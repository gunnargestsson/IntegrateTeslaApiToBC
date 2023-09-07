page 60203 "Tesla Property Factbox"
{
    Caption = 'Tesla Property Factbox';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Name/Value Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the Azure Active Directory application that will be used to connect to Exchange.';
                }
                field(PropertyValueField; Rec.GetValue())
                {
                    ApplicationArea = All;
                    Caption = 'Value';
                    ToolTip = 'Specifies the value of the GetValue() field.';
                    Visible = ShowValue;
                }
            }
        }
    }

    var
        ShowValue: Boolean;

    internal procedure Set(var TempNameValueBuffer: Record "Name/Value Buffer"; NewShowValue: Boolean)
    begin
        Rec.Copy(TempNameValueBuffer, true);
        ShowValue := NewShowValue;
    end;
}
