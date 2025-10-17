tableextension 50263 "Transfer Header Ext" extends "Transfer Header"
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
