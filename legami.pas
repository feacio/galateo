unit legami; 	//* legàmi, e non lègami come qualche malizioso potrebbe pensare

{$ifdef DLL} *** {$endif}

{$I defines}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons,
	Fcommons, Gdich, objects, Federico, FBitBtn;

function legami_comunitari_proc(father : TForm;i_obj : obj_index_type) : boolean;

type
  Tdlg_legami = class(TForm)
	 gbox_base: TGroupBox;
	 txt_h: TLabel;
	 txt_v: TLabel;
	 txt_move: TLabel;
	 sb_h: TSpeedButton;
	 sb_pos: TSpeedButton;
	 txt_all: TLabel;
	 sb_all: TSpeedButton;
	 sb_v: TSpeedButton;
	 btn_ok: TFBitBtn;
	 btn_cancel: TFBitBtn;
	 cb_all: TFCombo;
	 cb_horz: TFCombo;
	 cb_vert: TFCombo;
	 cb_pos: TFCombo;
	 procedure sb_allClick(Sender : TObject);
	 procedure sb_hClick(Sender : TObject);
	 procedure sb_vClick(Sender : TObject);
	 procedure sb_posClick(Sender : TObject);
	 procedure cb_allChange(Sender : TObject);
	 procedure cb_hvpChange(Sender : TObject);
	 procedure FormCreate(Sender : TObject);
	 procedure btn_okClick(Sender : TObject);
	 procedure btn_cancelClick(Sender : TObject);
	 procedure FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
  private
		i_obj : obj_index_type;
		i_logical_page : logical_page_type;
		pt_bo_modified : boolean_punt;
		procedure load_objects(cb : TComboBox;bo_only_cornici : boolean;str2select : string);
		constructor xcreate(father : TForm;i_obj : obj_index_type;var bo_modified : boolean);
  end;

implementation

{$R *.DFM}

uses galateo_debug, FCtrls,pages;

const
	MBOX_CAPTION = 'Impostazione legami comunitari';

function legami_comunitari_proc(father : TForm;i_obj : obj_index_type) : boolean;
begin
	var dlg: Tdlg_legami := Tdlg_legami.xCreate(father, i_obj, result);
	dlg.ShowModal;dlg.Free
end;

constructor Tdlg_legami.xcreate(father : TForm;i_obj : obj_index_type;var bo_modified : boolean);
begin
	pt_bo_modified := @bo_modified;bo_modified := FALSE;
	self.i_obj := i_obj;
	self.i_logical_page := get_pagina_logica_attiva_1B;
	inherited create(father)
end;

procedure Tdlg_legami.FormCreate(Sender : TObject);
begin
	caption := 'Legami di ';
	if (xobjs(i_obj,i_logical_page).get_name = '') then caption := caption + 'SENZA NOME'
	else caption := caption + xobjs(i_obj,i_logical_page).get_name;
	caption := caption + ' con gli altri oggetti';
	if NOT (MR_RESIZE in MR_AVAILABLE[xobjs(i_obj,i_logical_page).ca.tipo_oggetto]) then begin
		sb_h.Enabled := FALSE;txt_h.Enabled := sb_h.Enabled;cb_horz.Enabled := sb_h.Enabled;
		sb_v.Enabled := FALSE;txt_v.Enabled := sb_v.Enabled;cb_vert.Enabled := sb_v.Enabled
	end;
	if NOT (MR_MOVE in MR_AVAILABLE[xobjs(i_obj).ca.tipo_oggetto]) then begin
		sb_pos.Enabled := FALSE;txt_move.Enabled := sb_pos.Enabled;cb_pos.Enabled := sb_pos.Enabled
	end;

	sb_all.down := FALSE;sb_h.down := FALSE;sb_v.down := FALSE;sb_pos.down := FALSE;
	load_objects(cb_all,sb_all.down,'');
	with xobjs(i_obj, i_logical_page).xref do begin
		load_objects(cb_horz, sb_h.down, str_horz);
		load_objects(cb_vert, sb_v.down, str_vert);
		load_objects(cb_pos, sb_pos.down, str_pos)
	end;
	{$ifdef DEBUG} check_components(self) {$endif DEBUG}
end;

procedure Tdlg_legami.sb_allClick(Sender : TObject);
begin
	load_objects(cb_all, sb_all.down, cb_all.Text);
	if NOT sb_all.down then begin
		sb_h.down := FALSE;load_objects(cb_horz, FALSE, cb_horz.Text);
		sb_v.down := FALSE;load_objects(cb_vert, FALSE, cb_vert.Text);
		sb_pos.down := FALSE;load_objects(cb_pos, FALSE, cb_pos.Text)
	end
end;

procedure Tdlg_legami.sb_hClick(Sender : TObject); begin load_objects(cb_horz, sb_h.down, cb_horz.Text) end;
procedure Tdlg_legami.sb_vClick(Sender : TObject); begin load_objects(cb_vert, sb_v.down, cb_vert.Text) end;
procedure Tdlg_legami.sb_posClick(Sender : TObject); begin load_objects(cb_pos, sb_pos.down, cb_pos.Text) end;

procedure Tdlg_legami.cb_allChange(Sender : TObject);
begin
	if (MR_RESIZE in MR_AVAILABLE[xobjs(i_obj, i_logical_page).ca.tipo_oggetto]) then begin
		cb_horz.ItemIndex := cb_horz.Items.indexof(cb_all.Text);
		cb_vert.ItemIndex := cb_vert.Items.indexof(cb_all.Text)
	end;
	if (MR_MOVE in MR_AVAILABLE[xobjs(i_obj, i_logical_page).ca.tipo_oggetto]) then cb_pos.ItemIndex := cb_pos.Items.indexof(cb_all.Text)
end;

procedure Tdlg_legami.cb_hvpChange(Sender : TObject); begin cb_all.ItemIndex := -1 end;

procedure Tdlg_legami.btn_okClick(Sender : TObject);
begin
	with xobjs(i_obj, i_logical_page).xref do begin
		str_horz := cb_horz.Text;
		str_vert := cb_vert.Text;
		str_pos := cb_pos.Text
	end;
	pt_bo_modified^ := TRUE;
//	globale.bo_modified := TRUE;
	close
end;

procedure Tdlg_legami.load_objects(cb : TComboBox;bo_only_cornici : boolean;str2select : string);
begin
	var i_section : smallint := xobjs(i_obj, i_logical_page).ca.i_section_1B;
	cb.Items.clear;
//	cb.Items.add('');
	for var i : obj_index_type := 1 to i_objs do begin
		if (i = i_obj) then continue;
		var x : objs_type := xobjs(i, i_logical_page);
		if bo_only_cornici AND NOT (x.ca.tipo_oggetto in CORNICI_OBJS) then continue;
		if (x.ca.tipo_oggetto in ALPHABETIC_OBJS) AND (x.ca.show = OSW_HIDE) then continue;
		if (x.get_name = '') then continue;
		if (x.ca.i_section_1B <> i_section) then continue;
		cb.Items.add(lowercase(x.get_name))
	end;
	cb.ItemIndex := cb.Items.indexof(str2select)
end;

procedure Tdlg_legami.btn_cancelClick(Sender : TObject); begin close end;
procedure Tdlg_legami.FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState); begin if key_button(key, VK_F9, btn_ok, TRUE) then exit end;

initialization
	galateo_initialization_debug('legami')
finalization
	galateo_finalization_debug('legami')
end.
