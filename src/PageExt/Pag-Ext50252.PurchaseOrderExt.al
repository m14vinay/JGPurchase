pageextension 50252 "Purchase Order Ext" extends "Purchase Order"
{
    layout
    {
        addafter(Status)
        {
            field("PR No."; Rec."PR No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies PR No.';
                Editable = false;
                TableRelation = "Purchase Request Header" where ("PO Created" = Filter(True));
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
        modify("Buy-from Vendor No.")
        {
            trigger OnBeforeValidate()
            begin
                If Rec."PR No." <> '' then 
                    Error('Supplier cannot be changed. PO created from PR');
            end;
        }
    }
    actions{
        addafter("Archive Document")
        {
             action("PO Short Close")
                {
                    ApplicationArea = All;
                    Caption = 'PO Short Close';
                    Image = Archive;
                    ToolTip = 'Send the document to the archive and delete purchase order';
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                    ArchiveManagement: Codeunit ArchiveManagement;
                
                    begin
                        ArchiveManagement.ArchivePurchDocument(Rec);
                        CurrPage.Update(false);
                        Rec.Delete(True);
                    end;
                }
        }
    }
    trigger OnAfterGetRecord()
    begin
        SpecialInstruction := Rec.GetSpecailInstruction();
    end;

    var
        SpecialInstruction: Text;
    
}
