pageextension 50288 "Posted Purch Inv Subform Ext" extends "Posted Purch. Invoice Subform"
{
   layout{
        modify("Total VAT Amount")
        {
            Caption = 'Total SST';
            CaptionClass = GetCaptionWithCurrencyCode('Total SST');;
        }
        modify("Total Amount Excl. VAT")
        {
            Caption = 'Total Excl. SST';
            CaptionClass = GetCaptionWithCurrencyCode('Total Excl. SST');
        }
        modify("Total Amount Incl. VAT")
        {
            Caption = 'Total Incl. SST';
            CaptionClass = GetCaptionWithCurrencyCode('Total Incl. SST');
        }

    }
    procedure GetCaptionWithCurrencyCode(CaptionWithoutCurrencyCode: Text): Text
    var
        GLSetup: Record "General Ledger Setup";
        PurchInvHdr : Record "Purch. Inv. Header";
        CurrencyCode : Text[20];
    begin
        If PurchInvHdr.Get(Rec."Document No.") then
         CurrencyCode := PurchInvHdr."Currency Code";
        if CurrencyCode = '' then begin
            GLSetup.Get();
            CurrencyCode := GLSetup.GetCurrencyCode(CurrencyCode);
        end;


        if CurrencyCode <> '' then
            exit(CaptionWithoutCurrencyCode + StrSubstNo(' (%1)', CurrencyCode));

        exit(CaptionWithoutCurrencyCode);
    end;
}
