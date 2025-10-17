tableextension 50262 "Return Shipment Header Ext" extends "Return Shipment Header"
{
    fields
    {
        field(50255; "Transporter"; Text[50])
        {
            Caption = 'Transporter';
            DataClassification = CustomerContent;
        }
        field(50258; "Vehicle No."; Text[20])
        {
            Caption = 'Vehicle No.';
            DataClassification = CustomerContent;
        }
    }
}
