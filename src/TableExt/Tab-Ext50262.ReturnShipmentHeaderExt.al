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
        field(50266; "SST Exemption Registration No."; Text[30])
        {
            Caption = 'SST Exemption Registration No.';
            DataClassification = CustomerContent;
            TableRelation = "Vendor SST Exemption Details"."SST Exemption Registration No." where("Vendor No." = field("Buy-from Vendor No."));
        }
    }
}
