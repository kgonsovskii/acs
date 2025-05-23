object frmTimetable: TfrmTimetable
  Left = 274
  Top = 291
  BorderStyle = bsDialog
  Caption = 'Timetable'
  ClientHeight = 412
  ClientWidth = 535
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
  object Label1: TLabel
    Left = 92
    Top = 12
    Width = 12
    Height = 13
    Caption = '=='
  end
  object Bevel1: TBevel
    Left = 4
    Top = 116
    Width = 525
    Height = 10
    Shape = bsBottomLine
  end
  object Bevel2: TBevel
    Left = 4
    Top = 360
    Width = 525
    Height = 10
    Shape = bsBottomLine
  end
  object Button1: TButton
    Left = 190
    Top = 380
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 184
    Width = 157
    Height = 73
    Caption = 'Interval'
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 24
      Width = 26
      Height = 13
      Caption = 'From:'
    end
    object Label3: TLabel
      Left = 36
      Top = 44
      Width = 3
      Height = 13
      Caption = ':'
    end
    object Label4: TLabel
      Left = 112
      Top = 44
      Width = 3
      Height = 13
      Caption = ':'
    end
    object Label5: TLabel
      Left = 84
      Top = 24
      Width = 16
      Height = 13
      Caption = 'To:'
    end
    object Label6: TLabel
      Left = 72
      Top = 44
      Width = 6
      Height = 13
      Caption = '--'
    end
    object edtFromHour: TEdit
      Left = 8
      Top = 40
      Width = 25
      Height = 21
      TabOrder = 0
      Text = '1'
    end
    object edtFromMinute: TEdit
      Left = 44
      Top = 40
      Width = 25
      Height = 21
      TabOrder = 1
      Text = '0'
    end
    object edtToHour: TEdit
      Left = 84
      Top = 40
      Width = 25
      Height = 21
      TabOrder = 2
      Text = '3'
    end
    object edtToMinute: TEdit
      Left = 120
      Top = 40
      Width = 25
      Height = 21
      TabOrder = 3
      Text = '0'
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 260
    Width = 157
    Height = 93
    Caption = 'Pers. Categories'
    TabOrder = 2
    object chbPersCat1: TCheckBox
      Left = 8
      Top = 20
      Width = 33
      Height = 17
      Caption = '1'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object chbPersCat2: TCheckBox
      Left = 8
      Top = 36
      Width = 33
      Height = 17
      Caption = '2'
      TabOrder = 1
    end
    object chbPersCat3: TCheckBox
      Left = 8
      Top = 52
      Width = 33
      Height = 17
      Caption = '3'
      TabOrder = 2
    end
    object chbPersCat4: TCheckBox
      Left = 8
      Top = 68
      Width = 33
      Height = 17
      Caption = '4'
      TabOrder = 3
    end
    object chbPersCat5: TCheckBox
      Left = 44
      Top = 20
      Width = 33
      Height = 17
      Caption = '5'
      TabOrder = 4
    end
    object chbPersCat6: TCheckBox
      Left = 44
      Top = 36
      Width = 33
      Height = 17
      Caption = '6'
      TabOrder = 5
    end
    object chbPersCat7: TCheckBox
      Left = 44
      Top = 52
      Width = 33
      Height = 17
      Caption = '7'
      TabOrder = 6
    end
    object chbPersCat8: TCheckBox
      Left = 44
      Top = 68
      Width = 33
      Height = 17
      Caption = '8'
      TabOrder = 7
    end
    object chbPersCat9: TCheckBox
      Left = 80
      Top = 20
      Width = 33
      Height = 17
      Caption = '9'
      TabOrder = 8
    end
    object chbPersCat10: TCheckBox
      Left = 80
      Top = 36
      Width = 33
      Height = 17
      Caption = '10'
      TabOrder = 9
    end
    object chbPersCat11: TCheckBox
      Left = 80
      Top = 52
      Width = 33
      Height = 17
      Caption = '11'
      TabOrder = 10
    end
    object chbPersCat12: TCheckBox
      Left = 80
      Top = 68
      Width = 33
      Height = 17
      Caption = '12'
      TabOrder = 11
    end
    object chbPersCat13: TCheckBox
      Left = 120
      Top = 20
      Width = 33
      Height = 17
      Caption = '13'
      TabOrder = 12
    end
    object chbPersCat14: TCheckBox
      Left = 120
      Top = 36
      Width = 33
      Height = 17
      Caption = '14'
      TabOrder = 13
    end
    object chbPersCat15: TCheckBox
      Left = 120
      Top = 52
      Width = 33
      Height = 17
      Caption = '15'
      TabOrder = 14
    end
    object chbPersCat16: TCheckBox
      Left = 120
      Top = 68
      Width = 33
      Height = 17
      Caption = '16'
      TabOrder = 15
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 132
    Width = 157
    Height = 49
    Caption = 'Day'
    TabOrder = 3
    object cbxDays2: TComboBox
      Left = 12
      Top = 20
      Width = 137
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = '1 - '#1087#1086#1085#1077#1076#1077#1083#1100#1085#1080#1082
      Items.Strings = (
        '1 - '#1087#1086#1085#1077#1076#1077#1083#1100#1085#1080#1082
        '2 - '#1074#1090#1086#1088#1085#1080#1082
        '3 - '#1089#1088#1077#1076#1072
        '4 - '#1095#1077#1090#1074#1077#1088#1075
        '5 - '#1087#1103#1090#1085#1080#1094#1072
        '6 - '#1089#1091#1073#1073#1086#1090#1072
        '7 - '#1074#1086#1089#1082#1088#1077#1089#1077#1085#1100#1077
        '8 - *'#1087#1088#1072#1079#1076#1085#1080#1082)
    end
  end
  object Button5: TButton
    Left = 176
    Top = 216
    Width = 75
    Height = 25
    Caption = '+'
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 176
    Top = 248
    Width = 75
    Height = 25
    Caption = '-'
    TabOrder = 5
    OnClick = Button6Click
  end
  object Button4: TButton
    Left = 270
    Top = 380
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object sgdItems: TStringGrid
    Left = 260
    Top = 136
    Width = 269
    Height = 221
    ColCount = 4
    DefaultRowHeight = 19
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goThumbTracking]
    TabOrder = 7
  end
  object DateTimePicker: TDateTimePicker
    Left = 8
    Top = 8
    Width = 81
    Height = 21
    Date = 39519.507461689810000000
    Time = 39519.507461689810000000
    TabOrder = 8
  end
  object cbxDays1: TComboBox
    Left = 112
    Top = 8
    Width = 137
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 9
    Text = '1 - '#1087#1086#1085#1077#1076#1077#1083#1100#1085#1080#1082
    Items.Strings = (
      '1 - '#1087#1086#1085#1077#1076#1077#1083#1100#1085#1080#1082
      '2 - '#1074#1090#1086#1088#1085#1080#1082
      '3 - '#1089#1088#1077#1076#1072
      '4 - '#1095#1077#1090#1074#1077#1088#1075
      '5 - '#1087#1103#1090#1085#1080#1094#1072
      '6 - '#1089#1091#1073#1073#1086#1090#1072
      '7 - '#1074#1086#1089#1082#1088#1077#1089#1077#1085#1100#1077
      '8 - *'#1087#1088#1072#1079#1076#1085#1080#1082)
  end
  object sgdSpecialsDays: TStringGrid
    Left = 260
    Top = 4
    Width = 269
    Height = 109
    ColCount = 2
    DefaultRowHeight = 19
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goThumbTracking]
    TabOrder = 10
  end
  object Button2: TButton
    Left = 176
    Top = 40
    Width = 75
    Height = 25
    Caption = '+'
    TabOrder = 11
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 176
    Top = 72
    Width = 75
    Height = 25
    Caption = '-'
    TabOrder = 12
    OnClick = Button3Click
  end
end
