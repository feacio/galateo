library CASA;

//	definire EXCLUDE_DRAGDROP per escludere la libreria DRAG AND DROP COMPONENT SUITE
// è usata solamente in PRINT_REPORT per fare il drag&drop dei files generati
// a volte può essere (con)causa di problemi (2025-12)
// al momento è utilizzata e utilizzabile senza problemi

{$ifndef GALATEO} 			*** GALATEO required ***				{$endif}	// tutte le applicazioni del mondo GALATEO
//{$ifndef GALATEO_EXE}		*** GALATEO_EXE required ***		{$endif}	// GALATEO.EXE
{$ifndef CASA}					*** CASA required ***					{$endif}	// CASA.DLL
//{$ifndef GALRUN}				*** GALRUN required ***					{$endif}	// GALRUN.EXE

{$ifndef DLL}					*** DLL required ***					{$endif}	// CASA.DLL

{$ifndef DEBUG} {$ifdef EXCLUDE_DRAGDROP} ** ** ** {$endif} {$endif DEBUG}

// copy /B "$(OutputPath)" "E:\DX\JOLLY\main\$(Platform)\$(Config)\$(OutputName)$(OutputExt)"

{ Important note about DLL memory management: ShareMem must be the first unit in your library's USES clause AND your project's
  (select Project-View Source) USES clause if your DLL exports any procedures or functions that pass strings as parameters or
  function results. This applies to all strings passed to and from your DLL--even those that are nested in records and classes.
  ShareMem is the interface unit to the BORLNDMM.DLL shared memory manager, which must be deployed along with your DLL.
  To avoid using BORLNDMM.DLL, pass string information using PChar or ShortString parameters. }

uses
//  SimpleShareMEM,
	FastMM4,
  SysUtils,
  Windows,
  Dialogs,
  System.Classes,
  Forms,
  FireDAC.DApt,
  Fcommons,
  Fdebug,
  FRdebug,
  FXStrings,
  Fstrings,
  FMessage,
  FErrMsg,
  FFile,
  Fdata,
  FSystem,
  FSystem_ext,
  FDB,
  FProcs,
  FBrowse,
  Gdich,
  galateo_debug,
  GUN,
  printers_DX,
  proc,
  jobstack,
  pages,
  working,
  misure,
  objects,
  labels,
  sezione,
  print_report,
  printer_select;

{$R *.res}
{$R eventlog-messages\galateo_eventlog.res}			// decodifica dei messaggi sull' eventlog

// ----------- EXPORT DECLARATIONS ---------------------------------------------

{ ****$I printtyp.h}	// tipi usati per il collegamento alla DLL

function		set_GALATEO_universal_callback(setup_proc : universal_callback_procedure_type;
//					chkm : {$ifdef PROVA}cl_check_memory_allocation{$else}pointer{$endif}) : boolean; export; forward;
					chkm : pointer) : boolean; export; forward;
procedure	init_galateo(main_window_handle : hwnd;
					str_jolly_security_ID : string;		// identificatore di SICUREZZA che consente di capire se la chiamata proviene da JOLLY -- vedi funzione get_CASA_security_ID() su FPROCS
					bo_service_mode : boolean;
					wo_system_debug_mode : word;			// lasciare a zero per utilizzare i valori salvati da Galateo sul registry, oppure assegnare dei valori positivi
					system_RDEBUG_mode : RDEBUG_MODE_type;	// modalità di scrittura delle info di system-debug
					{str_calling_program,} str_author : string;
//					bo_PDF_allowed : boolean;	*** eliminato 2024-03-21
					str_parametri_connessione_DB : string = '';ptr : pointer = NIL); export; forward;

function		GALATEO_check_valid_printer : boolean; export; forward;

procedure	set_callback_replace_variabili_ambiente(func : callback_replace_variabili_ambiente_procedure_type); export;forward;

function		GAL_browse_files(father : TForm;str_default_print_path : string;
					var str_filename : string;
					bo_relative_path : boolean = TRUE	// parametro aggiunto 2009-02-12
				) : boolean; export;forward;

(*function		GAL_open(father : TForm;str_db_alias : string;
					str_caption,str_default_path : string;str_filename : string;
					str_parametri_connessione_DB : string;
					str_runtime_load_filenames : string) : integer; {export;}forward;*)
procedure	GAL_close(i_job : integer); export;forward;
function		GAL_print(i_job : integer;lo_print_style : integer) : boolean; export;forward;
function		GAL_open_and_print_method(father : TForm;{str_db_alias,} str_caption, str_default_path : string;
					report_info : report_info_type;setup_method : print_setup_method_type;lo_print_style : integer;str_parametri_connessione_DB : string = '';
					pt_str_last_exported_filename : string_punt = NIL;
					i_numero_stampe : integer = 1;str_runtime_load_filenames : string = '') : boolean; export;forward;
function		GAL_open_and_print_proc(father : TForm;{str_db_alias,} str_caption,str_default_path : string;
					report_info : report_info_type;	// 2016-02-01
					setup_proc : print_setup_procedure_type;lo_print_style : integer;
					str_parametri_connessione_DB : string = '';
					pt_str_last_exported_filename : string_punt = NIL;
					i_numero_stampe : integer = 1;str_runtime_load_filenames : string = '') : boolean; export;forward;

function		GAL_get_last_error(i_job : integer) : string; export;forward;
function		GAL_get_system_debug_filename : string; export;forward;

function		GAL_genera_parm_protetto(str_parm : string) : string;	export;forward;	// il parametro non avrà problemi anche se contiene virgole o altri caratteri speciali

function		GAL_set_textvar_value(i_job : integer;str_name,str_value : string;bo_must_exist : boolean = FALSE) : boolean; export;forward;
function		GAL_set_string_value(i_job : integer;str_name,str_value : string;bo_must_exist : boolean = FALSE) : boolean; export;forward;
//function		GAL_set_asciizvar_value(i_job : integer;str_name : string;lp_value : LPSTR;bo_must_exist : boolean = FALSE) : boolean; export;forward;
function		GAL_set_integer_value(i_job : integer;str_name : string;lo_value : integer;bo_must_exist : boolean = FALSE) : boolean; export;forward;
function		GAL_set_double_value(i_job : integer;str_name : string;do_value : double;bo_must_exist : boolean = FALSE) : boolean; export;forward;
function		GAL_set_textvar_listvalue(i_job : integer;str_name : string;tstr_list : TStrings;str_if_void : string;bo_must_exist : boolean = FALSE) : boolean; export;forward;
function		GAL_set_date_SQL(i_job : integer;str_name : string;dt : TDatetime;bo_must_exist : boolean = FALSE) : boolean; export;forward;
function		GAL_set_date_DMY(i_job : integer;str_name : string;dt : TDatetime;bo_must_exist : boolean = FALSE) : boolean;  export;forward;

function		GAL_exists_obj(i_job : integer;str_name : string) : boolean; export; forward;
function		GAL_exists_parm(i_job : integer;str_name : string) : boolean; export;forward;
function		GAL_exists_section(i_job : integer;str_section : string;var i_pagina_logica : integer) : boolean; export; forward;

function		GAL_set_global_option(i_job : word;i_option : word;str_value : string) : boolean; export; forward;

function		GAL_set_option(i_job, i_logical_page : integer;str_section : string;i_option : integer;lo_value : GAL_integer_parm) : boolean; export; forward;
function		GAL_get_option(i_job, i_logical_page : integer;str_section : string;lo_option : integer;var lo_value : GAL_integer_parm) : boolean; export;forward;

function		GAL_set_obj_option(i_job : integer;str_obj_name : string;i_option : integer;lo_value : GAL_integer_parm;bo_must_exist : boolean = FALSE) : boolean; export;forward;
function		GAL_get_obj_option(i_job : integer;str_obj_name : string;lo_option : integer;var lo_value : GAL_integer_parm;bo_must_exist : boolean = FALSE) : boolean;	export;forward;

//function		GAL_find_full_filename(str_default_path : string;var str_filename : string) : boolean; export;forward;

function		GAL_get_version_signature(bo_one_line_only : boolean) : string; export; forward;
function		GAL_get_version : integer; export; forward;			// versione eseguibile
function		GAL_get_DLL_version : integer; export; forward;		// versione DLL

function		GAL_get_descrizione(str_filename : string) : string; export; forward;
function		GAL_get_descrizione_path(str_filename, str_default_path : string;pt_bo_exists : GAL_boolean_punt = NIL) : string; export; forward;

// ------ end of EXPORT DECLARATIONS -------------------------------------------

type
	print_setup_method_punt = ^print_setup_method_type;
	print_setup_procedure_punt = ^print_setup_procedure_type;

EXPORTS set_GALATEO_universal_callback;
EXPORTS set_callback_replace_variabili_ambiente;
EXPORTS init_galateo;
EXPORTS GALATEO_check_valid_printer;
EXPORTS GAL_browse_files;
EXPORTS GAL_open_and_print_method;
EXPORTS GAL_open_and_print_proc;
//EXPORTS GAL_open;
EXPORTS GAL_close;
EXPORTS GAL_print;
EXPORTS GAL_set_textvar_value;
EXPORTS GAL_set_string_value;
EXPORTS GAL_exists_parm;
EXPORTS GAL_exists_obj;
EXPORTS GAL_exists_section;
//EXPORTS GAL_set_asciizvar_value;
EXPORTS GAL_set_integer_value;
EXPORTS GAL_set_double_value;
EXPORTS GAL_set_textvar_listvalue;
EXPORTS GAL_set_date_SQL;
EXPORTS GAL_set_date_DMY;
EXPORTS GAL_get_last_error;
EXPORTS GAL_get_system_debug_filename;
EXPORTS GAL_set_global_option;
EXPORTS GAL_set_option;
EXPORTS GAL_get_option;
EXPORTS GAL_set_obj_option;
EXPORTS GAL_get_obj_option;
EXPORTS GAL_genera_parm_protetto;
//EXPORTS GAL_find_full_filename;
EXPORTS GAL_get_version_signature;
EXPORTS GAL_get_version;
EXPORTS GAL_get_DLL_version;
EXPORTS GAL_get_descrizione;
EXPORTS GAL_get_descrizione_path;

(*{$I printopt.h}	{ elenco delle opzioni disponibili } *)

{ ***************************************************************************** }

var
	str_filename : array[1..MAX_JOBS] of string;
	universal_setup_proc : universal_callback_procedure_type;

	bo_initialized : boolean;

(*function GAL_find_full_filename(str_default_path : string;var str_filename : string) : boolean;
{ determina il nome del file completo;
  se trova il file rende TRUE e carica il nome (completo) del file su STR_FILENAME, altrimenti rende FALSE e non fa nulla;
  RICERCA: se il file con path non esiste, provo senza, poi con il path standard;
  il path standard può contenere più paths separati da puntoevirgola;
  se non esiste nè l'uno nè l'altro nè quell'altro, rende FALSE }

	function try_filename(s : string) : boolean;
	// se il file specificato esiste, assegna STR_FILENAME := S e rende TRUE
	begin
		result := FileExists(s);
		if result then str_filename := s
		{$ifdef RD} else runtime_debug('file:'+ACAPO+s+' non esiste','GAL_find_full_filename()',FALSE) {$endif}
	end;

begin
	var s := set_extension(str_filename,DEFAULT_EXT);
	var str_without_path := filename_without_path(s);
{	result := try_filename(s) OR
		try_filename(str_default_path + s) OR
		try_filename(filename_without_path(s)) OR
		try_filename(str_default_path+filename_without_path(s)) }
	result := FALSE;
	// se il nome ha un path, lo provo
	if (str_without_path <> s) then result := try_filename(s);
	// provo i percorsi default
	while NOT result AND (str_default_path <> '') do begin
		var i : smallint := pos(';', str_default_path);
		if (i = 0) then i := length(str_default_path)+1;
		var str_temp := copy(str_default_path,1,i-1);delete(str_default_path,1,i);
		if (copy(str_temp,length(str_temp),1) <> '\') then str_temp := str_temp + '\';
		result := try_filename(str_temp + s) OR try_filename(str_temp+str_without_path)
	end;
	// provo il nome senza alcun path (percorso corrente)
	if NOT result then result := try_filename(str_without_path)
end; *)

function GAL_open(father : TForm;{str_db_alias,} str_caption, str_default_path, str_filename, str_parametri_connessione_DB, str_runtime_load_filenames : string) : integer;
// rende il print-job avviato, oppure 0 in caso di errore
const MBOX_RUNTIME_DEBUG_CAPTION = 'GAL_open()';
var bo_stopped : boolean;	//*
begin
	result := 0;
	var i_job : smallint := 0;
	var bo_own_ww := FALSE;
	var old_form : TForm := NIL;

	if NOT bo_initialized then begin
		MessageBBox(father, 'Galateo non è stato inizializzato', MBOX_CAPTION);
		exit
	end;

//	if (str_db_alias = '') then str_db_alias := str_default_databasename;
	if (str_parametri_connessione_DB = '') then str_parametri_connessione_DB := xstr_default_connection_parms;

	try
		{$ifdef RD} runtime_debug('pre*window', MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00); {$endif}
		try
			i_job := alloca_job(father);if (i_job = 0) then exit;
			xprint_status[i_job] := PS_LOADING;	// non prima di qui, fa casino (o magari è il debugger che fa casino, cmq meglio evitare)

			if NOT esiste_stampante then begin
				MessageBBox(father, 'Nessuna stampante installata nel sistema' + ACAPO2 +
					'(ma come fai a stampare se non hai la stampante?)', MBOX_CAPTION, MB_ICONSTOP);
				abort
			end;
//sleep(1000);
			bo_own_ww := NOT ww_exists;
			if bo_own_ww then ww_create_preparing(father, TRUE, bo_stopped);
			ww_set_text('fase di caricamento report');
			if bo_own_ww then ww_show;

			{$ifdef RD} runtime_debug('inizio', MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00); {$endif}
			set_mbox_caption(str_caption);

			if NOT find_full_filename(str_default_path, str_filename, GALATEO_EXT) then begin
				MessageBBox(father, 'Il report non esiste.' + ACAPO2 + str_filename, str_caption, MB_ICONSTOP);
				abort
			end;
			casa.str_filename[i_job] := str_filename;
//			workwin.set_text(2, reduce_filename(str_filename, 40));
			ww_set_text(2, reduce_filename(str_filename, 40));
			{$ifdef RD} runtime_debug('il file esiste:' + ACAPO + str_filename, MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00); {$endif}
			assign_globale(i_job, TGlobale.create_dll(father, i_job, str_author));
			if NOT silent_mode then old_form := globale.set_main_form(get_working_window);
			{$ifdef RD} runtime_debug('after_assign_globale', MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00); {$endif}
			if NOT get_globale(i_job).load(father, str_filename, str_runtime_load_filenames) then abort;
			{$ifdef RD} runtime_debug('after get_globale',MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00); {$endif}
			set_pagina_logica_attiva_ZB(0, TRUE);	// dopo il caricamento potrebbe non essere attiva la prima pagina, ma una delle successive
//			if (str_db_alias + str_parametri_connessione_DB <> '') then get_globale(i_job).set_db_driver_runtime(str_db_alias, str_parametri_connessione_DB, TRUE);
			if (str_parametri_connessione_DB <> '') then get_globale(i_job).set_db_driver_runtime(str_parametri_connessione_DB);
			{$ifdef RD} runtime_debug('file caricato', MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00); {$endif}
//sleep(1000);
			log_parameter(casa.str_filename[i_job], i_job, '', 'start');
			xprint_status[i_job] := PS_LOADED
		except
			{$ifdef RD} runtime_debug('exception on GAL_open', MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00); {$endif}
			xprint_status[i_job] := PS_INATTIVA;
			if (i_job <> 0) then begin free_job(i_job);i_job := 0 end
		end
	finally
		if (globale <> NIL) then globale.set_main_form(old_form);
		if bo_own_ww AND ww_exists then begin
//			workwin.chiudi_finestra;workwin.free
			ww_close
		end
	end;
	result := i_job
end;

function GAL_set_parametro(str_parm : string) : boolean;
// applica il parametro specificato; rende TRUE in caso di successo, FALSE altrimenti; emette eventuali messaggi di errore
const INVALID_PARM_VALUE = 'Valore parametro non valido';
begin
	result := FALSE;
	var s : string := str_parm.Trim;	//		{$ifndef PROVA} *** {se viene inserito un parametro sbagliato, la seconda stampa fallisce sempre} {$endif}   **** NON CAPISCO IL SENSO DEL MIO COMMENTO PRECEDENTE
	try
//		if start_with(s, AORT_PARAMETRO_BASE, {casesensitive}FALSE) then begin
		if s.StartsWith(AORT_PARAMETRO_BASE, {ignorecase}TRUE) then begin
			delete(s, 1, length(AORT_PARAMETRO_BASE));
			for var i : smallint := 0 to byte(high(azione_opening_report_type)) do begin
				if (uppercase(s) = AORT_RUNTIME_PARMS[azione_opening_report_type(i)]) then begin
					globale.azione_opening_report_executive := azione_opening_report_type(i);
					result := TRUE;exit
				end
			end;
			raise exception.create(INVALID_PARM_VALUE)
		end;
		raise exception.create('parametro non riconosciuto')
	except
		error_msg('Errore durante la valutazione del parametro ' + str_parm + ACAPO2 + get_last_exception_msg, MBOX_CAPTION)
	end
end;

function GAL_print(i_job : integer;lo_print_style : integer) : boolean;
// rende TRUE in caso di successo, FALSE altrimenti
begin
	result := FALSE;
	try
		set_active_job(i_job);
		globale.stampa(get_father_of_job(i_job), FALSE, lo_print_style);
		result := (xprint_status[i_job] = PS_OK) OR ((lo_print_style AND GAL_POPT_SUCCESS_ON_ANTEPRIMA <> 0) AND (xprint_status[i_job] = PS_PREVIEW))
	except
//		result := FALSE
	end
end;

function GAL_set_textvar_value(i_job : integer;str_name,str_value : string;bo_must_exist : boolean = FALSE) : boolean;
{ imposta il valore della variabile di testo STR_NAME;
  rende FALSE se la variabile non esiste e se BO_MUST_EXIST, TRUE altrimenti }
begin
	result := GAL_set_string_value(i_job, str_name, str_value, bo_must_exist)
end;

function GAL_set_string_value(i_job : integer;str_name,str_value : string;bo_must_exist : boolean = FALSE) : boolean;
{ imposta il valore della variabile di testo STR_NAME;
  rende FALSE se la variabile non esiste e se BO_MUST_EXIST, TRUE altrimenti }
begin
//	result := GAL_set_asciizvar_value(i_job,str_name,asciiz(str_value),bo_must_exist)
	try
		set_active_job(i_job);
		{$ifdef RD} runtime_debug(str_value, 'set parm: ' + str_name, RD_DEBUG_PRINCIPALE_00); {$endif}
		log_parameter(str_filename[i_job], i_job, str_name, str_value);
//		xobj := name2obj(str_name, [xVARIABILE], TRUE);	*** fino al 2011-05-18
		var xobj : objs_type := name2obj(str_name, TV_OLD_VARIABILI, TRUE);
		if (xobj <> NIL) then begin
			xobj.aslabel.str_print := str_value;
//			strcpychk(xobj.aslabel.lp_print,LPSTR(str_value));
			result := TRUE
		end
		else begin
			if bo_must_exist then set_last_job_error('Variabile <' + str_name + '> non trovata');
			result := NOT bo_must_exist
		end
	except
		result := FALSE
	end
end;

(*function GAL_set_asciizvar_value(i_job : integer;str_name : string;lp_value : LPSTR;bo_must_exist : boolean = FALSE) : boolean;
{ imposta il valore della variabile di testo STR_NAME;
  rende FALSE se la variabile non esiste e se BO_MUST_EXIST, TRUE altrimenti }
//var xobj : objs_type;
begin
	result := GAL_set_string_value(i_job,str_name,string(lp_value),bo_must_exist)
end;*)

function GAL_set_double_value(i_job : integer;str_name : string;do_value : double;bo_must_exist : boolean = FALSE) : boolean;
begin
//	result := GAL_set_asciizvar_value(i_job,str_name,asciiz(str_value),bo_must_exist)
	try
		set_active_job(i_job);
		var str_value := strid(do_value, 0, 0);
		{$ifdef RD} runtime_debug(str_value, '*set parm*: ' + str_name, RD_DEBUG_PRINCIPALE_00); {$endif}
//		xobj := name2obj(str_name, [xVARIABILE], TRUE);	*** fino 2011-05-18
		var xobj : objs_type := name2obj(str_name, TV_OLD_VARIABILI, TRUE);
		log_parameter(str_filename[i_job], i_job, str_name, str_value);
		if (xobj = NIL) then begin
			if bo_must_exist then set_last_job_error('Variabile <' + str_name + '> non trovata');
			result := NOT bo_must_exist
		end
		else {with xobj.aslabel do } begin
			var lab : cl_label := xobj.aslabel;
			lab.bo_null := FALSE;
			lab.xdbl_print_value := do_value;
			lab.str_print := str_value;
			if (xobj.ca.tipo_valore <> VAL_NUMERO) then begin
				set_last_job_error('La variabile <' + str_name + '> non è di tipo numerico');
				result := FALSE
			end
			else result := TRUE
		end
	except
		result := FALSE
	end
end;

function GAL_set_integer_value(i_job : integer;str_name : string;lo_value : integer;bo_must_exist : boolean = FALSE) : boolean;
begin
	result := GAL_set_double_value(i_job, str_name, lo_value, bo_must_exist)
end;

function GAL_exists_parm(i_job : integer;str_name : string) : boolean;
// rende TRUE se la variabile specificata esiste ed è un parametro
begin
	set_active_job(i_job);
//	x := name2obj(str_name, [xVARIABILE], TRUE);		*** fino al 2011-05-18
	var x : objs_type := name2obj(str_name, TV_OLD_VARIABILI, TRUE);
	result := (x <> NIL) AND (x.ca.tipo_variabile = TV_PARAMETRO)
end;

function GAL_exists_obj(i_job : integer;str_name : string) : boolean;
// rende TRUE se l'oggetto (qualunque cosa esso sia) esiste
begin
	set_active_job(i_job);
	result := (name2obj(str_name, TRUE) <> NIL)
end;

function GAL_exists_section(i_job : integer;str_section : string;var i_pagina_logica : integer) : boolean;
{ rende TRUE se la sezione esiste;
  se i_page = 0 cerca su tutte le pagine, altrimenti sulla pagina logica indicata;
  su i_page in output carica il numero di pagina su cui è stata trovata la sezione }

	function search_section(i_pagina_logica : smallint) : boolean;
	// rende TRUE se trova la sezione sulla pagina indicata
	begin
		for var j : smallint := 1 to get_num_sections_page(i_pagina_logica) do
			if str_section = uppercase(sections_1B(j, i_pagina_logica).str_nome) then begin
				result := TRUE;exit
			end;
		result := FALSE
	end;

begin
	set_active_job(i_job);
	if (i_pagina_logica < 0) OR (i_pagina_logica > get_ultima_pagina_logica) then i_pagina_logica := 0;
	str_section := uppercase(str_section);
	if (i_pagina_logica = 0) then begin
		for var i : smallint := 1 to get_ultima_pagina_logica do
			if search_section(i) then begin result := TRUE;i_pagina_logica := i;exit end;
		result := FALSE
	end
	else result := search_section(i_pagina_logica)
end;

function GAL_set_textvar_listvalue(i_job : integer;str_name : string;
	tstr_list : TStrings;str_if_void : string;bo_must_exist : boolean = FALSE) : boolean;
{ imposta il valore della variabile STR_NAME con i valori contenuti nella string list, separati da virgole;
  se la lista è vuota, per evitare problemi con l'SQL viene comunque caricato il valore STR_IF_VOID;
  rende FALSE in caso di fallimento, oppure se la variabile non esiste AND bo_must_exist }
var str_value : string;
begin
	try
		set_active_job(i_job);
//		xobj := name2obj(str_name,[xVARIABILE],TRUE);	*** fino al 2011-05-18
		var xobj : objs_type := name2obj(str_name, TV_OLD_VARIABILI, TRUE);
		if (xobj = NIL) then begin
			if bo_must_exist then set_last_job_error('Variabile <' + str_name + '> non trovata');
			result := bo_must_exist;exit
		end;
		if (tstr_list = NIL) OR (tstr_list.count = 0) then str_value := str_if_void
		else for var i : smallint := 0 to tstr_list.count-1 do add_delimited(str_value, tstr_list[i]);
		xobj.aslabel.str_print := str_value;
		log_parameter(str_filename[i_job], i_job, str_name, str_value);
		result := TRUE
	except
		result := FALSE
	end
end;

function GAL_set_date_SQL(i_job : integer;str_name : string;dt : TDatetime;bo_must_exist : boolean = FALSE) : boolean;    	// assegna la data in formato SQL
begin
	result := GAL_set_string_value(i_job, str_name, dt2SQL(dt,{inapicia}FALSE), bo_must_exist)
end;

function GAL_set_date_DMY(i_job : integer;str_name : string;dt : TDatetime;bo_must_exist : boolean = FALSE) : boolean;    	// assegna la data in formato DD/MM/YYYY
begin
	result := GAL_set_string_value(i_job, str_name, asstring_data(dt, '/'), bo_must_exist)
end;

procedure GAL_close(i_job : integer);
const MBOX_RUNTIME_DEBUG_CAPTION = 'GAL_close()';
begin
	try
		{$ifdef RD} runtime_debug('starting', MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00); {$endif}
		set_active_job(i_job);
		try
			{$ifdef RD} runtime_debug('pre close controllo',MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00); {$endif}
//			if (control.controllo <> NIL) then control.controllo.close;									*** fino 2009-06-14
//			if (globale <> NIL) then globale.close;
			{$ifdef RD} runtime_debug('post close controllo',MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00); {$endif}
		except
			// chissenefre
		end;
		free_job(i_job)		// eseguo sempre e comunque
	except
		{$ifdef RD} runtime_debug('exception', MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00) {$endif}
	end
end;

function GAL_open_and_print(father : TForm;{str_db_alias : string;}
	str_caption, str_default_path : string;
	report_info : report_info_type;
	setup_method : print_setup_method_type;setup_proc : print_setup_procedure_type;
	str_parametri_connessione_DB : string;
	pt_str_last_exported_filename : string_punt;
	lo_print_style, i_numero_stampe : integer;
	str_runtime_load_filenames : string) : boolean;
{ rende TRUE in caso di successo, FALSE altrimenti;
  la procedura di stampa viene richiamata per I_NUMERO_STAMPE volte;
  se I_NUMERO_STAMPE <> 0 then lo stile di stampa viene sempre impostato a GAL_POPT_PRINT_PRINTER_DIRECT;
  per il momento semplicemente è una iterazione della stessa procedura "n load + n print";
  in futuro, quando avrò un minimo di tempo, dovrebbe essere trasformata in "1 load + n print" }
const MBOX_DEBUG_CAPTION = 'GAL_open_and_print()';
var
	i_job : smallint;	//*
	s, str_filename, str_temp, str_parms : string;
	bo_stopped : boolean;	//*
begin
	result := FALSE;//i_job := 0;

//	{$ifdef DEBUG} static_immediate_debug(MBOX_DEBUG_CAPTION + ' -- start'); {$endif DEBUG}
	work_SMTP.assign(registry_SMTP);	// ricarico i dati SMTP default
	try
		i_numero_stampa_multipla := 0;
		if (i_numero_stampe = 0) then i_numero_stampe := 1;	// tanto per evitare situazioni banali
		if (i_numero_stampe > 1) then begin
//			workwin := Tdlg_working.create_preparing(father, TRUE, bo_stopped);
			ww_create_preparing(father, TRUE, bo_stopped);
//			workwin.show;
			ww_show;
			lo_print_style := GAL_POPT_DIRECTLY_EXECUTE
		end;

		if (lo_print_style AND GAL_POPT_SILENT <> 0) then set_silent_mode(TRUE);

//		{$ifdef DEBUG} static_immediate_debug(MBOX_DEBUG_CAPTION + ' -- 100'); {$endif DEBUG}
		str_filename := report_info.str_filename;
		var j : smallint := pos('/', str_filename);
		if (j <> 0) then begin
			str_parms := copy(str_filename, j, MAXINT);
			str_filename := togliblanks(copy(str_filename, 1, j-1))
		end;
//		{$ifdef DEBUG} static_immediate_debug(MBOX_DEBUG_CAPTION + ' -- 200'); {$endif DEBUG}
		for var i : smallint := 1 to i_numero_stampe do begin
//			workwin.set_caption(str_caption + ' (' + i.ToString + '/' + i_numero_stampe.ToString + ')');
			ww_set_caption(str_caption + ' (' + i.ToString + '/' + i_numero_stampe.ToString + ')');

			try
//				if (str_db_alias = '') then str_db_alias := coalesce(globale.str_runtime_default_database_alias, str_runtime_default_system_database_alias);
//				if (str_db_alias = '') then str_db_alias := str_runtime_default_system_database_alias;
				i_job := GAL_open(father, {db_alias,} {caption}str_filename, str_default_path, str_filename, str_parametri_connessione_DB, str_runtime_load_filenames);
				if (i_job = 0) then abort;
				s := togliblanks(str_parms);
				while (s <> '') do begin
					var k : smallint := pos('/', copy(s, 2, MAXINT));if (k = 0) then k := length(s)+1 else inc(k);
					str_temp := togliblanks(copy(s, 1, k-1));s := togliblanks(copy(s, k, MAXINT));
					if NOT GAL_set_parametro(str_temp) then abort
				end
			except
				exit
			end;

			// se SERVICE uso quelli assegnati all'avvio (x' il registry letto è quello dell'account e non quello di sistema)
			if NOT get_service_mode then set_report_debug_target(str_filename, computer_registry_data.debug_target, computer_registry_data.Rdebug_mode);
{$ifdef DEBUG}
{			static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: SYSTEM-DEBUG =' + RDEBUG_DESCRIZIONE[RDEBUG_active_mode] + '   ' + get_debug_trace_mode.ToString);
			static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: REPORT-DEBUG = ' + RDEBUG_DESCRIZIONE[report_Rdebug_mode] + '   ' + GALATEO_DEBUG_TARGET_DESCR[report_debug_target]); {}
{$endif DEBUG}

			try
				debug(100, MBOX_DEBUG_CAPTION, 'pre universal callback');
				{$ifdef RD} runtime_debug('pre universal callback', MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00); {$endif}
				if (@universal_setup_proc <> NIL) AND NOT universal_setup_proc(i_job, report_info) then abort;
				debug(110, MBOX_DEBUG_CAPTION, 'pre setup callback');
				{$ifdef RD} runtime_debug('pre setup callback', MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00); {$endif}
				if ((@setup_method <> NIL) AND NOT setup_method(i_job)) OR ((@setup_proc <> NIL) AND NOT setup_proc(i_job)) then abort;
				debug(120, MBOX_DEBUG_CAPTION, 'pre log parms');
				{$ifdef RD} runtime_debug('pre log parms', MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00); {$endif}
				log_parameter(casa.str_filename[i_job], i_job, '', 'end');
				debug(130, MBOX_DEBUG_CAPTION, 'after log parms')
			except
				s := GAL_get_last_error(i_job);
				debug(190, MBOX_DEBUG_CAPTION, 'exception: ' + s);
				if (s <> '') then MessageBBox(father, s, str_filename, MB_ICONSTOP);
				GAL_close(i_job);exit
			end;

			try
				{$ifdef RD} runtime_debug('pre print', MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00); {$endif}
//				globale.i_active_monitor := get_active_monitor(father);
//				messageBBox(0, 'ACTIVE MONITOR = ' + globale.i_active_monitor.ToString, 'CASA');
//try abort; except error_msg(handle, 'Unknown exception eabort 0x13329134 at address 9938A33FB8', MBOX_CAPTION) end;	{$ifdef PROVA} *** {$endif}
//*	error_msg(0, 'Unknown exception eabort 0x13329134 at address 9938A33FB8', MBOX_CAPTION);		{$ifdef PROVA} *** {$endif}
//				static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: BEFORE GAL_PRINT :: ' + RDEBUG_DESCRIZIONE[RDEBUG_active_mode] + '   ' + GALATEO_DEBUG_TARGET_DESCR[galateo_debug.debug_target]);
				result := GAL_print(i_job, lo_print_style);
//				static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: AFTER GAL_PRINT :: ' + RDEBUG_DESCRIZIONE[RDEBUG_active_mode] + '   ' + GALATEO_DEBUG_TARGET_DESCR[galateo_debug.debug_target]);
				if (pt_str_last_exported_filename <> NIL) then pt_str_last_exported_filename^ := globale.str_last_exported_filename;
				if NOT result then break
			finally
				{$ifdef RD} runtime_debug('pre close', MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00); {$endif}
				GAL_close(i_job)
			end
		end
	finally
//		if (i_numero_stampe > 1) AND (xdlg_working <> NIL) then begin xdlg_working.chiudi_finestra;xdlg_working.free end
		if (i_numero_stampe > 1) then ww_close;
		if (father <> NIL) then ForceForegroundWindow(father.Handle);			// 2011-09-08
		set_silent_mode(FALSE)
	end
end;

function GAL_open_and_print_method(father : TForm;{str_db_alias,} str_caption, str_default_path : string;
	report_info : report_info_type;setup_method : print_setup_method_type;lo_print_style : integer;
	str_parametri_connessione_DB : string = '';pt_str_last_exported_filename : string_punt = NIL;
	i_numero_stampe : integer = 1;str_runtime_load_filenames : string = '') : boolean;
// rende TRUE in caso di successo, FALSE altrimenti
var local_report_info : report_info_type;		// copia dei dati locale alla DLL; per evitare problemi con le stringhe dinamiche allocate tra EXE e DLL
begin
{	result := GAL_open_and_print(father, str_db_alias, str_caption, str_default_path, report_info, setup_method, NIL,
		str_parametri_connessione_DB, lo_print_style, i_numero_stampe, str_runtime_load_filenames) }

	// creo una copia locale dei dati del report (per evitare problemi con le stringhe dinamiche allocate tra EXE e DLL) (2016-08-13)
	SetString(local_report_info.str_filename, LPSTR(report_info.str_filename), length(report_info.str_filename));
	SetString(local_report_info.str_description, LPSTR(report_info.str_description), length(report_info.str_description));
	local_report_info.lo_key_report := report_info.lo_key_report;

	result := GAL_open_and_print(father, {db_alias,} str_caption, str_default_path, local_report_info, setup_method, NIL,
		str_parametri_connessione_DB, pt_str_last_exported_filename, lo_print_style, i_numero_stampe, str_runtime_load_filenames)
end;

function GAL_open_and_print_proc(father : TForm;{str_db_alias,} str_caption, str_default_path : string;
	report_info : report_info_type;setup_proc : print_setup_procedure_type;lo_print_style : integer;
	str_parametri_connessione_DB : string = '';
	pt_str_last_exported_filename : string_punt = NIL;
	i_numero_stampe : integer = 1;str_runtime_load_filenames : string = '') : boolean;
// rende TRUE in caso di successo, FALSE altrimenti
begin
	result := GAL_open_and_print(father, {db_alias,} str_caption, str_default_path, report_info, NIL, setup_proc,
		str_parametri_connessione_DB, pt_str_last_exported_filename, lo_print_style, i_numero_stampe, str_runtime_load_filenames)
end;

function GAL_get_last_error(i_job : integer) : string;
begin
	try
		set_active_job(i_job);
		result := get_last_job_error
	except
		result := 'Impossibile reperire l''ultimo errore di stampa'
	end
end;

function GAL_set_option(i_job, i_logical_page : integer;str_section : string;i_option : integer;lo_value : GAL_integer_parm) : boolean;
{ imposta l'opzione specificata; rende TRUE in caso di successo;
  passare I_PAGE = -1 per impostare tutte le pagine contemporaneamente;
  passare I_SECTION = '' per impostare tutte le sezioni della/delle pagine specificate }

	function set_page(i_page : integer;bo_abort_if_invalid : boolean) : boolean;
	// rende TRUE in caso di successo, FALSE altrimenti

		procedure set_option(i_page, i_section : integer);
		begin
{$ifdef RD}
			runtime_debug(
				'i_page:' + i_page.ToString + ACAPO +
				'sezione:' + i_section.ToString + ACAPO +
				'opzione:' + i_option.ToString, 'set option (set_option())',  RD_DEBUG_PRINCIPALE_00);
{$endif RD}
			var s := sections_1B(i_section, i_page);
			{$ifdef PROVA} assert(s <> NIL,'GAL_SET_OPTION: sezione non trovata'); {$endif}
			with s do case i_option of
				GAL_OPT_STAMPA_ANCHE_SE_VUOTA : bo_stampa_anche_se_vuota := boolean(lo_value);
				GAL_OPT_STAMPA_SENZA_DATI : begin
					bo_senza_dati := boolean(lo_value);
					if bo_senza_dati then bo_stampa_anche_se_vuota := TRUE
				end;
				GAL_OPT_DONT_PRINT_SECTION : bo_dont_print_section := boolean(lo_value);
//				GAL_OPT_SECTION_HEIGHT : *;
				GAL_OPT_PAGE_WIDTH_MM : set_Vpage_size_X_cm(i_page, lo_value / 10);
				else {$ifdef PROVA} assert(FALSE,'GAL_set_option: OPZIONE non valida') {$endif}
			end
		end;

	begin // set_page()
		try
{$ifdef RD}
			runtime_debug(
				'i_page:' + i_page.ToString + ACAPO +
				'sezione:' + str_section + ACAPO +
				'opzione:' + i_option.ToString + ACAPO +
				'valore:' + lo_value.ToString,
				'set option (set_page())',  RD_DEBUG_PRINCIPALE_00);
{$endif}
			if (i_option in GAL_STRING_PARM_OPTIONS) then begin
				var s := strpas(LPSTR(lo_value));
				case i_option of
					GAL_GOPT_SET_EXPORT_PATH : globale.str_default_export_filepath := s;
//					GAL_GOPT_SET_EMAIL_DEFAULT_ADDRESS : globale.set_email_runtime_default(s);					*** qui fino al 2014-09-05
//					GAL_GOPT_SET_EMAIL_ADDRESS_LIST_TO : globale.set_email_runtime_elenco(s, MTT_TO);
//					GAL_GOPT_SET_EMAIL_ADDRESS_LIST_CC : globale.set_email_runtime_elenco(s, MTT_CC);
//					GAL_GOPT_SET_EMAIL_ADDRESS_LIST_CCN : globale.set_email_runtime_elenco(s, MTT_CCN);
					GAL_GOPT_SET_EMAIL_DEFAULT_ADDRESS : globale.set_email_runtime_default(s);
					GAL_GOPT_SET_EMAIL_ADDRESS_LIST_TO, GAL_GOPT_SET_EMAIL_ADDRESS_LIST_CC, GAL_GOPT_SET_EMAIL_ADDRESS_LIST_CCN :
						globale.set_email_runtime_elenco(s, mail_target_type(i_option - GAL_GOPT_SET_EMAIL_ADDRESS_LIST_TO));
					GAL_GOPT_PROFILE_SELECT : set_active_profile(s, i_page, {set_from_calling_program}TRUE);
					{$ifdef PROVA} else assert(FALSE, 'GAL_set_option() -- STRING_OPTION non trattata -- KJWE 3102') {$endif}
				end;
				result := TRUE;exit
			end;

			if (i_option in GAL_NUMERIC_PARM_OPTIONS) then begin
				case i_option of
					GAL_GOPT_DONT_SET_APPLICATION_PRINTER : globale.bo_usa_sempre_printer_report := boolean(lo_value)
					{$ifdef PROVA} else assert(FALSE, 'GAL_set_option() -- STRING_OPTION non trattata -- KJWE 3102') {$endif}
				end;
				result := TRUE;exit
			end;

			if (str_section = '') then begin
				for var i_section : section_index_type := 1 to get_num_sections_page(i_page) do set_option(i_page, i_section)
			end
			else begin
				str_section := uppercase(str_section);
				var i_section : section_index_type := get_num_sections_page(i_page);
				while (i_section > 0) AND (str_section <> uppercase(sections_1B(i_section, i_page).str_nome)) do dec(i_section);
				if (i_section > 0) then set_option(i_page, i_section)
				else if bo_abort_if_invalid then abort	// sezione indicata, ma non riconosciuta
			end;
			result := TRUE
		except
			result := FALSE
		end
	end;

begin
{$ifdef RD}
	runtime_debug(
		'i_page:' + i_logical_page.ToString + ACAPO +
		'sezione:' + str_section + ACAPO +
		'opzione:' + i_option.ToString, 'set option', RD_DEBUG_PRINCIPALE_00);
{$endif}
	set_active_job(i_job);
	job_stack.push_status;
	try
		if (i_option = GAL_GOPT_PRINTER_SELECT) then begin
			var s := strpas(LPSTR(lo_value));
//			if (NOT globale.xbo_usa_sempre_printer_report OR (globale.xstr_printer = '')) AND
			if (NOT globale.bo_usa_sempre_printer_report OR (globale.str_current_printer = '')) AND		// se non ci sono vincoli contrari (oppure se NESSUNA STAMPANTE è correntemente assegnata)
				(printer.printers.indexof(s) <> -1)			// se la stampante assegnanda è valida
					then globale.str_current_printer := s			//	{$ifNdef PROVA} *** {verificare funzionamento assegnazione} {$endif}
		end
		else begin
			if (i_logical_page = -1) then begin
				for i_logical_page := 1 to get_ultima_pagina_logica do
					if NOT set_page(i_logical_page, FALSE) then abort
			end
			else if NOT set_page(i_logical_page, TRUE) then abort
		end;
		result := TRUE
	except
		set_last_job_error('Errore durante l''impostazione delle sezioni di stampa');
		result := FALSE
	end;
	job_stack.pop_status
end;

//function GAL_set_global_option(i_job : word;i_option : word;str_value : string) : boolean;		**** fino al 2012-11-20
function GAL_set_global_option(i_job : word;i_option : word;str_value : string) : boolean;
{ impostazione di opzioni globali per il programma (ad esempio configurazione SMTP);
  per le impostazioni STATICHE (non legate ad uno specifico contesto) I_JOB può (deve) valere ZERO; altrimenti passare il numero di job da trattare }
const MBOX_RUNTIME_DEBUG_CAPTION = 'GAL_set_global_option()';
var str_local_value : string;
begin
	SetString(str_local_value, LPSTR(str_value), length(str_value));		// genero una copia locale del valore
	{$ifdef RD} runtime_debug('option:' + i_option.ToString + ACAPO + 'value:' + str_local_value, MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00); {$endif}
	if (i_job <> 0) then begin set_active_job(i_job);job_stack.push_status end;

	try
		result := TRUE;
		case i_option of
//			GAL_GOPT_SET_DEFAULT_DATABASE_ALIAS : globale.str_runtime_default_database_alias := str_local_value;
{			GAL_GOPT_SET_DEFAULT_DATABASE_ALIAS :
				if (i_job = 0) then str_runtime_default_system_database_alias := str_local_value
				else globale.str_runtime_default_database_alias := str_local_value;
//			GAL_GOPT_SET_DEFAULT_DATABASE_DRIVER : globale.str_runtime_default_database_driver := str_local_value;
			GAL_GOPT_SET_DEFAULT_DATABASE_DRIVER :
				if (i_job = 0) then str_runtime_default_system_database_driver := str_local_value
				else globale.xstr_runtime_default_database_driver := str_local_value; }
			GAL_GOPT_SET_DEFAULT_CONNECTION_PARMS :
				if (i_job = 0) then xstr_default_connection_parms := str_local_value
				else globale.connection_config.str_external_connection_parms := str_local_value;

(*			GAL_MODALITA_MAIL_CALLING_PROGRAM :		********** versione D6
				if is_numeric(str_value) AND (strtoint(str_value) in [0..byte(high(galateo_send_mail_mode_type))])
					then globale.modalita_invio_mail := galateo_send_mail_mode_type(strToInt(str_value))
				else result := FALSE;
			GAL_MODALITA_MAIL_CALLING_PROGRAM :		********* versione modificata 2024-03-12
				if is_numeric(str_local_value) AND (str_local_value.ToInteger in [0..byte(high(galateo_send_mail_mode_type))]) then begin
					if (globale.modalita_invio_mail in [GSMM_BLANK, GSMM_CALLING_PROGRAM{, GSMM_DEFAULT_MAPI_CLIENT, GSMM_LOCAL_SMTP, GSMM_OUTLOOK}])	// 2024-03-12: lascio l'impostazione forzata sul report
						then globale.modalita_invio_mail := galateo_send_mail_mode_type(str_local_value.ToInteger)
				end
				else result := FALSE; *)
			GAL_MODALITA_MAIL_CALLING_PROGRAM :
				if is_numeric(str_local_value) AND (str_local_value.ToInteger in [0..byte(high(galateo_send_mail_mode_type))]) then begin
					// se GALATEO non ha forzato la modalità di invio mail (ma ha lasciato al programma chiamante la possibilità di riassegnarla)
					if (globale.send_mail_modalita_standard_galateo in [GSMM_BLANK, GSMM_CALLING_PROGRAM{, GSMM_DEFAULT_MAPI_CLIENT, GSMM_LOCAL_SMTP, GSMM_OUTLOOK}])	// 2024-03-12: lascio l'impostazione forzata sul report
						then globale.modalita_invio_mail := galateo_send_mail_mode_type(str_local_value.ToInteger)
				end
				else result := FALSE;

			GAL_FORZA_MODALITA_MAIL_GALATEO :
				if is_numeric(str_local_value) AND (str_local_value.ToInteger in [0..byte(high(galateo_send_mail_mode_type))])
					then globale.modalita_invio_mail := galateo_send_mail_mode_type(str_local_value.ToInteger)
				else result := FALSE;
			GAL_SMTP_CONFIGURATION_DATA : work_SMTP.data.asText := str_local_value;		// assegnazione complessiva di tutti i parametri di configurazione SMTP -- uso SEMPRE quelli del programma chiamante in quanto più affidabili e attuali
			GAL_OUTLOOK_CONFIGURATION_DATA : static_outlook.asText := str_local_value;		// assegnazione complessiva di tutti i parametri di configurazione OUTLOOK
			GAL_SMTP_FIRMA : work_SMTP.str_firma := str_local_value;	// parametro separato x' la firma non è un elemento a sè stante, ma solo una informazione che sarà utilizzata per comporre il messaggio finale
			GAL_SMTP_CCN : work_SMTP.str_CCN := str_local_value;
//			GAL_SMTP_PROTOCOL : box_SMTP_protocol_calling_program := SQL2boolx(str_local_value);
			GAL_SMTP_PROTOCOL : box_SMTP_protocol_calling_program.read_SQL(str_local_value);
//			GAL_GOPT_MESSAGE_MAIL_MULTIPLE : globale.bo_warning_on_multiple_mail_addresses := SQL2bool(str_local_value);
			GAL_GOPT_MESSAGE_MAIL_MULTIPLE : globale.bo_warning_on_multiple_mail_addresses.read_SQL(str_local_value);
			GAL_GOPT_USER_MESSAGE_MAIL : globale.str_runtime_mail_user_message := str_local_value;
			GAL_GOPT_ADD_URL_RUNTIME : if (str_local_value <> '') then add_delimited(globale.str_links_runtime, str_local_value, ACAPO);

			GAL_DEBUGMODE_BASE : begin
				globale.bo_application_debug_base := (str_local_value <> '') AND (str_local_value <> '0');
				if globale.bo_application_debug_base then set_report_debug(TRUE)		// 2014-12-15
			end;
			GAL_DEBUGMODE_FULL : begin
				globale.bo_application_debug_full := (str_local_value <> '') AND (str_local_value <> '0');
				if globale.bo_application_debug_full then begin
					globale.bo_application_debug_base := TRUE;
					set_report_debug(TRUE)			// 2014-12-15
				end
			end;
			GAL_DEBUGMODE_SET_TARGET : begin
				var target_debug : GALATEO_debug_target_type;
				if (str_local_value = GAL_DEBUGMODE_TARGET_RDEBUG) then target_debug := DEBUG_TARG_CONSOLE else
				if (str_local_value = GAL_DEBUGMODE_TARGET_FILE_RDEBUG) then target_debug := DEBUG_TARG_BOTH else
				{if (str_local_value = GAL_DEBUGMODE_TARGET_FILE) then} target_debug := DEBUG_TARG_FILE;
				galateo_debug.report_debug_target := target_debug
			end;
			GAL_DEBUGMODE_RDEBUG_MODE : begin
				var RDEBUG_mode : RDEBUG_MODE_type;
				if (str_local_value = GAL_DEBUGMODE_RDEBUG_DATACOPY) then RDEBUG_mode := RDB_DATACOPY else
				if (str_local_value = GAL_DEBUGMODE_RDEBUG_PIPES) then RDEBUG_mode := RDB_PIPES else
				if (str_local_value = GAL_DEBUGMODE_RDEBUG_TCPIP) then RDEBUG_mode := RDB_TCPIP else
				{if (str_local_value = GAL_DEBUGMODE_RDEBUG_BLANK) then} RDEBUG_mode := RDB_BLANK;
				FRdebug.RDEBUG_active_mode := RDEBUG_mode;galateo_debug.report_Rdebug_mode := RDEBUG_mode
			end;

			else begin
				{$ifdef PROVA} assert(FALSE, 'GAL_set_global_option() -- errore opzione ' + i_option.ToString); {$endif}
				result := FALSE
			end
		end;
		if NOT result then abort
	except
		set_last_job_error('Errore durante l''impostazione delle opzioni globali -- opz[' + i_option.ToString + ']=' + str_local_value);
		result := FALSE
	end;
	if (i_job <> 0) then job_stack.pop_status
end;

procedure check_type(xobj : objs_type;x : obj_type_set);	overload; // verifico che l'obj sia del tipo giusto
begin
	if NOT (xobj.ca.tipo_oggetto in x) then begin
		set_last_job_error('L''opzione non è applicabile al tipo di oggetto');
		abort
	end
end;

procedure check_type(xobj : objs_type;tvs : variabile_set);	overload; // verifico che l'obj sia del tipo giusto
begin
	if NOT (xobj.tipo_variabile in tvs) then begin
		set_last_job_error('L''opzione non è applicabile al tipo di oggetto');
		abort
	end
end;

function GAL_set_obj_option(i_job : integer;str_obj_name : string;i_option : integer;lo_value : GAL_integer_parm;bo_must_exist : boolean = FALSE) : boolean;
{ imposta singole opzioni di oggetti; per oggetti di tipo BOOLEAN passare 0 per FALSE, 1 per TRUE;
  rende TRUE in caso di successo, FALSE in caso di errore (riportato dalle apposite procedure) }
const MBOX_RUNTIME_DEBUG_CAPTION = 'GAL_set_obj_option()';
var
	lab : cl_label;	//*
	str_error : string;
begin
	try
{$ifdef RD}
		runtime_debug(str_obj_name + ACAPO +
			'opz:' + i_option.ToString + ACAPO +
			'val:' + lo_value.ToString, MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
{$endif RD}
		str_error := '';
		var xobj := name2obj(str_obj_name, TRUE);
		if (xobj = NIL) then begin
		{$ifdef RD} runtime_debug(str_obj_name + ACAPO + 'obj not found',MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00); {$endif}
			if bo_must_exist then begin str_error := 'Variabile <' + str_obj_name + '> non trovata';abort end;
			result := TRUE;exit
		end;

//		tipo := xobj.tipo_oggetto;
		if (xobj.ca.tipo_oggetto = LABEL_OBJ) then lab := xobj.aslabel else lab := NIL;
		case i_option of
			GAL_OPT_OBJ_SHOW : begin
//				if (tipo in TESTI_OBJS) then lab.font.color := lab.lo_color;	// può essere gray perchè era nascosto
				if (xobj.ca.tipo_oggetto = LABEL_OBJ) then lab.Fontcolor := lab.lo_color;	// può essere gray perchè era nascosto
				xobj.set_show_state(SHOW_TYPES(lo_value))
			end;
			GAL_OPT_OBJ_SET_TIPOVARIABILE : begin
				{$ifdef PROVA} assert(lab <> NIL, 'GAL_OPT_OBJ_SET_TIPOVARIABILE oggetto non valido'); {$endif}
				if (lab <> NIL) then begin
//					lab.tipo_oggetto := xxxVARIABILE;
					case lo_value of
						GOST_TIPOVAR_VARIABILE : xobj.ca.tipo_variabile := TV_DB_FIELD;
						GOST_TIPOVAR_PARAMETRO : xobj.ca.tipo_variabile := TV_PARAMETRO;
						GOST_TIPOVAR_PARAMETRO_SQL_EARLY : xobj.ca.tipo_variabile := TV_SQL_SELECT_BEFORE_SQL;
						GOST_TIPOVAR_PARAMETRO_SQL_VERY_EARLY : xobj.ca.tipo_variabile := TV_SQL_SELECT_BEFORE_RUNTIME;
						GOST_TIPOVAR_GROUP_EXPR_SQL : xobj.ca.tipo_variabile := TV_GROUP_EXPR_SQL;
						GOST_TIPOVAR_SQL_SELECT : xobj.ca.tipo_variabile := TV_SQL_SELECT;
						{$ifdef PROVA} else assert(FALSE, 'GAL_OPT_OBJ_SET_TIPOVARIABILE parametro non valido : ' + lo_value.ToString) {$endif}
					end
				end
			end;
			GAL_OPT_OBJ_STR_DB_COLONNA : begin
//				check_type(xobj, xTESTI_OBJS);	// verifico che sia di tipo testo
				check_type(xobj, [TV_DB_FIELD]);	// verifico che sia di tipo testo
//				lab.str_SQL_expression := strpas(LPSTR(lo_value))
				xobj.str_SQL_expression := strpas(LPSTR(lo_value))
			end;
			GAL_OPT_OBJ_STR_SQL_SELECT : begin
				check_type(xobj, [TV_SQL_SELECT_BEFORE_SQL, TV_SQL_SELECT_BEFORE_RUNTIME, TV_SQL_SELECT]);	// verifico che sia di tipo corretto
//				lab.str_SQL_expression := strpas(LPSTR(lo_value))
				xobj.str_SQL_expression := strpas(LPSTR(lo_value))
			end;
{			GAL_OPT_OBJ_STR_FORMULA : begin		*** così fino al 2011-05-19
				check_type(xobj, xTESTI_OBJS);	// verifico che sia di tipo testo
				lab.tipo_oggetto := xxxFORMULA;	// c'è altro da fare ???
				lab.str_formula := strpas(LPSTR(lo_value))
			end; }
			GAL_OPT_OBJ_STR_FORMULA : begin
				xobj.tipo_variabile := TV_FORMULA;		// nel caso non sia una formula
				lab.ca.str_formula := strpas(LPSTR(lo_value))
			end;
			GAL_OPT_OBJ_GET_LENGTH_FORMULA : begin
				str_error := 'GAL_OPT_OBJ_GET_LENGTH_FORMULA: parametro di sola lettura';
				abort
			end;
			GAL_OPT_OBJ_IMAGE_FILENAME : begin		// imposta il nome del file collegato ad un'immagine
				check_type(xobj, [OBJ_BITMAP]);		// verifico che sia di tipo BMP
				var s := strpas(LPSTR(lo_value));
				{$ifdef RD} runtime_debug(str_obj_name + ACAPO + 'set image file:' + ACAPO + s, MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00); {$endif}
				if (s = '') then xobj.set_visible(FALSE)	// nessun file: nascondo !
				else if NOT xobj.asbitmap.load_file(s, TRUE) then begin str_error := 'Errore durante il caricamento di ' + s;abort end
			end;

			GAL_OPT_OBJ_XPOS_MM : xobj.set_left(cm2pixel_video_x(lo_value / 10));
			GAL_OPT_OBJ_YPOS_MM : xobj.set_top(cm2pixel_video_y(lo_value / 10));
			GAL_OPT_OBJ_WIDTH_MM : begin
				lab.autosize := FALSE;
				xobj.set_width(cm2pixel_video_x(lo_value / 10))
			end;
			GAL_OPT_OBJ_HEIGHT_MM : xobj.set_height(cm2pixel_video_y(lo_value / 10));
			GAL_OPT_OBJ_AUTOSIZE : lab.autosize := (lo_value <> 0);
			else abort
		end;
		result := TRUE
	except
		if (str_error = '') then str_error := 'Opzione non valida per l''oggetto <' + str_obj_name + '>';
//		MessageBBox(father,asciiz(str_error),MBOX_CAPTION,MB_ICONSTOP);
		set_last_job_error(str_error);
		result := FALSE
	end
end;

function GAL_get_option(i_job, i_logical_page : integer;str_section : string;lo_option : integer;var lo_value : GAL_integer_parm) : boolean;
{ legge lo stato dell'opzione specificata; rende TRUE in caso di successo, FALSE in caso di errore;
  I_LOGICAL_PAGE e I_SECTION devono avere valori validi (anche se I_LOGICAL_PAGE può valere 0, e STR_SECTION può valore BLANK) }

	function get_set_email_value(xs : email_address_type_set) : integer;
	begin
		result := 0;
		var lo : integer := 1;
		for var x : email_address_type := low(x) to high(x) do begin
			if (x in xs) then result := result + lo;
			lo := lo * 2
		end
	end;

const MBOX_RUNTIME_DEBUG_CAPTION = 'GAL_get_option()';
begin
	set_active_job(i_job);
	if (i_logical_page = 0) then i_logical_page := 1;
	job_stack.push_status;
	try
{$ifdef RD}
		runtime_debug('i_logical_page:' + i_logical_page.ToString + ACAPO +
			'sezione:' + str_section + ACAPO + 'opzione:' + lo_option.ToString, MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
{$endif RD}
		var i_section : section_index_type := MAIN_SECTION;
		if (str_section <> '') then begin
			str_section := uppercase(str_section);
			i_section := get_num_sections_page(i_logical_page);
			while (i_section > 0) AND (str_section <> uppercase(sections_1B(i_section).str_nome)) do dec(i_section);
			if (i_section = 0) then raise exception.create('Sezione <' + str_section + '> non riconosciuta')
		end;

		with sections_1B(i_section, i_logical_page) do case lo_option of
			GAL_OPT_STAMPA_ANCHE_SE_VUOTA : lo_value := integer(bo_stampa_anche_se_vuota);
			GAL_OPT_STAMPA_SENZA_DATI : lo_value := integer(bo_senza_dati);
			GAL_OPT_DONT_PRINT_SECTION : lo_value := integer(bo_dont_print_section);
			GAL_OPT_PAGE_WIDTH_MM : lo_value := round(get_Vpage_size_X_cm(i_logical_page) * 10);
			GAL_GOPT_DONT_SET_APPLICATION_PRINTER : lo_value := byte(globale.bo_usa_sempre_printer_report);
//			GAL_OPT_SECTION_HEIGHT_MM : lo_value := ;
			GAL_GOPT_SET_EMAIL_DEFAULT_ADDRESS : lo_value := get_set_email_value(globale.indirizzi_email_default);
			GAL_GOPT_SET_EMAIL_ADDRESS_LIST_TO : lo_value := get_set_email_value(globale.indirizzi_email_elenco);
//			GAL_GOPT_SET_EMAIL_ADDRESS_LIST_CC : lo_value := get_set_email_value(globale.indirizzi_email_elenco);
//			GAL_GOPT_SET_EMAIL_ADDRESS_LIST_CCN : lo_value := get_set_email_value(globale.indirizzi_email_elenco);	**
			GAL_GOPT_LOAD_DEFAULT_MAIL_WHEN_UNIQUE : lo_value := byte(globale.bo_load_indirizzo_main_when_unique);
				// messaggio all'utente in presenza di più mail passate dal programma chiamante
			else begin
				{$ifdef PROVA} assert(FALSE, 'GAL_set_option: OPZIONE non valida'); {$endif}
				raise exception.create('Parametro non valido')
			end
		end;
		result := TRUE
	except
		set_last_job_error(get_last_exception_msg);
		result := FALSE
	end;
	job_stack.pop_status
end;

function GAL_get_obj_option(i_job : integer;str_obj_name : string;lo_option : integer;var lo_value : GAL_integer_parm;bo_must_exist : boolean = FALSE) : boolean;
// rende TRUE in caso di successo, FALSE altrimenti
var lab : cl_label;	//*
begin
	try
//		result := FALSE;
{$ifdef RD}
		runtime_debug(str_obj_name + ACAPO +
			'opz:' + lo_option.ToString + ACAPO +
			'val:' + lo_value.ToString, 'get obj option', RD_DEBUG_PRINCIPALE_00);
{$endif RD}
		var xobj : objs_type := name2obj(str_obj_name, TRUE);
		if (xobj = NIL) then begin
			{$ifdef RD} runtime_debug(str_obj_name + ACAPO + 'obj not found','get obj option', RD_DEBUG_PRINCIPALE_00); {$endif}
			if bo_must_exist then raise exception.create('Variabile <' + str_obj_name + '> non trovata');
			result := TRUE;exit	// non esiste, ma va comunque OK
		end;

//		tipo := xobj.tipo_oggetto;
		if (xobj.ca.tipo_oggetto = LABEL_OBJ) then lab := xobj.aslabel else lab := NIL;
		lo_value := 0;
		case lo_option of
			GAL_OPT_OBJ_SHOW : lo_value := integer(xobj.get_show_state);
			GAL_OPT_OBJ_STR_DB_COLONNA : begin
//				check_type(xobj, xTESTI_OBJS);	// verifico che sia di tipo testo
				check_type(xobj, [TV_DB_FIELD]);	// verifico che sia del tipo giusto
//				if (length(lab.str_SQL_expression) > MAX_STR_DB_COLUMN_NAME-1) then	// verifico la max length del nome
				if (length(xobj.str_SQL_expression) > MAX_STR_DB_COLUMN_NAME-1) then	// verifico la max length del nome
					raise exception.create('nome di colonna troppo lungo');
//				strcpy(LPSTR(lo_value), asciiz(lab.str_SQL_expression))
//				strcpy(LPSTR(lo_value), asciiz(xobj.str_SQL_expression))
				strcpy(LPSTR(lo_value), LPSTR(xobj.str_SQL_expression))
			end;
			GAL_OPT_OBJ_STR_FORMULA : begin
//				check_type(xobj, [xxFORMULA]);	// verifico che sia di tipo formula
				check_type(xobj, [TV_FORMULA]);	// verifico che sia di tipo formula
//				strcpy(LPSTR(lo_value), asciiz(lab.ca.str_formula))
				strcpy(LPSTR(lo_value), LPSTR(lab.ca.str_formula))
			end;
			GAL_OPT_OBJ_GET_LENGTH_FORMULA : begin
//				check_type(xobj, [xxFORMULA]);	// verifico che sia di tipo formula
				check_type(xobj, [TV_FORMULA]);	// verifico che sia di tipo formula
				lo_value := length(lab.ca.str_formula) + 1	// +1: asciiz
			end;
			GAL_OPT_OBJ_IMAGE_FILENAME : raise exception.create('impossibile leggere il valore');
				// write only, perchè non esiste un file esterno
			GAL_OPT_OBJ_XPOS_MM: lo_value := round(video2cm_x(xobj.get_left) * 10);
			GAL_OPT_OBJ_YPOS_MM: lo_value := round(video2cm_y(xobj.get_top) * 10);
			GAL_OPT_OBJ_WIDTH_MM: lo_value := round(video2cm_x(xobj.get_width) * 10);
			GAL_OPT_OBJ_HEIGHT_MM: lo_value := round(video2cm_x(xobj.get_height) * 10);
			GAL_OPT_OBJ_AUTOSIZE : lo_value := integer(lab.Autosize);

			GAL_GET_OBJECT_TYPE : lo_value := integer(xobj.ca.tipo_oggetto);
			GAL_GET_OBJECT_VALUE_TYPE : if (xobj.ca.tipo_oggetto = LABEL_OBJ) then begin
				case xobj.ca.tipo_valore of
					VAL_NUMERO : lo_value := GOVT_NUMERO;
					VAL_TESTO : lo_value := GOVT_TESTO;
					VAL_BOOLEAN : lo_value := GOVT_BOOLEAN;
//					VAL_BOH : lo_value :=
					else lo_value := -1
				end
			end;
			else abort
		end;
		result := TRUE
	except
//		if (str_error = '') then str_error := 'Opzione non valida per l''oggetto <' + str_obj_name + '>';
//		MessageBBox(father, get_last_exception_msg, MBOX_CAPTION, MB_ICONSTOP);
		set_last_job_error(get_last_exception_msg);
		result := FALSE
	end
end;

function GAL_browse_files(father : TForm;str_default_print_path : string;var str_filename : string;bo_relative_path : boolean = TRUE) : boolean;
{ esegue il browse per files di tipo galateo;  rende TRUE in caso di successo
  se il file si trova nella directory STR_DEFAULT_PRINT_PATH o in una sua sottodirectory,
  viene indicata solo la parte di path a partire da (relativa a) STR_DEFAULT_PRINT_PATH }
begin
	try
		// 2009-02-12, altrimenti se passo un percorso senza nome file la procedure non esegue nessuna azione
		if (str_filename <> '') AND (extractFilename(str_filename) = '') then str_filename := str_filename + '*' + GALATEO_EXT;

		var dlg := TOpenDialog.create(father);
		dlg.DefaultExt := DEFAULT_EXT;
		dlg.options := [ofPathMustExist, ofFileMustExist, ofNoTestFileCreate];
		dlg.filter := FILES_FILTER;
		dlg.filename := str_filename;var str_temp := str_filename;
		if find_full_filename(str_default_print_path, str_temp, GALATEO_EXT) then dlg.InitialDir := ExtractFilePath(str_temp)
		else begin
			var i := pos(';', str_default_print_path);
			if (i = 0) then i := length(str_default_print_path) + 1;
			dlg.InitialDir := copy(str_default_print_path, 1, i-1)
		end;
		result := dlg.execute;	// non serve circondarlo con un SET_WAIT_CURSOR(), non funziona
		if result then begin
			str_filename := lowercase(dlg.filename);
			if bo_relative_path then begin
				while (str_default_print_path <> '') do begin
					var k := pos(';', str_default_print_path);if (k = 0) then k := length(str_default_print_path) + 1;
					str_temp := check_path(copy(str_default_print_path, 1, k-1));delete(str_default_print_path, 1, k);
					if (copy(str_filename, 1, length(str_temp)) = lowercase(str_temp)) then begin
						delete(str_filename, 1, length(str_temp));
						break
					end
				end;
				var j : smallint := length(str_filename) - length(DEFAULT_EXT) + 1;
				if (copy(uppercase(str_filename), j, 255) = uppercase(DEFAULT_EXT)) then delete(str_filename, j, 255)
			end
		end;
		dlg.free
	except
		result := FALSE
	end
end;

function GAL_genera_parm_protetto(str_parm : string) : string;
// il parametro non avrà problemi anche se contiene virgole o altri caratteri speciali
begin
//	result := DELIMITATORE_SPECIALE_PARMS + str_parm + DELIMITATORE_SPECIALE_PARMS
	result := str_parm
end;

function set_GALATEO_universal_callback(setup_proc : universal_callback_procedure_type;
//	chkm : {$ifdef PROVA}cl_check_memory_allocation{$else}pointer{$endif}) : boolean;
	chkm : pointer) : boolean;
{	imposta una callback function che viene richiamata in occasione di tutte le stampe;
	è del tutto analoga  alla callback function specifica per ogni stampa, ma consente di indicare valori e comportamenti comuni a tutto il programma;
	rende TRUE in caso di successo, FALSE altrimenti }
begin
//	{$ifdef PROVA} if (chkm <> NIL) then set_DLL_checkmem_object(chkm); {$endif}
	debug(0, 'set_GALATEO_universal_callback()', 'assegnato');
	universal_setup_proc := setup_proc;
	result := TRUE
end;

procedure set_callback_replace_variabili_ambiente(func : callback_replace_variabili_ambiente_procedure_type);
{ assegna la callback function usata da CASA.DLL per eseguire la sostituzione delle variabili di ambiente che possono essere inserite in determinati campi;
  (esempio: il nome della cartella/filename di exportazione, che può essere deciso in base ad impostazioni del programma chiamante) }
begin
	xxcallback_replace_variabili_ambiente := func
end;

function GAL_get_version : integer; begin result := GALATEO_VERSION end;
function GAL_get_DLL_version : integer; begin result := DLL_COMPATIBILITY_VERSION end;

function GAL_get_version_signature(bo_one_line_only : boolean) : string;
{ rende la stringa che deve essere mostrata nella about-dialog-box e che indica la versione del software;
  if BO_ONE_LINE_ONLY il messaggio occupa una sola riga, altrimenti può occuparne più d'una }
begin
	result := 'Stampe eseguite da' + ifs(bo_one_line_only, ' ', ACAPO) + get_internal_version_signature({datetime}TRUE)
end;

function GAL_get_descrizione(str_filename : string) : string;
begin
	result := GAL_get_descrizione_path(str_filename, '', NIL)
end;

function GAL_get_descrizione_path(str_filename, str_default_path : string;pt_bo_exists : GAL_boolean_punt = NIL) : string;
var f : text;
begin
	result := '';var bo_open := FALSE;
	if (pt_bo_exists <> NIL) then pt_bo_exists^ := FALSE;
	if (str_filename = '') then exit;
	try
		if NOT find_full_filename(str_default_path, str_filename, GALATEO_EXT) then exit;
		if (pt_bo_exists <> NIL) then pt_bo_exists^ := TRUE;
		assign(f, str_filename);reset(f);
		bo_open := TRUE;
		readln(f);readln(f);readln(f, result)
	except
		result := extractfilename(str_filename) + ' (non disponibile)'
	end;
	if bo_open then begin {$I-} close(f);if (IOresult = 0) then; {$I+} end
end;

function GAL_get_system_debug_filename : string;
{ rende il nome del system-debug-filename (non è il file di debug dei singoli report, ma quello di sistema);
  non viene garantita l'esistenza del file, ma solo la sua collocazione }
begin
	result := get_filename_debug_local({SQL}FALSE, {today}FALSE)
end;

procedure init_galateo(main_window_handle : hwnd;
	str_jolly_security_ID : string;		// identificatore di SICUREZZA che consente di capire se la chiamata proviene da JOLLY -- vedi funzione get_CASA_security_ID() su FPROCS
	bo_service_mode : boolean;
	wo_system_debug_mode : word;			// lasciare a zero per utilizzare i valori salvati da Galateo sul registry, oppure assegnare dei valori positivi
	system_RDEBUG_mode : RDEBUG_MODE_type;
	{str_calling_program,} str_author : string;
//	bo_PDF_allowed : boolean;
	str_parametri_connessione_DB : string = '';ptr : pointer = NIL);
{ STR_JOLLY_SECURITY_ID : identificatore di SICUREZZA che consente di capire se la chiamata proviene da JOLLY;
  formato in codesta guisa: encode_marked(JID#ID#AAAA-MM-DD HH:NN:SS)
  JID è parte fissa
  ID è un nome che può essere:
		JOLLY chiamata viene da JOLLY
		GALRUN chiamata viene da GALRUN (legge i files di configurazione della connessione database deve essere attivata l'opzione)
		QUALUNQUE ALTRA COSA non viene accettata;
  ORARIO: oltre a costituire parte dell'ID viene verificato che sia entro un ragionevole intervallo dall'ora corrente -- siamo sulla stessa macchina }
const MBOX_DEBUG_CAPTION = 'init_galateo (chiamata di inizializzazione DLL)';
begin
//	if (FRDebug.RDEBUG_active_mode in [*]) then wo_system_debugging_mode := else ;

// dal 2025-12-29, perchè chiamandolo nella initialization della PRINTERS_DX si piantava tutto se WIN64
//	init_printer;	// implicito in INIT_MISURE
	init_misure;
	init_printer_select;

	var str_calling_program := paramstr(0);
	var str_context := '-- FROM <' + str_calling_program + '>';
{$ifdef DEBUG}
{	static_immediate_debug(MBOX_DEBUG_CAPTION + ' -- BEFORE set_system_debug() ' +
		'SERVICE=' + bo_service_mode.SQL + ' mode=' + wo_system_debug_mode.ToString + '  RDEBUG=' + RDEBUG_DESCRIZIONE[system_RDEBUG_mode]); {}
{$endif DEBUG}
	set_service_mode(bo_service_mode);

	if (wo_system_debug_mode <> 0) then set_system_debug(TRUE, wo_system_debug_mode, system_RDEBUG_mode);
	if bo_service_mode then set_report_debug_target('service-mode', wo_system_debug_mode, system_RDEBUG_mode);
//	static_immediate_debug(MBOX_DEBUG_CAPTION + ' -- AFTER set_system_debug() mode=' + wo_system_debug_mode.ToString + '  RDEBUG=' + RDEBUG_DESCRIZIONE[system_RDEBUG_mode]);
	writeln_system_debug('start' + str_context, MBOX_DEBUG_CAPTION);
//	static_immediate_debug(MBOX_DEBUG_CAPTION + ' -- AFTER start');
	application.Handle := main_window_handle;		// 2007-09-23
	{$ifdef PROVA} if bo_initialized then MessageBBox(0, 'INIT_GALATEO() già chiamato', MBOX_CAPTION, MB_ICONSTOP); {$endif}
	bo_initialized := TRUE;

//	if NOT valid_CASA_security_ID(str_JOLLY_security_ID) then ????????????;
	box_allow_free_database_configuration_files := bool2x(JOLLY_CASA_security_ID(str_JOLLY_security_ID));

//	dich.bo_private_SMTP_manager := bo_private_SMTP_manager;
	// copio le stringhe in modo da creare unique references, per evitare problemi tra EXE e DLL
	SetString(Gdich.str_calling_program, LPSTR(str_calling_program), length(str_calling_program));
	SetString(Gdich.str_author, LPSTR(str_author), length(str_author));

//	str_DLL_calling_program := PROGRAM_NAME + ifs(str_calling_program, ' [' + str_calling_program + ']');
	var s := PROGRAM_NAME + ifs(str_calling_program, ' from [' + str_calling_program + ']');
	SetString(str_DLL_calling_program, LPSTR(s), length(s));

//	SetString(dich.str_default_databasename, LPSTR(str_default_databasename), length(str_default_databasename));
	SetString(xstr_default_connection_parms, LPSTR(str_parametri_connessione_DB), length(str_parametri_connessione_DB));
//	writeln_system_debug('str_parametri_connessione_DB=' + xstr_default_connection_parms, MBOX_DEBUG_CAPTION);
	Gdich.bo_PDF_allowed := bo_PDF_allowed;
	Gdich.ptr := ptr;		// attualmente non serve a nulla, è solo una finestra sul futuro

//	if bo_service_mode AND bo_stampante_selezionata_invalida then ***;		*** bisognerebbe mandare una mail, ma i dati di spedizione sono sul programma chiamante

	writeln_system_debug('end' + str_context, MBOX_DEBUG_CAPTION)
//	;static_immediate_debug(MBOX_DEBUG_CAPTION + ' -- end of INIT_GALATEO')
end;

{$S-}
procedure exit_DLL; far;
begin end;

procedure init_DLL;
begin
	IsMultiThread := TRUE;  // forza il locking del MM condiviso (JOLLY e' multi-thread: font-loader DevExpress)
//	addexitproc(exit_DLL);
	// imposto il nome per l'EVENTLOG; per le chiamate eseguite sulla DLL vale l'impostazione eseguita qui sulla DLL
//	{$ifdef DEBUG} messagebbox(0, 'AAAAAAAA', '000000000'); {$endif}
	set_eventlog_program_name(CASA_EVENTLOG_PROGRAM_NAME);
//	{$ifdef DEBUG} messagebbox(0, 'AAAAAAAA', '1111111111'); {$endif}
	// registro il programma per la decodifica dei codici per l'eventlog
	registra_eventlog_messages_decoder({install}TRUE, CASA_EVENTLOG_PROGRAM_NAME, {forza}FALSE, get_DLL_filename);
//	{$ifdef DEBUG} messagebbox(0, 'AAAAAAAA', '2222222222'); {$endif}

	if (computer_registry_data.i_DLL_system_debug_level <> DLL_SYSTEM_DEBUG_DISATTIVO)
		then set_system_debug(TRUE, computer_registry_data.get_system_debug_mode, computer_registry_data.RDEBUG_mode);
	bo_PDF_allowed := TRUE;
	GALATEO_init_WPDF_DLL;	// inizializza la DLL WPDF

	{$ifdef DEBUG} for var i : byte := 1 to MAX_JOBS do assert(str_filename[i] = '', 'KWJD 2983 -- filename[' + i.ToString + '] NOT BLANK') {$endif}
end;

function GALATEO_check_valid_printer : boolean;
// verifica che la stampante predefinita (o una stampante, se non è definita la predefinita) esista e sia valida; rende TRUE in caso di successo, FALSE altrimenti
begin
	{$ifdef DEBUG} static_immediate_debug('GALATEO_check_valid_printer :: bo_invalid_selected_printer=' + ifs(bo_invalid_selected_printer, 'T', 'F')); {$endif DEBUG}
	result := NOT bo_nessuna_stampante_installata AND NOT bo_invalid_selected_printer
end;

begin
	init_DLL
end.
