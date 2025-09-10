page 50252 "Price Comparison Subform"
{
    ApplicationArea = All;
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Price Comparison Line";
    AutoSplitKey = True;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field(ItemDescription; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field("PR No."; Rec."PR No.")
                {
                    ToolTip = 'Specifies the value of the PR No. field.', Comment = '%';
                }
                field("Purchase Quote No."; Rec."Purchase Quote No.")
                {
                    ToolTip = 'Specifies the value of the Purchase Quote No. field.', Comment = '%';
                }
                field("Vendor no."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor no. field.', Comment = '%';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Unit Cost Excl SST"; Rec."Unit Cost Excl SST")
                {
                    ToolTip = 'Specifies the value of the Unit Cost Excl SST field.', Comment = '%';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ToolTip = 'Specifies the value of the Line Amount field.', Comment = '%';
                }
                field("Vendor Selected"; Rec."Vendor Selected")
                {
                    ToolTip = 'Specifies the value of the Vendor Selected field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(SelectVendor)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Select Vendor';
                Ellipsis = true;
                Image = SelectLineToApply;
                ToolTip = 'Will select the vendor for each item';
                trigger OnAction()
                var
                    PriceCompLine: Record "Price Comparison Line";
                    PriceCompLine1: Record "Price Comparison Line";
                    PriceCompHdr : Record "Price Comparison Header";
                    PriceCompLineSelected: Record "Price Comparison Line";
                    VendorSelected: Boolean;
                begin
                    If PriceCompHdr.Get(Rec."Document No.") then 
                    If PriceCompHdr.Status = PriceCompHdr.Status::Open then begin
                    CurrPage.SetSelectionFilter(PriceCompLine1);
                    PriceCompLine1.SetRange(Type, PriceCompLine1.Type::Item);
                    If PriceCompLine1.FindSet() then
                        repeat
                            VendorSelected := False;

                            PriceCompLine.Reset();
                            PriceCompLine.SetRange("Item No.", PriceCompLine1."Item No.");
                            PriceCompLine.SetRange("Document No.",PriceCompLine1."Document No.");
                            If PriceCompLine.FindSet() then
                                repeat
                                    If PriceCompLine."Vendor Selected" = True then
                                        VendorSelected := True;
                                until (PriceCompLine.Next = 0);
                            If not VendorSelected then begin
                                PriceCompLine1."Vendor Selected" := True;
                                PriceCompLine1.Modify();
                            end;
                            If VendorSelected then
                                If Confirm('Vendor already selected for the Item %1. Do you want to change the Vendor?', true, PriceCompLine1."Item No.") then begin
                                    PriceCompLineSelected.Reset();
                                    PriceCompLineSelected.SetRange("Item No.", PriceCompLine1."Item No.");
                                    PriceCompLineSelected.SetRange("Vendor Selected", True);
                                    If PriceCompLineSelected.FindSet() then
                                        repeat
                                            If not (PriceCompLine1."Line No." = PriceCompLineSelected."Line No.") then begin
                                                PriceCompLineSelected."Vendor Selected" := false;
                                                PriceCompLineSelected.Modify();
                                            end;
                                        until PriceCompLineSelected.Next() = 0;
                                    If not PriceCompLine1."Vendor Selected" then begin
                                        PriceCompLine1."Vendor Selected" := True;
                                        PriceCompLine1.Modify();
                                    end;
                                end;
                        until PriceCompLine1.Next() = 0;
                    end else 
                      Error('Status must be equal to open');
                end;
            }
        }
    }
    
    var 
    PriceComparisonHdr : Record "Price Comparison Header";

    PriceCompHdr : Record "Price Comparison Header";
    
}
