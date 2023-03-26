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
        IsHandled: Boolean;
        InStr: InStream;
    begin
        OnBeforeAddInvoiceToIncomingDocument(Rec, IsHandled);
        if IsHandled then
            exit;

        if not DownloadInvoicePDF(TempBlob) then exit;
        TempBlob.CreateInStream(InStr);
        IncomingDocument.CreateIncomingDocument(InStr, fileName);
        OnAfterCreatingIncomingDocumentForInvoice(Rec, IncomingDocument);
        WorkflowEventHandling.RunWorkflowOnAfterIncomingDocReadyForOCR(IncomingDocument);
        Commit();
        OnAfterCreateIncomingDocumentBeforeOpeningCardPage(Rec, IncomingDocument, IsHandled);
        if not IsHandled then
            Page.RunModal(Page::"Incoming Document", IncomingDocument);
    end;

    internal procedure DownloadInvoicePDF(var TempBlob: Codeunit "Temp Blob") Success: Boolean
    var
        Setup: Record "Tesla API Setup";
        ApiHelper: Codeunit "Tesla API Request Helper";
        IsHandled: Boolean;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
    begin
        OnBeforeDownloadInvoicePDF(Rec, TempBlob, Success, IsHandled);
        if IsHandled then
            exit;

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
        IsHandled: Boolean;
    begin
        OnBeforeDownloadInvoicePDFFromBC(Rec, IsHandled);
        if IsHandled then
            exit;

        if DownloadInvoicePDF(TempBlob) then
            FileMgt.BLOBExport(TempBlob, fileName, true);
    end;

    local procedure GetInvoiceDownloadUrl() Url: Text
    var
        IsHandled: Boolean;
        UrlTok: Label 'https://ownership.tesla.com/mobile-app/charging/invoice/%1?deviceCountry=US&deviceLanguage=en&vin=%2', Locked = true;
    begin
        OnBeforeGetInvoiceDownloadUrl(Rec, Url, IsHandled);
        if IsHandled then
            exit;

        Url := StrSubstNo(UrlTok, LowerCase(Format(contentId).TrimStart('{}').TrimEnd('}')), vin);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAddInvoiceToIncomingDocument(var Rec: Record "Tesla Charging Invoice"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateIncomingDocumentBeforeOpeningCardPage(Rec: Record "Tesla Charging Invoice"; var IncomingDocument: Record "Incoming Document"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreatingIncomingDocumentForInvoice(Rec: Record "Tesla Charging Invoice"; var IncomingDocument: Record "Incoming Document")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDownloadInvoicePDF(var Rec: Record "Tesla Charging Invoice"; var TempBlob: Codeunit "Temp Blob"; var Success: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetInvoiceDownloadUrl(var Rec: Record "Tesla Charging Invoice"; var Url: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDownloadInvoicePDFFromBC(var Rec: Record "Tesla Charging Invoice"; var IsHandled: Boolean)
    begin
    end;
}
