table 60202 "Tesla API Flow Control"
{
    Access = Internal;
    Caption = 'Tesla API Flow Control';
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; ID; Guid)
        {
            Caption = 'ID';
            DataClassification = SystemMetadata;
        }
        field(2; "Has More Rows"; Boolean)
        {
            Caption = 'Has More Rows';
            DataClassification = SystemMetadata;
            InitValue = true;
        }
        field(3; "Row Offset"; Integer)
        {
            Caption = 'Row Offset';
            DataClassification = SystemMetadata;
        }
        field(4; "Row Total"; Integer)
        {
            Caption = 'Row Total';
            DataClassification = SystemMetadata;
        }
        field(5; "Row Count"; Integer)
        {
            Caption = 'Row Count';
            DataClassification = SystemMetadata;
        }
        field(6; "Page Number"; Integer)
        {
            Caption = 'Page Number';
            DataClassification = SystemMetadata;
            InitValue = 1;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }

    var
        LastUpdate: DateTime;
        StartTime: DateTime;
        Window: Dialog;

    /// <summary>
    /// Raises an event to be able to change the return of IsGuiAllowed function. Used for testing.
    /// </summary>
    [InternalEvent(false)]
    internal procedure OnBeforeGuiAllowed(var Result: Boolean; var Handled: Boolean)
    begin
    end;

    internal procedure OpenWindow(DialogString: Text; ShowEstimatedEndTime: Boolean)
    var
        ElapsedTimeTxt: Label '\\Elapsed time :.................. #21#############', Comment = '%21 = Elapsed Time';
        EstimatedEndTimeTxt: Label '\Estimated end time :..... #23#############', Comment = '%23 = Calculated End Time';
        EstimatedTimeLeftTxt: Label '\Estimated time left :...... #22#############', Comment = '%22 = Estimated time left';
        ProgressBarPlaceHolderTxt: Label '#20###############################################', Comment = '%20 = Progress Bar Text', Locked = true;
        WindowString: Text;
    begin
        if not IsGuiAllowed() then
            exit;

        StartTime := 0DT;
        WindowString := DialogString;
        if WindowString = '' then
            WindowString := ProgressBarPlaceHolderTxt
        else
            WindowString := WindowString + '\\' + ProgressBarPlaceHolderTxt;

        if ShowEstimatedEndTime then begin
            WindowString := WindowString + ElapsedTimeTxt + EstimatedTimeLeftTxt + EstimatedEndTimeTxt;
            StartTime := CurrentDateTime;
        end;

        Window.Open(WindowString);
        LastUpdate := CreateDateTime(19000101D, 100000T);
    end;

    internal procedure ReadFlowData(var ResponseJson: JsonToken)
    var
        IsHandled: Boolean;
        JValue: JsonToken;
    begin
        OnBeforeReadFlowData(Rec, ResponseJson, IsHandled);
        if IsHandled then
            exit;

        if ResponseJson.AsObject().Get('hasMoreData', JValue) then
            "Has More Rows" := JValue.AsValue().AsBoolean()
        else
            "Has More Rows" := false;
        if ResponseJson.AsObject().Get('totalResults', JValue) then
            "Row Count" += JValue.AsValue().AsInteger()
        else
            "Row Count" += 1;

        "Page Number" += 1;

        OnAfterReadFlowData(Rec, ResponseJson);
    end;

    internal procedure UpdateWindow(Counter: Integer; NoOfRecords: Integer);
    var
        EndTime: DateTime;
        CurrDuration: Duration;
        EstimatedDuration: Duration;
    begin
        if CurrentDateTime < LastUpdate + 1000 then
            exit;

        if Counter = 0 then
            exit;

        Window.Update(20, ProgressBar(Counter, NoOfRecords));
        LastUpdate := CurrentDateTime;

        if NoOfRecords = 0 then
            exit;

        if StartTime = 0DT then
            exit;

        CurrDuration := CurrentDateTime - StartTime;
        EstimatedDuration := Round((CurrentDateTime - StartTime) * 100 / (Counter / NoOfRecords * 100), 100);
        EndTime := StartTime + EstimatedDuration;
        Window.Update(21, FormatDuration(CurrDuration));

        if CurrDuration <= 2000 then
            exit;

        Window.Update(22, FormatDuration(EstimatedDuration - CurrDuration));
        Window.Update(23, Format(EndTime, 0, '<Hours24>:<Minutes,2>:<Seconds,2>'));
    end;

    internal procedure UpdateWindow(DialogFieldNo: Integer; DialogValue: Text);
    begin
        if not IsGuiAllowed() then
            exit;

        Window.Update(DialogFieldNo, DialogValue);
    end;

    internal procedure UpdateWindow(DialogFieldNo: Integer; DialogValue: Text; Counter: Integer; NoOfRecords: Integer);
    begin
        if not IsGuiAllowed() then
            exit;

        UpdateWindow(DialogFieldNo, DialogValue);
        UpdateWindow(Counter, NoOfRecords);
    end;

    local procedure FormatDuration(NewDuration: Duration): Text;
    var
        Minutes: Integer;
        Seconds: Integer;
        MinuteAndSecondsTxt: Label '%1 Minutes, %2 Seconds', Comment = '%1 = Minutes passed ; %2 = Seconds Passed';
        SecondsTxt: Label '%1 Seconds', Comment = '%1 = Seconds Passed';
    begin
        NewDuration := Round(NewDuration / 1000, 1);
        Minutes := Round(NewDuration / 60, 1, '<');
        Seconds := NewDuration - (Minutes * 60);
        if Minutes > 0 then
            exit(StrSubstNo(MinuteAndSecondsTxt, Minutes, Seconds))
        else
            exit(StrSubstNo(SecondsTxt, Seconds));
    end;

    local procedure IsGuiAllowed() GuiIsAllowed: Boolean
    var
        Handled: Boolean;
    begin
        OnBeforeGuiAllowed(GuiIsAllowed, Handled);
        if Handled then
            exit;
        exit(GuiAllowed());
    end;

    local procedure ProgressBar(Counter: Integer; MaxValue: Integer): Text
    var
        Percentage: Integer;
    begin
        if MaxValue = 0 then
            Percentage := 0
        else
            Percentage := Round(Counter / MaxValue * 100, 1);

        exit(ProgressBar(Percentage));
    end;

    local procedure ProgressBar(Percentage: Decimal) ReturnValue: Text;
    var
        FillCount: Integer;
        ProgressBarTxt: Label '%1 %2%3', Comment = '%1 = First Half of Progress Bar; %2 Percentage Text; %3 Second Half of Progress Bar ';
    begin
        FillCount := Round(Percentage / 2.777777778, 1);
        ReturnValue := PadStr('', FillCount, '█');
        ReturnValue := PadStr(ReturnValue, 36, '▒');
        ReturnValue := StrSubstNo(ProgressBarTxt, CopyStr(ReturnValue, 1, 18), Format(Percentage, 4, '<Integer>') + '% ', CopyStr(ReturnValue, 19, 18));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReadFlowData(var Rec: Record "Tesla API Flow Control"; var ResponseJson: JsonToken)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReadFlowData(var Rec: Record "Tesla API Flow Control"; var ResponseJson: JsonToken; var IsHandled: Boolean)
    begin
    end;
}
