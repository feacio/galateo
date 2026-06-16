{*******************************************************}
{                                                       }
{            Delphi Visual Component Library            }
{                                                       }
{ Copyright(c) 1995-2018 Embarcadero Technologies, Inc. }
{              All rights reserved                      }
{                                                       }
{*******************************************************}

unit Printers_VCL;	// copia della VCL.PRINTERS, con lievi modifiche per la sua derivazione in PRINTERS_DX

{$HPPEMIT LEGACYHPP}
{$R-,T-,X+,H+}
{$ifdef DEBUG} {$L+,D+} {$endif DEBUG}	// Federico

interface

uses
{$IF DEFINED(CLR)}
  WinUtils, System.Runtime.InteropServices,
{$ENDIF}
{$IF DEFINED(LINUX)}
  WinUtils,
{$ENDIF}
  Winapi.Windows, Winapi.WinSpool, System.UITypes, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms;

(*$HPPEMIT '#if defined(_VCL_ALIAS_RECORDS)' *)
(*$HPPEMIT '#if !defined(UNICODE)' *)
(*$HPPEMIT '#pragma alias "@Vcl@Printers@TPrinter@GetPrinterA$qqrpbt1t1rui"="@Vcl@Printers@TPrinter@GetPrinter$qqrpbt1t1rui"' *)
(*$HPPEMIT '#pragma alias "@Vcl@Printers@TPrinter@SetPrinterA$qqrpbt1t1ui"="@Vcl@Printers@TPrinter@SetPrinter$qqrpbt1t1ui"' *)
(*$HPPEMIT '#else' *)
(*$HPPEMIT '#pragma alias "@Vcl@Printers@TPrinter@GetPrinterW$qqrpbt1t1rui"="@Vcl@Printers@TPrinter@GetPrinter$qqrpbt1t1rui"' *)
(*$HPPEMIT '#pragma alias "@Vcl@Printers@TPrinter@SetPrinterW$qqrpbt1t1ui"="@Vcl@Printers@TPrinter@SetPrinter$qqrpbt1t1ui"' *)
(*$HPPEMIT '#endif' *)
(*$HPPEMIT '#endif' *)

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

  TPrinterState = System.UITypes.TPrinterState;
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

	TPrinterDeviceStringType = PChar;

	TPrinterDevice = class
		public
			Driver, Device, Port: String;
			constructor Create(ADriver, ADevice, APort : TPrinterDeviceStringType);
			function IsEqual(ADriver, ADevice, APort : TPrinterDeviceStringType) : Boolean;
	end;

	TPrinter = class(TObject)
		protected	// PUBLICcizzati by Federico
			FDeviceMode: THandle;
			FPrinterHandle: THandle;
			FDevMode: PDeviceMode;
			procedure SetState(Value: TPrinterState);
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
			str_setprinted_device : string;		// by Federico *****************************
			constructor Create;
			destructor Destroy; override;
			procedure Abort;
			procedure BeginDoc;
			procedure EndDoc;
			procedure NewPage;
			procedure Refresh;
			procedure GetPrinter(ADevice, ADriver, APort: PChar; var ADeviceMode: THandle);
			procedure SetPrinter(ADevice, ADriver, APort: PChar; ADeviceMode: THandle);
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
//function SetPrinter(NewPrinter: TPrinter): TPrinter;

{ AssignPrn - Assigns a Text variable to the currently selected printer.  Any
  Write or Writeln's going to that file variable will be written on the
  printer using the Canvas property's font.  A new page is automatically
  started if a CR is encountered on (or a Writeln is written to) the last
  line on the page.  Closing the text file will imply a call to the
  Printer.EndDoc method. Note: only one Text variable can be open on the
  printer at a time.  Opening a second will cause an exception.}

procedure AssignPrn(var F: Text);

var static_FPrinter : TPrinter = NIL;

implementation

uses {$ifdef DEBUG} galateo_debug, {$endif DEBUG} Vcl.Consts;

function FetchStr(var Str: PChar): PChar;
var P: PChar;
begin
	Result := Str;
	if (Str = NIL) then Exit;
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

function AbortProc(Prn: HDC; Error: Integer): Bool; {$IFNDEF CLR}stdcall;{$ENDIF}
begin
	Application.ProcessMessages;
	Result := not static_FPrinter.Aborted
end;

{ AssignPrn support }
type
  PrnRec = record
	 case Integer of
		1: (
		  Cur: TPoint;
		  Finish: TPoint;         { End of the printable area }
		  Height: Integer);       { Height of the current line }
		2: (
		  Tmp: array[1..32] of AnsiChar);
  end;

procedure NewPage(var Prn: PrnRec);
begin
	with Prn do begin
		Cur.X := 0;Cur.Y := 0;
		static_FPrinter.NewPage
	end
end;

// Start a new line on the current page, if no more lines left start a new page.
procedure NewLine(var Prn: PrnRec);

	function CharHeight: Word;
	var Metrics: TTextMetric;
	begin
		GetTextMetrics(static_FPrinter.Canvas.Handle, Metrics);
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

// Print a string to the printer without regard to special characters.  These should handled by the caller.
procedure PrnOutStr(var Prn: PrnRec; Text: PAnsiChar; Len: Integer);
var
	Extent: TSize;
	L: Integer;
begin
	with Prn, static_FPrinter.Canvas do begin
		while Len > 0 do begin
			L := Len;
			GetTextExtentPointA(Handle, Text, L, Extent);

			while (L > 0) and (Extent.cX + Cur.X > Finish.X) do begin
				L := CharPrevA(Text, Text+L) - Text;
				GetTextExtentPointA(Handle, Text, L, Extent)
			end;

			if Extent.cY > Height then Height := Extent.cY + 2;
			Winapi.Windows.TextOutA(Handle, Cur.X, Cur.Y, Text, L);
			Dec(Len, L);Inc(Text, L);
			if Len > 0 then NewLine(Prn) else Inc(Cur.X, Extent.cX)
		end
	end
end;

{ Print a string to the printer handling special characters. }
procedure PrnString(var Prn: PrnRec; Text: PAnsiChar; Len: Integer);
var
	L: Integer;
	TabWidth: Word;

	procedure Flush;
	begin
		if L <> 0 then PrnOutStr(Prn, Text, L);
		Inc(Text, L + 1);Dec(Len, L + 1);
		L := 0
	end;

	function AvgCharWidth: Word;
	var Metrics: TTextMetric;
	begin
		GetTextMetrics(static_FPrinter.Canvas.Handle, Metrics);
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

{$IF DEFINED(CLR)}
type
	TPrinterTextFactory = class(TObject, ITextDeviceFactory)
		function Open(t: Text; Mode: Word): Integer;
		function Close(t: Text): Integer;
	end;

	TPrinterWriter = class(System.IO.TextWriter)
	private
		FPrnRec: PrnRec;
	public
		constructor Create;
		procedure Close; override;
		function get_Encoding: System.Text.Encoding; override;
		procedure Write(Value: Char); override;
		procedure Write(buffer: array of Char); override;
		procedure Write(buffer: array of Char; index: Integer; count: Integer); override;
		procedure Write(Value: string); override;
		procedure WriteLine; override;
	end;

function TPrinterTextFactory.Open(t: Text; Mode: Word): Integer;
begin
	if (Mode <> fmOutput) then begin Result := 102;Exit end;
	t.Reader := NIL;  // cant read
	t.Writer := TPrinterWriter.Create;
	t.Mode := fmOutput;
	Result := 0
end;

function TPrinterTextFactory.Close(t: Text): Integer;
begin
//  if t.Writer <> nil then
//    (t.Writer as System.IO.StreamWriter).BaseStream.Close;
	t.Reader := NIL;t.Writer := NIL;
	t.Mode := fmClosed;
	Result := 0
end;

constructor TPrinterWriter.Create;
begin
	inherited;
	static_FPrinter.BeginDoc;
	FPrnRec.Cur.X := 0;
	FPrnRec.Cur.Y := 0;
	FPrnRec.Finish.X := static_FPrinter.PageWidth;
	FPrnRec.Finish.Y := static_FPrinter.PageHeight;
	FPrnRec.Height := 0
end;

procedure TPrinterWriter.Close;
begin
	static_FPrinter.EndDoc
end;

function TPrinterWriter.get_Encoding: System.Text.Encoding;
begin
	Result := System.Text.Encoding.ASCII
end;

procedure TPrinterWriter.Write(Value: Char);
begin
	PrnString(FPrnRec, Value, 1)
end;

procedure TPrinterWriter.Write(buffer: array of Char);
var S: string;
begin
	S := System.String.Create(buffer);
	PrnString(FPrnRec, S, Length(S))
end;

procedure TPrinterWriter.Write(buffer: array of Char; index: Integer; count: Integer);
var S: string;
begin
	S := System.String.Create(buffer, index, count);
	PrnString(FPrnRec, S, count)
end;

procedure TPrinterWriter.Write(Value: string);
begin
	PrnString(FPrnRec, Value, Length(Value))
end;

procedure TPrinterWriter.WriteLine;
begin
	Borland.Vcl.Printers.NewLine(FPrnRec)
end;
{$ENDIF}

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

{ Will ignore certain requests by the I/O system such as flush while doing an
  input. }
function PrnIgnore(var F: TTextRec): Integer;
begin
	Result := 0
end;

{ Deallocates the resources allocated to the printer file. }
function PrnClose(var F: TTextRec): Integer;
begin
	with PrnRec(F.UserData) do begin
		static_FPrinter.EndDoc;
		Result := 0
	end
end;

{ Called to open I/O on a printer file.  Sets up the TTextFile to point to
  printer I/O functions. }
function PrnOpen(var F: TTextRec): Integer;
//const
//  Blank: array[0..0] of Char = '';
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
			static_FPrinter.BeginDoc;

			Cur.X := 0;Cur.Y := 0;
			Finish.X := static_FPrinter.PageWidth;
			Finish.Y := static_FPrinter.PageHeight;
			Height := 0
		end;
		Result := 0
	end
end;

procedure AssignPrn(var F: Text);
begin
	with TTextRec(F), PrnRec(UserData) do begin
//		Printer;	*** commentato da Federico
		FillChar(F, SizeOf(F), 0);
		Mode := fmClosed;
		BufSize := SizeOf(Buffer);
		BufPtr := @Buffer;
		OpenFunc := @PrnOpen
	end
end;

{ TPrinterDevice }

constructor TPrinterDevice.Create(ADriver, ADevice, APort: TPrinterDeviceStringType);
begin
	inherited Create;
	Driver := ADriver;Device := ADevice;Port := APort
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
var FontSize: Integer;
begin
	if (GetDeviceCaps(Printer.DC, LOGPIXELSY) <> Font.PixelsPerInch) then begin
		FontSize := Font.Size;
		Font.PixelsPerInch := GetDeviceCaps(Printer.DC, LOGPIXELSY);
		Font.Size := FontSize
	end
end;

{ TPrinter }

constructor TPrinter.Create;
begin
	inherited Create;
	FPrinterIndex := -1
end;

destructor TPrinter.Destroy;
begin
  if Printing then EndDoc;
  SetState(TPrinterState.psNoHandle);
  FreePrinters;
  FreeFonts;
  FCanvas.Free;
  if FPrinterHandle <> 0 then ClosePrinter(FPrinterHandle);
  if FDeviceMode <> 0 then begin
	 GlobalUnlock(FDeviceMode);
	 GlobalFree(FDeviceMode);
	 FDeviceMode := 0;
  end;
  inherited Destroy;
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
			CheckPrinting(False);
			if Assigned(FCanvas) then FCanvas.Handle := 0;
			DeleteDC(DC);DC := 0
		end;
		TPrinterState.psHandleIC:
		  if (State = TPrinterState.psHandleDC) then exit
		  else CreateHandleFunc := CreateIC;
		TPrinterState.psHandleDC: begin
			if FCanvas <> nil then FCanvas.Handle := 0;
			if DC <> 0 then DeleteDC(DC);
			CreateHandleFunc := CreateDC;
		end
	end;
	if Assigned(CreateHandleFunc) then begin
		tpd := TPrinterDevice(Printers.Objects[PrinterIndex]);
		DC := CreateHandleFunc(PChar(tpd.Driver), PChar(tpd.Device), PChar(tpd.Port), FDevMode);
		if (DC = 0) then RaiseError(SInvalidPrinter);
		if (FCanvas <> NIL) then FCanvas.Handle := DC
	end;
	State := Value
end;

procedure TPrinter.CheckPrinting(Value: Boolean);
begin
	if Printing <> Value then
		if Value then RaiseError(SNotPrinting) else RaiseError(SPrinting);
end;

[PrintingPermission(SecurityAction.LinkDemand, Level=PrintingPermissionLevel.AllPrinting)]
procedure TPrinter.Abort;
begin
	CheckPrinting(TRUE);
	AbortDoc(Canvas.Handle);
	FAborted := TRUE;
	EndDoc;
	FAborted := TRUE
end;

[PrintingPermission(SecurityAction.LinkDemand, Level=PrintingPermissionLevel.AllPrinting)]
procedure TPrinter.BeginDoc;
var DocInfo: TDocInfo;
begin
	CheckPrinting(FALSE);
	SetState(TPrinterState.psHandleDC);
	Canvas.Refresh;
	TPrinterCanvas(Canvas).UpdateFont;
	FPrinting := TRUE;
	FAborted := FALSE;
	FPageNumber := 1;
	FillChar(DocInfo, SizeOf(DocInfo), 0);
	with DocInfo do begin cbSize := SizeOf(DocInfo);lpszDocName := PChar(Title) end;
	SetAbortProc(DC, AbortProc);
	if (StartDoc(DC, DocInfo) <= 0) then FPrinting := FALSE else StartPage(DC)
end;

[PrintingPermission(SecurityAction.LinkDemand, Level=PrintingPermissionLevel.AllPrinting)]
procedure TPrinter.EndDoc;
begin
	CheckPrinting(True);
	EndPage(DC);
	if not Aborted then Winapi.Windows.EndDoc(DC);
	FPrinting := FALSE;FAborted := FALSE;FPageNumber := 0
end;

[PrintingPermission(SecurityAction.LinkDemand, Level=PrintingPermissionLevel.AllPrinting)]
procedure TPrinter.NewPage;
begin
	CheckPrinting(TRUE);
	EndPage(DC);
	StartPage(DC);
	Inc(FPageNumber);
	Canvas.Refresh
end;

{$IF DEFINED(CLR)}
procedure TPrinter.GetPrinter(var ADevice, ADriver, APort: string; var ADeviceMode: IntPtr);
begin
  with TPrinterDevice(Printers.Objects[PrinterIndex]) do
  begin
	 ADevice := Device;
    ADriver := Driver;
    APort := Port;
  end;
  ADeviceMode := FDeviceMode;
end;
{$ELSE}
procedure TPrinter.GetPrinter(ADevice, ADriver, APort: PChar; var ADeviceMode: THandle);
begin
  with TPrinterDevice(Printers.Objects[PrinterIndex]) do
  begin
    StrCopy(ADevice, PChar(Device));
    StrCopy(ADriver, PChar(Driver));
    StrCopy(APort, PChar(Port));
  end;
  ADeviceMode := FDeviceMode;
end;
{$ENDIF}

procedure TPrinter.SetPrinterCapabilities(Value: Integer);
begin
  FCapabilities := [];
  if (Value and DM_ORIENTATION) <> 0 then
    Include(FCapabilities, pcOrientation);
  if (Value and DM_COPIES) <> 0 then
    Include(FCapabilities, pcCopies);
  if (Value and DM_COLLATE) <> 0 then
    Include(FCapabilities, pcCollation);
end;

{$IF DEFINED(CLR)}
procedure TPrinter.UpdateDeviceMode(ADeviceMode: IntPtr);
begin
  if FDeviceMode <> nil then
	 Marshal.FreeHGlobal(FDeviceMode);
  FDeviceMode := ADeviceMode;
end;
{$ENDIF}

[PrintingPermission(SecurityAction.LinkDemand, Level=PrintingPermissionLevel.AllPrinting)]
procedure TPrinter.SetPrinter(ADevice, ADriver, APort: PChar; ADeviceMode: THandle);
var I, J: Integer;
begin
	CheckPrinting(FALSE);
{$ifdef DEBUG}
	writeln_system_debug(1, 'PRINTER_VCL.TPrinter.SetPrinter()', 'previous STR_SETPRINTED_DEVICE=' + str_setprinted_device);
	writeln_system_debug(2, 'PRINTER_VCL.TPrinter.SetPrinter()', 'assigning ADEVICE=' + ADevice);
{$endif DEBUG}
	str_setprinted_device := ADevice;
	if (ADeviceMode <> FDeviceMode) then begin		// free the devmode block we have, and take the one we're given
		if (FDeviceMode <> 0) then begin
			GlobalUnlock(FDeviceMode);GlobalFree(FDeviceMode);
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
	with Printers do begin   // <- this rebuilds the FPrinters list
		for I := 0 to Count - 1 do begin
			if TPrinterDevice(Objects[I]).IsEqual(ADriver, ADevice, APort) then begin
				TPrinterDevice(Objects[I]).Port := APort;
				J := I;Break
			end
		end
	end;
	if (J = -1) then begin
		J := FPrinters.Count;
		FPrinters.AddObject(Format(SDeviceOnPort, [ADevice, APort]),
		TPrinterDevice.Create(ADriver, ADevice, APort))
	end;
	FPrinterIndex := J;
	if OpenPrinter(ADevice, FPrinterHandle, NIL) then begin
		if (FDeviceMode = 0) then begin		// alloc new device mode block if one was not passed in
			FDeviceMode := GlobalAlloc(GHND, DocumentProperties(0, FPrinterHandle, ADevice, NIL, NIL, 0));

			if (FDeviceMode <> 0) then begin
				FDevMode := GlobalLock(FDeviceMode);
				if (DocumentProperties(0, FPrinterHandle, ADevice, FDevMode, NIL, DM_OUT_BUFFER) < 0) then begin
					GlobalUnlock(FDeviceMode);GlobalFree(FDeviceMode);
					FDeviceMode := 0;FDevMode := NIL
				end
			end
		end;
		if (FDeviceMode <> 0) then SetPrinterCapabilities(FDevMode^.dmFields)
	end
end;

function TPrinter.GetCanvas : TCanvas;
begin
	if (FCanvas = NIL) then FCanvas := TPrinterCanvas.Create(Self);
	Result := FCanvas
end;

function EnumFontsProc(var LogFont : TLogFont;var TextMetric : TTextMetric;FontType : Integer;Data : Pointer) : Integer; stdcall;
begin
	TStrings(Data).Add(LogFont.lfFaceName);
	Result := 1
end;

function TPrinter.GetFonts : TStrings;
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

function TPrinter.GetHandle : HDC;
begin
	SetState(TPrinterState.psHandleIC);
	Result := DC
end;

function TPrinter.GetNumCopies : Integer;
begin
	GetPrinterIndex;
	if (FDeviceMode = 0) then RaiseError(SInvalidPrinterOp);
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
	if (FDeviceMode = 0) then RaiseError(SInvalidPrinterOp);
	if (FDevMode.dmOrientation = DMORIENT_PORTRAIT) then Result := poPortrait else Result := poLandscape
end;

procedure TPrinter.SetOrientation(Value: TPrinterOrientation);
const Orientations: array [TPrinterOrientation] of Integer = ( DMORIENT_PORTRAIT, DMORIENT_LANDSCAPE);
begin
	CheckPrinting(False);
	GetPrinterIndex;
	if FDeviceMode = 0 then RaiseError(SInvalidPrinterOp);
	SetState(TPrinterState.psNoHandle);
	FDevMode^.dmOrientation := Orientations[Value]
end;

function TPrinter.GetPageHeight : Integer;
begin
	SetState(TPrinterState.psHandleIC);
	Result := GetDeviceCaps(DC, VertRes)
end;

function TPrinter.GetPageWidth : Integer;
begin
	SetState(TPrinterState.psHandleIC);
	Result := GetDeviceCaps(DC, HorzRes)
end;

function TPrinter.GetPrinterIndex : Integer;
begin
  if (FPrinterIndex = -1) then SetToDefaultPrinter;
  Result := FPrinterIndex;
end;

procedure TPrinter.SetPrinterIndex(Value : Integer);
var
	lDeviceMode : THandle;	//*
	lDevice, lDriver, lPort : Array[0..255] of Char;	//*
begin
	CheckPrinting(False);
	if (Value < -1) or (Value >= Printers.Count) then RaiseError(SPrinterIndexError);
	if (Value = -1) then SetToDefaultPrinter;
	if (Value <> FPrinterIndex) then begin
		if (Value <> -1) then FPrinterIndex := Value;
//		with TPrinterDevice(Printers.Objects[FPrinterIndex]) do Printer.GetPrinter(lDevice, lDriver, lPort, lDeviceMode);
		with TPrinterDevice(Printers.Objects[FPrinterIndex]) do static_FPrinter.GetPrinter(lDevice, lDriver, lPort, lDeviceMode);
		GlobalUnlock(lDeviceMode);GlobalFree(lDeviceMode);lDeviceMode := 0;
//		Printer.SetPrinter(lDevice, lDriver, lPort, lDeviceMode);
		static_FPrinter.SetPrinter(lDevice, lDriver, lPort, lDeviceMode);
		FreeFonts;
		SetState(TPrinterState.psNoHandle)
	end
end;

function TPrinter.GetPrinters: TStrings;
var
	Flags, Count, NumInfo: DWORD;
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
				for var i : smallint := 0 to NumInfo - 1 do begin
					if (Level = 4) then
					with PPrinterInfo4(PrinterInfo)^ do begin
						FPrinters.AddObject(pPrinterName,
						TPrinterDevice.Create(nil, pPrinterName, NIL));
						Inc(PrinterInfo, sizeof(TPrinterInfo4))
					end
					else
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
	I : Integer;
	ByteCnt, StructCnt : DWORD;
	DefaultPrinter : array[0..1023] of Char;
	Device : PChar;
begin
	ByteCnt := 0;StructCnt := 0;
	if NOT EnumPrinters(PRINTER_ENUM_DEFAULT, NIL, 5, NIL, 0, ByteCnt, StructCnt) AND (GetLastError <> ERROR_INSUFFICIENT_BUFFER) then begin
		// With no printers installed, Win95/98 fails above with "Invalid filename".
		// NT succeeds and returns a StructCnt of zero.
		if GetLastError = ERROR_INVALID_NAME then RaiseError(SNoDefaultPrinter) else RaiseLastOSError
	end;
	var PrinterInfo : PPrinterInfo5 := AllocMem(ByteCnt);
	try
		EnumPrinters(PRINTER_ENUM_DEFAULT, NIL, 5, PrinterInfo, ByteCnt, ByteCnt, StructCnt);
		if StructCnt > 0 then Device := PrinterInfo.pPrinterName
		else begin
{$IF DEFINED(UNICODE)}
			I := Length(DefaultPrinter);
			if NOT GetDefaultPrinter(DefaultPrinter, I) then ZeroMemory(@DefaultPrinter[0], I * SizeOf(Char));
{$ELSE}
			GetProfileString('windows', 'device', '', DefaultPrinter, SizeOf(DefaultPrinter) - 1);
{$ENDIF}
			var Cur : PChar := DefaultPrinter;
			Device := FetchStr(Cur)
		end;
		with Printers do begin
			for I := 0 to Count-1 do begin
			  if AnsiSameText(TPrinterDevice(Objects[I]).Device, Device) then begin
					with TPrinterDevice(Objects[I]) do SetPrinter(PChar(Device), PChar(Driver), PChar(Port), 0);
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
begin
	if FPrinters <> nil then begin
		for var i : smallint := 0 to FPrinters.Count - 1 do FPrinters.Objects[I].Free;
		FreeAndNil(FPrinters)
	end
end;

procedure TPrinter.FreeFonts;
begin
	FreeAndNil(FFonts)
end;

{function Printer: TPrinter;
begin
	if (static_FPrinter = NIL) then static_FPrinter := TPrinter.Create;
	Result := static_Printer
end;

[PrintingPermission(SecurityAction.LinkDemand, Level=PrintingPermissionLevel.AllPrinting)]
function SetPrinter(NewPrinter: TPrinter): TPrinter;
begin
  Result := FPrinter;
  FPrinter := NewPrinter;
end;}

procedure TPrinter.Refresh;
begin
	FreeFonts;
	FreePrinters
end;

initialization
finalization
//	static_FPrinter.Free;
end.
