unit CUInsert;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ADODB;

type
  TfrmCUInsert = class(TForm)
    lblName: TLabel;
    edName: TEdit;
    seCapacity: TSpinEdit;
    lblCapacity: TLabel;
    btnSave: TButton;
    btnCancel: TButton;
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCUInsert: TfrmCUInsert;

implementation

{$R *.dfm}

uses DataModule, Main;

{  TfrmCUInsert.btnSaveClick(Sender: TObject)
  Обработчик события клика по кнопке Save  }
procedure TfrmCUInsert.btnSaveClick(Sender: TObject);
var
  spCUInsert: TADOStoredProc;
begin
  if (edName.Text = '') then
    ShowMessage('Не введено наименование коннектора')
  else if (seCapacity.Value <= 0) then
    ShowMessage('Не задана емкость')
  else
  begin
    spCUInsert := TADOStoredProc.Create(frmCUInsert);
    spCUInsert.Close;
    spCUInsert.Connection := DM.Connection;
    spCUInsert.Parameters.Clear;
    spCUInsert.ProcedureName := 'dbo.p_Connection_Unit_Add';
    spCUInsert.Parameters.Refresh;
    spCUInsert.Parameters.ParamByName('@Name').Value := edName.Text;
    spCUInsert.Parameters.ParamByName('@Capacity').Value := seCapacity.Value;
    spCUInsert.Parameters.ParamByName('@ID_Node').Value := frmMain.lcbNodes.KeyValue;
    spCUInsert.ExecProc;
  end;
end;

end.
