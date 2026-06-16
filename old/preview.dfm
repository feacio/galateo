object dlg_preview: Tdlg_preview
  Left = 274
  Top = 133
  HelpContext = 101
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'GALATEO - wysiwyg'
  ClientHeight = 167
  ClientWidth = 255
  Color = clWindow
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
  object panel: TPanel
    Left = 24
    Top = 12
    Width = 185
    Height = 93
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clWindow
    TabOrder = 0
    object pb: TPaintBox
      Left = 0
      Top = 0
      Width = 183
      Height = 91
      Align = alClient
      OnPaint = pbPaint
    end
  end
  object btn_close: TButton
    Left = 76
    Top = 124
    Width = 111
    Height = 25
    Hint = 
      'Se avessi pre-visto tutto questo / date cause e pretesto / ed ev' +
      'entuali conclusioni ...'
    Cancel = True
    Caption = 'ho pre-visto'
    Default = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = btn_closeClick
  end
end
