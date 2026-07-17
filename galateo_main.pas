unit galateo_main;	//*

{$I defines}
{$ifdef DLL} *** {$endif}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, Math, Buttons, ExtCtrls, StdCtrls, Menus, Actions, DB, Mask, DBCtrls, ActnList,
	JvSpeedbar, JvExMask, JvSpin, JvExExtCtrls, JvExtComponent, MRUfiles,
	Fcommons, Federico, gdich, objects, panel, proc, sezione;

type
	TGM = class(TForm)
			popup_object: TPopupMenu;
			itp_font: TMenuItem;
			itp_edit_obj: TMenuItem;
			N1: TMenuItem;
			main_menu: TMainMenu;
			itm_file_menu: TMenuItem;
			itm_save: TMenuItem;
			itm_new_report: TMenuItem;
			itm_close: TMenuItem;
			itm_objects_menu: TMenuItem;
			itm_modify: TMenuItem;
			itm_setup: TMenuItem;
			itm_help_menu: TMenuItem;
			itm_about: TMenuItem;
			itm_help: TMenuItem;
			N3: TMenuItem;
			itm_open: TMenuItem;
			itm_print_menu: TMenuItem;
			itm_saveas: TMenuItem;
			itp_delete_obj: TMenuItem;
			N4: TMenuItem;
			itm_database_menu: TMenuItem;
			itm_config_database: TMenuItem;
			itm_close_database: TMenuItem;
			itm_delete_object: TMenuItem;
			itm_insert_text: TMenuItem;
			itm_insert_disegno: TMenuItem;
			sbox: TScrollBox;
			pb_out: TPaintBox;
			popup_section: TPopupMenu;
			itp_sezione: TMenuItem;
			N9: TMenuItem;
			itp_elimina_sezione: TMenuItem;
			itp_nuova_sezione: TMenuItem;
			itp_nome_sezione: TMenuItem;
			N10: TMenuItem;
			N11: TMenuItem;
			itm_section_db_fields: TMenuItem;
			N12: TMenuItem;
			itm_insert_cornice: TMenuItem;
			itm_insert_line: TMenuItem;
			itm_copy: TMenuItem;
			itm_paste: TMenuItem;
			itm_cut: TMenuItem;
			N7: TMenuItem;
			itp_legami_comunitari: TMenuItem;
			N14: TMenuItem;
			itm_columns_sezione: TMenuItem;
			itm_legami_comunitari: TMenuItem;
			N15: TMenuItem;
			N16: TMenuItem;
			itp_new: TMenuItem;
			itp_new_text: TMenuItem;
			itp_new_line: TMenuItem;
			itp_new_rectangle: TMenuItem;
			itp_get_stile_obj: TMenuItem;
			itp_stile_applica: TMenuItem;
			itp_stile_formattazione: TMenuItem;
			itp_stile_font: TMenuItem;
			itp_stile_size: TMenuItem;
			itp_stile_applica_tutto: TMenuItem;
			N17: TMenuItem;
			itp_stile_valori: TMenuItem;
			itm_stile_applica: TMenuItem;
			itm_stile_valori: TMenuItem;
			itm_stile_formattazione: TMenuItem;
			itm_stile_font: TMenuItem;
			itm_stile_size: TMenuItem;
			N20: TMenuItem;
			itm_stile_applica_tutto: TMenuItem;
			itm_copy_style: TMenuItem;
			N21: TMenuItem;
			sbar: TJvSpeedBar;
			sbar_section: TJvSpeedBarSection;
			btn_right: TJvSpeedItem;
			btn_left: TJvSpeedItem;
			btn_down: TJvSpeedItem;
			btn_up: TJvSpeedItem;
			btn_new_text: TJvSpeedItem;
			btn_new_image: TJvSpeedItem;
			btn_new_rectangle: TJvSpeedItem;
			btn_edit: TJvSpeedItem;
			btn_delete: TJvSpeedItem;
			btn_load: TJvSpeedItem;
			btn_save: TJvSpeedItem;
			btn_new_section: TJvSpeedItem;
			btn_remarks: TJvSpeedItem;
			txt_pagina_pre: TLabel;
			i_pagina_logica: TJvSpinEdit;
			txt_pagina_post: TLabel;
			itp_new_image: TMenuItem;
			btn_new_line: TJvSpeedItem;
			itm_save_pagina_logica: TMenuItem;
			itm_impostazioni_menu: TMenuItem;
			itm_setup_pagina_logica: TMenuItem;
			itm_sezione: TMenuItem;
			itm_pagina_logica: TMenuItem;
			itp_elenco_objects: TMenuItem;
			itm_elenco_objects: TMenuItem;
			N5: TMenuItem;
			itm_show_hidden_objects: TMenuItem;
			itm_nuova_sezione: TMenuItem;
			N23: TMenuItem;
			itm_elimina_sezione: TMenuItem;
			btn_font: TJvSpeedItem;
			itm_font: TMenuItem;
			btn_show: TJvSpeedItem;
			itp_stile_formato_numerico: TMenuItem;
			itp_stile_legami_comunitari: TMenuItem;
			itm_stile_legami_comunitari: TMenuItem;
			itm_stile_formato_numerico: TMenuItem;
			itm_inverti_visualizzazione: TMenuItem;
			N24: TMenuItem;
			btn_imposta_pagina: TJvSpeedItem;
			itp_imposta_pagina: TMenuItem;
			btn_lock: TSpeedButton;
			itm_lock_objects: TMenuItem;
			itm_applica_formato: TMenuItem;
			itm_new_pagina_logica: TMenuItem;
			N25: TMenuItem;
			itm_delete_pagina_logica: TMenuItem;
			itm_set_system_operator: TMenuItem;
			N26: TMenuItem;
			itm_dont_write_version: TMenuItem;
			itm_view_debug_log: TMenuItem;
			itp_stile_visualizzazione: TMenuItem;
			itm_stile_visualizzazione: TMenuItem;
			itm_delete_debug_log: TMenuItem;
			itm_modify_info_salvataggio: TMenuItem;
			btn_galrun: TJvSpeedItem;
			itm_galrun: TMenuItem;
			btn_justify_left: TJvSpeedItem;
			panel_info: TPanel;
			txt_info_selezione: TLabel;
			txt_info_page: TLabel;
			itp_stile_height: TMenuItem;
			itp_stile_width: TMenuItem;
			N2: TMenuItem;
			N8: TMenuItem;
			itm_stile_height: TMenuItem;
			itm_stile_width: TMenuItem;
			itm_edit_hidden_section: TMenuItem;
			N28: TMenuItem;
			itm_macro_parametriche: TMenuItem;
			itm_GALRUN_parametri: TMenuItem;
			btn_justify_center: TJvSpeedItem;
			btn_justify_right: TJvSpeedItem;
			itp_copy_object_name: TMenuItem;
			itm_copy_object_name: TMenuItem;
			AL: TActionList;
			AL_copy_object_name: TAction;
			AL_copy_object_style: TAction;
			AL_applica_formato_choose: TAction;
			itp_applica_formato_scegli: TMenuItem;
			btn_send_email: TJvSpeedItem;
			itm_send_via_email: TMenuItem;
			btn_setup_export_integrale: TJvSpeedItem;
			AL_impostazioni_export_integrale: TAction;
			itm_expint_setup: TMenuItem;
			itm_GALRUN_CLIPBOARD: TMenuItem;
			btn_select_only_texts: TJvSpeedItem;
			btn_select_only_graphs: TJvSpeedItem;
			AL_file_open: TAction;
			AL_file_save: TAction;
			AL_file_save_as: TAction;
			MRU: TMRUFiles;
			N29: TMenuItem;
			AL_delete_object: TAction;
			btn_distribuisci_horz: TJvSpeedItem;
			btn_distribuisci_verticale: TJvSpeedItem;
			InserisciNUOVOoggetto1: TMenuItem;
			itm_insert_datamatrix: TMenuItem;
			AL_insert_datamatrix: TAction;
			itp_insert_datamatrix: TMenuItem;
			AL_insert_testo: TAction;
			AL_insert_immagine: TAction;
			AL_insert_cornice: TAction;
			AL_insert_line: TAction;
			btn_insert_datamatrix: TJvSpeedItem;
			AL_clipboard_paste: TAction;
			AL_clipboard_copy: TAction;
			AL_clipboard_cut: TAction;
			txt_open_textpad: TMenuItem;
			AL_text_editor: TAction;
			AL_applica_font_from_sezione: TAction;
			AL_applica_font_to_sezione: TAction;
			itp_applica_font_to_sezione: TMenuItem;
			itp_applica_font_from_sezione: TMenuItem;
			N13: TMenuItem;
			itm_assegna_font_from_sezione: TMenuItem;
			itm_assegna_font_to_sezione: TMenuItem;
			N19: TMenuItem;
			btn_documento_informativo_utente: TJvSpeedItem;
			btn_technical_reference: TJvSpeedItem;
			AL_documento_informativo_utente: TAction;
			AL_technical_reference: TAction;
			itm_documento_informativo_utente: TMenuItem;
			itm_technical_reference: TMenuItem;
			N31: TMenuItem;
			AL_apply_colore_spessore: TAction;
			itp_apply_colore_spessore: TMenuItem;
			itm_apply_colore_spessore: TMenuItem;
			itm_clear_documento_informativo_utente: TMenuItem;
			itm_clear_technical_reference: TMenuItem;
			N32: TMenuItem;
			AL_applica_shift_pos: TAction;
			itm_applica_shift_pos: TMenuItem;
			itp_applica_shift_pos: TMenuItem;
			itm_debug_base: TMenuItem;
			itm_debug_full: TMenuItem;
			itm_report_debug: TMenuItem;
			itm_system_debug_open_report: TMenuItem;
			AL_system_debug_open_report: TAction;
			N27: TMenuItem;
			N33: TMenuItem;
			itm_AVVISO_MRU: TMenuItem;
			btn_set_objects_order: TJvSpeedItem;
			Timer: TTimer;
			AL_apply_font_size: TAction;
			AL_fontsize_aumenta: TAction;
			AL_fontsize_riduci: TAction;
			AL_apply_font: TAction;
			AL_apply_font_color: TAction;
			itp_style_fontsize: TMenuItem;
			itp_style_fontcolor: TMenuItem;
			itm_style_fontcolor: TMenuItem;
			itm_style_fontsize: TMenuItem;
			AL_apply_font_name: TAction;
			itm_apply_style_fontname: TMenuItem;
			itp_apply_style_fontname: TMenuItem;
			AL_open_folder_report: TAction;
			itm_open_folder_report: TMenuItem;
			AL_set_object_order: TAction;
			itm_set_object_order: TMenuItem;
			AL_switch_sfondi: TAction;
			itm_show_sfondi: TMenuItem;
			N18: TMenuItem;
			AL_pagina_logica_edit: TAction;
			AL_nuova_sezione: TAction;
			AL_delete_sezione: TAction;
			AL_edit_hidden_section: TAction;
			AL_elenco_objects: TAction;
			AL_macro_parametriche: TAction;
			AL_modifica_font: TAction;
			AL_legami_comunitari: TAction;
			AL_show_hidden_objects: TAction;
			AL_inverti_visualizzazione: TAction;
			AL_stile_visualizzazione: TAction;
			AL_stile_legami_comunitari: TAction;
			AL_impostazioni: TAction;
			AL_imposta_pagina: TAction;
			AL_save_pagina_logica: TAction;
			AL_edit_selected_section: TAction;
			AL_lock_objects: TAction;
			AL_about: TAction;
			AL_help: TAction;
			AL_database_config: TAction;
			AL_columns_sezione: TAction;
			AL_GALRUN_execute: TAction;
			AL_GALRUN_parametri: TAction;
			AL_GALRUN_clipboard: TAction;
			AL_stile_applica_tutto: TAction;
			AL_stile_size_width: TAction;
			AL_stile_size_all: TAction;
			AL_stile_size_height: TAction;
			SYSTEMdebug1: TMenuItem;
			itm_system_debug_open_folder: TMenuItem;
			itm_system_debug_copy_filename: TMenuItem;
			AL_system_debug_open_folder: TAction;
			AL_system_debug_copy_filename: TAction;
    itm_filename_copy: TMenuItem;
    AL_report_filename_copy: TAction;
			procedure FormCreate(Sender : TObject);
			procedure FormDblClick(Sender : TObject);
			procedure btn_editClick(Sender : TObject);
			procedure btn_file_openClick(Sender : TObject);
			procedure itp_edit_objClick(Sender : TObject);
			procedure itm_new_reportClick(Sender : TObject);
			procedure itm_closeClick(Sender : TObject);
			procedure itm_modifyClick(Sender : TObject);
			procedure itm_close_databaseClick(Sender : TObject);
			procedure pb_outPaint(Sender : TObject);
			procedure FormCloseQuery(Sender : TObject;var CanClose : Boolean);
			procedure FormClose(Sender : TObject;var Action : TCloseAction);
			procedure pb_outDblClick(Sender : TObject);
			procedure FormResize(Sender : TObject);
			procedure itm_section_db_fieldsClick(Sender : TObject);
			procedure itp_nome_sezioneClick(Sender : TObject);
			procedure FormKeyUp(Sender : TObject;var Key : Word;Shift : TShiftState);
			procedure FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
			procedure FormDestroy(Sender : TObject);
			procedure btn_allinea_topClick(Sender : TObject);
			procedure btn_allinea_bottomClick(Sender : TObject);
			procedure btn_allinea_leftClick(Sender : TObject);
			procedure btn_allinea_rightClick(Sender : TObject);
			procedure itm_stile_formattazioneClick(Sender : TObject);
			procedure itm_stile_valoriClick(Sender : TObject);
			procedure popup_objectPopup(Sender : TObject);
			procedure itm_objects_menuClick(Sender : TObject);
			procedure btn_remarksMousemove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
			procedure btn_remarksClick(Sender : TObject);
			procedure i_pagina_logicaChange(Sender : TObject);
			procedure i_pagina_logicaEnter(Sender : TObject);
			procedure popup_sectionPopup(Sender : TObject);
			procedure btn_showClick(Sender : TObject);
			procedure itm_stile_formato_numericoClick(Sender : TObject);
			procedure btn_imposta_paginaClick(Sender : TObject);
			procedure itm_new_pagina_logicaClick(Sender : TObject);
			procedure itm_delete_pagina_logicaClick(Sender : TObject);
			procedure itm_set_system_operatorClick(Sender : TObject);
			procedure itm_dont_write_versionClick(Sender : TObject);
			procedure itm_view_debug_logClick(Sender : TObject);
			procedure itm_delete_debug_logClick(Sender : TObject);
			procedure itm_modify_info_salvataggioClick(Sender : TObject);
			procedure btn_galrunClick(Sender : TObject);
			procedure itp_new_textClick(Sender : TObject);
			procedure itp_new_imageClick(Sender : TObject);
			procedure itp_new_lineClick(Sender : TObject);
			procedure itp_new_rectangleClick(Sender : TObject);
			procedure btn_justify_leftClick(Sender : TObject);
			procedure btn_justify_centerClick(Sender : TObject);
			procedure btn_justify_rightClick(Sender : TObject);
			procedure AL_copy_object_nameExecute(Sender : TObject);
			procedure AL_copy_object_styleExecute(Sender : TObject);
			procedure AL_applica_formato_chooseExecute(Sender : TObject);
			procedure btn_send_emailClick(Sender : TObject);
			procedure itm_send_via_emailClick(Sender : TObject);
			procedure AL_impostazioni_export_integraleExecute(Sender : TObject);
			procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
			procedure btn_select_only_textsClick(Sender : TObject);
			procedure btn_select_only_graphsClick(Sender : TObject);
			procedure AL_file_openExecute(Sender : TObject);
			procedure AL_file_saveExecute(Sender : TObject);
			procedure AL_file_save_asExecute(Sender : TObject);
			procedure MRUClick(Sender: TObject; const FileName: String);
			procedure AL_delete_objectExecute(Sender : TObject);
			procedure btn_distribuisci_horzClick(Sender : TObject);
			procedure btn_distribuisci_verticaleClick(Sender : TObject);
			procedure AL_insert_datamatrixExecute(Sender : TObject);
			procedure itp_insert_datamatrixClick(Sender : TObject);
			procedure AL_insert_testoExecute(Sender : TObject);
			procedure AL_insert_immagineExecute(Sender : TObject);
			procedure AL_insert_corniceExecute(Sender : TObject);
			procedure AL_insert_lineExecute(Sender : TObject);
			procedure AL_clipboard_copyExecute(Sender : TObject);
			procedure AL_clipboard_pasteExecute(Sender : TObject);
			procedure AL_clipboard_cutExecute(Sender : TObject);
			procedure AL_text_editorExecute(Sender : TObject);
			procedure AL_applica_font_from_sezioneExecute(Sender : TObject);
			procedure AL_applica_font_to_sezioneExecute(Sender : TObject);
			procedure AL_documento_informativo_utenteExecute(Sender : TObject);
			procedure AL_technical_referenceExecute(Sender : TObject);
			procedure AL_apply_colore_spessoreExecute(Sender : TObject);
			procedure itm_clear_documento_informativo_utenteClick(Sender : TObject);
			procedure itm_clear_technical_referenceClick(Sender : TObject);
			procedure AL_applica_shift_posExecute(Sender : TObject);
			procedure itm_debug_baseClick(Sender : TObject);
			procedure itm_debug_fullClick(Sender : TObject);
			procedure AL_system_debug_open_reportExecute(Sender : TObject);
			procedure TimerTimer(Sender : TObject);
			procedure AL_apply_font_sizeExecute(Sender : TObject);
			procedure AL_fontsize_aumentaExecute(Sender : TObject);
			procedure AL_fontsize_riduciExecute(Sender : TObject);
			procedure AL_apply_fontExecute(Sender : TObject);
			procedure AL_apply_font_colorExecute(Sender : TObject);
			procedure AL_apply_font_nameExecute(Sender : TObject);
			procedure AL_open_folder_reportExecute(Sender : TObject);
			procedure AL_set_object_orderExecute(Sender : TObject);
			procedure AL_switch_sfondiExecute(Sender : TObject);
			procedure AL_pagina_logica_editExecute(Sender : TObject);
			procedure AL_nuova_sezioneExecute(Sender : TObject);
			procedure AL_delete_sezioneExecute(Sender : TObject);
			procedure FormDeactivate(Sender : TObject);
			procedure FormActivate(Sender : TObject);
			procedure AL_edit_hidden_sectionExecute(Sender : TObject);
			procedure AL_elenco_objectsExecute(Sender : TObject);
			procedure AL_modifica_fontExecute(Sender : TObject);
			procedure AL_legami_comunitariExecute(Sender : TObject);
			procedure AL_show_hidden_objectsExecute(Sender : TObject);
			procedure AL_inverti_visualizzazioneExecute(Sender : TObject);
			procedure AL_stile_visualizzazioneExecute(Sender : TObject);
			procedure AL_stile_legami_comunitariExecute(Sender : TObject);
			procedure AL_impostazioniExecute(Sender : TObject);
			procedure AL_imposta_paginaExecute(Sender : TObject);
			procedure AL_save_pagina_logicaExecute(Sender : TObject);
			procedure AL_edit_selected_sectionExecute(Sender : TObject);
			procedure AL_lock_objectsExecute(Sender : TObject);
			procedure AL_aboutExecute(Sender : TObject);
			procedure AL_helpExecute(Sender : TObject);
			procedure AL_database_configExecute(Sender : TObject);
			procedure AL_columns_sezioneExecute(Sender : TObject);
			procedure AL_GALRUN_executeExecute(Sender : TObject);
			procedure AL_GALRUN_parametriExecute(Sender : TObject);
			procedure AL_GALRUN_clipboardExecute(Sender : TObject);
			procedure AL_stile_applica_tuttoExecute(Sender : TObject);
			procedure AL_stile_size_allExecute(Sender : TObject);
			procedure AL_stile_size_widthExecute(Sender : TObject);
			procedure AL_stile_size_heightExecute(Sender : TObject);
			procedure AL_system_debug_open_folderExecute(Sender : TObject);
			procedure AL_system_debug_copy_filenameExecute(Sender : TObject);
    procedure AL_report_filename_copyExecute(Sender: TObject);
		private
			dtt_reset_info_selezione : TDatetime;
			procedure objects_order_execute;
			procedure delete_sezione;
		private
			bo_modified_phisical : boolean;
			bo_modified_rimandato : boolean;		// è stato modificato lo stato MODIFIED, ma l'applicazione è stata rimandata per motivi grafici
			procedure set_modified(bo : boolean);
			procedure callback_form_activation(bo_activate : boolean);
		private
			y_zero : smallint;			// dimensione del caption + menu + pannello bottoni
			i_setting_pagina_logica : logical_page_type;
			object_style_ref : objs_type;	// oggetto di cui si copia lo style
			i_last_stile_applicato : smallint;
			pos_popup_menu : TPoint;	// posizione in cui si è tirato giu' il popup
			ws_previous : TWindowState;
			bo_save_without_ask : boolean;
			str_logical_page_info : string;		// informazioni sulla pagina logica corrente
			sstore : TStrings;
			procedure add_section;
			procedure adegua_text_only;
			procedure applica_formato_choose;
			procedure applica_formato(wo_style : word);
			procedure delete_selected_objects;
			procedure edita_font(i_obj : obj_index_type);
			procedure set_justify(ta : TAlignMent;{box_giustificato : xboolean;}i_obj : obj_index_type = -1);
			procedure edita_obj(i_obj : obj_index_type);
			procedure edita_legami_comunitari(i_obj : obj_index_type);
			procedure galrun_execute;
			procedure galrun_parametri(bo_clipboard : boolean);
			function galrun_get_linea_comando(bo_assegna_valore_parametri : boolean;bo_executable : boolean = TRUE;bo_parametri : boolean = TRUE) : string;
			procedure imposta_pagina;
			procedure impostazioni_proc;
			procedure insert_delete_pagina_logica(bo_insert : boolean);
			procedure inverti_modalita_visualizzazione;
			procedure log_file_open;
			procedure log_file_delete;
			procedure pb_out_paint;
			procedure send_report_via_email;
			procedure set_applica_stile_menu_items;
			procedure set_pagina_logica_values;
			procedure enable_ctrls;
			procedure open_text_editor;
			procedure save;
			procedure nuovo_oggetto(tipo : obj_type;bo_from_popup : boolean);
			function	set_pagina_logica(i_new_pagina : logical_page_type;bo_update_indicatore : boolean;
				bo_forza_esecuzione : boolean = FALSE) : logical_page_type;
			procedure update_status_hidden_objects;
//			procedure wm_syscomm(var m:TMessage); message WM_SYSCOMMAND;
			procedure select_and_edit_section;
			procedure space_equally(bo_horz : boolean);
			procedure applica_font_from_sezione;
			procedure applica_font_to_sezione;
			procedure open_documento_info(var str_filename : string;str_default_ext, str_filter : string);
		public
			bo_dont_select_texts, bo_dont_select_graphics_objs : boolean;
			{$ifdef DEBUG} dt_last_debug_info : TDatetime; {$endif}		// datetime in cui è stato mostrato l'ultimo messaggio di debug
			property bo_modified : boolean read bo_modified_phisical write set_modified;
			procedure set_system_operator(bo_ask_password : boolean);
			procedure dont_write_version;
			procedure set_disegno_values;
			function load_file(str_filename : string) : boolean;
			procedure update_info_selection{$ifdef DEBUG}(str_debug_msg : string = ''){$endif};
			constructor xxcreate(father : TForm;bo_dll : boolean);
			function registra_MRU(str_filename : string) : boolean;
  end;

var GM : TGM;	// Galateo Main
//function controllo : TControllo;
{$ifdef DEBUG} procedure visual_debug(s : string;s2 : string = '';s3 : string = ''); {$endif}

implementation

{$R *.DFM}

uses FAssert, FDebug, FXStrings, FStrings, FErrMsg, help, FMessage, FSystem_base, FSystem, FCtrls, FProcs, FFile, FBrowse, Fdata, FTime,
	wproc, galateo_debug, about, fields, input_dialog, domanda_multipla, Fmail,
	legami, impostazioni, pagina_logica_edit, sezione_edit, objs_elenco, expint_profilo_elenco, Gun, labels, misure, pages, galateo_api;

const
	MRU_REGISTRY_KEY = 'Software\Galateo\MRU';		// Most Recent Files (gestione privata di Galateo, niente a che fare con Windows)

{$ifdef DEBUG} var i_GMs : integer; {$endif}

(*function controllo : Tcontrollo;
begin
//	result := globale.get_controllo
	result := phis_controllo
end;*)

constructor TGM.xxcreate(father : TForm;bo_dll : boolean);
begin
	{$ifdef DEBUG} inc(i_GMs); {$endif}
	inherited create(father);
//	visible := NOT bo_dll
end;

procedure TGM.FormCreate(Sender : TObject);
begin
	constraints.MinWidth := sbar.Width + 10;
	constraints.MinHeight := sbar.Height * (1+2);
//	icon := application.icon;
	btn_font.BtnCaption := '';

	wx := cl_form_manager.create(self, {itm_windows_menu}NIL, {MDB}NIL, callback_form_activation);

	set_modified(FALSE);
	y_zero := GetSystemMetrics(SM_CYCAPTION) + GetSystemMetrics(SM_CYMENU) + sbar.Height;
	if NOT tm.init_video_values(getDC(Handle), 1) then begin
		MessageBBox(handle, 'Impossibile inizializzare il sistema di misura', MBOX_CAPTION, MB_ICONSTOP);
		halt
	end;

	pb_out.Align := alClient;
	for var i_ZB : smallint := 0 to MAX_PAGINE_LOGICHE-1 do begin
		set_pagina_logica_attiva_ZB(i_ZB, FALSE);
		for var j_ZB : smallint := MAIN_SECTION_ZB to MAX_SECTIONS - 1 do
			assign_panel_ZB(j_ZB, Tgalpanel.xcreate(self, sbox, j_ZB + 1, j_ZB = MAIN_SECTION_ZB))
	end;
	set_pagina_logica_attiva_ZB(0, FALSE);	// FALSE! perchè self non esiste ancora
//	set_disegno_values;
//	itm_debug_full.Checked := globale.bo_debug_base;		NON ATTIVATO perchè si eseguono assegnazioni/disattivazioni non necessariamente desiderate
//	itm_debug_base.Checked := globale.bo_debug_full;
	MRU.LoadFromRegistry(MRU_REGISTRY_KEY);
	{ API di authoring PRIMA del caricamento del report: TGlobale.load e' interattivo e le sue modali
	  bloccherebbero l'avvio del server. Finche' GLOBALE e' NIL i comandi rispondono ok:false.
	  Il server e' acceso di default: si spegne solo con /NOAPI }
	api_start_default;
	globale := Tglobale.create_galateo(self);
	set_disegno_values;
	windowstate := wsMaximized
//	{$ifdef DEBUG} check_components(self) {$endif DEBUG}			**** tanto FALSE messages
end;

procedure TGM.FormDestroy(Sender : TObject);
begin
	{$ifdef DEBUG} dec(i_GMs); {$endif}
	api_stop;		// PRIMA di liberare GLOBALE: il thread della pipe potrebbe avere una richiesta in corso
	globale.Freex;		// viene eseguito qui sulla variabile locale GLOBALE; se DLL funziona in altro modo
	globale := NIL
end;

procedure TGM.callback_form_activation(bo_activate : boolean);
begin
	bo_activate := TRUE; {$ifNdef DEBUG} *** {$endif DEBUG}
end;

procedure TGM.FormActivate(Sender : TObject);
begin
	AL.State := asNormal;
	if bo_modified_rimandato then bo_modified := TRUE;
	if (sstore <> NIL) then tratta_shortcuts_menu(main_menu, {read_shortcuts}FALSE, sstore)
end;

procedure TGM.FormDeactivate(Sender : TObject);
begin
	AL.State := asSuspended;
	// disattivo gli shortcuts, soprattutto per il caso che la ChildWindow NON abbia un suo menu, e quindi continui ad usare gli shortcuts della main form
	tratta_shortcuts_menu(main_menu, {read_shortcuts}TRUE, sstore)
end;

procedure TGM.FormClose(Sender : TObject;var Action : TCloseAction);
begin
	globale.FormClose(self);		// operazioni eseguite if NOT DLL
	Action := caFree
end;

procedure TGM.AL_file_save_asExecute(Sender : TObject);
begin
//	if globale.save('') then begin MRU.Add(globale.str_filename);MRU.SaveToRegistry(MRU_REGISTRY_KEY) end
	if globale.save('') then registra_MRU(globale.str_filename)
end;

function TGM.registra_MRU(str_filename : string) : boolean;
begin
	try
		MRU.Add(globale.str_filename);
		MRU.SaveToRegistry(MRU_REGISTRY_KEY);
		result := TRUE
	except
		result := FALSE
	end
end;

function TGM.load_file(str_filename : string) : boolean;
begin
	result := globale.load(self, str_filename);
//	if result then begin MRU.Add(globale.str_filename);MRU.SaveToRegistry(MRU_REGISTRY_KEY) end
	if result then registra_MRU(globale.str_filename)
end;

procedure TGM.MRUClick(Sender: TObject; const FileName: String);
begin
	if (filename <> '') AND (filename = globale.str_filename) then begin
		MessageBBox(handle, 'Il file è già aperto', MBOX_CAPTION);		// si potrebbe verificare se è lo stesso, se è stato modificato, ....
		exit
	end;
//	globale.load(filename)
	load_file(filename)
end;

procedure TGM.AL_file_openExecute(Sender : TObject); begin load_file('') end;
procedure TGM.AL_file_saveExecute(Sender : TObject); begin save end;
procedure TGM.AL_impostazioniExecute(Sender : TObject); begin impostazioni_proc end;
procedure TGM.AL_impostazioni_export_integraleExecute(Sender : TObject); begin {exportazione_integrale_setup_proc(self)}expint_profilo_elenco_proc(self) end;
procedure TGM.AL_imposta_paginaExecute(Sender : TObject); begin imposta_pagina end;
procedure TGM.AL_copy_object_styleExecute(Sender : TObject); begin object_style_ref := get_selected_obj(0) end;
procedure TGM.AL_database_configExecute(Sender : TObject); begin globale.set_connessione_database end;
procedure TGM.AL_delete_objectExecute(Sender : TObject); begin delete_selected_objects end;
procedure TGM.AL_delete_sezioneExecute(Sender : TObject); begin delete_sezione end;
procedure TGM.btn_file_openClick(Sender : TObject); begin globale.load(self, '') end;
procedure TGM.itp_edit_objClick(Sender : TObject); begin edita_obj(get_selected_obj_index(0)) end;
procedure TGM.btn_editClick(Sender : TObject); begin edita_obj(get_selected_obj_index(0)) end;
procedure TGM.FormDblClick(Sender : TObject); begin impostazioni_proc end;
procedure TGM.pb_outDblClick(Sender : TObject); begin impostazioni_proc end;
procedure TGM.itm_new_reportClick(Sender : TObject); begin globale.nuova_etichetta end;
procedure TGM.itm_closeClick(Sender : TObject); begin close end;
procedure TGM.itm_modifyClick(Sender : TObject); begin edita_obj(get_selected_obj_index(0)) end;
procedure TGM.itm_close_databaseClick(Sender : TObject); begin globale.system_database.Connected := FALSE end;
procedure TGM.AL_clipboard_copyExecute(Sender : TObject); begin copy_clipboard(0) end;
procedure TGM.AL_clipboard_pasteExecute(Sender : TObject); begin paste_clipboard end;
procedure TGM.AL_clipboard_cutExecute(Sender : TObject); begin cut_clipboard(get_selected_obj_index(0)) end;
procedure TGM.pb_outPaint(Sender : TObject); begin pb_out_paint end;
procedure TGM.itp_nome_sezioneClick(Sender : TObject); begin edit_section_ZB(get_section_attiva_ZB, FALSE) end;
procedure TGM.btn_allinea_topClick(Sender : TObject); begin set_all_selected(SET_SEL_TOP,0,NIL) end;
procedure TGM.btn_allinea_bottomClick(Sender : TObject); begin set_all_selected(SET_SEL_BOTTOM,0,NIL) end;
procedure TGM.btn_allinea_leftClick(Sender : TObject); begin set_all_selected(SET_SEL_LEFT,0,NIL) end;
procedure TGM.btn_allinea_rightClick(Sender : TObject); begin set_all_selected(SET_SEL_RIGHT,0,NIL) end;
procedure TGM.AL_apply_fontExecute(Sender : TObject); begin applica_formato(STYLE_FONT) end;
procedure TGM.AL_apply_font_nameExecute(Sender : TObject); begin applica_formato(STYLE_FONTNAME) end;
procedure TGM.AL_apply_font_sizeExecute(Sender : TObject); begin applica_formato(STYLE_FONTSIZE) end;
procedure TGM.AL_apply_font_colorExecute(Sender : TObject); begin applica_formato(STYLE_FONTCOLOR) end;
procedure TGM.itm_stile_formattazioneClick(Sender : TObject); begin applica_formato(STYLE_FORMATTATION) end;
procedure TGM.itm_stile_valoriClick(Sender : TObject); begin applica_formato(STYLE_VALUES) end;
procedure TGM.itm_stile_formato_numericoClick(Sender : TObject); begin applica_formato(STYLE_FORMATO_NUMERICO) end;
procedure TGM.AL_stile_applica_tuttoExecute(Sender : TObject); begin applica_formato(STYLE_ALL) end;
procedure TGM.AL_stile_legami_comunitariExecute(Sender : TObject); begin applica_formato(STYLE_LEGAMI_COMUNITARI) end;
procedure TGM.AL_stile_size_allExecute(Sender : TObject); begin applica_formato(STYLE_SIZE) end;
procedure TGM.AL_stile_size_heightExecute(Sender : TObject); begin applica_formato(STYLE_HEIGHT) end;
procedure TGM.AL_stile_size_widthExecute(Sender : TObject); begin applica_formato(STYLE_WIDTH) end;
procedure TGM.popup_objectPopup(Sender : TObject); begin set_applica_stile_menu_items end;
procedure TGM.AL_insert_testoExecute(Sender : TObject); begin nuovo_oggetto(LABEL_OBJ, FALSE) end;
procedure TGM.AL_inverti_visualizzazioneExecute(Sender : TObject); begin inverti_modalita_visualizzazione end;
procedure TGM.AL_legami_comunitariExecute(Sender : TObject); begin edita_legami_comunitari(get_selected_obj_index(0)) end;
procedure TGM.AL_lock_objectsExecute(Sender : TObject); begin btn_lock.Down := NOT btn_lock.Down end;
procedure TGM.AL_modifica_fontExecute(Sender : TObject); begin edita_font(-1{get_selected_obj_index(0)}) end;
procedure TGM.AL_nuova_sezioneExecute(Sender : TObject); begin add_section end;
procedure TGM.itp_new_textClick(Sender : TObject); begin nuovo_oggetto(LABEL_OBJ, TRUE) end;
procedure TGM.AL_insert_immagineExecute(Sender : TObject); begin nuovo_oggetto(OBJ_BITMAP, FALSE) end;
procedure TGM.itp_new_imageClick(Sender : TObject); begin nuovo_oggetto(OBJ_BITMAP, TRUE) end;
procedure TGM.AL_insert_corniceExecute(Sender : TObject); begin nuovo_oggetto(OBJ_RECT, FALSE) end;
procedure TGM.itp_new_rectangleClick(Sender : TObject); begin nuovo_oggetto(OBJ_RECT,TRUE) end;
procedure TGM.AL_insert_lineExecute(Sender : TObject); begin nuovo_oggetto(OBJ_LINE, FALSE) end;
procedure TGM.itp_new_lineClick(Sender : TObject); begin nuovo_oggetto(OBJ_LINE, TRUE) end;
procedure TGM.AL_insert_datamatrixExecute(Sender : TObject); begin nuovo_oggetto(DATAMATRIX_OBJ, FALSE) end;
procedure TGM.itp_insert_datamatrixClick(Sender : TObject); begin nuovo_oggetto(DATAMATRIX_OBJ, TRUE) end;
procedure TGM.itm_objects_menuClick(Sender : TObject); begin if (get_num_selected_objects <> 0) then set_applica_stile_menu_items end;
procedure TGM.btn_showClick(Sender : TObject); begin inverti_modalita_visualizzazione end;
procedure TGM.AL_edit_hidden_sectionExecute(Sender : TObject); begin select_and_edit_section end;
procedure TGM.AL_edit_selected_sectionExecute(Sender : TObject); begin edit_section_ZB(get_section_attiva_ZB, FALSE) end;
procedure TGM.AL_elenco_objectsExecute(Sender : TObject); begin elenco_objs_proc(self, get_section_attiva_1B) end;
procedure TGM.imposta_pagina; begin edit_section_ZB(MAIN_SECTION_ZB, TRUE) end;
procedure TGM.btn_imposta_paginaClick(Sender : TObject); begin imposta_pagina end;
procedure TGM.itm_new_pagina_logicaClick(Sender : TObject); begin insert_delete_pagina_logica(TRUE) end;
procedure TGM.itm_delete_pagina_logicaClick(Sender : TObject); begin insert_delete_pagina_logica(FALSE) end;
procedure TGM.itm_set_system_operatorClick(Sender : TObject); begin set_system_operator(TRUE) end;
procedure TGM.AL_applica_formato_chooseExecute(Sender : TObject); begin applica_formato_choose end;
procedure TGM.AL_stile_visualizzazioneExecute(Sender : TObject); begin applica_formato(STYLE_VISUALIZZAZIONE) end;
procedure TGM.itm_dont_write_versionClick(Sender : TObject); begin dont_write_version end;
procedure TGM.itm_view_debug_logClick(Sender : TObject); begin log_file_open end;
procedure TGM.itm_delete_debug_logClick(Sender : TObject); begin log_file_delete end;
procedure TGM.btn_galrunClick(Sender : TObject); begin galrun_execute end;
procedure TGM.AL_GALRUN_executeExecute(Sender : TObject); begin galrun_execute end;
procedure TGM.AL_GALRUN_parametriExecute(Sender : TObject); begin galrun_parametri(FALSE) end;
procedure TGM.AL_GALRUN_clipboardExecute(Sender : TObject); begin galrun_parametri(TRUE) end;
procedure TGM.btn_justify_leftClick(Sender : TObject); begin set_justify(taLeftJustify) end;
procedure TGM.btn_justify_centerClick(Sender : TObject); begin set_justify(taCenter) end;
procedure TGM.btn_justify_rightClick(Sender : TObject); begin set_justify(taRightJustify) end;
procedure TGM.btn_send_emailClick(Sender : TObject); begin send_report_via_email end;
procedure TGM.itm_send_via_emailClick(Sender : TObject); begin send_report_via_email end;
procedure TGM.btn_distribuisci_horzClick(Sender : TObject); begin space_equally(TRUE) end;
procedure TGM.btn_distribuisci_verticaleClick(Sender : TObject); begin space_equally(FALSE) end;
procedure TGM.AL_text_editorExecute(Sender : TObject); begin open_text_editor end;
procedure TGM.AL_aboutExecute(Sender : TObject); begin about_proc(self) end;
procedure TGM.AL_applica_font_from_sezioneExecute(Sender : TObject); begin applica_font_from_sezione end;
procedure TGM.AL_columns_sezioneExecute(Sender : TObject); begin sections_ZB(get_section_attiva_ZB).open_database_fields end;
procedure TGM.AL_applica_font_to_sezioneExecute(Sender : TObject); begin applica_font_to_sezione end;
procedure TGM.AL_apply_colore_spessoreExecute(Sender : TObject); begin applica_formato(STYLE_COLORE_SPESSORE_LINEA) end;
procedure TGM.AL_applica_shift_posExecute(Sender : TObject); begin applica_formato(STYLE_SHIFT_POS) end;
procedure TGM.itm_section_db_fieldsClick(Sender : TObject); begin sections_ZB(get_section_attiva_ZB).open_database_fields end;
procedure TGM.applica_formato(wo_style : word); begin set_all_selected(SET_SEL_APPLICA_STYLE, wo_style, object_style_ref) end;
procedure TGM.i_pagina_logicaEnter(Sender : TObject); begin activecontrol := NIL end;
procedure TGM.btn_remarksClick(Sender : TObject); begin MessageBBox(handle, globale.tstr_remarks.Text, '*** REMARKS ***') end;
procedure TGM.AL_helpExecute(Sender : TObject); begin default_help_proc(self) end;
procedure TGM.AL_pagina_logica_editExecute(Sender : TObject); begin if pagina_logica_edit_proc(self, TRUE) then bo_modified := TRUE  end;
procedure TGM.AL_set_object_orderExecute(Sender : TObject); begin objects_order_execute end;
procedure TGM.AL_system_debug_open_reportExecute(Sender : TObject); begin open_local_file_debug(handle) end;
procedure TGM.AL_system_debug_open_folderExecute(Sender : TObject); begin explorer_select_filename(handle, get_filename_debug_local(FALSE)) end;

procedure TGM.AL_report_filename_copyExecute(Sender: TObject);
begin
	str2clipboard(globale.str_filename);
	MessageBBox(handle, 'Nome del report copiato' + ACAPO2 + globale.str_filename, MBOX_CAPTION)
end;

procedure TGM.AL_system_debug_copy_filenameExecute(Sender : TObject);
begin
	var str_filename := get_filename_debug_local(FALSE);
	str2clipboard(str_filename);
	MessageBBox(handle, 'Nome del file di debug copiato' + ACAPO2 + str_filename, MBOX_CAPTION)
end;

procedure TGM.AL_documento_informativo_utenteExecute(Sender : TObject);
begin open_documento_info(globale.str_documento_informativo_utente, DOC_INFO_UTENTE_DEFAULT_EXT, DOC_INFO_UTENTE_FILTER) end;

procedure TGM.AL_technical_referenceExecute(Sender : TObject);
begin open_documento_info(globale.str_technical_reference, TECHNICAL_REFERENCE_DEFAULT_EXT, TECHNICAL_REFERENCE_FILTER) end;

procedure TGM.FormCloseQuery(Sender : TObject;var CanClose : Boolean);
begin
	CanClose := FALSE;
//	if NOT wx.check_count(self, 'Chiudi tutte le finestre aperte') then exit;
	if NOT wx.can_close_application('Impossibile chiudere GALATEO') then exit;
	if bo_modified then begin
		var bo_save : boolean := TRUE;
		if NOT bo_save_without_ask then begin
			bo_save := FALSE;
			case MessageBBox(handle, 'Vuoi salvare le modifiche?', MBOX_CAPTION, MB_QUESTION) of
				IDYES: bo_save := TRUE;
				IDNO: ;
				IDCANCEL : exit
			end
		end;
		if bo_save AND NOT globale.save(globale.str_filename, NOT bo_save_without_ask) then exit;
		bo_modified := FALSE
//		bo_save_without_ask := FALSE
	end;
	if globale.bo_debug_base AND NOT bo_save_without_ask AND
		(MessageBBox(handle, DEBUG_MSG[globale.bo_debug_full] + ifs(globale.str_debug_computer, ' [' + globale.str_debug_computer + ']') + ACAPO2 +
			'Vuoi chiudere davvero?', MBOX_CAPTION, MB_QUESTION_DEF2) <> IDYES)
	then exit;
	CanClose := TRUE
end;

procedure TGM.FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
const KEYS = [VK_RETURN, VK_ESCAPE, VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN, VK_PRIOR, VK_NEXT, VK_HOME, VK_END];
var i : smallint;	//*

	function get_unit(bo_orizzontale : boolean) : smallint;
	begin
		if globale.bo_text_only then begin
			if bo_orizzontale then result := tm.i_text_only_char_video_pixel_x
			else result := globale.i_griglia_vtabs;
			if ssctrl in shift then result := 3 * result
		end
		else
			if ssctrl in shift then result := globale.i_griglia_vtabs
			else result := 1
	end;

begin
{	case key of		// tasti normali
		word('C') : begin
			if is_key_down(VK_CONTROL) then itm_copy.click;
			exit
		end;
		word('V') : begin
			if is_key_down(VK_CONTROL) then itm_paste.click;
			exit
		end
	end; }

	if NOT (key in KEYS) then exit;

	if (key in [VK_PRIOR, VK_NEXT, VK_HOME, VK_END]) then begin
//		if NOT (ssCtrl in shift) then exit;		*** commentata 2023-11-05
		case key of
			VK_PRIOR: i := get_pagina_logica_attiva_1B - 1;
			VK_NEXT: i := get_pagina_logica_attiva_1B + 1;
			VK_END : i := get_ultima_pagina_logica;
			VK_HOME : i := 1
			else i := 0
		end;
		if (i <> 0) then set_pagina_logica(i, TRUE);
		exit
	end;

	i := get_selected_obj_index(0);
	if (i = 0) then begin beep(0);exit end;
	case key of
		VK_RETURN: begin
			if (get_num_selected_objects > 1) then begin beep(0);exit end;		// 1 solo obj per volta
			if (ssAlt in shift) then edita_legami_comunitari(i) else
			if (ssShift in shift) then edita_font(-1{i})
			else edita_obj(i);
			exit
		end;
		VK_ESCAPE: begin xobjs(i, get_pagina_logica_attiva_1B).esc;exit end
	end;

	// eseguo per ogni oggetto selezionato
	for i := 1 to get_num_selected_objects do with get_selected_obj(i) do begin
		if (ssShift in shift) then begin
			if (key in [VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN]) AND (ca.tipo_oggetto = LABEL_OBJ) then aslabel.AutoSize := FALSE;
			case key of
				VK_LEFT: if (get_width > get_unit(TRUE)-1) then begin
					set_width(get_width - get_unit(TRUE));bo_modified := TRUE
				end;
				VK_RIGHT: if (get_left + get_width + get_unit(TRUE)-1 < i_Vpage_size_X_pix_video(get_pagina_logica_attiva_1B)) then begin
					set_width(get_width + get_unit(TRUE));bo_modified := TRUE
				end;
				VK_UP: if (get_height > get_unit(FALSE)-1) then begin
					set_height(get_height - get_unit(FALSE));bo_modified := TRUE
				end;
				VK_DOWN: if (get_top + get_height + get_unit(FALSE)-1 < i_Vpage_size_Y_pix_video(get_pagina_logica_attiva_1B)) then begin
					set_height(get_height + get_unit(FALSE));bo_modified := TRUE
				end
			end
		end
		else begin
			case key of
				VK_LEFT: if (get_left > get_unit(TRUE)-1) then begin set_left(get_left-get_unit(TRUE));bo_modified := TRUE end;
				VK_RIGHT: if (get_left + get_width + get_unit(TRUE) - 1 < i_Vpage_size_X_pix_video(get_pagina_logica_attiva_1B)) then begin
					set_left(get_left + get_unit(TRUE));bo_modified := TRUE
				end;
				VK_UP: if (get_top > get_unit(FALSE)-1) then begin set_top(get_top-get_unit(FALSE));bo_modified := TRUE end;
				VK_DOWN: begin
					if (get_top + get_height + get_unit(FALSE) - 1 <
						{ai_page_size_Y_pix_video(get_pagina_logica_attiva)} cm2pixel_video_y(sections_ZB(ca.i_section_1B - 1).r_y_gruppo_cm))
					then begin
						set_top(get_top + get_unit(FALSE));bo_modified := TRUE
					end
				end
			end
		end
	end
end;

procedure TGM.FormKeyUp(Sender : TObject;var Key : Word;Shift : TShiftState);
var i, i_attiva : smallint;
begin
	var bo_shift := (ssShift in shift);
	var bo_ctrl := (ssCtrl in shift);
	case key of
		VK_TAB : begin
			if (ssAlt in Shift) then exit;		// cose di sistema, non m'immischio
			if bo_ctrl then begin
				i_attiva := get_pagina_logica_attiva_1B;
				if bo_shift then
					if (i_attiva = 1) then i := get_ultima_pagina_logica else i := i_attiva-1
				else
					if (i_attiva < get_ultima_pagina_logica) then i := i_attiva+1 else i := 1;
				i_pagina_logica.value := i
//				set_pagina_logica_attiva(i, TRUE)
			end
			else begin
				i := get_next_object(get_selected_obj_index(0), NOT bo_shift, NOT globale.bo_show_hidden_objects);
				if (i <> 0) then obj_select(i, TRUE, FALSE)
			end
		end
	end
end;

procedure TGM.btn_remarksMousemove(Sender: TObject;Shift: TShiftState; X, Y: Integer);
begin
	if (globale.tstr_remarks.Text <> '') then btn_remarks.Hint := globale.tstr_remarks.Text
end;

procedure TGM.set_disegno_values;
var i : smallint;	//*
begin
	set_pagina_logica_values;
	update_status_hidden_objects;
	itm_show_hidden_objects.Checked := globale.bo_show_hidden_objects;

	with tm do begin
		for i := 0 to get_num_sections-1 do sections_ZB(i).set_panel_values;
		with panels_ZB(MAIN_SECTION_ZB) do begin
			sbox.horzscrollbar.Range := sbox.horzscrollbar.Position + left + width + BORDO_DISEGNO_X_PIXEL div 2;
			sbox.vertscrollbar.Range := sbox.vertscrollbar.Position + top + height + BORDO_DISEGNO_Y_PIXEL div 2
		end;

		for i := 0 to get_num_sections-1 do panels_ZB(i).griglia_virtuale;
		invalidate;		// per far ridisegnare tutto

		enable_ctrls
	end
end;

procedure TGM.save;
var str_stack : string;	//*
begin
	push_selected(str_stack, TRUE);
	globale.save(globale.str_filename);
	pop_selected (str_stack)
end;

procedure TGM.add_section;
begin
//	if (NOT globale.bo_report) then begin beep(1);exit end;
	if NOT (globale.tiporeport in REPORT_TYPES) then begin beep(1);exit end;
	if (get_num_sections = MAX_SECTIONS) then begin
		MessageBBox(handle, 'max ' + inttostr(MAX_SECTIONS) + ' sezioni nidificate', MBOX_CAPTION);
		exit
	end;
	sezione.add_section
end;

procedure TGM.delete_sezione;
begin
	if (get_section_attiva_ZB = MAIN_SECTION_ZB) then begin beep;exit end;	// an sen pàrla gnàc
	if (MessageBBox(handle, 'Vuoi eliminare la sezione selezionata e tutti gli oggetti in essa contenuti?', MBOX_CAPTION, MB_QUESTION) <> IDYES) then exit;
	delete_section_ZB(get_section_attiva_ZB)
end;

procedure TGM.edita_legami_comunitari(i_obj : obj_index_type);
begin
	if (i_obj = 0) then begin beep(0);exit end;
	if legami_comunitari_proc(self,i_obj) then bo_modified := TRUE
end;

procedure TGM.impostazioni_proc;
begin
	impostazioni.impostazioni_proc(self);
	tm.init_video_values(getDC(handle), 1);
	enable_ctrls;
//	if globale.bo_debug_base then itm_debug_full.Checked := TRUE;		NON ATTIVATO perchè si eseguono assegnazioni/disattivazioni non necessariamente desiderate
//	if globale.bo_debug_full then itm_debug_base.Checked := TRUE;
	adegua_text_only
end;

procedure TGM.edita_font(i_obj : obj_index_type);
{ passare -1 per editare il font di tutti gli oggetti selezionati, oppure
  l'oggetto di cui modificare il font }
var str_stack : string;	//*
begin
	if (i_obj = 0) then begin beep(0);exit end;
	var bo_all_objects := (i_obj = -1);		// TRUE se l'azione deve essere relativa a tutti gli oggetti selezionati
	if bo_all_objects then i_obj := get_selected_obj_index(0);
	var obj_base : objs_type := xobjs(i_obj, get_pagina_logica_attiva_1B);
	if (obj_base.ca.tipo_oggetto <> LABEL_OBJ) then begin beep(0);exit end;

	try
		var i_num_selected_objs : obj_index_type := push_selected(str_stack, TRUE);
		if NOT obj_base.aslabel.edit_font(self, TRUE) then exit;
		if bo_all_objects then begin
			for var i : obj_index_type := 1 to i_num_selected_objs do begin
				var j : obj_index_type := get_stack_obj(str_stack,i);if (j = i_obj) then continue;
				var xobj : objs_type := xobjs(j, get_pagina_logica_attiva_1B);
				if (xobj.ca.tipo_oggetto <> LABEL_OBJ) then continue;
				var lab : cl_label := xobj.aslabel;
				var lo_font_color : TColor := lab.fontcolor;
//				with xobj.aslabel do begin
//					font.assign(obj_base.aslabel.font);
					lab.assign_font(obj_base.aslabel);
//					font.Color := lo_font_color;
					lab.FontColor := lo_font_color;
//					lo_color := obj_base.aslabel.lo_color
					lab.lo_color := obj_base.aslabel.lo_color;
//				end;
			end;
		end;
		bo_modified := TRUE
	finally
		pop_selected(str_stack)
	end
end;

procedure TGM.edita_obj(i_obj : obj_index_type);
begin
	if (i_obj = 0) then beep(0) else xobjs(i_obj, get_pagina_logica_attiva_1B).edit_object
end;

procedure TGM.set_justify(ta : TAlignMent;{box_giustificato : xboolean;}i_obj : obj_index_type = -1);
{ assegna il formato specificato;
  passare -1 per coinvolgere tutti gli oggetti selezionati, oppure uno specifico oggetto }
var str_stack : string;	//*
begin
	if (i_obj = 0) then begin beep(0);exit end;
//	bo_all_objects := (i_obj = -1);
//	if (bo_all_objects) then i_obj := get_selected_obj_index(0);

	var i_num_selected_objs : obj_index_type := push_selected(str_stack, TRUE);
	for var i : obj_index_type := 1 to i_num_selected_objs do begin
		var j : obj_index_type := get_stack_obj(str_stack,i);
//		xobj := xobjs(j, get_pagina_logica_attiva);	*** fino 2011-05-21
		var xobj : objs_type := xobjs(j);
		if (xobj.ca.tipo_oggetto = LABEL_OBJ) then begin
//			if (box_giustificato in [XFALSE, XTRUE]) then xobj.aslabel.bo_giustificato := x2bool(box_giustificato)
//			else xobj.aslabel.alignment := ta
			xobj.aslabel.alignment := ta
		end
	end;
	pop_selected (str_stack);
	bo_modified := TRUE
end;

procedure TGM.set_applica_stile_menu_items;
// imposta le voci di menu relative all'applicazione dello stile dei controls
begin
	var xobj : objs_type := get_selected_obj(0);
	{$ifdef DEBUG} assert(xobj <> NIL, 'dovrebbe essere selezionato un oggetto'); {$endif}

	// main menu
	if (object_style_ref = NIL) then itm_stile_applica.Caption := 'Applica stile'
	else itm_stile_applica.Caption := 'Applica stile <' + copy(object_style_ref.get_name,1,15) + '>';
	itm_stile_applica.Enabled := (object_style_ref <> NIL) AND (object_style_ref <> xobj);
	itm_applica_formato.Enabled := itm_stile_applica.Enabled;
	AL_stile_size_all.Enabled := is_a_compatible_selection(SET_SEL_APPLICA_STYLE, STYLE_SIZE, object_style_ref);
	AL_stile_size_height.Enabled := is_a_compatible_selection(SET_SEL_APPLICA_STYLE, STYLE_HEIGHT, object_style_ref);
	AL_stile_size_width.Enabled := is_a_compatible_selection(SET_SEL_APPLICA_STYLE, STYLE_WIDTH, object_style_ref);
	AL_apply_font.Enabled := is_a_compatible_selection(SET_SEL_APPLICA_STYLE, STYLE_FONT, object_style_ref);
	AL_apply_font_size.Enabled := AL_apply_font.Enabled;
	AL_apply_font_name.Enabled := AL_apply_font.Enabled;
	AL_fontsize_aumenta.Enabled := AL_apply_font.Enabled;
	AL_fontsize_riduci.Enabled := AL_apply_font.Enabled;
	itm_stile_Formattazione.Enabled := is_a_compatible_selection(SET_SEL_APPLICA_STYLE, STYLE_FORMATTATION, object_style_ref);
	itm_stile_valori.Enabled := is_a_compatible_selection(SET_SEL_APPLICA_STYLE, STYLE_VALUES, object_style_ref);
	itm_stile_formato_numerico.Enabled := is_a_compatible_selection(SET_SEL_APPLICA_STYLE, STYLE_FORMATO_NUMERICO, object_style_ref);
	itm_stile_legami_comunitari.Enabled := is_a_compatible_selection(SET_SEL_APPLICA_STYLE, STYLE_LEGAMI_COMUNITARI, object_style_ref);
	itm_stile_visualizzazione.Enabled := is_a_compatible_selection(SET_SEL_APPLICA_STYLE, STYLE_VISUALIZZAZIONE, object_style_ref);
	AL_apply_colore_spessore.Enabled := is_a_compatible_selection(SET_SEL_APPLICA_STYLE, STYLE_COLORE_SPESSORE_LINEA, object_style_ref);

	AL_applica_font_from_sezione.Enabled := (get_num_selected_objects <> 0);
	AL_applica_font_to_sezione.Enabled := (get_num_selected_objects = 1) AND (get_selected_obj(1).ca.tipo_oggetto = LABEL_OBJ);

	// popup menu
	set_menuitem(itp_stile_applica, itm_stile_applica,[SMI_EXCLUDE_METHOD]);	// non c'è la procedure, evito il msg di warning
//	set_menuitem(itp_stile_font, itm_stile_font);
	set_menuitem(itp_stile_formattazione, itm_stile_formattazione);
	set_menuitem(itp_stile_valori, itm_stile_valori);
	set_menuitem(itp_stile_formato_numerico, itm_stile_formato_numerico)
end;

procedure TGM.set_pagina_logica_values;
// esegue l'impostazione iniziale dei controls relativi alla pagina logica
begin
//	bo := (globale <> NIL) AND globale.bo_report;
	var bo := (globale <> NIL) AND (globale.tiporeport = TR_REPORT);
	i_pagina_logica.Visible := bo;
	txt_pagina_pre.Visible := bo;
	txt_pagina_post.Visible := bo;
	pb_out.invalidate;
	if bo then begin
		try
			inc(i_setting_pagina_logica);
			i_pagina_logica.Value := get_pagina_logica_attiva_1B
		finally
			dec(i_setting_pagina_logica)
		end;
//		i_pagina_logica.Enabled := globale.bo_report AND (get_ultima_pagina_logica > 1);
		i_pagina_logica.Enabled := (globale.tiporeport = TR_REPORT) AND (get_ultima_pagina_logica > 1);
		txt_pagina_pre.Enabled := i_pagina_logica.Enabled;
		txt_pagina_post.Enabled := i_pagina_logica.Enabled;
		txt_pagina_post.Caption := 'di ' + get_ultima_pagina_logica.ToString
	end
end;

procedure TGM.nuovo_oggetto(tipo : obj_type;bo_from_popup : boolean);
var p : TPoint;	//*
begin
	if bo_from_popup then p := pos_popup_menu else fillchar(p, sizeof(p),0);
	new_obj_ZB(tipo, get_pagina_logica_attiva_ZB, get_section_attiva_ZB, p)
end;

procedure TGM.enable_ctrls;
// adegua il video alle impostazioni
begin
	// REPORT vs LABEL
//	bo := globale.bo_report;
	btn_new_section.Enabled := (globale.tiporeport <> TR_LABEL_REPORT);
	itm_sezione.Enabled := (globale.tiporeport in REPORT_TYPES);
	AL_nuova_sezione.Enabled := (globale.tiporeport in REPORT_TYPES);
	AL_delete_sezione.Enabled := (globale.tiporeport in REPORT_TYPES);
	itm_save_pagina_logica.Enabled := (globale.tiporeport = TR_REPORT);
//	popup_nuova_sezione.Enabled := (globale.tiporeport in REPORT_TYPES);popup_elimina_sezione.Enabled := (globale.tiporeport in REPORT_TYPES);
	itm_setup_pagina_logica.Enabled := (globale.tiporeport = TR_REPORT);

	set_menuitem(itp_sezione, itm_sezione);

//	AL_fontsize_aumenta.Enabled := ;
//	AL_fontsize_riduci.Enabled := ;

	AL_report_filename_copy.Enabled := (globale.str_filename <> '');

	// GRAPHIC vs TEXT ONLY
	var bo := NOT globale.bo_text_only;
	AL_insert_immagine.Enabled := bo;
	AL_insert_cornice.Enabled := bo;
	AL_insert_line.Enabled := bo
end;

procedure TGM.adegua_text_only;
begin
	if NOT globale.bo_text_only then exit;
	for var i : obj_index_type := 1 to i_objs do begin
//		if (xobjs(i,get_pagina_logica_attiva).tipo_oggetto in LABEL_OBJS) then begin
		if (xobjs(i).ca.tipo_oggetto = LABEL_OBJ) then begin
			var lab : cl_label := xobjs(i, get_pagina_logica_attiva_1B).aslabel;
			lab.Fontname := globale.Text_only_font.name;
			lab.Fontsize := globale.Text_only_font.size
		end
	end
end;

function TGM.set_pagina_logica(i_new_pagina : logical_page_type;bo_update_indicatore : boolean;
	bo_forza_esecuzione : boolean = FALSE) : logical_page_type;
// tenta di impostare la pagina logica specificata; rende la pagina che viene effettivamente impostata
begin
	result := -1;
	if (i_setting_pagina_logica <> 0) then exit;
//	if NOT wx.check_count(self, 'Chiudi tutte le finestre prima di cambiare pagina') then exit;
	if (wx.count(FALSE) > 0) then begin MessageBBox(handle, 'Chiudi tutte le finestre prima di cambiare pagina', MBOX_CAPTION, MB_ICONSTOP);exit end;
	try
		inc(i_setting_pagina_logica);
		var i_previous : smallint := get_pagina_logica_attiva_1B;
		try
			if (i_new_pagina in [1..get_ultima_pagina_logica]) then with sbox.vertscrollbar do begin
				var i_sb_pos : smallint := Position;Position := 0;
				set_pagina_logica_attiva_1B(i_new_pagina, TRUE, bo_forza_esecuzione);
				Position := i_sb_pos
			end
			else begin i_new_pagina := i_previous;beep(0) end;
			if bo_update_indicatore then i_pagina_logica.value := i_new_pagina
		except
			set_pagina_logica_attiva_1B(i_previous, TRUE)
		end;
		result := get_pagina_logica_attiva_1B
	finally
		dec(i_setting_pagina_logica)
	end
end;

procedure TGM.update_status_hidden_objects;
begin
	for var i_page_1B : logical_page_type := 1 to globale.i_pagine_logiche do begin
		for var i : obj_index_type := 1 to i_objs(i_page_1B) do begin
			var x : objs_type := xobjs(i, i_page_1B);
			if (x.tipo_oggetto = OBJ_BITMAP) AND x.asbitmap.bo_sfondo_design_time then x.set_visible(globale.bo_show_immagini_sfondo)
			else if x.is_hidden(0) then x.set_visible(globale.bo_show_hidden_objects)
		end
	end;

	if globale.bo_show_immagini_sfondo then
		for var i : obj_index_type := 1 to i_objs do begin
			var x : objs_type := xobjs(i);
			if (x.tipo_oggetto = OBJ_BITMAP) AND x.asbitmap.bo_sfondo_design_time then x.asbitmap.SendToBack
		end
end;

procedure TGM.set_modified(bo : boolean);
// applica lo stato 'bo_modified'
begin
	if (bo = bo_modified_phisical) then exit;
	// se applico AL_FILE_SAVE.ENABLED quando AL è disabled (perchè è aperta una NON-MODAL window), non funziona; devo attendere la FormActivate()
	if bo AND (AL.State <> asNormal) then begin bo_modified_rimandato := TRUE;exit end;
	bo_modified_phisical := bo;AL_file_save.Enabled := bo;
	bo_modified_rimandato := FALSE
end;

procedure TGM.delete_selected_objects;
// elimina gli oggetti selezionati, previa conferma
var str_stack : string;
begin
	var i_num_selected_objs : obj_index_type := get_num_selected_objects;
	case i_num_selected_objs of
		0 : begin beep(0);exit end;	// c'è di meglio da fare che correre dietro alle paturnie dell'utente
		1 : str_stack := 'Vuoi veramente cancellare l''elemento selezionato?';
		else str_stack := 'Vuoi cancellare ' + get_articolo(i_num_selected_objs, TRUE) + ' ' + i_num_selected_objs.ToString + ' oggetti selezionati?'
	end;
	if (MessageBBox(handle, str_stack, MBOX_CAPTION, MB_QUESTION) <> IDYES) then exit;

	push_selected(str_stack, TRUE);

{	for i := i_num_selected_objs downto 1 do	// necessaria la back-enumeration
		delete_object(get_stack_obj(str_stack, i),TRUE,i = 1) }

	while (str_stack <> '') do begin
		var i : obj_index_type := get_stack_max_object(str_stack, {delete_from_stack}TRUE);
		if (i = 0) then exit;
		delete_object(i, {conseguenze_video}TRUE, {select_next}str_stack = '')
	end
end;

procedure TGM.inverti_modalita_visualizzazione;
// modifica lo stato di tutti gli elementi selezionati
var
	show : show_types;	//*
	str_stack : string;	//*
begin
	if (get_num_selected_objects = 0) then beep(0);
	var i_num_selected_objs : obj_index_type := push_selected(str_stack, TRUE);
	bo_modified := TRUE;
	for var i : obj_index_type := 1 to i_num_selected_objs do begin
		var xobj : objs_type := xobjs(get_stack_obj(str_stack, i), get_pagina_logica_attiva_1B);
//		inverto tra i due stati SHOW e HIDE; gli altri stati vengono equiparati a
//		if (xobj.get_tipo in TESTI_OBJS) then begin	// solo oggetti di testo (per il momento)
			if (xobj.get_show_state = OSW_SHOW) then show := OSW_HIDE else show := OSW_SHOW;
			xobj.set_show_state(show)
//		end
	end;
	pop_selected(str_stack)
end;

procedure TGM.insert_delete_pagina_logica(bo_insert : boolean);
// inserisce una nuova pagina logica prima della pagina corrente
begin
	if (MessageBBox(handle,'Vuoi ' + ifs(bo_insert, 'INSERIRE una nuova pagina logica alla posizione corrente','ELIMINARE la pagina logica attiva') +
		'?' + ACAPO2 + 'ATTENZIONE: il file sarà salvato e il programma dovrà essere riavviato per concludere l''operazione',
		MBOX_CAPTION,MB_QUESTION) <> IDYES)
			then exit;

	if bo_insert AND NOT insert_pagina_logica then exit;	// errore o impossibilità: messaggio già emesso
	if NOT bo_insert AND NOT delete_pagina_logica then exit;	// errore o impossibilità: messaggio già emesso
	set_pagina_logica(get_pagina_logica_attiva_1B, TRUE, TRUE);
	case MessageBBox(handle,'Il programma ora deve essere riavviato per rendere operative le modifiche.' + ACAPO2 +
		'Vuoi salvare le modifiche?', MBOX_CAPTION, MB_YESNO)
	of
		IDYES : bo_modified := TRUE;
		IDNO : bo_modified := FALSE
	end;
	{$ifdef DEBUG} MessageBBox(handle,' Risolvere il problema SALVATAGGIO senza obbligare a chiudere e riaprire -- QQRRTT 345345', MBOX_CAPTION); {$endif}
	bo_save_without_ask := TRUE;
	close		//	{$ifndef DEBUG}  **** PROVARE A non chiudere il programma dopo l*inserimento di una nuova pagina logica {$endif}
end;

procedure TGM.i_pagina_logicaChange(Sender : TObject);
var i : logical_page_type;	//*
begin
	try i := round(i_pagina_logica.value) except exit end;	// se non riesce a convertire, non faccio nulla
	if (set_pagina_logica(i, FALSE) <> i) then i_pagina_logica.value := get_pagina_logica_attiva_1B
end;

procedure TGM.popup_sectionPopup(Sender : TObject);
begin
	GetCursorPos(pos_popup_menu);
	pos_popup_menu := panels_ZB(get_section_attiva_ZB).ScreenToClient(pos_popup_menu)
end;

procedure TGM.AL_switch_sfondiExecute(Sender : TObject);
begin
//	itm_show_sfondi.Checked := NOT itm_show_sfondi.Checked;
	globale.bo_show_immagini_sfondo := itm_show_sfondi.Checked;
	update_status_hidden_objects
end;

procedure TGM.FormResize(Sender : TObject);
// var i_min_h : smallint;
begin
	if (windowstate = wsMinimized) then begin
//		application.minimize;
//		visible := FALSE;
//		windowstate := ws_previous;
//		visible := TRUE
	end
	else begin
{		if (clientwidth < sb.Width) then begin
			width := width + sb.Width - clientwidth;
			exit
		end;
		i_min_h := sb.Height * (1+2);
		if (clientheight < i_min_h) then begin
			height := height + i_min_h - clientheight;
			exit
		end }
	end;
	ws_previous := windowstate
end;

{procedure Tcontrollo.wm_syscomm(var m:TMessage);
Begin
	m.wparam := m.wparam AND $FFF0;
  if m.Wparam=SC_ICON then showMessage('Mi hai minimizzato!!!');
  if m.Wparam=SC_RESTORE then showMessage('Mi hai ristorato!!!');
  if m.Wparam=SC_ZOOM then showMessage('Mi hai zoommato!!!');
//mostro un messaggio
  inherited
end;}

procedure TGM.applica_formato_choose;
begin
	if (get_selected_obj(0) = NIL) OR (object_style_ref = NIL) then begin beep;exit end;

	var dati : cl_dati_domanda_multipla := cl_dati_domanda_multipla.create;
	dati.set_answer_ZB(00, 'Dimensioni','',NOT itp_stile_size.Enabled);
	dati.set_answer_ZB(01, 'Altezza','',NOT itp_stile_height.Enabled);
	dati.set_answer_ZB(02, 'Larghezza','',NOT itp_stile_width.Enabled);
	dati.set_answer_ZB(03, 'Font','',NOT AL_apply_font.Enabled);
	dati.set_answer_ZB(04, 'Font: nome','',NOT AL_apply_font_name.Enabled);
	dati.set_answer_ZB(05, 'Font: dimensione','',NOT AL_apply_font_size.Enabled);
	dati.set_answer_ZB(06, 'Font: colore','',NOT AL_apply_font_color.Enabled);
	dati.set_answer_ZB(07, 'Legami comunitari','',NOT itp_stile_legami_comunitari.Enabled);
	dati.set_answer_ZB(08, 'Formattazione','',NOT itp_stile_formattazione.Enabled);
	dati.set_answer_ZB(09, 'Formato numerico','',NOT itp_stile_formato_numerico.Enabled);
	dati.set_answer_ZB(10, 'Valori','',NOT itp_stile_valori.Enabled);
	dati.set_answer_ZB(11, 'Colore e spessore linee', '', NOT AL_apply_colore_spessore.Enabled);
	dati.set_answer_ZB(12, 'Visualizzazione','',NOT itp_stile_visualizzazione.Enabled);

	var i : smallint := domanda_multipla_structure(self, 'Applica formato <' + object_style_ref.get_name + '>',
		'Quale porzione di formato vuoi applicare agli oggetti selezionati?', i_last_stile_applicato, dati);

	if (i <> 0) then i_last_stile_applicato := i;
	case i of
		00 : exit;
		01 : applica_formato(STYLE_SIZE);
		02 : applica_formato(STYLE_HEIGHT);
		03 : applica_formato(STYLE_WIDTH);
		04 : applica_formato(STYLE_FONT);
		05 : applica_formato(STYLE_FONTNAME);
		06 : applica_formato(STYLE_FONTSIZE);
		07 : applica_formato(STYLE_FONTCOLOR);
		08 : applica_formato(STYLE_LEGAMI_COMUNITARI);
		09 : applica_formato(STYLE_FORMATTATION);
		10 : applica_formato(STYLE_FORMATO_NUMERICO);
		11 : applica_formato(STYLE_VALUES);
		12 : applica_formato(STYLE_COLORE_SPESSORE_LINEA);
		13 : applica_formato(STYLE_VISUALIZZAZIONE)
	end
end;

procedure TGM.set_system_operator(bo_ask_password : boolean);
var s : string;	//*
begin
	if bo_ask_password then begin
		if NOT input_text_proc(NIL, 'System operator', 'Inserisci la password di autorizzazione', s, 0, NIL, IDS_PASSWORD)
			then exit;
		if (s <> str_PASSW_PASSEPARTOUT) AND NOT xPASSWORD_DATE_DEPENDENT(s, 0) then begin
			if (s <> '') then MessageBBox(handle, 'Password NON valida', MBOX_CAPTION);
			exit
		end
	end;
	globale.bo_federico_signed := TRUE;
	globale.str_signature := SYSTEM_SIGNATURE;
	caption := GM.Caption + ' [' + globale.str_signature + ']'
end;

procedure TGM.dont_write_version;
var s : string;	//*
begin
	if NOT globale.bo_federico_signed then begin
		if NOT input_text_proc(NIL, 'System operator', 'Inserisci la password di riconoscimento', s, 0, NIL, IDS_PASSWORD)
			then exit;
		if (s <> str_PASSW_PASSEPARTOUT) AND NOT xPASSWORD_DATE_DEPENDENT(s, 0) then begin
			if (s <> '') then MessageBBox(handle, 'Password NON riconosciuta', MBOX_CAPTION);
			exit
		end
	end;
	itm_dont_write_version.Checked := NOT itm_dont_write_version.Checked;
	globale.bo_dont_write_version := itm_dont_write_version.Checked
end;

procedure TGM.send_report_via_email;
const MBOX_CAPTION = 'Invio report per posta elettronica';
var str_external_pages : string;	//*
begin
//	var email : TMAPIMail := NIL;
	for var i : logical_page_type := 0 to get_ultima_pagina_logica - 1 do begin
		var xp : cl_logical_page_info := get_logical_page_ZB(i);
		if xp.bo_external then add_delimited(str_external_pages, xp.get_descrizione(TRUE), ACAPO)
	end;
	if (str_external_pages <> '') then
		MessageBBox(handle, 'ATTENZIONE' + ACAPO2 +
			'Le seguenti pagine risiedono su files esterni' + ACAPO +
			'che non saranno allegati al messaggio di posta elettronica' + ACAPO2 + str_external_pages,MBOX_CAPTION);

	if bo_modified AND NOT globale.save(globale.str_filename) then exit;
//	if (MessageBBox(handle, 'Vuoi inviare il report per e-mail ?', MBOX_CAPTION, MB_QUESTION) <> IDYES) then exit;

	send_email(self, '', 'GALATEO - ' + globale.str_filename, {body}'', globale.str_filename, {interactive}TRUE, {SMTP_protocol}FALSE, {delete_file_after}FALSE)
end;

procedure TGM.log_file_open;
begin
	var s := ChangeFileExt(globale.str_filename, DEBUG_LOG_EXT);
	execute_data_file(handle, FALSE, s)
end;

procedure TGM.log_file_delete;
begin
	var s := ChangeFileExt(globale.str_filename, DEBUG_LOG_EXT);
	if NOT FileExists(s) then begin
		MessageBBox(handle, 'File non esistente o non accessibile' + ACAPO2 + s, MBOX_CAPTION, MB_ICONSTOP);
		exit
	end;
	if DeleteFile(LPSTR(s)) then MessageBBox(handle, 'Debug log eliminato' + ACAPO2 + s, MBOX_CAPTION)
	else MessageBBox(handle,'IMPOSSIBILE eliminare il debug log' + ACAPO2 + s, MBOX_CAPTION, MB_ICONSTOP)
end;

function TGM.galrun_get_linea_comando(bo_assegna_valore_parametri : boolean;bo_executable : boolean = TRUE;bo_parametri : boolean = TRUE) : string;
{ genera una riga di comando per la chiamata a GALRUN.EXE;
  if (BO_ASSEGNA_VALORE_PARAMETRI) include le istruzioni di assegnazione dei valori ai parametri
  if (BO_EXECUTABLE) include il valore del nome dell'eseguibile (GALRUN) da chiamare
  if (BO_PARAMETRI) include i parametri da passare all'eseguibile (tutti i parametri, non solo quelli da valorizzare nel senso di BO_ASSEGNA_VALORE_PARAMETRI) }
begin
	result := '';
	var str_path := computer_registry_data.str_galrun_path;
	if (str_path = '') then str_path := ExtractFilepath(paramstr(0));
	if bo_executable then result := result + '"' + make_filename(GALRUN_EXE, str_path) + '"';
	if bo_parametri then begin
		result := result +
			' "' + GALRUN_PARM_FILENAME + extractFilePath(globale.str_filename) + ExtractFilename(globale.str_filename) + '"';
//			' ' + GALRUN_PARM_CONNESSIONE + globale.str_db_driveralias;
//			' ' + GALRUN_PARM_CONNESSIONE + globale.str_local_connection_parms.Replace(ACAPO, ';');	**** D6
		if globale.connection_config.bo_read_from_profile then result := result + ' ' + GALRUN_PARM_CONN_PARMS + globale.connection_config.str_profile;

		if (itm_debug_base.Checked AND NOT globale.bo_debug_base) OR (itm_debug_full.Checked AND NOT globale.bo_debug_full) then
			result := result + ' ' + ifs(itm_debug_full.Checked, GALRUN_PARM_DEBUG_FULL, GALRUN_PARM_DEBUG_BASE);

		for var i_pagina : logical_page_type := 1 to globale.i_pagine_logiche do begin
			for var i_obj : obj_index_type := 1 to i_objs(i_pagina) do begin
				var x : objs_type := xobjs(i_obj, i_pagina);
				if (x.tipo_variabile <> TV_PARAMETRO) then continue;
				var lab : cl_label := x.aslabel;
//				if (x.get_tipo = xVARIABILE) AND (x.aslabel.tipovar = TV_PARAMETRO) AND NOT x.aslabel.bo_ask_runtime then
				if {(x.tipo_variabile = TV_PARAMETRO) AND} NOT lab.bo_ask_runtime then
//					result := result + ' "/P=' + x.get_name + '=' + x.aslabel.str_esempio_value + '"'
					result := result + ' "/P=' + x.get_name + '=' +
						ifs(NOT lab.bo_runtime_default_is_SQL AND NOT lab.bo_runtime_default_is_formula, lab.get_runtime_default) + '"'
			end
		end
	end
end;

procedure TGM.galrun_parametri(bo_clipboard : boolean);
var bo_parametri : boolean;
begin
//	bo_parametri := FALSE;
	case MessageBBox(handle, 'Vuoi generare una definizione anche per i parametri di galateo?', 'Riga di comando per GALRUN', MB_QUESTION_DEF2) of
		IDYES : bo_parametri := TRUE;
		IDNO : bo_parametri := FALSE;
		else exit
	end;
	if bo_clipboard then begin
		str2clipboard(galrun_get_linea_comando(bo_parametri));
		MessageBBox(handle, 'Comando copiato sulla clipboard', MBOX_CAPTION)
	end
	else error_msg(galrun_get_linea_comando(bo_parametri), MBOX_CAPTION, TRUE, MB_ICONINFORMATION)
end;

procedure TGM.galrun_execute;
begin
	if bo_modified then begin
		case MessageBBox(handle,'Il file è stato modificato. Vuoi salvarlo?', MBOX_CAPTION, MB_QUESTION) of
			IDYES : save;
			IDNO : ;
			IDCANCEL : exit
		end
	end;
//	WinExecAndWait32(galrun_get_linea_comando({assegna_valore_parametri}TRUE, {executable}TRUE, {parametri}FALSE), {debug}FALSE, {visibility}0,
//		{wait}TRUE, {workpath}extractFilePath(globale.str_filename),
//		{parametri}galrun_get_linea_comando({assegna_valore_parametri}TRUE, {executable}FALSE, {parametri}TRUE))
	WinExecAndWait32(galrun_get_linea_comando(TRUE), FALSE, 0, TRUE, extractFilePath(globale.str_filename))
end;

procedure TGM.pb_out_paint;
var i, j, x, y, i_dx, i_dy : smallint;
begin
	pb_out.Color := cllime;
	str_logical_page_info := {$ifdef DEBUG} '----------- PROVA ------------   ' {$else} '' {$endif};
	var page : cl_logical_page_info := get_logical_page_ZB(get_pagina_logica_attiva_ZB);
	if (get_ultima_pagina_logica > 1) then str_logical_page_info := str_logical_page_info + page.get_descrizione(TRUE);
	if page.bo_external then str_logical_page_info :=
		str_logical_page_info + ifs(str_logical_page_info,' --- ') + 'external [' + page.str_external_filename + ']' +
		ifs(page.wo_external_original_version <> GALATEO_VERSION, ' [ver ' + version_of(page.wo_external_original_version) + ']') +
		ifs(page.str_page_ID,' --- ID=' + page.str_page_ID);

//	if (str_logical_page_info <> '') then pb_out.canvas.Textout(0,0,str_logical_page_info);
//	{$ifdef DEBUG} with pb_out do begin color := cllime;canvas.Textout(0,0,'PxROVA') end; {$endif}
	write_page_measures(get_pagina_logica_attiva_1B, pb_out, BORDO_DISEGNO_X_PIXEL, BORDO_DISEGNO_Y_PIXEL, globale.tiporeport, FALSE);
	txt_info_page.Caption := str_logical_page_info;

	if (globale.tiporeport = TR_LABEL_REPORT) then begin
		i_dx := cm2pixel_video_x(tm.r_delta_labs_X_cm);x := i_label_size_X_pix_video + i_dx;
		i_dy := cm2pixel_video_x(tm.r_delta_labs_Y_cm);y := i_label_size_Y_pix_video + i_dy;
		for i := 0 to tm.i_lab_per_row-1 do begin
			for j := 0 to tm.i_lab_per_page -1 do begin
				if (i = 0) AND (j = 0) then continue;	//label principale, già stampata
				pb_out.Canvas.Rectangle(BORDO_DISEGNO_X_PIXEL + i*x, BORDO_DISEGNO_Y_PIXEL + j*y,
					BORDO_DISEGNO_X_PIXEL + (i+1)*x - i_dx, BORDO_DISEGNO_Y_PIXEL + (j+1)*y - i_dy)
			end
		end
	end;

	pb_out.Canvas.Brush.Style := bsClear;	// trasparente
	pb_out.Canvas.Font.Name := 'Arial';
	pb_out.Canvas.Font.Size := 48;
	pb_out.Canvas.Font.Style := [fsBold];
	y := 20;
	var s := version_of(GALATEO_VERSION, '');pb_out.Canvas.TextOut(pb_out.Width - pb_out.Canvas.TextWidth(s) - 30, y, s);
	s := BITNESS;pb_out.Canvas.TextOut(pb_out.Width - pb_out.Canvas.TextWidth(s) - 30, y + pb_out.Canvas.TextHeight(s), s);

	update_info_selection
end;

procedure TGM.update_info_selection{$ifdef DEBUG}(str_debug_msg : string = ''){$endif};

	function get_object_info(i_ndx : obj_index_type;txt : TLabel = NIL) : string;
	// determina la descrizione per l'oggetto; se TXT <> NIL la assegna direttamente (compreso il campo HINTs)
	var str_item, str_hints : string;
	begin
		var xobj : objs_type := xobjs(i_ndx);
//		result := {$ifdef DEBUG} '[' + inttostr(i_ndx) + '] ' + {$endif} xobj.get_name;
		result := '[' + zeri(i_ndx, 3) + '] ' + xobj.get_name;
		if (xobj.ca.tipo_oggetto in EXPINT_OBJS) then begin
			var i_exports : obj_index_type := 0;
			var lab : cl_label := xobj.aslabel;
			for var i : obj_index_type := 0 to high(globale.expint_profiles) do begin
				if lab.ZB_get_integral_exportable(i, get_pagina_logica_attiva_ZB, NOT xobj.is_hidden(get_pagina_logica_attiva_1B)) then begin
					inc(i_exports);
					if (i_exports = 1) then result :=
						result + ' [exp' + ifs(lab.expint[i].str_header,'=' + lab.expint[i].str_header) + ifs(lab.expint[i].i_pos <> 0, ':' + inttostr(lab.expint[i].i_pos)) + '] ';
					str_item := {'profilo=' +} globale.expint_profiles[i].str_codice + ' : ' +
						'"' + coalesce(lab.expint[i].str_header, lab.Caption) + '"' +
						ifs(lab.expint[i].i_pos <> 0, ' pos=' + inttostr(lab.expint[i].i_pos));
					add_delimited(str_hints, str_item, ACAPO)
				end
				else add_delimited(str_hints, {'profilo=' +} globale.expint_profiles[i].str_codice + ' : campo non exportato', ACAPO)
			end;
			if (i_exports = 0) then str_hints := 'campo non exportato' else str_hints := 'IMPOSTAZIONI DI EXPORTAZIONE' + ACAPO + str_hints
		end;
		if (txt <> NIL) then begin
			txt.Caption := result;
			txt.Hint := str_hints
		end
	end;

var
	s : string;
	i : smallint;
	i_count : array[obj_type] of obj_index_type;
begin
	{$ifdef DEBUG} if (now - dt_last_debug_info < 10 * SECONDO) then exit; {$endif}		// lascio la visualizzazione del debug message per almeno un certo periodo
	txt_info_selezione.Color := $0080FFFF;
	case get_num_selected_objects of
		0 : txt_info_selezione.Caption := '';
		1 : {txt_info_selezione.Caption :=} get_object_info(get_selected_obj_index, txt_info_selezione);
		else begin
			txt_info_selezione.Caption := get_num_selected_objects.ToString + ' oggetti selezionati';
			for i := 1 to get_num_selected_objects do add_delimited(s, get_object_info(get_selected_obj_index(i)), ACAPO);
			add_delimited(s, '--------------------', ACAPO);

			fillchar(i_count,sizeof(i_count),0);
			for i := 1 to get_num_selected_objects do inc(i_count[get_selected_obj(i).ca.tipo_oggetto]);
			for var x : obj_type := succ(FIRST_TIPO) to pred(LAST_TIPO) do
				if (i_count[x] <> 0) then add_delimited(s, TIPO_OGGETTO_DESCRIZIONE[x] + ': ' + i_count[x].ToString, ACAPO);

			txt_info_selezione.Hint := s
		end
	end
end;

procedure TGM.select_and_edit_section;
{ consente l'editazione di una sezione previa scelta della sezione da editare;
  utile per editare sezioni completamente nascoste }
begin
	var it := TStringList.create;
	for var i : section_index_type := 0 to get_num_sections-1 do it.Add(sections_ZB(i).str_nome);
	var i : section_index_type := domanda_multipla_tstring(self, 'Modifica sezione', 'Seleziona la sezione da modificare', -1, it);
	if (i <> -1) then edit_section_ZB(i, FALSE)
end;

procedure TGM.itm_modify_info_salvataggioClick(Sender : TObject);
begin
	globale.get_signature(TRUE);
	bo_modified := TRUE;set_modified(TRUE)
end;

procedure TGM.AL_copy_object_nameExecute(Sender : TObject);
begin
	if (get_num_selected_objects = 1) then str2clipboard(get_selected_obj(0).get_name)
	else beep(0)
end;

procedure TGM.FormMouseWheel(Sender: TObject; Shift: TShiftState;WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
const UNITA = 20.0;	// range : 100
var i_new_pos, i_old_pos, i_unita : smallint;	//*
begin
	if (shift = []) then begin		// scroll verticale
		i_old_pos := sbox.vertscrollbar.Position;
		i_unita := round(UNITA * sbox.vertscrollbar.range / 100);
		if (wheelDelta > 0) then i_new_pos := MAX(i_old_pos - i_unita, 0) else i_new_pos := MIN(i_old_pos + i_unita, sbox.vertscrollbar.Range - i_unita);
		sbox.VertScrollbar.Position := i_new_pos
	end
	else begin	// scroll orizzontale
		i_old_pos := sbox.Horzscrollbar.Position;
		i_unita := round(UNITA * sbox.Horzscrollbar.range / 100);
		if (wheelDelta > 0) then i_new_pos := MAX(i_old_pos - i_unita, 0) else i_new_pos := MIN(i_old_pos + i_unita, sbox.HorzScrollbar.Range - i_unita);
		sbox.HorzScrollbar.Position := i_new_pos
	end;
	Handled := TRUE
end;

procedure TGM.btn_select_only_textsClick(Sender : TObject);
begin
	bo_dont_select_texts := FALSE;
	bo_dont_select_graphics_objs := btn_select_only_texts.Down
end;

procedure TGM.btn_select_only_graphsClick(Sender : TObject);
begin
	bo_dont_select_texts := btn_select_only_graphs.Down;
	bo_dont_select_graphics_objs := FALSE
end;

procedure TGM.space_equally(bo_horz : boolean);

	function getx(i : smallint) : int_pixel_type;
	begin
		if bo_horz then result := get_selected_obj(i).get_left else result := get_selected_obj(i).get_top
	end;

	procedure setx(i : smallint;value : int_pixel_type);
	begin
		if bo_horz then get_selected_obj(i).set_left(value) else get_selected_obj(i).set_top(value)
	end;

var px {$ifdef DEBUG} ,dbx {$endif} : array of smallint;
begin
	var i_selected_objs : obj_index_type := get_num_selected_objects;
	if (i_selected_objs < 3) then begin beep;exit end;

	setLength(px, i_selected_objs);
	{$ifdef DEBUG} setLength(dbx, i_selected_objs); {$endif}
	var i_min : int_pixel_type := MAXINT;var i_max : int_pixel_type := -MAXINT;
	for var i : obj_index_type := 1 to i_selected_objs do begin
		var x : int_pixel_type := getx(i);
		if (x < i_min) then i_min := x;
		if (x > i_max) then i_max := x;
		var k : obj_index_type := 0;
		while (px[k] <> 0) AND (x >= getx(px[k])) do inc(k);
		if (k < i - 1) then begin
			move(px[k], px[k+1], (i - k - 1) * sizeof(px[0]));
			{$ifdef DEBUG} move(dbx[k], dbx[k+1], (i - k - 1) * sizeof(dbx[0])) {$endif}
		end;
		px[k] := i;{$ifdef DEBUG} dbx[k] := x {$endif}
	end;

	for var i : obj_index_type := 1 to i_selected_objs-2 do setx(px[i], round(i_min + (i_max - i_min) / (i_selected_objs - 1) * i));		// il primo e l'ultimo oggetto non si spostano
	bo_modified := TRUE;
	px := NIL;{$ifdef DEBUG} dbx := NIL {$endif}
end;

procedure TGM.open_text_editor;
label execute;
begin
	if (globale.str_filename = '') then exit;
	if bo_modified then globale.save(globale.str_filename);		// salvare non è obbligatorio

	var str_programma := GetSystemPath(CSIDL_PROGRAM_FILES) + '\TextPad 4\textpad.exe';
	if FileExists(str_programma) then goto execute;

	str_programma := GetSystemPath(CSIDL_PROGRAM_FILESX86) + '\TextPad 4\textpad.exe';
	if FileExists(str_programma) then goto execute;

	str_programma := 'notepad.exe';
execute:
	{$ifNdef DEBUG} *** provare con nomi contenenti spazi {$endif DEBUG}
	WinExecAndWait32(str_programma, {debug}FALSE, {Visibility}0, {wait}FALSE, {work_directory}'', '"' + globale.str_filename + '"')
end;

procedure TGM.applica_font_from_sezione;
// elimina il font della sezione agli elementi selezionati
begin
	for var i : obj_index_type := 1 to get_num_selected_objects do begin
		var x : objs_type := get_selected_obj(i);
		if (x.ca.tipo_oggetto <> LABEL_OBJ) then continue;
		x.aslabel.assign_font(sections_ZB(x.ca.i_section_1B - 1).font_default, 0, 0);
		x.aslabel.Repaint
	end;
	bo_modified := TRUE
end;

procedure TGM.applica_font_to_sezione;
begin
	if (get_num_selected_objects <> 1) then exit;		// un solo oggetto selezionato
	var x : objs_type := get_selected_obj(1);
	if (x.ca.tipo_oggetto <> LABEL_OBJ) then exit;
	sections_ZB(x.ca.i_section_1B - 1).font_default.Assign(x.aslabel.get_font);
	bo_modified := TRUE;
	MessageBBox(handle, 'Font assegnato alla sezione', MBOX_CAPTION)
end;

procedure TGM.open_documento_info(var str_filename : string;str_default_ext, str_filter : string);
begin
	if (str_filename = '') AND
		NOT browse_for_files_open(self, {caption}'', str_filename, str_default_ext, str_filter, {default_dir}ExtractFilePath(globale.str_filename))
			then exit;

	var str_temp := extractFilename(str_filename);
	if FileExists(str_temp) then execute_data_file(handle, {debug}FALSE, str_temp)
	else execute_data_file(handle, {debug}FALSE, str_filename)
end;

procedure TGM.itm_clear_documento_informativo_utenteClick(Sender : TObject);
begin
	if (MessageBBox(handle, 'Vuoi eliminare l''indicazione del documento informativo utente?', MBOX_CAPTION, MB_QUESTION) = IDYES) then begin
		bo_modified := TRUE;
		globale.str_documento_informativo_utente := ''
	end
end;

procedure TGM.itm_clear_technical_referenceClick(Sender : TObject);
begin
	if (MessageBBox(handle, 'Vuoi eliminare l''indicazione del Technical Reference?', MBOX_CAPTION, MB_QUESTION) = IDYES) then begin
		bo_modified := TRUE;
		globale.str_technical_reference := ''
	end
end;

procedure TGM.itm_debug_baseClick(Sender : TObject);
begin
	itm_debug_base.Checked := NOT itm_debug_base.Checked;
	itm_debug_full.Checked := FALSE;
	MessageBBox(handle, 'Modalità di DEBUG ' + ifs(itm_debug_base.Checked, 'attivata', 'disattivata'), MBOX_CAPTION)
end;

procedure TGM.itm_debug_fullClick(Sender : TObject);
begin
	itm_debug_full.Checked := NOT itm_debug_full.Checked;
	itm_debug_base.Checked := FALSE;
	MessageBBox(handle, 'Modalità di FULL DEBUG ' + ifs(itm_debug_full.Checked, 'attivata', 'disattivata'), MBOX_CAPTION)
end;

procedure TGM.AL_save_pagina_logicaExecute(Sender : TObject);
begin
	if globale.save_external_logical_page(-1, TRUE) then
		MessageBBox(handle, 'Pagina logica felicemente exportata', MBOX_CAPTION)
end;

procedure TGM.AL_show_hidden_objectsExecute(Sender : TObject);
begin
	globale.bo_show_hidden_objects := NOT globale.bo_show_hidden_objects;
	itm_show_hidden_objects.Checked := globale.bo_show_hidden_objects;
//	bo_modified := TRUE;
	update_status_hidden_objects
end;

procedure TGM.objects_order_execute;

	function exec(i_ndx_from, i_ndx_to : obj_index_type) : boolean;
	begin
		if (i_ndx_from = i_ndx_to) then begin result := FALSE;exit end;	// evidentemente nulla da fare

		var x_from : objs_type := xobjs(i_ndx_from);	// tengo da parte l'oggetto da spostare
		if (i_ndx_to > i_ndx_from) then begin
			for var i : obj_index_type := i_ndx_from to i_ndx_to-1-1 do assign_obj(i, xobjs(i+1));
			dec(i_ndx_to)
		end
		else for var i : obj_index_type := i_ndx_from downto i_ndx_to+1 do assign_obj(i, xobjs(i-1));
		assign_obj(i_ndx_to, x_from);
		result := TRUE
	end;

var x : array of objs_type;
begin
	if (get_num_selected_objects < 2) then begin
		MessageBBox(handle, 'Seleziona almeno due oggetti', MBOX_CAPTION);
		exit
	end;

	try
		setLength(x, get_num_selected_objects + 1);		// per semplicità considero X 1-based
		for var i : obj_index_type := get_num_selected_objects downto 1 do begin
			x[i] := get_selected_obj(i);
			set_selected_obj(x[i].i_numero_obj, FALSE)	// deseleziono tutti gli oggetti (che cambieranno posizione, compreso il primo che potrebbe slittare causa spostamento di oggetti a lui precedenti)
		end;

		var i_count : obj_index_type := 0;
		for var i : obj_index_type := 2 to high(x) do
			if exec(x[i].i_numero_obj, x[1].i_numero_obj + i-1) then inc(i_count);

		for var i : obj_index_type := 1 to high(x) do set_selected_obj(x[i].i_numero_obj, TRUE);		// riseleziono gli oggetti alle loro nuove posizioni

		if (i_count <> 0) then bo_modified := TRUE;
		VAR s := ifs(i_count = 0, 'NESSUNA modifica necessaria', ifs(i_count = 1, '1 oggetto riallocato', i_count.ToString + ' oggetti riallocati'));
{		MessageBBox(handle, 'Riassegnazione eseguita' + ACAPO2 +
			ifs(i_count = 0, 'NESSUNA modifica necessaria',
			ifs(i_count = 1, '1 oggetto riallocato', inttostr(i_count) + ' oggetti riallocati')), MBOX_CAPTION) {}
		txt_info_selezione.Caption := s;txt_info_selezione.Color := clRed;
		Timer.Enabled := TRUE;dtt_reset_info_selezione := now + SECONDO * 2		// attivo il timer per restituire l'aspetto ordinario
	finally
//		update_info_selection
	end
end;

procedure TGM.TimerTimer(Sender : TObject);
begin
	if (dtt_reset_info_selezione <> 0) AND (now > dtt_reset_info_selezione) then begin
		dtt_reset_info_selezione := 0;
		update_info_selection
	end;
	if (dtt_reset_info_selezione = 0) then timer.Enabled := FALSE
end;

procedure TGM.AL_open_folder_reportExecute(Sender : TObject);
begin
	var str_filename := coalesce(globale.str_filename, paramstr(0));
	explorer_select_filename(handle, str_filename)
end;

procedure TGM.AL_fontsize_aumentaExecute(Sender : TObject);
begin
//
end;

procedure TGM.AL_fontsize_riduciExecute(Sender : TObject);
begin
//
end;

{$ifdef DEBUG}
	procedure visual_debug(s : string;s2 : string = '';s3 : string = '');
	begin
		if (s2 <> '') then s := s + ' // ' + s2;
		if (s3 <> '') then s := s + ' // ' + s3;
		GM.dt_last_debug_info := now;
		GM.txt_info_selezione.Caption := s
	end;
{$endif}

initialization
	galateo_initialization_debug('galateo_main')
finalization
	galateo_finalization_debug('galateo_main');
	{$ifdef DEBUG} CCI(i_GMs, 'TGM', 'galateo_main.pas') {$endif}
end.
