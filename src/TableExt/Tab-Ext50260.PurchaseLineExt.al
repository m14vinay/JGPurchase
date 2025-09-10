tableextension 50260 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        field(50259; "Price Comparison No."; Code[20])
        {
            Caption = 'Price Comparison No.';
            DataClassification = CustomerContent;
            TableRelation = "Price Comparison Header";
            Editable = false;
        }
        field(50260; "Price Comparison Line No."; Integer)
        {
            Caption = 'Price Comparison Line No.';
            DataClassification = CustomerContent;
        }
        field(50261; "Purchase Request No."; Code[20])
        {
            Caption = 'Purchase Request No.';
            DataClassification = CustomerContent;
            TableRelation = "Purchase Request Header";
            Editable = false;
        }
        field(50262; "Purchase Request Line No."; Integer)
        {
            Caption = 'Purchase Request Line No.';
            DataClassification = CustomerContent;
        }
        modify("No.")
        {
            trigger OnBeforeValidate()
            var
                PurchHeader: Record "Purchase Header";
                PurchReqLine: Record "Purchase Request Line";
                Item: Record Item;
            begin
                If (Rec."Document Type" = Rec."Document Type"::Quote) and (Rec.Type = Rec.Type::Item) then begin
                    If PurchHeader.Get(PurchHeader."Document Type"::Quote, Rec."Document No.") then
                        If PurchHeader."PR No." <> '' then
                            If Item.Get(Rec."No.") then
                                If Item.Type = Item.Type::Inventory then begin
                                    PurchReqLine.Reset();
                                    PurchReqLine.SetRange("No.", PurchHeader."PR No.");
                                    PurchReqLine.SetRange("Item No.", Rec."No.");
                                    If PurchReqLine.IsEmpty then
                                        Error('Item does not exist in PR %1', PurchHeader."PR No.");
                                end;
                end;
            end;
        }
    }

    trigger OnDelete()
    begin
        If Rec."Purchase Request No." <> '' then
            Error('Line created from PR %1, Delete line is not allowed', Rec."Purchase Request No.");
        If Rec."Price Comparison No." <> '' then
            Error('Line created from Price Comparison %1, Delete line is not allowed', Rec."Price Comparison No.");
    end;
}
