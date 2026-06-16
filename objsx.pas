unit objsx;		//*

{$I defines}
{$ifdef PROVA_FAST} {$R-,S-} {$endif}

interface

uses Windows, SysUtils, StdCtrls, Classes,
	FCommons, gdich;

type
	cl_common_attributes = class	// caratteristiche comuni a tutti i tipi di oggetto
		private
{$ifdef DEBUG}
			tipo_variabile_phisical : variabile_type;
			procedure set_tipo_variabile(tv : variabile_type);
{$endif}
		public
{$ifdef DEBUG}
			property tipo_variabile : variabile_type read tipo_variabile_phisical write set_tipo_variabile;
			procedure check_tipo_variabile(tv : variabile_type;str_caption : string);
{$else}
			tipo_variabile : variabile_type;
{$endif}
		private
			function get_log_query_SQL : boolean;			// esegue il log dell'istruzione SQL (se richiesto dai parametri generali)
		public
			bo_log_query_SQL_phisical : boolean;
			property bo_log_query_SQL : boolean read get_log_query_SQL;			// esegue il log dell'istruzione SQL (se richiesto dai parametri generali)
		private
//			str_print_phisical : string;
			procedure prepara_print_value;
		public
			bo_print_value_ready : boolean;
			lp_print, lp_print_left : LPSTR;
			function get_print_value : string;
			procedure set_print_value(s : string);
		public
			i_logical_page_ZB : logical_page_type;
			i_numero_obj : obj_index_type;
			i_section_1B : section_index_type;
			{$ifndef DLL} bo_external_owned : boolean; {$endif}
			{ BO_EXTERNAL_OWNED:
			  TRUE se l'oggetto è posseduto ESTERNAMENTE al legittimo proprietario
			  esempio CL_LABEL: TRUE se SELF è posseduto da OBJS_TYPE, FALSE se posseduto da CL_LABEL
			  default: TRUE
			  casi in cui ciò non avviene: i dialogs di modifica dei dati (LABEL_DIALOG.pas, DATAMATRIX_EDIT.pas) }
			tipo_oggetto : obj_type;
			tipo_valore : risultato_type;		// solo per i tipi di oggetto che gestiscono il campo
			show : show_types;
			lo_tag : integer;			// conserva il valore della property TAG per l'oggetto che possiede SELF
			bo_posizione_fissa : boolean;
				{ la posizione dell'oggetto è fissa all'interno della sua sezione;
				  non è modificata da eventuali cambiamenti di dimensione di altri oggetti }
			bo_move_obj_sottostanti : boolean;	// se la dimensione viene modificata, gli oggetti sottostanti vengono spostati
			bo_footer : boolean;						// oggetto legato al fondo della pagina (design-time only)
			str_print_if : string;					// condizione di stampa, se non è verificata, l'oggetto viene nascosto
			str_formula : string;					// solo per oggetti che supportano la modalità FORMULA
			str_SQL_expression : string;			// nome della colonna oppure espressione SQL
			str_esempio_value : string;
			tipo_formula_Xpos, tipo_formula_Ypos, tipo_formula_DX, tipo_formula_DY : shift_formula_type;
			str_formula_Xpos_cm, str_formula_Ypos_cm, str_formula_DX_cm, str_formula_DY_cm : string;	// formule il cui risultato determina uno shifting dell'oggetto sull'asse X o Y
{$ifdef CASA}
			x_print_exec, y_print_exec, dx_print_exec, dy_print_exec : int_pixel_type;		// coordinate e dimensioni effettive di stampa (video o printer)
{$endif CASA}
{$ifdef GALATEO_EXE}
			bo_selected : boolean;
			str_hints, str_remarks : string;
			bo_consenti_sovrapposizione_oggetti_simili : boolean;
{$endif GALATEO_EXE}
			constructor create(i_logical_page_ZB : logical_page_type;i_section : section_index_type;bo_external_owned : boolean = TRUE);
			destructor free;
			procedure assign(ca : cl_common_attributes);
			procedure assign_valori_formattazione(ca : cl_common_attributes);
			function load(var f : system.Text;wo_versione : word) : boolean;
			function valuta_boolean_runtime(handle : hwnd;str_condizione, str_object_descrizione : string) : boolean;
			function valuta_print_if(handle : hwnd;str_object_descrizione : string) : boolean;
{$ifdef GALATEO_EXE}
			function check_print_if(handle : hwnd) : boolean;
			function save(var f : system.Text) : boolean;
{$endif}
	end;

	{ classe che gestisce i riferimenti (in termini di posizione e di dimensione)
	  di ogni oggetto ad altri oggetti }
	reference_obj = class
		str_vert, str_horz, str_pos : string;		// legami comunitari
		procedure check;
		constructor create;
		procedure load(var f : text);
		procedure reset;
		procedure save(var f : text);
	end;

function get_new_tag : integer;
function create_name(str_base : string;bo_try_without_numero : boolean) : string;
//function name2index_active_page(str_nome : string;suitable_types : obj_type_set) : obj_index_type;
function name2index(str_nome : string;suitable_var_types : variabile_set;var i_page : logical_page_type;i_exclude_object : obj_index_type = 0) : obj_index_type; overload;
function name2index(str_nome : string;suitable_types : obj_type_set;var i_page : logical_page_type;i_exclude_object : obj_index_type = 0) : obj_index_type; overload;
function name2index(str_nome : string;suitable_types : obj_type_set = [];bo_db_column : boolean = FALSE;i_page : logical_page_type = 0;i_exclude_object : obj_index_type = 0) : obj_index_type;  overload;

{$ifdef GALATEO_EXE}
	function get_related_obj(tipi_oggetti : obj_type_set;i_section : section_index_type;
		x, y : int_pixel_type;bo_unselected_before, bo_area_minima : boolean) : obj_index_type;
	// select procedures
	procedure select_checking_keys(i_obj : obj_index_type);
	procedure load_combo_show_types(cb : TComboBox;i_section : section_index_type;sh_value : SHOW_TYPES);
	function get_show_type(cb : TComboBox) : SHOW_TYPES;
{$endif}

implementation

uses Fassert, Fdebug, FErrMsg, FXstrings, Fstrings, FMessage, FCtrls, FSystem,
	Gun, galateo_debug, proc, pages, functions, objects;

// -------- cl_common_attributes -----------------------------------------------

{$ifdef DEBUG} var i_common_attrs : integer; {$endif}

constructor cl_common_attributes.create(i_logical_page_ZB : logical_page_type;i_section : section_index_type;bo_external_owned : boolean = TRUE);
begin
	{$ifdef DEBUG} inc(i_common_attrs); {$endif}
	self.i_logical_page_ZB := i_logical_page_ZB;
	self.i_section_1B := i_section;
	{$ifndef DLL} self.bo_external_owned := bo_external_owned; {$endif}
	strcpychk(lp_print, '');
	show := OSW_SHOW
end;

destructor cl_common_attributes.free;
begin
	{$ifdef DEBUG} dec(i_common_attrs); {$endif}
	strdispose(lp_print);strdispose(lp_print_left)
end;

{$ifdef DEBUG} var lo_debug_char : integer; {$endif}

function cl_common_attributes.load(var f : system.Text;wo_versione : word) : boolean;
var s : string;
begin
	bo_posizione_fissa := FALSE;bo_footer := FALSE;
	bo_move_obj_sottostanti := TRUE;
	str_formula := '';str_SQL_expression := '';str_esempio_value := '';
	bo_log_query_SQL_phisical := FALSE;show := OSW_SHOW;
	{$ifndef DLL} str_hints := '';str_remarks := '';bo_consenti_sovrapposizione_oggetti_simili := FALSE; {$endif}

	if (wo_versione <= $010B) then begin result := TRUE;exit end;
	try
		readln(f, s);
		while (s <> '') do begin
			{$ifdef DEBUG} inc(lo_debug_char); {$endif}
			case s[1] of
				'A' : bo_posizione_fissa := TRUE;
				'B' : {$ifndef DLL} bo_footer := (i_section_1B = MAIN_SECTION) {$endif};	// solo per la MAIN section
				'L' : bo_move_obj_sottostanti := FALSE;
				'l' : bo_log_query_SQL_phisical := TRUE;
				's' : {$ifndef DLL} bo_consenti_sovrapposizione_oggetti_simili := TRUE {$endif};
				else if NOT accept_future_versions then raise exception.create('Attributo errato:' + ACAPO + '>' + s[1] + '< #' + inttostr(byte(s[1])))
			end;
			delete(s, 1, 1)
		end;
//		readln(f);
		readln(f, str_print_if);

		if (wo_versione >= $0261) then begin
			readln(f, byte(show), byte(tipo_valore), byte(tipo_formula_Xpos), byte(tipo_formula_Ypos), byte(tipo_formula_DX), byte(tipo_formula_DY));
			readln_LPSTR(f, str_formula);
			readln_LPSTR(f, str_SQL_expression);
			readln(f, str_esempio_value);
			{$ifdef DLL} readln(f);readln(f); {$else} readln_LPSTR(f, str_hints);readln_LPSTR(f, str_remarks); {$endif}
		end;
		readln(f, str_formula_Xpos_cm);readln(f, str_formula_Ypos_cm);
		readln(f, str_formula_DX_cm);readln(f, str_formula_DY_cm);
		readln(f);readln(f);		// free
		result := TRUE
	except
		error_msg('Errore durante la lettura degli attributi comuni (cl_common_attributes)'
			{$ifdef DEBUG} + ACAPO2 + 'char# = ' + lo_debug_char.ToString {$endif},MBOX_CAPTION);
		result := FALSE
	end
end;

procedure cl_common_attributes.assign(ca : cl_common_attributes);
begin
	tipo_oggetto := ca.tipo_oggetto;
	tipo_variabile := ca.tipo_variabile;
	self.i_logical_page_ZB := ca.i_logical_page_ZB;
	i_numero_obj := ca.i_numero_obj;
	i_section_1B := ca.i_section_1B;
	str_formula := ca.str_formula;
	str_SQL_expression := ca.str_SQL_expression;
	bo_log_query_SQL_phisical := ca.bo_log_query_SQL_phisical;
	lo_tag := ca.lo_tag;
	str_formula_Xpos_cm:= ca.str_formula_Xpos_cm;tipo_formula_Xpos := ca.tipo_formula_Xpos;
	str_formula_Ypos_cm := ca.str_formula_Ypos_cm;tipo_formula_Ypos := ca.tipo_formula_Ypos;
	str_formula_DX_cm := ca.str_formula_DX_cm;tipo_formula_DX := ca.tipo_formula_DX;
	str_formula_DY_cm := ca.str_formula_DY_cm;tipo_formula_DY := ca.tipo_formula_DY;
{$ifdef GALATEO_EXE}
//	bo_external_owned := ca.bo_external_owned;		*** NON assegno perchè rappresenta un valore esterno alla variabile
	bo_selected := ca.bo_selected;
	str_hints := ca.str_hints;
	str_remarks := ca.str_remarks;
	bo_consenti_sovrapposizione_oggetti_simili := ca.bo_consenti_sovrapposizione_oggetti_simili;
{$endif}
	str_esempio_value := ca.str_esempio_value;
	assign_valori_formattazione(ca)
end;

procedure cl_common_attributes.assign_valori_formattazione(ca : cl_common_attributes);
// esegue l'assegnazione dei valori riguardanti la formattazione del campo
begin
	tipo_valore := ca.tipo_valore;
	tipo_variabile := ca.tipo_variabile;
	bo_posizione_fissa := ca.bo_posizione_fissa;
	bo_footer := ca.bo_footer;
	bo_move_obj_sottostanti := ca.bo_move_obj_sottostanti;
	str_print_if := ca.str_print_if;
	str_formula_Xpos_cm := ca.str_formula_Xpos_cm;tipo_formula_Xpos := ca.tipo_formula_Xpos;
	str_formula_Ypos_cm := ca.str_formula_Ypos_cm;tipo_formula_Ypos := ca.tipo_formula_Ypos;
	str_formula_DX_cm := ca.str_formula_DX_cm;tipo_formula_DX := ca.tipo_formula_DX;
	str_formula_DY_cm := ca.str_formula_DY_cm;tipo_formula_DY := ca.tipo_formula_DY;
	show := ca.show
end;

function cl_common_attributes.valuta_boolean_runtime(handle : hwnd;str_condizione, str_object_descrizione : string) : boolean;
// rende TRUE se la condizione è VUOTA oppure VERA; emette eventuali messaggi di errore
var str_msg : string;
begin
	try
		if (str_condizione = '') then result := TRUE
		else if NOT interpreta_boolean_expression(str_condizione, FALSE, result, str_msg) then abort
	except
		MessageBBox(handle, str_msg, 'verifica condizione - ' + str_object_descrizione, MB_ICONSTOP)
	end
end;

function cl_common_attributes.valuta_print_if(handle : hwnd;str_object_descrizione : string) : boolean;
// rende TRUE se l'oggetto deve essere stampato, FALSE se la condizione STR_PRINT_IF lo inibisce; emette eventuali messaggi di errore
begin
	result := valuta_boolean_runtime(handle, str_print_if, str_object_descrizione)
end;

{$ifdef DEBUG}

	procedure cl_common_attributes.check_tipo_variabile(tv : variabile_type;str_caption : string);
	begin
		assert(tv in ALLOWED_TIPI_VARIABILI[tipo_oggetto],
			'check_tipo_variabile: ' + str_caption + ACAPO2 +
			'assegnazione di tipo variabile <' + coalesce(TV_DESCRIZIONE[tv], 'BLANK') + '> a oggetto <' + TIPO_OGGETTO_DESCRIZIONE[tipo_oggetto] + '>')
	end;

	procedure cl_common_attributes.set_tipo_variabile(tv : variabile_type);
	begin
		check_tipo_variabile(tv, 'set_tipo_variabile');
		tipo_variabile_phisical := tv
	end;

{$endif}

{$ifndef DLL}

	function cl_common_attributes.save(var f : system.Text) : boolean;
	begin
		try
			if bo_posizione_fissa then write(f,'A');
			if bo_footer then write(f,'B');
			if NOT bo_move_obj_sottostanti then write(f,'L');
			if bo_log_query_SQL then write(f, 'l');
			if bo_consenti_sovrapposizione_oggetti_simili then write(f, 's');
			writeln(f);
			writeln(f, str_print_if);
			writeln(f, byte(show), byte(tipo_valore):2, byte(tipo_formula_Xpos):2, byte(tipo_formula_Ypos):2, byte(tipo_formula_DX):2, byte(tipo_formula_DY):2, ' 0 0 0 0 0 0 0 0 0');
			writeln_LPSTR(f, str_formula);
			writeln_LPSTR(f, str_SQL_expression);
			writeln(f, str_esempio_value);
			{$ifdef DLL} writeln(f); writeln(f); {$else} writeln_LPSTR(f, str_hints);writeln_LPSTR(f, str_remarks); {$endif}
			writeln(f, str_formula_Xpos_cm);writeln(f, str_formula_Ypos_cm);
			writeln(f, str_formula_DX_cm);writeln(f, str_formula_DY_cm);
			writeln(f);writeln(f);	// free future implementations
			result := TRUE
		except
			result := FALSE
		end
	end;

	function cl_common_attributes.check_print_if(handle : hwnd) : boolean;
	{ esegue un controllo su STR_PRINT_IF; rende TRUE se tutto ok, FALSE se trova errori;
	  emette eventuali messaggi di errore }
	const MBOX_CAPTION = 'STAMPA SE ...';
{	var
		bo : boolean;
		str_msg : string; }
	begin
{		result := TRUE;
		str_print_if := togliblanks(str_print_if);
		if (str_print_if = '') then exit;
		result := interpreta_boolean_expression(str_print_if,TRUE,bo,str_msg);
		if NOT result then MessageBBox(handle,str_msg,MBOX_CAPTION,MB_ICONSTOP)	** }
		result := sections_1B(i_section_1B).validate_formula_editing(handle, str_print_if, 'condizione di stampa', {objs_type}NIL, VAL_BOOLEAN, TRUE)
	end;

{$endif}

procedure cl_common_attributes.prepara_print_value;  // funzione apparentemente non utilizzata, vedi doppione su LABELS
var s, str_result : string;
begin
	if bo_print_value_ready then exit;		// valore già elaborato
	try
		{$ifdef DEBUG} check_tipo_variabile(tipo_variabile_phisical, 'get_print_value'); {$endif}
		case tipo_variabile of
			TV_BLANK : {$ifdef DEBUG} assert(FALSE, 'TIPOVAR = TV_BLANK') {$endif};
//			TV_STATIC_TEXT : set_print_value(get_caption);
			TV_DB_FIELD : ;
			TV_PARAMETRO, TV_SQL_SELECT_BEFORE_SQL, TV_SQL_SELECT_BEFORE_RUNTIME : {$ifndef DLL} set_print_value(str_esempio_value) {$endif};
			TV_GROUP_EXPR_SQL : ;
			TV_SQL_SELECT : ;
			TV_FORMULA : begin
{$define OLD}
{$ifdef OLD}
				var tipo_res : risultato_type := tipo_valore;	// dal 2006-02-11: io so il tipo di risultato che la funzione deve rendere!
//				s := str_formula;
//				s := translate_local_macros(s);	// 2005-06-20
				s := translate_local_macros(str_formula);	// 2012-09-01
				sections_1B(i_section_1B).interpreta_string(s, {bo_stampa_vera}FALSE, {bo_check_errors}TRUE);	// 2005-04-10
				if NOT translate_formula(s, str_result, FALSE, tipo_res, tag2object(lo_tag))
					then raise exception.create(str_result);
{$else}
				tratta_formula(i_section, tag2object(tag), str_formula);		// dal 2008-09-19
{$endif}
				set_print_value(togli_protezione_parametri(str_result))
			end;
			else begin
				{$ifdef DEBUG} assert(FALSE,'GET_PRINT_VALUE(): non dovrebbe chiedermi ciò'); {$endif}
				abort
			end
		end;
		// eseguo l'eventuale arrotondamento
//		if (tipo in [FORMULA,VARIABILE]) AND (tipo_valore = VAL_NUMERO) then exec_round
	except
		var ox : objs_type := tag2object(lo_tag);
//		if (ox = NIL) then s := get_caption else s := ox.get_debug_caption;
		if (ox = NIL) then s := 'oggetto ' + i_numero_obj.ToString else s := ox.get_debug_caption;
		error_msg(s + ACAPO2 + 'Errore durante l''elaborazione dell''oggetto', MBOX_CAPTION);
		raise
	end
end;

function cl_common_attributes.get_print_value : string;
begin
	if NOT bo_print_value_ready then prepara_print_value;
//	result := str_print_phisical
	result := strpas(lp_print)
end;

procedure cl_common_attributes.set_print_value(s : string);
begin
	strcpychks(lp_print, s);//lp_print_left := NIL;
	bo_print_value_ready := TRUE
//	if bo_store_variabile AND (globale.fase_stampa = FASE_STAMPA_ASSEGNAZIONE_STORED_VALUES[tipo_oggetto]) then store_value
//	if bo_store_variabile AND (globale.fase_stampa = FASE_STAMPA_ASSEGNAZIONE_STORED_VALUES[tipo_variabile]) then store_value
end;

// ----------------- REFERENCE_OBJECT ------------------------------------------

constructor reference_obj.create;
begin reset end;

procedure reference_obj.check;
{ esegue un controllo sulla correttezza delle stringhe;
  se gli oggetti referenziati non esistono, il riferimento scompare;
  questa procedure dovrebbe essere chiamata per ogni oggetto ogni volta che si
  carica un file, ovvero ogni volta che si cancella un oggetto }

	procedure subcheck(var s : string);
	begin
		if (name2index(s) = 0) then begin s := ''{$ifNdef DLL};set_global_modified{$endif} end
	end;

begin
	subcheck(str_horz);
	subcheck(str_vert);
	subcheck(str_pos)
end;

procedure reference_obj.reset;
begin
	str_vert := '';str_horz := '';str_pos := ''
end;

procedure reference_obj.save(var f : text);
begin
	writeln(f,' / ',str_vert,' / ',str_horz,' / ',str_pos)
end;

procedure reference_obj.load(var f : text);
var s : string;	//*
begin
	reset;
	readln(f, s);if (s = '') then exit;
	{str_caption := copy(str,1,pos('/',str)-2);}delete(s,1,pos('/',s)+1);
	str_vert := copy(s, 1, pos('/', s) - 2);delete(s, 1, pos('/', s) + 1);
	str_horz := copy(s, 1, pos('/', s) - 2);delete(s, 1, pos('/', s) + 1);
	str_pos := s
end;

// -----------------------------------------------------------------------------

var lo_last_tag : integer;

function get_new_tag : integer;
// rende un TAG nuovo ed univoco
begin
{	var lo : integer := 1000000 + integer(random(1000)) * random(1000) + random(1000);
	while (xtag2index(lo) <> 0) do inc(lo);
	result := lo }
	inc(lo_last_tag);result := lo_last_tag
end;

function create_name(str_base : string;bo_try_without_numero : boolean) : string;
begin
	if bo_try_without_numero AND (name2obj(str_base, TRUE) = NIL) then begin
		result := str_base;exit
	end;
	var i : obj_index_type := 1;
	while (name2obj(str_base + zeri(i,2), TRUE) <> NIL) do inc(i);
	result := str_base + zeri(i,2)
end;

{$ifdef GALATEO_EXE}

	function get_related_obj(tipi_oggetti : obj_type_set;i_section : section_index_type;
		x,y : int_pixel_type;bo_unselected_before, bo_area_minima : boolean) : obj_index_type;
	{ rende l'indice dell'oggetto cui si riferisce il messaggio, oppure 0 se il messaggio non si riferisce a nessun oggetto in particolare;
	  la ricerca viene effettuata solamente sugli oggetti privi di gestione autonoma dei messaggi (XRECT,XLINE);
	  if BO_UNSELECTED_BEFORE then privilegia la selezione di oggetti non già selezionati;
	  serve per consentire la selezione di oggettini piccoli che si trovano sotto a oggettoni grandi;
	  se non si trova un oggetto non selezionato, agisce sull'oggetto selezionato;
	  if BO_AREA_MINIMA, tra gli oggetti che si trovano sul punto indicato rende quello che possiede l'area minima;
	  serve per selezionare oggettini piccolini coperti da oggettoni grandi (text objs) }
	begin
		result := 0;
//		if (globale.get_controllo.btn_select_only_texts.Down) then exit;
		var i_found_selected : obj_index_type := 0;
		var i_found_area : obj_index_type := 0;
		for var i : obj_index_type := 1 to i_objs do with xobjs(i) do begin
			if (tipi_oggetti <> []) AND NOT (ca.tipo_oggetto in tipi_oggetti) then continue;
			if NOT globale.bo_show_hidden_objects AND is_hidden(0) then continue;
			if (i_section <> ca.i_section_1B) then continue;
			if (xobjs(i).tipo_oggetto = OBJ_BITMAP) AND xobjs(i).asbitmap.bo_sfondo_design_time then continue;
			var j : int_pixel_type := get_left;
			if (x < j) OR (x > j + get_width(TRUE)) then continue;
			j := get_top;if (y < j) OR (y > j + get_height(TRUE)) then continue;
			if bo_area_minima then begin
				if (i_found_area = 0) OR (area(TRUE) < xobjs(i_found_area).area(TRUE)) then i_found_area := i;
				continue
			end;
			if (i_found_selected = 0) AND is_selected(i) then begin
				i_found_selected := i;continue
			end;
			result := i;break
		end;
		if (result = 0) AND bo_area_minima then result := i_found_area;
		if (result = 0) then result := i_found_selected
	end;

	procedure select_checking_keys(i_obj : obj_index_type);
	{ seleziona l'obj specificato verificando i tasti schiacciati;
	  if (BO_ALTERNA_STATO) e se l'obj era selezionato, lo deseleziona,
	  altrimenti lo seleziona sempre }
	begin
		var bo_was_selected := is_selected(i_obj);
		var bo_key_combination := multi_selecting_keys_combination;
		var bo := NOT (bo_was_selected AND bo_key_combination);
	//	if (bo_was_selected AND bo_key_combination) then bo := FALSE else bo := TRUE;
		obj_select(i_obj, bo, bo_key_combination)
	end;

	procedure load_combo_show_types(cb : TComboBox;i_section : section_index_type;sh_value : SHOW_TYPES);
	// carica i tipi di visualizzazione adatti alla sezione; assegna il valore SH_VALUE
	begin
		cb.Items.clear;
		for var sh : SHOW_TYPES := low(sh) to high(sh) do begin
			if (i_section = 1) AND NOT (sh in OSW_MAIN_RECORD_OBJECTS) then continue;
			if (i_section > 1) AND NOT (sh in OSW_SECTIONS_OBJECTS) then continue;
			cb.Items.add(SHOW_TYPES_DESCR[sh])
		end;
		cb_select(cb,SHOW_TYPES_DESCR[sh_value]);
		if (cb.ItemIndex = -1) then cb.ItemIndex := 0	// mostra sempre
	end;

	function get_show_type(cb : TComboBox) : SHOW_TYPES;
	begin
		for var sh : SHOW_TYPES := low(sh) to high(sh) do
			if (cb.Text = SHOW_TYPES_DESCR[sh]) then begin result := sh;exit end;
		{$ifdef DEBUG} assert(FALSE,'DSHD 2031 SHOW NOT FOUND!'); {$endif}
		result := OSW_SHOW	// default rassicurante ma da non utilizzare
	end;

{$endif GALATEO_EXE}

function name2index(str_nome : string;suitable_types : obj_type_set = [];
	bo_DB_column : boolean = FALSE;i_page : logical_page_type = 0;
	i_exclude_object : obj_index_type = 0) : obj_index_type;
{ rende l'indice nel vettore OBJS[] dell'oggetto con il nome specificato;
  il tipo dell'oggetto deve essere indicato in SUITABLE_TYPES; se SUITABLE_TYPES è vuoto, tutti i tipi vanno bene;
  rende 0 in caso di errore, ovvero di oggetto non trovato;
  fino al 2011-05-18 la ricerca avveniva dapprima sulla sezione principale, digradando poi verso le sezioni meno importanti;
  dopo tale data procede per posizione (indice nel vettore), assumendo che i nomi siano univoci;
  if (BO_DB_COLUMNS) then la ricerca avviene sul nome, ELSE sulle variabili che
  rispecchiano colonne del database;
  la ricerca viene eseguita nella pagina specificata in I_PAGE }
begin
	result := 0;
	var bo_all := (suitable_types = []);
	if (str_nome = '') then exit;
	str_nome := uppercase(str_nome);
	{$ifdef DEBUG} assert((i_page >= 0) AND (i_page <= get_ultima_pagina_logica), 'name2index(types 1) -- valore errato per i_page = ' + inttostr(i_page)); {$endif}
	if (i_page = 0) then i_page := get_pagina_logica_attiva_1B;
//	for var i_sezione : section_index_type := 1 to get_num_sections_page(i_page) do begin
		for var i : obj_index_type := 1 to i_objs(i_page) do begin
			if (i = i_exclude_object) then continue;			// escludo l'oggetto i-esimo
			var xobj : objs_type := xobjs(i, i_page);
//			if (xobj.get_section <> i_sezione) then continue;
//			var tipo : obj_type := xobj.ca.tipo_oggetto;
			if bo_db_column then begin
//				if (tipo = xxVARIABILE) AND
				if (xobj.ca.tipo_oggetto = LABEL_OBJ) AND (xobj.tipo_variabile = TV_DB_FIELD) AND	// discutibile il predicato (TIPO = LABEL_OBJ); probabilmente non serve ed è un retaggio del passato
//					(uppercase(xobj.aslabel.str_SQL_expression) = str_nome)
					(uppercase(xobj.str_SQL_expression) = str_nome)
				then begin
					result := i;exit
				end
			end
			else begin
				if (str_nome = uppercase(xobj.get_name)) AND (bo_all OR (xobj.ca.tipo_oggetto in suitable_types)) then begin
					result := i;exit
				end
			end
		end
//	end
end;

function name2index(str_nome : string;suitable_var_types : variabile_set;var i_page : logical_page_type;i_exclude_object : obj_index_type = 0) : obj_index_type;
begin
	result := 0;
	if (str_nome = '') then exit;
	str_nome := uppercase(str_nome);
	{$ifdef DEBUG} assert((i_page >= 0) AND (i_page <= get_ultima_pagina_logica), 'name2index(var) -- valore errato per i_page = ' + inttostr(i_page)); {$endif}
	if (i_page = 0) then i_page := get_pagina_logica_attiva_1B;
//	for var i_sezione : section_index_type := 1 to get_num_sections_page(i_page) do begin
		for var i : obj_index_type := 1 to i_objs(i_page) do begin
			if (i = i_exclude_object) then continue;			// escludo l'oggetto i-esimo
			var xobj : objs_type := xobjs(i,i_page);
//			if (xobj.get_section <> i_sezione) then continue;
			if (str_nome = uppercase(xobj.get_name)) AND ((suitable_var_types = []) OR (xobj.tipo_variabile in suitable_var_types)) then begin
				result := i;exit
			end
		end
//	end
end;

function name2index(str_nome : string;suitable_types : obj_type_set;var i_page : logical_page_type;i_exclude_object : obj_index_type = 0) : obj_index_type;
{ rende l'indice nel vettore OBJS[] dell'oggetto con il nome specificato;
  rende 0 in caso di errore, ovvero di oggetto non trovato;
  cerca in tutte le pagine del file: prima in quella aperta, poi parte dalla
  prima per arrivare fino all'ultima;
  il numero della pagina in cui viene trovato l'oggetto viene posto in I_PAGE }
begin
	str_nome := uppercase(str_nome);
	if (str_nome = '') then begin result := 0;i_page := 0;exit end;
	// cerco innanzitutto nella pagina attiva
	{$ifdef DEBUG} assert((i_page >= 0) AND (i_page <= get_ultima_pagina_logica), 'name2index(types 2) -- valore errato per i_page = ' + inttostr(i_page)); {$endif}
	i_page := get_pagina_logica_attiva_1B;
	result := name2index(str_nome, suitable_types, FALSE, i_page, i_exclude_object);
	if (result <> 0) then exit;	// risultato ok, I_PAGE già assegnata
	// poi cerco nelle eventuali altre pagine
	for var i : logical_page_type := 1 to get_ultima_pagina_logica do begin		// non posso usare I_PAGE per il LOOP
		if (i = get_pagina_logica_attiva_1B) then continue;	// già cercato in questa pagina
		result := name2index(str_nome, suitable_types, FALSE, i, {i_exclude_object}0);	// I_EXCLUDE_OBJECT vale solo nella pagina corrente, nelle altre non ha senso
		if (result <> 0) then begin i_page := i;exit end
	end;
	result := 0;i_page := 0	// non trovato, rende result e i_page = 0
end;

function cl_common_attributes.get_log_query_SQL : boolean;
begin
	result := bo_log_query_SQL_phisical AND NOT get_logical_page_ZB(i_logical_page_ZB).bo_exclude_debug
end;

initialization
	lo_last_tag := 1001000;
	galateo_initialization_debug('objsx')
finalization
	galateo_finalization_debug('objsx');
	{$ifdef DEBUG} CCI(i_common_attrs, 'cl_common_attributes', 'objsx.pas') {$endif}
end.
