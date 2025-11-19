pageextension 50265 "Posted Purchase Receipts Ext" extends "Posted Purchase Receipts"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
