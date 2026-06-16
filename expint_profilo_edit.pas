unit expint_profilo_edit;

{$I defines}
{$ifdef DLL} *** {$endif}

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls, Buttons, ActnList, ComCtrls, Actions,
  Federico, FBitBtn, Fcommons, validate,
  Gdich, Gun, expint_base;

function expint_profilo_edit_proc(father : TForm;var x : cl_expint_profilo) : boolean;

type
	expint_page_type = object
		panel : TFPanel;
		txt_label, txt_sigla_pagina : TMyLabel;
		cbx_abilita, cbx_print_pagina_fisica, cbx_print_pagina_logica, cbx_print_headers, cbx_row_after_headers,
			cbx_print_sezione, cbx_print_record : TFCheckBox;
		str_sigla: TFEdit;
	end;
	expint_page_punt = ^expint_page_type;
  Tdlg_expint_profilo = class(TForm)
	 panel_base: TFPanel;
	 panel_buttons: TFPanel;
	 btn_ok: TFBitBtn;
	 btn_cancel: TFBitBtn;
	 AL: TActionList;
	 AL_save: TAction;
	 AL_cancel: TAction;
	 pc: TFPageControl;
	 page_base: TTabSheet;
	 page_msgs: TTabSheet;
	 txt_expint_msg_before: TLabel;
	 str_expint_msg_before: TFMemo;
	 txt_expint_msg_after: TLabel;
	 str_expint_msg_after: TFMemo;
	 rb_expint_target: TRadioGroup;
	 txt_max_expint_lines: TMyLabel;
	 lo_max_expint_lines: TFEdit;
	 txt_expint_comando_specifico: TLabel;
	 txt_expint_file_azione: TLabel;
	 str_expint_comando_specifico: TFEdit;
	 btn_browse_expint_comando_specifico: TFBitBtn;
	 cb_expint_file_azione: TFCombo;
	 panel_top: TFPanel;
	 txt_codice: TMyLabel;
	 txt_descrizione: TMyLabel;
	 str_codice: TFEdit;
	 str_descrizione: TFEdit;
	 cbx_hidden: TFCheckBox;
	 page_pages: TTabSheet;
	 panel_note: TFPanel;
	 txt_note: TMyLabel;
	 str_note: TFMemo;
	 sb_pages: TScrollBox;
	 panel_00: TFPanel;
	 txt_sigla_00: TMyLabel;
	 txt_label_page_00: TMyLabel;
    cbx_abilita: TFCheckBox;
	 cbx_expint_pagina_fisica: TFCheckBox;
	 cbx_expint_pagina_logica: TFCheckBox;
	 cbx_expint_sezione: TFCheckBox;
	 cbx_expint_record: TFCheckBox;
	 str_sigla_export: TFEdit;
	 cbx_expint_headers: TFCheckBox;
	 cbx_blank_after_headers: TFCheckBox;
	 rb_expint_file_writemode: TRadioGroup;
	 cbx_select_sezioni: TFCheckBox;
	 rb_target_mode: TRadioGroup;
	 page_XML: TTabSheet;
	 btn_help: TFBitBtn;
    panel_XML_header: TFPanel;
    panel_XML_body: TFPanel;
    txt_struttura_XML: TMyLabel;
    str_struttura_XML: TFMemo;
    MySplitter1: TFSplitter;
	 txt_XML_header: TMyLabel;
    str_XML_header: TFMemo;
    gbox_trattamento_testo: TFGroupBox;
    txt_expint_separatore: TMyLabel;
    cb_expint_separatore: TFCombo;
    cbx_UTF8: TFCheckBox;
    cbx_elimina_speciali: TFCheckBox;
	 procedure FormCreate(Sender : TObject);
	 procedure FormCloseQuery(Sender : TObject;var CanClose : Boolean);
	 procedure FormDestroy(Sender : TObject);
	 procedure rb_expint_targetClick(Sender : TObject);
	 procedure btn_browse_expint_comando_specificoClick(Sender : TObject);
	 procedure cb_expint_file_azioneClick(Sender : TObject);
	 procedure AL_saveExecute(Sender : TObject);
	 procedure AL_cancelExecute(Sender : TObject);
	 procedure AAA_notify_modification(Sender : TObject);
	 procedure cbx_click_proc(Sender : TObject);
    procedure btn_helpClick(Sender : TObject);
    procedure pcChange(Sender : TObject);
  private
		pt_bo_result : boolean_punt;
		bo_something_modified : boolean;
		err_msg : cl_validation;
		data, external_data : cl_expint_profilo;
		pages : array of expint_page_type;				// 0-based !!!
		constructor xcreate(father : TForm;var x : cl_expint_profilo;var bo_result : boolean);
		procedure enable_ctrls;
		function read : boolean;
		procedure write;
		function validate(data : cl_expint_profilo) : boolean;
		procedure create_page(i_page_ZB : logical_page_type);
		procedure enable_page(i_page_ZB : logical_page_type);
		procedure read_page(i_page_ZB : logical_page_type);
		procedure write_page(i_page_ZB : logical_page_type);
  end;

implementation

{$R *.dfm}

uses FAssert, FXStrings, FStrings, FMessage, FCtrls, FCtrls_RX, FBrowse, FProcs, proc,
	galateo_debug, pages;

const
	MBOX_CAPTION = 'Profilo di exportazione';
	PAGE_COLORS : array[boolean] of TColor = ($00FFFFD5, $00EEDDFF);
	DISABLED_PAGE_COLOR = clGray;

	EXPINT_MODE = 0;
	XML_MODE = 1;

function expint_profilo_edit_proc(father : TForm;var x : cl_expint_profilo) : boolean;
begin
	var dlg : Tdlg_expint_profilo := Tdlg_expint_profilo.xCreate(father, x, result);
	dlg.ShowModal;dlg.Free
end;

constructor Tdlg_expint_profilo.xcreate(father: TForm;var x: cl_expint_profilo;var bo_result: boolean);
begin
	external_data := x;
	data := cl_expint_profilo.create;
	data.assign(x);
	bo_result := FALSE;
	pt_bo_result := @bo_result;
	err_msg := validation_create(MBOX_CAPTION);
	inherited create(father);
	left := father.Left + 40;top := father.Top + 40
end;

procedure Tdlg_expint_profilo.FormCreate(Sender : TObject);
begin
	caption := MBOX_CAPTION;
	cbx_elimina_speciali.Hint := EXPINT_DELETE_SPECIAL_CHARS_HINT;

	cb_expint_separatore.Items.clear;
	for var i : byte := 0 to byte(high(expint_separatore_type)) do cb_expint_separatore.Items.add(EIS_DESCRIZIONE[expint_separatore_type(i)]);

	rb_expint_target.Items.clear;
	for var i : byte := 0 to byte(high(export_integrale_target_type)) do rb_expint_target.Items.Add(EITT_DESCRIZIONE[export_integrale_target_type(i)]);

	cb_expint_file_azione.Items.clear;
	for var i : byte := 0 to byte(high(export_file_action_type)) do
		cb_expint_file_azione.Items.Add(EFAT_DESCR[export_file_action_type(i)]);

	rb_expint_file_writemode.Hint := FWT_HINTS;
	rb_expint_file_writemode.Items.Clear;
	for var i : byte := 0 to byte(high(file_writemode_type)) do rb_expint_file_writemode.Items.Add(FWT_DESCR[file_writemode_type(i)]);

	setLength(pages, get_ultima_pagina_logica);
	for var i : logical_page_type := 0 to get_ultima_pagina_logica-1 do create_page(i);

	write;
	{$ifdef DEBUG} check_components(self); {$endif DEBUG}
	bo_something_modified := FALSE
end;

procedure Tdlg_expint_profilo.FormCloseQuery(Sender: TObject;var CanClose: Boolean);
begin
	canclose := NOT bo_something_modified OR (MessageBBox(handle, 'Vuoi uscire senza salvare le modifiche?', MBOX_CAPTION, MB_QUESTION) = IDYES)
end;

procedure Tdlg_expint_profilo.FormDestroy(Sender : TObject);
begin
	validation_free(err_msg);
	if (data <> NIL) then data.free
end;

function Tdlg_expint_profilo.read : boolean;
begin
	data.bo_XML := (rb_target_mode.ItemIndex = XML_MODE);

	data.str_codice := str_codice.Text;
	data.str_descrizione := str_descrizione.Text;
	data.str_note := str_note.Text;
	data.bo_dont_show := cbx_hidden.Checked;
//	data.i_pos := i_pos.get_Asinteger(TRUE);

	data.str_message_before := str_expint_msg_before.Text;
	data.str_message_after := str_expint_msg_after.Text;
	data.str_comando_specifico_default := str_expint_comando_specifico.Text;
	data.expint_separatore := expint_separatore_type(cb_expint_separatore.Itemindex);
	data.lo_expint_max_lines := lo_max_expint_lines.get_Asinteger(FALSE);
	data.target_default := export_integrale_target_type(rb_expint_target.Itemindex);
	data.EFAT_default_action := export_file_action_type(cb_expint_file_azione.Itemindex);
	data.writemode_default := file_writemode_type(rb_expint_file_writemode.Itemindex);
	data.bo_choose_expint_sections := cbx_select_sezioni.Checked;

	for var i : logical_page_type := 0 to get_ultima_pagina_logica-1 do read_page(i);
	data.str_XML_struttura := togli_ACAPO_init_fine(str_struttura_XML.Text);
	data.str_XML_header := togli_ACAPO_init_fine(str_XML_header.Text);
	data.bo_encode_UTF8 := cbx_UTF8.Checked;
	data.bo_delete_special_chars := cbx_elimina_speciali.Checked;

	result := validate(data)
end;

procedure Tdlg_expint_profilo.write;
begin
//	rb_target_mode.ItemIndex := ifi(data.target = xRTA_EXPORT_INTEGRALE, EXPINT_MODE, XML_MODE);
	rb_target_mode.ItemIndex := ifi(data.bo_XML, XML_MODE, EXPINT_MODE);

	for var i : logical_page_type := 0 to get_ultima_pagina_logica - 1 do write_page(i);

	str_codice.Text := data.str_codice;
	str_descrizione.Text := data.str_descrizione;
	str_note.Text := data.str_note;
	cbx_hidden.Checked := data.bo_dont_show;
//	i_pos.set_Asinteger(data.i_pos);

	str_expint_msg_before.Text := data.str_message_before;
	str_expint_msg_after.Text := data.str_message_after;
	str_expint_comando_specifico.Text := data.str_comando_specifico_default;
	cb_expint_separatore.Itemindex := byte(data.expint_separatore);
	lo_max_expint_lines.set_Asinteger(data.lo_expint_max_lines);
	rb_expint_target.Itemindex := byte(data.target_default);
	cb_expint_file_azione.Itemindex := byte(data.EFAT_default_action);
	rb_expint_file_writemode.Itemindex := byte(data.writemode_default);
	cbx_select_sezioni.Checked := data.bo_choose_expint_sections;

	str_struttura_XML.Text := data.str_XML_struttura;
	str_XML_header.Text := data.str_XML_header;
	cbx_UTF8.Checked := data.bo_encode_UTF8;
	cbx_elimina_speciali.Checked := data.bo_delete_special_chars
end;

function Tdlg_expint_profilo.validate(data : cl_expint_profilo) : boolean;
begin
	if (data.str_codice = '') then validation_add(err_msg, 'Codice non indicato', TRUE);
	if (data.str_descrizione = '') then validation_add(err_msg, 'Descrizione non indicata', FALSE);
	result := validation_verify(err_msg, self, MBOX_CAPTION)
end;

procedure Tdlg_expint_profilo.AAA_notify_modification(Sender : TObject); begin bo_something_modified := TRUE end;
procedure Tdlg_expint_profilo.rb_expint_targetClick(Sender : TObject); begin AAA_notify_modification(NIL);enable_ctrls end;
procedure Tdlg_expint_profilo.cb_expint_file_azioneClick(Sender : TObject); begin enable_ctrls end;
procedure Tdlg_expint_profilo.AL_cancelExecute(Sender : TObject); begin close end;

procedure Tdlg_expint_profilo.btn_browse_expint_comando_specificoClick(Sender : TObject);
begin
	var s : string := str_expint_comando_specifico.Text;
	if browse_for_files_open(self, {caption}'Selezione batch file', s, COMMAND_FILES_DEFAULT_EXT, COMMAND_FILES_FILTER, {str_default_dir}'',
		{bo_relative_path}FALSE, {bo_file_must_exists}FALSE)
	then begin
		AAA_notify_modification(NIL);
		str_expint_comando_specifico.Text := s
	end
end;

procedure Tdlg_expint_profilo.enable_ctrls;
begin
	enable_FC(txt_expint_file_azione, export_integrale_target_type(rb_expint_target.Itemindex) = EITT_FILE);
	rb_expint_file_writemode.Enabled := (export_integrale_target_type(rb_expint_target.Itemindex) in EITT_FILE_TYPES);

	var bo_export_integrale := (rb_target_mode.ItemIndex = EXPINT_MODE);
	enable_FC(txt_max_expint_lines, bo_export_integrale);
	enable_FC(txt_expint_separatore, bo_export_integrale);
	cbx_select_sezioni.Enabled := bo_export_integrale;
	cbx_elimina_speciali.Enabled := bo_export_integrale;

{	enable_FC(txt_expint_comando_specifico,
		txt_expint_file_azione.Enabled AND (export_file_action_type(cb_expint_file_azione.ItemIndex) = EFAT_COMANDO_SPECIFICO)); }
	btn_browse_expint_comando_specifico.Enabled := txt_expint_comando_specifico.Enabled;

	page_XML.TabVisible := NOT bo_export_integrale;

	for var i : logical_page_type := 0 to get_ultima_pagina_logica-1 do enable_page(i)
end;

procedure Tdlg_expint_profilo.AL_saveExecute(Sender : TObject);
begin
	if bo_something_modified then begin
		if NOT read then exit;
		external_data.assign(data);
		pt_bo_result^ := TRUE;
		bo_something_modified := FALSE	// già salvato!
	end;
	close
end;

procedure Tdlg_expint_profilo.create_page(i_page_ZB : logical_page_type);

	procedure create_cbx(var cbx : TFCheckBox;parent : TWinControl;source : TFCheckBox);
	begin
		cbx := TFCheckBox.createx(parent, self);
		with source do cbx.SetBounds(left, top, width, height);
		cbx.Caption := source.Caption;
		cbx.AAA_notify_modification := AAA_notify_modification;
		cbx.OnClick := cbx_click_proc;
		cbx.Tag := i_page_ZB
	end;

begin
	var p : expint_page_punt := @pages[i_page_ZB];
	if (i_page_ZB = 0) then begin
		p.panel := panel_00;
		p.txt_label := txt_label_page_00;
		p.txt_sigla_pagina := txt_sigla_00;
		p.cbx_abilita := cbx_abilita;
		p.cbx_print_pagina_fisica := cbx_expint_pagina_fisica;
		p.cbx_print_pagina_logica := cbx_expint_pagina_logica;
		p.cbx_print_headers := cbx_expint_headers;
		p.cbx_row_after_headers := cbx_blank_after_headers;
		p.cbx_print_sezione := cbx_expint_sezione;
		p.cbx_print_record := cbx_expint_record;
		p.str_sigla := str_sigla_export
	end
	else begin
		p.panel := TFPanel.createx(sb_pages, self);
		p.panel.Caption := '';
		p.panel.Align := alBottom;p.panel.Align := alTop;
		p.panel.Height := panel_00.Height;

		p.txt_label := TMyLabel.createx(p.panel, self);
		p.txt_label.Align := alTop;p.txt_label.Alignment := taCenter;
		p.txt_label.Color := txt_label_page_00.Color;

		create_cbx(p.cbx_abilita, p.panel, cbx_abilita);

		p.str_sigla := TFEdit.createx(p.panel, self);
		with str_sigla_export do p.str_sigla.SetBounds(left, top, width, height);
		p.str_sigla.AAA_notify_modification := AAA_notify_modification;
		p.str_sigla.Tag := i_page_ZB;

		p.txt_sigla_pagina := TMyLabel.createx(p.panel, self);
		with txt_sigla_00 do p.txt_sigla_pagina.SetBounds(left, top, width, height);
		p.txt_sigla_pagina.Caption := txt_sigla_00.Caption;
		p.txt_sigla_pagina.FocusControl := p.str_sigla;

		create_cbx(p.cbx_print_pagina_fisica, p.panel, cbx_expint_pagina_fisica);
		create_cbx(p.cbx_print_record, p.panel, cbx_expint_record);
		create_cbx(p.cbx_print_pagina_logica, p.panel, cbx_expint_pagina_logica);
		create_cbx(p.cbx_print_sezione, p.panel, cbx_expint_sezione);
		create_cbx(p.cbx_print_headers, p.panel, cbx_expint_headers);
		create_cbx(p.cbx_row_after_headers, p.panel, cbx_blank_after_headers)
	end;
//	p.panel.Color := PAGE_COLORS[odd(i_page)]
end;

procedure Tdlg_expint_profilo.write_page(i_page_ZB : logical_page_type);		// i_page is ZERO-based
begin
	var p : expint_page_punt := @pages[i_page_ZB];
	var lp : cl_logical_page_info := get_logical_page_ZB(i_page_ZB);
	p.txt_label.Caption := ifs(lp.str_page_ID, lp.str_page_ID + ' - ') + lp.get_descrizione(TRUE);
	var e : cl_expint_page := data.expint_pages[i_page_ZB];

	p.cbx_abilita.Checked := e.bo_export_allowed;
	p.cbx_print_pagina_fisica.Checked := e.bo_print_pagina_fisica;
	p.cbx_print_pagina_logica.Checked := e.bo_print_pagina_logica;
	p.cbx_print_headers.Checked := e.bo_print_headers;
	p.cbx_row_after_headers.Checked := e.bo_blankrow_after_headers;
	p.cbx_print_sezione.Checked := e.bo_print_sezione;
	p.cbx_print_record.Checked := e.bo_print_record_number;
	p.str_sigla.Text := e.str_sigla
end;

procedure Tdlg_expint_profilo.read_page(i_page_ZB : logical_page_type);
begin
	var p : expint_page_punt := @pages[i_page_ZB];
	var e : cl_expint_page := data.expint_pages[i_page_ZB];

	e.bo_export_allowed := p.cbx_abilita.Checked;
	e.bo_print_pagina_fisica := p.cbx_print_pagina_fisica.Checked;
	e.bo_print_pagina_logica := p.cbx_print_pagina_logica.Checked;
	e.bo_print_headers := p.cbx_print_headers.Checked;
	e.bo_blankrow_after_headers := p.cbx_row_after_headers.Checked;
	e.bo_print_sezione := p.cbx_print_sezione.Checked;
	e.bo_print_record_number := p.cbx_print_record.Checked;
	e.str_sigla := p.str_sigla.Text
end;

procedure Tdlg_expint_profilo.enable_page(i_page_ZB : logical_page_type);	// 0-based
begin
	var p : expint_page_punt := @pages[i_page_ZB];
	var bo_can_export_page := globale.bo_export_allowed AND NOT get_logical_page_ZB(i_page_ZB).bo_dont_print_phisical;
	make_all_children_enabled(p.panel, bo_can_export_page AND p.cbx_abilita.Checked);
	p.panel.Color := ifi(p.panel.Enabled, PAGE_COLORS[odd(i_page_ZB)], DISABLED_PAGE_COLOR);
	p.panel.Enabled := TRUE;
	p.cbx_abilita.Enabled := bo_can_export_page;
	enable_FC(p.txt_sigla_pagina, bo_can_export_page AND p.cbx_abilita.Checked AND p.cbx_print_pagina_logica.Checked);

	var bo := cbx_expint_pagina_fisica.Enabled AND (rb_target_mode.ItemIndex = EXPINT_MODE);
	cbx_expint_pagina_fisica.Enabled := bo;
	cbx_expint_pagina_logica.Enabled := bo;
	cbx_expint_headers.Enabled := bo;
	cbx_blank_after_headers.Enabled := bo;
	cbx_expint_sezione.Enabled := bo;
	cbx_expint_record.Enabled := bo
end;

procedure Tdlg_expint_profilo.cbx_click_proc(Sender : TObject);
begin
	bo_something_modified := TRUE;
	enable_page((sender as TFCheckBox).tag)
end;

procedure Tdlg_expint_profilo.btn_helpClick(Sender : TObject);
var s : string;	//*
begin
	if (pc.ActivePage = page_XML) then s := XML_HELP;
	if (s <> '') then help_proc(self, s)
end;

procedure Tdlg_expint_profilo.pcChange(Sender : TObject);
begin
	btn_help.Enabled := (pc.ActivePage = page_XML)
end;

initialization
	galateo_initialization_debug('expint_profilo_edit')
finalization
	galateo_finalization_debug('expint_profilo_edit')
end.
