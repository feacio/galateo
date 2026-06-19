unit print_report;	//*

{ $ifdef DEBUG} { $define DEBUG} { $endif}

{ il prospetto di stampa è composta da una serie di pagine logiche;
  queste pagine vengono trasposte in corrispondenti pagine logiche di stampa, con alcune
  importanti differenze:
		una pagina logica originale può essere mappata su più pagine logiche di stampa,
			come nel caso in cui una singola pagina occupi più di una pagina;
		una pagina logica originale può non avere una corrispondente pagina logica di
			stampa, poichè non contiene alcun record e non è stata attivata l'opzione
			'stampa anche se la pagina è vuota';
		la pagina di stampa corrispondente alla pagina logica orivginale conserva lo
			stesso indice nel vettore delle pagine; non è detto che esista, ma se esiste
			vale la regola or ora enunciata; se non esiste, la variabile i-esima del
			vettore PRINT_PAGES vale NIL

  lo stato della stampa viene riportato sulla variabile PAGES.PRINT_STATUS[]
}

{$I defines}
{$ifNdef CASA} DLL ONLY !!! {$endif}

interface

uses SysUtils, Windows, Classes, Messages, Math, Actions, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, ActnList, Menus,
	Firedac.Stan.Def, Firedac.Stan.Async, FireDAC.Phys.ASADef, FireDAC.Phys.ODBCDef, FireDAC.Phys.MSSQLDef, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef,
	FireDAC.Phys.MySQLDef, FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc, FireDAC.Phys.MySQL, FireDAC.Phys.SQLite, FireDAC.Phys.MSSQL, FireDAC.Phys.ODBC, FireDAC.Phys,
	FireDAC.Stan.Intf, FireDAC.Phys.ODBCBase, FireDAC.Phys.ASA, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Comp.UI,
	JvExControls, JvSpeedButton,
	PDF, WPPDFR1, WPPDFR2,
	{$ifNdef EXCLUDE_DRAGDROP} DragDrop, DropSource, DragDropFile, {$endif}
//	DragDrop, DropSource, DragDropFile,DragDrop, DropSource, DragDropFile,
	Fcommons, FDebug, Federico, FBitBtn, FSQLsoft, FDB,
	Gdich, validate, pages, print_types, printer_select, expint_exec, text_scripts;

procedure print_report_proc(father : TForm;lo_print_style : integer);

var
	// nel caso di stampe multiple, indica il numero della stampa nella sequenza; inizialmente vale 0
	i_numero_stampa_multipla : smallint;
	PDF: TWPPDFPrinter = NIL;

type
//	scroll_button_type = TFSpeedButton;
//	scroll_button_type = TSpeedButton;
//	scroll_button_type = TJvSpeedButton;
	scroll_button_type = TFSpeedButton;
//croll_button_type = TXFSpeedButton;
  Tdlg_print_report = class(TForm)
	 btn_panel: TFPanel;
	 panel_footer_buttons: TFPanel;
	 txt_page: TLabel;
	 txt_pages: TLabel;
	 i_show_num_pages: TEdit;
	 btn_print: TFBitBtn;
	 btn_zoom: TFBitBtn;
	 i_pagina: TEdit;
	 btn_left: TFBitBtn;
	 btn_right: TFBitBtn;
	 timer: TTimer;
    panel_preview: TFPanel;
	 sbox: TScrollBox;
	 Shp: TShape;
	 pbox_ext: TPaintBox;
	 image: TImage;
	 index_panel: TFPanel;
	 split_index: TSplitter;
	 index : TTreeView;
	 btn_PDF: TFBitBtn;
	 btn_mail: TFBitBtn;
    sb_index: TSpeedButton;
	 PDF: TWPPDFPrinter;
	 email_enfatizzata: TImage;
	 popup_index: TPopupMenu;
    itp_print_pagina_logica: TMenuItem;
    btn_reload: TFBitBtn;
	 itp_export_pagina_logica: TMenuItem;
	 cbx_print_diretta: TFCheckBox;
	 btn_close: TFBitBtn;
	 popup_print_diretta: TPopupMenu;
	 itp_print_diretta: TMenuItem;
	 itp_print_diretta_DIRETTA: TMenuItem;
	 itp_print_diretta_DIALOG: TMenuItem;
	 itp_print_diretta_default: TMenuItem;
	 itp_separatore_00: TMenuItem;
	 btn_export: TFBitBtn;
	 AL: TActionList;
	 AL_close: TAction;
	 tb_panel: TFPanel;
	 tb: TTrackBar;
    AL_reload_data: TAction;
    btn_files_creati: TJvSpeedButton;
	 popup_files: TPopupMenu;
	 itl_file_delete: TMenuItem;
	 itp_file_open: TMenuItem;
    itl_file_open_folder: TMenuItem;
	 itp_file_copy_folder: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
	 AL_file_open: TAction;
	 AL_file_delete: TAction;
	 AL_file_open_folder: TAction;
	 AL_file_copy_folder: TAction;
	 AL_file_email: TAction;
	 itp_file_email: TMenuItem;
	 AL_export: TAction;
    AL_open_galateo: TAction;
    AL_print_mail: TAction;
	 AL_print_PDF: TAction;
    panel_footer_message: TFPanel;
    panel_footer_help: TFPanel;
    btn_info_utente: TFBitBtn;
	 btn_dragdrop: TFBitBtn;
    AL_print_printer: TAction;
	 procedure FormCreate(Sender : TObject);
	 procedure FormResize(Sender : TObject);
	 procedure pbox_extPaint(Sender : TObject);
	 procedure FormDestroy(Sender : TObject);
	 procedure FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
	 procedure btn_zoomClick(Sender : TObject);
	 procedure tb_panelResize(Sender : TObject);
	 procedure tbChange(Sender : TObject);
	 procedure i_paginaChange(Sender : TObject);
	 procedure btn_leftClick(Sender : TObject);
	 procedure btn_rightClick(Sender : TObject);
	 procedure i_paginaKeyPress(Sender: TObject; var Key: Char);
	 procedure FormActivate(Sender : TObject);
	 procedure timerTimer(Sender : TObject);
	 procedure indexChange(Sender: TObject; Node: TTreeNode);
	 procedure imageClick(Sender : TObject);
	 procedure pbox_extClick(Sender : TObject);
	 procedure indexClick(Sender : TObject);
	 procedure sb_indexClick(Sender : TObject);
	 procedure itp_print_pagina_logicaClick(Sender : TObject);
	 procedure itp_export_pagina_logicaClick(Sender : TObject);
	 procedure itp_print_diretta_defaultClick(Sender : TObject);
	 procedure itp_print_diretta_DIRETTAClick(Sender : TObject);
	 procedure itp_print_diretta_DIALOGClick(Sender : TObject);
	 procedure cbx_print_direttaClick(Sender : TObject);
	 procedure FormCloseQuery(Sender : TObject;var CanClose : Boolean);
	 procedure AL_closeExecute(Sender : TObject);
	 procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure AL_reload_dataExecute(Sender : TObject);
	 procedure indexDeletion(Sender: TObject; Node: TTreeNode);
	 procedure btn_info_utenteClick(Sender : TObject);
	 procedure AL_file_openExecute(Sender : TObject);
    procedure AL_file_deleteExecute(Sender : TObject);
	 procedure AL_file_open_folderExecute(Sender : TObject);
	 procedure AL_file_copy_folderExecute(Sender : TObject);
	 procedure AL_file_emailExecute(Sender : TObject);
	 procedure AL_exportExecute(Sender : TObject);
	 procedure AL_open_galateoExecute(Sender : TObject);
	 procedure AL_print_mailExecute(Sender : TObject);
	 procedure AL_print_PDFExecute(Sender : TObject);
    procedure panel_footer_messageClick(Sender : TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure AL_print_printerExecute(Sender: TObject);
	 procedure btn_dragdropClick(Sender: TObject);
	 procedure btn_dragdropMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
	 {$ifNdef EXCLUDE_DRAGDROP} procedure drop_sourceDrop(Sender: TObject; DragType: TDragType; var ContinueDrop: Boolean); {$endif}
  private
		bo_dont_open : boolean;
		bo_activated : boolean;
		bo_dont_close_after : boolean;
		bo_window_enabled : boolean;
		i_fattore_zoom_simbolico : smallint;
		r_fattore_zoom : real;
		i_phisical_width_10mm, i_phisical_height_10mm : integer;
		lo_print_style : integer;
		i_job : smallint;
		bo_setting_index : boolean;
		blink_timer : TTimer;
		bo_creazione_report_interrotta : boolean;
		bo_default_send_email, bo_first_print : boolean;
		target : report_target_type;
		PDF_opt : cl_PDF;		// opzioni PDF, variabile di comodo per la gestione
		exec_export_options : cl_exec_expint_options;		// opzioni di esportazione del report (valide per export integrale e XML)
		bo_printing_error_found : boolean;				// flag che registra la presenza di un errore durante il processo di stampa
		procedure close_connessione_SQL;
		procedure create_index;
//		procedure free_index;
		procedure show_index(bo_show : boolean);
		procedure check_timer_after_create;
		procedure draw;
		function exec_print(pt_lo_print_style : integer_punt;bo_comando_esplicito : boolean;str_pagine_logiche : string = '') : boolean;
		procedure free_print_pages;
		procedure goto_phisical_page(i_pagina_fisica : ph_page_type);
		procedure goto_selected_record;
		function get_index_item_selected : TTreeNode;
		procedure select_index_of_page;
		procedure impagina(bo_first_time : boolean;bo_reload_data : boolean = FALSE;bo_execute_scripts : boolean = TRUE);
		procedure imposta_misure_pagina;
		procedure left_right(bo_left : boolean);
		procedure set_fattore_zoom_simbolico(i_fattore_zoom_simbolico : smallint;i_delta : smallint = 0);
		procedure set_caption(bo_first_time : boolean);
		function reload_data(bo_from_closequery : boolean = FALSE) : boolean;
		function exec_SQL_scripts(tipo : SQL_script_type) : boolean;
	private
		i_active_logical_page_1B : logical_page_type;			// pagina attiva logica/fisica; ricoprono per semplicità le variabili esterne
		i_old_active_logical_page_1B : logical_page_type;
		i_active_phisical_page : ph_page_type;	// numero di pagina fisica attiva; è veramente la pagina fisica, che può contenere tante pagine virtuali
		i_total_phisical_pages : ph_page_type;		// numero totale di pagine fisiche
		i_total_virtual_pages : ph_page_type;		// numero di pagine virtuali; se REPORT == pagine fisiche; se label >> numero di etichette
//		function get_logical_page(i_phisical_page : ph_page_type) : logical_page_type;	// meglio lasciarla locale
		function get_handle : HWND;
		function IO_setup_print_diretta(bo_read : boolean;pds : print_diretta_type = PDS_REPORT) : print_diretta_type;
		procedure set_print_diretta_menu(pds : print_diretta_type);
	private
		function write_registro_eventi(message_type : eventlog_type;str_message : string;lo_event_ID : integer = 0) : boolean;
		function messagebbox(x : pointer;handle : hwnd;str_message, str_caption : string;TextType : DWORD = MB_ICONINFORMATION) : Word;
		function error_msg(father : TForm;x : pointer;str_msg, mbox_caption : string;bo_ignore_abort_msg : boolean = TRUE;
			mb_icon : integer = MB_ICONSTOP;str_filename : string = '';dw_event_id : DWORD = 0) : integer;
	private
		bo_building_scroll_buttons : boolean;
		scroll_buttons : array of scroll_button_type;
		procedure make_page_scroll_objects;
		procedure resize_scroll_buttons;
		procedure scroll_button_click(Sender : TObject);
	private
		it_last_created_filenames : TStrings;
		str_file_caption_base : string;
		str_last_actual_target_filename : string;		// ultimo nome effettivamente utilizzato, compreso di path
		function get_path_files_exportati : string;
		function get_elenco_files_generati(bo_delete_path : boolean = TRUE;i_numero_max : smallint = 0;str_delimitatore : string = '';
			str_elenco_files : string = '') : string;
		procedure enable_file_menuitems;
		function send_email(str_email_address : string;str_target_filename : string;bo_interactive : boolean) : boolean;
	private
		procedure check_blinking;
		procedure blink_timer_proc(Sender : TObject);
	private
		valid : cl_validation;
		active_contexts : validazione_context_set;		// contesti da controllare (ciascuno dei contesti attiva il controllo)
		function verifica_validazione(contexts : validazione_context_set) : boolean;
		function validation_callback_proc(ptr : pointer;var bo_errore : boolean) : boolean;
	private
		father : TForm;
		procedure zoom;
//		procedure set_ctrls_size;
		constructor xcreate(father : TForm;var lo_print_style : integer);
//		procedure wm_syscomm(var m:TMessage); message WM_SYSCOMMAND;
  end;

implementation

{$R *.DFM}

uses FAssert, FErrMsg, FXStrings, FStrings, FProcs, FRegistry, FSystem_base, FSystem, FSystem_ext, FMessage, FFile, FdataH, Fdata, Ftime,
	myprinter, export_DBF, sp_galateo, proc, input_dialog, galateo_debug, domanda_multipla, Fmail,
	{$ifndef DLL} galateo_main, {$endif}
	SMTP_proc, SMTP_dialog, FRedemption, FTP_proc, printers_VCL, printers_DX, working, intervallo,
	misure, Gun, expint_base, functions, sezione, objects, labels, GAPP, runtime, runtime_proc;

const
	MBOX_CAPTION = 'GALATEO';
	BORDO_DISEGNO_X_PIXEL = 10;
	BORDO_DISEGNO_Y_PIXEL = 10;
	MIN_FATTORE_ZOOM_SIMBOLICO_STD = 1;
	MAX_FATTORE_ZOOM_SIMBOLICO_STD = 9;
	FATTORI_ZOOM_STANDARD = [MIN_FATTORE_ZOOM_SIMBOLICO_STD..MAX_FATTORE_ZOOM_SIMBOLICO_STD];
	FATTORI_ZOOM : array[MIN_FATTORE_ZOOM_SIMBOLICO_STD..MAX_FATTORE_ZOOM_SIMBOLICO_STD] of smallint = (20, 40, 60, 80, 100, 125, 150, 200, 300);
	FATTORI_ZOOM_DESCR : array[MIN_FATTORE_ZOOM_SIMBOLICO_STD..MAX_FATTORE_ZOOM_SIMBOLICO_STD+2] of string =
	  ('20% (immagine molto piccola)','40%','60%','80%','100%','125%','150%','200%','300% (immagine molto grande)',
		'ADATTA ORIZZ','ADATTA FINESTRA');
	ZOOM_ACTUAL_SIZE = 5;
	ZOOM_FIT_WIDTH = 10;
	ZOOM_FIT_HEIGHT = 11;

	SHIFT_BASE = 16;

{$ifdef DEBUG}
	var
		pt_sections_values : ^cl_print_section;	// debugging purposes, per controllare everywhere il contenuto dei dati in formattazione
		lo_index_info : integer;
{$endif}
type
	cl_index_info = class		// classe
		lo_id : integer;
		i_pagina_logica : logical_page_type;		// pagina logica cui il record appartiene
		i_pagina_fisica : ph_page_type;	// pagina fisica in cui il record inizia
		constructor create(lo_id : integer;i_pagina_logica : logical_page_type;i_pagina_fisica : ph_page_type);
		{$ifdef DEBUG} destructor free; {$endif}
	end;

procedure print_report_proc(father : TForm;lo_print_style : integer);
const MBOX_DEBUG_CAPTION = 'print_report_proc()';
begin
	debug(0, MBOX_DEBUG_CAPTION, 'start');
	var glob := globale;
//	static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: 100 :: ');
	GALATEO_init_WPDF_DLL;

	debug(10, MBOX_DEBUG_CAPTION, '');
{$ifdef GALATEO_EXE}
//	str_selected_printer := globale.xstr_printer;
	var str_selected_printer : string := glob.printer_default[0].str_printer;
	var str_phisical_active_printer : string := printer.printers[printer.PrinterIndex];
{$endif GALATEO_EXE}
	xprint_status[get_active_job] := xPS_PREPARING;

//	printer.orientation := poPortrait;printer.canvas.TextWidth('A');

	debug(20, MBOX_DEBUG_CAPTION, '');
	if (lo_print_style AND GAL_POPT_FORZA_IMPOSTAZIONI_PROGRAMMA_CHIAMANTE = 0) then begin		// il flag GAL_POPT_FORZA_IMPOSTAZIONI_PROGRAMMA_CHIAMANTE forza l'applicazione delle impostazioni del programma chiamante
		case glob.azione_opening_report_executive of
			AORT_POPT_DEFAULT : ;	// usa le impostazioni default (e nel caso quelle passate dal programma che impartisce l'ordine di stampa)
			AORT_FORZA_ANTEPRIMA : lo_print_style := GAL_POPT_PRINT_ANTEPRIMA;
			AORT_PRINT_PRINTER : lo_print_style := GAL_POPT_PRINT_PRINTER;
			AORT_PRINT_PRINTER_DIRECT : lo_print_style := GAL_POPT_DIRECTLY_EXECUTE;
			AORT_PDF : lo_print_style := GAL_POPT_PDF;
			AORT_EMAIL : lo_print_style := GAL_POPT_EMAIL;
			AORT_PDF_DIRECT : lo_print_style := GAL_POPT_PDF OR GAL_POPT_DIRECTLY_EXECUTE;
			AORT_EMAIL_DIRECT : lo_print_style := GAL_POPT_EMAIL OR GAL_POPT_DIRECTLY_EXECUTE;
			{$ifdef DEBUG} else assert(FALSE, 'DKHW 9318') {$endif}
		end
	end
	else lo_print_style := lo_print_style - GAL_POPT_FORZA_IMPOSTAZIONI_PROGRAMMA_CHIAMANTE;

//	static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: 200 :: ');
	debug(100, MBOX_DEBUG_CAPTION, 'before create');
	var dlg := Tdlg_print_report.xcreate(father, lo_print_style);
	debug(110, MBOX_DEBUG_CAPTION, 'after create');
	{if (lo_print_style in [0,GAL_POPT_PRINT_ANTEPRIMA]) then }dlg.ShowModal;
	dlg.free;	// NON usare RELEASE !!!!
	debug(120, MBOX_DEBUG_CAPTION, 'after free');
{$ifdef GALATEO_EXE}
//	if (str_phisical_active_printer <> printer.printers[printer.printerindex]) OR (glob.printer_default[0].str_printer <> str_selected_printer)
	if (uppercase(str_phisical_active_printer) <> uppercase(printer.printers[printer.PrinterIndex])) OR
		(uppercase(glob.printer_default[0].str_printer) <> uppercase(str_selected_printer))
	then begin
		glob.select_printer(str_phisical_active_printer);
		glob.printer_default[0].str_printer := str_selected_printer;
		glob.autosize_printer_page
	end
{$endif GALATEO_EXE}
end;

constructor Tdlg_print_report.xcreate(father : TForm;var lo_print_style : integer);
// LO_PRINT_STYLE può essere modificato all'interno della window
const MBOX_DEBUG_CAPTION = 'Tdlg_print_report.xcreate()';
begin
	debug(0, MBOX_DEBUG_CAPTION, 'start');
//	for var i : smallint := 1 to MAX_PAGINE_LOGICHE do print_pages[i] := NIL;
	i_job := get_active_job;
	i_old_active_logical_page_1B := get_pagina_logica_attiva_1B;
	self.lo_print_style := lo_print_style;
	var g : TGlobale := globale;
//	static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: 100 :: ');
	debug(10, MBOX_DEBUG_CAPTION, 'before init_db_report()');
	var bo := g.init_db_report(g.phisical_report_database);
	debug(20, MBOX_DEBUG_CAPTION, 'after init_db_report() result=' + bo.SQL);
	if NOT bo then begin
//		static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: 110 :: ');
		raise exception.create('Errore durante la connessione')
	end;
//	static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: 200 :: ');
	self.father := father;
	PDF_opt := cl_PDF.create(g.PDF);
	valid := validation_create(g.str_filename);
//	static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: 3100 :: ');
	debug(30, MBOX_DEBUG_CAPTION, 'before create');
	inherited create(father);
	debug(40, MBOX_DEBUG_CAPTION, 'after create');
//	static_immediate_debug(MBOX_DEBUG_CAPTION + ' :: 400 :: ');
	if bo_dont_open then abort
//	if (lo_print_style in [GAL_POPT_PRINT_PRINTER,GAL_POPT_DIRECTLY_EXECUTE]) then exec_print(@lo_print_style)
end;

procedure Tdlg_print_report.FormCreate(Sender : TObject);
var s : string;	//**
begin
//	if father.Visible then parent := father;	// altrimenti non è una idea particolarmente brillante
	bo_dont_open := TRUE;bo_first_print := TRUE;

	panel_footer_message.Caption := ifs(globale.bo_debug_full, 'FULL-DEBUG', ifs(globale.bo_debug_base, 'DEBUG'));
	if (panel_footer_message.Caption <> '') then begin
		panel_footer_message.Cursor := crHandPoint;
		panel_footer_message.Color := clYellow
	end;

{$ifdef EXCLUDE_DRAGDROP}
	btn_dragdrop.Visible := FALSE;
{$else}
	drop_source := TDropFileSource.create;	****
	drop_source.DragTypes := [dtCopy];
	drop_source.OnDrop := drop_sourceDrop;
	drop_source.ShowImage := TRUE;
{$endif EXCLUDE_DRAGDROP}

	write_registro_eventi(ELT_INFORMATION, 'report [' + globale.str_filename + ']');
	set_caption(TRUE);
	globale.debug_message(father);		// emetto un eventuale messaggio di segnalazione del debug in corso
	pbox_ext.Align := alClient;
	it_last_created_filenames := TStringList.Create;
	btn_left.Height := panel_footer_buttons.Height;btn_left.Top := 0;
	btn_right.Height := panel_footer_buttons.Height;btn_right.Top := 0;
	r_fattore_zoom := 1;	// inizialmente
	i_fattore_zoom_simbolico := ZOOM_ACTUAL_SIZE;
	index_panel.Width := screen.Width div 8;
	show_index(globale.bo_show_index);
	sb_index.Visible := globale.bo_create_index;
	sb_index.down := globale.bo_show_index;
//	AL_export_integrale.Hint := shortcutToText(AL_export_integrale.ShortCut) + ' ' + AL_export_integrale.Hint;
//	AL_export_XML.Hint := shortcutToText(AL_export_XML.ShortCut) + ' ' + AL_export_XML.Hint;
	AL_export.Enabled := globale.bo_export_allowed AND (globale.expint_profiles <> NIL);

	btn_PDF.Caption := '';btn_reload.Caption := '';btn_export.Caption := '';btn_mail.Caption := '';
	str_file_caption_base := AL_file_open.Caption;

	btn_info_utente.Visible := (globale.str_documento_informativo_utente + globale.str_links_utente {$ifdef DLL} + globale.str_links_runtime{$endif} <> '');
	if btn_info_utente.Visible then
		btn_info_utente.Hint := 'apre il documento informativo sul report' + ACAPO +
			uppercase(extractFilename(globale.str_documento_informativo_utente) + ACAPO + globale.str_links_utente
			{$ifdef DLL} + ACAPO + globale.str_links_runtime {$endif});

	exec_export_options := cl_exec_expint_options.Create;
////	exec_export_options.bo_export_integrale := globale.bo_export_allowed AND globale.bo_export_set_default;
//	exec_export_options.target := globale.get_active_expint.expint_target_default;
//	exec_export_options.EFAT_action := globale.get_active_expint.EFAT_default_action;
//	exec_export_options.str_comando_specifico := globale.get_active_expint.str_expint_comando_specifico_default;

	case globale.azione_after_print of
		AAPT_NOTHING, AAPT_ASK_AGAIN_DEFAULT_NOT : bo_dont_close_after := FALSE;
		AAPT_ASK_AGAIN_DEFAULT_YES : bo_dont_close_after := TRUE;
		AAPT_ASK_AGAIN_DEFAULT_LAST_TIME :
			get_registry_boolean(HKEY_CURRENT_USER, GALATEO_REGISTRY_BASE, REGISTRY_DONT_CLOSE_AFTER, bo_dont_close_after, {default}FALSE);
		{$ifdef DEBUG} else assert(FALSE, 'DKWI 9283') {$endif}
	end;

	if (lo_print_style AND GAL_POPT_EFAT_NOTHING <> 0) then exec_export_options.EFAT_action := EFAT_NOTHING else
	if (lo_print_style AND GAL_POPT_EFAT_FOLDER <> 0) then exec_export_options.EFAT_action := EFAT_FOLDER else
	if (lo_print_style AND GAL_POPT_EFAT_CREATE_OPEN <> 0) then exec_export_options.EFAT_action := EFAT_CREATE_OPEN;

	var pd := IO_setup_print_diretta({read}TRUE);
	set_print_diretta_menu(pd);
	if (pd = PDS_REPORT) then pd := globale.print_diretta;
	cbx_print_diretta.Checked := (pd = PDS_DIRETTA);

	if NOT bo_PDF_allowed then begin
		AL_print_PDF.Enabled := FALSE;
		btn_mail.Enabled := FALSE
	end;

	if globale.bo_export_allowed AND globale.bo_export_set_default then target := RTA_EXPORT else target := RTA_PRINTER;

	// blocco introdotto 2013-04-28
	if (lo_print_style AND GAL_POPT_PRINT_PRINTER <> 0) then target := RTA_PRINTER else
	if (lo_print_style AND GAL_POPT_PDF <> 0) then target := RTA_PDF else
	if (lo_print_style AND GAL_POPT_EMAIL <> 0) then target := RTA_PDF;
//	if (lo_print_style AND   <> 0) then begin target := RTA_EXPORT_INTEGRALE;exit end;

	shp.Top := SHIFT_BASE;shp.Left := SHIFT_BASE;
	GAPP_init;
	imposta_misure_pagina;
	SendWindowToMonitor(self, globale.i_active_monitor, MFTM_DONT_MOVE);
	WindowState := wsMaximized;
//	set_ctrls_size;

	try
		set_wait_cursor(TRUE);
		try
			impagina(TRUE);
			AL_reload_data.Enabled := globale.bo_exists_runtime_parms;
			AL_reload_data.Caption := '';
			imposta_misure_pagina;
			check_blinking;
			draw;
			bo_default_send_email := globale.bo_auto_email;
			if bo_default_send_email AND (globale.str_condizione_auto_email <> '') AND
				NOT interpreta_boolean_expression(globale.str_condizione_auto_email, FALSE, bo_default_send_email, s)
			then begin
				bo_default_send_email := FALSE;
				MessageBBox(NIL, handle, 'Errore durante la valutazione della condizione' + ACAPO2 + globale.str_condizione_auto_email,
					'Invio automatico via e-mail', MB_ICONSTOP)
			end;
//			if bo_default_send_email then btn_mail.Glyph := email_enfatizzata.Picture.Bitmap;
			if bo_default_send_email then btn_mail.Glyph.Assign(email_enfatizzata.Picture.Bitmap);
			enable_file_menuitems;
			bo_dont_open := FALSE
		except
			bo_creazione_report_interrotta := TRUE;	// comunque, per segnalare che la stampa non è stata creata
			raise
		end
	finally
		set_wait_cursor(FALSE)
	end;
	xprint_status[i_job] := PS_PREVIEW;
	make_page_scroll_objects
end;

procedure Tdlg_print_report.FormActivate(Sender : TObject);
begin
	AL.State := asNormal;
	if NOT bo_activated then begin
		bo_activated := TRUE;

{		if globale.bo_export_proponi OR (lo_print_style AND (GAL_POPT_PRINT_PRINTER + GAL_POPT_DIRECTLY_EXECUTE) <> 0) then begin
			if (globale.str_expint_msg_before <> '') then MessageBBox(handle, globale.str_expint_msg_before, MBOX_CAPTION);
			timer.Enabled := TRUE;
			visible := FALSE
		end }
//		if globale.bo_export_proponi AND (globale.get_active_expint.str_expint_msg_before <> '') then MessageBBox(handle, globale.get_active_expint.str_expint_msg_before, MBOX_CAPTION);
		if (globale.str_message_opening_print <> '') then MessageBBox(NIL, handle, globale.str_message_opening_print, MBOX_CAPTION);

		check_timer_after_create
	end
end;

procedure Tdlg_print_report.FormDeactivate(Sender: TObject); begin AL.State := asSuspended end;

procedure Tdlg_print_report.FormDestroy(Sender : TObject);
const MBOX_DEBUG_CAPTION = 'Tdlg_print_report.FormDestroy()';
begin
	runtime_debug('start', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
	try
		if (it_last_created_filenames <> NIL) then begin it_last_created_filenames.free;it_last_created_filenames := NIL end;
		if (blink_timer <> NIL) then begin blink_timer.free;blink_timer := NIL end;
		if NOT bo_creazione_report_interrotta then SQL_save_progressivi_pagina(self);
		runtime_debug('100', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		GAPP_close;
//		free_index;
		runtime_debug('110', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		free_print_pages;
		runtime_debug('120', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		set_pagina_logica_attiva_1B(i_old_active_logical_page_1B, TRUE);
		set_virtual_printing_page(0);
		runtime_debug('130', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		if (exec_export_options <> NIL) then begin exec_export_options.free;exec_export_options := NIL end;
		runtime_debug('140', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		if (globale.phisical_report_database <> NIL) then begin
			// stacco l'SQL il più tardi possibile per evitare che le eventuali TEMPORARY TABLES vengano cancellate
			runtime_debug('150', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
			close_connessione_SQL;
			runtime_debug('151', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
			globale.phisical_report_database.free;
			runtime_debug('152', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
			globale.phisical_report_database := NIL
		end;
		runtime_debug('160', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		validation_free(valid);
		runtime_debug('170', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		if (PDF_opt <> NIL) then begin PDF_opt.free;PDF_opt := NIL end;
		runtime_debug('900', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01)
	except
		MessageBBox(NIL, father.handle, 'Errore durante la chiusura della stampa', MBOX_CAPTION, MB_ICONSTOP)
	end;
	runtime_debug('end of', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01)
end;

procedure Tdlg_print_report.FormCloseQuery(Sender : TObject;var CanClose : Boolean);
begin
	if bo_dont_close_after then canclose := NOT reload_data({from_closequery}TRUE)
	else canclose := TRUE
end;

procedure Tdlg_print_report.imposta_misure_pagina;
var i_marg_sx_pix, i_marg_sup_pix, i_larg_pix, i_alt_pix : int_pixel_type;
begin
	var i_page_1B : logical_page_type := get_pagina_logica_attiva_1B;
	with sections_ZB(MAIN_SECTION_ZB) do begin
		check_blinking;
		i_marg_sx_pix := cm2pixel_video_x(get_page_marg_SX_cm_1B(i_page_1B) * r_fattore_zoom);
		i_marg_sup_pix := cm2pixel_video_y(get_page_marg_UP_cm_1B(i_page_1B) * r_fattore_zoom);

{		if (globale.i_forced_width_10mm = 0) then i_phisical_width_10mm := getdevicecaps(printer.handle,HORZSIZE)
		else i_phisical_width_10mm := globale.i_forced_width_10mm div 10; }
		if (globale.i_forced_width_10mm = 0) then i_phisical_width_10mm := tm.i_phisical_10mm_width
		else i_phisical_width_10mm := globale.i_forced_width_10mm;
		i_larg_pix := cm2pixel_video_x(i_phisical_width_10mm / 100 * r_fattore_zoom);

{		if (globale.i_forced_height_10mm = 0) then i_phisical_height_10mm := getdevicecaps(printer.handle,VERTSIZE)
		else i_phisical_height_10mm := globale.i_forced_height_10mm div 10; }
		if (globale.i_forced_height_10mm = 0) then i_phisical_height_10mm := tm.i_phisical_10mm_height
		else i_phisical_height_10mm := globale.i_forced_height_10mm;
		i_alt_pix := cm2pixel_video_y(i_phisical_height_10mm / 100 * r_fattore_zoom);

{		i_larg_pix := cm2pixel_video_x(getdevicecaps(printer.handle,HORZSIZE)/10 * r_fattore_zoom);
		i_alt_pix := cm2pixel_video_y(getdevicecaps(printer.handle,VERTSIZE)/10 * r_fattore_zoom); }
		shift_orizzontal_sizes(i_larg_pix, i_alt_pix, i_page_1B);	// scambio horz e vert
		shift_orizzontal_sizes(i_phisical_width_10mm, i_phisical_height_10mm, i_page_1B);	// scambio horz e vert

		shp.Height := i_alt_pix;shp.Width := i_larg_pix;
		image.Top := SHIFT_BASE + i_marg_sup_pix - sbox.vertscrollbar.position;
		image.Left := SHIFT_BASE + i_marg_sx_pix - sbox.horzscrollbar.position;
		image.Width := round(i_PHpage_size_X_pix_video(i_page_1B) * r_fattore_zoom);
		image.Height := round(i_PHpage_size_Y_pix_video(i_page_1B) * r_fattore_zoom);
{		panel.Top := i_marg_sup_pix - sbox.vertscrollbar.position;
		panel.Left := i_marg_sx_pix - sbox.horzscrollbar.position;
		panel.Width := round(ai_page_size_X_pix_video(i_page_1B) * r_fattore_zoom);
		panel.Height := round(ai_page_size_Y_pix_video(i_page_1B) * r_fattore_zoom); }
		sbox.vertscrollbar.range := MAX(image.Top + image.Height,shp.Height) + 10 + SHIFT_BASE;
		sbox.horzscrollbar.range := MAX(image.Left + image.Width,shp.Width) + 10 + SHIFT_BASE
	end
end;

procedure Tdlg_print_report.free_print_pages;
begin
	for var i : logical_page_type := 1 to MAX_PAGINE_LOGICHE do begin
		while (print_pages_1B[i] <> NIL) do begin
			var pp := print_pages_1B[i];print_pages_1B[i] := print_pages_1B[i].next;
			pp.free
		end
	end;
	globale.free_stored_values
end;

procedure Tdlg_print_report.set_caption(bo_first_time : boolean);
begin
	var s := uppercase(globale.str_filename);
	if (pos(DEFAULT_EXT,s) <> 0) then s := copy(s,1,length(s)-length(DEFAULT_EXT));
	var str_printer : string := printer.printers[printer.printerindex];
	s := s + ' su ' + str_printer;
	if NOT bo_first_time then s := s + ' (' + FATTORI_ZOOM_DESCR[i_fattore_zoom_simbolico] + ')';
{	if globale.str_printer = '' then s := s + printer.printers[printer.printerindex]
	else s := s + globale.str_printer; }
//	caption := '[' + {$ifdef DEBUG} 'DBG-' + {$endif} zeri(GALATEO_VERSION,4) + '] ' + lowercase(s);		*** fino 2016-08-24
	caption := '[' + {$ifdef DEBUG} 'DBG-' + {$endif} version_of(GALATEO_VERSION) + '] ' + lowercase(s);

	cbx_print_diretta.Hint := 'stampa direttamente su  ' + str_printer;
	// in caso di stampante di rete, cerco di accorciare la stringa per renderla leggibile anche in poco spazio
	if start_with(str_printer, '\\') then begin
		delete(str_printer, 1, 2);
		var i : smallint := pos('\', str_printer);
		if (i <> 0) then str_printer := copy(str_printer, i+1, maxint)
	end;

	cbx_print_diretta.Caption := 'F8 ' + str_printer
end;

function Tdlg_print_report.exec_SQL_scripts(tipo : SQL_script_type) : boolean;

	function valuta_exec_script(sxt : SQL_script_type;i_script : smallint) : boolean;
	// rende TRUE se lo script deve essere eseguito, FALSE altrimenti; emette eventuali messaggi di errore
	const MBOX_CAPTION = 'STAMPA SE ...';
	var str_caption, str_msg : string;	//*
	begin
		try
//			if NOT bo_execute_scripts then begin result := FALSE;exit end;
			str_caption := get_runtime_script_description(sxt, i_script) + ' - condizione di esecuzione';
			var sx : text_script_record_punt := @globale.Text_scripts[sxt].recs[i_script];
			if (sx.str_condizione = '') then result := TRUE
			else begin
				if NOT interpreta_boolean_expression(sx.str_condizione, FALSE, result, str_msg) then abort;
				if NOT result then runtime_debug('*** SKIPPED SCRIPT ***', str_caption, RD_DEBUG_PRINCIPALE_00)
			end
		except
			runtime_debug(str_msg, str_caption, RD_DEBUG_PRINCIPALE_00);
			MessageBBox(NIL, handle, str_msg, str_caption, MB_ICONSTOP)
		end
	end;

	function exec_script(tipo : SQL_script_type;i_script : byte) : boolean;
	var s, str_temp, str_caption, str_databasename, mbox_caption : string;
	begin
		result := TRUE;
		var db_local : TFDatabase := NIL;var sx : text_script_record_punt := NIL;
		mbox_caption := 'Galateo: ' + globale.str_filename;
		try
			sx := @globale.Text_scripts[tipo].recs[i_script];
			str_caption := get_runtime_script_description(tipo, i_script);
//			s := togliblanks(TStrings2string(globale.tsql_scripts_pre[i_script],' '));
//			s := togli_ACAPO_finali(globale.str_scripts_pre[i_script]);
			s := togli_ACAPO_finali(sx.str_text);
			if sx.bo_disabled_locale OR sx.bo_disabled_remoto OR (s = '') OR NOT valuta_exec_script(tipo, i_script) then exit;		// nothing to do

			s := tratta_include_text(str_caption, s);
			s := translate_local_macros(s);
			// ???????????????????????????????????????????????????????????
//			MessageBBox(handle,'PRE' + ACAPO2 + str,inttostr(1));
			sections_ZB(0).interpreta_string(s, {stampa_vera}TRUE, {check_errors}FALSE);	// abilitato il 2002-01-29

//			MessageBBox(handle,'POST' + ACAPO2 + str,inttostr(1));
			// ???????????????????????????????????????????????????????????

			if sx.bo_transazione_separata then begin
				db_local := create_database(father, globale.report_database, sx.isolation_level, {start_transaction}TRUE);
//				db_local := TFDatabase.create(father);
//				db_local.Params.Text := globale.db_report.Params.Text;
				str_databasename := db_local.DatabaseName
			end
//			else str_databasename := sections_ZB(0).qry.DatabaseName;
			else str_databasename := globale.report_database.DatabaseName;

//			Gdebug_SQL(s, str_caption, {remarks}TRUE);		// la chiamata vera e propria viene debuggata all'interno
			if is_key_down(VK_CONTROL) then error_msg(self, NIL, s, str_caption, TRUE, MB_OK);
			// verifico se si tratta di una stored procedure
			ww_set_text(str_caption //+	// messaggio per il pubblico
//				ifs(globale.str_scripts_pre_descr[i_script],' [' + globale.str_scripts_pre_descr[i_script] + ']'));
				{ifs(sx.str_descrizione, ' [' + sx.str_descrizione + ']')});
			case exec_stored_proc(str_databasename, s, str_temp, FALSE, TRUE) of
				-1 : begin
					Gdebug_SQL(s, str_caption, {remarks}FALSE);
					raise exception.create(str_temp)	// stored procedure con errore; l'errore viene caricato su STR_RESULT
				end;
				1 : ;	// SP eseguita senza problemi
				0 : begin		// non è una SP
					Gdebug_SQL(ifs(pos(ACAPO, s) <> 0, ACAPO) + s {+ ifs(pos(ACAPO, s) <> 0, ACAPO)}, str_caption, {remarks}FALSE);
					exec_SQL(s, str_databasename)
{					if (db_local = NIL) then qry := sections_ZB(0).qry as TFquery else qry := create_query(father, db_local);
					exec_SQL(qry, s) }
				end
			end
		except
			error_msg(self, NIL, str_caption + ACAPO + 'Errore durante l''esecuzione dello script' + ACAPO2 + s, mbox_caption);
			result := FALSE
		end;
		if (db_local <> NIL) then begin
			if db_local.InTransaction then try
				if result AND sx.bo_commit then db_local.commit else db_local.rollback
			except
				error_msg(self, NIL, str_caption + ACAPO + 'Errore durante la chiusura della transazione (' + ifs(sx.bo_commit, 'COMMIT', 'ROLLBACK') + ')',
					mbox_caption);
				result := FALSE
			end;
			db_local.free
		end
	end;

begin
	result := TRUE;
	for var i : smallint := 0 to globale.Text_scripts[tipo].i_numero - 1 do begin
		if NOT exec_script(tipo, i) then begin
			result := FALSE;
			exit
		end
	end
end;

procedure Tdlg_print_report.impagina(bo_first_time : boolean;bo_reload_data : boolean = FALSE;bo_execute_scripts : boolean = TRUE);
{ copia i record da SECTIONS_VALUES, che contiene tutti i records di tutte le sections, in PRINT_PAGES e nei suoi sotto-objects;
  in caso di errore emette appropriati messaggi ed esegue un abort }

	procedure set_enabled(bo_enabled : boolean);
	begin
		panel_preview.Enabled := bo_enabled;
		btn_panel.Enabled := bo_enabled;
		bo_window_enabled := bo_enabled
	end;

	function translate_early_SQL_syntaxes(tipo : variabile_type) : boolean;
	// esegue le early-SQL sintaxes per il tipo specificato; rende TRUE in caso di successo, FALSE altrimenti
	begin
		result := FALSE;
		try
			for var i_logical_page : logical_page_type := 1 to get_ultima_pagina_logica do begin
				for var i : obj_index_type := 1 to i_objs(i_logical_page) do begin
					var xobj : objs_type := xobjs(i,i_logical_page);
//					if (xobj.get_tipo <> xVARIABILE) then continue;
					if (xobj.tipo_variabile <> tipo) then continue;
					var lab : cl_label := xobj.aslabel;
//					if (lab.tipovar <> tipo) then continue;

//					s := lab.str_SQL_expression;
					var s := xobj.str_SQL_expression;
					sections_1B(1, i_logical_page).interpreta_string(s, {stampa_vera}TRUE, {check_errors}FALSE);
					try
						if is_key_down(VK_CONTROL) then error_msg(self, NIL, s, '[pre-sql-syntax] ' + xobj.get_debug_caption, TRUE, MB_OK);
						sections_1B(1).qry.SQL.Text := s;
//						if lab.bo_log_query_SQL then Gdebug_SQL(sections(1).qry,'[pre-sql-syntax] ' + lab.Caption, FALSE, FALSE);
						if xobj.ca.bo_log_query_SQL then Gdebug_SQL(sections_1B(1).qry,'[pre-sql-syntax] ' + xobj.get_name, FALSE, NIL, FALSE);
						sections_1B(1).qry.Active := TRUE;
						if sections_1B(1).qry.eof then lab.str_print := ''
						else lab.str_print := sections_1B(1).qry.Fields[0].AsString;
//						if lab.bo_log_query_SQL then Gdebug_SQL(lab.str_print, '', TRUE)
						if xobj.ca.bo_log_query_SQL then Gdebug_SQL(lab.str_print, '', TRUE)
					except
						error_msg(self, NIL, 'Errore durante l''esecuzione dell''istruzione SQL:' + ACAPO2 + s, '[pre-sql-syntax] ' + xobj.get_debug_caption)
					end;
					sections_1B(1).qry.Active := FALSE
				end
			end;
			result := TRUE
		except
			error_msg(self, NIL, 'Errore durante l''esecuzione degli oggetti <' + TV_DESCRIZIONE[tipo] + '>', MBOX_CAPTION)
		end
	end;

	function reset_valori_calcolati(circostanza : recalculate_type) : smallint;
	// esegue il riazzeramento dei valori calcolati, in funzione della circostanza specificata; rende il numero degli oggetti ricalcolati
	var criteri_ricalcolo : set of recalculate_type;	//*
	begin
		// determino i criteri che devono indurre il ricalcolo
		case circostanza of
			REC_DEFAULT : criteri_ricalcolo := [];
			REC_UPDATE_RUNTIME_PARMS : criteri_ricalcolo := [REC_UPDATE_RUNTIME_PARMS, REC_ALWAYS];
			REC_AFTER_RUNTIME_PARMS : criteri_ricalcolo := [REC_UPDATE_RUNTIME_PARMS, REC_AFTER_RUNTIME_PARMS, REC_ALWAYS];
			REC_ALWAYS : criteri_ricalcolo := [low(recalculate_type)..high(recalculate_type)]
		end;

		result := 0;
		for var i_page : logical_page_type := 1 to get_ultima_pagina_logica do begin
			for var i_obj : obj_index_type := 1 to i_objs(i_page) do begin
				var obj : objs_type := xobjs(i_obj, i_page);
				if (obj.tipo_oggetto <> LABEL_OBJ) then continue;
				if NOT (obj.aslabel.ca.tipo_variabile in OGGETTI_CALCOLATI) then continue;
				if NOT (obj.aslabel.criterio_ricalcolo in criteri_ricalcolo) then continue;
				obj.aslabel.reset_print_value;inc(result)
			end
		end
	end;

label retry, after_set_runtime_parm, loop{, start_impaginazione};
const MBOX_CAPTION_DEBUG = 'print_report.impagina()';
const MAX_RUNTIME_QUESTIONS = 99;
var
	r : real;
	i : integer;
	i_logical_page_1B : logical_page_type;
	i_breaked_section : section_index_type;				// contiene la sezione che è stata spaccata perchè non ci sta nella pagina
	i_breaked_field_section : section_index_type;
	i_section_conta_records : section_index_type;		// sezione che determina il conteggio dei records per la pagina logica
	s, str_formatting_record : string;

	function get_new_print_page(pp : cl_print_page) : cl_print_page;
	// genera la pagina successiva rispetto a PP (pagina attuale)
	begin
//		if (get_numero_virtual_pages_of_pagina_logica = 0) then begin
		if (pp = NIL) then begin		// 2009-10-22 dovrebbe essere equivalente alla riga precedente; la riga prec NON funziona in caso di skip di etichette all'inizio della stampa
			print_pages_1B[i_logical_page_1B] := cl_print_page.create(get_last_virtual_printed_page);
			result := print_pages_1B[i_logical_page_1B]
		end
		else begin
			pp.next := cl_print_page.create(get_last_virtual_printed_page);
			result := pp.next
		end
	end;

begin
//	lab := NIL;
	if bo_first_time then bo_execute_scripts := TRUE;	// impossibile non eseguire gli scripts al primo giro
	var bo_own_ww := FALSE;
	var bo_stop := FALSE;
	var bo_stopped_validazione := FALSE;
	var dt_start_esecuzione : TDatetime := 0;
	{$ifndef DLL} globale.bo_first_print := TRUE; {$endif}

	try
//		free_index;
		free_print_pages;
		init_Gdebug_SQL(globale.str_filename, 'GENERAZIONE STAMPA', globale.bo_debug_delete_everytime);
		var sections_values : cl_print_section := NIL;
		try
			runtime_debug('start', MBOX_CAPTION_DEBUG, RD_DEBUG_PRINCIPALE_00);
//			pp := NIL;
			i_skip_virtual_pages := 0;
			set_virtual_printing_page(0);
			set_enabled(FALSE);

			bo_own_ww := NOT ww_exists;
			if bo_own_ww then begin
				ww_create_preparing(self, TRUE, bo_stop);
				ww_show
			end;
			{$ifndef DLL} GM.Visible := FALSE; {$endif}
			{$ifdef DEBUG} pt_sections_values := @sections_values; {$endif}	// debugging purposes, per controllare everywhere il contenuto dei dati in formattazione

			if NOT bo_first_time then begin
				for i_logical_page_1B := 1 to get_ultima_pagina_logica do
					reset_logical_page_print_values(i_logical_page_1B);
//				goto start_impaginazione
			end;

			if bo_first_time OR bo_reload_data then set_job_datetime;	// imposto l'ora ufficiale della stampa

			if bo_first_time then begin
//				if NOT exec_script(0) then abort;
				if NOT exec_SQL_scripts(TST_SQLS_EARLY) then abort;
				// i parametri runtime devono essere chiesti PRIMA dei VAR_SQL_SELECT_BEFORE_START (2006-09-01)
				if NOT translate_early_SQL_syntaxes(TV_SQL_SELECT_BEFORE_RUNTIME) then abort;
				exec_validazione_anticipata_proc(VCTXT_CHECK_PARMS);
				if (ask_runtime_parms(get_working_window, lo_print_style, FALSE, bo_dont_close_after, bo_execute_scripts) <> ARP_BUILD_REPORT) then abort;	// solo la prima volta; le successive viene richiesto direttamente da RELOAD_DATA()
				if bo_first_time then bo_execute_scripts := TRUE
			end;

			reset_valori_calcolati(REC_AFTER_RUNTIME_PARMS);
			dt_start_esecuzione := now;

			if globale.bo_use_transaction AND ({first_time OR bo_reload_data OR} bo_execute_scripts)
				AND NOT globale.report_database.inTransaction		// 2010-01-30
			then begin
				ww_set_text('Connessione al database');
				globale.report_database.Connected := TRUE;
				{$ifdef DEBUG} assert(NOT globale.report_database.inTransaction, 'transazione attiva al momento del lancio -- FPHQ 8301'); {$endif}
				globale.report_database.TxOptions.Isolation := globale.isolation_level;
				globale.report_database.StartTransaction
			end;

			if bo_first_time AND NOT translate_early_SQL_syntaxes(TV_SQL_SELECT_BEFORE_SQL) then abort;

			if bo_first_time OR ({reload_data AND} bo_execute_scripts) then begin
//				for i := 1 to SQL_PRE_SCRIPTS_NUMBER-1 do if NOT exec_script(i) then abort
				if NOT exec_SQL_scripts(TST_SQLS_BEFORE) then abort
			end;

{			// conto il numero di pagine logiche stampabili			***** USARE globale.GET_RUNTIME_PAGINE_LOGICHE_STAMPABILI
			i_pagine_logiche_stampabili := 0;
			for i_logical_page_1B := 1 to get_ultima_pagina_logica do begin
				if globale.lpages_info[i_logical_page_1B].bo_dont_print then continue;
				inc(i_pagine_logiche_stampabili)
			end; }

//start_impaginazione:
			lo_serial_number_impagina := 0;	// assegna un numero sequenziale ad ogni sezione; OK per riazzerare ad ogni stampa
//			dlg_working.set_avanzamento(xFST_READING_DATA,1,0,0,'');

			if (globale.tiporeport in LABEL_TYPES) AND (globale.str_label_skip <> '') then begin
				s := '';var tipo := VAL_NUMERO;
				if translate_formula(globale.str_label_skip, s, {test}FALSE, tipo, NIL) then
					i_skip_virtual_pages := strtoint(s) mod i_virtual_pages_per_phpage
				else MessageBBox(NIL, handle, 'Errore durante la valutazione della posizione dell''etichetta iniziale' + ACAPO2 + s, MBOX_CAPTION, MB_ICONSTOP)
			end;

			globale.init_traduzione;

(*			if bo_XML_export_available AND (globale.str_struttura_XML[i_profilo] <> '') then begin	***
				globale.str_struttura_XML_runtime := globale.str_struttura_XML;		// già pulito da eventuali righe vuote iniziali/finali
				sections_ZB(0).interpreta_string(globale.str_struttura_XML_runtime, {stampa_vera}TRUE, {check_errors}FALSE)	// abilitato il 2002-01-29
			end; *)
			setLength(globale.str_XML_header_runtime, length(globale.expint_profiles));
			setLength(globale.str_struttura_XML_runtime, length(globale.expint_profiles));
			for var i_profilo_00 : smallint := 0 to high(globale.expint_profiles) do begin
				var export_profilo : cl_expint_profilo := get_expint_profilo(i_profilo_00);
				globale.str_XML_header_runtime[i_profilo_00] := export_profilo.str_XML_header;
				globale.str_struttura_XML_runtime[i_profilo_00] := export_profilo.str_XML_struttura;		// già pulito da eventuali righe vuote iniziali/finali
				if export_profilo.bo_XML AND (export_profilo.str_XML_header + export_profilo.str_XML_struttura <> '') then begin
					sections_ZB(0).interpreta_string(globale.str_XML_header_runtime[i_profilo_00], {stampa_vera}TRUE, {check_errors}FALSE);
					sections_ZB(0).interpreta_string(globale.str_struttura_XML_runtime[i_profilo_00], {stampa_vera}TRUE, {check_errors}FALSE)
				end
			end;

			Gdebug_SQL('', '', {remarks}FALSE);
			Gdebug_SQL('', '------------------- FINE DEGLI SCRIPTS ---------------------', {remarks}FALSE);
			Gdebug_SQL('', '', {remarks}FALSE);

			for i_logical_page_1B := 1 to get_ultima_pagina_logica do begin
				if ww_stopped then abort;	// interruzione dell'utente
//				dlg_working.set_avanzamento(FST_READING_DATA,1,0,0,'');	// spostato qui il 2006-02-15
				ww_set_avanzamento(FST_READING_DATA, i_logical_page_1B, 0, 0, '', TRUE);	// modificato 2006-03-18
				runtime_debug('start logical page ' + i_logical_page_1B.ToString, MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
//				dlg_working.set_avanzamento(FST_READING_DATA,i_logical_page,get_last_phisical_printed_page,lo_total_rows);
				ww_reset_record_count;	// riazzero il contatore di records
				reset_logical_page_print_values(i_logical_page_1B);
				set_pagina_logica_attiva_1B(i_logical_page_1B, TRUE);
				var lp : cl_logical_page_info := get_logical_page_1B(i_logical_page_1B);

				if lp.bo_dont_print then s := '(pagina esclusa dalla stampa)'
				else if lp.bo_exclude_debug then s := '(debugging disabilitato)'
				else s := '';
				Gdebug_SQL('', '################### PAGINA LOGICA ' + zeri(i_logical_page_1B, 2) + ' ##################### ' + lp.get_descrizione(TRUE) + ' ' + s, {remarks}FALSE);
				if lp.bo_dont_print then continue;

				SetLength(lp.str_struttura_XML_runtime, length(globale.expint_profiles));		// alloco anche per EXPINT, anche se non sarebbe necessario
				for i := 0 to get_num_sections_page_ZB(i_logical_page_1B - 1) - 1 do
					setLength(sections_ZB(i, i_logical_page_1B - 1).str_XML_elaborato, length(globale.expint_profiles));
				for var i_profilo_01 : smallint := 0 to high(globale.expint_profiles) do begin
					var expint_page : cl_expint_page := get_expint_page_ZB(i_profilo_01, i_logical_page_1B - 1);
					if get_export_target_XML(i_profilo_01) AND expint_page.bo_export_allowed then begin
						lp.str_struttura_XML_runtime[i_profilo_01] := expint_page.str_XML_struttura;
						sections_ZB(0).interpreta_string(lp.str_struttura_XML_runtime[i_profilo_01], {stampa_vera}TRUE, {check_errors}FALSE)
					end
				end;

				var pp : cl_print_page := NIL;			// 2009-10-25: perchè altrimenti la GET_NEW_PRINT_PAGE() non funziona correttamente
				sections_values := NIL;i_breaked_section := 0;i_breaked_field_section := 0;

				runtime_debug('pre load SQL', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
				for i := 1 to i_objs do with xobjs(i, i_logical_page_1B) do begin
//					if (get_tipo in TESTI_OBJS) then aslabel.str_print := '';
//					if (get_tipo in TESTI_OBJS) AND NOT (aslabel.tipovar in TV_COSTANTI) then aslabel.clear_print_value		*** fino al 2011-05-09
					if (ca.tipo_oggetto in ALPHABETIC_OBJS) then clear_print_value
				end;

				var lo_rows : integer := sections_ZB(MAIN_SECTION_ZB).load_SQL_values(sections_values, valid);
				runtime_debug('post load SQL', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
				if (lo_rows = 0) then begin
					if lp.bo_message_if_not_printed then MessageBBox(NIL, father.handle, page_msg(i_logical_page_1B, 'Pagina non stampata perchè vuota'), MBOX_CAPTION);
					print_pages_1B[i_logical_page_1B] := NIL;
					continue
				end;

				runtime_debug('pre prepare to print', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
//				lo_counted_records := dlg_working.get_rows_number;	// leggo il numero di records della pagina logica
				var lo_counted_records : integer := get_total_record_number(i_logical_page_1B);	// leggo il numero di records della pagina logica

				for i := 0 to get_num_sections - 1 do sections_ZB(i).prepare2print;

				i_section_conta_records := get_num_sections_page(i_logical_page_1B);
				while (i_section_conta_records <> MAIN_SECTION) AND NOT sections_1B(i_section_conta_records, i_logical_page_1B).bo_conta_records
					do dec(i_section_conta_records);

				set_last_virtual_page_of_pagina_logica(0);
				while (sections_values <> NIL) OR (get_numero_virtual_pages_of_pagina_logica = 0) do begin
					if ww_stopped then abort;	// interruzione dell'utente

					// vedo se ci sono pagine da saltare
					if bo_goto_next_phisical_page then begin
						i_skip_virtual_pages :=
							(i_virtual_pages_per_phpage - get_last_virtual_printed_page mod i_virtual_pages_per_phpage) mod i_virtual_pages_per_phpage;
						bo_goto_next_phisical_page := FALSE
					end;
					// inserisco pagine vuote, ma proprio vuote
					while (i_skip_virtual_pages > 0) do begin
						{$ifdef DEBUG} assert(globale.tiporeport = TR_LABEL_REPORT,'i_skip_virtual_pages != 0 ma not TR_LABEL_REPORT -- KRWX 9158'); {$endif}
						set_virtual_printing_page(get_last_virtual_printed_page + 1);
//						pp.next := cl_print_page.create(get_last_virtual_printed_page);pp := pp.next;
						pp := get_new_print_page(pp);
						dec(i_skip_virtual_pages)
					end;

					set_virtual_printing_page(get_last_virtual_printed_page + 1);
					runtime_debug('inizio pagina virtuale ' + get_last_virtual_printed_page.ToString, MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);

					// cerco di capire a quale record è arrivata la formattazione
					str_formatting_record := '';
					if (i_section_conta_records <> 0) AND (lo_counted_records > 1) then begin
						runtime_debug('conta records start', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
						var svx : cl_print_section := sections_values;
						while (svx <> NIL) AND (svx.i_section_1B <> i_section_conta_records) do svx := svx.next;
						runtime_debug('conta records after', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
						if (svx <> NIL) then begin
							if (globale.get_runtime_pagine_logiche_stampabili = 1) then
								str_formatting_record := '[' + stri(svx.lo_LP_record_number / lo_counted_records * 100, 0) + '%]'
							// se ci sono + pagine logiche stampabili non uso la percentuale perchè trae in inganno
							else str_formatting_record := '[' +
								togliblanks(string(sections_1B(i_section_conta_records, i_logical_page_1B).str_record_descr_runtime) + ' ' +
									(svx.lo_LP_record_number + 1).ToString + '/' + (lo_counted_records).ToString) + ']'
//							else str_formatting_record := '[' + inttostr(lo_counted_records - svx.lo_record_number) + '/' + inttostr(lo_counted_records) + ']'
						end
					end;

					runtime_debug('set avanzamento before', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
					ww_set_avanzamento(FST_FORMATTING, i_logical_page_1B, get_last_virtual_printed_page, 0, str_formatting_record,TRUE);
					runtime_debug('set avanzamento after', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
					pp := get_new_print_page(pp);
					runtime_debug('set_last_virtual_page_of_pagina_logica pre', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
					set_last_virtual_page_of_pagina_logica(get_numero_virtual_pages_of_pagina_logica + 1);

					r := 0;
					runtime_debug('PRE impagina ==================================================', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
					sections_ZB(MAIN_SECTION_ZB).impagina(sections_values, pp, 0, sections_ZB(MAIN_SECTION_ZB).r_y_sezione_cm,
						r, Canvas, printer.Canvas, {dont_break}FALSE, {stampa_comunque}TRUE, {print_only_subs}FALSE, i_breaked_section, i_breaked_field_section);
					runtime_debug('POST impagina =================================================', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
					i_printing_section_ZB := -1
				end
			end;
			runtime_debug('500 after printing loop', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
			ww_set_avanzamento(FST_ZERO, 0, 0, 0, '');
			runtime_debug('510 after set_avanzamento', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
			if ww_stopped then begin
				runtime_debug('515 STOPPED!', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
				abort			// interruzione dell'utente
			end;
			if NOT silent_mode AND NOT verifica_validazione([VCTXT_ELABORAZIONE]) then begin
				bo_stopped_validazione := TRUE;
				abort
			end;
			dynamic_images_error_messages;	// verifico se vi sono errori di caricamento delle bitmaps dinamiche
			runtime_debug('520 after dyn_imgs', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
			create_index;
			runtime_debug('590 after create_index', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01)
		except
			// se possiedo il processo di comunicazione con l'utente, avviso del fallimento
			runtime_debug('599 EXCEPT', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
//			{$ifndef DEBUG} *** usare DLG_WORKING? {$endif}
			if bo_own_ww then
				if ww_stopped OR bo_stopped_validazione then
					MessageBBox(NIL, FSystem_base.get_handle(father), 'Stampa annullata', MBOX_CAPTION, MB_ICONINFORMATION OR MB_LOG_EVENT)
				else MessageBBox(NIL, FSystem_base.get_handle(father), 'Stampa fallita' + ACAPO2 + get_last_exception_msg, MBOX_CAPTION, MB_ICONINFORMATION OR MB_LOG_EVENT);
//			if bo_own_ww then MessageBBox(0, 'Stampa fallita', MBOX_CAPTION, MB_ICONSTOP);
//			if bo_own_ww then MessageBBox(myp.get_handle(dlg_working), 'Stampa fallita', MBOX_CAPTION, MB_ICONSTOP);
			while (sections_values <> NIL) do delete_first_print_section_record(sections_values);
			bo_stop := TRUE;
			if bo_first_time then abort else close
		end
	finally
		runtime_debug('X99 FINALLY', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
//		close_connessione_SQL;	// non lo faccio qui per non eliminare le eventuali temporary tables
		runtime_debug('910', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
		end_Gdebug_SQL;		// chiude il DEBUG

		if bo_own_ww then ww_close;
		set_enabled(TRUE);
		{$ifndef DLL} GM.Visible := TRUE {$endif}
	end;
//	runtime_debug('920', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
	if bo_stop then begin
//		runtime_debug('925 STOP', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
		exit
	end;

	if globale.bo_show_time_esecuzione then
		MessageBBox(NIL, father.handle, formatta_secondi((now - dt_start_esecuzione)  / SECONDO) + ' secondi', 'Tempo esecuzione');

	if (get_last_virtual_printed_page = 0) then begin
		MessageBBox(NIL, father.handle, 'Nessuna pagina da stampare', MBOX_CAPTION);
		abort
	end;

	xprint_status[i_job] := PS_OK;			// 2004-07-24

//	runtime_debug('930', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
	i_total_virtual_pages := get_last_virtual_printed_page;
//	i_virtual_pages_per_phpage := (tm.i_lab_per_row * tm.i_lab_per_page);
	i_total_phisical_pages := get_last_phisical_printed_page;
	i_pagina.Enabled := (i_total_phisical_pages > 1);
	btn_left.Enabled := i_pagina.Enabled;
	btn_right.Enabled := i_pagina.Enabled;
	i_active_logical_page_1B := i_old_active_logical_page_1B;
	if (print_pages_1B[i_active_logical_page_1B] = NIL) then i_active_logical_page_1B := get_pagina_logica_of_pagina_fisica_1B(1);
	i_active_phisical_page := get_pagina_fisica_of_pagina_virtuale(print_pages_1B[i_active_logical_page_1B].i_virtual_page_1B);

//	runtime_debug('940', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
	for i_logical_page_1B := 1 to get_ultima_pagina_logica do begin
		var lp : cl_logical_page_info := get_logical_page_1B(i_logical_page_1B);
		s := lp.str_message_if_printed;
		if (s <> '') AND pagina_stampata(i_logical_page_1B) then
			MessageBBox(NIL, father.handle, s, lp.get_descrizione(TRUE))
	end;

	i_pagina.Text := i_active_phisical_page.ToString;
	set_pagina_logica_attiva_1B(i_active_logical_page_1B, TRUE);
	i_show_num_pages.Text := i_total_phisical_pages.ToString;
//	runtime_debug('950 pre select_index_of_page', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
	select_index_of_page;
//	runtime_debug('960 pre select_index_of_page', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
	check_progressivi_pagina(self);
//	runtime_debug('999 *end*',MBOX_CAPTION_DEBUG, RD_DEBUG_PRINCIPALE_00)
end;

procedure Tdlg_print_report.close_connessione_SQL;
// chiude la connessione con l'SQL
const MBOX_CAPTION_DEBUG = 'print_report.SQL_close()';
var bo_unuseful : boolean;	//*
begin
	try
		// richiedo i parametri runtime conclusivi
//		if (ask_runtime_parms(dlg_working, TRUE) <> ARP_BUILD_REPORT) then abort
		if NOT bo_dont_open then ask_runtime_parms(get_working_window, lo_print_style, TRUE, bo_dont_close_after, bo_unuseful);
(*		try
			for i := 0 to globale.SQL_scripts[TST_SQLS_AFTER].i_numero - 1 do begin
				sx := @globale.SQL_scripts[TST_SQLS_AFTER].SQLS[i];
				s := togliblanks(togli_ACAPO_finali(sx.str_SQL));					{$ifndef DEBUG} *** gestire transazione {$endif}
				if sx.bo_enabled AND (s <> '') then begin
					str_caption := get_runtime_script_description(TST_SQLS_AFTER, i);
					s := tratta_include_text(str_caption, s);
					sections_ZB(0).interpreta_string(s,TRUE,FALSE);
					runtime_debug(str_caption + ACAPO + s, MBOX_CAPTION_DEBUG, RD_DEBUG_PRINCIPALE_00);
					Gdebug_SQL(s, str_caption);
					exec_SQL(NIL, s)	**
				end
			end
		except
			error_msg(NIL, get_handle,'Errore durante l''esecuzione d''uno script SQL conclusivo' + ACAPO2 + s, MBOX_CAPTION)
		end; *)

		var bo_stop := FALSE;
		try
			ww_create_preparing(self, TRUE, bo_stop);
			ww_enable_button(FALSE);
			ww_show;
			ww_set_text('esecuzione scripts conclusivi');
			if NOT exec_SQL_scripts(TST_SQLS_AFTER) then abort;
			ww_set_text('fase disconnessione database');
			with globale do if bo_use_transaction AND report_database.InTransaction then begin
				runtime_debug('Close SQL transaction','', RD_DEBUG_PRINCIPALE_00);
				if bo_commit_transaction then report_database.Commit else report_database.Rollback
			end
		finally
			ww_close
		end
	except
		error_msg(self, NIL, 'Errore durante la chiusura della connessione SQL', MBOX_CAPTION)
	end
end;

procedure Tdlg_print_report.i_paginaChange(Sender : TObject);
var i, j : integer;	//*
begin
	if bo_dont_open then exit;	// non ancora terminata la creazione della finestra
	try
		iVal(i_pagina.Text, i, j);if (j <> 0) then begin beep(0);abort end;	// reimposto la pagina corrente
//		iVal(i_pagina.Text, i, j);if (j <> 0) then begin beep(0);exit end;	// lascio la scritta errata
		if (i < 1) OR (i > i_total_phisical_pages) then begin beep(0);abort end;
		if (i_active_phisical_page <> i) then goto_phisical_page(i)
	except
		i_pagina.Text := i_active_phisical_page.ToString
	end
end;

procedure Tdlg_print_report.i_paginaKeyPress(Sender : TObject;var Key : Char);
begin
	if NOT CharInSet(key, [#8,'0'..'9']) then key := #0
end;

procedure Tdlg_print_report.goto_phisical_page(i_pagina_fisica : ph_page_type);
// va alla pagina specificata; aggiorna gli indicatori del numero di pagina
begin
	if bo_dont_open then exit;	// non ancora terminata la creazione della finestra
	try
		if (i_active_phisical_page <> i_pagina_fisica) then begin
			i_active_logical_page_1B := get_pagina_logica_of_pagina_fisica_1B(get_pagina_fisica_of_pagina_virtuale(i_pagina_fisica));
			if (i_active_logical_page_1B = 0) then abort;
			set_pagina_logica_attiva_1B(i_active_logical_page_1B, FALSE);
			i_active_phisical_page := i_pagina_fisica;
			imposta_misure_pagina;
			draw
		end
	except
		i_pagina_fisica := i_active_phisical_page;
		i_active_logical_page_1B := get_pagina_logica_of_pagina_fisica_1B(get_pagina_fisica_of_pagina_virtuale(i_active_phisical_page))
	end;
	if index_panel.Visible then select_index_of_page;
	if (i_pagina_fisica.ToString <> i_pagina.Text) then i_pagina.Text := i_pagina_fisica.ToString;
	if (tb.Position <> i_pagina_fisica) then tb.Position := i_pagina_fisica;
	if (scroll_buttons <> NIL) then scroll_buttons[i_pagina_fisica-1].Down := TRUE
end;

procedure Tdlg_print_report.FormResize(Sender : TObject);
begin
//	set_ctrls_size
end;

procedure Tdlg_print_report.draw;
var
	i, j, k : ph_page_type;
	xx, y : double;
	x0, y0, x1, y1 : int_pixel_type;
begin
	set_wait_cursor(TRUE);
	var picture : TPicture := NIL;
	try
		picture := TPicture.Create;
		tm.init_video_values(getDC(Handle), r_fattore_zoom);
		try
			picture.Bitmap.Height := i_PHpage_size_Y_pix_video(i_active_logical_page_1B);
			picture.Bitmap.Width := i_PHpage_size_X_pix_video(i_active_logical_page_1B);
//			printer.canvas.font.pixelsperinch := tm.i_pixel_per_inch_print_x;		// 2004-07-13
			case globale.tiporeport of
				TR_REPORT : print_page(print_pages_1B[i_active_logical_page_1B], i_active_phisical_page, TRUE,
					picture.Bitmap.Canvas, printer.Canvas, 0, 0, RTA_PRINTER);
				TR_LABEL_REPORT : begin
					xx := get_label_size_X_cm + tm.r_delta_labs_X_cm;
					y := get_label_size_Y_cm + tm.r_delta_labs_Y_cm;
					for i := 0 to tm.i_lab_per_page - 1 do begin
						for j := 0 to tm.i_lab_per_row - 1 do begin
							k := (i_active_phisical_page - 1) * i_virtual_pages_per_phpage + (i * tm.i_lab_per_row) + j + 1;
							if (k > i_total_virtual_pages) then break;
							if draw_lines_separazione_label then begin
//								picture.Bitmap.canvas.Pen.Style := psDash;
								picture.Bitmap.canvas.Pen.Style := psDot;
								x0 := cm2pixel_video_X(j * xx);x1 := cm2pixel_video_X(j * xx + get_label_size_X_cm);
								y0 := cm2pixel_video_Y(i * y);y1 := cm2pixel_video_Y(i * y + get_label_size_Y_cm);
//								picture.bitmap.canvas.Rectangle(x0,y0,x1,y1);	EFFETTO NON BELLO di sovrapposizione del tratteggio
								picture.Bitmap.canvas.MoveTo(x1, y0);	// alto dx
								picture.Bitmap.canvas.LineTo(x1, y1);	// basso dx
								picture.Bitmap.canvas.LineTo(x0, y1);	// basso sx
								if (tm.r_delta_labs_X_cm <> 0) then picture.Bitmap.canvas.LineTo(x0, y0)	// alto sx
								else picture.Bitmap.canvas.LineTo(x0, y0);
								if (tm.r_delta_labs_Y_cm <> 0) then picture.Bitmap.canvas.LineTo(x1, y0);	// alto sx
								picture.Bitmap.canvas.Pen.Style := psSolid
							end;

							print_page(print_pages_1B[i_active_logical_page_1B], k, TRUE, picture.bitmap.canvas, printer.canvas, j * xx, i * y, RTA_PRINTER)
						end
					end
				end
				{$ifdef DEBUG} else assert(FALSE,'tiporeport wrong -- DRAWING -- JSMN 2981') {$endif}
			end;
			image.Picture.Assign(picture)
		except
			error_msg(self, NIL, '', MBOX_CAPTION)
		end
	finally
		tm.init_video_values(getDC(handle), 1);
		picture.free;
		set_wait_cursor(FALSE)
	end
end;

procedure Tdlg_print_report.FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
const UNITA = 25.0;	// range : 100
var
	i_unita_hh, i_unita_vv : smallint;
	i_old_pos_hh, i_new_pos_hh, i_old_pos_vv, i_new_pos_vv : smallint;
	i_this, i_goto_page, j, i_pl : integer;
begin
	if NOT bo_window_enabled then exit;
	i_old_pos_vv := sbox.vertscrollbar.position;i_new_pos_vv := -1;
	i_old_pos_hh := sbox.horzscrollbar.position;i_new_pos_hh := -1;
	Ival(i_pagina.Text, i_this, j);if (j <> 0) then exit;

	i_goto_page := 0;		// assegnare questa variabile alla pagina su cui si ci vuole spostare
	i_unita_vv := round(UNITA * sbox.vertscrollbar.Range / 100 / r_fattore_zoom);
	i_unita_hh := round(UNITA * sbox.horzscrollbar.Range / 100 / r_fattore_zoom);
	if (activecontrol = index) AND (key in [VK_PRIOR, VK_NEXT, VK_END, VK_HOME, VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT]) then exit;
	i_pl := get_pagina_logica_of_pagina_fisica_1B(i_this);		// assegno la pagina logica attuale
	case key of
		VK_ESCAPE : close;
		VK_PRIOR: if (i_this > 1) then begin	// PAGE UP
			if (shift = []) then i_goto_page := i_this - 1 else
			if (shift = [ssCtrl]) then begin
				// se sono a metà di una pagina logica, mi sposto sulla prima pagina della pagina logica
				j := get_first_pagina_fisica_of_pagina_logica(get_pagina_logica_of_pagina_fisica_1B(i_this));
				if (i_this = j) then 	// sono sulla prima pagina fisica della pagina logica I_PL (che non può essere la PRIMA PAGINA FISICA STAMPATA, perchè non posso essere a pagina fisica 1)
					i_goto_page := get_first_pagina_fisica_of_pagina_logica(i_pl - 1)
				else i_goto_page := j	// non sono all'inizio della pagina logica, mi sposto sulla prima pagina della pagina logica
			end
		end;
		VK_NEXT: if (i_this < i_total_phisical_pages) then begin	// PAGE DOWN
			if (shift = []) then i_goto_page := i_this + 1 else
			if (shift = [ssCtrl]) then begin
				if (i_pl = globale.i_pagine_logiche) OR (i_pl = get_pagina_logica_of_pagina_fisica_1B(get_last_phisical_printed_page))
					then i_goto_page := get_last_phisical_printed_page	// sono già sull'ultima pagina logica (stampata): vado sull'ultima pagina fisica
				else i_goto_page := get_first_pagina_fisica_of_pagina_logica(i_pl) + get_numero_pagine_fisiche_of_pagina_logica(i_pl)
			end
		end;
		VK_END: if (shift = [ssCtrl]) then i_goto_page := get_first_pagina_fisica_of_pagina_logica(i_pl) + get_numero_pagine_fisiche_of_pagina_logica(i_pl) - 1
			else i_goto_page := i_total_phisical_pages;
		VK_HOME: if (shift = [ssCtrl]) then i_goto_page := get_first_pagina_fisica_of_pagina_logica(i_pl) else i_goto_page := 1;
		VK_UP: i_new_pos_vv := MAX(i_old_pos_vv - i_unita_vv, 0);
		VK_DOWN: i_new_pos_vv := MIN(i_old_pos_vv + i_unita_vv, sbox.vertscrollbar.range - i_unita_vv);
		VK_LEFT : i_new_pos_hh := MAX(i_old_pos_hh - i_unita_hh, 0);
		VK_RIGHT : i_new_pos_hh := MIN(i_old_pos_hh + i_unita_hh, sbox.horzscrollbar.range - i_unita_hh);
		VK_ADD : set_fattore_zoom_simbolico(0, 1);
		VK_SUBTRACT : set_fattore_zoom_simbolico(0, -1);
		VK_DIVIDE : set_fattore_zoom_simbolico(ifi(i_fattore_zoom_simbolico = ZOOM_FIT_WIDTH, ZOOM_ACTUAL_SIZE, ZOOM_FIT_WIDTH));
		VK_MULTIPLY : set_fattore_zoom_simbolico(ifi(i_fattore_zoom_simbolico = ZOOM_FIT_HEIGHT, ZOOM_ACTUAL_SIZE, ZOOM_FIT_HEIGHT));
		VK_CLEAR : set_fattore_zoom_simbolico(ZOOM_ACTUAL_SIZE);	// 5 tastierino numerico
{		VK_F2 : begin
			if (shift = [ssAlt]) then btn_export_DBF.click;
			if (shift = []) then btn_PDF.click
		end; }
		VK_F3 : show_index(NOT index_panel.Visible);
//		VK_F4 : if (shift = []) then btn_mail.click;
//		VK_F5 : if (shift = []) then reload_data;
		VK_F6 : zoom;
		VK_F8 : cbx_print_diretta.Checked := NOT cbx_print_diretta.Checked;
		VK_F9 : exec_print(NIL, {comando_esplicito}TRUE);
//		{$ifdef DLL} VK_F12 : if (shift = [ssCtrl, ssAlt, ssShift]) OR (shift = [ssCtrl]) then execute_data_file(handle, FALSE, globale.str_filename); {$endif}
		else exit
	end;
	key := 0;	// disable further processing
	if (i_goto_page <> 0) then i_pagina.Text := i_goto_page.ToString;
	if (i_new_pos_vv <> -1) then sbox.vertscrollbar.Position := i_new_pos_vv;
	if (i_new_pos_hh <> -1) then sbox.horzscrollbar.Position := i_new_pos_hh
end;

procedure Tdlg_print_report.zoom;
begin
	if (i_fattore_zoom_simbolico = 0) then i_fattore_zoom_simbolico := 4;
	var i := domanda_multipla_12_proc(self, MBOX_CAPTION, 'Fatture di zoom', i_fattore_zoom_simbolico,
		FATTORI_ZOOM_DESCR[1], FATTORI_ZOOM_DESCR[2], FATTORI_ZOOM_DESCR[3], FATTORI_ZOOM_DESCR[4], FATTORI_ZOOM_DESCR[5],
		FATTORI_ZOOM_DESCR[6], FATTORI_ZOOM_DESCR[7], FATTORI_ZOOM_DESCR[8], FATTORI_ZOOM_DESCR[9],
		'/ ADATTA ALLA DIMENSIONE ORIZZONTALE','* ADATTA ALLA FINESTRA','');
	if (i <> 0) then set_fattore_zoom_simbolico(i)
end;

procedure Tdlg_print_report.set_fattore_zoom_simbolico(i_fattore_zoom_simbolico : smallint;i_delta : smallint = 0);
begin
	if (i_delta <> 0) then begin
		if (self.i_fattore_zoom_simbolico in FATTORI_ZOOM_STANDARD) then begin
			i_fattore_zoom_simbolico := self.i_fattore_zoom_simbolico + i_delta;
			if NOT (i_fattore_zoom_simbolico in FATTORI_ZOOM_STANDARD) then begin beep;exit end
		end
		else i_fattore_zoom_simbolico := ZOOM_ACTUAL_SIZE
	end;
//	if NOT (i_fattore_zoom_simbolico IN FATTORI_ZOOM_STANDARD) then exit;
	self.i_fattore_zoom_simbolico := i_fattore_zoom_simbolico;
	case i_fattore_zoom_simbolico of
		MIN_FATTORE_ZOOM_SIMBOLICO_STD..MAX_FATTORE_ZOOM_SIMBOLICO_STD :
			r_fattore_zoom := FATTORI_ZOOM[i_fattore_zoom_simbolico] / 100;
		ZOOM_FIT_WIDTH : r_fattore_zoom := r_fattore_zoom * sbox.clientwidth / (image.Width + image.Left + 10);
		ZOOM_FIT_HEIGHT : r_fattore_zoom := r_fattore_zoom *
			min(sbox.clientheight / (image.clientheight + image.Top + 10), sbox.clientwidth / (image.Width + image.Left + 10))
	end;
	set_caption(FALSE);
	imposta_misure_pagina;
	pbox_ext.Invalidate;		// 2016-04-19 faccio ridisegnare la maschera
	draw
end;

procedure Tdlg_print_report.tb_panelResize(Sender : TObject);
begin
	if (scroll_buttons = NIL) then begin
		tb.Left := 5;
		tb.Width := tb_panel.Width - 2 * tb.Left
	end
	else resize_scroll_buttons
end;

procedure Tdlg_print_report.pbox_extPaint(Sender : TObject);
begin
//	pbox_ext.Invalidate;		// 2016-04-19
	write_page_measures(get_pagina_logica_attiva_1B, pbox_ext, SHIFT_BASE, SHIFT_BASE, globale.tiporeport, TRUE,
		r_fattore_zoom, i_phisical_width_10mm div 10, i_phisical_height_10mm div 10)
end;

procedure Tdlg_print_report.AL_closeExecute(Sender : TObject); begin close end;
procedure Tdlg_print_report.AL_print_printerExecute(Sender : TObject); begin exec_print(@lo_print_style, {comando_esplicito}TRUE) end;
procedure Tdlg_print_report.btn_zoomClick(Sender : TObject); begin zoom end;
procedure Tdlg_print_report.tbChange(Sender : TObject); begin goto_phisical_page(tb.Position) end;
procedure Tdlg_print_report.btn_leftClick(Sender : TObject); begin left_right(TRUE) end;
procedure Tdlg_print_report.btn_rightClick(Sender : TObject); begin left_right(FALSE) end;

procedure Tdlg_print_report.AL_exportExecute(Sender : TObject);
begin
	target := RTA_EXPORT;
	exec_print(NIL, {comando_esplicito}TRUE)
end;

procedure Tdlg_print_report.Left_right(bo_left : boolean);
var i,j : integer;
begin
	IVal(i_pagina.Text, i ,j);if (j <> 0) then exit;
	if bo_left then begin
		if (i > 1) then i_pagina.Text := (i - 1).ToString
		else beep(0)
	end
	else begin	// right
		if (i < i_total_phisical_pages) then i_pagina.Text := (i + 1).ToString
		else beep(0)
	end
end;

// valori statici per essere salvati tra una stampa e l'altra, se eseguita in modalità GAL_POPT_DIRECTLY_EXECUTE
var
	i_num_copie : smallint;
//	i_page_from, i_page_to : ph_page_type;
	str_pages_intervallo : string;

function Tdlg_print_report.exec_print(pt_lo_print_style : integer_punt;bo_comando_esplicito : boolean;str_pagine_logiche : string) : boolean;
{ bo_comando_esplicito è TRUE quando il comando di stampa è stato dato dall'utente, FALSE se si tratta di stampa eseguita automaticamente;
  PT_LO_PRINT_STYLE contiene indicazioni sulla modalità di stampa; assume i seguenti valori:
		NIL							a seguito di comando generico di stampa (BOTTONE F9 oppure stampa di una pagina logica)
		VALORE LETTO DA REPORT	quando uso bottone di stampa normale (stampa su stampante)
		GAL_POPT_PDF				quando uso bottone di stampa su PDF
		GAL_POPT_EMAIL				quando uso stampa su email
	il TARGET della stampa è definito dalla variabile TARGET che può assumere i valori RTA_PRINTER, RTA_PDF, RTA_EXPORT_INTEGRALE
	la stampa su email non è un possibile target, perchè deve essere associato a PDF oppure EXPORT_INTEGRALE }
var str_target_path : string;			// utilizzato per i casi di generazione di files PDF plurimi (PDFH_save_single_record, PDFH_save_logical_page)

	function execute_XML_export(father : TForm;i_profilo : smallint;{i_page_from, i_page_to : ph_page_type;}bo_clipboard : boolean;str_filename : string;
		bo_overwrite_file : boolean;var bo_exported_something : boolean) : boolean;
	{ esegue l'export in formato XML di TUTTE le pagine esportabili (nessuna selezione delle pagine stampate);
	  rende TRUE in caso di successo, FALSE altrimenti }

		function tratta_XML_pagina(var str_XML : string;i_pagina_ZB : smallint) : boolean;
		// carica su STR_XML i dati XML per la pagina; rende TRUE se esistono dati XML, FALSE altrimenti
		begin
			result := FALSE;
			var lp : cl_logical_page_info := get_logical_page_ZB(i_pagina_ZB);
			if lp.bo_dont_print then exit;
//			if NOT lp.bo_XML_allowed then exit;
			var expint_page : cl_expint_page := get_expint_page_ZB(i_profilo, i_pagina_ZB);
			if NOT get_export_target_XML(i_profilo) OR NOT expint_page.bo_export_allowed then exit;

			var sez : cl_sezione := sections_ZB(0, i_pagina_ZB);
//			if (sez.str_XML_elaborato <> '') then str_XML := ACAPO + sez.str_XML_elaborato + ACAPO;

			if (lp.str_struttura_XML_runtime[i_profilo] = '') then str_XML := sez.str_XML_elaborato[i_profilo]		// prendo semplicemente l'intero contenuto XML delle sezioni
			else begin		// esiste una struttura dati legata alla pagina, inserisco le sezioni al suo interno
				var lo_pos_sezione : integer := pos(XML_SEZIONE, lp.str_struttura_XML_runtime[i_profilo]);
				if (lo_pos_sezione = 0) then str_XML := lp.str_struttura_XML_runtime[i_profilo]	// sezione non specificata: copio semplicemente i dati XML della pagina
				else begin
{					str_XML := copy(lp.lstr_struttura_XML_runtime, 1, lo_pos_sezione - 1) + ACAPO + str_XML + ACAPO +
						copy(lp.lstr_struttura_XML_runtime, lo_pos_sezione + length(XML_SEZIONE) + 1, MAXINT) {}
					str_XML := copy(lp.str_struttura_XML_runtime[i_profilo], 1, lo_pos_sezione - 1);
					append_ACAPO(str_XML, sez.str_XML_elaborato[i_profilo]);
					var str_temp := copy(lp.str_struttura_XML_runtime[i_profilo], lo_pos_sezione + length(XML_SEZIONE), MAXINT);
					if start_with(str_temp, ACAPO) then delete(str_temp, 1, length(ACAPO));		// elimino l'ACAPO dopo l'istruzione XML_SEZIONE (per non aggiungere ACAPO indesiderati)
					append_ACAPO(str_XML, str_temp)
				end
			end;
			result := (str_XML <> '')
		end;

	var
		f : system.Text;	//*
		str_id, str_temp, str_descrizione_pagina : string;
//		str_clipboard : widestring;	// non serve a un granché (per non dire che non serve a nulla)
		str_clipboard : string;			// non serve a un granché (per non dire che non serve a nulla)
		i_pos, k : integer;				// cautelativamente eccessivo
		i_pagina_logica_ZB : logical_page_type;
		lp : cl_logical_page_info;
	begin
		result := TRUE;
		bo_exported_something := FALSE;
//		var handle : HWND := get_handle(father);
//		var handle : HWND := get_handle;

		try
			str_clipboard := globale.str_XML_header_runtime[i_profilo];
			if (globale.str_struttura_XML_runtime[i_profilo] = '') then begin		// nessuna struttura XML a livello globale: esporto TUTTE le pagine logiche nel loro ordine naturale
				for i_pagina_logica_ZB := 0 to get_ultima_pagina_logica-1 do begin
					lp := get_logical_page_ZB(i_pagina_logica_ZB);
					str_descrizione_pagina := coalesce(lp.str_page_ID, lp.get_descrizione(TRUE));
					if tratta_XML_pagina(str_temp, i_pagina_logica_ZB) then
						str_clipboard := ifs(str_clipboard, str_clipboard + ACAPO) +
							ifs(globale.bo_XML_structure_debug_info, XML_commento('PAGINA LOGICA', str_descrizione_pagina, {start}TRUE)) +
							str_temp + ACAPO +
							ifs(globale.bo_XML_structure_debug_info, XML_commento('PAGINA LOGICA', str_descrizione_pagina, {start}FALSE))
				end
			end
			else begin
				str_clipboard := ifs(str_clipboard, str_clipboard + ACAPO) + globale.str_struttura_XML_runtime[i_profilo];
				while TRUE do begin
					i_pos := System.pos(XML_PAGINA_LOGICA_BEFORE, str_clipboard);
					if (i_pos = 0) then break;
					k := pos(XML_PAGINA_LOGICA_AFTER, copy(str_clipboard, i_pos + length(XML_PAGINA_LOGICA_BEFORE), MAXINT));
					if (k = 0) OR (k > MAX_LENGTH_ID_PAGINA_LOGICA) then raise exception.create('ID pagina non indicato');
					str_id := copy(str_clipboard, i_pos + length(XML_PAGINA_LOGICA_BEFORE), k - 1);
					i_pagina_logica_ZB := get_pagina_logica_info_index_ZB(str_ID);
					if (i_pagina_logica_ZB = -1) then
						raise exception.create('La pagina logica referenziata nella struttura XML non esiste: <' + str_ID + '>');
					tratta_XML_pagina(str_temp, i_pagina_logica_ZB);		// acquisisco i dati XML per la pagina specificata

					lp := get_logical_page_ZB(i_pagina_logica_ZB);
					str_descrizione_pagina := coalesce(lp.str_page_ID, lp.get_descrizione(TRUE));

					str_clipboard := copy(str_clipboard, 1, i_pos - 1) + ACAPO +
						ifs(globale.bo_XML_structure_debug_info, XML_commento('PAGINA LOGICA', str_descrizione_pagina, {start}TRUE)) +
						str_temp + ACAPO +
						ifs(globale.bo_XML_structure_debug_info, XML_commento('PAGINA LOGICA', str_descrizione_pagina, {start}FALSE)) +
						copy(str_clipboard, i_pos + length(XML_PAGINA_LOGICA_BEFORE + XML_PAGINA_LOGICA_AFTER) + k - 1, MAXINT)
				end
			end;

			bo_exported_something := (str_clipboard <> '');
			// la (inutile) riga sottostante è stata commentata il 2019-09-08
//			if get_expint_profilo(i_profilo).bo_encode_UTF8 then str_clipboard := AnsiToUtf8(str_clipboard);	// non serve a un granché (per non dire che non serve a nulla)
			if bo_clipboard then begin
				str2Clipboard(str_clipboard);
//				MessageBBox(NIL, handle, 'Dati XML copiati sulla clipboard.' + ACAPO2 + 'Usa il comando  CTRL + V  per incollarli dove tu vuoi.', MBOX_CAPTION)
			end
			else begin
				system.assign(f, str_filename);rewrite(f);
				writeln(f, str_clipboard);
//				writeln(f, Utf8Encode(str_clipboard));
//				writeln(f, AnsiToUtf8(str_clipboard));
				system.close(f);
//				MessageBBox(NIL, handle, 'Dati XML salvati sul file' + ACAPO2 + str_filename, MBOX_CAPTION)
			end
		except
			error_msg(self, NIL, 'Errore durante la creazione del file ' + str_filename, MBOX_CAPTION);
			result := FALSE
		end
	end;

	function FTP_upload(str_source, str_target : string;exec_export_options : cl_exec_expint_options) : boolean;
	// esegue l'UPLOAD del file specificato sul server remoto; rende TRUE in caso di successo, FALSE altrimenti; emette eventuali specifici messaggi di errore
	begin
		var FTP : cl_FTP := NIL;
		result := FALSE;

(*		if (exec_export_options.FTP_parms.str_password = '') then begin
			FTP_impostazioni_proc(self, exec_export_options.FTP_parms, {executive_parms}TRUE);
			if (exec_export_options.FTP_parms.str_password = '') then exit
		end; *)

		try
			set_default_FTP_filelog(globale.str_filename);
			FTP := cl_FTP.create(self, exec_export_options.FTP_parms);
			set_default_FTP_filelog;
			try
				str_target := ExtractFilename(str_target);	// senza alcun path
				result := FTP.upload(str_source, exec_export_options.FTP_parms.str_remote_path, str_target, exec_export_options.writemode,
					'/',		// dovrebbe essere un parametro, ma è un valore fisso; sarebbe da sistemare
					NOT globale.bo_overwrite_file, TRUE);
				if NOT result then abort
			except
//				error_msg(handle, 'Errore durante la copia verso il server FTP', MBOX_CAPTION)
			end
		finally
			if (FTP <> NIL) then FTP.free
		end
	end;

	function conferma_spedizione_FTP : boolean;
	var s, str_error_message : string;	//*
	begin
		result := TRUE;
		if (exec_export_options.target <> EITT_FTP) then exit;
		if NOT globale.bo_FTP_conferma then exit;

		var str_caption := 'Trasferimento su FTP (' + globale.FTP_parms.str_host + ')';

		try
			result := FALSE;
			if (globale.str_FTP_password = '') then begin
				if (MessageBBox(NIL, handle, coalesce(globale.str_FTP_message, DEFAULT_FTP_CONFIRM_MESSAGE), str_caption, MB_QUESTION) <> IDYES)
					then exit
			end
			else begin
				if NOT input_text_proc(self, str_caption, coalesce(globale.str_FTP_message, 'Password trasferimento dati su server FTP'), s, {max_len}0, {pt_bo_back}NIL, IDS_PASSWORD)
					then exit;
				if (s <> globale.str_FTP_password) then begin str_error_message := 'Password non riconosciuta';exit end
			end;
			result := TRUE
		finally
			if NOT result then MessageBBox(NIL, handle, ifs(str_error_message, str_error_message + ACAPO2) + 'Trasferimento ANNULLATO', str_caption, MB_ICONSTOP)
		end
	end;

{	procedure set_target;
	// procedure che serve per assegnare il target; introdotta il 2013-04-28 per la creazione diretta di PDFs
	begin
		if (pt_lo_print_style = NIL) then exit;
		if (pt_lo_print_style^ AND GAL_POPT_PRINT_PRINTER <> 0) then begin target := RTA_PRINTER;exit end;
		if (pt_lo_print_style^ AND GAL_POPT_PDF <> 0) then begin target := RTA_PDF;exit end;
		if (pt_lo_print_style^ AND GAL_POPT_EMAIL <> 0) then begin target := RTA_PDF;exit end
//		if (pt_lo_print_style^ AND   <> 0) then begin target := RTA_EXPORT_INTEGRALE;exit end;
	end; }

	function get_filename(str_filename_assigned : string;i_pagina_fisica : ph_page_type = 0) : string;
	{ rigenera il nome del file di destinazione a partire dall'indicazione originale;
	  sotto le opportune condizioni genera nomifiles differenti in funzione della pagina/sezione da stampare }
	var s, str_filename_default, str_local_path : string;	//*
	begin
		if (target = RTA_PDF) AND (PDF_opt.behaviour in PDFH_MULTI_FILES) then begin
			str_filename_default := coalesce(get_page_main_record_filename(i_pagina_fisica), globale.str_export_filename, get_datetime_as_filename);

//			str_local_path := coalesce(ExtractFilePath(str_filename_default), str_target_path);		// se c'è un path esplicito nel filename, lo utilizzo
			str_local_path := ExtractFilePath(str_filename_default);				// se c'è un path esplicito nel filename, lo utilizzo
			if (str_local_path = '') then str_local_path := str_target_path;
			if (str_local_path = '') then str_local_path := globale.get_default_write_filepath({target_export}FALSE);

			result := make_filename(check_filename(ExtractFilename(str_filename_default), TRUE), str_local_path);
			result := ChangeFileExt(result, PDF_EXT)
		end
		else begin
{			str_filename_default := globale.get_default_export_filename;
			if (str_filename_default = '') then str_filename_default := get_datetime_as_filename
			else begin
				s := uppercase(ExtractFilePath(str_filename_default));
				if (s <> '') AND NOT DirectoryExists(s) then begin
					MessageBBox(NIL, handle, 'Stampa ANNULLATA !' + ACAPO2 + 'La cartella ' + s + ' non esiste o non è accessibile.',
						MBOX_CAPTION, MB_ICONSTOP);
					exit
				end
			end;
//			str_filename_default := check_filename(str_filename_default, TRUE);		// 2013-04-28 verifico che il nomefile sia utilizzabile
			// 2013-04-28 verifico che il nomefile sia utilizzabile
			result := make_filename(check_filename(ExtractFilename(str_filename_default), TRUE), ExtractFilePath(str_filename_default)); }
			result := str_filename_assigned;	// 2014-12-14: altrimenti non viene utilizzato il nome esplicitamente assegnato in PRINTER_SELECT

			// blocco aggiunto ex novo 2016-02-28 causa mancata applicazione della cartella default (in caso di indicazione non esplicita)
			if filename_has_explicit_path(result) then str_local_path := ExtractFilePath(result)
			else begin
				str_local_path := str_target_path;
				if (str_local_path = '') then str_local_path := globale.get_default_write_filepath({target_export}target = RTA_EXPORT)
			end;
			{$ifdef DEBUG} assert(str_local_path <> '', 'LOCAL_PATH non assegnato -- DJWK 3931'); {$endif}
			if (str_local_path <> '') then
				result := make_filename(check_filename(ExtractFilename(result), {allow_spaces}TRUE), str_local_path);

			case target of
				RTA_PDF : result := ChangeFileExt(result, PDF_EXT);				// garantisco che l'ext sia quella giusta
				RTA_EXPORT : begin
					s := uppercase(ExtractFileExt(result));
//					if (s = '') OR (s = PDF_EXT) then result := ChangeFileExt(result, ifs(target = xRTA_XML, XML_EXT, EITT_DEFAULT_FILE_EXT))
					if (s = '') OR (s = PDF_EXT) then result := ChangeFileExt(result, ifs(exec_export_options.bo_XML, LOWER_XML_EXT, EITT_DEFAULT_FILE_EXT))
				end
			end
		end
	end;

	procedure inizializza_PDF(str_filename : string;bo_autolaunch : boolean = FALSE);
	// inizializzo la stampa su file PDF
	begin
		print_report.PDF := PDF;
		PDF.Filename := str_filename;
		PDF_opt.write_properties(PDF);
		PDF.AutoLaunch := bo_autolaunch;
		PDF.info.Producer := 'GALATEO by Federico Callioni - www.feaci.it - federico@feaci.it';
		PDF.Info.Author := {$ifdef DLL} globale.str_author {$else} 'galateo' {$endif};
		PDF.info.Title := ExtractFilename(globale.str_filename);
//		add_delimited(str_PDF_filenames, str_filename, ACAPO)
	end;

	function exec_validazione(target : report_target_type;bo_email, bo_FTP : boolean) : boolean;
	begin
		var ctxs : validazione_context_set := [];
		case target of
			RTA_PRINTER, RTA_PDF : ctxs := ctxs + [VCTXT_PRINT];
			RTA_EXPORT : begin
				if exec_export_options.bo_XML then ctxs := ctxs + [VCTXT_XML];
				if exec_export_options.bo_export_integrale then ctxs := ctxs + [VCTXT_EXPORT_INTEGRALE]
			end
		end;
		if bo_email then ctxs := ctxs + [VCTXT_MAIL];
		if bo_FTP then ctxs := ctxs + [VCTXT_FTP];

		result := verifica_validazione(ctxs)
	end;

const MBOX_DEBUG_CAPTION = 'print_report.exec_print()';
label stampe_export, fine;
var
//	bo_stopped : boolean;
	i, j : integer;
	ix, iy : double;
	ii, jj, kk, i_pos_last_virtual_printed_page, i_pagine_stampate, i_pagine_totale : ph_page_type;
	i_pagina_logica_previous : logical_page_type;
	bo_changed_pagina_logica : boolean;		// TRUE sulla prima pagina fisica di ogni pagina logica (salvo la prima pagina fisica stampata)
	i_previous_length_10mm, id_cassetto_carta, i_PDF_orientation : smallint;
	i_sizex, i_sizey, i_size_temp : int_pixel_type;
	bo, bo_print, bo_stop, bo_printer_changed, bo_email, bo_newpage_setup, bo_started_doc, bo_was_visible : boolean;
	bo_checked_file_exist, bo_file_exists : boolean;
	bo_own_ww : boolean;		// TRUE se possiede la finestrella di dialogo con l'utente
	next_orientation, last_orientation : TPrinterOrientation;
	str_print_caption, str_main_printer, str_next_printer, str_previous_printer, str_next_cassetto, str_cassetto_previous : string;
	bo_exported_something, bo_impostazioni_cambiate : boolean;
	s, str_email_address : string;
	bo_need_advanced_config, bo_applica_always_stampante_main : boolean;
	str_watermark, str_previous_watermark : string;
	lo_print_style_temp : integer;
	str_temp_filename, str_FTP_temporary_filename : string;
	str_actual_target_filename : string;	// nome reale effettivo del file PDF che si deve creare; il nome può variare in base al contesto (sezione, pagina)
begin	// exec_print()
	try
		bo_printing_error_found := FALSE;
		init_Gdebug_SQL(globale.str_filename, 'ESECUZIONE STAMPA', {delete_previous_file}FALSE);		// delete_previous was TRUE until 2017-10-03
		last_orientation := poPortrait;		// esigenze di compilazione

		runtime_debug('start', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		// inizializzo con i valori default, altrimenti utilizzo quelli precedentemente utilizzati
		i_PDF_orientation := 0;
		i_previous_length_10mm := tm.i_phisical_10mm_height;lo_print_style_temp := 0;
		var xcanvas : TCanvas := NIL;		// ad usum compilatoris
		bo_applica_always_stampante_main := FALSE;
	//	PDF_opt := cl_PDF.assign(globale.PDF,TRUE);
	//	bo_stampa_diretta := cbx_print_diretta.Checked;
		str_actual_target_filename := globale.get_default_write_filename({target_export}FALSE);		// questa non è la versione definitiva, è solo una prima proposta
		exec_export_options.str_target_export_filename := globale.get_default_write_filename({target_export}TRUE);

		if (pt_lo_print_style = NIL) then pt_lo_print_style := @lo_print_style_temp;
		if cbx_print_diretta.Checked AND bo_comando_esplicito AND NOT (pt_lo_print_style^ in [GAL_POPT_DIRECTLY_EXECUTE, GAL_POPT_PDF, GAL_POPT_EMAIL])
		then pt_lo_print_style^ := GAL_POPT_DIRECTLY_EXECUTE;

		if bo_first_print AND bo_default_send_email AND ((pt_lo_print_style = NIL) OR (pt_lo_print_style^ AND GAL_POPT_EMAIL = 0)) AND NOT bo_silent_mode then begin
			case domanda_multipla_02_proc(self, MBOX_CAPTION,
				'La modalità standard di invio è per E-MAIL.' + ACAPO2 + 'Che tipo di stampa vuoi eseguire?', 2,
//				'Stampa normale', 'Invia per E-MAIL')	// STAMPA NORMALE: descrizione inadeguata quando stampo in formato PDF o altro
				'Normale', 'Invia per E-MAIL')
			of
				0 : exit;
				1 : ;
				2 : pt_lo_print_style^ := pt_lo_print_style^ OR GAL_POPT_EMAIL
			end
		end;
		bo_first_print := FALSE;

		Gdebug_SQL('filename=' + str_actual_target_filename + ' :: target=' + RTA_PRINT_TARGET_DESCRIZIONE[target], MBOX_DEBUG_CAPTION, TRUE);
		runtime_debug('010', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
//		if (PDF_opt.str_subject = '') then PDF_opt.str_subject := PDF_opt.str_PDF_filename;
//		if (globale.str_subject = '') then globale.str_subject := str_target_filename;
//		if (globale.str_subject = '') then globale.str_subject := coalesce(globale.str_descrizione_report, globale.str_filename);
		if (globale.str_subject = '') then globale.str_subject := str_actual_target_filename;		// se senza oggetto, uso il nome dell'allegato
//		sections(1,1).interpreta_string(globale.str_subject, TRUE, FALSE);
		sections_ZB(0, 0).interpreta_string(globale.str_subject, {stampa_vera}TRUE, {check_errors}FALSE);
//		if (globale.str_text <> '') then sections(1,1).interpreta_string(globale.str_text, TRUE, FALSE);
		if (globale.str_text <> '') then sections_ZB(0, 0).interpreta_string(globale.str_text, {stampa_vera}TRUE, {check_errors}FALSE);
		str_target_path := globale.str_default_export_filepath;
		if (str_target_path = '') then str_target_path := ExtractFilePath(str_actual_target_filename);

		runtime_debug('020', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		if (i_numero_stampa_multipla <= 1) AND (pt_lo_print_style^ AND GAL_POPT_DIRECTLY_EXECUTE = 0) AND NOT globale.bo_export_execute_automatically then begin
			i_numero_stampa_multipla := 1;
//			i_page_from := 1;i_page_to := i_total_phisical_pages;
			i_num_copie := globale.i_numero_copie_default;
			ival(i_pagina.Text, i, j);if (j <> 0) then begin beep(0);abort end;
			if (str_pagine_logiche = '') then begin
	//			str_pagine_logiche := '';
				for var i_plog_1B : logical_page_type := 1 to get_ultima_pagina_logica do if pagina_stampata(i_plog_1B) then begin
					if (target = RTA_EXPORT) then begin
						// per default propongo le pagine incluse nel PRIMO profilo di exportazione
						if get_expint_page_ZB({profilo}0, i_plog_1B - 1).bo_export_allowed
							then add_delimited(str_pagine_logiche, get_logical_page_1B(i_plog_1B).get_descrizione(TRUE))
					end
					else begin
						if get_logical_page_1B(i_plog_1B).bo_default_print_page
							then add_delimited(str_pagine_logiche, get_logical_page_1B(i_plog_1B).get_descrizione(TRUE))
					end
				end
			end;
			{$ifdef DEBUG} assert(str_pagine_logiche <> '', 'STR_PAGINE_LOGICHE non può essere blank -- KJPX 3991'); {$endif}
			str_pages_intervallo := get_intervallo_pagine_logiche(str_pagine_logiche);
			runtime_debug('030 pre select_printer_proc()', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
			bo_print := select_printer_proc(self, str_pages_intervallo, i_total_phisical_pages, i_num_copie, str_pagine_logiche, i, bo_printer_changed,
				target, str_actual_target_filename, str_target_path, TRUE, PDF_opt, exec_export_options, bo_email, str_email_address,
				bo_applica_always_stampante_main, pt_lo_print_style);
			runtime_debug('040 aft select_printer_proc()', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
			if NOT bo_print AND NOT bo_printer_changed then exit;	// nothing to do
			// se non sono state specificate pagine logiche da stampare, limito le pagini stampabili (operazione banale)
(*			if (str_pagine_logiche = '') then begin
				i_page_from := MAX(1, i_page_from);
				i_page_to := MIN(i_total_phisical_pages, i_page_to)
			end
			else begin
				{ se sono state specificate pagine logiche (potenzialmente NON consecutive), dò indicazione di stampare TUTTO,
				  riservandomi successivamente di limitare la stampa alle sole sezioni da trattare }
				i_page_from := 1;i_page_to := i_total_phisical_pages
			end *)
		end
		else begin
			if (i_numero_stampa_multipla = 0) then begin
{$ifdef DEBUG}
				assert((pt_lo_print_style^ AND GAL_POPT_DIRECTLY_EXECUTE <> 0) OR globale.bo_export_execute_automatically,
					'pt_lo_print_style^ != GAL_POPT_DIRECTLY_EXECUTE -- JPWT 9348');
{$endif DEBUG}
				i_num_copie := globale.i_numero_copie_default
			end;
			inc(i_numero_stampa_multipla);
//			bo_email := (pt_lo_print_style^ AND GAL_POPT_EMAIL) = GAL_POPT_EMAIL;		*** fino 2014-09-10
			bo_email := (pt_lo_print_style^ AND GAL_POPT_EMAIL <> 0);
			if bo_email then begin
//				str_email_address := globale.xxstr_email;
				str_email_address := globale.get_email_default;
				Gdebug_SQL('email=' + str_email_address, MBOX_DEBUG_CAPTION, TRUE);
				if (str_email_address = '') then begin
					MessageBBox(NIL, handle, 'E'' richiesto un indirizzo mail default', MBOX_CAPTION, MB_ICONSTOP);
					abort
				end
			end;
//			sections(1,1).interpreta_string(str_target_filename, TRUE, FALSE);
//			sections_ZB(0, 0).interpreta_string(str_target_filename, TRUE, FALSE);	**
//			str_target_filename_base := globale.get_default_export_filename(FALSE, 0);	// questa riga dovrebbe essere inutile, nome già assegnato sopra (osservazione del 2014-11-11)
			if (target = RTA_EXPORT) then str_actual_target_filename := exec_export_options.str_target_export_filename;
//			i_page_from := 1;i_page_to := i_total_phisical_pages;	// stampa sempre tutto
			str_pages_intervallo := '1-' + i_total_phisical_pages.ToString;		// stampa sempre tutto
			bo_print := TRUE
		end;
		set_caption(FALSE);	// imposto eventualmente un diverso titolo
		runtime_debug('050 pre select_printer_proc()', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);

		// 2021-06-29 le due righe qui sotto sono state modificate come più sotto
//		if NOT exec_validazione(target, bo_email, exec_export_options.target = EITT_FTP) then exit;
//		if NOT conferma_spedizione_FTP then exit;		// nel caso chiedo conferma della spedizione via FTP
		var bo_FTP := (target = RTA_EXPORT) AND (exec_export_options.target = EITT_FTP);
		if NOT exec_validazione(target, bo_email, bo_FTP) then exit;
		if bo_FTP AND NOT conferma_spedizione_FTP then exit;		// nel caso chiedo conferma della spedizione via FTP

		it_last_created_filenames.Clear;

		// se genero un file (PDF, oppure EXPINT_FILE, oppure (comunque!) email)
		if bo_email OR (target = RTA_PDF) OR ((target = RTA_EXPORT) AND (exec_export_options.target in EITT_FILE_TYPES)) then begin
//			str_actual_target_filename := get_filename(str_actual_target_filename, i_page_from);
			str_actual_target_filename := get_filename(str_actual_target_filename, get_intervallo_min(str_pages_intervallo));

			if bo_email OR ((pt_lo_print_style <> NIL) AND (pt_lo_print_style^ AND GAL_POPT_TEMPORARY_PATH <> 0)) // AND (pos('\', str_actual_target_filename) = 0)	// utilizzo una directory temporanea per non fare casino
				then str_actual_target_filename := get_temp_directory + ExtractFileName(str_actual_target_filename);

			bo_checked_file_exist := FALSE;bo_file_exists := FALSE;
			if NOT bo_email AND NOT globale.bo_overwrite_file then begin
				bo_checked_file_exist := TRUE;
				bo_file_exists := FileExists(str_actual_target_filename);
				if bo_file_exists AND
					(MessageBBox(NIL, get_handle, 'Il file ' + str_actual_target_filename + ' esiste già.' + ACAPO2 + 'Lo sovrascrivo?', MBOX_CAPTION, MB_QUESTION) <> IDYES)
						then exit
			end;
			// eseguo il (costoso) controllo del file esistente e lockato solo se necessario
			if (NOT bo_checked_file_exist OR bo_file_exists) AND
				NOT check_file_in_use(self, 'report <' + globale.str_filename + '>', str_actual_target_filename, {try_delete}TRUE, {try_change_name}TRUE)
			then begin
				MessageBBox(NIL, get_handle, 'Operazione annullata', MBOX_CAPTION, MB_ICONSTOP);
				exit
			end
		end;

		str_last_actual_target_filename := str_actual_target_filename;
		Gdebug_SQL('filename=' + str_actual_target_filename, MBOX_DEBUG_CAPTION, TRUE);
		if (target = RTA_PDF) then begin
			inizializza_PDF(str_actual_target_filename, {autolaunch}NOT bo_email AND (PDF_opt.behaviour = PDFH_OPEN_ACROBAT));
			it_last_created_filenames.Add(str_actual_target_filename)
		end;

		runtime_debug('060 pre select_printer_proc()', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
	//	if exec_export_options.bo_export_integrale then begin
		if (target = RTA_EXPORT) AND exec_export_options.bo_export_integrale then begin
			{$ifdef DEBUG} assert(export_integrale = NIL,'export_integrale <> NIL -- JHSG 9827'); {$endif}
			export_integrale := cl_exec_expint_main.create(exec_export_options);
//			if NOT exec_export_options.runtime_select_sections(self, i_page_from, i_page_to) then exit
			if NOT exec_export_options.runtime_select_sections(self, str_pages_intervallo) then exit
		end;

		str_last_printer_used := globale.str_current_printer;
		bo_was_visible := Visible;Visible := FALSE;
		try
			if //{$ifndef DEBUG} FALSE AND {$endif}
				globale.bo_autosize_page AND {(bo_printer_changed) AND} (i_previous_length_10mm <> tm.i_phisical_10mm_height)
			then begin
				runtime_debug('070 pre select_printer_proc()', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
				globale.autosize_printer_page;
				runtime_debug('075 pre select_printer_proc()', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
				impagina(FALSE);
				runtime_debug('080 pre select_printer_proc()', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
//				i_page_from := min(i_page_from, i_total_phisical_pages);i_page_to := min(i_page_to, i_total_phisical_pages);
				imposta_misure_pagina;
				runtime_debug('090 pre select_printer_proc()', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);

				// pare improbabile, ma le prossime istruzioni consentono alla stampante di settarsi ----------
				if orizzontale_ZB(get_pagina_logica_attiva_ZB) then next_orientation := poLandscape else next_orientation := poPortrait;
				printer.orientation := next_orientation;
				printer.canvas.TextWidth('A');
				// fine istruzioni improbabili ----------------------------------------------------------------

				draw
			end
			else imposta_misure_pagina;
			runtime_debug('100 pre select_printer_proc()', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
			if NOT bo_print then begin		// ho solo cambiato la stampante attiva
	//			self.SetFocus;
				exit
			end;

			bo_stop := FALSE;
	//		bo_own_ww := (dlg_working = NIL);
			bo_own_ww := NOT ww_exists;
			if bo_own_ww then begin
{				if (str_pagine_logiche = '') then i_pagine_totale := (i_page_to - i_page_from + 1)
				else begin
					i_pagine_totale := 0;
					for i := i_page_from to i_page_to do
						if exists_code(str_pagine_logiche, get_logical_page_1B(get_logical_page(i)].get_descrizione(TRUE)) then inc(i_pagine_totale)
				end; }
				i_pagine_totale := intervallo_count(str_pages_intervallo);
//				workwin := Tdlg_working.create_printing(self, TRUE, i_pagine_totale * i_num_copie, bo_stop);
				ww_create_printing(self, TRUE, i_pagine_totale * i_num_copie, bo_stop);
//				workwin.show
				ww_show
			end;
	//		bo_was_visible := visible;visible := FALSE;

//			if NOT tm.init_print_values({printer.handle,}globale.xstr_printer, TRUE) then abort;
			writeln_system_debug(0, MBOX_DEBUG_CAPTION, 'before init_print_values(' + globale.str_current_printer + ')');
			if NOT tm.init_print_values({printer.handle,}globale.str_current_printer, TRUE) then abort;
			writeln_system_debug(0, MBOX_DEBUG_CAPTION, 'after init_print_values(' + globale.str_current_printer + ')');

			xprint_status[i_job] := PS_PRINTING;
//			str_cassetto := globale.printer_default[0].str_cassetto;
//			str_printer_effettiva := globale.xstr_printer;
//			str_printer_effettiva := globale.str_current_printer;
//			{$ifdef DEBUG} assert(str_printer_effettiva <> '', 'stampante non assegnata correttamente'); {$endif}
			if (globale.str_current_printer = '') then globale.str_current_printer := str_stampante_predefinita;
			{$ifdef DEBUG} assert(globale.str_current_printer <> '', 'stampante non assegnata correttamente'); {$endif}
			if (globale.str_current_printer = '') then raise exception.create('Errore durante la selezione della stampante');
			i_pos_last_virtual_printed_page := 0;
			runtime_debug('110 pre select_printer_proc()', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
			try
				str_print_caption := ExtractFilename(globale.str_filename);
				if (pt_lo_print_style^ AND GAL_POPT_DIRECTLY_EXECUTE <> 0)
					then str_print_caption := str_print_caption + ' (' + i_numero_stampa_multipla.ToString + ')';
				printer.Title := str_print_caption;

				if (target = RTA_EXPORT) AND exec_export_options.bo_XML then goto stampe_export;		// se XML non stampo davvero, salto tutta la parte

				// dimensioni fisiche della pagina

//				if (globale.i_forced_width_10mm = 0) then i_PaperWidth_10mm := tm.i_phisical_10mm_width else i_PaperWidth_10mm := globale.i_forced_width_10mm;
//				if (globale.i_forced_height_10mm = 0) then i_PaperLength_10mm := tm.i_phisical_10mm_height else i_PaperLength_10mm := globale.i_forced_height_10mm;
				var i_PaperLength_10mm : integer := coalesce(globale.i_forced_width_10mm, tm.i_phisical_10mm_width);
				var i_PaperWidth_10mm : integer := coalesce(globale.i_forced_height_10mm, tm.i_phisical_10mm_height);

				// verifico se serve veramente la configurazione avanzata della stampante, che a volte crea qualche problema
				bo_need_advanced_config := (globale.str_current_tray <> '');
//				i := i_page_from;
				i := get_intervallo_min(str_pages_intervallo);
				var i_pagina_logica_1B : logical_page_type := -1;
//				while NOT bo_need_advanced_config AND (i <= i_page_to) do begin
				while NOT bo_need_advanced_config AND (i <> INTERVALLO_ERROR) do begin
					j := get_pagina_logica_of_pagina_fisica_1B(i);
					if (j <> i_pagina_logica_1B) then begin
						i_pagina_logica_1B := j;
						s := get_printer_page(i_pagina_logica_1B);
						if (s <> '') AND (printer.printers.indexof(s) <> -1) then	// se stampante specificata ed esistente
							bo_need_advanced_config := (get_cassetto_carta_page(i_pagina_logica_1B) <> '')
					end;
//					inc(i)
					i := intervallo_next(str_pages_intervallo, i)		// mi sposto sulla pagina successiva
				end;

				bo_newpage_setup := TRUE;bo_started_doc := FALSE;
				i_pagine_stampate := 0;i_pagina_logica_previous := 0;
				str_main_printer := globale.str_current_printer;		// stampante principale (e in genere unica)
				str_previous_printer := #255;		// valore impossibile, per obbligare ad eseguire l'assegnazione
//				str_cassetto_previous := #255;	// diverso da qualunque cosa
				str_cassetto_previous := '';		// cassetto predefinito: assegnazione da eseguire solo in presenza di valore positivamente specificato
				last_orientation := poLandscape;id_cassetto_carta := -1;	// ad uso e consumo del compiler
				runtime_debug('120 pre select_printer_proc()', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);

				i := get_intervallo_min(str_pages_intervallo);
//				for i := i_page_from to i_page_to do begin
				while (i <> INTERVALLO_ERROR) do begin
					runtime_debug('200 loop pagina ' + i.ToString, MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
					i_pagina_logica_1B := get_pagina_logica_of_pagina_fisica_1B(i);
					if (str_pagine_logiche <> '') AND NOT exists_code(str_pagine_logiche, get_logical_page_1B(i_pagina_logica_1B).get_descrizione(TRUE))
						then continue;

					// verifico se è stato eseguito un cambio di pagina logica
					bo_changed_pagina_logica := (i_pagina_logica_previous <> 0) AND (i_pagina_logica_1B <> i_pagina_logica_previous);
					i_pagina_logica_previous := i_pagina_logica_1B;

					runtime_debug('210 before set_pagina_logica_attiva()', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
					set_pagina_logica_attiva_1B(i_pagina_logica_1B, FALSE);
					runtime_debug('220 after set_pagina_logica_attiva()', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
					for j := 1 to i_num_copie do begin
						runtime_debug('230 loop -- copia=' + j.ToString + ' --stopped=' + bool2SQL(ww_stopped), MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
						if ww_stopped then abort;

						if (target in RTA_PRINT_TARGETS) then begin	// impostazioni della pagina di stampa: se EXPORT sostanzialmente non mi interessano
							runtime_debug('240', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);

							if globale.bo_pausa_pagina AND (i_pagine_stampate > 0) AND (target = RTA_PRINTER) then begin	// metto in pausa, ma solo se stampo su stampante fisica
								runtime_debug('245', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
								printer.EndDoc;	// chiudo la pagina precedente
								runtime_debug('246', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
								if (globale.i_durata_pausa_pagina_msec = 0) then begin
									if (MessageBBox(NIL, handle, coalesce(globale.str_pausa_pagina_message, 'BATTI OK PER CONTINUARE LA STAMPA'), MBOX_CAPTION, MB_YESNOCANCEL) = IDABORT) then abort
								end
								else sleep(globale.i_durata_pausa_pagina_msec);	// bisognerebbe fare un dialog figo per gestire l'attesa, ma adesso non ho tempo
								runtime_debug('248', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
								bo_newpage_setup := TRUE
							end;

							// verifica delle impostazioni della pagina
							if bo_applica_always_stampante_main then str_next_printer := str_main_printer
							else str_next_printer := uppercase(coalesce(get_printer_page(i_pagina_logica_1B), str_main_printer));		// determino la stampante da utilizzare per la pagina
							str_next_cassetto := '';
							if (uppercase(get_printer_page(i_pagina_logica_1B)) = uppercase(str_next_printer))
								then str_next_cassetto := get_cassetto_carta_page(i_pagina_logica_1B);
							if (str_next_cassetto = '') AND (uppercase(str_next_printer) = uppercase(str_main_printer))
								then str_next_cassetto := globale.str_current_tray;
							if orizzontale_1B(i_pagina_logica_1B) then next_orientation := poLandscape else next_orientation := poPortrait;

							runtime_debug('250', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
							if (str_next_cassetto <> str_cassetto_previous) then
								id_cassetto_carta := get_id_cassetto_carta(str_next_printer, str_next_cassetto);

							bo_impostazioni_cambiate := (str_next_printer <> str_previous_printer) OR
								(str_next_cassetto <> str_cassetto_previous) OR (last_orientation <> next_orientation);

							runtime_debug('260', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
							// messa in opera delle impostazioni
							if (i_pagine_stampate = 0) OR bo_impostazioni_cambiate then begin
								runtime_debug('261', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
								if (target = RTA_PRINTER) then begin
									runtime_debug('262', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
									if bo_print AND (i_pagine_stampate > 0) AND printer.printing then printer.EndDoc;	// chiudo la pagina precedente
									runtime_debug('263', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
									if (str_next_printer <> uppercase(printer.printers[printer.printerindex])) then begin
										runtime_debug('264', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
										printer.PrinterIndex := printer.printers.IndexOf(str_next_printer);
										writeln_system_debug(0, MBOX_DEBUG_CAPTION, 'before init_print_values printer=' + str_next_printer);
										if NOT tm.init_print_values({printer.handle,}str_next_printer, TRUE) then abort;		// 2011-07-25
										writeln_system_debug(0, MBOX_DEBUG_CAPTION, 'after init_print_values printer=' + str_next_printer);
										runtime_debug('265', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
										// dimensioni fisiche della pagina
										if (globale.i_forced_width_10mm = 0) then i_PaperWidth_10mm := tm.i_phisical_10mm_width
										else i_PaperWidth_10mm := globale.i_forced_width_10mm;
										runtime_debug('266', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
										if (globale.i_forced_height_10mm = 0) then i_PaperLength_10mm := tm.i_phisical_10mm_height
										else i_PaperLength_10mm := globale.i_forced_height_10mm
									end;

									if NOT check_printer_page_size(self, i_pagina_logica_1B, i_PaperWidth_10mm, i_PaperLength_10mm) then
										raise exception.create('Le dimensioni della pagina della stampante <' + str_next_printer + '> non sono conformi alle prescrizioni');
									runtime_debug('267', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
//									printer.Orientation := next_orientation;
//									set_printer_orientation(printer, next_orientation);	***
									try
										printer.Orientation := next_orientation;
										runtime_debug('268 orientation ok', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01)
									except
										runtime_debug('268 required advanced configuration', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
										bo_need_advanced_config := TRUE
									end;
									runtime_debug('268', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01)
								end;
								runtime_debug('269', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
								if (next_orientation = poPortrait) then i_PDF_orientation := 0 else i_PDF_orientation := 90;
								str_previous_printer := str_next_printer;
								str_cassetto_previous := str_next_cassetto;
								last_orientation := next_orientation;
								bo_newpage_setup := TRUE
							end;

							runtime_debug('270', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
							if bo_print then begin
								runtime_debug('271', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
								if (target = RTA_PDF) then str_watermark := coalesce(get_logical_page_1B(i_pagina_logica_1B).str_PDF_watermark, PDF_opt.str_PDF_watermark);
								runtime_debug('272', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
								i_sizex := printer.PageWidth;i_sizey := printer.PageHeight;
								runtime_debug('273', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
								if (next_orientation = poLandscape) then begin i_size_temp := i_sizex;i_sizex := i_sizey;i_sizey := i_size_temp end;
								runtime_debug('275', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
								if bo_newpage_setup then begin
									runtime_debug('277', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
									// nel caso eseguire sempre, perchè non si sa in che stato si trova la stampante
									if (target = RTA_PDF) then begin
										if bo_started_doc then PDF.EndPage
										else begin
											if (str_watermark <> '') then begin PDF.InputFile := str_watermark;PDF.InputFileMode := wpConvertInputToWatermark end;
											try
												PDF.BeginDoc
											except
												error_msg(self, NIL, 'Errore durante la creazione del file' + ACAPO2 + str_actual_target_filename, MBOX_CAPTION);
												abort
											end
										end;
										PDF.StartPage(i_sizex, i_sizey, printer.resx, printer.resy, i_PDF_orientation);
(*	PDF.StartWatermark('WMX', i_sizex, i_sizey, printer.resx, printer.resy{, i_PDF_orientation});
	PDF.Canvas.MoveTo(10,10);PDF.Canvas.LineTo(100,10);PDF.Canvas.LineTo(100,100);PDF.Canvas.LineTo(10,100);PDF.Canvas.LineTo(10,10);PDF.Canvas.LineTo(100,100);
	PDF.EndWatermark;	*)
										if (str_watermark <> '') then PDF.UseWatermark('inpage1');	// 'inpage' + i.ToString
										SaveDC(PDF.Canvas.Handle)
									end
									else begin
										if bo_need_advanced_config AND NOT
											advanced_printer_configuration(TRUE, next_orientation, id_cassetto_carta, i_PaperWidth_10mm, i_PaperLength_10mm)
												then abort;
//										if NOT bo_started_doc then	// riga aggiunta il 2005-09-06, commentata il 2005-09-19
											if globale.bo_text_only then text_only_BeginDoc else printer.BeginDoc
									end;
									bo_started_doc := TRUE
								end
								else begin
									runtime_debug('278', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
									if (target = RTA_PDF) then begin
										PDF.EndPage;
										if ((PDF_opt.behaviour = PDFH_SAVE_SINGLE_RECORD) AND
											 start_end_main_record_page({pagina_fisica_relativa}i - get_first_pagina_fisica_of_pagina_logica(i_pagina_logica_1B) + 1, {start}TRUE)) OR
											((PDF_opt.behaviour = PDFH_SAVE_LOGICAL_PAGE) AND bo_changed_pagina_logica)
										then begin
											PDF.EndDoc;
											s := get_filename(str_actual_target_filename, {pagina_fisica}i);
											if (it_last_created_filenames.Indexof(s) <> -1) then begin
												MessageBBox(NIL, handle,
													'Il nome del file su cui deve essere salvata la pagina ' + i.ToString + ' (' + s + ') è già stato utilizzato',
													MBOX_CAPTION, MB_ICONSTOP);
												abort
											end;
											it_last_created_filenames.Add(s);
											inizializza_PDF(s);
											PDF.BeginDoc
										end;
										PDF.StartPage(i_sizex, i_sizey, printer.resx, printer.resy, i_PDF_orientation)
//										if (str_previous_watermark = '') then PDF.EndPage else pdf.EndWatermark;
//										if (str_watermark = '') then PDF.StartPage(i_sizex, i_sizey, printer.resx, printer.resy, i_PDF_orientation)
//										else PDF.StartWatermark(str_watermark,i_sizex, i_sizey, printer.resx, printer.resy{, i_PDF_orientation})
									end
									else begin
										if globale.bo_text_only then text_only_newpage else printer.newpage
									end
								end;
								str_previous_watermark := str_watermark
							end;

							if (target = RTA_PDF) then xcanvas := PDF.Canvas else xcanvas := printer.canvas
						end;

						runtime_debug('280', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
						case globale.tiporeport of
							TR_REPORT : print_page(print_pages_1B[i_pagina_logica_1B], i, NOT bo_print, canvas, xcanvas,
//								get_page_marg_SX_cm(i_pagina_logica_1B), get_page_marg_UP_cm(i_pagina_logica_1B),
								get_page_marg_SX_cm_ZB(i_pagina_logica_1B - 1), get_page_marg_UP_cm_ZB(i_pagina_logica_1B - 1),
								target, (target = RTA_EXPORT) AND exec_export_options.bo_export_integrale);
							TR_LABEL_REPORT : begin
								{$ifdef DEBUG} assert(target <> RTA_EXPORT, 'KJHP 8927'); {$endif}
								ix := get_label_size_X_cm + tm.r_delta_labs_X_cm;
								iy := get_label_size_Y_cm + tm.r_delta_labs_Y_cm;
								for ii := 0 to tm.i_lab_per_page - 1 do begin
									for jj := 0 to tm.i_lab_per_row - 1 do begin
										kk := (i - 1) * i_virtual_pages_per_phpage + (ii * tm.i_lab_per_row) + jj + 1;
										if (kk > i_total_virtual_pages) then break;
										print_page(print_pages_1B[i_pagina_logica_1B], kk, NOT bo_print, canvas, xcanvas,
//											get_page_marg_SX_cm(i_pagina_logica_1B) + jj*ix, get_page_marg_UP_cm(i_pagina_logica_1B) + ii*iy,
											get_page_marg_SX_cm_ZB(i_pagina_logica_1B - 1) + jj*ix, get_page_marg_UP_cm_ZB(i_pagina_logica_1B - 1) + ii*iy,
											RTA_PRINTER, (target = RTA_EXPORT) AND exec_export_options.bo_export_integrale);
										i_pos_last_virtual_printed_page := kk
									end
								end
							end
							{$ifdef DEBUG} else assert(FALSE,'tiporeport wrong -- DRAWING -- JSMN 2981') {$endif}
						end;

						runtime_debug('290', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
						ww_printed_another_one;
						inc(i_pagine_stampate);bo_newpage_setup := FALSE
					end;
					runtime_debug('299 fine loop -- ' + j.ToString, MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
					i := intervallo_next(str_pages_intervallo, i)		// mi sposto sulla pagina successiva
				end;
				runtime_debug('300 aft end of loop', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);

				if bo_print then begin
stampe_export:
					runtime_debug('400 BO_PRINT', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
					if (exec_export_options.target = EITT_FTP) then begin
						{ preparo il nomefile temporaneo per l'exportazione; sarà poi travasato nel nomefile definitivo;
						  in caso di trasferimento via FTP è possibile che il file generato abbia un nome DIVERSO da quello trasmesso via FTP;
						  in particolare il file generato può essere marcato univocamente con DATA-ORA (per renderlo univoco, e per storicizzare l'exportazione),
						  mentre quello definitivo resta comunque il nome specificato nelle opzioni o dall'utente }
						runtime_debug('410 EXPINT target FTP', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
						if (exec_export_options.FTP_parms.str_local_temporary_path = '') then begin
							s := get_temp_directory;bo := TRUE
						end
						else begin
							s := exec_export_options.FTP_parms.str_local_temporary_path;
							bo := exec_export_options.FTP_parms.bo_storicizza_local_filename;
							if NOT DirectoryExists(s) then
								raise exception.create('Impostazioni FTP: il path locale di exportazione non esiste o non è accessibile: <' + s + '>')
						end;
						runtime_debug('420 EXPINT target FTP', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
						str_FTP_temporary_filename := make_filename(ifs(bo, get_datetime_as_filename + '-') +
							extractFilename(coalesce(str_actual_target_filename, globale.str_filename)), s);
						s := uppercase(ExtractFileExt(str_FTP_temporary_filename));
						if (s = '') OR (s = uppercase(GALATEO_EXT)) then
//							str_FTP_temporary_filename := ChangeFileExt(str_FTP_temporary_filename, ifs(target = xRTA_XML, XML_EXT, TXT_EXT))
							str_FTP_temporary_filename :=
								ChangeFileExt(str_FTP_temporary_filename, ifs((target = RTA_EXPORT) AND exec_export_options.bo_XML, lower_XML_EXT, TXT_EXT))
					end;

					runtime_debug('430 EXPINT target', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
					case target of
						RTA_PRINTER : begin
							if globale.bo_text_only then text_only_EndDoc else printer.EndDoc;
							// rimetto il foglio standard, per evitare casini futuri
							if (last_orientation = poLandscape) then printer.Orientation := poPortrait
						end;
						RTA_PDF : begin
							runtime_debug('450 PDF', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
							PDF.EndPage;
							runtime_debug('452 PDF', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
							PDF.EndDoc
						end;
						RTA_EXPORT : begin
							runtime_debug('460 EXPORT', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
							ww_set_text('fase di exportazione dati');
							str_temp_filename := coalesce(str_FTP_temporary_filename, str_actual_target_filename);
							if exec_export_options.bo_XML then begin
								if NOT execute_XML_export(self, exec_export_options.i_profilo, (exec_export_options.target = EITT_CLIPBOARD), str_temp_filename,
									globale.bo_overwrite_file, bo_exported_something)
										then raise exception.create('Errore durante l''esecuzione dell''exportazione XML')
							end
							else begin		// export integrale
								if NOT export_integrale.execute_export(self, str_temp_filename, globale.bo_overwrite_file, bo_exported_something)
									then raise exception.create('Errore durante l''esecuzione dell''exportazione integrale')
							end;
							globale.str_last_exported_filename := str_temp_filename;
							runtime_debug('465 EXPORT', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
							if NOT bo_exported_something then begin
								MessageBBox(NIL, handle, 'Non vi sono pagine logiche/sezioni exportabili', MBOX_CAPTION, MB_ICONSTOP);
								abort
							end;

							// segnalo il file generato o cerco di cancellarlo
							if (exec_export_options.target = EITT_FTP) AND (exec_export_options.FTP_parms.str_local_temporary_path = '')
								then delete_filename_ASAP(str_temp_filename)	// non viene eliminato subito, ma solo al prossimo riavvio
							else it_last_created_filenames.Add(str_temp_filename);

							runtime_debug('467 EXPORT', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
							if (exec_export_options.target = EITT_FTP) AND
								NOT FTP_upload({str_temp_filename}str_FTP_temporary_filename, str_actual_target_filename, exec_export_options)
							then begin
								MessageBBox(NIL, handle, 'Errore durante la copia verso il server FTP (' + exec_export_options.FTP_parms.str_host + ')',
									MBOX_CAPTION, MB_ICONSTOP);
								abort
							end;

							runtime_debug('468 EXPORT', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
							if NOT bo_email then begin
//								if (globale.str_message_after <> '') OR (exec_export_options.target = EITT_CLIPBOARD) then begin
								s := togliblanks(get_expint_profilo(exec_export_options.i_profilo).str_message_after);
								if (s <> '') OR (exec_export_options.target = EITT_CLIPBOARD) then begin
									s := coalesce(s, 'Output copiato sulla clipboard.' + ACAPO2 + 'Per incollarlo dove tu vuoi usa  CTRL + V');
									MessageBBox(NIL, handle, s, MBOX_CAPTION)
								end;

								if (exec_export_options.target = EITT_FILE) AND NOT silent_mode then begin		// nessuna azione da eseguire se SILENT_MODE
//									if (exec_export_options.EFAT_action = EFAT_COMANDO_SPECIFICO) AND (exec_export_options.str_comando_specifico = '') then exec_export_options.EFAT_action := EFAT_OPEN;
									case exec_export_options.EFAT_action of
										EFAT_NOTHING : ;
										EFAT_CREATE: if (togliblanks(get_expint_profilo(exec_export_options.i_profilo).str_message_after) = '')
											then MessageBBox(NIL, handle, 'Output esportato sul file ' + str_actual_target_filename, MBOX_CAPTION);
										EFAT_CREATE_OPEN : begin
											execute_data_file(handle, {debug}FALSE, str_actual_target_filename, {str_path}'', {wait}FALSE);
											sleep(700)	// lascio aprire il file/ partire il programma
										end;
										EFAT_FOLDER : if (str_actual_target_filename <> '') then	// se BLANK è stato creato il file SELF.str_filename con estensione TXT
											explorer_select_filename(handle, str_actual_target_filename);
(*										EFAT_COMANDO_SPECIFICO : WinExecAndWait32(exec_export_options.str_comando_specifico, {debug}FALSE, {Visibility}0,
												{wait}FALSE	{, str_work_directory : string = '';str_params : string = '';bo_message_on_error : boolean = TRUE;
												bo_execute_datafile : boolean = FALSE}); *)
										{$ifdef DEBUG} else assert(FALSE, 'DJHW 9391 -- EFAT_xxxxxxx') {$endif}
									end
								end;

								if (exec_export_options.str_comando_specifico <> '') then begin
									if (WinExecAndWait32(exec_export_options.str_comando_specifico, {debug}FALSE, {Visibility}0, {wait}FALSE,
	//									{, str_work_directory : string = '';str_params : string = '';bo_message_on_error : boolean = TRUE;bo_execute_datafile : boolean = FALSE}) = -1)
										{str_work_directory}'', {str_params}'', {message_on_error}FALSE, {execute_datafile}FALSE) = -1)
									AND (WinExecAndWait32(exec_export_options.str_comando_specifico, {debug}FALSE, {Visibility}0, {wait}FALSE,
										{str_work_directory}'', {str_params}'', {message_on_error}FALSE, {execute_datafile}TRUE) = -1)
									then MessageBBox(NIL, handle, 'Impossibile eseguire il comando' + ACAPO2 + exec_export_options.str_comando_specifico,
										MBOX_CAPTION, MB_ICONSTOP)
								end
							end
						end;
						{$ifdef DEBUG} else assert(FALSE, 'WRONG TARGET -- KWUI 8982') {$endif}
					end
				end;

				runtime_debug('600', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
				globale.str_last_exported_filename := str_actual_target_filename;
				if (target = RTA_PDF) AND NOT silent_mode AND NOT bo_email AND (pt_lo_print_style^ AND GAL_POPT_EFAT_NOTHING = 0) AND
					(pt_lo_print_style^ AND GAL_POPT_DIRECTLY_EXECUTE = 0)
				then begin
					case PDF_opt.behaviour of
						PDFH_SAVEONLY : messagebbox(NIL, 0, 'Report salvato su' + ACAPO2 + str_actual_target_filename, MBOX_CAPTION);
						PDFH_OPEN_ACROBAT : {autolaunch};	//  execute_data_file(handle,TRUE,PDF_opt.str_PDF_filename);
//						PDFH_OPEN_FOLDER : execute_data_file(handle,TRUE,extractFilepath(PDF_opt.str_PDF_filename));
						PDFH_OPEN_FOLDER : explorer_select_filename(handle, str_actual_target_filename);
						PDFH_SAVE_SINGLE_RECORD, PDFH_SAVE_LOGICAL_PAGE : begin
							if (it_last_created_filenames.Count = 1) then
								messagebbox(NIL, 0, 'Report salvato su' + ACAPO2 + str_actual_target_filename, MBOX_CAPTION)
							else messagebbox(NIL, 0, it_last_created_filenames.Count.ToString + ' files salvati su ' + str_target_path + ACAPO2 +
								get_elenco_files_generati, MBOX_CAPTION);
							explorer_open_folder(handle, str_target_path)
						end;
						{$ifdef DEBUG} else assert(FALSE,'PDF_behaviour non previsto -- KMCE 8328'); {$endif}
					end
				end;
				if bo_email then
					send_email(str_email_address, str_actual_target_filename, (pt_lo_print_style^ AND GAL_POPT_DIRECTLY_EXECUTE = 0) AND NOT silent_mode)
			except
				runtime_debug('EXCEPT pre stop=TRUE error=<' + get_last_exception_msg + '>', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
				error_msg(self, NIL, 'Errore durante l''esecuzione', MBOX_CAPTION);
				bo_stop := TRUE
			end;
			runtime_debug('800', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
			if bo_stop then begin
				runtime_debug('810 stopped', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
				if ww_stopped then xprint_status[i_job] := PS_CANCELLED else xprint_status[i_job] := PS_ERROR;
				try
					if bo_print then
						if globale.bo_text_only then text_only_abort else printer.abort
				except
				end
			end
			else begin
				runtime_debug('520 NOT stopped', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
				if (target = RTA_PRINTER) then
					label_write_ultima_posizione_stampa(globale.str_current_printer, globale.str_formato_label,
						i_pos_last_virtual_printed_page mod i_virtual_pages_per_phpage);
				xprint_status[i_job] := PS_OK
			end;

fine:
			runtime_debug('900 FINE', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
			set_pagina_logica_attiva_1B(i_active_logical_page_1B, FALSE);
			if bo_own_ww then begin
	//			workwin.chiudi_finestra;workwin.free
				ww_close
			end;
			if bo_stop then begin
				MessageBBox(NIL, get_handle, 'Stampa interrotta', MBOX_CAPTION, MB_ICONINFORMATION OR MB_LOG_EVENT);
				if NOT bo_print then close	// stavo rigenerando la stampa, ma sono stato interrotto
			end
		finally
			runtime_debug('990 FINALLY', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
			if (export_integrale <> NIL) then begin
				export_integrale.free;
				export_integrale := NIL
			end;
			visible := bo_was_visible
		end;
		runtime_debug('999 END', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01)
	finally
		result := NOT bo_stop;
		print_report.PDF := NIL;
		enable_file_menuitems;
		end_Gdebug_SQL;		// chiude il DEBUG
		if NOT bo_comando_esplicito AND bo_printing_error_found then close
	end
end;

procedure Tdlg_print_report.check_timer_after_create;
begin
	if globale.bo_export_proponi OR (lo_print_style AND (GAL_POPT_PRINT_PRINTER OR GAL_POPT_DIRECTLY_EXECUTE) <> 0) then begin
//		if (globale.str_expint_msg_before <> '') then MessageBBox(handle, globale.str_expint_msg_before, MBOX_CAPTION);
		timer.Enabled := TRUE;
		Visible := FALSE
	end
end;

procedure Tdlg_print_report.timerTimer(Sender : TObject);
begin
	timer.Enabled := FALSE;
	if globale.bo_export_proponi OR (lo_print_style AND (GAL_POPT_PRINT_PRINTER OR GAL_POPT_DIRECTLY_EXECUTE) <> 0) OR silent_mode
		then exec_print(@lo_print_style, {comando_esplicito}FALSE);
	if (lo_print_style AND (GAL_POPT_PRINT_PRINTER OR GAL_POPT_DIRECTLY_EXECUTE) <> 0) OR	// può essere stato cambiato
		globale.bo_export_execute_automatically
			then Close
	else Visible := TRUE
end;

// -----------------------------------------------------------------------------

procedure Tdlg_print_report.indexClick(Sender : TObject); begin goto_selected_record end;
procedure Tdlg_print_report.indexChange(Sender: TObject; Node: TTreeNode); begin goto_selected_record end;

procedure Tdlg_print_report.show_index(bo_show: boolean);
begin
	if NOT globale.bo_create_index then bo_show := FALSE;
	split_index.Visible := bo_show;
	index_panel.Visible := bo_show;
	if (bo_show <> sb_index.Down) then begin
		sb_index.Down := bo_show;
		if bo_show then select_index_of_page
	end
end;

constructor cl_index_info.create(lo_id: integer;i_pagina_logica: logical_page_type; i_pagina_fisica: ph_page_type);
begin
	{$ifdef DEBUG} inc(lo_index_info); {$endif}
	self.lo_id := lo_id;
	self.i_pagina_logica := i_pagina_logica;
	self.i_pagina_fisica := i_pagina_fisica
end;

{$ifdef DEBUG} destructor cl_index_info.free; begin dec(lo_index_info) end; {$endif}

procedure Tdlg_print_report.create_index;
var
	j : smallint;
	i_logical_page_1B : logical_page_type;
//	i_skip_main_section : smallint;
	pp : cl_print_page;
	sv : cl_print_section;
	sr : array[0..MAX_SECTIONS] of TtreeNode;
	// i_skip_section[i] contiene il numero di sezioni prive di indice che precedono la sezione I; la prima sezione (principale) è la sezione 1
	i_skip_section : array[0..MAX_SECTIONS] of byte;
	bo_skip_main_record, bo_new_logical_page : boolean;
begin
	try
		index.Items.clear;
		index.ShowRoot := FALSE;
		for j := 0 to MAX_SECTIONS do sr[j] := NIL;

		if NOT globale.bo_create_index then begin
			show_index(FALSE);
			exit
		end;

		for i_logical_page_1B := 1 to get_ultima_pagina_logica do begin
			if get_logical_page_1B(i_logical_page_1B).bo_dont_print then continue;
			if NOT pagina_stampata(i_logical_page_1B) then continue;		// pagina logica non stampata, non genero l'index
			if (get_ultima_pagina_logica > 1) then begin
				sr[0] := index.Items.Add(NIL, get_logical_page_1B(i_logical_page_1B).get_descrizione(TRUE));
//				sr[0].Data := pointer(i_logical_page_1B)
				sr[0].Data := cl_index_info.create({lo_id}0, i_logical_page_1B, get_first_pagina_fisica_of_pagina_logica(i_logical_page_1B))
			end
			else sr[0] := NIL;
			pp := print_pages_1B[i_logical_page_1B];
			bo_skip_main_record := (togliblanks(sections_1B(1, i_logical_page_1B).tsql_command.Text) = '');
			bo_new_logical_page := TRUE;		// vero all'inizio di ogni pagina logica
			fillchar(i_skip_section, sizeof(i_skip_section), 0);
			if bo_skip_main_record then i_skip_section[2] := 1;
//			i_skip_main_section := byte(bo_skip_main_record);
			while (pp <> NIL) do begin
				sv := pp.sections;
				while (sv <> NIL) do begin
					if (NOT bo_skip_main_record OR (sv.i_section_1B <> 1)) AND
						(sections_1B(sv.i_section_1B, i_logical_page_1B).str_field_codice_record <> '')
					then begin
						j := sv.i_section_1B - i_skip_section[sv.i_section_1B];
						{ l' IF è stato aggiunto l'2005-09-18;
						  il contenuto dell'IF esisteva già; l'IF serve per evitare che un record che va su più pagine abbia più riferimenti nell'index }
						if bo_new_logical_page OR (sr[j] = NIL) OR (sv.str_value_codice_record <> sr[j].Text) {OR (pointer(sv.xxlo_id) <> sr[j].data)} then begin
							sr[j] := index.Items.AddChildObject(sr[j - 1], coalesce(sv.str_value_codice_record, '(nessuna descrizione)'),
//								pointer(sv.lo_id))
								cl_index_info.create(sv.lo_id, i_logical_page_1B, sv.i_ph_page_start))
						end
					end
					else begin
						for j := sv.i_section_1B + 1 to MAX_SECTIONS do
							i_skip_section[j] := i_skip_section[sv.i_section_1B] + 1
					end;
					sv := sv.next
				end;
				bo_new_logical_page := FALSE;
				pp := pp.next
			end
		end
	except
		index.Items.clear;
		error_msg(self, NIL, 'Errore durante la generazione dell''indice', MBOX_CAPTION)
	end
end;

{procedure Tdlg_print_report.free_index;			*** operazione già svolta sulla indexDeletion()
var
	i : integer;
	li : cl_index_info;
begin
	for i := 0 to index.Items.Count-1 do begin
		li := cl_index_info(index.Items[i].data);
		if (li <> NIL) then begin li.free;index.Items[i].data := NIL end
	end
end;}

procedure Tdlg_print_report.indexDeletion(Sender: TObject;Node: TTreeNode);
begin
	if (node.data <> NIL) then begin
		cl_index_info(node.data).free;
		node.data := NIL
	end
end;

procedure Tdlg_print_report.goto_selected_record;
var pp : cl_print_page;	//*
begin
	if bo_setting_index then exit;
	try
		bo_setting_index := TRUE;
		if (index.Selected = NIL) then begin beep;exit end;
//		lo_id := integer(index.selected.data);
		var info : cl_index_info := cl_index_info(index.selected.data);
		if (get_ultima_pagina_logica > 1) AND (index.selected.level = 0) then begin
//			pp := print_pages[integer(index.Selected.data)];
			pp := print_pages_1B[info.i_pagina_logica];
			if (pp = NIL) then MessageBBox(NIL, get_handle, 'Pagina non stampata perchè vuota', MBOX_CAPTION)
			else goto_phisical_page(get_pagina_fisica_of_pagina_virtuale(pp.i_virtual_page_1B));
			exit
		end;

		var sv : cl_print_section := NIL;
		var lo_id := info.lo_id;
		for var i_logical_page_1B : logical_page_type := 1 to get_ultima_pagina_logica do begin
			pp := print_pages_1B[i_logical_page_1B];
			while (pp <> NIL) AND (sv = NIL) do begin
				sv := pp.sections;
				while (sv <> NIL) AND (sv.lo_id <> lo_id) do sv := sv.next;
				if (sv <> NIL) then begin
					var i_page_1B := pp.i_virtual_page_1B;
					if (i_page_1B <> i_active_phisical_page) then goto_phisical_page(get_pagina_fisica_of_pagina_virtuale(i_page_1B));
					exit
				end;
				pp := pp.next
			end
		end
	finally
		bo_setting_index := FALSE
	end
end;

procedure Tdlg_print_report.select_index_of_page;
// seleziona la prima voce di indice relativa alla pagina corrente (I_ACTIVE_PHISICAL_PAGE)
begin
	if NOT index_panel.Visible then exit;
	if bo_setting_index then exit;

	try
		bo_setting_index := TRUE;
		try
			if (index.Items.Count = 0) then exit;
			var tt : TTreenode := index.Items[0];
			while (tt <> NIL) AND (cl_index_info(tt.Data).i_pagina_fisica < i_active_phisical_page) do tt := tt.GetNext;
			if (tt <> NIL) then begin
				var info : cl_index_info := cl_index_info(tt.Data);
				// se ho beccato il record che indica la pagina logica, mi sposto sul primo record appartenente alla pagina (se esiste)
				if (info.i_pagina_fisica = i_active_phisical_page) AND (info.lo_id = 0) AND
					(tt.GetNext <> NIL) AND (cl_index_info(tt.GetNext.data).i_pagina_fisica = i_active_phisical_page)
						then tt := tt.GetNext;
				if (info.i_pagina_fisica > i_active_phisical_page) then tt := tt.GetPrev
			end;
			if (tt <> NIL) then begin tt.selected := TRUE;exit end;

(*			for i_logical_page := 1 to get_ultima_pagina_logica do begin
				// trovo l'ID della pagina fisica visualizzata (o meglio: del primo record/ della prima pagina virtuale)
				pp := print_pages_1B[i_logical_page];
				while (pp <> NIL) AND (get_pagina_fisica_of_pagina_virtuale(pp.i_virtual_page) <> i_active_phisical_page) do pp := pp.next;
				// vado a cercare sull'indice l'elemento corrispondente all'ID trovato
				if (pp <> NIL) then begin
					lo_id := pp.sections.lo_id;
					tt := index.Items[0];//ttl := NIL;
					while (tt <> NIL) AND (integer(tt.Data) < lo_id) do begin {ttl := tt;}tt := tt.GetNext end;
//					if (tt = NIL) then tt := ttl;			commentata il 2006-02-28 perchè sballa *SEMPRE* l'attribuzione della pagina -- forse serviva per la stampa del LABEL-REPORT
					if (tt <> NIL) AND (integer(tt.Data) > lo_id) then tt := tt.GetPrev;
					if (tt <> NIL) then begin
						tt.Selected := TRUE;
						exit
					end;

					// non trovo il record: mi posiziono quanto meno sulla pagina logica di pertinenza
					if (get_ultima_pagina_logica > 1) then begin
						tt := index.Items[0];
						while (tt <> NIL) AND (integer(tt.Data) <> i_logical_page) do tt := tt.GetNextSibling;
						if (tt <> NIL) {AND (print_pages_1B[integer(tt.data)].i_phisical_page = i_active_phisical_page)} then begin
							tt.Selected := TRUE;
							exit
						end
					end;
					exit
				end
			end *)
		except
//			{$ifdef DEBUG} error_msg(NIL, get_handle, '*** SOLO PROVA *** SELECT_INDEX_OF_PAGE()', MBOX_CAPTION) {$endif}
			{$ifdef DEBUG} error_msg(father, NIL, '*** SOLO PROVA *** SELECT_INDEX_OF_PAGE()', MBOX_CAPTION) {$endif}
		end
	finally
		bo_setting_index := FALSE
	end
end;

// -----------------------------------------------------------------------------

procedure Tdlg_print_report.imageClick(Sender : TObject);
begin
	if index_panel.Visible then ActiveControl := NIL
end;

procedure Tdlg_print_report.pbox_extClick(Sender : TObject);
begin
	if index_panel.Visible then ActiveControl := NIL
end;

procedure Tdlg_print_report.AL_print_PDFExecute(Sender : TObject);
begin
	var lo : integer := GAL_POPT_PDF;
	target := RTA_PDF;
	exec_print(@lo, {comando_esplicito}TRUE)
end;

procedure Tdlg_print_report.AL_print_mailExecute(Sender : TObject);
begin
	var lo : integer := GAL_POPT_EMAIL;
	target := RTA_PDF;	// 2014-11-24
	exec_print(@lo, {comando_esplicito}TRUE)
end;

procedure Tdlg_print_report.sb_indexClick(Sender : TObject);
begin
	if NOT bo_activated then exit;
	show_index(sb_index.Down)
end;

procedure Tdlg_print_report.blink_timer_proc(Sender : TObject);
begin
	var xp : cl_logical_page_info := get_logical_page_ZB(get_pagina_logica_attiva_ZB);
	if (sbox.Color = xp.i_colore_base) then sbox.Color := xp.i_colore_alt else sbox.Color := xp.i_colore_base
end;

procedure Tdlg_print_report.check_blinking;
begin
	if (get_logical_page_ZB(get_pagina_logica_attiva_ZB).i_colore_base = get_logical_page_ZB(get_pagina_logica_attiva_ZB).i_colore_alt) then begin
		if (blink_timer <> NIL) then begin blink_timer.free;blink_timer := NIL end
	end
	else if (blink_timer = NIL) then begin
		blink_timer := TTimer.Create(self);
		blink_timer.interval := 1400;
		blink_timer.OnTimer := blink_timer_proc;
		blink_timer.Enabled := TRUE
	end;
	sbox.Color := get_logical_page_ZB(get_pagina_logica_attiva_ZB).i_colore_base
end;

function Tdlg_print_report.get_index_item_selected : TTreeNode;
begin
	result := index.selected;
	if (result = NIL) then exit;
	while (result <> NIL) AND (result.level > byte(index.ShowRoot)) do result := result.GetPrev
end;

procedure Tdlg_print_report.itp_print_pagina_logicaClick(Sender : TObject);
begin
	target := RTA_PRINTER;
	var n : TTreeNode := get_index_item_selected;
	if (n <> NIL) then exec_print(NIL, {comando_esplicito}TRUE, n.Text)
end;

procedure Tdlg_print_report.itp_export_pagina_logicaClick(Sender : TObject);
begin
	target := RTA_EXPORT;
	var n : TTreeNode := get_index_item_selected;
	if (n <> NIL) then exec_print(NIL, TRUE, n.Text)
end;

procedure Tdlg_print_report.AL_reload_dataExecute(Sender : TObject); begin reload_data end;

function Tdlg_print_report.reload_data(bo_from_closequery : boolean = FALSE) : boolean;
{ la funzione rigenera il report richiedendo un nuovo set di parametri;
  rende TRUE se rigenera il report oppure se mantiene il report attuale; rende FALSE se l'utente vuole chiudere il report }
var bo_execute_scripts : boolean;	//*
begin
	result := TRUE;	// default
	if NOT AL_reload_data.Enabled OR NOT AL_reload_data.Visible then exit;		// 2009-08-30

	var i_res : smallint := ask_runtime_parms(self, lo_print_style, FALSE, bo_dont_close_after, bo_execute_scripts);
	if (i_res = ARP_NOTHING) AND bo_from_closequery then i_res := ARP_CLOSE_REPORT;
	case i_res of
		ARP_BUILD_REPORT : begin
			if bo_execute_scripts then close_connessione_SQL;	// chiudo la connessione e tutti i conti in sospeso
			impagina({first_time}FALSE, {reload_data}TRUE, bo_execute_scripts);
			check_blinking;
			make_page_scroll_objects;		// ricreo i bottoni per gli spostamenti di pagina
			draw;
			check_timer_after_create
		end;
		ARP_NOTHING : ;
		ARP_CLOSE_REPORT : begin
			result := FALSE;
			if NOT bo_from_closequery then close
		end
		{$ifdef DEBUG} else assert(FALSE,'RELOAD_DATA() -- KJWH 8381') {$endif}
	end
end;

function Tdlg_print_report.get_handle : HWND;
begin
	if (globale = NIL) then result := handle
	else result := globale.get_handle
end;

procedure Tdlg_print_report.itp_print_diretta_defaultClick(Sender : TObject); begin IO_setup_print_diretta(FALSE, PDS_REPORT) end;
procedure Tdlg_print_report.itp_print_diretta_DIRETTAClick(Sender : TObject); begin IO_setup_print_diretta(FALSE, PDS_DIRETTA) end;
procedure Tdlg_print_report.itp_print_diretta_DIALOGClick(Sender : TObject); begin IO_setup_print_diretta(FALSE, PDS_DIALOG) end;

function Tdlg_print_report.IO_setup_print_diretta(bo_read : boolean;pds : print_diretta_type = PDS_REPORT) : print_diretta_type;
begin
	var str_alias := 'operatore-default';	// per il momento c'è solo questo operatore
	var str_argomento := extractFilename(globale.str_filename);
	var str_key := 'print_diretta';
	if bo_read then result := print_diretta_type(read_registry_integer(str_alias, str_argomento, str_key, byte(pds)))
	else begin
		write_registry(str_alias, str_argomento, str_key, byte(pds));
		result := pds
	end;
	set_print_diretta_menu(pds)
end;

procedure Tdlg_print_report.set_print_diretta_menu(pds : print_diretta_type);
begin
	itp_print_diretta_DIALOG.Checked := (pds = PDS_DIALOG);
	itp_print_diretta_DIRETTA.Checked := (pds = PDS_DIRETTA);
	itp_print_diretta_default.Checked := (pds = PDS_REPORT)
end;

procedure Tdlg_print_report.cbx_print_direttaClick(Sender : TObject);
begin
	if NOT cbx_print_diretta.Checked AND (lo_print_style = GAL_POPT_DIRECTLY_EXECUTE)
		then lo_print_style := GAL_POPT_PRINT_ANTEPRIMA		// altrimenti si rischia di stampare direttamente anche in futuro
end;

const
	PAGE_BUTTON_MIN_SIZE = 14;
	PAGE_BUTTON_MAX_SIZE = 24;
	PAGE_BUTTON_BORDO_HORZ = 2;
	PAGE_BUTTON_BORDO_VERT = 2;
	PAGE_BUTTON_DELTA_VERT = PAGE_BUTTON_BORDO_VERT;

procedure Tdlg_print_report.make_page_scroll_objects;
const
	COLORE_BOTTONE_PAGINA_ATTIVA_BASE = clYellow;
	COLORE_BOTTONE_PAGINA_ATTIVA_ALTERNATIVO = clRed;
var colors : array of TColor;
begin
	tb.Max := i_total_phisical_pages;
	var fl_height : double := (screen.Height - 2*PAGE_BUTTON_BORDO_VERT) / i_total_phisical_pages;
	tb.Visible := (fl_height < PAGE_BUTTON_MIN_SIZE + PAGE_BUTTON_BORDO_VERT);
	// se i bottoni sono piccoli piccoli, riduco la dimensione del font utilizzato
	var i_fontsize : smallint := 10;	// default
	if (fl_height < PAGE_BUTTON_MIN_SIZE + (PAGE_BUTTON_MAX_SIZE - PAGE_BUTTON_MIN_SIZE) * 0.2) then i_fontsize := 8;

	try
		bo_building_scroll_buttons := TRUE;
		var i_buttons_needed : smallint := ifi(tb.Visible, 0, i_total_phisical_pages);

		var bo_custom := FALSE;var i_pagine_logiche_stampate : logical_page_type := 0;
		setLength(colors, get_ultima_pagina_logica);		// 0-based
		for var i : logical_page_type := 0 to get_ultima_pagina_logica - 1 do begin
			if get_logical_page_1B(i+1).bo_dont_print then continue;
			inc(i_pagine_logiche_stampate);
			colors[i] := get_logical_page_ZB(i).i_colore_base;
			bo_custom := bo_custom OR (colors[i] <> COLORE_DEFAULT_PRINT_BACKGROUND)
		end;
		if NOT bo_custom then begin
			i_pagine_logiche_stampate := 0;
			for var i : logical_page_type := 0 to get_ultima_pagina_logica-1 do begin
				if get_logical_page_ZB(i).bo_dont_print then continue;
//				if sections_ZB(MAIN_SECTION_ZB, i).bo_dont_print_section then continue;
				inc(i_pagine_logiche_stampate);
				colors[i] := ifi(odd(i_pagine_logiche_stampate), COLORE_DEFAULT_PRINT_BACKGROUND, COLORE_ALTERNATE_BUTTONS_DEFAULT)
			end
		end;

		// restituisco eventuali bottoni in eccedenza (creati nel giro precedente)
		for var i : smallint := i_buttons_needed to high(scroll_buttons) do scroll_buttons[i].free;
		setLength(scroll_buttons, i_buttons_needed);		// ridimensiono l'array

		if NOT tb.Visible then begin
			var i_width : smallint := tb.clientwidth - PAGE_BUTTON_BORDO_HORZ * 2;
			for var i : ph_page_type := 0 to i_total_phisical_pages-1 do begin
				if (scroll_buttons[i] <> NIL) then continue;				// salto i bottoni già creati
				var btn : scroll_button_type := scroll_button_type.Create(self);scroll_buttons[i] := btn;
				btn.OnClick := scroll_button_click;
//				cx := colors[get_logical_page(get_pagina_fisica_of_pagina_virtuale(i+1))-1];
				var i_lp_ZB : logical_page_type := get_pagina_logica_of_pagina_fisica_1B(get_pagina_fisica_of_pagina_virtuale(i+1)) - 1;
				var cx : TColor := colors[i_lp_ZB];
//				btn.Gradient.StartColor := cx;btn.Gradient.EndColor := cx;	**
//				btn.Color := cx;
				btn.color_bk_up := cx;
				btn.color_bk_down := ifi(get_color_similarity(cx, COLORE_BOTTONE_PAGINA_ATTIVA_BASE) < 0.8,
					COLORE_BOTTONE_PAGINA_ATTIVA_BASE, COLORE_BOTTONE_PAGINA_ATTIVA_ALTERNATIVO);
				btn.Parent := tb_panel;
				btn.Left := PAGE_BUTTON_BORDO_HORZ;btn.Width := i_width;
				btn.Anchors := [akLeft,akTop,akRight];
				btn.Tag := i;
				btn.GroupIndex := 7;		// basta che sia diverso da zero
				btn.Caption := (i+1).ToString;
				btn.Font.Name := 'Arial';btn.Font.Style := [fsBold];
				btn.Font.Size := i_fontsize;
				if (i_pagine_logiche_stampate > 1) then begin		// altrimenti ha poco senso
					btn.ShowHint := TRUE;
					btn.Hint := get_logical_page_ZB(i_lp_ZB).get_descrizione(TRUE)
				end
			end;
			scroll_buttons[i_active_phisical_page - 1].Down := TRUE
		end
	finally
		bo_building_scroll_buttons := FALSE;
		resize_scroll_buttons
	end
end;

procedure Tdlg_print_report.resize_scroll_buttons;
begin
	if bo_building_scroll_buttons OR (scroll_buttons = NIL) then exit;		// nulla di resize-are
	var i_height := (tb_panel.ClientHeight - 2 * PAGE_BUTTON_BORDO_VERT - (i_total_phisical_pages-1) * PAGE_BUTTON_DELTA_VERT) div i_total_phisical_pages;
	if (i_height > PAGE_BUTTON_MAX_SIZE) then i_height := PAGE_BUTTON_MAX_SIZE;
	for var i : smallint := 0 to high(scroll_buttons) do begin
		scroll_buttons[i].Top := PAGE_BUTTON_BORDO_VERT + (i_height + PAGE_BUTTON_DELTA_VERT) * i;
		scroll_buttons[i].Height := i_height
	end
end;

procedure Tdlg_print_report.scroll_button_click(Sender : TObject);
begin
	goto_phisical_page((sender as scroll_button_type).Tag + 1)
end;

procedure Tdlg_print_report.FormMouseWheel(Sender: TObject;Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;var Handled: Boolean);
const FATTORE_ZOOM = 1.4;
var Key : Word;	//*
begin
	if (shift = []) then begin
		if (wheelDelta < 0) then key := VK_DOWN else key := VK_UP;
		FormKeyDown(NIL, key, [])
	end;
	if (shift = [ssCtrl]) then begin
		if (wheelDelta > 0) then r_fattore_zoom := r_fattore_zoom * FATTORE_ZOOM
		else r_fattore_zoom := r_fattore_zoom / FATTORE_ZOOM;
//		set_caption(FALSE);
		imposta_misure_pagina;
		draw
	end;
	Handled := TRUE
end;

{procedure Tdlg_print_report.wm_syscomm(var m : TMessage);
var w : integer;
begin
	w := (m.wparam AND $FFF0);
//	if (w = SC_ICON) then *******;
	if (w = SC_RESTORE) OR (w = SC_ZOOM) then begin
//		if jmx.bo_lock_minimized then abort;
//		itm_window_maximize.Enabled := (w <> SC_ZOOM);
//		itm_window_restore.Enabled := (w = SC_ZOOM);
//		set_menu_window_state(TRUE)
	end;
	inherited
end;}

procedure Tdlg_print_report.btn_dragdropClick(Sender: TObject); begin MessageBBox(NIL, handle, btn_dragdrop.Hint, MBOX_CAPTION) end;

procedure Tdlg_print_report.btn_info_utenteClick(Sender : TObject);
var
	i_selected : smallint;	//*
	str_filename, str_descrizione : string;	//*
begin
	var it_descr := TStringList.create;
	var it_filenames := TStringList.create;
	var s := globale.str_documento_informativo_utente;
	if (s <> '') then begin it_filenames.Add(s);it_descr.Add(ExtractFilename(s)) end;

	var str_links := globale.str_links_utente;
	{$ifdef DLL} add_delimited(str_links, globale.str_links_runtime, ACAPO); {$endif}
	while (str_links <> '') do begin
		s := togliblanks(get_line(str_links, {delete}TRUE));
		if (s = '') then continue;
		check_link_utente(s, @str_filename, @str_descrizione);
		it_filenames.Add(str_filename);it_descr.Add(str_descrizione)
	end;

	case it_filenames.Count of
		0 : begin beep;exit end;
		1 : i_selected := 0;
		else i_selected := domanda_multipla_tstring(self, 'Documenti e links', 'Seleziona il link da aprire', 0, it_descr,
			{pt_opzioni}NIL, {hints_type}[], it_filenames)
	end;
	if (i_selected = -1) then exit;

	s := it_filenames[i_selected];
	if (s = '') then exit;	// non dovrebbe capitare

	if NOT FileExists(s) then find_full_filename(extractFilepath(globale.str_filename), s);	// solo per ricercare il file
//	execute_data_file(handle, {debug}FALSE, s)		// non verifico nulla: potrebbe essere un file, ma anche un link internet
	execute_data_file(handle, {debug}FALSE, s)		// eseguo anche se FILE NOT FOUND: potrebbe non essere un file, ma un link internet
end;

procedure Tdlg_print_report.enable_file_menuitems;
begin
//	btn_files_creati.Visible := (it_last_created_filenames.Count <> 0);
	AL_file_open.Enabled := (it_last_created_filenames.Count = 1);
	AL_file_email.Enabled := (it_last_created_filenames.Count > 0);
	AL_file_delete.Enabled := (it_last_created_filenames.Count > 0);

	var str_path := get_path_files_exportati;
	AL_file_open_folder.Enabled := (str_path <> '');
	AL_file_copy_folder.Enabled := (str_path <> '');

	if (it_last_created_filenames.Count = 1) then AL_file_open.Caption := str_file_caption_base + ' [' + it_last_created_filenames[0] + ']'
	else AL_file_open.Caption := str_file_caption_base
end;

procedure Tdlg_print_report.AL_file_openExecute(Sender : TObject);
begin
	if (it_last_created_filenames.Count = 1) then execute_data_file(handle, TRUE, it_last_created_filenames[0])
end;

function Tdlg_print_report.send_email(str_email_address : string;str_target_filename : string;bo_interactive : boolean) : boolean;
const
	NUMERO_MAX_RAGIONEVOLE_ALLEGATI = 32;
	NUMERO_MAX_ASSOLUTO_ALLEGATI = 64;

	procedure append_CCN_mail(var str_email_address : string);
	// aggiunge gli indirizzi CCN alla stringa di indirizzi, specificando i prefisso 'BCC:'
	begin
		sostituisci(str_email_address, MAIL_ADDRESS_UNOFFICIAL_DELIMITER, MAIL_ADDRESS_DELIMITER);	// necessario il PUNTOEVIRGOLA come separatore di indirizzi mail
		var str_CCN := work_SMTP.str_CCN;
		while (str_CCN <> '') do begin
//			var s := get_next_word(str_CCN, MAIL_ADDRESS_DELIMITER_SET, {delete_word}TRUE);
			var s := get_next_word(str_CCN, MAIL_ADDRESS_DELIMITER_SET, [NWO_DELETE]);
			if NOT exists_code(str_email_address, s, {ignore-case}TRUE, MAIL_ADDRESS_DELIMITER) then		// considero solo se NON già inserito (anche come indirizzo principale)
				add_delimited(str_email_address, 'BCC:' + s, MAIL_ADDRESS_DELIMITER, {only_if_not_exists}TRUE)
		end
	end;

const MBOX_DEBUG_CAPTION = 'Tdlg_print_report.send_email()';
begin
	result := FALSE;
	try
		Gdebug_SQL('start send email=' + str_email_address + ' :: filename=' + str_target_filename + '  :: interactive=' + bo_interactive.SQL, MBOX_DEBUG_CAPTION, TRUE);
		runtime_debug('start', MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);

		if (it_last_created_filenames.Count > NUMERO_MAX_ASSOLUTO_ALLEGATI) then begin
			MessageBBox(NIL, handle, 'Hai chiesto di creare una mail con ' + it_last_created_filenames.Count.ToString + ' allegati ma il limite massimo è ' +
				NUMERO_MAX_ASSOLUTO_ALLEGATI.ToString + '.' + ACAPO2 + 'Eseguire l''operazione manualmente attraverso il client di posta elettronica.',
				MBOX_CAPTION, MB_ICONSTOP);
			exit
		end;
		if (it_last_created_filenames.Count > NUMERO_MAX_RAGIONEVOLE_ALLEGATI) AND
			(MessageBBox(NIL, handle,
				'Stai creando una mail con un numero MOLTO GRANDE di allegati (' + it_last_created_filenames.Count.ToString + ').' + ACAPO2 +
				'Sei sicuro?', MBOX_CAPTION, MB_QUESTION_DEF2) <> IDYES)
					then exit;

		Gdebug_SQL('mode=' + GSMM_DESCRIZIONE[globale.modalita_invio_mail], MBOX_DEBUG_CAPTION, TRUE);
		case globale.modalita_invio_mail of
			GSMM_OUTLOOK : result := outlook_send_mail_simple(MBOX_CAPTION, handle, str_email_address,
				{str_cc}'', {work_SMTP.str_CCN}'', globale.str_subject, globale.str_text,
				work_SMTP.str_firma, it_last_created_filenames.Text, @static_outlook.data);
			GSMM_LOCAL_SMTP : begin
				runtime_debug('modalità SMTP', MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
				result := SMTP_send_proc(work_SMTP, PROGRAM_NAME, globale.str_filename, self, bo_interactive, {test}FALSE, str_email_address, {str_cc}'',
					work_SMTP.str_CCN, globale.str_subject, it_last_created_filenames.Text, globale.str_text);
				runtime_debug('after SMTP', MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
//				if NOT result then write_registro(
			end;
			else begin		// GSMM_DEFAULT_MAPI_CLIENT
				runtime_debug('modalità CLIENT', MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
				var bo_SMTP_protocol := FALSE;
				case work_SMTP.mail_client_setup.SMTP_protocol of
					SMTPEP_CALLING_PROGRAM : begin
						if (box_SMTP_protocol_calling_program in [XTRUE, XFALSE]) then bo_SMTP_protocol := x2bool(box_SMTP_protocol_calling_program)
					end;
//					SMTPEP_CLIENT_DEFAULT : bo_SMTP_protocol := FALSE;
					SMTPEP_ALWAYS_SMTP : bo_SMTP_protocol := TRUE
//					else bo_SMTP_protocol := FALSE
				end;
				append_CCN_mail(str_email_address);
				var str_firma := work_SMTP.str_firma;
				runtime_debug('before client call', MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
				result := Fmail.send_email(self, str_email_address, globale.str_subject, globale.str_text + ifs(str_firma, ACAPO + str_firma),
					it_last_created_filenames.Text, bo_interactive, bo_SMTP_protocol);
				runtime_debug('after client call = ' + bool2SQL(result), MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00)
			end;
			Gdebug_SQL('send email RESULT=' + result.SQL, MBOX_DEBUG_CAPTION, TRUE)
		end
	except
		runtime_debug('except' + ACAPO2 + get_last_error_msg, MBOX_DEBUG_CAPTION, RD_DEBUG_PRINCIPALE_00);
		error_msg(self, NIL, 'Errore durante la spedizione email', MBOX_CAPTION)
	end
end;

procedure Tdlg_print_report.AL_file_emailExecute(Sender : TObject);
begin
	var str_email_address := globale.get_email_default;
	if (str_email_address = '') AND NOT input_text_proc(self, 'Indirizzo mail', 'Indirizzo mail di destinazione', str_email_address) then exit;
//	xsend_email(str_email_address, globale.str_export_filename, {interactive}TRUE)		{$ifndef DEBUG} *** verificare {$endif}
	send_email(str_email_address, globale.get_default_write_filename({target_export}FALSE), {interactive}TRUE)
end;

procedure Tdlg_print_report.AL_file_deleteExecute(Sender : TObject);
var
	i : smallint;	//*
	str_deleted, str_errors : string;
begin
	if (it_last_created_filenames.Count = 1) then begin
		if (MessageBBox(NIL, handle, 'Vuoi eliminare il file ' + it_last_created_filenames[0] + ' ?', MBOX_CAPTION, MB_QUESTION_DEF2) <> IDYES)
			then exit;
		if DeleteFile(LPSTR(it_last_created_filenames[0])) then begin
			MessageBBox(NIL, handle, 'File eliminato', MBOX_CAPTION);
			it_last_created_filenames.Clear
		end
		else MessageBBox(NIL, handle, 'Eliminazione fallita', MBOX_CAPTION, MB_ICONSTOP)
	end
	else begin
		if (MessageBBox(NIL, handle, 'Vuoi eliminare i ' + it_last_created_filenames.Count.ToString + ' files generati?' + ACAPO2 + get_elenco_files_generati,
			MBOX_CAPTION, MB_QUESTION_DEF2) <> IDYES) then exit;
		var deleted : byteset := [];
		for i := 0 to it_last_created_filenames.Count-1 do begin
			try
				if DeleteFile(LPSTR(it_last_created_filenames[i])) then begin
					add_delimited(str_deleted, it_last_created_filenames[0], ACAPO);
					deleted := deleted + [i]
				end
//				else add_delimited(str_errors, it_last_created_filenames[i], ACAPO)
				else abort
			except
				add_delimited(str_errors, it_last_created_filenames[i], ACAPO)
			end
		end;
		for i := it_last_created_filenames.Count-1 downto 0 do if (i in deleted) then it_last_created_filenames.Delete(i);
		if (str_errors = '') then MessageBBox(NIL, handle, 'Tutto eliminato', MBOX_CAPTION)
		else if (str_deleted = '') then MessageBBox(NIL, handle, 'Errore durante l''eliminazione -- nessun file eliminato', MBOX_CAPTION, MB_ICONSTOP)
		else MessageBBox(NIL, handle, 'Errore durante l''eliminazione' + ACAPO2 +
			numero_elementi_lista(str_deleted).ToString + ' files eliminati' + ACAPO +
			numero_elementi_lista(str_errors).ToString + ' files NON eliminati', MBOX_CAPTION, MB_ICONSTOP)
	end;
	enable_file_menuitems
end;

function Tdlg_print_report.get_path_files_exportati : string;
// rende il PATH dei files realmente exportati, oppure il path generico di exportazione, o ciò che è più vicino a questo concetto
begin
	if (it_last_created_filenames.Count = 0) then result := globale.str_default_export_filepath
	else result := ExtractFilePath(it_last_created_filenames[0])
end;

procedure Tdlg_print_report.AL_file_open_folderExecute(Sender : TObject);
begin
	var str_path := get_path_files_exportati;
	execute_data_file(handle, TRUE, str_path)
end;

procedure Tdlg_print_report.AL_file_copy_folderExecute(Sender : TObject);
begin
	var str_path := get_path_files_exportati;
	if (str_path <> '') then str2clipboard(str_path)
end;

function Tdlg_print_report.get_elenco_files_generati(bo_delete_path : boolean = TRUE;i_numero_max : smallint = 0;
	str_delimitatore : string = '';str_elenco_files : string = '') : string;
{ se STR_ELENCO_FILES è blank (caso standard) viene mostrata la lista contenuta su IT_LAST_CREATED_FILENAMES,
  altrimenti viene utilizzato il contenuto di STR_ELENCO_FILES }
const DEFAULT_MAX = 12;
var s : string;	//*
begin
	result := '';
	var it := TStringList.create;
	if (i_numero_max = 0) then i_numero_max := DEFAULT_MAX;
	if (str_delimitatore = '') then str_delimitatore := ACAPO;

	if (str_elenco_files = '') then it.Assign(it_last_created_filenames)
	else begin
		while (str_elenco_files <> '') do it.Add(get_first_delimited_delete(str_elenco_files, str_delimitatore))
	end;

	for var i : smallint := 0 to min(it.Count, i_numero_max) - 1 do begin
		s := it[i];
		if bo_delete_path then s := ExtractFileName(s);
		add_delimited(result, s, str_delimitatore)
	end;
	var i_residuo : smallint := it.Count - i_numero_max;
	if (i_residuo >= 0) then begin
		if (i_residuo = 1) then begin
			s := it[it.Count-1];
			if bo_delete_path then s := ExtractFileName(s);
			add_delimited(result, s, str_delimitatore)
		end
		else add_delimited(result, '(altri ' + i_residuo.ToString + ' files)', str_delimitatore)
	end;
	it.free
end;

function Tdlg_print_report.messagebbox(x : pointer;handle : hwnd;str_message, str_caption : string;TextType : DWORD = MB_ICONINFORMATION) : Word;
{ gestisce la chiamata alla MessageBBox() in base alle impostazioni del report;
  se l'evento è un errore (o se contiene il flag MB_LOG_EVENT) scrive l'evento sul registro degli eventi o sul LOG_file }
begin
	if ((TextType AND MB_ICONSTOP) <> 0) then write_registro_eventi(ELT_ERROR, str_message)
	else if ((TextType AND MB_LOG_EVENT) <> 0) then write_registro_eventi(ELT_INFORMATION, str_message);

	if (handle = 0) then handle := get_handle;
	if (TextType AND MB_LOG_EVENT <> 0) then TextType := TextType - MB_LOG_EVENT;		// parametro custom, da non passare alla procedura vera
	if (TextType AND MB_ICONSTOP <> 0) then bo_printing_error_found := TRUE;
	if silent_mode then result := MB_OK
	else result := FMessage.MessageBBox(handle, str_message, str_caption, TextType)
end;

function Tdlg_print_report.error_msg(father : TForm;x : pointer;str_msg,mbox_caption : string;bo_ignore_abort_msg : boolean = TRUE;
	mb_icon : integer = MB_ICONSTOP;str_filename : string = '';dw_event_id : DWORD = 0) : integer;
begin
	if ((mb_icon AND MB_ICONSTOP) <> 0) then write_registro_eventi(ELT_ERROR, str_msg, dw_event_id);
	bo_printing_error_found := TRUE;
//	result := FErrMsg.error_msg(handle, str_msg, mbox_caption, bo_ignore_abort_msg, mb_icon, str_filename)
	result := FErrMsg.error_msg(father, str_msg, mbox_caption, bo_ignore_abort_msg, mb_icon, str_filename)
end;

function Tdlg_print_report.write_registro_eventi(message_type : eventlog_type;str_message : string;lo_event_ID : integer = 0) : boolean;
begin
	if globale.bo_log_registro_eventi then
		result := Fdebug.write_registro_eventi(message_type, str_message, lo_event_ID)
	else result := TRUE
end;

procedure Tdlg_print_report.AL_open_galateoExecute(Sender : TObject);
begin
	execute_data_file(handle, FALSE, globale.str_filename)
end;

function Tdlg_print_report.validation_callback_proc(ptr : pointer;var bo_errore : boolean) : boolean;
{ BO_ERRORE in input contiene TRUE se si tratta di ERRORE BLOCCANTE, FALSE se solo warning;
  in base al contesto in analisi, BO_ERRORE in OUTPUT contiene TRUE se l'errore DEVE essere considerato bloccante (errore), FALSE se solo warning }
var x : objs_type absolute ptr;
begin
	result := FALSE;
	if (x is objs_type) then begin
		result := (active_contexts * x.aslabel.validazione.contexts_attivo <> []);
		if result AND bo_errore then bo_errore := (active_contexts * x.aslabel.validazione.contexts_bloccante <> [])
	end
end;

function Tdlg_print_report.verifica_validazione(contexts : validazione_context_set) : boolean;
begin
	try
		active_contexts := contexts;
		result := silent_mode OR validation_verify(valid, self, globale.str_filename, VOPT_DONT_DELETE, validation_callback_proc)
	finally
		active_contexts := []		// non serve a nulla, solo esteticamente tranquillizzante
	end
end;

procedure Tdlg_print_report.panel_footer_messageClick(Sender : TObject);
begin
	if (panel_footer_message.Caption <> '') then execute_data_file(handle, FALSE, get_debug_filename)
end;

procedure Tdlg_print_report.btn_dragdropMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
{$ifNdef EXCLUDE_DRAGDROP}
	if NOT DragDetectPlus(TWinControl(Sender)) then exit;		// Wait for user to move mouse before we start the drag/drop.
	drop_source.Files.Clear;		// Delete anything from a previous drag.
	drop_source.Files.Add(globale.get_default_write_filename({target_export}TRUE));	// l'allegato non è ancora stato generato, ma faccio finta cmq di aver qualcosa da exportare
	drop_source.Execute
{$endif EXCLUDE_DRAGDROP}
end;

{$ifNdef EXCLUDE_DRAGDROP}
procedure Tdlg_print_report.drop_sourceDrop(Sender: TObject; DragType: TDragType; var ContinueDrop : Boolean);
begin
	drop_source.Files.Clear;		// Delete anything from a previous drag
	var lo : integer := GAL_POPT_PDF OR GAL_POPT_DIRECTLY_EXECUTE OR GAL_POPT_SILENT OR GAL_POPT_TEMPORARY_PATH;
	target := RTA_PDF;
	if exec_print(@lo, {esplicito}FALSE) then begin
		var str_filename := globale.str_last_exported_filename;
		drop_source.Files.Add(str_filename);
		delete_filename_ASAP(str_filename)	// elimina al prossimo riavvio, per lasciare il file disponibile
	end
	else ContinueDrop := FALSE
end;
{$endif EXCLUDE_DRAGDROP}

initialization
	galateo_initialization_debug('print_report')
finalization
	galateo_finalization_debug('print_report');
	{$ifdef DEBUG} CCI(lo_index_info, 'cl_index_info', 'print_report.pas') {$endif}
end.
