object dlg_murphie: Tdlg_murphie
  Left = 162
  Top = 103
  HelpContext = 101
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'La verit'#224
  ClientHeight = 173
  ClientWidth = 467
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Memo1: TMemo
    Left = 18
    Top = 12
    Width = 423
    Height = 71
    TabStop = False
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Palatino'
    Font.Style = []
    Lines.Strings = (
      #171'Se i costruttori costruissero come i programmatori '
      'programmano, il frullo d'#39'ali del primo picchio che '
      'passasse '
      'potrebbe distruggere la civilt'#224#187'.')
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object Button1: TButton
    Left = 6
    Top = 114
    Width = 455
    Height = 25
    Caption = 'Concedo la grazia al programmatore in virt'#249' della sua buona fede'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 6
    Top = 142
    Width = 455
    Height = 25
    Caption = 'I programmatori non dovrebbero commettere errori'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 206
    Top = 86
    Width = 173
    Height = 21
    BorderStyle = bsNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Palatino'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
    Text = 'Dalle Leggi di Murphie'
  end
end
