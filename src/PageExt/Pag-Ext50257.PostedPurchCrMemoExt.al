pageextension 50257 "Posted Purch CrMemo Ext" extends "Posted Purchase Credit Memo"
{
    layout
    {
        addafter(Corrective)
        {
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
        
    }
}
