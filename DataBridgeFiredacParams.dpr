program DataBridgeFiredacParams;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main.View in 'Main.View.pas' {MainView},
  Model.DB.Exceptions in 'Model\Bridge\DB-Core\Model.DB.Exceptions.pas',
  Model.FiredacParams.BaseInterface in 'Model\Bridge\DB-Core\Firedac\Model.FiredacParams.BaseInterface.pas',
  Model.Firedac.ParamsTypes in 'Model\Bridge\DB-Core\Firedac\Model.Firedac.ParamsTypes.pas',
  Model.Firedac.ConnectionParams in 'Model\Bridge\DB-Core\Firedac\Model.Firedac.ConnectionParams.pas',
  DM.DB.Bridge in 'Model\DM\DM.DB.Bridge.pas' {dmBridge: TDataModule};

{$R *.res}

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}

  Application.Initialize;
  Application.CreateForm(TMainView, MainView);
  Application.CreateForm(TdmBridge, dmBridge);
  Application.Run;
end.
