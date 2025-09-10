report 50251 "Price Comparison"
{
    ApplicationArea = All;
    Caption = 'Price Comparison';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    PreviewMode = PrintLayout;
    RDLCLayout = './src/Reports/Layouts/PriceComparison.rdl';
    dataset
    {
        dataitem(PriceComparisonHeader; "Price Comparison Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No; "No.")
            {
            }
            column(CreationDate; "Creation Date")
            {
            }
            column(PRNo; "PR No.")
            {
            }
            column(Remarks; Remarks)
            {
            }
            column(ReqDepartment; "Req Department")
            {
            }
            column(Status; Status)
            {
            }
            column(TypeofItem; "Type of Item")
            {
            }
            column(TypeofPurchase; "Type of Purchase")
            {
            }
            column(LocalPurchase; LocalPurchase) { }
            column(NewItem; NewItem) { }
            column(CompInfoName; CompInfo.Name) { }
            dataitem(PriceComparisonLine; "Price Comparison Line")
            {
                DataItemTableView = sorting("Item No.");
                DataItemLink = "Document No." = field("No.");
                column(ItemNo; PriceComparisonLine."Item No.")
                {
                }
                column(VendorNo; PriceComparisonLine."Vendor No.")
                {
                }
                column(VendorName; PriceComparisonLine."Vendor Name")
                {
                }
                column(ItemQuantity; PriceComparisonLine.Quantity)
                {
                }
                column(ItemDescription; PriceComparisonLine."Item Description")
                {
                }
                column(UnitPrice; PriceComparisonLine."Unit Cost Excl SST")
                {
                }
                column(LineAmount; PriceComparisonLine."Line Amount")
                {
                }
                column(PaymentTerms; PriceComparisonLine."Payment Terms Code")
                {
                }
                column(Validity; PriceComparisonLine."Quote Valid Until Date")
                {
                }
                column(Delivery; PriceComparisonLine."Delivery Date")
                {
                }
                column(LastPurchasePrice; LastPurchasePrice)
                {
                }
                column(DiscountAmount; PriceComparisonLine."Line Discount Amount")
                {
                }
                column(SSTAmount; PriceComparisonLine."SST Amount")
                {
                }
                column(Type; PriceComparisonLine.Type)
                {
                }
                column(GrandTotal; "SST Amount" + "Line Amount" - "Line Discount Amount")
                {
                }
                column(ShowChargeItems; ShowChargeItems)
                {
                }
                column(Vendor_Selected; vendorselected)
                {
                }
                column(LineNo; PriceComparisonLine."Line No.")
                {
                }
                trigger OnAfterGetRecord()
                begin
                    Clear(vendorselected);
                    Clear(PaymentTerms);
                    Clear(ShowChargeItems);
                    Clear(Validity);
                    Clear(Delivery);
                    Clear(LastPurchasePrice);
                    If ItemRec.Get("Item No.") then
                        LastPurchasePrice := ItemRec."Last Direct Cost";

                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
                    SalesHeader.SetRange("No.", PriceComparisonLine."Purchase Quote No.");
                    If SalesHeader.FindFirst() then begin
                        PaymentTerms := SalesHeader."Payment Terms Code";
                        Validity := SalesHeader."Quote Valid Until Date";
                        Delivery := SalesHeader."Shipment Method Code";

                    end;
                    GrandTotal += "SST Amount" + "Line Amount" - "Line Discount Amount";
                    If Type <> Type::Item then
                        ShowChargeItems := True;
                    PricComLine.Reset();
                    PricComLine.SetRange("Document No.",PriceComparisonLine."Document No.");
                    PricComLine.SetRange("Item No.", PriceComparisonLine."Item No.");
                    PricComLine.SetRange("Vendor Selected", true);
                    If PricComLine.FindFirst() then
                        vendorselected := PricComLine."Vendor Name";
                end;
            }
            trigger OnAfterGetRecord()
            begin
                LocalPurchase := false;
                NewItem := false;
                If "Type of Purchase" = "Type of Purchase"::Local then
                    LocalPurchase := true;
                if "Type of Item" = "Type of Item"::New then
                    NewItem := true;
                CompInfo.Get();
            end;

        }

    }
    var

        ItemRec: Record Item;
        SalesHeader: Record "Sales Header";
        CompInfo: Record "Company Information";
        PricComLine: Record "Price Comparison Line";
        GrandTotal: Decimal;
        LocalPurchase: Boolean;
        NewItem: Boolean;
        LastPurchasePrice: Decimal;
        PaymentTerms: Code[20];
        Validity: Date;
        Delivery: Code[20];
        ShowChargeItems: Boolean;
        vendorselected: text[100];

}
