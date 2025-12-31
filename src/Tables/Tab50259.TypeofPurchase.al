table 50259 "Type of Purchase"
{
    Caption = 'Type of Purchase';
    DataClassification = CustomerContent;
    LookupPageId = "Type of Purchase";
    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[80])
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
     fieldgroups
    {
        fieldgroup(DropDown; Code,Description)
        {
        }
    }
}
