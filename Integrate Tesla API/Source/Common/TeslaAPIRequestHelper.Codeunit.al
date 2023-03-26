codeunit 60201 "Tesla API Request Helper"
{
    Access = Internal;

    var
        RequestTok: Label 'Request';
        ResponseTok: Label 'Response';

    internal procedure AddReplaceContentHeader(var Request: HttpRequestMessage; HeaderName: Text; HeaderValue: Text)
    var
        Headers: HttpHeaders;
    begin
        Request.Content().GetHeaders(Headers);
        if Headers.Contains(HeaderName) then
            Headers.Remove(HeaderName);
        Headers.Add(HeaderName, HeaderValue);
    end;

    internal procedure AddReplaceRequestHeader(var Request: HttpRequestMessage; HeaderName: Text; HeaderValue: Text)
    var
        Headers: HttpHeaders;
    begin
        Request.GetHeaders(Headers);
        if Headers.Contains(HeaderName) then
            Headers.Remove(HeaderName);
        Headers.Add(HeaderName, HeaderValue);
    end;

    internal procedure GetChildJsonToken(JToken: JsonToken; ChildName: Text) ChildJToken: JsonToken
    begin
        JToken.AsObject().Get(ChildName, ChildJToken);
    end;

    internal procedure ReadAsJson(var Response: HttpResponseMessage) Json: JsonToken
    var
        JsonAsText: Text;
    begin
        Response.Content().ReadAs(JsonAsText);
        Json.ReadFrom(JsonAsText);
    end;

    internal procedure ReadAsTempBlob(var Response: HttpResponseMessage; var TempBlob: Codeunit "Temp Blob")
    var
        ResponseStream: InStream;
        OutStr: OutStream;
    begin
        CreateResponseStream(ResponseStream);
        Response.Content().ReadAs(ResponseStream);
        TempBlob.CreateOutStream(OutStr);
        CopyStream(OutStr, ResponseStream);
    end;

    internal procedure ReadJsonToken(var ResponseJson: JsonToken; ArrayName: Text; RecVariant: Variant)
    var
        DataTypeMgt: Codeunit "Data Type Management";
        TemplateRecRef: RecordRef;
        JArray, JObject : JsonToken;
    begin
        if not DataTypeMgt.GetRecordRef(RecVariant, TemplateRecRef) then exit;
        if ArrayName = '' then
            JArray := ResponseJson
        else
            if not ResponseJson.AsObject().Get(ArrayName, JArray) then exit;
        if JArray.IsValue() then
            if JArray.AsValue().IsNull() then exit;
        if JArray.IsObject() then begin
            ReadJsonObject(TemplateRecRef, JArray);
            exit;
        end;

        foreach JObject in JArray.AsArray() do
            ReadJsonObject(TemplateRecRef, JObject);
    end;

    internal procedure SendRequest(var Request: HttpRequestMessage; var Response: HttpResponseMessage; SessionTimeout: Duration)
    var
        AcitivityLogMgt: Codeunit "Tesla Activity Log Mgt.";
        IsHandled: Boolean;
        Client: HttpClient;
    begin
        OnBeforeSendRequest(Request, Response, IsHandled);
        if IsHandled then
            exit;

        if UpperCase(Request.Method()) = 'GET' then
            AcitivityLogMgt.InsertActivity(true, RequestTok, Request.GetRequestUri(), '');
        AddReplaceRequestHeader(Request, 'User-Agent', 'BusincessCentralIntegration/1.0');
        Client.Timeout(SessionTimeout);
        Client.Send(Request, Response);
        AcitivityLogMgt.InsertActivity(ResponseTok, Request.GetRequestUri(), Response);
        ThrowErrorIfNotSuccess(Response);
    end;

    [NonDebuggable]
    internal procedure SetRequest(Url: Text; Method: Text; Authorization: Text; var Request: HttpRequestMessage)
    var
        Headers: HttpHeaders;
    begin
        Clear(Request);
        Request.Method(Method);
        Request.SetRequestUri(Url);
        Request.GetHeaders(Headers);
        if Authorization <> '' then
            Headers.Add('Authorization', Authorization);
    end;

    [NonDebuggable]
    internal procedure SetRequestContent(var Request: HttpRequestMessage; ContentType: Text; ContentJson: JsonToken)
    var
        ContentText: Text;
    begin
        ContentJson.WriteTo(ContentText);
        SetRequestContent(Request, ContentType, ContentText);
    end;

    internal procedure SetRequestContent(var Request: HttpRequestMessage; ContentType: Text; var ContentStream: InStream)
    var
        AcitivityLogMgt: Codeunit "Tesla Activity Log Mgt.";
    begin
        Request.Content().WriteFrom(ContentStream);
        AddReplaceContentHeader(Request, 'Content-Type', ContentType);
        AcitivityLogMgt.InsertActivity(RequestTok, Request.GetRequestUri(), Request);
    end;

    internal procedure SetRequestContent(var Request: HttpRequestMessage; ContentType: Text; ContentText: Text)
    var
        AcitivityLogMgt: Codeunit "Tesla Activity Log Mgt.";
    begin
        Request.Content().WriteFrom(ContentText);
        AddReplaceContentHeader(Request, 'Content-Type', ContentType);
        AcitivityLogMgt.InsertActivity(RequestTok, Request.GetRequestUri(), Request);
    end;

    internal procedure WebServiceError(Response: HttpResponseMessage; ErrorMessage: TextBuilder)
    var
        ErrorCodeErr: Label 'Error code: %1', Comment = '%1 = error code';
        ResponseText: Text;
    begin
        ErrorMessage.AppendLine(StrSubstNo(ErrorCodeErr, Response.HttpStatusCode()));
        ErrorMessage.AppendLine(Response.ReasonPhrase());
        ErrorMessage.AppendLine();
        Response.Content().ReadAs(ResponseText);
        ErrorMessage.Append(ResponseText);
        Error(ErrorMessage.ToText());
    end;

    local procedure CreateResponseStream(var ResponseStream: InStream)
    var
        TempBlob: Codeunit "Temp Blob";
    begin
        TempBlob.CreateInStream(ResponseStream);
    end;

    local procedure PopulateTableFromJson(JObject: JsonObject; FieldNameFilter: Text; var RecRef: RecordRef) Success: Boolean
    var
        FldRec: Record "Field";
        FldRef: FieldRef;
        FldIndex: Integer;
        FieldName: Text;
    begin
        FldRec.SetRange(TableNo, RecRef.Number());
        FldRec.SetRange(Enabled, true);
        FldRec.SetRange(Class, FldRec.Class::Normal);
        FldRec.SetFilter(FieldName, FieldNameFilter);
        for FldIndex := 1 to RecRef.FieldCount() do begin
            FldRef := RecRef.FieldIndex(FldIndex);
            FldRec.SetRange("No.", FldRef.Number());
            if not FldRec.IsEmpty then begin
                FieldName := FldRef.Name();
                Success := TryPopulateTableFieldFromJson(JObject, FieldName, FldRef);
            end;
        end;
    end;

    local procedure ReadJsonObject(var TemplateRecRef: RecordRef; var JObject: JsonToken)
    var
        RecRef: RecordRef;
        xRecRef: RecordRef;
    begin
        RecRef := TemplateRecRef.Duplicate();
        PopulateTableFromJson(JObject.AsObject(), '', RecRef);
        xRecRef := RecRef.Duplicate();
        if xRecRef.Get(RecRef.RecordId) then
            RecRef.Modify(true)
        else
            RecRef.Insert(true);
    end;

    local procedure ThrowErrorIfNotSuccess(var Response: HttpResponseMessage)
    var
        ErrorMessage: TextBuilder;
    begin
        if not Response.IsSuccessStatusCode() then
            WebServiceError(Response, ErrorMessage);
    end;

    [TryFunction]
    local procedure TryPopulateTableFieldFromJson(JObject: JsonObject; propertyPath: Text; var FieldRef: FieldRef)
    var
        JToken: JsonToken;
        JText: Text;
        Value: Variant;
    begin
        if not JObject.SelectToken(propertyPath, JToken) then exit;

        case true of
            JToken.IsArray():
                begin
                    if JToken.AsArray().Count = 0 then
                        exit;
                    JToken.AsArray().WriteTo(JText);
                    Value := JText;
                end;
            JToken.IsObject():
                begin
                    JToken.AsObject().WriteTo(JText);
                    Value := JText;
                end;
            JToken.IsValue():
                begin
                    if JToken.AsValue().IsNull() then
                        exit;
                    Value := JToken.AsValue().AsText();
                end;
        end;
        TryPopulateTableFieldFromValue(Value, FieldRef);
    end;

    [TryFunction]
    local procedure TryPopulateTableFieldFromValue(Value: Variant; var FieldRef: FieldRef)
    var
        OutlookSynchTypeConv: Codeunit "Outlook Synch. Type Conv";
        BoolVal: Boolean;
        DateVal: Date;
        DateTimeVal: DateTime;
        DecimalVal: Decimal;
        GuidVal: Guid;
        IntVar: Integer;
    begin
        case Format(FieldRef.Type()) of
            'Integer',
            'Decimal':
                begin
                    Evaluate(DecimalVal, Value, 9);
                    FieldRef.Value(DecimalVal);
                end;
            'DateTime':
                begin
                    Evaluate(DateTimeVal, Value, 9);
                    FieldRef.Value(DateTimeVal);
                end;
            'Date':
                begin
                    Evaluate(DateVal, Value, 9);
                    FieldRef.Value(DateVal);
                end;
            'Boolean':
                begin
                    if not Evaluate(BoolVal, Value, 9) then
                        BoolVal := Format(Value) = 'Y';
                    FieldRef.Value(BoolVal);
                end;
            'GUID':
                begin
                    Evaluate(GuidVal, Value);
                    FieldRef.Value(GuidVal);
                end;
            'Text',
            'Code':
                FieldRef.Value(CopyStr(Value, 1, FieldRef.Length()));
            'Option':
                begin
                    if not Evaluate(IntVar, Value) then
                        IntVar := OutlookSynchTypeConv.TextToOptionValue(Value, FieldRef.OptionCaption());
                    if IntVar >= 0 then
                        FieldRef.Value := IntVar
                    else
                        Error('');
                end;
            'BLOB':
                if TryReadToBlob(FieldRef, Value) then
                    ;
        end;
    end;

    [TryFunction]
    local procedure TryReadToBlob(var BlobFieldRef: FieldRef; Value: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
    begin
        TempBlob.CreateOutStream(OutStr, TextEncoding::UTF8);
        OutStr.WriteText(Value);
        TempBlob.ToFieldRef(BlobFieldRef);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSendRequest(var Request: HttpRequestMessage; var Response: HttpResponseMessage; var IsHandled: Boolean)
    begin
    end;
}
