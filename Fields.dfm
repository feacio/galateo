object w_fields: Tw_fields
  Left = 282
  Top = 170
  BorderIcons = [biSystemMenu]
  Caption = 'Colonne Database'
  ClientHeight = 375
  ClientWidth = 322
  Color = clBtnFace
  Constraints.MinWidth = 250
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  Menu = menu
  OldCreateOrder = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 16
  object lb: TListBox
    Left = 0
    Top = 0
    Width = 322
    Height = 310
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 15
    ParentFont = False
    PopupMenu = popup
    TabOrder = 0
    OnDblClick = lbDblClick
  end
  object panel_buttons: TPanel
    Left = 0
    Top = 310
    Width = 322
    Height = 65
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      322
      65)
    object btn_order_by_name: TFSpeedButton
      Left = 92
      Top = 8
      Width = 224
      Height = 22
      AllowAllUp = True
      Anchors = [akLeft, akTop, akRight]
      GroupIndex = 1
      Caption = 'F4 ordina per nome'
      OnClick = btn_order_by_nameClick
      aspetto_standard = False
      color_text = clBlack
      color_text_disabled = clBlack
      color_bk_disabled = clBlack
      show_shortcut = False
      round_corners = 0
      ExplicitWidth = 198
    end
    object btn_not_used: TFSpeedButton
      Left = 92
      Top = 36
      Width = 224
      Height = 22
      AllowAllUp = True
      Anchors = [akLeft, akTop, akRight]
      GroupIndex = 2
      Caption = 'F6 solo non utilizzati'
      OnClick = btn_not_usedClick
      aspetto_standard = False
      color_text = clBlack
      color_text_disabled = clBlack
      color_bk_disabled = clBlack
      show_shortcut = False
      round_corners = 0
      ExplicitWidth = 198
    end
    object btn_load: TFBitBtn
      Left = 5
      Top = 8
      Width = 81
      Height = 33
      Caption = 'Carica'
      Default = True
      TabOrder = 0
      OnClick = btn_loadClick
      Glyph.Data = {
        D6060000424DD606000000000000360400002800000019000000180000000100
        080000000000A002000000000000000000000001000000010000000000000000
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
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF00000000FF
        FFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFF00000000F800FFFFFFFF
        FFFFFFFFFFFFFF000000FFFFFFFFFFFFFF000000000207F800FFFFFFFFFFFF00
        00FFFF000000FFFFFFFFFFFF000000000202FA07F800FFFFFFFF00000000FF00
        0000FFFFFFFFFF00000000020202020207F800FFFF000000F800FF000000FFFF
        FFFF000000000202FA02FA02FA07F800000000F8F800FF000000FFFFFF000000
        0002020202020202020207F800000007F800FF000000FFFF000000000202FA02
        FA02FA02FA02FA07F800F807F800FF000000FF0000000002020202FA02FA02FA
        02FA020207F80207F800FF000000FF0000000202FA02FA02FA02FA02FAFAFA02
        FA02FA07F800FF000000FFFF00FFFF0202FA02FA02FA02FA02FA02FA02020207
        F800FF000000FFFFFF00FFFF0202FA02FA02FAFAFAFAFAFAFA02FA07F800FF00
        0000FFFFFFFF00FFFF0202FA02FA02FA02FAFAFA02FA0207F800FF000000FFFF
        FFFFFF00FFFF0202FAFAFAFAFAFAFAFAFAFAFA07F800FF000000FFFFFFFFFFFF
        00FFFF0202FA02FAFAFA02FAFAFA0207F800FF000000FFFFFFFFFFFFFF00FFFF
        0202FAFAFAFAFAFAFAFAFA07F800FF000000FFFFFFFFFFFF000000FF020202FA
        02FAFAFAFAFAFA07F800FF000000FFFFFFFFFF00000000FFFA02FA02FAFAFAFA
        FAFAFA07F800FF000000FFFFFFFF00000000FF0202FA02FAFAFAFAFAFAFAFA07
        F800FF000000FFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF07F800FF00
        0000FFFFFFFFFFFF0000000000000000000000000000000000FFFF000000FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000}
      Layout = blGlyphRight
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = False
    end
  end
  object menu: TMainMenu
    Left = 28
    Top = 40
    object itm_fields: TMenuItem
      Caption = 'Campi database'
      object itm_update_fields: TMenuItem
        Caption = 'Ricarica campi'
        ShortCut = 116
        OnClick = itm_update_fieldsClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object itm_close: TMenuItem
        Caption = 'Chiudi'
        ShortCut = 27
        OnClick = itm_closeClick
      end
    end
    object itm_opzioni: TMenuItem
      Caption = 'Opzioni'
      object itm_solo_campi_mancanti: TMenuItem
        Caption = 'Solo campi non utilizzati'
        ShortCut = 117
        OnClick = itm_solo_campi_mancantiClick
      end
      object itm_primo_piano: TMenuItem
        Caption = 'Sempre in primo piano'
        OnClick = itm_primo_pianoClick
      end
      object itm_sort_fields: TMenuItem
        Caption = 'Ordina i campi'
        ShortCut = 115
        OnClick = itm_sort_fieldsClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object itm_copy_field_name: TMenuItem
        Caption = 'Copia nome campo'
        ShortCut = 16451
        OnClick = itm_copy_field_nameClick
      end
    end
  end
  object popup: TPopupMenu
    Left = 120
    Top = 28
    object itp_carica: TMenuItem
      Caption = 'Carica campo su report'
      Default = True
      OnClick = itp_caricaClick
    end
    object itp_copy_field_name: TMenuItem
      Caption = 'Copia nome campo'
      ShortCut = 16451
    end
  end
end
