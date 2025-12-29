table 50260 "Finance Type"
{
    Caption = 'Finance Type';
    DataClassification = CustomerContent;
    
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
