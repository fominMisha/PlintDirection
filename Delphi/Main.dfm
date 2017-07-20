object frmMain: TfrmMain
  Left = 275
  Top = 115
  Width = 882
  Height = 554
  Caption = 'Plint Direction'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 678
    Top = 0
    Height = 495
    Align = alRight
  end
  object Splitter2: TSplitter
    Left = 193
    Top = 0
    Height = 495
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 193
    Height = 495
    Align = alLeft
    Caption = 'Panel1'
    TabOrder = 0
    object gb_Nodes: TGroupBox
      Left = 1
      Top = 1
      Width = 191
      Height = 493
      Align = alClient
      Caption = 'Nodes'
      TabOrder = 0
      object lcbNodes: TDBLookupListBox
        Left = 2
        Top = 15
        Width = 187
        Height = 472
        Align = alClient
        KeyField = 'ID_Node'
        ListField = 'ID_Node;Name'
        ListSource = dsNodes
        PopupMenu = pmNodes
        TabOrder = 0
        OnClick = lcbNodesClick
      end
    end
  end
  object Panel2: TPanel
    Left = 196
    Top = 0
    Width = 482
    Height = 495
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    object gb_CU: TGroupBox
      Left = 1
      Top = 1
      Width = 480
      Height = 493
      Align = alClient
      Caption = 'Connection Units'
      TabOrder = 0
      object DBGrid1: TDBGrid
        Left = 2
        Top = 15
        Width = 476
        Height = 476
        Align = alClient
        DataSource = dsCU
        PopupMenu = pmCU
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
    end
  end
  object Panel3: TPanel
    Left = 681
    Top = 0
    Width = 185
    Height = 495
    Align = alRight
    Caption = 'Panel3'
    TabOrder = 2
    object gb_PlintDirection: TGroupBox
      Left = 1
      Top = 1
      Width = 183
      Height = 493
      Align = alClient
      Caption = 'PlintDirection'
      TabOrder = 0
      object DBGrid3: TDBGrid
        Left = 2
        Top = 15
        Width = 179
        Height = 451
        Align = alClient
        DataSource = dsPlintDirections
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
      object DBNavigator1: TDBNavigator
        Left = 2
        Top = 466
        Width = 179
        Height = 25
        DataSource = dsPlintDirections
        VisibleButtons = [nbInsert, nbDelete, nbPost, nbCancel, nbRefresh]
        Align = alBottom
        TabOrder = 1
      end
    end
  end
  object qNodes: TADOQuery
    Connection = DM.Connection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from dbo.t_Node')
    Left = 16
    Top = 464
  end
  object dsNodes: TDataSource
    DataSet = qNodes
    Left = 48
    Top = 464
  end
  object qCU: TADOQuery
    Connection = DM.Connection
    CursorType = ctStatic
    Parameters = <>
    Left = 208
    Top = 464
  end
  object dsCU: TDataSource
    DataSet = qCU
    Left = 240
    Top = 464
  end
  object qPlintDirections: TADOQuery
    Connection = DM.Connection
    CursorType = ctStatic
    Parameters = <>
    Left = 696
    Top = 440
  end
  object dsPlintDirections: TDataSource
    DataSet = qPlintDirections
    Left = 728
    Top = 440
  end
  object pmNodes: TPopupMenu
    Left = 80
    Top = 464
    object nInsertNode: TMenuItem
      Caption = 'Insert Node'
      OnClick = nInsertNodeClick
    end
    object nDeleteNode: TMenuItem
      Caption = 'Delete Node'
      OnClick = nDeleteNodeClick
    end
  end
  object pmCU: TPopupMenu
    Left = 272
    Top = 464
    object nInsertCU: TMenuItem
      Caption = 'Insert'
      OnClick = nInsertCUClick
    end
    object nDeleteCU: TMenuItem
      Caption = 'Delete'
      OnClick = nDeleteCUClick
    end
  end
  object MainMenu1: TMainMenu
    Left = 9
    Top = 25
    object Pack1: TMenuItem
      Caption = 'Pack'
      OnClick = Pack1Click
    end
    object ViewDirection1: TMenuItem
      Caption = 'View Direction'
      OnClick = ViewDirection1Click
    end
    object Settings1: TMenuItem
      Caption = 'Settings'
      object Connection1: TMenuItem
        Caption = 'Connection'
        OnClick = Connection1Click
      end
    end
  end
end
