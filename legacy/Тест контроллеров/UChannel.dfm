object FormChannel: TFormChannel
  Left = 577
  Top = 101
  Width = 441
  Height = 469
  BorderStyle = bsSizeToolWin
  Caption = '����������� �������'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ChannelList: TListBox
    Left = 4
    Top = 62
    Width = 391
    Height = 347
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 16
    MultiSelect = True
    ParentFont = False
    TabOrder = 0
  end
  object BAddChannel: TButton
    Left = 6
    Top = 6
    Width = 121
    Height = 25
    Caption = '�������� �����'
    TabOrder = 1
    OnClick = BAddChannelClick
  end
  object BDeleteChannel: TButton
    Left = 132
    Top = 6
    Width = 129
    Height = 25
    Caption = '������� �����'
    TabOrder = 2
    OnClick = BDeleteChannelClick
  end
  object BDeleteAllChannels: TButton
    Left = 266
    Top = 6
    Width = 129
    Height = 25
    Caption = '������� ��� ������'
    TabOrder = 3
    OnClick = BDeleteAllChannelsClick
  end
  object EChannel: TEdit
    Left = 4
    Top = 36
    Width = 391
    Height = 24
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
end
