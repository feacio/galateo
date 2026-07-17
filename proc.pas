unit Proc;	//*

{$I defines}

interface

uses UITypes, sysutils, Windows, VCL.dbctrls, classes, VCL.stdctrls, VCL.graphics, db, VCL.forms, Registry, Math,
	{$ifdef MSWINDOWS} {$WARN UNIT_PLATFORM OFF} VCL.FileCtrl, {$WARN UNIT_PLATFORM ON} {$endif}
	FireDAC.Stan.Error,
	Fcommons, FDB, VCL.controls,
	{$ifndef DLL} validate, {$endif}
	Gdich;

function get_internal_version_signature(bo_file_datetime : boolean = FALSE) : string;

function galateo_check_IBAN(str_IBAN : string;pt_str_error_message : string_punt = NIL) : boolean;

function accept_future_versions : boolean;
function check_decimal_format(s : string) : string;

{$ifNdef DLL} function check_printer_size_constraints(father : TForm;printer_size_constraints : printer_size_constraints_data_type;err_msg : cl_validation = NIL) : boolean; {$endif}

function check_link_utente(s : string;pt_str_filename : string_punt = NIL;pt_str_descrizione : string_punt = NIL) : boolean;

function translate_local_macros(str_SQL : string) : string;

function load_lingue(it : TStrings;bo_uppercase : boolean = FALSE) : boolean;
{$ifdef GALATEO_EXE}
	function load_lingua_items(it : TStrings;context_mode : lingua_context_set = [];bo_uppercase : boolean = FALSE) : boolean;
	function load_lingua_contesti_items(it : TStrings;bo_uppercase : boolean = FALSE) : boolean;
{$endif}

function XML_commento(str_header, str_text : string;bo_start : boolean;bo_ACAPO_after : boolean = TRUE) : string;

{$ifndef DLL}
	type
		pk_operations = (PK_NEW, PK_GET, PK_SET, PK_DEL);	// operazioni eseguibili sulle Primary Keys

	procedure	delete_codice(father : TForm;tbl : TFTable;qry : TFQuery);
	procedure	default_help_proc(self : TForm);
	function		esiste_codice(str_dbname, str_table,str_sql_campo, str_valore : string;str_where : string = '') : boolean;
	function		primary_key_function(str_table : string;lo : integer;pk_op : pk_operations) : integer;
	function		set_all_values(tbl : TFTable;str_campo, str_value : string) : boolean;
	function		update_tables(qry : TFquery;var bo_something_modified : boolean) : boolean;
	function		verify_editing_qry(var qry : TFquery;bo_forza : boolean) : boolean;
	function		verify_editing_tbl(var tbl : TFTable;bo_forza : boolean) : boolean;
	procedure	ask_for_delete(handle : hwnd;str_caption,str_object : string;sex : sesso);
	procedure	delete_log_file;
	procedure	read_parms;
//	procedure	set_DBN_hints(var dbn : TDBNavigator;str_record : string;genere : sesso);

	function		get_tipo_variabile(str_descrizione : string) : variabile_type;

{	function		browse_directory(str_caption : string;var str_path : string;str_default_path : string = '') : boolean;
	function		browse_for_files_open(father : TForm;var str_filename : string;
						str_default_ext,str_files_filter,str_default_dir : string;bo_relative_path : boolean = FALSE;
						bo_file_must_exists : boolean = TRUE) : boolean; }
	function		select_colore(father : TForm;var i_colore : TColor) : boolean;
	function		load_object_export_types_items(it : TStrings) : boolean;
	function		load_section_export_types_items(it : TStrings) : boolean;
	procedure	load_shift_formula_items(it : TStrings);
{$endif}

function help_proc(father : TForm;str_URL : string = '') : boolean;

function label_write_ultima_posizione_stampa(str_printer, str_formato : string;i_pos : smallint) : boolean;
function label_read_ultima_posizione_stampa(str_printer, str_formato : string;var i_pos : smallint) : boolean;

procedure exec_sql(str_SQL : string); overload;
procedure exec_sql(str_sql, str_databasename : string); overload;
procedure exec_sql(qry : TFquery;str_sql : string;str_databasename : string = ''); overload;

function get_integer_where(str_dbname, str_table, str_campo, str_where : string;var i_error : integer) : integer;
function get_string_where(str_dbname, str_table, str_campo, str_where : string;bo_show_errore : boolean = FALSE) : string; overload;
function get_string_where(str_dbname,str_select : string;str_field : string = '';bo_show_errore : boolean = FALSE) : string; overload;
function get_SQL_separator(s : string;var i_pos,i_len : smallint) : boolean;
function load_SQL_items(str_db_name, str_SQL_syntax, str_field_name : string;items : TStrings;bo_insert_blank : boolean) : boolean;

function binary_2_string(ff : TField;var str : string) : boolean;

function get_parm(var str_formula : string;var str_parm : string) : boolean;
function get_delimitatore(s : string;c : char) : smallint;
function togli_protezione_parametri(var s : string) : string;

//function		fetta(lp : LPSTR;i_start : word;str_separator : string;var str_result : string) : word;
function		get_char_in_formula(ch : string{str_operatore_type};s : string) : smallint;
//function		get_pos_chiusura_parentesi(s : string;i_open : smallint = 1) : smallint;
function		clear_external_parentesi(str_boolean : string) : string;
procedure	togli_blanks_non_necessari(var s : string);

function leggi_text_integer(handle : hwnd;ctrl : TEdit;lo_min,lo_max : integer;str_descr : string;lo_old_value : integer) : integer;
function leggi_text_real(handle : hwnd;ctrl : TEdit;r_min,r_max : real;str_descr : string;r_old_value : real) : real;

procedure TStrings_load(var f : text;t : TStrings);
procedure TStrings_save(var f : text;t : TStrings);
function TStrings_total_length(tstr : TStrings;i_riga_value : smallint) : word;

function read_font(var f : text;font : TFont) : boolean;
function write_font(var f : text;font : TFont) : boolean;

procedure read_object_pos(ctrl : TControl;var f : text;wo_versione : word);
procedure read_object_size(ctrl : TControl;var f : text;wo_versione : word);

procedure reopen_dataset_surplace(ds : TDataset);

function get_list_where(str_databasename, str_SQL_syntax : string;str_delimitatore : string = ',';bo_distinct : boolean = FALSE) : string;

{$ifdef DLL}
	procedure log_parameter(str_report_filename : string;i_job : smallint;str_name,str_value : string);
{$else}
	function setup_shell_extensions(father : TForm) : boolean;
{$endif}

function is_commento(s : string) : boolean;

{$ifdef DEBUG} procedure check_index(i : integer;str : string;i_min,i_max : integer); {$endif}

implementation

uses FAssert, FXStrings, FStrings, FErrMsg, Fdata, Ftime, FSQLsoft, FSystem_base, FSystem, FMessage, FProcs, FRegistry, FFile,
	{$ifndef DLL} Dialogs, {$endif}
	galateo_debug, misure, expint_base, objsx, pages;

procedure reopen_dataset_surplace(ds : TDataset);
// chiude e riapre la query, riaggiornandone i dati; resta in surplace sul record selezionato
begin
	if NOT ds.Active then exit;	// nulla da fare, se non casino
	try
		set_wait_cursor(TRUE);
		var bm : db.TBookmark := ds.GetBookmark;
		ds.Active := FALSE;
		ds.Active := TRUE;
		try ds.GotoBookmark(bm) except end;
		ds.Freebookmark(bm)
	finally
		set_wait_cursor(FALSE)
	end
end;

function leggi_text_real(handle : hwnd;ctrl : TEdit;r_min,r_max : real;str_descr : string;
	r_old_value : real) : real;
{ legge dal TEdit control specificato verificando che siano soddisfatte le condizioni
  LO_MIN e LO_MAX; se ci sono dei problemi emette un messaggio ed esegue un ABORT }
var r : real;
begin
//	leggi_text_real := r_old_value;
	{$I-} RRval(togliblanks(ctrl.Text), r); {$I+}
	if (IOresult <> 0) then begin
		MessageBBox(handle, 'Valore non valido', str_descr);
		abort
	end;

	if (r < r_min) OR (r > r_max) then begin
		MessageBBox(handle, 'Il valore deve essere compreso tra ' + strid(r_min, 0, 2) + ' e ' + strid(r_max, 0, 2), str_descr);
		abort
	end;

	result := r
end;

function leggi_text_integer(handle : hwnd;ctrl : TEdit;lo_min,lo_max : integer;str_descr : string;lo_old_value : integer) : integer;
begin
	var r : real := leggi_text_real(handle, ctrl, lo_min, lo_max, str_descr, lo_old_value);
	if (r <> round(r)) then begin
		MessageBBox(handle, 'Il valore non può avere cifre decimali', str_descr);
		abort
	end;
	result := round(r)
end;

procedure exec_sql(str_SQL : string);
//var db : TFDatabase;
begin
//	if (globale.xdb_report = NIL) then db := globale.xxdb_galateo else db := globale.xdb_report;
//	db.ExecSQL(str_SQL)
	globale.system_database.ExecSQL(str_SQL)
end;

procedure exec_sql(str_sql, str_databasename : string);
begin
	if (str_databasename = '') then begin
		exec_SQL(str_SQL);
		exit
	end;

	var qry : TFQuery := create_query(NIL, str_databasename, {str_SQL}'');	// non assegno str_SQL, altrimenti viene aperto e non eseguito
	qry.SQL.Text := str_sql;
	try
		qry.ExecSQL
	finally
		free_query(qry)
	end
end;

procedure exec_sql(qry : TFquery;str_sql : string;str_databasename : string = '');
begin
	if (qry = NIL) then exec_SQL(str_SQL, str_databasename)
	else begin qry.SQL.Text := str_sql;qry.ExecSQL end
end;

{$ifndef DLL}

	procedure default_help_proc(self : TForm); begin help_proc(self, GALATEO_TECHNICAL_HOME_PAGE) end;

	procedure delete_log_file;
	label fine;
	var
		f : file;
		s : string;
	begin
		var p : LPSTR := stralloc(256);
		Windows.GetPrivateProfileString(ODBC_GALATEO_SECTION, ODBC_DATABASEFILE, '', p, 256, ODBC_FILE_INI);
		if (strcomp(p, '') = 0) then goto fine;
		while (strlen(p) > 0) AND (p[strlen(p)-1] <> '.') do p[strlen(p)-1] := #0;
		s := strpas(p) + 'LOG';
		{$WARN SYMBOL_PLATFORM OFF}
		{$I-} system.assign(f,s);FileSetAttr(s,0);
		{$WARN SYMBOL_PLATFORM ON}
		erase(f);if IOresult = 0 then; {$I+}
	fine:
		strdispose(p)
	end;

	const
		// primary_keys
		TBL_PRIMARY_KEYS = 'primary_keys';
		TBL_PK_STR_TABLE = 'str_table';
		TBL_PK_LO_KEY = 'lo_primary_key';

	function primary_key_function(str_table : string;lo : integer;pk_op : pk_operations) : integer;
	{ esegue una operazione sulle primary key della table indicata;
	  in aggiunta ai codici restituiti per le singole operazioni, rende SQL_ERROR in caso di errore;
	  operazioni possibili:
			new_pk: generazione di una pk; risultato: la pk generata
			get_pk: rende la pk per la table indicata oppure 0 se la table non è ancora stata usata
			set_pk: imposta la pk per la table indicata
			del_pk: cancella la pk per la table indicata; rende 1 in caso di successo, 0 se non è stato possibile
	}
	var
		qry_pk : TFquery;
		ff_lo_key, ff_str_table : TField;
		db : TFDatabase;

		function set_pk(lo_new_key : integer) : integer;
		{ imposta la new pk per la table;
		  if LO_NEW_KEY = -1 la key viene generata, altrimenti si usa LO_NEW_KEY;
		  rende SQL_ERROR in caso di errore, oppure la key impostata }
		begin
			try
				db.starttransaction;
				qry_pk.SQL.add('SELECT * FROM ' + TBL_PRIMARY_KEYS + ' WHERE ' + TBL_PK_STR_TABLE + '=' + str_table.QuotedString);
				qry_pk.Active := TRUE;
				ff_str_table := qry_pk.FindField(TBL_PK_STR_TABLE);
				ff_lo_key := qry_pk.FindField(TBL_PK_LO_KEY);

				if NOT qry_pk.RequestLive then qry_pk.RequestLive := TRUE;
				qry_pk.Edit;
				if (lo_new_key = -1) then begin
					if (qry_pk.State = dsEdit) then
						ff_lo_key.AsInteger := ff_lo_key.AsInteger + 1
					else begin
						ff_str_table.AsString := str_table;
						ff_lo_key.AsInteger := 1
					end
				end
				else begin
					ff_str_table.AsString := str_table;
					ff_lo_key.AsInteger := lo_new_key
				end;
				set_pk := ff_lo_key.AsInteger;
				qry_pk.Post;
				db.commit
			except
				set_pk := SQL_ERROR;
				db.rollback
			end
		end;

		function get_pk : integer;
		{ rende l'ultima primary key usata per la table indicata;
		  rende 0 se la table non è mai stata usata; rende SQL_ERROR in caso di errore }
		begin
			try
				db.starttransaction;
				qry_pk.SQL.add('SELECT * FROM ' + TBL_PRIMARY_KEYS + ' WHERE ' + TBL_PK_STR_TABLE+'=' + str_table.QuotedString);
				qry_pk.Active := TRUE;
				if qry_pk.EOF then get_pk := 0
				else get_pk := qry_pk.FindField(TBL_PK_LO_KEY).AsInteger;
				db.rollback
			except
				get_pk := SQL_ERROR;
				db.rollback
			end
		end;

	label loop;
	var lo_res : integer;
	begin
		db := TFDatabase.create(NIL);
		db.loginprompt := FALSE;
		db.drivername := ODBC_STANDARD_DRIVER_NAME;
		db.name := 'pk';db.DatabaseName := db.name;
		db.connected := TRUE;
		qry_pk := TFquery.create(NIL);qry_pk.requestlive := TRUE;
		qry_pk.DatabaseName := db.name;
		var i : smallint := 0;
		repeat
			case pk_op of
				pk_new: lo_res := set_pk(-1);
				pk_get: lo_res := get_pk;
				pk_set: lo_res := set_pk(lo);
				pk_del: begin
					lo_res := get_pk;
					if (lo_res = SQL_ERROR) then goto loop;
					if (lo_res = lo) then begin
						lo_res := set_pk(lo-1);
						if (lo_res <> SQL_ERROR) then lo_res := 1	{ ok, successo }
					end
					else lo_res :=	0	{ nulla da fare, impossibile eseguire la cancellazione }
				end
				else begin
					{$ifdef DEBUG} assert(FALSE,'primary_key_function(): valore errato !!!'); {$endif}
					lo_res := -1
				end
			end;
		loop:
			inc(i);
			if (lo = SQL_ERROR) then sleep(200);
		until (lo <> SQL_ERROR) OR (i > 12);
		qry_pk.free;db.free;
		result := lo_res
	end;

	function set_all_values(tbl : TFTable;str_campo, str_value : string) : boolean;
	{ impone al campo STR_CAMPO di tutti i record di TBL il valore STR_VALUE;
	  la tbl deve essere aperta;
	  rende FALSE se l'operazione fallisce; non raisa nessuna exception }
	begin
		set_wait_cursor(TRUE);
		try
			var ff : TField := tbl.FindField(str_campo);
			verify_editing_tbl(tbl,TRUE);ff.AsString := str_value;
			var bm : TBookmark := tbl.GetBookmark;
			tbl.first;
			while NOT tbl.eof do begin
				verify_editing_tbl(tbl,TRUE);
				ff.AsString := str_value;
				tbl.next
			end;
			tbl.GotoBookmark(bm);tbl.Freebookmark(bm);
			set_all_values := TRUE
		except
			set_all_values := FALSE
		end;
		set_wait_cursor(FALSE)
	end;

	function verify_editing_qry(var qry : TFquery;bo_forza : boolean) : boolean;
	{ verifica che la query sia in stato di editing; se non lo è, la pone in stato di editing;
	  rende TRUE se la query all'uscita della funzione si trova in stato di editing, FALSE altrimenti }
	begin
		if (qry.State = dsCalcFields) then begin result := FALSE;exit end;
		if bo_forza AND NOT (qry.State in [dsEdit, dsInsert]) then qry.Edit;
		verify_editing_qry := (qry.State in [dsEdit, dsInsert])
	end;

	function verify_editing_tbl(var tbl : TFTable;bo_forza : boolean) : boolean;
	{ verifica che la table sia in stato di editing; se non lo è, la pone in stato di editing;
	  rende TRUE se la table, all'uscita della funzione, si trova in stato di editing,
	  FALSE altrimenti }
	begin
		if (tbl.State = dsCalcFields) then begin result := FALSE;exit end;
		if bo_forza AND NOT (tbl.State in [dsEdit, dsInsert]) then tbl.Edit;
		verify_editing_tbl := (tbl.State in [dsEdit, dsInsert])
	end;

	function esiste_codice(str_dbname, str_table, str_sql_campo, str_valore : string;str_where : string = '') : boolean;
	begin
		var qry := TFquery.create(NIL);qry.DatabaseName := str_dbname;
		try
			qry.SQL.add('SELECT ' + str_sql_campo + ' FROM ' + str_table +
				' WHERE ' + str_sql_campo + '=' + str_valore.QuotedString + ifs(str_where, ' AND (' + str_where + ')'));
			qry.Active := TRUE;esiste_codice := NOT qry.Eof
		finally
			qry.free
		end
	end;

	function update_tables(qry : TFquery;var bo_something_modified : boolean) : boolean;
	{ esegue un aggiornamento standard per una query di una tipica form di editazione dati;
	  rende TRUE se dei dati sono stati modificati nella finestra }
	begin
		if (qry.State in dsModifying) then qry.updaterecord;
		bo_something_modified := bo_something_modified OR qry.Modified;
		update_tables := bo_something_modified
	end;

	procedure delete_codice(father : TForm;tbl : TFTable;qry : TFquery);
	{ cancella il codice della table o della query;
	  passare pt_tbl oppure pt_qry contenenti la tavola o la query interessata,
	  l'altra deve essere NIL }
	const MBOX_CAPTION = 'Elimina codice';
	begin
		{$ifdef DEBUG} assert((tbl = NIL) XOR (qry = NIL),'errore in PROC.delete_codice'); {$endif}
		var bo_qry := (qry <> NIL);

		if bo_qry then begin
			if (qry.State = dsInsert) then begin qry.cancel;exit end
		end
		else begin
			if (tbl.State = dsInsert) then begin tbl.cancel;exit end
		end;

		if (MessageBBox(father, 'Sei sicuro di voler cancellare l''elemento selezionato?', MBOX_CAPTION,
			MB_YESNOCANCEL OR MB_ICONQUESTION OR MB_DEFBUTTON2) <> IDYES)
				then exit;
		try
			if bo_qry then begin
				var bo_was_requestlive := qry.requestlive;qry.requestlive := TRUE;
				qry.delete;
				qry.requestlive := bo_was_requestlive
			end
			else tbl.Delete
		except
//			on EDBEngineError do
			on E: EFDDBEngineException do begin
//				if (E.Kind = ekUKViolated then ******
				MessageBBox(father, 'ERRORE DATABASE' + ACAPO + '(probabilmente il codice è usato altrove)', MBOX_CAPTION, MB_ICONSTOP);
//				raise
			end;
			else error_msg(father, ERROR_EXECUTING, MBOX_CAPTION)
//			else MessageBBox(handle, 'ERRORE:' + , MBOX_CAPTION, MB_ICONSTOP)
		end
	end;

	procedure ask_for_delete(handle : hwnd;str_caption,str_object : string;sex : sesso);
	{ chiede conferma della conacellazione del codice;
	  dovrebbe essere chiamata dall'evento BeforeDelete();
	  se risponde NO esegue un'ABORT, abortendo la deletazione }
	begin
		if (sex = MARTE) then str_object := 'il ' + str_object + ' selezionato'
		else str_object := 'la ' + str_object + ' selezionata';
		if (MessageBBox(handle, 'Vuoi veramente cancellare ' + str_object + '?', str_caption, MB_QUESTION_DEF2) <> IDYES) then abort
	end;

	const
		HELP_PARM_1 = '?';
		HELP_PARM_2 = '/?';
		HELP_PARM_3 = '/h';
		HELP_PARM_4 = '/help';
		ALIAS_PARM = '/A';
		NOAPI_PARM = '/NOAPI';

	procedure read_parms;
	// legge gli eventuali paramtri passati al programma ed esegue le necessarie conseguenti azioni
	begin
		i_parm_filename := 0;
		for var i : smallint := 1 to paramcount do begin
			var s := uppercase(paramstr(i));
			if (s = HELP_PARM_1) OR (s = HELP_PARM_2) OR (s = HELP_PARM_3) OR (s = HELP_PARM_4) then begin
				MessageBBox(NULL, 'Parametri accettati da ' + PROGRAM_NAME_BASE + ':' + ACAPO2 +
					'/Anome: usa l''alias "nome"' + ACAPO +
					'/? schermata di aiuto', MBOX_CAPTION);
				halt
			end;
			if (s = NOAPI_PARM) then continue;		{ lo legge GALATEO_API: qui non deve finire per nome di file }
			if (copy(s, 1, length(ALIAS_PARM)) = ALIAS_PARM) then begin
				delete(s, 1, length(ALIAS_PARM));
				continue
			end;
			if (i_parm_filename = 0) then i_parm_filename := i
			else begin
				MessageBBox(NULL,'E'' possibile specificare un solo nome di file da aprire.' + ACAPO +
					'Tutti gli altri parametri verranno ignorati',MBOX_CAPTION);
				continue
			end
		end
	end;

	function get_tipo_variabile(str_descrizione : string) : variabile_type;
	// rende il tipo di variabile con descrizione STR_DESCRIZIONE
	begin
		result := low(variabile_type);
		while (result < high(variabile_type)) AND (TV_DESCRIZIONE[result] <> str_descrizione) do inc(result)
	end;

{$endif DLL}

procedure TStrings_load(var f : text;t : TStrings);
var
{	lp : LPSTR;
	s,s2 : string;
	i,j : integer;}
	s : string;	//*
	i : integer;
begin
	readln(f, s);t.clear;
	while (s <> '') do begin
		i := pos(#255, s);
		if (i = 0) then i := length(s) + 1;
		t.add(copy(s, 1, i - 1));
		delete(s, 1, i)
	end
(*	readln(f,s2);
	lp := LPSTR(s2);

	t.clear;i := 0;
	while (i < strlen(lp)) do begin
		s := strpas(@lp[i]);j := pos(#255,s);
		if (j <> 0) then delete(s,j,MAXINT) else j := length(s);
		t.add(s);inc(i,j)
	end *)
end;

procedure TStrings_save(var f : text;t : TStrings);
begin
	for var i : integer := 0 to t.Count-1 do begin
		if (i > 0) then write(f,#255);
		write(f,t[i])
	end;
	writeln(f)
end;

function TStrings_total_length(tstr : TStrings;i_riga_value : smallint) : word;
{ rende la lunghezza totale del contenuto di tstr;
  ad ogni riga (a partire dalla seconda) aggiunge il valore specificato da I_RIGA_VALUE }
begin
	var j : smallint := 0;
	for var i : smallint := 0 to tstr.Count-1 do inc(j, length(tstr[i]));
	result := j + (MAX(tstr.Count,1) - 1) * i_riga_value
end;

function get_SQL_separator(s : string;var i_pos, i_len : smallint) : boolean;
{ rende la posizione e la lunghezza del primo separatore SQL della stringa specificata;
  rende TRUE se trova almeno un separatore }
begin
	i_pos := 0;i_len := 0;
	for var i : smallint := 1 to NUM_SQL_SEPARATORS do begin
		var j : smallint := pos(SQL_SEPARATORS[i], s);
		if (j <> 0) AND ((j < i_pos) OR (i_pos = 0)) then begin i_pos := j;i_len := length(SQL_SEPARATORS[i]) end
	end;
	result := (i_pos <> 0)
end;

function get_char_in_formula(ch : string{str_operatore_type};s : string) : smallint;
{ rende la posizione della prima ricorrenza del carattere specificato;
  il carattere deve trovarsi al di fuori di ogni stringa e deve essere al
  livello di nidificazione di parentesi dell'inizio della stringa
  rende 0 in caso di errore, ovvero se il carattere non è stato trovato }
begin
	sostituisci(s, VIRGOLETTA_IN_TEXT, VIRGOLETTA_IN_TEXT_INTERNAL_USE);
	var i : smallint := 1;
	var i_level : smallint := 0;
	var i_len : smallint := length(ch);
	var bo_instringa := FALSE;
	result := 0;
	while (i <= length(s)) do begin
//		if (i_level < 0) then exit;	// evidentemente impossibile
		if (s[i] = VIRGOLETTA) then bo_instringa := NOT bo_instringa;
		if NOT bo_instringa then begin
			if (i_level <= 0) AND (copy(s, i, i_len) = ch) then begin result := i;exit end;
			if (s[i] = '(') then inc(i_level) else
			if (s[i] = ')') then dec(i_level)
		end;
		inc(i)
	end;
	sostituisci(s, VIRGOLETTA_IN_TEXT_INTERNAL_USE, VIRGOLETTA_IN_TEXT)
end;

function get_pos_chiusura_parentesi(s : string;i_open : smallint = 1) : smallint;
{ rende la posizione in cui viene chiusa la parentesi che si trova alla posizione I_OPEN;
  rende 0 se la parentesi non viene chiusa }
begin
	{$ifdef DEBUG} assert(copy(s,i_open,1) = '(','DJSH 2883'); {$endif}
	result := get_char_in_formula(')',copy(s,i_open+1,MAXINT));
	if (result <> 0) then inc(result,i_open)
end;

function clear_external_parentesi(str_boolean : string) : string;
// tolgo le eventuali parentesi externe (ininfluenti)
const
	PARENTESI_APERTA = '(';
	PARENTESI_CHIUSA = ')';
begin
	repeat
		str_boolean := togliblanks(str_boolean);
		if NOT start_with(str_boolean, PARENTESI_APERTA) then break;
		if (get_pos_chiusura_parentesi(str_boolean) <> length(str_boolean)) then break;
		delete(str_boolean,1,length(PARENTESI_APERTA));
		str_boolean := togli_finale(str_boolean, PARENTESI_CHIUSA)
	until FALSE;
	result := str_boolean
end;

procedure togli_blanks_non_necessari(var s : string);
{ toglie tutti gli spazî non necessari all'interno della formula STR;
  una formula come 'str_pippo + str_alleluia + if ( 1+2+3 > 4 ; 'a b c' ; 'd e f' ) '
  diventa          'str_pippo+str_alleluia+if(1+2+3>4;'a b c';'d e f')' }
var i,j,k : smallint;
begin
	s := togliblanks(s);if (s = '') then exit;

	sostituisci(s, VIRGOLETTA_IN_TEXT, VIRGOLETTA_IN_TEXT_INTERNAL_USE);
	k := 0;j := 0;
	repeat
		inc(j,k+1);
		repeat
			i := get_char_in_formula(' ',copy(s,j,MAXINT));
			if (i = 0) then i := get_char_in_formula(^I,copy(s,j,MAXINT));
			if (i <> 0) then delete(s,j+i-1,1);
		until (i = 0) OR (s[j] = '(');
		if (s[j] = '(') then k := 0
		else begin
			if (copy(s,j,1) = VIRGOLETTA) then begin
				while (j <= length(s)) AND (copy(s,j+1,1) <> VIRGOLETTA) do inc(j);
				if (j > length(s)) then break;
				inc(j)
			end;
			k := get_char_in_formula('(',copy(s,j+1,MAXINT));
			if (k = 0) then break
		end
	until FALSE;
	sostituisci(s,VIRGOLETTA_IN_TEXT_INTERNAL_USE,VIRGOLETTA_IN_TEXT)
end;

function read_font(var f : text;font : TFont) : boolean;
// legge dal file F il font specificato; rende TRUE in caso di successo, FALSE altrimenti
var
	str : string;
	i, j : integer;
	c : char;
begin
	try
		if eoln(f) then
			for i := 1 to 5 do readln(f)
		else begin
			readln(f,str);Font.Name := str;
			readln(f, i, j);font.Color := i;font.size := j;
			// lettere usate: B I S U
			while NOT eoln(f) do begin
				read(f, c);
				case c of
					'B' : font.style := font.style + [fsBold];
					'I' : font.style := font.style + [fsItalic];
					'U' : font.style := font.style + [fsUnderline];
					'S' : font.style := font.style + [fsStrikeout];
					else abort
				end
			end;
			readln(f);
			readln(f);readln(f)	// righe vuote
		end;
		result := TRUE
	except
		result := FALSE
	end
end;

function write_font(var f : text;font : TFont) : boolean;
{ salva sul file F il font specificato; rende TRUE in caso di successo, FALSE altrimenti;
  occupa 5 righe di file }
begin
	try
		writeln(f, font.Name);
		writeln(f, font.Color, ' ', font.size);
		if (fsBold in font.Style) then write(f,'B');
		if (fsItalic in font.Style) then write(f,'I');
		if (fsUnderline in font.Style) then write(f,'U');
		if (fsStrikeout in font.Style) then write(f,'S');
		writeln(f);
		writeln(f);writeln(f);	// free for future
		result := TRUE
	except
		result := FALSE
	end
end;

procedure read_object_pos(ctrl : TControl;var f : text;wo_versione : word);
{ legge la posizione dell'oggetto dal file specificato (LEFT, TOP);
  in caso di errore emette eventuali messaggi e genera un'exception }
var r_left, r_top : real;
begin
	read(f,r_left,r_top);
	if (wo_versione = $100) then begin ctrl.Left := round(r_left);ctrl.Top := round(r_top) end
	else begin ctrl.Left := cm2pixel_video_x(r_left);ctrl.Top := cm2pixel_video_y(r_top) end
end;

procedure read_object_size(ctrl : TControl;var f : text;wo_versione : word);
{ legge la dimensione dell'oggetto dal file specificato (WIDTH, HEIGHT);
  in caso di errore emette eventuali messaggi e genera un'exception }
var r_width,r_height : real;	//*
begin
	read(f, r_width, r_height);
	if (wo_versione = $100) then begin
		ctrl.Width := round(r_width);
		ctrl.Height := round(r_height)
	end
	else begin
		ctrl.Width := cm2pixel_video_x(r_width);
		ctrl.Height := cm2pixel_video_y(r_height)
	end
end;

function get_string_where(str_dbname, str_table, str_campo, str_where : string;bo_show_errore : boolean = FALSE) : string;
{ se esiste un record in STR_TABLE che risponde alla condizione contenuta in STR_WHERE,
  la funzione rende il valore del campo contenuto in STR_CAMPO (se ci sono più records,
  considera solo il primo); se il record non esiste rende una stringa vuota;
  STR_WHERE può contenere anche una condizione ORDER BY }
begin
	var qry : TFquery := NIL;
	try
		qry := TFquery.create(NIL);qry.DatabaseName := str_dbname;
		qry.SQL.Text := 'SELECT ' + str_campo + ' FROM ' + str_table + ' WHERE ' + str_where;
		qry.Active := TRUE;
		if qry.Eof then result := '' else result := qry.FindField(str_campo).AsString
	except
		if bo_show_errore then error_msg('Errore durante l''esecuzione dell''espressione SQL' + ACAPO2 + qry.SQL.Text, 'SQL');
		result := ''
	end;
	if (qry <> NIL) then qry.free
end;

function get_string_where(str_dbname,str_select : string;str_field : string = '';bo_show_errore : boolean = FALSE) : string;
// esegue l'istruzione contenuta in STR_SELECT; estrame STR_FIELD oppure il primo campo della query
begin
	var qry : TFquery := NIL;//bo_get_where := FALSE;
	try
		qry := TFquery.create(NIL);qry.DatabaseName := str_dbname;qry.SQL.Text := str_select;
		qry.Active := TRUE;
		var bo_get_where := NOT qry.Eof;
		if NOT bo_get_where then result := ''
		else begin
			if (str_field = '') then result := qry.fields[0].AsString
				// per consentire espressioni complesse rinominate con un AS ...
			else result := qry.FindField(str_field).AsString		// percorso normale
		end
	except
//		{$ifdef DEBUG} assert(FALSE,'errore in GET_STRING_WHERE(): ' + ACAPO2 + qry.*Text); {$endif}
		if bo_show_errore then error_msg('Errore durante l''esecuzione dell''espressione SQL' + ACAPO2 + qry.SQL.Text, 'SQL')
		{$ifdef DEBUG} else error_msg('errore in GET_STRING_WHERE(): ' + ACAPO2 + qry.SQL.Text,'ERRORE IN GET_XXXX_WHERE()') {$endif};

		result := ''
	end;
	if (qry <> NIL) then qry.free
end;

function get_integer_where(str_dbname, str_table, str_campo, str_where : string;var i_error : integer) : integer;
// I_ERROR vale -1 in caso di errore SQL; oppure >0 in caso di errore di traduzione
begin
	var s := get_string_where(str_dbname,str_table,str_campo,str_where);
	LVal(s, result, i_error)
end;

function load_SQL_items(str_db_name, str_SQL_syntax, str_field_name : string;items : TStrings;bo_insert_blank : boolean) : boolean;
{ carica su ITEMS il risultato della query specificata;
  il campo da caricare nella combo viene caricato su STR_FIELD_NAME;
  rende TRUE in caso di successo, FALSE altrimenti }
begin
	result := FALSE;
	var qry : TFQuery := NIL;
	try
		qry := create_query(NIL, str_DB_name, str_SQL_syntax);
		items.clear;
		if bo_insert_blank then items.add('');	// inserisco la stringa blank
		if (str_field_name = '') then str_field_name := qry.Fields[0].fieldname;
		while NOT qry.eof do begin
			items.add(qry.FindField(str_field_name).AsString);
			qry.Next
		end;
		result := TRUE
	except
	end;
	free_query(qry)
end;

function read_binary(ff : TField;stream : TMemoryStream) : boolean;
{ legge dal TField binary specificato nello stream specificato;
  rende TRUE in caso di successo }
begin
	try
		stream.clear; 
		TMemoField(ff).SaveToStream(stream);
		result := TRUE
	except
		result := FALSE
	end
end;

function binary_2_string(ff : TField;var str : string) : boolean;
// carica l'oggetto ff (blob) sulla stringa; rende TRUE in caso di successo
begin
	var stream : TMemoryStream := NIL;
	try
		stream := TMemoryStream.create;
		if NOT read_binary(ff,stream) then abort;
		str := copy(strpas(LPSTR(stream.memory)),1,stream.size);
		result := TRUE
//		rtf2string(stream);
	except
		result := FALSE
	end;
	if (stream <> NIL) then stream.free
end;

function get_parm(var str_formula : string;var str_parm : string) : boolean;
{ legge un parametro dalla lista dei parametri, e lo toglie dalla formula;
  il parametro letto viene caricato su STR_PARM;
  se si passa STR_FORMULA = ')' toglie la parentesi e rende FALSE (parametro non letto, ma comunque va tutto bene);
  rende TRUE quando riesce a leggere un parametro, FALSE se non ci sono più parametri;
  esegue un abort in caso di errore nella formula }
begin
	result := FALSE;
	str_formula := togliblanks(str_formula);
	if (str_formula = '') then exit;	// fine della fiera
	if (str_formula[1] = ')') then begin delete(str_formula,1,1);exit end;	// fine della fiera

	var i : smallint := 0;
	if (copy(str_formula, 1, length(DELIMITATORE_SPECIALE_PARMS)) = DELIMITATORE_SPECIALE_PARMS) then begin
		delete(str_formula, 1, length(DELIMITATORE_SPECIALE_PARMS));
		i := pos(DELIMITATORE_SPECIALE_PARMS, str_formula);
		if (i = 0) then raise Exception.create('Errore nel formato del parametro');	// delimitatore speciale non chiuso
		delete(str_formula,i,length(DELIMITATORE_SPECIALE_PARMS))
	end;
	// prendo il delimitatore più prossimo; attenzione che vi possono essere piu' formule sulla stessa riga
	if (i = 0) then begin
		i := get_delimitatore(str_formula,')');
		var j : smallint := get_delimitatore(str_formula, ',');
		// prendo il minimo tra quelli != 0
		if (i = 0) OR (j = 0) then i := max(i, j) else i := min(i, j)
	end;
	if (i = 0) then i := length(str_formula) + 1;

	str_parm := copy(str_formula, 1, i-1);
	if (copy(str_formula, i, 1) = ')') then dec(i);	// lascio la parentesi terminale
	delete(str_formula, 1, i);
	result := TRUE
end;

function togli_protezione_parametri(var s : string) : string;
// toglie tutte le eventuali occorrenze di DELIMITATORE_SPECIALE_PARMS
var i : smallint;	//*
begin
	repeat
		i := pos(DELIMITATORE_SPECIALE_PARMS, s);
		if (i <> 0) then delete(s,i,length(DELIMITATORE_SPECIALE_PARMS))
	until (i = 0);
	result := s
end;

function get_delimitatore(s : string;c : char) : smallint;
{ rende la posizione della prima occorrenza del delimitatore C;
  se il delimitatore è di quelli nidificanti (parentesi) fa le cose come ci si aspetterebbe che le facesse;
  tiene conto di coppie di virgolette;
  rende 0 se non trova il delimitatore }
begin
	var i : smallint := 1;var i_level_parentesi : smallint := 0;
	// cerco la fine del parametro, saltando parametri interni [esempio: copy(s,len(xxx))] e sottostringhe
	while (i <= length(s)) do begin
//AND (s[i] <> c) AND ((s[i] <> ')') OR (i_level_parentesi > 0))
		if (i_level_parentesi = 0) AND (s[i] = c) then break;
		if (s[i] = '(') then inc(i_level_parentesi) else
		if (s[i] = ')') then dec(i_level_parentesi) else
		if (s[i] = '"') then begin		// salto le stringhe contenute
			inc(i);while (i < length(s)) AND (s[i] <> '"') do inc(i)
		end;
		inc(i)
	end;
	if (i > length(s)) then i := 0;
	result := i
end;

function get_DLL_filename : string;
var FileName: array[0..MAX_PATH] of Char;
begin
	GetModuleFileName(HInstance, FileName, MAX_PATH);
	Result := string(FileName)
end;

function get_internal_version_signature(bo_file_datetime : boolean = FALSE) : string;
// rende la stringa che deve essere mostrata nella about-dialog-box e che indica la versione del software
begin
//	result := 'GALATEO per Windows ver '+inttostr(hi(VERSION))+'.'+zeri(lo(VERSION),2)
	result := 'GALATEO per Windows ver ' + version_of(GALATEO_VERSION);
	if bo_file_datetime then begin
		var dt : TDatetime := get_file_datetime(get_DLL_filename);
		if (dt <> 0) then result := result + ' -- release ' + asstring_datetime(dt)
	end
end;

function is_commento(s : string) : boolean;
// rende TRUE se la riga è un commento o se è blank
begin
	result := (togliblanks(s) = '') OR (copy(s, 1, length(COMMENTI)) = COMMENTI)
end;

{$ifndef DLL}	// se DLL no: altrimenti il collegamento viene eseguito sul programma che chiama la DLL

	function setup_shell_extensions(father : TForm) : boolean;
	// configura le shell extensions
	const
		CLASS_FILE_ASSOCIATION_KEY = DEFAULT_EXT;
		CLASS_APPLICATION_IDENTIFIER_KEY = 'Galateo';	// nome della classe della mia applicazione
		CLASS_APPLICATION_DESCRIPTION = 'Galateo';		// descrizione che compare in gestione risorse
	begin
		var reg : TRegistry := NIL;
		try
			reg := TRegistry.Create;
			// registro le keys di identificazione del tipo di file default
			reg.RootKey := HKEY_CLASSES_ROOT;
			reg.DeleteKey('\' + CLASS_FILE_ASSOCIATION_KEY);
			reg.DeleteKey('\' + CLASS_APPLICATION_IDENTIFIER_KEY);

			// generazione tipo di file
			reg.OpenKey('\' + CLASS_FILE_ASSOCIATION_KEY, TRUE);
			reg.WriteString('', CLASS_APPLICATION_IDENTIFIER_KEY);

	{		reg.OpenKey('\' + CLASS_FILE_ASSOCIATION_KEY+'\ShellNew',TRUE);
			reg.WriteString('NullFile','');	// per creare un file vuoto
	//		reg.WriteString('Command',paramstr(0)+' /N');	// per eseguire un comando che crea il file
	}
			// descrizione default in Explorer
			reg.OpenKey('\' + CLASS_APPLICATION_IDENTIFIER_KEY,TRUE);
			reg.WriteString('', CLASS_APPLICATION_DESCRIPTION);
			// icona default in Explorer
			reg.OpenKey('\' + CLASS_APPLICATION_IDENTIFIER_KEY + '\DefaultIcon', TRUE);
			reg.WriteString('', paramstr(0));

			// registrazione items in context menu (click tasto destro)
			reg.OpenKey('\' + CLASS_APPLICATION_IDENTIFIER_KEY + '\Shell\Open\Command', TRUE);
			reg.WriteString('', paramstr(0) + ' "%1"');

			result := TRUE
		except
			error_msg(father, 'Errore durante l''impostazione del collegamento con Explorer', MBOX_CAPTION);
			result := FALSE
		end;
		reg.Free
	end;

	function check_init : boolean;
	{ esegue una inizializzazione del programma;
	  se Galateo non ha mai girato prima d'ora esegue l'inizializzazione del collegamento al registry }
	begin
		var reg : TRegistry := NIL;
		try
			reg := TRegistry.Create;
			// registro le keys di identificazione del tipo di file default
			reg.RootKey := HKEY_CURRENT_USER;
			// generazione tipo di file
			if NOT reg.OpenKey('\' + GALATEO_REGISTRY_BASE, FALSE) then begin
				setup_shell_extensions(NIL);
				reg.OpenKey('\' + GALATEO_REGISTRY_BASE, TRUE)
			end;
			result := TRUE
		except
			result := FALSE
		end;
		reg.Free
	end;

	function select_colore(father : TForm;var i_colore : TColor) : boolean;
	// apre un dialog per la modifica del colore di FF_COLORE; rende TRUE se l'operazione viene eseguita effettivamente
	begin
		{$ifdef DEBUG} assert(father <> NIL, 'KJMQ 9283'); {$endif}
		var cd : TColorDialog := TColorDialog.Create(father);
		try
			cd.Color := max(i_colore, 0);
			cd.CustomColors.Add('COLORA=' + inttostr(cd.Color));
			result := cd.execute;
			if result then i_colore := cd.Color
		except
			result := FALSE;
			error_msg(father, 'Errore durante la selezione del colore', father.Caption)
		end;
		if (cd <> NIL) then cd.free
	end;

	function load_section_export_types_items(it : TStrings) : boolean;
	// carica su IT i tipi di exportazione
	begin
		for var ex : section_expint_mode_type := low(ex) to high(ex) do it.add(SEXP_DESCRIZIONE[ex]);
		result := TRUE
	end;

	function load_object_export_types_items(it : TStrings) : boolean;
	// carica su IT i tipi di exportazione
	begin
		for var ex : object_expint_mode_type := low(ex) to high(ex) do it.add(OEXP_DESCRIZIONE[ex]);
		result := TRUE
	end;

	procedure load_shift_formula_items(it : TStrings);
	begin
		it.Clear;
		for var x : shift_formula_type := low(x) to high(x) do it.Add(SHIFT_FORMULA_DESCRIZIONE[x])
	end;

{$endif}

function check_decimal_format(s : string) : string;
// verifica che i punti decimali siano del tipo giusto, in funzione di DecimalSeparator
var str_sep : string{[1]};
begin
	if (fDecimalSeparator = ',') then str_sep := '.' else str_sep := ',';
	var i : smallint := pos(str_sep, s);
	if (i <> 0) then s[i] := fDecimalSeparator;
	result := s
end;

{$ifdef DLL}
	procedure log_parameter(str_report_filename : string;i_job : smallint;str_name,str_value : string);
	// se STR_NAME = '', viene stampato il messaggio di servizio STR_VALUE
	var f : text;
	begin
//		messagebbox(0,str_report_filename + ACAPO2 + str_name + '   ' + str_value,'*** ' + bool2SQL(get_globale(i_job).bo_log_parametri) + ' ***');
		if NOT get_globale(i_job).bo_log_parametri then exit;
		try
			{$I-}
			assign(f,ChangeFileExt(str_report_filename,'.PARM'));
			append(f);if (IOresult = 2) then rewrite(f);
			if (str_name = '') AND (str_value = 'start') then writeln(f);	// una riga vuota a carattere fondamentalmente esterico
			write(f,zeri(get_globale(i_job).lo_key_sessione,8),' ',dttime2SQL(now,FALSE,TMFMT_HMSC),^I);
			if (str_name = '') then writeln(f,str_value,' =====================')
			else writeln_LPSTR(f,str_name + '=' + str_value);
			close(f)
			{$I+}
		except
		end
	end;
{$endif}

function help_proc(father : TForm;str_URL : string = '') : boolean;
const PATH_BASE = 'http://www.feaci.it/jolly/galateo/';
var str_path : string;
begin
	result := TRUE;
	if (str_URL = '') then begin
		MessageBBox(father.handle,'Aiuto non disponibile','AIUTO');
		exit
	end;
	if NOT start_with(str_URL, 'www', FALSE) AND NOT start_with(str_URL, 'http', FALSE) then begin
		str_path := PATH_BASE;
		if (str_path <> '') AND NOT end_with(str_path, '\') AND NOT end_with(str_path, '/') then str_path := str_path + '\';
		str_URL := str_path + str_URL
	end;
	if start_with(str_path, 'http', FALSE) OR start_with(str_path, 'www', FALSE) then sostituisci(str_URL, '\', '/')
	else sostituisci(str_URL, '/', '\');
	if NOT end_with(str_URL, '.HTM', FALSE) then str_URL := str_URL + '.htm';
	execute_data_file(father.handle, FALSE, str_URL)
end;

function get_list_where(str_databasename, str_SQL_syntax : string;str_delimitatore : string = ',';bo_distinct : boolean = FALSE) : string;
// emula (per SQL Server) la funzione LIST()
begin
	var qry : TFquery := NIL;result := '';
//	if (str_delimitatore = '') then str_delimitatore := ',';
	try
		qry := TFquery.create(NIL);qry.DatabaseName := str_databasename;qry.RequestLive := FALSE;
		qry.SQL.Text := str_SQL_syntax;
		Gdebug_SQL(qry,'list()');
		qry.Active := TRUE;
		while NOT qry.Eof do begin
			add_delimited(result,qry.Fields[0].AsString,str_delimitatore, bo_distinct);	
			qry.Next
		end;
		Gdebug_SQL(result,'result of list()',TRUE)
	except
		result := '';
		error_msg('Errore durante l''esecuzione dell''istruzione SQL' + ACAPO2 + qry.SQL.Text, 'SQL')
	end;
	if (qry <> NIL) then qry.free
end;

function translate_local_macros(str_SQL : string) : string;
type
	cl_macro = record
		str_id, str_value : string;
	end;
var macro : array of cl_macro;

	procedure sort_macros;
	begin
		// ordino le macro per lunghezza decrescente, per evitare equivoci di interpretazione di macro simili
		for var i : smallint := 0 to high(macro)-1 do begin
			for var j : smallint := i+1 to high(macro) do begin
				if (length(macro[i].str_id) < length(macro[j].str_id)) then begin
					var s := macro[i].str_id;macro[i].str_id := macro[j].str_id;macro[j].str_id := s;
					s := macro[i].str_value;macro[i].str_value := macro[j].str_value;macro[j].str_value := s
				end
			end
		end;
	end;

var
	s : string;
	i,j : smallint;
begin
	macro := NIL;result := '';
	try
		// 2009-02-12 -- elimino le righe di commento
		while (str_SQL <> '') do begin
			s := togliblanks(get_line(str_SQL, TRUE));
			if NOT start_with(s, '//') then result := result + s + ACAPO
		end;

		str_SQL := result;result := '';
		while (str_SQL <> '') do begin
			s := togliblanks(get_line(str_SQL, TRUE));
//       if start_with(s, '//') then continue;    // 2009-02-12 per consentire commenti tra le macro locali
			if (s = '') then begin {result := result + ACAPO;}continue end;
			if (copy(s, 1, length(MACRO_ID)) <> MACRO_ID) then begin
//				result := result + s + ACAPO + str_SQL;
				result := s + ACAPO + str_SQL;
				break
			end;

			i := pos('=',s);
			if (i = 0) then raise exception.create('Dichiarazione di macro priva del segno di assegnazione');
			j := length(macro);
			setLength(macro, j+1);//macro[j] := cl_macro.create;
			macro[j].str_id := uppercase(togliblanks(copy(s, 1, i-1)));
			macro[j].str_value := copy(s, i+1, MAXINT);
			// applico al valore della macro eventuali macro definite precedentemente
//			for i := 0 to high(macro) do sostituisci(result,macro[i].str_id,macro[i].str_value, TRUE);      ** fino a 2009-02-11, but it was wrong
			for i := 0 to high(macro) do sostituisci(str_SQL, macro[i].str_id, macro[i].str_value, TRUE);
			sort_macros    // ordino le macro, per essere sicuro che non ci siano confusioni tra macro simili
		end;

		for i := 0 to high(macro) do sostituisci(result, macro[i].str_id, macro[i].str_value, TRUE);
		result := togli_ACAPO_finali(result)
	finally
//		for i := 0 to high(macro) do macro[i].free;
		macro := NIL
	end
//	*if (s <> result) then runtime_debug(,'sostituzione macro (' + get_section_name + ')',TRUE); {$endif}
end;

function accept_future_versions : boolean;
// rende TRUE se il programma è istruito per leggere files di versioni successive a quella attuale dell'eseguibile
begin
	result := {$ifdef DLL} FALSE {$else} is_key_down(VK_SHIFT) AND NOT is_key_down(VK_CONTROL) {$endif}
end;

function label_IO_ultima_posizione_stampa(str_printer, str_formato : string;var i_pos : smallint;bo_read : boolean) : boolean;
const REGISTRY_LAST_POS = 'ultima';
var r : TFRegistry;
begin
//	r := NIL;
	result := TRUE;
	try
		if bo_read then i_pos := 0;		// default
		if NOT globale.bo_label_registra_ultima_posizione then exit;
//		if NOT (globale.tiporeport in LABEL_TYPES) then exit;
		r := TFRegistry.create('software\galateo\formati\' + coalesce(str_formato,'default') + '\' + str_printer, NOT bo_read, HKEY_CURRENT_USER, bo_read);
		if bo_read then i_pos := r.ReadInteger(REGISTRY_LAST_POS) else r.WriteInteger(REGISTRY_LAST_POS, i_pos);
		r.free
	except
		result := FALSE
	end
end;

function label_write_ultima_posizione_stampa(str_printer, str_formato : string;i_pos : smallint) : boolean;
begin
	if globale.bo_label_registra_ultima_posizione then
		result := label_IO_ultima_posizione_stampa(str_printer, str_formato, i_pos, FALSE)
	else result := TRUE
end;

function label_read_ultima_posizione_stampa(str_printer, str_formato : string;var i_pos : smallint) : boolean;
begin
	result := label_IO_ultima_posizione_stampa(str_printer, str_formato, i_pos, TRUE)
end;

function load_lingue(it : TStrings;bo_uppercase : boolean = FALSE) : boolean;
begin
	try
//		if (globale.xxdb_galateo <> NIL) AND (globale.xxdb_galateo.DatabaseName <> '')
		if (globale.phisical_system_database <> NIL) AND (globale.phisical_system_database.DatabaseName <> '')
			then load_SQL_items(globale.phisical_system_database.DatabaseName,
				'SELECT ' + TBL_LNG_STR_CODICE + ' FROM ' + TBL_LINGUE + ' ORDER BY ' + TBL_LNG_I_POS_TRADUZIONE + ',' + TBL_LNG_STR_CODICE,
					TBL_LNG_STR_CODICE, it, FALSE);
		if bo_uppercase then for var i : smallint := 0 to it.Count-1 do it[i] := uppercase(it[i]);
		result := TRUE
	except
		result := FALSE
	end
end;

{$ifdef GALATEO_EXE}

	function load_lingua_items(it : TStrings;context_mode : lingua_context_set = [];bo_uppercase : boolean = FALSE) : boolean;
	// vengono caricati gli items linguistici secondo la modalità specificata da CONTEXT_MODE; se CONTEXT_MODE è [], vengono caricati TUTTI gli IDs
	var str_where : string;
	begin
		try
			if (globale.phisical_system_database <> NIL) AND (globale.phisical_system_database.DatabaseName <> '') then begin

				if (LCT_SELECTED_CONTEXT in context_mode) AND (globale.str_lingua_contesto <> '') then
					str_where := str_where + TBL_TDL_STR_ID_CONTESTO + '=' + globale.str_lingua_contesto.QuotedString + ' OR ';
				if (LCT_OTHER_CONTEXTS in context_mode) then
					str_where := str_where + '(' + TBL_TDL_STR_ID_CONTESTO + '!=' + globale.str_lingua_contesto.QuotedString +
						' AND ' + TBL_TDL_STR_ID_CONTESTO + '!='''') OR ';
				if (LCT_GENERIC in context_mode) then
					str_where := str_where + TBL_TDL_STR_ID_CONTESTO + '='''' OR ';
				if (str_where <> '') then str_where := ' WHERE ' + copy(str_where, 1, length(str_where) - 4);

				load_SQL_items(globale.phisical_system_database.DatabaseName,
					'SELECT ' + '(if ' + TBL_TDL_STR_ID_CONTESTO + '='''' then lower(' + TBL_TDL_STR_CODICE + ') else upper(' + TBL_TDL_STR_CODICE + ') endif)' +
						' FROM ' + TBL_TRADUZIONI_LINGUA +
					str_where +
					' ORDER BY ' + TBL_TDL_STR_CODICE, {TBL_TDL_STR_CODICE}'', it, FALSE);
				if bo_uppercase then for var i : smallint := 0 to it.Count-1 do it[i] := uppercase(it[i])
			end;
			result := TRUE
		except
			result := FALSE
		end
	end;

	function load_lingua_contesti_items(it : TStrings;bo_uppercase : boolean = FALSE) : boolean;
	begin
		try
			if (globale.phisical_system_database <> NIL) AND (globale.phisical_system_database.DatabaseName <> '')
				then load_SQL_items(globale.phisical_system_database.DatabaseName,
					'SELECT DISTINCT ' + TBL_TDL_STR_ID_CONTESTO + ' FROM ' + TBL_TRADUZIONI_LINGUA +
					' ORDER BY ' + TBL_TDL_STR_ID_CONTESTO, TBL_TDL_STR_ID_CONTESTO, it, FALSE);
			result := TRUE
		except
			result := FALSE
		end
	end;

{$endif GALATEO_EXE}

{$ifdef DEBUG}
	procedure check_index(i : integer;str : string;i_min,i_max : integer);
	begin
		assert((i >= i_min) AND (i <= i_max),'PAGES.' + str + ': valore scorretto (' + i.ToString + '/' + i_max.ToString + ')')
	end;
{$endif}

function check_link_utente(s : string;pt_str_filename : string_punt = NIL;pt_str_descrizione : string_punt = NIL) : boolean;
{ analizza la stringa s e ne estrae il contenuto caricandolo su STR_FILENAME e STR_DESCRIZIONE; rende TRUE se la sintassi è corretta, FALSE altrimenti;
  S può contenere un FILENAME oppure una struttura del tipo "DESCRIZIONE <FILENAME>" }
begin
	s := togliblanks(s);

	result := TRUE;
	var i : smallint := pos('<', s);
	if (i <> 0) AND (copy(s, length(s), 1) <> '>') then result := FALSE;

	if result AND (i <> 0) then begin
		if (pt_str_descrizione <> NIL) then pt_str_descrizione^ := copy(s, 1, i-1);
		if (pt_str_filename <> NIL) then pt_str_filename^ := togliblanks(copy(s, i+1, length(s) - i - 1))
	end
	else begin
		if (pt_str_descrizione <> NIL) then pt_str_descrizione^ := s;
		if (pt_str_filename <> NIL) then pt_str_filename^ := s
	end
end;

function XML_commento(str_header, str_text : string;bo_start : boolean;bo_ACAPO_after : boolean = TRUE) : string;
begin
	if (str_header + str_text = '') then result := ''
	else result := '<!-- ' +
		ifs(str_header, '[' + str_header + '] ') +
		ifs(str_text, str_text + ' ') +
		ifs(bo_start, '(inizio)', '(fine)') +
		' -->' + ifs(bo_ACAPO_after, ACAPO)
end;

const
	IBAN_LEN_SIGLA_STATO = 2;		// le prime 2 lettere rappresentano lo stato
{	IBAN_SYMBOL_CIN = 'K';
	IBAN_SYMBOL_BANCA = 'B';
	IBAN_SYMBOL_FILIALE = 'S';
	IBAN_SYMBOL_CONTO = 'C'; }
	IBAN_STATI_NUMBER = 50;
	IBAN_FORMATS : array[0..IBAN_STATI_NUMBER-1] of string = (	// per il controllo al momento è usata solo la lunghezza dell'IBAN nazionale; ma non è escluso che in futuro venga usato anche il formato in dettaglio
		'ITkk ABBB BBCC CCCX XXXX XXXX XXX',         // Italia (27) ITkk ABBB BBCC CCCX XXXX XXXX XXX            IT = codice del paese, kk = cifre di controllo dell'IBAN o CIN EUR, A = codice CIN BBAN o CIN IT (lettera di controllo, acronimo di "Control Internal Number"), BBBBB = ABI (codice della banca), CCCCC = CAB (codice della filiale), e gli ultimi 12 caratteri rappresentano il numero del conto corrente con tanti zeri iniziali quanti ne mancano per arrivare alla lunghezza di dodici caratteri (es.: CC: 12345678 IBAN: ITkk ABBB BBCC CCC0 0001 2345 678). Alcune banche sostituiscono con le lettere CC i primi due zeri del conto corrente (es.: CC: 1234   IBAN: ITkkABBBBBCCCCCCC0000001234)
		'ALkk BBBB SSSK CCCC CCCC CCCC CCCC',        // Albania (28) ALkk BBBB SSSK CCCC CCCC CCCC CCCC          B = banca, S = filiale, C = numero conto corrente, K=numero di controllo
		'ADkk BBBB SSSS CCCC CCCC CCCC',             // Andorra (24) ADkk BBBB SSSS CCCC CCCC CCCC               B = banca, S = codice banca, C = numero conto corrente
		'SAkk BBCC CCCC CCCC CCCC CCCC',             // Arabia Saudita (24) SAkk BBCC CCCC CCCC CCCC CCCC        B = banca, C = numero conto corrente
		'ATkk BBBB BCCC CCCC CCCC',                  // Austria (20) ATkk BBBB BCCC CCCC CCCC                    B = banca, C = numero conto corrente
		'BEkk BBBC CCCC CCKK',                       // Belgio (16) BEkk BBBC CCCC CCKK                          B = banca, C = numero conto corrente, K = numero di controllo
		'BAkk BBBS SSCC CCCC CoKK',                  // Bosnia ed Erzegovina (20) BAkk BBBS SSCC CCCC CoKK       B = banca, S = sort code, C = numero conto corrente, K = numero di controllo
		'BGkk BBBB SSSS DDCC CCCC CC',               // Bulgaria (22) BGkk BBBB SSSS DDCC CCCC CC                B = codice banca alfanumerico (prime 4 lettere codice SWIFT), S = numero di filiale (BAE), D = tipo conto numerico, C = conto corrente alfanumerico (dal 5 giugno 2006)
		'HRkk BBBB BBBC CCCC CCCC C',                // Croazia (21) HRkk BBBB BBBC CCCC CCCC C                  B = banca, C = numero conto corrente
		'CYkk BBBS SSSS CCCC CCCC CCCC CCCC',        // Cipro (28) CYkk BBBS SSSS CCCC CCCC CCCC CCCC            B = banca, S = codice banca, C = numero conto corrente
		'CZkk BBBB SSSS SSCC CCCC CCCC',             // Repubblica Ceca (24) CZkk BBBB SSSS SSCC CCCC CCCC       B = banca, S = codice banca, C = numero conto corrente
		'DKkk BBBB CCCC CCCC CC',                    // Danimarca (18) DKkk BBBB CCCC CCCC CC                    B = banca, C = numero conto corrente
		'EEkk BBSS CCCC CCCC CCCK',                  // Estonia (20) EEkk BBSS CCCC CCCC CCCK                    B = banca, S = sort code, C = numero conto corrente, K = numero di controllo
		'FIkk BBBB BBCC CCCC CK',                    // Finlandia (18) FIkk BBBB BBCC CCCC CK                    B = banca, numero filiale e tipo conto corrente, C = numero conto corrente, K = numero di controllo
		'FRkk BBBB BGGG GGCC CCCC CCCC CKK',         // Francia (27) FRkk BBBB BGGG GGCC CCCC CCCC CKK           B = banca, G = codice sportello (filiale), C = numero conto corrente, K = chiave RIB.
		'GEkk BBCC CCCC CCCC CCCC CC',               // Georgia (22) GEkk BBCC CCCC CCCC CCCC CC                 B = banca, C = numero conto corrente
		'DEkk BBBB BBBB CCCC CCCC CC',               // Germania (22) DEkk BBBB BBBB CCCC CCCC CC                B = sort code (Bankleitzahl/BLZ = codice di avviamento bancario), C = numero conto corrente (l'ultima cifra e la chiave di controllo)
		'GIkk BBBB CCCC CCCC CCCC CCC',              // Gibilterra (23) GIkk BBBB CCCC CCCC CCCC CCC             B = first part of BIC, C = numero conto corrente
		'GRkk BBB BBBB CCCC CCCC CCCC CCCC',         // Grecia (27) GRkk BBB BBBB CCCC CCCC CCCC CCCC            K = numeri di controllo, B = codice banca e numero filiale, C = numero conto corrente
		'GLkk BBBB CCCC CCCC CC',                    // Groenlandia (18) GLkk BBBB CCCC CCCC CC                  Uguale alla Danimarca eccetto il codice del paese.
		'ISkk BBBB SSCC CCCC XXXX XXXX XX',          // Islanda (26) ISkk BBBB SSCC CCCC XXXX XXXX XX            B = banca, S = codice banca, C = numero conto corrente, X = numero di identificazione nazionale del titolare.
		'FOkk BBBB CCCC C7CCC CC',                   // Isole Fær Øer (18) FOkk BBBB CCCC CCCC CC                Uguale alla Danimarca eccetto il codice del paese.
		'IEkk AAAA BBBB BBCC CCCC CC',               // Irlanda (22) IEkk AAAA BBBB BBCC CCCC CC                 I primi 4 caratteri alfanumerici sono la parte iniziale del codice SWIFT. A seguire il codice banca di 6 cifre e il numero conto corrente di 8 cifre, entrambi numerici
		'ILkk BBB NNN CCCCCCCCCCCCC',                // Israele (23) ILkk BBB NNN CCCCCCCCCCCCC                  kk = numero di controllo 2 cifre, B = codice banca 3 cifre, N = codice filiale 3 cifre, C = numero conto corrente 13 cifre (di solito 6 zeri seguiti da un numero di 7 cifre).
		'LVkk BBBB CCCC CCCC CCCC C',                // Lettonia (21) LVkk BBBB CCCC CCCC CCCC C                 Le prime quattro cifre sono le stesse come le prime quattro cifre del codice della Banca SWIFT e le 13 cifre dopo che sono il numero del conto individuale (e possono includere sia lettere che numeri).
		'LBkk BBBB CCCC CCCC CCCC CCCC CCCC',        // Libano (28) LBkk BBBB CCCC CCCC CCCC CCCC CCCC           B = banca, C = numero conto corrente
		'LIkk BBBB BCCC CCCC CCCC C',                // Liechtenstein (21) LIkk BBBB BCCC CCCC CCCC C            Uguale alla Svizzera eccetto il codice del paese.
		'LTkk BBBB BCCC CCCC CCCC',                  // Lituania (20) LTkk BBBB BCCC CCCC CCCC                   B = banca, C = numero conto corrente
		'LUkk BBBC CCCC CCCC CCCC',                  // Lussemburgo (20) LUkk BBBC CCCC CCCC CCCC                B = banca, C = numero conto corrente
		'MKkk BBBC CCCC CCCC CKK',                   // Repubblica di Macedonia (19) MKkk BBBC CCCC CCCC CKK     B = banca, C = numero conto corrente, K = cifre di controllo
		'MTkk BBBB SSSS SCCC CCCC CCCC CCCC CCC',    // Malta (31) MTkk BBBB SSSS SCCC CCCC CCCC CCCC CCC        B = prima parte del BIC, S = sort code, C = numero conto corrente
		'MUkk BBBB BBSS CCCC CCCC CCCC CCCC CC',     // Mauritius (30) MUkk BBBB BBSS CCCC CCCC CCCC CCCC CC     B = prima parte del BIC, S = sort code, C = numero conto corrente
		'MCkk BBBB BGGG GGCC CCCC CCCC CKK',         // Monaco (27) MCkk BBBB BGGG GGCC CCCC CCCC CKK            Uguale alla Francia eccetto il codice del paese.
		'MEkk BBBC CCCC CCCC CCCC KK',               // Montenegro (22) MEkk BBBC CCCC CCCC CCCC KK              kk = cifre IBAN, B = codice banca, C = numero conto corrente, KK = cifre di controllo.
		'NOkk BBBB CCCC CCK',                        // Norvegia (15) NOkk BBBB CCCC CCK                         B = banca, C = numero conto corrente, K = cifra di controllo “modulo-11”
		'NLkk BBBB CCCC CCCC CC',                    // Paesi Bassi (18) NLkk BBBB CCCC CCCC CC                  I primi 4 caratteri alfabetici rappresentano una banca e le ultime dieci cifre un conto.
		'PLkk BBBB BBBk CCCC CCCC CCCC CCCC',        // Polonia (28) PLkk BBBB BBBk CCCC CCCC CCCC CCCC          B = banca (1-3 Bank code, 4-7 filiale), C = numero conto corrente, kk = cifre di controllo. Non ci sono lettere nel codice. Il singolo "k" dopo il codice bancario è la cifra di controllo ora ridondante dell'ex sistema, conservato in IBAN.
		'PTkk BBBB BBBB CCCC CCCC CCCK K',           // Portogallo (25) PTkk BBBB BBBB CCCC CCCC CCCK K          B = banca (Banca 1-4, 5-8 filiale; alcune banche non identificano il filiale e utilizzano “0000” per cifre 5-8), C = numero conto corrente, K = cifre di controllo. In realtà, dovuta al fatto che il portoghese BBAN utilizza il checksum di convalida stesso come IBAN (ISO 7064 calcolo mod 97-10), l'IBAN portoghese inizia sempre da PT50, seguito dal BBAN 21 cifre (o NIB, Número de Identificação Bancária).
		'GBkk BBBB SSSS SSCC CCCC CC',               // Regno Unito (22) GBkk BBBB SSSS SSCC CCCC CC             B = codice banca alfabetico, S = sort code (spesso un filiale specifico), C = numero conto corrente
		'ROkk BBBB CCCC CCCC CCCC CCCC',             // Romania (24) ROkk BBBB CCCC CCCC CCCC CCCC               I primi 4 caratteri alfanumerici rappresentano la Banca; secondo la regola stabilita dalla Banca nazionale rumena, il codice BBBB deve essere lo stesso con i primi 4 caratteri del codice identificativo della banca. Gli ultimi 16 rappresentano la filiale di banca specifica e un conto, alcun modo la banca decide di combinare (in genere i primi 4 tra i 16 identificano il filiale). Alcune banche includono l'identificatore di valuta ISO 4217 da qualche parte nel nome del conto.
		'SMkk ABBB BBCC CCCX XXXX XXXX XXX',         // San Marino (27) SMkk ABBB BBCC CCCX XXXX XXXX XXX        Uguale all'Italia eccetto per il codice del paese
		'RSkk BBBC CCCC CCCC CCCC KK',               // Serbia (22) RSkk BBBC CCCC CCCC CCCC KK                  B = bank code, C = ? di account, K = cifre di controllo[3]
		'SKkk BBBB SSSS SSCC CCCC CCCC',             // Slovacchia (24) SKkk BBBB SSSS SSCC CCCC CCCC            B = banca, S = sort code, C = numero conto corrente
		'SIkk BBBB BCCC CCCC CKK',                   // Slovenia (19) SIkk BBBB BCCC CCCC CKK                    Le prime 2 cifre BB rappresentano una banca, le successive 3 il filiale. Le ultime due cifre (KK) sono le cifre di controllo. Le cifre di controllo IBAN
		'ESkk BBBB GGGG KKCC CCCC CCCC',             // Spagna (24) ESkk BBBB GGGG KKCC CCCC CCCC                B = bank code, G=numero ufficio/filiale, K=Cifre di controllo, C = numero conto corrente
		'SEkk BBBB CCCC CCCC CCCC CCCC',             // Svezia (24) SEkk BBBB CCCC CCCC CCCC CCCC                Le lettere “B” rappresentano il codice banca e le lettere “C” il numero di conto
		'CHkk BBBB BCCC CCCC CCCC C',                // Svizzera (21) CHkk BBBB BCCC CCCC CCCC C                 B = bank code, C = numero conto corrente
		'TRkk BBBB BRCC CCCC CCCC CCCC CC',          // Turchia (26) TRkk BBBB BRCC CCCC CCCC CCCC CC            Il numero totale di caratteri alfanumerici, compreso il codice del paese e le cifre di controllo è 26. Le prime 5 cifre rappresentano una banca. Il successivo carattere alfanumerico, riservato per un utilizzo futuro, è impostato a zero. I seguenti 16 caratteri alfanumerici rappresentano la filiale di banca specifici e un conto. La data di inizio di emissione dell'IBAN turco era il 1º settembre del 2005.[4].
		'TNkk BBBB BCCC CCCC CCCC CCCC',             // Tunisia (24) TNkk BBBB BCCC CCCC CCCC CCCC               B = bank code, C = numero conto corrente
		'HUkk BBBB BBBC CCCC CCCC CCCC CCCC');       // Ungheria (28) HUkk BBBB BBBC CCCC CCCC CCCC CCCC         B = bank code, C = numero conto corrente

function galateo_check_IBAN(str_IBAN : string;pt_str_error_message : string_punt = NIL) : boolean;
// versione generica del controllo IBAN; JOLLY ha funzione più specifiche
begin
	result := FALSE;

	if (str_IBAN = '') then begin result := TRUE;exit end;	// se blank, IBAN evidentente non compilato
	if (length(str_IBAN) < 10) then begin
		if (pt_str_error_message <> NIL) then pt_str_error_message^ := 'IBAN troppo corto (' + str_IBAN + ')';
		exit
	end;

	if (pt_str_error_message <> NIL) then pt_str_error_message^ := '';
	str_IBAN := uppercase(sostituisci(str_IBAN, ' ', ''));		// maiuscolo e senza spazi

	for var i : smallint := 0 to high(IBAN_FORMATS) do begin
		if (copy(str_IBAN, 1, IBAN_LEN_SIGLA_STATO) <> copy(IBAN_FORMATS[i], 1, IBAN_LEN_SIGLA_STATO)) then continue;

		var str_formato := IBAN_FORMATS[i];
		str_formato := uppercase(sostituisci(str_formato, ' ', ''));		// maiuscolo e senza spazi
		if (length(str_IBAN) <> length(str_formato)) then begin
			if (pt_str_error_message <> NIL) then pt_str_error_message^ := 'lunghezza IBAN errata (' + str_IBAN + ')';
			exit
		end;

		result := check_international_IBAN(str_IBAN);
		exit
	end
end;

{$ifNdef DLL}
	function check_printer_size_constraints(father : TForm;printer_size_constraints : printer_size_constraints_data_type;err_msg : cl_validation = NIL) : boolean;
	const ERROR_MSG = 'Vincoli dimensione pagina stampante non corretti o incompatibili';
	begin
		result := TRUE;
		with printer_size_constraints do begin
			if (i_min_width_mm > i_max_width_mm) AND (i_max_width_mm <> 0) then result := FALSE;
			if (i_min_height_mm > i_max_height_mm) AND (i_max_height_mm <> 0) then result := FALSE
		end;
		if NOT result then begin
			if (err_msg = NIL) then MessageBBox(father, ERROR_MSG, MBOX_CAPTION, MB_ICONSTOP)
			else validation_add(err_msg, ERROR_MSG, TRUE)
		end
	end;
{$endif}

initialization
	galateo_initialization_debug('proc');
	{$ifndef DLL} check_init {$endif}
finalization
	{$ifdef DEBUG}
//		CCI(i_validazione, 'cl_validazione', 'dich.pas');
//		CCI(i_store_values, 'cl_store_value', 'proc.pas');
//		CCI(i_logical_page_info, 'cl_logical_page_info', 'global.pas');
//		CCI(i_global, 'Tglobale', 'global.pas')
	{$endif}
	galateo_finalization_debug('proc')
end.
