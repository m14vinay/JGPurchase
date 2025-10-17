pageextension 50273 "Purchase Return Shipment" extends "Posted Return Shipment"
{
    layout{
        addafter("No. Printed")
        {
              field("Vehicle No."; Rec."Vehicle No.")
            {
                ToolTip = 'Specifies Vehicle No.';
                ApplicationArea = All;
            }
             field("Transporter"; Rec.Transporter)
            {
                ToolTip = 'Specifies Transporter';
                ApplicationArea = All;
            }
        }
    }
}
