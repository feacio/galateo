unit GAPP;		//* GAPP: Gestione Automatica Progressivi di Pagina -- niente a che fare con l'omonima sarl

{$I defines}
{$ifNdef CASA} *** {$endif}		// solo runtime (no editor)

interface

uses SysUtils, Windows, VCL.Forms,
	Gdich, FDB;

function GAPP_init : boolean;		// da chiamare all'inizio della stampa
function GAPP_close : boolean;	// da chiamare dopo la fine della stampa

function get_numero_progressivo_pagina_1B(i_pagina_logica_1B : logical_page_type) : ph_page_type;	// rende il numero progressivo della pagina corrente
function check_progressivi_pagina(father : TForm) : boolean;
function SQL_save_progressivi_pagina(father : TForm) : boolean;

implementation

uses Fcommons, FAssert, FXStrings, FStrings, FErrMsg, FSQLsoft, input_dialog, FMessage,
	galateo_debug, Gun, proc, objsx, pages, print_types;

type
	cl_page_values = class		// valori caratteristici di una pagina stampata
		str_tipo_progressivo : string;
		i_esercizio : smallint;
		str_dt_riferimento : string;
		str_operatore : string;
		str_first_record_database, str_last_record_database : string;
		constructor create(i_logical_page_1B : logical_page_type);
		{$ifdef DEBUG} destructor free; {$endif}
		function get_SQL_where_base : string;
	end;

	cl_GAPP_sequenza = class;
	cl_GAPP_page = class
		i_logical_page_1B, i_logical_page_ZB : logical_page_type;		// valore necessario, perchè non è detto che le pagine della stessa sequenza siano tutte sulla stessa pagina logica
		i_virtual_page_1B, i_virtual_page_ZB : ph_page_type;				// pagina fisica di stampa
		i_progressivo_pagina : ph_page_type;		// numero progressivo di pagina assegnato alla pagina fisica
		str_first_record, str_last_record : string;
		str_first_record_database, str_last_record_database : string;
		str_operatore : string;
		str_dt_riferimento : string;
		constructor xcreate(pp : cl_print_page;pv : cl_page_values;i_logical_page_1B : logical_page_type;i_progressivo_pagina : ph_page_type);
		{$ifdef DEBUG} destructor free; {$endif}
		procedure save_SQL(str_databasename : string);
		procedure update_values(pp : cl_print_page);
	end;

	cl_GAPP_sequenza = class		// sequenza di pagine con lo stesso TIPO_PROGRESSIVO (sulla stessa numerazione)
		str_tipo_progressivo : string;
		i_esercizio : smallint;
		pages : array of cl_GAPP_page;
		bo_read_from_database : boolean;		// TRUE se sono stati letti records da database
		bo_creati_progressivi : boolean;		// TRUE se sono stati creati progressivi
		constructor xcreate(pv : cl_page_values);
		destructor free;
		procedure add_page(pp : cl_print_page;i_logical_page_1B : logical_page_type;
			pv : cl_page_values;i_virtual_page_1B : ph_page_type;bo_new_progressivo : boolean);
		function get_page(i_virtual_page_1B : ph_page_type) : cl_GAPP_page;
		procedure save_SQL(str_databasename : string);
	end;

	cl_GAPP = class
		sequenze : array of cl_GAPP_sequenza;
		bo_errore_generazione : boolean;	// si è verificato un errore durante la generazione dei progressivi
		qry : TFquery;	// liberamente utilizzabile per le varie operazioni della pagina
		function get_numero_pagina(pp : cl_print_page;i_logical_page_1B : logical_page_type;pv : cl_page_values) : ph_page_type;
		constructor create;
		destructor free;
		function load_from_database(pv : cl_page_values;i_last_page_read : ph_page_type = 0) : ph_page_type;
		function get_page(i_virtual_page_1B : ph_page_type) : cl_GAPP_page;
		function get_sequenza(i_virtual_page_1B : ph_page_type) : cl_GAPP_sequenza;
	end;

var
	GX : cl_GAPP;
	{$ifdef DEBUG} i_GAPP, i_GAPP_sequenza, i_GAPP_page, i_page_values : integer; {$endif}

// -----------------------------------------------------------------------------

function get_print_value(sec : cl_print_section;str_object : string;i_logical_page_1B : logical_page_type) : string;
// rende il valore associato all'oggetto STR_OBJECT sulla pagina correntemente attiva (ovvero quella che sta essendo stampata)
begin
	result := '';
	var field : cl_print_campo := NIL;
	var i : obj_index_type := name2index(str_object, GAPP_OBJS, FALSE, i_logical_page_1B);
	if (i <> 0) AND (sec <> NIL) then begin	// sec può essere NIL
		field := sec.get_record(i);
		if (field = NIL) AND (sec.next <> NIL) then field := sec.next.get_record(i)
	end;
	if (field = NIL) OR (field.lp_value = NIL) then begin
		str_object := '$' + str_object;
//		if pages.sections(1).interpreta_string(str_object,TRUE,FALSE) then result := str_object
		if pages.sections_ZB(0).interpreta_string(str_object, {stampa_vera}TRUE, {check_errors}FALSE) then result := str_object
	end
	else result := strpas(field.lp_value)
end;

// -----------------------------------------------------------------------------

constructor cl_page_values.create(i_logical_page_1B : logical_page_type);
begin
	{$ifdef DEBUG} inc(i_page_values); {$endif}
	var lp : cl_logical_page_info := get_logical_page_ZB(i_logical_page_1B - 1);
	str_tipo_progressivo := get_print_value(NIL, lp.str_GAPP_obj_tipo_progressivo, i_logical_page_1B);
	i_esercizio := strtoint(get_print_value(NIL, lp.str_GAPP_obj_esercizio, i_logical_page_1B));
	str_dt_riferimento := get_print_value(NIL, lp.str_GAPP_obj_dt_riferimento, i_logical_page_1B);
	str_operatore := get_print_value(NIL, lp.str_GAPP_obj_operatore, i_logical_page_1B)
end;

{$ifdef DEBUG}
destructor cl_page_values.free;
begin {$ifdef DEBUG} dec(i_page_values) {$endif} end;
{$endif}

function cl_page_values.get_SQL_where_base : string;
begin
	result := ' WHERE ' + TBL_PRS_STR_TIPO + '=' + str_tipo_progressivo.QuotedString + ' AND ' +
			TBL_PRS_I_ESERCIZIO + '=' + i_esercizio.ToString + ' '
end;

// ------------ cl_GAPP --------------------------------------------------------

constructor cl_GAPP.create;
begin
	{$ifdef DEBUG} inc(i_GAPP); {$endif}
//	qry := TFquery.create(NIL);qry.DatabaseName := globale.report_database.DatabaseName;qry.RequestLive := FALSE
	qry := create_query(NIL, globale.{$ifdef DLL}report_database{$else}system_database{$endif}.DatabaseName)
end;

destructor cl_GAPP.free;
begin
	for var i : ph_page_type := 0 to length(sequenze)-1 do sequenze[i].free;sequenze := NIL;
	if (qry <> NIL) then begin qry.free;qry := NIL end;
	{$ifdef DEBUG} dec(i_GAPP) {$endif}
end;

function cl_GAPP.get_numero_pagina(pp : cl_print_page;i_logical_page_1B : logical_page_type;pv : cl_page_values) : ph_page_type;
// rende il numero progressivo di pagina per la pagina indicata
begin
{$ifdef DEBUG}
	assert(get_logical_page_1B(i_logical_page_1B).has_progressivi_automatici(FALSE), 'pagina logica che non gestisce i progressivi automatici -- DJSH 9391');
{$endif}
	var i_virtual_page_1B : ph_page_type := pp.i_virtual_page_1B;

	// determino la sequenza cui appartiene la pagina in trattamento
	var i : ph_page_type := length(sequenze)-1;
	while (i >= 0) AND ((sequenze[i].str_tipo_progressivo <> pv.str_tipo_progressivo) OR (sequenze[i].i_esercizio <> pv.i_esercizio)) do dec(i);
	if (i = -1) then begin	// sequenza non esistente; la genero
		i := length(sequenze);setLength(sequenze,i+1);
		sequenze[i] := cl_GAPP_sequenza.xcreate(pv)
	end;
	var seq : cl_GAPP_sequenza := sequenze[i];

	// innanzitutto guardo se la pagina fisica è già stata associata ad un progressivo di pagina
	var page : cl_GAPP_page := seq.get_page(i_virtual_page_1B);
	if (page <> NIL) then begin	// progressivo trovato; i valori sono già salvati, non ho altro da fare
		result := page.i_progressivo_pagina;
		exit
	end;

	// quindi guardo se sul database esiste un riferimento alla pagina fisica indicata
	// se sono sulla prima pagina della sequenza prendo la prima pagina valida per i valori PV, altrimenti prendo la prima successiva all'ultima pagina letta
	if (seq.pages = NIL) then i := 0 else i := seq.pages[length(seq.pages)-1].i_progressivo_pagina;
	result := load_from_database(pv, i);

	var bo_new_progressivo := (result = 0);		// se non è stato trovato fino a qui, significa che il progressivo deve essere generato
	// vedo se è stata trattata (sulla stessa sequenza di numerazione) la pagina fisica precedente
{	if (result = 0) then begin		- COMMENTATO perchè caso particolare (più lento!) del successivo
		page := seq.get_page(i_virtual_page-1);
		if (page <> NIL) then result := page.i_progressivo_pagina + 1
	end; }

	// vedo se sulla stessa sequenza di numerazione esiste già una stata trattata una; prendo l'ultima pagina e la incremento
	if (result = 0) AND (seq.pages <> NIL) then
		result := seq.pages[length(seq.pages)-1].i_progressivo_pagina + 1;

	if (result = 0) then begin
		// determino il primo numero di pagina non usato
		qry.SQL.Text := 'SELECT FIRST * FROM ' + TBL_PROGRESSIVI_STAMPA + pv.get_SQL_where_base + ' ORDER BY ' + TBL_PRS_I_PAGINA + ' desc';
		qry.Active := TRUE;
		if NOT qry.Eof then result := qry.FindField(TBL_PRS_I_PAGINA).AsInteger + 1
	end;

	if (result = 0) then result := 1;	// nessuno dei casi precedenti: è la prima pagina per la sequenza di numerazione

	// registro la pagina sulla struttura delle pagine
	seq.add_page(pp, i_logical_page_1B, pv, result, bo_new_progressivo)
end;

function cl_GAPP.get_page(i_virtual_page_1B : ph_page_type): cl_GAPP_page;
begin
	for var i : smallint := 0 to length(sequenze)-1 do begin
		for var i_page : ph_page_type := 0 to length(sequenze[i].pages) - 1 do begin
			if (i_virtual_page_1B = sequenze[i].pages[i_page].i_virtual_page_1B) then begin
				result := sequenze[i].pages[i_page];
				exit
			end
		end
	end;
	result := NIL
end;

function cl_GAPP.get_sequenza(i_virtual_page_1B : ph_page_type): cl_GAPP_sequenza;
// rende la sequenza cui appartiene la pagina specificata; rende NIL se la sequenza non viene trovata
begin
	for var i : smallint := 0 to length(sequenze)-1 do begin
		result := sequenze[i];
		for var i_page : ph_page_type := 0 to length(result.pages) - 1 do
			if (i_virtual_page_1B = result.pages[i_page].i_virtual_page_1B) then exit
	end;
	result := NIL
end;

function cl_GAPP.load_from_database(pv : cl_page_values;i_last_page_read : ph_page_type = 0) : ph_page_type;
// carica da database la pagina con i valori PV e con numero di pagina > I_LAST_PAGE_READ; rende 0 se la pagina non esiste
begin
	result := 0;
	try
		qry.SQL.Text := 'SELECT FIRST * FROM ' + TBL_PROGRESSIVI_STAMPA +
			pv.get_SQL_where_base + ' AND ' + TBL_PRS_DT_RIFERIMENTO + '=' + pv.str_dt_riferimento.QuotedString +
			ifs(i_last_page_read <> 0,' AND ' + TBL_PRS_I_PAGINA + '>' + i_last_page_read.ToString) +
			' ORDER BY ' + TBL_PRS_I_PAGINA;
		qry.Active := TRUE;
		if NOT qry.Eof then begin	// record trovato
			result := qry.FindField(TBL_PRS_I_PAGINA).AsInteger;
			pv.str_first_record_database := qry.FindField(TBL_PRS_STR_ID_FIRST_RECORD).AsString;
			pv.str_last_record_database := qry.FindField(TBL_PRS_STR_ID_LAST_RECORD).AsString
		end
	except
		error_msg('Errore durante l''accesso al database', MBOX_CAPTION)
	end
end;

// ------------- cl_SEQUENZA ---------------------------------------------------

constructor cl_GAPP_sequenza.xcreate(pv : cl_page_values);
begin
	{$ifdef DEBUG} inc(i_GAPP_sequenza); {$endif}
	str_tipo_progressivo := pv.str_tipo_progressivo;
	i_esercizio := pv.i_esercizio
end;

destructor cl_GAPP_sequenza.free;
begin
	for var i : ph_page_type := 0 to length(pages)-1 do pages[i].free;pages := NIL;
	{$ifdef DEBUG} dec(i_GAPP_sequenza) {$endif}
end;

function cl_GAPP_sequenza.get_page(i_virtual_page_1B : ph_page_type): cl_GAPP_page;
// rende la pagina associata alla pagina fisica specificata; rende NIL se non trova la pagina in questione
begin
	for var i : ph_page_type := 0 to length(pages) - 1 do
		if (pages[i].i_virtual_page_1B = i_virtual_page_1B) then begin result := pages[i];exit end;
	result := NIL
end;

procedure cl_GAPP_sequenza.save_SQL(str_databasename : string);
begin
	for var i : ph_page_type := 0 to length(pages)-1 do pages[i].save_SQL(str_databasename)
end;

// -----------------------------------------------------------------------------

constructor cl_GAPP_page.xcreate(pp : cl_print_page;pv : cl_page_values;i_logical_page_1B : logical_page_type;i_progressivo_pagina : ph_page_type);
begin
	{$ifdef DEBUG} inc(i_GAPP_page); {$endif}
	self.i_logical_page_1B := i_logical_page_1B;self.i_logical_page_ZB := i_logical_page_1B - 1;
	self.i_virtual_page_1B := pp.i_virtual_page_1B;self.i_virtual_page_ZB := i_virtual_page_1B - 1;
	self.i_progressivo_pagina := i_progressivo_pagina;
	str_dt_riferimento := pv.str_dt_riferimento;str_operatore := pv.str_operatore;
	str_first_record_database := pv.str_first_record_database;str_last_record_database := pv.str_last_record_database
end;

{$ifdef DEBUG}
destructor cl_GAPP_page.free;
begin {$ifdef DEBUG} dec(i_GAPP_page) {$endif} end;
{$endif}

procedure cl_GAPP_page.update_values(pp : cl_print_page);
// carica su SELF i valori del primo e dell'ultimo record della pagina
begin
	var lp : cl_logical_page_info := get_logical_page_ZB(i_logical_page_ZB);
	var sec : cl_print_section := pp.sections;var last_dettaglio : cl_print_section := NIL;
	var bo_first := TRUE;
	// determino la sezione su cui si trova l'obj che mi interessa
	var i_record_section_1B : section_index_type := name2index(lp.str_GAPP_obj_record, [], FALSE, i_logical_page_1B);

	if (i_record_section_1B <> 0) then i_record_section_1B := xobjs(i_record_section_1B, i_logical_page_1B).ca.i_section_1B;
	while (sec <> NIL) do begin
		if (sec.i_section_1B = i_record_section_1B) then begin
			last_dettaglio := sec;
			if bo_first then begin		// il record sta per definizione sul DETTAGLIO
				bo_first := FALSE;
				str_first_record := get_print_value(sec, lp.str_GAPP_obj_record, i_logical_page_1B)
			end
		end;
		sec := sec.next
	end;
	if (last_dettaglio = NIL) then	// errore: nessun dettaglio trovato
		raise exception.create('Gestione automatica progressivi di pagina: impossibile reperire records sulla pagina');
	str_last_record := get_print_value(last_dettaglio, lp.str_GAPP_obj_record, i_logical_page_1B)
end;

procedure cl_GAPP_page.save_SQL(str_databasename : string);
var str_SQL : string;	//*
begin
	try
		var seq : cl_GAPP_sequenza := gx.get_sequenza(i_virtual_page_1B);
		str_SQL := 'INSERT INTO ' + TBL_PROGRESSIVI_STAMPA + '(' +
				TBL_PRS_STR_TIPO + ',' + TBL_PRS_I_ESERCIZIO + ',' + TBL_PRS_I_PAGINA + ',' +
				TBL_PRS_STR_ID_FIRST_RECORD + ',' + TBL_PRS_STR_ID_LAST_RECORD + ',' +
				TBL_PRS_STR_OPERATORE + ',' + TBL_PRS_DT_RIFERIMENTO + ')' +
			' VALUES (' +
				seq.str_tipo_progressivo.QuotedString + ',' + seq.i_esercizio.ToString + ',' +
				i_progressivo_pagina.ToString + ',' +
				str_first_record.QuotedString + ',' + str_last_record.QuotedString + ',' +
				str_operatore.QuotedString + ',' + str_dt_riferimento.QuotedString + ')';
		Gdebug_SQL(str_SQL, 'GAPP -- LP=' + i_logical_page_1B.ToString +
			'  VP=' + i_virtual_page_1B.ToString + '  PP=' + i_progressivo_pagina.ToString);
		exec_SQL(NIL, str_SQL, str_databasename)
	except
		error_msg('Errore durante la registrazione dei valori progressivi di pagina' + ACAPO2 + str_SQL, MBOX_CAPTION);
		raise
	end
end;

procedure cl_GAPP_sequenza.add_page(pp : cl_print_page;i_logical_page_1B : logical_page_type;
	pv : cl_page_values;i_virtual_page_1B : ph_page_type;bo_new_progressivo : boolean);
begin
	var i : ph_page_type := length(pages);setLength(pages, i+1);
	pages[i] := cl_GAPP_page.xcreate(pp, pv, i_logical_page_1B, i_virtual_page_1B);
	if bo_new_progressivo then bo_creati_progressivi := TRUE else bo_read_from_database := TRUE
end;

// -----------------------------------------------------------------------------

function GAPP_init : boolean;		// da chiamare all'inizio della stampa
begin
	GAPP_close;			// chiudo per re-inizializzare, eventualmente
	result := TRUE
end;

function GAPP_close : boolean;	// da chiamare dopo la fine della stampa
begin
	if (GX <> NIL) then begin GX.free;GX := NIL end;
	result := TRUE
end;

function get_numero_progressivo_pagina_1B(i_pagina_logica_1B : logical_page_type) : ph_page_type;
// rende il numero progressivo della pagina corrente
begin
	var pv : cl_page_values := NIL;
	var i_virtual_page_1B : ph_page_type := get_phisical_printing_page;
	if NOT get_logical_page_1B(i_pagina_logica_1B).has_progressivi_automatici(FALSE) then begin result := i_virtual_page_1B;exit end;

//	if (globale.fase_stampa <> FST_FORMATTING) then begin result := 0;exit end;
	var pp : cl_print_page := print_pages_1B[i_pagina_logica_1B];
	while (pp <> NIL) AND (pp.i_virtual_page_1B <> i_virtual_page_1B) do pp := pp.next;
	if (pp = NIL) then raise exception.create('Pagina fisica non trovata');	// mah? non dovrebbe capitare!

	if (GX = NIL) then GX := cl_GAPP.create;
	try
		pv := cl_page_values.create(i_pagina_logica_1B);
		result := GX.get_numero_pagina(pp, i_pagina_logica_1B, pv)
	finally
		if (pv <> NIL) then pv.free
	end
end;

// -----------------------------------------------------------------------------

function SQL_save_progressivi_pagina(father : TForm) : boolean;
{ esegue il salvataggio su database dei progressivi di pagina generati durante la stampa;
  rende TRUE in caso di successo, FALSE altrimenti }
label retry_password;
begin
	result := TRUE;
	if (GX = NIL) OR GX.bo_errore_generazione then exit;	// progressivi non gestiti, o errore che impedisce l'eventuale salvataggio

	var db : TFDatabase := NIL;var bo_definitiva := FALSE;
	try
//		init_Gdebug_SQL('GAPP', {dont_delete_file}TRUE);	// riapro l'eventuale sessione di DEBUG, che era già chiusa
		init_Gdebug_SQL(globale.str_filename, 'GAPP', {bo_delete_previous_file}FALSE);	// riapro l'eventuale sessione di DEBUG, che era già chiusa
		for var i_seq : logical_page_type := 0 to length(GX.sequenze)-1 do begin
			if NOT GX.sequenze[i_seq].bo_creati_progressivi then continue;

			if NOT bo_definitiva then begin
				if globale.bo_GAPP_ask_conferma_stampa_definitiva then begin
					if (MessageBBox(father.handle, 'La stampa eseguita deve essere considerata DEFINITIVA?', MBOX_CAPTION,
						MB_QUESTION_DEF2) <> IDYES) then exit;
					if (globale.str_GAPP_password_stampa_definitiva <> '') then begin
retry_password:
						var s := '';
						if NOT input_text_proc(father, father.Caption, 'Password per generazione stampa DEFINITIVA', s, 0, NIL, IDS_PASSWORD) then exit;
						if (uppercase(s) <> uppercase(globale.str_GAPP_password_stampa_definitiva)) then begin
							MessageBBox(father.handle, 'PASSWORD errata', MBOX_CAPTION);
							goto retry_password
						end
					end
				end;
				bo_definitiva := TRUE
			end;
			if (db = NIL) then begin
				globale.init_db_report(db,'GAPP');
				db.TransIsolation := tiDirtyRead;db.StartTransaction
			end;
			GX.sequenze[i_seq].save_SQL(db.DatabaseName)
		end;
		if (db <> NIL) then db.commit
	except
		error_msg(father, 'Errore durante il salvataggio dei progressivi di pagina', MBOX_CAPTION);
		if (db <> NIL) then try db.rollback except end;
		result := FALSE
	end;
	end_Gdebug_SQL;
	if (db <> NIL) then db.free;
	if result AND bo_definitiva {AND NOT globale.bo_GAPP_ask_conferma_stampa_definitiva} then
		MessageBBox(father, 'La stampa è stata considerata DEFINITIVA', MBOX_CAPTION)
end;

function check_progressivi_pagina(father : TForm) : boolean;
{ in relazione ai progressivi di pagina (GAPP) questa funzione svolge una duplice funzione:
	- se il report è originale (progressivi generati), assegna i valori del primo e ultimo record della pagina (che non erano sinora reperibili)
	  in funzione del prossimo eventuale salvataggio dei valori su database;
	- se il report è una ristampa verifica che il primo e l'ultimo record siano gli stessi di quelli della stampa originale;
  rende TRUE in caso di successo, FALSE se la stampa deve essere annullata }
const MSG_BASE = 'ATTENZIONE' + ACAPO2 + 'La versione originale di questa stampa era stata formattata in modo differente' + ACAPO2;
var
	str_messaggio : string;
	i_messaggi : smallint;

	procedure add_message(str_msg : string);
	begin
		inc(i_messaggi);
		if (str_messaggio = '') then str_messaggio := MSG_BASE + str_msg
	end;

begin
	result := TRUE;i_messaggi := 0;
	if (GX = NIL) then exit;	// progressivi non gestiti

	for var i_pagina_logica_1B : logical_page_type := 1 to get_ultima_pagina_logica do begin
		if NOT get_logical_page_1B(i_pagina_logica_1B).has_progressivi_automatici(FALSE) then continue;
		var pp : cl_print_page := print_pages_1B[i_pagina_logica_1B];
		while (pp <> NIL) do begin
			var page : cl_GAPP_page := GX.get_page(pp.i_virtual_page_1B);
			if (page = NIL) then raise exception.create('Pagina non trovata');
			page.update_values(pp);

			{ verifico la coerenza della formattazione;
			  meglio testare BO_READ_FROM_DATABASE, perchè gestisce il caso in cui siano semplicemente stati aggiunti records
			  alla fine della stampa (o più banalmente ridotto il numero di records per pagina): BO_CREATI_PROGRESSIVI sarebbe TRUE,
			  ma il controllo sarebbe comunque da eseguire e darebbe esito negativo!!! }
//			if (NOT GX.get_sequenza(pp.i_virtual_page).bo_creati_progressivi) then begin
			if GX.get_sequenza(pp.i_virtual_page_1B).bo_read_from_database then begin
{				if (pp.i_virtual_page < 3) then messageBBox(0,'pagina ' + inttostr(pp.i_virtual_page) + ACAPO2 +
					'first record=<' + page.str_first_record_database + '>    first record DB=<' + page.str_first_record + '>' + ACAPO2 +
					'last record=<' + page.str_last_record_database + '>    last record DB=<' + page.str_last_record + '>','XXXXXXXXXXXXXXXXX');{}
				if (page.str_first_record <> page.str_first_record_database) then
					add_message('la pagina ' + pp.i_virtual_page_1B.ToString + ' dovrebbe iniziare con il record <' +
						page.str_first_record_database + '> invece che con il record <' + page.str_first_record + '>');

				if (page.str_last_record <> page.str_last_record_database) then
					add_message('la pagina ' + pp.i_virtual_page_1B.ToString + ' dovrebbe finire con il record <' +
						page.str_last_record_database + '> invece che con il record <' + page.str_last_record + '>')
			end;
			pp := pp.next
		end;
	end;

	{ questo messaggio è ridondante, in quanto dovrebbe la sua presenza dovrebbe essere condizione perchè
	  vi siano altre differenze di formattazione; lo emetto comunque per completezza e garanzia }
	for var i_seq : smallint := 1 to length(GX.sequenze) - 1 do
		if GX.sequenze[i_seq].bo_creati_progressivi AND GX.sequenze[i_seq].bo_read_from_database
			then add_message('Vi sono progressivi di pagina sia generati sia letti dal database');

	result := (i_messaggi = 0);
	if NOT result then begin
		GX.bo_errore_generazione := TRUE;
		error_msg(father, str_messaggio +
			ifs(i_messaggi > 1, ACAPO2 + '(vi sono altre ' + (i_messaggi-1).ToString + ' differenze di impaginazione non visualizzate)'), father.Caption)
	end
end;

initialization
	galateo_initialization_debug('GAPP')
finalization
	galateo_finalization_debug('GAPP');
	{$ifdef DEBUG}
//		if (GX <> NIL) then begin GX.free;GX := NIL end;
		CCI(i_GAPP, {str_class_name} 'CL_GAPP', {source_file}'GAPP.pas');
		CCI(i_GAPP_page, {str_class_name} 'CL_GAPP_PAGE', {source_file}'GAPP.pas');
		CCI(i_page_values, {str_class_name} 'CL_PAGE_VALUES', {source_file}'GAPP.pas');
		CCI(i_GAPP_sequenza, {str_class_name} 'CL_GAPP_SEQUENZA', {source_file}'GAPP.pas')
	{$endif}
end.
