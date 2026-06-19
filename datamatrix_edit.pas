unit datamatrix_edit;

{$I defines}
{$ifdef DLL} *** {$endif}

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Buttons, Federico, StdCtrls, ExtCtrls, ActnList, Actions,
  Fcommons, FBitBtn, Gdich, objects, datamatrix_unit;

function datamatrix_edit_proc(father : TForm;dm : cl_datamatrix) : boolean;

type
  Tdlg_datamatrix = class(TForm)
	 panel_bottom: TFPanel;
	 txt_object: TLabel;
	 btn_legami: TFBitBtn;
	 btn_ok: TFBitBtn;
	 btn_cancel: TFBitBtn;
	 btn_help: TFBitBtn;
	 panel_base: TFPanel;
	 AL: TActionList;
	 AL_save: TAction;
	 AL_F6_visualizzazione: TAction;
	 AL_F11_stampa_if: TAction;
	 panel_header: TFPanel;
	 txt_nome: TMyLabel;
	 txt_valore: TMyLabel;
	 str_nome: TFEdit;
    str_valore: TFMemo;
    txt_tipo_variabile: TMyLabel;
    cb_tipo_variabile: TFCombo;
    txt_valore_text_only: TMyLabel;
    panel_formattazione: TFPanel;
    gbox_opzioni: TFGroupBox;
    txt_encoding_mode: TMyLabel;
	 txt_orientamento: TMyLabel;
    txt_preferred_format: TMyLabel;
    cb_encoding_mode: TFCombo;
	 cb_orientamento: TFCombo;
    cb_preferred_format: TFCombo;
	 gbox_font: TFGroupBox;
	 txt_backcolor: TMyLabel;
	 txt_forecolor: TMyLabel;
	 cb_backcolor: TColorBox;
	 cb_forecolor: TColorBox;
    gbox_opzioni_generali: TFGroupBox;
	 txt_show: TLabel;
	 txt_print_if: TLabel;
	 txt_hints: TLabel;
    cb_show: TFCombo;
	 str_print_if: TEdit;
	 str_hints: TEdit;
	 cbx_posizione_fissa: TCheckBox;
	 cbx_footer: TCheckBox;
	 txt_esempio: TLabel;
	 str_esempio: TEdit;
    gbox_size: TFGroupBox;
    txt_left: TLabel;
	 i_left_cm: TFEdit;
	 txt_top: TLabel;
	 i_top_cm: TFEdit;
    txt_size_Y: TLabel;
    fl_size_Y: TFEdit;
    cbx_autosize: TFCheckBox;
    btn_help_size: TFBitBtn;
    txt_size_X: TLabel;
    fl_size_X: TFEdit;
	 procedure FormCreate(Sender : TObject);
	 procedure btn_cancelClick(Sender : TObject);
	 procedure FormCloseQuery(Sender : TObject;var CanClose : Boolean);
	 procedure AAA_notify_modification(Sender : TObject);
	 procedure AL_saveExecute(Sender : TObject);
	 procedure AL_F6_visualizzazioneExecute(Sender : TObject);
	 procedure AL_F11_stampa_ifExecute(Sender : TObject);
	 procedure cb_tipo_variabileChange(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure btn_help_sizeClick(Sender : TObject);
    procedure FormClose(Sender : TObject;var Action : TCloseAction);
    procedure fl_size_XExit(Sender : TObject);
    procedure fl_size_XEnter(Sender : TObject);
  private
		pt_bo_modified : boolean_punt;
		bo_something_modified : boolean;
		i_obj : obj_index_type;						// numero dell'oggetto in editing
		i_logical_page : logical_page_type;		// pagina logica cui appartiene l'oggetto in editing
		xobj : objs_type;									// oggetto in modifica
		dmw : cl_datamatrix;								// Working copy
		dm_originale : cl_datamatrix;					// puntatore ai dati originali (copia dei dati da aggiornare in caso di modifiche salvata con successo)
		fl_DX_enter{, fl_DY_enter} : double;
		constructor xcreate(father : TForm;dm : cl_datamatrix;var bo_modified : boolean);
		procedure enable_ctrls;
		function read_data(dm : cl_datamatrix) : boolean;
		procedure save_and_close;
		function write_data : boolean;
  end;

implementation

{$R *.dfm}

uses FAssert, FXStrings, FStrings, FDataMatrix, FCtrls, FMessage,
	wproc, galateo_debug, proc, functions, pages, misure, objsx;

const
	MBOX_CAPTION = 'Datamatrix';
	HELP_DATAMATRIX_SIZE =
		'Il FORMATO rappresenta il numero di elementi del barcode (quadrati).' + ACAPO +
		'La DIMENSIONE rappresenta lo spazio utilizzato dal barcode (pixel).' + ACAPO2 +

		'Se FORMATO AUTOMATICO viene utilizzato il più piccolo formato sufficiente a rappresentare i dati,' + ACAPO +
		'altrimenti viene utilizzato il formato indicato (se sufficiente a rappresentare i dati, altrimenti viene ingrandito).' + ACAPO2 +

		'Se AUTOSIZE la dimensione del barcode viene determinata automaticamente in base al formato utilizzato,' + ACAPO +
		'altrimenti il barcode viene ridimensionato (ingrandito o rimpicciolito) fino a raggiungere la dimensione fissata.';

function datamatrix_edit_proc(father : TForm;dm : cl_datamatrix) : boolean;
begin
	if NOT wx.can_open(WT_DATAMATRIX_EDIT, father, dm.ca.i_numero_obj.ToString) then exit;
	var dlg := Tdlg_datamatrix.xCreate(father, dm, result);
	wx.register_open_window(father, dlg, WT_DATAMATRIX_EDIT, dm.ca.i_numero_obj.ToString);
{	if (bo_open_page_exportazione) then begin
		dlg.pc_visual_export.Activepage := dlg.page_export_integrale;
		if dlg.str_expint_header.Enabled then dlg.Activecontrol := dlg.str_expint_header
	end; }
//	dlg.ShowModal;dlg.Free
	dlg.Show
end;

constructor Tdlg_datamatrix.xcreate(father : TForm;dm : cl_datamatrix;var bo_modified : boolean);
begin
	pt_bo_modified := @bo_modified;bo_modified := FALSE;
	self.dm_originale := dm;
	dmw := cl_datamatrix.create(dm);
	i_obj := dm.ca.i_numero_obj;
	i_logical_page := get_pagina_logica_attiva_1B;
	xobj := xobjs(i_obj, i_logical_page);
	inherited create(father)
end;

procedure Tdlg_datamatrix.FormCreate(Sender : TObject);
begin
	caption := MBOX_CAPTION;
	txt_object.Caption := zeri(i_obj, 3);
	load_combo_show_types(cb_show, dm_originale.ca.i_section_1B, dmw.ca.show);

	cb_tipo_variabile.Items.Clear;
	for var i : byte := byte(low(variabile_type)) to byte(high(variabile_type)) do
		if (variabile_type(i) in DATAMATRIX_TIPI_VARIABILI) then cb_tipo_variabile.Items.Add(TV_DESCRIZIONE[variabile_type(i)]);

	write_data;
	{$ifdef DEBUG} check_components(self); {$endif DEBUG}
	bo_something_modified := FALSE
end;

procedure Tdlg_datamatrix.FormDestroy(Sender : TObject);
begin
	if (dmw <> NIL) then begin dmw.free;dmw := NIL end;
	wx.register_close_window(self)
end;

procedure Tdlg_datamatrix.FormCloseQuery(Sender: TObject;var CanClose: Boolean);
begin
	CanClose := NOT bo_something_modified OR (MessageBBox(handle, 'Vuoi uscire senza salvare le modifiche?', MBOX_CAPTION, MB_QUESTION_DEFBUTTON2) = IDYES)
end;

procedure Tdlg_datamatrix.FormClose(Sender : TObject;var Action : TCloseAction); begin Action := caFree end;
procedure Tdlg_datamatrix.AL_saveExecute(Sender : TObject); begin save_and_close end;
procedure Tdlg_datamatrix.btn_cancelClick(Sender : TObject); begin close end;
procedure Tdlg_datamatrix.AL_F6_visualizzazioneExecute(Sender : TObject); begin cb_next(cb_show) end;
procedure Tdlg_datamatrix.AL_F11_stampa_ifExecute(Sender : TObject); begin	str_print_if.SetFocus end;
procedure Tdlg_datamatrix.cb_tipo_variabileChange(Sender : TObject); begin enable_ctrls end;
procedure Tdlg_datamatrix.btn_help_sizeClick(Sender : TObject); begin MessageBBox(handle, HELP_DATAMATRIX_SIZE, MBOX_CAPTION) end;
procedure Tdlg_datamatrix.AAA_notify_modification(Sender : TObject); begin bo_something_modified := TRUE end;

procedure Tdlg_datamatrix.save_and_close;
begin
	if bo_something_modified then begin
		if NOT read_data(dmw) then exit;
		dm_originale.assign(dmw);
		bo_something_modified := FALSE;
		set_global_modified;
		pt_bo_modified^ := TRUE
	end;
	close
end;

function Tdlg_datamatrix.read_data(dm : cl_datamatrix) : boolean;
// legge e valida i dati dalla finestra; rende TRUE in caso di successo
begin
	result := FALSE;
	dmw.tv := get_tipo_variabile(cb_tipo_variabile.Text);
	if (cb_backcolor.Selected = cb_forecolor.Selected) then begin
		MessageBBox(handle, 'Il colore del fondo non può coincidere con quello del testo (non è una grande volpata!!!)', MBOX_CAPTION, MB_ICONSTOP);
		exit
	end;

	if NOT xobj.check_name(handle, str_nome.Text) then exit;

	case dmw.tv of
		TV_DB_FIELD : dmw.ca.str_SQL_expression := clear_blanks_eoln(str_valore.Text);
		TV_FORMULA : begin
			var s := '';
			dmw.ca.str_formula := clear_blanks_eoln(str_valore.Text);
			var str_temp := dmw.ca.str_formula;
			str_temp := translate_local_macros(str_temp);	// dal 2005-06-20
			sections_1B(dmw.ca.i_section_1B).interpreta_string(str_temp, FALSE, TRUE);	// aggiunta del 2005-05-09
//			tipo := VAL_BOH;
			var tipo : risultato_type := VAL_TESTO;	// limito al tipo di risultato TESTO
			var bo := translate_formula({dmw.str_formula}str_temp, s, TRUE, tipo, xobjs(i_obj, i_logical_page));
			if NOT bo then begin
				if (s <> '') then MessageBBox(handle, s, MBOX_CAPTION, MB_ICONSTOP);
				exit
			end
		end
	end;

	dmw.ca.str_print_if := togliblanks(str_print_if.Text);
	if NOT dmw.ca.check_print_if(handle) then exit;
	dmw.ca.str_esempio_value := str_esempio.Text;

	dmw.Name := uppercase(str_nome.Text);
	dmw.EncodingMode := cb_encoding_mode.ItemIndex;
	dmw.Orientation := cb_orientamento.ItemIndex * 90;
	if (cb_preferred_format.ItemIndex = 0) then dmw.PreferredFormat := DATAMATRIX_PF_AUTO
	else dmw.PreferredFormat := cb_preferred_format.ItemIndex - 1;

	dmw.BackColor := cb_backcolor.Selected;
	dmw.lo_true_color := cb_forecolor.Selected;
	dmw.bo_autosize := cbx_autosize.Checked;

	dmw.ca.show := show_types(cb_show.ItemIndex);
	dmw.ca.str_print_if := str_print_if.Text;
	dmw.Hint := str_hints.Text;
	dmw.ca.bo_posizione_fissa := cbx_posizione_fissa.Checked;
	dmw.ca.bo_footer := cbx_footer.Checked;

	var r : real := leggi_text_real(handle, i_left_cm, 0, get_PHpage_size_X_cm_1B(i_logical_page) - video2cm_x(dmw.Width), 'posizione orizzontale', video2cm_x(dmw.Left));
	dmw.Left := cm2pixel_video_x(r);
	r := leggi_text_real(handle,i_top_cm, -DELTA_CUSCINO_VERTICAL_HEIGHT,
		sections_1B(dmw.ca.i_section_1B).r_y_gruppo_cm - video2cm_y(dmw.Height) + DELTA_CUSCINO_VERTICAL_HEIGHT, 'posizione verticale', video2cm_y(dmw.Top));
	dmw.Top := cm2pixel_video_y(r);
	r := leggi_text_real(handle, fl_size_X, 0.1, 40, 'dimensione orizzontale', video2cm_x(dmw.Width));
	dmw.Width := cm2pixel_video_x(r);
	r := leggi_text_real(handle, fl_size_Y, 0.1, 40, 'dimensione vertuicale', video2cm_y(dmw.Width));
	dmw.Height := cm2pixel_video_y(r);

	result := TRUE
end;

procedure Tdlg_datamatrix.fl_size_XEnter(Sender : TObject); begin fl_DX_enter := fl_size_X.get_AsFloat(FALSE) end;

procedure Tdlg_datamatrix.fl_size_XExit(Sender : TObject);
begin
	var fl_DX : double := fl_size_X.get_AsFloat(FALSE);
	if (fl_DX_enter = fl_DX) then exit;
	// sarà corretto nella next line confrontare fl_DX_enter con fl_size_Y ??? NON LO SO !!!!!!!!
	if (fl_DX_enter = fl_size_Y.get_AsFloat(FALSE)) then fl_size_Y.set_AsFloat(fl_DX)
end;

function Tdlg_datamatrix.write_data : boolean;
begin
	str_nome.Text := dmw.Name;
	case dmw.tv of
		TV_FORMULA : str_valore.Text := dmw.ca.str_formula;
		TV_DB_FIELD : str_valore.Text := dmw.ca.str_SQL_expression
	end;

	cb_select(cb_tipo_variabile, TV_DESCRIZIONE[dmw.tv]);
	cb_encoding_mode.ItemIndex := dmw.EncodingMode;
	cb_orientamento.ItemIndex := dmw.Orientation div 90;
	var i : smallint := 0;
	if (dmw.PreferredFormat <> DATAMATRIX_PF_AUTO) then i := dmw.PreferredFormat + 1;
	cb_preferred_format.ItemIndex := i;
	cb_backcolor.Selected := dmw.BackColor;
	cb_forecolor.Selected := dmw.lo_true_color;
	cbx_autosize.Checked := dmw.bo_autosize;
	str_esempio.Text := dmw.ca.str_esempio_value;

	i_left_cm.Text := strid(video2cm_x(dmw.Left), 0, 2);
	i_top_cm.Text := strid(video2cm_y(dmw.Top), 0, 2);
	fl_size_X.Text := strid(video2cm_x(dmw.Width), 0, 2);
	fl_size_Y.Text := strid(video2cm_Y(dmw.Height), 0, 2);

//	cb_show.ItemIndex := byte(dmw.show);
	str_print_if.Text := dmw.ca.str_print_if;
	str_hints.Text := dmw.Hint;
	cbx_posizione_fissa.Checked := dmw.ca.bo_posizione_fissa;
	cbx_footer.Checked := dmw.ca.bo_footer;
	enable_ctrls;
	result := TRUE
end;

procedure Tdlg_datamatrix.enable_ctrls;
begin
	dmw.tv := get_tipo_variabile(cb_tipo_variabile.Text);
	str_valore.Color := TIPO_VARIABILE_EDIT_COLOR[dmw.tv];
	txt_valore.Caption := 'valore (' + TV_DESCRIZIONE[dmw.tv] + ')';
	txt_valore_text_only.Visible := (dmw.tv = TV_FORMULA)
end;

initialization
	galateo_initialization_debug('datamatrix_edit')
finalization
	galateo_finalization_debug('datamatrix_edit')
end.
