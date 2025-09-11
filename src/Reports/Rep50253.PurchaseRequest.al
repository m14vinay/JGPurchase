report 50253 "Purchase Request"
{
    ApplicationArea = All;
    Caption = 'Purchase Request';
    UsageCategory = Documents;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/PurchaseRequest1.rdl';
    dataset
    {
        dataitem(PurchaseRequestHeader; "Purchase Request Header")
        {
            RequestFilterFields = "No.";

            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoRegistration; CompInfo."Registration No.") { }
            column(Picture; CompInfo.Picture) { }
            column(PrintName; CompInfo."Print Name") { }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = sorting(Number);
                column(Date; PurchaseRequestHeader."Date")
                {
                }
                column(No; PurchaseRequestHeader."No.")
                {
                }
                column(POCreated; PurchaseRequestHeader."PO Created")
                {
                }
                column(Remarks; PurchaseRequestHeader.Remarks)
                {
                }
                column(RequestedBy; PurchaseRequestHeader."Requested By")
                {
                }
                column(ShortcutDimension1Code; PurchaseRequestHeader."Shortcut Dimension 1 Code")
                {
                }
                column(Status; PurchaseRequestHeader.Status)
                {
                }
                column(Type; TypeCaption)
                {
                }
                column(ApproverID; ApproverID) { }
                column(ApprovalDate; ApprovalDate) { }
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(OutputNo; OutputNo) { }

                    dataitem(PurchaseRequestLine; "Purchase Request Line")
                    {
                        DataItemLink = "No." = field("No.");
                        DataItemLinkReference = PurchaseRequestHeader;


                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break();
                        end;
                    }
                    dataitem(RoundLoop; "Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ItemNo; PurchaseRequestLine."Item No.") { }
                        column(ItemDescription; PurchaseRequestLine.Description) { }
                        column(Quantity; PurchaseRequestLine.Quantity) { }
                        column(PurchReqLineLineNo; PurchaseRequestLine."Line No") { }
                        column(UOM; PurchaseRequestLine.UOM) { }
                        column(NeedDate; PurchaseRequestLine."Need Date") { }
                        column(LineNo; LineNo) { }
                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                                TempReqLine.Find('-')
                            else
                                TempReqLine.Next();
                            PurchaseRequestLine := TempReqLine;

                            LineNo += 1;
                        end;

                        trigger OnPostDataItem()
                        begin
                            TempReqLine.DeleteAll();
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := TempReqLine.Find('+');
                            /* while MoreLines and (TempReqLine.Description = '') and
                                   (TempReqLine."No." = '') and (TempReqLine.Quantity = 0)
                             do
                                 MoreLines := TempReqLine.Next(-1) <> 0;*/
                            if not MoreLines then
                                CurrReport.Break();
                            TempReqLine.SetRange("Line No", 0, TempReqLine."Line No");
                            SetRange(Number, 1, TempReqLine.Count);
                        end;

                    }

                }
                trigger OnAfterGetRecord()
                var
                    PurchReqL: Record "Purchase Request Line";
                begin
                    Clear(TempReqLine);
                    Clear(LineNo);
                    TempReqLine.DeleteAll();
                    PurchReqL.Reset();
                    PurchReqL.SetRange("No.", PurchaseRequestHeader."No.");
                    If PurchReqL.FindSet() then
                        repeat
                            TempReqLine.Init();
                            TempReqLine := PurchReqL;
                            TempReqLine.Insert();
                        until PurchReqL.Next = 0;
                    if Number > 1 then
                        CopyText := FormatDocument.GetCOPYText();
                    OutputNo := OutputNo + 1;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 0;

                end;


            }
            trigger OnAfterGetRecord()
            begin
                Clear(ApproverID);
                Clear(ApprovalDate);
                TypeCaption := Format(PurchaseRequestHeader.Type);
                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Table ID", 50254);
                ApprovalEntry.SetRange("Document No.", PurchaseRequestHeader."No.");
                //ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                If ApprovalEntry.FindLast() then
                    If ApprovalEntry.Status = ApprovalEntry.Status::Approved then begin
                        ApproverID := ApprovalEntry."Approver ID";
                        ApprovalDate := DT2Date(ApprovalEntry."Last Date-Time Modified");
                    end;
            end;

        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoofCopies; NoOfCopies)
                    {
                        ApplicationArea = Suite;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies how many copies of the document to print.';
                    }

                }
            }
        }
    }
    trigger OnInitReport()
    begin
        CompInfo.Get();
        CompInfo.CalcFields(Picture);
    end;

    var
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        OutputNo: Integer;
        LineNo: Integer;
        FormatDocument: Codeunit "Format Document";
        CompInfo: Record "Company Information";
        TempReqLine: Record "Purchase Request Line" temporary;
        ApprovalEntry: Record "Approval Entry";
        MoreLines: Boolean;
        ApproverID: Code[50];
        TypeCaption: Text[20];
        ApprovalDate: Date;
}
