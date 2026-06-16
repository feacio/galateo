unit Sqlcomm;

{$ifdef DLL} *** {$endif}

{$I defines}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, Math, Data.DB,
	proc, Gdich, FBitBtn, FDB;

type
  Tsql_comm = class(TForm)
	 Label1: TLabel;
	 cb_campi: TListBox;
	 txt_campi: TLabel;
    txt_functions: TLabel;
	 cb_functions: TListBox;
    btn_cancel: TFBitBtn;
	 cb_sql: TComboBox;
    btn_exec: TFBitBtn;
	 procedure FormCreate(Sender : TObject);
	 procedure btn_execClick(Sender : TObject);
	 procedure btn_cancelClick(Sender : TObject);
	 procedure cb_campiDblClick(Sender : TObject);
	 procedure cb_functionsDblClick(Sender : TObject);
  private
		tbl : TFTable;
		pt_str_result : ^string;
  public
		constructor xcreate(father : TForm;tbl : TFTable;var str_result : string);
  end;

var
  sql_comm: Tsql_comm;

implementation

uses Fcommons, FXStrings, FStrings, FRegistry,
	galateo_debug;

{$R *.DFM}

const
	INI_LAST_SQL_CAPTION = 'comandi SQL';
	INI_LAST_SQL_COMMAND = 'comando #';
	NUM_LAST_SQLS = 24;	// ultimi n comandi

constructor Tsql_comm.xcreate(father : TForm;tbl : TFTable;var str_result : string);
begin
	self.tbl := tbl;
	pt_str_result := @str_result;
	inherited create(father)
end;

procedure Tsql_comm.FormCreate(Sender : TObject);
var
	i : smallint;
	s : string;
	ws : WideString;
	p : LPSTR;
begin
	if (pt_str_result^ <> '') then cb_sql.Text := lowercase(pt_str_result^);
	pt_str_result^ := '';

	p := stralloc(256);
	for i := 1 to NUM_LAST_SQLS do begin
//		Windows.GetPrivateProfileString(INI_LAST_SQL_CAPTION, asciiz(INI_LAST_SQL_COMMAND + inttostr(i)), '', p, 256, FILE_INI);
		ws := INI_LAST_SQL_COMMAND + inttostr(i);
		Windows.GetPrivateProfileString(INI_LAST_SQL_CAPTION, @ws, '', p, 256, FILE_INI);
		if (strlen(p) = 0) then break;
		cb_sql.Items.add(lowercase(strpas(p)))
	end;
	strdispose(p);

	tbl.Active := TRUE;
	for i := 0 to tbl.fieldcount-1 do begin
		s := lowercase(tbl.fields[i].fieldname);
		if (tbl.indexdefs.indexof(s) <> -1) then s := uppercase(s) else s := lowercase(s);
		cb_campi.Items.add(s)
	end;
	tbl.Active := FALSE
end;

procedure Tsql_comm.btn_cancelClick(Sender : TObject);
begin close end;

procedure Tsql_comm.cb_campiDblClick(Sender : TObject);
begin {cb_sql.seltext := cb_campi.Items.strings[cb_campi.ItemIndex]} end;

procedure Tsql_comm.cb_functionsDblClick(Sender : TObject);
begin {cb_sql.seltext := cb_functions.Items.strings[cb_functions.ItemIndex]} end;

procedure Tsql_comm.btn_execClick(Sender : TObject);
var i : integer;
begin
	pt_str_result^ := lowercase(togliblanks(cb_sql.Text));
	Windows.WritePrivateProfileString(INI_LAST_SQL_CAPTION, NIL, '', FILE_INI);

	// scrittura ultimi n comandi
	WritePrivateProfileString(INI_LAST_SQL_CAPTION, INI_LAST_SQL_COMMAND + inttostr(1), pt_str_result^, FILE_INI);
	i := cb_sql.Items.indexof(pt_str_result^);
	if (i <> -1) then cb_sql.Items.delete(i);
	for i := 0 to min(NUM_LAST_SQLS-2, cb_sql.Items.Count-1) do begin
		WritePrivateProfileString(INI_LAST_SQL_CAPTION, INI_LAST_SQL_COMMAND + inttostr(i+2), cb_sql.Items.strings[i], FILE_INI);
		cb_sql.Items.add(cb_sql.Items.strings[i])
	end;
	close
end;

initialization
	galateo_initialization_debug('SQLcomm')
finalization
	galateo_finalization_debug('SQLcomm')
end.
