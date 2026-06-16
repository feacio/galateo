unit Sezione;	//*

{$define VARS}					// 2006-08-04 per velocificare l'esecuzione; risultati scarsini, ma comunque ...

{$I defines}
{$ifdef PROVA_FAST} {$R-,S-} {$undef DEBUG} {$endif}

interface

uses Db, VCL.Forms, SysUtils, Windows, Messages, VCL.ExtCtrls, Classes, VCL.Graphics, VCL.Controls, Math,
	Fcommons, FDB, validate,
	Gdich, expint_base, {$ifdef GALATEO_EXE} panel, fields, objects, {$else} print_types, {$endif} colori_proc;

{$ifdef GALATEO_EXE}
procedure add_section;
//procedure delete_section_1B(i_section_1B : section_index_type);
procedure delete_section_ZB(i_section_ZB : section_index_type);
//function is_antenato_1B(i_section_1B, i_candidato_antenato_1B : section_index_type) : boolean;
function is_antenato_ZB(i_section_ZB, i_candidato_antenato_ZB : section_index_type) : boolean;
procedure write_section_ZB(var f : system.Text;i_section_ZB : section_index_type);
{$endif}
procedure open_all_queries(bo_open_ancestors, bo_accept_blank, bo_stampa_vera : boolean);
procedure read_section_ZB(var f : system.Text;i_logical_page_ZB : logical_page_type;i_section_ZB : section_index_type;wo_versione : word);
procedure set_main_section_values;

{$ifdef CASA} procedure exec_validazione_anticipata_proc(context : validazione_context_type); {$endif}

type
	cl_sezione = class
		public
			i_logical_page_ZB : logical_page_type;
			i_section_ZB, xi_section_1B : section_index_type;
			i_father_ZB : section_index_type;					// sezione padre in cui è inclusa la presente sezione; -1 per la MAIN_SECTION (che non ha padre)
			r_y0_rel_cm : misura_real_type;						// posizione del margine superiore della sezione relativa al padre
			r_y_gruppo_cm : misura_real_type; 					// dimensione verticale di ogni istanza sezione
			r_y_sezione_cm : misura_real_type;					// dimensione totale della sezione
			r_minimum_required_space_cm : misura_real_type;	// perchè la sezione sia stampata è NECESSARIO avere almeno questo spazio libero; 0 per saltare il controllo
			bo_autosize : boolean;				// solo per la sottosezioni 1 (principale) e 2 (subsezione)
			str_SQL : string;
			bo_read_from_file, bo_save_to_file : boolean;
			str_SQL_filename : string;
			tsql_command : TStrings;
			tsql_scripts : TStrings;
			qry : TFQuery;
			str_nome : string;
			font_default : TFont;
			bo_dont_break_fields : boolean;			// non breakka la sezione su due pagine
			bo_dont_break_subsections : boolean;	// non breakka le subsections della sezione dalla sezione
			bo_reprint_broken_sections : boolean;	// ristampa la sezione sulla pagina successiva se è impossibile stampare tutte le subsections sulla pagina attuale
			bo_del_blanks : boolean;					// elimina le righe con tutti valori blanks
			bo_fill_tutto : boolean;					// TRUE se la sezione occupa sempre tutto lo spazio
			bo_senza_dati : boolean;					//	se TRUE stampa il prospetto senza nessun dato
			bo_stampa_anche_se_vuota : boolean;		// non stampa la sezione se mancano record, altrimenti stampa 1 volta in bianco
			bo_dont_print_section : boolean;			// non stampa la sezione
			bo_print_only_if_subsection_has_records : boolean;
			bo_conta_records : boolean;
				{ TRUE se i records della sezione vengono considerati l'unità di misura principale del report;
				  il concetto ha valenza esclusivamente estetica e di rapporto umano con l'utente che aspetta dietro al video }
			str_record_descr_runtime : string{[LEN_RECORD_DESCR_RUNTIME]};
			bo_draw_line_bottom : boolean;	// disegna una riga sul fondo della sezione
			bo_draw_rect : boolean;				// disegna un rettangolo intorno alla sezione
			bo_draw_last_line : boolean;		// disegna la linea sotto l'ultima sezione (normalmente: non dovrebbe)
			str_obj_line_bottom_pos_and_width : string;	// oggetto da cui mutuare posizione e larghezza
			bo_double_thickness : boolean;	// raddoppia lo spessore di STR_OBJ_LINE_BOTTOM_POS_AND_WIDTH
			str_SQL_start_record : string;	// istruzione SQL eseguita all'inizio di ogni record
			colonne_colorate : colonna_colorata_array;
{$ifdef GALATEO_EXE}
		public
			w_fields: Tw_fields;
			procedure open_database_fields;
{$endif GALATEO_EXE}
		public
			str_export_filename_DBF : string;
			bo_exportable_DBF : boolean;				// TRUE se la query è exportabile in formato DBF
			str_SQL_export_DBF_store : string;		// comando di esportazione SQL (alternativo alla query principale)
			str_SQL_export_DBF_exec : string;		// da usare per l'esecuzione del comando (contiene str_SQL_export_store tradotto)

			function exportabile_integrale(i_profilo : expint_index_type;bo_runtime : boolean) : boolean;
			function get_expint_section(i_profilo : expint_index_type = -1) : cl_expint_section;
{$ifdef CASA}
		private
//			bo_XML_allowed_phisical : boolean;
//			function get_XML_allowed : boolean;
			function XML_attivo(i_profilo : smallint) : boolean;
			function tratta_XML(sv : cl_print_section) : boolean;
		public
//			str_condizione_export_XML : string;		{$ifndef DEBUG} *** {$endif}
//			str_struttura_XML : string;					// testo XML da exportare
			str_XML_elaborato : array of string;		// testo XML elaborato, pronto per essere acquisito nella sezione di livello superiore (if any)
//			property bo_XML_allowed : boolean read get_XML_allowed write bo_XML_allowed_phisical;					// TRUE se la sezione viene exportata su XML
			function XML_commento(bo_start : boolean) : string;
{$endif CASA}
		public
			str_field_codice_record : string;		// nome del campo codice per il record; serve per l'indicizzazione
			str_section_group_field : string;		// usato per la funzione SECTION_GROUP_CHANGED
			str_SQL_PK_debug_field : string;			// campo usato per 'marcare' il record in fase di debug
{$ifdef CASA}
			printing_values : cl_print_section;		// puntatore ai valori che stanno essendo stampati
{$endif CASA}
{$ifdef GALATEO_EXE}
			function check_margini_sezione_with_father : boolean;
			function check_margini_sezione_with_sons : boolean;
			function is_symbol_ok(str_obj,str : string;bo_msg : boolean;handle : HWND) : boolean;
			procedure set_panel_values;
			function validate_formula_editing(handle : hwnd;str_formula : string;str_descrizione : string;ox : objs_type;tipo : risultato_type;bo_allow_blank : boolean) : boolean;
			procedure write(var f : system.Text);
{$endif GALATEO_EXE}
			constructor create_ZB(i_section_ZB, i_father_ZB : section_index_type;i_logical_page_ZB : logical_page_type);
			destructor free;
			function get_first_son_1B : section_index_type;
			function get_first_son_ZB : section_index_type;
			function get_name(bo_specifica_pagina_logica : boolean = FALSE) : string;
{$ifdef CASA}
			function impagina(var psv : cl_print_section;pp : cl_print_page;
				r_y0_cm,r_max_height_cm : misura_real_type;var r_y_used_cm : misura_real_type;vcanvas,pcanvas : TCanvas;
				bo_dont_break, bo_stampa_comunque, bo_print_only_subs : boolean;
				var i_broken_section : section_index_type;var i_broken_field_section : section_index_type;
				bo_export : boolean = FALSE) : boolean;
			procedure tratta_index;
			function stampa_obj(bo_video,bo_ricalcola_delta : boolean;vcanvas,pcanvas : TCanvas;
				i_print_obj : obj_index_type;i_x0_pixel, i_y0_pixel : int_pixel_type;r_max_height_cm : misura_real_type;
				bo_can_break_object : boolean;var i_max_y_pixel : int_pixel_type;
				sv : cl_print_section;bo_export_integrale : boolean) : boolean;
			procedure prepare2print;
			procedure print_section(sec : cl_print_section;bo_video : boolean;vcanvas,pcanvas : TCanvas;r_x0_cm,r_y0_cm : misura_real_type;
				i_pagina_fisica : ph_page_type;bo_exportazione_integrale : boolean;target : report_target_type);
			function load_SQL_values(var sections_values : cl_print_section;valid : cl_validation) : integer;
{$endif CASA}
			procedure query_open(bo_open_ancestors, bo_accept_blank, bo_stampa_vera, bo_prepara_only : boolean);
			procedure query_close;
			function is_son_ZB(i_son_ZB : section_index_type) : boolean;
			procedure read(var f : system.Text;wo_versione : word);
			function interpreta_string(var s : string;bo_stampa_vera, bo_check_errors : boolean;str_context_caption : string = '') : boolean;
			function SQL_blank : boolean;
		private
{$ifdef CASA}
			print_objs : cl_section_print_objects;
			function draw_graphic_object(tipo : obj_type;sec : cl_print_section;
				bo_video : boolean;vcanvas,pcanvas : TCanvas;r : TRect;i_x0_pixel,i_y0_pixel : int_pixel_type) : boolean;
			procedure validate_objects(valid : cl_validation;sv : cl_print_section;bo_validate_pre_SQL : boolean;limita_context : validazione_context_set = []);
{$endif CASA}
			procedure set_father_ZB(i_father_ZB : section_index_type);
			procedure set_default_name;
			procedure interpreta_tstring(tstr : TStrings;bo_stampa_vera : boolean);	// traduce una query in SQL
			procedure interpreta_word(str_word : string;bo_stampa_vera,bo_check_errors : boolean;var str_result : string;str_context_caption : string = ''); // traduce una parola (parametro, macro interna)
{$ifdef VARS}
		private
			bo_vars_built : boolean;
			vars : array[variabile_type] of array of obj_index_type;	// vettore che contiene le variabili
			{$ifdef CASA} procedure build_vars; {$endif}
			procedure free_vars;
{$endif}
		private
			function get_SQL_save_executive_filename : string;
			function clear_SQL_save_command_text(str_SQL : string) : string;
{$ifdef GALATEO_EXE}
			function get_SQL_save_command_text(str_SQL : string) : string;
{$endif GALATEO_EXE}
	end;

{$ifdef CASA} var i_printing_section_ZB : section_index_type; {$endif}		// -1 per intendere NESSUNA

implementation

uses Fassert, FErrMsg, Fdebug, FXstrings, Fstrings, FMessage, FSystem_base, FSystem, FSQLsoft, Fdata, FDatah, Ftime, FProcs, FFile,
	sp_galateo, galateo_debug, proc, rects,
	{$ifdef CASA} objects, working, {$else} galateo_main, {$endif}
	Gun, misure, labels, datamatrix_unit, pages, expint_exec, functions;

{$ifdef CASA} var cqry : TFQuery;	{$endif}		// common query
{$ifdef DEBUG} var i_sezione : integer; {$endif}

// --------------- CL_SEZIONE --------------------------------------------------

constructor cl_sezione.create_ZB(i_section_ZB, i_father_ZB : section_index_type;i_logical_page_ZB : logical_page_type);
begin
	{$ifdef DEBUG} inc(i_sezione); {$endif}
	self.i_father_ZB := i_father_ZB;
	self.xi_section_1B := i_section_ZB + 1;
	self.i_section_ZB := i_section_ZB;
	self.i_logical_page_ZB := i_logical_page_ZB;
	set_default_name;	// assegna il nome default alla sezione
	qry := TFQuery.create(NIL);
//	qry.ResourceOptions.MacroExpand := FALSE;
	qry.ResourceOptions.MacroExpand := FALSE;
//	qry.DatabaseName := global.get_databasename;
	qry.DatabaseName := REPORT_DATABASENAME;
	tsql_command := TStringlist.create;
	tsql_scripts := TStringlist.create;
	str_SQL := '';str_SQL_filename := '';
	bo_read_from_file := FALSE;bo_save_to_file := FALSE;
{$ifdef CASA}
	print_objs := cl_section_print_objects.create(i_logical_page_ZB + 1, i_section_ZB + 1);
	bo_dont_break_fields := TRUE;bo_dont_break_subsections := TRUE;
	bo_reprint_broken_sections := (i_section_ZB = MAIN_SECTION_ZB);
{$endif}
//	bo_skip_on_continuazione := TRUE;	// default
//	bo_expint_headers_colonne := TRUE;  // default
//	bo_print_only_if_subsection_has_records := FALSE;
//	bo_del_blanks := FALSE;
	bo_fill_tutto := TRUE;bo_exportable_DBF := TRUE;
//	r_y0_rel_cm := 0;r_y_gruppo_cm := 0;
	bo_autosize := (i_section_ZB in [MAIN_SECTION_ZB, MAIN_SECTION_ZB + 1]);
	if (i_section_ZB = MAIN_SECTION_ZB) then r_y_sezione_cm := DEFAULT_PAGE_HEIGHT_CM;
//	if (i_section_1B <> MAIN_SECTION) AND (i_father_1B <> 0) then set_father_1B(i_father_1B);
	if (i_section_ZB <> MAIN_SECTION_ZB) AND (i_father_ZB <> -1) then set_father_ZB(i_father_ZB);
	r_minimum_required_space_cm := 0;
	bo_stampa_anche_se_vuota := (i_section_ZB <> MAIN_SECTION_ZB);
//	bo_senza_dati := FALSE;
//	printing_values := NIL;
//	{$ifdef GALATEO_EXE} w_fields := NIL; {$endif}
	{$ifdef GALATEO_EXE} set_panel_values; {$endif}
	font_default := TFont.create
end;

destructor cl_sezione.free;
begin
	{$ifdef DEBUG} dec(i_sezione); {$endif}
	free_query(qry);
	{$ifdef CASA} print_objs.free; {$endif}
	tsql_command.free;tsql_scripts.free;
	font_default.free;
	for var i : smallint := 0 to high(colonne_colorate) do colonne_colorate[i].free;colonne_colorate := NIL;
	{$ifdef VARS} free_vars; {$endif}
	{$ifdef GALATEO_EXE} if (w_fields <> NIL) then w_fields.close {$endif}
end;

{$ifdef GALATEO_EXE}
	function cl_sezione.check_margini_sezione_with_father : boolean;
	{ verifica che i margini della sezione siano compatibili con i margini della sezione padre;
	  rende TRUE se tutto ok, FALSE se ci sono problemi }
	begin
		if (i_section_ZB = MAIN_SECTION_ZB) then begin result := TRUE;exit end;
		result := FALSE;
//		if (r_y0_rel_cm + r_y_sezione_cm > sections_1B(i_father_1B).r_y_gruppo_cm) then exit;
		if (r_y0_rel_cm + r_y_sezione_cm > sections_ZB(i_father_ZB).r_y_gruppo_cm) then exit;
		if (i_section_ZB - 1 = MAIN_SECTION_ZB) then
			if (r_minimum_required_space_cm > r_y_sezione_cm) then exit
			else
		else begin
			// calcolo la distanza tra il bordo sup della sezione corrente e il borso sup della sezione 2 (sub-section di MAIN_SECTION) e
			var r : misura_real_type := 0;
//			for var i : section_index_type := MAIN_SECTION + 2 to i_section_1B do r := r + sections_1B(i).r_y0_rel_cm;
			for var i_ZB : section_index_type := MAIN_SECTION + 1 to i_section_ZB do r := r + sections_ZB(i_ZB).r_y0_rel_cm;
			// confronto con la distanza tra il bordo superiore della sezione corrente e il fondo della sezione 2 (sub-section di MAIN_SECTION)
//			if (r_minimum_required_space_cm > sections_1B(MAIN_SECTION + 1).r_y_sezione_cm - r) then exit
			if (r_minimum_required_space_cm > sections_ZB(MAIN_SECTION_ZB + 1).r_y_sezione_cm - r) then exit
		end;
		result := TRUE
	end;

	function cl_sezione.check_margini_sezione_with_sons : boolean;
	{ verifica che i margini della sezione siano compatibili con i margini di tutte le
	  sezioni figlie; rende TRUE se tutto ok, FALSE se ci sono problemi }
	begin
		result := FALSE;
		for var i : section_index_type := 0 to get_num_sections-1 do if is_son_ZB(i) then
			if (sections_ZB(i).r_y0_rel_cm + sections_ZB(i).r_y_sezione_cm > r_y_gruppo_cm) then exit;
		result := TRUE
	end;

	function cl_sezione.is_symbol_ok(str_obj,str : string;bo_msg : boolean;handle : HWND) : boolean;
	{ rende TRUE se il simbolo può essere come nome per un oggetto di qualunque tipo;
	  è FALSE se il simbolo è una keyword, o è già utilizzato, o non è utilizzabile;
	  if (bo_msg) then emette un opportuno messaggio d'avvertimento;
	  STR_OBJ è il nome dell'oggetto in esame; STR è il contenuto dell'oggetto }
	begin
		str_obj := str_obj + ': ';
		is_symbol_ok := FALSE;
		if (str = '') then begin
			if bo_msg then MessageBBox(handle, str_obj + 'specifica un contenuto', MBOX_CAPTION);
			exit
		end;
//		if (pos(' ',str) <> 0) OR (str[1] in ['0'..'9']) then begin
		if (pos(' ',str) <> 0) OR CharInSet(str[1], ['0'..'9']) then begin
			MessageBBox(handle, str_obj + 'non può contenere spazî nè iniziare con un numero', MBOX_CAPTION);
			abort
		end;
		is_symbol_ok := TRUE
	end;
{$endif}

function cl_sezione.get_first_son_1B : section_index_type;
// rende l'indice del primo figlio, oppure 0 se la sezione non ha figli
begin
	result := get_first_son_ZB + 1
end;

function cl_sezione.get_first_son_ZB : section_index_type;
// rende l'indice ZB del primo figlio, oppure -1 se la sezione non ha figli
begin
	for var i_ZB : section_index_type := 0 to get_num_sections - 1 do if is_son_ZB(i_ZB) then begin result := i_ZB;exit end;
	result := -1
end;

{$ifdef CASA}

(*function cl_sezione.draw_graphic_object(tipo : obj_type;sec : cl_print_section;
	bo_video : boolean;vcanvas,pcanvas : TCanvas;i_x0_pixel, i_y0_pixel : int_pixel_type) : boolean;
// disegna un oggetto grafico nella sezione; rende TRUE se l'ha disegnato, FALSE altrimenti
begin
	result := FALSE;
	var obj_modello : objs_type := name2obj(str_obj_line_bottom_pos_and_width, FALSE);
	if (obj_modello = NIL) then begin
{$ifdef GALATEO_EXE}
		MessageBBox(0, 'E'' stato richiesto di tracciare una linea sul fondo della sezione, ' +
			'ma non è possibile reperire l''oggetto di riferimento per posizione e dimensione',
			'Sezione ' + get_section_name, MB_ICONSTOP);
{$endif}
		exit
	end;
	var obj_draw : objs_type := NIL;
	try
		obj_draw := objs_type.create(NIL, i_logical_page_1B - 1, i_section_1B, tipo, 0, TRUE);
		{$ifdef DEBUG} obj_draw.set_name('sezione-' + zeri(i_section_1B - 1, 2)); {$endif}
		var graph_draw : cl_rect := obj_draw.asgraph;
		var graph_modello : cl_rect := obj_modello.asgraph;

		graph_draw.left := obj_modello.get_left;
		graph_draw.i_actual_width := obj_modello.get_width;
		if NOT bo_video then graph_draw.i_actual_width := cm2pixel_print_x(video2cm_x(graph_draw.i_actual_width));
		case tipo of
			OBJ_LINE : begin
				graph_draw.Top := cm2pixel_video_y(sec.r_height_cm / tm.r_fattore_zoom){ - 1};	// -1 altrimenti la colonna colorata della prossima sezione copre la riga
				graph_draw.i_actual_height := 0
			end;
			OBJ_RECT : begin
				graph_draw.Top := 0;
				var flx : double := sec.r_height_cm / tm.r_fattore_zoom;
				if bo_video then graph_draw.i_actual_height := cm2pixel_video_y(flx) else graph_draw.i_actual_height := cm2pixel_print_y(flx)
			end;
			else begin	// should not happen
				{$ifdef DEBUG} assert(FALSE,'WAJK 2931'); {$endif}
				abort
			end
		end;

		graph_draw.lo_colore_bordo := graph_modello.lo_colore_bordo;		// dal 2012-11-30
		graph_draw.lo_colore_fondo := graph_modello.lo_colore_fondo;		// dal 2012-11-30
		if (obj_modello.ca.tipo_oggetto in CORNICI_OBJS) then graph_draw.i_thickness := graph_modello.i_thickness;		// altrimenti per default THICKNESS = 1
		if bo_double_thickness then graph_draw.i_thickness := (graph_draw.i_thickness{+1}) * 2;

		var i1 : int_pixel_type := 0;var i2 : int_pixel_type := 0;var i3 : int_pixel_type := 0;
		if NOT obj_draw.print(vcanvas, pcanvas, i_x0_pixel, i_y0_pixel, bo_video, NIL, i1, i3, i2, 0, FALSE, 0, 0) then abort;

		result := TRUE
	except
	end;
	if (obj_draw <> NIL) then obj_draw.free
end; *)

function cl_sezione.draw_graphic_object(tipo : obj_type;sec : cl_print_section;bo_video : boolean;vcanvas,pcanvas : TCanvas;
	r : TRect;i_x0_pixel, i_y0_pixel : int_pixel_type) : boolean;
// disegna un oggetto grafico nella sezione; rende TRUE se l'ha disegnato, FALSE altrimenti
var canvas : TCanvas;
begin
	result := FALSE;
	var obj_modello : objs_type := name2obj(str_obj_line_bottom_pos_and_width, FALSE);
	if (obj_modello = NIL) then begin
{$ifdef GALATEO_EXE}
		MessageBBox(0, 'E'' stato richiesto di tracciare una linea sul fondo della sezione, ' +
			'ma non è possibile reperire l''oggetto di riferimento per posizione e dimensione',
			'Sezione ' + get_section_name, MB_ICONSTOP);
{$endif}
		exit
	end;

	if bo_video then canvas := vcanvas else canvas := pcanvas;
	var previous_pen : TPen := TPen.create;previous_pen.assign(canvas.pen);
	var i_pen_width := 1;
	if (obj_modello.ca.tipo_oggetto in CORNICI_OBJS) then i_pen_width := obj_modello.asgraph.i_thickness * ifi(bo_double_thickness, 2, 1);
	canvas.Pen.Width := i_pen_width;
	canvas.Pen.Color := obj_modello.asgraph.lo_colore_bordo;
	inc(r.Left, i_x0_pixel);inc(r.Right, i_x0_pixel);

	// solo linea esterna, non coloro il background; se si vuole colorare il background, ci sono le COLONNE COLORATE
	canvas.MoveTo(r.Left, r.Bottom);
	case tipo of
		OBJ_LINE : canvas.Lineto(r.Right, R.Bottom);
		OBJ_RECT : begin canvas.Lineto(r.Right, R.Bottom);canvas.Lineto(R.Right, R.Top);canvas.Lineto(R.Left, R.Top);canvas.Lineto(r.Left, R.Bottom) end
	end;

	canvas.Pen.assign(previous_pen)
end;

procedure cl_sezione.print_section(sec : cl_print_section;bo_video : boolean;vcanvas,pcanvas : TCanvas;r_x0_cm,r_y0_cm : misura_real_type;
	i_pagina_fisica : ph_page_type;bo_exportazione_integrale : boolean;target : report_target_type);
var i_x0_pixel, i_y0_pixel, i_max_y_pixel : int_pixel_type;	//*
begin
	// TRUE se sto eseguendo una exportazione XML -- in futuro potrebbe non risultare vero, se si aggiungessero altre modalità di exportazione
	var bo_XML := (target = RTA_EXPORT) AND NOT bo_exportazione_integrale;

	if sec.bo_continuazione AND (target = RTA_EXPORT) then begin
		if bo_exportazione_integrale then begin
			if get_expint_section.bo_skip_on_continuazione then exit	// stampo solo la prima istanza di ogni sezione
		end
		else exit		// XML: stampo solo la prima istanza di ogni sezione
	end;

	var i_bak_printing_section : section_index_type := i_printing_section_ZB;
	i_printing_section_ZB := i_section_ZB;

	if bo_video then begin
		{ " / TM.R_FATTORE_ZOOM": nella stampa a video il fattore ZOOM viene applicato già in fase di stampa, qui devo 'dedurlo'
		  nella stampa a stampa il fattore ZOOM non esiste, e quindi il problema non si pone;
		  non ho capito bene perchè sull'asse Y ciò non sia necessario, ma non mi formalizzo }
		i_x0_pixel := cm2pixel_video_x(r_x0_cm / tm.r_fattore_zoom);
		i_y0_pixel := cm2pixel_video_y(sec.r_y0_cm + r_y0_cm)
	end
	else begin
		i_x0_pixel := cm2pixel_print_x(r_x0_cm);
		i_y0_pixel := cm2pixel_print_y(sec.r_y0_cm + r_y0_cm)
	end;

	// genero il rettangolo che conterrà la sezione -- RuntimeRECT
	var rrect : TRect := Rect(0, i_y0_pixel, 0, 0);

	// assegno l'altezza della sezione
	var flx : double := sec.r_height_cm / tm.r_fattore_zoom;
	if bo_video then rrect.Height := cm2pixel_video_y(flx) else rrect.Height := cm2pixel_print_y(flx);

	// se esiste un oggetto che serve da modello per la funzione, assegno anche LEFT and RIGHT
	var objm : objs_type := NIL;	// oggetto modello
	if (str_obj_line_bottom_pos_and_width <> '') then objm := name2obj(str_obj_line_bottom_pos_and_width, FALSE);	// oggetto modello
	if (objm = NIL) then begin		// nessun modello, la sezione occupa tutta la larghezza della pagina
		rrect.Left := 0;
//		flx := get_PHpage_size_X_cm_1B(sec.i_logical_page_ZB + 1);
		flx := get_PHpage_size_X_cm_ZB(sec.i_logical_page_ZB);
		if bo_video then rrect.Right := cm2pixel_video_x(flx) else rrect.Right := cm2pixel_print_x(flx)
	end
	else begin
		// per come è costruito (MALE!) l'oggetto TRect, meglio utilizzare LEFT, RIGHT, TOP, BOTTOM anzichè WIDTH e HEIGHT
		rrect.Left := objm.get_left;rrect.Right := rrect.Left + objm.get_width;
//		rrect.Width := objm.asgraph.i_actual_width;
		if NOT bo_video then begin
			rrect.Left := tm.video2print_pixel_x(rrect.Left);
			rrect.Right := tm.video2print_pixel_x(rrect.Right)
		end
	end;

	sec.runtime_rect := rrect;

	printing_values := sec;		// spostato qui il 2008-07-11
	sec.set_section_fields_values(i_section_ZB + 1, PS_WRITE, {left_values}FALSE, {only_pos_size}FALSE, {forza_calcolo_formule}FALSE);
//	printing_values := sec;		// era qui fino al 2008-07-11
	if NOT bo_XML then begin
		var i_y1_pixel : int_pixel_type := 0;
		for var i_cc : smallint := 0 to high(colonne_colorate) do begin
			if (i_y1_pixel = 0) then begin
				if bo_video then i_y1_pixel := cm2pixel_video_y(sec.r_height_cm) else i_y1_pixel := cm2pixel_print_y(sec.r_height_cm);
				inc(i_y1_pixel, i_y0_pixel)
			end;
			if NOT bo_exportazione_integrale then		// 2023-02-20 altrimenti causa errore runtime; non so se è una buona soluzione
				colonne_colorate[i_cc].draw(sec, bo_video, i_x0_pixel, printing_values.cc_values[i_cc], vcanvas, pcanvas)
		end;

		{ per fare in modo che gli oggetti di testo restino SOPRA e le cornici e le immagini vadano SOTTO, la stampa avviene in due turni,
		  prima gli oggetti grafici, poi i testi }
		for var bo_graphic_objects := TRUE downto FALSE do begin
			for var i : obj_index_type := 1 to print_objs.i_objs do begin
				if ww_stopped then abort;
				var i_obj := print_objs.ys[i].i_obj;
				if (i_obj < 0) then continue;	// stampo solo oggetti, non sottosezioni
				if (bo_graphic_objects <> (xobjs(i_obj).tipo_oggetto in [OBJ_BITMAP, OBJ_RECT, OBJ_LINE])) then continue;
				stampa_obj(bo_video, FALSE, vcanvas, pcanvas, i, i_x0_pixel, i_y0_pixel, 0, FALSE, i_max_y_pixel, sec, bo_exportazione_integrale)
			end
		end
	end;
	if bo_exportazione_integrale then
		export_integrale.writeln(i_logical_page_ZB, i_section_ZB, sec.lo_id, i_pagina_fisica);	// chiudo l'exportazione per la sezione

	if (target <> RTA_EXPORT) AND (bo_draw_line_bottom OR bo_draw_rect) then begin
		var tipo : obj_type;
		if bo_draw_rect then tipo := OBJ_RECT else tipo := OBJ_LINE;	// tipo di oggetto da stampare

		// evito che la riga di fine sezione sia stampata sull'ultima sezione della pagina, ovvero sull'ultima sezione che precede la sezione di ordine superiore
		var bo_draw_obj := TRUE;
		if NOT bo_draw_rect AND NOT bo_draw_last_line then begin
			if (sec.next = NIL) then bo_draw_obj := FALSE
			else begin
				var sx : cl_print_section := sec.next;
				while (sx <> NIL) AND (sx.i_section_1B > sec.i_section_1B) do sx := sx.next;
				if (sx = NIL) then bo_draw_obj := FALSE
				else bo_draw_obj := (sx.i_section_1B = sec.i_section_1B)
			end
		end;

		if bo_draw_obj then draw_graphic_object(tipo, sec, bo_video, vcanvas, pcanvas, rrect, i_x0_pixel, i_y0_pixel)
	end;
	i_printing_section_ZB := i_bak_printing_section;
	printing_values := NIL
end;

function cl_sezione.stampa_obj(bo_video : boolean;
	bo_ricalcola_delta : boolean;	// se TRUE ricalcola eventuali sfasamenti di/tra oggetti, altrimenti usa quelli già calcolati
	vcanvas, pcanvas : TCanvas;
	i_print_obj : obj_index_type;i_x0_pixel, i_y0_pixel : int_pixel_type;
	r_max_height_cm : misura_real_type;bo_can_break_object : boolean;
	var i_max_y_pixel : int_pixel_type;
	sv : cl_print_section;bo_export_integrale : boolean) : boolean;
{ stampa l'oggetto specificato;
  I_PRINT_OBJ è l'indice riferito alla struttura contenuta in PRINT_OBJS;
  rende TRUE se la stampa è possibile o è avvenuta con successo e completamente;
  gestisce completamente le eventuali variazioni di posizione verticale degli oggetti aggiornando i campi PRINT_OBJS.R_DELTAY_CM[i];
  I_MAX_Y_PIXEL è la posizione più bassa raggiunta da un qualunque oggetto della sezione;
  serve in particolare per quegli oggetti che non spostano verso il basso i loro compagni
  in caso di variazione di dimensione, e che quindi non essendo monitorati rischiano di finire oltre la fine della sezione;
  if BO_CAN_BREAK_OBJECT then il singolo oggetto può essere stampato anche solo parzialmente }
var
	box_hidden : xboolean;
	xobj : objs_type;

	function hidden : boolean;
	begin
		if (box_hidden = XNOTHING) then
			box_hidden := bool2x(xobj.is_hidden(get_virtual_printing_page, sv.i_ph_page_start, sv.i_ph_page_end, TRUE, sv) OR
				NOT xobj.ca.valuta_print_if(0, xobj.get_name));
		result := (box_hidden = XTRUE)
	end;

const MBOX_CAPTION_DEBUG = 'stampa_obj()';
var
	i_margine_y_pixel, i_temp_max, i_delta_y, i_delta_y0, i_delta_y1, i_max_y_pixel_temp : int_pixel_type;
	cm2pix_y : cm2pix_func;
	pix2cm_y : pix2cm_func;
	r0_cm, r1_cm : misura_real_type;
begin
	var i_obj : obj_index_type := print_objs.ys[i_print_obj].i_obj;
	xobj := xobjs(i_obj, i_logical_page_ZB + 1);
	box_hidden := XNOTHING;

	var tipo : obj_type := xobj.ca.tipo_oggetto;
	// verifica se deve stampare l'obj (solo objs grafici: i testi li tratto cmq per capire se e quanto spazio devo 'tirare su' la stampa)
	if (tipo <> LABEL_OBJ) AND (bo_export_integrale OR hidden) then begin result := TRUE;exit end;
	runtime_debug('obj ' + i_obj.ToString + ' ' + xobj.get_name, MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);

	if bo_export_integrale then begin
		result := TRUE;	// always
		{ preferisco gestire qui la stampa specificando tutti i parametri (pagina, sezione, visibilità, ecc)
		  perchè molti parametri (esempio: la visibilità) sono accessibili solo localmente (qui) }
		var lab : cl_label := xobj.aslabel;
//		if lab.ZB_get_runtime_integral_exportable(globale.i_active_expint_profile, i_logical_page_1B - 1, NOT hidden)
		if lab.ZB_get_integral_exportable(globale.i_active_expint_profile, i_logical_page_ZB, NOT hidden)
			then export_integrale.write(i_logical_page_ZB, i_section_ZB, sv.lo_id, lab);
		exit
	end;

	if bo_video then begin cm2pix_y := cm2pixel_video_y;pix2cm_y := video2cm_y end
	else begin cm2pix_y := cm2pixel_print_y;pix2cm_y := print2cm_y end;
	i_margine_y_pixel := cm2pix_y(r_max_height_cm);
	if bo_ricalcola_delta then begin
		if xobj.ca.bo_posizione_fissa then r0_cm := 0	// 2000-06-10
		else r0_cm := print_objs.get_deltay_cm_for_object(i_print_obj);
		{ i_delta_y1 serve per gli oggetti grafici (rettangoli et simili) per i quali è necessario sapere se
		  al loro interno sono stati modificati degli spazi per consentire il loro eventuale ridimensionamento }
		if (tipo in CORNICI_OBJS) then r1_cm := print_objs.get_deltay_cm_in_object(i_print_obj, i_obj) else r1_cm := 0;
//		xobj.set_print_pos_and_size(i_delta_y0, i_delta_y1)	// assegno i valori ricalcolati
		xobj.set_print_pos_and_size(r0_cm, r1_cm);	// assegno i valori ricalcolati
		if (i_margine_y_pixel = 0) then i_margine_y_pixel := -1	// 0 evita il controllo, ma è sbagliato se semplicemente non c'è più spazio
	end
	else xobj.get_print_pos_and_size(r0_cm, r1_cm);				// leggo i valori precedentemente calcolati
	i_delta_y0 := cm2pix_y(r0_cm);i_delta_y := i_delta_y0;	// traduco i valori nel formato necessario
	i_delta_y1 := cm2pix_y(r1_cm);

	runtime_debug('pre print obj ' + i_obj.ToString, MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02);
	if (xobj.tipo_oggetto = LABEL_OBJ) AND is_debug_attivo(RD_DEBUG_DETTAGLIO_02) then
		runtime_debug('y0=' + strid(pix2cm_y(i_y0_pixel), 0, 2) + ' cm, max-y=' + strid(r_max_height_cm, 0, 2) + ', ' +
			'value[' + zeri(sv.lo_id, 6) + '-' + xobj.get_name + ']=' + copy_puntini(xobj.aslabel.str_print, 100),
			MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02);

	result := xobj.print(vcanvas, pcanvas, i_x0_pixel, i_y0_pixel, bo_video, NIL,
		i_delta_y, {i_max_y_pixel}i_max_y_pixel_temp, {i_delta_y_bottom}i_delta_y1, i_margine_y_pixel, bo_can_break_object,
		{i_ph_first_page_section}sv.i_ph_page_start, {i_ph_last_page_section}sv.i_ph_page_end, sv);
	runtime_debug('post print obj ' + i_obj.ToString + ' result=' + result.SQL, MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02);

	print_objs.set_deltay_cm(i_print_obj, pix2cm_y(i_delta_y - i_delta_y0));
	if bo_ricalcola_delta
		AND NOT hidden	// 2007-01-16: per gestire gli objs exportabili anche se nascosti
	then begin	// dal 2000-10-09: non particolarmente importante, solo un dettaglio
		i_temp_max := i_max_y_pixel_temp;
		i_max_y_pixel_temp := xobj.get_top + xobj.get_height + i_delta_y1;
		if (i_delta_y <> 0) AND (tipo <> OBJ_BITMAP) then inc(i_max_y_pixel_temp, i_delta_y);	// se bitmap, questo termine è già compreso in get_height()

		if (i_temp_max > i_max_y_pixel_temp) then i_max_y_pixel_temp := i_temp_max;	// 2006-01-11

//		if (i_max_y_pixel_temp > cm2pix_y(r_max_height_cm)) then result := FALSE
		result := result AND (i_max_y_pixel_temp <= cm2pix_y(r_max_height_cm))
	end;

	// se l'oggetto deborda dalla sezione, segnalo il fatto in I_DELTA_Y_SECTION_MIN
	if (i_max_y_pixel_temp > i_max_y_pixel) then i_max_y_pixel := i_max_y_pixel_temp;
	runtime_debug('end obj ' + i_obj.ToString + ' ' + xobj.get_name, MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02)
end;

function cl_sezione.impagina(var psv : cl_print_section;pp : cl_print_page;
	r_y0_cm, r_max_height_cm : misura_real_type;var r_y_used_cm : misura_real_type;vcanvas, pcanvas : TCanvas;
	bo_dont_break, bo_stampa_comunque, bo_print_only_subs : boolean;
	var i_broken_section : section_index_type;
	var i_broken_field_section : section_index_type;
	bo_export : boolean = FALSE) : boolean;
{ impagina la sezione specificata prelevando valori dal buffer di lavoro
  SV e spostandoli nel buffer finale PP;
  la procedura è ricorsiva; non vengono considerate tanto le posizioni assolute sulla
  pagina, quanto il fatto che gli oggetti non vadano oltre il bordo inferiore
  della pagina; parametri fondamentali sono:
		R_Y0_CM (input): contiene il punto in cui la sezione viene stampata; è un
			valore assoluto riferito al foglio;
		R_MAX_HEIGHT_CM (input): altezza max della sezione che si sta impaginando
			(e limite sostanziale anche per le sue sottosezioni)
		R_Y_USED_CM (output): spazio verticale effettivamente utilizzato; se la
			funzione rende TRUE tale valore è sempre <= R_MAX_HEIGHT_CM;
		BO_DONT_BREAK è TRUE se la sezione può essere stampata solo se è possibile
			stamparla tutta insieme sulla stessa pagina;
		BO_STAMPA_COMUNQUE: if TRUE la sezione (e le sue sottosezioni) vengono stampate
			anche se è stato impostata l'opzione 'stampa solo se la sezione è contenuta
			nella pagina'; la stampa della prima sezione di ogni pagina ha sempre
			BO_STAMPA_COMUNQUE = TRUE perchè non può trovarsi una situazione più
			favorevole per la stampa e si tratta inoltre di un conflitto che certamente
			non si potrà risolvere nelle pagina successive (perchè anche la sezione
			principale e tutte le sezioni gerarchicamente superiori nelle pagine successive
			restano identiche);
			in caso di conflitto tra BO_DONT_BREAK e BO_STAMPA_COMUNQUE viene seguita
			ovviamente l'indicazione fornita da BO_STAMPA_COMUNQUE;
		BO_CONTINUING_PRINT: generalmente deve essere impostato a FALSE e viene restituito
			con lo stesso valore; se un campo non può essere contenuto nella pagina,
			BO_CONTINUING_PRINT viene restituito TRUE, e bisogna effettuare una chiamata
			alla procedura con gli stessi identici parametri per dar modo di continuare
			la stampa su una pagina successiva;
		I_BROKEN_SECTION: sia in input che in output contiene la sezione spaccata dal fine pagina,
			ovvero una sezione che ha stampato una parte del suo contenuto ma non tutto
			(può essere sia che abbia stampato una parte del record, sia che abbia stampato
			una parte delle sue sottosezioni);
			I_BROKEN_SECTION contiene il valore della subsection più profonda (spaccata);
			vale 0 se non ci si trova in un contesto di sezioni spaccate;
		I_BROKEN_FIELD_SECTION: dovrebbe essere (secondo una postuma ricostruzione del
			possibile significato del termine) la sezione che ha avuto campi spaccati dal fine pagina;
			un campo spaccato è un record che sta un po' su una pagina e un po' sulla successiva;
		BO_EXPORT: i dati non vengono stampati ma exportati sulla destinazione default di exportazione;
  VALORE RESTITUITO: la funzione rende TRUE se l'oggetto sezione è entrato nella pagina }

	procedure errore_sezione_deborda(xobj : objs_type);
	var str_printed, str_not_printed : string;
	begin
		var bo_text := (xobj.ca.tipo_oggetto = LABEL_OBJ);
//		if bo_text then s := strpas(xobj.aslabel.lp_print) + strpas(xobj.aslabel.lp_print_left);
		if bo_text then begin
			str_printed := strpas(xobj.ca.lp_print);
			str_not_printed := strpas(xobj.ca.lp_print_left)
		end;

		MessageBBox(GH,
			'La sezione principale del formato di stampa deborda dai margini.' + ACAPO +
			'Correggere il formato di stampa o le impostazioni di configurazione' + ACAPO2 +
			'pagina logica: ' + get_pagina_logica_attiva_1B.ToString + ACAPO +
			'pagina fisica: ' + pp.i_virtual_page_1B.ToString + ACAPO +
			'oggetto: ' + xobj.get_name + ACAPO +
			'posizione: ' + floattostr(video2cm_x(xobj.get_top)) + ACAPO +
			'altezza (presunta -- solo prima riga): ' + floattostr(video2cm_x(xobj.get_height)) + ACAPO +
			'altezza max pagina: ' + floattostr(r_max_height_cm) +
//			ifs(bo_text, ACAPO2 + 'testo:' + ACAPO + '--- inizio ---------------' + ACAPO + copy_puntini(s, 1000)) + ACAPO + '--- fine -----------------',
			ifs(bo_text, ACAPO2 + '### parte stampata ############' + ACAPO + copy_puntini(str_printed, 1000) + ACAPO +
				'### parte NON stampata ########' + ACAPO + copy_puntini(str_not_printed, 1000) + ACAPO + '### fine ######################'),
			MBOX_CAPTION + ' [' + puntato(lo_serial_number_impagina) + ']', MB_ICONSTOP)
	end;

label start_sub_section;
const MBOX_CAPTION_DEBUG = 'cl_sezione.impagina()';
var
	i, i_obj_index : obj_index_type;
	lo_id_sv : integer;	// LO_ID per il record collegato alla section
	i_y0_pixel : int_pixel_type;
	r_y_ss_cm : misura_real_type;		// spazio usato per SubSections
	r_deltay_cm : misura_real_type;	// differenza tra spazio verticale utilizzato e preventivato; uso esclusivo all'interno della sezione
	r_temp_maxh, r_temp_dy_used_cm, r_temp_y0_cm : misura_real_type;
	r_delta_y_preliminare : misura_real_type;
	psv_print_page, psv_start, psv_subs, psv_temp : cl_print_section;
	bo_stampa_comunque_ss : boolean;			// utile per tenere traccia di un parametro che serve nella stampa delle subsections
	bo_ss_printed : boolean;					// TRUE quando almeno una subsection è stata stampata
	bo_broken_section_here : boolean;		// TRUE se in questa sezione avviene una spaccatura causa fine pagina
	bo_printed_ss_ok : boolean;
//	bo_sezione_debordante_msg : boolean;	// messaggio sulla sezione (principale) che deborda
//	bo_printed_text_obj_ok : boolean;		// stampato con successo almeno un oggetto di testo
	i_max_y_pixel : int_pixel_type;
		{ I_MAX_Y_PIXEL: massima y raggiunta dagli oggetti della sezione; serve per valutare la variazione minima di
		  dimensione della sezione, dovuta a quegli oggetti che non trasmettono agli altri la loro
		  variazione di dimensione; serve solo in caso di aumento della dimensione, per evitare di
		  tagliare un oggetto sulla fine della sezione }
begin
	result := FALSE;
	var bo_result := TRUE;
	i_printing_section_ZB := i_section_ZB;
	inc(lo_serial_number_impagina);		// numero progressivo sequenziale della sezione
//	bo_printed_text_obj_ok := FALSE;
	if ((i_broken_section = 0) AND (i_section_ZB = MAIN_SECTION_ZB)) then set_main_record_starting_on_page(pp.i_virtual_page_1B, psv.str_runtime_filename);
	r_y_used_cm := 0;
	var tstr_2_delete : TStringlist := NIL;
	i_max_y_pixel := 0;

	if bo_dont_print_section then begin result := TRUE;exit end;
	var str_debug_caption := i_logical_page_ZB.ToString + '/' + i_section_ZB.ToString + '/' + lo_serial_number_impagina.ToString + ' - ';
	runtime_debug('START SEZIONE P/L=' + i_logical_page_ZB.ToString + ' SEZ=' + i_section_ZB.ToString +
		' SERIAL=' + zeri(lo_serial_number_impagina, 6) + ' LO_ID=' + zeri(psv.lo_id, 6) + ' SQL-PK:' + psv.str_PK_debug_key,
		MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);

	// se la prima parte della sezione non deve essere stampata, perchè già stampata in una precedente pagina, tiro su i campi fino alla subsection
	r_delta_y_preliminare := 0;
	if (i_section_ZB <> MAIN_SECTION_ZB) AND (i_broken_section >= xi_section_1B) AND NOT bo_reprint_broken_sections AND (i_broken_field_section = 0) then begin
		i := 1;while (i <= print_objs.i_objs) AND (print_objs.ys[i].i_obj > 0) do inc(i);
		r_delta_y_preliminare := sections_1B(-print_objs.ys[i].i_obj).r_y0_rel_cm;
		r_y0_cm := r_y0_cm - r_delta_y_preliminare;
		r_max_height_cm := r_max_height_cm + r_delta_y_preliminare;
		// tiro su in corrispondenza del primo oggetto della sezione corrente, a meno che questo non sia la sottosezione
//		if (i <> 1) AND (i <= print_objs.i_objs) then print_objs.set_deltay_cm(1,-sections(-print_objs.ys[i].i_obj).r_y0_rel_cm)
	end;

	runtime_debug(str_debug_caption + 'preliminare-100', MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02);
	r_y_ss_cm := 0;
	printing_values := psv;psv_start := psv;
	lo_id_sv := psv.lo_id;
	psv.set_section_y0_pos(r_y0_cm);
	i_y0_pixel := cm2pixel_video_y(r_y0_cm);
	bo_broken_section_here := FALSE;
//	if (i_broken_section = 0) then psv.bo_start_page := TRUE;
//	if (i_broken_section = 0) AND (i_broken_field_section = 0) then psv.i_ph_page_start := pp.i_virtual_page;
	if (psv.i_ph_page_start = 0) OR ((i_broken_section = 0) AND (i_broken_field_section = 0))
		then psv.i_ph_page_start := pp.i_virtual_page_1B;

	if NOT bo_print_only_subs then begin	// altrimenti la section in effetti non c'è, come non c'è il suo record
		{$ifdef DEBUG} assert(psv <> NIL,'IMPAGINA: PSV = NIL'); {$endif}
		{ se la stampa non è la continuazione di precedente stampa, assegno i valori dei campi;
		  altrimenti non lo faccio, perchè nella precedente stampa sono stati tolti i valori già stampati }
		runtime_debug(str_debug_caption + 'before set_section_fields_values()', MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02);
//		runtime_debug(str_debug_caption + 'SQL-PK=' + sv.str_PK_debug_key, MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02);
		psv.set_section_fields_values(i_section_ZB + 1, PS_WRITE, {left_values}FALSE, {only_pos_size}FALSE, {forza_calcolo_formule}TRUE);
		runtime_debug(str_debug_caption + 'after set_section_fields_values()', MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02)
	end;

	// copia il record della main section sulla pagina; non lo sposto perchè non è detto che questa sia l'ultima pagina per questo record della main section
	runtime_debug(str_debug_caption + 'copy_print_section_record', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
	psv_print_page := copy_print_section_record(psv, pp, i_broken_field_section = xi_section_1B);
	{$ifdef CHECK_SECTIONS} check_sections_1B(pp.sections, 'impagina()'); {$endif}

	runtime_debug(str_debug_caption + 'pre loop', MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02);
	for i := 1 to print_objs.i_objs do begin
		if ww_stopped then abort;
		runtime_debug(str_debug_caption + 'loop index=' + zeri(i, 3) + ' obj=' + zeri(print_objs.ys[i].i_obj, 3) {+
			' name=' + xobjs(abs(print_objs.ys[i].i_obj),i_logical_page).get_name}, MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
		i_obj_index := print_objs.ys[i].i_obj;
		if (i_obj_index > 0) then begin	// oggetti
			runtime_debug(str_debug_caption + 'name=' + xobjs(i_obj_index, i_logical_page_ZB + 1).get_name, MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
			{ evito di ristampare gli oggetti della sezione già stampata e breakkata, se non indicato dall'apposita opzione;
			  questo in generale vale per gli oggetti fino all'eventuale sottosezione, dopo di che si riprende la stampa (I_BROKEN_SECTION viene rimesso a 0);
			  eventuali condizioni di limitazione della visibilita su singoli oggetti saranno gestite a livello del singolo oggetto }
			if (i_section_ZB <> MAIN_SECTION_ZB) AND (i_broken_section >= xi_section_1B) AND NOT bo_reprint_broken_sections AND (i_broken_field_section = 0) then begin
				psv_print_page.get_record(i_obj_index).bo_dont_print := TRUE;
				continue
			end;
			if bo_print_only_subs then continue;		// non stampo gli objects, ma solo le subsections
			if NOT stampa_obj(TRUE, TRUE, vcanvas, pcanvas, i, 0, i_y0_pixel, r_max_height_cm,
				{can_break_object}bo_stampa_comunque OR NOT bo_dont_break_fields, i_max_y_pixel, psv_print_page, {export}FALSE)
			then begin
				runtime_debug(str_debug_caption +
					'SEZIONE DEBORDANTE obj=' + xobjs(i_obj_index, i_logical_page_ZB + 1).get_name + ' ===============================================',
					MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);

				// la main section non può debordare !
				if (i_section_ZB = MAIN_SECTION_ZB) then begin
					errore_sezione_deborda(xobjs(i_obj_index, i_logical_page_ZB + 1));
					abort
				end;

				if bo_stampa_comunque OR (NOT bo_dont_break_fields {AND bo_printed_text_obj_ok}) then begin	// commentato il 2005-09-18
					{ impossibile stampare la sezione intera; il parametro BO_STAMPA_COMUNQUE autorizza a stampare sulla pagina presente la prima parte della
					  sezione, e a mandare sulla pagina successiva la parte rimanente;
					  analogo valore ha il predicato: campi spezzabili AND stampato almeno un campo felicemente (se non ha stampato ancora nulla,
					  la sezione può essere iniziata tranquillamente sulla pagina successiva);
					  il set di valori stampati non è stampabile ed è stato trattato solo parzialmente;
					  la procedura di stampa ha modificato gli oggetti caricando solo quelle parti di records che era in grado di stampare;
					  aggiorno il set di valori in fase di stampa ed aggiungo subito dopo un nuovo set di valori contenente la parte dei records che
					  non è stato possibile stampare in questa tornata }
					psv.set_section_fields_values(i_section_ZB + 1, PS_READ, {left_values}FALSE, {only_pos_size}FALSE, {forza_calcolo_formule}FALSE);	// aggiorno con la parte di record stampato
					if (psv_print_page <> NIL) then	// aggiorno la copia assegnata alla pagina di stampa
						psv_print_page.set_section_fields_values(i_section_ZB + 1, PS_READ, {left_values}FALSE, {only_pos_size}FALSE, {forza_calcolo_formule}FALSE);

					{ in caso di un record che va su piu' pagine capita che GALATEO vada in loop e non si blocchi perche' non riesce a tagliare a pezzi il record;
					  capita, credo, quando il record troppo lungo non è una variabile, ma una formula che deriva da altre variabili, i cui valori intatti
					  generano ad ogni pagina nuova il record troppo lungo; non sono sicurissimo, ma potrebbe essere cosi' }

					if (i_section_ZB + 1 >= i_broken_field_section) then begin	// IF del 2005-09-19
						psv.insert_complementary_set;					// aggiungo un set contenente i dati non stampati (spostato dentro l'IF 2005-09-19: prima era sopra)
						bo_broken_section_here := TRUE;					// riga ripristinata il 2005-09-18
						i_broken_field_section := i_section_ZB + 1	// segnalo di aver spaccato un record in questa sezione
					end;
					bo_result := FALSE;
					break
				end;
				// se la stampa non deve avere luogo, elimino il record che non sta nello spazio disponibile
				delete_print_sections_from_to(pp, psv.lo_id, -1);
				psv.i_ph_page_start := 0;	// evito di inizializzare la pagina su cui la sezione è iniziata
				i_broken_field_section := 0;
				exit
			end;
			runtime_debug(str_debug_caption + 'after print', MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02);
			// metto a TRUE se ho stampato felicemente almeno un oggetto di testo
//			bo_printed_text_obj_ok := bo_printed_text_obj_ok OR (xobjs(i_obj_index, i_logical_page).get_tipo in TESTI_OBJS)
		end
		else begin	// sub sections
			i_obj_index := -i_obj_index;	// indice della subsection, che era negativo ed adesso lo rendo positivo
			var ss : cl_sezione := sections_1B(i_obj_index);		// SS = sub-section
			psv_subs := psv.next;				// subsection to print
			bo_ss_printed := FALSE;
start_sub_section:
			{ r_temp_max_height := max height of subsection
			  altezza max della sotto-sezione; se questa è la MAIN_SECTION, i limiti della sotto sezione sono assoluti,
			  altrimenti sono relativi e coincidono teoricamente con quelli della sottosezione della main-section (nel senso che l'unico limite
			  è che non possono debordare dai limiti assoluti della sub-section della MAIN_SECTION) }

			r_deltay_cm := print_objs.get_deltay_cm_for_object(i);
			r_temp_y0_cm := r_y0_cm + ss.r_y0_rel_cm + r_y_ss_cm + r_deltay_cm;
			runtime_debug(str_debug_caption + 'section-100', MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02);
			if (i_section_ZB = MAIN_SECTION_ZB) then	// subsection della main section
				r_temp_maxh :=							// ALTEZZA MAX DELLA SUBSECTION (spazio max disponibile per la stampa) :=
					ss.r_y_sezione_cm					// altezza max teorica della sezione (non del gruppo di record, che è una dimensione di occupazione minima, ma dell'intera sezione)
					- r_deltay_cm						// MENO la differenza tra lo spazio occupato e quello preventivato
					- r_y_ss_cm							// MENO lo spazio già utilizzato per altre istanze di sub-sections
			else	// sub-[sub-[sub-...]] sections
				r_temp_maxh := 						// ALTEZZA MAX DELLA SUBSECTION (spazio max disponibile per la stampa) :=
					r_max_height_cm					// altezza max della sezione presente
					- r_y_gruppo_cm					// MENO lo spazio riservato per la sezione corrente
					+ ss.r_y_sezione_cm				// PIÙ la dimensione base della subsection
					- r_deltay_cm						// MENO la differenza tra lo spazio occupato e quello preventivato
					- r_y_ss_cm;						// MENO lo spazio già utilizzato da altre istanze della sub-sections
{			****** le seguenti righe sono state commentate 2018-03-10
			se la sotto-sezione slitta verso il basso, la sua dimensione (massima) deve essere ridotta della dimensione dello slittamento;
			queste righe impediscono che ciò avvenga;
			inoltre in rari casi, se la subsection slitta verso il basso, questa istruzione determina lo slittamento verso l'alto della seconda riga
			della subsection, che va a coprire e nascondere la prima riga;
			il caso che ha dimostrato il problema è stato IBI, rapportini-riepilogo-01.gal, stampa report rapportini RP/17/2272 RP/17/1823 RP/17/1848
			(l'aspetto qualificante è che la denominazione del cliente è troppo lunga e viene mandata a capo, generando uno scostamento verticale);
			il problema si manifesta solamente con la "nuova" modalità di valutazione degli scostamenti verticali (globale.BOX_NEW_VALUTAZIONE_SCOSTAMENTO),
			motivo per cui è rimasto latente per molto tempo }
{			if (i_section_ZB = MAIN_SECTION_ZB) AND (r_deltay_cm <> 0) then begin
				// modifico l'altezza e la posizione della sottosezione della main section
				print_objs.set_deltay_cm(i, -r_deltay_cm)	// alla fine della sezione lo spazio viene azzerato perchè utilizzato o risparmiato
			end; {}

			runtime_debug(str_debug_caption + 'section-200', MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02);
			if (psv_subs = NIL) OR (psv_subs.i_section_1B {<>} < i_obj_index) then begin	// nessun valore da stampare nella subsection
				// ----- aggiunta di gennaio '98 ---------
				print_objs.set_deltay_cm(i, r_y_ss_cm - ss.r_y_sezione_cm);
				// ----- fine aggiunta -------
				continue
			end;
//			if (ss.r_minimum_required_space_cm <= r_temp_maxh) then begin	// se ho lo spazio necessario per la subsection -- modificato il 2005-12-27
			if (max(ss.r_minimum_required_space_cm, ss.r_y_gruppo_cm) <= r_temp_maxh) then begin	// se ho lo spazio necessario per la subsection
				// se mi trovo sulla MAIN_SECTION e non ho ancora stampato nessuna subsection passa BO_STAMPA_COMUNQUE = TRUE
				// BO_STAMPA_COMUNQUE_SS: TRUE se TRUE per la section, ma solo per la prima subsection
				bo_stampa_comunque_ss := (bo_stampa_comunque AND NOT bo_ss_printed) OR ((i_section_ZB = MAIN_SECTION_ZB) AND (r_y_ss_cm = 0));
				bo_printed_ss_ok := ss.impagina(psv_subs, pp, r_temp_y0_cm, r_temp_maxh, r_temp_dy_used_cm, vcanvas, pcanvas, bo_dont_break, bo_stampa_comunque_ss,
					(psv_subs.i_section_1B > i_obj_index), i_broken_section, i_broken_field_section, bo_export);
					{ SV_SUBS.I_SECTION > J: saltata una subsection: è il caso in cui una sub-sub-section non stia sulla pagina
					  e venga stampata in testa alla pagina successiva, senza il preludio della sua sezione padre }
				i_printing_section_ZB := self.i_section_ZB;
				r_y_ss_cm := r_y_ss_cm + r_temp_dy_used_cm	// aggiorno lo spazio utilizzato per le subsections
			end
			else begin
				bo_printed_ss_ok := FALSE;
				runtime_debug(str_debug_caption + 'MANCA SPAZIO STAMPA SOTTOSEZIONE -- ' +
					'disponibile=' + strid(r_temp_maxh, 3) + ' richiesto=' + strid(max(ss.r_minimum_required_space_cm, ss.r_y_gruppo_cm), 0, 3),
					MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02)
			end;

			runtime_debug(str_debug_caption + 'section-300', MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02);
			if bo_printed_ss_ok then begin
				bo_ss_printed := TRUE;		// stampata successevolmente almeno una subsection
				if (i_section_ZB = MAIN_SECTION_ZB) then begin
					{ la stampa del record della sub-section (e di tutte le sue eventuali sub-sections) è andata ok;
					  sposto il record della sub-section (e delle eventuali sub-sub-sections) sulla pagina attuale }
					repeat
						delete_print_section_record(psv, psv.next.lo_id {$ifdef DEBUG},0{$endif})
					until (psv.next = NIL) OR (psv.next.i_section_1B <= i_obj_index);

					// se c'è un altro record per la sub-section, vado a stamparlo
					{$ifdef DEBUG} assert(i_broken_section = 0,'ASXD 9318'); {$endif}	// non dovrebbe mai capitare
					if (psv.next <> NIL) AND (psv.next.i_section_1B = i_obj_index) AND (i_broken_section = 0) then begin
						psv_subs := psv.next;	// next subsection to print
						goto start_sub_section
					end
				end
				else begin
					{ salto tutte le sottosezioni della sezione I_OBJ_INDEX, che ho già stampato;
					  queste sottosezioni, se la stampa della sottosezione della sezione
					  principale andrà a buon fine, saranno eliminate in blocco alla fine }
					repeat psv_subs := psv_subs.next until (psv_subs = NIL) OR (psv_subs.i_section_1B <= i_obj_index);
					// se dopo le sottosezioni c'è una sezione di livello I_OBJ_INDEX la stampo, altrimenti proseguo la stampa della sezione corrente
					if (psv_subs <> NIL) AND (psv_subs.i_section_1B = i_obj_index) then goto start_sub_section
				end
			end
			else begin	// stampa subsection(s) fallita
				{ la stampa della sub-section (e delle sue eventuali sub-sections) non è stata possibile;
				  se sono sulla MAIN SECTION chiudo la pagina e passo alla successiva (dopo aver stampato tutto ciò che manca
				  sulla pagina corrente; altrimenti passo il segnale di fine spazio alla sezione gerarchicamente superiore }
//				if (i_section = MAIN_SECTION) then begin
				runtime_debug(str_debug_caption + 'STAMPA SOTTOSEZIONE IMPOSSIBILE', MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02);
				if (i_broken_field_section = 0) then begin	// dal 1999-05-09
					{ se posso tener buone le subsections già stampate, le elimino dalla lista delle subsections da stampare;
					  se invece devo tenere tutte le subsections sulla stessa pagina, rimuovo la stampa già eseguita
					  (la section corrente con tutte le subsections già stampate) }
					if (({bo_ss_printed AND} NOT bo_dont_break_subsections) OR bo_stampa_comunque) then begin
						// carico su una TStrings la lista delle subs da eliminare perchè già stampate, se la sezione corrente sarà stampata con successo
						tstr_2_delete := TStringlist.Create;
						psv_temp := psv.next;
						while (psv_temp.lo_id <> psv_subs.lo_id) do begin
//							delete_print_section_record(sv,sv.next.lo_id{$ifdef DEBUG},0{$endif});
							tstr_2_delete.add(psv_temp.lo_id.ToString);
							psv_temp := psv_temp.next
						end;
//						r_y_used_cm := r_max_height_cm - r_delta_y_preliminare;	// ho usato tutto lo spazio disponibile, per definizione
						bo_broken_section_here := TRUE;	// indico che la sezione attuale è stata interrotta
//						bo_result := TRUE*
						bo_result := FALSE;
//						bo_stampa_comunque := bo_ss_printed
					end
					else begin	// la sezione, nel suo complesso non è stampabile: annullo tutto
						delete_print_sections_from_to(pp, psv.lo_id, -1);	// cancella da questa sezione in stampa in poi
						result := FALSE;exit
					end
				end
				else begin
					{ se è stato spaccato un field, elimino dalla lista dei records da stampare tutti i records fino a quello tagliato;
					  elimino anche il record contenente la prima parte del field tagliato, e lascio che si ricominci a stampare a partire dal suo successore,
					  che contiene la parte di field non ancora stampata }
					if (i_broken_field_section = i_section_ZB + 2) then begin	// IF: dal 2005-09-18, prima c'era solo il contenuto dell'IF
						var lo_temp : integer := psv_subs.next.lo_id;
						while (psv.next.lo_id <> lo_temp) do
							delete_print_section_record(psv, psv.next.lo_id{$ifdef DEBUG},0{$endif})	// dal 09.05.99
					end;

					// lascio che il loop continui per completare la stampa dei campi della main section
//					if (sv.next.i_section = MAIN_SECTION+1) then delete_print_sections_from_to(pp,sv.next.lo_id,-1)	// fino al 14.03.99
//					if (bo_stampa_comunque_ss) then delete_print_section_record(sv,sv_subs.lo_id{$ifdef DEBUG},2{$endif})	// dal 14.03.99
//					if (i_broken_field_section <> 0) then delete_print_section_record(sv,sv_subs.lo_id{$ifdef DEBUG},2{$endif})	// dal 09.05.99
					bo_result := FALSE	// dal 2005-09-18
				end
			end;
			runtime_debug(str_debug_caption + 'after subsection-300', MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02);

			// calcolo quanto spazio la sezione ha occupato in piu' o in meno
			// R_DELTAY_CM := modifica della dimensione della sottosezione; positivo se si è ingrandita
			r_deltay_cm := r_y_ss_cm - ss.r_y_sezione_cm {- r_delta_y_preliminare};
			// r_deltay_cm := quanto spazio la sezione ha occupato in piu' o in meno
			if (i_section_ZB = MAIN_SECTION_ZB) then begin
//				if (r_deltay_cm > 0) then r_deltay_cm := 0;	// 2005-12-20: la subsection della main section non può ingrandirsi, altrimenti la main section sballa!
//				{$ifdef DEBUG} assert(r_deltay_cm <= -print_objs.get_deltay_cm_for_object(i) <= 0,'main section non contenuta entro i suoi margini MZW 233'); {$endif}
				if ss.bo_fill_tutto then begin
					// dal 99/08/10, giorno di illuminazione
					r_deltay_cm := -print_objs.get_deltay_cm_for_object(i)
					// STAMPA OK: aggiungo/tolgo lo spazio che era stato guadagnato/perso all'inizio della sezione
//					if bo_printed_ss_ok then r_deltay_cm := -print_objs.get_deltay_cm_for_object(i)
//					else r_deltay_cm := Rmin(r_deltay_cm,0)		// ... a meno che questa non sia andata oltre i suoi limiti naturali
					// cosi' fino al 9 agosto 1999
//					else r_deltay_cm := Rmin(r_deltay_cm,0)-print_objs.get_deltay_cm_for_object(i)		// ... a meno che questa non sia andata oltre i suoi limiti naturali
				end
			end
			else begin
//				if ss.bo_fill_tutto then r_deltay_cm := max(r_deltay_cm,0)
				if ss.bo_fill_tutto AND (r_deltay_cm < 0) then r_deltay_cm := 0
			end;
			runtime_debug(str_debug_caption + 'after subsection-400', MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02);
			print_objs.set_deltay_cm(i, r_deltay_cm)	// da eseguire anche se (r_deltay_cm = 0)
//			if NOT result then exit
		end
	end;
	runtime_debug(str_debug_caption + 'after loop', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);

	if (tstr_2_delete <> NIL) then begin
		for var ii : smallint := 0 to tstr_2_delete.Count-1 do delete_print_section_record(psv, StrToInt(tstr_2_delete[ii]){$ifdef DEBUG},0{$endif});
		tstr_2_delete.free
	end;

	runtime_debug(str_debug_caption + 'terminate-00', MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02);
	if bo_result AND (i_broken_field_section = i_section_ZB + 1) then i_broken_field_section := 0;
	// se non ho spaccato un campo qui, e se la sezione in cui l'ho fatto è di ordine pari o inferiore, annullo l'indicazione
	if NOT bo_broken_section_here AND (i_broken_field_section <= i_section_ZB + 1) then i_broken_field_section := 0;
	// aggiunta del 23/04/99 ----------------------------------------------------
	{$ifdef CHECK_SECTIONS} check_sections(pp.sections,'AKJQ 9581'); {$endif}
	psv_temp := pp.get_print_section_1B(lo_id_sv{$ifdef DEBUG},i_section_ZB + 1{$endif});
	{$ifdef DEBUG} assert(psv_temp <> NIL,'QIW 199'); {$endif}
	psv_temp.set_section_fields_values(i_section_ZB + 1, PS_READ, {left_values}FALSE, {only_pos_size}TRUE, {forza_calcolo_formule}FALSE);
//	if (bo_result) then sv_temp.i_last_page := bo_result;	// aggiunto il 2002-12-08
	if bo_result then psv_print_page.i_ph_page_end := pp.i_virtual_page_1B
	else psv_print_page.i_ph_page_end := -1;	// NOT zero
//	end;
	// --------------------------------------------------------------------------

	runtime_debug(str_debug_caption + 'terminate-01', MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02);
	// verifico se la stampa è contenuta entro il limite della sezione
	result := bo_result;
	{$ifdef DEBUG} if NOT bo_result then assert(bo_broken_section_here OR (i_broken_section <> 0),'break-problem -- KJMX 9931'); {$endif}
	printing_values := NIL;
	if (i_section_ZB = MAIN_SECTION_ZB) then begin
		if (psv.next = NIL) OR (psv.next.i_section_ZB = MAIN_SECTION_ZB) then begin
			delete_first_print_section_record(psv);  // se ho terminato questa main section, faccio avanzare i dati
			set_main_record_ending_on_page(pp.i_virtual_page_1B)
		end;
		r_y_used_cm := 0		// valore non utilizzato
	end
	else begin
//		if (str_SQL_start_record <> '') then tratta_index;
		if bo_broken_section_here then i_broken_section := i_section_ZB + 1
		else
			if (i_section_ZB + 1 >= i_broken_section) then	// IF del 2005-09-18
				i_broken_section := 0;	// nessuna sezione è interrotta (non piu', almeno)
//		delete_print_sections_from_to(pp,sv_start.lo_id,sv.lo_id);
		r_y_used_cm := MIN(r_y_gruppo_cm + print_objs.get_deltay_cm_totale,r_max_height_cm) {- r_delta_y_preliminare};	// commento del 2005-12-20, spostato qualche riga sotto
			{ lo spazio occupato è pari alla dimensione teorica PIU' la differenza
			  tra spazio utilizzato e preventivato (che può anche essere negativa);
			  se tuttavia un oggetto ha debordato dai suoi limiti comunque la dimensione
			  max non può superare quella max della sezione }
		print_objs.reset_scostamenti(get_virtual_printing_page);		// 2007-01-15: riazzero gli scostamenti per gli oggetti della sezione
		{ verifico se vi sono oggetti finiti oltre la dimensione calcolata della sezione;
		  ciò è possibile a causa degli oggetti che non comunicano agli altri la variazione di dimensione }
		r_temp_maxh := video2cm_y(i_max_y_pixel){ - r_y0_cm} {- r_delta_y_preliminare};
		if (r_temp_maxh > r_y_used_cm) then r_y_used_cm := r_temp_maxh + 0.1	// +0.1 per avere un minimo di margine
	end;
	runtime_debug(str_debug_caption + 'terminate-02', MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02);
	if (str_SQL_start_record <> '') then tratta_index;
	psv_print_page.set_section_height(r_y_used_cm);
	r_y_used_cm := r_y_used_cm - r_delta_y_preliminare;		// dal 2005-12-20
	runtime_debug(str_debug_caption + 'end', MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02)
end;

procedure cl_sezione.tratta_index;
// esegue le elaborazioni atte alla generazione dell'indice
const	MBOX_CAPTION = 'Generazione indice';
begin
	var qry : TFQuery := NIL;
	try
		var str_temp := str_SQL_start_record;
		sostituisci(str_temp,ACAPO,' ');		// sostituisco gli ACAPO con più miti BLANKS
		str_temp := togliblanks(str_temp);if (str_temp = '') then exit;
		var tipo : risultato_type := VAL_TESTO;
		if NOT interpreta_string(str_temp, {stampa_vera}TRUE, {check_errors}FALSE) then;
		if NOT translate_formula(str_temp, str_temp, FALSE, tipo, NIL) then raise exception.create(str_temp);
		runtime_debug(str_temp, MBOX_CAPTION, RD_DEBUG_PRINCIPALE_00);
		qry := create_query(application, self.qry.DatabaseName);		// non assegno l'istruzione SQL perchè devo eseguire, non aprire
		qry.SQL.Text := str_temp;
		Gdebug_SQL(qry, MBOX_CAPTION);
		qry.execSQL
	except
		error_msg('', MBOX_CAPTION);
		abort
	end;
	free_query(qry)
end;

{$endif CASA}

function cl_sezione.interpreta_string(var s : string;bo_stampa_vera, bo_check_errors : boolean;str_context_caption : string = '') : boolean;
{ interpreta la stringa passata come parametro; traduce
		$abc nel valore della variabile ABC, se esiste
		gli oggetti database nel formato    SEZIONE.object
  if BO_CHECK_ERRORS gli eventuali simboli trovati devono essere definiti, altrimenti vengono tradotti solamente se effettivamente esistenti
  (questa opzione serve per consentire di usare il carattere $ nel testo, ad esempio);
  if BO_XML_SPECIAL_CHARS traduce i caratteri speciali XML (ovvero: &<>'" ) nella notazione XML-compatibile;
  rende TRUE se esegue una qualche modifica a S }
var
	bo_macro : boolean;	//*
	i, i_pos_sep, i_len_sep : smallint;
	str_temp, str_line, str_result : string;
begin
	if (s = '') then begin result := FALSE;exit end;

	// vado alla caccia delle macro parametriche
	repeat
		bo_macro := FALSE;
		while (pos('$', s) <> 0) do begin
			i := pos('$', s);
			str_line := str_line + copy(s, 1, i-1);
			delete(s, 1, i);	// cancello anche il dollaro

			// macro parametrica?
			if globale.translate_macro_parametrica(s, str_result, NIL, NOT bo_stampa_vera) then begin
				bo_macro := TRUE;
//				if bo_XML_special_chars then str_result := text2XML_special_chars(str_result);	**** NON converto la macro nel suo insieme, potrebbe contenere simboli < e > XML;
				str_line := str_line + str_result
			end
			else str_line := str_line + '$'	// rimetto il dollaro
		end;
		s := str_line + s;	// tutto quello che resta
		str_line := ''
	until NOT bo_macro;

(*	lp := @s[1];i := 0;
	while (strlen(lp) > i) do begin
		if ww_stopped then abort;
//		str_temp := strpas(@lp[i]);
		str_temp := strpas(LPSTR(@lp[i]));
		if get_sql_separator(str_temp, i_pos_sep, i_len_sep) then
			if (i_pos_sep = 1) then delete(str_temp, i_pos_sep + i_len_sep, MAXINT)
			else delete(str_temp, i_pos_sep, MAXINT);
		inc(i, length(str_temp));

		interpreta_word(str_temp, bo_stampa_vera, {check_errors}FALSE, str_result, str_context_caption);	// FALSE perchè non è questo il momento del controllo finale -- 2016-02-25
		if (uppercase(str_temp) = str_result) then str_result := str_temp;	// non trasformo inutilmente in maiuscolo

		str_line := str_line + str_result
	end; *)

//	if ww_stopped then abort;
	while (s <> '') do begin
		if get_sql_separator(s, i_pos_sep, i_len_sep) then begin
			if (i_pos_sep = 1) then begin		// separatore SQL ad inizio stringa; lo tolgo e proseguo
				str_line := str_line + copy(s, 1, i_len_sep);
				delete(s, 1, i_len_sep);
				continue
			end;
			str_temp := copy(s, 1, i_pos_sep - 1)	// estraggo la prima parola
		end
		else str_temp := s;	// non c'è nessun separatore SQL: la stringa contiene una sola 'parola' (probabilmente l'ultima dell'istruzione)
		delete(s, 1, str_temp.Length);		// tolgo la parte di stringa trattata

		interpreta_word(str_temp, bo_stampa_vera, {check_errors}FALSE, str_result, str_context_caption);	// FALSE perchè non è questo il momento del controllo finale -- 2016-02-25
		if (uppercase(str_temp) = str_result) then str_result := str_temp;	// non trasformo inutilmente in maiuscolo
		str_line := str_line + str_result
	end;

	// cerco simboli sfuggiti al controllo (esempio: '$PARM' non viene cuccato a causa degli apici)
	i := 0;
	while (pos('$', copy(str_line, i+1, MAXINT)) <> 0) do begin
		runtime_debug('Interpretazione ' + ACAPO + str_line,'interpreta_string()', RD_DEBUG_ACCESSORIO_01);
		i := i + pos('$', copy(str_line, i+1, MAXINT));	// perchè altrimenti un doppio dollaro mi manda in casino, come ha fatto il 2000-11-27
		str_temp := copy(str_line, i, MAXINT);

		if get_sql_separator(str_temp, i_pos_sep, i_len_sep) then
			if (i_pos_sep = 1) then delete(str_temp, i_pos_sep + i_len_sep, MAXINT) else delete(str_temp, i_pos_sep, MAXINT);
		// esamino la stringa intera, poi tolgo l'ultimo carattere, poi il penultimo, ...
		while (str_temp <> '$') do begin
			interpreta_word(str_temp, bo_stampa_vera, FALSE, str_result, str_context_caption);
			runtime_debug(str_temp + ACAPO + '-->' + ACAPO + str_result, 'interpreta_string()', RD_DEBUG_ACCESSORIO_01);
			if (uppercase(str_temp) <> str_result) then begin
//				if bo_XML_special_chars then str_result := text2XML_special_chars(str_result);
				delete(str_line, i, length(str_temp));
				insert(str_result, str_line, i);
				break
			end;
			delete(str_temp, length(str_temp), 1)	// tolgo un carattere per volta
		end
	end;
	result := (uppercase(s) <> uppercase(str_line));
	if result then s := str_line
end;

procedure cl_sezione.interpreta_tstring(tstr : TStrings;bo_stampa_vera : boolean);
// traduce una query in SQL
begin
	var s : string := tstr.Text;
	interpreta_string(s, bo_stampa_vera, {check_errors}TRUE);
	tstr.Text := s
end;

procedure cl_sezione.interpreta_word(str_word : string;bo_stampa_vera,bo_check_errors : boolean;var str_result : string;str_context_caption : string = '');
{ traduce una parola (parametro, macro interna) nella sua forma finale ed esplicita;
  cerca di interpretare secondo i simboli conosciuti in questa sezione, poi fa cercare
  negli ancestors, poi nei parametri generali;
  rende la parola tradotta; se non trova traduzioni, rende la parola non tradotta;
  se BO_CHECK_ERRORS, il simbolo deve essere riconosciuto, pena l'emessione di un errore bloccante (ATTENZIONE: si rischia di bloccare tutto per una banalità);
  la stringa LP_RESULT deve essere valida e deve essere restituita a carico della procedure chiamante }
const MBOX_DEBUG_CAPTION = 'interpreta_word()';
var
	i, j :  smallint;
	str_section, str_value : string;
	qry : TFQuery;
	xobj : objs_type;
begin
	str_word := uppercase(str_word);
	if (str_context_caption = '') then str_context_caption := get_name(TRUE)
	else str_context_caption := get_name(TRUE) + ' - ' + str_context_caption;

	if str_word.StartsWith('$') then begin
		xobj := name2obj(copy(str_word, 2, MAXINT), TRUE);
		// lascio aperto a tutti i tipi di oggetto, anche se ho il dubbio di dover limitare la ricerca alle sole variabili e funzioni
		if (xobj = NIL) then begin
			if NOT bo_check_errors then begin	// symbol not found: non ne faccio un dramma
				str_result := str_word;exit
			end;
			MessageBBox(0, '<' + str_word + '>: impossibile interpretare l''espressione', str_context_caption, MB_ICONSTOP);
			abort
		end
		else begin
//			str_result := {$ifdef DLL} strpas(xobj.aslabel.lp_print) {$else} xobj.aslabel.str_esempio_value {$endif};
{$ifdef DLL}
			str_result := xobj.aslabel.str_print;
{$else}
			if bo_stampa_vera AND
//				(NOT (xobj.aslabel.tipovar in TV_COSTANTI) OR
				(NOT (xobj.ca.tipo_variabile in TV_COSTANTI) OR
//				 ((xobj.aslabel.tipovar = TV_PARAMETRO) {AND xobj.aslabel.bo_set_parm_esempio_runtime} AND xobj.aslabel.bo_runtime_default_is_SQL))
				 ((xobj.ca.tipo_variabile = TV_PARAMETRO) {AND xobj.aslabel.bo_set_parm_esempio_runtime} AND xobj.aslabel.bo_runtime_default_is_SQL))
			then str_result := xobj.aslabel.str_print
//			else str_result := xobj.aslabel.str_esempio_value;
			else str_result := xobj.ca.str_esempio_value;
{$endif DLL}

			// if NOT DLL then per i parametri prendo sempre il valore di esempio
(*			if bo_stampa_vera {$ifdef GALATEO_EXE} AND (xobj.aslabel.tipovar <> VAR_PARAMETRO) {$endif} then str_result := xobj.aslabel.str_print
			else str_result := xobj.aslabel.str_esempio_value; *)
			runtime_debug(str_word + '=' + str_result, MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
			exit
		end
	end;

	j := pos('.', str_word);
	if (j <> 0) then begin
		str_section := copy(str_word, 1, j-1);
		i := 1;while (i <= get_num_sections) AND (str_section <> uppercase(sections_1B(i).get_name)) do inc(i);
		if (i <= get_num_sections) then begin
			qry := sections_1B(i).qry;
			if qry.Active then begin
				var ff : TField := qry.FindField(copy(str_word, j+1, MAXINT));
				if (ff <> NIL) then begin	// l'oggetto è un campo database
					if ff.isnull then begin str_result := 'NULL';exit end
					else begin
						str_value := ff.AsString;
						case ff.datatype of
							fTCurrency, fTFloat, ftFMTBcd, fTInteger, fTSmallint, fTWord, ftAutoInc : str_result := str_value;
							fTString, fTDate, fTDateTime, fTTime: str_result := str_value.QuotedString;
//							fTMemo, fTBCD, fTBlob, ftBoolean, fTBytes, fTGraphic, fTVarBytes: begin
							else begin
								str_value := 'Tipo di dato non gestito= ' + str_word;
								runtime_debug(str_value, MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
								MessageBBox(0, str_value, str_context_caption, MB_ICONSTOP);
								abort
							end
						end
					end
				end
				else begin	// non è un campo database: verifico se si tratta di un oggetto della sezione specificata
					xobj := name2obj(copy(str_word, j+1, MAXINT), FALSE);
					if (xobj = NIL) then begin
						// simbolo proprio non trovato: non ne faccio un dramma
						str_result := str_word;exit
{						MessageBBox(0, '<' + str_word + '>: impossibile interpretare l''espressione', STR_MBOX_CAPTION, MB_ICONSTOP);
						abort }
					end;
					if (xobj.ca.i_section_1B <> i) then begin
						MessageBBox(0, '<' + str_word + '>: identificativo ignoto', str_context_caption, MB_ICONSTOP);
						abort
					end;
					str_result := xobj.aslabel.str_print
				end
			end
			else str_result := '''137''';	// vale sia come numero che come stringa
			exit
		end
	end;
	str_result := str_word
end;

function cl_sezione.is_son_ZB(i_son_ZB : section_index_type) : boolean;
// rende TRUE se I_SON è un figlio della sezione
begin
	result := (sections_ZB(i_son_ZB).i_father_ZB = i_section_ZB)
end;

{$ifdef CASA}

procedure cl_sezione.validate_objects(valid : cl_validation;sv : cl_print_section;bo_validate_pre_SQL : boolean;limita_context : validazione_context_set = []);
{ esegue il controllo di validazione per gli oggetti appena letti;
  se BO_VALIDATE_PRE_SQL esegue la validazione esclusivamente sugli oggetti che devono essere validati PRIMA dell'esecuzione }

	procedure genera_errore(x : objs_type;vx : cl_validazione);
	var str_temp, str_message, str_reference : string;	//**
	begin
		str_message := vx.str_message;
		if (str_message = '') then begin		// nessun messaggio esplicito, genero un messaggio standard automatico
			// genero un riferimento automatico per contestualizzare l'errore
			if (vx.str_descrizione_field = '') then begin
				if (sv = NIL) then str_temp := '' else str_temp := '=' + sv.str_value_codice_record;
				str_reference := get_name(TRUE) + '-' + x.get_name + str_temp
			end
			else str_reference := vx.str_descrizione_field;
			case vx.tipo of
				VALID_FORMULA : str_message := 'condizione di validazione non soddisfatta';
				VALID_ERROR_IF_BLANK : str_message := 'il campo NON può essere vuoto';
				VALID_ERROR_IF_NOT_BLANK : str_message := 'il campo DEVE essere vuoto -- valore attuale: <' + copy_puntini(x.aslabel.str_print, {i_len}30) + '>';
			end
		end
		else begin		// messaggio personalizzato utente
			str_reference := '';		// lascio all'utente la contestualizzazione del problema
			interpreta_string(str_message, {stampa_vera}TRUE, {check_errors}FALSE);
			sostituisci(str_message, ACAPO, ' | ')		// gli ACAPO non sono tollerati, e generano GRAVI PROBLEMI
		end;

		var bo_blocco := FALSE;
		if vx.bo_bloccante then begin
			bo_blocco := TRUE;
			if (vx.str_condizione_bloccante_aggiuntiva <> '') AND
				NOT interpreta_boolean_expression(vx.str_condizione_bloccante_aggiuntiva, {test}FALSE, bo_blocco, str_temp) then
					raise exception.Create('Errore nel CONTROLLO DI VALIDAZIONE: valutazione della CONDIZIONE AGGIUNTIVA DI BLOCCO -- ' +
						'[' + get_name + ' - ' + x.get_name + ']' + ACAPO2 + str_temp)
		end;
		if NOT silent_mode AND bo_validate_pre_SQL AND bo_blocco then begin
			MessageBBox(GH, coalesce(vx.str_descrizione_field, get_name(TRUE) + '-' + x.get_name) + ACAPO2 + str_message, 'Report ' + globale.str_filename, MB_ICONSTOP);
			abort
		end
		else validation_add(valid, str_message, bo_blocco, {deroga}FALSE, str_reference, x)
	end;

var
	s : string;	//*
	bo, bo_blank : boolean;	//*
begin
	for var iZB : obj_index_type := 0 to i_objs_ZB(i_logical_page_ZB) - 1 do begin
		var x : objs_type := xobjs_ZB(iZB, i_logical_page_ZB);
		if (x.ca.i_section_1B <> i_section_ZB + 1) OR (x.tipo_oggetto <> LABEL_OBJ) OR NOT (x.tipo_variabile in VALIDATE_TIPI_VARIABILI) then continue;
		var vx : cl_validazione := x.aslabel.validazione;
		if NOT vx.bo_attivo then continue;
		if (bo_validate_pre_SQL <> vx.bo_pre_SQL) then continue;
		if (limita_context <> []) AND (vx.contexts_attivo * limita_context = []) then continue;

		case vx.tipo of
			VALID_FORMULA : begin
				if NOT interpreta_boolean_expression(vx.str_formula, {test}FALSE, bo, s) then
					raise exception.Create('Errore nella valutazione del controllo di validazione -- [' + get_name + ' - ' + x.get_name + ']' + ACAPO2 + s);
				if NOT bo then genera_errore(x, vx)
			end;
			VALID_ERROR_IF_BLANK, VALID_ERROR_IF_NOT_BLANK : begin
				s := x.aslabel.str_print;
				if (x.ca.tipo_valore = VAL_TESTO) then bo_blank := (s = '') else bo_blank := (s = '') OR (s = '0');
				if ((vx.tipo = VALID_ERROR_IF_NOT_BLANK) <> bo_blank) then genera_errore(x, vx)
			end
			{$ifdef DEBUG} ;else assert(FALSE, 'JHJR 4913') {$endif}
		end
	end
end;

function cl_sezione.load_SQL_values(var sections_values : cl_print_section;valid : cl_validation) : integer;
{ carica i valori per la sezione in oggetto sul'oggetto passato come parametro, dopo averlo allocato;
  restituisce il numero di records stampati; se la sezione non ha una query SQL, oppure se questa è vuota ma è stata specificata
  l'opzione BO_STAMPA_ANCHE_SE_VUOTA rende 1 perchè è come se avesse trovato un record;
  in caso di errore esegue un ABORT ed emette appropriati messaggi di avvertimento e di errore;
  se la sezione ha una query SQL, viene stampata solamente se nella query vi sono valori oppure se è selezionata l'opzione BO_STAMPA_ANCHE_SE_VUOTA;
  se la sezione non ha query SQL viene stampata comunque }
var str_last_group_value : string;

	function get_SQL_group_expression(i_obj : obj_index_type;sv : cl_print_section;bo_campo_vuoto : boolean) : boolean;
	{ determina il valore dell'espressione SQL contenuta nel campo e lo carica su SV;
	  l'espressione viene calcolata su un WHERE fornito dalla query attuale su un valore
	  della query nidificata ad un livello immediatamente più interno;
	  la funzione rende TRUE in caso di successo, FALSE altrimenti }
	const STR_EXPR_NAME = 'uqbar';	// nome convenzionale utilizzato per la formula; è irrilevante
	begin
		var qry : TFQuery := NIL;
		try
			var x : objs_type := xobjs(i_obj, i_logical_page_ZB + 1);
			var lab : cl_label := x.aslabel;
			if (x.ca.str_SQL_expression = '') then begin
				MessageBBox(GH, 'L''espressione SQL non può essere vuota', lab.Caption);
				abort
			end;
			var i_son_1B : section_index_type := get_first_son_1B;
			if (i_son_1B = 0) then begin
				MessageBBox(GH, 'L''espressione SQL dovendosi elaborare sulla sezione figlia, quest''ultima non può mancare', lab.Caption);
				abort
			end;

			// svolgo la query su una stringa
			sections_1B(i_son_1B).query_open(FALSE, FALSE, TRUE, TRUE);
			var s := uppercase(sections_1B(i_son_1B).qry.SQL.Text);
			// tolgo l'ORDER BY
			var j : smallint := pos('ORDER BY', s);if (j <> 0) then delete(s, j, MAXINT);

			// cerco la clausola FROM (e seguenti: WHERE)
			j := pos('FROM', s);
			if (j = 0) then begin
				MessageBBox(GH, 'La query della sezione figlia manca della clausola FROM', lab.Caption);
				abort
			end;
			s := copy(s, j, MAXINT);

			qry := TFQuery.create(NIL);
			qry.DatabaseName := sections_1B(i_son_1B).qry.DatabaseName;
//			qry.DatabaseName := globale.get_databasename;
			qry.SQL.add('SELECT ' + x.ca.str_SQL_expression + ' AS ' + STR_EXPR_NAME + ' ' + s);
//			if lab.bo_log_query_sql then Gdebug_SQL(qry, 'get_SQL_group_expression(' + lab.Caption + ')');
			if x.ca.bo_log_query_sql then Gdebug_SQL(qry, 'get_SQL_group_expression(' + x.get_name + ')');
			qry.Active := TRUE;
			var ff := qry.FindField(STR_EXPR_NAME);
			if (ff = NIL) then begin
//				MessageBBox(GH,'Impossibile trovare il campo <' + lab.str_SQL_expression + '>',lab.Caption);
				abort
			end;

			sv.new_record(i_obj, ff, NIL, bo_campo_vuoto);
			result := TRUE
		except
			error_msg(xobjs(i_obj, i_logical_page_ZB + 1).get_debug_caption + ACAPO +
				'errore durante la valutazione dell''espressione SQL' + ACAPO2 + qry.SQL.Text, MBOX_CAPTION);
			result := FALSE
		end;
		free_query(qry)
	end;

	function get_SQL_select_isolato(sv : cl_print_section;i_obj : obj_index_type;bo_campo_vuoto : boolean) : boolean;
	{ elabora una istruzione di select del tipo VAR_SQL_SELECT;
	  rende TRUE in caso di successo, FALSE altrimenti }
	begin
		try
			var x : objs_type := xobjs(i_obj, i_logical_page_ZB + 1);
			var lab : cl_label := x.aslabel;
			var str_caption := 'Oggetto <' + x.get_name + '>' +
				ifs(get_ultima_pagina_logica > 1, ' (page ' + inttostr(get_pagina_logica_attiva_1B) + ') ') + ': ';
			if (cqry = NIL) then cqry := TFQuery.create(NIL) else cqry.Active := FALSE;
			cqry.DatabaseName := self.qry.DatabaseName;

			var s := x.str_SQL_expression;
			try
				interpreta_string(s, {stampa_vera}TRUE, {check_errors}TRUE)
			except
				MessageBBox(GH, str_caption + 'errore durante l''elaborazione dell''oggetto', MBOX_CAPTION);
				raise
			end;
			if (s = '') then begin
				MessageBBox(GH, str_caption + 'nessun comando SQL', MBOX_CAPTION);
				abort
			end;
			cqry.SQL.Text := s;
			{$ifdef DEBUG} if is_key_down(VK_CONTROL) then messagebbox(GH, cqry.SQL.Text, get_name + ' - ' + x.get_name); {$endif}
			try
//				if lab.bo_log_query_sql then Gdebug_SQL(cqry,'get_SQL_isolato(' + x.get_name + ')');
				if x.ca.bo_log_query_sql then Gdebug_SQL(cqry, 'get_SQL_isolato(' + x.get_name + ')');
				cqry.Active := TRUE
			except
				error_msg(xobjs(i_obj, i_logical_page_ZB + 1).get_debug_caption + ACAPO +
					'errore durante la valutazione dell''espressione SQL' + ACAPO2 + cqry.SQL.Text,MBOX_CAPTION);
				abort
			end;

			if (cqry.fieldcount <> 1) then begin
				MessageBBox(GH,str_caption + 'il comando deve avere come risultato una ed una sola colonna', MBOX_CAPTION);
				abort
			end;

			bo_campo_vuoto := FALSE;	// ??
//			if qry.eof then bo_campo_vuoto := TRUE;
			// imposto il valore di stampa per le eventuali sottosezioni che volessero usare il valore
			lab.str_print := cqry.fields[0].AsString;

			var lp : LPSTR := NIL;
			{ 2014-08-13 la seguente assegnazione ha lo scopo di preservare il formato formattato del FLOAT, evitando così i problemi
			  di conversione causati dalle diverse modalità di specificazione dei separatori di migliaia e decimali }
			if (cqry.fields[0].datatype in [ftFloat, ftCurrency, ftFMTBcd]) then begin s := lab.str_print;lp := LPSTR(s) end;

			// archivio il valore (per la stampa!)
			sv.new_record(i_obj, cqry.fields[0], lp, bo_campo_vuoto);
			result := TRUE
		except
//			MessageBBox(GH,str_caption + 'errore durante la valutazione dell''espressione SQL', strpas(MBOX_CAPTION));
			result := FALSE
		end;
		cqry.Active := FALSE
	end;

	function tratta_obj(i_obj : obj_index_type;var sv : cl_print_section;bo_campo_vuoto : boolean) : boolean;
	{ esegue il trattamento dell'oggetto specificato;
	  bo_campo_vuoto è TRUE se si tratta di stampa senza dati;
	  rende TRUE se tutto OK, FALSE in caso di errore }
	var str_SQL_expression : string;

		function get_descrizione(lab : cl_label) : string;
		begin
			result := 'Sezione: <' + get_name + '>' +
				ifs(get_ultima_pagina_logica > 1,' (page ' + inttostr(get_pagina_logica_attiva_1B) + ') ') + ACAPO +
				'campo: <' + lab.Caption + '>' + ACAPO2 +
				'colonna: <' + str_SQL_expression + '>' + ACAPO2
		end;

	var
		lab : cl_label;
		{str_descrizione,} str_temp, str_RD_caption, str_time_format, str_datetime_format : string;
	begin
		result := TRUE;
		var fl_temp : double := 0;
		var obj : objs_type := xobjs(i_obj, i_logical_page_ZB + 1);
//		{$ifdef DEBUG} assert((obj.get_tipo = xVARIABILE) AND (obj.get_section = i_section), 'TRATTA_OBJ: obj errato KDJA 6599'); {$endif}
//		{$ifdef DEBUG} assert(obj.get_tipo = xVARIABILE, 'TRATTA_OBJ: obj errato KDJA 6598'); {$endif}
		{$ifdef DEBUG} assert(obj.ca.i_section_1B - 1 = i_section_ZB, 'TRATTA_OBJ: sezione errata KDJA 6599'); {$endif}
//		case lab.tipovar of
		case obj.tipo_variabile of
//			{$ifdef DEBUG} TV_BLANK : assert(FALSE,'tratta_obj() -- TV_BLANK -- JJEO 8210'); {$endif}
			TV_BLANK, TV_STATIC_TEXT, TV_FORMULA, TV_PARAMETRO, TV_SQL_SELECT_BEFORE_SQL, TV_SQL_SELECT_BEFORE_RUNTIME : begin
				sv.new_record(i_obj, NIL, NIL, FALSE);	// trattamento record 'solo pos & size'
{$ifdef DLL}
				// nothing to do here
 {$else}
//				strcpychks(lab.lp_print,lab.str_esempio_value)	// assegno il valore fornito come esempio
				lab := obj.aslabel;
//				lab.str_print := lab.str_esempio_value
				lab.str_print := obj.ca.str_esempio_value
{$endif DLL}
			end;
			TV_GROUP_EXPR_SQL: if NOT get_SQL_group_expression(i_obj, sv, bo_campo_vuoto) then abort;	// calcola il valore dell'espressione SQL
			TV_SQL_SELECT : if NOT get_SQL_select_isolato(sv, i_obj, bo_campo_vuoto) then abort;
			TV_DB_FIELD : begin
				lab := NIL;var dm : cl_datamatrix := NIL;
				case obj.tipo_oggetto of
					LABEL_OBJ : lab := obj.aslabel;
					DATAMATRIX_OBJ : dm := obj.asdatamatrix
					else begin
						{$ifdef DEBUG} assert(FALSE, 'tipo object non gestito -- KMPQ 39810'); {$endif}
						abort
					end
				end;
//				str_SQL_expression := coalesce(obj.ca.str_SQL_expression, lab.Caption);
				str_SQL_expression := obj.ca.str_SQL_expression;
				if (str_SQL_expression = '') then begin
					if (lab <> NIL) then str_SQL_expression := lab.Caption;
					if (dm <> NIL) then str_SQL_expression := dm.Name
				end;

				// cerco d'interpretare il campo
//				str_temp := '';interpreta_word(str_SQL_expression,TRUE,TRUE,str_temp);
				interpreta_string(str_SQL_expression, {stampa_vera}TRUE, {check_errors}TRUE);	// dal 2006-12-06
				if (lab <> NIL) then str_RD_caption := get_descrizione(lab);
				if (dm <> NIL) then str_RD_caption := dm.name;
				str_RD_caption := str_RD_caption + ' -- ';
				runtime_debug(str_RD_caption + 'colonna originale: <' + obj.str_SQL_expression + '>', 'Reading DB column', RD_DEBUG_ACCESSORIO_01);
//				str_SQL_expression := togliblanks(str_temp);
				str_SQL_expression := togliblanks(togli_ACAPO_finali(str_SQL_expression));
				var ff : TField := qry.FindField(str_SQL_expression);
				if (ff = NIL) then begin
					MessageBBox(GH, str_RD_caption + 'colonna non trovata nella query', MBOX_CAPTION, MB_ICONSTOP);
					abort
				end;
				var bo_somma_values := (lab <> NIL) AND lab.bo_valore_progressivo AND (obj.ca.tipo_valore = VAL_NUMERO);
				if bo_somma_values then
					if (sv.lo_record_number = 0) then fl_temp := 0
					else fl_temp := lab.xdbl_print_value;
				var lp : LPSTR := NIL;

//				lab.bo_null := ff.isnull;
				var bo_local_NULL := (lab <> NIL) AND ff.isNull;
				if (lab <> NIL) then lab.bo_null := bo_local_NULL;
//				if NOT lab.bo_null then begin
				if NOT bo_local_NULL then begin
					str_temp := '';

					if (lab = NIL) then begin str_time_format := '';str_datetime_format := '' end
					else begin str_time_format := lab.str_datetime_format;str_datetime_format := lab.str_datetime_format end;
					if (str_time_format = '') then str_time_format := coalesce(globale.str_default_time_format, SYSTEM_DEFAULT_TIME_FORMAT);
					if (str_datetime_format = '') then str_datetime_format := coalesce(globale.str_default_date_format, SYSTEM_DEFAULT_DATE_FORMAT);

					case ff.datatype of
						ftString, ftMemo, ftBlob{, ftBytes, ftVarBytes} : begin
							str_temp := ff.AsString;
							interpreta_string(str_temp, {stampa_vera}TRUE, {check_errors}FALSE)
						end;
						ftDate ,ftDateTime : begin
							fl_temp := ff.AsDateTime;
							if (fl_temp <> 0) then str_temp := FormatDateTime(str_datetime_format, fl_temp)
						end;
						ftTime : begin
							fl_temp := ff.AsDateTime;
							if (fl_temp <> 0) then str_temp := FormatDateTime(str_time_format, fl_temp)
						end;
						// next line aggiunta 2014-06-19 a causa di un errore di assegnazione dei floats in caso di valuta USD (con punto e virgola all'americana)
//						ftFloat, ftCurrency : str_temp := FloatToStr(ff.asfloat);
						// next line aggiunta 2014-06-19 per coerenza con punto precedente, anche se NON INDISPENSABILE (tutto funzionava anche senza)
//						ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint : str_temp := ff.AsString;
//						else
					end;
					if (str_temp <> '') then lp := @str_temp[1]	// assegno comunque: risparmio un .ASSTRING
				end;

{				if (lab.bo_null AND (lab.ca.tipo_valore = VAL_TESTO)) then begin		// i valori NUMERICI sono gestiti altrove (function APPLICA_FORMATO_NUMERICO)
					if (lab.comportamento_when_null = CWNT_REPORT_DEFAULT) then comportamento_when_null := globale.comportamento_when_null
					else comportamento_when_null := lab.comportamento_when_null;

					if (comportamento_when_null = xCWNT_USE_VALUE) then begin
						str_temp := '';
						if (lab.comportamento_when_null = xCWNT_USE_VALUE) then str_temp := lab.str_value_when_null;
						if (str_temp = '') then str_temp := globale.str_value_when_null_text;
						lp := @str_temp[1]
					end
				end; }

				if (lab <> NIL) AND lab.bo_null then begin		// bisognerebbe gestire anche DATAMATRIX
					var comportamento_when_null : comportamento_when_null_type;
					if (lab.comportamento_when_null = CWNT_REPORT_DEFAULT) then comportamento_when_null := globale.comportamento_when_null
					else comportamento_when_null := lab.comportamento_when_null;

					if (lab.ca.tipo_valore = VAL_NUMERO) then lab.xdbl_print_value := 0;	// comunque il valore numerico - ove applicabile - resta ZERO
					case comportamento_when_null of
						CWNT_STANDARD : ;
						xCWNT_USE_VALUE : begin
{							if (lab.ca.tipo_valore = VAL_TESTO) then begin
								str_temp := '';
								if (lab.comportamento_when_null = xCWNT_USE_VALUE) then str_temp := lab.str_value_when_null;
								if (str_temp = '') then str_temp := globale.str_value_when_null_text
							end
							else str_temp := coalesce(ifs(lab.comportamento_when_null = xCWNT_USE_VALUE, lab.str_value_when_null),
								globale.str_value_when_null_numeric); }

							if (lab.comportamento_when_null = xCWNT_USE_VALUE) then str_temp := lab.str_value_when_null else str_temp := '';
							if (str_temp = '') then
								str_temp := ifs(lab.ca.tipo_valore = VAL_TESTO, globale.str_value_when_null_text, globale.str_value_when_null_numeric);
{							// sostanzialmente equivalente, ma meno chiaro (e forse più lungo da computare)
							str_temp := coalesce(ifs(lab.comportamento_when_null = xCWNT_USE_VALUE, lab.str_value_when_null),
								ifs(lab.ca.tipo_valore = VAL_TESTO, globale.str_value_when_null_text, globale.str_value_when_null_numeric)); }

							lp := @str_temp[1]
						end
						else begin
//							str_temp := '';lp := @str_temp[1]	*** così fino 2020-05-22, ma si è messo a generare runtime errors 201
							str_temp := '';lp := LPSTR(str_temp)
						end
					end
				end;

//				if (lp = NIL) then lab.str_print := ff.AsString else lab.str_print := strpas(lp);
				if (lp = NIL) then begin
					if (lab <> NIL) then lab.str_print := ff.AsString;
					if (dm <> NIL) then dm.str_print := ff.AsString
				end
				else begin
					if (lab <> NIL) then lab.str_print := strpas(lp);
					if (dm <> NIL) then dm.str_print := strpas(lp)
				end;

				if (lab <> NIL) then begin	// bisognerebbe gestire anche DATAMATRIX
					if (uppercase(str_section_group_field) = uppercase(lab.Caption)) then begin
						{$ifdef DEBUG} assert(sv <> NIL, 'SV = NIL -- DHWE 8841'); {$endif}
						sv.bo_changed_group_field_value := (str_last_group_value <> lab.str_print);
						str_last_group_value := lab.str_print
					end
				end;

				if bo_somma_values then begin
{					lab.str_print := floattostr(strtofloat(check_decimal_format(str_temp)) +
//						strtofloat(check_decimal_format(lab.str_print)));
						lab.dbl_print_value); }
					fl_temp := fl_temp + lab.xdbl_print_value;
//					lab.dbl_print_value := fl_temp;
//					lab.str_print := float2SQL(fl_temp);
					lab.str_print := FloatToStr(fl_temp);
					str_temp := lab.str_print;lp := LPSTR(str_temp)
				end
				else begin
					{ 2014-06-19 la seguente assegnazione ha lo scopo di preservare il formato formattato del FLOAT, evitando così i problemi
					  di conversione causati dalle diverse modalità di specificazione dei separatori di migliaia e decimali }
//					if (ff.datatype in [ftFloat, ftCurrency]) then begin str_temp := lab.str_print;lp := LPSTR(str_temp) end
					if (ff.datatype in [ftFloat, ftCurrency, ftFMTBcd]) then begin
						if (lab <> NIL) then str_temp := lab.str_print;
						if (dm <> NIL) then str_temp := dm.str_print;
						lp := LPSTR(str_temp)
					end
				end;

				// ---- innovazione del 08/03/99 -----------
//				if (lab.tipo_valore = VAL_NUMERO)
//					then lab.applica_formato_numerico;	//  eseguo l'eventuale arrotondamento
				// --------------------
				runtime_debug(str_SQL_expression + ACAPO + '=' + ACAPO + ff.AsString + ACAPO +
					'bo_campo_vuoto=' + inttostr(byte(bo_campo_vuoto)),'interpreta_string()', RD_DEBUG_ACCESSORIO_01);
				sv.new_record(i_obj, ff, lp, bo_campo_vuoto)
			end
		end
	end;

	{$ifdef VARS}

		function loop_objs_variabili(tv : variabile_type;sv : cl_print_section;bo_campo_vuoto : boolean) : boolean;
		// carica i valori per gli oggetti specificati; rende TRUE se tutto OK, FALSE in caso di errore
		begin
			result := FALSE;
			if ww_stopped then abort;
			for var i : obj_index_type := 0 to high(vars[tv]) do begin
{				j := vars[tv,i];
				if (tv = TV_BLANK) then sv.new_record(j, NIL, NIL, FALSE)	// trattamento record 'solo pos & size'
				else if NOT tratta_obj(j, sv, bo_campo_vuoto) then exit }
				if NOT tratta_obj(vars[tv, i], sv, bo_campo_vuoto) then exit
			end;
			result := TRUE
		end;

	{$else VARS}

		function loop_objs_variabili(tipo_var : variabile_type;sv : cl_print_section;bo_campo_vuoto : boolean) : boolean;
		// carica i valori per gli oggetti specificati; rende TRUE se tutto OK, FALSE in caso di errore
		begin
			result := FALSE;
			if ww_stopped then abort;
			for var i : obj_index_type := 1 to i_objs do begin
				var obj : objs_type := xobjs(i, i_logical_page);
				if (obj.ca.i_section <> i_section) then continue;
				if (obj.get_tipo = VARIABILE) then begin
					if (obj.aslabel.tipovar <> tipo_var) then continue;
					if NOT tratta_obj(i, sv, bo_campo_vuoto) then exit
	//				if (lab.bo_store_variabile) then lab.store_value
				end
				else sv.new_record(i, NIL, NIL, FALSE)	// trattamento record 'solo pos & size'
			end;
			result := TRUE
		end;

	{$endif VARS}

	procedure assign_record_codice(sv : cl_print_section);
	// determina ed assegna il codice rappresentativo della sezione (STR_FIELD_CODICE_RECORD)
	begin
		if (str_field_codice_record = '') then exit;
		str_field_codice_record := uppercase(str_field_codice_record);
		for var i : obj_index_type := 1 to i_objs do begin
			var obj : objs_type := xobjs(i, i_logical_page_ZB + 1);
			if (obj.ca.i_section_1B = i_section_ZB + 1) AND (uppercase(obj.get_name) = str_field_codice_record) then begin
				var r : cl_print_campo := sv.recs;
				while (r <> NIL) AND (r.i_obj <> i) do r := r.next;
				if (r = NIL) then sv.str_value_codice_record := ''
				else sv.str_value_codice_record := strpas(r.lp_value);
				break
			end
		end
	end;

	function get_SQL_debug_key_value : string;
	begin
		result := '';
		if (str_SQL_PK_debug_field = '') then exit;
		if qry.Eof then begin result := '(EOF)';exit end;

		var ff : TField := qry.FindField(str_SQL_PK_debug_field);
		if (ff = NIL) then result := '(wrong SQL_debug_field: ' + str_SQL_PK_debug_field + ')'
		else begin
			result := 'L' + (i_section_ZB + 1).ToString + ':' + str_SQL_PK_debug_field + '=';		// metto anche un riferimento alla sezione (L1, L2, ...) per facilitare la ricerca nel debug-file
			if (ff.DataType in INTEGER_DATAFIELD_TYPES) then result := result + ff.AsString else
			if (ff.DataType in STRING_DATAFIELD_TYPES) then result := result + '<' + ff.AsString + '>' else
			if (ff.DataType in FLOAT_DATAFIELD_TYPES) then result := result + float2SQL(ff.asfloat) else
			if (ff.DataType in DATETIME_DATAFIELD_TYPES) then result := result + dttime2SQL(ff.AsDateTime, {inapicia}FALSE, TMFMT_HMS)
			else result := str_SQL_PK_debug_field + ': wrong data type'
		end
	end;

	function get_debug_record_ID(lo_row : integer;str_SQL_debug_key_value : string) : string;
	begin
		result := '[L' + (i_section_ZB + 1).Tostring + '][' + get_name + '] ' + zeri(lo_row, 4) + ifs(str_SQL_debug_key_value, ' -- ' + str_SQL_debug_key_value)
	end;

label fine;
var s, str_temp : string;	//*
begin		// load_SQL_values
	{$ifdef VARS} if NOT bo_vars_built then build_vars; {$endif}
	query_open(TRUE, i_section_ZB = MAIN_SECTION_ZB, TRUE, FALSE);
	var lo_row : integer := 0;var lo_rows_eliminate : integer := 0;
	var sv : cl_print_section := sections_values;
	var bo_no_SQL := (togliblanks(qry.SQL.Text) = '');		// TRUE se la sezione non ha comandi SQL
	if bo_dont_print_section then goto fine;
	var i_loop : smallint := 1;var i_record_loops : smallint := 0;
	var str_debug_caption := get_debug_record_ID(lo_row+1, get_SQL_debug_key_value);		// +1 perchè non ho ancora aggiornato LO_ROW
	runtime_debug('000 start', str_debug_caption, RD_DEBUG_ACCESSORIO_01);
	while NOT qry.Eof OR ((lo_row = 0) AND (bo_stampa_anche_se_vuota OR bo_no_SQL OR bo_senza_dati OR (i_loop <= i_record_loops))) do begin
		if ww_stopped then abort;
		if bo_senza_dati AND (lo_row > 0) then break;	// stampo solo il primo
		var bo_campo_vuoto := NOT bo_no_SQL AND (bo_senza_dati OR qry.Eof);	// if NO_SQL then considero che i dati ci siano
		inc(lo_row);
		runtime_debug('100 record start', str_debug_caption, RD_DEBUG_ACCESSORIO_01);
		if bo_conta_records then ww_read_record(str_record_descr_runtime);
		if (sv = NIL) then begin
			sections_values := cl_print_section.create(i_logical_page_ZB + 1, i_section_ZB + 1);
			sv := sections_values
		end
		else begin
			while (sv.next <> NIL) do sv := sv.next;
			sv.next := cl_print_section.create(i_logical_page_ZB + 1, i_section_ZB + 1);
			sv := sv.next
		end;
		sv.lo_record_number := lo_row-1;
		sv.str_PK_debug_key := get_SQL_debug_key_value;
		if bo_conta_records then begin
//			sv.xlo_total_record_number := globale.xlo_total_record_number;
			sv.lo_LP_record_number := get_total_record_number(i_logical_page_ZB + 1);
			set_total_record_number(sv.lo_LP_record_number + 1, i_logical_page_ZB + 1)
		end;

		// faccio caricare il valore degli oggetti; l'ordine è importante
		// obbligo a ricalcolare i valori delle formule -- 2004-10-02
		for var i : obj_index_type := 1 to i_objs do begin
			var x : objs_type := xobjs(i, i_logical_page_ZB + 1);
//			if (get_section = i_section) AND (get_tipo = FORMULA) {AND (aslabel.tipovar <> TV_VARIABILE)}		*** fino 2011-05-09
//			if (x.get_section = i_section) AND (x.tipo_variabile in FORMULA_OBJS) {AND (aslabel.tipovar <> TV_VARIABILE)}
			if (x.ca.i_section_1B = i_section_ZB + 1) AND (x.tipo_variabile = TV_FORMULA)
//				then aslabel.reset_print_value;		*** fino 2011-05-09
				then x.reset_print_value
		end;

		validate_objects(valid, sv, {pre_SQL}TRUE);

		if NOT loop_objs_variabili(TV_PARAMETRO, sv, bo_campo_vuoto) then abort;
		if (i_section_ZB = MAIN_SECTION_ZB) then begin	// dal 2006-09-02
			if NOT loop_objs_variabili(TV_SQL_SELECT_BEFORE_RUNTIME, sv, bo_campo_vuoto) then abort;
			if NOT loop_objs_variabili(TV_SQL_SELECT_BEFORE_SQL, sv, bo_campo_vuoto) then abort
		end;
		if NOT loop_objs_variabili(TV_DB_FIELD, sv, bo_campo_vuoto) then abort;
		if NOT loop_objs_variabili(TV_GROUP_EXPR_SQL, sv, bo_campo_vuoto) then abort;
		if NOT loop_objs_variabili(TV_STATIC_TEXT, sv, bo_campo_vuoto) then abort;
		if NOT loop_objs_variabili(TV_FORMULA, sv, bo_campo_vuoto) then abort;
		{$ifdef VARS} if NOT loop_objs_variabili(TV_BLANK, sv, bo_campo_vuoto) then abort; {$endif}		// oggetti grafici

		s := togliblanks(togli_ACAPO_finali(tsql_scripts.Text));
		if (s <> '') then try
			// aggiunta del 2001-04-23 ---------------------
			// se vi sono delle stored procedures elimino tutti i valori di stampa delle formule, per costringere a ricalcolarli
(*			for i := 1 to i_objs do with objs(i) do begin
				if (get_section = i_section) AND (get_tipo = FORMULA) {AND (aslabel.tipovar <> TV_VARIABILE)}
					then aslabel.reset_print_value
			end; *)
			// ------ fine aggiunta ------------------------

			interpreta_string(s, {stampa_vera}TRUE, {check_errors}FALSE);
			runtime_debug(s, str_debug_caption, RD_DEBUG_ACCESSORIO_01);
			// verifico se si tratta di una stored procedure
			case exec_stored_proc(qry.DatabaseName, s, str_temp, FALSE, TRUE) of
				-1 : raise exception.create(str_temp);	// stored procedure con errore; l'errore viene caricato su STR_RESULT
				1 : ;	// SP eseguita senza problemi
				0 : begin		// non è una SP
//					interpreta_string(s,TRUE,FALSE);
					exec_SQL(NIL, s)
				end
			end
		except
			error_msg('Errore durante l''esecuzione dell''SQL section script' + ACAPO2 + s, 'Galateo: ' + globale.str_filename);
			raise
		end;

		if NOT loop_objs_variabili(TV_SQL_SELECT, sv, bo_campo_vuoto) then abort;

		if (str_field_codice_record <> '') then assign_record_codice(sv);

		if (i_section_ZB = MAIN_SECTION_ZB) then begin		// 2014-09-01
			s := globale.str_export_filename;
			interpreta_string(s, {stampa_vera}TRUE, {check_errors}FALSE);
			sv.str_runtime_filename := s
		end;

		tratta_XML(sv);		// tratta i valori XML del record corrente

		validate_objects(valid, sv, {pre_SQL}FALSE);

		// faccio leggere i valori alle subsections
		if (get_first_son_1B <> 0) then begin
			var lo_subq_records : integer := 0;
			for var i : section_index_type := 0 to get_num_sections -1 do begin
				if is_son_ZB(i) then begin
					var sz : cl_sezione := sections_ZB(i);
					for var i_profilo : expint_index_type := 0 to high(globale.expint_profiles) do sz.str_XML_elaborato[i_profilo] := '';
					inc(lo_subq_records, sz.load_SQL_values(sv.next, valid))
				end
			end;
			if bo_print_only_if_subsection_has_records AND (lo_subq_records = 0) then begin
				delete_print_section_record(sections_values, sv.lo_id {$ifdef DEBUG}, i_section_ZB + 1{$endif});
				sv := sections_values;
				if (sv <> NIL) then while (sv.next <> NIL) do sv := sv.next;
				inc(lo_rows_eliminate)			// annullo la riga generata per la sezione
			end;

			for var i_profilo : expint_index_type := 0 to high(globale.expint_profiles) do begin
				if NOT XML_attivo(i_profilo) then continue;
				if (pos(XML_SOTTOSEZIONE, uppercase(str_XML_elaborato[i_profilo])) <> 0) then begin
//					Gdebug_SQL('***sostituzione XML***, str_debug_caption, TRUE);
					runtime_debug('120 sostituzione XML', str_debug_caption, RD_DEBUG_ACCESSORIO_01);
					for var i : section_index_type := 0 to get_num_sections - 1 do begin
						if is_son_ZB(i) then begin
							sostituisci(str_XML_elaborato[i_profilo], XML_SOTTOSEZIONE, sections_ZB(i).str_XML_elaborato[i_profilo], {ignore_case}TRUE);
							break
						end
					end
				end
			end
		end;
		for var i_profilo : expint_index_type := 0 to high(globale.expint_profiles) do
			if XML_attivo(i_profilo) then append_ACAPO(str_XML_elaborato[i_profilo], XML_commento({start}FALSE));

		if (i_loop = 1) AND (globale.tiporeport in LABEL_TYPES) then begin	// valuto il numero di etichette da stampare
			s := get_numero_etichette_object;
			if (s = '') then i_record_loops := get_numero_etichette_const
			else begin
				s := '$' + s;
				interpreta_string(s, {stampa_vera}TRUE, {check_errors}TRUE);
				i_record_loops := strtoint(s)
			end
		end;

		if (i_loop >= i_record_loops) then begin
			if qry.Active then begin
				if NOT get_logical_page_ZB(i_logical_page_ZB).bo_exclude_debug then Gdebug_SQL('***before next***', str_debug_caption, TRUE);
				runtime_debug('190 before next rec', str_debug_caption, RD_DEBUG_ACCESSORIO_01);
				qry.Next;
				str_debug_caption := get_debug_record_ID(lo_row + 1, get_SQL_debug_key_value);		// +1 perchè LO_ROW non è ancora stato incrementato
				if NOT get_logical_page_ZB(i_logical_page_ZB).bo_exclude_debug then Gdebug_SQL('200 new rec', str_debug_caption, TRUE)
			end;
			i_loop := 1;i_record_loops := 0
		end
		else inc(i_loop)
	end;
	runtime_debug('900 after query', str_debug_caption, RD_DEBUG_ACCESSORIO_01);
fine:
	query_close;
	result := lo_row - lo_rows_eliminate;
	runtime_debug('999 end of section', str_debug_caption, RD_DEBUG_ACCESSORIO_01)
end;

{$endif CASA}

{$ifdef GALATEO_EXE}
	procedure cl_sezione.open_database_fields;
	begin
		if (w_fields = NIL) then w_fields := Tw_fields.xcreate_ZB(GM, i_section_ZB)
		else w_fields.SetFocus
	end;
{$endif GALATEO_EXE}

{$ifdef CASA}
procedure cl_sezione.prepare2print;
// carica su PRINT_OBJS ordinati per posizione verticale tutti gli oggetti appartenenti alla sezione
begin
	print_objs.reset;
	for var i_obj : obj_index_type := 1 to i_objs do
		if (xobjs(i_obj, i_logical_page_ZB + 1).ca.i_section_1B = i_section_ZB + 1) then print_objs.add_object(i_obj);
//	for var i_sec_1B : section_index_type := 1 to get_num_sections do if is_son_1B(i_sec_1B) then print_objs.add_object(-i_sec_1B);
	for var i_sec_ZB : section_index_type := 0 to get_num_sections - 1 do if is_son_ZB(i_sec_ZB) then print_objs.add_object(-(i_sec_ZB + 1));
	print_objs.sort
end;
{$endif CASA}

procedure cl_sezione.query_close;
begin
	qry.Active := FALSE
end;

procedure cl_sezione.query_open(bo_open_ancestors, bo_accept_blank, bo_stampa_vera, bo_prepara_only : boolean);
{ apre la query della sezione; emette opportuni messaggi di errore e raisa
  una interruzione in caso di errore;
  if (BO_OPEN_ANCESTORS) verifica che le ancestor queries della query da aprire
  siano aperte; se non lo sono le fa aprire;
  if BO_ACCEPT_BLANK viene consentita una query vuota;
  if BO_PREPARA_ONLY then la query viene solo preparata, e non aperta }
begin
	if qry.Active then exit;
//	qry.DatabaseName := globale.get_databasename;
	if bo_stampa_vera then qry.DatabaseName := globale.get_databasename
//	else if (globale.str_db_driveralias = '') then qry.DatabaseName := '' else qry.DatabaseName := DB_GALATEO_NAME;
	else qry.DatabaseName := DB_GALATEO_NAME;
//	messageBBox(0,qry.DatabaseName + ACAPO + ifs(globale.db_report.InTransaction,'ATTIVO','non attivo'),get_name);

//	if bo_open_ancestors AND (i_section_1B <> MAIN_SECTION) AND (i_father_1B <> 0)
	if bo_open_ancestors AND (i_section_ZB <> MAIN_SECTION_ZB) AND (i_father_ZB <> -1)
//		then sections_ZB(i_father_1B - 1).query_open(TRUE, bo_accept_blank OR (i_father_1B = MAIN_SECTION), bo_stampa_vera, bo_prepara_only);
		then sections_ZB(i_father_ZB).query_open(TRUE, bo_accept_blank OR (i_father_ZB = MAIN_SECTION_ZB), bo_stampa_vera, bo_prepara_only);
	qry.SQL.Assign(tsql_command);
	qry.SQL.Text := translate_local_macros(qry.SQL.Text);
	interpreta_tstring(qry.SQL, bo_stampa_vera);
	if (TStrings_total_length(qry.SQL, 0) = 0) then begin
		if bo_accept_blank then exit;
		MessageBBox(GH, 'Sezione <' + get_name + '> : nessun comando SQL', MBOX_CAPTION);
		abort
	end;
	if (str_SQL_export_DBF_store <> '') then begin
		str_SQL_export_DBF_exec := translate_local_macros(str_SQL_export_DBF_store);	// dal 2005-09-15
		interpreta_string(str_SQL_export_DBF_exec, bo_stampa_vera, {check_errors}FALSE{???})
	end;

//	if (is_key_down(VK_CONTROL)) then MessageBBox(GH,qry.*Text,get_name);
	if is_key_down(VK_CONTROL) then error_msg(qry.SQL.Text, get_name, TRUE, MB_OK);
	try
		if NOT get_logical_page_ZB(i_logical_page_ZB).bo_exclude_debug then Gdebug_SQL(qry, 'query_open(' + get_name + ')');
		qry.Active := TRUE;
		runtime_debug('', get_name + ': query opened', RD_DEBUG_ACCESSORIO_01)
	except
		error_msg('Sezione <' + get_name + '>' +
			ifs(get_ultima_pagina_logica > 1,' (page ' + get_pagina_logica_attiva_1B.ToString + ')') +
			' : errore durante l''esecuzione del comando SQL' + ACAPO2 + qry.SQL.Text, MBOX_CAPTION);
		abort
	end
end;

procedure cl_sezione.read(var f : system.Text;wo_versione : word);
var
	c : char;
	j : smallint;
	i_section_objs, i_obj_read : obj_index_type;
	exs : cl_expint_section;	//*
begin
	try
		runtime_debug('100','cl_sezione.read()', RD_DEBUG_ACCESSORIO_01);
		if (wo_versione <= $0303) then exs := get_expint_section(0) else exs := NIL;
		readln(f, str_nome);
		if (i_section_ZB = MAIN_SECTION_ZB) then readln(f)
		else begin
			readln(f, i_father_ZB, r_y0_rel_cm, r_y_sezione_cm, r_y_gruppo_cm);
			dec(i_father_ZB)		// il valore è scritto 1-based
		end;
		bo_dont_break_fields := FALSE;bo_dont_break_subsections := FALSE;
		bo_del_blanks := FALSE;bo_fill_tutto := FALSE;
		bo_reprint_broken_sections := (i_section_ZB = MAIN_SECTION_ZB);	// sempre TRUE if MAIN_SECTION
		bo_dont_print_section := FALSE;bo_conta_records := FALSE;
		bo_print_only_if_subsection_has_records := FALSE;
		bo_draw_line_bottom := FALSE;bo_draw_rect := FALSE;bo_draw_last_line := FALSE;
		bo_exportable_DBF := TRUE;bo_double_thickness := FALSE;
		if (exs <> NIL) then exs.bo_headers_colonne := TRUE;  // default
//		bo_autosize := (i_section_1B in [MAIN_SECTION, MAIN_SECTION + 1]);
		bo_autosize := (i_section_ZB in [MAIN_SECTION_ZB, MAIN_SECTION_ZB + 1]);

		str_SQL := '';str_SQL_filename := '';
		bo_read_from_file := FALSE;bo_save_to_file := FALSE;

//		runtime_debug('110','cl_sezione.read()',FALSE);
		while NOT EoLn(f) do begin
			system.read(f, c);
			case c of
				'A' : bo_dont_break_fields := TRUE;
				'B' : bo_del_blanks := TRUE;
				'C' : bo_fill_tutto := TRUE;
				'D' : bo_dont_print_section := TRUE;
				'E' : bo_dont_break_subsections := TRUE;
				'F' : bo_reprint_broken_sections := TRUE;
				'G' : bo_conta_records := TRUE;
				'H' : bo_draw_line_bottom := TRUE;
				'I' : bo_draw_rect := TRUE;
				'J' : bo_draw_last_line := TRUE;
				'R' : bo_autosize := FALSE;
				'X' : bo_exportable_DBF := FALSE;
				'Y' : bo_print_only_if_subsection_has_records := TRUE;
				'Z' : bo_double_thickness := TRUE;
				'h' : if (exs <> NIL) then exs.bo_headers_colonne := FALSE;
				'r' : bo_read_from_file := TRUE;
				'w' : bo_save_to_file := TRUE;
				else if NOT accept_future_versions then abort
			end
		end;
		readln(f);
		Tstrings_load(f, tsql_command);
		if (wo_versione >= $0407) then readln(f, str_SQL_filename);
		if bo_read_from_file AND (str_SQL_filename <> '') then begin
			var s : string;
			var str_filename := get_SQL_save_executive_filename;
			if NOT read_textfile(str_filename, s) then raise exception.create('Impossibile leggere file ' + str_filename);
			{$ifdef CASA} s := clear_SQL_save_command_text(s); {$endif}		// se NOT galateo tolgo le righe di commento che in esecuzione possono creare guai
			tsql_command.Text := s
		end;
//		runtime_debug('120','cl_sezione.read()',FALSE);

//		if (i_section_1B <> MAIN_SECTION) then set_father_1B(i_father_1B);	// after la lettura degli attributi, please
		if (i_section_ZB <> MAIN_SECTION_ZB) then set_father_ZB(i_father_ZB);	// after la lettura degli attributi, please

		if NOT eoln(f) then begin system.read(f, j);bo_stampa_anche_se_vuota := boolean(j) end;
		if NOT eoln(f) then begin system.read(f, j);bo_senza_dati := boolean(j) end;
		readln(f);
		if NOT read_font(f, font_default) then abort;
		readln(f, str_record_descr_runtime);
		Tstrings_load(f, tsql_scripts);
		readln(f, str_obj_line_bottom_pos_and_width);
		readln_LPSTR(f, str_SQL_start_record);
		sostituisci(str_SQL_start_record, #255, ACAPO);	// per una differente modalità di archiviazione passata

		runtime_debug('130','cl_sezione.read()', RD_DEBUG_ACCESSORIO_01);
		readln(f, str_field_codice_record);
		readln_LPSTR(f, str_SQL_export_DBF_store);
		readln(f, str_export_filename_DBF);
		if eoln(f) then readln(f) else readln(f, r_minimum_required_space_cm);
		if (wo_versione <= $0303) then begin
			if (wo_versione > $0245) then begin
				readln(f, byte(exs.expint_mode), byte(exs.expint_objs_default_mode), exs.i_shift_columns, exs.str_sigla);
				if (byte(exs.expint_mode) > 0) then dec(exs.expint_mode);		// 2014-08-25 -- è stato eliminato il primo valore -- expint_mode(0)
				exs.str_sigla := togliblanks(exs.str_sigla);
				if (wo_versione > $0249) then readln(f, byte(exs.bo_skip_on_continuazione))
			end
			else begin
				readln(f);readln(f);
				exs.expint_mode := SEXP_YES;
				exs.expint_objs_default_mode := OEXP_DEFAULT;
				exs.i_shift_columns := 0;exs.str_sigla := '';exs.bo_skip_on_continuazione := TRUE
			end
		end;
		readln(f, str_section_group_field);
		readln(f, str_SQL_PK_debug_field);
		readln(f);
{		if (wo_versione > $0312) then begin
			readln(f, byte(bo_XML_allowed_phisical), str_condizione_export_XML);
			str_condizione_export_XML := togliblanks(str_condizione_export_XML)
		end
		else readln(f);
		readln_LPSTR(f, str_struttura_XML);
		str_struttura_XML := togli_ACAPO_init_fine(str_struttura_XML); }

		if (wo_versione >= $0404) then begin		// COLONNE_COLORATE: 2021-03-13 -- versione $0404
			readln(f, j);		// numero di colonne trattate
			SetLength(colonne_colorate, j);
			for j := 0 to j-1 do begin
				colonne_colorate[j] := cl_colonna_colorata.create;
				if NOT colonne_colorate[j].read(f, wo_versione) then raise exception.create('Errore durante la lettura delle COLONNE COLORATE')
			end
		end;

		if (wo_versione > $241) then for j := 1 to 12 do readln(f);		// righe di libertà aggiunte il 2006-03-15
//		if globale.bo_report OR (i_section <> MAIN_SECTION) then begin	// la MAIN SECTION delle labels carica i suoi oggetti a parte
		if (globale.tiporeport in REPORT_TYPES) OR (i_section_ZB <> MAIN_SECTION_ZB) then begin	// la MAIN SECTION delle labels carica i suoi oggetti a parte
			readln(f, i_section_objs);
			for var i : obj_index_type := 1 to i_section_objs do begin
				i_obj_read := read_object_ZB(f, i_objs + i, i_logical_page_ZB, i_section_ZB, wo_versione);
				runtime_debug('after read obj: ' + xobjs(i_obj_read, i_logical_page_ZB + 1).get_name,'cl_sezione.load()', RD_DEBUG_ACCESSORIO_01)
			end;
			set_num_objs(i_objs + i_section_objs)
		end;
		runtime_debug('990', 'cl_sezione.read()', RD_DEBUG_ACCESSORIO_01)
	except
		error_msg('Errore durante la lettura del file', MBOX_CAPTION);
		abort
	end;

	if (i_section_ZB = MAIN_SECTION_ZB) then r_y_gruppo_cm := r_y_sezione_cm	// per garanzia
end;

procedure cl_sezione.set_default_name;
{ rende il nome default per la sezione, in funzione del suo ruolo e del suo
  livello gerarchico; il nome non deve contenere spazi nè iniziare con una cifra }
begin
	case i_section_ZB of
		MAIN_SECTION_ZB : str_nome := 'Principale';
		MAIN_SECTION_ZB + 1 : str_nome := 'Dettaglio';
		else str_nome := 'GB_'+ (i_section_ZB - 1).ToString
	end;
	if (get_pagina_logica_attiva_1B <> 1) then str_nome := str_nome + '_' + get_pagina_logica_attiva_1B.ToString
end;

procedure cl_sezione.set_father_ZB(i_father_ZB : section_index_type);
{ assegna al pannello il legittimo parent; I_FATHER è l'indice del pannello che va a fare da parent al pannello presente;
  se I_FATHER=-1 il panel torna di proprietà di CONTROLLO.SBOX (parent del pannello principale) e viene nascosto }
begin
	{$ifdef GALATEO_EXE} panels_ZB(i_section_ZB).set_father_ZB(i_father_ZB); {$endif}		// if DLL: 2009-06-14
	self.i_father_ZB := i_father_ZB;
	if (i_section_ZB = MAIN_SECTION_ZB) {OR (i_father_ZB <> MAIN_SECTION_ZB)} then begin
		{ secondo quanto riportato dalla condizione commentata (i_father <> MAIN_SECTION) le sottosezioni dal
		  terzo livello in giù dovrebbero avere sempre l'opzione 'OCCUPA SEMPRE TUTTA LA SEZIONE';
		  non capisco perchè una sub-sub-section debba sempre occupare tutto lo spazio, e perciò commento (2006-09-10) }
		bo_fill_tutto := TRUE
	end
end;

{$ifdef GALATEO_EXE}

	procedure cl_sezione.set_panel_values;
	begin
		var p : TGalPanel := panels_ZB(i_section_ZB);
//		{$ifdef DEBUG} p.caption := 'PANEL #' + i_section_ZB.ToString; {$endif}
//		with panels(i_section_1B) do begin
			if (i_section_ZB = MAIN_SECTION_ZB) then begin
				p.BorderStyle := bsSingle;
				p.Left := BORDO_DISEGNO_X_PIXEL  - GM.sbox.horzscrollbar.Position;
				p.Top := BORDO_DISEGNO_Y_PIXEL - GM.sbox.vertscrollbar.Position
			end
			else begin
				p.BorderStyle := bsNone;
				p.Top := cm2pixel_video_y(r_y0_rel_cm);	// posizione relativa al padre
				p.Left := 0
			end;

	//		if (globale.tiporeport in LABEL_TYPES) then p.Width := i_label_size_X_pix_video else p.Width := i_page_size_X_pix_video(get_pagina_logica_attiva);
			p.Width := i_Vpage_size_X_pix_video(get_pagina_logica_attiva_1B);

			if (i_section_ZB = MAIN_SECTION_ZB) then begin
	//			if (globale.tiporeport in LABEL_TYPES) then p.Height := i_label_size_Y_pix_video else p.Height := i_page_size_Y_pix_video(get_pagina_logica_attiva)
				p.Height := i_Vpage_size_Y_pix_video(get_pagina_logica_attiva_1B)
			end
			else p.Height := cm2pixel_video_y(r_y_sezione_cm);
			p.xresize(FALSE)
//		end
	end;

	procedure cl_sezione.write(var f : system.Text);
	var i : smallint;
	begin
		writeln(f, str_nome);
//		writeln(f, i_father_1B, ' ', r_y0_rel_cm:0:4, ' ', r_y_sezione_cm:0:4, ' ', r_y_gruppo_cm:0:4);
		writeln(f, i_father_ZB + 1, ' ', r_y0_rel_cm:0:4, ' ', r_y_sezione_cm:0:4, ' ', r_y_gruppo_cm:0:4);
		if bo_dont_break_fields then system.write(f, 'A');
		if bo_del_blanks then system.write(f, 'B');
		if bo_fill_tutto then system.write(f, 'C');
		if bo_dont_print_section then system.write(f, 'D');
		if bo_dont_break_subsections then system.write(f, 'E');
		if bo_reprint_broken_sections then system.write(f, 'F');
		if bo_conta_records then system.write(f, 'G');
		if bo_draw_line_bottom then system.write(f, 'H');
		if bo_draw_rect then system.write(f, 'I');
		if bo_draw_last_line then system.write(f, 'J');
		if bo_read_from_file then system.write(f, 'r');
		if bo_save_to_file then system.write(f, 'w');
//		if (i_section_1B in [MAIN_SECTION, MAIN_SECTION+1]) AND NOT bo_autosize then system.write(f, 'R');
		if (i_section_ZB in [MAIN_SECTION_ZB, MAIN_SECTION_ZB + 1]) AND NOT bo_autosize then system.write(f, 'R');
		if NOT bo_exportable_DBF then system.write(f, 'X');
		if bo_print_only_if_subsection_has_records then system.write(f, 'Y');
		if bo_double_thickness then system.write(f, 'Z');
//		if NOT bo_headers_colonne then system.write(f, 'h');
		writeln(f);
		Tstrings_save(f, tsql_command);
		writeln(f, str_SQL_filename);		// dalla versione  versione 0407
		if bo_save_to_file AND (str_SQL_filename <> '') then write_textfile(get_SQL_save_executive_filename, get_SQL_save_command_text(tsql_command.Text));
		writeln(f, byte(bo_stampa_anche_se_vuota), ' ', byte(bo_senza_dati));
		if NOT write_font(f, font_default) then abort;
		writeln(f, str_record_descr_runtime);
		Tstrings_save(f, tsql_scripts);
		writeln(f, str_obj_line_bottom_pos_and_width);
		writeln_LPSTR(f, str_SQL_start_record);

		writeln(f, str_field_codice_record);
		writeln_LPSTR(f, str_SQL_export_DBF_store);
		writeln(f, str_export_filename_DBF);
		writeln(f, r_minimum_required_space_cm:0:4, ' 0 0 0 0 0 0 0 0 0 0');	// gli zeri sono per facilitare future estensioni del formato
//		writeln(f, byte(export_type), byte(export_type_fields_default):2, ' ', i_shift_columns, ' ', str_integral_export_ID);
//		writeln(f, byte(bo_skip_on_continuazione),' 0 0 0 0 0 0 0 0 0 0');
		writeln(f, str_section_group_field);
		writeln(f, str_SQL_PK_debug_field);

//		writeln(f, byte(bo_XML_allowed_phisical), ' ', str_condizione_export_XML);
//		writeln_LPSTR(f, str_struttura_XML);
		writeln(f);

		// COLONNE_COLORATE: 2021-03-13 -- versione $0404
		writeln(f, length(colonne_colorate), ' 0 0 0 0');		// scrivo il numero di colonne trattate
		for i := 0 to high(colonne_colorate) do colonne_colorate[i].write(f, i);

		for i := 1 to 12 do writeln(f);			// free for future implementations

//		if globale.bo_report OR (i_section <> MAIN_SECTION) then begin	// la MAIN SECTION delle labels carica i suoi oggetti a parte
		if (globale.tiporeport in REPORT_TYPES) OR (i_section_ZB <> MAIN_SECTION_ZB) then begin	// la MAIN SECTION delle labels carica i suoi oggetti a parte
			var i_section_objs : smallint := 0;
			for i := 1 to i_objs do
				if (xobjs(i, i_logical_page_ZB + 1).ca.i_section_1B = i_section_ZB + 1) then inc(i_section_objs);
			writeln(f, i_section_objs);
			i := 0;
			while (i_section_objs > 0) do begin
				inc(i);
				if (xobjs(i, i_logical_page_ZB + 1).ca.i_section_1B = i_section_ZB + 1) then begin
					write_object(f, i);dec(i_section_objs)
				end
			end
		end
	end;	

{$endif GALATEO_EXE}

function cl_sezione.get_name(bo_specifica_pagina_logica : boolean = FALSE) : string;
begin
	if (str_nome = '') then set_default_name;
	result := str_nome;
	if bo_specifica_pagina_logica AND (globale.i_pagine_logiche > 1)
//		then result := result + ' [pagina ' + inttostr(get_pagina_logica_attiva_1B) + ']'
		then with get_logical_page_ZB(i_logical_page_ZB) do
			result := result + ' [' + coalesce(str_page_ID, get_descrizione(TRUE)) + ']'
end;

const GSZ_HEADER_ID = '-- ##REM## ';		// ID per righe di commento salvataggio comando SQL sezioni

function cl_sezione.clear_SQL_save_command_text(str_SQL : string) : string;
// pulisce il comando SQL della sezione dalle righe di commento aggiunte in fase di salvataggio
begin
	while (str_SQL <> '') do begin
		var s := get_line(str_SQL, {delete}FALSE);
		if (s <> '') AND (pos(GSZ_HEADER_ID, s) = 0) then break;
		get_line(str_SQL, {delete}TRUE)
	end;
	result := str_SQL
end;

{$ifdef GALATEO_EXE}
function cl_sezione.get_SQL_save_command_text(str_SQL : string) : string;
// serve per il salvataggio su files esterni condivisi dei comandi SQL; gestisce le righe di intestazione
begin
	result := GSZ_HEADER_ID + ' ' + globale.str_filename + ' - ' + now.SQL(TMFMT_HMS OR TMTF_SENZA_APICI) + ACAPO2 + clear_SQL_save_command_text(str_SQL)
end;
{$endif GALATEO_EXE}

function cl_sezione.get_SQL_save_executive_filename : string;
begin
	result := str_SQL_filename;
	if (str_SQL_filename <> '') then
		if filename_has_explicit_path(str_SQL_filename) then result := str_SQL_filename
		else result := make_filename(str_SQL_filename, ExtractFilePath(globale.str_filename), {sostituisci_path}TRUE)
end;

// --- PROCEDURES di utilità ---------------------------------------------------

procedure read_section_ZB(var f : system.Text;i_logical_page_ZB : logical_page_type;i_section_ZB : section_index_type;wo_versione : word);
begin
	if (sections_ZB(i_section_ZB) = NIL) then
		assign_section_ZB(i_section_ZB, cl_sezione.create_ZB(i_section_ZB, -1, i_logical_page_ZB));	// il father viene letto dal file
	sections_ZB(i_section_ZB).read(f, wo_versione);
	{$ifdef GALATEO_EXE}panels_ZB(i_section_ZB).Visible := TRUE{$endif}
end;	

procedure set_main_section_values;
// imposta i valori per la sezione 'etichetta'
begin
	with sections_ZB(MAIN_SECTION_ZB) do begin
		r_y0_rel_cm := 0;
		r_y_sezione_cm := get_Vpage_size_Y_cm(get_pagina_logica_attiva_1B);
		r_y_gruppo_cm := r_y_sezione_cm;
		r_minimum_required_space_cm := 0;
		bo_fill_tutto := TRUE;
		{$ifndef DLL} set_panel_values {$endif}
	end
end;

{$ifdef GALATEO_EXE}

	procedure write_section_ZB(var f : system.Text;i_section_ZB : section_index_type);
	begin
		sections_ZB(i_section_ZB).write(f)
	end;

	procedure change_section_number_ZB(i_from_ZB, i_to_ZB : section_index_type);
	{ cambia il numero di sezione alla sezione i_from_1B e lo trasforma in i_to_1B;
	  la sezione che viene cambiata deve essere referenziata come sections(i_to_1B] }
	begin
//		xassign_section(i_to_1B, sections_1B(i_from_1B));
		assign_section_ZB(i_to_ZB, sections_ZB(i_from_ZB));
//		xassign_section(i_from_1B, NIL);
		assign_section_ZB(i_from_ZB, NIL);
//		sections_1B(i_to_1B).i_section_1B := i_to_1B;
		sections_ZB(i_to_ZB).i_section_ZB := i_to_ZB;

		// poichè i panels sono allocati sempre tutti, scambio i due panels
		var panel_temp : TGalPanel := panels_ZB(i_to_ZB);
		assign_panel_ZB(i_to_ZB, panels_ZB(i_from_ZB));
		assign_panel_ZB(i_from_ZB, panel_temp);
		panels_ZB(i_to_ZB).i_panel_1B := i_to_ZB + 1;

//		for i := 1 to i_objs do if (xobjs(i).ca.i_section = i_from_1B) then xobjs(i).set_section(i_to_1B);
		for var i_1B : smallint := 1 to i_objs do if (xobjs(i_1B).ca.i_section_1B = i_from_ZB + 1) then xobjs(i_1B).ca.i_section_1B := i_to_ZB + 1;
{		for i := 1 to get_num_sections do
			if (sections_1B(i) <> NIL) AND (sections_1B(i).xi_father_1B = i_from_1B) then begin
				sections_1B(i).xi_father_1B := i_to_1B;
				sections_1B(i).i_father_ZB := i_to_1B - 1
			end }
		for var i_ZB : smallint := 0 to get_num_sections-1 do
			if (sections_ZB(i_ZB) <> NIL) AND (sections_ZB(i_ZB).i_father_ZB = i_from_ZB) then
				sections_ZB(i_ZB).i_father_ZB := i_to_ZB
	end;

	procedure add_section;
	begin
//		assign_section(get_num_sections + 1, cl_sezione.create(get_num_sections + 1, get_section_attiva, get_pagina_logica_attiva_1B));
		assign_section_ZB(get_num_sections, cl_sezione.create_ZB(get_num_sections, get_section_attiva_ZB, get_pagina_logica_attiva_ZB));
		set_num_sections(get_num_sections + 1);
		var sn : cl_sezione := sections_ZB(get_num_sections - 1);	// sezione NUOVA
		var sa : cl_sezione := sections_ZB(get_section_attiva_ZB);	// sezione ATTIVA

	//	sn.r_y_sezione_cm := MAX(round(sections(get_section_attiva).r_y_gruppo_cm) - 2,1);
		sn.r_y_sezione_cm := MIN(MAX(round(sa.r_y_gruppo_cm * 0.2), 1), round(sa.r_y_gruppo_cm * 0.5));
		if (get_section_attiva_ZB = MAIN_SECTION_ZB) then begin
			sn.r_y0_rel_cm := round((sections_ZB(MAIN_SECTION_ZB).r_y_sezione_cm - sn.r_y_sezione_cm) / 2);
			sn.r_y_gruppo_cm := MAX(round(sn.r_y_sezione_cm / 2), 1);
		end
		else begin
			sn.r_y0_rel_cm := 1;
			sn.r_y_gruppo_cm := sn.r_y_sezione_cm
		end;
		sn.set_panel_values;
		panels_1B(get_num_sections).set_active(TRUE);
		GM.bo_modified := TRUE;
	//	obj.check_objs_pos_in_section(0)
	end;

{	procedure delete_section(i_section : section_index_type);
	var i : section_index_type;
	begin
		if (i_section = MAIN_SECTION) then exit;
		i := 1;
		while (i <= get_num_sections) do begin
			if (sections_1B(i).i_father = i_section) then begin delete_section(i);i := 0 end;
			inc(i)
		end;
		for i := i_objs downto 1 do
			if (xobjs(i).ca.i_section_1B = i_section) then delete_object(i,TRUE,FALSE);

		sections_1B(i_section).set_father(0);
		sections_1B(i_section).free;
		assign_section(i_section,NIL);
		for i := i_section to get_num_sections-1 do change_section_number(i+1,i);
		set_num_sections(get_num_sections-1);
		set_section_attiva(MAIN_SECTION);
		globale.bo_modified := TRUE
	end; }

	procedure delete_section_ZB(i_section_ZB : section_index_type);
	begin
		if (i_section_ZB = MAIN_SECTION_ZB) then exit;		// non si può cancellare la sezione principale
		var i_ZB : section_index_type := 0;
		// cancello (ricorsivamente) tutte le sezioni figle di I_SECTION_ZB
		while (i_ZB <= get_num_sections - 1) do begin
			if (sections_ZB(i_ZB).i_father_ZB = i_section_ZB) then begin delete_section_ZB(i_ZB);i_ZB := -1 end;
			inc(i_ZB)
		end;
		for var i_1B : obj_index_type := i_objs downto 1 do
			if (xobjs(i_1B).ca.i_section_1B - 1 = i_section_ZB) then delete_object(i_1B, TRUE, FALSE);

//		sections_1B(i_section_1B).set_father_1B(0);
		sections_ZB(i_section_ZB).set_father_ZB(-1);
//		sections_1B(i_section).free;
		sections_ZB(i_section_ZB).free;
//		assign_section(i_section, NIL);
		assign_section_ZB(i_section_ZB, NIL);
//		for i := i_section_1B to get_num_sections-1 do change_section_number(i+1, i);
		for i_ZB := i_section_ZB to get_num_sections-2 do change_section_number_ZB(i_ZB + 1, i_ZB);
//		set_num_sections(get_num_sections - 1);
		set_num_sections(get_num_sections - 1);
		set_section_attiva_ZB(MAIN_SECTION_ZB);
		GM.bo_modified := TRUE
	end;

	function is_antenato_ZB(i_section_ZB, i_candidato_antenato_ZB : section_index_type) : boolean;
	// rende TRUE se I_SECTION_ZB è un antenato della sezione
	begin
		var i : section_index_type := i_section_ZB;
		while (i <> -1) do begin
			i := sections_ZB(i).i_father_ZB;
			if (i = i_candidato_antenato_ZB) then begin result := TRUE;exit end
		end;
		result := FALSE
	end;

{$endif GALATEO_EXE}

procedure open_all_queries(bo_open_ancestors,bo_accept_blank,bo_stampa_vera : boolean);
// fa aprire le queries di ogni sezione; emette messaggi di errore e raisa una exception in caso di errore
begin
	for var i : section_index_type := 1 to get_num_sections do
		sections_1B(i).query_open(bo_open_ancestors,bo_accept_blank,bo_stampa_vera,FALSE)
end;

{$ifdef VARS}
{$ifdef CASA}
	procedure cl_sezione.build_vars;
	// carico sul vettore VARS l'elenco degli oggetti della sezione, divisi per tipo; serve per aumentare le performances
	begin
		free_vars;	// per scrupolo
		for var i : obj_index_type := 1 to i_objs do begin
			var x : objs_type := xobjs(i, i_logical_page_ZB + 1);
			if (x.ca.i_section_1B <> i_section_ZB + 1) then continue;
{			if (x.get_tipo = xVARIABILE) then tv := x.aslabel.tipovar	// tipi gestiti
			else tv := TV_BLANK; }	// tutti gli altri oggetti
			var tv : variabile_type := x.tipo_variabile;
			var j : obj_index_type := length(vars[tv]);
			setLength(vars[tv], j+1);vars[tv, j] := i
		end;
		bo_vars_built := TRUE
	end;
{$endif CASA}

	procedure cl_sezione.free_vars;
	begin
		for var tv := low(variabile_type) to high(variabile_type) do vars[tv] := NIL;
		bo_vars_built := FALSE
	end;

{$endif}

function cl_sezione.exportabile_integrale(i_profilo : expint_index_type;bo_runtime : boolean) : boolean;
{ rende TRUE se la sezione viene exportata (o può essere exportata);
  a DESIGN-TIME il valore OEXP_NOT indica comunque possibilità di exportazione (a seguito di una successiva scelta dell'utente) }
begin
	result := FALSE;
	if NOT globale.bo_export_allowed then exit;
	var exs := get_expint_section(i_profilo);
//	if (exs.xexport_type in [OEXP_NOT, OEXP_IMPOSSIBLE]) then exit;
	if (exs.expint_mode = SEXP_IMPOSSIBLE) then exit;		// a DESIGN-TIME OEXP_NOT non è una esclusione assoluta di exportazione
	if bo_runtime AND (exs.expint_mode = SEXP_NOT) then exit;		// a RUNTIME OEXP_NOT è una esclusione assoluta di exportazione
//	if NOT globale.pages_info[i_logical_page].bo_export_allowed then exit;
//	if NOT globale.expint_profiles[i_profilo].expint_pages[i_logical_page].bo_export_allowed then exit;
	if NOT get_expint_page_ZB(i_profilo, i_logical_page_ZB).bo_export_allowed then exit;
	if (exs.expint_mode = SEXP_YES) then begin result := TRUE;exit end;	// anche se la sezione è nascosta, o se uno dei padri è nascosto
	{ NEXT LINE: commentata 2014-12-17, perchè in caso di NESSUN COMANDO SQL non ci sarebbero alternative tra EXPORT ALWAYS e EXPORT FORBIDDEN
	  mentre resta utile la possibilità di mettere DEFAULT NOT ma insieme consentire l'exportazione su esplicita richiesta dell'utente }
//	if (TStrings_total_length(tsql_command, 0) = 0) then exit; 	// nessun comando SQL: per default NON exporto

{	var i : section_index_type := i_section_1B;
	while (i > MAIN_SECTION) do begin
		if sections_1B(i, i_logical_page_1B).bo_dont_print_section then exit;
		dec(i)
	end;  }
	var i_ZB : section_index_type := i_section_ZB;
	while (i_ZB > MAIN_SECTION_ZB) do begin
		if sections_ZB(i_ZB, i_logical_page_ZB).bo_dont_print_section then exit;
		dec(i_ZB)
	end;
	result := TRUE
end;

function cl_sezione.get_expint_section(i_profilo : expint_index_type = -1) : cl_expint_section;
begin
	result := expint_base.get_expint_section_ZB(i_profilo, i_logical_page_ZB, i_section_ZB)
end;

{$ifdef GALATEO_EXE}
	function cl_sezione.validate_formula_editing(handle : hwnd;str_formula : string;str_descrizione : string;ox : objs_type;tipo : risultato_type;bo_allow_blank : boolean) : boolean;
	{ rende TRUE se la formula specificata è valida, FALSE altrimenti;
	  TIPO deve essere il tipo di risultato richiesto, oppure può essere oppure VAL_BOH se qualunque tipo è ammesso }
	var
		bo : boolean;
		str_msg : string;
	begin
		str_formula := translate_local_macros(str_formula);	// dal 2005-06-20
		interpreta_string(str_formula, FALSE, TRUE);	// aggiunta del 2005-05-09
		if bo_allow_blank AND (str_formula = '') then result := TRUE
		else begin
			if (tipo = VAL_BOOLEAN) then result := interpreta_boolean_expression(str_formula, TRUE, bo, str_msg)
			else result := translate_formula(str_formula, str_msg, TRUE, tipo, ox);
			if NOT result AND (str_msg <> '') then MessageBBox(handle, str_msg, str_descrizione, MB_ICONSTOP)
		end
	end;
{$endif GALATEO_EXE}

function cl_sezione.SQL_blank : boolean;
// rende TRUE se NON c'è alcun comando SQL
begin
	var s : string := tsql_command.Text;
	sostituisci(s, ' ', '');
	sostituisci(s, ACAPO, '');
	sostituisci(s, ^I, '');
	result := (s = '')
end;

{$ifdef CASA}
function cl_sezione.tratta_XML(sv : cl_print_section) : boolean;
{ acquisisce i dati per l'exportazione XML e predispone per l'output definitivo;
  rende TRUE se l'operazione ha successo (oppure se non è stata eseguita), FALSE se ci sono stati errori }

	function exec(i_profilo : smallint) : boolean;
	const MBOX_DEBUG_CAPTION = 'tratta_XML_exec()';
	begin
		result := TRUE;
		if NOT XML_attivo(i_profilo) then exit;			// fatto nulla, comunque tutto OK

		Gdebug_SQL('start valutazione XML -- i_profilo = ' + i_profilo.ToString, MBOX_DEBUG_CAPTION, {remarks}TRUE);
(*		if (str_condizione_export_XML <> '') then begin
			s := str_condizione_export_XML;
			if NOT interpreta_boolean_expression(s, {test}FALSE, bo_result, str_msg) then
				raise exception.create('Errore durante la valutazione della condizione di exportabilita XML' + ACAPO2 +
					str_condizione_export_XML + ACAPO2 + str_msg);
			if NOT bo_result then exit		// condizione non verificata: salto l'exportazione del record
		end; *)

		append_ACAPO(str_XML_elaborato[i_profilo], XML_commento({start}TRUE));
		var s := get_expint_section_ZB(i_profilo, i_logical_page_ZB, i_section_ZB).str_struttura_XML;
		interpreta_string(s, {stampa_vera}TRUE, {check_errors}TRUE, 'valutazione struttura XML'{, {XML_special_chars TRUE});	// rende TRUE se modifica la stringa
	//	str_XML_elaborato := ifs(str_XML_elaborato, str_XML_elaborato + ACAPO) + s;
		append_ACAPO(str_XML_elaborato[i_profilo], s);
	//	sv.str_XML := s
	end;

const MBOX_DEBUG_CAPTION = 'tratta_XML()';
begin
	for var i_profilo : smallint := 0 to high(globale.expint_profiles) do exec(i_profilo);
	result := TRUE
end;
{$endif CASA}

{$ifdef CASA}
function cl_sezione.XML_attivo(i_profilo : smallint) : boolean;
// rende TRUE se l'XML è attivo per la sezione ed il profilo
begin
	result := FALSE;
	if NOT get_export_target_XML(i_profilo) then exit;

	var es := get_expint_section_ZB(i_profilo, i_logical_page_ZB, i_section_ZB);
	result := es.bo_XML_allowed AND (es.str_struttura_XML <> '')
end;

function cl_sezione.XML_commento(bo_start : boolean) : string;
begin
	if globale.bo_XML_structure_debug_info then result := proc.XML_commento('SEZIONE', get_name(TRUE), bo_start)
	else result := ''
end;

procedure exec_validazione_anticipata_proc(context : validazione_context_type);
begin
	if silent_mode then exit;	// nulla da fare
	var valid := validation_create(globale.str_filename);
	var bo_exclude_message_not_computed_object_OLD := bo_exclude_message_not_computed_object;
	bo_exclude_message_not_computed_object := TRUE;
	try
		// eseguo la validazione dei soli oggetti generali (sezione principale di ogni pagina)
		for var i_lpz : logical_page_type := 0 to get_ultima_pagina_logica-1 do
			sections_ZB(0, i_lpz).validate_objects(valid, {sv}NIL, {validate_pre_SQL}FALSE, [context]);
		if NOT validation_verify(valid, NIL, globale.str_filename, VOPT_DONT_DELETE, {callback_proc}NIL) then begin
//			bo_stopped_validazione := TRUE;
			abort
		end
	finally
		bo_exclude_message_not_computed_object := bo_exclude_message_not_computed_object_OLD;
		validation_free(valid)
	end
end;

{$endif CASA}

initialization
	galateo_initialization_debug('sezione')
finalization
	galateo_finalization_debug('sezione');
	{$ifdef DEBUG} CCI(i_sezione, 'cl_sezione', 'sezione.pas') {$endif}
end.
