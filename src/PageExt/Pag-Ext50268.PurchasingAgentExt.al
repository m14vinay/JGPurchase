pageextension 50268 "Purchasing Agent Ext" extends "Purchasing Agent Role Center"
{
    layout{
         addbefore("User Tasks Activities")
         {
             part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
            }         
         }
    }
}
