unit bmps;		//*

{$I defines}

interface

uses Windows, VCL.ExtCtrls, VCL.Graphics, Classes, VCL.Forms, Messages, SysUtils, Types, Math, VCL.Controls,
	{$ifndef DLL} panel, {$endif}
	gdich, objsx;

type
	cl_bmp = class(TImage)
		public
//			i_numero_obj : obj_index_type;
//			i_section : section_index_type;
//			show : show_types;
			ca : cl_common_attributes;
			str_immagine_dinamica : string;	// valore dell'immagine caricata dinamicamente
			bo_sfondo_design_time : boolean;			// oggetto utilizzabile solo a design-time, sfondo utile per costruire il report
{$ifdef GALATEO_EXE}
			bo_mantieni_proporzioni : boolean;
			fl_original_ratio : double;		// rapporto (X/Y) tra le dimensioni dell'immagine originale
{$endif}
			bo_autosize_immagine_dinamica : boolean;
			bo_cannot_exceed_original_size : boolean;
			autoresize_align_horz : horz_align_type;
			autoresize_align_vert : vert_align_type;
			bo_image_dinamica_should_exist, bo_image_dinamica_must_exist : boolean;
			str_immagini_inesistenti : string;		// per la generazione dei msg di errore
			original_picture : TPicture;
			resized_images : TStringList;
			constructor xcreate(form : TForm;ca : cl_common_attributes;i_section_1B : section_index_type;i_obj : obj_index_type;bo_init_default : boolean); overload;
			{$ifdef GALATEO_EXE} constructor xcreate(bmp_source : cl_bmp); overload; {$endif}
			procedure free;		// fino a 2011-05-10
//			destructor destroy; override;
{$ifdef GALATEO_EXE}
			procedure applica_style(obj_from : {objs_type}Pointer;wo_style : word);
			procedure esc;
			procedure edit_object;
			function save(var f : text;xref : reference_obj) : boolean;
			procedure select(bo_select : boolean);
			procedure assign_data(bmp_source : cl_bmp);		// copia i soli dati, non i campi 'attivi' (ad esempio non copia: father, handles, ...)
			{$ifdef DEBUG} procedure assign(a : char);  reintroduce; {$endif}		// per inibire l'uso della funzione base ASSIGN()
{$endif}
			function load_file(str_filename : string;
				bo_load_immagine_dinamica : boolean;	// TRUE se sto caricando un'immagine dinamica durante l'esecuzione, FALSE se sto caricando un'immagine in fase di editing
				bo_autosize : boolean = TRUE;bo_cannot_exceed_original_size : boolean = FALSE) : boolean;
			function get_x_left_virtuale(x_left : int_pixel_type) : int_pixel_type;
			{$ifdef GALATEO_EXE} function get_y_top_virtuale(y_top : int_pixel_type) : int_pixel_type; {$endif}
			function load(var f : text;xref : reference_obj;wo_versione : word) : boolean;
			function get_name : string;
			function set_name(str_nome : string) : string;
{$ifdef CASA}
			function print(vcanvas,pcanvas : TCanvas;x0,y0 : int_pixel_type;bo_video : boolean;
				ptcr : pTRect;var i_delta_y : int_pixel_type;var i_max_y_pixel : int_pixel_type;
				i_delta_y_bottom,i_margine_y_pixel : int_pixel_type;
				i_font_ridotto_size : smallint;bo_can_break_object : boolean;
				i_ph_first_page_section,i_ph_last_page_section : ph_page_type;ptr_print_section : {cl_print_section}pointer = NIL) : boolean;
{$endif CASA}
		private
			father : TForm;
			i_max_height, i_max_width : integer;
			i_height_originale_video_pixel : integer;	// altezza originale dell'oggetto; serve per gestire il ridimensionamento
			i_original_width, i_original_height : int_pixel_type;
			i_left_originale, i_top_originale : int_pixel_type;
			{$ifdef GALATEO_EXE}
				pbox : TGalPaintBox;
				procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
				procedure WMLButtonDown(var Message: TWMLButtonDOWN); message WM_LBUTTONDOWN;
				procedure WMLButtonDblclk(var Message: TWMLButtonDBLCLK); message WM_LBUTTONDBLCLK;
				procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
				procedure WMMousemove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
				procedure WMRButtonDown(var Message: TWMRButtonDOWN); message WM_RBUTTONDOWN;
				procedure WMmove(var Message: TWMMove); message WM_MOVE;
			{$endif}
			procedure init_default(bo_init_default : boolean);
			procedure applica_opzioni_bmp;
	end;

implementation

uses Fassert, Fdebug, FErrMsg, FSQLsoft, FFile, FMessage, FSystem_base, FSystem,
	galateo_debug, Fcommons, {powerarc,} FCompress, proc,
	{$ifdef GALATEO_EXE} galateo_main, bmp_dialog, {$endif}
	misure, objects, pages;

const
	RLE_CHAR_BASE = 27;	// primo carattere utilizzabile per la dimensione della sequenza
	RLE_CHAR_LAST = 255;	// ultimo carattere utilizzabile per la dimensione della sequenza
	RLE_MAX_LEN_SEQUENZA = RLE_CHAR_LAST - RLE_CHAR_BASE + 1;

	UNCOMPRESSED_BITMAP = 'UN';
	COMPRESSED_BITMAP = 'Z0';	// zeta zero

{$ifdef DEBUG} var i_bmps : integer; {$endif}

function hex2fast(c : byte) : string;
{ funzione che converte il byte in due bytes esadecimali;
  per velocificare la codifica e la decodifica le cifre sono rappresentate dalle lettere A..P }
begin
	result := char(byte('A') + c div 16) + char(byte('A') + c mod 16)
//	result := shortString(char(byte('A') + c div 16) + char(byte('A') + c mod 16))
end;

function fast2hex(s : string) : byte;
// che usa la funzione deve garantire che entrambe le cifre sono riempite
begin
	{$ifdef DEBUG} assert(s.Length = 2, 'fast2hex().Length = ' + s.Length.ToString + ' -- LPXX 3911'); {$endif}
	result := (byte(s[1]) - byte('A')) * 16 + (byte(s[2]) - byte('A'))
end;

{$ifdef GALATEO_EXE}

	function write_compressed_bitmap(father : TForm;var f : text;Picture : TPicture;str_image_name : string) : boolean;
	{ scrive la bitmap sul file F; rende TRUE in caso di successo;
	  priva di scrivere comprime l'immagine }
	begin
//		result := FALSE;
//		in_stream := NIL;out_stream := NIL;
		var stream : TMemoryStream := NIL;
		try
//			in_stream := TMemoryStream.create;out_stream := TMemoryStream.create;
			stream := TMemoryStream.create;
			picture.bitmap.savetostream(stream);
//			stream.position := 0;	// torno da capo
//			if NOT PowerarcCompress(in_Stream,Out_Stream,IPOWERBZIP) then
//			if NOT fCompress_proc(in_Stream, Out_Stream, IPOWERBZIP) then
			if NOT fCompress_proc(father, stream) then
				raise exception.create('errore durante la compressione dell''immagine ' + uppercase(str_image_name));
			writeln(f, stream.size);
			writeln(f, COMPRESSED_BITMAP);	// tipo di codifica
			writeln(f);	// un po' di spazio libero per eventuali opzioni
			stream.position := 0;	// torno da capo
//			for i := 0 to out_stream.size-1 do write(f, hex2fast(byte(LPSTR(out_stream.memory)[i])));
			for var i : integer := 0 to stream.size-1 do write(f, hex2fast(byte(PBYTE(stream.memory)[i])));
			writeln(f);
			result := TRUE
		finally
//			if (in_stream <> NIL) then in_stream.free;if (out_stream <> NIL) then out_stream.free
			if (stream <> NIL) then stream.free
		end
	end;

	function write_uncompressed_bitmap(var f : text;Picture : TPicture) : boolean;
	{ scrive la bitmap sul file F; rende TRUE in caso di successo;
	  utilizzando una formula di compressione RLE style;
	  scrive la bitmap come sequenza di gruppi di 3 bytes:
			#1: lunghezza della sequenza - 1  (0 per 1 carattere, 1 per 2 caratteri, e cosi' via)
			#2#3: valore esadecimale (in formato testo) }
	const BUFFER_SIZE = 4096;
	type buffer_type = array[1..BUFFER_SIZE+1] of byte;
	var
		i,j : integer;
		wo_read : integer;
		fx : file;
		pt : ^buffer_type;
		c : byte;
		str_filename : string;
	begin
		pt := NIL;
		try
			str_filename := TEMP_FILENAME(BMP_EXT);
			try
				picture.bitmap.savetofile(str_filename);
				system.assign(fx,str_filename);reset(fx,1);
				writeln(f, filesize(fx));	// scrivo la dimensione del file; non è la dimensione fisica, ma quella teorica
				writeln(f, UNCOMPRESSED_BITMAP);	// tipo di codifica
				writeln(f);	// un po' di spazio libero per eventuali opzioni
				new(pt);
				repeat
					blockread(fx,pt^,BUFFER_SIZE,wo_read);
					if (wo_read > 0) then pt^[wo_read+1] := NOT pt^[wo_read];	// rompo la sequenza sull'ultimo carattere; evito di dover controllare ogni volta
					i := 1;
					while (i <= wo_read) do begin
						c := pt^[i];j := i+1;
						while (j <= RLE_MAX_LEN_SEQUENZA) AND (pt^[j] = c) do inc(j);
						write(f, char(RLE_CHAR_BASE+(j-i-1)), hex2fast(c));
						i := j
					end;
				until (wo_read = 0);
				writeln(f)
			finally
				{$I-}
				close(fx);if (IOresult = 0) then;
				erase(fx);if (IOresult = 0) then;
				{$I+}
			end;
			result := TRUE
		except
			result := FALSE
		end;
		if (pt <> NIL) then dispose(pt)
	end;

{$endif}

function read_uncompressed_bitmap(var f : text;Picture : TPicture;wo_versione : word;i_filesize : integer = 0) : boolean;
{ legge la bitmap; rende TRUE in caso di successo;
  se I_FILESIZE = 0 la size del file si trova sulla prima riga del file F; altrimenti è già stata letta }
const BUFFER_SIZE = 4096;
type buffer_type = array[1..BUFFER_SIZE] of byte;
var
	i : integer;
	i_len, j, x : byte;
	fx : file;
	wo_written : integer;
	pt : ^buffer_type;
	c : char;
	str_hex : string[2];
	str_filename : string;
//	lo_tick,lo_chars: integer;
begin
	pt := NIL;
	try
		new(pt);
		if (i_filesize = 0) then readln(f, i_filesize);	// leggo la dimensione del file (altrimenti è già stata letta)
		str_filename := TEMP_FILENAME(BMP_EXT);
		try
			system.assign(fx, str_filename);rewrite(fx, 1);
	//		lo_tick := gettickCount;lo_chars := 0;
			repeat
				if (wo_versione <= $0103) then begin	// vecchia versione
					i := 0;
					while (i < i_filesize) AND (i < BUFFER_SIZE) do begin inc(i);read(f, pt^[i]) end
				end
				else begin	// new version, RLE compression (ah ah ha, che compressione!!!)
					i := 0;
					while (i < i_filesize) AND (i < BUFFER_SIZE) do begin
						read(f, c, str_hex);
						x := fast2hex(string(str_hex));i_len := byte(c) - RLE_CHAR_BASE + 1;
						for j := 1 to i_len do pt^[i+j] := x;
						inc(i, i_len);
	//					inc(lo_chars)
					end
				end;
				dec(i_filesize, i);blockwrite(fx,pt^, i, wo_written);
				if (wo_written <> i) then abort
			until (i = 0);
//			strMessageBBox(0,inttostr(gettickCount-lo_tick) + ACAPO2 + puntato(lo_chars)+' different chars','bmp test'0);
			close(fx);readln(f);
			picture.loadfromfile(str_filename)
		finally
			{$I-}
			close(fx);if (IOresult = 0) then;
			erase(fx);if (IOresult = 0) then;
			{$I-}
		end;
		result := TRUE
	except
		result := FALSE
	end;
	if (pt <> NIL) then dispose(pt)
end;

{$define _____OLD_WAY}
function read_compressed_bitmap(var f : text;Picture : TPicture;wo_versione : word;str_image_name : string) : boolean;
// legge la bitmap; rende TRUE in caso di successo
var
	s : string;
	i, i_size : integer;
	{$ifdef OLD_WAY} str_hex : string[2]; {$endif}
begin
//	result := FALSE;
	var stream : TMemoryStream := NIL;
	try
		readln(f, i_size);readln(f, s);readln(f);
		if (s = UNCOMPRESSED_BITMAP) then begin
			result := read_uncompressed_bitmap(f, Picture, wo_versione, i_size);
			exit
		end;
		{$ifdef DEBUG} assert(s = COMPRESSED_BITMAP, 'DJHD 9231'); {$endif}
		stream := TMemoryStream.create;
		stream.SetSize(i_size);

{$ifdef OLD_WAY}
		for i := 0 to i_size - 1 do begin
			read(f, str_hex);
//			byte(LPSTR(in_stream.memory)[i]) := fast2hex(str_hex)
//			LPSTR(in_stream.memory)[i] := char(fast2hex(str_hex))	*** D6
			PByte(stream.memory)[i] := fast2hex(str_hex)
		end;
		readln(f);
{$else}
		readln(f, s);
		{$ifdef DEBUG} assert(s.Length = i_size * 2, 'read_compressed_bitmap() -- length attesa = ' + i_size.ToString + ' -- reale = ' + s.Length.ToString); {$endif}
//		start_timer;
//		for i := 0 to i_size - 1 do PByte(stream.memory)[i] := fast2hex(s[i*2+1] + s[i*2+2]);	*** più lento
		for i := 0 to i_size - 1 do PByte(stream.memory)[i] := fast2hex(copy(s, i*2+1, 2));
//		ss := delta_timer_msec(0).ToString;application.MessageBox(pchar(ss), 'AAAAAAAAAA', 0);
{$endif}

//		if NOT PowerArcDecompress(In_Stream, Out_Stream) then
//		if NOT fDeCompress_proc(In_Stream, Out_Stream) then
		if NOT fDeCompress_proc(NIL, stream) then
			raise exception.create('errore durante la decompressione dell''immagine ' + uppercase(str_image_name));
		picture.bitmap.LoadFromStream(stream);

		result := TRUE
	finally
		if (stream <> NIL) then stream.free
	end
end;

constructor cl_bmp.xcreate(form : TForm;ca : cl_common_attributes;i_section_1B : section_index_type;i_obj : obj_index_type;bo_init_default : boolean);
begin
	inherited create({$ifdef DLL}NIL{$else}panels_ZB(i_section_1B - 1){$endif});
	self.ca := ca;
{$ifdef GALATEO_EXE}
	parent := panels_ZB(i_section_1B - 1);	// non è inutile !!!
	pbox := panels_ZB(i_section_1B - 1).pbox;
{$endif}
	self.father := form;
	ca.i_section_1B := i_section_1B;
	init_default(bo_init_default)
end;

{$ifdef GALATEO_EXE}
	constructor cl_bmp.xcreate(bmp_source : cl_bmp);
	begin
		var i_section_1B : section_index_type := bmp_source.ca.i_section_1B;
		inherited create({$ifdef DLL}NIL{$else}panels_ZB(i_section_1B - 1){$endif});
		ca := cl_common_attributes.create(bmp_source.ca.i_logical_page_ZB, i_section_1B, {bo_external_owned}TRUE);
		init_default(FALSE);
		self.father := bmp_source.father;
		ca.i_section_1B := i_section_1B ;
		parent := panels_ZB(i_section_1B - 1);	// non è inutile !!!
		pbox := panels_ZB(i_section_1B - 1).pbox;
		assign_data(bmp_source)
	end;
{$endif}

procedure cl_bmp.init_default(bo_init_default : boolean);
begin
	{$ifdef DEBUG} assert(ca <> NIL, 'CA is NIL'); {$endif}
	{$ifdef DEBUG} inc(i_bmps); {$endif}
	ca.tipo_oggetto := OBJ_BITMAP;
//	cursor := DEFAULT_CURSOR_OBJECTS;
	tag := get_new_tag;
	showhint := TRUE;hint := 'Per spostarmi schiaccia e trascina';
	resized_images := TStringList.create;
	inc(lo_creation);
	if bo_init_default then begin
{$ifdef GALATEO_EXE}
		left := (lo_creation * 30) mod parent.Width div 3 * 2;
		top := (lo_creation * 30) mod parent.Height div 3 * 2;
		// carico di default la stessa bitmap della barra degli strumenti
		picture.bitmap.assign(GM.btn_new_image.glyph);
{$endif NOT DLL}
		Caption := create_name('immagine',FALSE)
	end;
	bo_sfondo_design_time := FALSE;
	applica_opzioni_bmp;
	{$ifdef GALATEO_EXE} bo_mantieni_proporzioni := TRUE; {$endif}		// default attivata: è sempre molto comoda!
	Autosize := TRUE;Autosize := FALSE;		// entrambi necessarî
	Stretch := TRUE
end;

procedure cl_bmp.free;
//destructor cl_bmp.destroy;
begin
	{$ifdef DEBUG} dec(i_bmps); {$endif}
//	if (attr <> NIL) then begin attr.free;attr := NIL end;
	inherited		// 2011-05-10, prima non c'era
end;

function cl_bmp.get_name : string; begin result := caption end;
function cl_bmp.set_name(str_nome : string) : string; begin caption := str_nome end;

{$ifdef CASA}
function cl_bmp.print(vcanvas,pcanvas : TCanvas;x0,y0 : int_pixel_type;bo_video : boolean;
	ptcr : pTRect;var i_delta_y : int_pixel_type;var i_max_y_pixel : int_pixel_type;
	i_delta_y_bottom,i_margine_y_pixel : int_pixel_type;i_font_ridotto_size : smallint;
	bo_can_break_object : boolean;i_ph_first_page_section,i_ph_last_page_section : ph_page_type;
	ptr_print_section : {cl_print_section}pointer = NIL) : boolean;
// vedi commento generale in OBJECTS su PRINT_PROC_TYPE
var
	r : TRect;
	canvas : TCanvas;
begin
	result := TRUE;
//	if obj.is_hidden(show,get_phisical_printing_page) then exit;	SPOSTATO NELLA STAMPA_OBJ
	{$ifdef DEBUG} assert(NOT object_is_hidden(ca.show, get_virtual_printing_page,
		ca.i_section_1B, i_ph_first_page_section, i_ph_last_page_section, TRUE),'AKY 293'); {$endif}
	if NOT ca.bo_posizione_fissa then inc(y0, i_delta_y);

	if globale.bo_text_only then exit;		// non stampo, se non sono in grafica
	if bo_sfondo_design_time then exit;		// non stampo, se solo sfondo design-time

	if bo_video then begin
		r.Left := x0 + round(left * tm.r_fattore_zoom);
		r.Top := y0 + round(top * tm.r_fattore_zoom);
		r.Right := x0 + round((left+width) * tm.r_fattore_zoom);
		r.Bottom := y0 + round((top+height) * tm.r_fattore_zoom)
	end
	else begin
		r.Left := x0 + tm.video2print_pixel_x(left);
		r.Top := y0 + tm.video2print_pixel_y(top);
		r.Right := x0 + tm.video2print_pixel_x(left + width);
		r.Bottom := y0 + tm.video2print_pixel_y(top + height)
	end;
	// gestione ridimensionamento della sezione per immagini grandi
	if (i_margine_y_pixel <> 0) then begin
		i_margine_y_pixel := tm.video2print_pixel_y(i_margine_y_pixel);
		if (r.Bottom > i_margine_y_pixel - y0) then i_max_y_pixel := r.Bottom - y0;
		if ca.bo_move_obj_sottostanti then i_delta_y := (r.Bottom - r.Top) - i_height_originale_video_pixel
	end;

(*		var i_delta_y : int_pixel_type;
			{ INPUT: scostamento verticale dalla posizione originale dell'oggetto;
			  OUTPUT: scostamento della dimensione verticale dell'oggetto (se ha occupato più righe o meno righe),
			  da comunicare (in termini di spostamento di posizione) agli oggetti sottostanti;
			  I_DELTA_Y serve per calcolare le eventuali conseguenze sugli altri oggetti;
			  è positivo se l'oggetto aumenta la dimensione }
		var i_max_y_pixel : int_pixel_type;
			// posizione y massima; serve per effettuare calcoli sulla dimensione della sezione
*)
	if bo_video then canvas := vcanvas else canvas := pcanvas;
	canvas.stretchdraw(r, picture.graphic)
//	;picture.Bitmap.SaveToFile('E:\TEMP\xxx\AAA.bmp');		{$ifndef DEBUG} *** {$endif}
end;
{$endif CASA}

function cl_bmp.load(var f : text;xref : reference_obj;wo_versione : word) : boolean;
// carica l'oggetto; rende TRUE in caso di successo
var
	s : string;
	i : byte;
	c : char;
	{$ifdef DLL} fl : double; {$endif}
begin
	var old_show : show_types := OSW_SHOW;
	try
		read_object_pos(self, f, wo_versione);
		read_object_size(self, f, wo_versione);
		i_height_originale_video_pixel := height;
		i_left_originale := left;i_top_originale := top;
		i_original_width := width;i_original_height := height;
		readln(f);
		if (wo_versione <= $021E) then read_uncompressed_bitmap(f, picture, wo_versione)
		else read_compressed_bitmap(f, picture, wo_versione, get_name);
		i_max_height := height;i_max_width := width;
		autoresize_align_horz := HAT_LEFT;autoresize_align_vert := VAT_TOP;
		bo_sfondo_design_time := FALSE;
		{$ifdef GALATEO_EXE} bo_mantieni_proporzioni := TRUE; {$endif}
		xref.load(f);
		readln(f, s);set_name(s);
		if (wo_versione >= $010B) then begin
			if (wo_versione <= $0260) then readln(f, byte(old_show));
			readln(f, str_immagine_dinamica);
			readln(f, s);
			bo_autosize_immagine_dinamica := (s <> '') AND SQL2bool(copy(s, 1, 1));
			bo_image_dinamica_must_exist := (s <> '') AND SQL2bool(copy(s, 2, 1));
			bo_cannot_exceed_original_size := (length(s) >= 3) AND SQL2bool(copy(s, 3, 1));
			delete(s,1,3);
			while (s <> '') do begin
				case s[1] of
					'L' : {$ifdef GALATEO_EXE} bo_mantieni_proporzioni := FALSE {$endif};
					'a'..'c' : autoresize_align_horz := horz_align_type(byte(s[1]) - byte('a'));
					'A'..'C' : autoresize_align_vert := vert_align_type(byte(s[1]) - byte('A'));
					'S' : bo_sfondo_design_time := TRUE			// 2020-08-02
				end;
				delete(s, 1, 1)
			end;

//			read(f,c);bo_image_dinamica_should_exist := bo_image_dinamica_must_exist OR SQL2bool(c);
//			read(f,fl_original_ratio);
			if eoln(f) then begin
				bo_image_dinamica_should_exist := bo_image_dinamica_must_exist;
				{$ifdef GALATEO_EXE} fl_original_ratio := 0 {$endif}
			end
			else begin
				read(f,c);bo_image_dinamica_should_exist := bo_image_dinamica_must_exist OR SQL2bool(c);
				{$ifdef DLL} fl := 0; {$endif}	// solo per evitare la warning
				if NOT eoln(f) then read(f, {$ifdef DLL} fl {$else} fl_original_ratio {$endif});
				{$ifdef DLL} if (fl = 0) then; {$endif}	// solo per evitare la warning
			end;
			readln(f);
			for i := 1 to 3 do readln(f)
		end;
		if NOT ca.load(f, wo_versione) then abort;
		if (wo_versione <= $0260) then ca.show := old_show;
		applica_opzioni_bmp;

		result := TRUE
	except
		result := FALSE;
		error_msg(father, 'Errore durante la lettura del file (bmp)',MBOX_CAPTION)
	end
end;

function cl_bmp.load_file(str_filename : string;
	bo_load_immagine_dinamica : boolean;	// TRUE se sto caricando un'immagine dinamica durante l'esecuzione, FALSE se sto caricando un'immagine in fase di editing
	bo_autosize : boolean = TRUE;bo_cannot_exceed_original_size : boolean = FALSE) : boolean;
// carica l'immagine indicata; rende TRUE in caso di successo, FALSE altrimenti
var
	fl : real;
	i_new, i_max_section_space, i_delta : int_pixel_type;
	bo_too_big_for_section : boolean;
begin
	try
//		i_original_width := width;i_original_height := height;

//		if NOT bo_load_immagine_dinamica OR (globale.fase_stampa = FST_FORMATTING) then begin	// altrimenti è già stato caricato
			autosize := bo_autosize;
			picture.loadfromfile(str_filename);
			{$ifdef GALATEO_EXE}
				fl_original_ratio := 0;
				if (picture.Height <> 0) then fl_original_ratio := picture.Width / picture.Height;
			{$endif}

			autosize := FALSE
//		end;
;;;;;;;;;
		// verifico che l'immagine non ecceda le dimensioni massime
		i_max_section_space := cm2pixel_video_y(sections_1B(ca.i_section_1B).r_y_sezione_cm) - top - 1;	// -1: margine di approx
		if ca.bo_move_obj_sottostanti then
			// tolgo lo spazio tra il fondo dell'immagine e il fondo della sezione (che potrebbe essere utilizzato da altri oggetti)
			dec(i_max_section_space,cm2pixel_video_y(sections_1B(ca.i_section_1B).r_y_gruppo_cm) - (top + i_height_originale_video_pixel));

		bo_too_big_for_section := NOT bo_cannot_exceed_original_size AND (height > i_max_section_space);

		if bo_too_big_for_section OR
			(bo_autosize AND bo_cannot_exceed_original_size AND ((width > i_max_width) OR (height > i_max_height)))
		then begin
			// determino il fattore di scala
			if bo_too_big_for_section then begin
				if NOT bo_cannot_exceed_original_size AND (resized_images.indexof(str_filename) = -1) then begin
					resized_images.add(str_filename);
					MessageBBox(0,'Immagine <' + str_filename + '> troppo grande -- sarà ridimensionata',MBOX_CAPTION)
				end;
				fl := height / i_max_section_space
			end
			else fl := max(width / i_max_width,height / i_max_height);
			{$ifdef DEBUG} assert(fl <> 0,'JHDF 9287'); {$endif}
			if (fl <> 0) then begin width := round(width / fl);height := round(height / fl) end
		end;

		i_delta := 0;
		if (i_original_width <> width) then begin
			case autoresize_align_horz of
				HAT_LEFT : ;
				HAT_CENTER : i_delta := (i_original_width - width) div 2;
				HAT_RIGHT : i_delta := i_original_width - width
				{$ifdef DEBUG} else assert(FALSE, 'HAT -- DJHW 8873') {$endif}
			end
		end;
		i_new := i_left_originale + i_delta;
		if (i_new <> left) then left := i_new;

		i_delta := 0;
		if (i_original_height <> height) then begin
			case autoresize_align_vert of
				VAT_TOP : ;
				VAT_CENTER : i_delta := (i_original_height - height) div 2;
				VAT_BOTTOM : i_delta := i_original_height - height
				{$ifdef DEBUG} else assert(FALSE, 'HAT -- DJHW 8873') {$endif}
			end
		end;
		i_new := i_top_originale + i_delta;
		if (i_new <> top) then top := i_new;	

(*		i_delta := i_original_width - width;
		if (i_delta <> 0) then begin
			case autoresize_align_horz of
				HAT_LEFT : ;
				HAT_CENTER : left := i_left_originale + i_delta div 2;
				HAT_RIGHT : left := i_left_originale + i_delta
				{$ifdef DEBUG} else assert(FALSE, 'HAT -- DJHW 8873') {$endif}
			end
		end;

		if NOT (ca.bo_move_obj_sottostanti) then begin	// altrimenti il ridimensionamento elimina la necessità dell'alignment
			i_delta := i_original_height - height;
			if (i_delta <> 0) then begin
				case autoresize_align_vert of
					VAT_TOP : ;
					VAT_CENTER : top := i_top_originale + i_delta div 2;
					VAT_BOTTOM : top := i_top_originale + i_delta
					{$ifdef DEBUG} else assert(FALSE, 'VAT -- DJHW 8874') {$endif}
				end
			end
		end; *)

		result := TRUE
	except
		result := FALSE
	end
end;

function cl_bmp.get_x_left_virtuale(x_left : int_pixel_type) : int_pixel_type; begin result := x_left end;
{$ifdef GALATEO_EXE} function cl_bmp.get_y_top_virtuale(y_top : int_pixel_type) : int_pixel_type; begin result := y_top end; {$endif}

{$ifdef GALATEO_EXE}

	procedure cl_bmp.WMPaint(var Message: TWMPaint);
	begin
		inherited;
	{	BeginPaint(;
		if obj.tag2object(tag).is_hidden(0) then with canvas do begin
			pen.Color := COLOR_HIDDEN_OBJECTS;
			Pen.Width := 5;
			MoveTo(0,0);Lineto(width,height);
			MoveTo(width,0);Lineto(0,height);
		end;
		validaterect(picture.bitmap.handle,NIL) }
	end;

	procedure cl_bmp.WMmove(var Message: TWMMove);
	begin
		var ox : objs_type := tag2object(tag);
		if (ox <> NIL) then ox.on_change_size_and_pos
//		var i_obj : obj_index_type := tag2index(tag);
//		if (i_obj <> 0) then objs(i_obj).on_change_size_and_pos
	end;

	procedure cl_bmp.WMRButtonDown(var Message: TWMRButtonDown);
	begin
		var i_obj : obj_index_type := get_related_obj([], ca.i_section_1B, message.xpos+left, message.ypos+top, FALSE, TRUE);
		select_checking_keys(i_obj);
		var p : TPoint := ClientToScreen(Point(message.xpos,message.ypos));
		GM.popup_object.popup(p.x, p.y)
	end;

	procedure cl_bmp.WMLButtonDown(var Message: TWMLButtonDown);
	begin
		var i_obj : obj_index_type := get_related_obj([], ca.i_section_1B, message.xpos+left, message.ypos+top, FALSE, TRUE);
		if (i_obj = 0) AND bo_sfondo_design_time then exit;		// nulla da fare, non è selezionato nè questo oggetto nè un oggetto sottostante
		{$ifdef DEBUG} assert(i_obj <> 0,'ORPOLETTA 980'); {$endif}
		dd.bo_resizing_horz := (cursor = crSizeWE);
		dd.bo_resizing_vert := (cursor = crSizeNS);
		select_checking_keys(i_obj)
	end;

	procedure cl_bmp.WMLButtonDblclk(var Message: TWMLButtonDBLCLK); begin {$ifdef GALATEO_EXE} edit_object {$endif} end;
	procedure cl_bmp.WMLButtonUp(var Message: TWMLButtonUp); begin dd.dragging_mouse_up end;
	procedure cl_bmp.WMMousemove(var Message: TWMMouseMove); begin dd.dragging_Mousemove(self,message.xpos+left,message.ypos+top) end;

	procedure cl_bmp.esc;
	begin
	end;

	procedure cl_bmp.select(bo_select : boolean);
	begin
		if (bo_select = ca.bo_selected) then exit;
		ca.bo_selected := bo_select;
		Canvas.CopyMode := cmDSTINVERT;
		Canvas.CopyRect(Canvas.ClipRect, Canvas, Canvas.ClipRect)	// tutta l'immagine
	end;

	procedure cl_bmp.applica_style(obj_from : {objs_type}Pointer;wo_style : word);
	begin
		var xfrom : objs_type := objs_type(obj_from);
		if (wo_style = STYLE_ALL) then wo_style := BMP_STYLES;

{		if (wo_style AND STYLE_SIZE <> 0) then begin
			dec(wo_style,STYLE_SIZE);
			autosize := FALSE;height := xfrom.get_height;width := xfrom.get_width
		end; }
{		if (wo_style AND STYLE_LEGAMI_COMUNITARI <> 0) then begin
			dec(wo_style,STYLE_LEGAMI_COMUNITARI);
			obj_dest.xref.str_vert := xfrom.xref.str_vert;
			obj_dest.xref.str_horz := xfrom.xref.str_horz;
			obj_dest.xref.str_pos := xfrom.xref.str_pos
		end; }
		if (wo_style AND STYLE_VALUES <> 0) then begin
			{$ifdef DEBUG} dec(wo_style,STYLE_VALUES); {$endif}
			if (xfrom.ca.tipo_oggetto = OBJ_BITMAP) then begin
				autosize := xfrom.asbitmap.autosize;
				picture.assign(xfrom.asbitmap.picture)
			end
		end;
		{$ifdef DEBUG} assert(wo_style = 0,'cl_bmp.applica_style() <> 0') {$endif}
	end;

	function cl_bmp.save(var f : text;xref : reference_obj) : boolean;
	// salva l'oggetto; rende TRUE in caso di successo
	var i : byte;
	begin
		try
			writeln(f, video2cm_x(left):0:3,' ',video2cm_y(top):0:3,' ', video2cm_x(width):0:3,' ',video2cm_y(height):0:3);
			if globale.bo_use_compressed_bmps AND NOT write_compressed_bitmap(father, f, picture, get_name) then abort;
			if NOT globale.bo_use_compressed_bmps AND NOT write_UNcompressed_bitmap(f, picture) then abort;
			xref.save(f);
			writeln(f, get_name);
//			writeln(f, byte(show));
			writeln(f, str_immagine_dinamica);

			write(f, bool2SQL(bo_autosize_immagine_dinamica), bool2SQL(bo_image_dinamica_must_exist), bool2SQL(bo_cannot_exceed_original_size),
				char(byte('a') + byte(autoresize_align_horz)), char(byte('A') + byte(autoresize_align_vert)));
			if NOT bo_mantieni_proporzioni then write(f, 'L');
			if bo_sfondo_design_time then write(f, 'S');

			writeln(f);

			writeln(f, bool2SQL(bo_image_dinamica_should_exist), ' ', fl_original_ratio:0:8,' 0 0 0 0');
			for i := 1 to 3 do writeln(f);	// future free space
			if NOT ca.save(f) then abort;
			result := TRUE
		except
			result := FALSE;
			error_msg(father, 'Errore durante la scrittura del file', MBOX_CAPTION);
			abort
		end
	end;

	procedure cl_bmp.edit_object;
	begin
//		i_numero_obj := tag2index(tag);
		var bo_was_selected : boolean := (get_selected_obj_index(0) = ca.i_numero_obj);
		if bo_was_selected then obj_select(0, FALSE, FALSE);
		if bmp_dialog_proc(father, self) then set_global_modified;
		if bo_was_selected then obj_select(ca.i_numero_obj, TRUE, FALSE)
	end;

	{$ifdef DEBUG} procedure cl_bmp.assign(a : char); begin end; {$endif}		// per inibire l'uso della funzione base ASSIGN()

	procedure cl_bmp.assign_data(bmp_source : cl_bmp);
	// copia i soli dati, non i campi 'attivi' (ad esempio non copia: father, handles, ...)
	begin
		{$ifdef DEBUG} assign('A'); {$endif}		// inutile ma necessario
		Caption := bmp_source.Caption;		// 2018-09-03, incredibilmente non assegnava il nome dell'oggetto !!!!!
		ca.assign(bmp_source.ca);
		str_immagine_dinamica := bmp_source.str_immagine_dinamica;
		bo_sfondo_design_time := bmp_source.bo_sfondo_design_time;
{$ifdef GALATEO_EXE}
		bo_mantieni_proporzioni := bmp_source.bo_mantieni_proporzioni;
		fl_original_ratio := bmp_source.fl_original_ratio;
//		pbox : TGalPaintBox;
{$endif}
		bo_autosize_immagine_dinamica := bmp_source.bo_autosize_immagine_dinamica;
		bo_cannot_exceed_original_size := bmp_source.bo_cannot_exceed_original_size;
		autoresize_align_horz := bmp_source.autoresize_align_horz;
		autoresize_align_vert := bmp_source.autoresize_align_vert;
		bo_image_dinamica_should_exist := bmp_source.bo_image_dinamica_should_exist;
		bo_image_dinamica_must_exist := bmp_source.bo_image_dinamica_must_exist;
		str_immagini_inesistenti := bmp_source.str_immagini_inesistenti;
//		original_picture
//		resized_images := bmp_source.resized_images;
//		father : TForm;
		left := bmp_source.Left;width := bmp_source.Width;
		top := bmp_source.Top;height := bmp_source.Height;
		i_max_height := bmp_source.i_max_height;
		i_max_width := bmp_source.i_max_width;
		i_height_originale_video_pixel := bmp_source.i_height_originale_video_pixel;
		i_original_width := bmp_source.i_original_width;
		i_original_height := bmp_source.i_original_height;
		i_left_originale := bmp_source.i_left_originale;
		i_top_originale := bmp_source.i_top_originale;
		applica_opzioni_bmp
	end;

{$endif}

procedure cl_bmp.applica_opzioni_bmp;
begin
	if bo_sfondo_design_time then begin
		cursor := crDefault;
		sendToBack
	end
	else cursor := DEFAULT_CURSOR_OBJECTS
end;

//***************************************************************************************************************/

initialization
	galateo_initialization_debug('bmps')
finalization
	galateo_finalization_debug('bmps');
	{$ifdef DEBUG} CCI(i_bmps, 'cl_bmp', 'bmps.pas') {$endif}
end.
