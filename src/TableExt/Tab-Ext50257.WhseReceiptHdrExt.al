tableextension 50257 "Whse Receipt Hdr Ext" extends "Warehouse Receipt Header"
{
    fields
    {
        field(50251; "Vehicle No."; Text[20])
        {
            Caption = 'Vehicle No.';
            DataClassification = CustomerContent;
        }
        field(50252; "Transporter"; Text[50])
        {
            Caption = 'Transporter';
            DataClassification = CustomerContent;
        }
        field(50253; "Vendor DO Date"; Date)
        {
            Caption = 'Vendor DO Date';
            DataClassification = CustomerContent;
        }
        field(50254; "Remarks"; Text[100])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
    }
    trigger OnModify()
    begin
        If (rec."Vehicle No." <> xRec."Vehicle No.") or (Rec.Remarks <> xRec.Remarks) or (Rec."Vendor DO Date" <> xRec."Vendor DO Date") or (Rec.Transporter <> xRec.Transporter) then begin
            WhseRcptLine.Reset();
            WhseRcptLine.SetRange("No.", Rec."No.");
            WhseRcptLine.SetRange("Source Document", WhseRcptLine."Source Document"::"Purchase Order");
            if WhseRcptLine.FindSet() then
                repeat
                    PurchHeader.Reset();
                    PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
                    PurchHeader.SetRange("No.", WhseRcptLine."Source No.");
                    If PurchHeader.FindFirst() then begin
                        PurchHeader.Transporter := Rec.Transporter;
                        PurchHeader."Vendor DO Date" := Rec."Vendor DO Date";
                        PurchHeader.Remarks := Rec.Remarks;
                        PurchHeader."Vehicle No." := Rec."Vehicle No.";
                        PurchHeader.Modify(false);
                    end;
                until WhseRcptLine.Next() = 0;
        end;
    end;

    Var
        PurchHeader: Record "Purchase Header";
        WhseRcptLine: Record "Warehouse Receipt Line";
}
