unit expint_base;

{$I defines}

interface

uses Sysutils, Classes, Math, VCL.ComCtrls,
	Gdich, Fcommons;

{$ifNdef DLL}
	const
		XML_COLOR = $00FFFFD5;
		EXPINT_COLOR = $00BBFFFF;
{$endif}

type
	// per semplificare la MOST_exportable() mi piacerebbe riordinare i valori come OEXP_NOT, OEXP_DEFAULT, OEXP_YES, ma bisogna riassegnare i dati letti da file ed è complicato (bisogna cambiare VERSIONE del file, che è sempre poco consigliabile)
	object_expint_mode_type = (			// indicazione di exportazione per gli OGGETTI (labels)
		OEXP_DEFAULT,		// eredita l'impostazione default in base al tipo di oggetto, alla modalità di visualizzazione, alle impostazioni della sezione di appartenenza
		OEXP_YES,
		OEXP_NOT);					// l'oggetto/la sezione non viene exportata, ma l'impostazione può (eventualmente) essere modificata a runtime
	section_expint_mode_type = (		// indicazione di exportazione per le SEZIONI
//		SEXP_DEFAULT,				// valore non applicabile -- ELIMINATO 2014-08-25 a partire dalla versione $0312
		SEXP_YES,
		SEXP_NOT,					// l'oggetto/la sezione non viene exportata, ma l'impostazione può (eventualmente) essere modificata a runtime
		SEXP_IMPOSSIBLE);			// l'exportazione per l'oggetto/la sezione è impossibile *** valore introdotto con la versione $0311
	expint_multiline_type = (		// export integrale: modalità di trattamento di testi che vanno su più righe
		EXPINTML_EXCEL,				// modalità adatta per Excel
		EXPINTML_ONLY_FIRST_LINE,	// considera solo la prima riga
		EXPINTML_NONE,					// non fa nulla (sostituisce gli acapo con la stringa STR_EXPINT_ACAPO)
		EXPINTML_APICI,				// racchiude la stringa tra apici SEMPLICI
		EXPINTML_DOPPI_APICI);		// racchiude la stringa tra apici DOPPI
{$ifndef DLL}
	const
		OEXP_DESCRIZIONE : array[object_expint_mode_type] of string = ('default', 'esporta', 'NON esporta');
//		SEXP_DESCRIZIONE : array[section_expint_mode_type] of string = ('esporta', 'NON esporta', 'disabilita');
		SEXP_DESCRIZIONE_YES = 'esporta';
//		SEXP_DESCRIZIONE_NOT = 'NON esporta';
		SEXP_DESCRIZIONE_NOT = 'a richiesta runtime';		// exporta solo su esplicita richiesta eseguita a runtime
		SEXP_DESCRIZIONE_IMPOSSIBLE = 'esclude exportazione';
//		SEXP_DESCRIZIONE : array[section_expint_mode_type] of string = ('esporta', 'NON esporta', 'esclude exportazione');
		SEXP_DESCRIZIONE : array[section_expint_mode_type] of string = (SEXP_DESCRIZIONE_YES, SEXP_DESCRIZIONE_NOT, SEXP_DESCRIZIONE_IMPOSSIBLE);
{$endif}

const
	EXPINT_SPECIAL_CHARS_DELETED = [#0..#27];
	{$ifndef DLL}
		EXPINT_DELETE_SPECIAL_CHARS_HINT = 'Elimina alcuni caratteri speciali che possono interferire con la formattazione del testo in formato tabellare (Excel e simili).' + ACAPO +
			'Se ad esempio il testo contiene dei caratteri "ACAPO" (CR/LF) un singolo record può occupare più righe (con il rischio di disallineare le colonne)' + ACAPO2 +
			'ATTENZIONE:' + ACAPO +
			'il trattamento può sovrapporsi alla modalità di esportazione "EXCEL" specificata sui singoli campi exportati.' + ACAPO +
			'questa opzione non riguarda il trattamento di caratteri estesi (Unicode e limitrofi) il cui trattamento viene eventualmente gestito attraverso la codifica UTF-8';
	{$endif}

type
	cl_expint_profilo = class;
	cl_expint_page = class;
	cl_expint_section = class;
	cl_expint_object = class;
	expint_profilo_array = array of cl_expint_profilo;
	expint_page_array = array of cl_expint_page;
	expint_section_array = array of cl_expint_section;
	expint_object_array = array of cl_expint_object;

	{ CL_EXPINT_PROFILO contiene le impostazioni di EXPORT, sia per INTEGRALE che per XML
	  in realtà, mentre esistono realmente plurimi profili di exportazione integrale, ad oggi l'esportazione XML è una sola,
	  e ciò che cambiano sono solo le opzioni complementari; volendo, quando sarà necessario, si dovrà procedere ad implementare
	  i profili XML multipli }

	cl_expint_profilo = class		// impostazioni di exportazione integrale di primo livello; questo oggetto è referenziato su TGLOBALE
		private
			bo_XML_phisical : boolean;				// se FALSE, si tratta di export integrale
			function get_export_integrale : boolean;
		public
			str_codice : string;				// codice univoco dell'exportazione integrale
			str_descrizione, str_note : string;
//			i_pos : smallint;			// posizione nell'ordine di presentazione; il primo formato di export è quello default
			bo_dont_show : boolean;	// TRUE se il profilo NON deve essere mostrato
			str_message_before, str_message_after, str_comando_specifico_default : string;
			target_default : export_integrale_target_type;
			writemode_default : file_writemode_type;
			EFAT_default_action : export_file_action_type;

			// opzioni specifiche per EXPINT -- EXPortazione INTegrale
			lo_expint_max_lines : integer;				// numero max di righe exportate
			expint_separatore : expint_separatore_type;
			expint_pages : expint_page_array;			// in effetti sono in numero fisso di MAX_PAGINE_LOGICHE (zero-based)
			bo_choose_expint_sections : boolean;		// scelta delle sezioni da exportare
			// opzioni XML
			str_XML_header : string;		// premesso a qualunque XML, anche alle info di debug
			str_XML_struttura : string;
			bo_encode_UTF8 : boolean;		// l'exportazione viene convertita in UTF8
			bo_delete_special_chars : boolean;	// elimina i caratteri speciali EXPINT_SPECIAL_CHARS_DELETED

			property bo_XML : boolean read bo_XML_phisical {$ifNdef DLL} write bo_XML_phisical {$endif};
			property bo_export_integrale : boolean read get_export_integrale;

			constructor create;
			destructor free;
			procedure assign(x : cl_expint_profilo);	// self := x
			procedure reset;
			{$ifndef DLL} function write(var f : text;i_profilo : expint_index_type;i_pagine_logiche : logical_page_type) : boolean; {$endif}
			function read(var f : text;i_profilo_ZB : expint_index_type;i_pagine_logiche : logical_page_type;wo_versione : word) : boolean;
			function get_descrizione(i_pos : smallint = 0): string;
	end;
	cl_expint_page = class		// impostazioni di EXPORTAZIONE INTEGRALE per la pagina logica; questo oggetto è referenziato su CL_EXPINT_PROFILO
		public
			bo_export_allowed : boolean;		// consente l'exportazione integrale sulla pagina
			str_sigla : string;

			// dati EXPORT INTEGRALE
			bo_print_headers, bo_print_pagina_logica, bo_print_sezione, bo_print_pagina_fisica, bo_print_record_number : boolean;	// nell'exportazione integrale scrive le informazioni indicate
			bo_blankrow_after_headers : boolean;
			expint_sections : expint_section_array;		// in effetti sono allocate in numero di MAX_SECTIONS
			// dati XML
			str_XML_struttura : string;
			{$ifdef DEBUG} create : smallint; {$endif}
			constructor ZB_create(i_page_ZB : logical_page_type);		// 0-based
			destructor free;
			procedure assign(x : cl_expint_page);	// self := x
			function get_expint_sigla : string;
			{$ifndef DLL} function write(var f : text;i_profilo : expint_index_type;i_page_ZB : logical_page_type) : boolean; {$endif}
			function read(var f : text;i_profilo_ZB : expint_index_type;i_page_ZB : logical_page_type;wo_versione : word) : boolean;
		private
			i_page_ZB : logical_page_type;		// 0-based
			procedure reset;
	end;
	cl_expint_section = class		// impostazioni di exportazione integrale per la sezione; questo oggetto è referenziato su CL_EXPINT_PAGE
		// opzioni export integrale
		expint_mode : section_expint_mode_type;
		expint_objs_default_mode : object_expint_mode_type;	// valore assegnato ai campi della sezione per cui vale (export_type = OEXP_DEFAULT)
		str_sigla : string;
		str_descrizione_runtime : string;
		i_shift_columns : smallint;				// sposta l'output della sezione di XX colonne; default 0
		bo_skip_on_continuazione : boolean;		// non exporta la ristampa della sezione qualora il record vada su più pagine
		bo_headers_colonne : boolean;
		// opzioni export XML
		bo_XML_allowed : boolean;
		str_struttura_XML : string;
		constructor create;
		destructor free;
		procedure assign(x : cl_expint_section);	// self := x
		procedure reset;
		{$ifndef DLL} function write(var f : text) : boolean; {$endif}
		function read(var f : text;i_profilo_ZB : expint_index_type;i_pagina_ZB : logical_page_type;wo_versione : word) : boolean;
	end;
	cl_expint_object = class			// impostazioni di exportazione integrale per il singolo oggetto; referenziato sui singoli oggetti
		i_pos : smallint;					// posizione di esportazione assegnata
		i_exec_pos : smallint;			// posizione esecutiva: determinata al momento della stampa (in funzione di I_POS, ma non solo)
		expint_mode : object_expint_mode_type;
		str_header : string;				// header per la colonna exportata
		i_skip_cols_before : byte;		// shifta la colonna verso destra di XXX colonne
		multiline : expint_multiline_type;	// modalità di trattamento testi che vanno su più righe
		str_acapo : string;				// stringa usata come 'LINE SEPARATOR' (acapo)
		str_tab : string;					// stringa usata in sostituzione del TABULATORE (BLANK equivale al trattamento default)
		constructor create;
		destructor free;
		procedure assign(source : cl_expint_object);	// self := x
		procedure reset;
		{$ifndef DLL} function write(var f : text) : boolean; {$endif}
		function read(var f : text;i_profilo_ZB : expint_index_type;i_pagina_ZB : logical_page_type;i_object_1B : obj_index_type;wo_versione : word) : boolean;
	end;

	{$ifndef DLL} procedure expint_profilo_array_assign(var target, source : expint_profilo_array); {$endif}
	procedure expint_profilo_load_items(it : TStrings;x : expint_profilo_array = NIL);
	procedure load_export_profiles_proc(lv : TListView;i_select_index : smallint = -1);

	procedure expint_profilo_array_free(var x : expint_profilo_array);
	function expint_profiles_count : expint_index_type;

	function get_export_target_XML(i_profilo : expint_index_type = -1) : boolean;
	function get_export_target_integrale(i_profilo : expint_index_type = -1) : boolean;

	function get_expint_profilo(i_profilo : expint_index_type = -1) : cl_expint_profilo; overload;
	function get_expint_profilo(str_descrizione : string) : cl_expint_profilo; overload;
	function get_expint_page_ZB(i_pagina_logica_ZB : logical_page_type) : cl_expint_page; overload;
	function get_expint_page_ZB(i_profilo : expint_index_type;i_pagina_logica_ZB : logical_page_type) : cl_expint_page; overload;
	function get_expint_section_ZB(i_pagina_logica_ZB : logical_page_type;i_sezione_ZB : section_index_type) : cl_expint_section; overload;
	function get_expint_section_ZB(i_profilo : expint_index_type;i_pagina_logica_ZB : logical_page_type;i_sezione_ZB : section_index_type) : cl_expint_section; overload;
//	function get_expint_object_ZB(i_pagina_logica_ZB : logical_page_type;i_object_1B : obj_index_type) : cl_expint_object; overload;
//	function get_expint_object_ZB(i_profilo : expint_index_type;i_pagina_logica_ZB : logical_page_type;i_object_1B : obj_index_type) : cl_expint_object; overload;

function MOST_exportable(a, b : object_expint_mode_type) : object_expint_mode_type;

implementation

uses FAssert, FXStrings, FStrings, FErrMsg,
	galateo_debug, Gun, objects, pages;

{$ifdef DEBUG} var i_expint_profilo, i_expint_page, i_expint_section, i_expint_object : integer; {$endif}

const
	BAD_EXPINT_PROFILO_PAGE_START = 'exPs';			// versione $0304 -- per errore identico tra PROFILO and PAGE
	BAD_EXPINT_PROFILO_PAGE_END = 'exPe';				// versione $0304 -- per errore identico tra PROFILO and PAGE
	BAD_EXPINT_OBJECT_START_END = 'exSo';				// versione $0304 - per errore identico tra Start e End

	EXPINT_PROFILO_START = 'exProf-s';
	EXPINT_PROFILO_END = 'exProf-e';
	EXPINT_PAGE_START = 'exPag-s';
	EXPINT_PAGE_END = 'exPag-e';
	EXPINT_SECTION_START = 'exSs';
	EXPINT_SECTION_END = 'exSe';
	EXPINT_OBJECT_START = 'exObj-s';
	EXPINT_OBJECT_END = 'exObj-e';

	EXPINT_ERROR_READING = 'errore durante la lettura delle impostazioni di exportazione integrale';

// cl_expint_profilo ---------------------------------------------------------

constructor cl_expint_profilo.create;
begin
	{$ifdef DEBUG} inc(i_expint_profilo); {$endif}
	setLength(expint_pages, MAX_PAGINE_LOGICHE);
	for var i : logical_page_type := 0 to MAX_PAGINE_LOGICHE-1 do expint_pages[i] := cl_expint_page.ZB_create(i);
	reset
end;

destructor cl_expint_profilo.free;
begin
	{$ifdef DEBUG} dec(i_expint_profilo); {$endif}
	for var i : logical_page_type := 0 to MAX_PAGINE_LOGICHE-1 do begin expint_pages[i].free;expint_pages[i] := NIL end;
	expint_pages := NIL
end;

function cl_expint_profilo.get_export_integrale : boolean; begin result := NOT bo_XML_phisical end;

procedure cl_expint_profilo.assign(x : cl_expint_profilo);		// self := x
begin
	bo_XML_phisical := x.bo_XML_phisical;
	str_codice := x.str_codice;
	str_descrizione := x.str_descrizione;
	str_note := x.str_note;
//	i_pos := x.i_pos;
	bo_dont_show := x.bo_dont_show;

	lo_expint_max_lines := x.lo_expint_max_lines;
	expint_separatore := x.expint_separatore;
	str_message_before := x.str_message_before;
	str_message_after := x.str_message_after;
	str_comando_specifico_default := x.str_comando_specifico_default;
	target_default := x.target_default;
	writemode_default := x.writemode_default;
	EFAT_default_action := x.EFAT_default_action;
	bo_choose_expint_sections := x.bo_choose_expint_sections;
	str_XML_header := x.str_XML_header;
	str_XML_struttura := x.str_XML_struttura;
	bo_encode_UTF8 := x.bo_encode_UTF8;
	bo_delete_special_chars := x.bo_delete_special_chars;
	for var i : logical_page_type := 0 to MAX_PAGINE_LOGICHE-1 do expint_pages[i].assign(x.expint_pages[i])
end;

procedure cl_expint_profilo.reset;
begin
	bo_XML_phisical := FALSE;
	str_codice := '';str_descrizione := '';str_note := '';
//	i_pos := 50;
	bo_dont_show := FALSE;
	lo_expint_max_lines := 0;expint_separatore := EIS_TAB;
	str_message_before := '';str_message_after := '';str_comando_specifico_default := '';
//	wtarget_default := low(zexport_integrale_target_type);
//	target_default := EITT_DEFAULT;
	target_default := low(export_integrale_target_type);
	writemode_default := low(file_writemode_type);
	EFAT_default_action := EFAT_DEFAULT;
	bo_choose_expint_sections := FALSE;
	str_XML_header := '';str_XML_struttura := '';
	bo_encode_UTF8 := FALSE;
	bo_delete_special_chars := TRUE;
	for var i : logical_page_type := 0 to MAX_PAGINE_LOGICHE-1 do expint_pages[i].reset
end;

function cl_expint_profilo.get_descrizione(i_pos : smallint) : string;
// rende una descrizione complessiva per l'oggetto; i_pos è la posizione del gruppo; se ZERO viene ignorata
begin
//	result := ifs(i_pos > 0,'[' + zeri(i_pos,2) + '] ') + str_codice + ' -- ' + coalesce(str_descrizione,str_descrizione,'(senza descrizione)')
	result := {ifs(i_pos > 0,'[' + zeri(i_pos,2) + '] ') +} str_codice + ifs(str_descrizione, ' -- ' + str_descrizione)
end;

{$ifndef DLL}
	function cl_expint_profilo.write(var f : text;i_profilo : expint_index_type;i_pagine_logiche : logical_page_type) : boolean;
	var i : logical_page_type;
	begin
		result := FALSE;
		writeln(f, EXPINT_PROFILO_START);

		writeln(f, str_codice);
		writeln(f, str_descrizione);
		writeln_LPSTR(f, str_note);
		writeln_LPSTR(f, str_message_before);
		writeln_LPSTR(f, str_message_after);
		writeln_LPSTR(f, str_comando_specifico_default);
		writeln(f, {i_pos, }byte(bo_dont_show), ' ', byte(target_default), ' ', byte(EFAT_default_action), ' ', lo_expint_max_lines, ' ',
			byte(expint_separatore), byte(writemode_default):2, byte(bo_choose_expint_sections):2, byte(bo_XML_phisical):2, byte(bo_encode_UTF8):2,
			byte(bo_delete_special_chars):2, ' 0 0 0 0 0 0 0 0 0');
		writeln_LPSTR(f, str_XML_struttura);
		writeln_LPSTR(f, str_XML_header);

		for i := 1 to 1 do writeln(f);	// free space
		for i := 0 to i_pagine_logiche-1 do
			if NOT get_logical_page_ZB(i).bo_external	// se EXTERNAL le impostazioni si trovano sul file EXTERNAL
				AND NOT expint_pages[i].write(f, i_profilo, i) then exit;

		writeln(f, EXPINT_PROFILO_END);
		result := TRUE
	end;
{$endif}

function cl_expint_profilo.read(var f : text;i_profilo_ZB : expint_index_type;i_pagine_logiche : logical_page_type;wo_versione : word) : boolean;
const MBOX_CAPTION = 'opzioni di exportazione - principale';
var
	s : string;
	i : logical_page_type;
begin
	result := FALSE;
	try
		readln(f, s);if (s <> EXPINT_PROFILO_START) AND (s <> BAD_EXPINT_PROFILO_PAGE_START) then abort;

		readln(f, str_codice);
		readln(f, str_descrizione);
		readln_LPSTR(f, str_note);
		readln_LPSTR(f, str_message_before);
		readln_LPSTR(f, str_message_after);
		readln_LPSTR(f, str_comando_specifico_default);
		readln(f, byte(bo_dont_show), byte(target_default), byte(EFAT_default_action), lo_expint_max_lines, byte(expint_separatore),
			byte(writemode_default), byte(bo_choose_expint_sections), i, byte(bo_encode_UTF8), byte(bo_delete_special_chars));		// bo_XML_phisical è disponibile dalla versione $0322
		bo_XML_phisical := (i <> 0);		// prima è stato un valore non bool, potrebbe contenere valori diversi da 0/1 e fare casino
		if (wo_versione <= $0325) then bo_delete_special_chars := TRUE;
//		if (wo_versione < $030B) then inc(target_default);		// 2012-12-30, è stato inserito il valore EITT_DEFAULT *** fino 2015-04-18
		if (wo_versione >= $030B) AND (wo_versione <= $0321) then begin		// 2015-04-18, eliminato il valore EITT_DEFAULT
			if (byte(target_default) = 0) then target_default := globale.expint_default_target_backward_compatibility		// leggo il valore default esistente nelle versioni specificate (oggi eliminato)
			else dec(target_default)	// 2012-12-30, è stato eliminato il valore EITT_DEFAULT
		end;
		if (wo_versione <= $0321) then begin	// 2015-04-18, eliminato il valore FWT_DEFAULT
			if (byte(writemode_default) = 0) then writemode_default := globale.export_default_file_writemode_backward_compatibility // tratto il valore default
			else dec(writemode_default)
		end;
		readln_LPSTR(f, str_XML_struttura);
		readln_LPSTR(f, str_XML_header);

		for i := 1 to 1 do readln(f);	// free space

		for i := 0 to i_pagine_logiche-1 do
			if NOT get_logical_page_ZB(i).bo_external	// se EXTERNAL le impostazioni si trovano sul file EXTERNAL
				AND NOT expint_pages[i].read(f, i_profilo_ZB, i, wo_versione) then exit;

		readln(f, s);if (s <> EXPINT_PROFILO_END) AND (s <> BAD_EXPINT_PROFILO_PAGE_END) then abort;
		result := TRUE
	except
		error_msg(EXPINT_ERROR_READING + ' - reading PROFILO' + ACAPO + 'profilo-ZB=' + i_profilo_ZB.ToString, MBOX_CAPTION)
	end
end;

// cl_expint_page --------------------------------------------------------------

constructor cl_expint_page.ZB_create(i_page_ZB : logical_page_type);		// i_page is 0-based
begin
	{$ifdef DEBUG} inc(i_expint_page); {$endif}
	self.i_page_ZB := i_page_ZB;
	setLength(expint_sections, MAX_SECTIONS);
	for var i_section : section_index_type := 0 to MAX_SECTIONS-1 do expint_sections[i_section] := cl_expint_section.create;

	// alloco le istanze per le impostazioni di exportazione integrale gli oggetti che sono già stati caricati
//	if (length(expint_profiles) > 1) then begin	// 1 istanza è già esistente
		for var ix : obj_index_type := 1 to i_objs(i_page_ZB+1) do begin
			var objx : objs_type := xobjs(ix, i_page_ZB + 1);
			if (objx.tipo_oggetto in EXPINT_OBJS) then objx.aslabel.init_expint	// non è distruttivo, agisce solo se non ancora inizializzato
		end;
//	end;
	reset
end;

destructor cl_expint_page.free;
begin
	{$ifdef DEBUG} dec(i_expint_page); {$endif}
	for var i : logical_page_type := 0 to MAX_SECTIONS-1 do begin expint_sections[i].free;expint_sections[i] := NIL end;
	expint_sections := NIL
end;

procedure cl_expint_page.assign(x : cl_expint_page);
begin
	bo_export_allowed := x.bo_export_allowed;
	str_sigla := x.str_sigla;
	bo_print_headers := x.bo_print_headers;
	bo_print_pagina_logica := x.bo_print_pagina_logica;
	bo_print_sezione := x.bo_print_sezione;
	bo_print_pagina_fisica := x.bo_print_pagina_fisica;
	bo_print_record_number := x.bo_print_record_number;
	bo_blankrow_after_headers := x.bo_blankrow_after_headers;
	str_XML_struttura := x.str_XML_struttura;
	for var i : section_index_type := 0 to MAX_SECTIONS-1 do expint_sections[i].assign(x.expint_sections[i])
end;

procedure cl_expint_page.reset;
begin
	bo_export_allowed := TRUE;str_sigla := '';
	bo_print_headers := TRUE;bo_print_pagina_logica := TRUE;bo_print_sezione := TRUE;bo_print_pagina_fisica := FALSE;bo_print_record_number := FALSE;
	bo_blankrow_after_headers := TRUE;
	str_XML_struttura := '';
	for var i : section_index_type := 0 to MAX_SECTIONS-1 do expint_sections[i].reset
end;

{$ifndef DLL}
	function cl_expint_page.write(var f : text;i_profilo : expint_index_type;i_page_ZB : logical_page_type) : boolean;
	var i : integer;
	begin
		result := FALSE;
		writeln(f, EXPINT_PAGE_START);

		writeln(f, byte(bo_export_allowed):2, byte(bo_print_headers):2, byte(bo_print_pagina_logica):2, byte(bo_print_sezione):2,
			byte(bo_print_pagina_fisica):2, byte(bo_print_record_number):2, byte(bo_blankrow_after_headers):2, ' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0');
		writeln(f, str_sigla);
		for i := 1 to 3 do writeln(f);	// free space
		for i := 0 to get_num_sections_page(i_page_ZB + 1) - 1 do if NOT expint_sections[i].write(f) then exit;
		for i := 1 to 2 do writeln(f);	// free space
		for i := 1 to i_objs(i_page_ZB + 1) do begin
			var x : objs_type := xobjs(i, i_page_ZB + 1);
			if NOT (x.tipo_oggetto in EXPINT_OBJS) then continue;
			writeln(f, i);		// scrivo l'indice dell'oggetto salvato
			if NOT x.aslabel.get_expint_object(i_profilo).write(f) then exit
		end;
		writeln(f, 0);	// 0 è il codice che indica che ho finito gli oggetti
		writeln_LPSTR(f, str_XML_struttura);
		for i := 1 to 2 do writeln(f);	// free space

		writeln(f, EXPINT_PAGE_END);
		result := TRUE
	end;
{$endif}

function cl_expint_page.read(var f : text;i_profilo_ZB : expint_index_type;i_page_ZB : logical_page_type;wo_versione : word) : boolean;
const MBOX_CAPTION = 'exportazione integrale - pagina logica';
var
	s : string;
	i : integer;
begin
	result := FALSE;
	try
		readln(f, s);if (s <> EXPINT_PAGE_START) AND (s <> BAD_EXPINT_PROFILO_PAGE_START) then abort;

		readln(f, byte(bo_export_allowed), byte(bo_print_headers), byte(bo_print_pagina_logica), byte(bo_print_sezione),
			byte(bo_print_pagina_fisica), byte(bo_print_record_number), byte(bo_blankrow_after_headers));
		readln(f, str_sigla);
		for i := 1 to 3 do readln(f);	// free space
		for i := 0 to get_num_sections_page(i_page_ZB + 1) - 1 do if NOT expint_sections[i].read(f, i_profilo_ZB, i_page_ZB, wo_versione) then exit;
		for i := 1 to 2 do readln(f);	// free space
		while TRUE do begin
			readln(f, i);if (i = 0) then break;
			{$ifdef DEBUG} assert(xobjs(i, i_page_ZB + 1).tipo_oggetto in EXPINT_OBJS, 'cl_expint_page.read() -- tipo oggetto errato -- RJIN 3812'); {$endif}
			if NOT xobjs(i, i_page_ZB + 1).aslabel.get_expint_object(i_profilo_ZB).read(f, i_profilo_ZB, i_page_ZB, i, wo_versione) then exit
		end;
		readln_LPSTR(f, str_XML_struttura);
		for i := 1 to 2 do readln(f);	// free space

		readln(f, s);if (s <> EXPINT_PAGE_END) AND (s <> BAD_EXPINT_PROFILO_PAGE_END) then abort;
		result := TRUE
	except
		error_msg(EXPINT_ERROR_READING + ' reading PAGE' + ACAPO + 'profilo-ZB=' + i_profilo_ZB.ToString + ACAPO + 'pagina-ZB=' + i_page_ZB.ToString, MBOX_CAPTION)
	end
end;	

// cl_expint_section -----------------------------------------------------------

constructor cl_expint_section.create;
begin
	{$ifdef DEBUG} inc(i_expint_section); {$endif}
	reset
end;

destructor cl_expint_section.free;
begin
	{$ifdef DEBUG} dec(i_expint_section) {$endif}
end;

procedure cl_expint_section.reset;
begin
	expint_mode := SEXP_YES;expint_objs_default_mode := OEXP_DEFAULT;
	i_shift_columns := 0;str_sigla := '';str_descrizione_runtime := '';
	bo_skip_on_continuazione := TRUE;bo_headers_colonne := TRUE;
	bo_XML_allowed := FALSE;str_struttura_XML := ''
end;

procedure cl_expint_section.assign(x : cl_expint_section);
begin
	expint_mode := x.expint_mode;
	expint_objs_default_mode := x.expint_objs_default_mode;
	str_sigla := x.str_sigla;
	str_descrizione_runtime := x.str_descrizione_runtime;
	i_shift_columns := x.i_shift_columns;
	bo_skip_on_continuazione := x.bo_skip_on_continuazione;
	bo_headers_colonne := x.bo_headers_colonne;

	bo_XML_allowed := x.bo_XML_allowed;
	str_struttura_XML := x.str_struttura_XML
end;

{$ifndef DLL}
	function cl_expint_section.write(var f: text): boolean;
	begin
//		result := FALSE;
		writeln(f, EXPINT_SECTION_START);

		writeln(f, byte(expint_mode), ' ', byte(expint_objs_default_mode), ' ', i_shift_columns,
			byte(bo_skip_on_continuazione):2, byte(bo_headers_colonne):2, byte(bo_XML_allowed):2, ' 0 0 0 0 0 0');	//	110 00  0 0 0 0 0 0 0 0
		writeln(f, str_sigla);
		writeln(f, str_descrizione_runtime);
		writeln_LPSTR(f, str_struttura_XML);
//		for var i : section_index_type := 1 to 1 do writeln(f);	// free space
		writeln(f, EXPINT_SECTION_END);
		result := TRUE
	end;
{$endif}

function cl_expint_section.read(var f : text;i_profilo_ZB : expint_index_type;i_pagina_ZB : logical_page_type;wo_versione : word) : boolean;
const MBOX_CAPTION = 'exportazione integrale - sezione';
var s : string;	//*
begin
	result := FALSE;
	try
		readln(f, s);if (s <> EXPINT_SECTION_START) then abort;

		readln(f, byte(expint_mode), byte(expint_objs_default_mode), i_shift_columns, byte(bo_skip_on_continuazione), byte(bo_headers_colonne),
			byte(bo_XML_allowed));
		{ fino alla versione $311:
				* esisteva il valore di ordine ZERO (OEXP_DEFAULT), che è stato eliminato a partire dalla versione $312;
				* il valore OEXP_IMPOSSIBLE non esisteva; i valori OEXP_NOT precedenti a tale versione vengono convertiti su OEXP_IMPOSSIBLE }
		if (wo_versione <= $0311) then begin
			case byte(expint_mode) of
				0, 1 : expint_mode := SEXP_YES;		// 0 was DEFAULT, 1 was YES
				2 : expint_mode := SEXP_NOT			// 2 was NOT
				else begin
					{$ifdef DEBUG} assert(FALSE, 'valore imprevisto (' + byte(expint_mode).ToString + ') -- KLWI 3913'); {$endif}
					expint_mode := SEXP_YES
				end
			end
		end;
		readln(f, str_sigla);
		readln(f, str_descrizione_runtime);
		readln_LPSTR(f, str_struttura_XML);
//		for i := 1 to 1 do readln(f);	// free space

		readln(f, s);if (s <> EXPINT_SECTION_END) then abort;
		result := TRUE
	except
		error_msg(EXPINT_ERROR_READING + ' - reading SEZIONE' + ACAPO + 'profilo-ZB=' + i_profilo_ZB.ToString + ACAPO + 'pagina-ZB=' + i_pagina_ZB.ToString, MBOX_CAPTION)
	end
end;	

// cl_expint_object -----------------------------------------------------------

constructor cl_expint_object.create; begin {$ifdef DEBUG} inc(i_expint_object) {$endif} end;
destructor cl_expint_object.free; begin {$ifdef DEBUG} dec(i_expint_object) {$endif} end;

procedure cl_expint_object.reset;
begin
	i_pos := 0;
	i_exec_pos := 0;		// ????? mah???
	expint_mode := OEXP_DEFAULT;
	str_header := '';
	i_skip_cols_before := 0;
	multiline := EXPINTML_EXCEL;
	str_acapo := '';str_tab := ''
end;

procedure cl_expint_object.assign(source : cl_expint_object);
begin
	i_pos := source.i_pos;
	i_exec_pos := source.i_exec_pos;
	expint_mode := source.expint_mode;
	str_header := source.str_header;
	i_skip_cols_before := source.i_skip_cols_before;
	multiline := source.multiline;
	str_acapo := source.str_acapo;
	str_tab := source.str_tab
end;

{$ifndef DLL}
	function cl_expint_object.write(var f : text) : boolean;
	begin
//		result := FALSE;
		writeln(f, EXPINT_OBJECT_START);

		writeln(f, i_pos, ' ', {i_exec_pos}0 , ' ', byte(expint_mode), ' ', i_skip_cols_before, ' ', byte(multiline), ' 0 0 0 0 0 0');
		writeln(f, str_header);
		writeln_LPSTR(f, str_acapo);
		writeln_LPSTR(f, str_tab);
		for var i : section_index_type := 1 to 5 do writeln(f);	// free space
		writeln(f, EXPINT_OBJECT_END);
		result := TRUE
	end;
{$endif}

function cl_expint_object.read(var f : text;i_profilo_ZB : expint_index_type;i_pagina_ZB : logical_page_type;i_object_1B : obj_index_type;
	wo_versione : word) : boolean;
const MBOX_CAPTION = 'exportazione integrale - oggetto';
var
	s : string;
	i : logical_page_type;	//*
begin
	result := FALSE;
	try
		readln(f, s);if (s <> EXPINT_OBJECT_START) AND (s <> BAD_EXPINT_OBJECT_START_END) then abort;

		readln(f, i_pos, {i_exec_pos}i, byte(expint_mode), i_skip_cols_before, byte(multiline));
		if (i = 0) then ;		// compiler's problems
		readln(f, str_header);
		readln_LPSTR(f, str_acapo);
		readln_LPSTR(f, str_tab);
		for i := 1 to 5 do readln(f);	// free space

		readln(f, s);if (s <> EXPINT_OBJECT_END) AND (s <> BAD_EXPINT_OBJECT_START_END) then abort;
		result := TRUE
	except
		error_msg(EXPINT_ERROR_READING + ' - reading OBJECT' + ACAPO +
			'profilo-ZB=' + inttostr(i_profilo_ZB) + ACAPO + 'pagina-ZB=' + i_pagina_ZB.ToString + ACAPO + 'object-1B=' + i_object_1B.ToString, MBOX_CAPTION)
	end
end;

procedure expint_profilo_array_free(var x : expint_profilo_array);
begin
	for var i : smallint := 0 to high(x) do if (x[i] <> NIL) then x[i].free;
	x := NIL
end;

{$ifndef DLL}
	procedure expint_profilo_array_assign(var target, source : expint_profilo_array);
	begin
		expint_profilo_array_free(target);
		setLength(target, length(source));
		for var i : smallint := 0 to high(source) do begin
			target[i] := cl_expint_profilo.create;
			target[i].assign(source[i])
		end
	end;
{$endif}

function cl_expint_page.get_expint_sigla : string;
begin
	var s := str_sigla;
	if (globale.i_pagine_logiche = 1) then result := s else result := coalesce(s, 'PL/' + inttostr(i_page_ZB + 1))
end;

function get_expint_profilo(i_profilo : expint_index_type = -1) : cl_expint_profilo;
// solo a runtime: passare i_profilo = -1 per utilizzare il profilo correntemente attivo
begin
	if (i_profilo = -1) then i_profilo := max(globale.i_active_expint_profile, 0);
	{$ifdef DEBUG} assert((i_profilo >= 0) AND (i_profilo <= high(globale.expint_profiles)), 'get_expint_profilo() -- profilo errato'); {$endif}
	result := globale.expint_profiles[i_profilo]
end;

function get_expint_profilo(str_descrizione : string) : cl_expint_profilo;
begin
	for var i : expint_index_type := 0 to high(globale.expint_profiles) do begin
		var ep : cl_expint_profilo := globale.expint_profiles[i];
		if (ep.str_codice = str_descrizione) OR (ep.str_descrizione = str_descrizione) OR (ep.get_descrizione(i+1) = str_descrizione) then begin
			result := ep;
			exit
		end
	end;
	result := NIL
end;

function get_expint_page_ZB(i_profilo : expint_index_type;i_pagina_logica_ZB : logical_page_type) : cl_expint_page;
// solo a runtime: passare i_profilo = -1 per utilizzare il profilo correntemente attivo
begin
	{$ifdef DEBUG} assert((i_pagina_logica_ZB >= 0) AND (i_pagina_logica_ZB <= high(get_expint_profilo(i_profilo).expint_pages)), 'get_expint_page() -- pagina logica errata'); {$endif}
	result := get_expint_profilo(i_profilo).expint_pages[i_pagina_logica_ZB]
end;

function get_expint_section_ZB(i_profilo : expint_index_type;i_pagina_logica_ZB : logical_page_type;i_sezione_ZB : section_index_type) : cl_expint_section;
// solo a runtime: passare i_profilo = -1 per utilizzare il profilo correntemente attivo
begin
{$ifdef DEBUG}
	assert((i_pagina_logica_ZB >= 0) AND (i_pagina_logica_ZB <= high(get_expint_profilo(i_profilo).expint_pages)), 'get_expint_section() -- pagina logica errata');
	assert((i_sezione_ZB >= 0) AND (i_sezione_ZB <= high(get_expint_page_ZB(i_profilo, i_pagina_logica_ZB).expint_sections)), 'get_expint_section() -- sezione errata');
{$endif}
	result := get_expint_page_ZB(i_profilo, i_pagina_logica_ZB).expint_sections[i_sezione_ZB]
end;

(*function get_expint_object_ZB(i_profilo : expint_index_type;i_pagina_logica_ZB : logical_page_type;i_object_1B : obj_index_type) : cl_expint_object;
// i_object is 1-based
begin
	if (i_profilo = -1) then i_profilo := max(globale.i_active_expint_profile, 0);
	{$ifdef DEBUG}
		assert((i_profilo >= 0) AND (i_profilo <= high(globale.expint_profiles)), 'get_expint_object() -- profilo errato');
		assert(xobjs(i_object_1B, i_pagina_logica_ZB).tipo_oggetto in EXPINT_OBJS, 'get_expint_object() -- tipo errato');
	{$endif}
//	result := xobjs(i_object, i_pagina_logica).aslabel.expint[i_profilo]
	result := xobjs(i_object_1B, i_pagina_logica_ZB).aslabel.get_expint_object(i_profilo)
end;*)

function expint_profiles_count : expint_index_type; begin result := length(globale.expint_profiles) end;
function get_expint_page_ZB(i_pagina_logica_ZB : logical_page_type) : cl_expint_page; begin result := get_expint_page_ZB(-1, i_pagina_logica_ZB) end;
function get_expint_section_ZB(i_pagina_logica_ZB : logical_page_type;i_sezione_ZB : section_index_type) : cl_expint_section; begin result := get_expint_section_ZB(-1, i_pagina_logica_ZB, i_sezione_ZB) end;
//function get_expint_object_ZB(i_pagina_logica_ZB : logical_page_type;i_object_1B : obj_index_type) : cl_expint_object; begin result := get_expint_object_ZB(-1, i_pagina_logica_ZB, i_object_1B) end;

function get_export_target_XML(i_profilo : expint_index_type = -1) : boolean;
// rende TRUE se il target è XML
begin
	result := get_expint_profilo(i_profilo).bo_XML
end;

function get_export_target_integrale(i_profilo : expint_index_type = -1) : boolean;
// rende TRUE se il target è EXPORT_INTEGRALE
begin
	result := get_expint_profilo(i_profilo).bo_export_integrale
end;

procedure expint_profilo_load_items(it : TStrings;x : expint_profilo_array = NIL);
begin
	if (x = NIL) then x := globale.expint_profiles;
	it.clear;
	for var i : smallint := 0 to high(x) do it.add(x[i].get_descrizione(i+1))
end;

procedure load_export_profiles_proc(lv : TListView;i_select_index : smallint = -1);
type
	column_type = record
		str_caption : string;
		i_width : smallint;
		alignment : TAlignment;
	end;
const
	NUM_COLS = 3;
	COLS : array[0..NUM_COLS-1] of column_type = (
		(str_caption:'codice'; i_width: 200;alignment: taLeftJustify),
		(str_caption:'modalità'; i_width: ColumnHeaderWidth;alignment: taCenter),
		(str_caption:'descrizione'; i_width: 500;alignment: taLeftJustify));
begin
	if (i_select_index = -1) then i_select_index := lv.ItemIndex;
	if (lv.Columns.Count = 0) then begin
		for var i : smallint := 0 to NUM_COLS - 1 do with lv.Columns.Add do begin
			caption := COLS[i].str_caption;
			width := COLS[i].i_width;
			AlignMent := COLS[i].alignment
		end
	end;
	lv.Items.Clear;
	for var i : smallint := 0 to high(globale.expint_profiles) do begin
		var xp : cl_expint_profilo := globale.expint_profiles[i];
		var itm : TListItem := lv.Items.Add;
		itm.Caption := xp.str_codice;
		itm.SubItems.Add(ifs(xp.bo_XML, 'XML'));	// altrimenti blank
//		itm.SubItems.Add(xp.get_descrizione(xxx))
		itm.SubItems.Add(xp.str_descrizione)
	end;
	lv.Itemindex := i_select_index
end;

function MOST_exportable(a, b : object_expint_mode_type) : object_expint_mode_type;
// rende il valore più favorevole all'exportazione tra A e B
begin
	result := OEXP_DEFAULT;	// totalmente inutile, ma in assenza emette una warning assurda di UNDEFINED RETURN VALUE
	case a of
		OEXP_DEFAULT : if (b = OEXP_YES) then result := OEXP_YES else result := OEXP_DEFAULT;
		OEXP_YES : result := OEXP_YES;
		OEXP_NOT : result := b
	end
end;

initialization
	galateo_initialization_debug('expint_base')
finalization
	galateo_finalization_debug('expint_base');
{$ifdef DEBUG}
	CCI(i_expint_profilo, 'cl_expint_profilo', 'dich.pas');
	CCI(i_expint_page, 'cl_expint_page', 'dich.pas');
	CCI(i_expint_section, 'cl_expint_section', 'dich.pas');
	CCI(i_expint_object, 'cl_expint_object', 'dich.pas')
{$endif DEBUG}
end.
