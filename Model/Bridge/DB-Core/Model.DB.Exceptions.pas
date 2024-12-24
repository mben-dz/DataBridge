unit Model.DB.Exceptions;

interface
uses
  System.SysUtils;

type
  EDatabaseError = class(Exception);
  EInvalidParameterError = class(EDatabaseError);
  EConnectionError = class(EDatabaseError);

implementation

end.
