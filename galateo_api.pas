unit galateo_api;		// API di authoring: pilotaggio esterno di GALATEO.EXE via named pipe + JSON -- 2026-07-17

{$ifNdef GALATEO_EXE}	*** GALATEO_EXE required ***	{$endif}	// solo il designer sa creare e modificare un report
{$ifdef DLL}				*** DLL forbidden ***			{$endif}	// CASA.DLL sa solo leggere un .GAL, non modificarlo

interface

uses Winapi.Windows, System.Classes, System.SysUtils, System.JSON,
	gdich;

const
	API_PIPE_ROOT = '\\.\pipe\';
	API_PIPE_BASE = 'galateo_api_';						// il client enumera \\.\pipe\ cercando questo prefisso
	API_PROTOCOL_VERSION = 2;								// incrementare ad ogni modifica NON retrocompatibile del protocollo
	API_BUFFER_SIZE = 65536;
	API_PARM = '/API';										// /API:nomepipe sovrascrive il nome della pipe
	API_PARM_OFF = '/NOAPI';								// unico modo per spegnere il server: di default e' acceso
	API_LF = #10;												// il protocollo e' JSON Lines: una richiesta per riga, una risposta per riga

procedure api_start(str_pipe_name : string = '');
procedure api_start_default;
procedure api_stop;
function api_attivo : boolean;
function api_get_pipe_name : string;
function api_pipe_name_default : string;
function api_da_riga_comando(var str_pipe_name : string) : boolean;
function api_esegui(str_request : string) : string;
	{ esegue una richiesta JSON e rende la risposta JSON;
	  DEVE girare sul main thread: gli oggetti del report SONO controlli VCL (TLabel/TImage/TPaintBox) }

implementation

uses System.TypInfo, pages, Gun, objects, objsx, sezione, misure, galateo_main;

type
	cl_api_error = class(Exception);		// errore applicativo: viene reso al client come {"ok":false,"error":...}

	cl_api_server = class(TThread)
		private
			fstr_pipe_name : string;
			fstr_request : string;
			fstr_response : string;
			procedure esegui_sul_main_thread;
			procedure sblocca_connect;
			procedure tratta_client(h_pipe : THandle);
		protected
			procedure Execute; override;
		public
			constructor create_server(str_pipe_name : string);
			destructor Destroy; override;
	end;

var
	api_server : cl_api_server = NIL;
	str_api_pipe_name : string = '';

procedure api_error(str_msg : string);
begin
	raise cl_api_error.Create(str_msg)
end;

// ------------------- HELPERS JSON --------------------------------------------

function jnum(fl : misura_real_type) : TJSONNumber;
// TJSONNumber da una misura in cm; 3 decimali sono ampiamente sufficienti e tengono corto il JSON
begin
	result := TJSONNumber.Create(round(fl * 1000) / 1000)
end;

function jenum(pti : PTypeInfo;i_valore : integer) : TJSONString;
// rende il NOME del valore enumerato: il client ragiona su 'LABEL_OBJ', non su 1
begin
	result := TJSONString.Create(GetEnumName(pti, i_valore))
end;

function jo_get_string(jo : TJSONObject;str_name : string;str_default : string = '') : string;
begin
	result := str_default;
	if (jo = NIL) then exit;
	var jv := jo.GetValue(str_name);
	if (jv <> NIL) AND NOT (jv is TJSONNull) then result := jv.Value
end;

// ------------------- DESCRIZIONE DEL REPORT ----------------------------------

function descrivi_oggetto(i_obj_1B : obj_index_type;i_page_1B : logical_page_type) : TJSONObject;
var ox : objs_type;
begin
	result := TJSONObject.Create;
	try
		result.AddPair('index', TJSONNumber.Create(i_obj_1B));
		ox := xobjs(i_obj_1B, i_page_1B);
		if (ox = NIL) then exit;
		{ l'identita' dell'oggetto per il client e' il NOME, non l'indice:
		  DELETE_OBJECT compatta l'array e rinumera tutto quanto sta sotto }
		result.AddPair('name', ox.get_name);
		result.AddPair('obj_type', jenum(TypeInfo(obj_type), ord(ox.tipo_oggetto)));
		result.AddPair('var_type', jenum(TypeInfo(variabile_type), ord(ox.tipo_variabile)));
		result.AddPair('section', TJSONNumber.Create(ox.ca.i_section_1B));
		// le posizioni sono pixel video relativi al panel della sezione: al client servono cm
		result.AddPair('left_cm', jnum(video2cm_x(ox.get_left)));
		result.AddPair('top_cm', jnum(video2cm_y(ox.get_top)));
		result.AddPair('width_cm', jnum(video2cm_x(ox.get_width)));
		result.AddPair('height_cm', jnum(video2cm_y(ox.get_height)));
		if (ox.ca.str_formula <> '') then result.AddPair('formula', ox.ca.str_formula);
		if (ox.ca.str_SQL_expression <> '') then result.AddPair('sql_expression', ox.ca.str_SQL_expression);
		if (ox.ca.str_print_if <> '') then result.AddPair('print_if', ox.ca.str_print_if);
		if (ox.ca.str_esempio_value <> '') then result.AddPair('esempio_value', ox.ca.str_esempio_value)
	except
		result.Free;
		raise
	end
end;

function descrivi_sezione(i_section_1B : section_index_type;i_page_1B : logical_page_type) : TJSONObject;
var sez : cl_sezione;
begin
	result := TJSONObject.Create;
	try
		result.AddPair('index', TJSONNumber.Create(i_section_1B));
		sez := sections_1B(i_section_1B, i_page_1B);
		if (sez = NIL) then exit;
		result.AddPair('name', sez.str_nome);
		result.AddPair('father', TJSONNumber.Create(sez.i_father_ZB + 1));		// 0 = nessun padre (e' la MAIN)
		result.AddPair('y0_rel_cm', jnum(sez.r_y0_rel_cm));
		result.AddPair('y_gruppo_cm', jnum(sez.r_y_gruppo_cm));
		result.AddPair('y_sezione_cm', jnum(sez.r_y_sezione_cm));
		result.AddPair('autosize', TJSONBool.Create(sez.bo_autosize));
		if (sez.str_SQL <> '') then result.AddPair('sql', sez.str_SQL)
	except
		result.Free;
		raise
	end
end;

function descrivi_pagina(i_page_1B : logical_page_type) : TJSONObject;
var lpi : cl_logical_page_info;
begin
	result := TJSONObject.Create;
	try
		result.AddPair('index', TJSONNumber.Create(i_page_1B));
		// i metadati della pagina stanno su CL_LOGICAL_PAGE_INFO, la struttura su CL_LOGICAL_PAGE: due classi distinte
		lpi := get_logical_page_1B(i_page_1B);
		if (lpi <> NIL) then begin
			result.AddPair('id', lpi.str_page_ID);
			result.AddPair('descrizione', lpi.str_descrizione_breve);
			result.AddPair('external', TJSONBool.Create(lpi.bo_external));
			if lpi.bo_external then result.AddPair('external_filename', lpi.str_external_filename)
		end;
		var ja_sezioni := TJSONArray.Create;
		result.AddPair('sections', ja_sezioni);
		for var i : section_index_type := 1 to get_num_sections_page(i_page_1B) do
			ja_sezioni.AddElement(descrivi_sezione(i, i_page_1B));
		var ja_oggetti := TJSONArray.Create;
		result.AddPair('objects', ja_oggetti);
		for var i : obj_index_type := 1 to i_objs(i_page_1B) do
			ja_oggetti.AddElement(descrivi_oggetto(i, i_page_1B))
	except
		result.Free;
		raise
	end
end;

// ------------------- COMANDI -------------------------------------------------

function cmd_ping : TJSONValue;
// rende tutto cio' che serve al client per elencare le istanze aperte senza doversi leggere ogni report
begin
	var jo := TJSONObject.Create;
	jo.AddPair('pong', TJSONBool.Create(TRUE));
	jo.AddPair('protocol', TJSONNumber.Create(API_PROTOCOL_VERSION));
	jo.AddPair('pipe', str_api_pipe_name);
	jo.AddPair('pid', TJSONNumber.Create(GetCurrentProcessId));
	var bo_loaded := (globale <> NIL) AND (globale.str_filename <> '');
	jo.AddPair('report_loaded', TJSONBool.Create(bo_loaded));
	if bo_loaded then jo.AddPair('filename', globale.str_filename);
	result := jo
end;

function cmd_report_describe : TJSONValue;
begin
	if (globale = NIL) then api_error('GALATEO non e'' ancora inizializzato');
	var jo := TJSONObject.Create;
	try
		jo.AddPair('filename', globale.str_filename);
		jo.AddPair('modified', TJSONBool.Create(GM.bo_modified));
		jo.AddPair('pages_count', TJSONNumber.Create(globale.i_pagine_logiche));
		jo.AddPair('active_page', TJSONNumber.Create(get_pagina_logica_attiva_1B));
		jo.AddPair('active_section', TJSONNumber.Create(get_section_attiva_1B));
		var ja := TJSONArray.Create;
		jo.AddPair('pages', ja);
		for var i : logical_page_type := 1 to globale.i_pagine_logiche do ja.AddElement(descrivi_pagina(i));
		result := jo
	except
		jo.Free;
		raise
	end
end;

function api_dispatch(str_cmd : string;jo_args : TJSONObject) : TJSONValue;
begin
	result := NIL;
	if (str_cmd = 'ping') then result := cmd_ping
	else if (str_cmd = 'report.describe') then result := cmd_report_describe
	else api_error('comando sconosciuto: ' + str_cmd)
end;

function api_esegui(str_request : string) : string;
var jo_request : TJSONObject;
	jo_response : TJSONObject;
begin
	jo_request := NIL;
	jo_response := TJSONObject.Create;
	try
		try
			jo_request := TJSONObject.ParseJSONValue(str_request) as TJSONObject;
			if (jo_request = NIL) then api_error('richiesta JSON non valida');
			var str_cmd := jo_get_string(jo_request, 'cmd');
			if (str_cmd = '') then api_error('campo "cmd" mancante');
			// API_DISPATCH per prima: se solleva, il JO_RESPONSE parziale viene comunque buttato dall'EXCEPT
			var jv_result := api_dispatch(str_cmd, jo_request.GetValue('args') as TJSONObject);
			jo_response.AddPair('ok', TJSONBool.Create(TRUE));
			jo_response.AddPair('result', jv_result)
		except
			on e : Exception do begin
				{ nessuna eccezione deve raggiungere il thread della pipe, ne' tantomeno una messagebox:
				  l'errore torna al client come dato }
				jo_response.Free;
				jo_response := TJSONObject.Create;
				jo_response.AddPair('ok', TJSONBool.Create(FALSE));
				jo_response.AddPair('error', e.Message);
				jo_response.AddPair('error_class', e.ClassName)
			end
		end;
		result := jo_response.ToJSON
	finally
		jo_response.Free;
		jo_request.Free
	end
end;

// ------------------- SERVER (named pipe) -------------------------------------

function indice_LF(const tb : TBytes) : integer;
// posizione del primo LF nel buffer, -1 se non c'e'
begin
	for var i : integer := 0 to high(tb) do
		if (tb[i] = 10) then exit(i);
	result := -1
end;

constructor cl_api_server.create_server(str_pipe_name : string);
{ NB: qui NON si chiama START.
  TThread.AfterConstruction gira DOPO il corpo del costruttore ed e' lui a fare lo start: uno START anticipato
  provoca un'eccezione, il compilatore chiama il distruttore, e la WAITFOR dentro TThread.Destroy si inchioda
  per sempre sulla CONNECTNAMEDPIPE -- con GALATEO che non mostra nemmeno la finestra.
  Lo START lo fa API_START, a costruzione conclusa }
begin
	inherited Create({CreateSuspended}TRUE);
	FreeOnTerminate := FALSE;
	fstr_pipe_name := str_pipe_name
end;

procedure cl_api_server.sblocca_connect;
{ si collega alla propria pipe per sbloccare la CONNECTNAMEDPIPE:
  e' bloccante e non guarda TERMINATED, quindi senza un client che arriva non tornerebbe mai }
begin
	var h := CreateFile(PChar(fstr_pipe_name), GENERIC_READ OR GENERIC_WRITE, 0, NIL, OPEN_EXISTING, 0, 0);
	if (h <> INVALID_HANDLE_VALUE) then CloseHandle(h)
end;

destructor cl_api_server.Destroy;
// TThread.Destroy fa Terminate + WaitFor: senza lo sblocco qui sotto, chiunque liberi il server inchioda GALATEO
begin
	Terminate;
	sblocca_connect;
	inherited
end;

procedure cl_api_server.esegui_sul_main_thread;
begin
	fstr_response := api_esegui(fstr_request)
end;

procedure cl_api_server.tratta_client(h_pipe : THandle);
var buf : array[0..API_BUFFER_SIZE-1] of byte;
	tb : TBytes;
	dw_letti, dw_scritti : DWORD;
begin
	tb := NIL;
	while NOT Terminated do begin
		if NOT ReadFile(h_pipe, buf[0], length(buf), dw_letti, NIL) then exit;
		if (dw_letti = 0) then exit;
		var i_base := length(tb);
		setlength(tb, i_base + integer(dw_letti));
		move(buf[0], tb[i_base], dw_letti);
		// protocollo JSON Lines: tratto tutte le richieste complete presenti nel buffer
		var i_nl := indice_LF(tb);
		while (i_nl >= 0) do begin
			fstr_request := TEncoding.UTF8.GetString(tb, 0, i_nl).Trim;
			fstr_response := '';
			if (fstr_request <> '') AND NOT Terminated then
				Synchronize(esegui_sul_main_thread);		// il modello e' VCL: si tocca SOLO dal main thread
			if (fstr_response <> '') then begin
				var tb_out := TEncoding.UTF8.GetBytes(fstr_response + API_LF);
				if NOT WriteFile(h_pipe, tb_out[0], length(tb_out), dw_scritti, NIL) then exit;
				FlushFileBuffers(h_pipe)
			end;
			var i_resto := length(tb) - (i_nl + 1);
			if (i_resto > 0) then move(tb[i_nl + 1], tb[0], i_resto);
			setlength(tb, i_resto);
			i_nl := indice_LF(tb)
		end
	end
end;

procedure cl_api_server.Execute;
begin
	NameThreadForDebugging('galateo_api');
	while NOT Terminated do begin
		var h_pipe := CreateNamedPipe(PChar(fstr_pipe_name), PIPE_ACCESS_DUPLEX,
			PIPE_TYPE_BYTE OR PIPE_READMODE_BYTE OR PIPE_WAIT,
			PIPE_UNLIMITED_INSTANCES, API_BUFFER_SIZE, API_BUFFER_SIZE, 0, NIL);
		if (h_pipe = INVALID_HANDLE_VALUE) then begin
			sleep(1000);		// pipe non creabile: riprovo senza inchiodare la CPU
			continue
		end;
		try
			if ConnectNamedPipe(h_pipe, NIL) OR (GetLastError = ERROR_PIPE_CONNECTED) then
				if NOT Terminated then tratta_client(h_pipe);
			DisconnectNamedPipe(h_pipe)
		finally
			CloseHandle(h_pipe)
		end
	end
end;

// ------------------- AVVIO / ARRESTO -----------------------------------------

function api_attivo : boolean;
begin
	result := (api_server <> NIL)
end;

function api_get_pipe_name : string;
begin
	result := str_api_pipe_name
end;

function api_pipe_name_default : string;
{ una pipe per istanza, distinta dal PID.
  Piu' GALATEO aperti insieme sono la norma, non l'eccezione: con un solo nome di pipe condiviso
  Windows assegna il client a un'istanza qualsiasi fra quelle libere, e un LLM finirebbe per leggere
  un report e scriverne un altro -- senza che nessuno se ne accorga, visto che l'undo non esiste }
begin
	result := API_PIPE_ROOT + API_PIPE_BASE + GetCurrentProcessId.ToString
end;

function api_da_riga_comando(var str_pipe_name : string) : boolean;
{ rende FALSE solo se c'e' /NOAPI: il server e' acceso di default perche' GALATEO viene lanciato spesso
  da JOLLY su un report gia' aperto, e in quel caso la riga di comando non la scriviamo noi.
  /API:nomepipe sovrascrive il nome della pipe, col prefisso \\.\pipe\ o senza.
  NB: READ_PARMS (proc.pas) scarta tutto cio' che inizia per /A e ignora esplicitamente /NOAPI }
begin
	result := TRUE;
	str_pipe_name := api_pipe_name_default;
	for var i : smallint := 1 to paramcount do begin
		var s := paramstr(i);
		if (uppercase(s) = API_PARM_OFF) then begin
			result := FALSE;
			continue
		end;
		if (uppercase(copy(s, 1, length(API_PARM))) <> API_PARM) then continue;
		delete(s, 1, length(API_PARM));
		if (copy(s, 1, 1) <> ':') then continue;
		delete(s, 1, 1);
		if (s = '') then continue;
		if (copy(s, 1, 2) = '\\') then str_pipe_name := s else str_pipe_name := API_PIPE_ROOT + s
	end
end;

procedure api_start(str_pipe_name : string = '');
begin
	if (api_server <> NIL) then exit;		// gia' attivo
	if (str_pipe_name = '') then str_pipe_name := api_pipe_name_default;
	str_api_pipe_name := str_pipe_name;
	api_server := cl_api_server.create_server(str_pipe_name);
	api_server.Start		// START qui, non nel costruttore: vedi il commento su CREATE_SERVER
end;

procedure api_start_default;
// il server e' acceso di default; si spegne solo con /NOAPI
begin
	var str_pipe_name : string := '';
	if api_da_riga_comando(str_pipe_name) then api_start(str_pipe_name)
end;

procedure api_stop;
begin
	if (api_server = NIL) then exit;
	api_server.Free;		// il distruttore fa Terminate + sblocco della ConnectNamedPipe + WaitFor
	api_server := NIL
end;

end.