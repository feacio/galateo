unit label_edit;	//*

{$ifdef DLL} *** {$endif}

{$I defines}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, ComCtrls, Buttons, Forms, Dialogs, StdCtrls, ExtCtrls, TabNotBk, Math,
	UITypes, JvExStdCtrls, JvCombobox, JvColorCombo,
	federico, FBitBtn, FRegistry, Flabel, FListBox,
	Gdich, labels, expint_base;

procedure edit_label_proc(father : TForm;lab : cl_label;i_obj : obj_index_type;bo_modal : boolean = FALSE;bo_open_page_exportazione : boolean = FALSE;i_profilo_export : expint_index_type = 0);

type
  Tlabels = class(TForm)
	 Fontdlg: TFontDialog;
	 pc: TFPageControl;
	 page_oggetto: TTabSheet;
	 page_formato: TTabSheet;
	 page_runtime: TTabSheet;
	 pc_runtime_options: TFPageControl;
	 runtime_base: TTabSheet;
	 page_runtime_avanzate: TTabSheet;
	 rb_RTQ: TRadioGroup;
	 txt_runtime_blank_answer: TLabel;
	 cbx_runtime_answer_in_valori_suggeriti: TCheckBox;
	 cbx_runtime_answer_can_be_blank: TCheckBox;
	 str_runtime_blank_answer: TEdit;
	 cbx_RTQ_select_all_answers: TCheckBox;
	 txt_runtime_ask_if: TLabel;
	 str_runtime_ask_if: TEdit;
	 page_store: TTabSheet;
	 cbx_store_variabile: TFCheckBox;
	 str_nome_variabile_store: TFEdit;
	 cbx_nome_variabile_SQL: TFCheckBox;
	 txt_nome_variabile_store: TMyLabel;
	 txt_stoop: TLabel;
	 cb_stoop: TFCombo;
	 panel_top: TFPanel;
	 txt_nome: TLabel;
	 str_text: TEdit;
	 btn_font: TButton;
	 panel_bottom: TFPanel;
	 txt_object: TLabel;
	 btn_legami: TButton;
	 btn_ok: TFBitBtn;
	 btn_cancel: TFBitBtn;
    btn_help: TFBitBtn;
    page_remarks: TTabSheet;
	 str_remarks: TFMemo;
    panel_color: TPanel;
	 txt_colore_parametro: TLabel;
	 txt_runtime_hint: TLabel;
	 btn_text_color: TButton;
    btn_back_color: TButton;
    cbx_SQL_load_runtime_values: TCheckBox;
    panel_runtime_answers: TPanel;
    panel_runtime_answers_00: TPanel;
	 txt_runtime_answers: TLabel;
    str_runtime_answers: TMemo;
    panel_runtime_answers_01: TPanel;
	 txt_runtime_values: TLabel;
    str_runtime_values: TMemo;
    txt_runtime_enable_if: TLabel;
    str_runtime_enable_if: TEdit;
    txt_runtime_max_lines: TMyLabel;
    i_runtime_max_lines: TFEdit;
    txt_runtime_max_length: TMyLabel;
    i_runtime_max_length: TFEdit;
    btn_default_color: TButton;
    panel_runtime_question: TFPanel;
	 txt_runtime_question: TLabel;
    txt_runtime_caption: TLabel;
	 str_runtime_question: TMemo;
	 str_runtime_caption: TFEdit;
    txt_runtime_parm_gbox: TMyLabel;
	 cb_runtime_parm_gbox: TFCombo;
	 pc_formato: TMyPageControl;
    page_formattazione: TTabSheet;
	 page_formato_numero: TTabSheet;
    txt_formato_multiselect: TMyLabel;
	 cb_formato_multiselect: TFCombo;
    page_object_type: TMyPageControl;
    page_text: TTabSheet;
	 page_formula: TTabSheet;
	 page_variabile: TTabSheet;
    panel_formula: TFPanel;
    txt_funzioni: TLabel;
	 cb_available_functions: TFCombo;
    btn_help_funzioni: TFBitBtn;
    str_formula: TFMemo;
    page_forza_font: TTabSheet;
	 page_runtime_formato: TTabSheet;
    txt_runtime_formato: TLabel;
	 str_runtime_format: TEdit;
    btn_help_mask_format: TFBitBtn;
	 rb_runtime_tipodato: TRadioGroup;
    btn_formato_default: TFBitBtn;
    txt_runtime_path: TLabel;
    str_runtime_path: TEdit;
	 btn_browse_runtime_path: TButton;
    str_runtime_filename_filter: TEdit;
	 txt_runtime_filename_filter: TLabel;
	 memo_DB_colonna: TFMemo;
    page_runtime_script: TTabSheet;
	 panel_runtime_script: TFPanel;
    str_runtime_script: TFMemo;
    btn_runtime_script_insert: TFBitBtn;
	 cbx_SQL_runtime_debug: TCheckBox;
	 txt_runtime_min_length: TMyLabel;
    i_runtime_min_length: TFEdit;
    panel_tipovar: TFPanel;
    txt_tipovar: TLabel;
    cb_tipovar: TFCombo;
	 rb_solo_testo: TRadioButton;
	 rb_numero: TRadioButton;
    panel_text: TFPanel;
	 cbx_runtime: TCheckBox;
    page_dimensione: TTabSheet;
    panel_size_pos: TFPanel;
	 gbox_size: TGroupBox;
    txt_size_cm: TLabel;
    txt_size_chars: TLabel;
	 rb_size_fissa: TRadioButton;
	 rb_size_auto: TRadioButton;
    i_size_cm: TEdit;
    i_size_chars: TEdit;
	 cbx_autoheight: TFCheckBox;
    rb_align: TRadioGroup;
    gbx_posizione: TGroupBox;
	 txt_left: TLabel;
    txt_top: TLabel;
    i_left_cm: TEdit;
    i_top_cm: TEdit;
    cbx_centrato: TCheckBox;
    panel_formattazione: TFPanel;
    panel_numeri: TFPanel;
    txt_formato_numero: TMyLabel;
    cbx_progressivo: TCheckBox;
    cbx_show_segno: TCheckBox;
    cb_nz: TCheckBox;
	 cb_formato_numero: TFCombo;
    gbox_round_base: TGroupBox;
    rb_round: TRadioGroup;
    gbox_stampa_almeno: TGroupBox;
    txt_decimali_fissi: TLabel;
    txt_zeri: TLabel;
    str_decimali_fissi: TEdit;
    str_zeri: TEdit;
    panel_speciale: TFPanel;
    gbox_forza_font: TGroupBox;
	 cbx_font_bold: TFCheckBox;
	 cbx_font_italic: TFCheckBox;
    cbx_font_underlined: TFCheckBox;
	 cbx_font_strikeout: TFCheckBox;
    cbx_switch_fontstyle: TCheckBox;
    page_expint: TTabSheet;
	 lb_expint_elenco: TMyListBox;
    panel_expint: TFPanel;
	 txt_export: TLabel;
	 txt_export_pos: TMyLabel;
    txt_expint_header: TLabel;
    txt_expint_skip_cols_before: TMyLabel;
    txt_expint_acapo: TLabel;
	 txt_expint_multiline: TLabel;
    txt_expint_TAB: TLabel;
    cb_export: TFCombo;
    i_export_pos: TFEdit;
    str_expint_header: TEdit;
    i_expint_skip_cols_before: TFEdit;
    cb_expint_acapo: TFCombo;
    cb_expint_multiline: TFCombo;
    cb_expint_TAB: TFCombo;
    btn_help_export_integrale: TFBitBtn;
	 txt_expint_label: TLabel;
    panel_visual: TFPanel;
	 txt_show: TLabel;
    cb_show: TFCombo;
    txt_print_if: TLabel;
    txt_hints: TLabel;
	 str_print_if: TEdit;
    str_hints: TEdit;
    str_runtime_hint: TMemo;
    page_default: TTabSheet;
    txt_esempio: TLabel;
    str_esempio: TEdit;
    gbox_default: TFGroupBox;
	 txt_runtime_default: TLabel;
	 txt_runtime_default_debug: TLabel;
    str_runtime_default: TMemo;
	 str_runtime_default_debug: TMemo;
    gbox_runtime_default_options: TFGroupBox;
    cbx_parm_runtime_SQL: TCheckBox;
	 cbx_parm_runtime_formula: TCheckBox;
	 gbox_shift_pos: TFGroupBox;
	 txt_formula_Xpos: TLabel;
    str_formula_Xpos: TEdit;
    txt_formula_Xpos_type: TLabel;
    cb_formula_Xpos: TComboBox;
    txt_formula_Ypos: TLabel;
    str_formula_Ypos: TEdit;
    txt_formula_Ypos_type: TLabel;
    cb_formula_Ypos: TComboBox;
    gbox_lingua: TFGroupBox;
    txt_ID_lingua: TLabel;
	 cb_ID_lingua: TFCombo;
    cbx_IDs_lingua_selected_context: TFCheckBox;
	 cbx_IDs_lingua_generic_context: TFCheckBox;
    page_validazione: TTabSheet;
    txt_validazione_formula: TLabel;
    str_validazione_formula: TMemo;
    txt_validazione_message: TLabel;
    rb_validazione: TFRadioGroup;
	 cbx_attiva_validazione: TFCheckBox;
    gbox_error_check_context: TFGroupBox;
    cbx_validazione_always: TFCheckBox;
    cbx_validazione_print: TFCheckBox;
	 cbx_validazione_mail: TFCheckBox;
    cbx_validazione_FTP: TFCheckBox;
    cbx_validazione_expint: TFCheckBox;
    cbx_validazione_XML: TFCheckBox;
    cbx_validazione_elaborazione: TFCheckBox;
    str_validazione_message: TEdit;
    gbox_validazione_blocca: TFGroupBox;
    gbox_validazione_contesto_blocco: TFGroupBox;
    cbx_validazione_blocco_always: TFCheckBox;
	 cbx_validazione_blocco_print: TFCheckBox;
    cbx_validazione_blocco_mail: TFCheckBox;
	 cbx_validazione_blocco_FTP: TFCheckBox;
    cbx_validazione_blocco_expint: TFCheckBox;
    cbx_validazione_blocco_XML: TFCheckBox;
    cbx_validazione_blocco_elaborazione: TFCheckBox;
	 txt_condizione_bloccante_aggiuntiva: TLabel;
	 str_condizione_bloccante_aggiuntiva: TEdit;
    cbx_errore_bloccante: TFCheckBox;
    str_validazione_descrizione_field: TEdit;
    txt_validazione_descrizione_field: TLabel;
    cbx_attiva_traduzione: TFCheckBox;
    txt_comportamento_null: TLabel;
    cb_comportamento_null: TFCombo;
    txt_value_when_null: TLabel;
    cb_value_when_null: TFCombo;
    txt_criterio_ricalcolo: TLabel;
    cb_criterio_ricalcolo: TFCombo;
    panel_valuta: TFPanel;
    txt_valuta: TLabel;
	 gbox_round_valuta: TGroupBox;
	 txt_valuta_message: TLabel;
	 txt_round_valuta: TLabel;
	 txt_round_valuta_min: TLabel;
	 cb_round_valuta: TComboBox;
	 cb_round_valuta_min: TComboBox;
	 cb_valuta: TFCombo;
    gb_valuta: TGroupBox;
    cbx_valuta: TCheckBox;
    str_simbolo_valuta: TEdit;
    rb_posizione_simbolo_valuta: TRadioGroup;
    btn_euro: TButton;
    btn_lire: TButton;
	 cbx_valuta_breve: TCheckBox;
    gbox_rotazione: TGroupBox;
    txt_rotazione: TFLabel;
    i_rotazione: TFEdit;
    i_font_orientation: TFEdit;
	 txt_font_orientation: TLabel;
    cbx_posizione_fissa: TCheckBox;
	 cbx_footer: TCheckBox;
    gbox_formattazione: TGroupBox;
    cbx_riduci_se_necessario: TCheckBox;
    txt_minimum_auto_size: TLabel;
    cb_minimum_auto_size: TComboBox;
	 txt_interlinea: TLabel;
	 cbx_giustificato: TFCheckBox;
	 cbx_multiline: TCheckBox;
	 cbx_insert_if_multiline: TCheckBox;
	 fl_interlinea: TEdit;
	 cbx_suppress_blank: TCheckBox;
	 txt_max_vertical_size: TLabel;
	 fl_max_vertical_size: TEdit;
	 gbox_LCF: TFGroupBox;
	 txt_LCF_condizione: TLabel;
	 txt_LCF_esempio: TLabel;
	 txt_LCF_foreground_color: TLabel;
	 str_LCF_condizione: TEdit;
	 cbx_LCF_bold: TFCheckBox;
	 cbx_LCF_italic: TFCheckBox;
	 cbx_LCF_underline: TFCheckBox;
    cbx_LCF_strikeout: TFCheckBox;
    panel_LCF_background_color: TFPanel;
    cb_LCF_foreground_color: TJvColorComboBox;
    btn_help_LCF: TFBitBtn;
    gbox_formato: TGroupBox;
	 txt_datetime_format: TLabel;
    str_datetime_format: TEdit;
    btn_help_datetime_format: TFBitBtn;
    rb_charcase: TRadioGroup;
    txt_max_rows: TLabel;
    i_max_rows: TEdit;
    cbx_PDF_modificabile: TFCheckBox;
    gbox_sfondo: TGroupBox;
    cbx_trasparente: TFCheckBox;
    txt_sfondo: TMyLabel;
    panel_fondo: TFPanel;
    gbox_round: TGroupBox;
	 txt_round: TLabel;
    str_round: TEdit;
    cb_round: TComboBox;
    panel_header_variabile: TFPanel;
    txt_nome_colonna: TLabel;
    cbx_log_SQL: TCheckBox;
	 cbx_validate_pre_SQL: TFCheckBox;
    gbox_contesto_anticipato: TFGroupBox;
    cbx_check_parms: TFCheckBox;
    cbx_after_runtime_parms: TFCheckBox;
    gbox_contesto_anticipato_blocco: TFGroupBox;
    cbx_check_parms_blocco: TFCheckBox;
    cbx_after_runtime_parms_blocco: TFCheckBox;
	 procedure btn_cancelClick(Sender : TObject);
	 procedure btn_okClick(Sender : TObject);
	 procedure btn_fontClick(Sender : TObject);
	 procedure str_textChange(Sender : TObject);
	 procedure FormDestroy(Sender : TObject);
	 procedure FormCreate(Sender : TObject);
	 procedure rb_sizeClick(Sender : TObject);
	 procedure rb_solo_testoClick(Sender : TObject);
	 procedure rb_numeroClick(Sender : TObject);
	 procedure btn_legamiClick(Sender : TObject);
	 procedure cb_showChange(Sender : TObject);
	 procedure cb_tipovarChange(Sender : TObject);
	 procedure cbx_multilineClick(Sender : TObject);
	 procedure FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
	 procedure cbx_riduci_se_necessarioClick(Sender : TObject);
	 procedure cbx_valutaClick(Sender : TObject);
    procedure btn_euroClick(Sender : TObject);
	 procedure btn_lireClick(Sender : TObject);
	 procedure enable_ctrls_Click(Sender : TObject);
	 procedure cb_valutaChange(Sender : TObject);
	 procedure btn_help_mask_formatClick(Sender : TObject);
	 procedure cbx_store_variabileClick(Sender : TObject);
	 procedure btn_helpClick(Sender : TObject);
	 procedure btn_help_funzioniClick(Sender : TObject);
	 procedure btn_text_colorClick(Sender : TObject);
	 procedure btn_back_colorClick(Sender : TObject);
	 procedure panel_colorClick(Sender : TObject);
	 procedure btn_default_colorClick(Sender : TObject);
	 procedure cb_formato_numeroClick(Sender : TObject);
	 procedure cb_exportChange(Sender : TObject);
	 procedure page_object_typeChange(Sender : TObject);
	 procedure cbx_expint_only_first_lineClick(Sender : TObject);
	 procedure btn_help_export_integraleClick(Sender : TObject);
	 procedure btn_help_datetime_formatClick(Sender : TObject);
	 procedure btn_formato_defaultClick(Sender : TObject);
	 procedure btn_browse_runtime_pathClick(Sender : TObject);
	 procedure rb_runtime_tipodatoClick(Sender : TObject);
	 procedure btn_runtime_script_insertClick(Sender : TObject);
	 procedure i_rotazioneEnter(Sender : TObject);
	 procedure i_rotazioneExit(Sender : TObject);
	 procedure i_rotazioneChange(Sender : TObject);
	 procedure panel_runtime_answersResize(Sender : TObject);
	 procedure AAA_modified(Sender : TObject);
	 procedure FormCloseQuery(Sender : TObject;var CanClose : Boolean);
	 procedure lb_expint_elencoClick(Sender : TObject);
	 procedure cbx_LCF_Click(Sender : TObject);
	 procedure panel_LCF_background_colorClick(Sender : TObject);
	 procedure cb_LCF_foreground_colorChange(Sender : TObject);
	 procedure btn_help_LCFClick(Sender : TObject);
	 procedure cbx_IDs_lingua_selected_contextClick(Sender : TObject);
	 procedure rb_validazioneClick(Sender : TObject);
    procedure cbx_attiva_validazioneClick(Sender : TObject);
	 procedure cbx_validazione_contextClick(Sender : TObject);
    procedure cbx_validazione_blocco_Click(Sender : TObject);
    procedure cbx_errore_bloccanteClick(Sender : TObject);
    procedure str_validazione_descrizione_Change(Sender : TObject);
    procedure str_validazione_descrizione_fieldExit(Sender : TObject);
    procedure FormClose(Sender : TObject;var Action : TCloseAction);
    procedure cbx_attiva_traduzioneClick(Sender : TObject);
    procedure cb_comportamento_nullChange(Sender : TObject);
    procedure fl_max_vertical_sizeExit(Sender : TObject);
    procedure i_max_rowsExit(Sender : TObject);
    procedure panel_fondoClick(Sender : TObject);
	 procedure cb_roundChange(Sender : TObject);
    procedure str_roundChange(Sender : TObject);
	private
		expint_objects : expint_object_array;		// variabile locale di lavoro
		i_written_expint : smallint;
		procedure read_expint(i_profilo : expint_index_type);
		procedure write_expint(i_profilo : expint_index_type);
	private
		ledit, lbak : cl_label;
		bo_something_modified : boolean;
		i_logical_page : logical_page_type;
		i_sezione : section_index_type;
		bo_started : boolean;
		i_obj : obj_index_type;
		bo_rotazione_editing : boolean;
		bo_dont_set_activepage : boolean;		// disattiva l'assegnazione automatica della linguetta all'apertura della finestra
		procedure call_help(str_help : string = '');
		procedure enable_align(bo_able : boolean);
		procedure enable_ctrls;
		procedure enable_ctrls_expint;
		procedure enable_multiline_suppress;
		procedure enable_numerici;
		procedure enable_suppress_blanks;
		procedure enable_riduci_font;
		procedure enable_minimum_size_auto;
		procedure enable_insert_line_if_multiline;
		procedure enable_interlinea;
		function is_numero : boolean;
		procedure resize_runtime_panels;
		procedure set_rotazione(bo_rotazione : boolean);
		procedure expint_click;
		function read : boolean;
		procedure update_LCF_esempio;
		function get_language_context_mode : lingua_context_set;
		procedure write;
		function IO_form_size_and_pos_custom_proc(bo_save : boolean;reg : TFRegistry) : boolean;
		constructor xcreate(father : TForm;lo : cl_label;i_obj : obj_index_type);
	end;

implementation

{$R *.DFM}

uses FCommons, FXStrings, FStrings, FSQLsoft, FMessage, FCtrls, FCtrls_RX, valuta, FBrowse, FTrans, wproc,
	galateo_debug, domanda_multipla, proc, legami, misure, objects, pages, functions, objsx, runtime_gbox_proc;

const
	MBOX_CAPTION = 'Modifica oggetto';
	RUNTIME_DEFAULT_TEXT_COLOR = clWindowText;
	RUNTIME_DEFAULT_BACK_COLOR = clBtnFace;

	EXPINT_ACAPO_NUMERO = 5;
	EXPINT_ACAPO_DESCR : array [0..EXPINT_ACAPO_NUMERO-1] of string = ('CR+LF (acapo std)', 'LF+CR', 'CR', 'LF', 'SPAZIO');
	EXPINT_ACAPO_VALUES : array [0..EXPINT_ACAPO_NUMERO-1] of string = (ACAPO, LF+CR, CR, LF, ' ');

	EXPINT_TAB_NUMERO = 7;
	EXPINT_TAB_DESCR : array [0..EXPINT_TAB_NUMERO-1] of string = ('TAB', 'SPAZIO', 'DOPPIO SPAZIO', 'TRIPLO SPAZIO', '@', '*', '#');
	EXPINT_TAB_VALUES : array [0..EXPINT_TAB_NUMERO-1] of string = (TAB, ' ', '  ', '   ', '@', '*', '#');

	HELP_FONT_CONDIZIONALE = 'Se la condizione risulta verificata,' + ACAPO +
		'all''oggetto vengono applicate le modifiche specificate';

procedure edit_label_proc(father : TForm;lab : cl_label;i_obj : obj_index_type;bo_modal : boolean = FALSE;bo_open_page_exportazione : boolean = FALSE;i_profilo_export : expint_index_type = 0);
begin
	if NOT wx.can_open(father, WT_LABEL_EDIT, lab.ca.i_numero_obj.ToString) then exit;
	var dlg := TLabels.xCreate(father, lab, i_obj);
	wx.register_window(father, dlg, WT_LABEL_EDIT, lab.ca.i_numero_obj.ToString);
	if bo_open_page_exportazione then begin
		dlg.bo_dont_set_activepage := TRUE;
		dlg.pc.Activepage := dlg.page_expint;
		dlg.lb_expint_elenco.ItemIndex := i_profilo_export;
		dlg.expint_click;
		if dlg.str_expint_header.Enabled then dlg.Activecontrol := dlg.str_expint_header
	end;
	if bo_modal then begin dlg.ShowModal{;dlg.Free} end else dlg.Show
end;

constructor TLabels.xcreate(father : TForm;lo : cl_label;i_obj : obj_index_type);
begin
	ledit := lo;
//	bak_attr := cl_common_attributes.create(lo.ca.i_section);
	lbak := cl_label.xCreate(self, lo{, bak_attr});
	i_logical_page := get_pagina_logica_attiva_1B;
	i_sezione := ledit.ca.i_section_1B;
	self.i_obj := i_obj;

	// genero una copia dei dati oggetto di editing (per quanto riguarda l'export integrale)
	setLength(expint_objects, expint_profiles_count);
	for var i : expint_index_type := 0 to high(expint_objects) do begin
		expint_objects[i] := cl_expint_object.create;
		expint_objects[i].assign(lo.get_expint_object(i))
	end;

	inherited create(father)
end;

procedure Tlabels.FormCreate(Sender : TObject);
begin
	for var i : smallint := 0 to page_object_type.pagecount-1 do page_object_type.pages[i].TabVisible := FALSE;		// nascondo i TABs
	resize_runtime_panels;
	set_minimum_form_size(self);

	rb_round.Items.clear;
	for var i : smallint := 0 to byte(high(ROUND_TYPE_DESCRIZIONE)) do rb_round.Items.add(ROUND_TYPE_DESCRIZIONE[ROUND_TYPES(i)]);
	memo_DB_colonna.Color := FIELD_EDIT_COLOR;
	str_formula.Color := TIPO_VARIABILE_EDIT_COLOR[TV_FORMULA];
	gbox_LCF.Hint := HELP_FONT_CONDIZIONALE;

	for var i : smallint := 0 to byte(high(expint_multiline_type)) do
		cb_expint_multiline.Items.add(EXPINT_MULTILINE_DESCR[expint_multiline_type(i)]);
	load_object_export_types_items(cb_export.Items);
	expint_profilo_load_items(lb_expint_elenco.Items);

	rb_validazione.Items.Clear;
	for var i : smallint := 0 to byte(high(validazione_type)) do rb_validazione.Items.add(VALIDAZIONE_DESCRIZIONI[validazione_type(i)]);

	cbx_validazione_always.Hint := VALIDAZIONE_CONTEXT_HINT_ALWAYS;cbx_validazione_blocco_always.Hint := VALIDAZIONE_CONTEXT_HINT_ALWAYS;
	cbx_validazione_elaborazione.Hint := VALIDAZIONE_CONTEXT_HINT_ELABORAZIONE;cbx_validazione_blocco_elaborazione.Hint := VALIDAZIONE_CONTEXT_HINT_ELABORAZIONE;
	cbx_validazione_print.Hint := VALIDAZIONE_CONTEXT_HINT_PRINT;cbx_validazione_blocco_print.Hint := VALIDAZIONE_CONTEXT_HINT_PRINT;
	cbx_validazione_mail.Hint := VALIDAZIONE_CONTEXT_HINT_MAIL;cbx_validazione_blocco_mail.Hint := VALIDAZIONE_CONTEXT_HINT_MAIL;
	cbx_validazione_FTP.Hint := VALIDAZIONE_CONTEXT_HINT_FTP;cbx_validazione_blocco_FTP.Hint := VALIDAZIONE_CONTEXT_HINT_FTP;
	cbx_validazione_expint.Hint := VALIDAZIONE_CONTEXT_HINT_EXPINT;cbx_validazione_blocco_expint.Hint := VALIDAZIONE_CONTEXT_HINT_EXPINT;
	cbx_validazione_XML.Hint := VALIDAZIONE_CONTEXT_HINT_XML;cbx_validazione_blocco_XML.Hint := VALIDAZIONE_CONTEXT_HINT_XML;
	cbx_after_runtime_parms.Hint := VALIDAZIONE_CONTEXT_HINT_CHECK_PARMS;cbx_check_parms.Hint := VALIDAZIONE_CONTEXT_HINT_AFTER_RUNTIME;
	cbx_after_runtime_parms_blocco.Hint := VALIDAZIONE_CONTEXT_HINT_CHECK_PARMS;cbx_check_parms_blocco.Hint := VALIDAZIONE_CONTEXT_HINT_AFTER_RUNTIME;

	cb_comportamento_null.Items.Clear;
	for var i : smallint := 0 to byte(high(comportamento_when_null_type)) do cb_comportamento_null.Items.Add(COMPORTAMENTO_NULL_DESCRIZIONE[comportamento_when_null_type(i)]);
	cb_value_when_null.Items.Text := NULL_STANDARD_VALUES_NUMERICI;		// NUMERICI è più generico di STRINGS

	if (globale.str_lingua_object <> '') then begin
		cbx_attiva_traduzione.Checked := (ledit.str_ID_lingua <> '');
		load_lingua_items(cb_ID_lingua.Items, get_language_context_mode);

		if (globale.str_lingua_contesto = '') then cbx_IDs_lingua_selected_context.Caption := 'IDs dotati di contesto'
		else cbx_IDs_lingua_selected_context.Caption := 'IDs contesto <' + globale.str_lingua_contesto + '>';
		cbx_IDs_lingua_selected_context.Checked := (globale.str_lingua_contesto <> '');

		// se l'ID linguistico non viene riscontrato tra gli IDs disponibili, provo a cambiare la modalità di ricerca
		if (ledit.str_ID_lingua <> '') AND (cb_ID_lingua.Items.IndexOf(ledit.str_ID_lingua) = -1) AND
			esiste_codice(globale.system_database.DatabaseName, TBL_TRADUZIONI_LINGUA, TBL_TDL_STR_CODICE, ledit.str_ID_lingua)
		then begin
			var s := get_string_where(globale.system_database.DatabaseName, TBL_TRADUZIONI_LINGUA, TBL_TDL_STR_ID_CONTESTO,
				TBL_TDL_STR_CODICE + '=' + ledit.str_ID_lingua.QuotedString);
			if (s = '') then cbx_IDs_lingua_generic_context.Checked := TRUE else cbx_IDs_lingua_selected_context.Checked := FALSE;
			load_lingua_items(cb_ID_lingua.Items, get_language_context_mode)
		end
	end;

	load_shift_formula_items(cb_formula_Xpos.Items);
	load_shift_formula_items(cb_formula_Ypos.Items);
	write;
	IO_form_size_and_pos(self, FALSE, {registry_argument}'', {reset_values}FALSE, IO_form_size_and_pos_custom_proc);

	bo_started := TRUE;
	enable_ctrls;enable_suppress_blanks;
	{$ifdef DEBUG} check_components(self); {$endif}
	bo_something_modified := FALSE
end;

procedure Tlabels.FormDestroy(Sender : TObject);
begin
	if (lbak <> NIL) then begin
		if bo_something_modified then ledit.assign(lbak);
		lbak.free;lbak := NIL
	end;

	for var i : expint_index_type := 0 to high(expint_objects) do expint_objects[i].free;
	expint_objects := NIL;

//	if (bak_attr <> NIL) then begin bak_attr.free;bak_attr := NIL end
	wx.close_window(self)
end;

procedure Tlabels.FormClose(Sender : TObject;var Action : TCloseAction);
begin
	if (windowState <> wsMaximized) then		// altrimenti salva la misura maximized, che è fondamentalmente un equivoco
		IO_form_size_and_pos(self, TRUE, {registry_argument}'', {reset_values}FALSE, IO_form_size_and_pos_custom_proc);
	Action := caFree
end;

procedure Tlabels.FormCloseQuery(Sender : TObject; var CanClose : Boolean);
begin
	CanClose := NOT bo_something_modified OR (MessageBBox(handle, 'Vuoi uscire senza salvare le modifiche?', MBOX_CAPTION, MB_QUESTION) = IDYES)
end;

procedure Tlabels.btn_okClick(Sender : TObject);
begin
	if NOT read then exit;
	bo_something_modified := FALSE;
	set_global_modified;
	close
end;

procedure Tlabels.btn_cancelClick(Sender : TObject); begin close end;

procedure Tlabels.write;
// scrive LEDIT sulla maschera
begin
	txt_object.Caption := zeri(i_obj, 3);
//	resize_runtime_panels;

//	if globale.bo_report then cbx_centrato.Caption := 'centrato nella pagina';
	cbx_centrato.Caption := ifs((globale.tiporeport in LABEL_TYPES), 'centrato nell''etichetta', 'centrato nella pagina');
//	load_objects(cb_valuta.Items, [xVARIABILE], get_pagina_logica_attiva, ledit.i_section);
	load_objects(cb_valuta.Items, TV_OLD_VARIABILI, get_pagina_logica_attiva_1B, i_sezione);
//	cb_select(cb_valuta,lo.str_usa_formato_valuta);
	cb_valuta.Text := ledit.str_usa_formato_valuta;
	str_datetime_format.Text := ledit.str_datetime_format;

	cb_round_valuta.Items.clear;
	for var rvt : round_valuta_type := low(rvt) to high(rvt) do cb_round_valuta.Items.add(round_valuta_descr[rvt]);
	cb_round_valuta.ItemIndex := byte(ledit.round_valuta);
	cb_round_valuta_min.Items.assign(cb_round_valuta.Items);
	cb_round_valuta_min.ItemIndex := byte(ledit.round_valuta_min);
	cbx_valuta_breve.Checked := ledit.bo_usa_simbolo_valuta_breve;
	cb_select(cb_ID_lingua, ledit.str_ID_lingua);
	cbx_PDF_modificabile.Checked := ledit.bo_PDF_modificabile;

	var vdx : cl_validazione := ledit.validazione;
	cbx_attiva_validazione.Checked := vdx.bo_attivo;
	rb_validazione.ItemIndex := byte(vdx.tipo);
	cbx_validate_pre_SQL.Checked := vdx.bo_pre_SQL;
	str_validazione_formula.Text := vdx.str_formula;
	str_validazione_message.Text := vdx.str_message;
	str_validazione_descrizione_field.Text := vdx.str_descrizione_field;
	cbx_errore_bloccante.Checked := vdx.bo_bloccante;
	str_condizione_bloccante_aggiuntiva.Text := vdx.str_condizione_bloccante_aggiuntiva;

	cbx_check_parms.Checked := (VCTXT_CHECK_PARMS in vdx.contexts_attivo);
	cbx_after_runtime_parms.Checked := (VCTXT_AFTER_RUNTIME in vdx.contexts_attivo);
	cbx_validazione_always.Checked := vdx.get_check_always_standard({bloccante}FALSE);
	cbx_validazione_elaborazione.Checked := (VCTXT_ELABORAZIONE in vdx.contexts_attivo);
	cbx_validazione_print.Checked := (VCTXT_PRINT in vdx.contexts_attivo);
	cbx_validazione_mail.Checked := (VCTXT_MAIL in vdx.contexts_attivo);
	cbx_validazione_FTP.Checked := (VCTXT_FTP in vdx.contexts_attivo);
	cbx_validazione_expint.Checked := (VCTXT_EXPORT_INTEGRALE in vdx.contexts_attivo);
	cbx_validazione_XML.Checked := (VCTXT_XML in vdx.contexts_attivo);

	cbx_check_parms_blocco.Checked := (VCTXT_CHECK_PARMS in vdx.contexts_bloccante);
	cbx_after_runtime_parms_blocco.Checked := (VCTXT_AFTER_RUNTIME in vdx.contexts_bloccante);
	cbx_validazione_blocco_always.Checked := vdx.get_check_always_standard({bloccante}TRUE);
	cbx_validazione_blocco_elaborazione.Checked := (VCTXT_ELABORAZIONE in vdx.contexts_bloccante);
	cbx_validazione_blocco_print.Checked := (VCTXT_PRINT in vdx.contexts_bloccante);
	cbx_validazione_blocco_mail.Checked := (VCTXT_MAIL in vdx.contexts_bloccante);
	cbx_validazione_blocco_FTP.Checked := (VCTXT_FTP in vdx.contexts_bloccante);
	cbx_validazione_blocco_expint.Checked := (VCTXT_EXPORT_INTEGRALE in vdx.contexts_bloccante);
	cbx_validazione_blocco_XML.Checked := (VCTXT_XML in vdx.contexts_bloccante);

	cb_criterio_ricalcolo.ItemIndex := byte(ledit.criterio_ricalcolo);

	cb_comportamento_null.ItemIndex := byte(ledit.comportamento_when_null);
	cb_value_when_null.Text := ledit.str_value_when_null;

	var sx := '';
	for var apx : APIX_type := low(apx) to high(apx) do begin
		cb_formato_multiselect.Items.add(APIX_DESCR[apx]);
		add_delimited(sx, APIX_DESCR[apx] + ':   ' + inapicia('MERCURIO,VENERE,MARTE', apx), ACAPO)
	end;
	cb_formato_multiselect.Hint := sx;
	cb_formato_multiselect.ItemIndex := byte(ledit.RTQ_apix);

	str_text.Text := ledit.Caption;
	str_formula.Text := ledit.ca.str_formula;
	rb_round.ItemIndex := byte(ledit.round_method);

	case ledit.charcase of
		ecLowerCase : rb_charcase.ItemIndex := 0;
		ecNormal : rb_charcase.ItemIndex := 1;
		ecUpperCase : rb_charcase.ItemIndex := 2
	end;

	rb_solo_testo.Checked := (ledit.ca.tipo_valore = VAL_TESTO);
{	cbx_hide.Checked := ledit.xbo_hide;
	bo_was_hidden := ledit.xbo_hide; }
	fl_interlinea.Text := floattostr(ledit.fl_cm_interlinea);
	i_max_rows.Text := ledit.i_max_rows.ToString;
	fl_max_vertical_size.Text := floattostr(ledit.fl_max_vertical_size_cm);

	load_combo_show_types(cb_show, i_sezione, ledit.ca.show);
	cbx_progressivo.Checked := ledit.bo_valore_progressivo;
	cbx_show_segno.Checked := ledit.bo_show_segno;

	for var i : smallint := 1 to NUM_FUNCTIONS do cb_available_functions.Items.add(FUNC[i].str_help);
	i_rotazione.set_Asinteger(ledit.angle);
	i_font_orientation.set_Asinteger(ledit.FontOrientation);

	for var tvar : variabile_type := succ(TV_BLANK) to high(tvar) do begin
		if (tvar <> ledit.ca.tipo_variabile) AND		// se per caso la variabile ha il valore proibito, lascio il valore
//			(tvar in [TV_PARAMETRO, TV_SQL_SELECT_BEFORE_START])	// fino al 2006-09-02
			(tvar in TV_COSTANTI)
			AND (i_sezione <> MAIN_SECTION) then continue;
		cb_tipovar.Items.add(TV_DESCRIZIONE[tvar])
	end;
	cb_select(cb_tipovar, TV_DESCRIZIONE[ledit.ca.tipo_variabile]);
//	cb_tipovar.ItemIndex := byte(ledit.tipovar);

(*	case ledit.tipo_oggetto of		*** fino 2011-05-17
		xxTESTO : page_object_type.ActivePage := page_text;
		xxVARIABILE : page_object_type.ActivePage := page_variabile;
		xxFORMULA : page_object_type.ActivePage := page_formula
		{$ifdef DEBUG} else assert(FALSE, 'DHWE 9210') {$endif}
	end;
	page_text.Highlighted := (ledit.tipo_oggetto = xxTESTO);
	page_formula.Highlighted := (ledit.tipo_oggetto = xxFORMULA);
	page_variabile.Highlighted := (ledit.tipo_oggetto = xxVARIABILE); *)

	cbx_trasparente.Checked := ledit.bo_trasparente;
	panel_fondo.Color := ledit.lo_background_color;

	if ledit.autosize then rb_size_auto.Checked := TRUE else rb_size_fissa.Checked := TRUE;
	cbx_autoheight.Checked := ledit.bo_autoheight;
	i_size_cm.Text := strid(video2cm_x(ledit.Width), 0, 2);
	i_left_cm.Text := strid(video2cm_x(ledit.Left), 0, 2);
	i_top_cm.Text := strid(video2cm_y(ledit.Top), 0, 2);
	str_formula_Xpos.Text := ledit.ca.str_formula_Xpos_cm;cb_formula_Xpos.ItemIndex := byte(ledit.ca.tipo_formula_Xpos);
	str_formula_Ypos.Text := ledit.ca.str_formula_Ypos_cm;cb_formula_Ypos.ItemIndex := byte(ledit.ca.tipo_formula_Ypos);
	if globale.bo_text_only then i_size_chars.Text := tm.videopixel2colonne(ledit.Width+1).ToString;
//	enable_FC(txt_size_cm,NOT ledit.autosize AND NOT globale.bo_text_only);
//	enable_FC(txt_size_chars,NOT ledit.autosize AND globale.bo_text_only);

	case ledit.alignment of
		TaLeftJustify : rb_align.ItemIndex := 0;
		TaCenter : rb_align.ItemIndex := 1;
		TaRightJustify : rb_align.ItemIndex := 2
	end;
	cbx_giustificato.Checked := ledit.bo_giustificato;

	str_esempio.Text := ledit.ca.str_esempio_value;
	str_hints.Text := ledit.ca.str_hints;
	str_remarks.Text := ledit.ca.str_remarks;
	page_remarks.Highlighted := {(ledit.ca.str_hints <> '') OR} (ledit.ca.str_remarks <> '');

//	page_expint.HighLighted := (ledit.editing_type <> OEXP_DEFAULT) OR (ledit.i_pos <> 0);
//	lb_expint_elenco.ItemIndex := max(globale.i_default_expint_profile, 0);
	lb_expint_elenco.ItemIndex := 0;
	write_expint(lb_expint_elenco.ItemIndex);

	memo_DB_colonna.Text := ledit.ca.str_SQL_expression;
//	str_tables_aggiuntive.Text := ledit.str_add_tables;

	for var i : smallint := 0 to RND_NUMERO-1 do begin
		cb_round.Items.add(RND_VALUES[i].str_descr);
		if (ledit.str_round_formula = '') AND (ledit.xi_cifre_round = RND_VALUES[i].i_cifre) then cb_round.ItemIndex := i
	end;
	str_round.Text := ledit.str_round_formula;
	if (ledit.i_decimali_fissi = 0) then str_decimali_fissi.Text := coalesce(ledit.str_decimali_fissi_formula, '0') else str_decimali_fissi.Text := ledit.i_decimali_fissi.ToString;
	if (ledit.i_zeri = 0) then str_zeri.Text := coalesce(ledit.str_zeri_formula, '0') else str_zeri.Text := ledit.i_zeri.ToString;

	cb_formato_numero.ItemIndex := byte(ledit.fnt_formato_numerico);

	cbx_valuta.Checked := ledit.bo_simbolo_valuta;
	str_simbolo_valuta.Text := ledit.str_simbolo_valuta;
	str_simbolo_valuta.maxlength := LEN_SIMBOLO_VALUTA;
	rb_posizione_simbolo_valuta.ItemIndex := 1 - byte(ledit.bo_simbolo_valuta_sx);

	cbx_centrato.Checked := ledit.bo_centrato;
	cbx_switch_fontstyle.Checked := ledit.bo_switch_fontstyle;
	cbx_multiline.Checked := ledit.bo_multiline;
	cbx_riduci_se_necessario.Checked := ledit.bo_riduci_if_necessario;
	cbx_posizione_fissa.Checked := ledit.ca.bo_posizione_fissa;
	cbx_footer.Checked := ledit.ca.bo_footer;
	cbx_footer.Enabled := (i_sezione = MAIN_SECTION);
	cbx_runtime.Checked := ledit.bo_ask_runtime;
	if ledit.bo_ask_runtime then page_runtime.Highlighted := TRUE;
	str_runtime_default.Text := ledit.str_runtime_default_phisical;
	str_runtime_default_debug.Text := ledit.str_runtime_default_debug_phisical;
	cbx_parm_runtime_SQL.Checked := ledit.bo_runtime_default_is_SQL;
	cbx_parm_runtime_formula.Checked := ledit.bo_runtime_default_is_formula;
	cbx_log_SQL.Checked := ledit.ca.bo_log_query_sql;
	str_runtime_question.Text := ledit.str_runtime_question;
	str_runtime_caption.Text := ledit.xstr_runtime_caption;
	str_runtime_ask_if.Text := ledit.str_runtime_ask_if;
	str_runtime_enable_if.Text := ledit.str_runtime_enable_if;
	str_runtime_format.Text := ledit.str_runtime_format;
	cbx_runtime_answer_can_be_blank.Checked := ledit.bo_runtime_answer_can_be_blank;
	cbx_runtime_answer_in_valori_suggeriti.Checked := ledit.bo_runtime_answer_in_valori_suggeriti;
	str_runtime_answers.Text := ledit.str_runtime_answers;
	str_runtime_values.Text := ledit.str_runtime_values;
	str_runtime_blank_answer.Text := ledit.str_runtime_blank_answer;
	cbx_SQL_load_runtime_values.Checked := ledit.bo_SQL_load_runtime_values;
	cbx_SQL_runtime_debug.Checked := ledit.bo_SQL_runtime_parm_debug;
	cbx_RTQ_select_all_answers.Checked := ledit.bo_RTQ_select_all_answers;

	if (ledit.lo_runtime_text_color = RUNTIME_UNASSIGNED_COLOR) then panel_color.Font.Color := RUNTIME_DEFAULT_TEXT_COLOR
	else panel_color.Font.Color := ledit.lo_runtime_text_color;
	if (ledit.lo_runtime_back_color = RUNTIME_UNASSIGNED_COLOR) then panel_color.Color := RUNTIME_DEFAULT_BACK_COLOR
	else panel_color.Color := ledit.lo_runtime_back_color;
	str_runtime_hint.Text := ledit.str_runtime_hint;
	rb_runtime_tipodato.ItemIndex := byte(ledit.runtime_tipodato);
	str_runtime_path.Text := ledit.str_runtime_path;
	str_runtime_filename_filter.Text := ledit.str_runtime_filename_filter;
	str_runtime_script.Text := ledit.str_runtime_scripts;

	i_runtime_max_length.set_VAR_smallint(ledit.i_runtime_max_length);
	i_runtime_min_length.set_VAR_smallint(ledit.i_runtime_min_length);
	i_runtime_max_lines.set_VAR_smallint(ledit.i_runtime_max_lines);

	str_LCF_condizione.Text := ledit.str_LCF_condizione;
	cbx_LCF_bold.State := xbool2cbx(ledit.box_LCF_bold);
	cbx_LCF_underline.State := xbool2cbx(ledit.box_LCF_underline);
	cbx_LCF_italic.State := xbool2cbx(ledit.box_LCF_italic);
	cbx_LCF_strikeout.State := xbool2cbx(ledit.box_LCF_strikeout);
	cb_LCF_foreground_color.ColorValue := ledit.LCF_foreground_color;
	panel_LCF_background_color.Color := coalesce(ledit.LCF_background_color, clBtnFace);
	update_LCF_esempio;

	page_store.TabVisible := (page_object_type.Activepage <> page_text);
	cbx_store_variabile.Checked := ledit.bo_store_variabile;
	page_store.Highlighted := ledit.bo_store_variabile;
	cbx_nome_variabile_SQL.Checked := ledit.bo_nome_variabile_SQL;
	self.str_nome_variabile_store.Text := ledit.str_nome_variabile_store;
	for var stoop : STORE_OPERATION_TYPE := low(stoop) to high(stoop) do cb_stoop.Items.add(STOOP_DESCRIZIONE[stoop]);
	cb_stoop.ItemIndex := byte(ledit.store_operation);

	cbx_font_bold.Checked := ledit.bo_forza_font_bold;
	cbx_font_italic.Checked := ledit.bo_forza_font_italic;
	cbx_font_underlined.Checked := ledit.bo_forza_font_underlined;
	cbx_font_strikeout.Checked := ledit.bo_forza_font_strikeout;
	page_forza_font.Highlighted := ledit.bo_forza_font_bold OR ledit.bo_forza_font_italic OR ledit.bo_forza_font_underlined OR ledit.bo_forza_font_strikeout;

	rb_RTQ.Items.clear;
	sx := '';
{	for var rtq : RTQ_type := low(rtq) to high(rtq) do begin
		sx := RTQ_DESCRIZIONI[rtq];
		case rtq of
//			RTQ_SINGLE_SELECT : s := s + ' (max ' + inttostr(MAX_PARMS_DOMANDA_MULTIPLA) + ')';
			RTQ_MULTI_SELECT : sx := sx + ' (max ' + inttostr(RTQ_MULTI_SELECT_MAX_ITEMS) + ')'
		end;
		rb_RTQ.Items.add(sx)
	end; }
	for var rtq : RTQ_type := low(rtq) to high(rtq) do rb_RTQ.Items.add(RTQ_DESCRIZIONI[rtq]);
	rb_RTQ.ItemIndex := byte(ledit.rtq);

	with cb_minimum_auto_size do itemindex := items.indexof(MAX(ledit.i_minimum_size_auto,1).ToString);

	self.str_print_if.Text := ledit.ca.str_print_if;
	cb_nz.Checked := ledit.bo_blank_if_zero;
	cbx_suppress_blank.Checked := ledit.bo_suppress_blank;
//	cbx_insert_if_multiline.Checked := ledit.bo_insert_line_if_multiline;
	cbx_insert_if_multiline.Checked := ledit.ca.bo_move_obj_sottostanti;

	runtime_groupboxes_load_items(cb_runtime_parm_gbox.Items, globale.runtime_gboxes);
	cb_runtime_parm_gbox.ItemIndex := ledit.i_runtime_groupbox;
	if (cb_runtime_parm_gbox.ItemIndex = -1) then cb_runtime_parm_gbox.ItemIndex := 0;

	page_runtime_avanzate.highlighted := (str_runtime_ask_if.Text + str_runtime_enable_if.Text + str_runtime_hint.Text <> '') OR
		(cb_runtime_parm_gbox.ItemIndex <> 0);
	page_runtime_formato.HighLighted := (ledit.runtime_tipodato <> RTT_TEXT) OR (ledit.str_runtime_format <> '') OR
		(ledit.str_runtime_path + ledit.str_runtime_filename_filter <> '');
	page_runtime_script.highlighted := (ledit.str_runtime_scripts <> '');
	page_default.Highlighted := (ledit.ca.str_esempio_value + ledit.str_runtime_default_phisical + ledit.str_runtime_default_debug_phisical <> '');

	enable_ctrls;enable_suppress_blanks
end;

function TLabels.read : boolean;
// legge i dati dalla maschera su LEDIT; rende TRUE in caso di successo

	function check_runtime_values : boolean;
	begin
		result := FALSE;
		if NOT cbx_runtime.Checked then begin result := TRUE;exit end;
		try
			var i_codici : smallint := 0;var i_risposte : smallint := 0;

{			*********** così fino 2021-08, ma gli eventuali spazi finali sono troppo invisibili
			for i := 0 to str_runtime_answers.lines.Count-1 do
				if (togliblanks(str_runtime_answers.lines[i]) <> '') then inc(i_risposte);
			for i := 0 to str_runtime_values.lines.Count-1 do
				if (togliblanks(str_runtime_values.lines[i]) <> '') then inc(i_codici); }

			for var i : smallint := 0 to str_runtime_answers.lines.Count-1 do begin
				str_runtime_answers.lines[i] := togliblanks(str_runtime_answers.lines[i]);		// aggiunta 2021-08 per eventuali spazi finali inutili e invisibili
				if (str_runtime_answers.lines[i] <> '') then inc(i_risposte)
			end;
			for var i : smallint := 0 to str_runtime_values.lines.Count-1 do begin
				str_runtime_values.lines[i] := togliblanks(str_runtime_values.lines[i]);		// aggiunta 2021-08 per eventuali spazi finali inutili e invisibili
				if (str_runtime_values.lines[i] <> '') then inc(i_codici)
			end;

//			if (i_codici <> 0) AND (i_risposte = 0) then result := FALSE // comunque: non possono esserci codici senza risposte
//				else
//			if NOT ((i_codici <> 0) AND (i_risposte = 0)) then begin
			if (i_codici = 0) OR (i_risposte <> 0) then begin
				if cbx_SQL_load_runtime_values.Checked then result := TRUE	// istruzioni SQL: non necessaria parità di righe
				else result := (i_codici = i_risposte) OR (i_codici = 0)
			end
		finally
			if NOT result then
				MessageBBox(handle, 'I codici di risposta devono essere di numerosità pari alle risposte suggerite', MBOX_CAPTION, MB_ICONSTOP)
		end
	end;

(*	function check_formula(str_formula : string;str_descrizione : string;tipo : risultato_type;bo_allow_blank : boolean) : boolean;
	{ rende TRUE se la formula specificata è valida, FALSE altrimenti;
	  TIPO deve essere il tipo di risultato richiesto, oppure può essere oppure VAL_BOH se qualunque tipo è ammesso }
	var s, str_temp : string;
	begin
		s := '';tipo := VAL_BOH;
		str_temp := str_formula;
		str_temp := translate_local_macros(str_temp);	// dal 2005-06-20
		sections_1B(i_sezione).interpreta_string(str_temp, FALSE, TRUE);	// aggiunta del 2005-05-09
		if bo_allow_blank AND (str_temp = '') then result := TRUE
		else result := translate_formula(str_temp, s, TRUE, tipo, xobjs(i_obj, i_logical_page));
		if NOT result then MessageBBox(handle, s, str_descrizione, MB_ICONSTOP)
	end; *)

var
	i : integer;
	j : smallint;
	r : real;
begin
	result := FALSE;
	str_text.Text := togliblanks(str_text.Text);
	if (str_text.Text = '') then begin
		MessageBBox(handle,
//			ifs(ledit.tipo_oggetto = xxTESTO,
			ifs(ledit.ca.tipo_variabile = TV_STATIC_TEXT,
			'E'' necessario che ogni oggetto di testo contenga un testo',
			'E'' necessario che ogni oggetto abbia un nome'), MBOX_CAPTION, MB_ICONSTOP);
		exit
	end;
	if NOT check_runtime_values then exit;

	var ox : objs_type := xobjs(i_obj, i_logical_page);
	if NOT sections_1B(i_sezione).validate_formula_editing(handle, str_formula_Xpos.Text, 'formula posizione asse X', NIL, VAL_NUMERO, {allow_blank}TRUE) then exit;
	if NOT sections_1B(i_sezione).validate_formula_editing(handle, str_formula_Ypos.Text, 'formula posizione asse Y', NIL, VAL_NUMERO, {allow_blank}TRUE) then exit;
	ledit.ca.str_formula_Xpos_cm := str_formula_Xpos.Text;ledit.ca.tipo_formula_Xpos := shift_formula_type(cb_formula_Xpos.ItemIndex);
	ledit.ca.str_formula_Ypos_cm := str_formula_Ypos.Text;ledit.ca.tipo_formula_Ypos := shift_formula_type(cb_formula_Ypos.ItemIndex);

	if NOT sections_1B(i_sezione).validate_formula_editing(handle, str_LCF_condizione.Text, 'formula FONT alternativo condizionale', NIL,
		VAL_BOOLEAN, {allow_blank}TRUE) then exit;
	if cbx_attiva_validazione.Checked then begin
		if (validazione_type(rb_validazione.ItemIndex) = VALID_FORMULA) AND
			NOT sections_1B(i_sezione).validate_formula_editing(handle, str_validazione_formula.Text, 'formula validazione', NIL,
				VAL_BOOLEAN, {allow_blank}FALSE) then exit;
		if cbx_errore_bloccante.Checked AND (togliblanks(str_condizione_bloccante_aggiuntiva.Text) <> '') AND
			NOT sections_1B(i_sezione).validate_formula_editing(handle, str_condizione_bloccante_aggiuntiva.Text, 'validazione: condizione aggiuntiva blocco', NIL,
				VAL_BOOLEAN, {allow_blank}FALSE) then exit
	end;

{	if (page_object_type.ActivePage = page_text) then ledit.tipo_oggetto := xxTESTO;
	if (page_object_type.ActivePage = page_formula) then ledit.tipo_oggetto := xxFORMULA;
	if (page_object_type.ActivePage = page_variabile) then ledit.tipo_oggetto := xxVARIABILE; }

	if NOT xobjs(i_obj, i_logical_page).check_name(handle, str_text.Text) then exit;

	ledit.ca.str_print_if := self.str_print_if.Text;
	if NOT ledit.ca.check_print_if(handle) then exit;

//	if (ledit.tipo_oggetto in [xxFORMULA, xxVARIABILE]) AND (ledit.tipo_valore in [VAL_NUMERO]) then begin
	if (ledit.ca.tipo_variabile in [TV_FORMULA] + TV_OLD_VARIABILI) AND (ledit.ca.tipo_valore in [VAL_NUMERO]) then begin
		if cbx_parm_runtime_SQL.Checked AND cbx_parm_runtime_formula.Checked then begin
			MessageBBox(handle, 'Il valore di esempio non può essere contemporaneamente di tipo SQL e di tipo FORMULA', MBOX_CAPTION, MB_ICONSTOP);
			exit
		end;

		RRval(str_esempio.Text, r, @i);
		if (i <> 0) AND
			NOT (cbx_parm_runtime_SQL.Enabled AND cbx_parm_runtime_SQL.Checked) AND
			NOT (cbx_parm_runtime_formula.Enabled AND cbx_parm_runtime_formula.Checked) AND
			(MessageBBox(handle,'Il valore di esempio dovrebbe essere un numero.' + ACAPO + 'Vuoi modificarlo?',MBOX_CAPTION,MB_QUESTION) = IDYES)
		then begin
			pc.Activepage := page_default;str_esempio.Setfocus;
			exit
		end
	end;

	ledit.criterio_ricalcolo := recalculate_type(cb_criterio_ricalcolo.ItemIndex);

	ledit.comportamento_when_null := comportamento_when_null_type(cb_comportamento_null.ItemIndex);
	ledit.str_value_when_null := cb_value_when_null.Text;

	ledit.ca.str_formula := clear_blanks_eoln(str_formula.Text);	// da leggere sempre, per evitare equivoci
	ledit.ca.str_esempio_value := str_esempio.Text;
	ledit.ca.str_hints := str_hints.Text;
	ledit.ca.str_remarks := str_remarks.Text;
	ledit.ca.str_SQL_expression := memo_DB_colonna.Text;
//	ledit.str_add_tables := str_tables_aggiuntive.Text;
	ledit.Angle := i_rotazione.get_Asinteger(FALSE);
	ledit.FontOrientation := i_font_orientation.get_Asinteger(FALSE);

	ledit.str_usa_formato_valuta := cb_valuta.Text;
	ledit.str_datetime_format := str_datetime_format.Text;
	byte(ledit.round_valuta) := cb_round_valuta.ItemIndex;
	byte(ledit.round_valuta_min) := cb_round_valuta_min.Itemindex;
	ledit.bo_usa_simbolo_valuta_breve := cbx_valuta_breve.Checked;
{	if (ledit.str_usa_formato_valuta <> '') AND (ledit.xround_valuta < ledit.round_valuta_min) then
		MessageBBox(handle,
			'Si richiede di stampare un numero di decimali superiore a quello utilizzato nell''arrotondamento',MBOX_CAPTION); }
	ledit.str_ID_lingua := ifs(cbx_attiva_traduzione.Checked, cb_ID_lingua.Text);
	ledit.bo_PDF_modificabile := cbx_PDF_modificabile.Checked;

	var vdx : cl_validazione := ledit.validazione;
	vdx.bo_attivo := cbx_attiva_validazione.Checked;
	byte(vdx.tipo) := rb_validazione.ItemIndex;
	vdx.bo_pre_SQL := cbx_validate_pre_SQL.Checked;
	vdx.str_formula := str_validazione_formula.Text;
	vdx.str_message := str_validazione_message.Text;
	vdx.str_descrizione_field := str_validazione_descrizione_field.Text;
	vdx.bo_bloccante := cbx_errore_bloccante.Checked;
	vdx.str_condizione_bloccante_aggiuntiva := str_condizione_bloccante_aggiuntiva.Text;

//	vdx.bo_check_always := cbx_validazione_always.Checked;
	vdx.contexts_attivo := [];
	if cbx_check_parms.Checked then vdx.contexts_attivo := vdx.contexts_attivo + [VCTXT_CHECK_PARMS];
	if cbx_after_runtime_parms.Checked then vdx.contexts_attivo := vdx.contexts_attivo + [VCTXT_AFTER_RUNTIME];
	if cbx_validazione_elaborazione.Checked then vdx.contexts_attivo := vdx.contexts_attivo + [VCTXT_ELABORAZIONE];
	if cbx_validazione_print.Checked then vdx.contexts_attivo := vdx.contexts_attivo + [VCTXT_PRINT];
	if cbx_validazione_mail.Checked then vdx.contexts_attivo := vdx.contexts_attivo + [VCTXT_MAIL];
	if cbx_validazione_FTP.Checked then vdx.contexts_attivo := vdx.contexts_attivo + [VCTXT_FTP];
	if cbx_validazione_expint.Checked then vdx.contexts_attivo := vdx.contexts_attivo + [VCTXT_EXPORT_INTEGRALE];
	if cbx_validazione_XML.Checked then vdx.contexts_attivo := vdx.contexts_attivo + [VCTXT_XML];

	vdx.contexts_bloccante := [];
	if cbx_check_parms_blocco.Checked then vdx.contexts_bloccante := vdx.contexts_bloccante + [VCTXT_CHECK_PARMS];
	if cbx_after_runtime_parms_blocco.Checked then vdx.contexts_bloccante := vdx.contexts_bloccante + [VCTXT_AFTER_RUNTIME];
	if cbx_validazione_blocco_elaborazione.Checked then vdx.contexts_bloccante := vdx.contexts_bloccante + [VCTXT_ELABORAZIONE];
	if cbx_validazione_blocco_print.Checked then vdx.contexts_bloccante := vdx.contexts_bloccante + [VCTXT_PRINT];
	if cbx_validazione_blocco_mail.Checked then vdx.contexts_bloccante := vdx.contexts_bloccante + [VCTXT_MAIL];
	if cbx_validazione_blocco_FTP.Checked then vdx.contexts_bloccante := vdx.contexts_bloccante + [VCTXT_FTP];
	if cbx_validazione_blocco_expint.Checked then vdx.contexts_bloccante := vdx.contexts_bloccante + [VCTXT_EXPORT_INTEGRALE];
	if cbx_validazione_blocco_XML.Checked then vdx.contexts_bloccante := vdx.contexts_bloccante + [VCTXT_XML];

	ledit.ca.tipo_variabile := get_tipo_variabile(cb_tipovar.Text);
	if (TV_DESCRIZIONE[ledit.ca.tipo_variabile] <> cb_tipovar.Text) then begin
		MessageBBox(handle,'Specifica il tipo di variabile', MBOX_CAPTION, MB_ICONSTOP);
		exit
	end;

	if (page_object_type.ActivePage = page_variabile) then begin
		var bo_select := start_with(ledit.ca.str_SQL_expression, 'SELECT', FALSE);

		if NOT (ledit.ca.tipo_variabile in TV_SQL_SELECT_OBJECTS) AND bo_select AND
			(MessageBBox(handle,ledit.ca.str_SQL_expression + ACAPO2 +
				'A me sembra tanto una <' + TV_DESCRIZIONE[TV_SQL_SELECT] + '>, tu che ne dici?',
				 MBOX_CAPTION,MB_QUESTION) = IDYES)
					then exit;
		if (ledit.ca.tipo_variabile in TV_SQL_SELECT_OBJECTS) AND
			NOT bo_select AND NOT start_with(ledit.ca.str_SQL_expression, '$', FALSE) AND		// se inizia per $ richiama un altro oggetto
			(MessageBBox(handle,ledit.ca.str_SQL_expression + ACAPO2 +
				'L''istruzione caricata a me sembra tutto fuorchè una <' + TV_DESCRIZIONE[TV_SQL_SELECT] + '>, concordi?',
				 MBOX_CAPTION,MB_QUESTION) = IDYES)
					then exit
	end;

(*	case ledit.tipo_oggetto of
		xxTESTO : ledit.tipovar := TV_STATIC_TEXT;
		xxVARIABILE : begin
			ledit.tipovar := low(variabile_type);
			while (ledit.tipovar < high(variabile_type)) AND (TV_DESCRIZIONE[ledit.tipovar] <> cb_tipovar.Text) do inc(ledit.tipovar);
			if (TV_DESCRIZIONE[ledit.tipovar] <> cb_tipovar.Text) then begin
				MessageBBox(handle,'Specifica il tipo di variabile',MBOX_CAPTION,MB_ICONSTOP);
				exit
			end;

			bo_select := start_with(ledit.str_db_colonna,'SELECT',FALSE);

			if NOT (ledit.tipovar in TV_SQL_SELECT_OBJECTS) AND
//				(togliblanks(uppercase(copy(ledit.str_db_colonna,1,length('SELECT')))) = 'SELECT') AND
				bo_select AND
				(MessageBBox(handle,ledit.str_db_colonna + ACAPO2 +
					'A me sembra tanto una <' + TV_DESCRIZIONE[TV_SQL_SELECT] + '>, tu che ne dici?',
					 MBOX_CAPTION,MB_QUESTION) = IDYES)
						then exit;
			if (ledit.tipovar in TV_SQL_SELECT_OBJECTS) AND
				NOT bo_select AND NOT start_with(ledit.str_db_colonna,'$',FALSE) AND	// se inizia per $ richiama un altro oggetto
//				(togliblanks(uppercase(copy(ledit.str_db_colonna,1,length('SELECT')))) <> 'SELECT') AND
				(MessageBBox(handle,ledit.str_db_colonna + ACAPO2 +
					'L''istruzione caricata a me sembra tutto fuorchè una <' + TV_DESCRIZIONE[TV_SQL_SELECT] + '>, concordi?',
					 MBOX_CAPTION,MB_QUESTION) = IDYES)
						then exit
		end;
		XXFORMULA : ledit.tipovar := TV_FORMULA
	end; *)
	ledit.bo_blank_if_zero := cb_nz.Checked;

	read_expint(i_written_expint);
	for i := 0 to high(expint_objects) do ledit.get_expint_object(i).assign(expint_objects[i]);

//	if (ledit.tipo_oggetto in [xxFORMULA, xxVARIABILE]) AND (ledit.tipo_valore = VAL_NUMERO) then begin
	if (ledit.ca.tipo_variabile in [TV_FORMULA] + TV_OLD_VARIABILI) AND (ledit.ca.tipo_valore = VAL_NUMERO) then begin
		if (str_round.Text = '') then begin
			if (cb_round.ItemIndex = -1) then cb_round.ItemIndex := 0;
			ledit.xi_cifre_round := RND_VALUES[cb_round.ItemIndex].i_cifre
		end
		else begin
			if NOT sections_1B(i_sezione).validate_formula_editing(handle, str_round.Text, 'formula ARROTONDAMENTO', ox, VAL_NUMERO, {allow_blank}FALSE) then exit;
			ledit.str_round_formula := str_round.Text;
			ledit.xi_cifre_round := RND_ROUND_FORMULA
		end;

//		ledit.i_decimali_fissi := leggi_text_integer(handle, i_decimali_fissi, 0, 9, 'cifre decimali fisse', ledit.i_decimali_fissi);
		if is_numeric(str_decimali_fissi.Text) then begin
			ledit.str_decimali_fissi_formula := '';
			ledit.i_decimali_fissi := leggi_text_integer(handle, str_decimali_fissi, 0, 9, 'cifre decimali fisse', ledit.i_decimali_fissi)
		end
		else begin
			if NOT sections_1B(i_sezione).validate_formula_editing(handle, str_decimali_fissi.Text, 'formula NUMERO DECIMALI', ox, VAL_NUMERO, {allow_blank}FALSE) then exit;
			ledit.str_decimali_fissi_formula := str_decimali_fissi.Text;
			ledit.i_decimali_fissi := 0
		end;
//		ledit.i_zeri := leggi_text_integer(handle, i_zeri, 0, 9, 'cifre (alla sinistra della virgola)', ledit.i_zeri)
		if is_numeric(str_zeri.Text) then begin
			ledit.str_zeri_formula := '';
			ledit.i_zeri := leggi_text_integer(handle, str_zeri, 0, 9, 'cifre (alla sinistra della virgola)', ledit.i_zeri)
		end
		else begin
			if NOT sections_1B(i_sezione).validate_formula_editing(handle, str_zeri.Text, 'formula NUMERO CIFRE', ox, VAL_NUMERO, {allow_blank}FALSE) then exit;
			ledit.str_zeri_formula := str_zeri.Text;
			ledit.i_zeri := 0
		end
	end;
//	if (ledit.tipo_oggetto = xxFORMULA) then begin
	if (ledit.ca.tipo_variabile = TV_FORMULA) then begin
(*		xs := '';tipo := VAL_BOH;
		str_temp := ledit.ca.str_formula;
		str_temp := translate_local_macros(str_temp);	// dal 2005-06-20
		sections_1B(i_sezione).interpreta_string(str_temp, FALSE, TRUE);	// aggiunta del 2005-05-09
		bo := translate_formula({ledit.str_formula}str_temp, xs, TRUE, tipo, xobjs(i_obj, i_logical_page));
		if NOT bo then begin
			if (xs <> '') then MessageBBox(handle, xs, MBOX_CAPTION, MB_ICONSTOP);
			exit
		end *)
		if NOT sections_1B(i_sezione).validate_formula_editing(handle, ledit.ca.str_formula, 'formula oggetto', ox, VAL_BOH, {allow_blank}FALSE) then exit
	end;

	ledit.bo_trasparente := cbx_trasparente.Checked;ledit.Transparent := ledit.bo_trasparente;
	ledit.lo_background_color := panel_fondo.Color;ledit.Color := ledit.lo_background_color;
	ledit.autosize := rb_size_auto.Checked;
	ledit.bo_autoheight := cbx_autoheight.Checked;

	try
		if fl_interlinea.Enabled then
			ledit.fl_cm_interlinea := leggi_text_real(handle, fl_interlinea, 0, 10, 'interlinea', ledit.fl_cm_interlinea);
//		if fl_max_vertical_size.Enabled then
			ledit.fl_max_vertical_size_cm := leggi_text_real(handle, fl_max_vertical_size, 0, 10, 'dimensione verticale max', ledit.fl_max_vertical_size_cm);
//		if i_max_rows.Enabled then begin
			i := leggi_text_integer(handle, i_max_rows, 0, 31, '# max righe', ledit.i_max_rows);
			ledit.i_max_rows := i;
//		end;

		if rb_size_fissa.Checked then begin
			if globale.bo_text_only then begin
				i := leggi_text_integer(handle, i_size_chars, 1, MAX_COLUMNS_PER_PRINT_PAGE, 'dimensione in caratteri', tm.videopixel2colonne(ledit.Width));
//				objs(tag2index(ledit.tag)).set_width(round(i * tm.r_text_only_char_video_pixel_x))
				xobjs(ledit.ca.i_numero_obj, i_logical_page).set_width(round(i * tm.r_text_only_char_video_pixel_x))
//				ledit.Width := round(my_round(i * tm.r_text_only_char_video_pixel_x,0,RND_DIFETTO))
			end
			else begin
				r := leggi_text_real(handle, i_size_cm, 0.1, 40, 'dimensione orizzontale', video2cm_x(ledit.Width));
				ledit.Width := cm2pixel_video_x(r)
			end
		end;

//		r := leggi_text_real(handle,i_left_cm,-DELTA_CUSCINO,40,'posizione orizzontale',video2cm_x(ledit.Left));
		r := leggi_text_real(handle, i_left_cm, 0, get_PHpage_size_X_cm_1B(i_logical_page) - video2cm_x(ledit.Width),'posizione orizzontale',
			video2cm_x(ledit.Left));
		ledit.Left := cm2pixel_video_x(r);
		r := leggi_text_real(handle,i_top_cm,-DELTA_CUSCINO_VERTICAL_HEIGHT,
			sections_1B(i_sezione).r_y_gruppo_cm - video2cm_y(ledit.Height) + DELTA_CUSCINO_VERTICAL_HEIGHT, 'posizione verticale',video2cm_y(ledit.Top));
		ledit.Top := cm2pixel_video_y(r)
	except
		exit
	end;

	case rb_align.Itemindex of
		0 : ledit.Alignment := TaLeftJustify;
		1 : ledit.Alignment := TaCenter;
		2 : ledit.Alignment := TaRightJustify
	end;
	ledit.bo_giustificato := cbx_giustificato.Checked;

	ledit.set_show_state(get_show_type(cb_show));

	case rb_charcase.ItemIndex of
		0 : ledit.Charcase := ecLowerCase;
		1 : ledit.Charcase := ecNormal;
		2 : ledit.Charcase := ecUpperCase
	end;

	ledit.verify_height;
	byte(ledit.fnt_formato_numerico) := cb_formato_numero.ItemIndex;

	ledit.str_simbolo_valuta := togliblanks(str_simbolo_valuta.Text);
	ledit.bo_simbolo_valuta := cbx_valuta.Checked AND ((ledit.str_simbolo_valuta <> '') OR (ledit.str_usa_formato_valuta <> ''));
	byte(ledit.bo_simbolo_valuta_sx) := 1-rb_posizione_simbolo_valuta.ItemIndex;

	ledit.bo_centrato := cbx_centrato.Checked;
	ledit.bo_switch_fontstyle := cbx_switch_fontstyle.Checked;
	ledit.bo_multiline := cbx_multiline.Checked;
	ledit.ca.bo_posizione_fissa := cbx_posizione_fissa.Checked;
	ledit.ca.bo_footer := cbx_footer.Checked;
	ledit.bo_riduci_if_necessario := cbx_riduci_se_necessario.Checked;
	system.Val(cb_minimum_auto_size.Text,j,i);
	if (i = 0) then ledit.i_minimum_size_auto := j;

	ledit.bo_suppress_blank := cbx_suppress_blank.Checked;
	ledit.bo_ask_runtime := cbx_runtime.Checked AND cbx_runtime.Enabled AND cbx_runtime.Visible;
	ledit.str_runtime_default_phisical := str_runtime_default.Text;
	ledit.str_runtime_default_debug_phisical := str_runtime_default_debug.Text;
	ledit.bo_runtime_default_is_SQL := cbx_parm_runtime_SQL.Checked;
	ledit.bo_runtime_default_is_formula := cbx_parm_runtime_formula.Checked;
	ledit.ca.bo_log_query_sql_phisical := cbx_log_SQL.Checked;
//	ledit.str_runtime_question := togliblanks(str_runtime_question.Text);*
	ledit.str_runtime_question := clear_blanks_eoln(str_runtime_question.Text);
	ledit.xstr_runtime_caption := str_runtime_caption.Text;
	ledit.str_runtime_ask_if := str_runtime_ask_if.Text;
	ledit.str_runtime_enable_if := str_runtime_enable_if.Text;
	ledit.str_runtime_format := str_runtime_format.Text;
//	if NOT ledit.valuta_ask_runtime_if(handle) then exit;
	if NOT ledit.check_runtime_if(handle, ledit.str_runtime_ask_if) then exit;
	if NOT ledit.check_runtime_if(handle, ledit.str_runtime_enable_if) then exit;
	if (ledit.bo_ask_runtime AND (ledit.str_runtime_question = '')) then
		MessageBBox(handle,'Domanda runtime non indicata',MBOX_CAPTION);
	ledit.bo_runtime_answer_can_be_blank := cbx_runtime_answer_can_be_blank.Checked;
	ledit.bo_runtime_answer_in_valori_suggeriti := cbx_runtime_answer_in_valori_suggeriti.Checked;
	ledit.str_runtime_answers := str_runtime_answers.Text;
	ledit.str_runtime_values := str_runtime_values.Text;
	ledit.str_runtime_blank_answer := str_runtime_blank_answer.Text;
	byte(ledit.rtq) := rb_RTQ.ItemIndex;
	ledit.bo_SQL_load_runtime_values := cbx_SQL_load_runtime_values.Checked;
	ledit.bo_SQL_runtime_parm_debug := cbx_SQL_runtime_debug.Checked;
	ledit.bo_RTQ_select_all_answers := cbx_RTQ_select_all_answers.Checked;
	ledit.RTQ_apix := APIX_type(cb_formato_multiselect.ItemIndex);

	if (panel_color.font.Color = RUNTIME_DEFAULT_TEXT_COLOR) then ledit.lo_runtime_text_color := RUNTIME_UNASSIGNED_COLOR
	else ledit.lo_runtime_text_color := panel_color.font.Color;
	if (panel_color.Color = RUNTIME_DEFAULT_BACK_COLOR) then ledit.lo_runtime_back_color := RUNTIME_UNASSIGNED_COLOR
	else ledit.lo_runtime_back_color := panel_color.Color;
	ledit.str_runtime_hint := str_runtime_hint.Text;
	ledit.runtime_tipodato := runtime_tipodato_type(rb_runtime_tipodato.ItemIndex);
	ledit.str_runtime_path := str_runtime_path.Text;
	ledit.str_runtime_filename_filter := str_runtime_filename_filter.Text;
	if NOT runtime_scripts_validate(self, ledit, str_runtime_script.Text) then abort;
	ledit.str_runtime_scripts := str_runtime_script.Text;

	ledit.bo_store_variabile := cbx_store_variabile.Checked;
	ledit.bo_nome_variabile_SQL := cbx_nome_variabile_SQL.Checked;
	ledit.str_nome_variabile_store := self.str_nome_variabile_store.Text;
	ledit.store_operation := STORE_OPERATION_TYPE(cb_stoop.ItemIndex);

	ledit.bo_forza_font_bold := cbx_font_bold.Checked;
	ledit.bo_forza_font_italic := cbx_font_italic.Checked;
	ledit.bo_forza_font_underlined := cbx_font_underlined.Checked;
	ledit.bo_forza_font_strikeout := cbx_font_strikeout.Checked;

//	if ledit.bo_forza_font_bold then ledit.font.style := ledit.font.style + [fsBold];
//	if ledit.bo_forza_font_bold then ledit.FontWeight := LFW_bold;
	if ledit.bo_forza_font_bold then ledit.Bold := TRUE;
//	if ledit.bo_forza_font_italic then ledit.font.style := ledit.font.style + [fsItalic];
	if ledit.bo_forza_font_italic then ledit.Italic := TRUE;
//	if ledit.bo_forza_font_underlined then ledit.font.style := ledit.font.style + [fsUnderline];
	if ledit.bo_forza_font_underlined then ledit.Underline := TRUE;
//	if ledit.bo_forza_font_strikeout then ledit.font.style := ledit.font.style + [fsStrikeout];
	if ledit.bo_forza_font_strikeout then ledit.Strikeout := TRUE;

//	ledit.bo_insert_line_if_multiline := cbx_insert_if_multiline.Checked;
	ledit.ca.bo_move_obj_sottostanti := cbx_insert_if_multiline.Checked;
	ledit.i_runtime_groupbox := cb_runtime_parm_gbox.ItemIndex;
	if (ledit.i_runtime_groupbox = -1) then ledit.i_runtime_groupbox := 0;

	ledit.str_LCF_condizione := str_LCF_condizione.Text;
	ledit.box_LCF_bold := cbx2xbool(cbx_LCF_bold.State);
	ledit.box_LCF_underline := cbx2xbool(cbx_LCF_underline.State);
	ledit.box_LCF_italic := cbx2xbool(cbx_LCF_italic.State);
	ledit.box_LCF_strikeout := cbx2xbool(cbx_LCF_strikeout.State);
	ledit.LCF_foreground_color := cb_LCF_foreground_color.ColorValue;
	ledit.LCF_background_color := panel_LCF_background_color.Color;

	ledit.round_method := ROUND_TYPES(rb_round.ItemIndex);
	ledit.bo_valore_progressivo := cbx_progressivo.Checked;
	ledit.bo_show_segno := cbx_show_segno.Checked;
	ledit.Hint := ledit.ca.str_hints;

	if (ledit.Caption <> lbak.Caption) then name2obj(ledit.Caption, FALSE).change_riferimenti(lbak.Caption, ledit.Caption);
	if (ledit.bo_autoheight AND NOT lbak.bo_autoheight) then ledit.verify_height;
//	ledit.Caption := ifs(ledit.tipo_oggetto = xTESTO, str_text.Text, uppercase(str_text.Text));	// 2011-05-11
	ledit.Caption := str_text.Text;	// 2011-05-11
	result := TRUE
end;

procedure Tlabels.btn_fontClick(Sender : TObject); begin if ledit.edit_font(self, TRUE) then bo_something_modified := TRUE end;

procedure Tlabels.str_textChange(Sender : TObject);
begin
	{lo.Caption := str_text.Text;}		// attivo fino 2011-05-11, ma disattivato x' faceva casino sui controlli sul nuovo nome
	bo_something_modified := TRUE
end;

procedure TLabels.enable_ctrls;
begin
	if NOT bo_started then exit;
{	var new_tipo : obj_type := FIRST_TIPO;
	if (page_object_type.ActivePage = page_text) then new_tipo := xxTESTO;
	if (page_object_type.ActivePage = page_formula) then new_tipo := xxFORMULA;
	if (page_object_type.ActivePage = page_variabile) then begin
		new_tipo := xxVARIABILE;
		if (cb_tipovar.ItemIndex = -1) then cb_tipovar.ItemIndex := 0
	end; }

	var newvar : variabile_type := get_tipo_variabile(cb_tipovar.Text);

//	rb_solo_testo.Enabled := (new_tipo in [xxFORMULA, xxVARIABILE]);
	rb_solo_testo.Enabled := (newvar in [TV_FORMULA] + TV_OLD_VARIABILI);
	rb_solo_testo.Checked := (ledit.ca.tipo_valore = VAL_TESTO);
//	rb_solo_testo.Checked := (newvar = TV_STATIC_TEXT);
	rb_numero.Enabled := rb_solo_testo.Enabled;
//	rb_numero.Checked := (ledit.ca.tipo_valore <> VAL_TESTO);
	rb_numero.Checked := NOT rb_solo_testo.Checked;

{	cbx_log_SQL.Visible := (new_tipo = xxVARIABILE) AND
		((cb_tipovar.Text = TV_DESCRIZIONE[TV_SQL_SELECT]) OR
		 (cb_tipovar.Text = TV_DESCRIZIONE[TV_SQL_SELECT_BEFORE_SQL]) OR
		 (cb_tipovar.Text = TV_DESCRIZIONE[TV_SQL_SELECT_BEFORE_RUNTIME])); }
	cbx_log_SQL.Visible := (newvar in [TV_SQL_SELECT, TV_SQL_SELECT_BEFORE_SQL, TV_SQL_SELECT_BEFORE_RUNTIME]);
	cbx_SQL_runtime_debug.Enabled := cbx_SQL_load_runtime_values.Checked;

	enable_FC(txt_datetime_format, rb_numero.Enabled AND NOT rb_numero.Checked);
	enable_FC(txt_criterio_ricalcolo, newvar in OGGETTI_CALCOLATI);

	enable_ctrls_expint;

	if cbx_attiva_traduzione.Visible then make_all_children_enabled(gbox_lingua, cbx_attiva_traduzione.Checked);
//	cbx_attiva_traduzione.Enabled := (cb_ID_lingua.Text = '');		// modo semplice per gestire lo stato del flag

	if (newvar in [TV_STATIC_TEXT, TV_PARAMETRO]) then page_object_type.ActivePage := page_text else
	if (newvar = TV_FORMULA) then page_object_type.ActivePage := page_formula
	else page_object_type.ActivePage := page_variabile;

//	panel_text.Caption := ifs(newvar = TV_STATIC_TEXT, 'nessun parametro da configurare');
	panel_text.Caption := ifs((newvar = TV_STATIC_TEXT) AND (globale.str_lingua_object = ''), 'nessun parametro da configurare');
//	visible_FC(txt_ID_lingua, (newvar = TV_STATIC_TEXT) AND (globale.str_lingua_object <> ''));
	var bo := (newvar = TV_STATIC_TEXT) AND (globale.str_lingua_object <> '');
	cbx_attiva_traduzione.Visible := bo;gbox_lingua.Visible := bo;

//	bo := (new_tipo = xxVARIABILE) AND (cb_tipovar.Text = TV_DESCRIZIONE[TV_PARAMETRO]);
//	bo := (newvar = TV_PARAMETRO);
	cbx_runtime.Visible := (newvar = TV_PARAMETRO);
	bo := cbx_runtime.Visible AND cbx_runtime.Checked;
	page_runtime.TabVisible := bo;
//	page_runtime.Highlighted := TRUE;		// quanto Visible sempre TRUE
	{$ifdef DEBUG} assert(page_runtime.Highlighted, 'page_runtime.Highlighted deve essere TRUE -- JEOO 3991'); {$endif}
	if (RTQ_type(rb_rtq.ItemIndex) in [{RTQ_SINGLE_SELECT, }RTQ_MULTI_SELECT]) then
		cbx_runtime_answer_in_valori_suggeriti.Checked := TRUE;
	enable_FC(txt_formato_multiselect, RTQ_type(rb_rtq.ItemIndex) = RTQ_MULTI_SELECT);
	cbx_runtime_answer_in_valori_suggeriti.Enabled := bo AND (RTQ_type(rb_rtq.Itemindex) in [RTQ_TEXT, RTQ_SINGLE_SELECT]);
	cbx_RTQ_select_all_answers.Enabled := bo AND (RTQ_type(rb_rtq.ItemIndex) in [RTQ_MULTI_SELECT]);
	enable_FC(txt_runtime_blank_answer, bo AND cbx_runtime_answer_can_be_blank.Checked);
	txt_runtime_answers.Caption := ' ' + ifs(cbx_SQL_load_runtime_values.Checked, 'istruz SQL selezione risposte', 'risposte suggerite');
	txt_runtime_values.Caption := ' ' + ifs(cbx_SQL_load_runtime_values.Checked, 'istruz SQL selezione codici', 'codici di risposta');
	enable_FC(txt_runtime_max_length, bo AND (RTQ_type(rb_rtq.Itemindex) = RTQ_TEXT));
	enable_FC(txt_runtime_max_lines, bo AND (RTQ_type(rb_rtq.Itemindex) = RTQ_TEXT));

	enable_FC(txt_formula_Xpos, NOT cbx_centrato.Checked);
	enable_FC(txt_formula_Xpos_type, NOT cbx_centrato.Checked);

//	txt_sfondo.Enabled := NOT cbx_trasparente.Checked;
//	enable_FC(txt_sfondo, NOT cbx_trasparente.Checked);
	visible_FC(txt_sfondo, NOT cbx_trasparente.Checked);	// meglio VISIBLE che ENABLE, altrimenti si rischia di vedere un colore di fondo che non c'entra nulla

	visible_FC(txt_runtime_path, runtime_tipodato_type(rb_runtime_tipodato.Itemindex) = RTT_FILENAME);
	btn_browse_runtime_path.Visible := txt_runtime_path.Visible;
	visible_FC(txt_runtime_filename_filter, txt_runtime_path.Visible);

	enable_FC(txt_comportamento_null, newvar in GESTIONE_NULL_TIPOVARS);
	enable_FC(txt_value_when_null, txt_comportamento_null.Enabled AND (cb_comportamento_null.ItemIndex = byte(xCWNT_USE_VALUE)));

{	enable_FC(txt_tipovar,new_tipo = xxVARIABILE);
	with cb_tipovar do enable_FC(txt_nome_colonna, Enabled AND
		((text = TV_DESCRIZIONE[TV_VARIABILE]) OR (text = TV_DESCRIZIONE[TV_GROUP_EXPR_SQL]) OR
		 (text = TV_DESCRIZIONE[TV_SQL_SELECT_BEFORE_RUNTIME]) OR (text = TV_DESCRIZIONE[TV_SQL_SELECT_BEFORE_SQL]) OR
		 (text = TV_DESCRIZIONE[TV_SQL_SELECT]))); }
	enable_FC(txt_nome_colonna, Enabled AND (newvar in [TV_DB_FIELD, TV_GROUP_EXPR_SQL, TV_SQL_SELECT_BEFORE_SQL, TV_SQL_SELECT_BEFORE_RUNTIME, TV_SQL_SELECT]));
{	str_tables_aggiuntive.Enabled := cb_tipovar.Enabled AND (cb_tipovar.Text = TV_DESCRIZIONE[TV_GROUP_EXPR_SQL]);
	txt_tables_aggiuntive.Enabled := str_tables_aggiuntive.Enabled; }
//	enable_FC(txt_esempio, new_tipo in [xxFORMULA, xxVARIABILE]);
	enable_FC(txt_esempio, newvar <> TV_STATIC_TEXT);
	if txt_nome_colonna.Enabled then txt_nome_colonna.Caption := 'F5 ' + cb_tipovar.Text;

	bo := cbx_store_variabile.Checked;
	cbx_nome_variabile_SQL.Enabled := bo;
	enable_FC(txt_nome_variabile_store, bo);
	enable_FC(txt_stoop, bo);

	enable_riduci_font;
	enable_minimum_size_auto;
	enable_insert_line_if_multiline;
	enable_interlinea;

	txt_nome.Caption := ifs(newvar = TV_STATIC_TEXT, 'testo', 'nome');
	if (newvar <> ledit.ca.tipo_variabile) then begin
		ledit.ca.tipo_variabile := newvar;
		enable_numerici;
		enable_multiline_suppress
	end;

	make_all_children_enabled(page_validazione, (newvar in VALIDATE_TIPI_VARIABILI) AND cbx_attiva_validazione.Checked);
	if cbx_attiva_validazione.Checked then begin
		enable_FC(txt_validazione_formula, validazione_type(rb_validazione.ItemIndex) = VALID_FORMULA);
//		make_all_children_enabled(gbox_contesto_anticipato, bo);
		bo := NOT cbx_validazione_always.Checked;
		cbx_validazione_elaborazione.Enabled := bo;
		cbx_validazione_print.Enabled := bo;
		cbx_validazione_mail.Enabled := bo;
		cbx_validazione_FTP.Enabled := bo;
		cbx_validazione_expint.Enabled := bo;
		cbx_validazione_XML.Enabled := bo;

		cbx_validazione_blocco_always.Enabled := cbx_errore_bloccante.Checked;
		bo := cbx_errore_bloccante.Checked AND NOT cbx_validazione_blocco_always.Checked;
		enable_FC(txt_condizione_bloccante_aggiuntiva, cbx_errore_bloccante.Checked);
		make_all_children_enabled(gbox_contesto_anticipato_blocco, cbx_errore_bloccante.Checked);
		cbx_validazione_blocco_elaborazione.Enabled := bo AND cbx_validazione_elaborazione.Checked;
		cbx_validazione_blocco_print.Enabled := bo AND cbx_validazione_print.Checked;
		cbx_validazione_blocco_mail.Enabled := bo AND cbx_validazione_mail.Checked;
		cbx_validazione_blocco_FTP.Enabled := bo AND cbx_validazione_FTP.Checked;
		cbx_validazione_blocco_expint.Enabled := bo AND cbx_validazione_expint.Checked;
		cbx_validazione_blocco_XML.Enabled := bo AND cbx_validazione_XML.Checked;

		enable_FC(txt_validazione_descrizione_field, str_validazione_message.Text = '');
		enable_FC(txt_validazione_message, str_validazione_descrizione_field.Text = '')
	end
	else if (newvar in VALIDATE_TIPI_VARIABILI) then make_all_fathers_enabled(cbx_attiva_validazione);
	page_validazione.Highlighted := cbx_attiva_validazione.Checked AND cbx_attiva_validazione.Enabled
end;

function Tlabels.is_numero : boolean;
// rende TRUE se l'oggetto è numerico
begin
{	result := FALSE;
	case ledit.tipo_oggetto of
		xxTESTO : result := FALSE;
		xxVARIABILE, xxFORMULA : result := rb_numero.Checked
	end }
//	if (ledit.tipovar <> TV_STATIC_TEXT) then result := rb_numero.Checked
	result := (ledit.ca.tipo_variabile <> TV_STATIC_TEXT) AND rb_numero.Checked
end;

procedure Tlabels.enable_multiline_suppress;
begin
//	var bo := (ledit.tipo_oggetto <> xxTESTO) AND rb_size_fissa.Checked AND NOT is_numero;
	var bo := (ledit.ca.tipo_variabile <> TV_STATIC_TEXT) AND rb_size_fissa.Checked AND NOT is_numero;
	cbx_multiline.Enabled := bo;
	cbx_multiline.Checked := bo AND cbx_multiline.Checked;
	enable_insert_line_if_multiline
//	bo := (ledit.tipo_oggetto <> TESTO) AND NOT is_numero
end;

procedure Tlabels.rb_sizeClick(Sender : TObject);
begin
	bo_something_modified := TRUE;
	enable_FC(txt_size_cm,rb_size_fissa.Checked AND NOT globale.bo_text_only);
	enable_FC(txt_size_chars,rb_size_fissa.Checked AND globale.bo_text_only);
	cbx_autoheight.Visible := rb_size_fissa.Checked;
	enable_multiline_suppress;
	enable_riduci_font;
	enable_align(rb_size_fissa.Checked)
end;

procedure TLabels.enable_align(bo_able : boolean);
begin
	rb_align.Enabled := bo_able;
	cbx_giustificato.Enabled := bo_able
end;

procedure TLabels.enable_numerici;
// abilita/disabilita le varie opzioni per i campi numerici
begin
//	bo := (ledit.tipo_oggetto in [xxFORMULA, xxVARIABILE]) AND rb_numero.Checked;
	var bo := (ledit.ca.tipo_variabile in [TV_FORMULA] + TV_OLD_VARIABILI) AND rb_numero.Checked;
	if NOT bo AND (pc.Activepage = page_formato_numero) then pc.Activepage := page_formattazione;
	page_formato_numero.Tabvisible := bo;

	enable_FC(txt_valuta,bo);
	cbx_progressivo.Enabled := bo;
	cbx_show_segno.Enabled := bo;
	cbx_valuta.Enabled := bo;
	cb_nz.Enabled := bo;

	var bo_valuta_automatica := bo AND (cb_valuta.Text <> '');
	cbx_valuta_breve.Visible := bo_valuta_automatica;
	cbx_valuta_breve.Enabled := cbx_valuta.Checked;

//	if bo_valuta_automatica then pc_round.Activepage := page_round_valuta else pc_round.Activepage := page_round_base;
	make_all_children_enabled(gbox_round_valuta, bo_valuta_automatica);
	make_all_children_enabled(gbox_round_base, NOT bo_valuta_automatica);

	bo := bo AND (cb_valuta.Text = '');
	rb_round.Enabled := bo;
//	rb_round_eccesso.Enabled := bo;rb_round_difetto.Enabled := bo;rb_round_nearest.Enabled := bo;
//	cb_round.Enabled := bo;
	make_all_children_enabled(gbox_round, bo);
	make_all_children_enabled(gbox_stampa_almeno, bo, FALSE);
//	enable_FC(txt_decimali_fissi,bo);
	enable_FC(txt_zeri,bo AND (FORMATO_NUMERICO_TYPES(cb_formato_numero.ItemIndex) in [PD,VD]));

	rb_charcase.Enabled := NOT bo;
	cb_formato_numero.Enabled := bo;

	str_simbolo_valuta.Enabled := bo AND cbx_valuta.Checked;
	rb_posizione_simbolo_valuta.Enabled := str_simbolo_valuta.Enabled;
	btn_euro.Enabled := str_simbolo_valuta.Enabled;
	btn_lire.Enabled := str_simbolo_valuta.Enabled
end;

procedure Tlabels.rb_solo_testoClick(Sender : TObject);
begin
	bo_something_modified := TRUE;
	if rb_solo_testo.Checked then ledit.ca.tipo_valore := VAL_TESTO else ledit.ca.tipo_valore := VAL_NUMERO;
	if ((ledit.ca.tipo_valore = VAL_TESTO) XOR NOT rb_numero.Checked) then rb_numero.Checked := NOT (ledit.ca.tipo_valore = VAL_TESTO);
	enable_numerici;enable_multiline_suppress
end;

procedure Tlabels.rb_numeroClick(Sender : TObject);
begin
	bo_something_modified := TRUE;
	if rb_numero.Checked then ledit.ca.tipo_valore := VAL_NUMERO else ledit.ca.tipo_valore := VAL_TESTO;
	if ((ledit.ca.tipo_valore = VAL_TESTO) XOR rb_solo_testo.Checked) then rb_solo_testo.Checked := (ledit.ca.tipo_valore = VAL_TESTO);
	enable_numerici;enable_multiline_suppress
end;

procedure TLabels.enable_suppress_blanks;
begin
	cbx_suppress_blank.Enabled := NOT (get_show_type(cb_show) in [OSW_SHOW_LAST,OSW_HIDE_LAST]); 
	if NOT cbx_suppress_blank.Enabled AND cbx_suppress_blank.Checked then begin
		MessageBBox(handle,'E'' stata disabilitata l''opzione ' +
			ACAPO2 + '"' + cbx_suppress_blank.Caption + '"' + ACAPO2 +
			'perchè incompatibile con la modalità di visualizzazione scelta',MBOX_CAPTION);
		cbx_suppress_blank.Checked := FALSE
	end
end;

procedure Tlabels.cbx_multilineClick(Sender : TObject);
begin
	bo_something_modified := TRUE;
	enable_riduci_font;
	enable_insert_line_if_multiline;
	enable_interlinea
end;

procedure Tlabels.enable_insert_line_if_multiline;
begin
	cbx_insert_if_multiline.Enabled := cbx_multiline.Checked
end;

procedure TLabels.enable_riduci_font;
begin
	var bo := {NOT cb_multiline.Checked AND }rb_size_fissa.Checked;
	if cbx_riduci_se_necessario.Checked AND NOT bo then begin
		cbx_riduci_se_necessario.Checked := FALSE;
		MessageBBox(handle,'E'' stato necessario eliminare l''opzione di riduzione automatica del font',MBOX_CAPTION)
	end;
	cbx_riduci_se_necessario.Enabled := bo
end;

procedure Tlabels.enable_minimum_size_auto;
begin
	enable_FC(txt_minimum_auto_size,cbx_riduci_se_necessario.Enabled AND cbx_riduci_se_necessario.Checked)
end;

procedure Tlabels.FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
begin
	case key of
		VK_ESCAPE: close;
		VK_F2 : pc.Activepage := page_oggetto;
		VK_F3 : pc.Activepage := page_formato;
//		VK_F4 : pc.Activepage := page_arrotondamento;
		VK_F5 : begin
			if (shift = [ssAlt]) then windowstate := wsMaximized
			 else begin
				if (pc.Activepage <> page_oggetto) then pc.Activepage := page_oggetto;
				if (page_object_type.Activepage = page_formula) AND str_formula.Enabled then str_formula.SetFocus;
				if (page_object_type.Activepage = page_variabile) AND memo_DB_colonna.Enabled then memo_DB_colonna.SetFocus
			 end
		end;
		VK_F6 : if (pc.Activepage = page_oggetto) then cb_show.SetFocus;
		VK_F7 : if page_runtime.TabVisible then pc.Activepage := page_runtime;
		VK_F8 : btn_font.Click;
		VK_F9 : btn_ok.Click;
		VK_F11 : begin
{			if (shift = []) then begin
				pc.Activepage := page_store;
				str_remarks.SetFocus
			end
			else
			if (ssCtrl in Shift) AND str_print_if.Enabled then str_print_if.SetFocus }
			if (shift = []) AND str_print_if.Enabled then str_print_if.SetFocus
		end;
		VK_F12 : begin
//			if (shift = []) then pc.Activepage := page_remarks else
			if (ssCtrl in Shift) AND str_simbolo_valuta.Enabled then btn_euro.click;
//			if (ssShift in Shift) AND str_simbolo_valuta.Enabled then btn_lire.click
		end
		else inherited
	end
end;

procedure Tlabels.btn_legamiClick(Sender : TObject); begin if legami_comunitari_proc(self, i_obj) then bo_something_modified := TRUE end;
procedure Tlabels.AAA_modified(Sender : TObject); begin bo_something_modified := TRUE end;
procedure Tlabels.cb_showChange(Sender : TObject); begin bo_something_modified := TRUE;enable_suppress_blanks end;
procedure Tlabels.cb_comportamento_nullChange(Sender : TObject); begin enable_ctrls end;
procedure Tlabels.btn_euroClick(Sender : TObject); begin bo_something_modified := TRUE;str_simbolo_valuta.Text := '€' end;
procedure Tlabels.btn_lireClick(Sender : TObject); begin bo_something_modified := TRUE;str_simbolo_valuta.Text := '£' end;
procedure Tlabels.cbx_valutaClick(Sender : TObject); begin bo_something_modified := TRUE;enable_numerici end;
procedure Tlabels.cbx_riduci_se_necessarioClick(Sender : TObject); begin bo_something_modified := TRUE;enable_minimum_size_auto end;
procedure Tlabels.cb_formato_numeroClick(Sender : TObject); begin bo_something_modified := TRUE;enable_numerici end;
procedure Tlabels.cb_tipovarChange(Sender : TObject); begin enable_ctrls end;
procedure Tlabels.enable_ctrls_Click(Sender : TObject); begin bo_something_modified := TRUE;enable_ctrls end;
procedure Tlabels.cb_valutaChange(Sender : TObject); begin bo_something_modified := TRUE;enable_numerici end;
procedure Tlabels.cbx_store_variabileClick(Sender : TObject); begin bo_something_modified := TRUE;enable_ctrls end;
procedure Tlabels.btn_help_mask_formatClick(Sender : TObject); begin call_help(MASK_FORMAT_HELP) end;
procedure Tlabels.btn_help_funzioniClick(Sender : TObject); begin call_help(HELP_FUNZIONI) end;
procedure Tlabels.btn_help_datetime_formatClick(Sender : TObject); begin call_help(HELP_DATETIME_FORMAT) end;
procedure Tlabels.btn_helpClick(Sender : TObject); begin call_help end;
procedure Tlabels.cb_exportChange(Sender : TObject); begin bo_something_modified := TRUE;enable_ctrls_expint end;
procedure Tlabels.page_object_typeChange(Sender : TObject); begin bo_something_modified := TRUE;enable_ctrls end;
procedure Tlabels.cbx_expint_only_first_lineClick(Sender : TObject); begin bo_something_modified := TRUE;enable_ctrls_expint end;
procedure Tlabels.btn_help_export_integraleClick(Sender : TObject); begin call_help(EXPORT_INTEGRALE_HELP) end;
procedure Tlabels.rb_runtime_tipodatoClick(Sender : TObject); begin bo_something_modified := TRUE;enable_ctrls end;
procedure Tlabels.i_rotazioneEnter(Sender : TObject); begin set_rotazione(TRUE) end;
procedure Tlabels.i_rotazioneExit(Sender : TObject); begin set_rotazione(FALSE) end;
procedure Tlabels.lb_expint_elencoClick(Sender : TObject); begin expint_click end;
procedure Tlabels.cbx_LCF_Click(Sender : TObject); begin update_LCF_esempio end;
procedure Tlabels.cb_LCF_foreground_colorChange(Sender : TObject); begin update_LCF_esempio end;
procedure Tlabels.btn_help_LCFClick(Sender : TObject); begin MessageBBox(handle, HELP_FONT_CONDIZIONALE, MBOX_CAPTION) end;
procedure Tlabels.cbx_IDs_lingua_selected_contextClick(Sender : TObject); begin load_lingua_items(cb_ID_lingua.Items, get_language_context_mode) end;
procedure Tlabels.cbx_attiva_validazioneClick(Sender : TObject); begin enable_ctrls end;
procedure Tlabels.rb_validazioneClick(Sender : TObject); begin enable_ctrls end;
procedure Tlabels.cbx_errore_bloccanteClick(Sender : TObject); begin enable_ctrls end;
procedure Tlabels.str_validazione_descrizione_Change(Sender : TObject); begin AAA_modified(sender);enable_ctrls end;
procedure Tlabels.str_validazione_descrizione_fieldExit(Sender : TObject); begin enable_ctrls end;
procedure Tlabels.cbx_attiva_traduzioneClick(Sender : TObject); begin enable_ctrls end;
procedure Tlabels.fl_max_vertical_sizeExit(Sender : TObject); begin enable_interlinea end;
procedure Tlabels.i_max_rowsExit(Sender : TObject); begin enable_interlinea end;

procedure Tlabels.cb_roundChange(Sender : TObject);
begin
	AAA_modified(NIL);
	if (cb_round.ItemIndex <> -1) then str_round.Text := ''
end;

procedure Tlabels.str_roundChange(Sender : TObject);
begin
	AAA_modified(NIL);
	if (str_round.Text <> '') then cb_round.ItemIndex := -1
end;

procedure Tlabels.btn_browse_runtime_pathClick(Sender : TObject);
begin
	if browse_directory(self, 'cartella ricerca file', str_runtime_path) then bo_something_modified := TRUE
end;

procedure Tlabels.enable_interlinea;
begin
	var bo := cbx_multiline.Enabled AND cbx_multiline.Checked;
	enable_FC(txt_interlinea, bo);
	enable_FC(txt_max_vertical_size, bo AND ((i_max_rows.Text = '') OR (i_max_rows.Text = '0')));
	enable_FC(txt_max_rows, bo AND ((fl_max_vertical_size.Text = '') OR (fl_max_vertical_size.Text = '0')))
end;

procedure Tlabels.call_help(str_help : string = '');
begin
	if (str_help = '') AND (pc.Activepage = page_oggetto) then str_help := HELP_OBJS_TEXT;
	if (str_help = '') AND (pc.Activepage = page_store) then str_help := VARIABILI_STATICHE_HELP;
	if (str_help = '') AND (pc.Activepage = page_runtime) then str_help := HELP_RUNTIME_PARMS;
	if (str_help = '') then MessageBBox(handle,'Nessun aiuto disponibile', MBOX_CAPTION) else help_proc(self, str_help)
end;

procedure Tlabels.panel_colorClick(Sender : TObject);
begin
	MessageBBox(handle, 'Per modificare i colori usa i bottoni TESTO e SFONDO', MBOX_CAPTION)
end;

procedure Tlabels.btn_text_colorClick(Sender : TObject);
begin
	var lo : TColor := panel_color.Font.Color;
	if select_colore(self,lo) then begin bo_something_modified := TRUE;panel_color.Font.Color := lo end
end;

procedure Tlabels.btn_back_colorClick(Sender : TObject);
begin
	var lo : TColor := panel_color.Color;
	if select_colore(self,lo) then begin bo_something_modified := TRUE;panel_color.Color := lo end
end;

procedure Tlabels.panel_fondoClick(Sender : TObject);
begin
	var col : TColor := panel_fondo.Color;
	if NOT cbx_trasparente.Checked AND select_colore(self, col) then begin
		panel_fondo.Color := col;
		bo_something_modified := TRUE
	end
end;

procedure Tlabels.btn_default_colorClick(Sender : TObject);
begin
	panel_color.Font.Color := RUNTIME_DEFAULT_TEXT_COLOR;
	panel_color.Color := RUNTIME_DEFAULT_BACK_COLOR;
	bo_something_modified := TRUE
end;

procedure Tlabels.btn_formato_defaultClick(Sender : TObject);
begin
	bo_something_modified := TRUE;
	case runtime_tipodato_type(rb_runtime_tipodato.ItemIndex) of
//		RTT_DATA : str_runtime_format.Text := ifs(cbx_runtime_answer_can_be_blank.Checked, '!99/99/99;1;_', '!99/99/00;1;_')
		RTT_DATA : str_runtime_format.Text := '!99/99/99;1;_'			// sempre facoltativa; c'è cmq il controllo su RUNTIME.PAS
		else str_runtime_format.Text := ''
	end
end;

procedure Tlabels.btn_runtime_script_insertClick(Sender : TObject);
var rst : runtime_script_type;	//*
begin
	var it := TStringList.create;
	try
		for rst := succ(RST_BLANK) to high(runtime_script_type) do it.Add(RST_FORMATO_DESCRIZIONE[rst]);
		var i : smallint := domanda_multipla_tstring(self, 'Seleziona ', 'Inserimento script', -1, it);
		if (i = -1) then exit;
		rst := runtime_script_type(i + 1);
		str_runtime_script.Text := copy(str_runtime_script.Text, 1, str_runtime_script.SelStart) + RST_FORMATO_HELP[rst] +
			copy(str_runtime_script.Text, str_runtime_script.SelStart + str_runtime_script.SelLength + 1, MAXINT);
		bo_something_modified := TRUE
	finally
		it.free
	end
end;

procedure Tlabels.set_rotazione(bo_rotazione : boolean);
begin
	bo_rotazione_editing := bo_rotazione;
	if bo_rotazione then begin
		txt_rotazione.Angle := i_rotazione.get_Asinteger(FALSE);
		txt_rotazione.FontOrientation := i_font_orientation.get_Asinteger(FALSE);
		txt_rotazione.Backcolor := clAqua
	end
	else begin
		txt_rotazione.Angle := 0;
		txt_rotazione.FontOrientation := 0;
		txt_rotazione.Backcolor := clBtnFace
	end;
	bo_something_modified := TRUE
end;

procedure Tlabels.i_rotazioneChange(Sender : TObject);
begin
	if NOT bo_rotazione_editing then exit;
	txt_rotazione.Angle := i_rotazione.get_Asinteger(FALSE);
	txt_rotazione.FontOrientation := i_font_orientation.get_Asinteger(FALSE);
	bo_something_modified := TRUE
end;

procedure Tlabels.resize_runtime_panels;
begin
	panel_runtime_answers_01.Width := panel_runtime_answers.clientWidth div 2
end;

procedure Tlabels.panel_runtime_answersResize(Sender : TObject);
begin
//	if (panel_runtime_answers_00.Width - panel_runtime_answers_01.Width / panel_runtime_answers.Width < 0.04) then
	resize_runtime_panels
end;

procedure Tlabels.expint_click;
begin
	if (i_written_expint = lb_expint_elenco.Itemindex) then exit;
	if (i_written_expint <> -1) then read_expint(i_written_expint);
	write_expint(lb_expint_elenco.ItemIndex)
end;

procedure Tlabels.enable_ctrls_expint;
begin
	var i_profilo : expint_index_type := lb_expint_elenco.ItemIndex;
	if (i_profilo = -1) then exit;
	if sections_1B(i_sezione).exportabile_integrale(i_profilo, {bo_runtime}FALSE) then begin
		make_all_children_enabled(panel_expint, object_expint_mode_type(cb_export.ItemIndex) <> OEXP_NOT);
		if panel_expint.Enabled then begin
			enable_FC(txt_expint_acapo, NOT (expint_multiline_type(cb_expint_multiline.Itemindex) in [EXPINTML_EXCEL, EXPINTML_ONLY_FIRST_LINE]));
			enable_FC(txt_expint_tab, NOT (expint_multiline_type(cb_expint_multiline.Itemindex) in [EXPINTML_EXCEL]))
		end
		else begin
			make_all_fathers_enabled(cb_export, TRUE);
			enable_FC(txt_export, TRUE)
		end
	end
	else make_all_children_enabled(panel_expint, FALSE)
end;

procedure Tlabels.read_expint(i_profilo : expint_index_type);
begin
	if (i_profilo = -1) then exit;
	var x : cl_expint_object := expint_objects[i_profilo];

	x.expint_mode := object_expint_mode_type(cb_export.ItemIndex);
	x.i_pos := i_export_pos.get_Asinteger(FALSE);
	x.str_header := str_expint_header.Text;
	x.i_skip_cols_before := i_expint_skip_cols_before.get_Asinteger(FALSE);
	x.multiline := expint_multiline_type(cb_expint_multiline.ItemIndex);

	var s := '';
	for var i : smallint := 0 to EXPINT_ACAPO_NUMERO-1 do
		if (cb_expint_acapo.Text = EXPINT_ACAPO_DESCR[i]) then begin s := EXPINT_ACAPO_VALUES[i];break end;
	x.str_acapo := coalesce(s, cb_expint_acapo.Text);

	s := '';
	for var j : smallint := 0 to EXPINT_tab_NUMERO-1 do
		if (cb_expint_tab.Text = EXPINT_tab_DESCR[j]) then begin s := EXPINT_tab_VALUES[j];break end;
	x.str_tab := coalesce(s, cb_expint_tab.Text)
end;

procedure Tlabels.write_expint(i_profilo : expint_index_type);
begin
	if (i_profilo = -1) then exit;
	i_written_expint := i_profilo;
	var x : cl_expint_object := expint_objects[i_profilo];

	cb_export.ItemIndex := byte(x.expint_mode);
	i_export_pos.set_Asinteger(x.i_pos);
	str_expint_header.Text := x.str_header;
	i_expint_skip_cols_before.set_Asinteger(x.i_skip_cols_before);
	cb_expint_multiline.ItemIndex := byte(x.multiline);

	var s := '';cb_expint_acapo.Items.clear;
	for var i : smallint := 0 to EXPINT_ACAPO_NUMERO-1 do begin
		cb_expint_acapo.Items.add(EXPINT_ACAPO_DESCR[i]);
		if (x.str_acapo = EXPINT_ACAPO_VALUES[i]) then s := EXPINT_ACAPO_DESCR[i];
	end;
	cb_expint_acapo.Text := coalesce(s, x.str_acapo);

	s := '';cb_expint_tab.Items.clear;
	for var j : smallint := 0 to EXPINT_TAB_NUMERO-1 do begin
		cb_expint_tab.Items.add(EXPINT_TAB_DESCR[j]);
		if (x.str_tab = EXPINT_TAB_VALUES[j]) then s := EXPINT_TAB_DESCR[j];
	end;
	cb_expint_tab.Text := coalesce(s, x.str_tab);

	enable_ctrls_expint
end;

procedure TLabels.update_LCF_esempio;

	procedure applica_style(cbx : TFCheckBox;fs : TFontStyle);
	begin
		case cbx.State of
			cbChecked : txt_LCF_esempio.Font.Style := txt_LCF_esempio.Font.Style + [fs];
			cbUnChecked : txt_LCF_esempio.Font.Style := txt_LCF_esempio.Font.Style - [fs]
			else
		end
	end;

begin
	txt_LCF_esempio.Font.Assign(ledit.get_font);
	applica_style(cbx_LCF_bold, fsBold);
	applica_style(cbx_LCF_underline, fsUnderline);
	applica_style(cbx_LCF_italic, fsItalic);
	applica_style(cbx_LCF_strikeout, fsStrikeout);
	txt_LCF_esempio.Font.Color := cb_LCF_foreground_color.ColorValue;
	txt_LCF_esempio.Color := coalesce(panel_LCF_background_color.Color, clBtnFace)
end;

procedure Tlabels.panel_LCF_background_colorClick(Sender : TObject);
begin
	var cl : TColor := panel_LCF_background_color.Color;
	if select_colore(self, cl) then begin
		panel_LCF_background_color.Color := cl;
		update_LCF_esempio
	end
end;

function Tlabels.get_language_context_mode : lingua_context_set;
begin
	result := [];
	if (globale.str_lingua_contesto = '') then begin
		if cbx_IDs_lingua_selected_context.Checked then result := result + [LCT_SELECTED_CONTEXT, LCT_OTHER_CONTEXTS];
		if cbx_IDs_lingua_generic_context.Checked then result := result + [LCT_GENERIC]
	end
	else begin
		result := [LCT_SELECTED_CONTEXT];
		if NOT cbx_IDs_lingua_selected_context.Checked then result := result + [LCT_OTHER_CONTEXTS];
		if cbx_IDs_lingua_generic_context.Checked then result := result + [LCT_GENERIC]
	end
end;

var bo_checking_context : boolean;

procedure Tlabels.cbx_validazione_contextClick(Sender : TObject);
var cbx : TFCheckBox absolute sender;
begin
	if bo_checking_context then exit;
	bo_checking_context := TRUE;
	try
		if (cbx = cbx_validazione_always) then begin
			if cbx.Checked then begin
				cbx_validazione_elaborazione.Checked := TRUE;
				cbx_validazione_print.Checked := TRUE;
				cbx_validazione_mail.Checked:= TRUE;
				cbx_validazione_FTP.Checked := TRUE;
				cbx_validazione_expint.Checked := TRUE;
				cbx_validazione_XML.Checked := TRUE
			end
		end
		else cbx_validazione_always.Checked := FALSE;
		enable_ctrls
	finally
		bo_checking_context := FALSE
	end
end;

procedure Tlabels.cbx_validazione_blocco_Click(Sender : TObject);
var cbx : TFCheckBox absolute sender;
begin
	if bo_checking_context then exit;
	bo_checking_context := TRUE;
	try
		if (cbx = cbx_validazione_blocco_always) then begin
			if cbx.Checked then begin
				cbx_validazione_blocco_elaborazione.Checked := TRUE;
				cbx_validazione_blocco_print.Checked := TRUE;
				cbx_validazione_blocco_mail.Checked:= TRUE;
				cbx_validazione_blocco_FTP.Checked := TRUE;
				cbx_validazione_blocco_expint.Checked := TRUE;
				cbx_validazione_blocco_XML.Checked := TRUE
			end
		end
		else cbx_validazione_blocco_always.Checked := FALSE;
		enable_ctrls
	finally
		bo_checking_context := FALSE
	end
end;

function Tlabels.IO_form_size_and_pos_custom_proc(bo_save: boolean;reg: TFRegistry): boolean;
const REG_TABINDEX = 'tabindex';
begin
	try
		if bo_save then begin
			if NOT bo_dont_set_activepage then reg.WriteInteger(REG_TABINDEX, pc.ActivePageIndex)
		end
		else begin
			if NOT bo_dont_set_activepage then begin
				var i : smallint := reg.ReadInteger(REG_TABINDEX);
				if (i >= 0) AND (i < pc.PageCount) AND pc.Pages[i].TabVisible then pc.ActivePageIndex := i
			end
		end;
		result := TRUE

	except
		result := FALSE
	end
end;

initialization
	galateo_initialization_debug('label_edit')
finalization
	galateo_finalization_debug('label_edit')
end.
