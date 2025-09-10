table 50256 "Purchase Category"
{
    Caption = 'Purchase Category';
    DataClassification = ToBeClassified;
    LookupPageId = "Purchase Category";
    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
