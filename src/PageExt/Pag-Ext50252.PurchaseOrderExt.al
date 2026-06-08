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
                TableRelation = "Purchase Request Header" where("PO Created" = Filter(True));
            }
            field("Quote Valid Until Date"; Rec."Quote Valid Until Date")
            {
                ApplicationArea = All;
                ToolTip = 'Quote Valid Until Date';
            }
             field("Type of Purchase"; Rec."Type of Purchase")
            {
                ApplicationArea = All;
                ToolTip = 'Type of Purchase';
                ShowMandatory = True;
            }
             field("Finance Type"; Rec."Finance Type")
            {
                ApplicationArea = All;
                ToolTip = 'Finance Type';
                ShowMandatory = True;
            }
             field("Contract Type"; Rec."Contract Type")
            {
                ApplicationArea = All;
                ToolTip = 'Contract Type';
                ShowMandatory = True;
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
        addafter("Remit-to Code")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
                ToolTip = 'Reason Code';
            }
        }
         addafter("VAT Bus. Posting Group")
        {
            field("SST Exemption registration No."; Rec."SST Exemption registration No.")
            {
                ToolTip = 'SST Exemption registration No.';
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
            trigger OnAfterValidate()
            begin
                Rec."Location Code" := '';
            end;
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'SST Bus. Posting Group';
        }
        modify("VAT Reporting Date")
        {
            Caption = 'SST Reporting Date';
        }
        modify("Prices Including VAT")
        {
            Caption = 'Prices Including SST';
        }
        modify("Purchaser Code")
        {
            ShowMandatory = True;
        }
        modify("No.")
        {
            Editable = false;
        }
        modify("Payment Terms Code")
        {
            ShowMandatory = True;
        }
    }
    actions
    {
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
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            var
                PurchLine: Record "Purchase Line";
            begin
                Rec.TestField("Purchaser Code");
                PurchLine.Reset();
                PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                PurchLine.SetRange("Document No.", Rec."No.");
                PurchLine.SetFilter(Type, '%1', PurchLine.Type::Item);
                If PurchLine.FindSet() then
                    repeat
                        PurchLine.TestField("Unit of Measure Code");
                        PurchLine.TestField("Location Code");
                        PurchLine.TestField("Direct Unit Cost");
                    until PurchLine.Next() = 0;
            end;
        }
        modify(Reopen)
        {
            trigger OnBeforeAction()
            var
                UserSetup: Record "User Setup";
            begin
                If UserSetup.Get(UserId) then
                  If UserSetup."Shortcut Dimension 1 Code" <> 'PUR' then
                     Error('Only Purchasing team allowed to ReOpen');
            end;
        }
    }
    trigger OnAfterGetRecord()
    begin
        SpecialInstruction := Rec.GetSpecailInstruction();
    end;
     
    var
        SpecialInstruction: Text;

}
