unit Pages;	//*

{	pagine logiche: le diverse pagine che compongono un report pagine
	pagine fisiche: le pagine stampate
	pagine VIRTUALI: nel caso del report coincidono con le pagine fisiche, altrimenti con le etichette }

{ questa unit contiene le procedure necessarie per la gestione delle differenti
  pagine fisiche/logiche e delle sezioni che compongono i documenti;
  funziona un po' come una classe con una serie di properties, salvo il fatto
  che la unit sarebbe la classe, e le private properties sono oggetti non
  visibili all'esterno della unit;
  ho scelto questo (relativamente poco elegante) approccio per la complessità
  intrinseca del discorso e per la maggior libertà che mi ha lasciato in
  fase di strutturazione }

{$I defines}
{	$D-,$L-}
{	$L+,D+}
{$ifdef PROVA_FAST} {$R-,S-} {$endif}

{ $WARN SYMBOL_DEPRECATED OFF}
{$W-}

interface

uses Sysutils, Windows, VCL.Graphics, VCL.Extctrls, Classes, Math, VCL.Forms,
	Fcommons, FSQLsoft,
	{$ifndef DLL} panel, {$endif}
	Gdich, objects, Gun, printers_VCL, printers_DX, sezione;

type
	print_status_type =
	  (PS_INATTIVA,		// stato non attivo
		PS_LOADING,			// caricamento report da file -- aggiunto 2025-04-05
		PS_LOADED,			// caricamento report da file completato -- aggiunto 2025-04-05
		xPS_PREPARING,		// stampa in preparazione
		PS_PREVIEW,			// in anteprima di stampa
		PS_PRINTING,		// stampa in corso
		PS_ERROR,			// stampa interrotta da errore
		PS_CANCELLED,		// stampa interrotta dall'utente
		PS_OK);				// stampa terminata felicemente

	// classe che gestisce il profilo di stampa (stampante, impostazioni, cassetti) in funzione del profilo operatore selezionato
	cl_print_profile = class
		public
			str_profilo : string;				// blank per il profilo default
			function read_profile(var f : text) : boolean;
			{$ifndef DLL} function save_profile(var f : text) : boolean; {$endif}
		private
			next : cl_print_profile;
			str_printer, str_cassetto_carta : string;
//			xfgppl : xFGPPL_type;					// FlaG Print Pagina Logica
			r_marg_sx_cm_ph, r_marg_up_cm_ph : misura_real_type;
			str_attiva_on_workstation : string;			// il profilo viene caricato automaticamente sulla workstation specificata
			str_attiva_on_IP : string;						// il profilo viene caricato automaticamente in presenza dell' IP specificato
			str_attiva_on_windows_username : string;	// il profilo viene caricato automaticamente se lo username windows è quello specificato
			bo_set_from_calling_program : boolean;		// profilo assegnato dal programma principale ?
			constructor create;
			destructor free;
			procedure assign(p : cl_print_profile);
	end;

{$ifndef DLL}
	const
		HELP_PROFILES = 'I profili di stampa consentono di attivare impostazioni specifiche in funzione di specifici contesti.' + ACAPO2 +
			'I differenti profili possono essere attivati:' + ACAPO2 +
			'- via programma, attraverso opportune chiamate RUNTIME alla DLL.' + ACAPO +
			'  il profilo impostato via programma è prioritario' + ACAPO2 +
			'- automaticamente al verificarsi di un insieme di condizioni (nome computer, windows account, IP).' + ACAPO +
			'  Le condizioni di attivazione devono essere TUTTE contemporaneamente soddisfatte';
{$endif}

(*		***** commentato (x' inutile) 2011-07
type
	// tipi di impostazione per il trattamento delle indicazioni di stampa specifiche per le pagine logiche
	xFGPPL_type = (
		FGPPL_NOTHING,							// nessuna indicazione
		FGPPL_USE_ON_SPECIFIED_PRINTER,	// utilizza le indicazioni (cassetto carta) se la stampa avviene sulla stampante specificata
		FGPPL_USE_ALWAYS_IMPOSTAZIONI);	// utilizza sempre le indicazioni (stampante/cassetto carta)
const
	FGPPL_LAST = FGPPL_USE_ALWAYS_IMPOSTAZIONI;
	{$ifndef DLL}
		FGPPL_codice : array[xFGPPL_type] of string = (
			'Nessuna',
			'Sulla stampante indicata',
			'Sempre (se possibile)');
		FGPPL_descrizione : array[xFGPPL_type] of string = (
			'',
			'NB: le impostazioni inserite troveranno applicazione solamente quando sarà utilizzata la stampante indicata',
			'NB: le impostazioni inserite saranno applicate sempre (ove possibile) a prescindere dalla stampante utilizzata'
		);
	{$endif} *)
var
	xprint_status : array[1..MAX_JOBS] of print_status_type;

function		check_printer_page_size(father : TForm;i_pagina_logica_1B : logical_page_type;i_width_mm, i_height_mm : smallint) : boolean;

function		get_pagina_logica_attiva_ZB : logical_page_type;
function		get_pagina_logica_attiva_1B : logical_page_type;
function		set_pagina_logica_attiva_ZB(i_pagina_logica : logical_page_type;bo_update_video : boolean;bo_forza_esecuzione : boolean = FALSE) : logical_page_type;
function		set_pagina_logica_attiva_1B(i_pagina_logica_1B : logical_page_type;bo_update_video : boolean;bo_forza_esecuzione : boolean = FALSE) : logical_page_type;
function		get_ultima_pagina_logica : logical_page_type;

procedure	text_only_BeginDoc;
procedure	text_only_EndDoc;
procedure	text_only_Abort;
procedure	text_only_newpage;
procedure	text_only_closepage;
procedure	text_only_print(i_riga,i_colonna : smallint;s : string);

function		get_printer_page(i_page_1B : logical_page_type) : string;
procedure	set_printer_page(str_printer : string;i_page_1B : logical_page_type);

function		get_cassetto_carta_page(i_page_1B : logical_page_type) : string;
procedure	set_cassetto_carta_page(str_cassetto_carta : string;i_page_1B : logical_page_type);

function		get_workstation_page(i_page_1B : logical_page_type) : string;
procedure	set_workstation_page(str_workstation : string;i_page_1B : logical_page_type);

function		get_IP_page(i_page_1B : logical_page_type) : string;
procedure	set_IP_page(str_IP : string;i_page_1B : logical_page_type);

function		get_username_page(i_page_1B : logical_page_type) : string;
procedure	set_username_page(str_username : string;i_page_1B : logical_page_type);

//function		xget_flag_printer_pagina_logica(i_page_1B : logical_page_type) : xFGPPL_type;
//procedure	xset_flag_printer_pagina_logica(fgppl : xFGPPL_type;i_page_1B : logical_page_type);

function		pagina_stampata(i_page_1B : logical_page_type) : boolean;

// -----------------------------------------------------------------------------

function		get_page_marg_SX_cm_1B(i_page_1B : logical_page_type = 1) : misura_real_type;
function		get_page_marg_SX_cm_ZB(i_page_ZB : logical_page_type = 0) : misura_real_type;
procedure	set_page_marg_SX_cm_1B(i_page_1B : logical_page_type;r_value : misura_real_type);
procedure	set_page_marg_SX_cm_ZB(i_page_ZB : logical_page_type;r_value : misura_real_type);

function		get_page_marg_UP_cm_1B(i_page_1B : logical_page_type = 1) : misura_real_type;
function		get_page_marg_UP_cm_ZB(i_page_ZB : logical_page_type = 0) : misura_real_type;
procedure	set_page_marg_UP_cm_1B(i_page_1B : logical_page_type;r_value : misura_real_type);
procedure	set_page_marg_UP_cm_ZB(i_page_ZB : logical_page_type;r_value : misura_real_type);

// -----------------------------------------------------------------------------

{	VIRTUAL PAGES: dimensione di una pagina VIRTUALE
	se sono su un report coincide con la pagina fisica
	se sono su una label concide con la dimensione della singola label;
	per scegliere quali usare domandarsi:
		il valore riguarda SEMPRE la pagina fisica (29.7 x 21)? >>>>>>>> PH
		il valore riguarda la dimensione della label >>>>>>>>>>>>>>>>>>> LABEL
		il valore riguarda la dimensione PH se si tratta di report oppure la dimensione della label se label? >>>>>>>>> VIRTUAL ! }

function		get_Vpage_size_X_cm(i_page_1B : logical_page_type = 1) : misura_real_type;
procedure	set_Vpage_size_X_cm(i_page_1B : logical_page_type;r_value : misura_real_type);
function		i_Vpage_size_X_pix_video(i_page_1B : logical_page_type) : int_pixel_type;
function		i_Vpage_size_X_pix_print(i_page_1B : logical_page_type) : int_pixel_type;

function		get_Vpage_size_Y_cm(i_page_1B : logical_page_type = 1) : misura_real_type;
procedure	set_Vpage_size_Y_cm(i_page_1B : logical_page_type;r_value : misura_real_type);
function		i_Vpage_size_Y_pix_video(i_page_1B : logical_page_type) : int_pixel_type;
function		i_Vpage_size_Y_pix_print(i_page_1B : logical_page_type) : int_pixel_type;

// -----------------------------------------------------------------------------

//	PHisical PAGES: dimensione fisiche delle pagine logiche (si intende sempre superficie stampabile, non dimensione del foglio della stampante)

function		get_PHpage_size_X_cm_1B(i_page_1B : logical_page_type = 0) : misura_real_type;
function		get_PHpage_size_X_cm_ZB(i_page_ZB : logical_page_type = -1) : misura_real_type;
procedure	set_PHpage_size_X_cm_1B(i_page_1B : logical_page_type;r_value : misura_real_type);
procedure	set_PHpage_size_X_cm_ZB(i_page_ZB : logical_page_type;r_value : misura_real_type);
function		i_PHpage_size_X_pix_video(i_page_1B : logical_page_type) : int_pixel_type;
function		i_PHpage_size_X_pix_print(i_page_1B : logical_page_type) : int_pixel_type;

function		get_PHpage_size_Y_cm_1B(i_page_1B : logical_page_type = 1) : misura_real_type;
function		get_PHpage_size_Y_cm_ZB(i_page_ZB : logical_page_type = 0) : misura_real_type;
procedure	set_PHpage_size_Y_cm_1B(i_page_1B : logical_page_type;r_value : misura_real_type);
procedure	set_PHpage_size_Y_cm_ZB(i_page_ZB : logical_page_type;r_value : misura_real_type);
function		i_PHpage_size_Y_pix_video(i_page_1B : logical_page_type) : int_pixel_type;
function		i_PHpage_size_Y_pix_print(i_page_1B : logical_page_type) : int_pixel_type;

// -----------------------------------------------------------------------------

function		draw_lines_separazione_label : boolean;
procedure	set_draw_lines_separazione_label(bo : boolean);

//	LABEL PAGES: dimensione delle etichette

function		get_label_size_X_cm : misura_real_type;
procedure	set_label_size_X_cm(r_value : misura_real_type);
function		i_label_size_X_pix_video : int_pixel_type;
function		i_label_size_X_pix_print : int_pixel_type;

function		get_label_size_Y_cm : misura_real_type;
procedure	set_label_size_Y_cm(r_value : misura_real_type);
function		i_label_size_Y_pix_video : int_pixel_type;
function		i_label_size_Y_pix_print : int_pixel_type;

// -----------------------------------------------------------------------------

function		verify_page_size(i_page_1B : logical_page_type;handle : hwnd;printer : TFPrinter) : boolean;
procedure	write_page_measures(i_page_1B : logical_page_type;pbox : TPaintBox;
					x0,y0 : int_pixel_type;tiporeport : REPORT_TYPE;bo_margini : boolean;r_fattore_zoom : real = 1;
					i_width_mm : smallint = 0;i_height_mm : smallint = 0);

function		orizzontale_1B(i_page_1B : logical_page_type) : boolean;
function		orizzontale_ZB(i_page_ZB : logical_page_type) : boolean;
procedure	assign_orizzontale_1B(i_page_1B : logical_page_type;bo_orizzontale : boolean);
procedure	assign_orizzontale_ZB(i_page_ZB : logical_page_type;bo_orizzontale : boolean);
function		sections_1B(i_section_1B : section_index_type;i_page_1B : logical_page_type = 0) : cl_sezione;
function		sections_ZB(i_section_ZB : section_index_type;i_page_ZB : logical_page_type = -1) : cl_sezione;
//function		sections_page(i_section : section_index_type;i_page_1B : logical_page_type) : cl_sezione;
procedure	xassign_section(i_section : section_index_type;section : cl_sezione);
procedure	assign_section_ZB(i_section_ZB : section_index_type;section : cl_sezione);
function		get_num_sections : section_index_type;
function		get_num_sections_page(i_page_1B : logical_page_type) : section_index_type;
function		get_num_sections_page_ZB(i_page_ZB : logical_page_type) : section_index_type;
function		set_num_sections(i_num : section_index_type) : section_index_type;
function		get_section_attiva_1B : section_index_type;
function		get_section_attiva_ZB : section_index_type;
function		set_section_attiva_1B(i_section_1B : section_index_type) : section_index_type;
function		set_section_attiva_ZB(i_section_ZB : section_index_type) : section_index_type;

{$ifndef DLL}
	function		panels_1B(i : smallint) : TGalPanel;
	function		panels_ZB(i_ZB : smallint) : TGalPanel;
	procedure	assign_panel_1B(i_1B : smallint;panel : Tgalpanel);
	procedure	assign_panel_ZB(i_ZB : smallint;panel : Tgalpanel);
{$endif}

//function		xobjs(i : obj_index_type) : objs_type; overload;
function		xobjs(i_obj_1B : obj_index_type;i_page_1B : logical_page_type = 0) : objs_type;
function		xobjs_ZB(i_obj_ZB : obj_index_type;i_page_ZB : logical_page_type = -1) : objs_type;
//function		objs_page(i : obj_index_type;i_page_1B : logical_page_type) : objs_type;	{$ifndef DEBUG} eliminare {$endif}
procedure	assign_obj(i : obj_index_type;obj : objs_type);
function		i_objs(i_page_1B : logical_page_type = 0) : obj_index_type;		// rende il numero di oggetto allocati per la pagina
function		i_objs_ZB(i_page_ZB : logical_page_type = -1) : obj_index_type;		// rende il numero di oggetto allocati per la pagina
procedure	set_num_objs(i_objs : obj_index_type;i_page_1B : logical_page_type = 0);	// assegna il numero di oggetto allocati per la pagina

{$ifndef DLL}
	procedure	set_selected_obj(i_obj : obj_index_type;bo_selected : boolean;bo_beep : boolean = FALSE;bo_update_info : boolean = FALSE);
	function		get_selected_obj(i_pos : obj_index_type = 0) : objs_type;
	function		get_selected_obj_index(i_pos : obj_index_type = 0) : obj_index_type;
	function		get_num_selected_objects : obj_index_type;
	function		is_selected(i_obj : obj_index_type) : boolean;
{$endif}

{$ifndef DLL} procedure	setup_pagina_logica(i_pagina_logica_1B : logical_page_type); {$endif}
{$ifndef DLL} function insert_pagina_logica : boolean; {$endif}
{$ifndef DLL} function delete_pagina_logica : boolean; {$endif}

{$ifdef CASA}
procedure	reset_logical_page_print_values(i_pagina_logica : logical_page_type);
function		get_intervallo_pagine_logiche(str_pagine_logiche : string) : string;

function		get_first_pagina_fisica_of_pagina_logica(i_pagina_logica_1B : logical_page_type = 0) : ph_page_type;
function		get_numero_pagine_fisiche_of_pagina_logica(i_pagina_logica_1B : logical_page_type = 0) : ph_page_type;
function		get_first_pagina_fisica_of_pagina_logica_stampata(i_pagina_logica_1B : logical_page_type = 0) : ph_page_type;
function		get_numero_virtual_pages_of_pagina_logica(i_pagina_logica_1B : logical_page_type = 0) : ph_page_type;
function		get_numero_virtual_pages_of_pagina_logica_stampata(i_pagina_logica_1B : logical_page_type = 0) : ph_page_type;
procedure	set_last_virtual_page_of_pagina_logica(i_last : ph_page_type);
//function		numero_pagine_logiche_non_stampate(i_before_page : logical_page_type) : logical_page_type;
function		get_pagina_logica_of_pagina_fisica_1B(i_pagina_fisica : ph_page_type) : logical_page_type;

function		get_total_record_number(i_logical_page : logical_page_type = 0) : integer;
procedure	set_total_record_number(lo_number : integer;i_logical_page : logical_page_type = 0);

function		get_virtual_printing_page : ph_page_type;
function		get_last_virtual_printed_page : ph_page_type;
procedure	set_virtual_printing_page(i : ph_page_type);

function		page_msg(i_logical_page : logical_page_type;str_msg : string) : string;
{$endif CASA}

function		page_caption(i_logical_page_1B : logical_page_type;bo_descrizione_breve : boolean) : string;

var
	bo_goto_next_phisical_page : boolean;		// mettere a TRUE per forzare il salto alla next pagina fisica
	i_skip_virtual_pages : ph_page_type;		// assegnare per saltare un certo numero di pagine virtuali

function		get_last_phisical_printed_page : ph_page_type;
function		get_phisical_printing_page : ph_page_type;

function		get_pagina_fisica_of_pagina_virtuale(i_pagina_virtuale : ph_page_type) : ph_page_type;
function		i_virtual_pages_per_phpage : ph_page_type;	// numero di pagine virtuali per ogni pagina fisica

//function		str_mbox_caption : string;
//function		mbox_caption : LPSTR;	// così' fino al 2008-06-15
function		mbox_caption : string;

function		get_active_job : smallint;
function		set_active_job(i_job : smallint) : smallint;
function		get_father_of_job(i_job : smallint = 0) : TForm;

function		get_numero_etichette_const : integer;
function		get_numero_etichette_object : string;
procedure	set_numero_etichette(i_numero : integer;str_object : string);

procedure	set_job_datetime(i_job : smallint = 0;dt : TDatetime = 0);
function		get_job_datetime(i_job : smallint = 0) : TDatetime;

procedure	set_last_job_error(str_error : string);

//function __tag2index(lo_tag : integer;bo_only_active_logical_page : boolean = TRUE) : obj_index_type;
function tag2object(lo_tag : integer;bo_only_active_logical_page : boolean = TRUE) : objs_type;
//function obj2index(obj : objs_type) : obj_index_type;

function set_active_profile(str_profilo : string;i_pagina : logical_page_type = 0;bo_set_from_calling_program : boolean = FALSE) : cl_print_profile;
function get_active_profile(i_pagina : logical_page_type = 0) : cl_print_profile;
function get_profile(str_nome : string;i_pagina : logical_page_type = 0) : cl_print_profile;
function read_profiles(i_pagina : logical_page_type;var f : text) : boolean;
{$ifdef GALATEO_EXE}
	function new_profile(str_nome : string;i_pagina : logical_page_type = 0;modello : cl_print_profile = NIL) : cl_print_profile;
	procedure delete_profile(str_profilo : string;i_pagina : logical_page_type = 0);
	procedure load_profili_itemlist(it : Tstrings;i_pagina : logical_page_type = 0);
	function write_profiles(i_pagina : logical_page_type;var f : text) : boolean;
{$endif}

{$ifdef CASA}
// trattamento inizio/fine del main record, per regolare il comportamento in stampa di certi campi (OSW_SHOW_SOMR e simili)
procedure set_main_record_starting_on_page(i_pagina_fisica_assoluta : ph_page_type;str_local_filename : string);
procedure set_main_record_ending_on_page(i_pagina_fisica_assoluta : ph_page_type);
//function start_end_main_record_page(i_pagina_fisica_relativa : ph_page_type;bo_start : boolean) : boolean;
function start_end_main_record_page(i_pagina_fisica_relativa : ph_page_type;bo_start : boolean) : boolean;
function get_first_vpage_of_current_main_record(i_pagina_fisica_relativa : ph_page_type) : ph_page_type;
function get_last_vpage_of_current_main_record(i_pagina_fisica_relativa : ph_page_type) : ph_page_type;
function get_main_record_index(i_pagina_fisica_assoluta : ph_page_type) : integer; overload;
function get_main_record_index(i_pagina_logica_1B : logical_page_type;i_pagina_fisica_relativa : ph_page_type) : integer; overload;
function get_page_main_record_filename(i_pagina_fisica_assoluta : ph_page_type) : string;
{$endif CASA}

procedure runtime_debug(str_text, str_caption : string;i_livello_importanza : byte);
function is_debug_attivo(i_livello_importanza : byte) : boolean;		// rende TRUE se è attivo il debugging per il livello specificato

const
	// distinzione di importanza tra i messaggi di debug; al momento non è implementata, e non mi sembra neppure così utile
	RD_DEBUG_PRINCIPALE_00 = 0;		// msg principali
//	RD_DEBUG_ACCESSORIO_01 = 1;		// msg secondari
	RD_DEBUG_ACCESSORIO_01 = 0;		// msg secondari
//	RD_DEBUG_DETTAGLIO_02 = 2;			// msg di estremo dettaglio
	RD_DEBUG_DETTAGLIO_02 = 0;			// msg di estremo dettaglio

{$ifdef DLL}
	procedure	assign_globale(i_job : smallint;globale : TGlobale);
	function		globale : TGlobale;	// rende il lavoro attivo
	function		get_globale(i_job : smallint) : TGlobale;	// rende il lavoro i-esimo
	function		alloca_job(father : TForm) : smallint;
	procedure	free_job(i_job : smallint);
	procedure	set_mbox_caption(str_caption : string);
	function		get_last_job_error : string;
{$else}
var
	globale : TGlobale;
{$endif}

implementation

uses FAssert, FDebug, FErrMsg, FXStrings, FStrings, FSystem_base, FSystem, FProcs, FMessage,
	domanda_multipla, proc, intervallo,
	{$ifdef GALATEO_EXE} galateo_main, {$endif}
	{$ifdef CASA} print_types, {$endif}
	galateo_debug, misure, expint_base;

type
	start_end_record = array of ph_page_type;

	cl_logical_page = class
		private
//			function get_size_X_cm : misura_real_type;
//			procedure set_size_X_cm(r : misura_real_type);
			function get_page_size_Y_cm : misura_real_type;
			procedure set_page_size_Y_cm(r : misura_real_type);

			function get_marg_sx_cm : misura_real_type;
			procedure set_marg_sx_cm(r : misura_real_type);
			function get_marg_up_cm : misura_real_type;
			procedure set_marg_up_cm(r : misura_real_type);
			{$ifdef GALATEO_EXE} procedure update_logical_page_number(i_old_page_1B, i_new_page_1B : logical_page_type); {$endif}
		private
			profiles : cl_print_profile;				// elenco dei profili disponibili
			selected_profile : cl_print_profile;	// profilo selezionato
			bo_orizzontale : boolean;
			r_size_X_cm_ph : misura_real_type;
			r_label_width_cm, r_label_height_cm : misura_real_type;
			bo_draw_lines_separazione_label : boolean;	// disegna (solo a video!) le linee di separazione delle etichette
//			r_size_Y_cm_ph : misura_real_type;	viene utilizzata l'altezza della sezione, ed è comune a tutti i profili
			// numeri di pagina su cui iniziano/finiscono i records della main-section; la pagina è relativa alla pagina logica ed è 1-based
			vti_start_main_record_on_page, vti_end_main_record_on_page : start_end_record;
			str_local_filenames : array of string; // filename determinato dal record in caso di salvataggio delle singola pagina fisica/logica (PDFH_SAVE_SINGLE_RECORD, PDFH_SAVE_LOGICAL_PAGE)
		public
//			property r_labsize_X_cm : misura_real_type read r_size_X_cm_ph write r_size_X_cm_ph;	commentato il 2004-06-04
			property r_page_size_Y_cm : misura_real_type read get_page_size_Y_cm write set_page_size_Y_cm;
			property r_marg_sx_cm : misura_real_type read get_marg_sx_cm write set_marg_sx_cm;
			property r_marg_up_cm : misura_real_type read get_marg_up_cm write set_marg_up_cm;
		public
			i_objs : obj_index_type;									// numero di oggetti allocati
			i_sections : section_index_type;						// numero totale di sezioni; 0 se label, 1 se solo detail, n+1 per n group by
			i_section_attiva : section_index_type;				// sezione attiva
			i_last_pagina_virtuale_stampata : ph_page_type;
			lo_total_record_number : integer;	// numero totale di records della sezione indicata dal flag BO_CONTA_RECORDS
			sections : array[MAIN_SECTION..MAX_SECTIONS] of cl_sezione;
			objs : array[1..MAX_OBJS] of objs_type;
			i_numero_stampe_etichetta : smallint;			// alternativo a STR_OBJECT_NUMERO_STAMPE_ETICHETTA
			str_object_numero_stampe_etichetta : string;	// alternativo a I_NUMERO_STAMPE_ETICHETTA
{$ifdef GALATEO_EXE}
			panels : array[MAIN_SECTION..MAX_SECTIONS] of TGalPanel;
			i_num_objs_selected : obj_index_type;				// numero di oggetti selezionati
//				i_objs_selected : array[1..MAX_OBJS] of boolean;	// TRUE per ogni oggetto selezionato
			str_selected_objs : string;	// introdotta 2015-08-08, prima c'era I_OBJS_SELECTED che era meno naturale e soprattutto non manteneva l'ORDINE in cui gli oggetti erano stati selezionati
{$endif}
			constructor create;
			destructor free;
			procedure set_default_values_page;
			procedure reset_print_values;
			function pagina_stampata : boolean;		// TRUE se la pagina è stata stampata, FALSE se esclusa dalla stampa
	end;
	page_array = array[1..MAX_PAGINE_LOGICHE] of cl_logical_page;
	{$M+}
	cl_job = class
		public
			constructor create(father : TForm);
			destructor free;
		private
			pages : page_array;	// deposito delle logical pages (1-based)
			function get_last_error : string;
			procedure set_last_error(str : string);
			function get_caption : string;
			procedure set_caption(str : string);
			function get_pagina_logica_attiva_ZB : logical_page_type;
			procedure set_pagina_logica_attiva_ZB(i : logical_page_type);
			function get_pagina_logica_attiva_1B : logical_page_type;
			procedure set_pagina_logica_attiva_1B(i : logical_page_type);
			function get_globale : TGlobale;
			procedure set_globale(g : TGlobale);
		private
			i_ph_pagina_logica_attiva : logical_page_type;
			i_virtual_printing_page : ph_page_type;				// numero di pagina virtuale in stampa
			i_last_virtual_printed_page : ph_page_type;		// numero tot di pagine virtuali stampate
			str_ph_last_error : string;
			str_ph_caption : string;
			ph_xglobal : TGlobale;
			text_only_print_buffer : array[1..MAX_LINES_PER_PRINT_PAGE] of string;
			dt_time : TDatetime;
		public
			father : TForm;
			bo_text_only_open_page : boolean;
			print_file : textfile;
		published
			property i_pagina_logica_attiva_ZB : logical_page_type read get_pagina_logica_attiva_ZB write set_pagina_logica_attiva_ZB;
			property i_pagina_logica_attiva_1B : logical_page_type read get_pagina_logica_attiva_1B write set_pagina_logica_attiva_1B;
			property str_last_error : string read get_last_error write set_last_error;
			property str_caption : string read get_caption write set_caption;
			property xglobal : TGlobale read get_globale write set_globale;
			property datetime : TDatetime read dt_time;
	end;
	{$M-}
var
	jobs : array[1..MAX_JOBS] of cl_job;
	i_active_job : smallint;	// indice del job attualmente attivo; per GALATEO.EXE sempre = 1, per la DLL può variare
	{$ifdef DEBUG} i_jobs, i_logical_pages, i_profiles : smallint; {$endif}

//function page : page_array; forward;
function job : cl_job; forward;

// ---------------- SECTIONS PROCEDURES -----------------

function sections_1B(i_section_1B : section_index_type;i_page_1B : logical_page_type = 0) : cl_sezione;
begin
	{$ifdef DEBUG} check_index(i_section_1B, 'SECTIONS', 1, MAX_SECTIONS); {$endif}
	var j := job;
	if (i_page_1B = 0) then i_page_1B := j.i_pagina_logica_attiva_1B;
	result := j.pages[i_page_1B].sections[i_section_1B]
end;

function sections_ZB(i_section_ZB : section_index_type;i_page_ZB : logical_page_type = -1) : cl_sezione;
begin
	{$ifdef DEBUG} check_index(i_section_ZB + 1, 'SECTIONS', 1, MAX_SECTIONS); {$endif}
	var j := job;
	if (i_page_ZB = -1) then i_page_ZB := j.i_pagina_logica_attiva_ZB;
	result := j.pages[i_page_ZB + 1].sections[i_section_ZB + 1]
end;

procedure xassign_section(i_section : section_index_type;section : cl_sezione);
// assegna alla section i-esima della pagina attiva il valore specificato
begin
	{$ifdef DEBUG} check_index(i_section, 'ASSIGN SECTION', 1, MAX_SECTIONS); {$endif}
	job.pages[job.i_pagina_logica_attiva_1B].sections[i_section] := section
end;

procedure assign_section_ZB(i_section_ZB : section_index_type;section : cl_sezione);
// assegna alla section i-esima della pagina attiva il valore specificato
begin
	{$ifdef DEBUG} check_index(i_section_ZB, 'ASSIGN SECTION ZB', 0, MAX_SECTIONS - 1); {$endif}
	job.pages[job.i_pagina_logica_attiva_1B].sections[i_section_ZB + 1] := section
end;

function get_num_sections : section_index_type;
begin
	result := job.pages[job.i_pagina_logica_attiva_1B].i_sections
end;

function get_num_sections_page(i_page_1B : logical_page_type) : section_index_type;
// NON fare una unica funzione con la GET_NUM_SECTIONS!!!
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'GET_NUM SECTIONS_PAGE', 1, globale.i_pagine_logiche); {$endif}
	result := job.pages[i_page_1B].i_sections
end;

function get_num_sections_page_ZB(i_page_ZB : logical_page_type) : section_index_type;
// NON fare una unica funzione con la GET_NUM_SECTIONS!!!
begin
	{$ifdef DEBUG} check_index(i_page_ZB, 'GET_NUM SECTIONS_PAGE_ZB', 0, globale.i_pagine_logiche-1); {$endif}
	result := job.pages[i_page_ZB + 1].i_sections
end;

function set_num_sections(i_num : section_index_type) : section_index_type;
begin
	{$ifdef DEBUG} check_index(i_num, 'SET SECTIONS NUM', 0, MAX_SECTIONS); {$endif}
	job.pages[job.i_pagina_logica_attiva_1B].i_sections := i_num;
	result := i_num
end;

function get_section_attiva_1B : section_index_type; begin result := job.pages[job.i_pagina_logica_attiva_1B].i_section_attiva end;
function get_section_attiva_ZB : section_index_type; begin result := job.pages[job.i_pagina_logica_attiva_1B].i_section_attiva - 1 end;

function set_section_attiva_1B(i_section_1B : section_index_type) : section_index_type;
begin
	{$ifdef DEBUG} check_index(i_section_1B, 'SET SECTION ATTIVA 1B', 1, MAX_SECTIONS); {$endif}
	job.pages[job.i_pagina_logica_attiva_1B].i_section_attiva := i_section_1B;
	result := i_section_1B
end;

function set_section_attiva_ZB(i_section_ZB : section_index_type) : section_index_type;
begin
	{$ifdef DEBUG} check_index(i_section_ZB, 'SET SECTION ATTIVA ZB', 0, MAX_SECTIONS-1); {$endif}
	job.pages[job.i_pagina_logica_attiva_1B].i_section_attiva := i_section_ZB + 1;
	result := i_section_ZB
end;

// --------- PANELS PROCEDURES -------------------------------------------------

{$ifdef GALATEO_EXE}
	function panels_1B(i : smallint) : TGalPanel;
	begin
		{$ifdef DEBUG} check_index(i, 'PANELS', 1, MAX_SECTIONS); {$endif}
		result := job.pages[job.i_pagina_logica_attiva_1B].panels[i]
	end;

	function panels_ZB(i_ZB : smallint) : TGalPanel;
	begin
		{$ifdef DEBUG} check_index(i_ZB, 'ZB-PANELS', 0, MAX_SECTIONS-1); {$endif}
		result := job.pages[job.i_pagina_logica_attiva_1B].panels[i_ZB + 1]
	end;

	procedure assign_panel_1B(i_1B : smallint;panel : Tgalpanel);
	// assegna al panel i-esimo della pagina attiva il valore specificato
	begin
		{$ifdef DEBUG} check_index(i_1B, 'ASSIGN PANEL 1B', 1, MAX_SECTIONS); {$endif}
		job.pages[job.i_pagina_logica_attiva_1B].panels[i_1B] := panel
	end;

	procedure assign_panel_ZB(i_ZB : smallint;panel : Tgalpanel);
	// assegna al panel i-esimo della pagina attiva il valore specificato
	begin
		{$ifdef DEBUG} check_index(i_ZB,'ASSIGN PANEL ZB', 0, MAX_SECTIONS - 1); {$endif}
		job.pages[job.i_pagina_logica_attiva_1B].panels[i_ZB + 1] := panel
	end;

{$endif}

// ------------------- OBJS PROCEDURES -----------------------------------------

function xobjs(i_obj_1B : obj_index_type;i_page_1B : logical_page_type = 0) : objs_type;
begin
	if (i_page_1B = 0) then i_page_1B := job.i_pagina_logica_attiva_1B;
	{$ifdef DEBUG} check_index(i_obj_1B, 'OBJS(i)', 1, MAX_OBJS); {$endif}
	{$ifdef DEBUG} check_index(i_page_1B, 'OBJS(pagina)', 1, globale.i_pagine_logiche); {$endif}
	result := job.pages[i_page_1B].objs[i_obj_1B];
	{$ifdef DEBUG} if (result <> NIL) AND (result.i_numero_obj <> i_obj_1B) then assert(FALSE, 'result.i_numero_obj <> i_obj -- XIUW 8341') {$endif}
end;

function xobjs_ZB(i_obj_ZB : obj_index_type;i_page_ZB : logical_page_type = -1) : objs_type;
begin
	if (i_page_ZB = 0) then i_page_ZB := job.i_pagina_logica_attiva_ZB;
	{$ifdef DEBUG} check_index(i_obj_ZB, 'OBJS(i)', 0, MAX_OBJS-1); {$endif}
	{$ifdef DEBUG} check_index(i_page_ZB, 'OBJS_ZB(pagina)', 0, globale.i_pagine_logiche - 1); {$endif}
	result := job.pages[i_page_ZB + 1].objs[i_obj_ZB + 1];
	{$ifdef DEBUG} if (result <> NIL) AND (result.i_numero_obj <> i_obj_ZB + 1) then assert(FALSE, 'result.i_numero_obj <> i_obj_ZB -- XIUW 8342') {$endif}
end;

procedure assign_obj(i : obj_index_type;obj : objs_type);
// assegna il valore specificato all'oggetto i-esimo della pagina attiva
begin
	{$ifdef DEBUG} check_index(i,'ASSIGN OBJ',1,MAX_OBJS); {$endif}
	job.pages[job.i_pagina_logica_attiva_1B].objs[i] := obj;
	if (obj <> NIL) then obj.set_obj_number(i)	// 2006-01-18
end;

{$ifdef GALATEO_EXE}

	procedure set_selected_obj(i_obj : obj_index_type;bo_selected : boolean;bo_beep : boolean = FALSE;bo_update_info : boolean = FALSE);
	// seleziona l'oggetto I_OBJ; passare 0 per selezionare tutti gli oggetti della pagina
	begin
		{$ifdef DEBUG} check_index(i_obj, 'SET SELECTED OBJ', 0, MAX_OBJS); {$endif}
{		with job.pages[job.i_pagina_logica_attiva_1B] do begin
			if (i_objs = 0) then begin
				fillchar(i_objs_selected, sizeof(i_objs_selected), bo_selected);
				if bo_selected then i_num_objs_selected := i_objs else i_num_objs_selected := 0;
			end
			else begin
				if (i_objs_selected[i_obj] <> bo_selected) then begin
					inc(i_num_objs_selected, piumeno(bo_selected));
					i_objs_selected[i_obj] := bo_selected
				end
			end
		end; }

		with job.pages[job.i_pagina_logica_attiva_1B] do begin
			if (i_objs = 0) then begin		// seleziono/deseleziono tutto
				str_selected_objs := '';
				if bo_selected then begin
					for i_obj := 1 to i_objs do add_delimited(str_selected_objs, i_obj);
					i_num_objs_selected := i_objs
				end
				else i_num_objs_selected := 0
			end
			else begin
				if (exists_code(str_selected_objs, i_obj) <> bo_selected) then begin
					if bo_selected then add_delimited(str_selected_objs, i_obj) else str_selected_objs := delete_delimited(str_selected_objs, i_obj);
					inc(i_num_objs_selected, piumeno(bo_selected))
				end
			end
		end;

		if bo_beep then beep(0);
		if bo_update_info then GM.update_info_selection
	end;

	function get_selected_obj(i_pos : obj_index_type = 0) : objs_type;
	// parametri come per la GET_SELECTED_OBJ_INDEX
	begin
		var i_obj : obj_index_type := get_selected_obj_index(i_pos);
		if (i_obj = 0) then result := NIL else result := xobjs(i_obj)
	end;

	function get_selected_obj_index(i_pos : obj_index_type = 0) : obj_index_type;
	{ rende l' i-esimo oggetto selezionato;
	  se I_POS = 0 rende l'unico oggetto selezionato (se esiste);
	  se nessun oggetto è selezionato, o se l'indice è fuori scala, la funzione rende 0 }
	begin
		if (i_pos = 0) then i_pos := 1;
		var s := get_word(job.pages[job.i_pagina_logica_attiva_1B].str_selected_objs, i_pos-1, [',']);		// get_word() è 0-based
		if (s = '') then result := 0 else result := strtoint(s)
	end;

	function is_selected(i_obj : obj_index_type) : boolean;
	begin
		{$ifdef DEBUG} check_index(i_obj,'IS_SELECTED',1,i_objs); {$endif}
//		result := job.pages[job.i_pagina_logica_attiva_1B].i_objs_selected[i_obj]
		result := exists_code(job.pages[job.i_pagina_logica_attiva_1B].str_selected_objs, i_obj)
	end;

	function get_num_selected_objects : obj_index_type;
	begin
		result := job.pages[job.i_pagina_logica_attiva_1B].i_num_objs_selected
//		result := numero_elementi_lista(job.pages[job.i_pagina_logica_attiva_1B].str_selected_objs)
	end;

{$endif GALATEO_EXE}

function i_objs(i_page_1B : logical_page_type = 0) : obj_index_type;	// rende il numero di oggetto allocati per la pagina
begin
	if (i_page_1B = 0) then i_page_1B := job.i_pagina_logica_attiva_1B;
//	{$ifdef DEBUG} else check_index(i_page_1B,'I_OBJS',1,globale.i_pagine) {$endif};	// check solo se la pagina è specificata, altrimenti comunque OK
	result := job.pages[i_page_1B].i_objs
end;

function i_objs_ZB(i_page_ZB : logical_page_type = -1) : obj_index_type;		// rende il numero di oggetto allocati per la pagina
begin
	if (i_page_ZB = -1) then i_page_ZB := job.i_pagina_logica_attiva_ZB;
//	{$ifdef DEBUG} else check_index(i_page,'I_OBJS',1,globale.i_pagine) {$endif};	// check solo se la pagina è specificata, altrimenti comunque OK
	result := job.pages[i_page_ZB + 1].i_objs
end;

procedure set_num_objs(i_objs : obj_index_type;i_page_1B : logical_page_type = 0);
// imposta il numero di oggetto allocati per la pagina
begin
	if (i_page_1B = 0) then i_page_1B := job.i_pagina_logica_attiva_1B;
	{$ifdef DEBUG} check_index(i_objs, 'SET NUMERO OBJ', 0, MAX_OBJS); {$endif}
	job.pages[i_page_1B].i_objs := i_objs
end;

// --------- PAGE procedures ---------------------------------------------------

function get_pagina_logica_attiva_1B : logical_page_type; begin result := job.i_pagina_logica_attiva_1B end;
function get_pagina_logica_attiva_ZB : logical_page_type; begin result := job.i_pagina_logica_attiva_ZB end;
function get_ultima_pagina_logica : logical_page_type; begin result := globale.i_pagine_logiche end;

{$ifdef GALATEO_EXE}
	procedure setup_pagina_logica(i_pagina_logica_1B : logical_page_type);
	// imposta gli elementi di fondo della pagina logica; al momento da' semplicemente una mano di colore
	begin
		var xp : cl_logical_page_info := get_logical_page_1B(i_pagina_logica_1B);
		var bo_external := xp.bo_external;
		if (GM <> NIL) then begin
			if xp.bo_external then GM.sbox.Color := COLORE_EXTERNAL_PAGES
			else GM.sbox.Color := xp.i_colore_base
		end;

		var bo_hide := xp.bo_dont_print;var lo_color : TColor := clWindow;
		for var i : section_index_type := 1 to get_num_sections do with panels_1B(i) do begin
			bo_hide := bo_hide OR sections_1B(i, i_pagina_logica_1B).bo_dont_print_section;
			if bo_hide then lo_color := COLORE_HIDDEN_PAGES;
			color := lo_color;
			Enabled := NOT bo_external
		end
	end;
{$endif}

function set_pagina_logica_attiva_1B(i_pagina_logica_1B : logical_page_type;bo_update_video : boolean;bo_forza_esecuzione : boolean = FALSE) : logical_page_type;
// attiva la pagina specificata; rende l'indice della pagina precedentemente attiva

{$ifdef GALATEO_EXE}
	procedure attiva(bo_attiva : boolean);
	begin for var i : section_index_type := 1 to get_num_sections do panels_1B(i).Visible := bo_attiva end;
{$endif}

begin
	result := job.i_pagina_logica_attiva_1B;
	if (i_pagina_logica_1B = smallint(job.i_pagina_logica_attiva_1B)) AND NOT bo_forza_esecuzione then exit;	// nulla da fare
	{$ifdef DEBUG} check_index(i_pagina_logica_1B, 'SET pagina attiva', 1, MAX_PAGINE_LOGICHE); {$endif}
{$ifdef GALATEO_EXE}
	if (job.i_pagina_logica_attiva_1B <> 0) then begin
//		{$ifdef GALATEO_EXE} obj_select(0, FALSE, FALSE); {$endif}			***** commentato 2015-08-08; in questo modo si consente di mantenere la selezione al cambio pagina
		{$ifdef GALATEO_EXE} attiva(FALSE) {$endif}
	end;
{$endif NOT DLL}
	job.i_pagina_logica_attiva_1B := i_pagina_logica_1B;
	if (job.i_pagina_logica_attiva_1B <> 0) then begin
		{$ifdef GALATEO_EXE} attiva(TRUE); {$endif}
		set_section_attiva_ZB(MAIN_SECTION_ZB);
		{$ifdef GALATEO_EXE} if bo_update_video then GM.set_disegno_values {$endif}
	end;
	{$ifdef GALATEO_EXE} if bo_update_video then setup_pagina_logica(i_pagina_logica_1B) {$endif}
end;

function set_pagina_logica_attiva_ZB(i_pagina_logica : logical_page_type;bo_update_video : boolean;bo_forza_esecuzione : boolean = FALSE) : logical_page_type;
begin result := set_pagina_logica_attiva_1B(i_pagina_logica + 1, bo_update_video, bo_forza_esecuzione) - 1 end;

procedure reset_logical_page_print_values(i_pagina_logica : logical_page_type);
begin
	job.pages[i_pagina_logica].reset_print_values
end;

function	orizzontale_1B(i_page_1B : logical_page_type) : boolean;
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.orizzontale()', 1, MAX_PAGINE_LOGICHE); {$endif}
	result := job.pages[i_page_1B].bo_orizzontale
end;

function	orizzontale_ZB(i_page_ZB : logical_page_type) : boolean;
begin
	{$ifdef DEBUG} check_index(i_page_ZB, 'pages.orizzontale_ZB()', 0, MAX_PAGINE_LOGICHE-1); {$endif}
	result := job.pages[i_page_ZB + 1].bo_orizzontale
end;

procedure assign_orizzontale_1B(i_page_1B : logical_page_type;bo_orizzontale : boolean);
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.orizzontale()', 1, MAX_PAGINE_LOGICHE); {$endif}
	job.pages[i_page_1B].bo_orizzontale := bo_orizzontale
end;

procedure assign_orizzontale_ZB(i_page_ZB : logical_page_type;bo_orizzontale : boolean);
begin
	{$ifdef DEBUG} check_index(i_page_ZB, 'pages.orizzontale_ZB()', 0, MAX_PAGINE_LOGICHE-1); {$endif}
	job.pages[i_page_ZB + 1].bo_orizzontale := bo_orizzontale
end;

function cl_logical_page.get_page_size_Y_cm : misura_real_type;
begin
	if (sections[1] = NIL) then result := 0
	else result := sections[1].r_y_sezione_cm
end;

procedure cl_logical_page.set_page_size_Y_cm(r : misura_real_type);
begin
	if (sections[MAIN_SECTION] <> NIL) then begin
		sections[MAIN_SECTION].r_y_sezione_cm := r;
		sections[MAIN_SECTION].r_y_gruppo_cm := r		// aggiunto 2004-07-11; si parla del GRUPPO, non della dimensione della pagina
	end
end;

function cl_logical_page.get_marg_sx_cm;
begin
	result := selected_profile.r_marg_sx_cm_ph
end;

procedure cl_logical_page.set_marg_sx_cm(r : misura_real_type);
begin
	selected_profile.r_marg_sx_cm_ph := r
end;

function cl_logical_page.get_marg_up_cm;
begin
	result := selected_profile.r_marg_up_cm_ph
end;

procedure cl_logical_page.set_marg_up_cm(r : misura_real_type);
begin
	selected_profile.r_marg_up_cm_ph := r
end;

{$ifdef GALATEO_EXE}
	procedure cl_logical_page.update_logical_page_number(i_old_page_1B, i_new_page_1B : logical_page_type);
	{ il numero di pagina dell'oggetto page è stato cambiato (nuova pagina logica, oppure eliminazione di pagina logica);
	  questa procedure esegue le operazioni necessarie per gestire l'evento }
	begin
	//	for i := 1 to i_objs do objs[i].update_logical_page_number(i_new_page);
//		for var i : section_index_type := 1 to i_sections do sections[i].i_logical_page_1B := i_new_page_1B
		for var i : section_index_type := 1 to i_sections do sections[i].i_logical_page_ZB := i_new_page_1B - 1
	end;
{$endif}

function i_PHpage_size_X_pix_video(i_page_1B : logical_page_type) : int_pixel_type;
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.i_page_size_X_pix_video()', 1, MAX_PAGINE_LOGICHE); {$endif}
	result := cm2pixel_video_x(job.pages[i_page_1B].r_size_X_cm_ph)
end;

function i_PHpage_size_X_pix_print(i_page_1B : logical_page_type) : int_pixel_type;
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.ai_page_size_X_pix_print()', 1, MAX_PAGINE_LOGICHE); {$endif}
	result := cm2pixel_print_x(job.pages[i_page_1B].r_size_X_cm_ph)
end;

function i_PHpage_size_Y_pix_video(i_page_1B : logical_page_type) : int_pixel_type;
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.i_page_size_Y_pix_video()', 1, MAX_PAGINE_LOGICHE); {$endif}
	result := cm2pixel_video_y(job.pages[i_page_1B].r_page_size_Y_cm)
end;

function i_PHpage_size_Y_pix_print(i_page_1B : logical_page_type) : int_pixel_type;
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.i_page_size_Y_pix_print()', 1, MAX_PAGINE_LOGICHE); {$endif}
	result := cm2pixel_print_y(job.pages[i_page_1B].r_page_size_Y_cm)
end;

function get_printer_page(i_page_1B : logical_page_type) : string;
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.get_printer_page()', 1, MAX_PAGINE_LOGICHE); {$endif}
	result := job.pages[i_page_1B].selected_profile.str_printer
end;

procedure set_printer_page(str_printer : string;i_page_1B : logical_page_type);
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.set_printer_page()', 1, MAX_PAGINE_LOGICHE); {$endif}
	job.pages[i_page_1B].selected_profile.str_printer := uppercase(str_printer)
end;

function get_cassetto_carta_page(i_page_1B : logical_page_type) : string;
begin
	{$ifdef DEBUG} check_index(i_page_1B,'pages.get_cassetto_carta_page()',1,MAX_PAGINE_LOGICHE); {$endif}
	result := job.pages[i_page_1B].selected_profile.str_cassetto_carta
end;

procedure set_cassetto_carta_page(str_cassetto_carta : string;i_page_1B : logical_page_type);
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.set_cassetto_carta_page()', 1, MAX_PAGINE_LOGICHE); {$endif}
	job.pages[i_page_1B].selected_profile.str_cassetto_carta := str_cassetto_carta
end;

function get_workstation_page(i_page_1B : logical_page_type) : string;
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.get_workstation_page()', 1, MAX_PAGINE_LOGICHE); {$endif}
	result := job.pages[i_page_1B].selected_profile.str_attiva_on_workstation
end;

procedure set_workstation_page(str_workstation : string;i_page_1B : logical_page_type);
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.set_workstation_page()', 1, MAX_PAGINE_LOGICHE); {$endif}
	job.pages[i_page_1B].selected_profile.str_attiva_on_workstation := str_workstation
end;

function get_IP_page(i_page_1B : logical_page_type) : string;
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.get_IP_page()', 1, MAX_PAGINE_LOGICHE); {$endif}
	result := job.pages[i_page_1B].selected_profile.str_attiva_on_IP
end;

procedure set_IP_page(str_IP : string;i_page_1B : logical_page_type);
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.set_IP_page()', 1, MAX_PAGINE_LOGICHE); {$endif}
	job.pages[i_page_1B].selected_profile.str_attiva_on_IP := str_IP
end;

function get_username_page(i_page_1B : logical_page_type) : string;
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.get_username_page()', 1, MAX_PAGINE_LOGICHE); {$endif}
	result := job.pages[i_page_1B].selected_profile.str_attiva_on_windows_username
end;

procedure set_username_page(str_username : string;i_page_1B : logical_page_type);
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.set_username_page()', 1, MAX_PAGINE_LOGICHE); {$endif}
	job.pages[i_page_1B].selected_profile.str_attiva_on_windows_username := str_username
end;

(*function xget_flag_printer_pagina_logica(i_page_1B : logical_page_type) : xFGPPL_type;
begin
	{$ifdef DEBUG} check_index(i_page, 'pages.get_flag_printer_pagina_logica()', 1, MAX_PAGINE_LOGICHE); {$endif}
	result := job.pages[i_page].selected_profile.xfgppl
end;

procedure xset_flag_printer_pagina_logica(fgppl : xFGPPL_type;i_page_1B : logical_page_type);
begin
	{$ifdef DEBUG} check_index(i_page, 'pages.set_flag_printer_pagina_logica()', 1, MAX_PAGINE_LOGICHE); {$endif}
	job.pages[i_page].selected_profile.xfgppl := fgppl
end;*)

function get_PHpage_size_X_cm_1B(i_page_1B : logical_page_type = 0) : misura_real_type;
// dimensione X della pagina (o dell'etichetta); I_PAGE = 0 per intendere la pagina attiva
begin
//	{$ifdef DEBUG} check_index(i_page_1B,'pages.get_page_size_X_cm()',1,MAX_PAGINE_LOGICHE); {$endif}
	if (i_page_1B = 0) then i_page_1B := get_pagina_logica_attiva_1B;
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.get_page_size_X_cm()',1,MAX_PAGINE_LOGICHE); {$endif}
	result := job.pages[i_page_1B].r_size_X_cm_ph
end;

function get_PHpage_size_X_cm_ZB(i_page_ZB : logical_page_type = -1) : misura_real_type;
// dimensione X della pagina (o dell'etichetta); I_PAGE = 0 per intendere la pagina attiva
begin
	if (i_page_ZB = -1) then i_page_ZB := get_pagina_logica_attiva_ZB;
	{$ifdef DEBUG} check_index(i_page_ZB, 'pages.get_page_size_X_cm_ZB()', 0, MAX_PAGINE_LOGICHE - 1); {$endif}
	result := job.pages[i_page_ZB + 1].r_size_X_cm_ph
end;

procedure set_PHpage_size_X_cm_1B(i_page_1B : logical_page_type;r_value : misura_real_type);
// dimensione X della pagina (o dell'etichetta)
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.set_page_size_X_cm_1B()', 1, MAX_PAGINE_LOGICHE); {$endif}
	job.pages[i_page_1B].r_size_X_cm_ph := r_value
end;

procedure set_PHpage_size_X_cm_ZB(i_page_ZB : logical_page_type;r_value : misura_real_type);
// dimensione X della pagina (o dell'etichetta)
begin
	{$ifdef DEBUG} check_index(i_page_ZB, 'pages.set_page_size_X_cm_ZB()', 0, MAX_PAGINE_LOGICHE-1); {$endif}
	job.pages[i_page_ZB + 1].r_size_X_cm_ph := r_value
end;

function get_PHpage_size_Y_cm_1B(i_page_1B : logical_page_type = 1) : misura_real_type;
// dimensione Y della pagina (o dell'etichetta)
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.get_page_size_Y_cm_1B()', 1, MAX_PAGINE_LOGICHE); {$endif}
	result := job.pages[i_page_1B].r_page_size_Y_cm
end;

function get_PHpage_size_Y_cm_ZB(i_page_ZB : logical_page_type = 0) : misura_real_type;
// dimensione Y della pagina (o dell'etichetta)
begin
	{$ifdef DEBUG} check_index(i_page_ZB, 'pages.get_page_size_Y_cm_ZB()', 0, MAX_PAGINE_LOGICHE-1); {$endif}
	result := job.pages[i_page_ZB + 1].r_page_size_Y_cm
end;

procedure set_PHpage_size_Y_cm_1B(i_page_1B : logical_page_type;r_value : misura_real_type);
// dimensione Y della pagina (o dell'etichetta)
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.set_page_size_Y_cm_1B()', 1, MAX_PAGINE_LOGICHE); {$endif}
	job.pages[i_page_1B].r_page_size_Y_cm := r_value;
//	sections_page(MAIN_SECTION,i_page_1B).r_y_gruppo_cm := r_value	// aggiunto 2004-07-11; si parla del GRUPPO, non della dimensione della pagina
end;

procedure set_PHpage_size_Y_cm_ZB(i_page_ZB : logical_page_type;r_value : misura_real_type);
// dimensione Y della pagina (o dell'etichetta)
begin
	{$ifdef DEBUG} check_index(i_page_ZB, 'pages.set_page_size_Y_cm_ZB()', 0, MAX_PAGINE_LOGICHE-1); {$endif}
	job.pages[i_page_ZB + 1].r_page_size_Y_cm := r_value
end;

// -------------------------------------------------------------------------------------------------------------------------------------------------------------

function get_page_marg_SX_cm_1B(i_page_1B : logical_page_type = 1) : misura_real_type;
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.get_page_marg_SX_cm_1B()', 1, MAX_PAGINE_LOGICHE); {$endif}
	result := job.pages[i_page_1B].selected_profile.r_marg_sx_cm_ph
end;

function get_page_marg_SX_cm_ZB(i_page_ZB : logical_page_type = 0) : misura_real_type;
begin
	{$ifdef DEBUG} check_index(i_page_ZB, 'pages.get_page_marg_SX_cm_ZB()', 0, MAX_PAGINE_LOGICHE - 1); {$endif}
	result := job.pages[i_page_ZB + 1].selected_profile.r_marg_sx_cm_ph
end;

procedure set_page_marg_SX_cm_1B(i_page_1B : logical_page_type;r_value : misura_real_type);
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.set_page_marg_SX_cm_1B()', 1, MAX_PAGINE_LOGICHE); {$endif}
	job.pages[i_page_1B].selected_profile.r_marg_sx_cm_ph := r_value
end;

procedure set_page_marg_SX_cm_ZB(i_page_ZB : logical_page_type;r_value : misura_real_type);
begin
	{$ifdef DEBUG} check_index(i_page_ZB, 'pages.set_page_marg_SX_cm_ZB()', 0, MAX_PAGINE_LOGICHE - 1); {$endif}
	job.pages[i_page_ZB + 1].selected_profile.r_marg_sx_cm_ph := r_value
end;

function get_page_marg_UP_cm_1B(i_page_1B : logical_page_type = 1) : misura_real_type;
begin
	if (i_page_1B = 0) then i_page_1B := get_pagina_logica_attiva_1B;
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.get_page_marg_UP_cm_1B()', 1, MAX_PAGINE_LOGICHE); {$endif}
	result := job.pages[i_page_1B].selected_profile.r_marg_up_cm_ph
end;

function get_page_marg_UP_cm_ZB(i_page_ZB : logical_page_type = 0) : misura_real_type;
begin
	if (i_page_ZB = -1) then i_page_ZB := get_pagina_logica_attiva_ZB;
	{$ifdef DEBUG} check_index(i_page_ZB, 'pages.get_page_marg_UP_cm_ZB()', 0, MAX_PAGINE_LOGICHE - 1); {$endif}
	result := job.pages[i_page_ZB + 1].selected_profile.r_marg_up_cm_ph
end;

procedure set_page_marg_UP_cm_1B(i_page_1B : logical_page_type;r_value : misura_real_type);
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.set_page_marg_UP_cm_1B()', 1, MAX_PAGINE_LOGICHE); {$endif}
	job.pages[i_page_1B].selected_profile.r_marg_up_cm_ph := r_value
end;

procedure set_page_marg_UP_cm_ZB(i_page_ZB : logical_page_type;r_value : misura_real_type);
begin
	{$ifdef DEBUG} check_index(i_page_ZB, 'pages.set_page_marg_UP_cm_ZB()', 0, MAX_PAGINE_LOGICHE - 1); {$endif}
	job.pages[i_page_ZB + 1].selected_profile.r_marg_up_cm_ph := r_value
end;

(*function get_page_marg_DOWN_cm(i_page_1B : logical_page_type = 0) : misura_real_type;
begin
	if (i_page = 0) then i_page := get_pagina_logica_attiva;
	{$ifdef DEBUG} check_index(i_page, 'pages.get_page_marg_DOWN_cm()', 1, MAX_PAGINE_LOGICHE); {$endif}
//	result := job.pages[i_page].selected_profile.r_marg_up_cm_ph
	result := job.pages[i_page].selected_profile.r_marg_up_cm_ph
end; *)

procedure cl_logical_page.set_default_values_page;
begin
	r_size_X_cm_ph := DEFAULT_PAGE_WIDTH_CM;r_page_size_Y_cm := DEFAULT_PAGE_HEIGHT_CM;
	r_label_width_cm := DEFAULT_LABEL_WIDTH_CM;r_label_height_cm := DEFAULT_LABEL_HEIGHT_CM;
	selected_profile.r_marg_sx_cm_ph := 1;
	selected_profile.r_marg_up_cm_ph := 1;
	i_numero_stampe_etichetta := 1;str_object_numero_stampe_etichetta := ''
end;

procedure set_default_values(handle : HDC);
const MBOX_DEBUG_CAPTION = 'set_default_values()';
begin
	for var i : logical_page_type := 1 to MAX_PAGINE_LOGICHE do job.pages[i].set_default_values_page;

	if esiste_stampante(FALSE) then begin
		try
			writeln_system_debug(0, MBOX_DEBUG_CAPTION, 'before init_print_values()');
			tm.init_print_values({printer.handle,}'');
			writeln_system_debug(0, MBOX_DEBUG_CAPTION, 'after init_print_values()')
		except
			error_msg('Errore durante la selezione della stampante predefinita', MBOX_CAPTION);
			halt
		end
	end;
	if (handle <> NULL) then tm.init_video_values(handle, 1)
end;

function verify_page_size(i_page_1B : logical_page_type;handle : hwnd;printer : TFPrinter) : boolean;
{ verifica che la pagina fisica riesca a contenere la stampa virtuale;
  rende TRUE se tutto OK, FALSE altrimenti }
const RACCOMANDAZIONI = 'Correggi le caratteristiche dell''etichetta in stampa, '+
	'oppure modifica le caratteristiche della stampante (sul pannello di controllo)';
var {r_temp,} x, y, x_max, y_max : misura_real_type;
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.verify_page_size()', 1, MAX_PAGINE_LOGICHE); {$endif}

	x_max := getdevicecaps(printer.Handle, HORZRES) * 1.01;
	y_max := getdevicecaps(printer.Handle, VERTRES) * 1.01;
//	if (globale.bo_orizzontale) then begin r_temp := x_max;x_max := y_max;y_max := r_temp end;	// scambio
//	shift_orizzontal_sizes(x_max,y_max,globale.xbo_orizzontale);
	shift_orizzontal_sizes(x_max, y_max, get_pagina_logica_attiva_1B);

	// dimensione fisica della pagina di stampa
	var x_cm_size : misura_real_type := getdevicecaps(printer.handle, HORZSIZE) / 10;
	var y_cm_size : misura_real_type := getdevicecaps(printer.handle, VERTSIZE) / 10;
//	if (globale.bo_orizzontale) then begin r_temp := x_cm_size;x_cm_size := y_cm_size;y_cm_size := r_temp end;	// scambio
//	shift_orizzontal_sizes_real(x_cm_size,y_cm_size,globale.xbo_orizzontale);
	shift_orizzontal_sizes(x_cm_size, y_cm_size, get_pagina_logica_attiva_1B);

	with job.pages[i_page_1B] do begin
		if (globale.tiporeport in LABEL_TYPES) then begin
			x := selected_profile.r_marg_sx_cm_ph + (r_label_width_cm + tm.r_delta_labs_X_cm) * tm.i_lab_per_row;
			y := selected_profile.r_marg_up_cm_ph + (r_label_height_cm + tm.r_delta_labs_Y_cm) * tm.i_lab_per_page
		end
		else begin
			x := selected_profile.r_marg_sx_cm_ph + r_size_X_cm_ph;
			y := selected_profile.r_marg_up_cm_ph + r_page_size_Y_cm
		end
	end;

	var s := '';
	if (cm2pixel_print_x(x) > x_max) then	// tolleranza dell'1%
		s := 'La pagina fisica di stampa (larga ' + strid(x_cm_size, 0, 1) +
			' cm) è più stretta della stampa che si vuole eseguire (' + strid(x, 0, 1) + ' cm).' + ACAPO2;
	if (cm2pixel_print_y(y) > y_max) then	// tolleranza dell'1%
		s := s + 'La pagina fisica di stampa (alta ' + strid(y_cm_size, 0, 1)+
			' cm) è più corta della stampa che si vuole eseguire (' + strid(y, 0, 1) + ' cm).' + ACAPO2;

{$ifdef CONSENTI_WRONG_SIZES}
	if (s = '') then result := TRUE
	else begin
		s := s + 'Vuoi proseguire ugualmente?';
		result := MessageBBox(handle, s, MBOX_CAPTION, MB_QUESTION) = IDYES
	end;
{$else}
	if (s <> '') then MessageBBox(handle, s, MBOX_CAPTION, MB_ICONSTOP);
	verify_page_size := (s = '');
{$endif}
	if NOT result then MessageBBox(handle, RACCOMANDAZIONI, MBOX_CAPTION, MB_ICONSTOP)
end;

procedure write_page_measures(i_page_1B : logical_page_type;pbox : TPaintBox;
	x0,y0 : int_pixel_type;tiporeport : REPORT_TYPE;bo_margini : boolean;r_fattore_zoom : real = 1;
	i_width_mm : smallint = 0;i_height_mm : smallint = 0);
{ if BO_MARGINI then nella stampa considera anche i margini, ELSE stampa come se
  i margini non esistessero (e la pagina avesse dimensioni nette pari alla pagina
  fisica MENO i margini);
  se (X0,Y0) = (0,0) i numeri vengono scritti il più vicino possibile al margine sx;
  I_WIDTH_MM e I_HEIGHT_MM sono le dimensioni da stampare; se ZERO, vengono ricavate all'interno della procedure }
var
	s : string;	//*
	i, i_temp, i_x_end, i_y_end, ax0, ay0 : integer;
begin
	{$ifdef DEBUG} check_index(i_page_1B, 'pages.write_page_measures()', 1, MAX_PAGINE_LOGICHE); {$endif}
	with pbox do begin
		if (i_width_mm = 0) OR (i_height_mm = 0) then begin
			var bo_report := (globale.tiporeport = TR_REPORT);
			if bo_report then begin
				if bo_margini then begin
					i_x_end := trunc(getdevicecaps(printer.handle, HORZSIZE) / 10);
					i_y_end := trunc(getdevicecaps(printer.handle, VERTSIZE) / 10);
//					shift_orizzontal_sizes_integer(i_x_end,i_y_end,globale.bo_orizzontale);
					shift_orizzontal_sizes(i_x_end, i_y_end, i_page_1B)
				end
				else begin
					i_x_end := trunc(job.pages[i_page_1B].r_size_X_cm_ph);
					i_y_end := trunc(job.pages[i_page_1B].r_page_size_Y_cm)
				end
			end
			else begin
				i_x_end := trunc(job.pages[i_page_1B].r_size_X_cm_ph);
				i_y_end := trunc(job.pages[i_page_1B].r_page_size_Y_cm)
			end
		end;
		if (i_width_mm <> 0) then i_x_end := i_width_mm div 10;
		if (i_height_mm <> 0) then i_y_end := i_height_mm div 10;

		canvas.font.name := 'arial';canvas.font.style := [fsBold];
//		canvas.font.size := 8;
//		canvas.font.size := round(8 * r_fattore_zoom);
//		canvas.font.size := round(8 * (1 + r_fattore_zoom) / 2);
		var fl_size : double := 8 * r_fattore_zoom;
		if (r_fattore_zoom > 1) then fl_size := min(10, fl_size) else fl_size := max(6, fl_size);
		canvas.font.size := round(fl_size);

//		i_temp := round((y0-canvas.Textheight('0')) * r_fattore_zoom);
		i_temp := round((y0-canvas.Textheight('0')));
		for i := 0 to i_x_end do begin
			if (y0 = 0) and (i = 0) then continue;
			s := inttostr(i);
			if (y0 = 0) then ay0 := 1 else ay0 := i_temp;
			canvas.Textout(round((x0 + cm2pixel_video_x(i) - canvas.Textwidth(s) div 2) * r_fattore_zoom), ay0, s)
		end;
		i_temp := canvas.Textheight('0');
		for i := 1 to i_y_end do begin
			s := inttostr(i);
			if (x0 = 0) then ax0 := 1 else ax0 := round((x0 - 2 - canvas.Textwidth(s)) {* r_fattore_zoom});
			ay0 := round((y0 + cm2pixel_video_y(i)) * r_fattore_zoom);
			canvas.Textout(ax0, ay0 - i_temp, s);

			// disegno una riga orizzontale per segnare la misura esatta
			i_x_end := round((x0-0) {* r_fattore_zoom});
			canvas.MoveTo({i_x_end - 12}0, ay0);canvas.LineTo(i_x_end, ay0)
		end
	end
end;

constructor cl_logical_page.create;
begin
	{$ifdef DEBUG} inc(i_logical_pages); {$endif}
	profiles := cl_print_profile.Create;
	selected_profile := profiles;	// per default assegno il primo profilo
	set_default_values_page
end;

destructor cl_logical_page.free;
var i : smallint;	//*
begin
	{$ifdef DEBUG} dec(i_logical_pages); {$endif}
	while (profiles <> NIL) do begin var p := profiles;profiles := profiles.next;p.free end;
	for i := MAIN_SECTION to MAX_SECTIONS do if (sections[i] <> NIL) then begin sections[i].free;sections[i] := NIL end;
	for i := 1 to MAX_OBJS do if (objs[i] <> NIL) then begin objs[i].free;objs[i] := NIL end
end;

procedure cl_logical_page.reset_print_values;
// azzera i valori della precedente stampa
begin
//	bo_orizzontale := FALSE;
	i_last_pagina_virtuale_stampata := 0;lo_total_record_number := 0;
	vti_start_main_record_on_page := NIL;vti_end_main_record_on_page := NIL;str_local_filenames := NIL
end;

function page_caption(i_logical_page_1B : logical_page_type;bo_descrizione_breve : boolean) : string;
// rende la descrizione della pagina logica specificata; se manca una descrizione esplicita, ne fornisce una di default
begin
	result := get_logical_page_1B(i_logical_page_1B).get_descrizione(bo_descrizione_breve)
//	if (result = '') then result := '(pagina logica ' + inttostr(i_page_1B) + ')'
end;

{$ifdef CASA}

procedure set_main_record_starting_on_page(i_pagina_fisica_assoluta : ph_page_type;str_local_filename : string);
// un record della main section inizia sulla pagina specificata; la pagina specificata indica la pagina fisica relativa all'inizio della pagina logica
begin
	var i_pagina_relativa : ph_page_type := i_pagina_fisica_assoluta - get_first_pagina_fisica_of_pagina_logica + 1;
	if (i_pagina_relativa = 1) OR start_end_main_record_page(i_pagina_relativa-1,FALSE) then begin
		// verifico: se la pagina precedente non era una chiusura, questa non può essere un'apertura
		var p : cl_logical_page := job.pages[job.i_pagina_logica_attiva_1B];
		var i : ph_page_type := length(p.vti_start_main_record_on_page);
		setLength(p.vti_start_main_record_on_page, i+1);p.vti_start_main_record_on_page[i] := i_pagina_relativa;
		setLength(p.str_local_filenames, i+1);p.str_local_filenames[i] := str_local_filename
	end
end;

procedure set_main_record_ending_on_page(i_pagina_fisica_assoluta : ph_page_type);
{ un record della main section termina sulla pagina specificata; la pagina specificata
  indica la pagina fisica relativa all'inizio della pagina logica }
begin
	var i_pagina_relativa : ph_page_type := i_pagina_fisica_assoluta - get_first_pagina_fisica_of_pagina_logica + 1;
	var p : cl_logical_page := job.pages[job.i_pagina_logica_attiva_1B];
	var i : ph_page_type := length(p.vti_end_main_record_on_page);setLength(p.vti_end_main_record_on_page, i + 1);
	p.vti_end_main_record_on_page[i] := i_pagina_relativa
end;

function start_end_main_record_page(i_pagina_fisica_relativa : ph_page_type;bo_start : boolean) : boolean;
{ rende TRUE se un main record inizia/finisce sulla pagina specificata;
  la pagina specificata indica la pagina fisica relativa all'inizio della pagina logica }
var x : start_end_record;	//*
begin
	var p : cl_logical_page := job.pages[job.i_pagina_logica_attiva_1B];
	if bo_start then x := p.vti_start_main_record_on_page else x := p.vti_end_main_record_on_page;
	var i : smallint := 0;while (i < length(x)) AND (x[i] < i_pagina_fisica_relativa) do inc(i);
	result := (i < length(x)) AND (x[i] = i_pagina_fisica_relativa)
end;

function get_main_record_index(i_pagina_fisica_assoluta : ph_page_type) : integer;
// rende l'indice del main record che inizia alla pagina logica/fisica specificata
begin
	var i_pagina_logica : logical_page_type := get_pagina_logica_of_pagina_fisica_1B(i_pagina_fisica_assoluta);
	result := get_main_record_index(i_pagina_logica,
		{i_pagina_fisica_relativa}i_pagina_fisica_assoluta - get_first_pagina_fisica_of_pagina_logica(i_pagina_logica) + 1)
end;

function get_main_record_index(i_pagina_logica_1B : logical_page_type;i_pagina_fisica_relativa : ph_page_type) : integer;
{ rende l'indice del main record che inizia alla pagina logica/fisica specificata;
  il valore restituito (ovviamente, essendo indice di un vettore) è 0-based; in caso di errore o 'record not found' rende -1 }
begin
	if (i_pagina_fisica_relativa = 0) then begin result := -1;exit end;
	var p : cl_logical_page := job.pages[i_pagina_logica_1B];
	result := high(p.vti_start_main_record_on_page);
	while (result >= 0) AND (p.vti_start_main_record_on_page[result] > i_pagina_fisica_relativa) do dec(result)
end;

function get_page_main_record_filename(i_pagina_fisica_assoluta : ph_page_type) : string;
// rende il filename associato con la pagina fisica specificata; è derivato dal main record che inizia sulla suddetta pagina
begin
	var i : ph_page_type := get_main_record_index(i_pagina_fisica_assoluta);
	if (i = -1) then result := '' else result := job.pages[job.i_pagina_logica_attiva_1B].str_local_filenames[i]
end;

//function start_end_main_record_page(i_pagina_fisica_relativa : ph_page_type;bo_start : boolean) : boolean;
//{ rende TRUE se un main record inizia/finisce sulla pagina specificata;
//  la pagina specificata indica la pagina fisica relativa all'inizio della pagina logica }
//var p : cl_logical_page;
//begin
//	p := job.pages[job.i_pagina_logica_attiva];
//	if bo_start then result := p.bo_start_main_record_on_page[i_pagina_fisica_relativa]
//	else result := p.bo_end_main_record_on_page[i_pagina_fisica_relativa]
//end;

function get_first_vpage_of_current_main_record(i_pagina_fisica_relativa : ph_page_type) : ph_page_type;
begin
	if (i_pagina_fisica_relativa = 0) then result := 0
	else begin
		var p : cl_logical_page := job.pages[job.i_pagina_logica_attiva_1B];
//		result := i_pagina_fisica_relativa;
//		while (result >= 1) AND NOT p.bo_start_main_record_on_page[result] do dec(result);
//		j := result;

		var i : ph_page_type := high(p.vti_start_main_record_on_page);
		while (i >= 0) AND (p.vti_start_main_record_on_page[i] > i_pagina_fisica_relativa) do dec(i);
		if (i = -1) then result := 0 else result := p.vti_start_main_record_on_page[i];
//		{$ifdef DEBUG} assert(result = j,'DJMS 29391'); {$endif}
	end
end;

function get_last_vpage_of_current_main_record(i_pagina_fisica_relativa : ph_page_type) : ph_page_type;
var i,{j,}i_last : ph_page_type;
begin
	if (i_pagina_fisica_relativa = 0) then result := 0
	else begin
		var p : cl_logical_page := job.pages[job.i_pagina_logica_attiva_1B];
//		result := i_pagina_fisica_relativa;
//		while (result < xxMAX_PHISICAL_PAGES_PER_LOGICAL_PAGE) AND NOT p.bo_end_main_record_on_page[result] do inc(result);
//		if (NOT p.bo_end_main_record_on_page[result]) then result := 0;

//		j := result;
		i := 0;i_last := high(p.vti_end_main_record_on_page);
		while (i <= i_last) AND (p.vti_end_main_record_on_page[i] < i_pagina_fisica_relativa) do inc(i);
		if (i = i_last + 1) then result := 0 else result := p.vti_end_main_record_on_page[i];
//		{$ifdef DEBUG} assert(result = j,'DJMS 2939XXX'); {$endif}
	end
end;

{$ifdef PROVA} *** NON FUNZIONA LA NUOVA VERSIONE {$endif}
(*function get_first_vpage_of_current_main_record(i_pagina_fisica_relativa : ph_page_type) : ph_page_type;
var i : ph_page_type;
begin
	i := get_main_record_index(job.i_pagina_logica_attiva_1B, i_pagina_fisica_relativa);
	if (i = -1) then result := 0 else result := job.pages[job.i_pagina_logica_attiva_1B].vti_start_main_record_on_page[i]
end;

function get_last_vpage_of_current_main_record(i_pagina_fisica_relativa : ph_page_type) : ph_page_type;
var i : ph_page_type;
begin
	i := get_main_record_index(job.i_pagina_logica_attiva_1B, i_pagina_fisica_relativa);
	if (i = -1) then result := 0 else result := job.pages[job.i_pagina_logica_attiva_1B].vti_end_main_record_on_page[i]
end; *)

function page_msg(i_logical_page : logical_page_type;str_msg : string) : string;
// trasforma il messaggio aggiungendo il riferimento alla pagina logica
begin
	if globale.i_pagine_logiche = 1 then result := str_msg
	else result := page_caption(i_logical_page, TRUE) + ACAPO2 + str_msg
end;

function get_first_pagina_fisica_of_pagina_logica(i_pagina_logica_1B : logical_page_type = 0) : ph_page_type;
// rende la prima pagina fisica (assoluta) della pagina logica specificata; questa procedura è RICORSIVA
begin
	if (i_pagina_logica_1B = 0) then i_pagina_logica_1B := job.i_pagina_logica_attiva_1B;
	if (i_pagina_logica_1B = 1) then result := 1		// la prima pagina fisica della prima pagina logica è sempre la pagina 1
	else result := get_first_pagina_fisica_of_pagina_logica(i_pagina_logica_1B - 1) + get_numero_virtual_pages_of_pagina_logica(i_pagina_logica_1B - 1)
end;

function get_numero_pagine_fisiche_of_pagina_logica(i_pagina_logica_1B : logical_page_type = 0) : ph_page_type;
// rende il numero di pagine fisiche coperto dalla pagina logica specificata
begin
	if (i_pagina_logica_1B = 0) then i_pagina_logica_1B := job.i_pagina_logica_attiva_1B;
	result := get_pagina_fisica_of_pagina_virtuale(get_numero_virtual_pages_of_pagina_logica(i_pagina_logica_1B))
end;

{function get_pagina_logica_of_pagina_fisica(i_pagina_fisica : ph_page_type) : logical_page_type;
// rende la pagina logica cui appartiene la pagina fisica I_PAGINA_FISICA; rende ZERO in caso di errore
var
	i : logical_page_type;
	i_first_pagina_fisica, i_last_pagina_fisica : ph_page_type;
begin
	result := 0;
	for i := 1 to get_ultima_pagina_logica do begin
		i_first_pagina_fisica := get_first_pagina_fisica_of_pagina_logica(i);
		i_last_pagina_fisica := i_first_pagina_fisica + get_numero_virtual_pages_of_pagina_logica(i) - 1;
		if (i_pagina_fisica >= i_first_pagina_fisica) AND (i_pagina_fisica <= i_last_pagina_fisica) then begin result := i;exit end
	end
end; }

function get_pagina_logica_of_pagina_fisica_1B(i_pagina_fisica : ph_page_type) : logical_page_type;
// rende la pagina logica 1-based cui appartiene la pagina fisica; rende ZERO in caso di errore
begin
	var i_logical_1B : logical_page_type := 1;
	var i_last_logical_page_1B : logical_page_type := get_ultima_pagina_logica;
	while (i_logical_1B <= i_last_logical_page_1B) AND
//		((print_pages[i_logical] = NIL) OR
		(NOT pagina_stampata(i_logical_1B) OR
		 (print_pages_1B[i_logical_1B].i_virtual_page_1B + get_numero_virtual_pages_of_pagina_logica(i_logical_1B) - 1 < i_pagina_fisica))
			do inc(i_logical_1B);
	if (i_logical_1B <= get_ultima_pagina_logica) then result := i_logical_1B else result := 0;
	{$ifdef DEBUG} assert((result = 0) OR (print_pages_1B[result] <> NIL), 'PRINT_REPORT.get_logical_page = NIL') {$endif}
end;

function get_numero_virtual_pages_of_pagina_logica(i_pagina_logica_1B : logical_page_type = 0) : ph_page_type;
// rende il numero di pagine fisiche della pagina logica;
begin
	if (i_pagina_logica_1B = 0) then i_pagina_logica_1B := job.i_pagina_logica_attiva_1B;
	{$ifdef DEBUG} check_index(i_pagina_logica_1B, 'get_numero_virtual_pages_of_pagina_logica()', 1, MAX_PAGINE_LOGICHE); {$endif}

{	until 2008-12-21, a causa di un trascurabile errore di selezione a runtime di oggetti in modalità
	if pagina_stampata(i_pagina_logica_1B) then result := job.pages[i_pagina_logica_1B].i_last_pagina_fisica_stampata
	else result := 0; }

	// from 2008-12-21, a causa di un trascurabile errore di selezione a runtime di oggetti in modalità
	if get_logical_page_1B(i_pagina_logica_1B).bo_dont_print then result := 0	// riga aggiunta il 2008-12-21
	else if pagina_stampata(i_pagina_logica_1B) then result := job.pages[i_pagina_logica_1B].i_last_pagina_virtuale_stampata
	else result := 0
end;

function numero_pagine_logiche_non_stampate(i_before_page : logical_page_type) : logical_page_type;
{ rende il numero di pagine logiche non stampate prima di I_BEFORE_PAGE;
  se I_PLS è il numero di pagina logica stampata, I_PLS + numero_pagine_logiche_non_stampate(I_PLS) è la pagina logica reale di I_PLS;
  I_BEFORE_PAGE è il numero della pagina logica stampata; ad esempio, se le pagine indicate fra parentesi sono NON STAMPATE:
	(1) (2) 3 4 (5) 6 7
	numero_pagine_logiche_non_stampate(1) = 3
	numero_pagine_logiche_non_stampate(2) = 4
	numero_pagine_logiche_non_stampate(3) = 6
	numero_pagine_logiche_non_stampate(4) = 7
	numero_pagine_logiche_non_stampate(5) = ERRORE }
begin
	result := 0;var i_stampate : logical_page_type := 0;
	if (i_before_page = 0) then exit;
	for var i : logical_page_type := 1 to get_ultima_pagina_logica do begin
		if NOT pagina_stampata(i) then inc(result)
		else begin
			inc(i_stampate);
			if (i_stampate = i_before_page) then exit
		end
	end
end;

function get_first_pagina_fisica_of_pagina_logica_stampata(i_pagina_logica_1B : logical_page_type = 0) : ph_page_type;
// come GET_FIRST_PAGINA_FISICA_OF_PAGINA_LOGICA(), ma l'indice si riferisce alle sole pagine logiche stampate (salta le pagine blank o nascoste)
begin
	result := get_first_pagina_fisica_of_pagina_logica(i_pagina_logica_1B + numero_pagine_logiche_non_stampate(i_pagina_logica_1B))
end;

function get_numero_virtual_pages_of_pagina_logica_stampata(i_pagina_logica_1B : logical_page_type = 0) : ph_page_type;
// come get_numero_virtual_pages_of_pagina_logica(), ma l'indice si riferisce alle sole pagine logiche stampate (salta le pagine blank o nascoste)
begin
	result := get_numero_virtual_pages_of_pagina_logica(i_pagina_logica_1B + numero_pagine_logiche_non_stampate(i_pagina_logica_1B))
end;

procedure set_last_virtual_page_of_pagina_logica(i_last : ph_page_type);
begin
	job.pages[job.i_pagina_logica_attiva_1B].i_last_pagina_virtuale_stampata := i_last
end;

function get_total_record_number(i_logical_page : logical_page_type = 0) : integer;
// ultimo record utilizzato per la pagina logica specificata (sezione identificata da BO_CONTA_RECORDS)
begin
	if (i_logical_page = 0) then i_logical_page := job.i_pagina_logica_attiva_1B;
	result := job.pages[i_logical_page].lo_total_record_number
end;

procedure set_total_record_number(lo_number : integer;i_logical_page : logical_page_type = 0);
// ultimo record utilizzato per la pagina logica specificata (sezione identificata da BO_CONTA_RECORDS)
begin
	if (i_logical_page = 0) then i_logical_page := job.i_pagina_logica_attiva_1B;
	job.pages[i_logical_page].lo_total_record_number := lo_number
end;

function get_intervallo_pagine_logiche(str_pagine_logiche : string) : string;
// rende l'intervallo delle PAGINE FISICHE corrispondenti a STR_PAGINE_LOGICHE
var lo1, lo2 : integer;
begin
	result := '';
	for var i_pagina_logica_1B : logical_page_type := 1 to get_ultima_pagina_logica do begin
		var lp : cl_logical_page_info := get_logical_page_1B(i_pagina_logica_1B);
		if exists_code(str_pagine_logiche, lp.get_descrizione(TRUE)) then begin
			lo1 := get_first_pagina_fisica_of_pagina_logica(i_pagina_logica_1B);
//			lo2 := lo1 + get_numero_virtual_pages_of_pagina_logica(i_pagina_logica_1B) - 1;	***   fa casino tra pagine virtuali e pagine fisiche
//			lo2 := lo1 + get_numero_pagine_fisiche_of_pagina_logica(i_pagina_logica_1B) - 1;
//			lo2 := job.pages[i_pagina_logica_1B].i_last_pagina_virtuale_stampata;
//			lo2 := get_numero_pagine_fisiche_of_pagina_logica(job.i_last_virtual_printed_page);
			if (globale.tiporeport = TR_LABEL_REPORT) then lo2 := get_last_phisical_printed_page	 // se LABELS esiste una sola pagina logica
			else lo2 := lo1 + get_numero_virtual_pages_of_pagina_logica(i_pagina_logica_1B) - 1;
			add_delimited(result, inttostr(lo1) + INTERVALLO_SEPARATORE + inttostr(lo2))
		end
	end;

	result := get_intervallo_normalizzato(result)
end;

{$endif CASA}

// -------------------- CL_JOB -------------------------------------------------

constructor cl_job.create(father : TForm);
begin
	{$ifdef DEBUG} inc(i_jobs); {$endif}
	self.father := father;
//	i_virtual_printing_page := 0;str_caption := '';str_last_error := '';xglobal := NIL;
	for var i : logical_page_type := 1 to MAX_PAGINE_LOGICHE do pages[i] := cl_logical_page.create;
	i_pagina_logica_attiva_1B := 1
end;

destructor cl_job.free;
begin
	{$ifdef DEBUG} dec(i_jobs); {$endif}
	i_pagina_logica_attiva_1B := 0;
	for var i : logical_page_type := 1 to MAX_PAGINE_LOGICHE do pages[i].free;
	if (xglobal <> NIL) then xglobal.freex
end;

function cl_job.get_last_error : string; begin result := str_ph_last_error end;
procedure cl_job.set_last_error(str : string); begin str_ph_last_error := str end;
function cl_job.get_caption : string; begin result := str_ph_caption end;
procedure cl_job.set_caption(str : string); begin str_ph_caption := str end;
function cl_job.get_pagina_logica_attiva_1B : logical_page_type; begin result := i_ph_pagina_logica_attiva end;
procedure cl_job.set_pagina_logica_attiva_1B(i : logical_page_type); begin i_ph_pagina_logica_attiva := i end;
function cl_job.get_pagina_logica_attiva_ZB : logical_page_type; begin result := i_ph_pagina_logica_attiva - 1 end;
procedure cl_job.set_pagina_logica_attiva_ZB(i : logical_page_type); begin i_ph_pagina_logica_attiva := i + 1 end;
function cl_job.get_globale : TGlobale; begin result := ph_xglobal end;
procedure cl_job.set_globale(g : TGlobale); begin ph_xglobal := g end;

procedure set_job_datetime(i_job : smallint = 0;dt : TDatetime = 0);
// imposta data/ora ufficiale per la stampa
begin
	if (i_job = 0) then i_job := i_active_job;
	if (dt = 0) then dt := now;
	jobs[i_job].dt_time := dt
end;

function get_job_datetime(i_job : smallint = 0) : TDatetime;
// restituisce data/ora ufficiale per la stampa
begin
	if (i_job = 0) then i_job := i_active_job;
	result := jobs[i_job].dt_time;
	if (result = 0) then result := now	// cerco quantomeno di limitare il danno
end;

{$ifdef GALATEO_EXE}

function insert_pagina_logica : boolean;
{ inserisce una nuova pagina logica prima della pagina corrente;
  rende TRUE in caso di successo; emette eventuali messaggi di errore;
  dopo la chiamata (se successful) la pagina corrente deve essere ridisegnata per rendere manifesta la modifica alla struttura }
var i_profilo : expint_index_type;	//*
begin
	result := FALSE;
	if (get_ultima_pagina_logica = MAX_PAGINE_LOGICHE) then begin
		MessageBBox(0, 'Raggiunto il numero max di pagine logiche', MBOX_CAPTION);
		exit
	end;

	var i_page1B : logical_page_type := get_ultima_pagina_logica + 1;		// I è l'indice della pagina da eliminare, 1-based

	// rilascio il record per l'ultima pagina di ogni profilo di exportazione (prima di spostare 'in su' tutte le altre pagine)
	for i_profilo := 0 to high(globale.expint_profiles) do begin
//		globale.expint_profiles[i_profilo].expint_pages[MAX_PAGINE_LOGICHE-1].free;
//		{$ifdef DEBUG} globale.expint_profiles[i_profilo].expint_pages[MAX_PAGINE_LOGICHE-1] := NIL {$endif}
		globale.expint_profiles[i_profilo].expint_pages[i_page1B-1].free;
		{$ifdef DEBUG} globale.expint_profiles[i_profilo].expint_pages[i_page1B-1] := NIL {$endif}
	end;

	var pl_temp : cl_logical_page := job.pages[i_page1B];
	globale.lpZB_info[i_page1B - 1].free;
	{$ifdef DEBUG} globale.lpZB_info[i_page1B - 1] := NIL; {$endif}
	for i_page1B := get_ultima_pagina_logica downto get_pagina_logica_attiva_1B do begin			// I è 1-based
		job.pages[i_page1B + 1] := job.pages[i_page1B];
		job.pages[i_page1B + 1].update_logical_page_number(i_page1B, i_page1B + 1);
		globale.lpZB_info[i_page1B] := globale.lpZB_info[i_page1B - 1];
		globale.lpZB_info[i_page1B].update_logical_page_number(i_page1B + 1);
		for i_profilo := 0 to high(globale.expint_profiles) do begin
			globale.expint_profiles[i_profilo].expint_pages[i_page1B] := globale.expint_profiles[i_profilo].expint_pages[i_page1B - 1];
//			{$ifdef DEBUG} globale.expint_profiles[i_profilo].expint_pages[i - 1] := NIL {$endif}
		end
	end;
	i_page1B := get_pagina_logica_attiva_1B;
	job.pages[i_page1B] := pl_temp;
	globale.lpZB_info[i_page1B - 1] := cl_logical_page_info.create(i_page1B);
	for i_profilo := 0 to high(globale.expint_profiles) do
//			globale.expint_profiles[i_profilo].expint_pages[i - 1].create;	// zero-based
		globale.expint_profiles[i_profilo].expint_pages[i_page1B - 1] := cl_expint_page.ZB_create(i_page1B - 1);
	inc(globale.i_pagine_logiche);	// modifica get_ultima_pagina_logica()
	result := TRUE
end;

function delete_pagina_logica : boolean;
{ elimina la pagina logica corrente;
  rende TRUE in caso di successo; emette eventuali messaggi di errore;
  dopo la chiamata (se successfull) la pagina corrente deve essere ridisegnata per
  rendere manifesta la modifica alla struttura }
var
	i_obj : obj_index_type;
	i_page_1B : logical_page_type;
	i_profilo : expint_index_type;
begin
	result := FALSE;
	if (get_ultima_pagina_logica = 1) then begin
		MessageBBox(0, 'Impossibile eliminare la prima (ed unica) pagina logica', MBOX_CAPTION);
		exit
	end;

	i_page_1B := get_pagina_logica_attiva_1B;
	// rendo gli oggetti della pagina attiva
	for i_obj := 1 to i_objs(i_page_1B) do begin
		xobjs(i_obj, i_page_1B).free;
		assign_obj(i_obj, NIL)
	end;
	set_num_objs(0, i_page_1B);

	var pl_temp : cl_logical_page := job.pages[i_page_1B];
	globale.lpZB_info[i_page_1B - 1].free;
	for i_profilo := 0 to high(globale.expint_profiles) do
		globale.expint_profiles[i_profilo].expint_pages[i_page_1B - 1].free;	// index is zero-based
	for i_page_1B := i_page_1B + 1 to get_ultima_pagina_logica do begin
		job.pages[i_page_1B - 1] := job.pages[i_page_1B];
		job.pages[i_page_1B - 1].update_logical_page_number(i_page_1B, i_page_1B - 1);
		globale.lpZB_info[i_page_1B - 2] := globale.lpZB_info[i_page_1B - 1];
		for i_profilo := 0 to high(globale.expint_profiles) do
			globale.expint_profiles[i_profilo].expint_pages[i_page_1B - 2] := globale.expint_profiles[i_profilo].expint_pages[i_page_1B - 1]	// zero-based
	end;
	job.pages[get_ultima_pagina_logica] := pl_temp;
	i_page_1B := get_ultima_pagina_logica;
	globale.lpZB_info[i_page_1B - 1] := cl_logical_page_info.create(i_page_1B);
	for i_profilo := 0 to high(globale.expint_profiles) do
//		globale.expint_profiles[i_profilo].expint_pages[i_page - 1].create;	// zero-based
		globale.expint_profiles[i_profilo].expint_pages[i_page_1B - 1] := cl_expint_page.ZB_create(i_page_1B - 1);	// zero-based
	dec(globale.i_pagine_logiche);	// modifica get_ultima_pagina_logica()
	result := TRUE
end;

{$endif NOT DLL}

// ---------------- JOBS procedures --------------------------------------------

function get_active_job : smallint;
begin
	result := i_active_job
end;

function set_active_job(i_job : smallint) : smallint;
// attiva il JOB di stampa I_JOB; rende il JOB precedentemente attivo
begin
	result := i_active_job;
	i_active_job := i_job
end;

function job : cl_job;
// rende il job attivo
begin
	try
		{$ifdef DEBUG} check_index(i_active_job, 'JOB', 0, MAX_JOBS); {$endif}
		if (i_active_job = 0) then result := NIL else result := jobs[i_active_job]
	except
		result := NIL
	end
end;

function get_father_of_job(i_job : smallint = 0) : TForm;
begin
	if (i_job = 0) then i_job := i_active_job;
	result := jobs[i_job].father
end;

function mbox_caption : string;
begin
	if (job = NIL) then result := ''
	else result := job.str_caption;
	if (result = '') then result := PROGRAM_NAME
end;

procedure set_mbox_caption(str_caption : string);
begin job.str_caption := str_caption end;

function alloca_job(father : TForm) : smallint;
{ alloca un new job e rende l'indice del new job;
  imposta il job corrente sul new job;
  rende 0 in caso di errore }
begin
	result := 0;var i_job : smallint := 1;
	while (i_job <= MAX_JOBS) AND (jobs[i_job] <> NIL) do inc(i_job);
	if (i_job > MAX_JOBS) then begin
		set_last_job_error('Impossibile aprire più di ' + MAX_JOBS.ToString + ' lavori di stampa contemporanei');
		exit
	end;
	jobs[i_job] := cl_job.create(father);
	set_active_job(i_job);
	result := i_job
end;

procedure free_job(i_job : smallint);
begin
	try jobs[i_job].free except end;
	jobs[i_job] := NIL
end;

procedure set_last_job_error(str_error : string);
// rende TRUE in caso di successo, FALSE altrimenti
begin
	if (str_error <> '') then FDebug.debug(0, '', str_error);
	var j := job;
	if (j <> NIL) then j.str_last_error := str_error
end;

function get_last_job_error : string;
// rende TRUE in caso di successo, FALSE altrimenti
begin
	if (job <> NIL) then result := job.str_last_error
	else result := ''
end;

procedure set_virtual_printing_page(i : ph_page_type);
begin
	with job do begin
		i_virtual_printing_page := i;
		if (i = 0) then i_last_virtual_printed_page := 0
		else i_last_virtual_printed_page := MAX(i_last_virtual_printed_page, i)
	end
end;

function get_virtual_printing_page : ph_page_type;
begin
	result := job.i_virtual_printing_page
end;

function get_last_virtual_printed_page : ph_page_type;
begin
	result := job.i_last_virtual_printed_page
end;

function get_last_phisical_printed_page : ph_page_type;
begin
//	result := get_last_virtual_printed_page div (tm.i_lab_per_row * tm.i_lab_per_page)
	result := get_pagina_fisica_of_pagina_virtuale(get_last_virtual_printed_page)
end;

function get_phisical_printing_page : ph_page_type;
begin
//	result := get_virtual_printing_page div (tm.i_lab_per_row * tm.i_lab_per_page)
	result := get_pagina_fisica_of_pagina_virtuale(get_virtual_printing_page)
end;

// ---------------------- end of JOBS procedures -------------------------------

function i_virtual_pages_per_phpage : ph_page_type;	// numero di pagine virtuali per ogni pagina fisica
begin
	result := tm.i_lab_per_row * tm.i_lab_per_page
end;

function get_pagina_fisica_of_pagina_virtuale(i_pagina_virtuale : ph_page_type) : ph_page_type;
// rende la pagina fisica cui fa capo la pagina virtuale specificata
begin
	if (globale.tiporeport = TR_REPORT) then result := i_pagina_virtuale
	else result := (i_pagina_virtuale - 1) div (tm.i_lab_per_row * tm.i_lab_per_page) + 1
end;

{$ifdef CASA}

	procedure assign_globale(i_job : smallint;globale : TGlobale);
	begin
		jobs[i_job].xglobal := globale
	end;

	function globale : TGlobale;
	begin
		if (job = NIL) then result := NIL
		else result := job.xglobal
	end;

	function get_globale(i_job : smallint) : TGlobale;
	begin
		result := jobs[i_job].xglobal
	end;

{$endif CASA}

procedure text_only_BeginDoc;
begin
	{ $define PRINT_ON_FILE}
	{$ifdef PRINT_ON_FILE}
		{$ifndef DEBUG} * not so good, I am afraid * {$endif}
		system.assign(jobs[get_active_job].print_file, 'prova.pas');
	{$else}
		assignprn(jobs[get_active_job].print_file);
	{$endif}
	rewrite(jobs[get_active_job].print_file);
	text_only_newpage
end;

procedure text_only_EndDoc;
begin
	with jobs[get_active_job] do begin
		if bo_text_only_open_page then text_only_closepage;
		close(print_file)
	end
end;

procedure text_only_Abort;
begin
	with jobs[get_active_job] do begin
		bo_text_only_open_page := FALSE;
		{$I-} close(print_file);if IOresult = 0 then; {$I+}
	end
end;

procedure text_only_newpage;
begin
	var s := xstril('',globale.i_text_only_colonne, SA_RIGHT);
	with jobs[get_active_job] do begin
		if bo_text_only_open_page then text_only_closepage;
		for var i : smallint := 1 to MAX_LINES_PER_PRINT_PAGE do begin
			text_only_print_buffer[i] := s;
			setlength(text_only_print_buffer[i],globale.i_text_only_colonne)	// alloco stringhe referenziate singolarmente
		end;
		bo_text_only_open_page := TRUE
	end
end;

procedure text_only_closepage;
begin
	printer.canvas.font.assign(globale.Text_only_font);	// assegno il font scelto per la stampa
	with jobs[get_active_job] do begin
		for var i : smallint := 1 to globale.i_text_only_colonne do
			writeln(print_file,togliblanks_eoln(text_only_print_buffer[i]));
		{$ifdef DEBUG} assert(bo_text_only_open_page,'pagina di stampa text-only non opened POK-314'); {$endif}
		bo_text_only_open_page := FALSE
	end
end;

procedure text_only_print(i_riga, i_colonna : smallint;s : string);
// si stampa la stringa S alla riga I_RIGA e alla colonna I_COLONNA; indici 1-based, of course
begin
	with jobs[get_active_job] do begin
		if (i_riga < 0) OR (i_riga > globale.i_text_only_righe) then
			raise Exception.create('Indice riga <' + inttostr(i_riga) + '> fuori misura');
		if (i_colonna < 1) then
			raise Exception.create('Indice colonna negativo');
		if (i_colonna + length(s) - 1 > globale.i_text_only_colonne) then begin
			{$ifdef DEBUG} assert(FALSE,'pages.TEXT_ONLY_PRINT(): indice COLONNA fuori misura'); {$endif}
			setlength(text_only_print_buffer[i_riga], i_colonna + length(s) - 1)
		end;
//		move(s[1], text_only_print_buffer[i_riga][i_colonna], s.Length)
//strMessageBBox(0,s,stri(i_riga,2)+'/' + stri(i_colonna,2),0);
		for var j : smallint := 1 to length(s) do text_only_print_buffer[i_riga][i_colonna+j-1] := s[j]
	end
end;

procedure runtime_debug(str_text, str_caption : string;i_livello_importanza : byte);
{ emette un messaggio di runtime debugging;
  schiacciando CONTROL compaiono i messaggi marcati come MAIN,
  schiacciando anche ALT compaiono anche tutti gli altri;
  I_LIVELLO_IMPORTANZA vale 0 per i messaggi importanti, 1 per quelli meno, 2 per quelli trascurabili, 3 .... }
begin
	if (globale <> NIL) AND globale.bo_debug_full then Gdebug_SQL(str_text, str_caption, TRUE)		// se (!bo_debug_full) scrivo solo le istruzioni SQL
//		if (i_livello_importanza = 0) OR ((globale <> NIL) AND globale.bo_debug_full) then gdebug_SQL(str_text, str_caption, TRUE)		**** prima versione
end;

function is_debug_attivo(i_livello_importanza : byte) : boolean;
// rende TRUE se è attivo il debugging per il livello specificato
begin
	result := (globale <> NIL) AND globale.bo_debug_full
end;

//{$ifdef DEBUG} var i : byte; {$endif}

// ------------ PROFILES -------------------------------------------------------

constructor cl_print_profile.create;
begin
//	self.bo_default := bo_default;
	{$ifdef DEBUG} inc(i_profiles); {$endif}
	str_profilo := 'default'
end;

destructor cl_print_profile.free;
begin
	{$ifdef DEBUG} dec(i_profiles) {$endif}
end;

procedure cl_print_profile.assign(p : cl_print_profile);
begin
//	bo_default := p.bo_default;
	str_profilo := p.str_profilo;
	str_printer := p.str_printer;
	str_cassetto_carta := p.str_cassetto_carta;
//	xfgppl := p.xfgppl;
	str_attiva_on_workstation := p.str_attiva_on_workstation;
	str_attiva_on_IP := p.str_attiva_on_IP;
	str_attiva_on_windows_username := p.str_attiva_on_windows_username;
	r_marg_sx_cm_ph := p.r_marg_sx_cm_ph;
	r_marg_up_cm_ph := p.r_marg_up_cm_ph
end;

function cl_print_profile.read_profile(var f : text) : boolean;
var i : smallint;	//*
begin
	try
		readln(f, str_profilo);
		if (str_profilo = '') then str_profilo := 'default';
		readln(f, str_printer);
		readln(f, str_cassetto_carta);
		readln(f,{c,} i, r_marg_sx_cm_ph, r_marg_up_cm_ph);
//		bo_default := SQL2bool(c);
//		xfgppl := xFGPPL_type(i);
		readln(f, str_attiva_on_workstation);
		readln(f, str_attiva_on_IP);
		readln(f, str_attiva_on_windows_username);
		if (i = 0) then;			// riga totalmente inutile che serve per non mostrare la warning sul valore di I
		for i := 1 to 2 do readln(f);	// future implementations
		result := TRUE
	except
		result := FALSE
	end
end;

{$ifdef GALATEO_EXE}
	function cl_print_profile.save_profile(var f : text): boolean;
	// salva il profilo; rende TRUE in caso di successo, FALSE altrimenti
	begin
		try
			writeln(f, lowercase(str_profilo));
			writeln(f, str_printer);
			writeln(f, str_cassetto_carta);
			writeln(f, {bool2SQL(bo_default),} {byte(xfgppl)}'0', ' ', r_marg_sx_cm_ph:0:3, ' ', r_marg_up_cm_ph:0:3);
			writeln(f, str_attiva_on_workstation);
			writeln(f, str_attiva_on_IP);
			writeln(f, str_attiva_on_windows_username);
			for var i : smallint := 1 to 2 do writeln(f);	// future implementations
			result := TRUE
		except
			result := FALSE
		end
	end;

	function write_profiles(i_pagina : logical_page_type;var f : text) : boolean;
	{ salva tutti i profili per la pagina;
	  formato: scrive tutti i dati di un profilo, quindi scrive T se ci sono
	  altri profili, F se si tratta dell'ultimo profilo }
	begin
		try
			var p : cl_print_profile := jobs[get_active_job].pages[i_pagina].profiles;
			while (p <> NIL) do begin
				if NOT p.save_profile(f) then abort;
				p := p.next;
				writeln(f, bool2SQL(p <> NIL))
			end;
			result := TRUE
		except
			result := FALSE
		end
	end;
{$endif}

function read_profiles(i_pagina : logical_page_type;var f : text) : boolean;
var c : char;	//*
begin
	try
		var p : cl_print_profile := jobs[get_active_job].pages[i_pagina].profiles;
		repeat
			if NOT p.read_profile(f) then abort;
			readln(f, c);
			if (c = SQL_TRUE) then p.next := cl_print_profile.Create;
			p := p.next
		until (p = NIL);
		result := TRUE
	except
		result := FALSE
	end
end;

function set_active_profile(str_profilo : string;i_pagina : logical_page_type = 0;bo_set_from_calling_program : boolean = FALSE) : cl_print_profile;
{ BO_SET_FROM_CALLING_PROGRAM è TRUE se l'assegnazione avviene attraverso la chiamata del programma principale a CASA.DLL;
  è FALSE se il profilo viene attivato automaticamente in funzione delle condizioni (username, IP, computername) }
begin
	if (i_pagina = 0) then i_pagina := get_pagina_logica_attiva_1B;
	result := get_profile(str_profilo, i_pagina);
	{$ifdef GALATEO_EXE} {$ifdef DEBUG}
		// se DLL, il profilo può anche non esistere, nel qual caso non succede nulla
		assert(result <> NIL,'set_active_profile(' + str_profilo + '): profilo non esistente');
	{$endif} {$endif}
	if (result <> NIL) then begin
		jobs[get_active_job].pages[i_pagina].selected_profile := result;
		result.bo_set_from_calling_program := TRUE
	end
end;

function get_active_profile(i_pagina : logical_page_type = 0) : cl_print_profile;
begin
	if (i_pagina = 0) then i_pagina := get_pagina_logica_attiva_1B;
	result := jobs[get_active_job].pages[i_pagina].selected_profile
end;

function get_profile(str_nome : string;i_pagina : logical_page_type = 0) : cl_print_profile;
begin
	if (i_pagina = 0) then i_pagina := get_pagina_logica_attiva_1B;
	result := jobs[get_active_job].pages[i_pagina].profiles;
	str_nome := lowercase(str_nome);
	while (result <> NIL) AND (result.str_profilo <> str_nome) do result := result.next
end;

function new_profile(str_nome : string;i_pagina : logical_page_type = 0;modello : cl_print_profile = NIL) : cl_print_profile;
// crea un nuovo profilo e rende un puntatore al nuovo profilo; rende NIL in caso di errori (che vengono manifestati all'utente)
begin
	try
		if (i_pagina = 0) then i_pagina := get_pagina_logica_attiva_1B;
		if (get_profile(str_nome,i_pagina) <> NIL) then
			raise exception.create('Il profile <' + str_nome + ' esiste già');
		var p : cl_print_profile := jobs[get_active_job].pages[i_pagina].profiles;
		if (modello = NIL) then modello := get_active_profile(i_pagina);	// modello default
		while (p.next <> NIL) do p := p.next;
		p.next := cl_print_profile.Create;p := p.next;
		p.assign(modello);
		p.str_profilo := str_nome;
		result := p
	except
		error_msg('Errore durante la creazione del nuovo profilo', MBOX_CAPTION);
		result := NIL
	end
end;

procedure load_profili_itemlist(it : Tstrings;i_pagina : logical_page_type = 0);
begin
	if (i_pagina = 0) then i_pagina := get_pagina_logica_attiva_1B;
	var p : cl_print_profile := jobs[get_active_job].pages[i_pagina].profiles;
	it.Clear;
	while (p <> NIL) do begin
		it.Add(p.str_profilo);
		p := p.next
	end
end;

procedure delete_profile(str_profilo : string;i_pagina : logical_page_type = 0);
begin
	if (i_pagina = 0) then i_pagina := get_pagina_logica_attiva_1B;
	var p : cl_print_profile := jobs[get_active_job].pages[i_pagina].profiles;
	if (p.str_profilo = str_profilo) then begin
		jobs[get_active_job].pages[i_pagina].profiles := p.next;
		p.free
	end
	else begin
		while (p.next.str_profilo <> str_profilo) do p := p.next;
		var q : cl_print_profile := p.next;
		p.next := q.next;
		q.free
	end
end;

function pagina_stampata(i_page_1B : logical_page_type) : boolean;
begin
	result := jobs[get_active_job].pages[i_page_1B].pagina_stampata
end;

function cl_logical_page.pagina_stampata : boolean;
begin
	result := (i_last_pagina_virtuale_stampata <> 0)
end;

// -----------------------------------------------------------------------------

function draw_lines_separazione_label : boolean;
// rende TRUE se devono essere disegnate le linee esterne dell'etichetta
begin
	result := jobs[get_active_job].pages[1].bo_draw_lines_separazione_label
end;

procedure set_draw_lines_separazione_label(bo : boolean);
begin
	jobs[get_active_job].pages[1].bo_draw_lines_separazione_label := bo
end;

function get_label_size_X_cm : misura_real_type;
begin
//	{$ifdef DEBUG} assert(globale.tiporeport = TR_LABEL_REPORT,'globale.tiporeport <> TR_LABEL_REPORT -- KMZZ 0290'); {$endif}
	{$ifdef DEBUG} assert(globale.tiporeport in LABEL_TYPES,'globale.tiporeport NOT IN (LABEL_TYPES) -- KMZZ 0290'); {$endif}
	{$ifdef DEBUG} assert(globale.i_pagine_logiche = 1,'I_PAGINE > 1 -- KMZX 0290'); {$endif}
	result := jobs[get_active_job].pages[1].r_label_width_cm
end;

procedure set_label_size_X_cm(r_value : misura_real_type);
begin
//	{$ifdef DEBUG} assert(globale.tiporeport = TR_LABEL_REPORT,'globale.tiporeport <> TR_LABEL_REPORT -- KMZZ 0291'); {$endif}
	{$ifdef DEBUG} assert(globale.tiporeport in LABEL_TYPES,'globale.tiporeport NOT IN (LABEL_TYPES) -- KMZZ 0291'); {$endif}
	{$ifdef DEBUG} assert(globale.i_pagine_logiche = 1,'I_PAGINE > 1 -- KMZX 0291'); {$endif}
	jobs[get_active_job].pages[1].r_label_width_cm := r_value
end;

function i_label_size_X_pix_video : int_pixel_type;
begin
	result := cm2pixel_video_x(get_label_size_X_cm)
end;

function i_label_size_X_pix_print : int_pixel_type;
begin
	result := cm2pixel_print_x(get_label_size_X_cm)
end;

// -----------------------------------------------------------------------------

function get_numero_etichette_const : integer;
begin
	if (job.pages[1].str_object_numero_stampe_etichetta = '') then result := max(job.pages[1].i_numero_stampe_etichetta, 1)
	else result := 1	// risposta senza senso
end;

function get_numero_etichette_object : string;
begin
	result := job.pages[1].str_object_numero_stampe_etichetta
end;

procedure set_numero_etichette(i_numero : integer;str_object : string);
begin
	var p : cl_logical_page := job.pages[1];
	p.str_object_numero_stampe_etichetta := str_object;
	if (str_object = '') then p.i_numero_stampe_etichetta := max(i_numero, 1)
	else p.i_numero_stampe_etichetta := 1
end;

// -----------------------------------------------------------------------------

function get_label_size_Y_cm : misura_real_type;
begin
//	{$ifdef DEBUG} assert(globale.tiporeport = TR_LABEL_REPORT,'globale.tiporeport <> TR_LABEL_REPORT -- KMZZ 0292'); {$endif}
	{$ifdef DEBUG} assert(globale.tiporeport in LABEL_TYPES,'globale.tiporeport NOT IN (LABEL_TYPES) -- KMZZ 0292'); {$endif}
	{$ifdef DEBUG} assert(globale.i_pagine_logiche = 1,'I_PAGINE > 1 -- KMZX 0292'); {$endif}
	result := jobs[get_active_job].pages[1].r_label_height_cm
end;

procedure set_label_size_Y_cm(r_value : misura_real_type);
begin
//	{$ifdef DEBUG} assert(globale.tiporeport = TR_LABEL_REPORT,'globale.tiporeport <> TR_LABEL_REPORT -- KMZZ 0293'); {$endif}
	{$ifdef DEBUG} assert(globale.tiporeport in LABEL_TYPES,'globale.tiporeport NOT IN (LABEL_TYPES) -- KMZZ 0293'); {$endif}
	{$ifdef DEBUG} assert(globale.i_pagine_logiche = 1,'I_PAGINE > 1 -- KMZX 0293'); {$endif}
	jobs[get_active_job].pages[1].r_label_height_cm := r_value
end;

function i_label_size_Y_pix_video : int_pixel_type;
begin
	result := cm2pixel_video_x(get_label_size_Y_cm)
end;

function i_label_size_Y_pix_print : int_pixel_type;
begin
	result := cm2pixel_print_x(get_label_size_Y_cm)
end;

// -----------------------------------------------------------------------------

function get_vpage_size_X_cm(i_page_1B : logical_page_type = 1) : misura_real_type;
begin
	if (globale = NIL) OR NOT (globale.tiporeport in LABEL_TYPES) then result := get_PHpage_size_X_cm_1B(i_page_1B)
	else result := get_label_size_X_cm
end;

procedure set_vpage_size_X_cm(i_page_1B : logical_page_type;r_value : misura_real_type);
begin
	if (globale = NIL) OR NOT (globale.tiporeport in LABEL_TYPES) then set_PHpage_size_X_cm_1B(i_page_1B, r_value)
	else set_label_size_X_cm(r_value)
end;

function i_vpage_size_X_pix_video(i_page_1B : logical_page_type) : int_pixel_type;
begin
	if (globale = NIL) then result := i_PHpage_size_X_pix_video(i_page_1B)
	else if (globale.tiporeport in LABEL_TYPES) then result := i_label_size_X_pix_video else result := i_PHpage_size_X_pix_video(i_page_1B)
end;

function i_vpage_size_X_pix_print(i_page_1B : logical_page_type) : int_pixel_type;
begin
	if (globale = NIL) OR NOT (globale.tiporeport in LABEL_TYPES) then result := i_PHpage_size_X_pix_print(i_page_1B)
	else result := i_label_size_X_pix_print
end;

// -----------------------------------------------------------------------------

function get_vpage_size_Y_cm(i_page_1B : logical_page_type = 1) : misura_real_type;
begin
	if (globale = NIL) OR NOT (globale.tiporeport in LABEL_TYPES) then result := get_PHpage_size_Y_cm_1B(i_page_1B)
	else result := get_label_size_Y_cm
end;

procedure set_vpage_size_Y_cm(i_page_1B : logical_page_type;r_value : misura_real_type);
begin
	if (globale = NIL) OR NOT (globale.tiporeport in LABEL_TYPES) then set_PHpage_size_Y_cm_1B(i_page_1B, r_value)
	else set_label_size_Y_cm(r_value)
end;

function i_vpage_size_Y_pix_video(i_page_1B : logical_page_type) : int_pixel_type;
begin
	if (globale = NIL) OR NOT (globale.tiporeport in LABEL_TYPES) then result := i_PHpage_size_Y_pix_video(i_page_1B)
	else result := i_label_size_Y_pix_video
end;

function i_vpage_size_Y_pix_print(i_page_1B : logical_page_type) : int_pixel_type;
begin
	if (globale = NIL) OR NOT (globale.tiporeport in LABEL_TYPES) then result := i_PHpage_size_Y_pix_print(i_page_1B)
	else result := i_label_size_Y_pix_print
end;

// -----------------------------------------------------------------------------

function tag2object(lo_tag : integer;bo_only_active_logical_page : boolean = TRUE) : objs_type;

	function xtry(i_page_1B : logical_page_type) : objs_type;
	begin
		var x : cl_logical_page := job.pages[i_page_1B];
		for var i : obj_index_type := 1 to i_objs(i_page_1B) do
			if (lo_tag = x.objs[i].get_tag) then begin result := x.objs[i];exit end;
		result := NIL
	end;

begin
	result := xtry(job.i_pagina_logica_attiva_1B);
	if NOT bo_only_active_logical_page then begin
		for var i : logical_page_type := 1 to get_ultima_pagina_logica do begin
			if (i <> job.i_pagina_logica_attiva_1B) then continue;
			result := xtry(i);if (result <> NIL) then exit
		end
	end
end;

function check_printer_page_size(father : TForm;i_pagina_logica_1B : logical_page_type;i_width_mm, i_height_mm : smallint) : boolean;
begin
	result := TRUE;
	var xp : cl_logical_page_info := get_logical_page_1B(i_pagina_logica_1B);
	if (xp.printer_size_constraints_mode = PSC_EXCLUDE) then exit;		// nessun controllo da eseguire

	if (i_width_mm = 0) OR (i_height_mm = 0) then exit;

	var constraints : printer_size_constraints_data_type := xp.printer_size_constraints;
	if (constraints.i_min_width_mm <> 0) AND (i_width_mm < constraints.i_min_width_mm) then result := FALSE;
	if (constraints.i_max_width_mm <> 0) AND (i_width_mm > constraints.i_max_width_mm) then result := FALSE;

	if (constraints.i_min_height_mm <> 0) AND (i_height_mm < constraints.i_min_height_mm) then result := FALSE;
	if (constraints.i_max_height_mm <> 0) AND (i_height_mm > constraints.i_max_height_mm) then result := FALSE
end;

initialization
	galateo_initialization_debug('pages');
{$ifdef DEBUG}
	for var i : smallint := 1 TO MAX_JOBS do assert(jobs[i] = NIL,'DSDH 2538 -- NOT NIL !!!!');
{$endif}
//	for i := 1 TO MAX_JOBS do jobs[i] := NIL;
{$ifdef GALATEO_EXE}
	jobs[1] := cl_job.create(NIL);
	set_active_job(1);
	set_mbox_caption(GALATEO_MBOX_CAPTION)
{$endif NOT DLL}
finalization
	galateo_finalization_debug('pages');
	{$ifdef GALATEO_EXE} jobs[1].free;jobs[1] := NIL; {$endif}
{$ifdef DEBUG}
	CCI(i_jobs, 'cl_job', 'pages.pas');
	CCI(i_logical_pages, 'cl_logical_page', 'pages.pas');
	CCI(i_profiles, 'cl_print_profile', 'pages.pas')
{$endif}
end.
