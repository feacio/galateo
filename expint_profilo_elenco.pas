unit expint_profilo_elenco;

{$I defines}
{$ifdef DLL} *** {$endif}

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons, ActnList, ExtCtrls, ComCtrls,
  Federico, FBitBtn, Gdich;

procedure expint_profilo_elenco_proc(father : TForm);

type
  Tdlg_expint_profilo_elenco = class(TForm)
    panel_footer: TFPanel;
    btn_ok: TFBitBtn;
    panel_expint_edit: TFPanel;
	 txt_expint_label: TLabel;
	 btn_expint_buttons_panel: TFPanel;
    btn_expint_new: TFBitBtn;
    btn_expint_delete: TFBitBtn;
    btn_expint_up: TFBitBtn;
    btn_expint_down: TFBitBtn;
	 btn_expint_help: TFBitBtn;
    btn_expint_modify: TFBitBtn;
    btn_imposta: TFBitBtn;
	 lv: TListView;
    txt_export_header_default: TLabel;
	 procedure FormCreate(Sender : TObject);
	 procedure btn_expint_newClick(Sender : TObject);
	 procedure btn_expint_modifyClick(Sender : TObject);
	 procedure btn_expint_deleteClick(Sender : TObject);
	 procedure btn_expint_upClick(Sender : TObject);
	 procedure btn_expint_downClick(Sender : TObject);
	 procedure btn_cancelClick(Sender : TObject);
	 procedure FormClose(Sender : TObject;var Action : TCloseAction);
	 procedure btn_okClick(Sender : TObject);
	 procedure btn_impostaClick(Sender : TObject);
	 procedure lvSelectItem(Sender : TObject;Item : TListItem;Selected : Boolean);
    procedure lvDblClick(Sender : TObject);
	private
//		i_checked_expint : smallint;
		bo_something_modified : boolean;
		procedure expint_edit(bo_new : boolean = FALSE);
		procedure expint_delete;
		procedure expint_move(bo_up : boolean);
		procedure write(i_select_index : smallint = -1);
		procedure enable_ctrls;
		procedure imposta;
//  public
		constructor xcreate(father : TForm);
  end;

implementation

{$R *.dfm}

uses Fcommons, FXStrings, FStrings, FSystem, FMessage, FCtrls,
	galateo_debug, Gun, pages, objects, labels, expint_base, expint_dialog, expint_profilo_edit;

const
	MBOX_CAPTION = 'Profili di exportazione';

procedure expint_profilo_elenco_proc(father : TForm);
var dlg : Tdlg_expint_profilo_elenco;
begin
	try
		set_wait_cursor(TRUE);
		dlg := Tdlg_expint_profilo_elenco.xcreate(father);
	finally
		set_wait_cursor(FALSE)
	end;
	dlg.ShowModal;dlg.Free
end;

constructor Tdlg_expint_profilo_elenco.xcreate(father: TForm);
begin
//	i_checked_expint := globale.i_default_expint_profile;
	inherited create(father)
end;

procedure Tdlg_expint_profilo_elenco.FormCreate(Sender : TObject);
begin
	inherited;
	caption := MBOX_CAPTION;
	write;
	{$ifdef DEBUG} check_components(self) {$endif DEBUG}
end;

procedure Tdlg_expint_profilo_elenco.FormClose(Sender: TObject;var Action: TCloseAction);
begin
	if bo_something_modified then begin
		set_global_modified;
//		globale.i_default_expint_profile := i_checked_expint
	end;
	close
end;

procedure Tdlg_expint_profilo_elenco.write(i_select_index : smallint);
begin
	load_export_profiles_proc(lv, i_select_index);
	enable_ctrls
end;

procedure Tdlg_expint_profilo_elenco.expint_move(bo_up : boolean);
var i_delta : smallint;
begin
	var i_ndx : smallint := lv.ItemIndex;
	if (i_ndx = -1) then exit;
	if bo_up then begin
		if (i_ndx = 0) then exit;
		i_delta := -1
	end
	else begin
		if (i_ndx = lv.Items.Count-1) then exit;
		i_delta := +1
	end;
	var tp : cl_expint_profilo := globale.expint_profiles[i_ndx];
	globale.expint_profiles[i_ndx] := globale.expint_profiles[i_ndx+i_delta];
	globale.expint_profiles[i_ndx+i_delta] := tp;

	for var i_page : logical_page_type := 1 to get_ultima_pagina_logica do begin
		for var i_obj : obj_index_type := 1 to i_objs(i_page) do begin
			if NOT (xobjs(i_obj, i_page).tipo_oggetto in EXPINT_OBJS) then continue;
			var lab : cl_label := xobjs(i_obj, i_page).aslabel;
			var tpo : cl_expint_object := lab.expint[i_ndx];
			lab.expint[i_ndx] := lab.expint[i_ndx + i_delta];
			lab.expint[i_ndx + i_delta] := tpo
		end
	end;

	bo_something_modified := TRUE;
	write(i_ndx + i_delta)
end;

procedure Tdlg_expint_profilo_elenco.expint_delete;
begin
	if (lv.Items.Count < 2) then begin		// nulla da cancellare!!!
		MessageBBox(handle, 'Impossibile eliminare l''ultimo profilo di exportazione', MBOX_CAPTION, MB_ICONSTOP);
		exit
	end;
	var i_ndx : smallint := lv.ItemIndex;
	if (i_ndx = -1) then exit;
	if (MessageBBox(handle,'Vuoi eliminare il profilo di exportazione selezionato?', MBOX_CAPTION, MB_QUESTION_DEF2) <> IDYES) then exit;

	globale.expint_profiles[i_ndx].free;
	if (i_ndx <> length(globale.expint_profiles)-1) then	// altrimenti fa casino per l'indice, anche se l'operazione è solo virtuale
		move(globale.expint_profiles[i_ndx+1], globale.expint_profiles[i_ndx], (length(globale.expint_profiles) - i_ndx - 1) * sizeof(pointer));
	setLength(globale.expint_profiles, length(globale.expint_profiles) - 1);

	for var i_page : logical_page_type := 1 to get_ultima_pagina_logica do begin
		for var i_obj : obj_index_type := 1 to i_objs(i_page) do begin
			if NOT (xobjs(i_obj, i_page).tipo_oggetto in EXPINT_OBJS) then continue;
			var lab : cl_label := xobjs(i_obj, i_page).aslabel;
			lab.expint[i_ndx].free;
			if (i_ndx <> length(lab.expint)-1) then	// altrimenti fa casino per l'indice, anche se l'operazione è solo virtuale
				move(lab.expint[i_ndx+1], lab.expint[i_ndx], (length(lab.expint) - i_ndx - 1) * sizeof(pointer));
			setLength(lab.expint, length(lab.expint) - 1)
		end
	end;

	if (i_ndx = length(globale.expint_profiles)) then dec(i_ndx);
	bo_something_modified := TRUE;
	write(i_ndx)
end;

procedure Tdlg_expint_profilo_elenco.expint_edit(bo_new : boolean = FALSE);

	procedure append_new_expint_profile(p : cl_expint_profilo);
	begin
		var i_ndx : expint_index_type := length(globale.expint_profiles);
		setLength(globale.expint_profiles, i_ndx+1);
		globale.expint_profiles[i_ndx] := p;

		for var i_page : logical_page_type := 1 to get_ultima_pagina_logica do begin
			for var i_obj : obj_index_type := 1 to i_objs(i_page) do begin
				var x : objs_type := xobjs(i_obj, i_page);
				if NOT (x.ca.tipo_oggetto in EXPINT_OBJS) then continue;
				setLength(x.aslabel.expint, i_ndx + 1);
				x.aslabel.expint[i_ndx] := cl_expint_object.create
			end
		end
	end;

var
	i_ndx : smallint;	//*
	t : cl_expint_profilo;
begin
	if bo_new then begin
		for i_ndx := 0 to get_ultima_pagina_logica-1 do begin
			if get_logical_page_ZB(i_ndx).bo_external then begin
				MessageBBox(handle, 'I reports che caricano pagine da files esterni [pagina ' + (i_ndx + 1).Tostring + ': ' +
					get_logical_page_ZB(i_ndx).get_descrizione(TRUE) + ']' + ACAPO +
					'non possono possedere profili di exportazione integrale multipli', MBOX_CAPTION);
				exit
			end
		end
	end;

	i_ndx := 0;
	if bo_new then t := cl_expint_profilo.create
	else begin
		i_ndx := lv.ItemIndex;
		if (i_ndx = -1) then exit;
		t := get_expint_profilo(i_ndx)
	end;

	if expint_profilo_edit_proc(self, t) then begin
		bo_something_modified := TRUE;
		if bo_new then begin append_new_expint_profile(t);i_ndx := high(globale.expint_profiles) end;
		write(i_ndx)
	end
	else if bo_new then t.free
end;

procedure Tdlg_expint_profilo_elenco.btn_okClick(Sender : TObject); begin close end;
procedure Tdlg_expint_profilo_elenco.btn_expint_newClick(Sender : TObject); begin expint_edit(TRUE) end;
procedure Tdlg_expint_profilo_elenco.btn_expint_modifyClick(Sender : TObject); begin expint_edit end;
procedure Tdlg_expint_profilo_elenco.btn_expint_deleteClick(Sender : TObject); begin expint_delete end;
procedure Tdlg_expint_profilo_elenco.btn_expint_upClick(Sender : TObject); begin expint_move(TRUE) end;
procedure Tdlg_expint_profilo_elenco.btn_expint_downClick(Sender : TObject); begin expint_move(FALSE) end;
procedure Tdlg_expint_profilo_elenco.btn_cancelClick(Sender : TObject); begin close end;
procedure Tdlg_expint_profilo_elenco.btn_impostaClick(Sender : TObject); begin imposta end;
procedure Tdlg_expint_profilo_elenco.lvSelectItem(Sender: TObject;Item: TListItem; Selected: Boolean); begin enable_ctrls end;
procedure Tdlg_expint_profilo_elenco.lvDblClick(Sender : TObject); begin imposta end;

procedure Tdlg_expint_profilo_elenco.imposta;
begin
{	i := lv.ItemIndex;if (i = -1) then exit;
	if (get_export_target(lv.ItemIndex) = xRTA_EXPORT_INTEGRALE) then ZB_exportazione_integrale_setup_proc(self, lv.Itemindex)
	else ** }
	if btn_imposta.Enabled then ZB_exportazione_integrale_proc(self, lv.Itemindex) else expint_edit
end;

procedure Tdlg_expint_profilo_elenco.enable_ctrls;
begin
	btn_imposta.Enabled := (lv.ItemIndex <> -1) AND get_export_target_integrale(lv.ItemIndex)
end;

initialization
	galateo_initialization_debug('expint_profilo_elenco')
finalization
	galateo_finalization_debug('expint_profilo_elenco')
end.
