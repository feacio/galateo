unit print_link;

{ HEADERS per il collegamento con la DLL che si occupa della stampa;
  unit da richiamare nel programma utilizzatore della DLL di GALATEO }

{*$define DEBUG_DLL}		// se definito, la DLL viene creata VUOTA e le funzioni generate senza alcun body, per evitare interferenze

{$ifdef GALATEO}
	{$define PRESET_GALATEO}
{$else}
	{$define GALATEO}		// necessario per la DEFINES di GALATEO
{$endif}
{$I e:\DX13\galateo\defines}
{$ifndef PRESET_GALATEO} {$undef GALATEO} {$endif}		// probabilmente inutile, ma è una forma di coerenza in piu'

{$if defined(JOLLY) OR defined(JOLLY_SERVICES)} {$ifndef SCUOLA} {$ifndef SISDOC} {$ifndef GALATEO}
	{$define JOLLYEXT} {$endif}		// speciali extensions per JOLLY (interazioni tra REPORTS e OPERATORE)
{$endif} {$endif} {$endif}

interface

uses Windows, DB, Classes, Forms, SysUtils,
	Fcommons, Fdebug, FRdebug
	{$ifdef JOLLYEXT} ,Jdich {$endif};

{$I \DX13\galateo\printtyp.h}	// tipi usati per il collegamento alla DLL
{*$I \DX13\galateo\printopt.h}	// elenco delle opzioni disponibili
{$I printopt.h}	// elenco delle opzioni disponibili

function		check_GALATEO_version(lo_versione_required : integer;mbox_caption : string;bo_halt_if_wrong : boolean;pt_str_error_message : string_punt = NIL) : boolean;

procedure	init_galateo(main_window_handle : hwnd;
					str_jolly_security_ID : string;	// identificatore di SICUREZZA che consente di capire se la chiamata proviene da JOLLY -- vedi funzione get_CASA_security_ID() su FPROCS
					bo_service_mode : boolean;
					wo_forza_debug_mode : word;		// lasciare a zero per utilizzare i valori salvati da Galateo sul registry, oppure assegnare dei valori positivi
					system_RDEBUG_mode : RDEBUG_MODE_type;	// modalità di scrittura delle info di system-debug
					{str_calling_program,} str_author : string;
//					bo_PDF_allowed : boolean;		*** eliminato 2024-03-21
					str_parametri_connessione_DB : string = '';ptr : pointer = NIL);

function		GALATEO_check_valid_printer : boolean;

function		set_GALATEO_universal_callback(setup_proc : universal_callback_procedure_type;
//					chkm : {$ifdef DEBUG}cl_check_memory_allocation{$else}pointer{$endif}) : boolean;		*** definitivamente eliminato 2015-10-11
					chkm : pointer) : boolean;

procedure	set_callback_replace_variabili_ambiente(func : callback_replace_variabili_ambiente_procedure_type);

function		GAL_browse_files(father : TForm;str_default_print_path : string;var str_filename : string;bo_relative_path : boolean = TRUE) : boolean;
function		GAL_browse_files_TField(father : TForm;str_default_print_path : string;ff : TField) : boolean;
function		GAL_edit_report(father : TForm;str_default_print_path,str_report : string;str_calling_application_name : string = '') : boolean;
//function		GAL_find_full_filename(str_default_path : string;var str_filename : string) : boolean;

//function		GAL_open(father : TForm;str_db_alias : string;str_caption,str_default_path : string;str_filename : string) : integer;

function		GAL_get_print_style_anteprima(bo_anteprima : boolean) : integer;	// rende lo style per l'anteprima (SI/NO)

function		GAL_get_system_debug_filename : string;		// rende il nome del system-debug-filename (non è il file di debug dei singoli report, ma quello di sistema)

procedure	GAL_close(i_job : integer);
function		GAL_print(i_job : integer;lo_print_style : integer) : boolean;
function		GAL_open_and_print_method(father : TForm;{str_db_alias : string;}str_caption, str_default_path : string;
					report_info : report_info_type;setup_method : print_setup_method_type;
					lo_print_style : integer;		// valori GAL_POPT_xxxxxxxxxxxxxx
					str_parametri_connessione_DB : string;
					pt_str_last_exported_filename : string_punt = NIL;
					i_numero_stampe : integer = 1;
					str_runtime_load_filenames : string = '') : boolean;
function		GAL_open_and_print_proc(father : TForm;{str_db_alias : string;}str_caption, str_default_path : string;
					report_info : report_info_type;setup_proc : print_setup_procedure_type;
					lo_print_style : integer;		// valori GAL_POPT_xxxxxxxxxxxxxx
					str_parametri_connessione_DB : string;
					pt_str_last_exported_filename : string_punt = NIL;
					i_numero_stampe : integer = 1;
					str_runtime_load_filenames : string = '') : boolean;
// i_numero_stampe è il numero di distinte stampe che si vogliono eseguire; non è il numero di copie
// per ciascuna stampa sarà richiamata la SETUP_PROC, che dovrà dare indicazioni sulla stampa da eseguire

function		GAL_genera_parm_protetto(str_parm : string) : string;	// il parametro non avrà problemi anche se contiene virgole o altri caratteri speciali

function		GAL_get_last_error(i_job : integer) : string;

function		GAL_set_textvar_value(i_job : integer;str_name,str_value : string;bo_must_exist : boolean = FALSE) : boolean;
function		GAL_set_string_value(i_job : integer;str_name,str_value : string;bo_must_exist : boolean = FALSE) : boolean;
//function		GAL_set_asciizvar_value(i_job : integer;str_name : string;lp_value : pchar;bo_must_exist : boolean = FALSE) : boolean;
function		GAL_set_textvar_listvalue(i_job : integer;str_name : string;
					tstr_list : TStrings;str_if_void : string;bo_must_exist : boolean = FALSE) : boolean;
function		GAL_set_integer_value(i_job : integer;str_name : string;lo_value : integer;bo_must_exist : boolean = FALSE) : boolean;
function		GAL_set_double_value(i_job : integer;str_name : string;do_value : double;bo_must_exist : boolean = FALSE) : boolean;
function		GAL_set_date_SQL(i_job : integer;str_name : string;dt : TDatetime;bo_must_exist : boolean = FALSE) : boolean;
function		GAL_set_date_DMY(i_job : integer;str_name : string;dt : TDatetime;bo_must_exist : boolean = FALSE) : boolean;

function		GAL_set_global_option(i_job : word;i_option : word;str_value : string) : boolean;
//function	GAL_set_global_option(i_option : word;str_value : string) : boolean;
//function	GAL_set_option(i_job, i_page : integer;str_section : string;i_option,i_value : integer) : boolean;	*** così fino 2024-03-30
function		GAL_set_option(i_job, i_page : integer;str_section : string;i_option : integer;lo_value : GAL_integer_parm) : boolean;
//function	GAL_set_obj_option(i_job : integer;str_obj_name : string;i_option : integer;lo_value : integer;bo_must_exist : boolean = FALSE) : boolean;	*** così fino 2024-03-30
function		GAL_set_obj_option(i_job : integer;str_obj_name : string;i_option : integer;lo_value : GAL_integer_parm;bo_must_exist : boolean = FALSE) : boolean;

function		GAL_get_integer_option(i_job, i_page : integer;str_section : string;lo_option : integer;var lo_value : integer) : boolean;
function		GAL_get_option(i_job, i_page : integer;str_section : string;lo_option : integer;var lo_value : GAL_integer_parm) : boolean;
function		GAL_get_obj_integer_option(i_job : integer;str_obj_name : string;lo_option : integer;var lo_value : integer;bo_must_exist : boolean = FALSE) : boolean;
function		GAL_get_obj_option(i_job : integer;str_obj_name : string;lo_option : integer;var lo_value : GAL_integer_parm;bo_must_exist : boolean = FALSE) : boolean;

function		GAL_exists_section(i_job : integer;str_section : string;var i_pagina_logica : integer) : boolean;
function		GAL_exists_obj(i_job : integer;str_name : string) : boolean;
function		GAL_exists_parm(i_job : integer;str_name : string) : boolean;

function		GAL_get_version : integer;
function		GAL_get_DLL_version : integer;
function		GAL_get_version_signature(bo_one_line_only : boolean) : string;

function		GAL_get_descrizione(str_filename : string) : string;
function		GAL_get_descrizione_path(str_filename : string;str_default_path : string;pt_bo_exists : GAL_boolean_punt = NIL) : string;

var ireport : report_info_type;		// InfoREPORT: buffer di uso comune per tutte le procedures

procedure	reset_ireport(var x : report_info_type);
function		set_ireport(var x : report_info_type;str_report_filename : string;str_descrizione : string = '';lo_key_report : integer = 0) : report_info_type; overload;
function		set_ireport(str_report_filename : string;str_descrizione : string = '';lo_key_report : integer = 0) : report_info_type; overload;

// su GALRUN non funziona: verifica perchè e gestisci il caso !!!!
{$ifdef JOLLYEXT} function set_ireport(reps : cl_report_group;i_index_ZB : smallint) : report_info_type; overload; {$endif}

function domanda_livello_dettaglio_stampa(father : TForm;str_caption : string;var i_tipo_stampa : integer) : boolean;

implementation

uses FMessage, FSystem_base, FSystem, FSystem_ext, FFile, FProcs, FXstrings, Fstrings, domanda_multipla;
//	xSQLproc,		***** NOOOOO, altrimenti ci sono problemi

const
	MBOX_CAPTION = 'Galateo';

	{	FILOSOFIA DELLA GESTIONE DLL
		la versione RUNTIME utilizza la versione delle DLL che è stata copiata su su PATH pubblico
		E:\DX13\GALATEO\RUNTIMEs\$(OutputName)-32$(OutputExt) (e corrispondente versione -64)
		NON può usare CASA.DLL singola per non confondersi con la CASA.DLL della versione DELPHI-6 (ugualmente su path pubblico)

		la versione DEBUG deve utilizzare la versione debuggabile di CASA.DLL (nome identico a 32 e 64 bit)
		che si trova nelle directories di output del compilatore (altrimenti non si può debuggare) }

	GALATEO_DLL_BASENAME = 'CASA';
	GALATEO_DLL_FNAME =
{$ifdef DEBUG}
		{***********$define XPATH}
{$ifdef XPATH}
		'E:\DX13\GALATEO\' +
		{$ifdef WIN32} 'WIN32' {$endif}
		{$ifdef WIN64} 'WIN64' {$endif} +
//		'\Debug\' +
{$endif XPATH}
{$endif DEBUG}
		GALATEO_DLL_BASENAME + '.dll';

{$ifdef DEBUG_DLL}

procedure	init_galateo(main_window_handle : hwnd;
					str_jolly_security_ID : string;	// identificatore di SICUREZZA che consente di capire se la chiamata proviene da JOLLY -- vedi funzione get_CASA_security_ID() su FPROCS
					bo_service_mode : boolean;
					wo_forza_debug_mode : word;		// lasciare a zero per utilizzare i valori salvati da Galateo sul registry, oppure assegnare dei valori positivi
					system_RDEBUG_mode : RDEBUG_MODE_type;	// modalità di scrittura delle info di system-debug
					{str_calling_program,} str_author : string;
//					bo_PDF_allowed : boolean;		*** eliminato 2024-03-21
					str_parametri_connessione_DB : string = '';ptr : pointer = NIL);  begin end;

function		GALATEO_check_valid_printer : boolean; begin result := TRUE end;

function		set_GALATEO_universal_callback(setup_proc : universal_callback_procedure_type;chkm : pointer) : boolean; begin result := TRUE end;

procedure	set_callback_replace_variabili_ambiente(func : callback_replace_variabili_ambiente_procedure_type); begin end;

function		GAL_browse_files(father : TForm;str_default_print_path : string;var str_filename : string;bo_relative_path : boolean = TRUE) : boolean; begin result := TRUE end;

function		GAL_get_system_debug_filename : string;	 begin result := '' end;	// rende il nome del system-debug-filename (non è il file di debug dei singoli report, ma quello di sistema)

procedure	GAL_close(i_job : integer); begin end;
function		GAL_print(i_job : integer;lo_print_style : integer) : boolean;  begin result := TRUE end;
function		GAL_open_and_print_method(father : TForm;{str_db_alias : string;}str_caption, str_default_path : string;
					report_info : report_info_type;setup_method : print_setup_method_type;lo_print_style : integer;
					str_parametri_connessione_DB : string;pt_str_last_exported_filename : string_punt = NIL;i_numero_stampe : integer = 1;
					str_runtime_load_filenames : string = '') : boolean;  begin result := TRUE end;
function		GAL_open_and_print_proc(father : TForm;{str_db_alias : string;}str_caption, str_default_path : string;report_info : report_info_type;
					setup_proc : print_setup_procedure_type;lo_print_style : integer;str_parametri_connessione_DB : string;
					pt_str_last_exported_filename : string_punt = NIL;i_numero_stampe : integer = 1;str_runtime_load_filenames : string = '') : boolean;  begin result := TRUE end;
function		GAL_genera_parm_protetto(str_parm : string) : string;	 begin result := '' end;// il parametro non avrà problemi anche se contiene virgole o altri caratteri speciali
function		GAL_get_last_error(i_job : integer) : string;  begin result := '' end;
function		GAL_set_textvar_value(i_job : integer;str_name,str_value : string;bo_must_exist : boolean = FALSE) : boolean; begin result := TRUE end;
function		GAL_set_string_value(i_job : integer;str_name,str_value : string;bo_must_exist : boolean = FALSE) : boolean; begin result := TRUE end;
function		GAL_set_textvar_listvalue(i_job : integer;str_name : string;
					tstr_list : TStrings;str_if_void : string;bo_must_exist : boolean = FALSE) : boolean;  begin result := TRUE end;
function		GAL_set_integer_value(i_job : integer;str_name : string;lo_value : integer;bo_must_exist : boolean = FALSE) : boolean; begin result := TRUE end;
function		GAL_set_double_value(i_job : integer;str_name : string;do_value : double;bo_must_exist : boolean = FALSE) : boolean; begin result := TRUE end;
function		GAL_set_date_SQL(i_job : integer;str_name : string;dt : TDatetime;bo_must_exist : boolean = FALSE) : boolean; begin result := TRUE end;
function		GAL_set_date_DMY(i_job : integer;str_name : string;dt : TDatetime;bo_must_exist : boolean = FALSE) : boolean; begin result := TRUE end;

function		GAL_set_global_option(i_job : word;i_option : word;str_value : string) : boolean; begin result := TRUE end;
function		GAL_set_option(i_job, i_page : integer;str_section : string;i_option : integer;lo_value : GAL_integer_parm) : boolean; begin result := TRUE end;
function		GAL_set_obj_option(i_job : integer;str_obj_name : string;i_option : integer;lo_value : GAL_integer_parm;bo_must_exist : boolean = FALSE) : boolean; begin result := TRUE end;

function		GAL_get_option(i_job, i_page : integer;str_section : string;lo_option : integer;var lo_value : GAL_integer_parm) : boolean; begin result := TRUE end;
function		GAL_get_obj_option(i_job : integer;str_obj_name : string;lo_option : integer;var lo_value : GAL_integer_parm;bo_must_exist : boolean = FALSE) : boolean; begin result := TRUE end;

function		GAL_exists_section(i_job : integer;str_section : string;var i_pagina_logica : integer) : boolean; begin result := TRUE end;
function		GAL_exists_obj(i_job : integer;str_name : string) : boolean; begin result := TRUE end;
function		GAL_exists_parm(i_job : integer;str_name : string) : boolean; begin result := TRUE end;

{$I e:\DX13\galateo\galateo_versione}
function		GAL_get_version : integer; begin result := GALATEO_VERSION end;
function		GAL_get_DLL_version : integer; begin result := DLL_COMPATIBILITY_VERSION end;
function		GAL_get_version_signature(bo_one_line_only : boolean) : string; begin result := '' end;

function		GAL_get_descrizione(str_filename : string) : string;  begin result := '' end;
function		GAL_get_descrizione_path(str_filename : string;str_default_path : string;pt_bo_exists : GAL_boolean_punt = NIL) : string;  begin result := '' end;

{$else NOT DEBUG_DLL}

(*procedure	init_galateo(main_window_handle : hwnd;str_jolly_security_ID : string;bo_service_mode : boolean;wo_forza_debug_mode : word;system_RDEBUG_mode : RDEBUG_MODE_type;str_author : string;str_parametri_connessione_DB : string = '';ptr : pointer = NIL);  begin end;
function		GALATEO_check_valid_printer : boolean; begin result := TRUE end;
function		set_GALATEO_universal_callback(setup_proc : universal_callback_procedure_type;chkm : pointer) : boolean; begin result := TRUE end;
procedure	set_callback_replace_variabili_ambiente(func : callback_replace_variabili_ambiente_procedure_type); begin end;

function		GAL_browse_files(father : TForm;str_default_print_path : string;var str_filename : string;bo_relative_path : boolean = TRUE) : boolean; begin result := TRUE end;

function		GAL_get_system_debug_filename : string;	 begin result := '' end;	// rende il nome del system-debug-filename (non è il file di debug dei singoli report, ma quello di sistema)

procedure	GAL_close(i_job : integer); begin end;
function		GAL_print(i_job : integer;lo_print_style : integer) : boolean;  begin result := TRUE end;
function		GAL_open_and_print_method(father : TForm;{str_db_alias : string;}str_caption, str_default_path : string;
					report_info : report_info_type;setup_method : print_setup_method_type;lo_print_style : integer;
					str_parametri_connessione_DB : string;pt_str_last_exported_filename : string_punt = NIL;i_numero_stampe : integer = 1;
					str_runtime_load_filenames : string = '') : boolean;  begin result := TRUE end;
function		GAL_open_and_print_proc(father : TForm;{str_db_alias : string;}str_caption, str_default_path : string;report_info : report_info_type;
					setup_proc : print_setup_procedure_type;lo_print_style : integer;str_parametri_connessione_DB : string;
					pt_str_last_exported_filename : string_punt = NIL;i_numero_stampe : integer = 1;str_runtime_load_filenames : string = '') : boolean;  begin result := TRUE end;
function		GAL_genera_parm_protetto(str_parm : string) : string;	 begin result := '' end;// il parametro non avrà problemi anche se contiene virgole o altri caratteri speciali
function		GAL_get_last_error(i_job : integer) : string;  begin result := '' end;
function		GAL_set_textvar_value(i_job : integer;str_name,str_value : string;bo_must_exist : boolean = FALSE) : boolean; begin result := TRUE end;
function		GAL_set_string_value(i_job : integer;str_name,str_value : string;bo_must_exist : boolean = FALSE) : boolean; begin result := TRUE end;
function		GAL_set_textvar_listvalue(i_job : integer;str_name : string;
					tstr_list : TStrings;str_if_void : string;bo_must_exist : boolean = FALSE) : boolean;  begin result := TRUE end;
function		GAL_set_integer_value(i_job : integer;str_name : string;lo_value : integer;bo_must_exist : boolean = FALSE) : boolean; begin result := TRUE end;
function		GAL_set_double_value(i_job : integer;str_name : string;do_value : double;bo_must_exist : boolean = FALSE) : boolean; begin result := TRUE end;
function		GAL_set_date_SQL(i_job : integer;str_name : string;dt : TDatetime;bo_must_exist : boolean = FALSE) : boolean; begin result := TRUE end;
function		GAL_set_date_DMY(i_job : integer;str_name : string;dt : TDatetime;bo_must_exist : boolean = FALSE) : boolean; begin result := TRUE end;

function		GAL_set_global_option(i_job : word;i_option : word;str_value : string) : boolean; begin result := TRUE end;
function		GAL_set_option(i_job, i_page : integer;str_section : string;i_option : integer;lo_value : GAL_integer_parm) : boolean; begin result := TRUE end;
function		GAL_set_obj_option(i_job : integer;str_obj_name : string;i_option : integer;lo_value : GAL_integer_parm;bo_must_exist : boolean = FALSE) : boolean; begin result := TRUE end;

function		GAL_get_option(i_job, i_page : integer;str_section : string;lo_option : integer;var lo_value : GAL_integer_parm) : boolean; begin result := TRUE end;
function		GAL_get_obj_option(i_job : integer;str_obj_name : string;lo_option : integer;var lo_value : GAL_integer_parm;bo_must_exist : boolean = FALSE) : boolean; begin result := TRUE end;

function		GAL_exists_section(i_job : integer;str_section : string;var i_pagina_logica : integer) : boolean; begin result := TRUE end;
function		GAL_exists_obj(i_job : integer;str_name : string) : boolean; begin result := TRUE end;
function		GAL_exists_parm(i_job : integer;str_name : string) : boolean; begin result := TRUE end;

{$I e:\DX13\galateo\galateo_versione}
function		GAL_get_version : integer; begin result := GALATEO_VERSION end;
function		GAL_get_DLL_version : integer; begin result := DLL_COMPATIBILITY_VERSION end;
function		GAL_get_version_signature(bo_one_line_only : boolean) : string; begin result := '' end;

function		GAL_get_descrizione(str_filename : string) : string;  begin result := '' end;
function		GAL_get_descrizione_path(str_filename : string;str_default_path : string;pt_bo_exists : GAL_boolean_punt = NIL) : string;  begin result := '' end;
*)

////////////////////////////////////////

function		set_GALATEO_universal_callback;				external GALATEO_DLL_FNAME;
function		GALATEO_check_valid_printer;		external GALATEO_DLL_FNAME;	//ok
procedure	init_galateo;										external GALATEO_DLL_FNAME;
procedure	set_callback_replace_variabili_ambiente;	external GALATEO_DLL_FNAME;	// NOOOOOOO

function		GAL_browse_files;									external GALATEO_DLL_FNAME;

//function		GAL_open;										external GALATEO_DLL_FNAME;
procedure	GAL_close;											external GALATEO_DLL_FNAME;
function		GAL_print;											external GALATEO_DLL_FNAME;
function		GAL_open_and_print_method;						external GALATEO_DLL_FNAME;
function		GAL_open_and_print_proc;						external GALATEO_DLL_FNAME;
function		GAL_get_last_error;								external GALATEO_DLL_FNAME;
function		GAL_get_obj_option;								external GALATEO_DLL_FNAME;
function		GAL_get_option;									external GALATEO_DLL_FNAME;
//function		GAL_set_asciizvar_value;					external GALATEO_DLL_FNAME;
function		GAL_set_integer_value;							external GALATEO_DLL_FNAME;
function		GAL_set_double_value;							external GALATEO_DLL_FNAME;
function		GAL_set_date_SQL;									external GALATEO_DLL_FNAME;		// 2008-10-11, versione $0256
function		GAL_set_date_DMY;									external GALATEO_DLL_FNAME;		// 2008-10-11, versione $0256
function		GAL_set_textvar_value;							external GALATEO_DLL_FNAME;
function		GAL_set_string_value;							external GALATEO_DLL_FNAME;
function		GAL_set_textvar_listvalue;						external GALATEO_DLL_FNAME;
function		GAL_set_global_option;							external GALATEO_DLL_FNAME;		// 2012-06-28, versione $0308
function		GAL_set_option;									external GALATEO_DLL_FNAME;
function		GAL_set_obj_option;								external GALATEO_DLL_FNAME;
function		GAL_exists_obj;									external GALATEO_DLL_FNAME;
function		GAL_exists_section;								external GALATEO_DLL_FNAME;
function		GAL_exists_parm;									external GALATEO_DLL_FNAME;
function		GAL_genera_parm_protetto;						external GALATEO_DLL_FNAME;
//function		GAL_find_full_filename;						external GALATEO_DLL_FNAME;
function		GAL_get_version;									external GALATEO_DLL_FNAME;
function		GAL_get_DLL_version;								external GALATEO_DLL_FNAME;
function		GAL_get_version_signature;						external GALATEO_DLL_FNAME;
function		GAL_get_system_debug_filename : string;	external GALATEO_DLL_FNAME;

function		GAL_get_descrizione;								external GALATEO_DLL_FNAME;
function		GAL_get_descrizione_path;						external GALATEO_DLL_FNAME; {}

{$endif DEBUG_DLL}

function verify_editing_dataset(ds : {TDbDataset}TDataset;bo_forza : boolean = TRUE) : boolean;
{ verifica che la query sia in stato di editing; se non lo è, la pone in stato di editing;
  rende TRUE se la query all'uscita della funzione si trova in stato di editing, FALSE altrimenti }
begin
	if (ds.State = dsCalcFields) then begin result := FALSE;exit end;
	if bo_forza AND NOT (ds.State in [dsEdit, dsInsert]) then ds.edit;
	result := (ds.State in [dsEdit, dsInsert])
end;

function GAL_browse_files_TField(father : TForm;str_default_print_path : string;ff : TField) : boolean;
{ MACRO per accedere facilmente a GAL_browse_files;
  meglio tenerla qui, invece che sbatterla in DLL, a causa dell'intervento sull'oggetto legato al database;
  FF deve essere collegato ad un dataset modificabile }
begin
	var s := ff.AsString;
	result := GAL_browse_files(father, str_default_print_path, s);
	if NOT result then exit;
	try
		verify_editing_dataset(ff.dataset, TRUE);	// 2009-02-12
		ff.AsString := s
	except
		MessageBBox(0{father.handle}, 'Errore durante l''assegnazione', MBOX_CAPTION, MB_ICONSTOP)
	end
end;

function GAL_edit_report(father : TForm;str_default_print_path, str_report : string;str_calling_application_name : string = '') : boolean;
// lancia galateo; se STR_REPORT <> '' lo apre; rende TRUE se GALATEO viene lanciato con successo
//const GALATEO_PROGRAM = {$ifdef DEBUG} '\DX13\GALATEO\' + {$endif} 'GALATEO.EXE';
const GALATEO_PROGRAM = 'GALATEO.EXE';

	function try_exec(str_program_dir : string) : boolean;
	var
		si : TStartupInfo;	//**
		tp : TPROCESSINFORMATION;
		str_path, str_parm : string;
	begin
		fillchar(si, sizeof(si), 0);
		if (str_report = '') then str_path := str_default_print_path
		else begin
			str_path := extractFilePath(str_report);
			str_parm := ' ' + str_report
		end;
		if (str_path = '') then str_path := GetCurrentDir;
//		result := CreateProcess(NIL, asciiz(str_program_dir + GALATEO_PROGRAM + str_parm), NIL, NIL, FALSE, 0, NIL, asciiz(str_path), si, tp)
		str_parm := str_program_dir + GALATEO_PROGRAM + str_parm;
		result := CreateProcess(NIL, @str_parm, NIL, NIL, FALSE, 0, NIL, @str_path, si, tp)
	end;

begin
	result := FALSE;
	var handle : hwnd := get_handle(father);

	// se non ho i diritti necessari, non ci provo neanche; i diritti NON servono quando si "esegue" un file dati (esempio: .GAL)
	if (str_report = '') AND NOT check_running_administrative_rights(handle, str_calling_application_name) then exit;

	if (str_report <> '') AND NOT find_full_filename(str_default_print_path, str_report, GALATEO_EXT) then begin
		MessageBBox(handle, 'Report non trovato' + ACAPO2 + str_report, MBOX_CAPTION, MB_ICONSTOP);
		exit
	end;

	result := try_exec(ExtractFilePath(paramstr(0))) OR try_exec('') {$ifdef DEBUG} {OR try_exec('E:\DX13\bin\Win32')} {$endif DEBUG};
	if NOT result then MessageBBox(handle, 'Impossibile eseguire GALATEO.' + ACAPO2 + 'Errore ' + GetLastError.ToString, MBOX_CAPTION, MB_ICONSTOP)
end;

function GAL_get_print_style_anteprima(bo_anteprima : boolean) : integer;
begin
	if bo_anteprima then result := GAL_POPT_PRINT_ANTEPRIMA
	else result := GAL_POPT_PRINT_PRINTER
end;

function check_GALATEO_version(lo_versione_required : integer;mbox_caption : string;bo_halt_if_wrong : boolean;pt_str_error_message : string_punt = NIL) : boolean;
// verifica che la versione di GALATEO installata sia quella giusta; rende TRUE se tutto OK
begin
	var lo_versione_attuale : integer := GAL_get_version;
	result := (lo_versione_attuale = lo_versione_required);
	if NOT result then begin
		var str_error_message := 'E'' richiesta la versione ' + version_of(lo_versione_required) + ' di GALATEO, ma è presente la ' + version_of(lo_versione_attuale);
		if (pt_str_error_message = NIL) then MessageBBox(0, str_error_message, MBOX_CAPTION, MB_ICONSTOP) else pt_str_error_message^ := str_error_message;
		if bo_halt_if_wrong then halt
	end
end;

// -------------------------------------------------------------------------------------------------------------------------------------------------------------

procedure reset_ireport(var x : report_info_type);
begin
	x.str_filename := '';
	x.str_description := '';
	x.lo_key_report := 0
end;

function set_ireport(var x : report_info_type;str_report_filename : string;str_descrizione : string = '';lo_key_report : integer = 0) : report_info_type;
begin
	x.str_filename := str_report_filename;
	x.str_description := str_descrizione;
	x.lo_key_report := lo_key_report;
	result := x
end;

{$ifdef JOLLYEXT}
	function set_ireport(reps : cl_report_group;i_index_ZB : smallint) : report_info_type;
	begin
		result := set_ireport(reps.get_report(i_index_ZB), reps.get_descrizione(i_index_ZB, {get_descrizione}TRUE, {create_descrizione_if_not_exists}TRUE),
			reps.lo_key_reports[i_index_ZB])
	end;
{$endif JOLLYEXT}

function set_ireport(str_report_filename : string;str_descrizione : string = '';lo_key_report : integer = 0) : report_info_type;
begin
	result := set_ireport(ireport, str_report_filename, str_descrizione, lo_key_report)
end;

function domanda_livello_dettaglio_stampa(father : TForm;str_caption : string;var i_tipo_stampa : integer) : boolean;
var i_default : byte;	//*
begin
	case i_tipo_stampa of
		GALATEO_PARM_LIVELLO_DETTAGLIO_SINTETIC : i_default := 2;
		GALATEO_PARM_LIVELLO_DETTAGLIO_FULL : i_default := 3
		else i_default := 1
	end;

	case domanda_multipla_04_proc(father, MBOX_CAPTION, 'Livello di dettaglio della stampa?', i_default,
		'Livello standard', 'Stampa SINTETICA', 'Stampa COMPLETA')
	of
		1 : i_tipo_stampa := GALATEO_PARM_LIVELLO_DETTAGLIO_NORMAL;
		2 : i_tipo_stampa := GALATEO_PARM_LIVELLO_DETTAGLIO_SINTETIC;
		3 : i_tipo_stampa := GALATEO_PARM_LIVELLO_DETTAGLIO_FULL
		else begin result := FALSE;exit end
	end;
	result := TRUE
end;

function GAL_get_integer_option(i_job, i_page : integer;str_section : string;lo_option : integer;var lo_value : integer) : boolean;
var lo_parm : GAL_integer_parm;	//*
begin
	result := GAL_get_option(i_job, i_page, str_section, lo_option, lo_parm);
	lo_value := lo_parm
end;

function GAL_get_obj_integer_option(i_job : integer;str_obj_name : string;lo_option : integer;var lo_value : integer;bo_must_exist : boolean = FALSE) : boolean;
var lo_parm : GAL_integer_parm;	//*
begin
	result := GAL_get_obj_option(i_job, str_obj_name, lo_option, lo_parm);
	lo_value := lo_parm
end;

initialization
	initialization_debug('print_link')
finalization
	finalization_debug('print_link')
end.



function GAL_browse_files(father : TForm;str_default_print_path : string;var str_filename : string;bo_relative_path : boolean = TRUE) : boolean;
{ esegue il browse per files di tipo galateo; rende TRUE in caso di successo;
  fino al 2025-11-12 si trovava nella DLL (nel corpo di CASA), poi spostata per apparenti problemi con le chiamate dei DIALOGs standard;
  se il file si trova nella directory STR_DEFAULT_PRINT_PATH o in una sua sottodirectory,
  viene indicata solo la parte di path a partire da (relativa a) STR_DEFAULT_PRINT_PATH }
var str_initial_path : string;
begin
	try
		// 2009-02-12, altrimenti se passo un percorso senza nome file la procedure non esegue nessuna azione
		if (str_filename <> '') AND (extractFilename(str_filename) = '') then str_filename := str_filename + '*' + GALATEO_EXT;

		var str_temp := str_filename;
		if find_full_filename(str_default_print_path, str_temp, GALATEO_EXT) then str_initial_path := ExtractFilePath(str_temp)
		else begin
			var i := pos(';', str_default_print_path);
			if (i = 0) then i := length(str_default_print_path) + 1;
			str_initial_path := copy(str_default_print_path, 1, i-1)
		end;

		result := browse_for_files_open(father, 'Seleziona report', str_filename, GALATEO_EXT, GALATEO_FILES_FILTER, str_initial_path, bo_relative_path);
		if result then str_filename := lowercase(str_filename)

{		var dlg := TOpenDialog.create(father);
		dlg.DefaultExt := DEFAULT_EXT;
		dlg.options := [ofPathMustExist, ofFileMustExist, ofNoTestFileCreate];
		dlg.filter := FILES_FILTER;
		dlg.filename := str_filename;var str_temp := str_filename;
		if dlg.InitialDir := str_initial_path;
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
		dlg.free }
	except
		result := FALSE
	end
end;


