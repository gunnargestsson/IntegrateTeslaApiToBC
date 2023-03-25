table 60206 "Tesla Vehicle Media State"
{
    Caption = 'Tesla Vehicle Media State';
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
        field(2; remote_control_enabled; Boolean)
        {
            Caption = 'Remote Control Enabled';
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
