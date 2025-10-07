pageextension 50267 "Vendor List Ext" extends "Vendor List"
{
    layout
    {
        addafter("Search Name")
        {
            field("Business Nature"; Rec."Business Nature")
            {
                ToolTip = 'Specifies Business Nature';
                ApplicationArea = All;
            }
            field("Purchase Category"; Rec."Purchase Category")
            {
                Caption = 'Purchase Category';
                ToolTip = 'Specifies Purchase Category';
                ApplicationArea = All;
            }
        }
}
}
