object frmKeys: TfrmKeys
  Left = 337
  Top = 202
  Width = 622
  Height = 422
  BorderIcons = [biSystemMenu]
  Caption = 'Keys'
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
    Left = 0
    Top = 0
    Width = 614
    Height = 369
    Align = alClient
    ColCount = 7
    DefaultColWidth = 100
    DefaultRowHeight = 19
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goThumbTracking]
    TabOrder = 0
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 369
    Width = 614
    Height = 19
    Panels = <>
    SimplePanel = True
  end
end
