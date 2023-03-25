page 60202 "Tesla Vehicle List"
{
    ApplicationArea = All;
    Caption = 'Tesla Vehicle List';
    CardPageId = "Tesla Vehicle Card";
    Editable = false;
    PageType = List;
    SourceTable = "Tesla Vehicle";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(vin; Rec.vin)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VIN field.';
                }
                field(display_name; Rec.display_name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Display Name field.';
                }
                field(id; Rec.id)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID field.';
                }
                field(in_service; Rec.in_service)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the In Service field.';
                }
                field(state; Rec.state)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the State field.';
                }
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
                ToolTip = 'Wake Up the selected vehicles.';

                trigger OnAction()
                var
                    TeslaVehicle: Record "Tesla Vehicle";
                begin
                    TeslaVehicle.Copy(Rec, true);
                    CurrPage.SetSelectionFilter(TeslaVehicle);
                    if TeslaVehicle.FindSet() then
                        repeat
                            TeslaVehicle.WakeUp();
                        until TeslaVehicle.Next() = 0;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.GetVehicles(false);
    end;
}
