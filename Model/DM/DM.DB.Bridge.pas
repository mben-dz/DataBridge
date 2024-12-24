unit DM.DB.Bridge;

interface

uses
  System.SysUtils, System.Classes,
//
  Data.DB;

type
  TdmBridge = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function GetAdoOleDBConnectionStringDialog(aHandle: THandle): string;

var
  dmBridge: TdmBridge;

implementation
uses
  Data.Win.ADODB,
  Model.DB.Exceptions;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

function GetAdoOleDBConnectionStringDialog(aHandle: THandle): string;
var
  LConnectionString: WideString;
begin
  LConnectionString := PromptDataSource(aHandle, '');

  if LConnectionString = '' then
    raise EInvalidParameterError.Create('No connection string selected.');

  Result := LConnectionString;
end;

end.
