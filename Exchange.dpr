program Exchange;

uses
  System.StartUpCopy,
  FMX.Forms,
  UExchange in 'UExchange.pas' {MainFormExChange},
  UExchangeClasses in 'UExchangeClasses.pas',
  DMExCurenc in 'DMExCurenc.pas' {DMExCh: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TDMExCh, DMExCh);
  Application.CreateForm(TMainFormExChange, MainFormExChange);
  Application.Run;
end.
