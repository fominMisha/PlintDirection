object frmNodeInsert: TfrmNodeInsert
  Left = 192
  Top = 125
  BorderStyle = bsDialog
  Caption = 'Insert Node'
  ClientHeight = 89
  ClientWidth = 252
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbl: TLabel
    Left = 8
    Top = 10
    Width = 103
    Height = 13
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1091#1079#1083#1072':'
  end
  object edName: TEdit
    Left = 120
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'edName'
  end
  object btnSave: TButton
    Left = 32
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Save'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 144
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object spNodeInsert: TADOStoredProc
    Parameters = <>
    Left = 24
    Top = 32
  end
end
