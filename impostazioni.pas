unit impostazioni;

{$ifNdef GALATEO_EXE} *** {$endif}

{$I defines}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Math, Menus, StdCtrls, ExtCtrls, ComCtrls, TabNotBk, Buttons,ActnList, Dialogs, Actions,
	FireDAC.Stan.Option,
	JvExControls, JvSpeedButton, JvExStdCtrls, JvCombobox, JvColorCombo,
	Fcommons, FBitBtn, FRedemption, FListBox, Federico,
	Gdich, printers_DX, misure, proc,
//	runtime_proc,
	FTP_proc, SMTP_proc, text_scripts, colori_proc;

procedure impostazioni_proc(father : TForm);

type
	email_info_type = array[email_address_type] of TFCheckBox;

	SQL_tab_type = object
		private
			sheet : TTabSheet;
			panel_header : TFPanel;
			txt_descrizione, txt_condizione, txt_note, txt_filename : TMyLabel;
			str_descrizione, str_condizione, str_filename : TFEdit;
			btn_filename_browse, btn_filename_reload : TFBitBtn;
			cbx_disabled_locale, cbx_disabled_remoto : TFCheckBox;
			str_text, str_note : TFMemo;
			btn_sx, btn_dx : TFBitBtn;
			cbx_transazione_separata : TFCheckBox;
			rb_isolation_level, rb_commit : TFRadioGroup;
			procedure assign_tab_index(tipo : SQL_script_type;i_script_index : byte);
			procedure copy_from(source : SQL_tab_type);
	end;
	SQL_tab_punt = ^SQL_tab_type;

	macro_tab_type = object
		private
			sheet : TTabSheet;
			panel_header : TFPanel;
			txt_descrizione, txt_note, txt_filename : TMyLabel;
			str_descrizione, str_condizione, str_filename : TFEdit;
			btn_filename_browse, btn_filename_reload : TFBitBtn;
			str_text, str_note : TFMemo;
			btn_sx, btn_dx : TFBitBtn;
			procedure assign_tab_index(tipo : macro_script_type;i_script_index : byte;str_tab_caption : string);
			function get_default_tab_caption(i_index : smallint) : string;
			procedure copy_from(source : macro_tab_type);
	end;
	macro_tab_punt = ^macro_tab_type;

	// serve a tenere traccia (e trasmettere) dei cambiamenti nel nome dei colori symbolici
	colori_symbolici_modified_type = record
		str_colore_from, str_colore_to : string
	end;

  Tdlg_impostazioni = class(TForm)
	 printer_panel: TFPanel;
	 str_printer: TLabel;
	 str_page_descr: TLabel;
	 str_printer_base: TLabel;
	 page_generale: TTabSheet;
	 tab_misure: TTabSheet;
	 tab_pagine: TTabSheet;
	 txt_pagine: TLabel;
	 btn_header: TButton;
	 btn_active_section: TButton;
	 i_pagine: TEdit;
	 txt_lab_per_row: TLabel;
	 txt_lab_per_page: TLabel;
	 txt_delta_x: TLabel;
    txt_delta_y: TLabel;
	 i_lab_per_row: TEdit;
	 i_lab_per_page: TEdit;
	 r_delta_x: TEdit;
	 r_delta_y: TEdit;
	 panel_runtime_footer: TFPanel;
	 btn_ok: TFBitBtn;
	 btn_cancel: TFBitBtn;
	 ts_SQL: TTabSheet;
	 bo_use_transaction: TCheckBox;
	 rb_commit_transaction: TRadioGroup;
    txt_stored_procs: TLabel;
	 btn_formato_stproc: TFBitBtn;
    str_stored_procs: TMemo;
	 video_setup: TButton;
	 rem: TTabSheet;
	 txt_version: TLabel;
	 btn_print_setup: TFBitBtn;
    btn_formato_pagina: TButton;
	 gbox_phisical_size: TGroupBox;
    txt_phisical_page_width: TLabel;
    txt_phisical_page_height: TLabel;
	 i_phisical_page_height: TEdit;
	 i_phisical_page_width: TEdit;
	 cbx_phisical_size: TCheckBox;
	 page_versioni: TTabSheet;
	 lb_versioni: TListBox;
    btn_delete_versioni: TFBitBtn;
	 cbx_show_index: TCheckBox;
	 cbx_create_index: TCheckBox;
	 cbx_autosize_page: TCheckBox;
	 panel_descrizione_report: TFPanel;
	 panel_remarks: TFPanel;
	 txt_remarks: TLabel;
	 str_remarks: TMemo;
	 txt_descrizione_report: TLabel;
	 str_descrizione_report: TFEdit;
	 cb_isolation: TComboBox;
	 txt_isolation: TLabel;
	 page_PDF: TTabSheet;
	 panel_pdf_name: TFPanel;
    txt_export_filename: TLabel;
	 str_export_filename: TEdit;
	 cb_tiporeport: TFCombo;
    txt_tiporeport: TMyLabel;
	 cbx_ask_conferma_stampa_definitiva: TCheckBox;
	 txt_GAPP_password_stampa_definitiva: TLabel;
	 str_password_stampa_definitiva: TFEdit;
    page_runtime: TTabSheet;
	 gb_text_only: TGroupBox;
    txt_text_only_font: TLabel;
	 txt_text_only_cpi: TLabel;
    txt_text_only_lpi: TLabel;
	 cb_text_only_font: TJvFontComboBox;
	 cb_text_only_cpi: TComboBox;
	 cb_text_only_lpi: TComboBox;
    unabled_panel: TFPanel;
	 txt_text_only_colonne: TLabel;
	 txt_righe_per_pagina: TLabel;
    i_text_only_colonne: TEdit;
	 i_text_only_righe: TEdit;
    bo_text_only_report: TCheckBox;
    txt_default_export_filepath: TLabel;
    str_default_export_filepath: TEdit;
	 btn_browse_PKL_label_00: TFBitBtn;
    pc_export: TMyPageControl;
    page_export_PDF: TTabSheet;
	 page_export_integrale: TTabSheet;
	 page_export_mail: TTabSheet;
	 txt_hint_export: TLabel;
	 cbx_overwrite: TFCheckBox;
	 panel_runtime_header: TFPanel;
    panel_runtime_body: TFPanel;
    txt_runtime: TLabel;
	 lb_runtime_gboxes: TMyListBox;
	 runtime_panel: TFPanel;
    btn_runtime_gbox_add: TFBitBtn;
	 btn_runtime_gbox_delete: TFBitBtn;
    btn_runtime_gbox_moveup: TFBitBtn;
    btn_runtime_gbox_movedown: TFBitBtn;
	 btn_help: TFBitBtn;
	 btn_runtime_gbox_modify: TFBitBtn;
	 txt_azione_after_print: TLabel;
    cb_azione_after_print: TFCombo;
	 txt_runtime_caption: TMyLabel;
	 str_runtime_caption: TFEdit;
    panel_runtime_caption_color: TFPanel;
	 cbx_runtime_save_pos_size: TFCheckBox;
	 page_opzioni: TTabSheet;
	 txt_griglia: TLabel;
	 cbx_show_griglia: TCheckBox;
	 cbx_print_bordo: TCheckBox;
    cbx_use_griglia: TCheckBox;
	 i_griglia: TEdit;
    cbx_pagina_intera: TCheckBox;
    cbx_force_font_exist: TCheckBox;
    cbx_compressed_bmp: TCheckBox;
    cbx_new_metodo_scostamento: TCheckBox;
	 txt_pwd_edit: TMyLabel;
	 txt_pwd_exec: TMyLabel;
    str_pwd_edit: TFEdit;
	 str_pwd_exec: TFEdit;
	 gbox_label_options: TFGroupBox;
	 cbx_label_registra_ultima_posizione: TFCheckBox;
	 txt_formato_label: TMyLabel;
	 cb_formato_label: TFCombo;
    txt_label_skip: TMyLabel;
    str_label_skip: TFEdit;
    btn_label_skip_default: TFBitBtn;
	 panel_expint_header: TFPanel;
	 txt_message_opening_print: TMyLabel;
	 str_message_opening_print: TFMemo;
	 gbox_documenti: TFGroupBox;
	 txt_doc_utente: TLabel;
	 str_doc_utente: TEdit;
	 btn_doc_utente_browse: TFBitBtn;
	 btn_doc_utente_open: TFBitBtn;
	 txt_technical_reference: TLabel;
	 str_technical_reference: TEdit;
	 btn_technical_reference_browse: TFBitBtn;
	 btn_technical_reference_open: TFBitBtn;
    gbox_definizione_scripts_SQL: TFGroupBox;
	 txt_SQL_scripts_early: TLabel;
	 txt_SQL_scripts_before: TLabel;
    txt_SQL_scripts_after: TLabel;
    btn_SQL_scripts_number_apply: TFBitBtn;
	 page_SQL_scripts: TTabSheet;
    pc_SQL: TFPageControl;
    txt_SQL_scripts_header: TLabel;
	 txt_SQL_scripts_footer: TLabel;
    btn_help_scripts: TFBitBtn;
	 i_SQL_scripts_early: TFEdit;
	 i_SQL_scripts_before: TFEdit;
    i_SQL_scripts_after: TFEdit;
	 panel_SQL_scripts_blank: TFPanel;
    SQLS_model: TTabSheet;
	 pc_SQLS_model: TFPageControl;
    page_SQLS_00: TTabSheet;
	 panel_SQLS_header: TFPanel;
	 txt_SQLS_descrizione_00: TMyLabel;
    str_SQLS_descrizione_00: TFEdit;
    cbx_SQLS_disabled_locale_00: TFCheckBox;
    btn_SQL_move_sheet_sx: TFBitBtn;
    btn_SQL_move_sheet_dx: TFBitBtn;
    str_SQLS_00: TMemo;
    page_FTP: TTabSheet;
	 btn_impostazioni_FTP: TFBitBtn;
	 txt_SQLS_condizione_00: TMyLabel;
	 str_SQLS_condizione_00: TFEdit;
    txt_galateo_exe: TLabel;
    cbx_FTP_conferma: TFCheckBox;
	 txt_FTP_password: TMyLabel;
    str_FTP_password: TFEdit;
	 txt_FTP_message: TMyLabel;
	 str_FTP_message: TFEdit;
    btn_FTP_default_message: TFBitBtn;
	 txt_reexecute_SQL_scripts: TLabel;
    cb_reexecute_SQL_scripts: TComboBox;
    gbox_lingua: TFGroupBox;
    txt_lingua: TMyLabel;
	 cb_lingua_object: TFCombo;
	 txt_lingua_contesto: TMyLabel;
    cb_lingua_contesto: TFCombo;
    btn_help_export_filename: TFBitBtn;
    panel_PDF_base: TFPanel;
    btn_opzioni_PDF: TFBitBtn;
	 txt_numero_copie_default: TLabel;
    i_numero_copie_default: TEdit;
    panel_log: TFPanel;
    popup_SMTP: TPopupMenu;
    itp_SMTP_gmail: TMenuItem;
	 itp_SMTP_yahoo: TMenuItem;
    N1: TMenuItem;
    itp_SMTP_default: TMenuItem;
	 N2: TMenuItem;
    itp_SMTP_feaci: TMenuItem;
    itp_SMTP_microsoft_hotmail: TMenuItem;
    pc_mail_opzioni: TFPageControl;
	 page_mail_base: TTabSheet;
    txt_subject: TMyLabel;
    txt_text: TMyLabel;
    str_subject: TFEdit;
    str_text: TFMemo;
	 cbx_address_required: TFCheckBox;
    panel_invio_automatico: TFPanel;
    txt_condizione_auto_email: TMyLabel;
    cbx_auto_email: TFCheckBox;
    str_condizione_auto_email: TFEdit;
    page_mail_modalita_invio: TTabSheet;
	 rb_modalita_mail: TRadioGroup;
	 pc_mail: TFPageControl;
	 page_mail_opzioni_generali: TTabSheet;
	 txt_SMTP_firma: TMyLabel;
    txt_SMTP_ccn: TMyLabel;
    rb_client_SMTP: TRadioGroup;
    str_SMTP_firma: TFMemo;
	 str_SMTP_ccn: TFEdit;
    page_mail_SMTP: TTabSheet;
	 gbox_SMTP: TFGroupBox;
    txt_SMTP_from: TMyLabel;
    txt_SMTP_host: TMyLabel;
    txt_SMTP_auth_ID: TMyLabel;
    txt_SMTP_password: TMyLabel;
    txt_SMTP_porta: TMyLabel;
    txt_SMTP_descrizione_mittente: TMyLabel;
    btn_modelli_SMTP: TJvSpeedButton;
    txt_SMTP_replyto: TMyLabel;
	 str_SMTP_from: TFEdit;
	 str_SMTP_host: TFEdit;
	 str_SMTP_auth_ID: TFEdit;
	 str_SMTP_password: TFEdit;
	 btn_test_SMTP: TFBitBtn;
	 cbx_SMTP_TLS: TFCheckBox;
	 cbx_SMTP_need_authentication: TFCheckBox;
	 wo_SMTP_port: TFEdit;
	 str_SMTP_descrizione_mittente: TFEdit;
	 cbx_SMTP_conferma_lettura: TFCheckBox;
	 str_SMTP_replyto: TFEdit;
	 page_mail_indirizzi_defaultx: TTabSheet;
	 page_mail_indirizzi_availablex: TTabSheet;
	 panel_mail_indirizzo_default_elenco: TFPanel;
	 txt_mail_indirizzo_default_elenco: TMyLabel;
	 cbx_mail_indirizzo_default_elenco_SQL: TFCheckBox;
	 str_mail_indirizzo_default_elenco: TFMemo;
	 panel_mail_indirizzo_default_funzionale: TFPanel;
	 cbx_mail_default_00: TFCheckBox;
	 cbx_mail_default_01: TFCheckBox;
	 cbx_mail_default_02: TFCheckBox;
	 cbx_mail_default_04: TFCheckBox;
	 cbx_mail_default_05: TFCheckBox;
	 cbx_mail_default_06: TFCheckBox;
	 cbx_mail_default_03: TFCheckBox;
	 cbx_mail_when_unique: TFCheckBox;
	 txt_mail_default: TMyLabel;
	 panel_mail_indirizzo_available_elenco: TFPanel;
	 txt_mail_indirizzi_elenco: TMyLabel;
	 cbx_mail_indirizzi_elenco_SQL: TFCheckBox;
	 str_mail_indirizzi_elenco: TFMemo;
	 panel_mail_indirizzo_elenco_funzionale: TFPanel;
	 cbx_mail_elenco_00: TFCheckBox;
	 cbx_mail_elenco_01: TFCheckBox;
	 cbx_mail_elenco_02: TFCheckBox;
	 cbx_mail_elenco_04: TFCheckBox;
	 cbx_mail_elenco_05: TFCheckBox;
	 cbx_mail_elenco_06: TFCheckBox;
	 cbx_mail_elenco_03: TFCheckBox;
	 txt_mail_default_available: TMyLabel;
    txt_mail_opzioni: TLabel;
    pc: TPageControl;
    btn_help_export: TFBitBtn;
    panel_debug_upper: TFPanel;
    panel_debug_lower: TFPanel;
    FGroupBox2: TFGroupBox;
    cbx_log_registro_eventi: TCheckBox;
    cbx_log_file: TCheckBox;
	 gbox_debug: TGroupBox;
    txt_debug_computer: TLabel;
    cbx_debug_base: TCheckBox;
    cbx_debug_full: TCheckBox;
    str_debug_computer: TFEdit;
    btn_debug_on_this_computer: TFBitBtn;
    cbx_debug_delete_everytime: TCheckBox;
	 cbx_log_parametri: TCheckBox;
    cbx_show_time_esecuzione: TCheckBox;
    gbox_debug_runtime_message: TFGroupBox;
	 cbx_exclude_runtime_message_report: TCheckBox;
	 cbx_exclude_runtime_message_computer: TCheckBox;
	 txt_system_debug: TMyLabel;
    cb_system_debug: TFCombo;
    gbox_export_options: TFGroupBox;
    cbx_export_set_default: TFCheckBox;
    cbx_export_proponi: TFCheckBox;
    cbx_export_automatic: TFCheckBox;
    txt_expint_export_filename: TLabel;
	 str_expint_export_filename: TEdit;
    cbx_SQLS_isolated_transaction_00: TFCheckBox;
    rb_SQLS_transaction_isolation_level_00: TFRadioGroup;
    rb_SQLS_transaction_commit_00: TFRadioGroup;
    btn_export_profiles: TFBitBtn;
	 cbx_export_allowed: TFCheckBox;
	 gbox_XML: TFGroupBox;
    cbx_XML_structure_debug_info: TFCheckBox;
    btn_copy_clipboard: TFBitBtn;
    panel_hidden_objects_color: TFPanel;
    split_note_01: TMySplitter;
    txt_runtime_docs_info: TMyLabel;
    txt_links_utente: TLabel;
    str_links_utente: TFMemo;
	 btn_add_link_utente: TFBitBtn;
	 MyLabel1: TMyLabel;
    image_expint_varamb_00: TImage;
    image_expint_varamb_01: TImage;
    image_expint_varamb_02: TImage;
    txt_SQLS_note_00: TMyLabel;
    str_SQLS_note_00: TFMemo;
    gbox_null_values: TFGroupBox;
    txt_comportamento_null: TMyLabel;
    cb_comportamento_null: TFCombo;
    txt_value_when_null_text: TMyLabel;
    cb_value_when_null_text: TFCombo;
    txt_value_when_null_numeric: TMyLabel;
    cb_value_when_null_numeric: TFCombo;
    btn_help_SQL_null_values: TFBitBtn;
	 gbox_formato_datetime: TFGroupBox;
    txt_datetime_format: TLabel;
	 txt_time_formats: TLabel;
    str_date_format: TEdit;
    str_time_format: TEdit;
    btn_help_datetime_format: TFBitBtn;
    btn_shell_extensions: TFBitBtn;
	 txt_GALRUN: TLabel;
    str_galrun_path: TEdit;
	 btn_galrun: TFBitBtn;
    gbox_pausa_pagina: TFGroupBox;
	 cbx_pausa_pagina: TCheckBox;
    txt_pausa_pagina_message: TMyLabel;
    str_pausa_pagina_message: TFEdit;
    txt_pausa_pagina_durata_msec: TLabel;
    i_pausa_pagina_durata_msec: TFEdit;
    txt_SMTP_header: TMyLabel;
    page_outlook: TTabSheet;
    btn_outlook_configuration: TFBitBtn;
	 txt_SQLS_filename_00: TMyLabel;
	 str_SQLS_filename_00: TFEdit;
	 btn_SQLS_filename_browse_00: TFBitBtn;
	 btn_SQLS_filename_reload_00: TFBitBtn;
	 macro_model: TTabSheet;
	 page_macro_model: TFPageControl;
	 page_macro_00: TTabSheet;
	 panel_macro_header: TFPanel;
    txt_macro_descrizione: TMyLabel;
    txt_macro_note: TMyLabel;
    txt_macro_filename: TMyLabel;
    str_macro_descrizione: TFEdit;
    btn_macro_move_sheet_sx: TFBitBtn;
    btn_macro_move_sheet_dx: TFBitBtn;
    str_macro_note: TFMemo;
    str_macro_filename: TFEdit;
    btn_macro_filename_browse: TFBitBtn;
    btn_macro_filename_reload: TFBitBtn;
    memo_macros: TMemo;
	 page_macro_scripts: TTabSheet;
    txt_header_macro: TLabel;
	 txt_macros_footer: TLabel;
    pc_macro: TFPageControl;
    gbox_macro_tabs: TFGroupBox;
    txt_macro_scripts: TLabel;
    btn_applica_macro_scripts: TFBitBtn;
    i_macro_scripts: TFEdit;
	 btn_help_macro_parametriche: TFBitBtn;
	 btn_macro_add: TFBitBtn;
    btn_macro_delete: TFBitBtn;
    AL: TActionList;
    AL_find: TAction;
    AL_find_next: TAction;
    find_dialog: TFindDialog;
    cbx_SQLS_disabled_remoto_00: TFCheckBox;
    page_colori: TTabSheet;
	 txt_header_colori_symbolici: TLabel;
	 footer_colori_symbolici: TFPanel;
	 btn_colore_symbolico_add: TFBitBtn;
	 btn_colore_symbolico_delete: TFBitBtn;
	 lb_colori_symbolici: TMyListBox;
	 AL_colore_symbolico_add: TAction;
	 AL_colore_symbolico_delete: TAction;
	 txt_colore_symbolico: TMyLabel;
	 panel_colore_symbolico: TFPanel;
	 txt_colore_symbolico_nome: TMyLabel;
	 str_colore_symbolico_nome: TFEdit;
	 btn_colore_symbolico_update: TFBitBtn;
	 AL_colore_symbolico_update: TAction;
    txt_colore_symbolico_pos: TMyLabel;
    i_colore_symbolico_pos: TFEdit;
    FBitBtn1: TFBitBtn;
    AL_colore_symbolico_sort: TAction;
    btn_help_set_mail_conto_00: TFBitBtn;
    btn_help_set_mail_conto_01: TFBitBtn;
    gbox_debug_target: TFGroupBox;
    gbox_RDEBUG: TFGroupBox;
    rb_debug_target_file: TFRadio;
    rb_debug_target_console: TFRadio;
    rb_debug_target_all: TFRadio;
    rb_Rdebug_datacopy: TFRadio;
    rb_Rdebug_pipes: TFRadio;
    rb_Rdebug_TCPIP: TFRadio;
    rb_RDebug_blank: TFRadio;
    txt_runtime_help: TLabel;
    str_runtime_help: TFMemo;
    gbox_runtime_help_format: TFGroupBox;
    panel_runtime_help_background: TFPanel;
    panel_runtime_help_align: TFPanel;
    rb_runtime_help_align_sx: TFRadio;
    rb_runtime_help_align_center: TFRadio;
    rb_runtime_help_align_dx: TFRadio;
    panel_runtime_help_example: TFPanel;
    txt_runtime_help_example: TMyLabel;
	 procedure FormCreate(Sender : TObject);
	 procedure btn_cancelClick(Sender : TObject);
	 procedure btn_okClick(Sender : TObject);
	 procedure btn_print_setupClick(Sender : TObject);
	 procedure video_setupClick(Sender : TObject);
	 procedure cbx_use_grigliaClick(Sender : TObject);
	 procedure btn_headerClick(Sender : TObject);
	 procedure btn_active_sectionClick(Sender : TObject);
	 procedure bo_text_only_reportClick(Sender : TObject);
	 procedure cb_text_only_cpiClick(Sender : TObject);
	 procedure bo_use_transactionClick(Sender : TObject);
	 procedure btn_formato_stprocClick(Sender : TObject);
	 procedure FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
	 procedure btn_help_sql_scriptsClick(Sender : TObject);
	 procedure btn_shell_extensionsClick(Sender : TObject);
	 procedure cbx_phisical_sizeClick(Sender : TObject);
	 procedure lb_versioniMeasureItem(Control: TWinControl; Index: Integer;var Height: Integer);
	 procedure btn_delete_versioniClick(Sender : TObject);
	 procedure lb_versioniKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
	 procedure cbx_create_indexClick(Sender : TObject);
	 procedure generic_enable_ctrls(Sender : TObject);
	 procedure btn_browse_PKL_label_00Click(Sender : TObject);
	 procedure btn_help_macro_parametricheClick(Sender : TObject);
	 procedure btn_opzioni_PDFClick(Sender : TObject);
	 procedure btn_galrunClick(Sender : TObject);
	 procedure cb_tiporeport_exit_CloseUp(Sender : TObject);
	 procedure cbx_ask_conferma_stampa_definitivaClick(Sender : TObject);
	 procedure btn_runtime_gbox_addClick(Sender : TObject);
	 procedure btn_runtime_gbox_deleteClick(Sender : TObject);
	 procedure btn_runtime_gbox_moveupClick(Sender : TObject);
	 procedure btn_runtime_gbox_movedownClick(Sender : TObject);
	 procedure FormDestroy(Sender : TObject);
	 procedure btn_helpClick(Sender : TObject);
	 procedure btn_runtime_gbox_modifyClick(Sender : TObject);
	 procedure lb_runtime_gboxesClick(Sender : TObject);
	 procedure lb_runtime_gboxesDblClick(Sender : TObject);
	 procedure btn_debug_on_this_computerClick(Sender : TObject);
	 procedure cbx_export_allowedClick(Sender : TObject);
	 procedure cbx_export_set_defaultClick(Sender : TObject);
	 procedure btn_help_datetime_formatClick(Sender : TObject);
	 procedure cbx_auto_emailClick(Sender : TObject);
	 procedure panel_runtime_caption_colorClick(Sender : TObject);
	 procedure FormActivate(Sender : TObject);
	 procedure FormClose(Sender : TObject;var Action : TCloseAction);
	 procedure cbx_export_proponiClick(Sender : TObject);
	 procedure btn_label_skip_defaultClick(Sender : TObject);
	 procedure cbx_mail_default_Click(Sender : TObject);
	 procedure cbx_mail_elenco_Click(Sender : TObject);
    procedure btn_export_profilesClick(Sender : TObject);
	 procedure rb_modalita_mailClick(Sender : TObject);
    procedure btn_test_SMTPClick(Sender : TObject);
	 procedure btn_doc_utente_browseClick(Sender : TObject);
	 procedure btn_doc_utente_openClick(Sender : TObject);
    procedure btn_technical_reference_browseClick(Sender : TObject);
	 procedure btn_technical_reference_openClick(Sender : TObject);
    procedure btn_SQL_scripts_number_applyClick(Sender : TObject);
	 procedure SQL_scripts_numeroChange(Sender : TObject);
    procedure btn_impostazioni_FTPClick(Sender : TObject);
    procedure cbx_FTP_confermaClick(Sender : TObject);
    procedure btn_FTP_default_messageClick(Sender : TObject);
	 procedure btn_help_export_filenameClick(Sender : TObject);
	 procedure itp_SMTP_gmailClick(Sender : TObject);
    procedure itp_SMTP_yahooClick(Sender : TObject);
	 procedure itp_SMTP_defaultClick(Sender : TObject);
	 procedure dlg_impostazioniitp_SMTP_arubaClick(Sender : TObject);
	 procedure itp_SMTP_feaciClick(Sender : TObject);
	 procedure itp_SMTP_microsoft_hotmailClick(Sender : TObject);
	 procedure btn_help_exportClick(Sender : TObject);
	 procedure btn_copy_clipboardClick(Sender : TObject);
	 procedure panel_hidden_objects_colorClick(Sender : TObject);
	 procedure btn_add_link_utenteClick(Sender : TObject);
	 procedure image_expint_varamb_00Click(Sender : TObject);
	 procedure btn_help_SQL_null_valuesClick(Sender : TObject);
	 procedure cbx_pausa_paginaClick(Sender : TObject);
	 procedure btn_outlook_configurationClick(Sender : TObject);
	 procedure btn_applica_macro_scriptsClick(Sender : TObject);
	 procedure i_macro_scriptsChange(Sender : TObject);
	 procedure str_macro_descrizione_modify(Sender : TObject);
	 procedure btn_macro_addClick(Sender : TObject);
	 procedure btn_macro_deleteClick(Sender : TObject);
	 procedure btn_macro_filename_browseClick(Sender : TObject);
	 procedure btn_macro_filename_reloadClick(Sender : TObject);
	 procedure btn_SQLS_filename_browse_00Click(Sender : TObject);
	 procedure btn_SQLS_filename_reload_00Click(Sender : TObject);
	 procedure AL_findExecute(Sender : TObject);
	 procedure AL_find_nextExecute(Sender : TObject);
	 procedure find_dialogFind(Sender : TObject);
	 procedure AL_colore_symbolico_addExecute(Sender : TObject);
	 procedure AL_colore_symbolico_deleteExecute(Sender : TObject);
	 procedure AL_colore_symbolico_updateExecute(Sender : TObject);
	 procedure panel_color_assignClick(Sender : TObject);
	 procedure lb_colori_symboliciDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
	 procedure lb_colori_symboliciClick(Sender : TObject);
	 procedure AL_colore_symbolico_sortExecute(Sender : TObject);
    procedure btn_help_set_mail_contoClick(Sender : TObject);
    procedure rb_runtime_help_align_Click(Sender: TObject);
    procedure panel_runtime_help_backgroundClick(Sender: TObject);
    procedure txt_runtime_help_exampleClick(Sender: TObject);
	private
		rgboxes : runtime_groupboxes_array;	// variabile locale che duplica GLOBAL.runtime_gboxes
		procedure runtime_gbox_edit(bo_new : boolean = FALSE);
		procedure runtime_gbox_delete;
		procedure runtime_gbox_move(bo_up : boolean);
		procedure runtime_gbox_load(i_select_index : smallint = -1);
	private
		bo_setting_stato_mail : boolean;
		cbx_email_default, cbx_email_elenco : email_info_type;
//		procedure update_stato_mail_button(btn : TFSpeedButton;vt : email_info_type);
//		procedure set_stato_mail_button(btn : TFSpeedButton;vt : email_info_type);
	private
		tm : TMisure;
//		bo_report : boolean;
		tiporeport : REPORT_TYPE;
		bo_started : boolean;		// TRUE quando la finestra è stata inizializzata
//		xmemo_scripts_pre : array[0..SQL_PRE_SCRIPTS_NUMBER-1] of TMemo;
//		xstr_descr_scrips_pre : array[0..SQL_PRE_SCRIPTS_NUMBER-1] of TFEdit;
//		memo_scripts_post : array[0..SQL_POST_SCRIPTS_NUMBER-1] of TMemo;
//		str_descr_scrips_post : array[0..SQL_POST_SCRIPTS_NUMBER-1] of TFEdit;
		bo_warning_phisical_size : boolean;
		FTP_local : cl_FTP_parms;
		modalita_invio_mail_original : galateo_send_mail_mode_type;
		local_outlook : cl_outlook;
		procedure init_printer;
		procedure enable_ctrls;
		function read_from_window : boolean;
		procedure read_SMTP_values;
		procedure write_window;
		procedure ricalcola_text_only_sizes;
		procedure set_report(tiporeport : REPORT_TYPE);
		procedure delete_versioni_selezionate;
		procedure write_versioni_salvataggio;
		procedure window_size(bo_read : boolean);
		procedure browse_documento_informativo(ctrl : TEdit;str_default_ext, str_filter : string);
		procedure open_documento_informativo(ctrl : TEdit);
		procedure set_standard_SMTP(ss : standard_SMTP_services;bo_feaci : boolean = FALSE);
		procedure copy_versioni_clipboard;
//		procedure prova;
	private		// scripts SQL -- procedure contenute in TEXT_SCRIPTS_EDIT
		i_SQL_tabs_used : smallint;												// numero delle linguette legate agli scripts SQL
		SQL_tabs : array of SQL_tab_type;										// ospita SOLAMENTE le linguette degli scripts SQL
		procedure create_and_write_SQLS_table;
		procedure applica_modifica_numero_scripts_SQL;
		procedure read_SQLS_tabs;
		procedure enable_SQLS_tabs;
		procedure cbx_SQL_script_enabledClick(Sender : TObject);
		procedure move_SQL_script(i_index, i_direzione : smallint);
		procedure btn_SQL_move_sheet_sxClick(Sender : TObject);
		procedure btn_SQL_move_sheet_dxClick(Sender : TObject);
		procedure write_SQL_script_tab(i_sheet_index : smallint;sx : text_script_record_punt);
		procedure load_file_SQL_text_script(i_sheet_index : smallint;str_filename : string);
	private		// MACROS PARAMETRICHE -- procedure contenute in TEXT_SCRIPTS_EDIT
		i_macro_tabs_used : smallint;												// numero delle linguette legate agli scripts MACRO
		macro_tabs : array of macro_tab_type;							 		// ospita SOLAMENTE le linguette degli scripts MACRO
		procedure create_and_write_macro_table;
		procedure apply_macros_tab_values(tipo : text_script_type;sx : text_script_record_punt;i_index : byte);
		procedure applica_modifica_numero_scripts_macro;
		procedure read_macro_tabs;
		procedure enable_macro_tabs;
		procedure move_macro_script(i_index, i_direzione : smallint);
		procedure btn_macro_move_sheet_sxClick(Sender : TObject);
		procedure btn_macro_move_sheet_dxClick(Sender : TObject);
		procedure delete_macro_script(i_index : smallint);
		procedure write_macro_tab(i_index : smallint;sx : text_script_record_punt);
		procedure load_file_macro_text_script(i_index : smallint;str_filename : string);
	private
		bo_writing_scripts : boolean;
		local_scripts : array[text_script_type] of cl_text_scripts;		// ospita sia SQL scripts che macros
	private
		local_table_colori_symbolici : table_colori_symbolici;			// copia di lavoro locale; viene poi eventualmente travasata su GLOBALE
		colori_symbolici_modified : array of colori_symbolici_modified_type;
		procedure write_colori_symbolici(i_select_index : smallint = -1);
		procedure colore_symbolico_add;
		procedure colore_symbolico_delete;
		procedure colore_symbolico_update;
		procedure colore_symbolico_sort;
	private
		bo_activated : boolean;
		str_find_text : string;
		function get_active_memo : TMemo;
		procedure find;
		procedure find_next;
//		procedure call_find_dialog;
		procedure execute_find(str_find_text : string);
	public
		constructor xcreate(father : TForm);
  end;

implementation

uses FAssert, FRdebug, FXStrings, FSystem_base, FStrings, FSystem, FCtrls, FCtrls_RX, FMessage, FProcs, FFile, FBrowse, FRegistry,
	help, domanda_multipla, FSQLsoft, Fdata, Ftime, WPPDFR1,
	{$ifndef DLL} sezione_edit, {$endif}
	galateo_debug, wproc, PDF_edit, sp_galateo, MyPrinter, SMTP_dialog, OUTLOOK_config_dialog, FTP_dialog, galateo_main, pages,
	//printer_select,
	sezione, functions, runtime_gbox_proc, runtime_gbox_edit, printer_imposta, expint_profilo_elenco, objects;

{$R *.DFM}

const
	EXPORT_FILENAME_HINT = 'Inserire in questa casella il nome predefinito del file da creare come output del report.' + ACAPO2 +
		'Il nome può contenere la referenziazione di VARIABILI (precedute dal $).' + ACAPO +
		'Nel caso di esportazione in formato PDF su più files (un file per pagina/ per sezione)' + ACAPO +
		'il valore considerato all''atto della sostituzione delle variabili' + ACAPO +
		'è quello riferito al primo record della pagina/sezione.' + ACAPO +
		'E'' necessario che le variabili utilizzate siano definite su CIASCUNA delle pagine/sezioni da exportare';
var
	rw : TRect;
	i_activepage : smallint;
	bo_loaded, bo_maximized : boolean;

procedure impostazioni_proc(father : TForm);
var dlg : Tdlg_impostazioni;
begin
	if NOT wx.can_open(WT_IMPOSTAZIONI, father) then exit;
	try
		set_wait_cursor(TRUE);
		dlg := Tdlg_impostazioni.xcreate(father);
		wx.register_open_window(father, dlg, WT_IMPOSTAZIONI)
	finally
		set_wait_cursor(FALSE)
	end;
//	dlg.ShowModal;dlg.Free
	dlg.Show
end;

constructor Tdlg_impostazioni.xcreate(father : TForm);
begin
	inherited create(father)
end;

procedure Tdlg_impostazioni.FormCreate(Sender : TObject);
//var i : integer;	//*
begin
	str_links_utente.Hint := PRINT_URLS_HINTS;
	cb_tiporeport.Items.Clear;
	for var t : REPORT_TYPE := low(t) to high(t) do cb_tiporeport.Items.Add(TIPOREPORT_DESCRIZIONE[t]);
	set_minimum_form_size(self);

	str_galrun_path.Text := computer_registry_data.str_galrun_path;
	runtime_groupboxes_assign(rgboxes, globale.runtime_gboxes);

	txt_system_debug.Caption := txt_system_debug.Caption + ' [' + get_computer_name + ']';
	cbx_exclude_runtime_message_computer.Caption := cbx_exclude_runtime_message_computer.Caption + ' [' + get_computer_name + ']';

	rb_modalita_mail.Items.Clear;
	for var i : byte := 0 to byte(high(galateo_send_mail_mode_type)) do rb_modalita_mail.Items.Add(GSMM_DESCRIZIONE[galateo_send_mail_mode_type(i)]);

	cb_comportamento_null.Items.Clear;
	// parto da 1 per evitare l'item CWNT_REPORT_DEFAULT
	for var i : byte := 1 to byte(high(comportamento_when_null_type)) do cb_comportamento_null.Items.Add(COMPORTAMENTO_NULL_DESCRIZIONE[comportamento_when_null_type(i)]);
	cb_value_when_null_text.Items.Text := NULL_STANDARD_VALUES_STRINGS;
	cb_value_when_null_numeric.Items.Text := NULL_STANDARD_VALUES_NUMERICI;

	cb_reexecute_SQL_scripts.Items.Clear;
	for var i : byte := 0 to byte(high(SQL_reexecute_script_options)) do
		cb_reexecute_SQL_scripts.Items.Add(SQL_REEXECUTE_SCRIPTS_DESCRIZIONE[SQL_reexecute_script_options(i)]);

	rb_client_SMTP.Hint := SMTP_PROTOCOL_HINT;
	rb_client_SMTP.Items.Clear;
	for var i : byte := 0 to byte(high(SMTP_explicit_protocol_type)) do rb_client_SMTP.Items.Add(SMTP_PROTOCOL_DESCRIZIONE[SMTP_explicit_protocol_type(i)]);

	panel_mail_indirizzo_default_funzionale.Hint := EMAIL_ADDRESS_HINT;
	panel_mail_indirizzo_elenco_funzionale.Hint := EMAIL_ADDRESS_HINT;
	for var eat : email_address_type := low(eat) to high(eat) do begin
		cbx_email_default[eat] := FindComponent('cbx_mail_default_' + zeri(byte(eat), 2)) as TFCheckBox;
		cbx_email_elenco[eat] := FindComponent('cbx_mail_elenco_' + zeri(byte(eat), 2)) as TFCheckBox;

		cbx_email_default[eat].Caption := EMAIL_ADDRESS_CAPTION[eat];
		cbx_email_default[eat].Enabled := (eat in DEFAULT_ALLOWED_EMAIL_ADDRESS_TYPE);

		cbx_email_elenco[eat].Caption := EMAIL_ADDRESS_CAPTION[eat];
		cbx_email_elenco[eat].Enabled := (eat in ELENCO_ALLOWED_EMAIL_ADDRESS_TYPE)
	end;

{	cb_export_default_target.Items.Clear;
	for i := byte(succ(EITT_DEFAULT)) to byte(high(export_integrale_target_type)) do
		cb_export_default_target.Items.Add(EITT_DESCRIZIONE[export_integrale_target_type(i)]); }

	cb_lingua_object.Items.Clear;
	for var i_page : logical_page_type := 1 to get_ultima_pagina_logica do begin
		for var i : obj_index_type := 1 to i_objs(i_page) do begin
			var x : objs_type := xobjs(i, i_page);
			if (x.ca.i_section_1B = MAIN_SECTION) AND
				(x.tipo_variabile in [TV_PARAMETRO, TV_DB_FIELD, TV_SQL_SELECT_BEFORE_SQL, TV_SQL_SELECT_BEFORE_RUNTIME, TV_SQL_SELECT, TV_FORMULA])
					then cb_lingua_object.Items.Add(x.get_name)
		end
	end;
	load_lingua_contesti_items(cb_lingua_contesto.Items);

{	cb_expint_file_writemode.Hint := FWT_HINTS;cb_expint_file_writemode.Items.Clear;
	for i := byte(succ(FWT_DEFAULT)) to byte(high(file_writemode_type)) do cb_expint_file_writemode.Items.Add(FWT_DESCR[file_writemode_type(i)]); }

	SQLS_model.TabVisible := FALSE;
	btn_SQL_move_sheet_dx.Width := btn_SQL_move_sheet_sx.Width;
	btn_SQL_move_sheet_sx.Top := 0;btn_SQL_move_sheet_dx.Top := 0;
	btn_SQL_move_sheet_sx.Left := 0;
	btn_SQL_move_sheet_dx.Left := panel_SQLS_header.ClientHeight - btn_SQL_move_sheet_dx.Width;
	btn_SQL_move_sheet_sx.Height := panel_SQLS_header.ClientHeight;btn_SQL_move_sheet_dx.Height := panel_SQLS_header.ClientHeight;
	btn_SQL_move_sheet_sx.Hint := 'sposta INDIETRO lo script nella sequenza';
	btn_SQL_move_sheet_dx.Hint := 'sposta lo script IN AVANTI nella sequenza';

	macro_model.TabVisible := FALSE;
	btn_macro_move_sheet_dx.Width := btn_macro_move_sheet_sx.Width;
	btn_macro_move_sheet_sx.Top := 0;btn_macro_move_sheet_dx.Top := 0;
	btn_macro_move_sheet_sx.Left := 0;
	btn_macro_move_sheet_dx.Left := panel_SQLS_header.ClientHeight - btn_macro_move_sheet_dx.Width;
	btn_macro_move_sheet_sx.Height := panel_macro_header.ClientHeight;btn_macro_move_sheet_dx.Height := panel_macro_header.ClientHeight;
	btn_macro_move_sheet_sx.Hint := btn_SQL_move_sheet_sx.Hint;btn_macro_move_sheet_dx.Hint := btn_SQL_move_sheet_dx.Hint;

	cbx_mail_when_unique.Caption := EMAIL_MAIN_WHEN_UNIQUE_CAPTION;
	cbx_mail_when_unique.Hint := EMAIL_MAIN_WHEN_UNIQUE_HINT;

	txt_export_filename.Hint := EXPORT_FILENAME_HINT;
	str_export_filename.Hint := EXPORT_FILENAME_HINT;
	btn_help_export_filename.Hint := EXPORT_FILENAME_HINT;

//	page_versioni.TabVisible := globale.bo_federico_signed;
//	btn_delete_versioni.Enabled := globale.bo_federico_signed;
	txt_version.Caption := 'versione report: ' + version_of(globale.wo_versione_read) +
		' [' + ifs(globale.wo_versione_read = GALATEO_VERSION, 'up to date', 'attuale: ' + version_of(GALATEO_VERSION)) + ']';
	txt_galateo_exe.Caption := paramstr(0) + ' ' + BITNESS + ' ' + asstring_datetime(get_file_datetime(paramstr(0)), {bo_short_date}FALSE, TMFMT_HM);

//	visible_FC(txt_email,NOT bo_printing);
//	cbx_address_required.Visible := NOT bo_printing;

	for var i : byte := 0 to byte(high(azione_after_print_type)) do
		cb_azione_after_print.Items.Add(AAPT_DESCRIZIONE[azione_after_print_type(i)]);

	with str_printer_base do begin left := 0;width := printer_panel.Width end;
	with str_printer do begin left := 0;width := printer_panel.Width end;
	with str_page_descr do begin left := 0;width := printer_panel.Width end;

	page_SQLS_00.Visible := FALSE;page_SQLS_00.TabVisible := FALSE;

	for var sxt : text_script_type := low(sxt) to high(sxt) do local_scripts[sxt] := cl_text_scripts.Create(globale.Text_scripts[sxt]);
	create_and_write_SQLS_table;
	create_and_write_macro_table;

	FTP_local := cl_FTP_parms.create(globale.FTP_parms);
	local_outlook := cl_outlook.create(static_OUTLOOK);

	local_table_colori_symbolici.assign(globale.table_colori_symbolici);

	tm := TMisure.create;tm.xassign(misure.tm);
	init_printer;
	write_window;

	pc_mail.ActivePage.Highlighted := FALSE;
{	if (globale.modalita_invio_mail = GSMM_OUTLOOK) then pc_mail.ActivePage := page_outlook
	else if (globale.modalita_invio_mail = GSMM_LOCAL_SMTP) then pc_mail.ActivePage := page_mail_SMTP
	else pc_mail.ActivePage := page_mail_opzioni_generali; }
	modalita_invio_mail_original := globale.modalita_invio_mail;
	case globale.modalita_invio_mail of
		GSMM_OUTLOOK : pc_mail.ActivePage := page_outlook;
		GSMM_LOCAL_SMTP : pc_mail.ActivePage := page_mail_SMTP;
		else pc_mail.ActivePage := page_mail_opzioni_generali
	end;
	pc_mail.ActivePage.Highlighted := TRUE;

	bo_started := TRUE;
	enable_ctrls
end;

procedure Tdlg_impostazioni.FormActivate(Sender : TObject);
begin
	if bo_activated then exit;
	try
		pc.ActivePageIndex := globale.i_impostazioni_pageindex;
		pc_SQL.ActivePageIndex := globale.i_impostazioni_SQLscripts_pageindex;
		pc_macro.ActivePageIndex := globale.i_impostazioni_macro_scripts_pageindex;
		pc_macro.Pages[globale.i_impostazioni_macro_scripts_pageindex].Highlighted := TRUE;
		pc_export.ActivePageIndex := globale.i_impostazioni_export_pageindex;
		pc_mail_opzioni.ActivePageIndex := globale.i_impostazioni_mail_pageindex;
		pc_mail_opzioni.ActivePage.Highlighted := TRUE		// non dovrebbe essere necessario, ma ...
	except
	end;
	window_size(TRUE);
	bo_activated := TRUE
end;

procedure Tdlg_impostazioni.FormClose(Sender : TObject;var Action : TCloseAction);
begin
	globale.i_impostazioni_pageindex := pc.ActivePageIndex;
	globale.i_impostazioni_SQLscripts_pageindex := pc_SQL.ActivePageIndex;
	globale.i_impostazioni_macro_scripts_pageindex := pc_macro.ActivePageIndex;
	globale.i_impostazioni_export_pageindex := pc_export.ActivePageIndex;
	globale.i_impostazioni_mail_pageindex := pc_mail_opzioni.ActivePageIndex;
	window_size(FALSE);
	Action := caFree
end;

procedure Tdlg_impostazioni.FormDestroy(Sender : TObject);
begin
	if (FTP_local <> NIL) then begin FTP_local.free;FTP_local := NIL end;
	if (local_outlook <> NIL) then begin local_outlook.free;local_outlook := NIL end;
	for var sxt : text_script_type := low(sxt) to high(sxt) do
		if (local_scripts[sxt] <> NIL) then begin local_scripts[sxt].free;local_scripts[sxt] := NIL end;
	runtime_groupboxes_free(rgboxes);
	wx.register_close_window(self)
end;

procedure Tdlg_impostazioni.write_window;
var i : smallint;	//*
begin
	i_lab_per_row.Text := tm.i_lab_per_row.Tostring;
	i_lab_per_page.Text := tm.i_lab_per_page.Tostring;
	r_delta_x.Text := strid(tm.r_delta_labs_X_cm,0,0);
	r_delta_y.Text := strid(tm.r_delta_labs_Y_cm,0,0);
	cbx_show_griglia.Checked := tm.bo_show_griglia;
	cbx_print_bordo.Checked := tm.bo_print_bordo;
	cbx_pagina_intera.Checked := tm.bo_print_pagina_completa;
	cbx_force_font_exist.Checked := globale.bo_force_font_exist;
	str_default_export_filepath.Text := globale.str_default_export_filepath;
	write_versioni_salvataggio;
	cbx_show_index.Checked := globale.bo_show_index;
	cbx_create_index.Checked := globale.bo_create_index;
	cbx_autosize_page.Checked := globale.bo_autosize_page;
	str_descrizione_report.Text := globale.str_descrizione_report;
	str_runtime_help.Text := globale.str_runtime_help;
	globale.runtime_help_font.apply_to(txt_runtime_help_example);
	case globale.runtime_help_font.align of
		taLeftJustify : rb_runtime_help_align_sx.Checked := TRUE;
		taRightJustify : rb_runtime_help_align_dx.Checked := TRUE;
//		taCenter rb_runtime_help_align_center.Checked := TRUE;
		else rb_runtime_help_align_center.Checked := TRUE
	end;

	str_message_opening_print.Text := globale.str_message_opening_print;

	cbx_exclude_runtime_message_report.Checked := globale.bo_exclude_runtime_message_report;
	cbx_exclude_runtime_message_computer.Checked := computer_registry_data.bo_exclude_runtime_message_computer;
	panel_hidden_objects_color.Font.Color := computer_registry_data.lo_hidden_objects_color;

	cb_comportamento_null.ItemIndex := byte(globale.comportamento_when_null) - 1;		// -1 perchè non esiste l'item ZERO (CWNT_REPORT_DEFAULT)
	cb_value_when_null_text.Text := globale.str_value_when_null_text;
	cb_value_when_null_numeric.Text := globale.str_value_when_null_numeric;

	case globale.box_new_valutazione_scostamento of
		XFALSE : cbx_new_metodo_scostamento.State := cbUnChecked;
		XTRUE : cbx_new_metodo_scostamento.State := cbChecked
		else cbx_new_metodo_scostamento.State := cbGrayed
	end;
	cbx_pausa_pagina.Checked := globale.bo_pausa_pagina;
	str_pausa_pagina_message.Text := globale.str_pausa_pagina_message;
	i_pausa_pagina_durata_msec.set_Asinteger(globale.i_durata_pausa_pagina_msec);

	str_pwd_edit.Text := globale.str_password_edit;
	str_pwd_exec.Text := globale.str_password_exec;
	cb_select(cb_lingua_object, globale.str_lingua_object);
	cb_select(cb_lingua_contesto, globale.str_lingua_contesto);

	i_numero_copie_default.Text := globale.i_numero_copie_default.Tostring;
//	i_jpeg_compression_quality.Text := globale.i_jpeg_compression_quality.Tostring;
//	i_jpeg_percentuale.Text := globale.i_jpeg_percentuale.Tostring;
	i_phisical_page_width.Text := globale.i_forced_width_10mm.Tostring;
	i_phisical_page_height.Text := globale.i_forced_height_10mm.Tostring;
	make_all_children_enabled(gbox_phisical_size, FALSE, FALSE);
	cbx_compressed_bmp.Checked := globale.bo_use_compressed_bmps;
	cbx_log_parametri.Checked := globale.bo_log_parametri;
	cbx_show_time_esecuzione.Checked := globale.bo_show_time_esecuzione;

	if (computer_registry_data.debug_target = DEBUG_TARG_CONSOLE) then rb_debug_target_console.Checked := TRUE else
	if (computer_registry_data.debug_target = DEBUG_TARG_BOTH) then rb_debug_target_all.Checked := TRUE else
	{if (computer_registry_data.debug_target = DEBUG_TARG_FILE) then} rb_debug_target_file.Checked := TRUE;

	if (computer_registry_data.RDEBUG_mode = RDB_PIPES) then rb_Rdebug_pipes.Checked := TRUE else
	if (computer_registry_data.RDEBUG_mode = RDB_TCPIP) then rb_Rdebug_TCPIP.Checked := TRUE else
	if (computer_registry_data.RDEBUG_mode = RDB_DATACOPY) then rb_Rdebug_datacopy.Checked := TRUE
	else rb_RDebug_blank.Checked := TRUE;

//	memo_macros.Text := globale.str_macro_parametriche;
//	page_macro_scripts.Highlighted := (globale.str_macro_parametriche <> '');
	page_macro_scripts.Highlighted := (globale.Text_scripts[TST_MACRO_PARAMETRICHE].recs[0].str_text <> '');
	page_runtime.HighLighted := (length(globale.runtime_gboxes) > 1);		// se = 1 non riveste alcun interesse pratico

	str_doc_utente.Text := globale.str_documento_informativo_utente;
	str_technical_reference.Text := globale.str_technical_reference;
	str_links_utente.Text := globale.str_links_utente;

	i_pagine.Text := globale.i_pagine_logiche.Tostring;
	i_griglia.Text := globale.i_griglia_vtabs.Tostring;
	i_griglia.Enabled := globale.bo_griglia_vtabs AND NOT globale.bo_text_only;
	cbx_use_griglia.Checked := globale.bo_griglia_vtabs;
	cbx_use_griglia.Enabled := NOT globale.bo_text_only;
//	pc.Activepage := pc.pages[0];
	str_remarks.lines.assign(globale.tstr_remarks);
//	set_report(globale.bo_report);
	set_report(globale.tiporeport);
	btn_active_section.Enabled := (get_section_attiva_1B <> 0);
	btn_header.Enabled := (get_num_sections > 0);

	bo_text_only_report.Checked := globale.bo_text_only;
	cb_text_only_font.Text := globale.Text_only_font.name;

	cbx_XML_structure_debug_info.Checked := globale.bo_XML_structure_debug_info;

	cbx_export_allowed.Checked := globale.bo_export_allowed;
	cbx_export_set_default.Checked := globale.bo_export_set_default;
	cbx_export_proponi.Checked := globale.bo_export_proponi;
	cbx_export_automatic.Checked := globale.bo_export_execute_automatically;
//	cb_export_default_target.Itemindex := byte(globale.expint_default_target) - 1;
//	cb_expint_file_writemode.Itemindex := byte(globale.export_default_file_writemode) - 1;

	cb_azione_after_print.Itemindex := byte(globale.azione_after_print);
	str_runtime_caption.Text := globale.str_runtime_parms_caption;
	panel_runtime_caption_color.Font.Color := globale.lo_foreground_parms_caption_color;
	panel_runtime_caption_color.Color := globale.lo_background_parms_caption_color;
	cbx_runtime_save_pos_size.Checked := globale.bo_allow_saving_runtime_pos;

	rb_modalita_mail.ItemIndex := byte(globale.modalita_invio_mail);
//	wo_port := reg.readint(1, 25);
	str_SMTP_host.Text := registry_SMTP.data.str_host;
	wo_SMTP_port.Text := registry_SMTP.data.wo_port.Tostring;
	str_SMTP_from.Text := registry_SMTP.data.str_from;
	str_SMTP_auth_ID.Text := registry_SMTP.data.str_auth_ID;
	str_SMTP_password.Text := registry_SMTP.data.str_auth_pwd;
	str_SMTP_ccn.Text := registry_SMTP.str_CCN;
	str_SMTP_firma.Text := registry_SMTP.str_firma;
	cbx_SMTP_TLS.Checked := registry_SMTP.data.bo_use_TLS;
	cbx_SMTP_need_authentication.Checked := registry_SMTP.data.bo_need_authentication;
	rb_client_SMTP.Itemindex := byte(registry_SMTP.mail_client_setup.SMTP_protocol);
	str_SMTP_descrizione_mittente.Text := registry_SMTP.data.str_mittente_descrizione;
	cbx_SMTP_conferma_lettura.Checked := registry_SMTP.data.bo_conferma_lettura;
	str_SMTP_replyto.Text := registry_SMTP.data.str_reply_to;

	write_colori_symbolici;

	with cb_text_only_cpi do begin
		Itemindex := items.Indexof(globale.Text_only_font.size.Tostring);
		if (Itemindex = -1) then Itemindex := items.Indexof(TEXT_ONLY_SIZE_DEFAULT.Tostring)
	end;

	with cb_text_only_lpi do begin
		Itemindex := items.Indexof(globale.i_text_only_lpi.Tostring);
		if (itemindex = -1) then itemindex := items.indexof(TEXT_ONLY_LPI_DEFAULT.Tostring)
	end;

	i_text_only_righe.Text := globale.i_text_only_righe.Tostring;
	i_text_only_colonne.Text := globale.i_text_only_colonne.Tostring;

	cb_reexecute_SQL_scripts.ItemIndex := byte(globale.SQL_reexecute_scripts);

(*	var bo := FALSE;
	for i := 0 to SQL_PRE_SCRIPTS_NUMBER-1 do begin
		xmemo_scripts_pre[i] := FindComponent('memo_sql_pre_' + zeri(i,2)) as TMemo;
		xmemo_scripts_pre[i].Font.Name := 'Courier New';
		xmemo_scripts_pre[i].Font.Size := 10;xmemo_scripts_pre[i].Font.Style := [];
		xstr_descr_scrips_pre[i] := FindComponent('str_SQL_script_descr_' + zeri(i,2)) as TFEdit;
//		memo_scripts_pre[i].lines.assign(globale.tsql_scripts_pre[i]);
		xmemo_scripts_pre[i].lines.Text := globale.str_scripts_pre[i];
		xstr_descr_scrips_pre[i].Text := globale.str_scripts_pre_descr[i];
		if (i = 0) then cbx_early_script.Checked := (globale.str_scripts_pre[i] <> '');

		pc_stored_procs.pages[i].highlighted := (globale.str_scripts_pre[i] <> '');
		bo := bo OR pc_stored_procs.pages[i].highlighted
	end; *)

//	memo_SQL_remarks.Text := globale.str_script_remarks;
//	page_SQL_remarks.Highlighted := (globale.str_script_remarks <> '');
	str_date_format.Text := globale.str_default_date_format;
	str_time_format.Text := globale.str_default_time_format;

	cbx_address_required.Checked := globale.bo_address_required;
	str_subject.Text := globale.str_subject;
	str_text.Text := globale.str_text;
	cbx_auto_email.Checked := globale.bo_auto_email;
	str_condizione_auto_email.Text := globale.str_condizione_auto_email;

	for var eat : email_address_type := low(eat) to high(eat) do begin
		if (eat in globale.indirizzi_email_default) then cbx_email_default[eat].Checked := TRUE;
		if (eat in globale.indirizzi_email_elenco) then cbx_email_elenco[eat].Checked := TRUE
	end;
	cbx_mail_when_unique.Checked := globale.bo_load_indirizzo_main_when_unique;
//	update_stato_mail_button(btn_mail_default_all, cbx_email_default);
//	update_stato_mail_button(btn_mail_elenco_all, cbx_email_elenco);

	str_mail_indirizzo_default_elenco.Text := globale.str_indirizzi_email_default_internal;
	str_mail_indirizzi_elenco.Text := globale.str_indirizzi_email_elenco_internal;
	cbx_mail_indirizzo_default_elenco_SQL.Checked := globale.bo_indirizzi_email_default_SQL;
	cbx_mail_indirizzi_elenco_SQL.Checked := globale.bo_indirizzi_email_elenco_SQL;

(*	for i := 0 to SQL_POST_SCRIPTS_NUMBER-1 do begin
		memo_scripts_post[i] := FindComponent('memo_sql_post_' + zeri(i,2)) as TMemo;
		str_descr_scrips_post[i] := FindComponent('str_SQL_script_post_descr_' + zeri(i,2)) as TFEdit;
//		memo_scripts_post[i].lines.assign(globale.tsql_scripts_post[i]);
		memo_scripts_post[i].lines.Text := globale.str_scripts_post[i];
		str_descr_scrips_post[i].Text := globale.str_scripts_post_descr[i];
//		pc_stored_procs.pages[i+SQL_PRE_SCRIPTS_NUMBER+1].highlighted := (globale.str_scripts_post[i] <> '');
//		bo := bo OR pc_stored_procs.pages[i+SQL_PRE_SCRIPTS_NUMBER+1].highlighted
	end; *)
//	page_sql.Highlighted := bo;
	str_stored_procs.lines.assign(globale.tsql_stored_procs_definition);
//	if NOT cbx_early_script.Checked then pc_stored_procs.Activepage := sql_stored_proc_01;

	bo_use_transaction.Checked := globale.bo_use_transaction;
	case globale.isolation_level of
		xiReadCommitted : i := 1;
		xiRepeatableRead : i := 2
		else i := 0		// tiDirtyRead
	end;
	cb_isolation.Itemindex := i;

//	if globale.bo_commit_transaction then rb_commit_transaction.Itemindex := 0 else rb_commit_transaction.Itemindex := 1;
	rb_commit_transaction.Itemindex := byte(NOT globale.bo_commit_transaction);

	cbx_log_registro_eventi.Checked := globale.bo_log_registro_eventi;
	cbx_log_file.Checked := globale.bo_log_file;
	cbx_debug_base.Checked := globale.bo_debug_base;
	cbx_debug_full.Checked := globale.bo_debug_full;
	cbx_debug_delete_everytime.Checked := globale.bo_debug_delete_everytime;
	str_debug_computer.Text := globale.str_debug_computer;
	str_export_filename.Text := globale.str_export_filename;
	str_expint_export_filename.Text := globale.str_expint_export_filename;
//	str_struttura_XML.Text := globale.str_struttura_XML;
	cbx_overwrite.Checked := globale.bo_overwrite_file;
	cb_system_debug.Itemindex := computer_registry_data.i_DLL_system_debug_level;

	cb_formato_label.Text := globale.str_formato_label;
	cbx_label_registra_ultima_posizione.Checked := globale.bo_label_registra_ultima_posizione;
	str_label_skip.Text := globale.str_label_skip;

	cbx_ask_conferma_stampa_definitiva.Checked := globale.bo_GAPP_ask_conferma_stampa_definitiva;
	str_password_stampa_definitiva.Text := globale.str_GAPP_password_stampa_definitiva;
//	if () then str_password_stampa_definitiva.PasswordChar := #0;

	i_SQL_scripts_early.set_Asinteger(globale.Text_scripts[TST_SQLS_EARLY].i_numero);
	i_SQL_scripts_before.set_Asinteger(globale.Text_scripts[TST_SQLS_BEFORE].i_numero);
	i_SQL_scripts_after.set_Asinteger(globale.Text_scripts[TST_SQLS_AFTER].i_numero);
	i_macro_scripts.set_Asinteger(globale.Text_scripts[TST_MACRO_PARAMETRICHE].i_numero);

	runtime_gbox_load;

	cbx_FTP_conferma.Checked := globale.bo_FTP_conferma;
	str_FTP_password.Text := globale.str_FTP_password;
	str_FTP_message.Text := globale.str_FTP_message;

	enable_ctrls
end;

function Tdlg_impostazioni.read_from_window : boolean;

	procedure apply_hidden_color;
	begin
		for var i_page : logical_page_type := 1 to get_ultima_pagina_logica do begin
			for var i_obj : obj_index_type := 1 to i_objs(i_page) do begin
				var x : objs_type := xobjs(i_obj, i_page);
				if (x.get_show_state <> OSW_HIDE) then continue;
				case x.tipo_oggetto of
					LABEL_OBJ : x.aslabel.fontcolor := computer_registry_data.lo_hidden_objects_color;
					OBJ_BITMAP : ;						// nulla da fare
					OBJ_RECT, OBJ_LINE : ;			// riassegnato automaticamente in fase di ridisegno
					DATAMATRIX_OBJ : x.asdatamatrix.forecolor := computer_registry_data.lo_hidden_objects_color;
					{$ifdef DEBUG} else assert(FALSE, 'EROR 4021') {$endif}
				end
			end
		end
	end;

const PROVA_FONT = 'abcABC';
var i, j : integer;	//*
begin
	// controlli preventivi
{	if (pos('.',str_default_image_filename.Text) <> 0) then begin
		pc.Activepage := collegamenti_page;
		MessageBBox(handle,'Indicare il nome del file senza inserire l''estensione',gbox_export.Caption);
		str_default_image_filename.SetFocus;exit
	end; }

	result := FALSE;
	set_global_modified;	// a scanso di equivoci
	var printer : TFPrinter := NIL;
	try
//		tm.r_marg_sx_cm := leggi_text_real(handle,r_marg_sx,0,20,'margine sinistro pagina',tm.r_marg_sx_cm);
//		tm.r_marg_up_cm := leggi_text_real(handle,r_marg_up,0,20,'margine superiore pagina',tm.r_marg_up_cm);
//		tm.r_labsize_x_cm := leggi_text_real(handle,r_size_x,0.5,50,'Dimensione orizzontale etichetta',tm.r_labsize_x_cm);
//		tm.r_labsize_y_cm := leggi_text_real(handle,r_size_y,0.25,50,'Dimensione verticale etichetta',tm.r_labsize_y_cm);

		tm.i_lab_per_row := leggi_text_integer(handle, i_lab_per_row, 1, 20, 'Numero di etichette per pagina (larghezza)', tm.i_lab_per_row);
		tm.i_lab_per_page := leggi_text_integer(handle, i_lab_per_page, 1, 20, 'Numero di etichette per pagina (altezza)', tm.i_lab_per_page);
		tm.r_delta_labs_X_cm := leggi_text_real(handle, r_delta_x, 0, 10, 'Distanza orizzontale tra etichette', tm.r_delta_labs_X_cm);
		tm.r_delta_labs_Y_cm := leggi_text_real(handle, r_delta_y, 0, 10, 'Distanza verticale tra etichette', tm.r_delta_labs_Y_cm);

		globale.bo_griglia_vtabs := cbx_use_griglia.Checked;
		globale.i_griglia_vtabs := leggi_text_integer(handle, i_griglia, 1, 99, 'Dimensione maglia griglia di allineamento', globale.i_griglia_vtabs);

		tm.bo_show_griglia := cbx_show_griglia.Checked;
		tm.bo_print_bordo := cbx_print_bordo.Checked;
		tm.bo_print_pagina_completa := cbx_pagina_intera.Checked;
		misure.tm.xassign(tm);
//		globale.bo_report := bo_report;tm.set_report(bo_report);
		globale.tiporeport := tiporeport;tm.set_report(tiporeport);

//		globale.str_default_image_filename := str_default_image_filename.Text;
		globale.str_default_export_filepath := togliblanks(str_default_export_filepath.Text);
		// non faccio ulteriori controlli di esistenza sul path, perchè non necessariamente varrebbero in fase di esecuzione
		if (globale.str_default_export_filepath <> '') AND
			(globale.str_default_export_filepath[length(globale.str_default_export_filepath)] <> '\')
				then globale.str_default_export_filepath := globale.str_default_export_filepath + '\';

		globale.bo_XML_structure_debug_info := cbx_XML_structure_debug_info.Checked;

		globale.bo_export_allowed := cbx_export_allowed.Checked;
		globale.bo_export_set_default := cbx_export_set_default.Enabled AND cbx_export_set_default.Checked;
		globale.bo_export_proponi := cbx_export_proponi.Enabled AND cbx_export_proponi.Checked;
		globale.bo_export_execute_automatically := cbx_export_automatic.Enabled AND cbx_export_automatic.Checked;
//		globale.expint_default_target := export_integrale_target_type(cb_export_default_target.Itemindex + 1);
//		globale.export_default_file_writemode := file_writemode_type(cb_expint_file_writemode.Itemindex + 1);

		globale.azione_after_print := azione_after_print_type(cb_azione_after_print.Itemindex);
		globale.str_runtime_parms_caption := str_runtime_caption.Text;
		globale.str_message_opening_print := str_message_opening_print.Text;

		globale.bo_exclude_runtime_message_report := cbx_exclude_runtime_message_report.Checked;
		computer_registry_data.bo_exclude_runtime_message_computer := cbx_exclude_runtime_message_computer.Checked;
		if (computer_registry_data.lo_hidden_objects_color <> panel_hidden_objects_color.Font.Color) then begin
			computer_registry_data.lo_hidden_objects_color := panel_hidden_objects_color.Font.Color;
			apply_hidden_color
		end;

		globale.str_documento_informativo_utente := str_doc_utente.Text;
		globale.str_technical_reference := str_technical_reference.Text;
		globale.str_links_utente := str_links_utente.Text;
		for i := 0 to str_links_utente.Lines.Count -1 do begin
			if NOT check_link_utente(str_links_utente.Lines[i]) then begin
				MessageBBox(handle, 'Links utente: errore di formato alla riga ' + (i+1).Tostring, MBOX_CAPTION, MB_ICONSTOP);
				break
			end
		end;

		globale.comportamento_when_null := comportamento_when_null_type(cb_comportamento_null.ItemIndex + 1);		// -1 perchè non esiste l'item ZERO (CWNT_REPORT_DEFAULT)
		globale.str_value_when_null_text := cb_value_when_null_text.Text;
		globale.str_value_when_null_numeric := cb_value_when_null_numeric.Text;

		globale.bo_text_only := bo_text_only_report.Checked;
		ricalcola_text_only_sizes;
		globale.Text_only_font.name := cb_text_only_font.Text;
{		globale.Text_only_font.size := leggi_text_integer(handle,i_text_only_size,1,20,'Dimensione testo',
			globale.Text_only_font.size); }
		IVal(cb_text_only_cpi.Text, i, j);globale.Text_only_font.Size := i;
		// determino il CPI del font selezionato
		with canvas.font do begin
			assign(globale.Text_only_font);
			globale.i_text_only_cpi := round(tm.r_pixel_per_inch_video_x / (canvas.TextWidth(PROVA_FONT) / length(PROVA_FONT)))
		end;
		IVal(cb_text_only_lpi.Text, i, j);globale.i_text_only_lpi := i;
{		globale.i_text_only_righe := leggi_text_integer(handle,i_text_only_righe,1,MAX_LINES_PER_PRINT_PAGE,
			'Righe per ''solo testo''',globale.i_text_only_righe);
		globale.i_text_only_colonne := leggi_text_integer(handle,i_text_only_colonne,1,MAX_COLUMNS_PER_PRINT_PAGE,
			'Colonne per ''solo testo''',globale.i_text_only_colonne); }
		globale.i_text_only_righe := trunc(cm2inches(get_Vpage_size_Y_cm(get_pagina_logica_attiva_1B)) * globale.i_text_only_lpi);

		try
			printer := TFPrinter.create;
//			bo := misure.tm.verify_page_size(handle,printer);
			var bo := verify_page_size(get_pagina_logica_attiva_1B, handle, printer);
			if NOT bo then exit
		finally
			printer.free
		end;

		globale.bo_force_font_exist := cbx_force_font_exist.Checked;

//		sections(MAIN_SECTION).r_y_sezione_cm := get_Vpage_size_Y_cm(get_pagina_logica_attiva);
//		sections(MAIN_SECTION).r_y_gruppo_cm := sections(MAIN_SECTION).r_y_sezione_cm; *
//		set_PHpage_size_Y_cm(get_Vpage_size_Y_cm(get_pagina_logica_attiva);	**

		if (globale.str_password_edit <> str_pwd_edit.Text) then globale.str_password_edit := ifs(str_pwd_edit.Text, asym_password(str_pwd_edit.Text));
		if (globale.str_password_exec <> str_pwd_exec.Text) then globale.str_password_exec := ifs(str_pwd_exec.Text, asym_password(str_pwd_exec.Text));
		globale.str_lingua_object := cb_lingua_object.Text;
		globale.str_lingua_contesto := cb_lingua_contesto.Text;

		globale.i_pagine_logiche := leggi_text_integer(handle, i_pagine, 1, MAX_PAGINE_LOGICHE, 'N° pagine logiche del report', globale.i_pagine_logiche);
		globale.i_numero_copie_default := leggi_text_integer(handle, i_numero_copie_default, 1, 99, 'N° di copie default', globale.i_numero_copie_default);
		globale.bo_create_index := cbx_create_index.Checked;
		globale.bo_autosize_page := cbx_autosize_page.Checked;
		globale.str_descrizione_report := str_descrizione_report.Text;
		globale.str_runtime_help := str_runtime_help.Text;
		globale.runtime_help_font.read_from(txt_runtime_help_example);
		globale.bo_show_index := globale.bo_create_index AND cbx_show_index.Checked;
//		globale.bo_new_valutazione_scostamento := NOT cbx_old_metodo_scostamento.Checked;
		case cbx_new_metodo_scostamento.State of
			cbChecked : globale.box_new_valutazione_scostamento := XTRUE;
			cbUnChecked : globale.box_new_valutazione_scostamento := XFALSE;
			else globale.box_new_valutazione_scostamento := XNOTHING
		end;
		globale.bo_pausa_pagina := cbx_pausa_pagina.Checked;
		globale.str_pausa_pagina_message := str_pausa_pagina_message.Text;
		globale.i_durata_pausa_pagina_msec := i_pausa_pagina_durata_msec.get_Asinteger(FALSE);	

		globale.SQL_reexecute_scripts := SQL_reexecute_script_options(cb_reexecute_SQL_scripts.ItemIndex);

{		i := strtoint(i_jpeg_compression_quality.Text);
		if NOT (i in [1..100]) then begin
			MessageBBox(handle,'Il valore della JPEG COMPRESSION QUALITY deve essere compreso tra 1 e 100',MBOX_CAPTION);
			i := JPG_DEFAULT_COMPRESSION_QUALITY
		end;
		globale.i_jpeg_compression_quality := i; }

		globale.bo_use_compressed_bmps := cbx_compressed_bmp.Checked;
		globale.bo_log_parametri := cbx_log_parametri.Checked;
		globale.bo_show_time_esecuzione := cbx_show_time_esecuzione.Checked;
//		globale.str_macro_parametriche := togli_ACAPO_finali(memo_macros.Text);globale.build_macro_parametriche(TRUE);	*** fino 2018-07-08

		if rb_debug_target_console.Checked then computer_registry_data.debug_target := DEBUG_TARG_CONSOLE else
		if rb_debug_target_all.Checked then computer_registry_data.debug_target := DEBUG_TARG_BOTH else
		{if rb_debug_target_file.Checked then} computer_registry_data.debug_target := DEBUG_TARG_FILE;

		if rb_Rdebug_pipes.Checked then computer_registry_data.RDEBUG_mode := RDB_PIPES else
		if rb_Rdebug_TCPIP.Checked then computer_registry_data.RDEBUG_mode := RDB_TCPIP else
		if rb_Rdebug_datacopy.Checked then computer_registry_data.RDEBUG_mode := RDB_DATACOPY else
		{if rb_RDebug_blank.Checked then} computer_registry_data.RDEBUG_mode := RDB_BLANK;

//		globale.str_email := togli_ACAPO_finali(str_email.Text);
		globale.bo_address_required := cbx_address_required.Checked;
		globale.str_subject := togliblanks(str_subject.Text);
		globale.str_text := togli_ACAPO_finali(str_text.Text);
		globale.bo_auto_email := cbx_auto_email.Checked;
		globale.str_condizione_auto_email := str_condizione_auto_email.Text;

		globale.indirizzi_email_default := [];globale.indirizzi_email_elenco := [];
		for var eat : email_address_type := low(eat) to high(eat) do begin
			if cbx_email_default[eat].Checked then globale.indirizzi_email_default := globale.indirizzi_email_default + [eat];
			if cbx_email_elenco[eat].Checked then globale.indirizzi_email_elenco := globale.indirizzi_email_elenco + [eat]
		end;
		globale.bo_load_indirizzo_main_when_unique := cbx_mail_when_unique.Checked;
		globale.str_indirizzi_email_default_internal := togli_ACAPO_finali(str_mail_indirizzo_default_elenco.Text);
		globale.str_indirizzi_email_elenco_internal := togli_ACAPO_finali(str_mail_indirizzi_elenco.Text);
		globale.bo_indirizzi_email_default_SQL := cbx_mail_indirizzo_default_elenco_SQL.Checked;
		globale.bo_indirizzi_email_elenco_SQL := cbx_mail_indirizzi_elenco_SQL.Checked;

{		i := strtoint(i_jpeg_percentuale.Text);
		if (i < MIN_JPEG_PERCENTUALE) OR (i > MAX_JPEG_PERCENTUALE) then begin
			MessageBBox(handle,'La dimensione percentuale dell''immagine JPEG deve avere un valore compreso tra ' +
				inttostr(MIN_JPEG_PERCENTUALE) + ' e ' + inttostr(MAX_JPEG_PERCENTUALE),MBOX_CAPTION);
			i := JPG_DEFAULT_COMPRESSION_QUALITY
		end;
		globale.i_jpeg_percentuale := i; }

		globale.i_forced_width_10mm := strtoint(i_phisical_page_width.Text);
		globale.i_forced_height_10mm := strtoint(i_phisical_page_height.Text);

		GM.set_disegno_values;

		globale.tstr_remarks.assign(str_remarks.lines);
		globale.bo_log_registro_eventi := cbx_log_registro_eventi.Checked;
		globale.bo_log_file := cbx_log_file.Checked;
		globale.bo_debug_base := cbx_debug_base.Checked;
		globale.bo_debug_full := cbx_debug_full.Checked;
		globale.bo_debug_delete_everytime := cbx_debug_delete_everytime.Checked;
		globale.str_debug_computer := str_debug_computer.Text;
		computer_registry_data.i_DLL_system_debug_level := cb_system_debug.Itemindex;

		globale.str_default_date_format := str_date_format.Text;
		globale.str_default_time_format := str_time_format.Text;

		globale.tsql_stored_procs_definition.assign(str_stored_procs.lines);
		if NOT load_stored_procs(globale.tsql_stored_procs_definition,TRUE) then {???};

		globale.bo_use_transaction := bo_use_transaction.Checked;
		globale.bo_commit_transaction := globale.bo_use_transaction AND (rb_commit_transaction.ItemIndex = 0);
		case cb_isolation.ItemIndex of
//			0 : globale.isolation_level := tiDirtyRead;
			1 : globale.isolation_level := xiReadCommitted;
			2 : globale.isolation_level := xiRepeatableRead;
			else globale.isolation_level := xiDirtyRead
		end;
		globale.str_export_filename := str_export_filename.Text;
		globale.str_expint_export_filename := str_expint_export_filename.Text;
		globale.bo_overwrite_file := cbx_overwrite.Checked;

		globale.str_formato_label := togliblanks(cb_formato_label.Text);
		globale.bo_label_registra_ultima_posizione := cbx_label_registra_ultima_posizione.Checked;
		globale.str_label_skip := str_label_skip.Text;
		if (globale.tiporeport in LABEL_TYPES) AND (globale.str_formato_label = '')
			then MessageBBox(handle, 'Report di etichette: sarebbe opportuno specificare un codice di formato per le etichette', MBOX_CAPTION);

		if (get_pagina_logica_attiva_1B > globale.i_pagine_logiche) then
			set_pagina_logica_attiva_1B(globale.i_pagine_logiche, TRUE);	// mi riporto sull'ultima pagina logica esistente

		globale.bo_GAPP_ask_conferma_stampa_definitiva := cbx_ask_conferma_stampa_definitiva.Checked;
		globale.str_GAPP_password_stampa_definitiva := str_password_stampa_definitiva.Text;

		globale.lo_foreground_parms_caption_color := panel_runtime_caption_color.Font.Color;
		globale.lo_background_parms_caption_color := panel_runtime_caption_color.Color;
		globale.bo_allow_saving_runtime_pos := cbx_runtime_save_pos_size.Checked;

		globale.modalita_invio_mail := galateo_send_mail_mode_type(rb_modalita_mail.ItemIndex);
		read_SMTP_values;

		computer_registry_data.str_galrun_path := str_galrun_path.Text;
{		if (str_galrun_path.Text <> dich.str_galrun_path) then begin
			dich.str_galrun_path := str_galrun_path.Text;
			write_registry('', '', GALRUNT_PATH_REGISTRY_ITEM, dich.str_galrun_path)
		end; }

		globale.table_colori_symbolici.assign(local_table_colori_symbolici);
		for i := 0 to high(colori_symbolici_modified) do
			apply_change_name_colore_symbolico(colori_symbolici_modified[i].str_colore_from, colori_symbolici_modified[i].str_colore_to);

		read_SQLS_tabs;
		read_macro_tabs;
		for var sxt : text_script_type := low(sxt) to high(sxt) do globale.Text_scripts[sxt].copy_from(local_scripts[sxt]);
		globale.check_scripts_filenames;		// eseguo un controllo NON vincolante sui filenames utilizzati; sarà eseguito un controllo vincolante prima del salvataggio
		globale.build_macro_parametriche(TRUE);

		riassegna_groupboxes(globale.runtime_gboxes, rgboxes);	// faccio riassegnare le groupboxes dei vari oggetti
		runtime_groupboxes_assign(globale.runtime_gboxes, rgboxes);
		globale.FTP_parms.assign(FTP_local);
		static_OUTLOOK.assign(local_outlook);
		static_OUTLOOK.save;

		globale.bo_FTP_conferma := cbx_FTP_conferma.Checked;
		globale.str_FTP_password := str_FTP_password.Text;
		globale.str_FTP_message := str_FTP_message.Text;

		result := TRUE
	except
	end
end;

procedure Tdlg_impostazioni.read_SMTP_values;
begin
	var SMTP : cl_SMTP := registry_SMTP;

//	wo_port := reg.readint(1, 25);
	SMTP.data.str_host := str_SMTP_host.Text;
	SMTP.data.wo_port := wo_SMTP_port.get_Asinteger(FALSE);
	SMTP.data.str_from := str_SMTP_from.Text;
	SMTP.data.str_auth_ID := str_SMTP_auth_ID.Text;
	SMTP.data.str_auth_pwd := str_SMTP_password.Text;

	SMTP.data.bo_use_TLS := cbx_SMTP_TLS.Checked;
	SMTP.data.bo_need_authentication := cbx_SMTP_need_authentication.Checked;
	SMTP.data.str_mittente_descrizione := str_SMTP_descrizione_mittente.Text;
	SMTP.data.bo_conferma_lettura := cbx_SMTP_conferma_lettura.Checked;
	SMTP.data.str_reply_to := str_SMTP_replyto.Text;

	SMTP.str_CCN := str_SMTP_ccn.Text;
	SMTP.str_firma := str_SMTP_firma.Text;
	SMTP.mail_client_setup.SMTP_protocol := SMTP_explicit_protocol_type(rb_client_SMTP.Itemindex);

	SMTP.save
end;

procedure Tdlg_impostazioni.btn_okClick(Sender : TObject);
begin
	if read_from_window then begin
//		write_registry_string(HKEY_CURRENT_USER, GALATEO_REGISTRY_BASE, GALRUNT_SYSTEM_DEBUG_KEY, inttostr(i_DLL_system_debug_level));
		computer_registry_data.write_registry_values;
		close
	end
end;

procedure Tdlg_impostazioni.btn_cancelClick(Sender : TObject);
begin close end;

procedure Tdlg_impostazioni.btn_print_setupClick(Sender : TObject);
begin
	var bo_old := globale.bo_autosize_page;
	try
		globale.bo_autosize_page := cbx_autosize_page.Checked;	// può essere determinante all'interno della chiamata
		if imposta_printer_proc(self) then begin
			init_printer;
			globale.autosize_printer_page(TRUE)
		end
	finally
		globale.bo_autosize_page := bo_old
	end
end;

procedure Tdlg_impostazioni.video_setupClick(Sender : TObject); begin {video_setup_proc(self,TRUE)} end;
procedure Tdlg_impostazioni.cbx_use_grigliaClick(Sender : TObject); begin i_griglia.Enabled := cbx_use_griglia.Checked end;

procedure Tdlg_impostazioni.cb_tiporeport_exit_CloseUp(Sender : TObject);
begin
	if (cb_tiporeport.ItemIndex <> -1) then set_report(REPORT_TYPE(cb_tiporeport.ItemIndex))
end;

var bo_in_set_report : boolean;

//procedure Tdlg_impostazioni.set_report(bo_report : boolean);
procedure Tdlg_impostazioni.set_report(tiporeport : REPORT_TYPE);
begin
	if bo_in_set_report then exit;
	try
		bo_in_set_report := TRUE;
		self.tiporeport := tiporeport;
		if (cb_tiporeport.ItemIndex <> byte(tiporeport)) then cb_tiporeport.ItemIndex := byte(tiporeport);
		var bo_report := (tiporeport in REPORT_TYPES);
		var bo_label := (tiporeport in LABEL_TYPES);

		cbx_pagina_intera.Enabled := bo_label;
		enable_FC(txt_numero_copie_default,bo_report);
		enable_FC(txt_lab_per_row,bo_label);enable_FC(txt_lab_per_page,bo_label);
		enable_FC(txt_delta_x,bo_label);enable_FC(txt_delta_y,bo_label);
		enable_FC(txt_pagine,bo_report);
		make_all_children_enabled(gbox_label_options, bo_label)
	finally
		bo_in_set_report := FALSE
	end
end;

procedure Tdlg_impostazioni.btn_headerClick(Sender : TObject);
begin
	if NOT read_from_window then exit;
	edit_section_ZB(MAIN_SECTION_ZB, TRUE)
end;

procedure Tdlg_impostazioni.btn_active_sectionClick(Sender : TObject);
begin
	if NOT read_from_window then exit;
	edit_section_ZB(get_section_attiva_ZB, FALSE)
end;

procedure Tdlg_impostazioni.ricalcola_text_only_sizes;
{var
	i_size,i_lpi,j : integer;
	r_x,r_y : real; }
begin
{	IVal(cb_text_only_cpi.Text,i_size,j);
	rval(r_size_x.Text,r_x,j);
	i_text_only_colonne.Text := inttostr(my_round(cm2inches(r_x) * i_cpi,0,RND_NEAREST));

	IVal(cb_text_only_lpi.Text,i_lpi,j);
	rval(r_size_y.Text,r_y,j);
	i_text_only_righe.Text := inttostr(my_round(cm2inches(r_y) * i_lpi,0,RND_NEAREST)) }
end;

procedure Tdlg_impostazioni.btn_formato_stprocClick(Sender : TObject);
const MBOX_CAPTION = 'Formato stored procedures';
begin
	MessageBBox(handle, 'Una SP per riga.' + ACAPO2 +
		'NOME_PROC ( parametri separati da VIRGOLA ) : tipo_risultato' + ACAPO2 +
		'Ogni parametro deve essere definito come:' + ACAPO +
		'NOME_PARM:TIPO_PARM' + ACAPO2 +
		'Il tipo dei parametri e del risultato può essere:' + ACAPO +
		'STRING (max 254 chars), INTEGER, SMALLINT, DOUBLE, CURRENCY',
		MBOX_CAPTION);
	MessageBBox(handle,
		'Il risultato può essere anche di tipo VOID (nessun risultato)' + ACAPO2 +
		'L''ultimo parametro della stored procedure viene fatto valere anche come risultato della stessa' + ACAPO2 +
		'Se non ci sono parametri indicare comunque una coppia di parentesi vuota (C-like)' + ACAPO2 +
		'max ' + inttostr(SP_MAX_PARMS-1) + ' parametri' + ACAPO2 +		// -1 perchè c'è anche il risultato
		'max ' + inttostr(MAX_STORED_PROCS) + ' stored procs in totale' + ACAPO2 +
		'Righe di commento precedute da ' + COMMENTI,
		MBOX_CAPTION);
	MessageBBox(handle,
		'Un parametro che contenga virgole o altri caratteri speciali deve essere '+
		'iniziato e terminato dalla sequenza di caratteri:' + ACAPO + DELIMITATORE_SPECIALE_PARMS + ACAPO2 +
		'Esempio:' + DELIMITATORE_SPECIALE_PARMS + '''DDT-SCA'',''DDT-SCAR''' + DELIMITATORE_SPECIALE_PARMS,
		MBOX_CAPTION)
end;

procedure Tdlg_impostazioni.FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
begin
	if tratta_tasto_maximize(self, key, shift) then exit;
	case key of
		VK_F1 : if (shift = []) then default_help_proc(self)
	end;
	if key_button(key, VK_F7, btn_print_setup, FALSE) then exit;
	key_button(key, VK_F9, btn_ok, FALSE)
end;

procedure Tdlg_impostazioni.init_printer;
var
	s, str_stampante : string;
//	handle : HDC;
	bo_misure : boolean;
begin
//	globale.select_printer(globale.xstr_printer);
{	globale.select_printer(globale.get_default_printer(TRUE));
	if (globale.xstr_printer = '') then begin
		s := '[predefinita] ' + printer.printers[printer.printerindex];bo_misure := TRUE
	end
	else
	if (printer.printers.indexof(globale.xstr_printer) = -1) then begin
		s := globale.xstr_printer + ' [sconosciuta]';bo_misure := FALSE
	end
	else begin
		s := printer.printers[printer.printerindex];bo_misure := TRUE
	end;}
	str_stampante := globale.get_default_printer(TRUE);
	if (str_stampante = '') then begin s := '[predefinita] ' + str_stampante_predefinita;bo_misure := TRUE end
	else
	if (printer.printers.indexof(str_stampante) = -1) then begin s := str_stampante + ' [sconosciuta]';bo_misure := FALSE end
//	else begin s := printer.printers[printer.printerindex];bo_misure := TRUE end;
	else begin s := str_stampante;bo_misure := TRUE end;
	globale.select_printer(str_stampante);
	{$ifdef DEBUG} s := '<' + printer.printerindex.Tostring + '> ' + s; {$endif}
	str_printer.Caption := s;
	str_printer.Hint := str_printer.Caption;	// per farlo leggere anche se deborda
	if bo_misure then begin
		{with misure.tm do }str_page_descr.Caption :=
			'dimensione: ' + strid(misure.tm.i_phisical_10mm_width / 100, 0, 1) +
			' per ' + strid(misure.tm.i_phisical_10mm_height / 100, 0, 1) + ' cm' {+
			' (stampabile: '+ strid(getdevicecaps(handle,HORZSIZE)/10,0,1)+
			' per ' + strid(getdevicecaps(handle,VERTSIZE)/10,0,1) + ' cm)'}
{		handle := printer.handle;
		with misure.tm do str_page_descr.Caption :=
			'dimensione: ' + strid(print2cm_x(GetDeviceCaps(handle,PHYSICALWIDTH)),0,1) +
			' per ' + strid(print2cm_y(GetDeviceCaps(handle,PHYSICALHEIGHT)),0,1) + ' cm' +
			' (stampabile: '+ strid(getdevicecaps(handle,HORZSIZE)/10,0,1)+
			' per ' + strid(getdevicecaps(handle,VERTSIZE)/10,0,1) + ' cm)' }
	end
	else str_page_descr.Caption := 'dimensioni foglio non disponibili'
end;

procedure Tdlg_impostazioni.btn_shell_extensionsClick(Sender : TObject);
begin
	if setup_shell_extensions(self) then MessageBBox(handle, 'Collegamento reimpostato', MBOX_CAPTION, MB_OK)
	else MessageBBox(self, 'Collegamento NON reimpostato', MBOX_CAPTION, MB_ICONSTOP)
end;

procedure Tdlg_impostazioni.cbx_phisical_sizeClick(Sender : TObject);
begin
	if NOT bo_warning_phisical_size then begin
		MessageBBox(self, 'ATTENZIONE' + ACAPO2 +
			'In generale è preferibile impostare direttamente i parametri default per la stampante.' + ACAPO2 +
			'Lasciare i valori a ZERO per utilizzare le impostazioni default', MBOX_CAPTION);
		bo_warning_phisical_size := TRUE
	end;
	enable_ctrls
end;

procedure Tdlg_impostazioni.lb_versioniMeasureItem(Control: TWinControl;Index: Integer; var Height: Integer);
begin
	lb_versioni.ScrollWidth := max(lb_versioni.ScrollWidth,lb_versioni.Canvas.TextWidth(lb_versioni.Items[index])*2)	// *2 : empirico e teoricamente inutile
end;

procedure Tdlg_impostazioni.delete_versioni_selezionate;
begin
	if NOT globale.bo_federico_signed then begin
		MessageBBox(handle,'Sorry, non disponi dei diritti necessarî per eseguire l''operazione',MBOX_CAPTION);
		exit
	end;
	if (lb_versioni.SelCount = 0) then exit;
	if (MessageBBox(handle,'Vuoi eliminare le informazioni selezionate?',MBOX_CAPTION,MB_QUESTION) <> IDYES) then exit;
	for var i : smallint := lb_versioni.Items.Count-1 downto 0 do
		if (lb_versioni.selected[i]) then globale.salvataggi.Delete(i);
	set_global_modified;
	write_versioni_salvataggio
end;

procedure Tdlg_impostazioni.write_versioni_salvataggio;
begin
//	lb_versioni.Items.Assign(globale.salvataggi)
	var s := globale.salvataggi.Text;
	// mostro il nome del file solo se tale nome è diverso da quello attuale
	lb_versioni.Items.Text := sostituisci(s, '/' + extractFilename(globale.str_filename) + ']', ']', TRUE)
end;

procedure Tdlg_impostazioni.lb_versioniKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
	case key of
		VK_DELETE : begin delete_versioni_selezionate;key := 0 end
	end
end;

(*procedure prova;
var
//	printer : TPrinter;
	s : string;
//	handle : HDC;
	i,px,py : integer;
begin
//	printer := TPrinter.create;
	for i := 0 to printer.printers.Count-1 do begin
		printer.printerindex := i;
//		printer.begindoc;
		with printer do begin
			px := GetDeviceCaps(handle,LOGPIXELSX);py := GetDeviceCaps(handle,LOGPIXELSY);
			s := 'dimensione: ' + strid(GetDeviceCaps(handle,PHYSICALWIDTH)*2.54/px,0,1) +
				' per ' + strid(GetDeviceCaps(handle,PHYSICALHEIGHT)*2.54/py,0,1) + ' cm' +
				' (stampabile: '+ strid(getdevicecaps(handle,HORZSIZE)/10,0,1)+
				' per ' + strid(getdevicecaps(handle,VERTSIZE)/10,0,1) + ' cm)' +
				' dimensione: ' + strid(pagewidth*2.54/px,0,1) +
				' per ' + strid(pageheight*2.54/py,0,1) + ' cm';
			MessageBBox(0,s,printers[printerindex],0)
		end;
//		printer.abort
	end;
//	printer.free
end; {} *)

{procedure Tdlg_impostazioni.prova;
var
//	printer : TPrinter;
	s : string;
//	handle : HDC;
	i,px,py : integer;
	pd: TPrintDialog;
begin
//	printer := TPrinter.create;
	pd := TPrintDialog.Create(self);
	pd.execute;

	with printer do begin
		px := GetDeviceCaps(handle,LOGPIXELSX);py := GetDeviceCaps(handle,LOGPIXELSY);
		s := 'dimensione: ' + strid(GetDeviceCaps(handle,PHYSICALWIDTH)*2.54/px,0,1) +
			' per ' + strid(GetDeviceCaps(handle,PHYSICALHEIGHT)*2.54/py,0,1) + ' cm' +
			' (stampabile: '+ strid(getdevicecaps(handle,HORZSIZE)/10,0,1)+
			' per ' + strid(getdevicecaps(handle,VERTSIZE)/10,0,1) + ' cm)' +
			' dimensione: ' + strid(pagewidth*2.54/px,0,1) +
			' per ' + strid(pageheight*2.54/py,0,1) + ' cm';
		MessageBBox(0,s,printers[printerindex],0)
	end;
	pd.free
end;}

procedure Tdlg_impostazioni.enable_ctrls;
begin
//	cbx_autosize_page.Enabled := (rb_tipo_report.ItemIndex = TR_REPORT);
	cbx_autosize_page.Enabled := (REPORT_TYPE(cb_tiporeport.ItemIndex) in REPORT_TYPES);
	make_all_children_enabled(gbox_phisical_size, cbx_autosize_page.Enabled AND cbx_phisical_size.Checked, FALSE);

	enable_FC(txt_debug_computer, cbx_debug_base.Checked);
	btn_debug_on_this_computer.Enabled := cbx_debug_base.Checked;
	cbx_debug_full.Enabled := cbx_debug_base.Checked;
	cbx_debug_delete_everytime.Enabled := cbx_debug_base.Checked;
	make_all_children_enabled(gbox_debug_runtime_message, cbx_debug_base.Checked);

	make_all_children_enabled(gbox_debug_target, cbx_debug_base.Checked OR (cb_system_debug.ItemIndex <> 0));
//	make_all_children_enabled(gbox_RDEBUG, cbx_debug_base.Checked AND rb_debug_target_console.Checked);
	make_all_children_enabled(gbox_RDEBUG, gbox_debug_target.Enabled AND NOT rb_debug_target_file.Checked);

	cbx_use_griglia.Enabled := NOT bo_text_only_report.Checked;
	i_griglia.Enabled := cbx_use_griglia.Checked AND NOT bo_text_only_report.Checked;
	if bo_text_only_report.Checked then begin
		cbx_use_griglia.Checked := TRUE;
		i_griglia.Text := cm2pixel_video_y(tm.Text_only_line_height_cm).Tostring
	end;
	make_all_children_enabled(gb_text_only, bo_text_only_report.Checked, TRUE);
	make_all_children_enabled(unabled_panel, FALSE, TRUE);

	cbx_show_index.Enabled := cbx_create_index.Checked;
	enable_FC(txt_pausa_pagina_message, cbx_pausa_pagina.Checked);

	enable_FC(txt_GAPP_password_stampa_definitiva, cbx_ask_conferma_stampa_definitiva.Checked);
	btn_macro_delete.Enabled := (i_macro_tabs_used > 1);		// impossibile eliminare l'ultimo foglio macro

//	make_all_children_enabled(gbox_SMTP, modalita_mail_type(rb_modalita_mail.ItemIndex) in [MMT_CALLING_PROGRAM, MMT_LOCAL_STMP]);
//	make_all_fathers_enabled(rb_modalita_mail);

	rb_commit_transaction.Enabled := bo_use_transaction.Checked;
	enable_FC(txt_isolation, bo_use_transaction.Checked);
	enable_FC(txt_pagine, (globale.tiporeport = TR_REPORT));
	cb_tiporeport.Enabled := (globale.i_pagine_logiche = 1);	// i label-reports possono avere una sola pagina logica

//	make_all_children_enabled(sql_stored_proc_00, cbx_early_script.Checked, TRUE);
//	if NOT cbx_early_script.Checked then make_all_fathers_enabled(cbx_early_script, TRUE);

	var bo := cbx_export_allowed.Checked;
	make_all_children_enabled(page_export_integrale, bo, TRUE);
	if bo then begin
		cbx_export_proponi.Enabled := cbx_export_set_default.Checked;
		cbx_export_automatic.Enabled := cbx_export_proponi.Enabled AND cbx_export_proponi.Checked;
//		make_all_children_enabled(page_exportazione_integrale, cbx_export_allowed.Checked);
//		make_all_children_enabled(page_XML, cbx_XML_allowed.Checked);
//		cbx_XML_structure_debug_info.Enabled := cbx_XML_allowed.Checked
	end
	else begin
		make_all_fathers_enabled(cbx_export_allowed);
//		cbx_XML_allowed.Enabled := TRUE;
		btn_help_export.Enabled := TRUE
	end;

	enable_FC(txt_condizione_auto_email, cbx_auto_email.Checked);

	enable_SQLS_tabs;
	enable_macro_tabs;

	enable_FC(txt_FTP_password, cbx_FTP_conferma.Checked);
	enable_FC(txt_FTP_message, cbx_FTP_conferma.Checked);
	btn_FTP_default_message.Enabled := cbx_FTP_conferma.Checked;

	bo := (lb_runtime_gboxes.Count > 1) AND (lb_runtime_gboxes.Itemindex <> -1);
	btn_runtime_gbox_delete.Enabled := bo;
	btn_runtime_gbox_moveup.Enabled := bo AND (lb_runtime_gboxes.Itemindex > 0);
	btn_runtime_gbox_movedown.Enabled := bo AND (lb_runtime_gboxes.Itemindex < lb_runtime_gboxes.Count-1);
	btn_runtime_gbox_modify.Enabled := (lb_runtime_gboxes.Itemindex <> -1);

	cbx_mail_when_unique.Enabled := NOT cbx_email_default[EAT_PRINCIPALE].Checked;
	btn_outlook_configuration.Enabled := (galateo_send_mail_mode_type(rb_modalita_mail.ItemIndex) = GSMM_OUTLOOK)
end;

procedure Tdlg_impostazioni.btn_browse_PKL_label_00Click(Sender : TObject);
begin
	var s : string := str_default_export_filepath.Text;
	if browse_directory(self, 'directory exportazione', s, extractFilePath(globale.str_filename)) then str_default_export_filepath.Text := s
end;

procedure Tdlg_impostazioni.btn_galrunClick(Sender : TObject);
begin
	var s : string := str_galrun_path.Text;
	if browse_directory(self, 'directory di GalRun.exe', s, extractFilePath(paramstr(0))) then str_galrun_path.Text := s
end;

procedure Tdlg_impostazioni.runtime_gbox_edit(bo_new : boolean = FALSE);
var t : cl_runtime_groupbox;	//*
begin
	var i_ndx : smallint := 0;	// paranoie del compilatore
	if bo_new then t := cl_runtime_groupbox.create
	else begin
		i_ndx := lb_runtime_gboxes.ItemIndex;
		if (i_ndx = -1) then exit;
		t := rgboxes[i_ndx]
	end;

	if runtime_gbox_edit_proc(self,t) then begin
		if bo_new then begin
			i_ndx := length(rgboxes);
			setLength(rgboxes, i_ndx+1);
			rgboxes[i_ndx] := t
		end;
		runtime_gbox_load(i_ndx)
	end
	else if bo_new then t.free
end;

procedure Tdlg_impostazioni.runtime_gbox_delete;
begin
	if (lb_runtime_gboxes.Count < 2) then exit;	// nulla da cancellare!!!
	var i_ndx : smallint := lb_runtime_gboxes.ItemIndex;
	if (i_ndx = -1) then exit;
	if (MessageBBox(handle, 'Vuoi eliminare il gruppo corrente?', MBOX_CAPTION, MB_QUESTION_DEF2) <> IDYES) then exit;

	rgboxes[i_ndx].free;
	if (i_ndx <> length(rgboxes)-1) then	// altrimenti fa casino per l'indice, anche se l'operazione è solo virtuale
		move(rgboxes[i_ndx+1], rgboxes[i_ndx], (length(rgboxes) - i_ndx - 1) * sizeof(pointer));
	setLength(rgboxes, length(rgboxes) - 1);
	if (i_ndx = length(rgboxes)) then dec(i_ndx);
	runtime_gbox_load(i_ndx)
end;

procedure Tdlg_impostazioni.runtime_gbox_move(bo_up : boolean);
var i_ndx, i_delta : smallint;	//*
begin
	i_ndx := lb_runtime_gboxes.ItemIndex;
	if (i_ndx = -1) then exit;
	if bo_up then begin
		if (i_ndx = 0) then exit;
		i_delta := -1
	end
	else begin
		if (i_ndx = lb_runtime_gboxes.Count-1) then exit;
		i_delta := +1
	end;
	var t : cl_runtime_groupbox := rgboxes[i_ndx];
	rgboxes[i_ndx] := rgboxes[i_ndx+i_delta];
	rgboxes[i_ndx+i_delta] := t;
	runtime_gbox_load(i_ndx+i_delta)
end;

procedure Tdlg_impostazioni.runtime_gbox_load(i_select_index : smallint = -1);
// seleziona l'indice specificato; se I_SELECT_INDEX = -1 riseleziona l'indice corrente
begin
	if (i_select_index = -1) then i_select_index := lb_runtime_gboxes.ItemIndex;
	runtime_groupboxes_load_items(lb_runtime_gboxes.Items, rgboxes);
{	lb_runtime_gboxes.Items.clear;
	for var i : smallint := 0 to length(runtime_gboxes)-1 do
		lb_runtime_gboxes.Items.add(runtime_gboxes[i].get_descrizione(i+1)); }
	lb_runtime_gboxes.ItemIndex := i_select_index;
	enable_ctrls
end;

procedure Tdlg_impostazioni.btn_debug_on_this_computerClick(Sender : TObject);
begin
	str_debug_computer.Text := uppercase(get_computer_name)
end;

procedure Tdlg_impostazioni.panel_runtime_caption_colorClick(Sender : TObject);
var
	lo : TColor;
	bo_text : boolean;
begin
	case domanda_multipla_04_proc(self, 'Modifica colore', 'Vuoi cambiare il colore del titolo della finestra di richiesta dei parametri?',
		0, 'TESTO', 'SFONDO', 'ripristina default')
	of
//		0 : exit;
		1 : bo_text := TRUE;
		2 : bo_text := FALSE;
		3 : begin
			panel_runtime_caption_color.Font.Color := clWindowText;
			panel_runtime_caption_color.Color := clBtnFace;
			exit
		end;
		else exit
	end;
	if bo_text then lo := panel_runtime_caption_color.Font.Color else lo := panel_runtime_caption_color.Color;
	if select_colore(self,lo) then
		if bo_text then panel_runtime_caption_color.Font.Color := lo else panel_runtime_caption_color.Color := lo
end;

procedure Tdlg_impostazioni.window_size(bo_read : boolean);
const
	NDX_RECT = 1;
	NDX_MAXIMIZED = 2;
	OBSOLETO_NDX_ACTIVEPAGE = 3;
var i : smallint;
begin
	var r : TFRegistry := NIL;
	if (bo_read AND NOT bo_loaded) OR NOT bo_read then
		r := TFRegistry.create(make_registry_key('setup-window'{, ''}), {can_initialize_registry}TRUE, {rootkey}HKEY_CURRENT_USER, {readonly}bo_read);

	if bo_read then begin
		if NOT bo_loaded then begin
			try
				i := r.readint(NDX_MAXIMIZED, 2);bo_maximized := (i = 1);
				r.IO_rect(TRUE, NDX_RECT, rw);
				i_activepage := r.readint(OBSOLETO_NDX_ACTIVEPAGE)
			except
			end;
			bo_loaded := TRUE
		end;
		if bo_maximized then windowState := wsMaximized
		else SetBounds(rw.Left, rw.Top, rw.Right, rw.Bottom);
//		if (i_activepage <> 0) then pc.Activepage := pc.pages[i_activepage]				****** non più gestito qui da 2013-12-06
	end
	else begin
		rw.Left := left;rw.Top := top;rw.Right := width;rw.Bottom := height;
		bo_maximized := (windowState = wsMaximized);
		i_activepage := pc.Activepageindex;
		r.write(NDX_MAXIMIZED, byte(bo_maximized));
		r.IO_rect(FALSE, NDX_RECT, rw);
//		r.write(NDX_ACTIVEPAGE, i_activepage)
		r.write(OBSOLETO_NDX_ACTIVEPAGE, 0)
	end;
	if (r <> NIL) then r.free
end;

procedure Tdlg_impostazioni.btn_label_skip_defaultClick(Sender : TObject);
begin
	str_label_skip.Text := lowercase(FUNC[i_NDXF_POS_ULTIMA_ETICHETTA_STAMPATA_EXTERNAL].str_name) + '()'
end;

procedure Tdlg_impostazioni.cbx_mail_default_Click(Sender : TObject);
begin
//	bo_something_modified := TRUE;
	enable_ctrls
end;

procedure Tdlg_impostazioni.cbx_mail_elenco_Click(Sender : TObject);
begin
//	bo_something_modified := TRUE;
	if bo_setting_stato_mail then exit;
	try
		bo_setting_stato_mail := TRUE;
		var cbx : TFCheckBox := (sender as TFCheckBox);
		if NOT cbx.Checked then exit;
		if (cbx = cbx_email_elenco[EAT_BLANK]) then begin
			for var x : email_address_type := low(x) to high(x) do
				if (x <> EAT_BLANK) then cbx_email_elenco[x].Checked := FALSE
		end
		else cbx_email_elenco[EAT_BLANK].Checked := FALSE
	finally
		bo_setting_stato_mail := FALSE
	end
end;

procedure Tdlg_impostazioni.btn_test_SMTPClick(Sender : TObject);
begin
{	var wo : word := SMTP_DEFAULT_PORT;
	SMTP_test_proc(self, PROGRAM_NAME, wo, str_SMTP_host.Text, str_SMTP_from.Text, str_SMTP_auth_ID.Text, str_SMTP_password.Text,
		cbx_SMTP_need_authentication.Checked, cbx_SMTP_TLS.Checked,
		str_SMTP_descrizione_mittente.Text, str_SMTP_firma.Text, str_SMTP_ccn.Text) }
	var SMTP : cl_SMTP_data := cl_SMTP_data.create;
	try
		SMTP.wo_port := wo_SMTP_port.get_Asinteger(FALSE);
		SMTP.str_host := str_SMTP_host.Text;
		SMTP.str_from := str_SMTP_from.Text;
		SMTP.bo_need_authentication := cbx_SMTP_need_authentication.Checked;
		SMTP.bo_use_TLS := cbx_SMTP_TLS.Checked;
		SMTP.str_auth_ID := str_SMTP_auth_ID.Text;
		SMTP.str_auth_pwd := str_SMTP_password.Text;
		SMTP.bo_conferma_lettura := cbx_SMTP_conferma_lettura.Checked;
		SMTP.str_reply_to := str_SMTP_replyto.Text;
		SMTP.str_mittente_descrizione := str_SMTP_descrizione_mittente.Text;
		SMTP_test_proc(self, PROGRAM_NAME, SMTP, str_SMTP_firma.Text, str_SMTP_ccn.Text)
	finally
		SMTP.free
	end
end;

procedure Tdlg_impostazioni.browse_documento_informativo(ctrl : TEdit;str_default_ext, str_filter : string);
begin
	var s : string := ctrl.Text;
	if browse_for_files_open(self, {caption}'', s, str_default_ext, str_filter, {str_default_dir}ExtractFilePath(globale.str_filename))
		then ctrl.Text := s
end;

procedure Tdlg_impostazioni.open_documento_informativo(ctrl : TEdit);
begin
	if (ctrl.Text = '') then begin beep;exit end;
{	if NOT FileExists(ctrl.Text) then begin
		MessageBBox(handle, 'Il file <' + uppercase(ctrl.Text) + '> non esiste o non è accessibile', MBOX_CAPTION, MB_ICONSTOP);
		exit
	end; }
	execute_data_file(handle, {bo_debug}FALSE, ctrl.Text)
end;

procedure Tdlg_impostazioni.btn_doc_utente_browseClick(Sender : TObject);
begin browse_documento_informativo(str_doc_utente, DOC_INFO_UTENTE_DEFAULT_EXT, DOC_INFO_UTENTE_FILTER) end;

procedure Tdlg_impostazioni.btn_technical_reference_browseClick(Sender : TObject);
begin browse_documento_informativo(str_technical_reference, TECHNICAL_REFERENCE_DEFAULT_EXT, TECHNICAL_REFERENCE_FILTER) end;

procedure Tdlg_impostazioni.btn_FTP_default_messageClick(Sender : TObject); begin str_FTP_message.Text := DEFAULT_FTP_CONFIRM_MESSAGE end;
procedure Tdlg_impostazioni.cb_text_only_cpiClick(Sender : TObject); begin ricalcola_text_only_sizes end;
procedure Tdlg_impostazioni.btn_opzioni_PDFClick(Sender : TObject); begin PDF_options_dialog(self, globale.PDF, FALSE, FALSE) end;
procedure Tdlg_impostazioni.btn_delete_versioniClick(Sender : TObject); begin delete_versioni_selezionate end;
procedure Tdlg_impostazioni.cbx_create_indexClick(Sender : TObject); begin enable_ctrls end;
procedure Tdlg_impostazioni.bo_use_transactionClick(Sender : TObject); begin enable_ctrls end;
procedure Tdlg_impostazioni.bo_text_only_reportClick(Sender : TObject); begin enable_ctrls end;
procedure Tdlg_impostazioni.generic_enable_ctrls(Sender : TObject); begin enable_ctrls end;
procedure Tdlg_impostazioni.cbx_ask_conferma_stampa_definitivaClick(Sender : TObject); begin enable_ctrls end;
procedure Tdlg_impostazioni.btn_runtime_gbox_addClick(Sender : TObject); begin runtime_gbox_edit(TRUE) end;
procedure Tdlg_impostazioni.btn_runtime_gbox_modifyClick(Sender : TObject); begin runtime_gbox_edit end;
procedure Tdlg_impostazioni.lb_runtime_gboxesDblClick(Sender : TObject); begin runtime_gbox_edit end;
procedure Tdlg_impostazioni.btn_runtime_gbox_deleteClick(Sender : TObject); begin runtime_gbox_delete end;
procedure Tdlg_impostazioni.btn_runtime_gbox_moveupClick(Sender : TObject); begin runtime_gbox_move(TRUE) end;
procedure Tdlg_impostazioni.btn_runtime_gbox_movedownClick(Sender : TObject); begin runtime_gbox_move(FALSE) end;
procedure Tdlg_impostazioni.btn_helpClick(Sender : TObject); begin help_proc(self, HELP_RUNTIME_PARMS, HELP_RUNTIME_PARMS_GBOXES_SEGNALIBRO) end;
procedure Tdlg_impostazioni.lb_runtime_gboxesClick(Sender : TObject); begin enable_ctrls end;
procedure Tdlg_impostazioni.cbx_export_allowedClick(Sender : TObject); begin enable_ctrls end;
procedure Tdlg_impostazioni.cbx_export_set_defaultClick(Sender : TObject); begin enable_ctrls end;
procedure Tdlg_impostazioni.cbx_export_proponiClick(Sender : TObject); begin enable_ctrls end;
procedure Tdlg_impostazioni.btn_help_datetime_formatClick(Sender : TObject); begin help_proc(self, HELP_DATETIME_FORMAT) end;
procedure Tdlg_impostazioni.cbx_auto_emailClick(Sender : TObject); begin enable_ctrls end;
procedure Tdlg_impostazioni.btn_export_profilesClick(Sender : TObject); begin expint_profilo_elenco_proc(self) end;
procedure Tdlg_impostazioni.rb_modalita_mailClick(Sender : TObject); begin enable_ctrls end;
procedure Tdlg_impostazioni.cbx_pausa_paginaClick(Sender : TObject); begin enable_ctrls end;

procedure Tdlg_impostazioni.btn_doc_utente_openClick(Sender : TObject); begin open_documento_informativo(str_doc_utente) end;
procedure Tdlg_impostazioni.btn_technical_reference_openClick(Sender : TObject); begin open_documento_informativo(str_technical_reference) end;
procedure Tdlg_impostazioni.btn_impostazioni_FTPClick(Sender : TObject); begin FTP_impostazioni_proc(self, FTP_local) end;
procedure Tdlg_impostazioni.cbx_FTP_confermaClick(Sender : TObject); begin enable_ctrls end;
procedure Tdlg_impostazioni.btn_help_export_filenameClick(Sender : TObject); begin MessageBBox(handle, EXPORT_FILENAME_HINT, MBOX_CAPTION) end;

procedure Tdlg_impostazioni.itp_SMTP_defaultClick(Sender : TObject); begin set_standard_SMTP(SSMTPS_BLANK) end;
procedure Tdlg_impostazioni.itp_SMTP_gmailClick(Sender : TObject); begin set_standard_SMTP(SSMTPS_GMAIL) end;
procedure Tdlg_impostazioni.itp_SMTP_yahooClick(Sender : TObject); begin set_standard_SMTP(SSMTPS_YAHOO) end;
procedure Tdlg_impostazioni.itp_SMTP_microsoft_hotmailClick(Sender : TObject); begin set_standard_SMTP(SSMTPS_HOTMAIL_MICROSOFT) end;
procedure Tdlg_impostazioni.dlg_impostazioniitp_SMTP_arubaClick(Sender : TObject); begin set_standard_SMTP(SSMTPS_ARUBA) end;
procedure Tdlg_impostazioni.itp_SMTP_feaciClick(Sender : TObject); begin set_standard_SMTP(SSMTPS_ARUBA, TRUE) end;

procedure Tdlg_impostazioni.image_expint_varamb_00Click(Sender : TObject); begin MessageBBox(handle, VARIABILE_AMBIENTE_ALLOWED_MSG, MBOX_CAPTION) end;
procedure Tdlg_impostazioni.btn_help_exportClick(Sender : TObject); begin help_proc(self, EXPORT_HELP) end;
procedure Tdlg_impostazioni.btn_copy_clipboardClick(Sender : TObject); begin copy_versioni_clipboard end;
procedure Tdlg_impostazioni.btn_help_SQL_null_valuesClick(Sender : TObject); begin help_proc(self, HELP_COMPORTAMENTO_WHEN_NULL) end;

procedure Tdlg_impostazioni.btn_help_sql_scriptsClick(Sender : TObject); begin help_proc(self, HELP_SQL_SCRIPTS) end;
procedure Tdlg_impostazioni.btn_SQL_scripts_number_applyClick(Sender : TObject); begin applica_modifica_numero_scripts_SQL end;
procedure Tdlg_impostazioni.cbx_SQL_script_enabledClick(Sender : TObject); begin enable_SQLS_tabs {enable_ctrls} end;
procedure Tdlg_impostazioni.SQL_scripts_numeroChange(Sender : TObject); begin enable_SQLS_tabs end;
procedure Tdlg_impostazioni.btn_SQL_move_sheet_sxClick(Sender : TObject); begin move_SQL_script((sender as TFBitBtn).Tag, -1) end;
procedure Tdlg_impostazioni.btn_SQL_move_sheet_dxClick(Sender : TObject); begin move_SQL_script((sender as TFBitBtn).Tag, +1) end;

procedure Tdlg_impostazioni.btn_help_macro_parametricheClick(Sender : TObject); begin help_proc(self, MACRO_PARAMETRICHE_HELP) end;
procedure Tdlg_impostazioni.btn_applica_macro_scriptsClick(Sender : TObject); begin applica_modifica_numero_scripts_macro end;
procedure Tdlg_impostazioni.i_macro_scriptsChange(Sender : TObject); begin enable_macro_tabs end;
procedure Tdlg_impostazioni.btn_macro_move_sheet_sxClick(Sender : TObject); begin move_macro_script((sender as TFBitBtn).Tag, -1) end;
procedure Tdlg_impostazioni.btn_macro_move_sheet_dxClick(Sender : TObject); begin move_macro_script((sender as TFBitBtn).Tag, +1) end;

procedure Tdlg_impostazioni.btn_help_set_mail_contoClick(Sender : TObject);
begin
	MessageBBox(self,
		'L''assegnazione automatica delle mail è delegata al programma chiamante attraverso la callback procedure e viene attivata solamente se il report è associato ad un unico conto.' + ACAPO2 +
		'Il programma chiamante determina le mail in funzione dei parametri impostati sul report e li assegna usando le opzioni' + ACAPO +
			'- GAL_GOPT_SET_EMAIL_DEFAULT_ADDRESS' + ACAPO +
			'- GAL_GOPT_SET_EMAIL_ADDRESS_LIST_TO' + ACAPO2 +
		'In deroga al meccanismo automatico, è possibile recuperare via SQL le mail usando la STORED PROCEDURE get_emails_conto()' + ACAPO2 +
		'esempio:' + ACAPO +
			'SELECT get_emails_conto(max(BOL_str_conto), 0)' + ACAPO +
			'FROM bolle KEY JOIN tipi_BDOC' + ACAPO +
			'WHERE ($PARM_WHERE) AND' + ACAPO +
			'((SELECT count(DISTINCT BOL_str_conto) FROM bolle KEY JOIN tipi_BDOC WHERE ($PARM_WHERE)) = 1)', MBOX_CAPTION)
//	SP_FORMATTA_EMAIL = 'formatta_email';	// stored proc che formatta l'email nella forma >>    nome <email@server.it>
//	SP_GET_EMAILS_CONTO = 'get_emails_conto';
end;

procedure Tdlg_impostazioni.set_standard_SMTP(ss : standard_SMTP_services;bo_feaci : boolean = FALSE);
var
	source : cl_SMTP_data;	//*
	str_mail_utente : string;
begin
	if bo_feaci then source := SMTP_feaci else source := get_standard_SMTP_parms(ss);

	str_SMTP_host.Text := source.str_host;
	wo_SMTP_port.Text := source.wo_port.Tostring;
	cbx_SMTP_need_authentication.Checked := source.bo_need_authentication;
	cbx_SMTP_TLS.Checked := source.bo_use_TLS;

	if bo_feaci then begin
		if NOT ask_SMTP_mail_for_feaci_configuration(self, str_mail_utente) then exit;
		str_SMTP_from.Text := source.str_from;
		str_SMTP_auth_ID.Text := source.str_from;
		str_SMTP_password.Text := source.str_auth_pwd;
		str_SMTP_replyto.Text := str_mail_utente;
		str_SMTP_ccn.Text := str_mail_utente;
		messagebbox_explain_SMTP_feaci(self, caption)
	end
	else begin
		var bo_blank := (ss = SSMTPS_BLANK);
		str_SMTP_auth_ID.Color := USER_SMTP_FIELDS_COLOR;
		str_SMTP_password.Color := USER_SMTP_FIELDS_COLOR;
		str_SMTP_from.Color := USER_SMTP_FIELDS_COLOR;
		MessageBBox(handle, 'Impostazioni SMTP ' + STANDARD_SMTP_SERVICES_DESCRIPTION[ss] + ACAPO2 +
			ifs(NOT bo_blank, 'Verifica che i campi evidenziati siano correttamente compilati'), MBOX_CAPTION)
	end
end;

procedure Tdlg_impostazioni.copy_versioni_clipboard;
begin
	str2clipboard(lb_versioni.Items.Text);
	MessageBBox(handle, 'Versioni copiate sulla clipboard', MBOX_CAPTION)
end;

procedure Tdlg_impostazioni.panel_hidden_objects_colorClick(Sender : TObject);
var lo : TColor;
begin
	lo := panel_hidden_objects_color.Font.Color;
	if select_colore(self,lo) then panel_hidden_objects_color.Font.Color := lo
end;

procedure Tdlg_impostazioni.btn_add_link_utenteClick(Sender : TObject);
var s : string;
begin
	if NOT browse_for_files_open(self, 'Aggiungi link utente', s, ALL_FILES_DEFAULT_EXT, ALL_FILES_FILTER, {str_default_dir}'',
		{bo_relative_path}FALSE, {bo_file_must_exist}FALSE) then exit;
	str_links_utente.Lines.add(s)
end;

procedure Tdlg_impostazioni.btn_outlook_configurationClick(Sender : TObject); begin OUTLOOK_config_dialog_proc(self, local_outlook, TRUE) end;

procedure Tdlg_impostazioni.str_macro_descrizione_modify(Sender : TObject);
begin
	var i_index : smallint := (sender as TFEdit).Tag;
	pc_macro.Pages[i_index].Caption := coalesce((sender as TFEdit).Text, macro_tabs[i_index].get_default_tab_caption(i_index))
end;

{$I text_scripts_edit}

procedure Tdlg_impostazioni.AL_colore_symbolico_addExecute(Sender : TObject); begin colore_symbolico_add end;
procedure Tdlg_impostazioni.AL_colore_symbolico_deleteExecute(Sender : TObject); begin colore_symbolico_delete end;
procedure Tdlg_impostazioni.AL_colore_symbolico_sortExecute(Sender : TObject); begin colore_symbolico_sort end;
procedure Tdlg_impostazioni.AL_colore_symbolico_updateExecute(Sender : TObject); begin colore_symbolico_update end;
procedure Tdlg_impostazioni.AL_findExecute(Sender : TObject); begin find end;
procedure Tdlg_impostazioni.AL_find_nextExecute(Sender : TObject); begin find_next end;

function Tdlg_impostazioni.get_active_memo : TMemo;
// rende l'oggetto MEMO della pagina attiva; rende NIL se non esiste
begin
	result := NIL;
	if (pc.ActivePage = page_macro_scripts) then result := macro_tabs[pc_macro.ActivePageIndex].str_text;
	if (pc.ActivePage = page_SQL_scripts) then result := SQL_tabs[pc_SQL.ActivePageIndex].str_text
end;

procedure Tdlg_impostazioni.find;
begin
	var memo : TMemo := get_active_memo;if (memo = NIL) then begin beep;exit end;
	find_dialog.FindText := coalesce(memo.seltext, str_find_text);
	find_dialog.options := FD_DIALOG_OPTIONS;
	find_dialog.execute
end;

procedure Tdlg_impostazioni.find_next;
begin
	if (str_find_text = '') then find else execute_find(str_find_text)
end;

{procedure Tdlg_impostazioni.call_find_dialog;
var memo : TMemo;
begin
	memo := get_active_memo;if (memo = NIL) then begin beep;exit end;
	find_dialog.FindText := coalesce(memo.SelText, str_find_text);
	find_dialog.options := FD_DIALOG_OPTIONS;
	find_dialog.execute
end; }

procedure Tdlg_impostazioni.execute_find(str_find_text : string);
begin
	var memo : TMemo := get_active_memo;if (memo = NIL) then begin beep;exit end;
	str_find_text := uppercase(str_find_text);
	self.str_find_text := str_find_text;
	var i : integer := pos(str_find_text, copy(uppercase(memo.Lines.Text), memo.selstart+1+1, MAXINT));
	if (i = 0) then MessageBBox(handle, str_find_text + ACAPO2 + 'Testo non trovato', MBOX_CAPTION)
	else begin
//		if (pc.ActivePage <> page_note) then begin pc.ActivePage := page_note;my_sleep end;
		if NOT memo.Focused then memo.SetFocus;
		memo.Selstart := memo.Selstart + i -1+1;memo.Sellength := length(str_find_text)
	end
end;

procedure Tdlg_impostazioni.find_dialogFind(Sender : TObject);
begin
	find_dialog.CloseDialog;
	execute_find(find_dialog.FindText)
end;

procedure Tdlg_impostazioni.write_colori_symbolici(i_select_index : smallint = -1);
begin
	lb_colori_symbolici.Items.Clear;
	// la descrizione sull'ITEM non viene decisa qui ma sulla DrawItem()
	for var i : smallint := 0 to local_table_colori_symbolici.Count - 1 do
		lb_colori_symbolici.Items.Add(local_table_colori_symbolici.get_colore(i).str_descrizione);
	if (i_select_index <> -1) then lb_colori_symbolici.ItemIndex := i_select_index
end;

procedure Tdlg_impostazioni.lb_colori_symboliciClick(Sender : TObject);
begin
	var i : smallint := lb_colori_symbolici.ItemIndex;if (i = -1) then exit;
	var col := local_table_colori_symbolici.get_colore(i);
	str_colore_symbolico_nome.Text := col.str_descrizione;
	panel_colore_symbolico.Color := col.lo_colore;
	i_colore_symbolico_pos.Text := col.i_pos.ToString
end;

procedure Tdlg_impostazioni.lb_colori_symboliciDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var lb : TMyListBox absolute Control;
begin
	var col := local_table_colori_symbolici.get_colore(Index);
	var lo_colore : TColor := col.lo_colore;
	var s := ifs(col.i_pos <> 0, '[' + zeri(col.i_pos, 2) + '] ') + col.str_descrizione;
	if (odSelected in state) then begin
		var tr : TRect;
		tr := Rect;tr.Right := (tr.Left + tr.Right) div 2;
		lb.Canvas.FillRect(tr);lb.Canvas.TextRect(rect, s);
		tr := Rect;tr.Left := (tr.Left + tr.Right) div 2;
		lb.Canvas.Brush.Color := lo_colore;lb.Canvas.FillRect(tr)
	end
	else begin
		lb.Canvas.Brush.Color := lo_colore;
		lb.Canvas.FillRect(Rect);lb.Canvas.TextRect(rect, s)
	end
end;

procedure Tdlg_impostazioni.colore_symbolico_add;
var col : colore_symbolico_type;
begin
	col.str_descrizione := str_colore_symbolico_nome.Text;
	col.lo_colore := panel_colore_symbolico.Color;
	col.i_pos := i_colore_symbolico_pos.get_Asinteger(FALSE);
	if NOT local_table_colori_symbolici.validate(handle, col) then exit;
	local_table_colori_symbolici.add(col);
	write_colori_symbolici;
	lb_colori_symbolici.ItemIndex := local_table_colori_symbolici.Count - 1
end;

procedure Tdlg_impostazioni.colore_symbolico_delete;
begin
	var i : smallint := lb_colori_symbolici.ItemIndex;if (i = -1) then begin beep;exit end;
	if (MessageBBox(handle, 'Vuoi eliminare il colore symbolico selezionato?', MBOX_CAPTION, MB_QUESTION_DEFBUTTON2) <> IDYES) then exit;
	local_table_colori_symbolici.delete(i);
	write_colori_symbolici
end;

procedure Tdlg_impostazioni.colore_symbolico_update;
var col : colore_symbolico_type;
begin
	col.str_descrizione := str_colore_symbolico_nome.Text;
	col.lo_colore := panel_colore_symbolico.Color;
	col.i_pos := i_colore_symbolico_pos.get_Asinteger(FALSE);
	var i_ndx : smallint := lb_colori_symbolici.ItemIndex;
	if NOT local_table_colori_symbolici.validate(handle, col, i_ndx) then exit;
	var ptcc : colore_symbolico_punt := local_table_colori_symbolici.get_ptr_colore(i_ndx);
	// se il nome del colore è stato modificato, registro la modifica per trasmetterla al momento del salvataggio
	if (ptcc.str_descrizione <> col.str_descrizione) then begin
		var i : smallint := length(colori_symbolici_modified);
		setLength(colori_symbolici_modified, i+1);
		colori_symbolici_modified[i].str_colore_from := ptcc.str_descrizione;
		colori_symbolici_modified[i].str_colore_to := col.str_descrizione
	end;
	ptcc.assign(col);
	write_colori_symbolici(i_ndx)
end;

procedure Tdlg_impostazioni.panel_color_assignClick(Sender : TObject);
var panel : TFPanel absolute sender;
begin
	var col : TColor := panel.Color;
	if select_colore(self, col) then begin
		panel.Color := col;
//		bo_something_modified := TRUE
	end
end;

procedure Tdlg_impostazioni.colore_symbolico_sort;
begin
	if local_table_colori_symbolici.sort then begin
		write_colori_symbolici;
//		bo_something_modified := TRUE
	end
end;

procedure Tdlg_impostazioni.rb_runtime_help_align_Click(Sender : TObject);
var rb : TFRadio absolute Sender;
begin
	if (rb = rb_runtime_help_align_sx) then txt_runtime_help_example.Alignment := taLeftJustify else
	if (rb = rb_runtime_help_align_dx) then txt_runtime_help_example.Alignment := taRightJustify else
	{if (rb = rb_runtime_help_align_center) then} txt_runtime_help_example.Alignment := taCenter
end;

procedure Tdlg_impostazioni.panel_runtime_help_backgroundClick(Sender : TObject);
begin
	var col : TColor := txt_runtime_help_example.Color;
	if select_colore(self, col) then begin
		txt_runtime_help_example.Color := col;
//		bo_something_modified := TRUE
	end
end;

procedure Tdlg_impostazioni.txt_runtime_help_exampleClick(Sender : TObject);
begin
	var fd := TFontDialog.Create(self);
	try
		fd.font.assign(txt_runtime_help_example.Font);
		if fd.execute then txt_runtime_help_example.Font.assign(fd.font)
	finally
		fd.free
//		bo_something_modified := TRUE
	end
end;

initialization
{$ifdef DEBUG} var i := 27;cin(i); {$endif DEBUG}
	galateo_initialization_debug('impostazioni')
finalization
	galateo_finalization_debug('impostazioni')
end.
