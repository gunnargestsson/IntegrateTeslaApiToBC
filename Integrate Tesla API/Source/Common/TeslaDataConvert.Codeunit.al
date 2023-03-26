codeunit 60206 "Tesla Data Convert"
{
    Access = Internal;

    internal procedure KmToMiles(Km: Decimal): Decimal
    begin
        exit(Km / 1.609344);
    end;

    internal procedure MilesToKm(Miles: Decimal): Decimal
    begin
        exit(Miles * 1.609344);
    end;
}
