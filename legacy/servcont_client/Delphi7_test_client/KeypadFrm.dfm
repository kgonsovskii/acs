object frmKeypad: TfrmKeypad
  Left = 344
  Top = 309
  BorderStyle = bsDialog
  Caption = 'Keypad'
  ClientHeight = 234
  ClientWidth = 214
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Grid: TStringGrid
    Left = 4
    Top = 4
    Width = 205
    Height = 189
    ColCount = 3
    DefaultRowHeight = 19
    RowCount = 9
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goThumbTracking]
    TabOrder = 0
  end
  object Button1: TButton
    Left = 29
    Top = 200
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 109
    Top = 200
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
