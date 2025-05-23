object frmChips: TfrmChips
  Left = 337
  Top = 202
  Width = 622
  Height = 422
  BorderIcons = [biSystemMenu]
  Caption = 'Chips'
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
    Top = 41
    Width = 614
    Height = 335
    Align = alClient
    DefaultColWidth = 100
    DefaultRowHeight = 19
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goThumbTracking]
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnKeyUp = GridKeyUp
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 376
    Width = 614
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 614
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    FullRepaint = False
    ParentBackground = True
    TabOrder = 2
    object Label12: TLabel
      Left = 8
      Top = 12
      Width = 27
      Height = 13
      Caption = 'Ports:'
    end
    object chbPort1: TCheckBox
      Left = 40
      Top = 12
      Width = 17
      Height = 17
      TabOrder = 0
    end
    object chbPort2: TCheckBox
      Left = 56
      Top = 12
      Width = 17
      Height = 17
      TabOrder = 1
    end
    object chbPort3: TCheckBox
      Left = 72
      Top = 12
      Width = 17
      Height = 17
      TabOrder = 2
    end
    object chbPort4: TCheckBox
      Left = 88
      Top = 12
      Width = 17
      Height = 17
      TabOrder = 3
    end
    object chbPort5: TCheckBox
      Left = 104
      Top = 12
      Width = 17
      Height = 17
      TabOrder = 4
    end
    object chbPort6: TCheckBox
      Left = 120
      Top = 12
      Width = 17
      Height = 17
      TabOrder = 5
    end
    object chbPort7: TCheckBox
      Left = 136
      Top = 12
      Width = 17
      Height = 17
      TabOrder = 6
    end
    object chbPort8: TCheckBox
      Left = 152
      Top = 12
      Width = 17
      Height = 17
      TabOrder = 7
    end
    object Button1: TButton
      Left = 184
      Top = 8
      Width = 75
      Height = 25
      Action = frmMain.actControllerReadAllChips
      TabOrder = 8
    end
    object Button2: TButton
      Left = 264
      Top = 8
      Width = 75
      Height = 25
      Action = frmMain.actControllerWriteAllChips
      TabOrder = 9
    end
    object Button3: TButton
      Left = 352
      Top = 8
      Width = 75
      Height = 25
      Action = frmMain.actControllerActivateChip
      TabOrder = 10
    end
    object Button4: TButton
      Left = 432
      Top = 8
      Width = 75
      Height = 25
      Action = frmMain.actControllerDeactivateChip
      TabOrder = 11
    end
    object Button5: TButton
      Left = 520
      Top = 8
      Width = 75
      Height = 25
      Action = frmMain.actControllerEraseAllChips
      TabOrder = 12
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 396
    Top = 128
    object Add1: TMenuItem
      Action = actAdd
    end
    object Delete1: TMenuItem
      Action = actDel
    end
    object ClearAll1: TMenuItem
      Action = actClear
    end
  end
  object ActionList1: TActionList
    OnUpdate = ActionList1Update
    Left = 360
    Top = 128
    object actAdd: TAction
      Caption = 'Add'
      OnExecute = actAddExecute
    end
    object actDel: TAction
      Caption = 'Delete'
      OnExecute = actDelExecute
    end
    object actClear: TAction
      Caption = 'Clear All'
      OnExecute = actClearExecute
    end
  end
end
