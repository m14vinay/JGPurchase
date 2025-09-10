report 50259 PaymentVoucherReport
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/PaymentVoucherReport_v1.rdl';
    Caption = 'Payment Voucher';
    ApplicationArea = Suite;
    UsageCategory = Documents;
    WordMergeDataItem = "Vendor Ledger Entry";

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            DataItemTableView = sorting("Document Type", "Vendor No.", "Posting Date", "Currency Code") where("Document Type" = filter(Payment | Refund));
            RequestFilterFields = "Vendor No.", "Posting Date", "Document No.";
            column(VendorNo_VendLedgEntry; "Vendor Ledger Entry"."Vendor No.")
            {
                IncludeCaption = true;
            }
            column(VendorSystemCreatedBy; "Vendor Ledger Entry"."User ID")
            {
            }
            column(VendorAmount; "Vendor Ledger Entry"."Amount (LCY)")
            {
            }
            column(DocDate_VendLedgEntry; Format("Vendor Ledger Entry"."Document Date"))
            {
            }
            column(InstrumentDate; Format("Vendor Ledger Entry"."Posting Date"))
            {
            }
            column(InstrumentNumber; "Vendor Ledger Entry"."Payment Reference")
            {
            }
            column(PaymentMethod; "Vendor Ledger Entry"."Payment Method Code")
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
            column(DocNo_VendLedgEntry; "Vendor Ledger Entry"."Document No.")
            {
            }
            dataitem(VendItem; Vendor)
            {
                DataItemLink = "No." = field("Vendor No.");
                DataItemLinkReference = "Vendor Ledger Entry";
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
                column(vendpostcodecitycountrycounty; venditem."Post Code" + ', ' + venditem.City + ', ' + venditem.County + ', ' + Country)
                {

                }
                trigger OnAfterGetRecord()
                var
                    CountryRegion: Record "Country/Region";
                begin

                    if CountryRegion.Get(venditem."Country/Region Code") then
                        Country := CountryRegion.Name;
                end;
            }
            dataitem(DetailedVendorLedgEntry1; "Detailed Vendor Ledg. Entry")
            {
                DataItemLink = "Applied Vend. Ledger Entry No." = field("Entry No.");
                DataItemLinkReference = "Vendor Ledger Entry";
                //DataItemTableView = sorting("Applied Vend. Ledger Entry No.", "Entry Type") where(Unapplied = const(false));
                PrintOnlyIfDetail = true;
                column(AppEntryNo_DetailVendLedgEntry; "Applied Vend. Ledger Entry No.")
                {
                }
                dataitem(VendLedgEntry1; "Vendor Ledger Entry")
                {
                    DataItemLink = "Entry No." = field("Vendor Ledger Entry No.");
                    DataItemLinkReference = DetailedVendorLedgEntry1;
                    DataItemTableView = sorting("Entry No.");
                    column(InvoiceDate; Format("Document Date"))
                    {
                    }
                    column(InvoiceNo; "Document No.")
                    {

                    }
                    column(PostingDate_VendLedgEntry; Format("Posting Date"))
                    {
                    }
                    column(DocumentType_VendLedgEntry; "Document Type")
                    {
                        IncludeCaption = true;
                    }
                    column(DocNo_VendLedgEntry1; "Document No.")
                    {
                        IncludeCaption = true;
                    }
                    column(EXTDocumentNoVLE; "External Document No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_VendLedgEntry; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(ShowAmount; -ShowAmount)
                    {
                    }
                    column(CurrencyCodeCurrencyCode; CurrencyCode("Currency Code"))
                    {
                    }
                    column(AmountInWords; AmountInWords)
                    {
                    }
                    column(TotalShowAmount; -TotalShowAmount)
                    {

                    }
                    trigger OnAfterGetRecord()
                    begin
                        if VendLedgEntry1."Entry No." = "Vendor Ledger Entry"."Entry No." then
                            CurrReport.Skip();

                        "Vendor Ledger Entry".CalcFields("WHT Amount");
                        WHTAmount := "Vendor Ledger Entry"."WHT Amount";
                        ShowAmount := -DetailedVendorLedgEntry1.Amount + "Vendor Ledger Entry"."WHT Amount";
                        TotalShowAmount := ShowAmount + TotalShowAmount;
                        CodeCheck.InitTextVariable();
                        CodeCheck.FormatNoText(NoText, Abs(TotalShowAmount), "Currency Code");
                        AmountInWords := NoText[1] + ' ' + NoText[2];

                    end;
                }
            }


            trigger OnAfterGetRecord()
            begin
                Vend.Get("Vendor No.");
                FormatAddr.Vendor(VendAddr, Vend);
                if not Currency.Get("Currency Code") then
                    Currency.InitRoundingPrecision();
                CalcFields("Original Amount");
                RemainingAmount := -"Original Amount";

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
        Vend: Record Vendor;
        Currency: Record Currency;
        FormatAddr: Codeunit "Format Address";
        ReportTitle: Text[30];
        PaymentDiscountTitle: Text[30];
        CompanyAddr: array[8] of Text[100];
        VendAddr: array[8] of Text[100];
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