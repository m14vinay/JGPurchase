pageextension 50265 "Purchase Agent Activites Ext" extends "Purchase Agent Activities"
{
    layout{
        addafter("Purchase Orders - Authorize for Payment")
        {
            cuegroup("Price Comparisons")
            {
                Caption =  'Price Comparison';
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
                Caption =  'Purchase Requests';
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
        
        }
    }
}
