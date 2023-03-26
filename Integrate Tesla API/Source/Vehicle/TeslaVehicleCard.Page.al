page 60201 "Tesla Vehicle Card"
{
    Caption = 'Tesla Vehicle Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    SaveValues = false;
    SourceTable = "Tesla Vehicle";
    ;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(id; Rec.id)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the ID field.';
                }
                field(display_name; Rec.display_name)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Display Name field.';
                }
                field(vin; Rec.vin)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the VIN field.';
                }
                field(state; Rec.state)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the State field.';
                }
                field(calendar_enabled; Rec.calendar_enabled)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Calendar Enabled field.';
                }
                field(in_service; Rec.in_service)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the In Service field.';
                }
                field(access_type; Rec.access_type)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Access Type field.';
                }
                field(api_version; Rec.api_version)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the API Version field.';
                }
            }
            group(Status)
            {
                Caption = 'Status';
                field(car_version; Status.car_version)
                {
                    ApplicationArea = All;
                    Caption = 'Car Version';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Car Version field.';
                }
                field(dashcam_state; Status.dashcam_state)
                {
                    ApplicationArea = All;
                    Caption = 'Dashcam State';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Dashcam State field.';
                }
                field(locked; Status.locked)
                {
                    ApplicationArea = All;
                    Caption = 'Locked';
                    ToolTip = 'Specifies the value of the Locked field.';
                    trigger OnValidate()
                    begin
                        if Status.locked then
                            Status.LockDoors(Rec)
                        else
                            Status.UnlockDoors(Rec);
                    end;
                }
                field(odometer; Status.odometer)
                {
                    ApplicationArea = All;
                    Caption = 'Odometer';
                    DecimalPlaces = 0;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Odometer field.';
                }
                field(sentry_mode; Status.sentry_mode)
                {
                    ApplicationArea = All;
                    Caption = 'Sentry Mode';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Sentry Mode field.';
                }
                field(tpms_soft_warning_fl; Status.tpms_soft_warning_fl)
                {
                    ApplicationArea = All;
                    Caption = 'TPMS Soft Warning FL';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Tire Pressure Monitoring System Soft Warning Front Left field.';
                }
                field(tpms_soft_warning_fr; Status.tpms_soft_warning_fr)
                {
                    ApplicationArea = All;
                    Caption = 'TPMS Soft Warning FR';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Tire Pressure Monitoring System Soft Warning Front Right field.';
                }
                field(tpms_soft_warning_rl; Status.tpms_soft_warning_rl)
                {
                    ApplicationArea = All;
                    Caption = 'TPMS Soft Warning RL';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Tire Pressure Monitoring System Soft Warning Rear Left field.';
                }
                field(tpms_soft_warning_rr; Status.tpms_soft_warning_rr)
                {
                    ApplicationArea = All;
                    Caption = 'TPMS Soft Warning RR';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Tire Pressure Monitoring System Soft Warning Rear Right field.';
                }
                field(valet_mode; Status.valet_mode)
                {
                    ApplicationArea = All;
                    Caption = 'Valet Mode';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Valet Mode field.';
                }
            }
        }
        area(FactBoxes)
        {
            part(OptionCodes; "Tesla Property Factbox")
            {
                ApplicationArea = All;
                Caption = 'Option Codes';
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(WakeUp)
            {
                ApplicationArea = All;
                Caption = 'Wake Up';
                Image = UpdateDescription;
                ToolTip = 'Wake Up the vehicle.';

                trigger OnAction()
                begin
                    Rec.WakeUp();
                end;
            }
            action(HonkHorn)
            {
                ApplicationArea = All;
                Caption = 'Honk Horn';
                Image = Alerts;
                ToolTip = 'Honk the horn.';

                trigger OnAction()
                begin
                    Rec.HonkHorn();
                end;
            }
            action(RefreshStatus)
            {
                ApplicationArea = All;
                Caption = 'Refresh Status';
                Image = Status;
                ToolTip = 'Refresh the vehicle status.';
                trigger OnAction()
                begin
                    Status.GetVehicleStatus(Rec, true);
                end;
            }
        }
        area(Navigation)
        {
            action(ChargingSessions)
            {
                ApplicationArea = All;
                Caption = 'Charging Sessions';
                Image = Download;
                RunObject = page "Tesla Charging Session List";
                RunPageLink = vin = field(vin);
                ToolTip = 'View charging Sessions for the vehicle.';
            }
        }
    }
    var
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        Status: Record "Tesla Vehicle Status";

    trigger OnOpenPage()
    begin
        CurrPage.OptionCodes.Page.Set(TempNameValueBuffer, false);
        Rec.GetVehicles(false);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.LoadOptionCodes(TempNameValueBuffer);
        Status.GetVehicleStatus(Rec, false);
    end;
}
