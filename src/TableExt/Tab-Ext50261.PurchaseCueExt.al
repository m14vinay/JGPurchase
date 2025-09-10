tableextension 50261 "Purchase Cue Ext" extends "Purchase Cue"
{
    fields
    {
        field(50251; "Price Comparison Open"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Price Comparison Open';
            Editable = false;
            CalcFormula = count("Price Comparison Header" where("Status" = filter(Open)));
        }
        field(50252; "Price Comparison Approved"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Price Comparison Approved';
            Editable = false;
            CalcFormula = count("Price Comparison Header" where("Status" = filter(Released)));
        }
        field(50253; "PC Pending Approval"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Price Comparison Pending Approval';
            Editable = false;
            CalcFormula = count("Price Comparison Header" where("Status" = filter("Pending Approval")));
        }
         field(50254; "Purchase Request Open"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Purchase Request Open';
            Editable = false;
            CalcFormula = count("Purchase Request Header" where("Status" = filter(Open)));
        }
        field(50255; "Purchase Request Approved"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Purchase Request Approved';
            Editable = false;
            CalcFormula = count("Purchase Request Header" where("Status" = filter(Released)));
        }
        field(50256; "PR Pending Approval"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Purchase Request Pending Approval';
            Editable = false;
            CalcFormula = count("Purchase Request Header" where("Status" = filter("Pending Approval")));
        }
    }
}
