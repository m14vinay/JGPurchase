table 50252 "Price Comparison Line"
{
    Caption = 'Price Comparison Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Purchase Quote No."; Code[20])
        {
            Caption = 'Purchase Quote No.';
            TableRelation = "Purchase Header"."No." where ("Document Type" = Const(Quote));
        }
        field(4; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(5; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
        }
        field(6; "PR No."; Code[20])
        {
            Caption = 'PR No.';
            TableRelation = "Purchase Request Header"."No.";
        }
        field(7; "Type"; Enum "Purchase Line Type")
        {
            Caption = 'Type';
        }
        field(8; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(9; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(10; "Unit Cost Excl SST"; Decimal)
        {
            Caption = 'Unit Cost Excl SST';
        }
        field(11; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
        }
        field(12; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(13; "Payment Terms Code"; Code[20])
        {
            Caption = 'Payment Terms Code';
        }
        field(14; "Delivery Date"; Date)
        {
            Caption = 'Delivery Date';
        }
        field(15; "Quote Valid Until Date"; Date)
        {
            Caption = 'Quote Valid Until Date';
        }
        field(16; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
        }
        field(17; "SST Amount"; Decimal)
        {
            Caption = 'SST Amount';
        }
        field(18; "Vendor Selected"; Boolean)
        {
            Caption = 'Vendor Selected';
        }
        field(19; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
        }
        field(20; "Purchase Line No."; Integer)
        {
            Caption = 'Purchase Line No.';
        }
        field(21; "Direct Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
        }
        field(22; Amount; Decimal)
        {
            Caption = 'Amount';
            Editable = false;
        }
        field(23; "Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT';
            Editable = false;
        }
         field(24; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(25; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
        field(26; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
        }
        field(27; "Purchase Quote Line No."; Integer)
        {
            Caption = 'Purchase Quote Line No.';
        }

    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Item No.")
        {
        }

    }
    var
        PriceComparisonHeader: Record "Price Comparison Header";

    procedure CheckStatusOpen()
    begin
        If PriceComparisonHeader.Get("Document No.") then
            PriceComparisonHeader.TestField(PriceComparisonHeader.Status, PriceComparisonHeader.Status::Open);
    end;
}
