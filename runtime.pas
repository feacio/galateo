unit runtime;		//* dialog per la richiesta di parametri a RUNTIME

{$I defines}

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls, Buttons, Dialogs, Menus,
	JvExControls, JvSpeedButton,
	Fcommons, Federico, FBitBtn, validate, runtime_proc;

type
  Tdlg_runtime = class(TForm)
	 panel_bottoni: TFPanel;
	 btn_procedi: TFBitBtn;
	 btn_cancel: TFBitBtn;
	 btn_default: TFBitBtn;
	 sb: TScrollBox;
	 cbx_forza: TFCheckBox;
	 btn_close_report: TFBitBtn;
	 cbx_close_after: TFCheckBox;
	 btn_save_window_pos_size: TJvSpeedButton;
	 popup_pos_size: TPopupMenu;
	 itm_window_save: TMenuItem;
	 itm_window_reload: TMenuItem;
	 cbx_execute_scripts: TFCheckBox;
    txt_runtime_help: TMyLabel;
	 procedure FormCreate(Sender : TObject);
	 procedure FormDestroy(Sender : TObject);
	 procedure btn_procediClick(Sender : TObject);
	 procedure btn_cancelClick(Sender : TObject);
	 procedure FormCloseQuery(Sender : TObject;var CanClose : Boolean);
	 procedure FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
	 procedure btn_defaultClick(Sender : TObject);
	 procedure cbx_forzaClick(Sender : TObject);
	 procedure btn_close_reportClick(Sender : TObject);
	 procedure cbx_close_afterClick(Sender : TObject);
	 procedure FormActivate(Sender : TObject);
	 procedure itm_window_saveClick(Sender : TObject);
	 procedure itm_window_reloadClick(Sender : TObject);
		private
			bo_started, bo_dont_open : boolean;
			pt_i_result : smallint_punt;
		private
			RPT : runtime_parms_type;
			bo_saving, bo_saved, bo_something_modified : boolean;
//			EV : cl_ELE_varianti_prj;
			fields : cl_runtime_field_elenco;
//			str_valori_originali, str_valori_originali_identici : string;
			str_valori_originali : array of string;		// in caso di valori tradotti (codice/descrizione) contiene il codice
			pt_bo_modified : boolean_punt;
			pt_bo_execute_scripts : boolean_punt;
			bo_first_window, bo_last_window, bo_on_exit : boolean;
			pt_bo_dont_close_after : boolean_punt;
			lo_print_style : integer;	// tipo di stampa che deve essere eseguita; serve solo a titolo informativo
			rect_default : TRect;
			function create_fields : boolean;
			procedure save(bo_close : boolean);
			procedure on_read_proc(sender : TObject);
			procedure on_exit_proc(sender : TObject);
			procedure on_enter_proc(sender : TObject);
			procedure on_closeup_proc(sender : TObject);
			procedure enable_ctrls;
			function get_modified : boolean;
			function IO_window_pos_size(bo_save : boolean;bo_reset_values : boolean = FALSE) : boolean;
			constructor xcreate(father : TForm;RPT : runtime_parms_type;
				lo_print_style : integer;
				var bo_modified, bo_execute_scripts  : boolean;bo_first_window, bo_last_window, bo_on_exit : boolean;
				var bo_dont_close_after : boolean;var i_result : smallint);
  end;

function ask_runtime_parms(father : TForm;lo_print_style : integer;bo_on_exit : boolean;
	var bo_dont_close_after : boolean;var bo_execute_scripts : boolean) : smallint;	// rende una delle macro ARP_xxxx
//function runtime_parms_proc(father : TForm;RPT : runtime_parms_type) : smallint;

const
	ARP_BUILD_REPORT = +1;	// (ri)genera il report
	ARP_NOTHING = 0;			// non fa nulla; se ho già un'anteprima aperta, la lascia aperta
	ARP_CLOSE_REPORT = -1;	// chiude il report; se ho già un'anteprima aperta, la chiude

implementation

{$R *.dfm}

uses FAssert, FXStrings, FStrings, FErrMsg, FCtrls, Fdata, FSQLsoft, FMessage, FRegistry, FTrans, FSystem_base, FSystem, FSystem_ext, domanda_multipla,
	galateo_debug, Gdich, proc, labels, objects, pages, functions, sezione;

const
	MBOX_CAPTION = 'Parametri di stampa';

function runtime_parms_proc(father : TForm;RPT : runtime_parms_type;
	lo_print_style : integer;
	var bo_modified : boolean;		// valore sia INPUT che OUTPUT: consente di passare il valore tra le varie windows
	var bo_execute_scripts : boolean;
	bo_first_window, bo_last_window, bo_on_exit : boolean;
	var bo_dont_close_after : boolean) : smallint;
// rende 0 se non fa nulla, +1 se ha apportato modifiche, -1 se si vuole chiudere la stampa
begin
	result := ARP_NOTHING;
	if (RPT = NIL) AND NOT (bo_first_window AND (globale.str_runtime_help <> '')) then begin
//		MessageBBox(father.handle, 'Il progetto non possiede parametri da domandare a runtime', MBOX_CAPTION);
		exit
	end;

	if get_service_mode OR bo_silent_mode then begin result := ARP_BUILD_REPORT;exit end;	// non ha senso chiedere parametri se non è una esecuzione interattiva

	var dlg := Tdlg_runtime.xCreate(father, RPT, lo_print_style, bo_modified, bo_execute_scripts, bo_first_window, bo_last_window, bo_on_exit, bo_dont_close_after, result);
	try
		if (father <> NIL) then father.Visible := FALSE;	// nascondo il father per evitare la pluralità di finestre
		dlg.ShowModal;dlg.Free
	finally
		if (father <> NIL) then father.Visible := TRUE
	end
end;

constructor Tdlg_runtime.xcreate(father: TForm;RPT : runtime_parms_type;lo_print_style : integer;
	var bo_modified, bo_execute_scripts : boolean;bo_first_window, bo_last_window, bo_on_exit : boolean;
	var bo_dont_close_after : boolean;var i_result : smallint);
begin
	self.RPT := RPT;
	pt_i_result := @i_result;i_result := ARP_NOTHING;
	pt_bo_modified := @bo_modified;
	pt_bo_execute_scripts := @bo_execute_scripts;
	self.bo_first_window := bo_first_window;
	self.bo_last_window := bo_last_window;
	self.bo_on_exit := bo_on_exit;
	self.pt_bo_dont_close_after := @bo_dont_close_after;
	self.lo_print_style := lo_print_style;
	inherited create(father);
	if bo_dont_open then abort;
	bo_started := TRUE
end;

procedure Tdlg_runtime.FormCreate(Sender : TObject);
begin
	try
		Caption := MBOX_CAPTION + ' [' + globale.str_filename + ']';
		SendWindowToMonitor(self, globale.i_active_monitor, MFTM_CENTER);

		txt_runtime_help.Visible := (globale.str_runtime_help <> '');
		if txt_runtime_help.Visible then begin
//			txt_runtime_help.Caption := globale.str_runtime_help;
			var i_max_height : smallint := txt_runtime_help.Height * 5;
			globale.runtime_help_font.apply_to(txt_runtime_help);
			set_auto_label_height(txt_runtime_help, globale.str_runtime_help, i_max_height);
			txt_runtime_help.Hint := globale.str_runtime_help;txt_runtime_help.ShowHint := TRUE;
		end;

		btn_close_report.Visible := NOT globale.bo_first_print;
		btn_cancel.Visible := NOT btn_close_report.Visible OR (lo_print_style <> GAL_POPT_DIRECTLY_EXECUTE);
		btn_save_window_pos_size.Visible := globale.bo_allow_saving_runtime_pos;
		if btn_close_report.Visible AND NOT btn_cancel.Visible then begin
			btn_cancel.Cancel := FALSE;
			btn_close_report.Cancel := TRUE
		end;
		cbx_forza.Visible := NOT globale.bo_first_print AND NOT bo_on_exit;

		cbx_execute_scripts.Visible := NOT globale.bo_first_print AND (globale.SQL_reexecute_scripts <> SQLRSO_ALWAYS_REEXECUTE);
		cbx_execute_scripts.Enabled := (globale.SQL_reexecute_scripts in [SQLRSO_ALLOW_SKIP, SQLRSO_DEFAULT_SKIP]);
		cbx_execute_scripts.Checked := (globale.SQL_reexecute_scripts in [SQLRSO_ALWAYS_REEXECUTE, SQLRSO_ALLOW_SKIP]);
		if NOT cbx_execute_scripts.Checked then cbx_execute_scripts.Color := clYellow;

		cbx_close_after.Visible := (globale.azione_after_print <> AAPT_NOTHING);
		cbx_close_after.Checked := NOT pt_bo_dont_close_after^;

		if NOT (cbx_forza.Visible OR cbx_close_after.Visible) then panel_bottoni.Height := btn_procedi.Top * 2 + btn_procedi.Height;

		setLength(str_valori_originali, length(RPT));
		for var i : smallint := 0 to high(RPT) do str_valori_originali[i] := xobjs(RPT[i].i_object, RPT[i].i_logical_page).aslabel.str_print;
		if NOT create_fields then abort;

		enable_ctrls
	except
		error_msg(self, '', MBOX_CAPTION);
		bo_dont_open := TRUE
	end
end;

procedure Tdlg_runtime.FormActivate(Sender : TObject);
begin
	rect_default.Left := left;rect_default.Top := Top;
	rect_default.Right := Width;rect_default.Bottom := Height;
	IO_window_pos_size(FALSE)
end;

procedure Tdlg_runtime.FormDestroy(Sender : TObject);
begin
	if (fields <> NIL) then begin fields.free;fields := NIL end;
//	if (EV <> NIL) then begin EV.free;EV := NIL end;
//	wx.register_close_window(self)
end;

procedure Tdlg_runtime.itm_window_saveClick(Sender : TObject);
begin
	IO_window_pos_size(TRUE);
	MessageBBox(handle, 'Posizione salvata', MBOX_CAPTION)
end;

procedure Tdlg_runtime.itm_window_reloadClick(Sender : TObject);
begin
	IO_window_pos_size(TRUE, TRUE);
	Left := rect_default.Left;Top := rect_default.Top;
	Width := rect_default.Right;Height := rect_default.Bottom
end;

procedure Tdlg_runtime.cbx_close_afterClick(Sender : TObject);
begin
	if bo_started then
//		write_registry(str_alias,str_argomento,str_key : string;bo_value : boolean) : boolean; overload;
//		get_registry_boolean(, {bo_default}FALSE);
		write_registry_string(HKEY_CURRENT_USER, GALATEO_REGISTRY_BASE, REGISTRY_DONT_CLOSE_AFTER, bool2SQL(NOT cbx_close_after.Checked))
end;

function Tdlg_runtime.create_fields : boolean;
// crea i fields; rende TRUE in caso di successo, FALSE altrimenti
begin
	try
		fields := cl_runtime_field_elenco.create(self, RPT);
		if NOT fields.set_extra_fields_ctrls(self, on_read_proc, on_closeup_proc, on_enter_proc, on_exit_proc, NIL, sb) then abort;

		if globale.bo_first_print then fields.reset_values;
		fields.IO(FALSE);
		result := TRUE
	except
		result := FALSE;
		error_msg(self, '', MBOX_CAPTION)
	end
end;

procedure Tdlg_runtime.FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
begin
	case key of
		VK_ESCAPE : begin Key := 0;close end;
		VK_F9 : if btn_procedi.Enabled then begin Key := 0;btn_procedi.SetFocus;save(TRUE) end
	end;
	if (key <> 0) then inherited
end;

procedure Tdlg_runtime.btn_cancelClick(Sender : TObject);
begin
	for var i : smallint := 0 to high(RPT) do xobjs(RPT[i].i_object, RPT[i].i_logical_page).aslabel.str_print := str_valori_originali[i];
	pt_bo_dont_close_after^ := FALSE;
	close
end;

procedure Tdlg_runtime.btn_procediClick(Sender : TObject); begin save(TRUE) end;
procedure Tdlg_runtime.cbx_forzaClick(Sender : TObject); begin enable_ctrls end;

procedure Tdlg_runtime.btn_close_reportClick(Sender : TObject);
begin
	pt_i_result^ := ARP_CLOSE_REPORT;bo_saved := TRUE;
	pt_bo_dont_close_after^ := FALSE;
	close
end;

procedure Tdlg_runtime.FormCloseQuery(Sender: TObject;var CanClose: Boolean);
begin
//	if NOT bo_saved AND (bo_something_modified OR pt_i_result^) {AND bo_can_save} then
//		canclose := (MessageBBox(handle,EXIT_WITHOUT_SAVING,MBOX_CAPTION,MB_QUESTION {OR MB_DEFBUTTON2}) = IDYES)
//	else canclose := TRUE
	canclose := TRUE	// non faccio domande (che tutto sommato sono senza grande senso)
end;

function Tdlg_runtime.IO_window_pos_size(bo_save : boolean;bo_reset_values : boolean = FALSE) : boolean;
// salva/legge le impostazioni (size/pos) della finestra; rende TRUE in caso di successo, FALSE altrimenti
begin
	if globale.bo_allow_saving_runtime_pos then
		IO_form_size_and_pos(self, bo_save, 'galateo-runt-' + globale.str_filename, bo_reset_values);
	result := TRUE
end;

procedure Tdlg_runtime.save(bo_close : boolean);
begin
	if bo_saving OR NOT btn_procedi.Enabled then exit;
	var err_msg : cl_validation := validation_create(globale.str_filename);
	try
		bo_saving := TRUE;
		var bo_modified := pt_bo_modified^ OR cbx_forza.Checked OR get_modified;
		pt_bo_execute_scripts^ := cbx_execute_scripts.Checked;

		for var i : smallint := 0 to high(RPT) do begin
			var lab : cl_label := xobjs(RPT[i].i_object, RPT[i].i_logical_page).aslabel;
//			str_caption := coalesce(lab.str_runtime_caption, lab.Caption);
			var str_caption := coalesce(ifs(lab.str_runtime_question, '[' + lab.str_runtime_question + ']'), lab.xstr_runtime_caption, lab.Caption);

			var str_value := lab.str_print;
			var bo_blank_answer := FALSE;
			case lab.ca.tipo_valore of
				VAL_NUMERO : bo_blank_answer := (str_value = '0') AND NOT fields.field(i).valid_value(str_value);	// 0 è la traduzione numerica di BLANK; se 0 non è un valore valido, BLANK non è ammesso
				VAL_TESTO : bo_blank_answer := (str_value = '');
//				VAL_BOOLEAN : ;
//				VAL_BOH : ;
				{$ifdef DEBUG} else assert(FALSE, 'DKWJ 3919') {$endif DEBUG}
			end;

			if NOT bo_blank_answer AND (lab.rtq = RTQ_SINGLE_SELECT) AND lab.bo_runtime_answer_in_valori_suggeriti AND
				NOT fields.field(i).valid_value(str_value) AND (str_value <> lab.str_runtime_blank_answer)	// controllo aggiunto 2021-06-21
					then validation_add(err_msg, str_caption + ': valore non ammesso', TRUE);

			if bo_blank_answer then begin
				if NOT lab.bo_runtime_answer_can_be_blank
					then validation_add(err_msg, str_caption + ': è necessario specificare un valore', TRUE);
				lab.str_print := lab.str_runtime_blank_answer
			end;
{			if (lab.rtq = RTQ_MULTI_SELECT) then begin
//				lab.str_print := delimited_to_inapiciata(lab.str_print)
				lab.str_print := fields.field(i).translate_descrizioni_2_codici(lab.str_print, lab.RTQ_apix)
			end;	}
			if (lab.rtq = RTQ_MULTI_SELECT) then lab.str_print := inapicia(lab.str_print, lab.RTQ_apix);
			if (lab.i_runtime_min_length <> 0) AND (length(lab.str_print) < lab.i_runtime_min_length)
				then validation_add(err_msg, str_caption + ': lunghezza errata (minimo ' + lab.i_runtime_min_length.ToString +  ' caratteri)', TRUE);
			if (lab.runtime_tipodato = RTT_DATA) AND (lab.str_print <> '') then begin
//				str_value := lab.str_print;
				sostituisci(str_value, ' ', '');
				if lab.bo_runtime_answer_can_be_blank AND (str_value = '//') then lab.str_print := ''
				else begin
					var dt : TDatetime := 0;
					if (str_value <> '//') then dt := str2dt(str_value);
					if (dt = 0) then validation_add(err_msg,
						str_caption + ifs(str_value = '//', 'data obbligatoria non specificata', ': data non valida (' + lab.str_print + ')'), TRUE)
					else lab.str_print := asstring_data(dt, '/')		// formato DD/MM/YYYY non inapiciato
				end
			end
		end;

		if NOT validation_verify(err_msg, self, MBOX_CAPTION) then exit;

		pt_bo_modified^ := bo_modified;
		pt_i_result^ := ARP_BUILD_REPORT;
		bo_saved := TRUE;
		if bo_close then begin
//			IO_window_pos_size(TRUE);
			close
		end
	finally
		if (err_msg <> NIL) then validation_free(err_msg);
		bo_saving := FALSE
	end
end;

procedure Tdlg_runtime.on_read_proc(sender : TObject);
begin
	if NOT bo_started then exit;
	bo_something_modified := TRUE;
	{$ifdef DEBUG} assert(sender <> NIL, 'DJSH 2938'); {$endif}		// necessario, altrimenti la STANDARD_READ_PROC non funge
//	if (sender <> NIL) then fields.standard_read_proc(sender);
	if (sender <> NIL) then fields.standard_event_proc(sender, RSE_ON_UPDATE);
	enable_ctrls
end;

procedure Tdlg_runtime.on_enter_proc(sender : TObject);
begin
	if (sender <> NIL) then fields.standard_event_proc(sender, RSE_ON_ENTER)
end;

procedure Tdlg_runtime.on_exit_proc(sender : TObject);
begin
	if (sender <> NIL) then fields.standard_event_proc(sender, RSE_ON_EXIT)
end;

procedure Tdlg_runtime.on_closeup_proc(sender : TObject);
begin
	if (sender <> NIL) then fields.standard_event_proc(sender, RSE_ON_CLOSEUP)
end;

function Tdlg_runtime.get_modified : boolean;
// rende TRUE se è stato modificato un qualunque valore sulla presente finestra
begin
	result := bo_something_modified;
	if result then exit;	// inutile proseguire oltre
	for var i : smallint := 0 to high(str_valori_originali) do begin
		if (str_valori_originali[i] <> xobjs(RPT[i].i_object, RPT[i].i_logical_page).aslabel.str_print) then begin
			result := TRUE;exit
		end
	end
end;

procedure Tdlg_runtime.enable_ctrls;
begin
	var bo_modified := get_modified;
	btn_procedi.Enabled := cbx_forza.Checked OR globale.bo_first_print OR bo_modified OR pt_bo_modified^ OR NOT bo_last_window;
	cbx_forza.Enabled := NOT bo_modified;
	cbx_execute_scripts.Enabled := cbx_forza.Checked
end;

procedure Tdlg_runtime.btn_defaultClick(Sender : TObject);
begin
	fields.reset_values;
	fields.IO(FALSE);
	bo_something_modified := TRUE;enable_ctrls
end;

function ask_runtime_parms(father : TForm;lo_print_style : integer;bo_on_exit : boolean;var bo_dont_close_after : boolean;var bo_execute_scripts : boolean) : smallint;
{ domanda i parametri che devono essere chiesti a RUNTIME;
  rende 0 se non fa nulla, +1 se ha apportato modifiche, -1 se si vuole chiudere la stampa }

	procedure init_parms(i_parameter_window : smallint);
	{ fondamentale; non tanto la prima volta, ma certamente gli eventuali RELOADs;
	  non rileggo i valori VAR_SQL_SELECT_BEFORE_START, perchè se sto eseguendo una operazione di reload e
	  l'utente dovesse annullare l'operazione di reload, non saprei come ripristinare i valori originali;
	  l'operazione riguarda i soli parametri che appartengono ai gruppi che devono essere mostrati su I_PARAMETER_WINDOW;
	  se I_PARAMETER_WINDOW = 0, vengono riassegnati TUTTI i parametri }
	var str_value, str_default : string;
	begin
		for var i_logical_page : logical_page_type := 1 to get_ultima_pagina_logica do begin
			for var i_obj : obj_index_type := 1 to i_objs(i_logical_page) do begin
				var xobj : objs_type := xobjs(i_obj, i_logical_page);
//				if (xobj.get_tipo <> VARIABILE) then continue;
				if (xobj.ca.tipo_oggetto <> LABEL_OBJ) then continue;

				var lab : cl_label := xobj.aslabel;
//				if (lab.tipovar <> TV_PARAMETRO)
				if (xobj.ca.tipo_variabile <> TV_PARAMETRO)
//					OR NOT lab.get_parm_esempio_runtime_running		fino 2011-05-23
					OR NOT lab.bo_ask_runtime	// dal 2011-05-23
						then continue;

				if (lab.i_runtime_groupbox > high(globale.runtime_gboxes)) then lab.i_runtime_groupbox := 0;	// per cautela
				if (i_parameter_window <> 0) AND (globale.runtime_gboxes[lab.i_runtime_groupbox].i_parameter_window <> i_parameter_window) then continue;

				str_value := '';
//				s := lab.str_esempio_value;
//				s := xobj.str_esempio_value;
//				str_default := coalesce(ifs(globale.bo_debug, lab.str_runtime_default_debug), lab.str_runtime_default);
				str_default := lab.get_runtime_default;
				if (str_default <> '') then try
					if lab.bo_runtime_default_is_SQL then begin
						sections_1B(1, i_logical_page).interpreta_string(str_default, {bo_stampa_vera}TRUE, {bo_check_errors}FALSE);
						str_value := get_string_where(sections_1B(1, i_logical_page).qry.DatabaseName, str_default);
						{$ifdef DLL}
							lab.bo_runtime_default_is_SQL := FALSE;
//							lab.str_esempio_value := s
//							xobj.ca.str_esempio_value := str_value			*** eliminato 2012-09-01 perchè inutile (operazione già eseguita sotto)
						{$endif}
					end
					else if lab.bo_runtime_default_is_formula then begin		// ELSE dal 2009-10-22
//						str_value := '';
//						if NOT translate_formula(lab.str_esempio_value, s, {bo_test}FALSE, lab.tipo_valore, xobj) then abort
//						if NOT translate_formula(xobj.str_esempio_value, s, {bo_test}FALSE, xobj.ca.tipo_valore, xobj) then abort
						if NOT translate_formula(str_default, str_value, {bo_test}FALSE, xobj.ca.tipo_valore, xobj) then abort
					end
					else str_value := str_default
				except
					error_msg(father, 'Errore durante l''interpretazione del valore default per l''oggetto ' + xobj.get_debug_caption + ACAPO2 + str_value, MBOX_CAPTION);
					raise
				end;
				lab.str_print := str_value;
				{$ifdef DLL} xobj.ca.str_esempio_value := str_value {$endif}		// solo if DLL, altrimenti cambio il valore dell'oggetto; ciò significa abbandonare la possibilità di eseguire delle stampe REALI dall'interno dell'editor, ed affidarsi esclusivamente a GALRUN
			end
		end
	end;

	procedure reset_objects;
	{ fondamentale; non tanto la prima volta, ma certamente gli eventuali RELOADs;
	  non rileggo i valori VAR_SQL_SELECT_BEFORE_START, perchè se sto eseguendo una operazione di reload e
	  l'utente dovesse annullare l'operazione di reload, non saprei come ripristinare i valori originali;
	  non rileggo i valori PARAMETRO perchè semplicemente non devono essere riletti;
	  l'esecuzione della procedura è necessaria anche se nella ordinaria procedura di stampa viene eseguito un comando simile }
	begin
		for var i_logical_page : logical_page_type := 1 to get_ultima_pagina_logica do begin
			for var i : obj_index_type := 1 to i_objs(i_logical_page) do begin
				var xobj : objs_type := xobjs(i, i_logical_page);
//				if (xobj.get_tipo <> VARIABILE) then continue;
{				var tipo : object_type := xobj.get_tipo;
				if NOT (tipo in TESTI_OBJS) then continue;
				var lab : cl_label := xobj.aslabel;
				if NOT ((tipo = VARIABILE) AND (lab.tipovar in TIPIVAR_COSTANTI)) then lab.xreset_print_value }
				if (xobj.ca.tipo_oggetto = LABEL_OBJ) AND NOT (xobj.ca.tipo_variabile in TV_COSTANTI) then xobj.aslabel.reset_print_value
			end
		end
	end;

begin
	var handle : hwnd := get_handle(father);
//	if globale.bo_first_print then init_objects;
	var bo_modified := FALSE;
	var bo_rebuild := (globale.bo_first_print OR bo_on_exit);

	var sow : byteset := [];	// Set Of Windows numeri delle finestre di richiesta parametri; 1-based -- raccolgo il numero di tutte le finestre che POSSONO essere mostrate
	for var i : smallint := 0 to high(globale.runtime_gboxes) do
		if (bo_on_exit = globale.runtime_gboxes[i].bo_ask_on_exit)		// solo le finestre che devono essere mostrate in questa occasione
			then sow := sow + [globale.runtime_gboxes[i].i_parameter_window];

	var i_window : smallint := 0;
	var bo_first_window := TRUE;
	globale.bo_exists_runtime_parms := FALSE;
	while (sow <> []) do begin
		inc(i_window);
		if NOT (i_window in sow) then continue;
		sow := sow - [i_window];
		var RPT : runtime_parms_type := NIL;
		if globale.bo_first_print then init_parms(i_window);

		// carico sulla struttura RPT i parametri che devono essere letti
		for var i_logical_page : logical_page_type := 1 to get_ultima_pagina_logica do begin
			for var i : obj_index_type := 1 to i_objs(i_logical_page) do begin
				var xobj : objs_type := xobjs(i, i_logical_page);
//				if (xobj.tipo_oggetto <> xVARIABILE) then continue;
				if (xobj.tipo_variabile <> TV_PARAMETRO) then continue;

				var lab : cl_label := xobj.aslabel;
//				lab := xobjs(i,i_logical_page).aslabel;
				if (lab <> NIL) AND {(lab.tipovar = TV_PARAMETRO) AND} lab.bo_ask_runtime AND
					(globale.runtime_gboxes[lab.i_runtime_groupbox].bo_ask_on_exit = bo_on_exit) AND			// necessario specificarlo
					(globale.runtime_gboxes[lab.i_runtime_groupbox].i_parameter_window = i_window) AND
					lab.valuta_runtime_if(handle, lab.str_runtime_ask_if)
				then begin
//					s := uppercase(xobjs(i, i_logical_page).aslabel.Caption);	// codice parametro da creare
					var s := uppercase(lab.Caption);	// codice parametro da creare
					for var j : obj_index_type := 0 to high(RPT) do begin
						if (s = uppercase(xobjs(RPT[j].i_object, RPT[j].i_logical_page).aslabel.Caption)) then begin
							MessageBBox(handle, 'ATTENZIONE: il parametro ' + s + ' compare più di una volta', globale.str_filename, MB_ICONSTOP);
							result := ARP_CLOSE_REPORT;exit
						end
					end;
					add_runtime_parm(RPT, i_logical_page, i)
				end
			end
		end;

//		if NOT runtime_parms_proc(self,RPT) then raise exception.create('Stampa interrotta');
//		globale.bo_exists_runtime_parms := (RPT <> NIL);
//		if globale.bo_exists_runtime_parms then begin
		if (RPT <> NIL) then begin
			{if NOT globale.runtime_gboxes[i_window].bo_ask_on_exit then} globale.bo_exists_runtime_parms := TRUE;
			var bo_last_window := (sow = []);
			case runtime_parms_proc(father, RPT, lo_print_style, bo_modified, bo_execute_scripts, bo_first_window, bo_last_window, bo_on_exit, bo_dont_close_after) of
				ARP_BUILD_REPORT : bo_rebuild := TRUE;
				ARP_CLOSE_REPORT : begin result := ARP_CLOSE_REPORT;exit end;
				ARP_NOTHING : begin
					if globale.bo_first_print then result := ARP_CLOSE_REPORT else result := ARP_NOTHING;
					exit
				end
				{$ifdef DEBUG} else assert(FALSE,'DEJW 9925') {$endif}
			end;
			bo_first_window := FALSE
		end
	end;

	if bo_rebuild then begin
		result := ARP_BUILD_REPORT;
		globale.bo_first_print := FALSE;
		exec_validazione_anticipata_proc(VCTXT_AFTER_RUNTIME);
		reset_objects
	end
	else begin
//		{$ifdef DEBUG} assert(FALSE,'DEJW 9927'); {$endif}
		result := ARP_NOTHING;
		bo_dont_close_after := FALSE		// nessun parametro, dopo l'esecuzione chiudo senza dubbi nè remore
	end
end;

initialization
	galateo_initialization_debug('runtime')
finalization
	galateo_finalization_debug('runtime')
end.
