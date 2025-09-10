page 50254 "PR Department Mapping"
{
    ApplicationArea = All;
    Caption = 'PR Department Mapping';
    PageType = List;
    SourceTable = "PR Department Mapping";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.', Comment = '%';
                }
                field("Purchase Request No."; Rec."Purchase Request No.")
                {
                    ToolTip = 'Specifies the value of the Purchase Request No. field.', Comment = '%';
                }
            }
        }
    }
}
