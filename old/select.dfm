object dlg_select: Tdlg_select
  Left = 29
  Top = 139
  HelpContext = 115
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Database --> Stampa'
  ClientHeight = 439
  ClientWidth = 626
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object grid_panel: TFPanel
    Left = 0
    Top = 41
    Width = 626
    Height = 214
    Align = alClient
    Caption = 'grid_panel'
    ParentBackground = False
    TabOrder = 0
    object dbn: TDBNavigator
      Left = 1
      Top = 193
      Width = 624
      Height = 20
      DataSource = ds
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      Align = alBottom
      Hints.Strings = (
        'si sposta sul primo record'
        'record precedente'
        'record successivo'
        'si sposta sull'#39' ultimo record'
        'inserisci nuovo record'
        'elimina record selezionato'
        'modifica'
        'conferma modifiche'
        'annulla modifiche'
        'aggiorna video')
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object grid: TDBGrid
      Left = 1
      Top = 1
      Width = 624
      Height = 192
      Align = alClient
      DataSource = ds
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      PopupMenu = popup_grid
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = 'System'
      TitleFont.Style = []
      OnDblClick = gridDblClick
      OnKeyDown = gridKeyDown
    end
  end
  object panel_buttons: TFPanel
    Left = 0
    Top = 255
    Width = 626
    Height = 184
    Align = alBottom
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 1
    object pre_in_stampa_txt: TLabel
      Left = 44
      Top = 161
      Width = 133
      Height = 16
      Caption = 'si trovano in stampa'
    end
    object post_in_stampa_txt: TLabel
      Left = 242
      Top = 161
      Width = 55
      Height = 16
      Caption = 'etichette'
    end
    object txt_foglio: TLabel
      Left = 305
      Top = 161
      Width = 36
      Height = 16
      Caption = 'foglio'
    end
    object btn_close: TFBitBtn
      Left = 6
      Top = 131
      Width = 67
      Height = 23
      Hint = 'Chiude questa finestra'
      Cancel = True
      Caption = 'chiudi'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btn_closeClick
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = False
    end
    object btn_ff: TFBitBtn
      Left = 241
      Top = 131
      Width = 95
      Height = 23
      Hint = 'Invia alla stampante tutte le etichette gi'#224' stampate'
      Caption = 'sputa &foglio'
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btn_ffClick
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = False
    end
    object i_in_stampa: TEdit
      Left = 182
      Top = 157
      Width = 55
      Height = 24
      Hint = 'N'#176' di etichette in attesa di essere inviate alla stampante'
      TabStop = False
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
    end
    object btn_reset_print: TFBitBtn
      Left = 342
      Top = 131
      Width = 175
      Height = 23
      Hint = 'Elimina le etichette gi'#224' stampate'
      Caption = 's&vuota coda di stampa'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = btn_reset_printClick
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = False
    end
    object btn_preview: TFBitBtn
      Left = 79
      Top = 131
      Width = 79
      Height = 23
      Hint = 'Consente di vedere una anteprima di quello che sar'#224' stampato'
      Caption = '&preview'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btn_previewClick
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = False
    end
    object cbx_bigscreen: TCheckBox
      Left = 400
      Top = 161
      Width = 141
      Height = 21
      Hint = 'Ingrandisce l'#39'elenco dei records'
      Caption = 'elenco ingrandito'
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      Visible = False
      OnClick = cbx_bigscreenClick
    end
    object btn_how_many: TFBitBtn
      Left = 522
      Top = 131
      Width = 96
      Height = 23
      Hint = 
        'Risponde alla domanda: quanti records sono contenuti nella lista' +
        '?'
      Caption = '&quanti sono?'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = btn_how_manyClick
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = False
    end
    object btn_manuale: TFBitBtn
      Left = 164
      Top = 131
      Width = 71
      Height = 23
      Hint = 'Stampa con possibilit'#224' di modifica manuale dei dati'
      Caption = 'man&uale'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btn_manualeClick
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = False
    end
    object gb_selezione: TGroupBox
      Left = 9
      Top = 50
      Width = 617
      Height = 71
      Caption = ' seleziona '
      TabOrder = 8
      object txt_from: TLabel
        Left = 240
        Top = 16
        Width = 66
        Height = 16
        Alignment = taRightJustify
        Caption = '&dal codice'
        FocusControl = str_from
      end
      object label_select: TLabel
        Left = 10
        Top = 20
        Width = 43
        Height = 16
        Caption = 'ca&mpo'
        FocusControl = cb_select
      end
      object txt_to: TLabel
        Left = 248
        Top = 44
        Width = 58
        Height = 16
        Alignment = taRightJustify
        Caption = '&al codice'
        FocusControl = str_to
      end
      object cb_select: TComboBox
        Left = 58
        Top = 18
        Width = 173
        Height = 24
        Style = csDropDownList
        DropDownCount = 7
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object str_from: TEdit
        Left = 310
        Top = 14
        Width = 143
        Height = 24
        Hint = 
          'Seleziona tutti i codici superiori a quello selezionato (schiacc' +
          'ia APPLICA per selezionare)'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnChange = str_fromChange
      end
      object str_to: TEdit
        Left = 310
        Top = 40
        Width = 143
        Height = 24
        Hint = 
          'Seleziona tutti i codici inferiori a quello selezionato (schiacc' +
          'ia APPLICA per selezionare)'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnChange = str_toChange
      end
      object btn_applica_select: TFBitBtn
        Left = 546
        Top = 16
        Width = 61
        Height = 25
        Hint = 'Seleziona i codici DAL ... AL ...'
        Caption = 'applica'
        Default = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        OnClick = btn_applica_selectClick
        color_background_down = clBtnFace
        color_background_up = clBtnFace
        show_shortcut = False
      end
      object btn_print_select: TFBitBtn
        Left = 476
        Top = 16
        Width = 61
        Height = 25
        Hint = 'Stampa i codici DAL ... AL ...'
        Caption = '&stampa'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = btn_print_selectClick
        color_background_down = clBtnFace
        color_background_up = clBtnFace
        show_shortcut = False
      end
      object cbx_not_only_iniziali: TCheckBox
        Left = 28
        Top = 48
        Width = 179
        Height = 17
        Hint = 
          'seleziona tutti i record che nel campo indicato contengono la pa' +
          'rola specificata'
        Caption = 'cerca anche non iniziali'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = cbx_not_only_inizialiClick
      end
      object cbx_filtro: TCheckBox
        Left = 478
        Top = 46
        Width = 131
        Height = 17
        Caption = 'Usa come filtro'
        TabOrder = 6
        OnClick = cbx_filtroClick
      end
    end
    object gb_singolo_codice: TGroupBox
      Left = 9
      Top = 2
      Width = 617
      Height = 47
      Caption = ' Singolo codice '
      TabOrder = 9
      object txt_print_singolo: TLabel
        Left = 264
        Top = 20
        Width = 42
        Height = 16
        Caption = '&codice'
        FocusControl = str_print_singolo
      end
      object Label1: TLabel
        Left = 12
        Top = 22
        Width = 43
        Height = 16
        Caption = 'camp&o'
        FocusControl = cb_campo_singolo
      end
      object str_print_singolo: TEdit
        Left = 310
        Top = 14
        Width = 153
        Height = 24
        Hint = 'Codice per stampare o visualizzare un singolo record'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnChange = str_print_singoloChange
      end
      object btn_goto: TFBitBtn
        Left = 544
        Top = 14
        Width = 61
        Height = 25
        Hint = 'Visualizza il record specificato'
        Caption = 'vai a'
        Default = True
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = btn_gotoClick
        color_background_down = clBtnFace
        color_background_up = clBtnFace
        show_shortcut = False
      end
      object btn_print_singolo: TFBitBtn
        Left = 476
        Top = 14
        Width = 61
        Height = 25
        Hint = 'Stampa il record specificato'
        Caption = '&stampa'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btn_print_singoloClick
        color_background_down = clBtnFace
        color_background_up = clBtnFace
        show_shortcut = False
      end
      object cb_campo_singolo: TComboBox
        Left = 58
        Top = 17
        Width = 173
        Height = 24
        Hint = 'Campo a cui si riferisce il codice qui a lato'
        Style = csDropDownList
        DropDownCount = 7
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
    end
    object btn_print_all: TFBitBtn
      Left = 486
      Top = 157
      Width = 120
      Height = 25
      Hint = 'Stampa tutti i records in elenco'
      Caption = '&stampa TUTTO'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      OnClick = btn_print_allClick
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = False
    end
  end
  object Panel1: TFPanel
    Left = 0
    Top = 0
    Width = 626
    Height = 41
    Align = alTop
    ParentBackground = False
    TabOrder = 2
    object gb_orderby: TGroupBox
      Left = 9
      Top = -1
      Width = 478
      Height = 37
      TabOrder = 0
      object cb_sort: TComboBox
        Left = 212
        Top = 10
        Width = 191
        Height = 24
        Style = csDropDownList
        DropDownCount = 7
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object btn_sort: TFBitBtn
        Left = 410
        Top = 10
        Width = 61
        Height = 23
        Hint = 'Esegue l'#39'ordinamento dei records'
        Caption = 'ord&ina!'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btn_sortClick
        color_background_down = clBtnFace
        color_background_up = clBtnFace
        show_shortcut = False
      end
      object cbx_sort: TCheckBox
        Left = 18
        Top = 13
        Width = 187
        Height = 17
        Hint = 
          'Abilita l'#39'ordinamento dei records - ATTENZIONE: per ordinare i r' +
          'ecords seleziona il campo in base a cui selezionare e schiaccia ' +
          'ORDINA'
        Caption = 'o&rdina secondo il campo'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = cbx_sortClick
      end
    end
    object btn_comando_manuale: TFBitBtn
      Left = 498
      Top = 7
      Width = 111
      Height = 27
      Caption = 'Comando SQ&L'
      TabOrder = 1
      OnClick = btn_comando_manualeClick
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = False
    end
  end
  object ds: TDataSource
    DataSet = tbl
    Left = 94
    Top = 132
  end
  object popup_grid: TPopupMenu
    OnPopup = popup_gridPopup
    Left = 176
    Top = 130
    object impostaDA1: TMenuItem
      Caption = 'imposta "DA ..."'
      OnClick = impostaDA1Click
    end
    object impostaA1: TMenuItem
      Caption = 'imposta "A ..."'
      OnClick = impostaA1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object stamparecordselezionato1: TMenuItem
      Caption = 'stampa record selezionato'
      OnClick = stamparecordselezionato1Click
    end
  end
  object tbl: TTable
    AutoCalcFields = False
    Left = 56
    Top = 132
  end
  object qry: TFQuery
    Active = False
    ObjectView = True
    UpdateOptions.AssignedValues = [uvUpdateMode]
    REQUESTLIVE = True
    UPDATEMODE = upWhereKeyOnly
    Left = 23
    Top = 132
  end
end
