object aggiornamento: Taggiornamento
  Left = 275
  Top = 94
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'GALATEO - Aggiornamento archivio'
  ClientHeight = 164
  ClientWidth = 464
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object txt_filename: TLabel
    Left = 14
    Top = 16
    Width = 165
    Height = 16
    Caption = 'File  magazzino PROLOG'
  end
  object shp_sotto: TShape
    Left = 22
    Top = 56
    Width = 421
    Height = 49
    Shape = stEllipse
  end
  object shp_sopra: TShape
    Left = 22
    Top = 56
    Width = 65
    Height = 49
    Pen.Mode = pmBlack
    Shape = stEllipse
  end
  object btn_exec: TButton
    Left = 136
    Top = 118
    Width = 89
    Height = 29
    Caption = 'Aggiorna!'
    Default = True
    TabOrder = 0
    OnClick = btn_execClick
  end
  object str_filename: TEdit
    Left = 184
    Top = 12
    Width = 205
    Height = 24
    CharCase = ecLowerCase
    TabOrder = 1
  end
  object btn_filename: TBitBtn
    Left = 392
    Top = 12
    Width = 39
    Height = 23
    TabOrder = 2
    OnClick = btn_filenameClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      0400000000000001000000000000000000001000000010000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
      333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
      0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
      07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
      07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
      0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
      33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
      B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
      3BB33773333773333773B333333B3333333B7333333733333337}
    NumGlyphs = 2
  end
  object Panel: TPanel
    Left = 143
    Top = 70
    Width = 177
    Height = 19
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clWindow
    Ctl3D = False
    ParentCtl3D = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 3
    object txt_progression: TLabel
      Left = 0
      Top = 0
      Width = 175
      Height = 17
      Align = alClient
      Alignment = taCenter
      Caption = '%'
    end
  end
  object btn_close: TButton
    Left = 239
    Top = 118
    Width = 89
    Height = 29
    Cancel = True
    Caption = 'Chiudi'
    TabOrder = 4
    OnClick = btn_closeClick
  end
  object opendlg: TOpenDialog
    Ctl3D = False
    Filter = 'tutti i files|*.*'
    Options = [ofPathMustExist, ofFileMustExist]
    Left = 432
    Top = 10
  end
  object tbl: TTable
    Exclusive = True
    TableType = ttDBase
    UpdateMode = upWhereKeyOnly
    Left = 32
    Top = 134
  end
  object qry: TQuery
    AutoCalcFields = False
    Left = 62
    Top = 134
  end
  object db_update: TDatabase
    DatabaseName = 'db_update'
    DriverName = 'ODBC_GALATEO'
    LoginPrompt = False
    Params.Strings = (
      'USER NAME=GALATEO_OPERATOR'
      'ODBC DSN=GALATEO'
      'OPEN MODE=READ/WRITE'
      'SCHEMA CACHE SIZE=8'
      'SQLQRYMODE='
      'LANGDRIVER=intl'
      'SQLPASSTHRU MODE=SHARED AUTOCOMMIT'
      'PASSWORD=GALATEO_PASSWORD')
    SessionName = 'Default'
    TransIsolation = tiDirtyRead
    Left = 2
    Top = 134
  end
end
