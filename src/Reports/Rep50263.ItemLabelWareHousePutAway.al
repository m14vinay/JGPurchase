report 50263 "ItemLabelWareHousePutAway"
{
    ApplicationArea = All;
    Caption = 'Item Label Ware.House Put Away';
    UsageCategory = Tasks;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/ItemLabelWareHousePutAway.rdl';
    dataset
    {
        dataitem("Warehouse Activity Header"; "Warehouse Activity Header")
        {
            dataitem("Warehouse Activity Line"; "Warehouse Activity Line")
            {
                DataItemLink = "No." = field("No.");
                DataItemTableView = sorting("Action Type") where("Action Type" = filter(Place));
                column(ItemNo; "Warehouse Activity Line"."Item No.") { }
                column(Description; "Warehouse Activity Line".Description) { }
                column(LineNo; "Warehouse Activity Line"."Line No.") { }
                column(Quantity; "Warehouse Activity Line".Quantity) { }
                column(UOM; "Warehouse Activity Line"."Unit of Measure Code") { }
                column(Brand; Brand) { }
                column(PostingGroup; PostingGroup) { }
                column(PackSize; PackSize) { }
                column(LotNo; "Warehouse Activity Line"."Lot No.") { }
                column(GTINQRCode; GTINQRCode) { }
                column(CompInfoName; CompInfo.Name) { }
                column(LocationCode; "Warehouse Activity Line"."Location Code") { }
                column(BinCode; "Warehouse Activity Line"."Bin Code") { }
                dataitem(CopyLoop; "Integer")
                {
                    DataItemTableView = sorting(Number);

                    dataitem(PageLoop; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));
                        column(OutputNo; OutputNo) { }
                    }
                    trigger OnAfterGetRecord()
                    begin
                        OutputNo := OutputNo + 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        NoOfLoops := Abs(NoOfCopies);
                        CopyText := '';
                        SetRange(Number, 1, NoOfLoops);
                        OutputNo := 0;
                    end;
                }
                trigger OnAfterGetRecord()
                var
                    BarcodeString: Text;
                    BarcodeFontProvider: Interface "Barcode Font Provider";
                    BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
                    item: Record Item;
                begin
                    Clear(Brand);
                    Clear(PackSize);
                    Clear(PostingGroup);
                    // Declare the barcode provider using the barcode provider interface and enum
                    BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                    BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;

                    // Set data string source 
                    if "Lot No." <> '' then
                        BarcodeString := "Lot No."
                    else
                        BarcodeString := "Warehouse Activity Line"."Item No.";
                    // Validate the input
                    If BarcodeString <> '' then begin
                        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
                        // Encode the data string to the barcode font
                        GTINBarCode := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
                        GTINQRCode := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);
                    end;
                    if item.Get("Warehouse Activity Line"."Item No.") then begin
                        Brand := item.Brand;
                        PackSize := Item."PM Pack Qty";
                        PostingGroup := Item."Item Category Code";
                    end;
                end;
            }
        }
    }


    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoofCopies;
                    NoOfCopies)
                    {
                        ApplicationArea = Suite;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies how many copies of the label to print.';
                    }
                }
            }
        }
    }
    var
        Brand: Text;
        PackSize : Integer;
        PostingGroup : Code[20];
        NoOfCopies: Integer;
        ItemQuantity: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        OutputNo: Integer;
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        GTINBarCode: Text;
        GTINQRCode: Text;
        ItemLabelBufferTemp: Record "Item LabelBuffer" temporary;
        CompInfo: Record "Company Information";

    trigger OnInitReport()
    begin

        CompInfo.Get();
        BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
    end;

}
