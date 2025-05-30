object FReg: TFReg
  Left = 526
  Top = 176
  Width = 475
  Height = 407
  BorderStyle = bsSizeToolWin
  Caption = 'Разное отладочное'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 298
    Top = 10
    Width = 26
    Height = 13
    Caption = 'мсек'
  end
  object SetData: TCheckBox
    Left = 14
    Top = 8
    Width = 241
    Height = 17
    Caption = 'Включить опрос состояний датчиков через'
    TabOrder = 0
    OnClick = SetDataClick
  end
  object ETime: TEdit
    Left = 258
    Top = 6
    Width = 37
    Height = 21
    TabOrder = 1
    Text = '1000'
  end
  object ChComplex: TCheckBox
    Left = 14
    Top = 30
    Width = 263
    Height = 17
    Caption = 'Опрос в автономном режиме для WA48 и 207'
    TabOrder = 2
    OnClick = ChComplexClick
  end
  object Button1: TButton
    Left = 6
    Top = 54
    Width = 75
    Height = 25
    Caption = 'Уст. ДК'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 88
    Top = 54
    Width = 87
    Height = 25
    Caption = 'Читать DATA'
    TabOrder = 4
    OnClick = Button2Click
  end
  object EData: TEdit
    Left = 182
    Top = 56
    Width = 253
    Height = 21
    TabOrder = 5
  end
  object ButtonBreak: TButton
    Left = 6
    Top = 82
    Width = 75
    Height = 25
    Caption = 'Тормоз'
    TabOrder = 6
    OnClick = ButtonBreakClick
  end
  object Button4: TButton
    Left = 88
    Top = 82
    Width = 87
    Height = 25
    Caption = 'К-во событий'
    TabOrder = 7
    OnClick = Button4Click
  end
  object M5: TMemo
    Left = 4
    Top = 140
    Width = 437
    Height = 217
    TabOrder = 8
  end
  object Button3: TButton
    Left = 182
    Top = 82
    Width = 105
    Height = 25
    Caption = 'Читать ключи'
    TabOrder = 9
    OnClick = Button3Click
  end
  object Button5: TButton
    Left = 294
    Top = 82
    Width = 101
    Height = 25
    Caption = 'LAN-линия'
    TabOrder = 10
    OnClick = Button5Click
  end
  object BBios: TButton
    Left = 6
    Top = 110
    Width = 75
    Height = 25
    Caption = 'Загр. BIOS'
    TabOrder = 11
    OnClick = BBiosClick
  end
  object WBios: TButton
    Left = 88
    Top = 110
    Width = 87
    Height = 25
    Caption = 'Запись BIOS'
    TabOrder = 12
    OnClick = WBiosClick
  end
  object TMemory: TButton
    Left = 182
    Top = 110
    Width = 105
    Height = 25
    Caption = 'Тест памяти'
    TabOrder = 13
    OnClick = TMemoryClick
  end
  object Button6: TButton
    Left = 294
    Top = 110
    Width = 101
    Height = 25
    Caption = 'Расписание'
    TabOrder = 14
    OnClick = Button6Click
  end
  object TimerDATA: TTimer
    Enabled = False
    OnTimer = TimerDATATimer
    Left = 402
    Top = 4
  end
  object OpenDial: TOpenDialog
    Filter = '.bin'
    Title = 'Файл биосканера'
    Left = 340
    Top = 6
  end
end
