object labels: Tlabels
  Left = 537
  Top = 199
  HelpContext = 116
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Caratteristiche voce di testo'
  ClientHeight = 496
  ClientWidth = 593
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 16
  object pc: TFPageControl
    Left = 0
    Top = 29
    Width = 593
    Height = 431
    ActivePage = page_expint
    Align = alClient
    OwnerDraw = True
    TabOrder = 1
    AAA_AutoHighLight = False
    AAA_OpenOnFirstPage = True
    object page_oggetto: TTabSheet
      Caption = 'F2 base'
      object page_object_type: TMyPageControl
        Left = 0
        Top = 33
        Width = 585
        Height = 222
        ActivePage = page_text
        Align = alClient
        OwnerDraw = True
        TabOrder = 1
        OnChange = page_object_typeChange
        AAA_AutoHighLight = True
        AAA_OpenOnFirstPage = False
        object page_text: TTabSheet
          Caption = 'testo statico'
          object panel_text: TFPanel
            Left = 0
            Top = 0
            Width = 577
            Height = 191
            Align = alClient
            Caption = '***'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
            object cbx_runtime: TCheckBox
              Left = 23
              Top = 16
              Width = 246
              Height = 17
              Caption = 'parametro domandato '#39'a runtime'#39
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'System'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              OnClick = enable_ctrls_Click
            end
            object gbox_lingua: TFGroupBox
              Left = 16
              Top = 60
              Width = 405
              Height = 107
              Caption = 'traduzione automatica elementi di testo'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'System'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 2
              DesignSize = (
                405
                107)
              object txt_ID_lingua: TLabel
                Left = 23
                Top = 29
                Width = 58
                Height = 16
                Caption = 'ID lingua'
                FocusControl = cb_ID_lingua
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'System'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object cb_ID_lingua: TFCombo
                Left = 88
                Top = 25
                Width = 241
                Height = 24
                Hint = 
                  'indicare l'#39'identificatore del testo statico'#13#10'sar'#224' utilizzata la ' +
                  'versione nella lingua specificata sulle opzioni generali'
                Anchors = [akLeft, akTop, akRight]
                DropDownCount = 12
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'System'
                Font.Style = [fsBold]
                ParentFont = False
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
                OnChange = cb_showChange
                AAA_dropdownwidth = 0
                AAA_notify_modification = AAA_modified
                AAA_NeedNotifyModification = False
                AAA_CanBeVoid = True
                AAA_CanBeInvalid = True
              end
              object cbx_IDs_lingua_selected_context: TFCheckBox
                Left = 92
                Top = 56
                Width = 225
                Height = 17
                Hint = 
                  'se FLAGGATO, il programma carica esclusivamente gli'#13#10'identificat' +
                  'ori linguistici legati al contesto selezionato'#13#10' '#13#10'se NON FLAGGA' +
                  'TO il programma carica TUTTI gli identificatori linguistici'#13#10'(a ' +
                  'patto che siano dotati di contesto linguistico)'
                Anchors = [akTop, akRight]
                Caption = '*** context ***'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'System'
                Font.Style = [fsBold]
                ParentFont = False
                ParentShowHint = False
                ShowHint = True
                TabOrder = 1
                OnClick = cbx_IDs_lingua_selected_contextClick
                AAA_NeedNotifyModification = False
              end
              object cbx_IDs_lingua_generic_context: TFCheckBox
                Left = 92
                Top = 80
                Width = 173
                Height = 17
                Hint = 
                  'se FLAGGATO vengono caricati gli identificatori linguistici GENE' +
                  'RICI'#13#10'(ovvero quelli slegati da uno specifico contesto linguisti' +
                  'co)'
                Anchors = [akTop, akRight]
                Caption = 'IDs privi di contesto'
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'System'
                Font.Style = [fsBold]
                ParentFont = False
                ParentShowHint = False
                ShowHint = True
                TabOrder = 2
                OnClick = cbx_IDs_lingua_selected_contextClick
                AAA_NeedNotifyModification = False
              end
            end
            object cbx_attiva_traduzione: TFCheckBox
              Left = 23
              Top = 35
              Width = 356
              Height = 17
              Caption = 'attiva la traduzione automatica per questo oggetto'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'System'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 1
              OnClick = cbx_attiva_traduzioneClick
              AAA_NeedNotifyModification = False
            end
          end
        end
        object page_formula: TTabSheet
          Caption = 'formula calcolata'
          ImageIndex = 1
          object panel_formula: TFPanel
            Left = 0
            Top = 155
            Width = 577
            Height = 36
            Align = alBottom
            ParentBackground = False
            TabOrder = 1
            DesignSize = (
              577
              36)
            object txt_funzioni: TLabel
              Left = 10
              Top = 13
              Width = 124
              Height = 16
              Alignment = taRightJustify
              Caption = 'funzioni disponibili'
            end
            object cb_available_functions: TFCombo
              Left = 139
              Top = 7
              Width = 397
              Height = 24
              Anchors = [akLeft, akTop, akRight]
              DropDownCount = 20
              TabOrder = 0
              TabStop = False
              AAA_dropdownwidth = 240
              AAA_NeedNotifyModification = False
              AAA_CanBeVoid = True
              AAA_CanBeInvalid = True
            end
            object btn_help_funzioni: TFBitBtn
              Left = 542
              Top = 7
              Width = 29
              Height = 25
              Anchors = [akTop, akRight]
              TabOrder = 1
              TabStop = False
              OnClick = btn_help_funzioniClick
              Glyph.Data = {
                DE010000424DDE01000000000000760000002800000024000000120000000100
                0400000000006801000000000000000000001000000000000000000000000000
                80000080000000808000800000008000800080800000C0C0C000808080000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333336633
                3333333333333FF3333333330000333333364463333333333333388F33333333
                00003333333E66433333333333338F38F3333333000033333333E66333333333
                33338FF8F3333333000033333333333333333333333338833333333300003333
                3333446333333333333333FF3333333300003333333666433333333333333888
                F333333300003333333E66433333333333338F38F333333300003333333E6664
                3333333333338F38F3333333000033333333E6664333333333338F338F333333
                0000333333333E6664333333333338F338F3333300003333344333E666433333
                333F338F338F3333000033336664333E664333333388F338F338F33300003333
                E66644466643333338F38FFF8338F333000033333E6666666663333338F33888
                3338F3330000333333EE666666333333338FF33333383333000033333333EEEE
                E333333333388FFFFF8333330000333333333333333333333333388888333333
                0000}
              NumGlyphs = 2
              color_background_down = clBtnFace
              color_background_up = clBtnFace
              show_shortcut = False
            end
          end
          object str_formula: TFMemo
            Left = 0
            Top = 0
            Width = 577
            Height = 155
            Align = alClient
            Color = 16777088
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            ScrollBars = ssVertical
            TabOrder = 0
            OnChange = AAA_modified
            AAA_NeedNotifyModification = False
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = True
          end
        end
        object page_variabile: TTabSheet
          Caption = 'variabile'
          Highlighted = True
          ImageIndex = 2
          object memo_DB_colonna: TFMemo
            Left = 0
            Top = 21
            Width = 577
            Height = 170
            Align = alClient
            Color = 8454143
            ScrollBars = ssVertical
            TabOrder = 1
            AAA_notify_modification = AAA_modified
            AAA_NeedNotifyModification = False
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = True
          end
          object panel_header_variabile: TFPanel
            Left = 0
            Top = 0
            Width = 577
            Height = 21
            Align = alTop
            ParentBackground = False
            TabOrder = 0
            DesignSize = (
              577
              21)
            object txt_nome_colonna: TLabel
              Left = 5
              Top = 3
              Width = 91
              Height = 16
              Caption = 'nome colonna'
              FocusControl = memo_DB_colonna
            end
            object cbx_log_SQL: TCheckBox
              Left = 510
              Top = 3
              Width = 67
              Height = 17
              Hint = 
                'l'#39'istruzione SQL viene registrata nel file di LOG (se richiesto ' +
                'dalle impostazioni generali)'
              Anchors = [akTop, akRight]
              Caption = 'log sql'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = AAA_modified
            end
          end
        end
      end
      object panel_tipovar: TFPanel
        Left = 0
        Top = 0
        Width = 585
        Height = 33
        Align = alTop
        ParentBackground = False
        TabOrder = 0
        object txt_tipovar: TLabel
          Left = 7
          Top = 7
          Width = 76
          Height = 16
          Caption = 'tipo oggetto'
          FocusControl = cb_tipovar
        end
        object cb_tipovar: TFCombo
          Left = 87
          Top = 4
          Width = 196
          Height = 24
          Style = csDropDownList
          DropDownCount = 16
          TabOrder = 0
          OnChange = cb_tipovarChange
          AAA_dropdownwidth = 260
          AAA_notify_modification = AAA_modified
          AAA_NeedNotifyModification = True
          AAA_CanBeVoid = False
          AAA_CanBeInvalid = False
        end
        object rb_solo_testo: TRadioButton
          Left = 295
          Top = 8
          Width = 57
          Height = 17
          Caption = 'testo'
          TabOrder = 1
          OnClick = rb_solo_testoClick
        end
        object rb_numero: TRadioButton
          Left = 362
          Top = 8
          Width = 75
          Height = 17
          Caption = 'numero'
          TabOrder = 2
          OnClick = rb_numeroClick
        end
      end
      object panel_visual: TFPanel
        Left = 0
        Top = 255
        Width = 585
        Height = 145
        Align = alBottom
        ParentBackground = False
        TabOrder = 2
        DesignSize = (
          585
          145)
        object txt_show: TLabel
          Left = 3
          Top = 14
          Width = 124
          Height = 16
          Caption = 'F6 visualizzazione'
          FocusControl = cb_show
        end
        object txt_print_if: TLabel
          Left = 12
          Top = 40
          Width = 112
          Height = 16
          Caption = 'F11 stampa se ...'
          FocusControl = str_print_if
        end
        object txt_hints: TLabel
          Left = 8
          Top = 96
          Width = 82
          Height = 16
          Caption = 'Hint (editing)'
          FocusControl = str_hints
        end
        object txt_comportamento_null: TLabel
          Left = 26
          Top = 70
          Width = 101
          Height = 16
          Alignment = taRightJustify
          Caption = 'se valore NULL'
          FocusControl = cb_comportamento_null
        end
        object txt_value_when_null: TLabel
          Left = 327
          Top = 70
          Width = 69
          Height = 16
          Anchors = [akTop, akRight]
          Caption = 'usa valore'
          FocusControl = cb_value_when_null
        end
        object txt_criterio_ricalcolo: TLabel
          Left = 10
          Top = 123
          Width = 189
          Height = 16
          Alignment = taRightJustify
          Caption = 'criterio di ricalcolo del valore'
          FocusControl = cb_criterio_ricalcolo
        end
        object cb_show: TFCombo
          Left = 131
          Top = 9
          Width = 452
          Height = 24
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 12
          TabOrder = 0
          OnChange = cb_showChange
          AAA_dropdownwidth = 400
          AAA_notify_modification = AAA_modified
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = False
          AAA_CanBeInvalid = False
        end
        object str_print_if: TEdit
          Left = 131
          Top = 36
          Width = 452
          Height = 23
          Hint = 
            'Se la condizione indicata non '#232' verificata, l'#39'oggetto non viene ' +
            'stampato'
          Anchors = [akLeft, akTop, akRight]
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnChange = AAA_modified
        end
        object str_hints: TEdit
          Left = 96
          Top = 92
          Width = 487
          Height = 23
          Anchors = [akLeft, akTop, akRight]
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          OnChange = AAA_modified
        end
        object cb_comportamento_null: TFCombo
          Left = 131
          Top = 65
          Width = 186
          Height = 24
          Hint = 
            'definisce il valore visualizzato quando il valore del campo '#232' NU' +
            'LL'#13#10' '#13#10'il comportamento DEFAULT '#232' definito sulle impostazioni de' +
            'l report'#13#10' '#13#10'il comportamento STANDARD '#232' il seguente:'#13#10'- NUMERI:' +
            ' valore "0" (zero)'#13#10'- STRINGHE: nessun valore (stringa vuota)'#13#10' ' +
            #13#10'ATTENZIONE'#13#10'questa opzione NON cambia il valore dell'#39'oggetto, ' +
            'ma ne modifica solamente la visualizzazione'#13#10'per questo motivo i' +
            'l valore del campo, ove referenziato in una FORMULA, '#13#10'resta par' +
            'i al valore STANDARD (come sopra specificato)'#13#10' '#13#10'Per modificare' +
            ' realmente il valore di un campo, '#13#10'e non solo la sua visualizza' +
            'zione,'#13#10#232' necessario intervenire a livello della query SQL'
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 12
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnChange = cb_comportamento_nullChange
          AAA_dropdownwidth = 400
          AAA_notify_modification = AAA_modified
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = False
          AAA_CanBeInvalid = False
        end
        object cb_value_when_null: TFCombo
          Left = 401
          Top = 65
          Width = 180
          Height = 24
          Hint = 
            'invece del valore NULL viene utilizzato il valore qui specificat' +
            'o'
          Anchors = [akTop, akRight]
          DropDownCount = 12
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnChange = cb_showChange
          AAA_dropdownwidth = 0
          AAA_notify_modification = AAA_modified
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object cb_criterio_ricalcolo: TFCombo
          Left = 205
          Top = 118
          Width = 376
          Height = 24
          Hint = 
            'criterio di rivalutazione del valore dell'#39'oggetto'#13#10'si applica a ' +
            'FORMULE ed ESPRESSIONI SQL'#13#10' '#13#10'per ragioni di efficienza il valo' +
            're di ogni oggetto CALCOLATO'#13#10'viene determinato una sola volta e' +
            ' poi riutilizzato'#13#10' '#13#10'questo parametro consente di gestire casi ' +
            'non standard'#13#10'che richiedono una diversa politica di ricalcolo'#13#10 +
            'del valore degli oggetti calcolati'
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 12
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          OnChange = cb_comportamento_nullChange
          Items.Strings = (
            'calcola una sola volta e salva valore'
            'ricalcola dopo la modifica di ogni parametro runtime'
            'ricalcola dopo la richiesta dei parametri runtime'
            'ricalcola sempre')
          AAA_dropdownwidth = 0
          AAA_notify_modification = AAA_modified
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = False
          AAA_CanBeInvalid = False
        end
      end
    end
    object page_formato: TTabSheet
      Caption = 'F3 formato'
      object pc_formato: TMyPageControl
        Left = 0
        Top = 18
        Width = 585
        Height = 382
        ActivePage = page_formato_numero
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        OwnerDraw = True
        Style = tsButtons
        TabOrder = 0
        AAA_AutoHighLight = True
        AAA_OpenOnFirstPage = True
        object page_dimensione: TTabSheet
          Caption = 'dim && pos'
          Highlighted = True
          object panel_size_pos: TFPanel
            Left = 0
            Top = 0
            Width = 577
            Height = 348
            Align = alClient
            Color = 13434879
            ParentBackground = False
            TabOrder = 0
            DesignSize = (
              577
              348)
            object gbox_size: TGroupBox
              Left = 8
              Top = 1
              Width = 285
              Height = 64
              Caption = 'Dimensione'
              TabOrder = 0
              object txt_size_cm: TLabel
                Left = 52
                Top = 40
                Width = 19
                Height = 16
                Caption = 'cm'
                FocusControl = i_size_cm
              end
              object txt_size_chars: TLabel
                Left = 130
                Top = 40
                Width = 53
                Height = 16
                Caption = 'caratteri'
                FocusControl = i_size_chars
              end
              object rb_size_fissa: TRadioButton
                Left = 115
                Top = 17
                Width = 55
                Height = 17
                Caption = '&fissa'
                TabOrder = 1
                OnClick = rb_sizeClick
              end
              object rb_size_auto: TRadioButton
                Left = 13
                Top = 17
                Width = 95
                Height = 17
                Caption = '&automatica'
                TabOrder = 0
                OnClick = rb_sizeClick
              end
              object i_size_cm: TEdit
                Left = 76
                Top = 36
                Width = 45
                Height = 24
                AutoSize = False
                TabOrder = 3
                OnChange = AAA_modified
              end
              object i_size_chars: TEdit
                Left = 188
                Top = 36
                Width = 45
                Height = 24
                AutoSize = False
                TabOrder = 4
                OnChange = AAA_modified
              end
              object cbx_autoheight: TFCheckBox
                Left = 189
                Top = 17
                Width = 92
                Height = 17
                Hint = 'determina automaticamente l'#39'altezza dell'#39'oggetto'
                Caption = 'autoheight'
                Color = clBtnFace
                ParentColor = False
                ParentShowHint = False
                ShowHint = True
                TabOrder = 2
                AAA_notify_modification = AAA_modified
                AAA_NeedNotifyModification = False
              end
            end
            object rb_align: TRadioGroup
              Left = 299
              Top = 1
              Width = 104
              Height = 65
              Caption = 'Allineamento'
              ItemIndex = 0
              Items.Strings = (
                'Sinistra'
                'Centro'
                'Destra')
              TabOrder = 1
              OnClick = AAA_modified
            end
            object gbx_posizione: TGroupBox
              Left = 8
              Top = 114
              Width = 477
              Height = 72
              Caption = 'Posizione'
              TabOrder = 4
              object txt_left: TLabel
                Left = 8
                Top = 17
                Width = 73
                Height = 16
                Caption = 'orizzontale'
                FocusControl = i_left_cm
              end
              object txt_top: TLabel
                Left = 25
                Top = 45
                Width = 56
                Height = 16
                Caption = 'verticale'
                FocusControl = i_top_cm
              end
              object i_left_cm: TEdit
                Left = 84
                Top = 13
                Width = 51
                Height = 24
                AutoSize = False
                TabOrder = 0
                OnChange = AAA_modified
              end
              object i_top_cm: TEdit
                Left = 84
                Top = 41
                Width = 51
                Height = 24
                AutoSize = False
                TabOrder = 1
                OnChange = AAA_modified
              end
              object cbx_centrato: TCheckBox
                Left = 149
                Top = 47
                Width = 160
                Height = 22
                Caption = 'c&entrato nella pagina'
                TabOrder = 4
                OnClick = AAA_modified
              end
              object cbx_posizione_fissa: TCheckBox
                Left = 149
                Top = 12
                Width = 264
                Height = 17
                Hint = 
                  'La posizione dell'#39'oggetto non viene influenzata dagli oggetti so' +
                  'prastanti'
                Caption = 'posizione fissa nella pagina/sezione'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 2
                OnClick = AAA_modified
              end
              object cbx_footer: TCheckBox
                Left = 149
                Top = 30
                Width = 322
                Height = 17
                Hint = 
                  'La posizione dell'#39'oggetto in fase di disegno rimane legata al fo' +
                  'ndo della pagina'#13#10'Serve per facilitare la sistemazione di report' +
                  's su stampanti con lunghezza di pagina differente.'#13#10'Questa opzio' +
                  'ne non influenza la posizione dell'#39'oggetto a runtime.'
                Caption = 'posizione legata al fondo pagina (design-time)'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 3
                OnClick = AAA_modified
              end
            end
            object gbox_shift_pos: TFGroupBox
              Left = 8
              Top = 194
              Width = 559
              Height = 76
              Hint = 
                'Le formule qui specificate consentono di determinare'#13#10'(a RUNTIME' +
                ') la posizione di stampa dell'#39'oggetto.'#13#10'La posizione pu'#242' essere'#13 +
                #10'- ASSOLUTA: determinazione diretta della posizione di stampa'#13#10'-' +
                ' RELATIVA: spostamento rispetto alla posizione assegnata'#13#10#13#10'Le f' +
                'ormule devono dare un risultato NUMERICO'#13#10'che viene interpretato' +
                ' come un valore espresso in CENTRIMETRI'
              Anchors = [akLeft, akTop, akRight]
              Caption = 'FORMULE calcolo posizione (cm)'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 5
              DesignSize = (
                559
                76)
              object txt_formula_Xpos: TLabel
                Left = 12
                Top = 23
                Width = 45
                Height = 16
                Alignment = taRightJustify
                Caption = 'asse X'
                FocusControl = str_formula_Xpos
              end
              object txt_formula_Xpos_type: TLabel
                Left = 410
                Top = 23
                Width = 24
                Height = 16
                Anchors = [akTop, akRight]
                Caption = 'tipo'
                FocusControl = cb_formula_Xpos
              end
              object txt_formula_Ypos: TLabel
                Left = 11
                Top = 49
                Width = 46
                Height = 16
                Alignment = taRightJustify
                Caption = 'asse Y'
                FocusControl = str_formula_Ypos
              end
              object txt_formula_Ypos_type: TLabel
                Left = 410
                Top = 49
                Width = 24
                Height = 16
                Anchors = [akTop, akRight]
                Caption = 'tipo'
                FocusControl = cb_formula_Ypos
              end
              object str_formula_Xpos: TEdit
                Left = 62
                Top = 19
                Width = 344
                Height = 24
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                TabOrder = 0
                OnChange = AAA_modified
              end
              object cb_formula_Xpos: TComboBox
                Left = 438
                Top = 19
                Width = 113
                Height = 24
                Style = csDropDownList
                Anchors = [akTop, akRight]
                ParentShowHint = False
                ShowHint = False
                TabOrder = 1
                OnChange = AAA_modified
              end
              object str_formula_Ypos: TEdit
                Left = 62
                Top = 45
                Width = 344
                Height = 24
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                TabOrder = 2
                OnChange = AAA_modified
              end
              object cb_formula_Ypos: TComboBox
                Left = 438
                Top = 45
                Width = 113
                Height = 24
                Style = csDropDownList
                Anchors = [akTop, akRight]
                ParentShowHint = False
                ShowHint = False
                TabOrder = 3
                OnChange = AAA_modified
              end
            end
            object gbox_rotazione: TGroupBox
              Left = 407
              Top = 1
              Width = 163
              Height = 64
              Caption = 'Rotazione'
              TabOrder = 2
              object txt_rotazione: TFLabel
                Left = 14
                Top = 16
                Width = 105
                Height = 16
                AutoSize = True
                Bold = True
                FontName = 'System'
                TextXPos = 0
                TextYPos = 0
                Transparent = False
                BackColor = clBtnFace
                Color = clBtnFace
                Caption = 'rotazione (gradi)'
                FontColor = clWindowText
                FontHeight = -13
                FontSize = 10
                FontWidth = 0
                FontWeight = LFW_Bold
                Underline = False
                Angle = 0
                FontOrientation = 0
                Italic = False
                StrikeOut = False
                ShadowX = 0
                ShadowY = 0
                ShadowColor = clBlack
                BorderColor = clBlack
                BorderWidth = 0
                ExternalBorderColor = clGray
                ExternalBorderWidth = 0
                ExternalFillColor = clBtnFace
                ExternalFill = False
                Align = alNone
                Alignment = taRightJustify
                FocusControl = i_rotazione
                Layout = tlTop
              end
              object txt_font_orientation: TLabel
                Left = 34
                Top = 41
                Width = 85
                Height = 16
                Hint = 'orientamento delle SINGOLE LETTERE che compongono il testo'
                Alignment = taRightJustify
                Caption = 'orientamento'
                Color = clBtnFace
                FocusControl = i_font_orientation
                ParentColor = False
                ParentShowHint = False
                ShowHint = True
                Transparent = False
              end
              object i_rotazione: TFEdit
                Left = 122
                Top = 12
                Width = 35
                Height = 24
                MaxLength = 3
                TabOrder = 0
                Text = '0'
                OnChange = i_rotazioneChange
                OnEnter = i_rotazioneEnter
                OnExit = i_rotazioneExit
                AAA_tipodato = fe_integer
                AAA_notify_modification = AAA_modified
                AAA_NeedNotifyModification = False
                AAA_CanBeVoid = False
                AAA_CanBeInvalid = False
              end
              object i_font_orientation: TFEdit
                Left = 122
                Top = 37
                Width = 35
                Height = 24
                MaxLength = 3
                TabOrder = 1
                Text = '0'
                OnChange = i_rotazioneChange
                OnEnter = i_rotazioneEnter
                OnExit = i_rotazioneExit
                AAA_tipodato = fe_integer
                AAA_notify_modification = AAA_modified
                AAA_NeedNotifyModification = False
                AAA_CanBeVoid = False
                AAA_CanBeInvalid = False
              end
            end
            object cbx_PDF_modificabile: TFCheckBox
              Left = 16
              Top = 287
              Width = 193
              Height = 17
              Hint = 'determina automaticamente l'#39'altezza dell'#39'oggetto'
              Caption = 'oggetto PDF modificabile'
              Color = clBtnFace
              ParentColor = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 6
              AAA_notify_modification = AAA_modified
              AAA_NeedNotifyModification = False
            end
            object gbox_sfondo: TGroupBox
              Left = 8
              Top = 65
              Width = 285
              Height = 50
              Caption = 'Sfondo'
              TabOrder = 3
              object txt_sfondo: TMyLabel
                Left = 125
                Top = 11
                Width = 40
                Height = 32
                Alignment = taRightJustify
                Caption = 'colore'#13#10'fondo'
                FocusControl = panel_fondo
              end
              object cbx_trasparente: TFCheckBox
                Left = 12
                Top = 21
                Width = 101
                Height = 17
                Caption = 'trasparente'
                Color = clBtnFace
                ParentColor = False
                TabOrder = 0
                OnClick = enable_ctrls_Click
                AAA_NeedNotifyModification = False
              end
              object panel_fondo: TFPanel
                Left = 168
                Top = 14
                Width = 110
                Height = 29
                ParentBackground = False
                TabOrder = 1
                OnClick = panel_fondoClick
              end
            end
          end
        end
        object page_formattazione: TTabSheet
          Caption = 'formattazione'
          object panel_formattazione: TFPanel
            Left = 0
            Top = 0
            Width = 577
            Height = 348
            Align = alClient
            Color = 16777173
            ParentBackground = False
            TabOrder = 0
            DesignSize = (
              577
              348)
            object gbox_formattazione: TGroupBox
              Left = 8
              Top = 4
              Width = 562
              Height = 144
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Formattazione'
              TabOrder = 0
              object txt_minimum_auto_size: TLabel
                Left = 233
                Top = 16
                Width = 80
                Height = 16
                Caption = 'dim. minima'
                FocusControl = cb_minimum_auto_size
              end
              object txt_interlinea: TLabel
                Left = 54
                Top = 102
                Width = 161
                Height = 16
                Caption = 'cm interlinea (se + righe)'
                FocusControl = fl_interlinea
              end
              object txt_max_vertical_size: TLabel
                Left = 390
                Top = 55
                Width = 93
                Height = 16
                Caption = 'dim. vert. max'
                FocusControl = fl_max_vertical_size
              end
              object txt_max_rows: TLabel
                Left = 270
                Top = 55
                Width = 77
                Height = 16
                Caption = '# max righe'
                FocusControl = i_max_rows
              end
              object cbx_riduci_se_necessario: TCheckBox
                Left = 9
                Top = 16
                Width = 214
                Height = 17
                Hint = 
                  'riduce automaticamente il font se il campo'#13#10#232' troppo stretto per' +
                  ' contenere il testo'
                Caption = 'riduce font automaticamente'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
                OnClick = cbx_riduci_se_necessarioClick
              end
              object cb_minimum_auto_size: TComboBox
                Left = 316
                Top = 12
                Width = 49
                Height = 24
                Style = csDropDownList
                TabOrder = 1
                OnChange = AAA_modified
                Items.Strings = (
                  '36'
                  '24'
                  '20'
                  '18'
                  '16'
                  '14'
                  '12'
                  '11'
                  '10'
                  '9'
                  '8'
                  '7'
                  '6'
                  '5'
                  '4'
                  '3'
                  '2'
                  '1')
              end
              object cbx_giustificato: TFCheckBox
                Left = 9
                Top = 35
                Width = 97
                Height = 17
                Caption = 'giustificato'
                Color = clBtnFace
                ParentColor = False
                TabOrder = 2
                AAA_notify_modification = AAA_modified
                AAA_NeedNotifyModification = False
              end
              object cbx_multiline: TCheckBox
                Left = 9
                Top = 52
                Width = 257
                Height = 22
                Caption = 'spezza su pi'#249' righe se &necessario'
                TabOrder = 3
                OnClick = cbx_multilineClick
              end
              object cbx_insert_if_multiline: TCheckBox
                Left = 27
                Top = 81
                Width = 357
                Height = 17
                Caption = 'sposta verso il basso i campi sottostanti se + righe'
                TabOrder = 6
                OnClick = AAA_modified
              end
              object fl_interlinea: TEdit
                Left = 219
                Top = 98
                Width = 63
                Height = 24
                Hint = 
                  'Valore dell'#39'interlinea, nel caso il testo si distribuisca su pi'#249 +
                  ' d'#39'una riga.'#13#10'Lasciare a ZERO per il valore di interlinea defaul' +
                  't'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 7
                OnChange = AAA_modified
              end
              object cbx_suppress_blank: TCheckBox
                Left = 9
                Top = 122
                Width = 337
                Height = 17
                Caption = 'sposta &verso l'#39'alto i campi sottostanti se vuoto'
                TabOrder = 8
                OnClick = AAA_modified
              end
              object fl_max_vertical_size: TEdit
                Left = 487
                Top = 51
                Width = 63
                Height = 24
                Hint = 
                  'Dimensione verticale massima, espressa in CM'#13#10'lasciare 0 per NES' +
                  'SUN LIMITE'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 5
                OnChange = AAA_modified
                OnExit = fl_max_vertical_sizeExit
              end
              object i_max_rows: TEdit
                Left = 351
                Top = 51
                Width = 25
                Height = 24
                Hint = 
                  'Numero massimo di righe in cui pu'#242' essere spezzato l'#39'oggetto'#13#10'la' +
                  'sciare 0 per NESSUN LIMITE'
                MaxLength = 2
                ParentShowHint = False
                ShowHint = True
                TabOrder = 4
                OnChange = AAA_modified
                OnExit = i_max_rowsExit
              end
            end
            object gbox_LCF: TFGroupBox
              Left = 8
              Top = 229
              Width = 562
              Height = 93
              Hint = '** runtime'
              Anchors = [akLeft, akTop, akRight]
              Caption = 'FONT alternativo condizionale'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              DesignSize = (
                562
                93)
              object txt_LCF_condizione: TLabel
                Left = 8
                Top = 23
                Width = 71
                Height = 16
                Alignment = taRightJustify
                Caption = 'condizione'
                FocusControl = str_LCF_condizione
              end
              object txt_LCF_esempio: TLabel
                Left = 436
                Top = 23
                Width = 57
                Height = 16
                Anchors = [akTop, akRight]
                Caption = 'Esempio'
                FocusControl = str_LCF_condizione
                Transparent = False
              end
              object txt_LCF_foreground_color: TLabel
                Left = 208
                Top = 49
                Width = 76
                Height = 16
                Caption = 'colore testo'
                FocusControl = cb_LCF_foreground_color
              end
              object str_LCF_condizione: TEdit
                Left = 86
                Top = 19
                Width = 338
                Height = 24
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                TabOrder = 0
                OnChange = AAA_modified
              end
              object cbx_LCF_bold: TFCheckBox
                Left = 10
                Top = 50
                Width = 87
                Height = 17
                AllowGrayed = True
                Caption = 'grassetto'
                Color = clBtnFace
                ParentColor = False
                TabOrder = 1
                OnClick = cbx_LCF_Click
                AAA_notify_modification = AAA_modified
                AAA_NeedNotifyModification = False
              end
              object cbx_LCF_italic: TFCheckBox
                Left = 117
                Top = 50
                Width = 74
                Height = 17
                AllowGrayed = True
                Caption = 'corsivo'
                Color = clBtnFace
                ParentColor = False
                TabOrder = 2
                OnClick = cbx_LCF_Click
                AAA_notify_modification = AAA_modified
                AAA_NeedNotifyModification = False
              end
              object cbx_LCF_underline: TFCheckBox
                Left = 10
                Top = 70
                Width = 99
                Height = 17
                AllowGrayed = True
                Caption = 'sottolineato'
                Color = clBtnFace
                ParentColor = False
                TabOrder = 3
                OnClick = cbx_LCF_Click
                AAA_notify_modification = AAA_modified
                AAA_NeedNotifyModification = False
              end
              object cbx_LCF_strikeout: TFCheckBox
                Left = 117
                Top = 70
                Width = 74
                Height = 17
                AllowGrayed = True
                Caption = 'barrato'
                Color = clBtnFace
                ParentColor = False
                TabOrder = 4
                OnClick = cbx_LCF_Click
                AAA_notify_modification = AAA_modified
                AAA_NeedNotifyModification = False
              end
              object panel_LCF_background_color: TFPanel
                Left = 324
                Top = 51
                Width = 233
                Height = 35
                Anchors = [akLeft, akTop, akRight]
                Caption = 'colore sfondo'
                ParentBackground = False
                ParentShowHint = False
                ShowHint = False
                TabOrder = 6
                OnClick = panel_LCF_background_colorClick
              end
              object cb_LCF_foreground_color: TJvColorComboBox
                Left = 204
                Top = 65
                Width = 110
                Height = 23
                ColorDialogText = 'Custom...'
                DroppedDownWidth = 110
                NewColorText = 'Custom'
                ParentShowHint = False
                ShowHint = False
                TabOrder = 5
                OnChange = cb_LCF_foreground_colorChange
              end
              object btn_help_LCF: TFBitBtn
                Left = 535
                Top = 17
                Width = 21
                Height = 25
                Anchors = [akTop, akRight]
                TabOrder = 7
                OnClick = btn_help_LCFClick
                Glyph.Data = {
                  DE010000424DDE01000000000000760000002800000024000000120000000100
                  0400000000006801000000000000000000001000000000000000000000000000
                  80000080000000808000800000008000800080800000C0C0C000808080000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333336633
                  3333333333333FF3333333330000333333364463333333333333388F33333333
                  00003333333E66433333333333338F38F3333333000033333333E66333333333
                  33338FF8F3333333000033333333333333333333333338833333333300003333
                  3333446333333333333333FF3333333300003333333666433333333333333888
                  F333333300003333333E66433333333333338F38F333333300003333333E6664
                  3333333333338F38F3333333000033333333E6664333333333338F338F333333
                  0000333333333E6664333333333338F338F3333300003333344333E666433333
                  333F338F338F3333000033336664333E664333333388F338F338F33300003333
                  E66644466643333338F38FFF8338F333000033333E6666666663333338F33888
                  3338F3330000333333EE666666333333338FF33333383333000033333333EEEE
                  E333333333388FFFFF8333330000333333333333333333333333388888333333
                  0000}
                NumGlyphs = 2
                color_background_down = clBtnFace
                color_background_up = clBtnFace
                show_shortcut = False
              end
            end
            object gbox_formato: TGroupBox
              Left = 8
              Top = 150
              Width = 562
              Height = 74
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Formattazione'
              TabOrder = 1
              object txt_datetime_format: TLabel
                Left = 11
                Top = 31
                Width = 106
                Height = 16
                Alignment = taRightJustify
                Caption = 'formato data/ora'
                FocusControl = str_datetime_format
              end
              object str_datetime_format: TEdit
                Left = 121
                Top = 27
                Width = 146
                Height = 24
                TabOrder = 0
                OnChange = AAA_modified
              end
              object btn_help_datetime_format: TFBitBtn
                Left = 270
                Top = 26
                Width = 21
                Height = 25
                TabOrder = 1
                OnClick = btn_help_datetime_formatClick
                Glyph.Data = {
                  DE010000424DDE01000000000000760000002800000024000000120000000100
                  0400000000006801000000000000000000001000000000000000000000000000
                  80000080000000808000800000008000800080800000C0C0C000808080000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333336633
                  3333333333333FF3333333330000333333364463333333333333388F33333333
                  00003333333E66433333333333338F38F3333333000033333333E66333333333
                  33338FF8F3333333000033333333333333333333333338833333333300003333
                  3333446333333333333333FF3333333300003333333666433333333333333888
                  F333333300003333333E66433333333333338F38F333333300003333333E6664
                  3333333333338F38F3333333000033333333E6664333333333338F338F333333
                  0000333333333E6664333333333338F338F3333300003333344333E666433333
                  333F338F338F3333000033336664333E664333333388F338F338F33300003333
                  E66644466643333338F38FFF8338F333000033333E6666666663333338F33888
                  3338F3330000333333EE666666333333338FF33333383333000033333333EEEE
                  E333333333388FFFFF8333330000333333333333333333333333388888333333
                  0000}
                NumGlyphs = 2
                color_background_down = clBtnFace
                color_background_up = clBtnFace
                show_shortcut = False
              end
              object rb_charcase: TRadioGroup
                Left = 326
                Top = 9
                Width = 121
                Height = 60
                Caption = ' Carattere '
                Items.Strings = (
                  'minuscolo'
                  'Normale'
                  'MAIUSCOLO')
                TabOrder = 2
                OnClick = AAA_modified
              end
            end
          end
        end
        object page_formato_numero: TTabSheet
          Caption = 'numeri'
          ImageIndex = 1
          object panel_numeri: TFPanel
            Left = 0
            Top = 0
            Width = 577
            Height = 183
            Align = alTop
            Color = 13557503
            ParentBackground = False
            TabOrder = 0
            DesignSize = (
              577
              183)
            object txt_formato_numero: TMyLabel
              Left = 6
              Top = 133
              Width = 133
              Height = 16
              Caption = 'delimitatori numerici'
              FocusControl = cb_formato_numero
            end
            object cbx_progressivo: TCheckBox
              Left = 277
              Top = 108
              Width = 149
              Height = 17
              Caption = 'valore progressivo'
              TabOrder = 2
              OnClick = cbx_valutaClick
            end
            object cbx_show_segno: TCheckBox
              Left = 11
              Top = 157
              Width = 275
              Height = 17
              Caption = 'mostra segno anche per valori positivi'
              TabOrder = 4
              OnClick = cbx_valutaClick
            end
            object cb_nz: TCheckBox
              Left = 14
              Top = 109
              Width = 257
              Height = 17
              Caption = 'non stampare se il valore '#232' &ZERO'
              TabOrder = 1
              OnClick = AAA_modified
            end
            object cb_formato_numero: TFCombo
              Left = 141
              Top = 129
              Width = 292
              Height = 24
              Style = csDropDownList
              DropDownCount = 16
              TabOrder = 3
              OnClick = cb_formato_numeroClick
              Items.Strings = (
                'Nessun separatore per migliaia; punto per decimali'
                'Nessun separatore per migliaia; virgola per decimali'
                'Punti per le migliaia; virgola per decimali'
                'Virgola per le migliaia; punto per decimali')
              AAA_dropdownwidth = 0
              AAA_notify_modification = AAA_modified
              AAA_NeedNotifyModification = False
              AAA_CanBeVoid = False
              AAA_CanBeInvalid = False
            end
            object gbox_round_base: TGroupBox
              Left = 8
              Top = 0
              Width = 560
              Height = 107
              Anchors = [akLeft, akTop, akRight]
              Caption = 'arrotondamento'
              TabOrder = 0
              object rb_round: TRadioGroup
                Left = 8
                Top = 15
                Width = 165
                Height = 63
                Caption = 'arrotonda per'
                Items.Strings = (
                  'pr'
                  'ecc'
                  'dif')
                TabOrder = 0
                OnClick = AAA_modified
              end
              object gbox_stampa_almeno: TGroupBox
                Left = 189
                Top = 58
                Width = 365
                Height = 45
                Caption = 'stampa almeno'
                TabOrder = 2
                object txt_decimali_fissi: TLabel
                  Left = 9
                  Top = 20
                  Width = 55
                  Height = 16
                  Caption = 'decimali'
                  FocusControl = str_decimali_fissi
                end
                object txt_zeri: TLabel
                  Left = 196
                  Top = 21
                  Width = 28
                  Height = 16
                  Caption = 'cifre'
                  FocusControl = str_zeri
                end
                object str_decimali_fissi: TEdit
                  Left = 66
                  Top = 17
                  Width = 125
                  Height = 24
                  Hint = 
                    #232' possibile assegnare un NUMERO'#13#10'oppure una FORMULA (con variabi' +
                    'li)'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 0
                  OnChange = AAA_modified
                end
                object str_zeri: TEdit
                  Left = 227
                  Top = 17
                  Width = 125
                  Height = 24
                  Hint = 
                    'numero minimo di cifre alla sinistra della virgola'#13#10' '#13#10#232' possibi' +
                    'le assegnare un NUMERO'#13#10'oppure una FORMULA (con variabili)'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 1
                  OnChange = AAA_modified
                end
              end
              object gbox_round: TGroupBox
                Left = 189
                Top = 15
                Width = 365
                Height = 45
                Caption = 'cifre arrotondamento'
                TabOrder = 1
                object txt_round: TLabel
                  Left = 196
                  Top = 21
                  Width = 28
                  Height = 16
                  Caption = 'cifre'
                  FocusControl = str_round
                end
                object str_round: TEdit
                  Left = 227
                  Top = 17
                  Width = 125
                  Height = 24
                  Hint = 
                    'numero di cifre arrotondate'#13#10' '#13#10'0 significa arrotondare all'#39'unit' +
                    #224' '#13#10'2 significa 2 decimali'#13#10'3 significa 3 decimali'#13#10'-2 significa' +
                    ' arrotondare alle centinaia di unit'#224#13#10' '#13#10#232' possibile assegnare u' +
                    'n NUMERO'#13#10'oppure una FORMULA (con variabili)'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 1
                  OnChange = str_roundChange
                end
                object cb_round: TComboBox
                  Left = 9
                  Top = 17
                  Width = 168
                  Height = 24
                  Hint = 'Modalit'#224' di arrotondamento del risultato dei calcoli'
                  Style = csDropDownList
                  DropDownCount = 16
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 0
                  OnChange = cb_roundChange
                end
              end
            end
          end
          object panel_valuta: TFPanel
            Left = 0
            Top = 183
            Width = 577
            Height = 167
            Align = alTop
            Color = 14155735
            ParentBackground = False
            TabOrder = 1
            DesignSize = (
              577
              167)
            object txt_valuta: TLabel
              Left = 21
              Top = 9
              Width = 240
              Height = 16
              Alignment = taRightJustify
              Caption = 'usa il formato della valuta indicata in'
              FocusControl = cb_valuta
            end
            object gbox_round_valuta: TGroupBox
              Left = 8
              Top = 25
              Width = 563
              Height = 68
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
              object txt_valuta_message: TLabel
                Left = 2
                Top = 50
                Width = 559
                Height = 16
                Align = alBottom
                Alignment = taCenter
                Caption = 
                  'il formato effettivo viene assegnato in funzione dalla valuta ut' +
                  'ilizzata'
                Color = 14088184
                ParentColor = False
                Transparent = False
                ExplicitWidth = 449
              end
              object txt_round_valuta: TLabel
                Left = 10
                Top = 9
                Width = 146
                Height = 16
                Caption = 'tipo di arrotondamento'
                FocusControl = cb_round_valuta
              end
              object txt_round_valuta_min: TLabel
                Left = 208
                Top = 9
                Width = 184
                Height = 16
                Caption = 'n'#176' minimo decimali stampati'
                FocusControl = cb_round_valuta_min
              end
              object cb_round_valuta: TComboBox
                Left = 7
                Top = 24
                Width = 175
                Height = 24
                Hint = 'Modalit'#224' di arrotondamento del risultato dei calcoli'
                Style = csDropDownList
                DropDownCount = 16
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
                OnChange = AAA_modified
              end
              object cb_round_valuta_min: TComboBox
                Left = 207
                Top = 24
                Width = 175
                Height = 24
                Hint = 'Modalit'#224' di arrotondamento del risultato dei calcoli'
                Style = csDropDownList
                DropDownCount = 16
                ParentShowHint = False
                ShowHint = True
                TabOrder = 1
                OnChange = AAA_modified
              end
            end
            object cb_valuta: TFCombo
              Left = 266
              Top = 5
              Width = 303
              Height = 24
              Anchors = [akLeft, akTop, akRight]
              DropDownCount = 16
              Sorted = True
              TabOrder = 0
              OnChange = cb_valutaChange
              AAA_dropdownwidth = 240
              AAA_notify_modification = AAA_modified
              AAA_NeedNotifyModification = False
              AAA_CanBeVoid = True
              AAA_CanBeInvalid = True
            end
            object gb_valuta: TGroupBox
              Left = 8
              Top = 93
              Width = 563
              Height = 72
              Anchors = [akLeft, akTop, akRight]
              Caption = 'simbolo di valuta'
              TabOrder = 2
              object cbx_valuta: TCheckBox
                Left = 30
                Top = 17
                Width = 178
                Height = 17
                Caption = 'usa il simbolo di valuta'
                TabOrder = 0
                OnClick = cbx_valutaClick
              end
              object str_simbolo_valuta: TEdit
                Left = 212
                Top = 13
                Width = 40
                Height = 24
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -13
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 1
                OnChange = AAA_modified
              end
              object rb_posizione_simbolo_valuta: TRadioGroup
                Left = 12
                Top = 33
                Width = 159
                Height = 36
                Caption = 'posizione simbolo'
                Columns = 2
                ItemIndex = 0
                Items.Strings = (
                  'sinistra'
                  'destra')
                TabOrder = 2
                OnClick = AAA_modified
              end
              object btn_euro: TButton
                Left = 262
                Top = 15
                Width = 89
                Height = 21
                Caption = '^F12 euro '
                TabOrder = 3
                OnClick = btn_euroClick
              end
              object btn_lire: TButton
                Left = 357
                Top = 15
                Width = 53
                Height = 21
                Caption = 'lire'
                TabOrder = 4
                OnClick = btn_lireClick
              end
              object cbx_valuta_breve: TCheckBox
                Left = 238
                Top = 48
                Width = 151
                Height = 17
                Caption = 'simbolo abbreviato'
                TabOrder = 5
                OnClick = cbx_valutaClick
              end
            end
          end
        end
        object page_forza_font: TTabSheet
          Caption = 'speciale'
          ImageIndex = 3
          object panel_speciale: TFPanel
            Left = 0
            Top = 0
            Width = 577
            Height = 348
            Align = alClient
            Color = 15323903
            ParentBackground = False
            TabOrder = 0
            object gbox_forza_font: TGroupBox
              Left = 16
              Top = 40
              Width = 201
              Height = 65
              Hint = 
                'consente di forzare caratteristiche dei font anche quando gli st' +
                'essi fonts non le prevedono specificamente'
              Caption = 'forza applicazione di'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              object cbx_font_bold: TFCheckBox
                Left = 12
                Top = 20
                Width = 97
                Height = 17
                Caption = 'grassetto'
                Color = clBtnFace
                ParentColor = False
                TabOrder = 0
                AAA_notify_modification = AAA_modified
                AAA_NeedNotifyModification = False
              end
              object cbx_font_italic: TFCheckBox
                Left = 121
                Top = 20
                Width = 74
                Height = 17
                Caption = 'corsivo'
                Color = clBtnFace
                ParentColor = False
                TabOrder = 1
                AAA_notify_modification = AAA_modified
                AAA_NeedNotifyModification = False
              end
              object cbx_font_underlined: TFCheckBox
                Left = 12
                Top = 40
                Width = 99
                Height = 17
                Caption = 'sottolineato'
                Color = clBtnFace
                ParentColor = False
                TabOrder = 2
                Visible = False
                AAA_notify_modification = AAA_modified
                AAA_NeedNotifyModification = False
              end
              object cbx_font_strikeout: TFCheckBox
                Left = 121
                Top = 40
                Width = 74
                Height = 17
                Caption = 'barrato'
                Color = clBtnFace
                ParentColor = False
                TabOrder = 3
                Visible = False
                AAA_notify_modification = AAA_modified
                AAA_NeedNotifyModification = False
              end
            end
            object cbx_switch_fontstyle: TCheckBox
              Left = 19
              Top = 10
              Width = 230
              Height = 19
              Hint = 
                'Il font dell'#39'oggetto '#232' modificabile attraverso comandi contenuti' +
                ' nel testo'
              Caption = 'font modificabile via software'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = AAA_modified
            end
          end
        end
      end
    end
    object page_runtime: TTabSheet
      Caption = 'F7 runtime'
      Highlighted = True
      ImageIndex = 3
      object pc_runtime_options: TFPageControl
        Left = 0
        Top = 98
        Width = 585
        Height = 302
        ActivePage = runtime_base
        Align = alClient
        OwnerDraw = True
        TabOrder = 1
        AAA_AutoHighLight = False
        AAA_OpenOnFirstPage = True
        object runtime_base: TTabSheet
          Caption = 'opzioni base'
          DesignSize = (
            577
            271)
          object txt_runtime_blank_answer: TLabel
            Left = 23
            Top = 251
            Width = 164
            Height = 16
            Anchors = [akLeft, akBottom]
            Caption = 'testo della risposta blank'
            FocusControl = str_runtime_blank_answer
          end
          object rb_RTQ: TRadioGroup
            Left = 2
            Top = 169
            Width = 575
            Height = 38
            Hint = 
              'STANDARD = testo standard'#13#10'SINGLE SELECT = combobox'#13#10'MULTISELECT' +
              ' = '#232' possibile selezionare pi'#249' risposte contemporaneamente'
            Anchors = [akLeft, akRight, akBottom]
            Caption = 'modalit'#224' di presentazione della domanda'
            Columns = 3
            Items.Strings = (
              'standard'
              'combo (max 12)'
              'multiselect')
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnClick = enable_ctrls_Click
          end
          object cbx_runtime_answer_in_valori_suggeriti: TCheckBox
            Left = 15
            Top = 212
            Width = 314
            Height = 17
            Anchors = [akLeft, akBottom]
            Caption = 'la risposta deve essere tra i valori suggeriti'
            TabOrder = 4
            OnClick = enable_ctrls_Click
          end
          object cbx_runtime_answer_can_be_blank: TCheckBox
            Left = 15
            Top = 230
            Width = 216
            Height = 17
            Anchors = [akLeft, akBottom]
            Caption = 'la risposta pu'#242' essere blank'
            TabOrder = 5
            OnClick = enable_ctrls_Click
          end
          object str_runtime_blank_answer: TEdit
            Left = 193
            Top = 248
            Width = 385
            Height = 23
            Hint = 
              'in caso di risposta blank, la risposta stessa viene sostituita c' +
              'on il testo indicato'
            Anchors = [akLeft, akRight, akBottom]
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 7
            OnChange = AAA_modified
          end
          object cbx_RTQ_select_all_answers: TCheckBox
            Left = 238
            Top = 230
            Width = 194
            Height = 17
            Hint = 
              'tutte le risposte vengono selezionate per default'#13#10'impostazione ' +
              'applicabile solo a parametri '#39'MULTISELECT'#39
            Anchors = [akLeft, akBottom]
            Caption = 'seleziona tutte le risposte'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 6
            OnClick = enable_ctrls_Click
          end
          object cbx_SQL_load_runtime_values: TCheckBox
            Left = 12
            Top = -1
            Width = 314
            Height = 17
            Caption = 'Istruzione SQL per caricare i valori suggeriti'
            TabOrder = 0
            OnClick = enable_ctrls_Click
          end
          object panel_runtime_answers: TPanel
            Left = 6
            Top = 17
            Width = 578
            Height = 150
            Anchors = [akLeft, akTop, akRight, akBottom]
            BevelOuter = bvSpace
            TabOrder = 2
            OnResize = panel_runtime_answersResize
            object panel_runtime_answers_00: TPanel
              Left = 1
              Top = 1
              Width = 391
              Height = 148
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              object txt_runtime_answers: TLabel
                Left = 0
                Top = 0
                Width = 391
                Height = 16
                Align = alTop
                Caption = ' risposte suggerite'
                Color = clYellow
                FocusControl = str_runtime_answers
                ParentColor = False
                Transparent = False
                ExplicitWidth = 122
              end
              object str_runtime_answers: TMemo
                Left = 0
                Top = 16
                Width = 391
                Height = 132
                Align = alClient
                Color = 11599871
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                ScrollBars = ssBoth
                TabOrder = 0
                OnChange = AAA_modified
              end
            end
            object panel_runtime_answers_01: TPanel
              Left = 392
              Top = 1
              Width = 185
              Height = 148
              Align = alRight
              BevelOuter = bvNone
              TabOrder = 1
              object txt_runtime_values: TLabel
                Left = 0
                Top = 0
                Width = 185
                Height = 16
                Align = alTop
                Caption = ' codici di risposta'
                Color = clLime
                FocusControl = str_runtime_values
                ParentColor = False
                Transparent = False
                ExplicitWidth = 115
              end
              object str_runtime_values: TMemo
                Left = 0
                Top = 16
                Width = 185
                Height = 132
                Hint = 
                  'Inserire un codice per riga, senza APICI'#13#10'(che saranno eventualm' +
                  'ente aggiunti'#13#10'in base a quanto indicato nelle impostazioni avan' +
                  'zate)'#13#10' '#13#10'In assenza di CODICI DI RISPOSTA il programma'#13#10'utilizz' +
                  'a direttamente le risposte visualizzate'
                Align = alClient
                Color = 12713921
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
                ParentShowHint = False
                ScrollBars = ssBoth
                ShowHint = True
                TabOrder = 0
                OnChange = AAA_modified
              end
            end
          end
          object cbx_SQL_runtime_debug: TCheckBox
            Left = 339
            Top = -1
            Width = 101
            Height = 17
            Hint = 'carica sul gile di debug le istruzioni SQL'
            Caption = 'debug SQL'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = AAA_modified
          end
        end
        object page_runtime_avanzate: TTabSheet
          Caption = 'avanzate'
          ImageIndex = 1
          DesignSize = (
            577
            271)
          object txt_runtime_ask_if: TLabel
            Left = 17
            Top = 4
            Width = 145
            Height = 16
            Alignment = taRightJustify
            Caption = 'mostra domanda se ...'
            FocusControl = str_runtime_ask_if
          end
          object txt_colore_parametro: TLabel
            Left = 8
            Top = 62
            Width = 110
            Height = 16
            Alignment = taRightJustify
            Caption = 'colore parametro'
            FocusControl = panel_color
          end
          object txt_runtime_hint: TLabel
            Left = 3
            Top = 89
            Width = 87
            Height = 48
            Alignment = taRightJustify
            Caption = 'HINTS'#13#10'suggerimenti'#13#10'compilazione'
          end
          object txt_runtime_enable_if: TLabel
            Left = -1
            Top = 32
            Width = 163
            Height = 16
            Alignment = taRightJustify
            Caption = 'abilita compilazione se ..'
            FocusControl = str_runtime_enable_if
          end
          object txt_runtime_max_lines: TMyLabel
            Left = 338
            Top = 184
            Width = 65
            Height = 32
            Alignment = taRightJustify
            Anchors = [akLeft, akBottom]
            Caption = 'numero'#13#10'max righe'
            FocusControl = i_runtime_max_lines
          end
          object txt_runtime_max_length: TMyLabel
            Left = 26
            Top = 192
            Width = 136
            Height = 16
            Alignment = taRightJustify
            Anchors = [akLeft, akBottom]
            Caption = 'lunghezza max testo'
            FocusControl = i_runtime_max_length
          end
          object txt_runtime_parm_gbox: TMyLabel
            Left = 35
            Top = 221
            Width = 127
            Height = 16
            Alignment = taRightJustify
            Anchors = [akLeft, akBottom]
            Caption = 'gruppo di parametri'
            FocusControl = cb_runtime_parm_gbox
          end
          object txt_formato_multiselect: TMyLabel
            Left = 38
            Top = 249
            Width = 124
            Height = 16
            Alignment = taRightJustify
            Anchors = [akLeft, akBottom]
            Caption = 'formato multiselect'
            FocusControl = cb_formato_multiselect
          end
          object txt_runtime_min_length: TMyLabel
            Left = 221
            Top = 192
            Width = 60
            Height = 16
            Alignment = taRightJustify
            Anchors = [akLeft, akBottom]
            Caption = 'lung. min'
            FocusControl = i_runtime_min_length
          end
          object str_runtime_ask_if: TEdit
            Left = 167
            Top = 0
            Width = 413
            Height = 24
            Hint = 
              'la domanda sul parametro RUNTIME sar'#224' posta solo se la condizion' +
              'e indicata '#232' VERA'
            Anchors = [akLeft, akTop, akRight]
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnChange = AAA_modified
          end
          object panel_color: TPanel
            Left = 124
            Top = 58
            Width = 142
            Height = 24
            Hint = 'usa i bottoni TESTO e SFONDO'
            Caption = 'colore del parametro'
            Color = clSilver
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = panel_colorClick
          end
          object btn_text_color: TButton
            Left = 269
            Top = 59
            Width = 45
            Height = 23
            Caption = 'testo'
            TabOrder = 3
            OnClick = btn_text_colorClick
          end
          object btn_back_color: TButton
            Left = 319
            Top = 59
            Width = 51
            Height = 23
            Caption = 'sfondo'
            TabOrder = 4
            OnClick = btn_back_colorClick
          end
          object str_runtime_enable_if: TEdit
            Left = 167
            Top = 28
            Width = 413
            Height = 24
            Hint = 
              'l'#39'operatore potr'#224' compilare la risposta solo se la condizione in' +
              'dicata '#232' VERA'
            Anchors = [akLeft, akTop, akRight]
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnChange = AAA_modified
          end
          object i_runtime_max_lines: TFEdit
            Left = 406
            Top = 188
            Width = 29
            Height = 24
            Anchors = [akLeft, akBottom]
            MaxLength = 1
            TabOrder = 9
            Text = '0'
            AAA_tipodato = fe_integer
            AAA_notify_modification = AAA_modified
            AAA_NeedNotifyModification = False
            AAA_CanBeVoid = False
            AAA_ValueIfVoid = '0'
            AAA_CanBeInvalid = False
          end
          object i_runtime_max_length: TFEdit
            Left = 168
            Top = 188
            Width = 41
            Height = 24
            Anchors = [akLeft, akBottom]
            MaxLength = 3
            TabOrder = 7
            Text = '0'
            AAA_tipodato = fe_integer
            AAA_notify_modification = AAA_modified
            AAA_NeedNotifyModification = False
            AAA_CanBeVoid = False
            AAA_ValueIfVoid = '0'
            AAA_CanBeInvalid = False
          end
          object btn_default_color: TButton
            Left = 375
            Top = 59
            Width = 52
            Height = 23
            Caption = 'default'
            TabOrder = 5
            OnClick = btn_default_colorClick
          end
          object cb_runtime_parm_gbox: TFCombo
            Left = 168
            Top = 217
            Width = 414
            Height = 24
            Style = csDropDownList
            Anchors = [akLeft, akRight, akBottom]
            TabOrder = 10
            AAA_dropdownwidth = 0
            AAA_notify_modification = AAA_modified
            AAA_NeedNotifyModification = False
            AAA_CanBeVoid = False
            AAA_CanBeInvalid = True
          end
          object cb_formato_multiselect: TFCombo
            Left = 168
            Top = 245
            Width = 414
            Height = 24
            Style = csDropDownList
            Anchors = [akLeft, akRight, akBottom]
            ParentShowHint = False
            ShowHint = True
            TabOrder = 11
            AAA_dropdownwidth = 0
            AAA_notify_modification = AAA_modified
            AAA_NeedNotifyModification = False
            AAA_CanBeVoid = False
            AAA_CanBeInvalid = True
          end
          object i_runtime_min_length: TFEdit
            Left = 284
            Top = 188
            Width = 41
            Height = 24
            Anchors = [akLeft, akBottom]
            MaxLength = 3
            TabOrder = 8
            Text = '0'
            AAA_tipodato = fe_integer
            AAA_notify_modification = AAA_modified
            AAA_NeedNotifyModification = False
            AAA_CanBeVoid = False
            AAA_ValueIfVoid = '0'
            AAA_CanBeInvalid = False
          end
          object str_runtime_hint: TMemo
            Left = 97
            Top = 87
            Width = 481
            Height = 91
            Hint = 
              'i SUGGERIMENTI DI COMPILAZIONE'#13#10'vengono mostrati esattamente com' +
              'e la spiegazione che stai leggendo'
            Anchors = [akLeft, akTop, akRight, akBottom]
            Color = 12582911
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ScrollBars = ssVertical
            ShowHint = True
            TabOrder = 6
            OnChange = AAA_modified
          end
        end
        object page_runtime_formato: TTabSheet
          Caption = 'formato risposta'
          ImageIndex = 2
          object txt_runtime_formato: TLabel
            Left = 32
            Top = 96
            Width = 106
            Height = 16
            Caption = 'formato risposta'
            FocusControl = str_runtime_format
          end
          object txt_runtime_path: TLabel
            Left = 32
            Top = 168
            Width = 112
            Height = 16
            Caption = 'cartella di ricerca'
            FocusControl = str_runtime_path
          end
          object txt_runtime_filename_filter: TLabel
            Left = 76
            Top = 196
            Width = 68
            Height = 16
            Alignment = taRightJustify
            Caption = 'tipi di files'
            FocusControl = str_runtime_filename_filter
          end
          object str_runtime_format: TEdit
            Left = 31
            Top = 112
            Width = 148
            Height = 24
            Hint = 
              'formato del parametro: usare i seguenti simboli'#13#10'0 per indicare ' +
              'una cifra obbligatoria'#13#10'9 per indicare una cifra facoltativa'#13#10'A ' +
              'per indicare un carattere alfabetico'#13#10'X per indicare un caratter' +
              'e alfanumerico'#13#10' '#13#10'esempi:'#13#10'numero di 4 cifre (la prima cifra ob' +
              'bligatoria):  !0999'#13#10'formato data: 99/99/9999'#13#10'codice fiscale: A' +
              'AAAAA99A99A999A'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnChange = AAA_modified
          end
          object btn_help_mask_format: TFBitBtn
            Left = 191
            Top = 111
            Width = 77
            Height = 25
            Caption = 'formato'
            TabOrder = 3
            OnClick = btn_help_mask_formatClick
            Glyph.Data = {
              DE010000424DDE01000000000000760000002800000024000000120000000100
              0400000000006801000000000000000000001000000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333336633
              3333333333333FF3333333330000333333364463333333333333388F33333333
              00003333333E66433333333333338F38F3333333000033333333E66333333333
              33338FF8F3333333000033333333333333333333333338833333333300003333
              3333446333333333333333FF3333333300003333333666433333333333333888
              F333333300003333333E66433333333333338F38F333333300003333333E6664
              3333333333338F38F3333333000033333333E6664333333333338F338F333333
              0000333333333E6664333333333338F338F3333300003333344333E666433333
              333F338F338F3333000033336664333E664333333388F338F338F33300003333
              E66644466643333338F38FFF8338F333000033333E6666666663333338F33888
              3338F3330000333333EE666666333333338FF33333383333000033333333EEEE
              E333333333388FFFFF8333330000333333333333333333333333388888333333
              0000}
            NumGlyphs = 2
            Spacing = 2
            color_background_down = clBtnFace
            color_background_up = clBtnFace
            show_shortcut = False
          end
          object rb_runtime_tipodato: TRadioGroup
            Left = 31
            Top = 10
            Width = 148
            Height = 71
            Caption = 'tipo di dato'
            Items.Strings = (
              'stringa/numero'
              'data'
              'nome di file')
            TabOrder = 0
            OnClick = rb_runtime_tipodatoClick
          end
          object btn_formato_default: TFBitBtn
            Left = 191
            Top = 36
            Width = 177
            Height = 25
            Caption = 'assegna formato default'
            TabOrder = 1
            OnClick = btn_formato_defaultClick
            NumGlyphs = 2
            Spacing = 2
            color_background_down = clBtnFace
            color_background_up = clBtnFace
            show_shortcut = False
          end
          object str_runtime_path: TEdit
            Left = 148
            Top = 164
            Width = 225
            Height = 24
            Hint = 
              'cartella in cui avviene la ricerca del file'#13#10'supporta la sostitu' +
              'zione delle variabili di sistema (esempio: %PATH% )'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            OnChange = AAA_modified
          end
          object btn_browse_runtime_path: TButton
            Left = 378
            Top = 164
            Width = 23
            Height = 25
            Caption = '...'
            TabOrder = 5
            OnClick = btn_browse_runtime_pathClick
          end
          object str_runtime_filename_filter: TEdit
            Left = 148
            Top = 192
            Width = 225
            Height = 24
            Hint = 
              'tipi di files che devono essere ricercati'#13#10'separare con un punto' +
              'evirgola indicazioni multiple'#13#10' '#13#10'esempio: *.DBF;*.XLS;*.TXT'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 6
            OnChange = AAA_modified
          end
        end
        object page_runtime_script: TTabSheet
          Caption = 'scripts'
          ImageIndex = 3
          object panel_runtime_script: TFPanel
            Left = 0
            Top = 230
            Width = 577
            Height = 41
            Align = alBottom
            ParentBackground = False
            TabOrder = 1
            object btn_runtime_script_insert: TFBitBtn
              Left = 7
              Top = 10
              Width = 159
              Height = 25
              Caption = 'inserisci oggetto'
              TabOrder = 0
              OnClick = btn_runtime_script_insertClick
              Glyph.Data = {
                D6000000424DD60000000000000076000000280000000C0000000C0000000100
                0400000000006000000000000000000000001000000000000000000000000000
                80000080000000808000800000008000800080800000C0C0C000808080000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFF0000FFFF
                0000FFFF0AA0FFFF0000FFFF0AA0FFFF0000FFFF0AA0FFFF000000000AA00000
                00000AAAAAAAAAA000000AAAAAAAAAA0000000000AA000000000FFFF0AA0FFFF
                0000FFFF0AA0FFFF0000FFFF0AA0FFFF0000FFFF0000FFFF0000}
              color_background_down = clBtnFace
              color_background_up = clBtnFace
              show_shortcut = False
            end
          end
          object str_runtime_script: TFMemo
            Left = 0
            Top = 0
            Width = 577
            Height = 230
            Align = alClient
            Lines.Strings = (
              'str_runtime_script')
            ScrollBars = ssBoth
            TabOrder = 0
            AAA_notify_modification = AAA_modified
            AAA_NeedNotifyModification = False
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = True
          end
        end
      end
      object panel_runtime_question: TFPanel
        Left = 0
        Top = 0
        Width = 585
        Height = 98
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        DesignSize = (
          585
          98)
        object txt_runtime_question: TLabel
          Left = 10
          Top = 28
          Width = 132
          Height = 16
          Caption = 'testo della domanda'
          FocusControl = str_runtime_question
        end
        object txt_runtime_caption: TLabel
          Left = 15
          Top = 5
          Width = 132
          Height = 16
          Caption = 'titolo della domanda'
          FocusControl = str_runtime_caption
        end
        object str_runtime_question: TMemo
          Left = 6
          Top = 44
          Width = 579
          Height = 50
          Anchors = [akLeft, akTop, akRight, akBottom]
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 1
          OnChange = AAA_modified
        end
        object str_runtime_caption: TFEdit
          Left = 151
          Top = 1
          Width = 334
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          AAA_tipodato = fe_generico
          AAA_notify_modification = AAA_modified
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
      end
    end
    object page_expint: TTabSheet
      Caption = 'export'
      ImageIndex = 5
      object txt_expint_label: TLabel
        Left = 0
        Top = 0
        Width = 585
        Height = 16
        Align = alTop
        Alignment = taCenter
        Caption = 'impostazioni di exportazione per il profilo selezionato'
        Color = clYellow
        FocusControl = cb_export
        ParentColor = False
        Transparent = False
        ExplicitWidth = 351
      end
      object lb_expint_elenco: TMyListBox
        Left = 0
        Top = 16
        Width = 585
        Height = 259
        Align = alClient
        TabOrder = 0
        OnClick = lb_expint_elencoClick
        AAA_NeedNotifyModification = False
      end
      object panel_expint: TFPanel
        Left = 0
        Top = 275
        Width = 585
        Height = 125
        Align = alBottom
        ParentBackground = False
        TabOrder = 1
        DesignSize = (
          585
          125)
        object txt_export: TLabel
          Left = 7
          Top = 9
          Width = 63
          Height = 32
          Alignment = taRightJustify
          Caption = 'esporta'#13#10'il campo?'
          FocusControl = cb_export
        end
        object txt_export_pos: TMyLabel
          Left = 379
          Top = 17
          Width = 24
          Height = 16
          Anchors = [akTop, akRight]
          Caption = 'pos'
          FocusControl = i_export_pos
        end
        object txt_expint_header: TLabel
          Left = 8
          Top = 50
          Width = 151
          Height = 16
          Alignment = taRightJustify
          Caption = 'intestazione del campo'
          FocusControl = str_expint_header
        end
        object txt_expint_skip_cols_before: TMyLabel
          Left = 427
          Top = 51
          Width = 111
          Height = 16
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = 'blank cols before'
          FocusControl = i_expint_skip_cols_before
        end
        object txt_expint_acapo: TLabel
          Left = 146
          Top = 77
          Width = 119
          Height = 16
          Caption = 'traduci ACAPO con'
          FocusControl = cb_expint_acapo
        end
        object txt_expint_multiline: TLabel
          Left = 8
          Top = 77
          Width = 121
          Height = 16
          Alignment = taRightJustify
          Caption = 'se testo su + righe'
          FocusControl = cb_expint_multiline
        end
        object txt_expint_TAB: TLabel
          Left = 282
          Top = 77
          Width = 101
          Height = 16
          Caption = 'traduci TAB con'
          FocusControl = cb_expint_TAB
        end
        object cb_export: TFCombo
          Left = 75
          Top = 13
          Width = 290
          Height = 24
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 16
          TabOrder = 0
          OnChange = cb_exportChange
          AAA_dropdownwidth = 240
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = False
          AAA_CanBeInvalid = False
        end
        object i_export_pos: TFEdit
          Left = 406
          Top = 13
          Width = 37
          Height = 24
          Hint = 
            'la posizione della colonna che ospiter'#224' il valore del campo'#13#10'sar' +
            #224' determinata in base alla posizione qui indicata'#13#10' '#13#10'se il valo' +
            're viene lasciato a ZERO, la posizione della'#13#10'colonna viene dete' +
            'rminata automaticamente'
          Anchors = [akTop, akRight]
          MaxLength = 3
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Text = '0'
          AAA_tipodato = fe_integer
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = False
          AAA_CanBeInvalid = False
        end
        object str_expint_header: TEdit
          Left = 163
          Top = 46
          Width = 258
          Height = 24
          Hint = 'Intestazione della colonna'
          Anchors = [akLeft, akTop, akRight]
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
        end
        object i_expint_skip_cols_before: TFEdit
          Left = 541
          Top = 47
          Width = 37
          Height = 24
          Hint = 
            'aggiunge il numero specificato di colonne blank PRIMA del campo'#13 +
            #10'serve per allineare tra loro campi di sezioni differenti'
          Anchors = [akTop, akRight]
          MaxLength = 2
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          Text = '0'
          AAA_tipodato = fe_integer
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = False
          AAA_CanBeInvalid = False
        end
        object cb_expint_acapo: TFCombo
          Left = 143
          Top = 93
          Width = 129
          Height = 24
          Hint = 'indica come deve essere trattata la sequenza ACAPO (CR+LF)'
          DropDownCount = 16
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          OnChange = cb_exportChange
          AAA_dropdownwidth = 200
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object cb_expint_multiline: TFCombo
          Left = 8
          Top = 93
          Width = 122
          Height = 24
          Hint = 'modalit'#224' di trattamento del testo qualora vada su pi'#249' righe'
          Style = csDropDownList
          DropDownCount = 16
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnChange = cb_exportChange
          AAA_dropdownwidth = 200
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = False
        end
        object cb_expint_TAB: TFCombo
          Left = 279
          Top = 92
          Width = 129
          Height = 24
          Hint = 'indica come devono essere trattati i TABULATORI'
          DropDownCount = 16
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          OnChange = cb_exportChange
          AAA_dropdownwidth = 200
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object btn_help_export_integrale: TFBitBtn
          Left = 551
          Top = 91
          Width = 29
          Height = 25
          Anchors = [akTop, akRight]
          TabOrder = 7
          OnClick = btn_help_export_integraleClick
          Glyph.Data = {
            DE010000424DDE01000000000000760000002800000024000000120000000100
            0400000000006801000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333336633
            3333333333333FF3333333330000333333364463333333333333388F33333333
            00003333333E66433333333333338F38F3333333000033333333E66333333333
            33338FF8F3333333000033333333333333333333333338833333333300003333
            3333446333333333333333FF3333333300003333333666433333333333333888
            F333333300003333333E66433333333333338F38F333333300003333333E6664
            3333333333338F38F3333333000033333333E6664333333333338F338F333333
            0000333333333E6664333333333338F338F3333300003333344333E666433333
            333F338F338F3333000033336664333E664333333388F338F338F33300003333
            E66644466643333338F38FFF8338F333000033333E6666666663333338F33888
            3338F3330000333333EE666666333333338FF33333383333000033333333EEEE
            E333333333388FFFFF8333330000333333333333333333333333388888333333
            0000}
          NumGlyphs = 2
          color_background_down = clBtnFace
          color_background_up = clBtnFace
          show_shortcut = False
        end
      end
    end
    object page_store: TTabSheet
      Caption = 'store'
      ImageIndex = 4
      DesignSize = (
        585
        400)
      object txt_nome_variabile_store: TMyLabel
        Left = 12
        Top = 56
        Width = 97
        Height = 16
        Caption = 'nome variabile'
        FocusControl = str_nome_variabile_store
      end
      object txt_stoop: TLabel
        Left = 36
        Top = 113
        Width = 73
        Height = 16
        Caption = 'operazione'
        FocusControl = cb_stoop
      end
      object cbx_store_variabile: TFCheckBox
        Left = 24
        Top = 28
        Width = 313
        Height = 17
        Caption = 'assegna il valore dell'#39'oggetto alla variabile'
        TabOrder = 0
        OnClick = cbx_store_variabileClick
        AAA_notify_modification = AAA_modified
        AAA_NeedNotifyModification = False
      end
      object str_nome_variabile_store: TFEdit
        Left = 116
        Top = 52
        Width = 452
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        AAA_tipodato = fe_generico
        AAA_notify_modification = AAA_modified
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
      object cbx_nome_variabile_SQL: TFCheckBox
        Left = 48
        Top = 84
        Width = 357
        Height = 17
        Caption = 'comando SQL per generare nome variabile'
        TabOrder = 2
        AAA_notify_modification = AAA_modified
        AAA_NeedNotifyModification = False
      end
      object cb_stoop: TFCombo
        Left = 116
        Top = 109
        Width = 161
        Height = 24
        Style = csDropDownList
        TabOrder = 3
        AAA_dropdownwidth = 0
        AAA_notify_modification = AAA_modified
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = False
        AAA_CanBeInvalid = True
      end
    end
    object page_validazione: TTabSheet
      Caption = 'validazione'
      ImageIndex = 7
      DesignSize = (
        585
        400)
      object txt_validazione_formula: TLabel
        Left = 10
        Top = 112
        Width = 290
        Height = 16
        Caption = 'condizione di validazione (ok se soddisfatta)'
        FocusControl = str_validazione_formula
      end
      object txt_validazione_message: TLabel
        Left = 10
        Top = 378
        Width = 131
        Height = 16
        Alignment = taRightJustify
        Anchors = [akLeft, akBottom]
        Caption = 'messaggio di errore'
        FocusControl = str_validazione_message
      end
      object txt_validazione_descrizione_field: TLabel
        Left = 18
        Top = 351
        Width = 123
        Height = 16
        Alignment = taRightJustify
        Anchors = [akLeft, akBottom]
        Caption = 'descrizione campo'
        FocusControl = str_validazione_descrizione_field
      end
      object str_validazione_formula: TMemo
        Left = 6
        Top = 129
        Width = 572
        Height = 109
        Hint = 
          'viene generato un errore se la formula NON '#232' soddisfatta'#13#10' '#13#10'il ' +
          'campo contiene una FORMULA DI GALATEO'#13#10' '#13#10'ESEMPI'#13#10'cr_importo < 1' +
          '0000'#13#10'str_codice != "ABC"'#13#10'"$STR_CODICE" != "ABC"'
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = 12320767
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        MaxLength = 9999
        ParentFont = False
        ParentShowHint = False
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 5
        OnChange = AAA_modified
      end
      object rb_validazione: TFRadioGroup
        Left = 6
        Top = 22
        Width = 203
        Height = 85
        Hint = 
          'Specifica il tipo di controllo di validazione da eseguire.'#13#10' '#13#10'P' +
          'er BLANK si intende:'#13#10'- in caso di un campo di testo: un TESTO V' +
          'UOTO (lunghezza zero)'#13#10'- in caso di un campo numerico: il VALORE' +
          ' ZERO oppure un TESTO VUOTO'
        Caption = 'tipo validazione'
        Items.Strings = (
          '*'
          '*'
          '*')
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = rb_validazioneClick
        AAA_notify_modification = AAA_modified
        AAA_NeedNotifyModification = True
      end
      object cbx_attiva_validazione: TFCheckBox
        Left = 18
        Top = 3
        Width = 217
        Height = 17
        Hint = 'Attiva / disattiva il controllo di validazione per l'#39'oggetto'
        Caption = 'attiva controllo di validazione'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = cbx_attiva_validazioneClick
        AAA_notify_modification = AAA_modified
        AAA_NeedNotifyModification = True
      end
      object str_validazione_message: TEdit
        Left = 148
        Top = 374
        Width = 430
        Height = 24
        Hint = 
          'Messaggio che descrive la condizione di validazione violata.'#13#10' '#13 +
          #10'Questo messaggio '#232' una alternativa pi'#249' completa e personalizzab' +
          'ile'#13#10'alla semplice descrizione del campo che presenta il problem' +
          'a di validazione.'#13#10' '#13#10'Inserire direttamente nella casella il tes' +
          'to del messaggio'#13#10#232' possibile referenziare VARIABILI purch'#232' prec' +
          'edute dal simbolo del dollaro ($)'#13#10' '#13#10'ESEMPIO:'#13#10'valore non valid' +
          'o: $CR_IMPORTO'
        Anchors = [akLeft, akRight, akBottom]
        AutoSize = False
        Color = 13828050
        MaxLength = 9999
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        OnChange = str_validazione_descrizione_Change
        OnExit = str_validazione_descrizione_fieldExit
      end
      object gbox_validazione_blocca: TFGroupBox
        Left = 6
        Top = 243
        Width = 572
        Height = 100
        Anchors = [akLeft, akRight, akBottom]
        Color = 15852258
        ParentColor = False
        TabOrder = 6
        DesignSize = (
          572
          100)
        object txt_condizione_bloccante_aggiuntiva: TLabel
          Left = 218
          Top = 4
          Width = 71
          Height = 32
          Alignment = taRightJustify
          Caption = 'condizione'#13#10'aggiuntiva'
          FocusControl = str_condizione_bloccante_aggiuntiva
        end
        object gbox_validazione_contesto_blocco: TFGroupBox
          Left = 164
          Top = 36
          Width = 393
          Height = 57
          Anchors = [akLeft, akTop, akRight]
          Caption = 'contesto del blocco'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          object cbx_validazione_blocco_always: TFCheckBox
            Left = 12
            Top = 18
            Width = 69
            Height = 17
            Caption = 'TUTTI'
            Color = clBtnFace
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = cbx_validazione_blocco_Click
            AAA_notify_modification = AAA_modified
            AAA_NeedNotifyModification = True
          end
          object cbx_validazione_blocco_print: TFCheckBox
            Left = 268
            Top = 18
            Width = 114
            Height = 17
            Caption = 'stampa / PDF'
            Color = clBtnFace
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = cbx_validazione_blocco_Click
            AAA_notify_modification = AAA_modified
            AAA_NeedNotifyModification = True
          end
          object cbx_validazione_blocco_mail: TFCheckBox
            Left = 12
            Top = 36
            Width = 58
            Height = 17
            Caption = 'mail'
            Color = clBtnFace
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnClick = cbx_validazione_blocco_Click
            AAA_notify_modification = AAA_modified
            AAA_NeedNotifyModification = True
          end
          object cbx_validazione_blocco_FTP: TFCheckBox
            Left = 104
            Top = 36
            Width = 54
            Height = 17
            Caption = 'FTP'
            Color = clBtnFace
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            OnClick = cbx_validazione_blocco_Click
            AAA_notify_modification = AAA_modified
            AAA_NeedNotifyModification = True
          end
          object cbx_validazione_blocco_expint: TFCheckBox
            Left = 171
            Top = 36
            Width = 128
            Height = 17
            Caption = 'export integrale'
            Color = clBtnFace
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            OnClick = cbx_validazione_blocco_Click
            AAA_notify_modification = AAA_modified
            AAA_NeedNotifyModification = True
          end
          object cbx_validazione_blocco_XML: TFCheckBox
            Left = 316
            Top = 36
            Width = 60
            Height = 17
            Caption = 'XML'
            Color = clBtnFace
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 6
            OnClick = cbx_validazione_blocco_Click
            AAA_notify_modification = AAA_modified
            AAA_NeedNotifyModification = True
          end
          object cbx_validazione_blocco_elaborazione: TFCheckBox
            Left = 104
            Top = 18
            Width = 158
            Height = 17
            Caption = 'elaborazione report'
            Color = clBtnFace
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = cbx_validazione_blocco_Click
            AAA_notify_modification = AAA_modified
            AAA_NeedNotifyModification = True
          end
        end
        object str_condizione_bloccante_aggiuntiva: TEdit
          Left = 295
          Top = 8
          Width = 260
          Height = 24
          Hint = 
            'condizione (opzionale) che - se SODDISFATTA - rende l'#39'errore blo' +
            'ccante'#13#10' '#13#10'se la condizione NON '#232' specificata, l'#39'errore '#232' automa' +
            'ticamente bloccante'#13#10'se la condizione NON '#232' soddisfatta, l'#39'error' +
            'e viene gestito come se NON fosse bloccante'
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          MaxLength = 9999
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnChange = AAA_modified
        end
        object cbx_errore_bloccante: TFCheckBox
          Left = 12
          Top = 11
          Width = 188
          Height = 17
          Hint = 
            'Se viene attivato questo flag'#13#10'la mancata validazione viene cons' +
            'iderata ERRORE GRAVE'#13#10'e BLOCCA la prosecuzione dell'#39'elaborazione' +
            '.'#13#10' '#13#10'La condizione di blocco:'#13#10'- viene applicata esclusivamente' +
            ' ai CONTESTI specificati'#13#10'- '#232' subordinata al soddisfacimento del' +
            'la CONDIZIONE AGGIUNTIVA (se specificata)'
          Caption = 'blocca esecuzione report'
          Color = clBtnFace
          ParentColor = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = cbx_errore_bloccanteClick
          AAA_notify_modification = AAA_modified
          AAA_NeedNotifyModification = True
        end
        object gbox_contesto_anticipato_blocco: TFGroupBox
          Left = 8
          Top = 36
          Width = 137
          Height = 57
          Hint = 
            'il controllo di validazione viene eseguito esclusivamente nei co' +
            'ntesti specificati'
          Caption = 'controllo anticipato'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          object cbx_check_parms_blocco: TFCheckBox
            Tag = 1
            Left = 6
            Top = 18
            Width = 115
            Height = 17
            Caption = 'controllo parametri'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = cbx_validazione_contextClick
            AAA_notify_modification = AAA_modified
            AAA_NeedNotifyModification = True
          end
          object cbx_after_runtime_parms_blocco: TFCheckBox
            Tag = 1
            Left = 6
            Top = 36
            Width = 122
            Height = 17
            Caption = 'post runtime parms'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = cbx_validazione_contextClick
            AAA_notify_modification = AAA_modified
            AAA_NeedNotifyModification = True
          end
        end
      end
      object str_validazione_descrizione_field: TEdit
        Left = 148
        Top = 347
        Width = 430
        Height = 24
        Hint = 
          'Descrizione del campo coinvolto nel problema di validazione.'#13#10' '#13 +
          #10'Consente una referenziazione RAPIDA ed AUTOMATICA del problema ' +
          'di validazione.'#13#10'Viene usato in particolare con i controlli di v' +
          'alidazione che verificano '#13#10'la presenza o l'#39'assenza del valore n' +
          'el campo.'#13#10' '#13#10'Utilizzare la casella MESSAGGIO DI ERRORE per la c' +
          'omposizione di messaggi pi'#249' complessi, specifici e personalizzat' +
          'i.'
        Anchors = [akLeft, akRight, akBottom]
        AutoSize = False
        Color = 13828050
        MaxLength = 9999
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnChange = str_validazione_descrizione_Change
        OnExit = str_validazione_descrizione_fieldExit
      end
      object cbx_validate_pre_SQL: TFCheckBox
        Left = 262
        Top = 3
        Width = 161
        Height = 17
        Hint = 
          'La validazione viene eseguita PRIMA di eseguire le istruzioni SQ' +
          'L'#13#10'della sezione cui l'#39'oggetto appartiene'#13#10' '#13#10'Se il controllo '#232' ' +
          'impostato per BLOCCARE l'#39'esecuzione del report,'#13#10'il blocco viene' +
          ' eseguito IMMEDIATAMENTE (tramite ABORT)'
        Caption = 'validazione pre-SQL'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = cbx_attiva_validazioneClick
        AAA_notify_modification = AAA_modified
        AAA_NeedNotifyModification = True
      end
      object gbox_error_check_context: TFGroupBox
        Left = 360
        Top = 23
        Width = 218
        Height = 84
        Hint = 
          'il controllo di validazione viene eseguito esclusivamente nei co' +
          'ntesti specificati'
        Caption = 'controllo standard'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        object cbx_validazione_always: TFCheckBox
          Tag = 1
          Left = 7
          Top = 18
          Width = 54
          Height = 17
          Caption = 'TUTTI'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = cbx_validazione_contextClick
          AAA_notify_modification = AAA_modified
          AAA_NeedNotifyModification = True
        end
        object cbx_validazione_print: TFCheckBox
          Tag = 1
          Left = 7
          Top = 39
          Width = 98
          Height = 17
          Caption = 'stampa / PDF'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = cbx_validazione_contextClick
          AAA_notify_modification = AAA_modified
          AAA_NeedNotifyModification = True
        end
        object cbx_validazione_mail: TFCheckBox
          Tag = 1
          Left = 100
          Top = 39
          Width = 48
          Height = 17
          Caption = 'mail'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = cbx_validazione_contextClick
          AAA_notify_modification = AAA_modified
          AAA_NeedNotifyModification = True
        end
        object cbx_validazione_FTP: TFCheckBox
          Tag = 1
          Left = 152
          Top = 39
          Width = 49
          Height = 17
          Caption = 'FTP'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = cbx_validazione_contextClick
          AAA_notify_modification = AAA_modified
          AAA_NeedNotifyModification = True
        end
        object cbx_validazione_expint: TFCheckBox
          Tag = 1
          Left = 7
          Top = 60
          Width = 105
          Height = 17
          Caption = 'export integrale'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          OnClick = cbx_validazione_contextClick
          AAA_notify_modification = AAA_modified
          AAA_NeedNotifyModification = True
        end
        object cbx_validazione_XML: TFCheckBox
          Tag = 1
          Left = 128
          Top = 60
          Width = 54
          Height = 17
          Caption = 'XML'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          OnClick = cbx_validazione_contextClick
          AAA_notify_modification = AAA_modified
          AAA_NeedNotifyModification = True
        end
        object cbx_validazione_elaborazione: TFCheckBox
          Tag = 1
          Left = 71
          Top = 18
          Width = 123
          Height = 17
          Caption = 'elaborazione report'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = cbx_validazione_contextClick
          AAA_notify_modification = AAA_modified
          AAA_NeedNotifyModification = True
        end
      end
      object gbox_contesto_anticipato: TFGroupBox
        Left = 217
        Top = 23
        Width = 137
        Height = 84
        Hint = 
          'il controllo di validazione viene eseguito esclusivamente nei co' +
          'ntesti specificati'
        Caption = 'controllo anticipato'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        object cbx_check_parms: TFCheckBox
          Tag = 1
          Left = 6
          Top = 18
          Width = 115
          Height = 17
          Caption = 'controllo parametri'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = cbx_validazione_contextClick
          AAA_notify_modification = AAA_modified
          AAA_NeedNotifyModification = True
        end
        object cbx_after_runtime_parms: TFCheckBox
          Tag = 1
          Left = 6
          Top = 39
          Width = 122
          Height = 17
          Caption = 'post runtime parms'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = cbx_validazione_contextClick
          AAA_notify_modification = AAA_modified
          AAA_NeedNotifyModification = True
        end
      end
    end
    object page_default: TTabSheet
      Caption = 'default'
      ImageIndex = 6
      DesignSize = (
        585
        400)
      object txt_esempio: TLabel
        Left = 15
        Top = 355
        Width = 57
        Height = 32
        Anchors = [akLeft, akBottom]
        Caption = 'valore di'#13#10'esempio'
        FocusControl = str_esempio
      end
      object str_esempio: TEdit
        Left = 79
        Top = 359
        Width = 495
        Height = 24
        Hint = 'il valore di esempio '#232' utilizzato in fase di editing del report'
        Anchors = [akLeft, akRight, akBottom]
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnChange = AAA_modified
      end
      object gbox_default: TFGroupBox
        Left = 6
        Top = 12
        Width = 579
        Height = 333
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'valore DEFAULT'
        Color = 11468799
        ParentColor = False
        TabOrder = 0
        DesignSize = (
          579
          333)
        object txt_runtime_default: TLabel
          Left = 11
          Top = 77
          Width = 89
          Height = 16
          Caption = 'valore default'
          FocusControl = str_runtime_default
        end
        object txt_runtime_default_debug: TLabel
          Left = 11
          Top = 221
          Width = 292
          Height = 16
          Anchors = [akLeft, akBottom]
          Caption = 'valore default da utilizzare durante il DEBUG'
          FocusControl = str_runtime_default_debug
        end
        object str_runtime_default: TMemo
          Left = 10
          Top = 93
          Width = 556
          Height = 120
          Anchors = [akLeft, akTop, akRight, akBottom]
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 1
          OnChange = AAA_modified
        end
        object str_runtime_default_debug: TMemo
          Left = 10
          Top = 237
          Width = 556
          Height = 88
          Anchors = [akLeft, akRight, akBottom]
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 2
          OnChange = AAA_modified
        end
        object gbox_runtime_default_options: TFGroupBox
          Left = 28
          Top = 22
          Width = 297
          Height = 49
          Caption = 'il valore default '#232' ...'
          TabOrder = 0
          object cbx_parm_runtime_SQL: TCheckBox
            Left = 11
            Top = 22
            Width = 130
            Height = 17
            Hint = 
              'si tratta di una istruzione SQL che deve essere eseguita;'#13#10'pu'#242' c' +
              'ontenere il riferimento ad altri oggetti della stampa'
            Caption = 'espressione sql'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = AAA_modified
          end
          object cbx_parm_runtime_formula: TCheckBox
            Left = 150
            Top = 22
            Width = 141
            Height = 17
            Hint = 'si tratta di una formula, che deve essere interpretata'
            Caption = 'formula di galateo'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = AAA_modified
          end
        end
      end
    end
    object page_remarks: TTabSheet
      Caption = 'note'
      ImageIndex = 5
      object str_remarks: TFMemo
        Left = 0
        Top = 0
        Width = 585
        Height = 400
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 0
        AAA_notify_modification = AAA_modified
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
    end
  end
  object panel_top: TFPanel
    Left = 0
    Top = 0
    Width = 593
    Height = 29
    Align = alTop
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      593
      29)
    object txt_nome: TLabel
      Left = 4
      Top = 8
      Width = 57
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = 't&esto'
    end
    object str_text: TEdit
      Left = 66
      Top = 4
      Width = 423
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnChange = str_textChange
    end
    object btn_font: TButton
      Left = 500
      Top = 3
      Width = 89
      Height = 24
      Hint = 'Modifica il tipo e la dimensione del carattere dell'#39'oggetto'
      Anchors = [akTop, akRight]
      Caption = 'F8 ca&rattere'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btn_fontClick
    end
  end
  object panel_bottom: TFPanel
    Left = 0
    Top = 460
    Width = 593
    Height = 36
    Align = alBottom
    ParentBackground = False
    TabOrder = 2
    DesignSize = (
      593
      36)
    object txt_object: TLabel
      Left = 522
      Top = 10
      Width = 63
      Height = 16
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'txt_object'
    end
    object btn_legami: TButton
      Left = 355
      Top = 5
      Width = 133
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'Legami comunitari'
      TabOrder = 2
      OnClick = btn_legamiClick
    end
    object btn_ok: TFBitBtn
      Left = 11
      Top = 6
      Width = 78
      Height = 25
      Caption = 'F9 OK'
      Default = True
      TabOrder = 0
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
      Left = 100
      Top = 6
      Width = 81
      Height = 25
      Cancel = True
      Caption = 'Annulla'
      TabOrder = 1
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
    object btn_help: TFBitBtn
      Left = 496
      Top = 6
      Width = 29
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 3
      OnClick = btn_helpClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333336633
        3333333333333FF3333333330000333333364463333333333333388F33333333
        00003333333E66433333333333338F38F3333333000033333333E66333333333
        33338FF8F3333333000033333333333333333333333338833333333300003333
        3333446333333333333333FF3333333300003333333666433333333333333888
        F333333300003333333E66433333333333338F38F333333300003333333E6664
        3333333333338F38F3333333000033333333E6664333333333338F338F333333
        0000333333333E6664333333333338F338F3333300003333344333E666433333
        333F338F338F3333000033336664333E664333333388F338F338F33300003333
        E66644466643333338F38FFF8338F333000033333E6666666663333338F33888
        3338F3330000333333EE666666333333338FF33333383333000033333333EEEE
        E333333333388FFFFF8333330000333333333333333333333333388888333333
        0000}
      NumGlyphs = 2
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = False
    end
  end
  object Fontdlg: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    Device = fdPrinter
    Options = [fdEffects, fdForceFontExist, fdNoSimulations, fdWysiwyg]
    Left = 294
  end
end
