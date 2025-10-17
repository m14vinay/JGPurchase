tableextension 50264 "Transfer Shipment Header Ext" extends "Transfer Shipment Header"
{
    fields
    {
        field(50251; "Supplier"; Text[50])
        {
            Caption = 'Supplier';
            DataClassification = CustomerContent;
        }
    }
}
