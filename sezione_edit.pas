unit sezione_edit;	//*

{$ifNdef GALATEO_EXE} *** {$endif}

{$I defines}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Math, Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, Menus, ActnList, Actions, Grids,
	FRegistry, Federico, FListBox, FBitBtn,
	Printers_DX, Gdich, expint_base, fields, panel;

procedure edit_section_ZB(i_section_ZB : section_index_type;bo_only_impostazioni_pagina : boolean;
	bo_open_page_exportazione : boolean = FALSE;i_profilo : expint_index_type = 0);

type
  Tdlg_sezione = class(TForm)
	 font_dialog: TFontDialog;
    panel_bottoni: TFPanel;
    btn_ok: TFBitBtn;
    btn_cancel: TFBitBtn;
    pc: TPageControl;
	 page_opzioni: TTabSheet;
    page_SQL: TTabSheet;
	 str_SQL_select: TMemo;
    cbx_dont_break_fields: TFCheckBox;
	 cbx_blanks: TFCheckBox;
    cbx_fill_tutto: TFCheckBox;
	 cbx_bo_stampa_anche_se_vuota: TFCheckBox;
	 cbx_bo_senza_dati: TFCheckBox;
	 cbx_dont_print: TFCheckBox;
    cbx_dont_break_subsections: TFCheckBox;
    cbx_reprint: TFCheckBox;
	 st_procs: TTabSheet;
	 txt_SP: TLabel;
	 memo_scripts: TMemo;
	 formattazione: TTabSheet;
	 txt_nome: TLabel;
    str_nome: TEdit;
    btn_font: TFBitBtn;
    cbx_conta_records: TFCheckBox;
	 txt_record_name: TLabel;
    str_record_name: TEdit;
	 gbox_pos_size: TGroupBox;
	 txt_y0_rel: TLabel;
	 r_y0_rel: TEdit;
	 r_dy_gruppo: TEdit;
	 txt_dy_gruppo: TLabel;
	 r_dy_sezione: TEdit;
    txt_dy_sezione: TLabel;
    txt_obj_pos_width: TLabel;
	 rb_draw: TRadioGroup;
    txt_index_info: TLabel;
    memo_start_record: TMemo;
    pagina_logica: TTabSheet;
    rb_orientamento: TRadioGroup;
	 btn_standard_labels: TButton;
    cbx_draw_last_line: TFCheckBox;
    btn_index_esempio: TButton;
    cbx_print_only_if_subsection_has_records: TFCheckBox;
	 txt_codice_record: TLabel;
    cb_codice_record: TFCombo;
    cb_obj_pos_width: TFCombo;
    page_export: TTabSheet;
    cbx_autosize: TFCheckBox;
    btn_page_size: TButton;
	 txt_minimum_required_space: TLabel;
	 r_minimum_required_space: TEdit;
    txt_minimum_required_space2: TLabel;
    txt_size_page_x: TLabel;
	 txt_size_page_y: TLabel;
    r_size_page_x: TEdit;
	 r_size_page_y: TEdit;
    page_label: TTabSheet;
    txt_size_label_x: TLabel;
    txt_size_label_y: TLabel;
    r_size_label_x: TEdit;
    r_size_label_y: TEdit;
    txt_lab_per_row: TLabel;
	 txt_lab_per_page: TLabel;
	 txt_delta_x: TLabel;
    txt_delta_y: TLabel;
	 i_lab_per_row: TEdit;
	 i_lab_per_page: TEdit;
	 r_delta_x: TEdit;
	 r_delta_y: TEdit;
	 txt_misure_CM: TMyLabel;
    cbx_draw_lines_separazione_label: TFCheckBox;
    cbx_double_thickness: TFCheckBox;
	 btn_help: TFBitBtn;
    pc_export: TMyPageControl;
    page_exportazione: TTabSheet;
	 page_export_DBF: TTabSheet;
    cbx_export_DBF: TFCheckBox;
    txt_export_filename: TLabel;
    str_export_filename_DBF: TEdit;
    SQL_export_DBF: TMemo;
    txt_export: TLabel;
    txt_export_label: TMyLabel;
	 txt_numero_stampe_etichetta: TLabel;
    cb_numero_stampe_etichetta: TFCombo;
    i_numero_stampe_etichetta: TFEdit;
    btn_genera_SQL: TFBitBtn;
	 txt_group_by_section: TLabel;
    cb_group_by_section: TFCombo;
	 panel_profiles: TFPanel;
    panel_profiles_header: TFPanel;
	 txt_profiles: TLabel;
	 cb_profiles: TFCombo;
    btn_new_doc: TFBitBtn;
    btn_delete_doc: TFBitBtn;
    gbox_condizioni_profili: TFGroupBox;
    txt_profilo_workstation: TMyLabel;
    txt_profilo_username: TMyLabel;
    btn_profilo_workstation: TFBitBtn;
    btn_profilo_username: TFBitBtn;
	 str_profilo_workstation: TFEdit;
    str_profilo_username: TFEdit;
    panel_profiles_values: TFPanel;
	 txt_marg_sx: TLabel;
	 txt_marg_up: TLabel;
    r_marg_sx: TEdit;
    r_marg_up: TEdit;
	 txt_printer: TLabel;
    cb_printer: TFCombo;
    cb_cassetto: TFCombo;
    txt_cassetto: TLabel;
    txt_profile_message: TMyLabel;
    btn_help_profiles: TFBitBtn;
	 txt_profilo_IP: TMyLabel;
    str_profilo_IP: TFEdit;
    btn_profilo_IP: TFBitBtn;
    lb_expint_elenco: TMyListBox;
    btn_assegna_font: TFBitBtn;
    page_export_opzioni: TFPageControl;
    page_expint: TTabSheet;
    page_XML: TTabSheet;
    panel_expint_edit: TFPanel;
    txt_export_integrale: TLabel;
    txt_export_ID: TMyLabel;
	 txt_export_shift_columns: TMyLabel;
    txt_export_type_fields_default: TLabel;
    txt_expint_descrizione: TMyLabel;
    cb_export_integrale: TFCombo;
	 str_export_sigla: TFEdit;
    i_expint_shift_columns: TFEdit;
    cb_export_type_fields_default: TFCombo;
    cbx_dont_export_continuazione: TFCheckBox;
    cbx_header_colonne: TFCheckBox;
	 str_expint_descrizione: TFEdit;
	 panel_XML_header: TFPanel;
    txt_XML_text: TMyLabel;
	 cbx_XML_export: TFCheckBox;
    str_XML_text: TFMemo;
    txt_SQL_PK_debug_field: TLabel;
    str_SQL_PK_debug_field: TEdit;
	 AL: TActionList;
	 AL_find: TAction;
	 AL_find_next: TAction;
    find_dialog: TFindDialog;
    page_colonne_colorate: TTabSheet;
    txt_header_colonne_colorate: TMyLabel;
	 footer_colonne_colorate: TFPanel;
    btn_colcol_add: TFBitBtn;
    btn_colcol_del: TFBitBtn;
    AL_colonna_colorata_add: TAction;
    AL_colonna_colorate_delete: TAction;
    grid_colonne_colorate: TStringGrid;
    btn_riordina_colcol: TFBitBtn;
    AL_colonne_colorate_sort: TAction;
    panel_SQL_filename: TFPanel;
    cbx_SQL_save_to: TFCheckBox;
    cbx_SQL_read_from: TFCheckBox;
    str_SQL_filename: TFEdit;
    btn_browse_SQL_filename: TFBitBtn;
	 procedure FormCreate(Sender : TObject);
	 procedure btn_cancelClick(Sender : TObject);
	 procedure btn_okClick(Sender : TObject);
	 procedure r_dy_gruppoChange(Sender : TObject);
	 procedure FormClose(Sender : TObject;var Action : TCloseAction);
	 procedure btn_fontClick(Sender : TObject);
	 procedure FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
	 procedure cbx_conta_recordsClick(Sender : TObject);
	 procedure str_SQL_selectKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
	 procedure rb_orientamentoClick(Sender : TObject);
	 procedure btn_standard_labelsClick(Sender : TObject);
	 procedure cb_printerExit(Sender : TObject);
    procedure btn_index_esempioClick(Sender : TObject);
	 procedure btn_new_docClick(Sender : TObject);
	 procedure btn_delete_docClick(Sender : TObject);
    procedure cb_profilesExit(Sender : TObject);
	 procedure generic_enable_ctrls(Sender : TObject);
	 procedure btn_page_sizeClick(Sender : TObject);
	 procedure btn_helpClick(Sender : TObject);
	 procedure i_numero_stampe_etichettaChange(Sender : TObject);
	 procedure cb_numero_stampe_etichettaChange(Sender : TObject);
	 procedure btn_genera_SQLClick(Sender : TObject);
	 procedure btn_profilo_workstationClick(Sender : TObject);
	 procedure btn_profilo_usernameClick(Sender : TObject);
	 procedure btn_help_profilesClick(Sender : TObject);
	 procedure btn_profilo_IPClick(Sender : TObject);
	 procedure FormDestroy(Sender : TObject);
	 procedure lb_expint_elencoClick(Sender : TObject);
	 procedure btn_assegna_fontClick(Sender : TObject);
	 procedure find_dialogFind(Sender : TObject);
	 procedure AL_findExecute(Sender : TObject);
	 procedure AL_find_nextExecute(Sender : TObject);
    procedure AL_colonna_colorata_addExecute(Sender : TObject);
    procedure AL_colonna_colorate_deleteExecute(Sender : TObject);
    procedure grid_colonne_colorateDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure grid_colonne_colorateDblClick(Sender : TObject);
    procedure AL_colonne_colorate_sortExecute(Sender : TObject);
    procedure btn_browse_SQL_filenameClick(Sender : TObject);
	private
		expint_sections : expint_section_array;		// variabile locale di lavoro
//		exp : cl_expint_page;
		i_written_expint : smallint;
		i_profilo : expint_index_type;
		procedure read_expint(i_profilo : expint_index_type);
		procedure write_expint(i_profilo : expint_index_type);
	private
		str_find_text : string;
		function get_active_memo : TMemo;
		procedure find;
		procedure find_next;
//		procedure call_find_dialog;
		procedure execute_find(str_find_text : string);
	private
		procedure colonna_colorata_aggiungi;
		procedure colonna_colorata_elimina;
		procedure write_colonne_colorate;
		procedure sort_colonne_colorate;
  private
		i_pagina_1B, i_pagina_ZB : logical_page_type;	// pagina logica attiva
		i_section_ZB : section_index_type;
		bo_only_impostazioni_pagina : boolean;
		{$ifdef DEBUG} i_section_attiva : string; {$endif}
		str_nome_bak : {str_sezione_nome_type}string;
		r_y0_rel_bak,r_dy_sezione_bak,r_dy_gruppo_bak,r_minimum_required_space_bak : real;
		bo_dont_break_fields_bak,bo_dont_break_subsections_bak : boolean;
		bo_del_blanks_bak, bo_fill_tutto_bak, bo_dont_print_section_bak, bo_reprint_broken_sections_bak : boolean;
//		bo_dont_export_continuazione_bak,bo_print_headers_colonne_bak,
		bo_conta_records_bak,bo_draw_line_bottom_bak,bo_draw_rect_bak,bo_draw_last_line_bak : boolean;
//		qry_SQL_bak, qry_script_bak{,qry_start_record_bak} : TStrings;
		str_SQL_bak, str_script_bak, str_SQL_start_record_BAK : string;
		str_obj_line_bottom_pos_and_width_bak : string;
		str_profilo_workstation_bak, str_profilo_IP_bak, str_profilo_username_bak : string;
		bo_double_thickness_bak : boolean;
		bo_exportable_bak : boolean;
		bo_print_only_if_subsection_has_records_bak : boolean;
		bo_draw_lines_separazione_label_bak : boolean;
		font_bak : TFont;
		str_record_descr_runtime_bak : string{[LEN_RECORD_DESCR_RUNTIME]};
//		bo_font_modified : boolean;
		bo_started : boolean;
		r_V_height_base_cm : double;		// altezza dell'oggetto all'apertura della dialogbox
		bo_has_subsections : boolean;	// TRUE se la section ha delle sub-sections
		bo_dont_set_activepage : boolean;		// disattiva l'assegnazione automatica della linguetta all'apertura della finestra
		procedure enable_record_name;
		procedure enable_PPL;
		procedure enable_ctrls;
		procedure enable_ctrls_expint;
		procedure genera_SQL_default;
		procedure delete_profilo;
		procedure new_profilo;
		function read_profilo(str_profilo : string): boolean;
		procedure write_profilo(str_profilo: string);
		procedure help_proc;
		function IO_form_size_and_pos_custom_proc(bo_save : boolean;reg : TFRegistry) : boolean;
		constructor xcreate_ZB(father : TForm;i_section_ZB : section_index_type;bo_only_impostazioni_pagina : boolean;i_profilo : expint_index_type);
  end;

implementation

uses Fcommons, FXStrings, FStrings, help, FCtrls, FCtrls_RX, FSystem_base, FSystem, FMessage, FTrans, FProcs, FFile, FBrowse,
	wproc, proc, myprinter, galateo_debug, galateo_main, impostazioni, standard, misure, objects, pages, sezione, colori_proc, colonna_colorata_edit;

{$R *.DFM}

const
	COLONNE_COLORATE_FIXED = 3;		// numero di colonne fisse per la grid relativa alle COLONNE_COLORATE

procedure set_oggetti_footer(handle : hwnd;r_delta_height_cm : double); forward;

procedure edit_section_ZB(i_section_ZB : section_index_type;bo_only_impostazioni_pagina : boolean;
	bo_open_page_exportazione : boolean = FALSE;i_profilo : expint_index_type = 0);
begin
	if NOT bo_only_impostazioni_pagina AND NOT (globale.tiporeport in REPORT_TYPES) then begin
		impostazioni_proc(GM);
		exit
	end;

	var str_ID := get_pagina_logica_attiva_ZB.toString + '-' + i_section_ZB.toString;
	if NOT wx.can_open(WT_SECTION_EDIT, GM, str_ID) then exit;
	var dlg := Tdlg_sezione.xcreate_ZB(GM, i_section_ZB, bo_only_impostazioni_pagina, i_profilo);
	if bo_open_page_exportazione then dlg.pc.Activepage := dlg.page_export;
	wx.register_open_window(GM, dlg, WT_SECTION_EDIT, str_ID);
	dlg.Show;
{	dlg.showmodal;dlg.release;
	setup_pagina_logica(get_pagina_logica_attiva_1B);
	if (i_section_ZB = MAIN_SECTION_ZB) then GM.set_disegno_values }
end;

constructor Tdlg_sezione.xcreate_ZB(father : TForm;i_section_ZB : section_index_type;bo_only_impostazioni_pagina : boolean;i_profilo : expint_index_type);
begin
	{$ifdef DEBUG} if bo_only_impostazioni_pagina then assert(i_section_ZB = MAIN_SECTION_ZB,'WJGH 2839'); {$endif}
	if bo_only_impostazioni_pagina then i_section_ZB := MAIN_SECTION_ZB;	// a scanso d'equivoci
	self.i_section_ZB := i_section_ZB;
	self.i_pagina_1B := get_pagina_logica_attiva_1B;
	self.i_pagina_ZB := get_pagina_logica_attiva_ZB;
	self.i_profilo := i_profilo;
	self.bo_only_impostazioni_pagina := bo_only_impostazioni_pagina;

	// genero una copia dei dati oggetto di editing (per quanto riguarda l'export integrale)
	setLength(expint_sections, expint_profiles_count);
	for var i : smallint := 0 to expint_profiles_count-1 do begin
		expint_sections[i] := cl_expint_section.create;
//		expint_sections[i].assign(globale.expint_profiles[i].expint_pages[i_pagina].expint_sections[i_section])
		expint_sections[i].assign(get_expint_section_ZB(i, i_pagina_ZB, i_section_ZB))
	end;

	inherited create(father);
	{$ifdef DEBUG} i_section_attiva := 'AAA' {$endif}
end;

procedure Tdlg_sezione.FormCreate(Sender : TObject);
var i : smallint;	//*
begin
//	sections[i_section].Active := FALSE;
	str_nome.maxlength := LEN_NOME_SEZIONE;
//	btn_standard_labels.Enabled := NOT globale.bo_report;
	btn_standard_labels.Enabled := (globale.tiporeport in LABEL_TYPES);
	load_profili_itemlist(cb_profiles.Items);
	cb_select(cb_profiles, get_active_profile.str_profilo);

	page_colonne_colorate.TabVisible := (i_section_ZB > MAIN_SECTION_ZB);
	grid_colonne_colorate.ColCount := MAX_COLORI_CONDIZIONALI + COLONNE_COLORATE_FIXED;
	grid_colonne_colorate.Cells[0, 0] := 'descrizione';grid_colonne_colorate.ColWidths[0] := 200;
	grid_colonne_colorate.Cells[1, 0] := 'posizione';grid_colonne_colorate.ColWidths[1] := 120;
	grid_colonne_colorate.Cells[2, 0] := 'oggetto';grid_colonne_colorate.ColWidths[2] := 200;
	for i := 0 to MAX_COLORI_CONDIZIONALI - 1 do begin
		grid_colonne_colorate.Cells[COLONNE_COLORATE_FIXED + i, 0] := 'colore #' + (i+1).ToString;
		grid_colonne_colorate.ColWidths[COLONNE_COLORATE_FIXED + i] := 200
	end;

	set_minimum_form_size(self);

	btn_profilo_workstation.Hint := 'imposta il nome del computer (' + get_computer_name + ')';
	btn_profilo_IP.Hint := 'imposta l''indirizzo IP del computer (' + get_IP + ')';
	btn_profilo_username.Hint := 'imposta il nome dell''utente attivo (' + get_windows_username + ')';
	make_all_children_enabled(page_export, globale.bo_export_allowed);

	page_expint.TabVisible := FALSE;
	page_XML.TabVisible := FALSE;
	panel_expint_edit.Color := EXPINT_COLOR;
	str_XML_text.Color := XML_COLOR;

//	page_export_integrale.Highlighted := ;
//	page_XML.Highlighted := ;

	// se solo impostazioni pagina, nascondo tutto il resto
	bo_dont_set_activepage := FALSE;
	if bo_only_impostazioni_pagina then begin
		pc.Activepage := pagina_logica;
		for i := 0 to pc.pagecount-1 do pc.pages[i].tabvisible := (pc.pages[i] = pagina_logica);
		bo_dont_set_activepage := TRUE
	end
	else begin
		pc.Activepage := page_SQL;
		activecontrol := str_SQL_select;
		pagina_logica.Tabvisible := (i_section_ZB = MAIN_SECTION_ZB)
	end;
	page_label.Tabvisible := (globale.tiporeport in LABEL_TYPES);
	IO_form_size_and_pos(self, FALSE, {str_registry_argument}'', {bo_reset_values}FALSE, IO_form_size_and_pos_custom_proc);

//	apply_colori_symbolici_colonne_colorate(sections_1B(i_section_1B).colonne_colorate);
	apply_colori_symbolici_colonne_colorate(sections_ZB(i_section_ZB).colonne_colorate);
	write_colonne_colorate;

	for i := 1 to i_objs do begin
		var x : objs_type := xobjs(i);
		cb_obj_pos_width.Items.add(x.get_name);
//		if (x.get_tipo in [VARIABILE,FORMULA]) AND (x.aslabel.tipovar in [VAR_VARIABILE,VAR_SQL_SELECT]) then begin
{		if (x.get_section = i_section) AND
			((x.get_tipo in FORMULA_OBJS) OR
			 ((x.get_tipo = xVARIABILE) AND (x.aslabel.tipovar in [TV_VARIABILE, TV_SQL_SELECT]))) }
		if (x.ca.i_section_1B = i_section_ZB + 1) AND (x.tipo_variabile in [TV_FORMULA, TV_DB_FIELD, TV_SQL_SELECT])
				then cb_codice_record.Items.Add(x.get_name);

//		if (x.get_section = i_section) AND (x.get_tipo = xVARIABILE) AND (x.aslabel.tipovar = TV_VARIABILE)
		if (x.ca.i_section_1B = i_section_ZB + 1) AND (x.tipo_variabile = TV_DB_FIELD)
			then cb_group_by_section.Items.Add(x.get_name);

//		if (x.aslabel.tipo_valore = VAL_NUMERO) AND
		if (x.ca.tipo_valore = VAL_NUMERO) AND
{			((x.get_tipo in FORMULA_OBJS) OR		// datamatrix cmq esclusi, dato che serve un oggetto di tipo NUMERO
			 ((x.get_tipo = xVARIABILE) AND
			  (x.aslabel.tipovar in [TV_VARIABILE, TV_PARAMETRO, TV_SQL_SELECT_BEFORE_SQL, TV_SQL_SELECT_BEFORE_RUNTIME, TV_SQL_SELECT]))) }
			  // datamatrix cmq esclusi, dato che serve un oggetto di tipo NUMERO
			(x.tipo_variabile in [TV_DB_FIELD, TV_PARAMETRO, TV_SQL_SELECT_BEFORE_SQL, TV_SQL_SELECT_BEFORE_RUNTIME, TV_SQL_SELECT, TV_FORMULA])
		then cb_numero_stampe_etichetta.Items.add(x.get_name)
	end;

//	bo_has_subsections := (sections_1B(i_section_1B).get_first_son_1B <> 0);
	bo_has_subsections := (sections_ZB(i_section_ZB).get_first_son_1B <> 0);
	if (i_section_ZB = MAIN_SECTION_ZB) then begin
		enable_FC(txt_y0_rel, FALSE);
		enable_FC(txt_dy_sezione, FALSE);
		enable_FC(txt_dy_gruppo, FALSE);
		enable_FC(txt_minimum_required_space, FALSE);txt_minimum_required_space2.Enabled := FALSE;
		enable_FC(txt_nome, FALSE);
		cbx_fill_tutto.Enabled := FALSE;
		cbx_dont_break_fields.Enabled := FALSE;
		cbx_dont_break_subsections.Enabled := FALSE;
		cbx_reprint.Enabled := FALSE;
//		cbx_autosize.Enabled := (i_section_1B in [MAIN_SECTION, MAIN_SECTION+1]);
		cbx_autosize.Enabled := (i_section_ZB in [MAIN_SECTION_ZB, MAIN_SECTION_ZB + 1]);
		rb_draw.Enabled := FALSE;

		rb_orientamento.ItemIndex := byte(orizzontale_ZB(i_pagina_ZB));
{		if globale.bo_report then begin
			txt_size_horz.Caption := 'Larghezza netta pagina';
			txt_size_vert.Caption := 'Altezza netta pagina'
		end; }

//		if (globale.tiporeport in REPORT_TYPES) then begin		{$ifndef DEBUG} *** {$endif}    2008-07-31
//			r_size_page_x.Text := strid(get_PHpage_size_X_cm_1B(i_pagina_1B), 0, 0);
			r_size_page_x.Text := strid(get_PHpage_size_X_cm_ZB(i_pagina_ZB), 0, 0);
//			r_size_page_y.Text := strid(get_PHpage_size_Y_cm_1B(i_pagina_1B), 0, 0);
			r_size_page_y.Text := strid(get_PHpage_size_Y_cm_ZB(i_pagina_ZB), 0, 0);
			cbx_draw_lines_separazione_label.Checked := draw_lines_separazione_label
{		end
		else begin
			visible_FC(txt_size_page_x,FALSE);
			visible_FC(txt_size_page_y,FALSE)
		end; };

		if (globale.tiporeport in LABEL_TYPES) then begin
			r_size_label_x.Text := strid(get_label_size_X_cm, 0, 0);
			r_size_label_y.Text := strid(get_label_size_Y_cm, 0, 0);
			i_lab_per_row.Text := tm.i_lab_per_row.ToString;
			i_lab_per_page.Text := tm.i_lab_per_page.ToString;
			r_delta_x.Text := strid(tm.r_delta_labs_X_cm, 0, 0);
			r_delta_y.Text := strid(tm.r_delta_labs_Y_cm, 0, 0);

			var s := get_numero_etichette_object;
			if (s = '') then i_numero_stampe_etichetta.set_Asinteger(get_numero_etichette_const) else cb_select(cb_numero_stampe_etichetta, s)
		end
		else begin
			visible_FC(txt_size_label_x, FALSE);
			visible_FC(txt_size_label_y, FALSE)
		end;
		r_V_height_base_cm := get_Vpage_size_Y_cm(i_pagina_1B);

//		for var fgppl : xFGPPL_type := low(fgppl) to FGPPL_LAST do cb_ppl.Items.add(FGPPL_codice[fgppl]);
		cb_printer.Items.assign(printer.printers);
		write_profilo(cb_profiles.Text)
	end
	else begin
//		var bo_main_son := (sections_1B(i_section_1B).xi_father_1B = MAIN_SECTION);	// figlio della main section
		var bo_main_son := (sections_ZB(i_section_ZB).i_father_ZB = MAIN_SECTION_ZB);	// figlio della main section
		r_dy_sezione.Enabled := bo_main_son;
		{ la dimensione della sezione è un valore assoluto, ed ha senso solo se riferita
		  alla pagina; poichè le sotto-sezioni non sono mai riferite alla pagina, ma alle
		  sezioni entro cui sono inserite, per le sottosezioni tale valore non è modificabile }
//		cbx_fill_tutto.Enabled := bo_main_son
	end;

//	txt_SQL_select.Enabled := str_SQL_select.Enabled;

//	var sec : cl_sezione := sections_1B(i_section_1B);
	var sec : cl_sezione := sections_ZB(i_section_ZB);
	Caption := 'Formato sezione [' + sec.get_name + ']';
	str_nome_bak := sec.get_name;
	with sec do begin
		r_y0_rel_bak := r_y0_rel_cm;
		r_dy_sezione_bak := r_y_sezione_cm;r_dy_gruppo_bak := r_y_gruppo_cm;
		r_minimum_required_space_bak := r_minimum_required_space_cm;
		bo_dont_break_fields_bak := bo_dont_break_fields;
		bo_dont_break_subsections_bak := bo_dont_break_subsections;
		bo_del_blanks_bak := bo_del_blanks;
		bo_fill_tutto_bak := bo_fill_tutto;
		bo_reprint_broken_sections_bak := bo_reprint_broken_sections;
		bo_dont_print_section_bak := bo_dont_print_section;
//		bo_dont_export_continuazione_bak := bo_dont_export_continuazione;
//		bo_print_headers_colonne_bak := bo_print_headers_colonne;
//		qry_SQL_bak := TStringlist.create;qry_SQL_bak.assign(tsql_command);
		str_SQL_bak := tsql_command.Text;
//		qry_script_bak := TStringlist.create;qry_script_bak.assign(tsql_scripts);
		str_script_bak := tsql_scripts.Text;
//		qry_start_record_bak := TStringList.create;qry_start_record_bak.assign(xxtsql_start_record);
		str_SQL_start_record_BAK := str_SQL_start_record;
		font_bak := TFont.create;font_bak.assign(font_default);
		bo_conta_records_bak := bo_conta_records;
		str_record_descr_runtime_bak := str_record_descr_runtime;
		bo_draw_line_bottom_bak := bo_draw_line_bottom;
		bo_draw_last_line_bak := bo_draw_last_line;
		bo_draw_rect_bak := bo_draw_rect;
		str_obj_line_bottom_pos_and_width_bak := str_obj_line_bottom_pos_and_width;
		bo_double_thickness_bak := bo_double_thickness;
		bo_draw_lines_separazione_label_bak := draw_lines_separazione_label;
		bo_exportable_bak := bo_exportable_DBF;
		bo_print_only_if_subsection_has_records_bak := bo_print_only_if_subsection_has_records;

		str_profilo_workstation_bak := get_workstation_page(i_pagina_1B);
		str_profilo_IP_bak := get_IP_page(i_pagina_1B);
		str_profilo_username_bak := get_username_page(i_pagina_1B);

		self.str_nome.Text := sec.get_name;
		self.r_y0_rel.Text := strid(r_y0_rel_cm, 0, 0);
		self.r_dy_sezione.Text := strid(r_y_sezione_cm, 0, 0);
		self.r_dy_gruppo.Text := strid(r_y_gruppo_cm, 0, 0);
		self.r_minimum_required_space.Text := strid(r_minimum_required_space_cm, 0, 0);
		cbx_dont_break_fields.Checked := bo_dont_break_fields;
		cbx_dont_break_subsections.Checked := bo_dont_break_subsections;
		cbx_bo_stampa_anche_se_vuota.Checked := bo_stampa_anche_se_vuota;
		cbx_dont_print.Checked := bo_dont_print_section;
		cbx_bo_senza_dati.Checked := bo_senza_dati;
		cbx_blanks.Checked := bo_del_blanks;
		cbx_fill_tutto.Checked := bo_fill_tutto;
		cbx_autosize.Checked := bo_autosize;
		cbx_reprint.Checked := bo_reprint_broken_sections;
		cbx_print_only_if_subsection_has_records.Checked := bo_print_only_if_subsection_has_records;
		str_SQL_select.Lines.assign(tsql_command);
		SQL_export_DBF.Lines.Text := str_SQL_export_DBF_store;
		self.str_export_filename_DBF.Text := str_export_filename_DBF;
		memo_scripts.Lines.assign(tsql_scripts);
		cbx_SQL_read_from.Checked := sec.bo_read_from_file;
		cbx_SQL_save_to.Checked := sec.bo_save_to_file;
		self.str_SQL_filename.Text := sec.str_SQL_filename;
		st_procs.Highlighted := (memo_scripts.Text <> '');
//		memo_start_record.lines.assign(xxtsql_start_record);
		memo_start_record.lines.Text := str_SQL_start_record;
		cbx_conta_records.Checked := bo_conta_records;
		str_record_name.Text := str_record_descr_runtime;
		if bo_draw_rect then rb_draw.ItemIndex := 1 else
		if bo_draw_line_bottom then rb_draw.ItemIndex := 2
		else rb_draw.ItemIndex := 0;
		cbx_draw_last_line.Checked := bo_draw_last_line;
		cbx_double_thickness.Checked := bo_double_thickness;
		cb_select(cb_obj_pos_width, str_obj_line_bottom_pos_and_width);
		cb_select(cb_codice_record, str_field_codice_record);
		cb_select(cb_group_by_section, str_section_group_field);
		cbx_export_DBF.Checked := bo_exportable_DBF
	end;

	str_SQL_PK_debug_field.Text := sec.str_SQL_PK_debug_field;

	load_section_export_types_items(cb_export_integrale.Items);
	load_object_export_types_items(cb_export_type_fields_default.Items);

	expint_profilo_load_items(lb_expint_elenco.Items, globale.expint_profiles);
	lb_expint_elenco.ItemIndex := i_profilo;
	write_expint(lb_expint_elenco.ItemIndex);

	// highlighto se ci sono impostazioni non default
//	page_export_integrale.highlighted := (sec.export_type <> OEXP_DEFAULT) OR (sec.str_sigla <> '');
//	if (sec.export_type = OEXP_NOT) then page_export_integrale.Caption := page_export_integrale.Caption + ' [NOT exported]';
//	page_export_DBF.Highlighted := sec.bo_exportable_DBF AND (sec.str_SQL_export_DBF_store <> '');	// visualizzo solo se c'è uno specifico SQL per l'exportazione
//	page_export.Highlighted := page_export_integrale.highlighted OR page_XML.HighLighted OR page_export_DBF.highlighted;

	enable_record_name;
	enable_ctrls;
	{$ifdef DEBUG} check_components(self); {$endif DEBUG}
	bo_started := TRUE
end;

procedure Tdlg_sezione.FormClose(Sender: TObject;var Action: TCloseAction);
begin
//	qry_SQL_bak.free;qry_script_bak.free;font_bak.free
	IO_form_size_and_pos(self, TRUE, {str_registry_argument}'', {bo_reset_values}FALSE, IO_form_size_and_pos_custom_proc);
	Action := caFree
end;

procedure Tdlg_sezione.FormDestroy(Sender : TObject);
begin
	for var i : byte := 0 to high(expint_sections) do expint_sections[i].free;
	expint_sections := NIL;

	wx.register_close_window(self);
	setup_pagina_logica(get_pagina_logica_attiva_1B);
	if (i_section_ZB = MAIN_SECTION_ZB) then GM.set_disegno_values
end;

procedure Tdlg_sezione.btn_okClick(Sender : TObject);
var
	i : integer;	//*
	r_PH_new_height, r_LAB_new_height, r_V_new_height : real;
begin
	if (cbx_SQL_read_from.Checked OR cbx_SQL_save_to.Checked) then begin
		if (str_SQL_filename.Text = '') then begin MessageBBox(handle, 'Specifica il nome del file per il comando SQL', MBOX_CAPTION, MB_ICONSTOP);exit end;
		if cbx_SQL_save_to.Checked AND (togli_ACAPO_init_fine(str_SQL_select.Text) = '') then begin
			MessageBBox(handle, 'Non esiste nessun comando SQL da salvare su file', MBOX_CAPTION, MB_ICONSTOP);
			exit
		end;
		if (str_SQL_filename.Text <> '') then begin
			var s := uppercase(extractFileExt(str_SQL_filename.Text));
			if (s = '') then str_SQL_filename.Text := str_SQL_filename.Text + EXTERNAL_SQL_SECTION_COMMAND_EXT
			else if (s <> EXTERNAL_SQL_SECTION_COMMAND_EXT) then begin
				MessageBBox(handle, 'Non è possibile specificare l''estensione del file di salvataggio del comando SQL' + ACAPO2 + str_SQL_filename.Text, MBOX_CAPTION, MB_ICONSTOP);
				exit
			end;
			if filename_has_explicit_path(str_SQL_filename.Text) then begin
				if NOT writable_path(ExtractFilePath(str_SQL_filename.Text), s) then begin
					MessageBBox(handle, 'Errore nel file di salvataggio del comando SQL' + ACAPO2 + str_SQL_filename.Text + ACAPO2 + s, MBOX_CAPTION, MB_ICONSTOP);
					exit
				end;
				MessageBBox(handle, 'Il file di salvataggio del comando dovrebbe essere PRIVO di path', MBOX_CAPTION)
			end
		end
	end;

	try
//		var sec : cl_sezione := sections_1B(i_section_1B);
		var sec : cl_sezione := sections_ZB(i_section_ZB);
		with sec do begin
			tsql_scripts.assign(memo_scripts.Lines);

			sec.bo_read_from_file := cbx_SQL_read_from.Checked;
			sec.bo_save_to_file := cbx_SQL_save_to.Checked;
			sec.str_SQL_filename := togliblanks(self.str_SQL_filename.Text);

//			xxtsql_start_record.assign(memo_start_record.lines);
			str_SQL_start_record := clear_blanks_eoln(memo_start_record.lines.Text);
//			bo_print_headers_colonne := cbx_header_colonne.Checked;

			if (i_section_ZB <> MAIN_SECTION_ZB) then begin
				str_nome := togliblanks(self.str_nome.Text);
//				if (get_section_name = '') then begin
				if (str_nome = '') then begin
					MessageBBox(handle, 'Metti un nome a questa sezione, please', MBOX_CAPTION);
					abort
				end;

//				if NOT is_symbol_ok('Nome della sezione', get_section_name, TRUE, handle) then abort;
				if NOT is_symbol_ok('Nome della sezione', str_nome, TRUE, handle) then abort;

				r_y0_rel_cm := leggi_text_real(handle,self.r_y0_rel, 0, MAX_HEIGHT_SEZIONE_CM, 'posizione assoluta margine superiore', r_y0_rel_cm);
				r_y_sezione_cm := leggi_text_real(handle,self.r_dy_sezione, 0, MAX_HEIGHT_SEZIONE_CM, 'altezza complessiva della sezione', r_y_sezione_cm);
				r_y_gruppo_cm := leggi_text_real(handle,self.r_dy_gruppo, 0, MAX_HEIGHT_SEZIONE_CM, 'altezza di ogni gruppo di record', r_y_gruppo_cm);
				r_minimum_required_space_cm := leggi_text_real(handle,self.r_minimum_required_space, 0, 40, 'spazio minimo disponibile', r_minimum_required_space_cm);
//				bo_dont_export_continuazione := cbx_dont_export_continuazione.Checked;

				if (r_y_gruppo_cm > r_y_sezione_cm) then begin
					MessageBBox(handle, 'La dimensione della sezione non può essere inferiore alla dimensione del gruppo di record', MBOX_CAPTION);
					abort
				end;

				// verifico i margini della sezione con i margini della sezione padre
				if NOT check_margini_sezione_with_father then begin
					MessageBBox(handle,'I margini della sezione non sono compatibili con i margini della sezione padre', MBOX_CAPTION);
					abort
				end;

				// verifico i margini della sezione con i margini delle sezioni figlie
				if NOT check_margini_sezione_with_sons then begin
					MessageBBox(handle, 'I margini della sezione non sono compatibili con i margini delle sezioni figlie', MBOX_CAPTION);
					abort
				end
			end;

(*			if bo_font_modified then begin
				case MessageBBox(handle,'E'' stato modificato il font per la sezione.' + ACAPO2 +
					'Vuoi assegnare il nuovo font a tutti gli oggetti della sezione?', MBOX_CAPTION, MB_QUESTION_DEF2)
				of
					IDYES : begin
						for i := 1 to i_objs do with xobjs(i) do
							if (ca.i_section = i_section_1B) AND (ca.tipo_oggetto = LABEL_OBJ) then
//								aslabel.font.assign(font_default)
								aslabel.assign_font_from(font_default, 0, 0)
					end;
					IDNO : { nothin' to do };
					IDCANCEL : abort
				end
			end; *)

			for i := 0 to str_SQL_select.lines.Count-1 do
				str_SQL_select.lines[i] := togliblanks_eoln(str_SQL_select.lines[i]);
			tsql_command.assign(str_SQL_select.Lines);
			str_SQL_export_DBF_store := togli_ACAPO_finali(SQL_export_DBF.Lines.Text);
			str_export_filename_DBF := togliblanks(self.str_export_filename_DBF.Text);

			set_panel_values;
			bo_dont_break_fields := cbx_dont_break_fields.Checked;
			bo_dont_break_subsections := cbx_dont_break_subsections.Checked;
			bo_stampa_anche_se_vuota := cbx_bo_stampa_anche_se_vuota.Checked;
			bo_dont_print_section := cbx_dont_print.Checked;
			bo_senza_dati := cbx_bo_senza_dati.Checked;
			bo_del_blanks := cbx_blanks.Checked;
			bo_fill_tutto := cbx_fill_tutto.Checked;
			bo_autosize := cbx_autosize.Checked;
			if bo_autosize AND NOT globale.bo_autosize_page then
				MessageBBox(handle,
					'Perchè la sezione sia realmente ridimensionata in funzione della dimensione del foglio stampante, è necessario attivare l''opzione sulle impostazioni generali',
					MBOX_CAPTION);
			bo_reprint_broken_sections := cbx_reprint.Checked;
			bo_print_only_if_subsection_has_records := cbx_print_only_if_subsection_has_records.Checked;

			bo_draw_rect := FALSE;bo_draw_line_bottom := FALSE;
			case rb_draw.ItemIndex of
				0 : ;
				1 : bo_draw_rect := TRUE;
				2 : bo_draw_line_bottom := TRUE
			end;
			str_obj_line_bottom_pos_and_width := cb_obj_pos_width.Text;
			str_field_codice_record := cb_codice_record.Text;
			str_section_group_field := cb_group_by_section.Text;
			str_SQL_PK_debug_field := self.str_SQL_PK_debug_field.Text;

			bo_exportable_DBF := cbx_export_DBF.Checked AND cbx_export_DBF.Enabled;
			bo_draw_last_line := cbx_draw_last_line.Checked;
			bo_double_thickness := cbx_double_thickness.Checked;

			bo_conta_records := cbx_conta_records.Checked;
			if bo_conta_records {AND NOT bo_conta_records_bak} then
//				for i := 1 to get_num_sections do sections_1B(i).bo_conta_records := (i = i_section_1B);
				for i := 0 to get_num_sections-1 do sections_ZB(i).bo_conta_records := (i = i_section_ZB);
			str_record_descr_runtime := str_record_name.Text;

//			export_type := obj_export_type(cb_export_integrale.ItemIndex);
//			export_type_fields_default := obj_export_type(cb_export_type_fields_default.ItemIndex);
//			str_sigla := self.str_export_ID.Text;
//			i_export_shift_columns := self.i_export_shift_columns.get_ASinteger(FALSE)
		end;

		read_expint(i_written_expint);
		for i := 0 to expint_profiles_count-1 do
//			globale.expint_profiles[i].expint_pages[i_pagina].expint_sections[i_section].assign(expint_sections[i]);
//			get_expint_section_ZB(i, i_pagina_1B - 1, i_section_1B - 1).assign(expint_sections[i]);
			get_expint_section_ZB(i, i_pagina_ZB, i_section_ZB).assign(expint_sections[i]);

//		if (i_section_1B = MAIN_SECTION) then begin
		if (i_section_ZB = MAIN_SECTION_ZB) then begin
			assign_orizzontale_ZB(i_pagina_ZB, (rb_orientamento.ItemIndex = 1));

			if (globale.tiporeport in LABEL_TYPES) then set_draw_lines_separazione_label(cbx_draw_lines_separazione_label.Checked);

			if (globale.tiporeport = TR_LABEL_STANDALONE) then begin
				// così fino al 2008-07-31
//				set_label_size_X_cm(leggi_text_real(handle,r_size_label_x,0.5,50,'Dimensione orizzontale',get_label_size_X_cm));
//				set_label_size_Y_cm(leggi_text_real(handle,r_size_page_y,0.25,50,'Dimensione verticale',get_label_size_Y_cm))

				// così dal 2008-07-31
				set_label_size_X_cm(leggi_text_real(handle, r_size_label_x, 0.5, MAX_WIDTH_LABEL_CM, 'Dimensione orizzontale', get_label_size_X_cm));
				set_label_size_Y_cm(leggi_text_real(handle, r_size_label_y, 0.25, MAX_HEIGHT_LABEL_CM, 'Dimensione verticale', get_label_size_Y_cm));
//				set_PHpage_size_X_cm_1B(i_pagina_1B, leggi_text_real(handle, r_size_page_x, 0.5, MAX_WIDTH_PHISICAL_PAGE_CM, 'Dimensione orizzontale pagina', get_PHpage_size_X_cm_1B(i_pagina_1B)));
				set_PHpage_size_X_cm_ZB(i_pagina_ZB, leggi_text_real(handle, r_size_page_x, 0.5, MAX_WIDTH_PHISICAL_PAGE_CM, 'Dimensione orizzontale pagina', get_PHpage_size_X_cm_ZB(i_pagina_ZB)));
//				set_PHpage_size_Y_cm_1B(i_pagina_1B, leggi_text_real(handle, r_size_page_y, 0.25, MAX_HEIGHT_PHISICAL_PAGE_CM, 'Dimensione verticale', get_PHpage_size_Y_cm_1B(i_pagina_1B)))
				set_PHpage_size_Y_cm_ZB(i_pagina_ZB, leggi_text_real(handle, r_size_page_y, 0.25, MAX_HEIGHT_PHISICAL_PAGE_CM, 'Dimensione verticale', get_PHpage_size_Y_cm_ZB(i_pagina_ZB)))
			end
			else begin
				var bo_LAB := FALSE;r_LAB_new_height := 0;
//				set_PHpage_size_X_cm_1B(i_pagina_1B, leggi_text_real(handle, r_size_page_x, 0.5, MAX_WIDTH_PHISICAL_PAGE_CM, 'Dimensione orizzontale pagina', get_PHpage_size_X_cm_1B(i_pagina_1B)));
				set_PHpage_size_X_cm_ZB(i_pagina_ZB, leggi_text_real(handle, r_size_page_x, 0.5, MAX_WIDTH_PHISICAL_PAGE_CM, 'Dimensione orizzontale pagina', get_PHpage_size_X_cm_ZB(i_pagina_ZB)));
//				r_PH_new_height := leggi_text_real(handle, r_size_page_y, 0.25, MAX_HEIGHT_PHISICAL_PAGE_CM, 'Dimensione verticale pagina', get_PHpage_size_Y_cm_1B(i_pagina_1B));
				r_PH_new_height := leggi_text_real(handle, r_size_page_y, 0.25, MAX_HEIGHT_PHISICAL_PAGE_CM, 'Dimensione verticale pagina', get_PHpage_size_Y_cm_ZB(i_pagina_ZB));
//				var bo_PH := (r_PH_new_height <> get_PHpage_size_Y_cm_1B(i_pagina_1B));
				var bo_PH := (r_PH_new_height <> get_PHpage_size_Y_cm_ZB(i_pagina_ZB));

				if (globale.tiporeport = TR_LABEL_REPORT) then begin
					set_label_size_X_cm(leggi_text_real(handle, r_size_label_x, 0.5, MAX_WIDTH_LABEL_CM, 'Dimensione orizzontale etichetta', get_label_size_X_cm));
					r_LAB_new_height := leggi_text_real(handle, r_size_label_y, 0.25, MAX_HEIGHT_LABEL_CM, 'Dimensione verticale etichetta', get_label_size_Y_cm);
					r_V_new_height := r_LAB_new_height;
					bo_LAB := (r_LAB_new_height <> get_label_size_Y_cm)
				end
				else r_V_new_height := r_PH_new_height;

				if (r_V_new_height <> get_Vpage_size_Y_cm(i_pagina_1B)) then begin
					if (get_num_sections_page(i_pagina_1B) > 1) then begin
//						var ss : cl_sezione := sections_1B(2, i_pagina_1B);
						var ss : cl_sezione := sections_ZB(1, i_pagina_ZB);
						if NOT ss.bo_autosize AND (r_V_new_height < cm2pixel_video_y(ss.r_y0_rel_cm + ss.r_y_sezione_cm)) then begin
							MessageBBox(handle, 'La nuova dimensione della pagina è incompatibile con la dimensione della sotto-sezione', MBOX_CAPTION, MB_ICONSTOP);
							exit
						end
					end;

					if (r_V_new_height <> get_Vpage_size_Y_cm(i_pagina_1B)) then begin
						set_Vpage_size_Y_cm(i_pagina_1B, r_V_new_height);
						set_oggetti_footer(handle, r_V_new_height - r_V_height_base_cm)
//						controllo.set_disegno_values
					end
				end;

				if bo_LAB then set_label_size_Y_cm(r_LAB_new_height);
//				if bo_PH then set_PHpage_size_Y_cm_1B(i_pagina_1B, r_PH_new_height);
				if bo_PH then set_PHpage_size_Y_cm_ZB(i_pagina_ZB, r_PH_new_height);
				if bo_LAB OR bo_PH then GM.set_disegno_values
			end;

			if (globale.tiporeport in LABEL_TYPES) then begin
				tm.i_lab_per_row := leggi_text_integer(handle, i_lab_per_row, 1, 200, 'Numero di etichette per pagina (larghezza)', tm.i_lab_per_row);
				tm.i_lab_per_page := leggi_text_integer(handle, i_lab_per_page, 1, 200, 'Numero di etichette per pagina (altezza)', tm.i_lab_per_page);
				tm.r_delta_labs_X_cm := leggi_text_real(handle, r_delta_x, 0, 10, 'Distanza orizzontale tra etichette', tm.r_delta_labs_X_cm);
				tm.r_delta_labs_Y_cm := leggi_text_real(handle, r_delta_y, 0, 10, 'Distanza verticale tra etichette', tm.r_delta_labs_Y_cm);

				set_numero_etichette(i_numero_stampe_etichetta.get_Asinteger(FALSE), cb_numero_stampe_etichetta.Text)
			end;

			if NOT read_profilo(cb_profiles.Text) then exit
		end;

		globale.i_text_only_colonne := trunc(cm2inches(get_Vpage_size_X_cm(i_pagina_1B)) * globale.i_text_only_cpi);

		set_global_modified(TRUE);
		sections_ZB(i_section_ZB).qry.Active := FALSE;	// chiudo la query, per obbligare a ricaricare
		check_objs_pos_in_section(0);
		close
	except
	end
end;

procedure Tdlg_sezione.btn_cancelClick(Sender : TObject);
begin
	with sections_ZB(i_section_ZB) do begin
		str_nome := str_nome_bak;
		r_y0_rel_cm := r_y0_rel_bak;
		r_y_sezione_cm := r_dy_sezione_bak;
		r_y_gruppo_cm := r_dy_gruppo_bak;
		r_minimum_required_space_cm := r_minimum_required_space_bak;
		bo_dont_break_fields := bo_dont_break_fields_bak;
		bo_dont_break_subsections := bo_dont_break_subsections_bak;
		bo_del_blanks := bo_del_blanks_bak;bo_fill_tutto := bo_fill_tutto_bak;
		bo_reprint_broken_sections := bo_reprint_broken_sections_bak;
//		bo_dont_export_continuazione := bo_dont_export_continuazione_bak;
//		bo_print_headers_colonne := bo_print_headers_colonne_bak;
		bo_dont_print_section := bo_dont_print_section_bak;
//		tsql_command.assign(qry_SQL_bak);
		tsql_command.Text := str_SQL_bak;
//		tsql_scripts.assign(qry_script_bak);
		tsql_scripts.Text := str_script_bak;
//		xxtsql_start_record.assign(qry_start_record_bak);
		str_SQL_start_record := str_SQL_start_record_BAK;
		font_default.assign(font_bak);
		str_obj_line_bottom_pos_and_width := str_obj_line_bottom_pos_and_width_bak;
		bo_double_thickness := bo_double_thickness_bak;
		set_draw_lines_separazione_label(bo_draw_lines_separazione_label_bak);
		bo_exportable_DBF := bo_exportable_bak;
		bo_print_only_if_subsection_has_records := bo_print_only_if_subsection_has_records_bak;
		bo_conta_records := bo_conta_records_bak;
		str_record_descr_runtime := str_record_descr_runtime_bak;

//		str_profilo_workstation_bak := get_workstation_page(i_pagina);	**** non serve perchè queste variabili non sono ancora state assegnate
//		str_profilo_IP_bak := get_IP_page(i_pagina);
//		str_profilo_username_bak := get_username_page(i_pagina);

		bo_draw_line_bottom := bo_draw_line_bottom_bak;
		bo_draw_last_line := bo_draw_last_line_bak;
		bo_draw_rect := bo_draw_rect_bak
	end;
	close
end;

procedure Tdlg_sezione.r_dy_gruppoChange(Sender : TObject);
begin
	if bo_started AND (sections_ZB(i_section_ZB).i_father_ZB <> MAIN_SECTION_ZB) then
		r_dy_sezione.Text := r_dy_gruppo.Text
end;

procedure Tdlg_sezione.btn_fontClick(Sender : TObject);
begin
	font_dialog.font.assign(sections_ZB(i_section_ZB).font_default);
	if font_dialog.execute then begin
		sections_ZB(i_section_ZB).font_default.assign(font_dialog.font);
//		bo_font_modified := TRUE
	end
end;

procedure Tdlg_sezione.FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
begin
	if tratta_tasto_maximize(self,key,shift) then exit;
	case key of
		VK_F1 : help_proc
	end;
	key_button(key,VK_F9,btn_ok,FALSE)
end;

procedure Tdlg_sezione.enable_record_name;
begin
	enable_FC(txt_record_name,cbx_conta_records.Checked)
end;

procedure Tdlg_sezione.str_SQL_selectKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
	case key of VK_ESCAPE : close end
end;

procedure Tdlg_sezione.enable_ctrls;
begin
	enable_FC(txt_obj_pos_width, (i_section_ZB <> MAIN_SECTION_ZB) AND (rb_draw.Itemindex > 0));
	cbx_draw_last_line.Enabled := (i_section_ZB <> MAIN_SECTION_ZB) AND (rb_draw.Itemindex = 2);	// solo sulla linea
	cbx_double_thickness.Enabled := cb_obj_pos_width.Enabled AND (cb_obj_pos_width.ItemIndex <> -1);
{	if NOT globale.bo_export_allowed OR NOT globale.xpages_info[get_pagina_logica_attiva].bo_export_allowed
		then make_all_children_enabled(page_export_integrale, FALSE); }

//	btn_genera_SQL.Visible := (pc.ActivePage = page_SQL) AND (globale.str_local_connection_parms = '') AND (globale.str_db_table <> '');
	btn_genera_SQL.Visible := (pc.ActivePage = page_SQL) AND NOT globale.connection_config.blank;

	make_all_children_enabled(page_export_DBF, cbx_export_DBF.Checked);
	if NOT cbx_export_DBF.Checked then begin
//		cbx_export_DBF.Enabled := (i_section_1B <= MAIN_SECTION + 1);	// exportabili: la sezione MAIN e DETTAGLI
		cbx_export_DBF.Enabled := (i_section_ZB <= MAIN_SECTION_ZB + 1);	// exportabili: la sezione MAIN e DETTAGLI
		page_export_DBF.Enabled := cbx_export_DBF.Enabled
	end;

	var bo := cbx_SQL_save_to.Checked OR cbx_SQL_read_from.Checked;
	str_SQL_filename.Enabled := bo;btn_browse_SQL_filename.Enabled := bo;
	bo := NOT (cbx_SQL_read_from.Checked AND NOT cbx_SQL_save_to.Checked);
	str_SQL_select.ReadOnly := NOT bo;
	str_SQL_select.Font.Color := ifcolor(bo, clWindowText, clGrayText);

//	var bo_XML_allowed := globale.bo_export_allowed AND globale.lpages_info[i_pagina_1B].bo_XML_allowed;
	var bo_XML_allowed := TRUE;
	make_all_children_enabled(page_XML, bo_XML_allowed AND cbx_XML_export.Checked);
	if bo_XML_allowed AND NOT cbx_XML_export.Checked then make_all_fathers_enabled(cbx_XML_export);

	cbx_dont_break_subsections.Enabled := bo_has_subsections;
	cbx_reprint.Enabled := bo_has_subsections;
	cbx_print_only_if_subsection_has_records.Enabled := bo_has_subsections AND NOT cbx_bo_stampa_anche_se_vuota.Checked;
	cbx_bo_stampa_anche_se_vuota.Enabled := NOT cbx_print_only_if_subsection_has_records.Checked;
//	cbx_dont_print.Enabled := (i_section_1B <> MAIN_SECTION);
	cbx_dont_print.Enabled := (i_section_ZB <> MAIN_SECTION_ZB);

	AL_colonna_colorate_delete.Enabled := (grid_colonne_colorate.RowCount > grid_colonne_colorate.FixedRows);
	AL_colonne_colorate_sort.Enabled := (grid_colonne_colorate.RowCount > grid_colonne_colorate.FixedRows + 1);	// ne servono almeno 2 da riordinare

	enable_ctrls_expint
end;

procedure Tdlg_sezione.rb_orientamentoClick(Sender : TObject);
begin
//	if bo_started AND globale.bo_report then begin	// se report, scambio la dimensione h e v
	if bo_started AND (globale.tiporeport in REPORT_TYPES) then begin	// se report, scambio la dimensione h e v
		var s := r_size_page_x.Text;r_size_page_x.Text := r_size_page_y.Text;r_size_page_y.Text := s
	end
end;

procedure set_oggetti_footer(handle : hwnd;r_delta_height_cm : double);
begin
	var i_delta : smallint := round(r_delta_height_cm * 100);
	if (i_delta = 0) then exit;

	if (MessageBBox(handle, 'Vuoi ' +
		ifs((get_num_sections > 1) AND sections_1B(2).bo_autosize, 'ridimensionare la sottosezione e ') +
		'mantenere gli oggetti del footer legati al fondo pagina?',MBOX_CAPTION,MB_QUESTION) <> IDYES) then exit;

	var i_pagina : smallint := get_pagina_logica_attiva_1B;
	// vorrei passare resize_subsection(,,TRUE), ma è inutile perchè i valori sono già assegnati
	if (i_delta < 0) AND NOT globale.resize_subsection(i_pagina,i_delta,{TRUE}FALSE) then abort;		// prima ridimensiono la subsection
	globale.move_objects(i_pagina,i_delta);											// sposto gli oggetti
	if (i_delta > 0) AND NOT globale.resize_subsection(i_pagina,i_delta,{TRUE}FALSE) then abort		// poi ridimensiono la subsection
end;

procedure Tdlg_sezione.btn_standard_labelsClick(Sender : TObject);
//var i : smallint;
begin
{	i := select_standard_configuration(self);
	if (i <> -1) then begin
		r_marg_sx.Text := strid(CONFIGURAZIONI_STANDARD[i].get_page_marg_SX_cm(),0,0);
		r_marg_up.Text := strid(CONFIGURAZIONI_STANDARD[i].get_page_marg_UP_cm(),0,0);
		r_size_x.Text := strid(CONFIGURAZIONI_STANDARD[i].r_labsize_X_cm,0,0);
		r_size_y.Text := strid(CONFIGURAZIONI_STANDARD[i].get_page_size_Y_cm(,0,0);

		i_lab_per_row.Text := inttostr(CONFIGURAZIONI_STANDARD[i].i_lab_per_row);
		i_lab_per_page.Text := inttostr(CONFIGURAZIONI_STANDARD[i].i_lab_per_page);
		r_delta_x.Text := strid(CONFIGURAZIONI_STANDARD[i].r_delta_labs_X_cm,0,0);
		r_delta_y.Text := strid(CONFIGURAZIONI_STANDARD[i].r_delta_labs_Y_cm,0,0);

		cbx_pagina_intera.Checked := TRUE
	end }
end;

procedure Tdlg_sezione.cb_printerExit(Sender : TObject);
begin
	fill_info_cassetto_carta(cb_printer.Text, cb_cassetto)
end;

procedure Tdlg_sezione.enable_PPL;
begin
	var bo := (i_section_ZB = MAIN_SECTION_ZB) {AND (cb_ppl.ItemIndex <> byte(FGPPL_NOTHING))};
	enable_FC(txt_printer, bo);
	enable_FC(txt_cassetto, bo)
end;

procedure Tdlg_sezione.btn_index_esempioClick(Sender : TObject);
begin
	memo_start_record.Text := '"UPDATE xxx SET i_field_pagina=" + pagina() + " WHERE str_codice = " + str_codice'
end;

procedure Tdlg_sezione.btn_new_docClick(Sender : TObject); begin new_profilo end;
procedure Tdlg_sezione.btn_delete_docClick(Sender : TObject); begin delete_profilo end;

procedure Tdlg_sezione.new_profilo;
begin
	var str_name := '';
	if NOT InputQuery('Creazione nuovo profilo', 'Nome del nuovo profilo', str_name) then exit;
	read_profilo(cb_profiles.Text);
	str_name := lowercase(str_name);
	var p : cl_print_profile := new_profile(str_name, 0, get_profile(cb_profiles.Text));
	load_profili_itemlist(cb_profiles.Items);
	cb_select(cb_profiles,p.str_profilo);
	set_active_profile(p.str_profilo)
end;

procedure Tdlg_sezione.delete_profilo;
begin
	if (cb_profiles.Items.Count = 1) then begin
		MessageBBox(handle, 'Impossibile eliminare il primo profilo', MBOX_CAPTION);
		exit
	end;
	if (MessageBBox(handle, 'Vuoi eliminare il profilo <' + cb_profiles.Text + '> ?', MBOX_CAPTION, MB_QUESTION_DEF2) <> IDYES)
		then exit;
	delete_profile(cb_profiles.Text);
	load_profili_itemlist(cb_profiles.Items);
	cb_profiles.Itemindex := 0;
//	set_active_profile(cb_profiles.Text);
	write_profilo(cb_profiles.Text)
end;

function Tdlg_sezione.read_profilo(str_profilo : string) : boolean;
begin
	try
		set_active_profile(str_profilo);

//		set_page_marg_SX_cm_1B(i_pagina_1B, leggi_text_real(handle, r_marg_sx, 0, 20, 'margine sinistro pagina', get_page_marg_SX_cm_1B(i_pagina_1B)));
		set_page_marg_SX_cm_ZB(i_pagina_ZB, leggi_text_real(handle, r_marg_sx, 0, 20, 'margine sinistro pagina', get_page_marg_SX_cm_ZB(i_pagina_ZB)));
//		set_page_marg_UP_cm_1B(i_pagina_1B, leggi_text_real(handle, r_marg_up, 0, 20, 'margine superiore pagina', get_page_marg_UP_cm_1B(i_pagina_1B)));
		set_page_marg_UP_cm_ZB(i_pagina_ZB, leggi_text_real(handle, r_marg_up, 0, 20, 'margine superiore pagina', get_page_marg_UP_cm_ZB(i_pagina_ZB)));

//		xset_flag_printer_pagina_logica(xFGPPL_type(cb_ppl.ItemIndex), i_pagina);
		set_workstation_page(str_profilo_workstation.Text, i_pagina_1B);
		set_IP_page(str_profilo_IP.Text, i_pagina_1B);
		set_username_page(str_profilo_username.Text, i_pagina_1B);

		set_printer_page(cb_printer.Text, i_pagina_1B);
		set_cassetto_carta_page(cb_cassetto.Text, i_pagina_1B);
		result := TRUE
	except
		result := FALSE
	end
end;

procedure Tdlg_sezione.write_profilo(str_profilo : string);
begin
	set_active_profile(str_profilo);

//	r_marg_sx.Text := strid(get_page_marg_SX_cm_1B(i_pagina_1B), 0, 0);
	r_marg_sx.Text := strid(get_page_marg_SX_cm_ZB(i_pagina_ZB), 0, 0);
//	r_marg_up.Text := strid(get_page_marg_UP_cm_1B(i_pagina_1B), 0, 0);
	r_marg_up.Text := strid(get_page_marg_UP_cm_ZB(i_pagina_ZB), 0, 0);

//	var fg : xFGPPL_type := xget_flag_printer_pagina_logica(i_pagina);
//	cb_ppl.ItemIndex := byte(fg);
//	txt_descrizione_ppl.Caption := FGPPL_descrizione[fg];
	str_profilo_workstation.Text := get_workstation_page(i_pagina_1B);
	str_profilo_IP.Text := get_IP_page(i_pagina_1B);
	str_profilo_username.Text := get_username_page(i_pagina_1B);

//	if (fg = FGPPL_NOTHING) then s := '' else s := get_printer_page(i_pagina);
//	cb_select(cb_printer, get_printer_page(i_pagina));
	var s := get_printer_page(i_pagina_1B);
	cb_select(cb_printer, s);
	if (s = '') then cb_cassetto.clear
	else begin
		fill_info_cassetto_carta(s, cb_cassetto);
		cb_select(cb_cassetto, get_cassetto_carta_page(i_pagina_1B))
	end;
	enable_PPL
end;

procedure Tdlg_sezione.cb_profilesExit(Sender : TObject);
begin
	var str_old := get_active_profile().str_profilo;
	if (cb_profiles.Text <> str_old) then begin
		if NOT read_profilo(str_old) then begin
			cb_select(cb_profiles, str_old);
			abort
		end;
//		set_active_profile(cb_profiles.Text);
		write_profilo(cb_profiles.Text)
	end
end;

procedure Tdlg_sezione.btn_page_sizeClick(Sender : TObject);
begin
	var sx  : real := 0;var up  : real := 0;
	var h : real := tm.i_phisical_10mm_height / 100;
	var w : real := tm.i_phisical_10mm_width / 100;
	if (rb_orientamento.ItemIndex = 1) then begin var r : real := h;h := w;w := r end;

	try sx := leggi_text_real(handle, r_marg_sx, 0, 20, 'margine sinistro pagina', 0) except end;
	try up := leggi_text_real(handle, r_marg_up, 0, 20, 'margine superiore pagina', 0) except end;

	r_size_page_x.Text := strid(w - sx, 0, 0);
	r_size_page_y.Text := strid(h - up, 0, 0)
end;

procedure Tdlg_sezione.help_proc;
var str_url : string;	//*
begin
	if (pc.Activepage = page_export) then begin
		if (page_export_opzioni.ActivePage = page_expint) then str_url := EXPORT_INTEGRALE_HELP
		else if (page_export_opzioni.ActivePage = page_XML) then str_url := XML_HELP
		else str_url := EXPORT_HELP
	end
	else str_url := SEZIONE_HELP;

	help.help_proc(self, str_url)
end;

var bo_numero_etichette : boolean;

procedure Tdlg_sezione.i_numero_stampe_etichettaChange(Sender : TObject);
begin
	if bo_numero_etichette then exit;
	try
		bo_numero_etichette := TRUE;
		cb_numero_stampe_etichetta.ItemIndex := -1
	finally
		bo_numero_etichette := FALSE
	end
end;

procedure Tdlg_sezione.cb_numero_stampe_etichettaChange(Sender : TObject);
begin
	try
		bo_numero_etichette := TRUE;
		i_numero_stampe_etichetta.Text := ''
	finally
		bo_numero_etichette := FALSE
	end
end;

procedure Tdlg_sezione.genera_SQL_default;
begin
	if NOT btn_genera_SQL.Enabled OR NOT btn_genera_SQL.Visible then exit;
//	str_SQL_select.Text := 'SELECT * FROM "' + globale.str_db_table + '"' + ifs(str_SQL_select.Text, ACAPO2 + str_SQL_select.Text)
	str_SQL_select.Text := 'SELECT * FROM "' + globale.connection_config.str_table + '"' + ifs(str_SQL_select.Text, ACAPO2 + str_SQL_select.Text)
end;

procedure Tdlg_sezione.lb_expint_elencoClick(Sender : TObject);
begin
	if (i_written_expint = lb_expint_elenco.Itemindex) then exit;
	if (i_written_expint <> -1) then read_expint(i_written_expint);
	write_expint(lb_expint_elenco.ItemIndex)
end;

procedure Tdlg_sezione.read_expint(i_profilo : expint_index_type);
begin
	if (i_profilo = -1) then exit;
	var x : cl_expint_section := expint_sections[i_profilo];

	// opzioni EXPORT INTEGRALE
	x.expint_mode := section_expint_mode_type(cb_export_integrale.Itemindex);
	x.expint_objs_default_mode := object_expint_mode_type(cb_export_type_fields_default.Itemindex);
	x.str_sigla := str_export_sigla.Text;
	x.str_descrizione_runtime := str_expint_descrizione.Text;
	x.bo_skip_on_continuazione := cbx_dont_export_continuazione.Checked;
	x.bo_headers_colonne := cbx_header_colonne.Checked;
	x.i_shift_columns := i_expint_shift_columns.get_ASinteger(FALSE);

	// opzioni XML
	x.bo_XML_allowed := cbx_XML_export.Checked;
	x.str_struttura_XML := str_XML_text.Text
end;

procedure Tdlg_sezione.write_expint(i_profilo : expint_index_type);
begin
	if (i_profilo = -1) then exit;
	i_written_expint := i_profilo;
	var x : cl_expint_section := expint_sections[i_profilo];

	if get_export_target_XML(i_profilo) then page_export_opzioni.ActivePage := page_XML else page_export_opzioni.ActivePage := page_expint;

	// exportazione integrale
	cb_export_integrale.ItemIndex := byte(x.expint_mode);
	cb_export_type_fields_default.ItemIndex := byte(x.expint_objs_default_mode);
	str_export_sigla.Text := x.str_sigla;
	str_expint_descrizione.Text := x.str_descrizione_runtime;
	cbx_dont_export_continuazione.Checked := x.bo_skip_on_continuazione;
	cbx_header_colonne.Checked := x.bo_headers_colonne;
	i_expint_shift_columns.set_ASinteger(x.i_shift_columns);

	// XML
	cbx_XML_export.Checked := x.bo_XML_allowed;
	str_XML_text.Text := x.str_struttura_XML;

	enable_ctrls_expint
end;

procedure Tdlg_sezione.cbx_conta_recordsClick(Sender : TObject); begin enable_record_name end;
procedure Tdlg_sezione.generic_enable_ctrls(Sender : TObject); begin enable_ctrls end;
procedure Tdlg_sezione.btn_genera_SQLClick(Sender : TObject); begin genera_SQL_default end;
procedure Tdlg_sezione.btn_helpClick(Sender : TObject); begin help_proc end;
procedure Tdlg_sezione.btn_profilo_workstationClick(Sender : TObject); begin str_profilo_workstation.Text := get_computer_name end;
procedure Tdlg_sezione.btn_profilo_usernameClick(Sender : TObject); begin str_profilo_username.Text := get_windows_username end;
procedure Tdlg_sezione.btn_profilo_IPClick(Sender : TObject); begin str_profilo_IP.Text := get_IP end;
procedure Tdlg_sezione.btn_help_profilesClick(Sender : TObject); begin MessageBBox(handle, HELP_PROFILES, MBOX_CAPTION) end;

procedure Tdlg_sezione.enable_ctrls_expint;
begin
	var i_profilo : expint_index_type := lb_expint_elenco.ItemIndex;
	if (i_profilo = -1) then exit;
//	var xp : cl_logical_page_info := globale.pages_info[i_pagina];
	var x : cl_expint_page := get_expint_page_ZB(i_profilo, i_pagina_1B - 1);

//	make_all_children_enabled(page_export_integrale, obj_export_type(cb_export_integrale.ItemIndex) <> OEXP_NOT);
	var bo := globale.bo_export_allowed AND x.bo_export_allowed;
//	make_all_children_enabled(panel_expint_edit, bo AND (xobj_export_type(cb_export_integrale.Itemindex) <> OEXP_NOT));
	make_all_children_enabled(panel_expint_edit, bo AND NOT (section_expint_mode_type(cb_export_integrale.Itemindex) in [{SEXP_NOT,} SEXP_IMPOSSIBLE]));
	cbx_header_colonne.Enabled := cbx_header_colonne.Enabled AND x.bo_print_headers;

	if bo AND NOT panel_expint_edit.Enabled then begin
		make_all_fathers_enabled(panel_expint_edit);
		enable_FC(txt_export_integrale, TRUE);
		lb_expint_elenco.Enabled := TRUE
	end
end;

procedure Tdlg_sezione.btn_assegna_fontClick(Sender : TObject);
const MBOX_CAPTION = 'assegnazione font';
begin
	if (MessageBBox(handle, 'Vuoi assegnare il font della sezione a tutti gli oggetti della sezione?', MBOX_CAPTION, MB_QUESTION) <> IDYES) then exit;
	var i_oggetti : obj_index_type := 0;
	for var i : obj_index_type := 1 to i_objs do begin
		var x : objs_type := xobjs(i);
		if (x.ca.i_section_1B = i_section_ZB + 1) AND (x.ca.tipo_oggetto = LABEL_OBJ) then begin
			inc(i_oggetti);
			x.aslabel.assign_font(sections_ZB(i_section_ZB).font_default, 0, 0);
			x.aslabel.Repaint
		end
	end;
	set_global_modified;
	MessageBBox(handle, 'Assegnazione eseguita, ' + i_oggetti.ToString + ' oggetti modificati', MBOX_CAPTION)
end;

procedure Tdlg_sezione.btn_browse_SQL_filenameClick(Sender : TObject);
begin
	var str_filename : string := str_SQL_filename.Text;
	if browse_for_files_open(self, 'Comando SQL condiviso', str_filename, EXTERNAL_SQL_SECTION_COMMAND_EXT, EXTERNAL_SQL_SECTION_COMMAND_FILTER,
		ExtractFilePath(globale.str_filename), {relative_path}TRUE, {file_must_exist}FALSE)
			then str_SQL_filename.Text := str_filename
end;

function Tdlg_sezione.IO_form_size_and_pos_custom_proc(bo_save : boolean;reg : TFRegistry) : boolean;
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

procedure Tdlg_sezione.find_dialogFind(Sender : TObject);
begin
	find_dialog.CloseDialog;
	execute_find(find_dialog.FindText)
end;

procedure Tdlg_sezione.AL_colonna_colorata_addExecute(Sender : TObject); begin colonna_colorata_aggiungi end;
procedure Tdlg_sezione.AL_colonna_colorate_deleteExecute(Sender : TObject); begin colonna_colorata_elimina end;
procedure Tdlg_sezione.AL_colonne_colorate_sortExecute(Sender : TObject); begin sort_colonne_colorate end;
procedure Tdlg_sezione.AL_findExecute(Sender : TObject); begin find end;
procedure Tdlg_sezione.AL_find_nextExecute(Sender : TObject); begin find_next end;

{procedure Tdlg_sezione.call_find_dialog;
var memo : TMemo;
begin
	memo := get_active_memo;if (memo = NIL) then begin beep;exit end;
	find_dialog.FindText := coalesce(memo.SelText, str_find_text);
	find_dialog.options := FD_DIALOG_OPTIONS;
	find_dialog.execute
end;}

procedure Tdlg_sezione.execute_find(str_find_text: string);
begin
	var memo : TMemo := get_active_memo;if (memo = NIL) then begin beep;exit end;
	str_find_text := uppercase(str_find_text);self.str_find_text := str_find_text;
	var i : smallint := pos(str_find_text, copy(uppercase(memo.Lines.Text), memo.SelStart+1+1, MAXINT));
	if (i = 0) then MessageBBox(handle, str_find_text + ACAPO2 + 'Testo non trovato', MBOX_CAPTION)
	else begin
//		if (pc.ActivePage <> page_note) then begin pc.ActivePage := page_note;my_sleep end;
		if NOT memo.Focused then memo.SetFocus;
		memo.Selstart := memo.Selstart + i -1+1;memo.Sellength := length(str_find_text)
	end
end;

procedure Tdlg_sezione.find;
begin
	var memo : TMemo := get_active_memo;if (memo = NIL) then begin beep;exit end;
	find_dialog.FindText := coalesce(memo.seltext, str_find_text);
	find_dialog.options := FD_DIALOG_OPTIONS;
	find_dialog.execute
end;

procedure Tdlg_sezione.find_next;
begin
	if (str_find_text = '') then find else execute_find(str_find_text)
end;

function Tdlg_sezione.get_active_memo: TMemo;
begin
	result := NIL;
	if (pc.ActivePage = page_SQL) then result := str_SQL_select
end;

procedure Tdlg_sezione.colonna_colorata_aggiungi;
begin
	var cc := cl_colonna_colorata.create;
	try
		if colonna_colorata_edit_proc(self, cc, i_section_ZB) then begin
			var sz := sections_ZB(i_section_ZB);
			var i : smallint := length(sz.colonne_colorate);
			setLength(sz.colonne_colorate, i+1);sz.colonne_colorate[i] := cc;cc := NIL;
			write_colonne_colorate
		end
	finally
		if (cc <> NIL) then cc.free
	end
end;

procedure Tdlg_sezione.colonna_colorata_elimina;
begin
	var i : smallint := grid_colonne_colorate.Row - 1;if (i = -1) then exit;
	if (MessageBBox(handle, 'Vuoi eliminare la colonna colorata selezionata?', MBOX_CAPTION, MB_QUESTION OR MB_DEFBUTTON2) <> IDYES) then exit;
	var sz : cl_sezione := sections_ZB(i_section_ZB);
	sz.colonne_colorate[i].free;
	if (i <> high(sz.colonne_colorate)) then move(sz.colonne_colorate[i+1], sz.colonne_colorate[i], sizeof(pointer) * (length(sz.colonne_colorate) - i));
	setLength(sz.colonne_colorate, high(sz.colonne_colorate));
	write_colonne_colorate
end;

procedure Tdlg_sezione.grid_colonne_colorateDblClick(Sender : TObject);
begin
	var i : smallint := grid_colonne_colorate.Row - 1;
	if (i = -1) then colonna_colorata_aggiungi else colonna_colorata_edit_proc(self, sections_ZB(i_section_ZB).colonne_colorate[i], i_section_ZB);
	write_colonne_colorate
end;

procedure Tdlg_sezione.write_colonne_colorate;
var s : string;	//*
begin
	var sz : cl_sezione := sections_ZB(i_section_ZB);
	grid_colonne_colorate.RowCount := length(sz.colonne_colorate) + 1;
	for var i_row := 1 to length(sz.colonne_colorate) do begin		// indice da 1 a LEN, l'indice ZERO é la riga di intestazione
		var cc : cl_colonna_colorata := sz.colonne_colorate[i_row - 1];
		grid_colonne_colorate.Cells[0, i_row] := cc.str_descrizione;

		if (cc.tipo_limite in [TLC_FULL_WIDTH, TLC_SECTION_WIDTH]) then s := DESCRIZIONE_TIPO_LIMITE_COLONNE_COLORATE[cc.tipo_limite]
		else s := floatToStr(my_round(cc.get_margine_sx_CM, 2)) + ' - ' + floatToStr(my_round(cc.get_margine_dx_CM, 2)) + ' cm';
		grid_colonne_colorate.Cells[1, i_row] := s;

		case cc.tipo_limite of
//			TLC_FULL_WIDTH, TLC_SECTION_WIDTH, TLC_ASSEGNATO : ;
			TLC_OBJECT : s := cc.str_limite_object;
			TLC_LINES : s := cc.str_left_line + ' - ' + cc.str_right_line
			else s := ''
		end;
		grid_colonne_colorate.Cells[2, i_row] := s;

		for var i_col := 0 to MAX_COLORI_CONDIZIONALI - 1 do
			grid_colonne_colorate.Cells[COLONNE_COLORATE_FIXED + i_col, i_row] := cc.colori_condizionali[i_col].str_condizione
	end;
	enable_ctrls
end;

procedure Tdlg_sezione.grid_colonne_colorateDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
	grid : TStringGrid absolute sender;
	str_text : string;
	lo_colore : TColor;
begin
	if (aRow = 0) then exit;
	var sz : cl_sezione := sections_ZB(i_section_ZB);
	var cc : cl_colonna_colorata := sz.colonne_colorate[aRow - 1];
	if (Acol >= COLONNE_COLORATE_FIXED) then begin
		var i_ndx_colore : smallint := aCol - COLONNE_COLORATE_FIXED;
		str_text := cc.colori_condizionali[i_ndx_colore].str_condizione;
		lo_colore := cc.colori_condizionali[i_ndx_colore].colore.lo_colore
	end
	else begin
		str_text := grid.Cells[ACol, ARow];
		lo_colore := cc.colore_base.lo_colore
	end;
	if cc.bo_disabled then lo_colore := clLtGray else lo_colore := cc.decodifica_colore(lo_colore);
	grid.Canvas.Brush.Color := lo_colore;
	grid.Canvas.FillRect(Rect);grid.Canvas.TextRect(rect, str_text)
end;

procedure Tdlg_sezione.sort_colonne_colorate;
begin
	var i_inversioni : smallint := 0;
	var sz : cl_sezione := sections_ZB(i_section_ZB);
	for var i : smallint := 0 to high(sz.colonne_colorate) - 1 do
		for var j : smallint := i+1 to high(sz.colonne_colorate) do
			if (sz.colonne_colorate[i].get_margine_sx_CM > sz.colonne_colorate[j].get_margine_sx_CM) then begin
				var temp := sz.colonne_colorate[i];
				sz.colonne_colorate[i] := sz.colonne_colorate[j];
				sz.colonne_colorate[j] := temp;
				inc(i_inversioni)
			end;
	if (i_inversioni <> 0) then write_colonne_colorate;		// altrimenti non è cambiato nulla
	MessageBBox(handle, ifs(i_inversioni = 0, 'Nessun ordinamento necessario', 'Ordinamento eseguito'), MBOX_CAPTION)
end;

initialization
	galateo_initialization_debug('sezione_edit')
finalization
	galateo_finalization_debug('sezione_edit')
end.
