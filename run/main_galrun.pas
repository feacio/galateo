unit main_galrun;		//*

{$I \DX\defines}

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ImgList, Menus, ExtCtrls, System.ImageList,
	JvComponentBase, JvTrayIcon,
	Fcommons, FDB,
	Gdich;

{$I E:\DX\galateo\galateo_versione}
{$I E:\DX\galateo\printopt.h}

const
	MBOX_CAPTION = 'modulo avvio Galateo';		// per distinguerlo dal semplice caption 'GALATEO', soprattutto a debug-time

const
	// parametri standard JOLLY (gli originali veri si trovano su E:\DX\JOLLY\config_dich.pas)
	JOLLY_DEFAULT_DATABASE_SERVER = 'jolly';
	JOLLY_DEFAULT_DATABASE_NAME = 'jolly';
	JOLLY_DEFAULT_USER_NAME = 'jop';				// nome del default operator; questo operatore deve essere comunque usato per eseguire tutte le operazioni di sistema
	JOLLY_DEFAULT_PASSWORD = 'jpw';		// password default dell'operatore
	JOLLY_SYMBOLO_CREDENZIALI = '@';		// rimanda all'uso delle credenziali salvate da Jolly

	HELP_TEXT = 'parametri:' + ACAPO +
		GALRUN_PARM_FILENAME +				'nome_report' + ACAPO +
//		GALRUN_PARM_ALIAS +					'nome_connessione' + ACAPO +
		GALRUN_PARM_CONN_PARMS +			'parametro di connessione database' + ACAPO +
		GALRUN_PARM_PARAMETRO_GALATEO +	'nome_parametro=valore_parametro' + ACAPO +
		GALRUN_PARM_PARAMETRO_FILENAME +	'nome_file_parametri' + ACAPO +
		GALRUN_PARM_DEBUG_BASE +			' debug (modalità base)' + ACAPO +
		GALRUN_PARM_DEBUG_FULL +			' debug (modalità full)' + ACAPO +
		GALRUN_PARM_MAIL_DEFAULT_TO +		' indirizzo mail principale' + ACAPO +
		GALRUN_PARM_MAIL_DEFAULT_CC +		' indirizzo mail CC' + ACAPO +
		GALRUN_PARM_MAIL_DEFAULT_CCN +	' indirizzo mail CCN' + ACAPO +

		GALRUN_PARM_POPT_GALATEO_MODE + ' modifica la modalità esecuzione stampa' + ACAPO +
		'       ' + GALRUN_PARM_POPT_PRINT_ANTEPRIMA +	'  anteprima (default)' + ACAPO +
		'       ' + GALRUN_PARM_POPT_PRINT_PRINTER +		'  stampa su stampante' + ACAPO +
		'       ' + GALRUN_PARM_POPT_PDF +					'  stampa su file PDF' + ACAPO +
		'       ' + GALRUN_PARM_POPT_EMAIL +				'  stampa su PDF e invia per mail' + ACAPO +
//		'       ' + GALRUN_PARM_POPT_DIRECTLY_EXECUTE + '  esegue senza conferme preliminari' + ACAPO +
		'       ' + GALRUN_PARM_POPT_SILENT +				'  esegue in modalità completamente SILENTE' + ACAPO +
		'       ' + '(è possibile usare più parametri: ' +
			GALRUN_PARM_POPT_GALATEO_MODE + GALRUN_PARM_POPT_PDF + '+' + GALRUN_PARM_POPT_DIRECTLY_EXECUTE + ' )' + ACAPO +
		ACAPO +
		'Il file parametri contiene un parametro per riga nel formato NOME=VALORE' + ACAPO +
//		'I parametri ' + GALRUN_PARM_FILENAME_BASE + ' e ' + GALRUN_PARM_CONNESSIONE_BASE + ' sono obbligatorî' + ACAPO +
//		'Il parametro ' + GALRUN_PARM_CONNESSIONE_BASE + ' può essere blank';
		'Il parametro ' + GALRUN_PARM_FILENAME_BASE + ' è obbligatorio' + ACAPO2 +
		'Il parametro ' + GALRUN_PARM_CONN_PARMS_BASE + ' può contenere più elementi separati da ;' + ACAPO +
		'       ' + DBP_USERNAME + 'nome utente' + ACAPO +
		'       ' + DBP_PASSWORD + 'password' + ACAPO +
		'       ' + DBP_HOST + 'computer host' + ACAPO +
		'       ' + DBP_SERVER + 'database server' + ACAPO +
		'       ' + DBP_DATABASE + 'database name' + ACAPO +
		'       ' + DBP_PORT + 'numero porta' + ACAPO +
		'       ' + GALRUN_PARM_CONN_PARMS_BASE + '=' + JOLLY_SYMBOLO_CREDENZIALI + DEFAULT_JOLLY_DATABASE_PARMS_SYMBOL + ' usa le credenziali default JOLLY' + ACAPO +
		'       ' + GALRUN_PARM_CONN_PARMS_BASE + '=' + JOLLY_SYMBOLO_CREDENZIALI + 'NOME usa le credenziali salvate sul profilo NOME' + ACAPO +
		'       ' + 'NB: il profilo di connessione deve essere abilitato' + ACAPO +
		'       ' + 'per essere utilizzato esternamente a JOLLY';

type
	parm_type = record
		str_nome, str_valore : string;
	end;

  Tgrun_main = class(TForm)
	 IL: TImageList;
	 popup: TPopupMenu;
	 itp_close: TMenuItem;
	 Timer: TTimer;
    itp_about: TMenuItem;
    N1: TMenuItem;
    itp_report: TMenuItem;
    ttray: TTrayIcon;
	 procedure FormCreate(Sender : TObject);
	 procedure itp_closeClick(Sender : TObject);
	 procedure TimerTimer(Sender : TObject);
	 procedure ttrayClick(Sender : TObject);
	 procedure itp_aboutClick(Sender : TObject);
	 procedure itp_reportClick(Sender : TObject);
  private
		parms : array of parm_type;
		str_filename, str_conn_parms : string;
		bo_debug_base, bo_debug_full : boolean;
		lo_print_style : integer;
		str_mail_address : array[mail_target_type] of string;
		procedure help(str_message : string = '');
		function read_parametri : boolean;
		procedure about_proc;
		procedure check_DLL_version;
		procedure print;
		function print_setup(i_job: smallint): boolean;
	end;

var
  grun_main: Tgrun_main;

implementation

{$R *.dfm}
{$R E:\DX\GALATEO\eventlog-messages\galateo_eventlog.res}			// decodifica dei messaggi sull' eventlog

uses FXStrings, FStrings, FDebug, FRDebug, FMessage, FProcs, FFile, Fdata,
	print_link;

const
//	PROGRAM_NAME = 'GalRun';
	GALRUN_PROGRAM_NAME = 'Galateo''s runtime';

procedure Tgrun_main.check_DLL_version;
begin
	var lo_dll_version : integer := 0;
	if (GAL_get_version >= FIRST_GALATEO_VERSION_WITH_DLL_CHECK) then lo_dll_version := GAL_get_DLL_version;
	var s := '';
	if (lo_dll_version < DLL_COMPATIBILITY_VERSION) then s := 'CASA.DLL';
	if (lo_dll_version > DLL_COMPATIBILITY_VERSION) then s := uppercase(extractFilename(paramstr(0)));
	if (s <> '') then begin
		MessageBBox(handle, s + ' deve essere aggiornato ad una versione più recente', MBOX_CAPTION, MB_ICONSTOP);
		halt
	end
end;

procedure Tgrun_main.FormCreate(Sender : TObject);
var s : string;	//*
begin
	itp_report.Visible := FALSE;
	timer.Enabled := FALSE;
	// eventlog che si occupa solo dei parametri (eventlog stampa è gestito da CASA.DLL)
	set_eventlog_program_name(GALRUN_EVENTLOG_PROGRAM_NAME);
	registra_eventlog_messages_decoder({bo_install}TRUE, GALRUN_EVENTLOG_PROGRAM_NAME);
	for var i : smallint := 0 to paramcount do s := s + paramstr(i) + ' ';
	write_registro_eventi(ELT_INFORMATION, s, ELMSG_PARAMETRI_AVVIO);

	check_DLL_version;

	if NOT read_parametri then halt;
	ttray.Hint := MBOX_CAPTION + ' [' + str_filename + ']';
//	ttray.Cycleicons := TRUE;ttray.Startminimized := TRUE;
//	{$ifndef DEBUG} timer.interval := 100; {$endif}
	timer.Enabled := TRUE
end;

procedure Tgrun_main.itp_closeClick(Sender : TObject); begin close end;
procedure Tgrun_main.itp_aboutClick(Sender : TObject); begin about_proc end;

procedure Tgrun_main.TimerTimer(Sender : TObject);
begin
	timer.Enabled := FALSE;
	print
end;

procedure Tgrun_main.help(str_message : string = '');
begin
{	MessageBBox(handle,ifs(str_message <> '',str_message + ACAPO2) +
		'GAL RUN -- runtime per GALATEO per Windows ver ' + version_of(VERSION) + ACAPO2 + HELP_TEXT,
		MBOX_CAPTION); {}
	write_registro_eventi(ELT_ERROR, str_message, ELMSG_PARAMETRI_ERROR);
	str_message := ifs(str_message <> '', str_message + ACAPO2) +
		'GAL RUN -- runtime per GALATEO per Windows ver ' + version_of(GALATEO_VERSION) + ACAPO2 + HELP_TEXT;
	application.MessageBox(LPSTR(str_message), MBOX_CAPTION, MB_ICONSTOP);
	abort
end;

function Tgrun_main.read_parametri : boolean;
// legge e interpreta i parametri; rende TRUE in caso di successo, FALSE in caso di errore
var local_parms : array of string;

	procedure get_parm_parametro(s : string);
	// legge il parametro PARM_PARAMETRO_GALATEO caricato su S
	begin
		var str_context := 'PARAMETRO ' + s;
		if NOT start_with(s, GALRUN_PARM_PARAMETRO_GALATEO) then exit;
		delete(s, 1, length(GALRUN_PARM_PARAMETRO_GALATEO));
		var i : smallint := pos('=', s);if (i = 0) then help('manca il segno di uguaglianza' + str_context);
		var j : smallint := length(parms);
		setLength(parms, j+1);
		parms[j].str_nome := togliblanks(copy(s, 1, i-1));
		parms[j].str_valore := togliblanks(copy(s, i+1, MAXINT))
	end;

	function load_external_parameters_file(str_filename : string) : boolean;
	// legge il contenuto del file contenente parametri (GALRUN_PARM_PARAMETRO_FILENAME); rende FALSE in caso di errore
	var
		s : string;	//*
		f : system.Text;	//*
	begin
		result := FALSE;
		try
			if (open_textfile_readonly(f, str_filename) <> 0) then abort;
			while NOT eof(f) do begin
				readln(f, s);s := togliblanks(s);
				if (s = '') OR (start_with(s, '//')) then continue;
				setLength(local_parms, length(local_parms)+1);
				local_parms[high(local_parms)] := s
			end;
			system.close(f);
			result := TRUE
		except
			help('Errore durante la lettura del file di parametri: ' + str_filename)
		end
	end;

	function get_mail_address(var str_line : string;str_parametro : string) : boolean;
	// legge il parametro con indirizzo mail specificato da STR_PARAMETRO; rende TRUE se viene eseguita la lettura, FALSE se la procedura non fa nulla
	begin
		result := FALSE;
		if NOT start_with(str_line, str_parametro, {case-sensitive}FALSE) then exit;
		var s := togliblanks(copy(str_line, length(str_parametro) + 1, MAXINT));

		var tipo : mail_target_type := MTT_TO;	// esigenze del compilatore
		if (uppercase(str_parametro) = GALRUN_PARM_MAIL_DEFAULT_TO) then tipo := MTT_TO else
		if (uppercase(str_parametro) = GALRUN_PARM_MAIL_DEFAULT_CC) then tipo := MTT_CC else
		if (uppercase(str_parametro) = GALRUN_PARM_MAIL_DEFAULT_CCN) then tipo := MTT_CCN
		else abort;
		if (pos('@', s) = 0) then help('Indirizzo mail non corretto <' + s + '>');
		add_delimited(str_mail_address[tipo], s, ACAPO);
		result := TRUE
	end;

	function read_POPT_parameter(var s : string) : boolean;
	// esegue la lettura del parametro GALRUN_PARM_POPT_GALATEO_MODE; rende TRUE se viene eseguita la lettura, FALSE se la procedura non fa nulla
	begin
		var str_originale := s;
		if NOT start_with(s, GALRUN_PARM_POPT_GALATEO_MODE) then begin result := FALSE;exit end;
		if (lo_print_style <> 0) then help('Parametro ' + GALRUN_PARM_POPT_GALATEO_MODE + ' ripetuto');
		s := togliblanks(copy(s, length(GALRUN_PARM_POPT_GALATEO_MODE) + 1, MAXINT));

		while (s <> '') do begin
			if start_with(s, '+') then s := togliblanks(copy(s, 2, MAXINT));
			var i : byte := 0;while(i < GALRUN_PARMS_POPT_NUMBER) AND NOT start_with(s, GALRUN_PARMS_POPT[i]) do inc(i);
			if (i = GALRUN_PARMS_POPT_NUMBER) then help('Errore durante la lettura del parametro: ' + str_originale);

			lo_print_style := lo_print_style OR GALRUN_PARMS_POPT_VALUES[i];
			s := togliblanks(copy(s, length(GALRUN_PARMS_POPT[i]) + 1, MAXINT))
		end;

		lo_print_style := lo_print_style OR GAL_POPT_FORZA_IMPOSTAZIONI_PROGRAMMA_CHIAMANTE;	// forzo l'applicazione esclusiva delle impostazioni
		result := TRUE
	end;

	procedure read_parametri_connessione(s : string);
	begin
		if (str_conn_parms <> '') then help('parametro CONNESSIONE ripetuto');
		str_conn_parms := togliblanks(copy(s, length(GALRUN_PARM_CONN_PARMS) + 1, MAXINT));
		if str_conn_parms.StartsWith(JOLLY_SYMBOLO_CREDENZIALI) then begin
			var p : cl_database_parms := cl_database_parms.create;
			var str_profilo := copy(str_conn_parms, length(JOLLY_SYMBOLO_CREDENZIALI) + 1, MAXINT);
			var str_filename := p.get_filename(str_profilo);
			if NOT p.read_from_file(NIL, str_filename) then
				help(s + ACAPO2 + 'profilo <' + str_profilo + '> non trovato' + ACAPO + 'o non abilitato all''utilizzo al di fuori di JOLLY');
			str_conn_parms := p.AsString;
			p.Free
		end
//		else str_conn_parms := str_conn_parms.Replace(';', ACAPO)	** viene cmq eseguito in CASA.DLL
	end;

var s, str_fn, str_parametro_originale : string;
begin
	result := TRUE;
//	var bo_connessione_blank := FALSE;
	try
		if (paramcount = 0) then help;
		setLength(local_parms, paramcount);
		for var i : smallint := 1 to paramcount do local_parms[i-1] := uppercase(paramstr(i));
		var i : smallint := -1;
		while (i < high(local_parms)) do begin
			inc(i);
//			s := uppercase(paramstr(i));
			s := local_parms[i];str_parametro_originale := s;
			if start_with(s, GALRUN_PARM_FILENAME) then begin
				if (str_filename <> '') then help('parametro NOME REPORT ripetuto');
				str_filename := copy(s,length(GALRUN_PARM_FILENAME) + 1, MAXINT);
				str_filename := ChangeFileExt(str_FileName, GALATEO_EXT);
				if NOT FileExists(str_filename) then help('Il file <' + str_filename + '> non esiste');
				continue
			end;

//			if start_with(s, GALRUN_PARM_CONNESSIONE) then begin
{			if start_with(s, GALRUN_PARM_ALIAS) then begin
				if bo_connessione_blank OR (str_alias <> '') then help('parametro CONNESSIONE ripetuto');
				str_alias := copy(s, length(GALRUN_PARM_ALIAS) + 1, MAXINT);
				bo_connessione_blank := (str_alias = '');
				continue
			end; }

			if start_with(s, GALRUN_PARM_CONN_PARMS) then begin read_parametri_connessione(s);continue end;
			if start_with(s, GALRUN_PARM_PARAMETRO_GALATEO) then begin get_parm_parametro(s);continue end;

			if start_with(s, GALRUN_PARM_DEBUG_FULL) then begin bo_debug_full := TRUE;continue end;
			if start_with(s, GALRUN_PARM_DEBUG_BASE) then begin bo_debug_base := TRUE;continue end;

			if get_mail_address(s, GALRUN_PARM_MAIL_DEFAULT_TO) then continue;
			if get_mail_address(s, GALRUN_PARM_MAIL_DEFAULT_CC) then continue;
			if get_mail_address(s, GALRUN_PARM_MAIL_DEFAULT_CCN) then continue;	

			if read_POPT_parameter(s) then continue;

			if start_with(s, GALRUN_PARM_PARAMETRO_FILENAME) then begin
				str_fn := copy(s, length(GALRUN_PARM_PARAMETRO_FILENAME)+1, MAXINT);
				if NOT load_external_parameters_file(str_fn) then abort;
				continue
			end;

			help('parametro non riconosciuto: ' + s)
		end;

		// verifica dei parametri obbligatori
		if (str_filename = '') then help('Non è stato indicato il nome del report da stampare');
//		if (str_connessione = '') AND NOT bo_connessione_blank then help('Non è stato indicato il nome della connessione da utilizzare')
	except
		result := FALSE
	end
end;

procedure Tgrun_main.ttrayClick(Sender : TObject);
begin
	application.restore;
//	ttray.ShowMainForm		// necessario altrimenti in alcune circostanze non mostra il bottone sulla taskbar
end;

procedure Tgrun_main.print;
var info : report_info_type;
begin
	info.str_filename := str_filename;info.str_description := '';info.lo_key_report := 0;
	GAL_open_and_print_method(self, MBOX_CAPTION, {default_path}'', {filename}info, print_setup, lo_print_style, str_conn_parms);
//	if (MessageBBox(handle, 'Vuoi chiudere?', MBOX_CAPTION, MB_QUESTION) = IDYES) then close
	close
end;

function Tgrun_main.print_setup(i_job : smallint) : boolean;
begin
	try
		for var i : smallint := 0 to high(parms) do GAL_set_string_value(i_job, parms[i].str_nome, parms[i].str_valore, TRUE);

		if bo_debug_full then bo_debug_base := FALSE;		// tanto per non fare casino
		// DEBUG: parametro 1 per attivare (in realtà qualunque parametro diverso da '0' e da blank), 0 per disattivare
		if bo_debug_base then GAL_set_global_option(i_job, GAL_DEBUGMODE_BASE, '1');
		if bo_debug_full then GAL_set_global_option(i_job, GAL_DEBUGMODE_FULL, '1');
		for var i : byte := 0 to byte(high(mail_target_type)) do
			if (str_mail_address[mail_target_type(i)] <> '') then
				GAL_set_global_option(i_job, GAL_GOPT_SET_EMAIL_ADDRESSES[mail_target_type(i)], str_mail_address[mail_target_type(i)]);
		result := TRUE
	except
		result := FALSE
	end
end;

procedure Tgrun_main.about_proc;
begin
	var dt_DLL : TDatetime := get_file_datetime(DLL_FILENAME);
	MessageBBox(handle, 'Versione runtime di supporto per GALATEO' + ACAPO2 +
		uppercase(extractFileName(paramstr(0))) + ' ver. ' + version_of(GALATEO_VERSION) + '  ' + asstring_datetime(get_file_datetime(paramstr(0))) + ACAPO +
		uppercase(DLL_FILENAME) + ' ver. ' + version_of(GAL_get_version) + ifs(dt_DLL <> 0, '  ' + asstring_datetime(dt_DLL)) + ACAPO2 +
		ifs(dt_DLL = 0, 'Federico Callioni', 'Federico Callioni, 1994-' + inttostr(year(dt_DLL))) + ' - ' + 'www.feaci.it', MBOX_CAPTION)
end;	

procedure Tgrun_main.itp_reportClick(Sender : TObject);
begin
//	da fare: MessageBBox() con info sul report in esecuzione
end;

initialization
	set_debug_mbox_caption(GALRUN_PROGRAM_NAME);
	box_allow_free_database_configuration_files := XFALSE;	// i files di configurazione database devono essere predisposti per l'utilizzo FREE
	init_galateo(application.handle, get_CASA_security_ID({jolly}FALSE), {silent}FALSE, {system_debug_mode}0, RDB_BLANK, {GALRUN_PROGRAM_NAME,}
		'http://www.feaci.it', (*{PDF_allowed}TRUE,*) '', NIL);
//	init_galateo(application.handle, bo_debug, PROGRAM_NAME, LOGO_NOME_1,{bo_PDF_allowed} {$ifdef PDF} TRUE {$else} FALSE {$endif}, {GALATEO_conn_parms}'', NIL);
	FDB_DEFAULT_USER_NAME := JOLLY_DEFAULT_USER_NAME;
	FDB_DEFAULT_PASSWORD := JOLLY_DEFAULT_PASSWORD;
	FDB_DEFAULT_DBSERVERNAME := JOLLY_DEFAULT_DATABASE_SERVER;
	FDB_DEFAULT_DATABASENAME := JOLLY_DEFAULT_DATABASE_NAME;
//	FDB_DEFAULT_PORT := 2638
finalization
	finalization_debug('galateo_run')
end.
