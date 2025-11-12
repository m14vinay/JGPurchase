tableextension 50258 "Vendor Ext" extends Vendor
{
    fields
    {
        field(50251; "Purchase Category"; Code[20])
        {
            Caption = 'Purchase Category';
            DataClassification = CustomerContent;
            TableRelation = "Purchase Category";
        }
        field(50252; "Business Nature"; Text[100])
        {
            Caption = 'Business Nature';
            DataClassification = CustomerContent;
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'SST Bus. Posting Group';
        }
        modify("VAT Registration No.")
        {
            Caption = 'SST Registration No.';
        }
        modify("Prices Including VAT")
        {
            Caption = 'Prices Including SST';
        }
        modify("Phone No.")
        {
             trigger OnBeforeValidate()
            var
                c: Char;
                i: Integer;
            begin
                for i := 1 to StrLen("Phone No.") do begin
                    c := "Phone No."[i];
                    if c in ['A' .. 'Z', 'a' .. 'z','*','-','(',')'] then
                        FieldError("Phone No.", 'Phone number cannot contain letters or special characters.');
                end;
            end;
        }
         modify("Mobile Phone No.")
        {
             trigger OnBeforeValidate()
            var
                c: Char;
                i: Integer;
            begin
                for i := 1 to StrLen("Mobile Phone No.") do begin
                    c := "Mobile Phone No."[i];
                    if c in ['A' .. 'Z', 'a' .. 'z','*','-','(',')'] then
                        FieldError("Mobile Phone No.", 'Phone number cannot contain letters or special characters.');
                end;
            end;
        }
    }
}
