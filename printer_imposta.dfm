object dlg_imposta_printer: Tdlg_imposta_printer
  Left = 1311
  Top = 274
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  ClientHeight = 493
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  DesignSize = (
    417
    493)
  PixelsPerInch = 96
  TextHeight = 16
  object txt_default_printer_01: TLabel
    Left = 15
    Top = 93
    Width = 189
    Height = 16
    Caption = 'stampante default alternativa'
    FocusControl = cb_default_printer_01
  end
  object txt_default_printer_00: TLabel
    Left = 15
    Top = 46
    Width = 116
    Height = 16
    Caption = 'stampante default'
    FocusControl = cb_default_printer_00
  end
  object txt_default_printer_cassetto_00: TLabel
    Left = 264
    Top = 46
    Width = 91
    Height = 16
    Caption = 'cassetto carta'
    FocusControl = cb_default_printer_cassetto_00
  end
  object txt_default_printer_cassetto_01: TLabel
    Left = 264
    Top = 93
    Width = 91
    Height = 16
    Caption = 'cassetto carta'
    FocusControl = cb_default_printer_cassetto_01
  end
  object txt_azione_default: TLabel
    Left = 7
    Top = 226
    Width = 92
    Height = 16
    Caption = 'azione default'
    FocusControl = cb_azione_default
  end
  object txt_default_printer_modalita: TLabel
    Left = 7
    Top = 4
    Width = 69
    Height = 32
    Alignment = taRightJustify
    Caption = 'stampante'#13#10'predefinita'
    FocusControl = cb_default_printer_modalita
  end
  object txt_printer_unknonw: TLabel
    Left = 29
    Top = 181
    Width = 119
    Height = 32
    Alignment = taRightJustify
    Caption = 'in assenza delle'#13#10'stampanti indicate'
    FocusControl = cb_printer_unknonw
  end
  object btn_ok: TFBitBtn
    Left = 126
    Top = 401
    Width = 80
    Height = 24
    Anchors = [akLeft, akBottom]
    Caption = 'F9 OK'
    Default = True
    TabOrder = 12
    OnClick = btn_okClick
    Glyph.Data = {
      CE070000424DCE07000000000000360000002800000024000000120000000100
      1800000000009807000000000000000000000000000000000000007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
      7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
      7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
      7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
      7F7F007F7F007F7F007F7F007F7FFFFFFF007F7F007F7F007F7F007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
      7F7F00007F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
      7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7FFFFFFF
      007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
      7F007F7F007F7F007F7F7F0000007F00007F007F0000007F7F007F7F007F7F00
      7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
      7F7F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F
      7F007F7F007F7F007F7F007F7F007F7F007F7F7F0000007F00007F00007F0000
      7F007F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
      007F7F007F7F007F7F7F7F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F
      7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F000000
      7F00007F00007F00007F00007F00007F007F0000007F7F007F7F007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F007F7F007F7F007F7F007F
      7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F00
      7F7F007F7F7F0000007F00007F00007F0000FF00007F00007F00007F00007F00
      7F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFF
      FF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F7F7F7FFFFFFF007F7F00
      7F7F007F7F007F7F007F7F007F7F007F7F007F00007F00007F0000FF00007F7F
      00FF00007F00007F00007F007F0000007F7F007F7F007F7F007F7F007F7F007F
      7F007F7F007F7F7F7F7FFFFFFF007F7F7F7F7F007F7F7F7F7FFFFFFF007F7F00
      7F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F00FF00
      007F0000FF00007F7F007F7F007F7F00FF00007F00007F00007F007F0000007F
      7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF7F7F7F007F7F00
      7F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F
      007F7F007F7F007F7F007F7F00FF00007F7F007F7F007F7F007F7F007F7F00FF
      00007F00007F00007F007F0000007F7F007F7F007F7F007F7F007F7F007F7F00
      7F7F7F7F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F
      7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
      7F007F7F007F7F007F7F007F7F00FF00007F00007F00007F007F0000007F7F00
      7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
      007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F
      7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00FF0000
      7F00007F00007F007F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F
      7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
      7F7F007F7F007F7F007F7F00FF00007F00007F00007F007F0000007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
      7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F00
      7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00FF00007F00
      007F00007F007F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
      7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFF
      FFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
      007F7F007F7F007F7F00FF00007F00007F007F0000007F7F007F7F007F7F007F
      7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F
      7F7FFFFFFF007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00FF00007F00007F
      00007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
      7F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF7F7F7F007F7F007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
      7F007F7F007F7F00FF00007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
      7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F
      007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
      7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
      7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F}
    NumGlyphs = 2
    color_background_down = clBtnFace
    color_background_up = clBtnFace
    show_shortcut = False
  end
  object btn_cancel: TFBitBtn
    Left = 211
    Top = 401
    Width = 81
    Height = 24
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Annulla'
    TabOrder = 13
    OnClick = btn_cancelClick
    Glyph.Data = {
      CE070000424DCE07000000000000360000002800000024000000120000000100
      1800000000009807000000000000000000000000000000000000007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
      7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
      7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F007F7F007F7F007F
      7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
      7F7F007F7F007F7F007F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F0000FF0000
      7F00007F7F7F7F007F7F007F7F007F7F007F7F007F7F0000FF7F7F7F007F7F00
      7F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7FFFFFFF007F7F
      007F7F007F7F007F7F007F7F007F7FFFFFFF007F7F007F7F007F7F007F7F007F
      7F007F7F007F7F0000FF00007F00007F00007F7F7F7F007F7F007F7F007F7F00
      00FF00007F00007F7F7F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F
      FFFFFF007F7F7F7F7FFFFFFF007F7F007F7F007F7FFFFFFF7F7F7F7F7F7FFFFF
      FF007F7F007F7F007F7F007F7F007F7F007F7F0000FF00007F00007F00007F00
      007F7F7F7F007F7F0000FF00007F00007F00007F00007F7F7F7F007F7F007F7F
      007F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F7FFFFF
      FF7F7F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F00
      7F7F0000FF00007F00007F00007F00007F7F7F7F00007F00007F00007F00007F
      00007F7F7F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F007F
      7F007F7F7F7F7FFFFFFF7F7F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF00
      7F7F007F7F007F7F007F7F007F7F007F7F0000FF00007F00007F00007F00007F
      00007F00007F00007F00007F7F7F7F007F7F007F7F007F7F007F7F007F7F007F
      7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F7F7F7F007F7F007F7F007F7F00
      7F7FFFFFFF7F7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
      0000FF00007F00007F00007F00007F00007F00007F7F7F7F007F7F007F7F007F
      7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F00
      7F7F007F7F007F7F007F7FFFFFFF7F7F7F007F7F007F7F007F7F007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F00007F00007F00007F00007F00007F7F7F
      7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
      7F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F7F7F7F007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F0000FF0000
      7F00007F00007F00007F7F7F7F007F7F007F7F007F7F007F7F007F7F007F7F00
      7F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F
      7F7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
      7F007F7F0000FF00007F00007F00007F00007F00007F7F7F7F007F7F007F7F00
      7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F
      007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F
      7F007F7F007F7F007F7F007F7F0000FF00007F00007F00007F7F7F7F00007F00
      007F00007F7F7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
      007F7F007F7F7F7F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F
      7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F0000FF00007F00007F00
      007F7F7F7F007F7F0000FF00007F00007F00007F7F7F7F007F7F007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F7F7F7F007F7F007F7F007F7F7F7F7FFFFF
      FF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F00
      7F7F0000FF00007F00007F7F7F7F007F7F007F7F007F7F0000FF00007F00007F
      00007F7F7F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F
      7F007F7F7F7F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F7F00
      7F7F007F7F007F7F007F7F007F7F007F7F0000FF00007F007F7F007F7F007F7F
      007F7F007F7F0000FF00007F00007F00007F007F7F007F7F007F7F007F7F007F
      7F007F7F7F7F7FFFFFFFFFFFFF7F7F7F007F7F007F7F007F7F7F7F7FFFFFFF00
      7F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F007F7F0000FF00007F0000FF007F
      7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F007F7F007F7F00
      7F7F007F7F007F7F7F7F7FFFFFFFFFFFFFFFFFFF7F7F7F007F7F007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
      7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
      7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F7F7F7F
      007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
      7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
      7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F}
    NumGlyphs = 2
    color_background_down = clBtnFace
    color_background_up = clBtnFace
    show_shortcut = False
  end
  object panel_predefinita: TFPanel
    Left = 12
    Top = 431
    Width = 394
    Height = 58
    Anchors = [akLeft, akBottom]
    Enabled = False
    ParentBackground = False
    TabOrder = 14
    object txt_predefinita: TLabel
      Left = 5
      Top = 8
      Width = 383
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'la stampante predefinita di sistema '#232
    end
    object str_default: TEdit
      Left = 12
      Top = 26
      Width = 370
      Height = 24
      TabStop = False
      Color = clMoneyGreen
      ReadOnly = True
      TabOrder = 0
    end
  end
  object cb_default_printer_00: TFCombo
    Left = 15
    Top = 64
    Width = 243
    Height = 24
    DropDownCount = 16
    TabOrder = 1
    OnExit = cb_default_printer_00Exit
    AAA_dropdownwidth = 0
    AAA_notify_modification = AAA_notify_modification
    AAA_NeedNotifyModification = True
    AAA_CanBeVoid = True
    AAA_CanBeInvalid = True
  end
  object cb_default_printer_01: TFCombo
    Left = 15
    Top = 109
    Width = 243
    Height = 24
    DropDownCount = 16
    TabOrder = 3
    OnExit = cb_default_printer_01Exit
    AAA_dropdownwidth = 0
    AAA_notify_modification = AAA_notify_modification
    AAA_NeedNotifyModification = True
    AAA_CanBeVoid = True
    AAA_CanBeInvalid = True
  end
  object cb_default_printer_cassetto_00: TFCombo
    Left = 264
    Top = 64
    Width = 138
    Height = 24
    Style = csDropDownList
    DropDownCount = 16
    TabOrder = 2
    AAA_dropdownwidth = 250
    AAA_notify_modification = AAA_notify_modification
    AAA_NeedNotifyModification = False
    AAA_CanBeVoid = True
    AAA_CanBeInvalid = True
  end
  object cb_default_printer_cassetto_01: TFCombo
    Left = 264
    Top = 109
    Width = 138
    Height = 24
    Style = csDropDownList
    DropDownCount = 16
    TabOrder = 4
    AAA_dropdownwidth = 250
    AAA_notify_modification = AAA_notify_modification
    AAA_NeedNotifyModification = False
    AAA_CanBeVoid = True
    AAA_CanBeInvalid = True
  end
  object cbx_forza_printer_report: TFCheckBox
    Left = 17
    Top = 139
    Width = 389
    Height = 17
    Hint = 
      'viene trascurata l'#39'indicazione fornita runtime '#13#10'dall'#39'eseguibile' +
      ' che esegue la stampa'
    Caption = 'ignora la stampante impostata dal programma a runtime'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    AAA_notify_modification = AAA_notify_modification
    AAA_NeedNotifyModification = True
  end
  object cbx_print_diretta: TFCheckBox
    Left = 17
    Top = 161
    Width = 344
    Height = 17
    Hint = 
      'a runtime imposta il flag che evita l'#39'apertura del dialogo di se' +
      'lezione della stampante'
    Caption = 'imposta flag stampa diretta su stampante default'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    AAA_notify_modification = AAA_notify_modification
    AAA_NeedNotifyModification = True
  end
  object cb_azione_default: TFCombo
    Left = 103
    Top = 222
    Width = 302
    Height = 24
    Hint = 
      'azione default eseguita all'#39'esecuzione del report'#13#10' '#13#10'se il repo' +
      'rt viene eseguito da un programma esterno,'#13#10'l'#39'impostazione qui s' +
      'pecificata prevale su quella specificata dal programma esterno'
    Style = csDropDownList
    DropDownCount = 16
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    AAA_dropdownwidth = 250
    AAA_notify_modification = AAA_notify_modification
    AAA_NeedNotifyModification = False
    AAA_CanBeVoid = False
    AAA_CanBeInvalid = False
  end
  object cb_default_printer_modalita: TFCombo
    Left = 83
    Top = 10
    Width = 319
    Height = 24
    Hint = 'determina la modalit'#224' di selezione della stampante predefinita'
    Style = csDropDownList
    DropDownCount = 16
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = cb_default_printer_modalitaClick
    Items.Strings = (
      'stampante predefinita di sistema'
      'ultima stampante utilizzata'
      'obbliga a selezionare stampante'
      'stampante sotto specificata')
    AAA_dropdownwidth = 250
    AAA_notify_modification = AAA_notify_modification
    AAA_NeedNotifyModification = False
    AAA_CanBeVoid = False
    AAA_CanBeInvalid = False
  end
  object cb_printer_unknonw: TFCombo
    Left = 155
    Top = 185
    Width = 250
    Height = 24
    Hint = 
      'azione da eseguirsi se nessuna delle stampanti specificate esist' +
      'e'
    Style = csDropDownList
    DropDownCount = 16
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    AAA_dropdownwidth = 250
    AAA_notify_modification = AAA_notify_modification
    AAA_NeedNotifyModification = False
    AAA_CanBeVoid = False
    AAA_CanBeInvalid = False
  end
  object cbx_silent_mode: TCheckBox
    Left = 116
    Top = 255
    Width = 129
    Height = 17
    Hint = 
      'elimina qualunque interazione con l'#39'utente'#13#10' '#13#10'questa impostazio' +
      'ne si sovrappone parzialmente ad altre impostazioni'#13#10'(esempio: S' +
      'TAMPA DIRETTA SENZA CONFERMA),'#13#10'ma serve per garantire l'#39'elimina' +
      'zione di qualunque interazione'
    Caption = 'modalit'#224' silente'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    OnClick = AAA_notify_modification
  end
  object gbox_printer_size_MIN: TFGroupBox
    Left = 22
    Top = 278
    Width = 370
    Height = 51
    Hint = 
      'la stampa sar'#224' eseguita se la stampante selezionata ha'#13#10'ALMENO l' +
      'e dimensioni specificate'
    Caption = 'dimensioni MINIME pagina stampante'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    object txt_page_min_height: TMyLabel
      Left = 9
      Top = 26
      Width = 84
      Height = 16
      Alignment = taRightJustify
      Caption = 'altezza (mm)'
      FocusControl = i_min_page_height
    end
    object txt_page_min_width: TMyLabel
      Left = 181
      Top = 26
      Width = 101
      Height = 16
      Alignment = taRightJustify
      Caption = 'larghezza (mm)'
      FocusControl = i_min_page_width
    end
    object i_min_page_height: TFEdit
      Left = 97
      Top = 22
      Width = 74
      Height = 24
      TabOrder = 0
      AAA_tipodato = fe_integer
      AAA_notify_modification = AAA_notify_modification
      AAA_NeedNotifyModification = True
      AAA_CanBeVoid = True
      AAA_CanBeInvalid = True
    end
    object i_min_page_width: TFEdit
      Left = 286
      Top = 22
      Width = 74
      Height = 24
      TabOrder = 1
      AAA_tipodato = fe_integer
      AAA_notify_modification = AAA_notify_modification
      AAA_NeedNotifyModification = True
      AAA_CanBeVoid = True
      AAA_CanBeInvalid = True
    end
  end
  object gbox_printer_size_MAX: TFGroupBox
    Left = 22
    Top = 337
    Width = 370
    Height = 51
    Hint = 
      'la stampa sar'#224' eseguita se la stampante selezionata ha'#13#10'dimensio' +
      'ni NON SUPERIORI a quelle specificate'
    Caption = 'dimensioni MASSIME pagina stampante'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
    object txt_page_max_height: TMyLabel
      Left = 9
      Top = 25
      Width = 84
      Height = 16
      Alignment = taRightJustify
      Caption = 'altezza (mm)'
      FocusControl = i_max_page_height
    end
    object txt_page_max_width: TMyLabel
      Left = 181
      Top = 25
      Width = 101
      Height = 16
      Alignment = taRightJustify
      Caption = 'larghezza (mm)'
      FocusControl = i_max_page_width
    end
    object i_max_page_height: TFEdit
      Left = 97
      Top = 21
      Width = 74
      Height = 24
      TabOrder = 0
      AAA_tipodato = fe_integer
      AAA_notify_modification = AAA_notify_modification
      AAA_NeedNotifyModification = True
      AAA_CanBeVoid = True
      AAA_CanBeInvalid = True
    end
    object i_max_page_width: TFEdit
      Left = 286
      Top = 21
      Width = 74
      Height = 24
      TabOrder = 1
      AAA_tipodato = fe_integer
      AAA_notify_modification = AAA_notify_modification
      AAA_NeedNotifyModification = True
      AAA_CanBeVoid = True
      AAA_CanBeInvalid = True
    end
  end
end
