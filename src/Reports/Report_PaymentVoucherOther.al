report 50266 PaymentVoucherOtherReport
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/PaymentVoucherOtherReport.rdl';
    Caption = 'Payment Voucher (Other)';
    ApplicationArea = Suite;
    UsageCategory = Documents;
    //WordMergeDataItem = "G/L Entry";

    dataset
    {

        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = sorting("Document Type", "Posting Date") where("Source Code" = filter('PAYMENTJNL'));
            column(Description_Main; Description)
            {
                IncludeCaption = true;
            }
            column(SystemCreatedBy; UserId)
            {
            }
            column(Amount; "Amount")
            {
            }
            column(DocDate; Format("Document Date"))
            {
            }
            column(InstrumentDate; Format("Posting Date"))
            {
            }
            column(InstrumentNumber; '')
            {
            }
            column(PaymentMethod; '')
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
            column(DocNo; "Document No.")
            {
            }
            column(TotalShowAmount; "Amount")
            {

            }
            column(AmountInWords; AmountInWords)
            {
            }
            column(Comment; Comment)
            {

            }
            dataitem(VendLedgEntry1; "Vendor Ledger Entry")
            {
                DataItemLink = "Closed by Entry No." = field("Entry No.");
                DataItemLinkReference = "G/L Entry";
                DataItemTableView = sorting("Document Type", "Vendor No.", "Posting Date", "Currency Code") where("Document Type" = filter(Invoice));
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
                column(EXTDocumentNoVLE; "External Document No.")
                {
                    IncludeCaption = true;
                }
                column(Description_VendLedgEntry; Description)
                {
                    IncludeCaption = true;
                }
                column(InvoiceAmount; abs("Original Amount"))
                {
                }
                column(PaidAmouint; abs("Closed by Amount (LCY)"))
                {
                }
                column(CurrencyCodeCurrencyCode; CurrencyCode("Currency Code"))
                {
                }
                dataitem(VendItem; Vendor)
                {
                    DataItemLink = "No." = field("Vendor No.");
                    DataItemLinkReference = VendLedgEntry1;
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
                trigger OnAfterGetRecord()
                begin
                    VendLedgEntry1.CalcFields("Original Amount");
                end;
            }
            trigger OnAfterGetRecord()
            begin
                if not Currency.Get(GetCurrencyCode()) then
                    Currency.InitRoundingPrecision();
                Clear(AmountInWords);
                Clear(ShowAmount);
                TotalShowAmount := "G/L Entry"."Amount";
                CodeCheck.InitTextVariable();
                CodeCheck.FormatNoText(NoText, Abs(TotalShowAmount), GetCurrencyCode());
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