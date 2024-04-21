unit DMExCurenc;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,System.IOUtils;

type
  TDMExCh = class(TDataModule)
    FDExCh: TFDConnection;
    FDQueryEXCh: TFDQuery;
    FDQueryEXChID: TFDAutoIncField;
    FDQueryEXChtimestamp: TWideMemoField;
    FDQueryEXChCurrencyFromN: TWideMemoField;
    FDQueryEXChCurrencyTo: TWideMemoField;
    FDQueryEXChCurrencyFromRate: TFloatField;
    FDQueryEXChCurrencyToRate: TFloatField;
    FDQueryEXChAmountFrom: TFloatField;
    FDQueryEXChAmountTo: TFloatField;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDTransaction1: TFDTransaction;
    procedure FDExChBeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMExCh: TDMExCh;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDMExCh.FDExChBeforeConnect(Sender: TObject);
begin
 {$IF DEFINED (ANDROID)}
  FDExCh.Params.Values['Database'] := TPath.GetDocumentsPath + PathDelim + 'exchoperation.db';
 {$ELSEIF DEFINED (MSWINDOWS)}
 {$ENDIF}
end;

end.
