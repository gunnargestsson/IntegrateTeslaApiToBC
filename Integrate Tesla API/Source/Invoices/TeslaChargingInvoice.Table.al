table 60208 "Tesla Charging Invoice"
{
    Caption = 'Tesla Charging Invoice';
    DataClassification = SystemMetadata;
    Access = Internal;

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
        field(4; "Handled SystemMetadatam ID"; Guid)
        {
            Caption = 'Handled SystemMetadatam ID';
            DataClassification = SystemMetadata;
        }
        field(5; "Handled Table Id"; Integer)
        {
            Caption = 'Handled Table Id';
            DataClassification = SystemMetadata;
        }
        field(6; "Vehicle VIN"; Code[20])
        {
            Caption = 'Vehicle VIN';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; contentId)
        {
            Clustered = true;
        }
        key(HandledKey; "Handled Table Id", "Handled SystemMetadatam ID")
        {

        }
        key(VehicleKey; "Vehicle VIN")
        {

        }
    }


    local procedure GetChargingHistoryV2Url(vin: Text) Url: Text
    var
        IsHandled: Boolean;
        UrlTok: Label 'https://akamai-apigateway-charging-ownership.tesla.com/graphql?deviceLanguage=en&deviceCountry=US&ttpLocale=en_US&vin=%1&operationName=getChargingHistoryV2 ', Locked = true;
    begin
        exit(StrSubStNo(UrlTok, vin));
    end;

    local procedure GetChargingHistoryV2Request(PageNumber: Integer) Request: JsonObject
    var
        JObject: JsonObject;
    begin
        Request.Add('query', 'query getChargingHistoryV2($pageNumber: Int!, $sortBy: String, $sortOrder: SortByEnum) {  me {    charging {      historyV2(pageNumber: $pageNumber, sortBy: $sortBy, sortOrder: $sortOrder) {        data {          ...SparkHistoryItemFragment        }        totalResults        hasMoreData        pageNumber      }    }  }}        fragment SparkHistoryItemFragment on SparkHistoryItem {  countryCode  programType  billingType  vin  credit {    distance    distanceUnit  }  chargingPackage {    distance    distanceUnit    energyApplied  }  invoices {    fileName    contentId    invoiceType  }  chargeSessionId  siteLocationName  chargeStartDateTime  chargeStopDateTime  unlatchDateTime  fees {    ...SparkHistoryFeeFragment  }  vehicleMakeType  sessionId  surveyCompleted  surveyType  postId  cabinetId  din}        fragment SparkHistoryFeeFragment on SparkHistoryFee {  sessionFeeId  feeType  payorUid  amountDue  currencyCode  pricingType  usageBase  usageTier1  usageTier2  usageTier3  usageTier4  rateBase  rateTier1  rateTier2  rateTier3  rateTier4  totalTier1  totalTier2  totalTier3  totalTier4  uom  isPaid  uid  totalBase  totalDue  netDue  status}    ');
        JObject.Add('sortBy', 'start_datetime');
        JObject.Add('sortOrder', 'DESC');
        JObject.Add('pageNumber', PageNumber);
        Request.Add('variables', JObject);
        Request.Add('operationName', 'getChargingHistoryV2');
    end;

    internal procedure GetNewInvoices(Vehicle: Record "Tesla Vehicle")
    var
        Setup: Record "Tesla API Setup";
        FlowControl: Record "Tesla API Flow Control";
        ApiHelper: Codeunit "Tesla API Request Helper";
        ImportInvoicesTok: Label 'Importing Invoices #1#####';
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        ResponseJson, DataJson : JsonToken;
    begin
        Setup.Get();
        FlowControl.Init();
        FlowControl.OpenWindow(ImportInvoicesTok, false);
        while FlowControl."Has More Rows" do begin
            ApiHelper.SetRequest(GetChargingHistoryV2Url(Vehicle.vin), 'Post', Setup.GetAuthorization(), Request);
            ApiHelper.SetRequestContent(Request, 'application/json', GetChargingHistoryV2Request(FlowControl."Page Number").AsToken());
            ApiHelper.SendRequest(Request, Response, 30000);
            ResponseJson :=
                ApiHelper.GetChildJsonToken(
                    ApiHelper.GetChildJsonToken(
                        ApiHelper.GetChildJsonToken(
                            ApiHelper.GetChildJsonToken(
                                ApiHelper.ReadAsJson(Response), 'data'), 'me'), 'charging'), 'historyV2');
            ResponseJson.AsObject().Get('data', DataJson);
            if ReadInvoiceData(Vehicle, DataJson.AsArray()) then exit;
            FlowControl.ReadFlowData(ResponseJson);
            FlowControl.UpdateWindow(1, Format(FlowControl."Row Count"));
        end;
    end;

    local procedure ReadInvoiceData(Vehicle: Record "Tesla Vehicle"; Data: JsonArray) HasInvoicedStored: Boolean;
    var
        TempInvoice: Record "Tesla Charging Invoice" temporary;
        ApiHelper: Codeunit "Tesla API Request Helper";
        InvoiceArray, InvoiceJson, DataJson : JsonToken;
    begin
        foreach DataJson in Data do
            ApiHelper.ReadJsonArray(DataJson, 'invoices', TempInvoice);
        if TempInvoice.FindSet() then
            repeat
                HasInvoicedStored := not InsertInvoiceData(Vehicle, TempInvoice);
                if HasInvoicedStored then exit;
            until TempInvoice.Next() = 0;
    end;

    local procedure InsertInvoiceData(Vehicle: Record "Tesla Vehicle"; var TempInvoice: Record "Tesla Charging Invoice"): Boolean
    begin
        if Get(TempInvoice.contentId) then exit(false);
        Init();
        TransferFields(TempInvoice);
        "Vehicle VIN" := Vehicle.vin;
        exit(Insert(true));
    end;

}
