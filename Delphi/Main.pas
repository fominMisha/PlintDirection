unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, Grids, DBGrids, DB, ADODB, StdCtrls, ExtCtrls, Menus;

type
  TfrmMain = class(TForm)
    qNodes: TADOQuery;
    dsNodes: TDataSource;
    qCU: TADOQuery;
    dsCU: TDataSource;
    qPlintDirections: TADOQuery;
    dsPlintDirections: TDataSource;
    pmNodes: TPopupMenu;
    pmCU: TPopupMenu;
    nInsertNode: TMenuItem;
    nDeleteNode: TMenuItem;
    nInsertCU: TMenuItem;
    nDeleteCU: TMenuItem;
    Panel1: TPanel;
    gb_Nodes: TGroupBox;
    lcbNodes: TDBLookupListBox;
    Panel2: TPanel;
    Panel3: TPanel;
    gb_PlintDirection: TGroupBox;
    DBGrid3: TDBGrid;
    DBNavigator1: TDBNavigator;
    gb_CU: TGroupBox;
    DBGrid1: TDBGrid;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    MainMenu1: TMainMenu;
    Pack1: TMenuItem;
    ViewDirection1: TMenuItem;
    Settings1: TMenuItem;
    Connection1: TMenuItem;
    procedure lcbNodesClick(Sender: TObject);
    procedure Pack1Click(Sender: TObject);
    procedure ViewDirection1Click(Sender: TObject);
    procedure nInsertNodeClick(Sender: TObject);
    procedure nDeleteCUClick(Sender: TObject);
    procedure nDeleteNodeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Connection1Click(Sender: TObject);
    procedure nInsertCUClick(Sender: TObject);
  private
    procedure Refresh;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses DataModule, Directions, NodeInsert, CUInsert;

{  TfrmMain.lcbNodesClick
  Обработчик клика выбранный узел }
procedure TfrmMain.lcbNodesClick(Sender: TObject);
begin
  qCU.Close;
  qCU.SQL.Text := 'select cu.ID_CU, cu.Name, cu.Capacity from dbo.t_Connection_Unit as cu where cu.ID_Node = :ID_Node';
  qCU.Parameters.ParamByName('ID_Node').Value := lcbNodes.KeyValue;
  qCU.Open;

  qPlintDirections.Close;
  qPlintDirections.SQL.Text :=
      ' select pd.ID_CU_1, pd.PlintNumber_1, pd.ID_CU_2, pd.PlintNumber_2'
    + ' from dbo.t_Node as n'
    + '   left join dbo.t_Connection_Unit as cu1 on cu1.ID_Node = n.ID_Node'
    + '   left join dbo.t_Connection_Unit as cu2 on cu1.ID_Node = n.ID_Node'
    + '   join dbo.t_PlintDirection as pd on pd.ID_CU_1 = cu1.ID_CU and pd.ID_CU_2 = cu2.ID_CU'
    + ' where n.ID_Node = :ID_Node';
  qPlintDirections.Parameters.ParamByName('ID_Node').Value := lcbNodes.KeyValue;
  qPlintDirections.Open;
end;

{  TfrmMain.Pack1Click(Sender: TObject)
  Обработчик клика по кнопке упаковки плинтонаправлений  }
procedure TfrmMain.Pack1Click(Sender: TObject);
begin
  if (frmDirections = nil) then Application.CreateForm(TfrmDirections, frmDirections);
  frmDirections.spPlintDirectionsPack.Close;
  frmDirections.spPlintDirectionsPack.Parameters.Clear;
  frmDirections.spPlintDirectionsPack.Parameters.Refresh;
  frmDirections.spPlintDirectionsPack.Parameters.ParamByName('@ID_Node').Value := lcbNodes.KeyValue;
  frmDirections.spPlintDirectionsPack.Parameters.ParamByName('@Action').Value := 1;
  frmDirections.spPlintDirectionsPack.Open;

  frmDirections.spDirections.Close;
  frmDirections.spDirections.Parameters.Clear;
  frmDirections.spDirections.Parameters.Refresh;
  frmDirections.spDirections.Parameters.ParamByName('@ID_Node').Value := lcbNodes.KeyValue;
  frmDirections.spDirections.Open;

  frmDirections.ShowModal;
end;

{  TfrmMain.ViewDirection1Click(Sender: TObject);
  Обработчик клика по кнопке просмотра направлений}
procedure TfrmMain.ViewDirection1Click(Sender: TObject);
begin
  if (frmDirections = nil) then Application.CreateForm(TfrmDirections, frmDirections);
  frmDirections.spPlintDirectionsPack.Close;
  frmDirections.spPlintDirectionsPack.Parameters.Clear;
  frmDirections.spPlintDirectionsPack.Parameters.Refresh;
  frmDirections.spPlintDirectionsPack.Parameters.ParamByName('@ID_Node').Value := lcbNodes.KeyValue;
  frmDirections.spPlintDirectionsPack.Open;

  frmDirections.spDirections.Close;
  frmDirections.spDirections.Parameters.Clear;
  frmDirections.spDirections.Parameters.Refresh;
  frmDirections.spDirections.Parameters.ParamByName('@ID_Node').Value := lcbNodes.KeyValue;
  frmDirections.spDirections.Open;

  frmDirections.Caption := lcbNodes.ListSource.DataSet.FieldByName('Name').AsString + ': ' + 'Directions';
  frmDirections.ShowModal;
end;

{  TfrmMain.nInsertNodeClick(Sender: TObject);
  Обработчик клика по кнопке добавления нового узла}
procedure TfrmMain.nInsertNodeClick(Sender: TObject);
begin
  if (frmNodeInsert = nil) then
    Application.CreateForm(TfrmNodeInsert, frmNodeInsert);
  frmNodeInsert.ShowModal;
  if (frmNodeInsert.ModalResult = mrOk) then
  begin
    Refresh;
  end;
  FreeAndNil(frmNodeInsert);
end;

{  TfrmMain.nDeleteCUClick(Sender: TObject);
  Обработик клика по кнопке удаления коннектора  }
procedure TfrmMain.nDeleteCUClick(Sender: TObject);
var
  spDelCU: TADOStoredProc;
begin
  if (MessageDlg('Вы действительно хотите удалить запись?', mtConfirmation, [mbYes, mbNo], 1) = mrYes) then
  begin
    spDelCU := TADOStoredProc.Create(frmMain);
    spDelCU.Close;
    spDelCU.Connection := DM.Connection;
    spDelCU.Parameters.Clear;
    spDelCU.ProcedureName := 'dbo.p_Connection_Unit_Delete';
    spDelCU.Parameters.Refresh;
    spDelCU.Parameters.ParamByName('@ID_CU').Value := qCU.FieldByName('ID_CU').AsInteger;
    spDelCU.ExecProc;
    Refresh;
    FreeAndNil(spDelCU);
  end;
end;

{  TfrmMain.nDeleteNodeClick(Sender: TObject);
  Обработчик клика по кнопке удаления узла  }
procedure TfrmMain.nDeleteNodeClick(Sender: TObject);
var
  spDelNode: TADOStoredProc;
  BtnSelected: Integer;
begin
  if (MessageDlg('Вы действительно хотите удалить запись?', mtConfirmation, [mbYes, mbNo], 1) = mrYes) then
  begin
    spDelNode := TADOStoredProc.Create(frmMain);
    spDelNode.Connection := DM.Connection;
    spDelNode.Close;
    spDelNode.Parameters.Clear;
    spDelNode.ProcedureName := 'dbo.p_Node_Delete';
    spDelNode.Parameters.Refresh;
    spDelNode.Parameters.ParamByName('@ID_Node').Value := lcbNodes.KeyValue;
    spDelNode.ExecProc;
    Refresh;
    FreeAndNil(spDelNode);
  end;
end;

{  TfrmMain.FormCreate(Sender: TObject);
  Обработчик создания формы}
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  try
    DM.Connection.Connected := True;
    Refresh;
  except
    ShowMessage('Ошибка подключения к БД');
  end;
end;

{  TfrmMain.Connection1Click(Sender: TObject)
  Обработчик клика по кнопке открытия настроек подключения  }
procedure TfrmMain.Connection1Click(Sender: TObject);
var
  ConnectionString: String;
begin
  ConnectionString := PromptDataSource(Application.Handle, ConnectionString);
  if (Length(ConnectionString) > 0) then
  begin
    DM.Connection.Connected := False;
    DM.Connection.ConnectionString := ConnectionString;
    DM.Connection.Connected := True;
    Refresh;
  end;
end;

{  TfrmMain.Refresh
  Процедура обновления}
procedure TfrmMain.Refresh;
begin
   qNodes.Close;
   qNodes.Open;
   qCU.Close;
   qPlintDirections.Close;
end;

{  TfrmMain.nInsertCUClick(Sender: TObject)
  Обработчик клика по кнопке добавления коннектора}
procedure TfrmMain.nInsertCUClick(Sender: TObject);
begin
  if (frmCUInsert = nil) then
    Application.CreateForm(TfrmCUInsert, frmCUInsert);
  frmCUInsert.ShowModal;
  if (frmCUInsert.ModalResult = mrOk) then
  begin
    qCU.Close;
    qCU.Open;
  end;
  FreeAndNil(frmCUInsert);
end;

end.
