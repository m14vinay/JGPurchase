pageextension 50256 "Posted Purch Inv Ext" extends "Posted Purchase Invoice"
{
    layout
    {
        addafter(Corrective)
        {
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
    }
}

