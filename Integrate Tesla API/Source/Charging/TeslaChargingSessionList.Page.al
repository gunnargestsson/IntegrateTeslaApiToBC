page 60205 "Tesla Charging Session List"
{
    ApplicationArea = All;
    Caption = 'Tesla Charging Session List';
    CardPageId = "Tesla Charging Session Card";
    Editable = false;
    PageType = List;
    SourceTable = "Tesla Charging Session";
    SourceTableView = sorting(chargeStartDateTime) order(descending);
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(chargeSessionId; Rec.chargeSessionId)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Charge Session Id field.';
                }
                field(chargeStartDateTime; Rec.chargeStartDateTime)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Charge Start Date Time field.';
                }
                field(siteLocationName; Rec.siteLocationName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Site Location Name field.';
                }
                field(vehicleMakeType; Rec.vehicleMakeType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vehicle Make Type field.';
                }
                field(vin; Rec.vin)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VIN field.';
                }
                field(countryCode; Rec.countryCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country Code field.';
                }
                field(chargingPackage; Rec.chargingPackage)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Charging Package field.';
                }
                field(billingType; Rec.billingType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Billing Type field.';
                }
                field(programType; Rec.programType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Program Type field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(DownloadSessions)
            {
                ApplicationArea = All;
                Caption = 'Download Sessions';
                Image = Download;
                ToolTip = 'Download the charging sessions from Tesla.';
                trigger OnAction()
                var
                    TeslaChargingSession: Record "Tesla Charging Session";
                begin
                    TeslaChargingSession.GetChargingSessions();
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
