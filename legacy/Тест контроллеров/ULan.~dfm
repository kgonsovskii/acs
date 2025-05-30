object FAlarm: TFAlarm
  Left = 662
  Top = 227
  Width = 511
  Height = 576
  ActiveControl = EChip
  BorderStyle = bsSizeToolWin
  Caption = 'Работа с LAN-линией'
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
  object Label1: TLabel
    Left = 38
    Top = 8
    Width = 45
    Height = 13
    Caption = 'Код чипа'
  end
  object Label2: TLabel
    Left = 134
    Top = 8
    Width = 25
    Height = 13
    Caption = 'Порт'
  end
  object Label3: TLabel
    Left = 246
    Top = 6
    Width = 34
    Height = 13
    Caption = 'Обрыв'
  end
  object Label4: TLabel
    Left = 170
    Top = 26
    Width = 109
    Height = 13
    Caption = 'Короткое замыкание'
  end
  object GroupBox2: TGroupBox
    Left = 300
    Top = 216
    Width = 183
    Height = 291
    Caption = 'Работа с контроллером'
    TabOrder = 17
    object SetFactor: TButton
      Left = 8
      Top = 188
      Width = 167
      Height = 25
      Caption = 'Установить число бит'
      TabOrder = 0
    end
    object BCntrOn: TButton
      Left = 8
      Top = 222
      Width = 167
      Height = 25
      Caption = 'Включить рабочий режим'
      TabOrder = 1
      OnClick = BCntrOnClick
    end
    object BCntrOff: TButton
      Left = 8
      Top = 248
      Width = 167
      Height = 25
      Caption = 'Выключить рабочий режим'
      Enabled = False
      TabOrder = 2
      OnClick = BCntrOffClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 300
    Top = 48
    Width = 183
    Height = 163
    Caption = 'Работа со списком чипов'
    TabOrder = 15
  end
  object Cods: TStringGrid
    Left = 2
    Top = 50
    Width = 295
    Height = 477
    TabStop = False
    Anchors = [akLeft, akTop, akBottom]
    ColCount = 4
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    Options = [goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goRowSelect]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    OnClick = CodsClick
    OnDrawCell = CodsDrawCell
    ColWidths = (
      115
      51
      51
      70)
  end
  object BRead: TButton
    Left = 308
    Top = 340
    Width = 167
    Height = 25
    Caption = 'Прочитать коды чипов'
    TabOrder = 1
    TabStop = False
    OnClick = BReadClick
  end
  object BWrite: TButton
    Left = 308
    Top = 366
    Width = 167
    Height = 25
    Caption = 'Записать коды чипов'
    TabOrder = 2
    TabStop = False
    OnClick = BWriteClick
  end
  object EChip: TEdit
    Left = 2
    Top = 22
    Width = 117
    Height = 25
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    MaxLength = 12
    ParentFont = False
    TabOrder = 3
    Text = '222222222222'
  end
  object BLoad: TButton
    Left = 308
    Top = 66
    Width = 167
    Height = 25
    Caption = 'Загрузить из файла'
    TabOrder = 4
    TabStop = False
    OnClick = BLoadClick
  end
  object EdPort: TEdit
    Left = 128
    Top = 22
    Width = 35
    Height = 25
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    MaxLength = 1
    ParentFont = False
    TabOrder = 5
  end
  object BSave: TButton
    Left = 308
    Top = 178
    Width = 167
    Height = 25
    Caption = 'Сохранить в файле'
    TabOrder = 6
    TabStop = False
    OnClick = BSaveClick
  end
  object BAdd: TButton
    Left = 308
    Top = 98
    Width = 167
    Height = 23
    Caption = 'Добавить'
    TabOrder = 7
    TabStop = False
    OnClick = BAddClick
  end
  object MCount: TMemo
    Left = 168
    Top = 0
    Width = 31
    Height = 19
    TabStop = False
    TabOrder = 8
    Visible = False
  end
  object BChange: TButton
    Left = 308
    Top = 122
    Width = 167
    Height = 23
    Caption = 'Изменить'
    TabOrder = 9
    TabStop = False
    OnClick = BChangeClick
  end
  object BDelete: TButton
    Left = 308
    Top = 146
    Width = 167
    Height = 23
    Caption = 'Удалить'
    TabOrder = 10
    TabStop = False
    OnClick = BDeleteClick
  end
  object SBar: TStatusBar
    Left = 0
    Top = 530
    Width = 503
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object BlockAll: TButton
    Left = 308
    Top = 230
    Width = 167
    Height = 25
    Caption = 'Заблокировать все'
    TabOrder = 11
    TabStop = False
    OnClick = BlockAllClick
  end
  object UnBlockAll: TButton
    Left = 308
    Top = 256
    Width = 167
    Height = 25
    Caption = 'Разблокировать все'
    TabOrder = 12
    TabStop = False
    OnClick = UnBlockAllClick
  end
  object Block: TButton
    Left = 308
    Top = 282
    Width = 167
    Height = 25
    Caption = 'Заблокировать чип'
    TabOrder = 13
    TabStop = False
    OnClick = BlockClick
  end
  object UnBlock: TButton
    Left = 308
    Top = 308
    Width = 167
    Height = 25
    Caption = 'Разблокировать чип'
    TabOrder = 14
    TabStop = False
    OnClick = UnBlockClick
  end
  object Panel1: TPanel
    Left = 282
    Top = 4
    Width = 200
    Height = 19
    TabOrder = 18
    object O2: TPanel
      Left = 30
      Top = 4
      Width = 21
      Height = 11
      Caption = '2'
      TabOrder = 0
    end
    object O3: TPanel
      Left = 54
      Top = 4
      Width = 21
      Height = 11
      Caption = '3'
      TabOrder = 1
    end
    object O4: TPanel
      Left = 78
      Top = 4
      Width = 21
      Height = 11
      Caption = '4'
      TabOrder = 2
    end
    object O5: TPanel
      Left = 102
      Top = 4
      Width = 21
      Height = 11
      Caption = '5'
      TabOrder = 3
    end
    object O6: TPanel
      Left = 126
      Top = 4
      Width = 21
      Height = 11
      Caption = '6'
      TabOrder = 4
    end
    object O7: TPanel
      Left = 150
      Top = 4
      Width = 21
      Height = 11
      Caption = '7'
      TabOrder = 5
    end
    object O8: TPanel
      Left = 174
      Top = 4
      Width = 21
      Height = 11
      Caption = '8'
      TabOrder = 6
    end
    object O1: TPanel
      Left = 4
      Top = 4
      Width = 21
      Height = 11
      Caption = '1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
  end
  object Panel10: TPanel
    Left = 282
    Top = 24
    Width = 200
    Height = 19
    TabOrder = 19
    object K2: TPanel
      Left = 30
      Top = 4
      Width = 21
      Height = 11
      Caption = '2'
      TabOrder = 0
    end
    object K3: TPanel
      Left = 54
      Top = 4
      Width = 21
      Height = 11
      Caption = '3'
      TabOrder = 1
    end
    object K4: TPanel
      Left = 78
      Top = 4
      Width = 21
      Height = 11
      Caption = '4'
      TabOrder = 2
    end
    object K5: TPanel
      Left = 102
      Top = 4
      Width = 21
      Height = 11
      Caption = '5'
      TabOrder = 3
    end
    object K6: TPanel
      Left = 126
      Top = 4
      Width = 21
      Height = 11
      Caption = '6'
      TabOrder = 4
    end
    object K7: TPanel
      Left = 150
      Top = 4
      Width = 21
      Height = 11
      Caption = '7'
      TabOrder = 5
    end
    object K8: TPanel
      Left = 174
      Top = 4
      Width = 21
      Height = 11
      Caption = '8'
      TabOrder = 6
    end
    object K1: TPanel
      Left = 4
      Top = 4
      Width = 21
      Height = 11
      Caption = '1'
      TabOrder = 7
    end
  end
  object OTimer: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = OTimerTimer
    Left = 60
    Top = 130
  end
  object KTimer: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = KTimerTimer
    Left = 102
    Top = 130
  end
end
