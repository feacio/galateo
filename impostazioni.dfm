object dlg_impostazioni: Tdlg_impostazioni
  Left = 578
  Top = 180
  HelpContext = 111
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Impostazioni: misure in cm'
  ClientHeight = 676
  ClientWidth = 843
  Color = clBtnFace
  Constraints.MinHeight = 485
  Constraints.MinWidth = 483
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  TextHeight = 16
  object printer_panel: TFPanel
    Left = 0
    Top = 0
    Width = 843
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      839
      61)
    object str_printer: TLabel
      Left = 0
      Top = 23
      Width = 847
      Height = 16
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = '*'
      ParentShowHint = False
      ShowHint = True
    end
    object str_page_descr: TLabel
      Left = 0
      Top = 43
      Width = 847
      Height = 16
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = '*'
    end
    object str_printer_base: TLabel
      Left = 0
      Top = 3
      Width = 841
      Height = 16
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Stampante default:'
      ParentShowHint = False
      ShowHint = True
    end
  end
  object pc: TPageControl
    Left = 0
    Top = 65
    Width = 843
    Height = 564
    ActivePage = page_SQL_scripts
    Align = alClient
    MultiLine = True
    TabOrder = 1
    object page_generale: TTabSheet
      Caption = 'generale'
      DesignSize = (
        835
        512)
      object txt_version: TLabel
        Left = 20
        Top = 2
        Width = 57
        Height = 16
        Caption = 'versione'
        Color = 8454143
        ParentColor = False
      end
      object txt_tiporeport: TMyLabel
        Left = 20
        Top = 20
        Width = 92
        Height = 16
        Caption = 'tipo di stampa'
        FocusControl = cb_tiporeport
      end
      object txt_pwd_edit: TMyLabel
        Left = 29
        Top = 84
        Width = 163
        Height = 16
        Caption = 'password accesso report'
        FocusControl = str_pwd_edit
      end
      object txt_pwd_exec: TMyLabel
        Left = 8
        Top = 114
        Width = 184
        Height = 16
        Caption = 'password esecuzione report'
        FocusControl = str_pwd_exec
      end
      object txt_message_opening_print: TMyLabel
        Left = 19
        Top = 145
        Width = 339
        Height = 16
        Alignment = taRightJustify
        Caption = 'emetti messaggio ad apertura report (in esecuzione)'
        FocusControl = str_message_opening_print
      end
      object txt_galateo_exe: TLabel
        Left = 304
        Top = 2
        Width = 56
        Height = 14
        Caption = 'galateo.exe'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object cbx_show_index: TCheckBox
        Left = 232
        Top = 46
        Width = 176
        Height = 23
        Caption = 'mostra indice all'#39'avvio'
        TabOrder = 2
      end
      object cbx_create_index: TCheckBox
        Left = 232
        Top = 27
        Width = 218
        Height = 23
        Caption = 'attiva gestione indice records'
        TabOrder = 1
        OnClick = cbx_create_indexClick
      end
      object cb_tiporeport: TFCombo
        Left = 16
        Top = 35
        Width = 184
        Height = 24
        Style = csDropDownList
        TabOrder = 0
        OnCloseUp = cb_tiporeport_exit_CloseUp
        OnExit = cb_tiporeport_exit_CloseUp
        AAA_dropdownwidth = 0
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = False
        AAA_CanBeInvalid = True
      end
      object str_pwd_edit: TFEdit
        Left = 200
        Top = 80
        Width = 189
        Height = 24
        Hint = 'password richiesta per aprire il report in GALATEO'
        ParentShowHint = False
        PasswordChar = '@'
        ShowHint = True
        TabOrder = 3
        AAA_tipodato = fe_generico
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
      object str_pwd_exec: TFEdit
        Left = 200
        Top = 110
        Width = 189
        Height = 24
        Hint = 
          'password richiesta per eseguire il report (cio'#232' eseguire la stam' +
          'pa)'
        ParentShowHint = False
        PasswordChar = '@'
        ShowHint = True
        TabOrder = 4
        AAA_tipodato = fe_generico
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
      object str_message_opening_print: TFMemo
        Left = 14
        Top = 162
        Width = 805
        Height = 180
        Hint = 'messaggio che viene emesso al momento dell'#39'esecuzione del report'
        Anchors = [akLeft, akTop, akRight, akBottom]
        ParentShowHint = False
        ScrollBars = ssBoth
        ShowHint = True
        TabOrder = 5
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
      object panel_log: TFPanel
        Left = 0
        Top = 345
        Width = 835
        Height = 167
        Align = alBottom
        ParentBackground = False
        TabOrder = 6
        object panel_debug_upper: TFPanel
          Left = 1
          Top = 1
          Width = 833
          Height = 50
          Align = alTop
          ParentBackground = False
          TabOrder = 0
          DesignSize = (
            833
            50)
          object txt_system_debug: TMyLabel
            Left = 658
            Top = 1
            Width = 145
            Height = 16
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            Caption = 'runtime system debug'
            FocusControl = cb_system_debug
          end
          object cb_system_debug: TFCombo
            Left = 656
            Top = 18
            Width = 167
            Height = 24
            Hint = 
              'il DEBUG a livello di REPORT (e in particolare il debug delle is' +
              'truzioni SQL) '#13#10'consente di tracciare le azioni che portano alla' +
              ' generazione del report, '#13#10'e di scovare perci'#242' eventuali problem' +
              'i legati allo specifico report'#13#10' '#13#10'il debug a livello di SISTEMA' +
              ' consente invece di tracciare specifici problemi di esecuzione d' +
              'el programma,'#13#10'con specifico riferimento alle fasi di inizializz' +
              'azione e finalizzazione delle varie UNITs'#13#10'il SYSTEM-DEBUG non s' +
              'erve all'#39'utente, ma al personale di assistenza tecnica'#13#10' '#13#10'il de' +
              'bug NON riguarda l'#39'esecuzione di GALATEO (in quanto EDITOR di re' +
              'ports)'#13#10'ma la libreria CASA.DLL quando l'#39'esecuzione del report v' +
              'iene lanciata direttamente da GALATEO'#13#10' '#13#10'l'#39'impostazione non '#232' l' +
              'egata al report, ma '#232' relativa al COMPUTER su cui si sta lavoran' +
              'do'
            Style = csDropDownList
            Anchors = [akTop, akRight]
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnChange = generic_enable_ctrls
            Items.Strings = (
              'nessun debug'
              'debug base'
              'debug dettagliato')
            AAA_dropdownwidth = 0
            AAA_NeedNotifyModification = False
            AAA_CanBeVoid = False
            AAA_CanBeInvalid = True
          end
          object gbox_debug_target: TFGroupBox
            Left = 6
            Top = 2
            Width = 219
            Height = 44
            Caption = 'destinazione debug'
            TabOrder = 1
            object rb_debug_target_file: TFRadio
              Left = 12
              Top = 20
              Width = 41
              Height = 17
              Caption = 'file'
              TabOrder = 0
              OnClick = generic_enable_ctrls
              AAA_NeedNotifyModification = False
            end
            object rb_debug_target_console: TFRadio
              Left = 58
              Top = 20
              Width = 77
              Height = 17
              Caption = 'console'
              TabOrder = 1
              OnClick = generic_enable_ctrls
              AAA_NeedNotifyModification = False
            end
            object rb_debug_target_all: TFRadio
              Left = 136
              Top = 20
              Width = 78
              Height = 17
              Caption = 'entrambi'
              TabOrder = 2
              OnClick = generic_enable_ctrls
              AAA_NeedNotifyModification = False
            end
          end
          object gbox_RDEBUG: TFGroupBox
            Left = 234
            Top = 2
            Width = 330
            Height = 44
            Caption = 'console debug'
            TabOrder = 2
            object rb_Rdebug_datacopy: TFRadio
              Left = 98
              Top = 20
              Width = 82
              Height = 17
              Caption = 'datacopy'
              TabOrder = 0
              AAA_NeedNotifyModification = False
            end
            object rb_Rdebug_pipes: TFRadio
              Left = 186
              Top = 20
              Width = 58
              Height = 17
              Caption = 'pipes'
              TabOrder = 1
              AAA_NeedNotifyModification = False
            end
            object rb_Rdebug_TCPIP: TFRadio
              Left = 250
              Top = 20
              Width = 67
              Height = 17
              Caption = 'TCP/IP'
              TabOrder = 2
              AAA_NeedNotifyModification = False
            end
            object rb_RDebug_blank: TFRadio
              Left = 10
              Top = 20
              Width = 82
              Height = 17
              Caption = '(nessuno)'
              TabOrder = 3
              AAA_NeedNotifyModification = False
            end
          end
        end
        object panel_debug_lower: TFPanel
          Left = 1
          Top = 51
          Width = 833
          Height = 115
          Align = alClient
          ParentBackground = False
          TabOrder = 1
          object FGroupBox2: TFGroupBox
            Left = 1
            Top = 1
            Width = 204
            Height = 113
            Align = alLeft
            Caption = 'informazioni di LOG'
            TabOrder = 0
            object cbx_log_registro_eventi: TCheckBox
              Left = 15
              Top = 24
              Width = 174
              Height = 17
              Hint = 
                'scrive gli eventi principali sul registro eventi'#13#10'questa imposta' +
                'zione NON riguarda le informazioni di debug'
              Caption = 'LOG su registro eventi'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = generic_enable_ctrls
            end
            object cbx_log_file: TCheckBox
              Left = 15
              Top = 44
              Width = 174
              Height = 17
              Caption = '**INATTIVO** LOG su file'
              TabOrder = 1
              Visible = False
              OnClick = generic_enable_ctrls
            end
          end
          object gbox_debug: TGroupBox
            Left = 205
            Top = 1
            Width = 627
            Height = 113
            Hint = 
              'il DEBUG a livello di REPORT (e in particolare il debug delle is' +
              'truzioni SQL) '#13#10'consente di tracciare le azioni che portano alla' +
              ' generazione del report, '#13#10'e di individuare perci'#242' eventuali pro' +
              'blemi legati allo specifico report'
            Align = alClient
            Caption = 'Informazioni di debug (report)'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            DesignSize = (
              627
              113)
            object txt_debug_computer: TLabel
              Left = 282
              Top = 13
              Width = 160
              Height = 16
              Caption = 'debug solo sul computer'
              FocusControl = str_debug_computer
            end
            object cbx_debug_base: TCheckBox
              Left = 135
              Top = 16
              Width = 107
              Height = 17
              Hint = 
                'registra tutte le istruzioni SQL utilizzate durante la generazio' +
                'ne del report'
              Caption = 'registra SQL'
              Color = clYellow
              ParentColor = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              OnClick = generic_enable_ctrls
            end
            object cbx_debug_full: TCheckBox
              Left = 135
              Top = 33
              Width = 108
              Height = 17
              Hint = 
                'registra tutti gli eventi'#13#10'(se non attivo, vengono registrati so' +
                'lo gli eventi principali)'
              Caption = 'registra tutto'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
              OnClick = bo_use_transactionClick
            end
            object str_debug_computer: TFEdit
              Left = 282
              Top = 31
              Width = 136
              Height = 24
              Hint = 
                'il debug (che pu'#242' rallentare l'#39'esecuzione o avere effetti collat' +
                'erali non graditi)'#13#10'viene eseguito solamente sul computer specif' +
                'icato'
              CharCase = ecUpperCase
              TabOrder = 5
              AAA_tipodato = fe_generico
              AAA_NeedNotifyModification = False
              AAA_CanBeVoid = True
              AAA_CanBeInvalid = True
            end
            object btn_debug_on_this_computer: TFBitBtn
              Left = 424
              Top = 32
              Width = 24
              Height = 25
              Hint = 'inserisce il nome del computer in uso'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 6
              OnClick = btn_debug_on_this_computerClick
              Glyph.Data = {
                F6000000424DF600000000000000760000002800000010000000100000000100
                0400000000008000000000000000000000001000000000000000000000000000
                80000080000000808000800000008000800080800000C0C0C000808080000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFF00FFF
                FFFFFFFFFF0000FFFFFFFFFFF003300FFFFFFFFF003BB300FFFFFFF003BBBB30
                0FFFFF00330BB03300FFF003B000000B300F00377B0000BBB3000037F70000BB
                B300F0037000000B300FFF003307B03300FFFFF0037F7B300FFFFFFF0037F300
                FFFFFFFFF003300FFFFFFFFFFF0000FFFFFFFFFFFFF00FFFFFFF}
              color_background_down = clBtnFace
              color_background_up = clBtnFace
              show_shortcut = False
            end
            object cbx_debug_delete_everytime: TCheckBox
              Left = 135
              Top = 50
              Width = 138
              Height = 17
              Hint = 'elimina il registro di debug prima di ogni stampa'
              Caption = 'elimina ogni volta'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 4
              OnClick = bo_use_transactionClick
            end
            object cbx_log_parametri: TCheckBox
              Left = 6
              Top = 16
              Width = 111
              Height = 17
              Hint = 
                'per ogni stampa eseguita scrive su un file di LOG il valore dei ' +
                'parametri che sono stati utilizzati per generarla'
              Caption = 'log parametri'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
            end
            object cbx_show_time_esecuzione: TCheckBox
              Left = 6
              Top = 33
              Width = 107
              Height = 17
              Hint = 'rileva il tempo di esecuzione della stampa'
              Caption = 'rileva tempo'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnClick = bo_use_transactionClick
            end
            object gbox_debug_runtime_message: TFGroupBox
              Left = 7
              Top = 66
              Width = 586
              Height = 46
              Anchors = [akLeft, akTop, akRight]
              Caption = 'messaggio a runtime se il report viene avviato in modalit'#224' DEBUG'
              TabOrder = 7
              DesignSize = (
                586
                46)
              object cbx_exclude_runtime_message_report: TCheckBox
                Left = 11
                Top = 21
                Width = 188
                Height = 17
                Hint = 
                  'esclude il messaggio di avvertimento a runtime'#13#10'per il PRESENTE ' +
                  'REPORT'
                Caption = 'escludi per questo report'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
                OnClick = bo_use_transactionClick
              end
              object cbx_exclude_runtime_message_computer: TCheckBox
                Left = 207
                Top = 21
                Width = 366
                Height = 17
                Hint = 
                  'esclude il messaggio di avvertimento a runtime'#13#10'per TUTTI I REPO' +
                  'RTS eseguiti sul PRESENTE COMPUTER'
                Anchors = [akLeft, akTop, akRight]
                Caption = 'escludi per questo computer'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 1
                OnClick = bo_use_transactionClick
              end
            end
          end
        end
      end
      object gbox_macro_tabs: TFGroupBox
        Left = 618
        Top = 19
        Width = 199
        Height = 53
        Caption = 'numero di linguette MACRO'
        TabOrder = 7
        DesignSize = (
          199
          53)
        object txt_macro_scripts: TLabel
          Left = 16
          Top = 25
          Width = 33
          Height = 16
          Caption = 'early'
          FocusControl = i_macro_scripts
        end
        object btn_applica_macro_scripts: TFBitBtn
          Left = 107
          Top = 16
          Width = 81
          Height = 30
          Anchors = [akTop, akRight]
          Caption = 'applica'
          TabOrder = 1
          OnClick = btn_applica_macro_scriptsClick
          Glyph.Data = {
            DE000000424DDE0000000000000076000000280000000B0000000D0000000100
            0400000000006800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00880888888880
            0000880088888880000088800888888000008880B0888880000088880B088880
            000088880BB088800000000000BB0880000080BBBBBBB0800000880BBB000000
            00008880BBB08880000088880BBB08800000888880BBB0800000888888000000
            0000}
          color_background_down = clBtnFace
          color_background_up = clBtnFace
          show_shortcut = False
        end
        object i_macro_scripts: TFEdit
          Left = 56
          Top = 21
          Width = 35
          Height = 24
          MaxLength = 2
          TabOrder = 0
          OnChange = i_macro_scriptsChange
          OnExit = i_macro_scriptsChange
          AAA_tipodato = fe_integer
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
      end
    end
    object page_opzioni: TTabSheet
      Caption = 'opzioni'
      ImageIndex = 11
      DesignSize = (
        835
        512)
      object txt_griglia: TLabel
        Left = 236
        Top = 82
        Width = 32
        Height = 16
        Caption = 'punti'
      end
      object txt_numero_copie_default: TLabel
        Left = 22
        Top = 12
        Width = 237
        Height = 16
        Caption = 'numero default di copie da stampare'
        FocusControl = i_numero_copie_default
      end
      object txt_GALRUN: TLabel
        Left = 345
        Top = 474
        Width = 110
        Height = 32
        Alignment = taRightJustify
        Caption = 'directory su cui'#13#10'trovare GAL RUN'
        FocusControl = str_galrun_path
      end
      object cbx_show_griglia: TCheckBox
        Left = 14
        Top = 56
        Width = 186
        Height = 21
        Caption = 'mostra &griglia (a video)'
        TabOrder = 2
      end
      object cbx_print_bordo: TCheckBox
        Left = 210
        Top = 56
        Width = 251
        Height = 21
        Caption = 'stampa &bordo etichetta (in stampa)'
        TabOrder = 3
      end
      object cbx_use_griglia: TCheckBox
        Left = 14
        Top = 80
        Width = 187
        Height = 21
        Caption = 'tabu&latori verticali testi a'
        TabOrder = 4
        OnClick = cbx_use_grigliaClick
      end
      object i_griglia: TEdit
        Left = 200
        Top = 78
        Width = 31
        Height = 24
        MaxLength = 2
        TabOrder = 5
      end
      object cbx_pagina_intera: TCheckBox
        Left = 14
        Top = 36
        Width = 289
        Height = 23
        Caption = 's&tampa effettiva solo a pagina completa'
        TabOrder = 1
      end
      object cbx_force_font_exist: TCheckBox
        Left = 14
        Top = 102
        Width = 398
        Height = 21
        Caption = 'usa solamente font realmente esistenti (non simula i font)'
        TabOrder = 7
        OnClick = cbx_use_grigliaClick
      end
      object cbx_compressed_bmp: TCheckBox
        Left = 310
        Top = 81
        Width = 150
        Height = 17
        Caption = 'comprimi immagini'
        TabOrder = 6
      end
      object cbx_new_metodo_scostamento: TCheckBox
        Left = 14
        Top = 122
        Width = 361
        Height = 21
        Hint = 
          'il valore GRIGIO indica che viene utilizzato il metodo default'#13#10 +
          ' '#13#10'modifica introdotta 2007-01-14 che migliora la valutazione'#13#10'd' +
          'egli scostamenti verticali concorrenti tra pi'#249' oggetti'
        AllowGrayed = True
        Caption = 'usa nuovo metodo valutazione scostamenti verticali'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        State = cbChecked
        TabOrder = 8
        OnClick = cbx_use_grigliaClick
      end
      object gbox_label_options: TFGroupBox
        Left = 10
        Top = 167
        Width = 481
        Height = 94
        Caption = 'opzioni stampa etichette'
        TabOrder = 11
        DesignSize = (
          481
          94)
        object txt_formato_label: TMyLabel
          Left = 26
          Top = 21
          Width = 108
          Height = 16
          Caption = 'formato etichetta'
          FocusControl = cb_formato_label
        end
        object txt_label_skip: TMyLabel
          Left = 13
          Top = 70
          Width = 139
          Height = 16
          Alignment = taRightJustify
          Caption = 'salta etichette iniziali'
          FocusControl = str_label_skip
        end
        object cbx_label_registra_ultima_posizione: TFCheckBox
          Left = 22
          Top = 45
          Width = 261
          Height = 17
          Caption = 'registra ultima posizione di stampa'
          TabOrder = 1
          AAA_NeedNotifyModification = False
        end
        object cb_formato_label: TFCombo
          Left = 139
          Top = 17
          Width = 189
          Height = 24
          Hint = 'codice descrittivo del formato di etichetta stampato'
          DropDownCount = 16
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Text = 'cb_formato_label'
          Items.Strings = (
            'A4 3x8'
            'A4 2x8'
            'A4 2x4')
          AAA_dropdownwidth = 0
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object str_label_skip: TFEdit
          Left = 157
          Top = 66
          Width = 287
          Height = 24
          Hint = 
            'sulla prima pagina salta il numero di etichette specificato'#13#10#232' p' +
            'ossibile utilizzare formule aritmetiche contenenti gli oggetti d' +
            'el report'
          Anchors = [akLeft, akTop, akRight]
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          Text = 'str_label_skip'
          AAA_tipodato = fe_generico
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object btn_label_skip_default: TFBitBtn
          Left = 449
          Top = 66
          Width = 21
          Height = 25
          Hint = 'assegnil valore default al campo'
          Anchors = [akTop, akRight]
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          TabStop = False
          OnClick = btn_label_skip_defaultClick
          Glyph.Data = {
            26050000424D260500000000000036040000280000000F0000000F0000000100
            080000000000F0000000C40E0000C40E00000001000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
            A6000020400000206000002080000020A0000020C0000020E000004000000040
            20000040400000406000004080000040A0000040C0000040E000006000000060
            20000060400000606000006080000060A0000060C0000060E000008000000080
            20000080400000806000008080000080A0000080C0000080E00000A0000000A0
            200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
            200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
            200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
            20004000400040006000400080004000A0004000C0004000E000402000004020
            20004020400040206000402080004020A0004020C0004020E000404000004040
            20004040400040406000404080004040A0004040C0004040E000406000004060
            20004060400040606000406080004060A0004060C0004060E000408000004080
            20004080400040806000408080004080A0004080C0004080E00040A0000040A0
            200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
            200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
            200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
            20008000400080006000800080008000A0008000C0008000E000802000008020
            20008020400080206000802080008020A0008020C0008020E000804000008040
            20008040400080406000804080008040A0008040C0008040E000806000008060
            20008060400080606000806080008060A0008060C0008060E000808000008080
            20008080400080806000808080008080A0008080C0008080E00080A0000080A0
            200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
            200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
            200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
            2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
            2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
            2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
            2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
            2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
            2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
            2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFF00FF91999191919199909191919951FF00FF99989090D9
            9090D991D9909099FF00FF9990919991FFFFD89090FFFF99FF00FF99909191FF
            FF909890FFFF9191FF00F6919091FFFF999990FFFF919188FF00FFDA91FFFF91
            9191FFFF9190919AFF00FF91FFFF999991FFFF9991999090FF00FF9199FFFF91
            9191FFFF91909191FF00FF99D090FFFF91D1D909FF919199FF00FF90D99191FF
            FFD0D099FFFF9150FF00FF999090919AFFFFD99191FFFF91FF00F69990999191
            9191919191999951FF00FF5099919191919192919A915152FF00F6FFFFFFFFFF
            FFFFFFFFFFFFFFFFFF00}
          color_background_down = clBtnFace
          color_background_up = clBtnFace
          show_shortcut = False
        end
      end
      object gbox_lingua: TFGroupBox
        Left = 10
        Top = 261
        Width = 481
        Height = 66
        Caption = 'opzioni lingua (traduzione automatica)'
        TabOrder = 12
        object txt_lingua: TMyLabel
          Left = 12
          Top = 19
          Width = 40
          Height = 16
          Caption = 'lingua'
          FocusControl = cb_lingua_object
        end
        object txt_lingua_contesto: TMyLabel
          Left = 228
          Top = 19
          Width = 126
          Height = 16
          Alignment = taRightJustify
          Caption = 'contesto linguistico'
          FocusControl = cb_lingua_contesto
        end
        object cb_lingua_object: TFCombo
          Left = 12
          Top = 35
          Width = 207
          Height = 24
          Hint = 
            'selezionare l'#39'oggetto contenente il codice della lingua da appli' +
            'care al report'
          Style = csDropDownList
          DropDownCount = 16
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnCloseUp = cb_tiporeport_exit_CloseUp
          OnExit = cb_tiporeport_exit_CloseUp
          AAA_dropdownwidth = 0
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = False
          AAA_CanBeInvalid = True
        end
        object cb_lingua_contesto: TFCombo
          Left = 228
          Top = 35
          Width = 195
          Height = 24
          Hint = 
            'consente di considerare i soli elementi linguistici che apparten' +
            'gono al contesto specificato'#13#10'in sostanza si tratta di UN FILTRO' +
            ' per gli elementi linguistici'
          Style = csDropDownList
          DropDownCount = 16
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnCloseUp = cb_tiporeport_exit_CloseUp
          OnExit = cb_tiporeport_exit_CloseUp
          AAA_dropdownwidth = 0
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
      end
      object i_numero_copie_default: TEdit
        Left = 265
        Top = 8
        Width = 38
        Height = 24
        MaxLength = 2
        TabOrder = 0
      end
      object panel_hidden_objects_color: TFPanel
        Left = 480
        Top = 10
        Width = 338
        Height = 41
        Cursor = crHandPoint
        Hint = 'modifica il colore degli oggetti di testo nascosti'
        Caption = 'colore degli oggetti nascosti'
        Color = clWhite
        ParentBackground = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        OnClick = panel_hidden_objects_colorClick
      end
      object gbox_null_values: TFGroupBox
        Left = 10
        Top = 331
        Width = 481
        Height = 101
        Caption = 'comportamento DEFAULT per valori SQL NULL'
        TabOrder = 14
        object txt_comportamento_null: TMyLabel
          Left = 29
          Top = 27
          Width = 177
          Height = 16
          BiDiMode = bdLeftToRight
          Caption = 'comportamento STANDARD'
          FocusControl = cb_comportamento_null
          ParentBiDiMode = False
        end
        object txt_value_when_null_text: TMyLabel
          Left = 27
          Top = 50
          Width = 147
          Height = 16
          Alignment = taRightJustify
          Caption = 'testo default per TESTI'
          FocusControl = cb_value_when_null_text
        end
        object txt_value_when_null_numeric: TMyLabel
          Left = 220
          Top = 50
          Width = 164
          Height = 16
          Alignment = taRightJustify
          Caption = 'testo default per NUMERI'
          FocusControl = cb_value_when_null_numeric
        end
        object cb_comportamento_null: TFCombo
          Left = 212
          Top = 22
          Width = 181
          Height = 24
          Hint = 
            'Definisce il comportamento DEFAULT da utilizzare'#13#10'con i campi va' +
            'lorizzati a NULL.'#13#10' '#13#10'E'#39' possibile personalizzare il comportamen' +
            'to su ogni oggetto.'#13#10' '#13#10'Il comportamento STANDARD '#232' il seguente:' +
            #13#10'- NUMERI: valore "0" (zero)'#13#10'- STRINGHE: nessun valore (string' +
            'a vuota)'#13#10' '#13#10'ATTENZIONE'#13#10'questa opzione NON cambia il valore del' +
            'l'#39'oggetto, ma ne modifica solamente la visualizzazione'#13#10'per ques' +
            'to motivo il valore del campo, ove referenziato in una FORMULA, ' +
            #13#10'resta pari al valore STANDARD (come sopra specificato)'#13#10' '#13#10'Per' +
            ' modificare realmente il valore di un campo, '#13#10'e non solo la sua' +
            ' visualizzazione,'#13#10#232' necessario intervenire a livello della quer' +
            'y SQL'
          Style = csDropDownList
          DropDownCount = 16
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnCloseUp = cb_tiporeport_exit_CloseUp
          OnExit = cb_tiporeport_exit_CloseUp
          AAA_dropdownwidth = 0
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = False
          AAA_CanBeInvalid = True
        end
        object cb_value_when_null_text: TFCombo
          Left = 24
          Top = 67
          Width = 181
          Height = 24
          Hint = 'testo default da sostituire agli oggetti NULL di tipo TESTO'
          DropDownCount = 16
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnCloseUp = cb_tiporeport_exit_CloseUp
          OnExit = cb_tiporeport_exit_CloseUp
          AAA_dropdownwidth = 0
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = False
          AAA_CanBeInvalid = True
        end
        object cb_value_when_null_numeric: TFCombo
          Left = 220
          Top = 67
          Width = 181
          Height = 24
          Hint = 'testo default da sostituire agli oggetti NULL di tipo NUMERICO'
          DropDownCount = 16
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnCloseUp = cb_tiporeport_exit_CloseUp
          OnExit = cb_tiporeport_exit_CloseUp
          AAA_dropdownwidth = 0
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = False
          AAA_CanBeInvalid = True
        end
        object btn_help_SQL_null_values: TFBitBtn
          Left = 427
          Top = 14
          Width = 43
          Height = 38
          TabOrder = 3
          TabStop = False
          OnClick = btn_help_SQL_null_valuesClick
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
      object gbox_formato_datetime: TFGroupBox
        Left = 480
        Top = 62
        Width = 338
        Height = 54
        Caption = 'formato data / ora'
        TabOrder = 10
        object txt_datetime_format: TLabel
          Left = 11
          Top = 25
          Width = 28
          Height = 16
          Alignment = taRightJustify
          Caption = 'data'
          FocusControl = str_date_format
        end
        object txt_time_formats: TLabel
          Left = 172
          Top = 25
          Width = 21
          Height = 16
          Alignment = taRightJustify
          Caption = 'ora'
          FocusControl = str_time_format
        end
        object str_date_format: TEdit
          Left = 43
          Top = 21
          Width = 112
          Height = 24
          Hint = 'formato default per il formato delle date'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
        object str_time_format: TEdit
          Left = 197
          Top = 21
          Width = 112
          Height = 24
          Hint = 'formato default per il formato dei valori ORA'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
        end
        object btn_help_datetime_format: TFBitBtn
          Left = 310
          Top = 20
          Width = 21
          Height = 25
          TabOrder = 2
          TabStop = False
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
      end
      object btn_shell_extensions: TFBitBtn
        Left = 12
        Top = 471
        Width = 305
        Height = 39
        Hint = 
          'Ripristina e riconfigura i collegamenti tra il programma e Gesti' +
          'one Risorse'
        Caption = 'Reimposta collegamento con Explorer'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 15
        OnClick = btn_shell_extensionsClick
        Glyph.Data = {
          36080000424D3608000000000000360400002800000020000000200000000100
          0800000000000004000000000000000000000001000000010000000000004000
          000080000000FF000000002000004020000080200000FF200000004000004040
          000080400000FF400000006000004060000080600000FF600000008000004080
          000080800000FF80000000A0000040A0000080A00000FFA0000000C0000040C0
          000080C00000FFC0000000FF000040FF000080FF0000FFFF0000000020004000
          200080002000FF002000002020004020200080202000FF202000004020004040
          200080402000FF402000006020004060200080602000FF602000008020004080
          200080802000FF80200000A0200040A0200080A02000FFA0200000C0200040C0
          200080C02000FFC0200000FF200040FF200080FF2000FFFF2000000040004000
          400080004000FF004000002040004020400080204000FF204000004040004040
          400080404000FF404000006040004060400080604000FF604000008040004080
          400080804000FF80400000A0400040A0400080A04000FFA0400000C0400040C0
          400080C04000FFC0400000FF400040FF400080FF4000FFFF4000000060004000
          600080006000FF006000002060004020600080206000FF206000004060004040
          600080406000FF406000006060004060600080606000FF606000008060004080
          600080806000FF80600000A0600040A0600080A06000FFA0600000C0600040C0
          600080C06000FFC0600000FF600040FF600080FF6000FFFF6000000080004000
          800080008000FF008000002080004020800080208000FF208000004080004040
          800080408000FF408000006080004060800080608000FF608000008080004080
          800080808000FF80800000A0800040A0800080A08000FFA0800000C0800040C0
          800080C08000FFC0800000FF800040FF800080FF8000FFFF80000000A0004000
          A0008000A000FF00A0000020A0004020A0008020A000FF20A0000040A0004040
          A0008040A000FF40A0000060A0004060A0008060A000FF60A0000080A0004080
          A0008080A000FF80A00000A0A00040A0A00080A0A000FFA0A00000C0A00040C0
          A00080C0A000FFC0A00000FFA00040FFA00080FFA000FFFFA0000000C0004000
          C0008000C000FF00C0000020C0004020C0008020C000FF20C0000040C0004040
          C0008040C000FF40C0000060C0004060C0008060C000FF60C0000080C0004080
          C0008080C000FF80C00000A0C00040A0C00080A0C000FFA0C00000C0C00040C0
          C00080C0C000FFC0C00000FFC00040FFC00080FFC000FFFFC0000000FF004000
          FF008000FF00FF00FF000020FF004020FF008020FF00FF20FF000040FF004040
          FF008040FF00FF40FF000060FF004060FF008060FF00FF60FF000080FF004080
          FF008080FF00FF80FF0000A0FF0040A0FF0080A0FF00FFA0FF0000C0FF0040C0
          FF0080C0FF00FFC0FF0000FFFF0040FFFF0080FFFF00FFFFFF00FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF01031F0300FFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF01031F1F0300FFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF01031F1F030300FFFFFFFFFF2424242424
          242424242424242424242424000001031F1F03032424242424FF90D9D9D9D9D9
          D9D9D9D9D9D9D9D9D9D9D9D99001031F1F030324D9D9D9D9D92490FFFAFEFAFE
          FAFEFEFAFEFAFEFEFEFAFEFA01031F1F030300FAFAFAFEFAD92490FFFEFEFEFA
          FEFAFEFEFAFEFEFAFAFEFA01031F1F030300FAFEFAFAFAFAD92490FFFAFEFEFE
          FEFEFAFEFEFAFAFEFEFA92031F1F030300FAFAFAFAFAFAFAD92490FFFEFEFAFE
          FAFEFEFAFAFAFAFAFA92B6FF1F030300FAFAFEFAFEFEFAFAD92490FFFEFEFEFE
          FEFAFA000000000092B6FFB6920300FAFEFEFAFAFAFAFEFAD92490FFFEFAFEFE
          FA00000D0D0D0D0D0000B6929200FAFAFAFAFAFEFAFAFAFAD92490FFFEFEFEFA
          920DB61FB61FB61F0D0D009200FAFAFEFAFAFEFAFAFEFAFED92490FFFEFEFA92
          0DB61FB61FB61FB61F0D0D006CFEFEFAFEFEFAFEFEFAFAFAD92490FFFEFEFA92
          B61FFF1FB61FB61FB61F0D0092FAFAFEFAFAFEFAFAFAFEFAD92490FFFEFE92B6
          1FFF1FB61FB61FB61FB61F0D0092FEFEFEFEFAFEFEFAFAFED92490FFFEFE921F
          FF1FFF1FB61FB61FB61FB60D006CFAFEFAFEFEFAFAFEFEFAD92490FFFEFE92B6
          1FFFFFB61FB61FB61FB61F0D0092FEFAFEFEFAFEFEFEFAFED92490FFFEFE921F
          FF1FFFFFB61FB61FB61FB60D006CFEFEFEFAFEFEFAFAFEFAD92490FFFEFE92B6
          1FFFFFFF1FB61FB61FB61F0D0092FAFEFAFEFAFEFEFEFAFED92490FFFEFEFA92
          FF1FFFFFFF1FB61FB61FB6006CFAFEFEFEFEFEFAFEFAFEFAD92490FFFEFEFA92
          B6FF1FFF1FFF1FB61FB60D006CFEFAFEFEFEFAFEFEFEFEFAD92490FFFEFEFEFA
          92B6FF1FFF1FFF1FB60D0092FEFEFEFEFAFEFEFAFAFEFEFED92490FFFEFEFEFE
          FA9292B61FB61F92000092FAFEFAFEFEFEFAFEFEFEFAFEFAD92490FFFEFEFEFE
          FEFAFA92929292006C6CFEFEFEFEFEFAFEFEFAFEFEFEFAFED9FF90FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FF90D9D9D9D9D9
          D9D9D9D9D9D9D9D9D9D99090909090909090909090909090FFFFFF90FFFEFEFE
          FEFEFEFEFEFEFEFEFE90FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF90FFFEFE
          FEFEFEFEFEFEFEFE90FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF90FFFE
          FEFEFEFEFEFEFE90FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9090
          90909090909090FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        color_background_down = clBtnFace
        color_background_up = clBtnFace
        show_shortcut = False
      end
      object str_galrun_path: TEdit
        Left = 460
        Top = 478
        Width = 346
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 16
      end
      object btn_galrun: TFBitBtn
        Left = 810
        Top = 479
        Width = 18
        Height = 23
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 17
        TabStop = False
        OnClick = btn_galrunClick
        color_background_down = clBtnFace
        color_background_up = clBtnFace
        show_shortcut = False
      end
      object gbox_pausa_pagina: TFGroupBox
        Left = 500
        Top = 167
        Width = 320
        Height = 160
        Caption = 'pausa ad ogni pagina stampata'
        TabOrder = 13
        DesignSize = (
          320
          160)
        object txt_pausa_pagina_message: TMyLabel
          Left = 19
          Top = 93
          Width = 222
          Height = 16
          Alignment = taRightJustify
          Caption = 'messaggio di interruzione stampa'
          FocusControl = str_pausa_pagina_message
        end
        object txt_pausa_pagina_durata_msec: TLabel
          Left = 35
          Top = 65
          Width = 96
          Height = 16
          Caption = 'durata in msec'
        end
        object cbx_pausa_pagina: TCheckBox
          Left = 18
          Top = 30
          Width = 267
          Height = 21
          Caption = 'pausa dopo la stampa di ogni pagina'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = cbx_pausa_paginaClick
        end
        object str_pausa_pagina_message: TFEdit
          Left = 20
          Top = 111
          Width = 281
          Height = 24
          Hint = 
            'messaggio emesso durante la pausa di stampa'#13#10' '#13#10'dovrebbe essere ' +
            'qualcosa del tipo'#13#10'BATTI OK PER CONTINUARE LA STAMPA'#13#10' '#13#10'lasciar' +
            'e VUOTO se non si ha nulla di particolare da dire'
          Anchors = [akLeft, akTop, akRight]
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          AAA_tipodato = fe_generico
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object i_pausa_pagina_durata_msec: TFEdit
          Left = 139
          Top = 61
          Width = 67
          Height = 24
          Hint = 
            'durata della pausa, in MILLISECONDI'#13#10'assgnando il valore 0, il p' +
            'rogramma attende conferma dall'#39'utente prima di procedere'
          TabOrder = 1
          AAA_tipodato = fe_integer
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = False
        end
      end
    end
    object tab_misure: TTabSheet
      Caption = '&misure'
      object txt_lab_per_row: TLabel
        Left = 10
        Top = 40
        Width = 121
        Height = 32
        Alignment = taRightJustify
        Caption = 'N'#176' etichette per'#13#10'pagina (larghezza)'
        FocusControl = i_lab_per_row
      end
      object txt_lab_per_page: TLabel
        Left = 198
        Top = 40
        Width = 104
        Height = 32
        Alignment = taRightJustify
        Caption = 'N'#176' &etichette per'#13#10'pagina (altezza)'
        FocusControl = i_lab_per_page
      end
      object txt_delta_x: TLabel
        Left = 1
        Top = 11
        Width = 165
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        Caption = 's&pazio orizz. tra etichette'
        FocusControl = r_delta_x
      end
      object txt_delta_y: TLabel
        Left = 227
        Top = 10
        Width = 182
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'sp&azio vert. tra etichette'
        FocusControl = r_delta_y
      end
      object i_lab_per_row: TEdit
        Left = 138
        Top = 44
        Width = 47
        Height = 24
        TabOrder = 2
      end
      object i_lab_per_page: TEdit
        Left = 306
        Top = 44
        Width = 47
        Height = 24
        TabOrder = 3
      end
      object r_delta_x: TEdit
        Left = 174
        Top = 7
        Width = 47
        Height = 24
        TabOrder = 0
      end
      object r_delta_y: TEdit
        Left = 413
        Top = 6
        Width = 47
        Height = 24
        TabOrder = 1
      end
      object video_setup: TButton
        Left = 259
        Top = 78
        Width = 128
        Height = 27
        Caption = 'imposta vi&deo'
        Enabled = False
        TabOrder = 5
        OnClick = video_setupClick
      end
      object btn_formato_pagina: TButton
        Left = 78
        Top = 78
        Width = 169
        Height = 27
        Caption = 'Formato Pagina'
        TabOrder = 4
        OnClick = btn_headerClick
      end
      object gbox_phisical_size: TGroupBox
        Left = 6
        Top = 115
        Width = 448
        Height = 45
        TabOrder = 7
        object txt_phisical_page_width: TLabel
          Left = 10
          Top = 19
          Width = 164
          Height = 16
          Alignment = taRightJustify
          Caption = 'larghezza (decimi di mm)'
          FocusControl = i_phisical_page_width
        end
        object txt_phisical_page_height: TLabel
          Left = 243
          Top = 19
          Width = 147
          Height = 16
          Alignment = taRightJustify
          Caption = 'altezza (decimi di mm)'
          FocusControl = i_phisical_page_height
        end
        object i_phisical_page_height: TEdit
          Left = 394
          Top = 15
          Width = 47
          Height = 24
          TabOrder = 1
        end
        object i_phisical_page_width: TEdit
          Left = 178
          Top = 15
          Width = 47
          Height = 24
          TabOrder = 0
        end
      end
      object cbx_phisical_size: TCheckBox
        Left = 19
        Top = 108
        Width = 326
        Height = 17
        Caption = 'forza dimensioni della pagina fisica di stampa'
        TabOrder = 6
        OnClick = cbx_phisical_sizeClick
      end
      object cbx_autosize_page: TCheckBox
        Left = 20
        Top = 166
        Width = 223
        Height = 17
        Hint = 
          'adatta automaticamente le dimensioni della pagina,'#13#10'ridimensiona' +
          'ndo l'#39'area stampabile in funzione della dimensione '#13#10'reale della' +
          ' stampante utilizzata'
        Caption = 'adatta pagina alla stampante'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
      end
      object gb_text_only: TGroupBox
        Left = 71
        Top = 188
        Width = 328
        Height = 99
        TabOrder = 10
        object txt_text_only_font: TLabel
          Left = 16
          Top = 24
          Width = 36
          Height = 16
          Caption = 'FONT'
          FocusControl = cb_text_only_font
        end
        object txt_text_only_cpi: TLabel
          Left = 27
          Top = 48
          Width = 104
          Height = 16
          Caption = 'dimensione font'
          FocusControl = cb_text_only_cpi
        end
        object txt_text_only_lpi: TLabel
          Left = 26
          Top = 73
          Width = 105
          Height = 16
          Caption = 'righe per pollice'
          FocusControl = cb_text_only_lpi
        end
        object cb_text_only_font: TJvFontComboBox
          Left = 64
          Top = 20
          Width = 253
          Height = 23
          DroppedDownWidth = 253
          MaxMRUCount = 0
          Device = fdPrinter
          ItemIndex = -1
          Options = [foFixedPitchOnly]
          Sorted = False
          TabOrder = 0
        end
        object cb_text_only_cpi: TComboBox
          Left = 134
          Top = 44
          Width = 58
          Height = 24
          Style = csDropDownList
          TabOrder = 1
          OnClick = cb_text_only_cpiClick
          Items.Strings = (
            '6'
            '8'
            '10'
            '12'
            '15'
            '17.1'
            '20')
        end
        object cb_text_only_lpi: TComboBox
          Left = 134
          Top = 69
          Width = 58
          Height = 24
          Style = csDropDownList
          TabOrder = 2
          OnChange = cb_text_only_cpiClick
          Items.Strings = (
            '6')
        end
        object unabled_panel: TFPanel
          Left = 203
          Top = 44
          Width = 111
          Height = 50
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 3
          object txt_text_only_colonne: TLabel
            Left = 3
            Top = 4
            Width = 63
            Height = 16
            Caption = '# colonne'
            Enabled = False
            FocusControl = i_text_only_colonne
          end
          object txt_righe_per_pagina: TLabel
            Left = 25
            Top = 29
            Width = 41
            Height = 16
            Caption = '#righe'
            Enabled = False
            FocusControl = i_text_only_righe
          end
          object i_text_only_colonne: TEdit
            Left = 68
            Top = 0
            Width = 41
            Height = 24
            Enabled = False
            ReadOnly = True
            TabOrder = 0
          end
          object i_text_only_righe: TEdit
            Left = 68
            Top = 25
            Width = 41
            Height = 24
            Enabled = False
            ReadOnly = True
            TabOrder = 1
          end
        end
      end
      object bo_text_only_report: TCheckBox
        Left = 79
        Top = 190
        Width = 216
        Height = 17
        Caption = 'Stampa in formato solo testo'
        TabOrder = 9
        OnClick = bo_text_only_reportClick
      end
    end
    object tab_pagine: TTabSheet
      Caption = '&pagine logiche'
      DesignSize = (
        835
        512)
      object txt_pagine: TLabel
        Left = 88
        Top = 128
        Width = 196
        Height = 16
        Caption = 'N'#176' di pagine logiche del report'
        FocusControl = i_pagine
      end
      object txt_GAPP_password_stampa_definitiva: TLabel
        Left = 12
        Top = 422
        Width = 334
        Height = 16
        Anchors = [akLeft, akBottom]
        Caption = 'password richiesta per rendere definitive le stampe'
        FocusControl = str_password_stampa_definitiva
      end
      object btn_header: TButton
        Left = 123
        Top = 36
        Width = 169
        Height = 27
        Caption = 'Formato Pagina'
        TabOrder = 0
        OnClick = btn_headerClick
      end
      object btn_active_section: TButton
        Left = 123
        Top = 72
        Width = 169
        Height = 27
        Caption = 'Formato sezione attiva'
        TabOrder = 1
        OnClick = btn_active_sectionClick
      end
      object i_pagine: TEdit
        Left = 292
        Top = 124
        Width = 39
        Height = 24
        MaxLength = 2
        TabOrder = 2
      end
      object cbx_ask_conferma_stampa_definitiva: TCheckBox
        Left = 8
        Top = 397
        Width = 369
        Height = 17
        Hint = 
          'GALATEO domanda conferma prima di '#13#10'generare in via definitiva n' +
          'umeri progressivi di pagina'
        Anchors = [akLeft, akBottom]
        Caption = 'chiedi conferma prima di rendere definitiva la stampa'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = cbx_ask_conferma_stampa_definitivaClick
      end
      object str_password_stampa_definitiva: TFEdit
        Left = 350
        Top = 418
        Width = 99
        Height = 24
        Anchors = [akLeft, akBottom]
        PasswordChar = '#'
        TabOrder = 4
        AAA_tipodato = fe_generico
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
    end
    object ts_SQL: TTabSheet
      Caption = 'SQL'
      DesignSize = (
        835
        512)
      object txt_stored_procs: TLabel
        Left = 8
        Top = 191
        Width = 241
        Height = 16
        Caption = 'dichiarazione SQL stored procedures'
        FocusControl = str_stored_procs
      end
      object txt_isolation: TLabel
        Left = 326
        Top = 31
        Width = 92
        Height = 16
        Caption = 'isolation level'
        FocusControl = cb_isolation
      end
      object txt_reexecute_SQL_scripts: TLabel
        Left = 26
        Top = 151
        Width = 205
        Height = 32
        Alignment = taRightJustify
        Caption = 'opzioni di esecuzione SCRIPTS'#13#10'nelle ri-esecuzioni del report'
        FocusControl = cb_reexecute_SQL_scripts
      end
      object bo_use_transaction: TCheckBox
        Left = 18
        Top = 8
        Width = 313
        Height = 17
        Caption = 'Apri transazione SQL all'#39'inizio della stampa'
        TabOrder = 0
        OnClick = bo_use_transactionClick
      end
      object rb_commit_transaction: TRadioGroup
        Left = 22
        Top = 32
        Width = 257
        Height = 45
        Caption = ' Al termine esegui ... '
        Color = clBtnFace
        Columns = 2
        Items.Strings = (
          'COMMIT'
          'ROLLBACK')
        ParentColor = False
        TabOrder = 1
      end
      object btn_formato_stproc: TFBitBtn
        Left = 734
        Top = 109
        Width = 89
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Formato'
        TabOrder = 4
        OnClick = btn_formato_stprocClick
        Glyph.Data = {
          CE070000424DCE07000000000000360000002800000024000000120000000100
          1800000000009807000000000000000000000000000000000000007F7F007F7F
          007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F7F00007F7F007F7F007F
          7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
          7F7F007F7FFFFFFFFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F
          007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F00
          007F00007F7F00007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7FFFFFFF007F7F007F7F
          007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
          7F007F7F007F7FFFFF007F7F007F7F007F0000007F7F007F7F007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF
          007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
          7F007F7F007F7F007F7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F0000
          7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
          007F7F007F7F7F7F7FFFFFFFFFFFFF7F7F7FFFFFFF007F7F007F7F007F7F007F
          7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
          007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F007F7F007F
          7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F7F00007F00007F7F00007F7F007F7F007F7F
          007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
          7F007F7FFFFFFFFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F7F007F7F00
          7F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
          7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F7F7F7FFFFFFF007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
          007F7FFFFF007F7F007F7F007F0000007F7F007F7F007F7F007F7F007F7F007F
          7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F7F
          7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
          007F7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F007F7F007F0000007F
          7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
          7F7F7F7F7FFFFFFF007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F
          007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7FFFFF
          007F7F007F7F007F7F007F0000007F7F007F7F007F7F007F7F007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF
          007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
          7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F007F7F007F0000007F7F00
          7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F
          FFFFFF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F
          7F007F7F007F7F007F7F007F7F7F00007F0000007F7F007F7F007F7FFFFF007F
          7F007F7F007F7F007F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F
          007F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F
          7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F7F007F7F007F
          0000007F7F007F7F007F7FFFFF007F7F007F7F007F0000007F7F007F7F007F7F
          007F7F007F7F007F7F007F7F7F7F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFF
          FF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F00
          7F7FFFFF007F7F007F7F007F7F007F00007F00007F00007F7F007F7F007F7F00
          7F0000007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F7F7F
          7FFFFFFFFFFFFFFFFFFF7F7F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F00007F7F007F7F007F7F007F7F007F7F007F
          7F7F7F7FFFFFFF007F7F007F7F7F7F7F7F7F7F7F7F7F007F7F007F7F007F7F7F
          7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
          FFFF00FFFF007F7F007F7F007F7F007F7F007F7F007F7F00007F7F007F7F007F
          7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFFFFFFFF007F7F007F7F00
          7F7F007F7F007F7F007F7F7F7F7F007F7F007F7F007F7F007F7F007F7F007F7F
          007F7F007F7F007F7F007F7F007F7F007F7FFFFF00FFFF00FFFF00FFFF00FFFF
          00007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F
          7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F007F7F007F7F007F7F
          007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
          7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
          007F7F007F7F007F7F007F7F007F7F007F7F}
        NumGlyphs = 2
        color_background_down = clBtnFace
        color_background_up = clBtnFace
        show_shortcut = False
      end
      object str_stored_procs: TMemo
        Left = 0
        Top = 205
        Width = 835
        Height = 307
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        ScrollBars = ssBoth
        TabOrder = 5
        WordWrap = False
      end
      object cb_isolation: TComboBox
        Left = 293
        Top = 48
        Width = 160
        Height = 24
        Style = csDropDownList
        TabOrder = 2
        Items.Strings = (
          '0 Dirty reads'
          '1 Read committed'
          '2 Repeatable read')
      end
      object gbox_definizione_scripts_SQL: TFGroupBox
        Left = 16
        Top = 84
        Width = 434
        Height = 53
        Caption = 'SQL scripts - numero di scripts per tipologia'
        TabOrder = 3
        object txt_SQL_scripts_early: TLabel
          Left = 16
          Top = 25
          Width = 33
          Height = 16
          Caption = 'early'
          FocusControl = i_SQL_scripts_early
        end
        object txt_SQL_scripts_before: TLabel
          Left = 104
          Top = 25
          Width = 41
          Height = 16
          Caption = 'before'
          FocusControl = i_SQL_scripts_before
        end
        object txt_SQL_scripts_after: TLabel
          Left = 204
          Top = 25
          Width = 29
          Height = 16
          Caption = 'after'
          FocusControl = i_SQL_scripts_after
        end
        object btn_SQL_scripts_number_apply: TFBitBtn
          Left = 340
          Top = 16
          Width = 81
          Height = 30
          Caption = 'applica'
          TabOrder = 3
          OnClick = btn_SQL_scripts_number_applyClick
          Glyph.Data = {
            DE000000424DDE0000000000000076000000280000000B0000000D0000000100
            0400000000006800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00880888888880
            0000880088888880000088800888888000008880B0888880000088880B088880
            000088880BB088800000000000BB0880000080BBBBBBB0800000880BBB000000
            00008880BBB08880000088880BBB08800000888880BBB0800000888888000000
            0000}
          color_background_down = clBtnFace
          color_background_up = clBtnFace
          show_shortcut = False
        end
        object i_SQL_scripts_early: TFEdit
          Left = 56
          Top = 21
          Width = 35
          Height = 24
          MaxLength = 2
          TabOrder = 0
          OnChange = SQL_scripts_numeroChange
          OnExit = SQL_scripts_numeroChange
          AAA_tipodato = fe_integer
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object i_SQL_scripts_before: TFEdit
          Left = 152
          Top = 21
          Width = 35
          Height = 24
          MaxLength = 2
          TabOrder = 1
          OnChange = SQL_scripts_numeroChange
          OnExit = SQL_scripts_numeroChange
          AAA_tipodato = fe_integer
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object i_SQL_scripts_after: TFEdit
          Left = 240
          Top = 21
          Width = 35
          Height = 24
          MaxLength = 2
          TabOrder = 2
          OnChange = SQL_scripts_numeroChange
          OnExit = SQL_scripts_numeroChange
          AAA_tipodato = fe_integer
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
      end
      object cb_reexecute_SQL_scripts: TComboBox
        Left = 237
        Top = 152
        Width = 192
        Height = 24
        Hint = 
          'gli scripts SQL vengono eseguiti SEMPRE alla prima esecuzione de' +
          'l report'#13#10' '#13#10'in occasione di eventuali RIGENERAZIONI del report ' +
          #232' possibile che'#13#10'non sia necessario ri-eseguire gli scripts'
        Style = csDropDownList
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
      end
    end
    object SQLS_model: TTabSheet
      Caption = 'SQLS_model'
      ImageIndex = 12
      object pc_SQLS_model: TFPageControl
        Left = 0
        Top = 0
        Width = 835
        Height = 512
        ActivePage = page_SQLS_00
        Align = alClient
        MultiLine = True
        OwnerDraw = True
        TabOrder = 0
        AAA_AutoHighLight = False
        AAA_OpenOnFirstPage = False
        object page_SQLS_00: TTabSheet
          Caption = 'modello per gli oggetti creati runtime di gestione SQL SCRIPTS'
          object panel_SQLS_header: TFPanel
            Left = 0
            Top = 0
            Width = 827
            Height = 145
            Align = alTop
            Color = 14675967
            ParentBackground = False
            TabOrder = 0
            DesignSize = (
              827
              145)
            object txt_SQLS_descrizione_00: TMyLabel
              Left = 50
              Top = 7
              Width = 116
              Height = 16
              Caption = 'descrizione script'
              FocusControl = str_SQLS_descrizione_00
            end
            object txt_SQLS_condizione_00: TMyLabel
              Left = 352
              Top = 7
              Width = 166
              Height = 16
              Caption = 'condizione di esecuzione'
              FocusControl = str_SQLS_condizione_00
            end
            object txt_SQLS_note_00: TMyLabel
              Left = 580
              Top = 52
              Width = 28
              Height = 16
              Caption = 'note'
              FocusControl = str_SQLS_note_00
            end
            object txt_SQLS_filename_00: TMyLabel
              Left = 63
              Top = 121
              Width = 56
              Height = 16
              Caption = 'salva su'
              FocusControl = str_SQLS_filename_00
            end
            object str_SQLS_descrizione_00: TFEdit
              Left = 48
              Top = 24
              Width = 287
              Height = 24
              TabOrder = 0
              AAA_tipodato = fe_generico
              AAA_NeedNotifyModification = False
              AAA_CanBeVoid = True
              AAA_CanBeInvalid = True
            end
            object cbx_SQLS_disabled_locale_00: TFCheckBox
              Left = 50
              Top = 55
              Width = 218
              Height = 17
              Hint = 'questa impostazione ha effetto esclusivamente su questo report'
              Caption = 'disattiva esecuzione locale'
              Color = clBtnFace
              ParentColor = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              AAA_NeedNotifyModification = False
            end
            object btn_SQL_move_sheet_sx: TFBitBtn
              Left = 2
              Top = 0
              Width = 32
              Height = 145
              Anchors = [akLeft, akTop, akBottom]
              TabOrder = 11
              TabStop = False
              Glyph.Data = {
                F2010000424DF201000000000000760000002800000022000000130000000100
                0400000000007C01000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111111111
                1111111111111111111111000000111111110011011001111111177117117700
                0000111111100110110011111111771171177100000011111100110110011111
                1117711711771100000011111001101100111111117711711771110000001111
                0011011001111111177117117711110000001110011011001111111177117117
                7111110000001100110110011111111771171177111111000000100110110011
                1111117711711771111111000000001101100111111117711711771111111100
                0000100110110011111111771171177111111100000011001101100111111117
                7117117711111100000011100110110011111111771171177111110000001111
                0011011001111111177117117711110000001111100110110011111111771171
                1771110000001111110011011001111111177117117711000000111111100110
                1100111111117711711771000000111111110011011001111111177117117700
                00001111111111111111111111111111111111000000}
              NumGlyphs = 2
              color_background_down = clBtnFace
              color_background_up = clBtnFace
              show_shortcut = False
            end
            object btn_SQL_move_sheet_dx: TFBitBtn
              Left = 802
              Top = 0
              Width = 32
              Height = 145
              Anchors = [akTop, akRight, akBottom]
              TabOrder = 12
              TabStop = False
              Glyph.Data = {
                F2010000424DF201000000000000760000002800000022000000130000000100
                0400000000007C01000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111111111
                1111111111111111111111000000001101100111111117711711771111111100
                0000100110110011111111771171177111111100000011001101100111111117
                7117117711111100000011100110110011111111771171177111110000001111
                0011011001111111177117117711110000001111100110110011111111771171
                1771110000001111110011011001111111177117117711000000111111100110
                1100111111117711711771000000111111110011011001111111177117117700
                0000111111100110110011111111771171177100000011111100110110011111
                1117711711771100000011111001101100111111117711711771110000001111
                0011011001111111177117117711110000001110011011001111111177117117
                7111110000001100110110011111111771171177111111000000100110110011
                1111117711711771111111000000001101100111111117711711771111111100
                00001111111111111111111111111111111111000000}
              NumGlyphs = 2
              color_background_down = clBtnFace
              color_background_up = clBtnFace
              show_shortcut = False
            end
            object str_SQLS_condizione_00: TFEdit
              Left = 349
              Top = 23
              Width = 439
              Height = 24
              Hint = 
                'lo script viene eseguito solo se la condizione '#232' VUOTA'#13#10'oppure s' +
                'e contiene un predicato booleano VERO'#13#10' '#13#10'il predicato '#232' una for' +
                'mula di galateo, e pu'#242' contenere riferimenti a macro ed oggetti'#13 +
                #10'con l'#39'avvertenza che sta all'#39'utente verificare che il contenuto' +
                ' di tali oggetti'#13#10'sia valido e disponibile al momento dell'#39'esecu' +
                'zione degli script'
              Anchors = [akLeft, akTop, akRight]
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              AAA_tipodato = fe_generico
              AAA_NeedNotifyModification = False
              AAA_CanBeVoid = True
              AAA_CanBeInvalid = True
            end
            object cbx_SQLS_isolated_transaction_00: TFCheckBox
              Left = 50
              Top = 93
              Width = 231
              Height = 17
              Hint = 
                'esegue l'#39'operazione in una transazione isolata,'#13#10'creata per l'#39'oc' +
                'casione e chiusa al termine dell'#39'esecuzione'#13#10'dell'#39'istruzione SQL' +
                ' (NON al termine del report)'
              Caption = 'esegui in transazione separata'
              Color = clBtnFace
              ParentColor = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 4
              AAA_NeedNotifyModification = False
            end
            object rb_SQLS_transaction_isolation_level_00: TFRadioGroup
              Left = 291
              Top = 49
              Width = 163
              Height = 64
              Hint = 'livello di isolamento utilizzato per la transazione'
              Caption = 'isolation level'
              Items.Strings = (
                '*'
                '*'
                '*')
              ParentShowHint = False
              ShowHint = True
              TabOrder = 5
              AAA_NeedNotifyModification = True
            end
            object rb_SQLS_transaction_commit_00: TFRadioGroup
              Left = 476
              Top = 49
              Width = 100
              Height = 64
              Hint = 'chiudi la transazione con l'#39'istruzione specificata'
              Caption = 'al termine'
              Items.Strings = (
                'Commit'
                'Rollback')
              ParentShowHint = False
              ShowHint = True
              TabOrder = 6
              AAA_NeedNotifyModification = True
            end
            object str_SQLS_note_00: TFMemo
              Left = 611
              Top = 50
              Width = 179
              Height = 91
              Anchors = [akLeft, akTop, akRight, akBottom]
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              Lines.Strings = (
                'str_SQLS_note_00')
              ParentFont = False
              ScrollBars = ssVertical
              TabOrder = 7
              AAA_NeedNotifyModification = True
              AAA_CanBeVoid = True
              AAA_CanBeInvalid = True
            end
            object str_SQLS_filename_00: TFEdit
              Left = 124
              Top = 117
              Width = 340
              Height = 24
              Hint = 
                'lo script viene salvato su un file per poter essere condiviso co' +
                'n altri reports'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 8
              AAA_tipodato = fe_generico
              AAA_NeedNotifyModification = False
              AAA_CanBeVoid = True
              AAA_CanBeInvalid = True
            end
            object btn_SQLS_filename_browse_00: TFBitBtn
              Left = 470
              Top = 117
              Width = 23
              Height = 24
              Hint = 'carica un file contenente SQL scripts'
              Caption = '...'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 9
              OnClick = btn_SQLS_filename_browse_00Click
              color_background_down = clBtnFace
              color_background_up = clBtnFace
              show_shortcut = False
            end
            object btn_SQLS_filename_reload_00: TFBitBtn
              Left = 498
              Top = 117
              Width = 23
              Height = 24
              Hint = 'rilegge il file contenente lo script SQL'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 10
              OnClick = btn_SQLS_filename_reload_00Click
              Glyph.Data = {
                42010000424D4201000000000000760000002800000011000000110000000100
                040000000000CC00000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
                FFFFF0000000FFFFFF99999FFFFFF0000000FFFF999999999FFFF0000000FFF9
                9999999999FFF0000000FF99999FFF9999FFF0000000F99999FFFFFF99FFF000
                0000F9999FFFFFFFFFFFF0000000F999FFFFFFFFFFFFF0000000F999FFFFFFFF
                FFFFF0000000F999FFFFF9999999F0000000F9999FFFFF999999F0000000F999
                9FFFFFF99999F0000000FF99999FFF999999F0000000FFF9999999999999F000
                0000FFFF999999999F99F0000000FFFFF9999999FFF9F0000000FFFFFFFFFFFF
                FFFFF0000000}
              color_background_down = clBtnFace
              color_background_up = clBtnFace
              show_shortcut = False
            end
            object cbx_SQLS_disabled_remoto_00: TFCheckBox
              Left = 50
              Top = 74
              Width = 211
              Height = 17
              Hint = 
                'questa impostazione ha effetto su tutti i reports che richiamano' +
                ' lo script'
              Caption = 'disattiva esecuzione remota'
              Color = clBtnFace
              ParentColor = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
              AAA_NeedNotifyModification = False
            end
          end
          object str_SQLS_00: TMemo
            Left = 0
            Top = 145
            Width = 827
            Height = 336
            Align = alClient
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 1
          end
        end
      end
    end
    object page_SQL_scripts: TTabSheet
      Caption = 'SQL scripts'
      ImageIndex = 12
      DesignSize = (
        835
        512)
      object txt_SQL_scripts_header: TLabel
        Left = 0
        Top = 0
        Width = 835
        Height = 16
        Align = alTop
        Alignment = taCenter
        Caption = 'Scripts SQL eseguiti prima e dopo la stampa               '
        Color = 1303020
        ParentColor = False
        Transparent = False
        ExplicitWidth = 349
      end
      object txt_SQL_scripts_footer: TLabel
        Left = 0
        Top = 496
        Width = 835
        Height = 16
        Align = alBottom
        Alignment = taCenter
        Caption = 'attenzione: i costrutti SELECT saranno aperti ma non eseguiti'
        Color = 1303020
        ParentColor = False
        ShowAccelChar = False
        ExplicitWidth = 398
      end
      object panel_SQL_scripts_blank: TFPanel
        Left = 0
        Top = 16
        Width = 835
        Height = 480
        Align = alClient
        Caption = 'nessuno script SQL'
        Color = 11468718
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 2
      end
      object pc_SQL: TFPageControl
        Left = 0
        Top = 16
        Width = 835
        Height = 480
        Align = alClient
        MultiLine = True
        OwnerDraw = True
        TabOrder = 0
        AAA_AutoHighLight = False
        AAA_OpenOnFirstPage = False
      end
      object btn_help_scripts: TFBitBtn
        Left = 754
        Top = 16
        Width = 89
        Height = 27
        Anchors = [akTop, akRight]
        Caption = 'Formato'
        TabOrder = 1
        OnClick = btn_help_sql_scriptsClick
        Glyph.Data = {
          CE070000424DCE07000000000000360000002800000024000000120000000100
          1800000000009807000000000000000000000000000000000000007F7F007F7F
          007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F7F00007F7F007F7F007F
          7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
          7F7F007F7FFFFFFFFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F
          007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F00
          007F00007F7F00007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7FFFFFFF007F7F007F7F
          007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
          7F007F7F007F7FFFFF007F7F007F7F007F0000007F7F007F7F007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF
          007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
          7F007F7F007F7F007F7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F0000
          7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
          007F7F007F7F7F7F7FFFFFFFFFFFFF7F7F7FFFFFFF007F7F007F7F007F7F007F
          7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
          007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F007F7F007F
          7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F7F00007F00007F7F00007F7F007F7F007F7F
          007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
          7F007F7FFFFFFFFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F7F007F7F00
          7F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
          7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F7F7F7FFFFFFF007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
          007F7FFFFF007F7F007F7F007F0000007F7F007F7F007F7F007F7F007F7F007F
          7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F7F
          7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
          007F7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F007F7F007F0000007F
          7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
          7F7F7F7F7FFFFFFF007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F
          007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7FFFFF
          007F7F007F7F007F7F007F0000007F7F007F7F007F7F007F7F007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF
          007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
          7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F007F7F007F0000007F7F00
          7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F
          FFFFFF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F
          7F007F7F007F7F007F7F007F7F7F00007F0000007F7F007F7F007F7FFFFF007F
          7F007F7F007F7F007F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F
          007F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F
          7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F7F007F7F007F
          0000007F7F007F7F007F7FFFFF007F7F007F7F007F0000007F7F007F7F007F7F
          007F7F007F7F007F7F007F7F7F7F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFF
          FF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F00
          7F7FFFFF007F7F007F7F007F7F007F00007F00007F00007F7F007F7F007F7F00
          7F0000007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F7F7F
          7FFFFFFFFFFFFFFFFFFF7F7F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F00007F7F007F7F007F7F007F7F007F7F007F
          7F7F7F7FFFFFFF007F7F007F7F7F7F7F7F7F7F7F7F7F007F7F007F7F007F7F7F
          7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
          FFFF00FFFF007F7F007F7F007F7F007F7F007F7F007F7F00007F7F007F7F007F
          7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFFFFFFFF007F7F007F7F00
          7F7F007F7F007F7F007F7F7F7F7F007F7F007F7F007F7F007F7F007F7F007F7F
          007F7F007F7F007F7F007F7F007F7F007F7FFFFF00FFFF00FFFF00FFFF00FFFF
          00007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F
          7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F007F7F007F7F007F7F
          007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
          7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
          7F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
          007F7F007F7F007F7F007F7F007F7F007F7F}
        NumGlyphs = 2
        color_background_down = clBtnFace
        color_background_up = clBtnFace
        show_shortcut = False
      end
    end
    object macro_model: TTabSheet
      Caption = 'macro_model'
      ImageIndex = 12
      object page_macro_model: TFPageControl
        Left = 0
        Top = 0
        Width = 835
        Height = 512
        ActivePage = page_macro_00
        Align = alClient
        MultiLine = True
        OwnerDraw = True
        TabOrder = 0
        AAA_AutoHighLight = False
        AAA_OpenOnFirstPage = False
        object page_macro_00: TTabSheet
          Caption = 'modello per le linguette MACRO create runtime'
          object panel_macro_header: TFPanel
            Left = 0
            Top = 0
            Width = 827
            Height = 113
            Align = alTop
            Color = 14675967
            ParentBackground = False
            TabOrder = 0
            DesignSize = (
              827
              113)
            object txt_macro_descrizione: TMyLabel
              Left = 50
              Top = 9
              Width = 120
              Height = 16
              Alignment = taRightJustify
              Caption = 'descrizione macro'
              FocusControl = str_macro_descrizione
            end
            object txt_macro_note: TMyLabel
              Left = 47
              Top = 38
              Width = 28
              Height = 16
              Caption = 'note'
              FocusControl = str_macro_note
            end
            object txt_macro_filename: TMyLabel
              Left = 443
              Top = 9
              Width = 56
              Height = 16
              Caption = 'salva su'
              FocusControl = str_macro_filename
            end
            object str_macro_descrizione: TFEdit
              Left = 173
              Top = 5
              Width = 261
              Height = 24
              TabOrder = 0
              OnChange = str_macro_descrizione_modify
              OnExit = str_macro_descrizione_modify
              AAA_tipodato = fe_generico
              AAA_NeedNotifyModification = False
              AAA_CanBeVoid = True
              AAA_CanBeInvalid = True
            end
            object btn_macro_move_sheet_sx: TFBitBtn
              Left = 3
              Top = 0
              Width = 32
              Height = 113
              Anchors = [akLeft, akTop, akBottom]
              TabOrder = 5
              TabStop = False
              Glyph.Data = {
                F2010000424DF201000000000000760000002800000022000000130000000100
                0400000000007C01000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111111111
                1111111111111111111111000000111111110011011001111111177117117700
                0000111111100110110011111111771171177100000011111100110110011111
                1117711711771100000011111001101100111111117711711771110000001111
                0011011001111111177117117711110000001110011011001111111177117117
                7111110000001100110110011111111771171177111111000000100110110011
                1111117711711771111111000000001101100111111117711711771111111100
                0000100110110011111111771171177111111100000011001101100111111117
                7117117711111100000011100110110011111111771171177111110000001111
                0011011001111111177117117711110000001111100110110011111111771171
                1771110000001111110011011001111111177117117711000000111111100110
                1100111111117711711771000000111111110011011001111111177117117700
                00001111111111111111111111111111111111000000}
              NumGlyphs = 2
              color_background_down = clBtnFace
              color_background_up = clBtnFace
              show_shortcut = False
            end
            object btn_macro_move_sheet_dx: TFBitBtn
              Left = 794
              Top = 0
              Width = 32
              Height = 113
              Anchors = [akTop, akRight, akBottom]
              TabOrder = 6
              TabStop = False
              Glyph.Data = {
                F2010000424DF201000000000000760000002800000022000000130000000100
                0400000000007C01000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111111111
                1111111111111111111111000000001101100111111117711711771111111100
                0000100110110011111111771171177111111100000011001101100111111117
                7117117711111100000011100110110011111111771171177111110000001111
                0011011001111111177117117711110000001111100110110011111111771171
                1771110000001111110011011001111111177117117711000000111111100110
                1100111111117711711771000000111111110011011001111111177117117700
                0000111111100110110011111111771171177100000011111100110110011111
                1117711711771100000011111001101100111111117711711771110000001111
                0011011001111111177117117711110000001110011011001111111177117117
                7111110000001100110110011111111771171177111111000000100110110011
                1111117711711771111111000000001101100111111117711711771111111100
                00001111111111111111111111111111111111000000}
              NumGlyphs = 2
              color_background_down = clBtnFace
              color_background_up = clBtnFace
              show_shortcut = False
            end
            object str_macro_note: TFMemo
              Left = 77
              Top = 36
              Width = 701
              Height = 71
              Anchors = [akLeft, akTop, akRight, akBottom]
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              Lines.Strings = (
                'str_macro_note')
              ParentFont = False
              ScrollBars = ssVertical
              TabOrder = 4
              AAA_NeedNotifyModification = True
              AAA_CanBeVoid = True
              AAA_CanBeInvalid = True
            end
            object str_macro_filename: TFEdit
              Left = 503
              Top = 5
              Width = 218
              Height = 24
              Hint = 
                'lo script viene salvato su un file per poter essere condiviso co' +
                'n altri reports'
              Anchors = [akLeft, akTop, akRight]
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              AAA_tipodato = fe_generico
              AAA_NeedNotifyModification = False
              AAA_CanBeVoid = True
              AAA_CanBeInvalid = True
            end
            object btn_macro_filename_browse: TFBitBtn
              Left = 728
              Top = 5
              Width = 23
              Height = 24
              Hint = 'carica un file contenente MACRO'
              Anchors = [akTop, akRight]
              Caption = '...'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              OnClick = btn_macro_filename_browseClick
              color_background_down = clBtnFace
              color_background_up = clBtnFace
              show_shortcut = False
            end
            object btn_macro_filename_reload: TFBitBtn
              Left = 756
              Top = 5
              Width = 23
              Height = 24
              Hint = 'rilegge il file'
              Anchors = [akTop, akRight]
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
              OnClick = btn_macro_filename_reloadClick
              Glyph.Data = {
                42010000424D4201000000000000760000002800000011000000110000000100
                040000000000CC00000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
                FFFFF0000000FFFFFF99999FFFFFF0000000FFFF999999999FFFF0000000FFF9
                9999999999FFF0000000FF99999FFF9999FFF0000000F99999FFFFFF99FFF000
                0000F9999FFFFFFFFFFFF0000000F999FFFFFFFFFFFFF0000000F999FFFFFFFF
                FFFFF0000000F999FFFFF9999999F0000000F9999FFFFF999999F0000000F999
                9FFFFFF99999F0000000FF99999FFF999999F0000000FFF9999999999999F000
                0000FFFF999999999F99F0000000FFFFF9999999FFF9F0000000FFFFFFFFFFFF
                FFFFF0000000}
              color_background_down = clBtnFace
              color_background_up = clBtnFace
              show_shortcut = False
            end
          end
          object memo_macros: TMemo
            Left = 0
            Top = 113
            Width = 827
            Height = 368
            Align = alClient
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 1
          end
        end
      end
    end
    object page_macro_scripts: TTabSheet
      Caption = 'macro'
      ImageIndex = 13
      DesignSize = (
        835
        512)
      object txt_header_macro: TLabel
        Left = 0
        Top = 0
        Width = 835
        Height = 29
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = 'MACRO PARAMETRICHE'
        Color = 8454143
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = False
        Layout = tlCenter
      end
      object txt_macros_footer: TLabel
        Left = 0
        Top = 496
        Width = 835
        Height = 16
        Align = alBottom
        Alignment = taCenter
        Caption = 'per l'#39'elenco delle macro premi  ctrl+alt+F9  ovunque'
        Color = 8454143
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Layout = tlCenter
        ExplicitWidth = 334
      end
      object pc_macro: TFPageControl
        Left = 0
        Top = 29
        Width = 835
        Height = 467
        Align = alClient
        MultiLine = True
        OwnerDraw = True
        TabOrder = 0
        AAA_AutoHighLight = True
        AAA_OpenOnFirstPage = False
      end
      object btn_help_macro_parametriche: TFBitBtn
        Left = 748
        Top = 2
        Width = 82
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'formato'
        TabOrder = 1
        OnClick = btn_help_macro_parametricheClick
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
      object btn_macro_add: TFBitBtn
        Left = 680
        Top = 2
        Width = 27
        Height = 25
        Hint = 'aggiunge un foglio di macro'
        Anchors = [akTop, akRight]
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btn_macro_addClick
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
      object btn_macro_delete: TFBitBtn
        Left = 712
        Top = 2
        Width = 27
        Height = 25
        Hint = 'elimina il presente foglio di macro'
        Anchors = [akTop, akRight]
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = btn_macro_deleteClick
        Glyph.Data = {
          D6000000424DD60000000000000076000000280000000C0000000C0000000100
          0400000000006000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          0000FFFFFFFFFFFF0000FFFFFFFFFFFF0000FFFFFFFFFFFF0000000000000000
          0000099999999990000009999999999000000000000000000000FFFFFFFFFFFF
          0000FFFFFFFFFFFF0000FFFFFFFFFFFF0000FFFFFFFFFFFF0000}
        color_background_down = clBtnFace
        color_background_up = clBtnFace
        show_shortcut = False
      end
    end
    object page_PDF: TTabSheet
      Caption = 'export && PDF'
      ImageIndex = 8
      object txt_hint_export: TLabel
        Left = 0
        Top = 498
        Width = 835
        Height = 14
        Align = alBottom
        Alignment = taCenter
        Caption = 
          'NB: nei vari elementi '#232' possibile referenziare variabili di stam' +
          'pa precedute dal $ (dollaro)'
        Color = 8454143
        FocusControl = str_export_filename
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ExplicitWidth = 423
      end
      object panel_pdf_name: TFPanel
        Left = 0
        Top = 0
        Width = 835
        Height = 60
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        DesignSize = (
          835
          60)
        object txt_export_filename: TLabel
          Left = 14
          Top = 35
          Width = 125
          Height = 16
          Caption = 'nome file da creare'
          FocusControl = str_export_filename
          ParentShowHint = False
          ShowHint = True
        end
        object txt_default_export_filepath: TLabel
          Left = 9
          Top = 2
          Width = 130
          Height = 32
          Alignment = taRightJustify
          Caption = 'directory predefinita'#13#10'di esportazione'
          FocusControl = str_default_export_filepath
        end
        object image_expint_varamb_01: TImage
          Left = 813
          Top = 11
          Width = 16
          Height = 13
          Cursor = crHandPoint
          Hint = 
            'in questo campo sono consentite le variabili di ambiente e di si' +
            'stema'
          Anchors = [akTop, akRight]
          AutoSize = True
          ParentShowHint = False
          Picture.Data = {
            07544269746D6170DE000000424DDE0000000000000076000000280000001000
            00000D0000000100040000000000680000000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00FFFFFFFFFF0FFFFFFFFFFFFFFF00FFFFFFFFFFFFFF000FFF000000000000
            00FFF00000000000000FFF00000000000000FFFFFFFFFFFFFFFFF99999999999
            99FFFF9999999999999FFFF9999999999999FFFF999FFFFFFFFFFFFFF99FFFFF
            FFFFFFFFFF9FFFFFFFFF}
          ShowHint = True
          OnClick = image_expint_varamb_00Click
        end
        object image_expint_varamb_02: TImage
          Left = 677
          Top = 39
          Width = 16
          Height = 13
          Cursor = crHandPoint
          Hint = 
            'in questo campo sono consentite le variabili di ambiente e di si' +
            'stema'
          Anchors = [akTop, akRight]
          AutoSize = True
          ParentShowHint = False
          Picture.Data = {
            07544269746D6170DE000000424DDE0000000000000076000000280000001000
            00000D0000000100040000000000680000000000000000000000100000000000
            0000000000000000800000800000008080008000000080008000808000008080
            8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00FFFFFFFFFF0FFFFFFFFFFFFFFF00FFFFFFFFFFFFFF000FFF000000000000
            00FFF00000000000000FFF00000000000000FFFFFFFFFFFFFFFFF99999999999
            99FFFF9999999999999FFFF9999999999999FFFF999FFFFFFFFFFFFFF99FFFFF
            FFFFFFFFFF9FFFFFFFFF}
          ShowHint = True
          OnClick = image_expint_varamb_00Click
        end
        object str_export_filename: TEdit
          Left = 144
          Top = 32
          Width = 524
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
        end
        object str_default_export_filepath: TEdit
          Left = 144
          Top = 5
          Width = 632
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
        end
        object btn_browse_PKL_label_00: TFBitBtn
          Left = 785
          Top = 5
          Width = 24
          Height = 24
          Anchors = [akTop, akRight]
          TabOrder = 1
          TabStop = False
          OnClick = btn_browse_PKL_label_00Click
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFF000FF
            FFFFFF0000F0F0FFFFFFFF0FFFF000FFFFFFFF0FFFFFFFFFFFFFFF0FFFFFFFFF
            F000FF0FFFFF0000F0F0FF0FFFFF0FFFF000FF0FFFFFFFFFFFFFFF0FFFF000FF
            FFFFFF0000F0F0FFFFFFFF0FFFF000FFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFF
            FFFFF0F0FFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFF}
          color_background_down = clBtnFace
          color_background_up = clBtnFace
          show_shortcut = False
        end
        object cbx_overwrite: TFCheckBox
          Left = 731
          Top = 35
          Width = 95
          Height = 17
          Hint = 
            'non chiede conferma prima di sovrascrivere il file (se gi'#224' esist' +
            'ente)'
          Anchors = [akTop, akRight]
          Caption = 'sovrascrivi'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          AAA_NeedNotifyModification = False
        end
        object btn_help_export_filename: TFBitBtn
          Left = 698
          Top = 32
          Width = 24
          Height = 26
          Anchors = [akTop, akRight]
          TabOrder = 3
          TabStop = False
          OnClick = btn_help_export_filenameClick
          Glyph.Data = {
            CE070000424DCE07000000000000360000002800000024000000120000000100
            1800000000009807000000000000000000000000000000000000007F7F007F7F
            007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F7F00007F7F007F7F007F
            7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
            7F7F007F7FFFFFFFFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F
            007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F00
            007F00007F7F00007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
            7F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7FFFFFFF007F7F007F7F
            007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
            7F007F7F007F7FFFFF007F7F007F7F007F0000007F7F007F7F007F7F007F7F00
            7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF
            007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
            7F007F7F007F7F007F7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F0000
            7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
            007F7F007F7F7F7F7FFFFFFFFFFFFF7F7F7FFFFFFF007F7F007F7F007F7F007F
            7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
            7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
            007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F007F7F007F
            7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
            7F7F007F7F007F7F007F7F007F7F7F00007F00007F7F00007F7F007F7F007F7F
            007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
            7F007F7FFFFFFFFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
            7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F7F007F7F00
            7F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
            7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F7F7F7FFFFFFF007F7F007F7F00
            7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
            007F7FFFFF007F7F007F7F007F0000007F7F007F7F007F7F007F7F007F7F007F
            7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F7F
            7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
            007F7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F007F7F007F0000007F
            7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
            7F7F7F7F7FFFFFFF007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F
            007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7FFFFF
            007F7F007F7F007F7F007F0000007F7F007F7F007F7F007F7F007F7F007F7F00
            7F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF
            007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
            7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F007F7F007F0000007F7F00
            7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F
            FFFFFF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F
            7F007F7F007F7F007F7F007F7F7F00007F0000007F7F007F7F007F7FFFFF007F
            7F007F7F007F7F007F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F
            007F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F
            7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F7F007F7F007F
            0000007F7F007F7F007F7FFFFF007F7F007F7F007F0000007F7F007F7F007F7F
            007F7F007F7F007F7F007F7F7F7F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFF
            FF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F00
            7F7FFFFF007F7F007F7F007F7F007F00007F00007F00007F7F007F7F007F7F00
            7F0000007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F7F7F
            7FFFFFFFFFFFFFFFFFFF7F7F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F00
            7F7F007F7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F007F7F007F7F00
            7F7F007F7F007F7F007F7F007F7F00007F7F007F7F007F7F007F7F007F7F007F
            7F7F7F7FFFFFFF007F7F007F7F7F7F7F7F7F7F7F7F7F007F7F007F7F007F7F7F
            7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
            FFFF00FFFF007F7F007F7F007F7F007F7F007F7F007F7F00007F7F007F7F007F
            7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFFFFFFFF007F7F007F7F00
            7F7F007F7F007F7F007F7F7F7F7F007F7F007F7F007F7F007F7F007F7F007F7F
            007F7F007F7F007F7F007F7F007F7F007F7FFFFF00FFFF00FFFF00FFFF00FFFF
            00007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F
            7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F007F7F007F7F007F7F
            007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
            7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
            7F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
            007F7F007F7F007F7F007F7F007F7F007F7F}
          NumGlyphs = 2
          color_background_down = clBtnFace
          color_background_up = clBtnFace
          show_shortcut = False
        end
      end
      object pc_export: TMyPageControl
        Left = 0
        Top = 60
        Width = 835
        Height = 438
        ActivePage = page_export_PDF
        Align = alClient
        OwnerDraw = True
        TabOrder = 1
        AAA_AutoHighLight = True
        AAA_OpenOnFirstPage = True
        object page_export_PDF: TTabSheet
          Caption = 'PDF'
          Highlighted = True
          object panel_PDF_base: TFPanel
            Left = 0
            Top = 0
            Width = 827
            Height = 407
            Align = alClient
            Color = 14211582
            ParentBackground = False
            TabOrder = 0
            DesignSize = (
              827
              407)
            object MyLabel1: TMyLabel
              Left = 132
              Top = 275
              Width = 533
              Height = 16
              Anchors = []
              Caption = 
                'la modalit'#224' di stampa di UN FILE PER OGNI RECORD / PAGINA '#232' una ' +
                'opzione PDF'
              ExplicitTop = 276
            end
            object btn_opzioni_PDF: TFBitBtn
              Left = 199
              Top = 126
              Width = 397
              Height = 100
              Anchors = []
              Caption = 'opzioni PDF'
              TabOrder = 0
              OnClick = btn_opzioni_PDFClick
              Glyph.Data = {
                56020000424D560200000000000076000000280000001E0000001E0000000100
                040000000000E001000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FF7777777777
                7777777777777777770000000000000000000000000000000700099999999999
                9999999999999999070009F7777777777777777777777779070009F888888888
                8888888888888879070009F8998888888888888888888879070009F899988888
                8888888888888879070009F899898887FF7F888888888879070009F8899897FF
                FFFFF78888888879070009F888999FFFFFFFFFF888888879070009F8888F99FF
                FFFFFFF788888879070009F8888F9999FFFFFFFF88888879070009F8887FF999
                999FFFFF99998879070009F888FFF99FF9999999F8889879070009F888FFFF9F
                FFFF999999998879070009F8887FFF99FFF999FF78888879070009F888FFFF99
                FF99FFFFF8888879070009F8888FFFF99F9FFFFF88888879070009F88887FFF9
                999FFFF788888879070009F88888FFFF99FFFFF888888879070009F8888887F9
                99FFF78888888879070009F888888889F97F888888888879070009F888888889
                8988888888888879070009F8888888898988888888888879070009F888888889
                8988888888888879070009F8888888889888888888888879070009F888888888
                8888888888888879070009FFFFFFFFFFFFFFFFFFFFFFFFF90700099999999999
                99999999999999990F0000000000000000000000000000000F00}
              color_background_down = clBtnFace
              color_background_up = clBtnFace
              show_shortcut = False
            end
          end
        end
        object page_export_integrale: TTabSheet
          Caption = 'exportazione dati'
          ImageIndex = 1
          object panel_expint_header: TFPanel
            Left = 0
            Top = 0
            Width = 827
            Height = 247
            Align = alTop
            ParentBackground = False
            TabOrder = 0
            DesignSize = (
              827
              247)
            object btn_help_export: TFBitBtn
              Left = 688
              Top = 23
              Width = 82
              Height = 26
              Anchors = [akTop, akRight]
              Caption = 'export'
              TabOrder = 2
              TabStop = False
              OnClick = btn_help_exportClick
              Glyph.Data = {
                CE070000424DCE07000000000000360000002800000024000000120000000100
                1800000000009807000000000000000000000000000000000000007F7F007F7F
                007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F7F00007F7F007F7F007F
                7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                7F7F007F7FFFFFFFFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F00
                007F00007F7F00007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                7F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7FFFFFFF007F7F007F7F
                007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
                7F007F7F007F7FFFFF007F7F007F7F007F0000007F7F007F7F007F7F007F7F00
                7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF
                007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
                7F007F7F007F7F007F7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F0000
                7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                007F7F007F7F7F7F7FFFFFFFFFFFFF7F7F7FFFFFFF007F7F007F7F007F7F007F
                7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F007F7F007F
                7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                7F7F007F7F007F7F007F7F007F7F7F00007F00007F7F00007F7F007F7F007F7F
                007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
                7F007F7FFFFFFFFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F7F007F7F00
                7F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
                7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F7F7F7FFFFFFF007F7F007F7F00
                7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                007F7FFFFF007F7F007F7F007F0000007F7F007F7F007F7F007F7F007F7F007F
                7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F7F
                7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                007F7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F007F7F007F0000007F
                7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                7F7F7F7F7FFFFFFF007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F
                007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7FFFFF
                007F7F007F7F007F7F007F0000007F7F007F7F007F7F007F7F007F7F007F7F00
                7F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF
                007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
                7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F007F7F007F0000007F7F00
                7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F
                FFFFFF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F
                7F007F7F007F7F007F7F007F7F7F00007F0000007F7F007F7F007F7FFFFF007F
                7F007F7F007F7F007F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                007F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F
                7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F7F007F7F007F
                0000007F7F007F7F007F7FFFFF007F7F007F7F007F0000007F7F007F7F007F7F
                007F7F007F7F007F7F007F7F7F7F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFF
                FF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F00
                7F7FFFFF007F7F007F7F007F7F007F00007F00007F00007F7F007F7F007F7F00
                7F0000007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F7F7F
                7FFFFFFFFFFFFFFFFFFF7F7F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F00
                7F7F007F7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F007F7F007F7F00
                7F7F007F7F007F7F007F7F007F7F00007F7F007F7F007F7F007F7F007F7F007F
                7F7F7F7FFFFFFF007F7F007F7F7F7F7F7F7F7F7F7F7F007F7F007F7F007F7F7F
                7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                FFFF00FFFF007F7F007F7F007F7F007F7F007F7F007F7F00007F7F007F7F007F
                7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFFFFFFFF007F7F007F7F00
                7F7F007F7F007F7F007F7F7F7F7F007F7F007F7F007F7F007F7F007F7F007F7F
                007F7F007F7F007F7F007F7F007F7F007F7FFFFF00FFFF00FFFF00FFFF00FFFF
                00007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F
                7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F007F7F007F7F007F7F
                007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
                7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                7F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
                007F7F007F7F007F7F007F7F007F7F007F7F}
              NumGlyphs = 2
              color_background_down = clBtnFace
              color_background_up = clBtnFace
              show_shortcut = False
            end
            object gbox_export_options: TFGroupBox
              Left = 8
              Top = 68
              Width = 786
              Height = 97
              Anchors = [akLeft, akTop, akRight]
              Caption = 'opzioni exportazione'
              TabOrder = 3
              DesignSize = (
                786
                97)
              object txt_expint_export_filename: TLabel
                Left = 14
                Top = 67
                Width = 232
                Height = 16
                Caption = 'nome file specifico per exportazioni'
                FocusControl = str_expint_export_filename
                ParentShowHint = False
                ShowHint = True
              end
              object image_expint_varamb_00: TImage
                Left = 758
                Top = 68
                Width = 16
                Height = 13
                Cursor = crHandPoint
                Hint = 
                  'in questo campo sono consentite le variabili di ambiente e di si' +
                  'stema'
                Anchors = [akTop, akRight]
                AutoSize = True
                ParentShowHint = False
                Picture.Data = {
                  07544269746D6170DE000000424DDE0000000000000076000000280000001000
                  00000D0000000100040000000000680000000000000000000000100000000000
                  0000000000000000800000800000008080008000000080008000808000008080
                  8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
                  FF00FFFFFFFFFF0FFFFFFFFFFFFFFF00FFFFFFFFFFFFFF000FFF000000000000
                  00FFF00000000000000FFF00000000000000FFFFFFFFFFFFFFFFF99999999999
                  99FFFF9999999999999FFFF9999999999999FFFF999FFFFFFFFFFFFFF99FFFFF
                  FFFFFFFFFF9FFFFFFFFF}
                ShowHint = True
                OnClick = image_expint_varamb_00Click
              end
              object cbx_export_set_default: TFCheckBox
                Left = 24
                Top = 24
                Width = 268
                Height = 17
                Hint = 
                  'l'#39'exportazione integrale '#232' il tipo di stampa impostato per defau' +
                  'lt'
                Caption = 'usa come modalit'#224' di stampa default'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
                OnClick = cbx_export_set_defaultClick
                AAA_NeedNotifyModification = False
              end
              object cbx_export_proponi: TFCheckBox
                Left = 24
                Top = 43
                Width = 235
                Height = 17
                Hint = 
                  'dopo aver formattato la stampa il programma'#13#10'propone positivamen' +
                  'te l'#39'exportazione integrale'
                Caption = 'proponi automaticamente export'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 1
                OnClick = cbx_export_proponiClick
                AAA_NeedNotifyModification = False
              end
              object cbx_export_automatic: TFCheckBox
                Left = 272
                Top = 43
                Width = 232
                Height = 17
                Hint = 
                  'l'#39'exportazione viene eseguita senza che sia posta alcuna domanda' +
                  ' all'#39'utente'
                Caption = 'esegui automaticamente export'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 2
                AAA_NeedNotifyModification = False
              end
              object str_expint_export_filename: TEdit
                Left = 252
                Top = 63
                Width = 501
                Height = 24
                Hint = 
                  'specifico nome file utilizzato per le exportazioni (integrale e ' +
                  'XML)'#13#10' '#13#10'per default l'#39'exportazoine viene eseguita sul nomefile ' +
                  'generico'#13#10'(valido ad esempio anche per esportazioni in modalit'#224' ' +
                  'PDF)'#13#10'ma a volte '#232' necessario che le exportazioni utilizzino nom' +
                  'i specifici'#13#10'(ad esempio: FATTURA ELETTRONICA PA)'
                Anchors = [akLeft, akTop, akRight]
                ParentShowHint = False
                ShowHint = True
                TabOrder = 3
              end
            end
            object btn_export_profiles: TFBitBtn
              Left = 233
              Top = 8
              Width = 263
              Height = 44
              Caption = 'profili di exportazione'
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -19
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 1
              OnClick = btn_export_profilesClick
              Glyph.Data = {
                26050000424D260500000000000036040000280000000F0000000F0000000100
                080000000000F000000000000000000000000001000000000000000000000000
                80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                A6000020400000206000002080000020A0000020C0000020E000004000000040
                20000040400000406000004080000040A0000040C0000040E000006000000060
                20000060400000606000006080000060A0000060C0000060E000008000000080
                20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                20004000400040006000400080004000A0004000C0004000E000402000004020
                20004020400040206000402080004020A0004020C0004020E000404000004040
                20004040400040406000404080004040A0004040C0004040E000406000004060
                20004060400040606000406080004060A0004060C0004060E000408000004080
                20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                20008000400080006000800080008000A0008000C0008000E000802000008020
                20008020400080206000802080008020A0008020C0008020E000804000008040
                20008040400080406000804080008040A0008040C0008040E000806000008060
                20008060400080606000806080008060A0008060C0008060E000808000008080
                20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFF00FF51999191919099919191919991FF00FF999090D991
                D99090D990909899FF00FF99FFFF9090D8FFFF9199919099FF00FF9191FFFF90
                9890FFFF91919099FF00FF889191FFFF909999FFFF919091F600FF9A919091FF
                FF919191FFFF91DAFF00FF9090999199FFFF919999FFFF91FF00FF91919091FF
                FF919191FFFF9991FF00FF999191FF09D9D191FFFF90D099FF00FF5091FFFF99
                D0D0FFFF9191D990FF00FF91FFFF9191D9FFFF9A91909099FF00FF5199999191
                9191919191999099F600FF5251919A919291919191919950FF00FFFFFFFFFFFF
                FFFFFFFFFFFFFFFFF600}
              Spacing = 8
              color_background_down = 8421631
              color_background_up = 12910591
              show_shortcut = False
            end
            object cbx_export_allowed: TFCheckBox
              Left = 16
              Top = 19
              Width = 189
              Height = 17
              Hint = 
                'consente l'#39'esportazione dei dati secondo i profili di esportazio' +
                'ne disponibili'
              Caption = 'exportazione consentita'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = cbx_export_allowedClick
              AAA_NeedNotifyModification = False
            end
            object gbox_XML: TFGroupBox
              Left = 8
              Top = 173
              Width = 786
              Height = 61
              Anchors = [akLeft, akTop, akRight]
              Caption = 'impostazioni globali XML'
              TabOrder = 4
              object cbx_XML_structure_debug_info: TFCheckBox
                Left = 16
                Top = 28
                Width = 129
                Height = 17
                Hint = 'inserisce nella struttura XML alcune informazioni di debugging'
                Caption = 'info debug XML'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
                AAA_NeedNotifyModification = False
              end
            end
          end
        end
        object page_export_mail: TTabSheet
          Caption = 'invia per mail'
          ImageIndex = 2
          object txt_mail_opzioni: TLabel
            Left = 0
            Top = 0
            Width = 827
            Height = 19
            Align = alTop
            Alignment = taCenter
            Caption = 'opzioni spedizione di MAIL'
            Color = 8454143
            FocusControl = str_export_filename
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            Transparent = False
            ExplicitWidth = 205
          end
          object pc_mail_opzioni: TFPageControl
            Left = 0
            Top = 19
            Width = 827
            Height = 388
            ActivePage = page_mail_modalita_invio
            Align = alClient
            OwnerDraw = True
            TabOrder = 0
            AAA_AutoHighLight = True
            AAA_OpenOnFirstPage = False
            object page_mail_base: TTabSheet
              Caption = 'opzioni base'
              DesignSize = (
                819
                357)
              object txt_subject: TMyLabel
                Left = 30
                Top = 6
                Width = 48
                Height = 16
                Alignment = taRightJustify
                Caption = 'oggetto'
                FocusControl = str_subject
              end
              object txt_text: TMyLabel
                Left = 6
                Top = 33
                Width = 72
                Height = 16
                Alignment = taRightJustify
                Caption = 'messaggio'
                FocusControl = str_text
              end
              object str_subject: TFEdit
                Left = 82
                Top = 2
                Width = 745
                Height = 24
                Hint = 'indicare l'#39'oggetto del messaggio'
                Anchors = [akLeft, akTop, akRight]
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
                AAA_tipodato = fe_generico
                AAA_NeedNotifyModification = False
                AAA_CanBeVoid = True
                AAA_CanBeInvalid = True
              end
              object str_text: TFMemo
                Left = 82
                Top = 30
                Width = 745
                Height = 252
                Hint = 'indicare il testo del messaggio'
                Anchors = [akLeft, akTop, akRight, akBottom]
                ParentShowHint = False
                ScrollBars = ssBoth
                ShowHint = True
                TabOrder = 1
                AAA_NeedNotifyModification = False
                AAA_CanBeVoid = True
                AAA_CanBeInvalid = True
              end
              object cbx_address_required: TFCheckBox
                Left = 82
                Top = 290
                Width = 281
                Height = 17
                Hint = 
                  'GALATEO consente l'#39'invio del file PDF via '#13#10'posta elettronica so' +
                  'lo se '#232' stato indicato un destinatario'
                Anchors = [akLeft, akBottom]
                Caption = 'blocca invio se manca indirizzo e-mail'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 2
                AAA_NeedNotifyModification = False
              end
              object panel_invio_automatico: TFPanel
                Left = 0
                Top = 309
                Width = 819
                Height = 48
                Align = alBottom
                Color = 8454143
                ParentBackground = False
                TabOrder = 3
                DesignSize = (
                  819
                  48)
                object txt_condizione_auto_email: TMyLabel
                  Left = 9
                  Top = 26
                  Width = 48
                  Height = 16
                  Alignment = taRightJustify
                  Caption = 'solo se'
                  FocusControl = str_condizione_auto_email
                end
                object cbx_auto_email: TFCheckBox
                  Left = 14
                  Top = 4
                  Width = 294
                  Height = 17
                  Caption = 'proponi automaticamente invio via e-mail'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 0
                  OnClick = cbx_auto_emailClick
                  colorChecked = 8454143
                  colorUnChecked = 8454143
                  AAA_NeedNotifyModification = False
                end
                object str_condizione_auto_email: TFEdit
                  Left = 62
                  Top = 22
                  Width = 756
                  Height = 24
                  Hint = 
                    'la proposta automatica di invio avviene'#13#10'solo se la condizione '#232 +
                    ' verificata'#13#10'(oppure se non c'#39#232' condizione)'#13#10' '#13#10'la condizione '#232' ' +
                    'una FORMULA di Galateo e'#13#10'deve dare un risultato booleano (VERO ' +
                    'o FALSO)'
                  Anchors = [akLeft, akTop, akRight]
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 1
                  AAA_tipodato = fe_generico
                  AAA_NeedNotifyModification = False
                  AAA_CanBeVoid = True
                  AAA_CanBeInvalid = True
                end
              end
            end
            object page_mail_modalita_invio: TTabSheet
              Caption = 'modalit'#224' di invio'
              Highlighted = True
              ImageIndex = 2
              object txt_SMTP_header: TMyLabel
                Left = 0
                Top = 82
                Width = 819
                Height = 32
                Align = alBottom
                Alignment = taCenter
                Caption = 
                  'ATTENZIONE: le sottostanti impostazioni di spedizione sono legat' +
                  'e all'#39'account windows'#13#10'e salvate sul REGISTRY'
                Color = 14663679
                ParentColor = False
                Transparent = False
                ExplicitWidth = 571
              end
              object rb_modalita_mail: TRadioGroup
                Left = 8
                Top = 0
                Width = 557
                Height = 76
                Hint = 
                  'definisce la modalit'#224' di spedizione delle mail'#13#10' '#13#10'ATTENZIONE: l' +
                  'a modalit'#224' di assegnazione esplicita'#13#10'(client di posta elettroni' +
                  'ca, SMTP, Outlook)'#13#10'prevalgono sulla modalit'#224' impostata dal prog' +
                  'ramma chiamante.'#13#10'A prescindere dalla modalit'#224', per la spedizion' +
                  'e'#13#10'GALATEO utilizza i dati di configurazione SMTP'#13#10'forniti dal p' +
                  'rogramma chiamante'#13#10'(perch'#232' sempre da preferirsi rispetto a quel' +
                  'li'#13#10'staticamente definiti sul report)'
                Caption = 'modalit'#224' di spedizione'
                Columns = 2
                Items.Strings = (
                  '1'
                  '2'
                  '3'
                  '4'
                  '5')
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
                OnClick = rb_modalita_mailClick
              end
              object pc_mail: TFPageControl
                Left = 0
                Top = 114
                Width = 819
                Height = 243
                ActivePage = page_mail_SMTP
                Align = alBottom
                Anchors = [akLeft, akTop, akRight, akBottom]
                OwnerDraw = True
                TabOrder = 1
                AAA_AutoHighLight = True
                AAA_OpenOnFirstPage = False
                object page_mail_opzioni_generali: TTabSheet
                  Caption = 'client'
                  DesignSize = (
                    811
                    212)
                  object txt_SMTP_firma: TMyLabel
                    Left = 88
                    Top = 110
                    Width = 33
                    Height = 16
                    Caption = 'firma'
                  end
                  object txt_SMTP_ccn: TMyLabel
                    Left = 12
                    Top = 78
                    Width = 109
                    Height = 16
                    Caption = 'invia copia ccn a'
                    FocusControl = str_SMTP_ccn
                  end
                  object rb_client_SMTP: TRadioGroup
                    Left = 127
                    Top = 2
                    Width = 296
                    Height = 67
                    Hint = '*** runtime'
                    Caption = 'client di posta elettronica: forza SMTP?'
                    Items.Strings = (
                      '*** def'
                      '*** progr chiam'
                      '*** sempre SMTP')
                    ParentShowHint = False
                    ShowHint = True
                    TabOrder = 0
                    OnClick = rb_modalita_mailClick
                  end
                  object str_SMTP_firma: TFMemo
                    Left = 127
                    Top = 104
                    Width = 671
                    Height = 104
                    Hint = 
                      'FIRMA applicata a tutti i messaggi di posta elettronica inviati'#13 +
                      #10'sia in modalit'#224' CLIENT che in modalit'#224' SMTP'
                    Anchors = [akLeft, akTop, akRight, akBottom]
                    ParentShowHint = False
                    ScrollBars = ssBoth
                    ShowHint = True
                    TabOrder = 2
                    AAA_NeedNotifyModification = False
                    AAA_CanBeVoid = True
                    AAA_CanBeInvalid = True
                  end
                  object str_SMTP_ccn: TFEdit
                    Left = 127
                    Top = 74
                    Width = 671
                    Height = 24
                    Hint = 
                      'tutte le mail vengono inviate in modalit'#224' CCN al destinatario sp' +
                      'ecificato'#13#10'usare la VIRGOLA per inserire indirizzi multipli'
                    Anchors = [akLeft, akTop, akRight]
                    ParentShowHint = False
                    ShowHint = True
                    TabOrder = 1
                    AAA_tipodato = fe_generico
                    AAA_NeedNotifyModification = False
                    AAA_CanBeVoid = True
                    AAA_CanBeInvalid = True
                  end
                end
                object page_mail_SMTP: TTabSheet
                  Caption = 'configurazione SMTP'
                  Highlighted = True
                  ImageIndex = 1
                  object gbox_SMTP: TFGroupBox
                    Left = 0
                    Top = 0
                    Width = 811
                    Height = 212
                    Align = alClient
                    Color = 13303754
                    ParentColor = False
                    TabOrder = 0
                    DesignSize = (
                      811
                      212)
                    object txt_SMTP_from: TMyLabel
                      Left = 9
                      Top = 73
                      Width = 57
                      Height = 32
                      Alignment = taRightJustify
                      Caption = 'indirizzo'#13#10'mittente'
                      FocusControl = str_SMTP_from
                    end
                    object txt_SMTP_host: TMyLabel
                      Left = 12
                      Top = 25
                      Width = 70
                      Height = 16
                      Alignment = taRightJustify
                      Caption = 'SMTP host'
                      FocusControl = str_SMTP_host
                    end
                    object txt_SMTP_auth_ID: TMyLabel
                      Left = 136
                      Top = 53
                      Width = 46
                      Height = 16
                      Alignment = taRightJustify
                      Caption = 'auth-ID'
                      FocusControl = str_SMTP_auth_ID
                    end
                    object txt_SMTP_password: TMyLabel
                      Left = 480
                      Top = 53
                      Width = 63
                      Height = 16
                      Alignment = taRightJustify
                      Anchors = [akTop, akRight]
                      Caption = 'password'
                      FocusControl = str_SMTP_password
                    end
                    object txt_SMTP_porta: TMyLabel
                      Left = 420
                      Top = 25
                      Width = 33
                      Height = 16
                      Alignment = taRightJustify
                      Anchors = [akTop, akRight]
                      Caption = 'porta'
                      FocusControl = wo_SMTP_port
                    end
                    object txt_SMTP_descrizione_mittente: TMyLabel
                      Left = 263
                      Top = 73
                      Width = 76
                      Height = 32
                      Alignment = taRightJustify
                      Caption = 'descrizione'#13#10'mittente'
                      FocusControl = str_SMTP_descrizione_mittente
                    end
                    object btn_modelli_SMTP: TJvSpeedButton
                      Tag = 1
                      Left = 612
                      Top = 22
                      Width = 169
                      Height = 23
                      Hint = 
                        'consente di impostare i parametri per i principali servizi mail ' +
                        '(GMAIL, YAHOO, ...)'
                      Anchors = [akTop, akRight]
                      Caption = 'impostazioni standard'
                      DropDownMenu = popup_SMTP
                    end
                    object txt_SMTP_replyto: TMyLabel
                      Left = 270
                      Top = 109
                      Width = 69
                      Height = 16
                      Alignment = taRightJustify
                      Caption = 'rispondi a:'
                      FocusControl = str_SMTP_replyto
                    end
                    object str_SMTP_from: TFEdit
                      Left = 69
                      Top = 77
                      Width = 188
                      Height = 24
                      TabOrder = 6
                      AAA_tipodato = fe_generico
                      AAA_NeedNotifyModification = False
                      AAA_CanBeVoid = True
                      AAA_CanBeInvalid = True
                    end
                    object str_SMTP_host: TFEdit
                      Left = 87
                      Top = 21
                      Width = 320
                      Height = 24
                      Anchors = [akLeft, akTop, akRight]
                      TabOrder = 0
                      AAA_tipodato = fe_generico
                      AAA_NeedNotifyModification = False
                      AAA_CanBeVoid = True
                      AAA_CanBeInvalid = True
                    end
                    object str_SMTP_auth_ID: TFEdit
                      Left = 185
                      Top = 49
                      Width = 288
                      Height = 24
                      Anchors = [akLeft, akTop, akRight]
                      TabOrder = 4
                      AAA_tipodato = fe_generico
                      AAA_NeedNotifyModification = False
                      AAA_CanBeVoid = True
                      AAA_CanBeInvalid = True
                    end
                    object str_SMTP_password: TFEdit
                      Left = 548
                      Top = 49
                      Width = 143
                      Height = 24
                      Anchors = [akTop, akRight]
                      PasswordChar = '#'
                      TabOrder = 5
                      AAA_tipodato = fe_generico
                      AAA_NeedNotifyModification = False
                      AAA_CanBeVoid = True
                      AAA_CanBeInvalid = True
                    end
                    object btn_test_SMTP: TFBitBtn
                      Left = 699
                      Top = 51
                      Width = 84
                      Height = 51
                      Anchors = [akTop, akRight]
                      Caption = 'test SMTP'
                      TabOrder = 8
                      OnClick = btn_test_SMTPClick
                      Glyph.Data = {
                        86010000424D8601000000000000760000002800000020000000110000000100
                        0400000000001001000000000000000000001000000000000000000000000000
                        80000080000000808000800000008000800080800000C0C0C000808080000000
                        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFF8888888
                        888888888888888888FFFFFFF800000000000000000000000000FFFFF80FFFFF
                        FFFFFFFFFFFFFFFFFFF0FFFFF80FFFFFFFFFFFFFFFFFFFFFFFF0FFFFF80FFFFF
                        FFFFF78FFFFFFFFFFFF0777777777F7FFF7888FF888FFFFFFFF00000000000FF
                        FFFFFFFFFFFFFFFFFFF0FFFFF80FFFFFFF788888888FFFFFFFF0FF7777777FFF
                        FFFFFFFFFFFFFFFFFFF0FF00000000FFFF788888888FFFFFFFF0FFFFF80FFFFF
                        FFFFFFFFFFFFFFFFFFF0F77777777777F777FFFFFFFFFFFFFFF0F00000000000
                        0F000FFFFFF1F1F191F0FFFFF80FFFFFFFFFFFFFFFFFFFF989F07777770F8787
                        FFFFFFFFFFF1F1F191F00000000FFFFFFFFFFFFFFFFFFFFFFFF0FFFFFF000000
                        00000000000000000000}
                      Layout = blGlyphBottom
                      color_background_down = clBtnFace
                      color_background_up = 12320767
                      show_shortcut = False
                    end
                    object cbx_SMTP_TLS: TFCheckBox
                      Left = 537
                      Top = 25
                      Width = 61
                      Height = 17
                      Anchors = [akTop, akRight]
                      Caption = 'TLS'
                      Color = clBtnFace
                      ParentColor = False
                      TabOrder = 2
                      AAA_NeedNotifyModification = False
                    end
                    object cbx_SMTP_need_authentication: TFCheckBox
                      Left = 10
                      Top = 53
                      Width = 121
                      Height = 17
                      Caption = 'autenticazione'
                      Color = clBtnFace
                      ParentColor = False
                      TabOrder = 3
                      AAA_NeedNotifyModification = False
                    end
                    object wo_SMTP_port: TFEdit
                      Left = 458
                      Top = 21
                      Width = 57
                      Height = 24
                      Anchors = [akTop, akRight]
                      TabOrder = 1
                      AAA_tipodato = fe_integer
                      AAA_NeedNotifyModification = False
                      AAA_CanBeVoid = True
                      AAA_CanBeInvalid = True
                    end
                    object str_SMTP_descrizione_mittente: TFEdit
                      Left = 345
                      Top = 77
                      Width = 347
                      Height = 24
                      Anchors = [akLeft, akTop, akRight]
                      TabOrder = 7
                      AAA_tipodato = fe_generico
                      AAA_NeedNotifyModification = False
                      AAA_CanBeVoid = True
                      AAA_CanBeInvalid = True
                    end
                    object cbx_SMTP_conferma_lettura: TFCheckBox
                      Left = 10
                      Top = 109
                      Width = 195
                      Height = 17
                      Caption = 'richiedi conferma di lettura'
                      Color = clBtnFace
                      ParentColor = False
                      TabOrder = 9
                      AAA_NeedNotifyModification = False
                    end
                    object str_SMTP_replyto: TFEdit
                      Left = 345
                      Top = 105
                      Width = 347
                      Height = 24
                      Hint = 
                        'le risposte al messaggio inviato saranno automaticamente'#13#10'indiri' +
                        'zzate all'#39'indirizzo qui specificato'
                      Anchors = [akLeft, akTop, akRight]
                      ParentShowHint = False
                      ShowHint = True
                      TabOrder = 10
                      AAA_tipodato = fe_generico
                      AAA_NeedNotifyModification = False
                      AAA_CanBeVoid = True
                      AAA_CanBeInvalid = True
                    end
                  end
                end
                object page_outlook: TTabSheet
                  Caption = 'configurazione Outlook'
                  ImageIndex = 2
                  DesignSize = (
                    811
                    212)
                  object btn_outlook_configuration: TFBitBtn
                    Left = 242
                    Top = 37
                    Width = 328
                    Height = 137
                    Anchors = []
                    Caption = 'configurazione parametri OUTLOOK'
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -16
                    Font.Name = 'Arial'
                    Font.Style = [fsBold]
                    ParentFont = False
                    TabOrder = 0
                    OnClick = btn_outlook_configurationClick
                    Glyph.Data = {
                      FE320000424DFE32000000000000360000002800000042000000410000000100
                      180000000000C832000000000000000000000000000000000000FFFFFFFEFFEA
                      FFE5FFFFE4FFE9F4F2FCEFFFF9EFFFF6F7F5FFF7FEFAF0FCFAF0FCFAF0FCFAF0
                      FCFAF0FCFAF0FCFAF0FCFAF0FCFAF5F2FAF5F2FAF5F2FCF4F4FFF4F6FFF4F6FF
                      F4F7FFF3F7F7F2F1F9F4F3F9F4F3F8F2F3F6F0F1F6F0F1FBF2F5FDF4F7EFF7F6
                      F0F8F7F3F9F8F3F9F8F4F9F8F4F9F8F5F7F7F4F6F6F4F8F3F4F7F5F6F7F5F6F6
                      F6F8F6F6F9F6F8FBF5FAFBF5FAF4F6F6F4F6F6F4F6F6F6F6F6F7F7F7F9F7F7F9
                      F7F7F9F7F7EEF0DCFFFFE3F4F3E5E6FBF8EFFEF6E7E9F1E1F0FFF6FAFFFFFFFF
                      0000FFFFFFFFFFD5E7E5F1C1DADEB6E4C7BED8D8B6CDD5A8D3C6A6D5D2B4D5D1
                      B4D5D1B4D5D1B4D5D1B4D5D1B4D5D1B4D5D1B4D5D1B6D5D8B7D4D9B7D4D9B7D3
                      DAB7D3DAB9D2DCB9D2DCB9D1DDB7D4DBB7D4DBB6D3DAB6D2D9B6D2D9B8D2D9B9
                      D3DABAD4DBC5CFD9C4CED8C4CED8C3CDD7C3CCD6C2CBD5C1CAD4C1CAD4BDCED7
                      BDCED7BDCDD9BDCDD9BFCCDABFCCDCBFCCDCBFCCDCBCCCD8BCCCD8BDCDD9BDCD
                      D9BFCDD9BFCDD9BFCDD9BFCDD9C0CDEDCBD6ECB9CADFB5CFDFBED4D2CDDACCF3
                      FADFFFFFDEFFFFFF0000FFFFFFB6F5F360B4F622A3DC38B1D13AA6E63B93E022
                      9BD316A0E22A9CDB2A9CDB2A9CDB2A9CDB2A9CDB2A9CDB2A9CDB2A9CDB2290D8
                      228FD9228FD9228EDB228EDB228EDC228DDE228DDE1F8EDE1F8BDC1D8AD81D89
                      D71E8AD7218CD6218CD6228BD5198CD7188BD6178AD51689D41689D41689D416
                      89D41689D41586D61586D61585D71484D61484D81483D91483D91483D91384D4
                      1384D41384D41384D41384D41384D41384D41384D4007AE0047DE4027BD81D7D
                      D72978CF5C98D4D0D8F5FFF1F9FFFFFF0000FFFFFFDDF3FE58ABEF1BA4DC6CC3
                      E36EC5FD89B4F775C1EB67C9F972BEF372BEF372BEF372BEF372BEF372BEF372
                      BEF372BEF372C1EA72C1EA70BFEA70BFEA6EBFEC6EBEED6DBDEC6DBDEC6BBDED
                      69BBEB66B8E867B9E869BBEA6ABDEA69BCE968BBE86FB9E96EB8E86CB8E86BB7
                      E76CB8E86CBAE96EBCEB6FBDEC7AB3EB79B2EA77B1EC77B1EC77B0ED75B0EE74
                      AFED74AEEF75B0E873B0E873B0E872AFE770B0E770B0E770B0E76FB0E77EB2E0
                      6BB1ED62BCEB6FACEA297CD72D91D1BDDCF1E0F1FAFFFFFF0000FFFFFFFFFDF8
                      79B5E350BFD9DDEFEED0FFFFFFF1FDFFFFF0FAFFF5FCFFFDFCFFFDFCFFFDFCFF
                      FDFCFFFDFCFFFDFCFFFDFCFFFDFCFFF6FAFFF6FAFFF7F8FFF6F5FFF6F3FFF8F1
                      FFF8F0FFF7F3FFFEF2FFFDEEFFFBEAFFFBE9FFFCE8FFFDE6FFFEE4FFFEE5FEFA
                      E2FDF9E2FDF9DFFDF8DDFDF8DCFEF8DAFEF8DBFFF9E0FCFDDFFBFCDDFBFCDBFA
                      FDD9F9FED6F9FDD6F8FED4F8FED4F7FAD2F8FAD2F8FAD0F7F9CEF7F9CBF7F8C9
                      F7F8C9F7F8D2E7DFB2E0F2BEFFFBE4F6FF5E9BDF369AC4E0E7DAF9F6E8FFFFFF
                      0000FFFFFFE3EEFF44A9ED2FBFE9DAEEFFA8FFFFEEF7FFFBFFF2FFFFF5FBFFFF
                      FBFFFFFBFFFFFBFFFFFBFFFFFBFFFFFBFFFFFBFFFFEFF8FFEFF8FFEDF6FFEBF7
                      FFE6F6FFE4F4FFE2F5FFDFF3FFDEF5FFDDF5FFD7F4FFCEF0FFC3EBFFBBE9FFB8
                      E9FFB6EBFFAEF3FFAEF3FFACF3FFA9F2FFA5F2FFA0EFFF9CEEFF99EDFF85F1FF
                      85F1FF83F1FF7FF0FF7CEFFF79EEFF77EEFF76EEFF72ECFF72ECFF6FECFF6CEB
                      FF69ECFF66EBFF63EAFE61EBFE31A4E10A93E94BDBF7C0EAFF3888F30F89CFEA
                      DFE2FFEEFAFFFFFF0000FFFFFFE3F6FB45B5EA3AC8EBE9ECFA82FDFFCFF6FFF1
                      FFF5FFFAF3FEFFFBFEFFFBFEFFFBFEFFFBFEFFFBFEFFFBFEFFFBFEFFFBF4FEFF
                      F2FEFFF0FDFFEBFDFFE9FCFFE4FAFFE1FAFFDFFAFFD7F6FFD6F8FFCEF6FFBCEE
                      FFA8E1FF96DAFD90DBFF90DEFFB6E7FFB6E9FFB6ECFFB5EEFFB3EFFFADEDFFA8
                      EBFFA5E9FF90ECFF8EEBFF8CEBFF89E9FF85EAFF81E9FF7EE8FF7CE8FF75E5FF
                      75E5FF70E5FF6EE4FF69E4FF65E3FF62E3FE62E3FE41A5FF0078EB3EC8E5D9EF
                      FF3F91F70094CCE0EDDDEAFAF9FFFFFF0000FFFFFFEFFBF554BBE84BCCEDF4E7
                      F76BF1FBB7EEFFE4FFFFFFF2FFFFFDFFFFFDFFFFFDFFFFFDFFFFFDFFFFFDFFFF
                      FDFFFFFDFFF1FFFAEFFFFAECFFFBE8FFFAE3FEFADEFDFADCFDF9D9FBFAD2FAF5
                      D1FDFCC7FCFFB0F0FB93DEF47DD3F174D2F574D7FD93DEEE95E2F29AE8F89BEE
                      FD9AF2FF97F3FF93F1FE90F0FD97F2FB95F1FC92F1FB8EF0FC89EFFC85EEFB82
                      EDFB80EDFB77E9FF75E9FF72E9FF6EE8FE69E8FD65E8FC62E7FB60E7FB52CBFF
                      0081E036C8C8EDF2F15392EE0591C6F3E6D8F5EBF7FFFFFF0000FFFFFFEAFCF5
                      49B3F24DB6E7DEF6FC5BEBF76BE9FFC7F8FFFFFEF4FFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFF6FEFEF1FDFFEDFCFEE8FBFEE4FBFDE1
                      FAFEDFFAFEDBFCF8DFFFFFC8F2FF97D4F487D2F2A6EAFFC7F1FED3E3E976D5FF
                      76D4FF77D3FE7DD4FC86DAFD94E4FFA1EEFFA8F3FF9CF3F799F1F794EFF88CEB
                      FA86E9FD80E7FF7DE7FF7BE6FF5EE0FF62E4FF66E8FF6AECFD6AEBFA67E9FA64
                      E4FB60E1FA5FE4FF23A7E32796DEA9E4FE64ABEE2873CFD7DFE6F9FFF3FFFFFF
                      0000FFFFFFEBFBF449B3F24CB8E8DFF7FD5AEAF667E6FFBEF6FFFFFFF7FFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFF6FEFEF1FDFFEDFC
                      FEE8FBFEE4FBFDE1FAFEDFFAFEDCF9FDD2FAFFB6ECFF9DDBF9A4DDFCC8F2FFE0
                      FBFFE5F4F6CAE5FFC1E1FEB0DCF99DD9F78BD6F67CD6F872D9FA6EDAFC8BE8FF
                      8FECFF91F1FF91F3FF8DF2FF86ECFF7DE6FB76E1F67BEEFF7AEDFF76ECFD71EB
                      FB6BE8FC67E5FF60E2FF5DE0FF5FE4FF2EB3EC2899DC98D4F25CA4EA2B79D3D7
                      E0E4FAFEF3FFFFFF0000FFFFFFECF8F24AB4F34DBBEBDFF9FF5BE8F55FE2FFAC
                      F4FFFBFFFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFF
                      F6FEFEF1FDFFEDFCFEE8FBFEE4FBFDE1FAFEDFFAFEDFF9FFBFF0FFA0E5F9A5E2
                      FCCCEAFFF0F7FFF8FEFFF4FFFEFFFDFFFFFAFFEBF4FED0ECFDB2E3FD96DBFC83
                      D6FC77D3FC74CFFC78D4FF7CDBFF82E5FF85ECFF85F0FF83F3FF82F2FE82EAF7
                      7EE9F778E7F770E6F96AE5FF67E5FF63E5FF64E6FF60E3FF3FC6F82B9FDE7DBB
                      DF4F99E73382D9D6E0E0F9FBF5FFFFFF0000FFFFFFEDF6F348B5F34CBFECE0FB
                      FF5BE8F757DFFF93EFFFD6FEFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFF7FFFFF6FEFEF1FDFFEDFCFEE8FBFEE4FBFDE1FAFEDFFAFEE0F8FF
                      B0E7FC94E0F3B1E8FDEBF1FFFFF4FFFFF9FDF8FFFCFFFFF8FDFFFBFAFFFFF4FE
                      FFE8F7FFDDEFFFD4E9FFCEE5FF90D2FB8AD0F87FCDF275CEF072D4F272E0FA78
                      ECFF7CF4FF78E8FF76E8FF71E9FF6DE9FF69E8FF67E7FF66E4FF65E3FF62E2FF
                      4FD9FF30ABE368A7D33F8AE0368ADCD5E1DBF9F7F7FFFFFF0000FFFFFFF3F6F4
                      49B7F348C0EAE1FCFF5CE7F751DDFF79ECFFACF9FCFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFF6FEFEF1FDFFEDFCFEE8FBFEE4FBFDE1
                      FAFEDFFAFED6F2FFADE3FA9BE1F2C4EFFEFFF8FFFFF2FEFFF6F9FAFFFCF6FBFE
                      F7FCFFFBFEFFFFFEFFFFFDFFFFFCFFFFF9FCFFF7FADBF7FFCCF0FFB1E2F897D7
                      F07CCEED6CCDEF62CFF560D2FA6BE4FF6AE6FF69EBFF68EEFF67EDFF66E9FC67
                      E4F366E0EC61E1FF58E6FF3CBCED5E9FD22F7BDB358DDAD3E3D8FAF3FAFFFFFF
                      0000FFFFFFF7F8F648B6F246BFE9DFFDFE60E9F94BDCFF63E8FF85F2FAFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFF6FEFEF1FDFFEDFC
                      FEE8FBFEE4FBFDE1FAFEDFFAFEC3EAFFB2E3F9B6E7F5DFF8FFFFFCFFFFF9FFFF
                      FBFDFBFFFFFFF3FFFFF6FFFFF8FFFFFCFFFFFFFBFDFFF7F9FFF1F6FFEFFFFFFE
                      FAFFFFEAFCFFD2F3FFB6E8FF9ADBFA82D0F577C9F262C8F861CEFA60D6FF61DE
                      FF63E5FF69E9FE6EECF771EDF563E1FF58E9FF4CCFFA63A5E0226FD62F8AD5D4
                      E6D5F9F0FDFFFFFF0000FFFFFFFEFAF948B6F242BEE6DEFCFD62EAFC4ADEFF50
                      E6FF65EDF9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFF
                      F6FEFEF1FDFFEDFCFEE8FBFEE4FBFDE1FAFEDFFAFEAEE2F9BCE6F9D9F1FDF5FE
                      FFFFFEFFFFFDFFFFFCFFFBFEFFFFF9FFFFFAFFFFFCFFFFFDFFF9FEFCF5FFF9F2
                      FFF9F1FFF7FFFAF6FFFDFAFFFFFFF8FEFFEEFDFFE0F5FFD1ECFFC8E7FC97CCED
                      8BCBEE78CBF169CEF55FD4FB60DCFE64E4FF6AE8FF65E0FF53E7F559E0FF70B2
                      F31965D52685CBD5E8D3FAEEFFFFFFFF0000FFFFFFFFFAFB46B6F23EBDE4DDFC
                      FB65EBFD49DFFF47E5FF54E9F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFF7FFFFF6FEFEF1FDFFEDFCFEE8FBFEE4FBFDE1FAFEDFFAFEA2DDF1
                      C5E9F9EFF8FFFFFEFFFDFFFEF4FCFCF4FAFFF9F7FFF1FFFCF3FFFEF2FFFDF2FC
                      FCF6FBFEF9FCFFFDFCFFFFFCFFFFFDFFFFFEFFFFFCFDFFFBFCFFFBFBFFFCFCFF
                      FFFCFFFEFCF1FBFFD6F1FFABDEFE80CFF65EC6F54EC5F649CAFB4BCEFF65E0FF
                      4EE3ED62EAFF79BCFF1361D22180C6D6EAD3FAEEFFFFFFFF0000FFFFFFFAF7F9
                      49BDEC46C4E6E5F8FF68E7FC4CE6FF44E9FA4BDFFF84E7FDFFF9FFFFFFF5F3FF
                      EDFFFAEDFFFCFFDFFEFFE1F1FFFAFDFFF6FAFFF2FBFFF1FFFFEDFFFFE5FEFFD3
                      F1F2C6E5E6C3ECEEE3F6FEFDF4FFFFEEFFFFF2FFFFFFFFFFFFF5FFFFEAFCFDF9
                      FDFFFFFDFEFFF8F7FFF8F6FCFDFBFBFFFFF9FFFFF7FEFDFFFFFDFFFFFDFFFFFD
                      FFFFFDFFFFFCFFFFFCFFFFFCFFFFFEFFFFFDFFFEFAFFEFF6FFD6F0FEB4E3F990
                      D4F179CAEB3ABFE545D8FF38D3FF60D6FF066ECB3678D1E5DCD9F3F8FBFFFFFF
                      0000FFFFFFFAF7F949BDEC46C4E6E5F8FF68E7FC4CE6FF44E9FA4BDFFF7EEEFF
                      E2EEFFFCFBFDE9FFFBFFFAFBFFF8FCF5FFFBFFFFF7FFFFF7FFFFF9FAFDFBEEFA
                      FEE6FCFFDCFAFFCFF4FFC3ECFFDCEFFCFAFDFFFFFEFEFFFEF8F7F8EFF0FBF9F4
                      FDFFF6FAFFFDFFF9FFFFFEFFFEFFFDFDFFFEFCFFFFFEFFFFFFFCFFFDF5FFFCFE
                      FFFCFEFFFDFFFFFDFFFFFDFFFFFDFFFFFEFFFFFEFFF9FEFDFDFFFFFFFFFFFDFF
                      FFF4FCFFE0F6FFCDEEFFBFE9FF8CD5FB5FCCF233C5F55BD4FC1781D93474CCE2
                      DADAF2FEFFFFFFFF0000FFFFFFFAF7F949BDEC46C4E6E5F8FF68E7FC4CE6FF44
                      E9FA4BDFFF65EFFFB8EBFFE3F5FFEFFFFFFFFBFFFFFDFFFFFFF4FFFFE9EFFBFF
                      DBEBFBBDD7EFA3C7EB8FBEF181BAF872B3FD6AAFFE97BAF9BCD3FFE5EFFFF8FF
                      F9F8FFF4F6FFF9FBFAFFF7E9FFFDFDF7FFFFFCFFFFFFFFFEFFFFFDFFFDFEFFFB
                      FFFFF5FAF9FEFBFDFFFCFEFFFCFEFFFDFFFFFDFFFFFEFFFFFEFFFFFEFFF3FBFA
                      F9FEFCFFFFFCFFFFFBFFFFFCFFFEFFFDFDFFF8FDFFDEEAFF7AC3E137C4E95DDF
                      FC32A2F43676CBDED8D9E7FAFFFFFFFF0000FFFFFFFAF7F949BDEC46C4E6E5F8
                      FF68E7FC4CE6FF44E9FA4BDFFF3CE1FC98F4FFE8FFFFFFFFFBFFFCFFFFFBFFE6
                      F9FFC7DEE674B7FC64A8F14A93E53481DD2478DE1A73E5126FE80D6CEB257FF5
                      3D87ED699EE79EC4EED1EEFCF4FFFEFFFFF7FFF6EBFCFDF9FFFFFBFFFDFDFDFA
                      FCFEFDFFFBFEFFF8FEFFF2FBFFFEFBFDFEFBFDFFFCFEFFFDFFFEFDFFFFFEFFFD
                      FFFFFDFFFFFEF9FBFFFBFCFFFFFBFFFFF9FFFFF6FFFFF7FFFFFCFBFFFEF3F6FF
                      81CFE63FDCF661F3FF47C0FF3F80D1E7DCDEE3F1FDFFFFFF0000FFFFFFFAF7F9
                      49BDEC46C4E6E5F8FF68E7FC4CE6FF44E9FA4BDFFF24D7FC76F3FFE8FFFBFFFF
                      F0FFFAF9CFE7FF87C0FD4C9CE9137BEC0D74E8096EE2076BE10C6DE5116FEA13
                      70ED1470ED007AEE036BE41461DB336EDC6193E69FC3F1E0F3FBFFFFF7FAFFFF
                      FBFFFFFFFEFFFDF8FAFBF8FAFCFDFFF8FEFFF3FDFFFFFCFEFFFCFEFFFCFEFEFD
                      FFFCFEFFFBFFFFFBFFFFFAFFFFFFFAFFFFFCFFFFFEFFF8FDFBEBFCF8DDFAF7D3
                      F9F9CCFAFBC1F6FF70DEF640E9FF56ECFD39B3F94183D2F5E5E6EEF2FDFFFFFF
                      0000FFFFFFFAF7F949BDEC46C4E6E5F8FF68E7FC4CE6FF44E9FA4BDFFF34E2FF
                      53EDFAC4F7F3FFFBF9D5E4F770AFEC2E83E90577F30B76E90E75E91276E61C79
                      E6277EE62E80E53380E1327DDF127ECF1976DD206CEE1760F01360E52C7BE26E
                      B4F7ABE6FFEFFEFFF4FDFFFBFEFFFFFCFEFEF8F9FEFCFCFAFEFFF5FEFFFFFCFF
                      FFFDFFFFFDFFFEFDFFFAFEFFF9FEFFF7FFFFF7FFFFFFFBFFF8FCFFEAFDFFD7FD
                      FFC1FAFFACF6FF97EFFF8AE9FD6CDCFF49CDF533CAF64CC7E31988D13078C5EC
                      E3DFF1F3FBFFFFFF0000FFFFFFFAF7F949BDEC46C4E6E5F8FF68E7FC4CE6FF44
                      E9FA4BDFFF4DE6FF3CE8FE86E2FBBFD3FF6EB5F82089E41571E2117BF01F81EC
                      2080EB2180E8237FE6247FE2267DDF2379D92377D61C76CE2478DE2C7BF42279
                      FF096DF10468DF247DE54F99F7D1E6FBE5F4FFF8FDFFFFFEFFFFFDFAFFFDFAFE
                      FFFDFAFFFEFFFDFFFFFEFFFFFEFFFCFEFFFAFEFFF6FEFEF3FDFDF1FDFDD7FAFF
                      C9F6FFB6F1FFA3F1FF8BEDFF72E3FF59D2FC45C5F61CB1F326A7E6359EE170B6
                      E52079CA2F7DC9DADFD6EAF3F6FFFFFF0000FFFFFFFAF7F949BDEC46C4E6E5F8
                      FF68E7FC4CE6FF44E9FA4BDFFF50D9F92DE7FF58D2FF66A4FE1487F00079E824
                      7AE43585E2197CE8187AE81579E91179EA0F79EC0F79EE0D79EF0B79EF1F7BFC
                      136DEA0D69E01175E50E7BE41476DA2872D84176DEB0C9E3CCDFF4F1F7FFFFFE
                      FFFFFFFCFFFFFBFFFFFBFEFFFBFFFDFFFFFEFFFFFEFFFDFFFFF8FDFEF5FDFDF0
                      FCFCEFFDFCABF3FF9DECF988E4F575E1F963DBFF49CCFD2DB4F216A1E60094E7
                      1B8BDD4889DEA8C6FF468DE44095DDD2E5D6E3F8F5FFFFFF0000FFFFFFF4F6F7
                      48C8F33ECBE6DDF7FE6FE8FB54E6FF42E7FA42E2FF45EFFF45E0FF25A8F70E7F
                      E01E86E92489EB1C81E42186ED0F7EEA277FF1317AF31878EE007CEE0084F100
                      80ED1676E7066ED10A7DEF0882FE0D7AED2178DA357CDD2A76E71267ED4E7CEB
                      51ACEFE1FAFFFFF9FCFFFEF0F8FFF9FFF7FAFBFFFFFFFAFFF3F7FFDEF0F7E1F8
                      FFDBFCFFB9F4FE8DEEF873F2FB8CE8FF86E9FF83E9FF87EAFF8AE7FF7EE2FE63
                      DBF84ED6F249C2EC21AEDB4697DA7AAFFF3192E24182BFD5D5F3EAFBF7FFFFFF
                      0000FFFFFFF8F5F74CC7F342CAE6E0F7FF71EAFA57E7FF43E8F944E3FF42E3FF
                      35C9FD1D9DF01181E51A84E91F88E91A85E71C85EE188CF7147FE8187ADE2482
                      E12B89E22D87DF3486DF3E8AE42F8BDA157EDF0073E60376E8187CE2237BDF1C
                      75E41170EF366FE33B99E5B9DAFFFFF8FFFCFEF8EDFFF8F9F8FCEDFDFFDBF8F5
                      CEF1F4C1F2FABAF6FFA6EEFF89E0FB79DCF877E2FE93E8FE92EBFF91EDFF92EB
                      FF91E7FD89E6FD7BE8FE70EBFF67DDFF53DBFF63BDF469ACF7187FC83C7FB8D8
                      D8F6F3F8F7FFFFFF0000FFFFFFFCF5FA4FC6F345CAE6E4F7FE77EBFC5AE9FF46
                      E9F845E4FF41D5FF24ACEC148FE91889F11886EC1887E91B8BEF1787F1138AF1
                      0C84DE2A94DB6BB6EE9EC6FAAAC1F3A4C0F6A5CCFF7FBBEF4594DD1077D80778
                      E60F7EEA1078E30F74E11178EC1E64DF2185DE7BAEE6F2E6FFF8FEFFDFFEFDDF
                      FAFFCEF5FFB4FBF1ACF7F999F0FF78E4FF55D1FA4AC1EE66C8F289D5FFA9F1FF
                      A9F4FFA9F4FFA4F0FF9EECFD97ECFC94F2FF96F8FF82F2FF79F7FF7DDFFF6BC5
                      FC1D8DC93F86B8D2D5F1FFF7FBFFFFFF0000FFFFFFFFF4FA51C5F447C9E6E8F8
                      FF7EEDFD64ECFF4EEAF74CE3FF43CAFF1898E31188EB2093FC178BF0148AE91A
                      91F4158BF21385E03B9CE682C6F5CFF1FFF4FDFFFDFCFFFAFAFFF3F9FFD5EBFF
                      9AC4F1529AE72585E9107CEC0A76E60E74E4177AE61165E61379E3468AD7C5D4
                      FFEDFBFFCCFAFFB6F6FFA0E6FF87EAF878DFFA56CDFA2EBCF319B2E936BAE97E
                      D2F6BEE7FFBCF9FFBFF6FFBDF4FFB3F1FFA5F0FE9FEEFBA0EFF8A5EEF686F0FB
                      81EFFB83ECFF81ECFF4DC0EB54A1C8C6D2EAFFF6FFFFFFFF0000FFFFFFFEF3FB
                      51C5F448C8E5EDF9FF87F0FE6FEDFF5BEBF757E3FF3BBAFF138EE41187EE1F95
                      FE168FEF128DE71993F1158DF13A99DE8FC5FCE7EEFFFFFCFFFFFFF7F8FFF5FD
                      FFF9FFF2F4FFFBFFEBF1FFA7CCFF549AED1F7AE61075E91878E92078E21170EF
                      1378EC2176D295BAF8E3F5FFADECFA73DFF761C9F847BAED35B2EC18A6E709A3
                      E420B4EA62D2F6B6F1FFECFFFFC5F8FBC8F3FCC6EFFEB9F1FFA8F6FFA0F5FFA5
                      EEFCAEE8F489ECF491EBF288EFF884F9FF74E1FF77C7E6BBD9EAFFEBF3FFFFFF
                      0000FFFFFFFAF6FC4DC5F348C8E5F1F9FF90F1FF7BEFFF68EBF567E1FF2BA7F5
                      1590EC1089F01591F71190EC1090E31792EA1A90EF7BBDE6D3E6FFFFF5FFFFF4
                      F7F1F4E5EDFFF2FAFFF7FFF7F1FFFDFEFFFCFFDFEDFF83B5F13585E41878E91D
                      7BEC247BE31579EF1977EE0F70D8649EE6C6DAFF8EDDF231C3E627AFEF29ADFA
                      15AFF807B0F31BBAF45DD3FDA9EFFFD9FCFFE8FCEFCBFAF8D4F6FCD2F2FFBAF2
                      FF9DF4FF93F5FFA5F2FFBBF1FF90F1FBB4F9FF9AF6FB76EAF582E2F992E5FBB0
                      E7F0E7DCDFFFFFFF0000FFFFFFF3F6FE47C5F544C9E5F2FAFF97F3FF86F0FF76
                      EAF573DFFE1895E91C98F61290F60B8DEE1296EA1698E51A95E52698F2BCE1EF
                      ECF7FFFFFAFFFFF6FDFAF5F4FBFFFCFDFFFCFFFFFCFFFBFAFFFFFCEFFBFFA7D3
                      F84F9FEC187EE8117AE91D80E8157AE61F76EC0C73E0448BDBB3CAF885E1FA0D
                      BFE810B2FF21C4FF0CCCFF05D1FF35D6FC90E6FFDCF7FFE7FAFFCFF1EAD0FEF8
                      E0FDFFDAF6FFABE6FF72D6F962D2F685DDFFB1E9FF94F3FFC6F9FFA6F6FD7DE8
                      EF98E7FA9BF0FF9BE8EAD2DAD9FFFFFF0000FFFFFFEDF7FE44C6F542C9E5F4FA
                      FF9AF2FF8CF1FF7EEAF57CDEFC0F8FE221A2FF1597FC088CEA149BEC1E9FE821
                      99E533A2F8E8F9F6EAFEFFEFFFFFFBFCFFFFF9FFFFF9FFFFF5FBEFF3F4EFFFFE
                      F4FFF5ECFFF6BAE9FE62B6F71584E60376E41685ED1377DD2073E71079E83684
                      D7AFC6F88BEEFF07CAF613C5FF0DC9FF00D5FF00DAF532D9EE9FE2F9F2F5FFF1
                      FCFFCBFBFFCFFBF4E0FDFFD6F1FF93D1F741ADD727A2CE58B6E495D0FF90EFFF
                      BFE8FEA8F0F892F8FDB5FBFF9AF0FC83E1DDCCE3DEFFFFFF0000FFFFFFF1FAF7
                      56C5F550CBEDE2F4FB98F7FF93E8FE88F0FF43C3F618A4E7129AF42098F7079E
                      E91A9FF60C93FB009BE87FC6F8FDFAFFFAFCFFFAFFFFFFFFFEFFFCFCFFFAFBF4
                      FAFFE4FCFFF8F7FFE7FBFFB7EBFC90DEFF54B3F81B81E1147EE91481ED1681E3
                      2474F10E7EE2227BF469A7F5DCF7FF2DDCF706CFFF12C7FF1AD9FF03CEFB48CD
                      EFD7F4FFE8FFFFD1F9F4FFFAFFFEE9FFF8FFF8C2F8F860BBFF1491FF0793F811
                      96EE1787EB5BB7FE64CDF99AF6FFBDF8FFA4E1EBA1F4FFB0FCFFA3D0E5FFFFFF
                      0000FFFFFFF0F9F656C5F551CCEEE3F5FC98F7FF92E7FD86EEFF40C0F316A2E9
                      119AF6219AFA089FEA1CA0F41195FA009FE98DCEFBFFF3FAFFF8FBFDFFFEFDFF
                      FCFFFFFFF8FEFFE3FDFFD2FDFFA1E1FA95E5F675D9EB61D3F73DB0F31381E017
                      80E91D80EC1582E42375F20C7EE2217AF368A6F4DEF7FF2FDBF708D2FF18CCFF
                      1ADAFF00D0FA49D0F0E0F2FFF8FFFFDAFAF5FFFBFFE6F9FEE9FFFD9AE3F120A4
                      E4008CE530A2E93DA7E41392D71D85DE2497D46BCFF1B1F3FFAFEBFBA4F3FFAF
                      F4FEB1D1DCFFFFFF0000FFFFFFEFF8F556C5F551CCEEE4F6FD99F8FF91E6FC83
                      EBFF3DBDF013A0EB0F9AFA229DFD0AA1EB1FA2F31797F60DA6E9A3D7FFFFFDFB
                      FFFFFCF6FFFEE9FFFFDAF8FDC0ECF99FE4F588DFF344D1EC40D5E931CEE232D0
                      F424B3F60E89E51A83EA2382EA1685E72477F10B7EDF1D79F066A4F0DDF7FE31
                      DEF80CD4FF1CD1FF19DBFF00D3FA48D4F3E8F0FFFFFBFFEBFCF8F7FDFCE4FFFB
                      D8F8FF73C8F6069AE023A7E39DD7FAB0E2FE65CAF0238AEB1B90D55CC2ECB2F3
                      FFBDF8FFAAF4FFB6F0F5C7DBDCFFFFFF0000FFFFFFEFF8F556C5F552CDEFE5F7
                      FE9AF9FF91E6FC82EAFF3ABAED0FA0EC0F9DFC21A1FF0BA5EC20A3F21D9AF619
                      ACEAB3E0FFFFFFFEEFFFFFCCFCFEACF1FA90E4F673D7F351CDEF39C8ED26D4F8
                      24D8F51AD3ED24D8FF1DBEFF0B93ED1989ED1F84E71788E82379F1097FDE1C78
                      EF65A4EEDFF6FE34DFF90FD6FF1DD4FC19D9FF00D5F93FD8F5DEECFFFFF9FFF9
                      FFFDF6FFFFF3FFFBA8D5FA3C9FF11892E673BDEDEBF4FEFAFDFFC1EAFF87CFFF
                      6FC9F88CDDF8C0F5FFC3F5FFB1F3FEBEF1F4D7E3E3FFFFFF0000FFFFFFEFF8F5
                      56C5F553CEF0E6F8FF9AF9FF92E7FD82EAFF3BBBEE11A3EB0E9FFB20A5FF08A9
                      ED21A8F2209EF61EB0ECBAE3FFD2F4FAB2EDF689E5F267DCF151D6F73FD5FE29
                      D6FF1AD6FF35D9FF31DFFF25DAFA2CE0FF22C5FF0A98F1118CEC1585E5168AE8
                      237AF2097FDE1C79EE65A4EEDFF7FD36E0F815D7FF1AD6F91DD3FD01D3FB30D9
                      F8BCE5FEFFF8FFFAFFFFF8FFFFF1FBFF65BCF5098DF244A3FAB7D9FDEFF9F9F0
                      FAFAEAF0FFDCFBFFC8FBFFC6FAFAD3F3F8C9EFFBB9F3FFC3F1F9DCE2E7FFFFFF
                      0000FFFFFFF1FAF757C6F653CEF0E6F8FF9AF9FF93E8FE85EDFF3EBEF114A8EA
                      0EA3F91DA8FE05AEEC1DADF41CA3F91AB0ECB4E1FFB8F2FE95EAF968E0F34AD9
                      F53CD8FC35DAFF2BDEFF20DFFF40D6FF3EDDFF31D9FB32DDFF23C2FF0795EE0E
                      8CEB1488E7148BE8217BF10881DE1D7AED67A5ECE2F8FE38E0F717D8FF15D9F9
                      26CEFD0BD2FF19DAFB87DFF7DFF0FDF4FFFFFFFDFFC4E7F52EAAE60092EB6BC2
                      FFDBF7FFE1FFFED7FEFFEFFCFFF3F4F0E9FFF5E2FFF4E5F8F5D8F4FFC2F6FFCC
                      F1F9EBEAEEFFFFFF0000FFFFFFF2FBF858C7F753CEF0E5F7FE9AF9FF94E9FF88
                      F0FF42C2F519AEE70FA7F51BAAFB00B0EC19B2F719A6FD12AFEEAADCFFBDFAFF
                      9EF4FF75EBFC5CE6FD54E4FF51E2FF47E0FD3FDEFA3BD5FF3BDEFF2EDAF832DC
                      FF21BCFF0890EA158AEB1F8AEB118BE51F7CF10883DF1C7CEE69A7EEE5F9FE3A
                      E0F717D7FF11DCFD32CCFF1AD2FF08DCFF4ED8EFACE8F4EAFDFFFFF9FFA6D7E5
                      46AAE133A4E698DAF3F0FFFBECFDFADAF5FFEAFFFFF1F2F6E1FDF7DDFFF8EAFD
                      FFDEF8FFBDE9F6CDE6E8FFF7F1FFFFFF0000FFFFFFF3FCF959C8F853CEF0E5F7
                      FE9AF9FF95EAFF8AF2FF45C5F81DB1E510AAF319ABF700B3EB18B4F915A7FF0D
                      ADEDA1D8FFBEF2F8A3F1F883EFFB73F0FF75F0FF77EEFF70E9F968E3F133DAFF
                      34E2FF2ADDF82EDDFF20BCFE0B8DE61D8AEC2C8DEF118BE51F7CEF0883DD1D7D
                      EF6AA8EEE5F9FE3CE0F716D6FF12E1FF3BCCFF22D4FF00DCFF29D4EA8AE3EEDF
                      F8FFFFF4FFD1F9FFA7D6FFA2D6FFDBFDFCFFFFEEFFFBFEFEF1FFEEFCFBEDFAFF
                      D7FDFFCCF8FFE0F9FFD5F0FFA9D1DDC3D4D0FFFEEEFFFFFF0000FFFFFFF0F7FF
                      66D1FF3CCAE3E6FBFCB7F2FF9CECFF73EFF77DDCFD00ADF510AAF520ADF81DB1
                      F709B0EF07AEE728B7F051C8FFEDF5FF90F1F45CECED82E9F8A6E7FF8FE8FF72
                      E9FF6FEAFF77EFFB6BE8F75DE2FD51DAFF37BCF81996E61586E71F89F42C89E4
                      097FEE1A8DFF167BDD96ABE9BEF8FF16E8F61ED6FE17D1F92CD5FF37D7FF29D7
                      FF1ED7FD3CD8FB87DDFFC7E0FFFFFAFBFFFBFCFFFEFBFFFFFCFDFFFEF6FFFFF1
                      FFFFEFFEFFFFFDE4E6FFEEE5FCFEFCF4FE5EADE6308FCEE6E0D9FAF6FFFFFFFF
                      0000FFFFFFF0F6FD68D1FF3DCBE4E7FCFDB6F1FF9BEBFF75F1F982DFFE0AB2F9
                      12ADF61CADF818B2F90AB2F207AFEC23B5EF44C0FCE1F4FFA6F5FF74F3FC6EEB
                      FA7AE4FC7AE2FF75E3FF75E3FF73E8F171EBF969EAFF53D9FF32B6F21794E613
                      86E71C89F32489E51182F00884F6247EDCA1B7F1ABF2FF23DFF122D5FC11DCFF
                      24DCFF2DDBFF20DAFF0FD6FC21D6F658D6F98AD8FDE7F7FFF1FAFFFFFEFFFFFF
                      FCFFFFF8FFFFF6FFFBF0F9F7EDFBFEFFCFFFFFBBE2FED0D3EF4193DA2382CBDF
                      D9DAF6EFFEFFFFFF0000FFFFFFF1F4F96AD1FF41CCE6E8FDFFB4F0FF9AEAFF79
                      F3F98BE6FF1AB9FB18B1F618ADF714B3FD0BB5FC07B0F319B2F131B8F6ADE3FA
                      B3EFFF97F4FF6AEEFF5CE8F977E8FF8AECFF84EBFF75E4EE7BF0FF72EFFF50D1
                      FE29ABEC1591E51388E91987F11989E91E88F3007BE2408CDFB4CEFF90EDFF3F
                      DAEF31D8FD14E4FF22E1FF2ADDFF1FDAFF0DD9FC0ED7F82AD4F645D2F77BCCF2
                      95D5F8BBE3FFE0F1FFF6FCFFFAFEFFF4FFFFEFFFFFBAE4FF7BD3F870B2E79EB0
                      DF2D87DB2587D5E8E1E4FCF5FFFFFFFF0000FFFFFFF4F3F56CD2FF42CDE7E6FD
                      FFB1EFFF99E9FF7FF5FA94ECFF31C3FD20B5F513AEF30FB4FD0DB8FF0CB4FB14
                      B1F31FB4F463D4E8ADE8FFC1F4FF88F1FF67EBF583EDFE8FF0FF78EEFF80ECF8
                      82F2FF6CE4FF41BFF51F9FE61794E9168EEE1586EE1189ED278EF50079D267A1
                      E9C2E6FF7CECFE60DCF449E2FF2DE5FD37E0FC3FDBFE38DCFF29DDFF1FDDFF24
                      DAFE2DD6FC1FBEF835C0F956C3F973C7F782C9F580C8F274C6EF6AC5EC55AAE8
                      2CABDE47A4E395BAEC389DEC339AE3EEEBE6FBF7FDFFFFFF0000FFFFFFFAF6F5
                      6FD5FF42CDE7E3FCFFB1EEFF9AEAFF82F8F99AF0FF4DCEFF2FBDF412B0F00BB5
                      FD0FBAFF12B6FF13B3F915B5F525CDDF8EE1FDCEF0FFAFEFFF8AEBF590ECF782
                      EBF85BE6EF86F2FF78E9FF56CDFE2AA8E81796E51B96F01A92F21388EB0F85EF
                      238EF00D82CD8BB7F4C0F6FF6FECFB76E2FA61E9FF59E4FF5EE0FD62DDFD60DE
                      FF57E1FF4AE1FF41DEFF3EDBFF23E0FF2BDAFF38D0F93FC4F03CB9EB2FB3E91E
                      AEE811ADE941B5EC2DC4F05ECCFFB4E4FF4BB6F936A2DCE3E8D3EBEFE9FFFFFF
                      0000FFFFFFFFFBF672D6FF41CCE6E0FAFFAFEEFF9CECFF86FBFA9EF0FF6EDEFF
                      43C8F417B7ED0AB5F912B9FF15B6FF12B5F90FB8F600B8DE50C9F19CDBFFABE5
                      FFA0EDFF95F5FF81F5FF65F0FF73E5FF5CD2FF36B2F21A9AE71292EB1995F31A
                      92F1178BEA147FF21289E63B92D4ACCEFCABF6FF69E8F77CE6FE71EAFF7CE7FF
                      7BE6FF7AE5FF78E6FF75E6FF6FE3FF66E1FF5EDFFF56F6FC58F1F85AEAF559E4
                      F457E1F752E1FF4BE4FF49E6FF5BD6FC4AE7FF7CECFFC9F5FF52B9F02F9CCFE0
                      E6CFECF4EDFFFFFF0000FFFFFFFFFFF875D7FF3FCAE4DEF8FEAEEFFF9EEEFF89
                      FCF99FF0FF8DEEFF57D5F71EBEEE0CB7F512B6FF18B3FC11B5F60ABAF605A9F1
                      13B1F13CBDF46BCDFB7CDDFF6DE5FF66E4FF70DEFF4AC5FF34B2F31D9EED1296
                      F11092F3118EF0178DEC1C8FEA2380F90289DF71AAE7C7E2FF92F2FF6CE6F67A
                      EDFF7AE8FF83E7FF7BE9FF74ECFF75ECFB79E9FB7BE8FE79E6FF74E5FF7CEFFC
                      78EEF973EFF76EEEF36CEEF56DEDFA71EDFF72ECFF71E3FA5EEFFE89EDFFCFF0
                      FF54B1E83397D1E3E7DBF1FBFFFFFFFF0000FFFFFFFFFFF778D8FF3EC9E3DDF7
                      FEAFF0FF9FEFFF89FCF9A0EFFCA2F9FF64DFFB24C4EE0CB8F413B3FB16B0F911
                      B4F30ABBF428B0FF00ACFF00ACF126B5EF3DBDF22ABCEC30B1E856A7EA28A7EB
                      189AE71095ED1398FA1093FA0C88EC1289E62194EB3084FF008CDE97BDF7D8F1
                      FF84F0FC71E8F777F2FF80E8FF76E4FE6EE9FD64EEFA66EFF770ECF67BEAFA81
                      ECFF80EEFF7FDDFF7BE2FF77E8FF73EDFF75EFFF7CEDFD83E9FB88E5FA83EAFD
                      6CF2FC93EBFFD7EEFE5BAFE93595D7E3E3E3ECF3FFFFFFFF0000FFFFFFFFFBFF
                      AAE1FF30C7ECA7E6EAEBFFF38CEEF48FF1FF99FAFF9CFFFD82F0FC58D5FB33BF
                      FC1CB3FD12B2FA11B4F313B5EF18B3FC15B2FB12B2FA0FAFF70EABF510A7F211
                      A3EF12A0ED1D9DFF1297F80994EB0797E6119CEC1D9CF12192F21F89EE3287D5
                      77B7F7AFE3FFA9EEFD83ECEF6DEFF66EECFF73E2FF7AE9FF7AE9FF7AE9FF7AE9
                      FF7AE9FF7AE9FF7AE9FF7AE9FF7EEBFF7EEBFF7EEBFF7EEBFF7EEBFF7EEBFF7E
                      EBFF7EEBFF86E6FF81EFFB92F1FBF4F5FF3DB0E345A0E3CEDED3F9F8FCFFFFFF
                      0000FFFFFFFFF6FBD7EFFF41D0EB62DBE5EDFCFFC8F6FF82EBF691F5FF9FF6F8
                      8FEEFD73E0FF4DCDFE2ABCF811B3F407B4F304B7F413ACF111ACF110ACF211AD
                      F311ABF215AAF419A8F31DA7F3099DEF159FF2229EF6299BF52694F31A8EED0D
                      8BEA0489EA65B0EE8CD3FFA7EEFF9AEEFF80E9F277EDF976EDFF75E6FF7AE9FF
                      7AE9FF7AE9FF7AE9FF7AE9FF7AE9FF7AE9FF7AE9FF7EEBFF7EEBFF7EEBFF7EEB
                      FF7EEBFF7EEBFF7EEBFF7EEBFF86E6FF81EFFB92F1FBF4F5FF3DB0E346A1E4CE
                      DED3F9F8FCFFFFFF0000FFFFFFF8F4FAFFFBFF73E0EE20CBE3CAEEFFFFFAFF84
                      E8E38EF1FF9EEDF69EF1FF91F0FF72E1FF48CBF61EB9F004B3F200B5F91EB2F8
                      1BB1F715AFF613ADF410AAF312A7F115A3F016A2EF11A0E41DA3F125A0FA2396
                      F71988EE1586E71C92EB279EF39CDCFF9DEDFF93F5FF83ECFF7EE5F884EBFE81
                      EEFF76ECFF7DEAFF7DEAFF7DEAFF7DEAFF7DEAFF7DEAFF7DEAFF7DEAFF81EDFF
                      81EDFF81EDFF81EDFF81EDFF81EDFF81EDFF81EDFF86E6FF81EFFB93F2FCF5F6
                      FF3DB0E346A1E4CFDFD4F9F8FCFFFFFF0000FFFFFFECF6FDFFFFF8C5EFF624C5
                      EB78D7FFFBF8FFAAEFE597F4FF97F1FC9CF7FF9FFAFF8FF2FF6FE0FA45CBF523
                      BBF60DB1F91BB0FA18AFF913ADF80EAAF70CA7F60DA4F510A1F612A0F52B9FEC
                      1E9EF10A96F3008DED0089E52697E75FB3F488C9FFB4EDFC9AF2FF78F1FF6EE8
                      FE7FE6FF8FECFF89EFFF77F0FA7EEBFF7EEBFF7EEBFF7EEBFF7EEBFF7EEBFF7E
                      EBFF7EEBFF81EDFF81EDFF81EDFF81EDFF81EDFF81EDFF81EDFF81EDFF87E7FF
                      82F0FC93F2FCF5F6FF3DB0E346A1E4CFDFD4FAF9FDFFFFFF0000FFFFFFF0FCFF
                      EBFEE9FFF8FD72CEF929C5F0B8EBFBD3F7F7ABFAFF8BF5FF8EF6FB96F7FA9AF8
                      FD92F3FF7AE3FF5ACDFF44BCFD17A9F115A8F010A7F20CA6F30CA4F50DA3F712
                      A3F915A3FC1F9BF31296F10793EE0A95EC29A4EE5EBEF398DBFABFF0FFACF0F5
                      8EF0F670EDFB6EEBFF85ECFF94EEFF8AEFFE78EDF481EDFF81EDFF81EDFF81ED
                      FF81EDFF81EDFF81EDFF81EDFF84EEFF84EEFF84EEFF84EEFF84EEFF84EEFF84
                      EEFF84EEFF87E7FF82F0FC94F3FDF6F7FF3EB1E447A2E5D0E0D5FAF9FDFFFFFF
                      0000FFFFFFFBFCFFD8F9EAFFF9FFCDE1FF29C8E26BDAF0D2F3FFBBFBFF8CF6FD
                      8CF2F790F1F49AF7FAA1FCFF9BF6FF8BE5FF7CD5FF43C4FD3CC1FB32BAF527B2
                      F11EAAED1BA3EB1A9EEB1B9DEA10A4F01DA4F03AA8F45DB5FB80CCFF97E2FFA2
                      F3FBA3FAF698F3FC88EFF87CEEFB7FF1FF8CF2FF8DF0FF85ECFB7CEAF682EEFF
                      82EEFF82EEFF82EEFF82EEFF82EEFF82EEFF82EEFF86EEFF86EEFF86EEFF86EE
                      FF86EEFF86EEFF86EEFF86EEFF88E8FF83F1FD94F3FDF6F7FF3EB1E447A2E5D0
                      E0D5FBFAFEFFFFFF0000FFFFFFFFF7FAE4F8F9FCF9FBFFF8FB7AE0EC3BCEEE9E
                      E0FFBDF3FAAAF5FDA3F3FA99F1F896F4FA97F6FF9BF7FF9AF2FF97EEFE80EBFF
                      79E5FF6CDDFE5FD2F754C7F24DBFEE4BB9ED4AB7EB48C5F75CCAFA7DD2FF9ADD
                      FFA6E8FF9FEEFF8EF2FE7EF2F97FF5FF85EEFF8EEDFD93F2FF8BF4FF7FEFFC7F
                      EBFC86ECFF84EEFF84EEFF84EEFF84EEFF84EEFF84EEFF84EEFF84EEFF86EFFD
                      86EFFD86EFFD86EFFD86EFFD86EFFD86EFFD86EFFD88E8FF83F1FD94F3FDF6F7
                      FF3FB2E548A3E6D0E0D5FBFAFEFFFFFF0000FFFFFFFFF1F5FBFAFFCEF6F4FFFF
                      F2CDF7FC2FC9F26ACFFCB9ECEFC9F8FFBDF8FFABF5FF98F1FF8AEFF88AF0F594
                      F6F69CFBF79BF3FA97F0FA90EEFB8AECFC89ECFF8BECFF90EDFF94EEFF9FE8FF
                      A4EEFFA7F3FFA2F4FF95EFFA86EAFC7DE9FF7AEAFF6CF3FF81EAFF99E8FD9DEF
                      FB87F1F874EDF67BEBFD8EEFFF85EFFF85EFFF85EFFF85EFFF85EFFF85EFFF85
                      EFFF85EFFF87F0FE87F0FE87F0FE87F0FE87F0FE87F0FE87F0FE87F0FE88E8FF
                      83F1FD94F3FDF7F8FF3FB2E548A3E6D0E0D5FBFAFEFFFFFF0000FFFFFFFFFAFD
                      FCFBF7F4FBF4FFFAF7FDF4FECBE9FC6DD9F120CEE5D9EFF5C3F6F8A9FBFC9AFA
                      FA99F1F79FEDF4A3F0F9A5F6FEA0ECFFA0ECFFA0ECFFA0ECFFA0ECFFA0ECFFA0
                      ECFFA0ECFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF86ECFF
                      86ECFF86ECFF86ECFF86ECFF86ECFF86ECFF86ECFF84EBFE84EBFE84EBFE84EB
                      FE84EBFE84EBFE84EBFE84EBFE88F0FF88F0FF88F0FF88F0FF88F0FF88F0FF88
                      F0FF88F0FF99F8FF75EBF0ADFFE4DFFEF54EB4E946A2D3F1E2E6D5FFEDFFFFFF
                      0000FFFFFFFFFCFDF6FDFAF3FFF8FFFEFBFFFAFFF1F1FFACE5FB71DDF549CCED
                      86E2FBC7FBFFD3FFFFAEFEF184F5EB75F3F47BF5FF87F8FA87F8FA87F8FA87F8
                      FA87F8FA87F8FA87F8FA87F8FA8EF4FF8EF4FF8EF4FF8EF4FF8EF4FF8EF4FF8E
                      F4FF8EF4FF8EF3FF8EF3FF8EF3FF8EF3FF8EF3FF8EF3FF8EF3FF8EF3FF89F2FF
                      89F2FF89F2FF89F2FF89F2FF89F2FF89F2FF89F2FF89F2FF89F2FF89F2FF89F2
                      FF89F2FF89F2FF89F2FF89F2FF88EFFF74E6FDB0FFF6D9FAFF4AB2F5459DDDF6
                      D7ECF0F5F6FFFFFF0000FFFFFFFAF9FBF0FEFAF1FFF9FFFFFBFFFCFEFFF7FFF2
                      F2FFD2F0FF34D2F64DD0F17ED5EFB9E4F7E3F6FFE8FEFFCEFCFFB3F4FC92EEFF
                      92EEFF92EEFF92EEFF92EEFF92EEFF92EEFF92EEFF89F1F889F1F889F1F889F1
                      F889F1F889F1F889F1F889F1F88AF1FA8AF1FA8AF1FA8AF1FA8AF1FA8AF1FA8A
                      F1FA8AF1FA87F0F987F0F987F0F987F0F987F0F987F0F987F0F987F0F985EFF6
                      85EFF685EFF685EFF685EFF685EFF685EFF685EFF68BE5FD90E0FFC0F9FAD4FB
                      FF44BCF83AACE1F2E5F5FFFDFFFFFFFF0000FFFFFFFAF6FBF0FBF9EEFFF9F8FF
                      F7FFFDF9FFFAFCFFF8FFFFF9FFE2F2FF98DDF149C8E737C7F16BD8FFB8EBFFEE
                      F1FFFFEEF0C6F9F5C6F9F5C6F9F5C6F9F5C6F9F5C6F9F5C6F9F5C6F9F5B7F5FF
                      B7F5FFB7F5FFB7F5FFB7F5FFB7F5FFB7F5FFB7F5FFB7F4FFB7F4FFB7F4FFB7F4
                      FFB7F4FFB7F4FFB7F4FFB7F4FFB8F5FFB8F5FFB8F5FFB8F5FFB8F5FFB8F5FFB8
                      F5FFB8F5FFB8F5FFB8F5FFB8F5FFB8F5FFB8F5FFB8F5FFB8F5FFB8F5FFBAFAFF
                      CAF2FFD7FFFDC7F5F635B9E11CABC6C5DCD4EAF1EAFFFFFF0000FFFFFFFFF8FB
                      FBFBFBF1FFF9EEFFF6F3FCF2FAFAF4FFFBF8FFFDFAFFFFF5F3FEFFC6EBFF7CD4
                      FD38C4ED26C9E246DBE571EDEDCEF2FFCEF2FFCEF2FFCEF2FFCEF2FFCEF2FFCE
                      F2FFCEF2FFDFF7FDDFF7FDDFF7FDDFF7FDDFF7FDDFF7FDDFF7FDDFF7FDDDF4FC
                      DDF4FCDDF4FCDDF4FCDDF4FCDDF4FCDDF4FCDDF4FCDCF3FBDCF3FBDCF3FBDCF3
                      FBDCF3FBDCF3FBDCF3FBDCF3FBDBF1FCDBF1FCDBF1FCDBF1FCDBF1FCDBF1FCDB
                      F1FCDBF1FCB5F3FFD1EAFFCBEFFFBBE4F359B8EA4CB5D6E7E4E6FFF6FFFFFFFF
                      0000FFFFFFFFFCFEFFFDFEFCFFFDF1FFF9EBFDF6ECFDF4F0FDF5F6FDF6E3FEFA
                      FAFFFFFFFDFFFFF5FDCCE8F385DDEE45D9F121DAF639C2F039C2F039C2F039C2
                      F039C2F039C2F039C2F039C2F039BAF939BAF939BAF939BAF939BAF939BAF939
                      BAF939BAF936B6F736B6F736B6F736B6F736B6F736B6F736B6F736B6F734B2F3
                      34B2F334B2F334B2F334B2F334B2F334B2F334B2F330ADF130ADF130ADF130AD
                      F130ADF130ADF130ADF130ADF113B8C73DB2E530B9D341B8D12BA2E03AB0DABF
                      DFECECEDFFFFFFFF0000FFFFFFFFFDFCFFFCFBFFFBFCFCFCFCF3FEFCF1FFFBF5
                      FCF9FBFAF6FFF1FFF9F4F3E2FDEDECFFF2FDFFF7FFFBFFEEE9FFCAD3FEACEAF4
                      ACEAF4ACEAF4ACEAF4ACEAF4ACEAF4ACEAF4ACEAF495EBEB95EBEB95EBEB95EB
                      EB95EBEB95EBEB95EBEB95EBEB92E7E992E7E992E7E992E7E992E7E992E7E992
                      E7E992E7E992E5E792E5E792E5E792E5E792E5E792E5E792E5E792E5E78EDFE6
                      8EDFE68EDFE68EDFE68EDFE68EDFE68EDFE68EDFE697D8E6BDD3FF95D5F3ABD7
                      EFBBC6FFBCD0F3FFEDF1FFEDFFFFFFFF0000FFFFFFF2FCF6FAF8F7FFF7F9FFF9
                      FCFFFCFFFEFDFFFFFAFBFFF4F7EBFFFAF8FFF9FFFAF7FFF7F4F6F7F5F1FBF5FE
                      FFFBFFFFFCFFFCF9FFFCF9FFFCF9FFFCF9FFFCF9FFFCF9FFFCF9FFFCF9FFFAFD
                      FFFAFDFFFAFDFFFAFDFFFAFDFFFAFDFFFAFDFFFAFDFFF8FEFFF8FEFFF8FEFFF8
                      FEFFF8FEFFF8FEFFF8FEFFF8FEFFF9FFFFF9FFFFF9FFFFF9FFFFF9FFFFF9FFFF
                      F9FFFFF9FFFFF6FFFFF6FFFFF6FFFFF6FFFFF6FFFFF6FFFFF6FFFFF6FFFAF7E9
                      FFF4FFD7FBFBE5FFF7F8F4FFE2FCF6F8FFE4E5FFECFFFFFF0000FFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      0000}
                    Layout = blGlyphBottom
                    Spacing = 12
                    color_background_down = clBtnFace
                    color_background_up = 12320767
                    show_shortcut = False
                  end
                end
              end
            end
            object page_mail_indirizzi_defaultx: TTabSheet
              Caption = 'indirizzi default'
              ImageIndex = 2
              object txt_mail_default: TMyLabel
                Left = 0
                Top = 0
                Width = 205
                Height = 16
                Align = alTop
                Caption = 'indirizzi di destinazione default'
                Color = 16777162
                ParentColor = False
              end
              object panel_mail_indirizzo_default_elenco: TFPanel
                Left = 0
                Top = 66
                Width = 819
                Height = 291
                Align = alClient
                ParentBackground = False
                TabOrder = 0
                DesignSize = (
                  819
                  291)
                object txt_mail_indirizzo_default_elenco: TMyLabel
                  Left = 4
                  Top = 4
                  Width = 254
                  Height = 16
                  Caption = 'elenco indirizzi mail default (1 per riga)'
                  FocusControl = str_mail_indirizzo_default_elenco
                end
                object cbx_mail_indirizzo_default_elenco_SQL: TFCheckBox
                  Left = 663
                  Top = 3
                  Width = 121
                  Height = 17
                  Hint = 
                    'il testo indicato qui sotto '#232' una query SQL da utilizzare per re' +
                    'perire gli indirizzi email'
                  Anchors = [akTop, akRight]
                  Caption = 'istruzione SQL'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 0
                  AAA_NeedNotifyModification = False
                end
                object str_mail_indirizzo_default_elenco: TFMemo
                  Left = -1
                  Top = 22
                  Width = 795
                  Height = 235
                  Anchors = [akLeft, akTop, akRight, akBottom]
                  ScrollBars = ssBoth
                  TabOrder = 1
                  AAA_NeedNotifyModification = False
                  AAA_CanBeVoid = True
                  AAA_CanBeInvalid = True
                end
              end
              object panel_mail_indirizzo_default_funzionale: TFPanel
                Left = 0
                Top = 16
                Width = 819
                Height = 50
                Hint = '*** runtime'
                Align = alTop
                Color = 8454143
                ParentBackground = False
                ParentShowHint = False
                ShowHint = True
                TabOrder = 1
                DesignSize = (
                  819
                  50)
                object cbx_mail_default_00: TFCheckBox
                  Left = 8
                  Top = 8
                  Width = 133
                  Height = 17
                  Caption = '***'
                  TabOrder = 0
                  OnClick = cbx_mail_default_Click
                  colorChecked = 8454143
                  colorUnChecked = 8454143
                  AAA_NeedNotifyModification = False
                end
                object cbx_mail_default_01: TFCheckBox
                  Left = 145
                  Top = 8
                  Width = 133
                  Height = 17
                  Caption = '***'
                  Color = clBtnFace
                  ParentColor = False
                  TabOrder = 1
                  OnClick = cbx_mail_default_Click
                  AAA_NeedNotifyModification = False
                end
                object cbx_mail_default_02: TFCheckBox
                  Left = 282
                  Top = 8
                  Width = 133
                  Height = 17
                  Caption = '***'
                  Color = clBtnFace
                  ParentColor = False
                  TabOrder = 2
                  OnClick = cbx_mail_default_Click
                  AAA_NeedNotifyModification = False
                end
                object cbx_mail_default_04: TFCheckBox
                  Left = 8
                  Top = 29
                  Width = 133
                  Height = 17
                  Caption = '***'
                  Color = clBtnFace
                  ParentColor = False
                  TabOrder = 4
                  OnClick = cbx_mail_default_Click
                  AAA_NeedNotifyModification = False
                end
                object cbx_mail_default_05: TFCheckBox
                  Left = 145
                  Top = 29
                  Width = 133
                  Height = 17
                  Caption = '***'
                  Color = clBtnFace
                  ParentColor = False
                  TabOrder = 5
                  OnClick = cbx_mail_default_Click
                  AAA_NeedNotifyModification = False
                end
                object cbx_mail_default_06: TFCheckBox
                  Left = 282
                  Top = 29
                  Width = 133
                  Height = 17
                  Caption = '***'
                  Color = clBtnFace
                  ParentColor = False
                  TabOrder = 6
                  OnClick = cbx_mail_default_Click
                  AAA_NeedNotifyModification = False
                end
                object cbx_mail_default_03: TFCheckBox
                  Left = 420
                  Top = 8
                  Width = 133
                  Height = 17
                  Caption = '***'
                  Color = clBtnFace
                  ParentColor = False
                  TabOrder = 3
                  OnClick = cbx_mail_default_Click
                  AAA_NeedNotifyModification = False
                end
                object cbx_mail_when_unique: TFCheckBox
                  Left = 420
                  Top = 29
                  Width = 151
                  Height = 17
                  Hint = '* runtime'
                  Caption = 'principale if any'
                  Color = clBtnFace
                  ParentColor = False
                  TabOrder = 7
                  OnClick = cbx_mail_default_Click
                  AAA_NeedNotifyModification = False
                end
                object btn_help_set_mail_conto_00: TFBitBtn
                  Left = 770
                  Top = 8
                  Width = 24
                  Height = 26
                  Anchors = [akTop, akRight]
                  TabOrder = 8
                  TabStop = False
                  OnClick = btn_help_set_mail_contoClick
                  Glyph.Data = {
                    CE070000424DCE07000000000000360000002800000024000000120000000100
                    1800000000009807000000000000000000000000000000000000007F7F007F7F
                    007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F7F00007F7F007F7F007F
                    7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                    7F7F007F7FFFFFFFFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                    007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F00
                    007F00007F7F00007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7FFFFFFF007F7F007F7F
                    007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
                    7F007F7F007F7FFFFF007F7F007F7F007F0000007F7F007F7F007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF
                    007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
                    7F007F7F007F7F007F7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F0000
                    7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                    007F7F007F7F7F7F7FFFFFFFFFFFFF7F7F7FFFFFFF007F7F007F7F007F7F007F
                    7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                    007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F007F7F007F
                    7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F7F00007F00007F7F00007F7F007F7F007F7F
                    007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
                    7F007F7FFFFFFFFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F7F007F7F00
                    7F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
                    7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F7F7F7FFFFFFF007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                    007F7FFFFF007F7F007F7F007F0000007F7F007F7F007F7F007F7F007F7F007F
                    7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F7F
                    7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                    007F7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F007F7F007F0000007F
                    7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                    7F7F7F7F7FFFFFFF007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F
                    007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7FFFFF
                    007F7F007F7F007F7F007F0000007F7F007F7F007F7F007F7F007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF
                    007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
                    7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F007F7F007F0000007F7F00
                    7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F
                    FFFFFF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F
                    7F007F7F007F7F007F7F007F7F7F00007F0000007F7F007F7F007F7FFFFF007F
                    7F007F7F007F7F007F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                    007F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F
                    7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F7F007F7F007F
                    0000007F7F007F7F007F7FFFFF007F7F007F7F007F0000007F7F007F7F007F7F
                    007F7F007F7F007F7F007F7F7F7F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFF
                    FF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F00
                    7F7FFFFF007F7F007F7F007F7F007F00007F00007F00007F7F007F7F007F7F00
                    7F0000007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F7F7F
                    7FFFFFFFFFFFFFFFFFFF7F7F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F00007F7F007F7F007F7F007F7F007F7F007F
                    7F7F7F7FFFFFFF007F7F007F7F7F7F7F7F7F7F7F7F7F007F7F007F7F007F7F7F
                    7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                    FFFF00FFFF007F7F007F7F007F7F007F7F007F7F007F7F00007F7F007F7F007F
                    7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFFFFFFFF007F7F007F7F00
                    7F7F007F7F007F7F007F7F7F7F7F007F7F007F7F007F7F007F7F007F7F007F7F
                    007F7F007F7F007F7F007F7F007F7F007F7FFFFF00FFFF00FFFF00FFFF00FFFF
                    00007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F
                    7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F007F7F007F7F007F7F
                    007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
                    7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
                    007F7F007F7F007F7F007F7F007F7F007F7F}
                  NumGlyphs = 2
                  color_background_down = clBtnFace
                  color_background_up = clBtnFace
                  show_shortcut = False
                end
              end
            end
            object page_mail_indirizzi_availablex: TTabSheet
              Caption = 'indirizzi disponibili'
              ImageIndex = 3
              object txt_mail_default_available: TMyLabel
                Left = 0
                Top = 0
                Width = 603
                Height = 16
                Align = alTop
                Caption = 
                  'indirizzi di destinazione disponibili -- saranno inseriti nella ' +
                  'COMBO degli indirizzi disponibili'
                Color = 16777162
                ParentColor = False
              end
              object panel_mail_indirizzo_available_elenco: TFPanel
                Left = 0
                Top = 66
                Width = 819
                Height = 291
                Align = alClient
                ParentBackground = False
                TabOrder = 0
                DesignSize = (
                  819
                  291)
                object txt_mail_indirizzi_elenco: TMyLabel
                  Left = 4
                  Top = 4
                  Width = 278
                  Height = 16
                  Caption = 'elenco indirizzi mail disponibili (1 per riga)'
                  FocusControl = str_mail_indirizzi_elenco
                end
                object cbx_mail_indirizzi_elenco_SQL: TFCheckBox
                  Left = 663
                  Top = 3
                  Width = 121
                  Height = 17
                  Hint = 
                    'il testo indicato qui sotto '#232' una query SQL da utilizzare per re' +
                    'perire gli indirizzi email'
                  Anchors = [akTop, akRight]
                  Caption = 'istruzione SQL'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 0
                  AAA_NeedNotifyModification = False
                end
                object str_mail_indirizzi_elenco: TFMemo
                  Left = -1
                  Top = 22
                  Width = 795
                  Height = 235
                  Anchors = [akLeft, akTop, akRight, akBottom]
                  ScrollBars = ssBoth
                  TabOrder = 1
                  AAA_NeedNotifyModification = False
                  AAA_CanBeVoid = True
                  AAA_CanBeInvalid = True
                end
              end
              object panel_mail_indirizzo_elenco_funzionale: TFPanel
                Left = 0
                Top = 16
                Width = 819
                Height = 50
                Hint = '*** runtime'
                Align = alTop
                Color = 13302751
                ParentBackground = False
                ParentShowHint = False
                ShowHint = True
                TabOrder = 1
                DesignSize = (
                  819
                  50)
                object cbx_mail_elenco_00: TFCheckBox
                  Left = 8
                  Top = 8
                  Width = 133
                  Height = 17
                  Caption = '***'
                  Color = clBtnFace
                  ParentColor = False
                  TabOrder = 0
                  OnClick = cbx_mail_elenco_Click
                  AAA_NeedNotifyModification = False
                end
                object cbx_mail_elenco_01: TFCheckBox
                  Left = 141
                  Top = 8
                  Width = 133
                  Height = 17
                  Caption = '***'
                  Color = clBtnFace
                  ParentColor = False
                  TabOrder = 1
                  OnClick = cbx_mail_elenco_Click
                  AAA_NeedNotifyModification = False
                end
                object cbx_mail_elenco_02: TFCheckBox
                  Left = 274
                  Top = 8
                  Width = 133
                  Height = 17
                  Caption = '***'
                  Color = clBtnFace
                  ParentColor = False
                  TabOrder = 2
                  OnClick = cbx_mail_elenco_Click
                  AAA_NeedNotifyModification = False
                end
                object cbx_mail_elenco_04: TFCheckBox
                  Left = 8
                  Top = 28
                  Width = 133
                  Height = 17
                  Caption = '***'
                  Color = clBtnFace
                  ParentColor = False
                  TabOrder = 4
                  OnClick = cbx_mail_elenco_Click
                  AAA_NeedNotifyModification = False
                end
                object cbx_mail_elenco_05: TFCheckBox
                  Left = 141
                  Top = 28
                  Width = 133
                  Height = 17
                  Caption = '***'
                  Color = clBtnFace
                  ParentColor = False
                  TabOrder = 5
                  OnClick = cbx_mail_elenco_Click
                  AAA_NeedNotifyModification = False
                end
                object cbx_mail_elenco_06: TFCheckBox
                  Left = 274
                  Top = 28
                  Width = 133
                  Height = 17
                  Caption = '***'
                  Color = clBtnFace
                  ParentColor = False
                  TabOrder = 6
                  OnClick = cbx_mail_elenco_Click
                  AAA_NeedNotifyModification = False
                end
                object cbx_mail_elenco_03: TFCheckBox
                  Left = 408
                  Top = 8
                  Width = 133
                  Height = 17
                  Caption = '***'
                  Color = clBtnFace
                  ParentColor = False
                  TabOrder = 3
                  OnClick = cbx_mail_default_Click
                  AAA_NeedNotifyModification = False
                end
                object btn_help_set_mail_conto_01: TFBitBtn
                  Left = 772
                  Top = 10
                  Width = 24
                  Height = 26
                  Anchors = [akTop, akRight]
                  TabOrder = 7
                  TabStop = False
                  OnClick = btn_help_set_mail_contoClick
                  Glyph.Data = {
                    CE070000424DCE07000000000000360000002800000024000000120000000100
                    1800000000009807000000000000000000000000000000000000007F7F007F7F
                    007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F7F00007F7F007F7F007F
                    7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                    7F7F007F7FFFFFFFFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                    007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F00
                    007F00007F7F00007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7FFFFFFF007F7F007F7F
                    007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
                    7F007F7F007F7FFFFF007F7F007F7F007F0000007F7F007F7F007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF
                    007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
                    7F007F7F007F7F007F7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F0000
                    7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                    007F7F007F7F7F7F7FFFFFFFFFFFFF7F7F7FFFFFFF007F7F007F7F007F7F007F
                    7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                    007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F007F7F007F
                    7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F7F00007F00007F7F00007F7F007F7F007F7F
                    007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
                    7F007F7FFFFFFFFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F7F007F7F00
                    7F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
                    7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F7F7F7FFFFFFF007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                    007F7FFFFF007F7F007F7F007F0000007F7F007F7F007F7F007F7F007F7F007F
                    7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F7F
                    7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                    007F7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F007F7F007F0000007F
                    7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                    7F7F7F7F7FFFFFFF007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F
                    007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7FFFFF
                    007F7F007F7F007F7F007F0000007F7F007F7F007F7F007F7F007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF
                    007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
                    7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F007F7F007F0000007F7F00
                    7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F
                    FFFFFF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F
                    7F007F7F007F7F007F7F007F7F7F00007F0000007F7F007F7F007F7FFFFF007F
                    7F007F7F007F7F007F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                    007F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F
                    7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F007F7F007F7F007F
                    0000007F7F007F7F007F7FFFFF007F7F007F7F007F0000007F7F007F7F007F7F
                    007F7F007F7F007F7F007F7F7F7F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFF
                    FF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F00
                    7F7FFFFF007F7F007F7F007F7F007F00007F00007F00007F7F007F7F007F7F00
                    7F0000007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F7F7F
                    7FFFFFFFFFFFFFFFFFFF7F7F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F007F7FFFFF007F7F007F7F007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F00007F7F007F7F007F7F007F7F007F7F007F
                    7F7F7F7FFFFFFF007F7F007F7F7F7F7F7F7F7F7F7F7F007F7F007F7F007F7F7F
                    7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
                    FFFF00FFFF007F7F007F7F007F7F007F7F007F7F007F7F00007F7F007F7F007F
                    7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFFFFFFFF007F7F007F7F00
                    7F7F007F7F007F7F007F7F7F7F7F007F7F007F7F007F7F007F7F007F7F007F7F
                    007F7F007F7F007F7F007F7F007F7F007F7FFFFF00FFFF00FFFF00FFFF00FFFF
                    00007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F
                    7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F007F7F007F7F007F7F
                    007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
                    7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
                    7F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
                    007F7F007F7F007F7F007F7F007F7F007F7F}
                  NumGlyphs = 2
                  color_background_down = clBtnFace
                  color_background_up = clBtnFace
                  show_shortcut = False
                end
              end
            end
          end
        end
        object page_FTP: TTabSheet
          Caption = 'FTP'
          ImageIndex = 5
          DesignSize = (
            827
            407)
          object txt_FTP_password: TMyLabel
            Left = 22
            Top = 80
            Width = 143
            Height = 16
            Alignment = taRightJustify
            Caption = 'password di conferma'
            FocusControl = str_FTP_password
          end
          object txt_FTP_message: TMyLabel
            Left = 24
            Top = 49
            Width = 141
            Height = 16
            Caption = 'messaggio per utente'
            FocusControl = str_FTP_message
          end
          object btn_impostazioni_FTP: TFBitBtn
            Left = 219
            Top = 242
            Width = 397
            Height = 100
            Anchors = []
            Caption = 'impostazioni FTP'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -19
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
            OnClick = btn_impostazioni_FTPClick
            Glyph.Data = {
              DE0A0000424DDE0A0000000000007600000028000000470000004A0000000100
              040000000000680A000000000000000000001000000000000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFF0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFF0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFF
              FF77778FFFFFFFFFFFFF77777FFFFFF77777FFFFFFFFFFFFFFFFFFFFFFF0FFFF
              FFFFFFFFFFCCCC8FFFFFFFFFFFFF5CCCCFFFFFF7CCCCFFFFFFFFFFFFFFFFFFFF
              FFF0FFFFFFFFFFFFFFCCCC8FFFFFFFFFFFFF5CCCCFFFFFF7CCCCFFFFFFFFFFFF
              FFFFFFFFFFF0FFFFFFFFFFFFFFCCCC8FFFFFFFFFFFFF5CCCCFFFFFF7CCCCFFFF
              FFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFFCCCC8FFFFFFFFFFFFF5CCCCFFFFFF7
              CCCCFFFFFFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFFCCCC8FFFFFFFFFFFFF5CCC
              CFFFFFF7CCCCFFFFFFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFFCCCC8FFFFFFFFF
              FFFF5CCCCFFFFFF7CCCCCCCCC8FFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFFCCCCC8
              88888FFFFFFF5CCCCFFFFFF7CCCCCCCCCCC8FFFFFFFFFFFFFFF0FFFFFFFFFFFF
              FFCCCCCCCCCCCFFFFFFF5CCCCFFFFFF7CCCCCCCCCCCCCFFFFFFFFFFFFFF0FFFF
              FFFFFFFFFFCCCCCCCCCCCFFFFFFF5CCCCFFFFFF7CCCCFFFFCCCCCFFFFFFFFFFF
              FFF0FFFFFFFFFFFFFFCCCCCCCCCCCFFFFFFF5CCCCFFFFFF7CCCCFFFFCCCCCFFF
              FFFFFFFFFFF0FFFFFFFFFFFFFFCCCC8FFFFFFFFFFFFF5CCCCFFFFFF7CCCCFFFF
              CCCCCFFFFFFFFFFFFFF0FFFFFFFFFFFFFFCCCC8FFFFFFFFFFFFF5CCCCFFFFFF7
              CCCCFFFFCCCCCFFFFFFFFFFFFFF0FFFFFFFFFFFFFFCCCC8FFFFFFFFFFFFF5CCC
              CFFFFFF7CCCCFFFFCCCCC8FFFFFFFFFFFFF0FFFFFFFFFFFFFCCCCCCCCCCCC7F8
              CCCCCCCCCCCCC8F7CCCCCCCCCCCC8FFFFFFFFFFFFFF0FFFFFFFFFFFFFFCCCCCC
              CCCCCCFCCCCCCCCCCCCCC7F7CCCCCCCCCCC8FFFFFFFFFFFFFFF0FFFFFFFFFFFF
              FFCCCCCCCCCCC5F8CCCCCCCCCCCCC7F7CCCCCCCCC7FFFFFFFFFFFFFFFFF0FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFF0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFF0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFFFF000000000000
              00000000000000000000000000FFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFF00CCCC
              CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC00FFFFFFFFFFFFFFF0FFFFFFFFFFFF
              F0CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC0FFFFFFFFFFFFFF0FFFF
              FFFFFFFF0CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC0FFFFFFFFFF
              FFF0FFFFFFFFFFF0CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC0F
              FFFFFFFFFFF0FFFFFFFFFFF0CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
              CCCCCC0FFFFFFFFFFFF0FFFFFFFFFF0CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
              CCCCCCCCCCCCCCC0FFFFFFFFFFF0FFFFFFFFFF0CCCCCCCCCCCCCCCCCCCCCCCCC
              CCCCCCCCCCCCCCCCCCCCCCC0FFFFFFFFFFF0FFFFFFFFFF0CCCCCCCCCCCCCCCCC
              CCCCCC7CCCCCCCCCCCCCCCCCCCCCCCC0FFFFFFFFFFF0FFFFFFFFFF0CCCCCCCCC
              77CCCCCCCCCC5FF7CCCCCCCCCCCCCCCCCCCCCCC0FFFFFFFFFFF0FFFFFFFFFF0C
              CCCCCCCCFF875CCCCCC7FFFF5CCCCCCCCCCCCCCCCCCCCCC0FFFFFFFFFFF0FFFF
              FFFFFF0CCCCCCCCC8FFF875CCCC7FFFFFCCCCCCCCCCCCCCCCCCCCCC0FFFFFFFF
              FFF0FFFFFFFFFF0CCCCCCCCC8FFFFF887CCC7FFFF85CCCCCCCCCCCCCCCCCCCC0
              FFFFFFFFFFF0FFFFFFFFFF0CCCCCCCCC8FFFFFFF85CCC8FFFF7CCCCCCCCCCCCC
              CCCCCCC0FFFFFFFFFFF0FFFFFFFFFF0CCCCCCCCC7FFFFFF85CCCC5FFFFF7CCCC
              CCCCCCCCCCCCCCC0FFFFFFFFFFF0FFFFFFFFFF0CCCCCCCCC5FFFFFF7CCCCCC7F
              FFF85CCCCCCCCCCCCCCCCCC0FFFFFFFFFFF0FFFFFFFFFF0CCCCCCCCC5FFFFFFF
              7CCCCCC8FFFF8CCCCCCCCCCCCCCCCCC0FFFFFFFFFFF0FFFFFFFFFF0CCCCCCCCC
              5FF8FFFF8CCCCCCC8FFFF7CCCCCCCCCCCCCCCCC0FFFFFFFFFFF0FFFFFFFFFF0C
              CCCCCCCCCF7C7FFFF85CCCCCCFFFF87CCCCCCCCCCCCCCCC0FFFFFFFFFFF0FFFF
              FFFFFF0CCCCCCCCCC5CCCFFFFF7CCCCCC7FFFF85CCCCCCCCCCCCCCC0FFFFFFFF
              FFF0FFFFFFFFFF0CCCCCCCCCCCCCCC8FFFF5CCCCCC8FFFF8CCCCCCCCCCCCCCC0
              FFFFFFFFFFF0FFFFFFFFFF0CCCCCCCCCCCCCCC7FFFF85CCCCCC8FFFF7CCC5CCC
              CCCCCCC0FFFFFFFFFFF0FFFFFFFFFF0CCCCCCCCCCCCCCCC8FFFF8CCCCCC7FFFF
              FCC78CCCCCCCCCC0FFFFFFFFFFF0FFFFFFFFFF0CCCCCCCCCCCCCCCCC8FFFF7CC
              CCCC7FFFF87F8CCCCCCCCCC0FFFFFFFFFFF0FFFFFFFFFF0CCCCCCCCCCCCCCCCC
              5FFFFF5CCCCCC8FFFFFFFCCCCCCCCCC0FFFFFFFFFFF0FFFFFFFFFF0CCCCCCCCC
              CCCCCCCCC7FFFF8CCCCCC58FFFFFFCCCCCCCCCC0FFFFFFFFFFF0FFFFFFFFFF0C
              CCCCCCCCCCCCCCCCCC8FFFF8CCCCCC8FFFFFF5CCCCCCCCC0FFFFFFFFFFF0FFFF
              FFFFFF0CCCCCCCCCCCCCCCCCCC5FFFFF7CCC5FFFFFFFF5CCCCCCCCC0FFFFFFFF
              FFF0FFFFFFFFFF0CCCCCCCCCCCCCCCCCCCCCFFFFF5CCC7FFFFFFF7CCCCCCCCC0
              FFFFFFFFFFF0FFFFFFFFFF0CCCCCCCCCCCCCCCCCCCCC7FFFF8CCCC578FFFF7CC
              CCCCCCC0FFFFFFFFFFF0FFFFFFFFFF0CCCCCCCCCCCCCCCCCCCCCC8FFFF7CCCCC
              C58FF8CCCCCCCCC0FFFFFFFFFFF0FFFFFFFFFF0CCCCCCCCCCCCCCCCCCCCCCCFF
              F7CCCCCCCCC588CCCCCCCCC0FFFFFFFFFFF0FFFFFFFFFF0CCCCCCCCCCCCCCCCC
              CCCCCC5F5CCCCCCCCCCCC5CCCCCCCCC0FFFFFFFFFFF0FFFFFFFFFFF0CCCCCCCC
              CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC0FFFFFFFFFFFF0FFFFFFFFFFF0
              CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC0FFFFFFFFFFFF0FFFF
              FFFFFFFF0CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC0FFFFFFFFFF
              FFF0FFFFFFFFFFFFF0CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC0FFF
              FFFFFFFFFFF0FFFFFFFFFFFFFF00CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
              CC00FFFFFFFFFFFFFFF0FFFFFFFFFFFFFFFF0000000000000000000000000000
              0000000000FFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFF0}
            Spacing = 16
            color_background_down = 8421631
            color_background_up = 12910591
            show_shortcut = False
          end
          object cbx_FTP_conferma: TFCheckBox
            Left = 32
            Top = 20
            Width = 409
            Height = 17
            Hint = 
              'il programma richiede specifica conferma all'#39'utente'#13#10'prima di es' +
              'eguire la spedizione via FTP'
            Caption = 'richiedi conferma prima di eseguire trasferimento su FTP'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = cbx_FTP_confermaClick
            AAA_NeedNotifyModification = False
          end
          object str_FTP_password: TFEdit
            Left = 168
            Top = 76
            Width = 149
            Height = 24
            Hint = 
              'questa password viene richiesta per autorizzare la spedizione vi' +
              'a FTP'#13#10'se il campo resta vuoto, viene chiesta conferma generica ' +
              '(senza password)'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            AAA_tipodato = fe_generico
            AAA_NeedNotifyModification = False
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = True
          end
          object str_FTP_message: TFEdit
            Left = 168
            Top = 45
            Width = 340
            Height = 24
            Hint = 
              'messaggio di spiegazione all'#39'utente relativamente al processo di' +
              ' spedizione via FTP'#13#10'se il campo resta vuoto, viene emesso un me' +
              'ssaggio generico'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            AAA_tipodato = fe_generico
            AAA_NeedNotifyModification = False
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = True
          end
          object btn_FTP_default_message: TFBitBtn
            Left = 514
            Top = 45
            Width = 67
            Height = 25
            Hint = 'assegna un messaggio esemplificativo standard'
            Caption = 'esempio'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = btn_FTP_default_messageClick
            NumGlyphs = 2
            color_background_down = clBtnFace
            color_background_up = clBtnFace
            show_shortcut = False
          end
        end
      end
    end
    object page_runtime: TTabSheet
      Caption = 'runtime'
      ImageIndex = 10
      object panel_runtime_header: TFPanel
        Left = 0
        Top = 0
        Width = 835
        Height = 83
        Align = alTop
        ParentBackground = False
        TabOrder = 0
        DesignSize = (
          835
          83)
        object txt_azione_after_print: TLabel
          Left = 31
          Top = 40
          Width = 100
          Height = 16
          Caption = 'dopo la stampa'
          FocusControl = cb_azione_after_print
        end
        object txt_runtime_caption: TMyLabel
          Left = 9
          Top = 2
          Width = 122
          Height = 32
          Alignment = taRightJustify
          Caption = 'titolo finestra'#13#10'richiesta parametri'
          FocusControl = str_runtime_caption
        end
        object cb_azione_after_print: TFCombo
          Left = 135
          Top = 36
          Width = 340
          Height = 24
          Hint = 
            'azione default eseguita all'#39'esecuzione del report'#13#10' '#13#10'se il repo' +
            'rt viene eseguito da un programma esterno,'#13#10'l'#39'impostazione qui s' +
            'pecificata prevale su quella specificata dal programma esterno'
          Style = csDropDownList
          DropDownCount = 16
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          AAA_dropdownwidth = 250
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = False
          AAA_CanBeInvalid = False
        end
        object str_runtime_caption: TFEdit
          Left = 135
          Top = 6
          Width = 591
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          AAA_tipodato = fe_generico
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object panel_runtime_caption_color: TFPanel
          Left = 730
          Top = 5
          Width = 71
          Height = 27
          Anchors = [akTop, akRight]
          Caption = 'colore'
          ParentBackground = False
          TabOrder = 2
          OnClick = panel_runtime_caption_colorClick
        end
        object cbx_runtime_save_pos_size: TFCheckBox
          Left = 146
          Top = 62
          Width = 348
          Height = 17
          Caption = 'consenti salvataggio posizione finestra parametri'
          TabOrder = 3
          AAA_NeedNotifyModification = False
        end
      end
      object panel_runtime_body: TFPanel
        Left = 0
        Top = 83
        Width = 835
        Height = 429
        Align = alClient
        ParentBackground = False
        TabOrder = 1
        object txt_runtime: TLabel
          Left = 1
          Top = 1
          Width = 833
          Height = 30
          Align = alTop
          Alignment = taCenter
          AutoSize = False
          Caption = 'gruppi di parametri richiesti a RUNTIME'
          Color = 14811105
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Transparent = False
          Layout = tlCenter
        end
        object lb_runtime_gboxes: TMyListBox
          Left = 1
          Top = 31
          Width = 833
          Height = 356
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemHeight = 19
          ParentFont = False
          TabOrder = 0
          OnClick = lb_runtime_gboxesClick
          OnDblClick = lb_runtime_gboxesDblClick
          AAA_NeedNotifyModification = False
        end
        object runtime_panel: TFPanel
          Left = 1
          Top = 387
          Width = 833
          Height = 41
          Align = alBottom
          ParentBackground = False
          TabOrder = 1
          DesignSize = (
            833
            41)
          object btn_runtime_gbox_add: TFBitBtn
            Left = 5
            Top = 7
            Width = 118
            Height = 27
            Caption = 'nuovo gruppo'
            TabOrder = 0
            OnClick = btn_runtime_gbox_addClick
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
          object btn_runtime_gbox_delete: TFBitBtn
            Left = 218
            Top = 7
            Width = 76
            Height = 27
            Caption = 'elimina'
            TabOrder = 2
            OnClick = btn_runtime_gbox_deleteClick
            Glyph.Data = {
              D6000000424DD60000000000000076000000280000000C0000000C0000000100
              0400000000006000000000000000000000001000000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
              0000FFFFFFFFFFFF0000FFFFFFFFFFFF0000FFFFFFFFFFFF0000000000000000
              0000099999999990000009999999999000000000000000000000FFFFFFFFFFFF
              0000FFFFFFFFFFFF0000FFFFFFFFFFFF0000FFFFFFFFFFFF0000}
            color_background_down = clBtnFace
            color_background_up = clBtnFace
            show_shortcut = False
          end
          object btn_runtime_gbox_moveup: TFBitBtn
            Left = 684
            Top = 7
            Width = 51
            Height = 27
            Anchors = [akTop, akRight]
            Caption = 'SU'
            TabOrder = 3
            OnClick = btn_runtime_gbox_moveupClick
            Glyph.Data = {
              EE000000424DEE000000000000007600000028000000110000000A0000000100
              0400000000007800000000000000000000001000000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
              FFFFF0000000CCCCCCCCCCCCCCCCC0000000FCCCCCCCCCCCCCCCF0000000FFCC
              CCCCCCCCCCCFF0000000FFFCCCCCCCCCCCFFF0000000FFFFCCCCCCCCCFFFF000
              0000FFFFFCCCCCCCFFFFF0000000FFFFFFCCCCCFFFFFF0000000FFFFFFFCCCFF
              FFFFF0000000FFFFFFFFCFFFFFFFF0000000}
            color_background_down = clBtnFace
            color_background_up = clBtnFace
            show_shortcut = False
          end
          object btn_runtime_gbox_movedown: TFBitBtn
            Left = 740
            Top = 7
            Width = 57
            Height = 27
            Anchors = [akTop, akRight]
            Caption = 'GIU'#39
            TabOrder = 4
            OnClick = btn_runtime_gbox_movedownClick
            Glyph.Data = {
              EE000000424DEE000000000000007600000028000000110000000A0000000100
              0400000000007800000000000000000000001000000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFCFFF
              FFFFF0000000FFFFFFFCCCFFFFFFF0000000FFFFFFCCCCCFFFFFF0000000FFFF
              FCCCCCCCFFFFF0000000FFFFCCCCCCCCCCFFF0000000FFFCCCCCCCCCCCCFF000
              0000FFCCCCCCCCCCCCCCF0000000FCCCCCCCCCCCCCCCC0000000CCCCCCCCCCCC
              CCCCC0000000FFFFFFFFFFFFFFFFF0000000}
            color_background_down = clBtnFace
            color_background_up = clBtnFace
            show_shortcut = False
          end
          object btn_help: TFBitBtn
            Left = 802
            Top = 8
            Width = 29
            Height = 25
            Anchors = [akTop, akRight]
            TabOrder = 5
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
          object btn_runtime_gbox_modify: TFBitBtn
            Left = 128
            Top = 7
            Width = 83
            Height = 27
            Caption = 'modifica'
            TabOrder = 1
            OnClick = btn_runtime_gbox_modifyClick
            Glyph.Data = {
              D6000000424DD60000000000000076000000280000000C0000000C0000000100
              0400000000006000000000000000000000001000000000000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFF99FFFFF
              0000FFF999999FFF0000FF99999999FF0000F9999999999F0000F9999999999F
              000099999999999900009999999999990000F9999999999F0000F9999999999F
              0000FF99999999FF0000FFF999999FFF0000FFFFF99FFFFF0000}
            color_background_down = clBtnFace
            color_background_up = clBtnFace
            show_shortcut = False
          end
        end
      end
    end
    object page_colori: TTabSheet
      Caption = 'colori'
      ImageIndex = 13
      object txt_header_colori_symbolici: TLabel
        Left = 0
        Top = 0
        Width = 835
        Height = 30
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = 'gestione COLORI SYMBOLICI'
        Color = 16764671
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = False
        Layout = tlCenter
        ExplicitTop = 2
      end
      object footer_colori_symbolici: TFPanel
        Left = 0
        Top = 412
        Width = 835
        Height = 100
        Align = alBottom
        ParentBackground = False
        TabOrder = 0
        object txt_colore_symbolico: TMyLabel
          Left = 388
          Top = 17
          Width = 40
          Height = 16
          Caption = 'colore'
        end
        object txt_colore_symbolico_nome: TMyLabel
          Left = 10
          Top = 17
          Width = 147
          Height = 16
          Caption = 'nome simbolico colore'
          FocusControl = str_colore_symbolico_nome
        end
        object txt_colore_symbolico_pos: TMyLabel
          Left = 574
          Top = 17
          Width = 24
          Height = 16
          Caption = 'pos'
          FocusControl = i_colore_symbolico_pos
        end
        object btn_colore_symbolico_add: TFBitBtn
          Left = 27
          Top = 58
          Width = 120
          Height = 31
          Action = AL_colore_symbolico_add
          Caption = 'aggiungi'
          TabOrder = 2
          Glyph.Data = {
            8A010000424D8A01000000000000760000002800000015000000170000000100
            0400000000001401000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFF00000
            00FFFFFFF000FFFFFFF0AAAAA0FFFFFFF000FFFFFFF0AAAAA0FFFFFFF000FFFF
            FFF0AAAAA0FFFFFFF000FFFFFFF0AAAAA0FFFFFFF000FFFFFFF0AAAAA0FFFFFF
            F000FFFFFFF0AAAAA0FFFFFFF000FFFFFFF0AAAAA0FFFFFFF00000000000AAAA
            A000000000000AAAAAAAAAAAAAAAAAAA00000AAAAAAAAAAAAAAAAAAA00000AAA
            AAAAAAAAAAAAAAAA00000AAAAAAAAAAAAAAAAAAA00000AAAAAAAAAAAAAAAAAAA
            000000000000AAAAA00000000000FFFFFFF0AAAAA0FFFFFFF000FFFFFFF0AAAA
            A0FFFFFFF000FFFFFFF0AAAAA0FFFFFFF000FFFFFFF0AAAAA0FFFFFFF000FFFF
            FFF0AAAAA0FFFFFFF000FFFFFFF0AAAAA0FFFFFFF000FFFFFFF0AAAAA0FFFFFF
            F000FFFFFFF0000000FFFFFFF000}
          color_background_down = clBtnFace
          color_background_up = clBtnFace
          show_shortcut = False
        end
        object btn_colore_symbolico_delete: TFBitBtn
          Left = 293
          Top = 58
          Width = 81
          Height = 31
          Action = AL_colore_symbolico_delete
          Caption = 'elimina'
          TabOrder = 4
          Glyph.Data = {
            D6000000424DD600000000000000760000002800000014000000080000000100
            0400000000006000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
            FFFFFFFF00000000000000000000000000000999999999999999999000000999
            9999999999999990000009999999999999999990000009999999999999999990
            0000000000000000000000000000FFFFFFFFFFFFFFFFFFFF0000}
          NumGlyphs = 2
          color_background_down = clBtnFace
          color_background_up = clBtnFace
          show_shortcut = False
        end
        object panel_colore_symbolico: TFPanel
          Left = 434
          Top = 6
          Width = 117
          Height = 39
          ParentBackground = False
          TabOrder = 0
          TabStop = True
          OnClick = panel_color_assignClick
        end
        object str_colore_symbolico_nome: TFEdit
          Left = 162
          Top = 13
          Width = 211
          Height = 24
          CharCase = ecUpperCase
          MaxLength = 24
          TabOrder = 1
          AAA_tipodato = fe_generico
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object btn_colore_symbolico_update: TFBitBtn
          Left = 157
          Top = 58
          Width = 120
          Height = 31
          Action = AL_colore_symbolico_update
          Caption = 'aggiorna'
          TabOrder = 3
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000000000010000
            0004000000040000000500000006000000090000000B0000000B0000000B0000
            0009000000060000000300000001000000000000000000000000000000030000
            00090000000B0000000D00000010000000140000001600000017000000160000
            00140000000F0000000A0000000500000002000000000000000000000006102F
            228700000015000000180A1F1663143A29A71B5039DC1F5E43FB1B5039DC143A
            29A70A1E1662000000120000000B000000050000000100000000000000082364
            49FF133628981336289A236348FC52AB8FFF74CEB9FF88E4D3FF76D0BCFF56AD
            93FF236348FC13362897030907270000000A0000000200000001000000092669
            4EFF4BA283FF4BA283FF6ED0B2FF64B399FF4A8D76FF2C6E54FF4F8F79FF78BB
            A8FF87DBC4FF4C9F82FF15392A960000000F0000000400000001000000082A6F
            53FF91E1C9FF91E1C9FF6DB79DFF1A4534A70C1F1751020403130C1F174D1A45
            33A469A690FF97DFCAFF2A6E52FC0E241B5E0000000500000001000000072F77
            5BFFCFF3E8FFCFF3E8FF81B7A3FF183D2F8B0000000A00000005000000060103
            02111D4A39A695C5B4FF91C3B1FF1D4938A30000000600000001000000063784
            66FF378466FF378466FF378466FF378466FF1C42338200000004000000060000
            000B0F251C53378466FF378466FF2E6F55DA0000000600000002000000060000
            00110000001700000017000000120000000A00000006000000050000000A0000
            0011000000180000001C0000001A000000140000000700000002000000051B50
            39DA205F44FF205F44FF091A13570000000E0000000900000009102F2286205F
            44FF205F44FF205F44FF205F44FF205F44FF000000080000000300000004163D
            2CA25AAF97FF4DA98AFF163F2DAA0103021D0000001200000012000000151233
            2691419A7BFF60CFACFF60CFACFF236449FF0000000900000003000000020C22
            195926684DFC8EDEC9FF4D9B80FF184131AA0B1D165B020403240B1D165B1841
            31AA5DAF94FF8CE0C9FF8BE0C8FF26694EFF0000000800000003000000010000
            0005173C2D907AB19EFFAFE7D7FF77BAA3FF498F75FF2E7458FF498F75FF77BA
            A3FFAFE7D7FF7FB6A3FF7EB6A3FF2A6F53FF0000000600000002000000000000
            0002040B081C194132902E765AFC97C4B4FFB9E0D4FFCEF1E6FFB9E0D4FF97C4
            B4FF2E765AFC1A413191194132902F775BFF0000000300000001000000000000
            00000000000100000003122A215622503E9F2F6F56D9368164FA2F6F56D92250
            3E9F122A215600000005000000041B4233810000000100000001000000000000
            0000000000000000000100000001000000020000000300000004000000030000
            0002000000010000000100000001000000010000000000000000}
          color_background_down = clBtnFace
          color_background_up = clBtnFace
          show_shortcut = False
        end
        object i_colore_symbolico_pos: TFEdit
          Left = 605
          Top = 13
          Width = 46
          Height = 24
          CharCase = ecUpperCase
          MaxLength = 3
          NumbersOnly = True
          TabOrder = 5
          AAA_tipodato = fe_integer
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object FBitBtn1: TFBitBtn
          Left = 425
          Top = 58
          Width = 124
          Height = 31
          Action = AL_colore_symbolico_sort
          Caption = 'ordina colori'
          TabOrder = 6
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000000000000000
            0000000000010000000300000003000000010000000000000000000000000000
            0002000000060000000A0000000A000000060000000200000000000000000000
            000100000005122615750F1F1069000000050000000100000000000000000000
            00061F4124C3295830FF295630FF1F3F23C30000000600000000000000000000
            00030A140C4532724AFB2B673EF90710083C0000000300000000000000000000
            0008316840FF50CB9DFF3EC28FFF31673FFF0000000900000000000000020408
            041E2B5D3AE940BD8DFF3BB786FF25532EE30306031C00000002000000000000
            0008336C44FF53CEA2FF3EC793FF336B41FF00000009000000000101010A2248
            2BC040AF82FF3DCA99FF3DC998FF37A97AFF1E3F23BE0001010B000000010000
            0008346F47FF55D4AAFF3CC997FF346D45FF000000080000000018331E8B51A1
            7EFF72DEBEFF58D5AEFF40CC9FFF57D4ADFF4C9A76FF152C1889000000040000
            000736734CFF5BD6B0FF3FCB9CFF357149FF00000008000000003A875DFF3A85
            5CFF39835AFF64D8B4FF46CEA4FF37774EFF37764DFF37764DFF000000050000
            000737784FFF64D9B8FF46CEA4FF36754CFF0000000700000000000000040000
            000A3B895FFF6DDBBCFF4FD1AAFF397C53FF0000000B00000005000000010000
            0006387B53FF71DCBEFF4ED1AAFF387950FF0000000700000000000000000000
            00053D9067FF78DFC3FF56D3B0FF398057FF0000000600000000000000000000
            00063A8158FF7BE0C6FF56D3B0FF397D53FF0000000600000000000000000000
            00043D946CFF83E2CBFF5DD5B6FF3B865DFF0000000500000001000000040000
            00093C875DFF85E2CCFF5DD5B6FF3A8158FF0000000A00000005000000000000
            00043E9A72FF8BE5D1FF63D7BBFF3C8A61FF0000000400000003337149FF3371
            49FF3D8B61FF64D8BCFF64D8BCFF3C885EFF326E46FF326E46FF000000000000
            00033E9E76FF93E7D6FF69DAC1FF3E9066FF0000000400000002204C36887EC3
            A9FF9EE9DBFF75DEC7FF68DAC1FF74DEC6FF66B195FF173B2786000000000000
            00033FA278FF9AE9DAFF6DDBC5FF3E946AFF0000000300000000010201062F6E
            50BE9BD8C6FF9CE9DAFF79DFCBFF7DCBB5FF225B3CBB01010107000000000000
            00023FA57DFFA0EBDDFF70DDC9FF3F996EFF000000030000000000000001050D
            091944926EE7B0E9DBFFA5E2D4FF337956E10309061700000001000000000000
            00013EA881FFC5F4ECFFC5F4ECFF409F72FF0000000200000000000000000000
            00010E23193D5DAF8AFA4C9A75F8091911340000000100000000000000000000
            00012F7F61BE3FAA82FF3FAA82FF2F7D5FBE0000000100000000000000000000
            0000000000011A47366E153C2D62000000010000000000000000}
          color_background_down = clBtnFace
          color_background_up = clBtnFace
          show_shortcut = False
        end
      end
      object lb_colori_symbolici: TMyListBox
        Left = 0
        Top = 30
        Width = 835
        Height = 382
        Style = lbOwnerDrawFixed
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 24
        ParentFont = False
        TabOrder = 1
        OnClick = lb_colori_symboliciClick
        OnDrawItem = lb_colori_symboliciDrawItem
        AAA_NeedNotifyModification = False
      end
    end
    object rem: TTabSheet
      Caption = 'note'
      object split_note_01: TMySplitter
        Left = 0
        Top = 331
        Width = 835
        Height = 7
        Cursor = crVSplit
        Align = alBottom
        Color = clFuchsia
        ParentColor = False
        AAA_AutoColor = True
        ExplicitTop = 332
      end
      object panel_descrizione_report: TFPanel
        Left = 0
        Top = 0
        Width = 835
        Height = 331
        Align = alClient
        ParentBackground = False
        TabOrder = 0
        DesignSize = (
          835
          331)
        object txt_descrizione_report: TLabel
          Left = 12
          Top = 12
          Width = 118
          Height = 16
          Caption = 'descrizione report'
          FocusControl = str_descrizione_report
        end
        object txt_runtime_docs_info: TMyLabel
          Left = 1
          Top = 314
          Width = 833
          Height = 16
          Align = alBottom
          Alignment = taCenter
          Caption = 
            'a runtime tutti i files saranno ricercati per default nella cart' +
            'ella del report'
          Color = 8454143
          ParentColor = False
          ExplicitWidth = 469
        end
        object txt_runtime_help: TLabel
          Left = 36
          Top = 40
          Width = 94
          Height = 32
          Alignment = taRightJustify
          Caption = 'testo in'#13#10'runtime parms'
          FocusControl = str_descrizione_report
        end
        object str_descrizione_report: TFEdit
          Left = 136
          Top = 10
          Width = 688
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          AAA_tipodato = fe_generico
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object gbox_documenti: TFGroupBox
          Left = 19
          Top = 130
          Width = 805
          Height = 183
          Anchors = [akLeft, akTop, akRight, akBottom]
          Caption = 'documenti informativi report'
          TabOrder = 3
          DesignSize = (
            805
            183)
          object txt_doc_utente: TLabel
            Left = 35
            Top = 22
            Width = 140
            Height = 16
            Alignment = taRightJustify
            Caption = 'documento per utente'
            FocusControl = str_doc_utente
          end
          object txt_technical_reference: TLabel
            Left = 52
            Top = 50
            Width = 123
            Height = 16
            Alignment = taRightJustify
            Caption = 'technical reference'
            FocusControl = str_technical_reference
          end
          object txt_links_utente: TLabel
            Left = 68
            Top = 80
            Width = 104
            Height = 16
            Caption = 'altri links utente'
            FocusControl = str_descrizione_report
          end
          object str_doc_utente: TEdit
            Left = 180
            Top = 18
            Width = 561
            Height = 24
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 0
          end
          object btn_doc_utente_browse: TFBitBtn
            Left = 745
            Top = 19
            Width = 18
            Height = 23
            Anchors = [akTop, akRight]
            Caption = '...'
            TabOrder = 1
            TabStop = False
            OnClick = btn_doc_utente_browseClick
            color_background_down = clBtnFace
            color_background_up = clBtnFace
            show_shortcut = False
          end
          object btn_doc_utente_open: TFBitBtn
            Left = 769
            Top = 19
            Width = 23
            Height = 23
            Anchors = [akTop, akRight]
            TabOrder = 2
            TabStop = False
            OnClick = btn_doc_utente_openClick
            Glyph.Data = {
              12010000424D12010000000000007600000028000000110000000D0000000100
              0400000000009C00000000000000000000001000000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00770000000000
              007770000000700B7B7B7B7B7B077000000070B0B7B7B7B7B7B07000000070F0
              7B7B7B7B7B707000000070BF07B7B7B7B7B70000000070FBF000007B7B7B0000
              000070BFBFBFBF0000007000000070FBFBFBFBFBFB077000000070BFBFBFBFBF
              BF077000000070FBFBFBFBFBFB077000000070BFBFB000000077700000007700
              00077777777770000000777777777777777770000000}
            color_background_down = clBtnFace
            color_background_up = clBtnFace
            show_shortcut = False
          end
          object str_technical_reference: TEdit
            Left = 180
            Top = 46
            Width = 561
            Height = 24
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 3
          end
          object btn_technical_reference_browse: TFBitBtn
            Left = 745
            Top = 47
            Width = 18
            Height = 23
            Anchors = [akTop, akRight]
            Caption = '...'
            TabOrder = 4
            TabStop = False
            OnClick = btn_technical_reference_browseClick
            color_background_down = clBtnFace
            color_background_up = clBtnFace
            show_shortcut = False
          end
          object btn_technical_reference_open: TFBitBtn
            Left = 769
            Top = 47
            Width = 23
            Height = 23
            Anchors = [akTop, akRight]
            TabOrder = 5
            TabStop = False
            OnClick = btn_technical_reference_openClick
            Glyph.Data = {
              12010000424D12010000000000007600000028000000110000000D0000000100
              0400000000009C00000000000000000000001000000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00770000000000
              007770000000700B7B7B7B7B7B077000000070B0B7B7B7B7B7B07000000070F0
              7B7B7B7B7B707000000070BF07B7B7B7B7B70000000070FBF000007B7B7B0000
              000070BFBFBFBF0000007000000070FBFBFBFBFBFB077000000070BFBFBFBFBF
              BF077000000070FBFBFBFBFBFB077000000070BFBFB000000077700000007700
              00077777777770000000777777777777777770000000}
            color_background_down = clBtnFace
            color_background_up = clBtnFace
            show_shortcut = False
          end
          object str_links_utente: TFMemo
            Left = 180
            Top = 78
            Width = 561
            Height = 86
            Hint = '*runtime*'
            Anchors = [akLeft, akTop, akRight, akBottom]
            ParentShowHint = False
            ScrollBars = ssBoth
            ShowHint = True
            TabOrder = 6
            AAA_NeedNotifyModification = False
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = True
          end
          object btn_add_link_utente: TFBitBtn
            Left = 746
            Top = 81
            Width = 28
            Height = 29
            Anchors = [akTop, akRight]
            TabOrder = 7
            TabStop = False
            OnClick = btn_add_link_utenteClick
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
        object str_runtime_help: TFMemo
          Left = 136
          Top = 38
          Width = 479
          Height = 86
          Hint = 
            'questo testo viene mostrato nella finestra di richiesta di param' +
            'etri'#13#10'per spiegare lo scopo e la funzionalit'#224' del report'
          Anchors = [akLeft, akTop, akRight]
          ParentShowHint = False
          ScrollBars = ssBoth
          ShowHint = True
          TabOrder = 1
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object gbox_runtime_help_format: TFGroupBox
          Left = 625
          Top = 38
          Width = 199
          Height = 86
          Anchors = [akTop, akRight]
          Caption = 'formato testo'
          TabOrder = 2
          object panel_runtime_help_background: TFPanel
            Left = 106
            Top = 22
            Width = 86
            Height = 24
            Caption = 'background'
            ParentBackground = False
            TabOrder = 0
            TabStop = True
            OnClick = panel_runtime_help_backgroundClick
          end
          object panel_runtime_help_align: TFPanel
            Left = 16
            Top = 53
            Width = 176
            Height = 27
            ParentBackground = False
            TabOrder = 1
            object rb_runtime_help_align_sx: TFRadio
              Left = 6
              Top = 6
              Width = 41
              Height = 17
              Caption = 'sx'
              TabOrder = 0
              OnClick = rb_runtime_help_align_Click
              AAA_NeedNotifyModification = False
            end
            object rb_runtime_help_align_center: TFRadio
              Left = 53
              Top = 6
              Width = 67
              Height = 17
              Caption = 'center'
              TabOrder = 1
              OnClick = rb_runtime_help_align_Click
              AAA_NeedNotifyModification = False
            end
            object rb_runtime_help_align_dx: TFRadio
              Left = 130
              Top = 6
              Width = 41
              Height = 17
              Caption = 'dx'
              TabOrder = 2
              OnClick = rb_runtime_help_align_Click
              AAA_NeedNotifyModification = False
            end
          end
          object panel_runtime_help_example: TFPanel
            Left = 8
            Top = 17
            Width = 92
            Height = 34
            ParentBackground = False
            TabOrder = 2
            object txt_runtime_help_example: TMyLabel
              AlignWithMargins = True
              Left = 4
              Top = 4
              Width = 84
              Height = 26
              Cursor = crHandPoint
              Align = alClient
              Alignment = taCenter
              AutoSize = False
              Caption = 'Abc'
              Transparent = False
              Layout = tlCenter
              OnClick = txt_runtime_help_exampleClick
              ExplicitLeft = 26
              ExplicitTop = 16
              ExplicitWidth = 23
              ExplicitHeight = 14
            end
          end
        end
      end
      object panel_remarks: TFPanel
        Left = 0
        Top = 338
        Width = 835
        Height = 174
        Align = alBottom
        ParentBackground = False
        TabOrder = 1
        object txt_remarks: TLabel
          Left = 1
          Top = 1
          Width = 334
          Height = 32
          Align = alTop
          Alignment = taCenter
          Caption = 
            '&REMarks, ovvero note sull'#39' eziologia, la '#13#10'teleologia e le moda' +
            'lit'#224' di funzionamento del report'
        end
        object str_remarks: TMemo
          Left = 1
          Top = 33
          Width = 833
          Height = 140
          Align = alClient
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
    object page_versioni: TTabSheet
      Caption = 'versioni'
      ImageIndex = 7
      object lb_versioni: TListBox
        Left = 0
        Top = 0
        Width = 835
        Height = 471
        Style = lbOwnerDrawVariable
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 15
        MultiSelect = True
        ParentFont = False
        TabOrder = 0
        OnKeyDown = lb_versioniKeyDown
        OnMeasureItem = lb_versioniMeasureItem
      end
      object TFPanel
        Left = 0
        Top = 471
        Width = 835
        Height = 41
        Align = alBottom
        ParentBackground = False
        TabOrder = 1
        DesignSize = (
          835
          41)
        object btn_delete_versioni: TFBitBtn
          Left = 16
          Top = 8
          Width = 265
          Height = 27
          Caption = 'Elimina informazioni selezionate'
          TabOrder = 0
          OnClick = btn_delete_versioniClick
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
        object btn_copy_clipboard: TFBitBtn
          Left = 556
          Top = 9
          Width = 265
          Height = 27
          Anchors = [akTop, akRight]
          Caption = 'Copia versioni su CLIPBOARD'
          TabOrder = 1
          OnClick = btn_copy_clipboardClick
          Glyph.Data = {
            EE000000424DEE000000000000007600000028000000100000000F0000000100
            0400000000007800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            888888888800000000088888880FFFFFFF088888880F00000F088888880FFFFF
            FF088000000000000F0880FFFFFFF0FFFF0880F00000F0999F0880FFFFFFF0FF
            FF0880F00000F000000880FFFFFFF088888880F99999F088888880FFFFFFF088
            888880000000008888888888888888888888}
          color_background_down = clBtnFace
          color_background_up = clBtnFace
          show_shortcut = False
        end
      end
    end
  end
  object panel_runtime_footer: TFPanel
    Left = 0
    Top = 629
    Width = 843
    Height = 47
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 2
    object btn_ok: TFBitBtn
      Left = 44
      Top = 11
      Width = 87
      Height = 27
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
      Left = 136
      Top = 11
      Width = 81
      Height = 27
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
    object btn_print_setup: TFBitBtn
      Left = 282
      Top = 11
      Width = 271
      Height = 27
      Caption = 'F7 stampante e modalit'#224' di stampa'
      TabOrder = 2
      OnClick = btn_print_setupClick
      Glyph.Data = {
        8A050000424D8A05000000000000360400002800000012000000110000000100
        0800000000005401000000000000000000000001000000010000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A6004E434E00434E4300594E59004E594E0064645900D9D9CE00C3C3AD0021AD
        9D00004E86000B64910043CEB8000000590000376F000B437A00006F6F000B7A
        7A001686860043B8AD0000216400165986000B647A00216491002C6F9D002191
        7A00437AAD004E86B800004E6F002C919100D9866F00379D9D00E4917A00EF9D
        86004EADB80059B8C300002C590000645900C37A5900379D86004391AD006491
        C300FCAD91000000430016376F0021437A00166F6F00217A7A00000B4E001621
        640000434E00004E59000B436400164E6F000B5964002C598600217A64003764
        91002C866F004EAD9D000016430000214E000B2C590021647A00AD6459002C6F
        8600B86F64004E6F9D00378686004391910064ADB8007AADCE006FB8C3002C37
        6F00C3866F00CE917A00D99D8600599DAD00E4AD910086C3D900160B4E00430B
        3700002C4300004E43000B594E001664590043598600437A91004E869D006486
        AD0064AD9D0000002C00000037000B434E00164E590021436400215964002C4E
        6F002C6F5900377A64002C6F6F00916F4E0043866F007A91B800869DC300430B
        21000B1643004E162C005921370016214E000B432C00212C5900642C43006F37
        4E007A43590037647A00599D910086C3C3000B002C002C00210016003700000B
        2C00002C2C0000213700371643000037370043214E000B2C4300372C64006F4E
        37007A4343007A594300864E4E004E6F8600AD7A6F004E868600B8917A00C39D
        86006F9DAD007AADB80091B8CE009DC3D900ADCEE40021000B0037000B005937
        5900164E43003743640021594E004E4E7A009159640059598600436F59009D6F
        64004E7A6400646F91006F7A9D0021000000211643002C214E00376464004359
        6F00436F6F008686AD00000021001600210000211600210B2C000B0B2C003716
        2C00432137004E2C430021432C0021434E002C4E59008664590064869100C3B8
        9D00C3E4EF00CEEFFC000B2C2C0043212100162137004E2C2C00212C43001637
        3700593737002C4E4300644343006F4E4E0037594E006459430064867A006F91
        8600869DAD0091ADB800CEC3AD000B000B00000B160000162100433759004E43
        6400647A64007A647A00866F86007A919D00AD919100B89D9D00E4FCFF000000
        0B00000B0000210B160000160B000B2116002C213700372C430059596F006F59
        640064647A0086866F000B00000037434E00434E59004E646400596F6F00866F
        6F006F7A8600917A7A009D868600ADB8C300B8C3CE00C3CED900CED9E400D9E4
        EF00FFFCEF000B0B00000B0B160016162100F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
        0707070707070707070707070000070707000000000000000000000007070707
        0000070700070707070707070707000700070707000007000000000000000000
        000000000700070700000700070707070707FFFFFF0707000000070700000700
        070707070707F8F8F80707000700070700000700000000000000000000000000
        0707000700000700070707070707070707070007000700070000070700000000
        000000000000070007000007000007070700FFFFFFFFFFFFFFFF000700070007
        00000707070700FF0000000000FF00000000070700000707070700FFFFFFFFFF
        FFFFFF00070707070000070707070700FF0000000000FF000707070700000707
        07070700FFFFFFFFFFFFFFFF0007070700000707070707070000000000000000
        0007070700000707070707070707070707070707070707070000070707070707
        0707070707070707070707070000}
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = False
    end
  end
  object popup_SMTP: TPopupMenu
    Left = 542
    Top = 21
    object itp_SMTP_default: TMenuItem
      Caption = 'configurazione default'
      OnClick = itp_SMTP_defaultClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object itp_SMTP_gmail: TMenuItem
      Caption = 'GMAIL'
      OnClick = itp_SMTP_gmailClick
    end
    object itp_SMTP_yahoo: TMenuItem
      Caption = 'YAHOO'
      OnClick = itp_SMTP_yahooClick
    end
    object itp_SMTP_microsoft_hotmail: TMenuItem
      Caption = 'Microsoft / Hotmail'
      OnClick = itp_SMTP_microsoft_hotmailClick
    end
    object itp_SMTP_aruba: TMenuItem
      Caption = 'Server Aruba'
      OnClick = dlg_impostazioniitp_SMTP_arubaClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object itp_SMTP_feaci: TMenuItem
      Caption = 'configurazione SMTP JOLLY'
      OnClick = itp_SMTP_feaciClick
    end
  end
  object AL: TActionList
    Left = 641
    Top = 15
    object AL_find: TAction
      Caption = 'AL_find'
      SecondaryShortCuts.Strings = (
        'ctrl+T')
      ShortCut = 114
      OnExecute = AL_findExecute
    end
    object AL_find_next: TAction
      Caption = 'AL_find_next'
      ShortCut = 16454
      OnExecute = AL_find_nextExecute
    end
    object AL_colore_symbolico_add: TAction
      Caption = 'aggiungi'
      OnExecute = AL_colore_symbolico_addExecute
    end
    object AL_colore_symbolico_delete: TAction
      Caption = 'elimina'
      OnExecute = AL_colore_symbolico_deleteExecute
    end
    object AL_colore_symbolico_update: TAction
      Caption = 'aggiorna'
      OnExecute = AL_colore_symbolico_updateExecute
    end
    object AL_colore_symbolico_sort: TAction
      Caption = 'ordina colori'
      OnExecute = AL_colore_symbolico_sortExecute
    end
  end
  object find_dialog: TFindDialog
    Options = [frDown, frHideMatchCase, frHideWholeWord, frHideUpDown]
    OnFind = find_dialogFind
    Left = 698
    Top = 18
  end
end
