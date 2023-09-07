table 60209 "Tesla Charging Session"
{
    Access = Internal;
    Caption = 'Tesla Charging Session';
    DataCaptionFields = siteLocationName, chargeStartDateTime, vin;
    DataClassification = SystemMetadata;

    fields
    {
        field(1; countryCode; Code[10])
        {
            Caption = 'Country Code';
            DataClassification = SystemMetadata;
        }
        field(2; programType; Code[10])
        {
            Caption = 'Program Type';
            DataClassification = SystemMetadata;
        }
        field(3; billingType; Code[20])
        {
            Caption = 'Billing Type';
            DataClassification = SystemMetadata;
        }
        field(4; vin; Code[20])
        {
            Caption = 'VIN';
            DataClassification = SystemMetadata;
        }
        field(5; credit; Code[20])
        {
            Caption = 'Credit';
            DataClassification = SystemMetadata;
        }
        field(6; chargingPackage; Code[20])
        {
            Caption = 'Charging Package';
            DataClassification = SystemMetadata;
        }
        field(7; invoices; Blob)
        {
            Caption = 'Invoices';
            DataClassification = SystemMetadata;
        }
        field(8; chargeSessionId; Code[50])
        {
            Caption = 'Charge Session Id';
            DataClassification = SystemMetadata;
        }
        field(9; siteLocationName; Text[100])
        {
            Caption = 'Site Location Name';
            DataClassification = SystemMetadata;
        }
        field(10; chargeStartDateTime; DateTime)
        {
            Caption = 'Charge Start Date Time';
            DataClassification = SystemMetadata;
        }
        field(11; chargeStopDateTime; DateTime)
        {
            Caption = 'Charge Stop Date Time';
            DataClassification = SystemMetadata;
        }
        field(12; unlatchDateTime; DateTime)
        {
            Caption = 'Unlatch Date Time';
            DataClassification = SystemMetadata;
        }
        field(13; fees; Blob)
        {
            Caption = 'Fees';
            DataClassification = SystemMetadata;
        }
        field(14; vehicleMakeType; Text[50])
        {
            Caption = 'Vehicle Make Type';
            DataClassification = SystemMetadata;
        }
        field(15; sessionId; Code[20])
        {
            Caption = 'Session Id';
            DataClassification = SystemMetadata;
        }
        field(16; surveyCompleted; Boolean)
        {
            Caption = 'Survey Completed';
            DataClassification = SystemMetadata;
        }
        field(17; surveyType; Code[10])
        {
            Caption = 'Survey Type';
            DataClassification = SystemMetadata;
        }
        field(18; postId; Code[10])
        {
            Caption = 'Post Id';
            DataClassification = SystemMetadata;
        }
        field(19; cabinetId; Code[20])
        {
            Caption = 'Cabinet Id';
            DataClassification = SystemMetadata;
        }
        field(20; din; Code[10])
        {
            Caption = 'DIN';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; chargeSessionId)
        {
            Clustered = true;
        }
        key(CronologicalKey; chargeStartDateTime, vin)
        {
            Clustered = false;
        }
    }

    internal procedure GetChargingSessions()
    var
        Vehicle: Record "Tesla Vehicle";
        IsHandled: Boolean;
    begin
        OnBeforeGetChargingSessions(Rec, IsHandled);
        if IsHandled then
            exit;

        Vehicle.GetVehicles(false);
        if Vehicle.FindSet() then
            repeat
                GetChargingSessionsForVehicle(Vehicle);
            until Vehicle.Next() = 0;

        OnAfterGetChargingSessions(Rec);
    end;

    internal procedure GetChargingSessionsForVehicle(Vehicle: Record "Tesla Vehicle")
    var
        FlowControl: Record "Tesla API Flow Control";
        Setup: Record "Tesla API Setup";
        ApiHelper: Codeunit "Tesla API Request Helper";
        IsHandled: Boolean;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        ResponseJson: JsonToken;
        ImportInvoicesTok: Label 'Importing charging sessions for %1', Comment = '%1 = Vehicle Name';
    begin
        OnBeforeGetChargingSessionsForVehicle(Rec, Vehicle, IsHandled);
        if IsHandled then
            exit;

        Setup.Get();
        FlowControl.Init();
        FlowControl.OpenWindow(StrSubstNo(ImportInvoicesTok, Vehicle.display_name) + ': #1###', false);
        while FlowControl."Has More Rows" do begin
            ApiHelper.SetRequest(GetChargingHistoryV2Url(Vehicle.vin), 'Post', Setup, Request);
            ApiHelper.SetRequestContent(Request, 'application/json', GetChargingHistoryV2Request(FlowControl."Page Number").AsToken());
            ApiHelper.SendRequest(Request, Response, 30000);
            ResponseJson :=
                ApiHelper.GetChildJsonToken(
                    ApiHelper.GetChildJsonToken(
                        ApiHelper.GetChildJsonToken(
                            ApiHelper.GetChildJsonToken(
                                ApiHelper.ReadAsJson(Response), 'data'), 'me'), 'charging'), 'historyV2');
            ApiHelper.ReadJsonToken(ResponseJson, 'data', Rec);
            FlowControl.ReadFlowData(ResponseJson);
            FlowControl.UpdateWindow(1, Format(FlowControl."Row Count"));
        end;

        OnAfterGetChargingSessionsForVehicle(Rec, Vehicle);
    end;

    internal procedure LoadFees(var Fee: Record "Tesla Charging Fee")
    var
        TempBlob: Codeunit "Temp Blob";
        ApiHelper: Codeunit "Tesla API Request Helper";
        IsHandled: Boolean;
        InStr: InStream;
        FeeArray: JsonToken;
    begin
        OnBeforeLoadFees(Rec, Fee, IsHandled);
        if IsHandled then
            exit;

        Fee.DeleteAll();
        TempBlob.FromRecord(Rec, FieldNo(fees));
        if not TempBlob.HasValue() then
            exit;

        TempBlob.CreateInStream(InStr, TextEncoding::UTF8);
        FeeArray.ReadFrom(InStr);
        ApiHelper.ReadJsonToken(FeeArray, '', Fee);

        OnAfterLoadFees(Rec, Fee);
    end;

    internal procedure LoadInvoices(var Invoice: Record "Tesla Charging Invoice")
    var
        TempBlob: Codeunit "Temp Blob";
        ApiHelper: Codeunit "Tesla API Request Helper";
        IsHandled: Boolean;
        InStr: InStream;
        InvoiceArray: JsonToken;
    begin
        OnBeforeLoadInvoices(Rec, Invoice, IsHandled);
        if IsHandled then
            exit;

        Invoice.DeleteAll();
        TempBlob.FromRecord(Rec, FieldNo(invoices));
        if not TempBlob.HasValue() then
            exit;

        TempBlob.CreateInStream(InStr, TextEncoding::UTF8);
        InvoiceArray.ReadFrom(InStr);
        Invoice.vin := vin;
        ApiHelper.ReadJsonToken(InvoiceArray, '', Invoice);

        OnAfterLoadInvoices(Rec, Invoice);
    end;

    local procedure GetChargingHistoryV2Request(PageNumber: Integer) Request: JsonObject
    var
        IsHandled: Boolean;
        JObject: JsonObject;
    begin
        OnBeforeGetChargingHistoryV2Request(Rec, PageNumber, Request, IsHandled);
        if IsHandled then
            exit;

        Request.Add('query', 'query getChargingHistoryV2($pageNumber: Int!, $sortBy: String, $sortOrder: SortByEnum) {  me {    charging {      historyV2(pageNumber: $pageNumber, sortBy: $sortBy, sortOrder: $sortOrder) {        data {          ...SparkHistoryItemFragment        }        totalResults        hasMoreData        pageNumber      }    }  }}        fragment SparkHistoryItemFragment on SparkHistoryItem {  countryCode  programType  billingType  vin  credit {    distance    distanceUnit  }  chargingPackage {    distance    distanceUnit    energyApplied  }  invoices {    fileName    contentId    invoiceType  }  chargeSessionId  siteLocationName  chargeStartDateTime  chargeStopDateTime  unlatchDateTime  fees {    ...SparkHistoryFeeFragment  }  vehicleMakeType  sessionId  surveyCompleted  surveyType  postId  cabinetId  din}        fragment SparkHistoryFeeFragment on SparkHistoryFee {  sessionFeeId  feeType  payorUid  amountDue  currencyCode  pricingType  usageBase  usageTier1  usageTier2  usageTier3  usageTier4  rateBase  rateTier1  rateTier2  rateTier3  rateTier4  totalTier1  totalTier2  totalTier3  totalTier4  uom  isPaid  uid  totalBase  totalDue  netDue  status}    ');
        JObject.Add('sortBy', 'start_datetime');
        JObject.Add('sortOrder', 'DESC');
        JObject.Add('pageNumber', PageNumber);
        Request.Add('variables', JObject);
        Request.Add('operationName', 'getChargingHistoryV2');

        OnAfterGetChargingHistoryV2Request(Rec, PageNumber, Request);
    end;

    local procedure GetChargingHistoryV2Url(VehicleVIN: Text) Url: Text
    var
        IsHandled: Boolean;
        UrlTok: Label 'https://akamai-apigateway-charging-ownership.tesla.com/graphql?deviceLanguage=en&deviceCountry=US&ttpLocale=en_US&vin=%1&operationName=getChargingHistoryV2 ', Locked = true;
    begin
        OnBeforeGetChargingHistoryV2Url(Rec, VehicleVIN, Url, IsHandled);
        if IsHandled then
            exit;

        exit(StrSubstNo(UrlTok, VehicleVIN));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetChargingHistoryV2Request(var Rec: Record "Tesla Charging Session"; PageNumber: Integer; var Request: JsonObject)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetChargingSessions(var Rec: Record "Tesla Charging Session")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetChargingSessionsForVehicle(var Rec: Record "Tesla Charging Session"; Vehicle: Record "Tesla Vehicle")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterLoadFees(var Rec: Record "Tesla Charging Session"; var Fee: Record "Tesla Charging Fee")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterLoadInvoices(var Rec: Record "Tesla Charging Session"; var Invoice: Record "Tesla Charging Invoice")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetChargingHistoryV2Request(var Rec: Record "Tesla Charging Session"; PageNumber: Integer; var Request: JsonObject; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetChargingHistoryV2Url(var Rec: Record "Tesla Charging Session"; VehicleVIN: Text; var Url: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetChargingSessions(var Rec: Record "Tesla Charging Session"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetChargingSessionsForVehicle(var Rec: Record "Tesla Charging Session"; Vehicle: Record "Tesla Vehicle"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLoadFees(var Rec: Record "Tesla Charging Session"; var Fee: Record "Tesla Charging Fee"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLoadInvoices(var Rec: Record "Tesla Charging Session"; var Invoice: Record "Tesla Charging Invoice"; var IsHandled: Boolean)
    begin
    end;
}
