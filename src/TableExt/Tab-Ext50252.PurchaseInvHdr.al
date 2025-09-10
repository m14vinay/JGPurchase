tableextension 50252 "Purchase Inv Hdr" extends "Purch. Inv. Header"
{
     fields
    {
        field(50251; "Special Instructions";Blob )
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
        TempBlob: Codeunit "Temp Blob";
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Special Instructions");
        "Special Instructions".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("Special Instructions")));
        /*TempBlob.FromRecord(Rec, FieldNo("Special Instructions"));
        TempBlob.CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("Special Instructions")));*/
    end;
}
