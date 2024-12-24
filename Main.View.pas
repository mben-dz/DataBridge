unit Main.View;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo;

type
  TMainView = class(TForm)
    BtnTest: TButton;
    Memo_Log: TMemo;
    BtnGetAdoDialog: TButton;
    procedure BtnTestClick(Sender: TObject);
    procedure BtnGetAdoDialogClick(Sender: TObject);
  strict private

  private
    procedure Log(const aLog: string);
  end;

var
  MainView: TMainView;

implementation

uses
  FMX.Platform.Win, // To get native window handle
//
  Model.Firedac.ParamsTypes,
  Model.FiredacParams.BaseInterface,
  Model.Firedac.ConnectionParams,
//
  DM.DB.Bridge // To get Ado connection string
;

{$R *.fmx}

procedure TMainView.Log(const aLog: string);
begin
  Memo_Log.Lines.Append('-----------------');
    Memo_Log.Lines.Append(aLog);
  Memo_Log.Lines.Append('-----------------');
end;

procedure TMainView.BtnGetAdoDialogClick(Sender: TObject);
var
  LNativeHandle: THandle;
begin
  LNativeHandle := WindowHandleToPlatform(MainView.Handle).Wnd;

  Log(GetAdoOleDBConnectionStringDialog(LNativeHandle));
end;

procedure TMainView.BtnTestClick(Sender: TObject);
begin
  try
    GSQLiteParams
      .Pooled(True)
      .Username('Admin')
      .Password('123')
      .SubParams
        .LockingMode(mLockingNormal)
        .BackToBase
      .UserName('User')
      .SubParams
        .LockingMode(mLockingExclusive)
        .Encrypt(AES128);
//        .BackToBase
//      .Database('');
  finally
    Log('Pooled: ' +BoolToStr(GSQLiteParams.Pooled, True)+ sLineBreak+
        'Database: ' +GSQLiteParams.Database+ sLineBreak+
        'UserName: ' +GSQLiteParams.UserName+ sLineBreak+
        'Password: ' +GSQLiteParams.Password+ sLineBreak+
        'LockingMode: ' +GSQLiteParams
          .SubParams.LockingMode.ToString+ sLineBreak+
        'Encrypt: ' +GSQLiteParams
          .SubParams.Encrypt.ToString);
  end;
end;

end.
