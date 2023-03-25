codeunit 90205 "Library - Setup Storage"
{
    Permissions = tabledata "General Ledger Setup" = rimd;

    trigger OnRun()
    begin
    end;

    var
        TempIntegerStoredTables: Record "Integer" temporary;
        Assert: Codeunit LibraryAssert;
        RecordRefStorage: array[100] of RecordRef;
        CompositePrimaryKeyErr: Label 'Composite primary key is not allowed';
        OnlyOneEntryAllowedErr: Label 'Setup table with only one entry is allowed';
        TableBackupErr: Label 'Table %1 already added to backup', Comment = '%1 = Table Caption';

    procedure Restore()
    var
        RecordRefDestination: RecordRef;
        RecordRefSource: RecordRef;
        Index: Integer;
    begin
        Index := TempIntegerStoredTables.Count();
        while Index > 0 do begin
            RecordRefSource := RecordRefStorage[Index];
            RecordRefDestination.Open(RecordRefSource.Number);
            CopyFields(RecordRefSource, RecordRefDestination);
            RecordRefDestination.Modify();
            RecordRefDestination.Close();
            Index -= 1;
        end;
    end;

    procedure Save(TableId: Integer)
    var
        RecRef: RecordRef;
    begin
        if TempIntegerStoredTables.Get(TableId) then
            Error(TableBackupErr, TableId);

        RecRef.Open(TableId);
        Assert.AreEqual(1, RecRef.Count, OnlyOneEntryAllowedErr);
        RecRef.Find();
        ValidatePrimaryKey(RecRef);

        TempIntegerStoredTables.Number := TableId;
        TempIntegerStoredTables.Insert(true);
        RecordRefStorage[TempIntegerStoredTables.Count] := RecRef;
    end;

    procedure SaveCompanyInformation()
    begin
        Save(Database::"Company Information");
    end;

    procedure SaveGeneralLedgerSetup()
    begin
        Save(Database::"General Ledger Setup");
    end;

    procedure SaveManufacturingSetup()
    begin
        Save(Database::"Manufacturing Setup");
    end;

    procedure SavePurchasesSetup()
    begin
        Save(Database::"Purchases & Payables Setup");
    end;

    procedure SaveSalesSetup()
    begin
        Save(Database::"Sales & Receivables Setup");
    end;

    local procedure CopyFields(RecordRefSource: RecordRef; var RecordRefDestination: RecordRef)
    var
        DestinationFieldRef: FieldRef;
        SourceFieldRef: FieldRef;
        i: Integer;
    begin
        for i := 1 to RecordRefSource.FieldCount do begin
            SourceFieldRef := RecordRefSource.FieldIndex(i);
            if SourceFieldRef.Class = FieldClass::Normal then begin
                DestinationFieldRef := RecordRefDestination.Field(SourceFieldRef.Number);
                DestinationFieldRef.Value(SourceFieldRef.Value)
            end;
        end
    end;

    local procedure ValidatePrimaryKey(var RecRef: RecordRef)
    var
        KeyRef: KeyRef;
    begin
        KeyRef := RecRef.KeyIndex(1);
        Assert.AreEqual(1, KeyRef.FieldCount, CompositePrimaryKeyErr);
    end;
}
