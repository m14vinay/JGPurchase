pageextension 50285 "Blanket Purchase Order Ext" extends "Blanket Purchase Order"
{
    layout
    {
        modify("VAT Bus. Posting Group")
        {
          Caption = 'SST Bus. Posting Group';
        }
          modify("Prices Including VAT")
        {
          Caption = 'Prices Including SST';
        }
    }
}
