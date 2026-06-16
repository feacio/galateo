object dlg_pagina_logica: Tdlg_pagina_logica
  Left = 572
  Top = 224
  Caption = 'Pagina logica'
  ClientHeight = 461
  ClientWidth = 458
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = [fsBold]
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object pc: TPageControl
    Left = 0
    Top = 0
    Width = 458
    Height = 420
    ActivePage = page_base
    Align = alClient
    TabOrder = 0
    object page_base: TTabSheet
      Caption = 'opzioni'
      DesignSize = (
        450
        389)
      object txt_section_filename: TLabel
        Left = 20
        Top = 54
        Width = 76
        Height = 16
        Caption = '*ext fname*'
        FocusControl = str_section_filename
      end
      object txt_descrizione: TLabel
        Left = 113
        Top = 128
        Width = 117
        Height = 16
        Alignment = taRightJustify
        Caption = 'descrizione breve'
        FocusControl = str_descrizione_breve
      end
      object txt_ID_pagina: TLabel
        Left = 232
        Top = 31
        Width = 62
        Height = 16
        Caption = 'ID pagina'
        FocusControl = str_ID_pagina
      end
      object txt_PDF_watermark: TLabel
        Left = 34
        Top = 252
        Width = 98
        Height = 16
        Alignment = taRightJustify
        Caption = 'PDF watermark'
        FocusControl = str_PDF_watermark
      end
      object txt_message_if_printed: TLabel
        Left = 10
        Top = 215
        Width = 177
        Height = 32
        Alignment = taRightJustify
        Caption = 'messaggio da emettere se '#13#10'la pagina viene stampata'
        FocusControl = str_message_if_printed
      end
      object txt_descrizione_lunga: TLabel
        Left = 13
        Top = 154
        Width = 124
        Height = 16
        Alignment = taRightJustify
        Caption = 'descrizione estesa'
        FocusControl = str_descrizione_estesa
      end
      object txt_last_saved_by: TLabel
        Left = 67
        Top = 102
        Width = 68
        Height = 16
        Caption = 'salvata da'
        FocusControl = str_last_saved_by
      end
      object txt_versione_external_file: TLabel
        Left = 222
        Top = 6
        Width = 33
        Height = 14
        Caption = 'ver ***'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object txt_condizione: TMyLabel
        Left = 126
        Top = 320
        Width = 139
        Height = 16
        Caption = 'condizione di stampa'
        FocusControl = str_condizione
      end
      object str_section_filename: TEdit
        Left = 16
        Top = 70
        Width = 365
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        CharCase = ecLowerCase
        TabOrder = 2
        OnChange = AAA_notify_modification
      end
      object btn_browse: TFBitBtn
        Left = 388
        Top = 71
        Width = 23
        Height = 22
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 3
        OnClick = btn_browseClick
        color_background_down = clBtnFace
        color_background_up = clBtnFace
        show_shortcut = False
      end
      object str_descrizione_breve: TEdit
        Left = 234
        Top = 124
        Width = 177
        Height = 24
        Hint = 
          'descrizione breve della pagina logica'#13#10'viene usata anche per tut' +
          'te le comunicazioni di servizio'
        Anchors = [akLeft, akTop, akRight]
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        OnChange = AAA_notify_modification
      end
      object str_ID_pagina: TFEdit
        Left = 296
        Top = 27
        Width = 117
        Height = 24
        Hint = 
          'identificativo della pagina logica'#13#10'viene utilizzato in diversi ' +
          'contesti, fra cui:'#13#10'- la generazione del formato XML'#13#10'- la sosti' +
          'tuzione dinamica della pagina (ad esempio con una versione custo' +
          'mizzata, differenziata per ogni cliente)'
        Anchors = [akLeft, akTop, akRight]
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        AAA_tipodato = fe_generico
        AAA_notify_modification = AAA_notify_modification
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
      object cbx_message_if_not_printed: TFCheckBox
        Left = 28
        Top = 176
        Width = 380
        Height = 17
        Caption = 'emetti un messaggio se la pagina non viene stampata'
        TabOrder = 8
        OnClick = AAA_notify_modification
        AAA_NeedNotifyModification = True
      end
      object str_PDF_watermark: TFEdit
        Left = 136
        Top = 249
        Width = 219
        Height = 24
        Hint = 
          'file PDF utilizzato come fondopagina (tipicamente: il foglio del' +
          'la carta intestata)'
        Anchors = [akLeft, akTop, akRight]
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
        Text = 'str_PDF_watermark'
        AAA_tipodato = fe_generico
        AAA_notify_modification = AAA_notify_modification
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
      object btn_PDF_watermark_open: TFBitBtn
        Left = 384
        Top = 249
        Width = 27
        Height = 24
        Anchors = [akTop, akRight]
        TabOrder = 13
        TabStop = False
        OnClick = btn_PDF_watermark_openClick
        Glyph.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
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
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00550B0B0B0B0B
          0B0B0B0B0B0B010100080E9E9E9E9E9E9E9E9E9E9E9E9E5500080EFFF6FFF6FF
          080807F5F5F5AE5500080EF6F6080708070707070707AE5500085608F69E56F7
          F60708080808AE5500085607F6079E5607F6F6F6F6F6AE550E0856070708079F
          56F6F6F6F6F6AE0E0D0A56AE070708F69F9EAFAE08F6AE560E0156AE070708F6
          F656F6EF56569F56570196F7F7070808F69F07EF57F6AE0E000896F7ED070808
          F6F65656F6F6AE55000896F7ED0707FFF6F657AFF6F6AE55000896AEAEAEAEAE
          AEAE9FEEAEAEAE5500089E9F9F9F9F9F979F569EAF9F9F0E0808080808080808
          089F560808080808080808080808080808575708080808080808}
        color_background_down = clBtnFace
        color_background_up = clBtnFace
        show_shortcut = False
      end
      object btn_PDF_watermark_browse: TFBitBtn
        Left = 361
        Top = 249
        Width = 18
        Height = 24
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 12
        TabStop = False
        OnClick = btn_PDF_watermark_browseClick
        color_background_down = clBtnFace
        color_background_up = clBtnFace
        show_shortcut = False
      end
      object panel_colore_base: TFPanel
        Left = 12
        Top = 277
        Width = 175
        Height = 26
        ParentBackground = False
        TabOrder = 14
        object txt_colore_fondo: TLabel
          Left = 1
          Top = 1
          Width = 173
          Height = 24
          Cursor = crHandPoint
          Align = alClient
          Alignment = taCenter
          Caption = 'colore di fondo anteprima'
          Layout = tlCenter
          OnClick = txt_colore_fondoClick
          ExplicitWidth = 165
          ExplicitHeight = 16
        end
      end
      object panel_colore_alt: TFPanel
        Left = 352
        Top = 277
        Width = 92
        Height = 26
        ParentBackground = False
        TabOrder = 16
        object txt_colore_alt: TLabel
          Left = 1
          Top = 1
          Width = 90
          Height = 24
          Cursor = crHandPoint
          Align = alClient
          Alignment = taCenter
          Caption = 'colore blink'
          Color = clBtnFace
          ParentColor = False
          Layout = tlCenter
          WordWrap = True
          OnClick = txt_colore_altClick
          ExplicitWidth = 75
          ExplicitHeight = 16
        end
      end
      object cbx_blink: TFCheckBox
        Left = 199
        Top = 282
        Width = 143
        Height = 17
        Caption = 'attiva effetto blink'
        TabOrder = 15
        OnClick = cbx_blinkClick
        AAA_notify_modification = AAA_notify_modification
        AAA_NeedNotifyModification = False
      end
      object cbx_default_dont_print_page: TFCheckBox
        Left = 29
        Top = 195
        Width = 344
        Height = 17
        Hint = 
          'La pagina logica, bench'#232' presente sull'#39'anteprima,'#13#10'viene ignorat' +
          'a nella stampa reale'
        Caption = 'escludi pagina logica dalla stampa su stampante'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        OnClick = cbx_blinkClick
        AAA_notify_modification = AAA_notify_modification
        AAA_NeedNotifyModification = False
      end
      object str_message_if_printed: TEdit
        Left = 192
        Top = 219
        Width = 219
        Height = 24
        Hint = 
          'Il messaggio indicato viene emesso solo se la pagina '#232' stampata.' +
          #13#10' '#13#10'Serve per evidenziare la presenza di pagine di controllo'#13#10'(' +
          'ad esempio: pagine che contengono errori o anomalie)'
        Anchors = [akLeft, akTop, akRight]
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
        OnChange = AAA_notify_modification
      end
      object btn_colore_std: TFBitBtn
        Left = 12
        Top = 306
        Width = 113
        Height = 15
        Caption = 'colore standard'
        TabOrder = 17
        OnClick = btn_colore_stdClick
        color_background_down = clBtnFace
        color_background_up = clBtnFace
        show_shortcut = False
      end
      object str_descrizione_estesa: TEdit
        Left = 140
        Top = 150
        Width = 271
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 7
        OnChange = AAA_notify_modification
      end
      object rb_PL_external: TRadioGroup
        Left = 16
        Top = -1
        Width = 185
        Height = 51
        Caption = ' la pagina logica '#232' ... '
        Items.Strings = (
          'residente'
          'caricata da file esterno')
        TabOrder = 0
        TabStop = True
        OnClick = rb_PL_externalClick
      end
      object str_last_saved_by: TEdit
        Left = 140
        Top = 98
        Width = 241
        Height = 24
        Hint = 'nome del file che ha salvato la pagina'
        TabStop = False
        Anchors = [akLeft, akTop, akRight]
        CharCase = ecLowerCase
        Color = clMoneyGreen
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 4
      end
      object btn_open_last_saved_by: TFBitBtn
        Left = 387
        Top = 95
        Width = 27
        Height = 28
        Anchors = [akTop, akRight]
        TabOrder = 5
        TabStop = False
        OnClick = btn_open_last_saved_byClick
        Glyph.Data = {
          42080000424D4208000000000000420000002800000020000000200000000100
          1000030000000008000000000000000000000000000000000000007C0000E003
          00001F000000596B596B596B596B596B596B596B596B596B596B596B596B596B
          596B596B596B596B596B596B596B596B596B596B596B596B596B596B596B596B
          596B596B596B0000000000000000000000000000000000000000000000000000
          00000000000000000000100000000000000000000000596B596B596B596B596B
          596B596B596B00001002FF031002186310001042104210421042104200001042
          10421042104210421042100010021863100218630000596B596B596B596B596B
          596B596B596B000018631002186310021000596B596B596B596B596B1042596B
          596B596B596B596B596B100018631002596B10020000596B596B596B596B596B
          596B596B596B00001863FF03100218631000596B596B596B596B596B1042596B
          596B596B596B596B596B10001863596B1002596B0000596B596B596B596B596B
          596B596B596B000018631002186310021000596B596B596B596B596B1042596B
          596B0000596B596B596B100018631002596B10020000596B596B596B596B596B
          596B596B596B00001863FF03100218631000596B596B596B596B596B1042596B
          596B596B0000596B596B1000100218631002596B0000596B596B596B596B596B
          596B596B596B000010421002186310001000596B596B596B596B596B1042596B
          596B596B596B596B596B596B10001002596B10020000596B596B596B596B596B
          596B596B596B0000FF03FF031002100000000000000000000000000000000000
          000000000000000000000000100018631002596B0000596B596B596B596B596B
          596B596B596B000018631002FF031000596B596B596B596B596B596B0000596B
          596B596B596B596B596B596B10001002186310020000596B596B596B596B596B
          596B596B596B00001863FF0310021000596B0000596B0000596B596B1042596B
          596B596B596B596B596B596B596B1000100218630000596B596B596B596B596B
          596B596B596B000018631002FF031000596B596B0000596B0000596B1042596B
          596B0000596B596B596B596B596B1000186310020000596B596B596B596B596B
          596B596B596B000018631000100010001000596B596B0000596B596B1042596B
          596B596B0000596B596B596B596B1000100010000000596B596B596B596B596B
          596B596B596B000010001002FF03100210001000596B596B596B596B1042596B
          596B596B596B596B596B100010001002186310020000596B596B596B596B596B
          596B596B596B00001863FF031002FF03100210001000596B596B596B1042596B
          596B596B596B10001000186310021863100218630000596B596B596B596B596B
          596B596B596B0000FF031002FF0310021863FF03100010000000000000000000
          00000000100010001863100218631002186310020000596B596B596B596B596B
          596B596B596B00001863FF03100218631002186310021000596B596B0000596B
          596B596B1000FF031002FF0310021863100218630000596B596B596B596B596B
          596B596B596B000018631002FF031002FF031002FF0310001000596B1042596B
          596B596B10001002FF03100218631002186310020000596B596B596B596B596B
          596B596B596B00001863FF0310021863100218631002FF031000596B1042596B
          596B10001002FF031002FF031002596B100218630000596B596B596B596B596B
          596B596B596B000018631002FF03100218631002186310021000596B1042596B
          596B1000FF031002FF031002FF031002186310020000596B596B596B596B596B
          596B596B596B00001863FF031002FF03100218631002FF031000596B1042596B
          596B10001002FF031002FF031002FF03100210420000596B596B596B596B596B
          596B596B596B0000104200000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000596B596B596B596B596B
          596B596B596B0000104210421042104210421042104210421042104210421042
          10421042104210421042104210421042104210420000596B596B596B596B596B
          596B596B596B00001042FF03596BFF03596BFF03596B0000596BFF03596BFF03
          596BFF030000FF03596BFF03596BFF03104210420000596B596B596B596B596B
          596B596B596B596B00001042FF03596BFF0300000000596B0000596BFF03596B
          FF03000000000000FF03596BFF03596B10420000596B596B596B596B596B596B
          596B596B596B596B00001042596B00000000FF03596BFF03596B000000000000
          0000FF03596BFF0300000000596BFF0310420000596B596B596B596B596B596B
          596B596B596B596B000010420000596BFF03596BFF03596B0000596B0000596B
          0000596BFF03596BFF03596B000010420000596B596B596B596B596B596B596B
          596B596B596B596B596B00001042FF03596BFF03596B0000596BFF030000FF03
          596B0000596BFF03596BFF0310420000596B596B596B596B596B596B596B596B
          596B596B596B596B596B596B00001042FF03596B0000596BFF03596B0000596B
          FF03596B0000596BFF0310420000596B596B596B596B596B596B596B596B596B
          596B596B596B596B596B596B596B000000001042596BFF03596BFF030000FF03
          596BFF03596B104200000000596B596B596B596B596B596B596B596B596B596B
          596B596B596B596B596B596B596B596B596B0000000010421042104200001042
          1042104200000000596B596B596B596B596B596B596B596B596B596B596B596B
          596B596B596B596B596B596B596B596B596B596B596B00000000000000000000
          00000000596B596B596B596B596B596B596B596B596B596B596B596B596B596B
          596B596B596B}
        Margin = 0
        Spacing = 0
        color_background_down = clBtnFace
        color_background_up = clBtnFace
        show_shortcut = False
      end
      object cbx_dont_print: TFCheckBox
        Left = 4
        Top = 340
        Width = 113
        Height = 17
        Hint = 'la pagina NON viene stampata'
        Caption = 'non stampare'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 18
        OnClick = cbx_dont_printClick
        AAA_notify_modification = AAA_notify_modification
        AAA_NeedNotifyModification = False
      end
      object str_condizione: TFEdit
        Left = 119
        Top = 336
        Width = 303
        Height = 24
        Hint = 
          'la pagina viene stampata se la condizione indicata '#232' VERA (oppur' +
          'e se '#232' vuota)'
        Anchors = [akLeft, akTop, akRight]
        ParentShowHint = False
        ShowHint = True
        TabOrder = 19
        AAA_tipodato = fe_generico
        AAA_notify_modification = AAA_notify_modification
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = True
        AAA_CanBeInvalid = True
      end
      object cbx_exclude_debug: TFCheckBox
        Left = 4
        Top = 369
        Width = 212
        Height = 17
        Hint = 
          'la pagina e gli oggetti della pagina NON generano informazioni d' +
          'i debugging'
        Caption = 'escludi debug per la pagina'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 20
        OnClick = cbx_dont_printClick
        AAA_notify_modification = AAA_notify_modification
        AAA_NeedNotifyModification = False
      end
    end
    object page_GAPP: TTabSheet
      Caption = 'numerazione automatica'
      ImageIndex = 1
      object panel_GAPP_attiva: TFPanel
        Left = 0
        Top = 0
        Width = 450
        Height = 31
        Align = alTop
        ParentBackground = False
        TabOrder = 0
        object cbx_attiva_GAPP: TFCheckBox
          Left = 48
          Top = 8
          Width = 345
          Height = 17
          Caption = 'attiva gestione automatica progressivi di pagina'
          TabOrder = 0
          OnClick = cbx_attiva_GAPPClick
          AAA_NeedNotifyModification = True
        end
      end
      object panel_GAPP_codice: TFPanel
        Left = 0
        Top = 31
        Width = 450
        Height = 61
        Align = alTop
        ParentBackground = False
        TabOrder = 1
        object txt_obj_automatic_index: TLabel
          Left = 72
          Top = 6
          Width = 192
          Height = 48
          Alignment = taRightJustify
          Caption = 
            'oggetto che contiene il codice'#13#10'usato per la generazione'#13#10'automa' +
            'tica numeri di pagina'
          FocusControl = cb_GAPP_str_tipo_progressivo
        end
        object cb_GAPP_str_tipo_progressivo: TFCombo
          Left = 272
          Top = 18
          Width = 180
          Height = 24
          Style = csDropDownList
          DropDownCount = 16
          TabOrder = 0
          AAA_dropdownwidth = 250
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
      end
      object panel_GAPP_operatore: TFPanel
        Left = 0
        Top = 243
        Width = 450
        Height = 40
        Align = alTop
        ParentBackground = False
        TabOrder = 5
        object txt_AI_operatore: TLabel
          Left = 53
          Top = 10
          Width = 209
          Height = 16
          Alignment = taRightJustify
          Caption = 'operatore che esegue la stampa'
          FocusControl = cb_GAPP_operatore
        end
        object cb_GAPP_operatore: TFCombo
          Left = 272
          Top = 6
          Width = 180
          Height = 24
          Style = csDropDownList
          DropDownCount = 16
          TabOrder = 0
          AAA_dropdownwidth = 250
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
      end
      object panel_GAPP_record: TFPanel
        Left = 0
        Top = 129
        Width = 450
        Height = 46
        Align = alTop
        ParentBackground = False
        TabOrder = 3
        object txt_GAPP_record: TLabel
          Left = 23
          Top = 8
          Width = 239
          Height = 32
          Alignment = taRightJustify
          Caption = 'codice del record stampato'#13#10'(esempio: numero riga di prima nota)'
          FocusControl = cb_GAPP_str_record
        end
        object cb_GAPP_str_record: TFCombo
          Left = 272
          Top = 12
          Width = 180
          Height = 24
          Style = csDropDownList
          DropDownCount = 16
          TabOrder = 0
          AAA_dropdownwidth = 250
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
      end
      object panel_GAPP_esercizio: TFPanel
        Left = 0
        Top = 92
        Width = 450
        Height = 37
        Align = alTop
        ParentBackground = False
        TabOrder = 2
        object txt_esercizio: TLabel
          Left = 113
          Top = 10
          Width = 150
          Height = 16
          Alignment = taRightJustify
          Caption = 'esercizio di riferimento'
          FocusControl = cb_GAPP_esercizio
        end
        object cb_GAPP_esercizio: TFCombo
          Left = 272
          Top = 6
          Width = 180
          Height = 24
          Style = csDropDownList
          DropDownCount = 16
          TabOrder = 0
          AAA_dropdownwidth = 250
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
      end
      object panel_GAPP_data: TFPanel
        Left = 0
        Top = 175
        Width = 450
        Height = 68
        Align = alTop
        ParentBackground = False
        TabOrder = 4
        object txt_AI_dt_riferimento: TLabel
          Left = 33
          Top = 7
          Width = 229
          Height = 48
          Alignment = taRightJustify
          Caption = 
            'data di riferimento della pagina'#13#10'(esempio: dt della riga, o del' +
            ' mese)'#13#10'(formato: YYYY-MM-DD)'
          FocusControl = cb_GAPP_dt_riferimento
        end
        object cb_GAPP_dt_riferimento: TFCombo
          Left = 272
          Top = 19
          Width = 180
          Height = 24
          Style = csDropDownList
          DropDownCount = 16
          TabOrder = 0
          AAA_dropdownwidth = 250
          AAA_notify_modification = AAA_notify_modification
          AAA_NeedNotifyModification = False
          AAA_CanBeVoid = True
          AAA_CanBeInvalid = True
        end
      end
    end
    object page_exportazione: TTabSheet
      Caption = 'exportazione'
      ImageIndex = 2
      object panel_export_edit: TFPanel
        Left = 0
        Top = 150
        Width = 450
        Height = 239
        Align = alClient
        ParentBackground = False
        TabOrder = 1
        object pc_export: TFPageControl
          Left = 1
          Top = 42
          Width = 448
          Height = 196
          ActivePage = page_expint
          Align = alClient
          OwnerDraw = True
          TabOrder = 1
          AAA_AutoHighLight = False
          AAA_OpenOnFirstPage = False
          object page_expint: TTabSheet
            Caption = 'page_expint'
            object panel_expint: TFPanel
              Left = 0
              Top = 0
              Width = 440
              Height = 165
              Align = alClient
              ParentBackground = False
              TabOrder = 0
              object cbx_expint_pagina_fisica: TFCheckBox
                Left = 18
                Top = 11
                Width = 181
                Height = 17
                Caption = 'numero di pagina fisica'
                Color = clBtnFace
                ParentColor = False
                TabOrder = 0
                OnClick = cbx_export_allowedClick
                AAA_notify_modification = AAA_notify_modification
                AAA_NeedNotifyModification = False
              end
              object cbx_expint_pagina_logica: TFCheckBox
                Left = 18
                Top = 29
                Width = 151
                Height = 17
                Caption = 'sigla pagina logica'
                Color = clBtnFace
                ParentColor = False
                TabOrder = 1
                OnClick = cbx_export_allowedClick
                AAA_notify_modification = AAA_notify_modification
                AAA_NeedNotifyModification = False
              end
              object cbx_expint_sezione: TFCheckBox
                Left = 228
                Top = 29
                Width = 113
                Height = 17
                Caption = 'sigla sezione'
                Color = clBtnFace
                ParentColor = False
                TabOrder = 2
                OnClick = cbx_export_allowedClick
                AAA_notify_modification = AAA_notify_modification
                AAA_NeedNotifyModification = False
              end
              object cbx_expint_record: TFCheckBox
                Left = 228
                Top = 11
                Width = 205
                Height = 17
                Caption = 'numero progressivo record'
                Color = clBtnFace
                ParentColor = False
                TabOrder = 3
                OnClick = cbx_export_allowedClick
                AAA_notify_modification = AAA_notify_modification
                AAA_NeedNotifyModification = False
              end
              object cbx_expint_headers: TFCheckBox
                Left = 18
                Top = 47
                Width = 165
                Height = 17
                Caption = 'intestazione colonne'
                Color = clBtnFace
                ParentColor = False
                TabOrder = 4
                OnClick = cbx_export_allowedClick
                AAA_notify_modification = AAA_notify_modification
                AAA_NeedNotifyModification = False
              end
              object cbx_blank_after_headers: TFCheckBox
                Left = 18
                Top = 65
                Width = 298
                Height = 17
                Caption = 'riga di separazione tra intestazione e dati'
                Color = clBtnFace
                ParentColor = False
                TabOrder = 5
                OnClick = cbx_export_allowedClick
                AAA_notify_modification = AAA_notify_modification
                AAA_NeedNotifyModification = False
              end
            end
          end
          object page_XML: TTabSheet
            Caption = 'page_XML'
            ImageIndex = 1
            object txt_struttura_XML: TMyLabel
              Left = 0
              Top = 0
              Width = 440
              Height = 16
              Align = alTop
              Caption = 'struttura dati XML'
              FocusControl = str_struttura_XML
              ExplicitWidth = 115
            end
            object str_struttura_XML: TFMemo
              Left = 0
              Top = 16
              Width = 440
              Height = 149
              Align = alClient
              ScrollBars = ssBoth
              TabOrder = 0
              WantTabs = True
              WordWrap = False
              AAA_notify_modification = AAA_notify_modification
              AAA_NeedNotifyModification = False
              AAA_CanBeVoid = True
              AAA_CanBeInvalid = True
            end
          end
        end
        object panel_export_header: TFPanel
          Left = 1
          Top = 1
          Width = 448
          Height = 41
          Align = alTop
          ParentBackground = False
          TabOrder = 0
          object txt_export_sigla: TMyLabel
            Left = 227
            Top = 15
            Width = 80
            Height = 16
            Alignment = taRightJustify
            Caption = 'sigla pagina'
            FocusControl = str_export_sigla
          end
          object cbx_export_allowed: TFCheckBox
            Left = 18
            Top = 15
            Width = 157
            Height = 17
            Caption = 'abilita exportazione'
            TabOrder = 0
            OnClick = cbx_export_allowedClick
            AAA_notify_modification = AAA_notify_modification
            AAA_NeedNotifyModification = False
          end
          object str_export_sigla: TFEdit
            Left = 312
            Top = 11
            Width = 82
            Height = 24
            Hint = 
              'sigla che consente l'#39'dentificazione breve della pagina nel file ' +
              'esportato'
            MaxLength = 7
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnChange = str_export_siglaChange
            AAA_tipodato = fe_generico
            AAA_notify_modification = AAA_notify_modification
            AAA_NeedNotifyModification = False
            AAA_CanBeVoid = True
            AAA_CanBeInvalid = True
          end
        end
      end
      object lv_export: TListView
        Left = 0
        Top = 0
        Width = 450
        Height = 150
        Align = alTop
        Columns = <>
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnClick = lv_exportClick
      end
    end
    object page_size_constraints: TTabSheet
      Caption = 'dimensioni'
      ImageIndex = 3
      DesignSize = (
        450
        389)
      object txt_size_modalita: TMyLabel
        Left = 22
        Top = 54
        Width = 132
        Height = 16
        Caption = 'modalit'#224' di controllo'
      end
      object txt_size_header: TMyLabel
        Left = 0
        Top = 0
        Width = 450
        Height = 31
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = 'controllo dimensioni pagina stampante'
        Color = 11075583
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = False
        Layout = tlCenter
      end
      object gbox_printer_size_MIN: TFGroupBox
        Left = 35
        Top = 164
        Width = 366
        Height = 60
        Caption = 'dimensioni MINIME pagina stampante'
        TabOrder = 0
        object txt_page_min_height: TMyLabel
          Left = 9
          Top = 30
          Width = 84
          Height = 16
          Alignment = taRightJustify
          Caption = 'altezza (mm)'
          FocusControl = i_min_page_height
        end
        object txt_page_min_width: TMyLabel
          Left = 181
          Top = 30
          Width = 101
          Height = 16
          Alignment = taRightJustify
          Caption = 'larghezza (mm)'
          FocusControl = i_min_page_width
        end
        object i_min_page_height: TFEdit
          Left = 97
          Top = 26
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
          Top = 26
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
        Left = 35
        Top = 237
        Width = 366
        Height = 60
        Caption = 'dimensioni MASSIME pagina stampante'
        TabOrder = 1
        object txt_page_max_height: TMyLabel
          Left = 9
          Top = 30
          Width = 84
          Height = 16
          Alignment = taRightJustify
          Caption = 'altezza (mm)'
          FocusControl = i_max_page_height
        end
        object txt_page_max_width: TMyLabel
          Left = 181
          Top = 30
          Width = 101
          Height = 16
          Alignment = taRightJustify
          Caption = 'larghezza (mm)'
          FocusControl = i_max_page_width
        end
        object i_max_page_height: TFEdit
          Left = 97
          Top = 26
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
          Top = 26
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
      object cb_size_modalita: TFCombo
        Left = 158
        Top = 51
        Width = 275
        Height = 24
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
        OnChange = cb_size_modalitaChange
        AAA_dropdownwidth = 0
        AAA_notify_modification = AAA_notify_modification
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = False
        AAA_CanBeInvalid = False
      end
    end
  end
  object panel_buttons: TFPanel
    Left = 0
    Top = 420
    Width = 458
    Height = 41
    Align = alBottom
    ParentBackground = False
    TabOrder = 1
    object btn_ok: TFBitBtn
      Left = 140
      Top = 8
      Width = 77
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
      Left = 230
      Top = 8
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
    object btn_help: TMyBitBtn
      Left = 354
      Top = 8
      Width = 80
      Height = 25
      Caption = 'aiuto'
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
  end
  object AL: TActionList
    Left = 32
    Top = 404
    object AL_save: TAction
      Caption = 'F9 OK'
      ShortCut = 120
      OnExecute = AL_saveExecute
    end
  end
end
