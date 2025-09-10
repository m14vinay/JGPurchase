pageextension 50263 "Whse Recept Ext" extends "Warehouse Receipt"
{
    layout{
        addafter("Vendor Shipment No.")
        {
         field("Vehicle No."; Rec."Vehicle No.")
            {
                ToolTip = 'Specifies Vehicle No.';
                ApplicationArea = All;
            }
            field("Vendor DO Date"; Rec."Vendor DO Date")
            {
                ToolTip = 'Specifies Vendor DO Date';
                ApplicationArea = All;
            }
            field("Transporter"; Rec.Transporter)
            {
                ToolTip = 'Specifies Transporter';
                ApplicationArea = All;
            }
            field("Remarks"; Rec.Remarks)
            {
                ToolTip = 'Specifies Remarks';
                ApplicationArea = All;
            }
        }
    }
    actions{
        addafter("&Print")
        {
             action("ItemLabel")
                {
                    ApplicationArea = All;
                    Caption = 'Item Label';
                    Image = Print;
                    ToolTip = 'Send the document to the archive and delete purchase order';
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                    WareRecprHdr : Record "Warehouse Receipt Header";
                    SetRecord : Codeunit "Subscriber";
                    begin
                        //CurrPage.SetSelectionFilter(WareRecprHdr);
                        SetRecord.SetWHseRecptHdr(Rec);
                        Report.RunModal(Report::"Item Label");
                    end;
                }
        }
    }
}
