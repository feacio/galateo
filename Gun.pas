unit Gun;			{ Galateo UNit: contiene il modulo GALATEO, che rappresenta il cuore dell'applicazione
						  fino al 2020-11-21 era tutto contenuto in GLOBAL, che però aveva il difetto di essere una FORM
						  semi-nascosta, con significativi problemi di gestione }

{$I defines}

interface

uses Windows, Forms, Classes, SysUtils, Graphics, Messages, Math,
	FireDAC.Stan.Option,
	FCommons, FDebug, FRDebug, FXStrings, FStrings, FDB, FTP_proc, FCtrls,
	WPPDFR1, PDF,
	Gdich, objects, colori_proc,
	expint_base, text_scripts{$ifNdef DLL}, galateo_main{$endif};

type
	cl_macro_parametrica = class
		str_nome, str_macro : string;
		parms : array of string;
		constructor create(str_testo_macro : string;bo_test : boolean);
		destructor free;
	end;

	cl_logical_page_info = class
		// informazioni sulla pagina logica; non sono su CL_LOGICAL_PAGE proprio perchè riguardano CL_LOGICAL_PAGE (e ne regolano il caricamento, ad esempio)
		private
			i_page_1B : logical_page_type;		// 1-based
			function calculate_dont_print : boolean;
//		private
//			bo_XML_allowed_phisical : boolean;
//			function get_XML_allowed : boolean;
		public
			bo_external : boolean;				// pagina logica caricata da file esterno
			wo_external_original_version : word;		// versione del file GPL; può essere differente dalla versione del file principale
			str_page_ID : string;				// nome della pagina -- utilizzato per identificare univocamente la pagina
			str_external_filename : string;	// nome del file che contiene la pagina logica
			bo_message_if_not_printed : boolean;
			str_message_if_printed : string;	// messaggio da emettere se la pagina (che contiene errori o situazioni anomale) viene stampata
			bo_default_print_page : boolean;	// per default propone la stampa della pagina (in printer_select)
			i_colore_base, i_colore_alt : TColor;
			str_PDF_watermark : string;	   // WATERMARK da utilizzare per la specifica pagina
			str_descrizione_breve, str_descrizione_estesa : string;
			str_last_saved_by_main_report : string;	// il GPL è stato salvato l'ultima volta dal file .........
			str_condizione_esecuzione : string;			// la pagina viene stampa solo se la condizione è verificata
			bo_dont_print_phisical : boolean;			// se TRUE la pagina NON viene stampata
			bo_exclude_debug : boolean;					// esclude TUTTO il debug per gli oggetti della pagina
//			str_struttura_XML : string;
			str_struttura_XML_runtime : array of string;			// struttura XML contenente i dati XML tradotti a runtime; contiene un valore per ogni profilo exportato in modalità XML
//			property bo_XML_allowed : boolean read get_XML_allowed write bo_XML_allowed_phisical;
			property bo_dont_print : boolean read calculate_dont_print;		// TRUE se la pagina è esclusa dalla stampa (non viene mostrata neanche in anteprima)

{			bo_export_allowed : boolean;		// consente l'exportazione integrale sulla pagina
			str_sigla : string;
			bo_print_headers, bo_print_pagina_logica, bo_print_sezione, bo_print_pagina_fisica, bo_print_record_number : boolean;	// nell'exportazione integrale scrive le informazioni indicate
			bo_blankrow_after_headers : boolean;
			function get_expint_sigla : string;
			function get_expint_page(i_profilo_expint : byte) : cl_expint_page; }

			constructor create(i_page_1B : logical_page_type);
			{$ifdef DEBUG} destructor free; {$endif}
			procedure reset(i_page_1B : logical_page_type);
			function sostituisci_filename(str_RLF : string) : string;
			function get_descrizione(bo_descrizione_breve : boolean) : string;
{$ifndef DLL}
			procedure assign(source : cl_logical_page_info);
			procedure update_logical_page_number(i_page : logical_page_type);
{$endif}
		public	// GAPP: Gestione Automatica Progressivi di Pagina -- niente (ma proprio NIENTE) a che fare con la omonima sarl francese
			bo_attiva_GAPP : boolean;
			str_GAPP_obj_tipo_progressivo : string;	// oggetto che contiene il tipo di numerazione (esempio: oggetto che referenzia un campo database che contiene un valore come IVA-ACQ)
			str_GAPP_obj_esercizio : string;				// oggetto che contiene il valore dell'esercizio
			str_GAPP_obj_record : string;					// oggetto che contiene il codice del record oggetto della stampa (esempio: la riga di primanota); deve trovarsi sulla sezione 2
			str_GAPP_obj_dt_riferimento : string;		// oggetto che contiene la data di riferimento cui la stampa si riferisce; può essere relativo al singolo record oppure alla stampa nel suo insieme
			str_GAPP_obj_operatore : string;
//			box_GAPP_SQL_exist : xboolean;				// XTRUE se esistono i progressivi sul database, XFALSE se non esistono, XNOTHING se non è ancora stato verificato
			bo_GAPP_creati_progressivi : boolean;		// TRUE se ho creato dei progressivi
			function has_progressivi_automatici(bo_error_msg : boolean) : boolean;

(*		{$ifdef DLL}
			private
				printer_size_constraints_phisical_values : printer_size_constraints_data_type;
				function get_printer_size_constraints : printer_size_constraints_data_type;
			public
				printer_size_constraints_mode : printer_size_constraints_type;
				property printer_size_constraints : printer_size_constraints_data_type read get_printer_size_constraints;
		{$else}
			private
				function get_printer_size_constraints : printer_size_constraints_data_type;
			public
				printer_size_constraints_mode : printer_size_constraints_type;
				printer_size_constraints_phisical_values : printer_size_constraints_data_type;
				property printer_size_constraints : printer_size_constraints_data_type read get_printer_size_constraints;
		{$endif} *)
			private
				function get_printer_size_constraints : printer_size_constraints_data_type;
			public
				printer_size_constraints_mode : printer_size_constraints_type;
				printer_size_constraints_phisical_values : printer_size_constraints_data_type;
				property printer_size_constraints : printer_size_constraints_data_type read get_printer_size_constraints;
	end;

	cl_connection_configuration = class
		public
			father : TForm;
			bo_read_from_profile : boolean;
			str_profile, str_profile_path : string;
	//		bo_alias : boolean;
			bo_login_prompt : boolean;
			str_driver, str_table, str_parametri_connessione : string;
			function blank : boolean;
			procedure clear;
			function assign(source : cl_connection_configuration) : cl_connection_configuration;
			function read(var f : Text;wo_versione : word) : boolean;
			{$ifdef GALATEO_EXE} function write(var f : Text) : boolean; {$endif}
			constructor create(father : TForm);
			destructor free;
		public
			database_parms : cl_database_parms;			// dati del profilo letti dalla READ_PROFILE; sola lettura, non vengono salvati
			{$ifdef DLL} str_external_connection_parms : string; {$endif}	// parametri assegnati dalla procedura chiamante; hanno la precedenza
			function read_profile(str_report_filename : string;pt_bo_galateo_cannot_connect : boolean_punt) : boolean;
			function get_parametri_connessione(pt_error_galateo_NOT_allowed : boolean_punt = NIL) : string;
	end;
	connection_configuration_punt = ^cl_connection_configuration;

	Tglobale = class
		private
			function get_system_database : TFDatabase;
			procedure set_system_database(db : TFDatabase);
			{$ifdef CASA} function get_report_database : TFDatabase; {$endif}
			{$ifdef CASA} procedure set_report_database(db : TFDatabase); {$endif}
		public
			phisical_report_database : TFDatabase;				// UNICO db da utilizzare a runtime nella generazione dei reports
			phisical_system_database : TFDatabase;				// database da utilizzare per la gestione di sistema
//			xdb_report : TFDatabase;					// UNICO db da utilizzare a runtime nella generazione dei reports
//			xxdb_galateo: TFDatabase;
			{$ifdef CASA} property report_database : TFDatabase read get_report_database write set_report_database; {$endif}
			property system_database : TFDatabase read get_system_database write set_system_database;
		public
			procedure FormClose(Sender : TObject);
		private
			send_mail_modalita_standard_galateo_ph : galateo_send_mail_mode_type;
					// modalità standard di Galateo; usare direttamente solo per modificare la modalità standard
					// è il valore PRIMA di essere eventualmente sovrascritto dal programma chiamante
					// questa variabile dovrebbe essere salvata staticamente (ad esempio sul registry)
					// fino a 2018-09 era salvata (da SMTP_PROC), poi è stata spostata qui e non è più avvenuto
			xsend_mail_modalita_calling_program : galateo_send_mail_mode_type;		// modalità impostata dal programma chiamante
			send_mail_modalita_runtime_user : galateo_send_mail_mode_type;			// modalità impostata runtime dall'utente
			function get_modalita_invio_mail : galateo_send_mail_mode_type;
			procedure set_modalita_invio_mail(modalita : galateo_send_mail_mode_type);
		public
			property send_mail_modalita_standard_galateo : galateo_send_mail_mode_type read send_mail_modalita_standard_galateo_ph;
			property modalita_invio_mail : galateo_send_mail_mode_type read get_modalita_invio_mail write set_modalita_invio_mail;
		public
			lo_key_sessione : integer;
			father : TForm;
			str_password_edit, str_password_exec : string;					// pwd di accesso a GALATEO
			fase_stampa : FASI_STAMPA_TYPE;
			i_active_monitor : smallint;				// monitor da utilizzare per il report (anteprima e dialogs)
			str_descrizione_report, str_runtime_help : string;
			runtime_help_font : font_info;
			bo_use_compressed_bmps : boolean;
			bo_orizzontale_old_version : boolean;	// orientamento pagina; NON usare; vedi PAGES
			box_new_valutazione_scostamento : xboolean;	/////////// ELIMINARE 2008-01-01 *******************************************************************
				// XNOTHING per usare il default di sistema, oppure XTRUE, XFALSE
				// 2007-01-14: usa il nuovo metodo di valutazione degli scostamenti verticali
//			i_jpeg_compression_quality : 1..100;	// 1 max quality, 100 max compression
//			i_jpeg_percentuale : MIN_JPEG_PERCENTUALE..MAX_JPEG_PERCENTUALE;	// dimensione dell'immagine rispetto salvata
			bo_show_hidden_objects : boolean;		// mostra/nasconde gli oggetti non visibili
			str_default_date_format : string;	// formato utilizzato per la formattazione delle date
			str_default_time_format : string;	// formato utilizzato per la formattazione dei DATETIMEs
			i_forced_width_10mm, i_forced_height_10mm : integer;
				// dimensioni del foglio in decimi di mm se differenti dall'impostazione standard della stampante
			bo_force_font_exist : boolean;	// non simula font non realmente esistenti
			azione_after_print : azione_after_print_type;
			print_diretta : print_diretta_type;
			bo_pausa_pagina : boolean;			// se TRUE il programma si interrompe dopo la stampa di ogni pagina (salvo ovviamente l'ultima)
			str_pausa_pagina_message : string;		// messaggio che viene proposto durante la pausa di stampa
			i_durata_pausa_pagina_msec : smallint;	// durata della pausa in msec

//			bo_alias : boolean;
//			str_db_driveralias : string;		// driver oppure alias della connessione a database (vedi il valore BO_ALIAS)
{$ifdef DLL}
//			str_runtime_default_database_driver : string;		// valore default trasmesso
//			str_runtime_default_database_alias : string;		// valore default
{$endif}
			connection_config : cl_connection_configuration;
//			str_db_table, xstr_local_connection_parms : string;
//			bo_login_prompt : boolean;				// chiede i parametri della connessione runtime
			bo_use_transaction : boolean;			// chiude tutto entro una transazione SQL
			bo_commit_transaction : boolean;		// esegue un commit al termine (if bo_use_transaction, of course)
			isolation_level : TFDTxIsolation;
			str_db_field_default : string;		// ANACRONISTICO: il campo del database da considerare principale (funzionava con le semplici etichette)
		public
			SQL_reexecute_scripts : SQL_reexecute_script_options;
			text_scripts : text_scripts_array_type;
			function check_scripts_filenames : boolean;

		public
			tsql_stored_procs_definition : TStrings;
			str_documento_informativo_utente, str_technical_reference : string;
			str_links_utente : string;					// links specificati staticamente sul report
			{$ifdef DLL} str_links_runtime : string; {$endif}		// links specificati runtime dal programma chiamante
			printer_size_constraints : printer_size_constraints_data_type;
		public
			str_lingua_object : string;		// oggetto che contiene la lingua da utilizzare per le traduzioni
			str_lingua_contesto : string;		// contesto linguistico (opzionale) che serve per selezionare gli elementi linguistici
			function init_traduzione : boolean;
			function traduzione_disponibile : boolean;
			function get_traduzione_lingua(str_item : string) : string;
		public
			comportamento_when_null : comportamento_when_null_type;
			str_value_when_null_text, str_value_when_null_numeric : string;
		public
			bo_griglia_vtabs : boolean;
			i_griglia_vtabs : smallint;			// dimensione delle maglie della griglia di allineamento virtuale
			i_pagine_logiche : logical_page_type;		// numero di pagine logiche del report
			function get_runtime_pagine_logiche_stampabili : logical_page_type;		// numero totale di pagine logiche stampabili; valore disponibile a runtime
		public
			tiporeport : REPORT_TYPE;
			bo_dll : boolean;
			i_job : smallint;
			tstr_remarks : TStrings;				// remarks sul contenuto del file
			bo_loading_file : boolean;				// TRUE durante il caricamento del file
			bo_exclude_azioni_comunitarie : boolean;	// esclude azioni comunitarie (move, resize a catena)
			bo_create_index, bo_show_index : boolean;
			bo_exists_runtime_parms : boolean;			// esiste almeno un parametro runtime (realmente richiesto)
			bo_allow_saving_runtime_pos : boolean;		// consente il salvataggio della posizione della runtime-parms-window
			{$ifndef DLL} bo_external_file_too_old : boolean; {$endif}		// esclude il salvataggio in determinate condizioni

			lpZB_info : array[0..MAX_PAGINE_LOGICHE-1] of cl_logical_page_info;		// 0-based
			i_numero_copie_default : smallint;
			bo_log_parametri : boolean;	// per ogni stampa tiene traccia su un file registro dei parametri che l'hanno generata
			bo_show_time_esecuzione : boolean;

			// opzioni globali di Exportazione
			bo_overwrite_file : boolean;
			str_export_filename : string;				// nomefile default destinazione exportazione; vale sia PDF che export integrale e XML
			str_expint_export_filename : string;	// nomefile utilizzato per export integrale e XML (in deroga a STR_EXPORT_FILENAME)
			str_last_exported_filename : string;	// nome del (ultimo) file realmente exportato

			str_formato_label : string;								// codice descrittivo del formato di etichetta
			str_label_skip : string;									// parte a stampare saltando il numero specificato di etichette
			bo_label_registra_ultima_posizione : boolean;		// registra l'ultima posizione di stampa per le etichette

			// TEXT ONLY FEATURES
			bo_text_only : boolean;		// si desidera che la stampa sia eseguita in stile 'text only', no graphics
			text_only_font : TFont;
			i_text_only_colonne, i_text_only_righe : smallint;	// # di colonne per riga e di righe per pagina
			i_text_only_cpi, i_text_only_lpi : smallint;			// Chars Per Inch e Lines Per Inch

//			str_default_image_filename : string;
			str_default_export_filepath : string;
		private
			bo_phisical_debug_base, bo_phisical_debug_full : boolean;
			function get_debug_base : boolean;
			function get_debug_full : boolean;
{$ifNdef DLL}
			procedure set_debug_base(bo : boolean);
			procedure set_debug_full(bo : boolean);
{$endif NOT DLL}
		private
			bo_silent_mode_phisical : boolean;			// esclude i messaggi di interazione con l'utente
{$ifndef DLL}
		public
			property bo_silent_mode : boolean read bo_silent_mode_phisical write bo_silent_mode_phisical;
{$endif DLL}
		public
			table_colori_symbolici : table_colori_symbolici;
		public
			bo_application_debug_base, bo_application_debug_full : boolean;		// impostazioni assegnate da programma esterno
			bo_debug_delete_everytime : boolean;	// modalità di debugging
			str_debug_computer : string;
			bo_log_registro_eventi, bo_log_file : boolean;
			{$ifndef DLL} bo_saved_debug : boolean; {$endif}
			bo_exclude_runtime_message_report : boolean;			// salvato sul report

			property bo_debug_base : boolean read get_debug_base {$ifNdef DLL} write set_debug_base {$endif};
			property bo_debug_full : boolean read get_debug_full {$ifNdef DLL} write set_debug_full {$endif};
//			procedure debug_message(handle : HWND = 0);
			procedure debug_message(father : TForm = NIL);
		public
			bo_GAPP_ask_conferma_stampa_definitiva : boolean;		// domanda se si vuole considerare la stampa presente come definitiva
			str_GAPP_password_stampa_definitiva : string;			// password richiesta per convalidare la stampa definitiva

			{$ifdef DLL} str_author : string; {$endif}	// nome dell'utente che esegue la stampa
			PDF : cl_PDF;		// valori e impostazioni per PDF
		private
			function PDF_load(var f : system.Text;wo_versione_report : word) : boolean;
			{$ifndef DLL} function PDF_save(var f : system.Text) : boolean; {$endif}
		private
			bo_XML_structure_debug_info_phisical : boolean;		// TRUE se inserisce nella struttura XML finale riferimenti agli elementi costitutivi della struttura
			function get_XML_structure_debug_info : boolean;
		public
//			bo_XML_allowed : boolean;		// TRUE se l'export XML è consentito a livello globale
//			str_struttura_XML : string;	// formato XML esterno a tutte le sezioni e a tutte le pagine
			str_XML_header_runtime, str_struttura_XML_runtime : array of string;			// struttura XML contenente i dati XML tradotti a runtime
			property bo_XML_structure_debug_info : boolean read get_XML_structure_debug_info write bo_XML_structure_debug_info_phisical;	// TRUE se inserisce nella struttura XML finale riferimenti agli elementi costitutivi della struttura
//			function XML_runtime_implemented : boolean;
		public
			// EXPortazione INTtegrale
{			str_message_before, str_message_after, str_comando_specifico_default : string;
			target_default : export_integrale_target_type;
			EFAT_default_action : export_file_action_type;
			lo_expint_max_lines : integer;		// numero max di righe exportate
			expint_separatore : expint_separatore_type; {}

			// impostazioni generiche di exportazione integrale
			bo_export_allowed, bo_export_set_default, bo_export_proponi, bo_export_execute_automatically : boolean;
			export_default_file_writemode_backward_compatibility : file_writemode_type;
			expint_default_target_backward_compatibility : export_integrale_target_type;		// valore default, utilizzato solo se il profilo di exportazione integrale attivo vale EITT_DEFAULT
			expint_profiles : expint_profilo_array;
			i_active_expint_profile : expint_index_type;		// indice (riferito a EXPINT) dell'exportazione integrale attiva; il valore è valido solo durante l'esecuzione della stampa (ovvero dell'exportazione)
			FTP_parms : cl_FTP_parms;
			bo_FTP_conferma : boolean;		// richiede conferma prima di eseguire il trasferimento su FTP
			str_FTP_message, str_FTP_password : string;			// per eseguire il trasferimento su FTP richiede la password specificata (massima garanzia di volontà dell'operatore)
//			i_default_expint_profile : expint_index_type;	// indice (riferito a EXPINT) dell'exportazione integrale default ***** il default è sempre il primo profilo
//			function get_active_expint : cl_expint_profilo;
		private
			function get_azione_opening_report : azione_opening_report_type;
			procedure set_azione_opening_report(azione : azione_opening_report_type);
		public
			azione_opening_report_phisical : azione_opening_report_type;		// valore trattato nel report
			azione_opening_report_runtime : azione_opening_report_type;		// valore impostato runtime via parametro
			property azione_opening_report_executive : azione_opening_report_type read get_azione_opening_report write set_azione_opening_report;	// valore efficace, letto ed assegnato durante l'esecuzione del report
		public
			str_current_printer, str_current_tray : string;		// stampante e cassetto in uso per la stampa in corso
			modalita_selezione_default_printer : default_printer_selection_type;
			bo_usa_sempre_printer_report : boolean;	// non accetta l'impostazione della stampante runtime, usa sempre quella indicata nel report
			azione_printer_unknown : azione_printer_unknown_type;
			printer_default : array[0..NUMERO_DEFAULT_PRINTERS-1] of printer_default_type;
			function get_default_printer(bo_blank_if_predefinita : boolean) : string;
//			function xget_current_printer(bo_blank_if_predefinita : boolean) : string;
		public
//			str_macro_parametriche : string;			*** 2018-07-08 spostato su TEXT_SCRIPTS
			macro_parametriche : array of cl_macro_parametrica;
			bo_first_print : boolean;	// TRUE alla prima stampa, diventa FALSE quando eseguo un reload di dati (F5 da PRINT_REPORT)
			function build_macro_parametriche(bo_test : boolean) : boolean;
			function translate_macro_parametrica(var str_text : string;var str_result : string;ox : objs_type;bo_test : boolean) : boolean;
			procedure free_macro_parametriche;
//			function esiste_macro_parametrica(s : string) : boolean;
		private
			str_email_default_runtime : string;	// valori impostati runtime dal programma chiamante
			str_email_elenco_runtime : array[mail_target_type] of string;
//			str_email_default_local_computed, str_email_elenco_local_computed : string;	// valori impostati runtime calcolati da STR_INDIRIZZI_EMAIL_DEFAULT/ELENCO
			function traslate_internal_email(var str_result : string;bo_default : boolean;str_elenco : string;bo_SQL : boolean) : boolean;
		public
			// Exportazione su Mail
			bo_auto_email : boolean;				// se T (salvo STR_CONDIZIONE_AUTO_EMAIL) propone l'invio automatico via mail
			str_condizione_auto_email : string;	// condizione che vincola l'invio automatico via mail
			str_subject, str_text : string;
			bo_address_required : boolean;	// richiede la presenza di un indirizzo per effettuare l'invio
			indirizzi_email_default, indirizzi_email_elenco : email_address_type_set;
			bo_load_indirizzo_main_when_unique : boolean;		// usa l'indirizzo mail principale se nessun altro è disponibile
{$ifdef DLL}
			bo_main_info_user_messages_displayed : boolean;		// TRUE quando i messaggi informativi legati all'invio di mail sono stati mostrati
			bo_warning_on_multiple_mail_addresses : boolean;	// avvisa in presenza di più indirizzi mail
			str_runtime_mail_user_message : string;				// messaggio da mostrare all'utente quando invia il report per mail
{$endif DLL}
			str_indirizzi_email_default_internal, str_indirizzi_email_elenco_internal : string;		// valori interni, da trasformare nei corrispondenti valori COMPUTED
			bo_indirizzi_email_default_SQL, bo_indirizzi_email_elenco_SQL : boolean;
			str_message_opening_print : string;		// messaggio emesso prima di eseguire la stampa
			function get_email_default : string;	// email default (eventualmente comma-delimited)
			function get_email_elenco(tipo : mail_target_type = MTT_TO) : string;		// elenco delle mail disponibili nella combobox, ACAPO-delimited
{$ifdef DLL}
			procedure set_email_runtime_default(s : string);
			procedure set_email_runtime_elenco(s : string;tipo : mail_target_type = MTT_TO);
{$endif DLL}
		private
			function get_pos_macro_parametrica(str_macro : string) : smallint;
			function get_connessione_blank : boolean;
		public
			wo_versione_read : word;	// versione del report, come è stato letto
			main_form : TForm;
			property connessione_blank : boolean read get_connessione_blank;
			function get_databasename : string;
			function get_handle(calling_form : TForm = NIL) : hwnd;
			function get_active_form(calling_form : TForm = NIL) : TForm;
			function init_db_report(var db : TFDatabase;str_databasename : string = '') : boolean;
			function set_main_form(new_main_form : TForm) : TForm;
		public
			bo_autosize_page : boolean;		// ridimensionamento automatico della pagina in funzione delle dimensioni reali della stampante utilizzata
			i_printer_reference_height_10mm : smallint;	// dimensione del foglio della stampante di riferimento
			procedure autosize_printer_page(bo_ask : boolean = FALSE);
			function resize_subsection(i_page : logical_page_type;i_deltay_10mm : smallint;bo_ask_on_problem : boolean) : boolean;
			procedure move_objects(i_page : logical_page_type;i_deltay_10mm : smallint);
		private
			stored_values : array of cl_store_value;
			function get_stored_value_pos(str_name : string;var i_ndx : integer) : boolean;
		public
			procedure store_value(str_name : string;str_value : string;bo_text : boolean;stoop : STORE_OPERATION_TYPE); overload;
			procedure store_value(str_name : string;fl_value : double;stoop : STORE_OPERATION_TYPE); overload;
			function get_stored_value(str_name : string;bo_must_exists : boolean = TRUE) : string;
			function esiste_stored_value(str_name : string) : boolean;
			procedure free_stored_values;
		private
			str_filename_phisical : string;
//			function read_str_filename : string;
			procedure write_str_filename(s : string);
		private
			// variabili temporanee rese necessarie dal supporto a precedenti formati di salvataggio
			r_labsize_x_cm_temp, r_labsize_y_cm_temp, r_marg_sx_cm_temp, r_marg_up_cm_temp : misura_real_type;

{$ifndef DLL}
		public
			salvataggi : TStrings;
			bo_federico_signed : boolean;		// federico ha firmato la modifica
			bo_dont_write_version : boolean;
			str_signature, str_descrizione_modifiche : string;				// nome che firma il salvataggio attuale e descrizione delle modifiche apportate
			i_impostazioni_pageindex, i_impostazioni_SQLscripts_pageindex, i_impostazioni_macro_scripts_pageindex, i_impostazioni_export_pageindex, i_impostazioni_mail_pageindex : smallint;
			function get_signature(bo_ask_always : boolean = FALSE;bo_can_abort : boolean = FALSE) : string;
{$endif NOT DLL}
		private
			procedure init(father : TForm;i_job : smallint;str_author : string);
			procedure init_form(form : TForm);
			procedure init_banali;	// inizializzazioni non di concetto, ovvero banali
			procedure init_values;	// inizializzazioni dei valori default
			function read_label(var f : system.Text;wo_versione : word) : boolean;
			function read_report(var f : system.Text;wo_versione : word;str_runtime_load_filenames : string) : boolean;
			function read_pagina_logica_external(str_external_filename : string;i_logical_page : logical_page_type) : boolean;
			function read_pagina_logica_attiva(var f : system.Text;var wo_versione : word;bo_external : boolean;str_runtime_load_filenames : string = '') : boolean;
		public
			runtime_gboxes : runtime_groupboxes_array;
			lo_background_parms_caption_color, lo_foreground_parms_caption_color : TColor;
			str_runtime_parms_caption : string;		// titolo della finestra di richiesta dei parametri
			bo_show_immagini_sfondo : boolean;		// mostra le BMPs di sfondo -- utile a DESIGN- e RUN-time
//			str_debug_filename : string;
			destructor freex;
			function load(father : TForm;str_filename : string;str_runtime_load_filenames : string = '') : boolean;
			function select_printer(str_new_printer : string) : boolean;
//			procedure set_db_driver(bo_login_prompt : boolean;str_db_driver, str_connection_parms : string;bo_alias : boolean);
			procedure set_db_driver(bo_login_prompt : boolean;str_connection_parms : string);
//			{$ifdef DLL} procedure set_db_driver_runtime(str_db_driver, str_parametri_connessione_DB : string;bo_alias : boolean);  {$endif}
			procedure set_keep_connections(bo_keep : boolean);
{$ifdef DLL}
			procedure stampa(father : TForm;bo_manuale : boolean;lo_print_style : integer);
			procedure set_db_driver_runtime(str_parametri_connessione_DB : string);
			constructor create_dll(father : TForm;i_job : smallint;str_author : string);
{$else}
//			function backup : boolean;
//			procedure link_label_2_address_database;
			function write_label(var f : system.Text) : boolean;
			function write_report(var f : system.Text) : boolean;
			procedure nuova_etichetta;
			function save(str_filename : string;bo_can_abort : boolean = TRUE) : boolean;
			function save_external_logical_page(i_logical_page : logical_page_type;bo_ask : boolean) : boolean;
			function write_pagina_logica_attiva(var f : system.Text;bo_external_file : boolean) : boolean;
			procedure set_connessione_database;
			procedure write_groupboxes(var f : text);
			constructor create_galateo(father : TForm);
			procedure program_messages(var Msg: TMsg;var Handled: Boolean);		// Tapplication
{$endif DLL}
			procedure read_groupboxes(var f : text;wo_versione : word);
			property str_filename : string read str_filename_phisical write write_str_filename;

			function get_default_write_filename(bo_target_export : boolean;bo_translate_macros : boolean = TRUE) : string;
			function get_default_write_filepath(bo_target_export : boolean;bo_translate_macros : boolean = TRUE) : string;
	end;

function silent_mode : boolean;			// esecuzione senza interazione con l'utente
procedure set_silent_mode(bo : boolean);

function get_pagina_logica_info_index_ZB(str_ID : string) : logical_page_type;
function get_logical_page_ZB(i_pagina_ZB : logical_page_type) : cl_logical_page_info;
function get_logical_page_1B(i_pagina_1B : logical_page_type) : cl_logical_page_info;

const
	DEBUG_MSG : array[boolean] of string = ('Report in esecuzione in modalità debug', 'Report in esecuzione in modalità debug [avanzata]');

{$ifdef CASA}
var bo_exclude_message_not_computed_object : boolean;
{$endif CASA}

implementation

uses FMessage, FSystem_base, FSystem, FSystem_ext, FErrMsg, FProcs, Fdata, Fbrowse, FFile, FSQLsoft, ValEdit,
{$ifdef CASA}
	functions, print_report, working,
{$else}
	domanda_multipla, pagina_logica_edit, db_link, Database, macros_elenco, // Ftime, panel,
{$endif}
	input_dialog, runtime_gbox_proc,
	myprinter, printers_DX, galateo_debug, proc, sp_galateo,
	{printer_select, }sezione, pages, FRegistry, misure;

//	FAssert, 	FTP_proc,

var
	it_lingue_disponibili : TStrings;
	{$ifdef DEBUG} i_logical_page_info, i_macro_parametrica, i_global : integer; {$endif}

const
	INIT_LOCAL_PROGRAM_NAME = {$ifdef DLL} 'casa of Galateo' {$else} 'GALATEO' {$endif};
	GBOX_MARKER_START = 'g-box-start';
	GBOX_MARKER_END = 'g-box-end';
	MAX_BOXES = 7;

var
	bo_silent_mode : boolean;		// esecuzione in modalità SILENZIOSA (condizione legata al singolo REPORT)

procedure set_silent_mode(bo : boolean);
begin
	if get_service_mode then bo := TRUE;
	bo_silent_mode := bo;
	{$ifdef CASA} fmessage.bo_silent_mode := bo {$endif}
end;

function silent_mode : boolean;
{ rende TRUE se il report deve essere eseguito in modalità silenziosa (ovvero senza interazione con l'utente);
  l'impostazione può derivare dal valore impostato sul report (GLOBALE.BO_SILENT_MODE) oppure dall'esecuzione in modalità SERVIZIO }
begin
	result := TRUE;
	if bo_silent_mode then exit;
	if (globale <> NIL) AND globale.bo_silent_mode_phisical then exit;
	result := FALSE
end;

// #	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#

function get_pagina_logica_info_index_ZB(str_ID : string) : logical_page_type;
// rende la posizione Zero-Based della pagina logica con l'ID specificato; rende -1 se la pagina logica non esiste
begin
	str_ID := uppercase(togliblanks(str_ID));
	if (str_ID = '') then begin result := -1;exit end;
	for var i : logical_page_type := 0 to get_ultima_pagina_logica-1 do begin
		if (str_ID = uppercase(get_logical_page_ZB(i).str_page_ID)) then begin
			result := i;
			exit
		end
	end;
	result := -1
end;

function get_logical_page_ZB(i_pagina_ZB : logical_page_type) : cl_logical_page_info; begin result := globale.lpZB_info[i_pagina_ZB] end;
function get_logical_page_1B(i_pagina_1B : logical_page_type) : cl_logical_page_info; begin result := globale.lpZB_info[i_pagina_1B - 1] end;

// #	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#

// #	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#

// #	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#

// #	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#

// #	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#

// #	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#	#

{$ifdef GALATEO_EXE}
	procedure cl_logical_page_info.assign(source : cl_logical_page_info);
	begin
		i_page_1B := source.i_page_1B;
		bo_external := source.bo_external;
		wo_external_original_version := source.wo_external_original_version;
		str_page_ID := source.str_page_ID;
		str_external_filename := source.str_external_filename;
		bo_message_if_not_printed := source.bo_message_if_not_printed;
		str_message_if_printed := source.str_message_if_printed;
		bo_default_print_page := source.bo_default_print_page;
		i_colore_base := source.i_colore_base;
		i_colore_alt := source.i_colore_alt;
		str_PDF_watermark := source.str_PDF_watermark;
		str_descrizione_breve := source.str_descrizione_breve;
		str_descrizione_estesa := source.str_descrizione_estesa;
		str_last_saved_by_main_report := source.str_last_saved_by_main_report;
		bo_dont_print_phisical := source.bo_dont_print_phisical;
		bo_exclude_debug := source.bo_exclude_debug;
		str_condizione_esecuzione := source.str_condizione_esecuzione;
		printer_size_constraints_mode := source.printer_size_constraints_mode;
		printer_size_constraints_phisical_values := source.printer_size_constraints_phisical_values;

		bo_attiva_GAPP := source.bo_attiva_GAPP;
		str_GAPP_obj_tipo_progressivo := source.str_GAPP_obj_tipo_progressivo;
		str_GAPP_obj_esercizio := source.str_GAPP_obj_esercizio;
		str_GAPP_obj_record := source.str_GAPP_obj_record;
		str_GAPP_obj_dt_riferimento := source.str_GAPP_obj_dt_riferimento;
		str_GAPP_obj_operatore := source.str_GAPP_obj_operatore;
		bo_GAPP_creati_progressivi := source.bo_GAPP_creati_progressivi
	end;

	procedure cl_logical_page_info.update_logical_page_number(i_page : logical_page_type);
	begin
		i_page_1B := i_page
	end;
{$endif DLL}

constructor cl_logical_page_info.create(i_page_1B : logical_page_type);
begin
	{$ifdef DEBUG} inc(i_logical_page_info); {$endif}
	reset(i_page_1B)
end;

{$ifdef DEBUG}
	destructor cl_logical_page_info.free;
	begin
		dec(i_logical_page_info)
	end;
{$endif}

function cl_logical_page_info.get_descrizione(bo_descrizione_breve : boolean) : string;
begin
//	if (str_descrizione = '') then result := 'sezione #' + i_page.ToString
	if bo_descrizione_breve then result := coalesce(str_descrizione_breve, str_descrizione_estesa)
	else result := coalesce(str_descrizione_estesa, str_descrizione_breve);
	if (result = '') then result := '(pagina logica ' + i_page_1B.ToString + ')'
end;

{function cl_logical_page_info.get_expint_sigla : string;
var s : string;
	i_profilo_expint : smallint;
begin
	i_profilo_expint := 0;
	s := get_expint_page(i_profilo_expint).str_sigla;
	if (globale.i_pagine = 1) then result := s else result := coalesce(s, 'PL/' + i_page.ToString)
end;}

{function cl_logical_page_info.get_expint_page(i_profilo_expint : byte) : cl_expint_page;
// rende l'oggetto relativo al profilo specificato e alla pagina logica SELF
begin
	result := globale.expint_profiles[i_profilo_expint].expint_pages[i_page - 1]
end; }

function cl_logical_page_info.has_progressivi_automatici(bo_error_msg : boolean) : boolean;
begin
	result := bo_attiva_GAPP;
	if NOT result then exit;
	if (str_GAPP_obj_tipo_progressivo = '') OR (str_GAPP_obj_esercizio = '') OR (str_GAPP_obj_record = '') OR
		(str_GAPP_obj_dt_riferimento = '') OR (str_GAPP_obj_operatore = '')
	then begin
		result := FALSE;
		if bo_error_msg then MessageBBox(GH, 'Generazione automatica progressivi di stampa: parametri incompleti', GALATEO_MBOX_CAPTION)
	end
end;

procedure cl_logical_page_info.reset(i_page_1B : logical_page_type);
begin
	self.i_page_1B := i_page_1B;
	bo_external := FALSE;
	str_external_filename := '';
	str_page_ID := '';
	bo_message_if_not_printed := TRUE;
	str_message_if_printed := '';str_descrizione_breve := '';str_descrizione_estesa := '';
	str_PDF_watermark := '';
	bo_dont_print_phisical := FALSE;str_condizione_esecuzione := '';
	bo_exclude_debug := FALSE;
	str_struttura_XML_runtime := NIL;
	printer_size_constraints_mode := low(printer_size_constraints_mode);
	fillchar(printer_size_constraints_phisical_values, sizeof(printer_size_constraints_phisical_values), 0);

{	str_sigla := '';
	bo_export_allowed := TRUE;
	bo_print_pagina_logica := TRUE;
	bo_print_sezione := TRUE;
	bo_print_pagina_fisica := FALSE;
	bo_print_record_number := FALSE;
	bo_print_headers := TRUE;bo_blankrow_after_headers := TRUE; }

	bo_default_print_page := TRUE;
	bo_attiva_GAPP := FALSE;str_GAPP_obj_tipo_progressivo := '';str_GAPP_obj_esercizio := '';
	str_GAPP_obj_record := '';str_GAPP_obj_dt_riferimento := '';str_GAPP_obj_operatore := '';bo_GAPP_creati_progressivi := FALSE;
	i_colore_base := COLORE_DEFAULT_PRINT_BACKGROUND;i_colore_alt := COLORE_DEFAULT_PRINT_BACKGROUND
end;

function cl_logical_page_info.sostituisci_filename(str_RLF : string) : string;
{ formato: stringa divisa in righe separate da ACAPO; ogni riga ha il seguente formato:
	IDENTIFICATORE=FILENAME
  se la pagina corrente ha STR_PAGE_ID = IDENTIFICATORE viene utilizzato FILENAME }
const RUNTIME_DEBUG_CAPTION = 'sostituisci_filename()';
begin
	result := str_external_filename;
	writeln_system_debug(0, RUNTIME_DEBUG_CAPTION, 'str_RLF:' + str_RLF);
	while (str_RLF <> '') do begin
		var s := uppercase(get_line(str_RLF, TRUE));

		var str_temp := s;
		s := replace_environment_variables(s);
		if assigned(xxcallback_replace_variabili_ambiente)			// 2016-10-14
			then s := xxcallback_replace_variabili_ambiente(get_active_job, s, {ptr:unused}NIL);
		if (str_temp <> s) then writeln_system_debug(100, RUNTIME_DEBUG_CAPTION, '<' + str_temp + '> TRASFORMATO IN <' + s + '>');

		var i : smallint := pos('=',s);if (i = 0) then continue;
		var str_ID := togliblanks(copy(s, 1, i-1));
		if (str_ID = uppercase(str_page_ID)) then begin
			result := togliblanks(copy(s, i+1, MAXINT));
			if NOT end_with(result, EXTERNAL_LP_EXT, FALSE) then result := result + EXTERNAL_LP_EXT;
//			runtime_debug(str_page_ID + ' <<<< '+ result, 'sostituzione GPL', RD_DEBUG_ACCESSORIO_01);
			writeln_system_debug(200, RUNTIME_DEBUG_CAPTION, str_page_ID + '=' + result);
			exit
		end
	end
end;

function cl_logical_page_info.get_printer_size_constraints : printer_size_constraints_data_type;
begin
	if (printer_size_constraints_mode = PSC_REPORT_DEFAULT) then result := globale.printer_size_constraints
	else result := printer_size_constraints_phisical_values
end;

function cl_logical_page_info.calculate_dont_print : boolean;
// TRUE se la pagina è esclusa dalla stampa (non viene mostrata neanche in anteprima)
begin
{$ifdef DLL}
	if bo_dont_print_phisical then result := TRUE
	else if (str_condizione_esecuzione = '') then result := FALSE
	else begin
		var bo : boolean;
		var s := str_condizione_esecuzione;
		if interpreta_boolean_expression(str_condizione_esecuzione, {test}FALSE, bo, s) then result := NOT bo
		else result := FALSE
	end
{$else}
	result := bo_dont_print_phisical
{$endif DLL}
end;

// ---- cl_macro_parametrica ---------------------------------------------------

constructor cl_macro_parametrica.create(str_testo_macro : string;bo_test : boolean);
var str_originale, str_parm : string;	//*
begin
	str_originale := str_testo_macro;

	str_nome := get_first_delimited(str_testo_macro, '(');
	if (str_nome = str_testo_macro) then raise exception.create(str_originale + ': definizione macro non valida');
	str_testo_macro := delete_delimited(str_testo_macro, str_nome, FALSE, '(');
	str_nome := uppercase(str_nome);

	// leggo i parametri
	while get_parm(str_testo_macro, str_parm) do begin
		setLength(parms, length(parms) + 1);
		if bo_test AND start_with(str_parm, '#') then
			MessageBBox(0, 'Macro <' + str_nome + '> : il parametro non dovrebbe iniziare con #', MBOX_CAPTION);
		parms[high(parms)] := str_parm
	end;
	str_testo_macro := togliblanks(str_testo_macro);
	if (copy(str_testo_macro,1,1) <> '=') then raise exception.create(str_originale + ': manca il segno di UGUALE');
	str_macro := togliblanks(copy(str_testo_macro, 2, MAXINT));

	{$ifdef DEBUG} inc(i_macro_parametrica) {$endif}	// alla fine !!!
end;

destructor cl_macro_parametrica.free;
begin
	{$ifdef DEBUG} dec(i_macro_parametrica); {$endif}
	parms := NIL
end;

// ################################## TGlobale ####################################################################

{$ifdef DLL}

constructor TGlobale.create_dll(father : TForm;i_job : smallint;str_author : string);
const MBOX_DEBUG_CAPTION = 'TGlobale.create_dll()';
begin
	bo_dll := TRUE;
	runtime_debug('pre', MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
//	inherited create(father);
	init(father, i_job, str_author);
	runtime_debug('after', MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00)
end;

{$else NOT DLL}

constructor TGlobale.create_galateo(father : TForm);
begin
//	bo_dll := FALSE;
//	inherited create(father);
//	GH := handle;
	globale := self;
	init(father, 1, 'feacio')
end;

{$endif DLL}

procedure TGlobale.init_banali;
// inizializzazioni non di concetto, ovvero banali
begin
	wo_versione_read := GALATEO_VERSION;		// default: ad esempio per documenti nuovi
//	application.helpfile := GALATEO_HELP_FILE;
	tstr_remarks := TStringList.create;
	phisical_system_database := create_database(father, TI_READ, {start_trans}FALSE, {debug}TRUE, {aliasname}'', {conn_name}DB_GALATEO_NAME, {ask_parms}XFALSE,
		{connect}FALSE, {auto_reconnect}TRUE);
//	db_galateo.Connected := FALSE;
//	db_galateo.Name := DB_GALATEO_NAME;db_galateo.DatabaseName := DB_GALATEO_NAME;
	str_password_edit := '';str_password_exec := '';
	i_numero_copie_default := 1;
	bo_first_print := TRUE;
	bo_log_parametri := FALSE;
	SQL_reexecute_scripts := SQLRSO_ALWAYS_REEXECUTE;
	bo_show_immagini_sfondo := TRUE;
	if (connection_config = NIL) then connection_config := cl_connection_configuration.create(father) else connection_config.clear;
{$ifdef DLL}
	bo_main_info_user_messages_displayed := FALSE;
	str_runtime_mail_user_message := '';
	bo_warning_on_multiple_mail_addresses := FALSE;
{$else}
	i_impostazioni_pageindex := 0;i_impostazioni_SQLscripts_pageindex := 0;i_impostazioni_macro_scripts_pageindex := 0;
	i_impostazioni_export_pageindex := 0;i_impostazioni_mail_pageindex := 0;
{$endif}
//	str_macro_parametriche := '';
	free_macro_parametriche;
	bo_show_index := FALSE;bo_create_index := FALSE;
	bo_allow_saving_runtime_pos := FALSE;
	bo_autosize_page := TRUE;i_printer_reference_height_10mm := 0;
//	i_default_expint_profile := 0;
	i_active_expint_profile := 0;
//	i_jpeg_compression_quality := JPG_DEFAULT_COMPRESSION_QUALITY;i_jpeg_percentuale := 100;
	bo_use_compressed_bmps := TRUE;
	bo_FTP_conferma := FALSE;str_FTP_password := '';str_FTP_message := '';
	for var ts := low(text_script_type) to high(text_script_type) do
		if (text_scripts[ts] = NIL) then text_scripts[ts] := cl_text_scripts.create(ts) else text_scripts[ts].reset;

//	for i := 0 to SQL_PRE_SCRIPTS_NUMBER-1 do str_scripts_pre[i] := '';
//	for i := 0 to SQL_POST_SCRIPTS_NUMBER-1 do str_scripts_post_descr[i] := '';
//	str_script_remarks := '';
	for var i : smallint := 1 to MAX_PAGINE_LOGICHE do lpZB_info[i - 1] := cl_logical_page_info.create(i);
	str_default_date_format := '';str_default_time_format := '';
	{$ifndef DLL} salvataggi := TStringList.create; {$endif}
	tsql_stored_procs_definition := TStringlist.create;
	bo_GAPP_ask_conferma_stampa_definitiva := TRUE;str_GAPP_password_stampa_definitiva := '';
	table_colori_symbolici.clear;
	text_only_font := TFont.Create	// creare sempre !!!
end;

procedure TGlobale.init_values;
// inizializzazioni di concetto, ovvero non banali
begin
	i_pagine_logiche := 1;
//	bo_report := {$ifdef REPORT_GENERATOR} TRUE {$else} FALSE {$endif};
	tiporeport := {$ifdef REPORT_GENERATOR} TR_REPORT {$else} TR_LABEL_STANDALONE {$endif};
//	tm.set_report(bo_report);
	tm.set_report(tiporeport);
	randomize;lo_key_sessione := random(10000000);
	bo_griglia_vtabs := TRUE;i_griglia_vtabs := INI_MAGLIA_GRIGLIA_VTABS_DEFAULT;
	bo_text_only := FALSE;
	bo_show_time_esecuzione := FALSE;

	send_mail_modalita_standard_galateo_ph := GSMM_DEFAULT;
	xsend_mail_modalita_calling_program := GSMM_BLANK;
	send_mail_modalita_runtime_user := GSMM_BLANK;

	{str_struttura_XML := '';}str_XML_header_runtime := NIL;str_struttura_XML_runtime := NIL;bo_XML_structure_debug_info := FALSE;
	bo_export_allowed := TRUE;bo_export_set_default := FALSE;bo_export_proponi := FALSE;bo_export_execute_automatically := FALSE;
//	expint_default_target := succ(EITT_DEFAULT);		// non può mai essere EITT_DEFAULT *** fino 2015-04-18
//	expint_default_target_backward_compatibility := export_integrale_target_type(0);
//	export_default_file_writemode := succ(FWT_DEFAULT);		// non può mai essere FWT_DEFAULT
//	export_default_file_writemode_backward_compatibility := low(file_writemode_type);

{	lo_expint_max_lines := 0;expint_separatore := EIS_TAB;
	str_message_before := '';str_message_after := '';str_comando_specifico_default := '';
	target_default := export_integrale_target_type(0);
	EFAT_default_action := EFAT_DEFAULT; }

	expint_profilo_array_free(expint_profiles);		// restituisco eventuali profili già esistenti
	setLength(expint_profiles, 1);
	expint_profiles[0] := cl_expint_profilo.create;
	expint_profiles[0].str_codice := 'default';

	if (FTP_parms = NIL) then FTP_parms := cl_FTP_parms.create else FTP_parms.clear;

	str_export_filename := '';bo_overwrite_file := FALSE;str_expint_export_filename := '';
	bo_auto_email := FALSE;bo_address_required := FALSE;
	str_condizione_auto_email := '';
	str_subject := '';str_text := '';
	str_message_opening_print := '';
	indirizzi_email_default := [];indirizzi_email_elenco := [];bo_load_indirizzo_main_when_unique := TRUE;
	str_indirizzi_email_default_internal := '';str_indirizzi_email_elenco_internal := '';
	bo_indirizzi_email_default_SQL := FALSE;bo_indirizzi_email_elenco_SQL := FALSE;
	str_email_default_runtime := '';
	for var x : mail_target_type := low(x) to high(x) do str_email_elenco_runtime[x] := '';
//	str_email_default_local_computed := '';str_email_elenco_local_computed := '';
	str_documento_informativo_utente := '';str_technical_reference := '';str_links_utente := '';
	str_lingua_object := '';str_lingua_contesto := '';
	fillchar(printer_size_constraints, sizeof(printer_size_constraints), 0);

	comportamento_when_null := CWNT_STANDARD;
	str_value_when_null_text := '';str_value_when_null_numeric := '';

	runtime_groupboxes_free(runtime_gboxes);
	setLength(runtime_gboxes, 1);runtime_gboxes[0]:= cl_runtime_groupbox.Create;

	if (PDF = NIL) then PDF := cl_PDF.create else PDF.init
end;

procedure TGlobale.init_form(form : TForm);
begin
	{$ifdef DEBUG} assert(NOT phisical_system_database.Connected, ''); {$endif}
//	if silent_mode then form.Visible := FALSE;	****
	var handle := 0;
	if (form <> NIL) then handle := form.Handle;
//	if NOT tm.init_video_values(getDC(form.Handle), 1) then begin
	if NOT tm.init_video_values(getDC(Handle), 1) then begin
{		video_setup_proc(self,FALSE);
		if (tm.init_video_values(getdc(handle),1)) then
			MessageBBox(handle,'Esegui nuovamente ' + PROGRAM_NAME + ' per rendere operative le impostazioni fornite.',
				MBOX_CAPTION)
		else MessageBBox(handle,'Non è possibile proseguire senza l''indicazione delle misure dello schermo',
				MBOX_CAPTION); }
		halt(1)
	end;

	try
		{$ifndef DLL} GM.sbox.Visible := FALSE; {$endif}
{		for var i : smallint := 1 to MAX_PAGINE_LOGICHE do begin
			set_pagina_logica_attiva_1B(i, FALSE);
			assign_section_ZB(MAIN_SECTION_ZB, cl_sezione.create(MAIN_SECTION, 0, i));
			set_num_sections(MAIN_SECTION);
			set_main_section_values
		end; }
		for var i_ZB : smallint := 0 to MAX_PAGINE_LOGICHE - 1 do begin
			set_pagina_logica_attiva_ZB(i_ZB, FALSE);
			assign_section_ZB(MAIN_SECTION_ZB, cl_sezione.create_ZB(MAIN_SECTION_ZB, -1, i_ZB));
			set_num_sections(1);
			set_main_section_values
		end;
		set_pagina_logica_attiva_ZB(0, FALSE);
{$ifndef DLL}
		application.OnMessage := program_messages;
		read_parms;
//		if (i_parm_filename <> 0) then load(paramstr(i_parm_filename))
		if (i_parm_filename <> 0) then begin
			var str_filename := paramstr(i_parm_filename);
			if load(father, str_filename) then GM.registra_MRU(str_filename)
		end
{$endif NOT DLL}
	finally
		{$ifndef DLL} GM.sbox.Visible := TRUE {$endif}
	end
end;

procedure TGlobale.init(father : TForm;i_job : smallint;str_author : string);
const MBOX_DEBUG_CAPTION = 'TGlobale.init()';
begin
	{$ifdef DEBUG} inc(i_global); {$endif}
	runtime_debug('start', MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
	i_active_monitor := get_active_monitor(father);		// monitor su cui tutto l'output deve essere indirizzato
	self.i_job := i_job;set_active_job(i_job);
//	{$ifdef DLL} self.str_author := str_author; {$endif}
	{$ifdef DLL} SetString(self.str_author, LPSTR(str_author), length(str_author)); {$endif}
	if (printer.printers.Count = 0) then begin
		MessageBBox(get_handle, 'Please, installa almeno una stampante prima di lanciare GALATEO.', MBOX_CAPTION);
		halt
	end;
	init_banali;
	init_values;
	init_form(father);
	runtime_debug('end', MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00)
end;

destructor Tglobale.freex;
begin
//	{$ifndef DLL} if bo_saved_debug then MessageBBox(handle,DEBUG_MSG[bo_debug_full],MBOX_CAPTION); {$endif}
	free_macro_parametriche;
	runtime_groupboxes_free(runtime_gboxes);
	expint_profilo_array_free(expint_profiles);		// restituisco eventuali profili già esistenti
	if (FTP_parms <> NIL) then begin FTP_parms.free;FTP_parms := NIL end;
	for var tx := low(text_script_type) to high(text_script_type) do
		if (text_scripts[tx] <> NIL) then begin text_scripts[tx].free;text_scripts[tx] := NIL end;
	if (PDF <> NIL) then begin PDF.free;PDF := NIL end;
	free_database(phisical_system_database);
	if (connection_config <> NIL) then begin connection_config.free;connection_config := NIL end;
	for var i : smallint := 0 to MAX_PAGINE_LOGICHE-1 do
		if (lpZB_info[i] <> NIL) then begin lpZB_info[i].free;lpZB_info[i] := NIL end;
	{$ifdef DEBUG} dec(i_global) {$endif}
end;

function TGlobale.set_main_form(new_main_form : TForm) : TForm;
{ poichè SELF non è una vera finestra, ma solo un aborto di finestra, questa function serve per consentire in ogni momento
  di avere un FATHER consistente per eventuali finestre di messaggio;
  la finestra FATHER del report deve segnalare di essere la MAIN_FORM chiamando questa procedure, e deve segnalare di NON ESSERLO più
  assegnando la nuova form (che era probabilmente quella attiva al momento della prima chiamata);
  la funzione rende la MAIN_FORM attiva al momento della chiamata }
begin
	result := self.main_form;
	self.main_form := new_main_form
end;

function TGlobale.load(father : TForm;str_filename : string;str_runtime_load_filenames : string = '') : boolean;
const RUNTIME_DEBUG_CAPTION = 'TGlobale.load()';

	procedure check_pwd(str_password : string;str_caption : string);
	var s : string;	//*
	begin
		if (str_password = '') then exit;
		var bo := FALSE;
		try
			if NOT input_text_proc(father, MBOX_CAPTION, str_caption, s, 0, NIL, IDS_PASSWORD) then exit;
			bo := (asym_password(s) = str_password) OR xpassword_date_dependent(s, 0)
		finally
			if NOT bo then begin
				MessageBBox(father, 'Password non corretta', MBOX_CAPTION, MB_ICONSTOP);
				application.Terminate;halt
			end
		end
	end;

var
	f : system.Text;
	i, {$ifdef DLL} i2, i3, i4, {$endif} i_pagina_att : smallint;
	str_temp, str_macro_parametriche_old, str_message : string;
	s3 : string[3];
	r : real;
	r_delta_labs_X_cm, r_delta_labs_Y_cm : misura_real_type;
	i_lab_per_row, i_lab_per_page : smallint;
	wo_versione : word;
	c : char;
	lo1, lo2 : integer;
//	objx : objs_type;
begin
	bo_loading_file := TRUE;
	bo_exclude_azioni_comunitarie := TRUE;	// escludo movimentazioni e resizing automatici
	{$ifndef DLL} bo_external_file_too_old := FALSE; {$endif}
	{$ifdef GALATEO_EXE} var i_monitor := 0; {$endif}

	try
		result := FALSE;
//		runtime_debug('inizio', RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
		writeln_system_debug(100, RUNTIME_DEBUG_CAPTION, 'start');

		if (str_filename = '') then begin
//			if (str_filename_phisical <> '') then opendlg.InitialDir := ExtractFilePath(str_filename_phisical);	// 2014-08-18
//			if NOT opendlg.execute then exit;str_filename := opendlg.filename
			if NOT browse_for_files_open(father, MBOX_CAPTION, str_filename, DEFAULT_EXT, FILES_FILTER, {str_default_dir}'') then exit
		end
		else begin	// verifico che il nome abbia l'estensione e che sia un nome lungo
			if (pos('.',str_filename) = 0) then str_filename := str_filename + DEFAULT_EXT;
//			MessageBBox(0,str_filename,'FILENAME',0);
			str_temp := ShortToLongFilename(str_filename);
			if (str_temp <> '') then str_filename := str_temp
//			;MessageBBox(0,str_filename,'FILENAME',0)
		end;

		// pare che voglia veramente caricare un file; pulisco le tracce di quello attualmente aperto
{$ifndef DLL}
		obj_select(0,FALSE,FALSE);
		if (i_objs <> 0) OR GM.bo_modified then begin
			nuova_etichetta;
			if GM.bo_modified then exit	// non ha salvato
		end;
{$endif NOT DLL}

		wo_versione_read := GALATEO_VERSION;		// da impostare PRIMA di STR_FILENAME
		self.str_filename := '';
		{$I-} system.assign(f, str_filename);reset(f); {$I+}
		if (IOresult <> 0) then begin
			MessageBBox(father, 'Impossibile aprire il file <' + str_filename + '>', MBOX_CAPTION, MB_ICONSTOP);
			exit
		end;

		{$ifndef DLL} GM.Sbox.Visible := FALSE;GM.Update; {$endif}
//		runtime_debug('110',RUNTIME_DEBUG_CAPTION);
		try
			set_wait_cursor(TRUE);
			readln(f, str_temp);
			if (str_temp <> START_OF_GALATEO_FILE) then begin
				MessageBBox(father, 'Il formato del file non è corretto', MBOX_CAPTION, MB_ICONSTOP);
				exit
			end;
			readln(f, r);	// per adesso trascuro il bittaggio della versione che ha scritto il file
			wo_versione := round(r);if (wo_versione = 1) then wo_versione := $0100;

			if (wo_versione > GALATEO_VERSION) AND NOT accept_future_versions then begin
				MessageBBox(father ,
					'Impossibile leggere il file <' + str_filename + '>' + ACAPO2 +
//					'La versione del file è successiva a quella ' + {$ifdef DLL} 'della libreria CASA.DLL' {$else} 'di GALATEO' {$endif} + ACAPO2 +
					'La versione del file (' + version_of(wo_versione) + ') è successiva a quella ' +
						{$ifdef DLL} 'della libreria CASA.DLL' {$else} 'di GALATEO' {$endif} + ' (' + version_of(GALATEO_VERSION) + ')' + ACAPO2 +
//					{$ifndef DLL} 'eseguibile ' + paramstr(0) + ACAPO + 'release ' + asstring_datetime(FileDateToDateTime(FileAge(paramstr(0)))) + ACAPO2 + {$endif}
					{$ifndef DLL} 'eseguibile ' + paramstr(0) + ACAPO + 'release ' + asstring_datetime(get_file_datetime(paramstr(0))) + ACAPO2 + {$endif}
					'(in apertura schiaccia lo shift per forzare la lettura del file)', MBOX_CAPTION, MB_ICONSTOP);
				abort
			end;
			wo_versione_read := wo_versione;		// imposto la versione del file letto
//			runtime_debug('versione report: ' + wo_versione.ToString, RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
			writeln_system_debug(110, RUNTIME_DEBUG_CAPTION, 'versione report: ' + wo_versione.ToString);
			self.str_filename := str_filename;

//			if (wo_versione_read <= $0303) then begin
			// creo sempre un profilo di exportazione per il caso di external_pages
				expint_profilo_array_free(expint_profiles);		// restituisco eventuali profili già esistenti
				setLength(expint_profiles, 1);
				expint_profiles[0] := cl_expint_profilo.create;
				expint_profiles[0].str_codice := 'default';
//			end;

			tstr_remarks.clear;
			if (wo_versione >= $0103) then begin
				readln(f, str_descrizione_report);
				if (wo_versione >= $0106) then begin
//					runtime_debug('$0106', RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
					writeln_system_debug(120, RUNTIME_DEBUG_CAPTION);
					if NOT load_font_1L(f,text_only_font) then abort;
					readln(f, i_text_only_colonne, i_text_only_righe, i_text_only_cpi, i_text_only_lpi);
				end
				else begin readln(f);readln(f) end;
				readln(f{,str_default_image_filename});
				readln(f, str_default_export_filepath);
{$ifdef DLL}
				readln(f);
{$else}
				readln_LPSTR(f, str_temp);
				salvataggi.Text := shift_alfanumeric(copy(str_temp, 1, length(str_temp)-3));
{$endif DLL}

				TStrings_load(f, tstr_remarks);
//				runtime_debug('Note: '+ TStrings2string(tstr_remarks, ACAPO), RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
				writeln_system_debug(125, RUNTIME_DEBUG_CAPTION);
				readln_LPSTR(f, str_runtime_help);
				runtime_help_font.readln(f);
				for i := 1 to 3 do readln(f)		// righe vuote
			end;

//			runtime_debug('130',RUNTIME_DEBUG_CAPTION,FALSE);
			writeln_system_debug(130, RUNTIME_DEBUG_CAPTION);
			readln(f, r_labsize_x_cm_temp, r_labsize_y_cm_temp, r_marg_sx_cm_temp, r_marg_up_cm_temp,
				i_lab_per_row, i_lab_per_page, r_delta_labs_X_cm, r_delta_labs_Y_cm, str_temp);
//			tm.r_labsize_x_cm := r_labsize_x_cm;
//			tm.r_labsize_y_cm := r_labsize_y_cm;
//			tm.r_marg_sx_cm := r_marg_sx_cm;
//			tm.r_marg_up_cm := r_marg_up_cm;
			tm.i_lab_per_row := i_lab_per_row;
			tm.i_lab_per_page := i_lab_per_page;
			tm.r_delta_labs_X_cm := r_delta_labs_X_cm;
			tm.r_delta_labs_Y_cm := r_delta_labs_Y_cm;
			tm.bo_show_griglia := (togliblanks(str_temp) = 'TRUE');	// istruzione inutile

//			runtime_debug('140', RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
			writeln_system_debug(140, RUNTIME_DEBUG_CAPTION);
			readln(f, str_temp);tm.bo_print_bordo := (togliblanks(str_temp) = 'TRUE');
			readln(f, str_temp);tm.bo_print_pagina_completa := (togliblanks(str_temp) = 'TRUE');

			connection_config.clear;
//			xstr_local_connection_parms := '';bo_login_prompt := FALSE;	// saranno letti più sotto, è comunque importante sblankare
{			readln(f, str_db_driveralias);
			i := pos(' ', str_db_driveralias);
			str_db_table := copy(str_db_driveralias, i+1, MAXINT);delete(str_db_driveralias, i, MAXINT); }
			if (wo_versione <= $0402) then begin
				readln(f, str_temp);
				i := pos(' ', str_temp);
	//			str_db_table := copy(s, i+1, MAXINT);//delete(s, i, MAXINT);
				connection_config.str_table := copy(str_temp, i+1, MAXINT);//delete(s, i, MAXINT);
			end;
			phisical_system_database.Connected := FALSE;

			readln(f, str_db_field_default);
			readln(f, printer_default[0].str_printer);
//			select_printer(str_printer);
			readln(f, str_temp);
//			bo_report := (s = 'TRUE');
			if (str_temp = 'TRUE') then tiporeport := TR_REPORT
			else if (str_temp = 'FALSE') then tiporeport := TR_LABEL_STANDALONE
			else tiporeport := REPORT_TYPE(strtoint(str_temp));
			if eoln(f) then begin
				bo_griglia_vtabs := TRUE;
				i_griglia_vtabs := INI_MAGLIA_GRIGLIA_VTABS_DEFAULT;
				i_pagina_att := 1
			end
			else read(f, byte(bo_griglia_vtabs), i_griglia_vtabs, i_pagina_att);
			{ se è schiacciato uno shift, annullo l'opzione di tabulazione;
			  questa possibilità può servire quando si passa ad un computer con impostazioni differenti }
			bo_griglia_vtabs := bo_griglia_vtabs AND NOT is_key_down(VK_SHIFT);

			readln(f);

//			runtime_debug('150',RUNTIME_DEBUG_CAPTION,FALSE);
//			writeln_system_debug(, RUNTIME_DEBUG_CAPTION, );
			// opzioni di vario tipo
			bo_text_only := FALSE;bo_show_time_esecuzione := FALSE;//bo_alias := FALSE;
			bo_use_transaction := FALSE;bo_commit_transaction := FALSE;isolation_level := xiDirtyRead;
			bo_phisical_debug_base := FALSE;bo_phisical_debug_full := FALSE;bo_debug_delete_everytime := FALSE;
			bo_log_registro_eventi := FALSE;bo_log_file := FALSE;bo_silent_mode_phisical := FALSE;bo_exclude_runtime_message_report := FALSE;
			str_debug_computer := '';
			bo_orizzontale_old_version := FALSE;
			box_new_valutazione_scostamento := XNOTHING;
			bo_pausa_pagina := FALSE;str_pausa_pagina_message := '';i_durata_pausa_pagina_msec := 0;
			bo_show_hidden_objects := TRUE;
			bo_show_index := FALSE;bo_create_index := FALSE;bo_autosize_page := TRUE;
//			i_jpeg_compression_quality := JPG_DEFAULT_COMPRESSION_QUALITY;i_jpeg_percentuale := 100;
			bo_force_font_exist := TRUE;
			bo_use_compressed_bmps := TRUE;bo_log_parametri := FALSE;
			SQL_reexecute_scripts := SQLRSO_ALWAYS_REEXECUTE;
//			bo_login_prompt := FALSE;
			{str_struttura_XML := '';}{str_struttura_XML_runtime := '';}bo_XML_structure_debug_info := FALSE;
			bo_export_allowed := TRUE;bo_export_set_default := FALSE;bo_export_proponi := FALSE;bo_export_execute_automatically := FALSE;
//			expint_default_target := succ(EITT_DEFAULT);		// non può mai essere EITT_DEFAULT *** fino 2015-04-18
			expint_default_target_backward_compatibility := low(export_integrale_target_type);
//			export_default_file_writemode := succ(FWT_DEFAULT);		// non può mai essere FWT_DEFAULT
			export_default_file_writemode_backward_compatibility := low(file_writemode_type);
//			target_default := export_integrale_target_type(0);
//			EFAT_default_action := EFAT_DEFAULT;
			print_diretta := PDS_DIALOG;
			azione_opening_report_phisical := AORT_POPT_DEFAULT;
			azione_printer_unknown := azione_printer_unknown_type(0);
			azione_after_print := AAPT_NOTHING;
			if (wo_versione <= $0301) AND (printer_default[0].str_printer <> '') then modalita_selezione_default_printer := DPST_GALATEO
			else modalita_selezione_default_printer := DPST_SYSTEM_DEFAULT;

			while not eoln(f) do begin
				read(f, c);
				case c of
					'A' : bo_text_only := TRUE;
					'B' : {bo_alias := TRUE};
					'C' : bo_commit_transaction := TRUE;
					'D' : bo_phisical_debug_base := TRUE;
					'd' : bo_phisical_debug_full := TRUE;
					'E' : bo_use_compressed_bmps := FALSE;
					'F' : bo_force_font_exist := FALSE;
					'H' : bo_orizzontale_old_version := TRUE;
					'I' : bo_show_index := TRUE;
					'K' : bo_create_index := TRUE;
					'l' : connection_config.bo_login_prompt := TRUE;		// fino alla versione $0402 compresa
					'L' : bo_log_parametri := TRUE;
					'J' : begin read(f,s3){;i_jpeg_compression_quality := strtoint(s3)} end;
					'P' : begin read(f,s3){;i_jpeg_percentuale := strtoint(s3)} end;
					'R' : bo_autosize_page := FALSE;
					'S' : bo_show_hidden_objects := FALSE;
					'T' : bo_use_transaction := TRUE;
					'U' : begin
						{$ifdef DEBUG} assert(wo_versione <= $0303, 'DKIW 3123'); {$endif}
						read(f, c);expint_profiles[0].target_default := export_integrale_target_type(byte(c) - byte('0'))
					end;
					'V' : begin
						{$ifdef DEBUG} assert(wo_versione <= $0303, 'DKIW 3123'); {$endif}
						read(f, c);expint_profiles[0].EFAT_default_action := export_file_action_type(byte(c) - byte('0'))
					end;
					'Z' : begin read(f, c);modalita_selezione_default_printer := default_printer_selection_type(byte(c) - byte('0')) end;
					't' : begin read(f,c);isolation_level := TFDTxIsolation(byte(c) - byte('0')) end;
					'M' : bo_show_time_esecuzione := TRUE;
					'X' : box_new_valutazione_scostamento := XFALSE;
					'x' : box_new_valutazione_scostamento := XTRUE;
					'y' : {bo_XML_allowed := FALSE};		// mantengo per backward-compatibility
					'a' : bo_export_allowed := FALSE;
					'b' : bo_export_set_default := TRUE;
					'c' : bo_export_proponi := TRUE;
					'e' : bo_debug_delete_everytime := TRUE;
					'f' : print_diretta := PDS_DIRETTA;
					'g' : begin read(f, c);azione_opening_report_phisical := azione_opening_report_type(byte(c) - byte('0')) end;
					'h' : begin read(f, c);azione_after_print := azione_after_print_type(byte(c) - byte('0')) end;
					'i' : bo_export_execute_automatically := TRUE;
					'j' : begin read(f, c);azione_printer_unknown := azione_printer_unknown_type(byte(c) - byte('0')) end;
					'k' : begin
						read(f, c);
//						expint_default_target := export_integrale_target_type(byte(c) - byte('0')) end; **** fino 2015-04-18
						{$ifdef DEBUG} assert(wo_versione <= $0321, 'export_integrale_target_type() -- MMHP 3881'); {$endif}
						expint_default_target_backward_compatibility := export_integrale_target_type(byte(c) - byte('1'))	// si sconta il valore 0 (EITT_DEFAULT) che è stato rimosso
					end;
					'm' : begin
						read(f, c);
//						export_default_file_writemode := file_writemode_type(byte(c) - byte('0'))	*** fino 2015-04-18
						export_default_file_writemode_backward_compatibility := file_writemode_type(byte(c) - byte('1'))	// si sconta il valore 0 (FWT_DEFAULT) che è stato rimosso
					end;
					'n' : begin read(f, c);SQL_reexecute_scripts := SQL_reexecute_script_options(byte(c) - byte('0')) end;
					'o' : bo_exclude_runtime_message_report := TRUE;
					'p' : bo_pausa_pagina := TRUE;
//					's' : {$ifndef DLL} bo_system_runtime_debug := TRUE {$endif};
					'u' : bo_log_registro_eventi := TRUE;
					'v' : bo_log_file := TRUE;
					'w' : bo_XML_structure_debug_info := TRUE;
					'z' : bo_silent_mode_phisical := TRUE
					else abort
				end
			end;
			if NOT bo_export_set_default then bo_export_proponi := FALSE;	// however
			readln(f);
			bo_commit_transaction := (bo_commit_transaction AND bo_use_transaction);
			bo_show_index := (bo_show_index AND bo_create_index);

			if (wo_versione >= $0107) then begin
//				runtime_debug('$0107', RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
				writeln_system_debug(150, RUNTIME_DEBUG_CAPTION);
(*				for i := ifi(wo_versione <= $0258, 1, 0) to SQL_PRE_SCRIPTS_NUMBER-1 do begin
					if NOT readln_LPSTR(f, str_scripts_pre[i]) then abort;
					j := pos(SEQ_SEP_SQL_SCRIPT_DESCR, str_scripts_pre[i]);
					if (j = 0) then str_scripts_pre_descr[i] := ''
					else begin
						str_scripts_pre_descr[i] := copy(str_scripts_pre[i], j + length(SEQ_SEP_SQL_SCRIPT_DESCR), MAXINT);
						delete(str_scripts_pre[i],j,MAXINT)
					end
				end;
				for i := 0 to SQL_POST_SCRIPTS_NUMBER-1 do begin
					if NOT readln_LPSTR(f,str_scripts_post[i]) then abort;
					j := pos(SEQ_SEP_SQL_SCRIPT_DESCR,str_scripts_post[i]);
					if (j = 0) then str_scripts_post_descr[i] := ''
					else begin
						str_scripts_post_descr[i] := copy(str_scripts_post[i],j + length(SEQ_SEP_SQL_SCRIPT_DESCR), MAXINT);
						delete(str_scripts_post[i], j, MAXINT)
					end
				end; *)

				if (wo_versione < $030A) then begin
					text_scripts[TST_SQLS_EARLY].i_numero := 1;
					if (wo_versione > $0258) then text_scripts[TST_SQLS_EARLY].read_old(f, 0);
					text_scripts[TST_SQLS_BEFORE].i_numero := 3;
					for i := 0 to text_scripts[TST_SQLS_BEFORE].i_numero-1 do text_scripts[TST_SQLS_BEFORE].read_old(f, i);
					text_scripts[TST_SQLS_AFTER].i_numero := 1;
					for i := 0 to text_scripts[TST_SQLS_AFTER].i_numero-1 do text_scripts[TST_SQLS_AFTER].read_old(f, i)
				end;

				if NOT read_TStrings(f, tsql_stored_procs_definition) then abort;
				load_stored_procs(tsql_stored_procs_definition, TRUE);	// emetto eventuali messaggi, ma non prendo contromisure
				readln(f, printer_default[1].str_printer);
				if (wo_versione >= $020E) then read(f, i_numero_copie_default) else i_numero_copie_default := 1;
				readln(f);
				readln(f, printer_default[0].str_cassetto);
				readln(f, printer_default[1].str_cassetto);
				// forzatura delle dimensioni del foglio fisico di carta
				readln(f, str_temp);
				if (str_temp = '') then begin i_forced_width_10mm := 0;i_forced_height_10mm := 0 end
				else begin
					i := pos(' ', str_temp);
					i_forced_width_10mm := strtoint(copy(str_temp, 1, i-1));
					i_forced_height_10mm := strtoint(copy(str_temp, i+1, 255))
				end;
				if (wo_versione >= $0220) then begin
					readln(f, c);
					bo_usa_sempre_printer_report := SQL2bool(c)
				end
				else begin
					readln(f);
					bo_usa_sempre_printer_report := FALSE
				end;
				readln(f, str_temp);if (str_temp = '') then i_printer_reference_height_10mm := 0 else i_printer_reference_height_10mm := strtoint(str_temp);
				if (wo_versione <= $0402) then begin
					readln_LPSTR(f, str_temp);	// dalla versione $023B
					if (wo_versione > $0255) then str_temp := stringa2hex_decode(str_temp, TRUE);
					connection_config.str_parametri_connessione := str_temp
				end;
				readln_LPSTR(f, str_pausa_pagina_message);		// dalla versione $0328
				readln(f)
			end;
			if NOT PDF_load(f, wo_versione) then abort;
			if (wo_versione >= $023C) then begin
				readln_LPSTR(f, str_macro_parametriche_old);
//				readln_LPSTR(f, str_macro_parametriche);build_macro_parametriche(FALSE);		*** commentato 2018-07-08

				readln(f, str_temp);											// 2006-04-05
				if (str_temp <> '') then begin
					bo_GAPP_ask_conferma_stampa_definitiva := SQL2bool(str_temp[1]);
					// lascio spazio per altre opzioni
					str_GAPP_password_stampa_definitiva := copy(str_temp, 11, MAXINT)
				end;
				readln(f, str_debug_computer);
{$ifdef DLL}
				if bo_debug_base AND (str_debug_computer <> '')
					then bo_phisical_debug_base := (uppercase(get_computer_name) = str_debug_computer);		// name is always uppercase
{$endif DLL}
				if (wo_versione <= $0303) then begin
					readln_LPSTR(f, expint_profiles[0].str_message_after);
					readln(f, expint_profiles[0].str_comando_specifico_default)
				end;
//				readln_LPSTR(f, str_script_remarks);	** fino alla ver $0309, 2012-11-01
				readln(f);
				readln(f, str_default_date_format);
				{$ifdef DLL} if (str_default_date_format = '') then str_default_date_format := SYSTEM_DEFAULT_DATE_FORMAT; {$endif}
				readln(f, str_default_time_format);
				{$ifdef DLL} if (str_default_time_format = '') then str_default_time_format := SYSTEM_DEFAULT_TIME_FORMAT; {$endif}
				if (wo_versione <= $0303) then readln_LPSTR(f, expint_profiles[0].str_message_before);

				if (wo_versione > $0251) then begin
					readln(f, str_export_filename);	// prima era salvato nelle impostazioni PDF
					readln(f, byte(bo_overwrite_file), byte(bo_auto_email), byte(bo_address_required));
					if (wo_versione <= $0301) then readln_LPSTR(f, str_indirizzi_email_elenco_internal);

					readln_LPSTR(f, str_subject);
					readln_LPSTR(f, str_text);
					readln_LPSTR(f, str_condizione_auto_email)
				end;
				if (wo_versione > $0255) then begin
					readln(f, lo_background_parms_caption_color, lo_foreground_parms_caption_color, str_runtime_parms_caption);
					str_runtime_parms_caption := togliblanks(str_runtime_parms_caption)
				end
				else readln(f);

				if eoln(f) then readln(f)
				else begin
					read(f, byte(bo_allow_saving_runtime_pos), lo1, lo2, byte(bo_label_registra_ultima_posizione),
						{$ifdef CASA} i, i2, i3, i4 {$else} i_impostazioni_pageindex, i_impostazioni_SQLscripts_pageindex, i_impostazioni_export_pageindex, i_impostazioni_mail_pageindex {$endif});
					{$ifdef CASA} if (i = 0) then;if (i2 = 0) then;if (i3 = 0) then;if (i4 = 0) then; {$endif}
					if (wo_versione >= $0328) then begin
						read(f, printer_size_constraints.i_min_width_mm, printer_size_constraints.i_min_height_mm,
							printer_size_constraints.i_max_width_mm, printer_size_constraints.i_max_height_mm,
							i_durata_pausa_pagina_msec,		// 2017-08-11
							{$ifdef GALATEO_EXE} i_impostazioni_macro_scripts_pageindex {$else} i {$endif},	// 2018-07-09
							{$ifdef GALATEO_EXE} i_monitor {$else} i2 {$endif},	// 2018-07-09 ver $0404
							byte(send_mail_modalita_standard_galateo_ph)	// 2021-04-18, ver $0405 (prima questo valore esisteva ma non veniva salvato per motivi filosofici -- ma sbagliati)
							{ free place for numbers here ********************* } );
						{$ifdef CASA} if (i = i2) then; {$endif}	// per non far impermalire il compilatore
					end;
					readln(f);
					if (wo_versione <= $0303) then begin
						expint_profiles[0].lo_expint_max_lines := lo1;
						expint_profiles[0].expint_separatore := expint_separatore_type(lo2)
					end
				end;
				readln(f, str_password_edit);
				readln(f, str_password_exec);
				readln(f, str_formato_label);
				readln(f, str_label_skip);

				if (wo_versione <= $0301) then begin
					indirizzi_email_default := [EAT_PRINCIPALE];
					indirizzi_email_elenco := [];
					readln(f);readln(f)
				end
				else begin
					indirizzi_email_default := [];indirizzi_email_elenco := [];
					while NOT eoln(f) do begin read(f, i);indirizzi_email_default := indirizzi_email_default + [email_address_type(i)] end;
					readln(f);
					while NOT eoln(f) do begin read(f, i);indirizzi_email_elenco:= indirizzi_email_elenco + [email_address_type(i)] end;
					readln(f);
					readln_LPSTR(f, str_indirizzi_email_default_internal);
					readln_LPSTR(f, str_indirizzi_email_elenco_internal);
					readln(f, byte(bo_indirizzi_email_default_SQL), byte(bo_indirizzi_email_elenco_SQL), byte(bo_load_indirizzo_main_when_unique));
					if (wo_versione < $0306) then bo_load_indirizzo_main_when_unique := TRUE;		// prima l'opzione non esisteva
					readln(f, str_documento_informativo_utente);	// dalla versione $0309
					readln(f, str_technical_reference);				// dalla versione $0309
					readln(f, str_lingua_object);
					readln(f, str_lingua_contesto);
					readln(f, str_expint_export_filename);
//					readln_LPSTR(f, str_struttura_XML);
//					str_struttura_XML := togli_ACAPO_init_fine(str_struttura_XML);		// escludiamo il caso in cui vi siano solo righe vuote
					readln_LPSTR(f, str_links_utente);		// dalla versione $0323 (da metà versione, a dire il vero)
					{for i := 1 to 1 do} readln(f)
				end
			end;

//			runtime_debug('160',RUNTIME_DEBUG_CAPTION,FALSE);
			writeln_system_debug(160, RUNTIME_DEBUG_CAPTION);
{			if bo_alias then begin
				if (lowercase(db_galateo.Aliasname) <> lowercase(str_db_driveralias)) then db_galateo.Aliasname := str_db_driveralias
			end
			else begin
				if (lowercase(db_galateo.Drivername) <> lowercase(str_db_driveralias)) then db_galateo.Drivername := str_db_driveralias
			end; }
			phisical_system_database.Params.Text := connection_config.get_parametri_connessione;

//			runtime_debug('162',RUNTIME_DEBUG_CAPTION,FALSE);
			writeln_system_debug(161, RUNTIME_DEBUG_CAPTION);
			set_main_section_values;	// imposta i valori per la sezione principale
//			runtime_debug('PRE READ', RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);

			writeln_system_debug(162, RUNTIME_DEBUG_CAPTION);
			if {(wo_versione_read >= $0404) AND} NOT table_colori_symbolici.read(f, wo_versione_read) then abort;

			writeln_system_debug(163, RUNTIME_DEBUG_CAPTION, 'pre read');
//			if bo_report then read_report(f, wo_versione, str_runtime_load_filenames) else read_label(f, wo_versione);
			case tiporeport of
				TR_REPORT, TR_LABEL_REPORT : if NOT read_report(f, wo_versione, str_runtime_load_filenames) then {$ifdef DLL} abort {$endif};
				TR_LABEL_STANDALONE : if NOT read_label(f, wo_versione) then {$ifdef DLL} abort {$endif}
			end;

			read_groupboxes(f, wo_versione);

			if (wo_versione >= $030A) then begin
				str_message := '';
				for i := 0 to byte(high(text_script_type)) do begin
					if (text_script_type(i) = TST_MACRO_PARAMETRICHE) AND (wo_versione < $032D) then begin		// fino alla versione $032D questa voce non esisteva (qui)
						text_scripts[TST_MACRO_PARAMETRICHE].recs[0].str_text := str_macro_parametriche_old;
						continue
					end;
					if NOT text_scripts[text_script_type(i)].read(f, wo_versione, str_temp) then
{$ifdef DLL}
						raise exception.create('Errore durante la lettura degli scripts di testo: ' + str_temp);	// versione $030A
{$else}
						MessageBBox(father, 'Errore durante la lettura degli scripts di testo' + ACAPO2 + str_temp, MBOX_CAPTION, MB_ICONSTOP);
{$endif}
					if (str_temp <> '') then add_delimited(str_message, ACAPO2 + 'tipo di script "' + uppercase(DESCRIZIONE_TEXT_SCRIPT[text_script_type(i)]) + '"' + ACAPO2 + str_temp, ACAPO)
				end;
{$ifndef DLL}
				if (str_message <> '') then
					error_msg(father, 'ATTENZIONE: sono stati segnalati i seguenti problemi durante il caricamento degli scripts' + str_message, MBOX_CAPTION);
{$endif NOT DLL}
				for i := 1 to 5 do readln(f)	// FREEDOM !
			end
			else text_scripts[TST_MACRO_PARAMETRICHE].recs[0].str_text := str_macro_parametriche_old;

			build_macro_parametriche(FALSE);		// trovasi qui dal 2018-07-08

			if (wo_versione_read > $0402) then connection_config.read(f, wo_versione_read);		// a partire dalla versione $0403
			if (wo_versione_read > $0303) then begin
				readln(f, str_message_opening_print);
				for i := 1 to 6 do readln(f);	// FREEDOM !
				readln(f, i);setLength(expint_profiles, i);
				for i := 0 to high(expint_profiles) do
					if (expint_profiles[i] = NIL)		// può essere != NIL ad esempio nel caso di pagina EXTERNAL
						then expint_profiles[i] := cl_expint_profilo.create;

{				// alloco le istanze per le impostazioni di exportazione integrale gli oggetti che sono già stati caricati
				if (length(expint_profiles) > 1) then begin	// 1 istanza è già esistente
					for lo1 := 1 to i_pagine do begin
						for lo2 := 1 to i_objs(lo1) do begin
							objx := xobjs(lo2, lo1);
							if (objx.tipo_oggetto in EXPINT_OBJS) then objx.aslabel.init_expint		// non è distruttivo, agisce solo se non ancora inizializzato
						end
					end
				end; }

				for i := 0 to high(expint_profiles) do expint_profiles[i].read(f, i, i_pagine_logiche, wo_versione);
				if (wo_versione >= $030B) then FTP_parms.read(f);

				readln(f, str_temp);			// 2013-03-23
				bo_FTP_conferma := (str_temp <> '') AND SQL2bool(str_temp[1]);
				str_FTP_password := copy(str_temp, 2, MAXINT);
				readln_LPSTR(f, str_FTP_message);

				readln(f, str_temp);
				if (wo_versione >= $0326) then begin
					comportamento_when_null := comportamento_when_null_type(StrToInt(str_temp[1]));
					str_value_when_null_text := copy(str_temp, 2, MAXINT);
					readln(f, str_value_when_null_numeric);
					if (wo_versione >= $0328) then read(f,
						printer_size_constraints.i_min_width_mm, printer_size_constraints.i_min_height_mm,
						printer_size_constraints.i_max_width_mm, printer_size_constraints.i_max_height_mm);
					for i := 1 to 12 do readln(f)		// FREEDOM ! (aggiunti 2016-07-03 a partire dalla versione $0326
				end;

				readln(f, str_temp);
				{$ifdef DEBUG} assert(str_temp = END_OF_GALATEO_FILE, 'errore a fine file KJJE 3912'); {$endif}
			end;

//			select_printer(printer_default[0].str_printer);
			select_printer(get_default_printer(TRUE));
			autosize_printer_page;

//			runtime_debug('POST READ', RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
			writeln_system_debug(180, RUNTIME_DEBUG_CAPTION);
			{$ifdef DEBUG} if NOT eof(f) then MessageBBox(father, 'File non terminato', 'Debug message', MB_SYSTEMMODAL); {$endif}
			system.close(f);
//			runtime_debug('190', RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
			writeln_system_debug(190, RUNTIME_DEBUG_CAPTION);
			{$ifndef DLL} GM.set_disegno_values; {$endif}
			init_after_loading;
			set_pagina_logica_attiva_1B(i_pagina_att, TRUE, TRUE);

//			runtime_debug('fine', RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
			writeln_system_debug(200, RUNTIME_DEBUG_CAPTION, 'fine');

			if (wo_versione < $030D) then begin	// fino alla versione $030D il flag BO_HIDE_PAGE si trovava sulla prima sezione di ciascuna pagina
				for i := 0 to get_ultima_pagina_logica - 1 do begin
					if sections_ZB(0, i).bo_dont_print_section then begin
						lpZB_info[i].bo_dont_print_phisical := TRUE;
						sections_ZB(0, i).bo_dont_print_section := FALSE
					end
				end
			end;

			{$ifdef GALATEO_EXE} if (screen.MonitorCount > 1) AND (i_monitor <> -1) AND (GM <> NIL) then SendWindowToMonitor(GM, i_monitor); {$endif}
{$ifdef DLL}
			check_pwd(str_password_exec, 'password di esecuzione report');
{$else}
			check_pwd(str_password_edit, 'password di accesso');
			GM.bo_modified := FALSE;
{$endif DLL}
			result := TRUE
		except
//			runtime_debug('exception', RUNTIME_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
			writeln_system_debug(900, RUNTIME_DEBUG_CAPTION, 'except' + ACAPO + get_last_exception_msg);
			MessageBBox(father, 'Lettura file fallita' + ACAPO + get_last_exception_msg, MBOX_CAPTION, MB_ICONSTOP);
			set_num_objs(0)
		end;
{$ifndef DLL}
		if bo_external_file_too_old then
			MessageBBox(father, 'ATTENZIONE: non sarà possibile modificare il modulo di stampa <' + str_filename +
				'> perchè la versione di almeno uno tra i files esterni con cui si trova ad essere associato è troppo vecchia.',
				MBOX_CAPTION);
		GM.Sbox.Visible := TRUE;
{$endif NOT DLL}
		set_wait_cursor(FALSE);
//		if bo_debug_base then MessageBBox(father, DEBUG_MSG[bo_debug_full] + ifs(str_debug_computer, ' [' + str_debug_computer + ']'), MBOX_CAPTION)
		{$ifndef DLL} debug_message(father) {$endif}	// se DLL il messaggio viene emesso dalla PRINT_REPORT (per poter gestire anche l'attivazione a runtime della modalità di debug)
	finally
		set_report_debug(bo_phisical_debug_base OR bo_phisical_debug_full);
		{$ifndef DLL} bo_saved_debug := bo_debug_base; {$endif}
		bo_loading_file := FALSE;
		bo_exclude_azioni_comunitarie := FALSE
	end
end;

function Tglobale.read_label(var f : system.Text;wo_versione : word) : boolean;
var
	c : char;					//*
	r : misura_real_type;	//*
	i : obj_index_type;		//*
begin
	readln(f, i);
	for var j : obj_index_type := 1 to i do read_object_ZB(f, j, {logical_page_ZB}0, MAIN_SECTION_ZB, wo_versione);
	set_num_objs(i);
	if NOT eof(f) then sections_ZB(MAIN_SECTION_ZB).read(f, wo_versione);	// una versione preliminare non scriveva la MAIN SECTION
	if (wo_versione >= $0214) then begin
//		read(f, r);set_page_size_X_cm(1,r);
		read(f, r);set_label_size_X_cm(r);
//		read(f, r);set_page_size_Y_cm(1,r);
		read(f, r);set_label_size_Y_cm(r);
		read(f, r);set_page_marg_SX_cm_ZB(0, r);
		read(f, r);set_page_marg_UP_cm_ZB(0, r);
		readln(f);
		if (wo_versione >= $0255) then begin
			readln(f, c, r_labsize_x_cm_temp, r_labsize_y_cm_temp);
			assign_orizzontale_ZB({pagina}0, SQL2bool(c));
			set_PHpage_size_X_cm_ZB({pagina}0, r_labsize_x_cm_temp);
			set_PHpage_size_Y_cm_ZB({pagina}0, r_labsize_y_cm_temp);
			if NOT read_profiles({pagina}1, f) then abort
		end;
		for i := 1 to 12 do readln(f)
	end;
	result := TRUE
end;

function TGlobale.read_pagina_logica_attiva(var f : system.Text;var wo_versione : word;bo_external : boolean;str_runtime_load_filenames : string = '') : boolean;
{ legge la pagina logica corrente dal file specificato; rende TRUE in caso di successo;
  if BO_EXTERNAL_FILENAME si tratta di lettura da un file esterno }
const RUNTIME_DEBUG_CAPTION = 'read_pagina_logica_attiva()';
var
	c : char;
	i, i_sections, i_pagina_ZB : smallint;
	bo : boolean;
	s : string;
	f1, f2 : double;
	xp : cl_logical_page_info;
	bo_exp_created : boolean;
	exp : cl_expint_page;
begin
	i_pagina_ZB := get_pagina_logica_attiva_ZB;
	xp := lpZB_info[i_pagina_ZB];
	bo_exp_created := FALSE;
	if (wo_versione > $0303) then exp := NIL else
	if (expint_profiles = NIL)
		OR (expint_profiles[0].expint_pages[i_pagina_ZB] = NIL)		// clausola aggiunta 2012-04-25, per il caso di pagina external di versione precedente al $0303
	then begin
		bo_exp_created := TRUE;
		exp := cl_expint_page.ZB_create(i_pagina_ZB);
//		MessageBBox(handle, 'Le impostazioni di exportazione integrale per la pagina ' + i_pagina.ToString + ' (caricata da file externo) saranno trascurate', MBOX_CAPTION, MB_ICONINFORMATION)
	end
	else exp := expint_profiles[0].expint_pages[i_pagina_ZB];	// EXP può restare comunque NIL, ma è garantito che in questo caso non venga utilizzato
	try
//		runtime_debug('110','READ_PAGINA_LOGICA_ATTIVA()',FALSE);
		writeln_system_debug(110, RUNTIME_DEBUG_CAPTION, 'str_runtime_load_filenames=' + str_runtime_load_filenames);
		if (wo_versione > $0104) then begin
//			readln(f, xp.str_sigla);
//			if (wo_versione <= $0303) then readln(f, expint_profiles[0].expint_pages[i_pagina - 1].str_sigla);
			if (wo_versione <= $0303) then readln(f, exp.str_sigla);
			if (wo_versione > $0304) then readln(f);		// necessario per backward compatibility
			readln(f);readln(f);
			if NOT bo_external then begin
				readln(f, c, xp.str_external_filename);
				xp.bo_external := SQL2bool(c);
				if (wo_versione > $0232) then begin
					readln(f, xp.str_page_ID);
					readln(f, s);xp.bo_message_if_not_printed := (s <> SQL_FALSE);
//					readln(f);
					for i := 1 to 3 do readln(f)
				end;
				writeln_system_debug(112, RUNTIME_DEBUG_CAPTION);
				if xp.bo_external then begin	// file esterno contenente la pagina logica
//					result := read_pagina_logica_external(xp.str_external_filename);
					s := xp.sostituisci_filename(str_runtime_load_filenames);
					writeln_system_debug(115, RUNTIME_DEBUG_CAPTION, 'before read <' + s + '>');
					result := read_pagina_logica_external(s, i_pagina_ZB + 1);
					writeln_system_debug(116, RUNTIME_DEBUG_CAPTION, 'after read <' + s + '>');
					for i := 1 to 7 do readln(f);
					exit
				end
			end
		end;

//		runtime_debug('120','READ_PAGINA_LOGICA_ATTIVA()',FALSE);
		writeln_system_debug(120, RUNTIME_DEBUG_CAPTION);
		if bo_external then begin
			readln(f, wo_versione); 	// rileggo la versione, che tipicamente può essere differente
			xp.wo_external_original_version := wo_versione;		// assegno la versione del file external
			if (wo_versione > GALATEO_VERSION) then begin
				MessageBBox(get_handle, 'La versione di <' + xp.str_external_filename + '> è troppo avanti.' + ACAPO2 +
					'Per poterla utilizzare è necessario aggiornare il programma', MBOX_CAPTION, MB_ICONSTOP);
				abort
			end;
			readln(f, xp.str_last_saved_by_main_report);
			for i := 1 to 11 do readln(f)	// future implementation (external file only)
		end;

		i_sections := 1;
		if (wo_versione > $0101) then begin
//			runtime_debug('130','READ_PAGINA_LOGICA_ATTIVA()',FALSE);
			writeln_system_debug(130, RUNTIME_DEBUG_CAPTION);
			readln(f, i_sections);
			readln(f, xp.str_descrizione_estesa);

			if (wo_versione >= $0220) then begin
				readln(f, c);assign_orizzontale_ZB(i_pagina_ZB, SQL2bool(c));
				readln(f, r_labsize_x_cm_temp, r_labsize_y_cm_temp);
				set_PHpage_size_X_cm_ZB(i_pagina_ZB, r_labsize_x_cm_temp);
				set_PHpage_size_Y_cm_ZB(i_pagina_ZB, r_labsize_y_cm_temp);
				if NOT read_profiles(i_pagina_ZB + 1, f) then abort
			end
			else begin
				if (wo_versione > $020C) then begin
					readln(f,c);bo := SQL2bool(c);
					readln(f, r_labsize_x_cm_temp, r_labsize_y_cm_temp, r_marg_sx_cm_temp, r_marg_up_cm_temp)
				end
				else begin
					{$ifndef DLL}
						bo_external_file_too_old := bo_external;	// impossibile modificare e salvare il file se la pagina externa è così datata
					{$endif}
					readln(f);readln(f);
					bo := bo_orizzontale_old_version	// vecchia modalità, unica per tutte le pagine logiche
				end;
//				runtime_debug('135','READ_PAGINA_LOGICA_ATTIVA()',FALSE);
				writeln_system_debug(135, RUNTIME_DEBUG_CAPTION);
				assign_orizzontale_ZB(i_pagina_ZB, bo);
				set_PHpage_size_X_cm_ZB(i_pagina_ZB, r_labsize_x_cm_temp);
				set_PHpage_size_Y_cm_ZB(i_pagina_ZB, r_labsize_y_cm_temp);
				set_page_marg_SX_cm_ZB(i_pagina_ZB, r_marg_sx_cm_temp);
				set_page_marg_UP_cm_ZB(i_pagina_ZB, r_marg_up_cm_temp);

				if (wo_versione > $020E) then begin
					readln(f, c, s);
					if (c = #0) then;			// riga totalmente inutile che serve per non mostrare la warning sul valore di C
//					xset_flag_printer_pagina_logica(xFGPPL_type(byte(c)-byte('0')),i_pagina);		*** commentato 2011-07-25 perchè il campo non esiste più
					set_printer_page(s, i_pagina_ZB + 1);
					readln(f, s);
					set_cassetto_carta_page(s, i_pagina_ZB + 1)
				end
				else begin readln(f);readln(f) end
			end
		end;

		if (wo_versione > $023B) then begin
			readln(f, xp.str_PDF_watermark);
			readln(f, xp.str_message_if_printed);
			if (tiporeport = TR_LABEL_REPORT) then begin	// solo se (wo_versione > $023F)
				readln(f, f1, f2);
				set_label_size_X_cm(f1);set_label_size_Y_cm(f2);
				readln(f, c);set_draw_lines_separazione_label(c = '1')
			end
			else begin readln(f);readln(f) end;

			if (wo_versione <= $0303) then begin
				if (wo_versione > $0245) then begin
					readln(f, byte(exp.bo_export_allowed), byte(exp.bo_print_pagina_logica), byte(exp.bo_print_sezione),
						byte(exp.bo_print_pagina_fisica), byte(exp.bo_print_record_number), byte(exp.bo_print_headers), byte(exp.bo_blankrow_after_headers));
					exp.bo_blankrow_after_headers := NOT exp.bo_blankrow_after_headers		// storica inversione: il default è 1, ma storicamente era scritto 0
				end
				else readln(f)
			end;
			if (wo_versione > $024C) then readln(f, i, s) else begin i := 1;s := '';readln(f) end;
			set_numero_etichette(i, togliblanks(s));
			readln(f);readln(f)
		end;

(*		if (wo_versione > $023B) then begin
			readln(f,xp.str_PDF_watermark);
			readln(f,xp.str_message_if_printed);
			if (wo_versione > $023F) then begin
				readln(f,f1,f2);
				if (tiporeport = TR_LABEL_REPORT) then begin set_label_size_X_cm(f1);set_label_size_Y_cm(f2) end
			end
			else readln(f);
			readln(f,c);set_draw_lines_separazione_label(c = '1');
			for i := 1 to 4 do readln(f)
		end; *)

//		runtime_debug('150','READ_PAGINA_LOGICA_ATTIVA()',FALSE);
		writeln_system_debug(150, RUNTIME_DEBUG_CAPTION);
{		for i := MAIN_SECTION to i_sections do begin
			read_section(f, i_pagina, i, wo_versione);
			set_num_sections(i)
		end; }
		for var i_ZB := MAIN_SECTION_ZB to i_sections - 1 do begin
			read_section_ZB(f, i_pagina_ZB, i_ZB, wo_versione);
			set_num_sections(i_ZB + 1)
		end;
//		runtime_debug('160','READ_PAGINA_LOGICA_ATTIVA()',FALSE);
		writeln_system_debug(160, RUNTIME_DEBUG_CAPTION);
		if (wo_versione < $023E) then readln(f)
		else readln(f, byte(xp.bo_default_print_page), xp.i_colore_base, xp.i_colore_alt);
		readln(f, xp.str_descrizione_breve);
		readln(f, s);
		xp.bo_attiva_GAPP := SQL2bool(copy(s, 1, 1));
		readln(f, xp.str_GAPP_obj_tipo_progressivo);	// 2006-03-15
		readln(f, xp.str_GAPP_obj_esercizio);			// 2006-03-15
		readln(f, xp.str_GAPP_obj_record);				// 2006-03-15
		readln(f, xp.str_GAPP_obj_dt_riferimento);	// 2006-03-15
		readln(f, xp.str_GAPP_obj_operatore);			// 2006-03-15
//		if (wo_versione >= $030D) then readln(f, byte(xp.bo_dont_print_phisical)) else readln(f);
		if (wo_versione >= $030D) then read(f, byte(xp.bo_dont_print_phisical));
		if (wo_versione >= $0328) then read(f,
			byte(xp.printer_size_constraints_mode),
			xp.printer_size_constraints_phisical_values.i_min_width_mm,
			xp.printer_size_constraints_phisical_values.i_min_height_mm,
			xp.printer_size_constraints_phisical_values.i_max_width_mm,
			xp.printer_size_constraints_phisical_values.i_max_height_mm,
			byte(xp.bo_exclude_debug));
		readln(f);

		readln(f, xp.str_condizione_esecuzione);
		for i := 1 to 10 do readln(f);	// future implementations
		if bo_external then begin
			for i := 1 to 12 do readln(f);	// future implementation (external file only)
			{$ifdef DEBUG} assert(eof(f),'external file non finito') {$endif}
		end;
//		runtime_debug('999','READ_PAGINA_LOGICA_ATTIVA()',FALSE);
		writeln_system_debug(999, RUNTIME_DEBUG_CAPTION);
		result := TRUE
	except
		runtime_debug('*errore*', 'READ_PAGINA_LOGICA_ATTIVA()', RD_DEBUG_PRINCIPALE_00);
		writeln_system_debug(900, RUNTIME_DEBUG_CAPTION, 'exception' + ACAPO + get_last_exception_msg);
		result := FALSE
	end;
	if bo_exp_created then exp.free
end;

function Tglobale.get_modalita_invio_mail : galateo_send_mail_mode_type;
label retry;
begin
{$ifdef DLL}
	result := send_mail_modalita_runtime_user;		// imposto la modalità assegnata runtime dall'utente
//	if (result = MMT_BLANK) then result := send_mail_modalita_calling_program;
	if (result = GSMM_BLANK) then result := send_mail_modalita_standard_galateo_ph;		// se BLANK uso modalità default

retry:
	case result of
		GSMM_BLANK : begin result := GSMM_CALLING_PROGRAM;goto retry end;
		GSMM_CALLING_PROGRAM : begin
			if (xsend_mail_modalita_calling_program = GSMM_BLANK) then result := GSMM_DEFAULT_MAPI_CLIENT
			else begin result := xsend_mail_modalita_calling_program;goto retry end
		end;
//		MMT_DEFAULT_CLIENT : result := MMT_DEFAULT_CLIENT;
//		MMT_LOCAL_SMTP : if NOT valid_SMTP_configuration then begin result := MMT_DEFAULT_CLIENT;goto retry end  *************
//		MMT_LOCAL_SMTP : result := MMT_DEFAULT_CLIENT
		else exit
	end
{$else}
	result := send_mail_modalita_standard_galateo_ph
{$endif DLL}
end;

procedure Tglobale.set_modalita_invio_mail(modalita : galateo_send_mail_mode_type);
begin
	send_mail_modalita_standard_galateo_ph := modalita
end;

function Tglobale.check_scripts_filenames : boolean;
// controlla se vi sono ripetizioni nei filenames usati (opzionalmente) per salvare gli scripts SQL; rende TRUE se tutto ok, FALSE se vi sono problemi
var str_errors : string;	//*
begin
	var it : TStrings := TStringList.create;
	try
		for var st : text_script_type := low(st) to high(st) do begin
			for var i : smallint := 0 to text_scripts[st].i_numero-1 do begin
				var sx : text_script_record_punt := @text_scripts[st].recs[i];
				if (sx.str_filename = '') then continue;

				var str_caption := DESCRIZIONE_TEXT_SCRIPT_SHORT[st] + ' #' + (i + 1).ToString + ' -- ' + sx.str_filename + ' -- ';
				var str_filename := uppercase(extractFileName(sx.str_filename));
				if (it.IndexOf(str_filename) = -1) then begin
					it.Add(str_filename);
					if NOT valid_filename(str_filename, TRUE) then
						add_delimited(str_errors, str_caption + 'CARATTERI NON VALIDI NEL NOMEFILE')
				end
				else add_delimited(str_errors, str_caption, 'NOMEFILE RIPETUTO')
			end
		end;
		result := (str_errors = '');
		if NOT result then error_msg(get_active_form, 'Salvataggio SCRIPTS SQL : sono stati rilevati i seguenti errori' + ACAPO2 + str_errors, 'salvataggio scripts')
	finally
		it.free
	end
end;

function Tglobale.PDF_load(var f : system.Text;wo_versione_report : word) : boolean;
// legge le impostazioni PDF per il file; rende TRUE in caso di successo, FALSE altrimenti

	function get_password : string;
	var s : string;
	begin
		readln(f, s);result := '';
		while (s <> '') do begin
			result := result + char(strtoint(copy(s, 1, 3)));
			delete(s, 1, 3)
		end;
		result := crypt(result, -PDF_PASSWORD_SEED)
	end;

var
	i : smallint;
	s : string;
begin
	result := TRUE;
	if (wo_versione_report < $023C) then exit;	// PDF non ancora implementati
	try
		PDF.init;		// per scrupolo e sicurezza
		if (wo_versione_report <= $0251) then readln(f, str_export_filename);
		readln(f, PDF.str_PDF_watermark);
		PDF.str_PDF_user_password := get_password;
		PDF.str_PDF_owner_password := get_password;

		PDF.PDF_modes := [];
		while NOT eoln(f) do begin read(f,i);PDF.PDF_modes := PDF.PDF_modes + [my_PDF_mode(i)] end;
		readln(f);

		readln(f, i);
		if (i in [0..PDF_COMPRESS_NUMERO-1]) then PDF.PDF_compress := TWPCompressStreamMethod(i) else PDF.PDF_compress := wpCompressNone;

//		behaviour := PDFH_open_folder;
		readln(f, s);PDF.PDF_encryption := [];PDF.bo_PDF_crea_autolinks := FALSE;
		if (wo_versione_report <= $0251) then bo_overwrite_file := TRUE;
		while (s <> '') do begin
			case s[1] of
				'A' : PDF.PDF_encryption := PDF.PDF_encryption + [wpEncryptFile];
				'B' : PDF.PDF_encryption := PDF.PDF_encryption + [wpEnableChanging];
				'C' : PDF.PDF_encryption := PDF.PDF_encryption + [wpEnableCopying];
				'D' : PDF.PDF_encryption := PDF.PDF_encryption + [wpEnableForms];
				'E' : PDF.PDF_encryption := PDF.PDF_encryption + [wpEnablePrinting];
				'F' : PDF.PDF_encryption := PDF.PDF_encryption + [wpLowQualityPrintOnly];
				'J' : begin delete(s,1,1);PDF.jpeg_quality := TWPJPEGQuality(strtoint(s[1])) end;
				'b' : begin delete(s,1,1);PDF.behaviour := PDF_behaviour(byte(s[1]) - byte('0')) end;
				'O' : if (wo_versione_report <= $0251) then bo_overwrite_file := FALSE;
				'R' : if (wo_versione_report <= $0251) then bo_address_required := TRUE;
				'X' : PDF.bo_PDF_crea_autolinks := TRUE;
				else
			end;
			delete(s,1,1)
		end;
		if (wo_versione_report <= $0251) then begin
			readln_LPSTR(f, s{gx.str_email});		// 2011-08-13 non ho capito bene a cosa serve questa riga
			readln_LPSTR(f, str_subject);
			readln_LPSTR(f, str_text);
			readln_LPSTR(f, s);
			if (s <> '') then begin
				bo_auto_email := SQL2bool(copy(s, 1, 1));
				str_condizione_auto_email := copy(s, 2, maxint)
			end
		end;
		if (wo_versione_report >= $024B) then readln(f, byte(PDF.fontmode)) else readln(f);
		readln_LPSTR(f, PDF.str_ExcludedFonts);
		{for i := 1 to 1 do} readln(f)
	except
		error_msg('Errore durante la lettura delle impostazioni PDF', MBOX_CAPTION);
		result := FALSE
	end
end;

{$ifndef DLL}
	function TGlobale.PDF_save(var f : system.Text) : boolean;
	// salva le impostazioni PDF per il file; rende TRUE in caso di successo, FALSE altrimenti

		procedure write_password(s : string);
		begin
			s := crypt(s, PDF_PASSWORD_SEED);
			while (s <> '') do begin
				write(f, zeri(byte(s[1]), 3));
				delete(s, 1, 1)
			end;
			writeln(f)
		end;

	begin
		result := TRUE;
		try
//			writeln(f,xstr_PDF_filename);	// fino alla versione $0251
			writeln(f, PDF.str_PDF_watermark);
			write_password(PDF.str_PDF_user_password);
			write_password(PDF.str_PDF_owner_password);

			for var i : smallint := 0 to GAL_PDF_MODES_NUMERO - 1 do if (GAL_PDF_MODES[i] in PDF.PDF_modes) then write(f, ' ', i);
			writeln(f);

			writeln(f, byte(PDF.PDF_compress));

			if (wpEncryptFile in PDF.PDF_encryption) then write(f, 'A');
			if (wpEnableChanging in PDF.PDF_encryption) then write(f, 'B');
			if (wpEnableCopying in PDF.PDF_encryption) then write(f, 'C');
			if (wpEnableForms in PDF.PDF_encryption) then write(f, 'D');
			if (wpEnablePrinting in PDF.PDF_encryption) then write(f, 'E');
			if (wpLowQualityPrintOnly in PDF.PDF_encryption) then write(f, 'F');
//			if bo_address_required then write(f, 'R');		fino alla versione $0251
//			if NOT bo_overwrite_file then write(f, 'O');	fino alla versione $0251
			if PDF.bo_PDF_crea_autolinks then write(f, 'X');
			write(f, 'b', byte(PDF.behaviour));
			if (PDF.jpeg_quality <> wpNoJPEG) then write(f, 'J', byte(PDF.jpeg_quality));
			writeln(f);
//			writeln_LPSTR(f,str_email);
//			writeln_LPSTR(f,str_subject);
//			writeln_LPSTR(f,str_text);
//			writeln_LPSTR(f,bool2SQL(bo_auto_email) + str_condizione_auto_email);
			writeln(f, byte(PDF.fontmode), ' 0 0 0 0 0 0 0 0');
			writeln_LPSTR(f, PDF.str_ExcludedFonts);
			{for var i : smallint := 1 to 1 do} writeln(f)	// FREEDOM!!!
		except
			error_msg('Errore durante il salvataggio delle impostazioni PDF', MBOX_CAPTION);
			result := FALSE
		end
	end;
{$endif}

{$ifndef DLL}
	procedure Tglobale.write_groupboxes(var f : text);
	// salva le informazioni legate ai groupboxes; emette una exception in caso di errore
	begin
		writeln(f,GBOX_MARKER_START);
		writeln(f, length(runtime_gboxes));
		writeln(f);writeln(f);	// spazio free
		for var i : smallint := 0 to high(runtime_gboxes) do begin
			writeln(f);	// free
			runtime_gboxes[i].write(f);
			writeln(f)	// free
		end;
		for var i : smallint := 1 to 7 do writeln(f);
		writeln(f,GBOX_MARKER_END)
	end;
{$endif}

procedure Tglobale.read_groupboxes(var f : text;wo_versione : word);
// carica da F le informazioni legate ai groupboxes; emette una exception in caso di errore
var
	i : smallint;	//**
	s : string;
begin
	try
		runtime_groupboxes_free(runtime_gboxes);
		if (wo_versione <= $0242) then begin	// non ancora gestiti
			setLength(runtime_gboxes, 1);
			runtime_gboxes[0]:= cl_runtime_groupbox.Create;
			exit
		end;

		readln(f, s);if (s <> GBOX_MARKER_START) then abort;
		readln(f, i);
		if (i < 0) OR (i > MAX_BOXES) then abort;
		setLength(runtime_gboxes, i);
		readln(f);readln(f);	// spazio free
		for i := 0 to high(runtime_gboxes) do begin
			readln(f);	// free
			runtime_gboxes[i] := cl_runtime_groupbox.create;
			runtime_gboxes[i].read(f, wo_versione);
			readln(f)	// free
		end;
		for i := 1 to 7 do readln(f);
		readln(f, s);if (s <> GBOX_MARKER_END) then abort
	except
		raise exception.create('Errore durante il caricamento dei g-boxes')
	end
end;

function Tglobale.get_azione_opening_report : azione_opening_report_type;
begin
	if (azione_opening_report_runtime = AORT_POPT_DEFAULT) then result := azione_opening_report_phisical
	else result := azione_opening_report_runtime
end;

procedure Tglobale.set_azione_opening_report(azione : azione_opening_report_type);
begin
//	if (azione_opening_report_runtime = AORT_POPT_DEFAULT) then azione_opening_report_phisical := azione
//	else azione_opening_report_runtime := azione
	azione_opening_report_runtime := azione
end;

function TGLobale.init_traduzione : boolean;
{ procedura da chiamare all'inizio dell'elaborazione (o della pagina) per inizializzare la traduzione in una specifica lingua;
  rende TRUE se l'inizializzazione avviene correttamente (a prescindere dal fatto che la traduzione sia attivata ed utilizzabile) }
begin
	if (it_lingue_disponibili <> NIL) then begin
		it_lingue_disponibili.Free;
		it_lingue_disponibili := NIL
	end;
	result := TRUE
end;

function TGlobale.traduzione_disponibile : boolean;
// rende TRUE se il servizio di traduzione è attivo
begin
	result := (str_lingua_object <> '')
end;

function TGlobale.get_traduzione_lingua(str_item : string) : string;
begin
	result := '';

	if (it_lingue_disponibili = NIL) then begin
		it_lingue_disponibili := TStringList.Create;
		load_lingue(it_lingue_disponibili, {uppercase}TRUE)
	end;
	if (it_lingue_disponibili.Count = 0) then exit;		// gestione lingue disattivata

	var str_lingua := str_lingua_object;
//	if (str_lingua = '') then exit;		// oggetto non referenziato
	if (str_lingua = '') then str_lingua := it_lingue_disponibili[0]		// lingua non assegnata, uso la prima lingua disponibile
	else begin
		var ox := name2obj(str_lingua, {all_pages} TRUE);
		if (ox = NIL) then exit;
		str_lingua := uppercase(ox.calcola_print_value);
		if (str_lingua = '') then str_lingua := it_lingue_disponibili[0]		// lingua non assegnata, uso la prima lingua disponibile
	end;
	if (it_lingue_disponibili.Indexof(str_lingua) = -1) then exit;	// lingua non disponibile per la traduzione

	result := get_string_where(get_databasename, 'select lingua_translate(' + str_item.QuotedString + ', ' + str_lingua.QuotedString + ')')
end;

function Tglobale.get_runtime_pagine_logiche_stampabili : logical_page_type;
// restituisce il numero di pagine logiche stampabili
begin
	result := 0;
	for var i : logical_page_type := 0 to i_pagine_logiche - 1 do begin
		if lpZB_info[i].bo_dont_print then continue;
		inc(result)
	end
end;

function Tglobale.get_XML_structure_debug_info : boolean;
begin
//	result := bo_XML_structure_debug_info_phisical {$ifdef DLL} OR bo_debug_base {$endif}
	result := bo_XML_structure_debug_info_phisical
end;

// *************************************************************************************************************************************************************

function Tglobale.get_stored_value_pos(str_name : string;var i_ndx : integer) : boolean;
{ cerca la variabile STR_NAME; rende TRUE se trova il valore, FALSE altrimenti;
  assegna comunque I_NDX all'indice del record più prossimo (uguale o superiore) a STR_NAME }
begin
	if (stored_values = NIL) then begin i_ndx := 0;result := FALSE;exit end;
	str_name := uppercase(str_name);
	var i_min : integer := 0;var i_max : integer := high(stored_values);
	while (i_min < i_max) do begin
		i_ndx := (i_min + i_max) div 2;
		if (str_name > stored_values[i_ndx].str_name) then i_min := i_ndx + 1 else
		if (str_name < stored_values[i_ndx].str_name) then	i_max := i_ndx - 1
		else begin result := TRUE;exit end
	end;
	i_ndx := i_min;
	result := (str_name = stored_values[i_ndx].str_name);
	if NOT result AND (str_name > stored_values[i_ndx].str_name) then inc(i_ndx)
end;

procedure Tglobale.store_value(str_name : string;str_value : string;bo_text : boolean;stoop : STORE_OPERATION_TYPE);
var i, i_numero : integer;
begin
//	{$ifdef DEBUG} assert(globale.fase_stampa = FASE_STAMPA_ASSEGNAZIONE_STORED_VALUES,'must be FASE_STAMPA_ASSEGNAZIONE_STORED_VALUES -- JHMQ 9291'); {$endif}
	str_name := uppercase(str_name);
	if NOT get_stored_value_pos(str_name, i) then begin
		i_numero := length(stored_values);
		setLength(stored_values, i_numero + 1);
		if (i < i_numero) then move(stored_values[i], stored_values[i+1], (i_numero-i) * sizeof(pointer));
		stored_values[i] := cl_store_value.create
	end;

	if bo_text then stored_values[i].set_value(str_name, str_value)
	else stored_values[i].set_value(str_name, strtofloat(coalesce(str_value, '0')), stoop);
	if {bo_debug_full} bo_debug_base then
		Gdebug_SQL('STORED VALUE [' + puntato(length(stored_values)) + '] ::: ' + str_name + '=' + str_value, 'STORE', TRUE)
end;

procedure Tglobale.store_value(str_name : string;fl_value : double;stoop : STORE_OPERATION_TYPE);
begin
	store_value(str_name, floattostr(fl_value), FALSE, stoop)
end;

(*function Tglobale.get_stored_value_pos(str_name : string) : integer;
// rende la posizione (0-based) di str_name; rende -1 se la variabile non esiste
var i_num : integer;
begin
	str_name := uppercase(str_name);
{	result := length(stored_values) - 1;
	while (result >= 0) AND (stored_values[result].str_name <> str_name) do dec(result) }
	result := 0;i_num := length(stored_values);
	while (result < i_num) AND (str_name > stored_values[result].str_name) do inc(result);
	if (result = i_num) OR (str_name <> stored_values[result].str_name) then result := -1
end; *)

function Tglobale.get_stored_value(str_name : string;bo_must_exists : boolean = TRUE) : string;
var
	i : integer;
	s : string;
begin
	if NOT get_stored_value_pos(str_name, i) then begin
//		i := get_stored_value_pos(str_name);
//		if (i = -1) then begin
		if bo_must_exists {AND (fase_stampa <> FASE_STAMPA_ASSEGNAZIONE_STORED_VALUES)} then begin
			s := 'Variabile <' + str_name + '> non esistente';
			MessageBBox(get_handle, s, MBOX_CAPTION);
			raise exception.create(s)
		end
		else result := ''
	end
	else result := stored_values[i].get_value
end;

function Tglobale.esiste_stored_value(str_name : string) : boolean;
var i : integer;
begin
	result := get_stored_value_pos(str_name, i)
end;

{function Tglobale.get_stored_double_value(str_name : string) : double;
begin
	s := get_stored_value(str_name,
end;	*}

procedure Tglobale.free_stored_values;
begin
	if bo_debug_base AND (stored_values <> NIL) then
		Gdebug_SQL('allocati ' + puntato(length(stored_values)) + ' stored values','free_stored_values()', TRUE);
	for var i : integer := 0 to high(stored_values) do stored_values[i].free;
	stored_values := NIL
end;

// *************************************************************************************************************************************************************

function Tglobale.build_macro_parametriche(bo_test : boolean) : boolean;
var i_errori : smallint;

	procedure xadd(s : string);
	var i, j : smallint;	//*
	begin
		i := length(macro_parametriche);
		try
			setLength(macro_parametriche, i + 1);
			macro_parametriche[i] := cl_macro_parametrica.create(s, bo_test);
			for j := 0 to i-1 do
				if (macro_parametriche[j].str_nome = macro_parametriche[i].str_nome) then
					raise exception.create('Il nome di macro <' + macro_parametriche[i].str_nome + '> non è univoco')
		except
			inc(i_errori);
			error_msg(get_active_form, 'Errore durante l''interpretazione delle macro', MBOX_CAPTION);
			setLength(macro_parametriche, i)
		end;

		// riordino le macro parametriche, perchè siano sempre in ordine alfabetico
		for i := 0 to high(macro_parametriche) do begin
			for j := i+1 to high(macro_parametriche) do begin
				if (macro_parametriche[i].str_nome > macro_parametriche[j].str_nome) then begin
					var m := macro_parametriche[j];
					macro_parametriche[j] := macro_parametriche[i];
					macro_parametriche[i] := m
				end
			end
		end
	end;

var
	i : smallint;
	s, str_line, str_macro : string;
begin
	free_macro_parametriche;

	for i := 0 to text_scripts[TST_MACRO_PARAMETRICHE].i_numero-1 do
		s := s + text_scripts[TST_MACRO_PARAMETRICHE].recs[i].str_text + ACAPO;

	i_errori := 0;
	try
		s := tratta_include_text('Lettura MACRO', s)
	except
		inc(i_errori);
		error_msg('Errore durante la lettura delle MACROs', MBOX_CAPTION)
	end;
	while (s <> '') do begin
		str_line := get_line(s,TRUE);
		i := pos('//',str_line);if (i <> 0) then delete(str_line,i,maxint);	// tolgo i commenti
		if bo_test AND start_with(str_line, '$') then
			error_msg(get_active_form, 'Una riga non dovrebbe iniziare con un  $' + ACAPO2 + str_line, MBOX_CAPTION);
//			MessageBBox(handle, 'Una riga non dovrebbe iniziare con un  $' + ACAPO2 + str_line, MBOX_CAPTION, MB_ICONSTOP);	*
		if (str_line = '') then continue;
//		if (str_macro <> '') AND NOT (str_line[1] in [' ',^I]) then begin	// se la riga NON è la continuazione della precedente
		if (str_macro <> '') AND NOT CharInSet(str_line[1], [' ',^I]) then begin	// se la riga NON è la continuazione della precedente
			xadd(str_macro);
			str_macro := ''
		end;
		str_macro := str_macro + ifs(str_macro,' ') + togliblanks(str_line)
	end;
	if (str_macro <> '') then xadd(str_macro);
	result := (i_errori = 0)
end;

procedure Tglobale.free_macro_parametriche;
begin
	for var i : smallint := 0 to high(macro_parametriche) do macro_parametriche[i].free;
	macro_parametriche := NIL
end;

function Tglobale.translate_macro_parametrica(var str_text : string;var str_result: string;ox : objs_type;bo_test : boolean) : boolean;
{ cerca di tradurre la macro parametrica che si trova all'inizio di STR_TEXT;
  in caso di successo rende TRUE, elimina da STR_TEXT la parte di testo tradotta e carica su STR_RESULT la traduzione;
  se I_OBJ != 0 la macro è sviluppata in relazione all'oggetto specificato, e sarà conseguentemente interpretata;
  BO_TEST è TRUE se si sta valutando la correttezza syntattica della macro, FALSE se la si sta interpretando davvero }
var
	str_parm : string;
	parms : array of string;
begin
	result := FALSE;str_result := '';
	if (macro_parametriche = NIL) then exit;	// inutile fare ulteriori faticose verifiche
	var s := togliblanks(str_text);
	var i : smallint := pos('(', s);if (i = 0) then exit;
	var str_nome := togliblanks(copy(s, 1, i-1));
	var i_macro : smallint := get_pos_macro_parametrica(str_nome);
	if (i_macro = -1) then exit;
	var m : cl_macro_parametrica := macro_parametriche[i_macro];

	try
		s := togliblanks(copy(s, i+1, MAXINT));
		while (get_parm(s, str_parm)) do begin
			if (start_with(str_parm, '"') AND end_with(str_parm, '"')) OR (start_with(str_parm, '''') AND end_with(str_parm, ''''))
				then str_parm := copy(str_parm, 2, length(str_parm) - 2);
			sostituisci(str_parm, ACAPO, ' ');	// dal 2009-02-19: non dovrebbero capitare più di tanto, ma se non sono trattati sono ingestibili
			setLength(parms, length(parms) + 1);
			parms[high(parms)] := str_parm
		end;
		if (length(parms) <> length(m.parms)) then
			error_msg(get_active_form, 'Macro ' + str_nome + ': numero di parametri è errato' + ACAPO2 + str_text, MBOX_CAPTION);

		for i := 0 to high(parms) do
			str_result := str_result + MACRO_ID + m.parms[i] + '=' + parms[i] + ACAPO;
		str_result := str_result + m.str_macro;
		str_result := translate_local_macros(str_result);

		if (ox <> NIL) then
//			sections(ox.aslabel.i_section).interpreta_string(str_result, {stampa_vera}NOT bo_test, {check_errors}TRUE);
			sections_1B(ox.ca.i_section_1B).interpreta_string(str_result, {stampa_vera}NOT bo_test, {check_errors}TRUE);

		str_text := s;
		result := TRUE
	finally
		parms := NIL
	end
end;

function Tglobale.get_pos_macro_parametrica(str_macro : string): smallint;
// rende la posizione della macro (0-based) oppure -1 se la macro non esiste;
// le macro parametriche sono SEMPRE ordinate alfabeticamente
begin
	if (macro_parametriche = NIL) then begin result := -1;exit end;	// famo prima
	var i_num : smallint := length(macro_parametriche);
	result := 0;str_macro := uppercase(str_macro);
	while (result < i_num) AND (str_macro > macro_parametriche[result].str_nome) do inc(result);
	if (result = i_num) OR (str_macro <> macro_parametriche[result].str_nome) then result := -1
end;

// -----------------------------------------------------------------------------

{$ifndef DLL}

	procedure Tglobale.program_messages(var Msg : TMsg;var Handled : Boolean);		// Tapplication
	begin
//		Handled := FALSE;
		case msg.message of
			WM_KEYDOWN: begin
				if (msg.LParam mod 256 <> 1) then exit;	// solo alla prima pressione del tasto
				case msg.wparam of
					word('S') : begin		// S as System operator
						if NOT bo_federico_signed AND is_key_down(VK_CONTROL) AND is_key_down(VK_SHIFT) AND is_key_down(VK_MENU) then begin
							Handled := TRUE;beep;
							GM.set_system_operator(FALSE);
						end
					end;
					word('Y') : begin		// Y as I don't know whY
						if NOT bo_dont_write_version AND is_key_down(VK_CONTROL) AND is_key_down(VK_SHIFT) AND is_key_down(VK_MENU) then begin
							Handled := TRUE;beep;
							bo_dont_write_version := TRUE
						end
					end;
					VK_F9 : begin
						if is_key_down(VK_CONTROL) AND is_key_down(VK_MENU) then begin // CTRL schiacciato ?
							macros_elenco_proc(NIL);
							Handled := TRUE
						end
					end
				end
			end
		end;
//		inherited
	end;

	function Tglobale.get_signature(bo_ask_always : boolean = FALSE;bo_can_abort : boolean = FALSE) : string;
	// se bo_can_abort la procedura NON consente l'annullamento
	begin
{		if bo_ask_always OR (str_signature = '') AND
			NOT input_text_proc(NIL,'Salvataggio','Operatore che firma il salvataggio',str_signature,MAX_SIGNATURE_LENGTH)
				then abort;	// annullo il salvataggio }

		if (bo_ask_always OR (str_signature = '') OR (str_descrizione_modifiche = '')) AND
			NOT input_text_proc(NIL, 'Salvataggio', 'Operatore che firma il salvataggio', 'Descrizione delle modifiche effettuate',
				str_signature, str_descrizione_modifiche, MAX_SIGNATURE_LENGTH, NIL, ifi(bo_federico_signed, IDS_SETFOCUS_2ND_FIELD))
		then
			if bo_can_abort then sysutils.abort		// annullo il salvataggio
			else str_signature := 'identificazione rifiutata';

		if bo_federico_signed AND (str_signature = '') then str_signature := SYSTEM_SIGNATURE;
		result := dttime2SQL(now, FALSE, TMFMT_HM) + ' ' +
			ifs(bo_federico_signed, '*', ' ') +		// firma del sistemista
			xstril(str_signature, MAX_SIGNATURE_LENGTH, SA_LEFT) + ' ver ' + zeri(GALATEO_VERSION, 4) +
			' [' + {$ifdef WIN32} '32' {$endif} {$ifdef WIN64} '64' {$endif} + ']' +
			' [' + get_computer_name + '/' + extractFilename(str_filename) + ']  ' + str_descrizione_modifiche
	end;

{$endif DLL}

function TGlobale.traslate_internal_email(var str_result : string;bo_default : boolean;str_elenco : string;bo_SQL : boolean) : boolean;
{ APPENDE a STR_RESULT l'elenco degli indirizzi mail caricati su STR_ELENCO; trascura eventuali indirizzi mail doppi;
  BO_DEFAULT è TRUE se sto traducendo gli indirizzi mail DEFAULT, FALSE se sto traducendo l'elenco degli indirizzi disponibili;
  STR_ELENCO può essere un elenco delimitato da ACAPO oppure una istruzione SQL;
  rende TRUE in caso di successo, FALSE altrimenti }
const DELIM = ACAPO;
var s : string;	//*
begin
	result := TRUE;var qry : TFquery := NIL;
	var str_caption := 'traslate_internal_email(' + ifs(bo_default, 'DEFAULT', 'ELENCO') + ')';
	runtime_debug('start', str_caption, RD_DEBUG_PRINCIPALE_00);
	if (str_elenco = '') then exit;
	if bo_SQL then begin
		try
			s := togli_ACAPO_finali(str_elenco);
			if (s = '') then exit;		// nothing to do

			runtime_debug('SQL', str_caption, RD_DEBUG_DETTAGLIO_02);
			s := tratta_include_text(str_caption, s);
			s := translate_local_macros(s);
			sections_ZB(0).interpreta_string(s, {stampa_vera}TRUE, {check_errors}FALSE);

			Gdebug_SQL(s, str_caption);
			runtime_debug('query', str_caption, RD_DEBUG_DETTAGLIO_02);
			qry := create_query(get_active_form, get_databasename, s);
			var i : smallint := 0;str_elenco := '';
			while NOT qry.Eof AND (i < 1000) do begin		// 1000: solo per prudenza
				s := qry.Fields[0].AsString;
				runtime_debug('loop-' + zeri(i,3) + ' -- ' + s, str_caption, RD_DEBUG_DETTAGLIO_02);
				add_delimited(str_elenco, s, ACAPO, TRUE);		// il delimitatore di ELENCO è sempre ACAPO
				qry.Next;inc(i)
			end
		except
			error_msg('Errore durante l''interpretazione dell''elenco mail' + ACAPO2 + str_elenco, 'Galateo: ' + str_filename);
			result := FALSE
		end;
		free_query(qry)
	end;

	while (str_elenco <> '') do begin
		s := get_first_delimited(str_elenco, ACAPO);
		str_elenco := delete_delimited(str_elenco, s, FALSE, ACAPO);
		s := togliblanks(s);
		if (s = '') then continue;
		add_delimited(str_result, s, ACAPO, TRUE)
	end
end;

function TGlobale.get_email_default : string;
// email default (eventualmente comma-delimited)
begin
	result := str_email_default_runtime;
	if NOT traslate_internal_email(result, {default}TRUE, str_indirizzi_email_default_internal, bo_indirizzi_email_default_SQL) then result := '';
	sostituisci(result, ACAPO, ',')
end;

function TGlobale.get_email_elenco(tipo : mail_target_type = MTT_TO) : string;
// elenco delle mail disponibili nella combobox, ACAPO-delimited
begin
	result := str_email_elenco_runtime[tipo];
	if NOT traslate_internal_email(result, {default}FALSE, str_indirizzi_email_elenco_internal, bo_indirizzi_email_elenco_SQL) then result := ''
end;

{$ifdef DLL}
	procedure TGlobale.set_email_runtime_default(s : string); begin str_email_default_runtime := s end;
	procedure TGlobale.set_email_runtime_elenco(s : string;tipo : mail_target_type = MTT_TO); begin str_email_elenco_runtime[tipo] := s end;
{$endif}

function Tglobale.get_default_write_filename(bo_target_export : boolean;bo_translate_macros : boolean = TRUE) : string;
//var str_filepath, str_filename : string;
begin
	result := '';
	if bo_target_export then result := str_expint_export_filename;
	if (result = '') then result := str_export_filename;
	if (result = '') then result := ChangeFileExt(ExtractFilename(self.str_filename), '');

	if bo_translate_macros then
		sections_ZB(0).interpreta_string(result, {stampa_vera}TRUE, {check_errors}FALSE);

	result := replace_environment_variables(result);
	if assigned(xxcallback_replace_variabili_ambiente)			// 2016-01-19
		then result := xxcallback_replace_variabili_ambiente(i_job, result, {ptr:unused}NIL);

(*	// se non c'è un path esplicito, non lo assegno qui (farebbe
	if NOT filename_has_explicit_path(result) then begin
		str_filepath := str_default_export_filepath;
		str_filepath := replace_environment_variables(str_filepath);
		if assigned(callback_replace_variabili_ambiente)
			then str_filepath := callback_replace_variabili_ambiente(i_job, str_filepath, {ptr:unused}NIL);
		if (str_filepath = '') then str_filepath := GetSystemPath(CSIDL_PERSONAL);
//		result := str_filepath + ExtractFilename(result)
		result := make_filename(result, str_filepath)
	end; *)

	// 2014-11-24 -- comunque il nomefile deve essere valido !!!
	if (pos(':', result) + pos('\', result) = 0) then		// se non c'è il path controllo direttamente il nome
		result := check_filename(result, {allow_spaces}FALSE)
	else result := ExtractFilePath(result) + check_filename(ExtractFilename(result), {allow_spaces}FALSE)		// se c'è il path, controllo il nome separatamente
end;

function Tglobale.get_default_write_filepath(bo_target_export : boolean;bo_translate_macros : boolean = TRUE) : string;
{ PATH default di exportazione;
  se BO_TARGET_EXPORT si parla specificamente di exportazione, altrimenti di salvataggio (PDF);
  il PATH viene usato solamente se il filename NON ha un path esplicito;
  questo PATH deve essere usato come un percorso di exportazione DEFAULT, e assegnato DOPO la scelta liberamente eseguita dall'utente }
begin
	result := str_default_export_filepath;
	result := replace_environment_variables(result);
	if assigned(xxcallback_replace_variabili_ambiente)
		then result := xxcallback_replace_variabili_ambiente(i_job, result, {ptr:unused}NIL);
	if (result = '') then result := GetSystemPath(CSIDL_PERSONAL)
end;

{$ifndef DLL}

{	function Tglobale.backup : boolean;
	// esegue un backup del database; rende TRUE in caso di successo, FALSE altrimenti
	begin result := backup_proc(controllo) end; }

{$ifdef MSWINDOWS}
function TGlobale.save(str_filename : string;bo_can_abort : boolean = TRUE) : boolean;
// salva il file attivo; rende TRUE in caso di successo, FALSE altrimenti
var f : textfile;
begin
	result := FALSE;
	if bo_external_file_too_old then begin
		MessageBBox(get_handle, 'ATTENZIONE: impossibile modificare il modulo di stampa <' + str_filename +
				'> perchè la versione di almeno uno tra i files esterni con cui si trova ad essere associato è troppo vecchia.', MBOX_CAPTION);
		exit
	end;

	var str_signature_temp := salvataggi.Text;
	if NOT bo_dont_write_version then begin
		if (str_signature_temp <> '') then str_signature_temp := ACAPO + str_signature_temp;
		str_signature_temp := get_signature(FALSE, bo_can_abort) + str_signature_temp
	end;

	if (GALATEO_VERSION > wo_versione_read) AND
		(MessageBBox(get_active_form, 'Versione ' + version_of(wo_versione_read) + ' >> ' + version_of(GALATEO_VERSION) + ACAPO2 + 'Confermi?', MBOX_CAPTION, MB_QUESTION) <> IDYES)
			then exit;

	if NOT check_scripts_filenames then exit;

	obj_select(0, FALSE, FALSE);
	if (str_filename = '') then begin
		if NOT browse_for_files_save(get_active_form, MBOX_CAPTION, str_filename, DEFAULT_EXT, FILES_FILTER, {default_dir}'') then exit;
//		if NOT Savedlg.execute then exit;str_filename := savedlg.filename;
		self.str_filename := str_filename
	end;

	var str_bak := set_extension(str_filename,BAK_EXT);
	var i_fileattr : integer := FileGetAttr(str_filename);
	if (i_fileattr <> -1) AND (i_fileattr AND faReadOnly <> 0) then begin
		MessageBBox(get_handle, 'Il file ' + uppercase(str_filename) + ' è di sola lettura', MBOX_CAPTION, MB_ICONSTOP);
		exit
	end;
	i_fileattr := FileGetAttr(str_bak);
	if (i_fileattr <> -1) AND (i_fileattr AND faReadOnly <> 0) then begin
		MessageBBox(get_handle, 'Impossibile rinominare ' + uppercase(str_filename) + ' perchè ' + uppercase(str_bak) + ' è di sola lettura',
			MBOX_CAPTION, MB_ICONSTOP);
		exit
	end;

	try
		set_wait_cursor(TRUE);
		if FileExists(str_filename) then begin	// genero il file .BAK
			try
				DeleteFile(str_bak);if FileExists(str_bak) then abort;
				if NOT RenameFile(str_filename,str_bak) then abort
			except
				if (MessageBBox(get_handle, 'Errore durante la creazione del file di backup (' + str_bak + ').' + ACAPO2 +
					 'Vuoi salvare comunque?', MBOX_CAPTION, MB_QUESTION_DEF2) <> IDYES)
						then abort
			end
		end;

		assignfile(f, str_filename);rewrite(f);
		writeln(f, START_OF_GALATEO_FILE);
		writeln(f, GALATEO_VERSION:4, ' ', {$ifdef WIN32} 32 {$endif} {$ifdef WIN64} 64 {$endif});
		writeln(f, str_descrizione_report);

		if NOT save_font_1L(f, text_only_font) then abort;
		writeln(f, i_text_only_colonne, ' ', i_text_only_righe, ' ', i_text_only_cpi, ' ', i_text_only_lpi);
		writeln(f{,str_default_image_filename});
		writeln(f, str_default_export_filepath);
		str_signature_temp := shift_alfanumeric(str_signature_temp);
		writeln_LPSTR(f, str_signature_temp + zeri(get_xor_value(str_signature_temp), 3));
		TStrings_save(f, tstr_remarks);
		writeln_LPSTR(f, str_runtime_help);
		runtime_help_font.writeln(f);

		for var i : byte := 1 to 3 do writeln(f);	// righe vuote, thinking to future

		with tm do
			writeln(f, '0 0 0 0 ', i_lab_per_row, ' ', i_lab_per_page, ' ', r_delta_labs_X_cm:0:4, ' ', r_delta_labs_Y_cm:0:4, ' ', bo_show_griglia);
{			writeln(f,r_labsize_x_cm_temp:0:4,' ',r_labsize_y_cm_temp:0:4,' ',r_marg_sx_cm:0:4,' ', r_marg_up_cm:0:4,' ',i_lab_per_row,' ',i_lab_per_page,' ',
				r_delta_labs_X_cm:0:4,' ',r_delta_labs_Y_cm:0:4,' ',bo_show_griglia); }
		writeln(f, tm.bo_print_bordo);
		writeln(f, tm.bo_print_pagina_completa);
//		writeln(f, {str_db_driveralias}'X', ' ', connection_config.str_table);		******* fino alla versione $0402
		writeln(f, str_db_field_default);
		writeln(f, printer_default[0].str_printer);		// stampante da usare per l'etichetta; '' se usa la stampante predefinita
//		writeln(f, bo_report);		// è label oppure report
		writeln(f, byte(tiporeport));	// dal 2005-11-02
		writeln(f, byte(bo_griglia_vtabs), ' ', i_griglia_vtabs, ' ', get_pagina_logica_attiva_1B);

		// opzioni di vario tipo; lettere usate: A,B,C,D,E,F,H,I,J,K,L,M,P,R,S,T,U,V,X,Z, a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,t,u,v,w,x,y,z
		if bo_text_only then write(f, 'A');
//		if bo_alias then write(f, 'B');	** fino al 2019-09, versione $0400
		if bo_commit_transaction then write(f, 'C');
		if bo_debug_base then write(f, 'D');
		if bo_debug_full then write(f, 'd');
		if bo_debug_delete_everytime then write(f, 'e');
		bo_saved_debug := bo_debug_base;

		if bo_exclude_runtime_message_report then write(f, 'o');
		if bo_log_registro_eventi then write(f, 'u');
		if bo_log_file then write(f, 'v');
		if bo_silent_mode_phisical then write(f, 'z');

		if NOT bo_use_compressed_bmps then write(f, 'E');
		if bo_create_index AND bo_show_index then write(f, 'I');
		if bo_create_index then write(f, 'K');
		if bo_log_parametri then write(f, 'L');
//		if connection_config.bo_login_prompt then write(f, 'l');	************ fino alla versione $0402
		if NOT bo_autosize_page then write(f, 'R');
		if bo_use_transaction then write(f, 'T');
		write(f, 't', byte(isolation_level));
//	  	if (byte(target_default) <> 0) then write(f, 'U', byte(target_default));
//		if (EFAT_default_action <> EFAT_DEFAULT) then write(f, 'V', byte(EFAT_default_action));
//		if bo_orizzontale then write(f,'H');    modalità non più gestita
		if NOT bo_show_hidden_objects then write(f, 'S');
//		write(f,'J',zeri(i_jpeg_compression_quality, 3));
//		write(f,'P',zeri(i_jpeg_percentuale,3));
		if NOT bo_force_font_exist then write(f, 'F');
		if bo_show_time_esecuzione then write(f, 'M');
		case box_new_valutazione_scostamento of
			XTRUE : write(f, 'x');
			XFALSE : write(f, 'X')
		end;
//		if NOT bo_XML_allowed then write(f, 'y');		// default: TRUE
		if NOT bo_export_allowed then write(f, 'a');
		if bo_export_set_default then write(f, 'b');
		if bo_export_proponi then write(f, 'c');
//		write(f, 'k', byte(expint_default_target).ToString);		** valore rimosso a partire da 2015-04-18 versione $0322
//		write(f, 'm', byte(export_default_file_writemode).ToString);	** valore rimosso a partire da 2015-04-18 versione $0322
		if (SQL_reexecute_scripts <> low(SQL_reexecute_scripts)) then write(f, 'n', byte(SQL_reexecute_scripts));
		if bo_pausa_pagina then write(f, 'p');
//		write(f, 'r', byte(debug_target));	// 2024-03-16

		if bo_export_execute_automatically then write(f, 'i');
//		if NOT bo_new_valutazione_scostamento then write(f,'X');	// usato per qualche giorno fino al 2007-01-16
		if (print_diretta = PDS_DIRETTA) then write(f, 'f');
		if (azione_opening_report_phisical <> AORT_POPT_DEFAULT) then write(f, 'g', byte(azione_opening_report_phisical));
		if (azione_after_print <> AAPT_NOTHING) then write(f, 'h', byte(azione_after_print));
		if (modalita_selezione_default_printer <> DPST_SYSTEM_DEFAULT)
			then write(f, 'Z', byte(modalita_selezione_default_printer).ToString);		// versione $0302
		if (byte(azione_printer_unknown) <> 0) then write(f, 'j', byte(azione_printer_unknown));	// versione $0303
		if bo_XML_structure_debug_info then write(f, 'w');
		writeln(f);

(*		for var i : byte := 0 to SQL_PRE_SCRIPTS_NUMBER-1 do			****** codice commentato da versione $030A
//			if NOT write_TStrings(f,tsql_scripts_pre[i]) then abort;
			if NOT writeln_LPSTR(f,str_scripts_pre[i] +
				ifs(str_scripts_pre_descr[i],SEQ_SEP_SQL_SCRIPT_DESCR + str_scripts_pre_descr[i])) then abort;
		for var i : byte := 0 to SQL_POST_SCRIPTS_NUMBER-1 do
//			if NOT write_TStrings(f,tsql_scripts_post[i]) then abort;
			if NOT writeln_LPSTR(f,str_scripts_post[i] +
				ifs(str_scripts_post_descr[i],SEQ_SEP_SQL_SCRIPT_DESCR + str_scripts_post_descr[i])) then abort; *)
		if NOT write_TStrings(f,tsql_stored_procs_definition) then abort;
		writeln(f, printer_default[1].str_printer);
		writeln(f, i_numero_copie_default);
		writeln(f, printer_default[0].str_cassetto);
		writeln(f, printer_default[1].str_cassetto);
		writeln(f, i_forced_width_10mm,' ',i_forced_height_10mm);
		writeln(f, bool2SQL(bo_usa_sempre_printer_report));
		i_printer_reference_height_10mm := tm.i_phisical_10mm_height;
		writeln(f, i_printer_reference_height_10mm);
//		writeln_LPSTR(f,str_parametri_connessione_DB);		// fino alla versione $0255
//		writeln(f, stringa2hex_encode(connection_config.str_parametri_connessione, TRUE));			**** fino alla versione $0402
		writeln_LPSTR(f, str_pausa_pagina_message);
		writeln(f);	// FREEDOM !

		if NOT PDF_save(f) then abort;

		writeln_LPSTR(f, {str_macro_parametriche}'');
		writeln(f, bool2SQL(bo_GAPP_ask_conferma_stampa_definitiva), '         ', str_GAPP_password_stampa_definitiva);	// 2006-04-05
		writeln(f, str_debug_computer);
//		writeln_LPSTR(f, str_message_after);
//		writeln(f, str_comando_specifico_default);
//		writeln_LPSTR(f, str_script_remarks);		** fino alla ver $0309, 2012-11-01
		writeln(f);
		writeln(f, str_default_date_format);writeln(f, str_default_time_format);
//		writeln_LPSTR(f, str_message_before);		*** fino alla $0303
		writeln(f, str_export_filename);	// prima era salvato nelle impostazioni PDF
		writeln(f, byte(bo_overwrite_file), byte(bo_auto_email):2, byte(bo_address_required):2);
//		writeln_LPSTR(f, str_email);	**** fino al 2011-08-12, versione $0301, poi spostato sotto

		writeln_LPSTR(f, str_subject);
		writeln_LPSTR(f, str_text);
		writeln_LPSTR(f, str_condizione_auto_email);
		writeln(f, lo_background_parms_caption_color, ' ', lo_foreground_parms_caption_color, ' ', str_runtime_parms_caption);
		var i_monitor : smallint := -1;
		if (Screen.MonitorCount > 1) AND NOT GM.Monitor.Primary then i_monitor := GM.Monitor.MonitorNum;
		writeln(f, byte(bo_allow_saving_runtime_pos), ' ', {lo_expint_max_lines, byte(expint_separatore):2, } '0 0 ',
			byte(bo_label_registra_ultima_posizione):2, {' ', i_default_expint_profile,} ' ',
			i_impostazioni_pageindex, ' ', i_impostazioni_SQLscripts_pageindex, ' ', i_impostazioni_export_pageindex, ' ', // spazi perchè il numero può variare considerevolmente
			i_impostazioni_mail_pageindex, ' ',
			printer_size_constraints.i_min_width_mm, ' ', printer_size_constraints.i_min_height_mm, ' ',
			printer_size_constraints.i_max_width_mm, ' ', printer_size_constraints.i_max_height_mm, ' ',
			i_durata_pausa_pagina_msec, ' ', i_impostazioni_macro_scripts_pageindex,
			i_monitor:3, 	// 2021-03-14 ver $0404
			byte(send_mail_modalita_standard_galateo_ph):2,	// 2021-04-18, ver $0405 (prima questo valore esisteva ma non veniva salvato per motivi filosofici -- ma sbagliati)
			' 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0');
		writeln(f, str_password_edit);
		writeln(f, str_password_exec);
		writeln(f, str_formato_label);
		writeln(f, str_label_skip);

		// dal 2011-08-12, versione $0302
		for var i : byte := 0 to byte(high(email_address_type)) do if (email_address_type(i) in indirizzi_email_default) then write(f, i.ToString:2);
		writeln(f);
		for var i : byte := 0 to byte(high(email_address_type)) do if (email_address_type(i) in indirizzi_email_elenco) then write(f, i.ToString:2);
		writeln(f);
		writeln_LPSTR(f, str_indirizzi_email_default_internal);
		writeln_LPSTR(f, str_indirizzi_email_elenco_internal);
		writeln(f, byte(bo_indirizzi_email_default_SQL), byte(bo_indirizzi_email_elenco_SQL):2, byte(bo_load_indirizzo_main_when_unique):2, ' 0 0 0 0 0 0 0');
		writeln(f, str_documento_informativo_utente);	// dalla versione $0309
		writeln(f, str_technical_reference);				// dalla versione $0309
		writeln(f, str_lingua_object);
		writeln(f, str_lingua_contesto);
		writeln(f, str_expint_export_filename);
//		writeln_LPSTR(f, str_struttura_XML);
		writeln_LPSTR(f, str_links_utente);
		writeln(f, '');	// FREEDOM !

		table_colori_symbolici.write(f);

		// LABEL: OPZIONI GENERALI/ OGGETTI/ opzioni della MAIN SECTION
		// REPORT: OPZIONI GENERALI/ SEZIONE 1 (main) [/altre sezioni [..]]
{		if bo_report then
			if NOT write_report(f) then abort
			else
		else if NOT write_label(f) then abort; }
		case tiporeport of
			TR_REPORT, TR_LABEL_REPORT : if NOT write_report(f) then abort;
			TR_LABEL_STANDALONE : if NOT write_label(f) then abort
		end;

		write_groupboxes(f);

		for var i : byte := 0 to byte(high(text_script_type)) do
			if NOT text_scripts[text_script_type(i)].write(f)	// fino alla versione $023D non c'era TST_MACRO
				then raise exception.create('Errore durante il salvataggio degli scripts di testo');	// versione $030A
//		if NOT SQLS_early.write(f) OR NOT SQLS_before.write(f) OR NOT SQLS_after.write(f) then raise exception.create('Errore durante il salvataggio degli scripts');	// versione $030A

		for var i : byte := 1 to 5 do writeln(f, '');	// FREEDOM ! 	versione $030A
		connection_config.write(f);		// a partire dalla versione $0403

		writeln(f, str_message_opening_print);
		for var i : byte := 1 to 6 do writeln(f, '');	// FREEDOM !
		writeln(f, length(expint_profiles), ' 0 0 0 0 0 0 0');
		for var i : byte := 0 to high(expint_profiles) do expint_profiles[i].write(f, i, i_pagine_logiche);
		FTP_parms.write(f);

		writeln(f, bool2SQL(bo_FTP_conferma), str_FTP_password);			// 2013-03-23
		writeln_LPSTR(f, togliblanks_eoln(str_FTP_message));

		writeln(f, byte(comportamento_when_null), str_value_when_null_text);
		writeln(f, str_value_when_null_numeric);
		writeln(f, printer_size_constraints.i_min_width_mm, ' ', printer_size_constraints.i_min_height_mm, ' ',
			printer_size_constraints.i_max_width_mm, ' ', printer_size_constraints.i_max_height_mm, ' 0 0 0 0 0 0 0 0 0 0');
		for var i : byte := 1 to 11 do writeln(f);		// FREEDOM ! (aggiunti 2016-07-03 a partire dalla versione $0326

		writeln(f, END_OF_GALATEO_FILE);

		system.close(f);

		wo_versione_read := GALATEO_VERSION;	// dopo il salvataggio, la versione diventa quella attuale

		var bo_save_all := FALSE;
		for var i : logical_page_type := 0 to i_pagine_logiche-1 do begin	// verifico se vi sono pagine logiche da salvare
			if lpZB_info[i].bo_external then continue;	// pagina caricata dall'esterno
			if (lpZB_info[i].str_external_filename = '') then continue;	// pagina residente, ma non salvata esternamente
			var bo_save_this := FALSE;
			if NOT bo_save_all then begin
				case domanda_multipla_04_proc(get_active_form, MBOX_CAPTION, 'Vuoi salvare la pagina logica ' + (i + 1).ToString + ACAPO +
					'<' + page_caption(i + 1, TRUE) + '>' + ACAPO + ' sul file <' + lpZB_info[i].str_external_filename + '> ?',
					0, 'Salva', 'Non salvare', 'Salva tutte','')
				of
					0 : break;	// interrompo la verifica
					1 : bo_save_this := TRUE;
					2 : {bo_save_this := FALSE};
					3 : bo_save_all := TRUE
				end
			end;
			if (bo_save_all OR bo_save_this) AND NOT save_external_logical_page(i + 1, FALSE) then abort
		end;
		result := TRUE;GM.bo_modified := FALSE
	except
		MessageBBox(get_active_form, 'Salvataggio fallito', MBOX_CAPTION, MB_ICONSTOP)
	end;
	set_wait_cursor(FALSE)
end;
{$endif MSWINDOWS}

	procedure TGlobale.nuova_etichetta;
	begin
		if GM.bo_modified then begin
			case MessageBBox(get_active_form, 'Vuoi salvare le modifiche?', MBOX_CAPTION, MB_QUESTION) of
				IDYES: if NOT save(str_filename) then exit;
				IDNO: ;
				IDCANCEL : exit
			end
		end;
		for var i_page_1B : logical_page_type := 1 to get_ultima_pagina_logica do begin
			set_pagina_logica_attiva_ZB(i_page_1B + 1, FALSE);
			while (i_objs > 0) do begin xobjs(i_objs,i_page_1B).free;set_num_objs(i_objs-1) end;
			tm.default_values(getdc(GM.handle), printer_default[0].str_printer);
			set_num_sections(1);
{			for var i_section : section_index_type := MAIN_SECTION+1 to get_num_sections do begin
				sections_1B(i_section).free;assign_section(i_section, NIL);
				panels(i_section).Visible := FALSE
			end; }
			for var i_section_ZB : section_index_type := {MAIN_SECTION_ZB +} 1 to get_num_sections - 1 do begin
				sections_ZB(i_section_ZB).free;assign_section_ZB(i_section_ZB, NIL);
//				panels_ZB(i_section_ZB).Visible := FALSE	// secondo me questa istruzione è sbagliata
				panels_ZB(0).Visible := FALSE	// 2021-03-06 questa potrebbe essere quella giusta
			end;
//			set_num_sections(1)
		end;
		for var i_page_1B : logical_page_type := 1 to MAX_PAGINE_LOGICHE do lpZB_info[i_page_1B - 1].reset(i_page_1B);
		set_pagina_logica_attiva_ZB(0, TRUE);
		GM.set_disegno_values;
		connection_config.clear;
		str_filename := '';//str_db_table := '';xstr_local_connection_parms := '';str_db_driveralias := '';bo_alias := FALSE;
		GM.bo_modified := FALSE
	end;

{	procedure TGlobale.link_label_2_address_database;
	// collega l'etichetta al database standard indirizzi
	begin
		if (lowercase(str_db_table) = TBL_RUBRICA_VIEW) AND
			(lowercase(str_db_driver) = ODBC_STANDARD_DRIVER_NAME) AND NOT bo_alias
		then begin
			MessageBBox(get_handle, 'L''etichetta è già collegata al database indirizzi standard.',MBOX_CAPTION);
			exit
		end;

		if (MessageBBox(get_handle, 'Vuoi collegare l''etichetta al database indirizzi standard?', MBOX_CAPTION,MB_YESNOCANCEL) <> IDYES) then exit;
		str_db_table := TBL_RUBRICA_VIEW;
		str_db_driver := ODBC_STANDARD_DRIVER_NAME;
		bo_alias := FALSE;
		bo_modified := TRUE
	end; }

	function Tglobale.write_label(var f : system.Text) : boolean;
	{ formato LABEL: OPZIONI GENERALI / OGGETTI / OPZIONI MAIN SECTION;
	  rende TRUE in caso di successo }
	begin
		try
			writeln(f,i_objs);
			for var i : obj_index_type := 1 to i_objs do write_object(f, i);
//			sections_1B(MAIN_SECTION).write(f);
			sections_ZB(MAIN_SECTION_ZB).write(f);
			// a partire dalla versione $0214
			writeln(f, get_label_size_X_cm:0:4, ' ', get_label_size_Y_cm:0:4, ' ', get_page_marg_SX_cm_ZB :0:4, ' ', get_page_marg_UP_cm_ZB:0:4);
			// a partire dalla versione $0255 -------------------------------------
			writeln(f, bool2SQL(orizzontale_ZB({pagina}0)), ' ', get_PHpage_size_X_cm_1B, ' ', get_PHpage_size_Y_cm_1B);
			if NOT write_profiles({i_pagina}1, f) then abort;
			// fine modifica versione $0255 ---------------------------------------
			for var i : byte := 1 to 12 do writeln(f);	// free space for future
			result := TRUE
		except
			result := FALSE
		end
	end;

	function Tglobale.save_external_logical_page(i_logical_page : logical_page_type;bo_ask : boolean) : boolean;
	{ salva su file esterno della pagina logica specificata;
	  passare -1 per indicare la pagina logica corrente;
	  rende TRUE se ha salvato la pagina, FALSE se non l'ha salvata;
	  if BO_ASK then chiede all'utente una conferma preliminare }
	var f : system.Text;
	begin
		result := FALSE;
		var i_previous_active_page : logical_page_type := get_pagina_logica_attiva_1B;
		if (i_logical_page = -1) then i_logical_page := get_pagina_logica_attiva_1B;
		var xp : cl_logical_page_info := lpZB_info[i_logical_page - 1];
		if xp.bo_external then begin
			MessageBBox(get_handle, 'Impossibile esportare una pagina logica non residente', MBOX_CAPTION);
			exit
		end;

		if (xp.get_descrizione(TRUE) = '') then	// warning only
			MessageBBox(get_handle, page_caption(i_logical_page, TRUE) + ACAPO2 + 'manca la descrizione della pagina logica', MBOX_CAPTION);

		if (xp.str_external_filename = '') then begin
			MessageBBox(get_handle, 'Specifica il nome del file su cui esportare la pagina logica', MBOX_CAPTION);
			if (i_logical_page = i_previous_active_page) then pagina_logica_edit_proc(get_active_form, FALSE);
			exit
		end;

		if bo_ask AND
			(MessageBBox(get_handle, 'Vuoi salvare la pagina logica corrente su <' + xp.str_external_filename + '> ?', MBOX_CAPTION, MB_QUESTION) <> IDYES)
				then exit;	// rende FALSE

		try
			try
				set_wait_cursor(TRUE);

				// verifico se è stato indicato un PATH e, nel caso, se esiste
				var s := xp.str_external_filename;
				if (pos('\', s) <> 0) then begin
					s := ExtractFilePath(s);
					if NOT DirectoryExists(s) then raise exception.create(
						'Il percorso indicato per il salvataggio della pagina logica non esiste o non è accessibile.' + ACAPO2 +
//						'pagina logica ' + i_logical_page.ToString + ': ' + xp.get_descrizione(TRUE) + ACAPO2 +
						'file: ' + xp.str_external_filename)
				end;

				assignfile(f,xp.str_external_filename);rewrite(f);
				obj_select(0,FALSE,FALSE);	// tolgo la selezione
				if (i_logical_page <> i_previous_active_page) then set_pagina_logica_attiva_1B(i_logical_page, FALSE);
				if NOT write_pagina_logica_attiva(f, TRUE) then abort;

{				writeln(f);writeln(f);	// spazio di rispetto
				writeln(f, EXTERNAL_EXPINT_PROFILE_START);
				writeln(f,'exporting page ', i_logical_page);
				for var i_profilo : expint_index_type := 0 to high(expint_profiles) do
					expint_profiles[i_profilo].expint_pages[i_logical_page-1].write(f, i_profilo, i_logical_page-1);
				writeln(f, EXTERNAL_EXPINT_PROFILE_END);
				writeln(f);writeln(f);	}	// spazio di rispetto

				system.close(f)
			finally
				if (i_logical_page <> i_previous_active_page) then set_pagina_logica_attiva_1B(i_previous_active_page,FALSE);
				set_wait_cursor(FALSE)
			end;
			result := TRUE
		except
			{$I-} system.close(f);if IOresult = 0 then; {$I+}	// chiudo alla bell'emeglio
			error_msg('Errore durante il salvataggio della pagina logica ' + i_logical_page.ToString +
				' (' + xp.get_descrizione(TRUE) + ')', MBOX_CAPTION);
//			result := FALSE
		end
	end;

	function TGlobale.write_pagina_logica_attiva(var f : system.Text;bo_external_file : boolean) : boolean;
	{ scrive la pagina logica attiva sul file specificato; rende TRUE in caso di successo;
	  if BO_EXTERNAL_FILE then si tratta del salvataggio di una pagina logica salvata su un file esterno,
	  e viene trattata in modo sensibilmente differente }
	begin
		try
			var i_pagina_ZB : logical_page_type := get_pagina_logica_attiva_ZB;
			var i_pagina_1B := i_pagina_ZB + 1;
			var xp : cl_logical_page_info := lpZB_info[i_pagina_ZB];
			writeln(f{, xp.str_sigla});	// non serve a niente ma è necessario per backward compatibility; fino alla $0302 scriveva qui anche la sigla della pagina, la versione $0304 non scrive questa riga (per errore)
			for var i : byte := 1 to 2 do writeln(f);
			if NOT bo_external_file then begin
				writeln(f, bool2SQL(xp.bo_external), xp.str_external_filename);
				writeln(f, xp.str_page_ID);
				writeln(f, bool2SQL(xp.bo_message_if_not_printed));
				for var i : byte := 1 to 3 do writeln(f)
			end;
			if xp.bo_external then begin		// la pagina logica è salvata su un file esterno
				for var i : byte := 1 to 7 do writeln(f);
				result := TRUE;exit
			end;

			if bo_external_file then begin
				writeln(f, GALATEO_VERSION);
				writeln(f, str_filename_phisical);	// 2006-06-19
				for var i : byte := 1 to 11 do writeln(f)		// future implementation (external file only)
			end;
			writeln(f, get_num_sections);
			writeln(f, xp.str_descrizione_estesa);
			writeln(f, bool2SQL(orizzontale_ZB(i_pagina_ZB)));
			writeln(f, get_PHpage_size_X_cm_ZB(i_pagina_ZB), ' ', get_PHpage_size_Y_cm_ZB(i_pagina_ZB));
			if NOT write_profiles(i_pagina_1B, f) then abort;
{			writeln(f,get_page_size_X_cm(i_pagina_1B),get_page_size_Y_cm(i_pagina_1B),
				get_page_marg_SX_cm(i_pagina_1B),get_page_marg_UP_cm(i_pagina_1B));
			writeln(f,char(byte(get_flag_printer_pagina_logica(i_pagina_1B))+byte('0')),get_printer_page(i_pagina_1B));
			writeln(f,get_cassetto_carta_page(i_pagina_1B)); }

			writeln(f, xp.str_PDF_watermark);
			writeln(f, xp.str_message_if_printed);
			if (tiporeport = TR_LABEL_REPORT) then begin
				writeln(f, get_label_size_X_cm, ' ', get_label_size_Y_cm);
				writeln(f, byte(draw_lines_separazione_label), ' 0 0 0 0 0 0 0 0 0')
			end
			else begin writeln(f);writeln(f) end;
{			writeln(f, byte(xp.bo_export_allowed):2, byte(xp.bo_print_pagina_logica):2, byte(xp.bo_print_sezione):2,
				byte(xp.bo_print_pagina_fisica):2, byte(xp.bo_print_record_number):2, byte(xp.bo_print_headers):2,
				byte(NOT xp.bo_blankrow_after_headers):2, ' 0 0 0 0 0'); }
			writeln(f, get_numero_etichette_const, ' ', get_numero_etichette_object);
			for var i : byte := 1 to 2 do writeln(f);

			for var i : section_index_type := MAIN_SECTION_ZB to get_num_sections_page_ZB(i_pagina_ZB) - 1 do write_section_ZB(f, i);
			writeln(f, byte(xp.bo_default_print_page), ' ', xp.i_colore_base, ' ', xp.i_colore_alt);
			writeln(f, xp.str_descrizione_breve);
			writeln(f, bool2SQL(xp.bo_attiva_GAPP));			// 2006-03-15
			writeln(f, xp.str_GAPP_obj_tipo_progressivo);	// 2006-03-15
			writeln(f, xp.str_GAPP_obj_esercizio);				// 2006-03-15
			writeln(f, xp.str_GAPP_obj_record);					// 2006-03-15
			writeln(f, xp.str_GAPP_obj_dt_riferimento);		// 2006-03-15
			writeln(f, xp.str_GAPP_obj_operatore);				// 2006-03-15
			writeln(f, byte(xp.bo_dont_print_phisical),		// riga scritta dalla versione $030D 2013-02-03
				byte(xp.printer_size_constraints_mode):2,
				' ', xp.printer_size_constraints_phisical_values.i_min_width_mm,
				' ', xp.printer_size_constraints_phisical_values.i_min_height_mm,
				' ', xp.printer_size_constraints_phisical_values.i_max_width_mm,
				' ', xp.printer_size_constraints_phisical_values.i_max_height_mm,
				byte(xp.bo_exclude_debug):2, ' 0 0 0 0 0 0 0 0 0 0 0 0 0');

			writeln(f, xp.str_condizione_esecuzione);
			for var i : byte := 1 to 10 do writeln(f);	// free space for future implementations
			if bo_external_file then for var i : byte := 1 to 12 do writeln(f);	// future implementation (external file only)
			result := TRUE
		except
			result := FALSE
		end
	end;

	function Tglobale.write_report(var f : system.Text) : boolean;
	begin
		try
			var k : logical_page_type := get_pagina_logica_attiva_ZB;
			writeln(f, get_num_sections, ' ', i_pagine_logiche);
			for var i_ZB : logical_page_type := 0 to i_pagine_logiche - 1 do begin
				set_pagina_logica_attiva_ZB(i_ZB, FALSE);
				if NOT write_pagina_logica_attiva(f, FALSE) then abort
			end;
			set_pagina_logica_attiva_ZB(k, FALSE);
			result := TRUE
		except
			result := FALSE
		end
	end;

{$endif NOT DLL}

function TGlobale.read_pagina_logica_external(str_external_filename : string;i_logical_page : logical_page_type) : boolean;
// legge la pagina logica corrente dal file specificato; rende TRUE in caso di successo
label start;
const
	VERSIONE_BASE_EXTERNAL_FILE = $0105;
	RUNTIME_DEBUG_CAPTION = 'read_pagina_logica_external()';
var f : system.Text;
begin
	var str_runtime_debug_caption := 'lp=' + i_logical_page.ToString + ' basefile=' + str_external_filename + ' -- ';
	writeln_system_debug(100, RUNTIME_DEBUG_CAPTION, str_runtime_debug_caption + 'START');
	try
		{$I-}
		// provo sul file come è espressamente indicato (senza interpretazioni)
		var str_assigned_filename := str_external_filename;
		writeln_system_debug(110, RUNTIME_DEBUG_CAPTION, str_runtime_debug_caption + 'before try ' + str_assigned_filename);
		assignfile(f, str_assigned_filename);reset(f);
		if (IOresult = 0) then goto start;	// OK

		// provo sulla directory corrente
		var s := ExtractFileName(str_external_filename);
		str_assigned_filename := s;
		writeln_system_debug(120, RUNTIME_DEBUG_CAPTION, str_runtime_debug_caption + 'before try ' + str_assigned_filename);
		assignfile(f, str_assigned_filename);reset(f);
		if (IOresult = 0) then goto start;	// OK

		// provo sulla directory su cui si trova il file principale
		str_assigned_filename := ExtractFilePath(str_filename) + s;
		writeln_system_debug(130, RUNTIME_DEBUG_CAPTION, str_runtime_debug_caption + 'before try ' + str_assigned_filename);
		assignfile(f, str_assigned_filename);reset(f);
		{$I+}
		if (IOresult = 0) then goto start;	// OK

		writeln_system_debug(199, RUNTIME_DEBUG_CAPTION, str_runtime_debug_caption + 'pre abort (file not found: ' + str_assigned_filename + ')');
		abort;	// file not found
start:
		writeln_system_debug(200, RUNTIME_DEBUG_CAPTION, str_runtime_debug_caption + '### FOUND: <' + str_assigned_filename + '> ###');
		var wo_versione : word := VERSIONE_BASE_EXTERNAL_FILE;
		if NOT read_pagina_logica_attiva(f, wo_versione, TRUE) then abort;
		writeln_system_debug(300, RUNTIME_DEBUG_CAPTION, str_runtime_debug_caption + 'after read <' + str_assigned_filename + '>');

{		***** salvataggio delle importazioni di exportazione generale;
		mi sono accorto solo a posteriori che l'operazione è logicamente impossibile a causa del numero potenzialmente differente tra report e external file;
		potrebbe avere senso tutt'al più pensare all'exportazione di UN SOLO PROFILO (il primo) che in genere è sufficiente;
		if (wo_versione >= $0305) then begin
			readln(f);readln(f);	// spazio di rispetto
			readln(f, s);if (s <> EXTERNAL_EXPINT_PROFILE_START) then abort;
			readln(f);	// 'exporting page ', i_logical_page
			for var i_profilo : smallint := 0 to high(expint_profiles) do
				if NOT expint_profiles[i_profilo].expint_pages[i_logical_page-1].read(f, i_profilo, i_logical_page-1) then abort;
			readln(f, s);if (s <> EXTERNAL_EXPINT_PROFILE_END) then abort;
			readln(f);readln(f)	// spazio di rispetto
		end;	}

		system.close(f);
		writeln_system_debug(900, RUNTIME_DEBUG_CAPTION, str_runtime_debug_caption + 'END');
		result := TRUE
	except
		result := FALSE;
		writeln_system_debug(999, RUNTIME_DEBUG_CAPTION, str_runtime_debug_caption + 'exception: ' + get_last_exception_msg);
		{$I-} system.close(f);if IOresult = 0 then; {$I+}
		MessageBBox(get_handle, 'Caricamento pagina logica ' + i_logical_page.ToString + ACAPO2 +
			'Impossibile leggere il file <' + str_external_filename + '>', MBOX_CAPTION, MB_ICONSTOP)
	end
end;

function Tglobale.read_report(var f : system.Text;wo_versione : word;str_runtime_load_filenames : string) : boolean;
const RUNTIME_DEBUG_CAPTION = 'read_report()';
label after, restart_loop;
var
	i_sections : smallint;	//**
	{$ifndef DLL} x, y : objs_type; {$endif}
begin
	result := TRUE;
//	runtime_debug('BEGIN OF',RUNTIME_DEBUG_CAPTION,RD_DEBUG_ACCESSORIO_01);
	writeln_system_debug(100, RUNTIME_DEBUG_CAPTION, 'start');
	read(f, i_sections);	// n° di sections; valore non più utilizzato, ma da caricare per i files fino alla ver 0x101
	{ $ifdef DEBUG} if (i_sections = 197) then {beep(0)}; { $endif}	// solo per evitare la warning !!!
	if eoln(f) then i_pagine_logiche := 1 else read(f, i_pagine_logiche);
	readln(f);

//	for i_page := 1 to MAX_PAGINE_LOGICHE do lpZB_info[i_page - 1].reset(i_page);
	for var i_page_ZB : smallint := 0 to MAX_PAGINE_LOGICHE - 1 do lpZB_info[i_page_ZB].reset(i_page_ZB + 1);
//	for i_page := 1 to i_pagine_logiche do begin
	for var i_page_ZB : smallint := 0 to i_pagine_logiche - 1 do begin
		if eof(f) then break;
//		runtime_debug('inizio loop ' + i_page.ToString, RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		writeln_system_debug(103, RUNTIME_DEBUG_CAPTION, 'start loop --------');
		set_pagina_logica_attiva_ZB(i_page_ZB, FALSE);
//		runtime_debug('105',RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		writeln_system_debug(105, RUNTIME_DEBUG_CAPTION);
//		if (i_page > 1) then set_main_section_values;	// imposta i valori per la sezione principale
		if (i_page_ZB > MAIN_SECTION_ZB) then set_main_section_values;	// imposta i valori per la sezione principale (solo per le pagine successive alla prima)
//		runtime_debug('110',RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		writeln_system_debug(110, RUNTIME_DEBUG_CAPTION);
		if NOT read_pagina_logica_attiva(f, wo_versione, FALSE, str_runtime_load_filenames)
			then result := FALSE;	// comunico ma continuo la lettura, altrimenti rimango sempre a mezz'aria
//		runtime_debug('120',RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		writeln_system_debug(120, RUNTIME_DEBUG_CAPTION);

{$ifndef DLL}
//		for j := 1 to i_objs do xobjs(j, i_page).check_size;
		for var jz : smallint := 0 to i_objs_ZB(i_page_ZB) - 1 do xobjs_ZB(jz, i_page_ZB).check_size;
restart_loop:
//		for j := 1 to i_objs-1 do begin
		for var jz : smallint := 0 to i_objs_ZB(i_page_ZB) - 1 do begin
//			x := xobjs(j, i_page);
			x := xobjs_ZB(jz, i_page_ZB);
//			for k := j + 1 to i_objs do begin
			for var kz : smallint := jz + 1 to i_objs_ZB(i_page_ZB) - 1 do begin
//				y := xobjs(k, i_page);
				y := xobjs_ZB(kz, i_page_ZB);
				if (x.ca.tipo_oggetto <> y.ca.tipo_oggetto) then continue;
				if (x.ca.i_section_1B <> y.ca.i_section_1B) then continue;
				if (abs(x.get_top - y.get_top) > 1) OR (abs(x.get_left - y.get_left) > 1) then continue;
				if (abs(x.get_height - y.get_height) > 1) OR (abs(x.get_width - y.get_width) > 1) then continue;
				if (x.ca.tipo_oggetto in ALPHABETIC_OBJS) AND (x.get_name <> y.get_name) then continue;
				if x.ca.bo_consenti_sovrapposizione_oggetti_simili OR y.ca.bo_consenti_sovrapposizione_oggetti_simili then continue;
//				case x.get_tipo of
//					xTESTO, xVARIABILE, xFORMULA : if (x.get_name <> y.get_name) then continue;
//					DATAMATRIX : ;		/// NON SO BENE cosa fare e x' -- 2011-05-09
//					xOBJ_BITMAP, OBJ_RECT, OBJ_LINE : { fine dei controlli };
//				end;
				case MessageBBox(get_handle, 'Pagina logica ' + get_pagina_logica_attiva_1B.ToString + ACAPO +
					'Sezione <' + sections_ZB(get_section_attiva_ZB).str_nome + '>' + ACAPO +
					'<' + x.get_name + '>' + ACAPO2 +
					'Vi sono due oggetti [' + TIPO_OGGETTO_DESCRIZIONE[x.ca.tipo_oggetto] + '] apparentemente identici (o molto simili) e vicinissimi.' + ACAPO2 +
					'Elimino il secondo?', MBOX_CAPTION, MB_QUESTION_DEF2)
				of
//					IDYES : begin delete_object(k, FALSE, FALSE);goto restart_loop end;	// riparto perchè gli oggetti sono cambiati
					IDYES : begin delete_object(kz + 1, FALSE, FALSE);goto restart_loop end;	// riparto perchè gli oggetti sono cambiati
					IDNO: ;
					IDCANCEL : goto after
				end
			end
		end;
after:
{$endif NOT DLL}
	end;

	writeln_system_debug(999, RUNTIME_DEBUG_CAPTION, 'end of')
end;

(*function Tglobale.read_report(var f : system.Text;wo_versione : word;str_runtime_load_filenames : string) : boolean;
const RUNTIME_DEBUG_CAPTION = 'read_report()';
label after, restart_loop;
var
	i_page, i_sections : smallint;
{$ifndef DLL}
	j, k : smallint;
	x, y : objs_type;
{$endif}
begin
	result := TRUE;
//	runtime_debug('BEGIN OF',RUNTIME_DEBUG_CAPTION,RD_DEBUG_ACCESSORIO_01);
	writeln_system_debug(100, RUNTIME_DEBUG_CAPTION, 'start');
	read(f, i_sections);	// n° di sections; valore non più utilizzato, ma da caricare per i files fino alla ver 0x101
	{ $ifdef DEBUG} if (i_sections = 197) then {beep(0)}; { $endif}	// solo per evitare la warning !!!
	if eoln(f) then i_pagine_logiche := 1 else read(f, i_pagine_logiche);
	readln(f);

	for i_page := 1 to MAX_PAGINE_LOGICHE do lpZB_info[i_page - 1].reset(i_page);
	for i_page := 1 to i_pagine_logiche do begin
		if eof(f) then break;
//		runtime_debug('inizio loop ' + i_page.ToString, RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		writeln_system_debug(103, RUNTIME_DEBUG_CAPTION, 'start loop --------');
		set_pagina_logica_attiva_1B(i_page, FALSE);
//		runtime_debug('105',RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		writeln_system_debug(105, RUNTIME_DEBUG_CAPTION);
		if (i_page > 1) then set_main_section_values;	// imposta i valori per la sezione principale
//		runtime_debug('110',RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		writeln_system_debug(110, RUNTIME_DEBUG_CAPTION);
		if NOT read_pagina_logica_attiva(f, wo_versione, FALSE, str_runtime_load_filenames)
			then result := FALSE;	// comunico ma continuo la lettura, altrimenti rimango sempre a mezz'aria
//		runtime_debug('120',RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		writeln_system_debug(120, RUNTIME_DEBUG_CAPTION);

{$ifndef DLL}
		for j := 1 to i_objs do xobjs(j, i_page).check_size;
restart_loop:
		for j := 1 to i_objs-1 do begin
			x := xobjs(j, i_page);
			for k := j + 1 to i_objs do begin
				y := xobjs(k, i_page);
				if (x.ca.tipo_oggetto <> y.ca.tipo_oggetto) then continue;
				if (x.ca.i_section_1B <> y.ca.i_section_1B) then continue;
				if (abs(x.get_top - y.get_top) > 1) OR (abs(x.get_left - y.get_left) > 1) then continue;
				if (abs(x.get_height - y.get_height) > 1) OR (abs(x.get_width - y.get_width) > 1) then continue;
				if (x.ca.tipo_oggetto in ALPHABETIC_OBJS) AND (x.get_name <> y.get_name) then continue;
				if (x.ca.bo_consenti_sovrapposizione_oggetti_simili OR y.ca.bo_consenti_sovrapposizione_oggetti_simili) then continue;
//				case x.get_tipo of
//					xTESTO, xVARIABILE, xFORMULA : if (x.get_name <> y.get_name) then continue;
//					DATAMATRIX : ;		/// NON SO BENE cosa fare e x' -- 2011-05-09
//					xOBJ_BITMAP, OBJ_RECT, OBJ_LINE : { fine dei controlli };
//				end;
				case MessageBBox(get_handle, 'Pagina logica ' + get_pagina_logica_attiva_1B.ToString + ACAPO +
					'Sezione <' + sections_ZB(get_section_attiva_ZB).str_nome + '>' + ACAPO +
					'<' + x.get_name + '>' + ACAPO2 +
					'Vi sono due oggetti [' + TIPO_OGGETTO_DESCRIZIONE[x.ca.tipo_oggetto] + '] apparentemente identici (o molto simili) e vicinissimi.' + ACAPO2 +
					'Elimino il secondo?', MBOX_CAPTION, MB_QUESTION_DEF2)
				of
					IDYES : begin delete_object(k, FALSE, FALSE);goto restart_loop end;	// riparto perchè gli oggetti sono cambiati
					IDNO: ;
					IDCANCEL : goto after;
				end
			end
		end;
after:
{$endif NOT DLL}
	end;

	writeln_system_debug(999, RUNTIME_DEBUG_CAPTION, 'end of')
end; *)

procedure Tglobale.write_str_filename(s : string);
begin
	s := lowercase(ExpandFileName(s));
	str_filename_phisical := s;
//	if (s = '') then s := PROGRAM_NAME else s := PROGRAM_NAME + ' - ' + s;
	s := PROGRAM_NAME + ifs(s, ' - ' + s);
	application.Title := s;
//	{$ifndef DLL} GM.Caption := s + ifs(GALATEO_VERSION <> wo_versione_read, ' [' + wo_versione_read.ToString + '/' + GALATEO_VERSION.ToString + ']') {$endif}
	{$ifndef DLL} GM.Caption := s + ifs(GALATEO_VERSION <> wo_versione_read, ' [' + version_of(wo_versione_read, '') + '/' + version_of(GALATEO_VERSION, '') + ']') {$endif}
end;

procedure TGlobale.set_keep_connections(bo_keep : boolean);
begin
	phisical_system_database.ResourceOptions.KeepConnection := bo_keep
end;

function TGlobale.get_default_printer(bo_blank_if_predefinita : boolean) : string;
{ determina la stampante default in funzione della situazione;
  per default rende comunque la stampante predefinita di sistema;
  se il risultato della funzione è la stampante predefinita AND BO_BLANK_IF_PREDEFINITA, rende BLANK anzichè la stampante predefinita }
begin
	result := '';
	case modalita_selezione_default_printer of
//		DPST_SYSTEM_DEFAULT : {result := printer.Printers[printer.printerindex]};
		DPST_SYSTEM_DEFAULT : begin
			var bo_assegnata_software := (uppercase(str_current_printer) <> uppercase(str_stampante_predefinita));	// assegnata dal software chiamante
			if bo_assegnata_software then result := str_current_printer // else result := ''
		end;
//		DPST_LAST_USED : result := coalesce(str_current_printer, printer.Printers[printer.printerindex]);
		DPST_LAST_USED : result := str_last_printer_used;
		DPST_RUNTIME_SELECTED : ;	// lascio comunque la predefinita, obbligherò l'utente a scegliere al momento giusto
		DPST_GALATEO : begin
			for var i : smallint := 0 to NUMERO_DEFAULT_PRINTERS-1 do begin
				var s := printer_default[i].str_printer;
				if (s <> '') AND (printer.Printers.indexof(s) <> -1) then begin
					result := s;break
				end
			end
		end
	end;
	if (result = '') then result := str_stampante_predefinita;
	if bo_blank_if_predefinita AND (uppercase(result) = uppercase(str_stampante_predefinita)) then result := '';
//	result := uppercase(result)
end;

{function Tglobale.xget_current_printer(bo_blank_if_predefinita : boolean): string;
begin
	result := xstr_current_printer;
	if bo_blank_if_predefinita AND (result = '') then result := str_stampante_predefinita
end;	}

function TGlobale.select_printer(str_new_printer : string) : boolean;
{ attiva la stampante specificata e la imposta come standard per il documento;
  restituisce l'indice della stampante selezionata nel vettore PRINTER.PRINTERS[];
  se STR_NEW_PRINTER = '' si limita ad attivare la stampante già selezionata;
  in caso di errore rende -1 }
begin
	try
		set_wait_cursor(TRUE);	// dal 2008-09-09
//		if (str_new_printer = '') then str_new_printer := printer.printers[printer.printerindex];
		if (str_new_printer = '') then str_new_printer := str_stampante_predefinita;
//		var str_printer := str_new_printer;
		if (str_new_printer <> '') then begin
			if (printer.printers.indexof(str_new_printer) = -1) AND
				(printer_default[1].str_printer <> '') AND (printer.printers.indexof(printer_default[1].str_printer) <> -1)
					then str_new_printer := printer_default[1].str_printer
		end;
//		str_new_printer := uppercase(str_new_printer);		// 2011-07-23
//		str_new_printer := str_new_printer;						// 2011-07-23

		set_phisical_active_printer(NIL, {forza}get_windows_version >= WVT_8, str_new_printer, TRUE);	// dal 2004-05-28
		str_current_printer := str_new_printer;	// 2011-07-23
		{$ifdef TESTDEBUG} messagebbox(0, 'stampante attiva=' + printer.printers[printer.printerindex], MBOX_CAPTION); {$endif}
		result := TRUE
	except
		result := FALSE
	end;
	set_wait_cursor(FALSE)
end;

procedure Tglobale.FormClose(Sender : TObject);
// questa procedure deve essere chiamata dall'interno della Close di Controllo
begin
	try
		try
			{$ifndef DLL} GM.Sbox.Visible := FALSE; {$endif}
			ClipCursor(NIL);			// a scanso di equivoci, libero il cursore
			{$ifndef DLL} obj_select(0, FALSE, FALSE); {$endif}	// deseleziono l'eventuale oggetto selezionato
			{ sezioni e oggetti dovrebbero essere distrutti nella GUN.FINALIZATION, ma preferisco anticipare qui la cosa
			  perchè sono legati al Form che viene distrutto e fanno casino }
			for var i : obj_index_type := 1 to MAX_PAGINE_LOGICHE do begin
				set_pagina_logica_attiva_1B(i, {update_video}FALSE);
				for var j : obj_index_type := 1 to i_objs(i) do begin
					xobjs(j, i).free;
					assign_obj(j, NIL)
				end;
				set_num_objs(0, i);
				for var k : obj_index_type := 0 to MAX_SECTIONS-1 do if (sections_ZB(k) <> NIL) then begin
//					panels(j).free;{assign_panel(j,NIL);
					sections_ZB(k).free;assign_section_ZB(k, NIL)
				end
			end;
			set_pagina_logica_attiva_1B(1, FALSE);
			if phisical_system_database.Connected then begin
				phisical_system_database.Connected := FALSE;
				{$ifndef DLL} delete_log_file {$endif}
			end;
			text_only_font.free;
//			for i := 1 to SQL_PRE_SCRIPTS_NUMBER do tsql_scripts_pre[i].free;
//			for i := 1 to SQL_POST_SCRIPTS_NUMBER do tsql_scripts_post[i].free;
			tsql_stored_procs_definition.free;
//			for i := 0 to MAX_PAGINE_LOGICHE-1 do lpZB_info[i].free;
			{$ifndef DLL} salvataggi := TStringList.create; {$endif}
			tstr_remarks.free
		finally
			{$ifndef DLL} GM.Sbox.Visible := TRUE {$endif}
		end
	except
		MessageBBox(get_active_form, 'Errore durante la chiusura di ' + PROGRAM_NAME_BASE, MBOX_CAPTION, MB_ICONSTOP)
	end
end;

// --------------------------------

constructor cl_connection_configuration.create(father : TForm);
begin
	self.father := father;
	database_parms := cl_database_parms.create;
	clear
end;

destructor cl_connection_configuration.free;
begin
	if (database_parms <> NIL) then begin database_parms.Free;database_parms := NIL end
end;

function cl_connection_configuration.get_parametri_connessione(pt_error_galateo_NOT_allowed : boolean_punt = NIL) : string;
// se in OUTPUT pt_error_galateo_NOT_allowed^ il problema è che il profilo di connessione (JOLLY) non consente accesso da GALATEO
const MBOX_DEBUG_CAPTION = 'XXXXXXXXXXXXXXXXX cl_connection_configuration.get_parametri_connessione()';
begin
{$ifdef DLL}
//	result := str_external_connection_parms;	*** fino 2024-03-19
	result := coalesce(str_external_connection_parms, xstr_default_connection_parms);
//	debug(25, MBOX_DEBUG_CAPTION, 'FIRST VALUE=' + str_external_connection_parms + ' ::::: ' + xstr_default_connection_parms);	{$ifNdef DEBUG} ***** {$endif DEBUG}
{$endif DLL}
	if (result = '') AND read_profile(globale.str_filename, pt_error_galateo_NOT_allowed) then begin
		result := database_parms.asstring;
//		debug(26, MBOX_DEBUG_CAPTION, 'database_parms.asstring=' + result)	{$ifNdef DEBUG} ***** {$endif DEBUG}
	end;
	if (result = '') then begin
		result := self.str_parametri_connessione;
//		debug(27, MBOX_DEBUG_CAPTION, 'self.xstr_parametri_connessione=' + result)	{$ifNdef DEBUG} ***** {$endif DEBUG}
	end
end;

function cl_connection_configuration.assign(source : cl_connection_configuration) : cl_connection_configuration;
begin
//	debug(25, 'ZZZZZZZZZZZZZZZZZZZZ', 'source.str_external_connection_parms=' + source.str_external_connection_parms);	{$ifNdef DEBUG} ***** {$endif DEBUG}
	bo_read_from_profile := source.bo_read_from_profile;str_profile := source.str_profile;str_profile_path := source.str_profile_path;
	bo_login_prompt := source.bo_login_prompt;//	bo_alias := source.bo_alias;
	str_driver := source.str_driver;str_table := source.str_table;str_parametri_connessione := source.str_parametri_connessione;
	{$ifdef DLL} str_external_connection_parms := source.str_external_connection_parms; {$endif}
	database_parms.assign(source.database_parms);
	result := self
end;

function cl_connection_configuration.blank : boolean;
begin
	result := (str_profile = '') AND (str_driver = '') AND (str_parametri_connessione = '') {$ifdef DLL} AND (str_external_connection_parms = '') {$endif}
end;

procedure cl_connection_configuration.clear;
begin
	bo_read_from_profile := TRUE;
	str_profile := {$ifdef JOLLY} *'JOLLY' {$else} '' {$endif};
	str_profile_path := '';
//	bo_alias := FALSE;
	bo_login_prompt := FALSE;
	str_driver := '';str_table := '';str_parametri_connessione := '';
	{$ifdef DLL} str_external_connection_parms := ''; {$endif}
	database_parms.reset
end;

function cl_connection_configuration.read(var f : Text;wo_versione : word): boolean;
var i : smallint;	//**
begin
	{$ifdef DEBUG} assert(wo_versione >= $0403, 'wrong version -- KLPW 3091'); {$endif DEBUG}
	readln(f, {alias}i, byte(bo_read_from_profile), byte(bo_login_prompt));
	if (i = -1) then;		// solo per evitare la compiler warning
	readln(f, str_profile);
	readln(f, str_profile_path);
	readln(f);
	readln_LPSTR(f, str_parametri_connessione);
	str_parametri_connessione := stringa2hex_decode(str_parametri_connessione, TRUE);
	readln(f, str_driver);
	readln(f, str_table);
	readln(f);readln(f);
	result := TRUE
end;

function cl_connection_configuration.read_profile(str_report_filename : string;pt_bo_galateo_cannot_connect : boolean_punt) : boolean;
// legge i dati dal FILE-profilo specificato; rende TRUE in caso di successo, oppure FALSE se non è stato possibile (per qualunque motivo) eseguire l'operazione
var str_profile_phisical_filename : string;	//*

	function check_path(str_path : string) : boolean;
	begin
		if (pt_bo_galateo_cannot_connect <> NIL) then pt_bo_galateo_cannot_connect^ := FALSE;
		var str_filename := make_filename(str_profile_phisical_filename, str_path);
//		result := FileExists(str_filename) AND database_parms.read_from_file(father, str_filename) AND database_parms.bo_galateo_free_access
		result := FileExists(str_filename) AND database_parms.read_from_file(father, str_filename, {error_message}NIL,
			{allow_free_galateo_access}(pt_bo_galateo_cannot_connect <> NIL));
		if result AND NOT database_parms.bo_galateo_free_access then begin
			result := FALSE;
			if (pt_bo_galateo_cannot_connect <> NIL) then pt_bo_galateo_cannot_connect^ := TRUE
		end
	end;

begin
	result := FALSE;
	if (pt_bo_galateo_cannot_connect <> NIL) then pt_bo_galateo_cannot_connect^ := FALSE;
	database_parms.reset;
	if NOT bo_read_from_profile OR (str_profile = '') then exit;
	str_profile_phisical_filename := database_parms.make_profile_filename(str_profile, TRUE);if (str_profile_phisical_filename = '') then exit;
	result := (str_profile_path <> '') AND check_path(str_profile_path);
	if NOT result then result := check_path(extractFilePath(str_report_filename));
	if NOT result then result := check_path(extractFilePath(paramstr(0)))
end;

{$ifdef GALATEO_EXE}
function cl_connection_configuration.write(var f : Text) : boolean;	// dalla versione $0403 in poi
begin
	writeln(f, {alias}'0', byte(bo_read_from_profile):2, byte(bo_login_prompt):2, ' 0 0 0 0 0 0 0 0');
	writeln(f, str_profile);
	writeln(f, str_profile_path);
	writeln(f);
	writeln(f, stringa2hex_encode(str_parametri_connessione, TRUE));
	writeln(f, str_driver);
	writeln(f, str_table);
	writeln(f);writeln(f);
	result := TRUE
end;
{$endif GALATEO_EXE}

{$ifNdef DLL}
procedure Tglobale.set_connessione_database;
begin
//	var bo := database_proc(self, bo_alias, bo_login_prompt, str_db_driveralias, str_db_table, str_parametri_connessione_DB);
//	var bo := xdatabase_proc(father, bo, bo_login_prompt, s, str_db_table, xstr_local_connection_parms);
	var bo := xdatabase_proc(father, @connection_config);

//	dlg_database := Tdlg_database.xcreate(self,bo_alias,bo_login_prompt,xstr_db_driver,str_db_table,str_parametri_connessione_DB,@bo);
//	dlg_database.showmodal;dlg_database.release;
//	if (str_db_driveralias = '') then db_galateo.Connected := FALSE;
	if (connection_config.get_parametri_connessione = '') then system_database.Connected := FALSE;
	if bo AND (connection_config.str_table <> '') then begin
//		dlg_dblink := Tdlg_dblink.xcreate(self, str_db_driveralias <> '',str_db_table);
		dlg_dblink := Tdlg_dblink.xcreate(father, connection_config.get_parametri_connessione <> '', connection_config.str_table);
		dlg_dblink.ShowModal;dlg_dblink.release
	end;
	GM.bo_modified := bo
end;

{$else}	// NOT DLL

procedure TGlobale.stampa(father : TForm;bo_manuale : boolean;lo_print_style : integer);
// if BO_MANUALE THEN esegue la stampa manuale ELSE esegue la stampa manuale o da database in funzione della configurazione dell'etichetta
const MBOX_DEBUG_CAPTION = 'TGlobale.stampa()';
label manuale;
begin
//	static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: START :: ' + RDEBUG_DESCRIZIONE[RDEBUG_active_mode] + '   ' + GALATEO_DEBUG_TARGET_DESCR[galateo_debug.debug_target]);
	writeln_system_debug(0, MBOX_DEBUG_CAPTION, 'start');
	if (father = NIL) then father := self.father;
	{$ifndef DLL} obj_select(0, FALSE, FALSE); {$endif}	// deseleziono tutti gli oggetti
	try
		IO_dynamic_images(TRUE);	// carico le immagini dinamiche

//		if NOT select_printer(coalesce(xget_printer_page(1),str_printer)) then exit;	NON deve essere assegnata la stampante, ma solo le impostazioni in funzione della stampante
//		if NOT select_printer(printer_default[0].str_printer) then exit;
		if NOT select_printer(get_default_printer(TRUE)) then exit;

		// se la stampante è determinata, verifico che esista
		if (modalita_selezione_default_printer = DPST_GALATEO) then begin
			var i : smallint := 0;
			var s := uppercase(str_current_printer);
			var str_printers : string;
			while (i < NUMERO_DEFAULT_PRINTERS) AND (s <> uppercase(printer_default[i].str_printer)) do begin
				add_delimited(str_printers, printer_default[i].str_printer, ACAPO, TRUE);
				inc(i)
			end;
			if (i = NUMERO_DEFAULT_PRINTERS) then begin		// stampante fissata non esistente
				if (numero_elementi_lista(str_printers, ACAPO) = 1) then s := 'Stampante non esistente: ' + str_printers
				else s := 'Nessuna delle stampanti previste è disponibile' + ACAPO2 + str_printers;

				case azione_printer_unknown of
					APUT_SELECT_NEW_PRINTER : begin
						if (azione_opening_report_executive = AORT_PRINT_PRINTER_DIRECT)		// evito la stampa diretta senza passare dal dialog di selezione stampante
							then azione_opening_report_executive := AORT_PRINT_PRINTER;
						MessageBBox(get_active_form, s + ACAPO2 + 'Selezionare una nuova stampante', MBOX_CAPTION)
					end;
					APUT_ABORT : begin MessageBBox(get_active_form, s + ACAPO2 + 'Stampa ANNULLATA', MBOX_CAPTION, MB_ICONSTOP);exit end;
					APUT_USE_PRINTER_DEFAULT : MessageBBox(get_active_form, s + ACAPO2 + 'Viene utilizzata la stampante predefinita: ' + str_stampante_predefinita, MBOX_CAPTION);
					{$ifdef DEBUG} else assert(FALSE, 'JOWP 3991') {$endif}
				end
			end
		end;

//		set_db_driver(bo_login_prompt, str_db_driveralias, str_local_connection_parms, bo_alias);
//		writeln_system_debug(140, MBOX_DEBUG_CAPTION, 'connection_config.get_parametri_connessione=' + connection_config.get_parametri_connessione);
		set_db_driver(connection_config.bo_login_prompt, connection_config.get_parametri_connessione);
//		if bo_report then print_report_proc(father,lo_print_style)
		if (tiporeport in REPORT_TYPES) then print_report_proc(father, lo_print_style)
{$ifdef DLL}
		{$ifdef DEBUG} else assert(FALSE,'globale.stampa(): NOT bo_report'); {$endif}
{$else}
		else begin
			var bo_database := NOT bo_manuale AND (connection_config.str_table <> '');
			var p : LPSTR := stralloc(100);
			var lo_totale_labels : integer;
			var bo_2manuale : boolean;	**
			Windows.GetPrivateProfileString(PROGRAM_NAME_BASE, INI_TOTAL_LABEL_PRINT, '0', p, strbufsize(p), FILE_INI);
			Lval(strpas(p), lo_totale_labels, i);
			if bo_database then begin
//				select_proc(self, str_db_driveralias, str_db_table, lo_totale_labels, bo_2manuale);
				select_proc(get_active_form, s, connection_config.str_table, lo_totale_labels, bo_2manuale);
				if bo_2manuale then goto manuale
			end
			else begin
manuale:
				running_window := Trunning_window.xcreate(get_active_form, lo_totale_labels);
				running_window.showmodal;running_window.release
			end;
			WritePrivateProfileString(PROGRAM_NAME_BASE, INI_TOTAL_LABEL_PRINT, lo_totale_labels.ToString, FILE_INI);
			strdispose(p)
		end
{$endif DLL}
	finally
		IO_dynamic_images(FALSE)		 // ricarico le immagini statiche
	end
end;

procedure TGlobale.set_db_driver_runtime(str_parametri_connessione_DB : string);
// esegue il MERGE tra i parametri interni e quelli esterni
var
	s : string;	//*
	i_row : integer;	//*
begin
	var it_base := TValueListEditor.create(NIL);
	var it_runt := TValueListEditor.create(NIL);
	try
		sostituisci(str_parametri_connessione_DB, ';', ACAPO);
		it_runt.Strings.Text := str_parametri_connessione_DB;
		s := connection_config.get_parametri_connessione;
		it_base.Strings.Text := sostituisci(s, ';', ACAPO);

		// se una stringa definita staticamente su GALATEO non è compresa sul set definito RUNTIME, la aggiungo
		for var i : smallint := 0 to it_base.Strings.Count-1 do begin
			var str_temp := it_base.Keys[i+1];	// bastardata, comportamento anomalo del componente
			if NOT it_runt.FindRow(it_base.Keys[i+1], i_row) then begin
				str_temp := it_base.Strings[i];
				it_runt.Strings.Add(it_base.Strings[i]);
				str_temp := it_runt.Strings.Text
			end
		end;
		s := it_runt.Strings.Text
	except
		s := str_parametri_connessione_DB
	end;

	it_base.Free;it_runt.Free;
	set_db_driver(connection_config.bo_login_prompt, s)
end;
{$endif DLL}

procedure TGlobale.set_db_driver(bo_login_prompt : boolean;str_connection_parms : string);
begin
(*	self.bo_alias := bo_alias;
	{$ifdef DLL}
		if (str_db_driver = '') then
			str_db_driver := ifs(bo_alias, coalesce(str_runtime_default_database_alias, str_runtime_default_system_database_alias),
				coalesce(xstr_runtime_default_database_driver, str_runtime_default_system_database_driver));
	{$endif}
	self.str_db_driveralias := str_db_driver; *)
	var bo_was_connected := phisical_system_database.Connected;
	phisical_system_database.Connected := FALSE; 	// a scanso di equivoci
//	if bo_alias then db_galateo.Aliasname := str_db_driver else db_galateo.Drivername := str_db_driver;
	phisical_system_database.LoginPrompt := bo_login_prompt;
	phisical_system_database.Params.Text := str_connection_parms;
//	set_default_database_parms(str_parametri_connessione_DB);	*************
//	set_default_database_parms(str_alias, str_Username, str_Password : string;wo_Port : word = 0) : cl_database_parms;
	connection_config.str_parametri_connessione := str_connection_parms;
	phisical_system_database.Connected := bo_was_connected
end;

function Tglobale.get_connessione_blank : boolean;
{ concetto introdotto 2007-11-25:
  se CONNESSIONE_BLANK, non c'è nessuna connessione esplicita a database
  (se non c'è connessione ci troviamo tipicamente nel caso di nome fisico di DBF-file) }
begin
//	result := (str_db_driveralias = '')		*** fino 2012-11-19
//	result := (str_db_driveralias = '') {$ifdef DLL} AND (str_runtime_default_database_alias = '') {$endif}	// {$ifNdef DEBUG} **** ??? {$endif}
	result := (connection_config.get_parametri_connessione = '')
end;

function Tglobale.get_databasename : string;
begin
	// il collegamento al DB può essere richiesto anche prima che venga aperta la PRINT_REPORT, che usualmente inizializza il database
//	if connessione_blank OR ((xdb_report = NIL) AND NOT init_db_report(xdb_report)) then result := ''
	if connessione_blank OR ((phisical_report_database = NIL) AND NOT init_db_report(phisical_report_database)) then result := ''
	else result := REPORT_DATABASENAME

//	result := str_db_driver
{	if (str_db_driver = '') then result := ''
	else
		if (db_report = NIL) then result := DB_GALATEO_NAME
		else result := REPORT_DATABASENAME }
end;

function Tglobale.init_db_report(var db : TFDatabase;str_databasename : string = '') : boolean;
{ crea, inizializza e connette il database per i reports; rende TRUE se tutto OK, FALSE in caso di problemi
  se DB = NIL viene inizializzato il DB default (DB_REPORT) }
const MBOX_DEBUG_CAPTION = 'Tglobale.init_db_report()';
label retry;
begin
	debug(0, MBOX_DEBUG_CAPTION, 'start');
	var bo_login_prompt := connection_config.bo_login_prompt;
	if (str_databasename = '') then str_databasename := REPORT_DATABASENAME;
retry:
	if (db <> NIL) then begin result := TRUE;exit end;	// già inizializzato
	result := FALSE;

	debug(10, MBOX_DEBUG_CAPTION, '');
//	db := TFDatabase.create(father);	*** così fino 2021-02-14
	db := TFDatabase.create(father, {debug}XTRUE, {late_destroy}FALSE, {disable_macros}TRUE);		// così dal 2021-02-14

//	static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: 300 :: ');
	debug(20, MBOX_DEBUG_CAPTION, '');
	db.Name := str_databasename;db.Databasename := str_databasename;
//	s := coalesce(str_db_driveralias, str_runtime_default_database_alias);
//	if bo_alias then db.Aliasname := str_db_driveralias else db.Drivername := str_db_driveralias;
	var bo_error_galateo_NOT_allowed : boolean := FALSE;
//	static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: 400 :: ');
	db.Params.Text := connection_config.get_parametri_connessione(@bo_error_galateo_NOT_allowed);
//	debug(25, MBOX_DEBUG_CAPTION, db.Params.Text);	{$ifNdef DEBUG} ***** {$endif DEBUG}
	db.LoginPrompt := bo_login_prompt;
//	static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: 500 :: ' + db.Params.Text);
	debug(30, MBOX_DEBUG_CAPTION, ifs(connessione_blank, 'connessione blank', 'NOT BLANK'));
	if connessione_blank then result := TRUE	// 2007-11-25: se connessione blank, non c'è nessuna connessione esplicita (tipicamente: nome fisico di DBF-file)
	else begin
		try
			debug(100, MBOX_DEBUG_CAPTION, 'before connect');
			db.Connected := TRUE;		// tanto vale farlo subito
			debug(110, MBOX_DEBUG_CAPTION, 'after connect');
			result := TRUE
		except
//			{$ifNdef DLL} error_msg(handle,'Errore durante la connessione a ' + str_db_driver,MBOX_CAPTION); {$endif}
//			error_msg(handle, 'Errore durante la connessione a ' + str_db_driveralias, MBOX_CAPTION);
			debug(800, MBOX_DEBUG_CAPTION, 'exception on connect');
			error_msg(father, 'Errore durante la connessione al database' +
				ifs(bo_error_galateo_NOT_allowed, ACAPO2 + 'Il profilo di accesso database <' + connection_config.str_profile + '> non è utilizzabile da GALATEO.'), MBOX_CAPTION);
			db.Free;db := NIL
		end;
		if (db = NIL) AND NOT bo_login_prompt then begin bo_login_prompt := TRUE;goto retry end
	end;
	debug(999, MBOX_DEBUG_CAPTION, 'finally')
//	;static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: 999 :: ');
end;

function Tglobale.resize_subsection(i_page : logical_page_type;i_deltay_10mm : smallint;bo_ask_on_problem : boolean) : boolean;
{ ridimensiona la sezione; rende TRUE se l'operazione richiesta viene eseguita, FALSE se l'operazione viene bloccata;
  verifica che la dimensione della sottosezione non si annulli, e
	if (bo_ask_on_problem) emette eventuali messaggi di conferma, else emette messaggio di avvertimento dei problemi }
begin
	if (i_deltay_10mm = 0) then begin result := TRUE;exit end;	// nessun ridimensionamento richiesto

	result := FALSE;
	if (get_num_sections_page(i_page) = 1) then exit;	// nulla da fare
	var s2 : cl_sezione := sections_1B(2, i_page);
	if NOT s2.bo_autosize then exit;
	var r_new_y_cm : double := s2.r_y_sezione_cm + i_deltay_10mm / 100;
	var str_descrizione := 'ridimensionamento richiesto: ' + floattostr(i_deltay_10mm / 100) + ' cm' + ACAPO +
		'max possibile: ' + floattostr(s2.r_y_gruppo_cm - s2.r_y_sezione_cm) + ' cm';
	if bo_ask_on_problem then
		result := (r_new_y_cm < s2.r_y_gruppo_cm) AND (MessageBBox(get_handle,
			'Impossibile effettuare il ridimensionamento richiesto per la sottosezione.' + ACAPO2 +
			str_descrizione + ACAPO2 +
			'Eseguo il ridimensionamento massimo possibile?', s2.get_name, MB_QUESTION_DEF2)
		= IDYES)
	else begin
		result := TRUE;	// eseguo comunque, a prescindere dal permesso
		if (r_new_y_cm < s2.r_y_gruppo_cm) then MessageBBox(get_handle,
			'Impossibile effettuare il ridimensionamento richiesto per la sottosezione' + ACAPO2 + str_descrizione, s2.get_name, MB_ICONSTOP)
	end;
	if result then s2.r_y_sezione_cm := max(r_new_y_cm, s2.r_y_gruppo_cm)
end;

procedure Tglobale.move_objects(i_page : logical_page_type;i_deltay_10mm : smallint);
var i_limite_sup_ss_pixel, i_limite_inf_ss_pixel : int_pixel_type;	// limiti inferiore e superiore della subsection
begin
	var i_deltay_pixel : int_pixel_type := cm2pixel_video_y(i_deltay_10mm / 100);
	var i_top : int_pixel_type := 0;
	var i_height : int_pixel_type := 0;
	if (get_num_sections_page(i_page) = 1) OR NOT sections_1B(2, i_page).bo_autosize then begin
		i_limite_sup_ss_pixel := 0;
		i_limite_inf_ss_pixel := 0
	end
	else with sections_1B(2, i_page) do begin
		i_limite_sup_ss_pixel := cm2pixel_video_y(r_y0_rel_cm);
		i_limite_inf_ss_pixel := cm2pixel_video_y(r_y0_rel_cm + r_y_sezione_cm)
	end;

	try
		bo_exclude_azioni_comunitarie := TRUE;
		for var i_obj : obj_index_type := 1 to i_objs(i_page) do begin
			var obj : objs_type := xobjs(i_obj,i_page);
			if (obj.ca.i_section_1B <> MAIN_SECTION) then continue;
//if (i_obj <> 1) then continue;	{$ifdef DEBUG} *** {$endif}
			case obj.ca.tipo_oggetto of
				LABEL_OBJ, OBJ_BITMAP, DATAMATRIX_OBJ : begin
					if (i_limite_inf_ss_pixel = 0) then begin	// se non ci sono sottosezioni utilizzo l'indicazione FOOTER dell'oggetto
						if obj.ca.bo_footer then obj.set_top(obj.get_top + i_deltay_pixel)
					end
					else begin		// sposto tutti gli oggetti che si trovano al di sotto della sottosezione
						i_top := obj.get_top;
						if (i_top > i_limite_inf_ss_pixel) then obj.set_top(i_top + i_deltay_pixel)
					end
				end;
				OBJ_RECT, OBJ_LINE : begin
					var bo_move := FALSE;var bo_resize := FALSE;
					if (i_limite_inf_ss_pixel = 0) then begin		// se non ci sono sottosezioni utilizzo l'indicazione FOOTER dell'oggetto
						bo_move := obj.ca.bo_footer;
//						bo_resize := obj.get_common_attributes.bo_autoresize
					end
					else begin
						i_top := obj.get_top;
						if (i_top > i_limite_inf_ss_pixel) then bo_move := TRUE
						else begin
							i_height := obj.get_height;
							bo_resize := (i_top < i_limite_sup_ss_pixel) AND (i_top + i_height > i_limite_inf_ss_pixel)
						end
					end;
					{$ifdef DEBUG} assert(NOT (bo_move AND bo_resize), 'DJSHD 9231 --- NOT (bo_move AND bo_resize) ---'); {$endif}
					if bo_move then obj.set_top(i_top + i_deltay_pixel);
					if bo_resize then obj.set_height(i_height + i_deltay_pixel)
				end;
				{$ifdef DEBUG} else assert(FALSE,'FDJJ 2993') {$endif}
			end
		end
	finally
		bo_exclude_azioni_comunitarie := FALSE
	end
end;

procedure Tglobale.autosize_printer_page(bo_ask : boolean = FALSE);
const
	MBOX_CAPTION = 'Ridimensionamento foglio';

	procedure resize_page(i_page : logical_page_type;i_deltay_10mm : smallint);
	var r_min_size_cm : misura_real_type;
	begin
		if NOT sections_1B(MAIN_SECTION, i_page).bo_autosize then exit;
		runtime_debug('start page ' + i_page.ToString, MBOX_CAPTION, RD_DEBUG_ACCESSORIO_01);

		if (i_deltay_10mm < 0) then begin	// verifico se il rimpicciolimento non è eccessivo
			if (get_num_sections_page(i_page) > 1) then
				with sections_1B(2, i_page) do r_min_size_cm := r_y0_rel_cm + r_y_gruppo_cm
			else r_min_size_cm := 0;
			if (get_Vpage_size_Y_cm(i_page) + i_deltay_10mm/100 < r_min_size_cm) then
				i_deltay_10mm := round((r_min_size_cm - get_Vpage_size_Y_cm(i_page)) * 100)
		end;

		// se devo rimpicciolire la pagina, prima adatto le subsections e sposto gli oggetti
		if (i_deltay_10mm < 0) then begin
			resize_subsection(i_page,i_deltay_10mm,FALSE);	// prima ridimensiono la subsection
			move_objects(i_page,i_deltay_10mm)				 	// poi sposto gli oggetti
		end;

		set_Vpage_size_Y_cm(i_page,get_Vpage_size_Y_cm(i_page) + i_deltay_10mm / 100);

		// se devo ingrandire la sezione, lo faccio dopo aver spostato gli oggetti e ridimensionato le subsections
		if (i_deltay_10mm > 0) then begin
			move_objects(i_page, i_deltay_10mm);					// prima sposto gli oggetti
			resize_subsection(i_page, i_deltay_10mm, FALSE)	// poi ridimensiono la subsection
		end;
		runtime_debug('end page ' + i_page.ToString, MBOX_CAPTION, RD_DEBUG_ACCESSORIO_01)
	end;

begin
//	exit;
	if NOT bo_autosize_page OR (i_printer_reference_height_10mm = 0) then exit;
	if (i_forced_width_10mm <> 0) AND (i_forced_height_10mm <> 0) then exit;

	var i_deltay_10mm : smallint := tm.i_phisical_10mm_height - i_printer_reference_height_10mm;		//* quanto deve essere ALLUNGATO il foglio rispetto allo standard
	if (i_deltay_10mm = 0) then exit;
	if bo_ask AND
		(MessageBBox(get_handle, 'Vuoi modificare la dimensione della pagina in funzione della stampante selezionata?', MBOX_CAPTION, MB_QUESTION) <> IDYES)
			then exit;

	runtime_debug('000 start',MBOX_CAPTION, RD_DEBUG_ACCESSORIO_01);
	for var i_page : logical_page_type := 1 to get_ultima_pagina_logica do resize_page(i_page, i_deltay_10mm);
	i_printer_reference_height_10mm := tm.i_phisical_10mm_height;
	runtime_debug('999 end', MBOX_CAPTION, RD_DEBUG_ACCESSORIO_01)
end;

function TGlobale.get_debug_base : boolean;
begin
	result := bo_phisical_debug_base OR bo_application_debug_base
end;

function TGlobale.get_debug_full : boolean;
begin
	result := bo_phisical_debug_full OR bo_application_debug_full
end;

procedure TGlobale.debug_message(father : TForm = NIL);
// emetto un eventuale messaggio di segnalazione del debug in corso
begin
	if bo_debug_base
		{$ifdef DLL} AND NOT (computer_registry_data.bo_exclude_runtime_message_computer OR bo_exclude_runtime_message_report) {$endif}
	then begin
		var str_filename := get_debug_filename(self.str_filename);
		MessageBBox(get_active_form, DEBUG_MSG[bo_debug_full] + ifs(str_debug_computer, ' [' + str_debug_computer + ']') +
			ifs(bo_application_debug_base, ' [richiesta runtime]') +
			ifs(str_filename, ACAPO2 + 'debug filename: ' + str_filename), MBOX_CAPTION)
	end
end;

{$ifNdef DLL}
	procedure TGlobale.set_debug_base(bo : boolean); begin bo_phisical_debug_base := bo end;
	procedure TGlobale.set_debug_full(bo : boolean); begin bo_phisical_debug_full := bo end;
{$endif}

function TGlobale.get_handle(calling_form : TForm = NIL) : hwnd;
begin
(*//	result := get_active_form.handle
//	if (dlg_working <> NIL) then result := dlg_working.handle else	// 2006-09-01
	if ww_exists then result := get_working_window.handle else	// 2009-12-13
	if (main_form <> NIL) then result := main_form.handle else
	{$ifndef DLL} if (controllo <> NIL) then result := GM.handle else {$endif}
	result := handle *)
	result := Fsystem_base.get_handle(get_active_form)
end;

function TGlobale.get_active_form(calling_form : TForm = NIL) : TForm;
// rende una form valida ed attiva a cui è possibile 'attaccare' eventuali finestre di messaggio o di altro genere
begin
//	if (dlg_working <> NIL) then result := dlg_working else		// 2006-09-01
	{$ifdef CASA} if ww_exists then result := get_working_window else {$endif}			// 2009-12-13
	if (calling_form <> NIL) then result := calling_form else	// 2006-09-01
	if (main_form <> NIL) then result := main_form else
	{$ifndef DLL} if (GM <> NIL) then result := GM else {$endif}
	result := father
end;

{$ifdef CASA}

function Tglobale.get_report_database: TFDatabase;
begin
	if bo_use_transaction then begin
		if (phisical_report_database = NIL) then
			phisical_report_database := create_database(father, TI_READ, {start_trans}FALSE, {debug}TRUE, {aliasname}'', {conn_name}DB_GALATEO_NAME, {ask_parms}XFALSE, {connect}FALSE, {auto_reconnect}TRUE);
		result := phisical_report_database
	end
	else result := get_system_database
end;

procedure Tglobale.set_report_database(db : TFDatabase);
begin
	if bo_use_transaction then phisical_report_database := NIL
//	else ********* NOTHING, non riassegno il SYSTEM_DATABASE
end;

{$endif CASA}

function Tglobale.get_system_database : TFDatabase;
begin
	if (phisical_system_database = NIL) then
		phisical_system_database := create_database(father, TI_READ, {start_trans}FALSE, {debug}TRUE, {aliasname}'', {conn_name}DB_GALATEO_NAME,
			{ask_parms}XFALSE, {connect}FALSE, {auto_reconnect}TRUE);
	if NOT phisical_system_database.Connected AND connection_config.read_profile(str_filename, {galateo_rights}NIL) then		// provo a leggere il profilo
		phisical_system_database.Params.Text := connection_config.database_parms.asstring;
	result := phisical_system_database
end;

procedure Tglobale.set_system_database(db : TFDatabase);
begin
	phisical_system_database := db
end;

initialization
	galateo_initialization_debug('Gun');
	set_debug_mbox_caption(INIT_LOCAL_PROGRAM_NAME);
	set_default_database_parms_BLANK;		// non utilizzo i dati default di connessione a database (anche perchè potrebbero essere più databases differenti)
	set_registry_program_name(INIT_LOCAL_PROGRAM_NAME);
//	{$ifndef DLL} str_galrun_path := read_registry_string('', '', GALRUNT_PATH_REGISTRY_ITEM); {$endif}
finalization
	galateo_finalization_debug('Gun');
{$ifdef DEBUG}
	CCI(i_macro_parametrica, 'cl_macro_parametrica', 'Gun.pas');
	CCI(i_logical_page_info, 'cl_logical_page_info', 'Gun.pas');
	CCI(i_global, 'Tglobale', 'Gun.pas')
{$endif}
end.
