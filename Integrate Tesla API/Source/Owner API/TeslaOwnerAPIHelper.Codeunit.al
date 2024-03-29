codeunit 60200 "Tesla Owner API Helper"
{
    Access = Internal;

    var
        RequestMgt: Codeunit "Tesla API Request Helper";
        LoadingMsg: Label 'Importing rows #1########\\Please wait', Comment = '%1 = no. of records imported';

    internal procedure DownloadWithFlowControl(Url: Text; RecVariant: Variant)
    begin
        DownloadWithFlowControl(Url, '', RecVariant, false);
    end;

    internal procedure DownloadWithFlowControl(Url: Text; QueryFilter: Text; RecVariant: Variant)
    begin
        DownloadWithFlowControl(Url, QueryFilter, RecVariant, false);
    end;

    internal procedure DownloadWithFlowControl(Url: Text; QueryFilter: Text; RecVariant: Variant; HideDialog: Boolean)
    var
        TempFlowControl: Record "Tesla API Flow Control" temporary;
        ResponseJson: JsonToken;
    begin
        if not HideDialog then
            TempFlowControl.OpenWindow(LoadingMsg, false);
        if not HideDialog then
            TempFlowControl.UpdateWindow(1, Format(0));
        TempFlowControl.Init();
        while TempFlowControl."Has More Rows" do begin
            GetByUrl(Url, TempFlowControl."Row Offset", QueryFilter, ResponseJson);
            RequestMgt.ReadJsonToken(ResponseJson, 'response', RecVariant);
            TempFlowControl.ReadFlowData(ResponseJson);
            TempFlowControl."Row Offset" := TempFlowControl."Row Offset" + TempFlowControl."Row Count";
            if not HideDialog then
                TempFlowControl.UpdateWindow(1, TempFlowControl."Row Count");
        end;
    end;

    local procedure GetByUrl(Url: Text; RowOffset: Integer; QueryFilter: Text; var ResponseJson: JsonToken)
    var
        Setup: Record "Tesla API Setup";
        ApiHelper: Codeunit "Tesla API Request Helper";
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
    begin
        Setup.Get();
        ApiHelper.SetRequest(Url, 'Get', Setup, Request);
        ApiHelper.SendRequest(Request, Response, 30000);
        ResponseJson := ApiHelper.ReadAsJson(Response)
    end;
}
