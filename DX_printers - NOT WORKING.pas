unit DX_Printers;	// unit VCL.PRINTERS.PAS rivista da Federico, 2019-09-08 ver $0400
//unit D6_printers;	// unit PRINTERS.PAS rivista da Federico, 2004-07, versione $0234 (2.52)
//unit Vcl.Printers;

{*******************************************************}
{                                                       }
{            Delphi Visual Component Library            }
{                                                       }
{ Copyright(c) 1995-2018 Embarcadero Technologies, Inc. }
{              All rights reserved                      }
{                                                       }
{*******************************************************}

{$HPPEMIT LEGACYHPP}
{$R-,T-,X+,H+}

interface

uses Winapi.Windows, Winapi.WinSpool, System.UITypes, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms, Vcl.Consts,
	gdich;

(*$HPPEMIT '#if defined(_VCL_ALIAS_RECORDS)' *)
(*$HPPEMIT '#if !defined(UNICODE)' *)
(*$HPPEMIT '#pragma alias "@Vcl@Printers@TPrinter@GetPrinterA$qqrpbt1t1rui"="@Vcl@Printers@TPrinter@GetPrinter$qqrpbt1t1rui"' *)
(*$HPPEMIT '#pragma alias "@Vcl@Printers@TPrinter@SetPrinterA$qqrpbt1t1ui"="@Vcl@Printers@TPrinter@SetPrinter$qqrpbt1t1ui"' *)
(*$HPPEMIT '#else' *)
(*$HPPEMIT '#pragma alias "@Vcl@Printers@TPrinter@GetPrinterW$qqrpbt1t1rui"="@Vcl@Printers@TPrinter@GetPrinter$qqrpbt1t1rui"' *)
(*$HPPEMIT '#pragma alias "@Vcl@Printers@TPrinter@SetPrinterW$qqrpbt1t1ui"="@Vcl@Printers@TPrinter@SetPrinter$qqrpbt1t1ui"' *)
(*$HPPEMIT '#endif' *)
(*$HPPEMIT '#endif' *)

{W1074}	{$WARN UNKNOWN_CUSTOM_ATTRIBUTE OFF}		// by Federico <<<<<<<<<<<<<<<<<<<<<<
{W1025}	{$WARN UNSUPPORTED_CONSTRUCT OFF}			// by Federico <<<<<<<<<<<<<<<<<<<<<<
{$if NOT defined(GALATEO) OR NOT defined(DLL)} *** da chiamare SOLO via CASA.DLL {$endif}

procedure init_printer;
function get_default_printer_index : smallint;		// rende la stampante predefinita (quella default di sistema)

function get_paper_size(devmode : PDeviceMode;var i_phisical_10mm_width, i_phisical_10mm_height : integer) : boolean;
function	cm2inches(r : real) : real;
function	inches2cm(r : real) : real;

var
	bo_nessuna_stampante_installata : boolean;	// TRUE se non ci sono stampanti nel sistema

const
  poPortrait = System.UITypes.TPrinterOrientation.poPortrait;
  poLandscape = System.UITypes.TPrinterOrientation.poLandScape;
  pcCopies = System.UITypes.TPrinterCapability.pcCopies;
  pcOrientation = System.UITypes.TPrinterCapability.pcOrientation;
  pcCollation = System.UITypes.TPrinterCapability.pcCollation;

type
  EPrinter = class(Exception);

  { TPrinter }

  { The printer object encapsulates the printer interface of Windows.  A print
    job is started whenever any redering is done either through a Text variable
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

  TPrinterState = System.UITypes .TPrinterState;		// psNoHandle, psHandleIC, psHandleDC
  {$NODEFINE TPrinterState}
  TPrinterOrientation = System.UITypes.TPrinterOrientation;
  {$NODEFINE TPrinterOrientation}
  TPrinterCapability = System.UITypes.TPrinterCapability;
  {$NODEFINE TPrinterCapability}
  TPrinterCapabilities = System.UITypes.TPrinterCapabilities;
  {$NODEFINE TPrinterCapabilities}

  {$HPPEMIT OPENNAMESPACE}
  {$HPPEMIT 'using System::Uitypes::TPrinterState;'}
  {$HPPEMIT 'using System::Uitypes::TPrinterOrientation;'}
  {$HPPEMIT 'using System::Uitypes::TPrinterCapability;'}
  {$HPPEMIT 'using System::Uitypes::TPrinterCapabilities;'}
  {$HPPEMIT CLOSENAMESPACE}

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
	 FPrinterHandle: THandle;
	 FDevMode: PDeviceMode;
	 FDeviceMode: THandle;
	 procedure SetState(Value: TPrinterState);
	 function GetCanvas: TCanvas;
	 function GetNumCopies: Integer;
	 function GetFonts: TStrings;
	 function GetHandle: HDC;
	 function GetOrientation: TPrinterOrientation;
	 function GetPageHeight: Integer;
	 function GetPageWidth: Integer;
	 function GetPrinterIndex: Integer;
	 procedure SetPrinterCapabilities(Value: Integer);
	 procedure SetPrinterIndex(Value: Integer);
	 function GetPrinters: TStrings;
	 procedure SetNumCopies(Value: Integer);
	 procedure SetOrientation(Value: TPrinterOrientation);
	 procedure SetToDefaultPrinter;
	 procedure CheckPrinting(Value: Boolean);
	 procedure FreePrinters;
	 procedure FreeFonts;
  public
	 constructor Create;
	 destructor Destroy; override;
	 procedure Abort;
	 procedure BeginDoc;
	 procedure EndDoc;
	 procedure NewPage;
	 procedure Refresh;
	 procedure GetPrinter(ADevice, ADriver, APort: PChar; var ADeviceMode: THandle);
	 procedure SetPrinter(ADevice, ADriver, APort: PChar; ADeviceMode: THandle); overload;
	 property Aborted: Boolean read FAborted;
	 property Canvas: TCanvas read GetCanvas;
	 property Capabilities: TPrinterCapabilities read FCapabilities;
	 property Copies: Integer read GetNumCopies write SetNumCopies;
	 property Fonts: TStrings read GetFonts;
	 property Handle: HDC read GetHandle;
	 property Orientation: TPrinterOrientation read GetOrientation write SetOrientation;
	 property PageHeight: Integer read GetPageHeight;
	 property PageWidth: Integer read GetPageWidth;
	 property PageNumber: Integer read FPageNumber;
	 property PrinterIndex: Integer read GetPrinterIndex write SetPrinterIndex;
	 property Printing: Boolean read FPrinting;
	 property Printers: TStrings read GetPrinters;
	 property Title: string read FTitle write FTitle;
		// by federico *******************************************************************************************************************
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
		function document_properties(father : TForm) : boolean;
		function get_devicename(str_printer_name : string) : string;
		procedure SetPrinter(str_printer_name : string;ADeviceMode : THandle); overload;
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

function Printer: TPrinter;
function SetPrinter(NewPrinter: TPrinter): TPrinter;

{ AssignPrn - Assigns a Text variable to the currently selected printer.  Any
  Write or Writeln's going to that file variable will be written on the
  printer using the Canvas property's font.  A new page is automatically
  started if a CR is encountered on (or a Writeln is written to) the last
  line on the page.  Closing the text file will imply a call to the
  Printer.EndDoc method. Note: only one Text variable can be open on the
  printer at a time.  Opening a second will cause an exception.}

procedure AssignPrn(var F: Text); 

implementation

uses galateo_debug, FAssert, FErrMsg{, pages};

var
	FPrinter: TPrinter = NIL;
	i_default_printer_index : smallint;

function FetchStr(var Str: PChar): PChar;
var P: PChar;
begin
	Result := Str;
	if Str = nil then Exit;
	P := Str;
	while P^ = ' ' do Inc(P);
	Result := P;
	while (P^ <> #0) and (P^ <> ',') do Inc(P);
	if P^ = ',' then begin P^ := #0;Inc(P) end;
	Str := P
end;

procedure RaiseError(const Msg: string);
begin
	raise EPrinter.Create(Msg)
end;

function AbortProc(Prn: HDC; Error: Integer): Bool; stdcall;
begin
	Application.ProcessMessages;
	Result := not FPrinter.Aborted
end;

{ AssignPrn support }
type
	PrnRec = record
		case Integer of
			1: (
				Cur: TPoint;
				Finish: TPoint;         { End of the printable area }
				Height: Integer);       { Height of the current line }
			2: (Tmp: array[1..32] of AnsiChar);
	end;

procedure NewPage(var Prn: PrnRec);
begin
	with Prn do begin
		Cur.X := 0;Cur.Y := 0;
		FPrinter.NewPage
	end
end;

// Start a new line on the current page, if no more lines left start a new page.
procedure NewLine(var Prn: PrnRec);

	function CharHeight: Word;
	var Metrics: TTextMetric;
	begin
		GetTextMetrics(FPrinter.Canvas.Handle, Metrics);
		Result := Metrics.tmHeight
	end;

begin
	with Prn do begin
		Cur.X := 0;
		if Height = 0 then Inc(Cur.Y, CharHeight) else Inc(Cur.Y, Height);
		if Cur.Y > (Finish.Y - (Height * 2)) then NewPage(Prn);
		Height := 0
	end
end;

// Print a string to the printer without regard to special characters.  These should handled by the caller.
procedure PrnOutStr(var Prn: PrnRec; Text: PAnsiChar; Len: Integer);
var
  Extent: TSize;
  L: Integer;
begin
	with Prn, FPrinter.Canvas do begin
		while Len > 0 do begin
			L := Len;
			GetTextExtentPointA(Handle, Text, L, Extent);

			while (L > 0) and (Extent.cX + Cur.X > Finish.X) do begin
				L := CharPrevA(Text, Text+L) - Text;
				GetTextExtentPointA(Handle, Text, L, Extent)
			end;

			if Extent.cY > Height then Height := Extent.cY + 2;
			Winapi.Windows.TextOutA(Handle, Cur.X, Cur.Y, Text, L);
			Dec(Len, L);
			Inc(Text, L);
			if Len > 0 then NewLine(Prn) else Inc(Cur.X, Extent.cX)
		end
	end
end;

// Print a string to the printer handling special characters.
procedure PrnString(var Prn: PrnRec; Text: PAnsiChar; Len: Integer);
var
  L: Integer;
  TabWidth: Word;

  procedure Flush;
  begin
	 if L <> 0 then PrnOutStr(Prn, Text, L);
	 Inc(Text, L + 1);
	 Dec(Len, L + 1);
	 L := 0;
  end;

	function AvgCharWidth: Word;
	var Metrics: TTextMetric;
	begin
		GetTextMetrics(FPrinter.Canvas.Handle, Metrics);
		Result := Metrics.tmAveCharWidth
	end;

begin
  L := 0;
  with Prn do begin
	 while L < Len do begin
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

{ Called when a Read or Readln is applied to a printer file. Since reading is
  illegal this routine tells the I/O system that no characters where read, which
  generates a runtime error. }
function PrnInput(var F: TTextRec): Integer;
begin
	with F do begin BufPos := 0;BufEnd := 0 end;
	Result := 0
end;

{ Called when a Write or Writeln is applied to a printer file. The calls
  PrnString to write the text in the buffer to the printer. }
function PrnOutput(var F: TTextRec): Integer;
begin
	with F do begin
		PrnString(PrnRec(UserData), PAnsiChar(BufPtr), BufPos);
		BufPos := 0;Result := 0
	end
end;

// Will ignore certain requests by the I/O system such as flush while doing an input.
function PrnIgnore(var F: TTextRec): Integer;
begin
	Result := 0
end;

// Deallocates the resources allocated to the printer file.
function PrnClose(var F: TTextRec): Integer;
begin
	with PrnRec(F.UserData) do begin
		FPrinter.EndDoc;
		Result := 0
	end
end;

// Called to open I/O on a printer file.  Sets up the TTextFile to point to printer I/O functions.
function PrnOpen(var F: TTextRec): Integer;
//const Blank: array[0..0] of Char = '';
begin
	with F, PrnRec(UserData) do begin
		if Mode = fmInput then begin
			InOutFunc := @PrnInput;
			FlushFunc := @PrnIgnore;
			CloseFunc := @PrnIgnore
		end
		else begin
			Mode := fmOutput;
			InOutFunc := @PrnOutput;
			FlushFunc := @PrnOutput;
			CloseFunc := @PrnClose;
			FPrinter.BeginDoc;

			Cur.X := 0;Cur.Y := 0;
			Finish.X := FPrinter.PageWidth;
			Finish.Y := FPrinter.PageHeight;
			Height := 0
		end;
		Result := 0
	end
end;

procedure AssignPrn(var F: Text);
begin
	with TTextRec(F), PrnRec(UserData) do begin
		Printer;
		FillChar(F, SizeOf(F), 0);
		Mode := fmClosed;
		BufSize := SizeOf(Buffer);
		BufPtr := @Buffer;
		OpenFunc := @PrnOpen
	end
end;

{ TPrinterDevice }

type
	TPrinterDeviceStringType = PChar;
	TPrinterDevice = class
		private
			Driver, Device, Port: String;
			constructor Create(ADriver, ADevice, APort: TPrinterDeviceStringType);
			function IsEqual(ADriver, ADevice, APort: TPrinterDeviceStringType): Boolean;
	end;

constructor TPrinterDevice.Create(ADriver, ADevice, APort: TPrinterDeviceStringType);
begin
	inherited Create;
	Driver := ADriver;
	Device := ADevice;
	Port := APort
end;

function TPrinterDevice.IsEqual(ADriver, ADevice, APort: TPrinterDeviceStringType): Boolean;
begin
	Result := (Device = ADevice) and ((Port = '') or (Port = APort))
end;

{ TPrinterCanvas }

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
	Printer.SetState(TPrinterState.psHandleIC);
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
var
  FontSize: Integer;
begin
	if GetDeviceCaps(Printer.DC, LOGPIXELSY) <> Font.PixelsPerInch then begin
		FontSize := Font.Size;
		Font.PixelsPerInch := GetDeviceCaps(Printer.DC, LOGPIXELSY);
		Font.Size := FontSize
	end
end;

{ TPrinter }

constructor TPrinter.Create;
begin
  inherited Create;
  FPrinterIndex := -1;
end;

destructor TPrinter.Destroy;
begin
	if Printing then EndDoc;
	SetState(TPrinterState.psNoHandle);
	FreePrinters;
	FreeFonts;
	FCanvas.Free;
	if FPrinterHandle <> 0 then ClosePrinter(FPrinterHandle);
{	if FDeviceMode <> 0 then begin
		GlobalUnlock(FDeviceMode);
		GlobalFree(FDeviceMode);
		FDeviceMode := 0;
	end; }
	reset_devicemode;
	inherited Destroy
end;

procedure TPrinter.SetState(Value: TPrinterState);
type TCreateHandleFunc = function (DriverName, DeviceName, Output: PChar;InitData: PDeviceMode): HDC stdcall;
var
	CreateHandleFunc: TCreateHandleFunc;
	tpd : TPrinterDevice;
begin
	if (Value = State) then exit;
	CreateHandleFunc := NIL;
	case Value of
		TPrinterState.psNoHandle: begin
			CheckPrinting(FALSE);
			if Assigned(FCanvas) then FCanvas.Handle := 0;
			DeleteDC(DC);DC := 0
		end;
		TPrinterState.psHandleIC: if (State <> TPrinterState.psHandleDC) then CreateHandleFunc := CreateIC else Exit;
		TPrinterState.psHandleDC: begin
			if (FCanvas <> NIL) then FCanvas.Handle := 0;
			if (DC <> 0) then DeleteDC(DC);
			CreateHandleFunc := CreateDC
		end
	end;
	if Assigned(CreateHandleFunc) then begin
{			with TPrinterDevice(Printers.Objects[PrinterIndex]) do begin
			DC := CreateHandleFunc(PChar(Driver), PChar(Device), PChar(Port), FDevMode);
			if (DC = 0) then RaiseError(SInvalidPrinter);
			if (FCanvas <> NIL) then FCanvas.Handle := DC
		end }
		tpd := TPrinterDevice(Printers.Objects[PrinterIndex]);
		DC := CreateHandleFunc(PChar(tpd.Driver), PChar(tpd.Device), PChar(tpd.Port), FDevMode);
		if (DC = 0) then RaiseError(SInvalidPrinter);
		if (FCanvas <> NIL) then FCanvas.Handle := DC
	end;
	State := Value
end;

procedure TPrinter.CheckPrinting(Value: Boolean);
begin
	if (Printing <> Value) then
		if Value then RaiseError(SNotPrinting) else RaiseError(SPrinting)
end;

[PrintingPermission(SecurityAction.LinkDemand, Level=PrintingPermissionLevel.AllPrinting)]
procedure TPrinter.Abort;
begin
	CheckPrinting(True);
	AbortDoc(Canvas.Handle);
	FAborted := TRUE;
	EndDoc;
	FAborted := TRUE
end;

[PrintingPermission(SecurityAction.LinkDemand, Level=PrintingPermissionLevel.AllPrinting)]
procedure TPrinter.BeginDoc;
var DocInfo: TDocInfo;
begin
	CheckPrinting(False);
	SetState(TPrinterState.psHandleDC);
	Canvas.Refresh;
	TPrinterCanvas(Canvas).UpdateFont;
	FPrinting := True;
	FAborted := False;
	FPageNumber := 1;
	FillChar(DocInfo, SizeOf(DocInfo), 0);
	with DocInfo do begin
		cbSize := SizeOf(DocInfo);
		lpszDocName := PChar(Title)
	end;
	SetAbortProc(DC, AbortProc);
	if StartDoc(DC, DocInfo) <= 0 then FPrinting := FALSE else StartPage(DC)
end;

[PrintingPermission(SecurityAction.LinkDemand, Level=PrintingPermissionLevel.AllPrinting)]
procedure TPrinter.EndDoc;
begin
	CheckPrinting(True);
	EndPage(DC);
	if not Aborted then Winapi.Windows.EndDoc(DC);
	FPrinting := False;
	FAborted := False;
	FPageNumber := 0
end;

[PrintingPermission(SecurityAction.LinkDemand, Level=PrintingPermissionLevel.AllPrinting)]
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
	ADeviceMode := FDeviceMode
end;

procedure TPrinter.SetPrinterCapabilities(Value: Integer);
begin
	FCapabilities := [];
	if (Value and DM_ORIENTATION) <> 0 then Include(FCapabilities, pcOrientation);
	if (Value and DM_COPIES) <> 0 then Include(FCapabilities, pcCopies);
	if (Value and DM_COLLATE) <> 0 then Include(FCapabilities, pcCollation)
end;

{$define XXX}	{$ifndef DEBUG} *** {$endif}
{$ifdef XXX}
[PrintingPermission(SecurityAction.LinkDemand, Level=PrintingPermissionLevel.AllPrinting)]
procedure TPrinter.SetPrinter(ADevice, ADriver, APort: PChar; ADeviceMode: THandle);
const MBOX_RUNTIME_DEBUG_CAPTION = 'TPrinter.SetPrinter()';
var i, j, lo : integer;
begin
	writeln_system_debug(0, MBOX_RUNTIME_DEBUG_CAPTION);
	CheckPrinting(FALSE);
	str_setprinted_device := adevice;
	if (ADeviceMode <> FDeviceMode) then begin  // free the devmode block we have, and take the one we're given
//		if (FDeviceMode <> 0) then begin GlobalUnlock(FDeviceMode);GlobalFree(FDeviceMode);FDevMode := NIL end;
		if (FDeviceMode <> 0) then reset_devicemode;
		FDeviceMode := ADeviceMode
	end;
	if (FDeviceMode <> 0) then begin
		FDevMode := GlobalLock(FDeviceMode);
		SetPrinterCapabilities(FDevMode.dmFields)
	end;
	FreeFonts;
	if (FPrinterHandle <> 0) then begin
		ClosePrinter(FPrinterHandle);
		FPrinterHandle := 0
	end;
	SetState(TPrinterState.psNoHandle);
	j := -1;
	with Printers do begin		// <- this rebuilds the FPrinters list
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
		FPrinters.AddObject(Format(SDeviceOnPort, [ADevice, APort]),
		TPrinterDevice.Create(ADriver, ADevice, APort))
	end;
	writeln_system_debug(100, MBOX_RUNTIME_DEBUG_CAPTION);
	FPrinterIndex := j;
	if OpenPrinter(ADevice, FPrinterHandle, NIL) then begin
		writeln_system_debug(110, MBOX_RUNTIME_DEBUG_CAPTION);
		if (FDeviceMode = 0) then begin  // alloc new device mode block if one was not passed in
			writeln_system_debug(120, MBOX_RUNTIME_DEBUG_CAPTION);
//			FDeviceMode := GlobalAlloc(GHND, DocumentProperties(0, FPrinterHandle, ADevice, NIL, NIL, 0));
			lo := DocumentProperties({hWnd}0, {hPrinter}FPrinterHandle, {pDeviceName}ADevice, {pDevModeOutput}NIL, {pDevModeInput}NIL, {fMode}0);
			writeln_system_debug(121, MBOX_RUNTIME_DEBUG_CAPTION, 'DocumentProperties=' + lo.ToString);
			if (lo = -1) then lo := 10000;	// su Win7 dava una dimensione pari a 1689, 10k è cautelativo
			FDeviceMode := GlobalAlloc(GHND, lo);
			writeln_system_debug(130, MBOX_RUNTIME_DEBUG_CAPTION, 'FDeviceMode=' + FDeviceMode.ToString);
			if (FDeviceMode <> 0) then begin
				writeln_system_debug(140, MBOX_RUNTIME_DEBUG_CAPTION);
				FDevMode := GlobalLock(FDeviceMode);
				writeln_system_debug(150, MBOX_RUNTIME_DEBUG_CAPTION);
				lo := DocumentProperties({hWnd}0, {hPrinter}FPrinterHandle, {pDeviceName}ADevice, {pDevModeOutput}FDevMode, {pDevModeInput}NIL, {fMode}DM_OUT_BUFFER);
				if (lo < 0) then begin
//					GlobalUnlock(FDeviceMode);GlobalFree(FDeviceMode);FDeviceMode := 0;FDevMode := NIL
					writeln_system_debug(160, MBOX_RUNTIME_DEBUG_CAPTION, 'DocumentProperties=' + inttostr(lo));
					reset_devicemode
				end;
				writeln_system_debug(190, MBOX_RUNTIME_DEBUG_CAPTION)
			end;
			writeln_system_debug(199, MBOX_RUNTIME_DEBUG_CAPTION)
		end
		// start federico (pedissequamente copiato da D6)
		else begin
			writeln_system_debug(200, MBOX_RUNTIME_DEBUG_CAPTION);
			lo := DocumentProperties(0, FPrinterHandle, {pDeviceName}ADevice, {pDevModeOutput}FDevMode, {pDevModeInput}FDevMode, {fMode}DM_MODIFY OR DM_OUT_BUFFER);
			if (lo < 0) then begin
				writeln_system_debug(210, MBOX_RUNTIME_DEBUG_CAPTION, 'DocumentProperties=' + inttostr(lo));
				reset_devicemode	// se la chiamata fallisce
			end;
			writeln_system_debug(290, MBOX_RUNTIME_DEBUG_CAPTION)
		end;
		// end federico (pedissequamente copiato da D6)
		writeln_system_debug(300, MBOX_RUNTIME_DEBUG_CAPTION);
		if (FDeviceMode <> 0) then begin
			writeln_system_debug(310, MBOX_RUNTIME_DEBUG_CAPTION);
			SetPrinterCapabilities(FDevMode^.dmFields)
		end;
		writeln_system_debug(390, MBOX_RUNTIME_DEBUG_CAPTION)
	end;
	writeln_system_debug(999, MBOX_RUNTIME_DEBUG_CAPTION)
end;

{$else}

[PrintingPermission(SecurityAction.LinkDemand, Level=PrintingPermissionLevel.AllPrinting)]
procedure TPrinter.SetPrinter(ADevice, ADriver, APort: PChar; ADeviceMode: THandle);
var i, j, lo : integer;
begin
	CheckPrinting(FALSE);
	if (ADeviceMode <> FDeviceMode) then begin  // free the devmode block we have, and take the one we're given
		if (FDeviceMode <> 0) then begin
			GlobalUnlock(FDeviceMode);
			GlobalFree(FDeviceMode);
			FDevMode := NIL
		end;
		FDeviceMode := ADeviceMode
	end;
	if (FDeviceMode <> 0) then begin
		FDevMode := GlobalLock(FDeviceMode);
		SetPrinterCapabilities(FDevMode.dmFields)
	end;
	FreeFonts;
	if (FPrinterHandle <> 0) then begin
		ClosePrinter(FPrinterHandle);
		FPrinterHandle := 0
	end;
	SetState(TPrinterState.psNoHandle);
	J := -1;
	with Printers do begin		// <- this rebuilds the FPrinters list
		for I := 0 to Count - 1 do begin
			if TPrinterDevice(Objects[I]).IsEqual(ADriver, ADevice, APort) then begin
				TPrinterDevice(Objects[I]).Port := APort;
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
		if (FDeviceMode = 0) then begin		// alloc new device mode block if one was not passed in
			lo := DocumentProperties({hWnd}0, {hPrinter}FPrinterHandle, {pDeviceName}ADevice, {pDevModeOutput}NIL, {pDevModeInput}NIL, {fMode}0);
			FDeviceMode := GlobalAlloc(GHND, lo);
			if (FDeviceMode <> 0) then begin
				FDevMode := GlobalLock(FDeviceMode);
				if (DocumentProperties({hWnd}0, {hPrinter}FPrinterHandle, {pDeviceName}ADevice, {pDevModeOutput}FDevMode, {pDevModeInput}NIL, {fMode}DM_OUT_BUFFER) < 0) then begin
					GlobalUnlock(FDeviceMode);GlobalFree(FDeviceMode);
					FDeviceMode := 0;FDevMode := NIL
				end
			end
		end;
		if FDeviceMode <> 0 then SetPrinterCapabilities(FDevMode^.dmFields)
	end
end;

{$endif}

function TPrinter.GetCanvas: TCanvas;
begin
	if (FCanvas = NIL) then FCanvas := TPrinterCanvas.Create(Self);
	Result := FCanvas
end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;FontType: Integer; Data: Pointer): Integer; stdcall;
begin
	TStrings(Data).Add(LogFont.lfFaceName);
	Result := 1
end;

function TPrinter.GetFonts: TStrings;
begin
	if (FFonts = NIL) then
	try
		SetState(TPrinterState.psHandleIC);
		FFonts := TStringList.Create;
		EnumFonts(DC, nil, @EnumFontsProc, Pointer(FFonts))
	except
		FreeAndNil(FFonts);
		raise
	end;
	Result := FFonts
end;

function TPrinter.GetHandle: HDC;
begin
	SetState(TPrinterState.psHandleIC);
	Result := DC
end;

function TPrinter.GetNumCopies: Integer;
begin
	GetPrinterIndex;
	if FDeviceMode = 0 then RaiseError(SInvalidPrinterOp);
	Result := FDevMode.dmCopies
end;

procedure TPrinter.SetNumCopies(Value: Integer);
begin
	CheckPrinting(False);
	GetPrinterIndex;
	if (FDeviceMode = 0) then RaiseError(SInvalidPrinterOp);
	SetState(TPrinterState.psNoHandle);
	FDevMode^.dmCopies := Value
end;

function TPrinter.GetOrientation: TPrinterOrientation;
begin
	GetPrinterIndex;
	if FDeviceMode = 0 then RaiseError(SInvalidPrinterOp);
	if FDevMode.dmOrientation = DMORIENT_PORTRAIT then Result := poPortrait else Result := poLandscape
end;

procedure TPrinter.SetOrientation(Value: TPrinterOrientation);
const Orientations: array [TPrinterOrientation] of Integer = (DMORIENT_PORTRAIT, DMORIENT_LANDSCAPE);
begin
	CheckPrinting(False);
	GetPrinterIndex;
	if FDeviceMode = 0 then RaiseError(SInvalidPrinterOp);
	SetState(TPrinterState.psNoHandle);
	FDevMode^.dmOrientation := Orientations[Value]
end;

function TPrinter.GetPageHeight : integer;
begin
	SetState(TPrinterState.psHandleIC);
	Result := GetDeviceCaps(DC, VertRes)
end;

function TPrinter.GetPageWidth : integer;
begin
	SetState(TPrinterState.psHandleIC);
	Result := GetDeviceCaps(DC, HorzRes)
end;

function TPrinter.GetPrinterIndex : integer;
begin
	if (FPrinterIndex = -1) then SetToDefaultPrinter;
	Result := FPrinterIndex
end;

procedure TPrinter.SetPrinterIndex(Value : integer);
var
	lDevice, lDriver, lPort : Array[0..255] of Char;
	lDeviceMode : THandle;
begin
	CheckPrinting(FALSE);
	if (Value < -1) or (Value >= Printers.Count) then RaiseError(SPrinterIndexError);
	if (Value = -1) then SetToDefaultPrinter;
	if Value <> FPrinterIndex then begin
		if (Value <> -1) then FPrinterIndex := Value;
		with TPrinterDevice(Printers.Objects[FPrinterIndex]) do Printer.GetPrinter(lDevice, lDriver, lPort, lDeviceMode);
		GlobalUnlock(lDeviceMode);GlobalFree(lDeviceMode);lDeviceMode := 0;
		Printer.SetPrinter(lDevice, lDriver, lPort, lDeviceMode);
		FreeFonts;
		SetState(TPrinterState.psNoHandle)
	end
end;

function TPrinter.GetPrinters: TStrings;
var
	Flags, Count, NumInfo: DWORD;
	i : integer;
	Level: Byte;
	LineCur, Port: PChar;
	Buffer, PrinterInfo: PByte;
begin
	if (FPrinters = NIL) then begin
		FPrinters := TStringList.Create;
		Result := FPrinters;
		try
			if (Win32Platform = VER_PLATFORM_WIN32_NT) then begin Flags := PRINTER_ENUM_CONNECTIONS or PRINTER_ENUM_LOCAL;Level := 4 end
			else begin Flags := PRINTER_ENUM_LOCAL;Level := 5 end;
			Count := 0;
			EnumPrinters(Flags, NIL, Level, NIL, 0, Count, NumInfo);
			if (Count = 0) then Exit;
			GetMem(Buffer, Count);
			try
				if NOT EnumPrinters(Flags, nil, Level, PByte(Buffer), Count, Count, NumInfo) then Exit;
				PrinterInfo := Buffer;
				for i := 0 to NumInfo - 1 do begin
					if (Level = 4) then
						with PPrinterInfo4(PrinterInfo)^ do begin
							FPrinters.AddObject(pPrinterName,
							TPrinterDevice.Create(NIL, pPrinterName, NIL));
							Inc(PrinterInfo, sizeof(TPrinterInfo4))
						end
					else
						with PPrinterInfo5(PrinterInfo)^ do begin
							LineCur := pPortName;Port := FetchStr(LineCur);
							while Port^ <> #0 do begin
								FPrinters.AddObject(Format(SDeviceOnPort, [pPrinterName, Port]), TPrinterDevice.Create(nil, pPrinterName, Port));
								Port := FetchStr(LineCur)
							end;
							Inc(PrinterInfo, sizeof(TPrinterInfo5))
						end
				end
			finally
			  FreeMem(Buffer, Count)
			end
		except
			FPrinters.Free;FPrinters := NIL;
			raise
		end
	end;
	Result := FPrinters
end;

{$IF DEFINED(UNICODE) AND DEFINED(MSWINDOWS)}
function GetDefaultPrinter(DefaultPrinter: PChar; var I: Integer): BOOL; stdcall; external winspl name 'GetDefaultPrinterW';
{$ENDIF}

procedure TPrinter.SetToDefaultPrinter;
var
	i : integer;
	ByteCnt, StructCnt : DWORD;
	DefaultPrinter: array[0..1023] of Char;
	Cur, Device: PChar;
	PrinterInfo: PPrinterInfo5;
begin
	ByteCnt := 0;StructCnt := 0;
	if NOT EnumPrinters(PRINTER_ENUM_DEFAULT, nil, 5, nil, 0, ByteCnt, StructCnt) AND (GetLastError <> ERROR_INSUFFICIENT_BUFFER) then begin
		// With no printers installed, Win95/98 fails above with "Invalid filename".
		// NT succeeds and returns a StructCnt of zero.
		if (GetLastError = ERROR_INVALID_NAME) then RaiseError(SNoDefaultPrinter) else RaiseLastOSError
	end;
	PrinterInfo := AllocMem(ByteCnt);
	try
		EnumPrinters(PRINTER_ENUM_DEFAULT, nil, 5, PrinterInfo, ByteCnt, ByteCnt, StructCnt);
		if (StructCnt > 0) then Device := PrinterInfo.pPrinterName
		else begin
{$IF DEFINED(UNICODE)}
			I := Length(DefaultPrinter);
			if NOT GetDefaultPrinter(DefaultPrinter, I) then ZeroMemory(@DefaultPrinter[0], I * SizeOf(Char));
{$ELSE}
			GetProfileString('windows', 'device', '', DefaultPrinter, SizeOf(DefaultPrinter) - 1);
{$ENDIF}
			Cur := DefaultPrinter;Device := FetchStr(Cur)
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
var I: Integer;
begin
	if (FPrinters <> NIL) then begin
		for i := 0 to FPrinters.Count - 1 do FPrinters.Objects[i].Free;
		FreeAndNil(FPrinters)
	end
end;

procedure TPrinter.FreeFonts;
begin
	FreeAndNil(FFonts)
end;

function Printer: TPrinter;
begin
	if (FPrinter = NIL) then FPrinter := TPrinter.Create;
	Result := FPrinter
end;

[PrintingPermission(SecurityAction.LinkDemand, Level=PrintingPermissionLevel.AllPrinting)]
function SetPrinter(NewPrinter: TPrinter): TPrinter;
begin
	Result := FPrinter;
	FPrinter := NewPrinter
end;

procedure TPrinter.Refresh;
begin
	FreeFonts;
	FreePrinters
end;

// ******************** FEDERICO *******************************************************************************************************

function TPrinter.document_properties(father : TForm) : boolean;
// apre la pagina di impostazioni avanzate per la stampante; rende TRUE se sono state effettuate impostazioni, FALSE altrimenti
var
	StubDevMode: TDeviceMode;
	lo : integer;
	wstr_setprinted_device : WideString;
	handle : HWND;
begin
	result := FALSE;
	if (father = NIL) then handle := 0 else handle := father.Handle;
	wstr_setprinted_device := str_setprinted_device;
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
		error_msg(handle, 'Impossibile aprire la pagina delle impostazioni avanzate', str_setprinted_device)
	end
end;

function TPrinter.get_devicename(str_printer_name : string) : string;
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


//		i_pixel_per_inch_print_x := GetDeviceCaps(DC, LOGPIXELSX); *-*
//		i_pixel_per_inch_print_x := GetDeviceCaps(FPrinterHandle, LOGPIXELSX);


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

var bo_initialized : boolean = FALSE;

procedure init_printer;
begin
//	if (printer <> NIL) then exit;
//	fPrinter := TPrinter.Create;
	if bo_initialized then exit;
//		if (FPrinter = NIL) then FPrinter := TPrinter.Create;
	{$ifdef WIN32}
		i_default_printer_index := printer.PrinterIndex;
	{$endif}
	{$ifdef WIN64}
//		bo_initialized := TRUE;exit;	{$ifndef DEBUG} *** {$endif}
		i_default_printer_index := printer.PrinterIndex;
	{$endif}
	bo_initialized := TRUE
end;

function get_default_printer_index : smallint;
// rende la stampante predefinita (quella default di sistema)
begin
	result := i_default_printer_index
end;

procedure TPrinter.reset_devicemode;
begin
	if (fDeviceMode <> 0) then begin
		GlobalUnlock(fDeviceMode);
		GlobalFree(fDeviceMode);
		fDeviceMode := 0
	end;
	fdevmode := NIL;
	i_pixel_per_inch_print_x := 0;i_pixel_per_inch_print_y := 0;
	i_phisical_10mm_height := 0;i_phisical_10mm_width := 0
end;

procedure TPrinter.SetPrinter(str_printer_name : string;ADeviceMode : THandle);
// str_printer_name è il nome della stampante (ricavabile da printer.printers)
begin
	str_printer_name := get_devicename(str_printer_name);
//	{$ifdef DEBUG} assert(str_printer_name <> '','SetPrinter(): device not found KKDW 2838'); {$endif}
//	if (str_printer_name <> '') then SetPrinter(LPSTR(str_printer_name), '', '', ADeviceMode)
	if (str_printer_name <> '') then SetPrinter(PChar(str_printer_name), '', '', ADeviceMode)
end;

{$I print_functions}

initialization
	galateo_initialization_debug('DX_printers');
	init_printer
finalization
	galateo_finalization_debug('DX_printers');
  FPrinter.Free;
end.
