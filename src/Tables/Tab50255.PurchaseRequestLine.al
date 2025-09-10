table 50255 "Purchase Request Line"
{
    Caption = 'Purchase Request Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Line No"; Integer)
        {
            Caption = 'Line No';
        }
        field(3; "Date"; Date)
        {
            Caption = 'Date';
            Editable = false;
             trigger OnValidate()
            begin
                CheckStatusOpen();
            end;
        }
        field(4; "Requested By"; Text[80])
        {
            Caption = 'Requested By';
            Editable = false;
             trigger OnValidate()
            begin
                CheckStatusOpen();
            end;
        }
        field(5; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            trigger OnValidate()
            var
                Item: Record Item;
            begin
                CheckStatusOpen();
                If Item.Get("Item No.") then
                    Description := Item.Description;
                UOM := Item."Base Unit of Measure";
            end;
        }
        field(6; Description; Text[100])
        {
            Caption = 'Description';
             trigger OnValidate()
            begin
                CheckStatusOpen();
            end;
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';
            trigger OnValidate()
            begin
                CheckStatusOpen();
            end;
        }
        field(8; UOM; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure".Code;
            trigger OnValidate()
            begin
                CheckStatusOpen();
            end;
        }
        field(9; "Need Date"; Date)
        {
            Caption = 'Need Date';
            trigger OnValidate()
            begin
                CheckStatusOpen();
            end;
        }
        field(10; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            TableRelation = "Purchase Header"."No." where ("Document Type" = Const(Order));
        }
        field(11; "Purchase Line No."; Integer)
        {
            Caption = 'Purchase Line No.';
        }
    }
    keys
    {
        key(PK; "No.", "Line No")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()

    begin
        CheckStatusOpen();
        If PurchReqHeader.Get("No.") then begin
            PurchReqHeader.TestField(PurchReqHeader.Status, PurchReqHeader.Status::Open);
            rec."Requested By" := PurchReqHeader."Requested By";
            Rec.Date := PurchReqHeader.Date;
        end;
    end;
    trigger OnDelete()
    begin
        CheckStatusOpen();
    end;

    procedure CheckStatusOpen()
    begin
        If PurchReqHeader.Get("No.") then
            PurchReqHeader.TestField(PurchReqHeader.Status, PurchReqHeader.Status::Open);
    end;

    var
        PurchReqHeader: Record "Purchase Request Header";

}
