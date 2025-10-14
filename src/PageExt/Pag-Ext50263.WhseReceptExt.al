pageextension 50263 "Whse Recept Ext" extends "Warehouse Receipt"
{
    layout
    {
        addafter("Vendor Shipment No.")
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
                MultiLine = True;
            }
            field("Inward Advise Note (IAN) No."; Rec."Inward Advise Note (IAN) No.")
            {
                ToolTip = 'Specifies Inward Advise Note (IAN) No.';
                ApplicationArea = All;
                BlankZero = true;
            }
        }
    }
    actions
    {
        addafter("&Print")
        {
            action("ItemLabel")
            {
                ApplicationArea = All;
                Caption = 'Item Label';
                Image = Print;
                ToolTip = 'Send the document to the archive and delete purchase order';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    WareRecprHdr: Record "Warehouse Receipt Header";
                    SetRecord: Codeunit "Subscriber";
                begin
                    //CurrPage.SetSelectionFilter(WareRecprHdr);
                    SetRecord.SetWHseRecptHdr(Rec);
                    Report.RunModal(Report::"Item Label");
                end;
            }
            group("Request Approval")
            {
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = not OpenApprovalEntriesExist and CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = True;
                    PromotedCategory = Category5;
                    ToolTip = 'Send the approval request.';
                    trigger OnAction()
                    var
                        CustomWorkFlowMgt: Codeunit "Custom WorkFlow Mgt";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        If CustomWorkFlowMgt.CheckWRApprovalPossible(RecRef) then
                            CustomWorkFlowMgt.OnSendWRForApproval(RecRef);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord or CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    ToolTip = 'Cancel the approval request.';
                    Promoted = True;
                    PromotedCategory = Category5;
                    trigger OnAction()
                    var
                        CustomWorkFlowMgt: Codeunit "Custom WorkFlow Mgt";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        CustomWorkFlowMgt.OnCancelWRForApproval(RecRef);
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = All;
                    Caption = 'Approvals';
                    Enabled = Rec.Status <> Rec.Status::Open;
                    Image = Approvals;
                    Promoted = True;
                    PromotedCategory = New;
                    ToolTip = 'View approval requests';
                    trigger OnAction()
                    begin
                        ApprovalMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';

                action(Approve)
                {
                    ApplicationArea = Suite;
                    Caption = 'Approve';
                    Image = Approve;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    Promoted = True;
                    PromotedCategory = Category4;
                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Suite;
                    Caption = 'Reject';
                    Image = Reject;
                    ToolTip = 'Reject the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    Promoted = True;
                    PromotedCategory = Category4;
                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Delegate';
                    Image = Delegate;
                    ToolTip = 'Delegate the requested changes to the substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    Promoted = True;
                    PromotedCategory = Category4;
                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = Suite;
                    Caption = 'Comments';
                    Image = ViewComments;
                    ToolTip = 'View or add comments for the record.';
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    Promoted = True;
                    PromotedCategory = Category4;
                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
        }

    }
    var
        ApprovalMgmt: Codeunit "Approvals Mgmt.";
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        CanCancelApprovalForRecord: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        Text003: Label 'The approval process must be cancelled or completed to reopen this document.';

    trigger OnAfterGetCurrRecord()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId());
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId());
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId());
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RecordId(), CanRequestApprovalForFlow, CanCancelApprovalForFlow);


    end;
}
