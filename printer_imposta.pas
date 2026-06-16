unit Printer_imposta;	//*

{$ifdef DLL} ***** {$endif}
{$I defines}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus,
	FBitBtn, Federico, validate,
	printers_DX, Gdich;

function imposta_printer_proc(father : TForm) : boolean;
{ if BO_PRINT_DAVVERO rende TRUE se schiaccia OK,
  else rende TRUE se viene modificata la stampante predefinita per il documento;
  le caselle I_PAGE_FROM e I_PAGE_TO vengono attivate solo if BO_STAMPA_DAVVERO
  e se IF i_page_from > 0 e i_page_to > 1 }

type
  Tdlg_imposta_printer = class(TForm)
    btn_ok: TFBitBtn;
    btn_cancel: TFBitBtn;
    txt_default_printer_01: TLabel;
    txt_default_printer_00: TLabel;
    panel_predefinita: TFPanel;
    txt_predefinita: TLabel;
	 str_default: TEdit;
	 cb_default_printer_00: TFCombo;
	 cb_default_printer_01: TFCombo;
	 txt_default_printer_cassetto_00: TLabel;
	 cb_default_printer_cassetto_00: TFCombo;
	 txt_default_printer_cassetto_01: TLabel;
	 cb_default_printer_cassetto_01: TFCombo;
	 cbx_forza_printer_report: TFCheckBox;
	 cbx_print_diretta: TFCheckBox;
	 txt_azione_default: TLabel;
	 cb_azione_default: TFCombo;
	 txt_default_printer_modalita: TLabel;
	 cb_default_printer_modalita: TFCombo;
    txt_printer_unknonw: TLabel;
    cb_printer_unknonw: TFCombo;
    cbx_silent_mode: TCheckBox;
    gbox_printer_size_MIN: TFGroupBox;
    txt_page_min_height: TMyLabel;
    txt_page_min_width: TMyLabel;
    i_min_page_height: TFEdit;
    i_min_page_width: TFEdit;
    gbox_printer_size_MAX: TFGroupBox;
    txt_page_max_height: TMyLabel;
    txt_page_max_width: TMyLabel;
    i_max_page_height: TFEdit;
    i_max_page_width: TFEdit;
	 procedure FormCreate(Sender : TObject);
	 procedure btn_okClick(Sender : TObject);
	 procedure btn_cancelClick(Sender : TObject);
	 procedure FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
	 procedure AAA_notify_modification(Sender : TObject);
	 procedure FormDestroy(Sender : TObject);
	 procedure cb_default_printer_00Exit(Sender : TObject);
	 procedure cb_default_printer_01Exit(Sender : TObject);
	 procedure cb_default_printer_modalitaClick(Sender : TObject);
	private
		bo_open_ok : boolean;
		pt_bo_modified : ^boolean;
		bo_something_modified : boolean;
		err_msg : cl_validation;
		cb_default_printers, cb_default_printer_cassetto : array[0..NUMERO_DEFAULT_PRINTERS-1] of TFCombo;
		function validate : boolean;
		procedure enable_ctrls;
  public
		constructor xcreate(father : TForm;var bo_modified : boolean);
			{ rende BO_MODIFIED = TRUE se viene modificata la stampante su cui stampare;
			  aggiorna direttamente il valore di CONTROLLO.STR_PRINTER }
  end;

implementation

uses Fcommons, FXStrings, FStrings, FMessage, FCtrls, 
	galateo_debug, myprinter, proc, pages, misure;

const
	MBOX_CAPTION = 'Selezione stampante';
	STAMPANTE_PREDEFINITA = '*** STAMPANTE PREDEFINITA ***';
//var str_stampante_predefinita : string;		// stampante predefinita di sistema

{$R *.DFM}

function imposta_printer_proc(father : TForm) : boolean;
// rende TRUE se è stata modificata la stampante selezionata
begin
	if NOT esiste_stampante(TRUE) then exit;
	var dlg: Tdlg_imposta_printer := Tdlg_imposta_printer.xCreate(father, result);
	dlg.ShowModal;dlg.Free;
	if result then begin
		set_global_modified;
//		if (globale.printer_default[0].str_printer = '') then printer.printerindex := -1 else printer.printerindex := printer.printers.indexof(globale.printer_default[0].str_printer)
	end
end;	

constructor Tdlg_imposta_printer.xcreate(father : TForm;var bo_modified : boolean);
begin
	pt_bo_modified := @bo_modified;
	bo_modified := FALSE;
	inherited create(father);
	if NOT bo_open_ok then abort
end;

procedure Tdlg_imposta_printer.FormCreate(Sender : TObject);
var i : byte;	//*
begin
	try
		caption := MBOX_CAPTION;
		err_msg := validation_create(MBOX_CAPTION);

		if (printer.printers.Count = 0) then begin
			MessageBBox(handle,'Please, abbi la cortesia di installare almeno una stampante ' +
				'prima di pensare di scegliere quella che dovrà stampare il tuo grazioso documento', MBOX_CAPTION);
			abort
		end;
		str_default.Text := str_stampante_predefinita;
		cb_default_printer_00.Items.assign(printer.printers);
		cb_default_printer_00.Items.insert(0, STAMPANTE_PREDEFINITA);
		cb_default_printer_01.Items.assign(cb_default_printer_00.Items);

		for i := 0 to NUMERO_DEFAULT_PRINTERS-1 do begin
			cb_default_printers[i] := FindComponent('cb_default_printer_' + zeri(i,2)) as TFCombo;
			cb_default_printer_cassetto[i] := FindComponent('cb_default_printer_cassetto_' + zeri(i,2)) as TFCombo;
			{$ifdef DEBUG} assert((cb_default_printers[i] <> NIL) AND (cb_default_printer_cassetto[i] <> NIL), 'DJHW 9310'); {$endif}
			if (globale.printer_default[i].str_printer <> '') then begin
				cb_default_printers[i].Text := globale.printer_default[i].str_printer;
				fill_info_cassetto_carta(globale.printer_default[i].str_printer, cb_default_printer_cassetto[i]);
				cb_select(cb_default_printer_cassetto[i], globale.printer_default[i].str_cassetto)
			end
		end;
{		cb_default_printer_00.Text := globale.printer_default[0].str_printer;
		cb_default_printer_01.Text := globale.printer_default[1].str_printer;
		if (globale.xstr_printer <> '') then begin
			fill_info_cassetto_carta(globale.xstr_printer, cb_default_printer_cassetto_00);
			cb_select(cb_default_printer_cassetto_00, globale.str_cassetto_carta_main)
		end;
		if (globale.str_printer_alt <> '') then begin
			fill_info_cassetto_carta(globale.str_printer_alt, cb_default_printer_cassetto_01);
			cb_select(cb_default_printer_cassetto_01, globale.str_cassetto_carta_alt)
		end;	}

		cbx_forza_printer_report.Checked := globale.bo_usa_sempre_printer_report;
		cbx_print_diretta.Checked := (globale.print_diretta = PDS_DIRETTA);

		cb_default_printer_modalita.Items.Clear;
		for i := 0 to byte(high(default_printer_selection_type)) do
			cb_default_printer_modalita.Items.Add(DEFAULT_PRINTER_SELECTION_DESCRIZIONE[default_printer_selection_type(i)]);
		cb_default_printer_modalita.ItemIndex := byte(globale.modalita_selezione_default_printer);

		for i := 0 to byte(high(azione_printer_unknown_type)) do cb_printer_unknonw.Items.Add(APUT_DESCRIZIONE[azione_printer_unknown_type(i)]);
		cb_printer_unknonw.ItemIndex := byte(globale.azione_printer_unknown);

		for i := 0 to byte(high(azione_opening_report_type)) do cb_azione_default.Items.Add(AORT_OPZIONI_DESCRIZIONE[azione_opening_report_type(i)]);
		cb_azione_default.ItemIndex := byte(globale.azione_opening_report_phisical);

		cbx_silent_mode.Checked := globale.bo_silent_mode;

		i_min_page_height.set_Asinteger(globale.printer_size_constraints.i_min_height_mm);
		i_min_page_width.set_Asinteger(globale.printer_size_constraints.i_min_width_mm);
		i_max_page_height.set_Asinteger(globale.printer_size_constraints.i_max_height_mm);
		i_max_page_width.set_Asinteger(globale.printer_size_constraints.i_max_width_mm);

		enable_ctrls;
		{$ifdef DEBUG} check_components(self); {$endif DEBUG}

		bo_open_ok := TRUE
	except
		bo_open_ok := FALSE
	end
end;

procedure Tdlg_imposta_printer.FormDestroy(Sender : TObject);
begin
	validation_free(err_msg)
end;

function Tdlg_imposta_printer.validate : boolean;
// rende TRUE se tutto OK
label fine;
var printer_size_constraints : printer_size_constraints_data_type;
begin
	if NOT bo_something_modified then goto fine;
	cb_default_printer_00.Text := togliblanks(cb_default_printer_00.Text);
	cb_default_printer_01.Text := togliblanks(cb_default_printer_01.Text);

	if (cb_default_printer_modalita.ItemIndex = byte(DPST_GALATEO)) then begin
		if (cb_default_printer_00.Text = '') then validation_add(err_msg, 'Specifica una stampante default', TRUE);
{		if (cb_default_printer_01.Text <> '') AND (cb_default_printer_00.Text = '') then
			then validation_add(err_msg, 'Impossibile indicare la stampante alternativa senza aver indicato la principale', TRUE); }

		with cb_default_printer_00 do
			if (Text <> '') AND (items.indexof(Text) = -1)
				then validation_add(err_msg, 'Stampante default <' + text + '> non riconosciuta', FALSE);
		with cb_default_printer_01 do
			if (Text <> '') AND (items.indexof(Text) = -1)
				then validation_add(err_msg, 'Stampante alternativa <' + text + '> non riconosciuta', FALSE)
	end;

	printer_size_constraints.i_min_height_mm := i_min_page_height.get_Asinteger(FALSE);
	printer_size_constraints.i_min_width_mm := i_min_page_width.get_Asinteger(FALSE);
	printer_size_constraints.i_max_height_mm := i_max_page_height.get_Asinteger(FALSE);
	printer_size_constraints.i_max_width_mm := i_max_page_width.get_Asinteger(FALSE);
	check_printer_size_constraints(self, printer_size_constraints, err_msg);

fine:
	result := validation_verify(err_msg, self, '')
end;

procedure Tdlg_imposta_printer.btn_okClick(Sender : TObject);
begin
	btn_ok.SetFocus;
	if bo_something_modified then begin
		if NOT validate then exit;
		globale.modalita_selezione_default_printer := default_printer_selection_type(cb_default_printer_modalita.Itemindex);

		for var i : smallint := 0 to NUMERO_DEFAULT_PRINTERS-1 do begin
//			globale.printer_default[i].str_printer := uppercase(cb_default_printers[i].Text);
			globale.printer_default[i].str_printer := cb_default_printers[i].Text;
			if (globale.printer_default[i].str_printer = STAMPANTE_PREDEFINITA)
				then globale.printer_default[i].str_printer := '';
			globale.printer_default[i].str_cassetto := cb_default_printer_cassetto[i].Text
		end;

//		globale.xstr_printer := uppercase(cb_default_printer_00.Text);
//		if (globale.xstr_printer = STAMPANTE_PREDEFINITA) then globale.xstr_printer := '';
//		globale.str_printer_alt := uppercase(cb_default_printer_01.Text);
//		if (globale.str_printer_alt = STAMPANTE_PREDEFINITA) then globale.str_printer_alt := '';
//		globale.str_cassetto_carta_main := cb_default_printer_cassetto_00.Text;
//		globale.str_cassetto_carta_alt := cb_default_printer_cassetto_01.Text;

		globale.bo_usa_sempre_printer_report := cbx_forza_printer_report.Checked;
		if cbx_print_diretta.Checked then globale.print_diretta := PDS_DIRETTA
		else globale.print_diretta := PDS_DIALOG;
		globale.azione_printer_unknown := azione_printer_unknown_type(cb_printer_unknonw.ItemIndex);
		globale.azione_opening_report_phisical := azione_opening_report_type(cb_azione_default.ItemIndex);
		globale.bo_silent_mode := cbx_silent_mode.Checked;

		globale.printer_size_constraints.i_min_height_mm := i_min_page_height.get_Asinteger(FALSE);
		globale.printer_size_constraints.i_min_width_mm := i_min_page_width.get_Asinteger(FALSE);
		globale.printer_size_constraints.i_max_height_mm := i_max_page_height.get_Asinteger(FALSE);
		globale.printer_size_constraints.i_max_width_mm := i_max_page_width.get_Asinteger(FALSE);

		pt_bo_modified^ := TRUE		// rende TRUE
	end;
	close
end;

procedure Tdlg_imposta_printer.btn_cancelClick(Sender : TObject); begin close end;
procedure Tdlg_imposta_printer.FormKeyDown(Sender: TObject;var Key: Word;Shift: TShiftState); begin key_button(key, VK_F9, btn_ok, TRUE) end;
procedure Tdlg_imposta_printer.cb_default_printer_00Exit(Sender : TObject); begin fill_info_cassetto_carta(cb_default_printer_00.Text, cb_default_printer_cassetto_00) end;
procedure Tdlg_imposta_printer.cb_default_printer_01Exit(Sender : TObject); begin fill_info_cassetto_carta(cb_default_printer_01.Text, cb_default_printer_cassetto_01) end;
procedure Tdlg_imposta_printer.cb_default_printer_modalitaClick(Sender : TObject); begin enable_ctrls end;

procedure Tdlg_imposta_printer.AAA_notify_modification(Sender : TObject);
begin
	bo_something_modified := TRUE;
	enable_ctrls
end;

procedure Tdlg_imposta_printer.enable_ctrls;
begin
	var bo := (cb_default_printer_modalita.ItemIndex = byte(DPST_GALATEO));
	enable_FC(txt_default_printer_00, bo);
	enable_FC(txt_default_printer_01, bo);
	enable_FC(txt_default_printer_cassetto_00, bo);
	enable_FC(txt_default_printer_cassetto_01, bo);
	enable_FC(txt_printer_unknonw, cb_default_printer_modalita.ItemIndex = byte(DPST_GALATEO));
	cbx_print_diretta.Enabled := NOT cbx_silent_mode.Checked
end;

initialization
	galateo_initialization_debug('printer_imposta');
{$ifdef GALATEO}
	if esiste_stampante(FALSE) then str_stampante_predefinita := printer.printers[printer.printerindex]
{$endif}
finalization
	galateo_finalization_debug('printer_imposta')
end.
