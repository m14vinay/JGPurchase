pageextension 50274 "Transfer Order Ext" extends "Transfer Order"
{
    layout{
        addafter("Assigned User ID")
        {
              field(Supplier; Rec.Supplier)
            {
                ToolTip = 'Specifies Supplier';
                ApplicationArea = All;
            }
        }
    }
}
