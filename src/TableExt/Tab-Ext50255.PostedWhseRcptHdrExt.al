tableextension 50255 "Posted Whse Rcpt Hdr Ext" extends "Posted Whse. Receipt Header"
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
}
