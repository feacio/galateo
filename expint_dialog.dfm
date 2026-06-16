object dlg_expint_setup: Tdlg_expint_setup
  Left = 122
  Top = 172
  Caption = '?'
  ClientHeight = 529
  ClientWidth = 782
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object txt_header: TMyLabel
    Left = 0
    Top = 0
    Width = 782
    Height = 24
    Cursor = crHandPoint
    Align = alTop
    Alignment = taCenter
    Caption = 'txt_header'
    Color = 8454016
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Layout = tlCenter
    OnClick = txt_headerClick
    ExplicitWidth = 108
  end
  object panel_base: TFPanel
    Left = 0
    Top = 24
    Width = 782
    Height = 442
    Align = alClient
    Caption = 'exportazione    pagina    logica    disabilitata'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    OnResize = panel_baseResize
  end
  object panel_bottom: TFPanel
    Left = 0
    Top = 466
    Width = 782
    Height = 63
    Align = alBottom
    ParentBackground = False
    TabOrder = 0
    object btn_close: TFBitBtn
      Left = 12
      Top = 12
      Width = 83
      Height = 31
      Cancel = True
      Caption = 'Chiudi'
      TabOrder = 0
      OnClick = btn_closeClick
      Glyph.Data = {
        B2050000424DB205000000000000360400002800000013000000130000000100
        0800000000007C01000000000000000000000001000000000000000000000000
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
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0008560D151515
        15151515160E0E0E0E0E0D15080056161656565656575717171717171717170E
        15001717575F5F5F5F5F5F5F5F1F17171717170F0D0017575F5F5F5F5F5F5F5F
        5F5F1F1F171717170D00175F5F5FEFFF5F5F5F5F5F5F5FFFB71717170E00175F
        5F5FFFFFFF5F5F5F5F5FFFFFFF1717170E00575F5F5F5FFFFFFF5F5F5FFFFFFF
        1F1717170E00575F5F5F5F5FFFFFFF5FFFFFF65F1F17171716005F5F6767675F
        5FFFFFFFFFFF5F5F1717171716005F5F6767675F5F5FFFFFFF5F5F5F17175757
        15005F676767675F5FFFFFFFFFFF5F575757575715005FA7A7A7675FFFFFFF5F
        FFFFFF5757575F5715005FA7A7A767FFFFFF5F5F5FFFFFFF575F5F5715005FA7
        A7A7FFFFFF5F5F5F5F5FFFFFFF5F5F5715005FAFAFA7EFFF675F5F5F5F5F5FFF
        EF5F5F57150067AFAFAFA7A7A767675F5F5F5F5F5F5F5F571500A7AFAFAFAFA7
        A7A7A7A7A767675F5F5F5F571500A7AFAFAFA7A7A7A7A7676767675F5F5F5F57
        5600F6A7A7675F5F5F5F5F5F5F5F5F5F5F57175FF600}
      Spacing = 8
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = False
    end
    object btn_rinumera: TFBitBtn
      Left = 104
      Top = 12
      Width = 125
      Height = 31
      Action = AL_rinumera
      Cancel = True
      Caption = 'Rinumera'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Glyph.Data = {
        A6050000424DA605000000000000360400002800000010000000170000000100
        0800000000007001000000000000000000000001000000000000000000000000
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
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
        0707070707070707070707FAFAFAFA000000000000FAFAFAFA0707FAFAFAFAFA
        00FAFAFAFAFAFAFAFA0707FAFAFAFAFAFA00FAFAFAFAFAFAFA0707FAFAFAFAFA
        FAFA00FAFAFAFAFAFA0707FAFAFAFAFAFAFAFA00FAFAFAFAFA0707FAFAFAFAFA
        FAFAFAFA00FAFAFAFA0707FAFAFAFAFAFAFAFAFA00FAFAFAFA0707FAFAFAFAFA
        FAFAFAFA00FAFAFAFA0707FAFAFAFA00FAFAFAFA00FAFAFAFA0707FAFAFAFAFA
        00000000FAFAFAFAFA0707FAFA00FAFAFAFAFAFAFAFAFAFAFA0707FAFA00FAFA
        FAFAFAFA00000000FA0707FAFA00FAFAFAFAFA00FAFAFAFA000707FAFA00FAFA
        FAFAFAFAFAFAFAFA000707FAFA00FAFAFAFAFAFAFAFAFAFA000707FAFA00FAFA
        FAFAFAFAFAFAFAFA000707FAFA00FAFAFAFAFAFAFA000000FA070700FA00FAFA
        FAFAFAFAFAFAFAFA000707FA0000FAFAFAFAFAFAFAFAFAFA000707FAFA00FAFA
        FAFAFA00FAFAFAFA000707FAFAFAFAFAFAFAFAFA00000000FA07070707070707
        07070707070707070707}
      Spacing = 8
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = True
    end
    object panel_filter: TFPanel
      Left = 478
      Top = 1
      Width = 303
      Height = 61
      Align = alRight
      Color = 8454143
      ParentBackground = False
      TabOrder = 4
      object cbx_testi: TFCheckBox
        Left = 11
        Top = 4
        Width = 58
        Height = 17
        Caption = 'testi'
        TabOrder = 0
        OnClick = cbx_showClick
        colorChecked = 8454143
        colorUnChecked = 8454143
        AAA_NeedNotifyModification = False
      end
      object cbx_parametri: TFCheckBox
        Left = 88
        Top = 23
        Width = 91
        Height = 17
        Caption = 'parametri'
        Checked = True
        State = cbChecked
        TabOrder = 3
        OnClick = cbx_showClick
        colorChecked = 8454143
        colorUnChecked = 8454143
        AAA_NeedNotifyModification = False
      end
      object cbx_fields: TFCheckBox
        Left = 88
        Top = 4
        Width = 129
        Height = 17
        Caption = 'campi database'
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = cbx_showClick
        colorChecked = 8454143
        colorUnChecked = 8454143
        AAA_NeedNotifyModification = False
      end
      object cbx_formule: TFCheckBox
        Left = 11
        Top = 23
        Width = 78
        Height = 17
        Caption = 'formule'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = cbx_showClick
        colorChecked = 8454143
        colorUnChecked = 8454143
        AAA_NeedNotifyModification = False
      end
      object cbx_strings: TFCheckBox
        Left = 220
        Top = 4
        Width = 77
        Height = 17
        Caption = 'stringhe'
        Checked = True
        State = cbChecked
        TabOrder = 5
        OnClick = cbx_showClick
        colorChecked = 8454143
        colorUnChecked = 8454143
        AAA_NeedNotifyModification = False
      end
      object cbx_numbers: TFCheckBox
        Left = 220
        Top = 23
        Width = 72
        Height = 17
        Caption = 'numeri'
        Checked = True
        State = cbChecked
        TabOrder = 6
        OnClick = cbx_showClick
        colorChecked = 8454143
        colorUnChecked = 8454143
        AAA_NeedNotifyModification = False
      end
      object cbx_local_SQL: TFCheckBox
        Left = 88
        Top = 43
        Width = 91
        Height = 16
        Caption = 'SQL locali'
        Checked = True
        State = cbChecked
        TabOrder = 4
        OnClick = cbx_showClick
        colorChecked = 8454143
        colorUnChecked = 8454143
        AAA_NeedNotifyModification = False
      end
      object btn_default_options: TFBitBtn
        Left = 221
        Top = 42
        Width = 64
        Height = 18
        Cancel = True
        Caption = 'default'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = btn_default_optionsClick
        Spacing = 8
        color_background_down = clBtnFace
        color_background_up = clBtnFace
        show_shortcut = True
      end
    end
    object btn_insert_blank: TFBitBtn
      Left = 240
      Top = 12
      Width = 90
      Height = 31
      Action = AL_insert_blank
      Cancel = True
      Caption = 'blank'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Glyph.Data = {
        D6000000424DD60000000000000076000000280000000C0000000C0000000100
        0400000000006000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFF0000FFFF
        0000FFFF0AA0FFFF0000FFFF0AA0FFFF0000FFFF0AA0FFFF000000000AA00000
        00000AAAAAAAAAA000000AAAAAAAAAA0000000000AA000000000FFFF0AA0FFFF
        0000FFFF0AA0FFFF0000FFFF0AA0FFFF0000FFFF0000FFFF0000}
      Spacing = 8
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = True
    end
    object btn_delete_blank: TFBitBtn
      Left = 336
      Top = 12
      Width = 90
      Height = 31
      Action = AL_delete_blank
      Cancel = True
      Caption = 'blank'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Glyph.Data = {
        D6000000424DD60000000000000076000000280000000C0000000C0000000100
        0400000000006000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        0000FFFFFFFFFFFF0000FFFFFFFFFFFF0000FFFFFFFFFFFF0000000000000000
        0000099999999990000009999999999000000000000000000000FFFFFFFFFFFF
        0000FFFFFFFFFFFF0000FFFFFFFFFFFF0000FFFFFFFFFFFF0000}
      Spacing = 8
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = True
    end
  end
  object popup_sezione: TPopupMenu
    Left = 108
    Top = 60
    object itp_edit_object: TMenuItem
      Action = AL_edit_object
    end
    object itp_setup_sezione: TMenuItem
      Caption = 'Modifica impostazioni sezione'
      OnClick = itp_setup_sezioneClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object itp_sezione_rinumera: TMenuItem
      Action = AL_rinumera
    end
    object itp_delete_numerazione: TMenuItem
      Action = AL_delete_numerazione
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object itp_enable_section: TMenuItem
      Caption = 'Abilita exportazione sezione'
    end
    object itp_disable_section: TMenuItem
      Caption = 'Disabilita exportazione sezione'
    end
  end
  object ACL: TActionList
    Left = 208
    Top = 76
    object AL_rinumera: TAction
      Caption = 'Rinumera'
      Hint = 
        'Rinumera gli oggetti della sezione selezionata'#13#10'(solo per quanto' +
        ' riguarda la sequenza di exportazione)'
      ShortCut = 115
      OnExecute = AL_rinumeraExecute
    end
    object AL_delete_numerazione: TAction
      Caption = 'Elimina numerazione oggetti'
      OnExecute = AL_delete_numerazioneExecute
    end
    object AL_resize_window: TAction
      Caption = 'toogle window size'
      ShortCut = 32884
      OnExecute = AL_resize_windowExecute
    end
    object AL_insert_blank: TAction
      Caption = 'blank'
      ShortCut = 45
      OnExecute = AL_insert_blankExecute
    end
    object AL_delete_blank: TAction
      Caption = 'blank'
      ShortCut = 46
      OnExecute = AL_delete_blankExecute
    end
    object AL_edit_object: TAction
      Caption = 'Modifica impostazioni oggetto'
      ShortCut = 113
      OnExecute = AL_edit_objectExecute
    end
  end
end
