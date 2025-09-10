tableextension 50253 "Purch CrMemo Hdr Ext" extends "Purch. Cr. Memo Hdr."
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
