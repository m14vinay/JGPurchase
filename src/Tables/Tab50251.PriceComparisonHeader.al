table 50251 "Price Comparison Header"
{
    Caption = 'Price Comparison Header';
    DataClassification = CustomerContent;
    LookupPageId = "Price Comparison List";
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = False;
        }
        field(2; "PR No."; Code[20])
        {
            Caption = 'PR No.';
            Editable = False;
            TableRelation = "Purchase Request Header"."No.";
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(3; "Req Department"; Code[20])
        {
            Caption = 'Req Department';
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(4; "Creation Date"; DateTime)
        {
            Caption = 'Creation Date';
            Editable = false;
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(5; Remarks; Text[100])
        {
            Caption = 'Remarks';
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(6; "Type of Item"; Enum "Type of Item")
        {
            DataClassification = CustomerContent;
            Caption = 'Type of Item';
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(7; "Type of Purchase"; Enum "Type of Purchase")
        {
            DataClassification = CustomerContent;
            Caption = 'Type of Purchase';
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(8; Status; Enum "Purchase Document Status")
        {
            Caption = 'Status';
            Editable = False;
        }
        field(9; "PO Created"; Boolean)
        {
           Caption = 'PO Created';
        }
    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "PR No.")
        {
        }
    }
     fieldgroups
    {
        fieldgroup(DropDown; "PR No.","No.", "Req Department")
        {
        }
    }
    var
    VendorSelectedEnabled : Boolean;
    procedure PriceCompLinesExist(): Boolean
    var
        PriceCompLine: Record "Price Comparison Line";
    begin
        PriceCompLine.Reset();
        PriceCompLine.ReadIsolation := IsolationLevel::ReadUncommitted;
        PriceCompLine.SetRange("Document No.", "No.");
        exit(not PriceCompLine.IsEmpty);
    end;
}
