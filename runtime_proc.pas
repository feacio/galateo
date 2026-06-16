unit runtime_proc;		//*

{$I defines}
{$ifNdef CASA} *** {$endif}	// solo DLL !!!

interface

uses Windows, SysUtils, VCL.Forms, VCL.Graphics, Classes, VCL.StdCtrls, VCL.Buttons, VCL.ComCtrls, VCL.Controls, Math, VCL.Mask,
	federico, FXStrings, FStrings, FBitBtn, gdich, multi_dialog, objects, labels;

type
	// serve solo per passare l'elenco dei parametri da trattare a runtime
	runtime_parm_type = record
		i_logical_page : logical_page_type;
		i_object : obj_index_type;
	end;
	runtime_parms_type = array of runtime_parm_type;

	// --------------------------------------------------------------------------
	cl_runtime_field_elenco = class;
	cl_runtime_field = class
		private
			i_logical_page : logical_page_type;
			i_object : obj_index_type;
			obj : objs_type;
			lab : cl_label;	// = li_obj.lab, definito solo per comodità e immediatezza
//			lo_colore_base : TColor;
			it_descrizioni, it_codici : TStrings;
			scripts : cl_runtime_scripts;
			father : cl_runtime_field_elenco;
			str_base_event_value : array[RSE_WC_BASE_EVENT_FIRST..RSE_WC_BASE_EVENT_LAST] of string;
			constructor create(father : cl_runtime_field_elenco;RP : runtime_parm_type);
			destructor free;
			procedure apply_scripts(rse : runtime_script_event;bo_changed : boolean = FALSE);
//			function get_control : TWinControl;
			function get_codice_associato(s : string) : string;
			function get_descrizione_associata(s : string) : string;
			procedure browse_proc(sender : TObject);
		private
			cb : TFCombo;
			xstr : TFEdit;
			mask : TMaskEdit;
			memo : TFMemo;
			cbx : TFCheckBox;
			btn_browse : TFBitBtn;
//			dt : TJvDateEdit;
			txt : TLabel;
			xmulti : cl_multi_dialog;
			str_multi : string;	// stringa usata per la gestione del multi-dialog; qualora siano differenti, contiene LE DESCRIZIONI e non i codici; STR_PRINT contiene invece i codici
			read_proc_base, closeup_proc_base, exit_proc_base, enter_proc_base : TNotifyEvent;
//			procedure validate(err_msg : cl_validation;li_table : pointer{cl_extra_table};str_parametro : string = '');
			procedure IO(bo_read : boolean);
			procedure enable(bo_enabled : boolean);
//			procedure segnala_modifica_automatica(bo_modified : boolean);
			function load_combo_items(father : TForm;var str_default_value : string;bo_messages : boolean = TRUE) : boolean;
			procedure multi_modified_proc(pt : pointer);
//			procedure set_combo_value(father : TForm);
//			procedure set_default_value;
			procedure reset_to_default;
			function Tag : integer;
		public
			function get_control : TWinControl;
			function translate_descrizioni_2_codici(str_descrizioni : string;apix : APIX_type;
				it_source : TStrings = NIL;it_target : TStrings = NIL) : string;
			function translate_values(str_descrizioni : string;apix : APIX_type;it_source : TStrings = NIL;it_target : TStrings = NIL) : string;
			function valid_value(s : string) : boolean;	// rende TRUE se il valore è uno tra i valori accettati come risposta
	end;

	cl_runtime_field_elenco = class
		private
			form : TForm;
			bo_in_standard_event : array[runtime_script_event] of boolean;
			fx : array of cl_runtime_field;
//			EV : cl_ELE_varianti_prj;
			RPT : runtime_parms_type;
			function get_index_from_tag(lo_tag : integer) : smallint;
		public
			constructor create(form : TForm;RPT : runtime_parms_type);
			destructor free;
			function set_extra_fields_ctrls(form : TForm;read_proc, closeup_proc, enter_proc, exit_proc : TNotifyEvent;
				page : TTabSheet;parent_control : TWinControl = NIL) : boolean;
			procedure standard_event_proc(sender: TObject;evento : runtime_script_event);
//			procedure standard_read_proc(sender : TObject);
//			procedure standard_closeup_proc(sender : TObject);
//			procedure standard_enter_proc(sender : TObject);
//			procedure standard_exit_proc(sender : TObject);
			procedure enable_ctrls;
			procedure IO(bo_read : boolean);
//			procedure enable_first_ctrl;
			function field(i : smallint) : cl_runtime_field; overload;	// rende fx[i]
			function field(lab : cl_label) : cl_runtime_field; overload;	// rende fx[i]
			function reset_values : boolean;
	end;

procedure add_runtime_parm(var RPT : runtime_parms_type;i_logical_page : logical_page_type;i_object : obj_index_type);

implementation

uses Fcommons, FAssert, FErrMsg, FCtrls, FMessage, FSystem_base, FSystem, FProcs, FBrowse, FSQLsoft,
	galateo_debug, proc, pages, functions;

{$ifdef DEBUG} var i_runtime_field, i_runtime_field_elenco : integer; {$endif}

procedure add_runtime_parm(var RPT : runtime_parms_type;i_logical_page : logical_page_type;i_object : obj_index_type);
begin
	var i : smallint := length(RPT);setLength(RPT, i+1);
	RPT[i].i_logical_page := i_logical_page;
	RPT[i].i_object := i_object
end;

const		// costanti banali di gestione spicciola campi EXTRA
	X0_LABEL = 5;
//	YBASE = 10;
	YBASE = 20;
	DELTA_Y = 4 {interline};
	LABEL_WIDTH = 200;
	DX_CONTROL = 5;	// distanza tra label e control
	MARGINE_DX = 8;	// distinta tra i controlli ed il margine dx
	COMBO_WIDTH = 240;
	MULTI_BUTTON_WIDTH = 18;
	NUMERIC_EDIT_WIDTH = 100;
	DATA_EDIT_WIDTH = 90;
	STRING_EDIT_WIDTH = COMBO_WIDTH;
	BROWSE_BUTTON_WIDTH = 24;	// dimensione del bottone di browse per i filenames
	BROWSE_BUTTON_DX = 5;		// distanza del browse button dal controllo principale

// ----- cl_runtime_field -------------------------------------------------

constructor cl_runtime_field.create(father : cl_runtime_field_elenco;RP : runtime_parm_type);
begin
	{$ifdef DEBUG} inc(i_runtime_field); {$endif}
	i_object := RP.i_object;i_logical_page := RP.i_logical_page;
	self.father := father;

	obj := xobjs(i_object, i_logical_page);
{$ifdef DEBUG}
	var str_caption := 'cl_runtime_field.create(LP=' + inttostr(i_logical_page) + ' I_OBJ=' + inttostr(i_object) + ') -- ';
	assert(obj <> NIL, str_caption + 'NOT FOUND -- JIHW 7015');
	assert(obj.tipo_variabile in TV_OLD_VARIABILI, str_caption + 'NON E'' UNA *VARIABILE* -- JIHW 7016');
	assert(obj.tipo_variabile = TV_PARAMETRO, str_caption + 'NON E'' UN PARAMETRO -- JIHW 7017');
{$endif}

	lab := obj.aslabel;
	if (lab.str_runtime_scripts <> '') then begin
		scripts := cl_runtime_scripts.create;
		scripts.set_text(lab.str_runtime_scripts)
	end
end;

destructor cl_runtime_field.free;
begin
	{$ifdef DEBUG} dec(i_runtime_field); {$endif}
	if (scripts <> NIL) then begin scripts.Free;scripts := NIL end;
	multi_dialog_free(xmulti)
end;

function cl_runtime_field.Tag : integer;
begin
	if (txt <> NIL) AND (txt.focuscontrol <> NIL) then result := txt.focuscontrol.Tag else
	if (cb <> NIL) then result := cb.Tag else
	if (xstr <> NIL) then result := xstr.Tag else
	if (mask <> NIL) then result := mask.Tag else
	if (memo <> NIL) then result := memo.Tag else
	if (cbx <> NIL) then result := cbx.Tag else
//	if (dt <> NIL) then result := dt.Tag else
	result := 0
end;

procedure cl_runtime_field.enable(bo_enabled : boolean);
begin
	if (cbx <> NIL) then cbx.Enabled := bo_enabled;
	if (txt <> NIL) then enable_FC(txt,bo_enabled);
	if (xmulti <> NIL) then xmulti.button.Enabled := bo_enabled
end;

function cl_runtime_field.get_codice_associato(s : string): string;
var it_codici, it_descrizioni : TStrings;
begin
	if (self.it_codici = NIL) OR (self.it_codici.Count = 0) then it_codici := self.it_descrizioni else it_codici := self.it_codici;
	it_descrizioni := self.it_descrizioni;
	var i : smallint := 0;s := uppercase(s);
	while (i < it_descrizioni.Count) AND (s <> uppercase(it_descrizioni[i])) do inc(i);
	if (i = it_descrizioni.Count) then result := '' else result := it_codici[i]
end;

function cl_runtime_field.get_descrizione_associata(s : string): string;
var it_codici, it_descrizioni : TStrings;
begin
	if (self.it_codici = NIL) OR (self.it_codici.Count = 0) then it_codici := self.it_descrizioni else it_codici := self.it_codici;
	it_descrizioni := self.it_descrizioni;
	var i : smallint := 0;s := uppercase(s);
	while (i < it_codici.Count) AND (s <> uppercase(it_codici[i])) do inc(i);
	if (i = it_codici.Count) then result := '' else result := it_descrizioni[i]
end;

function cl_runtime_field.translate_descrizioni_2_codici(str_descrizioni : string;apix : APIX_type;
	it_source : TStrings = NIL;it_target : TStrings = NIL) : string;
{ converte le stringhe da DESCRIZIONI a CODICI;
  la procedure può essere usata anche per lo scopo opposto assegnando opportunamente IT_SOURCE e IT_TARGET }
{var
	s : string;
	i : smallint;}
begin
	if (it_source = NIL) then it_source := self.it_descrizioni;
	if (it_target = NIL) then it_target := self.it_codici;
{	str_descrizioni := delimited_to_inapiciata(str_descrizioni, APIX_BLANK);
	if (it_source = NIL) OR (it_target = NIL) OR (it_source.Count <> it_target.Count) then result := str_descrizioni
	else begin
		result := '';
		while (str_descrizioni <> '') do begin
			s := get_first_delimited(str_descrizioni);
			str_descrizioni := delete_delimited(str_descrizioni, s, FALSE);
			i := it_source.IndexOf(s);
			if (i <> -1) then add_delimited(result, it_target[i])
		end
	end;
	result := delimited_to_inapiciata(result, apix)}
	result := translate_values(str_descrizioni, apix, it_source, it_target)
end;

function cl_runtime_field.translate_values(str_descrizioni : string;apix : APIX_type;it_source : TStrings = NIL;it_target : TStrings = NIL) : string;
{ converte le stringhe da SOURCE a TARGET (esempio: da DESCRIZIONI a CODICI, oppure viceversa);
  come la TRANSLATE_DESCRIZIONI_2_CODICI, solo un po' meno truffaldina nella denominazione }
begin
	{$ifdef DEBUG} assert(it_source <> NIL, 'cl_runtime_field.translate_values() : IT_SOURCE=NIL -- JKLP 4812'); {$endif}
	{$ifdef DEBUG} assert(it_target <> NIL, 'cl_runtime_field.translate_values() : IT_TARGET=NIL -- JKLP 4812'); {$endif}
	str_descrizioni := inapicia(str_descrizioni, APIX_BLANK);
	if (it_source = NIL) OR (it_target = NIL) OR (it_source.Count <> it_target.Count) then result := str_descrizioni
	else begin
		result := '';
		while (str_descrizioni <> '') do begin
			var s := get_first_delimited(str_descrizioni);
			str_descrizioni := delete_delimited(str_descrizioni, s, FALSE);
			var i : smallint := it_source.IndexOf(s);
			if (i <> -1) then add_delimited(result, it_target[i])
		end
	end;
	result := inapicia(result, apix)
end;

function cl_runtime_field.valid_value(s : string) : boolean;
// rende TRUE se il valore è uno tra i valori accettati come risposta
begin
	var it := it_codici;
	if (it = NIL) OR (it.Text = '') then it := it_descrizioni;		// se non vi sono valori espliciti, uso direttamente le risposte suggerite
	result := (it <> NIL) AND (it.IndexOf(s) <> -1)
end;

function cl_runtime_field.get_control : TWinControl;
begin
	if (cbx <> NIL) then result := cbx else
	if (cb <> NIL) then result := cb else
	if (xstr <> NIL) then result := xstr else
	if (mask <> NIL) then result := mask else
	if (memo <> NIL) then result := memo else
	result := NIL
end;

procedure cl_runtime_field.apply_scripts(rse : runtime_script_event;bo_changed : boolean = FALSE);
{ applica gli scripts dell'oggetto; la procedure viene chiamata in seguito all'evento specificato (RSE);
  vi sono due versioni per ogni evento principale: la versione base (ALWAYS) e la versione WhenChanged;
  la versione BASE viene attivata sempre; quella WC solo se BO_CHANGED = TRUE}
const SUBST_APICE = '_*!*_';	// sequenza improbabile
var s, str_debug_caption, str_default, str_originale : string;
begin
	if (scripts = NIL) then exit;	// nulla, ma proprio nulla, da fare
	for var i : smallint := 0 to high(scripts.sx) do begin
//		if NOT (rse in scripts.sx[i].execute_on_events) then continue;

		var bo := FALSE;
		if (rse in scripts.sx[i].execute_on_events) then bo := TRUE;
		if NOT bo AND (rse in RSE_WC_BASE_EVENTS) AND bo_changed then begin
			case rse of
				RSE_ON_CLOSEUP : bo := (RSE_ON_CLOSEUP_WC in scripts.sx[i].execute_on_events);
				RSE_ON_EXIT : bo := (RSE_ON_EXIT_WC in scripts.sx[i].execute_on_events);
				{$ifdef DEBUG} else assert(FALSE, 'evento WC non gestito -- DJHW 9317') {$endif}
			end
		end;

		if NOT bo then continue;

		var x : objs_type := NIL;var fld : cl_runtime_field := NIL;
		if (scripts.sx[i].str_apply_on_parametro <> '') then begin
//			x := name2obj(scripts.sx[i].str_apply_on_parametro, [xTESTO, xVARIABILE], {bo_all_pages}TRUE);
			x := name2obj(scripts.sx[i].str_apply_on_parametro, TV_SCRIPTS_TARGET_APPLICATION, {bo_all_pages}TRUE);
			{$ifdef DEBUG} assert(x <> NIL, 'parametro not found: ' + scripts.sx[i].str_apply_on_parametro + ' -- KYEE 0923'); {$endif}
			fld := father.field(x.aslabel);
			{$ifdef DEBUG} assert(fld <> NIL, 'label not found: -- KYEE 0924') {$endif}
		end;
		str_debug_caption := 'apply_scripts(' + obj.aslabel.Caption + ') -- script ' + (i+1).Tostring;

		case scripts.sx[i].tipo of
			{$ifdef DEBUG} RST_BLANK : assert(FALSE, 'RST_BLANK -- DJWE 9391'); {$endif}
			RST_SETVALUE : begin
				if (x <> NIL) then begin
					s := scripts.sx[i].str_value;
					reset_print_values(MAIN_SECTION);
					var bo_query := (start_with(s, '#'));
					str_originale := ifs(bo_query, copy(s, 2, MAXINT), s);
					try
//						s := tratta_formula({obj.get_section,} obj, str_originale)
//						s := tratta_formula({obj.get_section,} x, str_originale)	// l'oggetto di riferimento è quello da assegnare (esempio: tipo di dato -- numero o stringa)
//						if bo_query then tipo_res := VAL_TESTO else tipo_res := x.aslabel.tipo_valore;
						var tipo_res : risultato_type;
						if bo_query then tipo_res := VAL_TESTO else tipo_res := x.ca.tipo_valore;
						// se QUERY, il risultato è una stringa di testo (la query), altrimenti è del tipo dell'oggetto di destinazione
						s := tratta_formula({obj.get_section,} obj, str_originale, tipo_res)
					except
						error_msg(father.form, 'Errore nell''esecuzione dello script' + ACAPO2 + str_originale + ACAPO2 + s, obj.aslabel.Caption);
						abort
					end;
					if bo_query then begin
						Gdebug_SQL(s, str_debug_caption);
						s := get_string_where(globale.report_database.DatabaseName, s, '', TRUE);
						Gdebug_SQL('risultato=' + s, str_debug_caption, {remarks}TRUE)
					end;
					x.aslabel.str_print := s;
					if (fld <> NIL) then fld.IO(FALSE)
				end
			end;
			RST_RELOAD_COMBO : begin
				var cb : TFCombo := NIL;
				if (fld <> NIL) then cb := fld.cb;
				if (cb <> NIL) then begin
					// faccio ricalcolare le formule che sono già state calcolate,
					// per il non improbabile caso che il caricamento della combo dipenda da una formula
					reset_print_values(MAIN_SECTION);
//					calcola_values(get_handle(father.form), TRUE, MAIN_SECTION, {bo_non_ricalcolare_formule_non_vuote}FALSE);
					s := x.aslabel.str_print;
					fld.load_combo_items(father.form, str_default, FALSE);	// STR_DEFAULT non serve a nulla
{					if (cb.Text <> s) then begin
						j := cb.Items.indexof(s);
						if (j <> -1) then cb.ItemIndex := j // else if (cb.Style = csDropDown) then cb.Text := s
					end }
					var j : smallint := cb.Items.indexof(s);
					cb.ItemIndex := cb.Items.indexof(s);		// eventualmente cancellando il valore se non esiste in lista
					if (j = -1) then begin cb.Text := '';x.aslabel.str_print := '' end else cb.Text := s
				end
			end;
			else begin
				{$ifdef DEBUG} assert(FALSE, 'RST_ valore non trattato -- DJWE 9392'); {$endif}
				abort
			end
		end
	end
end;

procedure cl_runtime_field.IO(bo_read : boolean);
var s, str_original_value : string;	//*
begin
	if bo_read then begin
		str_original_value := lab.str_print;
		if (cbx <> NIL) then lab.str_print := bool2SQL(cbx.Checked)
		else begin
			if (cb <> NIL) then
				if (xmulti = NIL) then s := cb.Text else s := str_multi;
			if (xstr <> NIL) then s := xstr.Text;
			if (mask <> NIL) then s := mask.Text;
			if (memo <> NIL) then s := memo.Text;
//			if (memo = NIL) AND (it_descrizioni <> NIL) AND
//				(lab.rtq <> RTQ_MULTI_SELECT)	// gestito a parte: può avere valori non immediatamente decodificabili
//					then s := get_codice_associato(s);

			if (memo = NIL) AND (it_descrizioni <> NIL) then begin
				case lab.rtq of
//					RTQ_SINGLE_SELECT : s := get_codice_associato(s);
					RTQ_SINGLE_SELECT : s := coalesce(get_codice_associato(s), s);		// 2012-09-28 in caso di testo non compreso tra le scelte predefinite, il valore restava comunque blank
					RTQ_MULTI_SELECT : s := translate_descrizioni_2_codici(s, lab.RTQ_apix);	// STR_PRINT: sempre i CODICI, non le descrizioni
					else	// ok
				end
			end;

//			case obj.aslabel.tipo_valore of
			case obj.ca.tipo_valore of
				VAL_NUMERO : begin
					s := togliblanks(s);
					if (s <> '') then strToFloat(s)
				end;
				VAL_TESTO : begin
//					if (memo = NIL) AND (it_descrizioni <> NIL) then s := get_codice_associato(s)
				end;
				{$ifdef DEBUG} else assert(FALSE,'DXRR 3722 non gestito') {$endif}
			end;
			lab.str_print := s
		end;
		if (scripts <> NIL) AND (str_original_value <> lab.str_print) then apply_scripts(RSE_ON_UPDATE)
	end
	else begin
		s := lab.str_print;

		// lab.str_print contiene il CODICE; se esiste, uso la descrizione associata al codice
		if {(obj.aslabel.tipo_valore = VAL_TESTO) AND} (memo = NIL) AND (it_codici <> NIL)
			AND NOT ((cb <> NIL) AND (lab.rtq = RTQ_MULTI_SELECT))		// riga aggiunta 2010-06-08 x' conversione inutile (e anzi dannosa)
		then begin
			s := get_descrizione_associata(s);
			if (s = '') then s := lab.str_print	// 2007-03-28 nessuna descrizione associata: torno al codice
		end;

		if (cbx <> NIL) then cbx.Checked := SQL2bool(s);
		if (cb <> NIL) then begin
			if (lab.rtq = RTQ_MULTI_SELECT) then begin
//				str_multi := s;
//				str_multi := translate_descrizioni_2_codici(s, APIX_BLANK, it_codici, it_descrizioni);	// ??lab.RTQ_apix??: direi di no
//				str_multi := s;		// STR_PRINT: codici; STR_MULTI: descrizioni
//				str_multi := translate_descrizioni_2_codici(s, APIX_BLANK, it_codici, it_descrizioni);	// usata alla ROVESCIA: da descr a codice; STR_PRINT: codici; STR_MULTI: descrizioni
				str_multi := translate_values(s, APIX_BLANK, it_codici, it_descrizioni);	// da descr a codice; STR_PRINT: codici; STR_MULTI: descrizioni
				xmulti.write
			end
			else
				if (cb.style = csDropDownList) then cb_select(cb, s) else cb.Text := s
		end;
		if (xstr <> NIL) then xstr.Text := s;
		if (mask <> NIL) then mask.Text := s;
		if (memo <> NIL) then memo.Text := s
	end
end;

procedure cl_runtime_field.multi_modified_proc(pt : pointer);
// procedure richiamata quando viene modificata una multi-dialog
begin
	lab.str_print := str_multi;
	if assigned(read_proc_base) then read_proc_base(cl_multi_dialog(pt).combobox)
end;

function cl_runtime_field.load_combo_items(father : TForm;var str_default_value : string;bo_messages : boolean = TRUE) : boolean;
const BLANK_ANSWER = '(nessun valore)';
var s, str_descrizioni, str_codici{, str_temp} : string;
begin
	var handle : hwnd := get_handle(father);
	result := FALSE;str_default_value := '';
	if (it_codici <> NIL) then it_codici.free;
	if (it_descrizioni <> NIL) then it_descrizioni.free;
	it_codici := TStringList.create;it_descrizioni := TstringList.create;
	{$ifdef DEBUG} assert(cb <> NIL,'CB deve essere stata creata!!! -- DJHS 0992'); {$endif}

//	bo_can_be_blank := lab.bo_runtime_answer_can_be_blank AND (lab.tipo_valore = VAL_TESTO);		fino al 2009-11-20, ma in caso di parametro numerico (esempio: anno) pareva improprio
	var bo_can_be_blank := lab.bo_runtime_answer_can_be_blank {AND (lab.tipo_valore = VAL_TESTO)};

	str_descrizioni := lab.str_runtime_answers;
	sections_1B(1, i_logical_page).interpreta_string(str_descrizioni, {stampa_vera}TRUE, {check_errors}FALSE);
	str_codici := lab.str_runtime_values;
	sections_1B(1, i_logical_page).interpreta_string(str_codici, {stampa_vera}TRUE, {check_errors}FALSE);
	if lab.bo_SQL_load_runtime_values then begin
		if (str_descrizioni = '') then begin
			MessageBBox(handle, 'Non è stata specificata l''istruzione SQL per il caricamento della ComboBox', obj.get_debug_caption, MB_ICONSTOP);
			exit
		end;
		if lab.bo_SQL_runtime_parm_debug then Gdebug_SQL(str_descrizioni, obj.get_debug_caption + ' (descrizioni)');
		if NOT load_SQL_items(globale.report_database.DatabaseName, str_descrizioni{lab.str_runtime_answers}, '', it_descrizioni, FALSE) then begin
			MessageBBox(handle, 'Errore nel reperimento dei VALORI di risposta' + ACAPO2 + {lab.str_runtime_answers}str_descrizioni,
				obj.get_debug_caption, MB_ICONSTOP);
			exit
		end;
		if (lab.str_runtime_values <> '') then begin
			if lab.bo_SQL_runtime_parm_debug then Gdebug_SQL(str_codici, obj.get_debug_caption + ' (codici di risposta)');
			if NOT load_SQL_items(globale.report_database.DatabaseName, str_codici, '', it_codici, FALSE) then begin
				MessageBBox(handle,'Errore nel reperimento dei CODICI di risposta' + ACAPO2 + lab.str_runtime_values,
					obj.get_debug_caption,MB_ICONSTOP);
				exit
			end;
			if (it_descrizioni.Count <> it_codici.Count) then begin
				MessageBBox(handle,'I VALORI e i CODICI di risposta sono in numero differente -- saranno utilizzati solamente i CODICI',
					obj.get_debug_caption);
				it_descrizioni.Assign(it_codici)
			end
		end
	end
	else begin
		it_codici.Text := str_codici;
		it_descrizioni.Text := str_descrizioni
	end;

	if NOT bo_can_be_blank AND (it_descrizioni.Count = 0) AND bo_messages then begin
		MessageBBox(handle,'ATTENZIONE' + ACAPO2 + 'Il parametro <' + lab.get_runtime_caption + '> è obbligatorio, ma non c''è nessun valore disponibile' + ACAPO2 +
			'Impossibile proseguire', MBOX_CAPTION, MB_ICONSTOP);
		abort
	end;

	case lab.rtq of
		RTQ_TEXT, RTQ_SINGLE_SELECT : begin
			if bo_can_be_blank then s := lab.str_runtime_blank_answer;
			cb.AAA_CanBeVoid := bo_can_be_blank
		end;
		RTQ_MULTI_SELECT : ;
		{$ifdef DEBUG} else assert(FALSE,'DFJS 9311') {$endif}
	end;

	var it := it_codici;
	if (it_descrizioni.Count <> 0) then it := it_descrizioni;
	cb.Items.assign(it);

	result := TRUE
end;

(*procedure cl_runtime_field.segnala_modifica_automatica(bo_modified: boolean);
const
//	COLORE_MODIFIED = clRed;
	COLORE_MODIFIED = $000080FF;
begin
	if (cbx <> NIL) then begin
		if (lo_colore_base = 0) then lo_colore_base := cbx.Color;
		cbx.Color := ifi(bo_modified,COLORE_MODIFIED,lo_colore_base)
	end;
	if (cb <> NIL) then begin
		if (lo_colore_base = 0) then lo_colore_base := cb.Color;
		cb.Color := ifi(bo_modified,COLORE_MODIFIED,lo_colore_base)
	end;
	if (xstr <> NIL) then begin
		if (lo_colore_base = 0) then lo_colore_base := xstr.Color;
		xstr.Color := ifi(bo_modified,COLORE_MODIFIED,lo_colore_base)
	end;
	if (mask <> NIL) then begin
		if (lo_colore_base = 0) then lo_colore_base := mask.Color;
		mask.Color := ifi(bo_modified,COLORE_MODIFIED,lo_colore_base)
	end;
	if (memo <> NIL) then begin
		if (lo_colore_base = 0) then lo_colore_base := memo.Color;
		memo.Color := ifi(bo_modified,COLORE_MODIFIED,lo_colore_base)
	end
end; *)

// -------- cl_runtime_field_elenco ---------------------------------------

constructor cl_runtime_field_elenco.create(form : TForm;RPT : runtime_parms_type);
begin
	{$ifdef DEBUG} inc(i_runtime_field_elenco); {$endif}
	self.form := form;self.RPT := RPT;
	setLength(fx, length(RPT));
	for var i : smallint := 0 to high(fx) do fx[i] := cl_runtime_field.create(self, RPT[i])
end;

destructor cl_runtime_field_elenco.free;
begin
	for var i : smallint := 0 to high(fx) do fx[i].free;
	fx := NIL;
	{$ifdef DEBUG} dec(i_runtime_field_elenco); {$endif}
end;

procedure cl_runtime_field_elenco.IO(bo_read : boolean);
begin
	for var i : smallint := 0 to high(fx) do fx[i].IO(bo_read);
	if NOT bo_read then enable_ctrls
end;

var i_larghezza_barra : smallint = 0;	// larghezza della barra di scorrimento

function cl_runtime_field_elenco.set_extra_fields_ctrls(form : TForm;read_proc, closeup_proc, enter_proc, exit_proc : TNotifyEvent;
	page : TTabSheet;parent_control : TWinControl = NIL) : boolean;
{ procede all'impostazione degli extra fields per la table in questione; rende TRUE in caso di successo, FALSE altrimenti;
  READ_PROC è la procedure che viene chiamata in via 'standard' quando l'oggetto viene modificato;
  PARENT_CONTROL è il control su cui devono essere creati gli oggetti; lasciare NIL per crearli direttamente su PAGE;
  INCLUDE_FIELDS contiene l'indicazione dei campi da mostrare tra quelli che possono essere mostrati/nascosti }
label after;
var
	i, i_group, i_group_created, y0, i_parent_control_height, i_caption_height, i_delta_form_width : smallint;
	gbox : TGroupBox;
	li : objs_type;
	lab : cl_label;
	ctrl : TWinControl;
	txt : TLabel;
	cb : TFCombo;
	xstr : TFEdit;
	mask : TMaskEdit;
	memo : TFMemo;
	me : TCustomEdit;
	cbx : TFCheckBox;
	btn_browse : TFBitBtn;
//	dt : TJvDateEdit;
	str_field : string;
	gx : cl_runtime_groupbox;
	lo_text_color, lo_back_color : TColor;
	btn_multi : TFBitBtn;
	multi_opt : OMD_set;
	str_default_value : string;
begin
	result := FALSE;
	if (i_larghezza_barra = 0) then i_larghezza_barra := GetSystemMetrics(SM_CXVSCROLL);
//	form.Width := form.Width + (X0_LABEL + LABEL_WIDTH + DX_CONTROL + STRING_EDIT_WIDTH + DX_CONTROL) - parent_control.Width + MARGINE_DX;	// da fare QUI!   + form.Width - form.ClientWidth
	// calcolo di quanto deve essere modificata la dimensione della FORM; applicherò la modifica DOPO aver creato i children controls
	i_delta_form_width := (X0_LABEL + LABEL_WIDTH + DX_CONTROL + STRING_EDIT_WIDTH + DX_CONTROL) - parent_control.Width + MARGINE_DX;
	i_parent_control_height := parent_control.Height;
	form.Constraints.Minwidth := form.Width - (STRING_EDIT_WIDTH - 20);
	parent_control.Align := alNone;
{$ifdef DEBUG}
	ctrl := NIL;if (ctrl = NIL) then;
	assert(form.ActiveControl = NIL, 'ActiveControl già assegnato -- KJYY 8829');
{$endif}
	try
		i_group_created := -1;
		y0 := 0;gx := NIL;gbox := NIL;	// solo per rassicurare il compilatore
		if (parent_control = NIL) then parent_control := page;

		if (globale.str_runtime_parms_caption = '') then i_caption_height := 0
		else begin
			txt := TLabel.Create(form);txt.Parent := form;
			txt.Name := 'TXT_runtime_caption';txt.Alignment := taCenter;
			txt.ShowAccelChar := FALSE;
			txt.Caption := globale.str_runtime_parms_caption;
			txt.Align := alTop;
			txt.Font.Name := 'Arial';txt.Font.Style := [fsBold];txt.Font.Size := 14;
			txt.Font.Color := globale.lo_foreground_parms_caption_color;
			txt.Color := globale.lo_background_parms_caption_color;
			i_caption_height := txt.Height
//			txt.ShowHint := TRUE;txt.Hint := ;
		end;

		// mi tutelo che i gruppi referenziati dagli oggetti esistano; se un gruppo non esiste, riassegno l'oggetto al primo gruppo
		{	INUTILE, controllo già eseguito
		for i := 0 to high(RPT) do begin
			lab := fx[i].obj.aslabel;
			if (lab.i_runtime_groupbox >= length(globale.runtime_gboxes)) then lab.i_runtime_groupbox := 0
		end; }

		for i_group := 0 to high(globale.runtime_gboxes) do begin
			for i := 0 to high(RPT) do begin
				li := fx[i].obj;lab := li.aslabel;
				if (lab.i_runtime_groupbox <> i_group) then continue;
				str_field := lab.Caption;
				if (i_group_created <> i_group) then begin
					gx := globale.runtime_gboxes[i_group];
					if (i_group_created = -1) then y0 := 0 else y0 := gbox.Top + gbox.Height;
					gbox := TGroupBox.Create(form);gbox.Parent := parent_control;
					gbox.Caption := gx.str_descrizione;
					parent_control.Height := y0 + gbox.Top + 200;	// ininfluente, a patto che non compaiano le scrollbars
					gbox.Top := y0;gbox.Left := 0;
					gbox.Width := parent_control.ClientWidth;
					gbox.Anchors := [akTop, akLeft, akRight];
					if (gx.lo_gruppo_text_color <> RUNTIME_UNASSIGNED_COLOR) then gbox.font.Color := gx.lo_gruppo_text_color;
					if (gx.lo_gruppo_back_color <> RUNTIME_UNASSIGNED_COLOR) then begin
						gbox.ParentBackground := FALSE;		// altrimenti non tiene il colore
						gbox.Color := gx.lo_gruppo_back_color
					end;
					y0 := YBASE;
					i_group_created := i_group	// in fondo !!!!!!!!!!
				end;

				lo_text_color := gx.get_color(lab.lo_runtime_text_color, TRUE);
				lo_back_color := gx.get_color(lab.lo_runtime_back_color, FALSE);

				if (lab.ca.tipo_valore = VAL_BOOLEAN) then begin
					cbx := TFCheckBox.create(form);cbx.Parent := gbox;
					fx[i].cbx := cbx;ctrl := cbx;
					cbx.name := str_field;
					cbx.Caption := lab.str_runtime_question;
					cbx.ShowHint := TRUE;cbx.Hint := lab.str_runtime_hint;
					cbx.Top := y0-3;
					cbx.Left := X0_LABEL + LABEL_WIDTH + DX_CONTROL;
					cbx.Width := STRING_EDIT_WIDTH + MARGINE_DX - 1 - i_delta_form_width;	// faccio arrivare proprio fino in fondo
//					cbx.Left := X0_LABEL;cbx.Width := parent_control.ClientWidth - cbx.Left - 5;
					cbx.allowgrayed := FALSE;		// NOT li.bo_required;
					cbx.OnClick := read_proc;cbx.OnEnter := enter_proc;cbx.OnExit := exit_proc;
					cbx.Tag := i;
					cbx.Anchors := [akTop, akLeft, akRight];
//					cbx.Color := li.get_color(clBtnFace);
//					cbx.Font.Color := li.lo_text_color;cbx.Color := li.lo_back_color;
					if (lo_back_color <> RUNTIME_UNASSIGNED_COLOR) then cbx.Color := lo_back_color;
					if (lo_text_color <> RUNTIME_UNASSIGNED_COLOR) then cbx.Font.Color := lo_text_color;
					{$ifdef DEBUG} cbx.AAA_NeedNotifyModification := FALSE; {$endif}
					inc(y0, cbx.Height + DELTA_Y);
//				cbx.Enabled := li.bo_enabled;
					goto after
				end;

				txt := TLabel.Create(form);txt.Parent := gbox;
				fx[i].txt := txt;
				txt.Name := 'TXT_' + str_field;
				txt.Font.Name := 'Arial';
				txt.Left := X0_LABEL;txt.Top := y0;
				txt.Alignment := taRightJustify;txt.Autosize := FALSE;
				txt.Width := LABEL_WIDTH;
				txt.Caption := coalesce(lab.str_runtime_question,lab.Caption);
				txt.ShowHint := TRUE;txt.Hint := lab.str_runtime_hint;
				txt.Tag := i;
				txt.ShowAccelChar := FALSE;
//				txt.Font.Color := li.lo_text_color;
				xstr := NIL;btn_multi := NIL;cb := NIL;btn_browse := NIL;

				if (lab.rtq = RTQ_TEXT) then begin		// TEdit or TMemo
					if (lab.ca.tipo_valore = VAL_TESTO) AND (lab.i_runtime_max_lines > 1) then begin		// TMemo
						memo := TFMemo.create(form);fx[i].memo := memo;
						memo.Width := STRING_EDIT_WIDTH - i_delta_form_width;
						memo.set_lines_height(lab.i_runtime_max_lines);
						memo.Parent := gbox;	// da fare qui, no TXT.Focuscontrol.xxxxx
						txt.FocusControl := memo;
						memo.MaxLength := lab.i_runtime_max_length;
						memo.Anchors := [akTop, akLeft, akRight];
//						memo.Color := li.get_color;
						memo.OnChange := read_proc;memo.OnEnter := enter_proc;memo.OnExit := exit_proc;
						memo.Tag := i;
						if (lo_back_color <> RUNTIME_UNASSIGNED_COLOR) then memo.Color := lo_back_color;
						if (lo_text_color <> RUNTIME_UNASSIGNED_COLOR) then memo.Font.Color := lo_text_color;
						{$ifdef DEBUG} memo.AAA_NeedNotifyModification := FALSE; {$endif}
					end
					else begin
						if (lab.str_runtime_format = '') then begin	// TFEdit
							xstr := TFEdit.create(form);fx[i].xstr := xstr;me := xstr;
							xstr.parent := gbox;	// da fare qui, no TXT.Focuscontrol.xxxxx; altrimenti alcune assegnazioni vengono perse
							{$ifdef DEBUG} xstr.AAA_NeedNotifyModification := FALSE; {$endif}

							xstr.MaxLength := lab.i_runtime_max_length;
							xstr.OnChange := read_proc;xstr.OnEnter := enter_proc;xstr.OnExit := exit_proc;
							xstr.CharCase := lab.CharCase;
							if (lo_back_color <> RUNTIME_UNASSIGNED_COLOR) then xstr.Color := lo_back_color;
							if (lo_text_color <> RUNTIME_UNASSIGNED_COLOR) then xstr.Font.Color := lo_text_color;
							if (lab.runtime_tipodato = RTT_FILENAME) then begin
								btn_browse := TFBitBtn.Create(form);fx[i].btn_browse := btn_browse;
								btn_browse.Parent := gbox;
								btn_browse.Caption := '...';
								btn_browse.OnClick := fx[i].browse_proc
							end
						end
						else begin	// TMaskEdit
							mask := TMaskEdit.Create(form);fx[i].mask := mask;me := mask;
							mask.Parent := gbox;	// da fare qui, no TXT.Focuscontrol.xxxxx; altrimenti alcune assegnazioni vengono perse
							mask.OnChange := read_proc;mask.OnEnter := enter_proc;mask.OnExit := exit_proc;
							mask.EditMask := lab.str_runtime_format;
							if (lo_back_color <> RUNTIME_UNASSIGNED_COLOR) then mask.Color := lo_back_color;
							if (lo_text_color <> RUNTIME_UNASSIGNED_COLOR) then mask.Font.Color := lo_text_color
						end;

						case lab.ca.tipo_valore of
							VAL_NUMERO : begin
								me.Width := NUMERIC_EDIT_WIDTH;
								if (xstr <> NIL) then
									if (lab.xi_cifre_round = 0) then xstr.AAA_tipodato := fe_Integer else xstr.AAA_tipodato := fe_Float
							end;
							VAL_TESTO : begin
								case lab.runtime_tipodato of
									RTT_TEXT : me.Width := STRING_EDIT_WIDTH;
									RTT_DATA : me.Width := DATA_EDIT_WIDTH;
									RTT_FILENAME : me.Width := STRING_EDIT_WIDTH - BROWSE_BUTTON_WIDTH - BROWSE_BUTTON_DX
									{$ifdef DEBUG} else assert(FALSE, 'UIHW 9301 non gestito') {$endif}
								end
							end
							{$ifdef DEBUG} else assert(FALSE,'DIWU 3131 non gestito') {$endif}
						end;
						me.Width := me.Width - i_delta_form_width;

						txt.FocusControl := me;me.Anchors := [akTop, akLeft, akRight];
						me.Tag := i;
					end
				end
				else begin	// combobox
					cb := TFCombo.create(form);
					fx[i].cb := cb;
					cb.parent := gbox;	// da fare qui, no TXT.Focuscontrol.xxxxx
					txt.FocusControl := cb;
					cb.Width := COMBO_WIDTH - ifi(lab.rtq = RTQ_MULTI_SELECT,MULTI_BUTTON_WIDTH + 3) - i_delta_form_width;
					cb.DropDownCount := 16;cb.MaxLength := lab.i_runtime_max_length;
					cb.OnChange := read_proc;cb.OnEnter := enter_proc;cb.OnExit := exit_proc;cb.OnCloseUp := closeup_proc;
					cb.Tag := i;
					cb.Anchors := [akTop, akLeft, akRight];
					cb.CharCase := lab.charcase;
//					cb.Color := li.get_color;

					if (lo_back_color <> RUNTIME_UNASSIGNED_COLOR) then cb.Color := lo_back_color;
					if (lo_text_color <> RUNTIME_UNASSIGNED_COLOR) then cb.Font.Color := lo_text_color;
					{$ifdef DEBUG} cb.AAA_NeedNotifyModification := FALSE; {$endif}
					if lab.bo_runtime_answer_in_valori_suggeriti then cb.Style := csDropDownList else cb.Style := csDropDown;

					fx[i].load_combo_items(form, str_default_value);
					// se c'è una sola voce nell'elenco, la seleziono direttamente
					if lab.bo_runtime_answer_in_valori_suggeriti AND (cb.Items.Count = 1) AND (lab.str_print = '') then lab.str_print := cb.Items[0];
					if (lab.rtq = RTQ_MULTI_SELECT) then begin
						btn_multi := TFBitBtn.create(form);btn_multi.Parent := gbox;
						btn_multi.Caption := '...';btn_multi.Anchors := [akTop, akRight];

//						fx[i].xstr_multi := str_default_value;
						fx[i].str_multi := fx[i].translate_descrizioni_2_codici(str_default_value, lab.RTQ_apix);
						multi_opt := [OMD_ALL_DIFFERENT_NONE_SELECTED];
						if lab.bo_runtime_answer_can_be_blank then multi_opt := multi_opt + [OMD_ALLOW_ZERO_ANSWERS];
//						{if () then} multi_opt := multi_opt + [OMD_INAPICIA_RISULTATO];
						if lab.bo_RTQ_select_all_answers then multi_opt := multi_opt + [OMD_SELECT_ALL];
						fx[i].read_proc_base := read_proc;	// assegno la procedure standard di segnalazione delle modifiche
						fx[i].exit_proc_base := exit_proc;fx[i].enter_proc_base := enter_proc;
						fx[i].closeup_proc_base := closeup_proc;
						fx[i].xmulti := cl_multi_dialog.create(form, txt.Caption, cb, btn_multi, fx[i].str_multi, '', multi_opt, '', fx[i].multi_modified_proc);
//						if (lab.bo_RTQ_select_all_answers) then lab.str_print := fx[i].xstr_multi;	*
						if lab.bo_RTQ_select_all_answers then lab.str_print := fx[i].translate_descrizioni_2_codici(fx[i].str_multi, lab.RTQ_apix);
						fx[i].xmulti.write
					end
					else begin	// RTQ_SINGLE_SELECT
//						fx[i].lab.str_print := str_default_value
//						cb_select
					end
				end;

				ctrl := txt.FocusControl;
				txt.FocusControl.Name := lab.Caption;
				txt.FocusControl.ShowHint := (lab.str_runtime_hint <> '');txt.FocusControl.Hint := lab.str_runtime_hint;
				txt.FocusControl.Left := txt.Left + LABEL_WIDTH + DX_CONTROL;
				txt.ShowHint := TRUE;txt.Hint := txt.Caption;
				if (txt.FocusControl is TFMemo) then txt.FocusControl.Top := txt.Top
				else txt.FocusControl.Top := txt.Top + (txt.Height - txt.FocusControl.Height) div 2;
				if (btn_multi <> NIL) then begin
					btn_multi.Top := cb.Top;btn_multi.Left := cb.Left + COMBO_WIDTH - MULTI_BUTTON_WIDTH - i_delta_form_width;
					btn_multi.Width := MULTI_BUTTON_WIDTH;btn_multi.Height := cb.Height
				end;

				if (btn_browse <> NIL) then
					btn_browse.SetBounds(txt.FocusControl.Left + txt.FocusControl.Width + BROWSE_BUTTON_DX, txt.FocusControl.Top,
						BROWSE_BUTTON_WIDTH, txt.FocusControl.Height);
				inc(y0, txt.FocusControl.Height + DELTA_Y);
//				enable_FC(txt,li.bo_enabled)
after:
				parent_control.Height := gbox.Top + y0 + 10;	// ininfluente, a patto che non compaiano le scrollbars
				gbox.Height := y0 + DELTA_Y;
				// assegno il control che deve avere il focus
				{$ifdef DEBUG} assert(ctrl <> NIL,'set_extra_fields_ctrls() -- ctrl non assegnato -- KPRT 8712'); {$endif}
				if (form.ActiveControl = NIL) AND ctrl.Enabled then form.ActiveControl := ctrl;
				{$ifdef DEBUG} ctrl := NIL;if (ctrl = NIL) then; {$endif}	// solo per essere sicuro dell'avvenuta assegnazione
			end
		end;

		enable_ctrls;
//		form.Height := min(form.Height + (y0 + DELTA_Y) - parent_control.Height,screen.Height - 100);	// da fare QUI!
//		parent_control.Height := gbox.Top + gbox.Height;
		parent_control.Align := alClient;
//		form.Height := min(form.Height + (gbox.Top + gbox.Height) - parent_control.Height,screen.Height - 100);	// da fare QUI!
		i := form.Height + (i_caption_height + gbox.Top + gbox.Height) - i_parent_control_height + (parent_control.Height - parent_control.ClientHeight);
		form.Height := min(i, screen.Height - 100);	// da fare QUI!
		form.Constraints.MaxHeight := i;

		form.Width := form.Width + i_delta_form_width;	// applico DOPO aver creato i children controls, altrimenti fa casino

//		page.tabvisible := TRUE;
		result := TRUE
	except
		if (page <> NIL) then page.TabVisible := FALSE
	end
end;

procedure cl_runtime_field_elenco.enable_ctrls;
begin
	for var i : smallint := 0 to high(fx) do
		fx[i].enable(fx[i].lab.valuta_runtime_if(get_handle(form),fx[i].lab.str_runtime_enable_if))
//	for i := 0 to high(fx) do fx[i].enable(EV.Enabled(i))
end;

function cl_runtime_field_elenco.get_index_from_tag(lo_tag : integer) : smallint;
// rende l'indice nel vettore in funzione del valore di TAG; rende -1 in caso di errore
begin
	result := high(fx);
	while (result >= 0) AND (fx[result].Tag <> lo_tag) do dec(result)
end;

procedure cl_runtime_field_elenco.standard_event_proc(sender : TObject;evento : runtime_script_event);
// procedura standard di gestione degli eventi
begin
	if bo_in_standard_event[evento] then exit;	// not reentrant, please!
	try
		bo_in_standard_event[evento] := TRUE;
		{$ifdef DEBUG} assert(sender <> NIL, 'DXSA 2380'); {$endif}
		var i : smallint := get_index_from_tag((sender as TControl).Tag);
		if (i = -1) then exit;	// ????????????????????
		var evento_wc : runtime_script_event := evento;
		case evento of
			RSE_ON_UPDATE : fx[i].IO(TRUE);
			RSE_ON_ENTER : begin
				fx[i].apply_scripts(RSE_ON_ENTER);
				evento_wc := RSE_ON_EXIT		// faccio assegnare il valore base per l'evento ON_EXIT
			end;
			RSE_ON_DROPDOWN : evento_wc := RSE_ON_CLOSEUP;	// faccio assegnare il valore base per l'evento RSE_ON_CLOSEUP
			RSE_ON_CLOSEUP : begin
				if (fx[i].cb = NIL) then exit;
				fx[i].apply_scripts(RSE_ON_CLOSEUP, fx[i].str_base_event_value[RSE_ON_CLOSEUP] <> fx[i].lab.str_print)
			end;
			RSE_ON_EXIT : fx[i].apply_scripts(RSE_ON_EXIT, fx[i].str_base_event_value[RSE_ON_EXIT] <> fx[i].lab.str_print);
			{$ifdef DEBUG} else assert(FALSE, 'DXSA 2381') {$endif}
		end;
		if (evento_wc in RSE_WC_BASE_EVENTS) then fx[i].str_base_event_value[evento_wc] := fx[i].lab.str_print;
		enable_ctrls
	finally
		bo_in_standard_event[evento] := FALSE
	end
end;

{procedure cl_runtime_field_elenco.enable_first_ctrl;
var
	i : smallint;
	ctrl : TWinControl;
begin
	for i := 0 to high(fx) do begin
		ctrl := fx[i].get_control;
		if (ctrl.Visible AND ctrl.Enabled) then begin
			activecontrol := ctrl;
			ctrl.setFocus;
			break
		end
	end
end;	}

function cl_runtime_field_elenco.field(i : smallint) : cl_runtime_field;
begin
	result := fx[i]
end;

function cl_runtime_field_elenco.field(lab : cl_label) : cl_runtime_field;
begin
	result := NIL;
	for var i : smallint := 0 to high(fx) do
		if (fx[i].lab = lab) then begin result := fx[i];break end
end;

function cl_runtime_field_elenco.reset_values : boolean;
begin
	for var i : smallint := 0 to high(fx) do fx[i].reset_to_default;
	result := TRUE
end;

procedure cl_runtime_field.reset_to_default;
var s : string;	//*
begin
//	var handle : hwnd := 0;
	var bo_combo_select_all := (lab.rtq = RTQ_MULTI_SELECT) AND lab.bo_RTQ_select_all_answers;

//	{$ifdef DEBUG} assert(lab.bo_ask_runtime, 'NOT bo_ask_runtime'); {$endif}		{$ifNdef DEBUG} *** {eliminare a partire da 2011-07 anzi da 2011-09-30} {$endif}
//	if lab.get_parm_esempio_runtime_running then begin		*** fino 2011-05-23
	if lab.bo_ask_runtime			// da 2011-05-23, ma la condizione è scontata
		AND NOT bo_combo_select_all		// condizione NON scontata
	then begin
//		i := it_codici.indexof(lab.str_esempio_value);
//		if (i = -1) then i := it_descrizioni.indexof(lab.str_esempio_value);
//		if (i <> -1) then str_default_value := it_descrizioni[i]
		s := lab.ca.str_esempio_value;		// eventuali formule o espressioni SQL sono già state tradotte e salvate su STR_ESEMPIO_VALUE

		if (s <> '') then try
			if lab.bo_runtime_default_is_SQL then begin
				sections_1B(1, i_logical_page).interpreta_string(s, {bo_stampa_vera}TRUE, {bo_check_errors}FALSE);
				s := get_string_where(sections_1B(1, i_logical_page).qry.DatabaseName, s);
//				{$ifdef DLL} lab.bo_runtime_default_is_SQL := FALSE;lab.str_esempio_value := s {$endif}
				lab.bo_runtime_default_is_SQL := FALSE;obj.ca.str_esempio_value := s
			end (*else			**** commentato 2011-07-23: la traduzione della formula è già avvenuta!!!
			if lab.bo_runtime_default_is_formula then begin
				if NOT translate_formula(s, s, {bo_test}FALSE, lab.ca.tipo_valore, obj) then abort
			end *)
		except
			error_msg(self.father.form, 'Errore durante l''interpretazione del valore default per l''oggetto ' + obj.get_debug_caption + ACAPO2 + s, MBOX_CAPTION);
			raise
		end;
		lab.str_print := s;
		exit
	end;

//	if (lab.rtq = RTQ_MULTI_SELECT) AND lab.bo_RTQ_select_all_answers then begin
	if bo_combo_select_all then begin
//		s := togli_ACAPO_finali(ifs(it_descrizioni.Count = 0,it_codici.Text, it_descrizioni.Text));
		s := togli_ACAPO_finali(coalesce(it_codici.Text, it_descrizioni.Text));
		lab.str_print := sostituisci(s,ACAPO,',')		// STR_PRINT: sempre i CODICI, non le descrizioni
	end
	else begin	// 2008-07-16
		case lab.ca.tipo_valore of
			VAL_NUMERO : lab.str_print := '0';
//			VAL_TESTO,
			VAL_BOOLEAN : lab.str_print := SQL_FALSE;
			else lab.str_print := ''
		end
	end
end;

// -----------------------------------------------------------------------------

procedure cl_runtime_field.browse_proc(sender : TObject);
begin
	{$ifdef DEBUG} assert(xstr <> NIL, 'browse_proc() -- JDEJ 9310'); {$endif}
	var s : string := xstr.Text;
	var str_filter := lab.str_runtime_filename_filter;
	sostituisci(str_filter, '*.', '');
	sostituisci(str_filter, ';', ' ');
	if browse_for_files_open(get_form(xstr), {caption}'', s, {str_default_ext}'',
		{str_files_filter}ifs(str_filter, 'files ' + str_filter + '|' + lab.str_runtime_filename_filter),
		lab.str_runtime_path, {bo_relative_path}FALSE, {bo_file_must_exists}TRUE) then xstr.Text := s
end;

initialization
	galateo_initialization_debug('runtime_proc')
finalization
	galateo_finalization_debug('runtime_proc');
{$ifdef DEBUG}
	CCI(i_runtime_field, 'cl_runtime_field', 'runtime_proc.pas');
	CCI(i_runtime_field_elenco, 'cl_runtime_field_elenco', 'runtime_proc.pas')
{$endif DEBUG}
end.
