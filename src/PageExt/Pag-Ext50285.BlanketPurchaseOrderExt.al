pageextension 50285 "Blanket Purchase Order Ext" extends "Blanket Purchase Order"
{
    layout
    {
        modify("VAT Bus. Posting Group")
        {
          Caption = 'SST Bus. Posting Group';
        }
          modify("Prices Including VAT")
        {
          Caption = 'Prices Including SST';
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
