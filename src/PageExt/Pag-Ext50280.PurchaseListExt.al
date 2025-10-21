pageextension 50280 "Purchase List Ext" extends "Purchase Order List"
{
    layout{
        modify("Amount Including VAT")
        {
            Caption = 'Amount Including SST';
        }
    }
}
