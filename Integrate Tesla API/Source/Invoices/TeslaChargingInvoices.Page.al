page 60204 "Tesla Charging Invoices"
{
    ApplicationArea = All;
    Caption = 'Tesla Charging Invoices';
    PageType = List;
    SourceTable = "Tesla Charging Invoice";
    UsageCategory = History;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Vehicle VIN"; Rec."Vehicle VIN")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vehicle VIN field.';
                }
                field(contentId; Rec.contentId)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Content ID field.';
                }
                field(fileName; Rec.fileName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the File Name field.';
                }
                field(invoiceType; Rec.invoiceType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice Type field.';
                }
            }
        }
    }
}
