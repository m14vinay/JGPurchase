pageextension 50292 "Posted Purch Recpt Line Ext" extends "Posted Purchase Receipt Lines"
{
    layout
    {
        addafter("Location Code")
        {
             field("Posting Date"; Rec."Posting Date")
             {
                ApplicationArea = All;
             }
        }
        modify("Order No.")
        {
            Visible = true;
        }
    }
}
