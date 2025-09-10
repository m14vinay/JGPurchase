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
