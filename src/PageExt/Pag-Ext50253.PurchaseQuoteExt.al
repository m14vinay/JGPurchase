pageextension 50253 "Purchase Quote Ext" extends "Purchase Quote"
{
    layout
    {
        addafter(Status)
        {
            field("PR No."; Rec."PR No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies PR No.';
                TableRelation = "Purchase Request Header"."No." where(Status = Const(Released), "PO Created" = const(false));
                trigger OnValidate()
                begin
                    If Rec."PR No." <> '' then begin
                        PurchaseRequisitionHdr.Reset();
                        PurchaseRequisitionHdr.SetRange("No.", Rec."PR No.");
                        If PurchaseRequisitionHdr.FindFirst() then
                            Rec.Validate("Shortcut Dimension 1 Code", PurchaseRequisitionHdr."Shortcut Dimension 1 Code");
                    end;
                end;
            }
            field("Price Comparison No."; Rec."Price Comparison No.")
            {
                ApplicationArea = All;
                ToolTip = 'Price Comparison No.';
                Editable = false;
            }
            field("Quote Valid Until Date"; Rec."Quote Valid Until Date")
            {
                ApplicationArea = All;
                ToolTip = 'Quote Valid Until Date';
            }
            group("Special Instruction")
            {
                field(SpecialInstruction; SpecialInstruction)
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    MultiLine = true;
                    ShowCaption = false;
                    ToolTip = 'Specifies the products or service being offered.';

                    trigger OnValidate()
                    begin
                        Rec.SetSpecailInstruction(SpecialInstruction);
                    end;
                }
            }
        }
        addafter("Shipment Method Code")
        {
            field(Incoterms; Rec.Incoterms)
            {
                ToolTip = 'Specifies Incoterms';
                ApplicationArea = All;
            }

        }

    }
   /* actions
    {
        addafter("Archive Document")
        {
            action(UpadteDimensionPR)
            {
                ApplicationArea = Suite;
                Caption = 'Update PR Dimension';
                Image = Process;
                Promoted = True;
                PromotedIsBig = True;
                PromotedCategory = Category7;
                ToolTip = 'Update the Dimensions of Header and Lines';

                trigger OnAction()
                var
                    PurchaseRequisitionHdr: Record "Purchase Request Header";
                begin
                    If Rec."PR No." <> '' then begin
                        PurchaseRequisitionHdr.Reset();
                        PurchaseRequisitionHdr.SetRange("No.", Rec."PR No.");
                        If PurchaseRequisitionHdr.FindFirst() then
                            Rec.Validate("Shortcut Dimension 1 Code", PurchaseRequisitionHdr."Shortcut Dimension 1 Code");
                    end else
                        Error('PR No. should not be blank');

                end;
            }
        }
    }*/

    trigger OnAfterGetRecord()
    begin
        SpecialInstruction := Rec.GetSpecailInstruction();
    end;

    trigger OnOpenPage()
    begin
        If Rec."Document Type" = Rec."Document Type"::Quote then
            If Rec."Price Comparison Created" then
                CurrPage.Editable(false);
    end;


    var
        PurchaseRequisitionHdr: Record "Purchase Request Header";
        SpecialInstruction: Text;
        IsEditable: Boolean;
}
