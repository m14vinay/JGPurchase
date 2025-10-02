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
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnBeforePostSourceDocument', '', false, false)]
    local procedure OnBeforePostSourceDocument(var WhseRcptLine: Record "Warehouse Receipt Line"; PurchaseHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header"; TransferHeader: Record "Transfer Header"; var CounterSourceDocOK: Integer; HideValidationDialog: Boolean; var IsHandled: Boolean)
    var
    WhseRcptHdr : Record "Warehouse Receipt Header";
    begin
     If WhseRcptHdr.Get(WhseRcptLine."No.") then begin
       PurchaseHeader."Inward Advise Note (IAN) No." := WhseRcptHdr."Inward Advise Note (IAN) No.";
       PurchaseHeader.Modify(false);
     end;

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
