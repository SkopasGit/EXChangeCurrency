unit UExchange;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo, UExchangeClasses, System.JSON, System.DateUtils, FMX.Edit,
  FMX.ListBox, FMX.Layouts, Data.Bind.EngExt, FMX.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, FMX.Bind.Editors, Data.Bind.Components,Quick.Logger,
  Quick.Logger.Provider.Files, FMX.Grid.Style, Fmx.Bind.Grid, Data.Bind.Grid,
  Data.Bind.DBScope, FMX.Grid,System.IOUtils;

type
  TMainFormExChange = class(TForm)
    Ok: TButton;
    ComboBoxFromCurenc: TComboBox;
    ComboBoxToCurenc: TComboBox;
    EditAmountFrom: TEdit;
    EditAmountTo: TEdit;
    Grid1: TGrid;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    LabelCurencFrom: TLabel;
    LabelCurencTo: TLabel;
    LabelAmountFrom: TLabel;
    LabelAmountTo: TLabel;
    procedure ButtonGetClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  BaseURL = 'https://openexchangerates.org/api/';
  App_id = 'b1765d19927348c299d71c5067983fce';

var
  MainFormExChange: TMainFormExChange;
  ExcangeCurencies: TExchangeFreePlanClientJSON;

implementation

uses DMExCurenc;

{$R *.fmx}

procedure TMainFormExChange.ButtonGetClick(Sender: TObject);
var
  RequestRec: TOpeararion;
  DateTimeValue: TDateTime;
begin
  with ExcangeCurencies do
  begin
    MoneyFrom := ComboBoxFromCurenc.Items.Names[ComboBoxFromCurenc.ItemIndex];
    MoneyTo := ComboBoxToCurenc.Items.Names[ComboBoxToCurenc.ItemIndex];
   try
    RequestRec := ConvertFromTo(MoneyFrom, MoneyTo,
      StrToFloat(EditAmountFrom.Text));
   except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      Log(E.Message,etWarning);
      exit
    end;

   end;
  end;
  EditAmountTo.Text := FloatToStr(RequestRec.AmountTo);
  with DMExCh do
  begin
    FDTransaction1.StartTransaction;
    try
        FDTransaction1.StartTransaction;
        FDQueryEXCh.Insert;
        FDQueryEXChtimestamp.AsString :=DateTimeToStr(UnixToDateTime(RequestRec.timestamp));
        FDQueryEXChCurrencyFromN.AsString := RequestRec.CurrencyFromName;
        FDQueryEXChCurrencyTo.AsString := RequestRec.CurrencyToName;
        FDQueryEXChCurrencyFromRate.AsFloat := RequestRec.CurrencyFromRate;
        FDQueryEXChCurrencyToRate.AsFloat := RequestRec.CurrencyToRate;
        FDQueryEXChAmountFrom.AsFloat := RequestRec.AmountFrom;
        FDQueryEXChAmountTo.AsFloat := RequestRec.AmountTo;
        FDQueryEXCh.Post;
        FDTransaction1.Commit;
    except
      FDTransaction1.Rollback;
      ShowMessage('Transaction rolled back due to error.');
      Log('Transaction rolled back due to error.',etWarning)
    end;

  end;

end;

procedure TMainFormExChange.FormActivate(Sender: TObject);
begin
  ShowMessage('I am active')
end;

procedure TMainFormExChange.FormCreate(Sender: TObject);
var

  i: Integer;
begin
Logger.Providers.Add(GlobalLogFileProvider);
    with GlobalLogFileProvider do
  begin
    LogLevel := LOG_ALL;
    Enabled := True;
    Logger.Providers.Add(GlobalLogFileProvider);
  end;
  // Creating the Exchange object when the form is created
  Log('Start Programm'+DateToStr(now),etInfo);
  ExcangeCurencies := TExchangeFreePlanClientJSON.Create(BaseURL, App_id);
  try
    // Getting the list of currencies
    if Assigned(ExcangeCurencies) then
    begin
      try
        // Getting the list of currencies
        ComboBoxFromCurenc.Items.Assign(ExcangeCurencies.Currencies);
        ComboBoxToCurenc.Items.Assign(ComboBoxFromCurenc.Items);
      except
        on E: Exception do
          begin
            ShowMessage('Error: ' + E.Message);
            Log(E.Message,etWarning)
          end;
      end;
    end
    else
      begin
        ShowMessage('Error: Unable to create exchange object');
        Log('Error: Unable to create exchange object',etWarning);
      end;
  except

    ExcangeCurencies.Free;
  end;

  ComboBoxFromCurenc.ItemIndex := 0;
  ComboBoxToCurenc.ItemIndex := 0;
  DMExCh.FDExCh.Open;
 DMExCh.FDQueryEXCh.Active := True;

end;

procedure TMainFormExChange.FormDestroy(Sender: TObject);
begin
  DMExCh.FDExCh.Close;
  ExcangeCurencies.Free;
  Log('exit program',etInfo);
end;

end.
