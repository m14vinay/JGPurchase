tableextension 50256 "Purchase Hdr Archive Ext" extends "Purchase Header Archive"
{
    fields
    {
        field(50251; "Special Instructions"; Blob)
        {
            Caption = 'Special Instructions';
            DataClassification = CustomerContent;
        }
        field(50252; "PR No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PR No.';
        }
        field(50253; "Quote Valid Until Date"; Date)
        {
            Caption = 'Quote Valid To Date';
        }
         field(50254; "Incoterms"; Code[20])
        {
            Caption = 'Incoterms';
            DataClassification = CustomerContent;
            TableRelation = Incoterms;
        }
    }
    procedure GetSpecialInstruction() SpecialInstruction: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Special Instructions");
        "Special Instructions".CreateInStream(InStream, TextEncoding::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("Special Instructions")));
    end;

}
