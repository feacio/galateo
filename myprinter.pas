unit MyPrinter;	//* contiene le procedure di gestione della stampante

{$I defines}

interface

uses Windows, Forms, WinSpool, SysUtils, StdCtrls,
	FCommons, printers_VCL, printers_DX;

const
	STAMPANTE_PREDEFINITA = '*** STAMPANTE PREDEFINITA ***';

var
	str_stampante_predefinita : string;		// stampante predefinita di sistema
	str_last_printer_used : string;			// identifica la stampante usata nella stampa precedente

function set_phisical_active_printer(father : TForm;bo_forza : boolean;str_printer : String;bo_msg : boolean = FALSE) : boolean;	// attiva la stampante specificata
//function set_default_printer(str_printer : String) : boolean;

function base_printer_configuration : boolean;
function advanced_printer_configuration(bo_advanced_configuration : boolean;
	orientation : TPrinterOrientation;id_cassetto_carta : smallint;
	i_phisical_PaperWidth,i_phisical_PaperLength : integer) : boolean;
procedure fill_info_cassetto_carta(str_printer : string;cb : TComboBox);
function get_id_cassetto_carta(str_printer, str_cassetto_carta : string) : smallint;
function get_cassetto_ID(str_printer, str_cassetto_descrizione : string) : smallint;

implementation

uses FErrMsg, FXStrings, FStrings, FAssert, FMessage, FSystem, FCtrls,
	galateo_debug, Gdich, misure, pages;

const
	MBOX_CAPTION = 'Stampante';

type
	TBinName = array[0..23] of char;	// nome dei cassetti per la carta DC_BINNAMES
	TBinName_array = array of TBinName;

var
	// variabili utili per i valori di inizializzazione della Advanced Printer Configuration
	bo_executed_APC : boolean;	// TRUE dopo aver eseguito almeno una volta la Advanced Printer Configuration
	i_default_defaultsource : smallint;

	str_tray_printer : string;					// stampante per la quale sono state lette le informazioni dei TRAYs
	TRAYS_descr : string_array;					// TRAYS della stampante attiva
	trays_IDs : integer_array;					// IDs dei trays per la stampante attiva

function set_phisical_active_printer(father : TForm;bo_forza : boolean;str_printer : string;bo_msg : boolean = FALSE) : boolean;
{ rende FISICAMENTE attiva la stampante specificata;
  rende TRUE se è stato possibile effettuare l'operazione, FALSE altrimenti;
  emette eventuali messaggi di avvertimento }
const MBOX_DEBUG_CAPTION = 'set_phisical_active_printer()';
var
	p1, p2, p3 : array[0..300] of char;
	DM : thandle;
	d : ^TDeviceMode;
begin
	var i_previous_index : smallint := 0;
	var wh : hwnd := 0;
	if (father <> NIL) then wh := father.Handle;
	if NOT bo_forza AND (printer.printers[printer.printerindex] = str_printer) then begin result := TRUE;exit end;
	{$ifdef TESTDEBUG} messagebbox(0, 'set_phisical_active_printer(' + str_printer + ')', MBOX_CAPTION); {$endif}

	try
		i_previous_index := printer.PrinterIndex;
		if (printer.PrinterIndex = printer.Printers.IndexOf(str_printer)) then printer.PrinterIndex := -1;		// riga aggiunta 2014-07-02 x' altrimenti la stampa non funzionava su Windows 8
		printer.PrinterIndex := printer.Printers.IndexOf(str_printer);
{$ifdef TESTDEBUG}
		messagebbox(0, 'XXXXXXX printer.printerindex = ' + inttostr(printer.PrinterIndex), MBOX_CAPTION);
		messagebbox(0, 'str_printer=' + str_printer, MBOX_CAPTION);
		messagebbox(0, 'printer.Printers[printer.printerindex]=' + printer.Printers[printer.printerindex], MBOX_CAPTION);
{$endif}

		if (globale.i_forced_width_10mm <> 0) AND (globale.i_forced_height_10mm <> 0) then begin
			printer.GetPrinter(p1, p2, p3, DM);		// leggo il valore di DM
			d := GlobalLock(DM);
			d.dmFields := d.dmFields OR DM_PAPERLENGTH OR DM_PAPERWIDTH;
			d.dmPaperLength := globale.i_forced_height_10mm;
			d.dmPaperWidth := globale.i_forced_width_10mm;
			GlobalUnlock(DM);
			printer.SetPrinter(p1, p2, p3, DM)
		end;
		writeln_system_debug(0, MBOX_DEBUG_CAPTION, 'before init_print_values(' + globale.str_current_printer + ')');
		tm.init_print_values({printer_handle,}str_printer);
		writeln_system_debug(0, MBOX_DEBUG_CAPTION, 'after init_print_values(' + globale.str_current_printer + ')');

		result := TRUE
	except
		result := FALSE
	end;
	if NOT result then begin
		if bo_msg then MessageBBox(wh, 'Impossibile selezionare la stampante <' + str_printer + '>', MBOX_CAPTION);
		if (printer.PrinterIndex <> i_previous_index) then
			// provo a riattivare la stampante precedentemente attivata
			try printer.PrinterIndex := i_previous_index except end
	end
end;

// versione STANDARD
function advanced_printer_configuration(bo_advanced_configuration : boolean;orientation : TPrinterOrientation;
	id_cassetto_carta : smallint; i_phisical_PaperWidth, i_phisical_PaperLength : integer) : boolean;
// esegue l'impostazioni avanzate della stampante; rende TRUE in caso di successo, FALSE altrimenti
const MBOX_DEBUG_CAPTION = 'advanced_printer_configuration()';
var
	str_printername : string;	//*
	Device, Driver, Port : array[0..300] of char;
	DM : THandle;	//*
	devmode : PDeviceMode;	//*
begin
	runtime_debug('000', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
	try
{		i := printer.printers.IndexOf(globale.str_printer);
		if (i <> -1) then printer.PrinterIndex := i; }

		try
{			for i := 0 to printer.Printers.Count-1 do
				runtime_debug('00-' + i.ToString + printer.Printers[i], MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01); {}
			{ il seguente loop serve perchè a volte (esempio: portatili IBIservice 2020-02) la chiamata ha successo ma DEVMODE resta NIL;
			  provando a riassegnare PRINTERINDEX sembra che il groppo si sblocchi e la cosa funzioni }
			var i : smallint := 0;
			repeat
				printer.GetPrinter(device, driver, port, DM);
				if (i = 0) then str_printername := device;
				runtime_debug('010 device=' + device, MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
				devmode := GlobalLock(DM);
				runtime_debug('020 device=' + device + '  devmode=' + ifs(devmode = NIL, 'NIL', 'assigned'), MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
				if NOT assigned(devmode) then begin
					if (i < 3) then begin	// provo a forzare la riassegnazione
						inc(i);
						runtime_debug('030 loop=' + i.ToString + '  printerindex before=' + printer.PrinterIndex.ToString, MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
						printer.PrinterIndex := -1;
						printer.PrinterIndex := printer.Printers.IndexOf(device);
						runtime_debug('031 loop=' + i.ToString + '  printerindex after =' + printer.PrinterIndex.ToString, MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01)
					end
					else abort
				end
			until assigned(devmode);
			{$ifdef DEBUG} assert(str_printername = device, 'myprinter::wrong device: ' + device + ' instead of ' + str_printername + ' --- KLPW 3991'); {$endif}
			runtime_debug('100', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
			devmode.dmFields := 0;
			runtime_debug('110', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);

			if bo_advanced_configuration then begin
				// DIMENSIONE FOGLIO --------------------------------------------------
				{	necessario impostarlo, perchè altrimenti in NT prende un valore che non è nè
					il valore di Galateo nè quello stabilito come default per la stampante;
					valori in decimi di mm }
{					if ((devmode.dmFields AND DM_PAPERSIZE) <> 0) then dec(devmode.dmFields,DM_PAPERSIZE);
				devmode.dmPaperSize := 0;
				devmode.dmFields := (devmode.dmFields OR DM_PAPERLENGTH OR DM_PAPERWIDTH);
				devmode.dmPaperLength := i_phisical_PaperLength;
				devmode.dmPaperWidth := i_phisical_PaperWidth; //div 10;  }

				runtime_debug('120 pre orientation', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
				// ORIENTAMENTO STAMPA ------------------------------------------------
				devmode.dmFields := (devmode.dmFields OR DM_ORIENTATION);
				if (orientation = poPortrait) then devmode.dmOrientation := DMORIENT_PORTRAIT
				else devmode.dmOrientation := DMORIENT_LANDSCAPE;

				// CASSETTO CARTA -----------------------------------------------------
				// leggo il valore default del device
				runtime_debug('130 pre cassetto', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
				if NOT bo_executed_APC then i_default_defaultsource := devmode.dmDefaultSource;
				devmode.dmFields := (devmode.dmFields OR DM_DEFAULTSOURCE);
				// se valore default, utilizzo il valore base
				if (id_cassetto_carta = -1) then devmode.dmDefaultSource := i_default_defaultsource
				else devmode.dmDefaultSource := id_cassetto_carta
			end;
//			strcpy(device,LPSTR(globale.str_printer)); commentato il 2004-07-21
			runtime_debug('200 before setPrinter()', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
			printer.setPrinter(device, driver, port, DM);
			runtime_debug('210 post setPrinter()', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
			bo_executed_APC := TRUE
		finally
			GlobalUnlock(DM)
		end;

		runtime_debug('900 success', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		result := TRUE
	except
		error_msg('Errore durante l''impostazione avanzata della stampante', MBOX_CAPTION);
		result := FALSE
	end
end;

function base_printer_configuration : boolean;
begin
	result := advanced_printer_configuration(FALSE, poPortrait, -1, 0, 0)
end;

// VERSIONE DOCUMENT_PROPERTIES
(*function advanced_printer_configuration(orientation : TPrinterOrientation;id_cassetto_carta : smallint;
	i_phisical_PaperWidth,i_phisical_PaperLength : integer) : boolean;
// esegue l'impostazioni avanzate della stampante; rende TRUE in caso di successo, FALSE altrimenti
var
	Device, Driver, Port: array[0..79] of char;
	DM: THandle;
	devmode,nullo : PDeviceModeA;
	i : integer;
begin
	devmode := NIL;
	try
		printer.GetPrinter(device,driver,port,DM);
//exit;
		try
			devmode := GlobalLock(DM);
			if NOT assigned(devmode) then abort;
			devmode.dmFields := 0;

			// DIMENSIONE FOGLIO --------------------------------------------------
			{	necessario impostarlo, perchè altrimenti in NT prende un valore che non è nè
				il valore di Galateo nè quello stabilito come default per la stampante;
				valori in decimi di mm }
{			if ((devmode.dmFields AND DM_PAPERSIZE) <> 0) then dec(devmode.dmFields,DM_PAPERSIZE);
			devmode.dmPaperSize := 0;
			devmode.dmFields := (devmode.dmFields OR DM_PAPERLENGTH OR DM_PAPERWIDTH);
			devmode.dmPaperLength := i_phisical_PaperLength;
			devmode.dmPaperWidth := i_phisical_PaperWidth; //div 10; }

			// ORIENTAMENTO STAMPA ------------------------------------------------
			devmode.dmFields := (devmode.dmFields OR DM_ORIENTATION);
			if (orientation = poPortrait) then devmode.dmOrientation := DMORIENT_PORTRAIT
			else devmode.dmOrientation := DMORIENT_LANDSCAPE;

			// CASSETTO CARTA -----------------------------------------------------
			// leggo il valore default del device
			if NOT bo_executed_apc then i_default_defaultsource := devmode.dmDefaultSource;
			devmode.dmFields := (devmode.dmFields OR DM_DEFAULTSOURCE);
			// se valore default, utilizzo il valore base
			if (id_cassetto_carta = -1) then devmode.dmDefaultSource := i_default_defaultsource
			else devmode.dmDefaultSource := id_cassetto_carta

			{ da implementare
				DMCOLLATE_TRUE
				DM_PRINTQUALITY
				DM_COPIES
			}
		finally
			GlobalUnlock(DM);devmode := NIL
		end;

//		printer.setPrinter(device,driver,port,DM);result := TRUE
		new(nullo);fillchar(nullo^,sizeof(nullo^),0);
		i := DocumentProperties(0,printer.handle,device,devmode^,nullo^,DM_IN_BUFFER);
		result := (i >= 0);
		dispose(nullo);

		if (result) then bo_executed_apc := TRUE
	except
		error_msg(0,'Errore durante l''impostazione avanzata della stampante',MBOX_CAPTION,MB_ICONSTOP);
		result := FALSE
	end
end; *)

(*function set_default_printer(str_printer : String) : boolean;
// seleziona la stampante specificata; rende TRUE se esegue il compito, FALSE se fallisce
var
	j : smallint;
	Device, Driver, Port : LPSTR;
	HdeviceMode: Thandle;
	p : TPrinter;
begin
	result := FALSE;
	Device := NIL;Driver := NIL;Port := NIL;p := NIL;
	str_printer := uppercase(str_printer);

	try
		// Seleziona la stampante di default
		Printer.PrinterIndex := -1;
		getmem(Device, 255);getmem(Driver, 255);getmem(Port, 255);
		p := TPrinter.create;
		// se la stampante fa parte di quelle selezionate
		for j := 0 to Printer.printers.Count-1 do begin
			if (uppercase(Printer.printers[j]) = str_printer) then begin
				p.printerindex := j;
				p.getprinter(device, driver, port, HdeviceMode);
				StrCat(Device, ',') ;
				StrCat(Device, Driver) ;
				StrCat(Device, Port) ;
				WriteProfileString('windows', 'device', Device) ;
				StrCopy(Device, 'windows' ) ;
				SendMessage(HWND_BROADCAST, WM_WININICHANGE,0, integer(@Device));
				result := TRUE;
				exit
			end
		end
	finally
		// libera tutto
		if (Device <> NIL) then Freemem(device,255);
		if (Driver <> NIL) then Freemem(Driver,255);
		if (Port <> NIL) then Freemem(Port,255);
		if (p <> NIL) then p.Free
	end
end; *)

(*procedure fill_info_cassetto_carta(str_printer : string;cb : TComboBox);
var
	Bins : array of TBinName;
	Device, Driver, Port: array[0..79] of char;
	i_items, i : smallint;
	Dummy: THandle;
	printer : TFPrinter;
	str_selected : string;
begin
	printer := NIL;
	try
		try
			set_wait_cursor(TRUE);
			if (str_printer = STAMPANTE_PREDEFINITA) then str_printer := str_stampante_predefinita;
			printer := TFPrinter.Create;
			str_selected := cb.Text;
			cb.Clear;
			i := printer.printers.indexOf(str_printer);
			if (i = -1) then exit;
			cb.Items.add('');
			printer.PrinterIndex := i;
			printer.GetPrinter(@Device, @Driver, @Port, Dummy);
//			i_items := DeviceCapabilitiesA(Device, Port,DC_BINNAMES,NIL,NIL);
			i_items := DeviceCapabilitiesA(@Device, {@Port}NIL, DC_BINNAMES, NIL, NIL);
			if (i_items > 0) then begin
				SetLength(Bins, i_items);
				DeviceCapabilities(Device, Port, DC_BINNAMES, Bins[0],NIL);
				for i := 0 to i_items-1 do cb.Items.add(StrPas(Bins[i]));
				cb_select(cb, str_selected)
			end
//			else RaiseLastWin32Error	******* prima versione
//			else RaiseLastOSError		*** versione in uso fino al 2007-06-06;
					// commentata perchè in rarissimi casi dava errore, e impediva la stampa, mentre è meglio piuttosto perdere le info sui cassetti
					// esempio di guaio : HELM, "Kyocera FS-1030D KX" su server02
					// esempio di guaio : CO2Laser, "Samsung 4521"
		finally
			printer.free;
			set_wait_cursor(FALSE)
		end
	except
		runtime_debug('*** ERRORE ***' + ACAPO2 + get_last_error_msg, 'fill_info_cassetto_carta(' + str_printer + ')', RD_DEBUG_PRINCIPALE_00)
	end
end;*)

(*procedure TfMAin.GetPaperBins(sl: TStrings; PrinterName: String);
// https://www.experts-exchange.com/questions/27527589/getting-printer-trays.html
type
	TBinName = array [0..23] of Char;
	TBinNameArray = array [1..High(Integer) div SizeOf(TBinName)] of TBinName;
	PBinnameArray = ^TBinNameArray;
	TBinArray = array [1..High(Integer) div SizeOf(Word)] of Word;
	PBinArray = ^TBinArray;
var
	Device, Driver, Port: array [0..255] of Char;
	hDevMode: THandle;
	i, numBinNames, numBins, temp: Integer;
	pBinNames: PBinnameArray;
	pBins: PBinArray;
begin
  //set specified printer
  for numBins := 0 to Printer.Printers.Count -1 do
		if Printer.Printers [numBins] = PrinterName then Printer.PrinterIndex := numBins;
  //original Code
	Printer.GetPrinter(Device, Driver, Port, hDevmode);
	numBinNames := WinSpool.DeviceCapabilities(Device, Port, DC_BINNAMES, nil, nil);
	numBins     := WinSpool.DeviceCapabilities(Device, Port, DC_BINS, nil, nil);
	if numBins <> numBinNames then
		raise Exception.Create('DeviceCapabilities reports different number of bins and bin names!');
	if numBinNames > 0 then begin
		pBins := NIL;
		GetMem(pBinNames, numBinNames * SizeOf(TBinname));
		GetMem(pBins, numBins * SizeOf(Word));
		try
			WinSpool.DeviceCapabilities(Device, Port, DC_BINNAMES, PChar(pBinNames), nil);
			WinSpool.DeviceCapabilities(Device, Port, DC_BINS, PChar(pBins), nil);
			sl.Clear;
			for i := 1 to numBinNames do begin
				temp := pBins^[i];
				sl.addObject(pBinNames^[i], TObject(temp))
			end
	finally
		FreeMem(pBinNames);
		if pBins <> nil then FreeMem(pBins)
		end
	end
end;	*)

{$ifdef DEBUG} {*$define TRAY_DEBUG} {$endif DEBUG}
function load_printer_trays(str_printer : string;var str_trays : string_array;var trays_IDs : integer_array) : boolean;
{ carica su STR_TRAYS i nomi dei cassetti di STR_PRINTER e su TRAYS_IDS gli identificativi;
  rende TRUE se l'operazione ha successo, FALSE altrimenti }
const MBOX_DEBUG_CAPTION = 'load_printer_trays(()';
type
//	TBinArray = array[1..High(Integer) div Sizeof(Word)] of Word;
	TBinArray = array[0..High(Integer) div Sizeof(Word)-1] of Word;
	PBinArray = ^TBinArray;
var
	HPrinter : THandle;	//*
	pBins: PBinArray;
	trays : TBinName_array;
begin
	result := FALSE;
	if (str_printer = STAMPANTE_PREDEFINITA) then str_printer := str_stampante_predefinita;
	writeln_system_debug(0, MBOX_DEBUG_CAPTION, 'PRINTER: ' + str_printer);
	{$ifdef TRAY_DEBUG} messagebbox(0, 'PRINTER: ' + str_printer, MBOX_DEBUG_CAPTION); {$endif}
	if NOT OpenPrinter(PChar(str_printer), HPrinter, NIL) then exit;
	writeln_system_debug(10, MBOX_DEBUG_CAPTION, 'after open printer');
	{$ifdef TRAY_DEBUG} messagebbox(0, 'after open printer', MBOX_DEBUG_CAPTION); {$endif}

	var i00 : integer := DeviceCapabilities(PChar(str_printer), NIL, DC_BINNAMES, NIL, NIL);		// numero di cassetti
	writeln_system_debug(15, MBOX_DEBUG_CAPTION, 'dw_00 = ' + i00.Tostring);
	{$ifdef TRAY_DEBUG} messagebbox(0, 'dw_00 = ' + i00.Tostring, MBOX_DEBUG_CAPTION); {$endif}
	if (i00 < 0) then begin
		str_trays := NIL;trays_IDs := NIL;
		exit
	end;

	str_tray_printer := str_printer;
	setLength(str_trays, i00);setLength(trays_IDs, i00);
	writeln_system_debug(20, MBOX_DEBUG_CAPTION);

	GetMem(pBins, i00 * Sizeof(Word));
	var i01 : integer := DeviceCapabilities(PChar(str_printer), NIL, DC_BINS, PChar(pBins), NIL);
	if (i00 <> i01) then {$ifdef DEBUG} assert(FALSE, 'TRAYS: numero di IDS differente da numero di NAMES -- KEJI 0389') {$endif};
	writeln_system_debug(30, MBOX_DEBUG_CAPTION);

	if (i00 > 0) then begin
		writeln_system_debug(40, MBOX_DEBUG_CAPTION);
		{$ifdef TRAY_DEBUG} messagebbox(0, '40', MBOX_DEBUG_CAPTION); {$endif}
		SetLength(trays, i00);		// dimensiono il buffer in cui saranno scritti i cassetti (ciascuno lungo 24 caratteri)
		DeviceCapabilities(PChar(str_printer), NIL, DC_BINNAMES, Pointer(trays), NIL);
		for var i : smallint := 0 to i00-1 do begin
			str_trays[i] := StrPas(trays[i]);
			trays_IDs[i] := pBins[i]
		end
	end;
	writeln_system_debug(50, MBOX_DEBUG_CAPTION);
	{$ifdef TRAY_DEBUG} messagebbox(0, '50', MBOX_DEBUG_CAPTION); {$endif}
	if (pBins <> NIL) then FreeMem(pBins);
	ClosePrinter(HPrinter);
	writeln_system_debug(999, MBOX_DEBUG_CAPTION);
	{$ifdef TRAY_DEBUG} messagebbox(0, '999', MBOX_DEBUG_CAPTION); {$endif}
	result := TRUE
end;

procedure fill_info_cassetto_carta(str_printer : string;cb : TComboBox);
begin
	cb.Clear;
	if load_printer_trays(str_printer, TRAYS_descr, trays_IDs) then
		for var i : smallint := 0 to high(TRAYS_descr) do cb.Items.add(TRAYS_descr[i])
end;

function get_id_cassetto_carta(str_printer, str_cassetto_carta : string) : smallint;
// rende l'ID del cassetto carta; rende -1 per il cassetto default (nessuna indicazione specifica)
begin
//	str_printer := globale.xstr_printer;
	if (str_cassetto_carta = '') then result := -1		// niente da fare, evidentemente
	else begin
		result := get_cassetto_ID(str_printer, str_cassetto_carta);
		if (result = -1) then	// comunque rendo -1, ovvero 'cassetto default'
			MessageBBox(0, 'Impossibile identificare il cassetto carta richiesto' + ACAPO +
				'Viene utilizzato il cassetto default', MBOX_CAPTION, MB_ICONSTOP)
	end
end;

function get_cassetto_ID(str_printer, str_cassetto_descrizione : string) : smallint;
// rende l'INDICE (non l'ID !!!) per il cassetto indicato per la stampante indicata; -1 per errore (o not found)
begin
	result := -1;
	str_cassetto_descrizione := uppercase(str_cassetto_descrizione);
	if (uppercase(str_tray_printer) <> uppercase(str_printer)) AND NOT load_printer_trays(str_printer, TRAYS_descr, TRAYS_IDS) then exit;	// errore
	for var i : smallint := 0 to high(TRAYS_descr) do if (uppercase(TRAYS_descr[i]) = str_cassetto_descrizione) then begin result := trays_IDs[i];break end
end;

(*function set_printer_orientation(printer : TFPrinter;next_orientation : TPrinterOrientation) : boolean;
const MBOX_DEBUG_CAPTION = 'set_printer_orientation()';
begin
	runtime_debug('000 orientation required=' + byte(next_orientation).ToString, MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
{$ifdef WINDOWS_DIRECT_MODE}

{$else}	// modo usato fino 2020-02-22, fallisce su portatili IBI
	runtime_debug('001 previous orientation=' + byte(printer.Orientation).ToString, MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
	printer.Orientation := next_orientation;
{$endif}
end; *)

initialization
	galateo_initialization_debug('myprinter')
finalization
	galateo_finalization_debug('myprinter')
end.
