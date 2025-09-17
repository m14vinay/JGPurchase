report 50255 "Official Voucher (Customer)"
{
    ApplicationArea = All;
    Caption = 'Official Voucher (Customer)';
    RDLCLayout = './src/Reports/Layouts/OfficialVoucherCust.rdlc';
    UsageCategory = ReportsAndAnalysis;
    PreviewMode = PrintLayout;
    WordMergeDataItem = CustLedgerEntry;

    dataset
    {
        dataitem(CustLedgerEntry; "Cust. Ledger Entry")
        {
            RequestFilterFields = "Document No.", "Posting Date", "Customer No.", "Document Type";
            DataItemTableView = SORTING("Document Type", "Document No.");

            column(PrintName; CompanyInfo."Print Name") { }
            column(Document_No_; "Document No.") { }
            column(Document_Date; "Posting Date") { }
            column(External_Document_No_; "External Document No.") { }
            column(Customer_No; "Customer No.") { }
            column(Customer_Name; "Customer Name") { }
            column(Amount; Amount) { }
            column(AmountLCY; "Amount (LCY)") { }
            column(description; Description) { }
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
            column(CustName; CustName) { }
            column(CustAddr1; CustAddr1) { }
            column(CustAddr2; CustAddr2) { }
            column(PostCodeCityCountryCountry; CustPostCodeCityCountryCountry) { }
            column(Phone; CustPhone) { }
            column(Mobile; CustMobile) { }
            column(City; CustCity) { }
            column(County; CustCounty) { }
            column(CountryRegionCode; CustCountryRegionCode) { }
            column(HomePage; CustHomePage) { }
            column(CustCurrency_Code; CustCurrencyCode) { }
            column(AmountInWords; AmountInWords) { }
            column(TotalShowAmountCol; TotalShowAmount) { }

            dataitem(AppliedEntries; "Cust. Ledger Entry")
            {
                DataItemLink = "Closed by Entry No." = field("Entry No.");
                DataItemLinkReference = CustLedgerEntry;
                DataItemTableView = where("Closed by Entry No." = filter(<> 0));

                column(Applied_Ext_Document_No_; "External Document No.") { }
                column(Applied_Document_No_; "Document No.") { }
                column(Applied_Document_Date; "Document Date") { }
                column(Applied_Amount; Amount) { }
                column(Applied_Amount__LCY_; "Amount (LCY)") { }
                column(Applied_Description; Description) { }
                column(Applied_Currency_Code; "Currency Code") { }
                column(Applied_Document_Type; "Document Type") { }
                column(Applied_Posting_Date; "Posting Date") { }

                trigger OnAfterGetRecord()
                begin
                    CustLedgerEntry.CalcFields("WHT Amount");
                    WHTAmount := CustLedgerEntry."WHT Amount";
                    ShowAmount := Abs("Amount (LCY)") + Abs(WHTAmount);

                    TotalShowAmount += ShowAmount;

                    // Remove the skip logic since we're now filtering correctly
                    // if "Entry No." = CustLedgerEntry."Entry No." then
                    //     CurrReport.Skip();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TotalShowAmount := 0;

                if CustomerRec.Get("Customer No.") then begin
                    CustName := CustomerRec.Name;
                    CustAddr1 := CustomerRec.Address;
                    CustAddr2 := CustomerRec."Address 2";
                    CustPostCodeCityCountryCountry := GetCustAddressFull();
                    CustPhone := CustomerRec."Phone No.";
                    CustCity := CustomerRec.City;
                    CustCounty := CustomerRec.County;
                    CustCountryRegionCode := CustomerRec."Country/Region Code";
                    CustMobile := CustomerRec."Mobile Phone No.";
#pragma warning disable AL0432
                    CustHomePage := CustomerRec."Home Page";
#pragma warning restore AL0432
                    CustCurrencyCode := CustomerRec."Currency Code";
                end;

                CalculateAmountInWords();
            end;

            trigger OnPostDataItem()
            begin
            end;

        }
    }
    requestpage
    {
        layout { area(Content) { } }
        actions { area(Processing) { } }
    }

    labels { }

    var
        CompanyInfo: Record "Company Information";
        CustomerRec: Record Customer;
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
        AmountCust: Decimal;
        CompanyRegNo: Text[250];
        TotalShowAmount: Decimal;
        ShowAmount: Decimal;
        WHTAmount: Decimal;

        CustName: Text;
        CustAddr1: Text;
        CustAddr2: Text;
        CustPostCodeCityCountryCountry: Text;
        CustPhone: Text;
        CustCity: Text;
        CustCounty: Text;
        CustCountryRegionCode: Text;
        CustMobile: Text;
        CustHomePage: Text;
        CustCurrencyCode: Text;

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
        CurrencyCodeToUse := CustLedgerEntry."Currency Code";
        if CurrencyCodeToUse = '' then begin
            if GLSetup.Get() then
                CurrencyCodeToUse := GLSetup."LCY Code";
        end;

        ValueToConvert := Abs(CustLedgerEntry."Amount (LCY)");

        CheckCU.InitTextVariable();
        CheckCU.FormatNoText2(NoText, ValueToConvert, CurrencyCodeToUse);

        // case CurrencyCodeToUse of
        //     'MYR':
        //         CurrencyPrefix := 'Malaysian Ringgit ';
        //     else
        //         CurrencyPrefix := '';
        // end;
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

    local procedure GetCustAddressFull(): Text
    var
        CountyRec: Record County;
        CountyDescription: Text;
    begin
        CountyDescription := CustomerRec.County;
        if CountyDescription <> '' then
            if CountyRec.Get(CountyDescription) then
                CountyDescription := CountyRec.Description;

        exit(Format(
            CustomerRec."Post Code" + ', ' +
            CustomerRec.City + ', ' +
            CountyDescription + ', ' +
            GetCustCountryName()
        ));
    end;

    local procedure GetCustCountryName(): Text
    var
        CountryRegion: Record "Country/Region";
    begin
        if CustomerRec."Country/Region Code" <> '' then
            if CountryRegion.Get(CustomerRec."Country/Region Code") then
                exit(CountryRegion.Name);

        exit('');
    end;
}

