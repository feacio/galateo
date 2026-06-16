unit BMP_dialog;

{$I defines}
{$ifdef DLL} *** {$endif}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls,
	Gdich, proc, Federico, bmps, FBitBtn;

function bmp_dialog_proc(father : TForm;bmp : cl_bmp) : boolean;

type
  Tbmps = class(TForm)
    txt_size_y: TLabel;
	 r_size_x: TEdit;
	 r_size_y: TEdit;
    txt_size_x: TLabel;
    btn_original_size: TButton;
	 btn_ok: TFBitBtn;
	 btn_cancel: TFBitBtn;
    txt_object_name: TLabel;
    str_object_name: TEdit;
    cbx_posizione_fissa: TCheckBox;
    cbx_footer: TCheckBox;
    txt_top: TLabel;
    txt_left: TLabel;
	 r_left: TEdit;
	 r_top: TEdit;
	 txt_object: TLabel;
    cbx_proporzioni: TCheckBox;
	 btn_load: TBitBtn_fede;
	 btn_save: TBitBtn_fede;
	 cbx_consenti_sovrapposizione: TCheckBox;
	 pc_options: TFPageControl;
	 page_visualizzazione: TTabSheet;
    page_dynamic_load: TTabSheet;
    page_formule_posizione: TTabSheet;
	 cbx_sfondo_design_time: TCheckBox;
    txt_show: TLabel;
    cb_show: TFCombo;
    txt_print_if: TLabel;
    str_print_if: TEdit;
    txt_formula_Xpos: TLabel;
	 txt_formula_Xpos_type: TLabel;
    txt_formula_Ypos: TLabel;
    txt_formula_Ypos_type: TLabel;
    str_formula_Xpos: TEdit;
    cb_formula_Xpos: TComboBox;
    str_formula_Ypos: TEdit;
    cb_formula_Ypos: TComboBox;
    txt_posizione_header: TLabel;
    str_immagine_dinamica: TEdit;
    cbx_autosize_dinamica: TCheckBox;
    cbx_cannot_exceed_original_size: TCheckBox;
    rb_autoresize_align_horz: TRadioGroup;
    rb_autoresize_align_vert: TRadioGroup;
    cbx_image_dinamica_must_exist: TCheckBox;
    cbx_move_obj_sottostanti: TCheckBox;
    cbx_image_dinamica_should_exist: TCheckBox;
    txt_dynamic_header: TMyLabel;
    txt_immagine_dinamica: TLabel;
	 procedure FormCreate(Sender : TObject);
	 procedure btn_cancelClick(Sender : TObject);
	 procedure btn_okClick(Sender : TObject);
	 procedure btn_original_sizeClick(Sender : TObject);
	 procedure btn_loadClick(Sender : TObject);
	 procedure btn_saveClick(Sender : TObject);
	 procedure FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
	 procedure generic_enable_ctrls(Sender : TObject);
	 procedure FormDestroy(Sender : TObject);
	 procedure FormClose(Sender : TObject;var Action : TCloseAction);
  private
		bmp_external, bmp_local : cl_bmp;
		r_size_x_value,r_size_y_value, fl_left, fl_top : double;
		bo_image_modified : boolean;
		procedure enable_ctrls;
		function read : boolean;
		procedure write;
		function save : boolean;
		constructor xcreate(father : TForm;bmp : cl_bmp);
 end;

implementation

uses Fcommons, FXStrings, FStrings, FErrMsg, FMessage, FCtrls, FBrowse,
	wproc, galateo_debug, misure, objects, pages, objsx, sezione;

{$R *.DFM}

const
	MBOX_CAPTION = 'Caratteristiche immagine';

function bmp_dialog_proc(father : TForm;bmp : cl_bmp) : boolean;
begin
	if NOT wx.can_open(father, WT_IMAGE_EDIT, bmp.get_name) then begin result := FALSE;exit end;
	var dlg := Tbmps.xcreate(father, bmp);
	wx.register_window(father, dlg, WT_IMAGE_EDIT, bmp.get_name);
//	dlg.showmodal;dlg.release;
	dlg.Show;
	result := TRUE
end;

constructor Tbmps.xcreate(father : TForm;bmp : cl_bmp);
begin
	bmp_external := bmp;
	inherited create(father)
end;

procedure Tbmps.FormCreate(Sender : TObject);
begin
	bmp_local := cl_bmp.xcreate(bmp_external);
	str_object_name.Text := bmp_external.get_name;
	load_combo_show_types(cb_show, bmp_local.ca.i_section_1B, bmp_local.ca.show);
	load_shift_formula_items(cb_formula_Xpos.Items);
	load_shift_formula_items(cb_formula_Ypos.Items);
	write;
	enable_ctrls;
	{$ifdef DEBUG} check_components(self) {$endif DEBUG}
end;

procedure Tbmps.FormClose(Sender : TObject;var Action : TCloseAction); begin Action := caFree end;

procedure Tbmps.FormDestroy(Sender : TObject);
begin
	if (bmp_local <> NIL) then begin bmp_local.ca.free;bmp_local.free;bmp_local := NIL end;
	wx.close_window(self)
end;

function Tbmps.save : boolean;
begin
	result := FALSE;
	if NOT read then exit;
	bmp_external.assign_data(bmp_local);
	if bo_image_modified then begin
		bmp_external.Picture.Assign(bmp_local.Picture);
		bo_image_modified := FALSE
	end;
	result := TRUE
end;

procedure Tbmps.btn_okClick(Sender : TObject);
begin
//	if NOT read then exit;
//	bmp_external.assign_data(bmp_local);
	if save then close
end;

procedure Tbmps.btn_cancelClick(Sender : TObject);
begin close end;

procedure Tbmps.btn_original_sizeClick(Sender : TObject);
begin
	if (MessageBBox(handle, 'Vuoi ripristinare le dimensioni originali dell''immagine?', MBOX_CAPTION, MB_QUESTION) <> IDYES) then exit;
	bmp_local.Autosize := TRUE;bmp_local.Autosize := FALSE;
	close
end;

procedure Tbmps.btn_loadClick(Sender : TObject);
var str_filename : string;
begin
//	if NOT load.execute then exit;
	if NOT browse_for_files_open(self, 'Carica immagine', str_filename, BMP_EXT, BMP_FILES_FILTER, {default_dir}'') then exit;
	if NOT bmp_local.load_file(str_filename, FALSE) then exit;
	bo_image_modified := TRUE;
	if NOT save then exit;
	close
end;

procedure Tbmps.btn_saveClick(Sender : TObject);
var str_filename : string;
begin
//	if NOT savedialog.execute then exit;
	if NOT browse_for_files_save(self, 'Salva immagine', str_filename, BMP_EXT, BMP_FILES_FILTER, {default_dir}'') then exit;
	try
		bmp_external.Picture.Graphic.SaveToFile(str_filename);
		MessageBBox(handle, 'Immagine salvata' + ACAPO2 + str_filename, MBOX_CAPTION)
	except
		MessageBBox(handle, 'Errore durante il salvataggio dell''immagine', MBOX_CAPTION, MB_ICONSTOP)
	end
end;

procedure Tbmps.FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
begin
	case key of
		VK_F6 : begin pc_options.ActivePage := page_visualizzazione;cb_show.SetFocus end;
		VK_F9: btn_ok.click;
		VK_F11 : begin pc_options.ActivePage := page_visualizzazione;str_print_if.SetFocus end
	end
end;

procedure Tbmps.generic_enable_ctrls(Sender : TObject); begin enable_ctrls end;

procedure Tbmps.enable_ctrls;
begin
	cbx_cannot_exceed_original_size.Enabled := cbx_autosize_dinamica.Checked;
	cbx_move_obj_sottostanti.Enabled := cbx_autosize_dinamica.Checked;
	if NOT cbx_cannot_exceed_original_size.Enabled then cbx_cannot_exceed_original_size.Checked := FALSE;

	enable_FC(txt_show, NOT cbx_sfondo_design_time.Checked);
	enable_FC(txt_print_if, NOT cbx_sfondo_design_time.Checked);
	page_dynamic_load.TabVisible := NOT cbx_sfondo_design_time.Checked;

	cbx_image_dinamica_should_exist.Enabled := NOT cbx_image_dinamica_must_exist.Checked;
	if (cbx_image_dinamica_must_exist.Checked) then cbx_image_dinamica_should_exist.Checked := TRUE;

	rb_autoresize_align_horz.Enabled := cbx_autosize_dinamica.Checked AND cbx_cannot_exceed_original_size.Checked;
	rb_autoresize_align_vert.Enabled := rb_autoresize_align_horz.Enabled AND NOT cbx_move_obj_sottostanti.Checked
end;

procedure Tbmps.write;
begin
	r_size_x_value := video2cm_x(bmp_local.Width);r_size_y_value := video2cm_y(bmp_local.Height);
	fl_left := video2cm_x(bmp_local.Left);fl_top := video2cm_y(bmp_local.Top);
	txt_object.Caption := zeri(bmp_local.ca.i_numero_obj, 3);

	r_size_x.Text := strid(r_size_x_value, 0, 2);
	r_size_y.Text := strid(r_size_y_value, 0, 2);
	r_left.Text := strid(fl_left, 0, 2);
	r_top.Text := strid(fl_top, 0, 2);
	cbx_posizione_fissa.Checked := bmp_local.ca.bo_posizione_fissa;
	cbx_footer.Checked := bmp_local.ca.bo_footer;
	cbx_footer.Enabled := (bmp_local.ca.i_section_1B = MAIN_SECTION);
	str_print_if.Text := bmp_local.ca.str_print_if;
	cbx_sfondo_design_time.Checked := bmp_local.bo_sfondo_design_time;
	str_immagine_dinamica.Text := bmp_local.str_immagine_dinamica;
	cbx_autosize_dinamica.Checked := bmp_local.bo_autosize_immagine_dinamica;
	cbx_image_dinamica_must_exist.Checked := bmp_local.bo_image_dinamica_must_exist;
	cbx_image_dinamica_should_exist.Checked := bmp_local.bo_image_dinamica_should_exist;
	cbx_cannot_exceed_original_size.Checked := bmp_local.bo_cannot_exceed_original_size;
	rb_autoresize_align_horz.Itemindex := byte(bmp_local.autoresize_align_horz);
	rb_autoresize_align_vert.Itemindex := byte(bmp_local.autoresize_align_vert);

	str_formula_Xpos.Text := bmp_local.ca.str_formula_Xpos_cm;cb_formula_Xpos.ItemIndex := byte(bmp_local.ca.tipo_formula_Xpos);
	str_formula_Ypos.Text := bmp_local.ca.str_formula_Ypos_cm;cb_formula_Ypos.ItemIndex := byte(bmp_local.ca.tipo_formula_Ypos);

	cbx_proporzioni.Checked := bmp_local.bo_mantieni_proporzioni;

	cbx_move_obj_sottostanti.Checked := bmp_local.ca.bo_move_obj_sottostanti;
	cbx_consenti_sovrapposizione.Checked := bmp_local.ca.bo_consenti_sovrapposizione_oggetti_simili
end;

function Tbmps.read : boolean;
begin
	result := FALSE;
	try
		if NOT xobjs(bmp_local.ca.i_numero_obj, {i_logical_page}0).check_name(handle, str_object_name.Text) then exit;

		bmp_local.ca.str_print_if := self.str_print_if.Text;
		if NOT bmp_local.ca.check_print_if(handle) then exit;

		bmp_local.bo_sfondo_design_time := cbx_sfondo_design_time.Checked;

		var sec : cl_sezione := sections_ZB(bmp_local.ca.i_section_1B - 1);
//		ox := xobjs(bmp_local.ca.i_numero_obj, get_pagina_logica_attiva_1B);
		if NOT sec.validate_formula_editing(handle, str_formula_Xpos.Text, 'formula posizione asse X', NIL, VAL_NUMERO, {allow_blank}TRUE) then exit;
		if NOT sec.validate_formula_editing(handle, str_formula_Ypos.Text, 'formula posizione asse Y', NIL, VAL_NUMERO, {allow_blank}TRUE) then exit;
		bmp_local.ca.str_formula_Xpos_cm := str_formula_Xpos.Text;bmp_local.ca.tipo_formula_Xpos := shift_formula_type(cb_formula_Xpos.ItemIndex);
		bmp_local.ca.str_formula_Ypos_cm := str_formula_Ypos.Text;bmp_local.ca.tipo_formula_Ypos := shift_formula_type(cb_formula_Ypos.ItemIndex);

		bmp_local.set_name(str_object_name.Text);
		r_size_x_value := leggi_text_real(handle, r_size_x, 0.1, 32, 'dimensione orizzontale', r_size_x_value);	// 32 ? non c'è una ragione precisa !
		r_size_y_value := leggi_text_real(handle, r_size_y, 0.1, 32, 'dimensione verticale', r_size_y_value);

//		fl_left := leggi_text_real(handle,r_left,0.1,20,'posizione orizzontale',fl_left);
		fl_left := leggi_text_real(handle, r_left, 0, get_PHpage_size_X_cm_1B - r_size_x_value, 'posizione orizzontale', fl_left);

//		fl_top := leggi_text_real(handle,r_top,0.1,20,'posizione verticale',fl_top);
		fl_top := leggi_text_real(handle, r_top, -DELTA_CUSCINO_VERTICAL_HEIGHT,
			sections_ZB(bmp_local.ca.i_section_1B - 1).r_y_gruppo_cm - video2cm_y(bmp_local.Height) + DELTA_CUSCINO_VERTICAL_HEIGHT, 'posizione verticale', fl_top);

		bmp_local.Width := cm2pixel_video_x(r_size_x_value);
		bmp_local.Height := cm2pixel_video_y(r_size_y_value);
		bmp_local.Left := cm2pixel_video_x(fl_left);
		bmp_local.Top := cm2pixel_video_y(fl_top);

		bmp_local.ca.show := get_show_type(cb_show);
//		bmp_local.set_show_state(get_show_type(cb_show));
		bmp_local.Visible := (bmp_local.ca.show <> OSW_HIDE) OR globale.bo_show_hidden_objects;
		bmp_local.str_immagine_dinamica := str_immagine_dinamica.Text;
		bmp_local.bo_autosize_immagine_dinamica := cbx_autosize_dinamica.Checked;
		bmp_local.bo_image_dinamica_must_exist := cbx_image_dinamica_must_exist.Checked;
		bmp_local.bo_image_dinamica_should_exist := cbx_image_dinamica_should_exist.Checked;
		bmp_local.bo_cannot_exceed_original_size := cbx_cannot_exceed_original_size.Checked;
		bmp_local.autoresize_align_horz := horz_align_type(rb_autoresize_align_horz.Itemindex);
		bmp_local.autoresize_align_vert := vert_align_type(rb_autoresize_align_vert.Itemindex);
		bmp_local.bo_mantieni_proporzioni := cbx_proporzioni.Checked;

		bmp_local.ca.bo_posizione_fissa := cbx_posizione_fissa.Checked;
		bmp_local.ca.bo_footer := cbx_footer.Checked;
		bmp_local.ca.bo_move_obj_sottostanti := cbx_move_obj_sottostanti.Checked;
		bmp_local.ca.bo_consenti_sovrapposizione_oggetti_simili := cbx_consenti_sovrapposizione.Checked;

		result := TRUE
	except
		error_msg(self, '', MBOX_CAPTION)
	end
end;

initialization
	galateo_initialization_debug('bmp_dialog')
finalization
	galateo_finalization_debug('bmp_dialog')
end.
