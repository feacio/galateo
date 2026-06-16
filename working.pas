unit working;	//*

{$I defines}
{$ifNdef CASA} *** {$endif}

interface

uses SysUtils, Windows, Messages, Classes, VCL.Graphics, VCL.Controls, VCL.Forms, VCL.Dialogs, VCL.StdCtrls, VCL.Buttons, VCL.ExtCtrls,
  Printers_DX, Gdich, proc;

type
  Tdlg_working = class(TForm)
	 btn_stop: TBitBtn;
	 txt1: TLabel;
	 txt2: TLabel;
	 txt_printer: TLabel;
	 procedure btn_stopClick(Sender : TObject);
	 procedure FormCloseQuery(Sender : TObject;var CanClose : Boolean);
	 procedure FormDestroy(Sender : TObject);
	 procedure FormCreate(Sender : TObject);
	 procedure FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
  private
		pt_bo_stop : ^boolean;
		bo_can_close : boolean;
		bo_report : boolean;
		bo_printing : boolean;		// TRUE se sta stampando, FALSE se in preparazione della stampa
		i_printed : integer;			// numero di oggetti già stampati
		i_2print : integer;			// numero di oggetti (etichette o pagine da stampare)
		lo_rows : integer;
		procedure another_record(str_descr_record : string);
		procedure init(bo_printing, bo_report : boolean;father : TForm;var bo_stop : boolean);
		function stopped : boolean;
		constructor create_printing(father : TForm;bo_report : boolean;i_2print : integer;var bo_stop : boolean);
		constructor create_preparing(father : TForm;bo_report : boolean;var bo_stop : boolean);
		procedure chiudi_finestra;
		procedure printed_another_one(bo_sending_email : boolean = FALSE);	// da chiamare al termine della stampa di OGNI etichetta o di ogni pagina
		procedure set_caption(str_caption : string);
		procedure set_avanzamento(fs : FASI_STAMPA_TYPE;
			i_logical_page : logical_page_type;i_virtual_page : ph_page_type;lo_rows : integer;str_descr_record : string;
			bo_forza_assegnazione_descrizione : boolean = FALSE);
		procedure set_text(i_text : byte;str_text : string);
	end;

function		ww_create_preparing(father : TForm;bo_report : boolean;var bo_stop : boolean) : boolean;
function		ww_create_printing(father : TForm;bo_report : boolean;i_2print : integer;var bo_stop : boolean) : boolean;

function		ww_stopped : boolean;	// rende TRUE se è stato schiacciato il bottone di stop
procedure	ww_read_record(str_descr_record : string);	// letto un altro record
function		ww_enable_button(bo_enabled : boolean) : boolean;		// rende lo stato precedente: TRUE se enabled, FALSE altrimenti
procedure	ww_printed_another_one(bo_sending_email : boolean = FALSE);
procedure	ww_reset_record_count(lo_rows : integer = 0);	// assegna il counter al valore specificato; usato soprattutto per resettare
procedure	ww_set_text(str_text : string); overload;							// comunica un cambiamento di attività
procedure	ww_set_text(i_text : byte;str_text : string); overload;		// comunica un cambiamento di attività
procedure	ww_set_caption(str_text : string);			// comunica un cambiamento di attività (livello massimo)
function		ww_exists : boolean;					// TRUE se la finestra è già stata creata
function		ww_show : boolean;
function		ww_close : boolean;					// chiude la finestra e libera le risorse
function		get_working_window : Tdlg_working;
procedure	ww_set_avanzamento(fs : FASI_STAMPA_TYPE;i_logical_page : logical_page_type;i_virtual_page : ph_page_type;
					lo_rows : integer;str_descr_record : string;bo_forza_assegnazione_descrizione : boolean = FALSE);

implementation

uses Fcommons, FAssert, FXStrings, FStrings, FSystem, FSystem_ext, FMessage,
	galateo_debug, Gun, pages;

{$R *.DFM}

var
	ww : Tdlg_working;
	bo_ww_silent_created : boolean;

function ww_create_preparing(father : TForm;bo_report : boolean;var bo_stop : boolean) : boolean;
begin
	{$ifdef DEBUG} assert(NOT ww_exists, 'ww_create_preparing() -- NOT NIL !!!'); {$endif}
	if silent_mode then bo_ww_silent_created := TRUE		// segnalo la creazione virtuale della finestra
	else ww := Tdlg_working.create_preparing(father, bo_report, bo_stop);
	result := TRUE
end;

function ww_create_printing(father : TForm;bo_report : boolean;i_2print : integer;var bo_stop : boolean) : boolean;
begin
	{$ifdef DEBUG} assert(NOT ww_exists, 'ww_create_printing() -- NOT NIL !!!'); {$endif}
	if silent_mode then bo_ww_silent_created := TRUE		// segnalo la creazione virtuale della finestra
	else ww := Tdlg_working.create_printing(father, bo_report, i_2print, bo_stop);
	result := TRUE
end;

function ww_stopped : boolean;
// rende TRUE se è stato schiacciato il bottone di stop
begin
	if silent_mode then result := FALSE
	else result := ww_exists AND ww.stopped
end;

procedure ww_read_record(str_descr_record : string);
// da chiamare in occasione della lettura di ogni nuovo record da SQL
begin
	if silent_mode then exit;
	if ww_exists then ww.another_record(str_descr_record)
end;

procedure ww_printed_another_one(bo_sending_email : boolean = FALSE);
begin
	if silent_mode then exit;
	if ww_exists then ww.printed_another_one(bo_sending_email)
end;

function ww_enable_button(bo_enabled : boolean) : boolean;
// abilita/disabilita il bottone STOP; rende lo stato precedente: TRUE se enabled, FALSE altrimenti
begin
//	if NOT ww_exists then begin result := FALSE;exit end;		*** così fino 2022-12-20
	if (ww = NIL) OR NOT ww_exists then begin result := FALSE;exit end;
	result := ww.btn_stop.Enabled;
	if (result <> bo_enabled) then begin ww.btn_stop.Enabled := bo_enabled;my_PeekMessage end
end;

procedure ww_reset_record_count(lo_rows : integer = 0);		// assegna il counter al valore specificato; usato soprattutto per resettare
begin
	if silent_mode then exit;
	if ww_exists then ww.lo_rows := lo_rows
end;

procedure ww_set_text(str_text : string);	// comunica un cambiamento di attività
begin
	if silent_mode OR (ww = NIL) then exit;
	ww.set_text(1, str_text);
	ww.set_text(2, '')
end;

procedure ww_set_text(i_text : byte;str_text : string); overload;		// comunica un cambiamento di attività
begin
	if silent_mode then exit;
	ww.set_text(i_text, str_text)
end;

procedure ww_set_caption(str_text : string);	// comunica un cambiamento di attività (livello massimo)
begin
	if silent_mode OR NOT ww_exists then exit;
	ww.set_caption(str_text)
end;

function ww_exists : boolean;
// rende TRUE se la finestra è già stata creata, FALSE se non ancora
begin
	if silent_mode then result := bo_ww_silent_created
	else result := (ww <> NIL) AND IsWindow(ww.handle)
end;

function ww_show : boolean;
begin
	if NOT silent_mode AND ww_exists then ww.Show;
	result := TRUE
end;

function get_working_window : Tdlg_working;
begin
	result := ww
end;

function ww_close : boolean;					// chiude la finestra e libera le risorse
begin
	if silent_mode then bo_ww_silent_created := FALSE
	else begin
		result := FALSE;
		if NOT ww_exists then exit;
		ww.chiudi_finestra;
		ww.free
	end;
	result := TRUE
end;

procedure ww_set_avanzamento(fs : FASI_STAMPA_TYPE;i_logical_page : logical_page_type;i_virtual_page : ph_page_type;
	lo_rows : integer;str_descr_record : string;bo_forza_assegnazione_descrizione : boolean = FALSE);
begin
	if NOT silent_mode AND ww_exists then
		ww.set_avanzamento(fs, i_logical_page, i_virtual_page, lo_rows, str_descr_record, bo_forza_assegnazione_descrizione)
end;

// ---------------------------------------------

constructor Tdlg_working.create_preparing(father : TForm;bo_report : boolean;var bo_stop : boolean);
begin
	init(FALSE, bo_report, father, bo_stop);
	inherited create(father);
	if father.Visible then parent := father;	// altrimenti rimane tutto invisibile, il che non è proprio il massimo
	if (MBOX_CAPTION = '') then caption := PROGRAM_NAME + ' - caricamento formato di stampa'
	else begin
		caption := PROGRAM_NAME + ifs(PROGRAM_NAME <> MBOX_CAPTION, ' - ' + MBOX_CAPTION)
//		if (PROGRAM_NAME = str_MBOX_CAPTION) then caption := PROGRAM_NAME
//		else caption := PROGRAM_NAME + ' - ' + str_MBOX_CAPTION
	end
end;

constructor Tdlg_working.create_printing(father : TForm;bo_report : boolean;i_2print : integer;var bo_stop : boolean);
begin
	init(TRUE, bo_report, father, bo_stop);
	self.i_2print := i_2print;
	inherited create(father);
	i_printed := -1;printed_another_one
//	caption := str_MBOX_CAPTION + 'preparazione stampa '
end;

procedure Tdlg_working.FormCreate(Sender : TObject);
var i_monitor : smallint;
begin
//	old_main_form := globale.set_main_form(self, NIL);
	txt_printer.Caption := lowercase(printer.printers[printer.printerindex]);
	if (globale = NIL) then i_monitor := get_active_monitor(self) else i_monitor := globale.i_active_monitor;
	SendWindowToMonitor(self, i_monitor, MFTM_CENTER);
	set_avanzamento(FST_READING_REPORT, -1, -1, 0, '')
end;

procedure Tdlg_working.init(bo_printing,bo_report : boolean;father : TForm;var bo_stop : boolean);
begin
	self.bo_printing := bo_printing;
//	pt_bo_stop := @bo_stop;pt_bo_stop^ := FALSE;
	pt_bo_stop := @bo_stop;bo_stop := FALSE;
	bo_can_close := FALSE;
	self.bo_report := bo_report;
//	parent := father
end;

procedure Tdlg_working.btn_stopClick(Sender : TObject);
begin
	if (MessageBBox(handle, 'Vuoi interrompere la stampa?', MBOX_CAPTION, MB_QUESTION) <> IDYES) then exit;
	pt_bo_stop^ := TRUE;
	btn_stop.Caption := 'attendi';btn_stop.Enabled := FALSE
end;

procedure Tdlg_working.chiudi_finestra;
begin bo_can_close := TRUE;close end;

procedure Tdlg_working.FormCloseQuery(Sender: TObject;var CanClose: Boolean);
begin canclose := bo_can_close end;

procedure Tdlg_working.printed_another_one(bo_sending_email : boolean = FALSE);
begin
	inc(i_printed);
	if bo_report then
		if (i_printed+1 <= i_2print) then txt1.Caption := 'pagina ' + inttostr(i_printed+1) + ' di ' + inttostr(i_2print)
		else txt1.Caption := ifs(bo_sending_email,'preparazione e-mail','fase di chiusura stampa')
	else txt1.Caption := 'ho stampato ' + inttostr(i_printed) + ' etichette';
	txt1.update
end;

procedure Tdlg_working.FormDestroy(Sender : TObject);
begin
	ww := NIL;
//	globale.set_main_form(old_main_form)
end;

procedure Tdlg_working.set_caption(str_caption : string);
begin
	{$ifdef DEBUG} str_caption := 'DBG-' + str_caption; {$endif}
	caption := str_caption
end;

procedure Tdlg_working.set_text(i_text : byte;str_text : string);
// imposta i testi delle labels
var txt : TLabel;
begin
	case i_text of
		1 : txt := txt1;
		2 : txt := txt2
		else begin
			{$ifdef DEBUG} assert(FALSE,'errore nel numero Tdlg_working.set_texts() LAX 818'); {$endif}
			exit
		end
	end;
	with txt do begin caption := str_text;update end
end;

procedure Tdlg_working.set_avanzamento(fs : FASI_STAMPA_TYPE;
	i_logical_page : logical_page_type;i_virtual_page : ph_page_type;lo_rows : integer;
	str_descr_record : string;bo_forza_assegnazione_descrizione : boolean = FALSE);
// utilizzare le macro WORKING_xxxx
var s : string;
begin
	if bo_forza_assegnazione_descrizione {OR (fs = FST_FORMATTING)} OR ((globale <> NIL) AND (fs <> globale.fase_stampa)) then begin
//		{$ifdef DEBUG} assert(self.fase_stampa <= fase_stampa,'FASE STAMPA INCORRECT KJZ 199'); {$endif}
		globale.fase_stampa := fs;
		if {(i_logical_page <> -1)} (i_logical_page > 0) AND (get_ultima_pagina_logica <> 1) then s := page_caption(i_logical_page,TRUE) + ': ';
		case fs of
			FST_READING_REPORT : set_text(1,s + 'preparazione stampa');
			FST_READING_DATA: set_text(1,s + 'lettura dati');
			FST_FORMATTING : set_text(1,s + 'formattazione');
			FST_ZERO : set_text(1,s + '')	// fase di chiusura
		end
	end;

	case fs of
		FST_READING_REPORT : ;
		FST_READING_DATA : begin
//			{$ifdef DEBUG} assert(lo_rows > 0,'WWR 902'); {$endif}
			self.lo_rows := lo_rows;
			if (lo_rows = 0) AND (str_descr_record = '') then s := ''
			else s := coalesce(str_descr_record,'record') + ' ' + inttostr(lo_rows);
			set_text(2, s)
		end;
		FST_FORMATTING : begin
			{$ifdef DEBUG} assert(i_logical_page <> -1,'WWR 903'); {$endif}
{			if (get_ultima_pagina_logica <> 1) then s := page_caption(i_logical_page) + ', ';
			s := s + 'pagina ' + inttostr(i_phisical_page);
			set_text(2,s)}
			if (globale.tiporeport = TR_REPORT) then s := 'pagina ' + inttostr(i_virtual_page) + ifs(str_descr_record,'   ' + str_descr_record)
			else s := 'etichetta ' + inttostr(i_virtual_page) + ' [pagina ' + inttostr(get_pagina_fisica_of_pagina_virtuale(i_virtual_page)) + ']';
			set_text(2, s)
		end
	end
end;

procedure Tdlg_working.another_record(str_descr_record : string);
begin
	my_PeekMessage;
	set_avanzamento(FST_READING_DATA, get_pagina_logica_attiva_1B, -1, lo_rows+1, str_descr_record)
end;

function Tdlg_working.stopped : boolean;
begin
	my_PeekMessage;stopped := pt_bo_stop^
end;

procedure Tdlg_working.FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
begin
	case key of
		VK_ESCAPE,VK_RETURN : btn_stop.Click
	end
end;

initialization
	galateo_initialization_debug('working')
finalization
	galateo_finalization_debug('working');
	{$ifdef DEBUG} assert(ww = NIL,'dlg_working non an-NIL-lato') {$endif}
end.
