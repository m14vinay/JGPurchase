table 50258 "FG Item Label"
{
    Caption = 'FG Item Label';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            AutoIncrement = true;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
             TableRelation = Item."No.";
            trigger OnValidate()
            var
            ItemRec : Record Item;
            begin
               If ItemRec.Get("Item No.") then begin
                  Description := ItemRec.Description;
                  "Pack Size" := ItemRec."Pack Size";
               end;
            end;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Pack Size"; Code[20])
        {
            Caption = 'Pack Size';
        }
        field(5; "Production Date"; Date)
        {
            Caption = 'Production Date';
        }
        field(6; "Recording Slip No"; Integer)
        {
            Caption = 'Recording Slip No';
        }
    }
    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }
}
