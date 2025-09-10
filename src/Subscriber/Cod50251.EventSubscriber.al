codeunit 50253 "Subscriber"
{
    SingleInstance = true;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnBeforePostedWhseRcptHeaderInsert', '', false, false)]
    local procedure OnBeforePostWhseRcptHeader(var PostedWhseReceiptHeader: Record "Posted Whse. Receipt Header"; WarehouseReceiptHeader: Record "Warehouse Receipt Header")
    begin
       PostedWhseReceiptHeader."Vehicle No." := WarehouseReceiptHeader."Vehicle No.";
       PostedWhseReceiptHeader.Transporter := WarehouseReceiptHeader.Transporter;
       PostedWhseReceiptHeader.Remarks := WarehouseReceiptHeader.Remarks;
       PostedWhseReceiptHeader."Vendor DO Date" := WarehouseReceiptHeader."Vendor DO Date";
    end;
    Procedure SetWHseRecptHdr(WhseRcptHdr : Record "Warehouse Receipt Header")
    begin
         WareRecptHdr1 := WhseRcptHdr;
    end;
    Procedure GetWHseRecptHdr() WhseRcptHdr : Record "Warehouse Receipt Header"
    begin
         Exit(WareRecptHdr1);
    end;
    var
    WareRecptHdr1 : Record "Warehouse Receipt Header";
}
