table 50253 "PR Department Mapping"
{
    Caption = 'PR Department Mapping';
    DataClassification = CustomerContent;
    
    fields
    {
       field(1; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));

        }
        field(2; "Purchase Request No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }
    keys
    {
        key(PK; "Shortcut Dimension 1 Code")
        {
            Clustered = true;
        }
    }
}
