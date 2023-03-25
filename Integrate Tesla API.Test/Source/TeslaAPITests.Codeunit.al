codeunit 90200 "Tesla API Tests"
{
    Description = 'Unit Tests for Tesla API';
    Subtype = Test;

    trigger OnRun();
    begin
        IsInitialized := false;
    end;

    [Test]
    procedure "Default_Build_Test"()
    begin
        // [GIVEN] Default 
        // [WHEN] Build 
        // [THEN] Test 
    end;

    local procedure Initialize();
    begin
        LibraryTestInitialize.OnTestInitialize(Codeunit::"Tesla API Tests");
        ClearLastError();
        LibraryVariableStorage.Clear();
        LibrarySetupStorage.Restore();
        if IsInitialized then
            exit;

        LibraryTestInitialize.OnBeforeTestSuiteInitialize(Codeunit::"Tesla API Tests");

        LibraryAny.SetDefaultSeed();

        // CUSTOMIZATION: Prepare setup tables etc. that are used for all test functions


        IsInitialized := true;
        Commit();

        // CUSTOMIZATION: Add all setup tables that are changed by tests to the SetupStorage, so they can be restored for each test function that calls Initialize.
        // This is done InMemory, so it could be run after the COMMIT above
        //   LibrarySetupStorage.Save(DATABASE::"[SETUP TABLE ID]");

        LibraryTestInitialize.OnAfterTestSuiteInitialize(Codeunit::"Tesla API Tests");
    end;

    var
        Assert: Codeunit LibraryAssert;
        LibraryAny: Codeunit LibraryAny;
        LibrarySetupStorage: Codeunit "Library - Setup Storage";
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
        LibraryVariableStorage: Codeunit LibraryVariableStore;
        IsInitialized: Boolean;
}