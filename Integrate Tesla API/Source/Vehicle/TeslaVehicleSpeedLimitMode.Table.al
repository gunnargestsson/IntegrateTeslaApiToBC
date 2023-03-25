table 60204 "Tesla Vehicle Speed Limit Mode"
{
    Caption = 'Tesla Vehicle Speed Limit Mode';
    DataClassification = SystemMetadata;
    TableType = Temporary;
    Access = Internal;

    fields
    {
        field(1; ID; Text[20])
        {
            Caption = 'ID';
            DataClassification = SystemMetadata;
        }
        field(2; active; Boolean)
        {
            Caption = 'Active';
            DataClassification = SystemMetadata;
        }
        field(3; current_limit_mph; Decimal)
        {
            Caption = 'Current Limit';
            DataClassification = SystemMetadata;
        }
        field(4; max_limit_mph; Decimal)
        {
            Caption = 'Max Limit';
            DataClassification = SystemMetadata;
        }
        field(5; min_limit_mph; Decimal)
        {
            Caption = 'Min Limit';
            DataClassification = SystemMetadata;
        }
        field(6; pin_code_set; Boolean)
        {
            Caption = 'Pin Code Set';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Setup.GetRecordOnce();
        if not Setup."Convert To KM" then exit;
        current_limit_mph := Convert.MilesToKm(current_limit_mph);
        max_limit_mph := Convert.MilesToKm(max_limit_mph);
        min_limit_mph := Convert.MilesToKm(min_limit_mph);
    end;

    var
        Setup: Record "Tesla API Setup";
        Convert: Codeunit "Tesla Data Convert";
}
