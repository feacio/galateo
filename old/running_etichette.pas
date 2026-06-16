unit running_etichette;		//*

{$ifdef DLL} *** {$endif}

{$I defines}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
	Printers_DX, Gdich, objects, proc;

procedure save_print_variable_value(str_name,str_value : string);

type
	TRunning_edit_punt = ^TRunning_edit_type;
  Trunning_window = class(TForm)
	 panel_buttons: TPanel;
	 btn_print: TButton;
	 btn_close: TButton;
	 btn_ff: TButton;
	 pre_in_stampa_txt: TLabel;
	 i_in_stampa: TEdit;
	 post_in_stampa_txt: TLabel;
	 txt_num_labels: TLabel;
	 i_num_labels: TEdit;
	 panel_vars: TPanel;
	 btn_recalcola: TButton;
	 btn_reset_print: TButton;
	 txt_foglio: TLabel;
	 btn_preview: TButton;
	 panel_function: TPanel;
	 btn_print_sel: TButton;
	 procedure btn_closeClick(Sender : TObject);
	 procedure FormCreate(Sender : TObject);
	 procedure btn_printClick(Sender : TObject);
	 procedure FormClose(Sender : TObject;var Action : TCloseAction);
	 procedure btn_ffClick(Sender : TObject);
	 procedure FormCloseQuery(Sender : TObject;var CanClose : Boolean);
	 procedure btn_recalcolaClick(Sender : TObject);
	 procedure btn_reset_printClick(Sender : TObject);
	 procedure FormDestroy(Sender : TObject);
	 procedure btn_previewClick(Sender : TObject);
	 procedure btn_print_selClick(Sender : TObject);
	public
		robjs : array[1..MAX_OBJS] of TRunning_edit_punt;
		function get_robj_index(i_obj : integer) : integer;
		constructor xcreate(father : TForm;var lo_totale_labels : integer);
	private
		printer : TFPrinter;	// si sovrappone al default
		i_last_label_printed_fisico : integer;	// ultima etichetta stampata
		i_robjs : integer;
		pt_lo_totale_labels : ^integer;
		bo_ask_incorrect : boolean;
		procedure init_printer;
		procedure show_formula_values;
		function get_values_variabili(bo_printing : boolean) : boolean;
		procedure write_last_label_printed(i : integer);
		function read_last_label_printed : integer;
		property i_last_label_printed : integer
			read read_last_label_printed write write_last_label_printed;
  end;
	Trunning_edit_type = class(TEdit)
		private
			i_related_obj : i_obj_index_type;	// collegamento all'oggetto generatore
			str_nome : string;
			lab : TLabel;
			tipo_oggetto : obj_type;
			tipo_variabile : variabile_type;
		public
			constructor xcreate(tipo_oggetto : obj_type;tipo_variabile : variabile_type;parent : TRunning_window;panel : TPanel;
				i_related_obj,i_order : i_obj_index_type);
	end;

var
	running_window: Trunning_window;

implementation

uses Fcommons, FXStrings, FStrings, FMessage, FRegistry, PDF, 
	galateo_debug, misure, pages, expint_exec, preview, print_label_old, printer_select;

{$R *.DFM}

constructor Trunning_edit_type.xcreate(tipo_oggetto : obj_type;tipo_variabile : variabile_type;parent : TRunning_window;
	panel : TPanel;i_related_obj,i_order : i_obj_index_type);
var i_delta_height,i_temp : int_pixel_type;
begin
	inherited create(parent);
	i_temp := panel.Height;
	self.tipo_oggetto := tipo_oggetto;self.i_related_obj := i_related_obj;
	self.tipo_variabile := tipo_variabile;
	left := parent.i_num_labels.Left;
	i_delta_height := parent.i_num_labels.Height+7;
	height := parent.i_num_labels.Height;
	str_nome := xobjs(i_related_obj).aslabel.Caption;
	if (xobjs(i_related_obj).ca.tipo_valore = VAL_TESTO) then width := round((parent.Width - left) * 0.9357)
	else width := parent.i_num_labels.Width;

	panel.Height := panel.Height + i_delta_height;
	self.parent := panel;
//	case tipo_oggetto of
	case tipo_variabile of
//		xVARIABILE : begin
		TV_DB_FIELD, TV_PARAMETRO, TV_GROUP_EXPR_SQL, TV_SQL_SELECT_BEFORE_SQL, TV_SQL_SELECT_BEFORE_RUNTIME, TV_SQL_SELECT : begin
			taborder := i_order;
			top := parent.i_num_labels.Top + i_delta_height * (i_order-1)
		end;
//		xFORMULA: begin
		TV_FORMULA: begin
			enabled := FALSE;top := i_delta_height * (i_order-1) + 10;
			if (i_order = 1) then panel.Height := panel.Height + parent.i_num_labels.Top
		end
	end;	

	lab := TLabel.create(parent);
	lab.Parent := self.parent;
//	lab.Enabled := (tipo_oggetto = xVARIABILE);
	lab.Enabled := (tipo_variabile in TV_OLD_VARIABILI);
	lab.Autosize := TRUE;
	lab.Caption := str_nome;
//	if (tipo_oggetto = xVARIABILE) then begin
	if (tipo_variabile in TV_OLD_VARIABILI) then begin
		lab.Caption := '&' + lab.Caption;
		lab.focuscontrol := self
	end;
	lab.Height := parent.txt_num_labels.Height;
	lab.Left := parent.txt_num_labels.Left + parent.txt_num_labels.Width - lab.Width;
	lab.Top := top + height div 2 - lab.Height div 2;
	i_temp := (panel.Height - i_temp);
	parent.Height := parent.Height + i_temp;
	parent.panel_buttons.Top := parent.panel_buttons.Top + i_temp;
end;

{*****************************}

constructor Trunning_window.xcreate(father : TForm;var lo_totale_labels : integer);
begin
	pt_lo_totale_labels := @lo_totale_labels;
	inherited create(father)
end;

procedure Trunning_window.init_printer;
var str_printer : string;
begin
	str_printer := globale.printer_default[0].str_printer;
	if (str_printer = '') then printer.printerindex := -1
	else begin
		printer.printerindex := printer.Printers.indexof(str_printer);
		if (printer.printerindex = -1) AND (globale.printer_default[1].str_printer <> '') then
			printer.printerindex := printer.Printers.indexof(globale.printer_default[1].str_printer);
		if (printer.printerindex = -1) OR
			(uppercase(printer.Printers[printer.printerindex]) <> uppercase(str_printer))
		then begin
			MessageBBox(handle,'Impossibile selezionare la stampante <' + str_printer + '>.' + ACAPO2 +
				'La stampa avverrà sulla stampante predefinita di Windows.', MBOX_CAPTION, MB_ICONSTOP);
			printer.printerindex := -1
		  end
	end;
	tm.init_print_values({printer.handle,}str_printer)
end;

procedure Trunning_window.FormCreate(Sender : TObject);
const BUFSIZE = 100;
var
	p, q : LPSTR;
	xobj : objs_type;
	i, i_order_var, i_order_formula : i_obj_index_type;
begin
	printer := TFPrinter.create;	// genero il collegamento alla stampante

	init_printer;
	i_last_label_printed := 0;
	bo_ask_incorrect := TRUE;

	// genero i controls per le variabili
	p := stralloc(BUFSIZE);q := stralloc(BUFSIZE);
	i_order_var := 2;i_order_formula := 1;i_robjs := 0;
	if NOT tm.bo_print_pagina_completa then begin
		btn_ff.Enabled := FALSE;btn_reset_print.Enabled := FALSE;
		pre_in_stampa_txt.Enabled := FALSE;post_in_stampa_txt.Enabled := FALSE;
		txt_foglio.Enabled := FALSE;i_in_stampa.Enabled := FALSE
	end;

	// verifico se è possibile leggere ancora qualche valore dalla stampa precedente
	Windows.GetPrivateProfileString(INI_LAST_VALUES,INI_LAST_FILENAME,'',p,BUFSIZE,FILE_INI);
	if (globale.str_filename = '') OR (strcomp(p,strpcopy(q,globale.str_filename)) <> 0) then
		Windows.WritePrivateProfileString(INI_LAST_VALUES,NIL,'',FILE_INI);	// svuoto la sezione

	panel_function.Left := 0;panel_function.Width := panel_vars.Width;
	panel_function.Height := 0;
	for i := 1 to i_objs do begin
		xobj := xobjs(i);
//		if (xobj.tipo_oggetto in [xVARIABILE, xFORMULA]) then begin
		if (xobj.tipo_variabile in TV_OLD_VARIABILI + [TV_FORMULA]) then begin
			inc(i_robjs);new(robjs[i_robjs]);
//			case xobj.tipo_oggetto of
			case xobj.tipo_variabile of
//				xVARIABILE : begin
				TV_DB_FIELD, TV_PARAMETRO, TV_GROUP_EXPR_SQL, TV_SQL_SELECT_BEFORE_SQL, TV_SQL_SELECT_BEFORE_RUNTIME, TV_SQL_SELECT : begin
//					robjs[i_robjs]^ := Trunning_edit_type.xcreate(xxxVARIABILE, xobj.tipo_variabile, self, panel_vars, i, i_order_var);
					robjs[i_robjs]^ := Trunning_edit_type.xcreate(LABEL_OBJ, xobj.tipo_variabile, self, panel_vars, i, i_order_var);
					Windows.GetPrivateProfileString(INI_LAST_VALUES, strpcopy(q, robjs[i_robjs].str_nome), '', p, 100, FILE_INI);
					if (strlen(p) <> 0) then robjs[i_robjs].Text := strpas(p);
					inc(i_order_var)
				end;
//				xFORMULA : begin
				TV_FORMULA : begin
//					robjs[i_robjs]^ := Trunning_edit_type.xcreate(xxxFORMULA, TV_FORMULA, self,panel_function,i,i_order_formula);
					robjs[i_robjs]^ := Trunning_edit_type.xcreate(LABEL_OBJ, TV_FORMULA, self, panel_function, i, i_order_formula);
					inc(i_order_formula)
				end
			end
		end
	end;

	panel_function.Top := panel_vars.Height;
	txt_foglio.Caption := '(foglio: ' + inttostr(tm.i_lab_per_row*tm.i_lab_per_page) + ' etichette)';

	{$ifdef PROFESSIONALE} btn_ff.Caption := 'Emetti pagina'; {$endif}

//	GetPrivateProfileString(PROGRAM_NAME,INI_TOTAL_LABEL_PRINT,'0',p,strbufsize(p),FILE_INI);
	strdispose(p);strdispose(q)
end;     

procedure save_print_variable_value(str_name,str_value : string);
begin WritePrivateProfileString(INI_LAST_VALUES, str_name, str_value, FILE_INI) end;

procedure Trunning_window.FormClose(Sender: TObject;var Action: TCloseAction);
var i : integer;
begin
	Windows.WritePrivateProfileString(INI_LAST_VALUES,NIL,'',FILE_INI);	// svuoto la sezione
	if (globale.str_filename <> '') then
		WritePrivateProfileString(INI_LAST_VALUES,INI_LAST_FILENAME,globale.str_filename,FILE_INI);
	for i := 1 to i_robjs do
//		if (robjs[i].tipo_oggetto = xVARIABILE) then
		if (robjs[i].tipo_variabile in TV_OLD_VARIABILI) then
			save_print_variable_value(robjs[i].str_nome,robjs[i].Text);
	printer.free
end;

procedure Trunning_window.btn_printClick(Sender : TObject);
var
	k, lo_labs,lo_totale : integer;
	bo_stop : boolean;
begin
	i_num_labels.Text := togliblanks(i_num_labels.Text);
	if (i_num_labels.Text = '') then lo_labs := 1
	else begin
		Lval(i_num_labels.Text,lo_labs,k);
		if (k <> 0) then begin
			MessageBBox(handle,'Non ho capito quante etichette devo stampare',MBOX_CAPTION);
			exit
		end
	end;
	if NOT (get_values_variabili(TRUE) AND calcola_values(handle,TRUE,1,FALSE)) then exit;
	show_formula_values;
	k := i_last_label_printed;bo_stop := FALSE;
	lo_totale := pt_lo_totale_labels^;
	stampa(printer, handle, lo_labs, k, pt_lo_totale_labels^, TRUE, bo_stop, bo_ask_incorrect);
	if (lo_totale <> pt_lo_totale_labels^) then begin
		i_last_label_printed := k;
		if NOT tm.bo_print_pagina_completa AND (i_last_label_printed <> 0) then btn_ff.click	// sputo la stampa
	end;
	i_num_labels.SetFocus
end;

function Trunning_window.get_robj_index(i_obj : integer) : integer;
{ rende l'indice sul vettore ROBJS che contiene l'oggetto che referenzia OBJS[i];
  rende 0 se non lo trova }
var i : integer;
begin
	i := i_robjs;
	while (i > 0) AND (robjs[i].i_related_obj <> i_obj) do dec(i);
	get_robj_index := i
end;

procedure Trunning_window.btn_closeClick(Sender : TObject);
begin close end;

procedure Trunning_window.btn_ffClick(Sender : TObject);
begin
	btn_ff.Enabled := FALSE;
	if (i_last_label_printed <> 0) then begin
		try printer.EndDoc except end;
		i_last_label_printed := 0
	end
end;

procedure Trunning_window.FormCloseQuery(Sender: TObject;var CanClose: Boolean);
begin
	canclose := TRUE;
	if (i_last_label_printed <> 0) then
		case MessageBBox(handle,MBOX_MSG_FF_PRINT_QUESTION, MBOX_CAPTION,MB_QUESTION) of
			IDYES: try printer.EndDoc except end;
			IDNO,IDCANCEL: begin
				MessageBBox(handle,MBOX_MSG_CANT_EXIT_PRINT,MBOX_CAPTION);
				canclose := FALSE
			end
		end
end;

procedure Trunning_window.write_last_label_printed(i : integer);
begin
	i_last_label_printed_fisico := i;
	i_in_stampa.Text := inttostr(i);
	btn_reset_print.Enabled := tm.bo_print_pagina_completa AND (i <> 0);
	btn_ff.Enabled := tm.bo_print_pagina_completa AND (i <> 0);
	btn_print_sel.Enabled := (i = 0)
end;

function Trunning_window.read_last_label_printed : integer;
begin read_last_label_printed := i_last_label_printed_fisico end;

procedure TRunning_window.show_formula_values;
var
	i{,k} : i_obj_index_type;
	str_result : string;
	x : objs_type;
//	r : real;
begin
	for i := 1 to i_objs do begin
		x := xobjs(i);
//		if (x.tipo_oggetto = xFORMULA) then {with xobjs(i).aslabel do} begin
		if (x.tipo_variabile = TV_FORMULA) then {with xobjs(i).aslabel do} begin
			str_result := x.aslabel.str_print;
{			if (tipo_valore = VAL_NUMERO) then begin
				applica_formato_numerico;	// probabilmente questa istruzione è un optional
				str_result := str_print
//				str_result := puntatox(dbl_print_value,fnt_formato_numerico)
			end
			else str_result := xxxstr_print; }
			robjs[get_robj_index(i)].Text := str_result
{			str_result := str_print;
			if ((tipo_valore = VAL_NUMERO) AND xbo_puntato) then begin
				Rval(str_result,r,k);
				if (k = 0) then str_result := puntato(r) else str_result := 'ERRORE ****'
			end;
			robjs[get_robj_index(i)].Text := str_result }
		end
	end
end;	

procedure Trunning_window.btn_recalcolaClick(Sender : TObject);
begin
	get_values_variabili(FALSE);
	calcola_values(handle,FALSE,1,FALSE);
	show_formula_values
end;

procedure Trunning_window.btn_reset_printClick(Sender : TObject);
begin
	if (MessageBBox(handle,MBOX_MSG_RESET_PRINT_QUESTION,MBOX_CAPTION,MB_QUESTION) <> IDYES) then exit;        
	try printer.abort except end;
	i_last_label_printed := 0;
	MessageBBox(handle,'La coda di stampa è vuota',MBOX_CAPTION)
end;

procedure Trunning_window.FormDestroy(Sender : TObject);
begin while (i_robjs > 0) do begin robjs[i_robjs].free;dec(i_robjs) end end;

procedure Trunning_window.btn_previewClick(Sender : TObject);
begin
	if NOT get_values_variabili(FALSE) OR NOT calcola_values(handle,FALSE,1,FALSE) then exit;
	show_formula_values;
	dlg_preview := Tdlg_preview.xcreate(self);
	dlg_preview.showmodal;dlg_preview.release
end;

function TRunning_window.get_values_variabili(bo_printing : boolean) : boolean;
{ assegna il valore alle variabili;
  rende TRUE in caso di successo, FALSE altrimenti;
  if (BO_PRINTING) then emette messaggi d'errore }
var
	i : i_obj_index_type;
	j,k : integer;
	str_result : string;
	r : real;
begin
	get_values_variabili := FALSE;
//	for i := 1 to i_objs do with xobjs(i) do if (tipo_oggetto = xVARIABILE) then begin
	for i := 1 to i_objs do with xobjs(i) do if (tipo_variabile in TV_OLD_VARIABILI) then begin
		k := get_robj_index(i);
		str_result := togliblanks(robjs[k].Text);
		if (ca.tipo_valore = VAL_NUMERO) AND (pos('.',str_result) <> 0) then begin	
			MessageBBox(handle,
				'Per evitare equivoci tra il punto decimale e i punti delle migliaia, la variabile numerica <' + robjs[k].str_nome +
					'> non può contenere punti.', MBOX_CAPTION);
			robjs[k].SetFocus;exit
		end;
		RRval(str_result,r,@j); 
		if (ca.tipo_valore = VAL_NUMERO) AND (j <> 0) then begin
			MessageBBox(handle,'Il valore del campo <' + robjs[k].str_nome + '> deve essere numerico', MBOX_CAPTION);
			exit
		end;

//		strcpy(aslabel.lp_print,asciiz(str_result))
		aslabel.str_print := str_result;
{		if NOT aslabel.bo_text AND (r - my_round(r,RND_UNITA_ROUND,TRUE) = 0)
			then aslabel.str_print := puntato(r)
		else aslabel.str_print := str_result }
	end;
	get_values_variabili := TRUE
end;

procedure Trunning_window.btn_print_selClick(Sender : TObject);
var
//	i_page_from,i_page_to : i_ph_page_type;
	str_print_intervallo : string;
	i_num_copie : smallint;
	bo_email, bo_printer_changed, bo_apply_all_pages : boolean;
	str_target_filename, str_target_path, str_email, str_pagine_logiche : string;
	PDF : cl_PDF;
	target : report_target_type;
	intexp : cl_exec_expint_options;	// opzioni di esportazione del report
begin
	if (i_last_label_printed <> 0) then exit;
	PDF := cl_PDF.create(globale.PDF);
	intexp := cl_exec_expint_options.create;
	str_target_filename := globale.str_export_filename;
	try
		i_num_copie := 1;
//		i_page_from := 0;i_page_to := 0;
		str_print_intervallo := '';		// *** sarebbe da verificare questa assegnazione (prima si usavano I_PAGE_FROM e I_PAGE_TO
		bo_email := FALSE;	// per scrupolo
		if select_printer_proc(self, str_print_intervallo, {i_page_from, i_page_to,} {i_max_page}0, i_num_copie, str_pagine_logiche, 0, bo_printer_changed,
			target, str_target_filename, str_target_path, FALSE, PDF, intexp, bo_email, str_email, bo_apply_all_pages, NIL) OR bo_printer_changed
				then init_printer
	finally
		intexp.free;
		PDF.free
	end
end;

initialization
	galateo_initialization_debug('running_etichette')
finalization
	galateo_finalization_debug('running_etichette')
end.
