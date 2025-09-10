table 50258 "Price Comparison Cue"
{
    Caption = 'Price Comparison Cue';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Price Comparison Open"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Price Comparison Open';
            Editable = false;
            CalcFormula = count("Price Comparison Header" where("Status" = filter(Open)));
        }
        field(3; "Price Comparison Approved"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Price Comparison Approved';
            Editable = false;
            CalcFormula = count("Price Comparison Header" where("Status" = filter(Released)));
        }
        field(4; "PC Pending Approval"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Price Comparison Pending Approval';
            Editable = false;
            CalcFormula = count("Price Comparison Header" where("Status" = filter("Pending Approval")));
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
