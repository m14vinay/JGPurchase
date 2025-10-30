pageextension 50284 "Purchase Statistics Ext" extends "Purchase Statistics"
{
    layout{
        modify(VATAmount)
        {
            Caption = 'SST Amount';
            CaptionClass = 'SST Amount';
        }
    }
}
