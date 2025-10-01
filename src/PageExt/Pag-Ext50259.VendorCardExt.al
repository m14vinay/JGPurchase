pageextension 50259 "Vendor Card Ext" extends "Vendor Card"
{
    layout
    {
        modify(Blocked)
        {
            Editable = false;
        }
        addafter("Search Name")
        {
            field("Business Nature"; Rec."Business Nature")
            {
                ToolTip = 'Specifies Business Nature';
                ApplicationArea = All;
            }
            field("Purchase Category"; Rec."Purchase Category")
            {
                Caption = 'Purchase Category';
                ToolTip = 'Specifies Purchase Category';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            var
                DocumentAttachment: Record "Document Attachment";
                RecordID: RecordId;
            begin

                RecordID := Rec.RecordId;

                DocumentAttachment.Reset();
                DocumentAttachment.SetRange("Table ID", RecordID.TableNo);
                DocumentAttachment.SetRange("No.", Rec."No.");
                if DocumentAttachment.IsEmpty then
                    Message('Has the relevant vendor related documents been uploaded?');
            end;

        }
        addafter("Item References")
        {
            action(BlockItem)
            {
                ApplicationArea = All;
                Caption = 'Block Vendor';
                Image = Cancel;
                ToolTip = 'Blocks the Vendor';
                Promoted = true;
                PromotedCategory = Category9;
                trigger OnAction()
                begin
                    Rec.Blocked := Rec.Blocked::All;
                end;
            }
        }
        modify(Approve)
        {
            trigger OnAfterAction()
            begin
                Rec.Blocked := Rec.Blocked::" ";
            end;
        }
    }

    /*trigger OnAfterGetRecord()
    var
        vendorcard: page "Vendor Card";
    begin
        if Rec.Blocked = Rec.Blocked::All then begin
            vendorcard.SetRecord(Rec);
            vendorcard.Editable := true;
        end else begin
            vendorcard.SetRecord(Rec);
            vendorcard.Editable := false;
        end;
        // page is editable otherwise 
    end;

    trigger OnOpenPage()
    begin
        if Rec.Blocked = Rec.Blocked::" " then
            CurrPage.Editable(false);
    end;*/


}
