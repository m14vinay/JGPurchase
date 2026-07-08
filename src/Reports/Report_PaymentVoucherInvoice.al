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
            RequestFilterFields = "Document No.";
            column(PrintName; CompanyInfo."Print Name")
            {
            }
            column(InstrumentDate; "Gen. Journal Line"."Posting Date")
            {
            }
            column(Posting_Date; "Gen. Journal Line"."Posting Date")
            {
            }
            column(Currrency; "Gen. Journal Line"."Currency Code") { }

            column(InstrumentNumber; "Gen. Journal Line"."Payment Reference")
            {
            }
            column(RecepeintBankAccount; "Gen. Journal Line"."Recipient Bank Account")
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
            column(Document_Date; "Document Date")
            {
            }
            column(InvoiceDate; InvoiceDate)
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
            column(CurrencyName; GetCurrencyNames("Currency Code"))
            {
            }
            column(AmountInWords; AmountInWords)
            {
            }
            column(TotalShowAmount; Amount)
            {
            }
            column(Account_No_; "Actual Vendor No.")
            {
            }
            column(Comment; Comment)
            {
            }
            column(Account_Type; "Account Type")
            {
            }
            column(Name; Name) { }
            column(Address1; Address1) { }
            column(Adress2; Adress2) { }
            column(PostCodeCityCounty; PostCodeCityCounty) { }
            column(PhoneNo; PhoneNo) { }
            column(MobilePhoneNo; MobilePhoneNo) { }
            dataitem(VendLedgEntry1; "Vendor Ledger Entry")
            {
                DataItemLink = "Applies-to ID" = field("Applies-to ID"), "Vendor No." = field("Account No.");
                DataItemLinkReference = "Gen. Journal Line";
                DataItemTableView = sorting("Entry No.");
                column(EXTDocumentNo; "External Document No.") { }
                column(DocumentNo; "Document No.") { }
                column(DocumentDate; "Document Date") { }
                column(InvoiceAmount; ABS(VendLedgEntry1."Original Amount")) { }
                column(PaidAmount; ABS(VendLedgEntry1."Amount to Apply")) { }
                column(DescriptionVLE; Description) { }
                column(VendorShow; VendorShow) { }
                trigger OnAfterGetRecord()
                begin
                    VendLedgEntry1.CalcFields("Original Amount");
                    VendorShow := True;
                end;

                trigger OnPreDataItem()
                begin
                    VendLedgEntry1.SetFilter("Applies-to ID", '<>%1', '');
                    VendorShow := false;
                end;
            }
            dataitem(CustLedgerEntry; "Cust. Ledger Entry")
            {
                DataItemLink = "Applies-to ID" = field("Applies-to ID"), "Customer No." = field("Account No.");
                DataItemLinkReference = "Gen. Journal Line";
                DataItemTableView = sorting("Entry No.");
                column(CustExtDocNo; "External Document No.") { }
                column(CustDocumentNo; "Document No.") { }
                column(CustDocumentDate; "Document Date") { }
                column(CustInvoiceAmount; ABS(CustLedgerEntry."Original Amount")) { }
                column(CustPaidAmount; ABS(CustLedgerEntry."Amount to Apply")) { }
                column(CustDescription; Description) { }
                column(CustShow; CustShow) { }
                trigger OnAfterGetRecord()
                begin
                    CustLedgerEntry.CalcFields("Original Amount");
                    CustShow := True;
                end;

                trigger OnPreDataItem()
                begin
                    CustLedgerEntry.SetFilter("Applies-to ID", '<>%1', '');
                    CustShow := false;
                end;
            }


            trigger OnAfterGetRecord()
            var
                vendorLedgerEntry: Record "Vendor Ledger Entry";
                GenJournLine: Record "Gen. Journal Line";
            begin

                Clear(AmountInWords);
                Clear(ShowAmount);
                if not Currency.Get("Currency Code") then
                    Currency.InitRoundingPrecision();

                GenJournLine.Reset();
                GenJournLine.SetRange("Journal Template Name", "Gen. Journal Line"."Journal Template Name");
                GenJournLine.SetRange("Journal Batch Name", "Gen. Journal Line"."Journal Batch Name");
                GenJournLine.SetRange("Document No.", "Gen. Journal Line"."Document No.");
                If GenJournLine.FindSet() then
                    repeat
                        ShowAmount += GenJournLine.Amount;
                    until GenJournLine.Next() = 0;
                //ShowAmount := "Gen. Journal Line"."Amount";
                CodeCheck.InitTextVariable();
                CodeCheck.FormatNoText(NoText, ShowAmount, "Currency Code");
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
                If "Account Type" = "Account Type"::Vendor then begin
                    If vendorRec.Get("Account No.") then;
                    Name := vendorRec.Name;
                    Address1 := vendorRec.Address;
                    Adress2 := vendorRec."Address 2";
                    PostCodeCityCounty := vendorRec."Post Code" + ', ' + vendorRec.City + ', ' + GetCountyName(vendorRec.County) + ', ' + GetCountryName(vendorRec."Country/Region Code");
                    PhoneNo := vendorRec."Phone No.";
                    MobilePhoneNo := vendorRec."Mobile Phone No.";
                end;
                If "Account Type" = "Account Type"::Customer then begin
                    If CustomerRec.Get("Account No.") then;
                    Name := CustomerRec.Name;
                    Address1 := CustomerRec.Address;
                    Adress2 := CustomerRec."Address 2";
                    PostCodeCityCounty := CustomerRec."Post Code" + ', ' + CustomerRec.City + ', ' + GetCountyName(CustomerRec.County) + ', ' + GetCountryName(CustomerRec."Country/Region Code");
                    PhoneNo := CustomerRec."Phone No.";
                    MobilePhoneNo := CustomerRec."Mobile Phone No.";
                end;



            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                FormatAddr.Company(CompanyAddr, CompanyInfo);
                begin


                    CompanyCountry := GetCountryName(CompanyInfo."Country/Region Code");
                    CompanyCounty := GetCountyName(CompanyInfo."County");
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
        CurrencyNameValue: Text[50];
        VendorShow: Boolean;
        CustShow: Boolean;
        Name: Text[100];
        Address1: Text[100];
        Adress2: Text[100];
        PostCodeCityCounty: Text[150];
        vendorRec: Record Vendor;
        CustomerRec: Record Customer;
        PhoneNo: Text[30];
        MobilePhoneNo: Text[30];

    local procedure CurrencyCode(SrcCurrCode: Code[10]): Code[10]
    begin
        if SrcCurrCode = '' then
            exit(GLSetup."LCY Code")
        else
            exit(SrcCurrCode);
    end;

    procedure GetCurrencyNames(CurencyCode: Code[20]): Text
    begin
        case CurencyCode of
            ' ':
                exit('Malaysian Ringgit');
            'USD':
                exit('United States Dollar');
            'EUR':
                exit('Euro');
            'GBP':
                exit('British Pound');
            'SGD':
                exit('Singapore Dollar');
            'AUD':
                exit('Australian Dollar');
            'CAD':
                exit('Canadian Dollar');
            'JPY':
                exit('Japanese Yen');
            'CNY':
                exit('Chinese Yuan');
            'HKD':
                exit('Hong Kong Dollar');
            'IDR':
                exit('Indonesian Rupiah');
            'THB':
                exit('Thai Baht');
            'PHP':
                exit('Philippine Peso');
            'INR':
                exit('Indian Rupee');
        end; // Returns the code if not listed above
    end;

    procedure GetCountryName(Countryname: Code[30]): Text[50]
    var
        CountryRegion: Record "Country/Region";
    begin
        if CountryRegion.Get(Countryname) then
            Exit(CountryRegion.Name);
    end;

    procedure GetCountyName(Countyname: Code[30]): Text[50]
    var
        County: Record "County";
    begin
        if County.Get(Countyname) then
            Exit(County.Description);
    end;

}