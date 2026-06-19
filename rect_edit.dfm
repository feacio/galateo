object dlg_rect_settings: Tdlg_rect_settings
  Left = 411
  Top = 191
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Impostazioni rettangolo'
  ClientHeight = 418
  ClientWidth = 653
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  DesignSize = (
    653
    418)
  TextHeight = 16
  object txt_nome: TLabel
    Left = 27
    Top = 8
    Width = 88
    Height = 16
    Caption = 'nome oggetto'
    FocusControl = str_nome
  end
  object txt_object: TLabel
    Left = 568
    Top = 394
    Width = 63
    Height = 16
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = 'txt_object'
    ExplicitTop = 403
  end
  object gbox_base: TGroupBox
    Left = 14
    Top = 34
    Width = 621
    Height = 113
    Anchors = [akLeft, akTop, akRight]
    Caption = ' impostazioni '
    TabOrder = 1
    DesignSize = (
      621
      113)
    object txt_thickness: TLabel
      Left = 15
      Top = 22
      Width = 97
      Height = 16
      Alignment = taRightJustify
      Caption = 'spessore linea'
      FocusControl = i_thickness
    end
    object txt_show: TLabel
      Left = 186
      Top = 56
      Width = 124
      Height = 16
      Caption = 'F6 visualizzazione'
      FocusControl = cb_show
    end
    object txt_print_if: TLabel
      Left = 27
      Top = 86
      Width = 112
      Height = 16
      Alignment = taRightJustify
      Caption = 'F11 stampa se ...'
      FocusControl = str_print_if
    end
    object txt_round_corners: TLabel
      Left = 22
      Top = 56
      Width = 90
      Height = 16
      Alignment = taRightJustify
      Caption = 'round corners'
      FocusControl = i_round_corners
    end
    object i_thickness: TEdit
      Left = 115
      Top = 19
      Width = 42
      Height = 24
      NumbersOnly = True
      TabOrder = 0
      Text = '0'
    end
    object UpDown_thickness: TUpDown
      Left = 157
      Top = 19
      Width = 15
      Height = 24
      Associate = i_thickness
      Min = 1
      Max = 0
      TabOrder = 1
    end
    object panel_foreground: TFPanel
      Left = 184
      Top = 16
      Width = 90
      Height = 30
      Cursor = crHandPoint
      Caption = 'BORDO'
      ParentBackground = False
      TabOrder = 2
      OnClick = color_click
    end
    object panel_background: TFPanel
      Left = 400
      Top = 16
      Width = 90
      Height = 30
      Cursor = crHandPoint
      Caption = 'FONDO'
      ParentBackground = False
      TabOrder = 4
      OnClick = color_click
    end
    object btn_colori_automatici: TFBitBtn
      Left = 500
      Top = 16
      Width = 89
      Height = 30
      Caption = 'auto'
      TabOrder = 5
      OnClick = btn_colori_automaticiClick
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        00020000000A2219164378594EB9A2776AECB28374FFA27669EC77584EB92119
        16450000000B0000000200000000000000000000000000000000000000020403
        03135D463F94BB9588FDDFC9C1FFF3EBE6FFFBF5F2FFF4EAE6FFDFC9C0FFBA92
        85FD5C453D960403031500000002000000000000000000000000000000096F55
        4AA6CBA99EFFF8F0ECFFF0D7B6FFE8C085FFFBF6F3FF45B7F9FF94D3F8FFF5F0
        ECFFC8A699FF6C5248A80000000A0000000100000000000000002C221F4BC39E
        91FFF8F2ECFFE9C48FFFE4B570FFE4B570FFFBF6F3FF1DAAFAFF1DA9FAFF4CBA
        F9FFF0EEEDFFC0998BFF2B201D4E0000000400000000000000007B6157B0E3D1
        CAFFF0D7B4FFE4B876FFE4B875FFE4B672FFFCF7F4FF1EADF9FF1EAAF9FF1EAA
        F9FF89CFF7FFE0CCC4FF785C53B1000000080000000000000000AD8A7CE7F7F2
        EEFFE7C28AFFE4BA7AFFE4B978FFE4B978FFFCF8F6FF1FADF9FF1FADF8FF1EAD
        F8FF3BB7F9FFF5EDEAFFA88475E80000000B0000000000000000BF9A8BFAFDFA
        F8FFFCF9F7FFFDF9F7FFFCF9F7FFFCF9F7FFFCF9F7FFFCF9F7FFFCF9F6FFFCF9
        F6FFFCF8F7FFFBF6F4FFBA9384FA0000000A0000000000000000B29284E7F8F3
        F0FF7594F1FF6185F0FF6085F0FF6085F0FFFDFAF8FF9D6641FF9C653FFFA777
        54FFFCF9F7FFF7F0ECFFAE8C7DE7000000090000000000000000836C62ACE8D8
        D1FFB4C5F6FF6588F0FF6488F1FF6387F1FFFDFBF9FFB48561FFFFFFFFFFBB8E
        6EFFB28567FFE6D5CDFF80685EAD00000006000000000000000030282544D2B5
        A6FFF9F7F6FF8DA7F3FF678AF0FF678AF0FFFDFBF9FFC0977AFFF9F6F3FFFCEE
        DBFFC29779FFB68B70FF45342CA4574035FF0000000000000000000000037765
        5C99DBC4B8FFFAF8F9FFBCCBF7FF88A2F2FFFDFCFBFFFDFCFBFFCCAA95FFFEFE
        FDFFFCEEDBFF998275FF5D453AFF60534CB80000000000000000000000010504
        040A64554F80D2B6AAFAEBDED7FFF9F5F2FFFEFEFDFFF8F5F2FFEBDED7FFCEB0
        9EFFB2A59FFF654C40FF9F8C82FF412E26FB0A06044E00000000000000000000
        00000000000225201D328D796EAEBCA092E5D2B3A4FFBCA092E68D776DAF4A3B
        339A6D5447FFC5B8B0FF483329FF8C6F61FF422E26FB0A060448000000000000
        000000000000000000010000000200000003000000030000000300000002755C
        4FFF6A5B53BC765C4EFDE6D9C7FF483329FF896C5EFF24140FE1000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000281F1A5A795E51FDE3D6C0FF4C372CFF614A3FE4000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000261E19516C5448EA6B5447EA21191548}
      color_background_down = clBtnFace
      color_background_up = clBtnFace
      show_shortcut = False
    end
    object cbx_trasparente: TCheckBox
      Left = 290
      Top = 23
      Width = 99
      Height = 17
      Caption = 'trasparente'
      TabOrder = 3
      OnClick = AAA_something_modified
    end
    object str_print_if: TEdit
      Left = 145
      Top = 83
      Width = 462
      Height = 24
      Hint = 
        'Se la condizione indicata non '#232' verificata, l'#39'oggetto non viene ' +
        'stampato'
      Anchors = [akLeft, akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
    end
    object cb_show: TFCombo
      Left = 316
      Top = 52
      Width = 291
      Height = 24
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 12
      TabOrder = 8
      AAA_dropdownwidth = 400
      AAA_NeedNotifyModification = False
      AAA_CanBeVoid = False
      AAA_CanBeInvalid = False
    end
    object i_round_corners: TEdit
      Left = 115
      Top = 52
      Width = 42
      Height = 24
      MaxLength = 1
      NumbersOnly = True
      TabOrder = 6
      Text = '0'
    end
    object updown_round_corners: TUpDown
      Left = 157
      Top = 52
      Width = 16
      Height = 24
      Associate = i_round_corners
      Max = 0
      TabOrder = 7
    end
  end
  object str_nome: TEdit
    Left = 122
    Top = 4
    Width = 215
    Height = 24
    TabOrder = 0
  end
  object btn_ok: TFBitBtn
    Left = 42
    Top = 383
    Width = 78
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'F9 OK'
    TabOrder = 3
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
    Left = 131
    Top = 383
    Width = 81
    Height = 25
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Annulla'
    TabOrder = 4
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
  object gbox_shift_pos: TFGroupBox
    Left = 14
    Top = 154
    Width = 621
    Height = 216
    Hint = 
      'Le formule qui specificate consentono di determinare'#13#10'(a RUNTIME' +
      ') la posizione di stampa dell'#39'oggetto.'#13#10'La posizione pu'#242' essere'#13 +
      #10'- ASSOLUTA: determinazione diretta della posizione di stampa'#13#10'-' +
      ' RELATIVA: spostamento rispetto alla posizione assegnata'#13#10#13#10'Le f' +
      'ormule devono dare un risultato NUMERICO'#13#10'che viene interpretato' +
      ' come un valore espresso in CENTRIMETRI'
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'posizione e dimensione (tutti i valori in CM)'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    DesignSize = (
      621
      216)
    object txt_formula_Xpos: TLabel
      Left = 202
      Top = 37
      Width = 45
      Height = 16
      Alignment = taRightJustify
      Caption = 'asse X'
      FocusControl = str_formula_Xpos
    end
    object txt_formula_Ypos: TLabel
      Left = 201
      Top = 65
      Width = 46
      Height = 16
      Alignment = taRightJustify
      Caption = 'asse Y'
      FocusControl = str_formula_Ypos
    end
    object txt_height: TLabel
      Left = 57
      Top = 123
      Width = 48
      Height = 16
      Alignment = taRightJustify
      Caption = 'altezza'
      FocusControl = i_height
    end
    object txt_width: TLabel
      Left = 40
      Top = 94
      Width = 65
      Height = 16
      Alignment = taRightJustify
      Caption = 'larghezza'
      FocusControl = i_width
    end
    object txt_top: TLabel
      Left = 17
      Top = 65
      Width = 88
      Height = 16
      Alignment = taRightJustify
      Caption = 'pos. verticale'
      FocusControl = i_top
    end
    object txt_left: TLabel
      Left = 56
      Top = 37
      Width = 49
      Height = 16
      Alignment = taRightJustify
      Caption = 'sinistra'
      FocusControl = i_left
    end
    object txt_formula_DX: TLabel
      Left = 182
      Top = 94
      Width = 65
      Height = 16
      Alignment = taRightJustify
      Caption = 'larghezza'
      FocusControl = str_formula_DX
    end
    object txt_formula_DY: TLabel
      Left = 199
      Top = 123
      Width = 48
      Height = 16
      Alignment = taRightJustify
      Caption = 'altezza'
      FocusControl = str_formula_DY
    end
    object sep: TBevel
      Left = 20
      Top = 152
      Width = 582
      Height = 2
      Anchors = [akLeft, akTop, akRight]
    end
    object txt_formula_header: TMyLabel
      Left = 306
      Top = 15
      Width = 115
      Height = 16
      Caption = 'formula di calcolo'
    end
    object txt_tipo_formula_header: TMyLabel
      Left = 518
      Top = 15
      Width = 77
      Height = 16
      Caption = 'tipo formula'
    end
    object str_formula_Xpos: TEdit
      Left = 252
      Top = 33
      Width = 242
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      TabOrder = 4
    end
    object cb_formula_Xpos: TComboBox
      Left = 500
      Top = 33
      Width = 113
      Height = 24
      Style = csDropDownList
      Anchors = [akTop, akRight]
      TabOrder = 5
    end
    object str_formula_Ypos: TEdit
      Left = 252
      Top = 61
      Width = 242
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      TabOrder = 6
    end
    object cb_formula_Ypos: TComboBox
      Left = 500
      Top = 61
      Width = 113
      Height = 24
      Style = csDropDownList
      Anchors = [akTop, akRight]
      TabOrder = 7
    end
    object i_height: TEdit
      Left = 115
      Top = 119
      Width = 57
      Height = 24
      TabOrder = 3
    end
    object i_width: TEdit
      Left = 115
      Top = 90
      Width = 57
      Height = 24
      TabOrder = 2
    end
    object i_top: TEdit
      Left = 115
      Top = 61
      Width = 57
      Height = 24
      TabOrder = 1
    end
    object i_left: TEdit
      Left = 115
      Top = 33
      Width = 57
      Height = 24
      TabOrder = 0
    end
    object str_formula_DX: TEdit
      Left = 252
      Top = 90
      Width = 242
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      TabOrder = 8
    end
    object cb_formula_DX_type: TComboBox
      Left = 500
      Top = 90
      Width = 113
      Height = 24
      Style = csDropDownList
      Anchors = [akTop, akRight]
      TabOrder = 9
    end
    object str_formula_DY: TEdit
      Left = 252
      Top = 119
      Width = 242
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      TabOrder = 10
    end
    object cb_formula_DY_type: TComboBox
      Left = 500
      Top = 119
      Width = 113
      Height = 24
      Style = csDropDownList
      Anchors = [akTop, akRight]
      TabOrder = 11
    end
    object cbx_footer: TCheckBox
      Left = 21
      Top = 166
      Width = 336
      Height = 17
      Hint = 
        'La posizione dell'#39'oggetto in fase di disegno rimane legata al fo' +
        'ndo della pagina'#13#10'Serve per facilitare la sistemazione di report' +
        's su stampanti con lunghezza di pagina differente.'#13#10'Questa opzio' +
        'ne non influenza la posizione dell'#39'oggetto a runtime.'
      Caption = 'posizione legata al fondo pagina (a design-time)'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 12
    end
    object cbx_posizione_fissa: TCheckBox
      Left = 21
      Top = 190
      Width = 268
      Height = 17
      Hint = 
        'La posizione dell'#39'oggetto non viene influenzata dagli oggetti so' +
        'prastanti'
      Caption = 'posizione fissa nella pagina/sezione'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 13
    end
    object cbx_dimensione_verticale_fissa: TCheckBox
      Left = 297
      Top = 190
      Width = 197
      Height = 17
      Hint = 
        'La dimensione verticale dell'#39'oggetto non viene modificata'#13#10'a seg' +
        'uito del ridimensionamento di oggetti che si trovano'#13#10'all'#39'intern' +
        'o della sua altezza'
      Caption = 'dimensione verticale fissa'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 14
    end
    object btn_legami: TButton
      Left = 435
      Top = 163
      Width = 178
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Lega&mi comunitari'
      TabOrder = 15
      OnClick = btn_legamiClick
    end
  end
end
