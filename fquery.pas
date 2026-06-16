unit Fquery;	// Free QUERY module 

{$I defines}

{ *** definizione permessi di utilizzo *** }
{$ifdef WF_DLL} {$define OK} {$endif}
{$ifdef GALATEO} {$ifndef DLL} {$define OK} {$endif} {$endif}
{$ifndef OK} not good, sir {$endif}
{ **************************************** }

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, DB, DBTables,
	commons, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDB;

procedure free_query(father : TForm;str_db_name : str_SQL_type); {export;}

type
  Tdlg_free_query = class(TForm)
	 Panel1: TPanel;
	 Panel2: TPanel;
	 Label1: TLabel;
	 sql: TMemo;
	 btn_ok: TBitBtn;
	 btn_check_syntax: TBitBtn;
	 btn_cancel: TBitBtn;
	 db_fquery: TFDatabase;
	 Image1: TImage;
	 Panel5: TPanel;
	 Panel3: TPanel;
	 Label2: TLabel;
	 lb_tables: TListBox;
	 Panel4: TPanel;
	 Label3: TLabel;
	 lb_fields: TListBox;
	 qry: TFquery;
    cbx_update: TCheckBox;
	 procedure FormCreate(Sender : TObject);
	 procedure btn_okClick(Sender : TObject);
	 procedure btn_check_syntaxClick(Sender : TObject);
	 procedure btn_cancelClick(Sender : TObject);
	 procedure lb_tablesClick(Sender : TObject);
	 procedure FormKeyDown(Sender: TObject;var Key: Word;Shift: TShiftState);
  private
		str_db_name : str_SQL_type;
		bo_dont_open : boolean;
		i_user_id : integer;	{ id dello user nella table SYSUSERPERM }
		function check_query(bo_dont_show_msg_if_ok,bo_can_update : boolean) : boolean;
		procedure load_tables;
		procedure check_proc;
		procedure exec_proc;
		procedure set_table(str_table : str_SQL_type);
  public
		constructor xcreate(f_father : TForm;str_db_name : str_SQL_type);
  end;

implementation

uses FXStrings, FStrings, FMessage, FSQLsoft, 
	exec_qry, proc;

{$R *.DFM}

const
	MBOX_CAPTION = 'Creazione queries';
	STR_USER_NAME = 'jop';

	SYSTBL_USERS = 'SYSUSERPERM';
	SYSTBL_USERS_STR_USER_NAME = 'user_name';
	SYSTBL_USERS_I_ID = 'user_id';

	SYSTBL_TABLES = 'SYSTABLE';
	SYSTBL_TABLES_STR_NAME = 'table_name';
	SYSTBL_TABLES_I_USER_ID = 'creator';
	SYSTBL_TABLES_I_TABLE_ID = 'table_id';

	SYSTBL_COLUMNS = 'SYSCOLUMN';
	SYSTBL_COL_I_TABLE_ID = 'table_id';
	SYSTBL_COL_STR_COLUMN_NAME = 'column_name';

procedure free_query(father : TForm;str_db_name : str_SQL_type);
var dlg_query: Tdlg_free_query;
begin
	dlg_query := Tdlg_free_query.xcreate(father,str_db_name);
	dlg_query.showmodal;dlg_query.release
end;

constructor Tdlg_free_query.xcreate(f_father : TForm;str_db_name : str_SQL_type);
begin
	self.str_db_name := str_db_name;
	inherited create(f_father);
	if (bo_dont_open) then abort
end;

procedure Tdlg_free_query.FormCreate(Sender : TObject);
begin
	try
		if (str_db_name = '') then begin	{ no external database, use the internal one }
			str_db_name := db_fquery.DatabaseName;
{			db_fquery.aliasname := str_alias; }
{			set_alias(db_fquery,self); }
			db_fquery.connected := TRUE
		end
		else begin
			{$ifdef DEBUG} db_fquery.aliasname := '' {$endif}	{ lo disabilito completamente }
		end;
		load_tables;
		bo_dont_open := FALSE
	except
		bo_dont_open := TRUE
	end
end;

procedure Tdlg_free_query.btn_okClick(Sender : TObject);
begin
	if NOT check_query(TRUE,cbx_update.Checked) then exit; {}
	exec_query(self,str_db_name,sql.Text,FALSE,cbx_update.Checked)
end;

procedure Tdlg_free_query.btn_check_syntaxClick(Sender : TObject);
begin check_query(FALSE,cbx_update.Checked) end;

procedure Tdlg_free_query.btn_cancelClick(Sender : TObject);
begin close end;

procedure Tdlg_free_query.load_tables;
// carica la listbox delle tables
var i_error : integer;
begin
	i_user_id := get_integer_where(str_db_name, SYSTBL_USERS, SYSTBL_USERS_I_ID, SYSTBL_USERS_STR_USER_NAME + '=' + str2SQL(STR_USER_NAME), i_error);
	if (i_error <> 0) OR (i_user_id = 0) then begin
		MessageBBox(handle, 'Impossibile ottenere l''ID dello user', MBOX_CAPTION, MB_ICONSTOP);
		exit
	end;

	if NOT load_SQL_items(str_db_name,
		'SELECT '+SYSTBL_TABLES_STR_NAME+' FROM ' + SYSTBL_TABLES +
		' WHERE ' + SYSTBL_TABLES_I_USER_ID+'='+inttostr(i_user_id),
		SYSTBL_TABLES_STR_NAME,lb_tables.Items,FALSE)
	then begin
		MessageBBox(handle,'Impossibile leggere le tabelle disponibili sul database',MBOX_CAPTION,MB_ICONSTOP);
		exit
	end
end;

procedure Tdlg_free_query.set_table(str_table : str_SQL_type);
// imposta la table specificata
var i_table_id,i_error : integer;
begin
	i_table_id := get_integer_where(str_db_name, SYSTBL_TABLES, SYSTBL_TABLES_I_TABLE_ID, SYSTBL_TABLES_STR_NAME + '=' + str2SQL(str_table), i_error);
	if (i_table_id = 0) OR (i_error <> 0) then begin
		MessageBBox(handle, 'Tabella <' + str_table + '> non riconosciuta', MBOX_CAPTION, MB_ICONSTOP);
		exit
	end;

	if NOT load_SQL_items(str_db_name, 'SELECT ' + SYSTBL_COL_STR_COLUMN_NAME + ' FROM ' + SYSTBL_COLUMNS +
		' WHERE ' + SYSTBL_COL_I_TABLE_ID + '=' + inttostr(i_table_id), SYSTBL_COL_STR_COLUMN_NAME, lb_fields.Items, FALSE)
	then begin
		MessageBBox(handle, 'Impossibile leggere le tabelle disponibili sul database', MBOX_CAPTION, MB_ICONSTOP);
		exit
	end
end;

procedure Tdlg_free_query.lb_tablesClick(Sender : TObject);
var i : integer;
begin
	i := lb_tables.ItemIndex;
	if i <> -1 then set_table(lb_tables.Items[i])
end;

function Tdlg_free_query.check_query(bo_dont_show_msg_if_ok,bo_can_update : boolean) : boolean;
{ esegue una verifica della query; rende TRUE se la query è eseguibile }
{ la funzione, bella e perfetta, inspiegabilmente pianta il sistema in caso di
  query errate; incapace di trovare il motivo di questo anomalo comportamento,
  preferisco aggirare il problema AAAAAAAAAAAAAAAAAAGGGGGGGGGHHHHHHHHHHHHHHHH!}
(*var
	s : string;
	qry : TFquery;
begin
	qry := NIL;
	try
		qry := TFquery.create(self);
		qry.DatabaseName := str_db_name;
		qry.SQL.assign(self.SQL.lines);
		qry.Active := TRUE;

		if NOT bo_dont_show_msg_if_ok then MessageBBox(handle,'OK!',MBOX_CAPTION);
		result := TRUE
	except
		s := get_last_exception_msg;
		if s = '' then s := 'Vi sono errori la cui descrizione non è purtroppo disponibile'
		else s := 'Errore nella query' + ACAPO2 + s;
		MessageBBox(handle,s,MBOX_CAPTION);
		result := FALSE
	end;
	qry.free
end; *)
begin
	result := exec_query(self, str_db_name, sql.Text, TRUE, bo_can_update);
	if result AND NOT bo_dont_show_msg_if_ok then MessageBBox(handle, 'OK!', MBOX_CAPTION)
end;

procedure Tdlg_free_query.check_proc; begin btn_check_syntax.click end;
procedure Tdlg_free_query.exec_proc; begin btn_ok.click end;

procedure Tdlg_free_query.FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
begin standard_key_management_12(Key, Shift, [], NIL, NIL, NIL, NIL, check_proc, NIL, NIL, NIL, exec_proc, NIL, NIL, NIL) end;

initialization
//	initialization_debug('fquery')
end.
