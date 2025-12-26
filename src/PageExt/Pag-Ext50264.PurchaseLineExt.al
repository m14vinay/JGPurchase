pageextension 50264 "Purchase Line Ext" extends "Purchase Order Subform"
{
    layout
    {
        addafter("Line Amount")
        {

            field("Price Comparison No."; Rec."Price Comparison No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("No.")
        {
            field("Vendor Item No."; Rec."Vendor Item No.")
            {
                ApplicationArea = All;
            }
        }
        modify("Line Discount Amount")
        {
            Visible = true;
        }


        modify(Quantity)
        {
            trigger OnBeforeValidate()
            begin
                /* If (Rec."Purchase Request No." <> '') or (Rec."Price Comparison No." <> '') then
                     if Rec.Quantity < xRec.Quantity then
                         Error('Created from PR %1 Cannot reduce the Quantity', Rec."Purchase Request No.");*/
            end;
        }
        modify("No.")
        {
            trigger OnAfterAfterLookup(Selected: RecordRef)
            begin
                If (Rec."Purchase Request No." <> '') or (Rec."Price Comparison No." <> '') then
                    Error('Line created from PR %1 Cannot change No.', Rec."Purchase Request No.");
            end;
        }
        modify("Direct Unit Cost")
        {
            trigger OnBeforeValidate()
            begin
                If Rec."Price Comparison No." <> '' then
                    Error('Line created from PR %1 Cannot change Price', Rec."Purchase Request No.");
            end;
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'SST Bus. Posting Group';
        }
        modify("VAT Prod. Posting Group")
        {
            Caption = 'SST Prod. Posting Group';
            Editable = false;
        }
        modify("Total VAT Amount")
        {
            Caption = 'Total SST';
            CaptionClass = Rec.GetCaptionWithCurrencyCode('Total SST',Currency.Code);;
        }
        modify("Total Amount Excl. VAT")
        {
            Caption = 'Total Excl. SST';
            CaptionClass = Rec.GetCaptionWithCurrencyCode('Total Excl. SST',Currency.Code);
        }
        modify("Total Amount Incl. VAT")
        {
            Caption = 'Total Incl. SST';
            CaptionClass = Rec.GetCaptionWithCurrencyCode('Total Incl. SST',Currency.Code);
        }
         modify(AmountBeforeDiscount)
        {
            Caption = 'Subtotal Excl. SST';
            CaptionClass = Rec.GetCaptionWithCurrencyCode('Subtotal Excl. SST',Currency.Code);
        }

    }



    Var
        DocumentTotals: Codeunit "Document Totals";

    
}
