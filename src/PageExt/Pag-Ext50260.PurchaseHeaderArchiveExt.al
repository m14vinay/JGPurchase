pageextension 50260 "Purchase Header Archive Ext" extends "Purchase Order Archive"
{
    layout
    {
        addafter(status)
        {
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
         addafter("Shipment Method Code")
        {
            field(Incoterms; Rec.Incoterms)
            {
                ToolTip = 'Specifies Incoterms';
                ApplicationArea = All;
            }

        }
    }
}
