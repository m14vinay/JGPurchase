report 50261 CustomerPaymentVoucherReport
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/CustomerPaymentVoucherReport.rdl';
    Caption = 'Payment Voucher (Customer)';
    ApplicationArea = Suite;
    UsageCategory = Documents;
    WordMergeDataItem = "Cust. Ledger Entry";

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Document Type", "Customer No.", "Posting Date", "Currency Code") where("Document Type" = filter(Refund));
            RequestFilterFields = "Customer No.", "Posting Date", "Document No.";
            column(Customer_No_; "Cust. Ledger Entry"."Customer No.")
            {
                IncludeCaption = true;
            }
            column(SystemCreatedBy; UserID)
            {
            }
            column(CustomerAmount; "Cust. Ledger Entry"."Amount (LCY)")
            {
            }
            column(Document_Date; Format("Cust. Ledger Entry"."Document Date"))
            {
            }
            column(InstrumentDate; Format("Cust. Ledger Entry"."Posting Date"))
            {
            }
            column(InstrumentNumber; "Cust. Ledger Entry"."Payment Reference")
            {
            }
            column(PaymentMethod; "Cust. Ledger Entry"."Payment Method Code")
            {

            }
            column(PrintName; CompanyInfo."Print Name")
            {
            }
            column(CompanyAddress; CompanyInfo."Address")
            {
            }
            column(CompanyPostcode; CompanyInfo."Post Code")
            {
            }
            column(CompanyCity; CompanyInfo."City")
            {
            }
            column(CompanyState; CompanyCounty)
            {
            }
            column(CompanyCountry; CompanyCountry)
            {
            }
            column(CompanyInfoName; CompanyInfo.Name)
            {
            }
            column(CompanyInfoFax; CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfoEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfoHomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyInfoVATRegNo; CompanyInfo."ADY E-INV SST Reg No.")
            {
            }
            column(CompanyInfoBusinessRegistrationNo; CompanyInfo."Registration No.")
            {
            }
            column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
            {
            }
            column(CompanyInfoBankName; CompanyInfo."Bank Name")
            {
            }
            column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
            {
            }
            column(CompanyLogo; CompanyInfo."Picture")
            {
            }
            column(CompanyPicture1; CompanyInfo."Company Logo 1")
            {
            }
            column(CompanyPicture2; CompanyInfo."Company Logo 2")
            {
            }
            column(CompanyPicture3; CompanyInfo."Company Logo 3")
            {
            }
            column(ReportTitle; ReportTitle)
            {
            }
            column(Document_No_; "Document No.")
            {
            }
            column(TotalShowAmount; "Amount (LCY)" * -1)
            {

            }
            column(AmountInWords; AmountInWords)
            {
            }
            dataitem(CustomerItem; Customer)
            {
                DataItemLink = "No." = field("Customer No.");
                DataItemLinkReference = "Cust. Ledger Entry";
                column(No; CustomerItem."No.")
                {

                }
                column(CustName; CustomerItem.Name)
                {

                }
                column(CustAdd1; CustomerItem.Address)
                {

                }
                column(CustAdd2; CustomerItem."Address 2")
                {

                }
                column(CustPostalCode; CustomerItem."Post Code")
                {

                }
                column(CustCity; CustomerItem.City)
                {

                }
                column(CustCountry; Country)
                {

                }
                column(CustCounty; CustomerItem.County)
                {

                }
                column(CustPhone; CustomerItem."Phone No.")
                {

                }
                column(CustMobileNo; CustomerItem."Mobile Phone No.")
                {

                }
                column(Custpostcodecitycountrycounty; CustomerItem."Post Code" + ', ' + CustomerItem.City + ', ' + CustomerItem.County + ', ' + Country)
                {

                }

                trigger OnAfterGetRecord()
                var
                    CountryRegion: Record "Country/Region";
                begin

                    if CountryRegion.Get(CustomerItem."Country/Region Code") then
                        Country := CountryRegion.Name;
                end;
            }

            dataitem(CustLedgEntry1; "Cust. Ledger Entry")
            {
                DataItemLink = "Closed by Entry No." = field("Entry No.");
                DataItemLinkReference = "Cust. Ledger Entry";
                DataItemTableView = sorting("Document Type", "Customer No.", "Posting Date", "Currency Code") where("Document Type" = filter(Invoice));
                column(InvoiceDate; Format("Document Date"))
                {
                }
                column(InvoiceNo; "Document No.")
                {

                }
                column(PostingDate_CustLedgEntry; Format("Posting Date"))
                {
                }
                column(DocumentType_CustLedgEntry; "Document Type")
                {
                    IncludeCaption = true;
                }
                column(EXTDocumentNoVLE; "External Document No.")
                {
                    IncludeCaption = true;
                }
                column(Description_CustLedgEntry; Description)
                {
                    IncludeCaption = true;
                }
                column(CurrencyCodeCurrencyCode; CurrencyCode("Currency Code"))
                {
                }
                column(InvoiceAmount; abs("Original Amount"))
                {
                }
                column(PaidAmouint; abs("Closed by Amount (LCY)"))
                {
                }
                trigger OnAfterGetRecord()
                begin
                    CustLedgEntry1.CalcFields("Original Amount");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Cust.Get("Customer No.");
                FormatAddr.Customer(CustAddr, Cust);
                if not Currency.Get("Currency Code") then
                    Currency.InitRoundingPrecision();
                CalcFields("Original Amount");
                Clear(AmountInWords);
                Clear(ShowAmount);
                TotalShowAmount := "Cust. Ledger Entry"."Amount (LCY)";
                CodeCheck.InitTextVariable();
                CodeCheck.FormatNoText(NoText, Abs(TotalShowAmount), "Currency Code");
                AmountInWords := NoText[1] + ' ' + NoText[2];

            end;

            trigger OnPreDataItem()
            var
                CountryRegion: Record "Country/Region";
                County: Record "County";
            begin
                CompanyInfo.Get();
                FormatAddr.Company(CompanyAddr, CompanyInfo);
                begin

                    if CountryRegion.Get(CompanyInfo."Country/Region Code") then
                        CompanyCountry := CountryRegion.Name;
                    if County.Get(CompanyInfo."County") then
                        CompanyCounty := County."Description";
                end;
                GLSetup.Get();
            end;
        }
    }
    trigger OnInitReport()
    begin
        CompanyInfo.SetAutoCalcFields(Picture);
        CompanyInfo.SetAutoCalcFields("Company Logo 1");
        CompanyInfo.SetAutoCalcFields("Company Logo 2");
        CompanyInfo.SetAutoCalcFields("Company Logo 3");
    end;

    var
        CompanyCounty: Text;
        CompanyCountry: Text;
        Country: text;
        AmountInWords: text;
        NoText: array[2] of Text;
        CodeCheck: Codeunit 50200;
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        Cust: Record Customer;
        Currency: Record Currency;
        FormatAddr: Codeunit "Format Address";
        ReportTitle: Text[30];
        PaymentDiscountTitle: Text[30];
        CompanyAddr: array[8] of Text[100];
        CustAddr: array[8] of Text[100];
        RemainingAmount: Decimal;
        TotalShowAmount: Decimal;
        ShowAmount: Decimal;
        WHTAmount: Decimal;

    local procedure CurrencyCode(SrcCurrCode: Code[10]): Code[10]
    begin
        if SrcCurrCode = '' then
            exit(GLSetup."LCY Code")
        else
            exit(SrcCurrCode);
    end;
}