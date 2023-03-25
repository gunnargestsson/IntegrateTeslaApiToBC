page 60200 "Tesla API Setup"
{
    ApplicationArea = All;
    Caption = 'Tesla Api Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Tesla API Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Log Activity"; Rec."Log Activity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Log Activity field.';
                }
                field("Convert To KM"; Rec."Convert To KM")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Convert To KM field.';
                }
                field("Tesla API Access Token"; Rec."Tesla API Access Token")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tesla API Access Token field.';
                }
                field(email; Rec.email)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the E-Mail field.';
                }
                field(full_name; Rec.full_name)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Full Name field.';
                }
                field(profile_image_url; Rec.profile_image_url)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Profile Image Url field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ConnectToApi)
            {
                ApplicationArea = All;
                Caption = 'Connect to Tesla API';
                Image = Link;
                ToolTip = 'Executes the Connect to Tesla API action.';
                trigger OnAction()
                begin
                    CurrPage.SaveRecord();
                    Rec.GetMe();
                    CurrPage.Update((false));
                end;
            }
        }
        area(Navigation)
        {
            action(ViewActivity)
            {
                ApplicationArea = All;
                Caption = 'Activity Log';
                Enabled = Rec."Log Activity";
                Image = Log;
                ToolTip = 'View API Activity Log';
                trigger OnAction()
                begin
                    Rec.ViewActivityLog();
                end;
            }
            action(Vehicles)
            {
                ApplicationArea = All;
                Caption = 'Vehicles';
                Image = ShowList;
                ToolTip = 'View Vehicles';
                RunObject = page "Tesla Vehicle List";
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;
}
