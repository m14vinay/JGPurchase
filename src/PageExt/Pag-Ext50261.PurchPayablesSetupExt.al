pageextension 50261 "Purch & Payables Setup Ext" extends "Purchases & Payables Setup"
{
     layout
    {
        addafter("Posted Prepmt. Cr. Memo Nos.")
        {
            field("Price Comparison No."; Rec."Price Comparison No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code for the number series that will be used to assign numbers to Price Comparison.';
            }
        }
          addafter("Default Cancel Reason Code")
        {
            field("Terms and Conditions Sales"; Rec."Terms and Conditions Purchase")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies Terms and Conditions Purchase';
                ExtendedDatatype = URL;
            }
        }
          modify("Allow VAT Difference")
        {
            Caption = 'Allow SST Difference';
        }
        modify("Enable Vendor GST Amount (ACY)")
        {
            Caption = 'Enable Vendor SST Amount (ACY)';
        }
          modify("Calc. Inv. Disc. per VAT ID")
        {
            Caption = 'Calc. Inv. Disc. per SST ID';
        }
    }
}
