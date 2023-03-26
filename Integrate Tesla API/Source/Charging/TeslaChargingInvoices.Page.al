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
    actions
    {
        area(Processing)
        {
            action(Download)
            {
                ApplicationArea = All;
                Caption = 'Download';
                Image = Download;
                ToolTip = 'Download the selected invoice.';
                trigger OnAction()
                begin
                    Rec.DownloadInvoicePDFFromBC();
                end;
            }
            action(CreateIncomingDocument)
            {
                ApplicationArea = All;
                Caption = 'Create Incoming Document';
                Image = DocumentEdit;
                ToolTip = 'Create an incoming document from the selected invoice.';
                trigger OnAction()
                begin
                    Rec.AddInvoiceToIncomingDocument();
                end;
            }
        }
    }

    internal procedure Set(var Invoice: Record "Tesla Charging Invoice")
    begin
        Rec.Copy(Invoice, true)
    end;
}
