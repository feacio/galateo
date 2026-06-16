unit Db_link;

{$ifdef DLL} *** {$endif}

{$I defines}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, DB,
	FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
	FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
	FDB, federico, FBitBtn, Gdich, proc;

type
  Tdlg_dblink = class(TForm)
    tbl: TFTable;
    txt_label_fields: TLabel;
    txt_DB_fields: TLabel;
    btn_ok: TFBitBtn;
	 lb_etik: TComboBox;
	 lb_db: TComboBox;
    cbx_codice_default: TFCheckBox;
    cbx_index: TFCheckBox;
	 procedure FormCreate(Sender : TObject);
	 procedure lb_etikChange(Sender : TObject);
	 procedure lb_dbChange(Sender : TObject);
	 procedure btn_okClick(Sender : TObject);
	 procedure cbx_codice_defaultClick(Sender : TObject);
	 procedure cbx_indexClick(Sender : TObject);
  private
		bo_odbc : boolean;
		bo_dont_open : boolean;
		str_table : string;
		bo_assigning_cbx_codice_default : boolean;
		bo_indexes : array[0..1023] of boolean;	// TRUE se il campo i-esimo ha indice
		function get_obj_index(str : string) : smallint;
  public
		constructor xcreate(father : TForm;bo_odbc : boolean;var str_table : string);
  end;

var
  dlg_dblink: Tdlg_dblink;

implementation

uses Fcommons, FErrMsg, FMessage, FSystem, FCtrls,
	objects, pages;

{$R *.DFM}

const
	MBOX_CAPTION = 'Collegamento a database';

constructor Tdlg_dblink.xcreate(father : TForm;bo_odbc : boolean;var str_table : string);
begin
	bo_dont_open := TRUE;
	self.bo_odbc := bo_odbc;
	self.str_table := str_table;
	inherited create(father);
	if bo_dont_open then abort
end;

procedure Tdlg_dblink.FormCreate(Sender : TObject);
var i, j : integer;	//*
begin
	try
		try
			if bo_odbc then tbl.DatabaseName := globale.system_database.Name else tbl.DatabaseName := '';
//			tbl.TableType := ttDefault;
			tbl.TableName := str_table;
			tbl.Active := TRUE
		except
			error_msg('Impossibile collegarsi al database specificato', MBOX_CAPTION);
			abort
		end;
		tbl.indexdefs.update;
		for i := 0 to tbl.fieldcount-1 do begin
			var s := tbl.fields[i].FieldName;
			if (uppercase(copy(s,1,length(TBL_PREFIX_INVISIBILE))) = TBL_PREFIX_INVISIBILE) then continue;
			lb_db.Items.add(s);
			for j := 1 to i_objs do with xobjs(j) do begin
//				if (get_tipo_oggetto = xVARIABILE) AND
				if (tipo_variabile in TV_OLD_VARIABILI) AND
//					(aslabel.str_db_colonna = '') AND
					(str_SQL_expression = '') AND
					(uppercase(aslabel.Caption) = uppercase(tbl.fields[i].fieldname))
//				then aslabel.str_db_colonna := uppercase(tbl.fields[i].fieldname)
				then str_SQL_expression := uppercase(tbl.fields[i].fieldname)
			end;
			bo_indexes[i] := tbl.indexdefs.indexof(tbl.fields[i].fieldname) <> -1
		end;
		for i := 1 to i_objs do with xobjs(i) do
//			if (get_tipo_oggetto = xVARIABILE) then lb_etik.Items.add(aslabel.Caption);
			if (tipo_variabile in TV_OLD_VARIABILI) then lb_etik.Items.add(aslabel.Caption);
		{$ifdef DEBUG} check_components(self); {$endif DEBUG}
		bo_dont_open := FALSE
	except
		bo_dont_open := TRUE;
		error_msg('Errore durante il collegamento al database specificato', MBOX_CAPTION);
		abort
	end
end;

procedure Tdlg_dblink.lb_etikChange(Sender : TObject);
begin
	var i : integer := get_obj_index(lb_etik.Text);
	if (i = 0) then begin lb_db.ItemIndex := -1;exit end;
	var j : smallint := lb_db.Items.Count-1;
	while (j >= 0) do begin
//		if (uppercase(lb_db.Items.strings[j]) = uppercase(xobjs(i).aslabel.str_db_colonna))
		if (uppercase(lb_db.Items.strings[j]) = uppercase(xobjs(i).str_SQL_expression))
		then break;
		dec(j)
	end;
	lb_db.ItemIndex := j;

	bo_assigning_cbx_codice_default := TRUE;
	cbx_codice_default.Checked := (globale.str_db_field_default = uppercase(lb_db.Text));
	bo_assigning_cbx_codice_default := FALSE;

	i := tbl.fielddefs.indexof(lb_db.Text);
	cbx_index.Checked := (i >= 0) AND bo_indexes[i]
end;

function Tdlg_dblink.get_obj_index(str : string) : smallint;
// rende l'indice nel vettore OBJS dell'item con nome STR; rende 0 se non esiste
begin
	var i : smallint := i_objs;
	while(i > 0) do begin
		if (uppercase(str) = uppercase(xobjs(i).aslabel.Caption)) then break;
		dec(i)
	end;
	get_obj_index := i
end;

procedure Tdlg_dblink.lb_dbChange(Sender : TObject);
begin
	var i : smallint := tbl.fielddefs.indexof(lb_db.Text);
	cbx_index.Checked := (i >= 0) AND bo_indexes[i];

	if (lb_etik.ItemIndex = -1) then begin
{		MessageBBox(handle,'Per eseguire una associazione devi selezionare una delle variabili dell''etichetta.',
			MBOX_CAPTION); }
		exit
	end;
	i := get_obj_index(lb_etik.Text);
//	xobjs(i).aslabel.str_db_colonna := uppercase(lb_db.Text);
	xobjs(i).str_SQL_expression := uppercase(lb_db.Text);
	bo_assigning_cbx_codice_default := TRUE;
	cbx_codice_default.Checked := (globale.str_db_field_default = uppercase(lb_db.Text));

	bo_assigning_cbx_codice_default := FALSE
end;

procedure Tdlg_dblink.cbx_codice_defaultClick(Sender : TObject);
begin
	if bo_assigning_cbx_codice_default then exit;
	var i : smallint := lb_db.ItemIndex;
	if (i = -1) then begin
		MessageBBox(handle, 'Seleziona un campo del database prima di definirlo come codice default', MBOX_CAPTION);
		exit
	end;
	globale.str_db_field_default := uppercase(lb_db.Text)
end;

procedure Tdlg_dblink.btn_okClick(Sender : TObject);
begin
	// genero gli eventuali indici
	for var i : smallint := 0 to tbl.fieldcount-1 do begin
		var s := tbl.fielddefs.Items[i].Name;
		if bo_indexes[i] AND (tbl.indexdefs.indexof(tbl.fields[i].fieldname) = -1) then begin
			case MessageBBox(handle, 'Vuoi creare l''indice per il campo <' + s + '> ?', MBOX_CAPTION, MB_YESNOCANCEL) of
				IDYES: begin
					set_wait_cursor(TRUE);
//					tbl.AddIndex(s, s, []);
					tbl.AddIndex(s, s, '', []);
					set_wait_cursor(FALSE)
				end;
				IDNO: ;
				IDCANCEL :exit
			end
		end;
		if NOT bo_indexes[i] AND (tbl.indexdefs.indexof(tbl.fields[i].fieldname) <> -1) then begin
			case MessageBBox(handle, 'Vuoi eliminare l''indice per il campo <' + s + '> ?', MBOX_CAPTION, MB_YESNOCANCEL) of
				IDYES: begin
					set_wait_cursor(TRUE);
					tbl.DeleteIndex(s);
					set_wait_cursor(FALSE)
				end;
				IDNO: ;
				IDCANCEL :exit
			end
		end
	end;

	close
end;

procedure Tdlg_dblink.cbx_indexClick(Sender : TObject);
begin
	var i : integer := tbl.fielddefs.indexof(lb_db.Text);
	if (i >= 0) then bo_indexes[i] := cbx_index.Checked
end;

//initialization
//	initialization_debug('db_link')
end.
