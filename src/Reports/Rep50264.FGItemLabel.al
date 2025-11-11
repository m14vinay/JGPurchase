report 50264 "FG Item Label"
{
    ApplicationArea = All;
    Caption = 'FG Item Label';
    UsageCategory = Tasks;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/FGItemLabel.rdl';
    dataset
    {
        dataitem("FG Item Label"; "FG Item Label")
        {
            column(ItemNo; ItemNo) { }
            column(Description; "FG Item Label".Description) { }
            column(Pack_Size; "FG Item Label"."Pack Size") { }
            column(Production_Date; "FG Item Label"."Production Date") { }
            column(Recording_Slip_No; "FG Item Label"."Recording Slip No") { }
            column(GTINQRCode; GTINQRCode) { }
            column(CompInfoName; CompInfo.Name) { }
            column(EntryNo; "Entry No") { }
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
            begin
                // Declare the barcode provider using the barcode provider interface and enum
                BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                PackSizeString := '-' + "Pack Size";
                
                Evaluate(ItemNo,"Item No.");
                ItemNo := ItemNo.Replace(PackSizeString ,'');
                // Set data string source 
                if "Item No." <> '' then begin
                    BarcodeString := Format(ItemNo) + '-' + Format("Pack Size") + '-' + Format("Production Date", 0, '<Day,2>/<Month,2>/<Year4>') + '-' + Format("Recording Slip No");
                    BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
                    // Encode the data string to the barcode font
                    GTINBarCode := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
                    GTINQRCode := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);
                end;
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
        ItemNo : Text;
        PackSizeString : Text[20];

    trigger OnInitReport()
    begin

        CompInfo.Get();
        BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
    end;

}
