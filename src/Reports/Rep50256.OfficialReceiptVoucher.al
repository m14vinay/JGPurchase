report 50256 "Official Voucher (Vendor)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/OfficialVoucherReport.rdlc';
    ApplicationArea = All;
    Caption = 'Official Voucher (Vendor)';
    UsageCategory = ReportsAndAnalysis;
    PreviewMode = PrintLayout;
    WordMergeDataItem = VendorLedgerEntry;

    dataset
    {
        dataitem(VendorLedgerEntry; "Vendor Ledger Entry")
        {
            // RequestFilterFields = "Posting Date", "Document No.", "Document Type";
            // DataItemTableView = SORTING("Document Type", "Document No.");

            column(PrintName; CompanyInfo."Print Name") { }
            column(Document_No_; "Document No.") { }
            column(Document_Date; "Posting Date") { }
            column(External_Document_No_; "External Document No.") { }
            column(Amount; Amount) { }
            column(Amount__LCY_; "Amount (LCY)") { }
            column(Description; Description) { }
            column(CompanyNameCol; CompanyName) { }
            column(CompanyAddressCol; CompanyAddress) { }
            column(CompanyPhoneCol; CompanyPhone) { }
            column(CompanyFaxCol; CompanyFax) { }
            column(CompanyEmailCol; CompanyEmail) { }
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(companyLogo1; CompanyInfo."Company Logo 1") { }
            column(companyLogo2; CompanyInfo."Company Logo 2") { }
            column(companyLogo3; CompanyInfo."Company Logo 3") { }
            column(companyPrintName; CompanyInfo."Print Name") { }
            column(CompanyHomePage; CompanyHomePage) { }
            column(CompanyRegNo; CompanyRegNo) { }
            column(SSTRegistrationCol; SSTRegistration) { }
            column(Document_Type; "Document Type") { }
            column(Currency_Code; "Currency Code") { }
            column(TotalAmountLCY; TotalAmountLCY) { }
            column(Payment_Reference; "Payment Reference") { }

            column(VendorName; VendorName) { }
            column(VendorAddr1; VendorAddr1) { }
            column(VendorAddr2; VendorAddr2) { }
            column(PostCodeCityCountryCountry; VendorPostCodeCityCountryCountry) { }
            column(Phone; VendorPhone) { }
            column(Mobile; VendorMobile) { }
            column(City; VendorCity) { }
            column(County; VendorCounty) { }
            column(CountryRegionCode; VendorCountryRegionCode) { }
            column(HomePage; VendorHomePage) { }
            column(VendorCurrency_Code; VendorCurrencyCode) { }

            column(AmountInWords; AmountInWords) { }
            column(TotalShowAmountCol; TotalShowAmount) { }

            // Simplified applied entries without complex DataItemLink
            dataitem(AppliedEntries; "Vendor Ledger Entry")
            {
                DataItemLinkReference = VendorLedgerEntry;
                // Remove the DataItemTableView to prevent filter prompts

                column(Applied_Ext_Document_No_; "External Document No.") { }
                column(Applied_Document_No_; "Document No.") { }
                column(Applied_Document_Date; "Document Date") { }
                column(Applied_Amount; Amount) { }
                column(Applied_Amount__LCY_; "Amount (LCY)") { }
                column(Applied_Description; Description) { }
                column(Applied_Currency_Code; "Currency Code") { }
                column(Applied_Document_Type; "Document Type") { }
                column(Applied_Posting_Date; "Posting Date") { }

                trigger OnPreDataItem()
                begin
                    // Set filters programmatically instead of using DataItemLink
                    SetRange("Closed by Entry No.", VendorLedgerEntry."Entry No.");
                    SetFilter("Closed by Entry No.", '<>0');
                end;

                trigger OnAfterGetRecord()
                begin
                    VendorLedgerEntry.CalcFields("WHT Amount");
                    WHTAmount := VendorLedgerEntry."WHT Amount";
                    ShowAmount := Abs("Amount (LCY)") + WHTAmount;

                    TotalShowAmount += ShowAmount;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TotalShowAmount := 0;

                if VendorRec.Get("Vendor No.") then begin
                    VendorName := VendorRec.Name;
                    VendorAddr1 := VendorRec.Address;
                    VendorAddr2 := VendorRec."Address 2";
                    VendorPostCodeCityCountryCountry := GetVendorAddressFull();
                    VendorPhone := VendorRec."Phone No.";
                    VendorCity := VendorRec.City;
                    VendorCounty := VendorRec.County;
                    VendorCountryRegionCode := VendorRec."Country/Region Code";
                    VendorMobile := VendorRec."Mobile Phone No.";
#pragma warning disable AL0432
                    VendorHomePage := VendorRec."Home Page";
#pragma warning restore AL0432
                    VendorCurrencyCode := VendorRec."Currency Code";
                end;

                CalculateAmountInWords();
            end;
        }
    }

    requestpage
    {
        SaveValues = true; // Add this to remember filter values

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Vendor Ledger Entry';

                    field(documentNo; DocumentNoFilter)
                    {
                        Caption = 'Document No.';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the document number for filtering.';

                        trigger OnValidate()
                        begin
                            // Apply filter immediately when changed
                        end;
                    }

                    field(PostingDateFrom; PostingDateFromFilter)
                    {
                        Caption = 'From Posting Date';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the starting posting date for filtering.';
                    }

                    field(PostingDateTo; PostingDateToFilter)
                    {
                        Caption = 'To Posting Date';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the ending posting date for filtering.';
                    }

                    field(DocumentTypeField; DocumentTypeFilter)
                    {
                        Caption = 'Document Type';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the document type to filter by';
                        OptionCaption = 'All,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            DocumentTypeFilter := DocumentTypeFilter::Refund;
        end;
    }

    labels { }

    var
        CompanyInfo: Record "Company Information";
        VendorRec: Record "Vendor";
        CompanyName: Text;
        CompanyAddress: Text;
        CompanyPhone: Text;
        CompanyFax: Text;
        CompanyEmail: Text;
        SSTRegistration: Text;
        CompanyHomePage: Text;
        CompanyLogo1: Text;
        CompanyLogo2: Text;
        TotalAmountLCY: Decimal;
        CheckCU: Codeunit 50252;
        NoText: array[2] of Text[80];
        AmountInWords: Text[250];
        AmountVendor: Decimal;
        CompanyRegNo: Text[250];
        TotalShowAmount: Decimal;
        ShowAmount: Decimal;
        WHTAmount: Decimal;

        // Changed to include "All" option
        DocumentTypeFilter: Option "All",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;

        // Separate filter variables
        DocumentNoFilter: Code[20];
        PostingDateFromFilter: Date;
        PostingDateToFilter: Date;

        VendorName: Text;
        VendorAddr1: Text;
        VendorAddr2: Text;
        VendorPostCodeCityCountryCountry: Text;
        VendorPhone: Text;
        VendorCity: Text;
        VendorCounty: Text;
        VendorCountryRegionCode: Text;
        VendorMobile: Text;
        VendorHomePage: Text;
        VendorCurrencyCode: Text;

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.SetAutoCalcFields(Picture);
        CompanyInfo.SetAutoCalcFields("Company Logo 1");
        CompanyInfo.SetAutoCalcFields("Company Logo 2");
        CompanyInfo.SetAutoCalcFields("Company Logo 3");
    end;

    trigger OnPreReport()
    begin
        // Apply filters based on request page values
        if DocumentNoFilter <> '' then
            VendorLedgerEntry.SetRange("Document No.", DocumentNoFilter);

        if PostingDateFromFilter <> 0D then
            VendorLedgerEntry.SetRange("Posting Date", PostingDateFromFilter, PostingDateToFilter);

        // Apply document type filter
        if DocumentTypeFilter <> DocumentTypeFilter::"All" then
            VendorLedgerEntry.SetRange("Document Type", DocumentTypeFilter - 1); // Adjust for "All" option

        if CompanyInfo.Get() then begin
            CompanyName := CompanyInfo.Name;
            CompanyAddress := GetCompanyAddress();
            CompanyPhone := CompanyInfo."Phone No.";
            CompanyFax := CompanyInfo."Fax No.";
            CompanyEmail := CompanyInfo."E-Mail";
#pragma warning disable AL0432
            CompanyHomePage := CompanyInfo."Home Page";
#pragma warning restore AL0432
            SSTRegistration := CompanyInfo."VAT Registration No.";
            CompanyRegNo := CompanyInfo."Registration No.";
        end;

        TotalAmountLCY := 0;
        TotalShowAmount := 0;
    end;

    local procedure CalculateAmountInWords()
    var
        GLSetup: Record "General Ledger Setup";
        CurrencyCodeToUse: Code[10];
        ValueToConvert: Decimal;
        CurrencyPrefix: Text;
    begin
        CurrencyCodeToUse := VendorLedgerEntry."Currency Code";
        if CurrencyCodeToUse = '' then begin
            if GLSetup.Get() then
                CurrencyCodeToUse := GLSetup."LCY Code";
        end;

        ValueToConvert := Abs(VendorLedgerEntry."Amount (LCY)");

        CheckCU.InitTextVariable();
        CheckCU.FormatNoText2(NoText, ValueToConvert, CurrencyCodeToUse);

        AmountInWords := NoText[1] + NoText[2];
    end;

    local procedure GetCompanyAddress(): Text
    var
        CountryRegion: Record "Country/Region";
        CountyRec: Record County;
        CountryName: Text;
        CountyDescription: Text;
    begin
        if CompanyInfo."Country/Region Code" <> '' then
            if CountryRegion.Get(CompanyInfo."Country/Region Code") then
                CountryName := CountryRegion.Name;

        CountyDescription := CompanyInfo.County;
        if CountyDescription <> '' then
            if CountyRec.Get(CountyDescription) then
                CountyDescription := CountyRec.Description;

        exit(
            Format(
                CompanyInfo.Address + ', ' +
                CompanyInfo."Address 2" + ', ' +
                CompanyInfo."Post Code" + ', ' +
                CompanyInfo.City + ', ' +
                CountyDescription + ', ' +
                CountryName
            )
        );
    end;

    local procedure GetVendorAddressFull(): Text
    var
        CountyRec: Record County;
        CountyDescription: Text;
    begin
        CountyDescription := VendorRec.County;
        if CountyDescription <> '' then
            if CountyRec.Get(CountyDescription) then
                CountyDescription := CountyRec.Description;

        exit(Format(
            VendorRec."Post Code" + ', ' +
            VendorRec.City + ', ' +
            CountyDescription + ', ' +
            GetVendorCountryName()
        ));
    end;

    local procedure GetVendorCountryName(): Text
    var
        CountryRegion: Record "Country/Region";
    begin
        if VendorRec."Country/Region Code" <> '' then
            if CountryRegion.Get(VendorRec."Country/Region Code") then
                exit(CountryRegion.Name);

        exit('');
    end;
}