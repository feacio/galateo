unit Fields;	//*

{$ifNdef GALATEO_EXE} *** {$endif}

{$I defines}

interface

uses Db, SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Menus, Math, Buttons, ExtCtrls, ActnList,
	Fcommons, Federico, FBitBtn, gdich;

//const MAX_FIELDS = 399;		// numero max di fields editabili contemporaneamente
type
  Tw_fields = class(TForm)
	 lb: TListBox;
	 menu: TMainMenu;
	 itm_fields: TMenuItem;
	 itm_close: TMenuItem;
	 itm_opzioni: TMenuItem;
	 itm_solo_campi_mancanti: TMenuItem;
	 itm_primo_piano: TMenuItem;
	 itm_update_fields: TMenuItem;
	 N1: TMenuItem;
	 itm_sort_fields: TMenuItem;
    panel_buttons: TPanel;
    btn_load: TFBitBtn;
	 popup: TPopupMenu;
	 itp_copy_field_name: TMenuItem;
	 itp_carica: TMenuItem;
	 N2: TMenuItem;
	 itm_copy_field_name: TMenuItem;
    btn_order_by_name: TFSpeedButton;
    btn_not_used: TFSpeedButton;
	 procedure FormCreate(Sender : TObject);
	 procedure FormClose(Sender : TObject;var Action : TCloseAction);
	 procedure lbDblClick(Sender : TObject);
	 procedure itm_solo_campi_mancantiClick(Sender : TObject);
	 procedure itm_closeClick(Sender : TObject);
	 procedure itm_primo_pianoClick(Sender : TObject);
	 procedure itm_update_fieldsClick(Sender : TObject);
	 procedure itm_sort_fieldsClick(Sender : TObject);
	 procedure btn_loadClick(Sender : TObject);
    procedure FormResize(Sender : TObject);
    procedure itp_caricaClick(Sender : TObject);
	 procedure itm_copy_field_nameClick(Sender : TObject);
	 procedure btn_order_by_nameClick(Sender : TObject);
	 procedure btn_not_usedClick(Sender : TObject);
  private
		i_section_ZB : section_index_type;
		bo_dont_open : boolean;
//		i_pos_sections : array[1..MAX_SECTIONS] of obj_index_type;	// posizione dell'inizio delle sezioni nella lista
//		i_pos_blanks : array[1..MAX_SECTIONS] of obj_index_type;		// posizione dei blanks nella lista
		ffx_type : array of TFieldType;
		bo_solo_campi_non_utilizzati : boolean;	// TRUE se si vogliono nell'elenco solamente i campi non utilizzati
		procedure exec;
		procedure insert_object_ZB(str_field_name : string;i_section_ZB : section_index_type);
		procedure update_lbox(bo_keep_pos : boolean);
  public
		constructor xcreate_ZB(father : TForm;i_section_ZB : section_index_type);
  end;

//function fields_proc(father : TForm;i_section : section_index_type) : TW_fields;

implementation

{$R *.DFM}

uses FErrMsg, FXStrings, FStrings, FTrans, FMessage, FCtrls, FSystem_base, FSystem,
	proc, galateo_debug, objsx, objects, pages, sezione, galateo_main, labels;

const
	MBOX_CAPTION = 'Campi database';

{function fields_proc(father : TForm;i_section : section_index_type) : TW_fields;
var dlg : Tw_fields;
begin
	dlg := Tw_fields.xCreate(father, i_section);
	dlg.ShowModal;
//	dlg.Free		NOOOOOOOOO *********
end;	}

constructor Tw_fields.xcreate_ZB(father : TForm;i_section_ZB : section_index_type);
begin
	self.i_section_ZB := i_section_ZB;
	bo_dont_open := TRUE;bo_solo_campi_non_utilizzati := FALSE;
	inherited create(father);
//	parent := father;
	if bo_dont_open then abort;
	visible := TRUE
end;

procedure Tw_fields.FormCreate(Sender : TObject);
begin
	update_lbox(FALSE);
//	left := 50;width := GetSystemMetrics(SM_CXFULLSCREEN) div 4;
//	top := 50;height := GetSystemMetrics(SM_CYFULLSCREEN) - top*2;
	IO_form_size_and_pos(self, FALSE, 'fields');
	if (i_section_ZB <> -1) then caption := 'SEZIONE <' + uppercase(sections_ZB(i_section_ZB).str_nome) + '>';

	set_menuitem(itp_copy_field_name, itm_copy_field_name);
	bo_dont_open := FALSE
end;

procedure Tw_fields.FormClose(Sender : TObject;var Action : TCloseAction);
begin
	if (i_section_ZB <> -1) then sections_ZB(i_section_ZB).w_fields := NIL;
	ffx_type := NIL;
	IO_form_size_and_pos(self, TRUE, 'fields')
end;

procedure Tw_fields.exec;
begin
	var i : obj_index_type := lb.ItemIndex;if (i = -1) then begin beep(0);exit end;
{	for j := 1 to get_num_sections do if (i_pos_blanks[j] = i) then exit;
	for j := 1 to get_num_sections do if (i_pos_sections[j] = i) then begin
		MessageBBox(handle,sections(j).tsql_command.Text,'Comando SQL');
		exit
	end;
	if (i_section = 0) then j := get_section_attiva else j := i_section; }
//	insert_object(lb.Items[i],j,ffx_type[i])
	insert_object_ZB(lb.Items[i], i_section_ZB)
end;

procedure Tw_fields.insert_object_ZB(str_field_name : string;i_section_ZB : section_index_type);
const P_VOID : Tpoint = (x:0;y:0);
var i_obj : obj_index_type;	//*
begin
	var str_obj_name := str_field_name;
	if (name2index(str_obj_name, [], FALSE, get_pagina_logica_attiva_1B) <> 0) then begin
		if (MessageBBox(handle,'Esiste già un oggetto con nome <' + str_field_name + '> .' + ACAPO2 + 'Vuoi inserirlo ugualmente?',
			MBOX_CAPTION, MB_QUESTION_DEF2) <> IDYES) then exit;
		i_obj := 0;
		while (name2index(str_obj_name, [], FALSE, get_pagina_logica_attiva_1B) <> 0) do begin
			inc(i_obj);str_obj_name := str_field_name + '_' + zeri(i_obj,2)
		end;
		MessageBBox(handle,'Il nome dell''oggetto inserito è stato cambiato in <' + str_obj_name + '>',MBOX_CAPTION)
	end;

//	i_obj := new_obj(xxxVARIABILE, i_section, P_VOID);
	i_obj := new_obj_ZB(LABEL_OBJ, get_pagina_logica_attiva_ZB, i_section_ZB, P_VOID);
	if (i_obj = 0) then abort;
	str_field_name := togliblanks(str_field_name);
	var lab : cl_label := xobjs(i_obj).aslabel;
	lab.Caption := str_obj_name;
	lab.ca.str_SQL_expression := str_field_name;
	lab.ca.tipo_variabile := TV_DB_FIELD;
	var ff_type : TFieldType := sections_ZB(i_section_ZB).qry.FindField(str_field_name).DataType;
	if (ff_type in NUMERIC_FIELDS) then begin lab.ca.tipo_valore := VAL_NUMERO;lab.ca.str_esempio_value := inttostr(random(9) + 1) end
	else begin lab.ca.tipo_valore := VAL_TESTO;lab.ca.str_esempio_value := 'ABC' end;
	if bo_solo_campi_non_utilizzati then update_lbox(TRUE)
end;

procedure Tw_fields.update_lbox(bo_keep_pos : boolean);

	procedure load_section(i_section_ZB : section_index_type{;bo_alone : boolean});
	// if (BO_ALONE) then la sezione caricata è l'unica da caricare
	begin
{		if NOT bo_alone then begin
			if (i_section > 1) then begin i_pos_blanks[i_section] := lb.Items.Count;lb.Items.add('') end;
			i_pos_sections[i_section] := lb.Items.Count;
			lb.Items.add('SEZIONE <' + uppercase(sections(i_section).str_nome) + '>')
		end; }
		var sz : cl_sezione := sections_ZB(i_section_ZB);
		for var i : obj_index_type := 0 to sz.qry.fielddefs.Count-1 do begin
			var str_column_name := sz.qry.FieldDefs[i].Name;
			if bo_solo_campi_non_utilizzati AND (dbcolumn2obj(str_column_name) <> NIL) then continue;
			setLength(ffx_type, length(ffx_type)+1);
			ffx_type[length(ffx_type)-1] := sz.qry.fielddefs[i].datatype;
			lb.Items.add(str_column_name)
		end
	end;

begin
	var i_pos : section_index_type := lb.ItemIndex;
	lb.Items.clear;
//	for i := 1 to MAX_SECTIONS do begin i_pos_sections[i] := -1;i_pos_blanks[i] := -1 end;
	try
		with globale.system_database do
			if (drivername <> '') AND NOT Connected then Connected := TRUE
	except
		error_msg(self, 'Impossibile eseguire la connessione al database', MBOX_CAPTION);
		abort
	end;

	if (i_section_ZB = -1) then open_all_queries(FALSE, TRUE, FALSE)
	else sections_ZB(i_section_ZB).query_open(FALSE, TRUE, FALSE, FALSE);

//	if (i_section = 0) then for i := 1 to get_num_sections do load_section(i, get_num_sections = 1) else load_section(i_section,TRUE);
	load_section(i_section_ZB);
	if bo_keep_pos then lb.ItemIndex := MIN(i_pos, lb.Items.Count-1)
end;

procedure Tw_fields.lbDblClick(Sender : TObject); begin exec end;
procedure Tw_fields.btn_loadClick(Sender : TObject); begin exec end;
procedure Tw_fields.itp_caricaClick(Sender : TObject); begin exec end;
procedure Tw_fields.itm_closeClick(Sender : TObject); begin close end;
procedure Tw_fields.itm_update_fieldsClick(Sender : TObject); begin update_lbox(FALSE) end;

procedure Tw_fields.itm_primo_pianoClick(Sender : TObject);
begin
	itm_primo_piano.Checked := NOT itm_primo_piano.Checked;
	if itm_primo_piano.Checked then formstyle := fsstayontop
	else formstyle := fsnormal
end;

procedure Tw_fields.itm_sort_fieldsClick(Sender : TObject);
begin
//	MessageBBox(handle,'SISTEMARE il discorso dell''ordinamento!!!',MBOX_CAPTION,MB_ICONSTOP);
	itm_sort_fields.Checked := NOT itm_sort_fields.Checked;
	if (btn_order_by_name.Down <> itm_sort_fields.Checked) then btn_order_by_name.Down := itm_sort_fields.Checked;
	lb.Sorted := itm_sort_fields.Checked;update_lbox(FALSE)
end;

procedure Tw_fields.btn_order_by_nameClick(Sender : TObject);
begin
	itm_sort_fieldsClick(NIL)
end;

procedure Tw_fields.FormResize(Sender : TObject);
begin {btn_load.Left := (clientwidth - btn_load.Width) div 2 - 1} end;

procedure Tw_fields.itm_copy_field_nameClick(Sender : TObject);
begin
	if (lb.ItemIndex <> -1) then begin
		str2clipboard(lb.Items[lb.ItemIndex]);
		beep
	end
end;

procedure Tw_fields.itm_solo_campi_mancantiClick(Sender : TObject);
begin
	bo_solo_campi_non_utilizzati := NOT itm_solo_campi_mancanti.Checked;
	if (btn_not_used.Down <> bo_solo_campi_non_utilizzati) then btn_not_used.Down := bo_solo_campi_non_utilizzati;
	itm_solo_campi_mancanti.Checked := bo_solo_campi_non_utilizzati;
	update_lbox(FALSE)
end;

procedure Tw_fields.btn_not_usedClick(Sender : TObject);
begin
	itm_solo_campi_mancantiClick(NIL)
end;

initialization
	galateo_initialization_debug('fields')
finalization
	galateo_finalization_debug('fields')
end.
