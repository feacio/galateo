unit expint_exec;		//* procedure di gestione delle EXPortazioni INTegrali -- con specifico riferimento alle procedure RUNTIME

{$I defines}

interface

uses Sysutils, VCL.Forms, Windows, Classes,
	Fcommons, FTP_proc, Gdich, expint_base, labels;

type
	cl_exec_expint_options = class		// opzioni di exportazione; serve per i dialogs di relazione con l'utente
		private
			function get_XML : boolean;
			function get_export_integrale : boolean;
		public
			str_target_export_filename : string;	// nomefile specifico per l'exportazione; se BLANK viene utilizzato il nome default (definito su GLOBAL)
//			bo_export_integrale : boolean;			// TRUE se export abilitato
			i_profilo : expint_index_type;
			// opzioni eventualmente modificate
			target : export_integrale_target_type;
			writemode : file_writemode_type;
			EFAT_action : export_file_action_type;
			str_comando_specifico : string;	// comando eseguito dopo il salvataggio del file (se not blank)
			FTP_parms : cl_FTP_parms;
			property bo_XML : boolean read get_XML;
			property bo_export_integrale : boolean read get_export_integrale;
			constructor create;
			destructor free;
{$ifdef CASA}
//			function runtime_select_sections(father : TForm;i_page_from, i_page_to : ph_page_type) : boolean;
			function runtime_select_sections(father : TForm;str_intervallo_pagine : string) : boolean;
{$endif CASA}
	end;

	cl_exec_expint_page = class;
	cl_exec_expint_sezione = class;

	cl_exec_expint_main = class
		private
			i_profilo : expint_index_type;
			pages : array of cl_exec_expint_page;
			expint_options : cl_exec_expint_options;		// contenitore delle opzioni da utilizzare per l'exportazione
		public
			constructor create(expint_options : cl_exec_expint_options);
			destructor free;
			function execute_export(father : TForm;str_target_filename : string;bo_overwrite_file : boolean;var bo_exported_something : boolean) : boolean;
			function writeln(i_pagina_logica_ZB : logical_page_type;i_sezione_ZB : section_index_type;lo_ID_sezione : integer;i_pagina_fisica : ph_page_type) : boolean;
			function write(i_pagina_logica_ZB : logical_page_type;i_sezione_ZB : section_index_type;lo_ID_sezione : integer;lab : cl_label) : boolean;
			function get_exec_expint_page_ZB(i_logical_page : logical_page_type) : cl_exec_expint_page;
	end;

	cl_exec_expint_page = class
		private
			i_profilo : expint_index_type;
			i_pagina_logica_ZB, i_pagina_logica_1B : logical_page_type;
			exp : cl_expint_page;
			bo_export : boolean;					// FALSE se la pagina NON deve essere exportata
			bo_actually_exported : boolean;	// TRUE se è stata effettivamente esportato almeno 1 elemento della pagina (ovvero: se deve essere exportato l'header)
			sezioni : array of cl_exec_expint_sezione;
			lines : array of string;
			str_output : string;
			bo_colonna_pagina_logica : boolean;		// TRUE se esiste la colonna della pagina logica; deriva (via valutazione) da xp.xbo_print_pagina_logica
			constructor ZB_create(i_profilo : expint_index_type;i_pagina_logica_ZB : logical_page_type);
			destructor free;
			function lines_as_text : string;
			function write(i_sezione_ZB : section_index_type;lo_ID_sezione : integer;lab : cl_label) : boolean;
			function writeln(i_sezione_ZB : section_index_type;lo_ID_sezione : integer;i_pagina_fisica : ph_page_type) : boolean;
			function execute_export(father : TForm;var lo_lines : integer;var bo_exported_something : boolean) : boolean;
		public
			function get_exec_expint_section_ZB(i_sezione : section_index_type) : cl_exec_expint_sezione;
	end;

	cl_exec_expint_sezione = class
		private
			i_profilo : expint_index_type;
			i_pagina_logica_ZB, i_pagina_logica_1B : logical_page_type;
			i_sezione_ZB, i_sezione_1B : section_index_type;
			lo_last_ID_sezione : integer;
			i_numero_record : integer;
			values : array of string;
			constructor ZB_create(i_profilo : expint_index_type;i_pagina_logica_ZB : logical_page_type;i_sezione_ZB : section_index_type);
			destructor free;
			function init : boolean;
			procedure reset;
			function get_section_ID : string;
			function get_headers : string;
			function write(lo_ID_sezione : integer;lab : cl_label) : boolean;
			function writeln(lo_ID_sezione : integer) : string;
		private
			{ TRUE se la sezione è ipoteticamente exportabile ad una analisi preliminare;
			  questa impostazione può essere modificata dalla eventuale forzatura dell'utente a runtime }
			bo_exportabile_preliminare : boolean;
			box_exportabile_runtime : xboolean;	// XNOTHING significa DEFAULT NON MODIFICATO; XTRUE e XFALSE rappresentano la forzatura del valore
			function get_originale_export_type : section_expint_mode_type;
			function get_exportabile_runtime : boolean;
			procedure set_exportabile_runtime(bo_exportabile : boolean);
		public
//			function default_export : boolean;	// TRUE se per default la sezione deve essere exportata
			property originale_export_type : section_expint_mode_type read get_originale_export_type;		// modalità originale di exportazione
			property bo_exportabile_runtime : boolean read get_exportabile_runtime write set_exportabile_runtime;
			procedure reset_exportabile_runtime;		// resetta il valore EXPORTABILE_RUNTIME
	end;

var export_integrale : cl_exec_expint_main;		// contiene l'oggetto runtime di EXPORT_INTEGRALE (no XML, è un'altra storia)

implementation

uses FAssert, FErrMsg, FSQLsoft, FXStrings, FStrings, FSystem_base, FSystem, FMessage,
	galateo_debug, domanda_multipla, multi_dialog, intervallo, proc, objects, pages;

{$ifdef DEBUG}
	var i_expint_options, i_export_integrale, i_export_integrale_pagina, i_export_integrale_sezione : smallint;
{$endif}

// --- cl_exec_expint_main ------------------------------------------------------

constructor cl_exec_expint_main.create(expint_options : cl_exec_expint_options);
begin
	{$ifdef DEBUG} inc(i_export_integrale); {$endif}
//	{$ifdef DEBUG} assert(intexp_options.bo_export_integrale,'DJHW 9289'); {$endif}
//	self.tipo := intexp_options.tipo;
	self.i_profilo := expint_options.i_profilo;
	self.expint_options := expint_options;
//	atarget := intexp_options.ytarget;if (atarget = EITT_DEFAULT) then atarget := globale.expint_default_target;
//	str_target_filename := intexp_options.xstr_target_filename;
	setLength(pages, get_ultima_pagina_logica);
	for var i : logical_page_type := 0 to get_ultima_pagina_logica - 1 do pages[i] := cl_exec_expint_page.ZB_create(i_profilo, i)
end;

destructor cl_exec_expint_main.free;
begin
	{$ifdef DEBUG} dec(i_export_integrale); {$endif}
	for var i : section_index_type := 0 to get_ultima_pagina_logica - 1 do pages[i].free;
	pages := NIL
end;

function cl_exec_expint_main.write(i_pagina_logica_ZB : logical_page_type;i_sezione_ZB : section_index_type;
	lo_ID_sezione : integer;lab : cl_label) : boolean;
{ registra l'export per l'oggetto specificato;
  rende TRUE in caso di successo, FALSE in caso di errore;
  evita di registrare twice l'exportazione per lo stesso LO_ID }
begin
	{$ifdef DEBUG} check_index(i_pagina_logica_ZB, 'cl_exec_expint_main.write()', 0, high(pages)); {$endif}
	result := pages[i_pagina_logica_ZB].write(i_sezione_ZB, lo_ID_sezione, lab)
end;

function cl_exec_expint_main.get_exec_expint_page_ZB(i_logical_page: logical_page_type): cl_exec_expint_page;
begin
	result := pages[i_logical_page]
end;

function cl_exec_expint_main.execute_export(father : TForm;str_target_filename : string;bo_overwrite_file : boolean;var bo_exported_something : boolean) : boolean;
// esegue fisicamente l'exportazione; BO_EXPORTED_SOMETHING vale TRUE se viene esportato davvero qualcosa, FALSE se non c'è nulla da exportare
const MBOX_CAPTION = 'Esportazione integrale';
var
//	wo_option : word;
	s{, str_filename} : string;
	f : text;
	bo : boolean;
	lo_lines_temp : integer;	//*
	local_writemode : file_writemode_type;	//*
begin
	result := FALSE;
	bo_exported_something := FALSE;
	var lo_lines : integer := 0;
	var handle : hwnd := get_handle(father);
{$ifdef DEBUG}
	if (expint_options.target = EITT_FTP) then begin
		assert(str_target_filename <> '', 'execute_export(FTP) -- nomefile non specificato');
		assert(NOT FileExists(str_target_filename), 'execute_export(FTP) -- file exists')
	end;
{$endif DEBUG}

	case expint_options.target of
//		EITT_CLIPBOARD : local_writemode := EFWT_DELETE;	// irrilevante
		EITT_FILE : local_writemode := expint_options.writemode;
		EITT_FTP : local_writemode := FWT_REWRITE		// la modalità APPEND può riferirsi solo alla successiva copia su FTP, non alla creazione del file transitorio
		else local_writemode := FWT_REWRITE				// prevalentemente per le pare del compilatore
	end;

	if (expint_options.target = EITT_FILE) AND (local_writemode = FWT_REWRITE) AND FileExists(str_target_filename) then begin
		if NOT bo_overwrite_file then begin
			case domanda_multipla_02_proc(father, MBOX_CAPTION, 'Il file ' + str_target_filename + ' esiste già.', 1,
				'Sovrascrivi il file', 'Annulla exportazione')
			of
				0, 2 : exit;
				1 : {bo_overwrite_file := TRUE};
				{$ifdef DEBUG} else assert(FALSE, 'EXPINT -- JKHT 3481') {$endif}
			end
		end;
		if {bo_overwrite_file AND} NOT SysUtils.DeleteFile(str_target_filename) then begin
			MessageBBox(handle, 'Impossibile eliminare il file ' + str_target_filename, MBOX_CAPTION, MB_ICONSTOP);
			exit
		end
	end;

	for var i : logical_page_type := 0 to high(pages) do begin
		if pages[i].bo_export then begin
			if NOT pages[i].execute_export(father, lo_lines_temp, bo) then exit;
			inc(lo_lines, lo_lines_temp);
			{if (bo) then} bo_exported_something := TRUE;
			s := s + pages[i].str_output
		end
	end;
	var ep : cl_expint_profilo := get_expint_profilo(i_profilo);
	if (ep.lo_expint_max_lines <> 0) AND (lo_lines > ep.lo_expint_max_lines) then
		MessageBBox(handle, 'Sono state esportate ' + puntato(lo_lines) + ' righe, ma il LIMITE ammesso è pari a ' + puntato(ep.lo_expint_max_lines), MBOX_CAPTION);

	if NOT bo_exported_something then begin
//		MessageBBox(handle, 'Non vi sono pagine logiche/sezioni exportabili', MBOX_CAPTION, MB_ICONSTOP);
		result := TRUE;exit
	end;

	if end_with(s, ACAPO) then delete(s, length(s) - length(ACAPO) + 1, MAXINT);
	case expint_options.target of
		EITT_CLIPBOARD: str2clipboard(s);
		EITT_FILE, EITT_FTP : begin
			try
				if (str_target_filename = '') then str_target_filename := changeFileExt(globale.str_filename, TEXT_EXT);
				assign(f, str_target_filename);
				if (local_writemode = FWT_APPEND) then begin
					{$I-} append(f); {$I+}
					if (IOresult <> 0) then rewrite(f)
				end
				else rewrite(f);
				system.write(f, s);		// no WRITELN perchè altrimenti si crea una riga vuota (in più) in fondo al file
				close(f)
			except
				error_msg(father, 'Errore durante la scrittura del file ' + str_target_filename, MBOX_CAPTION);
				exit
			end
		end;
		{$ifdef DEBUG} else assert(FALSE, 'EXPINT -- JDHW 9434') {$endif}
	end;

	result := TRUE
end;

function cl_exec_expint_main.writeln(i_pagina_logica_ZB : logical_page_type;i_sezione_ZB : section_index_type;
	lo_ID_sezione : integer;i_pagina_fisica : ph_page_type) : boolean;
// rende il numero di righe exportate (dopo quella passata come parametro: la prima chiamata rende 1)
begin
	result := pages[i_pagina_logica_ZB].writeln(i_sezione_ZB, lo_ID_sezione, i_pagina_fisica)
end;

// -- cl_exec_expint_page ----------------------------------------

constructor cl_exec_expint_page.ZB_create(i_profilo : expint_index_type;i_pagina_logica_ZB : logical_page_type);
// I_PAGINA_LOGICA: 1-based
begin
	{$ifdef DEBUG} inc(i_export_integrale_pagina); {$endif}
	self.i_profilo := i_profilo;
	self.i_pagina_logica_1B := i_pagina_logica_ZB + 1;
	self.i_pagina_logica_ZB := i_pagina_logica_ZB;
//	xp := globale.lpages_info[i_pagina_logica];
	exp := get_expint_page_ZB(i_profilo, i_pagina_logica_ZB);
	bo_colonna_pagina_logica := exp.bo_print_pagina_logica AND (exp.get_expint_sigla <> '');
	var i_sezioni_exportabili : section_index_type := 0;
	setLength(sezioni, get_num_sections_page(i_pagina_logica_ZB + 1));
	for var i_sezione_ZB : section_index_type := 0 to high(sezioni) do begin
		sezioni[i_sezione_ZB] := cl_exec_expint_sezione.ZB_create(i_profilo, i_pagina_logica_ZB, i_sezione_ZB);
		if sezioni[i_sezione_ZB].bo_exportabile_preliminare then inc(i_sezioni_exportabili)
	end;
//	self.bo_export := globale.lpages_info[i_pagina_logica].bo_export_allowed AND (i_sezioni_exportabili > 0)
	self.bo_export := exp.bo_export_allowed AND (i_sezioni_exportabili > 0)
end;

destructor cl_exec_expint_page.free;
begin
	{$ifdef DEBUG} dec(i_export_integrale_pagina); {$endif}
	for var i : section_index_type := 0 to get_num_sections_page(i_pagina_logica_ZB + 1) - 1 do sezioni[i].free;
	sezioni := NIL;lines := NIL
end;

function cl_exec_expint_page.write(i_sezione_ZB : section_index_type;lo_ID_sezione : integer;lab : cl_label): boolean;
{ registra l'export per l'oggetto specificato;
  rende TRUE in caso di successo, FALSE in caso di errore;
  evita di registrare twice l'exportazione per lo stesso LO_ID }
begin
	{$ifdef DEBUG} check_index(i_sezione_ZB, 'cl_exec_expint_page.write()', 0, high(sezioni)); {$endif}
	result := NOT bo_export OR sezioni[i_sezione_ZB].write(lo_ID_sezione, lab)
end;

function cl_exec_expint_page.writeln(i_sezione_ZB : section_index_type;lo_ID_sezione : integer;i_pagina_fisica : ph_page_type) : boolean;
// conclude l'exportazione per la sezione specificata; carica i dati exportati su LINES
begin
	if bo_export then begin
		bo_actually_exported := TRUE;
//		if sezioni[i_sezione_ZB].bo_exportabile_preliminare AND (lo_ID_sezione <> sezioni[i_sezione_ZB].lo_last_ID_sezione) then begin
		if sezioni[i_sezione_ZB].get_exportabile_runtime AND (lo_ID_sezione <> sezioni[i_sezione_ZB].lo_last_ID_sezione) then begin
			setLength(lines, length(lines) + 1);
			var str_separator : string := EIS_CHAR[get_expint_profilo(i_profilo).expint_separatore];
			lines[high(lines)] :=
				ifs(exp.bo_print_pagina_fisica, i_pagina_fisica.ToString + str_separator) +
				ifs(bo_colonna_pagina_logica, exp.get_expint_sigla + str_separator) +
				sezioni[i_sezione_ZB].writeln(lo_ID_sezione)
		end;
//		if (i_sezione < length(sezioni)) do sezioni[i_sezione{+1-1}].i_numero_record := 0	// resetto il numero di record delle sezioni successive
		while (i_sezione_ZB < length(sezioni)) do begin	// resetto il numero di record delle sezioni successive
			sezioni[i_sezione_ZB].i_numero_record := 0;
			inc(i_sezione_ZB)
		end
	end;
	result := TRUE
end;

function cl_exec_expint_page.execute_export(father : TForm;var lo_lines : integer;var bo_exported_something : boolean) : boolean;
{ BO_EXPORTED_SOMETHING vale TRUE se viene eseguita l'exportazione di almeno una sezione;
  LO_LINES contiene il numero di righe exportate }
begin
	bo_exported_something := FALSE;
	str_output := '';lo_lines := 0;
	var str_separatore : string := EIS_CHAR[get_expint_profilo(i_profilo).expint_separatore];

	if NOT bo_export OR NOT bo_actually_exported then begin result := TRUE;exit end;	// pagina non exportata, ma va bene così

//	if NOT ask_export_sections then abort;	**
	if exp.bo_print_headers AND bo_actually_exported then begin
		for var i : section_index_type := 0 to high(sezioni) do begin
//			if sezioni[i].bo_export AND NOT sezioni[i].bo_runtime_dont_export then begin
			if sezioni[i].bo_exportabile_runtime then begin
				bo_exported_something := TRUE;
//				if sections(sezioni[i].i_sezione, i_pagina_logica).bo_headers_colonne then begin
				if exp.expint_sections[sezioni[i].i_sezione_ZB].bo_headers_colonne then begin
					inc(lo_lines);
					str_output := str_output +
						ifs(exp.bo_print_pagina_fisica, str_separatore) +
						ifs(bo_colonna_pagina_logica, exp.get_expint_sigla + str_separatore) +
						sezioni[i].get_headers + ACAPO
				end
			end
		end;
		if exp.bo_blankrow_after_headers then begin	// lascio una riga di separazione tra headers e dati
			inc(lo_lines);
			str_output := str_output + ACAPO
		end
	end;
{	if (bo_exported_something) then begin
//		for i := 0 to high(lines) do str_output := str_output + lines[i] + ACAPO;
//		str_output := str_output + ACAPO;
		str_output := str_output + lines_as_text + ACAPO;
		inc(lo_lines, length(lines))
	end }
	str_output := str_output + lines_as_text;
	if (length(lines) <> 0) then begin
		str_output := str_output + ACAPO;
		inc(lo_lines, length(lines))
	end;
	result := TRUE
end;

function cl_exec_expint_page.get_exec_expint_section_ZB(i_sezione : section_index_type) : cl_exec_expint_sezione;
begin
	result := sezioni[i_sezione]
end;

function cl_exec_expint_page.lines_as_text : string;
// rende il contenuto di LINES in modo efficiente

	function add_lines(i_from, i_to : integer) : string;
	{ rende le LINES da I_FROM a I_TO comprese; valori ZERO-based;
	  in presenza di un numero elevato di righe, la generazione della stringa risultato per somma di ciascuna delle righe
	  può risultare MOLTO costosa, per la necessità di manipolare molte volte una stringa che diventa progressivamente molto lunga;
	  per questo motivo questa procedura spezza ricorsivamente il compito delle generazione della stringa risultato }
	const LIMITE_EXEC = 200;	// anche un'eccessiva ricorsione ha un costo, ed in ogni caso il vantaggio diventa consistente in presenza di numeri grandi
	begin
		result := '';
		if (i_to - i_from < LIMITE_EXEC) then
			for var i : integer := i_from to i_to do result := result + lines[i] + ACAPO
		else begin
			var i : integer := (i_from + i_to) div 2;
			result := add_lines(i_from, i-1) + add_lines(i, i_to)
		end
	end;

begin
	result := add_lines(0, high(lines))
//	{$ifdef DEBUG} ;assert(result = xxx, 'cl_exec_expint_page.lines_as_text -- DIFFERENT!!!') {$endif}
end;

// -- cl_exec_expint_sezione ----------------------------------------------

constructor cl_exec_expint_sezione.ZB_create(i_profilo : expint_index_type;i_pagina_logica_ZB : logical_page_type;i_sezione_ZB : section_index_type);
// i_pagina_logica e i_sezione: 1-based
begin
	{$ifdef DEBUG} inc(i_export_integrale_sezione); {$endif}
	self.i_profilo := i_profilo;
	self.i_pagina_logica_ZB := i_pagina_logica_ZB;
	self.i_pagina_logica_1B := i_pagina_logica_ZB + 1;
	self.i_sezione_ZB := i_sezione_ZB;
	self.i_sezione_1B := i_sezione_ZB + 1;
	// verifico a livello preliminare se la sezione deve essere realmente exportata; questa indicazione potrebbe essere modificata dall'indicazione dell'utente
	bo_exportabile_preliminare := sections_ZB(i_sezione_ZB, i_pagina_logica_ZB).exportabile_integrale(i_profilo, {runtime}FALSE);
//	xp := globale.lpages_info[i_pagina_logica];
	if NOT init then abort
end;

destructor cl_exec_expint_sezione.free;
begin
	{$ifdef DEBUG} dec(i_export_integrale_sezione); {$endif}
	values := NIL
end;

function cl_exec_expint_sezione.init : boolean;
// inizializza l'exportazione integrale per la sezione specificata
type
	tipo = record
		i_obj : obj_index_type;
		i_pos : integer
	end;
	tipo_array = array of tipo;
	tipo_array_punt = ^tipo_array;

	procedure insert(lab : cl_label;ptx : tipo_array_punt;i_pos : integer);
	begin
		var i : obj_index_type := 0;
		while (i < length(ptx^)) AND (ptx^[i].i_pos <= i_pos) do inc(i);
		setLength(ptx^, length(ptx^)+1);
		for var k : obj_index_type := high(ptx^)-1 downto i do ptx^[k+1] := ptx^[k];
		ptx^[i].i_obj := lab.ca.i_numero_obj;ptx^[i].i_pos := i_pos
	end;

	procedure assign(ptx : tipo_array_punt;var i_pos : obj_index_type);
	begin
		for var i : obj_index_type := 0 to high(ptx^) do begin
//			var lab : cl_label := xobjs(ptx^[i].i_obj, i_pagina_logica).aslabel;
			var exo : cl_expint_object := xobjs(ptx^[i].i_obj, i_pagina_logica_1B).aslabel.get_expint_object(i_profilo);
//			inc(i_pos, lab.i_skip_cols_before + 1);
			inc(i_pos, exo.i_skip_cols_before + 1);
//			lab.i_exec_export_pos := i_pos-1
			exo.i_exec_pos := i_pos-1
		end
	end;

var x_ass, x_unass : array of tipo;		// contenitore per ordinare i campi ASSigned e UNASSigned
begin
	result := TRUE;
	if NOT bo_exportabile_preliminare then exit;		// se non vi sono possibilità (neppure teoriche) di exportazione, non ho nulla da fare
	// looppo tra gli oggetti da exportare
	// gli oggetti che hanno un posizionamento (i_pos) vengono posizionati in ordine sulle colonne 1, 2, 3, ....
	// gli altri oggetti vengono messi in fila per posizione (LEFT-CORNER) e assegnati consecutivamente DOPO quelli già assegnati
	for var i : obj_index_type := 1 to i_objs(i_pagina_logica_1B) do begin
		var xobj : objs_type := xobjs(i, i_pagina_logica_1B);
		if (xobj.ca.i_section_1B <> i_sezione_1B) OR NOT (xobj.ca.tipo_oggetto in EXPINT_OBJS) then continue;
		var lab : cl_label := xobj.aslabel;
		lab.get_expint_object(i_profilo).i_exec_pos := 0;	// resetto, non si sa mai
		if NOT lab.ZB_get_integral_exportable(i_profilo, i_pagina_logica_ZB) then continue;	// skippo i fields da non exportare

		var i_pos : obj_index_type := lab.get_expint_object(i_profilo).i_pos;
		if (i_pos = 0) then insert(lab, @x_unass, xobj.get_left) else insert(lab, @x_ass, i_pos)
	end;

	// per scrupolo verifico l'ordinamento
{$ifdef DEBUG}
	for var i : obj_index_type := 0 to high(x_unass)-1 do assert(x_unass[i].i_pos <= x_unass[i+1].i_pos,'wrong sort UNASS -- LRTP 9934');
	for var i : obj_index_type := 0 to high(x_ass)-1 do assert(x_ass[i].i_pos <= x_ass[i+1].i_pos,'wrong sort ASSIGNED -- LRTP 9935');
{$endif}

	var i_pos : obj_index_type := 0;
	assign(@x_ass, i_pos);
	assign(@x_unass, i_pos);
	setLength(values, i_pos);
	x_ass := NIL;x_unass := NIL
end;

procedure cl_exec_expint_sezione.reset;
begin
//	i_numero_record := 0;
	for var i : obj_index_type := 0 to high(values) do values[i] := ''
end;

function cl_exec_expint_sezione.get_section_ID : string;
// rende l'ID che marca tutte le righe della sezione (xp.bo_print_sezione permettendo)
begin
//	result := coalesce(sections(i_sezione, i_pagina_logica).str_sigla, 'S/' + inttostr(i_sezione))
//	result := sections(i_sezione, i_pagina_logica).str_sigla;
//	result := sections(i_sezione, i_pagina_logica).str_sigla;
	result := get_expint_section_ZB(i_profilo, i_pagina_logica_ZB, i_sezione_ZB).str_sigla;
	if (result = '') then begin
		case i_sezione_ZB of
			0 : result := 'SP';	// Sezione Principale
			1 : result := '>';
			else result := 'ss/' + zeri(i_sezione_ZB + 1,2)
		end
	end
end;

function cl_exec_expint_sezione.get_headers : string;
begin
	var exp : cl_expint_page := get_expint_page_ZB(i_profilo, i_pagina_logica_ZB);
//	{$ifdef DEBUG} assert(sections(i_sezione, i_pagina_logica).bo_headers_colonne, 'sezione.bo_headers_colonne -- JTWR 7374'); {$endif}
	{$ifdef DEBUG} assert(exp.expint_sections[i_sezione_ZB].bo_headers_colonne, 'sezione.bo_headers_colonne -- JTWR 7374'); {$endif}
	reset;
	for var i : obj_index_type := 1 to i_objs(i_pagina_logica_1B) do begin
		var xobj : objs_type := xobjs(i, i_pagina_logica_1B);
		if (xobj.ca.i_section_1B <> i_sezione_1B) OR NOT (xobj.ca.tipo_oggetto in EXPINT_OBJS) then continue;
		var lab : cl_label := xobj.aslabel;
		var exo : cl_expint_object := lab.get_expint_object(i_profilo);
		if NOT lab.ZB_get_integral_exportable(i_profilo, i_pagina_logica_ZB) then continue;	// skippo i fields da non exportare
		{$ifdef DEBUG} check_index(exo.i_exec_pos, 'cl_exec_expint_sezione.get_headers()', 0, high(values)); {$endif}
		var s := coalesce(exo.str_header, lab.Caption);
		sections_1B(MAIN_SECTION, i_pagina_logica_1B).interpreta_string(s, {stampa_vera}TRUE, {check_errors}FALSE);
		values[exo.i_exec_pos] := s
	end;

	var sep : string := EIS_CHAR[get_expint_profilo(i_profilo).expint_separatore];
	result :=
		ifs(exp.bo_print_sezione, get_section_ID + sep) +
		ifs(exp.bo_print_record_number, sep);
	for var i : obj_index_type := 0 to high(values) do result := result + values[i] + ifs(i < high(values),sep);
	reset
end;

function cl_exec_expint_sezione.write(lo_ID_sezione : integer;lab : cl_label) : boolean;
{ registra l'export per l'oggetto specificato;
  rende TRUE in caso di successo, FALSE in caso di errore;
  evita di registrare twice l'exportazione per lo stesso LO_ID }
var s : string;
begin
	if bo_exportabile_runtime then begin
		{$ifdef DEBUG} assert(lab <> NIL, 'JKWM 8283'); {$endif}
		{$ifdef DEBUG} check_index(lab.get_expint_object(i_profilo).i_exec_pos, 'cl_exec_expint_sezione.write()', 0, high(values)); {$endif}
		if {bo_export AND} (lo_ID_sezione <> lo_last_ID_sezione) then begin
			var exo : cl_expint_object := lab.get_expint_object(i_profilo);
			if lab.bo_null then s := ifs(lab.ca.tipo_valore = VAL_NUMERO, '0', '')
			else s := lab.str_print;
			var sep : string := EIS_CHAR[get_expint_profilo(i_profilo).expint_separatore];
			var i_acapo : smallint := pos(ACAPO, s);
			var i_tab : smallint := pos(sep, s);
			if (i_acapo <> 0) OR (i_tab <> 0) then begin
				var bo_virgolette := FALSE;		// TRUE se il testo deve essere racchiuso tra virgolette

				if (i_acapo <> 0) then begin
					// racchiudo tra virgolette se in caso di multiline il formato lo prevede esplicitamente
					if (exo.multiline in [EXPINTML_EXCEL, EXPINTML_DOPPI_APICI]) then bo_virgolette := TRUE;
					case exo.multiline of
						EXPINTML_EXCEL : sostituisci(s, ACAPO, LF);
						EXPINTML_ONLY_FIRST_LINE : s := copy(s, 1, i_acapo-1);
						EXPINTML_NONE, EXPINTML_APICI, EXPINTML_DOPPI_APICI : begin
							sostituisci(s, ACAPO, coalesce(exo.str_acapo,'@'));
							if (exo.multiline = EXPINTML_APICI) then s := str2SQL(s)
						end;
						{$ifdef DEBUG} else assert(FALSE, 'multiline non gestito -- JUYW 0000') {$endif}
					end
				end;

				if (i_tab <> 0) then bo_virgolette := TRUE;	// 2009-03-11, in sostituzione del testo commentato qui sotto
(*				if (i_tab <> 0) AND (lab.str_expint_tab <> sep) AND (lab.multiline <> EXPINTML_EXCEL) then
					sostituisci(s, sep, coalesce(lab.str_expint_tab, '   '));

				// racchiudo fra virgolette in presenza di TABs non tradotti (qualora il formato non gestisca a parte il fatto)
				if (i_tab <> 0) AND (lab.str_expint_tab = sep) AND NOT (lab.multiline in [EXPINTML_APICI])
					then bo_virgolette := TRUE; *)
				if bo_virgolette then begin
					sostituisci(s, '"', '""');
					s := '"' + s + '"'
				end
			end;
			values[exo.i_exec_pos] := s
		end
	end;
	result := TRUE
end;

function cl_exec_expint_sezione.writeln(lo_ID_sezione : integer) : string;
{ chiude l'exportazione per la sezione; rende una stringa che rappresenta il valore dell'exportazione;
  resetta il contenuto della sezione }
begin
	if bo_exportabile_runtime AND (lo_ID_sezione <> lo_last_ID_sezione) then begin
		inc(i_numero_record);
		var sep : string := EIS_CHAR[get_expint_profilo(i_profilo).expint_separatore];
		var exp : cl_expint_page := get_expint_page_ZB(i_profilo, i_pagina_logica_ZB);
		result := ifs(exp.bo_print_sezione, get_section_ID + sep) +	ifs(exp.bo_print_record_number, i_numero_record.Tostring + sep);
		for var i : obj_index_type := 1 to exp.expint_sections[i_sezione_ZB].i_shift_columns do result := result + sep;

		var bo_delete_special_chars := get_expint_profilo(i_profilo).bo_delete_special_chars;
		for var i : obj_index_type := 0 to high(values) do begin
			if bo_delete_special_chars then values[i] := sostituisci(values[i], EXPINT_SPECIAL_CHARS_DELETED, '');
			result := result + values[i] + sep
		end;
		if end_with(result, sep) then delete(result, length(result) - length(sep) + 1, MAXINT);	// tolgo l'ultimo SEPARATORE
		lo_last_ID_sezione := lo_ID_sezione;		// per evitare che eventuali records spiattellati su più d'una pagina vengano ripetuti
		reset
	end
	else result := ''
end;

// --- end of EXPORT_INTEGRALE -------------------------------------------------

constructor cl_exec_expint_options.create;
begin
	{$ifdef DEBUG} inc(i_expint_options); {$endif}
//	i_profilo := globale.i_default_expint_profile;
	FTP_parms := cl_FTP_parms.Create(globale.FTP_parms);
	i_profilo := 0;
	var li_profilo : cl_expint_profilo := get_expint_profilo(i_profilo);
//	if (li_profilo.target_default = EITT_DEFAULT) then target := globale.expint_default_target else target := li_profilo.target_default;	*** eliminato 2015-04-18
	target := li_profilo.target_default;
//	if (li_profilo.writemode_default = FWT_DEFAULT) then ewritemode := globale.export_default_file_writemode else ewritemode := li_profilo.writemode_default; *** eliminato 2015-04-18
	writemode := li_profilo.writemode_default;
	EFAT_action := li_profilo.EFAT_default_action;
	str_comando_specifico := li_profilo.str_comando_specifico_default
end;

destructor cl_exec_expint_options.free;
begin
	{$ifdef DEBUG} dec(i_expint_options); {$endif}
	if (FTP_parms <> NIL) then begin FTP_parms.free;FTP_parms := NIL end
end;

function cl_exec_expint_options.get_XML : boolean;
begin
	if (i_profilo = -1) then result := FALSE
	else result := get_expint_profilo(i_profilo).bo_XML
end;

function cl_exec_expint_options.get_export_integrale : boolean;
begin
	if (i_profilo = -1) then result := FALSE
	else result := get_expint_profilo(i_profilo).bo_export_integrale
end;

// -----------------------------------------------------------------------------------------------------------------------------

procedure cl_exec_expint_sezione.reset_exportabile_runtime;		// resetta il valore EXPORTABILE_RUNTIME
begin
	box_exportabile_runtime := XNOTHING
end;

function cl_exec_expint_sezione.get_exportabile_runtime : boolean;
// rende TRUE se a RUNTIME la sezione deve essere exportata (dopo l'eventuale scelta manuale dell'utente)
begin
(*	case box_exportabile_runtime of
//		XNOTHING, XBOTH : result := (originale_export_type in [xOEXP_YES, xOEXP_DEFAULT]);		{$ifndef DEBUG} verificare valore OEXP_DEFAULT {$endif}
		XNOTHING, XBOTH : result := sections_ZB(i_sezione_ZB, i_pagina_logica_ZB).exportabile_integrale(i_profilo, {runtime}TRUE);
//		XTRUE, XFALSE : result := (box_exportabile_runtime = XTRUE)
		else result := (box_exportabile_runtime = XTRUE)
	end *)
	if (box_exportabile_runtime = XTRUE) then result := TRUE
	else result := sections_ZB(i_sezione_ZB, i_pagina_logica_ZB).exportabile_integrale(i_profilo, {runtime}TRUE)
end;

procedure cl_exec_expint_sezione.set_exportabile_runtime(bo_exportabile : boolean);
begin
	if bo_exportabile then box_exportabile_runtime := XTRUE else box_exportabile_runtime := XFALSE
end;

function cl_exec_expint_sezione.get_originale_export_type : section_expint_mode_type;
// originarie impostazioni di exportazione della sezione
begin
	result := get_expint_section_ZB(i_profilo, i_pagina_logica_ZB, i_sezione_ZB).expint_mode
end;

{$ifdef CASA}
//function cl_exec_expint_options.runtime_select_sections(father : TForm;i_page_from, i_page_to : ph_page_type) : boolean;
function cl_exec_expint_options.runtime_select_sections(father : TForm;str_intervallo_pagine : string) : boolean;
{ consente a runtime la selezione delle sezioni che devono essere exportate;
  rende TRUE in caso di successo, FALSE se bisogna annullare tutto }
var ndx_sezioni_ZB : array of section_index_type;		// contiene gli indici delle sezioni in trattamento
begin
	result := TRUE;
	var it : TStrings := NIL;

	// identifico la pagina logica stampata; se si tratta di PIU' pagine logiche, rinuncio al tentativo di scegliere le sezioni da exportare
//	var i_pagina_logica_1B : logical_page_type := get_pagina_logica_of_pagina_fisica_1B(i_page_from);
	var i_pagina_logica_1B : logical_page_type := get_pagina_logica_of_pagina_fisica_1B(get_intervallo_min(str_intervallo_pagine));
	// BO_PAGINE_LOGICHE_MULTIPLE = FALSE se esiste una sola pagina exportabile (fatto che consente la selezione delle sezioni)
//	var bo_pagine_logiche_multiple := (get_pagina_logica_of_pagina_fisica_1B(i_page_to) <> i_pagina_logica_1B);
	var bo_pagine_logiche_multiple := (get_pagina_logica_of_pagina_fisica_1B(get_intervallo_max(str_intervallo_pagine)) <> i_pagina_logica_1B);

//	if bo_pagine_logiche_multiple then exit;

	var expint_page : cl_exec_expint_page := export_integrale.get_exec_expint_page_ZB(i_pagina_logica_1B - 1);
	var bo_choose_runtime := get_expint_profilo(i_profilo).bo_choose_expint_sections;

	// se NON è consentita la scelta delle sezioni da exportare, assegno il valore (predefinito) della scelta definitiva;
	if NOT bo_choose_runtime OR bo_pagine_logiche_multiple then begin
		for var i : section_index_type := 0 to get_num_sections_page(i_pagina_logica_1B) - 1 do begin
			var exec_expint_section : cl_exec_expint_sezione := expint_page.get_exec_expint_section_ZB(i);
			exec_expint_section.bo_exportabile_runtime := (exec_expint_section.originale_export_type = SEXP_YES)
		end;

		if bo_choose_runtime AND bo_pagine_logiche_multiple then
			MessageBBox(get_handle(father),
				'Attenzione: l''opzione di selezione delle sezioni da exportare è disabilitata' + ACAPO +
					'perchè la stampa contiene più di una pagina logica', MBOX_CAPTION);

		exit
	end;

	// poichè è consentita la scelta delle sezioni da exportare, ripristino il valore default originale
	for var i : section_index_type := 0 to get_num_sections_page(i_pagina_logica_1B) - 1 do
		expint_page.get_exec_expint_section_ZB(i).reset_exportabile_runtime;

	try
		it := TStringList.create;
		var xs : byteset := [];
		var i_index : section_index_type := 0;
		for var i : section_index_type := 1 to get_num_sections_page(i_pagina_logica_1B) do begin
			var expint_section : cl_expint_section := get_expint_section_ZB(i_profilo, i_pagina_logica_1B - 1, i - 1);
			var exec_expint_section : cl_exec_expint_sezione := expint_page.get_exec_expint_section_ZB(i - 1);

			exec_expint_section.reset_exportabile_runtime;		// ripristino il valore default originale
			if (exec_expint_section.originale_export_type = SEXP_IMPOSSIBLE) then continue;	// se la sezione NON PUO' essere exportata, salto

			inc(i_index);
			setLength(ndx_sezioni_ZB, length(ndx_sezioni_ZB) + 1);
			ndx_sezioni_ZB[high(ndx_sezioni_ZB)] := i - 1;		// registro l'indice della sezione in trattamento

			it.Add(coalesce(expint_section.str_descrizione_runtime, sections_1B(i, i_pagina_logica_1B).str_nome));
			if (exec_expint_section.originale_export_type = SEXP_YES) then xs := xs + [i_index - 1]
		end;

		if NOT multi_dialog_proc(father, 'Exportazione dati', xs, it, [], 'Seleziona le sezioni da exportare') then begin result := FALSE;exit end;
//		for i := 0 to get_num_sections_page(i_pagina_logica_1B) - 1 do		// I è ZERO-based
		for var i : section_index_type := 0 to high(ndx_sezioni_ZB) do		// I è ZERO-based
//			expint_page.get_exec_expint_section_ZB(i - 1).bo_runtime_dont_export := NOT (i - 1 in xs)
			expint_page.get_exec_expint_section_ZB(ndx_sezioni_ZB[i]).bo_exportabile_runtime := (i in xs)
	finally
		it.free
	end
end;
{$endif CASA}

initialization
	galateo_initialization_debug('expint_exec')
finalization
	galateo_finalization_debug('expint_exec');
{$ifdef DEBUG}
	CCI(i_export_integrale, 'cl_exec_expint_main', 'pages.pas');
	CCI(i_export_integrale_pagina, 'cl_exec_expint_page', 'pages.pas');
	CCI(i_export_integrale_sezione, 'cl_exec_expint_sezione', 'pages.pas');
	CCI(i_expint_options, 'cl_expint_options', 'pages.pas')
{$endif DEBUG}
end.
