page 50256 "Purchase Request List"
{
    ApplicationArea = All;
    Caption = 'Purchase Request List';
    PageType = List;
    SourceTable = "Purchase Request Header";
    UsageCategory = Lists;
    CardPageId = "Purchase Request";
    DeleteAllowed = false;
    Editable = false;
    RefreshOnActivate = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.', Comment = '%';
                }
                field("Requested By"; Rec."Requested By")
                {
                    ToolTip = 'Specifies the value of the Requested By field.', Comment = '%';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }
     actions
    {
        area(Navigation)
        {
            group(Action12)
            {
                 action(PurchReqRep)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Request Report';
                    Image = Report;
                    Promoted = True;
                    PromotedCategory = Process;
                    ToolTip = 'Purchase Request Report';
                    trigger OnAction()
                    var
                        PurchReqHdr: Record "Purchase Request Header";
                    begin
                        // Run the report with the filter applied
                        CurrPage.SetSelectionFilter(PurchReqHdr);
                        Report.RunModal(Report::"Purchase Request", true, false, PurchReqHdr);
                    end;
                }
            }
        }
    }
    
    
}
