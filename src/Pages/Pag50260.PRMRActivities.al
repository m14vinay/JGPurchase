page 50260 "PR MR Activities"
{
    ApplicationArea = All;
    Caption = 'PR MR Activities';
    PageType = CardPart;
    SourceTable = "PR MR Cue";
    
    layout
    {
        area(Content)
        {
             cuegroup("Price Comparisons")
            {
                Caption = 'Price Comparison';
                field("Price Comparison Open"; Rec."Price Comparison Open")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Price Comparison List";
                    Caption = 'Open PC';
                    ToolTip = 'Specifies the number of Price Comparison records that are Open on the Role Center.';
                }
                field("PC Pending Approval"; Rec."PC Pending Approval")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Price Comparison List";
                    Caption = 'Pending Approval PC';
                    ToolTip = 'Specifies the number of Price Comparison records that are Pending Approval on the Role Center.';
                }
                field("Price Comparison Approved"; Rec."Price Comparison Approved")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Price Comparison List";
                    Caption = 'Approved PC';
                    ToolTip = 'Specifies the number of Price Comparison records that are Approved on the Role Center.';
                }
            }
            cuegroup("Purchase Requests")
            {
                Caption = 'Purchase Requests';
                field("Purchase Request Open"; Rec."Purchase Request Open")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Purchase Request List";
                    Caption = 'Open PR';
                    ToolTip = 'Specifies the number of Purchase Request records that are Open on the Role Center.';
                }
                field("PR Pending Approval"; Rec."PR Pending Approval")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Purchase Request List";
                    Caption = 'Pending Approval PR';
                    ToolTip = 'Specifies the number of Purchase Request records that are Pending Approval on the Role Center.';
                }
                field("Purchase Request Approved"; Rec."Purchase Request Approved")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Purchase Request List";
                    Caption = 'Approved PR';
                    ToolTip = 'Specifies the number of Purchase Request records that are Approved on the Role Center.';
                }
            }
            cuegroup("Material Requisition")
            {
                Caption = 'Material Requisition';
                field("Material Requisition Pending"; Rec."MR Pending")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "MR Header List";
                    Caption = 'Pending MR';
                    ToolTip = 'Specifies the number of Material Requisition records that are Pending on the Role Center.';
                }
                 field("Material Requisition Submitted"; Rec."MR Submitted")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "MR Header List";
                    Caption = 'Submitted MR';
                    ToolTip = 'Specifies the number of Material Requisition records that are Submitted on the Role Center.';
                }
                field("Material Requisition Issued"; Rec."MR Issued")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "MR Header List";
                    Caption = 'Issued MR';
                    ToolTip = 'Specifies the number of Material Requisition records that are Issued on the Role Center.';
                }
            }
        }
    }
}
