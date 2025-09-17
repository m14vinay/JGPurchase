report 50260 PaymentVoucherReportInvoice
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/PaymentVoucherReportInvoice_v1.rdl';
    Caption = 'Print PV';
    ApplicationArea = Suite;
    UsageCategory = Documents;
    WordMergeDataItem = "Gen. Journal Line";

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            column(PrintName; CompanyInfo."Print Name")
            {
            }
            column(InstrumentDate; Format("Gen. Journal Line"."Posting Date"))
            {
            }
            column(Posting_Date; Format("Gen. Journal Line"."Posting Date"))
            {
            }
            column(InstrumentNumber; "Gen. Journal Line"."Payment Reference")
            {
            }
            column(PaymentMethod; "Gen. Journal Line"."Payment Method Code")
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
            column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
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
            column(Document_Date; Format("Document Date"))
            {
            }
            column(InvoiceDate; Format(InvoiceDate))
            {
            }
            column(InvoiceNumber; InvoiceNumber)
            {
            }
            column(Document_Type; "Document Type")
            {
                IncludeCaption = true;
            }
            column(Document_No_; "Document No.")
            {
                IncludeCaption = true;
            }
            column(EXTDocumentNo; "External Document No.")
            {
            }
            column(SystemCreatedBy; UserId)
            {
            }
            column(Description; "Description")
            {
            }
            column(ShowAmount; ShowAmount)
            {
            }
            column(Amount; Amount)
            {
            }
            column(CurrencyCodeCurrencyCode; CurrencyCode("Currency Code"))
            {
            }
            column(AmountInWords; AmountInWords)
            {
            }
            column(TotalShowAmount; TotalShowAmount)
            {
            }
            column(Account_No_; "Actual Vendor No.")
            {
            }

            dataitem(VendItem; Vendor)
            {
                DataItemLink = "No." = field("Account No.");
                DataItemLinkReference = "Gen. Journal Line";
                column(VendorNo; venditem."No.")
                {

                }
                column(VendorName; venditem.Name)
                {

                }
                column(VendAdd1; venditem.Address)
                {

                }
                column(vendadd2; venditem."Address 2")
                {

                }
                column(vendpostcode; venditem."Post Code")
                {

                }
                column(vendcity; venditem.City)
                {

                }
                column(vendcountry; Country)
                {

                }
                column(vendcounty; venditem.County)
                {

                }
                column(venphone; venditem."Phone No.")
                {

                }
                column(vendmobileno; venditem."Mobile Phone No.")
                {

                }
                column(vendpostcodecitycountrycounty; venditem."Post Code" + ', ' + venditem.City + ', ' + County + ', ' + Country)
                {

                }
                trigger OnAfterGetRecord()
                var
                    CountryRegion: Record "Country/Region";
                    CountyRec: Record "County";
                begin

                    if CountryRegion.Get(venditem."Country/Region Code") then
                        Country := CountryRegion.Name;
                    if CountyRec.Get(venditem."County") then
                        County := CountyRec."Description";
                end;
            }
            dataitem(VendLedgEntry1; "Vendor Ledger Entry")
            {
                DataItemLink = "Applies-to ID" = field("Applies-to ID"), "Vendor No." = field("Account No.");
                DataItemLinkReference = "Gen. Journal Line";
                DataItemTableView = sorting("Entry No.");
                column(DocumentNo; "Document No.") { }
                column(DocumentDate; "Document Date") { }
                column(InvoiceAmount; VendLedgEntry1."Remaining Amount" * -1) { }
                column(PaidAmount; VendLedgEntry1."Amount to Apply" * -1) { }
                column(DescriptionVLE; Description) { }
                trigger OnAfterGetRecord()
                begin
                    VendLedgEntry1.CalcFields("Remaining Amount");
                end;

            }

            trigger OnAfterGetRecord()
            var
                vendorLedgerEntry: Record "Vendor Ledger Entry";
            begin
                if not Currency.Get("Currency Code") then
                    Currency.InitRoundingPrecision();

                ShowAmount := "Gen. Journal Line"."Amount";
                TotalShowAmount := ShowAmount + TotalShowAmount;
                CodeCheck.InitTextVariable();
                CodeCheck.FormatNoText(NoText, Abs(TotalShowAmount), "Currency Code");
                AmountInWords := NoText[1] + ' ' + NoText[2];
                if ("Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::Vendor)
      and ("Gen. Journal Line"."Applies-to ID" <> '') then begin
                    vendorLedgerEntry.Reset();
                    vendorLedgerEntry.SetRange("Vendor No.", "Gen. Journal Line"."Account No.");
                    vendorLedgerEntry.SetRange("Applies-to ID", "Gen. Journal Line"."Applies-to ID");
                    if vendorLedgerEntry.FindFirst() then
                        InvoiceNumber := vendorLedgerEntry."Document No.";
                    InvoiceDate := vendorLedgerEntry."Document Date";

                end;
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
        InvoiceDate: Date;
        InvoiceNumber: Text;
        CompanyCountry: Text;
        Country: text;
        County: Text;
        AmountInWords: text;
        NoText: array[2] of Text;
        CodeCheck: Codeunit 50200;
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        Vend: Record Vendor;
        Currency: Record Currency;
        FormatAddr: Codeunit "Format Address";
        ReportTitle: Text[30];
        PaymentDiscountTitle: Text[30];
        CompanyAddr: array[8] of Text[100];
        VendAddr: array[8] of Text[100];
        TotalShowAmount: Decimal;
        ShowAmount: Decimal;

    local procedure CurrencyCode(SrcCurrCode: Code[10]): Code[10]
    begin
        if SrcCurrCode = '' then
            exit(GLSetup."LCY Code")
        else
            exit(SrcCurrCode);
    end;

}