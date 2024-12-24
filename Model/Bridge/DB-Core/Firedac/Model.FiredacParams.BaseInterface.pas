unit Model.FiredacParams.BaseInterface;

interface
uses
  Model.Firedac.ParamsTypes;

type
  iDynamicInterface<T: TBaseFiredacDriver; D> = interface ['{95F3CC6F-EB53-46E0-B9E7-CF78A32FF809}'] // <BaseInterface, DerivedInterface>
    function SubParams: D;
  end;

  iBaseFiredacParams<T: TBaseFiredacDriver; D> = interface(iDynamicInterface<T, D>) ['{B5A4A031-EFA0-4424-902D-2529FC4F1B48}']
    function Pooled(aValue: Boolean): iBaseFiredacParams<T, D>; overload;
    function Database(aValue: string): iBaseFiredacParams<T, D>; overload;
    function Username(aValue: string): iBaseFiredacParams<T, D>; overload;
    function Password(aValue: string): iBaseFiredacParams<T, D>; overload;

    function Pooled: Boolean; overload;
    function Database: string; overload;
    function UserName: string; overload;
    function Password: string; overload;
  end;

implementation

end.
