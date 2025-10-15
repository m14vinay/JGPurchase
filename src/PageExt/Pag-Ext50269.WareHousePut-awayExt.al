pageextension 50269 "Warehouse Put-away Ext" extends "Warehouse Put-away"
{
    actions
    {
        addafter("&Print")
        {
            action(ItemLabel)
            {
                ApplicationArea = All;
                Caption = 'Item Label Ware.House Put Away';
                Image = Report;
                trigger OnAction()
                var
                    MyReportID: Integer;
                    Filter: Record "Warehouse Activity Header";
                begin
                    MyReportID := Report::ItemLabelWareHousePutAway;
                    CurrPage.SetSelectionFilter(Filter);
                    Report.RunModal(MyReportID, true, false, Filter);
                end;
            }
        }
    }
}
