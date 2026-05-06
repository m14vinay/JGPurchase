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
        field(50266; "SST Exemption Registration No."; Text[30])
        {
            Caption = 'SST Exemption Registration No.';
            DataClassification = CustomerContent;
            TableRelation = "Vendor SST Exemption Details"."SST Exemption Registration No." where("Vendor No." = field("Buy-from Vendor No."));
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
        modify("VAT Reporting Date")
        {
            Caption = 'SST Reporting Date';
        }
        modify("Amount Including VAT")
        {
             Caption = 'Amount Including SST';
        }
        modify("Prices Including VAT")
        {
            Caption = 'Prices Including SST';
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
