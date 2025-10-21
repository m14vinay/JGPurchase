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
        WhseRcptHdr: Record "Warehouse Receipt Header";
    begin
        PurchHeader."Inward Advise Note (IAN) No." := WhseRcptHeader."Inward Advise Note (IAN) No.";
        PurchHeader."Vehicle No." := WhseRcptHeader."Vehicle No.";
        PurchHeader."Vendor DO Date" := WhseRcptHeader."Vendor DO Date";
        PurchHeader.Transporter := WhseRcptHeader.Transporter;
        PurchHeader.Remarks := WhseRcptHeader.Remarks;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnBeforePostSourceHeader', '', false, false)]
    local procedure UpdatePurchHeader(var WhseShptLine: Record "Warehouse Shipment Line"; GlobalSourceHeader: Variant; WhsePostParameters: Record "Whse. Post Parameters")
    var
        PurchHdr: Record "Purchase Header";
        WarehouseShipHdr: Record "Warehouse Shipment Header";
        PurchLine: Record "Purchase Line";
    begin
        If WhseShptLine."Source Document" = WhseShptLine."Source Document"::"Purchase Return Order" then
            If WarehouseShipHdr.Get(WhseShptLine."No.") then
                If PurchHdr.Get(PurchHdr."Document Type"::"Return Order", WhseShptLine."Source No.") then begin
                    PurchHdr."Vehicle No." := WarehouseShipHdr."Vehicle No.";
                    PurchHdr.Transporter := WarehouseShipHdr.Transporter;
                    PurchHdr.Modify(false);
                    If PurchLine.Get(PurchLine."Document Type"::"Return Order", WhseShptLine."Source No.", WhseShptLine."Source Line No.") then begin
                        PurchLine.Returnable := WhseShptLine.Returnable;
                        PurchLine.Modify(False);
                    end;
                end;

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Outbound", 'OnAfterCreateWhseShipmentHeaderFromWhseRequest', '', false, false)]
    local procedure UpdateReturnable(var WarehouseRequest: Record "Warehouse Request"; var WhseShptHeader: Record "Warehouse Shipment Header")
    var
        PurcLine: Record "Purchase Line";
        WarehouseShipLine: Record "Warehouse Shipment Line";
    begin
        WarehouseShipLine.Reset();
        WarehouseShipLine.SetRange("No.", WhseShptHeader."No.");
        If WarehouseShipLine.FindSet() then
            repeat
                If PurcLine.Get(PurcLine."Document Type"::"Return Order", WarehouseShipLine."Source No.", WarehouseShipLine."Source Line No.") then begin
                    WarehouseShipLine.Returnable := PurcLine.Returnable;
                    WarehouseShipLine.Modify();
                end;
            until WarehouseShipLine.Next() = 0;

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnCopyPurchDocOnAfterCopyPurchDocLines', '', false, false)]
    local procedure OnCopyPurchDocOnAfterCopyPurchDocLines(FromDocType: Option; FromDocNo: Code[20]; FromPurchaseHeader: Record "Purchase Header"; IncludeHeader: Boolean; var ToPurchHeader: Record "Purchase Header"; MoveNegLines: Boolean; var ReleaseDocument: Boolean; var IsHandled: Boolean)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        ToPurchHeader."Price Comparison Created" := false;
        ToPurchHeader."PR No." := '';
        ToPurchHeader."Price Comparison No." := '';
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Quote);
        PurchaseLine.SetRange("Document No.", ToPurchHeader."No.");
        If PurchaseLine.FindSet() then
            repeat
                PurchaseLine."Price Comparison Line No." := 0;
                PurchaseLine."Price Comparison No." := '';
                PurchaseLine."Purchase Request No." := '';
                PurchaseLine."Purchase Request Line No." := 0;
                PurchaseLine.Modify(false);
            until PurchaseLine.Next() = 0;
    end;
    
    Procedure SetWHseRecptHdr(WhseRcptHdr: Record "Warehouse Receipt Header")
    begin
        WareRecptHdr1 := WhseRcptHdr;
    end;

    Procedure GetWHseRecptHdr() WhseRcptHdr: Record "Warehouse Receipt Header"
    begin
        Exit(WareRecptHdr1);
    end;

    var
        WareRecptHdr1: Record "Warehouse Receipt Header";
}
