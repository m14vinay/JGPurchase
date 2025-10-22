tableextension 50260 "Purchase Line Ext" extends "Purchase Line"
{

    fields
    {
        field(50259; "Price Comparison No."; Code[20])
        {
            Caption = 'Price Comparison No.';
            DataClassification = CustomerContent;
            TableRelation = "Price Comparison Header";
            Editable = false;
        }
        field(50260; "Price Comparison Line No."; Integer)
        {
            Caption = 'Price Comparison Line No.';
            DataClassification = CustomerContent;
        }
        field(50261; "Purchase Request No."; Code[20])
        {
            Caption = 'Purchase Request No.';
            DataClassification = CustomerContent;
            TableRelation = "Purchase Request Header";
            Editable = false;
        }
        field(50262; "Purchase Request Line No."; Integer)
        {
            Caption = 'Purchase Request Line No.';
            DataClassification = CustomerContent;
        }
        field(50263; "Returnable"; Boolean)
        {
            Caption = 'Returnable';
            DataClassification = CustomerContent;
        }
        modify("VAT %")
        {
            Caption = 'SST %';
        }
        modify("VAT Amount (ACY)")
        {
            Caption = 'SST Amount (ACY)';
        }
        modify("VAT Base (ACY)")
        {
            Caption = 'SST Base (ACY)';
        }
        modify("VAT Base Amount")
        {
            Caption = 'SST Base Amount';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'SST Bus. Posting Group';
        }
        modify("VAT Calculation Type")
        {
            Caption = 'SST Calculation Type';
        }
        modify("VAT Difference")
        {
            Caption = 'SST Difference';
            CaptionClass = 'SST Difference';
        }
        modify("VAT Difference (ACY)")
        {
            Caption = 'SST Difference (ACY)';
        }
        modify("VAT Identifier")
        {
            Caption = 'SST Identifier';
        }
        modify("VAT Prod. Posting Group")
        {
            Caption = 'SST Prod. Posting Group';
        }
        modify("Prepmt VAT Diff. Deducted")
        {
            Caption = 'Prepmt SST Diff. Deducted';
        }
        modify("Prepmt. VAT Base Deducted")
        {
            Caption = 'Prepmt. SST Base Deducted';
        }
        modify("Prepmt. VAT Amount Deducted")
        {
            Caption = 'Prepmt. SST Amount Deducted';
        }
        modify("Prepmt. VAT Amount Inv. (LCY)")
        {
            Caption = 'Prepmt. SST Amount Inv. (LCY)';
        }
        modify("Prepmt. VAT Base Amt.")
        {
            Caption = 'Prepmt. SST Base Amt.';
        }
        modify("Prepayment VAT %")
        {
            Caption = 'Prepayment SST %';
        }
        modify("Prepayment VAT Difference")
        {
            Caption = 'Prepayment SST Difference';
        }
        modify("Prepayment VAT Identifier")
        {
            Caption = 'Prepayment SST Identifier';
        }
        modify("Prepmt VAT Diff. to Deduct")
        {
            Caption = 'Prepmt SST Diff. to Deduct';
        }
        modify("Non-Deductible VAT %")
        {
            Caption = 'Non-Deductible SST %';
        }
        modify("Non-Deductible VAT Amount")
        {
            Caption = 'Non-Deductible SST Amount';
        }
        modify("Non-Deductible VAT Base")
        {
            Caption = 'Non-Deductible SST Base';
        }
        modify("Non-Deductible VAT Diff.")
        {
            Caption = 'Non-Deductible SST Diff.';
        }
        modify("Amount Including VAT")
        {
            Caption = 'Amount Including SST';
        }
        modify("Prepmt. VAT Calc. Type")
        {
            Caption = 'Prepmt. SST Calc. Type';
        }
        modify("Prepmt. Amt. Incl. VAT")
        {
            Caption = 'Prepmt. Amt. Incl. SST';
        }
        modify("Amount Including VAT (ACY)")
        {
            Caption = 'Amount Including SST (ACY)';
        }
        modify("Prepmt. Non-Deduct. VAT Base")
        {
            Caption = 'Prepmt. Non-Deduct. SST Base';
        }
        modify("Prepmt. Non-Deduct. VAT Amount")
        {
            Caption = 'Prepmt. Non-Deduct. SST Amount';
        }
        modify("A. Rcd. Not Inv. Ex. VAT (LCY)")
        {
            Caption = 'A. Rcd. Not Inv. Ex. SST (LCY)';
        }
        modify("Outstanding Amt. Ex. VAT (LCY)")
        {
            Caption = 'Outstanding Amt. Ex. SST (LCY)';
        }
        modify("Prepmt. Amount Inv. Incl. VAT")
        {
            Caption = 'Prepmt. Amount Inv. Incl. SST';
        }
        modify("No.")
        {
            trigger OnBeforeValidate()
            var
                PurchHeader: Record "Purchase Header";
                PurchReqLine: Record "Purchase Request Line";
                Item: Record Item;
            begin
                If (Rec."Document Type" = Rec."Document Type"::Quote) and (Rec.Type = Rec.Type::Item) then begin
                    If PurchHeader.Get(PurchHeader."Document Type"::Quote, Rec."Document No.") then
                        If PurchHeader."PR No." <> '' then
                            If Item.Get(Rec."No.") then
                                If Item.Type = Item.Type::Inventory then begin
                                    PurchReqLine.Reset();
                                    PurchReqLine.SetRange("No.", PurchHeader."PR No.");
                                    PurchReqLine.SetRange("Item No.", Rec."No.");
                                    If PurchReqLine.IsEmpty then
                                        Error('Item does not exist in PR %1', PurchHeader."PR No.");
                                end;
                end;
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                PurchHeader: Record "Purchase Header";
                PurchReqLine: Record "Purchase Request Line";
                Item: Record Item;
            begin
                If Quantity > 0 then
                    If (Rec."Document Type" = Rec."Document Type"::Quote) and (Rec.Type = Rec.Type::Item) then begin
                        If PurchHeader.Get(PurchHeader."Document Type"::Quote, Rec."Document No.") then
                            If PurchHeader."PR No." <> '' then
                                If Item.Get(Rec."No.") then
                                    If Item.Type = Item.Type::Inventory then begin
                                        PurchReqLine.Reset();
                                        PurchReqLine.SetRange("No.", PurchHeader."PR No.");
                                        PurchReqLine.SetRange("Item No.", Rec."No.");
                                        If PurchReqLine.FindFirst() then
                                            If PurchReqLine.Quantity <> Quantity then
                                                Error('Quantity for the Item %1 in Purchase Request is %2', PurchReqLine."Item No.", PurchReqLine.Quantity);
                                    end;
                    end;
            end;
        }
    }
    procedure GetCaptionWithCurrencyCode(CaptionWithoutCurrencyCode: Text; CurrencyCode: Code[10]): Text
    var
        GLSetup: Record "General Ledger Setup";
    begin
        if CurrencyCode = '' then begin
            GLSetup.Get();
            CurrencyCode := GLSetup.GetCurrencyCode(CurrencyCode);
        end;

        if CurrencyCode <> '' then
            exit(CaptionWithoutCurrencyCode + StrSubstNo(' (%1)', CurrencyCode));

        exit(CaptionWithoutCurrencyCode);
    end;

   
    /*trigger OnDelete()
    begin
        If Rec."Purchase Request No." <> '' then
            Error('Line created from PR %1, Delete line is not allowed', Rec."Purchase Request No.");
        If Rec."Price Comparison No." <> '' then
            Error('Line created from Price Comparison %1, Delete line is not allowed', Rec."Price Comparison No.");
    end;*/
}
