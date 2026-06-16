unit xprinters;	// unit PRINTER.PAS rivista da Federico, 2004-07, versione $0234 (2.52)

{$I defines}
{$ifdef DLL} {$undef RD}  {$endif}	// altrimenti fa casino con la unit PAGES

{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{  Copyright (c) 1995-2001 Borland Software Corporation }
{                                                       }
{*******************************************************}

interface

uses Windows, WinSpool, SysUtils, Classes, Graphics, Forms,
	dich;

function get_paper_size(devmode : PDeviceMode;var i_phisical_10mm_width, i_phisical_10mm_height : integer) : boolean;
function	cm2inches(r : real) : real;
function	inches2cm(r : real) : real;

type
  EPrinter = class(Exception);

  { TPrinter }

  { The printer object encapsulates the printer interface of Windows.  A print
	 job is started whenever any rendering is done either through a Text variable
    or the printers canvas.  This job will stay open until EndDoc is called or
    the Text variable is closed.  The title displayed in the Print Manager (and
	 on network header pages) is determined by the Title property.

    EndDoc - Terminates the print job (and closes the currently open Text).
      The print job will being printing on the printer after a call to EndDoc.
	 NewPage - Starts a new page and increments the PageNumber property.  The
      pen position of the Canvas is put back at (0, 0).
    Canvas - Represents the surface of the currently printing page.  Note that
      some printer do not support drawing pictures and the Draw, StretchDraw,
		and CopyRect methods might fail.
	 Fonts - The list of fonts supported by the printer.  Note that TrueType
		fonts appear in this list even if the font is not supported natively on
      the printer since GDI can render them accurately for the printer.
	 PageHeight - The height, in pixels, of the page.
	 PageWidth - The width, in pixels, of the page.
	 PageNumber - The current page number being printed.  This is incremented
      when ever the NewPage method is called.  (Note: This property can also be
		incremented when a Text variable is written, a CR is encounted on the
      last line of the page).
    PrinterIndex - Specifies which printer in the TPrinters list that is
		currently selected for printing.  Setting this property to -1 will cause
		the default printer to be selected.  If this value is changed EndDoc is
		called automatically.
    Printers - A list of the printers installed in Windows.
    Title - The title used by Windows in the Print Manager and for network
      title pages. }

  TPrinterState = (psNoHandle, psHandleIC, psHandleDC);
  TPrinterOrientation = (poPortrait, poLandscape);
  TPrinterCapability = (pcCopies, pcOrientation, pcCollation);
  TPrinterCapabilities = set of TPrinterCapability;

  TPrinter = class(TObject)
  private
	 FCanvas: TCanvas;
	 FFonts: TStrings;
	 FPageNumber: Integer;
	 FPrinters: TStrings;
	 FPrinterIndex: Integer;
	 FTitle: string;
	 FPrinting: Boolean;
	 FAborted: Boolean;
	 FCapabilities: TPrinterCapabilities;
	 State: TPrinterState;
	 DC: HDC;
	 DevMode: PDeviceMode;
	 DeviceMode: THandle;
	 FPrinterHandle: THandle;
	 procedure SetState(Value: TPrinterState);
	 function GetCanvas: TCanvas;
	 function GetNumCopies: Integer;
	 function GetFonts: TStrings;
	 function GetHandle: HDC;
	 function GetOrientation: TPrinterOrientation;
	 function GetPageHeight: Integer;
	 function GetPageWidth: Integer;
	 function GetPrinterIndex: Integer;
	 procedure SetPrinterCapabilities(DevMode: PDeviceMode);
	 procedure SetPrinterIndex(Value: Integer);
	 function GetPrinters : TStrings;
	 procedure SetNumCopies(Value: Integer);
	 procedure SetOrientation(Value: TPrinterOrientation);
	 procedure SetToDefaultPrinter;
	 procedure CheckPrinting(Value: Boolean);
	 procedure FreePrinters;
	 procedure FreeFonts;
	private
		i_pixel_per_inch_print_x, i_pixel_per_inch_print_y : int_pixel_type;
		i_phisical_10mm_height, i_phisical_10mm_width : integer;
		procedure reset_devicemode;	// by federico
		function GetPageHeight_10mm : integer;
		function GetPageWidth_10mm : integer;
		function GetResX : integer;
		function GetResY : integer;
  public
		str_setprinted_device : string;	// stampante per la quale è stata eseguita la SetPrinter()
	 constructor Create;
	 destructor Destroy; override;
	 procedure Abort;
	 procedure BeginDoc;
	 procedure EndDoc;
	 procedure NewPage;
	 procedure GetPrinter(ADevice, ADriver, APort: PChar; var ADeviceMode: THandle);
	 procedure SetPrinter(ADevice, ADriver, APort: PChar; ADeviceMode: THandle); overload;
	 procedure SetPrinter(str_printer_name : string;ADeviceMode: THandle); overload;
	 procedure Refresh;
	 property Aborted: Boolean read FAborted;
	 property Canvas: TCanvas read GetCanvas;
	 property Capabilities: TPrinterCapabilities read FCapabilities;
	 property Copies: Integer read GetNumCopies write SetNumCopies;
	 property Fonts: TStrings read GetFonts;
	 property Handle : HDC read GetHandle;
	 property Orientation: TPrinterOrientation read GetOrientation write SetOrientation;
	 property PageHeight: Integer read GetPageHeight;
	 property PageWidth: Integer read GetPageWidth;
	 property PageNumber: Integer read FPageNumber;
	 property PrinterIndex: Integer read GetPrinterIndex write SetPrinterIndex;
	 property Printing: Boolean read FPrinting;
	 property Printers: TStrings read GetPrinters;
	 property Title: string read FTitle write FTitle;
		// by federico
		function document_properties(father : TForm) : boolean;
		function get_devicename(str_printer_name : string) : string;
		property PageHeight_10mm: Integer read GetPageHeight_10mm;
		property PageWidth_10mm: Integer read GetPageWidth_10mm;
		property resx: Integer read GetResX;	// in pixels per pollice
		property resy: Integer read GetResY;	// in pixels per pollice
  end;

{ Printer function - Replaces the Printer global variable of previous versions,
  to improve smart linking (reduce exe size by 2.5k in projects that don't use
  the printer).  Code which assigned to the Printer global variable
  must call SetPrinter instead.  SetPrinter returns current printer object
  and makes the new printer object the current printer.  It is the caller's
  responsibility to free the old printer, if appropriate.  (This allows
  toggling between different printer objects without destroying configuration
  settings.) }

//function Printer: TPrinter;
var Printer: TPrinter = NIL;

//function SetPrinter(NewPrinter: TPrinter): TPrinter;

{ AssignPrn - Assigns a Text variable to the currently selected printer.  Any
  Write or Writeln's going to that file variable will be written on the
  printer using the Canvas property's font.  A new page is automatically
  started if a CR is encountered on (or a Writeln is written to) the last
  line on the page.  Closing the text file will imply a call to the
  Printer.EndDoc method. Note: only one Text variable can be open on the
  printer at a time.  Opening a second will cause an exception.}

procedure AssignPrn(var F: Text);

implementation

uses FAssert,
	{$ifdef RD} pages, {$endif}
	Consts, error_messages;

function FetchStr(var Str : PChar): PChar;
var P : PChar;
begin
	Result := Str;
	if (Str = NIL) then Exit;
	P := Str;
	while (P^ = ' ') do Inc(P);
	Result := P;
	while (P^ <> #0) and (P^ <> ',') do Inc(P);
	if (P^ = ',') then begin P^ := #0;Inc(P) end;
	Str := P
end;

procedure RaiseError(const Msg: string);
begin
	raise EPrinter.Create(Msg)
end;

function AbortProc(Prn: HDC; Error: Integer): Bool; stdcall;
begin
	Application.ProcessMessages;
	Result := NOT Printer.Aborted
end;

type
  PrnRec = record
	 case Integer of
		1: (
		  Cur: TPoint;
		  Finish: TPoint;				// End of the printable area
		  Height: Integer);			// Height of the current line
		2: (
		  Tmp: array[1..32] of Char);
  end;

procedure NewPage(var Prn: PrnRec);
begin
	with Prn do begin
		Cur.X := 0;Cur.Y := 0;
		Printer.NewPage
	end
end;

procedure NewLine(var Prn: PrnRec);
// Start a new line on the current page, if no more lines left start a new page

	function CharHeight: Word;
	var Metrics: TTextMetric;
	begin
		GetTextMetrics(Printer.Canvas.Handle, Metrics);
		Result := Metrics.tmHeight
	end;

begin
	with Prn do begin
		Cur.X := 0;
		if (Height = 0) then Inc(Cur.Y, CharHeight) else Inc(Cur.Y, Height);
		if Cur.Y > (Finish.Y - (Height * 2)) then NewPage(Prn);
		Height := 0
	end
end;

procedure PrnOutStr(var Prn: PrnRec; Text: PChar; Len: Integer);
// Print a string to the printer without regard to special characters.  These should handled by the caller.
var
  Extent: TSize;
  L: Integer;
begin
	with Prn, Printer.Canvas do begin
		while (Len > 0) do begin
			L := Len;
			GetTextExtentPoint(Handle, Text, L, Extent);

			while (L > 0) and (Extent.cX + Cur.X > Finish.X) do begin
				L := CharPrev(Text, Text+L) - Text;
				GetTextExtentPoint(Handle, Text, L, Extent)
			end;

			if (Extent.cY > Height) then Height := Extent.cY + 2;
			Windows.TextOut(Handle, Cur.X, Cur.Y, Text, L);
			Dec(Len, L);Inc(Text, L);
			if (Len > 0) then NewLine(Prn) else Inc(Cur.X, Extent.cX)
		end
	end
end;

procedure PrnString(var Prn: PrnRec; Text: PChar; Len: Integer);
// Print a string to the printer handling special characters.
var
	L: Integer;
	TabWidth: Word;

	procedure Flush;
	begin
		if (L <> 0) then PrnOutStr(Prn, Text, L);
		Inc(Text, L + 1);
		Dec(Len, L + 1);
		L := 0
	end;

	function AvgCharWidth: Word;
	var Metrics: TTextMetric;
	begin
		GetTextMetrics(Printer.Canvas.Handle, Metrics);
		Result := Metrics.tmAveCharWidth
	end;

begin
	L := 0;
	with Prn do begin
		while (L < Len) do begin
			case Text[L] of
				#9: begin
					Flush;
					TabWidth := AvgCharWidth * 8;
					Inc(Cur.X, TabWidth - ((Cur.X + TabWidth + 1) mod TabWidth) + 1);
					if Cur.X > Finish.X then NewLine(Prn)
				end;
				#13: Flush;
				#10: begin Flush;NewLine(Prn) end;
				^L: begin Flush;NewPage(Prn) end;
				else Inc(L)
			end
		end
	end;
	Flush
end;

function PrnInput(var F: TTextRec): Integer;
{ Called when a Read or Readln is applied to a printer file. Since reading is
  illegal this routine tells the I/O system that no characters where read, which
  generates a runtime error. }
begin
	with F do begin BufPos := 0;BufEnd := 0 end;
	Result := 0
end;

function PrnOutput(var F: TTextRec): Integer;
// Called when a Write or Writeln is applied to a printer file. The calls PrnString to write the text in the buffer to the printer.
begin
	with F do begin
		PrnString(PrnRec(UserData), PChar(BufPtr), BufPos);
		BufPos := 0;
		Result := 0
	end
end;

function PrnIgnore(var F: TTextRec): Integer;
// Will ignore certain requests by the I/O system such as flush while doing an input.
begin
	Result := 0
end;

function PrnClose(var F: TTextRec): Integer;
// Deallocates the resources allocated to the printer file.
begin
	with PrnRec(F.UserData) do begin
		Printer.EndDoc;
		Result := 0
	end
end;

function PrnOpen(var F: TTextRec): Integer;
// Called to open I/O on a printer file.  Sets up the TTextFile to point to printer I/O functions.
const Blank: array[0..0] of Char = '';
begin
	with F, PrnRec(UserData) do begin
		if (Mode = fmInput) then begin
			InOutFunc := @PrnInput;
			FlushFunc := @PrnIgnore;
			CloseFunc := @PrnIgnore
		end
		else begin
			Mode := fmOutput;
			InOutFunc := @PrnOutput;
			FlushFunc := @PrnOutput;
			CloseFunc := @PrnClose;
			Printer.BeginDoc;

			Cur.X := 0;Cur.Y := 0;
			Finish.X := Printer.PageWidth;
			Finish.Y := Printer.PageHeight;
			Height := 0
		end;
		Result := 0
	end
end;

procedure AssignPrn(var F: Text);
begin
	with TTextRec(F), PrnRec(UserData) do begin
//		Printer; 		commentata da Federico perchè la variabile Printer esiste sempre
		FillChar(F, SizeOf(F), 0);
		Mode := fmClosed;
		BufSize := SizeOf(Buffer);
		BufPtr := @Buffer;
		OpenFunc := @PrnOpen
	end
end;

// TPrinterDevice ==============================================================

type
	TPrinterDevice = class
		Driver, Device, Port: String;
		constructor Create(ADriver, ADevice, APort: PChar);
		function IsEqual(ADriver, ADevice, APort: PChar): Boolean;
	end;

constructor TPrinterDevice.Create(ADriver, ADevice, APort: PChar);
begin
	inherited Create;
	Driver := ADriver;
	Device := ADevice;
	Port := APort
end;

function TPrinterDevice.IsEqual(ADriver, ADevice, APort : PChar): Boolean;
begin
	Result := (Device = ADevice) and ((Port = '') or (Port = APort))
end;

// TPrinterCanvas ==============================================================

type
	TPrinterCanvas = class(TCanvas)
		Printer: TPrinter;
		constructor Create(APrinter: TPrinter);
		procedure CreateHandle; override;
		procedure Changing; override;
		procedure UpdateFont;
	end;

constructor TPrinterCanvas.Create(APrinter: TPrinter);
begin
	inherited Create;
	Printer := APrinter
end;

procedure TPrinterCanvas.CreateHandle;
begin
	Printer.SetState(psHandleIC);
	UpdateFont;
	Handle:= Printer.DC
end;

procedure TPrinterCanvas.Changing;
begin
	Printer.CheckPrinting(True);
	inherited Changing;
	UpdateFont
end;

procedure TPrinterCanvas.UpdateFont;
var FontSize: Integer;
begin
	if (GetDeviceCaps(Printer.DC, LOGPIXELSY) <> Font.PixelsPerInch) then begin
		FontSize := Font.Size;
		Font.PixelsPerInch := GetDeviceCaps(Printer.DC, LOGPIXELSY);
		Font.Size := FontSize
	end
end;

// TPrinter ====================================================================

constructor TPrinter.Create;
begin
	inherited Create;
	FPrinterIndex := -1
end;

destructor TPrinter.Destroy;
begin
	if (Printing) then EndDoc;
	SetState(psNoHandle);
	FreePrinters;
	FreeFonts;
	FCanvas.Free;
	if (FPrinterHandle <> 0) then ClosePrinter(FPrinterHandle);
	reset_devicemode;
	inherited Destroy
end;

procedure TPrinter.reset_devicemode;
begin
	if (DeviceMode <> 0) then begin
		GlobalUnlock(DeviceMode);
		GlobalFree(DeviceMode);
		DeviceMode := 0
	end;
	devmode := NIL;
	i_pixel_per_inch_print_x := 0;i_pixel_per_inch_print_y := 0;
	i_phisical_10mm_height := 0;i_phisical_10mm_width := 0
end;

procedure TPrinter.SetState(Value : TPrinterState);
type TCreateHandleFunc = function(DriverName, DeviceName, Output: PChar; InitData: PDeviceMode): HDC stdcall;
var CreateHandleFunc: TCreateHandleFunc;
begin
	if (Value = State) then exit;
	CreateHandleFunc := NIL;
	case Value of
		psNoHandle: begin
			CheckPrinting(False);
			if Assigned(FCanvas) then FCanvas.Handle := 0;
			try DeleteDC(DC) except end;	// a volte fallisce, se la stampante non è presente (esempio: inaccessibile, spenta)
			DC := 0
		end;
		psHandleIC: begin
			if (State <> psHandleDC) then CreateHandleFunc := CreateIC
			else Exit
		end;
		psHandleDC: begin
			if (FCanvas <> NIL) then FCanvas.Handle := 0;
			if (DC <> 0) then begin DeleteDC(DC);DC := 0 end;
			CreateHandleFunc := CreateDC
		end
	end;
	if Assigned(CreateHandleFunc) then
		with TPrinterDevice(Printers.Objects[PrinterIndex]) do begin
			DC := CreateHandleFunc(PChar(Driver), PChar(Device), PChar(Port), DevMode);
			if (DC = 0) then RaiseError(SInvalidPrinter);
//DeleteDC(DC);			
			if (FCanvas <> NIL) then FCanvas.Handle := DC
		end;
	State := Value
end;

procedure TPrinter.CheckPrinting(Value : Boolean);
begin
	if (Printing <> Value) then
		if (Value) then RaiseError(SNotPrinting)
		else RaiseError(SPrinting)
end;

procedure TPrinter.Abort;
begin
	CheckPrinting(True);
	AbortDoc(Canvas.Handle);
	FAborted := True;
	EndDoc
end;

procedure TPrinter.BeginDoc;
var DocInfo: TDocInfo;
begin
	CheckPrinting(False);
	SetState(psHandleDC);
	Canvas.Refresh;
	TPrinterCanvas(Canvas).UpdateFont;
	FPrinting := True;FAborted := False;
	FPageNumber := 1;
	FillChar(DocInfo, SizeOf(DocInfo), 0);
	with DocInfo do begin
		cbSize := SizeOf(DocInfo);
		lpszDocName := PChar(Title)
	end;
	SetAbortProc(DC, AbortProc);
	StartDoc(DC, DocInfo);
	StartPage(DC)
end;

procedure TPrinter.EndDoc;
begin
	CheckPrinting(True);
	EndPage(DC);
	if NOT Aborted then Windows.EndDoc(DC);
	FPrinting := False;FAborted := False;
	FPageNumber := 0
end;

procedure TPrinter.NewPage;
begin
	CheckPrinting(True);
	EndPage(DC);
	StartPage(DC);
	Inc(FPageNumber);
	Canvas.Refresh
end;

procedure TPrinter.GetPrinter(ADevice, ADriver, APort: PChar; var ADeviceMode: THandle);
begin
	with TPrinterDevice(Printers.Objects[PrinterIndex]) do begin
		StrCopy(ADevice, PChar(Device));
		StrCopy(ADriver, PChar(Driver));
		StrCopy(APort, PChar(Port))
	end;
	ADeviceMode := DeviceMode
end;

procedure TPrinter.SetPrinterCapabilities(DevMode : PDeviceMode);
begin
	if (DevMode.dmFields AND DM_YRESOLUTION <> 0) OR (Devmode.dmPrintQuality > 0) then begin
		i_pixel_per_inch_print_x := Devmode.dmPrintQuality;
		i_pixel_per_inch_print_y := Devmode.dmYResolution;
		if (i_pixel_per_inch_print_x <> i_pixel_per_inch_print_y) then begin
			{ in certi casi, INSPIEGABILMENTE, inverte i due valori e sballa tutta la stampa;
			  succede ad esempio sulla Konika Minolta PagePro 1300 settando la risoluzione a 1200*600;
			  in questi ALLUCINANTI CASI lascio che a fare il lavoro sia la GetDeviceCaps(Handle, LOGPIXELSX/Y) }
			i_pixel_per_inch_print_x := 0;i_pixel_per_inch_print_y := 0
		end
	end;                        

	// provo a leggere la dimensione della pagina in funzione del tipo di foglio
	get_paper_size(DevMode, i_phisical_10mm_width, i_phisical_10mm_height);
	// provo sempre e comunque a leggere la dimensione esplicita
//	if (DevMode.dmFields AND DM_PAPERLENGTH <> 0) then i_phisical_10mm_height := devmode.dmPaperLength;
//	if {(i_phisical_10mm_height = 0) AND} (devmode.dmPaperLength <> 0) then begin
	if (i_phisical_10mm_height = 0) AND (devmode.dmPaperLength <> 0) then begin
		i_phisical_10mm_height := devmode.dmPaperLength;
		{$ifdef RD} runtime_debug('paperLenght = ' + inttostr(i_phisical_10mm_height) + ' mm','SetPrinterCapabilities()',FALSE) {$endif}
	end;
//	if (DevMode.dmFields AND DM_PAPERWIDTH <> 0) then i_phisical_10mm_width := devmode.dmPaperWidth;
//	if {(i_phisical_10mm_width = 0) AND} (devmode.dmPaperWidth <> 0) then begin
	if (i_phisical_10mm_width = 0) AND (devmode.dmPaperWidth <> 0) then begin
		i_phisical_10mm_width := devmode.dmPaperWidth;
		{$ifdef RD} runtime_debug('paperWidth = ' + inttostr(i_phisical_10mm_width) + ' mm','SetPrinterCapabilities()',FALSE) {$endif}
	end;

	FCapabilities := [];
	if (DevMode.dmFields and DM_ORIENTATION) <> 0 then Include(FCapabilities, pcOrientation);
	if (DevMode.dmFields and DM_COPIES) <> 0 then Include(FCapabilities, pcCopies);
	if (DevMode.dmFields and DM_COLLATE) <> 0 then Include(FCapabilities, pcCollation)
end;

procedure TPrinter.SetPrinter(str_printer_name : string;ADeviceMode: THandle);
// str_printer_name è il nome della stampante (ricavabile da printer.printers)
begin
	str_printer_name := get_devicename(str_printer_name);
	{$ifdef DEBUG} assert(str_printer_name <> '','SetPrinter(): device not found KKDW 2838'); {$endif}
	if (str_printer_name <> '') then SetPrinter(LPSTR(str_printer_name),'','',ADeviceMode)
end; 

procedure TPrinter.SetPrinter(ADevice, ADriver, APort: PChar; ADeviceMode: THandle);
// ADevice è il nome del device, non della stampante!!!!
var
	i,j : smallint;
	StubDevMode: TDeviceMode;
begin
	CheckPrinting(False);
	str_setprinted_device := adevice;
	if (ADeviceMode <> DeviceMode) then begin  // free the devmode block we have, and take the one we're given
		if (DeviceMode <> 0) then reset_devicemode;
		DeviceMode := ADeviceMode
	end;
	if (DeviceMode <> 0) then begin
		DevMode := GlobalLock(DeviceMode);
		SetPrinterCapabilities(DevMode)
	end;
	FreeFonts;
	if (FPrinterHandle <> 0) then begin
		ClosePrinter(FPrinterHandle);
		FPrinterHandle := 0
	end;
	SetState(psNoHandle);
	j := -1;
	with Printers do begin  // <- this rebuilds the FPrinters list
		for i := 0 to Count - 1 do begin
			if TPrinterDevice(Objects[i]).IsEqual(ADriver, ADevice, APort) then begin
				TPrinterDevice(Objects[i]).Port := APort;
				j := i;
				Break
			end
		end
	end;
	if (j = -1) then begin
		j := FPrinters.Count;
		FPrinters.AddObject(Format(SDeviceOnPort, [ADevice, APort]), TPrinterDevice.Create(ADriver, ADevice, APort))
	end;

	FPrinterIndex := j;
	if OpenPrinter(ADevice, FPrinterHandle, NIL) then begin
		if (DeviceMode = 0) then begin		// alloc new device mode block if one was not passed in
			DeviceMode := GlobalAlloc(GHND,DocumentProperties(0, FPrinterHandle, ADevice, StubDevMode,StubDevMode, 0));
			if (DeviceMode <> 0) then begin
				DevMode := GlobalLock(DeviceMode);
				if (DocumentProperties(0, FPrinterHandle, ADevice, DevMode^, DevMode^, DM_OUT_BUFFER) < 0)
					then reset_devicemode
			end;
		end
		// start federico
		else begin
			if (DocumentProperties(0, FPrinterHandle, ADevice, DevMode^, DevMode^, DM_MODIFY OR DM_OUT_BUFFER) < 0)
				then reset_devicemode	// se la chiamata fallisce
		end;
		// end federico
		if (DeviceMode <> 0) then SetPrinterCapabilities(DevMode)
	end
end;

function TPrinter.GetCanvas: TCanvas;
begin
	if (FCanvas = NIL) then FCanvas := TPrinterCanvas.Create(Self);
	Result := FCanvas
end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
begin
	TStrings(Data).Add(LogFont.lfFaceName);
	Result := 1
end;

function TPrinter.GetFonts: TStrings;
begin
	if FFonts = NIL then begin
		try
			SetState(psHandleIC);
			FFonts := TStringList.Create;
			EnumFonts(DC, NIL, @EnumFontsProc, Pointer(FFonts))
		except
			FreeAndNil(FFonts);
			raise
		end
	end;
	Result := FFonts
end;

function TPrinter.GetHandle: HDC;
begin
	SetState(psHandleIC);
	Result := DC
end;

function TPrinter.GetNumCopies: Integer;
begin
	GetPrinterIndex;
	if (DeviceMode = 0) then RaiseError(SInvalidPrinterOp);
	Result := DevMode.dmCopies
end;

procedure TPrinter.SetNumCopies(Value : Integer);
begin
	CheckPrinting(False);
	GetPrinterIndex;
	if (DeviceMode = 0) then RaiseError(SInvalidPrinterOp);
	SetState(psNoHandle);
	DevMode.dmCopies := Value
end;

function TPrinter.GetOrientation : TPrinterOrientation;
begin
	GetPrinterIndex;
	if (DeviceMode = 0) then RaiseError(SInvalidPrinterOp);
	if (DevMode.dmOrientation = DMORIENT_PORTRAIT) then Result := poPortrait
	else Result := poLandscape
end;

procedure TPrinter.SetOrientation(Value : TPrinterOrientation);
const Orientations: array [TPrinterOrientation] of Integer = (DMORIENT_PORTRAIT, DMORIENT_LANDSCAPE);
begin
	CheckPrinting(False);
	GetPrinterIndex;
	if (DeviceMode = 0) then RaiseError(SInvalidPrinterOp);
	SetState(psNoHandle);
	DevMode.dmOrientation := Orientations[Value]
end;

function TPrinter.GetPageHeight : Integer;
begin
	SetState(psHandleIC);
	Result := GetDeviceCaps(DC, VertRes);
	{$ifdef RD} runtime_debug('GetPageHeight = ' + inttostr(result),'GetPageHeight',FALSE) {$endif}
end;

function TPrinter.GetPageWidth : Integer;
begin
	SetState(psHandleIC);
	Result := GetDeviceCaps(DC, HorzRes);
	{$ifdef RD} runtime_debug('GetPageWidth = ' + inttostr(result),'GetPageWidth',FALSE) {$endif}
end;

function TPrinter.GetPrinterIndex : Integer;
begin
	if (FPrinterIndex = -1) then SetToDefaultPrinter;
	Result := FPrinterIndex
end;

procedure TPrinter.SetPrinterIndex(Value : Integer);
var str_devicename : string;
begin
	CheckPrinting(False);
	if (Value = -1) or (PrinterIndex = -1) then SetToDefaultPrinter
	else if (Value < 0) or (Value >= Printers.Count) then RaiseError(SPrinterIndexError);
	FPrinterIndex := Value;
//	if (value <> -1) then SetPrinter(LPSTR(printers[value]),'','',0);	// by Federico
	if (value <> -1) then begin	// by federico
		str_devicename := get_devicename(printers[value]);
		if (str_devicename <> str_setprinted_device)
			then SetPrinter(LPSTR(str_devicename),'','',0)
	end;
	FreeFonts;
	SetState(psNoHandle)
end;

function TPrinter.GetPrinters: TStrings;
var
	LineCur, Port : PChar;
	Buffer, PrinterInfo : PChar;
	Flags, Count, NumInfo : DWORD;
	I : Integer;
	Level : Byte;
begin
	if (FPrinters = NIL) then begin
		FPrinters := TStringList.Create;
		Result := FPrinters;
		try
			if (Win32Platform = VER_PLATFORM_WIN32_NT) then begin
				Flags := (PRINTER_ENUM_CONNECTIONS OR PRINTER_ENUM_LOCAL);
				Level := 4
			end
			else begin
				Flags := PRINTER_ENUM_LOCAL;
				Level := 5
			end;
			Count := 0;
			EnumPrinters(Flags, NIL, Level, NIL, 0, Count, NumInfo);
			if Count = 0 then Exit;
			GetMem(Buffer, Count);
			try
				if NOT EnumPrinters(Flags, NIL, Level, PByte(Buffer), Count, Count, NumInfo) then Exit;
				PrinterInfo := Buffer;
				for i := 0 to NumInfo - 1 do begin
					if (Level = 4) then begin
						with PPrinterInfo4(PrinterInfo)^ do begin
							FPrinters.AddObject(pPrinterName,TPrinterDevice.Create(NIL, pPrinterName, NIL));
							Inc(PrinterInfo, sizeof(TPrinterInfo4))
						end
					end
					else begin
						with PPrinterInfo5(PrinterInfo)^ do begin
							LineCur := pPortName;
							Port := FetchStr(LineCur);
							while (Port^ <> #0) do begin
								FPrinters.AddObject(Format(SDeviceOnPort, [pPrinterName, Port]),
								TPrinterDevice.Create(NIL, pPrinterName, Port));
								Port := FetchStr(LineCur)
							end;
							Inc(PrinterInfo, sizeof(TPrinterInfo5))
						end
					end
				end
			finally
				FreeMem(Buffer, Count)
			end
		except
			FPrinters.Free;
			FPrinters := NIL;
			raise
		end
	end;
	Result := FPrinters
end;

procedure TPrinter.SetToDefaultPrinter;
var
	i : Integer;
	ByteCnt, StructCnt : DWORD;
	DefaultPrinter : array[0..1023] of char;
	Cur, Device : PChar;
	PrinterInfo : PPrinterInfo5;
begin
	ByteCnt := 0;StructCnt := 0;
	if NOT EnumPrinters(PRINTER_ENUM_DEFAULT, NIL, 5, NIL, 0, ByteCnt,
		StructCnt) AND (GetLastError <> ERROR_INSUFFICIENT_BUFFER)
	then begin
		// With no printers installed, Win95/98 fails above with "Invalid filename".
		// NT succeeds and returns a StructCnt of zero.
		if (GetLastError = ERROR_INVALID_NAME) then RaiseError(SNoDefaultPrinter)
		else RaiseLastOSError
	end;
	PrinterInfo := AllocMem(ByteCnt);
	try
		EnumPrinters(PRINTER_ENUM_DEFAULT, NIL, 5, PrinterInfo, ByteCnt, ByteCnt, StructCnt);
		if (StructCnt > 0) then Device := PrinterInfo.pPrinterName
		else begin
			GetProfileString('windows', 'device', '', DefaultPrinter, SizeOf(DefaultPrinter) - 1);
			Cur := DefaultPrinter;
			Device := FetchStr(Cur)
		end;
		with Printers do begin
			for i := 0 to Count-1 do begin
				if AnsiSameText(TPrinterDevice(Objects[i]).Device, Device) then begin
					with TPrinterDevice(Objects[i]) do SetPrinter(PChar(Device), PChar(Driver), PChar(Port), 0);
					Exit
				end
			end
		end
	finally
		FreeMem(PrinterInfo)
	end;
	RaiseError(SNoDefaultPrinter)
end;

procedure TPrinter.FreePrinters;
var i : smallint;
begin
	if (FPrinters <> NIL) then begin
		for I := 0 to FPrinters.Count - 1 do FPrinters.Objects[I].Free;
		FreeAndNil(FPrinters)
	end
end;

procedure TPrinter.FreeFonts;
begin
	FreeAndNil(FFonts)
end;

{function Printer: TPrinter;
begin
	if FPrinter = NIL then FPrinter := TPrinter.Create;
	Result := FPrinter
end; }

{function SetPrinter(NewPrinter: TPrinter): TPrinter;
begin
	Result := Printer;
	Printer := NewPrinter
end; }

procedure TPrinter.Refresh;
begin
	FreeFonts;
	FreePrinters
end;

function TPrinter.document_properties(father : TForm) : boolean;
// apre la pagina di impostazioni avanzate per la stampante; rende TRUE se sono state effettuate impostazioni, FALSE altrimenti
var
	StubDevMode: TDeviceMode;
	lo_result : integer;
	wh : hwnd;
begin
	result := FALSE;
	try
		if (DeviceMode = 0) then begin		// alloc new device mode block if one was not passed in
			DeviceMode := GlobalAlloc(GHND,DocumentProperties(0, FPrinterHandle, LPSTR(str_setprinted_device),
				StubDevMode,StubDevMode, 0));
			if (DeviceMode <> 0) then	begin
				DevMode := GlobalLock(DeviceMode);
				if (DocumentProperties(0, FPrinterHandle, LPSTR(str_setprinted_device), DevMode^,	DevMode^, DM_OUT_BUFFER) < 0)
				then begin
					reset_devicemode;
					abort
				end
			end
		end;

		if (father = NIL) then wh := 0 else wh := father.handle;
		lo_result := DocumentProperties(wh, FPrinterHandle, LPSTR(str_setprinted_device), DevMode^, DevMode^,
			DM_IN_BUFFER OR DM_PROMPT OR DM_OUT_BUFFER);
		if (lo_result < 0) then begin	// se la chiamata fallisce
			reset_devicemode;
			abort
		end;
		result := (lo_result = IDOK);
		if (result) then SetState(psNoHandle)	// faccio ricreare l'handle, quando necessario
	except
		error_msg(0,'Impossibile aprire la pagina delle impostazioni avanzate',str_setprinted_device)
	end
end;

function TPrinter.get_devicename(str_printer_name: string): string;
{ rende il nome del device associato alla stampante specificata; serve per effettuare le chiamata a SetPrinter()
  STR_PRINTER_NAME può essere ricavato da PRINTER.PRINTERS;
  STR_PRINTER_NAME può essere, ad esempio: "HP Laserjet III on LPT1"
  il device corrispondente tipicamente è : "HP Laserjet III" }
var i : smallint;
begin
	i := printers.indexof(str_printer_name);
	if (i = -1) then result := ''
	else result := TPrinterDevice(printers.Objects[I]).Device
end;

function TPrinter.GetPageHeight_10mm : integer;
begin
	if (i_phisical_10mm_height = 0) then
		i_phisical_10mm_height := round(GetDeviceCaps(Handle,PHYSICALHEIGHT) / GetResY * CM_PER_INCH * 100);
	result := i_phisical_10mm_height
end;

function TPrinter.GetPageWidth_10mm : integer;
begin
	if (i_phisical_10mm_width = 0) then
		i_phisical_10mm_width := round(GetDeviceCaps(Handle,PHYSICALWIDTH) / GetResX * CM_PER_INCH * 100);
	result := i_phisical_10mm_width
end;

function TPrinter.GetResX : integer;		// risoluzione orizzontale, in pixels per pollice
begin
	if (i_pixel_per_inch_print_x = 0) then
		i_pixel_per_inch_print_x := GetDeviceCaps(Handle, LOGPIXELSX);
	result := i_pixel_per_inch_print_x
end;

function TPrinter.GetResY : integer;		// risoluzione verticale, in pixels per pollice
begin
	if (i_pixel_per_inch_print_y = 0) then
		i_pixel_per_inch_print_y := GetDeviceCaps(Handle, LOGPIXELSY);
	result := i_pixel_per_inch_print_y
end;

{$I print_functions}

initialization
	Printer := TPrinter.Create
finalization
//	{$ifdef DEBUG} *** {$endif}
//	Printer.Free;
	printer := NIL
end.
