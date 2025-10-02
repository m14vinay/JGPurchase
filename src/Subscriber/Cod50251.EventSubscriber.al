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
       PostedWhseReceiptHeader."Inward Advise Note (IAN) No." := WarehouseReceiptHeader."Inward Advise Note (IAN) No.";
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnPostSourceDocumentOnBeforePostPurchaseHeader', '', false, false)]
    local procedure OnBeforePostSourceDocument(var PurchHeader: Record "Purchase Header"; WhseRcptHeader: Record "Warehouse Receipt Header"; SuppressCommit: Boolean; var CounterSourceDocOK: Integer; var IsHandled: Boolean)
    var
    WhseRcptHdr : Record "Warehouse Receipt Header";
    begin
       PurchHeader."Inward Advise Note (IAN) No." := WhseRcptHeader."Inward Advise Note (IAN) No.";
       PurchHeader."Vehicle No." := WhseRcptHeader."Vehicle No.";
       PurchHeader."Vendor DO Date" := WhseRcptHeader."Vendor DO Date";
       PurchHeader.Transporter := WhseRcptHeader.Transporter;
       PurchHeader.Remarks := WhseRcptHeader.Remarks;
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
