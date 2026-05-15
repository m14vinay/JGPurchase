tableextension 50259 "Purch Pay Setup Ext" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50251; "Price Comparison No."; Code[20])
        {
            Caption = 'Price Comparison No.';
            TableRelation = "No. Series";
        }
        field(50252; "Terms and Conditions Purchase"; Text[150])
        {
            Caption = 'Terms and Conditions Purchase';
            ExtendedDatatype = URL;
        }
        modify("Allow VAT Difference")
        {
            Caption = 'Allow SST Difference';
        }

    }
}
