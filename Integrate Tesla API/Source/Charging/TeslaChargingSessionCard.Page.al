page 60206 "Tesla Charging Session Card"
{
    Caption = 'Tesla Charging Session Card';
    PageType = Card;
    SourceTable = "Tesla Charging Session";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;

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
                field(chargingPackage; Rec.chargingPackage)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Charging Package field.';
                }
                field(countryCode; Rec.countryCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country Code field.';
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
            }
            part(Invoices; "Tesla Charging Invoices")
            {
                ApplicationArea = All;
                Caption = 'Invoices';
                Editable = false;
            }
            part(Fees; "Tesla Charging Fees")
            {
                ApplicationArea = All;
                Caption = 'Fees';
                Editable = false;
            }
        }
    }

    var
        Fee: Record "Tesla Charging Fee";
        Invoice: Record "Tesla Charging Invoice";

    trigger OnOpenPage();
    begin
        CurrPage.Invoices.Page.Set(Invoice);
        CurrPage.Fees.Page.Set(Fee);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.LoadInvoices(Invoice);
        Rec.LoadFees(Fee);
    end;
}
