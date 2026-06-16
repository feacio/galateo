unit galateo_debug;		//*

{	questa unit contiene specifiche funzionalità di debugging specifiche di galateo;
	si appoggia (genericamente) anche alla debug-unit standard MYDEBUG.PAS

	in GALATEO (e in CASA) ci sono DUE distinti livelli di debug:
		1) a livello di report (BO_REPORT_DEBUG), attivabile:
			A) sulle impostazioni del report
			B) attraverso opportuni parametri sulla chiamata dal programma principale (esempio: JOLLY)
>>			usare la funzione RUNTIME_DEBUG()     (disponibile su PAGES.PAS)

		2) a livello di systema (BO_GALATEO_SYSTEM_DEBUG), con specifico riferimento alle fasi di inizializzazione e chiusura DLL,
			e in generale a tutto ciò che non è coperto dal primo livello di debug; questa modalità è attivabile:
			IN VIA PRINCIPALE: attivare variabile condizionale di compilazione GALATEO_SYSTEM_DEBUG su E:\DX\GALATEO\DEFINES
				(soluzione di gran lunga migliore, ma impegnativa su eseguibile in produzione)
			B) chiamata a CASA.init_galateo(), parametro BO_SYSTEM_DEBUG
			C) ... si attendono idee brillanti ...
>>			usare la funzione WRITELN_SYSTEM_DEBUG()

}

{$I defines}
{$ifdef GALATEO_SYSTEM_DEBUG} {$ifNdef DEBUG} *** {$endif} {$endif}

interface

uses DB, SysUtils,
	FRDebug, FDB;

type
	{ per consentire l'inserimento di elementi di contestualizzazione del debug
	  (senza obbligare ciascuna delle procedure che chiamano il debug a generare localmente queste informazioni)
	  viene utilizzata una FUNZIONE richiamata dalla procedura che esegue il debug;
	  l'indirizzo di questa funzione può essere fornito staticamente (SET_DEBUG_REFERENCE_FUNCTION)
	  oppure localmente, ad ogni chiamata alla funzione di debug }
	debug_reference_function = function(pt : pointer) : string;		// tipo di funzione che rende informazioni generiche sul contesto e lo stato di avanzamento dell'elaborazione
procedure set_debug_reference_function(func : debug_reference_function);

function set_system_debug(bo_attivo : boolean;wo_system_debug_mode : word;RDEBUG_mode : RDEBUG_MODE_type) : boolean;
function set_report_debug(bo_attivo : boolean) : boolean;

// Gdebug sta per Galateo-DEBUG (debug a livello di REPORT) ==========================================================================================

//function init_Gdebug_SQL(str_report_filename : string;str_message : string;bo_dont_delete_file : boolean = FALSE) : string;
function init_Gdebug_SQL(str_report_filename : string;str_message : string;bo_delete_previous_file : boolean = FALSE) : string;
procedure end_Gdebug_SQL;
procedure Gdebug_SQL(str : string;str_caption : string;bo_remarks : boolean = FALSE;get_local_reference : debug_reference_function = NIL;bo_acapo_after : boolean = TRUE); overload;
procedure Gdebug_SQL(qry : TFquery;str_caption : string;bo_remarks : boolean = FALSE;get_local_reference : debug_reference_function = NIL;bo_acapo_after : boolean = TRUE); overload;
function Gdebug_initialized : boolean;

// procedure di SYSTEM-DEBUG =========================================================================================================================

procedure galateo_initialization_debug(str_unit_filename : string;bo_write_however : boolean = FALSE);
procedure galateo_finalization_debug(str_unit_filename : string;bo_write_however : boolean = FALSE);
procedure writeln_system_debug(str_message, str_context : string); overload;
procedure writeln_system_debug(i_index : integer;str_context : string;str_message : string = ''); overload;
function get_debug_filename(str_report_filename : string = '') : string;

procedure set_report_debug_target(str_debug_caption : string;debug_target : GALATEO_debug_target_type;Rdebug_mode : RDEBUG_MODE_type); overload;
procedure set_report_debug_target(str_debug_caption : string;wo_debug_mode : word;Rdebug_mode : RDEBUG_MODE_type); overload;

var
	report_debug_target : GALATEO_debug_target_type;	// vale per il REPORT-debug
	report_Rdebug_mode : RDEBUG_MODE_type;		// vale per il REPORT-debug

implementation

uses FDebug, Fcommons, Fdata, Ftime, FXStrings, FStrings, FErrMsg, FMessage, FProcs, FFile,
	gdich;

const
	MBOX_CAPTION  = {$ifdef DLL} 'CASA.DLL' {$else} 'GALATEO' {$endif};

var
	bo_report_debug : boolean;				// attivato debug su uno specifico report
	bo_galateo_system_debug : boolean;	// è stato attivato un controllo di debug di sistema; è una modalità distinta dal debug del singolo report (che viene attivato dal report)
var
	f_debug : system.Text;
	bo_debug_initialized : boolean;
	str_debug_message : string;
	str_debug_filename : string;
	static_debug_reference_function : debug_reference_function;
	str_debug_caption : string;

procedure set_report_debug_target(str_debug_caption : string;wo_debug_mode : word;Rdebug_mode : RDEBUG_MODE_type);
begin
	var debug_target : GALATEO_debug_target_type;
	if (wo_debug_mode AND DEBUG_TARGET_LOCAL_FILE <> 0) AND (wo_debug_mode AND DEBUG_TARGET_RUNTIME <> 0) then debug_target := DEBUG_TARG_BOTH
	else if (wo_debug_mode AND DEBUG_TARGET_RUNTIME <> 0) then debug_target := DEBUG_TARG_CONSOLE
	else {if (wo_debug_mode AND DEBUG_TARGET_LOCAL_FILE <> 0) then} debug_target := DEBUG_TARG_FILE;
	set_report_debug_target(str_debug_caption, debug_target, Rdebug_mode)
end;

procedure set_report_debug_target(str_debug_caption : string;debug_target : GALATEO_debug_target_type;Rdebug_mode : RDEBUG_MODE_type);
begin
	galateo_debug.str_debug_caption := str_debug_caption;
	galateo_debug.report_debug_target := debug_target;
	galateo_debug.report_Rdebug_mode := Rdebug_mode;
	{$ifdef DEBUG} static_immediate_debug('set_debug_target() -- ' + str_debug_caption + ' :: ' + GALATEO_DEBUG_TARGET_DESCR[debug_target] + '   ' + RDEBUG_DESCRIZIONE[Rdebug_mode]) {$endif DEBUG}
end;

function get_debug_filename(str_report_filename : string = '') : string;
// se STR_REPORT_FILENAME = '' rende il debug-filename già precedentemente generato
begin
	if (str_report_filename = '') then result := str_debug_filename
	else result := ChangeFileExt(str_report_filename, DEBUG_LOG_EXT);
end;

function set_system_debug(bo_attivo : boolean;wo_system_debug_mode : word;RDEBUG_mode : RDEBUG_MODE_type) : boolean;
// rende TRUE se esegue l'assegnazione
const DEBUG_MESSAGE = {$ifdef GALATEO_SYSTEM_DEBUG} 'Runtime system debug attivato staticamente (variabile condizionale)' {$else} 'Runtime system debug attivato' {$endif};
begin
	result := (bo_attivo <> bo_galateo_system_debug) OR (RDEBUG_mode <> RDEBUG_active_mode);
	if NOT result then exit;

{$ifdef DEBUG}
static_immediate_debug('set_system_debug(() bo_attivo=' + bo_attivo.SQL +
		'  debug-mode=' + wo_system_debug_mode.ToString + '  ' + RDEBUG_DESCRIZIONE[RDEBUG_mode]);
{$endif DEBUG}

	if bo_attivo then MessageBBox(0, MBOX_CAPTION + ACAPO2 + DEBUG_MESSAGE, MBOX_CAPTION);
	bo_galateo_system_debug := bo_attivo;
	set_low_level_debugging_mode(TRUE);		// faccio scrivere immediatamente tutto; più lento ma più completo e sicuro

	if (wo_system_debug_mode = 0) then begin
		wo_system_debug_mode := computer_registry_data.get_system_debug_mode;
		RDEBUG_mode := computer_registry_data.RDEBUG_mode
	end;
	if (wo_system_debug_mode <> 0) then begin
		set_debug_trace_mode(wo_system_debug_mode, get_debug_mode(bo_attivo));	// destinazione: LOCAL FILE, intervieni sul parametro per aggiungere altre destinazioni
		if (wo_system_debug_mode AND DEBUG_TARGET_RUNTIME <> 0) then RDEBUG_active_mode := RDEBUG_mode	// assegno la modalità per il Runtime debugging
	end
{$ifdef DEBUG}
;static_immediate_debug('set_system_debug(() ASSIGNED : bo_attivo=' + bo_attivo.SQL +
		'  debug-mode=' + get_debug_trace_mode.ToString + '  ' + RDEBUG_DESCRIZIONE[RDEBUG_active_mode]);
{$endif DEBUG}
end;

function set_report_debug(bo_attivo : boolean) : boolean;
begin
	result := bo_report_debug;
	bo_report_debug := bo_attivo
end;

// ---------------------------------------------------------------------------------------------------------------------------------------------------

procedure galateo_initialization_debug(str_unit_filename : string;bo_write_however : boolean = FALSE);
begin
	{$ifdef GALATEO_SYSTEM_DEBUG} set_system_debug(TRUE, {detailed}TRUE); {$endif}
	FDebug.initialization_debug(str_unit_filename, bo_write_however OR bo_galateo_system_debug)
end;

procedure galateo_finalization_debug(str_unit_filename : string;bo_write_however : boolean = FALSE);
begin
//	{$ifdef GALATEO_SYSTEM_DEBUG} set_system_debug(TRUE); {$endif}		*** INUTILE, già stato attivato (e se non ancora attivato, tanti saluti!!!)
	FDebug.finalization_debug(str_unit_filename, bo_write_however OR bo_galateo_system_debug)
end;

procedure writeln_system_debug(str_message, str_context : string);
begin
	if NOT bo_galateo_system_debug then exit;
//	FDebug.debug(0, str_context, str_message)
	writeln_system_debug(0, str_context, str_message)
end;

procedure writeln_system_debug(i_index : integer;str_context : string;str_message : string = '');
begin
	if NOT bo_galateo_system_debug then exit;
	FDebug.debug(NIL, '[system] ' + str_context, i_index, str_message);
//	if (computer_registry_data.Rdebug_mode <> RDB_BLANK) then
//		RDEBUG(computer_registry_data.Rdebug_mode, i_index, {importante}TRUE, 'system', ifs(str_context, '[' + str_context + '] ') + str_message)
end;

// ---------------------------------------------------------------------------------------------------------------------------------------------------

function Gdebug_writeln(s : string) : boolean;
// scrive fisicamente sul file o sull'event-log
begin
	result := TRUE;
	try
//		if NOT bo_debug_initialized OR (globale = NIL) OR NOT globale.bo_debug_base then exit;
		if NOT bo_debug_initialized OR NOT bo_report_debug then exit;
		if (report_debug_target in [DEBUG_TARG_FILE, DEBUG_TARG_BOTH]) then begin
			writeln(f_debug, s);
			flush(f_debug)
		end;
		if (report_debug_target in [DEBUG_TARG_CONSOLE, DEBUG_TARG_BOTH]) then RDEBUG(report_Rdebug_mode , {index}0, {importante}TRUE, str_debug_caption, s)
	except
		result := FALSE
	end
end;

function Gdebug_initialized : boolean;
begin
	result := bo_debug_initialized
end;

function init_Gdebug_SQL(str_report_filename : string;str_message : string;bo_delete_previous_file : boolean = FALSE) : string;
// restituisce il nome del file contenente le info di debug; rende BLANK in caso di errore o di debug non attivato
var s : string;	//*
begin
	result := str_debug_filename;
	{$ifdef DEBUG} static_immediate_debug('init_Gdebug_SQL() :: ' + RDEBUG_DESCRIZIONE[RDEBUG_active_mode] + '   ' + GALATEO_DEBUG_TARGET_DESCR[galateo_debug.report_debug_target]); {$endif DEBUG}
//	messagebbox(0,'001',MBOX_CAPTION);
//	if NOT globale.bo_debug_base OR bo_debug_initialized then exit;	*
	if NOT bo_report_debug OR bo_debug_initialized then exit;

	if (report_debug_target in [DEBUG_TARG_FILE, DEBUG_TARG_BOTH]) then begin
		{$I-}
		close(f_debug);if (IOresult = 0) then;
//		globale.str_debug_filename := ChangeFileExt(globale.str_filename, DEBUG_LOG_EXT);
//		str_debug_filename := ChangeFileExt(str_report_filename, DEBUG_LOG_EXT);
		str_debug_filename := get_debug_filename(str_report_filename);
		if NOT writeable_path(extractFilePath(str_debug_filename), s) then begin
			str_debug_filename := make_filename(str_debug_filename, get_temp_directory, {sostituisci_path}TRUE);
			result := str_debug_filename
		end;
		save_target_debug_filename(str_debug_filename, 'report-debug GALATEO (' + str_report_filename + ')');

//		if NOT bo_dont_delete_file AND globale.bo_debug_delete_everytime then DeleteFile(str_debug_filename);
		if bo_delete_previous_file then DeleteFile(str_debug_filename);
		assign(f_debug, str_debug_filename);if (IOresult = 0) then;
		append(f_debug);if (IOresult <> 0) then rewrite(f_debug);
		if (IOresult = 0) then;
//		messagebbox(0, str_debug_filename, 'AAAAAAAA');
		str_debug_message := str_message;
{		writeln(f_debug,'||||||||||||||||| ' +
			ifs(str_message,'START: ' + str_message,'start of print') + ' ',
			dttime2SQL(now, FALSE, TMFMT_HMS), ' -- ver ' + version_of(GALATEO_VERSION) + '  |||||||||||||');
		bo_debug_initialized := (IOresult = 0) }
	end;

	try
		bo_debug_initialized := TRUE;
		if NOT Gdebug_writeln('||||||||||||||||| ' + ifs(str_message,'START: ' + str_message, 'start of print') + ' ' +
			dttime2SQL(now, FALSE, TMFMT_HMS) + ' -- ver ' + version_of(GALATEO_VERSION) + '  |||||||||||||')
				then abort;
		result := str_debug_filename
	except
		str_debug_filename := '';
		bo_debug_initialized := FALSE
	end;
//	;messagebbox(0, '999', str_debug_filename);
	{$I+}
end;

procedure end_Gdebug_SQL;
begin
	if {NOT globale.bo_debug OR} NOT bo_debug_initialized then exit;
	try
		{$I-}
//		messagebbox(0,'END_debug(000)',globale.str_debug_filename);
		Gdebug_writeln('|||||||||||| ' + ifs(str_debug_message,'END: ' + str_debug_message, 'end of print') + ' ' + dttime2SQL(now, FALSE, TMFMT_HMS) + ' ||||||||||||');
//		if (IOresult = 0) then;
		Gdebug_writeln('');
		if (report_debug_target in [DEBUG_TARG_FILE, DEBUG_TARG_BOTH]) then begin
			close(f_debug);if (IOresult = 0) then
		end;
		bo_debug_initialized := FALSE
		{$I+}
	except
	end
end;

(*procedure Gdebug_SQL(str : string;str_caption : string;bo_remarks : boolean = FALSE;get_local_reference : debug_reference_function = NIL;bo_acapo_after : boolean = TRUE);
const REM = '--' + ^I;
var str_reference : string;
begin
	try
//		if NOT bo_debug_initialized OR (globale = NIL) OR NOT globale.bo_debug_base then exit;
		if NOT bo_debug_initialized OR NOT bo_report_debug then exit;

		if (str_caption <> '') then begin
			if NOT assigned(get_local_reference) then get_local_reference := static_debug_reference_function;
			if assigned(get_local_reference) then str_reference := get_local_reference(NIL);
{			writeln_debug('/******************** ' + dttime2SQL(now,FALSE,TMFMT_HMS) + ' ' +
				ifs(get_ultima_pagina_logica > 1, '-- page ' + inttostr(get_pagina_logica_attiva_1B) + ' -- ') + str_caption + ' */'); }
			Gdebug_writeln('/******************** ' + dttime2SQL(now,FALSE,TMFMT_HMS) + ' ' +
				ifs(str_reference, ' -- ' + str_reference) +
				' -- ' + str_caption + ' */')
		end;
		if (IOresult = 0) then;
		str := togli_ACAPO_finali(str);
		if (str <> '') then begin
			if bo_remarks then begin
				str := REM + str;
				sostituisci(str, ACAPO, ACAPO + REM)
			end
			else if NOT end_with(str, ';') then str := str + ';';
			Gdebug_writeln(str)
		end;
		if bo_acapo_after then Gdebug_writeln('')
	except
		error_msg(0, 'Errore durante la generazione del file di LOG', str_debug_filename);
		try
			end_Gdebug_SQL
		finally
			bo_debug_initialized := FALSE
		end
	end
end;*)

procedure Gdebug_SQL(str : string;str_caption : string;bo_remarks : boolean = FALSE;get_local_reference : debug_reference_function = NIL;bo_acapo_after : boolean = TRUE);
const REM = '--' + ^I;
var str_output, str_reference : string;
begin
	try
//		if NOT bo_debug_initialized OR (globale = NIL) OR NOT globale.bo_debug_base then exit;
		if NOT bo_debug_initialized OR NOT bo_report_debug then exit;

		if (str_caption <> '') then begin
			if NOT assigned(get_local_reference) then get_local_reference := static_debug_reference_function;
			if assigned(get_local_reference) then str_reference := get_local_reference(NIL);
{			writeln_debug('/******************** ' + dttime2SQL(now,FALSE,TMFMT_HMS) + ' ' +
				ifs(get_ultima_pagina_logica > 1, '-- page ' + inttostr(get_pagina_logica_attiva_1B) + ' -- ') + str_caption + ' */'); }
			str_output := '/* ' + dttime2SQL(now,FALSE,TMFMT_HMS) + ' ' + ifs(str_reference, ' -- ' + str_reference) + ' -- ' + str_caption + ' */'
		end;
		if (IOresult = 0) then;
		str := togli_ACAPO_finali(str);
		if (str <> '') then begin
			if bo_remarks then begin
				str := REM + str;
				sostituisci(str, ACAPO, ACAPO + REM)
			end
			else if NOT end_with(str, ';') then str := str + ';';
			str_output := str_output + '  ' + str
//			Gdebug_writeln(str)
		end;
		Gdebug_writeln(str_output)
//		if bo_acapo_after then Gdebug_writeln('')
	except
		error_msg('Errore durante la generazione del file di LOG', str_debug_filename);
		try
			end_Gdebug_SQL
		finally
			bo_debug_initialized := FALSE
		end
	end
end;

procedure Gdebug_SQL(qry : TFquery;str_caption : string;bo_remarks : boolean = FALSE;get_local_reference : debug_reference_function = NIL;bo_acapo_after : boolean = TRUE);
begin
	{$ifdef DEBUG} assert(qry <> NIL,'debug_SQL() -- qry IS NIL -- HMEX 8283'); {$endif}
	var s : string := qry.SQL.Text;
	if (pos(ACAPO, s) <> 0) then s := ACAPO + s {+ ACAPO};
	Gdebug_SQL(s, str_caption + ' [' + qry.DatabaseName + ']', bo_remarks, get_local_reference, bo_acapo_after)
end;

procedure set_debug_reference_function(func : debug_reference_function);		{$ifdef PROVA} *** assegnare ed utilizzare {$endif}
begin
	if assigned(func) then static_debug_reference_function := func
	else static_debug_reference_function := NIL
end;

initialization
	galateo_initialization_debug('galateo_debug')
finalization
	galateo_finalization_debug('galateo_debug')
end.
