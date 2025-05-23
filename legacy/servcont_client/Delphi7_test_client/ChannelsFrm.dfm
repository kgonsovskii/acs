object frmChannels: TfrmChannels
  Left = 442
  Top = 279
  BorderStyle = bsDialog
  Caption = 'Channels'
  ClientHeight = 246
  ClientWidth = 240
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 240
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    FullRepaint = False
    ParentBackground = True
    TabOrder = 0
    object Label1: TLabel
      Left = 4
      Top = 12
      Width = 42
      Height = 13
      Caption = 'Channel:'
    end
    object cbxChannels: TComboBox
      Left = 52
      Top = 8
      Width = 73
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = cbxChannelsChange
    end
  end
  object sgdChannels: TStringGrid
    Left = 0
    Top = 41
    Width = 240
    Height = 205
    Align = alClient
    ColCount = 2
    DefaultRowHeight = 19
    FixedCols = 0
    RowCount = 10
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goThumbTracking]
    TabOrder = 1
    ColWidths = (
      106
      128)
  end
end
