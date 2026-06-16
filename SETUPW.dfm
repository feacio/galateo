object window_setup: Twindow_setup
  Left = 10
  Top = 141
  HelpContext = 124
  ActiveControl = i_mm_width
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Misurazione dimensione reale video'
  ClientHeight = 423
  ClientWidth = 592
  Color = clBlack
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Panel: TPanel
    Left = 22
    Top = 12
    Width = 547
    Height = 341
    Color = clYellow
    TabOrder = 0
    object Label1: TLabel
      Left = 60
      Top = 266
      Width = 388
      Height = 48
      Alignment = taCenter
      Caption = 
        'La misurazione della dimensione reale del video serve per ottene' +
        're a video una riproduzione fedele anche nelle dimensioni di ci'#242 +
        ' che sar'#224' effettivamente stampato.'
      Transparent = True
      WordWrap = True
    end
    object Label9: TLabel
      Left = 90
      Top = 153
      Width = 262
      Height = 16
      Caption = 'quanti mm '#232' alto questo riquadro giallo?'
    end
    object Label10: TLabel
      Left = 81
      Top = 127
      Width = 271
      Height = 16
      Caption = 'quanti mm '#232' largo questo riquadro giallo?'
    end
    object Label2: TLabel
      Left = 94
      Top = 40
      Width = 185
      Height = 16
      Caption = 'impostazioni standard ------->'
    end
    object i_mm_height: TEdit
      Left = 358
      Top = 149
      Width = 75
      Height = 22
      TabOrder = 1
    end
    object i_mm_width: TEdit
      Left = 358
      Top = 121
      Width = 75
      Height = 22
      TabOrder = 0
    end
    object cb_standard: TComboBox
      Left = 288
      Top = 36
      Width = 189
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 2
      OnChange = cb_standardChange
    end
  end
  object btn_ok: TButton
    Left = 202
    Top = 372
    Width = 89
    Height = 33
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btn_okClick
  end
  object btn_cancel: TButton
    Left = 302
    Top = 372
    Width = 89
    Height = 33
    Cancel = True
    Caption = 'Annulla'
    TabOrder = 2
    OnClick = btn_cancelClick
  end
end
