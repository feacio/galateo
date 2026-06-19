unit Objects;	//*

{$I defines}

interface

uses Windows, SysUtils, Types, Classes, Messages, VCL.Controls, VCL.Stdctrls, VCL.Graphics, VCL.ExtCtrls, Math, VCL.Forms, VCL.Clipbrd,
	Fcommons, Gdich, objsx, labels, bmps, rects, {$ifdef GALATEO_EXE} panel, {$endif} datamatrix_unit;

type
	objs_type = class;	// forward

	{ prototipo del funzione di stampa;
	  rende TRUE in caso di stampa completata felicemente; rende FALSE in caso di stampa
	  impossibile o incompleta }
	print_proc_type = function(
		vcanvas,pcanvas : TCanvas;			// canvas per Printer e Video
		x0, y0 : int_pixel_type;				// coordinate di stampa; la stampa avviene a (x0,y0)
		bo_video : boolean;
			{ if BO_VIDEO then i parametri (in input e in output) sono espressi in unità di misura VIDEO,
			  altrimenti in unità di misura PRINTER; a prescindere da questo fatto, tutti i calcoli interni
			  a questa procedure sono espressi in PRINTER, per garantirne l'esattezza reale }
		ptcr : pTRect;
		var i_delta_y : int_pixel_type;
			{ INPUT: scostamento verticale dalla posizione originale dell'oggetto;
			  OUTPUT: scostamento della dimensione verticale dell'oggetto (se ha occupato più righe o meno righe),
			  da comunicare (in termini di spostamento di posizione) agli oggetti sottostanti;
			  I_DELTA_Y serve per calcolare le eventuali conseguenze sugli altri oggetti;
			  è positivo se l'oggetto aumenta la dimensione }
		var i_max_y_pixel : int_pixel_type;		// posizione y massima; serve per effettuare calcoli sulla dimensione della sezione
		i_delta_y_bottom : int_pixel_type;		// comunica (in input, ovviamente) la variazione di dimensione dell'oggetto
		i_margine_y_pixel : int_pixel_type;
			{ posizione (in pixel) del margine inferiore della sezione; rappresenta
			  il limite dello spazio occupabile; passare 0 per non attivare il controllo }
		i_font_ridotto_size : smallint;
			{ dimensione modificata in automatico; se <> 0, la riga è continuazione
			  di una riga precedente, e la dimensione specificata DEVE essere utilizzata }
		bo_can_break_object : boolean;
		i_ph_first_page_section,i_ph_last_page_section : ph_page_type;
		ptr_print_section : {cl_print_section}pointer = NIL) : boolean of object;

	objs_type = class
		private
			function get_tipo_oggetto : obj_type;
//			procedure set_tipo_oggetto(tb : obj_type);
			function get_tipo_variabile : variabile_type;
			procedure set_tipo_variabile(tv : variabile_type);
//			function get_tipo_valore : risultato_type;
			function get_SQL_expression : string;
			procedure set_SQL_expression(s : string);
//			function get_esempio_value : string;
//			procedure set_esempio_value(s : string);
//			function get_section : section_index_type;	// rende la sezione cui appartiene l'oggetto
//			procedure set_section(i_section : section_index_type);
		public
			ca : cl_common_attributes;
			i_numero_obj : obj_index_type;
			xref : reference_obj;
			bo_dont_print : boolean;
				{ BO_DONT_PRINT: esclude dalla stampa il record, per motivi di carattere superiore
				  non direttamente legati all'oggetto ma in generale alla formattazione della pagina o della sezione }
			property tipo_variabile : variabile_type read get_tipo_variabile write set_tipo_variabile;
			property tipo_oggetto : obj_type read get_tipo_oggetto;
//			property tipo_valore : risultato_type read get_tipo_valore;
			property str_SQL_expression : string read get_SQL_expression write set_SQL_expression;
//			property str_esempio_value : string read get_esempio_value write set_esempio_value;
//			property i_section : section_index_type read get_section write set_section;

			constructor create_ZB(form : TForm;i_logical_page_ZB : logical_page_type;i_section_ZB : section_index_type;tipo : obj_type;i_obj : obj_index_type;bo_init_default : boolean);
			destructor free;

			procedure clear_print_value;
			procedure reset_print_value;
			function calcola_print_value : string;

			procedure set_obj_number(i_numero_obj : obj_index_type);

			function get_left : int_pixel_type;
			function get_top : int_pixel_type;
			function get_height(bo_uso_selezione : boolean = FALSE) : int_pixel_type;
			function get_width(bo_uso_selezione : boolean = FALSE) : int_pixel_type;

			procedure set_height(h : int_pixel_type);
			procedure set_left(x : int_pixel_type);
			procedure set_top(y : int_pixel_type);
			procedure set_width(w : int_pixel_type);

			function aslabel : cl_label;
			function asbitmap : cl_bmp;
			function asgraph : cl_rect;
			function asdatamatrix : cl_datamatrix;
			procedure bringtofront;
			function get_debug_caption : string;
//			function get_handle : hwnd;
			function get_hints : string;
			function get_name : string;
			function get_show_state : show_types;
			function get_tag : integer;
			function get_x_left_virtuale(x_left : int_pixel_type) : int_pixel_type;
			{$ifdef GALATEO_EXE} function get_y_top_virtuale(y_top : int_pixel_type) : int_pixel_type; {$endif}
//			function get_common_attributes : cl_common_attributes;
{$ifdef GALATEO_EXE}
			function area(bo_uso_selezione : boolean = FALSE) : integer;
			function check_name(handle : hwnd;str_new_name : string) : boolean;
			procedure check_pos_in_section;
			function panel : TGalPanel;
			function pbox : TGalPaintBox;
			procedure applica_style(obj_from : objs_type;wo_style : word);
			procedure change_riferimenti(str_old_name, str_new_name : string);
			procedure check_size;
			function check_resize(i_obj : obj_index_type;i_delta_h,i_delta_w,i_delta_x,i_delta_y : int_pixel_type) : boolean;
			procedure esc;
			procedure edit_object;
			function is_in_rectangle(p1, p2 : TSmallPoint;bo_selezione_inclusiva : boolean = FALSE {$ifdef DEBUG} ;bo_debug : boolean = FALSE {$endif}) : boolean;
			function is_stile_applicabile(obj_ref : objs_type;wo_style : word) : boolean;
			procedure on_change_size_and_pos;
			function save(var f : text) : boolean;
			procedure select(bo_select, bo_beep_on_change_status, bo_update_info_selezione : boolean);
			function selected : boolean;
{$endif GALATEO_EXE}
			function is_hidden(i_pagina_fisica : ph_page_type;
				i_ph_first_page_section : ph_page_type = 0;i_ph_last_page_section : ph_page_type = 0;
				bo_dont_hide_on_zero_values : boolean = FALSE;ptr_print_section : {cl_print_section}pointer = NIL) : boolean;
			function load(var f : text;tipo_variabile : variabile_type;wo_versione : word) : boolean;
{$ifdef CASA}
			function print(vcanvas, pcanvas : TCanvas;x0,y0 : int_pixel_type;bo_video : boolean;ptcr : pTRect;
				var i_delta_y : int_pixel_type;var i_max_y_pixel : int_pixel_type;
				i_delta_y_bottom, i_margine_y_pixel : int_pixel_type;bo_can_break_object : boolean;
				i_ph_first_page_section, i_ph_last_page_section : ph_page_type;ptr_print_section : {cl_print_section}pointer = NIL) : boolean;
{$endif}
			procedure set_name(str_nome : string);
			procedure set_show_hints(bo_show : boolean);
			procedure set_visible(bo_visible : boolean);
			function set_show_state(show : show_types) : show_types;
			procedure get_print_pos_and_size(var r_delta_y0_print, r_delta_y_int_print : misura_real_type);
			procedure set_print_pos_and_size(r_delta_y0_print, r_delta_y_int_print : misura_real_type);
		private
			lab : cl_label;
			bmp : cl_bmp;
			graph : cl_rect;
			dm : cl_datamatrix;
			{$ifdef GALATEO_EXE} i_old_left, i_old_top, i_old_width, i_old_height : integer; {$endif}
			r_delta_y0_print : misura_real_type;				// sfasamento y rispetto alla posizione di stampa prevista
			r_delta_y_int_print : misura_real_type; 			// sfasamento che interviene tra l'inizio e la fine del campo
	end;

{*  $I objsx.h}
{*  $I function.h}

//var obj : Tobjects;

function calcola_values(handle : HWND;bo_printing : boolean;i_section_1B : section_index_type;bo_non_ricalcolare_formule_non_vuote : boolean) : boolean;
procedure reset_print_values(i_sezione_1B : section_index_type;i_pagina_logica_1B : logical_page_type = 0);
function name2obj(str_nome : string;bo_all_pages : boolean;i_exclude_object : obj_index_type = 0) : objs_type; overload;
function name2obj(str_nome : string;suitable_obj_types : obj_type_set;bo_all_pages : boolean;i_exclude_object : obj_index_type = 0) : objs_type; overload;
function name2obj(str_nome : string;suitable_var_types : variabile_set;bo_all_pages : boolean;i_exclude_object : obj_index_type = 0) : objs_type; overload;
function dbcolumn2obj(str_db_column : string) : objs_type;
function get_next_object(i_obj : obj_index_type;bo_forward, bo_must_be_visible : boolean) : obj_index_type;
procedure init_after_loading;		// da richiamare dopo aver caricato un nuovo file
function read_object_ZB(var f : system.Text;i_obj : obj_index_type;i_logical_page_ZB : logical_page_type;i_section_ZB : section_index_type;
	wo_versione : word;bo_read_index_from_file : boolean = TRUE) : obj_index_type;
{$ifdef CASA}
	procedure IO_dynamic_images(bo_push : boolean);
	function dynamic_images_error_messages : boolean;
{$endif}
function object_is_hidden(show : show_types;i_pagina_fisica : ph_page_type;i_sezione_1B : section_index_type = 0;
	i_ph_first_page_section : ph_page_type = 0;i_ph_last_page_section : ph_page_type = 0;
	bo_dont_hide_on_zero_values : boolean = FALSE;
	ptr_print_section : {cl_print_section}pointer = NIL) : boolean;
//function _xytag2object(lo_tag : integer) : objs_type;
{$ifdef GALATEO_EXE}
	function new_obj_ZB(tipo : obj_type;i_logical_page_ZB : logical_page_type;i_section_ZB : section_index_type;ppos : TPoint) : obj_index_type;
	procedure obj_select(i_obj : obj_index_type;bo_select : boolean;bo_add : boolean = FALSE);
	procedure delete_object(i_obj : obj_index_type;bo_conseguenze_video, bo_select_next : boolean);
	procedure check_objs_pos_in_section(i_section_1B : section_index_type);
	procedure copy_clipboard(i_obj : obj_index_type);
	procedure cut_clipboard(i_obj : obj_index_type);
	function is_a_compatible_selection(i_azione : integer;wo_parm : word;xobj : objs_type) : boolean;
	procedure load_objects(it : TStrings;tipi : obj_type_set;i_pagina_logica_1B : logical_page_type;
		i_section_1B : section_index_type;bo_load_obj_sezioni_superiori : boolean = TRUE); overload;
	procedure load_objects(it : TStrings;vars : variabile_set;i_pagina_logica_1B : logical_page_type;
		i_section_1B : section_index_type;bo_load_obj_sezioni_superiori : boolean = TRUE); overload;
	function load_objects(it : TStrings;i_page_ZB : logical_page_type;sezioni_ZB : byteset = [];objs_types : obj_type_set = [];tipi_valore : risultato_set = []) : smallint; overload;

	procedure paste_clipboard;
	function set_all_selected(i_azione : integer;wo_parm : word;xobj : objs_type) : boolean;
	procedure write_object(var f : system.Text;i_obj : obj_index_type);
	function push_selected(var str_stack : string;bo_deselect : boolean) : obj_index_type;
	procedure pop_selected(str_stack : string);
	function get_stack_obj(str_stack : string;i_pos : obj_index_type) : obj_index_type;
	function get_stack_max_object(var str_stack : string;bo_delete_from_stack : boolean = FALSE) : obj_index_type;
	function tratta_mouse_messages(i_section_1B : section_index_type;var Message: TWMMouse) : boolean;
	procedure check_resize_all(i_obj : obj_index_type;i_delta_h, i_delta_w, i_delta_x, i_delta_y : int_pixel_type);
{$endif}

implementation

uses Fassert, Fdebug, FXstrings, Fstrings, FErrMsg, FSQLsoft, FMessage, FSystem_base, FSystem, FFile,
	{$ifdef GALATEO_EXE} galateo_main, {$endif}
	{$ifdef CASA} print_types, {$endif}
	Gun, galateo_debug, proc, misure, sezione, pages, functions;

{$ifdef GALATEO_EXE}
var	// procedure di selezione dinamica degli oggetti per area (tramite mouse)
	bo_mouse_down : boolean;				// TRUE se il mouse è DOWN
	pm_down : TSmallPoint;					// dove è stato cliccato il mouse; vale (-1,-1) se il bottone non è sta
	pm_last : TSmallPoint;					// contiene l'ultimo punto disegnato; vale (-1,-1) se blank
	str_objs_selected_before : string;	// objs selezionati all'inizio dell'operazione 'area dinamica'
	str_area_selecting_objs : string;	// stringa che contiene gli oggetti selezionati dinamicamente
{$endif}
{$ifdef DEBUG} var i_objs_type : integer; {$endif}

constructor objs_type.create_ZB(form : TForm;i_logical_page_ZB : logical_page_type;i_section_ZB : section_index_type;tipo : obj_type;
	i_obj : obj_index_type;bo_init_default : boolean);
begin
	{$ifdef DEBUG} inc(i_objs_type); {$endif}
	self.i_numero_obj := i_obj;
	graph := NIL;lab := NIL;bmp := NIL;
	xref := reference_obj.create;
	{$ifdef DEBUG} assert(ca = NIL, 'ATTR is NOT NIL'); {$endif}
	ca := cl_common_attributes.create(i_logical_page_ZB, i_section_ZB + 1, {external_owned}TRUE);
	case tipo of
//		LABEL_OBJ, xxxVARIABILE, xxxFORMULA : lab := cl_label.xcreate(form, i_section, tipo, i_obj, bo_init_default);
		LABEL_OBJ : lab := cl_label.xcreate(form, ca, i_section_ZB + 1, i_obj, bo_init_default);
		DATAMATRIX_OBJ : dm := cl_datamatrix.xCreate(form, ca, i_section_ZB + 1, i_obj, bo_init_default);
		OBJ_BITMAP : bmp := cl_bmp.xcreate(form, ca, i_section_ZB + 1, i_obj, bo_init_default);
		OBJ_RECT, OBJ_LINE : graph := cl_rect.xcreate(form, ca, tipo, i_section_ZB + 1, i_obj, bo_init_default)
	end
end;

destructor objs_type.free;
begin
	{$ifdef DEBUG} dec(i_objs_type); {$endif}
	case ca.tipo_oggetto of
		LABEL_OBJ : begin lab.free;lab := NIL end;
		DATAMATRIX_OBJ : begin dm.free;dm := NIL end;
		OBJ_BITMAP : begin bmp.free;bmp := NIL end;
		OBJ_RECT, OBJ_LINE : begin graph.free;graph := NIL end
	end;
	if (ca <> NIL) then begin ca.free;ca := NIL end;
//	inherited free		{$ifdef DEBUG} *** {si dovrebbe chiamare! detto il 2011-05-10, ma dà errore; se hai un po' di tempo per guardarlo ...} {$endif}
end;

procedure objs_type.set_obj_number(i_numero_obj : obj_index_type);
// assegna all'oggetto indicato il suo numero di oggetto
begin
	self.i_numero_obj := i_numero_obj;
	ca.i_numero_obj := i_numero_obj;
{	self.i_numero_obj := i_numero_obj;
	case ca.tipo_oggetto of
		LABEL_OBJ : lab.i_numero_obj := i_numero_obj;
		DATAMATRIX : dm.attr.i_numero_obj := i_numero_obj;
		OBJ_BITMAP : bmp.attr.i_numero_obj := i_numero_obj;
		OBJ_RECT, OBJ_LINE : graph.attr.i_numero_obj := i_numero_obj
	end }
end;

function objs_type.get_tag : integer;
begin
	case ca.tipo_oggetto of
		LABEL_OBJ : result := lab.tag;
		DATAMATRIX_OBJ : result := dm.tag;
		OBJ_BITMAP : result := bmp.tag;
		OBJ_RECT, OBJ_LINE : result := graph.tag
		else result := 0
	end
end;

function objs_type.get_tipo_oggetto : obj_type;
begin
	result := ca.tipo_oggetto
{//	if (lab <> NIL) then result := lab.tipo_oggetto else
	if (lab <> NIL) then result := LABEL_OBJ else
	if (graph <> NIL) then result := graph.tipo_oggetto else
	if (bmp <> NIL) then result := OBJ_BITMAP else
	if (dm <> NIL) then result := DATAMATRIX else
	result := NO_TYPE }
end;

function objs_type.get_tipo_variabile: variabile_type;
begin
	result := ca.tipo_variabile
{	case ca.tipo_oggetto of
		LABEL_OBJ : result := lab.tipovar;
		DATAMATRIX_OBJ : result := dm.tv;
		else result := TV_BLANK
	end }
end;

procedure objs_type.set_tipo_variabile(tv : variabile_type);
begin
	ca.tipo_variabile := tv
(*	case ca.tipo_oggetto of
		LABEL_OBJ : lab.tipovar := tv;
		DATAMATRIX_OBJ : dm.tv := tv;
		else {$ifdef DEBUG} assert(FALSE, 'set_tipo_variabile()') {$endif}
	end *)
end;

function objs_type.is_hidden(i_pagina_fisica : ph_page_type;
	i_ph_first_page_section : ph_page_type = 0;i_ph_last_page_section : ph_page_type = 0;
	bo_dont_hide_on_zero_values : boolean = FALSE;ptr_print_section : {cl_print_campo}pointer = NIL) : boolean;
{ rende TRUE se l'oggetto è nascosto sulla pagina specificata;
  passando I_PAGE = 0 si ottiene un risultato che indica se su almeno una pagina l'oggetto viene stampato }
//var sh : show_types;
begin
{	case ca.tipo_oggetto of
		LABEL_OBJ : sh := ca.show;
		DATAMATRIX : sh := dm.show;
		OBJ_BITMAP : sh := bmp.show;
		OBJ_RECT, OBJ_LINE : sh := graph.show;
		else begin result := TRUE;exit end
	end;}
	result := object_is_hidden(ca.show, i_pagina_fisica, ca.i_section_1B,
		i_ph_first_page_section, i_ph_last_page_section, bo_dont_hide_on_zero_values, ptr_print_section)
end;	

function objs_type.get_name : string;
begin
	case ca.tipo_oggetto of
		LABEL_OBJ : result := lab.Caption;
		DATAMATRIX_OBJ : result := dm.Name;
		OBJ_BITMAP : result := bmp.get_name;
		OBJ_RECT, OBJ_LINE : result := graph.Caption
	end
end;

procedure objs_type.set_name(str_nome : string);
begin
	case ca.tipo_oggetto of
		LABEL_OBJ : lab.Caption := str_nome;
		DATAMATRIX_OBJ : dm.name := str_nome;
		OBJ_BITMAP : bmp.set_name(str_nome);
		OBJ_RECT, OBJ_LINE : graph.Caption := str_nome
	end
end;

{$ifdef GALATEO_EXE}

	procedure objs_type.esc;
	begin
		dd.dragging_mouse_up;
		case ca.tipo_oggetto of
			LABEL_OBJ : lab.esc;
			DATAMATRIX_OBJ : dm.esc;
			OBJ_BITMAP : bmp.esc;
			OBJ_RECT, OBJ_LINE : graph.esc
		end
	end;

	function objs_type.is_stile_applicabile(obj_ref : objs_type;wo_style : word) : boolean;
	begin
		result := FALSE;
		// STYLE_ALL and SIZE and LEGAMI_COMUNITARI sono generali, tra tutti i tipi
		if (wo_style = STYLE_ALL) OR (wo_style AND COMMON_STYLES = wo_style) then begin
			result := TRUE;exit
		end;
		if (obj_ref = NIL) then exit;

		var tipo : obj_type := get_tipo_oggetto;var ref_tipo : obj_type := obj_ref.get_tipo_oggetto;
		if NOT ((tipo = ref_tipo) OR
			((tipo = LABEL_OBJ) AND (ref_tipo = LABEL_OBJ)) OR
			((tipo in CORNICI_OBJS) AND (ref_tipo in CORNICI_OBJS)))
				then exit;
		case tipo of
			LABEL_OBJ : begin
				result := (wo_style AND LABEL_STYLES = wo_style);
				// se formato numerico: deve essere un numero
				if (wo_style = STYLE_FORMATO_NUMERICO)
//					AND NOT ((ref_tipo in [xxVARIABILE, xxFORMULA])
					AND ((obj_ref.get_tipo_variabile in [TV_BLANK, TV_STATIC_TEXT])
					AND (obj_ref.ca.tipo_valore = VAL_NUMERO))
						then result := FALSE
			end;
			DATAMATRIX_OBJ : result := (wo_style AND DATAMATRIX_STYLES = wo_style);
			OBJ_BITMAP : result := (wo_style AND BMP_STYLES = wo_style);
			OBJ_RECT, OBJ_LINE : result := (wo_style AND GRAPHIC_STYLES = wo_style)
		end
	end;

	procedure objs_type.applica_style(obj_from : objs_type;wo_style : word);
	begin
		{$ifdef DEBUG} assert(self <> obj_from,'applica style a se stesso: should not happen'); {$endif}
		if (self = obj_from) then exit;
		set_global_modified;
		// la formattazione si trascina sempre dietro anche la dimensione
		if (wo_style AND STYLE_FORMATTATION <> 0) then wo_style := (wo_style OR STYLE_SIZE);

		// tratto insieme gli attributi comuni a tutti i tipi di oggetti
		if (wo_style AND STYLE_SIZE <> 0) then begin
			if (wo_style AND STYLE_HEIGHT <> 0) then set_height(obj_from.get_height);
			if (wo_style AND STYLE_WIDTH <> 0) then set_width(obj_from.get_width);
			wo_style := wo_style AND (NOT STYLE_SIZE);
			case ca.tipo_oggetto of
				LABEL_OBJ : begin
					lab.autosize := FALSE;
					lab.bo_autoheight := obj_from.lab.bo_autoheight
				end;
				OBJ_BITMAP : bmp.autosize := FALSE;
				DATAMATRIX_OBJ, OBJ_RECT, OBJ_LINE : ;
				{$ifdef DEBUG} else assert(FALSE,'DJSHD 2312'); {$endif}
			end
		end;

		if (wo_style AND STYLE_SHIFT_POS <> 0) then begin
			ca.tipo_formula_Xpos := obj_from.ca.tipo_formula_Xpos;ca.str_formula_Xpos_cm := obj_from.ca.str_formula_Xpos_cm;
			ca.tipo_formula_Ypos := obj_from.ca.tipo_formula_Ypos;ca.str_formula_Ypos_cm := obj_from.ca.str_formula_Ypos_cm;
			ca.tipo_formula_DX := obj_from.ca.tipo_formula_DX;ca.str_formula_DX_cm := obj_from.ca.str_formula_DX_cm;
			ca.tipo_formula_DY := obj_from.ca.tipo_formula_DY;ca.str_formula_DY_cm := obj_from.ca.str_formula_DY_cm;
			dec(wo_style, STYLE_SHIFT_POS)
		end;

		if (wo_style AND STYLE_LEGAMI_COMUNITARI <> 0) then begin
			dec(wo_style, STYLE_LEGAMI_COMUNITARI);
			xref.str_vert := obj_from.xref.str_vert;
			xref.str_horz := obj_from.xref.str_horz;
			xref.str_pos := obj_from.xref.str_pos
		end;
		if (wo_style AND STYLE_VISUALIZZAZIONE <> 0) then begin
			dec(wo_style, STYLE_VISUALIZZAZIONE);
			set_show_state(obj_from.get_show_state);
			ca.str_print_if := obj_from.ca.str_print_if
		end;
		{$ifdef DEBUG} assert(wo_style AND COMMON_STYLES = 0,'common style non esauriti -- CJSHD 2310'); {$endif}

		if (wo_style <> 0) then begin
			case ca.tipo_oggetto of
				LABEL_OBJ : lab.applica_style(obj_from, wo_style);
				DATAMATRIX_OBJ : dm.applica_style(obj_from, wo_style);
				OBJ_BITMAP : bmp.applica_style(obj_from, wo_style);
				OBJ_RECT, OBJ_LINE : graph.applica_style(obj_from, wo_style)
				{$ifdef DEBUG} else assert(FALSE,'DXSD 5579'); {$endif}
			end
		end
	end;

	function objs_type.area(bo_uso_selezione : boolean = FALSE) : integer;
	begin
		result := max(get_height(bo_uso_selezione),1) * max(get_width(bo_uso_selezione),1)
	end;

{$endif}

function objs_type.aslabel : cl_label; 
begin
	{$ifdef DEBUG} assert(ca.tipo_oggetto = LABEL_OBJ,'ASLABEL: tipo non corretto -- IHNX 2991'); {$endif}
	if (ca.tipo_oggetto <> LABEL_OBJ) then abort;
	aslabel := lab
end;

function objs_type.asbitmap : cl_bmp;
begin
	{$ifdef DEBUG} assert(ca.tipo_oggetto = OBJ_BITMAP,'ASBITMAP: tipo non corretto -- IHNX 2992'); {$endif}
	if (ca.tipo_oggetto <> OBJ_BITMAP) then abort;
	asbitmap := bmp
end;

function objs_type.asgraph : cl_rect;
begin
	{$ifdef DEBUG} assert(ca.tipo_oggetto in CORNICI_OBJS,'ASGRAPH: tipo non corretto -- IHNX 2993'); {$endif}
	if NOT (ca.tipo_oggetto in CORNICI_OBJS) then abort;
	asgraph := graph
end;

function objs_type.asdatamatrix : cl_datamatrix;
begin
	{$ifdef DEBUG} assert(ca.tipo_oggetto = DATAMATRIX_OBJ,'ASDATAMATRIX: tipo non corretto -- IHNX 2994'); {$endif}
	if (ca.tipo_oggetto <> DATAMATRIX_OBJ) then abort;
	asdatamatrix := dm
end;	

procedure objs_type.bringtofront;
begin
	case ca.tipo_oggetto of
		LABEL_OBJ : lab.bringtofront;
		DATAMATRIX_OBJ : dm.BringToFront;
		OBJ_BITMAP : bmp.bringtofront;
//		OBJ_RECT, OBJ_LINE : {graph.bringtofront}
	end
end;

{function objs_type.get_common_attributes : cl_common_attributes;
begin
	result := NIL;	// ad uso prevalente del compilatore
	case ca.tipo_oggetto of
		LABEL_OBJ : result := lab.attr;
		DATAMATRIX : result := dm.attr;
		OBJ_BITMAP : result := bmp.attr;
		OBJ_RECT, OBJ_LINE : result := graph.attr
	end
end;}

{$ifdef GALATEO_EXE}

	function objs_type.save(var f : text) : boolean;
	begin
		case ca.tipo_oggetto of
			LABEL_OBJ : result := lab.save(f, xref);
			DATAMATRIX_OBJ : result := dm.save(f, xref);
			OBJ_BITMAP : result := bmp.save(f,xref);
			OBJ_RECT, OBJ_LINE : result := graph.save(f,xref);
			else result := FALSE
		end
	end;

	function objs_type.selected : boolean;
	begin
		try
			result := ca.bo_selected
		except
			{$ifdef DEBUG} assert(FALSE,'NLK 102'); {$endif}
			result := FALSE
		end
	end;

	function objs_type.check_resize(i_obj : obj_index_type;i_delta_h,i_delta_w,i_delta_x,i_delta_y : int_pixel_type) : boolean;
	{ verifica se in seguito allo spostamento dell'oggetto I_OBJ si debbano eseguire
	  degli aggiornamenti sull'oggetto SELF;
	  rende TRUE se vengono eseguite modifiche su SELF }
//	var tipo : obj_type;
	begin
		result := FALSE;
		if globale.bo_exclude_azioni_comunitarie then exit;
		if (MR_MOVE in MR_AVAILABLE[ca.tipo_oggetto]) then begin
			if ((i_delta_x <> 0) OR (i_delta_y <> 0)) AND (name2index(xref.str_pos) = i_obj) then begin
				set_left(get_left + i_delta_x);
				set_top(get_top + i_delta_y);
				result := TRUE
			end
		end;
		if (MR_RESIZE in MR_AVAILABLE[ca.tipo_oggetto]) then begin
			if (i_delta_h <> 0) AND (name2index(xref.str_vert) = i_obj) then begin
				set_height(get_height + i_delta_h);
				result := TRUE
			end;
			if (i_delta_w <> 0) AND (name2index(xref.str_horz) = i_obj) then begin
				set_width(get_width + i_delta_w);
				result := TRUE
			end
		end
	end;	

	procedure objs_type.on_change_size_and_pos;
//	var i_delta_h, i_delta_w, i_delta_x, i_delta_y : int_pixel_type;
	begin
//		if globale.bo_loading_file then exit;	// durante il caricamento il meccanismo viene disabilitato
		if (get_tipo_oggetto = OBJ_BITMAP) AND bmp.bo_mantieni_proporzioni AND (bmp.fl_original_ratio <> 0) then begin
			if (get_height <> i_old_height) then bmp.Width := round(bmp.Height * bmp.fl_original_ratio)
			else
			if (get_width <> i_old_width) then bmp.Height := round(bmp.Width / bmp.fl_original_ratio)
		end;

		if NOT globale.bo_exclude_azioni_comunitarie AND (i_old_left + i_old_top + i_old_width + i_old_height <> 0) then begin
			var i_delta_h : int_pixel_type := get_height - i_old_height;
			var i_delta_w : int_pixel_type := get_width - i_old_width;
			var i_delta_x : int_pixel_type := get_left - i_old_left;
			var i_delta_y : int_pixel_type := get_top - i_old_top;
			if (i_delta_h <> 0) OR (i_delta_w <> 0) OR (i_delta_x <> 0) OR (i_delta_y <> 0) then
//				check_resize_all(obj2index(self), i_delta_h, i_delta_w, i_delta_x, i_delta_y)
				check_resize_all(i_numero_obj, i_delta_h, i_delta_w, i_delta_x, i_delta_y)
		end;
		i_old_height := get_height;i_old_width := get_width;
		i_old_left := get_left;i_old_top := get_top
	end;

	function objs_type.pbox : TGalPaintBox;
	begin pbox := panel.pbox end;

	function objs_type.panel : TGalPanel;
	begin panel := panels_1B(ca.i_section_1B) end;

{$endif}

function objs_type.load(var f : text;tipo_variabile : variabile_type;wo_versione : word) : boolean;
begin
//	runtime_debug('BEGIN','objs_type.load()',FALSE);
	case ca.tipo_oggetto of
		LABEL_OBJ : result := lab.load(f, xref, tipo_variabile, wo_versione);
		DATAMATRIX_OBJ : result := dm.load(f, xref, wo_versione);
		OBJ_BITMAP : result := bmp.load(f, xref, wo_versione);
		OBJ_RECT, OBJ_LINE : result := graph.load(f, xref, wo_versione)
		else result := FALSE
	end;
	if NOT result then runtime_debug('FALSE!' + ACAPO + '<' + get_name + '>','objs_type.load()', RD_DEBUG_PRINCIPALE_00)
end;

procedure objs_type.set_left(x : int_pixel_type);
begin
	case ca.tipo_oggetto of
		LABEL_OBJ : lab.Left := x;
		DATAMATRIX_OBJ : dm.Left := x;
		OBJ_BITMAP : bmp.Left := x;
		OBJ_RECT, OBJ_LINE : graph.Left := x
	end;
	{$ifdef GALATEO_EXE} on_change_size_and_pos {$endif}
end;

procedure objs_type.set_top(y : int_pixel_type);
begin
	case ca.tipo_oggetto of
		LABEL_OBJ : lab.Top := y;
		DATAMATRIX_OBJ : dm.Top := y;
		OBJ_BITMAP : bmp.Top := y;
		OBJ_RECT, OBJ_LINE : graph.Top := y
	end;
	{$ifdef GALATEO_EXE} on_change_size_and_pos {$endif}
end;

procedure objs_type.set_width(w : int_pixel_type);
begin
	w := MAX(w,0);
	case ca.tipo_oggetto of
		LABEL_OBJ : begin
			if globale.bo_text_only then w := get_x_left_virtuale(w+1); // +1 perchè arrotonda per difetto
			lab.Width := w
		end;
		DATAMATRIX_OBJ : dm.Width := w;
		OBJ_BITMAP : bmp.Width := w;
		OBJ_RECT, OBJ_LINE : begin graph.Width := MAX(w+1,graph.i_thickness);graph.i_actual_width := w end
	end;
	{$ifdef GALATEO_EXE} on_change_size_and_pos {$endif}
end;

procedure objs_type.set_height(h : int_pixel_type);
begin
	h := MAX(h,0);
	case ca.tipo_oggetto of
		LABEL_OBJ : begin lab.Height := h;lab.bo_autoheight := FALSE end;
		DATAMATRIX_OBJ : dm.Height := h;
		OBJ_BITMAP : bmp.Height := h;
		OBJ_RECT, OBJ_LINE : begin graph.Height := MAX(h+1,graph.i_thickness);graph.i_actual_height := h end
	end;
	{$ifdef GALATEO_EXE} on_change_size_and_pos {$endif}
end;

function objs_type.get_top : int_pixel_type;
begin
	case ca.tipo_oggetto of
		LABEL_OBJ : result := lab.Top;
		DATAMATRIX_OBJ : result := dm.Top;
		OBJ_BITMAP : result := bmp.Top;
		OBJ_RECT, OBJ_LINE : result := graph.Top;
		else result := 0
	end
end;

function objs_type.get_left : int_pixel_type;
begin
	case ca.tipo_oggetto of
		LABEL_OBJ : result := lab.Left;
		DATAMATRIX_OBJ : result := dm.Left;
		OBJ_BITMAP : result := bmp.Left;
		OBJ_RECT, OBJ_LINE : result := graph.Left
		else result := 0
	end
end;

function objs_type.get_width(bo_uso_selezione : boolean = FALSE) : int_pixel_type;
begin
	case ca.tipo_oggetto of
		LABEL_OBJ : result := lab.Width;
		DATAMATRIX_OBJ : result := dm.Width;
		OBJ_BITMAP : result := bmp.Width;
		OBJ_RECT : result := graph.i_actual_width;
		OBJ_LINE : begin
			result := graph.i_actual_width;
			if bo_uso_selezione then result := max(result, graph.i_thickness)
		end;
		else result := 0
	end
end;

function objs_type.get_height(bo_uso_selezione : boolean = FALSE) : int_pixel_type;
begin
	case ca.tipo_oggetto of
		LABEL_OBJ : result := lab.Height;
		DATAMATRIX_OBJ : result := dm.Height;
		OBJ_BITMAP : result := bmp.Height;
		OBJ_RECT : result := graph.i_actual_height;
		OBJ_LINE : begin
			result := graph.i_actual_height;
			if bo_uso_selezione then result := max(result, graph.i_thickness)
		end;
		else result := 0
	end
end;

function objs_type.get_hints : string;
begin
	case ca.tipo_oggetto of
		LABEL_OBJ : result := lab.Hint;
		DATAMATRIX_OBJ : result := dm.Hint;
		OBJ_BITMAP : result := bmp.Hint;
		OBJ_RECT, OBJ_LINE : result := graph.Hint;
	end
end;	

procedure objs_type.set_show_hints(bo_show : boolean);
begin
	case ca.tipo_oggetto of
		LABEL_OBJ : lab.showhint := bo_show;
		DATAMATRIX_OBJ : dm.ShowHint := bo_show;
		OBJ_BITMAP : bmp.showhint := bo_show;
		OBJ_RECT, OBJ_LINE : graph.showhint := bo_show
	end
end;

(*function objs_type.get_section : section_index_type;
// rende la sezione cui appartiene l'oggetto
begin
	result := ca.i_section
{	case ca.tipo_oggetto of
		LABEL_OBJ : result := lab.i_section;
		DATAMATRIX : result := dm.i_section;
		OBJ_BITMAP : result := bmp.i_section;
		OBJ_RECT, OBJ_LINE : result := graph.i_section
		else result := -1
	end }
end;

procedure objs_type.set_section(i_section : section_index_type);
begin
	ca.i_section := i_section
{	case ca.tipo_oggetto of
		LABEL_OBJ : lab.i_section := i_section;
		DATAMATRIX : dm.i_section := i_section;
		OBJ_BITMAP : bmp.i_section := i_section;
		OBJ_RECT, OBJ_LINE : graph.i_section := i_section
	end }
end; *)

function objs_type.set_show_state(show : show_types) : show_types;
// imposta la modalità di visualizzazione per l'oggetto; rende lo stato precedente dell'oggetto
begin
	result := ca.show;
	{$ifdef DLL}	// if DLL non serve altro
		ca.show := show
	{$else}
		case ca.tipo_oggetto of
			LABEL_OBJ : lab.set_show_state(show);
			DATAMATRIX_OBJ : dm.set_show_state(show);
			else ca.show := show
		end
	{$endif}
end;

function objs_type.get_show_state : show_types;
// rende lo stato dell'oggetto
begin
	result := ca.show
{	case ca.tipo_oggetto of
		LABEL_OBJ : result := lab.show;
		DATAMATRIX_OBJ : result := dm.show;
		OBJ_BITMAP : result := bmp.show;
		OBJ_RECT, OBJ_LINE : result := graph.show;
		else result := OSW_SHOW	// default, ma solo per evitare la warning del compiler
	end }
end;

procedure objs_type.set_visible(bo_visible : boolean);
// imposta la property VISIBLE per l'objecto; restituisce lo stato precedente
begin
	case ca.tipo_oggetto of
		LABEL_OBJ : lab.Visible := bo_visible;
		DATAMATRIX_OBJ : dm.Visible := bo_visible;
		OBJ_BITMAP : bmp.Visible := bo_visible;
		OBJ_RECT, OBJ_LINE : graph.Visible := bo_visible
	end
end;

(*function objs_type.get_handle : hwnd;
begin
	case ca.tipo_oggetto of
//		TESTO, VARIABILE, FORMULA : result := lab.font.handle;
		TESTO, VARIABILE, FORMULA : result := lab.get_font_handle;		{$ifndef DEBUG} ************ {$endif}
		OBJ_BITMAP : result := bmp.canvas.handle;
		OBJ_RECT, OBJ_LINE : result := {graph.handle}0;
		else result := 0
	end
end;*)

{$ifdef CASA}

var bo_printing : boolean;

function objs_type.print(vcanvas, pcanvas : TCanvas;x0, y0 : int_pixel_type;bo_video : boolean;
	ptcr : pTRect;var i_delta_y : int_pixel_type;var i_max_y_pixel : int_pixel_type;
	i_delta_y_bottom, i_margine_y_pixel : int_pixel_type;bo_can_break_object : boolean;
	i_ph_first_page_section, i_ph_last_page_section : ph_page_type;ptr_print_section : {cl_print_section}pointer = NIL) : boolean;
// vedi commento a PRINT_PROC_TYPE

	function calcola_formula_base(str_formula : string) : double;
	// elabora la formula di posizionamento/ridimensionamento; rende il valore della formula
	var str_result : string;	//*
	begin
		str_formula := translate_local_macros(str_formula);	// 2005-06-20
		sections_1B(ca.i_section_1B).interpreta_string(str_formula, {stampa_vera}TRUE, {check_errors}FALSE);		// 2005-04-10
		var tipo : risultato_type := VAL_NUMERO;
		if NOT translate_formula(str_formula, str_result, {test}FALSE, tipo, NIL)
			then raise exception.create('Errore nel calcolo runtime della posizione');
		result := strTofloat(check_decimal_format(str_result))		// estraggo il valore in CM
	end;

	function calcola_formula_pos_shift(str_formula_CM : string;tipo_formula : shift_formula_type;bo_horz : boolean;i_base_pos : int_pixel_type) : int_pixel_type;
	{ calcola la formula di posizionamento; rende lo SPOSTAMENTO da applicare per ottenere il risultato desiderato;
	  i valori sono espressi in VIDEOPIXEL o in PRINTPIXEL, in base a BO_VIDEO }
	var fl_formula_cm, fl_posizione_attuale : double;
	begin
		fl_formula_cm := calcola_formula_base(str_formula_CM);	// estraggo il valore in CM

		if (tipo_formula = SHFT_ABSOLUTE) then begin	// calcolo lo sfasamento rispetto alla posizione attuale
			if bo_horz then fl_posizione_attuale := video2cm_x(get_Left) else fl_posizione_attuale := video2cm_y(get_Top);	// get_LEFT e get_TOP sono cmq VIDEO
			fl_formula_cm := fl_formula_cm - fl_posizione_attuale
		end;
		if bo_video then if bo_horz then result := cm2pixel_video_x(fl_formula_cm) else result := cm2pixel_video_y(fl_formula_cm)
		else if bo_horz then result := cm2pixel_print_x(fl_formula_cm) else result := cm2pixel_print_y(fl_formula_cm);
		result := i_base_pos + result
	end;

	function calcola_formula_size_shift(str_formula_CM : string;tipo_formula : shift_formula_type;bo_horz : boolean;i_video_size : int_pixel_type) : int_pixel_type;
	{ calcola la formula di ridimensionamento; rende la dimensione effettiva dell'oggetto;
	  I_ACTUAL_SIZE è la dimensione dell'oggetto prima dell'elaborazione	(ACTUAL può essere inteso sia nel suo significato italiano che in quello inglese :-) )
	  in base a BO_VIDEO restituisce un valore espresso in VIDEOPIXEL o in PRINTPIXEL }
	begin
		var fl_actual_size_CM : double := 0;
		if (tipo_formula = SHFT_RELATIVE) then	// devo convertire il valore da pixel video a CM
			if bo_horz then fl_actual_size_CM := video2cm_x(i_video_size) else fl_actual_size_CM := video2cm_y(i_video_size);
		var fl_size_cm : double := fl_actual_size_CM + calcola_formula_base(str_formula_CM);	// estraggo il valore in CM

		if bo_video then if bo_horz then result := cm2pixel_video_x(fl_size_cm) else result := cm2pixel_video_y(fl_size_cm)
		else if bo_horz then result := cm2pixel_print_x(fl_size_cm) else result := cm2pixel_print_y(fl_size_cm)
	end;

begin
	{$ifdef DEBUG} assert(NOT bo_printing, 'objs_type.print: chiamata rientrante'); {$endif}
	{$ifdef DEBUG} assert(pcanvas <> NIL, 'print canvas necessario'); {$endif}
	i_max_y_pixel := 0;
	if bo_dont_print OR bo_printing then begin result := TRUE;exit end;

	if (ca.str_formula_Xpos_cm <> '') then x0 := calcola_formula_pos_shift(ca.str_formula_Xpos_cm, ca.tipo_formula_Xpos, {horz}TRUE, x0);
	if (ca.str_formula_Ypos_cm <> '') then y0 := calcola_formula_pos_shift(ca.str_formula_Ypos_cm, ca.tipo_formula_Ypos, {horz}FALSE, y0);
	if (ca.tipo_oggetto in [OBJ_RECT, OBJ_LINE]) then begin	// negli altri casi non ha senso, ed è cmq ignorata
		var rp : cl_rect := asgraph;
		if (ca.str_formula_DX_cm = '') then
			if bo_video then rp.i_executive_width := rp.i_actual_width
			else rp.i_executive_width := tm.video2print_pixel_x(rp.i_actual_width)
		else rp.i_executive_width := calcola_formula_size_shift(ca.str_formula_DX_cm, ca.tipo_formula_DX, {horz}TRUE, rp.i_actual_width);
		if (ca.str_formula_DY_cm = '') then
			if bo_video then rp.i_executive_height := rp.i_actual_height
			else rp.i_executive_height := tm.video2print_pixel_y(rp.i_actual_height)
		else rp.i_executive_height := calcola_formula_size_shift(ca.str_formula_DY_cm, ca.tipo_formula_DY, {horz}FALSE, rp.i_actual_height)
	end;

	bo_printing := TRUE;
	var pp : print_proc_type := NIL;
	try
		case ca.tipo_oggetto of
			LABEL_OBJ : pp := lab.print;
			DATAMATRIX_OBJ : pp := dm.print;
			OBJ_BITMAP : pp := bmp.print;
			OBJ_RECT, OBJ_LINE : pp := graph.print;
			else begin {$ifdef DEBUG} assert(FALSE, 'objs_type.print(): valore errato -- JKOI 4923'); {$endif} abort end
		end;
		result := pp(vcanvas, pcanvas, x0, y0, bo_video, ptcr, i_delta_y, i_max_y_pixel, i_delta_y_bottom, i_margine_y_pixel, 0, bo_can_break_object,
			i_ph_first_page_section, i_ph_last_page_section, ptr_print_section)
	finally
		bo_printing := FALSE
	end
end;
{$endif CASA}

function objs_type.get_x_left_virtuale(x_left : int_pixel_type) : int_pixel_type;
begin
	case ca.tipo_oggetto of
		LABEL_OBJ : result := lab.get_x_left_virtuale(x_left);
		DATAMATRIX_OBJ : result := dm.get_x_left_virtuale(x_left);
		OBJ_BITMAP: result := bmp.get_x_left_virtuale(x_left);
		OBJ_RECT, OBJ_LINE : result := graph.get_x_left_virtuale(x_left);
		else result := 0
	end
end;

{$ifdef GALATEO_EXE}
	function objs_type.get_y_top_virtuale(y_top : int_pixel_type) : int_pixel_type;
	begin
		case ca.tipo_oggetto of
			LABEL_OBJ : result := lab.get_y_top_virtuale(y_top);
			DATAMATRIX_OBJ : result := dm.get_y_top_virtuale(y_top);
			OBJ_BITMAP: result := bmp.get_y_top_virtuale(y_top);
			OBJ_RECT, OBJ_LINE : result := graph.get_y_top_virtuale(y_top);
			else begin
				{$ifdef DEBUG} assert(FALSE,'get_y_top_virtuale'); {$endif}
				result := 0
			end
		end
	end;
{$endif}

procedure objs_type.get_print_pos_and_size(var r_delta_y0_print,r_delta_y_int_print : misura_real_type);
// legge valori posizionali stampa
begin
	r_delta_y0_print := self.r_delta_y0_print;
	r_delta_y_int_print := self.r_delta_y_int_print
end;

procedure objs_type.set_print_pos_and_size(r_delta_y0_print,r_delta_y_int_print : misura_real_type);
// assegna valori posizionali stampa
begin
	self.r_delta_y0_print := r_delta_y0_print;
	self.r_delta_y_int_print := r_delta_y_int_print
end;

{$ifdef GALATEO_EXE}

	procedure objs_type.select(bo_select,bo_beep_on_change_status,bo_update_info_selezione : boolean);
	begin
//		var i_numero_obj : obj_index_type := obj2index(self);	// USO quello interno
		if (is_selected(i_numero_obj) = bo_select) then exit;
		panels_1B(ca.i_section_1B).set_active(TRUE);
		set_selected_obj(i_numero_obj, bo_select, bo_beep_on_change_status, bo_update_info_selezione);
		case ca.tipo_oggetto of
			LABEL_OBJ : lab.select(bo_select);
			DATAMATRIX_OBJ : dm.select(bo_select);
			OBJ_BITMAP : bmp.select(bo_select);
			OBJ_RECT, OBJ_LINE : graph.select(bo_select)
		end;
		if bo_select then bringToFront
	end;

	procedure objs_type.edit_object;
	begin
//		obj.select(0,FALSE,FALSE);
		case ca.tipo_oggetto of
			LABEL_OBJ : lab.edit_object;
			DATAMATRIX_OBJ : dm.edit_object;
			OBJ_BITMAP: bmp.edit_object;
			OBJ_RECT, OBJ_LINE : graph.edit_object
		end;
//		obj.select(obj.obj2index(self),FALSE,FALSE)
	end;

	procedure objs_type.check_size;
	// verifica che l'oggetto non abbia misure sballate; da usare in fase di caricamento da file

		procedure msg(str_arg : string);
		begin
			MessageBBox(0, TIPO_OGGETTO_DESCRIZIONE[ca.tipo_oggetto] + ' <' + get_name + '>' + ACAPO +
				'sezione ' + sections_1B(ca.i_section_1B).str_nome + ACAPO2 + str_arg, 'Notifica correzioni automatiche', MB_ICONSTOP);
			set_name('*' + get_name + '*')
		end;

	begin
		var r_x_cm_max : misura_real_type := get_Vpage_size_X_cm(get_pagina_logica_attiva_1B);
		var r_y_cm_max : misura_real_type := sections_1B(ca.i_section_1B).r_y_gruppo_cm;
		if (ca.tipo_oggetto <> OBJ_LINE) then begin
			if (get_width < 1) then begin set_width(20);msg('larghezza nulla') end;
			if (get_height < 1) then begin set_height(20);msg('altezza nulla') end
		end
		else begin
			if (get_width < 1) AND (get_height < 1) then begin set_width(10);set_height(10);msg('dimensione nulla') end
		end;

		if (get_top + get_height < 0) then begin set_top(0);msg('sopra l''orizzonte') end;
		if (video2cm_x(get_left) < 0) then begin set_left(0);msg('troppo a sx') end;
		if (video2cm_y(get_top) >= r_y_cm_max) then begin
			set_top(cm2pixel_video_y(r_y_cm_max) - get_height);msg('sotto l''orizzonte')
		end;
		if (video2cm_x(get_left) >= r_x_cm_max) then begin
			set_left(cm2pixel_video_x(r_x_cm_max) - get_width);msg('troppo a dx')
		end
	end;

	procedure objs_type.check_pos_in_section;
	{ verifica che l'oggetto non sia coperto da una sotto-sezione;
	  se I_SECTION=0 esegue il controllo per gli oggetti di tutte le sezioni }
	begin
		// verifico che sia nell'area valida
		if (get_top + get_height > cm2pixel_video_y(sections_1B(ca.i_section_1B).r_y_gruppo_cm)) then
			set_top(cm2pixel_video_y(sections_1B(ca.i_section_1B).r_y_gruppo_cm) - get_height);

		// verifico che non sia coperto da sub-sections
		for var i_ZB : section_index_type := 0 to get_num_sections - 1 do begin
			if NOT is_antenato_ZB(i_ZB, ca.i_section_1B - 1) then continue;
			// posizione oggetto: inizio, fine
			var o1 : TPoint := panel.ClientToScreen(Point(0, get_top));
			var o2 : TPoint := panel.ClientToScreen(Point(0, get_top + get_height));
			// posizione subsection: inizio, fine
			var s1 : TPoint := panels_ZB(i_ZB).ClientToScreen(Point(0, 0));
			var s2 : TPoint := panels_ZB(i_ZB).ClientToScreen(Point(0, panels_ZB(i_ZB).Height));

			var bo_change := FALSE;

			// cornici e linee: intervengo solo se l'obj è completamente nascosto dalla subsection
			if (ca.tipo_oggetto in CORNICI_OBJS) AND ((o1.y < s1.y-2) OR (o2.y > s2.y+2)) then break;

			// se il top dell'oggetto è nascosto dalla sottosezione, lo mando sotto la subsection
			if (o1.y > s1.y) AND (o1.y < s2.y) then begin
				o1.y := s2.y;o2.y := o1.y + get_height;
				bo_change := TRUE
			end;
			// se il fondo dell'oggetto è nascosto dalla sottosezione, lo mando sopra la subsection
			if (o2.y > s1.y) AND (o2.y < s2.y) then begin
				o1.y := s1.y - get_height;o2.y := o1.y + get_height;
				bo_change := TRUE
			end;
			if bo_change then begin o1 := panel.ScreenToClient(o1);set_top(o1.y) end;
			break // poichè il nipote è più piccolo del figlio, basta verificare il figlio
		end
	end;

	procedure objs_type.change_riferimenti(str_old_name, str_new_name: string);
	{ dopo che il nome di un oggetto è stato modificato da STR_OLD_NAME a STR_NEW_NAME, la procedura si occupa di trasmettere la modifica
	  nelle situazioni in cui l'oggetto modificato era citato: legami comunitari, eccetera }
	begin
//		if NOT (ca.tipo_oggetto in [{TESTO,}xxVARIABILE, xxFORMULA, DATAMATRIX, {BITMAP,}OBJ_RECT, OBJ_LINE]) then exit;
		if NOT (ca.tipo_oggetto in [LABEL_OBJ, DATAMATRIX_OBJ, {BITMAP,}OBJ_RECT, OBJ_LINE]) then exit;
		str_old_name := togliblanks(uppercase(str_old_name));
		if (str_old_name = '') then exit;	// altrimenti fa un puttanaio che la metà basta
		for var i : obj_index_type := 1 to i_objs do begin
			var obj : objs_type := xobjs(i);
			var xref : reference_obj := obj.xref;
			if (uppercase(xref.str_pos) = str_old_name) then xref.str_pos := str_new_name;
			if (uppercase(xref.str_vert) = str_old_name) then xref.str_vert := str_new_name;
			if (uppercase(xref.str_horz) = str_old_name) then xref.str_horz := str_new_name;

			case obj.ca.tipo_oggetto of
				LABEL_OBJ : begin
					if (uppercase(obj.lab.str_usa_formato_valuta) = str_old_name)
						then obj.lab.str_usa_formato_valuta := str_new_name
				end;
//				BITMAP :
//				OBJ_RECT, OBJ_LINE : ;
			end
		end;

		for var i : section_index_type := 1 to get_num_sections do begin
			var sz := sections_1B(i);
			if (uppercase(sz.str_obj_line_bottom_pos_and_width) = str_old_name)
				then sz.str_obj_line_bottom_pos_and_width := str_new_name
		end
	end;

	function objs_type.is_in_rectangle(p1,p2 : TSmallPoint;bo_selezione_inclusiva : boolean = FALSE {$ifdef DEBUG} ;bo_debug : boolean = FALSE {$endif}) : boolean;
	{ rende TRUE se l'oggetto cade nel rettangolo (p1,p2);
	  se bo_selezione_inclusiva deve cadere completamente nel rettangolo, altrimenti basta anche solo un pezzettino }
	var
		x1,x2,y1,y2 : int_pixel_type;			// coordinate del rettangolo
		ox1,ox2,oy1,oy2 : int_pixel_type;	// coordinate dell'oggetto
	begin
		x1 := min(p1.x, p2.x);x2 := max(p1.x, p2.x);y1 := min(p1.y, p2.y);y2 := max(p1.y, p2.y);
		ox1 := get_left;ox2 := ox1 + get_width;oy1 := get_top;oy2 := oy1 + get_height;
		if bo_selezione_inclusiva then result := (x1 <= ox1) AND (x2 >= ox2) AND (y1 <= oy1) AND (y2 >= oy2)
		else result := (x1 <= ox2) AND (x2 >= ox1) AND (y1 <= oy2) AND (y2 >= oy1);
		{$ifdef DEBUG}
			if bo_debug then visual_debug(
				'AREA :: x1=' + zeri(x1,4) + ' x2=' + zeri(x2,4) + ' y1=' + zeri(y1,4) + ' y2=' + zeri(y2,4),
				'OBJ :: x1=' + zeri(ox1,4) + ' x2=' + zeri(ox2,4) + ' y1=' + zeri(oy1,4) + ' y2=' + zeri(oy2,4),
				ifs(result, 'TRUE', 'FALSE'))
		{$endif}
	end;

{$endif}

function objs_type.get_debug_caption : string;
begin
	case ca.tipo_oggetto of
		LABEL_OBJ : result := lab.Caption;
		DATAMATRIX_OBJ : result := dm.Name;
		OBJ_BITMAP : result := bmp.get_name;
		OBJ_RECT, OBJ_LINE : result := graph.Caption
	end;
	result := 'oggetto <' + result + '>' + ifs(get_ultima_pagina_logica > 1,' (page ' + get_pagina_logica_attiva_1B.Tostring + ')')
end;

procedure init_after_loading;
// da richiamare dopo aver caricato un nuovo file
begin
	lo_creation := 0;
	for var i : obj_index_type := 1 to i_objs do xobjs(i).xref.check
end;

(*function tag2index(lo_tag : integer) : obj_index_type;
{ rende l'indice nel vettore OBJS[] dell'oggetto con il TAG specificato;
  rende 0 in caso di errore }
var i : obj_index_type;
begin
	for i := 1 to i_objs do
		if (lo_tag = objs(i).get_tag) then begin tag2index := i;exit end;
	tag2index := 0
end;*)

(*function __xytag2object(lo_tag : integer) : objs_type; 		{$ifndef DEBUG} eliminare !!!! {$endif}
// rende NIL in caso di fallimento
begin
	lo_tag := _tag2index(lo_tag);
	if (lo_tag = 0) then result := NIL else result := xobjs(lo_tag)
end;	*)

(*function obj2index(obj : objs_type) : obj_index_type;
{ rende l'indice nel vettore OBJS[] dell'oggetto specificato;
  rende 0 in caso di errore }
var i : obj_index_type;
begin
	for i := 1 to i_objs do
		if (obj = objs(i)) then begin obj2index := i;exit end;
	obj2index := 0
end;*)

function name2obj(str_nome : string;bo_all_pages : boolean;i_exclude_object : obj_index_type = 0) : objs_type;
const objs : obj_type_set = [];
begin
	result := name2obj(str_nome, objs, bo_all_pages, i_exclude_object)
end;

function name2obj(str_nome : string;suitable_obj_types : obj_type_set;bo_all_pages : boolean;i_exclude_object : obj_index_type = 0) : objs_type;
{ rende un puntatore all'oggetto con il nome specificato;
  rende NIL in caso di errore, ovvero di oggetto non trovato;
  if BO_ALL_PAGES cerca in tutte le pagine del file, a partire da quella aperta,
  quindi dalla prima per arrivare fino all'ultima; altrimenti cerca solo nella
  pagina aperta }
var
	i_ndx : obj_index_type;	//*
	i_page : logical_page_type;
begin
	{$ifdef DEBUG} if bo_all_pages then assert(i_exclude_object = 0, 'i_exclude_object può essere usato solo su pagine singole -- JKPE 9391'); {$endif}
	if bo_all_pages then begin
		i_page := 0;		// 2011-05-19
		i_ndx := name2index(str_nome, suitable_obj_types, i_page)		// in questo caso I_EXCLUDE_OBJECT non ha molto senso
	end
	else begin
		i_page := get_pagina_logica_attiva_1B;
		i_ndx := name2index(str_nome, suitable_obj_types, FALSE, i_page, i_exclude_object)
	end;
	if (i_ndx <> 0) then result := xobjs(i_ndx, i_page) else result := NIL
end;

function name2obj(str_nome : string;suitable_var_types : variabile_set;bo_all_pages : boolean;i_exclude_object : obj_index_type = 0) : objs_type; overload;
begin
	{$ifdef DEBUG} if bo_all_pages then assert(i_exclude_object = 0, 'i_exclude_object può essere usato solo su pagine singole -- JKPE 9391'); {$endif}
(*	if bo_all_pages then begin
		i_page := 0;	// 2011-05-19
		i_ndx := name2index(str_nome, suitable_var_types, i_page)		// in questo caso I_EXCLUDE_OBJECT non ha molto senso
	end
	else begin
		i_page := get_pagina_logica_attiva;
		i_ndx := name2index(str_nome, suitable_var_types, {FALSE,} i_page, i_exclude_object)
	end; *)

	var i_page : logical_page_type := get_pagina_logica_attiva_1B;		// prima cerco sulla pagina attiva
	var i_ndx : obj_index_type := name2index(str_nome, suitable_var_types, {FALSE,} i_page, i_exclude_object);
	if (i_ndx = 0) AND bo_all_pages then begin
		i_page := 0;
		while (i_page < get_ultima_pagina_logica) AND (i_ndx = 0) do begin
			inc(i_page);
			if (i_page <> get_pagina_logica_attiva_1B) then		// pagina attiva è già stata ricercata
				i_ndx := name2index(str_nome, suitable_var_types, i_page)		// in questo caso I_EXCLUDE_OBJECT non ha molto senso x' non è riferito ad una specifica pagina
		end
	end;

	if (i_ndx <> 0) then result := xobjs(i_ndx, i_page) else result := NIL
end;

function dbcolumn2obj(str_db_column : string) : objs_type;
{ restituisce il'oggtto corrispondente alla colonna di database specificata;
  rende NIL se l'oggetto non esiste;
  la ricerca viene eseguita solo nella pagina logica aperta }
begin
	var i_ndx : obj_index_type := name2index(str_db_column, [], TRUE, get_pagina_logica_attiva_1B);
	if (i_ndx = 0) then result := NIL else result := xobjs(i_ndx, get_pagina_logica_attiva_1B)
end;

function read_object_ZB(var f : system.Text;i_obj : obj_index_type;i_logical_page_ZB : logical_page_type;i_section_ZB : section_index_type;
	wo_versione : word;bo_read_index_from_file : boolean = TRUE) : obj_index_type;
{ BO_DONT_ASSIGN_NAME fa in modo che non venga assegnato il NOME all'oggetto, perchè a volte (ad esempio nel caso del copia-incolla)
  la generazione di un oggetto con il nome predefinito da luogo a problemi (DataMatrix);
  rende la posizione dell'oggetto letto;
  fino alla versione 030F l'indice (la posizione) dell'oggetto veniva generata automaticamente, a partire dalla versione 0310 tale valore
  viene letto da file (a meno che il parametro BO_GENERA_OBJECT_INDEX sia TRUE);
  utilizzare il valore passato come parametro quando la posizione non dipende da quanto scritto nel file (esempio: incolla da clipboard) }
var
	s : string;	//*
	i_obj_read : obj_index_type;	// indice dell'oggetto come letto da file; da ignorare se NOT BO_GENERA_OBJECT_INDEX
begin
	readln(f, s);
	s := uppercase(s);
	var tipo : obj_type := succ(FIRST_TIPO);		// necessario eseguire qui questa assegnazione per motivi di compilazione
	var tipo_variabile : variabile_type := TV_BLANK;
	if (wo_versione <= $0260) then begin
		// per motivi storici leggo il tipo di variabile in funzione del tipo di oggetto (che fino al 2011-05 era distinto tra TESTI, VARIABILI e FORMULE)
		if (s = OLD_TIPO_STATIC_TEXT_DESCRIZIONE) then tipo_variabile := TV_STATIC_TEXT else
		if (s = OLD_TIPO_VARIABILE_DESCRIZIONE) then tipo_variabile := TV_DB_FIELD else	// TB_DB_FIELD: antico valore default
		if (s = OLD_TIPO_FORMULA_DESCRIZIONE) then tipo_variabile := TV_FORMULA;
		if (tipo_variabile <> TV_BLANK) then tipo := LABEL_OBJ
	end;
	if (tipo_variabile = TV_BLANK) then begin
		while (tipo < LAST_TIPO) and (s <> uppercase(TIPO_OGGETTO_DESCRIZIONE[tipo])) do inc(tipo);
		if (tipo = LAST_TIPO) then abort
	end;
	if (wo_versione < $0310) then begin
		i_obj_read := 0;bo_read_index_from_file := FALSE		// fino alla versione $030F il valore non veniva mai letto dal file
	end
	else readln(f, i_obj_read);
	if bo_read_index_from_file then i_obj := i_obj_read;	// altrimenti utilizza il valore passato come parametro
	assign_obj(i_obj, objs_type.create_ZB({$ifdef DLL}NIL{$else}GM{$endif}, i_logical_page_ZB, i_section_ZB, tipo, i_obj, FALSE));
	if NOT xobjs(i_obj).load(f, tipo_variabile, wo_versione) then abort;
	result := i_obj
end;

{$ifdef GALATEO_EXE}

	procedure write_object(var f : system.Text;i_obj : obj_index_type);
	{ procedure fondamentalmente inutile, scritta esclusivamente per simmetria
	  estetica con la read_object; salva l'oggetto specificato }
	begin
		writeln(f, TIPO_OGGETTO_DESCRIZIONE[xobjs(i_obj).ca.tipo_oggetto]);
		writeln(f, i_obj, ' 0 0 0 0');		// dal 2013-05-01 ver $0310
		xobjs(i_obj).save(f)
	end;

	procedure delete_object(i_obj : obj_index_type;bo_conseguenze_video,bo_select_next : boolean);
	{ elimina l'oggetto specificato ed esegue tutte le operazioni connesse e necessarie;
	  if BO_CONSEGUENZE_VIDEO then mette in atto tutte le conseguenze di tipo video alla cancellazione;
	  if BO_SELECT_NEXT then seleziona l'oggetto piu' prossimo a quello eliminato }
	begin
		if bo_conseguenze_video then begin
			if (get_selected_obj_index(0) = i_obj) then obj_select(0, FALSE);
			xobjs(i_obj).set_visible(FALSE)
		end;

		xobjs(i_obj).free;

{		infelice metodo di riposizionamento usato sino al 2001-09-01
		if (i_obj <> i_objs) then assign_obj(i_obj,objs(i_objs)); }
		for var i : obj_index_type := i_obj to i_objs-1 do assign_obj(i, xobjs(i + 1));	// dal 2001-09-01

		assign_obj(i_objs, NIL);set_num_objs(i_objs - 1);

		if bo_conseguenze_video then begin
			if bo_select_next then obj_select(i_objs,TRUE);
			for var i : obj_index_type := 1 to i_objs do xobjs(i).xref.check	// controllo i riferimenti
		end;
		GM.bo_modified := TRUE
	end;

	function check_space_for_another_object_in_page(bo_message : boolean) : boolean;
	// verifica che vi sia spazio per un ulteriore oggetto nella pagina; rende TRUE se c'è spazio, FALSE altrimenti
	begin
		result := (i_objs < MAX_OBJS);
		if NOT result AND bo_message then
			MessageBBox(GH, 'Non è possibile inserire un altro oggetto perchè è stato raggiunto il numero massimo di oggetti nella pagina (' + inttostr(MAX_OBJS) + ')', MBOX_CAPTION)
	end;

	function new_obj_ZB(tipo : obj_type;i_logical_page_ZB : logical_page_type;i_section_ZB : section_index_type;ppos : TPoint) : obj_index_type;
	{ crea un nuovo oggetto del tipo specificato alla posizione specificata;
	  if (PPOS = (0,0)) then usa una posizione standard;
	  in caso di successo rende l'indice dell'oggetto generato, altrimenti rende 0 }
	begin
		if NOT check_space_for_another_object_in_page(TRUE) then begin result := 0;exit end;
		assign_obj(i_objs + 1, objs_type.create_ZB(GM, i_logical_page_ZB, i_section_ZB, tipo, i_objs+1, TRUE));
		set_num_objs(i_objs + 1);		// DOPO la creazione
		with ppos do if (x + y <> 0) then
			with xobjs(i_objs) do begin set_top(y);set_left(x) end;
		panels_ZB(i_section_ZB).griglia_virtuale;
		xobjs(i_objs).check_pos_in_section;
		{$ifdef GALATEO_EXE} obj_select(i_objs, TRUE); {$endif}
		set_global_modified;
		result := i_objs
	end;

	procedure check_objs_pos_in_section(i_section_1B : section_index_type);
	{ verifica che gli oggetti appartenenti alla sezione I_SECTION non siano
	  coperti da una sotto-sezione;
	  se I_SECTION=0 esegue il controllo per gli oggetti di tutte le sezioni }
	begin
		try
			set_wait_cursor(TRUE);
			for var i : obj_index_type := 1 to i_objs do
				if (i_section_1B = 0) OR (i_section_1B = xobjs(i).ca.i_section_1B) then
					xobjs(i).check_pos_in_section
		finally
			set_wait_cursor(FALSE)
		end
	end;

	const
		CLIPBOARD_MARK = '*GALATEO*';

	function tratta_mouse_messages(i_section_1B : section_index_type;var Message: TWMMouse) : boolean;
	{ verifica se il messaggio si riferisce ad un oggetto tra quelli privi di gestione
	  autonoma dei mouse-messages;
	  in caso affermativo gestisce il messaggio e rende TRUE (messaggio già trattato)
	  altrimenti rende FALSE }
//	var p : TgalPanel;

		procedure draw(bo_erase : boolean);
		begin
			var p : TgalPaintBox := panels_ZB(i_section_1B - 1).pbox;
			var old_mode : TPenMode := p.canvas.Pen.Mode;
			p.canvas.Pen.Mode := pmNotXor;		// use XOR mode to draw/erase
			p.canvas.pen.Color := COLORE_SELEZIONE;
			p.canvas.Rectangle(pm_down.x, pm_down.y, pm_last.x, pm_last.y);
			if NOT bo_erase {AND (pm_last <> message)} then
				p.canvas.Rectangle(pm_down.x, pm_down.y, message.xpos, message.ypos);
			if NOT bo_erase then pm_last := message.pos;
			p.canvas.Pen.Mode := old_mode
		end;

		procedure select_area;
		// seleziona/deseleziona tutti gli oggetti compresi nell'area PM_DOWN .. PM_LAST
		var
//			i_pagina : logical_page_type;
//			i_pagina_fisica : ph_page_type;
			bo_in_area : boolean;		// TRUE se l'oggetto si trova nell'area del mouse
			bo_obj_trattato : boolean;	// TRUE se l'oggetto è già stato trattato nella presente selezione (esiste in STR_AREA_SELECTING_OBJS)
			bo_selected_before : boolean;
//			ctrl : TControllo;
		begin
//			i_pagina := get_pagina_logica_attiva;
//			i_pagina_fisica := get_first_pagina_fisica_of_pagina_logica;
//			ctrl := globale.get_controllo;
			for var i_obj : obj_index_type := 1 to i_objs do begin
				var x : objs_type := xobjs(i_obj);
				if (x.ca.i_section_1B <> i_section_1B) then continue;
//				if NOT globale.bo_show_hidden_objects AND x.is_hidden(i_pagina_fisica) then continue;		commentato 2018-03-10, sostituito con riga successiva
				if NOT globale.bo_show_hidden_objects AND (x.get_show_state = OSW_HIDE) then continue;		// ignoro solamente se SEMPRE NASCOSTO

				if GM.bo_dont_select_texts AND (x.ca.tipo_oggetto = LABEL_OBJ) then continue;
				if GM.bo_dont_select_graphics_objs AND (x.ca.tipo_oggetto in CORNICI_OBJS) then continue;
				if (x.tipo_oggetto = OBJ_BITMAP) AND x.asbitmap.bo_sfondo_design_time then continue;

				bo_in_area := x.is_in_rectangle(pm_down, pm_last, SELEZIONE_INCLUSIVA);
				bo_selected_before := exists_code(str_objs_selected_before, i_obj);
				bo_obj_trattato := exists_code(str_area_selecting_objs, i_obj);
				if bo_in_area then begin
					if NOT bo_obj_trattato then begin
						x.select({in_area <>} NOT bo_selected_before, FALSE, FALSE);
						add_delimited(str_area_selecting_objs, i_obj)
					end
					// else non devo fare nulla
				end
				else if bo_obj_trattato then begin
					// se avevo già trattato l'oggetto, inverto la sua attuale selezione e lo tolgo dagli ogetti trattati
					x.select(NOT x.selected, FALSE, FALSE);
					str_area_selecting_objs := delete_delimited(str_area_selecting_objs, i_obj.ToString, FALSE)
				end
			end;
			GM.update_info_selection
				{$ifdef DEBUG}('(' + pm_down.x.ToString + ',' + pm_down.y.ToString + ') (' + message.xpos.ToString + ',' + message.ypos.ToString + ')'){$endif}
		end;

//	const
//		DX_BORDO_SCORRIMENTO = 10;	// ampiezza Y della fascia entro cui si genera lo scorrimento della finestra
//		PASSO_SCORRIMENTO = 1;
	begin
		result := FALSE;
//		p := panels(i_section);
		if bo_mouse_down then begin
			result := TRUE;
			case message.msg of
				WM_LBUTTONUP : begin
					bo_mouse_down := FALSE;
					SetCaptureControl(NIL);
					draw(TRUE)
				end;
				WM_MOUSEMOVE : begin
{					i := message.ypos + p.Top;var i_scorrimento : smallint := 0;
					if (i > GM.sbox.Height - DX_BORDO_SCORRIMENTO) then i_scorrimento := PASSO_SCORRIMENTO
					else if (i < DX_BORDO_SCORRIMENTO) then i_scorrimento := -PASSO_SCORRIMENTO;
					if (i_scorrimento <> 0) then begin
//						draw(TRUE);
						GM.sbox.vertscrollbar.position := GM.sbox.vertscrollbar.position + i_scorrimento;
//						draw(FALSE)
					end; }
					draw(FALSE);select_area
				end;
				else result := FALSE	// msg non gestito
			end
		end;

		if (message.msg = WM_MOUSEMOVE) then exit;
		var i_obj : obj_index_type := get_related_obj(CORNICI_OBJS, i_section_1B, message.xpos,message.ypos, NOT multi_selecting_keys_combination, TRUE);

		if (i_obj = 0) OR is_key_down(VK_MENU) then begin
			result := TRUE;
			case message.msg of
				WM_LBUTTONDOWN : begin
					if NOT multi_selecting_keys_combination then begin
						panels_ZB(i_section_1B - 1).set_active(TRUE);
						obj_select(0, FALSE);
						GM.update_info_selection
					end;
					str_area_selecting_objs := '';str_objs_selected_before := '';
					for var i : obj_index_type := 1 to i_objs do if xobjs(i).selected then add_delimited(str_objs_selected_before, i);
					SetCaptureControl(panels_ZB(i_section_1B - 1).pbox);
					bo_mouse_down := TRUE;
					pm_down := message.pos;pm_last := pm_down
				end
				else result := FALSE	// msg non gestito
			end
		end
		else begin
			with xobjs(i_obj).asgraph do case message.msg of
				WM_LBUTTONDOWN : WMLbuttonDown(message);
				WM_LBUTTONDBLCLK : WMLButtonDblclk(message);
				WM_LBUTTONUP : WMLButtonUp(message);
				WM_MOUSEMOVE: WMMousemove(message);
				WM_RBUTTONDOWN: WMRButtonDown(message)
			end;
			result := TRUE
		end
	end;

	procedure check_resize_all(i_obj : obj_index_type;i_delta_h, i_delta_w, i_delta_x, i_delta_y : int_pixel_type);
	{ l'oggetto I_OBJ comunica di aver cambiato posizione e/o dimensione;
	  gli altri oggetti vengono avvertiti perchè possano mettere in atto le azioni opportune }
	begin
		for var j : obj_index_type := 1 to i_objs do
			if (j <> i_obj) AND
				NOT xobjs(j).selected		// un oggetto selezionato viene già spostato per via diretta, la via indiretta è inutile e dannosa
			then xobjs(j).check_resize(i_obj, i_delta_h, i_delta_w, i_delta_x, i_delta_y)
	end;

	procedure cut_clipboard(i_obj : obj_index_type);
	begin
		if (i_obj <= 0) then begin beep(0);exit end;
		copy_clipboard(i_obj);
		delete_object(i_obj, TRUE, TRUE)
	end;

	procedure copy_clipboard(i_obj : obj_index_type);
	{ copia l'oggetto I_OBJ sulla clipboard;
	  se I_OBJ = 0 then copia in sequenza tutti gli oggetti selezionati }
	var
		f : text;
		str_filename, str_stack, str_stack_selected : string;
	begin
		try
			set_wait_cursor(TRUE);
			try
				var i_num_objs : obj_index_type := push_selected(str_stack_selected,TRUE);
				if (i_obj = 0) then begin
					if (i_num_objs = 0) then begin beep(0);exit end;
					str_stack := str_stack_selected
				end
				else begin
					i_num_objs := 1;
					str_stack := i_obj.ToString
				end;
				str_filename := TEMP_FILENAME(BMP_EXT);	// la BMP extension è richiesta solo per gli oggetti BMP
//				new(f);
				try
					assign(f, str_filename);rewrite(f);
					writeln(f, CLIPBOARD_MARK);	// identificatore della clipboard di Galateo
					for var i : obj_index_type := 1 to i_num_objs do write_object(f, get_stack_obj(str_stack, i));
					close(f);
					text_file2clipboard(str_filename)
				finally
					{$I-}
					close(f);if (IOresult = 0) then;	// ripeto, non si sa mai
					erase(f);if (IOresult = 0) then;
					{$I+}
//					dispose(f)
				end;
			except
				MessageBBox(0, 'Errore durante la copia degli oggetti', MBOX_CAPTION, MB_ICONSTOP)
			end
		finally
			pop_selected(str_stack_selected);
			set_wait_cursor(FALSE)
		end
	end;

	procedure paste_clipboard;
	var
		f : text;
		str_temp, str_stack : string;	//*
	begin
//		new(f);
		try
			set_wait_cursor(TRUE);
			try
				if NOT clipboard.hasformat(CF_TEXT) then begin	// non può essere cosa di Galateo
					beep(0);exit
				end;
				var str_filename := TEMP_FILENAME(BMP_EXT);
				try
					text_clipboard2file(str_filename);
					assign(f, str_filename);reset(f);
					readln(f, str_temp);
					if (str_temp <> CLIPBOARD_MARK) then begin beep(0);close(f);exit end;	// non è cosa di Galateo
					obj_select(0, FALSE);
					while NOT Eof(f) do begin
						if NOT check_space_for_another_object_in_page(TRUE) then break;
						read_object_ZB(f, i_objs+1, get_pagina_logica_attiva_ZB, get_section_attiva_ZB, GALATEO_VERSION, {read_index_from_file}FALSE);
						set_num_objs(i_objs+1);{obj.select(i_objs);}
						str_stack := togliblanks(str_stack + ' ' + i_objs.ToString);
						// verifico che il nome sia univoco; eccezione: gli oggetti di testo
						with xobjs(i_objs) do begin
//							if (get_tipo_oggetto <> xTESTO) then begin	*** così fino al 2011-05-17
							if (get_tipo_variabile <> TV_STATIC_TEXT) then begin
								str_temp := get_name;
								set_name('X' + inttostr(random(1000000)) + '_' + str_temp);
								set_name(create_name(str_temp, TRUE))
							end
						end
					end;
					GM.bo_modified := TRUE	// segnalo l'avvenuta modifica
				finally
					{$I-}
					close(f);if (IOresult = 0) then;
					erase(f);if (IOresult = 0) then;
					{$I+}
				end;
				pop_selected(str_stack)
			except
				beep(0)
			end;
		finally
//			dispose(f);
			set_wait_cursor(FALSE)
		end
	end;

	// ----------- SELECT procedures -----------------------

	procedure obj_select(i_obj : obj_index_type;bo_select : boolean;bo_add : boolean = FALSE);
	// seleziona l'oggetto specificato; passa 0 per intendere 'tutti gli oggetti'
	begin
		if bo_select AND NOT bo_add AND (get_selected_obj_index(0) <> 0) then
			while (get_num_selected_objects > 0) do get_selected_obj(1).select(FALSE, FALSE, TRUE);
		if (i_obj = 0) then begin
			for var i : smallint := 1 to i_objs do
				if (is_selected(i) <> bo_select) then xobjs(i).select(bo_select, bo_add, TRUE)
		end
		else xobjs(i_obj).select(bo_select, bo_add, TRUE)
	end;

	function push_selected(var str_stack : string;bo_deselect : boolean) : obj_index_type;
	{ fotografa lo stato degli oggetti selezionati e lo carica sullo stack STR_STACK;
	  rende il numero di oggetti selezionati (e caricati sullo stack);
	  gli oggetti sono ordinati in ordine crescente }
	begin
		result := get_num_selected_objects;
		str_stack := '';	// precauzionale
		for var i : obj_index_type := 1 to result do add_delimited(str_stack, get_selected_obj_index(i), ' ');
{		for i := 1 to result do begin
			if (str_stack <> '') then str_stack := str_stack + ' ';
			str_stack := str_stack + inttostr(get_selected_obj_index(i))
		end; }
		if bo_deselect then obj_select(0, FALSE)
	end;

	function get_stack_obj(str_stack : string;i_pos : obj_index_type) : obj_index_type;
	// rende l'oggetto alla posizione I_POS dello stack STR_STACK; rende 0 se tale oggetto non esiste
	var j, k : integer;	//*
	begin
		var i_obj : obj_index_type := 0;result := 0;	// default: no objs found
		while (str_stack <> '') do begin
			var i : obj_index_type := pos(' ', str_stack);if (i = 0) then i := length(str_stack) + 1;
			if NOT Ival(copy(str_stack, 1, i-1), j, k) then begin
				{$ifdef DEBUG} assert(FALSE,'AKDJ 918'); {$endif}	// impossibile, se la stringa è stata costruita da push_selected()
				exit
			end;
			inc(i_obj);if (i_obj = i_pos) then begin result := j;exit end;
			delete(str_stack, 1, i)
		end
	end;

	function get_stack_max_object(var str_stack : string;bo_delete_from_stack : boolean = FALSE) : obj_index_type;
	// rende l'oggetto con l'indice più alto dello stack specificato; non è l'ultimo oggetto, ma quello con l'indice più elevato
	begin
		result := 0;	// default: no objs found
		var s := str_stack;
		while (s <> '') do begin
			var i_obj : obj_index_type := strToInt(get_first_delimited_delete(s, ' '));
			if (i_obj > result) then result := i_obj
		end;
		if bo_delete_from_stack AND (result <> 0) then str_stack := delete_delimited(str_stack, result, ' ')
	end;

	procedure pop_selected(str_stack : string);
	// ripristina lo stato degli oggetti selezionati come indicato in STR_STACK
	var j, k : integer;	//*
	begin
		obj_select(0,FALSE);	// precauzionale
		while (str_stack <> '') do begin
			var i : smallint := pos(' ',str_stack);if (i = 0) then i := length(str_stack)+1;
			if NOT Ival(copy(str_stack, 1, i-1), j, k) then begin
				{$ifdef DEBUG} assert(FALSE, 'AKJ 918'); {$endif}	// impossibile, se la stringa è stata costruita da push_selected()
				exit
			end;
			obj_select(j, TRUE, TRUE);
			delete(str_stack, 1, i)
		end
	end;

	function set_all_selected(i_azione : integer;wo_parm : word;xobj : objs_type) : boolean;
	{ esegue una determinata azione su tutti gli oggetti specificati;
	  rende TRUE se l'azione ha successo, FALSE altrimenti }
	var str_stack : string;	//*
	begin
		result := FALSE;
		if NOT is_a_compatible_selection(i_azione, wo_parm, xobj) then begin
			MessageBBox(GH, 'La varietà e/o il tipo degli oggetti selezionati non consentono l''operazione richiesta', MBOX_CAPTION);
			exit
		end;

		try
			set_global_modified;

			var j : obj_index_type := 0;
			var i_selected : obj_index_type := push_selected(str_stack, {deselect}TRUE);
			// inizializzazione
			case i_azione of
				SET_SEL_BOTTOM, SET_SEL_RIGHT: j := 0;
				SET_SEL_TOP, SET_SEL_LEFT: j := 29999	// valore altino
			end;

//			for i := 1 to get_num_selected_objects do with get_selected_obj(i) do begin
			for var i : obj_index_type := 1 to i_selected do with xobjs(get_stack_obj(str_stack, i)) do begin
				case i_azione of
					SET_SEL_BOTTOM : j := MAX(j, get_top + get_height);
					SET_SEL_TOP : j := MIN(j, get_top);
					SET_SEL_LEFT : j := MIN(j, get_left);
					SET_SEL_RIGHT : j := MAX(j, get_left + get_width)
				end
			end;

			// esecuzione effettiva
//			for i := 1 to get_num_selected_objects do with get_selected_obj(i) do begin
			for var i : obj_index_type := 1 to i_selected do with xobjs(get_stack_obj(str_stack, i)) do begin
				case i_azione of
					SET_SEL_BOTTOM : set_top(j - get_height);
					SET_SEL_TOP : set_top(j);
					SET_SEL_LEFT : set_left(j);
					SET_SEL_RIGHT : set_left(j - get_width);
					SET_SEL_APPLICA_STYLE : applica_style(xobj, wo_parm)
				end
			end;
			result := TRUE
		finally
			pop_selected(str_stack)
		end
	end;	

	function is_a_compatible_selection(i_azione : integer;wo_parm : word;xobj : objs_type) : boolean;
	{ rende TRUE se è possibile eseguire l'azione specificata sull'insieme di
	  oggetti attualmente selezionati }
	begin
		result := TRUE;
		case i_azione of
			SET_SEL_BOTTOM, SET_SEL_TOP, SET_SEL_LEFT, SET_SEL_RIGHT : {result := TRUE};
			SET_SEL_APPLICA_STYLE : begin
				for var i : obj_index_type := 1 to get_num_selected_objects do
					result := result AND get_selected_obj(i).is_stile_applicabile(xobj, wo_parm);
			end;
			else begin
				{$ifdef DEBUG} assert(FALSE,'AZIONE NON GESTITA'); {$endif}
				result := FALSE
			end
		end
	end;

	procedure load_objects(it : TStrings;tipi : obj_type_set;i_pagina_logica_1B : logical_page_type;
		i_section_1B : section_index_type;bo_load_obj_sezioni_superiori : boolean = TRUE);
	// carica tutti gli oggetti identificati dai parametri
	begin
		it.clear;
		for var i : obj_index_type := 1 to i_objs(i_pagina_logica_1B) do begin
			var x := xobjs(i, i_pagina_logica_1B);
			if (x.ca.i_section_1B > i_section_1B) OR ((x.ca.i_section_1B <> i_section_1B) AND NOT bo_load_obj_sezioni_superiori)
				then continue;
			if (tipi <> []) AND NOT (x.ca.tipo_oggetto in tipi) then continue;
			it.add(lowercase(x.get_name))
		end
	end;

	procedure load_objects(it : TStrings;vars : variabile_set;i_pagina_logica_1B : logical_page_type;i_section_1B : section_index_type;
		bo_load_obj_sezioni_superiori : boolean = TRUE);
	// carica tutti gli oggetti identificati dai parametri
	begin
		it.clear;
		for var i : obj_index_type := 1 to i_objs(i_pagina_logica_1B) do begin
			var x := xobjs(i, i_pagina_logica_1B);
			if (x.ca.i_section_1B > i_section_1B) OR ((x.ca.i_section_1B <> i_section_1B) AND NOT bo_load_obj_sezioni_superiori)
				then continue;
			if (vars <> []) AND NOT (x.get_tipo_variabile in vars) then continue;
			it.add(lowercase(x.get_name))
		end
	end;

	function load_objects(it : TStrings;i_page_ZB : logical_page_type;sezioni_ZB : byteset = [];objs_types : obj_type_set = [];tipi_valore : risultato_set = []) : smallint;
	// rende il numero di oggetti caricati
	begin
		result := 0;
		for var i_ZB := 0 to i_objs_ZB(i_page_ZB) - 1 do begin
			var x : objs_type := xobjs_ZB(i_ZB, i_page_ZB);
			if (sezioni_ZB <> []) AND NOT ((x.ca.i_section_1B - 1) in sezioni_ZB) then continue;
			if (objs_types <> []) AND NOT (x.tipo_oggetto in objs_types) then continue;
			if (tipi_valore <> []) AND NOT (x.ca.tipo_valore in tipi_valore) then continue;
			it.add(x.get_name);inc(result)
		end
	end;

	function objs_type.check_name(handle : hwnd;str_new_name : string) : boolean;
	// rende TRUE se il nome è valido, FALSE altrimenti; verifica la presenza di eventuali doppioni (all'interno della stessa pagina)
	begin
		result := FALSE;
		if (get_name = str_new_name) then begin result := TRUE;exit end;		// nessun cambiamento, tutto ok
		var tipo := ca.tipo_oggetto;
		str_new_name := uppercase(str_new_name);

		if (str_new_name = '') then begin
//			if (tipo = xxTESTO) then begin result := TRUE;exit end;
			if (tipo = LABEL_OBJ) AND (ca.tipo_variabile = TV_STATIC_TEXT) then begin result := TRUE;exit end;
			MessageBBox(handle, 'Specificare un nome per l''oggetto', MBOX_CAPTION, MB_ICONSTOP);
			exit
		end;

//		if (tipo <> xxTESTO) then begin
		if (tipo <> LABEL_OBJ) OR (ca.tipo_variabile <> TV_STATIC_TEXT) then begin
//			if (str_new_name[1] in ['0'..'9']) OR (pos(' ', str_new_name) <> 0) then begin
			if CharInSet(str_new_name[1], ['0'..'9']) OR (pos(' ', str_new_name) <> 0) then begin
				MessageBBox(handle, 'Il nome dell''oggetto non può contenere spazî nè iniziare con un numero', MBOX_CAPTION, MB_ICONSTOP);
				exit
			end;

			for var i : smallint := 1 to length(str_new_name) do begin
//				if (NOT (upcase(str_new_name[i]) in ['A'..'Z','0'..'9','_'])) then begin
				if NOT CharInSet(upcase(str_new_name[i]), ['A'..'Z', '0'..'9', '_']) then begin
					MessageBBox(handle, 'Il nome dell''oggetto può essere composto esclusivamente da lettere, numeri e _', MBOX_CAPTION, MB_ICONSTOP);
					exit
				end
			end;

			if (name2index(str_new_name, [], FALSE, {i_logical_page}0, i_numero_obj) <> 0) then begin		// cerco sulla pagina corrente, escludendo SELF
				MessageBBox(handle,'Il nome dell''oggetto non è univoco.' + ACAPO2 +
					'Esiste già un oggetto con il nome <' + str_new_name + '>.', MBOX_CAPTION, MB_ICONSTOP);
				exit
			end
		end;

		result := TRUE
	end;

{$endif GALATEO_EXE}

function object_is_hidden(show : show_types;i_pagina_fisica : ph_page_type;
	i_sezione_1B : section_index_type = 0;
	i_ph_first_page_section : ph_page_type = 0;i_ph_last_page_section : ph_page_type = 0;
	bo_dont_hide_on_zero_values : boolean = FALSE;ptr_print_section : {cl_print_section}pointer = NIL) : boolean;
{ rende TRUE se l'oggetto è nascosto sulla pagina (fisica) specificata;
  passando I_PAGINA_FISICA = 0 si ottiene un risultato che indica se su almeno una pagina l'oggetto viene stampato;
  BO_DONT_HIDE_ON_ZERO_VALUES indica di NON utilizzare l'indicazione delle pagine INIZIALI e FINALI
  (ovvero: FINALI, perchè le pagine iniziali sono sempre note) per la determinazione dello stato di un oggetto;
  se la pagina finale non è nota, quindi, la procedura tende a indicare che l'oggetto deve essere stampato;
  serve per i casi in cui si sta stampando un oggetto "solo sull'ultima pagina" senza sapere ancora se la pagina in stampa è l'ultima }
begin
{$ifdef CASA}
	var bo_SOR : boolean;	//* Start Of Record
	if (i_pagina_fisica = 0) OR (i_sezione_1B = 0) then begin result := (show = OSW_HIDE);exit end;
//	dec(i_pagina_fisica,get_first_pagina_fisica_of_pagina_logica-1);	// # di page relativo alla sezione corrente
	bo_SOR := (ptr_print_section <> NIL) AND cl_print_section(ptr_print_section).bo_continuazione;	// la continuazione della prima stampa del record si intende come 'prima pagina'
	case show of	// considero solo il caso SHOW, poi eventualmente inverto
		OSW_SHOW, OSW_HIDE: result := FALSE;
//		OSW_SHOW_1,OSW_HIDE_1 : result := (i_pagina_fisica <> 1);
		OSW_SHOW_1, OSW_HIDE_1 : result := (i_pagina_fisica <> get_first_pagina_fisica_of_pagina_logica);
//		OSW_SHOW_LAST, OSW_HIDE_LAST : result := (i_pagina_fisica <> get_numero_pagine_fisiche_of_pagina_logica);
		OSW_SHOW_LAST, OSW_HIDE_LAST : result := (i_pagina_fisica <> get_first_pagina_fisica_of_pagina_logica + get_numero_virtual_pages_of_pagina_logica - 1);
		OSW_SHOW_1REC, OSW_SHOW_SOR : begin
			if (i_sezione_1B = MAIN_SECTION) then result := NOT start_end_main_record_page(i_pagina_fisica - get_first_pagina_fisica_of_pagina_logica + 1, TRUE)
			else result := (i_ph_first_page_section <> 0) AND (i_pagina_fisica <> i_ph_first_page_section);
			if result AND (show = OSW_SHOW_1REC) then result := NOT bo_SOR
		end;
		OSW_HIDE_1REC, OSW_HIDE_SOR : begin
			if (i_sezione_1B = MAIN_SECTION) then result := start_end_main_record_page(i_pagina_fisica - get_first_pagina_fisica_of_pagina_logica + 1, TRUE)
			else result := ((i_ph_first_page_section <> 0) AND (i_pagina_fisica = i_ph_first_page_section));
			if NOT result AND (show = OSW_HIDE_1REC) then result := bo_SOR
		end;
		OSW_SHOW_EOR : begin
			if bo_dont_hide_on_zero_values AND (i_ph_last_page_section = 0) then result := FALSE	// default: mostro anche se non so ancora
			else begin
				if (i_sezione_1B = MAIN_SECTION) then
					result := NOT start_end_main_record_page(i_pagina_fisica - get_first_pagina_fisica_of_pagina_logica + 1, FALSE)
				else result := (i_ph_last_page_section <> 0) AND (i_pagina_fisica <> i_ph_last_page_section)
			end
		end;
		OSW_HIDE_EOR : begin
			if bo_dont_hide_on_zero_values AND (i_ph_last_page_section = 0) then result := FALSE	// default: mostro anche se non so ancora
			else begin
				if (i_sezione_1B = MAIN_SECTION) then
					result := start_end_main_record_page(i_pagina_fisica - get_first_pagina_fisica_of_pagina_logica + 1, FALSE)
				else result := (i_ph_last_page_section <> 0) AND (i_pagina_fisica = i_ph_last_page_section)
			end
		end;
		else begin
			{$ifdef DEBUG} assert(FALSE, 'is_hidden: wrong value'); {$endif}
//			result := FALSE;
			abort
		end
	end;
	if (show in [OSW_HIDE,OSW_HIDE_1, OSW_HIDE_LAST {,OSW_HIDE_SOMR, OSW_HIDE_EOMR}]) then
		result := NOT result
{$else}
	result := (show = OSW_HIDE)		// GALATEO_EXE
{$endif CASA}
end;

function get_next_object(i_obj : obj_index_type;bo_forward,bo_must_be_visible : boolean) : obj_index_type;
// seleziona l'oggetto successivo (o precedente); rende NIL in caso di errore
begin
	if (i_obj = 0) then
		if bo_forward then i_obj := 0 else i_obj := i_objs+1;
	for var i : obj_index_type := 1 to i_objs do begin
		if bo_forward then begin
			inc(i_obj);if (i_obj > i_objs) then i_obj := 1
		end
		else begin
			dec(i_obj);if (i_obj = 0) then i_obj := i_objs
		end;
		if NOT bo_must_be_visible OR NOT xobjs(i_obj).is_hidden(0) then begin
			result := i_obj;exit
		end
	end;
	result := 0
end;

// -----------------------------------------------------------------------------

procedure reset_print_values(i_sezione_1B : section_index_type;i_pagina_logica_1B : logical_page_type = 0);
// pagina logica: -1 per 'TUTTE LE PAGINE LOGICHE', oppure 0 per 'PAGINA LOGICA ATTIVA
// sezione: -1 per 'tutte le sezioni'
begin
	if (i_pagina_logica_1B = 0) then i_pagina_logica_1B := get_pagina_logica_attiva_1B;
	for var i_pl : logical_page_type := 1 to get_ultima_pagina_logica do begin
		if (i_pl <> i_pagina_logica_1B) AND (i_pagina_logica_1B <> -1) then continue;
		// azzero tutti i valori di stampa
		for var i : obj_index_type := 1 to i_objs do begin
			var x := xobjs(i, i_pl);
			if (i_sezione_1B > 0) AND (i_sezione_1B <> x.ca.i_section_1B) then continue;
{			case x.get_tipo_oggetto of		*** fino 2011-05-09
				TESTO, FORMULA : x.aslabel.reset_print_value;
//				VARIABILE, OBJ_BITMAP : ;	// deve essere già stato impostato, a questo punto
			end }
//			if (x.get_tipo_oggetto in [xxTESTO, xxFORMULA, DATAMATRIX]) then x.reset_print_value		// dal 2011-05-09
			if (x.get_tipo_variabile in [TV_STATIC_TEXT, TV_FORMULA]) then x.reset_print_value		// dal 2011-05-19; raccoglie TESTI, FORMULE e DATAMATRIX (che possono essere TESTI oppure FORMULE)
		end
	end
end;

function calcola_values(handle : HWND;bo_printing : boolean;i_section_1B : section_index_type;bo_non_ricalcolare_formule_non_vuote : boolean) : boolean;
{ calcola le formule e assegna i testi fissi;
  il valore delle variabili deve essere già stato assegnato;
  if (I_SECTION != 0) then tratta solo la section specificata, altrimenti le tratta tutte;
  rende TRUE in caso di successo, FALSE altrimenti;
  BO_NON_RICALCOLARE_FORMULE_NON_VUOTE serve per la stampa delle formule: se una formula va su più pagine,
  GALATEO la taglia e ne stampa diverse parti sulle diverse pagine; in questo caso bisogna evitare di ricalcolarla
  ad ogni pagina stampata, per evitare di rigenerare il suo valore complessivo;
  if (BO_PRINTING) then emette messaggi d'errore }
const MBOX_DEBUG_CAPTION = 'calcola_values()';
var
	xobj : objs_type;	//*
	str_temp : string;
begin
//	bo_non_ricalcolare_formule_non_vuote := FALSE;	// parametro temporaneamente non utilizzato perchè crea problemi
	runtime_debug('000 start', MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
	if (i_section_1B = 0) then i_section_1B := 1;
	var sez : cl_sezione := sections_1B(i_section_1B);
	if sez.bo_dont_print_section then begin result := TRUE;exit end;
	var i_logical_page_1B : logical_page_type := sez.i_logical_page_ZB + 1;
	try
		runtime_debug('100', MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
		for var i : obj_index_type := 1 to i_objs do with xobjs(i, i_logical_page_1B) do begin
			if (i_section_1B <> 0) AND (i_section_1B <> ca.i_section_1B) then continue;

{			case get_tipo of	*** così fino 2011-05-19
				TESTO, FORMULA : aslabel.reset_print_value;
//				VARIABILE, OBJ_BITMAP : ;	// deve essere già stato impostato, a questo punto
			end }
			if (get_tipo_variabile in [TV_STATIC_TEXT, TV_FORMULA]) then reset_print_value	// 2011-05-09
		end;
		// ricalcolo il valore di ogni formula (e testo, che può essersi deteriorato nella stampa precedente)
		runtime_debug('200', MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
		for var i : obj_index_type := 1 to i_objs do begin
			xobj := xobjs(i, i_logical_page_1B);
			if (i_section_1B <> 0) AND (i_section_1B <> xobj.ca.i_section_1B) then continue;	// solo la sezione interessata
			if (xobj.tipo_variabile in [TV_STATIC_TEXT, TV_FORMULA]) then xobj.calcola_print_value
		end;

		// carico il contenuto delle bitmaps dinamiche
		runtime_debug('300 before dyn bmps', MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
		for var i : obj_index_type := 1 to i_objs do begin
			xobj := xobjs(i, i_logical_page_1B);
			if (xobj.ca.i_section_1B <> i_section_1B) OR (xobj.ca.tipo_oggetto <> OBJ_BITMAP) then continue;
			var bmp : cl_bmp := xobj.asbitmap;
			if (bmp.str_immagine_dinamica = '') then continue;		// immagine dynamica non specificata
			var tipo_res : risultato_type := VAL_TESTO;
			if NOT translate_formula(bmp.str_immagine_dinamica, str_temp, FALSE, tipo_res, xobj) then begin
				MessageBBox(GH, str_temp, 'Oggetto <' + xobj.get_name + '>', MB_ICONSTOP);
				abort
			end;
			if (str_temp = '') then begin		// immagine assegnata, ma valore calcolato BLANK
				bmp.Picture := NIL		// 2016-01-27 (altrimenti - se blank - ripete l'ultima immagine caricata)
			end
			else begin		// immagine assegnata, vado a caricarla
				runtime_debug('loop obj-' + zeri(i, 4) + ' (' + xobj.get_name + ') [' + bmp.str_immagine_dinamica + '] >>> [' + str_temp + ']',
					MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
				// sostituisco eventuali variabili di ambiente
				if assigned(xxcallback_replace_variabili_ambiente) then
					str_temp := xxcallback_replace_variabili_ambiente(get_active_job, str_temp, {ptr:unused}NIL);
				if FileExists(str_temp) then begin
					if NOT bmp.load_file(str_temp, TRUE, bmp.bo_autosize_immagine_dinamica, bmp.bo_cannot_exceed_original_size) then begin
						MessageBBox(GH, 'Impossibile caricare l''immagine <' + str_temp + '>', MBOX_CAPTION, MB_ICONSTOP);
						abort
					end
				end
				else begin
					if bmp.bo_image_dinamica_must_exist then begin
						MessageBBox(GH, 'L''immagine <' + str_temp + '> non esiste', MBOX_CAPTION, MB_ICONSTOP);
						abort
					end
					else begin
						bmp.picture.assign(bmp.original_picture);
						if bmp.bo_image_dinamica_should_exist then add_delimited(bmp.str_immagini_inesistenti, str_temp, ACAPO)
					end
				end
			end
		end;

		runtime_debug('999', MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
		result := TRUE
	except
		runtime_debug('except' + ACAPO + get_last_error_msg, MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
		result := FALSE
	end
end;

{$ifdef CASA}

	procedure IO_dynamic_images(bo_push : boolean);
	// esegue il salvataggio/il ripristino delle immagini statiche dopo una stampa in cui possono essere state utilizzate le immagini dinamiche
	begin
		try
			{ se legata al valore di specifici oggetti (esempio: parametro runtime che decide se la pagina deve essere stampata oppure no)
			  la condizione di stampa delle specifiche pagine tipicamente potrebbe non essere ancora stata calcolata
			  (con specifico riferimento agli oggetti NUMERICI, quelli di tipo TESTO sono meno sensibili);
			  dato che (al momento) non esiste soluzione, escludo il messaggio di errore;
			  qualora ci siano significativi errori nel trattmaento delle immagini, bisognerà trovare una soluzione }
			bo_exclude_message_not_computed_object := TRUE;

			for var i_page : logical_page_type := 1 to get_ultima_pagina_logica do begin
				if get_logical_page_1B(i_page).bo_dont_print then continue;		// 2016-01-27
				for var i : obj_index_type := 1 to i_objs(i_page) do begin
					var x : objs_type := xobjs(i, i_page);
					if (x.ca.tipo_oggetto = OBJ_BITMAP) AND (x.asbitmap.str_immagine_dinamica <> '') then begin
						var bmp : cl_bmp := x.asbitmap;
						if bo_push then begin
							{$ifdef DEBUG} assert(bmp.original_picture = NIL, 'AJGH 9023'); {$endif}
							bmp.original_picture := TPicture.create;
							bmp.original_picture.assign(bmp.Picture)
						end
						else begin
							{$ifdef DEBUG} assert(bmp.original_picture <> NIL, 'AJGH 9024'); {$endif}
							bmp.Picture.assign(bmp.original_picture);
							bmp.original_picture.free;bmp.original_picture := NIL
						end
					end
				end
			end
		finally
			bo_exclude_message_not_computed_object := FALSE
		end
	end;

	function dynamic_images_error_messages : boolean;
	// emette eventuali errori di bitmaps dinamiche; rende TRUE se OK, FALSE se l'esecuzione del essere interrotta
	type
		array_type = record
			str_filename : string;
			i_numero : smallint;
		end;
	var a : array of array_type;

		procedure add(s : string);
		begin
			var i : smallint := 0;s := lowercase(s);
			while (i < length(a)) AND (s > a[i].str_filename) do inc(i);
			if (i < length(a)) AND (a[i].str_filename = s) then inc(a[i].i_numero)
			else begin
				var i_len : smallint := length(a);
				setlength(a, i_len+1);
				for var j : smallint := i_len downto i+1 do a[j] := a[j-1];
				a[i].str_filename := s;a[i].i_numero := 1
			end
		end;

	begin
		for var i_page : logical_page_type := 1 to get_ultima_pagina_logica do begin
			for var i_obj : obj_index_type := 1 to i_objs(i_page) do begin
				var xobj : objs_type := xobjs(i_obj,i_page);
				if (xobj.ca.tipo_oggetto <> OBJ_BITMAP) then continue;
				var bmp : cl_bmp := xobj.asbitmap;

				var s := bmp.str_immagini_inesistenti;
				if (s = '') then continue;

				while (s <> '') do begin
					var str_temp := get_first_delimited(s,ACAPO);
					s := delete_delimited(s,str_temp,FALSE,ACAPO);
					add(str_temp)
				end;

				for var i : smallint := 0 to length(a)-1 do add_delimited(s,'[' + a[i].i_numero.ToString + '] ' + a[i].str_filename, ACAPO);
				a := NIL;

				MessageBBox(GH, 'Errore durante il caricamento delle seguenti immagini' + ACAPO2 + s, MBOX_CAPTION, MB_ICONSTOP)
			end
		end;
		result := TRUE
	end;

{$endif CASA}

function objs_type.get_SQL_expression : string; begin result := ca.str_SQL_expression end;
procedure objs_type.set_SQL_expression(s : string); begin ca.str_SQL_expression := s end;
//function objs_type.get_esempio_value : string; begin result := ca.xstr_esempio_value end;
//procedure objs_type.set_esempio_value(s : string); begin ca.xstr_esempio_value := s end;

(*function objs_type.get_tipo_valore : risultato_type;
begin
{	if (lab <> NIL) then result := lab.tipo_valore else
	if (dm <> NIL) then result := VAL_TESTO
	else result := VAL_BOH }		// oggetti grafici ed altro
	result := ca.tipo_valore
end;*)

procedure objs_type.clear_print_value;
begin
	case ca.tipo_oggetto of
		LABEL_OBJ : if NOT (ca.tipo_variabile in TV_COSTANTI) then lab.clear_print_value;
		DATAMATRIX_OBJ : dm.clear_print_value
		else
	end
{	if (lab <> NIL) then begin
		if NOT (lab.tipovar in TV_COSTANTI) then lab.clear_print_value
	end else
	if (dm <> NIL) then dm.clear_print_value
//	else }
end;

procedure objs_type.reset_print_value;
begin
	case ca.tipo_oggetto of
		LABEL_OBJ : lab.reset_print_value;
		DATAMATRIX_OBJ : dm.reset_print_value
		else
	end
{	if (lab <> NIL) then lab.reset_print_value else
	if (dm <> NIL) then dm.reset_print_value
//	else }
end;

function objs_type.calcola_print_value : string;
// forza il calcolo della formula, se già non era avvenuto
begin
	case ca.tipo_oggetto of
		LABEL_OBJ : result := lab.str_print;
		DATAMATRIX_OBJ : result := ca.get_print_value
		else
	end
end;

initialization
	galateo_initialization_debug('objects')
finalization
	galateo_finalization_debug('objects');
	{$ifdef DEBUG} CCI(i_objs_type, 'objs_type', 'objects.pas') {$endif}
end.
