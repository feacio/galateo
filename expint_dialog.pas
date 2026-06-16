unit expint_dialog;	//*

{$I defines}
{$ifdef DLL} *** {$endif}

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Math, Menus, ActnList,Dialogs, StdCtrls, ExtCtrls, Actions,
	Federico, FListBox, FBitBtn, Gdich, expint_base, Gun;

function ZB_exportazione_integrale_proc(father : TForm;i_profilo : expint_index_type;i_pagina_logica_ZB : logical_page_type = -1) : boolean;

type
	Tdlg_expint_setup = class;
	cl_struttura_sezione = class;
	cl_pannello = class
		father : cl_struttura_sezione;
		form : Tdlg_expint_setup;
		i_profilo : expint_index_type;
		i_pagina_logica_ZB : logical_page_type;
		i_sezione_ZB : section_index_type;
		i_selected_obj : section_index_type;		// 1-based
		panel : TFPanel;
		txt_caption : TMyLabel;
		lb : TMyListBox;
		bo_pannello_export : boolean;		// indica se si tratta del pannello che contiene gli oggetti da exportare oppure quella che contiene gli oggetti da NON exportare
		bo_numerato : boolean;		// TUTTI gli oggetti hanno posizione di exportazione
		constructor create(father : cl_struttura_sezione;bo_pannello_export : boolean);
		{$ifdef DEBUG} destructor free; {$endif}
		procedure enable_popup;
		procedure edit_oggetto;
		procedure load_lista(bo_rinumera : boolean = FALSE);
		procedure lb_Click(Sender : TObject);
		procedure lb_DblClick(Sender : TObject);
		procedure lb_DragOver(Sender, Source: TObject; X,Y: Integer; State: TDragState; var Accept: Boolean);
		procedure lb_DragDrop(Sender, Source: TObject; X,Y: Integer);
		procedure lb_Enter(Sender : TObject);
		procedure lb_Exit(Sender : TObject);
		procedure lb_MouseDown(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
	end;
	cl_struttura_sezione = class
		form : Tdlg_expint_setup;
		father : TFPanel;
		panel : TFPanel;		// pannello che contiene l'intera struttura
		header_panel : TFPanel;
		xtxt_caption : TMyLabel;
		cb_expint_mode : TFCombo;
		details : array[boolean] of cl_pannello;	// predicato: bo_export
		i_profilo : expint_index_type;
		i_pagina_logica_ZB : logical_page_type;
		i_sezione_ZB : section_index_type;
//		sezione : cl_sezione;
		exs : cl_expint_section;
		i_sezioni : section_index_type;	// numero tot di sezioni
		constructor ZB_create(father : TFPanel;i_sezione_ZB, i_sezioni : section_index_type);
		destructor free;
		procedure panel_Resize(Sender : TObject);
		procedure resize;
		procedure load_liste;
		procedure edit_sezione;
		procedure header_panel_OnClick(Sender : TObject);
		procedure rinumera_section;
		procedure clear_numerazione_section;
		procedure write_sezione;
		procedure cb_expint_mode_OnChange(Sender : TObject);
	end;

  Tdlg_expint_setup = class(TForm)
	 panel_base: TFPanel;
	 panel_bottom: TFPanel;
	 btn_close: TFBitBtn;
	 txt_header: TMyLabel;
	 popup_sezione: TPopupMenu;
	 itp_disable_section: TMenuItem;
	 itp_enable_section: TMenuItem;
	 N1: TMenuItem;
	 itp_setup_sezione: TMenuItem;
	 itp_sezione_rinumera: TMenuItem;
	 itp_delete_numerazione: TMenuItem;
	 N2: TMenuItem;
	 ACL: TActionList;
	 AL_rinumera: TAction;
	 AL_delete_numerazione: TAction;
	 btn_rinumera: TFBitBtn;
	 panel_filter: TFPanel;
	 cbx_testi: TFCheckBox;
	 cbx_parametri: TFCheckBox;
	 cbx_fields: TFCheckBox;
	 cbx_formule: TFCheckBox;
	 cbx_strings: TFCheckBox;
	 cbx_numbers: TFCheckBox;
	 cbx_local_SQL: TFCheckBox;
	 AL_resize_window: TAction;
	 btn_insert_blank: TFBitBtn;
	 AL_insert_blank: TAction;
	 AL_delete_blank: TAction;
	 btn_delete_blank: TFBitBtn;
	 btn_default_options: TFBitBtn;
	 itp_edit_object: TMenuItem;
    AL_edit_object: TAction;
	 procedure FormCreate(Sender : TObject);
	 procedure FormCloseQuery(Sender : TObject;var CanClose : Boolean);
	 procedure panel_baseResize(Sender : TObject);
	 procedure txt_headerClick(Sender : TObject);
	 procedure btn_closeClick(Sender : TObject);
	 procedure itp_setup_sezioneClick(Sender : TObject);
	 procedure FormActivate(Sender : TObject);
	 procedure AL_rinumeraExecute(Sender : TObject);
	 procedure AL_delete_numerazioneExecute(Sender : TObject);
	 procedure cbx_showClick(Sender : TObject);
	 procedure FormClose(Sender : TObject;var Action : TCloseAction);
	 procedure AL_resize_windowExecute(Sender : TObject);
	 procedure AL_insert_blankExecute(Sender : TObject);
	 procedure AL_delete_blankExecute(Sender : TObject);
	 procedure btn_default_optionsClick(Sender : TObject);
	 procedure AL_edit_objectExecute(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
  private
		i_profilo : expint_index_type;
		i_pagina_logica_ZB : logical_page_type;
		bo_created : boolean;
		i_sezioni : section_index_type;
		bo_sezioni_generate : boolean;
		xp : cl_logical_page_info;
		exp : cl_expint_page;
//		exs : expint_section_array;
		bo_something_modified : boolean;
		sez : array of cl_struttura_sezione;
		selected_panel : cl_pannello;
		constructor create(father : TForm;i_profilo : expint_index_type;i_pagina_logica_ZB : logical_page_type); reintroduce;
		procedure rebuild;
		procedure edit_pagina_logica;
//		function get_selected_pannello(sender : TObject) : cl_pannello;
		function get_selected_sezione(sender : TObject) : cl_struttura_sezione;
		procedure window_size(bo_read : boolean);
		procedure modify_blank_line(i_numero : smallint);
		procedure set_default_options;
		procedure genera_struttura_sezioni;
  end;

implementation

{$R *.dfm}

uses Fcommons, FAssert, FXStrings, FStrings, FMessage, FCtrls, FRegistry, FSystem_base,
	galateo_debug, objects, proc, pages, expint_exec, labels, sezione, sezione_edit, pagina_logica_edit, label_edit;

const
	MBOX_CAPTION = 'Setup exportazione integrale';
	DEFAULT_FLAGS : array[0..6] of boolean = (
		FALSE,	// testi
		TRUE, TRUE, TRUE, TRUE, TRUE, TRUE);
{	EXPINT_SEZIONE_HINT = 'Impostazione di exportazione integrale per la sezione' + ACAPO2 +
		'Valori ammessi:' + ACAPO +
		SEXP_DESCRIZIONE_YES + ': la sezione viene SEMPRE exportata' + ACAPO +
		SEXP_DESCRIZIONE_NOT + ': per default la sezione NON viene exportata, ma l''utente può modificare l''impostazione a runtime' + ACAPO +
		SEXP_DESCRIZIONE_IMPOSSIBLE + ': la sezione non viene MAI exportata' + ACAPO2 +
		'Le impostazioni di exportazione restano comunque disponibili anche se il valore assegnato è NON ESPORTA,' + ACAPO +
		'perchè tale assegnazione potrebbe essere modificata a runtime'; }
var
	bo_loaded, bo_maximized : boolean;
	rw : TRect;
	bo_flags : array[0..6] of boolean;
	{$ifdef DEBUG} i_pannello, i_struttura_sezione : integer; {$endif}

function ZB_exportazione_integrale_proc(father : TForm;i_profilo : expint_index_type;i_pagina_logica_ZB : logical_page_type = -1) : boolean;
begin
	if (i_pagina_logica_ZB = -1) then i_pagina_logica_ZB := get_pagina_logica_attiva_ZB;

	if get_logical_page_ZB(i_pagina_logica_ZB).bo_external then begin
		MessageBBox(father, 'Le pagine non residenti non possono essere oggetto di EXPORTAZIONE INTEGRALE', MBOX_CAPTION);
		result := FALSE;exit
	end;

	var dlg := Tdlg_expint_setup.Create(father, i_profilo, i_pagina_logica_ZB);
	dlg.ShowModal;dlg.Free;
	result := TRUE
end;

constructor Tdlg_expint_setup.create(father : TForm;i_profilo : expint_index_type;i_pagina_logica_ZB : logical_page_type);
begin
	self.i_pagina_logica_ZB := i_pagina_logica_ZB;
	self.i_profilo := i_profilo;
//	exp := globale.expint_profiles[i_profilo].expint_pages[i_pagina_logica];
	exp := get_expint_page_ZB(i_profilo, i_pagina_logica_ZB);
	inherited create(father)
end;

// -----------------------------------------------------------------------------

procedure Tdlg_expint_setup.FormCreate(Sender : TObject);
begin
	xp := get_logical_page_ZB(i_pagina_logica_ZB);
	caption := MBOX_CAPTION;
	i_sezioni := get_num_sections_page(i_pagina_logica_ZB + 1);

	genera_struttura_sezioni;
	txt_header.Caption := 'profilo ' + get_expint_profilo(i_profilo).str_codice + ' - ' + ifs(exp.str_sigla, '[' + exp.str_sigla + '] ') + xp.get_descrizione(TRUE);
	{$ifdef DEBUG} check_components(self) {$endif DEBUG}
end;

procedure Tdlg_expint_setup.FormActivate(Sender : TObject);
begin
	for var i : section_index_type := 0 to i_sezioni-1 do begin
		var lb : TMyListBox := sez[i].details[TRUE].lb;
		if lb.Enabled then lb.SetFocus
	end;
	window_size(TRUE);
	bo_created := TRUE;rebuild
end;

procedure Tdlg_expint_setup.FormClose(Sender : TObject;var Action : TCloseAction);
begin
	window_size(FALSE)
end;

procedure Tdlg_expint_setup.FormDestroy(Sender : TObject);
begin
	for var i : section_index_type := 0 to i_sezioni-1 do begin sez[i].free;sez[i] := NIL end
end;

procedure Tdlg_expint_setup.FormCloseQuery(Sender : TObject;var CanClose : Boolean);
begin
	canclose := NOT bo_something_modified OR (MessageBBox(handle, 'Vuoi uscire senza salvare le modifiche ?', MBOX_CAPTION, MB_QUESTION_DEF2) = IDYES)
end;

procedure Tdlg_expint_setup.genera_struttura_sezioni;
begin
	setLength(sez, i_sezioni);
	for var i : section_index_type := 0 to i_sezioni-1 do begin
		sez[i] := cl_struttura_sezione.ZB_create(panel_base, i, i_sezioni);
//		sez[i].load_liste
	end;
	bo_sezioni_generate := TRUE
end;

procedure Tdlg_expint_setup.panel_baseResize(Sender : TObject);
begin
	if NOT bo_sezioni_generate then exit;
	for var i : section_index_type := 0 to i_sezioni-1 do sez[i].resize
end;

procedure Tdlg_expint_setup.txt_headerClick(Sender : TObject); begin edit_pagina_logica end;

procedure Tdlg_expint_setup.edit_pagina_logica;
begin
	pagina_logica_edit_proc(self, FALSE, TRUE, i_profilo);
	rebuild
end;

procedure Tdlg_expint_setup.rebuild;
begin
	if NOT bo_created then exit;
//	panel_base.Visible := xp.bo_export_allowed;	// nascondo tutto
	for var i : section_index_type := 0 to i_sezioni-1 do sez[i].load_liste;
	if (selected_panel <> NIL) then selected_panel.enable_popup
end;

procedure Tdlg_expint_setup.btn_closeClick(Sender : TObject);
begin
	close
end;

// -----------------------------------------------------------------------------

constructor cl_struttura_sezione.ZB_create(father : TFPanel;i_sezione_ZB, i_sezioni : section_index_type);
begin
	{$ifdef DEBUG} inc(i_struttura_sezione); {$endif}
	self.father := father;
	self.i_sezione_ZB := i_sezione_ZB;self.i_sezioni := i_sezioni;

	form := get_form(father) as Tdlg_expint_setup;
	i_profilo := form.i_profilo;
	i_pagina_logica_ZB := form.i_pagina_logica_ZB;
	exs := get_expint_section_ZB(i_profilo, i_pagina_logica_ZB, i_sezione_ZB);

	panel := TFPanel.Create(form);panel.parent := father;
	{$ifdef DEBUG} panel.Name := 'panel_sezione_' + zeri(i_sezione_ZB, 2); {$endif}
	panel.Color := clYellow;
	panel.Font.Name := 'System';panel.Font.Size := 10;panel.Font.Style := [fsBold];

	header_panel := TFPanel.Create(form);header_panel.parent := panel;
	{$ifdef DEBUG} header_panel.Name := 'panel_sezione_header_' + zeri(i_sezione_ZB, 2); {$endif}
	header_panel.Color := clYellow;
	header_panel.Align := alTop;
	header_panel.Height := form.txt_header.Height + 5;
	header_panel.Font.Name := 'Arial';header_panel.font.Size := 14;header_panel.Font.Style := [fsBold];
//	header_panel.Caption := ifs(exs.str_sigla, '[' + exs.str_sigla + '] ') + {'[' + inttostr(self.i_sezione) + '] ' +} sections_ZB(i_sezione_ZB).str_nome;
	header_panel.Cursor := form.txt_header.Cursor;

	for var bo := FALSE to TRUE do details[bo] := cl_pannello.create(self, bo);
	panel.OnResize := panel_Resize;

	cb_expint_mode := TFCombo.Create(form);cb_expint_mode.Parent := header_panel;
	cb_expint_mode.Style := csDropDownList;
	cb_expint_mode.Width := 90;cb_expint_mode.Align := alLeft;
	cb_expint_mode.AAA_dropdownwidth := cb_expint_mode.Width * 2;
	cb_expint_mode.Font.Name := 'System';cb_expint_mode.Font.Size := 10;cb_expint_mode.Font.Style := [fsBold];
	load_section_export_types_items(cb_expint_mode.Items);
	cb_expint_mode.ItemIndex := byte(exs.expint_mode);
	cb_expint_mode.ShowHint := TRUE;
//	cb_expint_mode.Hint := xEXPINT_SEZIONE_HINT;
	cb_expint_mode.Hint :=
		'Impostazione di exportazione integrale per la sezione' + ACAPO2 +
		'Valori ammessi:' + ACAPO +
		uppercase(SEXP_DESCRIZIONE_YES) + ': la sezione viene SEMPRE exportata' + ACAPO +
		uppercase(SEXP_DESCRIZIONE_NOT) + ': per default la sezione NON viene exportata, ma l''utente può modificare l''impostazione a runtime' + ACAPO +
		uppercase(SEXP_DESCRIZIONE_IMPOSSIBLE) + ': la sezione non viene MAI exportata' + ACAPO2 +
		'Le impostazioni di exportazione restano comunque disponibili anche se il valore assegnato è NON ESPORTA,' + ACAPO +
		'perchè tale assegnazione potrebbe essere modificata a runtime';
	{$ifdef DEBUG} cb_expint_mode.AAA_NeedNotifyModification := FALSE; {$endif}

	write_sezione;		// prima di assegnare le procedure di gestione degli eventi
	header_panel.Onclick := header_panel_OnClick;
	cb_expint_mode.OnChange := cb_expint_mode_OnChange
end;

destructor cl_struttura_sezione.free;
begin
	for var bo := FALSE to TRUE do details[bo].free;
	{$ifdef DEBUG} dec(i_struttura_sezione) {$endif}
end;

procedure cl_struttura_sezione.load_liste;
begin
	panel.Visible := form.exp.bo_export_allowed;	// nascondo tutto
	for var bo := FALSE to TRUE do details[bo].load_lista
end;

procedure cl_struttura_sezione.cb_expint_mode_OnChange(Sender : TObject);
begin
	exs.expint_mode := section_expint_mode_type(cb_expint_mode.ItemIndex);
	set_global_modified;
	form.rebuild
end;

procedure cl_struttura_sezione.panel_Resize(Sender : TObject);
begin
	details[TRUE].panel.Height := panel.Height div 2
end;

procedure cl_struttura_sezione.resize;
begin
//	panel.Top := 0;
	panel.Height := father.Height;
	panel.Width := father.Width div i_sezioni;
	panel.Left := panel.Width * (i_sezione_ZB)
end;

procedure cl_struttura_sezione.header_panel_OnClick(Sender : TObject); begin edit_sezione end;

procedure cl_struttura_sezione.edit_sezione;
begin
	edit_section_ZB(i_sezione_ZB, FALSE, TRUE, i_profilo);
	write_sezione;		// aggiorno i valori eventualmente modificato all'interno della EDIT_SECTION()
	form.rebuild
end;

procedure cl_struttura_sezione.write_sezione;
begin
	header_panel.Caption := ifs(exs.str_sigla, '[' + exs.str_sigla + '] ') +
		coalesce(exs.str_descrizione_runtime, '(' + sections_ZB(i_sezione_ZB).str_nome + ')') +
		ifs(sections_ZB(i_sezione_ZB, i_pagina_logica_ZB).SQL_blank, ' [nessun comando SQL]');
	header_panel.Hint := header_panel.Caption;header_panel.ShowHint := TRUE;
	cb_expint_mode.ItemIndex := byte(exs.expint_mode)
end;

// -----------------------------------------------------------------------------

constructor cl_pannello.create(father : cl_struttura_sezione;bo_pannello_export : boolean);
begin
	{$ifdef DEBUG} inc(i_pannello); {$endif}
	self.father := father;
	self.bo_pannello_export := bo_pannello_export;
	form := get_form(father.panel) as Tdlg_expint_setup;

	i_profilo := form.i_profilo;
	i_pagina_logica_ZB := form.i_pagina_logica_ZB;
	i_sezione_ZB := father.i_sezione_ZB;

	panel := TFPanel.create(form);panel.parent := father.panel;
	panel.Top := 0;
	if bo_pannello_export then panel.align := alTop else panel.align := alClient;
//	panel.OnResize := panel_Resize;
	{$ifdef DEBUG} var str_suffisso := '_' + zeri(i_sezione_ZB, 2) + '_' + ifs(bo_pannello_export, 'YES', 'NOT'); {$endif}

	txt_caption := TMyLabel.create(form);txt_caption.parent := panel;
	{$ifdef DEBUG} txt_caption.name := 'TXT' + str_suffisso; {$endif}
	txt_caption.align := alTop;
	txt_caption.Alignment := taCenter;
	txt_caption.Font.Name := 'Arial';txt_caption.font.Size := 12;txt_caption.Font.Style := [fsBold];
	txt_caption.Caption := 'campi ' + ifs(bo_pannello_export, 'exportati', 'non exportati');

	lb := TMyListBox.create(form);lb.parent := panel;
	{$ifdef DEBUG} lb.name := 'LB' + str_suffisso; {$endif}
	lb.align := alClient;lb.AAA_NeedNotifyModification := FALSE;
	lb.OnClick := lb_Click;lb.OnDblClick := lb_DblClick;
	lb.DragMode := dmAutomatic;lb.OnDragDrop := lb_DragDrop;lb.OnDragOver := lb_DragOver;
	lb.OnEnter := lb_Enter;lb.OnExit := lb_Exit;
	lb.OnMouseDown := lb_MouseDown;
	lb.PopupMenu := form.popup_sezione
end;

{$ifdef DEBUG}
	destructor cl_pannello.free;
	begin
		dec(i_pannello)
	end;
{$endif}

procedure cl_pannello.enable_popup;
begin
	var sez : cl_sezione := sections_ZB(i_sezione_ZB, i_pagina_logica_ZB);
	form.itp_sezione_rinumera.Enabled := bo_pannello_export;
	var bo := sez.exportabile_integrale(i_profilo, {runtime}FALSE);
	form.itp_enable_section.Checked := bo;form.itp_disable_section.Checked := NOT bo
end;

procedure cl_pannello.lb_Click(Sender : TObject);
begin
	i_selected_obj := 0;
	if (lb.ItemIndex = -1) then exit;
	var i : smallint := lb.ItemIndex;if (i = -1) then exit;
	i_selected_obj := lb.GetItemData(i);
	obj_select(i_selected_obj, TRUE);
	if bo_pannello_export then begin
		// mantengo allineata la selezione sulle varie listboxes delle diverse sezioni
		for i := 0 to father.i_sezioni-1 do begin
			var lx : TMyListBox := form.sez[i].details[bo_pannello_export].lb;
			if lx.Enabled AND (lx.Items.Count > lb.ItemIndex) then lx.ItemIndex := lb.ItemIndex
		end
	end;
	form.AL_insert_blank.Enabled := bo_pannello_export;
	form.AL_delete_blank.Enabled := bo_pannello_export
end;

procedure cl_pannello.edit_oggetto;
begin
	var i : smallint := lb.ItemIndex;if (i = -1) then exit;
	i := lb.GetItemData(i);if (i = 0) then exit;
	edit_label_proc(form, xobjs(i, i_pagina_logica_ZB + 1).aslabel, i, {modal}TRUE, {open_page_exportazione}TRUE, i_profilo);
	form.rebuild
end;

procedure cl_pannello.lb_DragOver(Sender, Source : TObject; X, Y : Integer;State : TDragState; var Accept : Boolean);
begin
	Accept := FALSE;
	var lb : TMyListBox := (source as TMyListBox);if (lb = NIL) then exit;
	x := lb.ItemIndex;if (x = -1) then exit;
	if (lb.GetItemData(x) = 0) then exit;	// non si tratta di un oggetto vero, è solo un blank

	accept :=
		(pointer(source) = pointer(father.details[NOT bo_pannello_export].lb)) OR	// sposta sulla lista EXPORT-YES / EXPORT-NOT
		((source = sender) AND bo_pannello_export)											// sposta di posizione; valido solo per la listbox di exportazione
end;

procedure cl_pannello.lb_DragDrop(Sender, Source : TObject; X, Y : Integer);
var p : TPoint;
begin
	if (source = father.details[NOT bo_pannello_export].lb) then begin	// sposta da EXPORT-YES a EXPORT-NOT o viceversa
		var lx : TMyListBox := father.details[NOT bo_pannello_export].lb;

		var i : smallint := lx.ItemIndex;if (i = -1) then exit;
		i := lx.GetItemData(i);if (i = 0) then exit;
//		sez := sections(father.i_sezione, form.i_pagina_logica);
		var lab : cl_label := xobjs(i, i_pagina_logica_ZB + 1).aslabel;
		var exo : cl_expint_object := lab.get_expint_object(i_profilo);
		if bo_pannello_export then exo.expint_mode := OEXP_YES else exo.expint_mode := OEXP_NOT;
		i_selected_obj := i;

		// sulla lista source seleziono l'item successivo
		i := lx.ItemIndex;
		if (i = lx.Items.Count-1) then dec(i) else inc(i);
		if (i <> -1) then father.details[NOT bo_pannello_export].i_selected_obj := lx.GetItemData(i)
	end
	else begin
		if NOT bo_pannello_export then begin
			{$ifdef DEBUG} assert(FALSE, 'non dovrebbe essere possibile -- JDHW 9941'); {$endif}
			exit
		end;
		if NOT self.bo_numerato then begin
			MessageBBox(form.Handle, 'Per spostare gli oggetti è necessario eseguire preventivamente la rinumerazione degli oggetti della sezione.', MBOX_CAPTION);
			exit
		end;
		if (lb.Itemindex = -1) then exit;	// non dovrebbe capitare ma ...
		// LAB : oggetto da spostare
		var i : smallint := lb.GetItemData(lb.Itemindex);if (i = 0) then exit;	// riga blank
		var lab : cl_label := xobjs(i, i_pagina_logica_ZB + 1).asLabel;
		var exo : cl_expint_object := lab.get_expint_object(i_profilo);

		p.X := x;p.Y := y;i := lb.ItemAtPos(p, FALSE);	// determino il target object
		if (i = lb.Itemindex) then exit;						// coincide con l'oggetto da spostare: nulla da fare

		if (i = lb.Items.Count) then exo.i_pos := high(exo.i_pos)
		else begin
			// se per caso mi trovo su righe blank, mi sposto sul primo oggetto vero
			while (i < lb.Items.Count) AND (lb.GetItemData(i) = 0) do inc(i);
			if (i = lb.Itemindex) then exit;						// coincide con l'oggetto source: nulla da fare

			i := lb.GetItemData(i);	// trovo l'indice dell'oggetto target
			if (i = 0) then exit;
//			lab.i_pos := xobjs(i, i_pagina_logica).aslabel.i_pos - 1
			exo.i_pos := xobjs(i, i_pagina_logica_ZB + 1).aslabel.get_expint_object(i_profilo).i_pos - 1
		end;
		father.rinumera_section
	end;

	set_global_modified;
	form.rebuild
end;	

procedure cl_pannello.lb_Enter(Sender : TObject);
begin
	if (form.selected_panel <> NIL) then form.selected_panel.lb.Color := clWindow;
	lb.Color := $00FAF5D1;
	form.selected_panel := self;
	enable_popup
end;

procedure cl_pannello.lb_Exit(Sender : TObject);
begin
//	lb.Color := clWindow
end;

procedure cl_pannello.lb_MouseDown(Sender : TObject; Button : TMouseButton;Shift : TShiftState; X, Y : Integer);
begin
	if NOT lb.Focused then lb.SetFocus
end;

procedure cl_pannello.lb_DblClick(Sender : TObject); begin edit_oggetto end;
procedure Tdlg_expint_setup.itp_setup_sezioneClick(Sender : TObject); begin get_selected_sezione(sender).edit_sezione end;
procedure Tdlg_expint_setup.AL_rinumeraExecute(Sender : TObject); begin get_selected_sezione(sender).rinumera_section end;
procedure Tdlg_expint_setup.AL_delete_numerazioneExecute(Sender : TObject); begin get_selected_sezione(sender).clear_numerazione_section end;
procedure Tdlg_expint_setup.cbx_showClick(Sender : TObject); begin rebuild end;
procedure Tdlg_expint_setup.AL_insert_blankExecute(Sender : TObject); begin modify_blank_line(+1) end;
procedure Tdlg_expint_setup.AL_delete_blankExecute(Sender : TObject); begin modify_blank_line(-1) end;
procedure Tdlg_expint_setup.btn_default_optionsClick(Sender : TObject); begin set_default_options end;
//function Tdlg_expint_setup.get_selected_pannello(sender : TObject): cl_pannello; begin result := selected_panel end;

procedure Tdlg_expint_setup.set_default_options;
begin
	cbx_testi.Checked := DEFAULT_FLAGS[0];
	cbx_parametri.Checked := DEFAULT_FLAGS[1];
	cbx_fields.Checked := DEFAULT_FLAGS[2];
	cbx_formule.Checked := DEFAULT_FLAGS[3];
	cbx_strings.Checked := DEFAULT_FLAGS[4];
	cbx_numbers.Checked := DEFAULT_FLAGS[5];
	cbx_local_SQL.Checked := DEFAULT_FLAGS[6];
	rebuild
end;

function Tdlg_expint_setup.get_selected_sezione(sender : TObject) : cl_struttura_sezione;
begin
//	p := get_selected_pannello(sender);
	var p : cl_pannello := selected_panel;
	if (p = NIL) then result := NIL else result := p.father
end;

procedure Tdlg_expint_setup.window_size(bo_read : boolean);
const
	NDX_SAVED = 0;
	NDX_RECT = 1;
	NDX_MAXIMIZED = 2;
	NDX_FLAGS_BASE = 30;
begin
	var r : TFRegistry := NIL;
	if (bo_read AND NOT bo_loaded) OR NOT bo_read then begin
		try
			r := TFRegistry.create(make_registry_key('expint_setup'{, 'GALATEO'}),
				{can_initialize_registry}NOT bo_read, {rootkey}HKEY_CURRENT_USER, {readonly}bo_read)
		except
			exit
		end
	end;

	if bo_read then begin
		var bo_ok := FALSE;
		if bo_loaded then bo_ok := TRUE
		else begin
			try
				bo_ok := r.read_boolean(NDX_SAVED, FALSE);
				if bo_ok then begin
					bo_maximized := r.read_boolean(NDX_MAXIMIZED, FALSE);
					r.IO_rect(TRUE, NDX_RECT, rw);
					for var i : smallint := 0 to sizeof(bo_flags)-1 do bo_flags[i] := r.read_boolean(NDX_FLAGS_BASE + i, DEFAULT_FLAGS[i])
				end
			except
			end;
			bo_loaded := TRUE
		end;
		if bo_ok then begin
			if bo_maximized then windowState := wsMaximized
			else SetBounds(rw.Left, rw.Top, rw.Right, rw.Bottom);

			cbx_testi.Checked := bo_flags[0];
			cbx_parametri.Checked := bo_flags[1];
			cbx_fields.Checked := bo_flags[2];
			cbx_formule.Checked := bo_flags[3];
			cbx_strings.Checked := bo_flags[4];
			cbx_numbers.Checked := bo_flags[5];
			cbx_local_SQL.Checked := bo_flags[6]
		end
	end
	else begin
		rw.Left := left;rw.Top := top;rw.Right := width;rw.Bottom := height;
		bo_maximized := (windowState = wsMaximized);
		r.write(NDX_MAXIMIZED, bo_maximized);
		r.IO_rect(FALSE, NDX_RECT, rw);
		bo_flags[0] := cbx_testi.Checked;
		bo_flags[1] := cbx_parametri.Checked;
		bo_flags[2] := cbx_fields.Checked;
		bo_flags[3] := cbx_formule.Checked;
		bo_flags[4] := cbx_strings.Checked;
		bo_flags[5] := cbx_numbers.Checked;
		bo_flags[6] := cbx_local_SQL.Checked;
		for var j : smallint := 0 to sizeof(bo_flags)-1 do r.write(NDX_FLAGS_BASE + j, bo_flags[j]);
		r.write(NDX_SAVED, TRUE)
	end;
	if (r <> NIL) then r.free
end;

procedure Tdlg_expint_setup.AL_resize_windowExecute(Sender : TObject);
begin
	if WindowState = wsNormal then WindowState := wsMaximized else WindowState := wsNormal
end;

procedure Tdlg_expint_setup.modify_blank_line(i_numero : smallint);
begin
	if (selected_panel = NIL) then exit;
	var lb : TMyListBox := selected_panel.lb;
	var i : smallint := lb.ItemIndex;if (i = -1) then exit;
	while (i < lb.Items.Count) AND (lb.GetItemData(i) = 0) do inc(i);
	selected_panel.i_selected_obj := lb.GetItemData(i);	// può essere differente se era selezionato una delle righe blank
//	var lab : cl_label := xobjs(lb.GetItemData(i), i_pagina_logica).aslabel;
	var exo : cl_expint_object := xobjs(lb.GetItemData(i), i_pagina_logica_ZB + 1).aslabel.get_expint_object(i_profilo);
	if (exo.i_skip_cols_before + i_numero < 0) then exit;
	exo.i_skip_cols_before := exo.i_skip_cols_before + i_numero;
	set_global_modified;
	rebuild
end;

procedure cl_struttura_sezione.rinumera_section;
begin
{	if (MessageBBox(form.handle, 'Vuoi rinumerare gli oggetti exportabili per la sezione ' + sections(i_sezione).str_nome + ' ?',
		MBOX_CAPTION, MB_QUESTION) <> IDYES) then exit; {}

	details[TRUE].load_lista(TRUE);
	set_global_modified;
	form.rebuild		// cautelativo, ma efficace
end;

procedure cl_struttura_sezione.clear_numerazione_section;
begin
	if (MessageBBox(form.handle, 'Vuoi ELIMINARE la numerazione degli oggetti exportabili per la sezione ' + sections_ZB(i_sezione_ZB).str_nome + ' ?',
		MBOX_CAPTION, MB_QUESTION_DEF2) <> IDYES) then exit;

	for var i : smallint := 1 to i_objs(i_pagina_logica_ZB + 1) do begin
		var x : objs_type := xobjs(i, i_pagina_logica_ZB + 1);
		if (x.ca.i_section_1B <> i_sezione_ZB + 1) then continue;
//		if NOT (x.tipo_oggetto in ALPHABETIC_OBJS) then continue;
		if NOT (x.ca.tipo_oggetto in EXPINT_OBJS) then continue;
		x.aslabel.get_expint_object(i_profilo).i_pos := 0
	end;
	form.rebuild
end;

procedure cl_pannello.load_lista(bo_rinumera : boolean = FALSE);
// if (bo_rinumera) esegue la rinumerazione degli oggetti exportabili
const
	PASSO = 10;			// passo di rinumerazione
//	SECTION_SKIP = '------------ sezione >>>';
	SECTION_SKIP = '>>>>>>>>>>>>>>>>';
//	OBJECT_SKIP = '------------ oggetto >>>';
	OBJECT_SKIP =  '----------------------';
var
	i, j : obj_index_type;
	lab : cl_label;
	s : string;
	xa : array of cl_label;
begin
	var intexp : cl_exec_expint_options := NIL;
	try
		{$ifdef DEBUG} assert(export_integrale = NIL, 'export_integrale -- JJDW 3401'); {$endif}
		intexp := cl_exec_expint_options.create;
		intexp.i_profilo := i_profilo;
		export_integrale := cl_exec_expint_main.create(intexp);		// riordino i dati per l'exportazione integrale

		var sec : cl_sezione := sections_ZB(i_sezione_ZB, i_pagina_logica_ZB);
		lb.Enabled := sec.exportabile_integrale(i_profilo, {runtime}FALSE);
//		var exs : cl_expint_section := get_expint_section_ZB(i_profilo, i_pagina_logica_ZB, i_sezione_ZB);
//		lb.Enabled := (exs.xexport_type <> OEXP_IMPOSSIBLE);

		// carico su XA i soli oggetti exportabili
		j := 0;
		for i := 1 to i_objs(i_pagina_logica_ZB + 1) do begin
			var x : objs_type := xobjs(i, i_pagina_logica_ZB + 1);
			if (x.ca.i_section_1B <> i_sezione_ZB + 1) then continue;
			if NOT (x.ca.tipo_oggetto in EXPINT_OBJS) then continue;
			lab := x.aslabel;
			if bo_rinumera then lab.get_expint_object(i_profilo).i_pos := 0;
			if (bo_pannello_export <>
				form.exp.bo_export_allowed AND lab.ZB_get_integral_exportable(i_profilo, i_pagina_logica_ZB))
					then continue;

			if NOT bo_pannello_export then begin
				case x.ca.tipo_variabile of
					TV_STATIC_TEXT : if NOT form.cbx_testi.Checked then continue;
					TV_FORMULA : if NOT form.cbx_formule.Checked then continue;
					TV_DB_FIELD : if NOT form.cbx_fields.Checked then continue;
					TV_PARAMETRO : if NOT form.cbx_parametri.Checked then continue;
					TV_GROUP_EXPR_SQL, TV_SQL_SELECT_BEFORE_SQL, TV_SQL_SELECT_BEFORE_RUNTIME, TV_SQL_SELECT : if NOT form.cbx_local_SQL.Checked then continue;
					{$ifdef DEBUG} else assert(FALSE, 'DJWH 9133') {$endif}
				end;

				if (x.ca.tipo_variabile <> TV_STATIC_TEXT) then begin
					case x.ca.tipo_valore of
						VAL_TESTO : if NOT form.cbx_strings.Checked then continue;
						VAL_NUMERO : if NOT form.cbx_numbers.Checked then continue;
						{$ifdef DEBUG} else assert(FALSE, 'DJWH 9134') {$endif}
					end
				end
			end;

			setLength(xa, j + 1);
			xa[j] := lab;inc(j)
		end;

		for i := 0 to high(xa)-1 do begin
			for j := i+1 to high(xa) do begin
				if (xa[i].get_expint_object(i_profilo).i_exec_pos > xa[j].get_expint_object(i_profilo).i_exec_pos) then begin
					lab := xa[i];xa[i] := xa[j];xa[j] := lab
				end
			end
		end;

		if bo_rinumera then begin
			var i_pos : smallint := 0;
			for i := 0 to high(xa) do begin
				inc(i_pos, PASSO);
				xa[i].get_expint_object(i_profilo).i_pos := i_pos
			end
		end;

		lb.Items.Clear;
		for j := 1 to sec.get_expint_section(i_profilo).i_shift_columns do lb.Items.Add(SECTION_SKIP);

		self.bo_numerato := TRUE;		// TUTTI gli oggetti hanno posizione di exportazione?
		for i := 0 to high(xa) do begin
			lab := xa[i];
			var exo : cl_expint_object := lab.get_expint_object(i_profilo);
			for j := 1 to exo.i_skip_cols_before do lb.Items.Add(OBJECT_SKIP);
			s := '';
			if (exo.i_pos = 0) then self.bo_numerato := FALSE else s := s + '[' + zeri(exo.i_pos, 3) + '] ';

			if (exo.str_header <> '') then s := s + exo.str_header + ' (' + lab.Caption + ')' else s := s + lab.Caption;
			lb.Items.add(s);
			lb.SetItemData(lb.Items.Count-1, lab.ca.i_numero_obj);
			if (lab.ca.i_numero_obj = i_selected_obj) then lb.Itemindex := lb.Items.Count-1
		end
	finally
		export_integrale.free;export_integrale := NIL;
		intexp.free
	end
end;

procedure Tdlg_expint_setup.AL_edit_objectExecute(Sender : TObject);
begin
	if (selected_panel = NIL) then exit;
	selected_panel.edit_oggetto
end;

initialization
	galateo_initialization_debug('expint_setup')
finalization
	galateo_finalization_debug('expint_setup');
{$ifdef DEBUG}
	CCI(i_struttura_sezione, 'cl_struttura_sezione', 'expint_setup.pas');
	CCI(i_pannello, 'cl_pannello', 'expint_setup.pas')
{$endif}
end.
