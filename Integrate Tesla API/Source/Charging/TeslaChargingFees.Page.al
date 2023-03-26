page 60207 "Tesla Charging Fees"
{
    Caption = 'Tesla Charging Fees';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Tesla Charging Fee";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(feeType; Rec.feeType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fee Type field.';
                }
                field(usageBase; Rec.usageBase)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Usage Base field.';
                }
                field(uom; Rec.uom)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field(rateBase; Rec.rateBase)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rate Base field.';
                }
                field(totalBase; Rec.totalBase)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Base field.';
                }
                field(currencyCode; Rec.currencyCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(isPaid; Rec.isPaid)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Is Paid field.';
                }
                field(status; Rec.status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    internal procedure Set(var Fee: Record "Tesla Charging Fee")
    begin
        Rec.Copy(Fee, true)
    end;
}
