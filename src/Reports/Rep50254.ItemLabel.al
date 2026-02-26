report 50254 "Item Label"
{
    ApplicationArea = All;
    Caption = 'Item Label';
    UsageCategory = Tasks;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/ItemLabel.rdl';
    dataset
    {
        dataitem("Warehouse Receipt Header"; "Warehouse Receipt Header")
        {
            dataitem(Itemlablebuffer; "Item LabelBuffer")
            {
                DataItemLink = "Whse Rcpt No" = field("No.");
                column(ItemNo; Itemlablebuffer."Item No.") { }
                column(Description; Itemlablebuffer.Description) { }
                column(LineNo; Itemlablebuffer."Line No.") { }
                column(Quantity; Itemlablebuffer.Quantity) { }
                column(UOM; Itemlablebuffer.UOM) { }
                column(Brand; Itemlablebuffer.Brand) { }
                column(LotNo; Itemlablebuffer."Lot No.") { }
                column(GTINQRCode; GTINQRCode) { }
                column(CompInfoName; CompInfo.Name) { }
                column(LocationCode; Itemlablebuffer."Location Code") { }
                column(BinCode; Itemlablebuffer."Bin Code") { }
                column(PostingGroup; Itemlablebuffer."Posting Group") { }
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
                        //ItemLabelBufferTemp := ItemLabelBufferTemp;
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

                begin
                    BarcodeString := '';
                    // Declare the barcode provider using the barcode provider interface and enum
                    BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                    BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;

                    // Set data string source 
                    if Itemlablebuffer."Lot No." <> '' then
                        BarcodeString := "Lot No."
                    else
                        BarcodeString := "Item No.";
                    // Validate the input
                    If BarcodeString <> '' then begin
                        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
                        // Encode the data string to the barcode font
                        GTINQRCode := '';
                        GTINBarCode := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
                        GTINQRCode := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);
                    end
                end;
            }
            trigger OnAfterGetRecord()
            var
                WareRecptLine: Record "Warehouse Receipt Line";
                WarseRecptHdr: Record "Warehouse Receipt Header";
                ReservEntry: Record "Reservation Entry";
                Item: Record Item;
                SetRecord: Codeunit "Subscriber";
            begin
                //If NoOfCopies = 0 then
                // Error('No ');
                Itemlablebuffer.DeleteAll();
                WarseRecptHdr := SetRecord.GetWHseRecptHdr();
                WareRecptLine.Reset();
                WareRecptLine.SetRange("No.", "No.");
                If WareRecptLine.FindSet() then
                    repeat
                        ReservEntry.Reset();
                        ReservEntry.SetRange("Source Type", DATABASE::"Purchase Line");
                        ReservEntry.SetRange("Source ID", WareRecptLine."Source No.");
                        ReservEntry.SetRange("Source Ref. No.", WareRecptLine."Line No.");
                        If ReservEntry.FindSet() then begin
                            repeat
                                Itemlablebuffer.Init();
                                Itemlablebuffer."Item No." := WareRecptLine."Item No.";
                                Itemlablebuffer."Line No." := WareRecptLine."Line No.";
                                Itemlablebuffer."Lot No." := ReservEntry."Lot No.";
                                Itemlablebuffer.UOM := WareRecptLine."Unit of Measure Code";
                                Itemlablebuffer."Whse Rcpt No" := WareRecptLine."No.";
                                Itemlablebuffer."Bin Code" := WareRecptLine."Bin Code";
                                Itemlablebuffer."Location Code" := WareRecptLine."Location Code";
                                If Item.Get(WareRecptLine."Item No.") then begin
                                    Itemlablebuffer.Description := Item.Description;
                                    Itemlablebuffer.Brand := Item.Brand;
                                    Itemlablebuffer.Quantity := Item."PM Pack Qty";
                                    Itemlablebuffer."Posting Group" := Item."Item Category Code";
                                end;


                                Itemlablebuffer.Insert();
                            until ReservEntry.Next() = 0;
                        end else begin
                            Itemlablebuffer.Init();
                            Itemlablebuffer."Item No." := WareRecptLine."Item No.";
                            Itemlablebuffer."Line No." := WareRecptLine."Line No.";
                            Itemlablebuffer.UOM := WareRecptLine."Unit of Measure Code";
                            Itemlablebuffer."Whse Rcpt No" := WareRecptLine."No.";
                            Itemlablebuffer."Bin Code" := WareRecptLine."Bin Code";
                            Itemlablebuffer."Lot No." := '';
                            Itemlablebuffer."Location Code" := WareRecptLine."Location Code";
                            If Item.Get(WareRecptLine."Item No.") then begin
                                Itemlablebuffer.Description := Item.Description;
                                Itemlablebuffer.Brand := Item.Brand;
                                Itemlablebuffer.Quantity := Item."PM Pack Qty";
                                Itemlablebuffer."Posting Group" := Item."Item Category Code";
                            end;

                            Itemlablebuffer.Insert();

                        end;
                    until WareRecptLine.Next() = 0;
                Clear(SetRecord);
            end;

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
    // Itemlablebuffer: Record "Item LabelBuffer";

    trigger OnInitReport()
    begin

        CompInfo.Get();
        Itemlablebuffer.DeleteAll();
        BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
    end;

    trigger OnPreReport()
    begin
        Itemlablebuffer.DeleteAll();
    end;

}
