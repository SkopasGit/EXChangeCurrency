unit UExchangeClasses;

interface

uses
  System.SysUtils, System.Classes, System.Net.HttpClientComponent,
  System.Net.HttpClient, System.JSON,Quick.Logger,
  Quick.Logger.Provider.Files;
type  // record for operation
  TOpeararion=record
    timestamp:int64;
    CurrencyFromName:string;
    CurrencyToName:string;
    CurrencyFromRate:Real;
    CurrencyToRate:Real;
    AmountFrom:Real;
    AmountTo:Real;
  end;
type
  TExchangeFreePlanClient = class(TNetHTTPClient)
  private
    FURL: string;
    // base url openexchangerates "https://openexchangerates.org/api"
    FApp_id: string; // id openexchangerates
    FPrettyprint: Boolean; // human-readable on 1; off 2
    FShow_alternative: Boolean;
    // Extend returned values with alternative, black market and digital currency rates
    FResult: string;
    FMoneyFrom: string; // fielf for ExChange From
    FMoneyTo: string; // to
    function RequestEx(URL: string; out Answer: string): Boolean;
    procedure SetDefault;
  public
    property AURL: string read FURL write FURL;
    property Prettyprint: Boolean read FPrettyprint write FPrettyprint;
    property Show_alternative: Boolean read FShow_alternative
      write FShow_alternative;
    property MoneyFrom: string read FMoneyFrom write FMoneyFrom;
    property MoneyTo: string read FMoneyTo write FMoneyTo;
    constructor Create(App_id: string); reintroduce; overload;
    constructor Create(BaseURL, App_id: string); reintroduce; overload;
    function ExLatest: string; virtual;
    function ExHistorical(Date: TDate): string; virtual; abstract;
    function Excurrencies: string; virtual;
    function ExTimeSeries(DateFrom, DateTo: TDate): string; virtual; abstract;
    function ExConvert(From, Exto: string; value: string): string;
      virtual; abstract;
    function Exohlc: string; virtual; abstract;
    function ExUsage: string; virtual; abstract;
  end;

type
  TExchangeFreePlanClientJSON = class(TExchangeFreePlanClient)
  private
   FCurrencies:TStringList;
   FOeratopn:TOpeararion;
   function GetCurrencies: TStringList;
   function  GetCovertAmount:real;
  public
    property
      Currencies:TStringList read GetCurrencies;
     function ConvertFromTo(CurrencyFrom,CurrencyTo:string;Curramount:Real):TOpeararion;virtual;
   destructor Destroy overload;
  end;

implementation

{ TExchangeFreePlanClient }

constructor TExchangeFreePlanClient.Create(App_id: string);
begin
  inherited Create(nil);
  FApp_id := App_id;
  SetDefault;
end;

constructor TExchangeFreePlanClient.Create(BaseURL, App_id: string);
begin
  inherited Create(nil);
  FURL := BaseURL;
  FApp_id := App_id;
  SetDefault;
end;

function TExchangeFreePlanClient.Excurrencies: string;
begin
  if RequestEx(FURL + 'currencies.json?prettyprint=' + BoolToStr(Prettyprint,
    true) + '&' + 'show_inactive=' + BoolToStr(FShow_alternative, true), FResult)
  then
    Result := FResult
  else
    Result := '';
end;

function TExchangeFreePlanClient.ExLatest: string;
begin

  if (FMoneyFrom = '') or (FMoneyTo = '') then
    if RequestEx(FURL + 'latest.json?app_id=' + FApp_id + '&prettyprint=' +
      BoolToStr(Prettyprint, true) + '&' + 'show_inactive=' +
      BoolToStr(FShow_alternative, true), FResult) then
      Result := FResult
    else
      Result := ''
  else if RequestEx(FURL + 'latest.json?app_id=' + FApp_id + '&symbols=' +
    FMoneyFrom + ',' + FMoneyTo + '&prettyprint=' + BoolToStr(Prettyprint, true)
    + '&' + 'show_inactive=' + BoolToStr(FShow_alternative, true), FResult) then
    Result := FResult
  else
    Result := '';

end;

function TExchangeFreePlanClient.RequestEx(URL: string;
  out Answer: string): Boolean;
begin
  try
    Answer := Get(URL).ContentAsString(nil);
    Result := true;
    // raise Exception.Create('Error');
  Except
    on E: Exception do
    begin
      ShowException(E, ExceptAddr);
      Result := false;
      Answer := '';
      Log(E.Message,etWarning)
    end;

  end;
end;

procedure TExchangeFreePlanClient.SetDefault;
begin
  FPrettyprint := false;
  FShow_alternative := false;
  Accept := 'application/json';
  FMoneyFrom := '';
  FMoneyTo := '';
end;

{ TExchangeFreePlanClientJSON }




function TExchangeFreePlanClientJSON.ConvertFromTo(CurrencyFrom,
  CurrencyTo: string; CurrAmount: Real): TOpeararion;
var
JSONOBject, RatesObject: TJSONObject;
 JSONPair,RatesPair:TJSONPair;
begin
 self.ExLatest;
 JSONOBject := TJSONObject.ParseJSONValue(FResult) as TJSONObject;
 with FOeratopn do
 begin
   timestamp:=(JSONOBject.GetValue<int64>('timestamp'));
   RatesPair := JSONObject.Get('rates');
   RatesObject := RatesPair.JsonValue as TJSONObject;
   CurrencyFromName:=FMoneyFrom;
   CurrencyToName:=FMoneyTo;
   CurrencyFromRate:=RatesObject.GetValue<real>(FMoneyFrom);
   CurrencyToRate:=RatesObject.GetValue<real>(FMoneyTo);
   AmountFrom:=Curramount;
   AmountTo:=GetCovertAmount;
 end;
  Result:=FOeratopn;
 end;

destructor TExchangeFreePlanClientJSON.Destroy;
begin
inherited Destroy;
  FreeAndNil(FCurrencies);
end;

function TExchangeFreePlanClientJSON.GetCovertAmount: real;
begin
 with FOeratopn do
 Result:=(CurrencyToRate/CurrencyFromRate)*AmountFrom;
end;

function TExchangeFreePlanClientJSON.GetCurrencies: TStringList;
var
  JSONObject: TJSONObject;
  JSONPair: TJSONPair;
   i:Integer;
begin

  if FCurrencies=nil then
  FCurrencies:=TStringList.Create;
  FCurrencies.Clear;
  inherited Excurrencies;
  JSONObject:=TJSONObject.ParseJSONValue(FResult) as TJSONObject;
    for I := 0 to pred(JSONObject.Count) do
      begin
        JSONPair:=JSONObject.Get(i);
        if Assigned(JSONPair) then
          JSONPair.Value;
          FCurrencies.AddPair(JSONPair.JsonString.Value,JSONPair.JsonValue.Value)
      end;
    Result:=FCurrencies;
  end;

end.
