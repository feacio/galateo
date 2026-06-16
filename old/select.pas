unit Select;	//*

{$ifdef DLL} *** {$endif}

{$I defines}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, DB, Math, DBCtrls, Grids, DBGrids, ExtCtrls, StdCtrls,
	Menus, Buttons, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
	FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FDB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
	FBitBtn, federico,
	printers_DX, Gdich, numprint, objects, proc, sqlcomm, working;

procedure select_proc(father : TForm;var str_driver,str_table : string;var lo_totale_labels : integer;var bo_passa_a_manuale : boolean);

type
  Tdlg_select = class(TForm)
    grid_panel: TFPanel;
	 ds: TDataSource;
	 popup_grid: TPopupMenu;
    impostaDA1: TMenuItem;
	 impostaA1: TMenuItem;
    panel_buttons: TFPanel;
	 pre_in_stampa_txt: TLabel;
	 post_in_stampa_txt: TLabel;
	 txt_foglio: TLabel;
	 btn_close: TFBitBtn;
    btn_ff: TFBitBtn;
	 i_in_stampa: TEdit;
	 btn_reset_print: TFBitBtn;
    btn_preview: TFBitBtn;
	 stamparecordselezionato1: TMenuItem;
	 N1: TMenuItem;
	 cbx_bigscreen: TCheckBox;
    tbl: TTable;
    qry: TFquery;
	 btn_how_many: TFBitBtn;
	 btn_manuale: TFBitBtn;
    Panel1: TFPanel;
    gb_orderby: TGroupBox;
	 cb_sort: TComboBox;
    btn_sort: TFBitBtn;
    cbx_sort: TCheckBox;
    btn_comando_manuale: TFBitBtn;
    dbn: TDBNavigator;
	 grid: TDBGrid;
	 gb_selezione: TGroupBox;
    txt_from: TLabel;
    label_select: TLabel;
    txt_to: TLabel;
    cb_select: TComboBox;
    str_from: TEdit;
    str_to: TEdit;
    btn_applica_select: TFBitBtn;
    btn_print_select: TFBitBtn;
    cbx_not_only_iniziali: TCheckBox;
    cbx_filtro: TCheckBox;
    gb_singolo_codice: TGroupBox;
    txt_print_singolo: TLabel;
    Label1: TLabel;
    str_print_singolo: TEdit;
    btn_goto: TFBitBtn;
    btn_print_singolo: TFBitBtn;
	 cb_campo_singolo: TComboBox;
	 btn_print_all: TFBitBtn;
	 procedure FormCreate(Sender : TObject);
	 procedure btn_applica_selectClick(Sender : TObject);
	 procedure impostaDA1Click(Sender : TObject);
	 procedure impostaA1Click(Sender : TObject);
	 procedure popup_gridPopup(Sender : TObject);
	 procedure btn_gotoClick(Sender : TObject);
	 procedure str_print_singoloChange(Sender : TObject);
	 procedure cbx_sortClick(Sender : TObject);
	 procedure str_fromChange(Sender : TObject);
	 procedure str_toChange(Sender : TObject);
	 procedure btn_sortClick(Sender : TObject);
	 procedure btn_closeClick(Sender : TObject);
	 procedure stamparecordselezionato1Click(Sender : TObject);
	 procedure btn_ffClick(Sender : TObject);
	 procedure btn_reset_printClick(Sender : TObject);
	 procedure FormCloseQuery(Sender : TObject;var CanClose : Boolean);
	 procedure btn_print_selectClick(Sender : TObject);
	 procedure btn_print_singoloClick(Sender : TObject);
	 procedure cbx_not_only_inizialiClick(Sender : TObject);
	 procedure gridDblClick(Sender : TObject);
	 procedure btn_previewClick(Sender : TObject);
	 procedure cbx_bigscreenClick(Sender : TObject);
	 procedure cbx_filtroClick(Sender : TObject);
	 procedure btn_how_manyClick(Sender : TObject);
	 procedure btn_manualeClick(Sender : TObject);
	 procedure btn_comando_manualeClick(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
	 procedure gridKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
    procedure btn_print_allClick(Sender : TObject);
  private
		printer : TFPrinter;	// si sovrappone al default
		str_table : string;
		pt_lo_totale_labels : ^integer;
//		bo_tuttoschermo : boolean;
//		i_y0_grid,i_dy_grid : integer;
		str_filter_campo,str_filter_to,str_filter_from : string;
		bo_in_cbx_filtro_click : boolean;
		bo_odbc : boolean;
		procedure imposta_limite(bo_from : boolean);
		procedure set_table_index;
		function exec_select(str_campo, str_from, str_to : string) : boolean;
		procedure print(bo_selected : boolean;str_campo, str_from, str_to : string);
		function get_values_variabili(bo_printing : boolean) : boolean;
		function my_find_field(str_campo : string) : TField;
		procedure set_index(str_index : string);
		procedure exec_sort;
		procedure print_all;
  public
		constructor xcreate(father : TForm;var str_driver,str_table : string;var lo_totale_labels : integer;var bo_passa_a_manuale : boolean);
	private
		i_last_label_printed_fisico : integer;	{ ultima etichetta stampata }
//		str_from_original_caption : string[30];
		str_from_original_caption, str_from_original_hint : string;
		pt_bo_manuale : ^boolean;
		bo_open_ok : boolean;
		procedure write_last_label_printed(i : integer);
		function read_last_label_printed : integer;
		property i_last_label_printed : integer read read_last_label_printed write write_last_label_printed;
  end;


implementation

uses Fcommons, FAssert, FXStrings, FStrings, FSystem_base, FSystem, FMessage,
	galateo_debug, misure, pages, labels, running_etichette;

{$R *.DFM}

procedure select_proc(father : TForm;var str_driver,str_table : string;var lo_totale_labels : integer;var bo_passa_a_manuale : boolean);
var dlg: Tdlg_select;
begin
	dlg := Tdlg_select.xcreate(father, str_driver, str_table, lo_totale_labels, bo_passa_a_manuale);
	dlg.ShowModal;dlg.Free
end;

constructor Tdlg_select.xcreate(father : TForm;var str_driver,str_table : string;
	var lo_totale_labels : integer;var bo_passa_a_manuale : boolean);
begin
	pt_lo_totale_labels := @lo_totale_labels;
//	bo_tuttoschermo := FALSE;
	bo_in_cbx_filtro_click := FALSE;
	bo_odbc := (str_driver <> '');
	self.str_table := str_table;
	pt_bo_manuale := @bo_passa_a_manuale;bo_passa_a_manuale := FALSE;
	inherited create(father);
	if NOT bo_open_ok then abort
end;

procedure Tdlg_select.FormCreate(Sender : TObject);
var
	i : smallint;
	s : string;
	bo : boolean;
begin
	set_wait_cursor(TRUE);
	bo_open_ok := FALSE;
	try
		if bo_ODBC then tbl.DatabaseName := globale.system_database.Name else tbl.DatabaseName := '';
		qry.DatabaseName := tbl.DatabaseName;
		tbl.TableName := str_table;tbl.Active := TRUE;
		// genero il collegamento con la stampante
		printer := TFPrinter.create;
		tm.init_print_values({printer.handle,}'');
		i_last_label_printed := 0;
		windowstate := wsMaximized;
		set_wait_cursor(FALSE)
	except
		set_wait_cursor(FALSE);
		MessageBBox(NULL, 'Impossibile collegarsi al database specificato.' + ACAPO2 +
			'Assicurati che il database sia presente ed accessibile e che le informazioni di accesso al database '+
			'(vedi: menù DATABASE/Configurazione) siano corrette.', MBOX_CAPTION);
		// disabilito tutto tranne il comando di chiusura
		for i := 0 to ControlCount-1 do controls[i].Enabled := FALSE;
		panel_buttons.Enabled := TRUE;
		for i := 0 to panel_buttons.controlcount-1 do panel_buttons.controls[i].Enabled := FALSE;
		btn_close.Enabled := TRUE;
		exit
	end;
	tbl.indexdefs.Update;
	for i := 0 to tbl.fieldcount-1 do begin
		s := lowercase(tbl.fields[i].fieldname);
		bo := (tbl.indexdefs.indexof(s) <> -1);

		if bo_ODBC then begin
			if bo then s := uppercase(s) else s := lowercase(s);
		end
		else // carico solo gli indici disponibili
			if NOT bo then continue;

		cb_select.Items.add(s);
		cb_campo_singolo.Items.add(s);
		cb_sort.Items.add(s)
	end;
	i := cb_select.Items.indexof(globale.str_db_field_default);
	cb_select.ItemIndex := i;cb_sort.ItemIndex := i;cb_campo_singolo.ItemIndex := i;

	if bo_ODBC then
		cb_sort.Hint := 'Campo in base a cui viene effettuato l''ordinamento dei records;'+
		' in MAIUSCOLO sono specificati i campi con indice (ricerca veloce)'
	else cb_sort.Hint := 'Campo in base a cui viene effettuato l''ordinamento dei records';

	if NOT tm.bo_print_pagina_completa then begin
		btn_ff.Enabled := FALSE;btn_reset_print.Enabled := FALSE;
		pre_in_stampa_txt.Enabled := FALSE;post_in_stampa_txt.Enabled := FALSE;
		txt_foglio.Enabled := FALSE;i_in_stampa.Enabled := FALSE
	end;
	txt_foglio.Caption := '(foglio: ' + inttostr(tm.i_lab_per_row*tm.i_lab_per_page) + ' etichette)';
	str_from_original_caption := txt_from.Caption;
	str_from_original_hint := str_from.Hint;

	bo_open_ok := TRUE
end;

procedure Tdlg_select.FormDestroy(Sender : TObject);
begin printer.free end;

procedure Tdlg_select.FormCloseQuery(Sender: TObject;var CanClose: Boolean);
begin
	canclose := TRUE;
	if (i_last_label_printed <> 0) then begin
		case MessageBBox(handle,MBOX_MSG_FF_PRINT_QUESTION,MBOX_CAPTION,MB_ICONQUESTION+MB_YESNOCANCEL) of
			IDYES:
				try
					enabled := FALSE;
					printer.EndDoc
				except
            	enabled := TRUE
				end;
			IDNO,IDCANCEL: begin
				MessageBBox(handle,MBOX_MSG_CANT_EXIT_PRINT,MBOX_CAPTION);
				canclose := FALSE;pt_bo_manuale^ := FALSE
			end
		end
	end
end;

function Tdlg_select.my_find_field(str_campo : string) : TField;
begin
	if tbl.Active then my_find_field := tbl.FindField(str_campo)
	else my_find_field := qry.FindField(str_campo)
end;

function Tdlg_select.exec_select(str_campo, str_from, str_to : string) : boolean;
const LAST_CHAR = 'z';	// was: #127
var
	ff : TField;	//*
	str_temp, str_apice, str_where : string;
begin
//	result := FALSE;
	set_wait_cursor(TRUE);
	str_where := '';
	var bo_tbl := tbl.Active;

	if (str_campo <> '') then begin
		ff := my_find_field(str_campo);
		if (ff.datatype in STRING_DB_TYPES) then str_apice := '''' else str_apice := ' ';
		if cbx_not_only_iniziali.Checked then begin
			if (ff.datatype in STRING_DB_TYPES) then begin
				if (str_from <> '') then
					str_where := str_where + str_campo + ' LIKE''%' + str_from + '%''AND '
			end
			else MessageBBox(handle,
				'L''opzione di selezione ''CERCA ANCHE NON INIZIALI'' non può essere utilizzata su campi numerici come <' +
					uppercase(str_campo)+'>', MBOX_CAPTION, MB_ICONSTOP);
		end
		else begin
			if (str_from <> '') then str_where := str_where + str_campo + '>=' + str_apice + str_from + str_apice + 'AND ';
			if (str_to <> '') then begin
				if (my_find_field(str_campo).datatype in STRING_DB_TYPES) then str_to := str_to + LAST_CHAR;
				str_where := str_where + str_campo + '<=' + str_apice + str_to+ str_apice + 'AND '
			end
		end
	end;
	if (str_filter_campo <> '') then begin
		ff := my_find_field(str_filter_campo);
		if (ff.datatype in STRING_DB_TYPES) then str_apice := '''' else str_apice := ' ';
		if (str_filter_from <> '') then
			str_where := str_where + str_filter_campo + '>=' + str_apice + str_filter_from + str_apice + 'AND ';
		if (str_filter_to <> '') then begin
			str_to := str_filter_to;
			if (ff.datatype in STRING_DB_TYPES) then str_to := str_to + LAST_CHAR;
			str_where := str_where + str_filter_campo + '<=' + str_apice + str_to + str_apice + 'AND '
		end
	end;

	if bo_odbc then str_apice := ' ' else str_apice := '''';
	qry.SQL.Text := 'SELECT * FROM ' + str_apice + str_table + str_apice;
	if (str_where <> '') then begin
		delete(str_where, length(str_where) - length('AND ') + 1, MAXINT);
		qry.SQL.add('WHERE ' + str_where)
	end;

	if cbx_sort.Checked AND (cb_sort.Text <> '') then str_temp := cb_sort.Text
	else begin
		str_temp := str_campo;
		cb_sort.ItemIndex := cb_sort.Items.indexof(str_campo)
	end;
	if (str_temp <> '') then qry.SQL.add('ORDER BY ' + str_temp);	{ str_temp potrebbe essere = '' se str_campo = '' }
	qry.RequestLive := TRUE;

	try
		tbl.Active := FALSE;
		ds.DataSet := qry;
		qry.Active := TRUE;
		set_wait_cursor(FALSE);
		result := TRUE
	except
		MessageBBox(handle,'Errore durante la selezione.' + ACAPO2 +
			'Probabilmente uno dei limiti impostati è scorretto.' + ACAPO2 +
			'Di seguito comparirà un messaggio che spiega (in inglese) il tipo di errore',
			MBOX_CAPTION,MB_ICONSTOP);
		if bo_tbl then tbl.Active := TRUE
		else begin
			qry.SQL.Text := 'SELECT * FROM ' + str_apice + str_table + str_apice;
			qry.Active := TRUE
		end;
		{result :=} exec_select('','','');
		set_wait_cursor(FALSE);
		raise	{ emetto il messaggio di errore }
	end
end;

procedure Tdlg_select.imposta_limite(bo_from : boolean);
label only_codice;
var
	i : integer;
	str_codice : string;
begin
	if (cb_select.Items.indexof(grid.selectedfield.fieldname) = -1) then begin
		MessageBBox(handle,'Impossibile usare questo campo per selezionare records.',MBOX_CAPTION);
		exit
	end;

	if (cb_select.Text <> '') AND (uppercase(cb_select.Text) <> uppercase(grid.selectedfield.fieldname)) then begin
		case MessageBBox(handle,'Vuoi cambiare il campo in base a cui selezionare?',MBOX_CAPTION,MB_YESNOCANCEL+MB_ICONQUESTION) of
			IDYES: begin
				cb_select.ItemIndex := cb_select.Items.indexof(grid.selectedfield.fieldname);
				str_codice := grid.selectedfield.AsString
			end;
			IDNO: begin
				i := tbl.fielddefs.indexof(cb_select.Text);
				str_codice := tbl.fields[i].AsString;
				goto only_codice
			end;
			IDCANCEL : exit
		end
	end
	else begin
		cb_select.ItemIndex := cb_select.Items.indexof(grid.selectedfield.fieldname);
		str_codice := grid.selectedfield.AsString
	end;
only_codice:
	if bo_from then str_from.Text := str_codice else str_to.Text := str_codice
end;

procedure Tdlg_select.btn_applica_selectClick(Sender : TObject);
begin
	exec_select(string(cb_select.Text), string(str_from.Text), string(str_to.Text))
end;

procedure Tdlg_select.impostaDA1Click(Sender : TObject); begin imposta_limite(TRUE) end;
procedure Tdlg_select.impostaA1Click(Sender : TObject); begin imposta_limite(FALSE) end;
procedure Tdlg_select.exec_sort; begin if tbl.Active then set_table_index else btn_applica_select.click end;
procedure Tdlg_select.btn_sortClick(Sender : TObject); begin exec_sort end;
procedure Tdlg_select.btn_closeClick(Sender : TObject); begin close end;

procedure Tdlg_select.popup_gridPopup(Sender : TObject);
begin
	if (grid.selectedfield.fieldname = '') then begin
		MessageBBox(handle,'Seleziona un record',MBOX_CAPTION);
		exit
	end
end;

procedure Tdlg_select.set_index(str_index : string);
{ attiva l'indice e lo setta sulla voce specificata;
  serve solo per la TABLE, not per la query }
begin
	if NOT tbl.Active then exit;
	var bo_was_checked := cbx_sort.Checked;cbx_sort.Checked := TRUE;
	cb_sort.ItemIndex := cb_sort.Items.indexof(str_index);
	exec_sort;
	cbx_sort.Checked := bo_was_checked
end;

procedure Tdlg_select.btn_gotoClick(Sender : TObject);
label fine;
begin
	set_wait_cursor(TRUE);
	try
		if NOT tbl.Active then begin
			qry.Active := FALSE;
			ds.dataset := tbl;
			tbl.Active := TRUE
		end;
		if (cb_campo_singolo.Text = '') then begin beep(0);abort end;	{ non si tratta di errore, ma solo di un modo per uscire }
		tbl.cancelrange;	{ tolgo impostazioni precedenti }
		{ setto l'indice sulla key desiderata: per forza, altrimenti non ha senso andare al codice }
		set_index(cb_campo_singolo.Text);
		tbl.SetKey;
		tbl.FindField(cb_campo_singolo.Text).AsString := str_print_singolo.Text;
		tbl.GotoNearest;
		grid.selectedfield := tbl.findfield(cb_campo_singolo.Text)
	except
   end;
fine:
	set_wait_cursor(FALSE)
end;

procedure Tdlg_select.str_print_singoloChange(Sender : TObject);
begin
	var bo := (length(str_print_singolo.Text) > 0);
	btn_goto.Enabled := bo;btn_print_singolo.Enabled := bo;
	btn_goto.default := bo;btn_applica_select.default := NOT bo;
	if bo then begin str_from.Text := '';str_to.Text := '' end
end;

procedure Tdlg_select.cbx_sortClick(Sender : TObject);
begin
	var bo := cbx_sort.Checked;
	cb_sort.Enabled := bo;
	btn_sort.Enabled := bo
end;

procedure Tdlg_select.set_table_index;
{ imposta l'indice per la table (not per la query, che se lo imposta da sola) }
begin
	if NOT tbl.Active then exit;
	if (uppercase(tbl.indexfieldnames) = uppercase(cb_sort.Text)) then exit;	{ nulla da fare }
	if (uppercase(tbl.indexname) = uppercase(cb_sort.Text)) then exit;	{ nulla da fare }
	set_wait_cursor(TRUE);
	tbl.cancelrange;
	if NOT cbx_sort.Checked OR (cb_sort.Text = '') then tbl.indexname := ''
	else begin
		tbl.Active := FALSE;
		tbl.indexfieldnames := cb_sort.Text;
		tbl.Active := TRUE
	end;
	set_wait_cursor(FALSE)
end;

procedure Tdlg_select.str_fromChange(Sender : TObject);
begin
	var bo := (togliblanks(str_from.Text) <> '') OR (togliblanks(str_to.Text) <> '');
{	btn_applica_select.Enabled := bo; {}
	btn_print_select.Enabled := bo;
	btn_goto.default := NOT bo;btn_applica_select.default := bo;
	if (str_from.Text <> '') then str_print_singolo.Text := ''
end;

procedure Tdlg_select.str_toChange(Sender : TObject);
begin
	var bo := (togliblanks(str_from.Text) <> '') OR (togliblanks(str_to.Text) <> '');
{	btn_applica_select.Enabled := bo; {}
	btn_print_select.Enabled := bo;
	if (str_to.Text <> '') then str_print_singolo.Text := ''
end;

function Tdlg_select.get_values_variabili(bo_printing : boolean) : boolean;
{ assegna il valore alle variabili caricandolo dal database;
  rende TRUE in caso di successo, FALSE altrimenti;
  if (BO_PRINTING) then emette messaggi d'errore }
label restart;
var
	i : i_obj_index_type;
	j : integer;
	str_result : string;
	r : real;
	fld : TField;
	x : objs_type;
	lab : cl_label;
begin
	get_values_variabili := FALSE;
restart:
	for i := 1 to i_objs do begin
		x := xobjs(i);
//		if (x.get_tipo_oggetto <> xVARIABILE) then continue;
		if NOT (x.tipo_variabile in TV_OLD_VARIABILI) then continue;
		lab := x.aslabel;
//		fld := my_find_field(lab.str_db_colonna);
		fld := my_find_field(x.str_SQL_expression);
		if (fld = NIL) then begin
//			if (lab.str_db_colonna = '') then begin
			if (x.str_SQL_expression = '') then begin
				if (my_find_field(lab.Caption) = NIL)
//					then str_result := 'La variabile <' + lab.Caption + '> non è associata a nessun campo del database'
					then str_result := 'La variabile <' + x.get_name + '> non è associata a nessun campo del database'
				else begin
//					lab.str_db_colonna := lab.Caption;
					x.str_SQL_expression := lab.Caption;
					goto restart
				end
			end
			else str_result := 'La variabile <' + x.get_name + '> è associata ad un campo del database sconosciuto o non valido';
			MessageBBox(handle, str_result, MBOX_CAPTION);
			exit
		end;
		str_result := fld.AsString;
		RRval(str_result, r, @j);
		if ((x.ca.tipo_valore = VAL_NUMERO) AND (j <> 0)) then begin
			MessageBBox(handle,'Il valore del campo <' + lab.Caption + '> deve essere numerico', MBOX_CAPTION);
			exit
		end;
//		strcpy(aslabel.lp_print,asciiz(str_result))
		lab.str_print := str_result
	end;
	get_values_variabili := TRUE
end;	

procedure Tdlg_select.write_last_label_printed(i : integer);
begin
	i_last_label_printed_fisico := i;
	i_in_stampa.Text := inttostr(i);
	btn_reset_print.Enabled := tm.bo_print_pagina_completa AND (i <> 0);
	btn_ff.Enabled := tm.bo_print_pagina_completa AND (i <> 0)
end;

function Tdlg_select.read_last_label_printed : integer;
begin read_last_label_printed := i_last_label_printed_fisico end;

procedure Tdlg_select.stamparecordselezionato1Click(Sender : TObject); begin print(TRUE,'','','') end;
procedure Tdlg_select.gridDblClick(Sender : TObject); begin print(TRUE,'','','') end;

procedure Tdlg_select.btn_ffClick(Sender : TObject);
begin
	btn_ff.Enabled := FALSE;
	if (i_last_label_printed <> 0) then begin
		try printer.EndDoc except end;
		i_last_label_printed := 0
	end
end;

procedure Tdlg_select.btn_reset_printClick(Sender : TObject);
begin
	if (MessageBBox(handle,MBOX_MSG_RESET_PRINT_QUESTION,MBOX_CAPTION,MB_ICONQUESTION+MB_YESNOCANCEL) <> IDYES) then exit;
	try printer.abort except end;
	i_last_label_printed := 0;
	MessageBBox(handle,'La coda di stampa è vuota',MBOX_CAPTION)
end;

procedure Tdlg_select.btn_print_selectClick(Sender : TObject);
begin print(FALSE, string(cb_select.Text), string(str_from.Text), string(str_to.Text)) end;

procedure Tdlg_select.btn_print_singoloClick(Sender : TObject);
label errore;
var r : real;
begin
	btn_goto.click;
	var ff := tbl.FindField(cb_campo_singolo.Text);
	if (ff = NIL) then goto errore;	// should not happen
	var str_error := 'Codice non trovato';
	if (ff.datatype in NUMERIC_DB_TYPES) then begin
		if (NOT RRval(str_print_singolo.Text,r)) then goto errore;
		if (abs(r - ff.asfloat) > 1e-6) then goto errore
	end
	else if (uppercase(str_print_singolo.Text) <> uppercase(ff.AsString)) then goto errore;
	print(TRUE, '', '', '');
	exit;	{ TUTTO OK }
errore:
	if (str_error <> '') then MessageBBox(handle, str_error, MBOX_CAPTION, MB_ICONSTOP)
	else beep(0)
end;

procedure Tdlg_select.cbx_not_only_inizialiClick(Sender : TObject);
begin
	var bo := cbx_not_only_iniziali.Checked;
	str_to.Enabled := NOT bo;txt_to.Enabled := NOT bo;
	if NOT bo then begin
		txt_from.Caption := string(str_from_original_caption);
		str_from.Hint := str_from_original_hint
	end
	else begin
		txt_from.Caption := 'codice';
		str_from.Hint := 'Seleziona tutti i codici contenenti la parola specificata (schiaccia APPLICA per selezionare)'
	end
end;

procedure Tdlg_select.btn_previewClick(Sender : TObject);
begin
	if NOT get_values_variabili(FALSE) then exit;
	if NOT calcola_values(handle,FALSE,0,FALSE) then exit;
	dlg_preview := Tdlg_preview.xcreate(self);
	dlg_preview.showmodal;dlg_preview.release
end;

procedure Tdlg_select.cbx_bigscreenClick(Sender : TObject);
begin
{	bo_tuttoschermo := NOT bo_tuttoschermo;
	if (bo_tuttoschermo) then begin
		i_y0_grid := grid_panel.Top;
		i_dy_grid := grid_panel.Height;
		grid_panel.Top := gb_orderby.Top;
		grid_panel.Height := gb_selezione.Top+gb_selezione.Height - gb_orderby.Top
	end
	else begin grid_panel.Top := i_y0_grid;grid_panel.Height := i_dy_grid end;
	btn_comando_manuale.Visible := NOT bo_tuttoschermo;
	gb_orderby.Visible := NOT bo_tuttoschermo;
	gb_singolo_codice.Visible := NOT bo_tuttoschermo;
	gb_selezione.Visible := NOT bo_tuttoschermo }
end;

procedure Tdlg_select.cbx_filtroClick(Sender : TObject);
label fine;
begin
	if bo_in_cbx_filtro_click then exit;
	bo_in_cbx_filtro_click := TRUE;
	str_filter_from := '';str_filter_to := '';str_filter_campo := '';
	if cbx_filtro.Checked then begin
		if cbx_not_only_iniziali.Checked then begin
			cbx_filtro.Checked := FALSE;
			MessageBBox(handle,
				'Impossibile usare come filtro una selezione in cui la ricerca avviene anche per ''NON INIZIALI''.',
				MBOX_CAPTION);
			goto fine
		end;
		if (cb_select.Text = '') then begin
			cbx_filtro.Checked := FALSE;
			MessageBBox(handle,'Imposta un campo in base a cui selezionare i dati',MBOX_CAPTION);
			goto fine
		end;
		str_filter_from := togliblanks(str_from.Text);
		str_filter_to := togliblanks(str_to.Text);
		if (str_filter_from = '') AND (str_filter_to = '') then begin
			beep(0);cbx_filtro.Checked := FALSE;
			goto fine
		end;
		str_filter_campo := cb_select.Text;
		MessageBBox(handle,'Le impostazioni correnti saranno considerate come filtro per le prossime selezioni',
			MBOX_CAPTION);
		str_from.Text := '';str_to.Text := '';
	end;
	btn_applica_select.click;
fine:
	bo_in_cbx_filtro_click := FALSE
end;

procedure Tdlg_select.btn_how_manyClick(Sender : TObject);
var
	lo : integer;
	s : string;
begin
	set_wait_cursor(TRUE);
	if tbl.Active then lo := tbl.recordcount else lo := qry.recordcount;
	set_wait_cursor(FALSE);
	s := '';
	if (lo = -1) then s := 'Calcolo impossibile'
	else begin
		if (lo < 10) then s := 'solo ';
		if (lo > 999) then s := 'la bellezza di ';
		s := 'La lista contiene ' + s + puntato(lo) + ' records.'
	end;
	MessageBBox(handle, s, MBOX_CAPTION)
end;

procedure Tdlg_select.btn_manualeClick(Sender : TObject);
begin
	// carico sulla variabile i valori del record attivo
	get_values_variabili(FALSE);
//	for i := 1 to i_objs do with xobjs(i) do if (get_tipo = xVARIABILE) then
	for var i : i_obj_index_type := 1 to i_objs do with xobjs(i) do if (tipo_variabile in TV_OLD_VARIABILI) then
		with aslabel do save_print_variable_value(caption, str_print);
	close;	// necessario per chiudere la stampante attiva
	pt_bo_manuale^ := TRUE
end;

procedure Tdlg_select.btn_comando_manualeClick(Sender : TObject);
var
	i : integer;
	str_apice, str_sql : string;
begin
	var bo_was_active := tbl.Active;
	tbl.Active := FALSE;
	str_sql := '';
	for i := 0 to qry.SQL.Count-1 do str_sql := str_sql + qry.SQL.strings[i] + ' ';
	str_sql := togliblanks(str_sql);
	SQL_comm := TSQL_comm.xcreate(self,tbl,str_sql);
	try
		Visible := FALSE;
		SQL_comm.ShowModal;SQL_comm.Release
	finally
		Visible := TRUE
	end;
	if (str_sql = '') then begin tbl.Active := bo_was_active;exit end;

	str_sql := uppercase(str_sql);
	if (pos(' FROM ',str_sql) = 0) then begin
		i := length(str_sql)+1;
		i := MAX(MIN(i, pos('WHERE', str_sql)), MIN(i, pos('ORDER BY', str_sql)));
		if (i = 0) then i := str_sql.Length + 1;
		if bo_odbc then str_apice := ' ' else str_apice := '''';
		insert(' FROM ' + str_apice + str_table + str_apice, str_sql, i)
	end;
	try
		set_wait_cursor(TRUE);
		qry.Active := FALSE;qry.RequestLive := FALSE;
		qry.SQL.Text := str_sql;
		ds.DataSet := qry;qry.Active := TRUE;
		set_wait_cursor(FALSE)
	except
		ds.DataSet := tbl;tbl.Active := TRUE;
		set_wait_cursor(FALSE);
		MessageBBox(handle,'Errore nel comando SQL. Seguirà una descrizione (ahimè in inglese) dell''errore', MBOX_CAPTION, MB_ICONSTOP);
		raise
	end
end;

procedure Tdlg_select.print(bo_selected : boolean;str_campo, str_from, str_to : string);
label fine;
var
	i_labs, k : integer;
	{bo_ok,}bo_stop, bo_stop_window, bo_ask_incorrect : boolean;
begin
	{bo_ok := FALSE; }
	i_labs := get_print_num(self);
	if (i_labs < 1) then begin beep;exit end;

	bo_stop_window := NOT bo_selected OR (i_labs > 1);
	if NOT bo_stop_window then begin
		set_wait_cursor(TRUE);
		SetCapture(handle)
	end;
	if NOT bo_selected AND NOT exec_select(str_campo, str_from, str_to) then exit;
	bo_stop := FALSE;bo_ask_incorrect := TRUE;
	if bo_stop_window then begin
//		workwin := Tdlg_working.create_printing(self, FALSE, {qry.recordcount}grid.datasource.dataset.recordcount, bo_stop);
		ww_create_printing(self, FALSE, {qry.recordcount}grid.datasource.dataset.recordcount, bo_stop);
//		workwin.show;
		ww_show;
		Visible := FALSE
	end;
	while (NOT bo_stop) do begin
		if NOT bo_selected AND qry.eof then break;
//		if (bo_selected AND tbl.eof) then break;
		if NOT get_values_variabili(TRUE) then goto fine;
		if NOT calcola_values(handle, TRUE, 0, FALSE) then goto fine;
		k := i_last_label_printed;
		try
			stampa(printer, handle, i_labs, k, pt_lo_totale_labels^, FALSE, bo_stop, bo_ask_incorrect)
		except
			bo_stop := TRUE
		end;
		i_last_label_printed := k;
		if bo_selected then break else qry.Next
	end;
{	bo_ok := TRUE; }
	if NOT tm.bo_print_pagina_completa then btn_ff.click;	// sputo la stampa

fine:
	if NOT bo_selected then exec_select(cb_select.Text, self.str_from.Text, self.str_to.Text);
	if bo_stop_window then begin
//		workwin.chiudi_finestra;workwin.free
		ww_close
	end
	else begin ReleaseCapture;set_wait_cursor(FALSE) end;
	beep(0);
	if bo_stop then MessageBBox(handle, 'Stampa interrotta dall''utente', MBOX_CAPTION, MB_ICONSTOP);
	Visible := TRUE
end;

procedure Tdlg_select.gridKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
begin
	case key of
		VK_RETURN : begin print(TRUE, '', '', '');key := 0 end
	end
end;

procedure Tdlg_select.btn_print_allClick(Sender : TObject); begin print_all end;

procedure Tdlg_select.print_all;
begin
	if (MessageBBox(handle, 'Vuoi stampare tutti (ma proprio TUTTI) i records in elenco?', MBOX_CAPTION, MB_QUESTION_DEF2) <> IDYES) then exit;
//	print(FALSE,'','','')
	print(FALSE, ifs(str_from.Text + str_to.Text = '', '', cb_select.Text), str_from.Text, str_to.Text)
end;

initialization
	galateo_initialization_debug('select')
finalization
	galateo_finalization_debug('select')
end.
