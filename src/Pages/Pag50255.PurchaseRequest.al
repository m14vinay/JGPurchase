page 50255 "Purchase Request"
{
    ApplicationArea = All;
    Caption = 'Purchase Request';
    PageType = Document;
    SourceTable = "Purchase Request Header";
    RefreshOnActivate = true;
    PromotedActionCategoriesML = ENU='Home,Process,Report,Approve,Request Approve';
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                    Editable = false;
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.', Comment = '%';
                    Editable = false;
                }
                field("Requested By"; Rec."Requested By")
                {
                    ToolTip = 'Specifies the value of the Requested By field.', Comment = '%';
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.', Comment = '%';
                    Editable = false;
                }
                 field("Assigned To"; Rec."Assigned To")
                {
                    ToolTip = 'Specifies the value of the Assigned To field.', Comment = '%';
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                    MultiLine = True;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
            part(PurchaseRequestLine; "Purchase Request Subform")
            {
                ApplicationArea = Basic, Suite;
                Editable = true;
                Enabled = true;
                SubPageLink = "No." = field("No.");
                UpdatePropagation = Both;
            }
        }
        area(FactBoxes)
        {
            part(Control5; "Purchase Request FactBox")
            {
                ApplicationArea = Suite;
                Provider = PurchaseRequestLine;
                SubPageLink = "No." = field("No."),
                              "Line No" = field("Line No");
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            group(Action12)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&lease';
                    Enabled = Rec.Status <> Rec.Status::Released;
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    Promoted = True;
                    PromotedIsBig = True;
                    PromotedCategory = New;
                    ToolTip = 'Release the document to the next stage of processing. You must reopen the document before you can make changes to it.';

                    trigger OnAction()
                    begin
                        PerformManualRelease(Rec);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&open';
                    Enabled = Rec.Status <> Rec.Status::Open;
                    Image = ReOpen;
                    Promoted = True;
                    PromotedIsBig = True;
                    PromotedCategory = New;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed';

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        PerformManualReopen(Rec);
                    end;
                }
                action(CreatePO)
                {
                    ApplicationArea = Suite;
                    Caption = 'Create PO';
                    Enabled = (Rec.Status = Rec.Status::Released) and (Rec.Type = Rec.Type::Bulk);
                    Image = MakeOrder;
                    Promoted = True;
                    PromotedIsBig = True;
                    PromotedCategory = New;
                    ToolTip = 'Create Purchase Order';

                    trigger OnAction()
                    begin
                        CreatePurchaseOrder();
                    end;
                }
                action(PurchReqRep)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Request Report';
                    Image = Report;
                    Promoted = True;
                    PromotedCategory = Report;
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
        Area(Processing)
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
                    PromotedCategory = Category5;
                    ToolTip = 'Send the approval request.';
                    trigger OnAction()
                    var
                        CustomWorkFlowMgt: Codeunit "Custom WorkFlow Mgt";
                        RecRef: RecordRef;
                        PurchReqLine: Record "Purchase Request Line";
                    begin
                        CheckNeedDate();
                        RecRef.GetTable(Rec);
                        If CustomWorkFlowMgt.CheckPurchaseRequestApprovalPossible(RecRef) then
                            CustomWorkFlowMgt.OnSendPurchReqForApproval(RecRef);
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
                        CustomWorkFlowMgt.OnCancelPurchReqForApproval(RecRef);
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

    procedure PerformManualReopen(var PurchReqHeader: Record "Purchase Request Header")
    begin
        if PurchReqHeader.Status = PurchReqHeader.Status::"Pending Approval" then
            Error(MsgText003);
        if PurchReqHeader.Status = PurchReqHeader.Status::Open then
            exit;
        PurchReqHeader.Status := PurchReqHeader.Status::Open;
        PurchReqHeader.Modify(true);
    end;

    procedure PerformManualRelease(PurchHeader: Record "Purchase Request Header")
    var
        CustomWorkflowMgt: Codeunit "Custom WorkFlow Mgt";
    begin
        CustomWorkflowMgt.CheckPRManualRelease(PurchHeader);
        if Rec.Status = Rec.Status::"Pending Approval" then
            Error(MsgText003);
        if Rec.Status <> Rec.Status::Released then begin
            Rec.Status := Rec.Status::Released;
            Commit();
        end;
    end;


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

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        UserSetup: Record "User Setup";
        PRDepartment: Record "PR Department Mapping";
        NoSeries: Codeunit "No. Series";
    begin
        
        If UserSetup.Get(UserId) then
            If PRDepartment.Get(UserSetup."Shortcut Dimension 1 Code") then
                Rec."No." := NoSeries.PeekNextNo(PRDepartment."Purchase Request No.")
            Else
                Error('No Series setup is not availbale for PR Department');
        Rec."Requested By" := UserSetup."User ID";
        Rec."Shortcut Dimension 1 Code" := UserSetup."Shortcut Dimension 1 Code";
        Rec.Date := System.Today();
        
    end;
    procedure CheckNeedDate()
    var
        PurchReqLine: Record "Purchase Request Line";
    begin
        PurchReqLine.Reset();
        PurchReqLine.SetRange("No.", Rec."No.");
        If PurchReqLine.FindSet() then
            repeat
                PurchReqLine.TestField("Need Date");
            until PurchReqLine.Next() = 0;
    end;

    procedure CreatePurchaseOrder()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchLineTemp: Record "Purchase Line" temporary;
        PurchLine: Record "Purchase Line";
        PurchaseReqLine: Record "Purchase Request Line";
        NoSeries: Codeunit "No. Series";
        PurchSetup: Record "Purchases & Payables Setup";
        Item: Record Item;
        PurchPrice: Record "Purchase Price";
        CreatePO: Boolean;
    begin
        If Rec."PO Created" then
            If Confirm('PO already created for the PR %1. Do you want to Continue?', true, Rec."No.") then
                CreatePO := True;

        If not (Rec."PO Created") or CreatePO then begin
            PurchSetup.Get();
            PurchaseReqLine.Reset();
            PurchaseReqLine.SetRange("No.", Rec."No.");
            If PurchaseReqLine.FindSet() then
                repeat
                    If Item.Get(PurchaseReqLine."Item No.") then;
                    Item.TestField("Vendor No.");
                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
                    PurchaseHeader.SetRange("Buy-from Vendor No.", Item."Vendor No.");
                    PurchaseHeader.SetRange("PR No.", PurchaseReqLine."No.");
                    If not PurchaseHeader.FindFirst() then begin
                        PurchaseHeader.InitRecord();
                        PurchaseHeader.Validate("Document Type", PurchaseHeader."Document Type"::Order);
                        PurchaseHeader.Validate("No.", NoSeries.GetNextNo(PurchSetup."Order Nos."));
                        PurchaseHeader.Insert(True);
                        PurchaseHeader.Validate("Buy-from Vendor No.", Item."Vendor No.");
                        PurchaseHeader."PR No." := PurchaseReqLine."No.";
                        PurchaseHeader.Modify();
                    end;
                    PurchaseLine.Reset();
                    PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                    PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                    PurchaseLine.SetRange("No.", PurchaseReqLine."Item No.");
                    If not PurchaseLine.FindFirst() then begin
                        PurchaseLine.InitHeaderDefaults(PurchaseHeader, PurchLineTemp);
                        PurchaseLine.Validate("Document Type", PurchaseLine."Document Type"::Order);
                        PurchaseLine.Validate("Document No.", PurchaseHeader."No.");
                        PurchLine.Reset();
                        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                        PurchLine.SetRange("Document No.", PurchaseHeader."No.");
                        PurchLine.SetAscending("Line No.", false);
                        If PurchLine.FindFirst() then
                            PurchaseLine."Line No." := PurchLine."Line No." + 10000
                        else
                            PurchaseLine."Line No." := 10000;
                        PurchaseLine.Insert(True);
                    end;
                    PurchaseLine.Validate(Type, PurchaseLine.Type::Item);
                    PurchaseLine.Validate("No.", PurchaseReqLine."Item No.");
                    PurchaseLine.Validate(Quantity, PurchaseReqLine.Quantity);
                    PurchPrice.Reset();
                    PurchPrice.SetRange("Item No.", PurchaseReqLine."Item No.");
                    PurchPrice.SetRange("Vendor No.", Item."Vendor No.");
                    PurchPrice.SetRange("Starting Date", 0D, PurchaseHeader."Order Date");
                    If PurchPrice.FindFirst() then;
                    PurchaseLine.Validate("Direct Unit Cost", PurchPrice."Direct Unit Cost");
                    PurchaseLine."Purchase Request No." := PurchaseReqLine."No.";
                    PurchaseLine."Purchase Request Line No." := PurchaseReqLine."Line No";
                    PurchaseLine."Unit of Measure Code" := PurchPrice."Unit of Measure Code";
                    PurchaseReqLine."Purchase Order No." := PurchaseHeader."No.";
                    PurchaseReqLine."Purchase Line No." := PurchaseLine."Line No.";
                    PurchaseLine.Validate("Expected Receipt Date", PurchaseReqLine."Need Date");
                    PurchaseLine.Modify();
                    PurchaseReqLine.Modify();
                until PurchaseReqLine.Next() = 0;
            Rec."PO Created" := True;
            Rec.Modify();
            Message('Purchase Order Created');
        end;


    end;

    var
        ApprovalMgmt: Codeunit "Approvals Mgmt.";
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        CanCancelApprovalForRecord: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        MsgText003: Label 'The approval process must be cancelled or completed to reopen this document.';

}