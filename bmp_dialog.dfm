object bmps: Tbmps
  Left = 986
  Top = 178
  HelpContext = 117
  BorderIcons = [biSystemMenu]
  Caption = 'Caratteristiche immagine'
  ClientHeight = 448
  ClientWidth = 341
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  DesignSize = (
    341
    448)
  PixelsPerInch = 96
  TextHeight = 16
  object txt_size_y: TLabel
    Left = 23
    Top = 67
    Width = 79
    Height = 16
    Alignment = taRightJustify
    Caption = 'altezza (cm)'
    FocusControl = r_size_y
  end
  object txt_size_x: TLabel
    Left = 6
    Top = 41
    Width = 96
    Height = 16
    Alignment = taRightJustify
    Caption = 'larghezza (cm)'
    FocusControl = r_size_x
  end
  object txt_object_name: TLabel
    Left = 15
    Top = 12
    Width = 88
    Height = 16
    Alignment = taRightJustify
    Caption = 'nome oggetto'
    FocusControl = str_object_name
  end
  object txt_top: TLabel
    Left = 169
    Top = 67
    Width = 36
    Height = 16
    Alignment = taRightJustify
    Caption = 'pos V'
    FocusControl = r_top
  end
  object txt_left: TLabel
    Left = 167
    Top = 41
    Width = 38
    Height = 16
    Alignment = taRightJustify
    Caption = 'pos H'
    FocusControl = r_left
  end
  object txt_object: TLabel
    Left = 275
    Top = 430
    Width = 63
    Height = 16
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = 'txt_object'
    ExplicitLeft = 282
    ExplicitTop = 519
  end
  object r_size_x: TEdit
    Left = 107
    Top = 35
    Width = 52
    Height = 24
    TabOrder = 1
  end
  object r_size_y: TEdit
    Left = 107
    Top = 63
    Width = 52
    Height = 24
    TabOrder = 2
  end
  object btn_original_size: TButton
    Left = 4
    Top = 118
    Width = 146
    Height = 25
    Hint = 
      'Torna alla dimensione originale dell'#39'immagine come caricata dal ' +
      'disco'
    Caption = 'dimensione originale'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnClick = btn_original_sizeClick
  end
  object btn_ok: TFBitBtn
    Left = 48
    Top = 418
    Width = 78
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'F9 OK'
    TabOrder = 13
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
    Left = 137
    Top = 418
    Width = 81
    Height = 25
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Annulla'
    TabOrder = 14
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
  object str_object_name: TEdit
    Left = 107
    Top = 7
    Width = 174
    Height = 24
    TabOrder = 0
  end
  object cbx_posizione_fissa: TCheckBox
    Left = 26
    Top = 354
    Width = 221
    Height = 17
    Hint = 
      'La posizione dell'#39'oggetto non viene influenzata dagli oggetti so' +
      'prastanti'
    Anchors = [akLeft, akBottom]
    Caption = 'posizione fissa nella pagina'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    OnClick = generic_enable_ctrls
  end
  object cbx_footer: TCheckBox
    Left = 26
    Top = 374
    Width = 237
    Height = 17
    Hint = 
      'La posizione dell'#39'oggetto in fase di disegno rimane legata al fo' +
      'ndo della pagina'#13#10'Serve per facilitare la sistemazione di report' +
      's su stampanti con lunghezza di pagina differente.'#13#10'Questa opzio' +
      'ne non influenza la posizione dell'#39'oggetto a runtime.'
    Anchors = [akLeft, akBottom]
    Caption = 'posizione legata al fondo pagina'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
    OnClick = generic_enable_ctrls
  end
  object r_left: TEdit
    Left = 210
    Top = 35
    Width = 52
    Height = 24
    TabOrder = 3
  end
  object r_top: TEdit
    Left = 210
    Top = 63
    Width = 52
    Height = 24
    TabOrder = 4
  end
  object cbx_proporzioni: TCheckBox
    Left = 21
    Top = 95
    Width = 248
    Height = 17
    Hint = 
      'durante il ridimensionamento vengono preservate le proporzioni d' +
      'ell'#39'immagine'#13#10'serve esclusivamente durante l'#39'editing del report,' +
      ' non a run-time'
    Caption = 'mantieni proporzioni (design-time)'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = generic_enable_ctrls
  end
  object btn_load: TBitBtn_fede
    Left = 154
    Top = 118
    Width = 69
    Height = 25
    Caption = 'carica'
    TabOrder = 7
    OnClick = btn_loadClick
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
    Spacing = 3
    color_background_down = clBtnFace
    color_background_up = clBtnFace
    show_shortcut = False
  end
  object btn_save: TBitBtn_fede
    Left = 226
    Top = 118
    Width = 62
    Height = 25
    Caption = 'salva'
    TabOrder = 8
    OnClick = btn_saveClick
    Glyph.Data = {
      E6000000424DE60000000000000076000000280000000E0000000E0000000100
      0400000000007000000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00700000000000
      0000088000000770800008800000077080000880000007708000088000000000
      8000088888888888800008800000000880000807777777708000080777777770
      8000080777777770800008077777777080000807777777700000080777777770
      70000000000000000000}
    Spacing = 3
    color_background_down = clBtnFace
    color_background_up = clBtnFace
    show_shortcut = False
  end
  object cbx_consenti_sovrapposizione: TCheckBox
    Left = 26
    Top = 394
    Width = 258
    Height = 17
    Hint = 
      '[DESIGN-TIME only]'#13#10'non attiva il controllo di sovrapposizione c' +
      'on oggetti simili per natura, dimensioni e posizione'
    Anchors = [akLeft, akBottom]
    Caption = 'disattiva controllo sovrapposizione'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 12
    OnClick = generic_enable_ctrls
  end
  object pc_options: TFPageControl
    Left = 3
    Top = 149
    Width = 334
    Height = 199
    ActivePage = page_formule_posizione
    Anchors = [akLeft, akTop, akRight, akBottom]
    OwnerDraw = True
    TabOrder = 9
    AAA_AutoHighLight = False
    AAA_OpenOnFirstPage = True
    object page_visualizzazione: TTabSheet
      Caption = 'visualizzazione'
      DesignSize = (
        326
        168)
      object txt_show: TLabel
        Left = 15
        Top = 31
        Width = 65
        Height = 16
        Caption = 'F6 mostra'
        FocusControl = cb_show
      end
      object txt_print_if: TLabel
        Left = 15
        Top = 80
        Width = 112
        Height = 16
        Caption = 'F11 stampa se ...'
        FocusControl = str_print_if
      end
      object cbx_sfondo_design_time: TCheckBox
        Left = 16
        Top = 7
        Width = 301
        Height = 17
        Hint = 
          'L'#39'immagine NON viene stampata ma  serve solamente'#13#10'come sfondo p' +
          'er le operazioni di creazione e visualizzazione del report'
        Caption = 'sfondo per costruzione report (design time)'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = generic_enable_ctrls
      end
      object cb_show: TFCombo
        Left = 14
        Top = 47
        Width = 299
        Height = 24
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        DropDownCount = 12
        TabOrder = 1
        AAA_dropdownwidth = 400
        AAA_NeedNotifyModification = False
        AAA_CanBeVoid = False
        AAA_CanBeInvalid = False
      end
      object str_print_if: TEdit
        Left = 14
        Top = 98
        Width = 299
        Height = 24
        Hint = 
          'Se la condizione indicata non '#232' verificata, l'#39'oggetto non viene ' +
          'stampato'
        Anchors = [akLeft, akTop, akRight]
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
    end
    object page_dynamic_load: TTabSheet
      Caption = 'runtime'
      ImageIndex = 1
      DesignSize = (
        326
        168)
      object txt_dynamic_header: TMyLabel
        Left = 0
        Top = 0
        Width = 326
        Height = 16
        Align = alTop
        Alignment = taCenter
        Caption = 'opzioni di caricamento dinamico immagine'
        Color = 14155735
        ParentColor = False
        Transparent = False
        ExplicitWidth = 278
      end
      object txt_immagine_dinamica: TLabel
        Left = 4
        Top = 28
        Width = 64
        Height = 16
        Alignment = taRightJustify
        Caption = 'immagine'
        FocusControl = str_immagine_dinamica
      end
      object str_immagine_dinamica: TEdit
        Left = 73
        Top = 24
        Width = 246
        Height = 24
        Hint = 
          'nome del file dell'#39'immagine da caricare'#13#10'pu'#242' contenere variabili' +
          ' che saranno sostituite in esecuzione'
        Anchors = [akLeft, akTop, akRight]
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object cbx_autosize_dinamica: TCheckBox
        Left = 28
        Top = 53
        Width = 221
        Height = 17
        Hint = 
          'la dimensione dell'#39'oggetto segue la dimensione dell'#39'immagine car' +
          'icata'
        Caption = 'ridimensionamento automatico'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = generic_enable_ctrls
      end
      object cbx_cannot_exceed_original_size: TCheckBox
        Left = 28
        Top = 70
        Width = 187
        Height = 17
        Hint = 
          'l'#39'immagine non pu'#242' superare la dimensione dell'#39'oggetto;'#13#10'se la s' +
          'upera viene '#39'scalata'#39' nel rispetto delle proporzioni'
        Caption = 'dimensione MAX fissata'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = generic_enable_ctrls
      end
      object rb_autoresize_align_horz: TRadioGroup
        Left = 5
        Top = 88
        Width = 161
        Height = 34
        Caption = 'allineam. orizzont.'
        Columns = 3
        Items.Strings = (
          'sx'
          'cen'
          'dx')
        TabOrder = 3
      end
      object rb_autoresize_align_vert: TRadioGroup
        Left = 175
        Top = 88
        Width = 156
        Height = 34
        Caption = 'allineam. verticale'
        Columns = 3
        Items.Strings = (
          'su'
          'cen'
          'gi'#249)
        TabOrder = 4
      end
      object cbx_image_dinamica_must_exist: TCheckBox
        Left = 28
        Top = 160
        Width = 193
        Height = 17
        Hint = 'se l'#39'immagine non esiste la stampa viene interrotta'
        Caption = 'l'#39'immagine DEVE esistere'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = generic_enable_ctrls
      end
      object cbx_move_obj_sottostanti: TCheckBox
        Left = 28
        Top = 126
        Width = 209
        Height = 17
        Hint = 
          'in caso di ridimensionamento dell'#39'oggetto, gli oggetti sottostan' +
          'ti vengono spostati conseguentemente'
        Caption = 'sposta gli oggetti sottostanti'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        OnClick = generic_enable_ctrls
      end
      object cbx_image_dinamica_should_exist: TCheckBox
        Left = 28
        Top = 142
        Width = 189
        Height = 17
        Hint = 'se l'#39'immagine non esiste il programma emette un messaggio'
        Caption = 'messaggio se non esiste'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        OnClick = generic_enable_ctrls
      end
    end
    object page_formule_posizione: TTabSheet
      Caption = 'posizione'
      ImageIndex = 2
      DesignSize = (
        326
        168)
      object txt_formula_Xpos: TLabel
        Left = 12
        Top = 31
        Width = 45
        Height = 16
        Alignment = taRightJustify
        Caption = 'asse X'
        FocusControl = str_formula_Xpos
      end
      object txt_formula_Xpos_type: TLabel
        Left = 182
        Top = 31
        Width = 24
        Height = 16
        Anchors = [akTop, akRight]
        Caption = 'tipo'
        FocusControl = cb_formula_Xpos
        ExplicitLeft = 190
      end
      object txt_formula_Ypos: TLabel
        Left = 11
        Top = 57
        Width = 46
        Height = 16
        Alignment = taRightJustify
        Caption = 'asse Y'
        FocusControl = str_formula_Ypos
      end
      object txt_formula_Ypos_type: TLabel
        Left = 182
        Top = 57
        Width = 24
        Height = 16
        Anchors = [akTop, akRight]
        Caption = 'tipo'
        FocusControl = cb_formula_Ypos
        ExplicitLeft = 190
      end
      object txt_posizione_header: TLabel
        Left = 0
        Top = 0
        Width = 326
        Height = 16
        Align = alTop
        Alignment = taCenter
        Caption = 'valori in CM'
        Color = 12910591
        FocusControl = str_formula_Xpos
        ParentColor = False
        Transparent = False
        ExplicitWidth = 78
      end
      object str_formula_Xpos: TEdit
        Left = 62
        Top = 27
        Width = 116
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        TabOrder = 0
      end
      object cb_formula_Xpos: TComboBox
        Left = 210
        Top = 27
        Width = 113
        Height = 24
        Style = csDropDownList
        Anchors = [akTop, akRight]
        TabOrder = 1
      end
      object str_formula_Ypos: TEdit
        Left = 62
        Top = 53
        Width = 116
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        TabOrder = 2
      end
      object cb_formula_Ypos: TComboBox
        Left = 210
        Top = 53
        Width = 113
        Height = 24
        Style = csDropDownList
        Anchors = [akTop, akRight]
        TabOrder = 3
      end
    end
  end
end
