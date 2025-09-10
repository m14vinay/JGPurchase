tableextension 50251 "Purchase Header Ext" extends "Purchase Header"
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
            //TableRelation = "Purchase Request Header"."No." where (Status = Const(Released), "PO Created" = const(false));
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
        field(50259; "Price Comparison Created"; Boolean)
        {
            Caption = 'Price Comparison Created';
            DataClassification = CustomerContent;
        }
        field(50260; "Price Comparison No."; Code[20])
        {
            Caption = 'Price Comparison No.';
            DataClassification = CustomerContent;
        }
       
    }
    procedure SetSpecailInstruction(NewSpecialInstruction: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Special Instructions");
        "Special Instructions".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewSpecialInstruction);
        Modify();
    end;

    procedure GetSpecailInstruction() SpecialInstruction: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Special Instructions");
        "Special Instructions".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("Special Instructions")));
    end;
}
