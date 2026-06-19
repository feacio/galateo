unit rects;

{$I defines}

interface

uses Windows, VCL.ExtCtrls, VCL.Graphics, VCL.Forms, UITypes, Messages, SysUtils, Math, VCL.Controls, Types,
	{$ifdef GALATEO_EXE} panel, {$endif}
	gdich, objsx;

const
	ROUND_CONVERSION_FACTOR = 5;		// rapporto tra l'indice interno ed il valore effettivamente utilizzato
	{$ifdef GALATEO_EXE} MAX_ROUND_FACTOR = 10; {$endif}

type
	cl_rect = class(TPaintBox)
		public
//			i_numero_obj : obj_index_type;
//			tipo_oggetto : obj_type;
//			i_section : section_index_type;
			ca : cl_common_attributes;
			i_thickness : smallint;
			lo_colore_bordo, lo_colore_fondo : TColor;
			bo_trasparente : boolean;
			i_round_factor : smallint;			// non è il parametro passato alla RoundRect(), ma un indice interno, va da 0 a MAX_ROUND_FACTOR
			i_actual_width, i_actual_height : int_pixel_type;			// dimensione reale dell'oggetto
			i_executive_width, i_executive_height : int_pixel_type;	// dimensione dell'oggetto esecutiva (eventualmente ricalcolata prima della stampa)
			bo_dimensione_verticale_fissa : boolean;						// l'oggetto non subisce ridimensionamento verticale
//			show : show_types;
			constructor xcreate(form : TForm;ca : cl_common_attributes;tipo_oggetto : obj_type;i_section_1B : section_index_type;i_obj : obj_index_type;bo_init_default : boolean);
//			procedure free;		// fino a 2011-05-10
			destructor Destroy; override;
{$ifdef GALATEO_EXE}
			procedure applica_style(obj_from : {objs_type} pointer;wo_style : word);
			function save(var f : text;xref : reference_obj) : boolean;
			procedure edit_object;
			procedure esc;
			procedure select(bo_select : boolean);
			procedure WMLButtonDown(var Message: TWMLButtonDOWN); message WM_LBUTTONDOWN;
			procedure WMLButtonDblclk(var Message: TWMLButtonDBLCLK); // message WM_LBUTTONDBLCLK;
			procedure WMLButtonUp(var Message: TWMLButtonUp); // message WM_LBUTTONUP;
			procedure WMMousemove(var Message: TWMMouseMove); // message WM_MOUSEMOVE;
			procedure WMRButtonDown(var Message: TWMRButtonDOWN); // message WM_RBUTTONDOWN;
			procedure WMmove(var Message: TWMMove); message WM_MOVE;
{$endif GALATEO_EXE}
			function load(var f : text;xref : reference_obj;wo_versione : word) : boolean;
			function get_x_left_virtuale(x_left : int_pixel_type) : int_pixel_type;
			{$ifdef GALATEO_EXE} function get_y_top_virtuale(y_top : int_pixel_type) : int_pixel_type; {$endif}
{$ifdef CASA}
			function print(vcanvas,pcanvas : TCanvas;x0,y0 : int_pixel_type;bo_video : boolean;
				ptcr : pTRect;var i_delta_y : int_pixel_type;var i_max_y_pixel : int_pixel_type;
				i_delta_y_bottom,i_margine_y_pixel : int_pixel_type;
				i_font_ridotto_size : smallint;bo_can_break_object : boolean;
				i_ph_first_page_section,i_ph_last_page_section : ph_page_type;ptr_print_section : {cl_print_section}pointer = NIL) : boolean;
{$endif CASA}
			property caption;
		private
			father : TForm;
{$ifdef GALATEO_EXE}
			pbox : TGalPaintBox;
			procedure WMPaint(var Message : TWMPaint); message WM_PAINT;
			procedure xpaint;
{$endif GALATEO_EXE}
	end;

implementation

uses Fassert, Fcommons, Fdebug, FMessage,
	{$ifdef GALATEO_EXE} galateo_main, rect_edit, {$endif}
	galateo_debug, proc, misure, pages, objects;

{$ifdef DEBUG} var i_rects : integer; {$endif}

constructor cl_rect.xcreate(form : TForm;ca : cl_common_attributes;tipo_oggetto : obj_type;i_section_1B : section_index_type;
	i_obj : obj_index_type;bo_init_default : boolean);
var str_temp : string;
begin
	inherited create({$ifdef DLL}NIL{$else}panels_1B(i_section_1B){$endif});
//	self.i_numero_obj := i_obj;
	{$ifdef DEBUG} inc(i_rects); {$endif}
//	ca := cl_common_attributes.create(i_section);
	{$ifdef DEBUG} assert(ca <> NIL, 'CA is NIL'); {$endif}
	self.ca := ca;
//	self.tipo_oggetto := tipo_oggetto;
	ca.tipo_oggetto := tipo_oggetto;
//	attr.tipo_valore := VAL_BLANK;
	self.father := form;
	ca.i_section_1B := i_section_1B;
{$ifdef GALATEO_EXE}
	parent := panels_ZB(i_section_1B - 1);	// non è inutile !!!
	pbox := panels_ZB(i_section_1B - 1).pbox;
{$endif}
//	inherited create(panels(i_section));
	Cursor := DEFAULT_CURSOR_OBJECTS;
	inc(lo_creation);
	Tag := get_new_tag;
//	showhint := TRUE;hint := 'Per spostarmi schiaccia il tasto sinistro e trascina';
	ShowHint := TRUE;hint := 'Per spostarmi schiaccia e trascina';
	SendToBack;		// necessario perchè altrimenti copre gli altri controls
//	BringToFront;
	if bo_init_default then begin
		if (tipo_oggetto = OBJ_RECT) then str_temp := 'RECT_' else str_temp := 'LINEA_';
		caption := create_name(str_temp, FALSE);
{$ifdef GALATEO_EXE}
		Left := (lo_creation * 30) mod Parent.Width div 3 * 2;
		Top := (lo_creation * 30) mod Parent.Height div 3 * 2;
{$endif GALATEO_EXE}
		lo_colore_bordo := clBlack;i_thickness := 1;
		lo_colore_fondo := clWhite;bo_trasparente := TRUE;
		i_round_factor := 0;
		i_actual_width := 90;Width := i_actual_width + 1;
		i_actual_height := 50;Height := i_actual_height + 1
	end
//	bo_selected := FALSE
end;

destructor cl_rect.destroy;
begin
	{$ifdef DEBUG} dec(i_rects); {$endif}
//	if (attr <> NIL) then begin ca.free;attr := NIL end;
//	Visible := FALSE;		{$ifNdef DEBUG} *** necessario??? {$endif}
	inherited		// 2011-05-10, prima non c'era
end;

function cl_rect.load(var f : text;xref : reference_obj;wo_versione : word) : boolean;
// carica l'oggetto; rende TRUE in caso di successo
var s : string;  //*
begin
	try
		read_object_pos(self, f, wo_versione);
		read_object_size(self, f, wo_versione);
		readln(f);
		i_actual_width := Width;if (i_actual_width = 1) then i_actual_width := 0;
		i_actual_height := height;if (i_actual_height = 1) then i_actual_height := 0;
		if (i_actual_width = 0) AND (i_actual_height = 0) then begin
			i_actual_width := cm2pixel_video_x(0.5);
			i_actual_height := cm2pixel_video_y(0.5)
		end;
		xref.load(f);
		readln(f, s);Caption := s;

		if NOT eoln(f) then read(f, lo_colore_bordo, i_thickness);
		readln(f);	// chiude l'istruzione precedente

		var old_show : show_types := OSW_SHOW;
		if (wo_versione < $0203) then readln(f)
		else if (wo_versione <= $0260) then readln(f, byte(old_show));

		if NOT ca.load(f, wo_versione) then abort;
		if (wo_versione <= $0260) then ca.show := old_show;
		lo_colore_fondo := clWhite;bo_trasparente := TRUE;		// valori default per old reports (ver < $0404 e $030C e $0224) -- fondo e trasparenza non gestiti
		i_round_factor := 0;		// rettangolo perfetto
		if (wo_versione > $0224) then begin
			readln(f, lo_colore_fondo);
			if (wo_versione >= $030C) then readln(f, byte(bo_dimensione_verticale_fissa), byte(bo_trasparente), i_round_factor);
//			if (wo_versione < $0404) then bo_trasparente := (lo_colore_fondo = clWhite);		// fino a questa versione il fondo non era gestito
			if (wo_versione < $0404) then bo_trasparente := TRUE;		// fino a questa versione il fondo non era gestito
			for var i : smallint := 1 to 11 do readln(f)
		end;
		Color := lo_colore_fondo;

		Width := max(i_actual_width + 1, i_thickness);
		Height := max(i_actual_height + 1, i_thickness);

		result := TRUE
	except
//		result := FALSE;
		MessageBBox(father, 'Errore durante la lettura del file', MBOX_CAPTION, MB_ICONSTOP);
		abort
	end
end;

function cl_rect.get_x_left_virtuale(x_left : int_pixel_type) : int_pixel_type; begin result := x_left end;
{$ifdef GALATEO_EXE} function cl_rect.get_y_top_virtuale(y_top : int_pixel_type) : int_pixel_type; begin result := y_top end; {$endif}

{$ifdef CASA}
function cl_rect.print(vcanvas, pcanvas : TCanvas;x0,y0 : int_pixel_type;bo_video : boolean;
	ptcr : pTRect;var i_delta_y : int_pixel_type;var i_max_y_pixel : int_pixel_type;
	i_delta_y_bottom, i_margine_y_pixel : int_pixel_type;
	i_font_ridotto_size : smallint;bo_can_break_object : boolean;
	i_ph_first_page_section, i_ph_last_page_section : ph_page_type;ptr_print_section : {cl_print_section}pointer = NIL) : boolean;
// vedi commento generale in OBJECTS su PRINT_PROC_TYPE
var
	r : TRect;	//*
	canvas : TCanvas; //*
begin
	result := TRUE;
	{$ifdef DEBUG} assert(NOT object_is_hidden(ca.show, get_virtual_printing_page, ca.i_section_1B, i_ph_first_page_section, i_ph_last_page_section, TRUE), 'AKYX 2934'); {$endif}
	if globale.bo_text_only then exit;	// non stampo, se non sono in grafica
	if (ca.show = OSW_HIDE) then exit;
	inc(y0, i_delta_y);
	if bo_dimensione_verticale_fissa then i_delta_y_bottom := 0;		// annullo il ridimensionamento verticale
	ca.x_print_exec := x0 + Left;ca.y_print_exec := y0 + Top;
//	ca.dx_print_exec := i_actual_width;ca.dy_print_exec := i_actual_height;
	if (i_executive_width = 0) then i_executive_width := i_actual_width;
	if (i_executive_height = 0) then i_executive_height := i_actual_height;
	ca.dx_print_exec := i_executive_width;ca.dy_print_exec := i_executive_height;
	var i_round_executive : int_pixel_type := i_round_factor * ROUND_CONVERSION_FACTOR;		// arbitrario, ma funge abbastanza bene
	if bo_video then begin
//		r.Left := x0+left;r.Top := y0+top;
//		r.Right := x0 + left+i_actual_width;
//		r.Bottom := y0+top+i_actual_height + i_delta_y_bottom
		canvas := vcanvas;
		r.Left := x0 + round(Left * tm.r_fattore_zoom);
		r.Top := y0 + round(Top * tm.r_fattore_zoom);
		r.Right := x0 + round((Left + i_executive_width) * tm.r_fattore_zoom);
		r.Bottom := y0 + i_delta_y_bottom + round((Top + i_executive_height) * tm.r_fattore_zoom)
	end
	else begin
		canvas := pcanvas;
		r.Left := x0 + tm.video2print_pixel_x(Left);
		r.Top := y0 + tm.video2print_pixel_y(Top);
//		r.Right := x0 + tm.video2print_pixel_x(Left) + i_executive_width;
//		r.Right := r.Left + tm.video2print_pixel_x(i_executive_width);
		r.Right := r.Left + i_executive_width;
//		r.Bottom := y0 + tm.video2print_pixel_y(Top) + i_executive_height + i_delta_y_bottom
//		r.Bottom := r.Top + tm.video2print_pixel_y(i_executive_height) + i_delta_y_bottom
		r.Bottom := r.Top + i_executive_height + i_delta_y_bottom;
		i_round_executive := tm.video2print_pixel_y(i_round_executive)
	end;

(*	var p_old : TPen := TPen.create;p_old.assign(canvas.pen);
	var i_pen_width := MAX(i_thickness, 1);
	canvas.Pen.Width := i_pen_width;
	canvas.Pen.Color := lo_colore_bordo;
	canvas.MoveTo(r.Left, r.Top);
	if (ca.tipo_oggetto = OBJ_RECT) then begin
//		canvas.Rectangle(r.Left, r.Top, r.Right, r.Bottom)		*** riempie anche il fondo, io voglio solo il contorno
		canvas.Lineto(r.Right, r.Top);canvas.Lineto(r.Right, r.Bottom);
		canvas.Lineto(r.Left, r.Bottom);canvas.Lineto(r.Left, r.Top)
	end
	else canvas.Lineto(r.Right, r.Bottom);
	canvas.Pen.assign(p_old);

	if (ca.tipo_oggetto = OBJ_RECT) AND (lo_colore_fondo <> clWhite) then begin
		{ inflato il rect usando DIV 2 perchè la linea (se Pen.Width > 1) viene disegnata metà sopra metà sotto;
		  la parte interna da rispettare è quindi I_PEN_WIDTH DIV 2 }
		var i_delta : smallint := max(i_pen_width div 2, 1);
		InflateRect(r, -i_delta, -i_delta);
		r.Right := r.Right {+ 1};r.Bottom := r.Bottom + 1;
		var lo_old : TColor := canvas.Brush.Color;
		canvas.Brush.Color := lo_colore_fondo;
		var i_old_bkmode : integer := 0;
		if bo_trasparente then i_old_bkmode := SetBkMode(canvas.Handle, TRANSPARENT);
		canvas.FillRect(r);
		if bo_trasparente then SetBkMode(canvas.Handle, i_old_bkmode);
		canvas.Brush.Color := lo_old
	end *)

	var previous_pen : TPen := TPen.create;previous_pen.assign(canvas.pen);
	var i_pen_width := max(i_thickness, 1);
	canvas.Pen.Width := i_pen_width;canvas.Pen.Color := lo_colore_bordo;

	if (ca.tipo_oggetto = OBJ_LINE) {OR bo_trasparente} then begin	// solo linea esterna, non coloro il background
		canvas.MoveTo(r.Left, r.Top);
		canvas.Lineto(r.Right, R.Bottom)
{		case ca.tipo_oggetto of
			OBJ_LINE : canvas.Lineto(r.Right, R.Bottom);
			OBJ_RECT : begin canvas.Lineto(r.Left, R.Bottom);canvas.Lineto(r.Right, R.Bottom);canvas.Lineto(R.Right, R.Top);canvas.Lineto(R.Left, R.Top) end
		end }
	end
	else begin		// disegno un rettangolo compreso il fondo
		var lo_previous_brush_color : TColor := canvas.Brush.Color;
		canvas.Brush.Color := lo_colore_fondo;
		if bo_trasparente then canvas.Brush.Style := bsClear else canvas.Brush.Style := bsSolid;
//		var i_old_bkmode : integer := 0;
//		if bo_trasparente then i_old_bkmode := SetBkMode(canvas.Handle, TRANSPARENT);
//		canvas.FillRect(r);		*** disegna solo l'interno, non il bordo
		r.bottom := r.bottom + 1;r.Right := r.Right + 1;		// perchè RECTANGLE esclude il bordo destro
		if (i_round_executive = 0) then canvas.Rectangle(r)
		else canvas.RoundRect(r.Left, r.Top, r.Right, r.Bottom, i_round_executive, i_round_executive);
//		if bo_trasparente then SetBkMode(canvas.Handle, i_old_bkmode);
		canvas.Brush.Color := lo_previous_brush_color
	end;
	canvas.Pen.assign(previous_pen)
end;

{$endif CASA}

{$ifdef GALATEO_EXE}

	procedure cl_rect.WMPaint(var Message: TWMPaint); begin xpaint end;

	procedure cl_rect.xPaint;
	const
		LO_COLOR_SELECTED = clRed;
		LO_COLOR_SELECTED_ALTERNATIVE = clGreen;
	begin
		i_thickness := MAX(i_thickness, 1);
		var lo_colore : TColor := self.lo_colore_bordo;
		if ca.bo_selected then
			if (lo_colore = LO_COLOR_SELECTED) then lo_colore := LO_COLOR_SELECTED_ALTERNATIVE
			else lo_colore := LO_COLOR_SELECTED
		else if object_is_hidden(ca.show, 0) then lo_colore := computer_registry_data.lo_hidden_objects_color;

(*		with canvas do begin
			Pen.Width := i_thickness;Pen.Color := lo_colore;
			MoveTo(0,0);
			if (ca.tipo_oggetto = OBJ_RECT) then begin
				var r : TRect := Rect(0, 0, i_actual_width, i_actual_height);
//				canvas.Rectangle(r);		*** noooo, riempie il fondo
//				Lineto(0, i_actual_height);Lineto(i_actual_width, i_actual_height);Lineto(i_actual_width, 0);Lineto(0, 0);
				Lineto(r.Left, R.Bottom);Lineto(r.Right, R.Bottom);Lineto(R.Right, R.Top);Lineto(R.Left, R.Top);
				if (lo_colore_fondo <> clWhite) then begin
					InflateRect(r, -i_thickness, -i_thickness);
					var lo_old : TColor := canvas.Brush.Color;
					canvas.Brush.Color := lo_colore_fondo;
					var i_old_bkmode : integer := 0;
					if bo_trasparente then i_old_bkmode := SetBkMode(canvas.Handle, TRANSPARENT);
					canvas.FillRect(r);
					if bo_trasparente then SetBkMode(canvas.Handle, i_old_bkmode);
					canvas.Brush.Color := lo_old
				end
			end
			else begin
				{$ifdef DEBUG} assert(ca.tipo_oggetto = OBJ_LINE,'tipo graphic obj IQP 230'); {$endif}
				Lineto(i_actual_width, i_actual_height)
			end
		end *)

		var r : TRect := Rect(0, 0, i_actual_width, i_actual_height);
		canvas.Pen.Width := i_thickness;canvas.Pen.Color := lo_colore;
		if (ca.tipo_oggetto = OBJ_LINE) {OR bo_trasparente} then begin	// solo linea esterna, non coloro il background
			canvas.MoveTo(r.Left, r.Top);
			case ca.tipo_oggetto of
				OBJ_LINE : canvas.Lineto(r.Right, R.Bottom);
				OBJ_RECT : begin canvas.Lineto(r.Left, R.Bottom);canvas.Lineto(r.Right, R.Bottom);canvas.Lineto(R.Right, R.Top);canvas.Lineto(R.Left, R.Top) end
			end
		end
		else begin
			var lo_previous_brush_color : TColor := canvas.Brush.Color;
			canvas.Brush.Color := lo_colore_fondo;
			if bo_trasparente then canvas.Brush.Style := bsClear else canvas.Brush.Style := bsSolid;
//			if bo_trasparente then i_old_bkmode := SetBkMode(canvas.Handle, TRANSPARENT);
			r.bottom := r.bottom + 1;r.Right := r.Right + 1;		// perchè RECTANGLE esclude il bordo destro
			if (i_round_factor = 0) then canvas.Rectangle(r)
			else canvas.RoundRect(r.Left, r.Top, r.Right, r.Bottom, i_round_factor * ROUND_CONVERSION_FACTOR, i_round_factor * ROUND_CONVERSION_FACTOR);
//			if bo_trasparente then SetBkMode(canvas.Handle, i_old_bkmode);
			canvas.Brush.Color := lo_previous_brush_color
		end
	end;

	procedure cl_rect.WMmove(var Message: TWMMove);
	begin
		var ox : objs_type := tag2object(tag);
		if (ox <> NIL) then ox.on_change_size_and_pos
//		var i_obj : obj_index_type := _tag2index(tag);
//		if (i_obj <> 0) then xobjs(i_obj).on_change_size_and_pos
	end;

	(*procedure cl_rect.self_select;
	// ad uso interno, per selezionare l'oggetto (se stesso)
	begin
		if (NOT ca.bo_selected) then obj.select(obj.tag2index(tag),TRUE,FALSE)
	end; *)

	procedure cl_rect.select(bo_select : boolean);
	// ad uso generale, per applicare la selezione a questo oggetto
	begin
		if (bo_select = ca.bo_selected) then exit;
		ca.bo_selected := bo_select;
		xpaint
	end;

	procedure cl_rect.WMLButtonDown(var Message: TWMLButtonDown);
	begin
		dd.bo_resizing_horz := (cursor = crSizeWE);
		dd.bo_resizing_vert := (cursor = crSizeNS);
		var i_obj : obj_index_type := get_related_obj([], ca.i_section_1B, message.xpos, message.ypos, FALSE, TRUE);
		{$ifdef DEBUG} assert(i_obj <> 0,'ORPOLETTA 987'); {$endif}
		select_checking_keys(i_obj)
	end;

	procedure cl_rect.WMRButtonDown(var Message: TWMRButtonDown);
	begin
		var i_obj : obj_index_type := get_related_obj([], ca.i_section_1B, message.xpos, message.ypos, FALSE, TRUE);
		{$ifdef DEBUG} assert(i_obj <> 0, 'ORPOLETTA 986'); {$endif}
		if NOT is_selected(i_obj) then select_checking_keys(i_obj);
		var p : TPoint := ClientToScreen(Point(message.xpos-left, message.ypos-top));
		GM.popup_object.popup(p.x, p.y)
	end;

	procedure cl_rect.WMLButtonDblclk(var Message: TWMLButtonDBLCLK); begin edit_object end;
	procedure cl_rect.WMLButtonUp(var Message: TWMLButtonUp); begin dd.dragging_mouse_up end;
	procedure cl_rect.WMMousemove(var Message: TWMMouseMove); begin {dd.dragging_Mousemove*(self,message.xpos+left,message.ypos+top)} end;
	procedure cl_rect.edit_object; begin rect_edit_proc(father, ca.i_numero_obj) end;
	procedure cl_rect.esc; begin end;

	function cl_rect.save(var f : text;xref : reference_obj) : boolean;
	// salva l'oggetto; rende TRUE in caso di successo
	begin
		try
			writeln(f, video2cm_x(left):0:3,' ', video2cm_y(top):0:3,' ', video2cm_x(i_actual_width):0:3,' ', video2cm_y(i_actual_height):0:3);
			xref.save(f);
			writeln(f, Caption);
			writeln(f, lo_colore_bordo, ' ', i_thickness);
//			writeln(f,byte(show));
			if NOT ca.save(f) then abort;
			writeln(f, lo_colore_fondo);
			writeln(f, byte(bo_dimensione_verticale_fissa), byte(bo_trasparente):2, i_round_factor:3, ' 0 0 0 0 0 0 0 0 0 0');		// dalla versione $030C
			for var i : smallint := 1 to 11 do writeln(f);
			result := TRUE
		except
//			result := FALSE;
			MessageBox(father.handle, 'Errore durante la scrittura del file', MBOX_CAPTION, MB_ICONSTOP);
			abort
		end
	end;

	procedure cl_rect.applica_style(obj_from : {objs_type} pointer;wo_style : word);
	begin
		if (wo_style = STYLE_ALL) then wo_style := GRAPHIC_STYLES;
		var x : objs_type := objs_type(obj_from);
{		if (wo_style AND STYLE_SIZE <> 0) then begin
			dec(wo_style,STYLE_SIZE);
			i_actual_height := obj_from.get_height;height := MAX(i_actual_height+1,i_thickness);
			i_actual_width := obj_from.get_width;width := MAX(i_actual_width+1,i_thickness)
		end; }
{		if (wo_style AND STYLE_LEGAMI_COMUNITARI <> 0) then begin
			dec(wo_style,STYLE_LEGAMI_COMUNITARI);
			obj_dest.xref.str_vert := obj_from.xref.str_vert;
			obj_dest.xref.str_horz := obj_from.xref.str_horz;
			obj_dest.xref.str_pos := obj_from.xref.str_pos
		end; }
		if (wo_style AND STYLE_FORMATTATION <> 0) then begin
			{$ifdef DEBUG} dec(wo_style, STYLE_FORMATTATION); {$endif}
			if (x.ca.tipo_oggetto in [OBJ_RECT, OBJ_LINE]) then begin
				i_thickness := x.asgraph.i_thickness;
				lo_colore_bordo := x.asgraph.lo_colore_bordo;
				lo_colore_fondo := x.asgraph.lo_colore_fondo;
				bo_trasparente := x.asgraph.bo_trasparente;
				i_round_factor := x.asgraph.i_round_factor;
				bo_dimensione_verticale_fissa := x.asgraph.bo_dimensione_verticale_fissa
			end
		end;
		if (wo_style AND STYLE_COLORE_SPESSORE_LINEA <> 0) then begin
			{$ifdef DEBUG} dec(wo_style, STYLE_COLORE_SPESSORE_LINEA); {$endif}
			if (x.ca.tipo_oggetto in [OBJ_RECT, OBJ_LINE]) then begin
				i_thickness := x.asgraph.i_thickness;
				lo_colore_bordo := x.asgraph.lo_colore_bordo;
				lo_colore_fondo := x.asgraph.lo_colore_fondo;
				bo_trasparente := x.asgraph.bo_trasparente;
				i_round_factor := x.asgraph.i_round_factor
			end
		end;	
		{$ifdef DEBUG} assert(wo_style = 0,'cl_rect.applica_style() <> 0') {$endif}
	end;

{$endif GALATEO_EXE}

initialization
	galateo_initialization_debug('rects')
finalization
	galateo_finalization_debug('rects');
	{$ifdef DEBUG} CCI(i_rects, 'cl_rect', 'rects.pas') {$endif}
end.
