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
        modify("Phone No.")
        { 
            ShowMandatory = True;
        }
        modify("E-Mail")
        { 
            ShowMandatory = True;
        }
        modify("Primary Contact No.")
        { 
            ShowMandatory = True;
        }
        modify(MobilePhoneNo)
        { 
            ShowMandatory = True;
        }
          modify("VAT Bus. Posting Group")
        {
            Caption = 'SST Bus. Posting Group';
        }
         modify("VAT Registration No.")
        {
            Caption = 'SST Registration No.';
        }
         modify("Prices Including VAT")
        {
            Caption = 'Prices Including SST';
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
            action(SSTExemptionList)
            {
                ApplicationArea = All;
                Caption = 'Vendor SST Exemption Details';
                Image = VATExemption;
                ToolTip = 'SST Exemption Details';
                Promoted = true;
                PromotedCategory = Category9;
                RunObject = page "Vendor SST Exemption Details";
                RunPageLink = "Vendor No." = field("No.");
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
