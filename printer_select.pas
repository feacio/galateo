unit printer_select;

{$I defines}
{$ifNdef CASA} *** {$endif}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, ExtDlgs, StdCtrls, Buttons, Menus, ComCtrls, ExtCtrls, Actions, ActnList,
//	RXCtrls,
	JvExStdCtrls, JvTextListBox,
	Fcommons, PDF, FBitBtn, Federico, domanda_multipla, multi_dialog,
	printers_DX, Gdich, pages, expint_exec;

procedure init_printer_select;

function select_printer_proc(father : TForm;
//	var i_page_from,i_page_to : ph_page_type;
	{ per quanto riguarda la selezione delle pagine da stampare:
			il campo esecutivo è STR_INTERVALLO_PAGINE;
			il campo STR_PAGINE_LOGICHE serve solo per compilare adeguatamente il campo STR_INTERVALLO_PAGINE;
	  entrambi i campi devono essere compilati in INPUT, e sono adeguatamente modificati in OUTPUT;
	  STR_INTERVALLO_PAGINE deve essere SEMPRE compilato, STR_PAGINE_LOGICHE è facoltativo }
	var str_intervallo_pagine : string;i_max_page : ph_page_type;var i_num_copie : smallint;var str_pagine_logiche : string;
	i_pagina_corrente : ph_page_type;
	var bo_printer_changed : boolean;
	var target : report_target_type;
	var str_target_filename : string;			// nome del file da generare (if any)
	var str_target_path : string;					// alternativo a STR_TARGET_FILENAME, per i casi in cui devono essere generati files plurimi
	bo_allow_save_as_PDF : boolean;PDF_opt : cl_PDF;	// opzioni di exportazione in PDF
	exec_export_options : cl_exec_expint_options;									// opzioni di exportazione (integrale e XML)
	var bo_send_as_email : boolean;var str_email_address : string;
	var bo_applica_stampante_all_pages : boolean;
	pt_lo_print_style : integer_punt) : boolean;
{ rende TRUE se schiaccia OK,
  le caselle I_PAGE_FROM e I_PAGE_TO vengono attivate solo if BO_STAMPA_DAVVERO
  e se IF i_page_from > 0 e i_page_to > 1;
  se viene modificata la stampante selezionata rende BO_PRINTER_CHANGED = TRUE (anche se non vuole stampare);
  PT_LO_PRINT_STYLE se <> NIL indica lo style della stampa; può essere modificato }

type
  Tdlg_select_printer = class(TForm)
	 button_panel: TPanel;
	 btn_ok: TFBitBtn;
    btn_cancel: TFBitBtn;
    btn_apply: TFBitBtn;
    btn_preview: TFBitBtn;
	 pagine_panel: TPanel;
	 gb_pagine: TGroupBox;
    txt_intervallo: TLabel;
	 cbx_pagina_corrente: TCheckBox;
	 panel_printers: TPanel;
    lb: TJvTextListBox;
    panel_mail: TPanel;
    cb_email: TFCombo;
	 txt_pagina_logica: TLabel;
	 cb_pagina_logica: TFCombo;
    btn_advanced: TFBitBtn;
    btn_pagina_logica: TFBitBtn;
    cbx_sezione_corrente: TCheckBox;
	 pc: TMyPageControl;
    page_printer: TTabSheet;
    page_PDF: TTabSheet;
    page_export: TTabSheet;
    gb_opzioni: TGroupBox;
	 txt_num_copie: TLabel;
	 txt_cassetto: TLabel;
    i_num_copie: TFEdit;
    UpDown2: TUpDown;
    cb_cassetto: TFCombo;
	 rb_PDF_behaviour: TRadioGroup;
    btn_opzioni_PDF: TFBitBtn;
    rb_export_target: TRadioGroup;
	 txt_export_file_azione: TLabel;
	 cb_export_file_azione: TFCombo;
	 panel_apply_all_pages: TFPanel;
	 cbx_apply_all_pages: TFCheckBox;
    cb_export_file_writemode: TFCombo;
	 txt_export_file_writemode: TLabel;
    btn_impostazioni_FTP: TFBitBtn;
    page_SMTP: TTabSheet;
    btn_mail_config: TFBitBtn;
    rb_modalita_mail: TFRadioGroup;
    panel_target: TFPanel;
    cbx_PDF: TCheckBox;
    cbx_export_dati: TCheckBox;
	 cbx_email: TCheckBox;
    panel_filename: TFPanel;
    txt_filename: TLabel;
    str_filename: TEdit;
    btn_browse_file: TFBitBtn;
    btn_open_path: TFBitBtn;
	 panel_filepath: TFPanel;
    btn_browse_path: TFBitBtn;
    str_path: TEdit;
    btn_open_filepath: TFBitBtn;
    txt_path: TLabel;
    txt_email: TLabel;
    str_intervallo: TFEdit;
    panel_default_printer: TFPanel;
    txt_default_printer: TLabel;
    str_default_printer: TEdit;
    txt_profilo_export: TLabel;
    cb_profilo_export: TFCombo;
    btn_email: TFBitBtn;
    AL: TActionList;
    AL_set_PDF: TAction;
    AL_set_expint: TAction;
    AL_set_email: TAction;
    AL_set_current_page: TAction;
    AL_apply: TAction;
    AL_next_cassetto: TAction;
    AL_preview: TAction;
	 AL_set_current_section: TAction;
    AL_save: TAction;
	 procedure FormCreate(Sender : TObject);
	 procedure btn_cancelClick(Sender : TObject);
	 procedure lbDblClick(Sender : TObject);
	 procedure cbx_pagina_correnteClick(Sender : TObject);
	 procedure lbClick(Sender : TObject);
	 procedure FormActivate(Sender : TObject);
	 procedure btn_browse_fileClick(Sender : TObject);
	 procedure cbx_PDFClick(Sender : TObject);
	 procedure cbx_emailClick(Sender : TObject);
	 procedure btn_advancedClick(Sender : TObject);
	 procedure btn_opzioni_PDFClick(Sender : TObject);
	 procedure FormDestroy(Sender : TObject);
	 procedure cbx_sezione_correnteClick(Sender : TObject);
	 procedure cbx_export_datiClick(Sender : TObject);
	 procedure rb_export_targetClick(Sender : TObject);
    procedure btn_impostazioni_FTPClick(Sender : TObject);
    procedure rb_PDF_behaviourClick(Sender : TObject);
    procedure btn_browse_pathClick(Sender : TObject);
    procedure btn_open_pathClick(Sender : TObject);
	 procedure rb_modalita_mailClick(Sender : TObject);
	 procedure btn_mail_configClick(Sender : TObject);
    procedure str_intervalloChange(Sender : TObject);
    procedure cb_profilo_exportChange(Sender : TObject);
    procedure AL_set_PDFExecute(Sender: TObject);
    procedure AL_set_expintExecute(Sender: TObject);
    procedure AL_set_emailExecute(Sender: TObject);
    procedure AL_set_current_pageExecute(Sender: TObject);
    procedure AL_set_current_sectionExecute(Sender: TObject);
    procedure AL_applyExecute(Sender: TObject);
    procedure AL_next_cassettoExecute(Sender: TObject);
    procedure AL_previewExecute(Sender: TObject);
    procedure AL_saveExecute(Sender: TObject);
	private
		bo_filenames_differenziati_per_target : boolean;		// segnala se è attiva la gestione di filenames differenziati per target
		bo_selected_target_export_filename : boolean;
		str_target_filenames : array[boolean] of string;		// contiene i filenames per i vari target; predicato: BO_EXPORT
		procedure set_target_filename(bo_export : boolean;bo_forza_assegnazione : boolean = FALSE);
	private
		bo_activated : boolean;
		bo_open_ok : boolean;
		pt_bo_modified,pt_bo_printer_changed : ^boolean;
//		pt_i_page_from, pt_i_page_to : ^ph_page_type;
		pt_str_intervallo_pagine : string_punt;
		pt_i_num_copie : ^smallint;
		pt_lo_print_style : integer_punt;
		PDF_opt, PDF_opt_originale : cl_PDF;
		exec_export_options : cl_exec_expint_options;
		bo_allow_save_as_PDF : boolean;
		pt_bo_send_as_email : ^boolean;
		pt_bo_applica_stampante_all_pages : boolean_punt;
		pt_str_email_address : ^string;
		str_image_filename : string;
		i_pagina_corrente, i_max_page : ph_page_type;
		i_default_itemindex : smallint;
//		xbo_aborted : boolean;			{$ifdef DEBUG} *** {non serve a nulla} {$endif}
		i_printerindex_selected_on_enter : smallint;		// indice della printer selezionata all'ingresso
		bo_setting_sezione : boolean;
		bo_document_properties_modified : boolean;
		multi_pagina : cl_multi_dialog;
		str_pagine_logiche : string;
		pt_str_pagine_logiche : string_punt;
		pt_target : report_target_punt;
		pt_str_target_filename, pt_str_target_path : string_punt;	// FILENAME e PATH sono alternativi, da usare nei casi di file singolo o multipli
		bo_enable_apply_all_pages : boolean;
		str_email : string;
		multi_email : cl_multi_dialog;
		constructor xcreate(father : TForm;var bo_modified,bo_printer_changed : boolean;
//			var i_page_from,i_page_to : ph_page_type;
			var str_intervallo_pagine : string;i_max_page : ph_page_type;var i_num_copie : smallint;
			var str_pagine_logiche : string;
			i_pagina_corrente : integer;
			var target : report_target_type;
			var str_target_filename : string;
			var str_target_path : string;			// alternativo a STR_TARGET_FILENAME, per i casi in cui devono essere generati files plurimi
			bo_allow_save_as_PDF : boolean;PDF_opt : cl_PDF;
			var bo_send_as_email : boolean;var str_email_address : string;
			exec_export_options : cl_exec_expint_options;
			var bo_applica_stampante_all_pages : boolean;
			pt_lo_print_style : integer_punt);
		{ rende BO_MODIFIED = TRUE se viene modificata la stampante su cui stampare;
		  aggiorna direttamente il valore di CONTROLLO.STR_PRINTER }
		procedure apply(bo_close_window : boolean);
//		procedure apply_selezione_pagine_logiche;
		procedure cb_pagina_logica_change(pt : pointer);
		procedure enable_ctrls;
		procedure set_email_combo;
		procedure applica_profilo_export;
		procedure setfocus_file_path;
  end;

implementation

uses FAssert, FErrMsg, FXStrings, FStrings, FdataH, Fdata, FCtrls, FCtrls_RX, FFile, FSystem_base, FSystem, FMessage, FProcs, FBrowse, PDF_edit, multi_select,
	myprinter, proc, FTP_dialog, intervallo,
	galateo_debug, Gun, misure, expint_base, FRedemption, OUTLOOK_config_dialog, SMTP_proc, SMTP_config_dialog;

const
	MBOX_CAPTION = 'Selezione stampante';

{$R *.DFM}

function select_printer_proc(father : TForm;
//	var i_page_from,i_page_to : ph_page_type;
	var str_intervallo_pagine : string;i_max_page : ph_page_type;var i_num_copie : smallint;var str_pagine_logiche : string;
	i_pagina_corrente : ph_page_type;
	var bo_printer_changed : boolean;
	var target : report_target_type;
	var str_target_filename : string;		// nome del file da generare (if any)
	var str_target_path : string;				// alternativo a STR_TARGET_FILENAME, per i casi in cui devono essere generati files plurimi
	bo_allow_save_as_PDF : boolean;PDF_opt : cl_PDF;						// opzioni di exportazione in PDF
	exec_export_options : cl_exec_expint_options;									// opzioni di exportazione integrale
	var bo_send_as_email : boolean;var str_email_address : string;
	var bo_applica_stampante_all_pages : boolean;
	pt_lo_print_style : integer_punt) : boolean;
// rende TRUE se è stata modificata la stampante selezionata
var dlg: Tdlg_select_printer;
begin
	runtime_debug('000','printer_select.select_printer_proc()',RD_DEBUG_ACCESSORIO_01);
	if NOT esiste_stampante(TRUE) then exit;
	runtime_debug('010', 'printer_select.select_printer_proc()', RD_DEBUG_ACCESSORIO_01);
	dlg := Tdlg_select_printer.xCreate(father, result, bo_printer_changed,
//		i_page_from, i_page_to,
		str_intervallo_pagine, i_max_page, i_num_copie, str_pagine_logiche, i_pagina_corrente, target, str_target_filename, str_target_path,
		bo_allow_save_as_PDF, PDF_opt, bo_send_as_email, str_email_address,
		exec_export_options, bo_applica_stampante_all_pages, pt_lo_print_style);
	runtime_debug('020', 'printer_select.select_printer_proc()', RD_DEBUG_ACCESSORIO_01);
	dlg.ShowModal;
	runtime_debug('990', 'printer_select.select_printer_proc()', RD_DEBUG_ACCESSORIO_01);
	dlg.Free;
	runtime_debug('999', 'printer_select.select_printer_proc()', RD_DEBUG_ACCESSORIO_01)
end;

constructor Tdlg_select_printer.xcreate(father : TForm;
	var bo_modified, bo_printer_changed : boolean;
//	var i_page_from,i_page_to : ph_page_type;
	var str_intervallo_pagine : string;i_max_page : ph_page_type;var i_num_copie : smallint;var str_pagine_logiche : string;
	i_pagina_corrente : integer;
	var target : report_target_type;
	var str_target_filename : string;
	var str_target_path : string;					// alternativo a STR_TARGET_FILENAME, per i casi in cui devono essere generati files plurimi
	bo_allow_save_as_PDF : boolean;PDF_opt : cl_PDF;
	var bo_send_as_email : boolean;var str_email_address : string;
	exec_export_options : cl_exec_expint_options;
	var bo_applica_stampante_all_pages : boolean;
	pt_lo_print_style : integer_punt);
const MBOX_DEBUG_CAPTION = 'Tdlg_select_printer.xcreate()';
begin
	runtime_debug('000', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
	pt_bo_modified := @bo_modified;
	pt_bo_printer_changed := @bo_printer_changed;bo_printer_changed := FALSE;
	bo_modified := FALSE;
//	pt_i_page_from := @i_page_from;
//	pt_i_page_to := @i_page_to;i_max_page := i_page_to;
	pt_str_intervallo_pagine := @str_intervallo_pagine;
	self.i_max_page := i_max_page;
	pt_i_num_copie := @i_num_copie;
	self.str_pagine_logiche := str_pagine_logiche;
	pt_str_pagine_logiche := @str_pagine_logiche;
	pt_target := @target;
	pt_str_target_filename := @str_target_filename;
	pt_str_target_path := @str_target_path;
	self.bo_allow_save_as_PDF := bo_allow_save_as_PDF;
	PDF_opt_originale := PDF_opt;
	self.PDF_opt := cl_PDF.create(PDF_opt);
	self.exec_export_options := exec_export_options;
	self.pt_lo_print_style := pt_lo_print_style;
	self.i_pagina_corrente := i_pagina_corrente;
	self.pt_bo_send_as_email := @bo_send_as_email;bo_send_as_email := FALSE;
	self.pt_str_email_address := @str_email_address;
	pt_bo_applica_stampante_all_pages := @bo_applica_stampante_all_pages;bo_applica_stampante_all_pages := FALSE;
	runtime_debug('100', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);

	// nome eventuale di salvataggio: vedo se contiene delle variabili da tradurre
	str_image_filename := globale.get_default_write_filename({export}FALSE);  {$ifdef PROVA} *** serve ancora ??? {$endif}

	runtime_debug('200', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
	inherited create(father);
	runtime_debug('900', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
	if NOT bo_open_ok then abort;
	runtime_debug('999', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01)
end;

procedure Tdlg_select_printer.FormCreate(Sender : TObject);

	procedure select_default_printer;
	const MBOX_DEBUG_CAPTION = 'FormCreate.select_default_printer()';
	var
		i : byte;	//*
		s, str_special_pages : string;
	begin
		runtime_debug('000', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
	{ if (globale.str_printer_imposta <> '') AND (lb.Items.IndexOf(globale.str_printer_imposta) <> -1) then
	  globale.xstr_printer := globale.str_printer_imposta;}

	  var str_stampante := globale.str_current_printer;
	  if (globale.modalita_selezione_default_printer <> DPST_GALATEO) AND (uppercase(str_stampante) = uppercase(str_stampante_predefinita)) then str_stampante := '';
	  if (lb.Items.Indexof(str_stampante) = -1) then str_stampante := '';
	  if (str_stampante = '') then lb.Itemindex := 0 else lb.Itemindex := lb.Items.Indexof(str_stampante);

(*		if (globale.printer_default[0].str_printer = '') then lb.ItemIndex := 0
		else begin
//			runtime_debug('010', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
//			lb.ItemIndex := lb.Items.indexof(globale.xstr_printer);
//			if (lb.ItemIndex <> -1) then str_cassetto := globale.printer_default[0].str_cassetto;
//			runtime_debug('020', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
//			if (lb.ItemIndex = -1) AND (globale.printer_default[1].str_printer <> '') then begin
//				lb.ItemIndex := lb.Items.indexof(globale.printer_default[1].str_printer);
//				if (lb.ItemIndex <> -1) then str_cassetto := globale.printer_default[1].str_cassetto
//			end;

			runtime_debug('010', 'FormCreate.select_default_printer() - BEFORE', RD_DEBUG_ACCESSORIO_01);
			lb.ItemIndex := -1;
			for i := 0 to NUMERO_DEFAULT_PRINTERS-1 do begin
				runtime_debug('020', 'FormCreate.select_default_printer() - ' + zeri(i,2), RD_DEBUG_ACCESSORIO_01);
				str_stampante_principale := coalesce(str_stampante_principale, globale.printer_default[i].str_printer);
				lb.ItemIndex := lb.Items.indexof(globale.printer_default[i].str_printer);
				runtime_debug('021', 'FormCreate.select_default_printer() - ' + zeri(i,2), RD_DEBUG_ACCESSORIO_01);
				if (lb.ItemIndex <> -1) then begin
					str_cassetto := globale.printer_default[i].str_cassetto;
					break
				end
			end;

			runtime_debug('030', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
			if (lb.ItemIndex = -1) then begin
				MessageBBox(handle, 'Stampante default sconosciuta.' + ACAPO2 + str_stampante_principale, MBOX_CAPTION);
				lb.ItemIndex := lb.Items.indexof(STAMPANTE_PREDEFINITA)
			end
		end; *)
		runtime_debug('040', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		i_default_itemindex := lb.Itemindex;
		if (i_default_itemindex <> -1) then begin
			runtime_debug('050', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
			fill_info_cassetto_carta(lb.Items[i_default_itemindex], cb_cassetto);
			runtime_debug('060', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);

			if (globale.modalita_selezione_default_printer = DPST_GALATEO) {AND (str_stampante <> '')} then begin
				i := 0;
				if (str_stampante = '') then str_stampante := str_stampante_predefinita;	// recupero eventuali impostazioni cassetto anche per la stampante predefinita
				while (i < NUMERO_DEFAULT_PRINTERS) AND (uppercase(globale.printer_default[i].str_printer) <> uppercase(str_stampante)) do inc(i);
				if (i < NUMERO_DEFAULT_PRINTERS) then cb_select(cb_cassetto, globale.printer_default[i].str_cassetto)
			end
		end;

		if (lb.ItemIndex = 0) then str_stampante := str_stampante_predefinita else str_stampante := lb.Items[lb.ItemIndex];

		runtime_debug('070', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		for i := 1 to get_ultima_pagina_logica do begin
			s := get_printer_page(i);
			if (s <> '') AND (uppercase(s) <> uppercase(str_stampante)) AND (printer.printers.indexof(s) <> -1) then
				add_delimited(str_special_pages, '[' + i.ToString + '] ' + get_logical_page_1B(i).get_descrizione(TRUE) + ' >> ' + s, ACAPO)
		end;
		bo_enable_apply_all_pages := (str_special_pages <> '');
		panel_apply_all_pages.Hint := 'nel report esistono pagine logiche con impostazioni di stampa differenziate' + ACAPO +
			'attiva questo flag per forzare l''utilizzazione della stampante specificata su TUTTE le pagine del report' +
			ifs(str_special_pages, ACAPO2 + 'le pagine con impostazioni differenziate sono:' + ACAPO + str_special_pages);

		runtime_debug('999', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01)
	end;

	procedure init_filename;
	begin
		str_target_filenames[FALSE] := ExtractFilePath(str_image_filename) + check_filename(ExtractFilename(str_image_filename));	// assegno il nome normalizzato
		str_target_filenames[TRUE] := coalesce(exec_export_options.str_target_export_filename, str_target_filenames[FALSE]);

		bo_filenames_differenziati_per_target := (str_target_filenames[FALSE] <> str_target_filenames[TRUE]);	// se non ci sono differenze, non attivo la gestione
		bo_selected_target_export_filename := (pt_target^ = RTA_EXPORT);
		str_filename.Text := str_target_filenames[bo_selected_target_export_filename]
	end;

const MBOX_DEBUG_CAPTION = 'Tdlg_select_printer.FormCreate()';
var s : string;
begin
	try
		runtime_debug('000', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		caption := MBOX_CAPTION;
		rb_PDF_behaviour.Hint := PDF_BEHAVIOUR_HINT;
		rb_PDF_behaviour.Items.Clear;
		for var p : PDF_behaviour := low(p) to high(p) do
			if (p <> PDFH_SAVE_LOGICAL_PAGE) OR (globale.get_runtime_pagine_logiche_stampabili > 1) then
				rb_PDF_behaviour.Items.Add(PDF_BEHAVIOUR_DESCRIZIONE[p]);
		i_printerindex_selected_on_enter := printer.Printerindex;
		var lo_print_style : integer := 0;
		if (pt_lo_print_style <> NIL) then lo_print_style := pt_lo_print_style^;
		var bo := (lo_print_style AND GAL_POPT_PRINT_PRINTER <> 0);
		AL_preview.Enabled := bo;
		set_email_combo;

		runtime_debug('010', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		if bo_PDF_allowed AND (lo_print_style AND (GAL_POPT_PDF OR GAL_POPT_EMAIL) <> 0)
//				AND (pt_target^ <> RTA_EXPORT_INTEGRALE)
//				AND NOT (pt_target^ in [RTA_EXPORT_INTEGRALE, RTA_XML])
				AND (pt_target^ in RTA_PRINT_TARGETS)
			then pt_target^ := RTA_PDF;

		for var i : byte := 0 to pc.pagecount-1 do pc.pages[i].TabVisible := FALSE;
//		pc_opzioni.TabIndex := 0;
{		if NOT bo then begin
			height := height - (button_panel.Height - btn_preview.Top);
			button_panel.Height := btn_preview.Top
		end; }

		if (lo_print_style AND GAL_POPT_DIRECTLY_EXECUTE <> 0) then begin
			height := height - pagine_panel.Height;
			pagine_panel.Height := 0;
			pagine_panel.Enabled := FALSE
		end
		else begin
//			bo := (pt_i_page_to^ > 1);
			bo := (i_max_page > 1);
			make_all_children_enabled(gb_pagine, bo, FALSE)
		end;

		runtime_debug('020', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
//		enable_FC(txt_num_copie, globale.bo_report);
		enable_FC(txt_num_copie, globale.tiporeport in REPORT_TYPES);
		if bo_allow_save_as_PDF then begin
//			str_filename.Text := str_image_filename;
//			str_filename.Text := check_filename(str_image_filename);	// assegno il nome normalizzato
//			str_filename.Text := ExtractFilePath(str_image_filename) + check_filename(ExtractFilename(str_image_filename));	// assegno il nome normalizzato
			init_filename;
			str_path.Text := pt_str_target_path^;
//			set_email_combo
		end
		else begin
			panel_target.Visible := FALSE;
			lb.Align := alClient
		end;

//		cbx_pdf.Checked := bo_PDF_allowed AND (lo_print_style AND (GAL_POPT_PDF OR GAL_POPT_EMAIL) <> 0);
		cbx_pdf.Checked := (pt_target^ = RTA_PDF);
		cbx_email.Checked := (lo_print_style AND GAL_POPT_EMAIL <> 0);
//		cbx_export_integrale.Enabled := globale.bo_expint_allowed;
		cbx_export_dati.Visible := globale.bo_export_allowed AND (globale.expint_profiles <> NIL);
		s := get_expint_profilo.str_message_before;
		if (s <> '') then cbx_export_dati.Hint := s;	// solo per il primo profilo: soluzione parziale ma complessivamente efficace
		cbx_export_dati.Checked := cbx_export_dati.Visible AND (pt_target^ = RTA_EXPORT);
		if cbx_export_dati.Checked then cbx_export_dati.Color := clYellow;	// evidenzio

		var k : byte := byte(PDF_opt.behaviour);
		if (globale.get_runtime_pagine_logiche_stampabili = 1) AND (PDF_opt.behaviour = PDFH_SAVE_LOGICAL_PAGE) then k := byte(PDFH_OPEN_FOLDER);
		rb_PDF_behaviour.Itemindex := k;

		runtime_debug('030',MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		if (get_ultima_pagina_logica = 1) then begin
//			enable_FC(txt_pagina_logica, FALSE);
			btn_pagina_logica.Enabled := FALSE
		end
		else begin
			for var i : byte := 1 to get_ultima_pagina_logica do begin
				if pagina_stampata(i) then begin
					s := get_logical_page_1B(i).get_descrizione(TRUE);
					if (cb_pagina_logica.Items.indexof(s) <> -1) then begin
//						MessageBBox(handle,'ATTENZIONE: vi sono pagine logiche con descrizione identica.', MBOX_CAPTION);
						cb_pagina_logica.Clear;
						break
					end;
					cb_pagina_logica.Items.add(s)
				end
			end;

			if (cb_pagina_logica.Items.Count > 0) then
				multi_pagina := cl_multi_dialog.create(self, 'Sezioni di stampa', cb_pagina_logica,
					btn_pagina_logica, str_pagine_logiche, '', [], '(selezione)', cb_pagina_logica_change)
		end;
		runtime_debug('040', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		cbx_sezione_corrente.Visible := (cb_pagina_logica.Items.Count > 0);
		visible_FC(txt_pagina_logica, cbx_sezione_corrente.Visible);
		btn_pagina_logica.Visible := cbx_sezione_corrente.Visible;

		expint_profilo_load_items(cb_profilo_export.Items);
		cb_profilo_export.ItemIndex := 0;		// sempre predefinito il PRIMO PROFILO di export
//		enable_FC(txt_profilo_export, cb_profilo_export.Items.Count > 1);		*** NO, lascio vedere in chiaro
		for var i : byte := 0 to byte(high(export_integrale_target_type)) do rb_export_target.Items.Add(EITT_DESCRIZIONE[export_integrale_target_type(i)]);
		cb_export_file_writemode.Hint := FWT_HINTS;
		for var i : byte := 0 to byte(high(file_writemode_type)) do cb_export_file_writemode.Items.Add(FWT_DESCR[file_writemode_type(i)]);
		for var i : byte := 0 to byte(high(export_file_action_type)) do cb_export_file_azione.Items.Add(EFAT_DESCR[export_file_action_type(i)]);
		btn_impostazioni_FTP.Left := cb_export_file_azione.Left + cb_export_file_azione.Width + 4;

//		applica_profilo_export;		*** inizialmente assegno le opzioni specificate all'esterno di questa proc
		rb_export_target.Itemindex := byte(exec_export_options.target);
		cb_export_file_azione.Itemindex := byte(exec_export_options.EFAT_action);
		cb_export_file_writemode.ItemIndex := byte(exec_export_options.writemode);

//		rb_modalita_mail.ItemIndex := byte(static_SMTP.modalita <> MMT_LOCAL_SMTP);		// 0=SMTP, 1=client
//		case xstatic_SMTP.modalita of
		case globale.modalita_invio_mail of
//			GSMM_DEFAULT_MAPI_CLIENT : rb_modalita_mail.ItemIndex := 0;
			GSMM_OUTLOOK : rb_modalita_mail.ItemIndex := 1;
			GSMM_LOCAL_SMTP : rb_modalita_mail.ItemIndex := 2
			else rb_modalita_mail.ItemIndex := 0
		end;

		runtime_debug('050', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		if (printer.printers.Count = 0) then begin
			MessageBBox(handle,'Per favore, abbi la cortesia di installare almeno una stampante '+
				'prima di pensare di scegliere quella che trasferirà sulla carta questo grazioso documento', MBOX_CAPTION);
			abort
		end;
		str_default_printer.Text := str_stampante_predefinita;
		lb.Items.add(STAMPANTE_PREDEFINITA);
		with printer do for var i : smallint := 1 to printers.Count do lb.Items.add(printers[i - 1]);
		runtime_debug('060', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		select_default_printer;	// imposta la stampante da utilizzare
		runtime_debug('070', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01);
		bo_open_ok := TRUE;
		enable_ctrls;		// dopo BO_OPEN_OK = TRUE
		{$ifdef DEBUG} check_components(self) {$endif DEBUG}
	except
		bo_open_ok := FALSE
	end;
	runtime_debug('999', MBOX_DEBUG_CAPTION, RD_DEBUG_ACCESSORIO_01)
end;

procedure Tdlg_select_printer.FormDestroy(Sender : TObject);
begin
	multi_dialog_free(multi_pagina);
	multi_dialog_free(multi_email);
	PDF_opt.free;PDF_opt := NIL
end;

procedure Tdlg_select_printer.FormActivate(Sender : TObject);
begin
	if bo_activated OR NOT bo_open_ok then exit;
//	bo_activated := TRUE;		// qui fino al 2015-04-05, spostato sotto perchè l'assegnazione di STR_INTERVALLO invalidava l'assegnazione delle pagine logiche
	str_intervallo.Text := pt_str_intervallo_pagine^;
	if (multi_pagina <> NIL) AND NOT multi_pagina.all_selected then begin
		var s := str_pagine_logiche;
		MessageBBox(handle, 'Saranno stampate solo le seguenti pagine logiche:' + ACAPO2 + sostituisci(s, ',', ACAPO), MBOX_CAPTION)
	end;
	if (multi_pagina <> NIL) then multi_pagina.write;
//	frecce_from.max := i_max_page;frecce_to.max := i_max_page;
	i_num_copie.set_VAR_smallint(pt_i_num_copie^);

	enable_ctrls;
	if cbx_email.Checked then try cb_email.SetFocus except end
	else if cbx_PDF.Checked then setfocus_file_path;

	bo_activated := TRUE
end;

procedure Tdlg_select_printer.cbx_pagina_correnteClick(Sender : TObject);
begin
	var bo := NOT cbx_pagina_corrente.Checked;
	if NOT bo then begin
		str_intervallo.Text := i_pagina_corrente.ToString;
//		i_page_from.set_Asinteger(i_pagina_corrente);i_page_to.set_Asinteger(i_pagina_corrente);
		cb_pagina_logica.ItemIndex := -1
	end;
	enable_ctrls
end;

procedure Tdlg_select_printer.cbx_sezione_correnteClick(Sender : TObject);
begin
	var bo := cbx_sezione_corrente.Checked;
	if bo then begin
		str_pagine_logiche := get_logical_page_1B(get_pagina_logica_attiva_1B).get_descrizione(TRUE);
		multi_pagina.write;
		cb_pagina_logica_change(NIL)
	end;
	enable_ctrls
end;

procedure Tdlg_select_printer.AL_applyExecute(Sender: TObject); begin apply(FALSE) end;
procedure Tdlg_select_printer.AL_next_cassettoExecute(Sender: TObject); begin with cb_cassetto do Itemindex := ifi(itemindex = items.Count-1, 0, itemindex + 1) end;
procedure Tdlg_select_printer.AL_set_current_pageExecute(Sender: TObject); begin if cbx_pagina_corrente.Enabled then cbx_pagina_corrente.Checked := NOT cbx_pagina_corrente.Checked end;
procedure Tdlg_select_printer.AL_set_current_sectionExecute(Sender: TObject); begin if cbx_sezione_corrente.Enabled then cbx_sezione_corrente.Enabled := NOT cbx_sezione_corrente.Enabled end;
procedure Tdlg_select_printer.AL_set_emailExecute(Sender: TObject); begin if cbx_email.Enabled AND cbx_email.Visible then cbx_email.Checked := NOT cbx_email.Checked end;
procedure Tdlg_select_printer.AL_set_expintExecute(Sender: TObject); begin if cbx_export_dati.Visible AND cbx_export_dati.Enabled then cbx_export_dati.Checked := NOT cbx_export_dati.Checked end;
procedure Tdlg_select_printer.AL_set_PDFExecute(Sender: TObject); begin if cbx_PDF.Visible AND cbx_PDF.Enabled then cbx_PDF.Checked := NOT cbx_PDF.Checked end;

procedure Tdlg_select_printer.AL_previewExecute(Sender: TObject);
begin
	{$ifdef DEBUG} assert(pt_lo_print_style <> NIL,'QIMM 2093'); {$endif}
{	if (pt_lo_print_style^ AND GAL_POPT_PRINT_PRINTER <> 0) then
		pt_lo_print_style^ := pt_lo_print_style^ - GAL_POPT_PRINT_PRINTER; }
	pt_lo_print_style^ := (pt_lo_print_style^ AND NOT GAL_POPT_PRINT_PRINTER);
	apply(FALSE)
end;

procedure Tdlg_select_printer.lbClick(Sender : TObject);
begin
	enable_ctrls;
	fill_info_cassetto_carta(lb.Items[lb.Itemindex], cb_cassetto)
end;

procedure Tdlg_select_printer.AL_saveExecute(Sender: TObject); begin apply(TRUE) end;
procedure Tdlg_select_printer.lbDblClick(Sender : TObject); begin apply(TRUE) end;
procedure Tdlg_select_printer.rb_modalita_mailClick(Sender : TObject); begin enable_ctrls end;

procedure Tdlg_select_printer.btn_cancelClick(Sender : TObject);
begin
	pt_bo_modified^ := FALSE;
	pt_bo_printer_changed^ := FALSE;
//	xbo_aborted := TRUE;	// indico che ho chiuso senza 'salvare'

	if (lb.ItemIndex-1 <> printer.printerindex) then
//		printer.printerindex := printer.Printers.indexof(globale.str_printer);	*
		printer.printerindex := i_printerindex_selected_on_enter;

	close
end;

procedure Tdlg_select_printer.apply(bo_close_window : boolean);
// if BO_CLOSE_WINDOW then sto chiudendo la finestra per andare a stampare (o exportare), altrimenti schiacciato APPLY (o equivalente)
var
	i, j : integer;	//**
	s, str_error, str_mail_filename : string;
begin
//	xbo_aborted := FALSE;
	btn_ok.SetFocus;
	if (lb.Itemindex = -1) then begin beep(0);exit end;
	pt_bo_send_as_email^ := cbx_email.Enabled AND cbx_email.Checked;

	if cbx_PDF.Enabled AND cbx_PDF.Checked then pt_target^ := RTA_PDF else
	if cbx_export_dati.Enabled AND cbx_export_dati.Checked then begin
//		if (rb_export_modalita.ItemIndex = 0) then begin		*** il numero degli items non è fisso
		pt_target^ := RTA_EXPORT;
		exec_export_options.i_profilo := cb_profilo_export.ItemIndex;
		globale.i_active_expint_profile := exec_export_options.i_profilo
	end
	else pt_target^ := RTA_PRINTER;
	exec_export_options.target := export_integrale_target_type(rb_export_target.Itemindex);
	exec_export_options.EFAT_action := export_file_action_type(cb_export_file_azione.Itemindex);
	exec_export_options.writemode := file_writemode_type(cb_export_file_writemode.Itemindex);

//	exec_export_options.str_comando_specifico := ;		attualmente non modificabile localmente, si usa sempre il default (GLOBALE.xxxxx)

	if pt_bo_send_as_email^ then begin
		str_mail_filename := get_temp_directory + coalesce(ExtractFileName(str_filename.Text), get_datetime_as_filename);
		if (pt_target^ = RTA_EXPORT) then exec_export_options.target := EITT_FILE
	end;

//	if exec_export_options.bo_export_integrale AND (exec_export_options.target in EITT_FILE) then begin
//	if (pt_target^ = xRTA_EXPORT_INTEGRALE) AND (exec_export_options.target in EITT_FILE_TYPES) then begin
	if (pt_target^ = RTA_EXPORT) AND (exec_export_options.target in EITT_FILE_TYPES) then begin
		pt_str_target_filename^ := ifs(pt_bo_send_as_email^, str_mail_filename, str_filename.Text);
		if end_with(pt_str_target_filename^, PDF_EXT, FALSE) OR (ExtractFileExt(pt_str_target_filename^) = '') then
//			pt_str_target_filename^ := changeFileExt(pt_str_target_filename^, *EITT_DEFAULT_FILE_EXT)		{$ifndef DEBUG} *** personalizzare per XML {$endif}
//			pt_str_target_filename^ := changeFileExt(pt_str_target_filename^, ifs(pt_target^ = xRTA_XML, XML_EXT, EITT_DEFAULT_FILE_EXT))
			// lowercase(XML) perchè la fattura elettronica (ARUBA) richiede l'extensione minuscola
			pt_str_target_filename^ := changeFileExt(pt_str_target_filename^, ifs(exec_export_options.bo_XML, LOWER_XML_EXT, EITT_DEFAULT_FILE_EXT))
	end;

	if (pt_target^ = RTA_PDF) then begin
//		PDF_opt.str_PDF_filename := togliblanks(str_filename.Text);
		if panel_filename.Visible then begin
			pt_str_target_filename^ := togliblanks(str_filename.Text);
//			if pt_bo_send_as_email^ then PDF_opt.str_PDF_filename := get_temp_directory + ExtractFileName(PDF_opt.str_PDF_filename)
//			if pt_bo_send_as_email^ then PDF_opt.str_PDF_filename := changeFileExt(str_mail_filename, PDF_EXT)
			if pt_bo_send_as_email^ then pt_str_target_filename^ := changeFileExt(str_mail_filename, PDF_EXT)
//			else if (PDF_opt.str_PDF_filename = '') then begin
			else if (pt_str_target_filename^ = '') then begin
				MessageBBox(handle, 'Indica il file su cui eseguire il salvataggio', MBOX_CAPTION);
				exit
			end
		end
		else begin
			pt_str_target_path^ := togliblanks(str_path.Text);
			if (pt_str_target_path^ = '') AND NOT pt_bo_send_as_email^ then begin		// se mando per mail, salvo su cartella temporanea
				MessageBBox(handle, 'Indica il percorso di salvataggio dei files', MBOX_CAPTION);
				exit
			end
		end;

		PDF_opt.behaviour := PDF_behaviour(rb_PDF_behaviour.Itemindex)
	end;

	pt_str_email_address^ := '';
	if pt_bo_send_as_email^ then begin
//		pt_str_email_address^ := togliblanks(cb_email.Text);
//		pt_str_email_address^ := str_email;	** fino 2023-05-15
		pt_str_email_address^ := coalesce(str_email, cb_email.Text);

//		if (rb_modalita_mail.ItemIndex = 0) then static_SMTP.modalita := MMT_LOCAL_SMTP else static_SMTP.modalita := MMT_DEFAULT_MAPI_CLIENT;
		case rb_modalita_mail.ItemIndex of
//			0 : static_SMTP.modalita := MMT_DEFAULT_MAPI_CLIENT;
			1 : globale.modalita_invio_mail := GSMM_OUTLOOK;
			2 : globale.modalita_invio_mail := GSMM_LOCAL_SMTP
			else globale.modalita_invio_mail := GSMM_DEFAULT_MAPI_CLIENT
		end;
		if (globale.modalita_invio_mail in [GSMM_DEFAULT_MAPI_CLIENT, GSMM_OUTLOOK]) then begin
globale.bo_address_required := TRUE;	// non so perchè ma se manca l'indirizzo la mail non viene generata !!! ?????????????????
			if globale.bo_address_required AND (pt_str_email_address^ = '') then begin
				MessageBBox(handle, 'Indirizzo e-mail non indicato', MBOX_CAPTION);
				exit
			end
		end
	end;

	if (panel_filename.Visible AND {(pt_str_target_filename^ <> '') AND}
		 (pt_bo_send_as_email^ OR (pt_target^ = RTA_PDF) OR
		  ((pt_target^ = RTA_EXPORT) AND (exec_export_options.target in EITT_FILE_TYPES)))) OR
		(panel_filepath.Visible {AND (pt_str_target_path^ <> '')})
	then begin
		if panel_filename.Visible then s := ExtractFilePath(pt_str_target_filename^) else s := pt_str_target_path^;
		if (s <> '') AND NOT DirectoryExists(s) then begin
			MessageBBox(handle, 'Il percorso ' + uppercase(s) + ' non esiste o non è accessibile.', MBOX_CAPTION, MB_ICONSTOP);
			exit
		end;
		if (s <> '') AND NOT writeable_path(s, str_error) then begin		// 2016-02-26
			MessageBBox(handle, 'Il percorso ' + uppercase(s) + ' non è accessibile in scrittura', MBOX_CAPTION, MB_ICONSTOP);
			exit
		end;
		if NOT panel_filepath.Visible then pt_str_target_path^ := ExtractFilePath(pt_str_target_filename^)		// assegno il PATH
	end;

	PDF_opt_originale.assign(PDF_opt, 0);

	Ival(i_num_copie.Text, j, i);
	pt_i_num_copie^ := j;
	if gb_pagine.Enabled then begin
		// necessario, perchè altrimenti non lo legge -- non capisco, ma mi adeguo
//		Ival(i_page_from.Text,j,i);pt_i_page_from^ := j;
//		Ival(i_page_to.Text,j,i);pt_i_page_to^ := j

		pt_str_intervallo_pagine^ := str_intervallo.Text;
		if NOT check_intervallo(str_intervallo.Text) OR (get_intervallo_min(str_intervallo.Text) < 1) then begin
			MessageBBox(handle, 'Intervallo pagine non valido: ' + ACAPO2 + str_intervallo.Text, MBOX_CAPTION, MB_ICONSTOP);
			exit
		end;
		if (get_intervallo_max(str_intervallo.Text) > i_max_page) then begin
			MessageBBox(handle, 'Intervallo pagine non valido -- ultima pagina stampabile: ' + i_max_page.ToString + ACAPO2 + str_intervallo.Text, MBOX_CAPTION, MB_ICONSTOP);
			exit
		end;
		pt_str_intervallo_pagine^ := get_intervallo_normalizzato(pt_str_intervallo_pagine^)
	end;
	if (pt_target^ <> RTA_PRINTER) then pt_i_num_copie^ := 1;	// sempre!
	pt_str_pagine_logiche^ := str_pagine_logiche;

	if (lb.ItemIndex = 0) then s := '' else s := lb.Items[lb.ItemIndex];
	pt_bo_modified^ := bo_close_window;
//	pt_bo_printer_changed^ := (uppercase(s) <> uppercase(globale.xstr_printer));
	pt_bo_printer_changed^ := (uppercase(s) <> uppercase(globale.str_current_printer));
	globale.str_current_printer := s;		// carattere normale (no uppercase)
	s := uppercase(s);
//	globale.xstr_printer := s;
//	if pt_bo_modified^ AND globale.bo_report then begin	// se ha deciso di stampare, checcko i vari elementi
	if pt_bo_modified^ AND (globale.tiporeport in REPORT_TYPES) then begin	// se ha deciso di stampare, checcko i vari elementi
{		if (str_pagine_logiche = '') AND
			((pt_i_page_from^ < 1) OR (pt_i_page_to^ < 1) OR (pt_i_page_to^ > i_max_page) OR (pt_i_page_from^ > pt_i_page_to^))
		then begin
			MessageBBox(handle, 'Hey, le pagine devono essere nell''intervallo: 1-' + i_max_page.ToString, MBOX_CAPTION);
			abort
		end; }
		if (pt_i_num_copie^ < 1) then begin
			MessageBBox(handle, 'Hey, non puoi stampare meno di 1 copia!!!', MBOX_CAPTION);
			abort
		end
	end;
(*	if pt_bo_printer_changed^ then begin
		{$ifndef DLL}
			if globale.bo_report then
				MessageBBox(handle,'La stampante predefinita per questo documento non è stata modificata.'+ACAPO2+
					'Questa finestra consente solamente di modificare la stampante su cui si esegue la stampa di prova',
					MBOX_CAPTION);
		{$endif}
		if (pt_bo_printer_changed^) then begin
			printer.printerindex := lb.ItemIndex-1;
			base_printer_configuration
		end
	end; *)

	if pt_bo_printer_changed^ then begin
{$ifndef DLL}
//		if globale.bo_report then
		if (globale.tiporeport in REPORT_TYPES) then
			MessageBBox(handle,'La stampante predefinita per questo documento NON è stata modificata.' + ACAPO2 +
				'Questa finestra consente solamente di modificare la stampante su cui si esegue la stampa di prova',
				MBOX_CAPTION);
{$endif NOT DLL}
		if (lb.ItemIndex <= 0) then s := str_default_printer.Text else s := lb.Items[lb.Itemindex];
		set_phisical_active_printer(self, {forza}FALSE, s)
	end;

//	globale.printer_default[0].str_cassetto := cb_cassetto.Text;
	pt_bo_applica_stampante_all_pages^ := cbx_apply_all_pages.Checked AND panel_apply_all_pages.Visible;
	globale.str_current_tray := cb_cassetto.Text;
	close
end;

(*procedure Tdlg_select_printer.btn_browse_fileClick(Sender : TObject);
var dlg : TSaveDialog;
begin
	dlg := TSaveDialog.create(self);
	dlg.defaultext := PDF_EXT;dlg.filter := PDF_FILTER;
	dlg.options := [ofEnableSizing,ofNoReadOnlyReturn,{ofOverwritePrompt,}ofPathMustExist];
	dlg.filename := str_filename.Text;
	if dlg.execute then str_filename.Text := dlg.Filename;
	dlg.free
end;  *)

procedure Tdlg_select_printer.btn_browse_fileClick(Sender : TObject);
var str_ext, str_filter, str_filename, str_path, str_default_path : string;
begin
	var bo_PDF := cbx_PDF.Checked;
	var bo_XML := NOT bo_PDF AND exec_export_options.bo_XML;

	if bo_PDF then begin str_ext := PDF_EXT;str_filter := PDF_FILTER end else
	if bo_XML then begin str_ext := XML_EXT;str_filter := XML_FILTER end else
	begin str_ext := ALL_FILES_DEFAULT_EXT;str_filter := ALL_FILES_FILTER end;

	str_filename := self.str_filename.Text;
	str_default_path := globale.get_default_write_filepath({target_export}NOT bo_PDF);
	if filename_has_explicit_path(str_filename) then str_path := extractFilePath(str_filename)
	else begin
		if (pt_str_target_path <> NIL) then str_path := pt_str_target_path^;
		if (str_path = '') then str_path := str_default_path;
		str_filename := make_filename(str_filename, str_path)
	end;

	if NOT browse_for_files_save(self, 'Percorso di salvataggio', str_filename, str_ext, str_filter, str_path) then exit;
	if start_with(str_filename, str_default_path, {case-sens}FALSE) then exit;	// non assegno il path se uguale a quello DEFAULT (non PT_STR_TARGET_PATH^)
	self.str_filename.Text := str_filename
end;

procedure Tdlg_select_printer.btn_browse_pathClick(Sender : TObject);
begin
	browse_directory(self, 'Seleziona percorso di salvataggio', str_path, globale.str_default_export_filepath)
end;

procedure Tdlg_select_printer.SetFocus_file_path;
// mette il focus sulla casella del nomefile oppure del path
begin
	if NOT bo_open_ok then exit;		// finestra non ancora (completamente) aperta
	try
		if panel_filename.Visible AND str_filename.Enabled then str_filename.SetFocus;
		if panel_filepath.Visible AND str_path.Enabled then str_path.SetFocus
	except
	end
end;

procedure Tdlg_select_printer.rb_PDF_behaviourClick(Sender : TObject);
begin
	enable_ctrls;
	setfocus_file_path
end;

procedure Tdlg_select_printer.set_target_filename(bo_export : boolean;bo_forza_assegnazione : boolean = FALSE);
begin
	if NOT bo_filenames_differenziati_per_target then exit;		// gestione non attiva, nulla da fare
	if NOT bo_forza_assegnazione AND (bo_selected_target_export_filename = bo_export) then exit;	// target già attivo, nulla da fare

	var bo := bo_selected_target_export_filename;
	var s := str_filename.Text;
	str_filename.Text := str_target_filenames[bo];
	str_target_filenames[bo] := s;
	bo_selected_target_export_filename := NOT bo
end;

procedure Tdlg_select_printer.cbx_PDFClick(Sender : TObject);
begin
//	cbx_email.Checked := bo_PDF_allowed AND cbx_email.Checked AND cbx_PDF.Checked;
	if cbx_PDF.Checked then begin
		if cbx_export_dati.Checked then cbx_export_dati.Checked := FALSE
	end
	else begin
		if cbx_email.Checked AND NOT cbx_export_dati.Checked then cbx_email.Checked := FALSE
	end;
	if NOT bo_activated then exit;
//	if cbx_PDF.Checked then setfocus_file_path;
	enable_ctrls;
	if cbx_PDF.Checked then setfocus_file_path
end;

procedure Tdlg_select_printer.cbx_export_datiClick(Sender : TObject);
begin
	if cbx_export_dati.Checked then begin
		if cbx_PDF.Checked then cbx_PDF.Checked := FALSE
	end
	else begin
		if cbx_email.Checked AND NOT cbx_PDF.Checked then cbx_email.Checked := FALSE
	end;
	if NOT bo_activated then exit;
	enable_ctrls;
//	if cbx_export.Checked then try str_filename.SetFocus except end
end;

procedure Tdlg_select_printer.rb_export_targetClick(Sender : TObject); begin enable_ctrls end;

procedure Tdlg_select_printer.cbx_emailClick(Sender : TObject);
begin
//	cbx_PDF.Checked := bo_PDF_allowed AND (cbx_PDF.Checked OR cbx_email.Checked);
	if cbx_email.Checked then begin
		if NOT cbx_PDF.Checked AND NOT cbx_export_dati.Checked then begin
			if bo_PDF_allowed then cbx_PDF.Checked := TRUE
			else cbx_export_dati.Checked := TRUE
		end;
//		if (cbx_export_integrale.Checked) then cbx_export_integrale.Checked := FALSE;
//		if NOT cbx_PDF.Checked AND bo_PDF_allowed then cbx_PDF.Checked := TRUE
	end;
{$ifdef DLL}
	if NOT globale.bo_main_info_user_messages_displayed then begin
		var str_message : string;
		globale.bo_main_info_user_messages_displayed := TRUE;
		if globale.bo_warning_on_multiple_mail_addresses AND (cb_email.Items.Count > 1) then
			add_delimited(str_message, 'Sono presenti più indirizzi mail', ACAPO2);
		if (globale.str_runtime_mail_user_message <> '') then add_delimited(str_message, globale.str_runtime_mail_user_message, ACAPO2);
		if (str_message <> '') then MessageBBox(handle, str_message, 'Invio documento')
	end;
{$endif DLL}

	if NOT bo_activated then exit;
//	if cbx_email.Checked AND cb_email.Enabled AND cb_email.Visible then cb_email.Setfocus;
	if panel_mail.Visible then cb_email.Setfocus;
	enable_ctrls
end;

// -----------------------------------------------------------------------------

procedure Tdlg_select_printer.set_email_combo;
begin
	cb_email.Items.clear;//cb_email.Text := '';
	cb_email.Items.Text := globale.get_email_elenco;
	str_email := globale.get_email_default;
	if (str_email = '') then cb_email.Text := ''		// altrimenti in certe circostanze compare il testo CB_EMAIL (francamente poco gradevole)
	else begin
		if (cb_email.Items.indexof(str_email) = -1) then cb_email.Items.insert(0, str_email);		// inserisco in testa
		cb_select(cb_email, str_email)
	end;
	multi_email := cl_multi_dialog.create(self, 'E-mail', cb_email, btn_email, str_email)
end;

procedure Tdlg_select_printer.cb_pagina_logica_change(pt : pointer);
begin
	try
		bo_setting_sezione := TRUE;
		str_intervallo.Text := get_intervallo_pagine_logiche(str_pagine_logiche)
	finally
		bo_setting_sezione := FALSE
	end
end;

procedure Tdlg_select_printer.str_intervalloChange(Sender : TObject);
begin
	if bo_activated AND NOT bo_setting_sezione AND ((sender as TFEdit).Text <> '') then begin
		str_pagine_logiche := '';
		if (multi_pagina <> NIL) then multi_pagina.write
	end
end;

procedure Tdlg_select_printer.btn_advancedClick(Sender : TObject);
var i_printer_index : smallint;	//*
begin
	if (lb.ItemIndex = 0) then i_printer_index := get_default_printer_index		// stampante predefinita
	else i_printer_index := lb.ItemIndex-1;
	if (printer.printerindex <> i_printer_index) then printer.printerindex := i_printer_index;

	if printer.document_properties(self) then begin
		bo_document_properties_modified := TRUE;
		enable_ctrls
	end
end;

procedure Tdlg_select_printer.enable_ctrls;
begin
	if NOT bo_open_ok then exit;		// finestra non ancora (del tutto) aperta
	panel_filename.Visible := FALSE;
	panel_filepath.Visible := FALSE;
	panel_mail.Visible := cbx_email.Enabled AND cbx_email.Checked;
	if NOT panel_mail.Visible then begin
		if cbx_PDF.Checked then begin
			if (PDF_behaviour(rb_PDF_behaviour.Itemindex) in PDFH_MULTI_FILES) then panel_filepath.Visible := TRUE
			else panel_filename.Visible := TRUE
		end
		else if (cbx_export_dati.Checked AND (export_integrale_target_type(rb_export_target.Itemindex) in EITT_FILE_TYPES))
			then panel_filename.Visible := TRUE
	end;

	AL_apply.Enabled := (lb.ItemIndex <> i_default_itemindex) OR bo_document_properties_modified;
	rb_PDF_behaviour.Enabled := NOT cbx_email.Checked;
	rb_export_target.Enabled := NOT cbx_email.Checked;

//	enable_FC(txt_expint_file_azione, rb_expint_target.Enabled AND (export_integrale_target_type(rb_expint_target.ItemIndex) in EITT_FILE));
//	target := export_integrale_target_type(rb_expint_target.Itemindex + 1); *** fino 2015-04-18
	var target : export_integrale_target_type := export_integrale_target_type(rb_export_target.Itemindex);
	var bo := rb_export_target.Enabled AND (target in EITT_FILE_TYPES);
	visible_FC(txt_export_file_writemode, bo);
	visible_FC(txt_export_file_azione, bo AND (target = EITT_FILE));
	btn_impostazioni_FTP.Visible := bo AND (target = EITT_FTP);

	if NOT bo_PDF_allowed then begin
		cbx_PDF.Enabled := FALSE;
//		cbx_email.Enabled := FALSE
	end;

	panel_apply_all_pages.Visible := bo_enable_apply_all_pages AND NOT (cbx_PDF.Visible AND cbx_PDF.Enabled AND cbx_PDF.Checked);

	bo := (i_max_page > 1) AND NOT cbx_pagina_corrente.Checked AND NOT cbx_sezione_corrente.Checked;
	enable_FC(txt_intervallo, bo);
//	enable_FC(txt_page_from, bo);enable_FC(txt_page_to, bo);
	enable_FC(txt_pagina_logica, bo);
	btn_pagina_logica.Enabled := bo;
	cbx_sezione_corrente.Enabled := (i_max_page > 1) AND NOT cbx_pagina_corrente.Checked;
	cbx_pagina_corrente.Enabled := (i_max_page > 1) AND NOT cbx_sezione_corrente.Checked;

	cbx_export_dati.Enabled := (globale.tiporeport = TR_REPORT) AND globale.bo_export_allowed;

{	str_path.Visible := FALSE;
	str_filename.Visible := FALSE;
	if NOT cb_email.Visible then begin
		if cbx_PDF.Checked then begin
			if (PDF_behaviour(rb_PDF_behaviour.Itemindex) in PDFH_MULTI_FILES) then str_path.Visible := TRUE
			else str_filename.Visible := TRUE
		end
		else if (cbx_export_integrale.Checked AND (export_integrale_target_type(rb_expint_target.Itemindex + 1) in EITT_FILE_TYPES))
			then str_filename.Visible := TRUE
	end; }

	if cbx_email.Checked then pc.Activepage := page_SMTP
	else if cbx_PDF.Checked then pc.Activepage := page_PDF
	else if cbx_export_dati.Checked then pc.Activepage := page_export
	else pc.ActivePage := page_printer;

	set_target_filename(cbx_export_dati.Checked);
	btn_mail_config.Enabled := (rb_modalita_mail.ItemIndex in [1, 2]);
	case rb_modalita_mail.ItemIndex of
		0 : btn_mail_config.Caption := 'parametri mail';
		1 : btn_mail_config.Caption := 'parametri OUTLOOK';
		2 : btn_mail_config.Caption := 'parametri SMTP'
	end
end;

procedure Tdlg_select_printer.btn_opzioni_PDFClick(Sender : TObject);
begin
	PDF_opt.behaviour := PDF_behaviour(rb_PDF_behaviour.ItemIndex);
	if PDF_options_dialog(self, PDF_opt, TRUE, cbx_email.Checked) then begin
		rb_PDF_behaviour.ItemIndex := byte(PDF_opt.behaviour);
//		if cbx_email.Checked then set_email_combo;
		enable_ctrls	// per scrupolo
	end
end;

procedure Tdlg_select_printer.btn_impostazioni_FTPClick(Sender : TObject);
begin
	FTP_impostazioni_proc(self, exec_export_options.FTP_parms, {executive_parms}TRUE)
end;

procedure Tdlg_select_printer.btn_open_pathClick(Sender : TObject);
var s : string;
begin
	if panel_filepath.Visible then begin
		s := togliblanks(str_path.Text);
		if (s <> '') then explorer_open_folder(handle, s)
	end
	else begin
		s := str_filename.Text;
		if FileExists(s) then explorer_select_filename(handle, s) else explorer_open_folder(handle, extractFilePath(s))
	end
end;

procedure Tdlg_select_printer.btn_mail_configClick(Sender : TObject);
begin
	case rb_modalita_mail.ItemIndex of
		0 : btn_mail_config.Caption := 'parametri mail';
		1 : OUTLOOK_config_dialog_proc(self, static_OUTLOOK, {can_test}TRUE);
		2 : SMTP_config_dialog_proc(self, work_SMTP, {can_test}TRUE)
	end
end;

procedure Tdlg_select_printer.applica_profilo_export;
begin
	if NOT globale.bo_export_allowed OR (cb_profilo_export.Items.Count = 0) then exit;
	var prof : cl_expint_profilo := get_expint_profilo(cb_profilo_export.Text);
	if (prof = NIL) then prof := get_expint_profilo(cb_profilo_export.ItemIndex);

	rb_export_target.ItemIndex := byte(prof.target_default);
	cb_export_file_azione.Itemindex := byte(prof.EFAT_default_action);
	cb_export_file_writemode.ItemIndex := byte(prof.writemode_default)
end;

procedure Tdlg_select_printer.cb_profilo_exportChange(Sender : TObject); begin applica_profilo_export end;

procedure init_printer_select;
// soprattutto se WIN64 da NON chiamare prima dell'avvio dell' EXE, altrimenti si pianta tutto (2025-12-29)
begin
	if esiste_stampante(FALSE) AND (printer <> NIL) then str_stampante_predefinita := printer.printers[printer.printerindex]
end;

initialization
	galateo_initialization_debug('printer_select');
	{$ifdef DEBUG} assert(printer <> NIL, 'printer IS NIL !!!!!! -- printer_select'); {$endif}
//	init_printer_select
finalization
	galateo_finalization_debug('printer_select')
end.
