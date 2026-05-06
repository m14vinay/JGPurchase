table 50261 "Vendor SST Exemption Details"
{
    Caption = 'Vendor SST Exemption Details';
    DataClassification = CustomerContent;
    LookupPageId = "Vendor SST Exemption Details";
    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor."No.";
        }
        field(2; "SST Exemption Registration No."; Text[30])
        {
            Caption = 'SST Exemption Registration No.';
        }
        field(3; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
        }
        field(4; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
        }
        field(5; "SST Business Posting Group"; Code[20])
        {
            Caption = 'SST Business Posting Group';
            TableRelation = "VAT Business Posting Group".Code;
        }
    }
    keys
    {
        key(PK; "Vendor No.","SST Exemption Registration No.","Effective Date")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown;"Vendor No.","SST Exemption Registration No.","SST Business Posting Group","Effective Date"){}
    }
}