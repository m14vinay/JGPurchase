pageextension 50281 "Purchase Return Ext" extends "Purchase Return Order"
{
    layout{
        modify("Prices Including VAT")
        {
            Caption = 'Prices Including SST';
        }
         modify("VAT Bus. Posting Group")
        {
            Caption = 'SST Bus. Posting Group';
        }
        modify("VAT Reporting Date")
        {
            Caption = 'SST Reporting Date';
        }
    }
}
