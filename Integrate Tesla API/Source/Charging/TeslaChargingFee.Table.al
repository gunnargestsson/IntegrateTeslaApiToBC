table 60211 "Tesla Charging Fee"
{
    Access = Internal;
    Caption = 'Tesla Charging Fee';
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; sessionFeeId; Code[10])
        {
            Caption = 'Session Fee Id';
            DataClassification = SystemMetadata;
        }
        field(2; feeType; Code[20])
        {
            Caption = 'Fee Type';
            DataClassification = SystemMetadata;
        }
        field(3; payorUid; Guid)
        {
            Caption = 'Payor Unique Id';
            DataClassification = SystemMetadata;
        }
        field(4; amountDue; Decimal)
        {
            Caption = 'Amount Due';
            DataClassification = SystemMetadata;
        }
        field(5; currencyCode; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = SystemMetadata;
        }
        field(6; pricingType; Code[10])
        {
            Caption = 'Pricing Type';
            DataClassification = SystemMetadata;
        }
        field(7; usageBase; Integer)
        {
            Caption = 'Usage Base';
            DataClassification = SystemMetadata;
        }
        field(8; usageTier1; Integer)
        {
            Caption = 'Usage Tier 1';
            DataClassification = SystemMetadata;
        }
        field(9; usageTier2; Integer)
        {
            Caption = 'Usage Tier 2';
            DataClassification = SystemMetadata;
        }
        field(10; usageTier3; Integer)
        {
            Caption = 'Usage Tier 3';
            DataClassification = SystemMetadata;
        }
        field(11; usageTier4; Integer)
        {
            Caption = 'Usage Tier 4';
            DataClassification = SystemMetadata;
        }
        field(12; rateBase; Integer)
        {
            Caption = 'Rate Base';
            DataClassification = SystemMetadata;
        }
        field(13; rateTier1; Integer)
        {
            Caption = 'Rate Tier 1';
            DataClassification = SystemMetadata;
        }
        field(14; rateTier2; Integer)
        {
            Caption = 'Rate Tier 2';
            DataClassification = SystemMetadata;
        }
        field(15; rateTier3; Integer)
        {
            Caption = 'Rate Tier 3';
            DataClassification = SystemMetadata;
        }
        field(16; rateTier4; Integer)
        {
            Caption = 'Rate Tier 4';
            DataClassification = SystemMetadata;
        }
        field(17; totalTier1; Integer)
        {
            Caption = 'Total Tier 1';
            DataClassification = SystemMetadata;
        }
        field(18; totalTier2; Integer)
        {
            Caption = 'Total Tier 2';
            DataClassification = SystemMetadata;
        }
        field(19; totalTier3; Integer)
        {
            Caption = 'Total Tier 3';
            DataClassification = SystemMetadata;
        }
        field(20; totalTier4; Integer)
        {
            Caption = 'Total Tier 4';
            DataClassification = SystemMetadata;
        }
        field(21; uom; Text[10])
        {
            Caption = 'Unit of Measure';
            DataClassification = SystemMetadata;
        }
        field(22; isPaid; Boolean)
        {
            Caption = 'Is Paid';
            DataClassification = SystemMetadata;
        }
        field(23; uid; Guid)
        {
            Caption = 'Unique Id';
            DataClassification = SystemMetadata;
        }
        field(24; totalBase; Decimal)
        {
            Caption = 'Total Base';
            DataClassification = SystemMetadata;
        }
        field(25; totalDue; Decimal)
        {
            Caption = 'Total Due';
            DataClassification = SystemMetadata;
        }
        field(26; netDue; Decimal)
        {
            Caption = 'Net Due';
            DataClassification = SystemMetadata;
        }
        field(27; status; Code[10])
        {
            Caption = 'Status';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; sessionFeeId)
        {
            Clustered = true;
        }
    }
}
