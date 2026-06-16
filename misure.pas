unit Misure;

{$I defines}

interface

uses Windows, Graphics, WinSpool, SysUtils,
	Fcommons, printers_DX, Gdich;

procedure init_misure;

function esiste_stampante(bo_msg : boolean = FALSE) : boolean;
function selected_printer_valid(bo_msg : boolean = FALSE) : boolean;

procedure shift_orizzontal_sizes(var x,y : integer;i_pagina_logica_1B : logical_page_type); overload;
procedure shift_orizzontal_sizes(var x,y : misura_real_type;i_pagina_logica_1B : logical_page_type); overload;

function cm2pixel_video_x(r : misura_real_type) : int_pixel_type;
function cm2pixel_video_y(r : misura_real_type) : int_pixel_type;
function cm2pixel_print_x(r : misura_real_type) : int_pixel_type;
function cm2pixel_print_y(r : misura_real_type) : int_pixel_type;

function video2cm_x(i_pixel : int_pixel_type) : misura_real_type;
function video2cm_y(i_pixel : int_pixel_type) : misura_real_type;
function print2cm_x(i_pixel : int_pixel_type) : misura_real_type;
function print2cm_y(i_pixel : int_pixel_type) : misura_real_type;

type
	{$M+}
	Tmisure = class	// classe che governa e descrive la pagina
		private
			// Text Only
			bo_text_only : boolean;		// TRUE se l'output deve essere eseguito solo testo
			init_dc : HDC;					// HDC usato per l'inizializzazione
			str_last_printer_name : string;		// ultima stampante inizializzata
			function get_text_only_line_height_cm : double;
			function get_i_text_only_char_video_pixel_x : int_pixel_type;
			function get_r_text_only_char_video_pixel_x : double;
			function get_text_only_char_print_pixel_x : int_pixel_type;
		published
			function videopixel2colonne(i_pixel : int_pixel_type) : int_pixel_type;
			function printpixel2colonne(i_pixel : int_pixel_type) : int_pixel_type;
			property text_only_line_height_cm : double read get_text_only_line_height_cm;
			property i_text_only_char_video_pixel_x : int_pixel_type read get_i_text_only_char_video_pixel_x;	// dimensione in pixel di 1 char Text Only
			property r_text_only_char_video_pixel_x : double read get_r_text_only_char_video_pixel_x;	// dimensione in pixel di 1 char Text Only
			property text_only_char_print_pixel_x : int_pixel_type read get_text_only_char_print_pixel_x;	// dimensione in pixel di 1 char Text Only
			function text_only_video_font_ppi(i_pixelsperinch_original : int_pixel_type) : int_pixel_type;
		private
			// Graphics
			xr_delta_labs_X_cm, xr_delta_labs_Y_cm : misura_real_type;	// spazio tra etichette contigue

			function read_delta_labs_X_cm : misura_real_type;
			procedure write_delta_labs_X_cm (r:misura_real_type);

			function read_delta_labs_Y_cm : misura_real_type;
			procedure write_delta_labs_Y_cm (r:misura_real_type);
			function advanced_get_printer_info(str_printer_name : string = '') : boolean;
		public
			bo_show_griglia,bo_print_bordo : boolean;
			i_lab_per_row, i_lab_per_page : smallint;	// numero di etichette in orizzontale/verticale
			bo_print_pagina_completa : boolean;

			i_phisical_10mm_height, i_phisical_10mm_width : integer;	// dimensioni fisiche del foglio (lette dalla stampante selezionata)

			i_pixel_per_inch_print_x, i_pixel_per_inch_print_y : int_pixel_type;
			r_pixel_per_inch_video_x, r_pixel_per_inch_video_y : misura_real_type;
			r_fattore_zoom : real;

			constructor create;
			{$ifndef DLL} procedure xassign(tm : Tmisure); {$endif}
			procedure default_values(handle : HDC;str_printer : string);

			property r_delta_labs_X_cm : misura_real_type read read_delta_labs_X_cm write write_delta_labs_X_cm;
			property r_delta_labs_Y_cm : misura_real_type read read_delta_labs_Y_cm write write_delta_labs_Y_cm;

			function video2print_pixel_x(i_pixel : int_pixel_type) : int_pixel_type;
			function video2print_pixel_y(i_pixel : int_pixel_type) : int_pixel_type;

			function print2video_pixel_x(i_pixel : int_pixel_type) : int_pixel_type;
			function print2video_pixel_y(i_pixel : int_pixel_type) : int_pixel_type;

//			procedure init_print_values(handle : HDC;str_printer_name : string);
			function init_print_values(str_printer_name : string;bo_message : boolean = FALSE) : boolean;
			function init_video_values(dc : HDC;r_fattore : real;bo_forza : boolean = FALSE) : boolean;
//			procedure set_report(bo_report : boolean);
			procedure set_report(tiporeport : REPORT_TYPE);

	end;
	{$M-}
	cm2pix_func = function(r : misura_real_type) : int_pixel_type {of object};
	pix2cm_func = function(i : int_pixel_type) : misura_real_type {of object};
var
	tm : TMisure;

implementation

uses FSystem, FErrMsg, FMessage, FProcs, {$ifdef DEBUG} FDebug, {$endif DEBUG}
	galateo_debug, pages, proc;

constructor Tmisure.Create;
begin
	var i : smallint := printer.PrinterIndex;
	if (i <> -1) then default_values(NULL, printer.printers[i])
end;

procedure TMisure.default_values(handle : HDC;str_printer : string);
{$ifdef DEBUG} const MBOX_DEBUG_CAPTION = 'TMisure.default_values()'; {$endif DEBUG}
begin
{$ifdef REPORT_GENERATOR}
	i_lab_per_row := 1;i_lab_per_page := 1;
{$else}
	i_lab_per_row := 3;i_lab_per_page := 4;
{$endif}
	r_delta_labs_X_cm := 0;r_delta_labs_Y_cm := 0;
	r_pixel_per_inch_video_x := 0;r_pixel_per_inch_video_y := 0;

	bo_show_griglia := TRUE;bo_print_bordo := FALSE;
	bo_print_pagina_completa := TRUE;
	bo_invalid_selected_printer := FALSE;
	if esiste_stampante(FALSE) then begin
		try		// TRY creato il 2009-07-08 con tutto quello che contiene
			{$ifdef DEBUG} static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: before default_values() -- bo_service=' + get_service_mode.SQL); {$endif DEBUG}
			if NOT init_print_values({printer.handle,}str_printer)
				then raise exception.create('Impossibile leggere i parametri della stampante predefinita')
			{$ifdef DEBUG} ;static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: after default_values() -- bo_service=' + get_service_mode.SQL); {$endif DEBUG}
//			;abort	{$ifdef DEBUG} *** {$endif DEBUG}
		except
			bo_invalid_selected_printer := TRUE;
			{$ifdef DEBUG} static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: EXCEPT before default_values() -- bo_service=' + get_service_mode.SQL); {$endif DEBUG}
			error_msg('Errore durante l''accesso a GALATEO', MBOX_CAPTION);
			{$ifdef DEBUG} static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: EXCEPT after default_values() -- bo_service=' + get_service_mode.SQL); {$endif DEBUG}
//			halt;exit
		end
	end;
	if (handle <> NULL) then init_video_values(handle, 1)
end;

function TMisure.init_video_values(dc : HDC;r_fattore : real;bo_forza : boolean = FALSE) : boolean;
// rende FALSE se non riesce a leggere i valori di inizializzazione
begin
	if (init_dc = 0) OR bo_forza then begin	// inizializza solo una volta, a meno che non sia
{		var x : integer := GetPrivateProfileInt(PROGRAM_NAME,INI_X_VIDEO_PROP,0,FILE_INI);
		var y : integer := GetPrivateProfileInt(PROGRAM_NAME,INI_Y_VIDEO_PROP,0,FILE_INI);
		init_video_values := (x <> 0) AND (y <> 0);
		if (x = 0) then x := 100;if (y = 0) then y := 100;
		or_pixel_per_inch_video_x := GetDeviceCaps(dc,LOGPIXELSX) / x * 100.0 * r_fattore;
		or_pixel_per_inch_video_y := GetDeviceCaps(dc,LOGPIXELSY) / y * 100.0 * r_fattore ;{}

		self.r_fattore_zoom := r_fattore;
		r_pixel_per_inch_video_x := GetDeviceCaps(dc, LOGPIXELSX) * r_fattore;	//	Number of pixels per logical inch along the screen width.
		r_pixel_per_inch_video_y := GetDeviceCaps(dc, LOGPIXELSY) * r_fattore;	//	Number of pixels per logical inch along the screen height.
		init_dc := dc
	end;
	result := TRUE
end;

{procedure TMisure.init_print_values(handle : HDC;str_printer_name : string);
begin
	if (handle <> 0) then begin
		i_pixel_per_inch_print_x := GetDeviceCaps(handle,LOGPIXELSX);	// prima!
		i_pixel_per_inch_print_y := GetDeviceCaps(handle,LOGPIXELSY)
	end;
	get_printer_info(str_printer_name);
	bo_text_only := (GetDeviceCaps(handle,LINECAPS) = LC_NONE)
end; }

{$ifndef DLL}
	procedure TMisure.xassign(TM : TMisure);
	begin
		i_pixel_per_inch_print_x := tm.i_pixel_per_inch_print_x;
		i_pixel_per_inch_print_y := tm.i_pixel_per_inch_print_y;
		r_pixel_per_inch_video_x := tm.r_pixel_per_inch_video_x;
		r_pixel_per_inch_video_y := tm.r_pixel_per_inch_video_y;
		i_lab_per_row := tm.i_lab_per_row;
		i_lab_per_page := tm.i_lab_per_page;
	//	r_labsize_X_cm := tm.r_labsize_X_cm;
	//	r_labsize_Y_cm := tm.r_labsize_Y_cm;
	//	r_marg_sx_cm := tm.r_marg_sx_cm;
	//	r_marg_up_cm := tm.r_marg_up_cm;
		r_delta_labs_X_cm := tm.r_delta_labs_X_cm;
		r_delta_labs_Y_cm := tm.r_delta_labs_Y_cm;
		bo_show_griglia := tm.bo_show_griglia;
		bo_print_bordo := tm.bo_print_bordo;
		bo_print_pagina_completa := tm.bo_print_pagina_completa
	end;
{$endif}

function TMisure.read_delta_labs_X_cm : misura_real_type; begin result := xr_delta_labs_X_cm end;
procedure TMisure.write_delta_labs_X_cm (r:misura_real_type); begin xr_delta_labs_X_cm := r end;
function TMisure.read_delta_labs_Y_cm : misura_real_type; begin result := xr_delta_labs_Y_cm end;
procedure TMisure.write_delta_labs_Y_cm (r:misura_real_type); begin xr_delta_labs_Y_cm := r end;

function TMisure.video2print_pixel_x(i_pixel : int_pixel_type) : int_pixel_type;
begin
	{$ifdef DEBUG} assert(r_pixel_per_inch_video_x <> 0, 'i_pixel_per_inch_print_y = 0 -- JMZZ 9901'); {$endif}
	if (i_pixel = 0) then result := 0
	else result := round(i_pixel / r_pixel_per_inch_video_x * i_pixel_per_inch_print_x * tm.r_fattore_zoom)
end;

function TMIsure.video2print_pixel_y(i_pixel : int_pixel_type) : int_pixel_type;
begin
	{$ifdef DEBUG} assert(r_pixel_per_inch_video_y <> 0, 'i_pixel_per_inch_print_y = 0 -- JMZZ 9902'); {$endif}
	if (i_pixel = 0) then result := 0
	else result := round(i_pixel / r_pixel_per_inch_video_y * i_pixel_per_inch_print_y * tm.r_fattore_zoom)
end;

function TMIsure.print2video_pixel_x(i_pixel : int_pixel_type) : int_pixel_type;
begin
	{$ifdef DEBUG} assert(i_pixel_per_inch_print_x <> 0, 'i_pixel_per_inch_print_x = 0 -- JMZZ 9903'); {$endif}
	if (i_pixel = 0) then result := 0
	else result := round(i_pixel / i_pixel_per_inch_print_x * r_pixel_per_inch_video_x / tm.r_fattore_zoom)
end;

function TMIsure.print2video_pixel_y(i_pixel : int_pixel_type) : int_pixel_type;
begin
	{$ifdef DEBUG} assert(i_pixel_per_inch_print_y <> 0, 'i_pixel_per_inch_print_y = 0 -- JMZZ 9904'); {$endif}
	if (i_pixel = 0) then result := 0
	else result := round(i_pixel / i_pixel_per_inch_print_y * r_pixel_per_inch_video_y / tm.r_fattore_zoom)
end;

//procedure TMIsure.set_report(bo_report : boolean);
procedure TMIsure.set_report(tiporeport : REPORT_TYPE);
begin
//	if bo_report then begin
	if (tiporeport in LABEL_TYPES) then begin
		i_lab_per_row := 1;i_lab_per_page := 1
	end
//	else
end;

function TMIsure.get_text_only_line_height_cm : double;
// altezza riga di testo in stampe di tipo TEXT ONLY
begin
	try
		result := CM_PER_INCH / globale.i_text_only_lpi
	except
		result := CM_PER_INCH / TEXT_ONLY_LPI_DEFAULT
	end
end;

function TMIsure.get_r_text_only_char_video_pixel_x : double;
// dimensione in pixel di 1 carattere di testo stile 'text only'
begin
	result := r_pixel_per_inch_video_x / globale.i_text_only_cpi
end;

function TMIsure.get_i_text_only_char_video_pixel_x : int_pixel_type;
// dimensione in pixel di 1 carattere di testo stile 'text only'
begin
	result := round(get_r_text_only_char_video_pixel_x)
end;

function TMIsure.get_text_only_char_print_pixel_x : int_pixel_type;
// dimensione in pixel di 1 carattere di testo stile 'text only'
begin
	result := round((CM_PER_INCH / globale.i_text_only_cpi) / (CM_PER_INCH / i_pixel_per_inch_print_x))
end;

function TMIsure.videopixel2colonne(i_pixel : int_pixel_type) : int_pixel_type;
// rende il numero di colonne corrispondente al numero di pixel specificato
begin
	if (i_pixel = 0) then result := 0
	else result := trunc(i_pixel / get_r_text_only_char_video_pixel_x)
end;

function TMIsure.printpixel2colonne(i_pixel : int_pixel_type) : int_pixel_type;
// rende il numero di colonne corrispondente al numero di pixel specificato
begin
	if (i_pixel = 0) then result := 0
	else result := i_pixel div get_text_only_char_print_pixel_x
end;

function TMIsure.Text_only_video_font_ppi(i_pixelsperinch_original : int_pixel_type) : int_pixel_type;
{ rende il valore PIXELPERINCH da utilizzare con il font a video per ottenere
  un output rispettoso delle misure e delle proporzioni;
  I_PIXELPERINCH_ORIGINAL è il valore originale }
begin
	result := round(i_pixelsperinch_original)
end;

function selected_printer_valid(bo_msg : boolean = FALSE) : boolean;
// rende TRUE se la stampante selezionata è valida
begin
	result := (printer.Printers.Count > 0) AND NOT bo_nessuna_stampante_installata AND NOT bo_invalid_selected_printer
end;

function esiste_stampante(bo_msg : boolean = FALSE) : boolean;
// rende TRUE se nel sistema esiste almeno una stampante; se BO_MSG emette un messaggio di avvertimento
begin
	result := NOT bo_nessuna_stampante_installata;
	if NOT result AND bo_msg then MessageBBox(0, 'Nessuna stampante installata nel sistema', MBOX_CAPTION, MB_ICONSTOP)
end;

procedure shift_orizzontal_sizes(var x,y : integer;i_pagina_logica_1B : logical_page_type);
// se BO_ORIZZONTALE then scambio horz e vert
begin
	if orizzontale_ZB(i_pagina_logica_1B - 1) then begin
		var i : integer := x;x := y;y := i
	end
end;

procedure shift_orizzontal_sizes(var x,y : misura_real_type;i_pagina_logica_1B : logical_page_type);
// se BO_ORIZZONTALE then scambio horz e vert
begin
	if orizzontale_ZB(i_pagina_logica_1B - 1) then begin
		var t : misura_real_type := x;x := y;y := t
	end
end;

// -----------------------------------------------------------------------------

(*
function {TMisure.}cm2pixel_video_x(r : misura_real_type) : int_pixel_type; begin result := round(cm2inches(r * tm.r_pixel_per_inch_video_x)) end;
function {TMisure.}cm2pixel_video_y(r : misura_real_type) : int_pixel_type; begin result := round(cm2inches(r * tm.r_pixel_per_inch_video_y)) end;
function {TMisure.}cm2pixel_print_x(r : misura_real_type) : int_pixel_type; begin result := round(cm2inches(r * tm.i_pixel_per_inch_print_x)) end;
function {TMisure.}cm2pixel_print_y(r : misura_real_type) : int_pixel_type; begin result := round(cm2inches(r * tm.i_pixel_per_inch_print_y)) end;
function {TMIsure.}video2cm_x(i_pixel : int_pixel_type) : misura_real_type; begin result := i_pixel / tm.r_pixel_per_inch_video_x * CM_PER_INCH end;
function {TMIsure.}video2cm_y(i_pixel : int_pixel_type) : misura_real_type; begin result := i_pixel / tm.r_pixel_per_inch_video_y * CM_PER_INCH end;
function {TMIsure.}print2cm_x(i_pixel : int_pixel_type) : misura_real_type; begin result := i_pixel / tm.i_pixel_per_inch_print_x * CM_PER_INCH end;
function {TMIsure.}print2cm_y(i_pixel : int_pixel_type) : misura_real_type; begin result := i_pixel / tm.i_pixel_per_inch_print_y * CM_PER_INCH end;
*)

function cm2pixel_video_x(r : misura_real_type) : int_pixel_type;
begin
	if (r = 0) then result := 0
	else result := round(cm2inches(r * tm.r_pixel_per_inch_video_x))
end;

function cm2pixel_video_y(r : misura_real_type) : int_pixel_type;
begin
	if (r = 0) then result := 0
	else result := round(cm2inches(r * tm.r_pixel_per_inch_video_y))
end;

function cm2pixel_print_x(r : misura_real_type) : int_pixel_type;
begin
	if (r = 0) then result := 0
	else result := round(cm2inches(r * tm.i_pixel_per_inch_print_x))
end;

function cm2pixel_print_y(r : misura_real_type) : int_pixel_type;
begin
	if (r = 0) then result := 0
	else result := round(cm2inches(r * tm.i_pixel_per_inch_print_y))
end;

function video2cm_x(i_pixel : int_pixel_type) : misura_real_type;
begin
	if (i_pixel = 0) then result := 0
	else result := i_pixel / tm.r_pixel_per_inch_video_x * CM_PER_INCH
end;

function video2cm_y(i_pixel : int_pixel_type) : misura_real_type;
begin
	if (i_pixel = 0) then result := 0
	else result := i_pixel / tm.r_pixel_per_inch_video_y * CM_PER_INCH
end;

function print2cm_x(i_pixel : int_pixel_type) : misura_real_type;
begin
	if (i_pixel = 0) then result := 0
	else result := i_pixel / tm.i_pixel_per_inch_print_x * CM_PER_INCH
end;

function print2cm_y(i_pixel : int_pixel_type) : misura_real_type;
begin
	if (i_pixel = 0) then result := 0
	else result := i_pixel / tm.i_pixel_per_inch_print_y * CM_PER_INCH
end;

//	********** versione in uso fino al 2023-04-07
//	function TMisure.init_print_values(str_printer_name : string;bo_message : boolean = FALSE) : boolean;
//	// deve essere chiamata dopo aver impostato la stampante attiva con printer.SETPRINTER()
//	const MBOX_CAPTION_DEBUG = 'init_print_values()';
//	begin
//		result := FALSE;
//		try
//			if (str_printer_name <> '') AND (printer.str_setprinted_device <> printer.get_devicename(str_printer_name))
//				then printer.setPrinter(str_printer_name, 0);
//
//	(*		{$ifdef WIN64}
//				i_pixel_per_inch_print_x := 0;i_pixel_per_inch_print_y := 0;
//				i_phisical_10mm_height := 0;i_phisical_10mm_width := 0;
//			{$else}
//				// se WIN64, per motivi inattingibili, si pianta sulla printers_VCL.Printer.SetState() -- CreateHandleFunc()
//				// i valori vengono cmq recuperati attraverso la ADVANCED_GET_PRINTER_INFO()
//				i_pixel_per_inch_print_x := printer.ResX;i_pixel_per_inch_print_y := printer.ResY;
//				i_phisical_10mm_height := printer.PageHeight_10mm;i_phisical_10mm_width := printer.PageWidth_10mm;
//			{$endif} *)
//			i_pixel_per_inch_print_x := 0;	// 2020-01-29: preferisco passare sempre dalla ADVANCED() perchè è più sicura
//
//			// il prossimo IF: dal 2009-07-04
//			if ((i_pixel_per_inch_print_x <= 0) OR (i_pixel_per_inch_print_y <= 0) OR (i_phisical_10mm_height <= 0) OR (i_phisical_10mm_width <= 0)) then begin
//				advanced_get_printer_info(str_printer_name);
//				var bo_ok := (i_pixel_per_inch_print_x > 0) AND (i_pixel_per_inch_print_y > 0) AND (i_phisical_10mm_height > 0) AND (i_phisical_10mm_width > 0);
//	//			i_pixel_per_inch_print_x := -1;
//	//			if (i_pixel_per_inch_print_x <= 0) OR (i_pixel_per_inch_print_y <= 0) OR (i_phisical_10mm_height <= 0) OR (i_phisical_10mm_width <= 0) then exit
//				if NOT bo_ok then exit
//			end;
//			bo_text_only := FALSE;
//			result := TRUE
//		finally
//			if NOT result then begin
//				if bo_message then MessageBBox(0, 'Impossibile leggere i parametri della stampante ' + str_printer_name, MBOX_CAPTION, MB_ICONSTOP);
//				i_pixel_per_inch_print_x := 0;i_pixel_per_inch_print_y := 0;i_phisical_10mm_height := 0;i_phisical_10mm_width := 0
//			end
//		end
//	end;

function TMisure.init_print_values(str_printer_name : string;bo_message : boolean = FALSE) : boolean;
// deve essere chiamata dopo aver impostato la stampante attiva con printer.SETPRINTER()

	function tratta_printer_name(str_printer_name : string) : string; begin result := '##' + str_printer_name + '##' end;

const MBOX_CAPTION_DEBUG = 'init_print_values()';
begin
	writeln_system_debug(0, MBOX_CAPTION_DEBUG, 'str_printer_name=' + str_printer_name + '   str_last_printer_name=' + str_last_printer_name);
	result := (tratta_printer_name(str_printer_name) = str_last_printer_name);
	if result then exit;	// già trattata
	try
		writeln_system_debug(1, MBOX_CAPTION_DEBUG);
//		runtime_debug('000', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);

		writeln_system_debug(1900, MBOX_CAPTION_DEBUG, 'PRINTER TO SELECT: ' + str_printer_name);
		writeln_system_debug(1901, MBOX_CAPTION_DEBUG, 'printer.str_setprinted_device: ' + printer.str_setprinted_device);
		writeln_system_debug(1902, MBOX_CAPTION_DEBUG, 'printer.get_devicename(str_printer_name): ' + printer.get_devicename(str_printer_name));
//		if (str_printer_name <> '') AND (printer.str_setprinted_device <> printer.get_devicename(str_printer_name)) then printer.setPrinter(str_printer_name, 0);
		if (str_printer_name <> '') {AND (printer.str_setprinted_device <> printer.get_devicename(str_printer_name))} then printer.setPrinter(str_printer_name, 0);

//		runtime_debug('010 after setPrinter()', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
		writeln_system_debug(10, MBOX_CAPTION_DEBUG, 'after setPrinter(' + str_printer_name + ')');

		{ 2023-04-07 su WIN64 ci sono problemi ad usare PRINTER.RES*, su WIN32/64 la ADVANCED_GET_PRINTER_INFO a volte rende un valore simbolico (poco utilizzabile)
		  adotto quindi due strategie diverse per WIN32/64
		  WIN32: prima uso la PRINTER.RES*, in caso di fallimento provo la ADVANCED_GET_PRINTER_INFO
		  WIN64: prima provo la ADVANCED_GET_PRINTER_INFO, in caso di fallimento ... boh ??? }
{$ifdef WIN64}
		// se WIN64, per motivi inattingibili, si pianta sulla printers_VCL.Printer.SetState() -- CreateHandleFunc()
		// i valori vengono cmq recuperati attraverso la ADVANCED_GET_PRINTER_INFO()
		i_pixel_per_inch_print_x := 0;i_pixel_per_inch_print_y := 0;i_phisical_10mm_height := 0;i_phisical_10mm_width := 0;
{$else WIN32}
		i_pixel_per_inch_print_x := printer.ResX;i_pixel_per_inch_print_y := printer.ResY;
		i_phisical_10mm_height := printer.PageHeight_10mm;i_phisical_10mm_width := printer.PageWidth_10mm;
{$endif WIN32-64}

		var bo_ok := (i_pixel_per_inch_print_x > 0) AND (i_pixel_per_inch_print_y > 0) AND (i_phisical_10mm_height > 0) AND (i_phisical_10mm_width > 0);
		writeln_system_debug(20, MBOX_CAPTION_DEBUG, 'bo_ok=' + bo_ok.SQL +
			'  i_pixel_per_inch_print_x=' + i_pixel_per_inch_print_x.Tostring + '  i_pixel_per_inch_print_y=' + i_pixel_per_inch_print_y.Tostring +
			'  i_phisical_10mm_height=' + i_phisical_10mm_height.Tostring + '  i_phisical_10mm_width=' + i_phisical_10mm_width.Tostring);
		if NOT bo_ok then begin
			writeln_system_debug(100, MBOX_CAPTION_DEBUG, {$ifdef WIN64} 'chiamo la ' {$else} 'cannot read std values >> ' {$endif} + 'advanced_get_printer_info()');
			advanced_get_printer_info(str_printer_name);
			bo_ok := (i_pixel_per_inch_print_x > 0) AND (i_pixel_per_inch_print_y > 0) AND (i_phisical_10mm_height > 0) AND (i_phisical_10mm_width > 0);
			writeln_system_debug(105, MBOX_CAPTION_DEBUG,
				'  i_pixel_per_inch_print_x=' + i_pixel_per_inch_print_x.ToString + '  i_pixel_per_inch_print_y=' + i_pixel_per_inch_print_y.ToString +
				'  i_phisical_10mm_height=' + i_phisical_10mm_height.ToString + '  i_phisical_10mm_width=' + i_phisical_10mm_width.ToString);

//			runtime_debug('110 after advanced_get_printer_info() -- read=' + byte(bo_ok).ToString, MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
			writeln_system_debug(110, MBOX_CAPTION_DEBUG, 'after advanced_get_printer_info() -- read=' + byte(bo_ok).ToString);
//			i_pixel_per_inch_print_x := -1;
//			if (i_pixel_per_inch_print_x <= 0) OR (i_pixel_per_inch_print_y <= 0) OR (i_phisical_10mm_height <= 0) OR (i_phisical_10mm_width <= 0) then exit
//			if NOT bo_ok then exit
		end;

{$ifdef WIN64}
		if NOT bo_ok then begin
			i_pixel_per_inch_print_x := printer.ResX;i_pixel_per_inch_print_y := printer.ResY;
			i_phisical_10mm_height := printer.PageHeight_10mm;i_phisical_10mm_width := printer.PageWidth_10mm;
			bo_ok := (i_pixel_per_inch_print_x > 0) AND (i_pixel_per_inch_print_y > 0) AND (i_phisical_10mm_height > 0) AND (i_phisical_10mm_width > 0)
		end;
{$endif WIN64}
		if NOT bo_ok then exit;

//		runtime_debug('300', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
		writeln_system_debug(300, MBOX_CAPTION_DEBUG);
		bo_text_only := FALSE;
		result := TRUE
	finally
//		runtime_debug('finally -- result=' + byte(result).Tostring, MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
		writeln_system_debug('finally -- result=' + result.SQL, MBOX_CAPTION_DEBUG);
		if result then str_last_printer_name := tratta_printer_name(str_printer_name)
		else begin
			if bo_message then MessageBBox(0, 'Impossibile leggere i parametri della stampante ' + str_printer_name, MBOX_CAPTION, MB_ICONSTOP);
			i_pixel_per_inch_print_x := 0;i_pixel_per_inch_print_y := 0;
			i_phisical_10mm_height := 0;i_phisical_10mm_width := 0
		end
	end
end;

function TMisure.advanced_get_printer_info(str_printer_name : string = '') : boolean;
{ legge le impostazioni della stampante specificata; rende TRUE in caso di successo, FALSE altrimenti;
  se STR_PRINTER_NAME = '' then legge le impostazioni di PRINTERINDEX }

	procedure get_default_printer_values;
	var h : HDC;	//**
	begin
		try h := printer.handle except exit end;
		try
			i_phisical_10mm_height := round(GetDeviceCaps(h, PHYSICALHEIGHT) / i_pixel_per_inch_print_x * CM_PER_INCH * 100)
		except end;
		try
			i_phisical_10mm_width := round(GetDeviceCaps(h, PHYSICALWIDTH) / i_pixel_per_inch_print_x * CM_PER_INCH * 100)
		except end
	end;

	function symbolic_PrintQuality(i_quality : int64) : boolean;
	// rende TRUE se il valore è simbolico (DMRES_DRAFT / DMRES_LOW / DMRES_MEDIUM / DMRES_HIGH) (ovvero praticamente inutilizzabile)
	const
		DMRES_DRAFT_WIN = -1;	// valori originali, rimappati da Delphi (????)
		DMRES_LOW_WIN = -2;
		DMRES_MEDIUM_WIN = -3;
		DMRES_HIGH_WIN = -4;
		SYMBOLIC_VALUES : array[0..7] of int64 = (
			DMRES_DRAFT, DMRES_LOW, DMRES_MEDIUM, DMRES_HIGH,	// Windows.pas
			DMRES_DRAFT_WIN, DMRES_LOW_WIN, DMRES_MEDIUM_WIN, DMRES_HIGH_WIN);
	begin
{		result := (i_quality = DMRES_DRAFT) OR (i_quality = DMRES_LOW) OR (i_quality = DMRES_MEDIUM) OR (i_quality = DMRES_HIGH) OR
			(i_quality = DMRES_DRAFT_WIN) OR (i_quality = DMRES_LOW_WIN) OR (i_quality = DMRES_MEDIUM_WIN) OR (i_quality = DMRES_HIGH_WIN) }
		for var i : byte := 0 to high(SYMBOLIC_VALUES) do if (i_quality = SYMBOLIC_VALUES[i]) then begin result := TRUE;exit end;
		result := FALSE
	end;

{	function check_PrintQuality(i_quality : int64) : int64;
	begin
		if (i_quality = DMRES_DRAFT) then result := 300 else			// DMRES_DRAFT = LongWord(-1);
		if (i_quality = DMRES_LOW) then result := 300 else				// DMRES_LOW = LongWord(-2);
		if (i_quality = DMRES_MEDIUM) then result := 600 else			// DMRES_MEDIUM = LongWord(-3);
		if (i_quality = DMRES_HIGH) then result := 600					// DMRES_HIGH = LongWord(-4);
		else result := i_quality
	end; }

//const BORDO_SUPERIORE_SICUREZZA_MM = 0;	// margine minimo di stampa, in mm; applicato sia sopra che sotto
const MBOX_CAPTION_DEBUG = 'TMisure.advanced_get_printer_info()';
var
	HPrinter : THandle;	//*
	i_structure_size : Cardinal;	//*
	PrinterDefaults : TPrinterDefaults;	//*
begin
	result := FALSE;
	if (str_printer_name = '') then str_printer_name := printer.Printers[printer.printerindex];

//	str_printer_name := 'Apple Color LaserWriter 12/600';
	PrinterDefaults.DesiredAccess := PRINTER_ACCESS_USE;
	PrinterDefaults.pDatatype := NIL;PrinterDefaults.pDevMode := NIL;
	writeln_system_debug(0, MBOX_CAPTION_DEBUG, 'printer=' + str_printer_name);
	try
		if NOT OpenPrinter(LPSTR(printer.get_devicename(str_printer_name)), HPrinter, @PrinterDefaults) then begin
			writeln_system_debug(100, MBOX_CAPTION_DEBUG, 'OpenPrinter() failed');
			raise exception.create('Errore durante l''accesso alla stampante (OpenPrinter)')
		end;
		try
			SetLastError(0);
			writeln_system_debug(110, MBOX_CAPTION_DEBUG, 'after SetLastError(0)');
			// Determine the number of bytes to allocate for the PRINTER_INFO_2 construct...
			GetPrinter(HPrinter, {structure level}2, NIL, 0, @i_structure_size);
			writeln_system_debug(120, MBOX_CAPTION_DEBUG, 'i_structure_size = ' + i_structure_size.ToString);
			// Allocate memory space for the PRINTER_INFO_2 pointer (PrinterInfo2)...
			// https://learn.microsoft.com/it-it/windows/win32/printdocs/getprinter?redirectedfrom=MSDN
			var PI2 : PPrinterInfo2 := AllocMem(i_structure_size);
			try
				if GetPrinter(HPrinter, {structure level}2, PI2, i_structure_size, @i_structure_size) then begin
					writeln_system_debug(130, MBOX_CAPTION_DEBUG, 'GetPrinter() success');
//					https://learn.microsoft.com/it-it/windows/win32/api/wingdi/ns-wingdi-devmodea

{					if (PI2.pDevMode.dmFields AND DM_YRESOLUTION <> 0) OR (PI2.pDevmode.dmPrintQuality <> 0) then begin
						i_pixel_per_inch_print_x := PI2.pDevmode.dmPrintQuality;		// = -2
//						i_pixel_per_inch_print_x := check_PrintQuality(PI2.pDevmode.dmPrintQuality);		// = -2
						i_pixel_per_inch_print_y := PI2.pDevmode.dmYResolution;		// = 0
//						i_pixel_per_inch_print_y := check_PrintQuality(PI2.pDevmode.dmYResolution);		// = 0
						writeln_system_debug(140, MBOX_CAPTION_DEBUG, 'i_pixel_per_inch_print_x=' + i_pixel_per_inch_print_x.ToString +
							'  i_pixel_per_inch_print_y=' + i_pixel_per_inch_print_y.ToString);
						// 2021-08-05: non capisco ma su certe stampanti la X viene inizializzata ma la Y no !!!! (esempio Win10 ANESA)
						if (i_pixel_per_inch_print_y = 0) then i_pixel_per_inch_print_y := i_pixel_per_inch_print_x
					end; }

					if (PI2.pDevMode.dmFields AND DM_YRESOLUTION <> 0) then begin
						i_pixel_per_inch_print_x := PI2.pDevmode.dmPrintQuality;
						i_pixel_per_inch_print_y := PI2.pDevmode.dmYResolution;
						writeln_system_debug(135, MBOX_CAPTION_DEBUG, 'i_pixel_per_inch_print_x=' + i_pixel_per_inch_print_x.ToString +
							'  i_pixel_per_inch_print_y=' + i_pixel_per_inch_print_y.ToString)
					end
					else if (PI2.pDevmode.dmPrintQuality <> 0) AND NOT symbolic_PrintQuality(PI2.pDevmode.dmPrintQuality) then begin
						i_pixel_per_inch_print_x := PI2.pDevmode.dmPrintQuality;
						i_pixel_per_inch_print_y := PI2.pDevmode.dmYResolution;
						if (i_pixel_per_inch_print_y = 0) then i_pixel_per_inch_print_y := i_pixel_per_inch_print_x	// improprio, ma ...
					end;

//					get_default_printer_values;	// a scanso di equivoci
					// se possibile leggo la dimensione dal formato della carta
					get_paper_size(PI2.pDevMode, i_phisical_10mm_width, i_phisical_10mm_height);
					writeln_system_debug(150, MBOX_CAPTION_DEBUG, 'i_phisical_10mm_width=' + i_phisical_10mm_width.ToString + '   i_phisical_10mm_height=' + i_phisical_10mm_height.ToString);

					// provo sempre e comunque a leggere la dimensione esplicita
					if (PI2.pDevMode.dmFields AND DM_PAPERLENGTH <> 0) then begin
						i_phisical_10mm_height := PI2.pdevmode.dmPaperLength;
						writeln_system_debug(160, MBOX_CAPTION_DEBUG, 'i_phisical_10mm_height = ' + i_phisical_10mm_height.ToString)
					end;
					if (PI2.pDevMode.dmFields AND DM_PAPERWIDTH <> 0) then begin
						i_phisical_10mm_width := PI2.pdevmode.dmPaperWidth;
						writeln_system_debug(170, MBOX_CAPTION_DEBUG, 'i_phisical_10mm_width=' + i_phisical_10mm_width.ToString)
					end;
//					dec(i_phisical_10mm_height, BORDO_SUPERIORE_SICUREZZA_MM * 2 * 10);
					result := TRUE
				end
				else begin
					writeln_system_debug(900, MBOX_CAPTION_DEBUG, 'GetPrinter(): chiamata fallita');
					raise exception.create('GetPrinter(): chiamata fallita')
				end
			finally
				FreeMem(PI2, i_structure_size)
			end
		finally
			ClosePrinter(HPrinter)
		end
	except
		writeln_system_debug(999, MBOX_CAPTION_DEBUG, 'exception');
		{$ifdef DEBUG} error_msg(NIL, 'Impossibile leggere le impostazioni della stampante ' + str_printer_name, MBOX_CAPTION); {$endif}
		get_default_printer_values
	end
end;

(*  {test print using selected resolution}
  Printer.GetPrinter(Device, Driver, Port, hDevmode);
  {force reset of devmode}
  Printer.SetPrinter(Device, Driver, Port, 0);
  Printer.GetPrinter(Device, Driver, Port, hDevmode);
  if hDevmode <> 0 then
  begin
	 pDevmode := GlobalLock(hDevmode);
	 if pDevmode <> nil then
	 try
		pDevMode^.dmPrintQuality := LoWord(dw);
		pDevmode^.dmYResolution := HiWord(dw);
		pDevmode^.dmFields := pDevmode^.dmFields or DM_PRINTQUALITY or DM_YRESOLUTION;
	 finally
		GlobalUnlock(hDevmode);
	 end; *)

procedure init_misure;
// soprattutto se WIN64 da NON chiamare prima dell'avvio dell' EXE, altrimenti si pianta tutto (2025-12-29)
begin
	init_printer;		// eseguo qui perchè altrimenti a volte dà problemi
//	bo_nessuna_stampante_installata := (printer.printers.Count = 0);
	tm := TMisure.create
end;

initialization
	galateo_initialization_debug('misure');
//{$ifdef WIN64} {$ifdef DEBUG} exit; {$else} ******* {$endif} {$endif}
//	init_misure		// soprattutto se WIN64 da NON chiamare prima dell'avvio dell' EXE, altrimenti si pianta tutto (2025-12-29)
finalization
	galateo_finalization_debug('misure')
end.
