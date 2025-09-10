tableextension 50258 "Vendor Ext" extends Vendor
{
    fields
    {
        field(50251; "Purchase Category";Code[20] )
        {
            Caption = 'Purchase Category';
            DataClassification = CustomerContent;
            TableRelation = "Purchase Category";
        }
    }
}
