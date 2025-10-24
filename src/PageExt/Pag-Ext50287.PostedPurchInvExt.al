pageextension 50287 "Posted PurchInvExt" extends "Posted Purchase Invoices"
{
    layout{
        modify("Amount Including VAT")
        {
            Caption = 'Amount Including SST';
        }
    }
}
