pageextension 50266 PaymentJournal extends "Payment Journal"
{

    actions
    {
        addafter(Approvals)
        {
            action(PaymentVoucherReportInvoice)
            {
                ApplicationArea = All;
                Caption = 'Print PV';
                Image = Report; // Optional icon
                trigger OnAction()
                var
                    MyReportID: Integer;
                    DocumentNo: Record "Gen. Journal Line";
                begin
                    MyReportID := Report::PaymentVoucherReportInvoice; // Replace with your report ID or name
                                                                       // Run without request page
                                                                       // Report.Run(MyReportID, false, false); 

                    // Run with request page
                    //CurrPage.SetSelectionFilter(DocumentNo);
                    DocumentNo.Reset();
                    DocumentNo.SetRange("Journal Template Name",Rec."Journal Template Name");
                    DocumentNo.SetRange("Journal Batch Name",Rec."Journal Batch Name");
                    If DocumentNo.FindSet() then;
                    //DocumentNo.Reset();
                    //DocumentNo.SETRANGE("Document No.", Rec."Document No.");
                    Report.RunModal(MyReportID, true, false, DocumentNo);
                end;
            }
        }
    }
}