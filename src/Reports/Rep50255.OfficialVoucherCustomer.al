report 50255 "Official Voucher (Customer)"
{
    ApplicationArea = All;
    Caption = 'Official Voucher (Customer)';
    RDLCLayout = './src/Reports/Layouts/OfficialVoucherCust.rdl';
    UsageCategory = ReportsAndAnalysis;
    PreviewMode = PrintLayout;
    WordMergeDataItem = CustLedgerEntry;

    dataset
    {
        dataitem(CustLedgerEntry; "Cust. Ledger Entry")
        {
            RequestFilterFields = "Document No.", "Posting Date", "Customer No.", "Document Type";
            DataItemTableView = SORTING("Document Type", "Document No.") WHERE("Document Type" = CONST(Payment));
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
            column(TINNoCol; TINNo) { }
            column(Document_Type; "Document Type") { }
            column(Currency_Code; "Currency Code") { }
            column(TotalAmountLCY; TotalAmountLCY) { }
            column(Payment_Reference; "Payment Reference") { }
            column(PaymentMethodCode; PaymentMethodCode) { }
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

            // Pattern 1: Find entries that were applied TO this payment (e.g., invoice applied to payment)
            // This is like DetailedCustLedgEntry1 in Report 211
            dataitem(DetailedCustLedgEntry1; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Applied Cust. Ledger Entry No." = field("Entry No.");
                DataItemLinkReference = CustLedgerEntry;
                DataItemTableView = sorting("Applied Cust. Ledger Entry No.", "Entry Type") where(Unapplied = const(false));

                dataitem(AppliedEntries1; "Cust. Ledger Entry")
                {
                    DataItemLink = "Entry No." = field("Cust. Ledger Entry No.");
                    DataItemLinkReference = DetailedCustLedgEntry1;
                    DataItemTableView = sorting("Entry No.");

                    column(Applied_Ext_Document_No_; "External Document No.") { }
                    column(Applied_Document_No_; "Document No.") { }
                    column(Applied_Document_Date; "Document Date") { }
                    column(Applied_Amount; AppliedAmount) { }
                    column(Applied_Amount__LCY_; AppliedAmountLCY) { }
                    column(OriginalAmount; "Original Amount") { }
                    column(Applied_Description; Description) { }
                    column(Applied_Currency_Code; "Currency Code") { }
                    column(Applied_Document_Type; "Document Type") { }
                    column(Applied_Posting_Date; "Posting Date") { }

                    trigger OnAfterGetRecord()
                    var

                    begin

                        // Skip if this is the same entry as the payment itself
                        if "Entry No." = CustLedgerEntry."Entry No." then
                            CurrReport.Skip();

                        // Get the applied amount from the detailed entry (negative because direction)
                        AppliedAmount := -DetailedCustLedgEntry1.Amount;
                        AppliedAmountLCY := -DetailedCustLedgEntry1."Amount (LCY)";

                        CustLedgerEntry.CalcFields("WHT Amount");
                        WHTAmount := CustLedgerEntry."WHT Amount";
                        ShowAmount := Abs(AppliedAmount) + Abs(WHTAmount);

                        TotalShowAmount += ShowAmount;
                    end;

                    trigger OnPreDataItem()
                    begin
                        Clear(AppliedAmount);
                        Clear(OrigAmnt);
                    end;
                }
            }

            // Pattern 2: Find entries this payment was applied TO (e.g., payment applied to invoice)
            // This is like DetailedCustLedgEntry2 in Report 211
            dataitem(DetailedCustLedgEntry2; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Cust. Ledger Entry No." = field("Entry No.");
                DataItemLinkReference = CustLedgerEntry;
                DataItemTableView = sorting("Cust. Ledger Entry No.", "Entry Type", "Posting Date") where(Unapplied = const(false));

                dataitem(AppliedEntries2; "Cust. Ledger Entry")
                {
                    DataItemLink = "Entry No." = field("Applied Cust. Ledger Entry No.");
                    DataItemLinkReference = DetailedCustLedgEntry2;
                    DataItemTableView = sorting("Entry No.");

                    // Use same column names - they will merge into the same dataset
                    column(Applied_Ext_Document_No_2; "External Document No.") { }
                    column(Applied_Document_No_2; "Document No.") { }
                    column(Applied_Document_Date_2; "Document Date") { }
                    column(Applied_Amount_2; AppliedAmount) { }
                     column(OriginalAmount2; OrigAmnt) { }
                    column(Applied_Amount__LCY__2; AppliedAmountLCY) { }
                    column(Applied_Description_2; Description) { }
                    column(Applied_Currency_Code_2; "Currency Code") { }
                    column(Applied_Document_Type_2; "Document Type") { }
                    column(Applied_Posting_Date_2; "Posting Date") { }

                    trigger OnAfterGetRecord()
                    begin
                        // Skip if this is the same entry as the payment itself

                        if "Entry No." = CustLedgerEntry."Entry No." then
                            CurrReport.Skip();

                        // Get the applied amount from the detailed entry
                        AppliedAmount := DetailedCustLedgEntry2.Amount;
                        AppliedAmountLCY := DetailedCustLedgEntry2."Amount (LCY)";

                        CustLedgerEntry.CalcFields("WHT Amount");
                        WHTAmount := CustLedgerEntry."WHT Amount";
                        ShowAmount := Abs(AppliedAmount) + Abs(WHTAmount);

                        TotalShowAmount += ShowAmount;
                    end;
                }
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

                // Get Payment Method Code
                PaymentMethodCode := GetPaymentMethodCode();
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
        OrigAmnt: Decimal;
        TINNo: Text[250];
        PaymentMethodCode: Text[250];
        CheckCU: Codeunit 50252;
        NoText: array[2] of Text[80];
        AmountInWords: Text[250];
        AmountCust: Decimal;
        CompanyRegNo: Text[250];
        TotalShowAmount: Decimal;
        ShowAmount: Decimal;
        WHTAmount: Decimal;
        AppliedAmount: Decimal;
        AppliedAmountLCY: Decimal;
        CustLedgEntryOrig: Record "Cust. Ledger Entry";
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
            SSTRegistration := CompanyInfo."ADY E-INV SST Reg No.";
            TINNo := CompanyInfo."ADY E-INV TIN No.";
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
        if CustLedgerEntry."Currency Code" = '' then begin
            if GLSetup.Get() then
                CurrencyCodeToUse := GLSetup."LCY Code";
        end;

        ValueToConvert := Abs(CustLedgerEntry."Amount (LCY)");

        CheckCU.InitTextVariable();
        CheckCU.FormatNoText(NoText, ValueToConvert, CurrencyCodeToUse);

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
                CompanyInfo."Post Code" + ' ' +
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

    local procedure GetPaymentMethodCode(): Text
    var
        PaymentMethod: Record "Payment Method";
    begin
        if CustLedgerEntry."Payment Method Code" <> '' then begin
            if PaymentMethod.Get(CustLedgerEntry."Payment Method Code") then
                exit(PaymentMethod.Description)
            else
                exit(CustLedgerEntry."Payment Method Code");
        end;
        exit('');
    end;
}

