tableextension 50255 "Posted Whse Rcpt Hdr Ext" extends "Posted Whse. Receipt Header"
{
    fields
    {
        field(50251; "Vehicle No."; Text[20])
        {
            Caption = 'Vehicle No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50252; "Transporter"; Text[50])
        {
            Caption = 'Transporter';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50253; "Vendor DO Date"; Date)
        {
            Caption = 'Vendor DO Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50254; "Remarks"; Text[100])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50255; "Inward Advise Note (IAN) No."; Integer)
        {
            Caption = 'Inward Advise Note (IAN) No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
