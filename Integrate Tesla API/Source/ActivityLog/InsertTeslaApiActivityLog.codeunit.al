codeunit 60204 "Insert Tesla Api Activity Log"
{
    Access = Internal;
    TableNo = "Activity Log";

    trigger OnRun()
    begin
        InsertActivityLog(Rec);
    end;

    internal procedure InsertActivityLog(var Rec: Record "Activity Log")
    var
        ActivityLog: Record "Activity Log";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeInsertActivityLog(Rec, IsHandled);
        if IsHandled then exit;

        if not ActivityLogExists(ActivityLog) then begin
            ActivityLog.LockTable(true);
            ActivityLog.TransferFields(Rec, true);
            ActivityLog.ID := 0;
            ActivityLog.Insert();
            Commit();
        end;
    end;

    local procedure ActivityLogExists(ActivityLog: Record "Activity Log"): Boolean
    begin
        ActivityLog.SetRange("Record ID", ActivityLog."Record ID");
        ActivityLog.SetRange(Context, ActivityLog.Context);
        ActivityLog.SetRange(Description, ActivityLog.Description);
        ActivityLog.SetRange(Status, ActivityLog.Status);
        exit(not ActivityLog.IsEmpty());
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertActivityLog(var ActivityLog: Record "Activity Log"; var IsHandled: Boolean)
    begin
    end;
}
