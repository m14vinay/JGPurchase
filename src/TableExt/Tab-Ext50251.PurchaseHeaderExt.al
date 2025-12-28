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
            //TableRelation = "Purchase Request Header"."No.";
            TableRelation = "Purchase Request Header"."No." where (Status = Const(Released));
        }
        field(50253; "Quote Valid Until Date"; Date)
        {
            Caption = 'Quote Valid To Date';
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
            TableRelation = "Price Comparison Header"."No.";
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
        modify("VAT Reporting Date")
        {
            Caption = 'SST Reporting Date';
        }
        modify("Doc. Amount VAT")
        {
            Caption = 'Doc. Amount SST';
        }
        modify("Amount Including VAT")
        {
             Caption = 'Amount Including SST';
        }
        modify("Prices Including VAT")
        {
            Caption = 'Prices Including SST';
        }
        modify("Doc. Amount Incl. VAT")
        {
            Caption = 'Doc. Amount Incl. SST';
        }
        modify("A. Rcd. Not Inv. Ex. VAT (LCY)")
        {
            Caption = 'A. Rcd. Not Inv. Ex. SST (LCY)';
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

    trigger OnBeforeDelete()
    begin
        If Rec."Document Type" = Rec."Document Type"::Quote then
            If Rec."Price Comparison No." <> '' then
                Error('Price Comparison %1 exists for the Quote', Rec."Price Comparison No.");
    end;
}
