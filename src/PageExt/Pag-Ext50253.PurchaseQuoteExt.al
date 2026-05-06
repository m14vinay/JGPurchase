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
                TableRelation = "Purchase Request Header"."No." where("PO Created" = const(false));
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
            field("Price Comparison Created"; Rec."Price Comparison Created")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies PR No.';
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
         addafter("VAT Bus. Posting Group")
        {
            field("SST Exemption registration No."; Rec."SST Exemption registration No.")
            {
                ToolTip = 'SST Exemption registration No.';
                ApplicationArea = All;
            }
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'SST Bus. Posting Group';
        }
        modify("Prices Including VAT")
        {
            Caption = 'Prices Including SST';
        }
         modify("Payment Terms Code")
        {
            ShowMandatory = True;
        }
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            var
            VendorRec : Record Vendor;
            begin
                If VendorRec.Get(Rec."Buy-from Vendor No.") then
                   VendorRec.TestField("Location Code");
            end;
        }

    }
    actions
    {
        addafter(CopyDocument)
        {
            action(CopyDoc)
            {
                ApplicationArea = Suite;
                Caption = 'Copy PR Lines';
                Image = Copy;
                Promoted = True;
                PromotedIsBig = True;
                PromotedCategory = Process;
                ToolTip = 'Copy PR line items into Purchase Quote';
                trigger OnAction()
                var
                    PurchaseRequest: Record "Purchase Request Line";
                    PurchaseLine : Record "Purchase Line";
                    PurchaseLineNo : Record "Purchase Line";
                begin
                    PurchaseRequest.Reset();
                    PurchaseRequest.SetRange("No.", Rec."PR No.");
                    If PurchaseRequest.FindSet() then
                        repeat
                           PurchaseLine.Init();
                           PurchaseLine."Document Type" := PurchaseLine."Document Type"::Quote;
                           PurchaseLine.Validate("Document No.", Rec."No.");
                           PurchaseLineNo.Reset();
                           PurchaseLineNo.SetAscending("Line No.",false);
                           PurchaseLineNo.SetRange("Document Type",PurchaseLineNo."Document Type"::Quote);
                           PurchaseLineNo.SetRange("Document No.",Rec."No.");
                           If PurchaseLineNo.FindFirst() then
                             PurchaseLine."Line No." := PurchaseLineNo."Line No." + 10000
                            else
                               PurchaseLine."Line No." := 10000;
                           PurchaseLine.Insert(True);
                           PurchaseLine.Validate(Type,PurchaseLine.Type::Item);
                           PurchaseLine.Validate("No.",PurchaseRequest."Item No.");
                           PurchaseLine.Validate("Unit of Measure Code",PurchaseRequest.UOM);
                           PurchaseLine.Validate(Quantity,PurchaseRequest.Quantity);
                           PurchaseLine.Modify();
                        until PurchaseRequest.Next() = 0;
                end;
            }
        }

    }

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
