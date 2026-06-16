object dlg_print_num: Tdlg_print_num
  Left = 165
  Top = 151
  HelpContext = 101
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Stampa'
  ClientHeight = 99
  ClientWidth = 238
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 57
    Top = 18
    Width = 68
    Height = 16
    Caption = 'n'#176' di copie'
  end
  object i_num: TEdit
    Left = 129
    Top = 14
    Width = 51
    Height = 22
    MaxLength = 3
    TabOrder = 0
    Text = '1'
    OnChange = i_numChange
  end
  object btn_ok: TButton
    Left = 40
    Top = 48
    Width = 73
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btn_okClick
  end
  object btn_cancel: TButton
    Left = 124
    Top = 48
    Width = 73
    Height = 25
    Cancel = True
    Caption = 'Annulla'
    TabOrder = 2
    OnClick = btn_cancelClick
  end
end
