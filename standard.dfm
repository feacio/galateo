object dlg_standard_configurations: Tdlg_standard_configurations
  Left = 200
  Top = 94
  HelpContext = 111
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Configurazioni standard'
  ClientHeight = 181
  ClientWidth = 402
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object lb: TListBox
    Left = 13
    Top = 12
    Width = 375
    Height = 122
    TabOrder = 0
    OnDblClick = lbDblClick
  end
  object btn_ok: TButton
    Left = 106
    Top = 144
    Width = 89
    Height = 26
    Caption = 'OK'
    TabOrder = 1
    OnClick = btn_okClick
  end
  object btn_cancel: TButton
    Left = 208
    Top = 144
    Width = 89
    Height = 26
    Caption = 'Annulla'
    TabOrder = 2
    OnClick = btn_cancelClick
  end
end
