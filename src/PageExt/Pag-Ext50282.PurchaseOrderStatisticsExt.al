pageextension 50282 "Purchase Order Statistics Ext" extends "Purchase Order Statistics"
{
    layout
    {
        modify("VATAmount[1]")
        {
            CaptionClass = 'SST Amount';
            Caption = 'SST Amount';
        }
         modify(VATAmount_Invoicing)
        {
            CaptionClass = 'SST Amount';
            Caption = 'SST Amount';
        }
         modify("VATAmount[3]")
        {
            CaptionClass = 'SST Amount';
            Caption = 'SST Amount';
        }
        modify(PrepmtVATAmount)
        {
            Caption = 'SST Amount';
            CaptionClass = 'SST Amount'; 
        }
         modify(TotalAmount1ACY)
        {
            Caption = 'Total excl. SST (ACY)';
        }
         modify(VATAmountACY)
        {
            Caption = 'SST Amount (ACY)';
        }
         modify(TotalAmount2ACY)
        {
            Caption = 'Total Incl. SST (ACY)';
        }
    }
    trigger OnAfterGetRecord()
    begin
        TotalExclSST := 'Total excl. SST (ACY)';
    end;
   
   var
   TotalExclSST : Text[30];
   TotalSSTACY : Label 'SST Amount (ACY)';
   TotalInclACY : Label 'Total Incl. SST (ACY)';
}
