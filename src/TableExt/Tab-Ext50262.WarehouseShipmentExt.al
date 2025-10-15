tableextension 50262 "Warehouse Shipment Ext" extends "Warehouse Shipment Header"
{
    fields
    {
          field(50256; "Approval Status"; Enum "Purchase Document Status")
        {
            Caption = 'Approval Status';
            Editable = False;
        }
    }
     procedure WhseShpLinesExist(): Boolean
    var
        WareShipLine: Record "Warehouse Shipment Line";
    begin
        WareShipLine.Reset();
        WareShipLine.ReadIsolation := IsolationLevel::ReadUncommitted;
        WareShipLine.SetRange("No.", "No.");
        exit(not WareShipLine.IsEmpty);
    end;
}
