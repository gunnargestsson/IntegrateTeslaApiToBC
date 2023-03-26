table 60208 "Tesla Charging Invoice"
{
    Access = Internal;
    Caption = 'Tesla Charging Invoice';
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; contentId; Guid)
        {
            Caption = 'Content ID';
            DataClassification = SystemMetadata;
        }
        field(2; fileName; Text[50])
        {
            Caption = 'File Name';
            DataClassification = SystemMetadata;
        }
        field(3; invoiceType; Text[20])
        {
            Caption = 'Invoice Type';
            DataClassification = SystemMetadata;
        }
        field(4; vin; Code[20])
        {
            Caption = 'VIN';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; contentId)
        {
            Clustered = true;
        }
    }

    internal procedure AddInvoiceToIncomingDocument()
    var
        IncomingDocument: Record "Incoming Document";
        TempBlob: Codeunit "Temp Blob";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        InStr: InStream;
    begin
        if not DownloadInvoicePDF(TempBlob) then exit;
        TempBlob.CreateInStream(InStr);
        IncomingDocument.CreateIncomingDocument(InStr, fileName);
        WorkflowEventHandling.RunWorkflowOnAfterIncomingDocReadyForOCR(IncomingDocument);
        Commit();
        Page.RunModal(Page::"Incoming Document", IncomingDocument);
    end;

    internal procedure DownloadInvoicePDF(var TempBlob: Codeunit "Temp Blob"): Boolean
    var
        Setup: Record "Tesla API Setup";
        ApiHelper: Codeunit "Tesla API Request Helper";
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
    begin
        Setup.Get();
        ApiHelper.SetRequest(GetInvoiceDownloadUrl(), 'Get', Setup, Request);
        ApiHelper.SendRequest(Request, Response, 30000);
        ApiHelper.ReadAsTempBlob(Response, TempBlob);
        exit(TempBlob.HasValue());
    end;

    internal procedure DownloadInvoicePDFFromBC()
    var
        FileMgt: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
    begin
        if DownloadInvoicePDF(TempBlob) then
            FileMgt.BLOBExport(TempBlob, fileName, true);
    end;

    local procedure GetInvoiceDownloadUrl() Url: Text
    var
        UrlTok: Label 'https://ownership.tesla.com/mobile-app/charging/invoice/%1?deviceCountry=US&deviceLanguage=en&vin=%2', Locked = true;
    begin
        Url := StrSubstNo(UrlTok, LowerCase(Format(contentId).TrimStart('{}').TrimEnd('}')), vin);
    end;
}
