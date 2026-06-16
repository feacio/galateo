// elenco delle opzioni disponibili per la DLL -- incluso by DICH.PAS
const
	GALATEO_EXT = '.gal';
	GALATEO_FILES_FILTER = 'Files Galateo (*' + GALATEO_EXT + ')|*' + GALATEO_EXT;

	PRINT_URLS_HINTS = 'specificare eventuali LINKS e URLs utili all''utente come riferimento in fase di stampa' + ACAPO2 +
		'FORMATO: un link per riga' + ACAPO2 +
		'è possibile aggiungere una descrizione ad ogni link con la seguente sintassi:  DESCRIZIONE <LINK>' + ACAPO +
		'esempio:' + ACAPO +
		'RIFERIMENTO NORMATIVO <www.fatturapa.gov.it>';

	// nome per il visualizzatore degli eventi; per le chiamate eseguite sulla DLL vale questa impostazione
{$ifdef DLL}
	CASA_EVENTLOG_PROGRAM_NAME = 'CASA [Galateo]';
{$else}
//	GALATEO_EVENTLOG_PROGRAM_NAME = 'GALATEO';				********** EVENTLOG gestito da CASA.DLL
	// sotto W10 e successivi eventuali errori derivano dalla mancanza dei diritti di amministrazione
	GALRUN_EVENTLOG_PROGRAM_NAME = 'Galateo''s runtime';	// EVENTLOG gestito da CASA.DLL, questo serve solo per eventuali errori nei parametri di chiamata
{$endif}

	// personalizzazione a runtime di alcuni specifici campi dei reports

	GAL_CUSTOM_PARM_AVVISO = ACAPO2 + 'il report deve essere stato predisposto per accettare questi parametri';
	GAL_CUSTOM_CAPTION_00_PARM = 'PARM_CUSTOM_CAPTION_00';
	GAL_CUSTOM_FOOTER_00_PARM = 'PARM_CUSTOM_FOOTER_00';
	GAL_CUSTOM_CAPTION_00_PARM_HINT = 'Personalizzazione del TITOLO in fase di stampa' + ACAPO2 +
		'Assegna il valore del parametro <' + GAL_CUSTOM_CAPTION_00_PARM + '>' + GAL_CUSTOM_PARM_AVVISO;
	GAL_CUSTOM_FOOTER_00_PARM_HINT = 'Personalizzazione del FONDO PAGINA in fase di stampa' + ACAPO2 +
		'Assegna il valore del parametro <' + GAL_CUSTOM_FOOTER_00_PARM + '>' + GAL_CUSTOM_PARM_AVVISO;

	// nomi standard di parametri standard per Galateo
	GALATEO_PARM_LO_KEY = 'PARM_lo_key';
	GALATEO_PARM_LO_KEYS = 'PARM_lo_keys';
	GALATEO_PARM_FATTURA_ELETTRONICA = 'PARM_FATTURA_ELETTRONICA';		// viene impostato a T quando la stampa avviene da fatturazione elettronica (esclude la richiesta di parametri)
	GALATEO_PARM_LO_KEY_PRINT = 'PARM_LO_KEY_PRINT';
	GALATEO_PARM_SESSIONE = 'PARM_SESSIONE';
	GALATEO_PARM_FILENAME = 'PARM_FILENAME';			// ??? a cosa serve di preciso ??? forse è un sinonimo di GALATEO_PARM_EXPORT_FILENAME
	GALATEO_PARM_EXPORT_FILENAME = 'PARM_EXPORT_FILENAME';
	GALATEO_PARM_LO_KEY_SESSIONE = 'PARM_lo_key_sessione';
	GALATEO_PARM_LO_KEY_DETAIL = 'PARM_lo_key_detail';
	GALATEO_PARM_STR_CODICE = 'PARM_str_codice';		// singolo codice
	GALATEO_PARM_STR_CODICI = 'PARM_str_codici';		// più codici
	GALATEO_PARM_SELECT = 'PARM_select';
	GALATEO_PARM_VIEW = 'PARM_view';					// vista che esegue la pre-selezione dei dati interessanti
	GALATEO_PARM_WHERE_VIEW = 'PARM_WHERE_view';	// where aggiuntiva alla PARM_VIEW; serve ad esempio per stampare i soli records selezionati
	GALATEO_PARM_TABLES = 'PARM_tables';
	GALATEO_PARM_ALL_CODES = 'PARM_ALL_codes';
	GALATEO_PARM_QUERY = 'PARM_query';				// intera query

	GALATEO_PARM_DT_FROM_DEFAULT = 'PARM_DT_FROM_DEFAULT';
	GALATEO_PARM_DT_TO_DEFAULT = 'PARM_DT_TO_DEFAULT';

	GALATEO_PARM_WHERE = 'PARM_where';					// non specificato se CON/SENZA clausola (WITH or WITHOUT)
	GALATEO_PARM_WHERE_WITHOUT = 'PARM_where';		// tipicamente: comprensiva della clausola WHERE -- il parametro passato deve essere del tipo "(A > B)" (senza clausola
	GALATEO_PARM_WHERE_WITH = 'PARM_where';			// tipicamente: comprensiva della clausola WHERE -- il parametro passato deve essere del tipo "WHERE (A > B)"

	GALATEO_PARM_ORDER_BY = 'PARM_order_by';		// tipicamente: comprensiva della clausola ORDER BY
	GALATEO_PARM_GROUP_BY = 'PARM_group_by';		// tipicamente: comprensiva della clausola GROUP BY
	GALATEO_PARM_TOTALE = 'PARM_TOTALE';
	GALATEO_PARM_CAPTION = 'PARM_caption';				// titolo generico ma fisso per la stampa (tipicamente di sistema)
	GALATEO_PARM_DESCRIZIONE = 'PARM_DESCRIZIONE';	// descrizione della stampa (tipicamente a discrezione utente)
	GALATEO_PARM_TABLE = 'PARM_table';					// nome della table da utilizzare per la stampa
	GALATEO_PARM_VALUTA = 'PARM_VALUTA';
	GAL_PARM_IMAGE_PATH = 'PARM_IMAGE_PATH';
	GALATEO_PARM_MAGAZZINI = 'PARM_MAGAZZINI';

	GALATEO_PARM_DT_SQL = 'PARM_DT_SQL';				// data unica, in formato SQL
	GALATEO_PARM_DT_FROM_SQL = 'PARM_DT_FROM_SQL';
	GALATEO_PARM_DT_TO_SQL = 'PARM_DT_TO_SQL';
	GALATEO_PARM_DT_FROM = 'PARM_DT_FROM';
	GALATEO_PARM_DT_TO = 'PARM_DT_TO';

	GALATEO_PARM_LIVELLO_DETTAGLIO_SINTETIC	= -1;
	GALATEO_PARM_LIVELLO_DETTAGLIO_NORMAL		=  0;
	GALATEO_PARM_LIVELLO_DETTAGLIO_FULL			= +1;
	GALATEO_PARM_LIVELLO_DETTAGLIO = 'PARM_LIVELLO_DETTAGLIO';		// se definito, può essere utilizzato nel report in base all'impostazione eseguita nel software

	GAL_OPERATORE_CODICE = 'PARM_OPERATORE_CODICE';
	GAL_OPERATORE_NOME_COMPLETO = 'PARM_OPERATORE_NOME_COMPLETO';
	GAL_OPERATORE_SIGLA = 'PARM_OPERATORE_SIGLA';
	GAL_OPERATORE_LOGO = 'PARM_OPERATORE_LOGO';
	GAL_OPERATORE_WORKSTATION = 'PARM_WORKSTATION';
	JOLLY_PRINT_DEFAULT_LOGO = 'PARM_DEFAULT_LOGO_GRAFICO';

	GAL_POPT_PRINT_ANTEPRIMA = 1;			// default
	GAL_POPT_PRINT_PRINTER = 2;			// stampa direttamente sulla stampante, previa richiesta di selezione stampante
	GAL_POPT_DIRECTLY_EXECUTE = 4;		// stampa diretta senza nessuna richiesta, utilizzata anche per stampe multiple
	GAL_POPT_PDF = 8;							// propone la creazione di un file PDF
	GAL_POPT_EMAIL = 16;						// propone per default l'invio per mail; presuppone ed implica PDF
	GAL_POPT_SILENT = 32;					// report eseguito in modalità SILENZIOSA -- come GAL_POPT_DIRECTLY_EXECUTE ma più strong (usare INSIEME a GAL_POPT_DIRECTLY_EXECUTE e/o altri flags)
	GAL_POPT_TEMPORARY_PATH = 2048;		// la stampa viene creata su un percorso temporaneo
	// il seguente valore è ANOMALO: se attivato il programma chiamante forza GALATEO ad applicare l'indicazione trasmessa (anzichè quella registrata sul report)
	GAL_POPT_FORZA_IMPOSTAZIONI_PROGRAMMA_CHIAMANTE = 128;

	// azioni eseguite dopo la stampa (vedi EFAT_xxxx su DICH)
	GAL_POPT_EFAT_NOTHING = 256;
	GAL_POPT_EFAT_CREATE = GAL_POPT_EFAT_NOTHING;	// sono sinonimi
	GAL_POPT_EFAT_FOLDER = 512;
	GAL_POPT_EFAT_CREATE_OPEN = 1024;
	GAL_POPT_SUCCESS_AFTER_PRINT = 0;	// (0 = DEFAULT): la funzione di stampa rende TRUE solo dopo aver eseguito una stampa effettiva (printer, PDF, mail, ...)
	GAL_POPT_SUCCESS_ON_ANTEPRIMA = 2048;	// la funzione di stampa (GAL_OPEN_AND_PRINT and varianti) rende TRUE anche solo dopo aver aperto l'anteprima; di norma rende TRUE solo dopo aver eseguito una stampa effettiva (printer, PDF, mail, ...)

	GAL_DIRECT_PRINT_BASE = GAL_POPT_FORZA_IMPOSTAZIONI_PROGRAMMA_CHIAMANTE OR GAL_POPT_DIRECTLY_EXECUTE;
	GAL_DIRECT_PRINT = GAL_DIRECT_PRINT_BASE OR GAL_POPT_PRINT_PRINTER;		// esegue la stampa diretta, senza domandare alcunchè
	GAL_DIRECT_PDF = GAL_DIRECT_PRINT_BASE OR GAL_POPT_PDF;			// esegue la stampa diretta su PDF, senza domandare alcunchè
//	GAL_DIRECT_MAIL = GAL_DIRECT_PRINT_BASE OR GAL_POPT_EMAIL;		// esegue la spedizione diretta per mail, senza domandare alcunchè

	GAL_POPT_NUMERO = 5;
	GAL_POPT_DESCRIZIONE : array[0..GAL_POPT_NUMERO-1] of string = (
		'anteprima di stampa',
		'stampa diretta (con selezione stampante)',
		'stampa diretta (senza selezione stampante)',
		'creazione di file PDF',
		'invio via mail (file PDF)');
	GAL_POPT_VALUES : array[0..GAL_POPT_NUMERO-1] of smallint = (
		GAL_POPT_PRINT_ANTEPRIMA,
		GAL_POPT_PRINT_PRINTER,
		GAL_POPT_DIRECTLY_EXECUTE,
		GAL_POPT_PDF,
		GAL_POPT_EMAIL);

	// opzioni per le sezioni  (usare GAL_set_option())
	GAL_OPT_STAMPA_ANCHE_SE_VUOTA = 1;
	GAL_OPT_STAMPA_SENZA_DATI = 2;
	GAL_OPT_DONT_PRINT_SECTION = 3;		// se applicata alla sezione principale di una pagina, la pagina non viene stampata
	GAL_OPT_PAGE_WIDTH_MM = 4;
//	GAL_OPT_SECTION_HEIGHT_MM = 4;

	// ------- GAL_set_global_option() --------------------------------
	// SMTP - parametri di systema
	GAL_MODALITA_MAIL_CALLING_PROGRAM = 1300;	// indicazione della modalità di invio mail richiesta dal programma chiamante -- non è vincolante, ma dipende dalle impostazioni di GALATEO
	GAL_FORZA_MODALITA_MAIL_GALATEO = 1301;	// forzatura del valore MODALITA_MAIL_TYPE di GALATEO
		{ GAL_SMTP_FORZA_MODALITA_GALATEO -- di norma questo parametro NON è da utilizzare, perchè è assolutamente vincolante
		  la modalità dovrebbe essere definita all'interno del report, non sull'applicazione client
		  l'unica seria eccezione è rappresentata da GALRUN che può essere configurato attraverso i parametri runtime
		  oppure da applicazioni che forzano l'applicazione di una modalità definita sul report (esempio: JOLLY_SERVICES) }
	GAL_SMTP_CONFIGURATION_DATA = 1302;
	GAL_OUTLOOK_CONFIGURATION_DATA = 1303;
//	GAL_SMTP_DESCRIZIONE_MITTENTE = 1303;		// descrizione del mittente già formattata (SOCIETA' + NOME)
	GAL_SMTP_FIRMA = 1304;
	GAL_SMTP_CCN = 1305;
	GAL_SMTP_PROTOCOL = 1306;
{	GAL_SMTP_HOST = 1302;
	GAL_SMTP_PORT = 1303;
	GAL_SMTP_NEED_AUTHENTICATION = 1304;
	GAL_SMTP_TLS = 1305;
	xGAL_SMTP_FROM = 1310;
	GAL_SMTP_AUTH_ID = 1311;
	GAL_SMTP_AUTH_PWD = 1312; }

	GAL_GOPT_SET_DEFAULT_CONNECTION_PARMS = 240;	// istituito 2019-09, sostituisce 241 e 242
//	GAL_GOPT_SET_DEFAULT_DATABASE_ALIAS = 241;		// 2012-09-08 prima era esplicitamente definito da ogni stampa
//	GAL_GOPT_SET_DEFAULT_DATABASE_DRIVER = 242;		// 2012-09-08 prima era esplicitamente definito da ogni stampa
	GAL_DEBUGMODE_BASE = 243;		// debug attivato se parametro 1, disattivato se parametro 0
	GAL_DEBUGMODE_FULL = 244;		// debug attivato se parametro 1, disattivato se parametro 0
	GAL_DEBUGMODE_SET_TARGET = 245;	// passare come parametro GAL_DEBUGMODE_TARGET_FILE/ GAL_DEBUGMODE_TARGET_RDEBUG / GAL_DEBUGMODE_TARGET_FILE_RDEBUG
	GAL_DEBUGMODE_TARGET_FILE = 'FILE';
	GAL_DEBUGMODE_TARGET_RDEBUG = 'RDEBUG';
	GAL_DEBUGMODE_TARGET_FILE_RDEBUG = 'FILE-RDEBUG';
	GAL_DEBUGMODE_RDEBUG_MODE = 246;	// passare GAL_DEBUGMODE_RDEBUG_BLANK / GAL_DEBUGMODE_RDEBUG_DATACOPY / GAL_DEBUGMODE_RDEBUG_PIPES / GAL_DEBUGMODE_RDEBUG_TCPIP
	GAL_DEBUGMODE_RDEBUG_BLANK = 'BLANK';	// disattiva la funzione
	GAL_DEBUGMODE_RDEBUG_DATACOPY = 'DATACOPY';
	GAL_DEBUGMODE_RDEBUG_PIPES = 'PIPES';
	GAL_DEBUGMODE_RDEBUG_TCPIP = 'TCPIP';

	// fino al 2014-09-05 l'opzione GAL_GOPT_SET_EMAIL_ADDRESS_LIST (che era UNICA, non era divisa in tre)
	GAL_GOPT_SET_EMAIL_ADDRESS_LIST_TO = 106;		// I_VALUE è un LPSTR asciiz contenente l'elenco delle mail da inserire nella combobox -- vedi funzione GAL_get_option()
	GAL_GOPT_SET_EMAIL_ADDRESS_LIST_CC = 107;		// I_VALUE è un LPSTR asciiz contenente l'email default  -- vedi funzione GAL_get_option()
	GAL_GOPT_SET_EMAIL_ADDRESS_LIST_CCN = 108;		// I_VALUE è un LPSTR asciiz contenente l'email default  -- vedi funzione GAL_get_option()

	// -- GAL_set_option() ------------------------------------
	// opzioni generali per il programma (usare GAL_set_option())
	GAL_GOPT_SET_EXPORT_PATH = 101;			// I_VALUE è un LPSTR asciiz contenente il path; deve terminare con \ ; può essere temporaneamente forzato dalla SET_PRINT_EXPORT_PATH()
	GAL_GOPT_SET_EMAIL_DEFAULT_ADDRESS = 102;		// I_VALUE è un LPSTR asciiz contenente l'email default  -- vedi funzione GAL_get_option()
		// quando l'opzione viene passata alla funzione GAL_get_option() il risultato è un numero contenente la bitmask della variabile
	GAL_GOPT_PRINTER_SELECT = 103;			// I_VALUE è un LPSTR asciiz contenente il nome della stampante
	GAL_GOPT_PROFILE_SELECT = 104;			// I_VALUE è un LPSTR asciiz contenente il nome del profilo
	GAL_GOPT_DONT_SET_APPLICATION_PRINTER = 105;	// evita di impostare la stampante predefinita dell'eseguibile; I_VALUE = 0/1 >> FALSE/TRUE
	GAL_GOPT_LOAD_DEFAULT_MAIL_WHEN_UNIQUE = 109;		// boolean: 0=FALSE, 1=TRUE
	GAL_GOPT_ADD_URL_RUNTIME = 110;

	// messaggio all'utente in presenza di più mail passate dal programma chiamante
	GAL_GOPT_MESSAGE_MAIL_MULTIPLE = 120;		// passare 0 per disattivare, 1 per attivare
	GAL_GOPT_USER_MESSAGE_MAIL = 121;			// passa a CASA un messaggio da mostrare all'utente in occasione della spedizione del report via mail

	GAL_GOPT_SET_EMAIL_ADDRESSES : array[mail_target_type] of word =
		(GAL_GOPT_SET_EMAIL_ADDRESS_LIST_TO, GAL_GOPT_SET_EMAIL_ADDRESS_LIST_CC, GAL_GOPT_SET_EMAIL_ADDRESS_LIST_CCN);

	GAL_STRING_PARM_OPTIONS = [
		GAL_GOPT_SET_DEFAULT_CONNECTION_PARMS,
//		GAL_GOPT_SET_DEFAULT_DATABASE_ALIAS, GAL_GOPT_SET_DEFAULT_DATABASE_DRIVER,
		GAL_GOPT_SET_EXPORT_PATH,
		GAL_GOPT_SET_EMAIL_DEFAULT_ADDRESS, GAL_GOPT_PROFILE_SELECT,
		GAL_GOPT_SET_EMAIL_ADDRESS_LIST_TO, GAL_GOPT_SET_EMAIL_ADDRESS_LIST_CC, GAL_GOPT_SET_EMAIL_ADDRESS_LIST_CCN];
	GAL_NUMERIC_PARM_OPTIONS = [GAL_GOPT_DONT_SET_APPLICATION_PRINTER];

	// opzioni per i singoli oggetti
	GAL_OPT_OBJ_SET_TIPOVARIABILE = 1000;	// passare uno dei parametri GOST_TIPOVAR_xxxx
	GOST_TIPOVAR_VARIABILE = 0;	
	GOST_TIPOVAR_PARAMETRO = 1;
	GOST_TIPOVAR_GROUP_EXPR_SQL = 2;
	GOST_TIPOVAR_SQL_SELECT = 3;
//	GOST_TIPOVAR_PARAMETRO_SQL >>>> GOST_TIPOVAR_PARAMETRO_SQL_EARLY;
	GOST_TIPOVAR_PARAMETRO_SQL_EARLY = 4;
	GOST_TIPOVAR_PARAMETRO_SQL_VERY_EARLY = 5;

	GAL_OPT_OBJ_SHOW = 1001;					// visibilità dell'oggetto; passare valori OSW_xxxx
//	MAX_STR_DB_COLUMN_NAME = 128+1;			// max size fisica (zero finale compreso) del nome di un campo
	MAX_STR_DB_COLUMN_NAME = 1024+1;			// max size fisica (zero finale compreso) del nome di un campo
	GAL_OPT_OBJ_STR_DB_COLONNA = 1002;
		{ modifica campo colonna database o equivalente; il parametro è un LPSTR(),
		  sia in entrata che in uscita (se e quando serve);
		  deve essere grande a sufficienza per contenere il risultato (MAX_STR_DB_COLUMN_NAME) }
	GAL_OPT_OBJ_STR_FORMULA = 1003;
	GAL_OPT_OBJ_GET_LENGTH_FORMULA = 1004;	// rende la lunghezza della formula, compreso lo zero finale; SOLO LETTURA
		// legge/modifica la formula del campo indicato; il parametro è un LPSTR(); in caso di lettura, deve essere di lunghezza sufficiente
	GAL_OPT_OBJ_STR_SQL_SELECT = 1005;
	GAL_OPT_OBJ_IMAGE_FILENAME = 1101;
		// GAL_..._IMAGE_FILENAME: passare nel parametro LONGINT un puntatore asciiz al nome del file da caricare
	GAL_OPT_OBJ_XPOS_MM = 1201;
	GAL_OPT_OBJ_YPOS_MM = 1202;
	GAL_OPT_OBJ_WIDTH_MM = 1203;
	GAL_OPT_OBJ_HEIGHT_MM = 1204;
		{ XPOS-YPOS:
			passare nel parametro longint la posizione in millimetri
			la posizione si intende sempre relativa alla sezione in cui si trova l'oggetto da muovere }
	GAL_OPT_OBJ_AUTOSIZE = 1211;	// rende 0 se FALSE, 1 se TRUE

	GAL_GET_OBJECT_TYPE = 1301;		// rende il tipo di oggetto (ca.tipo_oggetto: obj_type): un valore numerico mappato su
		// -1=oggetto non esistente, 1=LABEL_OBJ, 2=OBJ_BITMAP, 3=OBJ_RECT, 4=OBJ_LINE, 5=DATAMATRIX_OBJ, 6=LAST_TIPO);
	GAL_GET_OBJECT_VALUE_TYPE = 1302;	// per oggetti di tipo LABEL_OBJ: rende un valore GOVT_xxxx : il tipo di valore dell'oggetto (ca.tipo_valore: RISULTATO_TYPE)
		// -1=oggetto non esistente, 0=VAL_NUMERO, 1=VAL_TESTO, 2=VAL_BOOLEAN, 3=VAL_BOH
	GOVT_NUMERO = 0;
	GOVT_TESTO = 1;
	GOVT_BOOLEAN = 2;

type
	SHOW_TYPES = (
		OSW_SHOW,			// mostra sempre
		OSW_HIDE,			// nasconde sempre
		OSW_SHOW_1,			// mostra sulla prima pagina fisica della pagina logica
		OSW_SHOW_LAST,		// mostra sull'ultima pagina fisica della pagina logica
		OSW_HIDE_1,			// nasconde sulla prima pagina fisica della pagina logica
		OSW_HIDE_LAST,		// nasconde sull'ultima pagina fisica della pagina logica
		OSW_SHOW_1REC,		// mostra sul primo record (utile se il record si estende su più pagine)
		OSW_HIDE_1REC,		// nasconde sul primo record (utile se il record si estende su più pagine)
		OSW_SHOW_SOR,		// mostra solo sulla prima pagina del record (anche se il record si estende su più pagine)
		OSW_HIDE_SOR,		// nasconde sulla prima pagina del record
		OSW_SHOW_EOR,		// mostra solo sull'ultima pagina del record
		OSW_HIDE_EOR);		// nasconde sull'ultima pagina del record
const
//	OSW_FIRST = OSW_SHOW;OSW_LAST = OSW_HIDE_EOMR;
//	OSW_MAIN_RECORD_OBJECTS = [OSW_FIRST..OSW_LAST];
	OSW_MAIN_RECORD_OBJECTS = [low(SHOW_TYPES)..high(SHOW_TYPES)];
	OSW_SECTIONS_OBJECTS = [OSW_SHOW,OSW_HIDE,
//		OSW_SHOW_1,OSW_SHOW_LAST,	// non utile, perchè al subrecord non interessa il numero della pagina assoluta, ma casomai solo il numero del record (primo, non primo, ultimo, non ultimo >> SOR, EOR)
//		OSW_HIDE_1,OSW_HIDE_LAST,	// non utile, come sopra
		OSW_SHOW_1REC,
		OSW_HIDE_1REC,
		OSW_SHOW_SOR,
		OSW_HIDE_SOR,
		OSW_SHOW_EOR,
		OSW_HIDE_EOR];

	SHOW_TYPES_DESCR : array[SHOW_TYPES] of string = (
		'Mostra sempre',
		'Nascondi sempre',
		'Mostra solo sulla 1.a pagina fisica della pagina logica',		// mostra sulla prima pagina fisica della pagina logica
		'Mostra solo sull''ultima pagina fisica della pagina logica',	// mostra sull'ultima pagina fisica della pagina logica
		'Nascondi sulla 1.a pagina fisica della pagina logica',			// nasconde sulla prima pagina fisica della pagina logica
		'Nascondi sull''ultima pagina fisica della pagina logica',		// nasconde sull'ultima pagina fisica della pagina logica
		'Mostra su tutte le pagine del primo record',						// mostra solo sulle pagine del primo record
		'Nasconde su tutte le pagine del primo record',						// nasconde solo sulle pagine del primo record
		'Mostra solo sulla prima pagina del record',							// mostra solo sulla prima pagina del record (anche se il record occupa + pagine)
		'Nascondi sulla prima pagina del record',								// nasconde solo alla fine del record della main section
		'Mostra solo sull''ultima pagina del record',						// mostra solo alla fine del record
		'Nascondi sull''ultima pagina del record');							// nasconde solo alla fine del record

{ OSW_SHOW_EOMR, HIDE: esempio: capitolo con tanti articoli, totale solo sull'ultima pagina;
  la pagina logica è composta da più capitoli, ciascuno dei quali occupa una o più pagine;
  il campo del totale va solo sul capitolo }

type
	email_address_type = (EAT_BLANK, EAT_PRINCIPALE, EAT_DIREZIONE, EAT_AMMINISTRAZIONE, EAT_ORDINI, EAT_MAGAZZINO, EAT_UFFICIO_TECNICO);
	email_address_type_set = set of email_address_type;

{$ifndef DLL}
const		// parametri utilizzabili per la chiamata a GALRUN
	GALRUN_PARM_FILENAME_BASE = '/F';
	GALRUN_PARM_FILENAME = GALRUN_PARM_FILENAME_BASE + '=';
//	GALRUN_PARM_CONNESSIONE_BASE = '/C';
//	GALRUN_PARM_CONNESSIONE = GALRUN_PARM_CONNESSIONE_BASE + '=';
	GALRUN_PARM_CONN_PARMS_BASE = '/C';		// parametri di connessione a database (FireDAC)
	GALRUN_PARM_CONN_PARMS = GALRUN_PARM_CONN_PARMS_BASE + '=';
	DEFAULT_JOLLY_DATABASE_PARMS_SYMBOL = 'JOLLY';	// indica che vengono usati i parametri default del database JOLLY
	GALRUN_PARM_PARAMETRO_GALATEO = '/P=';
	GALRUN_PARM_PARAMETRO_FILENAME = '/@=';
	GALRUN_PARM_DEBUG_BASE = '/D';
	GALRUN_PARM_DEBUG_FULL = '/D+';
	GALRUN_PARM_MAIL_DEFAULT_TO = '/TO=';
	GALRUN_PARM_MAIL_DEFAULT_CC = '/CC=';
	GALRUN_PARM_MAIL_DEFAULT_CCN = '/CCN=';

	GALRUN_PARM_POPT_GALATEO_MODE = '/M=';		// + parametro GALRUN_PARM_POPT_xxxxxxxxxx
	GALRUN_PARM_POPT_PRINT_ANTEPRIMA = 'ANTEPRIMA';
	GALRUN_PARM_POPT_PRINT_PRINTER = 'STAMPANTE';
//	{$ifdef PROVA} *** {$endif}
	GALRUN_PARM_POPT_DIRECTLY_EXECUTE = 'DIRETTA';		//	**** è la modalità di stampa diretta, senza selezione della stampante
	GALRUN_PARM_POPT_PDF = 'PDF';
	GALRUN_PARM_POPT_EMAIL = 'MAIL';
	GALRUN_PARM_POPT_SILENT = 'SILENT';
	GALRUN_PARMS_POPT_NUMBER = 6;
	GALRUN_PARMS_POPT : array[0..GALRUN_PARMS_POPT_NUMBER-1] of string = (GALRUN_PARM_POPT_PRINT_ANTEPRIMA, GALRUN_PARM_POPT_PRINT_PRINTER,
		GALRUN_PARM_POPT_DIRECTLY_EXECUTE, GALRUN_PARM_POPT_PDF, GALRUN_PARM_POPT_EMAIL, GALRUN_PARM_POPT_SILENT);
	GALRUN_PARMS_POPT_VALUES : array[0..GALRUN_PARMS_POPT_NUMBER-1] of {DWORD}longint = (GAL_POPT_PRINT_ANTEPRIMA, GAL_POPT_PRINT_PRINTER,
		GAL_POPT_DIRECTLY_EXECUTE, GAL_POPT_PDF, GAL_POPT_EMAIL, GAL_POPT_SILENT);
{$endif}

