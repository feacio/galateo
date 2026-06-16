unit colonna_colorata_edit;

{$ifNdef GALATEO_EXE} *** {$endif}

{$I defines}

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Actions, ActnList, ExtCtrls, StdCtrls, ComCtrls,
	FCommons, federico, FBitBtn, gdich, colori_proc;

function colonna_colorata_edit_proc(father : TForm;cc : cl_colonna_colorata;i_sezione_ZB : section_index_type) : boolean;

type
  Tdlg_colonna_colorata_edit = class(TForm)
	 str_descrizione: TFEdit;
	 txt_descrizione: TMyLabel;
	 rb_tipo_limite: TFRadioGroup;
	 panel: TFPanel;
	 panel_footer: TFPanel;
	 btn_ok: TFBitBtn;
	 btn_cancel: TFBitBtn;
	 txt_limite_sx: TMyLabel;
    str_limite_sx: TFEdit;
	 txt_limite_dx: TMyLabel;
    str_limite_dx: TFEdit;
    cb_object: TFCombo;
    txt_object: TMyLabel;
    txt_linea_sx: TMyLabel;
    cb_linea_sx: TFCombo;
	 txt_linea_dx: TMyLabel;
	 cb_linea_dx: TFCombo;
	 gbox_limiti: TFGroupBox;
    txt_colore_base: TMyLabel;
    panel_colore_base: TFPanel;
    AL: TActionList;
	 AL_save: TAction;
    AL_annulla: TAction;
	 cb_colore_base_symbolico: TFCombo;
	 AL_help: TAction;
	 btn_help: TFBitBtn;
    pc_colori: TFPageControl;
    page_colore_condizionale: TTabSheet;
    page_gradazione_colore: TTabSheet;
	 txt_condizione: TMyLabel;
    txt_colore: TMyLabel;
    txt_color_00: TMyLabel;
    txt_color_01: TMyLabel;
	 txt_color_02: TMyLabel;
    txt_color_03: TMyLabel;
    txt_colore_symbolico: TMyLabel;
	 str_condizione_00: TFEdit;
	 panel_colore_00: TFPanel;
    btn_blank_00: TFBitBtn;
    panel_colore_01: TFPanel;
    str_condizione_01: TFEdit;
    btn_blank_01: TFBitBtn;
    str_condizione_02: TFEdit;
    panel_colore_02: TFPanel;
    btn_blank_02: TFBitBtn;
    panel_colore_03: TFPanel;
	 str_condizione_03: TFEdit;
    btn_blank_03: TFBitBtn;
    cb_colore_symbolico_00: TFCombo;
    cb_colore_symbolico_01: TFCombo;
    cb_colore_symbolico_02: TFCombo;
    cb_colore_symbolico_03: TFCombo;
    panel_grad_riferimento: TFPanel;
    panel_grad_minx: TFPanel;
    panel_grad_mix: TFPanel;
    panel_grad_max: TFPanel;
    txt_grad_formula_valore: TMyLabel;
    panel_grad_sample: TFPanel;
    panel_grad_mix_sample: TFPanel;
	 panel_grad_min_sample: TFPanel;
    panel_grad_max_sample: TFPanel;
	 txt_grad_valore_base: TMyLabel;
    i_grad_valore_min: TFEdit;
    txt_grad_colore_min: TMyLabel;
    panel_grad_colore_min: TFPanel;
    cb_grad_colore_symbolico_min: TFCombo;
    txt_grad_mix_header: TMyLabel;
	 txt_grad_mix_colore_iniziale: TMyLabel;
    panel_grad_mix_colore_iniziale: TFPanel;
    cb_grad_mix_colore_iniziale_symbolico: TFCombo;
    txt_grad_mix_colore_finale: TMyLabel;
	 panel_grad_mix_colore_finale: TFPanel;
    cb_grad_mix_colore_finale_symbolico: TFCombo;
    txt_grad_valore_max: TMyLabel;
	 i_grad_valore_max: TFEdit;
	 txt_grad_colore_max: TMyLabel;
    panel_grad_colore_max: TFPanel;
	 cb_grad_colore_symbolico_max: TFCombo;
    cbx_colori_condizionali: TFCheckBox;
    cbx_gradazione_colore: TFCheckBox;
    panel_grad_extra_range: TFPanel;
    txt_grad_valore_extra_range: TMyLabel;
    txt_grad_colore_extra_range: TMyLabel;
    panel_grad_colore_extra_range: TFPanel;
    cb_grad_colore_symbolico_extra_range: TFCombo;
    pbox: TPaintBox;
    str_grad_formula_valore: TFEdit;
    cbx_disabled: TFCheckBox;
    txt_condizione_abilitazione: TMyLabel;
    str_condizione_abilitazione: TFEdit;
    btn_righe_alterne: TFBitBtn;
	 AL_righe_alternate: TAction;
    FBitBtn1: TFBitBtn;
    AL_clear: TAction;
	 procedure FormCreate(Sender : TObject);
	 procedure FormCloseQuery(Sender : TObject;var CanClose : Boolean);
	 procedure generic_enable_ctrls(Sender : TObject);
	 procedure AAA_notify_modification(Sender : TObject);
	 procedure panel_colore_Click(Sender : TObject);
	 procedure btn_blank_Click(Sender : TObject);
	 procedure AL_saveExecute(Sender : TObject);
	 procedure AL_annullaExecute(Sender : TObject);
	 procedure cb_colore_symbolico_Click(Sender : TObject);
	 procedure AL_helpExecute(Sender : TObject);
	 procedure cbx_colori_Click(Sender : TObject);
	 procedure pboxPaint(Sender : TObject);
	 procedure AL_righe_alternateExecute(Sender : TObject);
	 procedure AL_clearExecute(Sender : TObject);
  private
		bo_started, bo_something_modified : boolean;
		pt_bo_result : boolean_punt;
		local_cc, external_cc : cl_colonna_colorata;
		i_sezione_ZB : section_index_type;
		str_condizione : array[0..MAX_COLORI_CONDIZIONALI-1] of TFEdit;
		panel_colore : array[0..MAX_COLORI_CONDIZIONALI-1] of TFPanel;
		cb_colore_symbolico : array[0..MAX_COLORI_CONDIZIONALI-1] of TFCombo;
		constructor xcreate(father : TForm;cc : cl_colonna_colorata;i_sezione_ZB : section_index_type;var bo_result : boolean);
		destructor free;
		procedure clear_execute;
		procedure write_data;
		function read_data : boolean;
		procedure enable_ctrls;
		procedure righe_alterne;
  end;

implementation

{$R *.dfm}

uses FMessage, FCtrls, FXStrings, validate, fProcs, FCtrls_RX,
	objects, pages, functions, sezione, proc;

const
	MBOX_CAPTION = 'Colonna colorata';
	HELP_COLONNE_COLORATE =
		'Le COLONNE COLORATE consentono di avere colonne verticali di report colorate con specifici colori.' + ACAPO2 +
		'La posizione e la larghezza di ogni colonna può essere assegnata, oppure definita in relazione a oggetti del report.' + ACAPO +
		'Vengono utilizzate le dimensioni degli oggetti in editing, se si desidera avere una dimensione dinamica della colonna usare le FORMULE.' + ACAPO2 +
		'Il colore di ogni colonna può essere fisso, oppure determinato attraverso la valutazione di condizioni, oppure calcolato come gradiente fra due colori estremi.' + ACAPO +
		'Nel caso della valutazione di condizioni, viene applicato il colore associato alla prima condizione soddisfatta, oppure il colore base se nessuna condizione è soddisfatta.' + ACAPO2 +
		'Ogni colore può essere definito in funzione dei COLORI SYMBOLICI (vedi OPZIONI GENERALI REPORT per la definizione e significato dei COLORI SYMBOLICI).';

function colonna_colorata_edit_proc(father : TForm;cc : cl_colonna_colorata;i_sezione_ZB : section_index_type) : boolean;
begin
	var dlg := Tdlg_colonna_colorata_edit.xcreate(father, cc, i_sezione_ZB, result);
	dlg.showmodal;dlg.release
end;

{ Tdlg_colonna_colorata_edit }

constructor Tdlg_colonna_colorata_edit.xcreate(father : TForm;cc : cl_colonna_colorata;i_sezione_ZB : section_index_type;var bo_result : boolean);
begin
	inherited create(father);
	self.external_cc := cc;
	local_cc := cl_colonna_colorata.create;local_cc.assign(external_cc);
	self.i_sezione_ZB := i_sezione_ZB;
	pt_bo_result := @bo_result;bo_result := FALSE
end;

procedure Tdlg_colonna_colorata_edit.FormCreate(Sender : TObject);
begin
	set_caption(self, MBOX_CAPTION);
	globale.table_colori_symbolici.load_items(cb_colore_base_symbolico.Items);
	cb_grad_colore_symbolico_min.Items.Assign(cb_colore_base_symbolico.Items);
	cb_grad_mix_colore_iniziale_symbolico.Items.Assign(cb_colore_base_symbolico.Items);
	cb_grad_mix_colore_finale_symbolico.Items.Assign(cb_colore_base_symbolico.Items);
	cb_grad_colore_symbolico_max.Items.Assign(cb_colore_base_symbolico.Items);
	cb_grad_colore_symbolico_extra_range.Items.Assign(cb_colore_base_symbolico.Items);
	for var i : smallint := 0 to MAX_COLORI_CONDIZIONALI-1 do begin
		var s := zeri(i, 2);
		str_condizione[i] := (FindComponent('str_condizione_' + s) as TFEdit);
		panel_colore[i] := (FindComponent('panel_colore_' + s) as TFPanel);
		cb_colore_symbolico[i] := (FindComponent('cb_colore_symbolico_' + s) as TFCombo);
		cb_colore_symbolico[i].Items.Assign(cb_colore_base_symbolico.Items)
	end;

	rb_tipo_limite.Items.Clear;
	for var tx : tipo_limite_colonna_colorata := low(tx) to high(tx) do rb_tipo_limite.Items.add(DESCRIZIONE_TIPO_LIMITE_COLONNE_COLORATE[tx]);

	load_objects(cb_object.Items, get_pagina_logica_attiva_ZB, [MAIN_SECTION_ZB..i_sezione_ZB{-1}], [LABEL_OBJ, OBJ_BITMAP, OBJ_RECT, OBJ_LINE, DATAMATRIX_OBJ]);
	load_objects(cb_linea_sx.Items, get_pagina_logica_attiva_ZB, [MAIN_SECTION_ZB..i_sezione_ZB-1], [OBJ_LINE, OBJ_RECT]);
	cb_linea_dx.Items.Assign(cb_linea_sx.Items);
//	load_objects(cb_grad_oggetto_riferimento.Items, get_pagina_logica_attiva_ZB, [i_sezione_ZB], [LABEL_OBJ], [VAL_NUMERO]);

	// tolgo le linguette, che non servono (utili solo in editing)
	page_colore_condizionale.TabVisible := FALSE;page_gradazione_colore.TabVisible := FALSE;

	write_data;
	{$ifdef DEBUG} check_components(self); {$endif DEBUG}
	bo_something_modified := FALSE;bo_started := TRUE
end;

destructor Tdlg_colonna_colorata_edit.free;
begin
	if (local_cc <> NIL) then local_cc.free
end;

procedure Tdlg_colonna_colorata_edit.FormCloseQuery(Sender : TObject;var CanClose : Boolean);
begin
	canclose := NOT bo_something_modified OR (MessageBBox(handle, 'Vuoi uscire senza salvare le modifiche?', MBOX_CAPTION, MB_QUESTION) =  IDYES)
end;

procedure Tdlg_colonna_colorata_edit.generic_enable_ctrls(Sender : TObject); begin enable_ctrls end;
procedure Tdlg_colonna_colorata_edit.AL_annullaExecute(Sender : TObject); begin close end;
procedure Tdlg_colonna_colorata_edit.AL_clearExecute(Sender : TObject); begin clear_execute end;
procedure Tdlg_colonna_colorata_edit.AL_helpExecute(Sender : TObject); begin MessageBBox(handle, HELP_COLONNE_COLORATE, MBOX_CAPTION) end;	// www.feaci.it/jolly/galateo/colonne-colorate.htm
procedure Tdlg_colonna_colorata_edit.AL_righe_alternateExecute(Sender : TObject); begin righe_alterne end;
procedure Tdlg_colonna_colorata_edit.AAA_notify_modification(Sender : TObject); begin bo_something_modified := TRUE end;

procedure Tdlg_colonna_colorata_edit.panel_colore_Click(Sender : TObject);
var panel : TFPanel absolute sender;
begin
	var col : TColor := panel.Color;
	if NOT select_colore(self, col) then exit;
	panel.Color := col;
	if (panel.Tag = -1) then begin
		if (panel = panel_colore_base) then begin
			cb_colore_base_symbolico.ItemIndex := -1;
			panel_grad_colore_min.Color := col;cb_grad_colore_symbolico_min.ItemIndex := -1
		end;
		if (panel = panel_grad_colore_min) then begin
			cb_grad_colore_symbolico_min.ItemIndex := -1;
			panel_colore_base.Color := col;cb_colore_base_symbolico.ItemIndex := -1
		end;
		if (panel = panel_grad_mix_colore_iniziale) then cb_grad_mix_colore_iniziale_symbolico.ItemIndex := -1;
		if (panel = panel_grad_mix_colore_finale) then cb_grad_mix_colore_finale_symbolico.ItemIndex := -1;
		if (panel = panel_grad_colore_max) then cb_grad_colore_symbolico_max.ItemIndex := -1;
		if (panel = panel_grad_colore_extra_range) then cb_grad_colore_symbolico_extra_range.ItemIndex := -1
	end
	else cb_colore_symbolico[panel.Tag].ItemIndex := -1;
	bo_something_modified := TRUE;enable_ctrls
end;

procedure Tdlg_colonna_colorata_edit.pboxPaint(Sender : TObject);
begin
	gradiente_orizzontale(pbox.Canvas, rect(0, 0, pbox.Width, pbox.Height), panel_grad_mix_colore_iniziale.Color, panel_grad_mix_colore_finale.Color)
end;

procedure Tdlg_colonna_colorata_edit.cb_colore_symbolico_Click(Sender : TObject);
var cb : TFCombo absolute Sender;
begin
	var panel : TFPanel := NIL;	// assegnato a NIL solo per il compilatore
	var s := cb.Text;if (s = '') then exit;
	var i_index : smallint := globale.table_colori_symbolici.get_index(s);
	if (i_index = -1) then exit;
	if (cb.Tag = -1) then begin
		if (cb = cb_colore_base_symbolico) then panel := panel_colore_base;
		if (cb = cb_grad_colore_symbolico_min) then panel := panel_grad_colore_min;
		if (cb = cb_grad_mix_colore_iniziale_symbolico) then panel := panel_grad_mix_colore_iniziale;
		if (cb = cb_grad_mix_colore_finale_symbolico) then panel := panel_grad_mix_colore_finale;
		if (cb = cb_grad_colore_symbolico_max) then panel := panel_grad_colore_max;
		if (cb = cb_grad_colore_symbolico_extra_range) then panel := panel_grad_colore_extra_range
	end
	else panel := panel_colore[cb.Tag];
	{$ifdef DEBUG} assert(panel <> NIL, 'Tdlg_colonna_colorata_edit.cb_colore_symbolico_Click() -- (PANEL == NIL)'); {$endif}
	if (panel <> NIL) then begin	// sempre !!!
		panel.Color := globale.table_colori_symbolici.get_colore(i_index).lo_colore;
		if (panel = panel_colore_base) then begin panel_grad_colore_min.Color := panel.Color;cb_grad_colore_symbolico_min.ItemIndex := cb.ItemIndex end;
		if (panel = panel_grad_colore_min) then begin panel_colore_base.Color := panel.Color;cb_colore_base_symbolico.ItemIndex := cb.ItemIndex end
	end;
	enable_ctrls
end;

function Tdlg_colonna_colorata_edit.read_data : boolean;
var s : string;	//*
begin
	result := FALSE;
	var cc := cl_colonna_colorata.create;
	var err_msg := validation_create('Colonna colorata');
	try
		cc.str_descrizione := str_descrizione.Text;
		if (cc.str_descrizione = '') then validation_add(err_msg, 'Descrizione non indicata', TRUE);
		cc.colore_base.lo_colore := cc.codifica_colore(panel_colore_base.Color);
		cc.colore_base.str_colore_symbolico := cb_colore_base_symbolico.Text;
		cc.tipo_limite := tipo_limite_colonna_colorata(rb_tipo_limite.ItemIndex);

		cc.bo_disabled := cbx_disabled.Checked;
		cc.str_condizione_abilitazione := str_condizione_abilitazione.Text;
		var bo_result : boolean;
		if NOT cc.bo_disabled AND (cc.str_condizione_abilitazione <> '') AND
			NOT interpreta_boolean_expression(cc.str_condizione_abilitazione, {test}TRUE, bo_result, s)
				then validation_add(err_msg, 'condizioni di abilitazione :: ' + s, TRUE);

		// leggo comunque tutti i campi di tutti i tipi colore, ma controllo solamente quelli del TIPO_COLORE selezionato
		if cbx_gradazione_colore.Checked then cc.tipo_colore := TCCC_GRADAZIONE else
		if cbx_colori_condizionali.Checked then cc.tipo_colore := TCCC_CONDIZIONE else
		cc.tipo_colore := TCCC_BLANK;

		case cc.tipo_limite of
			TLC_FULL_WIDTH, TLC_SECTION_WIDTH : ;
			TLC_ASSEGNATO : begin
				cc.fl_margine_sx_cm := str_limite_sx.get_AsFloat(TRUE);
				cc.fl_margine_dx_cm := str_limite_dx.get_AsFloat(TRUE);
				if NOT cc.bo_disabled then begin
					if (cc.fl_margine_sx_cm < 0) then validation_add(err_msg, 'Limite SX non valido', TRUE);
					if (cc.fl_margine_dx_cm > get_PHpage_size_X_cm_1B) then validation_add(err_msg, 'Limite SX non valido', TRUE);
					if (cc.fl_margine_dx_cm <= cc.fl_margine_sx_cm) then validation_add(err_msg, 'Limiti SX e DX non compatibili', TRUE)
				end
			end;
			TLC_FORMULE : begin
				cc.str_formula_margine_sx_CM := str_limite_sx.Text;cc.str_formula_margine_dx_CM := str_limite_dx.Text;
				if NOT cc.bo_disabled then begin
					var sz : cl_sezione := sections_ZB(i_sezione_ZB);
					if NOT sz.validate_formula_editing(handle, cc.str_formula_margine_sx_CM, 'formula margine SX', NIL, VAL_NUMERO, {allow_blank}FALSE) then exit;
					if NOT sz.validate_formula_editing(handle, cc.str_formula_margine_dx_CM, 'formula margine DX', NIL, VAL_NUMERO, {allow_blank}FALSE) then exit
				end
			end;
			TLC_OBJECT : begin
				cc.str_limite_object := cb_object.Text;
				if NOT cc.bo_disabled AND (cc.str_limite_object = '') then validation_add(err_msg, 'Specificare l''oggetto', TRUE)
			end;
			TLC_LINES : begin
				cc.str_left_line := cb_linea_sx.Text;cc.str_right_line := cb_linea_dx.Text;
				if NOT cc.bo_disabled then begin
					if (cc.str_left_line = '') OR (cc.str_right_line = '') then validation_add(err_msg, 'Specificare le LINEE di delimitazione', TRUE)
					else if (cc.str_left_line = cc.str_right_line) then validation_add(err_msg, 'Le LINEE di delimitazione devono essere DIFFERENTI', TRUE)
					else if (cc.get_margine_sx_CM > cc.get_margine_dx_CM) then validation_add(err_msg, 'La LINEA SX deve essere a sinistra della LINEA DX', TRUE)
				end
			end
		end;

		for var i : smallint := 0 to MAX_COLORI_CONDIZIONALI-1 do begin
			var str_caption := 'COLORE #' + (i+1).ToString + ' :: ';
			var col_cond : colore_condizionale_punt := @cc.colori_condizionali[i];
			col_cond.str_condizione := trim(str_condizione[i].Text);
			col_cond.colore.lo_colore := cc.codifica_colore(panel_colore[i].Color);
			col_cond.colore.str_colore_symbolico := cb_colore_symbolico[i].Text;
			if NOT cc.bo_disabled AND (cc.tipo_colore = TCCC_CONDIZIONE) then begin		// leggo sempre ma controllo solo se pertinente
				if NOT check_condizione_booleana(handle, col_cond.str_condizione, '', @s) then
					validation_add(err_msg, str_caption + 'errore di valutazione della condizione: ' + s, TRUE);
				if ((col_cond.colore.lo_colore <> 0) OR (col_cond.colore.str_colore_symbolico <> '')) AND (col_cond.str_condizione = '') then
					validation_add(err_msg, str_caption + 'condizione non definita', TRUE)
			end
		end;

		var grad : colore_gradazione_punt := @cc.gradazione;		// non è una classe, solo un object
		grad.str_formula_valore := str_grad_formula_valore.Text;
		grad.i_valore_min := i_grad_valore_min.get_Asinteger(TRUE);
		grad.colore_min.lo_colore := panel_grad_colore_min.Color;
		grad.colore_min.str_colore_symbolico := cb_grad_colore_symbolico_min.Text;

		grad.colore_mix_from.lo_colore := panel_grad_mix_colore_iniziale.Color;
		grad.colore_mix_from.str_colore_symbolico := cb_grad_mix_colore_iniziale_symbolico.Text;
		grad.colore_mix_to.lo_colore := panel_grad_mix_colore_finale.Color;
		grad.colore_mix_to.str_colore_symbolico := cb_grad_mix_colore_finale_symbolico.Text;

		grad.i_valore_max := i_grad_valore_max.get_Asinteger(TRUE);
		grad.colore_max.lo_colore := panel_grad_colore_max.Color;
		grad.colore_max.str_colore_symbolico := cb_grad_colore_symbolico_max.Text;

		grad.colore_extra_range.lo_colore := panel_grad_colore_extra_range.Color;
		grad.colore_extra_range.str_colore_symbolico := cb_grad_colore_symbolico_extra_range.Text;

		if NOT cc.bo_disabled AND (cc.tipo_colore = TCCC_GRADAZIONE) then begin
			try
				validation_start_riferimento(err_msg, 'GRADAZIONE DI COLORE');

(*				var x := name2obj(grad.str_oggetto_riferimento, [LABEL_OBJ], {all_pages}FALSE);
				if (x = NIL) then validation_add(err_msg, 'Oggetto di riferimento non riconosciuto o non valido', TRUE)
				else if (x.aslabel.ca.tipo_valore <> VAL_NUMERO) then validation_add(err_msg, 'L'' oggetto di riferimento deve essere una variabile NUMERICA', TRUE); *)

				var tipo : risultato_type := VAL_NUMERO;
				if NOT translate_formula(grad.str_formula_valore, s, {test}TRUE, tipo, NIL)
					then validation_add(err_msg, 'Errore durante la validazione della formula', TRUE);

				if (grad.i_valore_min >= grad.i_valore_max) then validation_add(err_msg, 'Il valore MINIMO deve essere inferiore al valore MASSIMO', TRUE);

				if (grad.colore_mix_from.lo_colore = grad.colore_mix_to.lo_colore) then
					validation_add(err_msg, 'Non vi è differenza tra i colori della banda intermedia', FALSE);

				grad.colore_min.check_not_blank(err_msg, 'valore minimo');
				grad.colore_max.check_not_blank(err_msg, 'valore massimo');
				grad.colore_mix_from.check_not_blank(err_msg, 'banda intermedia - valore iniziale');
				grad.colore_mix_to.check_not_blank(err_msg, 'banda intermedia - valore finale')
			finally
				validation_stop_riferimento(err_msg)
			end
		end;

		result := validation_verify(err_msg, self, 'Colonna colorata');
		if result then local_cc.assign(cc)
	finally
		if (cc <> NIL) then cc.free;
		validation_free(err_msg)
	end
end;

procedure Tdlg_colonna_colorata_edit.write_data;
begin
	enable_ctrls;		// setta i tipi di EDIT-CONTROLS
	str_descrizione.Text := local_cc.str_descrizione;
	panel_colore_base.Color := local_cc.decodifica_colore(local_cc.colore_base.lo_colore);
	cb_select(cb_colore_base_symbolico, local_cc.colore_base.str_colore_symbolico);
	rb_tipo_limite.ItemIndex := byte(local_cc.tipo_limite);

	cbx_disabled.Checked	:= local_cc.bo_disabled;
	str_condizione_abilitazione.Text := local_cc.str_condizione_abilitazione;

	cbx_gradazione_colore.Checked := (local_cc.tipo_colore = TCCC_GRADAZIONE);
	cbx_colori_condizionali.Checked := (local_cc.tipo_colore = TCCC_CONDIZIONE);

	case local_cc.tipo_limite of
		TLC_FULL_WIDTH, TLC_SECTION_WIDTH : ;
		TLC_ASSEGNATO : begin
			str_limite_sx.set_AsFloat(local_cc.fl_margine_sx_cm);
			str_limite_dx.set_AsFloat(local_cc.fl_margine_dx_cm)
		end;
		TLC_FORMULE : begin
			str_limite_sx.Text := local_cc.str_formula_margine_sx_CM;
			str_limite_dx.Text := local_cc.str_formula_margine_dx_CM
		end;
		TLC_OBJECT : cb_select(cb_object, local_cc.str_limite_object);
		TLC_LINES : begin cb_select(cb_linea_sx, local_cc.str_left_line);cb_select(cb_linea_dx, local_cc.str_right_line) end
	end;

	for var i : smallint := 0 to MAX_COLORI_CONDIZIONALI-1 do begin
		var col_cond : colore_condizionale_type := local_cc.colori_condizionali[i];
		str_condizione[i].Text := col_cond.str_condizione;
		panel_colore[i].Color := local_cc.decodifica_colore(col_cond.colore.lo_colore);
		cb_select(cb_colore_symbolico[i], col_cond.colore.str_colore_symbolico)
	end;

//	cb_select(cb_grad_oggetto_riferimento, local_cc.gradazione.str_oggetto_riferimento);
	str_grad_formula_valore.Text := local_cc.gradazione.str_formula_valore;
	i_grad_valore_min.set_Asinteger(local_cc.gradazione.i_valore_min);
	panel_grad_colore_min.Color := local_cc.gradazione.colore_min.lo_colore;
	panel_grad_min_sample.Color := local_cc.gradazione.colore_min.lo_colore;
	cb_select(cb_grad_colore_symbolico_min, local_cc.gradazione.colore_min.str_colore_symbolico);

	panel_grad_mix_colore_iniziale.Color := local_cc.gradazione.colore_mix_from.lo_colore;
	cb_select(cb_grad_mix_colore_iniziale_symbolico, local_cc.gradazione.colore_mix_from.str_colore_symbolico);
	panel_grad_mix_colore_finale.Color := local_cc.gradazione.colore_mix_to.lo_colore;
	panel_grad_max_sample.Color := local_cc.gradazione.colore_mix_to.lo_colore;
	cb_select(cb_grad_mix_colore_finale_symbolico, local_cc.gradazione.colore_mix_to.str_colore_symbolico);

	i_grad_valore_max.set_Asinteger(local_cc.gradazione.i_valore_max);
	panel_grad_colore_max.Color := local_cc.gradazione.colore_max.lo_colore;
	cb_select(cb_grad_colore_symbolico_max, local_cc.gradazione.colore_max.str_colore_symbolico);

	panel_grad_colore_extra_range.Color := local_cc.gradazione.colore_extra_range.lo_colore;
	cb_select(cb_grad_colore_symbolico_extra_range, local_cc.gradazione.colore_extra_range.str_colore_symbolico);

	enable_ctrls
end;

procedure Tdlg_colonna_colorata_edit.AL_saveExecute(Sender : TObject);
begin
	if bo_something_modified then begin
		if NOT read_data then exit;
		external_cc.assign(local_cc);
		bo_something_modified := FALSE;pt_bo_result^ := TRUE
	end;
	close
end;

procedure Tdlg_colonna_colorata_edit.btn_blank_Click(Sender : TObject);
begin
	var i : smallint := (sender as TFBitBtn).Tag;
	str_condizione[i].Text := '';panel_colore[i].Color := local_cc.decodifica_colore(0);cb_colore_symbolico[i].ItemIndex := -1;
	bo_something_modified := TRUE
end;

procedure Tdlg_colonna_colorata_edit.cbx_colori_Click(Sender : TObject);
var cbx : TFCheckBox absolute Sender;
begin
	if NOT bo_started then exit;
	bo_something_modified := TRUE;
	if cbx.checked then begin
		if (cbx <> cbx_colori_condizionali) AND cbx_colori_condizionali.Checked then cbx_colori_condizionali.Checked := FALSE;
		if (cbx <> cbx_gradazione_colore) AND cbx_gradazione_colore.Checked then cbx_gradazione_colore.Checked := FALSE
	end;
	enable_ctrls
end;

procedure Tdlg_colonna_colorata_edit.enable_ctrls;
begin
	var bo_enabled := NOT cbx_disabled.Checked;
	enable_fc(txt_condizione_abilitazione, bo_enabled);
	txt_colore_base.Enabled := bo_enabled;cb_colore_base_symbolico.Enabled := bo_enabled;panel_colore_base.Enabled := bo_enabled;
	rb_tipo_limite.Enabled := bo_enabled;
	cbx_colori_condizionali.Enabled := bo_enabled;cbx_gradazione_colore.Enabled := bo_enabled;

	var tx := tipo_limite_colonna_colorata(rb_tipo_limite.ItemIndex);
	var bo := (tx in [TLC_ASSEGNATO, TLC_FORMULE]) AND bo_enabled;
	enable_FC(txt_limite_sx, bo);enable_FC(txt_limite_dx, bo);
	if bo then begin
		var tipodato : EDIT_FORMATI_TYPE;
		if (tx = TLC_ASSEGNATO) then tipodato := fe_float else tipodato := fe_generico;
		str_limite_sx.AAA_tipodato := tipodato;
		str_limite_dx.AAA_tipodato := tipodato;
		bo := (tx = TLC_ASSEGNATO) AND bo_enabled;
		str_limite_sx.NumbersOnly := bo;str_limite_dx.NumbersOnly := bo
	end;
	enable_FC(txt_object, bo_enabled AND (tx = TLC_OBJECT));
	bo := bo_enabled AND (tx = TLC_LINES);
	enable_FC(txt_linea_sx, bo);enable_FC(txt_linea_dx, bo);

	make_all_children_enabled(pc_colori, bo_enabled);
	if cbx_colori_condizionali.Checked then pc_colori.ActivePage := page_colore_condizionale else page_colore_condizionale.Visible := FALSE;
	if cbx_gradazione_colore.Checked then pc_colori.ActivePage := page_gradazione_colore else page_gradazione_colore.Visible := FALSE;

	panel_grad_min_sample.Color := panel_grad_colore_min.Color;
	panel_grad_max_sample.Color := panel_grad_colore_max.Color;
	panel_grad_mix_sample.Invalidate		// faccio ridisegnare il gradiente
end;

procedure Tdlg_colonna_colorata_edit.righe_alterne;
begin
	clear_execute;
	str_descrizione.Text := 'righe alterne';
	panel_colore_base.Color := COLORE_RIGHE_ALTERNE;
	rb_tipo_limite.ItemIndex := byte(TLC_SECTION_WIDTH);
//	str_condizione_abilitazione.Text := FUNC[NDXF_DISPARI].str_name + '()=' + SQL_TRUE;
	str_condizione_abilitazione.Text := 'dispari() = "' + SQL_TRUE + '"';
	enable_ctrls
end;

procedure Tdlg_colonna_colorata_edit.clear_execute;
begin
	local_cc.clear;write_data;
	bo_something_modified := TRUE
end;

end.
