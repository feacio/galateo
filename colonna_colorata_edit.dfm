object dlg_colonna_colorata_edit: Tdlg_colonna_colorata_edit
  Left = 0
  Top = 0
  Caption = 'dlg_colonna_colorata_edit'
  ClientHeight = 506
  ClientWidth = 637
  Color = clBtnFace
  Constraints.MinWidth = 600
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = [fsBold]
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object panel: TFPanel
    Left = 0
    Top = 0
    Width = 637
    Height = 459
    Align = alClient
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      637
      459)
    object txt_descrizione: TMyLabel
      Left = 22
      Top = 9
      Width = 76
      Height = 32
      Alignment = taRightJustify
      Caption = 'descrizione'#13#10'colonna'
      FocusControl = str_descrizione
    end
    object txt_colore_base: TMyLabel
      Left = 343
      Top = 9
      Width = 40
      Height = 32
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'colore'#13#10'base'
    end
    object txt_condizione_abilitazione: TMyLabel
      Left = 187
      Top = 51
      Width = 163
      Height = 16
      Alignment = taRightJustify
      Caption = 'condizioni di abilitazione'
      FocusControl = str_condizione_abilitazione
    end
    object str_descrizione: TFEdit
      Left = 104
      Top = 13
      Width = 223
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      CharCase = ecUpperCase
      TabOrder = 0
      OnChange = AAA_notify_modification
      AAA_tipodato = fe_generico
      AAA_notify_modification = AAA_notify_modification
      AAA_NeedNotifyModification = True
      AAA_CanBeVoid = True
      AAA_CanBeInvalid = True
    end
    object rb_tipo_limite: TFRadioGroup
      Left = 28
      Top = 78
      Width = 245
      Height = 134
      Caption = 'modalit'#224' determinazione larghezza'
      TabOrder = 5
      OnClick = generic_enable_ctrls
      AAA_notify_modification = AAA_notify_modification
      AAA_NeedNotifyModification = True
    end
    object gbox_limiti: TFGroupBox
      Left = 298
      Top = 85
      Width = 327
      Height = 127
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 6
      DesignSize = (
        327
        127)
      object txt_limite_sx: TMyLabel
        Left = 10
        Top = 11
        Width = 87
        Height = 16
        Caption = 'limite sx (cm)'
        FocusControl = str_limite_sx
      end
      object txt_limite_dx: TMyLabel
        Left = 10
        Top = 39
        Width = 87
        Height = 16
        Caption = 'limite dx (cm)'
        FocusControl = str_limite_dx
      end
      object txt_object: TMyLabel
        Left = 10
        Top = 70
        Width = 87
        Height = 16
        Caption = 'come oggetto'
        FocusControl = cb_object
      end
      object txt_linea_sx: TMyLabel
        Left = 13
        Top = 100
        Width = 52
        Height = 16
        Caption = 'linea sx'
        FocusControl = cb_linea_sx
      end
      object txt_linea_dx: TMyLabel
        Left = 181
        Top = 100
        Width = 16
        Height = 16
        Caption = 'dx'
        FocusControl = cb_linea_dx
      end
      object str_limite_sx: TFEdit
        Left = 103
        Top = 7
        Width = 214
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnChange = AAA_notify_modification
        AAA_tipodato = fe_float
        AAA_notify_modification = AAA_notify_modification
        AAA_NeedNotifyModification = True
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
      object str_limite_dx: TFEdit
        Left = 103
        Top = 35
        Width = 214
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        OnChange = AAA_notify_modification
        AAA_tipodato = fe_float
        AAA_notify_modification = AAA_notify_modification
        AAA_NeedNotifyModification = True
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
      object cb_object: TFCombo
        Left = 103
        Top = 66
        Width = 214
        Height = 24
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        DropDownCount = 16
        TabOrder = 2
        AAA_dropdownwidth = 400
        AAA_notify_modification = AAA_notify_modification
        AAA_NeedNotifyModification = True
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = False
      end
      object cb_linea_sx: TFCombo
        Left = 71
        Top = 96
        Width = 101
        Height = 24
        Style = csDropDownList
        DropDownCount = 16
        TabOrder = 3
        AAA_dropdownwidth = 400
        AAA_notify_modification = AAA_notify_modification
        AAA_NeedNotifyModification = True
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = False
      end
      object cb_linea_dx: TFCombo
        Left = 200
        Top = 96
        Width = 117
        Height = 24
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        DropDownCount = 16
        TabOrder = 4
        AAA_dropdownwidth = 400
        AAA_notify_modification = AAA_notify_modification
        AAA_NeedNotifyModification = True
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = False
      end
    end
    object panel_colore_base: TFPanel
      Tag = -1
      Left = 389
      Top = 13
      Width = 81
      Height = 24
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      ParentBackground = False
      TabOrder = 1
      OnClick = panel_colore_Click
    end
    object cb_colore_base_symbolico: TFCombo
      Tag = -1
      Left = 485
      Top = 13
      Width = 114
      Height = 24
      Style = csDropDownList
      Anchors = [akTop, akRight]
      DropDownCount = 16
      TabOrder = 2
      OnChange = cb_colore_symbolico_Click
      AAA_dropdownwidth = 250
      AAA_notify_modification = AAA_notify_modification
      AAA_NeedNotifyModification = True
      AAA_CanBeVoid = True
      AAA_CanBeInvalid = False
    end
    object pc_colori: TFPageControl
      Left = 1
      Top = 247
      Width = 635
      Height = 211
      ActivePage = page_colore_condizionale
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      OwnerDraw = True
      TabOrder = 9
      AAA_AutoHighLight = False
      AAA_OpenOnFirstPage = False
      object page_colore_condizionale: TTabSheet
        Caption = 'colori condizionali'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        DesignSize = (
          627
          180)
        object txt_condizione: TMyLabel
          Left = 320
          Top = 8
          Width = 71
          Height = 16
          Caption = 'condizione'
        end
        object txt_colore: TMyLabel
          Left = 56
          Top = 8
          Width = 40
          Height = 16
          Caption = 'colore'
        end
        object txt_color_00: TMyLabel
          Left = 11
          Top = 29
          Width = 16
          Height = 16
          Caption = '#1'
        end
        object txt_color_01: TMyLabel
          Left = 11
          Top = 59
          Width = 16
          Height = 16
          Caption = '#2'
        end
        object txt_color_02: TMyLabel
          Left = 11
          Top = 90
          Width = 16
          Height = 16
          Caption = '#3'
        end
        object txt_color_03: TMyLabel
          Left = 11
          Top = 120
          Width = 16
          Height = 16
          Caption = '#4'
        end
        object txt_colore_symbolico: TMyLabel
          Left = 124
          Top = 8
          Width = 111
          Height = 16
          Caption = 'colore symbolico'
        end
        object str_condizione_00: TFEdit
          Left = 242
          Top = 25
          Width = 336
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          OnChange = AAA_notify_modification
          AAA_tipodato = fe_generico
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = True
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object panel_colore_00: TFPanel
          Left = 34
          Top = 25
          Width = 81
          Height = 24
          Cursor = crHandPoint
          ParentBackground = False
          TabOrder = 0
          OnClick = panel_colore_Click
        end
        object btn_blank_00: TFBitBtn
          Left = 582
          Top = 25
          Width = 37
          Height = 24
          Anchors = [akTop, akRight]
          TabOrder = 3
          OnClick = btn_blank_Click
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000000000000000
            0000000000000000000200000007000000070000000400000007000000070000
            0004000000070000000700000002000000000000000000000000000000000000
            000000000000352A288A614D4AFF6B5955FF7A6865FF786865FF756460FF705D
            5AFF604D49FF5B4743FF33272687000000000000000000000000000000000000
            0000000000005C4843EAAE9E95FFB5A69EFF9C887DFFBEB1AAFFBAACA5FF957F
            74FFB2A39AFFA99990FF574540E3000000000000000000000000000000000000
            00000000000068524CFFD9CBC3FFD1C6BFFF9E8B81FFDFD3CDFFD5CAC3FF9682
            77FFD9CBC3FFCCC0B8FF67514BFF000000000000000000000000000000000000
            0000000000006A5550FFD9CBC3FFD1C6BFFFA18E83FFDFD3CDFFD4CAC3FF9A86
            7BFFD9CBC3FFCCC0B8FF69544FFF000000000000000000000000000000000000
            0000000000006E5953FFD9CBC3FFD1C6BEFFA49188FFDED3CCFFD4C9C3FF9D89
            7FFFD9CBC3FFCCC0B8FF6D5852FF000000000000000000000000000000000000
            000000000000725C56FFD8CBC3FFD1C5BEFFA6958BFFDED3CCFFD4C9C2FFA08D
            83FFD8CBC3FFCCC0B8FF715B55FF000000000000000000000000000000010000
            000100000003755F58FFD5C7BFFFCDC1BBFFA6968DFFDACFC8FFD0C5BFFFA190
            86FFD5C7BFFFC8BCB5FF745E57FF000000030000000100000001000000010000
            00030101010874605AFFCDC0B9FFC5BAB3FFA6958DFFD3C8C1FFC8BEB8FFA08F
            85FFCCBFB7FFC0B5AEFF735F59FF010101090101010400000001000000010101
            01060202020E76625BFFC1B6AFFFBAAFA9FFA3948DFFC6BBB5FFBDB3ADFF9E8F
            87FFC0B4ADFFB6ABA4FF76625BFF0202020F0101010600000002000000010101
            010669514BFF6A524CFF6B534DFF6E5751FF725B56FF735D57FF725B56FF6E57
            51FF6B534DFF6A524CFF69514BFF69514BFF0101010600000002000000010000
            00036B544DFFAB9588FFB29D91FFBFAEA4FFCEC0B9FFD3C8C1FFCEC0B9FFBFAE
            A4FFB29D91FFAB9588FFAA9386FF6B544DFF0000000300000001000000000000
            000141332E97907E78FFB0A39FFFC5BBB8FFD2CAC8FFD6D0CDFFD2CAC8FFC7BE
            BBFFBAAFABFFAA9D98FF8D7A73FF40322E950000000100000000000000000000
            00000000000055433EC46F5852FF8D7971FF8E7A72FF715B55FF715A54FF8D79
            71FF8C7870FF6E5751FF55433EC4000000000000000000000000000000000000
            0000000000000000000001010101725B55FF453836900C0C0C0C0B0B0B0B4236
            348C725B55FF0000000000000000000000000000000000000000000000000000
            00000000000000000000010101015A4844C4887570FF8F7D78FF8E7D78FF8976
            71FF594743C40000000000000000000000000000000000000000}
          color_background_down = clBtnFace
          color_background_up = clBtnFace
          show_shortcut = False
        end
        object panel_colore_01: TFPanel
          Tag = 1
          Left = 34
          Top = 55
          Width = 81
          Height = 24
          Cursor = crHandPoint
          ParentBackground = False
          TabOrder = 4
          OnClick = panel_colore_Click
        end
        object str_condizione_01: TFEdit
          Tag = 1
          Left = 242
          Top = 55
          Width = 336
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 6
          OnChange = AAA_notify_modification
          AAA_tipodato = fe_generico
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = True
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object btn_blank_01: TFBitBtn
          Tag = 1
          Left = 582
          Top = 55
          Width = 37
          Height = 24
          Anchors = [akTop, akRight]
          TabOrder = 7
          OnClick = btn_blank_Click
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000000000000000
            0000000000000000000200000007000000070000000400000007000000070000
            0004000000070000000700000002000000000000000000000000000000000000
            000000000000352A288A614D4AFF6B5955FF7A6865FF786865FF756460FF705D
            5AFF604D49FF5B4743FF33272687000000000000000000000000000000000000
            0000000000005C4843EAAE9E95FFB5A69EFF9C887DFFBEB1AAFFBAACA5FF957F
            74FFB2A39AFFA99990FF574540E3000000000000000000000000000000000000
            00000000000068524CFFD9CBC3FFD1C6BFFF9E8B81FFDFD3CDFFD5CAC3FF9682
            77FFD9CBC3FFCCC0B8FF67514BFF000000000000000000000000000000000000
            0000000000006A5550FFD9CBC3FFD1C6BFFFA18E83FFDFD3CDFFD4CAC3FF9A86
            7BFFD9CBC3FFCCC0B8FF69544FFF000000000000000000000000000000000000
            0000000000006E5953FFD9CBC3FFD1C6BEFFA49188FFDED3CCFFD4C9C3FF9D89
            7FFFD9CBC3FFCCC0B8FF6D5852FF000000000000000000000000000000000000
            000000000000725C56FFD8CBC3FFD1C5BEFFA6958BFFDED3CCFFD4C9C2FFA08D
            83FFD8CBC3FFCCC0B8FF715B55FF000000000000000000000000000000010000
            000100000003755F58FFD5C7BFFFCDC1BBFFA6968DFFDACFC8FFD0C5BFFFA190
            86FFD5C7BFFFC8BCB5FF745E57FF000000030000000100000001000000010000
            00030101010874605AFFCDC0B9FFC5BAB3FFA6958DFFD3C8C1FFC8BEB8FFA08F
            85FFCCBFB7FFC0B5AEFF735F59FF010101090101010400000001000000010101
            01060202020E76625BFFC1B6AFFFBAAFA9FFA3948DFFC6BBB5FFBDB3ADFF9E8F
            87FFC0B4ADFFB6ABA4FF76625BFF0202020F0101010600000002000000010101
            010669514BFF6A524CFF6B534DFF6E5751FF725B56FF735D57FF725B56FF6E57
            51FF6B534DFF6A524CFF69514BFF69514BFF0101010600000002000000010000
            00036B544DFFAB9588FFB29D91FFBFAEA4FFCEC0B9FFD3C8C1FFCEC0B9FFBFAE
            A4FFB29D91FFAB9588FFAA9386FF6B544DFF0000000300000001000000000000
            000141332E97907E78FFB0A39FFFC5BBB8FFD2CAC8FFD6D0CDFFD2CAC8FFC7BE
            BBFFBAAFABFFAA9D98FF8D7A73FF40322E950000000100000000000000000000
            00000000000055433EC46F5852FF8D7971FF8E7A72FF715B55FF715A54FF8D79
            71FF8C7870FF6E5751FF55433EC4000000000000000000000000000000000000
            0000000000000000000001010101725B55FF453836900C0C0C0C0B0B0B0B4236
            348C725B55FF0000000000000000000000000000000000000000000000000000
            00000000000000000000010101015A4844C4887570FF8F7D78FF8E7D78FF8976
            71FF594743C40000000000000000000000000000000000000000}
          color_background_down = clBtnFace
          color_background_up = clBtnFace
          show_shortcut = False
        end
        object str_condizione_02: TFEdit
          Tag = 2
          Left = 242
          Top = 86
          Width = 336
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 10
          OnChange = AAA_notify_modification
          AAA_tipodato = fe_generico
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = True
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object panel_colore_02: TFPanel
          Tag = 2
          Left = 34
          Top = 86
          Width = 81
          Height = 24
          Cursor = crHandPoint
          ParentBackground = False
          TabOrder = 8
          OnClick = panel_colore_Click
        end
        object btn_blank_02: TFBitBtn
          Tag = 2
          Left = 582
          Top = 86
          Width = 37
          Height = 24
          Anchors = [akTop, akRight]
          TabOrder = 11
          OnClick = btn_blank_Click
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000000000000000
            0000000000000000000200000007000000070000000400000007000000070000
            0004000000070000000700000002000000000000000000000000000000000000
            000000000000352A288A614D4AFF6B5955FF7A6865FF786865FF756460FF705D
            5AFF604D49FF5B4743FF33272687000000000000000000000000000000000000
            0000000000005C4843EAAE9E95FFB5A69EFF9C887DFFBEB1AAFFBAACA5FF957F
            74FFB2A39AFFA99990FF574540E3000000000000000000000000000000000000
            00000000000068524CFFD9CBC3FFD1C6BFFF9E8B81FFDFD3CDFFD5CAC3FF9682
            77FFD9CBC3FFCCC0B8FF67514BFF000000000000000000000000000000000000
            0000000000006A5550FFD9CBC3FFD1C6BFFFA18E83FFDFD3CDFFD4CAC3FF9A86
            7BFFD9CBC3FFCCC0B8FF69544FFF000000000000000000000000000000000000
            0000000000006E5953FFD9CBC3FFD1C6BEFFA49188FFDED3CCFFD4C9C3FF9D89
            7FFFD9CBC3FFCCC0B8FF6D5852FF000000000000000000000000000000000000
            000000000000725C56FFD8CBC3FFD1C5BEFFA6958BFFDED3CCFFD4C9C2FFA08D
            83FFD8CBC3FFCCC0B8FF715B55FF000000000000000000000000000000010000
            000100000003755F58FFD5C7BFFFCDC1BBFFA6968DFFDACFC8FFD0C5BFFFA190
            86FFD5C7BFFFC8BCB5FF745E57FF000000030000000100000001000000010000
            00030101010874605AFFCDC0B9FFC5BAB3FFA6958DFFD3C8C1FFC8BEB8FFA08F
            85FFCCBFB7FFC0B5AEFF735F59FF010101090101010400000001000000010101
            01060202020E76625BFFC1B6AFFFBAAFA9FFA3948DFFC6BBB5FFBDB3ADFF9E8F
            87FFC0B4ADFFB6ABA4FF76625BFF0202020F0101010600000002000000010101
            010669514BFF6A524CFF6B534DFF6E5751FF725B56FF735D57FF725B56FF6E57
            51FF6B534DFF6A524CFF69514BFF69514BFF0101010600000002000000010000
            00036B544DFFAB9588FFB29D91FFBFAEA4FFCEC0B9FFD3C8C1FFCEC0B9FFBFAE
            A4FFB29D91FFAB9588FFAA9386FF6B544DFF0000000300000001000000000000
            000141332E97907E78FFB0A39FFFC5BBB8FFD2CAC8FFD6D0CDFFD2CAC8FFC7BE
            BBFFBAAFABFFAA9D98FF8D7A73FF40322E950000000100000000000000000000
            00000000000055433EC46F5852FF8D7971FF8E7A72FF715B55FF715A54FF8D79
            71FF8C7870FF6E5751FF55433EC4000000000000000000000000000000000000
            0000000000000000000001010101725B55FF453836900C0C0C0C0B0B0B0B4236
            348C725B55FF0000000000000000000000000000000000000000000000000000
            00000000000000000000010101015A4844C4887570FF8F7D78FF8E7D78FF8976
            71FF594743C40000000000000000000000000000000000000000}
          color_background_down = clBtnFace
          color_background_up = clBtnFace
          show_shortcut = False
        end
        object panel_colore_03: TFPanel
          Tag = 3
          Left = 34
          Top = 116
          Width = 81
          Height = 24
          Cursor = crHandPoint
          ParentBackground = False
          TabOrder = 12
          OnClick = panel_colore_Click
        end
        object str_condizione_03: TFEdit
          Tag = 3
          Left = 242
          Top = 116
          Width = 336
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 14
          OnChange = AAA_notify_modification
          AAA_tipodato = fe_generico
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = True
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
        object btn_blank_03: TFBitBtn
          Tag = 3
          Left = 582
          Top = 116
          Width = 37
          Height = 24
          Anchors = [akTop, akRight]
          TabOrder = 15
          OnClick = btn_blank_Click
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000000000000000
            0000000000000000000200000007000000070000000400000007000000070000
            0004000000070000000700000002000000000000000000000000000000000000
            000000000000352A288A614D4AFF6B5955FF7A6865FF786865FF756460FF705D
            5AFF604D49FF5B4743FF33272687000000000000000000000000000000000000
            0000000000005C4843EAAE9E95FFB5A69EFF9C887DFFBEB1AAFFBAACA5FF957F
            74FFB2A39AFFA99990FF574540E3000000000000000000000000000000000000
            00000000000068524CFFD9CBC3FFD1C6BFFF9E8B81FFDFD3CDFFD5CAC3FF9682
            77FFD9CBC3FFCCC0B8FF67514BFF000000000000000000000000000000000000
            0000000000006A5550FFD9CBC3FFD1C6BFFFA18E83FFDFD3CDFFD4CAC3FF9A86
            7BFFD9CBC3FFCCC0B8FF69544FFF000000000000000000000000000000000000
            0000000000006E5953FFD9CBC3FFD1C6BEFFA49188FFDED3CCFFD4C9C3FF9D89
            7FFFD9CBC3FFCCC0B8FF6D5852FF000000000000000000000000000000000000
            000000000000725C56FFD8CBC3FFD1C5BEFFA6958BFFDED3CCFFD4C9C2FFA08D
            83FFD8CBC3FFCCC0B8FF715B55FF000000000000000000000000000000010000
            000100000003755F58FFD5C7BFFFCDC1BBFFA6968DFFDACFC8FFD0C5BFFFA190
            86FFD5C7BFFFC8BCB5FF745E57FF000000030000000100000001000000010000
            00030101010874605AFFCDC0B9FFC5BAB3FFA6958DFFD3C8C1FFC8BEB8FFA08F
            85FFCCBFB7FFC0B5AEFF735F59FF010101090101010400000001000000010101
            01060202020E76625BFFC1B6AFFFBAAFA9FFA3948DFFC6BBB5FFBDB3ADFF9E8F
            87FFC0B4ADFFB6ABA4FF76625BFF0202020F0101010600000002000000010101
            010669514BFF6A524CFF6B534DFF6E5751FF725B56FF735D57FF725B56FF6E57
            51FF6B534DFF6A524CFF69514BFF69514BFF0101010600000002000000010000
            00036B544DFFAB9588FFB29D91FFBFAEA4FFCEC0B9FFD3C8C1FFCEC0B9FFBFAE
            A4FFB29D91FFAB9588FFAA9386FF6B544DFF0000000300000001000000000000
            000141332E97907E78FFB0A39FFFC5BBB8FFD2CAC8FFD6D0CDFFD2CAC8FFC7BE
            BBFFBAAFABFFAA9D98FF8D7A73FF40322E950000000100000000000000000000
            00000000000055433EC46F5852FF8D7971FF8E7A72FF715B55FF715A54FF8D79
            71FF8C7870FF6E5751FF55433EC4000000000000000000000000000000000000
            0000000000000000000001010101725B55FF453836900C0C0C0C0B0B0B0B4236
            348C725B55FF0000000000000000000000000000000000000000000000000000
            00000000000000000000010101015A4844C4887570FF8F7D78FF8E7D78FF8976
            71FF594743C40000000000000000000000000000000000000000}
          color_background_down = clBtnFace
          color_background_up = clBtnFace
          show_shortcut = False
        end
        object cb_colore_symbolico_00: TFCombo
          Left = 123
          Top = 25
          Width = 112
          Height = 24
          Style = csDropDownList
          DropDownCount = 16
          TabOrder = 1
          OnClick = cb_colore_symbolico_Click
          AAA_dropdownwidth = 250
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = True
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = False
        end
        object cb_colore_symbolico_01: TFCombo
          Tag = 1
          Left = 123
          Top = 55
          Width = 112
          Height = 24
          Style = csDropDownList
          DropDownCount = 16
          TabOrder = 5
          OnClick = cb_colore_symbolico_Click
          AAA_dropdownwidth = 250
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = True
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = False
        end
        object cb_colore_symbolico_02: TFCombo
          Tag = 2
          Left = 123
          Top = 86
          Width = 112
          Height = 24
          Style = csDropDownList
          DropDownCount = 16
          TabOrder = 9
          OnClick = cb_colore_symbolico_Click
          AAA_dropdownwidth = 250
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = True
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = False
        end
        object cb_colore_symbolico_03: TFCombo
          Tag = 3
          Left = 123
          Top = 116
          Width = 112
          Height = 24
          Style = csDropDownList
          DropDownCount = 16
          TabOrder = 13
          OnClick = cb_colore_symbolico_Click
          AAA_dropdownwidth = 250
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = True
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = False
        end
      end
      object page_gradazione_colore: TTabSheet
        Caption = 'gradazione di colore'
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object panel_grad_riferimento: TFPanel
          Left = 0
          Top = 0
          Width = 627
          Height = 35
          Align = alTop
          BevelOuter = bvNone
          ParentBackground = False
          ParentColor = True
          TabOrder = 0
          DesignSize = (
            627
            35)
          object txt_grad_formula_valore: TMyLabel
            Left = 7
            Top = 8
            Width = 49
            Height = 16
            Caption = 'formula'
            FocusControl = str_grad_formula_valore
          end
          object panel_grad_sample: TFPanel
            Left = 306
            Top = 2
            Width = 320
            Height = 29
            Anchors = [akTop, akRight]
            ParentBackground = False
            TabOrder = 1
            object panel_grad_mix_sample: TFPanel
              Left = 49
              Top = 1
              Width = 222
              Height = 27
              Align = alClient
              ParentBackground = False
              TabOrder = 1
              object pbox: TPaintBox
                Left = 1
                Top = 1
                Width = 220
                Height = 25
                Align = alClient
                OnPaint = pboxPaint
                ExplicitLeft = 96
                ExplicitTop = 12
                ExplicitWidth = 105
                ExplicitHeight = 105
              end
            end
            object panel_grad_min_sample: TFPanel
              Left = 1
              Top = 1
              Width = 48
              Height = 27
              Align = alLeft
              Caption = 'min'
              ParentBackground = False
              TabOrder = 0
            end
            object panel_grad_max_sample: TFPanel
              Left = 271
              Top = 1
              Width = 48
              Height = 27
              Align = alRight
              Caption = 'max'
              ParentBackground = False
              TabOrder = 2
            end
          end
          object str_grad_formula_valore: TFEdit
            Left = 60
            Top = 4
            Width = 237
            Height = 24
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 0
            OnChange = AAA_notify_modification
            AAA_tipodato = fe_generico
            AAA_notify_modification = AAA_notify_modification
            AAA_NeedNotifyModification = True
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = True
          end
        end
        object panel_grad_minx: TFPanel
          Left = 0
          Top = 35
          Width = 627
          Height = 35
          Align = alTop
          BevelOuter = bvNone
          Color = 15334626
          ParentBackground = False
          TabOrder = 1
          DesignSize = (
            627
            35)
          object txt_grad_valore_base: TMyLabel
            Left = 42
            Top = 10
            Width = 93
            Height = 16
            Caption = 'valore minimo'
            FocusControl = i_grad_valore_min
          end
          object txt_grad_colore_min: TMyLabel
            Left = 219
            Top = 10
            Width = 92
            Height = 16
            Alignment = taRightJustify
            Caption = 'colore minimo'
          end
          object i_grad_valore_min: TFEdit
            Left = 143
            Top = 6
            Width = 54
            Height = 24
            NumbersOnly = True
            TabOrder = 0
            OnChange = AAA_notify_modification
            AAA_tipodato = fe_integer
            AAA_notify_modification = AAA_notify_modification
            AAA_NeedNotifyModification = True
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = True
          end
          object panel_grad_colore_min: TFPanel
            Tag = -1
            Left = 317
            Top = 6
            Width = 81
            Height = 24
            Cursor = crHandPoint
            ParentBackground = False
            TabOrder = 1
            OnClick = panel_colore_Click
          end
          object cb_grad_colore_symbolico_min: TFCombo
            Tag = -1
            Left = 411
            Top = 6
            Width = 199
            Height = 24
            Style = csDropDownList
            Anchors = [akLeft, akTop, akRight]
            DropDownCount = 16
            TabOrder = 2
            OnChange = cb_colore_symbolico_Click
            AAA_dropdownwidth = 250
            AAA_notify_modification = AAA_notify_modification
            AAA_NeedNotifyModification = True
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = False
          end
        end
        object panel_grad_mix: TFPanel
          Left = 0
          Top = 70
          Width = 627
          Height = 35
          Align = alTop
          BevelOuter = bvNone
          Color = 13565951
          ParentBackground = False
          TabOrder = 2
          DesignSize = (
            627
            35)
          object txt_grad_mix_header: TMyLabel
            Left = 1
            Top = 2
            Width = 84
            Height = 32
            Alignment = taRightJustify
            Caption = 'BANDA'#13#10'INTERMEDIA'
          end
          object txt_grad_mix_colore_iniziale: TMyLabel
            Left = 109
            Top = 10
            Width = 64
            Height = 16
            Alignment = taRightJustify
            Caption = 'dal colore'
          end
          object txt_grad_mix_colore_finale: TMyLabel
            Left = 382
            Top = 10
            Width = 56
            Height = 16
            Alignment = taRightJustify
            Caption = 'al colore'
          end
          object panel_grad_mix_colore_iniziale: TFPanel
            Tag = -1
            Left = 175
            Top = 6
            Width = 60
            Height = 24
            Cursor = crHandPoint
            ParentBackground = False
            TabOrder = 0
            OnClick = panel_colore_Click
          end
          object cb_grad_mix_colore_iniziale_symbolico: TFCombo
            Tag = -1
            Left = 243
            Top = 6
            Width = 94
            Height = 24
            Style = csDropDownList
            DropDownCount = 16
            TabOrder = 1
            OnChange = cb_colore_symbolico_Click
            AAA_dropdownwidth = 250
            AAA_notify_modification = AAA_notify_modification
            AAA_NeedNotifyModification = True
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = False
          end
          object panel_grad_mix_colore_finale: TFPanel
            Tag = -1
            Left = 446
            Top = 6
            Width = 60
            Height = 24
            Cursor = crHandPoint
            ParentBackground = False
            TabOrder = 2
            OnClick = panel_colore_Click
          end
          object cb_grad_mix_colore_finale_symbolico: TFCombo
            Tag = -1
            Left = 516
            Top = 6
            Width = 94
            Height = 24
            Style = csDropDownList
            Anchors = [akLeft, akTop, akRight]
            DropDownCount = 16
            TabOrder = 3
            OnChange = cb_colore_symbolico_Click
            AAA_dropdownwidth = 250
            AAA_notify_modification = AAA_notify_modification
            AAA_NeedNotifyModification = True
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = False
          end
        end
        object panel_grad_max: TFPanel
          Left = 0
          Top = 105
          Width = 627
          Height = 35
          Align = alTop
          BevelOuter = bvNone
          Color = 16777166
          ParentBackground = False
          TabOrder = 3
          DesignSize = (
            627
            35)
          object txt_grad_valore_max: TMyLabel
            Left = 30
            Top = 10
            Width = 105
            Height = 16
            Caption = 'valore massimo'
            FocusControl = i_grad_valore_max
          end
          object txt_grad_colore_max: TMyLabel
            Left = 239
            Top = 10
            Width = 72
            Height = 16
            Alignment = taRightJustify
            Caption = 'colore max'
          end
          object i_grad_valore_max: TFEdit
            Left = 143
            Top = 6
            Width = 54
            Height = 24
            NumbersOnly = True
            TabOrder = 0
            OnChange = AAA_notify_modification
            AAA_tipodato = fe_integer
            AAA_notify_modification = AAA_notify_modification
            AAA_NeedNotifyModification = True
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = True
          end
          object panel_grad_colore_max: TFPanel
            Tag = -1
            Left = 319
            Top = 6
            Width = 81
            Height = 24
            Cursor = crHandPoint
            ParentBackground = False
            TabOrder = 1
            OnClick = panel_colore_Click
          end
          object cb_grad_colore_symbolico_max: TFCombo
            Tag = -1
            Left = 411
            Top = 6
            Width = 199
            Height = 24
            Style = csDropDownList
            Anchors = [akLeft, akTop, akRight]
            DropDownCount = 16
            TabOrder = 2
            OnChange = cb_colore_symbolico_Click
            AAA_dropdownwidth = 250
            AAA_notify_modification = AAA_notify_modification
            AAA_NeedNotifyModification = True
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = False
          end
        end
        object panel_grad_extra_range: TFPanel
          Left = 0
          Top = 140
          Width = 627
          Height = 40
          Align = alClient
          BevelOuter = bvNone
          Color = 12698111
          ParentBackground = False
          TabOrder = 4
          DesignSize = (
            627
            40)
          object txt_grad_valore_extra_range: TMyLabel
            Left = 20
            Top = 11
            Width = 188
            Height = 16
            Caption = 'trattamento valori fuori range'
          end
          object txt_grad_colore_extra_range: TMyLabel
            Left = 271
            Top = 11
            Width = 40
            Height = 16
            Alignment = taRightJustify
            Caption = 'colore'
          end
          object panel_grad_colore_extra_range: TFPanel
            Tag = -1
            Left = 319
            Top = 7
            Width = 81
            Height = 24
            Cursor = crHandPoint
            ParentBackground = False
            TabOrder = 0
            OnClick = panel_colore_Click
          end
          object cb_grad_colore_symbolico_extra_range: TFCombo
            Tag = -1
            Left = 411
            Top = 7
            Width = 199
            Height = 24
            Style = csDropDownList
            Anchors = [akLeft, akTop, akRight]
            DropDownCount = 16
            TabOrder = 1
            OnChange = cb_colore_symbolico_Click
            AAA_dropdownwidth = 250
            AAA_notify_modification = AAA_notify_modification
            AAA_NeedNotifyModification = True
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = False
          end
        end
      end
    end
    object cbx_colori_condizionali: TFCheckBox
      Left = 46
      Top = 222
      Width = 151
      Height = 17
      Caption = 'colori condizionali'
      TabOrder = 7
      OnClick = cbx_colori_Click
      AAA_NeedNotifyModification = False
    end
    object cbx_gradazione_colore: TFCheckBox
      Left = 204
      Top = 222
      Width = 411
      Height = 17
      Caption = 'gradazione continua di colore in funzione di una formula'
      TabOrder = 8
      OnClick = cbx_colori_Click
      AAA_NeedNotifyModification = False
    end
    object cbx_disabled: TFCheckBox
      Left = 20
      Top = 51
      Width = 153
      Height = 17
      Caption = 'colonna disabilitata'
      TabOrder = 3
      OnClick = generic_enable_ctrls
      AAA_notify_modification = AAA_notify_modification
      AAA_NeedNotifyModification = False
    end
    object str_condizione_abilitazione: TFEdit
      Left = 352
      Top = 47
      Width = 263
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
      OnChange = AAA_notify_modification
      AAA_tipodato = fe_generico
      AAA_notify_modification = AAA_notify_modification
      AAA_NeedNotifyModification = True
      AAA_CanBeVoid = True
      AAA_CanBeInvalid = True
    end
  end
  object panel_footer: TFPanel
    Left = 0
    Top = 459
    Width = 637
    Height = 47
    Align = alBottom
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      637
      47)
    object btn_ok: TFBitBtn
      Left = 22
      Top = 9
      Width = 110
      Height = 28
      Action = AL_save
      Caption = 'Salva'
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
      show_shortcut = True
    end
    object btn_cancel: TFBitBtn
      Left = 149
      Top = 9
      Width = 98
      Height = 28
      Action = AL_annulla
      Cancel = True
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
      Left = 551
      Top = 9
      Width = 68
      Height = 28
      Action = AL_help
      Anchors = [akTop, akRight]
      Caption = 'Aiuto'
      TabOrder = 4
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
    object btn_righe_alterne: TFBitBtn
      Left = 289
      Top = 9
      Width = 127
      Height = 28
      Action = AL_righe_alternate
      Cancel = True
      Caption = 'righe alterne'
      TabOrder = 2
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000060000
        000A0000000A0000000A0000000A0000000B0000000B0000000B0000000B0000
        000B0000000B0000000B0000000B0000000B00000007000000027E5D52BDAF82
        72FFAF8272FFAE8172FFAE8072FFAE8071FFAE8071FFAE8070FFAD8070FFAD7F
        70FFAD7F70FFAC7F6FFFAC7F6FFFAD7E6FFF7C5B4FBE00000007B28577FFFCF8
        F6FFFCF8F5FFFBF7F6FFFBF7F5FFFBF7F5FFFBF7F5FFFBF6F4FFFBF6F4FFFBF6
        F3FFFBF6F3FFFBF6F3FFFAF5F2FFFAF5F2FFAE8072FF0000000AB5897AFFFCF9
        F7FFC59062FFC59062FFC58F61FFC58E60FFC48F60FFC58E60FFC48E5FFFC48D
        5FFFC48D5EFFC48C5EFFC48C5DFFFBF6F3FFB18475FF0000000AB68C7EFFFDFA
        F8FFCD9F75FFECD5B5FFE5C59CFFE5C49CFFE5C39BFFE4C49AFFE4C299FFE5C3
        9AFFE4C298FFE4C298FFC48E5FFFFBF7F5FFB28778FF00000009B98F81FFFDFB
        F9FFCEA178FFCEA177FFCEA077FFCDA077FFCEA077FFCEA077FFCDA076FFCDA0
        76FFCDA075FFCD9F75FFC69062FFFBF7F6FFB58A7CFF00000009BB9385FFFDFB
        FAFFF7F0EBFFF8EFEBFFF8F0EBFFF7EFEBFFF7EFEBFFF7F0EBFFF8EFEBFFF7EF
        EAFFF8EFEAFFF7EFEAFFF8EFEBFFFCF9F7FFB88E7FFF00000008BE9688FFFEFC
        FBFFCA9B6FFFCA9A6EFFCA996DFFCA996DFFCA986BFFC9976BFFC9966AFFC997
        6AFFC89569FFC99568FFC89568FFFCF9F8FFBA9183FF00000007C0998BFFFEFC
        FCFFD2A880FFF1E0C8FFE9CEAAFFE9CEA9FFE8CDA9FFE9CCA8FFE9CCA7FFE8CB
        A6FFE8CBA6FFE8CBA5FFCA976BFFFDFAF9FFBD9587FF00000007C29C8EFFFEFD
        FCFFD2A982FFD3A982FFD2AA82FFD2A981FFD2A881FFD2A881FFD2A981FFD1A8
        80FFD1A880FFD2A780FFCB9A6FFFFDFBFAFFC0978AFF00000006C49E91FFFEFE
        FDFFF9F0EDFFF8F1EDFFF9F0EDFFF9F0EDFFF8F1EDFFF8F0EDFFF8F1ECFFF8F0
        EDFFF8F0ECFFF8F0ECFFF8F0ECFFFDFCFBFFC29B8DFF00000006C6A093FFFFFE
        FEFFD1A77EFFD1A67DFFD1A67CFFD1A57BFFD0A57BFFCFA47AFFCFA379FFCFA2
        78FFCFA177FFCEA176FFCEA176FFFEFCFBFFC49E90FF00000005C7A396FFFFFE
        FEFFD6B18AFFF5E9D6FFEDD8B8FFEDD8B8FFEDD7B7FFECD7B6FFECD6B5FFECD5
        B5FFECD5B5FFECD4B3FFD0A479FFFEFDFCFFC5A093FF00000005C8A497FFFFFF
        FFFFD7B38DFFD7B38CFFD7B28CFFD8B18CFFD7B28BFFD7B28BFFD6B18AFFD7B1
        8AFFD6B18AFFD7B08AFFD1A77EFFFEFDFDFFC7A295FF00000004CAA699FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFEFEFFFFFE
        FEFFFFFEFEFFFFFEFEFFFFFEFEFFFEFEFEFFC8A497FF00000003967C72BECAA7
        9AFFCAA79AFFCAA79AFFCAA79AFFCAA79AFFCAA699FFCAA699FFCAA699FFCAA6
        99FFCAA699FFCAA699FFCAA699FFCAA699FF967B70BF00000002}
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = False
    end
    object FBitBtn1: TFBitBtn
      Left = 433
      Top = 9
      Width = 89
      Height = 28
      Action = AL_clear
      Cancel = True
      Caption = 'clear'
      TabOrder = 3
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00020000000900000012000000180000001A0000001A00000018000000100000
        0005000000010000000000000000000000000000000000000000000000020000
        000D3524146A936338E5A56B3AFFA36938FFA16736FF9D6233FB633E20B70805
        022800000006000000010000000000000000000000000000000000000008442F
        1D78C18B59FEE1AC76FFE4C296FFB5793BFFB5793CFFB5793CFFAD7239FF7E50
        2AD80302042A00000006000000010000000000000000000000000000000DB07D
        4EF3E6B17AFFE9B47DFFE9B47DFFE7C79DFFB67A3DFFB57A3DFFB57A3DFF6953
        7BFF090E5ED50001052800000006000000010000000000000000000000086A4E
        329DEFD7B3FFE9B47DFFE9B47DFFE9B47DFFEACDA4FFB57B3EFF735C86FF313F
        CCFF2935B8FF0B1161D501010627000000050000000100000000000000010000
        000C745538A5F2DDBBFFE9B47DFFE9B47DFFE9B47DFFD1CEE1FF3443CEFF3443
        CDFF3443CEFF2C39BAFF0D1463D4010106260000000500000001000000000000
        00020000000B76583BA4F5E2C1FFE9B47DFFB5A9B8FF829FF1FFB1C9F5FF3949
        D1FF3A4AD1FF3A49D1FF303FBDFF111767D30101062500000005000000000000
        0000000000010000000B785B3DA3E9E1D2FF87A3F2FF87A4F1FF87A3F2FFB9D0
        F7FF3E50D5FF3E50D5FF3F50D5FF3545C2FF141B6AD201010622000000000000
        000000000000000000010000000A2C386FA2C9E2F9FF8CA8F3FF8DA8F3FF8CA8
        F3FFC0D8F9FF4457D9FF4356D9FF4456D9FF3949C2FF141A61C2000000000000
        000000000000000000000000000100000009303D74A1CFE7FBFF92ADF3FF91AD
        F4FF92ADF4FFC6DEFAFF495EDBFF495DDCFF475AD7FF232F8BF0000000000000
        00000000000000000000000000000000000100000008334177A0D4ECFCFF97B2
        F5FF97B2F4FF97B3F5FFCCE4FBFF4A5FDAFF3141A4F6090C214A000000000000
        000000000000000000000000000000000000000000010000000736457A9FD8F0
        FDFF9DB7F5FF9CB7F5FFD9F1FEFF6B81CAF50B0E234700000006000000000000
        0000000000000000000000000000000000000000000000000001000000063947
        7D9EDBF3FEFFDBF3FFFF677FCFF513192C440000000500000001000000000000
        0000000000000000000000000000000000000000000000000000000000010000
        00053543728E4F63AACD151A2D40000000040000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0001000000030000000400000002000000000000000000000000}
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = False
    end
  end
  object AL: TActionList
    Left = 120
    Top = 108
    object AL_save: TAction
      Caption = 'Salva'
      ShortCut = 120
      OnExecute = AL_saveExecute
    end
    object AL_annulla: TAction
      Caption = 'Annulla'
      ShortCut = 27
      OnExecute = AL_annullaExecute
    end
    object AL_help: TAction
      Caption = 'Aiuto'
      OnExecute = AL_helpExecute
    end
    object AL_righe_alternate: TAction
      Caption = 'righe alterne'
      OnExecute = AL_righe_alternateExecute
    end
    object AL_clear: TAction
      Caption = 'clear'
      OnExecute = AL_clearExecute
    end
  end
end
