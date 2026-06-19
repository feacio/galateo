unit printers_DX;		// modifiche derivative alla unit VCL.Printers -- ricopiata su PRINTERS_VCL.pas

{$ifndef DEBUG} *** {$endif DEBUG}	// identificare cambio di postazione virtuale, ricaricare stampanti
{https://stackoverflow.com/questions/1228290/delphi-printer-printers-not-refreshing


http://www.delphigroups.info/2/61/315531.html
You can destroy the current printer object with
  SetPrinter(Nil).Free;
On the next use of Printer (which is a function that returns the internal
TPrinter object maintained by the Printers unit) a new TPrinter instance
will be created and that rereads the printer list.
Peter Below (TeamB)  100113.1...@compuserve.com)
No e-mail responses, please, unless explicitely requested! }

interface

{*$define LIMITED_DEBUG}

uses Windows, WinSpool, UITypes, SysUtils, Classes, Graphics, Forms,
	printers_VCL, Gdich;

procedure init_printer;
function get_default_printer_index : smallint;		// rende la stampante predefinita (quella default di sistema)

function get_paper_size(devmode : PDeviceMode;var i_phisical_10mm_width, i_phisical_10mm_height : integer) : boolean;

var
	bo_nessuna_stampante_installata : boolean;	// TRUE se non ci sono stampanti nel sistema
	bo_invalid_selected_printer : boolean;	// TRUE se la stampante selezionata non è valida

type
	TFPrinter = class(TPrinter)
		private
			str_current_printer_name : string;	// stampante attiva
			i_pixel_per_inch_print_x, i_pixel_per_inch_print_y : int_pixel_type;
			i_phisical_10mm_height, i_phisical_10mm_width : integer;
			procedure reset_devicemode;	// by federico
			function GetPageHeight_10mm : integer;
			function GetPageWidth_10mm : integer;
			function GetResX : integer;
			function GetResY : integer;
	  public
//			str_setprinted_device : string;	// stampante per la quale è stata eseguita la SetPrinter()
			function document_properties(father : TForm) : boolean;
			function get_devicename(str_printer_name : string) : string;
			procedure SetPrinter(str_printer_name : string;ADeviceMode : THandle); overload;
			property PageHeight_10mm: Integer read GetPageHeight_10mm;
			property PageWidth_10mm: Integer read GetPageWidth_10mm;
			property resx: Integer read GetResX;	// in pixels per pollice
			property resy: Integer read GetResY;	// in pixels per pollice
	end;

	{$ifdef DEBUG} TPrinter = array of smallint; {$endif}

{ Printer function - Replaces the Printer global variable of previous versions,
  to improve smart linking (reduce exe size by 2.5k in projects that don't use
  the printer).  Code which assigned to the Printer global variable
  must call SetPrinter instead.  SetPrinter returns current printer object
  and makes the new printer object the current printer.  It is the caller's
  responsibility to free the old printer, if appropriate.  (This allows
  toggling between different printer objects without destroying configuration
  settings.) }

function Printer : TFPrinter;
function SetPrinter(NewPrinter : TFPrinter) : TFPrinter;

{ AssignPrn - Assigns a Text variable to the currently selected printer.  Any
  Write or Writeln's going to that file variable will be written on the
  printer using the Canvas property's font.  A new page is automatically
  started if a CR is encountered on (or a Writeln is written to) the last
  line on the page.  Closing the text file will imply a call to the
  Printer.EndDoc method. Note: only one Text variable can be open on the
  printer at a time.  Opening a second will cause an exception.}

//procedure AssignPrn(var F: Text);

implementation

uses FCommons, galateo_debug, FAssert, FErrMsg, FProcs
	{$ifNdef LIMITED_DEBUG},pages{$endif};

var
//	FPrinter: TFPrinter = NIL;		*** usa PRINTERS_VCL.static_FPrinter
	i_default_printer_index : smallint;

function Printer : TFPrinter;
begin
	if (static_FPrinter = NIL) then static_FPrinter := TFPrinter.Create;
	result := TFPrinter(static_FPrinter)
end;

{$IF DEFINED(CLR)}[PrintingPermission(SecurityAction.LinkDemand, Level=PrintingPermissionLevel.AllPrinting)]{$ENDIF}
function SetPrinter(NewPrinter : TFPrinter): TFPrinter;
begin
	Result := Printer;
	TFPrinter(static_FPrinter) := NewPrinter
end;

function get_paper_size(devmode : PDeviceMode;var i_phisical_10mm_width, i_phisical_10mm_height : integer) : boolean;
{ legge la dimensione del foglio fisico in funzione del tipo di carta;
  imposta i_phisical_10mm_width e i_phisical_10mm_height;
  rende TRUE in caso di successo, FALSE altrimenti }

	procedure set_inches(fl_width, fl_height : real;bo_rotated : boolean = FALSE);
	begin
		if bo_rotated then begin
			i_phisical_10mm_width := round(inches2cm(fl_height) * 100);
			i_phisical_10mm_height := round(inches2cm(fl_width) * 100)
		end
		else begin
			i_phisical_10mm_width := round(inches2cm(fl_width) * 100);
			i_phisical_10mm_height := round(inches2cm(fl_height) * 100)
		end;
{$ifNdef LIMITED_DEBUG}
		runtime_debug('width/height = ' + i_phisical_10mm_width.ToString + '/' +
			i_phisical_10mm_height.ToString + ' mm', 'print_functions.SetInches()', RD_DEBUG_ACCESSORIO_01)
{$endif}
	end;

	procedure set_mm(i_width, i_height : smallint;bo_rotated : boolean = FALSE);
	begin
		if bo_rotated then begin
			i_phisical_10mm_width := i_height * 10;
			i_phisical_10mm_height := i_width * 10
		end
		else begin
			i_phisical_10mm_width := i_width * 10;
			i_phisical_10mm_height := i_height * 10
		end;
{$ifNdef LIMITED_DEBUG}
		runtime_debug('width/height = ' + i_phisical_10mm_width.ToString + '/' + i_phisical_10mm_height.ToString + ' mm', 'print_functions.SetMM()', RD_DEBUG_ACCESSORIO_01)
{$endif}
	end;

begin
	result := FALSE;
	if ((devmode.dmFields AND DM_PAPERSIZE) = 0) then exit;
	case devmode.dmPaperSize of
		DMPAPER_LETTER : set_inches(8.5, 11);
		DMPAPER_LEGAL : set_inches(8.5, 14);
		DMPAPER_10X14 : set_inches(10, 14);
		DMPAPER_11X17 : set_inches(11, 17);
		DMPAPER_12X11 : set_inches(12, 11);
		DMPAPER_A3 : set_mm(297, 420);
		DMPAPER_A3_ROTATED : set_mm(420, 297);
		DMPAPER_A4 : set_mm(210, 297);
		DMPAPER_A4_ROTATED : set_mm(210, 297, TRUE);
		DMPAPER_A4SMALL : set_mm(210, 297);
		DMPAPER_A5 : set_mm(148, 210);
		DMPAPER_A5_ROTATED : set_mm(148, 210, TRUE);
		DMPAPER_A6 : set_mm(105, 148);
		DMPAPER_A6_ROTATED : set_mm(105, 148, TRUE);
		DMPAPER_B4 : set_mm(250, 354);
		DMPAPER_B4_JIS_ROTATED : set_mm(257, 364, TRUE);
		DMPAPER_B5 : set_mm(182, 257);
		DMPAPER_B5_JIS_ROTATED : set_mm(182, 257, TRUE);
		DMPAPER_B6_JIS : set_mm(128, 182);
		DMPAPER_B6_JIS_ROTATED : set_mm(128, 182, TRUE);
		DMPAPER_CSHEET : set_inches(17,22);
		DMPAPER_DBL_JAPANESE_POSTCARD : set_mm(200, 148);
		DMPAPER_DBL_JAPANESE_POSTCARD_ROTATED : set_mm(200, 148,TRUE);
		DMPAPER_DSHEET : set_inches(22, 34);
		DMPAPER_ENV_9 : set_inches(3.875, 8.875);
		DMPAPER_ENV_10 : set_inches(4.125, 9.5);
		DMPAPER_ENV_11 : set_inches(4.5, 10.375);
		DMPAPER_ENV_12 : set_inches(4.75, 11);
		DMPAPER_ENV_14 : set_inches(5, 11.5);
		DMPAPER_ENV_C5 : set_mm(162, 229);
		DMPAPER_ENV_C3 : set_mm(324, 458);
		DMPAPER_ENV_C4 : set_mm(229, 324);
		DMPAPER_ENV_C6 : set_mm(114, 162);
		DMPAPER_ENV_C65 : set_mm(114, 229);
		DMPAPER_ENV_B4 : set_mm(250, 353);
		DMPAPER_ENV_B5 : set_mm(176, 250);
		DMPAPER_ENV_B6 : set_mm(176, 125);
		DMPAPER_ENV_DL : set_mm(110, 220);
		DMPAPER_ENV_ITALY : set_mm(110, 230);
		DMPAPER_ENV_MONARCH : set_inches(3.875, 7.5);
		DMPAPER_ENV_PERSONAL : set_inches(3.625, 6.5);
		DMPAPER_ESHEET : set_inches(34, 44);
		DMPAPER_EXECUTIVE : set_inches(7.25, 10.5);
		DMPAPER_FANFOLD_US : set_inches(14.875, 11);
		DMPAPER_FANFOLD_STD_GERMAN : set_inches(8.5, 12);
		DMPAPER_FANFOLD_LGL_GERMAN : set_inches(8, 13);
		DMPAPER_FOLIO : set_inches(8.5, 13);
		DMPAPER_JAPANESE_POSTCARD_ROTATED : set_mm(148, 100);
//		DMPAPER_JENV_CHOU3
//		DMPAPER_JENV_CHOU3_ROTATED               otated
//		DMPAPER_JENV_CHOU4
//		DMPAPER_JENV_CHOU4_ROTATED               otated
//		DMPAPER_JENV_KAKU2
//		DMPAPER_JENV_KAKU2_ROTATED               otated
//		DMPAPER_JENV_KAKU3
//		DMPAPER_JENV_KAKU3_ROTATED               otated
//		DMPAPER_JENV_YOU4
//		DMPAPER_JENV_YOU4_ROTATED                tated
//		DMPAPER_LAST                             Windows 2000/xp: dmpaper_penv_10_rotated
		DMPAPER_LEDGER : set_inches(17,11);
		DMPAPER_LETTER_ROTATED : set_inches(8.5, 11, TRUE);
		DMPAPER_LETTERSMALL : set_inches(8.5, 11);
		DMPAPER_NOTE : set_inches(8.5, 11);
		DMPAPER_P16K : set_mm(146, 215);
		DMPAPER_P16K_ROTATED : set_mm(146, 215, TRUE);
		DMPAPER_P32K : set_mm(97, 151);
		DMPAPER_P32K_ROTATED : set_mm(97, 151, TRUE);
		DMPAPER_P32KBIG : set_mm(97, 151);
		DMPAPER_P32KBIG_ROTATED : set_mm(97, 151, TRUE);
		DMPAPER_PENV_1 : set_mm(102, 165);
		DMPAPER_PENV_1_ROTATED : set_mm(102, 165, TRUE);
		DMPAPER_PENV_2 : set_mm(102, 176);
		DMPAPER_PENV_2_ROTATED : set_mm(102, 176, TRUE);
		DMPAPER_PENV_3 : set_mm(125, 176);
		DMPAPER_PENV_3_ROTATED : set_mm(125, 176, TRUE);
		DMPAPER_PENV_4 : set_mm(110, 208);
		DMPAPER_PENV_4_ROTATED : set_mm(110, 208, TRUE);
		DMPAPER_PENV_5 : set_mm(110, 220);
		DMPAPER_PENV_5_ROTATED : set_mm(110, 220, TRUE);
		DMPAPER_PENV_6 : set_mm(120, 230);
		DMPAPER_PENV_6_ROTATED : set_mm(120, 230, TRUE);
		DMPAPER_PENV_7 : set_mm(160, 230);
		DMPAPER_PENV_7_ROTATED : set_mm(160, 230, TRUE);
		DMPAPER_PENV_8 : set_mm(120, 309);
		DMPAPER_PENV_8_ROTATED : set_mm(120, 309, TRUE);
		DMPAPER_PENV_9 : set_mm(229, 324);
		DMPAPER_PENV_9_ROTATED : set_mm(229, 324, TRUE);
		DMPAPER_PENV_10 : set_mm(324, 458);
		DMPAPER_PENV_10_ROTATED : set_mm(324, 458, TRUE);
		DMPAPER_QUARTO : set_mm(215,275);
		DMPAPER_STATEMENT : set_inches(5.5, 8.5);
		DMPAPER_TABLOID : set_inches(11, 17);
		else begin
{$ifdef DEBUG}
			assert(FALSE,'DKMN 9991 -- UNKNOWN PAPER TYPE ' + devmode.dmPaperSize.ToString);
{$else}
			runtime_debug('unknown paperSize (' + devmode.dmPaperSize.ToString + ')', 'print_functions.get_paper_size()', RD_DEBUG_ACCESSORIO_01);
{$endif}
			exit
		end
	end;
	result := TRUE
end;

// -------------------------------------------------------------------------------------------------------------------------------------

function TFPrinter.document_properties(father : TForm) : boolean;
// apre la pagina di impostazioni avanzate per la stampante; rende TRUE se sono state effettuate impostazioni, FALSE altrimenti
var
	lo : integer;	//*
	StubDevMode: TDeviceMode;	//*
begin
	result := FALSE;
	var handle : HWND := 0;
	if (father <> NIL) then handle := father.Handle;
	var wstr_setprinted_device : WideString := str_setprinted_device;
	try
		if (fDeviceMode = 0) then begin		// alloc new device mode block if one was not passed in
//			lo := DocumentProperties(0, FPrinterHandle, LPSTR(str_setprinted_device), StubDevMode, StubDevMode, 0);
//			lo := DocumentProperties(0, FPrinterHandle, PChar(str_setprinted_device), StubDevMode, StubDevMode, 0);
			lo := DocumentProperties(0, FPrinterHandle, @wstr_setprinted_device, StubDevMode, StubDevMode, 0);
			fDeviceMode := GlobalAlloc(GHND, lo);
			if (fDeviceMode <> 0) then	begin
				fDevMode := GlobalLock(fDeviceMode);
//				lo := DocumentProperties(0, FPrinterHandle, LPSTR(str_setprinted_device), DevMode^, DevMode^, DM_OUT_BUFFER);
//				lo := DocumentProperties(0, FPrinterHandle, PChar(str_setprinted_device), fDevMode^, fDevMode^, DM_OUT_BUFFER);
				lo := DocumentProperties(0, FPrinterHandle, @wstr_setprinted_device, fDevMode^, fDevMode^, DM_OUT_BUFFER);
				if (lo < 0) then begin
					reset_devicemode;
					abort
				end
			end
		end;

//		lo := DocumentProperties(wh, FPrinterHandle, LPSTR(str_setprinted_device), DevMode^, DevMode^, DM_IN_BUFFER OR DM_PROMPT OR DM_OUT_BUFFER);
//		lo := DocumentProperties(wh, FPrinterHandle, PChar(str_setprinted_device), fDevMode^, fDevMode^, DM_IN_BUFFER OR DM_PROMPT OR DM_OUT_BUFFER);
		lo := DocumentProperties(handle, FPrinterHandle, @wstr_setprinted_device, fDevMode^, fDevMode^, DM_IN_BUFFER OR DM_PROMPT OR DM_OUT_BUFFER);
		if (lo < 0) then begin	// se la chiamata fallisce
			reset_devicemode;
			abort
		end;
		result := (lo = IDOK);
//		if result then SetState(psNoHandle)	// faccio ricreare l'handle, quando necessario
		if result then SetState(System.UITypes.TPrinterState.psNoHandle)	// faccio ricreare l'handle, quando necessario
	except
		error_msg(father, 'Impossibile aprire la pagina delle impostazioni avanzate', str_setprinted_device)
	end
end;

function TFPrinter.get_devicename(str_printer_name : string) : string;
{ rende il nome del device associato alla stampante specificata; serve per effettuare le chiamata a SetPrinter()
  STR_PRINTER_NAME può essere ricavato da PRINTER.PRINTERS;
  STR_PRINTER_NAME può essere, ad esempio: "HP Laserjet III on LPT1"
  il device corrispondente tipicamente è : "HP Laserjet III" }
begin
	var i : smallint := printers.indexof(str_printer_name);
	if (i = -1) then result := '' else result := TPrinterDevice(printers.Objects[I]).Device
end;

function TFPrinter.GetPageHeight_10mm : integer;
begin
	if (i_phisical_10mm_height = 0) then i_phisical_10mm_height := round(GetDeviceCaps(Handle, PHYSICALHEIGHT) / GetResY * CM_PER_INCH * 100.0);
	result := i_phisical_10mm_height
end;

function TFPrinter.GetPageWidth_10mm : integer;
begin
	if (i_phisical_10mm_width = 0) then i_phisical_10mm_width := round(GetDeviceCaps(Handle, PHYSICALWIDTH) / GetResX * CM_PER_INCH * 100.0);
	result := i_phisical_10mm_width
end;

function TFPrinter.GetResX : integer;		// risoluzione orizzontale, in pixels per pollice
begin
//	i_pixel_per_inch_print_x := GetDeviceCaps(DC, LOGPIXELSX); *-*
//	i_pixel_per_inch_print_x := GetDeviceCaps(FPrinterHandle, LOGPIXELSX);
	if (i_pixel_per_inch_print_x = 0) then i_pixel_per_inch_print_x := GetDeviceCaps(Handle, LOGPIXELSX);
	result := i_pixel_per_inch_print_x
end;

function TFPrinter.GetResY : integer;		// risoluzione verticale, in pixels per pollice
begin
	if (i_pixel_per_inch_print_y = 0) then i_pixel_per_inch_print_y := GetDeviceCaps(Handle, LOGPIXELSY);
	result := i_pixel_per_inch_print_y
end;

procedure init_printer;
// soprattutto se WIN64 da NON chiamare prima dell'avvio dell' EXE, altrimenti si pianta tutto (2025-12-29)
begin
	if (static_FPrinter = NIL) then i_default_printer_index := printer.PrinterIndex
end;

function get_default_printer_index : smallint;
// rende la stampante predefinita (quella default di sistema)
begin
	result := i_default_printer_index
end;

procedure TFPrinter.reset_devicemode;
begin
	if (fDeviceMode <> 0) then begin
		GlobalUnlock(fDeviceMode);GlobalFree(fDeviceMode);
		fDeviceMode := 0
	end;
	fdevmode := NIL;
	i_pixel_per_inch_print_x := 0;i_pixel_per_inch_print_y := 0;
	i_phisical_10mm_height := 0;i_phisical_10mm_width := 0
end;

procedure TFPrinter.SetPrinter(str_printer_name : string;ADeviceMode : THandle);
// str_printer_name è il nome della stampante (ricavabile da printer.printers)
begin
	str_printer_name := get_devicename(str_printer_name);
//	{$ifdef DEBUG} assert(str_printer_name <> '','SetPrinter(): device not found KKDW 2838'); {$endif}
//	if (str_printer_name <> '') then SetPrinter(LPSTR(str_printer_name), '', '', ADeviceMode)
//	if (str_printer_name <> '') then SetPrinter(PChar(str_printer_name), '', '', ADeviceMode)
	if (str_printer_name <> '') AND (str_printer_name <> str_current_printer_name) then begin
		reset_devicemode;
		SetPrinter(PChar(str_printer_name), '', '', ADeviceMode);
		str_current_printer_name := str_printer_name
	end
end;

initialization
	galateo_initialization_debug('DX_printers');
//	init_printer	**** soprattutto se WIN64 da NON chiamare prima dell'avvio dell' EXE, altrimenti si pianta tutto (2025-12-29)
finalization
	galateo_finalization_debug('DX_printers');
	if (static_FPrinter <> NIL) then begin TFPrinter(static_FPrinter).Free;static_FPrinter := NIL end
end.
