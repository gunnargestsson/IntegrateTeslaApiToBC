table 60210 "Tesla Vehicle Software Update"
{
    Caption = 'Tesla Vehicle Software Update';
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
        field(2; download_perc; Integer)
        {
            Caption = 'Download Percentage';
            DataClassification = SystemMetadata;
        }
        field(3; expected_duration_sec; Integer)
        {
            Caption = 'Expected Duration (sec)';
            DataClassification = SystemMetadata;
        }
        field(4; install_perc; Integer)
        {
            Caption = 'Install Percentage';
            DataClassification = SystemMetadata;
        }
        field(5; status; Text[30])
        {
            Caption = 'Status';
            DataClassification = SystemMetadata;
        }
        field(6; "version"; Text[20])
        {
            Caption = 'Version';
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
}
