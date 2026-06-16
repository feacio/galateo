object dlg_select_printer: Tdlg_select_printer
  Left = 200
  Top = 98
  ActiveControl = lb
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  ClientHeight = 252
  ClientWidth = 291
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 0
    Top = 208
    Width = 289
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = 'attualmente la stampante predefinita '#232
  end
  object lb: TListBox
    Left = 33
    Top = 12
    Width = 225
    Height = 143
    ItemHeight = 16
    TabOrder = 0
    OnDblClick = lbDblClick
  end
  object btn_ok: TButton
    Left = 50
    Top = 170
    Width = 89
    Height = 27
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btn_okClick
  end
  object btn_cancel: TButton
    Left = 152
    Top = 170
    Width = 89
    Height = 27
    Cancel = True
    Caption = 'Annulla'
    TabOrder = 2
    OnClick = btn_cancelClick
  end
  object str_default: TEdit
    Left = 33
    Top = 228
    Width = 225
    Height = 24
    Enabled = False
    TabOrder = 3
  end
end
