codeunit 50251 "Custom WorkFlow Mgt"
{
    procedure CheckPriceComparisonApprovalPossible(var RecRef: RecordRef): Boolean
    var
        IsHandled: Boolean;
        ShowNothingToApproveError: Boolean;
        PriceCompHdr: Record "Price Comparison Header";
    begin
        if not WorkflowManagement.CanExecuteWorkflow(RecRef, GetWorkFlowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef)) then
            Error(NoWorkflowEnabledErr);
        RecRef.SetTable(PriceCompHdr);
        ShowNothingToApproveError := not PriceCompHdr.PriceCompLinesExist();

        if ShowNothingToApproveError then
            Error(NothingToApproveErr);



        exit(true);
    end;
    procedure CheckPRManualRelease(var PurchReqHdr : Record "Purchase Request Header")
    var 
    WorkFlowMgmt : Codeunit "Workflow Management";
    WorkflowEventHandling: Codeunit "Workflow Event Handling";
    CustomApproval : Codeunit "Custom WorkFlow Mgt";
    WorkflowCode : Code[128];
    RecRef: RecordRef;
    Text002: Label 'This document can only be released when the approval process is complete.';
    begin
         RecRef.GetTable(PurchReqHdr);
        If WorkflowManagement.CanExecuteWorkflow(RecRef, GetWorkFlowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef)) then
            Error(Text002);
    end;
    procedure CheckPCManualRelease(var PriceComp : Record "Price Comparison Header")
    var 
    WorkFlowMgmt : Codeunit "Workflow Management";
    WorkflowEventHandling: Codeunit "Workflow Event Handling";
    CustomApproval : Codeunit "Custom WorkFlow Mgt";
    WorkflowCode : Code[128];
    RecRef: RecordRef;
    Text002: Label 'This document can only be released when the approval process is complete.';
    begin
         RecRef.GetTable(PriceComp);
        If WorkflowManagement.CanExecuteWorkflow(RecRef, GetWorkFlowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef)) then
            Error(Text002);
    end;

    procedure CheckPurchaseRequestApprovalPossible(var RecRef: RecordRef): Boolean
    var
        ShowNothingToApproveError: Boolean;
        PurchReqHdr: Record "Purchase Request Header";
    begin
        if not WorkflowManagement.CanExecuteWorkflow(RecRef, GetWorkFlowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef)) then
            Error(NoWorkflowEnabledErr);
        RecRef.SetTable(PurchReqHdr);
        ShowNothingToApproveError := not PurchReqHdr.PurchReqLineExist();

        if ShowNothingToApproveError then
            Error(NothingToApproveErr);
        exit(true);
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendPriceCompForApproval(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPriceCompForApproval(var RecRef: RecordRef)
    begin
    end;
     [IntegrationEvent(false, false)]
    procedure OnSendPurchReqForApproval(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPurchReqForApproval(var RecRef: RecordRef)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", OnAddWorkflowEventsToLibrary, '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    var
        RecRef: RecordRef;
        WorkFlowEventHandling: Codeunit "Workflow Event Handling";
    begin
        Clear(WorkFlowEventHandling);
        RecRef.Open(Database::"Price Comparison Header");
        WorkFlowEventHandling.AddEventToLibrary(GetWorkFlowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), Database::"Price Comparison Header",
        GetWorkFlowEventDesc(WorkflowSendApprovalEventDesc, RecRef), 0, false);
        WorkFlowEventHandling.AddEventToLibrary(GetWorkFlowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef), Database::"Price Comparison Header",
        GetWorkFlowEventDesc(WorkflowCancelApprovalEventDesc, RecRef), 0, false);
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", OnAddWorkflowEventsToLibrary, '', false, false)]
    local procedure OnAddPurchReqWorkflowEventsToLibrary()
    var
        RecRef: RecordRef;
        WorkFlowEventHandling: Codeunit "Workflow Event Handling";
    begin
        Clear(WorkFlowEventHandling);
        RecRef.Open(Database::"Purchase Request Header");
        WorkFlowEventHandling.AddEventToLibrary(GetWorkFlowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), Database::"Purchase Request Header",
        GetWorkFlowEventDesc(WorkflowSendApprovalEventDesc, RecRef), 0, false);
        WorkFlowEventHandling.AddEventToLibrary(GetWorkFlowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef), Database::"Purchase Request Header",
        GetWorkFlowEventDesc(WorkflowCancelApprovalEventDesc, RecRef), 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom WorkFlow Mgt", OnSendPriceCompForApproval, '', false, false)]
    local procedure RunWorkFlowOnSendPriceCompForApproval(var RecRef: RecordRef)
    begin
        WorkflowManagement.HandleEvent(GetWorkFlowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom WorkFlow Mgt", OnCancelPriceCompForApproval, '', false, false)]
    local procedure RunWorkFlowOnCancelPriceCompForApproval(var RecRef: RecordRef)
    begin
        WorkflowManagement.HandleEvent(GetWorkFlowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef), RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom WorkFlow Mgt", OnSendPurchReqForApproval, '', false, false)]
    local procedure RunWorkFlowOnSendPurchReqForApproval(var RecRef: RecordRef)
    begin
        WorkflowManagement.HandleEvent(GetWorkFlowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom WorkFlow Mgt", OnCancelPurchReqForApproval, '', false, false)]
    local procedure RunWorkFlowOnCancelPurchReqForApproval(var RecRef: RecordRef)
    begin
        WorkflowManagement.HandleEvent(GetWorkFlowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef), RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", OnOpenDocument, '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        PriceCompHdr: Record "Price Comparison Header";
        PurchReqHdr : Record "Purchase Request Header";
    begin
        case RecRef.Number of
            Database::"Price Comparison Header":
                begin
                    RecRef.SetTable(PriceCompHdr);
                    PriceCompHdr.Validate(Status, PriceCompHdr.Status::Open);
                    PriceCompHdr.Modify(true);
                    Handled := true;
                end;
        end;

        case RecRef.Number of
            Database::"Purchase Request Header":
                begin
                    RecRef.SetTable(PurchReqHdr);
                    PurchReqHdr.Validate(Status, PurchReqHdr.Status::Open);
                    PurchReqHdr.Modify(true);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnSetStatusToPendingApproval, '', false, false)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        PriceComparisonHdr: Record "Price Comparison Header";
        PurchRequestHeader : Record "Purchase Request Header";
    begin
        case RecRef.Number of
            Database::"Price Comparison Header":
                begin
                    RecRef.SetTable(PriceComparisonHdr);
                    PriceComparisonHdr.Validate(Status, PriceComparisonHdr.Status::"Pending Approval");
                    PriceComparisonHdr.Modify(true);
                    Variant := PriceComparisonHdr;
                    IsHandled := true;
                end;

        end;

        case RecRef.Number of
            Database::"Purchase Request Header":
                begin
                    RecRef.SetTable(PurchRequestHeader);
                    PurchRequestHeader.Validate(Status, PurchRequestHeader.Status::"Pending Approval");
                    PurchRequestHeader.Modify(true);
                    IsHandled := true;
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnPopulateApprovalEntryArgument, '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkFlowStepInstance: Record "Workflow Step Instance")
    var
        PriceComparisonHeadr: Record "Price Comparison Header";
        PurchReqHdr : Record "Purchase Request Header";
    begin
        case RecRef.Number of
            Database::"Price Comparison Header":
                begin
                    RecRef.SetTable(PriceComparisonHeadr);
                    ApprovalEntryArgument."Document No." := PriceComparisonHeadr."No.";
                end;
        end;

        case RecRef.Number of
            Database::"Purchase Request Header":
                begin
                    RecRef.SetTable(PurchReqHdr);
                    ApprovalEntryArgument."Document No." := PurchReqHdr."No.";
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnRejectApprovalRequest, '', false, false)]
    local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        PriceComparisonHeadr: Record "Price Comparison Header";
        PurchReqHdrRej : Record "Purchase Request Header";
    begin
        case ApprovalEntry."Table ID" of
            Database::"Price Comparison Header":
                begin
                    If PriceComparisonHeadr.Get(ApprovalEntry."Document No.") then
                        PriceComparisonHeadr.Validate(Status, PriceComparisonHeadr.Status::Open);
                    PriceComparisonHeadr.Modify(True);
                end;
        end;

        case ApprovalEntry."Table ID" of
            Database::"Purchase Request Header":
                begin
                    If PurchReqHdrRej.Get(ApprovalEntry."Document No.") then
                        PurchReqHdrRej.Validate(Status, PurchReqHdrRej.Status::Open);
                    PurchReqHdrRej.Modify(true);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", OnReleaseDocument, '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; Var Handled: Boolean)
    var
        PriceComparisonHeadrRelease: Record "Price Comparison Header";
    begin
        case RecRef.Number of
            DataBase::"Price Comparison Header":
                begin
                    RecRef.SetTable(PriceComparisonHeadrRelease);
                    PriceComparisonHeadrRelease.Validate(Status, PriceComparisonHeadrRelease.Status::Released);
                    PriceComparisonHeadrRelease.Modify(True);
                    Handled := true;
                end;
        end;

    end;
     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", OnReleaseDocument, '', false, false)]
    local procedure OnReleasePurchReqDoc(RecRef: RecordRef; Var Handled: Boolean)
    var
        
        PurchReqHdrRelease : Record "Purchase Request Header";
    begin

        case RecRef.Number of
            DataBase::"Purchase Request Header":
                begin
                    RecRef.SetTable(PurchReqHdrRelease);
                    PurchReqHdrRelease.Validate(Status, PurchReqHdrRelease.Status::Released);
                    PurchReqHdrRelease.Modify(True);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnConditionalCardPageIDNotFound', '', true, true)]
    local procedure OnConditionalCardPageIDNotFound(RecordRef: RecordRef; var CardPageID: Integer)
    begin
        if RecordRef.Number = DATABASE::"Price Comparison Header" then
            CardPageID := PAGE::"Price Comparison";
        if RecordRef.Number = DATABASE::"Purchase Request Header" then
            CardPageID := PAGE::"Purchase Request";
    end;



    var
        WorkflowManagement: Codeunit "Workflow Management";
        RUNWORKFLOWONSENDFORAPPROVALCODE: Label 'RUNWORKFLOWONSEND%1FORAPPROVAL';
        RUNWORKFLOWONCANCELFORAPPROVALCODE: Label 'RUNWORKFLOWONCANCEL%1FORAPPROVAL';

        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        NothingToApproveErr: Label 'There is nothing to approve.';
        WorkflowSendApprovalEventDesc: Label 'Approval of a %1 is requested.';
        WorkflowCancelApprovalEventDesc: Label 'An approval request for a %1 is cancelled.';

    procedure GetWorkFlowCode(WorkFlowCode: Code[128]; RecRef: RecordRef): Code[128]
    begin
        exit(DelChr(StrSubstNo(WorkFlowCode, RecRef.Name), '=', ' '));
    end;

    procedure GetWorkFlowEventDesc(WorkflowEventDesc: Text; RecRef: RecordRef): Text
    begin
        exit(StrSubstNo(WorkflowEventDesc, RecRef.Name))
    end;


}
