table 60203 "Tesla Vehicle Status"
{
    Caption = 'Tesla Vehicle Status';
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; ID; Code[20])
        {
            Caption = 'ID';
            DataClassification = SystemMetadata;
        }
#pragma warning disable AL0468
        field(2; allow_authorized_mobile_devices_only; Boolean)
#pragma warning restore AL0468
        {
            Caption = 'Allow Authorized Mobile Devices Only';
            DataClassification = SystemMetadata;
        }
        field(3; api_version; Integer)
        {
            Caption = 'API Version';
            DataClassification = SystemMetadata;
        }
        field(4; autopark_state_v2; Text[20])
        {
            Caption = 'Autopark State V2';
            DataClassification = SystemMetadata;
        }
        field(5; calendar_supported; Boolean)
        {
            Caption = 'Calendar Supported';
            DataClassification = SystemMetadata;
        }
        field(6; car_version; Text[20])
        {
            Caption = 'Car Version';
            DataClassification = SystemMetadata;
        }
        field(7; center_display_state; Integer)
        {
            Caption = 'Center Display State';
            DataClassification = SystemMetadata;
        }
        field(8; dashcam_clip_save_available; Boolean)
        {
            Caption = 'Dashcam Clip Save Available';
            DataClassification = SystemMetadata;
        }
        field(9; dashcam_state; Text[20])
        {
            Caption = 'Dashcam State';
            DataClassification = SystemMetadata;
        }
        field(10; df; Integer)
        {
            Caption = 'df';
            DataClassification = SystemMetadata;
        }
        field(11; dr; Integer)
        {
            Caption = 'dr';
            DataClassification = SystemMetadata;
        }
        field(12; fd_window; Integer)
        {
            Caption = 'Front Driver Window';
            DataClassification = SystemMetadata;
        }
        field(13; feature_bitmask; Text[10])
        {
            Caption = 'Feature Bitmask';
            DataClassification = SystemMetadata;
        }
        field(14; fp_window; Integer)
        {
            Caption = 'Front Passanger Window';
            DataClassification = SystemMetadata;
        }
        field(15; ft; Integer)
        {
            Caption = 'Front Trunk';
            DataClassification = SystemMetadata;
        }
        field(16; homelink_device_count; Integer)
        {
            Caption = 'Homelink Device Count';
            DataClassification = SystemMetadata;
        }
        field(17; homelink_nearby; Boolean)
        {
            Caption = 'Homelink Nearby';
            DataClassification = SystemMetadata;
        }
        field(18; is_user_present; Boolean)
        {
            Caption = 'Is User Present';
            DataClassification = SystemMetadata;
        }
        field(19; locked; Boolean)
        {
            Caption = 'locked';
            DataClassification = SystemMetadata;
        }
        field(20; media_info; Blob)
        {
            Caption = 'Media Info';
            DataClassification = SystemMetadata;
        }
        field(21; media_state; Blob)
        {
            Caption = 'Media State';
            DataClassification = SystemMetadata;
        }
        field(22; notifications_supported; Boolean)
        {
            Caption = 'Notifications Supported';
            DataClassification = SystemMetadata;
        }
        field(23; odometer; Decimal)
        {
            Caption = 'Odometer';
            DataClassification = SystemMetadata;
        }
        field(24; parsed_calendar_supported; Boolean)
        {
            Caption = 'Parsed Calendar Supported';
            DataClassification = SystemMetadata;
        }
        field(25; pf; Integer)
        {
            Caption = 'pf';
            DataClassification = SystemMetadata;
        }
        field(26; pr; Integer)
        {
            Caption = 'pr';
            DataClassification = SystemMetadata;
        }
        field(27; rd_window; Integer)
        {
            Caption = 'Reard Driver Window';
            DataClassification = SystemMetadata;
        }
        field(28; remote_start; Boolean)
        {
            Caption = 'Remote Start';
            DataClassification = SystemMetadata;
        }
        field(29; remote_start_enabled; Boolean)
        {
            Caption = 'Remote Start Enabled';
            DataClassification = SystemMetadata;
        }
        field(30; remote_start_supported; Boolean)
        {
            Caption = 'Remote Start Supported';
            DataClassification = SystemMetadata;
        }
        field(31; rp_window; Integer)
        {
            Caption = 'Reard Passanger Window';
            DataClassification = SystemMetadata;
        }
        field(32; rt; Integer)
        {
            Caption = 'Reard Trunk';
            DataClassification = SystemMetadata;
        }
        field(33; santa_mode; Integer)
        {
            Caption = 'Santa Mode';
            DataClassification = SystemMetadata;
        }
        field(34; sentry_mode; Boolean)
        {
            Caption = 'Sentry Mode';
            DataClassification = SystemMetadata;
        }
        field(35; sentry_mode_available; Boolean)
        {
            Caption = 'Sentry Mode Available';
            DataClassification = SystemMetadata;
        }
        field(36; service_mode; Boolean)
        {
            Caption = 'Service Mode';
            DataClassification = SystemMetadata;
        }
        field(37; service_mode_plus; Boolean)
        {
            Caption = 'Service Mode Plus';
            DataClassification = SystemMetadata;
        }
        field(38; software_update; Blob)
        {
            Caption = 'Software Update';
            DataClassification = SystemMetadata;
        }
        field(39; speed_limit_mode; Blob)
        {
            Caption = 'Speed Limit Mode';
            DataClassification = SystemMetadata;
        }
        field(40; timestamp; BigInteger)
        {
            Caption = 'Timestamp';
            DataClassification = SystemMetadata;
        }
        field(41; tpms_hard_warning_fl; Boolean)
        {
            Caption = 'TPMS Hard Warning FL';
            DataClassification = SystemMetadata;
        }
        field(42; tpms_hard_warning_fr; Boolean)
        {
            Caption = 'TPMS Hard Warning FR';
            DataClassification = SystemMetadata;
        }
        field(43; tpms_hard_warning_rl; Boolean)
        {
            Caption = 'TPMS Hard Warning RL';
            DataClassification = SystemMetadata;
        }
        field(44; tpms_hard_warning_rr; Boolean)
        {
            Caption = 'TPMS Hard Warning RR';
            DataClassification = SystemMetadata;
        }
#pragma warning disable AL0468
        field(45; tpms_last_seen_pressure_time_fl; BigInteger)
#pragma warning restore AL0468
        {
            Caption = 'TPMS Last Seen Pressure Time FL';
            DataClassification = SystemMetadata;
        }
#pragma warning disable AL0468
        field(46; tpms_last_seen_pressure_time_fr; BigInteger)
#pragma warning restore AL0468
        {
            Caption = 'TPMS Last Seen Pressure Time FR';
            DataClassification = SystemMetadata;
        }
#pragma warning disable AL0468
        field(47; tpms_last_seen_pressure_time_rl; BigInteger)
#pragma warning restore AL0468
        {
            Caption = 'TPMS Last Seen Pressure Time RL';
            DataClassification = SystemMetadata;
        }
#pragma warning disable AL0468
        field(48; tpms_last_seen_pressure_time_rr; BigInteger)
#pragma warning restore AL0468
        {
            Caption = 'TPMS Last Seen Pressure Time RR';
            DataClassification = SystemMetadata;
        }
        field(49; tpms_pressure_fl; Decimal)
        {
            Caption = 'TPMS Pressure FL';
            DataClassification = SystemMetadata;
        }
        field(50; tpms_pressure_fr; Decimal)
        {
            Caption = 'TPMS Pressure FR';
            DataClassification = SystemMetadata;
        }
        field(51; tpms_pressure_rl; Decimal)
        {
            Caption = 'TPMS Pressure RL';
            DataClassification = SystemMetadata;
        }
        field(52; tpms_pressure_rr; Decimal)
        {
            Caption = 'TPMS Pressure RR';
            DataClassification = SystemMetadata;
        }
        field(53; tpms_rcp_front_value; Decimal)
        {
            Caption = 'TPMS RCP Front Value';
            DataClassification = SystemMetadata;
        }
        field(54; tpms_rcp_rear_value; Decimal)
        {
            Caption = 'TPMS RCP Rear Value';
            DataClassification = SystemMetadata;
        }
        field(55; tpms_soft_warning_fl; Boolean)
        {
            Caption = 'TPMS Soft Warning FL';
            DataClassification = SystemMetadata;
        }
        field(56; tpms_soft_warning_fr; Boolean)
        {
            Caption = 'TPMS Soft Warning FR';
            DataClassification = SystemMetadata;
        }
        field(57; tpms_soft_warning_rl; Boolean)
        {
            Caption = 'TPMS Soft Warning RL';
            DataClassification = SystemMetadata;
        }
        field(58; tpms_soft_warning_rr; Boolean)
        {
            Caption = 'TPMS Soft Warning RR';
            DataClassification = SystemMetadata;
        }
        field(59; valet_mode; Boolean)
        {
            Caption = 'Valet Mode';
            DataClassification = SystemMetadata;
        }
        field(60; valet_pin_needed; Boolean)
        {
            Caption = 'Valet Pin Needed';
            DataClassification = SystemMetadata;
        }
        field(61; vehicle_name; Text[30])
        {
            Caption = 'Vehicle Name';
            DataClassification = SystemMetadata;
        }
        field(62; webcam_available; Boolean)
        {
            Caption = 'Webcam Available';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Setup.GetRecordOnce();
        if not Setup."Convert To KM" then exit;
        odometer := Convert.MilesToKm(odometer);
    end;

    var
        Setup: Record "Tesla API Setup";
        Convert: Codeunit "Tesla Data Convert";

    internal procedure GetVehicleStatus(Vehicle: Record "Tesla Vehicle"; Force: Boolean)
    var
        SessionMemory: Codeunit "Tesla API Memory";
        TeslaOwnerApiHelper: Codeunit "Tesla Owner API Helper";
        HasRecords: Boolean;
    begin
        HasRecords := SessionMemory.GetInMemoryInstance(Vehicle, Rec);
        if Force then
            Rec.DeleteAll();
        Rec.ID := Vehicle.id;
        if Force or not HasRecords then
            TeslaOwnerApiHelper.DownloadWithFlowControl(GetStatusUrl(Vehicle.id_s), Rec);
        Rec.FindFirst();
    end;

    [NonDebuggable]
    internal procedure LockDoors(Vehicle: Record "Tesla Vehicle")
    var
        Setup: Record "Tesla API Setup";
        CommandResult: Record "Tesla Command Result";
        ApiHelper: Codeunit "Tesla API Request Helper";
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        ResponseJson: JsonToken;
    begin
        Setup.Get();
        ApiHelper.SetRequest(GetLockUrl(Vehicle.id_s), 'Post', Setup.GetAuthorization(), Request);
        ApiHelper.SendRequest(Request, Response, 30000);
        ResponseJson := ApiHelper.ReadAsJson(Response);
        ApiHelper.ReadJsonToken(ResponseJson, 'response', CommandResult);
        CommandResult.ShowResult();
        Modify(true);
    end;

    [NonDebuggable]
    internal procedure UnlockDoors(Vehicle: Record "Tesla Vehicle")
    var
        Setup: Record "Tesla API Setup";
        CommandResult: Record "Tesla Command Result";
        ApiHelper: Codeunit "Tesla API Request Helper";
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        ResponseJson: JsonToken;
    begin
        Setup.Get();
        ApiHelper.SetRequest(GetUnlockUrl(Vehicle.id_s), 'Post', Setup.GetAuthorization(), Request);
        ApiHelper.SendRequest(Request, Response, 30000);
        ResponseJson := ApiHelper.ReadAsJson(Response);
        ApiHelper.ReadJsonToken(ResponseJson, 'response', CommandResult);
        CommandResult.ShowResult();
        Modify(true);
    end;

    local procedure GetLockUrl(VehicleId: Text) Url: Text
    var
        IsHandled: Boolean;
        UrlTok: Label 'https://owner-api.teslamotors.com/api/1/vehicles/%1/command/door_lock', Locked = true;
    begin
        OnBeforeGetLockUrl(Rec, VehicleId, Url, IsHandled);
        if IsHandled then
            exit;

        exit(StrSubstNo(UrlTok, VehicleId));
    end;

    local procedure GetStatusUrl(VehicleId: Text) Url: Text
    var
        IsHandled: Boolean;
        UrlTok: Label 'https://owner-api.teslamotors.com/api/1/vehicles/%1/data_request/vehicle_state', Locked = true;
    begin
        OnBeforeGetStatusUrl(Rec, VehicleId, Url, IsHandled);
        if IsHandled then
            exit;

        exit(StrSubstNo(UrlTok, VehicleId));
    end;

    local procedure GetUnlockUrl(VehicleId: Text) Url: Text
    var
        IsHandled: Boolean;
        UrlTok: Label 'https://owner-api.teslamotors.com/api/1/vehicles/%1/command/door_unlock', Locked = true;
    begin
        OnBeforeGetUnlockUrl(Rec, VehicleId, Url, IsHandled);
        if IsHandled then
            exit;

        exit(StrSubstNo(UrlTok, VehicleId));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetLockUrl(var Rec: Record "Tesla Vehicle Status"; VehicleId: Text; var Url: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetStatusUrl(var Rec: Record "Tesla Vehicle Status"; VehicleId: Text; var Url: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetUnlockUrl(var Rec: Record "Tesla Vehicle Status"; VehicleId: Text; var Url: Text; var IsHandled: Boolean)
    begin
    end;
}
