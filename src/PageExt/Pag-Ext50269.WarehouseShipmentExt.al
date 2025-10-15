pageextension 50270 "Warehouse Shipment Ext" extends "Warehouse Shipment"
{
    PromotedActionCategoriesML = ENU = 'Home,Prepare,Print/Send,Shipment,Print,Navigate,Test,Test2,Request Approve,Approve';
    layout
    {
        addafter(Status)
        {
            field("Approval Status"; Rec."Approval Status")
            {
                ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                ApplicationArea = All;
            }
        }

    }
    actions
    {
        modify("Post and &Print")
        {
            trigger OnBeforeAction()
            begin
                If not (Rec.Status = Rec.Status::Released) then
                    Error('Approval Status must be Released');
            end;
        }
        modify("P&ost Shipment")
        {
            trigger OnBeforeAction()
            begin
                If not (Rec.Status = Rec.Status::Released) then
                    Error('Approval Status must be Released');
            end;
        }
        addafter("&Print")
        {
            action(Release)
            {
                ApplicationArea = Suite;
                Caption = 'Approval Re&lease';
                Enabled = Rec."Approval Status" <> Rec."Approval Status"::Released;
                Image = ReleaseDoc;
                Promoted = True;
                PromotedIsBig = True;
                PromotedCategory = Process;
                ToolTip = 'Release the document to the next stage of processing. You must reopen the document before you can make changes to it.';

                trigger OnAction()
                var
                    CustomWorkFlow: Codeunit "Custom WorkFlow Mgt";
                begin
                    CustomWorkFlow.CheckWSManualRelease(Rec);
                    PerformManualRelease();
                end;
            }
            action(Reopen)
            {
                ApplicationArea = Suite;
                Caption = 'Approval Re&open';
                Enabled = Rec."Approval Status" <> Rec."Approval Status"::Open;
                Image = ReOpen;
                Promoted = True;
                PromotedIsBig = True;
                PromotedCategory = Process;
                ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed';

                trigger OnAction()
                var
                    ReleasePurchDoc: Codeunit "Release Purchase Document";
                begin
                    PerformManualReopen();
                end;
            }
            action(Approvals)
            {
                ApplicationArea = All;
                Caption = 'Approvals';
                Enabled = Rec."Approval Status" <> Rec."Approval Status"::Open;
                Image = Approvals;
                Promoted = True;
                PromotedCategory = Process;
                ToolTip = 'View approval requests';
                trigger OnAction()
                begin
                    ApprovalMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                end;
            }
        }
        addafter("P&osting")
        {
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = not OpenApprovalEntriesExist and CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = True;
                    PromotedCategory = Category9;
                    ToolTip = 'Send the approval request.';
                    trigger OnAction()
                    var
                        CustomWorkFlowMgt: Codeunit "Custom WorkFlow Mgt";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        If CustomWorkFlowMgt.CheckWSApprovalPossible(RecRef) then
                            CustomWorkFlowMgt.OnSendWSForApproval(RecRef);
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
                    PromotedCategory = Category9;
                    trigger OnAction()
                    var
                        CustomWorkFlowMgt: Codeunit "Custom WorkFlow Mgt";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        CustomWorkFlowMgt.OnCancelWSForApproval(RecRef);
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
                    PromotedCategory = Category10;
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
                    PromotedCategory = Category10;
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
                    PromotedCategory = Category10;
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
                    PromotedCategory = Category10;
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

    procedure PerformManualReopen()
    begin
        if Rec."Approval Status" = Rec."Approval Status"::"Pending Approval" then
            Error(Text003);
        if Rec."Approval Status" = Rec."Approval Status"::Open then
            exit;
        Rec."Approval Status" := Rec."Approval Status"::Open;
        Rec.Modify(true);
    end;

    procedure PerformManualRelease()
    begin
        if Rec."Approval Status" = Rec."Approval Status"::"Pending Approval" then
            Error(Text003);
        if Rec."Approval Status" <> Rec."Approval Status"::Released then begin
            Rec."Approval Status" := Rec."Approval Status"::Released;
            Commit();
        end;
    end;
}


