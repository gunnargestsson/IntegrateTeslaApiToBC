table 60205 "Tesla Command Result"
{
    Access = Internal;
    Caption = 'Tesla Command Result';
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; ID; Guid)
        {
            Caption = 'ID';
            DataClassification = SystemMetadata;
        }
        field(2; result; Boolean)
        {
            Caption = 'result';
            DataClassification = SystemMetadata;
        }
        field(3; reason; Text[2048])
        {
            Caption = 'reason';
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
        ID := CreateGuid();
    end;

    internal procedure ShowResult()
    begin
        if not FindFirst() then exit;
        if result then exit;
        Error(reason);
    end;
}
