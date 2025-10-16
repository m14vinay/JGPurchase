pageextension 50266 PaymentJournal extends "Payment Journal"
{
    layout{
         modify("VAT Bus. Posting Group")
        {
            Caption = 'SST Bus. Posting Group';
        }
         modify("VAT Prod. Posting Group")
        {
            Caption = 'SST Prod. Posting Group';
        }
         modify("VAT Amount")
        {
            Caption = 'SST Amount';
        }
          modify("VAT Difference")
        {
            Caption = 'SST Difference';
        }
           modify("Bal. VAT Amount")
        {
            Caption = 'Bal. SST Amount';
        }
         modify("Bal. VAT Bus. Posting Group")
        {
            Caption = 'Bal. SST Bus. Posting Group';
        }
          modify("Bal. VAT Difference")
        {
            Caption = 'Bal. SST Difference';
        }
           modify("Bal. VAT Prod. Posting Group")
        {
            Caption = 'Bal. SST Prod. Posting Group';
        }
    }

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