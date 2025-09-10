pageextension 50254 "Purchase Invoice" extends "Purchase Invoice"
{
    layout
    {
        addafter(Status)
        {
            group("Special Instruction")
            {
                field(SpecialInstruction; SpecialInstruction)
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    MultiLine = true;
                    ShowCaption = false;
                    ToolTip = 'Specifies the products or service being offered.';

                    trigger OnValidate()
                    begin
                        Rec.SetSpecailInstruction(SpecialInstruction);
                    end;
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
    trigger OnAfterGetRecord()
    begin
        SpecialInstruction := Rec.GetSpecailInstruction();
    end;

    var
        SpecialInstruction: Text;
}
