report 50258 "Goods Receipt Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Goods Receipt Report';
    DefaultLayout = RDLC;
    PreviewMode = PrintLayout;
    RDLCLayout = './src/Reports/Layouts/GoodsReceipt.rdl';

    dataset
    {
        dataitem(PurchRcptHeader; "Purch. Rcpt. Header")
        {
            RequestFilterFields = "No.", "Buy-from Vendor No.", "Document Date";
            column(PrintName; CompanyInfo."Print Name")
            {
            }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyAddress) { }
            column(CompanyPhone; CompanyInfo."Phone No.") { }
            column(CompanyFax; CompanyInfo."Fax No.") { }
            column(CompanyEmail; CompanyInfo."E-Mail") { }
            column(CompanySSTReg; CompanyInfo."Registration No.") { }
            column(CompanyLogo1; CompanyInfo.Picture) { }
            column(CompanyLogo2; CompanyInfo."Company Logo 1") { }
            column(CompanyLogo3; CompanyInfo."Company Logo 2") { }
            column(CompanyLogo4; CompanyInfo."Company Logo 3") { }
            column(CompanyRegNo; CompanyInfo."Registration No.") { }
            column(ReportTitle; 'Goods Receipt') { }
            column(SupplierAddressLabel; 'Supplier Address:') { }


            column(DocumentNo; PurchRcptHeader."No.") { }
            column(DocumentDate; PurchRcptHeader."Document Date") { }
            column(OrderNo; PurchRcptHeader."Order No.") { }
            column(PurchaseDocumentDate; PurchaseDocumentDate) { }
            column(Remarks; remarks) { }
            column(BuyFromVendorNo; PurchRcptHeader."Buy-from Vendor No.") { }
            column(BuyFromVendorName; PurchRcptHeader."Buy-from Vendor Name") { }
            column(VendorShipmentNo; PurchRcptHeader."Vendor Shipment No.") { }
            column(VendorAddress; VendorAddress) { }
            column(VendorName_Lookup; VendorName_Lookup) { }
            column(VendorAddress_Lookup; VendorAddress_Lookup) { }
            column(VendorFaxNo_Lookup; VendorFaxNo_Lookup) { }
            column(CompanyHomePage_Lookup; CompanyHomePage_Lookup) { }

            dataitem(PurchRcptLine; "Purch. Rcpt. Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") where(Type = filter(<> ' '));

                column(LineNo; LineNo) { }
                column(ItemNo; PurchRcptLine."No.") { }
                column(Description; PurchRcptLine.Description) { }
                column(UOM; PurchRcptLine."Unit of Measure Code") { }
                column(POQuantity; PurchaseQuantity) { }
                column(ReceivedQuantity; PurchRcptLine.Quantity) { }
                column(LocationCode; PurchRcptLine."Location Code") { }

                trigger OnAfterGetRecord()
                begin
                    LineNo += 1;
                    GetPurchaseQuantity();
                end;

                trigger OnPreDataItem()
                begin
                    LineNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                GetCompanyInfo();
                GetVendorInfo();
                GetPurchaseHeaderInfo();
            end;
        }
    }

    trigger OnInitReport()
    begin
        GetCompanyInfo();
        CompanyInfo.SetAutoCalcFields(Picture);
        CompanyInfo.SetAutoCalcFields("Company Logo 1");
        CompanyInfo.SetAutoCalcFields("Company Logo 2");
        CompanyInfo.SetAutoCalcFields("Company Logo 3");
    end;

    var
        CompanyInfo: Record "Company Information";
        Vendor: Record Vendor;
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        CountryRegion: Record "Country/Region";
        PurchOrderArchiveHeader: Record "Purchase Header Archive";
        PurchOrderArchiveLine: Record "Purchase Line Archive";
        CompanyAddress: Text;
        VendorAddress: Text;
        VendorName_Lookup: Text;
        CompanyHomePage_Lookup: Text[250];
        VendorAddress_Lookup: Text;
        VendorFaxNo_Lookup: Text;
        PurchaseDocumentDate: Date;
        PurchaseQuantity: Decimal;
        LineNo: Integer;
        ShowSignatoryBox: Boolean;

    local procedure GetCompanyInfo()
    begin
        if not CompanyInfo.Get() then
            CompanyInfo.Init();

        CompanyAddress := CompanyInfo.Address;
#pragma warning disable AL0432
        CompanyHomePage_Lookup := CompanyInfo."Home Page";
#pragma warning restore AL0432
        if CompanyInfo."Address 2" <> '' then
            CompanyAddress += ', ' + CompanyInfo."Address 2";
        if CompanyInfo."Post Code" <> '' then
            CompanyAddress += ', ' + CompanyInfo."Post Code";
        if CompanyInfo.City <> '' then
            CompanyAddress += ', ' + CompanyInfo.City;
        if CompanyInfo."Country/Region Code" <> '' then begin
            if CountryRegion.Get(CompanyInfo."Country/Region Code") then
                CompanyAddress += ', ' + CountryRegion.Name;
        end;
    end;

    local procedure GetVendorInfo()
    begin
        if Vendor.Get(PurchRcptHeader."Buy-from Vendor No.") then begin

            VendorName_Lookup := Vendor.Name;
            VendorFaxNo_Lookup := Vendor."Fax No.";
            VendorAddress_Lookup := Vendor.Address;
            if Vendor."Address 2" <> '' then
                VendorAddress_Lookup += ', ' + Vendor."Address 2";
            if Vendor."Post Code" <> '' then
                VendorAddress_Lookup += ', ' + Vendor."Post Code";
            if Vendor.City <> '' then
                VendorAddress_Lookup += ', ' + Vendor.City;
            if Vendor.County <> '' then
                VendorAddress_Lookup += ', ' + Vendor.County;
            if Vendor."Country/Region Code" <> '' then begin
                if CountryRegion.Get(Vendor."Country/Region Code") then
                    VendorAddress_Lookup += ', ' + CountryRegion.Name;
            end;
        end;

        VendorAddress := PurchRcptHeader."Buy-from Address";
        if PurchRcptHeader."Buy-from Address 2" <> '' then
            VendorAddress += ', ' + PurchRcptHeader."Buy-from Address 2";
        if PurchRcptHeader."Buy-from Post Code" <> '' then
            VendorAddress += ', ' + PurchRcptHeader."Buy-from Post Code";
        if PurchRcptHeader."Buy-from City" <> '' then
            VendorAddress += ', ' + PurchRcptHeader."Buy-from City";
        if PurchRcptHeader."Buy-from County" <> '' then
            VendorAddress += ', ' + PurchRcptHeader."Buy-from County";
        if PurchRcptHeader."Buy-from Country/Region Code" <> '' then begin
            if CountryRegion.Get(PurchRcptHeader."Buy-from Country/Region Code") then
                VendorAddress += ', ' + CountryRegion.Name;
        end;
    end;

    local procedure GetPurchaseHeaderInfo()
    begin
        if PurchRcptHeader."Order No." <> '' then begin
            // Get from Purchase Order Archive using PurchRcptHeader.No
            PurchaseHeader.Reset();
            PurchaseHeader.SetRange("No.", PurchRcptHeader."Order No.");
            if PurchaseHeader.FindFirst() then
                PurchaseDocumentDate := PurchaseHeader."Document Date"
            else begin
                PurchOrderArchiveHeader.Reset();
                PurchOrderArchiveHeader.SetRange("No.", PurchRcptHeader."Order No.");
                if PurchOrderArchiveHeader.FindFirst() then
                    PurchaseDocumentDate := PurchOrderArchiveHeader."Document Date"
                else
                    PurchaseDocumentDate := 0D;
            end;


        end;
    end;

    local procedure GetPurchaseQuantity()
    begin
        if PurchRcptHeader."Order No." <> '' then begin
            // Get from Purchase Order Archive using PurchOrderArchiveHeader.No
            PurchaseLine.Reset();
            PurchaseLine.SetRange("Document No.", PurchRcptHeader."Order No.");
            PurchaseLine.SetRange("Line No.", PurchRcptLine."Order Line No.");
            if PurchaseLine.FindFirst() then
                PurchaseQuantity := PurchaseLine.Quantity
            else begin
                PurchOrderArchiveHeader.Reset();
                PurchOrderArchiveHeader.SetRange("No.", PurchRcptHeader."Order No.");
                if PurchOrderArchiveHeader.FindFirst() then begin
                    PurchOrderArchiveLine.Reset();
                    PurchOrderArchiveLine.SetRange("Document No.", PurchOrderArchiveHeader."No.");
                    PurchOrderArchiveLine.SetRange("Line No.", PurchRcptLine."Line No.");
                    if PurchOrderArchiveLine.FindFirst() then
                        PurchaseQuantity := PurchOrderArchiveLine.Quantity
                    else
                        PurchaseQuantity := 0;
                end;

            end;
        end;
    end;
}
