page 60203 "Tesla Property Factbox"
{
    Caption = 'Tesla Property Factbox';
    PageType = ListPart;
    SourceTable = "Name/Value Buffer";
    SourceTableTemporary = true;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Value"; Rec.GetValue())
                {
                    ApplicationArea = All;
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
