page 50260 "FG Item Label"
{
    ApplicationArea = All;
    Caption = 'FG Item Label';
    PageType = List;
    SourceTable = "FG Item Label";
    UsageCategory = Lists;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Pack Size"; Rec."Pack Size")
                {
                    ToolTip = 'Specifies the value of the Pack Size field.', Comment = '%';
                }
                field("Production Date"; Rec."Production Date")
                {
                    ToolTip = 'Specifies the value of the Production Date field.', Comment = '%';
                }
                field("Recording Slip No"; Rec."Recording Slip No")
                {
                    ToolTip = 'Specifies the value of the Recording Slip No field.', Comment = '%';
                }
            }
        }
    }
}
