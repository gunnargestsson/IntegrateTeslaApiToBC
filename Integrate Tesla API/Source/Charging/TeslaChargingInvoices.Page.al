page 60204 "Tesla Charging Invoices"
{
    ApplicationArea = All;
    Caption = 'Tesla Charging Invoices';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Tesla Charging Invoice";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
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

    internal procedure Set(var Invoice: Record "Tesla Charging Invoice")
    begin
        Rec.Copy(Invoice, true)
    end;
}
