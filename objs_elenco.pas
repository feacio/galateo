unit objs_elenco;		//*

{$I defines}

{$ifdef DLL} non trovo questa posizione particolarmente adatta {$endif}

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons,
	Gdich, objects;

procedure elenco_objs_proc(father : TForm;i_sezione : smallint);
// passare I_SEZIONE = 0 per 'tutte le sezioni'

type
  Tdlg_elenco_objs = class(TForm)
    panel_bottoni: TPanel;
	 lista: TListView;
	 cbx_nascosti: TCheckBox;
	 btn_cancel: TBitBtn;
	 btn_ok: TBitBtn;
    btn_elimina: TBitBtn;
    cbx_sorted_sequenza: TCheckBox;
    btn_up: TBitBtn;
    btn_down: TBitBtn;
    txt_sequenza: TLabel;
    cbx_validazione: TCheckBox;
	 procedure FormCreate(Sender : TObject);
    procedure cbx_Click(Sender : TObject);
	 procedure FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
	 procedure listaColumnClick(Sender: TObject; Column: TListColumn);
	 procedure btn_okClick(Sender : TObject);
	 procedure listaDblClick(Sender : TObject);
	 procedure btn_cancelClick(Sender : TObject);
	 procedure btn_eliminaClick(Sender : TObject);
	 procedure btn_upClick(Sender : TObject);
	 procedure btn_downClick(Sender : TObject);
	 procedure listaDragDrop(Sender, Source: TObject; X, Y: Integer);
	 procedure listaDragOver(Sender, Source: TObject; X, Y: Integer;State: TDragState; var Accept: Boolean);
	 procedure FormClose(Sender : TObject;var Action : TCloseAction);
	 procedure listaChange(Sender: TObject; Item: TListItem;Change: TItemChange);
  private
		bo_can_open : boolean;
		i_sezione : smallint;
		i_logical_page : logical_page_type;
		function get_selected_obj : objs_type;
		function build_lista : boolean;
		procedure modify_object;
		procedure move_obj(i_ndx_from, i_ndx_to: smallint);
		procedure rebuild_lista(i_selected_ndx : smallint);
		constructor xcreate(father : TForm;i_sezione : smallint);
  end;

implementation

{$R *.DFM}

uses FAssert, FXStrings, FStrings, FSystem_base, FSystem, FProcs, FTrans, FMessage, galateo_debug, pages;

const
	SUBITEM_OBJ_INDEX = 0;	// subitems utilizzato per l'indice dell'oggetto
	REGISTRY_ARGOMENTO = 'objs_elenco';

procedure elenco_objs_proc(father : TForm;i_sezione : smallint);
var dlg: Tdlg_elenco_objs;
begin
	try
		set_wait_cursor(TRUE);
		dlg := Tdlg_elenco_objs.xcreate(father, i_sezione)
	finally
		set_wait_cursor(FALSE)
	end;
	dlg.ShowModal;dlg.Free
end;

constructor Tdlg_elenco_objs.xcreate(father : TForm;i_sezione : smallint);
begin
	self.i_sezione := i_sezione;
	self.i_logical_page := get_pagina_logica_attiva_1B;
	inherited create(father);
	if NOT bo_can_open then abort
end;

function Tdlg_elenco_objs.build_lista : boolean;
// rigenera la lista degli oggetti; rende TRUE in caso di successo
var
	it : TListItem;
	xobj : objs_type;
	bo_hidden : boolean;
	s : string;
begin
	try
//		lista.Items.BeginUpdate;
		try
			lista.Items.clear;	// a scanZo di equivoci
			if cbx_sorted_sequenza.Checked then lista.sorttype := stNone else lista.sorttype := stBoth;
			for var i : obj_index_type := 1 to i_objs do begin
				xobj := xobjs(i, i_logical_page);
				if (i_sezione <> 0) AND (i_sezione <> xobj.ca.i_section_1B) then continue;
				bo_hidden := xobj.is_hidden(0);
				if NOT bo_hidden AND cbx_nascosti.Checked then continue;

				if cbx_validazione.Checked AND ((xobj.ca.tipo_oggetto <> LABEL_OBJ) OR NOT xobj.aslabel.validazione.bo_attivo) then continue;

				it := lista.Items.add;
				it.Caption := lowercase(xobj.get_name);
				it.subitems.add(inttostr(i));
{				case xobj.tipo_oggetto of
					xTESTO, xFORMULA, xOBJ_BITMAP, DATAMATRIX, OBJ_RECT, OBJ_LINE : s := TIPO_DESCRIZIONE[xobj.get_tipo];
					xVARIABILE : s := TV_DESCRIZIONE[xobj.aslabel.tipovar];
					else s := ''
				end;}
				case xobj.ca.tipo_oggetto of
					LABEL_OBJ : s := TV_DESCRIZIONE[xobj.tipo_variabile];
					OBJ_BITMAP, DATAMATRIX_OBJ, OBJ_RECT, OBJ_LINE : s := TIPO_OGGETTO_DESCRIZIONE[xobj.ca.tipo_oggetto];
					else s := ''
				end; 	
				it.subitems.add(lowercase(s));
				it.SubItems.add(YN(bo_hidden));
//				if (xobj.get_tipo in LABEL_OBJS) then it.subitems.add(xobj.aslabel.str_hints)
				it.subitems.add(xobj.get_hints)	
			end;
			txt_sequenza.Enabled := cbx_sorted_sequenza.Checked AND NOT cbx_nascosti.Checked;
			btn_down.Enabled := txt_sequenza.Enabled;btn_up.Enabled := txt_sequenza.Enabled;
			result := TRUE
		except
			result := TRUE
		end
	finally
//		lista.Items.EndUpdate
	end
end;

procedure Tdlg_elenco_objs.FormCreate(Sender : TObject);
var s : string;
begin
	try
		if (i_sezione = 0) then s := 'TUTTE LE SEZIONI' else s := sections_1B(i_sezione).str_nome;
		caption := MBOX_CAPTION + ' [' + s + ']';
		if NOT build_lista then abort;
		IO_form_size_and_pos(self, FALSE);
		bo_can_open := TRUE
	except
	end
end;

procedure Tdlg_elenco_objs.FormKeyDown(Sender: TObject;var Key: Word;Shift: TShiftState);
begin
	case key of
		VK_RETURN,VK_F2: modify_object;
		VK_F3 : btn_elimina.Click;
		VK_F4 : if (shift = []) then cbx_nascosti.Checked := NOT cbx_nascosti.Checked else exit;
		VK_F5 : cbx_sorted_sequenza.Checked := NOT cbx_sorted_sequenza.Checked;
		VK_F9,VK_F12,VK_ESCAPE : close;
		VK_F11 : cbx_validazione.Checked := NOT cbx_validazione.Checked;
		VK_UP: begin
			if NOT (ssCtrl in Shift) then exit;	// trattamento default del tasto
			if btn_up.Enabled then btn_up.click
		end;
		VK_DOWN: begin
			if NOT (ssCtrl in Shift) then exit;	// trattamento default del tasto
			if btn_down.Enabled then btn_down.Click
		end;
		else exit
	end;
	key := 0
end;

procedure Tdlg_elenco_objs.modify_object;
var xobj : objs_type;
begin
	xobj := get_selected_obj;
	if (lista.Items.Count = 0) OR (xobj = NIL) then begin beep(0);exit end;
	xobj.edit_object;
	build_lista;
	lista.selected := lista.FindCaption(0,xobj.get_name,FALSE,TRUE,FALSE)
end;

function CompareFunc(Item1, Item2: TListItem; ParamSort: Integer): Integer; stdcall;
var i,j,k : integer;
begin
	if (paramsort = SUBITEM_OBJ_INDEX) then begin
		IVal(item1.subitems[paramsort],i,k);
		IVal(item2.subitems[paramsort],j,k);
		result := piumeno(i > j)
	end
	else result := piumeno(item1.subitems[paramsort] > item2.subitems[paramsort])
end;

procedure Tdlg_elenco_objs.listaColumnClick(Sender: TObject;Column: TListColumn);
begin
	if (column.index = 0) then lista.CustomSort(NIL,0) else lista.CustomSort(@comparefunc, column.index-1);
	cbx_sorted_sequenza.Checked := (column.index-1 = SUBITEM_OBJ_INDEX)
end;

procedure Tdlg_elenco_objs.cbx_Click(Sender : TObject); begin build_lista end;
procedure Tdlg_elenco_objs.btn_okClick(Sender : TObject); begin modify_object end;
procedure Tdlg_elenco_objs.listaDblClick(Sender : TObject); begin modify_object end;
procedure Tdlg_elenco_objs.btn_cancelClick(Sender : TObject); begin close end;

procedure Tdlg_elenco_objs.btn_eliminaClick(Sender : TObject);
var xobj : objs_type;
begin
	xobj := get_selected_obj;
	if (xobj = NIL) then begin beep(0);exit end;
	if (MessageBBox(handle, 'Vuoi eliminare l''oggetto selezionato?', MBOX_CAPTION, MB_ICONQUESTION OR MB_YESNOCANCEL) <> IDYES) then exit;
//	delete_object(obj2index(xobj), TRUE, FALSE);
	delete_object(xobj.i_numero_obj, TRUE, FALSE);
	build_lista
end;

function Tdlg_elenco_objs.get_selected_obj : objs_type;
begin
	try
		if (lista.Items.Count = 0) OR (lista.selected = NIL) then result := NIL
		else result := name2obj(lista.selected.Caption, FALSE)
	except
		result := NIL
	end
end;

procedure Tdlg_elenco_objs.rebuild_lista(i_selected_ndx : smallint);
begin
	build_lista;
	with lista do begin
		selected := items[i_selected_ndx];
		selected.makevisible(FALSE);
		setfocus
	end
end;

procedure Tdlg_elenco_objs.btn_upClick(Sender : TObject);
var
	i_itemindex,i,j : integer;
	xobj : objs_type;
begin
	if (lista.selected = NIL) then i_itemindex := 0
	else i_itemindex := lista.selected.index;
	if (i_itemindex = 0) then begin beep(0);exit end;
	ival(lista.selected.subitems[SUBITEM_OBJ_INDEX],i,j);
	xobj := xobjs(i,i_logical_page);
	assign_obj(i,xobjs(i-1,i_logical_page));
	assign_obj(i-1,xobj);
	rebuild_lista(i_itemindex-1);
	set_global_modified
end;

procedure Tdlg_elenco_objs.btn_downClick(Sender : TObject);
var
	i_itemindex,i,j : integer;
	xobj : objs_type;
begin
	if (lista.selected = NIL) then i_itemindex := MAXINT
	else i_itemindex := lista.selected.index;
	if (i_itemindex >= lista.Items.Count-1) then begin beep(0);exit end;
	ival(lista.selected.subitems[SUBITEM_OBJ_INDEX],i,j);
	xobj := xobjs(i,i_logical_page);
	assign_obj(i,xobjs(i+1,i_logical_page));
	assign_obj(i+1,xobj);
	rebuild_lista(i_itemindex+1);
	set_global_modified
end;

procedure Tdlg_elenco_objs.listaDragOver(Sender, Source: TObject; X,Y: Integer; State: TDragState; var Accept: Boolean);
begin
	accept := btn_up.Enabled
end;

procedure Tdlg_elenco_objs.listaDragDrop(Sender, Source: TObject; X,Y: Integer);
var
	i : smallint;
	k : TListItem;
begin
	k := lista.GetItemAt(X,Y);
	if (k = NIL) then i := -1 else i := k.index;		// sul fondo >> -1
	if (i <> lista.selected.index) then move_obj(lista.selected.index,i)
end;

procedure Tdlg_elenco_objs.move_obj(i_ndx_from,i_ndx_to : smallint);
// passare I_TO = -1 per dire 'metti sul fondo'
var
	i,i_tox : smallint;
	x_from : objs_type;
begin
	if (i_ndx_to = -1) then i_ndx_to := lista.Items.Count-1;
	i_tox := i_ndx_to;

	i_ndx_from := strtoint(lista.Items[i_ndx_from].subitems[SUBITEM_OBJ_INDEX]);
	i_tox := strtoint(lista.Items[i_tox].subitems[SUBITEM_OBJ_INDEX]);

	x_from := xobjs(i_ndx_from,i_logical_page);	// tengo da parte l'oggetto da spostare
	if (i_tox > i_ndx_from) then begin
		for i := i_ndx_from to i_tox-1-1 do assign_obj(i, xobjs(i+1, i_logical_page));
		dec(i_tox);dec(i_ndx_to)
	end
	else for i := i_ndx_from downto i_tox+1 do assign_obj(i, xobjs(i-1, i_logical_page));
	assign_obj(i_tox,x_from);
	rebuild_lista(i_ndx_to);
//	rebuild_lista(i_tox-1);
	set_global_modified
end;

procedure Tdlg_elenco_objs.FormClose(Sender: TObject;var Action: TCloseAction);
begin
	IO_form_size_and_pos(self, TRUE)
end;

procedure Tdlg_elenco_objs.listaChange(Sender: TObject; Item: TListItem;Change: TItemChange);
var xobj : objs_type;
begin
	xobj := get_selected_obj;
	if (xobj = NIL) then exit;
	obj_select(xobj.i_numero_obj, TRUE)
end;

initialization
	galateo_initialization_debug('objs_elenco')
finalization
	galateo_finalization_debug('objs_elenco')
end.
