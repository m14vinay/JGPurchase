page 50253 "Price Comparison List"
{
    ApplicationArea = All;
    Caption = 'Price Comparison List';
    PageType = List;
    SourceTable = "Price Comparison Header";
    UsageCategory = Lists;
    CardPageId = "Price Comparison";
    InsertAllowed = false;
    Editable = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("PR No."; Rec."PR No.")
                {
                    ToolTip = 'Specifies the value of the PR No. field.', Comment = '%';
                }
                field("Req Department"; Rec."Req Department")
                {
                    ToolTip = 'Specifies the value of the Req Department field.', Comment = '%';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date field.', Comment = '%';
                }
                field("Type of Item"; Rec."Type of Item")
                {
                    ToolTip = 'Specifies the value of the Type of Item field.', Comment = '%';
                }
                field("Type of Purchase"; Rec."Type of Purchase")
                {
                    ToolTip = 'Specifies the value of the Type of Purchase field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            group(Report)
            {
                action(PriceCompRep)
                {
                    ApplicationArea = All;
                    Caption = 'Price Comparison Report';
                    Image = Report;
                    Promoted = True;
                    PromotedCategory = Process;
                    ToolTip = 'View Price Compare Rep';
                    trigger OnAction()
                    var
                        PriceCompHdr: Record "Price Comparison Header";
                    begin
                        // Run the report with the filter applied
                        CurrPage.SetSelectionFilter(PriceCompHdr);
                        Report.RunModal(Report::"Price Comparison", true, false, PriceCompHdr);
                    end;
                }

            }
        }
    }
}
