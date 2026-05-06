page 50263 "Vendor SST Exemption Details"
{
    ApplicationArea = All;
    Caption = 'Vendor SST Exemption Details';
    PageType = List;
    SourceTable = "Vendor SST Exemption Details";
    UsageCategory = Lists;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                }
                field("SST Exemption Registration No."; Rec."SST Exemption Registration No.")
                {
                    ToolTip = 'Specifies the value of the SST Exemption Registration No. field.', Comment = '%';
                }
                field("SST Business Posting Group"; Rec."SST Business Posting Group")
                {
                    ToolTip = 'Specifies the value of the SST Business Posting Group field.', Comment = '%';
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.', Comment = '%';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ToolTip = 'Specifies the value of the Expiry Date field.', Comment = '%';
                }
            }
        }
    }
}
