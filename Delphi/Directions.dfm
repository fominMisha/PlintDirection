object frmDirections: TfrmDirections
  Left = 281
  Top = 140
  Width = 680
  Height = 444
  Caption = 'Directions'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 435
    Top = 0
    Height = 405
    Align = alRight
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 435
    Height = 405
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 1
      Top = 1
      Width = 433
      Height = 403
      Align = alClient
      Caption = 'Directions'
      TabOrder = 0
      object DBGrid1: TDBGrid
        Left = 2
        Top = 15
        Width = 429
        Height = 386
        Align = alClient
        DataSource = DataSource1
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
    end
  end
  object Panel2: TPanel
    Left = 438
    Top = 0
    Width = 226
    Height = 405
    Align = alRight
    Caption = 'Panel2'
    TabOrder = 1
    object GroupBox2: TGroupBox
      Left = 1
      Top = 1
      Width = 224
      Height = 403
      Align = alClient
      Caption = 'Directions View'
      TabOrder = 0
      object DBLookupListBox1: TDBLookupListBox
        Left = 2
        Top = 15
        Width = 220
        Height = 381
        Align = alClient
        KeyField = 'ID_CU_1'
        ListField = 'Direction'
        ListSource = DataSource2
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object spPlintDirectionsPack: TADOStoredProc
    Connection = DM.Connection
    ProcedureName = 'p_Plint_Direction_Pack;1'
    Parameters = <>
    Left = 17
    Top = 377
  end
  object DataSource1: TDataSource
    DataSet = spPlintDirectionsPack
    Left = 49
    Top = 377
  end
  object DataSource2: TDataSource
    DataSet = spDirections
    Left = 337
    Top = 377
  end
  object spDirections: TADOStoredProc
    Connection = DM.Connection
    ProcedureName = 'p_Direction_List;1'
    Parameters = <>
    Left = 305
    Top = 377
  end
end
