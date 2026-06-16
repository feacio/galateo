unit gdich;	// Galateo DICHiarazioni

{		fare dialog di selezione indirizzi mail reali
			- con distinzione tra TO: CC: CCN:
			- con indicazione dell'indirizzo predefinito
			- con indicazione degli indirizzi predefiniti per tipologia (FATTURA/ MAGAZZINO/ ORDINI/ ...)
			- elenco di tutti gli altri indirizzi

		per me DB_COMMON non serve a nulla; cancellarlo?  2000-02-23

		scritte in verticale
		aggiungi funzionalità di visual-resizing per TUTTI gli objecti
		dare la possibilità di usare dei 'fogli di fondo' per consentire l'utilizzo di carta intestata individuale su report comuni
		bottone di allineamento al centro (horz & vert) tra più oggetti
		ATTRIBUTO DI UN CAMPO: essere stampato sulla prima riga oppure sull'ultima dell'eventuale oggetto multi-linea
			(esempio: un importo da stampare in corrispondenza alla fine della descrizione)
?		de-staticizzare il numero max di oggetti e di pagine fisiche gestibili

**********
	AGGIUNGERE campo commenti alla query della sezione e/o alla sezione stessa;

	IMMEDIATE
		bloccare riposizionamento di oggetti runtime (DLL)
		bloccare tipo stampante (non bloccata, grafica, text only)

	FASCICOLAZIONE

	BUGS E PROBLEMI
		problema della stampante predefinita
		check ricorsività nei legami comunitari
		se piazzo una cornice che inizia a metà di oggetto testo che viene splittato su piu' righe,
			la cornice non viene ingrandita ma spinta sul fondo

		due oggetti in una sezione, allineati in basso:
			il primo più grande, non wrappabile
			il secondo più piccolo, wrappabile, e con testi che si distribuiscono su più righe
			il primo viene stampato correttamente, il secondo si sposta sotto di uno spazio corrispondente a sè stesso

	UTILI
		oggetti RTF (aggiungere funzionalità all'oggetto testo già esistente, piuttosto che aggiungere un 'oggetto RTF')
		passare i REMARKS su tutti gli oggetti (anche oggetti grafici)

	UTILI MA COSTOSE
		componente di collegamento per delphi

	EVENTUALI
		ottimizza automatic move and size (che è un po' troppo lento quando ci sono tanti oggetti)
}

{$I defines}

interface

uses Forms, Windows, Sysutils, Graphics, Dialogs, DB, Classes, Controls, Math,
	WPPDFR1,
	Fcommons, FRDebug, SMTP_proc, FRedemption;

{$I printopt.h}	// elenco delle opzioni disponibili
{$I galateo_versione}
{$I printtyp.h}	// tipi usati per il collegamento alla DLL

{$ifdef GALATEO_EXE}	procedure set_global_modified(bo : boolean = TRUE);	{$endif}
procedure GALATEO_init_WPDF_DLL;	// inizializza la DLL WPDF

var
	lo_creation : integer;	// variabile di uso distribuito per impostazioni default su nuovi oggetti
	{$ifdef DLL} general_runtime_parent : TForm; {$endif}		// form di uso generale come parent per tutti coloro che ne hanno bisogno

const
	// tutte le dimensioni max erano 50 cm fino a 2009-07
	MAX_WIDTH_CM = 200;
	MAX_HEIGHT_CM = 500;
	MAX_WIDTH_LABEL_CM = MAX_WIDTH_CM;
	MAX_HEIGHT_LABEL_CM = MAX_HEIGHT_CM;
	MAX_WIDTH_PHISICAL_PAGE_CM = MAX_WIDTH_CM;
	MAX_HEIGHT_PHISICAL_PAGE_CM = MAX_HEIGHT_CM;

	MAX_HEIGHT_SEZIONE_CM = 500;	// 2021-03, prima era 40 cm

	MAX_LENGTH_ID_PAGINA_LOGICA = 32;		// lunghezza max ID (identificatore) delle pagine logiche

	FD_DIALOG_OPTIONS = [frDown, frHideMatchCase, frHideWholeWord, frHideUpDown];

type
	report_type = (	// TIPO DI REPORT, ovvero di stampa
		TR_REPORT,					// report SQL classico
		TR_LABEL_STANDALONE,		// label
		TR_LABEL_REPORT);			// label stampata da query SQL (mix tra report e label)
	report_target_type = (	// tipo di destinazione del report: stampante, PDF, export
		RTA_PRINTER,
//		RTA_EMAIL,					// EMAIL non può essere un target, perchè deve essere associato a PDF oppure EXPORT_INTEGRALE
		RTA_PDF,
		RTA_EXPORT);				// EXPORT: exportazione integrale e XML
	report_target_punt = ^report_target_type;
const
	RTA_PRINT_TARGETS = [RTA_PRINTER, RTA_PDF];					// viene eseguita una stampa, reale o virtuale
	RTA_PRINT_TARGET_DESCRIZIONE : array[report_target_type] of string = ('PRINTER', 'PDF', 'EXPORT');

	XML_ID_PAGINA_LOGICA_PLACEHOLDER = '@';				// marcatore per la posizione della sottosezione nel formato XML
	XML_PAGINA_LOGICA_BEFORE = '<#PAGINA=';
	XML_PAGINA_LOGICA_AFTER = '#>';
//	XML_PAGINA_LOGICA = '<#PAGINA=' + XML_ID_PAGINA_LOGICA_PLACEHOLDER + '#>';		// marcatore per la posizione della sottosezione nel formato XML
	XML_PAGINA_LOGICA = XML_PAGINA_LOGICA_BEFORE + XML_ID_PAGINA_LOGICA_PLACEHOLDER + XML_PAGINA_LOGICA_AFTER;
	XML_SEZIONE = '<#SEZIONE#>';					// marcatore per la posizione della sezione nel formato XML della pagina logica
	XML_SOTTOSEZIONE = '<#SOTTOSEZIONE#>';		// marcatore per la posizione della sottosezione nel formato XML della sezione (di livello superiore)
const
	REPORT_TYPES = [TR_REPORT, TR_LABEL_REPORT];
	LABEL_TYPES = [TR_LABEL_STANDALONE, TR_LABEL_REPORT];
	TIPOREPORT_DESCRIZIONE : array[REPORT_TYPE] of string = ('Report', 'Etichetta', 'Report di etichette');
{$ifdef GALATEO_EXE}
const
	SET_SEL_BOTTOM = 1;
	SET_SEL_TOP = 2;
	SET_SEL_LEFT = 3;
	SET_SEL_RIGHT = 4;
	SET_SEL_APPLICA_STYLE = 5;
	DELTA_CUSCINO_VERTICAL_HEIGHT = 0.2;		// spazio di respiro nel posizionamento degli oggetti a video

	SHORTCUT_ELENCO_MACROS = 'alt+ctrl+F8'; 	// shortcut che attiva la windows delle macro parametriche
{$endif}
type
	horz_align_type = (HAT_LEFT, HAT_CENTER, HAT_RIGHT);
	vert_align_type = (VAT_TOP, VAT_CENTER, VAT_BOTTOM);

const
	DLL_SYSTEM_DEBUG_DISATTIVO = 0;
	DLL_SYSTEM_DEBUG_BASE = 1;
	DLL_SYSTEM_DEBUG_DETTAGLIATO = 2;
type
	cl_computer_registry_data = class
		bo_exclude_runtime_message_computer : boolean;
		i_DLL_system_debug_level : byte;		// parametro che attiva il debug; macros DLL_SYSTEM_DEBUG_xxxxxxxxx
		RDEBUG_mode : RDEBUG_MODE_type;
		debug_target : GALATEO_debug_target_type;
		{$ifndef DLL} str_galrun_path : string; {$endif}
		lo_hidden_objects_color : TColor;
		function read_registry_values : boolean;
		{$ifdef GALATEO_EXE} function write_registry_values : boolean; {$endif}
		function get_system_debug_mode : word;
	end;
var
	computer_registry_data : cl_computer_registry_data;
	xxcallback_replace_variabili_ambiente : callback_replace_variabili_ambiente_procedure_type;
const
	VARIABILE_AMBIENTE_ALLOWED_MSG = 'E'' possibile utilizzare variabili di ambiente che saranno interpretate a runtime' + ACAPO2 +
		'Le variabili di ambiente possono essere:' + ACAPO +
		'- di SISTEMA (esempio: %USERPROFILE% per indicare il percorso dei documenti dell''utente)' + ACAPO +
		'- di AMBIENTE ovvero definite dal programma chiamante (esempio: $JOLLY$ per indicare il percorso base del programma JOLLY)' + ACAPO2 +
		'è compito dell''utente assicurarsi di utilizzare la sintassi corretta';

var
	{$ifdef DLL} str_calling_program : string; {$endif}			// nome del programma chiamante; esempio: "JOLLY"
	{$ifdef DLL} str_DLL_calling_program : string; {$endif}		// nome completo del programma chiamante + DLL: esempio "[JOLLY] galateo"
	str_author : string;
	bo_PDF_allowed : boolean;
	ptr : pointer;
	xstr_default_connection_parms : string;		// parametri default di connessione (non legati a specifiche stampe ma inizializzati runtime dall'applicazione chiamante)
	str_runtime_default_system_database_alias, str_runtime_default_system_database_driver : string;	// valori default, meglio utilizzare quelli 'freschi' passati ad ogni stampa
	registry_SMTP : cl_SMTP;							// contiene i dati SMTP letti dal registry; è la copia originale che viene travasata su STATIC_SMTP all'avvio di ogni report
	{$ifdef CASA} work_SMTP : cl_SMTP; {$endif}	// contiene le impostazioni SMTP di lavoro (condivise, esterne, ...)
	box_SMTP_protocol_calling_program : xboolean;	// valore del parametro impostato dal programma esterno
	static_outlook : cl_outlook;
	lo_serial_number_impagina : integer;

const
//	PROGRAM_NAME = 'GALATEO';
	PROGRAM_NAME_BASE = 'GALATEO';
//	{$ifNdef DLL} PROGRAM_NAME_BASE = 'GALATEO DX'; {$endif DLL}	// aggiunto DX per distinguerlo da versione D6
	BITNESS = {$ifdef WIN64} '(64bit)' {$else} '(32bit)' {$endif};
	PROGRAM_NAME = PROGRAM_NAME_BASE + ' ' + BITNESS;

	// definizione limiti generali di Galateo
	MAX_PAGINE_LOGICHE = 12;							// numero max di pagine per ogni documento
//	MAX_PHISICAL_PAGES_PER_LOGICAL_PAGE = 4096;	// numero max di pagine fisiche per ogni pagina logica
//	MAX_SECTIONS = 4;										// compresa la main
	MAX_SECTIONS = 5;										// compresa la main -- dal 2011-07-05
	MAX_JOBS = {$ifdef DLL} 1 {$else} 1 {$endif};	// num max di stampe contemporanee (per DLL)
	MAX_OBJS = 400;										// numero max di oggetti utilizzabili in ogni pagina del disegno (was 300 until 2017-10)
	// text only constants
	MAX_LINES_PER_PRINT_PAGE = 128;					// dubito che una pagina text only ne possa contenere di più
	MAX_COLUMNS_PER_PRINT_PAGE = 254;
//	TEXT_ONLY_FONT_DEFAULT = 'Courier new';
	TEXT_ONLY_SIZE_DEFAULT = 12;						// dimensione font
	TEXT_ONLY_LPI_DEFAULT = 6;							// lines per inch

const
	TBL_LINGUE = 'lingue';
	TBL_LNG_STR_CODICE = 'LNG_str_codice';
	TBL_LNG_I_POS_TRADUZIONE = 'LNG_i_pos_traduzione';

	TBL_TRADUZIONI_LINGUA = 'traduzioni_lingua';
	TBL_TDL_STR_CODICE = 'TDL_str_codice';
	TBL_TDL_STR_DESCRIZIONE = 'TDL_str_descrizione';
	TBL_TDL_STR_ID_CONTESTO = 'TDL_str_ID_contesto';

{$ifdef GALATEO_EXE}
type
	{ flags che configurano la modalità di caricamento degli IDs linguistici;
	  gli IDs possono essere legati ad uno specifico contesto, oppure essere privi di contesto (ovvero essere GENERICI) }
	lingua_context_type = (
		LCT_SELECTED_CONTEXT,	// carica gli IDs legati al contesto selezionato
		LCT_OTHER_CONTEXTS,		// carica gli IDs legati a contesti DIFFERENTI da quello selezionato
		LCT_GENERIC);				// carica gli IDs privi di contesto
	lingua_context_set = set of lingua_context_type;

const
	HELP_JOLLY_BASE = 'http://www.feaci.it/jolly/';
	HELP_GALATEO_JOLLY_BASE = HELP_JOLLY_BASE + 'galateo/';
	GALRUN_EXE = 'galrun.exe';
	GALATEO_HOME_PAGE = 'http://www.feaci.it/programmi/galateo.htm';
	GALATEO_TECHNICAL_HOME_PAGE = HELP_GALATEO_JOLLY_BASE + 'galateo.htm';
	// -------------------------------------------------------
	MASK_FORMAT_HELP = HELP_JOLLY_BASE + 'mask';
	SEZIONE_HELP = HELP_GALATEO_JOLLY_BASE + 'sezione';
	EXPORT_HELP = HELP_GALATEO_JOLLY_BASE + 'export';
	EXPORT_INTEGRALE_HELP = HELP_GALATEO_JOLLY_BASE + 'export_integrale';
	XML_HELP = HELP_GALATEO_JOLLY_BASE + 'export_XML';
	VARIABILI_STATICHE_HELP = HELP_GALATEO_JOLLY_BASE + 'variabili_statiche';
	HELP_DATABASE_CONNECTION = HELP_GALATEO_JOLLY_BASE + 'parametri_connessione_DB';
	MACRO_PARAMETRICHE_HELP = HELP_GALATEO_JOLLY_BASE + 'macro_parametriche';
	HELP_PAGINE = HELP_GALATEO_JOLLY_BASE + 'pagine';
	HELP_GESTIONE_AUTOMATICA_PROGRESSIVI_PAGINA = HELP_GALATEO_JOLLY_BASE + 'progressivi_pagina';
	HELP_FUNZIONI = HELP_GALATEO_JOLLY_BASE + 'funzioni';
	HELP_DATETIME_FORMAT = HELP_GALATEO_JOLLY_BASE + 'datetime-format';
	HELP_SQL_SCRIPTS = 'SQL-scripts';
	HELP_RUNTIME_PARMS = HELP_GALATEO_JOLLY_BASE + 'runtime_parms';
	HELP_RUNTIME_PARMS_GBOXES_SEGNALIBRO = 'GBOXES';	// riferito a HELP_RUNTIME_PARMS
	HELP_OBJS_TEXT = 'objs_text';
	HELP_OBJS_IMAGES = 'objs_images';
	HELP_OBJS_GRAPHICAL = 'objs_graphics';
	HELP_COMPORTAMENTO_WHEN_NULL = 'null';
{$endif GALATEO_EXE}

const
	MACRO_ID = '#';
	SYSTEM_DEFAULT_DATE_FORMAT = 'dd/mm/yy';		// formato default formattazione dei valori TDate, TDatetime [FormatDateTime()]
	SYSTEM_DEFAULT_TIME_FORMAT = 'hh:nn';			// formato default formattazione dei valori Times [FormatDateTime()]

const
	GALATEO_REGISTRY_BASE = 'software\galateo';
	REGISTRY_DONT_CLOSE_AFTER = 'dont_close_after';
	REGISTRY_GLOBAL_ARGOMENTO = GALATEO_REGISTRY_BASE + '\impostazioni';
	REGISTRY_SMTP_ARGOMENTO = GALATEO_REGISTRY_BASE + '\SMTP';
	REGISTRY_OUTLOOK_ARGOMENTO = GALATEO_REGISTRY_BASE + '\outlook';
//	REGISTRY_PROFILE = 'base';
//	GALRUNT_SYSTEM_DEBUG_KEY = 'DLL-system-debug';
	END_OF_DATAMATRIX = 'eoo-dm';		// stringa che chiude la registrazione di un oggetto DATAMATRIX - Enf Of Object DataMatrix
	OBJECT_NOT_PROPERLY_CLOSED = 'Oggetto non chiuso correttamente';

type
	obj_index_type = smallint;		// tipo di campo che contiene gli indici dei campi
	ph_page_type = smallint;			// tipo della pagina fisica
	logical_page_type = shortint;	// tipo della pagina logica
	section_index_type = smallint;	// tipo del numero di sezione
//	int_pixel_type = {$ifdef DEBUG} smallint {$else} integer {$endif};		// tipo che rappresenta pixels
	int_pixel_type = integer;			// tipo che rappresenta pixels
	misura_real_type = real;			// tipo che esprime le misure espresse in centimetri
	expint_index_type = shortint;		// index dei vettori di profili di exportazione integrale

//	obj_type = (FIRST_TIPO, TESTO, VARIABILE, FORMULA, OBJ_BITMAP, OBJ_RECT, OBJ_LINE, LAST_TIPO);
	obj_type = (FIRST_TIPO, LABEL_OBJ, OBJ_BITMAP, OBJ_RECT, OBJ_LINE, DATAMATRIX_OBJ, LAST_TIPO);
	obj_type_set = set of obj_type;

type
	validazione_type = (VALID_ERROR_IF_BLANK, VALID_ERROR_IF_NOT_BLANK, VALID_FORMULA);
	validazione_context_type = (
		VCTXT_CHECK_PARMS,		// verifica parametri di stampa (prima di RUNTIME e di qualunque altra cosa)
		VCTXT_AFTER_RUNTIME,		// dopo la richiesta dei RUNTIME-PARMS (solo se esistono RUNTIME-PARMS)
		VCTXT_ELABORAZIONE, VCTXT_PRINT, VCTXT_MAIL, VCTXT_FTP, VCTXT_EXPORT_INTEGRALE, VCTXT_XML);
	validazione_context_set = set of validazione_context_type;
	cl_validazione = class
		bo_attivo : boolean;
		tipo : validazione_type;
		str_formula : string;
		str_message : string;				// messaggio più personalizzato e dettagliato
		str_descrizione_field : string;	// descrizione rapida del campo, per la generazione di una referenziazione automatica
		bo_pre_SQL : boolean;			// la validazione viene eseguita PRIMA dell'istruzione SQL della sezione cui l'oggetto appartiene
		bo_bloccante : boolean;			// TRUE se un eventuale errore è grave e blocca la stampa
		str_condizione_bloccante_aggiuntiva : string;		// se BO_BLOCCANTE, la condizione di BLOCCO viene attivata/disattivata da questa condizione; se la condizione è soddisfatta, l'errore è bloccante
		contexts_attivo : validazione_context_set;
		contexts_bloccante : validazione_context_set;		// l'errore è GRAVE nei contesti specificati
//		property asstring : string read xxx write ewww;		poco fuinzionale perchè in lettura mi serve la versione del file letto
		constructor create;
		{$ifdef DEBUG} destructor free; {$endif}
		procedure clear;
{$ifdef GALATEO_EXE}
		function asstring : string;
		procedure assign(source : cl_validazione);
		function get_check_always_standard(bo_bloccante : boolean) : boolean;
{$endif GALATEO_EXE}
		function get_asstring(wo_versione : word;var s : string) : boolean;
	end;
const
{$ifdef GALATEO_EXE}
	VALIDAZIONE_DESCRIZIONI : array[validazione_type] of string = ('errore se blank', 'err. se not blank', 'condizione');
	VALIDAZIONE_CONTEXT_HINT_CHECK_PARMS =
		'il controllo viene eseguito dopo l''assegnazione dei parametri' + ACAPO +
		'e dopo l''esecuzione delle istruzioni SQL-syntax VERY-EARLY';
	VALIDAZIONE_CONTEXT_HINT_AFTER_RUNTIME =
		'il controllo viene eseguito dopo la richiesta di eventuali parametri runtime' + ACAPO +
		'se non vi sono parametri runtime, il controllo viene omesso';
	VALIDAZIONE_CONTEXT_HINT_ALWAYS = 'il controllo viene applicato in tutti i possibili contesti';
	VALIDAZIONE_CONTEXT_HINT_ELABORAZIONE =
		'Il controllo viene applicato durante l''elaborazione del report.' + ACAPO2 +
		'Se la validazione NON viene superata, l''elaborazione viene bloccata' + ACAPO +
		'PRIMA di produrre qualunque tipo di output (compresa l''anteprima di stampa)';
	VALIDAZIONE_CONTEXT_HINT_PRINT = 'il controllo viene applicato in fase di stampa su STAMPANTE o su PDF';
	VALIDAZIONE_CONTEXT_HINT_MAIL = 'il controllo viene applicato solo quando si desidera inviare il report via MAIL';
	VALIDAZIONE_CONTEXT_HINT_FTP = 'il controllo viene applicato solo quando si desidera trasmettere il report via FTP';
	VALIDAZIONE_CONTEXT_HINT_EXPINT = 'il controllo viene applicato solo quando si esegue una EXPORTAZIONE INTEGRALE';
	VALIDAZIONE_CONTEXT_HINT_XML = 'il controllo viene applicato solo quando si esegue una EXPORTAZIONE in formato XML';
{$endif GALATEO_EXE}
	VALIDAZIONE_ALL_STANDARD_CONTEXTS = [low(validazione_context_type)..high(validazione_context_type)] - [VCTXT_CHECK_PARMS, VCTXT_AFTER_RUNTIME];

type
	SQL_reexecute_script_options = (		// opzioni per la ri-esecuzione degli scripts SQL
		SQLRSO_ALWAYS_REEXECUTE,
		SQLRSO_ALLOW_SKIP,
		SQLRSO_DEFAULT_SKIP,
		SQLRSO_CANNOT_REEXECUTE);
const
	SQL_REEXECUTE_SCRIPTS_DESCRIZIONE : array[SQL_reexecute_script_options] of string = (
		'esegui sempre',	//	SQLRSO_ALWAYS_REEXECUTE,
		'consenti salta',		// SQLRSO_ALLOW_SKIP,
		'default salta',		// SQLRSO_DEFAULT_SKIP,
		'sempre salta');		// SQLRSO_CANNOT_REEXECUTE);

const
//	LABEL_OBJ = xxxTESTO;
//	LABEL_OBJS = [xxxTESTO, xxxVARIABILE, xxxFORMULA];					// oggetti rappresentati con una TLabel (o derivata); DATAMATRIX NON è una LABEL_OBJS
//	LABEL_OBJS = [LABEL_OBJ];					// oggetti rappresentati con una TLabel (o derivata); DATAMATRIX NON è una LABEL_OBJS
	NO_TYPE = FIRST_TIPO;
	OLD_TIPO_STATIC_TEXT_DESCRIZIONE = 'TESTO';
	OLD_TIPO_VARIABILE_DESCRIZIONE = 'VARIABILE';
	OLD_TIPO_FORMULA_DESCRIZIONE = 'FORMULA';
//	str_type : array[succ(FIRST_TIPO)..pred(LAST_TIPO)] of string =
	TIPO_OGGETTO_DESCRIZIONE : array[succ(FIRST_TIPO)..pred(LAST_TIPO)] of string = 
//		('TESTO', 'VARIABILE', 'FORMULA', 'BITMAP', 'RETTANGOLO', 'LINEA');
//		(OLD_TIPO_STATIC_TEXT_DESCRIZIONE, OLD_TIPO_VARIABILE_DESCRIZIONE, OLD_TIPO_FORMULA_DESCRIZIONE, 'BITMAP', 'RETTANGOLO', 'LINEA', 'DATAMATRIX');
		('TESTO', 'BITMAP', 'RETTANGOLO', 'LINEA', 'DATAMATRIX');

	// i barcodes sono considerati TESTI benchè siano stampati graficamente, perchè contengono testo e sono analoghi alle FORMULE
	ALPHABETIC_OBJS = [LABEL_OBJ, DATAMATRIX_OBJ];					// comprende i Barcodes (che hanno un testo, anche se sono stampati graficamente)
	GAPP_OBJS = [LABEL_OBJ];												// Gestione Automatica Progressivo Pagina -- vedi GAPP.pas
	EXPINT_OBJS = [LABEL_OBJ];												// si intende "oggetti exportabili con Exportazione Integrale"
//	EXTERNAL_EXPINT_PROFILE_START = 'exp-ext-start';				// marcatura exportazione su external file
//	EXTERNAL_EXPINT_PROFILE_END = 'exp-ext-end';						// marcatura exportazione su external file
//	xFORMULA_OBJS = [xxxFORMULA, DATAMATRIX];							// oggetti che possono essere FORMULE
//	xOBJS_FORMULE_VARIABILI = xFORMULA_OBJS + [xxxVARIABILE];	// oggetti che possono essere FORMULE oppure VARIABILI
	CORNICI_OBJS = [OBJ_RECT, OBJ_LINE];

	DEFAULT_FTP_CONFIRM_MESSAGE = 'Confermi trasferimento dati su server FTP?';

{$ifndef DLL}
	const
		DOC_INFO_UTENTE_DEFAULT_EXT = PDF_EXT;
		DOC_INFO_UTENTE_FILTER = PDF_FILTER;
		TECHNICAL_REFERENCE_DEFAULT_EXT = WORD_EXT;
		TECHNICAL_REFERENCE_FILTER = ALL_FILES_FILTER;
{$endif DLL}

type
	printer_size_constraints_type = (
		PSC_REPORT_DEFAULT,	// applica le impostazioni generali
		PSC_EXCLUDE,			// esclude controllo sulla pagina
		PSC_CUSTOM);			// applica impostazioni personalizzate per la pagina
	printer_size_constraints_data_type = record
		i_min_width_mm, i_min_height_mm, i_max_width_mm, i_max_height_mm : smallint
	end;
{$ifNdef DLL}
	const
		PRINTER_SIZE_CONSTRINTS_DESCRIZIONE : array[printer_size_constraints_type] of string = (
			'applica impostazioni generali',
			'nessun controllo',
			'impostazioni specifiche per la pagina');
{$endif NOT DLL}

type
	risultato_type = (VAL_NUMERO, VAL_TESTO, VAL_BOOLEAN, VAL_BOH);
	risultato_set = set of risultato_type;
	variabile_type = (	// possibili tipi di variabili
		TV_BLANK,								// valore non ammesso, serve per i casi in cui l'oggetto non sia una variabile -- aggiunto il 2006-08-04
		TV_STATIC_TEXT,						// testo fisso (coincidente con il NOME dell'oggetto)
		TV_DB_FIELD,							// colonna database -- was TV_VARIABILE until 2011-05-17
		TV_PARAMETRO,							// parametro impostabile run-time
		TV_GROUP_EXPR_SQL,					// operazione SQL sulla sezione sottostante
		TV_SQL_SELECT_BEFORE_SQL,			// early: valore SQL elaborato prima dell'esecuzione della query SQL
		TV_SQL_SELECT_BEFORE_RUNTIME,		// very-early: valore SQL elaborato prima della richiesta dei parametri runtime
		TV_SQL_SELECT,							// istruzione di SELECT completa ed isolata dal resto
		TV_FORMULA);							// introdotto 2011-05-17, prima era un OBJ_TYPE
	variabile_set = set of variabile_type;
const
	TV_OLD_VARIABILI = [TV_DB_FIELD, TV_PARAMETRO, TV_GROUP_EXPR_SQL, TV_SQL_SELECT_BEFORE_SQL, TV_SQL_SELECT_BEFORE_RUNTIME, TV_SQL_SELECT];	// TV corrispondenti al vecchio OBJ_TYPE 'VARIABILE'
	TV_SCRIPTS_TARGET_APPLICATION = [TV_STATIC_TEXT, TV_PARAMETRO];	// tipi di variabili che possono essere modificate attraverso uno script runtime
	LABEL_TIPI_VARIABILI = [TV_STATIC_TEXT, TV_DB_FIELD, TV_PARAMETRO, TV_GROUP_EXPR_SQL, TV_SQL_SELECT_BEFORE_SQL, TV_SQL_SELECT_BEFORE_RUNTIME, TV_SQL_SELECT, TV_FORMULA];
	DATAMATRIX_TIPI_VARIABILI = [TV_DB_FIELD, TV_FORMULA];	// tipi ammessi per l'oggetto DATAMATRIX
	DATAMATRIX_TIPO_VARIABILE_DEFAULT = TV_FORMULA;
{$ifdef DEBUG}
	ALLOWED_TIPI_VARIABILI : array[obj_type] of variabile_set = (		// tipi di variabili consentiti per ciascun tipo di oggetto
		[TV_BLANK],										// FIRST_TIPO,
		LABEL_TIPI_VARIABILI,						// LABEL_OBJ,
		[TV_BLANK], [TV_BLANK], [TV_BLANK], 	// OBJ_BITMAP, OBJ_RECT, OBJ_LINE,
		DATAMATRIX_TIPI_VARIABILI,					// DATAMATRIX_OBJ,
		[TV_BLANK]);									// LAST_TIPO
{$endif}
	VALIDATE_TIPI_VARIABILI = [TV_STATIC_TEXT, TV_DB_FIELD, TV_PARAMETRO, {TV_GROUP_EXPR_SQL,} TV_SQL_SELECT_BEFORE_SQL, TV_SQL_SELECT_BEFORE_RUNTIME, TV_SQL_SELECT, TV_FORMULA];

	TV_SQL_SELECT_OBJECTS = [TV_SQL_SELECT_BEFORE_SQL, TV_SQL_SELECT_BEFORE_RUNTIME, TV_SQL_SELECT];
	TV_COSTANTI = [TV_PARAMETRO, TV_SQL_SELECT_BEFORE_RUNTIME, TV_SQL_SELECT_BEFORE_SQL];	// tipi di oggetti che non devono essere ricalcolati dopo l'avvio
	TV_DESCRIZIONE : array[variabile_type] of string =
		('', 'testo statico', 'colonna database', 'parametro', 'SQL group function', 'SQL syntax pre SQL (early)', 'SQL syntax pre-runtime (very early)', 'SQL syntax', 'formula Galateo');
{$ifndef DLL}
	FIELD_EDIT_COLOR = $0080FFFF;
	TIPO_VARIABILE_EDIT_COLOR : array[variabile_type] of TColor = (
		0,							// TV_BLANK,
		clWindow,				// TV_STATIC_TEXT,
		FIELD_EDIT_COLOR,		// TV_DB_FIELD,
		FIELD_EDIT_COLOR,		// TV_PARAMETRO,
		FIELD_EDIT_COLOR,		// TV_GROUP_EXPR_SQL,
		FIELD_EDIT_COLOR,		// TV_SQL_SELECT_BEFORE_SQL,
		FIELD_EDIT_COLOR,		// TV_SQL_SELECT_BEFORE_RUNTIME,
		FIELD_EDIT_COLOR,		// TV_SQL_SELECT,
		$00FFFF80				// TV_FORMULA);
	);
{$endif}

type
	recalculate_type = (				// criteri di ricalcolo degli oggetti calcolati
		REC_DEFAULT,					// ricalcola una sola volta, e riutilizza il valore
		REC_UPDATE_RUNTIME_PARMS,	// ricalcola dopo la modifica di qualunque parametro runtime
		REC_AFTER_RUNTIME_PARMS,	// ricalcola dopo la chiusura dei parametri runtime, e prima dell'elaborazione del report
		REC_ALWAYS);					// ricalcola SEMPRE
const
	OGGETTI_CALCOLATI = TV_SQL_SELECT_OBJECTS + [TV_FORMULA];

const
	COMMENTI = '//';	// commenti preceduti da ...
	DEFAULT_COLOR_HIDDEN_OBJECTS = clSilver;
	COLORE_NORMAL_PAGES = $00E3E0D2;
	COLORE_EXTERNAL_PAGES = 12639424;	// verdino ammuffito
//	COLORE_HIDDEN_PAGES = $00E3E0D2;	// azzurrino spento
	COLORE_HIDDEN_PAGES = $00B9DCFF;	// ocretta
	COLORE_SELEZIONE = clRed;
	SELEZIONE_INCLUSIVA = FALSE;	// se TRUE vengono selezionati gli oggetti completamente all'interno dell'area selezionata, se FALSE basta che siano toccati

//	COLORE_DEFAULT_PRINT_BACKGROUND = clMoneyGreen;
	COLORE_DEFAULT_PRINT_BACKGROUND = COLORE_NORMAL_PAGES;
	COLORE_ALTERNATE_BUTTONS_DEFAULT = clYellow;

	LEN_OPERATORE = 2;
{$ifdef GALATEO_EXE}
	MAX_SIGNATURE_LENGTH = 12;
//	MAX_SIGN_DESCRIPTION_LENGTH = 20;
	SYSTEM_SIGNATURE = 'system';
{$endif}
//type str_operatore_type = string[LEN_OPERATORE];
var
	GH : HWND;	// Generic Handle; handle cui chiunque può riferirsi in caso di difficoltà
	xx_lo_record_number : integer;

//procedure read_DLL_system_debug;

{$ifdef GALATEO_EXE}
	const
		EMAIL_ADDRESS_CAPTION : array[email_address_type] of string = ('nessuno', 'principale', 'direzione', 'amministrazione', 'ordini', 'magazzino', 'ufficio tecnico');
		EMAIL_ADDRESS_HINT = 'Gli indirizzi mail vengono richiesti al programma chiamante con riferimento alla tipologia di indirizzo specificata';
		DEFAULT_ALLOWED_EMAIL_ADDRESS_TYPE =		// tipi di indirizzi mail ammessi per la gestione INDIRIZZO DEFAULT
			[{EAT_BLANK,} EAT_PRINCIPALE, EAT_DIREZIONE, EAT_AMMINISTRAZIONE, EAT_ORDINI, EAT_MAGAZZINO, EAT_UFFICIO_TECNICO];
		ELENCO_ALLOWED_EMAIL_ADDRESS_TYPE =			// tipi di indirizzi mail ammessi per la gestione ELENCO INDIRIZZI
			[EAT_BLANK, {EAT_PRINCIPALE,} EAT_DIREZIONE, EAT_AMMINISTRAZIONE, EAT_ORDINI, EAT_MAGAZZINO, EAT_UFFICIO_TECNICO];
//		EMAIL_PRINCIPALE_IF_ANY_CAPTION = 'usa principale se nessuno';
		EMAIL_MAIN_WHEN_UNIQUE_CAPTION = 'principale se unico';
		EMAIL_MAIN_WHEN_UNIQUE_HINT = 'utilizza l''indirizzo principale' + ACAPO + 'se nessun altro indirizzo risulta valido ed utilizzabile';
{$endif}

{
	***** STRUTTURA STAMPA:
	3 livelli:
		1. virtuale (stampa grafica oppure exportazione integrale)
		2. phisical (formato fisico della stampa): PRINTER - FILE PDF - FILE DI TESTO - CLIPBOARD
		3. media di distribuzione (PRINTER - FILE PDF - TEXTFILE - MAIL - FTP - CLIPBOARD
	tra i diversi livelli ci sono molte correlazioni obbligatorie

type
	virtual_target_type = (		// possibili formati di output: o grafico o exportazione integrale
		VTT_DEFAULT,			// non è un formato vero, serve solo per gestire il caso default
		VTT_GRAPHIC,			// stampa oppure creazione di file PDF
		VTT_EXPINT);			// exportazione integrale
	phisical_target_type = (	// formato fisico di preparazione dell'output
		PTT_PRINTER, PTT_PDF, PTT_TEXTFILE, PTT_CLIPBOARD);
	media_target_type =		// modalità attraverso cui il report viene trasmesso
		(MTT_PRINTER, MTT_PDF, MTT_TEXTFILE, MTT_MAIL, MTT_FTP, MTT_CLIPBOARD);
	phisical_target_set = set of phisical_target_type;
	media_target_set = set of media_target_type;
const
	// PHISICAL TARGET_TYPEs consentiti per ciascuno dei VIRTUAL_TARGET_TYPEs
	PHISICAL_ALLOWED : array[virtual_target_type] of phisical_target_set = (
		[PTT_PRINTER, PTT_PDF],				// VTT_GRAPHIC
		[PTT_TEXTFILE, PTT_CLIPBOARD]		// VTT_EXPINT
	);
	// MEDIA_TARGET_TYPEs consentiti per ciascuno dei PHISICAL_TARGET_TYPEs
	MEDIA_ALLOWED : array[phisical_target_type] of media_target_set = (
		[MTT_PRINTER],	// PTT_PRINTER
		[MTT_PDF, MTT_MAIL, MTT_FTP],	// PTT_PDF
		[MTT_TEXTFILE, MTT_MAIL, MTT_FTP, MTT_CLIPBOARD],	// PTT_TEXTFILE
		[MTT_CLIPBOARD]);	// PTT_CLIPBOARD
	PHISICAL_TARGET_DESCRIZIONE : array[phisical_target_type] of string = ('stampante', 'PDF', 'textfile', 'clipboard');
	MEDIA_TARGET_DESCRIZIONE : array[media_target_type] of string = ('stampante', 'PDF', 'textfile', 'mail', 'FTP', 'clipboard'); }
type
	export_integrale_target_type = (
//		EITT_DEFAULT,			// valore predefinito, definito UNA TANTUM sulle opzioni principali del report -- ELIMINATO 2015-04-18 a partire dalla versione $0322
		EITT_CLIPBOARD,
		EITT_FILE,
		EITT_FTP);
	export_file_action_type = (		// azioni intraprese dopo l'exportazione su file
		EFAT_CREATE,					// nessuna azione, solo creazione file (valido solo se EITT_FILE)
		EFAT_CREATE_OPEN,				// crea e apre il file (valido solo se EITT_TEXTFILE_CREATE)
		EFAT_FOLDER,					// apre la cartella del file
		EFAT_NOTHING					// nessuna azione
//		EFAT_COMANDO_SPECIFICO		// esegue un comando specifico (globale.str_expint_comando_specifico)
//		EFAT_CREATE_OPEN				// apre il file creato
	);
	expint_separatore_type = (EIS_TAB, EIS_COMMA, EIS_SEMICOLON);
const
//	EITT_DESCRIZIONE : array[export_integrale_target_type] of string = ('default', 'clipboard', 'file', 'FTP');
	EITT_DESCRIZIONE : array[export_integrale_target_type] of string = ({'default',} 'clipbrd', 'file', 'FTP');
	EITT_FILE_TYPES = [EITT_FILE, EITT_FTP];
	EITT_DEFAULT_FILE_EXT = '.TXT';	// i files generati da exportazione integrale sono per default di questo tipo
	EFAT_DESCR : array[export_file_action_type] of string =
		('crea file', 'crea e apri file', 'crea file e apri cartella',
//			'esegue comando utente');
			'nessuna azione');
	EFAT_DEFAULT = EFAT_FOLDER;
	EIS_DESCRIZIONE : array[expint_separatore_type] of string = ('TAB', 'virgola', 'puntoevirgola');
	EIS_CHAR : array[expint_separatore_type] of string = (^I, ',', ';');
type
	fasi_stampa_type = (FST_ZERO, FST_READING_REPORT, FST_READING_DATA, FST_FORMATTING);
const
	// fase di stampa in cui avviene l'assegnazione degli stored-values
	// è differenziata perchè le variabili devono essere trattate WHEN READING DATA, le formule WHEN FORMATTING
	FASE_STAMPA_ASSEGNAZIONE_STORED_VALUES : array[variabile_type] of FASI_STAMPA_TYPE = (
		FST_ZERO,				//	TV_BLANK,  -- indirettamente vale anche per gli oggetti non di testo (BMPS, GRAPHS, ...)
		FST_READING_DATA,		// TV_STATIC_TEXT
		FST_READING_DATA,		// TV_DB_FIELD
		FST_READING_DATA,		// TV_PARAMETRO
		FST_READING_DATA,		// TV_GROUP_EXPR_SQL
		FST_READING_DATA,		// TV_SQL_SELECT_BEFORE_SQL
		FST_READING_DATA,		// TV_SQL_SELECT_BEFORE_RUNTIME
		FST_READING_DATA,		// TV_SQL_SELECT
		FST_FORMATTING);		// TV_FORMULA

type
	store_operation_type = (STOOP_SET, STOOP_ADD, STOOP_SUB);
const
	STOOP_DESCRIZIONE : array[STORE_OPERATION_TYPE] of string = ('assegna valore', 'somma', 'sottrai');
type
	standard_configuration_type = record
		str_nome : string{[50]};
		r_marg_sx_cm, r_marg_up_cm : misura_real_type;
		r_labsize_X_cm, r_labsize_Y_cm : misura_real_type;
		i_lab_per_row, i_lab_per_page : integer;						// numero di etichette in orizzaontale/verticale
		r_delta_labs_X_cm, r_delta_labs_Y_cm : misura_real_type	// spazio tra etichette contigue
	end;

type
	comportamento_when_null_type = (CWNT_REPORT_DEFAULT, CWNT_STANDARD, xCWNT_USE_VALUE, CWNT_BLANK);
const
	{$ifdef GALATEO_EXE} COMPORTAMENTO_NULL_DESCRIZIONE : array[comportamento_when_null_type] of string =
		('valore DEFAULT per il report', 'modalità STANDARD', 'usa valore assegnato', 'non stampare nulla'); {$endif}
	// tipi di oggetti cui si applica la gestione del COMPORTAMENTO_WHEN_NULL
	GESTIONE_NULL_TIPOVARS = [TV_DB_FIELD {TV_SQL_SELECT, TV_SQL_SELECT_BEFORE_SQL, TV_SQL_SELECT_BEFORE_RUNTIME}	{TV_GROUP_EXPR_SQL,}];
{$ifdef GALATEO_EXE}
	NULL_STANDARD_VALUES_NUMERICI = '0' + ACAPO +
		'####' + ACAPO +
		'(null)' + ACAPO +
		'(nessun valore)';
	NULL_STANDARD_VALUES_STRINGS = '####' + ACAPO +
		'(null)' + ACAPO +
		'(nessun valore)';
{$endif GALATEO_EXE}

	{$ifdef PROVA} *** 2016-08 in prospettiva eliminare; è utilizzato per indicare che il formato numerico non è stato applicato {$endif}
	xNUMERIC_NULL_VALUE : double = -3.14987654321;	// valore non inizializzato

const
	INI_BACKUP_SECTION = 'backup';
	INI_BACKUP_FILENAME = 'filename';
	INI_BACKUP_DIRECTORY = 'directory';
	STR_BACKUP_BAK_NAME = 'galateo.bak';
//	GALATEO_HELP_FILE = 'galateo.hlp';
	NUMERIC_FIELDS = [ftSmallint, ftInteger, ftWord, ftFloat, ftCurrency, ftBCD];
	TEXT_FIELDS = [ftString, ftMemo, ftTime, ftDateTime, ftDate];
	OTHER_FIELDS = [ftUnknown, ftBoolean, ftBytes, ftVarBytes, ftBlob, ftGraphic];

{$ifdef GALATEO_EXE}
	NUM_CONF_STANDARD = 2;
	CONFIGURAZIONI_STANDARD : array[0..NUM_CONF_STANDARD-1] of standard_configuration_type =
	 ((str_nome : 'foglio A4 24 etichette (8 per 3)';
			r_marg_sx_cm:0;r_marg_up_cm:0;r_labsize_X_cm:6.6;r_labsize_Y_cm:3.6;
			i_lab_per_row:3;i_lab_per_page :8;r_delta_labs_X_cm:0.2;r_delta_labs_Y_cm :0),
	  (str_nome : 'foglio A4 6 etichette (3 per 2)';
			r_marg_sx_cm:0;r_marg_up_cm:0;r_labsize_X_cm:9.8;r_labsize_Y_cm:9.4667;
			i_lab_per_row:2;i_lab_per_page:3;r_delta_labs_X_cm:0;r_delta_labs_Y_cm:0));
//	CONFIGURAZIONE_STD_A4 = 0;
{$endif}

	DEFAULT_PAGE_WIDTH_CM = 20;
	DEFAULT_PAGE_HEIGHT_CM = 28 ;			// dimensioni default del foglio
	DEFAULT_LABEL_WIDTH_CM = 10;
	DEFAULT_LABEL_HEIGHT_CM = 7 ;			// dimensioni default dell'etichetta

	ODBC_STANDARD_DRIVER_NAME = 'odbc_galateo';	// driver standard per odbc; MINUSCOLO!!!
	DB_GALATEO_NAME = 'db_galateo';	// nome dell'oggetto TFDatabase
	REPORT_DATABASENAME = 'db_report';	// nome del database da utilizzarsi in reporting

	MAX_ITERAZIONI = 12;				// numero max di iterazioni per il calcolo delle formule
	MAX_FORMULA_RICORSIONI = 12;	// numero max di chiamate ricorsive alla funzione che risolve le formule

//	LEN_RUBRICA_CODICE = 12;
	TBL_PREFIX_INVISIBILE = 'XXX';	// tutte le colonne il cui nome inizia con questo prefisso non sono visibili all'utente

	LARG_SIZE_AREA = 6;	// larghezza dell'area in cui compare la risizing arrow
//	TBL_RUBRICA_VIEW = 'rubrica'; // MINUSCOLO!!!

	LEN_RECORD_DESCR_RUNTIME = 24;	// lunghezza del nome del record che compare runtime all'utente in fase di stampa

	MAIN_SECTION = 1;	// sezione unica per le etichette
	MAIN_SECTION_ZB = 0;	// sezione unica per le etichette
	LEN_NOME_SEZIONE = 30;

	NUM_SQL_SEPARATORS = 11 + 4 + 1 + 1 + 1;
	SQL_SEPARATORS : array[1..NUM_SQL_SEPARATORS] of string =
		('<>', '>=', '<=', '!=', '==', '=', ' ', ')', '(', ',', ACAPO,
		 '-', '+', '*', '/', // '.',
		 '"',			// aggiunto 2005-05-04
		 '''',		// aggiunto 2005-06-15
		 '%');		// aggiunto 2006-06-14

	TBL_PROGRESSIVI_STAMPA = 'progressivi_stampa';
	TBL_PRS_STR_TIPO = 'PRS_str_tipo';
	TBL_PRS_I_ESERCIZIO = 'PRS_i_esercizio';
	TBL_PRS_I_PAGINA = 'PRS_i_pagina';
	TBL_PRS_DT_RIFERIMENTO = 'PRS_dt_riferimento';
	TBL_PRS_STR_ID_FIRST_RECORD = 'PRS_str_ID_first_record';
	TBL_PRS_STR_ID_LAST_RECORD = 'PRS_str_ID_last_record';
	TBL_PRS_STR_OPERATORE = 'PRS_str_operatore';
//	TBL_PRS_DT_CREAZIONE = 'PRS_dt_creazione';

	EXIT_WITHOUT_SAVING = 'Vuoi uscire senza salvare le modifiche?';
	CODICE_USATO_ALTROVE = 'Non è stato possibile eliminare il codice selezionato. Probabilmente è usato altrove';
	ERROR_SAVING = 'Errore durante il salvataggio delle modifiche';
	dsModifying = [dsInsert,dsEdit];

	// separatori utilizzati per formattare un testo su più righe
	PRE_SEPARATORI = ['(', '[', '{'];	// separatori che vanno a capo
	POST_SEPARATORI = [':', ';', '!', '?', '+', ')', ']', '}'
		,'-'		// 2009-02-25
	];	// separatori che stanno sulla stessa riga
type
//	str_sezione_nome_type = string[LEN_NOME_SEZIONE];
	pTrect = ^Trect;
	rnd_type = record
//		str_descr : string[26];
		str_descr : string;
		i_cifre : shortint
	end;

	// tipo di arrotondamento richiesto per la valuta selezionata
	round_valuta_type = (
		RNDV_FISSI,			// numero di decimali fissi per la valuta (EURO=2)
		RNDV_MAX,			// numero di decimali max (EURO=4)
		RNDV_CALCOLO,		// numero di decimali da utilizzarsi nei calcoli (come limite) (EURO=6)
		RNDV_SIGNIFICATIVI);	// viene garantito un minimo di decimali tale da avere valori significativi (ma non > MAX)
const
	round_valuta_descr : array[round_valuta_type] of string = (
		'decimali fissi', 'decimali max', 'decimali calcolo', 'decimali significativi');

const
	{$define NESSUNO}
{$ifdef REPORT_GENERATOR}
	{$ifndef NESSUNO} * * {$endif} {$undef NESSUNO}
	PRG_ASSOCIATO =
		{$ifdef JOLLY} 'JOLLY per Windows' {$endif}
		{$ifdef CASA_DLL} 'CASA.dll' {$endif}
	;
{$endif}
{$ifdef SCALVINA}
	{$undef NESSUNO}
	LOGO_NOME_1 = 'Elettronica Scalvina srl';
	LOGO_NOME_2 = 'Vertova (BG)';
{$endif}
	{$ifdef NESSUNO}  please, give me a customer! {$endif}

	LEN_DB_CAMPO = 32;
	LEN_DB_CODICE = 30;
	LEN_DB_ORDER_BY = LEN_DB_CAMPO*2;
	STRING_DB_TYPES = [ftMemo, ftString];	// tipi di dati 'STRINGA'
	NUMERIC_DB_TYPES = [ftSmallint, ftInteger, ftWord, ftFloat, ftCurrency, ftBCD];

	ODBC_FILE_INI = 'odbc.ini';
	ODBC_GALATEO_SECTION = 'GALATEO';
	ODBC_DATABASEFILE = 'DATABASE';
type
//	str_db_campo_type = string[LEN_DB_CAMPO];	{ fatta per contenere il nome di un campo di database }
//	str_db_codice_type = string[LEN_DB_CODICE];	{ fatta per contenere un codice }
//	str_db_order_by_type = string[LEN_DB_ORDER_BY];	{ fatta per contenere una condizione di ordinamento }

	azione_opening_report_type = (
		AORT_POPT_DEFAULT,	// usa le impostazioni default (e nel caso quelle passate dal programma che impartisce l'ordine di stampa)
		// opzioni seguenti: prescinde dalle impostazioni del programma chiamante
		AORT_FORZA_ANTEPRIMA,
		AORT_PRINT_PRINTER,				// stampa direttamente sulla stampante, previa richiesta di selezione stampante
		AORT_PRINT_PRINTER_DIRECT,		// stampa diretta senza nessuna richiesta, utilizzata anche per stampe multiple
		AORT_PDF,							// propone la creazione di un file PDF
		AORT_EMAIL,							// propone per default l'invio per mail; presuppone PDF
		AORT_PDF_DIRECT,
		AORT_EMAIL_DIRECT);
const
	AORT_PARAMETRO_BASE = '/I=';		// I come Interfaccia; da versione $0303 2011-10-05; esempio: /I=M per MAIL
	AORT_RUNTIME_PARMS : array[azione_opening_report_type] of string = (	// parametri utilizzabili a runtime
		'****',	// da non utilizzarsi
		'A',		//	'anteprima di stampa',
		'S',		//	'stampa diretta (con selezione stampante)',
		'D',		// 'stampa diretta (senza selezione stampante)',
		'PDF',	// 'creazione di file PDF',
		'M',		// 'invio via mail (file PDF)');
		'PDF+D',
		'M+D');
type
	azione_printer_unknown_type = (
		APUT_SELECT_NEW_PRINTER,
		APUT_ABORT,			// annulla la stampa
		APUT_USE_PRINTER_DEFAULT);
	azione_after_print_type = (
		AAPT_NOTHING,
		AAPT_ASK_AGAIN_DEFAULT_NOT,
		AAPT_ASK_AGAIN_DEFAULT_YES,
		AAPT_ASK_AGAIN_DEFAULT_LAST_TIME);
	default_printer_selection_type = (		// modalità di selezione della stampante predefinita
		DPST_SYSTEM_DEFAULT,						// usa la stampante predefinita di sistema
		DPST_LAST_USED,							// usa l'ultima stampante utilizzata; la prima volta utilizza la stampante predefinita
		DPST_RUNTIME_SELECTED,					// obbliga l'utente a scegliere la stampante a runtime
		DPST_GALATEO);								// utilizza la stampante impostata in galateo (salvata sul file)
	print_diretta_type = (		// impostazioni per la visualizzazione del dialog di selezione della stampante
		PDS_DIALOG,					// per default chiama sempre il DIALOG
		PDS_DIRETTA,				// per default esegue sempre la stampa diretta
		PDS_REPORT);				// utilizza le impostazioni indicare sul report

	printer_default_type = record
		str_printer : string;
		str_cassetto : string;
	end;
const
	NUMERO_DEFAULT_PRINTERS = 2;

{$ifdef GALATEO_EXE}
const
	AORT_OPZIONI_DESCRIZIONE : array[azione_opening_report_type] of string = (
		'applica impostazioni programma chiamante',
		'anteprima',
		'apre dialog di selezione stampante',
		'stampa diretta (non apre dialog selez.stamp.)',
		'crea file PDF',
		'invia per e-mail',
		'crea file PDF (senza conferma)',
		'invia per e-mail (senza conferma)');
	APUT_DESCRIZIONE : array[azione_printer_unknown_type] of string = (
		'consenti selezione stampante',		// APUT_SELECT_NEW_PRINTER
		'annulla la stampa', 					// APUT_ABORT
		'usa stampante predefinita');			// APUT_USE_PRINTER_DEFAULT
	AAPT_DESCRIZIONE : array[azione_after_print_type] of string = (
		'nessuna azione possibile',
		'consenti nuova esecuzione report (default NO)',
		'consenti nuova esecuzione report (default SI)',
		'consenti nuova esecuzione (default: come volta prec.)');
	DEFAULT_PRINTER_SELECTION_DESCRIZIONE : array[default_printer_selection_type] of string = (
		'stampante predefinita di sistema',				// DPST_SYSTEM_DEFAULT
		'ultima stampante utilizzata',					// DPST_LAST_USED
		'obbliga operatore a selezionare stampante',	// DPST_RUNTIME_SELECTED
		'usa stampante specificata');						// DPST_GALATEO
{$endif}

const
	RND_ROUND_FORMULA = -99;		// l'arrotondamento è indicato da una formula
	RND_NO_ROUND = -12;
	RND_UNITA_ROUND = 0;
	RND_NUMERO = 11;
	RND_VALUES : array[0..RND_NUMERO-1] of rnd_type =
		((str_descr:'nessun arrotondamento';i_cifre:RND_NO_ROUND),
		 (str_descr:'4 decimali';i_cifre:-4),
		 (str_descr:'3 decimali';i_cifre:-3),
		 (str_descr:'2 decimali';i_cifre:-2),
		 (str_descr:'1 decimale';i_cifre:-1),
		 (str_descr:'unità';i_cifre:0),
		 (str_descr:'alle decine';i_cifre:1),
		 (str_descr:'alle centinaia';i_cifre:2),
		 (str_descr:'alle migliaia';i_cifre:3),
		 (str_descr:'alle miriadi';i_cifre:4),
		 (str_descr:'alle centinaia di migliaia';i_cifre:5));
type
//	boolean_pointer = ^boolean;
//	integer_pointer = ^integer;
//	TTable_pointer = ^TTable;	{$ifndef DEBUG} * {$endif}
//	TFquery_pointer = ^TFquery;
	// generico vettore di puntatori
	ptr_array_type = array[1..16000] of pchar;
	ptr_array_punt = ^ptr_array_type;
const
	BORDO_DISEGNO_X_PIXEL = 30;
	BORDO_DISEGNO_Y_PIXEL = 15;
	START_OF_GALATEO_FILE = 'File formato GALATEO';
	END_OF_GALATEO_FILE = '*** fine del file GALATEO ***';
	FILE_INI = PROGRAM_NAME_BASE + '.INI';
	GALATEO_MBOX_CAPTION = PROGRAM_NAME;	// solo GALATEO, non vale per la DLL
	DEFAULT_EXT = '.GAL';
	FILES_FILTER = 'Files di Galateo (*' + DEFAULT_EXT + ')|*' + DEFAULT_EXT;
	BAK_EXT = '.~GAL';

	EXTERNAL_LP_EXT = '.GPL';
	EXTERNAL_LP_FILTER = 'Pagine Logiche di Galateo (*' + EXTERNAL_LP_EXT + ')|*' + EXTERNAL_LP_EXT;
	DEBUG_LOG_EXT = '.LOG';

	GALATEO_SQL_SCRIPT_FILE_EXT = '.GSQ';	// Galateo Scripts sQl
	GALATEO_MACRO_SCRIPT_FILE_EXT = '.GSM';	// Galateo Scripts Macro

	GALATEO_SQL_SCRIPT_FILE_FILTER = 'Files scripts SQL (*' + GALATEO_SQL_SCRIPT_FILE_EXT + ')|*' + GALATEO_SQL_SCRIPT_FILE_EXT;
	GALATEO_MACRO_SCRIPT_FILE_FILTER = 'Files macro (*' + GALATEO_MACRO_SCRIPT_FILE_EXT + ')|*' + GALATEO_MACRO_SCRIPT_FILE_EXT;

	EXTERNAL_SQL_SECTION_COMMAND_EXT = '.GSZ';		// salvataggio comando SQL sezioni
	EXTERNAL_SQL_SECTION_COMMAND_FILTER = 'Comandi SQL sezioni (*' + EXTERNAL_SQL_SECTION_COMMAND_EXT + ')|*' + EXTERNAL_SQL_SECTION_COMMAND_EXT;

//	JPG_EXT = '.jpg';
//	JPG_FILTER = 'Immagini JPG (*' + JPG_EXT + ')|*'+JPG_EXT;
//	JPG_DEFAULT_COMPRESSION_QUALITY = 90;
//	MIN_JPEG_PERCENTUALE = 5;
//	MAX_JPEG_PERCENTUALE = 500;

	INI_X_VIDEO_PROP = 'xprop';
	INI_Y_VIDEO_PROP = 'yprop';
	INI_MAGLIA_GRIGLIA_VTABS_DEFAULT = 8;
	INI_TOTAL_LABEL_PRINT = 'etichette stampate';
	INI_LAST_VALUES = 'last values';
	INI_LAST_FILENAME = 'filename';

	INI_DB_SECTION = 'database';
	INI_DB_NAME = 'nome database';

	DEFAULT_MINIMUM_SIZE_AUTO = 7;	// default dimensione minima di riduzione automatica del font
const
	DELIMITATORE_SPECIALE_PARMS = '\#';
	{ un parametro può essere compreso tra coppie di questa stringa, se deve
	  contenere caratteri speciali al suo interno;
	  ESEMPIO:   'DDT-SCA','DDT-SCAR'    -->		\#'DDT-SCA','DDT-SCAR'\# }

	NUM_OPERATORI_FORMULA_NUMERO = 4;
	OPERATORI_FORMULA_NUMERO_ARRAY : array[1..NUM_OPERATORI_FORMULA_NUMERO] of char = ('+', '/', '*', '-');
	NUM_OPERATORI_FORMULA_TESTO = 1;
	OPERATORI_FORMULA_TESTO_ARRAY : array[1..NUM_OPERATORI_FORMULA_TESTO] of char = ('+');
	VIRGOLETTA = '"';
	VIRGOLETTA_IN_TEXT = '\' + VIRGOLETTA;	// viene letto come 'VIRGOLETTA'
	VIRGOLETTA_IN_TEXT_INTERNAL_USE = #213 + #215 + #214;	// non deve contenere VIRGOLETTA -- uso esclusivamente interno
	PARENTESI = ['(',')'];
	NUM_OPERATORI_COMPARAZIONE = 7;
	OPERATORI_COMPARAZIONE : array[1..NUM_OPERATORI_COMPARAZIONE] of string = ('!=','<>','>=','<=','<','>','=');	// in fondo i caratteri semplici

	OP_OR = '||';
	OP_AND = '&&';
var
//	OPERATORI_FORMULA_NUMERO_SET, OPERATORI_FORMULA_TESTO_SET : set of char;
	OPERATORI_FORMULA_NUMERO_SET, OPERATORI_FORMULA_TESTO_SET : set of Ansichar;
	{$ifdef GALATEO_EXE} TSTR_DB_NAVIGATOR_HELPS : TStrings; {$endif}
	i_parm_filename : byte;
		{ 0 per nessuno, oppure il numero del parametro del file da aprire in avvio
		  impostato in PROC.READ_PARMS, usato in CONTROL }
//	strlst : shortstring;

type
	shift_formula_type = (SHFT_RELATIVE, SHFT_ABSOLUTE);		// modalità di applicazione delle formule di shiftamento posizionale
{$ifdef GALATEO_EXE}
	const	SHIFT_FORMULA_DESCRIZIONE : array[shift_formula_type] of string = ('relativo', 'assoluto');	// il soggetto sottinteso è 'spostamento': (spostamento) assoluto, (spostamento) relativo
{$endif}

{ definizione tipi di automatismi di movimento e di resizing disponibili per i
  vari tipi di oggetti }
{$ifdef GALATEO_EXE}
	type
		mr_types = (MR_MOVE, MR_RESIZE);	// Move and Resize types
		mr_set = set of mr_types;
	const
		MR_TESTI = [MR_MOVE];		// operazioni disponibili per i testi
		MR_BITMAPS = [MR_MOVE]; 	// operazioni disponibili per le bitmaps
		MR_CORNICI = [MR_MOVE,MR_RESIZE];	// operazioni disponibili per le cornici
		MR_DATAMATRIX = [MR_MOVE];		// operazioni disponibili per oggetti datamatrix
		MR_AVAILABLE : array[succ(low(obj_type))..pred(high(obj_type))] of mr_set =
//			(MR_TESTI, MR_TESTI, MR_TESTI, MR_BITMAPS, MR_CORNICI, MR_CORNICI);
			({LABEL_OBJ}MR_TESTI, {OBJ_BITMAP}MR_BITMAPS, {OBJ_RECT}MR_CORNICI, {OBJ_LINE}MR_CORNICI, {DATAMATRIX_OBJ}MR_DATAMATRIX);
{$endif}

const
	SFX : array[TFontStyle] of string = ({bold}'\\B', {italic}'\\I',{underline}'\\U',{striked}'\\X');
	SF_ON = '<';
	SF_OFF = '>';
{	funzionamento dei comandi SFX:
	ponendo il comando all'inizio di una variabile di tipo stringa, si attivano/disattivano le caratteristiche del font
		\\B<abc		mette abc in BOLD
		\\B>xyz		mette xyz in NO-BOLD }

type
	RTQ_type = (RTQ_TEXT, RTQ_SINGLE_SELECT, RTQ_MULTI_SELECT);	// modalità di richiesta dei parametri runtime
const
	RTQ_MULTI_SELECT_MAX_ITEMS = 12;
	RTQ_DESCRIZIONI : array[RTQ_type] of string = ('testo', 'single-select', 'multipla');

const
	DEFAULT_CURSOR_OBJECTS = crSize;
	// definizione parti di stile trasportabili da un oggetto all'altro
	STYLE_HEIGHT						= $0001;
	STYLE_WIDTH							= $0002;
	STYLE_SIZE							= STYLE_HEIGHT OR STYLE_WIDTH;	// dimensioni
	STYLE_FONT							= $0004;	// font utilizzato
	STYLE_FORMATTATION				= $0008;	// opzioni di formattazione
	STYLE_VALUES						= $0010;	// valore dei campi
	STYLE_FORMATO_NUMERICO			= $0020;	// formato numerico
	STYLE_LEGAMI_COMUNITARI			= $0040;	// formato numerico
	STYLE_VISUALIZZAZIONE			= $0080;	// modalità di visualizzazione
	STYLE_COLORE_SPESSORE_LINEA	= $0100;	// colore e spessore linee
	STYLE_SHIFT_POS					= $0200;	// impostazioni di spostamento
	STYLE_FONTSIZE						= $0400;	// dimensione font
	STYLE_FONTCOLOR					= $0800;	// dimensione font
	STYLE_FONTNAME						= $1000;	// nome font (Courier, Arial, ...)
	STYLE_ALL							= $FFFF;	// tutto, ma proprio tutto
	// stili applicabili ai diversi oggetti
	COMMON_STYLES = STYLE_SIZE OR STYLE_LEGAMI_COMUNITARI OR STYLE_VISUALIZZAZIONE OR STYLE_SHIFT_POS;
	LABEL_STYLES = COMMON_STYLES OR STYLE_FONT OR STYLE_FONTNAME OR STYLE_FONTSIZE OR STYLE_FONTCOLOR OR STYLE_FORMATTATION OR STYLE_VALUES OR STYLE_FORMATO_NUMERICO;
	DATAMATRIX_STYLES = COMMON_STYLES OR {STYLE_FORMATTATION OR }STYLE_VALUES;
	BMP_STYLES = COMMON_STYLES OR {STYLE_FORMATTATION OR }STYLE_VALUES;
	GRAPHIC_STYLES = COMMON_STYLES OR STYLE_FORMATTATION OR STYLE_COLORE_SPESSORE_LINEA;

const
	RUNTIME_UNASSIGNED_COLOR = MAXINT-1;

type
	cl_store_value = class
//{$ifdef DEBUG}	public {$else}	private {$endif}
		public
			str_name : string;
			bo_text : boolean;
			lp : pointer;
		public
			{$ifdef DEBUG}	constructor create; {$endif}
			destructor free;
			procedure set_value(str_name : string;s : string); overload;
			procedure set_value(str_name : string;fl : double;stoop : STORE_OPERATION_TYPE); overload;
			function get_value : string;
	end;

var
	tstr_temporary_filenames : TStrings;	// contenitore per i files temporanei

type
	cl_runtime_groupbox = class
		public
			{$ifdef GALATEO_EXE} lo_id : integer; {$endif}	// ID univoco del gruppo
			str_descrizione : string;
			i_parameter_window : smallint;				// numero della finestra di richiesta parametri (1-based)
			bo_ask_only_when_creating : boolean;		// gruppo di parms richiesto solo durante la creazione del report
			bo_ask_on_exit : boolean;						// il gruppo viene richiesto in fase di uscita da GALATEO
			lo_gruppo_text_color, lo_gruppo_back_color : TColor;
			lo_default_text_color, lo_default_back_color : TColor;
			constructor create{(i_first_variante : smallint)};
			destructor free;
			function get_color(lo_colore_variante : TColor;bo_text : boolean) : TColor;
			procedure read(var f : text;wo_versione : word);
			{$ifdef GALATEO_EXE} procedure write(var f : text); {$endif}
			procedure assign(source : cl_runtime_groupbox);
			function get_descrizione(i_pos : smallint = 0) : string;
		private
//			function read_from_text(handle : hwnd;s : string;bo_error_msg : boolean) : boolean;
			procedure reset;
	end;
	runtime_groupboxes_array = array of cl_runtime_groupbox;

implementation

uses galateo_debug, FDebug, FAssert, FXStrings, FStrings, FErrMsg, FRegistry, FSystem, FDB, FProcs
//	proc
{$if defined(GALATEO_EXE) or defined(CASA)}
//	,objects, misure, pages ,sezione,
	{$ifdef GALATEO_EXE} ,galateo_main {$endif}
{$endif};

{$ifdef DEBUG} var i_validazione, i_store_values, i_runtime_gboxes : integer; {$endif}

const
	HINT_HIDE_PAUSE = 12000;	// periodo di visibilità degli hints; round(PI*4k)

procedure application_system_formats;
begin
	fShortDateFormat := 'dd/MM/yy'
end;

procedure init;
begin
	set_application_system_formats(application_system_formats);

	OPERATORI_FORMULA_TESTO_SET := [];OPERATORI_FORMULA_NUMERO_SET := [];
	for var i : byte := 1 to NUM_OPERATORI_FORMULA_TESTO do OPERATORI_FORMULA_TESTO_SET := OPERATORI_FORMULA_TESTO_SET + [OPERATORI_FORMULA_TESTO_ARRAY[i]];
	for var i : byte := 1 to NUM_OPERATORI_FORMULA_NUMERO do OPERATORI_FORMULA_NUMERO_SET := OPERATORI_FORMULA_NUMERO_SET + [OPERATORI_FORMULA_NUMERO_ARRAY[i]];
	GH := 0;

{$ifdef GALATEO_EXE}
	TSTR_DB_NAVIGATOR_HELPS := TStringlist.Create;
	TSTR_DB_NAVIGATOR_HELPS.add('primo/a record');
	TSTR_DB_NAVIGATOR_HELPS.add('record precedente');
	TSTR_DB_NAVIGATOR_HELPS.add('record successivo/a');
	TSTR_DB_NAVIGATOR_HELPS.add('ultimo/a record');
	TSTR_DB_NAVIGATOR_HELPS.add('inserisci nuovo/a record');
	TSTR_DB_NAVIGATOR_HELPS.add('elimina record selezionato/a');
	TSTR_DB_NAVIGATOR_HELPS.add('modifica');
	TSTR_DB_NAVIGATOR_HELPS.add('conferma modifiche');
	TSTR_DB_NAVIGATOR_HELPS.add('annulla modifiche');
	TSTR_DB_NAVIGATOR_HELPS.add('aggiorna video')
{$endif}
end;

{procedure read_DLL_system_debug;
// legge il parametro che attiva il debug
var lo : integer;
begin
//	get_registry_boolean(HKEY_CURRENT_USER, xGALATEO_REGISTRY, GALRUNT_SYSTEM_DEBUG_KEY, bo_DLL_system_debug)
	if get_registry_integer(HKEY_CURRENT_USER, GALATEO_REGISTRY_BASE, GALRUNT_SYSTEM_DEBUG_KEY, lo) then i_DLL_system_debug_level := lo
end;}

function cl_computer_registry_data.read_registry_values : boolean;
// legge i valori dal registry; rende TRUE in caso di successo, FALSE altrimenti
var lo : integer;
begin
	result := FALSE;var reg : TFRegistry := NIL;
	// inizializzo i valori
	bo_exclude_runtime_message_computer := FALSE;
	i_DLL_system_debug_level := DLL_SYSTEM_DEBUG_DISATTIVO;
	{$ifndef DLL} str_galrun_path := ''; {$endif}
	lo_hidden_objects_color := DEFAULT_COLOR_HIDDEN_OBJECTS;

	try
		reg := TFregistry.create(REGISTRY_GLOBAL_ARGOMENTO, {can_initialize_registry}FALSE, HKEY_CURRENT_USER, {bo_readonly}TRUE);
		if (reg = NIL) then exit;
//		{$ifndef DLL} reg.IO_string(TRUE, 10, str_galrun_path); {$endif}	//		was		GALRUNT_PATH_REGISTRY_ITEM = 'galrun';
		{$ifndef DLL} reg.IO_string(TRUE, 19, str_galrun_path); {$endif}	// per la versione DX uso una posizione differente da D6, per avere due impostazioni differenti
		reg.IO_boolean({read}TRUE, 11, bo_exclude_runtime_message_computer);
		reg.IO_integer(TRUE, 12, i_DLL_system_debug_level);
		reg.IO_integer(TRUE, 21, lo);
		if (lo_hidden_objects_color <> 0) then lo_hidden_objects_color := lo;
		reg.IO_integer(TRUE, 22, lo);RDEBUG_mode := (RDEBUG_MODE_type(lo));
		reg.IO_integer(TRUE, 23, lo);debug_target:= (GALATEO_debug_target_type(lo));
		result := TRUE
	except
	end;
	if (reg <> NIL) then reg.free
end;

{$ifdef GALATEO_EXE}
	function cl_computer_registry_data.write_registry_values : boolean;
	// salva i valori sul registry; rende TRUE in caso di successo, FALSE altrimenti
	begin
		result := FALSE;var reg : TFRegistry := NIL;
		try
			reg := TFregistry.create(REGISTRY_GLOBAL_ARGOMENTO, {can_initialize_registry}TRUE, HKEY_CURRENT_USER, {bo_readonly}FALSE);
			if (reg = NIL) then exit;
//			reg.IO_string(FALSE, 10, str_galrun_path);
			reg.IO_string(FALSE, 19, str_galrun_path);	// per la versione DX uso una posizione differente da D6, per avere due impostazioni differenti
			reg.IO_boolean({bo_read}FALSE, 11, bo_exclude_runtime_message_computer);
			reg.IO_integer(FALSE, 12, i_DLL_system_debug_level);
			reg.IO_integer(FALSE, 21, integer(lo_hidden_objects_color));
			reg.IO_integer(FALSE, 22, byte(RDEBUG_mode));
			reg.IO_integer(FALSE, 23, byte(debug_target));
			result := TRUE
		finally
			if (reg <> NIL) then reg.free
		end
	end;

{$endif GALATEO_EXE}

// ----- cl_validazione ---------------------------------------

const
	START_OF_VALIDATION = '|sv'#126;
	END_OF_VALIDATION = #126'ev|';
	VALIDAZIONE_LENGTH_STRINGS_SIZE = 4;		// 4 caratteri (in decimale) come lunghezza max della stringa = 9999

constructor cl_validazione.create;
begin
	{$ifdef DEBUG} inc(i_validazione); {$endif}
	clear
end;

procedure cl_validazione.clear;
begin
	bo_attivo := FALSE;byte(tipo) := 0;bo_pre_SQL := FALSE;
	str_formula := '';str_message := '';str_descrizione_field := '';
	bo_bloccante := FALSE;str_condizione_bloccante_aggiuntiva := '';
	contexts_attivo := VALIDAZIONE_ALL_STANDARD_CONTEXTS;contexts_bloccante := VALIDAZIONE_ALL_STANDARD_CONTEXTS
end;

{$ifdef DEBUG}
	destructor cl_validazione.free;
	begin
		dec(i_validazione)
	end;
{$endif}

function cl_validazione.get_asstring(wo_versione : word;var s : string) : boolean;
// legge SELF dalla stringa S ed elimina la parte letta; rende TRUE in caso lettura eseguita con successo, FALSE se non fa nulla

	function get_bool(var s : string) : boolean; begin result := boolean(strToInt(extract_string(s, 1))) end;

	function get_contexts(s : string) : validazione_context_set;
	begin
		var wo : word := str2hex(s);
		if (wo = 0) then result := VALIDAZIONE_ALL_STANDARD_CONTEXTS
		else begin
			result := [];
			if (wo_versione <= $040A) then wo := wo * 4;	// sono stati aggiunti i due valori VCTXT_CHECK_PARMS e VCTXT_AFTER_RUNTIME
			for var vx : validazione_context_type := low(vx) to high(vx) do
				if (round(power(2, byte(vx))) AND wo <> 0) then result := result + [vx]
		end
	end;

	function get_string(var s : string) : string;
	begin
		var lo : integer := strToInt(copy(s, 1, VALIDAZIONE_LENGTH_STRINGS_SIZE));
		result := readln_LPSTR(copy(s, VALIDAZIONE_LENGTH_STRINGS_SIZE+1, lo));
		delete(s, 1, lo + VALIDAZIONE_LENGTH_STRINGS_SIZE)
	end;

begin	// get_asstring()
	result := FALSE;
	if (s = END_OF_VALIDATION) then begin result := TRUE;clear;exit end;

	if NOT start_with(s, START_OF_VALIDATION) then exit;
	var i : smallint := pos(END_OF_VALIDATION, s);if (i = 0) then exit;
	var str_temp := copy(s, 1, i + length(END_OF_VALIDATION) - 1);

	try
		clear;
		extract_string(str_temp, length(START_OF_VALIDATION));		// elimino il marcatore di inizio
		bo_attivo := get_bool(str_temp);
		tipo := validazione_type(strToInt(extract_string(str_temp, 2)));
		bo_bloccante := get_bool(str_temp);
		contexts_attivo := get_contexts(extract_string(str_temp, 2));
		contexts_bloccante := get_contexts(extract_string(str_temp, 2));
		bo_pre_SQL := get_bool(str_temp);

		delete(str_temp, 1, 3);	// spazio vuoto per future implementazioni
		str_formula := get_string(str_temp);
		str_message := get_string(str_temp);
		str_descrizione_field := get_string(str_temp);
		str_condizione_bloccante_aggiuntiva := get_string(str_temp);
		get_string(str_temp);		// campo per il momento non usato
		delete(str_temp, 1, 4);

		result := (str_temp = END_OF_VALIDATION);
		if result then delete(s, 1, i-1) else clear
	except
		clear
	end
end;

{$ifdef GALATEO_EXE}

procedure cl_validazione.assign(source : cl_validazione);
begin
	bo_attivo := source.bo_attivo;
	tipo := source.tipo;
	bo_pre_SQL := source.bo_pre_SQL;
	str_formula := source.str_formula;
	str_message := source.str_message;
	str_descrizione_field := source.str_descrizione_field;
	str_condizione_bloccante_aggiuntiva := source.str_condizione_bloccante_aggiuntiva;
	bo_bloccante := source.bo_bloccante;
	contexts_attivo := source.contexts_attivo;
	contexts_bloccante := source.contexts_bloccante
end;

function cl_validazione.AsString : string;

	function contexts_asstring(ctxs : validazione_context_set) : string;
	begin
		var wo : word := 0;
		if (ctxs <> VALIDAZIONE_ALL_STANDARD_CONTEXTS) then
			for var vx := low(validazione_context_type) to high(validazione_context_type) do
				if (vx in ctxs) then inc(wo, round(power(2, byte(vx))));
		result := stri_hex(wo, 2)
	end;

	function write_string(s : string) : string; begin result := zeri(length(writeln_LPSTR(s)), VALIDAZIONE_LENGTH_STRINGS_SIZE) + writeln_LPSTR(s) end;

	function blank : boolean;		// rende TRUE se la struttura è completamente prima di valori significativi (non è sufficiente che sia NON ATTIVA)
	begin
		result := NOT bo_attivo AND (str_formula + str_message + str_condizione_bloccante_aggiuntiva = '')
	end;

begin
	if blank then result := END_OF_VALIDATION		// inutile sprecare spazio per scrivere cose insensate
	else result := START_OF_VALIDATION +
		byte(bo_attivo).ToString + zeri(byte(tipo), 2) + byte(bo_bloccante).ToString +	// sembrerebbe sbagliato il modo di scrivere, per il momento lo lascio com'è (2022-10-25)
		contexts_asstring(contexts_attivo) +
		contexts_asstring(contexts_bloccante) +
		byte(bo_pre_SQL).ToString +
		'000' +			// spazio libero per future implementazioni
		write_string(str_formula) +
		write_string(str_message) +
		write_string(str_descrizione_field) +
		write_string(str_condizione_bloccante_aggiuntiva) +
		write_string('') +	// freedom!
		'0000' + END_OF_VALIDATION
end;

function cl_validazione.get_check_always_standard(bo_bloccante : boolean) : boolean;
var ctxs : validazione_context_set;
begin
	if bo_bloccante then ctxs := contexts_bloccante else ctxs := contexts_attivo;
	result := (ctxs = VALIDAZIONE_ALL_STANDARD_CONTEXTS)
end;

{$endif GALATEO_EXE}

// cl_runtime_groupbox ---------------------------------------------------------

constructor cl_runtime_groupbox.create;
begin
	{$ifdef DEBUG} inc(i_runtime_gboxes); {$endif}
	{$ifdef GALATEO_EXE} lo_id := random(1000000000); {$endif}
	reset
end;

destructor cl_runtime_groupbox.free;
begin
	{$ifdef DEBUG} dec(i_runtime_gboxes) {$endif}
end;

function cl_runtime_groupbox.get_color(lo_colore_variante: TColor;bo_text: boolean): TColor;
// rende il colore default per la variante tipica; LO_COLORE_VARIANTE è il colore default specifico per la variante in discussione
begin
	if (lo_colore_variante = RUNTIME_UNASSIGNED_COLOR) then result := ifi(bo_text,lo_default_text_color,lo_default_back_color)
	else result := lo_colore_variante
end;

procedure cl_runtime_groupbox.reset;
begin
	str_descrizione := '';i_parameter_window := 1;bo_ask_on_exit := FALSE;bo_ask_only_when_creating := FALSE;
	lo_gruppo_text_color := RUNTIME_UNASSIGNED_COLOR;lo_gruppo_back_color := RUNTIME_UNASSIGNED_COLOR;
	lo_default_text_color := RUNTIME_UNASSIGNED_COLOR;lo_default_back_color := RUNTIME_UNASSIGNED_COLOR
end;

procedure cl_runtime_groupbox.assign(source: cl_runtime_groupbox);
begin
	{$ifdef GALATEO_EXE} lo_id := source.lo_id; {$endif}
	str_descrizione := source.str_descrizione;
	i_parameter_window := source.i_parameter_window;
	bo_ask_on_exit := source.bo_ask_on_exit;
	bo_ask_only_when_creating := source.bo_ask_only_when_creating;
	lo_gruppo_text_color := source.lo_gruppo_text_color;
	lo_gruppo_back_color := source.lo_gruppo_back_color;
	lo_default_text_color := source.lo_default_text_color;
	lo_default_back_color := source.lo_default_back_color
end;

function cl_runtime_groupbox.get_descrizione(i_pos : smallint = 0): string;
// rende una descrizione complessiva per l'oggetto; i_pos è la posizione del gruppo; se ZERO viene ignorata
begin
	result := ifs(i_pos > 0,'[' + zeri(i_pos,2) + '] ') +
		ifs(str_descrizione,str_descrizione,'(senza descrizione)') +
		ifs(bo_ask_only_when_creating, ' [when creating]') +
		ifs(bo_ask_on_exit,' [on exit]')
end;

procedure cl_runtime_groupbox.read(var f: text; wo_versione: word);
begin
	readln(f,str_descrizione);
	readln(f,lo_gruppo_text_color, lo_gruppo_back_color, lo_default_text_color, lo_default_back_color);
	if (wo_versione <= $0244) then begin
		i_parameter_window := 1;bo_ask_on_exit := FALSE;bo_ask_only_when_creating := FALSE
	end
	else begin
		readln(f, i_parameter_window, byte(bo_ask_on_exit), byte(bo_ask_only_when_creating));
		readln(f);readln(f);readln(f);readln(f)
	end
end;

{$ifdef GALATEO_EXE}
	procedure cl_runtime_groupbox.write(var f : text);
	begin
		writeln(f, str_descrizione);
		writeln(f, lo_gruppo_text_color, ' ', lo_gruppo_back_color, ' ', lo_default_text_color, ' ', lo_default_back_color);
		writeln(f, i_parameter_window, byte(bo_ask_on_exit):2, byte(bo_ask_only_when_creating):2, ' 0 0 0 ababababababab 0 0 0');
		for var i : smallint := 1 to 4 do writeln(f)
	end;
{$endif}

// ----- cl_store_value --------------------------------------------------------

{$ifdef DEBUG}
	constructor cl_store_value.create;
	begin
		inc(i_store_values)
	end;
{$endif}

destructor cl_store_value.free;
begin
	{$ifdef DEBUG} dec(i_store_values); {$endif}
	if (lp <> NIL) then dispose(lp)
end;

function cl_store_value.get_value : string;
begin
	if bo_text then result := string(lp^)
	else result := floattostr(double(lp^))
end;

procedure cl_store_value.set_value(str_name, s : string);
var lps : ^string;
begin
//	{$ifdef DEBUG} assert(globale.fase_stampa = FASE_STAMPA_ASSEGNAZIONE_STORED_VALUES,'must be FASE_STAMPA_ASSEGNAZIONE_STORED_VALUES -- JHMQ 9292'); {$endif}
	self.str_name := str_name;
	if (lp <> NIL) then dispose(lp);
	new(lps);lp := lps;
	bo_text := TRUE;
	lps^ := s
end;

procedure cl_store_value.set_value(str_name: string; fl: double;stoop : STORE_OPERATION_TYPE);
var lpd : ^double;
begin
//	{$ifdef DEBUG} assert(globale.fase_stampa = FASE_STAMPA_ASSEGNAZIONE_STORED_VALUES,'must be FASE_STAMPA_ASSEGNAZIONE_STORED_VALUES -- JHMQ 9293'); {$endif}
{	self.str_name := str_name;
	if (lp <> NIL) then dispose(lp);
	new(lpd);lp := lpd;
	bo_text := FALSE;
	lpd^ := fl }
	self.str_name := str_name;
	if (lp <> NIL) AND bo_text then begin dispose(lp);lp := NIL end;
	if (lp = NIL) then begin new(lpd);lp := lpd;lpd^ := 0 end else lpd := lp;
	case stoop of
		STOOP_SET : lpd^ := fl;
		STOOP_ADD : lpd^ := lpd^ + fl;
		STOOP_SUB : lpd^ := lpd^ - fl
	end;
	bo_text := FALSE
end;

procedure delete_temporary_files;
begin
	for var i : smallint := 0 to tstr_temporary_filenames.Count-1 do
		try DeleteFile(tstr_temporary_filenames[i]) except end
end;

{$ifdef GALATEO_EXE}
procedure set_global_modified(bo : boolean = TRUE);		// pessima modalità di assegnare lo stato di modifica del report; causato da motivi storici
begin
	GM.bo_modified := bo
end;
{$endif GALATEO_EXE}

var i_chiamate_DLL : integer;

procedure GALATEO_init_WPDF_DLL;	// inizializza la DLL WPDF
{	wPDF 2 Standard:	WPDF_Start('Federico Callioni','A1aadam45ra_9g4grr7k');
	wPDF 4 Standard:	WPDF_Start(Federico Callioni,5B169857#91DE80BA@A6793807); }
const
//	WPDF licence: User Name: Federico Callioni - Password : RNZY-AKSN-W2U4-9HLP
//	chiamare		WPDF_Start('Federico Callioni','A1aadam45ra_9g4grr7k');
//	LICENCE_NAME_CRYPTED = '(ÇlëWOohlAX1™¦¾™¢';				// Federico Callioni (D6)
	LICENCE_NAME_CRYPTED = 'ĨÇlëŗŏoŨlŁŘı'#$0099'¦¾'#$0099'¢'; // Federico Callioni
//	LICENCE_CODE_CRYPTED_v02 = '#“içIGy-pX$f¤ƒ’«b'#$17'Ç';	// A1aadam45ra_9g4grr7k
	LICENCE_CODE_CRYPTED_v04 = 'ė¤9¼ĞĞAİoķĨĉru'#$7F'mzİġ'#$0092'iÙ'#$0082'ÃÊâ';	// 5B169857#91DE80BA@A6793807
	CRYPT_CODE = -77;
begin
	inc(i_chiamate_DLL);
	if (i_chiamate_DLL = 1) {AND bo_PDF_allowed} then begin
//		WPDF_Start(AnsiString(crypt(LICENCE_NAME_CRYPTED, CRYPT_CODE)), AnsiString(crypt(LICENCE_CODE_CRYPTED, CRYPT_CODE)));	// licenza per il wPDF
//		WPDF_Start('Federico Callioni', '5B169857#91DE80BA@A6793807')
		WPDF_Start(AnsiString(crypt(LICENCE_NAME_CRYPTED, CRYPT_CODE)), AnsiString(crypt(LICENCE_CODE_CRYPTED_V04, CRYPT_CODE)))
	end
end;

function cl_computer_registry_data.get_system_debug_mode : word;
begin
	result := 0;
	var bo_system_debug := (i_DLL_system_debug_level <> DLL_SYSTEM_DEBUG_DISATTIVO);
	if NOT bo_system_debug then exit;
	if (debug_target in [DEBUG_TARG_FILE, DEBUG_TARG_BOTH]) then result := result OR DEBUG_TARGET_LOCAL_FILE;
	if (debug_target in [DEBUG_TARG_CONSOLE, DEBUG_TARG_BOTH]) then result := result OR DEBUG_TARGET_RUNTIME;
	if (i_DLL_system_debug_level = DLL_SYSTEM_DEBUG_DETTAGLIATO) then result := result OR DEBUG_DETTAGLIATO
end;

initialization
	tstr_temporary_filenames := TStringList.create;
	computer_registry_data := cl_computer_registry_data.create;
	computer_registry_data.read_registry_values;
	galateo_initialization_debug('dich');
	registry_SMTP := cl_SMTP.create(TRUE, REGISTRY_SMTP_ARGOMENTO, PROGRAM_NAME);
	{$ifdef CASA} work_SMTP := cl_SMTP.create(registry_SMTP); {$endif}
	static_outlook := cl_outlook.create(TRUE, REGISTRY_OUTLOOK_ARGOMENTO, PROGRAM_NAME);
	application.HintHidePause := HINT_HIDE_PAUSE;	// quanti ms rimane attiva la finestrella degli hints
	// inizializzazione variabili di FDB
	FDB_DEFAULT_USER_NAME := 'jop';FDB_DEFAULT_PASSWORD := 'jpw';
	FDB_DEFAULT_DBSERVERNAME := 'jolly';FDB_DEFAULT_DATABASENAME := 'jolly';
{$ifndef DLL}
	bo_PDF_allowed := TRUE;str_author := '* Galateo *';
//	read_DLL_system_debug;		// se DLL viene letto sulla unit CASA (origine del programma)
{$endif}
	init
finalization
	galateo_finalization_debug('dich');
	delete_temporary_files;
	if (registry_SMTP <> NIL) then registry_SMTP.free;
	{$ifdef CASA} if (work_SMTP <> NIL) then work_SMTP.free; {$endif}
	if (static_outlook <> NIL) then static_outlook.free;
{$ifdef DEBUG}
	CCI(i_store_values, 'cl_store_value', 'gdich.pas');
	CCI(i_runtime_gboxes, 'cl_runtime_groupbox', 'gdich.pas');
	CCI(i_validazione, 'cl_validazione', 'gdich.pas');
{$endif}
end.
