table 50259 "Purchase Request Cue"
{
    Caption = 'Purchase Request Cue';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Purchase Request Open"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Purchase Request Open';
            Editable = false;
            CalcFormula = count("Purchase Request Header" where("Status" = filter(Open)));
        }
        field(3; "Purchase Request Approved"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Purchase Request Approved';
            Editable = false;
            CalcFormula = count("Purchase Request Header" where("Status" = filter(Released)));
        }
        field(4; "PR Pending Approval"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Purchase Request Pending Approval';
            Editable = false;
            CalcFormula = count("Purchase Request Header" where("Status" = filter("Pending Approval")));
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
