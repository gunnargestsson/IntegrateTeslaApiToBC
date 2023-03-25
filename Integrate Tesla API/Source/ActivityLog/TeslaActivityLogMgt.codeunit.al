codeunit 60203 "Tesla Activity Log Mgt."
{
    Access = Internal;

    var
        DataTypeNotValidErr: Label 'The specified variant type is not valid.';

    internal procedure InsertActivity(Success: Boolean; NewContext: Text[30]; ActivityDescription: Text; ActivityMessage: Text)
    var
        Setup: Record "Tesla API Setup";
    begin
        if not Setup.Get() then exit;
        if not Setup."Log Activity" then exit;
        InsertActivity(Setup, Success, NewContext, ActivityDescription, ActivityMessage);
    end;

    [NonDebuggable]
    internal procedure InsertActivity(Success: Boolean; NewContext: Text[30]; ActivityDescription: Text; ActivityMessageAsJson: JsonToken)
    var
        ActivityMessage: Text;
    begin
        if ActivityMessageAsJson.IsObject then begin
            if ActivityMessageAsJson.AsObject().Contains('ClientToken') then
                ActivityMessageAsJson.AsObject().Remove('ClientToken');
            if ActivityMessageAsJson.AsObject().Contains('AccessToken') then
                ActivityMessageAsJson.AsObject().Remove('AccessToken');
        end;
        ActivityMessageAsJson.WriteTo(ActivityMessage);
        InsertActivity(Success, NewContext, ActivityDescription, ActivityMessage);
    end;

    internal procedure InsertActivity(NewContext: Text[30]; ActivityDescription: Text; Response: HttpResponseMessage)
    var
        HasContent, Success : Boolean;
        ActivityMessage: Text;
    begin
        Success := Response.IsSuccessStatusCode;
        HasContent := Response.Content().ReadAs(ActivityMessage);
        InsertActivity(Success and HasContent, NewContext, ActivityDescription, ActivityMessage);
    end;

    internal procedure InsertActivity(NewContext: Text[30]; ActivityDescription: Text; Request: HttpRequestMessage)
    var
        Success: Boolean;
        ActivityMessage: Text;
    begin
        Success := Request.Content().ReadAs(ActivityMessage);
        InsertActivity(Success, NewContext, ActivityDescription, ActivityMessage);
    end;

    internal procedure InsertActivity(RelatedVariant: Variant; Success: Boolean; NewContext: Text[30]; ActivityDescription: Text; ActivityMessage: Text)
    var
        ActivityLog: Record "Activity Log";
        IsHandled: Boolean;
        ActivityLogSessionId: Integer;
    begin
        if not LogActivity(RelatedVariant, Success, NewContext, ActivityDescription, ActivityMessage, ActivityLog) then exit;
        IsHandled := false;
        OnBeforeStartingInsertLogSession(ActivityLog, IsHandled);
        if not IsHandled then
            StartSession(ActivityLogSessionId, Codeunit::"Insert Tesla Api Activity Log", CompanyName, ActivityLog);
    end;

    internal procedure InsertActivity(RelatedVariant: Variant; Success: Boolean; CodeunitID: Integer; ActivityDescription: Text; ActivityMessage: Text)
    var
        AllObj: Record AllObj;
    begin
        AllObj.SetRange("Object Type", AllObj."Object Type"::Codeunit);
        AllObj.SetRange("Object ID", CodeunitID);
        AllObj.FindFirst();

        InsertActivity(RelatedVariant, Success, Format(AllObj."Object Name"), ActivityDescription, ActivityMessage);
    end;

    local procedure LogActivity(RelatedVariant: Variant; Success: Boolean; NewContext: Text[30]; ActivityDescription: Text; ActivityMessage: Text; var ActivityLog: Record "Activity Log"): Boolean
    begin
        exit(LogActivityImplementation(RelatedVariant, Success, NewContext, ActivityDescription, ActivityMessage, ActivityLog));
    end;

    local procedure LogActivityImplementation(RelatedVariant: Variant; Success: Boolean; NewContext: Text[30]; ActivityDescription: Text; ActivityMessage: Text; var ActivityLog: Record "Activity Log"): Boolean
    var
        Setup: Record "Tesla API Setup";
        DataTypeManagement: Codeunit "Data Type Management";
        RecRef: RecordRef;
        FldRef: FieldRef;
        IgnoreActivityLog: Boolean;
    begin
        Clear(ActivityLog);
        IgnoreActivityLog := false;

        if not DataTypeManagement.GetRecordRef(RelatedVariant, RecRef) then
            Error(DataTypeNotValidErr);

        if RecRef.Number = Database::"Tesla API Setup" then
            if DataTypeManagement.FindFieldByName(RecRef, FldRef, Setup.FieldName("Log Activity")) then
                IgnoreActivityLog := not FldRef.Value;

        OnBeforeInitActivityLog(RelatedVariant, Success, NewContext, ActivityDescription, ActivityMessage, IgnoreActivityLog);

        if IgnoreActivityLog then exit(false);
        ActivityLog."Record ID" := RecRef.RecordId;
        ActivityLog."Activity Date" := CurrentDateTime;
        ActivityLog."User ID" := CopyStr(UserId, 1, MaxStrLen(ActivityLog."User ID"));
        if Success then
            ActivityLog.Status := ActivityLog.Status::Success
        else
            ActivityLog.Status := ActivityLog.Status::Failed;
        ActivityLog.Context := NewContext;
        ActivityLog.Description := CopyStr(ActivityDescription, 1, MaxStrLen(ActivityLog.Description));
        ActivityLog."Activity Message" := CopyStr(ActivityMessage, 1, MaxStrLen(ActivityLog."Activity Message"));
        ActivityLog."Table No Filter" := RecRef.Number;

        if StrLen(ActivityMessage) > MaxStrLen(ActivityLog."Activity Message") then
            SetDetailedInfoFromText(ActivityMessage, ActivityLog);
        OnAfterInitActivityLog(RelatedVariant, Success, NewContext, ActivityDescription, ActivityMessage);
        exit(true);
    end;

    local procedure SetDetailedInfoFromText(Details: Text; var ActivityLog: Record "Activity Log")
    var
        OutputStream: OutStream;
    begin
        ActivityLog."Detailed Info".CreateOutStream(OutputStream);
        OutputStream.WriteText(Details);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitActivityLog(RelatedVariant: Variant; Success: Boolean; NewContext: Text[30]; ActivityDescription: Text; ActivityMessage: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitActivityLog(RelatedVariant: Variant; Success: Boolean; NewContext: Text[30]; ActivityDescription: Text; ActivityMessage: Text; var IgnoreActivityLog: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeStartingInsertLogSession(ActivityLog: Record "Activity Log"; var IsHandled: Boolean)
    begin
    end;
}