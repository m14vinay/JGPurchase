pageextension 50262 "Posted Whse Recpt Ext" extends "Posted Whse. Receipt"
{
    layout
    {
        addafter("Whse. Receipt No.")
        {
            field("Vehicle No."; Rec."Vehicle No.")
            {
                ToolTip = 'Specifies Vehicle No.';
                ApplicationArea = All;
            }
            field("Vendor DO Date"; Rec."Vendor DO Date")
            {
                ToolTip = 'Specifies Vendor DO Date';
                ApplicationArea = All;
            }
            field("Transporter"; Rec.Transporter)
            {
                ToolTip = 'Specifies Transporter';
                ApplicationArea = All;
            }
            field("Remarks"; Rec.Remarks)
            {
                ToolTip = 'Specifies Remarks';
                ApplicationArea = All;
            }
        }
    }
}
