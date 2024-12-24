unit Model.Firedac.ConnectionParams;

interface
uses
  Model.Firedac.ParamsTypes,
  Model.FiredacParams.BaseInterface,
  Model.DB.Exceptions;

type
//  iMSAccesseParams  = iBaseFiredacParams<TMSAccessDriver, TMSAccessDriver>;

  iSQLiteParams = interface
    function LockingMode(aValue: TSQLiteLockingMode): iSQLiteParams; overload;
    function Encrypt(aValue: TSQLiteEncryptMode): iSQLiteParams; overload;

    function LockingMode: TSQLiteLockingMode; overload;
    function Encrypt: TSQLiteEncryptMode; overload;

    function BackToBase: iBaseFiredacParams<TSQLiteDriver, iSQLiteParams>;
  end;

//  iPostgreSqlParams = iBaseFDParams<TPostgreSqlDriver>;
//  iMySQLParams      = iBaseFDParams<TMySQLDriver>;
//  iFirebirdParams   = iBaseFDParams<TFirebirdDriver>;
//  iInterbaseParams  = iBaseFDParams<TInterbaseDriver>;
//  iInterbaseLParams = iBaseFDParams<TInterbaseLiteDriver>;

//  function GetDefault_SqliteParams(
//       const aDatabase: string;
//       const aUsername: string = ''; const aPassword: string = '';
//       const aLockingMode: TSQLiteLockingMode = mLockingExclusive; aEncrypt: TSQLiteEncryptMode = EncryptNone): iBaseFiredacParams<TSQLiteDriver, iSQLiteParams>;

var
  GSQLiteParams: iBaseFiredacParams<TSQLiteDriver, iSQLiteParams>;
implementation
uses
  System.SysUtils,
  System.TypInfo;

type

  TBaseConnectionParams<T: TBaseFiredacDriver; D: IInterface> = class(TInterfacedObject, iBaseFiredacParams<T, D>)
  strict private
    fPooled: Boolean;
    fDatabase,
    fUsername,
    fPassword: string;
//    [Weak]
    fSQLiteParams: iSQLiteParams;
//    fPostgreSqlParams: iPostgreSqlParams;

    procedure ValidateParamsException;

    constructor Create(
       const aDatabase: string;
       const aUsername: string = ''; const aPassword: string = '';
       const aLockingMode: TSQLiteLockingMode = mLockingExclusive; aEncrypt: TSQLiteEncryptMode = EncryptNone); overload;

  private

    function Pooled(aValue: Boolean): iBaseFiredacParams<T, D>; overload;
    function Database(aValue: string): iBaseFiredacParams<T, D>; overload;
    function Username(aValue: string): iBaseFiredacParams<T, D>; overload;
    function Password(aValue: string): iBaseFiredacParams<T, D>; overload;

    function Pooled: Boolean; overload;
    function Database: string; overload;
    function UserName: string; overload;
    function Password: string; overload;

    function SubParams: D;

    class function NewSQLiteParams(
       const aDatabase: string;
       const aUsername: string = ''; const aPassword: string = '';
       const aLockingMode: TSQLiteLockingMode = mLockingExclusive; aEncrypt: TSQLiteEncryptMode = EncryptNone): iBaseFiredacParams<T, D>;

    destructor Destroy; override;
  end;

  TSqliteParams = class(TInterfacedObject, iSQLiteParams)
  strict private
    fLockingMode: TSQLiteLockingMode;
    fEncrypt: TSQLiteEncryptMode;

  private
    constructor Create(
       const aDatabase: string;
       const aUsername: string = ''; const aPassword: string = '';
       const aLockingMode: TSQLiteLockingMode = mLockingExclusive; aEncrypt: TSQLiteEncryptMode = EncryptNone);

    function LockingMode(aValue: TSQLiteLockingMode): iSQLiteParams; overload;
    function Encrypt(aValue: TSQLiteEncryptMode): iSQLiteParams; overload;

    function LockingMode: TSQLiteLockingMode; overload;
    function Encrypt: TSQLiteEncryptMode; overload;

    function BackToBase: iBaseFiredacParams<TSQLiteDriver, iSQLiteParams>;
  end;

function GetDefault_SqliteParams(
       const aDatabase: string;
       const aUsername: string = ''; const aPassword: string = '';
       const aLockingMode: TSQLiteLockingMode = mLockingExclusive; aEncrypt: TSQLiteEncryptMode = EncryptNone): iBaseFiredacParams<TSQLiteDriver, iSQLiteParams>;
begin
  Result := TBaseConnectionParams<TSQLiteDriver, iSQLiteParams>
    .NewSQLiteParams(aDatabase, aUsername,aPassword,aLockingMode, aEncrypt);
end;
{ TBaseConnectionParams }

procedure TBaseConnectionParams<T, D>.ValidateParamsException;
begin
  if fDatabase = '' then
    raise EInvalidParameterError.Create('Database must be specified.');

end;

constructor TBaseConnectionParams<T, D>.Create(
  const aDatabase, aUsername,
  aPassword: string; const aLockingMode: TSQLiteLockingMode;
  aEncrypt: TSQLiteEncryptMode);
begin
//  fPostgreSqlParams := nil;
  fDatabase := aDatabase;
  fUsername := aUsername;
  fPassword := aPassword;

  ValidateParamsException;

  fSQLiteParams := TSqliteParams.Create(aDatabase, aUsername, aPassword, aLockingMode, aEncrypt);
  fSQLiteParams.LockingMode(aLockingMode).Encrypt(aEncrypt);

end;

class function TBaseConnectionParams<T, D>.NewSQLiteParams(
  const aDatabase,
  aUsername, aPassword: string; const aLockingMode: TSQLiteLockingMode;
  aEncrypt: TSQLiteEncryptMode): iBaseFiredacParams<T, D>;
begin
  Result:= Self.Create(aDatabase, aUsername, aPassword, aLockingMode, aEncrypt);
end;

destructor TBaseConnectionParams<T, D>.Destroy;
begin
//  if Assigned(fSQLiteParams) then
//    fSQLiteParams := nil;

  inherited;
end;

{$REGION '  Base Firedac Params .. '}
function TBaseConnectionParams<T, D>.Pooled(aValue: Boolean): iBaseFiredacParams<T, D>;
begin
  Result :=  Self;

  fPooled := aValue;
end;

function TBaseConnectionParams<T, D>.Pooled: Boolean;
begin
  Result := fPooled;
end;

function TBaseConnectionParams<T, D>.Database(aValue: string): iBaseFiredacParams<T, D>;
begin
  Result := Self;

  if aValue = '' then
    raise EInvalidParameterError.Create('Database must be specified.');

  fDatabase := aValue;
end;

function TBaseConnectionParams<T, D>.Database: string;
begin
  Result := fDatabase;
end;

function TBaseConnectionParams<T, D>.Username(aValue: string): iBaseFiredacParams<T, D>;
begin
  Result := Self;

  fUsername := aValue;
end;

function TBaseConnectionParams<T, D>.Username: string;
begin
  Result := fUsername;
end;

function TBaseConnectionParams<T, D>.Password(aValue: string): iBaseFiredacParams<T, D>;
begin
  Result := Self;

  fPassword := aValue;
end;

function TBaseConnectionParams<T, D>.Password: string;
begin
  Result := fPassword;
end;

function TBaseConnectionParams<T, D>.SubParams: D;
begin
  Result := fSQLiteParams;
end;
{$ENDREGION}

{ TSqliteParams }

function TSqliteParams.BackToBase: iBaseFiredacParams<TSQLiteDriver, iSQLiteParams>;
var
  LResult: iBaseFiredacParams<TSQLiteDriver, iSQLiteParams>;
begin
  LResult := nil;

  if Assigned(GSQLiteParams) then
    LResult := GSQLiteParams else
    raise EInvalidParameterError.Create('Base Params Instance is Nul.');



  Result := LResult;
end;

constructor TSqliteParams.Create(const aDatabase, aUsername, aPassword: string;
  const aLockingMode: TSQLiteLockingMode; aEncrypt: TSQLiteEncryptMode);
begin
  inherited Create;

  fLockingMode := aLockingMode;
  fEncrypt     := aEncrypt;
end;

function TSqliteParams.LockingMode(
  aValue: TSQLiteLockingMode): iSQLiteParams;
begin
  Result := Self;

  fLockingMode := aValue;
end;

function TSqliteParams.LockingMode: TSQLiteLockingMode;
begin
  Result := fLockingMode;
end;

function TSqliteParams.
Encrypt(aValue: TSQLiteEncryptMode): iSQLiteParams;
begin
  Result := Self;

  fEncrypt := aValue;
end;

function TSqliteParams.Encrypt: TSQLiteEncryptMode;
begin
  Result := fEncrypt;
end;

initialization
  GSQLiteParams := GetDefault_SqliteParams('DATABASE');

end.
