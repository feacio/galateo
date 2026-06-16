object dlg_expint_profilo: Tdlg_expint_profilo
  Left = 756
  Top = 228
  ClientHeight = 505
  ClientWidth = 512
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = [fsBold]
  OldCreateOrder = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object panel_base: TFPanel
    Left = 0
    Top = 0
    Width = 512
    Height = 457
    Align = alClient
    ParentBackground = False
    TabOrder = 0
    object pc: TFPageControl
      Left = 1
      Top = 90
      Width = 510
      Height = 366
      ActivePage = page_base
      Align = alClient
      OwnerDraw = True
      TabOrder = 1
      OnChange = pcChange
      AAA_AutoHighLight = True
      AAA_OpenOnFirstPage = True
      object page_base: TTabSheet
        Caption = 'opzioni'
        DesignSize = (
          502
          335)
        object txt_max_expint_lines: TMyLabel
          Left = 261
          Top = 75
          Width = 65
          Height = 16
          Caption = 'max righe'
          FocusControl = lo_max_expint_lines
        end
        object txt_expint_comando_specifico: TLabel
          Left = 12
          Top = 102
          Width = 107
          Height = 32
          Alignment = taRightJustify
          Caption = 'dopo export'#13#10'esegui comando'
          FocusControl = str_expint_comando_specifico
        end
        object txt_expint_file_azione: TLabel
          Left = 22
          Top = 75
          Width = 44
          Height = 16
          Caption = 'azione'
          FocusControl = cb_expint_file_azione
        end
        object rb_expint_target: TRadioGroup
          Left = 132
          Top = 3
          Width = 193
          Height = 57
          Hint = 
            'destinazione dell'#39'output;'#13#10'se DEFAULT viene utilizzato il valore' +
            ' default del report'#13#10'(e non quello del profilo di exportazione)'
          Caption = 'destinazione'
          Columns = 2
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          TabStop = True
          OnClick = rb_expint_targetClick
        end
        object lo_max_expint_lines: TFEdit
          Left = 331
          Top = 71
          Width = 79
          Height = 24
          Hint = 
            'numero max di righe exportate (viene emesso solo un avviso)'#13#10'las' +
            'ciare ZERO per indicare '#39'nessun limite'#39#13#10' '#13#10'esempio: il numero m' +
            'ax di righe exportate su EXCEL '#232' 65536'#13#10'(aumentato a 1.048.576 a' +
            ' partire dalla versione 2007)'
          MaxLength = 9
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          AAA_tipodato = fe_integer
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = False
          AAA_CanBeInvalid = False
        end
        object str_expint_comando_specifico: TFEdit
          Left = 126
          Top = 106
          Width = 346
          Height = 24
          Hint = 
            'dopo l'#39'esecuzione dell'#39'exportazione esegue il comando specificat' +
            'o'#13#10#13#10'il comando pu'#242' indicare un file dati (ad esempio un file EX' +
            'CEL)'#13#10'oppure un programma (es. NOTEPAD)'#13#10'oppure un file BATCH o ' +
            'altro secondo la Tua personale fantasia'
          Anchors = [akLeft, akTop, akRight]
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          AAA_tipodato = fe_generico
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object btn_browse_expint_comando_specifico: TFBitBtn
          Left = 478
          Top = 107
          Width = 18
          Height = 23
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 6
          TabStop = False
          OnClick = btn_browse_expint_comando_specificoClick
          color_background_down = clBtnFace
          color_background_up = clBtnFace
          show_shortcut = False
        end
        object cb_expint_file_azione: TFCombo
          Left = 74
          Top = 71
          Width = 170
          Height = 24
          Style = csDropDownList
          TabOrder = 3
          OnClick = cb_expint_file_azioneClick
          AAA_dropdownwidth = 0
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = False
          AAA_CanBeInvalid = False
        end
        object panel_note: TFPanel
          Left = 0
          Top = 239
          Width = 502
          Height = 96
          Align = alBottom
          Anchors = [akLeft, akTop, akRight, akBottom]
          ParentBackground = False
          TabOrder = 9
          DesignSize = (
            502
            96)
          object txt_note: TMyLabel
            Left = 18
            Top = 15
            Width = 28
            Height = 16
            Caption = 'note'
            FocusControl = str_note
          end
          object str_note: TFMemo
            Left = 50
            Top = 12
            Width = 439
            Height = 77
            Anchors = [akLeft, akTop, akRight, akBottom]
            ScrollBars = ssBoth
            TabOrder = 0
            AAA_notify_modification = AAA_notify_modification
            AAA_NeedNotifyModification = True
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = True
          end
        end
        object rb_expint_file_writemode: TRadioGroup
          Left = 336
          Top = 3
          Width = 149
          Height = 57
          Hint = 
            'modalit'#224' di scrittura;'#13#10'se DEFAULT viene utilizzata la modalit'#224' ' +
            'default del report'#13#10'(e non quella del profilo di exportazione)'
          Caption = 'modalit'#224' di scrittura'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          TabStop = True
          OnClick = rb_expint_targetClick
        end
        object cbx_select_sezioni: TFCheckBox
          Left = 31
          Top = 142
          Width = 337
          Height = 17
          Hint = 
            'Attiva la possibilit'#224' di selezionare a runtime le SEZIONI da exp' +
            'ortare.'#13#10' '#13#10'Tutte le sezioni possono essere attivate o disattiva' +
            'te,'#13#10'ad eccezione di quelle per le quali l'#39'exportazione '#232' DISABI' +
            'LITATA'#13#10'e che in ogni caso non sono exportabili.'#13#10' '#13#10'NB: l'#39'opzio' +
            'ne di scelta delle sezioni da exportare '#232' attiva solo'#13#10'se l'#39'expo' +
            'rtazione coinvolge una sola pagina logica.'#13#10'Se viceversa l'#39'expor' +
            'tazione coinvolge pi'#249' pagine logiche, '#13#10'il programma si comporta' +
            ' come se questa opzione fosse disattivata e'#13#10'vengono stampate so' +
            'lo le sezioni che per default sono ATTIVE.'
          Caption = 'consenti a runtime scelta sezioni da exportare'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = True
        end
        object rb_target_mode: TRadioGroup
          Left = 10
          Top = 3
          Width = 107
          Height = 57
          Hint = 'modalit'#224' di exportazione'
          Caption = 'modalit'#224
          Items.Strings = (
            'integrale'
            'XML')
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          TabStop = True
          OnClick = rb_expint_targetClick
        end
        object gbox_trattamento_testo: TFGroupBox
          Left = 10
          Top = 166
          Width = 484
          Height = 68
          Anchors = [akLeft, akTop, akRight]
          Caption = 'trattamento testo'
          TabOrder = 8
          object txt_expint_separatore: TMyLabel
            Left = 13
            Top = 19
            Width = 70
            Height = 16
            Caption = 'separatore'
            FocusControl = cb_expint_separatore
          end
          object cb_expint_separatore: TFCombo
            Left = 13
            Top = 35
            Width = 137
            Height = 24
            Style = csDropDownList
            TabOrder = 0
            AAA_dropdownwidth = 0
            AAA_notify_modification = AAA_notify_modification
            AAA_NeedNotifyModification = False
            AAA_CanBeVoid = False
            AAA_CanBeInvalid = True
          end
          object cbx_UTF8: TFCheckBox
            Left = 178
            Top = 20
            Width = 67
            Height = 17
            Hint = 
              'L'#39'esportazione viene eseguita codificando il testo in formato UF' +
              'T-8'
            Caption = 'UTF-8'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            AAA_notify_modification = AAA_notify_modification
            AAA_NeedNotifyModification = True
          end
          object cbx_elimina_speciali: TFCheckBox
            Left = 178
            Top = 40
            Width = 285
            Height = 17
            Hint = '*** RUNTIME assigned ***'
            Caption = 'elimina caratteri speciali (Excel e simili)'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            AAA_notify_modification = AAA_notify_modification
            AAA_NeedNotifyModification = True
          end
        end
      end
      object page_msgs: TTabSheet
        Caption = 'messaggi'
        ImageIndex = 1
        DesignSize = (
          502
          335)
        object txt_expint_msg_before: TLabel
          Left = 15
          Top = 14
          Width = 98
          Height = 16
          Alignment = taRightJustify
          Caption = 'msg pre export'
          FocusControl = str_expint_msg_before
        end
        object txt_expint_msg_after: TLabel
          Left = 4
          Top = 86
          Width = 109
          Height = 16
          Alignment = taRightJustify
          Caption = 'msg dopo export'
          FocusControl = str_expint_msg_after
        end
        object str_expint_msg_before: TFMemo
          Left = 118
          Top = 9
          Width = 385
          Height = 63
          Hint = 
            'messaggio che serve per eventuali istruzioni all'#39'operatore'#13#10' '#13#10'v' +
            'iene mostrato all'#39'operatore se '#232' attivata la proposta'#13#10'di esport' +
            'azione integrale automatica (PROPONI SUBITO)'#13#10' '#13#10'il testo viene ' +
            'anche assegnato come HINT (suggerimento)'#13#10'sul checkbox dell'#39'expo' +
            'rtazione integrale'
          Anchors = [akLeft, akTop, akRight]
          ParentShowHint = False
          ScrollBars = ssVertical
          ShowHint = True
          TabOrder = 0
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object str_expint_msg_after: TFMemo
          Left = 118
          Top = 85
          Width = 385
          Height = 65
          Hint = 'messaggio che serve per eventuali istruzioni all'#39'operatore'
          Anchors = [akLeft, akTop, akRight]
          ParentShowHint = False
          ScrollBars = ssVertical
          ShowHint = True
          TabOrder = 1
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
      end
      object page_pages: TTabSheet
        Caption = 'pagine logiche'
        Highlighted = True
        ImageIndex = 2
        object sb_pages: TScrollBox
          Left = 0
          Top = 0
          Width = 502
          Height = 335
          VertScrollBar.Tracking = True
          Align = alClient
          TabOrder = 0
          object panel_00: TFPanel
            Left = 0
            Top = 0
            Width = 498
            Height = 96
            Align = alTop
            ParentBackground = False
            TabOrder = 0
            object txt_sigla_00: TMyLabel
              Left = 224
              Top = 23
              Width = 80
              Height = 16
              Alignment = taRightJustify
              Caption = 'sigla pagina'
              FocusControl = str_sigla_export
            end
            object txt_label_page_00: TMyLabel
              Left = 1
              Top = 1
              Width = 496
              Height = 16
              Align = alTop
              Alignment = taCenter
              Caption = '***'
              Color = 8454143
              ParentColor = False
              Transparent = False
              ExplicitWidth = 18
            end
            object cbx_abilita: TFCheckBox
              Left = 8
              Top = 21
              Width = 157
              Height = 17
              Caption = 'abilita exportazione'
              TabOrder = 0
              OnClick = cbx_click_proc
              AAA_notify_modification = AAA_notify_modification
              AAA_NeedNotifyModification = False
            end
            object cbx_expint_pagina_fisica: TFCheckBox
              Left = 8
              Top = 42
              Width = 181
              Height = 17
              Caption = 'numero di pagina fisica'
              TabOrder = 2
              OnClick = cbx_click_proc
              AAA_notify_modification = AAA_notify_modification
              AAA_NeedNotifyModification = False
            end
            object cbx_expint_pagina_logica: TFCheckBox
              Left = 8
              Top = 58
              Width = 151
              Height = 17
              Caption = 'sigla pagina logica'
              TabOrder = 4
              OnClick = cbx_click_proc
              AAA_notify_modification = AAA_notify_modification
              AAA_NeedNotifyModification = False
            end
            object cbx_expint_sezione: TFCheckBox
              Left = 190
              Top = 58
              Width = 113
              Height = 17
              Caption = 'sigla sezione'
              TabOrder = 5
              OnClick = cbx_click_proc
              AAA_notify_modification = AAA_notify_modification
              AAA_NeedNotifyModification = False
            end
            object cbx_expint_record: TFCheckBox
              Left = 190
              Top = 42
              Width = 205
              Height = 17
              Caption = 'numero progressivo record'
              TabOrder = 3
              OnClick = cbx_click_proc
              AAA_notify_modification = AAA_notify_modification
              AAA_NeedNotifyModification = False
            end
            object str_sigla_export: TFEdit
              Left = 306
              Top = 19
              Width = 82
              Height = 24
              Hint = 
                'sigla che consente l'#39'dentificazione breve della pagina nel file ' +
                'esportato'
              MaxLength = 7
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              AAA_tipodato = fe_generico
              AAA_notify_modification = AAA_notify_modification
              AAA_NeedNotifyModification = False
              AAA_CanBeVoid = True
              AAA_CanBeInvalid = True
            end
            object cbx_expint_headers: TFCheckBox
              Left = 8
              Top = 75
              Width = 165
              Height = 17
              Caption = 'intestazione colonne'
              TabOrder = 6
              OnClick = cbx_click_proc
              AAA_notify_modification = AAA_notify_modification
              AAA_NeedNotifyModification = False
            end
            object cbx_blank_after_headers: TFCheckBox
              Left = 190
              Top = 75
              Width = 298
              Height = 17
              Caption = 'riga di separazione tra intestazione e dati'
              TabOrder = 7
              OnClick = cbx_click_proc
              AAA_notify_modification = AAA_notify_modification
              AAA_NeedNotifyModification = False
            end
          end
        end
      end
      object page_XML: TTabSheet
        Caption = 'XML base'
        ImageIndex = 3
        object MySplitter1: TFSplitter
          Left = 0
          Top = 105
          Width = 502
          Height = 7
          Cursor = crVSplit
          Align = alTop
          Color = clFuchsia
          ParentColor = False
          AAA_AutoColor = True
          ExplicitWidth = 510
        end
        object panel_XML_header: TFPanel
          Left = 0
          Top = 0
          Width = 502
          Height = 105
          Align = alTop
          ParentBackground = False
          TabOrder = 0
          object txt_XML_header: TMyLabel
            Left = 1
            Top = 1
            Width = 500
            Height = 16
            Align = alTop
            Caption = 'intestazione XML (inserito prima di qualunque dubug-info)'
            FocusControl = str_XML_header
            ExplicitWidth = 375
          end
          object str_XML_header: TFMemo
            Left = 1
            Top = 17
            Width = 500
            Height = 87
            Align = alClient
            ScrollBars = ssBoth
            TabOrder = 0
            WantTabs = True
            WordWrap = False
            AAA_notify_modification = AAA_notify_modification
            AAA_NeedNotifyModification = True
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = True
          end
        end
        object panel_XML_body: TFPanel
          Left = 0
          Top = 112
          Width = 502
          Height = 223
          Align = alClient
          ParentBackground = False
          TabOrder = 1
          object txt_struttura_XML: TMyLabel
            Left = 1
            Top = 1
            Width = 500
            Height = 16
            Align = alTop
            Caption = 'struttura dati XML'
            FocusControl = str_struttura_XML
            ExplicitWidth = 115
          end
          object str_struttura_XML: TFMemo
            Left = 1
            Top = 17
            Width = 500
            Height = 205
            Align = alClient
            ScrollBars = ssBoth
            TabOrder = 0
            WantTabs = True
            WordWrap = False
            AAA_notify_modification = AAA_notify_modification
            AAA_NeedNotifyModification = True
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = True
          end
        end
      end
    end
    object panel_top: TFPanel
      Left = 1
      Top = 1
      Width = 510
      Height = 89
      Align = alTop
      ParentBackground = False
      TabOrder = 0
      DesignSize = (
        510
        89)
      object txt_codice: TMyLabel
        Left = 44
        Top = 20
        Width = 42
        Height = 16
        Caption = 'codice'
        FocusControl = str_codice
      end
      object txt_descrizione: TMyLabel
        Left = 10
        Top = 48
        Width = 76
        Height = 16
        Caption = 'descrizione'
        FocusControl = str_descrizione
      end
      object str_codice: TFEdit
        Left = 90
        Top = 16
        Width = 191
        Height = 24
        TabOrder = 0
        AAA_tipodato = fe_generico
        AAA_notify_modification = AAA_notify_modification
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
      object str_descrizione: TFEdit
        Left = 90
        Top = 44
        Width = 410
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
        AAA_tipodato = fe_generico
        AAA_notify_modification = AAA_notify_modification
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
      object cbx_hidden: TFCheckBox
        Left = 332
        Top = 20
        Width = 98
        Height = 17
        Caption = 'disattivato'
        TabOrder = 1
        AAA_notify_modification = AAA_notify_modification
        AAA_NeedNotifyModification = True
      end
    end
  end
  object panel_buttons: TFPanel
    Left = 0
    Top = 457
    Width = 512
    Height = 48
    Align = alBottom
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      512
      48)
    object btn_ok: TFBitBtn
      Left = 20
      Top = 14
      Width = 85
      Height = 25
      Action = AL_save
      Caption = 'OK'
      TabOrder = 0
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
      show_shortcut = True
    end
    object btn_cancel: TFBitBtn
      Left = 116
      Top = 14
      Width = 89
      Height = 25
      Action = AL_cancel
      Caption = 'Annulla'
      TabOrder = 1
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
    object btn_help: TFBitBtn
      Left = 423
      Top = 14
      Width = 78
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'aiuto'
      TabOrder = 2
      TabStop = False
      OnClick = btn_helpClick
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        888888888880008888888888880BB00888888888880BB0088888888888800888
        88888888880B008888888888880B008888888888880B008888888888880BB008
        888888880080BB0088888880B0080BB008888880B00880B008888880BB000BB0
        088888880BBBBB00888888888000000888888888888888888888}
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = False
    end
  end
  object AL: TActionList
    Left = 304
    Top = 104
    object AL_save: TAction
      Caption = 'OK'
      ShortCut = 120
      OnExecute = AL_saveExecute
    end
    object AL_cancel: TAction
      Caption = 'Annulla'
      ShortCut = 27
      OnExecute = AL_cancelExecute
    end
  end
end
