table 60208 "Tesla Charging Invoice"
{
    Access = Internal;
    Caption = 'Tesla Charging Invoice';
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; contentId; Guid)
        {
            Caption = 'Content ID';
            DataClassification = SystemMetadata;
        }
        field(2; fileName; Text[50])
        {
            Caption = 'File Name';
            DataClassification = SystemMetadata;
        }
        field(3; invoiceType; Text[20])
        {
            Caption = 'Invoice Type';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; contentId)
        {
            Clustered = true;
        }
    }
}
