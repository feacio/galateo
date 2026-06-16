object dlg_datamatrix: Tdlg_datamatrix
  Left = 582
  Top = 182
  Caption = 'datamatrix'
  ClientHeight = 556
  ClientWidth = 487
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object panel_bottom: TFPanel
    Left = 0
    Top = 520
    Width = 487
    Height = 36
    Align = alBottom
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      487
      36)
    object txt_object: TLabel
      Left = 426
      Top = 10
      Width = 63
      Height = 16
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'txt_object'
    end
    object btn_legami: TFBitBtn
      Left = 249
      Top = 5
      Width = 133
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'Legami comunitari'
      Enabled = False
      TabOrder = 2
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = False
    end
    object btn_ok: TFBitBtn
      Left = 11
      Top = 6
      Width = 78
      Height = 25
      Action = AL_save
      Caption = 'F9 OK'
      Default = True
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
      Left = 390
      Top = 6
      Width = 29
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 3
      Visible = False
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
  object panel_base: TFPanel
    Left = 0
    Top = 0
    Width = 487
    Height = 520
    Align = alClient
    ParentBackground = False
    TabOrder = 0
    object panel_header: TFPanel
      Left = 1
      Top = 1
      Width = 485
      Height = 170
      Align = alClient
      ParentBackground = False
      TabOrder = 0
      DesignSize = (
        485
        170)
      object txt_nome: TMyLabel
        Left = 28
        Top = 12
        Width = 36
        Height = 16
        Caption = 'nome'
        FocusControl = str_nome
      end
      object txt_valore: TMyLabel
        Left = 23
        Top = 44
        Width = 53
        Height = 16
        Caption = 'valore ()'
        FocusControl = str_valore
      end
      object txt_tipo_variabile: TMyLabel
        Left = 257
        Top = 12
        Width = 24
        Height = 16
        Caption = 'tipo'
        FocusControl = cb_tipo_variabile
      end
      object txt_valore_text_only: TMyLabel
        Left = 408
        Top = 44
        Width = 64
        Height = 16
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        Caption = 'solo testo'
        FocusControl = str_valore
      end
      object str_nome: TFEdit
        Left = 68
        Top = 8
        Width = 175
        Height = 24
        CharCase = ecUpperCase
        TabOrder = 0
        AAA_tipodato = fe_generico
        AAA_notify_modification = AAA_notify_modification
        AAA_NeedNotifyModification = True
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
      object str_valore: TFMemo
        Left = 20
        Top = 61
        Width = 456
        Height = 105
        Anchors = [akLeft, akTop, akRight, akBottom]
        ScrollBars = ssVertical
        TabOrder = 2
        AAA_notify_modification = AAA_notify_modification
        AAA_NeedNotifyModification = True
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
      object cb_tipo_variabile: TFCombo
        Left = 285
        Top = 8
        Width = 151
        Height = 24
        Style = csDropDownList
        DropDownCount = 16
        TabOrder = 1
        OnChange = cb_tipo_variabileChange
        Items.Strings = (
          'ASCII (ASCII 0-127)'
          'C40 (numeri e maiuscole)'
          'TEXT (numeri e minuscole)'
          'BASE256 (dati binari)')
        AAA_dropdownwidth = 0
        AAA_notify_modification = AAA_notify_modification
        AAA_NeedNotifyModification = True
        AAA_CanBeVoid = False
        AAA_CanBeInvalid = False
      end
    end
    object panel_formattazione: TFPanel
      Left = 1
      Top = 171
      Width = 485
      Height = 348
      Align = alBottom
      ParentBackground = False
      TabOrder = 1
      DesignSize = (
        485
        348)
      object gbox_opzioni: TFGroupBox
        Left = 20
        Top = 4
        Width = 457
        Height = 67
        Caption = 'opzioni di formattazione'
        TabOrder = 0
        DesignSize = (
          457
          67)
        object txt_encoding_mode: TMyLabel
          Left = 12
          Top = 20
          Width = 126
          Height = 16
          Caption = 'modalit'#224' di codifica'
          FocusControl = cb_encoding_mode
        end
        object txt_orientamento: TMyLabel
          Left = 186
          Top = 20
          Width = 61
          Height = 16
          Caption = 'direzione'
          FocusControl = cb_orientamento
        end
        object txt_preferred_format: TMyLabel
          Left = 275
          Top = 20
          Width = 49
          Height = 16
          Caption = 'formato'
          FocusControl = cb_preferred_format
        end
        object cb_encoding_mode: TFCombo
          Left = 9
          Top = 36
          Width = 172
          Height = 24
          Style = csDropDownList
          DropDownCount = 16
          TabOrder = 0
          Items.Strings = (
            'ASCII (ASCII 0-127)'
            'C40 (numeri e maiuscole)'
            'TEXT (numeri e minuscole)'
            'BASE256 (dati binari)')
          AAA_dropdownwidth = 240
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = True
          AAA_CanBeVoid = False
          AAA_CanBeInvalid = False
        end
        object cb_orientamento: TFCombo
          Left = 185
          Top = 36
          Width = 80
          Height = 24
          Style = csDropDownList
          DropDownCount = 16
          TabOrder = 1
          Items.Strings = (
            'normale'
            '90 gradi'
            '180 gradi'
            '270 gradi')
          AAA_dropdownwidth = 0
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = True
          AAA_CanBeVoid = False
          AAA_CanBeInvalid = False
        end
        object cb_preferred_format: TFCombo
          Left = 270
          Top = 36
          Width = 95
          Height = 24
          Hint = 'rappresenta il numero di elementi (quadrati) del barcode'
          Style = csDropDownList
          DropDownCount = 16
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          Items.Strings = (
            'automatico'
            '10 x 10'
            '12 x 12'
            '14 x 14'
            '16 x 16'
            '18 x 18'
            '20 x 20'
            '22 x 22'
            '24 x 24'
            '26 x 26'
            '32 x 32'
            '36 x 36'
            '40 x 40'
            '44 x 44'
            '48 x 48'
            '52 x 52'
            '64 x 64'
            '72 x 72'
            '80 x 80'
            '88 x 88'
            '96 x 96'
            '104 x 104'
            '120 x 120'
            '132 x 132'
            '144 x 144'
            '8 x 18'
            '8 x 32'
            '12 x 26'
            '12 x 36'
            '16 x 36'
            '16 x 48')
          AAA_dropdownwidth = 0
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = True
          AAA_CanBeVoid = False
          AAA_CanBeInvalid = False
        end
        object btn_help_size: TFBitBtn
          Left = 382
          Top = 35
          Width = 65
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'size'
          TabOrder = 3
          OnClick = btn_help_sizeClick
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
      object gbox_font: TFGroupBox
        Left = 20
        Top = 76
        Width = 457
        Height = 49
        Caption = 'opzioni font'
        TabOrder = 1
        object txt_backcolor: TMyLabel
          Left = 230
          Top = 21
          Width = 88
          Height = 16
          Caption = 'colore sfondo'
          FocusControl = cb_backcolor
        end
        object txt_forecolor: TMyLabel
          Left = 11
          Top = 21
          Width = 76
          Height = 16
          Caption = 'colore testo'
          FocusControl = cb_forecolor
        end
        object cb_backcolor: TColorBox
          Left = 322
          Top = 18
          Width = 125
          Height = 22
          DropDownCount = 16
          TabOrder = 1
          OnChange = AAA_notify_modification
        end
        object cb_forecolor: TColorBox
          Left = 92
          Top = 18
          Width = 125
          Height = 22
          DropDownCount = 16
          TabOrder = 0
          OnChange = AAA_notify_modification
        end
      end
      object gbox_opzioni_generali: TFGroupBox
        Left = 20
        Top = 183
        Width = 457
        Height = 155
        Anchors = [akLeft, akTop, akRight]
        Caption = 'opzioni generali'
        TabOrder = 3
        DesignSize = (
          457
          155)
        object txt_show: TLabel
          Left = 23
          Top = 19
          Width = 124
          Height = 16
          Caption = 'F6 visualizzazione'
          FocusControl = cb_show
        end
        object txt_print_if: TLabel
          Left = 32
          Top = 45
          Width = 112
          Height = 16
          Caption = 'F11 stampa se ...'
          FocusControl = str_print_if
        end
        object txt_hints: TLabel
          Left = 28
          Top = 70
          Width = 26
          Height = 16
          Caption = 'Hint'
          FocusControl = str_hints
        end
        object txt_esempio: TLabel
          Left = 8
          Top = 128
          Width = 117
          Height = 16
          Caption = 'valore di esempio'
          FocusControl = str_esempio
        end
        object cb_show: TFCombo
          Left = 151
          Top = 14
          Width = 292
          Height = 24
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 16
          TabOrder = 0
          AAA_dropdownwidth = 400
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = False
          AAA_CanBeInvalid = False
        end
        object str_print_if: TEdit
          Left = 151
          Top = 41
          Width = 292
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
          OnChange = AAA_notify_modification
        end
        object str_hints: TEdit
          Left = 60
          Top = 66
          Width = 383
          Height = 23
          Anchors = [akLeft, akTop, akRight]
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnChange = AAA_notify_modification
        end
        object cbx_posizione_fissa: TCheckBox
          Left = 63
          Top = 89
          Width = 276
          Height = 17
          Hint = 
            'La posizione dell'#39'oggetto non viene influenzata dagli oggetti so' +
            'prastanti'
          Caption = 'posizione fissa nella pagina/sezione'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = AAA_notify_modification
        end
        object cbx_footer: TCheckBox
          Left = 63
          Top = 106
          Width = 328
          Height = 17
          Hint = 
            'La posizione dell'#39'oggetto in fase di disegno rimane legata al fo' +
            'ndo della pagina'#13#10'Serve per facilitare la sistemazione di report' +
            's su stampanti con lunghezza di pagina differente.'#13#10'Questa opzio' +
            'ne non influenza la posizione dell'#39'oggetto a runtime.'
          Caption = 'posizione legata al fondo pagina (design-time)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = AAA_notify_modification
        end
        object str_esempio: TEdit
          Left = 127
          Top = 124
          Width = 316
          Height = 23
          Anchors = [akLeft, akTop, akRight]
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
          OnChange = AAA_notify_modification
        end
      end
      object gbox_size: TFGroupBox
        Left = 20
        Top = 128
        Width = 457
        Height = 49
        Caption = 'dimensione e posizione (CM)'
        TabOrder = 2
        object txt_left: TLabel
          Left = 8
          Top = 21
          Width = 33
          Height = 16
          Caption = 'orizz'
          FocusControl = i_left_cm
        end
        object txt_top: TLabel
          Left = 100
          Top = 21
          Width = 25
          Height = 16
          Caption = 'vert'
          FocusControl = i_top_cm
        end
        object txt_size_Y: TLabel
          Left = 278
          Top = 21
          Width = 16
          Height = 16
          Caption = 'dy'
          FocusControl = fl_size_Y
        end
        object txt_size_X: TLabel
          Left = 196
          Top = 21
          Width = 16
          Height = 16
          Caption = 'dx'
          FocusControl = fl_size_X
        end
        object i_left_cm: TFEdit
          Left = 44
          Top = 17
          Width = 48
          Height = 24
          AutoSize = False
          TabOrder = 0
          AAA_tipodato = fe_generico
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object i_top_cm: TFEdit
          Left = 128
          Top = 17
          Width = 51
          Height = 24
          AutoSize = False
          TabOrder = 1
          AAA_tipodato = fe_generico
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object fl_size_Y: TFEdit
          Left = 300
          Top = 17
          Width = 51
          Height = 24
          Hint = 
            'rappresenta la dimensione del barcode'#13#10' '#13#10'se AUTOSIZE, il valore' +
            ' viene utilizzato esclusivamente'#13#10'per la rappresentazione dell'#39'o' +
            'ggetto in fase di editing'
          AutoSize = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          AAA_tipodato = fe_float
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object cbx_autosize: TFCheckBox
          Left = 363
          Top = 21
          Width = 78
          Height = 17
          Hint = 'ridimensiona automaticamente il barcode'
          Caption = 'autosize'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = True
        end
        object fl_size_X: TFEdit
          Left = 216
          Top = 17
          Width = 51
          Height = 24
          Hint = 
            'rappresenta la dimensione del barcode'#13#10' '#13#10'se AUTOSIZE, il valore' +
            ' viene utilizzato esclusivamente'#13#10'per la rappresentazione dell'#39'o' +
            'ggetto in fase di editing'
          AutoSize = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnEnter = fl_size_XEnter
          OnExit = fl_size_XExit
          AAA_tipodato = fe_float
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
      end
    end
  end
  object AL: TActionList
    Left = 380
    Top = 8
    object AL_save: TAction
      Caption = 'F9 OK'
      ShortCut = 120
      OnExecute = AL_saveExecute
    end
    object AL_F6_visualizzazione: TAction
      Caption = 'visualizzazione'
      ShortCut = 117
      OnExecute = AL_F6_visualizzazioneExecute
    end
    object AL_F11_stampa_if: TAction
      Caption = 'AL_F11_stampa_if'
      OnExecute = AL_F11_stampa_ifExecute
    end
  end
end
