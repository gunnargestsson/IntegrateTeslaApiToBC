table 60200 "Tesla API Setup"
{
    Caption = 'Tesla API Setup';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        field(2; "Tesla API Access Token"; Text[2048])
        {
            Caption = 'Tesla API Access Token';
            DataClassification = ToBeClassified;
        }
        field(3; "Tesla API Refresh Token"; Text[2048])
        {
            Caption = 'Tesla API Refresh Token';
            DataClassification = ToBeClassified;
        }
        field(4; email; Text[80])
        {
            Caption = 'E-Mail';
            DataClassification = ToBeClassified;
        }
        field(5; full_name; Text[100])
        {
            Caption = 'Full Name';
            DataClassification = ToBeClassified;
        }
        field(6; profile_image_url; Text[250])
        {
            Caption = 'Profile Image Url';
            DataClassification = ToBeClassified;
        }
        field(7; "Log Activity"; Boolean)
        {
            Caption = 'Log Activity';
            DataClassification = ToBeClassified;
        }
        field(8; "Convert To KM"; Boolean)
        {
            Caption = 'Convert To KM';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        RecordHasBeenRead: Boolean;

    trigger OnDelete()
    begin
        DeleteActivityLog();
    end;

    internal procedure DeleteActivityLog()
    var
        ActivityLog: Record "Activity Log";
    begin
        ActivityLog.SetRange("Record ID", RecordId);
        if not ActivityLog.IsEmpty then
            ActivityLog.DeleteAll();
    end;

    internal procedure GetAuthorization(): Text
    var
        AuthorizationTok: Label 'Bearer %1', Locked = true;
    begin
        TestField("Tesla API Access Token");
        exit(StrSubstNo(AuthorizationTok, "Tesla API Access Token"));
    end;

    local procedure GetDownloadUrl() Url: Text
    var
        IsHandled: Boolean;
        UrlTok: Label 'https://owner-api.teslamotors.com/api/1/users/me', Locked = true;
    begin
        OnBeforeGetDownloadUrl(Url, IsHandled);
        if IsHandled then
            exit;

        exit(UrlTok)
    end;

    internal procedure GetMe()
    var
        TeslaOwnerApiHelper: Codeunit "Tesla Owner API Helper";
        IsHandled: Boolean;
    begin
        OnBeforeGetMe(Rec, IsHandled);
        if IsHandled then
            exit;

        TeslaOwnerApiHelper.DownloadWithFlowControl(GetDownloadUrl(), Rec);

        OnAfterGetMe(Rec);
    end;

    internal procedure GetRecordOnce()
    begin
        if RecordHasBeenRead then
            exit;
        Get();
        RecordHasBeenRead := true;
    end;

    internal procedure InsertIfNotExists()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert(true);
        end;
    end;

    internal procedure ViewActivityLog()
    var
        ActivityLog: Record "Activity Log";
    begin
        ActivityLog.ShowEntries(Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetDownloadUrl(var Url: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetMe(var Rec: Record "Tesla API Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetMe(var Rec: Record "Tesla API Setup")
    begin
    end;
}