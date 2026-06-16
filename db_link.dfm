object dlg_dblink: Tdlg_dblink
  Left = 185
  Top = 85
  HelpContext = 125
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Collegamento database <--> etichetta'
  ClientHeight = 279
  ClientWidth = 370
  Color = clBtnFace
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
  object txt_label_fields: TLabel
    Left = 19
    Top = 6
    Width = 112
    Height = 16
    Caption = 'variabili etichetta'
  end
  object txt_DB_fields: TLabel
    Left = 195
    Top = 6
    Width = 103
    Height = 16
    Caption = 'campi database'
  end
  object btn_ok: TFBitBtn
    Left = 60
    Top = 237
    Width = 89
    Height = 27
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = btn_okClick
    color_background_down = clBtnFace
    color_background_up = clBtnFace
    show_shortcut = False
  end
  object lb_etik: TComboBox
    Left = 16
    Top = 22
    Width = 165
    Height = 207
    Style = csSimple
    TabOrder = 1
    OnChange = lb_etikChange
  end
  object lb_db: TComboBox
    Left = 190
    Top = 22
    Width = 165
    Height = 207
    Style = csSimple
    TabOrder = 2
    OnChange = lb_dbChange
  end
  object cbx_codice_default: TFCheckBox
    Left = 212
    Top = 232
    Width = 139
    Height = 17
    Caption = 'codice principale'
    TabOrder = 3
    OnClick = cbx_codice_defaultClick
    AAA_NeedNotifyModification = False
  end
  object cbx_index: TFCheckBox
    Left = 212
    Top = 252
    Width = 147
    Height = 17
    Caption = 'campo con indice'
    TabOrder = 4
    OnClick = cbx_indexClick
    AAA_NeedNotifyModification = False
  end
  object tbl: TFTable
    AutoCalcFields = False
    ConnectionName = 'db_galateo'
    Exclusive = True
    DATABASENAME = 'db_galateo'
    Left = 8
    Top = 240
  end
end
