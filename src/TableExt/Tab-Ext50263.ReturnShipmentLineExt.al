tableextension 50263 "Return Shipment Line Ext" extends "Return Shipment Line"
{
    fields
    {
        field(50263; "Returnable"; Boolean)
        {
            Caption = 'Returnable';
            DataClassification = CustomerContent;
        }
    }
}
