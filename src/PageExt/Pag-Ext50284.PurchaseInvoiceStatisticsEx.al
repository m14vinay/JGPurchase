pageextension 50284 "Purchase Invoice Statistics Ex" extends "Purchase Invoice Statistics"
{
    layout{
      modify(AmountInclVAT)
         {
            Caption = 'Total Incl. SST';
         }
           modify(VATAmount)
         {
            Caption = 'SST Amount';
            CaptionClass = 'SST Amount';
         }
    }
}
