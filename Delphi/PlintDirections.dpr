program PlintDirections;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  DataModule in 'DataModule.pas' {DM: TDataModule},
  Directions in 'Directions.pas' {frmDirections},
  NodeInsert in 'NodeInsert.pas' {frmNodeInsert},
  CUInsert in 'CUInsert.pas' {frmCUInsert};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmDirections, frmDirections);
  Application.CreateForm(TfrmNodeInsert, frmNodeInsert);
  Application.CreateForm(TfrmCUInsert, frmCUInsert);
  Application.Run;
end.
