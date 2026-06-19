unit datamatrix_unit;

{$I defines}
{$ifdef CASA} {$define PRINT_WMF} {$endif}	// metodo SCANDALOSO per stampare via salvataggio di file WMF; è l'unico che ho trovato
//{$ifdef DEBUG} *** {$else} {*$R+,L+,D+,S+} {$endif}

interface

uses UITypes, Windows, SysUtils, VCL.Forms, VCL.Graphics, Types, Messages, VCL.Controls, VCL.ExtCtrls,
	Activex, VCL.AxCtrls, VCL.OleCtrls, VCL.DBOleCtl,
	DMATRIXLib_TLB, FDatamatrix,
	gdich, objsx, panel;

type
	cl_datamatrix = class(TFDatamatrix)
		private
			father : TForm;
{$ifdef GALATEO_EXE}
			pbox : TGalPaintBox;
//			procedure WMKeyDown(var Message: TWMKey); message WM_KEYDOWN;
//			procedure WMKeyUp(var Message: TWMKey); message WM_KEYUP;
			procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
			procedure WMLButtonDown(var Message: TWMLButtonDOWN); message WM_LBUTTONDOWN;
			procedure WMLButtonDblclk(var Message: TWMLButtonDBLCLK); message WM_LBUTTONDBLCLK;
			procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
			procedure WMMousemove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
			procedure WMRButtonDown(var Message: TWMRButtonDOWN); message WM_RBUTTONDOWN;
			procedure WMmove(var Message: TWMMove); message WM_MOVE;
{$endif GALATEO_EXE}
		private
			str_local_name : string;
			function get_tag : integer;
			procedure set_tag(lo_tag : integer);
			function get_print_value : string;
			procedure set_print_value(s : string);
			function get_name : string;
			procedure set_name(s : string);
			function get_tipo_variabile : variabile_type;
			procedure set_tipo_variabile(tv : variabile_type);
			function rigenera_immagine : boolean;
		public
			ca : cl_common_attributes;
			bo_autosize : boolean;
			lo_true_color : TColor;							// colore VERO dell'oggetto; serve per quando è grigio perchè non visibile
//			tv_phisical : variabile_type;
//			bo_print_value_ready : boolean;
//			show : show_types;
//			i_section : section_index_type;
//			i_numero_obj : obj_index_type;
//			str_formula : string;
			property name : string read get_name write set_name;
			property str_print : string read get_print_value write set_print_value;
			property tag : integer read get_tag write set_tag;
			property tv : variabile_type read get_tipo_variabile write set_tipo_variabile;
			function assign(dm : cl_datamatrix) : cl_datamatrix;		// self := dm
			function apply_autosize : boolean;
{$ifdef GALATEO_EXE}
			procedure applica_style(obj_from : {objs_type} pointer;wo_style : word);
			procedure edit_object;
			procedure esc;
			function save(var f : text;xref : reference_obj) : boolean;
			procedure select(bo_select : boolean);
			procedure set_show_state(show : show_types);
{$endif GALATEO_EXE}
{$ifdef CASA}
			function print(vcanvas, pcanvas : TCanvas;x0,y0 : int_pixel_type;bo_video : boolean;
				ptcr : pTRect;var i_delta_y : int_pixel_type;var i_max_y_pixel : int_pixel_type;
				i_delta_y_bottom,i_margine_y_pixel : int_pixel_type;
				i_font_ridotto_size : smallint;bo_can_break_object : boolean;
				i_ph_first_page_section,i_ph_last_page_section : ph_page_type;ptr_print_section : {cl_print_section}pointer = NIL) : boolean;
{$endif}
			procedure clear_print_value;
			procedure reset_print_value;
			function get_x_left_virtuale(x_left : int_pixel_type) : int_pixel_type;
			{$ifdef GALATEO_EXE} function get_y_top_virtuale(y_top : int_pixel_type) : int_pixel_type; {$endif}
			function load(var f : text;xref : reference_obj;wo_versione : word) : boolean;
			constructor xcreate(father : TForm;ca : cl_common_attributes;i_section_1B : section_index_type;i_numero_obj : obj_index_type;bo_init_default : boolean);
			constructor create(dm : cl_datamatrix);
			destructor Destroy; override;
	end;

implementation

uses Fcommons, {$ifdef DEBUG}FAssert,{$endif} FErrMsg, FDebug, FXStrings, FStrings, FFile,
	{$ifdef GALATEO_EXE} galateo_main, datamatrix_edit, {$endif}
	galateo_debug, proc, functions, objects, misure, pages;

{$ifdef DEBUG} var i_datamatrix : integer; {$endif}

{$ifdef PRINT_WMF}
var
	wmf_picture : TPicture;
	str_wmf_filename : string;
{$endif}

constructor cl_datamatrix.create(dm : cl_datamatrix);
begin
	{$ifdef DEBUG} inc(i_datamatrix); {$endif}
	inherited create(dm.father);
	ca := cl_common_attributes.create(dm.ca.i_logical_page_ZB, dm.ca.i_section_1B, {bo_external_owned}FALSE);
	assign(dm)
end;

constructor cl_datamatrix.xcreate(father : TForm;ca : cl_common_attributes;i_section_1B : section_index_type;i_numero_obj : obj_index_type;bo_init_default : boolean);
const MBOX_RUNTIME_DEBUG_CAPTION = 'cl_datamatrix.xcreate()';
begin
	{$ifdef DEBUG} inc(i_datamatrix); {$endif}
	inc(lo_creation);
	{$ifdef RD} runtime_debug('010 start', MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01); {$endif}
	inherited create(father);
	{$ifdef RD} runtime_debug('020 after inherited create', MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01); {$endif}

	self.father := father;
//	self.i_section := i_section;
//	self.i_numero_obj := i_numero_obj;
//	attr := cl_common_attributes.create(i_section);
	self.ca := ca;
	ca.tipo_valore := VAL_TESTO;		// sempre!
	ca.tipo_oggetto := DATAMATRIX_OBJ;
	{$ifdef DLL}
		parent := general_runtime_parent;
	{$else}
		parent := panels_ZB(i_section_1B - 1);	// necesse est
		pbox := panels_ZB(i_section_1B - 1).pbox;
	{$endif}

	if bo_init_default then begin
{$ifdef GALATEO_EXE}
		left := (lo_creation * 30) mod parent.Width div 3 * 2;
		top := (lo_creation * 30) mod parent.Height div 3 * 2;
		// carico di default la stessa bitmap della barra degli strumenti
{$endif}
		Name := create_name('Datamatrix', FALSE);
		tv := DATAMATRIX_TIPO_VARIABILE_DEFAULT
	end;

	cursor := DEFAULT_CURSOR_OBJECTS;
	{$ifdef RD} runtime_debug('999', MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01) {$endif}
end;

destructor cl_datamatrix.destroy;
begin
	{$ifdef DEBUG} dec(i_datamatrix); {$endif}
	{$ifdef GALATEO_EXE} if (ca <> NIL) AND NOT ca.bo_external_owned then begin ca.free;ca := NIL end; {$endif}
	inherited
end;

function cl_datamatrix.get_name : string; begin result := str_local_name end;
procedure cl_datamatrix.set_name(s : string); begin str_local_name := s end;
function cl_datamatrix.get_x_left_virtuale(x_left: int_pixel_type): int_pixel_type; begin result := x_left end;
{$ifdef GALATEO_EXE} function cl_datamatrix.get_y_top_virtuale(y_top: int_pixel_type): int_pixel_type; begin result := y_top end; {$endif}
function cl_datamatrix.get_tag : integer; begin result := inherited tag end;

procedure cl_datamatrix.set_tag(lo_tag : integer);
begin
	ca.lo_tag := lo_tag;
	inherited tag := lo_tag
end;

function cl_datamatrix.assign(dm : cl_datamatrix) : cl_datamatrix;
begin
	TFDatamatrix(self).Assign(dm);
//	tv := dm.tv;
	ca.assign(dm.ca);
	set_name(dm.name);						// NAME è ridefinito localmente
//	show := dm.show;
//	i_section := dm.i_section;
//	i_numero_obj := dm.i_numero_obj;		// discutibile, ma assegno anche questo
	bo_autosize := dm.bo_autosize;
	lo_true_color := dm.lo_true_color;
//	str_formula := dm.str_formula;
	result := self
end;

function cl_datamatrix.load(var f : text;xref : reference_obj;wo_versione : word) : boolean;
const
	MBOX_CAPTION = 'lettura Datamatrix';
	MBOX_RUNTIME_DEBUG_CAPTION = 'cl_datamatrix.load()';
var
	s, str_debug_context : string;	//*
	fl1, fl2, fl3, fl4 : double;	//*
	i, lo1, lo2, lo3, lo4, lo5, lo6 : integer;	//*
begin
	result := TRUE;
	try
		str_debug_context := ' [obj=' + zeri(ca.i_numero_obj, 2) + '] ';
		{$ifdef RD} runtime_debug('010 start' + str_debug_context, MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01); {$endif}
		readln(f, s);set_name(s);
		str_debug_context := str_debug_context + '(' + s + ') ';
		{$ifdef RD} runtime_debug('020 name' + str_debug_context, MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01); {$endif}

		readln(f, i, fl1, fl2, fl3, fl4);
		tv := variabile_type(i);
		left := cm2pixel_video_x(fl1);top := cm2pixel_video_y(fl2);
		width := cm2pixel_video_x(fl3);height := cm2pixel_video_y(fl4);

//		readln(f, s);font.Name := s;
		readln(f, lo1, byte(bo_autosize));font.Color := lo1;

		readln(f, s);font.Style := [];
		while (s <> '') do begin
			case s[1] of
				'B' : font.Style := font.Style + [fsBold];
				'U' : font.Style := font.Style + [fsUnderline];
				'I' : font.Style := font.Style + [fsItalic];
				'S' : font.Style := font.Style + [fsStrikeout];
				else raise exception.create ('carattere imprevisto nei parametri del font')
			end;
			delete(s, 1, 1)
		end;

		readln(f, {MarginCM}fl1, {NarrowBarCM}fl2, {FixedResolutionCM}lo1, {ForeColor}lo_true_color, {BackColor}lo2,
			{ProcessTilde}lo3, {Orientation}lo4, {PreferredFormat}lo5, {EncodingMode}lo6);
		MarginCM := fl1;
		NarrowBarCM := fl2;
		FixedResolutionCM := lo1;
		ForeColor := lo_true_color;
		BackColor := lo2;
		ProcessTilde := lo3;
		Orientation := lo4;
		PreferredFormat := lo5;
		EncodingMode := lo6;

		for i := 1 to 7 do readln(f);		// free future space
		if NOT ca.load(f, wo_versione) then abort;

		readln(f, s);
		if (s <> END_OF_DATAMATRIX) then raise exception.create(OBJECT_NOT_PROPERLY_CLOSED);

//		if (ca.show = OSW_HIDE) then font.Color := COLOR_HIDDEN_OBJECTS;
{$ifdef GALATEO_EXE}
		DataToEncode := coalesce(ca.str_esempio_value, get_name);
		set_show_state(ca.show);
{$endif GALATEO_EXE}
		{$ifdef RD} runtime_debug('900' + str_debug_context, MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01) {$endif}
	except
//		result := FALSE;
		{$ifdef RD} runtime_debug('EXCEPT' + str_debug_context + get_last_exception_msg, MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01); {$endif}
		error_msg(father, 'Errore durante la lettura del file', MBOX_CAPTION);
		abort
	end;
	{$ifdef RD} runtime_debug('999' + str_debug_context, MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01) {$endif}
end;

{$ifdef GALATEO_EXE}

	function cl_datamatrix.save(var f : text;xref : reference_obj) : boolean;
	begin
		result := TRUE;
		try
			writeln(f, name);
			writeln(f, byte(tv), ' ', video2cm_x(left):0:3, ' ', video2cm_y(top):0:3, ' ', video2cm_x(width):0:3, ' ', video2cm_y(height):0:3, ' 0 0 0 0');
//			writeln(f, font.Name);
			writeln(f, Font.Color, byte(bo_autosize):2, ' 0 0 0 0');

			if (fsBold in font.style) then write(f, 'B');
			if (fsUnderline in font.style) then write(f, 'U');
			if (fsItalic in font.style) then write(f, 'I');
			if (fsStrikeout in font.style) then write(f, 'S');
			writeln(f);

			writeln(f, MarginCM:0:4, ' ', NarrowBarCM:0:4, ' ', FixedResolutionCM, ' ', {ForeColor}lo_true_color, ' ', BackColor, ' ',
				ProcessTilde, ' ', Orientation, ' ', PreferredFormat, ' ', EncodingMode, ' 0 0 0 0 0 0 0 0 0');
			for var i : smallint := 1 to 7 do writeln(f);		// free future space
			if NOT ca.save(f) then abort;
			writeln(f, END_OF_DATAMATRIX)			// tanto per chiudere il file
		except
//			result := FALSE;
			error_msg(father, 'Errore durante la scrittura del file', MBOX_CAPTION);
			abort
		end
	end;

	procedure cl_datamatrix.esc; begin end;

	procedure cl_datamatrix.applica_style(obj_from : pointer;wo_style : word);
	begin
		var objf : objs_type := objs_type(obj_from);
		if (wo_style = STYLE_ALL) then wo_style := LABEL_STYLES;

//		var dm := objf.asdatamatrix;

		if (wo_style AND STYLE_FONT <> 0) then begin
			dec(wo_style, STYLE_FONT);
			if (objf.ca.tipo_oggetto = DATAMATRIX_OBJ) then begin
{				assign_font_from(lab);
				fontcolor := lab.fontcolor;
				bo_forza_font_bold := lab.bo_forza_font_bold;
				bo_forza_font_italic := lab.bo_forza_font_italic;
				bo_forza_font_underlined := lab.bo_forza_font_underlined;
				bo_forza_font_strikeout := lab.bo_forza_font_strikeout;
				if NOT autosize AND bo_autoheight then verify_height }
			end
		end;

		if (wo_style AND STYLE_FORMATTATION <> 0) then begin
			dec(wo_style, STYLE_FORMATTATION);
			if (objf.ca.tipo_oggetto = DATAMATRIX_OBJ) then begin
{				alignment := lab.alignment;bo_giustificato := lab.bo_giustificato;
				str_datetime_format := lab.str_datetime_format;
				bo_centrato := lab.bo_centrato;
				bo_switch_fontstyle := lab.bo_switch_fontstyle;
				bo_blank_if_zero := lab.bo_blank_if_zero;
				show := lab.show;
//				font.Color := lab.font.Color;
				lo_color := lab.lo_color;
				bo_autoheight := lab.bo_autoheight;
				bo_multiline := lab.bo_multiline;
				fl_cm_interlinea := lab.fl_cm_interlinea;
				bo_riduci_if_necessario := lab.bo_riduci_if_necessario;
				i_minimum_size_auto := lab.i_minimum_size_auto;
				ca.assign(lab.attr);
				bo_suppress_blank := lab.bo_suppress_blank;
//				bo_insert_line_if_multiline := lab.bo_insert_line_if_multiline
}			end
		end;

		if (wo_style AND STYLE_VALUES <> 0) then begin
			{$ifdef DEBUG} dec(wo_style,STYLE_VALUES); {$endif}
			if (objf.ca.tipo_oggetto = DATAMATRIX_OBJ) then begin
{				str_formula := lab.str_formula;
//				tipo_valore := lab.tipo_valore;
//				tipovar := lab.tipovar;
//				str_db_colonna := lab.str_db_colonna;
				str_esempio_value := lab.str_esempio_value }
			end
		end;

		{$ifdef DEBUG} assert(wo_style = 0,'cl_datamatrix.applica_style()') {$endif}
	end;

	procedure cl_datamatrix.set_show_state(show : show_types);
	begin
		if (show = OSW_HIDE) then forecolor := computer_registry_data.lo_hidden_objects_color
		else {if (self.show = OSW_HIDE) then} forecolor := lo_true_color;
		visible := (show <> OSW_HIDE) OR globale.bo_show_hidden_objects;
		ca.show := show
	end;

	procedure cl_datamatrix.edit_object;
	begin
		var bo_was_selected := (get_selected_obj_index(0) = ca.i_numero_obj);
		if bo_was_selected then obj_select(0, FALSE, FALSE);
		if datamatrix_edit_proc(father, self) then begin
			set_global_modified;
			apply_autosize;
			DataToEncode := coalesce(ca.str_esempio_value, get_name);
			set_show_state(ca.show)	// nel caso sia stato modificato
		end;
		if bo_was_selected then obj_select(ca.i_numero_obj, TRUE, FALSE)
	end;

	procedure cl_datamatrix.select(bo_select: boolean);
	begin
		if (bo_select = ca.bo_selected) then exit;	// non cambia nulla
{		if (bo_select AND (width >= pbox.Width)) then begin
			MessageBBox(father.handle,'Oggetto troppo grande per l''attuale formato di visualizzazione.' + ACAPO2 +
				'Lo riduco alla massima dimensione accettabile.', MBOX_CAPTION, MB_ICONSTOP);
			autosize := TRUE;left := 1;
//			while (width > 0) AND (width >= pbox.Width) do font.size := font.size-1
			while (width > 0) AND (width >= pbox.Width) do fontsize := fontsize - 1
		end;}

		var lo : integer := ForeColor;ForeColor := BackColor;BackColor := lo;
		ca.bo_selected := bo_select
	end;

	procedure cl_datamatrix.WMLButtonDblclk(var Message: TWMLButtonDBLCLK); begin {$ifdef GALATEO_EXE} edit_object {$endif} end;
	procedure cl_datamatrix.WMPaint(var Message: TWMPaint); begin inherited end;
	procedure cl_datamatrix.WMLButtonUp(var Message: TWMLButtonUp); begin dd.dragging_mouse_up end;
	procedure cl_datamatrix.WMMousemove(var Message: TWMMouseMove); begin dd.dragging_Mousemove(self, message.xpos+left, message.ypos+top) end;
//	procedure cl_datamatrix.WMKeyDown(var Message: TWMKey); begin message.result := 1 end;
//	procedure cl_datamatrix.WMKeyUp(var Message: TWMKey); begin message.result := 1 end;

	procedure cl_datamatrix.WMLButtonDown(var Message: TWMLButtonDOWN);
	begin
		var i_obj : obj_index_type := get_related_obj([], ca.i_section_1B, message.xpos+left, message.ypos+top, {bo_unselected_before}FALSE, {bo_area_minima}TRUE);
		{$ifdef DEBUG} assert(i_obj <> 0,'ORPOLETTA 5580'); {$endif}
		dd.bo_resizing_horz := (cursor = crSizeWE);
		dd.bo_resizing_vert := (cursor = crSizeNS);
		select_checking_keys(i_obj)
	end;

	procedure cl_datamatrix.WMmove(var Message : TWMMove);
	begin
		var ox : objs_type := tag2object(tag);
		if (ox <> NIL) then ox.on_change_size_and_pos
	end;

	procedure cl_datamatrix.WMRButtonDown(var Message : TWMRButtonDOWN);
	begin
		var i_obj : obj_index_type := get_related_obj([], ca.i_section_1B, message.xpos+left, message.ypos+top, FALSE, TRUE);
		select_checking_keys(i_obj);
		var p : TPoint := ClientToScreen(Point(message.xpos,message.ypos));
		GM.popup_object.popup(p.x, p.y)
	end;

{$endif}

procedure cl_datamatrix.reset_print_value;
begin
	ca.bo_print_value_ready := FALSE;
	strcopy(ca.lp_print, '')
//*	str_print := ''
//	dbl_print_value_phisical := NUMERIC_NULL_VALUE
end;

procedure cl_datamatrix.clear_print_value;
begin
//	ca.bo_print_value_ready := FALSE;strcopy(ca.lp_print, '')
	reset_print_value
end;

function cl_datamatrix.get_tipo_variabile : variabile_type;
begin
	{$ifdef DEBUG} assert(ca.tipo_variabile in DATAMATRIX_TIPI_VARIABILI, 'GET_tipo_variabile() -- tipo_variabile errato = <' + TV_DESCRIZIONE[ca.tipo_variabile] + '>'); {$endif}
	result := ca.tipo_variabile
end;

procedure cl_datamatrix.set_tipo_variabile(tv : variabile_type);
begin
	{$ifdef DEBUG} assert(tv in DATAMATRIX_TIPI_VARIABILI, 'SET_tipo_variabile() -- tipo_variabile errato = <' + TV_DESCRIZIONE[tv] + '>'); {$endif}
	ca.tipo_variabile := tv
end;

function cl_datamatrix.get_print_value : string;
begin
	result := ca.get_print_value
end;
(*function cl_datamatrix.get_print_value : string;
var
	ox : objs_type;
	s, str_result : string;
	tipo_res : risultato_type;
begin
	if NOT bo_print_value_ready then begin
		try
			case ca.tipo_variabile of
				TV_BLANK : {$ifdef DEBUG} assert(FALSE, 'TIPOVAR = TV_BLANK') {$endif};
				TV_STATIC_TEXT : set_print_value(caption);
				TV_DB_FIELD : ;
				TV_PARAMETRO, TV_SQL_SELECT_BEFORE_SQL, TV_SQL_SELECT_BEFORE_RUNTIME : {$ifdef GALATEO_EXE} set_print_value(ca.str_esempio_value) {$endif};
				TV_GROUP_EXPR_SQL : ;
				TV_SQL_SELECT : ;
				TV_FORMULA : begin
{$define OLD}
{$ifdef OLD}
//					tipo_res := VAL_BOH;			// cosi' fino al 2006-02-10
					tipo_res := ca.tipo_valore;	// dal 2006-02-11: io so il tipo di risultato che la funzione deve rendere!
					s := ca.str_formula;
//MessagebbOX(0, str_formula, 'XXXXXXXXXX'); 	{$ifndef DEBUG} *** {$endif}
					s := translate_local_macros(s);	// 2005-06-20
					sections(ca.i_section).interpreta_string(s, {bo_stampa_vera}FALSE, {bo_check_errors}TRUE);	// 2005-04-10
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
//	if (tipo_oggetto in [xxFORMULA, xxVARIABILE]) AND (tipo_valore = VAL_NUMERO) AND (dbl_print_value_phisical = NULL_VALUE)
	if (ca.tipo_variabile <> TV_STATIC_TEXT) AND (ca.tipo_valore = VAL_NUMERO) AND (dbl_print_value_phisical = NULL_VALUE)
		then applica_formato_numerico;
	result := strpas(lp_print)
end;	*)

procedure cl_datamatrix.set_print_value(s : string);
begin
	ca.set_print_value(s)
end;
(*procedure cl_datamatrix.set_print_value(s : string);
begin
	strcpychks(lp_print,s);//lp_print_left := NIL;
	applica_formato_numerico;
	bo_print_value_ready := TRUE;
//	if bo_store_variabile AND (globale.fase_stampa = FASE_STAMPA_ASSEGNAZIONE_STORED_VALUES[tipo_oggetto]) then store_value
	if bo_store_variabile AND (globale.fase_stampa = FASE_STAMPA_ASSEGNAZIONE_STORED_VALUES[ca.tipo_variabile]) then store_value
end;	*)

function cl_datamatrix.rigenera_immagine : boolean;
// rigenera l'immagine in base ai parametri attuali
const MBOX_RUNTIME_DEBUG_CAPTION = 'cl_datamatrix.rigenera_immagine()';
begin
{$ifdef CASA}
	var str_debug_context := ' [' + str_local_name + ' -- obj=' + zeri(ca.i_numero_obj, 2) + '] ';
	{$ifdef RD} runtime_debug('010 before SaveEnhWMF' + str_debug_context, MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01); {$endif}
	SaveEnhWMF(str_wmf_filename);	// il modo è una schifezza, e ancor m'offende, ma non ho trovato di meglio
	{$ifdef RD} runtime_debug('020 after SaveEnhWMF' + str_debug_context, MBOX_RUNTIME_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01); {$endif}
{$endif CASA}
{repaint;
x := GetXPixels;y := GetYPixels;
changed;
x := GetXPixels;y := GetYPixels;
createcontrol;
x := GetXPixels;y := GetYPixels;
initcontroldata;
x := GetXPixels;y := GetYPixels;
///////////////////onchanged;
x := GetXPixels;y := GetYPixels;
showobject;
x := GetXPixels;y := GetYPixels;
oncontrolinfochanged;
x := GetXPixels;y := GetYPixels;
picturechanged(self);
x := GetXPixels;y := GetYPixels;
/////////////initcontrolinterface(;	// ???
x := GetXPixels;y := GetYPixels;
doobjectverb(0);
x := GetXPixels;y := GetYPixels;
doobjectverb(1);
x := GetXPixels;y := GetYPixels;
doobjectverb(2);
x := GetXPixels;y := GetYPixels;
doobjectverb(3);
x := GetXPixels;y := GetYPixels;
doobjectverb(4);
x := GetXPixels;y := GetYPixels;
doobjectverb(5);
x := GetXPixels;y := GetYPixels;
doobjectverb(6);
x := GetXPixels;y := GetYPixels;
doobjectverb(7);
x := GetXPixels;y := GetYPixels; }
//showaboutbox;
{x := GetXPixels;y := GetYPixels;
doublebuffered := FALSE;
x := GetXPixels;y := GetYPixels;
doublebuffered := TRUE;
x := GetXPixels;y := GetYPixels;
doublebuffered := FALSE;
x := GetXPixels;y := GetYPixels;
doublebuffered := TRUE;
x := GetXPixels;y := GetYPixels;
adjustsize;
x := GetXPixels;y := GetYPixels;
invalidate;
x := GetXPixels;y := GetYPixels; }
//************************************paintto(canvas, 0, 0);
{x := GetXPixels;y := GetYPixels;
realign;
x := GetXPixels;y := GetYPixels;
updatecontrolstate;
x := GetXPixels;y := GetYPixels;
resize; }
	result := TRUE		// significa pochino, ma serve ad evitare la warning
end;

function cl_datamatrix.apply_autosize : boolean;
// ricalcola la dimensione dell'immagine; rende TRUE se la dimensione viene modificata, FALSE se rimane invariata
begin
	result := FALSE;
	if NOT bo_autosize then exit;
	rigenera_immagine;
	var x : int_pixel_type := GetXPixels;
	var y : int_pixel_type := GetYPixels;
	if (x <> width) OR (y <> height) then begin
		height := y;width := x;
		result := TRUE
	end
end;

{$ifdef CASA}
function cl_datamatrix.print(vcanvas, pcanvas: TCanvas; x0, y0: int_pixel_type; bo_video: boolean; ptcr: pTRect;
	var i_delta_y, i_max_y_pixel: int_pixel_type; i_delta_y_bottom, i_margine_y_pixel: int_pixel_type; i_font_ridotto_size: smallint;
	bo_can_break_object: boolean; i_ph_first_page_section, i_ph_last_page_section: ph_page_type; ptr_print_section: pointer): boolean;
const MBOX_CAPTION_DEBUG = 'datamatrix print()';
var
	r : TRect;
	canvas : TCanvas;
begin
	result := TRUE;

	if globale.bo_text_only then exit;	// non stampo, se non sono in grafica
	if bo_video then canvas := vcanvas else canvas := pcanvas;
	DataToEncode := get_print_value;
	runtime_debug('obj ' + ca.i_numero_obj.ToString + ' ' + get_name + ' - DataToEncode=' + DataToEncode, MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);

	{$ifdef DEBUG} assert(NOT object_is_hidden(ca.show, get_virtual_printing_page,
		ca.i_section_1B, i_ph_first_page_section, i_ph_last_page_section, TRUE), 'printing hidden object -- DAKY 4391'); {$endif}
	if NOT ca.bo_posizione_fissa then inc(y0, i_delta_y);

	if bo_autosize then rigenera_immagine;	// faccio ricalcolare la dimensione dell'oggetto da stampare

	if bo_video then begin
{$ifdef PRINT_WMF}
		r.Left := x0 + round(left * tm.r_fattore_zoom);
		r.Top := y0 + round(top * tm.r_fattore_zoom);
		if bo_autosize then begin
			r.Right := x0 + round((left + GetXPixels) * tm.r_fattore_zoom);
			r.Bottom := y0 + round((top + GetYPixels) * tm.r_fattore_zoom)
		end
		else begin
			r.Right := x0 + round((left + width) * tm.r_fattore_zoom);
			r.Bottom := y0 + round((top + height) * tm.r_fattore_zoom)
		end
{$else}
		r.Left := x0 + round(left * tm.r_fattore_zoom);r.Top := y0 + round(top * tm.r_fattore_zoom);
		r.Right := x0 + round(({left+}width) * tm.r_fattore_zoom);r.Bottom := {y0 +} round(({top+}height) * tm.r_fattore_zoom)
{$endif PRINT_WMF}
	end
	else begin
{$ifdef PRINT_WMF}
		r.Left := x0 + tm.video2print_pixel_x(left);r.Top := y0 + tm.video2print_pixel_y(top);
		if bo_autosize then begin
			r.Right := x0 + tm.video2print_pixel_x(left + GetXPixels);
			r.Bottom := y0 + tm.video2print_pixel_y(top + GetYPixels)
		end
		else begin
			r.Right := x0 + tm.video2print_pixel_x(left + width);
			r.Bottom := y0 + tm.video2print_pixel_y(top + height)
		end
{$else}
		***
{$endif PRINT_WMF}
	end;
	// gestione ridimensionamento della sezione per immagini grandi
	if (i_margine_y_pixel <> 0) then begin
		i_margine_y_pixel := tm.video2print_pixel_y(i_margine_y_pixel);
		if (r.Bottom > i_margine_y_pixel - y0) then i_max_y_pixel := r.Bottom - y0;
//		if ca.bo_move_obj_sottostanti then i_delta_y := (r.Bottom - r.Top) - i_height_originale_video_pixel
	end;

{$ifdef PRINT_WMF}
	SaveEnhWMF(str_wmf_filename);
	wmf_picture.LoadFromFile(str_wmf_filename);
//	wmf_picture.Assign(picture);
	canvas.stretchdraw(r, wmf_picture.Graphic);
//	canvas.Font.Name := 'arial';canvas.Font.Size := 6;canvas.TextOut(r.Left, r.Bottom, datatoencode);
{$else}
	canvas.stretchdraw(r, picture.Graphic);
//	PaintTo(canvas, r.Left, r.Top);		FUNZIONA ma ovviamente non ridimensiona l'immagine secondo necessità
//	;canvas.Font.Size := 6;
//	canvas.TextOut(x0+r.Left, r.Top+r.Bottom+5, datatoencode);
{$endif PRINT_WMF}

{	bmp := TBitmap.create;
	bmp.Assign(picture.Graphic);
	canvas.stretchdraw(r, bmp.);
	bmp.Free; }
{	image := TImage.create(parent);
	image.picture.Assign(picture);
	canvas.stretchdraw(r, image.picture.graphic);
	image.Free; }
{	x := TPicture.create;
	x.Assign(picture);
	r.Left := r.Left + 100;
	canvas.stretchdraw(r, x.graphic);
	x.bitmap.SaveToFile('E:\TEMP\xxx\' + dataToEncode + '.bmp');
	x.Free; }

////	picture.Bitmap.SaveToClipboardFormat(AFormat, AData, APalette);clipboard.SetAsHandle(aformat, adata);
////	picture.SaveToFile('E:\TEMP\xxx\' + dataToEncode + '.pic');
////	picture.Bitmap.SaveToFile('E:\TEMP\xxx\' + dataToEncode);
////	picture.Graphic.SaveToFile('E:\TEMP\xxx\' + dataToEncode);
//	;SaveEnhWMF('E:\TEMP\xxx\' + dataToEncode + '.wmf');		{$ifndef DEBUG} *** {$endif}
end;
{$endif CASA}

initialization
	galateo_initialization_debug('datamatrix_unit');
	CoInitialize(NIL);
{$ifdef PRINT_WMF}
	wmf_picture := TPicture.create;
	str_wmf_filename := TEMP_FILENAME(WMF_EXT)
{$endif PRINT_WMF}
finalization
	galateo_finalization_debug('datamatrix_unit');
	CoUnInitialize;
	{$ifdef DEBUG} CCI(i_datamatrix, 'cl_datamatrix', 'datamatrix_unit') {$endif}
end.
