pageextension 50289 "Posted Purchase Cr Ext" extends "Posted Purchase Credit Memos"
{
    layout{
        modify("Amount Including VAT")
        {
            Caption = 'Amount Including SST';
        }
    }
}
