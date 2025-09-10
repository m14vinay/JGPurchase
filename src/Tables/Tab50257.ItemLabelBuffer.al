table 50257 "Item LabelBuffer"
{
    Caption = 'Item LabelBuffer';
    DataClassification = CustomerContent;
    TableType = Temporary;
    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No';
        }
        field(2; "Line No."; Integer)
        {
            
        }
        field(3; "Lot No.";Code[50] )
        {
        }
        field(4; Brand; Text[100])
        {
           
        }
        field(5; UOM; Code[20])
        {
            
        }
        field(6; Description; Text[100])
        {
            
        }
        field(7; Quantity; Decimal)
        {
            
        }
         field(8; "Whse Rcpt No"; Code[20])
        {
            
        }
         field(9; "Location Code"; Code[20])
        {
            
        }
         field(10; "Bin Code"; Code[20])
        {
            
        }
    }
    keys
    {
        key(PK; "Item No.","Line No.","Lot No.")
        {
            Clustered = true;
        }
    }
}
