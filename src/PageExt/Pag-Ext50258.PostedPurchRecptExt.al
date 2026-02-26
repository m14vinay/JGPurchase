pageextension 50258 "Posted Purch Recpt Ext" extends "Posted Purchase Receipt"
{
    layout
    {
        addafter("Responsibility Center")
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
            field("Vehicle No."; Rec."Vehicle No.")
            {
                ToolTip = 'Specifies Vehicle No.';
                ApplicationArea = All;
                Editable = false;
            }
            field("Vendor DO Date"; Rec."Vendor DO Date")
            {
                ToolTip = 'Specifies Vendor DO Date';
                ApplicationArea = All;
                Editable = false;
            }
            field("Transporter"; Rec.Transporter)
            {
                ToolTip = 'Specifies Transporter';
                ApplicationArea = All;
                Editable = false;
            }
            field("Remarks"; Rec.Remarks)
            {
                ToolTip = 'Specifies Remarks';
                ApplicationArea = All;
                Editable = false;
                MultiLine = true;
            }
            field("Inward Advise Note (IAN) No."; Rec."Inward Advise Note (IAN) No.")
            {
                ToolTip = 'Inward Advise Note (IAN) No.';
                ApplicationArea = All;
                Editable = false;
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
