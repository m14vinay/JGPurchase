pageextension 50293 "Acc. PayablesCoordinatorRC Ext" extends "Acc. Payables Coordinator RC"
{
    layout
    {
        addafter(Control1900601808)
        {
            part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
            }
        }
    }
}
