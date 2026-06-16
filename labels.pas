unit labels;	//*

{$I defines}

interface

uses SysUtils, UITypes, VCL.StdCtrls, VCL.Graphics, Windows, StrUtils, VCL.Forms, Messages, Types, Classes, VCL.Dialogs, Math,
	Fcommons, FXstrings, Fstrings, Flabel, valuta,
	{$ifndef DLL} panel, {$endif}
	Gdich, expint_base, objsx;

type
	runtime_tipodato_type = (RTT_TEXT, RTT_DATA, RTT_FILENAME);
{$ifndef DLL}
const
//	EXPINT_MULTILINE_GESTITE_RIGIDAMENTE = [EXPINTML_EXCEL, EXPINTML_ONLY_FIRST_LINE];	// modalità all'interno delle quali l'utente non può parametrare il comportamento
	EXPINT_MULTILINE_DESCR : array[expint_multiline_type] of string = (
		'modalità Excel',						// EXPINTML_EXCEL,
		'solo prima riga',					// EXPINTML_ONLY_FIRST_LINE,
		'nessun intervento',					// EXPINTML_NONE,					// non fa nulla (sostituisce gli acapo con la stringa STR_EXPINT_ACAPO)
		'racchiude tra apici',				// EXPINTML_APICI,				// racchiude la stringa tra apici SEMPLICI
		'racchiude tra doppi apici');		// EXPINTML_DOPPI_APICI);		// racchiude la stringa tra apici DOPPI
{$endif}
type
	// tipi di scripts eseguibili runtime
	runtime_script_type = (RST_BLANK, RST_SETVALUE, RST_RELOAD_COMBO);
	// la versione xxxx_WC è una modalità accessoria della corrispondente modalità principale: When Changed
	runtime_script_event = (RSE_BLANK, RSE_ON_UPDATE, RSE_ON_ENTER, RSE_ON_DROPDOWN, RSE_ON_CLOSEUP, RSE_ON_EXIT, RSE_ON_CLOSEUP_WC, RSE_ON_EXIT_WC);
const
	RSE_DEFAULT = [RSE_ON_EXIT_WC];
	RSE_WC_BASE_EVENT_FIRST = RSE_ON_CLOSEUP;
	RSE_WC_BASE_EVENT_LAST = RSE_ON_EXIT;
	RSE_WC_BASE_EVENTS = [RSE_WC_BASE_EVENT_FIRST..RSE_WC_BASE_EVENT_LAST];
	RSE_SCRIPT_REFERENZIABILI = [RSE_ON_UPDATE, RSE_ON_ENTER, RSE_ON_CLOSEUP, RSE_ON_EXIT, RSE_ON_CLOSEUP_WC, RSE_ON_EXIT_WC];	// valori referenziabili negli scripts
type
	cl_runtime_script = class
		private
			function read_from_text(str_text : string;bo_error_msg : boolean) : boolean;
			procedure reset;
		public
			tipo : runtime_script_type;
			execute_on_events : set of runtime_script_event;
			str_apply_on_parametro : string;
			str_value : string;
	end;

	cl_runtime_scripts = class
		private
			str_text : string;
		private
{$ifndef DLL}
			handle : hwnd;
			constructor create(handle : hwnd);
			destructor free;
{$endif DLL}
			function read_text(str_text : string) : boolean;
		public
			sx : array of cl_runtime_script;
			function get_text : string;
			function set_text(str_text : string) : boolean;
	end;

const
	RST_SET_VALUE_OPTION = '/SET_VALUE';
	RST_RELOAD_COMBO_OPTION = '/RELOAD';
{$ifndef DLL}
	RST_FORMATO_DESCRIZIONE : array[succ(RST_BLANK)..high(runtime_script_type)] of string = (
		'assegnazione valore a variabile',			// RST_SETVALUE
		'ricarica valori di una combobox'			// RST_RELOAD_COMBO
	);
	RST_FORMATO_HELP : array[succ(RST_BLANK)..high(runtime_script_type)] of string = (
		RST_SET_VALUE_OPTION + '(nomeparametro)=',		// RST_SETVALUE
		RST_RELOAD_COMBO_OPTION + '(nomeparametro)'		// RST_RELOAD_COMBO
	);
{$endif DLL}

	RSE_WC_EXT = '_WC';
	RSE_ON_UPDATE_TEXT = '/ON_UPDATE';
	RSE_ON_CLOSEUP_TEXT = '/ON_CLOSEUP';
	RSE_ON_CLOSEUP_WC_TEXT = RSE_ON_CLOSEUP_TEXT + RSE_WC_EXT;
	RSE_ON_EXIT_TEXT = '/ON_EXIT';
	RSE_ON_EXIT_WC_TEXT = RSE_ON_EXIT_TEXT + RSE_WC_EXT;
	RSE_ON_ENTER_TEXT = '/ON_ENTER';

	// --------------------------------------------------------------------------

type
	cl_label = class(TFLabel)
		public
			{$ifdef DEBUG} font : array of integer; {$endif}
			ca : cl_common_attributes;
			bo_giustificato : boolean;
			// caratteristiche specifiche dell'oggetto
			round_method : ROUND_TYPES;
		private
			i_cifre_round_phisical : shortint;							// approssima a 10 elevato a i_cifre_round -- vale RND_ROUND_FORMULA se è applicato STR_ROUND_FORMULA
			function get_cifre_round : shortint;
		public
			str_round_formula : string;						// FORMULA che determina il valore di I_CIFRE_ROUND
			property xi_cifre_round : shortint read get_cifre_round {$ifdef GALATEO_EXE} write i_cifre_round_phisical {$endif};
		public
			i_decimali_fissi : shortint;						// numero di cifre decimali stampate comunque -- vale DECIMALI_NON_ASSEGNATI se viene usata la formula
			i_zeri : shortint;									// # minimo di cifre alla sinistra della virgola -- vale DECIMALI_NON_ASSEGNATI se viene usata la formula
			str_decimali_fissi_formula, str_zeri_formula : string;		// FORMULA che determina il valore di I_DECIMALI_FISSI e I_ZERI
			fnt_formato_numerico : FORMATO_NUMERICO_TYPES;
			bo_valore_progressivo : boolean;					// continua a sommare i valori della variabile
			bo_show_segno : boolean;							// mostra il segno anche per valori numerici positivi
			bo_simbolo_valuta, bo_simbolo_valuta_sx : boolean;
			str_simbolo_valuta : string;
			criterio_ricalcolo : recalculate_type;
			bo_centrato, bo_blank_if_zero : boolean;
			bo_PDF_modificabile : boolean;
			bo_multiline : boolean;								// TRUE se la scritta può andare su più righe
			fl_cm_interlinea : misura_real_type;			// altezza dell'interlinea; 0 per default
			fl_max_vertical_size_cm : misura_real_type;	// dimensione verticale se multiline; 0 per default (no limits) -- dalla ver $0333
			i_max_rows : byte;									// numero max di righe in cui l'oggetto può essere spezzato
			bo_suppress_blank : boolean;						// suppress blank controls
//			bo_insert_line_if_multiline : boolean;			// sposta gli oggetti sottostanti se multiline
			bo_riduci_if_necessario : boolean;				// prova a ridurre il font se il campo è troppo stretto
			i_minimum_size_auto : byte;						// dimensione minima di riduzione automatica
			bo_forza_font_bold, bo_forza_font_italic, bo_forza_font_underlined, bo_forza_font_strikeout : boolean;
			charcase : TEditCharCase;							// stampa il testo maiuscolo/minuscolo
			bo_switch_fontstyle : boolean;					// cambiamento dello style del font 'on the fly'
			str_usa_formato_valuta : string;					// l'oggetto usa il formato di valuta indicato
			str_datetime_format : string;						// formato utilizzato per la formattazione dei DATETIMEs
			round_valuta : round_valuta_type;				// tipo di arrotondamento per la valuta indicata
			round_valuta_min : round_valuta_type;			// numero minimo di decimali da stampare
			bo_usa_simbolo_valuta_breve : boolean;
			lo_color : TColor;									// colore dell'oggetto; serve per quando è grigio perchè non visibile
			lo_background_color : TColor;						// applicabile se NOT TRANSPARENT
			bo_trasparente : boolean;							// sovrascrive la property TRANSPARENT, che però è usata in fase di editing per certi effetti
			bo_autoheight : boolean;							// auto resize della dimensione verticale (if not autosize)
			str_ID_lingua : string;								// IDentificatore in lingua per la traduzione automatica
			validazione : cl_validazione;
			comportamento_when_null : comportamento_when_null_type;
			str_value_when_null : string;
		public
			str_LCF_condizione : string;
			box_LCF_bold, box_LCF_underline, box_LCF_italic, box_LCF_strikeout : xboolean;
			LCF_foreground_color, LCF_background_color : TColor;
			procedure apply_font_condizionale(f : TFont);
		public
			bo_ask_runtime : boolean;					// chiede il valore a runtime (solo per parametri, of course)
//			{$ifndef DEBUG} *** {valuta eliminazione XSTR_RUNTIME_CAPTION} {$endif}
			str_runtime_question, xstr_runtime_caption : string;	// testo e caption della domanda da porre a runtime
			str_runtime_format : string;				// formato obbligatorio in input del parametro runtime
			// se TRUE STR_RUNTIME_ANSWERS e STR_RUNTIME_VALUES contengono istruzioni SQL di selezione dati e risposte
			rtq : RTQ_type;
			bo_SQL_load_runtime_values : boolean;
			bo_SQL_runtime_parm_debug : boolean;	// esegue il debug delle espressioni SQL utilizzate per i parametri runtime
			str_runtime_answers : string;				// possibili valori di risposta (in Combobox), separati da ACAPO
			str_runtime_values : string;				// codici corrispondenti ai valori di risposta, separati da ACAPO
			bo_runtime_answer_can_be_blank : boolean;
			str_runtime_blank_answer : string;
			bo_runtime_answer_in_valori_suggeriti : boolean;
			bo_RTQ_select_all_answers : boolean;	// opzione valida solo per i runtime-parameters multiselect
			RTQ_apix : APIX_type;						// per runtime-multiselect parms: come deve essere formattata la stringa restituita
			str_runtime_ask_if : string;				// la runtime-question viene posta se la condizione indicata è TRUE
			str_runtime_enable_if : string;			// la runtime-question è ENABLED se la condizione indicata è TRUE
			i_runtime_groupbox : smallint;			// GROUPBOX cui l'oggetto appartiene (indice 0-based)
			lo_runtime_text_color, lo_runtime_back_color : TColor;
			str_runtime_hint : string;
			runtime_tipodato : runtime_tipodato_type;
			str_runtime_path, str_runtime_filename_filter : string;					// stringa base di ricerca parametro
			i_runtime_max_lines : smallint;			// vale 1 se TEdit, >1 se TMemo, irrilevante in altre circostanze
			i_runtime_min_length : smallint;			// valore usato per validare il campo
			i_runtime_max_length : smallint;			// valore MaxLength per il control di tipo text
			str_runtime_scripts : string;				// opzioni e script per l'esecuzione runtime
		public
			expint : array of cl_expint_object;
			function ZB_get_running_export_type(i_profilo : expint_index_type;i_logical_page_ZB : logical_page_type) : object_expint_mode_type;
			function ZB_get_integral_exportable(i_profilo : expint_index_type;i_logical_page_ZB : logical_page_type;bo_visible : boolean = TRUE) : boolean;
//			function ZB_get_runtime_integral_exportable(i_profilo : expint_index_type;i_logical_page_ZB : logical_page_type;bo_visible : boolean = TRUE) : boolean;
			function get_expint_object(i_profilo : expint_index_type = -1) : cl_expint_object;
		public
			bo_runtime_default_is_SQL : boolean;			// il testo default è un'istruzione SQL
			bo_runtime_default_is_formula : boolean;		// il testo default è una formula
			str_runtime_default_phisical, str_runtime_default_debug_phisical : string;		// usare quando possibile la funzione GET_RUNTIME_DEFAULT()
			function get_runtime_default : string;		// valore nudo e crudo del default, non tradotto nè interpretato (cosa che deve avvenire in funzione del contesto)
			{$ifndef DLL} function check_runtime_if(handle : hwnd;str_condizione : string) : boolean; {$endif}
			function valuta_runtime_if(handle : hwnd;str_condizione : string) : boolean;
			function get_runtime_caption : string;
		public
			bo_store_variabile : boolean;
			bo_nome_variabile_SQL : boolean;	// TRUE se il nome della variabile deve essere generato attraverso un comando SQL
			str_nome_variabile_store : string;
			store_operation : STORE_OPERATION_TYPE;
			procedure store_value;
		public
			constructor xcreate(form : TForm;ca : cl_common_attributes;i_section_1B : section_index_type;i_obj : obj_index_type;bo_init_default : boolean); overload;
			{$ifndef DLL} constructor xcreate(form : TForm;lab : cl_label); overload; {$endif}		// costruttore di copia
			procedure free;		// fino a 2011-05-10
//			destructor destroy; override;
			procedure init_expint;
			function applica_formato_numerico : string;
{$ifdef CASA}
			procedure assign_formatted_numeric_print_value(lp : LPSTR);
{$endif CASA}
{$ifdef GALATEO_EXE}
			procedure applica_style(obj_from : {objs_type} pointer;wo_style : word);
			function assign(lab : cl_label) : cl_label; reintroduce;		// esegue SELF := LAB; rende SELF
			procedure assign_inherited_field(lab : TFlabel);
			function edit_font(father : TForm;bo_tratta : boolean) : boolean;
			procedure esc;
			procedure edit_object;
			function save(var f : text;xref : reference_obj) : boolean;
			procedure select(bo_select : boolean);
{$endif GALATEO_EXE}
			function load(var f : text;xref : reference_obj;tipo_variabile : variabile_type;wo_versione : word) : boolean;
			function get_x_left_virtuale(x_left : int_pixel_type) : int_pixel_type;
			{$ifndef DLL} function get_y_top_virtuale(y_top : int_pixel_type) : int_pixel_type; {$endif}
			procedure verify_height;
		private
			father : TForm;
{$ifdef GALATEO_EXE}
			pbox : TGalPaintBox;
//			procedure WMKeyDown(var Message: TWMKey); message WM_KEYDOWN;
//			procedure WMKeyUp(var Message: TWMKey); message WM_KEYUP;
			procedure WMLButtonDown(var Message: TWMLButtonDOWN); message WM_LBUTTONDOWN;
			procedure WMLButtonDblclk(var Message: TWMLButtonDBLCLK); message WM_LBUTTONDBLCLK;
			procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
			procedure WMMousemove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
			procedure WMRButtonDown(var Message: TWMRButtonDOWN); message WM_RBUTTONDOWN;
			procedure WMmove(var Message: TWMMove); message WM_MOVE;
{$endif GALATEO_EXE}
		private		// FORMULE e relative impostazioni
			dbl_print_value_phisical : double;		// valore numerico assegnato all'oggetto; NULL_VALUE se non numerico o non assegnato
			str_formatted_print : string;				// ultimo valore formattato per la stampa; serve solo per evitare ricorsioni
			function get_print_value : string;
			procedure set_print_value(s : string);
			function get_numeric_print_value : double;
			procedure set_numeric_print_value(dbl : double);
			function get_tag : integer;
			procedure set_tag(lo_tag : integer);
		public
			bo_null : boolean;		// (2016-07-02) TRUE se il valore SQL è NULL; si applica solo ad alcuni tipi di oggetti (GESTIONE_NULL_TIPOVARS); per default vale FALSE; vedi anche COMPORTAMENTO_WHEN_NULL
			property tag : integer read get_tag write set_tag;
			procedure clear_print_value;
			procedure reset_print_value;
			property str_print : string read get_print_value write set_print_value;
			property xdbl_print_value : double read get_numeric_print_value write set_numeric_print_value;
{$ifdef CASA}
			function print(vcanvas, pcanvas : TCanvas;x0,y0 : int_pixel_type;bo_video : boolean;
				ptcr : pTRect;var i_delta_y : int_pixel_type;var i_max_y_pixel : int_pixel_type;
				i_delta_y_bottom,i_margine_y_pixel : int_pixel_type;
				i_font_ridotto_size : smallint;bo_can_break_object : boolean;
				i_ph_first_page_section,i_ph_last_page_section : ph_page_type;ptr_print_section : {cl_print_section}pointer = NIL) : boolean;
{$else}
			procedure set_show_state(show : show_types);
{$endif CASA}
	end;

{$ifdef GALATEO_EXE}
	function runtime_scripts_validate(father : TForm; lab : cl_label;str_runtime_scripts : string) : boolean;
{$endif GALATEO_EXE}

function tratta_formula({i_section : section_index_type;}pt_obj : {objs_type}pointer;str_formula : string;tipo_res : risultato_type = VAL_BOH) : string;

implementation

//***************************************************************************************************************/

uses Fassert, Fdebug, FErrMsg, FSQLsoft, FMessage, FProcs, FSystem_base, FSystem,
	{$ifdef DEBUG} Fdata, Ftime, {$endif}
	{$ifndef DLL} galateo_main, label_edit, {$endif}
	{$ifdef CASA} gun, {$endif CASA}	// dal 2025-04-07
	galateo_debug, proc, misure, sezione, pages, functions, objects,
	printers_DX;	// printers_DX aggiunta 2012-09-24

const
	MAX_FATTORE_FORMATTAZIONE = 32;

{$ifdef DEBUG}
	var
		i_labels : integer;
		i_old, i_new : int64;
{$endif}

constructor cl_label.xcreate(form : TForm;ca : cl_common_attributes;i_section_1B : section_index_type;i_obj : obj_index_type;bo_init_default : boolean);
begin
//	general_runtime_parent := NIL; {$ifndef DEBUG} *** {$endif}
	inherited create({$ifdef DLL}general_runtime_parent{$else}panels_ZB(i_section_1B - 1){$endif});
	init_expint;
	validazione := cl_validazione.create;

	{$ifdef DEBUG} inc(i_labels); {$endif}
//	self.i_numero_obj := i_obj;
//	ca := cl_common_attributes.create(i_section);
	{$ifdef DEBUG} assert(ca <> NIL, 'CA is NIL'); {$endif}
	self.ca := ca;
	ca.tipo_oggetto := LABEL_OBJ;
	self.father := form;
	ca.i_section_1B := i_section_1B;
{$ifdef DLL}
	parent := general_runtime_parent;
{$else}
	parent := panels_ZB(i_section_1B - 1);	// necesse est
	pbox := panels_ZB(i_section_1B - 1).pbox;
{$endif DLL}
//	inherited create(panels(i_section));
//	self.tipo_oggetto := tipo_oggetto;
	bo_autoheight := TRUE;
	inc(lo_creation);
	tag := get_new_tag;
	showhint := TRUE;
	ParentFont := FALSE;
	cursor := DEFAULT_CURSOR_OBJECTS;
	bo_null := FALSE;		// FALSE perchè si applica solamente a certi tipi di oggetti (GESTIONE_NULL_TIPOVARS)
	comportamento_when_null := low(comportamento_when_null_type);str_value_when_null := '';
//	lp_print := NIL;lp_print_left := NIL;
	strcpychk(ca.lp_print, '');
//	bo_SQL_value_assigned := FALSE;bo_formatted_print := FALSE;
	dbl_print_value_phisical := xNUMERIC_NULL_VALUE;
	ca.tipo_valore := VAL_TESTO;
	round_method := RND_NEAREST;
//	bo_centrato := FALSE;bo_blank_if_zero := FALSE;
	fnt_formato_numerico := FORMATO_NUMERICO_DEFAULT;
//	bo_multiline := FALSE;bo_suppress_blank := FALSE;
//	bo_insert_line_if_multiline := TRUE;
	ca.bo_move_obj_sottostanti := TRUE;
//	bo_riduci_if_necessario := FALSE;bo_ask_runtime := FALSE;
	i_minimum_size_auto := DEFAULT_MINIMUM_SIZE_AUTO;
//	show := OSW_SHOW;
	charcase := ecNormal;
	transparent := TRUE;bo_trasparente := TRUE;
	lo_runtime_text_color := RUNTIME_UNASSIGNED_COLOR;lo_runtime_back_color := RUNTIME_UNASSIGNED_COLOR;
	i_runtime_groupbox := 0;
	{$ifndef DLL} ExternalFillColor := $00B0FFFF; {$endif}		// giallino tenero

	str_LCF_condizione := '';LCF_foreground_color := 0;LCF_background_color := 0;
	box_LCF_bold := XNOTHING;box_LCF_underline := XNOTHING;box_LCF_italic := XNOTHING;box_LCF_strikeout := XNOTHING;

	if bo_init_default then begin
{$ifdef GALATEO_EXE}
		ca.tipo_variabile := TV_STATIC_TEXT;
		left := (lo_creation * 30) mod pbox.Width div 3 * 2;
		top := (lo_creation * 30) mod pbox.Height div 3 * 2;
{		case tipo_oggetto of	*** così fino al 2011-05-19, ma l'assegnazione non è rilevante (credo)
			xxxTESTO : caption := 'testo';
			xxxVARIABILE : caption := 'variabile';
			xxxFORMULA : caption := 'formula'
		end; }
		caption := 'testo';		// dal 2011-05-19 generico così per tutti
//			if globale.bo_text_only then Font.assign(globale.Text_only_font) else Font.assign(sections(i_section).font_default);
		if globale.bo_text_only then assign_font(globale.Text_only_font, 0, 0)
		else assign_font(sections_ZB(i_section_1B - 1).font_default, 0, 0);

		case ca.tipo_valore of
			VAL_TESTO : ca.str_esempio_value := 'ABC';
			VAL_NUMERO : ca.str_esempio_value := '13';
			else begin
				{$ifdef DEBUG} assert(FALSE,'TIPO di valore non trattato in create()'); {$endif}
				ca.str_esempio_value := '13'
			end
		end;
{$endif GALATEO_EXE}
		caption := create_name(caption, FALSE)
	end;
	rebuild_font;
	paint
end;

{$ifdef GALATEO_EXE}
	constructor cl_label.xcreate(form : TForm;lab : cl_label);
	begin
		inherited create(form);
		{$ifdef DEBUG} inc(i_labels); {$endif}
		init_expint;
		validazione := cl_validazione.create;
		ca := cl_common_attributes.create(lab.ca.i_logical_page_ZB, lab.ca.i_section_1B, {external_owned}FALSE);
//		self.ca := ca;		// la struttura CA è sempre ESTERNA
//		ca.tipo_oggetto := LABEL_OBJ;
		assign(lab)
	end;
{$endif GALATEO_EXE}

procedure cl_label.init_expint;
begin
	setLength(expint, max(expint_profiles_count, 1));		// almeno 1 viene creato sempre
	for var i : expint_index_type := 0 to high(expint) do
		if (expint[i] = NIL) then expint[i] := cl_expint_object.create
end;

procedure cl_label.free;
begin
	{$ifdef DEBUG} dec(i_labels); {$endif}
	{$ifdef GALATEO_EXE} if (ca <> NIL) AND NOT ca.bo_external_owned then begin ca.free;ca := NIL end; {$endif}
	if (parent <> NIL) then parent.removecontrol(self);
//	Visible := FALSE;		{$ifNdef DEBUG} *** {necessario?} {$endif}
//	strdispose(lp_print);strdispose(lp_print_left);

	for var i : expint_index_type := 0 to high(expint) do expint[i].free;
	expint := NIL;
	{$ifdef DEBUG} assert(validazione <> NIL, 'cl_label.free validazione == NIL -- TPPX 4994'); {$endif}
	validazione.free;validazione := NIL;
	inherited free		// dal 2011-05-10, prima non c'era (ma era sbagliato)
end;	

procedure cl_label.verify_height;
// sistemo l'altezza dell'oggetto; REQUIRED anche if DLL !!!!!!
begin
	if NOT autosize AND bo_autoheight then begin
		var i : int_pixel_type := width;var j : int_pixel_type := left;
		autosize := TRUE;autosize := FALSE;
		width := i;left := j
	end
end;

{$ifdef GALATEO_EXE}

	procedure cl_label.select(bo_select : boolean);
	begin
		if (bo_select = ca.bo_selected) then exit;	// non cambia nulla
		if bo_select AND (width >= pbox.Width) AND (ca.show <> OSW_HIDE) then begin
			MessageBBox(father.handle, 'Oggetto troppo grande per l''attuale formato di visualizzazione.' + ACAPO2 +
				'Lo riduco alla massima dimensione accettabile.', MBOX_CAPTION, MB_ICONSTOP);
			Autosize := TRUE;Left := 1;
//			while (width > 0) AND (width >= pbox.Width) do font.size := font.size-1
			var i_loop : smallint := 30;	// per limitare il loop, che può bloccarsi se oggetto grande su report piccolissimo (esempio: etichette)
			while (Width > 0) AND (Width >= pbox.Width) AND (FontSize > 1) AND (i_loop > 0) do begin Fontsize := Fontsize - 1;dec(i_loop) end
		end;

//		var lo_temp : TColor := Color;Color := Fontcolor;Fontcolor := lo_temp;
		FontColor := reverse_color(FontColor);
		Transparent := bo_trasparente AND NOT bo_select;
//		if NOT bo_select AND NOT bo_trasparente then Color := lo_background_color;
		ExternalFill := bo_select;
		ExternalBorderWidth := byte((Angle <> 0) AND bo_select);
//		FExternalBorderColor := clGray;
		ca.bo_selected := bo_select
	end;

	procedure cl_label.WMLButtonDown(var Message: TWMLButtonDown);
	begin
		var i_obj : obj_index_type := get_related_obj([],ca.i_section_1B, message.xpos+left, message.ypos+top, FALSE, TRUE);
		{$ifdef DEBUG} assert(i_obj <> 0, 'ORPOLETTA 987'); {$endif}
		select_checking_keys(i_obj)
	end;

	procedure cl_label.WMRButtonDown(var Message: TWMRButtonDown);
	begin
		var i_obj : obj_index_type := get_related_obj([], ca.i_section_1B, message.xpos + left, message.ypos + top, FALSE, TRUE);
		{$ifdef DEBUG} assert(i_obj <> 0, 'ORPOLETTA 986'); {$endif}
		if NOT is_selected(i_obj) then select_checking_keys(i_obj);
		var p : TPoint := ClientToScreen(Point(message.xpos, message.ypos));
		GM.popup_object.popup(p.x, p.y)
	end;

//	procedure cl_label.WMKeyDown(var Message: TWMKey); begin message.result := 0 end;
//	procedure cl_label.WMKeyUp(var Message: TWMKey); begin message.result := 0 end;
	procedure cl_label.WMLButtonDblclk(var Message: TWMLButtonDBLCLK); begin edit_object end;
	procedure cl_label.WMLButtonUp(var Message: TWMLButtonUp); begin dd.dragging_mouse_up end;
	procedure cl_label.WMMousemove(var Message: TWMMouseMove); begin dd.dragging_Mousemove(self, message.xpos + left, message.ypos + top) end;

	procedure cl_label.applica_style(obj_from : {objs_type}pointer;wo_style : word);
	begin
		var objf : objs_type := objs_type(obj_from);
		if (wo_style = STYLE_ALL) then wo_style := LABEL_STYLES;

		var lab : cl_label := objf.aslabel;
{		if (wo_style AND xSTYLE_SIZE <> 0) then begin
			dec(wo_style,STYLE_SIZE);
			autosize := FALSE;height := objf.get_height;width := objf.get_width
		end; }

{		if (wo_style AND xSTYLE_LEGAMI_COMUNITARI <> 0) then begin
			dec(wo_style,xSTYLE_LEGAMI_COMUNITARI);
			obj_dest.xref.str_vert := objf.xref.str_vert;
			obj_dest.xref.str_horz := objf.xref.str_horz;
			obj_dest.xref.str_pos := objf.xref.str_pos
		end; }

		if (wo_style AND STYLE_FONT <> 0) then begin
			dec(wo_style, STYLE_FONT);
			if (objf.ca.tipo_oggetto = LABEL_OBJ) then begin
//				font.assign(lab.font);
				assign_font(lab);
//				font.Color := lab.font.Color;
//				fontcolor := lab.fontcolor;
				lo_color := fontcolor;
				lo_background_color := lab.lo_background_color;
				bo_trasparente := lab.bo_trasparente;
				bo_forza_font_bold := lab.bo_forza_font_bold;
				bo_forza_font_italic := lab.bo_forza_font_italic;
				bo_forza_font_underlined := lab.bo_forza_font_underlined;
				bo_forza_font_strikeout := lab.bo_forza_font_strikeout;
				if NOT autosize AND bo_autoheight then verify_height;

				str_LCF_condizione := lab.str_LCF_condizione;
				box_LCF_bold := lab.box_LCF_bold;
				box_LCF_underline := lab.box_LCF_underline;
				box_LCF_italic := lab.box_LCF_italic;
				box_LCF_strikeout := lab.box_LCF_strikeout;
				LCF_foreground_color := lab.LCF_foreground_color;LCF_background_color := lab.LCF_background_color
			end
		end;

		if (wo_style AND STYLE_FONTNAME <> 0) then begin
			dec(wo_style, STYLE_FONTNAME);
			if (objf.ca.tipo_oggetto = LABEL_OBJ) then FontName := lab.FontName
		end;

		if (wo_style AND STYLE_FONTSIZE <> 0) then begin
			dec(wo_style, STYLE_FONTSIZE);
			if (objf.ca.tipo_oggetto = LABEL_OBJ) then fontsize := lab.FontSize
		end;

		if (wo_style AND STYLE_FONTCOLOR <> 0) then begin
			dec(wo_style, STYLE_FONTCOLOR);
			if (objf.ca.tipo_oggetto = LABEL_OBJ) then begin
				lo_color := lab.FontColor;
				FontColor := lab.Fontcolor
			end
		end;

		if (wo_style AND STYLE_FORMATO_NUMERICO <> 0) then begin
			dec(wo_style,STYLE_FORMATO_NUMERICO);
			if (objf.ca.tipo_oggetto = LABEL_OBJ) then begin
				bo_blank_if_zero := lab.bo_blank_if_zero;
				str_usa_formato_valuta := lab.str_usa_formato_valuta;
				round_valuta := lab.round_valuta;
				round_valuta_min := lab.round_valuta_min;
				bo_usa_simbolo_valuta_breve := lab.bo_usa_simbolo_valuta_breve;
				i_cifre_round_phisical := lab.i_cifre_round_phisical;str_round_formula := lab.str_round_formula;
				i_decimali_fissi := lab.i_decimali_fissi;i_zeri := lab.i_zeri;
				str_decimali_fissi_formula := lab.str_decimali_fissi_formula;str_zeri_formula := lab.str_zeri_formula;
				round_method := lab.round_method;
				fnt_formato_numerico := lab.fnt_formato_numerico;
				bo_show_segno := lab.bo_show_segno;
				bo_simbolo_valuta := lab.bo_simbolo_valuta;
				bo_simbolo_valuta_sx := lab.bo_simbolo_valuta_sx;
				str_simbolo_valuta := lab.str_simbolo_valuta
			end
		end;

		if (wo_style AND STYLE_FORMATTATION <> 0) then begin
			dec(wo_style, STYLE_FORMATTATION);
			if (objf.ca.tipo_oggetto = LABEL_OBJ) then begin
				alignment := lab.alignment;bo_giustificato := lab.bo_giustificato;
				str_datetime_format := lab.str_datetime_format;
				bo_centrato := lab.bo_centrato;
				bo_switch_fontstyle := lab.bo_switch_fontstyle;
				bo_blank_if_zero := lab.bo_blank_if_zero;
				ca.show := lab.ca.show;
//				font.Color := lab.font.Color;
//				fontcolor := lab.fontcolor;
//				lo_color := lab.lo_color;lo_background_color := lab.lo_background_color;bo_trasparente := lab.bo_trasparente;
				bo_autoheight := lab.bo_autoheight;
				bo_multiline := lab.bo_multiline;
				fl_cm_interlinea := lab.fl_cm_interlinea;
				fl_max_vertical_size_cm := lab.fl_max_vertical_size_cm;
				i_max_rows := lab.i_max_rows;
				bo_riduci_if_necessario := lab.bo_riduci_if_necessario;
				i_minimum_size_auto := lab.i_minimum_size_auto;
				ca.assign_valori_formattazione(lab.ca);
				bo_suppress_blank := lab.bo_suppress_blank;
//				bo_insert_line_if_multiline := lab.bo_insert_line_if_multiline
			end
		end;

		if (wo_style AND STYLE_VALUES <> 0) then begin
			{$ifdef DEBUG} dec(wo_style, STYLE_VALUES); {$endif}
			if (objf.ca.tipo_oggetto = LABEL_OBJ) then begin
				ca.str_formula := lab.ca.str_formula;
				ca.tipo_valore := lab.ca.tipo_valore;
				ca.tipo_variabile := lab.ca.tipo_variabile;
				ca.str_SQL_expression := lab.ca.str_SQL_expression;
				ca.str_esempio_value := lab.ca.str_esempio_value
			end
		end;

		{$ifdef DEBUG} assert(wo_style = 0,'cl_label.applica_style()') {$endif}
	end;

	function cl_label.save(var f : text;xref : reference_obj) : boolean;
	// salva l'oggetto; rende TRUE in caso di successo
	var i : smallint;
	begin
		try
			writeln(f, Caption);
			writeln(f, video2cm_x(left):0:3, ' ', video2cm_y(top):0:3, ' ', video2cm_x(width):0:3);
//			writeln_LPSTR(f, str_formula);		// fino a 2011-05-20, versione $0260
			writeln(f, FontName);
//			writeln(f, font.Color, ' ', font.size);
			writeln(f, lo_color, ' ', fontsize);	// dal 1999-07-23
			// lettere usate: A..O (P) Q..Z 1..9 a..n p..z ! ~ $ # @ + * : &
			// free £

//			if (fsBold in font.style) then write(f,'B');
			if (fontWeight > LFW_NORMAL) then write(f, 'B');
//			if (fsItalic in font.style) then write(f,'I');
			if Italic then write(f, 'I');
//			if (fsUnderline in font.style) then write(f,'U');
			if Underline then write(f, 'U');
//			if (fsStrikeout in font.style) then write(f,'S');
			if Strikeout then write(f, 'S');
			if autosize then write(f, 'A') else write(f, 'F');
			if NOT bo_autoheight then write(f, 'n');
			if bo_blank_if_zero then write(f, 'D');
			case fnt_formato_numerico of
				PD: write(f, 'a');
				VD: write(f, 'b');
				PM_VD: write(f, 'c');
				VM_PD: write(f, 'd')
			end;
			if bo_simbolo_valuta then write(f, 'f');
			if bo_simbolo_valuta_sx then write(f, 'g');
			if bo_show_segno then write(f, 'm');
			if (str_simbolo_valuta <> '') then write(f, '~', str_simbolo_valuta, '~');
			if bo_centrato then write(f, 'C');
			if bo_switch_fontstyle then write(f, 'w');
			if bo_multiline then write(f, 'M');
			if bo_riduci_if_necessario then begin
				write(f, 'R');	// versioni vecchie
				write(f, 'G', i_minimum_size_auto, ' ')
			end;
			if (criterio_ricalcolo <> REC_DEFAULT) then write(f, '*', byte(criterio_ricalcolo));
			if bo_suppress_blank then write(f, 'K');
//			if (NOT bo_insert_line_if_multiline) then write(f, 'L');		sostituito da ca.BO_MOVE_OBJ_SOTTOSTANTI
			if bo_ask_runtime then begin
				write(f, 'Q');
				write(f, 'x', byte(rtq));
				if bo_RTQ_select_all_answers then write(f, '!');
				if bo_SQL_load_runtime_values then write(f, 'y');
				if bo_SQL_runtime_parm_debug then write(f, 'p');
				write(f, '"', zeri(byte(RTQ_apix), 2))
			end;
			if bo_PDF_modificabile then write(f, ':');
			if NOT bo_trasparente then write(f, '&');	// dalla versione $0404, 2021-03-15

{			if (tipo_oggetto = xxVARIABILE) then begin	// ****** fino 2011-05-17
				case tipovar of
//					TV_BLANK : ;
					TV_VARIABILE : write(f,'V');
					TV_PARAMETRO : write(f,'W');
					TV_GROUP_EXPR_SQL : write(f,'J');
					TV_SQL_SELECT_BEFORE_SQL : write(f,'z');
					TV_SQL_SELECT_BEFORE_RUNTIME : write(f,'@');
					TV_SQL_SELECT : write(f,'E')
				end
			end; }
			write(f, 'V', char(ord('A') - 1 + byte(ca.tipo_variabile)));		// dal 2011-05-17: scrivo SEMPRE il tipo di variabile

//			write(f, OSW_FILE_ID[show]);		// meglio, ma non ne vale tanto la pena
{			case show of
				OSW_SHOW: ;
				OSW_HIDE: write(f,'H');
				OSW_SHOW_1: write(f,'1');
				OSW_SHOW_LAST: write(f,'9');
				OSW_HIDE_1: write(f,'2');
				OSW_HIDE_LAST: write(f,'8');
				OSW_SHOW_SOR: write(f,'3');
				OSW_HIDE_SOR: write(f,'4');
				OSW_SHOW_EOR: write(f,'5');
				OSW_HIDE_EOR: write(f,'6');
				OSW_SHOW_1REC : write(f,'7');
				OSW_HIDE_1REC : write(f,'v')
			end; }

			case alignment of
				TaLeftJustify : write(f,'X');
				TaCenter : write(f,'Y');
				TaRightJustify : write(f,'Z')
			end;
			if bo_giustificato then write(f,'T');

			case charcase of
				ecLowerCase : write(f,'N');
				ecNormal: ;
				ecUpperCase: write(f,'O')
			end;

			if bo_valore_progressivo then write(f, 'h');
			if (byte(round_valuta) <> 0) then write(f, 'r', char(byte(round_valuta) + byte('0')));
			if (byte(round_valuta_min) <> 0) then write(f, 's', char(byte(round_valuta_min) + byte('0')));
			if bo_usa_simbolo_valuta_breve then write(f, 't');

			if bo_runtime_answer_can_be_blank then write(f, 'i');
			if bo_runtime_answer_in_valori_suggeriti then write(f, 'j');
//			if bo_set_parm_esempio_runtime then write(f, 'k');
			if bo_runtime_default_is_SQL then write(f, 'l');
			if bo_runtime_default_is_formula then write(f, '+');
//			if bo_set_parm_esempio_runtime then write(f,'q');
//			if bo_set_runtime_default_SSD then write(f,'u');
//			if NOT bo_log_query_sql then write(f,'e');
			case runtime_tipodato of
				RTT_TEXT : ;
				RTT_DATA : write(f,'$');
				RTT_FILENAME : write(f,'#');
				{$ifdef DEBUG} else assert(FALSE, 'runtime_tipodato -- JHSE 9921') {$endif}
			end;

			writeln(f);

			writeln(f, {byte(tipo_valore),' ',} byte(round_method), ' ', i_cifre_round_phisical, ' ', i_decimali_fissi, ' ', i_zeri,
				' #', str_round_formula, '#', str_decimali_fissi_formula, '#', str_zeri_formula);	// STR_DECIMALI_FISSI_FORMULA e STR_ZERI_FORMULA dalla versione $0409 2022-10-25
//			writeln_LPSTR(f, str_db_colonna);
//			writeln(f, ifs(tipo_oggetto <> xTESTO, str_esempio_value));	*** fino al 2011-05-17
//			writeln(f, ifs(tipovar <> TV_STATIC_TEXT, str_esempio_value));	*** fino al 2011-05-21
			xref.save(f);
//			writeln(f, str_hints);
			if NOT ca.save(f) then abort;
			// da versione $0211 in poi
			writeln_LPSTR(f, str_runtime_question);
//			writeln(f, fl_cm_interlinea:0:3);	// versione $212
			writeln(f, fl_cm_interlinea:0:4);	// versione $212
			writeln(f, str_usa_formato_valuta);
			writeln_LPSTR(f, str_runtime_answers);
			writeln_LPSTR(f, str_runtime_values);
			writeln(f, str_runtime_blank_answer);
			writeln(f, str_runtime_ask_if);
			writeln(f, str_runtime_format);
			writeln_LPSTR(f, xstr_runtime_caption);
			writeln(f, bool2SQL(bo_store_variabile), bool2SQL(bo_nome_variabile_SQL), str_nome_variabile_store);
			writeln(f, byte(store_operation));
//			writeln_LPSTR(f, str_remarks);
			writeln(f, i_runtime_groupbox, ' ', lo_runtime_text_color, ' ', lo_runtime_back_color, ' ', i_runtime_max_lines, ' ', i_runtime_max_length);
			writeln_LPSTR(f, str_runtime_hint);
			writeln(f, str_runtime_enable_if);
			writeln(f, {byte(editing_type), ' ', i_pos, ' ', i_skip_cols_before, byte(multiline):2, ' ',}
				i_runtime_min_length, ' ', fl_max_vertical_size_cm:0:3, ' ', i_max_rows, ' 0 0 0 0 0 0 0 0 0 0 0 0');		// fl_max_vertical_size, i_max_rows: dalla ver $0333
//			writeln(f, str_header);
//			for i := 1 to length(str_acapo) do write(f, ' ', byte(str_acapo[i]));writeln(f);
//			writeln(f, translate_string2hex(xstr_acapo));
//			writeln(f, translate_string2hex(str_tab));
			writeln(f, byte(bo_forza_font_bold), byte(bo_forza_font_italic):2, byte(bo_forza_font_underlined):2, byte(bo_forza_font_strikeout):2,
				angle mod 360:5, FontOrientation mod 360:5, ' ', lo_background_color, ' 0 0 0 0 0 0 0 0');	// LO_BACKGROUND_COLOR da $0404
			writeln(f, str_datetime_format);
			writeln(f, str_runtime_path);
			writeln(f, str_runtime_filename_filter);
			writeln_LPSTR(f, str_runtime_scripts);
			writeln_LPSTR(f, str_runtime_default_phisical);
			writeln_LPSTR(f, str_runtime_default_debug_phisical);

			writeln(f, str_LCF_condizione);
			writeln(f, byte(box_LCF_bold):2, byte(box_LCF_underline):2, byte(box_LCF_italic):2, byte(box_LCF_strikeout):2, ' ',			// dalla versione $030E
				LCF_foreground_color, ' ', LCF_background_color, ' 0 0 0 0 0 0 0 0 0 0');

			writeln(f, str_ID_lingua);
			writeln_LPSTR(f, validazione.AsString);
			writeln(f, byte(comportamento_when_null), str_value_when_null);
			for i := 1 to 4 do writeln(f);
			result := TRUE
		except
			result := FALSE;
			error_msg(father, 'Errore durante la scrittura del file', MBOX_CAPTION);
			abort
		end
	end;

	procedure cl_label.edit_object;
	begin
//		i_numero_obj := tag2index(tag);
//		var bo_was_selected := (get_selected_obj_index(0) = ca.i_numero_obj);
//		if bo_was_selected then obj_select(0, FALSE, FALSE);
		edit_label_proc(father, self, ca.i_numero_obj);
//		left := get_x_left_virtuale(left);		*** aveva un senso quando il DIALOG era MODAL, adesso non ha significato pratico
//		if bo_was_selected then obj_select(ca.i_numero_obj, TRUE, FALSE)
	end;

	function cl_label.edit_font(father : TForm;bo_tratta : boolean) : boolean;
	{ if (bo_tratta) then esegue i controlli e le post-elaborazioni sul font modificato, altrimenti si limita a cambiarlo;
	  rende TRUE se il font viene effettivamente modificato }
	begin
		result := FALSE;
		var bo_was_selected := ca.bo_selected;
		if bo_was_selected then select(FALSE);
		try
			try
				var lo_old_color : integer := 0;	// ad uso del compilatore, affinchè non rompa
				var fdlg := TFontDialog.create(father);
				fdlg.options := [fdEffects{,fdWysiwyg}];
				if globale.bo_force_font_exist then
					fdlg.options := fdlg.options + [fdForceFontExist, fdNoSimulations];
				fdlg.device := fdBoth;	// fdScreen+fdPrinter
//				if (show = OSW_HIDE) then begin lo_old_color := font.Color;font.Color := lo_color end;
				if (ca.show = OSW_HIDE) then begin lo_old_color := fontcolor;fontcolor := lo_color end;
//				fdlg.font.assign(font);
				assign_font_to(fdlg.font);
				if fdlg.execute then begin
//					font.assign(fdlg.font);
					assign_font(fdlg.font, 0, 0);
					lo_color := fontcolor;
					if (ca.show = OSW_HIDE) then fontcolor := lo_old_color;
					if bo_tratta then begin
						if autosize OR bo_autoheight then verify_height;
//						globale.bo_modified := TRUE
					end;
					result := TRUE
				end
			except
			end
		finally
			if bo_was_selected then select(TRUE)
		end
	end;

	procedure cl_label.WMmove(var Message: TWMMove);
	begin
		var ox : objs_type := tag2object(tag);
		if (ox <> NIL) then ox.on_change_size_and_pos
//		i_obj := tag2index(tag);
//		if (i_obj <> 0) then xobjs(i_obj,get_pagina_logica_attiva).on_change_size_and_pos
	end;

	procedure cl_label.esc; begin end;

	procedure cl_label.set_show_state(show : show_types);
	begin
		if (show = OSW_HIDE) then fontcolor := computer_registry_data.lo_hidden_objects_color
		else if (ca.show = OSW_HIDE) then fontcolor := lo_color;
		Visible := (show <> OSW_HIDE) OR globale.bo_show_hidden_objects;
		ca.show := show
	end;

{$endif GALATEO_EXE}

function cl_label.load(var f : text;xref : reference_obj;tipo_variabile : variabile_type;wo_versione : word) : boolean;
// carica l'oggetto; rende TRUE in caso di successo
type
	old_type = record
		str_formula, str_SQL_expression, str_esempio_value : string;
		{$ifdef GALATEO_EXE} str_hints, str_remarks : string; {$endif}
		bo_log_query_SQL : boolean;
		show : show_types;
		tipo_valore : risultato_type;
		bo_set_parm_esempio_runtime, bo_set_runtime_default_SSD : boolean;
	end;
var
	c, c2 : char;
	s : string;
	old : old_type;
	i, j : integer;
	r_left, r_top, r_width : misura_real_type;	//*
begin
	result := FALSE;
	old.str_formula := '';old.str_SQL_expression := '';old.str_esempio_value := '';
	{$ifdef GALATEO_EXE} old.str_hints := '';old.str_remarks := ''; {$endif}
	old.bo_log_query_sql := FALSE;
	old.show := low(show_types);
	old.tipo_valore := low(risultato_type);
	old.bo_set_parm_esempio_runtime := FALSE;
	old.bo_set_runtime_default_SSD := FALSE;

	try
		enable_paint(FALSE);		// blocco l'aggiornamento del font
		try
			autosize := FALSE;
			bo_autoheight := TRUE;
			readln(f, s);caption := s;
	//		*runtime_debug(caption + ': 100','cl_label.load()',FALSE); {$endif}
			readln(f, r_left, r_top, r_width);
			if (wo_versione = $100) then begin
				Left := round(r_left);Top := round(r_top);Width := round(r_width)
			end
			else begin
				Left := cm2pixel_video_x(r_left);
				Top := cm2pixel_video_y(r_top);
				Width := cm2pixel_video_x(r_width)
			end;

			if (wo_versione <= $0260) then readln_LPSTR(f, old.str_formula);
			readln(f, s);FontName := s;
			readln(f, i, j);
			lo_color := i;fontsize := j;
			fontcolor := lo_color;
			var bo_puntato := FALSE;	// compatibilità con il passato
			bo_blank_if_zero := FALSE;
			fnt_formato_numerico := FORMATO_NUMERICO_DEFAULT;
			bo_simbolo_valuta := FALSE;bo_simbolo_valuta_sx := FALSE;bo_show_segno := FALSE;
			str_simbolo_valuta := '';
			bo_riduci_if_necessario := FALSE;
			i_minimum_size_auto := DEFAULT_MINIMUM_SIZE_AUTO;
			bo_multiline := FALSE;
	//		bo_insert_line_if_multiline := TRUE;
			ca.bo_move_obj_sottostanti := TRUE;
			old.bo_log_query_SQL := TRUE;

			bo_valore_progressivo := FALSE;
	//		tipovar := TV_DB_FIELD;	// default in precedente formato di salvataggio
			if (tipo_variabile <> TV_BLANK) then ca.tipo_variabile := tipo_variabile;		// dal 2011-05-17 il default è assegnato in base al valore letto esternamente
			i_decimali_fissi := 0;i_zeri := 0;str_decimali_fissi_formula := '';str_zeri_formula := '';
	//		font.style := [];
	//		FontWeight := LFW_normal;
			Bold := FALSE;Italic := FALSE;Underline := FALSE;Strikeout := FALSE;
			charcase := ecNormal;
			bo_switch_fontstyle := FALSE;
			round_valuta := round_valuta_type(0);round_valuta_min := round_valuta_type(0);
			bo_usa_simbolo_valuta_breve := FALSE;
			bo_ask_runtime := FALSE;str_ID_lingua := '';
			comportamento_when_null := low(comportamento_when_null_type);str_value_when_null := '';
			validazione.clear;
			bo_runtime_default_is_SQL := FALSE;bo_runtime_default_is_formula := FALSE;
			str_runtime_default_phisical := '';str_runtime_default_debug_phisical := '';
	//		bo_set_parm_esempio_runtime := FALSE;bo_set_runtime_default_SSD := FALSE;
			bo_runtime_answer_can_be_blank := FALSE;bo_runtime_answer_in_valori_suggeriti := FALSE;
			rtq := RTQ_TEXT;
			bo_SQL_load_runtime_values := FALSE;bo_SQL_runtime_parm_debug := FALSE;
			bo_RTQ_select_all_answers := FALSE;RTQ_apix := APIX_SINGLE;
			alignment := TaLeftJustify;bo_giustificato := FALSE;
			runtime_tipodato := RTT_TEXT;
			bo_PDF_modificabile := FALSE;
			i_runtime_max_lines := 0;i_runtime_max_length := 0;i_runtime_min_length := 0;fl_max_vertical_size_cm := 0;i_max_rows := 0;
         bo_trasparente := TRUE;

			bo_forza_font_bold := FALSE;bo_forza_font_italic := FALSE;
			bo_forza_font_underlined := FALSE;bo_forza_font_strikeout := FALSE;
			angle := 0;FontOrientation := 0;lo_background_color := 0;
			old.show := OSW_SHOW;

	//		*runtime_debug(caption + ': 200','cl_label.load()',FALSE); {$endif}
			while NOT eoln(f) do begin
				read(f, c);
				case c of
					'A' : Autosize := TRUE;
	//				'B' : font.style := font.style + [fsBold];
	//				'B' : fontWeight := LFW_bold;
					'B' : Bold := TRUE;
					'C' : bo_centrato := TRUE;
					'D' : bo_blank_if_zero := TRUE;
					'E' : ca.tipo_variabile := TV_SQL_SELECT;
					'F' : autosize := FALSE;
					'G' : begin
						read(f, i_minimum_size_auto,c);
						{$ifdef DEBUG} assert(c = ' ', 'ERRORE di formato sulla MINIMUM_AUTO_SIZE');
						{$else}
							if (c = ' ') then;	// per evitare le compiler's warnings
						{$endif}
					end;
					'H' : begin old.show := OSW_HIDE{;fontcolor := COLOR_HIDDEN_OBJECTS} end;
	//				'I' : font.style := font.style + [fsItalic];
					'I' : Italic := TRUE;
					'J' : ca.tipo_variabile := TV_GROUP_EXPR_SQL;
					'K' : bo_suppress_blank := TRUE;
	//				'L' : bo_insert_line_if_multiline := FALSE;
					'L' : ca.bo_move_obj_sottostanti := FALSE;	// retaggio del passato
					'M' : bo_multiline := TRUE;
					'N' : charcase := ecLowerCase;
					'O' : charcase := ecUpperCase;
					'P' : bo_puntato := TRUE;	// compatibilità con il passato
					'Q' : bo_ask_runtime := TRUE;
					'R' : bo_riduci_if_necessario := TRUE;
	//				'S' : font.style := font.style + [fsStrikeout];
					'S' : Strikeout := TRUE;
					'T' : bo_giustificato := TRUE;
	//				'U' : font.style := font.style + [fsUnderline];
					'U' : Underline := TRUE;
					'V' : begin
						{ a partire dalla versione $0300 il flag indica il tipo di variabile, ed è sempre indicato;
						  nelle versioni precedenti il flag era presente solo per oggetti di tipo VARIABILE e indicata il tipo di variabile TB_DB_FIELD (was: TV_VARIABILE);
						  poichè tale valore era il valore default (e a volte si derogava dalla regola) in lettura trascuro il parametro per versioni precedenti alla $0300 }
						if (wo_versione >= $0300) then begin	// dal 2011-05-17: leggo SEMPRE il tipo di variabile
							read(f, c);
							if (byte(c) <> byte('A') - 1) then ca.tipo_variabile := variabile_type(byte(c) - ord('A') + 1)
						end
	//					{$ifdef DEBUG} else assert((tipo_variabile = TV_DB_FIELD) AND (ca.tipo_variabile = TV_DB_FIELD), 'tipo_variabile errato') {$endif}
	{					if (wo_versione <= $0260) then ca.tipo_variabile := TV_DB_FIELD
						else begin	// dal 2011-05-17: leggo SEMPRE il tipo di variabile
							read(f, c);
							ca.tipo_variabile := variabile_type(byte(c) - ord('A') + 1)
						end }
					end;

					'W' : ca.tipo_variabile := TV_PARAMETRO;

					'X' : alignment := TaLeftJustify;
					'Y' : alignment := TaCenter;
					'Z' : alignment := TaRightJustify;

					'1' : old.show := OSW_SHOW_1;
					'2' : old.show := OSW_HIDE_1;
					'3' : old.show := OSW_SHOW_SOR;
					'4' : old.show := OSW_HIDE_SOR;
					'5' : old.show := OSW_SHOW_EOR;
					'6' : old.show := OSW_HIDE_EOR;
					'9' : old.show := OSW_SHOW_LAST;
					'8' : old.show := OSW_HIDE_LAST;
					'7' : old.show := OSW_SHOW_1REC;
					'v' : old.show := OSW_HIDE_1REC;

					'a' : fnt_formato_numerico := PD;
					'b' : fnt_formato_numerico := VD;
					'c' : fnt_formato_numerico := PM_VD;
					'd' : fnt_formato_numerico := VM_PD;
					'e' : old.bo_log_query_sql := FALSE;
					'f' : bo_simbolo_valuta := TRUE;
					'g' : bo_simbolo_valuta_sx := TRUE;
					'h' : bo_valore_progressivo := TRUE;
					'i' : bo_runtime_answer_can_be_blank := TRUE;
					'j' : bo_runtime_answer_in_valori_suggeriti := TRUE;
					'k', 'q' : old.bo_set_parm_esempio_runtime := TRUE;
					'l' : bo_runtime_default_is_SQL := TRUE;
					'm' : bo_show_segno := TRUE;
					'n' : bo_autoheight := FALSE;
					'p' : bo_SQL_runtime_parm_debug := TRUE;
					'r' : begin
						{$ifdef DEBUG} assert(NOT eoln(f),'DJHC 9287'); {$endif}
						read(f,c);round_valuta := round_valuta_type(byte(c) - byte('0'))
					end;
					's' : begin
						{$ifdef DEBUG} assert(NOT eoln(f),'DJHC 9288'); {$endif}
						read(f,c);round_valuta_min := round_valuta_type(byte(c) - byte('0'))
					end;
					't' : bo_usa_simbolo_valuta_breve := TRUE;
					'u' : old.bo_set_runtime_default_SSD := TRUE;
					'w' : bo_switch_fontstyle := TRUE;
					'x' : begin
						if (wo_versione <= $022A) then rtq := RTQ_SINGLE_SELECT
						else begin
							read(f,c);
							rtq := RTQ_type(byte(c) - byte('0'))
						end
					end;
					'y' : bo_SQL_load_runtime_values := TRUE;
					'z' : ca.tipo_variabile := TV_SQL_SELECT_BEFORE_SQL;
					'@' : ca.tipo_variabile := TV_SQL_SELECT_BEFORE_RUNTIME;
					'~' : begin
						while TRUE do begin
							read(f,c);if (c = '~') then break;
							str_simbolo_valuta := str_simbolo_valuta + c
						end
					end;
					'*' : begin read(f, c);byte(criterio_ricalcolo) := strtoint(c) end;
					'!' : bo_RTQ_select_all_answers := TRUE;
					'"' : begin
						read(f, c, c2);
						RTQ_apix := APIX_type(strtoint(c + c2))
					end;
					'$' : runtime_tipodato := RTT_DATA;
					'#' : runtime_tipodato := RTT_FILENAME;
					'+' : bo_runtime_default_is_formula := TRUE;
					':' : bo_PDF_modificabile := TRUE;
					'&' : bo_trasparente := FALSE;
					'£' : ;	// free for future use
					else if NOT accept_future_versions then raise exception.create('Attributo errato in lettura file')
				end
			end;
			Transparent := bo_trasparente;

	//		if (tipo_oggetto <> VARIABILE) then tipovar := TV_VARIABILE;	// 2006-07-31: se non è una variabile, trascuro il valore specifico del parametro, che in certi casi trae in inganno
	//		if (tipo_oggetto <> xxVARIABILE) then tipovar := TV_BLANK;	// *** commentato 2011-05-17 	// 2006-08-04: se non è una variabile, trascuro il valore specifico del parametro, che in certi casi trae in inganno

			{ se l'oggetto non è visibile, assegno per default font nero;
			  prima di questa versione non veniva conservato il colore degli oggetti disabilitati }
			if (wo_versione < $010E) AND (old.show = OSW_HIDE) then lo_color := clBlack; 

			// prima della versione 2.01 esisteva solo il flag BO_PUNTATO per i punti delle migliaia
			if (wo_versione < $0202) then begin
				{$ifdef DEBUG} assert(fnt_formato_numerico = FORMATO_NUMERICO_DEFAULT,'WDOY 2493'); {$endif}
				if bo_puntato then fnt_formato_numerico := PM_VD else fnt_formato_numerico := PD
			end;

	//		*runtime_debug(caption + ': 300','cl_label.load()',FALSE); {$endif}
			readln(f);
			if (wo_versione <= $0260) then read(f, byte(old.tipo_valore));
			read(f, j, i_cifre_round_phisical);
	//		tipo_valore := risultato_type(i);{bo_text := boolean(i);}

			if (wo_versione <= $0300) then begin
				// c'era un bug che scambiava tra loro i valori NEAREST e DIFETTO
				// poichè il NEAREST è molto più utilizzato del DIFETTO, e dato che cmq il precedente DIFETTO non funzionava (perchè in effetti valeva come NEAREST) assegno sempre NEAREST
				if (j = 0) then round_method := RND_ECCESSO else round_method := RND_NEAREST;
	{			case j of
					0 : round_method := xRND_ECCESSO;
					1 : round_method := xRND_DIFETTO;
					2 : round_method := xRND_NEAREST
				end }
			end
			else round_method := ROUND_TYPES(j);

			if NOT eoln(f) then read(f, i_decimali_fissi);
			if NOT eoln(f) then read(f, i_zeri);
			if (wo_versione >= $0409) then begin
				read(f, s);s := togliblanks(s);
				str_round_formula := get_word_CSV(s, 1, '#');
				str_decimali_fissi_formula := get_word_CSV(s, 2, '#');
				str_zeri_formula := get_word_CSV(s, 3, '#')
			end;
			readln(f);

			if (wo_versione <= $0260) then begin
				readln_LPSTR(f, old.str_SQL_expression);
				readln(f, old.str_esempio_value)
			end;
			xref.load(f);

			if (wo_versione <= $0260) then readln(f {$ifndef DLL},old.str_hints{$endif});
			runtime_debug(caption + ': 400','cl_label.load()', RD_DEBUG_ACCESSORIO_01);
			if NOT ca.load(f, wo_versione) then abort;

			if (wo_versione <= $0260) then begin
				ca.str_formula := old.str_formula;
				ca.str_SQL_expression := old.str_SQL_expression;
				ca.str_esempio_value := old.str_esempio_value;
				{$ifdef GALATEO_EXE} ca.str_hints := old.str_hints;ca.str_remarks := old.str_remarks; {$endif}
				ca.bo_log_query_SQL_phisical := old.bo_log_query_SQL;
				ca.show := old.show;
				ca.tipo_valore := old.tipo_valore
			end;	
			if (ca.show = OSW_HIDE) then fontcolor := computer_registry_data.lo_hidden_objects_color;

			runtime_debug(caption + ': 500','cl_label.load()', RD_DEBUG_ACCESSORIO_01);
			if (wo_versione > $0210) then begin
	//			readln(f, str_runtime_question);
				if NOT readln_LPSTR(f, str_runtime_question) then abort;
				if (wo_versione > $0211) then readln(f, fl_cm_interlinea) else begin readln(f);fl_cm_interlinea := 0 end;
				readln(f, str_usa_formato_valuta);
				if NOT readln_LPSTR(f, str_runtime_answers) then abort;
				if NOT readln_LPSTR(f, str_runtime_values) then abort;
				readln(f, str_runtime_blank_answer);
				readln(f, str_runtime_ask_if)
			end;
			if (wo_versione > $0224) then begin
				readln(f, str_runtime_format);
				readln(f, xstr_runtime_caption);
				readln(f, s);
				if (s <> '') then begin
					bo_store_variabile := SQL2bool(s[1]);
					bo_nome_variabile_SQL := SQL2bool(s[2]);
					str_nome_variabile_store := copy(s, 3, MAXINT)
				end;
				readln(f, s);if (s = '') then store_operation := STOOP_SET else store_operation := STORE_OPERATION_TYPE(strtoint(s));
				if (wo_versione <= $0260) then begin readln_LPSTR(f, s);{$ifndef DLL} ca.str_remarks := s {$endif} end;

				if (wo_versione > $0242) then begin
					readln(f, i_runtime_groupbox, lo_runtime_text_color, lo_runtime_back_color, i_runtime_max_lines, i_runtime_max_length);
//					if (i_runtime_groupbox > high(globale.runtime_gboxes)) then i_runtime_groupbox := 0		**** ERRORE introdotto 2011-07, con l'effetto di annullare il riferimento a TUTTE le GBOXes successive alla prima
				end
				else readln(f);

				readln_LPSTR(f, str_runtime_hint);
				readln(f, str_runtime_enable_if);

	{			if (wo_versione > $0245) then readln(f, byte(editing_type), i_pos, i_skip_cols_before, byte(multiline), i_runtime_min_length)
				else begin editing_type := OEXP_DEFAULT;i_pos := 0;i_skip_cols_before := 0;byte(multiline) := 0;readln(f) end; }

				var exp : cl_expint_object := expint[0];
				if (wo_versione <= $0245) then begin
					exp.expint_mode := OEXP_DEFAULT;exp.i_pos := 0;exp.i_skip_cols_before := 0;byte(exp.multiline) := 0;
					readln(f)
				end
				else
				if (wo_versione <= $0303) then
					readln(f, byte(exp.expint_mode), exp.i_pos, exp.i_skip_cols_before, byte(exp.multiline), i_runtime_min_length)
				else begin
					read(f, i_runtime_min_length);
					if (wo_versione >= $0333) then read(f, fl_max_vertical_size_cm, i_max_rows);	// riga introdotta 2019-05 e RIPRISTINATA 2019-07-27 causa incomprensibile scomparsa
					readln(f)
				end;

				if (wo_versione <= $0303) then begin	// NON accorpare con il blocco precedente, fa casino
					readln(f, exp.str_header);
	//				str_acapo := '';while NOT eoln(f) do begin read(f,i);xstr_acapo := xstr_acapo + char(i) end;readln(f);
					readln(f, exp.str_acapo);exp.str_acapo := translate_hex2string(exp.str_acapo);
					readln(f, exp.str_tab);exp.str_tab := translate_hex2string(exp.str_tab)
				end;

				if NOT eoln(f) then begin
					readln(f, byte(bo_forza_font_bold), byte(bo_forza_font_italic), byte(bo_forza_font_underlined), byte(bo_forza_font_strikeout),
						{angle}i, {FontOrientation}j, lo_background_color);
					Color := lo_background_color;		// l'applicazione dipende poi da TRANSPARENT
					var fs : TFontStyles := [];
	//				if bo_forza_font_bold then fs := fs + [fsBold];
	//				if bo_forza_font_bold then FontWeight := LFW_bold;
					if bo_forza_font_bold then Bold := TRUE;
	//				if bo_forza_font_italic then fs := fs + [fsItalic];
					if bo_forza_font_italic then Italic := TRUE;
	//				if bo_forza_font_underlined then fs := fs + [fsUnderline];
					if bo_forza_font_underlined then Underline := TRUE;
	//				if bo_forza_font_strikeout then fs := fs + [fsStrikeout];
					if bo_forza_font_strikeout then Strikeout := TRUE;
	//				if (fs <> []) then font.style := font.style + fs
					angle := i;FontOrientation := j
				end
				else readln(f);
				readln(f, str_datetime_format);
				readln(f, str_runtime_path);
				readln(f, str_runtime_filename_filter);
				if (wo_versione > $024D) then begin
					readln_LPSTR(f, str_runtime_scripts);
					readln_LPSTR(f, str_runtime_default_phisical);
					readln_LPSTR(f, str_runtime_default_debug_phisical);

					if (wo_versione >= $030E) then begin
						readln(f, str_LCF_condizione);
						readln(f, byte(box_LCF_bold), byte(box_LCF_underline), byte(box_LCF_italic), byte(box_LCF_strikeout),
							LCF_foreground_color, LCF_background_color)
					end
					else begin
						readln(f);readln(f);
{						str_LCF_condizione := '';
						box_LCF_bold := XNOTHING;
						box_LCF_underline := XNOTHING;
						box_LCF_italic := XNOTHING;
						box_LCF_strikeout := XNOTHING;
						LCF_foreground_color := 0;LCF_background_color := 0; }
					end;

					readln(f, str_ID_lingua);
					readln_LPSTR(f, s);
					if (wo_versione >= $0321) then validazione.get_asstring(wo_versione, s);

					readln(f, s);
					if (s <> '') then begin
						{$ifdef DEBUG} assert(wo_versione >= $0325, 'COMPORTAMENTO_WHEN_NULL inserito in versione $0325 -- 2016-07-03'); {$endif}
						comportamento_when_null := comportamento_when_null_type(StrToInt(s[1]));
						str_value_when_null := copy(s, 2, MAXINT)
					end;
					for i := 1 to 4 do readln(f)
				end;

				if (wo_versione <= $0260) AND old.bo_set_parm_esempio_runtime then begin
					if old.bo_set_runtime_default_SSD then str_runtime_default_debug_phisical := old.str_esempio_value
					else str_runtime_default_phisical := old.str_esempio_value
				end
			end;

	//		*runtime_debug(caption + ': 600','cl_label.load()',FALSE);
			enable_paint(TRUE, FALSE);		// ricostruisco il font (una sola volta, alla fine)
			verify_height;	// also if DLL !!!!!
			{$ifdef GALATEO_EXE} hint := ca.str_hints; {$endif}
			result := TRUE
		except
//			result := FALSE;
			MessageBox(father.handle, 'Errore durante la lettura del file', MBOX_CAPTION, MB_ICONSTOP);
			abort
		end
	finally
		enable_paint(TRUE, FALSE)		// forzo la riabilitazione del painting, anche in caso di errori
	end
end;

function cl_label.get_x_left_virtuale(x_left : int_pixel_type) : int_pixel_type;
begin
	if bo_centrato then x_left := (parent.Width - width) div 2;
	if globale.bo_text_only then result := round(tm.videopixel2colonne(x_left) * tm.r_text_only_char_video_pixel_x)
	else result := x_left
end;

function cl_label.get_tag : integer; begin result := inherited tag end;

procedure cl_label.set_tag(lo_tag : integer);
begin
	ca.lo_tag := lo_tag;
	inherited tag := lo_tag
end;

{$ifdef GALATEO_EXE}
	function cl_label.get_y_top_virtuale(y_top : int_pixel_type) : int_pixel_type;
	var mtr : TTEXTMETRIC;	//*
	begin
		if NOT globale.bo_griglia_vtabs OR (globale.i_griglia_vtabs <= 1) then begin
			result := y_top;exit
		end;
//		pbox.canvas.font := font;
		pbox.canvas.font := get_font;
		GetTextMetrics(pbox.canvas.handle, mtr);
		// calcolo la base effettiva della scritta
		var i_base_carattere : int_pixel_type := y_top + mtr.tmAscent;
		// calcolo la base normalizzata (ovvero: grigliata, ma senza costine)
		i_base_carattere := (((i_base_carattere-1) div globale.i_griglia_vtabs)+1) * globale.i_griglia_vtabs;
		if (i_base_carattere - mtr.tmAscent < 0) then inc(i_base_carattere,globale.i_griglia_vtabs);
		if (i_base_carattere - mtr.tmAscent + height > pbox.Height)
			then dec(i_base_carattere,globale.i_griglia_vtabs);
		y_top := i_base_carattere - mtr.tmAscent;
		result := y_top
	end;

	function cl_label.assign(lab : cl_label) : cl_label;
	// esegue SELF := LAB; rende SELF
	begin
		ca.assign(lab.ca);
		bo_giustificato := lab.bo_giustificato;
		round_method := lab.round_method;
		i_cifre_round_phisical := lab.i_cifre_round_phisical;str_round_formula := lab.str_round_formula;
		fnt_formato_numerico := lab.fnt_formato_numerico;
		bo_valore_progressivo := lab.bo_valore_progressivo;
		bo_show_segno := lab.bo_show_segno;
		bo_simbolo_valuta := lab.bo_simbolo_valuta;
		bo_simbolo_valuta_sx := lab.bo_simbolo_valuta_sx;
		str_simbolo_valuta := lab.str_simbolo_valuta;
		bo_centrato := lab.bo_centrato;
		bo_blank_if_zero := lab.bo_blank_if_zero;
		i_decimali_fissi := lab.i_decimali_fissi;i_zeri := lab.i_zeri;
		str_decimali_fissi_formula := lab.str_decimali_fissi_formula;str_zeri_formula := lab.str_zeri_formula;
		bo_multiline := lab.bo_multiline;
		fl_cm_interlinea := lab.fl_cm_interlinea;
		fl_max_vertical_size_cm := lab.fl_max_vertical_size_cm;
		i_max_rows := lab.i_max_rows;
		bo_suppress_blank := lab.bo_suppress_blank;
		criterio_ricalcolo := lab.criterio_ricalcolo;
		bo_riduci_if_necessario := lab.bo_riduci_if_necessario;
		i_minimum_size_auto := lab.i_minimum_size_auto;
		bo_forza_font_bold := lab.bo_forza_font_bold;
		bo_forza_font_italic := lab.bo_forza_font_italic;
		bo_forza_font_underlined := lab.bo_forza_font_underlined;
		bo_forza_font_strikeout := lab.bo_forza_font_strikeout;
		charcase := lab.charcase;
		bo_switch_fontstyle := lab.bo_switch_fontstyle;
		str_usa_formato_valuta := lab.str_usa_formato_valuta;
		str_datetime_format := lab.str_datetime_format;
		round_valuta := lab.round_valuta;
		round_valuta_min := lab.round_valuta_min;
		bo_usa_simbolo_valuta_breve := lab.bo_usa_simbolo_valuta_breve;
		str_ID_lingua := lab.str_ID_lingua;
		validazione.assign(lab.validazione);
		comportamento_when_null := lab.comportamento_when_null;
		str_value_when_null := lab.str_value_when_null;
		lo_color := lab.lo_color;lo_background_color := lab.lo_background_color;
		Transparent := lab.Transparent;bo_trasparente := lab.bo_trasparente;
		bo_autoheight := lab.bo_autoheight;
		bo_ask_runtime := lab.bo_ask_runtime;
		str_runtime_question := lab.str_runtime_question;
		xstr_runtime_caption := lab.xstr_runtime_caption;
		str_runtime_format := lab.str_runtime_format;
		rtq := lab.rtq;
		bo_SQL_load_runtime_values := lab.bo_SQL_load_runtime_values;
		bo_SQL_runtime_parm_debug := lab.bo_SQL_runtime_parm_debug;
		str_runtime_answers := lab.str_runtime_answers;
		str_runtime_values := lab.str_runtime_values;
		bo_runtime_answer_can_be_blank := lab.bo_runtime_answer_can_be_blank;
		str_runtime_blank_answer := lab.str_runtime_blank_answer;
		bo_runtime_answer_in_valori_suggeriti := lab.bo_runtime_answer_in_valori_suggeriti;
		bo_RTQ_select_all_answers := lab.bo_RTQ_select_all_answers;
		bo_PDF_modificabile := lab.bo_PDF_modificabile;
		RTQ_apix := lab.RTQ_apix;
		str_runtime_ask_if := lab.str_runtime_ask_if;
		str_runtime_enable_if := lab.str_runtime_enable_if;
		i_runtime_groupbox := lab.i_runtime_groupbox;
		lo_runtime_text_color := lab.lo_runtime_text_color;
		lo_runtime_back_color := lab.lo_runtime_back_color;
		str_runtime_hint := lab.str_runtime_hint;
		runtime_tipodato := lab.runtime_tipodato;
		str_runtime_path := lab.str_runtime_path;
		str_runtime_filename_filter := lab.str_runtime_filename_filter;
		i_runtime_max_lines := lab.i_runtime_max_lines;
		i_runtime_min_length := lab.i_runtime_min_length;
		i_runtime_max_length := lab.i_runtime_max_length;
		str_runtime_scripts := lab.str_runtime_scripts;
		str_runtime_default_phisical := lab.str_runtime_default_phisical;
		str_runtime_default_debug_phisical := lab.str_runtime_default_debug_phisical;
		{$ifdef DEBUG} assert(high(expint) = high(lab.expint), 'cl_label.assign() con length(expint) differenti: ' + length(expint).ToString + '/' + length(lab.expint).ToString); {$endif}
		for var i : expint_index_type := 0 to high(expint) do expint[i].assign(lab.expint[i]);
		bo_runtime_default_is_SQL := lab.bo_runtime_default_is_SQL;
		bo_runtime_default_is_formula := lab.bo_runtime_default_is_formula;
		bo_store_variabile := lab.bo_store_variabile;
		bo_nome_variabile_SQL := lab.bo_nome_variabile_SQL;
		str_nome_variabile_store := lab.str_nome_variabile_store;
		store_operation := lab.store_operation;
		bo_null := lab.bo_null;
//		bo_SQL_value_assigned := lab.bo_SQL_value_assigned;
		dbl_print_value_phisical := lab.dbl_print_value_phisical;
//		bo_formatted_print := lab.bo_formatted_print;
		str_formatted_print := lab.str_formatted_print;
		assign_inherited_field(lab);

		str_LCF_condizione := lab.str_LCF_condizione;
		box_LCF_bold := lab.box_LCF_bold;
		box_LCF_underline := lab.box_LCF_underline;
		box_LCF_italic := lab.box_LCF_italic;
		box_LCF_strikeout := lab.box_LCF_strikeout;
		LCF_foreground_color := lab.LCF_foreground_color;LCF_background_color := lab.LCF_background_color;

		result := self
	//	*lp_print
	//	*lp_print_left
	end;

	procedure cl_label.assign_inherited_field(lab : TFlabel);
	// esegue l'assegnazione dei campi ereditati
	begin
		Angle := lab.Angle;
		FontOrientation := lab.FontOrientation;
		ExternalBorderWidth := lab.ExternalBorderWidth;
		TextXPos := lab.TextXPos;TextYPos := lab.TextYPos;
		assign_font(lab)
	end;

{$endif GALATEO_EXE}

function tratta_formula({i_section : section_index_type;}pt_obj : {objs_type}pointer;str_formula : string;tipo_res : risultato_type = VAL_BOH) : string;
{ I_SECTION non è necessariamente uguale a PT_OBJ.GET_SECTION()
  TIPO_RES: assegnare solo per forzare un tipo differente da quello di PT_OBJ^ }
var obj : objs_type absolute pt_obj;	//*
begin
	result := '';
	if (str_formula = '') then exit;
//	if (tipo_res = VAL_BOH) then tipo_res := obj.aslabel.tipo_valore;	// dal 2006-02-11: io so il tipo di risultato che la funzione deve rendere!
	if (tipo_res = VAL_BOH) then tipo_res := obj.ca.tipo_valore;	// dal 2006-02-11: io so il tipo di risultato che la funzione deve rendere!
//MessageBBox(0, str_formula, 'XXXXXXXXXX'); 	{$ifndef DEBUG} *** {$endif}
	str_formula := translate_local_macros(str_formula);	// 2005-06-20
	sections_1B(obj.ca.i_section_1B).interpreta_string(str_formula, {stampa_vera}FALSE, {check_errors}TRUE);	// 2005-04-10
//	sections(i_section).interpreta_string(str_formula,FALSE,TRUE);	// 2005-04-10
//	if NOT translate_formula(s,str_result,FALSE,tipo_res,tag2index(tag)) then begin
//	if NOT translate_formula(s,str_result,FALSE,tipo_res,i_numero_obj) then begin		-- fa casino perchè I_NUMERO_OBJ è relativo ad una pagina logica che non sempre è quella attiva
	if NOT translate_formula(str_formula, result, FALSE, tipo_res, obj)
		then raise exception.create(result)
end;

(*function cl_label.get_print_value : string;		**** così fino al 2011-05-17
var
	ox : objs_type;
	s, str_result : string;
	tipo_res : risultato_type;
begin
	if NOT bo_print_value_ready then begin
		try
			case tipo_oggetto of
				xTESTO : set_print_value(caption);
				xxVARIABILE : begin
					case tipovar of
						TV_BLANK, TV_VARIABILE : ;
						TV_PARAMETRO, TV_SQL_SELECT_BEFORE_SQL, TV_SQL_SELECT_BEFORE_RUNTIME :
							{$ifndef DLL} set_print_value(str_esempio_value) {$endif};
						TV_GROUP_EXPR_SQL:;
						TV_SQL_SELECT: ;
					end;
//					strMessageBBox(0,'Valore non elaborato','Variabile <' + caption + '>',MB_ICONSTOP);
//					exit
				end;
				xxFORMULA : begin
{$define OLD}
{$ifdef OLD}
//					tipo_res := VAL_BOH;			// cosi' fino al 2006-02-10
					tipo_res := tipo_valore;	// dal 2006-02-11: io so il tipo di risultato che la funzione deve rendere!
					s := str_formula;
//MessagebbOX(0, str_formula, 'XXXXXXXXXX'); 	{$ifndef DEBUG} *** {$endif}
					s := translate_local_macros(s);	// 2005-06-20
					sections(i_section).interpreta_string(s,FALSE,TRUE);	// 2005-04-10
//					if NOT translate_formula(s,str_result,FALSE,tipo_res,tag2index(tag)) then begin
//					if NOT translate_formula(s,str_result,FALSE,tipo_res,i_numero_obj) then begin		-- fa casino perchè I_NUMERO_OBJ è relativo ad una pagina logica che non sempre è quella attiva
					if NOT translate_formula(s, str_result, FALSE, tipo_res, tag2object(tag))
						then raise exception.create(str_result);
{$else}
					str_result := tratta_formula(i_section, tag2object(tag), str_formula);		// dal 2008-09-19
{$endif}
					set_print_value(togli_protezione_parametri(str_result));
				end;
				else begin
					{$ifdef DEBUG} assert(FALSE,'GET_PRINT_VALUE(): non dovrebbe chiedermi ciò'); {$endif}
					abort
				end
			end;
			// eseguo l'eventuale arrotondamento
//			if (tipo in [FORMULA,VARIABILE]) AND (tipo_valore = VAL_NUMERO) then exec_round
		except
			ox := tag2object(tag);
			if (ox = NIL) then s := caption else s := ox.get_debug_caption;
			error_msg(0,s + ACAPO2 + 'Errore durante l''elaborazione dell''oggetto',MBOX_CAPTION);
			raise
		end
	end;
	if (tipo_oggetto in [xxFORMULA, xxVARIABILE]) AND (tipo_valore = VAL_NUMERO) AND (dbl_print_value_phisical = NULL_VALUE)
		then applica_formato_numerico;
	result := strpas(lp_print)
end; *)

function cl_label.get_print_value : string;
var s, str_result : string;
begin
	if NOT ca.bo_print_value_ready then begin
		try
			case ca.tipo_variabile of
				TV_BLANK : {$ifdef DEBUG} assert(FALSE, 'TIPOVAR = TV_BLANK') {$endif};
				TV_STATIC_TEXT : begin
//					set_print_value(caption)
{					if NOT globale.traduzione_disponibile then set_print_value(caption)
					else begin
						s := globale.get_traduzione_lingua(self.str_ID_lingua);
						set_print_value(s)
					end }
					if globale.traduzione_disponibile AND (str_ID_lingua <> '') then begin
						s := globale.get_traduzione_lingua(str_ID_lingua);
						set_print_value(s)
					end
					else set_print_value(caption)
				end;
				TV_DB_FIELD : ;
				TV_PARAMETRO, TV_SQL_SELECT_BEFORE_SQL, TV_SQL_SELECT_BEFORE_RUNTIME : {$ifndef DLL} set_print_value(ca.str_esempio_value) {$endif};
				TV_GROUP_EXPR_SQL : ;
				TV_SQL_SELECT : ;
				TV_FORMULA : begin
{$define X123_OLD}
{$ifdef X123_OLD}
//					var tipo_res : risultato_type := VAL_BOH;			// cosi' fino al 2006-02-10
					var tipo_res : risultato_type := ca.tipo_valore;	// dal 2006-02-11: io so il tipo di risultato che la funzione deve rendere!
//					s := ca.str_formula;
//					s := translate_local_macros(s);	// 2005-06-20
					s := translate_local_macros(ca.str_formula);	// 2012-09-01
					sections_1B(ca.i_section_1B).interpreta_string(s, {stampa_vera}FALSE, {check_errors}TRUE);	// 2005-04-10
//					if NOT translate_formula(s,str_result,FALSE,tipo_res,tag2index(tag)) then begin
//					if NOT translate_formula(s,str_result,FALSE,tipo_res,i_numero_obj) then begin		-- fa casino perchè I_NUMERO_OBJ è relativo ad una pagina logica che non sempre è quella attiva
					if NOT translate_formula(s, str_result, FALSE, tipo_res, tag2object(tag))
						then raise exception.create(str_result);
{$else}
					str_result := tratta_formula(i_section, tag2object(tag), str_formula);		// dal 2008-09-19
{$endif}
					set_print_value(togli_protezione_parametri(str_result))
				end;
				else begin
					{$ifdef DEBUG} assert(FALSE,'GET_PRINT_VALUE(): non dovrebbe chiedermi ciò'); {$endif}
					abort
				end
			end;
			// eseguo l'eventuale arrotondamento
//			if (tipo in [FORMULA,VARIABILE]) AND (tipo_valore = VAL_NUMERO) then exec_round
		except
			var ox : objs_type := tag2object(tag);
			if (ox = NIL) then s := Caption else s := ox.get_debug_caption;
			error_msg(s + ACAPO2 + 'Errore durante l''elaborazione dell''oggetto', MBOX_CAPTION);
			raise
		end
	end;
//	if (tipo_oggetto in [xxFORMULA, xxVARIABILE]) AND (tipo_valore = VAL_NUMERO) AND (dbl_print_value_phisical = NULL_VALUE)

{	if bo_null AND (ca.tipo_valore <> VAL_NUMERO) then begin		// i valori NULL di tipo NUMERICO sono trattati altrove
		var comportamento_when_null : comportamento_when_null_type;
		if (self.comportamento_when_null = CWNT_REPORT_DEFAULT) then comportamento_when_null := globale.comportamento_when_null
		else comportamento_when_null := self.comportamento_when_null;

		s := '';
		case comportamento_when_null of
//			CWNT_REPORT_DEFAULT,
//			CWNT_STANDARD,
			xCWNT_USE_VALUE : begin
				if (self.comportamento_when_null = xCWNT_USE_VALUE) then s := str_value_when_null;
				if (s = '') then s := globale.str_value_when_null_text;
				strcpychk(ca.lp_print, LPSTR(s))
			end;
//			CWNT_BLANK
//			else
		end
	end; }

	// tratto i valori NULL di tipo STRINGA per assegnare il valore BLANK quando utilizzati in funzioni e comparazioni (non in stampa)
	if bo_null AND (ca.tipo_valore <> VAL_NUMERO) then begin		// i valori NULL di tipo NUMERICO sono trattati altrove
		result := '';
		exit
	end;

	if (ca.tipo_variabile <> TV_STATIC_TEXT) AND (ca.tipo_valore = VAL_NUMERO)
			AND (dbl_print_value_phisical = xNUMERIC_NULL_VALUE)	/// significa: FORMATO NUMERICO NON ANCORA APPLICATO
		then applica_formato_numerico;
	result := strpas(ca.lp_print)
end;

procedure cl_label.set_print_value(s : string);
begin
{	if bo_null AND (ca.tipo_valore <> VAL_NUMERO) then begin		// i valori NULL di tipo NUMERICO sono trattati altrove
		var comportamento_when_null : comportamento_when_null_type;
		if (self.comportamento_when_null = CWNT_REPORT_DEFAULT) then comportamento_when_null := globale.comportamento_when_null
		else comportamento_when_null := self.comportamento_when_null;

		case comportamento_when_null of
//			CWNT_REPORT_DEFAULT,
//			CWNT_STANDARD,
			xCWNT_USE_VALUE : begin
				var str_null : string;
				if (self.comportamento_when_null = xCWNT_USE_VALUE) then str_null := str_value_when_null;
				if (str_null = '') then str_null := globale.str_value_when_null_text;
				s := str_null
			end;
//			CWNT_BLANK
//			else
		end
	end; }

	strcpychks(ca.lp_print, s);//lp_print_left := NIL;
	applica_formato_numerico;
	ca.bo_print_value_ready := TRUE;
//	if bo_store_variabile AND (globale.fase_stampa = FASE_STAMPA_ASSEGNAZIONE_STORED_VALUES[tipo_oggetto]) then store_value
	if bo_store_variabile AND (globale.fase_stampa = FASE_STAMPA_ASSEGNAZIONE_STORED_VALUES[ca.tipo_variabile]) then store_value
end;

procedure cl_label.store_value;
begin
	if NOT bo_store_variabile {OR bo_value_stored} then exit;
//	bo_value_stored := TRUE;
	var str_name := str_nome_variabile_store;
	if (str_name = '') then str_name := caption;
	var sz : cl_sezione := sections_1B(ca.i_section_1B);
	sz.interpreta_string(str_name, {stampa_vera}TRUE, {check_errors}FALSE);
	if bo_nome_variabile_SQL then str_name := get_string_where(sz.qry.DatabaseName, str_name);
//	globale.store_value(str_name, tipo_valore <> VAL_NUMERO, str_print)
	if (ca.tipo_valore = VAL_NUMERO) then globale.store_value(str_name, get_numeric_print_value, store_operation)
	else globale.store_value(str_name, str_print, TRUE, STOOP_SET)
end;

procedure cl_label.reset_print_value;
// obbliga a ricalcolare il valore di stampa
begin
	ca.bo_print_value_ready := FALSE;
	strcpy(ca.lp_print, '');		// 2006-07-31
//	bo_null := TRUE;bo_SQL_value_assigned := FALSE;bo_formatted_print := FALSE;
	dbl_print_value_phisical := xNUMERIC_NULL_VALUE				// formato numerico non ancora applicato
end;

procedure cl_label.clear_print_value;
begin
	ca.bo_print_value_ready := FALSE;
	strcpy(ca.lp_print, '')
end;

function cl_label.get_numeric_print_value : double;
begin
//	{$ifdef DEBUG} assert(ca.bo_print_value_ready = (dbl_print_value_phisical = xNUMERIC_NULL_VALUE)
	if (dbl_print_value_phisical = xNUMERIC_NULL_VALUE) {$ifdef CASA} AND NOT bo_exclude_message_not_computed_object {$endif} then
		MessageBBox(0,'Oggetto: ' + caption + ACAPO2 +
			'L''oggetto è stato referenziato ma non è stato ancora calcolato.' + ACAPO2 +
			'Prova a spostarlo verso l''alto nella scaletta della precedenza di elaborazione',
			MBOX_CAPTION);
//	{$ifdef DEBUG} assert(,'obj: ' + caption + ACAPO2 + 'NULL NUMERIC VALUE') {$endif};
	if bo_null OR (dbl_print_value_phisical = xNUMERIC_NULL_VALUE) then result := 0
	else result := dbl_print_value_phisical
end;

procedure cl_label.set_numeric_print_value(dbl : double);
begin
	if bo_null then dbl_print_value_phisical := 0
	else dbl_print_value_phisical := dbl
end;

function cl_label.applica_formato_numerico : string;
{ arrotonda e formatta il valore numerico dell'oggetto;
  rende il risultato dell'arrotondamento, che pure viene scritto in LP_PRINT e in STR_PRINT }
var
	dbl : double;	//*
	str_result, str_original, str_show_segno, str_temp : string;	//*
begin
//	if NOT (tipo_oggetto in [xxVARIABILE, xxFORMULA]) OR (tipo_valore <> VAL_NUMERO) then begin
	if (ca.tipo_variabile = TV_STATIC_TEXT) OR (ca.tipo_valore <> VAL_NUMERO) then begin
		set_numeric_print_value(xNUMERIC_NULL_VALUE);
		exit
	end;
	try
{		if bo_null then begin
			if (self.comportamento_when_null = CWNT_REPORT_DEFAULT) then comportamento_when_null := globale.comportamento_when_null
			else comportamento_when_null := self.comportamento_when_null;

			if (comportamento_when_null <> CWNT_STANDARD) then begin		// 2016-07-03
				set_numeric_print_value(0);		// comunque il valore numerico - ove applicabile - resta ZERO
				case comportamento_when_null of
					// uso il valore di locale STR_VALUE_WHEN_NULL solamente se il comportamento locale ESPLICITO è xCWNT_USE_VALUE
					xCWNT_USE_VALUE : str_result := coalesce(ifs(self.comportamento_when_null = xCWNT_USE_VALUE, str_value_when_null),
						globale.str_value_when_null_numeric);		// stiamo necessariamente parlando un NUMERO !!!
//					CWNT_BLANK : str_result := ''
					else str_result := ''		// cautelativamente tratto TUTTI gli altri casi
				end;
				exit
			end
		end; }

		str_original := strpas(ca.lp_print);
		try
			{ verifico se ho già eseguito la formattazione;
			  se viene utilizzata una valuta, poichè questa può essere contenuta in una variabile
			  o in una formula che non necessariamente era già stata calcolata al momento del caricamento del dato,
			  forzo comunque la riformattazione }
			if (str_usa_formato_valuta = '') AND (dbl_print_value_phisical <> xNUMERIC_NULL_VALUE) AND (str_formatted_print = str_original) then begin
				str_result := str_original;
				exit	// elaborazione già eseguita
			end;

			var valuta : cl_valuta := NIL;
			var i_cifre_round_min : smallint := 0;		// per esigenze di compilatore
			if (str_usa_formato_valuta <> '') then begin
				load_tbl_valute(globale.get_databasename);	// verifico d'aver caricato la tabella delle valute
				var x_valuta : objs_type := name2obj(str_usa_formato_valuta, TRUE);

				if (x_valuta <> NIL) then valuta := get_ptr_valuta(x_valuta.aslabel.get_print_value);
				if (valuta = NIL) then begin
					MessageBBox(0, 'oggetto: ' + caption + ACAPO2 + 'Impossibile trovare le impostazioni per la valuta', MBOX_CAPTION, MB_ICONSTOP);
					abort
				end;
				case round_valuta of
					RNDV_FISSI : i_cifre_round_phisical := FIX_ROUNDING;
					RNDV_MAX : i_cifre_round_phisical := MAX_ROUNDING;
					RNDV_CALCOLO : i_cifre_round_phisical := EXTENDED_ROUNDING;
					RNDV_SIGNIFICATIVI : i_cifre_round_phisical := RND_SIGNIFICATIVE_DEFAULT
					{$ifdef DEBUG} ;else assert(FALSE,'DKJF 92743') {$endif}
				end;
				case round_valuta_min of
					RNDV_FISSI : i_cifre_round_min := FIX_ROUNDING;
					RNDV_MAX : i_cifre_round_min := MAX_ROUNDING;
					RNDV_CALCOLO : i_cifre_round_min := EXTENDED_ROUNDING;
					RNDV_SIGNIFICATIVI : i_cifre_round_min := RND_SIGNIFICATIVE_DEFAULT
					{$ifdef DEBUG} ;else assert(FALSE,'DKJF 92553') {$endif}
				end;
//				i_cifre_round := -valuta.i_decimali_fissi;
				round_method := RND_NEAREST
			end;

//			DRval(str_original,dbl,j);
			// ------------ 2001-12-19 start -----------------------------------------------------
			if (dbl_print_value_phisical = xNUMERIC_NULL_VALUE) OR (str_formatted_print <> str_original)
				then DRval(str_original, dbl)
			else dbl := dbl_print_value_phisical;
			// ------------ 2001-12-19 end -------------------------------------------------------

			var i_cifre_round_local : shortint := xi_cifre_round;	// valore calcolato, evito di ripetere il calcolo
			if (i_cifre_round_local <> RND_NO_ROUND) then begin
				if (valuta = NIL) then dbl := my_round(dbl, -i_cifre_round_local, round_method)		// prima arrotondo come desiderato
				else dbl := valuta.vround(dbl, i_cifre_round_local)
			end;
			set_numeric_print_value(dbl);
			if (abs(dbl) < 1e-10) AND bo_blank_if_zero then str_result := ''
			else begin
				if (dbl = 0) then dbl := 0;	// assurdo, ma evita visualizzazioni come "-0" (non meno assurde e altrettanto inspiegabili)
				if (str_usa_formato_valuta = '') then begin
					if bo_show_segno AND (dbl > 0) then str_show_segno := '+';
					if (str_decimali_fissi_formula <> '') then begin
						var ris : risultato_type := VAL_NUMERO;
						if translate_formula(str_decimali_fissi_formula, str_temp, {test}FALSE, ris, NIL) then i_decimali_fissi := str_temp.ToInteger
					end;
					if (str_zeri_formula <> '') then begin
						var ris : risultato_type := VAL_NUMERO;
						if translate_formula(str_zeri_formula, str_temp, {test}FALSE, ris, NIL) then i_zeri := str_temp.ToInteger
					end;
					str_result := formatta_numero(dbl, fnt_formato_numerico, i_zeri, max(-i_cifre_round_local, 0), i_decimali_fissi);
					if bo_simbolo_valuta then begin
						if bo_simbolo_valuta_sx then str_result := str_simbolo_valuta + ' ' + str_result
						else str_result := str_show_segno + str_result + ' ' + str_simbolo_valuta
					end
					else str_result := str_show_segno + str_result
				end
				else begin
					if bo_simbolo_valuta then
						if bo_usa_simbolo_valuta_breve then str_result := valuta.formatta_currency_short(dbl, i_cifre_round_min, bo_show_segno)
						else str_result := valuta.formatta_currency(dbl, i_cifre_round_min, bo_show_segno)
					else str_result := valuta.puntato(dbl, i_cifre_round_min, {decimali_max}MAX_ROUNDING, bo_show_segno)
				end
			end
		except
			set_numeric_print_value(xNUMERIC_NULL_VALUE)
//			str_print := str_original
		end
	finally
//		str_print := str_result;	// NO!!! per la ricorsione
		strcpychks(ca.lp_print, str_result);
		str_formatted_print := str_result;
		result := str_result
	end
end;

{$ifdef CASA}

procedure cl_label.assign_formatted_numeric_print_value(lp : LPSTR);
// copia da LP (stringa già formattata) il valore numerico
var
	formato : FORMATO_NUMERICO_TYPES;	//*
	str_simbolo_valuta : string;	//*
begin
	if bo_null then begin
		dbl_print_value_phisical := 0;
		ca.bo_print_value_ready := TRUE;
		exit
	end;

	var v : cl_valuta := NIL;		// esigenze di compilatore
	var c : char := ' ';
	strcpy(ca.lp_print, lp);
	var s := strpas(lp);

	// tolgo il separatore delle migliaia (la stringa è formattata secondo il formato assegnato al campo)
	if (str_usa_formato_valuta = '') then begin
		formato := fnt_formato_numerico;
		str_simbolo_valuta := self.str_simbolo_valuta
	end
	else begin
		v := get_ptr_valuta(name2obj(str_usa_formato_valuta, TRUE).aslabel.get_print_value);
		formato := v.display_format;
		str_simbolo_valuta := ifs(self.bo_usa_simbolo_valuta_breve, v.str_simbolo_short, v.str_sigla)
	end;

	// blocco inserito 2014-06-19 per eliminare il simbolo di valuta; fino a ieri il probl non esisteva x' la stringa arrivava senza simbolo (causa bug collaterale)
	if bo_simbolo_valuta then begin
//		if (str_usa_formato_valuta = '') then bo_sx := bo_simbolo_valuta_sx else bo_sx := v.bo_simbolo_before;	// aggiunto 2016-04-16 perchè non interpretava correttamente se (STR_USA_FORMATO_VALUTA != '')
		var bo_sx := bo_simbolo_valuta_sx;
		if (v <> NIL) then bo_sx := v.bo_simbolo_before;		// modificato 2016-06-03 (ma sostanzialmente equivalente a 2016-04-16)
		if bo_sx AND start_with(s, str_simbolo_valuta) then s := copy(s, length(str_simbolo_valuta) + 1, MAXINT);
		if NOT bo_sx AND end_with(s, str_simbolo_valuta) then s := copy(s, 1, length(s) - length(str_simbolo_valuta));
		s := togliblanks(s)
	end;

	case formato of
		PM_VD: sostituisci(s, '.', '');
		VM_PD: sostituisci(s, ',', '')
	end;
	case formato of
		PD, VM_PD : c := '.';		// Punto Decimali
		VD, PM_VD : c := ','			// Virgola Decimali
	end;
	if (fdecimalseparator <> c) then sostituisci(s, c, fdecimalseparator);

	// ---------------------------------------

	if (str_simbolo_valuta <> '') then s := togliblanks(sostituisci(s, str_simbolo_valuta, ''));
	if (s = '') then dbl_print_value_phisical := 0
	else begin
		try
			dbl_print_value_phisical := strtofloat(s)
		except
//			error_msg(0,'Errore durante la conversione del valore ' + s + ACAPO2 + tag2object(tag).get_debug_caption, MBOX_CAPTION);
//			error_msg(0,'Errore durante la conversione del valore ' + s + ACAPO2 + objs(i_numero_obj).get_debug_caption, MBOX_CAPTION);
			error_msg('Errore durante la conversione del valore ' + s + ACAPO2 + tag2object(tag, FALSE).get_debug_caption, MBOX_CAPTION);
			raise
		end
	end;
	strcpy(ca.lp_print, LPSTR(floattostr(dbl_print_value_phisical)));
	ca.bo_print_value_ready := FALSE;str_formatted_print := '<x*';
	applica_formato_numerico;
{	if ((abs(dbl_print_value_phisical) < 1e-10) AND bo_blank_if_zero) then begin
		strcpy(lp_print,'');
		str_formatted_print := ''
	end;
	* }
//	bo_print_value_ready := FALSE	{$ifndef DEBUG} ** {$endif}
end;

(*function cl_label.get_parm_esempio_runtime_running : boolean;
begin
	result := bo_set_parm_esempio_runtime;
	// se NON sto debuggando, e se è attiva la clausola di assegnazione Solo Se Debug, nego
	if NOT globale.bo_debug AND bo_set_runtime_default_SSD then result := FALSE
end;*)

function cl_label.print(vcanvas, pcanvas : TCanvas;x0, y0 : int_pixel_type;bo_video : boolean;
	ptcr : pTRect;var i_delta_y : int_pixel_type;var i_max_y_pixel : int_pixel_type;
	i_delta_y_bottom, i_margine_y_pixel : int_pixel_type;
	i_font_ridotto_size : smallint;bo_can_break_object : boolean;
	i_ph_first_page_section, i_ph_last_page_section : ph_page_type;
	ptr_print_section : {cl_print_section}pointer = NIL) : boolean;
{ vedi commento generale in OBJECTS su PRINT_PROC_TYPE;
  if BO_CAN_BREAK_OBJECT then se il record non sta nella sezione viene spaccato e ripartito tra LP_PRINT e LP_PRINT_LEFT; se ciò avviene la funzione rende FALSE }

	procedure print_giustificato(canvas : TCanvas;s : string;x0,y0 : int_pixel_type);
	var
		i, j, k, i_len, i_maxlen, i_interruzioni : int_pixel_type;
		i_pos, i_delta : array of int_pixel_type;
	begin
		if (s = '') then exit;	// cosi' ci togliamo il pensiero
		if bo_video then begin
			i_len := vcanvas.TextWidth(s);
			i_maxlen := width
		end
		else begin
			i_len := pcanvas.TextWidth(s);
			i_maxlen := tm.video2print_pixel_x(width)
		end;
		if (tm.r_fattore_zoom <> 1) then i_maxlen := round(i_maxlen * tm.r_fattore_zoom);

		i_interruzioni := 0;j := 1;
		while TRUE do begin
			i := j + pos(' ',copy(s,j,MAXINT));
			if (i = j) then break;	// nessuno spazio trovato

			// se c'è un gruppo di spazi, mi sposto alla fine del gruppo
			while (length(s) > i) AND (s[i] = ' ') do inc(i);

			inc(i_interruzioni);
			setLength(i_pos, i_interruzioni);
			i_pos[i_interruzioni-1] := i;
			j := i
		end;

		setLength(i_delta, i_interruzioni);
		var fl : double := (i_maxlen - i_len) / i_interruzioni;k := 0;
		for i := 0 to i_interruzioni-1 do begin
			j := round(fl * (i+1));
			i_delta[i] := j - k;
			inc(k, i_delta[i])
		end;

{$ifdef DEBUG}
		if (i_interruzioni > 0) then begin	// altrimenti è per definizione falso
			j := 0;for i := 0 to i_interruzioni-1 do inc(j,i_delta[i]);
			assert(j = i_maxlen - i_len,'DJHS 9293 -- distanza non esatta');
		end;
{$endif}

		if (i_len = i_maxlen) OR (i_interruzioni = 0) then begin		// caso raro, ma purtuttavia esistente
			canvas.TextOut(x0, y0, s);
			exit
		end;

		i := 0;j := 1;
		while (i < i_interruzioni) do begin
			var str_printing := copy(s, j, i_pos[i]-j);
			canvas.TextOut(x0, y0, str_printing);
			inc(x0, canvas.TextWidth(str_printing) + i_delta[i]);
			j := i_pos[i];inc(i)
		end;
		canvas.TextOut(x0, y0, copy(s, j, MAXINT));
		i_pos := NIL;i_pos := NIL
	end;

label restart_print, retry_switch_fontstyle, fine;
var
	i, j, i_delta_x, y, i_left, i_len : integer;
	xpos, ypos, i_row_height : int_pixel_type;
		// altezza della riga, per calcolare la y-pos della successiva o per effettuare la soppressione se blank
	i_dy_comp : int_pixel_type;	// sfasamento verticale iniziale compensatorio
	vmtr : TTEXTMETRIC;
//	cliprect : TRect;
//	{$ifdef DEBUG} lp_print : array[boolean] of byte; {$endif}	// per non usare inconsapevolmente LP_PRINT
	str_temp, str_print_locale, str_next, str_print_originale, str_left, str_printed : string;
	font : TFont;
	xcanvas: TCanvas;
	f : TFontStyle;
	f_bak : TFontStyles;
//	comportamento_when_null : comportamento_when_null_type;
//	bo_null_locale : boolean;			// TRUE se localmente devo considerare il valore NULL
//	str_value_null_locale : string;	// stringa da stampare a causa del valore NULL
begin		// cl_label.print()
	result := TRUE;
	i_max_y_pixel := 0;
	var i_pl : logical_page_type := get_pagina_logica_attiva_1B;
	{$ifdef DEBUG} assert(pcanvas <> NIL, 'pcanvas -- DUXU 2339'); {$endif}
//	{$ifdef DEBUG} lp_print[FALSE] := 1;lp_print[TRUE] := lp_print[FALSE];lp_print[FALSE] := lp_print[TRUE]; {$endif}	// cosi' ti frego il compiler
	if (ca.show = OSW_HIDE) then exit;
	var i_max_rows : smallint := 0;var i_active_row : smallint := 0;

	var i_delta_y_originale : int_pixel_type := i_delta_y;			// valore originale
	var i_delta_y_originale_video : int_pixel_type := i_delta_y_originale;

	// converto da video a printer
	if bo_video then begin
		x0 := tm.video2print_pixel_x(x0);
		y0 := tm.video2print_pixel_y(y0);
		i_delta_y := tm.video2print_pixel_y(i_delta_y);
		i_delta_y_originale_video := i_delta_y;
//		i_delta_y_bottom := tm.video2print_pixel_y(i_delta_y_bottom);	mai utilizzato
		i_margine_y_pixel := tm.video2print_pixel_y(i_margine_y_pixel)
	end;

	case charcase of
		ecLowerCase : strlower(ca.lp_print);
		ecNormal: ;
		ecUpperCase: strupper(ca.lp_print)
	end;

//	if (tipo in [FORMULA,VARIABILE]) AND (tipo_valore = VAL_NUMERO) then applica_formato_numerico
//	applica_formato_numerico;	**** fino 2016-10-08
	if (ca.tipo_valore = VAL_NUMERO) AND NOT bo_null then applica_formato_numerico;

//	lp_print_originale := NIL;lp_print_locale := NIL;lp_next := NIL;
	if (ca.lp_print_left <> NIL) then begin
		strcpychk(ca.lp_print, ca.lp_print_left);
		strdispose(ca.lp_print_left);ca.lp_print_left := NIL
	end;

//	strcpychk(lp_print_originale, ca.lp_print);		// assegno il comportamento base (tanto per cominciare)
	str_print_originale := ca.lp_print;
{	bo_null_locale := FALSE;
	if bo_null AND (ca.tipo_valore <> VAL_NUMERO) then begin		// i valori NULL di tipo NUMERICO sono già stati trattati
*		bo_null_locale := TRUE;
		if (self.comportamento_when_null = CWNT_REPORT_DEFAULT) then comportamento_when_null := globale.comportamento_when_null
		else comportamento_when_null := self.comportamento_when_null;

		if (comportamento_when_null = xCWNT_USE_VALUE) then begin		// 2016-07-03
			str_value_null_locale := coalesce(ifs(self.comportamento_when_null = xCWNT_USE_VALUE, str_value_when_null), globale.str_value_when_null_text);
			bo_null_locale := (str_value_null_locale <> '');
			if bo_null_locale then strcpychk(lp_print_originale, LPSTR(str_value_null_locale))
		end
	end; }
//	lp_left := lp_print_originale;
	str_left := str_print_originale;

	var bo_hidden := object_is_hidden(ca.show, get_virtual_printing_page, ca.i_section_1B, i_ph_first_page_section, i_ph_last_page_section, TRUE, ptr_print_section)
		OR NOT ca.valuta_print_if(0, caption);
	var bo_font_condizionale := (str_LCF_condizione <> '') AND ca.valuta_boolean_runtime(0, str_LCF_condizione, 'condizione font alternativo');

	// selezione del font da utilizzare
//	if globale.bo_text_only then font := globale.Text_only_font else font := self.font;			// versione originale, fino al 2010-09
//	if globale.bo_text_only then font := globale.Text_only_font else font := self.get_font;
//	if globale.bo_text_only then font := globale.Text_only_font else font := self.get_font(xcanvas);	//	***** mi sembra una puttanata
	if globale.bo_text_only then font := globale.Text_only_font else font := self.get_font;		// 2011-05-08

	// I_DY_COMP: per compensare eventuali influssi non dovuti
	if ca.bo_posizione_fissa then i_dy_comp := -i_delta_y else i_dy_comp := 0;

	var bo_first_loop := TRUE;		// TRUE al primo di stampa, FALSE per tutti gli altri
	if bo_switch_fontstyle then f_bak := font.Style;

restart_print:
	inc(i_active_row);	// 1 per la prima riga, 2 per la seconda, and so on
//	my_PeekMessage;   NO, problemi non banali con la rientranza
//	if bo_null_locale then strcpychk(lp_print_locale, LPSTR(str_value_null_locale)) else strcpychk(lp_print_locale, ca.lp_print);
//	strcpychk(lp_print_locale, ca.lp_print);
	str_print_locale := ca.lp_print;
	if bo_switch_fontstyle then Font.Style := f_bak;

retry_switch_fontstyle:
	if bo_switch_fontstyle then begin
//		f_bak := font.style;
//		str_temp := strpas(lp_print_locale);
		str_temp := str_print_locale;
		for f := fsBold to fsStrikeOut do begin
			if (pos(SFX[f], str_temp) <> 1) then continue;	// solo a inizio riga
			if (str_temp[length(SFX[f]) + 1] = SF_ON) then font.style := font.style + [f] else
			if (str_temp[length(SFX[f]) + 1] = SF_OFF) then font.style := font.style - [f]
			else continue;
			delete(str_temp, 1, length(SFX[f]) + length(SF_ON));
//			strcpy(lp_print_locale, LPSTR(str_temp));
			str_print_locale := str_temp;
			goto retry_switch_fontstyle	// perchè possono esserci più ordini di formattazione non nella giusta sequenza
		end
	end;

//	if bo_font_condizionale then apply_font_condizionale(font);
//canvas.font.style := [fsItalic, fsBold, fsStrikeout];

{$ifdef DEBUG}
//	if (tipo_oggetto in [xxFORMULA, xxVARIABILE]) AND (tipo_valore = VAL_NUMERO) {AND bo_puntato} then begin
	if (ca.tipo_variabile <> TV_STATIC_TEXT) AND (ca.tipo_valore = VAL_NUMERO) {AND bo_puntato} then begin
//		assert(NOT globale.bo_report OR (sections(i_section).printing_values <> NIL),
		assert((globale.tiporeport = TR_LABEL_STANDALONE) OR (sections_1B(ca.i_section_1B).printing_values <> NIL),
			caption + ': sections(i_section).printing_values = NIL');
	end;
{$endif DEBUG}
//	if NOT bo_suppress_blank AND (strlen(lp_print_locale) = 0) then goto fine;
	if NOT bo_suppress_blank AND (str_print_locale = '') then goto fine;
//	rebuild_font({xcanvas});
	pcanvas.Font.Assign(font);vcanvas.Font.Assign(font);	// sempre

	if bo_video then begin
		if globale.bo_text_only then vcanvas.Font.Pixelsperinch := tm.Text_only_video_font_ppi(font.Pixelsperinch)
		else vcanvas.Font.Pixelsperinch := round(tm.r_pixel_per_inch_video_x)
	end;

	// verifica dimensione; se non ci sta nel campo, riduco il font
	if bo_riduci_if_necessario AND NOT globale.bo_text_only then begin
		if (i_font_ridotto_size = 0) then begin
			str_temp := str_print_locale;
			i := -1;
			j := tm.video2print_pixel_x(width);
			with pcanvas, font do begin
				repeat
					if (i <> -1) then begin
						i_font_ridotto_size := size - piumeno(size >= 0);
						size := i_font_ridotto_size
					end;
					i := TextWidth(str_temp)	// dimensione del testo
				until (i <= j) OR (abs(size) <= i_minimum_size_auto)
			end
		end
		else pcanvas.Font.Size := i_font_ridotto_size
	end;

{	bo_acapo := FALSE;
	strcpychk(lp_next, '');lp_temp := strpos(lp_print_locale, ACAPO);	// verifico eventuali ACAPO
	if (lp_temp = NIL) then lp_temp := strpos(lp_print_locale, ACAPO_ROVESCIATO);
	if (lp_temp <> NIL) then begin
		bo_acapo := TRUE;
		strcpychk(lp_next, @lp_temp[strlen(ACAPO)]);
		lp_temp[0] := #0;					// chiudo la stringa LP_PRINT
		strcat(lp_print_locale, ' ')	// aggiungo uno spazio per consentire la divisione della parola
	end; }

	str_next := '';
	var bo_acapo := FALSE;		// TRUE se il testo da stampare contiene un ACAPO
	i := pos(ACAPO, str_print_locale);
	if (i = 0) then i := pos(ACAPO_ROVESCIATO, str_print_locale);
	if (i <> 0) then begin
		bo_acapo := TRUE;
		str_next := copy(str_print_locale, i + ACAPO.Length);
		setLength(str_print_locale, i-1);
		str_print_locale := str_print_locale + ' '	// aggiungo uno spazio per consentire la divisione della parola
	end;

	if autosize then i := i_Vpage_size_X_pix_print(i_pl) {-i_left}	// tutto lo spazio disponibile
	else i := tm.video2print_pixel_x(Width);
//	if (strlen(lp_print_locale) > 1) AND (pcanvas.TextWidth(strpas(lp_print_locale)) > i) then begin
	if (str_print_locale.Length > 1) AND (pcanvas.TextWidth(str_print_locale) > i) then begin
		i_len := str_print_locale.Length;str_temp := str_print_locale;

		j := 1;i_left := 1;
		// le stringhe valutate in media non sono lunghissime; mi fermo a MAX_FATTORE_FORMATTAZIONE per evitare di
		while (i_left < MAX_FATTORE_FORMATTAZIONE) AND (i_left < i_len div 2) do i_left := i_left * 2;
		while (i_left > 0) do begin
			while (j+i_left <= i_len) AND (pcanvas.TextWidth(LeftStr(str_temp, j+i_left-1)) <= i) do inc(j, i_left);
			i_left := i_left div 2
		end;
//		i_left := j;

		// J-1 caratteri sono la len max stampabile
//		lp_temp := stralloc((i_len-j+1) + integer(strlen(lp_next)) + 1);
//		strcpy(lp_temp, @lp_print_locale[j-1]);strcat(lp_temp, lp_next);
		str_next := copy(str_print_locale, j, MAXINT) + str_next;
		setLength(str_print_locale, j-1);
		bo_acapo := FALSE					// sono andato a capo perchè la riga era troppo lunga (non perchè c'era un ACAPO)
	end;

//	if bo_multiline AND (strlen(lp_next) <> 0) then begin
	if bo_multiline AND (str_next <> '') then begin
//		if (lp_next[0] <> ' ') then begin
		if NOT str_next.StartsWith(' ') then begin
			i := str_print_locale.Length;
//			while (i > 0) AND NOT (lp_print_locale[i-1] in [' '] + PRE_SEPARATORI + POST_SEPARATORI) do dec(i);
//			while (i > 0) AND NOT CharInSet(lp_print_locale[i-1], [' '] + PRE_SEPARATORI + POST_SEPARATORI) do dec(i);
			while (i > 0) AND NOT CharInSet(str_print_locale[i], [' '] + PRE_SEPARATORI + POST_SEPARATORI) do dec(i);
//			if (i > 0) AND (i <> integer(strlen(lp_print_locale))) then begin
			if (i > 0) AND (i <> str_print_locale.Length) then begin
//				if (lp_print_locale[i-1] = ' ') then begin j := i;i := i+1 end else
				if (str_print_locale[i] = ' ') then begin j := i;inc(i) end else
//				if (lp_print_locale[i-1] in PRE_SEPARATORI) then begin
//				if CharInSet(lp_print_locale[i-1], PRE_SEPARATORI) then begin
				if CharInSet(str_print_locale[i], PRE_SEPARATORI) then begin
					if (i = 1) then i := str_print_locale.Length;
					j := i
				end else
//				if (lp_print_locale[i-1] in POST_SEPARATORI) then begin i := i + 1;j := i end
//				if CharInSet(lp_print_locale[i-1], POST_SEPARATORI) then begin i := i + 1;j := i end
				if CharInSet(str_print_locale[i], POST_SEPARATORI) then begin inc(i);j := i end
				else begin
					{$ifdef DEBUG} assert(FALSE, 'print: errore strutturale JHCX 2873'); {$endif}
					j := 0	// solo per il compilatore
				end;
//				lp_temp := NIL;strcpychk(lp_temp, lp_next);
//				strcpychk(lp_next, @lp_print_locale[i-1]);
//				strcat(lp_next, lp_temp);strdispose(lp_temp);
				str_next := copy(str_print_locale, i, MAXINT) + str_next;
//				lp_print_locale[j-1] := #0
				setLength(str_print_locale, j-1)
			end
		end;
//		lp_togliblanks(lp_next);lp_togliblanks_eoln(lp_print_locale)
//		str_next := str_next.Trim;str_print_locale := str_print_locale.TrimRight
		str_next := togliblanks(str_next);str_print_locale := togliblanks_eoln(str_print_locale)
	end;

	i_delta_x := 0;
//	if NOT autosize AND (NOT bo_giustificato OR (strlen(lp_next) = 0)) then begin
	if NOT autosize AND (NOT bo_giustificato OR (str_next = '')) then begin
		case alignment of
			TaleftJustify : ;
			TaCenter : i_delta_x := MAX(tm.video2print_pixel_x(width) - pcanvas.TextWidth(str_print_locale), 0) div 2;
			TaRightJustify : i_delta_x := MAX(tm.video2print_pixel_x(width) - pcanvas.TextWidth(str_print_locale), 0)
		end
	end;

	if bo_centrato then begin	// centro orizzontalmente sulla pagina
//		i_left := tm.ai_page_size_X_pix_print - pcanvas.TextWidth(strpas(lp_print_locale));	// così fino al 23/04/99
		if autosize then i_left := i_Vpage_size_X_pix_print(i_pl) - pcanvas.TextWidth(str_print_locale)
		else i_left := i_Vpage_size_X_pix_print(i_pl) - tm.video2print_pixel_x(Width);
		i_left := MAX(i_left div 2, 0)
	end
	else i_left := tm.video2print_pixel_x(Left);

	{ calcolo della posizione verticale della scritta;
	  il calcolo viene eseguito in funzione della baseline della scritta, perchè l'obbiettivo è l'allineamento delle basi delle scritte, se possibile;
	  si calcola l'altezza effettiva della scritta e si impone il top dell'output in funzione della posizione effettiva della base del carattere;
	  per evitare in stampa difformità di comportamento rispetto a quello che avviene a video, eseguo la base del calcolo sul canvas video,
	  e poi ne riporto i risultato in termini di printer-pixel;
	  potrebbe capitare che due oggetti diversi (font diverso, ad esempio), che a video si comportano allo stesso modo
	  (e che peraltro sono stati allineati utilizzando esclusivamente unità di misura video), in stampa diano altezza differenti,
	  causando problemi di bottom-allineamento;
	  if BO_VIDEO GetTextMetrics viene seguito sempre su VCANVAS perchè purtroppo non posso utilizzare GetTextMetrics su PCANVAS se non c'è una stampa in corso }
	assign_font_to(vcanvas.Font);
	GetTextMetrics(vcanvas.Handle, vmtr);
	if bo_video then begin
//		y := distanza tra il TOP e la base della scritta; funziona se I_FONT_RIDOTTO_SIZE = 0
		j := Top + vmtr.tmAscent;
		if (i_font_ridotto_size <> 0) then begin
			vcanvas.Font.Size := i_font_ridotto_size;		// per la visualizzazione in anteprima
			GetTextMetrics(vcanvas.Handle, vmtr)
		end;
		y := tm.video2print_pixel_y(j - vmtr.tmAscent)
	end
	else begin
		pcanvas.Font.Color := vcanvas.Font.Color;		// 2021-10-19 per assegnare il colore in stampa
		j := tm.video2print_pixel_y(Top + vmtr.tmAscent);
		// calcola la distanza tra il TOP e la base della scritta in stampa
		GetTextMetrics(pcanvas.Handle, vmtr);
		y := j - vmtr.tmAscent
	end;

	if (i_max_rows = 0) then begin
		if (self.i_max_rows = 0) then begin
			if bo_multiline AND (fl_max_vertical_size_cm <> 0) then begin
				if (fl_cm_interlinea = 0) then begin
					if globale.bo_text_only then i_row_height := cm2pixel_print_y(tm.Text_only_line_height_cm)
					else begin
						i_row_height := vmtr.tmHeight + vmtr.tmExternalLeading;
						if bo_video then i_row_height := tm.video2print_pixel_y(i_row_height)	// vmtr è letto da VCANVAS
					end
				end
				else i_row_height := cm2pixel_print_x(fl_cm_interlinea);
				i_max_rows := max(trunc(cm2pixel_print_x(fl_max_vertical_size_cm) / i_row_height), 1)
			end
			else i_max_rows := 9999
		end
		else i_max_rows := self.i_max_rows
	end;

	if globale.bo_text_only then begin
//		{$ifdef DEBUG} assert(FALSE,'da verificare: FEAX 1619'); {$endif}
		i_row_height := cm2pixel_print_y(tm.Text_only_line_height_cm)
	end
	else begin
		i_row_height := vmtr.tmHeight + vmtr.tmExternalLeading;
		if bo_video then i_row_height := tm.video2print_pixel_y(i_row_height)	// vmtr è letto da VCANVAS
	end;

	// --------------------------------------------------------------------------

//	if (lp_next = NIL) OR NOT bo_multiline then i := 0 else i := strlen(lp_next);
	if (str_next = '') OR NOT bo_multiline then i := 0 else i := str_next.Length;
	inc(i, str_print_locale.Length);
	if bo_suppress_blank AND (bo_hidden OR (i = 0)) then dec(i_delta_y, i_row_height);

	// aggiungo la stringa stampata (anche nel caso BO_HIDDEN, perchè comunque servirà)
	if (str_printed <> '') OR NOT bo_first_loop then str_printed := str_printed + ACAPO;
//	str_printed := str_printed + strpas(lp_print_locale);
	str_printed := str_printed + str_print_locale;

	// stampo solo se c'è qualcosa da stampare
	if NOT bo_hidden AND NOT ((i = 0) AND bo_suppress_blank) then begin
		i_max_y_pixel := y + i_delta_y + i_dy_comp + i_row_height;
		if (i_margine_y_pixel = 0) OR (i_max_y_pixel <= i_margine_y_pixel) then begin
			i := x0 + i_left + i_delta_x;
			j := y0 + y + i_delta_y + i_dy_comp;

			ca.x_print_exec := i;ca.y_print_exec := j;		// coordinate di stampa effettive
			ca.dx_print_exec := Width;ca.dy_print_exec := Height;

			if NOT bo_video AND globale.bo_text_only then begin
				j := j div cm2pixel_print_y(tm.Text_only_line_height_cm) + 1;	// riga
				i := tm.printpixel2colonne(i) + 1;	// colonna
				text_only_print(j, i, str_print_locale)
			end
			else begin
				if bo_video then begin
					xcanvas := vcanvas;
					if (tm.r_fattore_zoom <> 1) then begin
						i := round((x0 + i_left + i_delta_x) * tm.r_fattore_zoom);
						j := y0 + i_delta_y + round((y + i_dy_comp) * tm.r_fattore_zoom)
					end;
					i := tm.print2video_pixel_x(i);
					j := tm.print2video_pixel_y(j)
				end
				else xcanvas := pcanvas;

				if bo_font_condizionale then apply_font_condizionale(xcanvas.Font);
				var lo_actual_color : TColor := xcanvas.Font.Color;

				var i_delta_left : integer;var i_delta_top : integer := 0;
				{if (FAngle <> 0) then} calculate_textXYpos(xcanvas, i_delta_left, i_delta_top);		// 2021-03-29 (serve per trattare gli oggetti con Font non orizzontale)

				if (str_next <> '') AND NOT Autosize AND bo_giustificato AND NOT bo_acapo then
					print_giustificato(xcanvas, str_print_locale, i, j)
				else begin
//					if bo_video then begin xpos := TextXPos;ypos := TextYPos end else begin xpos := tm.video2print_pixel_x(TextXPos);ypos := tm.video2print_pixel_y(TextYPos) end;
					xpos := TextXPos;ypos := TextYPos;
//xcanvas.font.Color := clRed;xcanvas.Font.Style := [fsItalic, fsBold, fsStrikeout];
//					xcanvas.TextOut(xpos + i, ypos + j, strpas(lp_print_locale))
					TextOut(xcanvas, xpos + i, ypos + j, str_print_locale, lo_actual_color)
{					if bo_video then xcanvas.TextOut(TextXPos + i, TextYPos + j, strpas(lp_print_locale))
					else write_context(pcanvas, TextXPos + i, TextYPos + j, strpas(lp_print_locale)) {}
				end
			end
			{	non clippo perchè non funge
				if (TRUE OR bo_video) then canvas.TextOut(x0+i_left+i_delta_x,y0+y,str_print ??? )
				else begin
					// clippo il rettangolo dell'etichetta per evitare debordamenti
					if (ptcr = NIL) then cliprect := canvas.ClipRect else cliprect := ptcr^;
					canvas.TextRect(cliprect,x0+i_left+i_delta_x,y0+y,str_print ??? )
				end; }
		end
		else begin	// oggetto instampabile
			if bo_can_break_object then begin
//				if (tipo_oggetto = xxFORMULA) then begin
				if (ca.tipo_variabile = TV_FORMULA) then begin
					MessageBBox(get_handle(father), 'ERRORE: la formula <' + uppercase(Caption) + '> occupa più d''una pagina.' + ACAPO +
						'Utilizza in sua vece una variabile statica.', MBOX_CAPTION, MB_ICONSTOP);
					abort
				end;
				{ carico la parte stampata su SELF.LP_PRINT, la parte non stampata su LP_PRINT_LEFT;
				  la cosa non è del tutto banale per via delle modifiche effettuate sulla stringa }
//				strcpychk(lp_print_left,lp_left);lp_left[0] := #0;
				strcpychk(ca.lp_print_left, ca.lp_print);	// indico cosa deve ancora essere stampato
//				strdispose(self.lp_print);self.lp_print := NIL;
//				strcpychk(self.lp_print,lp_print_originale)	// rialloco solo la parte necessaria
//				strcpychk(self.lp_print,LPSTR(str_printed))
//				str_temp := copy(str_printed, 1, length(str_printed) - integer(strlen(lp_print_locale)));
				str_temp := copy(str_printed, 1, str_printed.Length - str_print_locale.Length);
				strcpychk(ca.lp_print, LPSTR(str_temp))
			end;
			result := FALSE	// l'oggetto non è stato stampato (o quanto meno non completamente)
		end
	end;

	if result then begin
		var bo := NOT bo_hidden AND bo_multiline AND (str_next <> '');
		if bo AND (i_max_rows <> 0) AND (i_active_row = i_max_rows) then bo := FALSE;
		if bo then begin
			i := str_print_locale.Length;
//			if (i > 0) AND (lp_print_locale[i-1] = ' ') then begin	// tolgo un eventuale spazio sostitutivo dell'ACAPO
			if (i > 0) AND (str_print_locale[i] = ' ') then begin		// tolgo un eventuale spazio sostitutivo dell'ACAPO
//				lp_print_locale[i-1] := #0;dec(i)
				setLength(str_print_locale, i-1);dec(i)
			end;
			if (i > 0) then begin
//				{$ifdef DEBUG} if (strpos(lp_left, lp_print_locale) = NIL) then assert(FALSE,'LABEL.PRINT: errore in positioning lp_left'); {$endif}
{				lp_left := strpos(lp_left, lp_print_locale);
				lp_left := @lp_left[strlen(lp_print_locale)] }
				j := pos(str_print_locale, str_left);
				{$ifdef DEBUG} assert(j <> 0, 'LABEL.PRINT: errore in positioning lp_left'); {$endif}
				str_left := copy(str_left, j + str_print_locale.Length, MAXINT)
			end;
//			lp_togliblanks(lp_left);		// tolgo eventuali spazî dopo il fine riga (ma prima di un eventuale ACAPO)
//			str_left := str_left.Trim;		// tolgo eventuali spazî dopo il fine riga (ma prima di un eventuale ACAPO)
			str_left := togliblanks(str_left);		// tolgo eventuali spazî dopo il fine riga (ma prima di un eventuale ACAPO)
//			if (lp_left[0] = ' ') then lp_left := @lp_left[1];		// tolgo lo spazio che è stato usato per andare a capo
			if str_left.StartsWith(' ') then delete(str_left, 1 ,1);		// tolgo lo spazio che è stato usato per andare a capo
//			if (strlen(lp_left) >= 2) AND (lp_left[0] in [#13,#10]) AND (lp_left[1] in [#13, #10]) then lp_left := @lp_left[2];
//			if (strlen(lp_left) >= 2) AND CharInSet(lp_left[0], [#13,#10]) AND CharInSet(lp_left[1], [#13, #10]) then lp_left := @lp_left[2];
			if (str_left.Length >= 2) AND CharInSet(str_left[1], [#13, #10]) AND CharInSet(str_left[2], [#13, #10]) then delete(str_left, 1, ACAPO.Length);
//			strcpychk(lp_next, lp_left);strcpychk(ca.lp_print, lp_next);
			str_next := str_left;strcpychk(ca.lp_print, LPSTR(str_next));

			if (fl_cm_interlinea = 0) OR globale.bo_text_only then i := i_row_height else i := cm2pixel_print_x(fl_cm_interlinea);
			inc(i_delta_y, i);
			bo_first_loop := FALSE;
			goto restart_print	// procedo ad un'altro ciclo di stampa
		end;
//		strcpychk(self.lp_print,lp_print_originale)
		strcpychk(ca.lp_print, LPSTR(str_printed))
	end;
fine:

	i_max_y_pixel := tm.print2video_pixel_y(i_max_y_pixel);
	// verifico se l'oggetto modifica la posizione degli altri oggetti
//	if NOT ca.bo_move_obj_sottostanti then i_delta_y := i_delta_y_originale		COSI' FINO al 2006-01-10
//	if ((i_delta_y > 0) AND NOT ca.bo_move_obj_sottostanti) OR					// dal 2006-01-11 al 2006-02-11
//		((i_delta_y < 0) AND NOT bo_suppress_blank)
	if ((i_delta_y > i_delta_y_originale_video) AND NOT ca.bo_move_obj_sottostanti) OR	// dal 2006-02-11
		((i_delta_y < i_delta_y_originale_video) AND NOT bo_suppress_blank)
	then i_delta_y := i_delta_y_originale
	else begin
		if bo_video then begin
			i_delta_y := tm.print2video_pixel_y(i_delta_y);
{$ifdef DEBUG}
			assert(i_delta_y_originale = tm.print2video_pixel_y(tm.video2print_pixel_y(i_delta_y_originale)), 'CANY 1932');
			if (i_delta_y <> i_delta_y_originale) AND
				(i_delta_y = tm.print2video_pixel_y(tm.video2print_pixel_y(i_delta_y_originale)))
			then assert(FALSE, 'video -> print -> video <> VIDEO -- NXBZ 2631');
{$endif DEBUG}
		end
	end;

	if bo_switch_fontstyle then font.Style := f_bak;
//	strdispose(lp_print_locale);strdispose(lp_next);strdispose(lp_print_originale)
end;

{$endif CASA}

function cl_label.get_cifre_round : shortint;
begin
{$ifdef GALATEO_EXE}
	result := i_cifre_round_phisical
{$else}
	if (str_round_formula = '') then result := i_cifre_round_phisical
	else begin
		var s : string;
		var ris : risultato_type := VAL_NUMERO;
		if translate_formula(str_round_formula, s, {test}FALSE, ris, NIL) then result := -s.ToInteger else result := 0
	end
{$endif}
end;

function cl_label.valuta_runtime_if(handle : hwnd;str_condizione : string) : boolean;
{ rende TRUE se la condizione è vera;
  emette eventuali messaggi di errore;
  la funzione è stata costruita per verificare STR_RUNTIME_ASK_IF, ed è successivamente stata estesa }
const MBOX_CAPTION = 'Domanda a runtime se ...';
var str_msg : string;	//*
begin
//	str_print_if := togliblanks(str_print_if);
	try
		if NOT bo_ask_runtime then begin result := FALSE;exit end;
		if (str_condizione = '') then begin result := TRUE;exit end;
		if NOT interpreta_boolean_expression(str_condizione, FALSE, result, str_msg) then abort
	except
		MessageBBox(handle, str_msg, MBOX_CAPTION + ' [' + caption + ']', MB_ICONSTOP)
	end
end;

{$ifdef GALATEO_EXE}
	function cl_label.check_runtime_if(handle : hwnd;str_condizione : string) : boolean;
	{ esegue un controllo su STR_PRINT_IF; rende TRUE se tutto ok, FALSE se trova errori;
	  emette eventuali messaggi di errore }
	const MBOX_CAPTION = 'Domanda a runtime se ...';
	var
		bo : boolean;	//*
		str_msg : string;
	begin
		result := TRUE;
		if NOT bo_ask_runtime then exit;
		str_condizione := togliblanks(str_condizione);
		if (str_condizione = '') then exit;
		result := interpreta_boolean_expression(str_condizione, TRUE, bo, str_msg);
		if NOT result then MessageBBox(handle,str_msg,MBOX_CAPTION + ' [' + caption + ']',MB_ICONSTOP)
	end;

{$endif GALATEO_EXE}

function cl_label.get_runtime_caption : string;
begin
//	if (str_runtime_caption = '') then result := caption else result := str_runtime_caption + ' [' + caption + ']'
	result := uppercase(caption) + ifs(xstr_runtime_caption, ' (' + xstr_runtime_caption + ')')
end;

function cl_label.ZB_get_integral_exportable(i_profilo : expint_index_type;i_logical_page_ZB : logical_page_type;bo_visible : boolean = TRUE) : boolean;
{ rende TRUE se il campo deve essere considerato nell'exportazione integrale;
  lasciare BO_VISIBLE qualora si stia parlando del campo genericamente inteso, oppure passare il valore specifico qualora si stia parlando
  di una specifica istanza del campo;

  il valore restituito dalla sezione vale sia a DESIGN-TIME che a RUNTIME, nel senso che a livello del singolo campo non vi è differenza tra i due contesti;
  la differenza può esserci, invece, a livello della sezione cui il campo appartiene;
  in ogni caso: se la sezione cui il campo appartiene non è esportabile in nessun caso (SEXP_IMPOSSIBLE), neanche il campo è considerato exportabile
  in tutti gli altri casi il campo resta exportabile (anche se la sezione è SEXP_NOT) }
begin
	result := FALSE;
//	if NOT sections_ZB(ca.i_section_1B - 1, i_logical_page_ZB).exportabile_integrale(i_profilo, {runtime}FALSE) then exit;		*** così fino 2023-07-15
	if NOT sections_ZB(ca.i_section_1B - 1, i_logical_page_ZB).exportabile_integrale(i_profilo, {runtime}TRUE) then exit;
//	if bo_runtime then oet := ZB_get_running_export_type(i_profilo, i_logical_page_ZB) else oet := get_expint_object(i_profilo).expint_mode;
	var oet : object_expint_mode_type := get_expint_object(i_profilo).expint_mode;
	if (oet = OEXP_DEFAULT) then oet := ZB_get_running_export_type(i_profilo, i_logical_page_ZB);
	case oet of
		OEXP_YES : ;
		OEXP_NOT : exit;
		else begin
			if NOT bo_visible OR (ca.show = OSW_HIDE) then exit;
			if NOT (ca.tipo_variabile in [TV_FORMULA, TV_DB_FIELD, TV_SQL_SELECT]) then exit
		end
	end;
	result := TRUE
end;

function cl_label.ZB_get_running_export_type(i_profilo : expint_index_type;i_logical_page_ZB : logical_page_type) : object_expint_mode_type;
{ se I_PROFILO = -1 rende il valore MOST-EXPORTABLE tra tutti i profili;
		se almeno un profilo è OEXP_YES, rende OEXP_YES,
		altrimenti se almeno un profilo è OEXP_DEFAULT, rende OEXP_DEFAULT,
		altrimenti rende OEXP_NOT }
begin
//	if (expint_mode = OEXP_DEFAULT) then result := sections(ca.i_section, i_logical_page).export_type_fields_default else result := expint_mode
{	***** così fino 2023-07-15 **** equivale a tutte le 22 righe seguenti
	result := get_expint_object(i_profilo).expint_mode;
	if (result = OEXP_DEFAULT) then result := get_expint_section_ZB(i_profilo, i_logical_page_ZB, ca.i_section_1B - 1).expint_objs_default_mode }
	if (i_profilo = -1) then begin
		result := OEXP_NOT;
		for var i : smallint := 0 to high(globale.expint_profiles) do begin
			var prof : cl_expint_profilo := globale.expint_profiles[i];
			if NOT prof.bo_dont_show AND prof.expint_pages[i_logical_page_ZB].bo_export_allowed then
				result := MOST_exportable(result, get_expint_object(i).expint_mode)
		end;

		if (result = OEXP_DEFAULT) then begin
			result := OEXP_NOT;
			for var i : smallint := 0 to high(globale.expint_profiles) do
				result := MOST_exportable(result, get_expint_section_ZB(i, i_logical_page_ZB, ca.i_section_1B - 1).expint_objs_default_mode)
		end
	end
	else begin
		var prof : cl_expint_profilo := globale.expint_profiles[i_profilo];
		if NOT prof.bo_dont_show AND prof.expint_pages[i_logical_page_ZB].bo_export_allowed then begin
			result := get_expint_object(i_profilo).expint_mode;
			if (result = OEXP_DEFAULT) then result := get_expint_section_ZB(i_profilo, i_logical_page_ZB, ca.i_section_1B - 1).expint_objs_default_mode
		end
		else result := OEXP_NOT	// pagina/profilo da non esportare, ovviamente non si esporta neppure l'oggetto
	end
end;

// -----------------------------------------------------------------------------

const
	RST_OPZIONE : array[succ(RST_BLANK)..high(runtime_script_type)] of string = (RST_SET_VALUE_OPTION, RST_RELOAD_COMBO_OPTION);
	RST_OPZIONI_APPLY_ON_OTHER_PARAMETRO = [RST_SETVALUE, RST_RELOAD_COMBO];	// opzioni che prevedono l'applicazione di effetti su un altro parametro

	RSE_OPZIONE : array[runtime_script_event] of string = (
		{blank}'', RSE_ON_UPDATE_TEXT, RSE_ON_ENTER_TEXT, {RSE_ON_DROPDOWN}'',
		RSE_ON_CLOSEUP_TEXT, RSE_ON_EXIT_TEXT, RSE_ON_CLOSEUP_WC_TEXT, RSE_ON_EXIT_WC_TEXT);

procedure cl_runtime_script.reset;
begin
	tipo := RST_BLANK;
	str_apply_on_parametro := '';str_value := '';
	execute_on_events := RSE_DEFAULT
end;

function cl_runtime_script.read_from_text(str_text : string;bo_error_msg : boolean) : boolean;
const MBOX_CAPTION = 'Script runtime';
var i : smallint;	//*
begin
	bo_error_msg := TRUE;
	result := FALSE;var str_originale := str_text;
	try
		reset;
		for var rst : runtime_script_type := succ(RST_BLANK) to high(rst) do begin
			if start_with(str_text, RST_OPZIONE[rst], FALSE) then begin
				tipo := rst;
				delete(str_text, 1, length(RST_OPZIONE[rst]));str_text := togliblanks(str_text);
				break
			end
		end;
		if (tipo = RST_BLANK) then raise exception.create('Tipo di opzione non identificato' + ACAPO2 + str_originale);

		if (tipo in RST_OPZIONI_APPLY_ON_OTHER_PARAMETRO) then begin
			if NOT start_with(str_text, '(') then raise exception.create('Era atteso il carattere ''(''' + ACAPO2 + str_originale);
			i := pos(')', str_text);if (i = 0) then raise exception.create('Era atteso il carattere '')''' + ACAPO2 + str_originale);
			str_apply_on_parametro := togliblanks(copy(str_text, 2, i-1-1));
//			x := name2obj(str_apply_on_parametro, [xxTESTO, xxVARIABILE], {all_pages}TRUE);	**** fino 2011-05-17
			var x : objs_type := name2obj(str_apply_on_parametro, [TV_STATIC_TEXT] + TV_OLD_VARIABILI, {all_pages}TRUE);
			if (x = NIL) then raise exception.create('Oggetto non riconosciuto: ' + str_apply_on_parametro + ACAPO2 + str_originale);
			str_text := togliblanks(copy(str_text, i+1, MAXINT))
		end;

		case tipo of
			RST_SETVALUE : begin
				if NOT start_with(str_text, '=') then raise exception.create('Era atteso il carattere ''=''' + ACAPO2 + str_originale);
				str_text := togliblanks(copy(str_text, 2, MAXINT));
				i := pos(';/', str_text);
				if (i = 0) then i := length(str_text) + 1;
				str_value := copy(str_text, 1, i-1);delete(str_text, 1, i-1)
			end;
			RST_RELOAD_COMBO : begin
//				if (x.aslabel.
			end;
			else begin
				{$ifdef DEBUG} assert(FALSE, 'tipo RST non gestito -- DJHW 8938'); {$endif}
				exit
			end
		end;
		if start_with(str_text, ';') then begin
			str_text := togliblanks(copy(str_text, 2, MAXINT));
			var bo_first := TRUE;
			for var rse : runtime_script_event := high(rse) downto low(rse) do begin	// alla rovescia perchè altrimenti cerca prima /ON_EXIT di /ON_EXIT_WC, e il giochino non funziona più
				if (rse in RSE_SCRIPT_REFERENZIABILI) AND start_with(str_text, RSE_OPZIONE[rse], FALSE) then begin
					str_text := togliblanks(copy(str_text, length(RSE_OPZIONE[rse])+1, MAXINT));
					if start_with(str_text, ';') then begin delete(str_text, 1, 1);str_text := togliblanks(str_text) end;
					if bo_first then begin bo_first := FALSE;execute_on_events := [] end;
					if (rse in execute_on_events) then raise exception.Create('Opzione ripetuta: ' + RSE_OPZIONE[rse] + ACAPO2 + str_originale);
					execute_on_events := execute_on_events + [rse]
				end
			end
		end;	
		if (str_text <> '') then raise exception.create('E'' presente del testo non atteso alla fine della riga' + ACAPO2 + str_originale);

		result := TRUE
	except
		if bo_error_msg then error_msg('', MBOX_CAPTION)
	end
end;

// -----------------------------------------------------------------------------

{$ifdef GALATEO_EXE}
	constructor cl_runtime_scripts.create(handle : hwnd);
	begin
		self.handle := handle
	end;

	destructor cl_runtime_scripts.free;
	begin
		for var i : smallint := 0 to high(sx) do sx[i].free;
		sx := NIL
	end;

{$endif GALATEO_EXE}

function cl_runtime_scripts.get_text : string;
begin
	result := str_text
end;

function cl_runtime_scripts.read_text(str_text : string) : boolean;
// legge e traduce il testo specificato; rende TRUE se tutto OK, FALSE se contiene errori che obbligano a modifiche dell'utente
var str_line, str_context : string;	//*
begin
	result := FALSE;var bo_error_msg := FALSE;
	var i_riga : integer := 0;var i : smallint := 0;
	try
		while (str_text <> '') do begin
			var str_temp := get_line(str_text, i_riga);
			var j : smallint := pos('//',str_temp);if (j <> 0) then delete(str_temp,j,MAXINT);
			str_temp := togliblanks_eoln(str_temp);
			if end_with(str_temp, '_') then begin
				if (str_text = '') then raise exception.create('Ultima riga non valida');
				str_line := str_line + togliblanks(copy(str_temp,1,length(str_temp)-1));
				continue
			end;
			str_line := togliblanks(str_line + str_temp);
			if (str_line = '') OR start_with(str_line,';') {OR start_with(str_line,'//')} then begin str_line := '';continue end;
{			if get_macro(str_line, macros) then begin str_line := '';continue end;
			str_line := translate_macros(str_line);
			str_line := translate_SQL(str_line, FALSE, FALSE); }

{			if start_with(str_line, SCR_VARIABILE_VALIDAZIONE,FALSE) then begin
//				bo_first_line := FALSE;
				j := length(valid);
				setLength(valid, j+1);
				valid[j] := cl_script_validazione.create(i);
				if NOT valid[j].read_from_text(handle,str_line,bo_error_msg) then abort;
				str_temp := translate_SQL(valid[j].str_condizione, TRUE, TRUE);	// traduco forzatamente (e falsamente) l'eventuale SQL
				valuta_predicato(i, str_temp, TRUE);	// verifico la regola di validazione
				str_line := '';continue
			end; }

			setLength(sx,i+1);
			sx[i] := cl_runtime_script.create;
			if NOT sx[i].read_from_text(str_line,bo_error_msg) then abort;
			inc(i);str_line := ''
		end;

(*		try
			// dopo aver caricato tutte le varianti, eseguo la verifica degli EXEC
			i_riga := 0;	// per evitare
			for i := 0 to high(vx) do begin
				str_context := {'variante ' +} vx[i].str_codice;
				for j := 0 to high(vx[i].exec_commands) do execute_after_assegnazione(i, j, {test}TRUE)
			end
		except
			if bo_error_msg then error_msg(handle,'Errore durante l''interpretazione della variabile -- ' + str_context,MBOX_CAPTION);
			abort
		end; *)

		result := TRUE
	except
		if (i_riga <> 0) then str_context := 'riga ' + i_riga.ToString;
		if bo_error_msg then error_msg('Errore durante l''interpretazione della variabile -- ' + str_context, MBOX_CAPTION)
	end
end;

function cl_runtime_scripts.set_text(str_text : string): boolean;
// assegna il testo specificato, previa controllo sintattico
begin
	if (str_text = self.str_text) then result := TRUE
	else begin
		result := read_text(str_text);
		if result then self.str_text := str_text
	end
end;

{$ifdef GALATEO_EXE}
	function runtime_scripts_validate(father : TForm; lab : cl_label;str_runtime_scripts : string) : boolean;
	begin
		var r : cl_runtime_scripts := cl_runtime_scripts.create(get_handle(father));
		try
			result := r.set_text(str_runtime_scripts)
		finally
			r.free
		end
	end;
{$endif GALATEO_EXE}

{$ifdef DEBUG}
	procedure stats_report;
	var f : text;
	begin
		if (i_old = 0) then exit;	// nothing to write
		{$I-}
		assign(f, 'e:\stat-galateo.txt');append(f);
		if (IOresult <> 0) then rewrite(f);
		if (IOresult <> 0) then exit;
		writeln(f, dttime2SQL(now, FALSE, TMFMT_HM), ^I, MAX_FATTORE_FORMATTAZIONE, ^I, i_old, ^I, i_new);
		close(f)
		{$I+}
	end;
{$endif}

{ TFLabel }

function cl_label.get_expint_object(i_profilo : expint_index_type = -1) : cl_expint_object;
begin
	if (i_profilo = -1) then i_profilo := max(globale.i_active_expint_profile, 0);
	result := expint[i_profilo]
end;

function cl_label.get_runtime_default : string;
// restituisce il valore nudo e crudo del default, non tradotto nè interpretato (cosa che deve avvenire in funzione del contesto)
begin
	result := coalesce(ifs(globale.bo_debug_base, str_runtime_default_debug_phisical), str_runtime_default_phisical)
end;

procedure cl_label.apply_font_condizionale(f : TFont);

	procedure applica_style(box : xboolean;fs : TFontStyle);
	begin
		case box of
			XTRUE : f.Style := f.Style + [fs];
			XFALSE : f.Style := f.Style - [fs]
			else
		end
	end;

begin
	applica_style(box_LCF_bold, fsBold);
	applica_style(box_LCF_underline, fsUnderline);
	applica_style(box_LCF_italic, fsItalic);
	applica_style(box_LCF_strikeout, fsStrikeout);
	f.Color := LCF_foreground_color;
//	txt.Color := coalesce(LCF_background_color, clBtnFace)
end;

initialization
	galateo_initialization_debug('labels')
finalization
	galateo_finalization_debug('labels');
{$ifdef DEBUG}
	stats_report;
	CCI(i_labels, 'cl_label', 'labels.pas')
{$endif}
end.
