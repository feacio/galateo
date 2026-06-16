object running_window: Trunning_window
  Left = 746
  Top = 352
  HelpContext = 114
  ActiveControl = i_num_labels
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Stampa'
  ClientHeight = 177
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object panel_buttons: TPanel
    Left = 0
    Top = 55
    Width = 425
    Height = 122
    BorderStyle = bsSingle
    ParentColor = True
    TabOrder = 0
    object pre_in_stampa_txt: TLabel
      Left = 9
      Top = 54
      Width = 133
      Height = 16
      Caption = 'si trovano in stampa'
    end
    object post_in_stampa_txt: TLabel
      Left = 205
      Top = 54
      Width = 55
      Height = 16
      Caption = 'etichette'
    end
    object txt_foglio: TLabel
      Left = 270
      Top = 54
      Width = 36
      Height = 16
      Caption = 'foglio'
    end
    object btn_recalcola: TButton
      Left = 213
      Top = 14
      Width = 79
      Height = 27
      Caption = '&ricalcola'
      TabOrder = 2
      OnClick = btn_recalcolaClick
    end
    object btn_print: TButton
      Left = 49
      Top = 14
      Width = 79
      Height = 27
      Caption = '&stampa'
      Default = True
      TabOrder = 0
      OnClick = btn_printClick
    end
    object btn_close: TButton
      Left = 131
      Top = 14
      Width = 79
      Height = 27
      Cancel = True
      Caption = 'chiudi'
      TabOrder = 1
      OnClick = btn_closeClick
    end
    object btn_ff: TButton
      Left = 5
      Top = 84
      Width = 97
      Height = 27
      Caption = 'sputa &foglio'
      Enabled = False
      TabOrder = 4
      OnClick = btn_ffClick
    end
    object i_in_stampa: TEdit
      Left = 147
      Top = 50
      Width = 55
      Height = 24
      TabStop = False
      Enabled = False
      TabOrder = 6
    end
    object btn_reset_print: TButton
      Left = 105
      Top = 84
      Width = 161
      Height = 27
      Caption = 'svuota &coda di stampa'
      TabOrder = 5
      OnClick = btn_reset_printClick
    end
    object btn_preview: TButton
      Left = 295
      Top = 14
      Width = 79
      Height = 27
      Caption = '&preview'
      TabOrder = 3
      OnClick = btn_previewClick
    end
    object btn_print_sel: TButton
      Left = 269
      Top = 84
      Width = 148
      Height = 27
      Caption = 'seleziona stampante'
      TabOrder = 7
      OnClick = btn_print_selClick
    end
  end
  object panel_vars: TPanel
    Left = 0
    Top = 0
    Width = 425
    Height = 55
    BevelOuter = bvNone
    BorderStyle = bsSingle
    ParentColor = True
    TabOrder = 1
    object txt_num_labels: TLabel
      Left = 24
      Top = 20
      Width = 173
      Height = 16
      Caption = '&n'#176' di etichette da stampare'
      FocusControl = i_num_labels
    end
    object i_num_labels: TEdit
      Left = 202
      Top = 16
      Width = 127
      Height = 24
      MaxLength = 4
      TabOrder = 0
      Text = '1'
    end
  end
  object panel_function: TPanel
    Left = 376
    Top = 8
    Width = 35
    Height = 43
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clAppWorkSpace
    TabOrder = 2
  end
end
