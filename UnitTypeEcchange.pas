unit UnitTypeEcchange;

interface
uses
  System.SysUtils
type
  TOpeararion=record
    timestamp:TTimeStamp;
    MoneyFromName:string;
    MoneyToName:string;
    MoneyFromRate:real;
    MoneyToRate:real;
    Summa:real;
  end;

implementation

end.
