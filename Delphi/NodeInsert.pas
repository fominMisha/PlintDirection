unit NodeInsert;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB;

type
  TfrmNodeInsert = class(TForm)
    lbl: TLabel;
    edName: TEdit;
    btnSave: TButton;
    btnCancel: TButton;
    spNodeInsert: TADOStoredProc;
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNodeInsert: TfrmNodeInsert;

implementation

{$R *.dfm}

uses DataModule;

{  TfrmNodeInsert.btnSaveClick(Sender: TObject)
  Обработчик события клика по кнопке Save  }
procedure TfrmNodeInsert.btnSaveClick(Sender: TObject);
begin
  if (edName.Text <> '') then
  begin
    spNodeInsert.Close;
    spNodeInsert.Parameters.ParamByName('@Name').Value := edName.Text;
    spNodeInsert.ExecProc;
  end
  else
  begin
    ShowMessage('Не заполнено имя узла');
  end;
end;

{  TfrmNodeInsert.FormCreate(Sender: TObject)
  Обработчик создания формы  }
procedure TfrmNodeInsert.FormCreate(Sender: TObject);
begin
  spNodeInsert.Close;
  spNodeInsert.Connection := DM.Connection;
  spNodeInsert.ProcedureName := 'dbo.p_Node_Add';
  spNodeInsert.Parameters.Clear;
  spNodeInsert.Parameters.Refresh;
end;

end.
