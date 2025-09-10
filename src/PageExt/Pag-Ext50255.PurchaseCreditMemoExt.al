pageextension 50255 "Purchase Credit Memo Ext" extends "Purchase Credit Memo"
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
        
    }
    trigger OnAfterGetRecord()
    begin
        SpecialInstruction := Rec.GetSpecailInstruction();
    end;

    var
        SpecialInstruction: Text;
}
