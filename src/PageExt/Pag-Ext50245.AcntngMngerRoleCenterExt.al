pageextension 50291 "Acntng Mnger RoleCenter Ext" extends "Accounting Manager Role Center"
{
    layout
    {
        addafter(Control1902304208)
        {
            part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
            }
            part(PRMRActivities;"PR MR Activities")
            {
                ApplicationArea = Suite;
            }
        }
    }
}
