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
    actions
    {
        area(Processing)
        {
            action(FGItemLabel)
            {
                ApplicationArea = All;
                Caption = 'FG Item Label';
                Image = Report;
                Promoted = True;
                PromotedIsBig = True;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    MyReportID: Integer;
                    Filter: Record "FG Item Label";
                begin
                    MyReportID := Report::"FG Item Label";
                    CurrPage.SetSelectionFilter(Filter);
                    Report.RunModal(MyReportID, true, false, Filter);
                end;
            }
        }
    }
}
