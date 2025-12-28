pageextension 50260 "Purchase Header Archive Ext" extends "Purchase Order Archive"
{
    layout
    {
        addafter(status)
        {
             field("Type of Purchase"; Rec."Type of Purchase")
            {
                ApplicationArea = All;
                ToolTip = 'Type of Purchase';
            }
             field("Finance Type"; Rec."Finance Type")
            {
                ApplicationArea = All;
                ToolTip = 'Finance Type';
            }
             field("Contract Type"; Rec."Contract Type")
            {
                ApplicationArea = All;
                ToolTip = 'Contract Type';
            }
            field("PR No."; Rec."PR No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies PR No.';
            }
            field("Quote Valid Until Date"; Rec."Quote Valid Until Date")
            {
                ApplicationArea = All;
                ToolTip = 'Quote Valid Until Date';
            }
            group("Special Instructions")
            {
                Caption = 'Special Instructions';
                field(GetSpecailInstruction; Rec.GetSpecialInstruction())
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                    MultiLine = true;
                    ShowCaption = false;
                    ToolTip = 'Specifies the products or services being offered.';
                }
            }
        }
        modify("VAT Reporting Date")
        {
            Caption = 'SST Reporting Date';
        }
          modify("Prices Including VAT")
        {
            Caption = 'Prices Including SST';
        }
    }
}
