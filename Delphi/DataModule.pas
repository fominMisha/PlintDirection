unit DataModule;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  TDM = class(TDataModule)
    Connection: TADOConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;



implementation

{$R *.dfm}

end.
