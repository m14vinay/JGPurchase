page 50259 "Purchase Request FactBox"
{
    Caption = 'Purchase Request Line Details';
    PageType = CardPart;
    SourceTable = "Purchase Request Line";

    layout
    {
        area(content)
        {
            field("No."; Rec."Item No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item No.';
                Lookup = false;
                ToolTip = 'Specifies the number of a item.';

                trigger OnDrillDown()
                begin
                    ShowDetails();
                end;
            }
            field(Availability; CalcAvailability(Rec))
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Availability';
                DecimalPlaces = 0 : 5;
                DrillDown = true;
                Editable = true;
                ToolTip = 'Specifies how many units of the item on the purchase request line are available.';

                trigger OnDrillDown()
                var
                NewDate: Date;
                begin
                    
                if ItemAvailabilityFormsMgt.ShowItemAvailabilityByEvent(Item, GetFieldCaption(Rec.FieldCaption(Rec."Need Date")), Rec."Need Date", NewDate, false) then
                    Rec.Validate(Rec."Need Date", NewDate);
                    
                    CurrPage.Update(true);
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        // Rec.ClearPurchaseHeader();
    end;

    protected var
        PurchInfoPaneMgt: Codeunit "Purchases Info-Pane Management";
        ItemAvailabilityFormsMgt: Codeunit "Item Availability Forms Mgt";

        PurchAvailabilityMgt: Codeunit "Purch. Availability Mgt.";
    protected procedure ShowDetails()
    var
        Item: Record Item;
    begin
        Item.Get(Rec."Item No.");
        PAGE.Run(PAGE::"Item Card", Item);

    end;
    local procedure GetFieldCaption(FieldCaption: Text): Text[80]
    begin
        exit(CopyStr(FieldCaption, 1, 80));
    end;

    procedure CalcAvailability(var PurchLine: Record "Purchase Request Line"): Decimal
    var
        AvailableToPromise: Codeunit "Available to Promise";
        GrossRequirement: Decimal;
        ScheduledReceipt: Decimal;
        AvailableQuantity: Decimal;
        PeriodType: Enum "Analysis Period Type";
        AvailabilityDate: Date;
        LookaheadDateformula: DateFormula;
        IsHandled: Boolean;
        
    begin

        if Rec."Need Date" <> 0D then
            AvailabilityDate := Rec."Need Date"
        else
            AvailabilityDate := WorkDate();

        Item.Reset();
        Item.Setrange("No.", PurchLine."Item No.");
        Item.SetRange("Date Filter", 0D, AvailabilityDate);
       // Item.SetRange("Variant Filter", '');
       // Item.SetRange("Location Filter", '');
        Item.SetRange("Drop Shipment Filter", false);
        If Item.FindFirst() then;
        
        exit(
          AvailableToPromise.CalcQtyAvailabletoPromise(
            Item,
            GrossRequirement,
            ScheduledReceipt,
            AvailabilityDate,
            PeriodType,
            LookaheadDateformula));

    end;
    var
    Item: Record Item;

}

