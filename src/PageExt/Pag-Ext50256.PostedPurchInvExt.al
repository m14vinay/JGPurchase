pageextension 50256 "Posted Purch Inv Ext" extends "Posted Purchase Invoice"
{
    layout
    {
        addafter(Corrective)
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
            group("Special Instruction")
            {
                Caption = 'Special Instruction';
                field(GetSpecialInstruction; Rec.GetSpecialInstruction())
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                    MultiLine = true;
                    ShowCaption = false;
                }
            }
        }
        addafter("Shipment Method Code")
        {
            field(Incoterms; Rec.Incoterms)
            {
                ToolTip = 'Specifies Incoterms';
                ApplicationArea = All;
                Editable = false;
            }

        }
        
        modify("VAT Reporting Date")
        {
            Caption = 'SST Reporting Date';
        }
        
    }
}

