pageextension 50291 "Purchase Order List Ext" extends "Purchase Order List"
{
    layout{
        addafter("Location Code")
        {
            field(CreatedUser; CreatedUser)
            {
                Caption = 'Created By';
                ApplicationArea = All;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
      If User.Get(rec.SystemCreatedBy) then
         CreatedUser := User."User Name";
      
    end;
    var
    CreatedUser : Code[50];
    User : Record User;
    
}

