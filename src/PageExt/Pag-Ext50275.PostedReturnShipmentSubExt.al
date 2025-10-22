pageextension 50275 "Posted Return Shipment Sub Ext" extends "Posted Return Shipment Subform"
{
    
    layout{
        addafter(Quantity)
        {
            field(Returnable; Rec.Returnable)
            {
                ToolTip = 'Specifies Returnable';
                ApplicationArea = All;
                Editable = true;
            }
        }
         
    }
}
