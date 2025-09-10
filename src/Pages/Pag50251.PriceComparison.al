page 50251 "Price Comparison"
{
    ApplicationArea = All;
    Caption = 'Price Comparison';
    PageType = Document;
    SourceTable = "Price Comparison Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    PromotedActionCategoriesML = ENU = 'Home,Process,Report,Approve,Request Approve';
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
                }
                field("PR No."; Rec."PR No.")
                {
                    ToolTip = 'Specifies the value of the PR No. field.', Comment = '%';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                    MultiLine = true;
                }
                field("Req Department"; Rec."Req Department")
                {
                    ToolTip = 'Specifies the value of the Req Department field.', Comment = '%';
                    Editable = false;
                }
                field("Type of Item"; Rec."Type of Item")
                {
                    ToolTip = 'Specifies the value of the Type of Item field.', Comment = '%';
                }
                field("Type of Purchase"; Rec."Type of Purchase")
                {
                    ToolTip = 'Specifies the value of the Type of Purchase field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
            part(Lines; "Price Comparison Subform")
            {
                ApplicationArea = Basic, Suite;
                Editable = true;
                Enabled = true;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
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
                    var
                        CustomWorkFlow: Codeunit "Custom WorkFlow Mgt";
                    begin
                        CustomWorkFlow.CheckPCManualRelease(Rec);
                        CheckVendorSelected();
                        PerformManualRelease();
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
                    Enabled = Rec.Status = Rec.Status::Released;
                    Image = MakeOrder;
                    Promoted = True;
                    PromotedIsBig = True;
                    PromotedCategory = New;
                    ToolTip = 'Create Purchase Orders based on the vendors selected';

                    trigger OnAction()
                    var
                        PricCompLine: Record "Price Comparison Line";
                        PurchaseHeader: Record "Purchase Header";
                        PurchLineTemp: Record "Purchase Line" temporary;
                        PurchaseLine: Record "Purchase Line";
                        PurchHeader: Record "Purchase Header";
                        PurchReqLine: Record "Purchase Request Line";
                        PurchReqHeader: Record "Purchase Request Header";
                        PurchLine: Record "Purchase Line";
                        PurchQuoteLine: Record "Purchase Line";
                        PurchSetup: Record "Purchases & Payables Setup";
                        Vendor: Record Vendor;
                        PurchLineReserve: Codeunit "Purch. Line-Reserve";
                        NoSeries: Codeunit "No. Series";
                        PrepmtMgt: Codeunit "Prepayment Mgt.";
                        CreateChargeItem: Boolean;
                        CreatePO: Boolean;
                    begin
                        If Rec."PO Created" then
                            If Confirm('PO already created for the PR %1. Do you want to Continue?', true, Rec."No.") then
                                CreatePO := True;
                        If not Rec."PO Created" or CreatePO then begin
                            PurchSetup.Get();
                            PricCompLine.Reset();
                            PricCompLine.SetRange("Document No.", Rec."No.");
                            if PricCompLine.FindSet(true) then
                                repeat
                                    CreateChargeItem := True;
                                    If (PricCompLine."Vendor Selected") or (PricCompLine.Type = PricCompLine.Type::"Charge (Item)") then begin
                                        If Vendor.Get(PricCompLine."Vendor No.") then;
                                        PurchaseHeader.Reset();
                                        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
                                        PurchaseHeader.SetRange("Buy-from Vendor No.", PricCompLine."Vendor No.");
                                        PurchaseHeader.SetRange("Quote No.", PricCompLine."Purchase Quote No.");
                                        PurchaseHeader.SetRange("PR No.", PricCompLine."PR No.");
                                        If not PurchaseHeader.FindFirst() then begin
                                            CreateChargeItem := false;
                                            If not (PricCompLine.Type = PricCompLine.Type::"Charge (Item)") then begin
                                                If PurchHeader.Get(PurchHeader."Document Type"::Quote, PricCompLine."Purchase Quote No.") then begin
                                                    PurchaseHeader := PurchHeader;
                                                    PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
                                                    PurchaseHeader."No. Printed" := 0;
                                                    PurchaseHeader.Status := PurchaseHeader.Status::Open;
                                                    PurchaseHeader."Quote No." := PurchHeader."No.";
                                                    PurchaseHeader."No." := '';
                                                    PurchaseHeader.InitRecord();
                                                    PurchaseHeader.Insert(true);
                                                    PurchaseHeader."Shipment Method Code" := PurchHeader."Shipment Method Code";
                                                    PurchaseHeader."Payment Terms Code" := PurchHeader."Payment Terms Code";
                                                    PurchaseHeader."Order Date" := PurchHeader."Order Date";
                                                    if PurchHeader."Posting Date" <> 0D then
                                                        PurchaseHeader."Posting Date" := PurchHeader."Posting Date";

                                                    PurchaseHeader.InitFromPurchHeader(PurchHeader);
                                                    PurchaseHeader."Inbound Whse. Handling Time" := PurchHeader."Inbound Whse. Handling Time";

                                                    PurchaseHeader."Prepayment %" := Vendor."Prepayment %";
                                                    if PurchaseHeader."Posting Date" = 0D then
                                                        PurchaseHeader."Posting Date" := WorkDate();

                                                    PurchaseHeader.Modify();
                                                end;

                                            end;
                                        end;
                                        If PricCompLine.Type = PricCompLine.Type::Item then begin
                                            PurchaseLine.Reset();
                                            PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                                            PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                                            PurchaseLine.SetRange("No.", PricCompLine."Item No.");
                                            If not PurchaseLine.FindFirst() then begin
                                                PurchQuoteLine.Reset();
                                                PurchQuoteLine.SetRange("Document Type", PurchQuoteLine."Document Type"::Quote);
                                                PurchQuoteLine.SetRange("Document No.", PricCompLine."Purchase Quote No.");
                                                PurchQuoteLine.SetRange("Line No.", PricCompLine."Purchase Quote Line No.");
                                                If PurchQuoteLine.FindFirst() then begin
                                                    PurchaseLine := PurchQuoteLine;
                                                    PurchaseLine."Document Type" := PurchaseHeader."Document Type";
                                                    PurchaseLine."Document No." := PurchaseHeader."No.";
                                                    PurchLineReserve.TransferPurchLineToPurchLine(
                                                      PurchQuoteLine, PurchaseLine, PurchQuoteLine."Outstanding Qty. (Base)");
                                                    PurchaseLine.Validate("Shortcut Dimension 1 Code" , Rec."Req Department");
                                                    PurchaseLine.Validate("Shortcut Dimension 2 Code" , PurchQuoteLine."Shortcut Dimension 2 Code");
                                                    //PurchaseLine."Dimension Set ID" := PurchQuoteLine."Dimension Set ID";
                                                    PurchaseLine."Transaction Type" := PurchaseHeader."Transaction Type";
                                                    if Vendor."Prepayment %" <> 0 then
                                                        PurchaseLine."Prepayment %" := Vendor."Prepayment %";

                                                    PurchLine.Reset();
                                                    PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                                                    PurchLine.SetRange("Document No.", PurchaseHeader."No.");
                                                    PurchLine.SetAscending("Line No.", false);
                                                    If PurchLine.FindFirst() then
                                                        PurchaseLine."Line No." := PurchLine."Line No." + 10000
                                                    else
                                                        PurchaseLine."Line No." := 10000;
                                                    PrepmtMgt.SetPurchPrepaymentPct(PurchaseLine, PurchaseHeader."Posting Date");
                                                    PurchaseLine.Validate("Prepayment %");
                                                    if PurchaseLine."No." <> '' then
                                                        PurchaseLine.DefaultDeferralCode();
                                                    PurchaseLine.Insert();
                                                    PurchLineReserve.VerifyQuantity(PurchaseLine, PurchQuoteLine);
                                                end;
                                            end;

                                            PurchaseLine."Price Comparison No." := PricCompLine."Document No.";
                                            PurchaseLine."Price Comparison Line No." := PricCompLine."Line No.";
                                            PricCompLine."Purchase Order No." := PurchaseHeader."No.";
                                            PricCompLine."Purchase Line No." := PurchaseLine."Line No.";
                                            PurchReqLine.Reset();
                                            PurchReqLine.SetRange("No.", PricCompLine."PR No.");
                                            PurchReqLine.SetRange("Item No.", PricCompLine."Item No.");
                                            If PurchReqLine.FindFirst() then begin
                                                PurchaseLine.Validate("Expected Receipt Date", PurchReqLine."Need Date");
                                                PurchReqLine."Purchase Order No." := PurchaseHeader."No.";
                                                PurchReqLine."Purchase Line No." := PurchaseLine."Line No.";
                                                PurchaseLine."Purchase Request No." := PurchReqLine."No.";
                                                PurchaseLine."Purchase Request Line No." := PurchReqLine."Line No";
                                                PurchReqLine.Modify();
                                            end;
                                            
                                            PurchaseLine.Modify();
                                            PricCompLine.Modify();
                                        end;
                                        If (PricCompLine.Type = PricCompLine.Type::"Charge (Item)") and CreateChargeItem then begin
                                            PurchaseLine.Reset();
                                            PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                                            PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                                            PurchaseLine.SetRange("No.", PricCompLine."Item No.");
                                            If not PurchaseLine.FindFirst() then begin
                                                PurchQuoteLine.Reset();
                                                PurchQuoteLine.SetRange("Document Type", PurchQuoteLine."Document Type"::Quote);
                                                PurchQuoteLine.SetRange("Document No.", PricCompLine."Purchase Quote No.");
                                                PurchQuoteLine.SetRange("Line No.", PricCompLine."Purchase Quote Line No.");
                                                If PurchQuoteLine.FindFirst() then begin
                                                    PurchaseLine := PurchQuoteLine;
                                                    PurchaseLine."Document Type" := PurchaseHeader."Document Type";
                                                    PurchaseLine."Document No." := PurchaseHeader."No.";
                                                    PurchLineReserve.TransferPurchLineToPurchLine(
                                                      PurchQuoteLine, PurchaseLine, PurchQuoteLine."Outstanding Qty. (Base)");
                                                    PurchaseLine.Validate("Shortcut Dimension 1 Code", Rec."Req Department");
                                                    PurchaseLine.Validate("Shortcut Dimension 2 Code" , PurchQuoteLine."Shortcut Dimension 2 Code");
                                                    //PurchaseLine."Dimension Set ID" := PurchQuoteLine."Dimension Set ID";
                                                    PurchaseLine."Transaction Type" := PurchaseHeader."Transaction Type";
                                                    if Vendor."Prepayment %" <> 0 then
                                                        PurchaseLine."Prepayment %" := Vendor."Prepayment %";
                                                    PrepmtMgt.SetPurchPrepaymentPct(PurchaseLine, PurchaseHeader."Posting Date");
                                                    PurchaseLine.Validate("Prepayment %");
                                                    if PurchaseLine."No." <> '' then
                                                        PurchaseLine.DefaultDeferralCode();
                                                    PurchLine.Reset();
                                                    PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                                                    PurchLine.SetRange("Document No.", PurchaseHeader."No.");
                                                    PurchLine.SetAscending("Line No.", false);
                                                    If PurchLine.FindFirst() then
                                                        PurchaseLine."Line No." := PurchLine."Line No." + 10000
                                                    else
                                                        PurchaseLine."Line No." := 10000;
                                                    PurchaseLine.Insert();
                                                    PurchLineReserve.VerifyQuantity(PurchaseLine, PurchQuoteLine);
                                                end;
                                            end;

                                            PurchaseLine."Price Comparison No." := PricCompLine."Document No.";
                                            PurchaseLine."Price Comparison Line No." := PricCompLine."Line No.";
                                            PricCompLine."Purchase Order No." := PurchaseHeader."No.";
                                            PricCompLine."Purchase Line No." := PurchaseLine."Line No.";
                                            PurchReqLine.Reset();
                                            PurchReqLine.SetRange("No.", PricCompLine."PR No.");
                                            PurchReqLine.SetRange("Item No.", PricCompLine."Item No.");
                                            If PurchReqLine.FindFirst() then begin
                                                PurchaseLine.Validate("Expected Receipt Date", PurchReqLine."Need Date");
                                                PurchReqLine."Purchase Order No." := PurchaseHeader."No.";
                                                PurchReqLine."Purchase Line No." := PurchaseLine."Line No.";
                                                PurchaseLine."Purchase Request No." := PurchReqLine."No.";
                                                PurchaseLine."Purchase Request Line No." := PurchReqLine."Line No";
                                                PurchReqLine.Modify();
                                            end;
                                            PurchaseLine.Modify();
                                            PricCompLine.Modify();
                                            
                                        end;
                                    end;
                                until PricCompLine.Next() = 0;
                            Rec."PO Created" := True;
                            Rec.Modify();
                            Message('Purchase Order Created');
                            If PurchReqHeader.Get(Rec."PR No.") then begin
                              PurchReqHeader."PO Created" := True;
                              PurchReqHeader.Modify();
                            end;
                        end;
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
                    begin
                        CheckVendorSelected();
                        RecRef.GetTable(Rec);
                        If CustomWorkFlowMgt.CheckPriceComparisonApprovalPossible(RecRef) then
                            CustomWorkFlowMgt.OnSendPriceCompForApproval(RecRef);
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
                        CustomWorkFlowMgt.OnCancelPriceCompForApproval(RecRef);
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
                action(PriceCompRep)
                {
                    ApplicationArea = All;
                    Caption = 'Price Comparison Report';
                    Image = Report;
                    Promoted = True;
                    PromotedCategory = Report;
                    ToolTip = 'View Price Compare Rep';
                    trigger OnAction()
                    var
                        PriceCompHdr: Record "Price Comparison Header";
                    begin
                        // Run the report with the filter applied
                        CurrPage.SetSelectionFilter(PriceCompHdr);
                        Report.RunModal(Report::"Price Comparison", true, false, PriceCompHdr);
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
    procedure PerformManualReopen(var PriceComHeader: Record "Price Comparison Header")
    begin
        if PriceComHeader.Status = PriceComHeader.Status::"Pending Approval" then
            Error(Text003);
        if PriceComHeader.Status = PriceComHeader.Status::Open then
            exit;
        PriceComHeader.Status := PriceComHeader.Status::Open;
        PriceComHeader.Modify(true);
    end;

    procedure PerformManualRelease()
    begin
        if Rec.Status = Rec.Status::"Pending Approval" then
            Error(Text003);
        if Rec.Status <> Rec.Status::Released then begin
            Rec.Status := Rec.Status::Released;
            Commit();
        end;
    end;

    procedure CheckVendorSelected()
    var
        PriceCompLine: Record "Price Comparison Line";
        PriceCompLineItem: Record "Price Comparison Line";
        PriceCompLinetemp: Record "Price Comparison Line" temporary;
        vendorselected: Integer;
    begin
        PriceCompLinetemp.DeleteAll();
        PriceCompLine.Reset();
        PriceCompLine.SetRange("Document No.", Rec."No.");
        PriceCompLine.SetRange(Type, PriceCompLine.Type::Item);
        PriceCompLine.SetRange("Vendor Selected", true);
        If PriceCompLine.FindSet() then
            repeat
                PriceCompLinetemp.Init();
                PriceCompLinetemp := PriceCompLine;
                PriceCompLinetemp.Insert();
            until PriceCompLine.Next() = 0;
        PriceCompLineItem.Reset();
        PriceCompLineItem.SetRange("Document No.", Rec."No.");
        PriceCompLineItem.SetRange(Type, PriceCompLine.Type::Item);
        If PriceCompLineItem.FindSet() then
            repeat
                PriceCompLinetemp.Reset();
                PriceCompLinetemp.SetRange("Item No.", PriceCompLineItem."Item No.");
                If PriceCompLinetemp.IsEmpty then
                    Error('Vendors not selected for all the items');
            until PriceCompLineItem.Next() = 0;
    end;

    var
        ApprovalMgmt: Codeunit "Approvals Mgmt.";
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        CanCancelApprovalForRecord: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        VendorSelectedEnabled: Boolean;
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
