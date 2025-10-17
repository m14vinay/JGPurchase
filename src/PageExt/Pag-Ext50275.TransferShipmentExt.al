pageextension 50275 "Transfer Shipment Ext" extends "Posted Transfer Shipment"
{
    layout{
        addafter("Posting Date")
        {
              field(Supplier; Rec.Supplier)
            {
                ToolTip = 'Specifies Supplier';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
