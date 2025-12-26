pageextension 50277 "Purchase Quote" extends "Purchase Quote Subform"
{
    layout{
         modify("VAT Bus. Posting Group")
        {
            Caption = 'SST Bus. Posting Group';
        }
        modify("VAT Prod. Posting Group")
        {
            Caption = 'SST Prod. Posting Group';
            Editable = false;
        }
        modify("Total VAT Amount")
        {
            Caption = 'Total SST';
            CaptionClass = Rec.GetCaptionWithCurrencyCode('Total SST',Rec."Currency Code");
        }
        modify("Total Amount Excl. VAT")
        {
            Caption = 'Total Excl. SST';
            CaptionClass = Rec.GetCaptionWithCurrencyCode('Total Excl. SST',Rec."Currency Code");
        }
        modify("Total Amount Incl. VAT")
        {
            Caption = 'Total Incl. SST';
            CaptionClass = Rec.GetCaptionWithCurrencyCode('Total Incl. SST',Rec."Currency Code");
        }
         modify(AmountBeforeDiscount)
        {
            Caption = 'Subtotal Excl. SST';
            CaptionClass = Rec.GetCaptionWithCurrencyCode('Subtotal Excl. SST',Rec."Currency Code");
        }
    }
}
