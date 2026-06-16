unit pagina_logica_edit;

{$I defines}
{$ifdef DLL} *** {$endif}

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, ActnList, Actions,
	FCommons, Federico, FBitBtn,
	Gdich, expint_base, Gun;

function pagina_logica_edit_proc(father : TForm;bo_allows_external : boolean;bo_open_on_exportazione : boolean = FALSE;i_profilo : expint_index_type = 0) : boolean;
// BO_ALLOWS_EXTERNAL abilita/disabilita la possibilità che la pagina corrente venga impostata come external

type
  Tdlg_pagina_logica = class(TForm)
	 pc: TPageControl;
	 page_base: TTabSheet;
	 page_GAPP: TTabSheet;
	 txt_section_filename: TLabel;
	 txt_descrizione: TLabel;
	 txt_ID_pagina: TLabel;
	 txt_PDF_watermark: TLabel;
	 txt_message_if_printed: TLabel;
	 txt_descrizione_lunga: TLabel;
	 str_section_filename: TEdit;
	 btn_browse: TFBitBtn;
	 str_descrizione_breve: TEdit;
	 str_ID_pagina: TFEdit;
    cbx_message_if_not_printed: TFCheckBox;
	 str_PDF_watermark: TFEdit;
	 btn_PDF_watermark_open: TFBitBtn;
	 btn_PDF_watermark_browse: TFBitBtn;
	 panel_colore_base: TFPanel;
	 txt_colore_fondo: TLabel;
	 panel_colore_alt: TFPanel;
	 txt_colore_alt: TLabel;
    cbx_blink: TFCheckBox;
    cbx_default_dont_print_page: TFCheckBox;
    str_message_if_printed: TEdit;
    btn_colore_std: TFBitBtn;
    str_descrizione_estesa: TEdit;
	 rb_PL_external: TRadioGroup;
    txt_last_saved_by: TLabel;
    str_last_saved_by: TEdit;
	 btn_open_last_saved_by: TFBitBtn;
    panel_GAPP_attiva: TFPanel;
    panel_GAPP_codice: TFPanel;
    panel_GAPP_operatore: TFPanel;
	 cbx_attiva_GAPP: TFCheckBox;
    txt_obj_automatic_index: TLabel;
    cb_GAPP_str_tipo_progressivo: TFCombo;
    panel_GAPP_record: TFPanel;
    panel_GAPP_esercizio: TFPanel;
    txt_esercizio: TLabel;
	 cb_GAPP_esercizio: TFCombo;
	 txt_GAPP_record: TLabel;
	 cb_GAPP_str_record: TFCombo;
	 panel_GAPP_data: TFPanel;
	 txt_AI_dt_riferimento: TLabel;
	 cb_GAPP_dt_riferimento: TFCombo;
	 txt_AI_operatore: TLabel;
	 cb_GAPP_operatore: TFCombo;
	 page_exportazione: TTabSheet;
    panel_export_edit: TFPanel;
    txt_versione_external_file: TLabel;
    cbx_dont_print: TFCheckBox;
	 txt_condizione: TMyLabel;
    str_condizione: TFEdit;
    pc_export: TFPageControl;
    page_expint: TTabSheet;
	 page_XML: TTabSheet;
    panel_expint: TFPanel;
    cbx_expint_pagina_fisica: TFCheckBox;
    cbx_expint_pagina_logica: TFCheckBox;
    cbx_expint_sezione: TFCheckBox;
    cbx_expint_record: TFCheckBox;
    cbx_expint_headers: TFCheckBox;
    cbx_blank_after_headers: TFCheckBox;
    panel_export_header: TFPanel;
    txt_export_sigla: TMyLabel;
    cbx_export_allowed: TFCheckBox;
    str_export_sigla: TFEdit;
    txt_struttura_XML: TMyLabel;
    str_struttura_XML: TFMemo;
	 panel_buttons: TFPanel;
    btn_ok: TFBitBtn;
    btn_cancel: TFBitBtn;
	 btn_help: TMyBitBtn;
    lv_export: TListView;
    AL: TActionList;
    AL_save: TAction;
    page_size_constraints: TTabSheet;
    gbox_printer_size_MIN: TFGroupBox;
    txt_page_min_height: TMyLabel;
    txt_page_min_width: TMyLabel;
    i_min_page_height: TFEdit;
    i_min_page_width: TFEdit;
    gbox_printer_size_MAX: TFGroupBox;
    txt_page_max_height: TMyLabel;
    txt_page_max_width: TMyLabel;
    i_max_page_height: TFEdit;
    i_max_page_width: TFEdit;
    txt_size_modalita: TMyLabel;
	 cb_size_modalita: TFCombo;
	 txt_size_header: TMyLabel;
	 cbx_exclude_debug: TFCheckBox;
	 procedure FormCreate(Sender : TObject);
	 procedure btn_browseClick(Sender : TObject);
	 procedure btn_cancelClick(Sender : TObject);
	 procedure btn_PDF_watermark_browseClick(Sender : TObject);
	 procedure btn_PDF_watermark_openClick(Sender : TObject);
	 procedure txt_colore_fondoClick(Sender : TObject);
	 procedure txt_colore_altClick(Sender : TObject);
	 procedure cbx_blinkClick(Sender : TObject);
	 procedure btn_colore_stdClick(Sender : TObject);
	 procedure btn_helpClick(Sender : TObject);
	 procedure cbx_attiva_GAPPClick(Sender : TObject);
	 procedure rb_PL_externalClick(Sender : TObject);
	 procedure btn_open_last_saved_byClick(Sender : TObject);
	 procedure cbx_export_allowedClick(Sender : TObject);
	 procedure str_export_siglaChange(Sender : TObject);
	 procedure FormDestroy(Sender : TObject);
	 procedure cbx_dont_printClick(Sender : TObject);
	 procedure cbx_XML_allowedClick(Sender : TObject);
	 procedure lv_exportClick(Sender : TObject);
	 procedure AL_saveExecute(Sender : TObject);
	 procedure cb_size_modalitaChange(Sender : TObject);
	 procedure AAA_notify_modification(Sender : TObject);
	 procedure FormCloseQuery(Sender : TObject;var CanClose : Boolean);
  private
		i_pagina_logica_1B : logical_page_type;
		bo_allows_external : boolean;
		bo_external_original : boolean;
{		str_external_filename_bak,str_descrizione_breve_bak, str_descrizione_estesa_bak : string;
		str_PDF_watermark_bak : string;
		str_page_ID_bak : string;
		bo_message_if_not_printed_bak : boolean;
		str_message_if_printed_BAK : string;
		i_colore_base_BAK, i_colore_alt_BAK : TColor;
		bo_default_print_page_BAK : boolean; }
	private
		lp : cl_logical_page_info;					// LP : Local Page: variabile locale di lavoro
		expint_pages : expint_page_array;		// variabile locale di lavoro
//		exp : cl_expint_page;
		i_written_expint : smallint;
		procedure read_expint(i_profilo : expint_index_type);
		procedure write_expint(i_profilo : expint_index_type);
		procedure enable_ctrls_expint;
	private
		bo_something_modified : boolean;
		bo_open_on_exportazione : boolean;
		i_profilo : expint_index_type;
		bo_last_hidden : boolean;
		pt_bo_modified : boolean_punt;
		procedure set_external_section(bo_external : boolean);
		procedure call_help;
		procedure enable_ctrls(bo_forza : boolean = FALSE);
		function read : boolean;
		procedure write;
		procedure save;
		constructor xcreate(father : TForm;bo_allows_external : boolean;bo_open_on_exportazione : boolean;i_profilo : expint_index_type;var bo_modified : boolean);
  end;

implementation

uses FXStrings, FStrings, PDF, FSystem, FProcs, FCtrls, FCtrls_RX, FMessage, FBrowse, FFile,
	galateo_debug, pages, objects, proc, functions;

{$R *.DFM}

function pagina_logica_edit_proc(father : TForm;bo_allows_external : boolean;bo_open_on_exportazione : boolean = FALSE;i_profilo : expint_index_type = 0) : boolean;
// rende TRUE se vengono eseguite modifiche
begin
	result := FALSE;
	var dlg := Tdlg_pagina_logica.xCreate(father,bo_allows_external, bo_open_on_exportazione, i_profilo, result);
//	{$ifndef DEBUG} if bo_open_page_exportazione then dlg.pc.Activepage := dlg.page_export; {$endif}
	dlg.ShowModal;dlg.Free;
	setup_pagina_logica(get_pagina_logica_attiva_1B)
end;

constructor Tdlg_pagina_logica.xcreate(father : TForm;bo_allows_external : boolean;bo_open_on_exportazione : boolean;i_profilo : expint_index_type;
	var bo_modified : boolean);
begin
	self.bo_allows_external := bo_allows_external;
	pt_bo_modified := @bo_modified;

	self.bo_open_on_exportazione := bo_open_on_exportazione;
	self.i_profilo := i_profilo;
	i_pagina_logica_1B := get_pagina_logica_attiva_1B;
	lp := cl_logical_page_info.create(i_pagina_logica_1B);
	lp.assign(get_logical_page_1B(i_pagina_logica_1B));
	// genero una copia dei dati oggetto di editing (per quanto riguarda l'export integrale)
	setLength(expint_pages, expint_profiles_count);
	for var i : byte := 0 to expint_profiles_count-1 do begin
		expint_pages[i] := cl_expint_page.ZB_create(i_pagina_logica_1B - 1);
		expint_pages[i].assign(get_expint_page_ZB(i, i_pagina_logica_1B - 1))
	end;

	inherited create(father)
end;

procedure Tdlg_pagina_logica.FormCreate(Sender : TObject);
begin
	rb_PL_external.Enabled := bo_allows_external;
	bo_external_original := lp.bo_external;

	pc.Activepage := pc.pages[0];
	str_ID_pagina.MaxLength := MAX_LENGTH_ID_PAGINA_LOGICA;
	page_expint.TabVisible := FALSE;
	page_XML.TabVisible := FALSE;

	load_export_profiles_proc(lv_export, i_profilo);

	cb_size_modalita.Items.Clear;
	for var i : byte := 0 to byte(high(printer_size_constraints_type)) do cb_size_modalita.Items.Add(PRINTER_SIZE_CONSTRINTS_DESCRIZIONE[printer_size_constraints_type(i)]);

	str_struttura_XML.Color := XML_COLOR;
	panel_expint.Color := EXPINT_COLOR;

	for var i_lp : logical_page_type := 1 to i_pagina_logica_1B do begin
		for var i : obj_index_type := 1 to i_objs(i_lp) do begin
			var x : objs_type := xobjs(i, i_lp);
			if NOT (x.ca.tipo_oggetto in GAPP_OBJS) then continue;
			var str_name := x.get_name;
			// esercizio, operatore, tipo progressivo: prendo gli oggetti della MAIN_SECTION di tutte le pagine logiche (fino all'attuale)
			if (x.ca.i_section_1B = MAIN_SECTION) then begin
				cb_GAPP_esercizio.Items.Add(str_name);
				cb_GAPP_operatore.Items.Add(str_name);
				cb_GAPP_str_tipo_progressivo.Items.Add(str_name);
				cb_GAPP_dt_riferimento.Items.Add(str_name)
			end;

			if (i_lp = i_pagina_logica_1B) then begin
				// record: sulla sezione DETTAGLIO della pagina logica corrente
//				if (x.get_section = MAIN_SECTION+1) then
					cb_GAPP_str_record.Items.Add(str_name)
			end
		end
	end;

	txt_versione_external_file.Visible := lp.bo_external;
	txt_versione_external_file.Caption := 'versione file esterno: ' + version_of(lp.wo_external_original_version) +
		' [' + ifs(lp.wo_external_original_version = GALATEO_VERSION, 'up to date', 'attuale: ' + version_of(GALATEO_VERSION)) + ']';

	write;
	if bo_open_on_exportazione then pc.Activepage := page_exportazione;

	bo_something_modified := FALSE;
	enable_ctrls(TRUE);
	{$ifdef DEBUG} check_components(self) {$endif DEBUG}
end;

procedure Tdlg_pagina_logica.FormDestroy(Sender : TObject);
begin
	if (lp <> NIL) then begin lp.free;lp := NIL end;
	for var i : expint_index_type := 0 to high(expint_pages) do expint_pages[i].free;
	expint_pages := NIL
end;

procedure Tdlg_pagina_logica.write;
begin
	panel_colore_base.Color := lp.i_colore_base;
	panel_colore_alt.Color := lp.i_colore_alt;
	cbx_blink.Checked := (lp.i_colore_base <> lp.i_colore_alt);
	cbx_default_dont_print_page.Checked := NOT lp.bo_default_print_page;

	set_external_section(lp.bo_external);
	rb_PL_external.ItemIndex := byte(lp.bo_external);
	str_section_filename.Text := lp.str_external_filename;
	str_ID_pagina.Text := lp.str_page_ID;
	cbx_message_if_not_printed.Checked := lp.bo_message_if_not_printed;
	self.str_message_if_printed.Text := lp.str_message_if_printed;
	self.str_PDF_watermark.Text := lp.str_PDF_watermark;
	self.str_descrizione_breve.Text := lp.str_descrizione_breve;
	self.str_descrizione_estesa.Text := lp.str_descrizione_estesa;
	str_last_saved_by.Text := lp.str_last_saved_by_main_report;

	page_GAPP.Highlighted := lp.bo_attiva_GAPP;
	cbx_attiva_GAPP.Checked := lp.bo_attiva_GAPP;
	cb_select(cb_GAPP_str_tipo_progressivo, lp.str_GAPP_obj_tipo_progressivo);
	cb_select(cb_GAPP_esercizio, lp.str_GAPP_obj_esercizio);
	cb_select(cb_GAPP_str_record, lp.str_GAPP_obj_record);
	cb_select(cb_GAPP_dt_riferimento, lp.str_GAPP_obj_dt_riferimento);
	cb_select(cb_GAPP_operatore, lp.str_GAPP_obj_operatore);

	cb_size_modalita.ItemIndex := byte(lp.printer_size_constraints_mode);
	i_min_page_height.set_Asinteger(lp.printer_size_constraints_phisical_values.i_min_height_mm);
	i_min_page_width.set_Asinteger(lp.printer_size_constraints_phisical_values.i_min_width_mm);
	i_max_page_height.set_Asinteger(lp.printer_size_constraints_phisical_values.i_max_height_mm);
	i_max_page_width.set_Asinteger(lp.printer_size_constraints_phisical_values.i_max_width_mm);

	cbx_dont_print.Checked := lp.bo_dont_print_phisical;
	str_condizione.Text := lp.str_condizione_esecuzione;
	cbx_exclude_debug.Checked := lp.bo_exclude_debug;

//	lb_expint_elenco.ItemIndex := max(globale.i_default_expint_profile, 0);
//	lb_expint_elenco.ItemIndex := i_profilo;
	write_expint(lv_export.ItemIndex)
end;

function Tdlg_pagina_logica.read : boolean;
begin
	result := FALSE;
	with lp do begin
		str_external_filename := str_section_filename.Text;
		str_descrizione_breve := self.str_descrizione_breve.Text;
		str_descrizione_estesa := self.str_descrizione_estesa.Text;
		str_PDF_watermark := self.str_PDF_watermark.Text;
		str_page_ID := togliblanks(str_ID_pagina.Text);
		bo_message_if_not_printed := cbx_message_if_not_printed.Checked;
		str_message_if_printed := self.str_message_if_printed.Text;
		if bo_external AND (str_external_filename = '') then begin
			MessageBBox(handle, 'Specifica il nome del file da cui caricare la sezione', MBOX_CAPTION);
			exit
		end;

		i_colore_base := panel_colore_base.Color;
		if cbx_blink.Checked then i_colore_alt := panel_colore_alt.Color else i_colore_alt := i_colore_base;
		bo_default_print_page := NOT cbx_default_dont_print_page.Checked;

		if (str_external_filename <> '') then begin
			str_external_filename := set_extension(str_external_filename,EXTERNAL_LP_EXT);
			if bo_external AND NOT FileExists(str_external_filename) then begin
				MessageBBox(handle, 'Il file <' + str_external_filename + '> deve esistere !!!', MBOX_CAPTION);
				exit
			end;
			if bo_external AND NOT bo_external_original then
				MessageBBox(handle,'A partire dal prossimo caricamento di questo report, la ' +
					'pagina logica corrente sarà caricata direttamente dal file <' + str_external_filename + '>', MBOX_CAPTION)
		end;

		bo_attiva_GAPP := cbx_attiva_GAPP.Checked;
		str_GAPP_obj_tipo_progressivo := cb_GAPP_str_tipo_progressivo.Text;
		str_GAPP_obj_esercizio := cb_GAPP_esercizio.Text;
		str_GAPP_obj_record := cb_GAPP_str_record.Text;
		str_GAPP_obj_dt_riferimento := cb_GAPP_dt_riferimento.Text;
		str_GAPP_obj_operatore := cb_GAPP_operatore.Text;

		lp.printer_size_constraints_mode := printer_size_constraints_type(cb_size_modalita.ItemIndex);
		lp.printer_size_constraints_phisical_values.i_min_height_mm := i_min_page_height.get_Asinteger(FALSE);
		lp.printer_size_constraints_phisical_values.i_min_width_mm := i_min_page_width.get_Asinteger(FALSE);
		lp.printer_size_constraints_phisical_values.i_max_height_mm := i_max_page_height.get_Asinteger(FALSE);
		lp.printer_size_constraints_phisical_values.i_max_width_mm := i_max_page_width.get_Asinteger(FALSE);

		if NOT check_printer_size_constraints(self, lp.printer_size_constraints_phisical_values) then exit;

		lp.bo_dont_print_phisical := cbx_dont_print.Checked;
		lp.str_condizione_esecuzione := str_condizione.Text;
		lp.bo_exclude_debug := cbx_exclude_debug.Checked;
		if NOT check_condizione_booleana(handle, lp.str_condizione_esecuzione, 'condizione di attivazione pagina') then exit;

		read_expint(i_written_expint);
		for var i : expint_index_type := 0 to expint_profiles_count-1 do get_expint_page_ZB(i, i_pagina_logica_1B - 1).assign(expint_pages[i])
	end;

	result := TRUE
end;

procedure Tdlg_pagina_logica.btn_browseClick(Sender : TObject);
begin
	var dlg : TOpenDialog := TOpenDialog.create(self);
	try
		dlg.defaultext := EXTERNAL_LP_EXT;dlg.filter := EXTERNAL_LP_FILTER;
		if lp.bo_external then dlg.options := [ofNoChangeDir] else dlg.options := [ofNoChangeDir,ofFileMustExist];
		dlg.filename := str_section_filename.Text;
		if dlg.execute then begin AAA_notify_modification(NIL);str_section_filename.Text := dlg.Filename end
	finally
		dlg.free
	end
end;

procedure Tdlg_pagina_logica.rb_PL_externalClick(Sender : TObject);
begin
	if (rb_PL_external.ItemIndex = 1) AND (length(globale.expint_profiles) > 1) then begin
		MessageBBox(handle, 'I reports che possiedono profili multipli di exportazione integrale NON possono caricare pagine da files esterni', MBOX_CAPTION);
		rb_PL_external.ItemIndex := 0;
		exit
	end;
	set_external_section(rb_PL_external.Itemindex = 1)
end;

procedure Tdlg_pagina_logica.set_external_section(bo_external : boolean);
begin
//	get_logical_page_1B(i_pagina_logica_1B].bo_external := bo_external;
	lp.bo_external := bo_external;
	enable_FC(txt_descrizione, NOT bo_external);
	if bo_external then txt_section_filename.Caption := 'Questa pagina logica deve essere LETTA DAL file'
	else txt_section_filename.Caption := 'Questa pagina logica deve essere SALVATA SUL file';
	visible_FC(txt_last_saved_by, bo_external);btn_open_last_saved_by.Visible := bo_external
end;

procedure Tdlg_pagina_logica.save;
begin
//	with globale, lpages_info[i_pagina_logica_1B] do begin
	if NOT read then exit;
	pt_bo_modified^ := TRUE;
	get_logical_page_1B(i_pagina_logica_1B).assign(lp);
	bo_something_modified := FALSE;
	close
end;

procedure Tdlg_pagina_logica.AL_saveExecute(Sender : TObject); begin save end;
procedure Tdlg_pagina_logica.btn_cancelClick(Sender : TObject); begin close end;

procedure Tdlg_pagina_logica.btn_PDF_watermark_browseClick(Sender : TObject);
begin
	var str_filename : string := str_PDF_watermark.Text;
	if browse_for_files_open(self, {caption}'Seleziona watermark', str_filename, PDF_EXT, PDF_FILTER, {str_default_dir}'', {bo_relative_path} FALSE,
		{bo_file_must_exists} FALSE)
	then begin
		str_PDF_watermark.Text := str_filename;
		AAA_notify_modification(NIL)
	end
end;

procedure Tdlg_pagina_logica.btn_PDF_watermark_openClick(Sender : TObject);
begin
	execute_data_file(handle, TRUE, str_PDF_watermark.Text);
	AAA_notify_modification(NIL)
end;

procedure Tdlg_pagina_logica.txt_colore_fondoClick(Sender : TObject);
begin
	var i_colore : TColor := panel_colore_base.Color;
	if select_colore(self, i_colore) then panel_colore_base.Color := i_colore;
	enable_ctrls
end;

procedure Tdlg_pagina_logica.txt_colore_altClick(Sender : TObject);
begin
	var i_colore : TColor := panel_colore_alt.Color;
	if select_colore(self,i_colore) then panel_colore_alt.Color := i_colore
end;

procedure Tdlg_pagina_logica.cbx_blinkClick(Sender : TObject);
begin
	if cbx_blink.Checked AND (panel_colore_base.Color = panel_colore_alt.Color)
		then panel_colore_alt.Color := clYellow;
	enable_ctrls
end;

procedure Tdlg_pagina_logica.enable_ctrls(bo_forza : boolean = FALSE);
begin
	if bo_forza OR (bo_last_hidden <> cbx_dont_print.Checked) then begin
		make_all_children_enabled(pc, NOT cbx_dont_print.Checked);
		if cbx_dont_print.Checked then begin
			make_all_fathers_enabled(cbx_dont_print);
			enable_FC(txt_descrizione, TRUE)
		end;
		bo_last_hidden := cbx_dont_print.Checked
	end;

	btn_colore_std.Visible := (panel_colore_base.Color <> COLORE_NORMAL_PAGES);
	txt_colore_alt.Transparent := cbx_blink.Checked;
	txt_colore_alt.Enabled := cbx_blink.Checked;

	var bo := (cb_size_modalita.ItemIndex = byte(PSC_CUSTOM));
	make_all_children_enabled(gbox_printer_size_MIN, bo, TRUE);
	make_all_children_enabled(gbox_printer_size_MAX, bo, TRUE);

//	make_all_children_enabled(page_XML, globale.bo_expint_allowed);

	make_all_children_enabled(page_GAPP, cbx_attiva_GAPP.Checked);
	page_GAPP.Enabled := TRUE;cbx_attiva_GAPP.Enabled := TRUE;
	enable_ctrls_expint
end;

procedure Tdlg_pagina_logica.btn_colore_stdClick(Sender : TObject);
begin
	panel_colore_base.Color := COLORE_NORMAL_PAGES;
	enable_ctrls
end;

procedure Tdlg_pagina_logica.btn_helpClick(Sender : TObject); begin call_help end;
procedure Tdlg_pagina_logica.cbx_attiva_GAPPClick(Sender : TObject); begin AAA_notify_modification(NIL);enable_ctrls end;
procedure Tdlg_pagina_logica.cbx_dont_printClick(Sender : TObject); begin enable_ctrls end;
procedure Tdlg_pagina_logica.cbx_export_allowedClick(Sender : TObject); begin enable_ctrls_expint end;
procedure Tdlg_pagina_logica.str_export_siglaChange(Sender : TObject); begin enable_ctrls_expint end;
procedure Tdlg_pagina_logica.cbx_XML_allowedClick(Sender : TObject); begin enable_ctrls end;
procedure Tdlg_pagina_logica.cb_size_modalitaChange(Sender : TObject); begin enable_ctrls end;

procedure Tdlg_pagina_logica.call_help;
var s : string;	//*
begin
	if (pc.ActivePage = page_GAPP) then s := HELP_GESTIONE_AUTOMATICA_PROGRESSIVI_PAGINA else
	if (pc.ActivePage = page_exportazione) then s := ifs(pc_export.Activepage = page_XML, XML_HELP, EXPORT_INTEGRALE_HELP)
	else s := HELP_PAGINE;
	help_proc(self, s)
end;

procedure Tdlg_pagina_logica.btn_open_last_saved_byClick(Sender : TObject);
begin
	var str_filename := lp.str_last_saved_by_main_report;
	if (str_filename = '') then exit;
	execute_data_file(handle,{bo_debug}FALSE,str_filename)
end;

procedure Tdlg_pagina_logica.read_expint(i_profilo : expint_index_type);
begin
	if (i_profilo = -1) then exit;
	var x : cl_expint_page := expint_pages[i_profilo];

	x.bo_export_allowed := cbx_export_allowed.Checked;
	x.str_sigla := str_export_sigla.Text;
	// exportazione integrale
	x.bo_print_headers := cbx_expint_headers.Checked;
	x.bo_print_pagina_logica := cbx_expint_pagina_logica.Checked;
	x.bo_print_sezione := cbx_expint_sezione.Checked;
	x.bo_print_pagina_fisica := cbx_expint_pagina_fisica.Checked;
	x.bo_print_record_number := cbx_expint_record.Checked;
	x.bo_blankrow_after_headers := cbx_blank_after_headers.Checked;
	// XML
	x.str_XML_struttura := str_struttura_XML.Text
end;

procedure Tdlg_pagina_logica.write_expint(i_profilo : expint_index_type);
begin
	if (i_profilo = -1) then exit;
	i_written_expint := i_profilo;
	var x : cl_expint_page := expint_pages[i_profilo];

	if get_export_target_XML(i_profilo) then pc_export.ActivePage := page_XML else pc_export.ActivePage := page_expint;

	cbx_export_allowed.Checked := x.bo_export_allowed;
	str_export_sigla.Text := x.str_sigla;
	// exportazione integrale
	cbx_expint_headers.Checked := x.bo_print_headers;
	cbx_expint_pagina_logica.Checked := x.bo_print_pagina_logica;
	cbx_expint_sezione.Checked := x.bo_print_sezione;
	cbx_expint_pagina_fisica.Checked := x.bo_print_pagina_fisica;
	cbx_expint_record.Checked := x.bo_print_record_number;
	cbx_blank_after_headers.Checked := x.bo_blankrow_after_headers;
	// XML
	str_struttura_XML.Text := x.str_XML_struttura;
	enable_ctrls_expint
end;

procedure Tdlg_pagina_logica.enable_ctrls_expint;
begin
	var i_profilo : expint_index_type := lv_export.ItemIndex;
	if (i_profilo = -1) then exit;
//	xp := get_logical_page_1B(i_pagina];
//	x := expint_pages[i_profilo];

//	bo_can_export_page := globale.bo_expint_allowed AND NOT sections(1, i_pagina_logica_1B).bo_dont_print_section;	// in questo contesto I_PAGE è 1-based
	var bo_can_export_page := globale.bo_export_allowed AND NOT get_logical_page_1B(i_pagina_logica_1B).bo_dont_print_phisical;
	make_all_children_enabled(panel_export_edit, bo_can_export_page AND cbx_export_allowed.Checked);
	if NOT panel_export_edit.Enabled then make_all_fathers_enabled(cbx_export_allowed);
	cbx_export_allowed.Enabled := bo_can_export_page;
	enable_FC(txt_export_sigla, bo_can_export_page AND cbx_export_allowed.Checked AND cbx_expint_pagina_logica.Checked)
end;

procedure Tdlg_pagina_logica.lv_exportClick(Sender : TObject);
begin
	if (i_written_expint = lv_export.Itemindex) then exit;
	if (i_written_expint <> -1) then read_expint(i_written_expint);
	write_expint(lv_export.ItemIndex)
end;

procedure Tdlg_pagina_logica.AAA_notify_modification(Sender : TObject); begin bo_something_modified := TRUE end;

procedure Tdlg_pagina_logica.FormCloseQuery(Sender: TObject;var CanClose: Boolean);
begin
	canclose := NOT bo_something_modified OR (MessageBBox(handle, 'Vuoi chiudere SENZA salvare le modifiche?', MBOX_CAPTION, MB_QUESTION OR MB_DEFBUTTON2) = IDYES)
end;

initialization
	galateo_initialization_debug('pagina_logica_edit')
finalization
	galateo_finalization_debug('pagina_logica_edit')
end.
