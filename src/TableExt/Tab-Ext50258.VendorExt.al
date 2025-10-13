tableextension 50258 "Vendor Ext" extends Vendor
{
    fields
    {
        field(50251; "Purchase Category"; Code[20])
        {
            Caption = 'Purchase Category';
            DataClassification = CustomerContent;
            TableRelation = "Purchase Category";
        }
        field(50252; "Business Nature"; Text[100])
        {
            Caption = 'Business Nature';
            DataClassification = CustomerContent;
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
}
