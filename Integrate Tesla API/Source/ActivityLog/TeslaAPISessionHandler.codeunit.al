codeunit 60202 "Tesla API Session Handler"
{
    Access = Internal;
    EventSubscriberInstance = Manual;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Tesla Activity Log Mgt.", 'OnBeforeStartingInsertLogSession', '', false, false)]
    local procedure OnBeforeStartingInsertLogSession(ActivityLog: Record "Activity Log"; var IsHandled: Boolean)
    var
        InsertActivityLog: Codeunit "Insert Tesla Api Activity Log";
    begin
        InsertActivityLog.InsertActivityLog(ActivityLog);
        IsHandled := true;
    end;
}
