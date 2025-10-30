pageextension 50292 "Account Receivables Ext " extends "Account Receivables"
{
    layout
    {
        addafter("Acc. Receivable Activities")
        {
            part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
            }
        }
    }
}
