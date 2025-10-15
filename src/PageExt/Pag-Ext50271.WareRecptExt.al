pageextension 50271 "Ware Recpt Ext" extends "Warehouse Receipts"
{
    layout
    {
        addafter("Assigned User ID")
        {
            field("Status"; Rec."Status")
            {
                ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                ApplicationArea = All;
            }
        }
    }
}
