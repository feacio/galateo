object dlg_sezione: Tdlg_sezione
  Left = 649
  Top = 252
  BorderIcons = [biSystemMenu, biMaximize]
  ClientHeight = 381
  ClientWidth = 574
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 16
  object panel_bottoni: TFPanel
    Left = 0
    Top = 340
    Width = 574
    Height = 41
    Align = alBottom
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      574
      41)
    object btn_ok: TFBitBtn
      Left = 25
      Top = 10
      Width = 90
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
      Left = 125
      Top = 10
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
      Left = 483
      Top = 8
      Width = 87
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Aiuto'
      TabOrder = 2
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
    object btn_genera_SQL: TFBitBtn
      Left = 231
      Top = 10
      Width = 157
      Height = 25
      Caption = 'genera comando SQL'
      TabOrder = 3
      OnClick = btn_genera_SQLClick
      NumGlyphs = 2
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = False
    end
  end
  object pc: TPageControl
    Left = 0
    Top = 0
    Width = 574
    Height = 340
    ActivePage = pagina_logica
    Align = alClient
    TabOrder = 1
    OnChange = generic_enable_ctrls
    object page_SQL: TTabSheet
      Caption = 'SQL'
      object str_SQL_select: TMemo
        Left = 0
        Top = 0
        Width = 566
        Height = 276
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
        OnKeyDown = str_SQL_selectKeyDown
      end
      object panel_SQL_filename: TFPanel
        Left = 0
        Top = 276
        Width = 566
        Height = 33
        Align = alBottom
        ParentBackground = False
        TabOrder = 1
        DesignSize = (
          566
          33)
        object cbx_SQL_save_to: TFCheckBox
          Left = 18
          Top = 8
          Width = 83
          Height = 17
          Caption = 'salva su'
          TabOrder = 0
          OnClick = generic_enable_ctrls
          AAA_NeedNotifyModification = False
        end
        object cbx_SQL_read_from: TFCheckBox
          Left = 112
          Top = 8
          Width = 79
          Height = 17
          Caption = 'leggi da'
          TabOrder = 1
          OnClick = generic_enable_ctrls
          AAA_NeedNotifyModification = False
        end
        object str_SQL_filename: TFEdit
          Left = 212
          Top = 4
          Width = 314
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          Text = 'str_SQL_filename'
          AAA_tipodato = fe_generico
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object btn_browse_SQL_filename: TFBitBtn
          Left = 532
          Top = 4
          Width = 23
          Height = 24
          Anchors = [akTop, akRight]
          Caption = '...'
          ParentShowHint = False
          ShowHint = False
          TabOrder = 3
          OnClick = btn_browse_SQL_filenameClick
          color_background_down = clBtnFace
          color_background_up = clBtnFace
          show_shortcut = False
        end
      end
    end
    object formattazione: TTabSheet
      Caption = 'generali'
      DesignSize = (
        566
        309)
      object txt_nome: TLabel
        Left = 12
        Top = 10
        Width = 128
        Height = 16
        Caption = '&nome della sezione'
        FocusControl = str_nome
      end
      object txt_record_name: TLabel
        Left = 7
        Top = 249
        Width = 234
        Height = 16
        Caption = 'descrizione record (usa il singolare)'
        FocusControl = str_record_name
      end
      object txt_obj_pos_width: TLabel
        Left = 203
        Top = 142
        Width = 258
        Height = 16
        Caption = 'usa posizione, larghezza e spessore di'
        FocusControl = cb_obj_pos_width
      end
      object txt_codice_record: TLabel
        Left = 275
        Top = 224
        Width = 87
        Height = 16
        Alignment = taRightJustify
        Caption = 'codice record'
        FocusControl = cb_codice_record
      end
      object txt_group_by_section: TLabel
        Left = 307
        Top = 243
        Width = 57
        Height = 32
        Alignment = taRightJustify
        Caption = 'group by'#13#10'sezione'
        FocusControl = cb_group_by_section
      end
      object txt_SQL_PK_debug_field: TLabel
        Left = 261
        Top = 281
        Width = 103
        Height = 16
        Alignment = taRightJustify
        Caption = 'SQL debug field'
        FocusControl = str_SQL_PK_debug_field
      end
      object gbox_pos_size: TGroupBox
        Left = 0
        Top = 32
        Width = 521
        Height = 108
        Caption = 'Dimensioni e posizione'
        TabOrder = 3
        object txt_y0_rel: TLabel
          Left = 19
          Top = 17
          Width = 207
          Height = 32
          Alignment = taRightJustify
          Caption = 'posizione margine superiore '#13#10'(relativa alla sezione superiore)'
          FocusControl = r_y0_rel
        end
        object txt_dy_gruppo: TLabel
          Left = 20
          Top = 82
          Width = 206
          Height = 16
          Caption = 'a&ltezza di ogni gruppo di record'
          FocusControl = r_dy_gruppo
        end
        object txt_dy_sezione: TLabel
          Left = 82
          Top = 54
          Width = 144
          Height = 16
          Caption = '&altezza totale sezione'
          FocusControl = r_dy_sezione
        end
        object txt_minimum_required_space: TLabel
          Left = 346
          Top = 23
          Width = 120
          Height = 32
          Alignment = taCenter
          Caption = 'stampa la sezione'#13#10'se ci sono almeno'
          FocusControl = r_minimum_required_space
        end
        object txt_minimum_required_space2: TLabel
          Left = 361
          Top = 80
          Width = 91
          Height = 16
          Alignment = taCenter
          Caption = 'cm disponibili'
          FocusControl = r_minimum_required_space
        end
        object r_y0_rel: TEdit
          Left = 230
          Top = 21
          Width = 64
          Height = 24
          TabOrder = 0
        end
        object r_dy_gruppo: TEdit
          Left = 230
          Top = 78
          Width = 64
          Height = 24
          TabOrder = 2
          OnChange = r_dy_gruppoChange
        end
        object r_dy_sezione: TEdit
          Left = 230
          Top = 50
          Width = 64
          Height = 24
          TabOrder = 1
        end
        object r_minimum_required_space: TEdit
          Left = 374
          Top = 55
          Width = 64
          Height = 24
          TabOrder = 3
        end
      end
      object str_nome: TEdit
        Left = 144
        Top = 6
        Width = 177
        Height = 24
        TabOrder = 0
      end
      object btn_font: TFBitBtn
        Left = 332
        Top = 2
        Width = 73
        Height = 33
        Caption = 'font'
        TabOrder = 1
        OnClick = btn_fontClick
        Glyph.Data = {
          BE060000424DBE060000000000003604000028000000160000001B0000000100
          0800000000008802000000000000000000000001000000010000000000000000
          80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
          A400D6AD7B00DEB58400D6AD7300DEAD7B00DEBD9400DEB57B00DEB58C00DEBD
          8C00DEC69C00EFDECE00EFE7DE00E7C6A500E7D6BD00E7CEAD00E7CEA500F7EF
          E700EFE7E700DEBD9C00D6B57B00DEAD7300EFDEC600E7CEB500F7F7F700F7EF
          EF00DEBD8400F7F7EF00E7D6B500EFE7D600E7D6C600E7C69C00EFE7CE00EFD6
          BD00EFEFDE00F7E7DE00F7EFDE00F7F7E700DEB57300EFD6B500E7BD9C00F7E7
          D600EFDED600EFDEBD00EFD6C600FFF7F700E7BD9400DEC69400EFCEB500E7C6
          AD00FFFFF700F7F7FF00F7FFF700F7DECE00F7E7CE00E7D6AD00E7C69400FFF7
          FF00EFCEAD00E7CE9C00E7BD8C00F7FFFF00EFD6AD00E7B58C00E7B58400EFCE
          A5000000BF0000BF000000BFBF00BF000000BF00BF00BFBF00009F7F3F009F7F
          5F009F7F7F009F7F9F009F7FBF009F7FDF009F7FFF009F9F3F009F9F5F009F9F
          7F009F9F9F009F9FBF009F9FDF009F9FFF009FBF3F009FBF5F009FBF7F009FBF
          9F009FBFBF009FBFDF009FBFFF009FDF3F009FDF5F009FDF7F009FDF9F009FDF
          BF009FDFDF009FDFFF009FFF3F009FFF5F009FFF7F009FFF9F009FFFBF009FFF
          DF009FFFFF00BF3F3F00BF3F5F00BF3F7F00BF3F9F00BF3FBF00BF3FDF00BF3F
          FF00BF5F3F00BF5F5F00BF5F7F00BF5F9F00BF5FBF00BF5FDF00BF5FFF00BF7F
          3F00BF7F5F00BF7F7F00BF7F9F00BF7FBF00BF7FDF00BF7FFF00BF9F3F00BF9F
          5F00BF9F7F00BF9F9F00BF9FBF00BF9FDF00BF9FFF00BFBF3F00BFBF5F00BFBF
          7F00BFBF9F00BFBFBF00BFBFDF00BFBFFF00BFDF3F00BFDF5F00BFDF7F00BFDF
          9F00BFDFBF00BFDFDF000000C00000C0000000C0C000C0000000C000C000C0C0
          00005FBF3F005FBF5F005FBF7F005FBF9F005FBFBF005FBFDF005FBFFF005FDF
          3F005FDF5F005FDF7F005FDF9F005FDFBF005FDFDF005FDFFF005FFF3F005FFF
          5F005FFF7F005FFF9F005FFFBF005FFFDF005FFFFF007F3F3F007F3F5F007F3F
          7F007F3F9F007F3FBF007F3FDF007F3FFF007F5F3F007F5F5F007F5F7F007F5F
          9F007F5FBF007F5FDF007F5FFF007F7F3F007F7F5F007F7F7F007F7F9F007F7F
          BF007F7FDF007F7FFF007F9F3F007F9F5F007F9F7F007F9F9F007F9FBF007F9F
          DF007F9FFF007FBF3F007FBF5F007FBF7F007FBF9F007FBFBF007FBFDF007FBF
          FF007FDF3F007FDF5F007FDF7F007FDF9F007FDFBF007FDFDF007FDFFF007FFF
          3F007FFF5F007FFF7F007FFF9F007FFFBF007FFFDF007FFFFF009F3F3F009F3F
          5F009F3F7F009F3F9F009F3FBF009F3FDF009F3FFF009F5F3F009F5F5F009F5F
          7F009F5F9F009F5FBF009F5FDF009F5FFF00F0FBFF00A4A0A000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
          070707070707FEFF0707F8FEFEF8FF070000070707070707070707070707FE07
          FFFF0707FEFE07FE0000070707070707070707070707F8FFFFFEFFFE07FE0707
          0000070707070707070707070707FE07FEFE07F807FEFFFE0000070707070707
          07070707070707FE0707FF07FFFE07FE0000070707070707070707070707FE07
          FEFF07F807FE07070000070707070707070707070707FFF8FE0707FF07FEFF07
          0000070707070707070707070707FEFE07FFFFFF07FEFE070000070707070707
          07070707070707FEFE0707FFFEF8FE07000007070707070707070707070707FE
          07FEFEFFFEFE0707000007070707070707070707070700000000000000000007
          000007070707070707070707070700F8F8F807FF070700070000070707070707
          07070707070700F8F8F807FF0707000700000707070707070707070707070700
          F8F8F8F8FFF80007000007070707070707070707070700F80707FFFF07000707
          0000070700000000000000000000F8070707FFFF0700070700000707F8F8F8F8
          F8F8F8F8F8F8070707FFFF0700070707000007070707070707070707070707FF
          FFFFFF070007070700000707FFFFFFFFFFFFFFFFFFFFFFFFFFFF070007070707
          00000707FF07FF07FF07FF07FF07FF07FF000007070707070000070700000000
          00F807FF07000000000707070707070700000707070707070700000000070707
          0707070707070707000007070707070707070000070707070707070707070707
          0000070707F8F9F8F9F8F9F8F9F8F9F80707070707070707000007070707FFF9
          FFF9FFF9FFF9FF07070707070707070700000707070707070707070707070707
          0707070707070707000007070707070707070707070707070707070707070707
          0000}
        Layout = blGlyphRight
        color_background_down = clBtnFace
        color_background_up = clBtnFace
        show_shortcut = False
      end
      object cbx_conta_records: TFCheckBox
        Left = 4
        Top = 216
        Width = 256
        Height = 17
        Hint = 
          'I records della sezione sono utilizzati per dare un feedback all' +
          #39'utente'
        Caption = 'incrementa runtime records counter'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        OnClick = cbx_conta_recordsClick
        AAA_NeedNotifyModification = False
      end
      object str_record_name: TEdit
        Left = 48
        Top = 265
        Width = 174
        Height = 24
        Hint = 'si consiglia di usare il singolare'
        MaxLength = 30
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
      end
      object rb_draw: TRadioGroup
        Left = 3
        Top = 142
        Width = 181
        Height = 66
        Caption = 'Elementi grafici sezione'
        Items.Strings = (
          'Nulla'
          'Rettangolo'
          'Linea di fondo')
        TabOrder = 4
        TabStop = True
        OnClick = generic_enable_ctrls
      end
      object cbx_draw_last_line: TFCheckBox
        Left = 213
        Top = 183
        Width = 275
        Height = 17
        Hint = 
          'Stampa la linea che si trova sotto l'#39'ultima ricorrenza della sez' +
          'ione.'#13#10'Se si utilizza una cornice esterna '#232' preferibile non atti' +
          'vare l'#39'opzione.'
        Caption = 'stampa la linea sotto l'#39'ultima sezione'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        OnClick = cbx_conta_recordsClick
        AAA_NeedNotifyModification = False
      end
      object cb_codice_record: TFCombo
        Left = 368
        Top = 220
        Width = 157
        Height = 24
        Hint = 'il campo viene usato per la compilazione dell'#39'indice dei records'
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        DropDownCount = 16
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
        AAA_dropdownwidth = 250
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
      object cb_obj_pos_width: TFCombo
        Left = 204
        Top = 157
        Width = 319
        Height = 24
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        DropDownCount = 16
        TabOrder = 5
        OnChange = generic_enable_ctrls
        AAA_dropdownwidth = 0
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
      object cbx_double_thickness: TFCheckBox
        Left = 213
        Top = 199
        Width = 136
        Height = 17
        Hint = 'raddoppia lo spessore dell'#39'oggetto specificato'
        Caption = 'doppio spessore'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = cbx_conta_recordsClick
        AAA_NeedNotifyModification = False
      end
      object cb_group_by_section: TFCombo
        Left = 368
        Top = 249
        Width = 157
        Height = 24
        Hint = 
          'serve per assegnare il valore delle funzioni'#13#10'SECTION_GROUP_FIRS' +
          'T()'#13#10'SECTION_GROUP_MIDDLE()'#13#10'SECTION_GROUP_LAST()'
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        DropDownCount = 16
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
        AAA_dropdownwidth = 250
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
      object btn_assegna_font: TFBitBtn
        Left = 416
        Top = 2
        Width = 117
        Height = 33
        Hint = 'assegna il font della sezione a tutti gli oggetti'
        Caption = 'assegna font'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btn_assegna_fontClick
        Glyph.Data = {
          62010000424D620100000000000042000000280000000C0000000C0000000100
          100003000000200100000000000000000000000000000000000000F80000E007
          00001F000000FFCF302B6D1A6E1A6F22902A5022B22AB32A922213339FBF1023
          EB01EF2A513B6F224F2AB1327122712271220F125333F022312B4D1A4D22D774
          FFE7DFDF4E2A702A902A9122701A0E0A112B8F228E2A6D2A9574FFE7FFE78F32
          4E22D12A901A142B501AD12A4E2A0B2AEE427374FFE7FFE78E2A6E228F22F109
          9222DFCFFFDFFFE7DFE7FFE7FFE79FD7FFDFAF22F02A931A9743FFCFBFCFFFE7
          FFE7FFE7FFE7FFE79FCFAE22AF22941AAF0191224E22AE322B2AF584FFE7FFDF
          CE2AAE221133921AB2221333123B4D229574FFE7BFD7AE324D220D12F12A7012
          332B2E126F227664FFDFFFDF4E22ED117343D12A0E12F11A6F12B022F12AD132
          4F22912A912AF332CE09501AB222FFCFAF1AB0224F1A90225022B232101A5122
          B2229222FFD7}
        color_background_down = clBtnFace
        color_background_up = clBtnFace
        show_shortcut = False
      end
      object str_SQL_PK_debug_field: TEdit
        Left = 368
        Top = 278
        Width = 157
        Height = 24
        Hint = 
          'nome del campo SQL utilizzato per '#39'marcare'#39' il record in fase di' +
          ' debug'#13#10' '#13#10'si tratta tipicamente della PRIMARY KEY del record le' +
          'tto,'#13#10'e deve essere tassativamente un campo disponibile sulla qu' +
          'ery SQL'
        Anchors = [akLeft, akTop, akRight]
        MaxLength = 30
        ParentShowHint = False
        ShowHint = True
        TabOrder = 12
      end
    end
    object page_opzioni: TTabSheet
      Caption = 'impaginazione'
      DesignSize = (
        566
        309)
      object txt_index_info: TLabel
        Left = 4
        Top = 169
        Width = 498
        Height = 48
        Caption = 
          'Al caricamento di ogni record viene eseguito il seguente script ' +
          'SQL (che pu'#242' '#13#10'essere utilizzato ad esempio per generare un indi' +
          'ce dei contenuti).'#13#10'E'#39' possibile utilizzare i campi del database' +
          ' e le formule di GALATEO'
      end
      object cbx_dont_break_fields: TFCheckBox
        Left = 44
        Top = 4
        Width = 391
        Height = 17
        Hint = 
          'Se possibile mantiene sulla stessa pagina tutti i campi della st' +
          'essa sezione.'#13#10'In caso d'#39'incertezza, lasciare l'#39'opzione ATTIVATA' +
          '.'#13#10#13#10'Sotto certe condizioni, e'#39' possibile che certe sezioni sian' +
          'o ristampate '#13#10'senza evidenti differenze su due pagine consecuti' +
          've.'
        Caption = 'mantieni sulla stessa pagina tutti i campi della sezione'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = generic_enable_ctrls
        AAA_NeedNotifyModification = False
      end
      object cbx_blanks: TFCheckBox
        Left = 44
        Top = 78
        Width = 258
        Height = 17
        Hint = 
          'Le righe contenenti solo campi vuoti vengono '#13#10'eliminate, e i ca' +
          'mpi sottostanti vengono spostati verso l'#39'alto '#13#10'(anche in funzio' +
          'ne delle indicazioni di formato dei singoli campi).'
        Caption = 'elimina le righe con tutti valori nulli'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = generic_enable_ctrls
        AAA_NeedNotifyModification = False
      end
      object cbx_fill_tutto: TFCheckBox
        Left = 44
        Top = 96
        Width = 314
        Height = 17
        Hint = 
          'La sezione occupa sempre l'#39'intero spazio a sua disposizione.'#13#10'Se' +
          ' l'#39'opzione non '#232' selezionata e rimane spazio vuoto sul fondo del' +
          'la'#13#10'sezione i campi sottostanti vengono alzati.'
        Caption = 'occupa sempre tutto lo spazio della sezione'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        OnClick = generic_enable_ctrls
        AAA_NeedNotifyModification = False
      end
      object cbx_bo_stampa_anche_se_vuota: TFCheckBox
        Left = 44
        Top = 114
        Width = 314
        Height = 17
        Caption = 'stampa la sezione anche se priva di records'
        TabOrder = 6
        OnClick = generic_enable_ctrls
        AAA_NeedNotifyModification = False
      end
      object cbx_bo_senza_dati: TFCheckBox
        Left = 265
        Top = 132
        Width = 217
        Height = 17
        Hint = 'Stampa la sezione in bianco, senza dati'
        Caption = 'stampa senza dati (in bianco)'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        OnClick = generic_enable_ctrls
        AAA_NeedNotifyModification = False
      end
      object cbx_dont_print: TFCheckBox
        Left = 44
        Top = 132
        Width = 203
        Height = 17
        Hint = 'Non effettua nessun tipo di output per la sezione'
        Caption = 'non stampare la sezione'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = generic_enable_ctrls
        AAA_NeedNotifyModification = False
      end
      object cbx_dont_break_subsections: TFCheckBox
        Left = 44
        Top = 22
        Width = 353
        Height = 17
        Hint = 
          'Se possibile, mantiene tutte le sottosezioni sulla '#13#10'stessa pagi' +
          'na, eventualmente generando un salto pagina.'
        Caption = 'mantieni sulla stessa pagina tutte le sottosezioni'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = generic_enable_ctrls
        AAA_NeedNotifyModification = False
      end
      object cbx_reprint: TFCheckBox
        Left = 44
        Top = 40
        Width = 418
        Height = 17
        Hint = 
          'Se le sottosezioni occupano pi'#249' pagine'#13#10'i campi della sezione ve' +
          'ngono stampati su ogni pagina'
        Caption = 'ristampa la sezione se le sottosezioni vanno su pi'#249' pagine'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = generic_enable_ctrls
        AAA_NeedNotifyModification = False
      end
      object memo_start_record: TMemo
        Left = 0
        Top = 218
        Width = 574
        Height = 103
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 9
      end
      object btn_index_esempio: TButton
        Left = 455
        Top = 192
        Width = 75
        Height = 25
        Caption = 'esempio'
        TabOrder = 10
        OnClick = btn_index_esempioClick
      end
      object cbx_print_only_if_subsection_has_records: TFCheckBox
        Left = 44
        Top = 150
        Width = 417
        Height = 17
        Caption = 'non stampare la sezione se la sottosezione '#232' priva di dati'
        TabOrder = 11
        OnClick = generic_enable_ctrls
        AAA_NeedNotifyModification = False
      end
      object cbx_autosize: TFCheckBox
        Left = 44
        Top = 58
        Width = 449
        Height = 17
        Caption = 'ridimensiona la sezione in accordo con la dimensione del foglio'
        TabOrder = 3
        OnClick = generic_enable_ctrls
        AAA_NeedNotifyModification = False
      end
    end
    object st_procs: TTabSheet
      Caption = 'stored procs'
      object txt_SP: TLabel
        Left = 0
        Top = 0
        Width = 566
        Height = 48
        Align = alTop
        Alignment = taCenter
        Caption = 
          'Le stored procedures inserite (1 per riga) in questa schermata s' +
          'aranno eseguite'#13#10'DOPO l'#39'assegnazione del valore delle variabili ' +
          'della sezione'#13#10'e PRIMA del calcolo delle formule.'
        ExplicitWidth = 518
      end
      object memo_scripts: TMemo
        Left = 0
        Top = 48
        Width = 566
        Height = 261
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object pagina_logica: TTabSheet
      Caption = 'pagina'
      ImageIndex = 4
      object txt_size_page_x: TLabel
        Left = 14
        Top = 73
        Width = 188
        Height = 16
        Alignment = taRightJustify
        Caption = 'LARGHEZZA netta pagina cm'
        FocusControl = r_size_page_x
      end
      object txt_size_page_y: TLabel
        Left = 278
        Top = 73
        Width = 166
        Height = 16
        Alignment = taRightJustify
        Caption = 'ALTEZZA netta pagina cm'
        FocusControl = r_size_page_y
      end
      object rb_orientamento: TRadioGroup
        Left = 29
        Top = 5
        Width = 212
        Height = 44
        Caption = 'Orientamento pagina'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'Verticale'
          'Orizzontale')
        TabOrder = 0
        OnClick = rb_orientamentoClick
      end
      object btn_standard_labels: TButton
        Left = 306
        Top = 2
        Width = 133
        Height = 25
        Caption = 'etichette standard'
        Enabled = False
        TabOrder = 1
        OnClick = btn_standard_labelsClick
      end
      object btn_page_size: TButton
        Left = 267
        Top = 30
        Width = 244
        Height = 25
        Caption = 'carica dimensione foglio stampante'
        TabOrder = 4
        OnClick = btn_page_sizeClick
      end
      object r_size_page_x: TEdit
        Left = 205
        Top = 69
        Width = 57
        Height = 24
        TabOrder = 2
      end
      object r_size_page_y: TEdit
        Left = 447
        Top = 69
        Width = 57
        Height = 24
        TabOrder = 3
      end
      object panel_profiles: TFPanel
        Left = 0
        Top = 101
        Width = 566
        Height = 208
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        ParentBackground = False
        TabOrder = 5
        object panel_profiles_header: TFPanel
          Left = 1
          Top = 1
          Width = 564
          Height = 106
          Align = alTop
          Color = 13041663
          ParentBackground = False
          TabOrder = 0
          DesignSize = (
            564
            106)
          object txt_profiles: TLabel
            Left = 11
            Top = 14
            Width = 81
            Height = 16
            Caption = 'nome profilo'
            FocusControl = cb_profiles
          end
          object cb_profiles: TFCombo
            Left = 99
            Top = 10
            Width = 126
            Height = 24
            Hint = 
              'i profili consentono di selezionare determinate configurazioni '#13 +
              #10'di stampa in funzione di parametri  forniti runtime dall'#39'applic' +
              'azione'#13#10'che esegue la stampa'#13#10'se nessun profilo '#232' definito (o ut' +
              'ilizzabile), viene utilizzato il primo profilo'
            Style = csDropDownList
            DropDownCount = 16
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnCloseUp = cb_profilesExit
            OnExit = cb_profilesExit
            AAA_dropdownwidth = 0
            AAA_NeedNotifyModification = False
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = True
          end
          object btn_new_doc: TFBitBtn
            Left = 241
            Top = 8
            Width = 135
            Height = 28
            Caption = 'Aggiungi profilo'
            TabOrder = 1
            OnClick = btn_new_docClick
            Glyph.Data = {
              36050000424D3605000000000000360400002800000010000000100000000100
              0800000000000001000000000000000000000001000000010000000000004000
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
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000
              000000000000FFFFFFFFFF00FCFFFCFFFCFFFCFFFC00FFFFFFFFFF00FFFCFFFC
              FFFCFFFCFF00FFFFFFFFFF00FCFFFCFFFCFFFCFFFC00FFFFFFFFFF00FFFCFFFC
              FFFCFFFCFF00FFFF00FFFF00FCFFFCFFFCFFFCFFFC00FF00FFFFFF00FFFCFFFC
              FFFCFFFCFF0000FFFFFFFF00000000000000000000FFFF00FF00FFFF00FCFFFC
              FF00FFFF00FF00FFFFFFFFFFFF00000000FFFF00FF00FF00FFFFFFFFFFFFFFFF
              FFFF00FFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFF}
            Spacing = 5
            color_background_down = clBtnFace
            color_background_up = clBtnFace
            show_shortcut = False
          end
          object btn_delete_doc: TFBitBtn
            Left = 382
            Top = 8
            Width = 92
            Height = 28
            Caption = 'Elimina'
            TabOrder = 2
            OnClick = btn_delete_docClick
            Glyph.Data = {
              4E010000424D4E01000000000000760000002800000012000000120000000100
              040000000000D800000000000000000000001000000010000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00771777777777
              77777700000079917777777777777900000079991777777777777700000079B9
              91777777777797000000779B917777777779770000007779B917777777917700
              0000777799177777791777000000777779917777917777000000777777991779
              1777770000007777777991917777770000007777777799177777770000007777
              7779919177777700000077777799177917777700000077779991777791777700
              00007799B917777779177700000079B9917777777791770000009B9917777777
              777797000000899877777777777777000000}
            Spacing = 5
            color_background_down = clBtnFace
            color_background_up = clBtnFace
            show_shortcut = False
          end
          object gbox_condizioni_profili: TFGroupBox
            Left = 8
            Top = 36
            Width = 509
            Height = 63
            Caption = 'condizioni di attivazione profilo'
            TabOrder = 3
            object txt_profilo_workstation: TMyLabel
              Left = 16
              Top = 16
              Width = 60
              Height = 16
              Caption = 'computer'
              FocusControl = str_profilo_workstation
            end
            object txt_profilo_username: TMyLabel
              Left = 334
              Top = 16
              Width = 114
              Height = 16
              Alignment = taRightJustify
              Caption = 'account Windows'
              FocusControl = str_profilo_username
            end
            object txt_profilo_IP: TMyLabel
              Left = 177
              Top = 16
              Width = 74
              Height = 16
              Caption = 'indirizzo IP'
              FocusControl = str_profilo_IP
            end
            object btn_profilo_workstation: TFBitBtn
              Left = 145
              Top = 30
              Width = 24
              Height = 28
              Hint = 'imposta il nome del computer su cui stai lavorando'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnClick = btn_profilo_workstationClick
              Glyph.Data = {
                36050000424D360500000000000036040000280000000D000000100000000100
                0800000000000001000000000000000000000001000000000000000000000000
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
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFF6FFF69393
                93939393FFF6F6000000F6F6F6A3EDF5EDED9B9393F6F6000000FFF6ED080807
                07EDDBE493F6FF000000F6F6EDF6F60807E49BE493F6F6000000F6F6FFEDF608
                F59BD2E493F6FF000000F6F6F6E4EEEDE49A9293F6F6F6000000FFF6F6ECF1F4
                EDDBD29393F6FF000000F6F6ECEAEAEAEAF3EDDB9393F6000000F6F6ECEBF2F3
                F3F3F2EAEB93F6000000F6F6EDF2F3F3F3F3F3F2E393F6000000FFED09F30909
                090909F3E393FF000000F6ED0909090909090909DB93F6000000F6ED09090909
                090909099A93FF000000F6EDF7F50909F60909099293F6000000FFEDEDEDECEE
                EDED09ED9293FF000000F6F6F6F6F6EDEDEDEDEDEDF6F6000000}
              Spacing = 5
              color_background_down = clBtnFace
              color_background_up = clBtnFace
              show_shortcut = False
            end
            object btn_profilo_username: TFBitBtn
              Left = 473
              Top = 30
              Width = 24
              Height = 28
              Hint = '*** runtime'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 5
              OnClick = btn_profilo_usernameClick
              Glyph.Data = {
                42080000424D4208000000000000420000002800000020000000200000000100
                1000030000000008000000000000000000000000000000000000007C0000E003
                00001F000000BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                1F001F00BB771F001F00BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F00
                1F001F00BB771F001F001F00BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F00
                1F001F00BB771F001F001F00BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F00
                1F001F00BB771F001F001F00BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F00
                1F001F00BB771F001F001F00BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F00
                1F001F00BB771F001F001F00BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F00
                1F001F001F001F001F001F00BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F00
                1F001F001F001F001F001F00BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F00BB771F00
                1F001F001F001F001F001F00BB771F00BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F001F00BB771F00
                1F001F001F001F001F001F00BB771F001F00BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F001F00BB771F00
                1F001F001F001F001F001F00BB771F001F00BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F001F00BB77BB77
                1F001F001F001F001F00BB77BB771F001F00BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F001F00BB771F00
                1F001F00BB771F001F001F00BB771F001F00BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F001F00BB771F00
                1F001F00BB771F001F001F00BB771F001F00BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F001F00BB771F00
                1F001F00BB771F001F001F00BB771F001F00BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F001F001F001F00
                1F001F00BB771F001F001F001F001F001F00BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F001F001F001F00
                1F001F00BB771F001F001F001F001F001F00BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F001F001F001F00
                1F001F00BB771F001F001F001F001F001F00BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F001F00BB77
                BB77BB77BB77BB77BB77BB771F001F00BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB771F001F001F00BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                1F001F001F001F001F00BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F00
                1F001F001F001F001F001F00BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F00
                1F001F001F001F001F001F00BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771F00
                1F001F001F001F001F001F00BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                1F001F001F001F001F00BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB771F001F001F00BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77}
              Spacing = 5
              color_background_down = clBtnFace
              color_background_up = clBtnFace
              show_shortcut = False
            end
            object str_profilo_workstation: TFEdit
              Left = 12
              Top = 32
              Width = 128
              Height = 24
              TabOrder = 0
              AAA_tipodato = fe_generico
              AAA_NeedNotifyModification = False
              AAA_CanBeVoid = True
              AAA_CanBeInvalid = True
            end
            object str_profilo_username: TFEdit
              Left = 336
              Top = 32
              Width = 133
              Height = 24
              TabOrder = 4
              AAA_tipodato = fe_generico
              AAA_NeedNotifyModification = False
              AAA_CanBeVoid = True
              AAA_CanBeInvalid = True
            end
            object str_profilo_IP: TFEdit
              Left = 173
              Top = 32
              Width = 128
              Height = 24
              TabOrder = 2
              AAA_tipodato = fe_generico
              AAA_NeedNotifyModification = False
              AAA_CanBeVoid = True
              AAA_CanBeInvalid = True
            end
            object btn_profilo_IP: TFBitBtn
              Left = 306
              Top = 30
              Width = 24
              Height = 28
              Hint = 'imposta il nome del computer su cui stai lavorando'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
              OnClick = btn_profilo_IPClick
              Glyph.Data = {
                42080000424D4208000000000000420000002800000020000000200000000100
                1000030000000008000000000000000000000000000000000000007C0000E003
                00001F000000BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB771042BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB771042BB77BB77
                BB77BB77BB77BB77BB77BB7700001042BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB7700001042BB77BB77
                BB77BB77BB77BB77BB77BB7700001042BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77000010421042BB77
                BB77BB77BB77BB77BB77BB7700001042BB77BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB770000000000001042BB77
                BB77BB77BB77BB77BB77BB7700001042BB77BB77BB77BB77BB77104210421042
                10421042BB77BB77BB77BB77BB77BB77BB771042104200001042000010421042
                10421042BB77BB77BB77BB7700001042BB77BB77BB77BB770000000000000000
                0000BB771042BB77BB77BB77BB77BB7700000000000000000000000000000000
                000010421042BB77BB77BB7700001042BB77BB77BB770000BB77BB77BB77BB77
                BB770000BB771042BB77BB77BB7700001863FF7FFF7FFF7FFF7FFF7FFF7FFF7F
                FF7F00001042BB77BB77BB7700001042BB77BB7700001042BB77BB77BB77BB77
                BB77BB7700001042BB77BB77BB77000018631863186318631863186318631863
                FF7F00001042BB77BB77BB7700001042BB77BB7700001042BB77BB77BB77BB77
                BB77BB7700001042BB77BB77BB77000018631863186318631863186318631863
                FF7F00001042BB77BB77BB7700001042BB77BB7700001042BB77BB77BB77BB77
                BB77BB77000010421042BB77BB77000018631863186318631863186318631863
                FF7F00001042BB77BB77BB7700001042BB77BB7700001042BB77BB77BB77BB77
                BB7700000000000010421042BB77000018631863186318631863186318631863
                FF7F00001042BB77BB77BB7700001042BB77BB7700001042BB77BB77BB77BB77
                00001863FF7F186300001042BB77000018631863186318631863186318631863
                FF7F00001042BB77BB77BB7700001042BB77BB7700001042BB77BB77BB77BB77
                0000FF7F1863FF7F00001042BB77000018631863186318631863186318631863
                FF7F00001042BB77BB77BB77000010421042BB77000010421042BB77BB77BB77
                00001863FF7F186300001042BB77000018631863186318631863186318631863
                FF7F00001042BB77BB7700000000000010420000000000001042BB77BB77BB77
                0000FF7F1863FF7F00001042BB77000018631863186318631863186318631863
                18630000BB77BB77BB77000010420000104200001042000010421042BB77BB77
                00001863FF7F186300001042BB77BB7700000000000000000000000000000000
                0000BB77BB77BB7700000000000000000000000000000000000010421042BB77
                0000FF7F1863FF7F00001042BB77BB77BB770000104200001042000010420000
                1042BB77BB7700001863FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F00001042BB77
                00001863FF7F186300001042BB77BB77BB77000000000000BB77000000000000
                BB77BB77BB77000018631863186318631863186318631863FF7F00001042BB77
                0000FF7F1863FF7F00001042BB77BB77BB77BB7700001042BB77BB7700001042
                BB77BB77BB77000018631863186318631863186318631863FF7F00001042BB77
                00001863FF7F186300001042BB77BB77BB77BB7700001042BB77BB7700001042
                BB77BB77BB77000018631863186318631863186318631863FF7F00001042BB77
                0000FF7F1863FF7F0000BB77BB77BB77BB77BB7700001042BB77BB7700001042
                BB77BB77BB77000018631863186318631863186318631863FF7F00001042BB77
                BB77000000000000BB77BB77BB77BB77BB77BB7700001042BB77BB7700001042
                BB77BB77BB77000018631863186318631863186318631863FF7F00001042BB77
                BB77BB7700001042BB77BB77BB77BB77BB77BB7700001042BB77BB7700001042
                BB77BB77BB77000018631863186318631863186318631863FF7F00001042BB77
                BB77BB7700001042BB77BB77BB77BB77BB77BB7700001042BB77BB7700001042
                BB77BB77BB77000018631863186318631863186318631863FF7F00001042BB77
                BB77BB770000BB771042BB77BB77BB77BB77BB770000BB77BB77BB7700001042
                BB77BB77BB7700001863186318631863186318631863186318630000BB77BB77
                BB77BB77BB770000BB7710421042104210420000BB77BB77BB77BB7700001042
                BB77BB77BB77BB77000000000000000000000000000000000000BB77BB77BB77
                BB77BB77BB77BB7700000000000000000000BB77BB77BB77BB77BB7700001042
                BB77BB77BB77BB77BB77BB77BB770000104200001042BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB7700001042
                BB77BB77BB77BB77BB77BB77BB77000000000000BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB7700001042
                BB77BB77BB77BB77BB77BB77BB77BB7700001042BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB7700001042
                BB77BB77BB77BB77BB77BB77BB77BB770000BB77BB77BB77BB77BB77BB77BB77
                BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB77BB770000BB77
                BB77BB77BB77}
              Spacing = 5
              color_background_down = clBtnFace
              color_background_up = clBtnFace
              show_shortcut = False
            end
          end
          object btn_help_profiles: TFBitBtn
            Left = 513
            Top = 8
            Width = 31
            Height = 28
            Anchors = [akTop, akRight]
            TabOrder = 4
            OnClick = btn_help_profilesClick
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
        object panel_profiles_values: TFPanel
          Left = 1
          Top = 107
          Width = 564
          Height = 100
          Align = alClient
          Color = 8454143
          ParentBackground = False
          TabOrder = 1
          object txt_marg_sx: TLabel
            Left = 33
            Top = 10
            Width = 129
            Height = 16
            Alignment = taRightJustify
            Caption = 'margine sinistro cm'
            FocusControl = r_marg_sx
          end
          object txt_marg_up: TLabel
            Left = 229
            Top = 10
            Width = 142
            Height = 16
            Alignment = taRightJustify
            Caption = 'margine superiore cm'
            FocusControl = r_marg_up
          end
          object txt_printer: TLabel
            Left = 12
            Top = 40
            Width = 68
            Height = 16
            Caption = 'stampante'
            FocusControl = cb_printer
          end
          object txt_cassetto: TLabel
            Left = 316
            Top = 40
            Width = 55
            Height = 16
            Caption = 'cassetto'
            FocusControl = cb_cassetto
          end
          object txt_profile_message: TMyLabel
            Left = 1
            Top = 83
            Width = 562
            Height = 16
            Align = alBottom
            Alignment = taCenter
            Caption = 
              'lascia il campo STAMPANTE vuoto per usare la stampante principal' +
              'e'
            Color = 13302751
            FocusControl = str_profilo_workstation
            ParentColor = False
            Transparent = False
            ExplicitWidth = 445
          end
          object r_marg_sx: TEdit
            Left = 168
            Top = 6
            Width = 47
            Height = 24
            TabOrder = 0
          end
          object r_marg_up: TEdit
            Left = 375
            Top = 6
            Width = 47
            Height = 24
            TabOrder = 1
          end
          object cb_printer: TFCombo
            Left = 84
            Top = 36
            Width = 212
            Height = 24
            DropDownCount = 16
            TabOrder = 2
            OnExit = cb_printerExit
            AAA_dropdownwidth = 0
            AAA_NeedNotifyModification = False
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = True
          end
          object cb_cassetto: TFCombo
            Left = 375
            Top = 36
            Width = 152
            Height = 24
            DropDownCount = 16
            TabOrder = 3
            AAA_dropdownwidth = 250
            AAA_NeedNotifyModification = False
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = True
          end
        end
      end
    end
    object page_label: TTabSheet
      Caption = 'etichetta'
      ImageIndex = 6
      object txt_size_label_x: TLabel
        Left = 146
        Top = 49
        Width = 124
        Height = 16
        Alignment = taRightJustify
        Caption = 'larghezza etichetta'
        FocusControl = r_size_label_x
      end
      object txt_size_label_y: TLabel
        Left = 163
        Top = 76
        Width = 107
        Height = 16
        Alignment = taRightJustify
        Caption = 'altezza etichetta'
        FocusControl = r_size_label_y
      end
      object txt_lab_per_row: TLabel
        Left = 46
        Top = 177
        Width = 224
        Height = 16
        Caption = '&N'#176' etichette per pagina (larghezza)'
        FocusControl = i_lab_per_row
      end
      object txt_lab_per_page: TLabel
        Left = 63
        Top = 205
        Width = 207
        Height = 16
        Caption = 'N'#176' &etichette per pagina (altezza)'
        FocusControl = i_lab_per_page
      end
      object txt_delta_x: TLabel
        Left = 105
        Top = 112
        Width = 165
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        Caption = 's&pazio orizz. tra etichette'
        FocusControl = r_delta_x
      end
      object txt_delta_y: TLabel
        Left = 88
        Top = 139
        Width = 182
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'sp&azio vert. tra etichette'
        FocusControl = r_delta_y
      end
      object txt_misure_CM: TMyLabel
        Left = 0
        Top = 0
        Width = 566
        Height = 37
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = 'tutte le misure in CENTIMETRI'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        Layout = tlBottom
      end
      object txt_numero_stampe_etichetta: TLabel
        Left = 63
        Top = 242
        Width = 207
        Height = 16
        Alignment = taRightJustify
        Caption = 'quante volte stampo l'#39'etichetta?'
        FocusControl = i_numero_stampe_etichetta
      end
      object r_size_label_x: TEdit
        Left = 277
        Top = 45
        Width = 47
        Height = 24
        TabOrder = 0
      end
      object r_size_label_y: TEdit
        Left = 277
        Top = 73
        Width = 47
        Height = 24
        TabOrder = 1
      end
      object i_lab_per_row: TEdit
        Left = 277
        Top = 173
        Width = 47
        Height = 24
        TabOrder = 4
      end
      object i_lab_per_page: TEdit
        Left = 277
        Top = 201
        Width = 47
        Height = 24
        TabOrder = 5
      end
      object r_delta_x: TEdit
        Left = 277
        Top = 108
        Width = 47
        Height = 24
        TabOrder = 2
      end
      object r_delta_y: TEdit
        Left = 277
        Top = 135
        Width = 47
        Height = 24
        TabOrder = 3
      end
      object cbx_draw_lines_separazione_label: TFCheckBox
        Left = 69
        Top = 272
        Width = 379
        Height = 17
        Caption = 'linee separazione etichette (solo in anteprima a video)'
        TabOrder = 8
        AAA_NeedNotifyModification = False
      end
      object cb_numero_stampe_etichetta: TFCombo
        Left = 337
        Top = 238
        Width = 184
        Height = 24
        Style = csDropDownList
        DropDownCount = 16
        TabOrder = 7
        OnChange = cb_numero_stampe_etichettaChange
        AAA_dropdownwidth = 0
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
      object i_numero_stampe_etichetta: TFEdit
        Left = 276
        Top = 238
        Width = 49
        Height = 24
        TabOrder = 6
        OnChange = i_numero_stampe_etichettaChange
        AAA_tipodato = fe_integer
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
    end
    object page_export: TTabSheet
      Caption = 'export'
      ImageIndex = 5
      object txt_export_label: TMyLabel
        Left = 0
        Top = 0
        Width = 566
        Height = 24
        Align = alTop
        Alignment = taCenter
        Caption = 'esportazione della sezione'
        Color = clYellow
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        ShowAccelChar = False
        ShowHint = False
        Transparent = False
        ExplicitWidth = 268
      end
      object pc_export: TMyPageControl
        Left = 0
        Top = 24
        Width = 566
        Height = 285
        ActivePage = page_export_DBF
        Align = alClient
        OwnerDraw = True
        TabOrder = 0
        AAA_AutoHighLight = False
        AAA_OpenOnFirstPage = True
        object page_exportazione: TTabSheet
          Caption = 'exportazione integrale'
          object lb_expint_elenco: TMyListBox
            Left = 0
            Top = 0
            Width = 558
            Height = 69
            Align = alTop
            TabOrder = 0
            OnClick = lb_expint_elencoClick
            AAA_NeedNotifyModification = False
          end
          object page_export_opzioni: TFPageControl
            Left = 0
            Top = 69
            Width = 558
            Height = 185
            ActivePage = page_expint
            Align = alClient
            OwnerDraw = True
            TabOrder = 1
            AAA_AutoHighLight = False
            AAA_OpenOnFirstPage = False
            object page_expint: TTabSheet
              Caption = 'page_expint'
              object panel_expint_edit: TFPanel
                Left = 0
                Top = 0
                Width = 550
                Height = 154
                Align = alClient
                ParentBackground = False
                TabOrder = 0
                DesignSize = (
                  550
                  154)
                object txt_export_integrale: TLabel
                  Left = 10
                  Top = 12
                  Width = 129
                  Height = 16
                  Alignment = taRightJustify
                  Caption = 'esporta la sezione?'
                  FocusControl = cb_export_integrale
                end
                object txt_export_ID: TMyLabel
                  Left = 334
                  Top = 4
                  Width = 121
                  Height = 32
                  Alignment = taRightJustify
                  Anchors = [akTop, akRight]
                  Caption = 'sigla exportazione'#13#10'per la sezione'
                  FocusControl = str_export_sigla
                end
                object txt_export_shift_columns: TMyLabel
                  Left = 36
                  Top = 69
                  Width = 285
                  Height = 16
                  Caption = 'sposta output di           colonne verso destra'
                  FocusControl = i_expint_shift_columns
                end
                object txt_export_type_fields_default: TLabel
                  Left = 11
                  Top = 93
                  Width = 212
                  Height = 32
                  Alignment = taRightJustify
                  Caption = 'impostazione default per i campi'#13#10'non esplicitamente assegnati'
                  FocusControl = cb_export_type_fields_default
                end
                object txt_expint_descrizione: TMyLabel
                  Left = 38
                  Top = 44
                  Width = 205
                  Height = 16
                  Alignment = taRightJustify
                  Anchors = [akTop, akRight]
                  Caption = 'descrizione sezione (a runtime)'
                  FocusControl = str_expint_descrizione
                end
                object cb_export_integrale: TFCombo
                  Left = 144
                  Top = 8
                  Width = 167
                  Height = 24
                  Style = csDropDownList
                  Anchors = [akLeft, akTop, akRight]
                  DropDownCount = 16
                  TabOrder = 0
                  OnChange = generic_enable_ctrls
                  AAA_dropdownwidth = 240
                  AAA_NeedNotifyModification = False
                  AAA_CanBeVoid = False
                  AAA_CanBeInvalid = False
                end
                object str_export_sigla: TFEdit
                  Left = 460
                  Top = 8
                  Width = 86
                  Height = 24
                  Hint = 
                    'sigla che identifica le righe generate dalla sezione'#13#10'viene inse' +
                    'rito come primo campo del file esportato'
                  Anchors = [akTop, akRight]
                  MaxLength = 12
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 1
                  AAA_tipodato = fe_generico
                  AAA_NeedNotifyModification = False
                  AAA_CanBeVoid = True
                  AAA_CanBeInvalid = True
                end
                object i_expint_shift_columns: TFEdit
                  Left = 144
                  Top = 65
                  Width = 36
                  Height = 24
                  Hint = 
                    'consente di shiftare (spostare) l'#39'output di un certo numero di c' +
                    'olonne'#13#10' '#13#10'l'#39'opzione '#232' utile per distinguere l'#39'output di sezioni' +
                    ' differenti'
                  MaxLength = 3
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 3
                  AAA_tipodato = fe_integer
                  AAA_NeedNotifyModification = False
                  AAA_CanBeVoid = False
                  AAA_CanBeInvalid = False
                end
                object cb_export_type_fields_default: TFCombo
                  Left = 228
                  Top = 98
                  Width = 255
                  Height = 24
                  Style = csDropDownList
                  Anchors = [akLeft, akTop, akRight]
                  DropDownCount = 16
                  TabOrder = 4
                  AAA_dropdownwidth = 240
                  AAA_NeedNotifyModification = False
                  AAA_CanBeVoid = False
                  AAA_CanBeInvalid = False
                end
                object cbx_dont_export_continuazione: TFCheckBox
                  Left = 16
                  Top = 132
                  Width = 249
                  Height = 17
                  Hint = 'serve qualora un record risulti spaccato su pi'#249' di una pagina'
                  Caption = 'exporta una sola volta ogni record'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 5
                  OnClick = generic_enable_ctrls
                  AAA_NeedNotifyModification = False
                end
                object cbx_header_colonne: TFCheckBox
                  Left = 304
                  Top = 132
                  Width = 212
                  Height = 17
                  Caption = 'genera intestazione colonne'
                  TabOrder = 6
                  OnClick = generic_enable_ctrls
                  AAA_NeedNotifyModification = False
                end
                object str_expint_descrizione: TFEdit
                  Left = 247
                  Top = 40
                  Width = 300
                  Height = 24
                  Hint = 
                    'descrizione usata a RUNTIME durante l'#39'exportazione integrale per' +
                    ' riferirsi alla sezione'
                  Anchors = [akTop, akRight]
                  MaxLength = 100
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 2
                  AAA_tipodato = fe_generico
                  AAA_NeedNotifyModification = False
                  AAA_CanBeVoid = True
                  AAA_CanBeInvalid = True
                end
              end
            end
            object page_XML: TTabSheet
              Caption = 'page_XML'
              ImageIndex = 1
              object panel_XML_header: TFPanel
                Left = 0
                Top = 0
                Width = 550
                Height = 41
                Align = alTop
                BevelOuter = bvNone
                ParentBackground = False
                TabOrder = 0
                DesignSize = (
                  550
                  41)
                object txt_XML_text: TMyLabel
                  Left = 5
                  Top = 23
                  Width = 151
                  Height = 16
                  Anchors = [akLeft, akBottom]
                  Caption = 'testo XML da exportare'
                end
                object cbx_XML_export: TFCheckBox
                  Left = 3
                  Top = 4
                  Width = 354
                  Height = 17
                  Caption = 'comprende la sezione nell'#39'exportazione XML'
                  TabOrder = 0
                  OnClick = generic_enable_ctrls
                  AAA_NeedNotifyModification = False
                end
              end
              object str_XML_text: TFMemo
                Left = 0
                Top = 41
                Width = 550
                Height = 113
                Align = alClient
                ScrollBars = ssBoth
                TabOrder = 1
                AAA_NeedNotifyModification = False
                AAA_CanBeVoid = True
                AAA_CanBeInvalid = True
              end
            end
          end
        end
        object page_export_DBF: TTabSheet
          Caption = 'DBF (excel compatibile)'
          ImageIndex = 1
          object txt_export_filename: TLabel
            Left = 304
            Top = 8
            Width = 125
            Height = 16
            Caption = 'nome file esportato'
            FocusControl = str_export_filename_DBF
          end
          object txt_export: TLabel
            Left = 4
            Top = 51
            Width = 494
            Height = 16
            Caption = 
              'istruzione SQL per l'#39'esportazione dati (se blank, usa la query d' +
              'ella sezione)'
            FocusControl = SQL_export_DBF
          end
          object cbx_export_DBF: TFCheckBox
            Left = 20
            Top = 16
            Width = 260
            Height = 17
            Caption = 'sezione exportabile in formato DBF'
            TabOrder = 0
            OnClick = generic_enable_ctrls
            AAA_NeedNotifyModification = True
          end
          object str_export_filename_DBF: TEdit
            Left = 304
            Top = 23
            Width = 217
            Height = 24
            Hint = 
              'nome del file creato dalla procedura di esportazione'#13#10'sar'#224' esegu' +
              'ita la sostituzione delle variabili'
            MaxLength = 128
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
          end
          object SQL_export_DBF: TMemo
            Left = 0
            Top = 87
            Width = 558
            Height = 167
            Align = alBottom
            Anchors = [akLeft, akTop, akRight, akBottom]
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -16
            Font.Name = 'Times New Roman'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 2
            WordWrap = False
            OnKeyDown = str_SQL_selectKeyDown
          end
        end
      end
    end
    object page_colonne_colorate: TTabSheet
      Caption = 'colonne colorate'
      ImageIndex = 7
      object txt_header_colonne_colorate: TMyLabel
        Left = 0
        Top = 0
        Width = 566
        Height = 24
        Align = alTop
        Alignment = taCenter
        Caption = 'colonne colorate'
        Color = 14548957
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        ShowAccelChar = False
        ShowHint = False
        Transparent = False
        ExplicitWidth = 169
      end
      object footer_colonne_colorate: TFPanel
        Left = 0
        Top = 262
        Width = 566
        Height = 47
        Align = alBottom
        ParentBackground = False
        TabOrder = 0
        object btn_colcol_add: TFBitBtn
          Left = 59
          Top = 8
          Width = 120
          Height = 31
          Action = AL_colonna_colorata_add
          Caption = 'aggiungi'
          TabOrder = 0
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
        object btn_colcol_del: TFBitBtn
          Left = 191
          Top = 8
          Width = 81
          Height = 31
          Action = AL_colonna_colorate_delete
          Caption = 'elimina'
          TabOrder = 1
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
        object btn_riordina_colcol: TFBitBtn
          Left = 295
          Top = 8
          Width = 192
          Height = 31
          Action = AL_colonne_colorate_sort
          Caption = 'riordina per posizione'
          TabOrder = 2
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
      object grid_colonne_colorate: TStringGrid
        Left = 0
        Top = 24
        Width = 566
        Height = 238
        Align = alClient
        ColCount = 2
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 1
        OnDblClick = grid_colonne_colorateDblClick
        OnDrawCell = grid_colonne_colorateDrawCell
        ColWidths = (
          64
          63)
      end
    end
  end
  object font_dialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    Left = 513
    Top = 65533
  end
  object AL: TActionList
    Left = 396
    Top = 337
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
    object AL_colonna_colorata_add: TAction
      Caption = 'aggiungi'
      OnExecute = AL_colonna_colorata_addExecute
    end
    object AL_colonna_colorate_delete: TAction
      Caption = 'elimina'
      OnExecute = AL_colonna_colorate_deleteExecute
    end
    object AL_colonne_colorate_sort: TAction
      Caption = 'riordina per posizione'
      OnExecute = AL_colonne_colorate_sortExecute
    end
  end
  object find_dialog: TFindDialog
    Options = [frDown, frHideMatchCase, frHideWholeWord, frHideUpDown]
    OnFind = find_dialogFind
    Left = 446
    Top = 336
  end
end
