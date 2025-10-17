pageextension 50274 "Purchase Return Line Ext" extends "Purchase Return Order Subform"
{
    layout{
        addafter(Quantity)
        {
            field(Returnable; Rec.Returnable)
            {
                ToolTip = 'Specifies Returnable';
                ApplicationArea = All;
            }
        }
    }
}
