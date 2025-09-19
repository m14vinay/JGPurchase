pageextension 50251 "Purch Quote List Ext" extends "Purchase Quotes"
{
    layout
    {
        addafter("Buy-from Vendor No.")
        {
            field("PR No."; Rec."PR No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies PR No.';
            }
        }
    }
    actions
    {
        addafter(MakeOrder)
        {
            action("Create Price Comparison")
            {
                ApplicationArea = Suite;
                Caption = 'Create Price Comparison';
                Image = Archive;
                ToolTip = 'Create Price Comparison based on PR No.';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    PurchaseLine: Record "Purchase Line";
                    PriceComparisonHeader: Record "Price Comparison Header";
                    PriceCompHdr: Record "Price Comparison Header";
                    PriceComparisonLine: Record "Price Comparison Line";
                    PurchasePayablesSetup: Record "Purchases & Payables Setup";
                    PriceCompLine: Record "Price Comparison Line";
                    PurchReqHdr: Record "Purchase Request Header";
                    GeneralLedgerSetup: Record "General Ledger Setup";
                    CurrencyExchangeRate: Record "Currency Exchange Rate";
                    Currency: Record Currency;
                    NoSeries: Codeunit "No. Series";
                    PreviousPRNo: Code[20];
                begin
                    PurchasePayablesSetup.Get();
                    GeneralLedgerSetup.Get();
                    Clear(PreviousPRNo);
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    PurchaseHeader.SetCurrentKey("PR No.");
                    PurchaseHeader.SetAscending("PR No.", True);
                    If PurchaseHeader.FindSet(True) then
                        repeat
                            If PurchaseHeader."Price Comparison Created" then
                                Message('Price Comparison Created for Quote %1', PurchaseHeader."No.")
                            else begin
                                If PurchaseHeader."PR No." <> PreviousPRNo then begin

                                    PriceComparisonHeader.Init();
                                    PriceComparisonHeader."No." := NoSeries.GetNextNo(PurchasePayablesSetup."Price Comparison No.");
                                    PriceComparisonHeader."PR No." := PurchaseHeader."PR No.";
                                    PriceComparisonHeader."Creation Date" := CurrentDateTime;
                                    PurchReqHdr.Reset();
                                    PurchReqHdr.SetRange("No.", PurchaseHeader."PR No.");
                                    If PurchReqHdr.FindFirst() then
                                        PriceComparisonHeader."Req Department" := PurchReqHdr."Shortcut Dimension 1 Code";
                                    PriceComparisonHeader.Status := PriceComparisonHeader.Status::Open;
                                    PriceComparisonHeader.Insert();

                                    PriceComparisonHeader."Creation Date" := CurrentDateTime;
                                    PriceComparisonHeader."Req Department" := PurchaseHeader."Shortcut Dimension 1 Code";
                                    PriceComparisonHeader.Status := PriceComparisonHeader.Status::Open;
                                    PriceComparisonHeader.Modify();

                                end;
                                PurchaseLine.Reset();
                                PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Quote);
                                PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                                If PurchaseLine.FindSet() then
                                    repeat
                                        PriceComparisonLine.Reset();
                                        PriceComparisonLine.SetRange("Document No.", PriceComparisonHeader."No.");
                                        PriceComparisonLine.SetRange("Purchase Quote No.", PurchaseLine."Document No.");
                                        PriceComparisonLine.SetRange("Item No.", PurchaseLine."No.");
                                        PriceComparisonLine.SetRange("Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                                        If not PriceComparisonLine.FindFirst() then begin
                                            PriceComparisonLine.Init();
                                            PriceComparisonLine."Document No." := PriceComparisonHeader."No.";
                                            PriceCompLine.Reset();
                                            PriceCompLine.SetCurrentKey("Document No.", "Line No.");
                                            PriceCompLine.SetAscending("Line No.", False);
                                            PriceCompLine.SetRange("Document No.", PriceComparisonHeader."No.");
                                            If PriceCompLine.FindFirst() then
                                                PriceComparisonLine."Line No." := PriceCompLine."Line No." + 10000
                                            else
                                                PriceComparisonLine."Line No." := 10000;
                                            PriceComparisonLine.Insert();
                                        end;
                                        PriceComparisonLine.Type := PurchaseLine.Type;
                                        //PriceComparisonLine."Line No." := 10000;
                                        PriceComparisonLine."Purchase Quote No." := PurchaseHeader."No.";
                                        PriceComparisonLine."Purchase Quote Line No." := PurchaseLine."Line No.";
                                        PriceComparisonLine."Vendor no." := PurchaseHeader."Buy-from Vendor No.";
                                        PriceComparisonLine."Vendor Name" := PurchaseHeader."Buy-from Vendor Name";
                                        PriceComparisonLine."Item No." := PurchaseLine."No.";
                                        PriceComparisonLine."Item Description" := PurchaseLine.Description;
                                        PriceComparisonLine.Quantity := PurchaseLine.Quantity;
                                        PriceComparisonLine."PR No." := PurchaseHeader."PR No.";
                                        PriceComparisonLine."Quote Valid Until Date" := PurchaseHeader."Quote Valid Until Date";
                                        PriceComparisonLine."Payment Terms Code" := PurchaseHeader."Payment Terms Code";
                                        PriceComparisonLine."Delivery Date" := PurchaseHeader."Expected Receipt Date";
                                        If PurchaseHeader."Currency Code" = '' then
                                            PriceComparisonLine."Currency Code" := GeneralLedgerSetup."LCY Code"
                                        else
                                            PriceComparisonLine."Currency Code" := PurchaseHeader."Currency Code";

                                        If PurchaseHeader."Currency Code" = '' then
                                            Currency.InitRoundingPrecision()
                                        else
                                            If Currency.Get(PurchaseHeader."Currency Code") then;

                                        // PriceComparisonLine."Unit Cost Excl SST" := Round(PurchaseLine."Unit Cost (LCY)" / (1 + PurchaseLine."VAT %" / 100), Currency."Amount Rounding Precision")

                                        PriceComparisonLine."Unit Cost Excl SST" := PurchaseLine."Unit Cost";
                                        If (GeneralLedgerSetup."LCY Code" = PurchaseHeader."Currency Code") Or (PurchaseHeader."Currency Code" = '') then begin
                                            PriceComparisonLine."Line Amount" := PurchaseLine."Amount";
                                            PriceComparisonLine."Line Discount Amount" := PurchaseLine."Line Discount Amount" + PurchaseLine."Inv. Discount Amount";
                                            PriceComparisonLine."SST Amount" := PurchaseLine."Amount Including VAT" - PurchaseLine.Amount;
                                        end Else begin
                                            PriceComparisonLine."Line Amount" := PriceComparisonLine."Unit Cost Excl SST" * PurchaseLine.Quantity;
                                            PriceComparisonLine."Line Discount Amount" := Round(CurrencyExchangeRate.ExchangeAmtFCYToLCY(PurchaseHeader."Document Date", PurchaseHeader."Currency Code", (PurchaseLine."Line Discount Amount" + PurchaseLine."Inv. Discount Amount"), PurchaseHeader."Currency Factor"), Currency."Amount Rounding Precision");
                                            PriceComparisonLine."SST Amount" := Round(CurrencyExchangeRate.ExchangeAmtFCYToLCY(PurchaseHeader."Document Date", PurchaseHeader."Currency Code", (PurchaseLine."Amount Including VAT" - PurchaseLine.Amount), PurchaseHeader."Currency Factor"), Currency."Amount Rounding Precision");
                                        end;
                                        PriceComparisonLine."Direct Unit Cost" := PurchaseLine."Direct Unit Cost";
                                        PriceComparisonLine.Amount := PurchaseLine.Amount;
                                        PriceComparisonLine."Amount Including VAT" := PurchaseLine."Amount Including VAT";

                                        PriceComparisonLine.Modify();

                                    until PurchaseLine.Next() = 0;

                                PreviousPRNo := PurchaseHeader."PR No.";
                                PurchaseHeader."Price Comparison Created" := True;
                                PurchaseHeader."Price Comparison No." := PriceComparisonHeader."No.";
                                PurchaseHeader.Modify();
                            end;
                        until PurchaseHeader.Next() = 0;
                    Message('Price Comparison created');

                end;
            }
        }
    }

}
