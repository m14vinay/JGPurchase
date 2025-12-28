tableextension 50254 "Purch Recpt Hdr Ext" extends "Purch. Rcpt. Header"
{
    fields
    {

        field(50251; "Special Instructions"; Blob)
        {
            Caption = 'Special Instructions';
            DataClassification = CustomerContent;
        }
        field(50254; "Incoterms"; Code[20])
        {
            Caption = 'Incoterms';
            DataClassification = CustomerContent;
        }
        field(50255; "Transporter"; Text[50])
        {
            Caption = 'Transporter';
            DataClassification = CustomerContent;
        }
        field(50256; "Vendor DO Date"; Date)
        {
            Caption = 'Vendor DO Date';
            DataClassification = CustomerContent;
        }
        field(50257; "Remarks"; Text[100])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(50258; "Vehicle No."; Text[20])
        {
            Caption = 'Vehicle No.';
            DataClassification = CustomerContent;
        }
        field(50261; "Inward Advise Note (IAN) No."; Integer)
        {
            Caption = 'Inward Advise Note (IAN) No.';
            DataClassification = CustomerContent;
        }
        field(50262; "Type of Purchase"; Code[20])
        {
            Caption = 'Type of Purchase';
            DataClassification = CustomerContent;
            TableRelation = "Type of Purchase".Code;
        }
         field(50263; "Finance Type"; Code[20])
        {
            Caption = 'Finance Type';
            DataClassification = CustomerContent;
            TableRelation = "Finance Type".Code;
        }
         field(50264; "Contract Type"; enum "Contract Type")
        {
            Caption = 'Contract Type';
            DataClassification = CustomerContent;
        }
        modify("VAT Base Discount %")
        {
            Caption = 'SST Base Discount %';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'SST Bus. Posting Group';
        }
        modify("VAT Country/Region Code")
        {
            Caption = 'SST Country/Region Code';
        }
        modify("VAT Registration No.")
        {
            Caption = 'SST Registration No.';
        }

    }
    procedure GetSpecialInstruction(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Special Instructions");
        "Special Instructions".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("Special Instructions")));
    end;
}
