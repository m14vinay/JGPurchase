report 50257 "GL Voucher Report (DEV)"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'GL Voucher Report';
    RDLCLayout = './src/Reports/Layouts/GLV3.rdlc';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING("Document No.", "Posting Date");
            RequestFilterFields = "Document No.", "Posting Date", "Document Type", "Source Code";

            column(Document_No_; "Document No.") { }
            column(Description; Description) { }
            column(Amount; Amount) { }
            column(Posting_Date; "Posting Date") { }
            column(G_L_Account_No_; "G/L Account No.") { }
            column(G_L_Account_Name; "G/L Account Name") { }
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(CompanyInfo_Name; CompanyInfo.Name) { }
            column(CompanyInfo_Address; CompanyInfo.Address) { }
            column(CompanyInfo_Address2; CompanyInfo."Address 2") { }
            column(CompanyInfo_City; CompanyInfo.City) { }
            column(CompanyInfo_PostCode; CompanyInfo."Post Code") { }
            column(CompanyInfo_Phone; CompanyInfo."Phone No.") { }
            column(CompanyInfo_Fax; CompanyInfo."Fax No.") { }
            column(CompanyInfo_Email; CompanyInfo."E-Mail") { }
            column(CompanyInfo_GST; CompanyInfo."Industrial Classification") { }
            column(CompanyInfo_CoRegNo; CompanyInfo."VAT Registration No.") { }
            column(CompanyLogo1; CompanyInfo."Company Logo 1") { }
            column(CompanyLogo2; CompanyInfo."Company Logo 2") { }
            column(CompanyLogo3; CompanyInfo."Company Logo 3") { }
            column(AmountInWord; AmountInWord) { }
            column(Grand_Total; Grand_Total) { }
            column(Credit_Amount; "Credit Amount") { }
            column(Debit_Amount; "Debit Amount") { }
            column(Department_Name; DepartmentName) { }

            trigger OnAfterGetRecord()
            begin
                Clear(DepartmentName);
                if "Global Dimension 1 Code" <> '' then
                    if DimValue.Get('DEPARTMENT', "Global Dimension 1 Code") then
                        DepartmentName := DimValue.Name;

                Clear(Check2);
                Check2.InitTextVariable;
                Check2.FormatNoText(NoText, (Grand_Total), '');
                AmountInWord := NoText[1] + ' ' + NoText[2];
            end;

            trigger OnPostDataItem()
            begin
                GL2.Reset();
                GL2.SetRange("Document No.", "G/L Entry"."Document No.");
                if GL2.FindSet() then
                    repeat
                        Grand_Total += GL2.Amount;
                    until GL2.Next() = 0;
            end;

            trigger OnPreDataItem()
            begin
                // Check if Document Type filter is not set, then filter by empty Document Type AND Source Code = GENJNL
                if GetFilter("Document Type") = '' then begin
                    SetRange("Document Type", "Document Type"::" ");  // Filter for empty/null document type
                    SetRange("Source Code", 'GENJNL');
                end;
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    labels
    {
        PageCaption = 'Page';
        Date_ = 'Date                :';
        Remark = 'Remark    :';
        Total = 'TOTAL';
        PreparedBy = 'Prepared By    :';
        AuthorisedSignatory = 'Authorised Signatory';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        CompanyInfo.CALCFIELDS("Company Logo 1");
        CompanyInfo.CALCFIELDS("Company Logo 2");
        CompanyInfo.CALCFIELDS("Company Logo 3");
        CompanyInfo.CALCFIELDS(Picture);
        GLSetup.Get();
    end;

    var
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        DepartmentName: Text[100];
        // Check2: Report Check3;
        Check2: Codeunit 50252;
        NoText: array[2] of Text;
        AmountInWord: Text[250];
        currencies: Record Currency;
        CurrencyDesc: Text[30];
        Grand_Total: Decimal;
        SR_NO: Integer;
        GL2: Record "G/L Entry";

    local procedure CurrencyCode(SrcCurrCode: Code[10]): Code[10]
    begin
        if SrcCurrCode = '' then
            exit(GLSetup."LCY Code");
        exit(SrcCurrCode);
    end;

    local procedure CurrencyDescription(SrcCurrDesc: Text[60]): Text[60]
    begin
        if SrcCurrDesc = '' then
            exit(GLSetup."Local Currency Description");
        exit(SrcCurrDesc);
    end;
}