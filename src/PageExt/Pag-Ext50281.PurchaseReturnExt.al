pageextension 50281 "Purchase Return Ext" extends "Purchase Return Order"
{
    layout{
        modify("Prices Including VAT")
        {
            Caption = 'Prices Including SST';
        }
         modify("VAT Bus. Posting Group")
        {
            Caption = 'SST Bus. Posting Group';
        }
        modify("VAT Reporting Date")
        {
            Caption = 'SST Reporting Date';
        }
        addafter("VAT Bus. Posting Group")
        {
            field("SST Exemption registration No."; Rec."SST Exemption registration No.")
            {
                ToolTip = 'SST Exemption registration No.';
                ApplicationArea = All;
            }
        }
    }
}
