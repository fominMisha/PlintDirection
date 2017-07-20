object frmCUInsert: TfrmCUInsert
  Left = 192
  Top = 125
  Width = 299
  Height = 154
  Caption = 'Connection Unit Insert'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblName: TLabel
    Left = 16
    Top = 16
    Width = 108
    Height = 13
    Caption = 'Connection Unt Name:'
  end
  object lblCapacity: TLabel
    Left = 16
    Top = 44
    Width = 42
    Height = 13
    Caption = 'Capacity'
  end
  object edName: TEdit
    Left = 144
    Top = 12
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object seCapacity: TSpinEdit
    Left = 144
    Top = 40
    Width = 121
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 0
  end
  object btnSave: TButton
    Left = 32
    Top = 80
    Width = 75
    Height = 25
    Caption = 'btnSave'
    ModalResult = 1
    TabOrder = 2
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 168
    Top = 80
    Width = 75
    Height = 25
    Caption = 'btnCancel'
    ModalResult = 2
    TabOrder = 3
  end
end
