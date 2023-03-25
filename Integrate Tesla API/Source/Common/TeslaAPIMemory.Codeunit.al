codeunit 60205 "Tesla API Memory"
{
    SingleInstance = true;
    Access = Internal;

    var
        VehicleInMemory: Record "Tesla Vehicle";
        VehicleStatusInMemory: Record "Tesla Vehicle Status";

    procedure GetInMemoryInstance(var Vehicle: Record "Tesla Vehicle") HasRecords: Boolean;
    begin
        Vehicle.Copy(VehicleInMemory, true);
        HasRecords := not Vehicle.IsEmpty();
    end;

    procedure GetInMemoryInstance(Vehicle: Record "Tesla Vehicle"; var VehicleStatus: Record "Tesla Vehicle Status") HasRecords: Boolean;
    begin
        VehicleStatus.Copy(VehicleStatusInMemory, true);
        VehicleStatus.SetRange(ID, Vehicle.id);
        HasRecords := not VehicleStatus.IsEmpty();
    end;
}
