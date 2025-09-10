table 50254 "Purchase Request Header"
{
    Caption = 'Purchase Request Header';
    DataClassification = CustomerContent;
    LookupPageId = "Purchase Request List";
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(3; "Requested By"; Text[50])
        {
            Caption = 'Requested By';
        }
        field(4; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));
        }
        field(5; Remarks; Text[250])
        {
            Caption = 'Remarks';
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(6; Status; Enum "Purchase Document Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(7; Type; Enum "PR Type")
        {
            Caption = 'Type';
            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(8; "PO Created"; Boolean)
        {
            Caption = 'PO Created';
        }
        field(9; "Assigned To"; Code[50])
        {
            Caption = 'Assigned To';
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UserSelection: Codeunit "User Selection";
            begin
                UserSelection.ValidateUserName("Assigned To");
            end;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Requested By","No.")
        {
        }
    }
    trigger OnInsert()
    var
        UserSetup: Record "User Setup";
        PRDepartment: Record "PR Department Mapping";
        NoSeries: Codeunit "No. Series";
    begin
        
            If UserSetup.Get(UserId) then
                If PRDepartment.Get(UserSetup."Shortcut Dimension 1 Code") then
                    Rec."No." := NoSeries.GetNextNo(PRDepartment."Purchase Request No.",Today(), true)
                Else
                    Error('No Series setup is not availbale for PR Department');
       
    end;

    trigger OnDelete()
    var
    PurchReqLine : Record "Purchase Request Line";
    begin
        TestField(Status, Status::Open);
        PurchReqLine.Reset();
        PurchReqLine.SetRange("No.",Rec."No.");
        If PurchReqLine.FindFirst() then
           PurchReqLine.DeleteAll();

    end;

    procedure PurchReqLineExist(): Boolean
    var
        PurchReqLine: Record "Purchase Request Line";
    begin
        PurchReqLine.Reset();
        PurchReqLine.ReadIsolation := IsolationLevel::ReadUncommitted;
        PurchReqLine.SetRange("No.", "No.");
        exit(not PurchReqLine.IsEmpty);
    end;
}
