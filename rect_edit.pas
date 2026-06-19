unit rect_edit;		//*

{$ifdef DLL} *** {$endif}

{$I defines}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons, ComCtrls,
	Fcommons, Federico, FBitBtn, Gdich, objects, rects, Vcl.ExtCtrls;

procedure rect_edit_proc(father : TForm;i_obj : obj_index_type);

type
  Tdlg_rect_settings = class(TForm)
    gbox_base: TGroupBox;
    txt_thickness: TLabel;
    txt_nome: TLabel;
	 str_nome: TEdit;
	 i_thickness: TEdit;
    UpDown_thickness: TUpDown;
	 btn_ok: TFBitBtn;
	 btn_cancel: TFBitBtn;
	 txt_object: TLabel;
	 gbox_shift_pos: TFGroupBox;
	 txt_formula_Xpos: TLabel;
	 txt_formula_Ypos: TLabel;
	 str_formula_Xpos: TEdit;
	 cb_formula_Xpos: TComboBox;
	 str_formula_Ypos: TEdit;
	 cb_formula_Ypos: TComboBox;
	 panel_foreground: TFPanel;
	 panel_background: TFPanel;
	 btn_colori_automatici: TFBitBtn;
	 cbx_trasparente: TCheckBox;
    txt_height: TLabel;
    txt_width: TLabel;
    txt_top: TLabel;
    txt_left: TLabel;
    i_height: TEdit;
    i_width: TEdit;
    i_top: TEdit;
    i_left: TEdit;
	 txt_formula_DX: TLabel;
    str_formula_DX: TEdit;
    cb_formula_DX_type: TComboBox;
    txt_formula_DY: TLabel;
    str_formula_DY: TEdit;
    cb_formula_DY_type: TComboBox;
    txt_show: TLabel;
	 txt_print_if: TLabel;
	 str_print_if: TEdit;
    cb_show: TFCombo;
    sep: TBevel;
    cbx_footer: TCheckBox;
    cbx_posizione_fissa: TCheckBox;
    cbx_dimensione_verticale_fissa: TCheckBox;
    btn_legami: TButton;
    txt_formula_header: TMyLabel;
    txt_tipo_formula_header: TMyLabel;
    txt_round_corners: TLabel;
    i_round_corners: TEdit;
    updown_round_corners: TUpDown;
	 procedure btn_okClick(Sender : TObject);
	 procedure btn_cancelClick(Sender : TObject);
	 procedure FormCreate(Sender : TObject);
	 procedure btn_legamiClick(Sender : TObject);
	 procedure FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
	 procedure FormActivate(Sender : TObject);
	 procedure color_click(Sender : TObject);
	 procedure btn_colori_automaticiClick(Sender : TObject);
	 procedure AAA_something_modified(Sender : TObject);
    procedure FormClose(Sender : TObject;var Action : TCloseAction);
    procedure FormDestroy(Sender : TObject);
  private
		i_obj : obj_index_type;
		i_logical_page : logical_page_type;
		xobj : objs_type;
		rect : cl_rect;
		bo_something_modified : boolean;
//		old_show : show_types;
		constructor xcreate(father : TForm;i_logical_page : logical_page_type;i_obj : obj_index_type);
		procedure set_foreground_colors;
		procedure enable_ctrls;
  end;

implementation

uses FXStrings, FStrings, FSystem_base, FSystem, FMessage, FProcs, FCtrls,
	wproc, galateo_debug, pages, proc, legami, misure, objsx, sezione;

{$R *.DFM}

const
	MBOX_CAPTION = 'Impostazioni rettangolo';
	MAX_THICKNESS = 64;

procedure rect_edit_proc(father : TForm;i_obj : obj_index_type);
begin
	if NOT wx.can_open(WT_GRAPH_EDIT, father, i_obj.ToString) then exit;
	var dlg := Tdlg_rect_settings.xCreate(father, get_pagina_logica_attiva_1B, i_obj);
	wx.register_open_window(father, dlg, WT_GRAPH_EDIT, i_obj.ToString);
//	dlg.ShowModal;dlg.Free
	dlg.Show
end;

constructor Tdlg_rect_settings.xcreate(father : TForm;i_logical_page : logical_page_type;i_obj : obj_index_type);
begin
	self.i_obj := i_obj;
	self.i_logical_page := i_logical_page;
	xobj := xobjs(i_obj,i_logical_page);
	rect := xobj.asgraph;
	inherited create(father)
end;

procedure Tdlg_rect_settings.FormCreate(Sender : TObject);
begin
	load_shift_formula_items(cb_formula_Xpos.Items);
	cb_formula_Ypos.Items.Assign(cb_formula_Xpos.Items);
	cb_formula_DX_type.Items.Assign(cb_formula_Xpos.Items);
	cb_formula_DY_type.Items.Assign(cb_formula_Xpos.Items);

	txt_object.Caption := zeri(i_obj, 3);
//	i_thickness.Text := inttostr(rect.i_thickness,0);
	i_width.Text := strid(video2cm_x(xobj.get_width), 0, 2);
	i_height.Text := strid(video2cm_y(xobj.get_height), 0, 2);
	i_left.Text := strid(video2cm_x(xobj.get_left), 0, 2);
	i_top.Text := strid(video2cm_y(xobj.get_top), 0, 2);
	str_formula_Xpos.Text := rect.ca.str_formula_Xpos_cm;cb_formula_Xpos.ItemIndex := byte(rect.ca.tipo_formula_Xpos);
	str_formula_Ypos.Text := rect.ca.str_formula_Ypos_cm;cb_formula_Ypos.ItemIndex := byte(rect.ca.tipo_formula_Ypos);
	str_formula_DX.Text := rect.ca.str_formula_DX_cm;cb_formula_DX_type.ItemIndex := byte(rect.ca.tipo_formula_DX);
	str_formula_DY.Text := rect.ca.str_formula_DY_cm;cb_formula_DY_type.ItemIndex := byte(rect.ca.tipo_formula_DY);
	updown_thickness.Max := MAX_THICKNESS;
	updown_round_corners.Max := MAX_ROUND_FACTOR;
	str_nome.Text := xobj.get_name;
	str_nome.maxlength := 64;	// valore non particolarmente rilevante
	str_print_if.Text := rect.ca.str_print_if;
	cbx_footer.Checked := rect.ca.bo_footer;
	cbx_footer.Enabled := (rect.ca.i_section_1B = MAIN_SECTION);
	cbx_posizione_fissa.Checked := rect.ca.bo_posizione_fissa;
	cbx_dimensione_verticale_fissa.Checked := rect.bo_dimensione_verticale_fissa;
	load_combo_show_types(cb_show, rect.ca.i_section_1B, rect.ca.show);
	panel_foreground.Color := rect.lo_colore_bordo;panel_background.Color := rect.lo_colore_fondo;
	cbx_trasparente.Checked := rect.bo_trasparente;

	case rect.ca.tipo_oggetto of
		OBJ_LINE : begin
			cbx_trasparente.Visible := FALSE;
//			panel_foreground.Caption := 'LINEA'
			panel_foreground.Caption := ''	// non scrivo nulla
		end;
		OBJ_RECT : begin
			visible_FC(txt_round_corners, FALSE);updown_round_corners.Visible := FALSE
		end
	end;
	enable_ctrls;
//	{$ifdef DEBUG} check_components(self) {$endif DEBUG}	*** molti FALSE messages
end;

procedure Tdlg_rect_settings.FormClose(Sender : TObject;var Action : TCloseAction); begin Action := caFree end;
procedure Tdlg_rect_settings.FormDestroy(Sender : TObject); begin wx.register_close_window(self) end;
procedure Tdlg_rect_settings.AAA_something_modified(Sender : TObject); begin bo_something_modified := TRUE;enable_ctrls end;
procedure Tdlg_rect_settings.btn_cancelClick(Sender : TObject); begin close end;

procedure Tdlg_rect_settings.FormActivate(Sender : TObject);
begin
	i_thickness.Text := rect.i_thickness.Tostring;
	i_round_corners.Text := rect.i_round_factor.ToString
end;

procedure Tdlg_rect_settings.btn_okClick(Sender : TObject);
var
	i, i_tmp_thickness, i_tmp_round : integer;
	r_h, r_w, r_l, r_t : real;
begin
	Ival(i_thickness.Text, i_tmp_thickness, i);
	if (i <> 0) OR (i_tmp_thickness <= 0) OR (i_tmp_thickness > MAX_THICKNESS) then begin beep(2);exit end;
	RRval(i_height.Text, r_h, @i);
	if (i = 0) then RRval(i_width.Text, r_w, @i);
	if (i = 0) then RRval(i_left.Text, r_l, @i);
	if (i = 0) then RRval(i_top.Text, r_t, @i);
	if (i <> 0) then begin MessageBBox(handle, 'Valore errato per la dimensione o la posizione', MBOX_CAPTION);exit end;
	var str_new_name := str_nome.Text;		// necessario UPPERCASE() per motivi storici
	if NOT xobj.check_name(handle, str_new_name) then exit;

	IVal(i_round_corners.Text, i_tmp_round, i);
	if (i <> 0) OR (i_tmp_round < 0) OR (i_tmp_round > MAX_ROUND_FACTOR) then begin beep(2);exit end;

	var sec : cl_sezione := sections_1B(xobj.ca.i_section_1B);
	if NOT sec.validate_formula_editing(handle, str_formula_Xpos.Text, 'formula posizione asse X', NIL, VAL_NUMERO, {allow_blank}TRUE) then exit;
	if NOT sec.validate_formula_editing(handle, str_formula_Ypos.Text, 'formula posizione asse Y', NIL, VAL_NUMERO, {allow_blank}TRUE) then exit;
	if NOT sec.validate_formula_editing(handle, str_formula_DX.Text, 'formula dimensione asse X', NIL, VAL_NUMERO, {allow_blank}TRUE) then exit;
	if NOT sec.validate_formula_editing(handle, str_formula_DY.Text, 'formula dimensione asse Y', NIL, VAL_NUMERO, {allow_blank}TRUE) then exit;

	rect.ca.str_formula_Xpos_cm := str_formula_Xpos.Text;rect.ca.tipo_formula_Xpos := shift_formula_type(cb_formula_Xpos.ItemIndex);
	rect.ca.str_formula_Ypos_cm := str_formula_Ypos.Text;rect.ca.tipo_formula_Ypos := shift_formula_type(cb_formula_Ypos.ItemIndex);
	rect.ca.str_formula_DX_cm := str_formula_DX.Text;rect.ca.tipo_formula_DX := shift_formula_type(cb_formula_DX_type.ItemIndex);
	rect.ca.str_formula_DY_cm := str_formula_DY.Text;rect.ca.tipo_formula_DY := shift_formula_type(cb_formula_DY_type.ItemIndex);

	with xobj do begin
		rect.ca.str_print_if := togliblanks(self.str_print_if.Text);
		if NOT rect.ca.check_print_if(handle) then exit;
		rect.i_thickness := i_tmp_thickness;
		rect.i_round_factor := i_tmp_round;
		rect.ca.bo_footer := cbx_footer.Checked;
		rect.ca.bo_posizione_fissa := cbx_posizione_fissa.Checked;
		rect.bo_dimensione_verticale_fissa := cbx_dimensione_verticale_fissa.Checked;
		set_width(cm2pixel_video_x(r_w));set_height(cm2pixel_video_y(r_h));
		set_left(cm2pixel_video_x(r_l));set_top(cm2pixel_video_y(r_t));
		if (str_new_name <> uppercase(get_name)) then begin
			change_riferimenti(get_name, str_new_name);
			set_name(str_new_name)
		end;
		set_show_state(get_show_type(cb_show));
//		set_show_state(show_types(cb_show.ItemIndex))
		rect.lo_colore_bordo := panel_foreground.Color;
		rect.lo_colore_fondo := panel_background.Color;
		rect.bo_trasparente := cbx_trasparente.Checked
	end;

	set_global_modified;
	close
end;

procedure Tdlg_rect_settings.btn_colori_automaticiClick(Sender : TObject);
begin
	panel_foreground.Color := clBlack;panel_background.Color := clWhite;
	cbx_trasparente.Checked := TRUE;
	enable_ctrls
end;

procedure Tdlg_rect_settings.set_foreground_colors;
begin
	panel_foreground.Font.Color := automatic_foreground_color(panel_foreground.Color);
	panel_background.Font.Color := automatic_foreground_color(panel_background.Color)
end;

procedure Tdlg_rect_settings.btn_legamiClick(Sender : TObject);
begin
	if legami_comunitari_proc(self, i_obj) then bo_something_modified := TRUE
end;

procedure Tdlg_rect_settings.FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
begin
	if key_button(key, VK_F9, btn_ok, TRUE) then exit;
	case key of
		VK_F6: cb_show.SetFocus;
		VK_F11 : str_print_if.SetFocus
	end
end;

procedure Tdlg_rect_settings.color_click(Sender : TObject);
var panel : TFPanel absolute Sender;
begin
	var col : TColor := panel.Color;
	if select_colore(self, col) then begin
		panel.Color := col;
		panel.Font.Color := automatic_foreground_color(col);
		bo_something_modified := TRUE
	end
end;

procedure Tdlg_rect_settings.enable_ctrls;
begin
	var bo_line := (rect.ca.tipo_oggetto = OBJ_LINE);
	panel_background.Visible := NOT bo_line AND NOT cbx_trasparente.Checked;
	set_foreground_colors
end;

initialization
	galateo_initialization_debug('rect_edit')
finalization
	galateo_finalization_debug('rect_edit')
end.
