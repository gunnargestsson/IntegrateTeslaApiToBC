table 60201 "Tesla Vehicle"
{
    Caption = 'Tesla Vehicle';
    DataClassification = SystemMetadata;
    TableType = Temporary;
    DataCaptionFields = display_name;
    Access = Internal;

    fields
    {
        field(1; id; Code[20])
        {
            Caption = 'ID';
            DataClassification = SystemMetadata;
        }
        field(2; vehicle_id; Code[20])
        {
            Caption = 'Vehicle ID';
            DataClassification = SystemMetadata;
        }
        field(3; vin; Code[20])
        {
            Caption = 'VIN';
            DataClassification = SystemMetadata;
        }
        field(4; display_name; Text[30])
        {
            Caption = 'Display Name';
            DataClassification = SystemMetadata;
        }
        field(5; color; Text[30])
        {
            Caption = 'Color';
            DataClassification = SystemMetadata;
        }
        field(6; access_type; Code[20])
        {
            Caption = 'Access Type';
            DataClassification = SystemMetadata;
        }
        field(7; state; Text[20])
        {
            Caption = 'State';
            DataClassification = SystemMetadata;
        }
        field(8; in_service; Boolean)
        {
            Caption = 'In Service';
            DataClassification = SystemMetadata;
        }
        field(9; id_s; Code[20])
        {
            Caption = 'API ID';
            DataClassification = SystemMetadata;
        }
        field(10; calendar_enabled; Boolean)
        {
            Caption = 'Calendar Enabled';
            DataClassification = SystemMetadata;
        }
        field(11; api_version; Integer)
        {
            Caption = 'API Version';
            DataClassification = SystemMetadata;
        }
        field(12; backseat_token; Text[250])
        {
            Caption = 'Backseat Token';
            DataClassification = SystemMetadata;
        }
        field(13; backseat_token_updated_at; DateTime)
        {
            Caption = 'Backseat Token Updated At';
            DataClassification = SystemMetadata;
        }
        field(14; ble_autopair_enrolled; Boolean)
        {
            Caption = 'BLE Autopair Enrolled';
            DataClassification = SystemMetadata;
        }
        field(15; option_codes; Blob)
        {
            Caption = 'Option Codes';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; id)
        {
            Clustered = true;
        }
    }

    internal procedure LoadOptionCodes(var TempNameValueBuffer: Record "Name/Value Buffer")
    var
        TempBlob: Codeunit "Temp Blob";
        InStr: Instream;
        OptionCode, OptionCodes : Text;
        OptionCodeList: List of [Text];
    begin
        TempNameValueBuffer.DeleteAll();
        TempBlob.FromRecord(Rec, FieldNo(option_codes));
        if not TempBlob.HasValue() then
            exit;

        TempBlob.CreateInStream(InStr, TextEncoding::UTF8);
        InStr.ReadText(OptionCodes);
        OptionCodeList := OptionCodes.Split(',');
        foreach OptionCode in OptionCodeList do
            TempNameValueBuffer.AddNewEntry(OptionCode, '');
    end;

    local procedure GetDownloadUrl() Url: Text
    var
        IsHandled: Boolean;
        UrlTok: Label 'https://owner-api.teslamotors.com/api/1/vehicles', Locked = true;
    begin
        OnBeforeGetDownloadUrl(Url, IsHandled);
        if IsHandled then
            exit;

        exit(UrlTok)
    end;

    local procedure GetWakeUpUrl() Url: Text
    var
        IsHandled: Boolean;
        UrlTok: Label 'https://owner-api.teslamotors.com/api/1/vehicles/%1/wake_up', Locked = true;
    begin
        OnBeforeGetWakeUpUrl(Rec, Url, IsHandled);
        if IsHandled then
            exit;

        exit(StrSubStNo(UrlTok, id_s));
    end;

    local procedure GetHonkHornUrl() Url: Text
    var
        IsHandled: Boolean;
        UrlTok: Label 'https://owner-api.teslamotors.com/api/1/vehicles/%1/command/honk_horn', Locked = true;
    begin
        OnBeforeGetHonkHornUrl(Rec, Url, IsHandled);
        if IsHandled then
            exit;

        exit(StrSubStNo(UrlTok, id_s));
    end;

    internal procedure GetVehicles(Force: Boolean)
    var
        SessionMemory: Codeunit "Tesla API Memory";
        TeslaOwnerApiHelper: Codeunit "Tesla Owner API Helper";
        IsHandled, HasRecords : Boolean;
    begin
        OnBeforeGetVehicles(Rec, IsHandled);
        if IsHandled then
            exit;

        HasRecords := SessionMemory.GetInMemoryInstance(Rec);
        if Force then
            Rec.DeleteAll();
        if Force or not HasRecords then
            TeslaOwnerApiHelper.DownloadWithFlowControl(GetDownloadUrl(), Rec);

        OnAfterGetVehicles(Rec);
    end;

    [NonDebuggable]
    internal procedure WakeUp()
    var
        Setup: Record "Tesla API Setup";
        ApiHelper: Codeunit "Tesla API Request Helper";
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        ResponseJson: JsonToken;
    begin
        Setup.Get();
        ApiHelper.SetRequest(GetWakeUpUrl(), 'Post', Setup.GetAuthorization(), Request);
        ApiHelper.SendRequest(Request, Response, 30000);
        ResponseJson := ApiHelper.ReadAsJson(Response);
        ApiHelper.ReadJsonArray(ResponseJson, 'response', Rec);
    end;

    [NonDebuggable]
    internal procedure HonkHorn()
    var
        Setup: Record "Tesla API Setup";
        CommandResult: Record "Tesla Command Result";
        ApiHelper: Codeunit "Tesla API Request Helper";
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        ResponseJson: JsonToken;
    begin
        Setup.Get();
        ApiHelper.SetRequest(GetHonkHornUrl(), 'Post', Setup.GetAuthorization(), Request);
        ApiHelper.SendRequest(Request, Response, 30000);
        ResponseJson := ApiHelper.ReadAsJson(Response);
        ApiHelper.ReadJsonArray(ResponseJson, 'response', CommandResult);
        CommandResult.ShowResult();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetDownloadUrl(var Url: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetVehicles(var Rec: Record "Tesla Vehicle"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetVehicles(var Rec: Record "Tesla Vehicle")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetWakeUpUrl(var Rec: Record "Tesla Vehicle"; var Url: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetHonkHornUrl(var Rec: Record "Tesla Vehicle"; var Url: Text; var IsHandled: Boolean)
    begin
    end;
}
