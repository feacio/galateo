unit sp_galateo;			// gestione interfaccia con le STORED PROCEDURES

{$I defines}

interface

uses DB, Classes, Sysutils, Windows, Variants, FireDAC.Comp.Client, FireDAC.Stan.Param,
	Fcommons, gdich;

const
	SP_MAX_PARMS = 13;		// # max di parametri per una stored procedure; 1 viene tuttavia riservato per il risultato
	MAX_STORED_PROCS = 12;	// numero max di stored procs definibili
type
	sp_parm_type = record
		str_name : string;
		ParamType: TParamType;
		data_type : TFieldType
	end;
	sp_punt = ^xsp_type;
	xsp_type = object	// record di archiviazione valori per stored procedures
		str_sp_name : string;								// nome della stored procedure
		i_parms : byte;											// # di parametri della store proc
		tipo_res : TFieldType;									// tipo di risultato della funzione
		parms : array[1..SP_MAX_PARMS] of sp_parm_type;	// definizione dei parms
{$ifdef DEBUG} i_max_parms : 1..1; {$endif}		// numero di parametri, debugging-useful
		procedure reset;
		function load(var s : string) : boolean;
	end;
	sp_parm_array_type = array[1..SP_MAX_PARMS] of variant;

(*const
		SP_LINGUA_TRANSLATE : xsp_type = (str_sp_name:'lingua_translate';
			{$ifdef DEBUG}i_max_parms:12;{$endif}i_parms:2;
			 parms:(
			  (str_name:'@str_codice_item';ParamType:ptInput;data_type:ftString),
			  (str_name:'@str_lingua';ParamType:ptInput;data_type:ftString),
			  (str_name:'lingua_translate';ParamType:ptResult;data_type:ftString),
			  (str_name:'';ParamType:ptUnknown;data_type:ftUnknown),
			  (str_name:'';ParamType:ptUnknown;data_type:ftUnknown),
			  (str_name:'';ParamType:ptUnknown;data_type:ftUnknown),
			  (str_name:'';ParamType:ptUnknown;data_type:ftUnknown),
			  (str_name:'';ParamType:ptUnknown;data_type:ftUnknown),
			  (str_name:'';ParamType:ptUnknown;data_type:ftUnknown),
			  (str_name:'';ParamType:ptUnknown;data_type:ftUnknown),
			  (str_name:'';ParamType:ptUnknown;data_type:ftUnknown),
			  (str_name:'';ParamType:ptUnknown;data_type:ftUnknown),
			  (str_name:'';ParamType:ptUnknown;data_type:ftUnknown))); *)

function load_stored_procs(tstr : TStrings;bo_msg : boolean) : boolean;
function get_stored_proc(i_index : byte) : sp_punt;
function exec_stored_proc(str_db_name : string;var str_stored_proc, str_result : string;bo_test_only,bo_interpreta_parametri : boolean) : smallint;
function get_stored_proc_by_name(str_nome : string) : smallint;
function internal_tipo_res(ft : TFieldType) : risultato_type;		// traduce nel formato interno

implementation

uses FAssert, FXStrings, FStrings, FErrMsg, Fdata, Ftime, FSQLsoft, FMessage, FSystem_base, FSystem, FDB,
	galateo_debug, proc, pages, functions;

const
	MBOX_CAPTION = 'Stored procedures';
	NUM_SP_PARM_TYPES = 6;		// possibili tipi di parametri delle stored procedures
	SP_PARM_TYPE_NAMES : array[1..NUM_SP_PARM_TYPES] of string =
		('STRING','DOUBLE','INTEGER','SMALLINT','CURRENCY','VOID');
	SP_PARM_TYPE_TYPES : array[1..NUM_SP_PARM_TYPES] of TFieldType =
		(ftString,ftFloat,ftInteger,ftSmallint,ftCurrency,ftUnknown);
var
	sp_def : array[1..MAX_STORED_PROCS] of xsp_type;	// contenitore definizioni stored procs
	i_stored_procs : byte;	// numero di stored procedure contenuto in sp_def

function get_stored_proc(i_index : byte) : sp_punt;
// rende un puntatore alla stored procedure richiesta, oppure NIL in caso di errore
begin
	if (i_index > 0) AND (i_index <= i_stored_procs) then result := @sp_def[i_index]
	else begin
		{$ifdef DEBUG} assert(FALSE,'index out of rangex AXM 914'); {$endif}
		result := NIL
	end
end;

function internal_tipo_res(ft : TFieldType) : risultato_type;		// traduce nel formato interno
begin
	{$ifdef DEBUG} assert(ft in [ftString,ftFloat,ftInteger,ftSmallint,ftCurrency],'QEP 188'); {$endif}
	if (ft = ftString) then result := VAL_TESTO
	else result := VAL_NUMERO
end;

procedure xsp_type.reset;
var i : smallint;
begin
	str_sp_name := '';i_parms := 0;tipo_res := ftUnknown;
	for i := 1 to SP_MAX_PARMS do with parms[i] do begin
		str_name := '';ParamType := ptUnknown;data_type := ftUnknown
	end
end;

function xsp_type.load(var s : string) : boolean;
{ carica la definizione della stored proc da S, secondo la sintassi sotto descritta;
  rende TRUE in caso di successo, FALSE altrimenti;
  se rende FALSE, in s viene inserita la descrizione dell'errore riscontrato }
var
	i : smallint;
	str_error_base,str_temp : string;
	bo_found : boolean;
begin
	result := FALSE;reset;
	// leggo il nome
	i := pos('(',s);if (i = 0) then begin s := 'Parentesi non trovata';exit end;
	str_sp_name := uppercase(copy(s,1,i-1));delete(s,1,i);
	// leggo il tipo di risultato

	tipo_res := ftUnknown;bo_found := FALSE;
	for i := 1 to NUM_SP_PARM_TYPES do begin
		if (uppercase(copy(s,length(s)-length(SP_PARM_TYPE_NAMES[i])+1,
			length(SP_PARM_TYPE_NAMES[i]))) = SP_PARM_TYPE_NAMES[i])
		then begin
			bo_found := TRUE;
			tipo_res := SP_PARM_TYPE_TYPES[i];				// tipo di risultato della funzione
			s := copy(s,1,length(s) - length(SP_PARM_TYPE_NAMES[i]));
			break
		end
	end;
	if NOT bo_found then begin s := 'Errore nel tipo di risultato';exit end;

	// verifico che ci siano i : tra parentesi e risultato
	s := togliblanks(s);
	if (copy(s,length(s),1) <> ':') then begin s := 'Errore nel tipo di risultato';exit end;
	s := togliblanks(copy(s,1,length(s)-1));

	// verifico la parentesi di chiusura
	if (copy(s,length(s),1) <> ')') then begin s := 'Parentesi non chiusa';exit end;
	s := togliblanks(copy(s,1,length(s)-1));

	i_parms := 0;
	while (s <> '') do begin
		inc(i_parms);
		if (i_parms > SP_MAX_PARMS-1) then begin s := 'Troppi parametri';exit end;		// -1 perchè c'è anche il risultato
		i := pos(':',s);
		str_error_base := 'parametro #' + inttostr(i_parms)+': ';
		if (i = 0) then begin s := str_error_base + 'errore sul parametro';exit end;
		parms[i_parms].str_name := copy(s,1,i-1);delete(s,1,i);
		i := pos(',',s);if (i = 0) then i := length(s)+1;
		str_temp := uppercase(copy(s,1,i-1));
		parms[i_parms].ParamType := ptInput{Output};

		delete(s,1,i);s := togliblanks(s);

		parms[i_parms].data_type := ftUnknown;
		for i := 1 to NUM_SP_PARM_TYPES do begin
			if (uppercase(str_temp) = SP_PARM_TYPE_NAMES[i]) then begin
				parms[i_parms].data_type := SP_PARM_TYPE_TYPES[i];
				break
			end
		end;
		if (parms[i_parms].data_type = ftUnknown) then begin
			s := str_error_base + 'tipo parametro non valido o non riconosciuto';exit	// VOID non è accettato
		end
	end;
	result := TRUE		// tutto ok, finalmente
end;

function load_stored_procs(tstr : TStrings;bo_msg : boolean) : boolean;
{ carica su SP_DEFINITION le stored procedures contenute, una per riga, in TSTR;
  rende TRUE se tutto ok, FALSE se ci sono errori (nel qual caso non carica nulla);
  if BO_MSG then emette eventuali messaggi di errore }
var
	i : smallint;
	s : string;
begin
	i_stored_procs := 0;	// resetto tutti i parms preesistenti
	result := TRUE;
	for i := 0 to tstr.Count-1 do begin
		s := togliblanks(tstr[i]);
		if is_commento(s) then continue;
		if (i_stored_procs = MAX_STORED_PROCS) then begin
			if bo_msg then MessageBBox(0, 'max ' + inttostr(MAX_STORED_PROCS) + ' stored procedures', MBOX_CAPTION, MB_ICONSTOP);
			break
		end;
		inc(i_stored_procs);
		if NOT sp_def[i_stored_procs].load(s) then begin
			if bo_msg then MessageBBox(0,s + ACAPO2 + tstr[i],MBOX_CAPTION,MB_ICONSTOP);
			break
		end
	end;
	if NOT result then i_stored_procs := 0;		// azzero tutto (virtualmente, ma efficacemente)
end;

function execute_stored_proc(str_databasename : string;sp_data : sp_punt;var vparms : sp_parm_array_type;
	bo_show_error_msg : boolean = FALSE;pt_string_SQL : string_punt = NIL) : variant;
{ esegue la stored procedure specificata;
  i parametri in SP_DATA deveno RIGOROSAMENTE essere nell'ordine in cui sono definiti nella funzione;
  rende il valore del primo parametro di tipo PTRESULT, se esiste, altrimenti
  rende quello del primo parametro di tipo PTOUTPUT, se esiste;
  mette tutti gli eventuali risultati in STR_PARMS;
  usare VARCLEAR() sul singolo parametro per assegnare il valore NULL;
  non offre protezione da exceptions, ovvero consente la gestione esterna delle stesse;
  se PT_STRING_SQL <> NIL carica su PT_STRING_SQL^ la chiamata alla procedure }
var
	sp : TFDStoredProc;
	parm : sp_parm_type;
	i,i_result : smallint;
	tp : TFDParam;
	dt : TDatetime;
	bo_string, bo_wait_cursor_set, bo_assign_value : boolean;
	str_value, str_exec, str_parametro : string;
begin
	varclear(result);
	bo_wait_cursor_set := FALSE;
	sp := TFDStoredProc.create(NIL);
	try
		sp.ConnectionName := str_databasename;
		i_result := 0;
//		with sp_data^ do begin
		sp.StoredProcName := sp_data.str_sp_name;
		for i := 1 to sp_data.i_parms do begin
			parm := sp_data.parms[i];
			if (parm.ParamType = ptResult) then i_result := i;
			{$ifdef DEBUG} assert(parm.str_name <> '','errore nel numero di parametri AGBK 3866'); {$endif}
			tp := sp.params.CreateParam(parm.data_type, parm.str_name, parm.ParamType);
			bo_assign_value := (parm.ParamType in [ptInput,ptInputOutput]);
//			if (parm.ParamType in [ptInput,ptInputOutput{,ptOutput,ptResult}]) then begin
//			if (ParamType in [ptInput,ptInputOutput,ptOutput{,ptResult}]) then begin
				if VarIsEmpty(vparms[i]) OR VarIsNull(vparms[i]) then begin
					tp.clear;str_value := ''
				end
				else case parm.data_Type of
					ftInteger : begin
						if bo_assign_value then tp.asInteger := vparms[i];
						str_value := inttostr(vparms[i])
					end;
					ftSmallint : begin
						if bo_assign_value then tp.asSmallint := vparms[i];
						str_value := inttostr(vparms[i])
					end;
					ftWord : begin
						if bo_assign_value then tp.asWord := vparms[i];
						str_value := inttostr(vparms[i])
					end;
					ftString: begin
						if bo_assign_value then tp.AsString := vparms[i];
						str_value := str2SQL(vparms[i])
					end;
					ftDate, ftDatetime : begin
						double(dt) := vparms[i];	// altrimenti il variant fa casino
						{$ifdef DEBUG} if (parm.data_type = ftDate) then assert(abs(round(dt) - dt) < 1e-6,'execute_SP() -- date vs datetime -- JMOP 7283'); {$endif}
//						if (parms[i].data_type = ftDate) then dt := round(dt);
						if bo_assign_value then tp.asDatetime := dt;
						if (parm.data_Type = ftDate) then str_value := dt2SQL(dt)
						else str_value := dttime2SQL(dt, TRUE, TMFMT_HMS)
					end;
					ftCurrency, ftFloat: begin
						if bo_assign_value then tp.asfloat := vparms[i];
						str_value := float2SQL(vparms[i])
					end
					else begin
						{$ifdef DEBUG} assert(FALSE,'execute_stored_proc(): tipo non gestito'); {$endif}
						str_value := '***UNDEFINED***'
					end
				end;
//				str_exec := str_exec + '/* ' + parms[i].str_name + ' = */ ' + str_value
//				if NOT (ParamType in [ptOutput,ptResult]) then		*** fino a 2010-02-11, cambiata per causa CABERG (SQLserver?)
//				{$ifdef DEBUG} assert(NOT (parm.ParamType in [ptOutput,ptResult]), 'DKWJ 4921'); {$endif}
				if (parm.ParamType <> ptResult) then begin
					str_parametro := ifs(str_exec, ', ') + parm.str_name + ' = ' + str_value;
					if (str_value = '') then str_parametro := '/* ' + str_parametro + ' */';
					add_delimited(str_exec, str_parametro, ACAPO)
				end
//			end
		end;
		{$ifdef DEBUG}
			for i := sp_data.i_parms + 1 to sp_data.i_max_parms do with sp_data.parms[i] do begin
				assert(str_name = '', 'execute_stored_proc(): errore nel numero di parametri XDFG 8401');
				assert(ParamType = ptUnknown, 'execute_stored_proc(): errore nel paramtype XDFG 8402');
				assert(data_type = ftUnknown, 'execute_stored_proc(): errore nel data_type XDFG 8403')
			end;
		{$endif}

		str_exec := 'execute ' + sp_data.str_sp_name + ACAPO + str_exec + ';';
		Gdebug_SQL(str_exec, 'STORED PROC');
		if (pt_string_SQL <> NIL) then pt_string_SQL^ := pt_string_SQL^ + ACAPO + str_exec + ACAPO2;
		bo_string := is_key_down(VK_MENU) AND is_key_down(VK_CONTROL) AND is_key_down(VK_SHIFT);
		if bo_string then error_msg(str_exec, 'caption', TRUE, MB_OK);

		try
			bo_wait_cursor_set := set_wait_cursor(TRUE,TRUE);
			sp.Prepare;
			try
				sp.ExecProc
			except
				if (bo_show_error_msg) then
					error_msg('Errore durante l''esecuzione della procedura', 'Stored Proc ' + sp_data.str_sp_name);
				raise
			end
		finally
			if bo_wait_cursor_set then set_wait_cursor(FALSE)
		end;
		{ metto tutti i parametri di output in STR_PARMS[];
		  rendo il parametro con PT_RESULT, oppure il primo degli altri in output }
		for i := 1 to sp_data.i_parms do begin
			tp := sp.params.ParamByName(sp_data.parms[i].str_name);
			if (tp.ParamType in [ptOutput,ptInputOutput,ptResult]) then begin
				vparms[i] := tp.value;
				// assegno il primo parametro PTRESULT
				if (i_result = i) then result := vparms[i];
				// se non assegnato, assegno il primo parametro output
				if (i_result = 0) then begin result := vparms[i];i_result := -1 end
			end
			else varclear(vparms[i])
		end
	finally
		sp.free
	end
end;	

(*function execute_stored_proc(str_db_name : string;sp_data : sp_punt;var vparms : sp_parm_array_type) : variant;
{ esegue la stored procedure specificata;
  i parametri in SP_DATA deveno RIGOROSAMENTE essere nell'ordine in cui sono definiti nella funzione;
  rende il valore del primo parametro di tipo PTRESULT, se esiste, altrimenti
  rende quello del primo parametro di tipo PTOUTPUT, se esiste;
  mette tutti gli eventuali risultati in STR_PARMS;
  non offre protezione da exceptions, che rappresentano l'unico modo di venire
  a conoscenza di eventuali errori di esecuzione }
var
	sp : TStoredProc;
	i,i_result : integer;
	tp : TParam;
	dt : TDatetime;
begin
	varclear(result);
	sp := TStoredProc.create(NIL);
	try
		set_wait_cursor(TRUE);
		sp.DatabaseName := str_db_name;
		i_result := 0;
		with sp_data^ do begin
			sp.StoredProcName := str_name;
			for i := 1 to i_parms do begin
				if (parms[i].ParamType = ptResult) then i_result := i;
				with parms[i] do begin
					{$ifdef DEBUG} assert(str_name <> '','errore nel numero di parametri ABK 866'); {$endif}
					tp := sp.params.CreateParam(data_type,str_name,ParamType);
					if (ParamType in [ptInput,ptInputOutput{,ptOutput,ptResult}]) then begin
						if VarIsEmpty(vparms[i]) then tp.clear
						else case data_Type of
							ftInteger,ftSmallint,ftWord : tp.AsInteger := vparms[i];
							ftString: tp.AsString := vparms[i];
							ftDate : begin
								double(dt) := vparms[i];	// altrimenti il variant fa casino
								tp.asDatetime := dt
							end;
							ftCurrency,ftFloat: tp.asfloat := vparms[i];
							{$ifdef DEBUG} else assert(FALSE,'execute_stored_proc(): tipo non gestito') {$endif}
						end
					end
				end
			end;
			{$ifdef DEBUG}
				for i := i_parms+1 to SP_MAX_PARMS do with sp_data^.parms[i] do begin
					assert(str_name = '','execute_stored_proc(): errore nel numero di parametri DFG 401');
					assert(ParamType = ptUnknown,'execute_stored_proc(): errore nel paramtype DFG 402');
					assert(data_type = ftUnknown,'execute_stored_proc(): errore nel data_type DFG 403')
				end
			{$endif}
		end;
		sp.Prepare;
		sp.ExecProc;
		with sp_data^ do begin
			{ metto tutti i parametri di output in STR_PARMS[];
			  rendo il parametro con PT_RESULT, oppure il primo degli altri }
			for i := 1 to i_parms do begin
				tp := sp.params.ParamByName(sp_data.parms[i].str_name);
				if (tp.ParamType in [ptOutput,ptInputOutput,ptResult]) then begin
					vparms[i] := tp.value;
					// assegno il primo parametro PTRESULT
					if (i_result = i) then result := vparms[i];
					// se non assegnato, assegno il primo parametro output
					if (i_result = 0) then begin result := vparms[i];i_result := -1 end
				end
				else varclear(vparms[i])
			end
		end
	finally
		sp.free;
		set_wait_cursor(FALSE)
	end
end;*)

function exec_stored_proc(str_db_name : string;var str_stored_proc, str_result : string;bo_test_only,bo_interpreta_parametri : boolean) : smallint;
{ richiama la procedure specificata, insieme ai suoi eventuali parametri, in s;
  pone il risultato in str_result;
  la parte di STR_FORMULA utilizzata dalla chiamata alla stored proc viene tolga da STR_STORED_PROC;
  se viene eseguita una stored proc rende l'indice della stored proc exeguita ( > 0);
  se non viene eseguita nessuna SP, rende 0;
  se si cerca di eseguire, ma si falla, rende -1 e pone in STR_RESULT un messaggio di errore;
  if BO_INTERPRETA_PARAMETRI then si cerca di interpretare i parametri; da utilizzarsi se la
  stored proc si trova in una sezione (no se si trova nell'intestazione della pagina) }
var
	i,i_parms,i_sp : smallint;
	s,str_temp : string;
	vparms : sp_parm_array_type;
	sp : sp_punt;
	tipo : risultato_type;
begin
	result := 0;s := togliblanks(str_stored_proc);
	i := pos('(',s);if (i = 0) then exit;		// non è una stored procedure
	str_temp := uppercase(copy(s,1,i-1));delete(s,1,i);

	i_sp := get_stored_proc_by_name(str_temp);
	if (i_sp = 0) then exit;	// non è una stored procedure
	sp := @sp_def[i_sp];i_parms := 0;

	i := get_delimitatore(s,')');	// cerco la chiusura della parentesi
	if (i = 0) then begin str_result := 'Parentesi non chiusa';result := -1;exit end;
	str_stored_proc := copy(s,i+1,MAXINT);	// tolgo dalla formula ciò che ho già interpretato
	setlength(s,i-1);	// tengo tutti i parametri

	if bo_test_only then begin	// solo una prova, per il momento si scherza
		if (sp.tipo_res = ftUnknown) then begin
			str_result := 'Le stored procedures utilizzate nelle formule devono restituire un risultato!';
			result := -1;exit
		end;
		if internal_tipo_res(sp.tipo_res) = VAL_TESTO then str_result := 'ABC' else str_result := '10';
		result := i_sp;exit
	end;

	try	// carico i parametri reali
		while get_parm(s,str_temp) do begin
			inc(i_parms);if (i_parms > SP_MAX_PARMS) then break;	// mi arenerò sul check del numero di parms
			vparms[i_parms] := str_temp
		end
	except
		str_result := 'errore non lontano dal parametro #' + inttostr(i_parms)
	end;
	if (i_parms <> sp.i_parms) then begin str_result := 'numero di parametri scorretto';result := -1;exit end;

	if bo_interpreta_parametri then begin	// blocco (re)inserito il 2001-04-23
		for i := 1 to i_parms do begin
			str_temp := vparms[i];
			if sections_ZB(0).interpreta_string(str_temp, {bo_stampa_vera}TRUE, {bo_check_errors}FALSE) then vparms[i] := str_temp
		end
	end;

	for i := 1 to i_parms do begin
		tipo := internal_tipo_res(sp.parms[i].data_type);
{		if NOT obj.translate_formula(vparms[i],str_temp,FALSE,tipo,0) then begin
			str_result := 'parametro #' + inttostr(i_parms)+ACAPO2+str_temp;result := -1;exit
		end; }
		if translate_formula(vparms[i],str_temp,FALSE,tipo,NIL) then vparms[i] := str_temp;
		// blocco aggiunto il 2004-07-20
		str_temp := vparms[i];
		if sections_ZB(0).interpreta_string(str_temp, {bo_stampa_vera}TRUE, {bo_check_errors}FALSE) then vparms[i] := str_temp
	end;
	// definizione parametro risultato della function
	with sp^ do if (tipo_res <> ftUnknown) then begin
		inc(i_parms);
		parms[i_parms].str_name := str_sp_name;
		parms[i_parms].ParamType := ptResult;
		parms[i_parms].data_type := tipo_res
	end;
	try
		str_result := execute_stored_proc(str_db_name, sp, vparms);
		result := i_sp
	except
		result := -1;str_result := get_last_exception_msg
	end;
	if (sp.tipo_res <> ftUnknown) then dec(sp.i_parms)
end;

function get_stored_proc_by_name(str_nome : string) : smallint;
// rende l'indice della stored proc a partire dal nome; rende 0 se la stored proccnon è stata riconosciuta
var i : smallint;
begin
	i := i_stored_procs;str_nome := uppercase(str_nome);
	while (i > 0) AND (str_nome <> sp_def[i].str_sp_name) do dec(i);
	result := i
end;

initialization
	galateo_initialization_debug('SP')
finalization
	galateo_finalization_debug('SP')
end.
