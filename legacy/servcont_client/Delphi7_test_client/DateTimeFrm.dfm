object frmDateTime: TfrmDateTime
  Left = 192
  Top = 175
  BorderStyle = bsDialog
  Caption = 'frmDateTime'
  ClientHeight = 73
  ClientWidth = 168
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object DateTimePicker: TDateTimePicker
    Left = 8
    Top = 8
    Width = 153
    Height = 21
    Date = 39491.776157662040000000
    Time = 39491.776157662040000000
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 40
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 88
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
