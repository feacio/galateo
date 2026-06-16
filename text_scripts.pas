unit text_scripts;

// ci sono DUE tipi di text_scripts, gestiti in modo alquanto analogo: SQL SCRIPTS e MACRO

{$I defines}

interface

uses SysUtils, FireDAC.Stan.Option;

type
	// TEXT SCRIPT TYPE definisce oggetti di testo differenti ma da trattare in modo tutto sommato equivalente: SCRIPTS SQL, MACROS
	// ogni oggetto può avere una molteplicità di ITEMS
//	SQL_script_type = (SQLST_EARLY, SQLST_BEFORE, SQLST_AFTER);	// tipi di SQL scripts: da eseguire PRIMA
	text_script_type = (TST_SQLS_EARLY, TST_SQLS_BEFORE, TST_SQLS_AFTER, TST_MACRO_PARAMETRICHE);	// tipi di SQL scripts: da eseguire PRIMA
	SQL_script_type = TST_SQLS_EARLY..TST_SQLS_AFTER;	// tipi di SQL scripts: da eseguire PRIMA
	macro_script_type = TST_MACRO_PARAMETRICHE..TST_MACRO_PARAMETRICHE;
	super_script_type = (SST_SQL, SST_MACRO);		// super-tipi di scripts
const
	SCRIPT_TYPE : array[text_script_type] of super_script_type = (SST_SQL, SST_SQL, SST_SQL, SST_MACRO);
//	SCRIPT_FILE_EXT : array[super_script_type] of string = (GALATEO_SQL_SCRIPT_FILE_EXT, GALATEO_MACRO_SCRIPT_FILE_EXT);
	DESCRIZIONE_TEXT_SCRIPT : array[text_script_type] of string = ('SQL script preliminare', 'SQL script', 'SQL script di chiusura', 'macro');	// a RUNTIME usare GET_RUNTIME_SCRIPT_DESCRIPTION
	DESCRIZIONE_TEXT_SCRIPT_SHORT : array[text_script_type] of string = ('pre-script', 'script', 'post-script', 'macro');

type
	text_script_record_type = object
		bo_disabled_locale : boolean;			// TRUE se lo script è disattivato a livello LOCALE; questo valore NON viene scritto nell'eventuale file condiviso
		bo_disabled_remoto : boolean;			// TRUE se lo script è disattivato a livello REMOTO; questo valore viene scritto nell'eventuale file condiviso
		str_descrizione : string;
		str_condizione : string;				// perchè lo script sia eseguito la condizione deve essere VUOTA oppure SODDISFATTA
		str_text : string;						// contenuto principale dello script
		bo_transazione_separata : boolean;
		isolation_level : TFDTxIsolation;
		bo_commit : boolean;
		str_filename : string;
		str_saved_by_report : string;			// nome del report che ha eseguito il salvataggio
		str_hash_atteso : string;				// HASH atteso del file (questo report aveva letto/scritto il file con questo HASH)
{$ifdef GALATEO_EXE}
		str_note : string;
		dt_file_fisica : TDatetime;		// datetime del file fisico
		dt_file_attesa : TDatetime;		// datetime del file attesa (questo report aveva letto/scritto il file con questa data)
		function get_hash : string;
{$endif}
		procedure reset;
	end;
	text_script_record_punt = ^text_script_record_type;
	cl_text_scripts = class
		private
			i_numero_phisical : byte;		// numero di scripts gestiti dal sistema -- NON ASSEGNARE MAI DIRETTAMENTE, usare sempre la property I_NUMERO
			procedure set_numero(i : byte);
		public
			xtipo : text_script_type;
			recs : array of text_script_record_type;
			property i_numero : byte read i_numero_phisical write set_numero;
			{$ifdef DEBUG} destructor free; {$endif}
			constructor create(tipo : text_script_type); overload;
{$ifdef GALATEO_EXE}
			constructor create(source : cl_text_scripts); overload;
			procedure copy_from(source : cl_text_scripts);
			function write(var f : Text) : boolean;
{$endif}
			function read(var f : Text;wo_versione : word;var str_error_message : string) : boolean;
			function read_old(var f : Text;i_script_number : byte) : boolean;
			procedure reset;
	end;
	text_scripts_array_type = array[text_script_type] of cl_text_scripts;

{$ifdef CASA} function get_runtime_script_description(tipo : text_script_type;i_script_ZB : smallint) : string; {$endif}
function text_script_file_read(sx : text_script_record_punt;str_filename : string;str_caption : string; var str_error_message : string) : boolean; overload;
function text_script_file_read(str_text : string;sx : text_script_record_punt;str_caption : string;bo_reading_file : boolean;
	var str_error_message : string) : boolean; overload;

implementation

uses FAssert, galateo_debug, FCommons, FXStrings, FStrings, FFile, FData, FTime, FProcs,
	FDB, Gdich, pages;

const
	SCRIPT_ENCODE_KEY = 137;
	END_OF_SCRIPT = '#eos#';
{$ifdef DEBUG} var i_text_scripts : integer; {$endif}

constructor cl_text_scripts.create(tipo : text_script_type);
begin
	{$ifdef DEBUG} inc(i_text_scripts); {$endif}
	self.xtipo := tipo;
	reset
end;

{$ifdef GALATEO_EXE}
	constructor cl_text_scripts.create(source : cl_text_scripts);
	begin
		{$ifdef DEBUG} inc(i_text_scripts); {$endif}
		copy_from(source)
	end;

	procedure cl_text_scripts.copy_from(source : cl_text_scripts);
	begin
		self.xtipo := source.xtipo;
		i_numero := source.i_numero;
		for var i : smallint := 0 to i_numero - 1 do recs[i] := source.recs[i]
	end;
{$endif}

{$ifdef DEBUG}
	destructor cl_text_scripts.free;
	begin
		dec(i_text_scripts)
	end;
{$endif}

procedure cl_text_scripts.reset;
begin
	i_numero := 1;
	setLength(recs, i_numero);
	recs[0].reset
end;

function cl_text_scripts.read_old(var f : Text;i_script_number : byte) : boolean;
// legge il formato ante $030A per backward compatibility
const SEQ_SEP_SQL_SCRIPT_DESCR = '-#@#-';	// improbabile sequenza
begin
	var sx : text_script_record_punt := @recs[i_script_number];
	if NOT readln_LPSTR(f, sx.str_text) then abort;
	var j : smallint := pos(SEQ_SEP_SQL_SCRIPT_DESCR, sx.str_text);
	if (j = 0) then sx.str_descrizione := ''
	else begin
		sx.str_descrizione := copy(sx.str_text, j + length(SEQ_SEP_SQL_SCRIPT_DESCR), MAXINT);
		delete(sx.str_text, j, MAXINT)
	end;
	sx.bo_disabled_locale := (sx.str_text = '');
	sx.bo_disabled_remoto := FALSE;
	sx.bo_transazione_separata := FALSE;sx.isolation_level := xiDirtyRead;sx.bo_commit := TRUE;
//	TFDTxIsolation: xiDirtyRead, xiReadCommitted, xiReadCommitted, xiRepeatableRead

	sx.str_filename := '';
	result := TRUE
end;

function text_script_file_read(sx : text_script_record_punt;str_filename : string;str_caption : string; var str_error_message : string) : boolean;
var
	str_text : string;	//*
	bo_CIN_ok : boolean;
begin
	result := FALSE;
	if (str_caption <> '') then str_caption := str_caption + ': ';
	if NOT filename_has_explicit_path(str_filename) then str_filename := make_filename(str_filename, ExtractFilepath(globale.str_filename));

	if NOT FileExists(str_filename) then begin
		add_delimited(str_error_message, str_caption + 'il file <' + str_filename + '> non esiste', ACAPO);
		exit
	end;
	if NOT read_textfile(str_filename, str_text) then begin
		add_delimited(str_error_message, str_caption + 'errore durante la lettura del file <' + str_filename + '>', ACAPO);
		exit
	end;
{$ifdef GALATEO_EXE}
	sx.dt_file_fisica := get_file_datetime(str_filename);
{	if (dt_file_attesa <> 0) then begin
		if (abs(dt_file_attesa - sx.dt_filename_fisica) > SECONDO) then
			add_delimited(str_error_message, str_caption + 'il file <' + sx.str_filename + '> ha data ' + dttime2SQL(sx.dt_filename_fisica, FALSE, TMFMT_HMS) +
				' invece che ' + dttime2SQL(dt_file_attesa, FALSE, TMFMT_HMS), ACAPO)
	end; }
{$endif GALATEO_EXE}

	str_text := stringa2hex_decode(togli_ACAPO_finali(str_text), SCRIPT_ENCODE_KEY, @bo_CIN_ok);
	if NOT bo_CIN_ok then begin
		add_delimited(str_error_message, str_caption + 'il file <' + sx.str_filename + '> è ILLEGGIBILE perchè alterato', ACAPO);
		exit
	end;
	result := text_script_file_read(str_text, sx, str_caption, TRUE, str_error_message)	// rileggo TUTTI i valori dal contenuto del file
end;

function text_script_file_read(str_text : string;sx : text_script_record_punt;str_caption : string;bo_reading_file : boolean;
	var str_error_message : string) : boolean;
{ interpreta il contenuto di un file su cui è stato salvato uno script (SQL o MACRO);
  STR_TEXT contiene il testo da interpretare, opportunamente CODIFICATO;
  rende TRUE in caso di successo, FALSE altrimenti }
var i, wo_versione_read : word;	//*
begin
	result := FALSE;
	try
		var s := get_line(str_text, TRUE);

		if start_with(s, '#ver') then begin	// due righe aggiunte con versione $032E
//			get_next_word(s, [' '], {delete_word} TRUE);
			get_next_word(s, [' '], [NWO_SPACE, NWO_DELETE]);
//			wo_versione_read := strToInt(get_next_word(s, [' '], {bo_delete_word} TRUE));
			wo_versione_read := strToInt(get_next_word(s, [' '], [NWO_SPACE, NWO_DELETE]));
			if bo_reading_file AND (wo_versione_read > GALATEO_VERSION) then begin
				add_delimited(str_error_message, 'La versione ' + version_of(wo_versione_read) + ' dello script-file <' + sx.str_filename +
					'> è superiore alla versione del programma (' + version_of(GALATEO_VERSION) + '):' +
					' sarà utilizzata la copia dello script salvata internamente al report', ACAPO);
				result := TRUE;exit
			end;
			sx.str_saved_by_report := get_line(str_text, TRUE);		// contiene il report che ha eseguito il salvataggio del file
			s := get_line(str_text, TRUE)	// leggo la terza riga
		end
		else wo_versione_read := $032D;

		sx.bo_disabled_remoto := (copy(s, 1, 1) = '0');delete(s, 1, 2);
		sx.bo_transazione_separata := (copy(s, 1, 1) = '1');delete(s, 1, 2);
//		byte(sx.isolation_level) := strtoint(copy(s, 1, 1));delete(s, 1, 2);	**
		sx.isolation_level := TFDTxIsolation(strtoint(copy(s, 1, 1)));delete(s, 1, 2);
		sx.bo_commit := (copy(s, 1, 1) = '1');delete(s, 1, 2);
		if (wo_versione_read < $0321) then sx.bo_commit := TRUE;

		sx.str_descrizione := readln_LPSTR(get_line(str_text, TRUE));
		sx.str_text := readln_LPSTR(get_line(str_text, TRUE));
		sx.str_condizione := readln_LPSTR(get_line(str_text, TRUE));
		s := get_line(str_text, TRUE);{$ifdef GALATEO_EXE} sx.str_note := readln_LPSTR(s); {$endif}		// dalla versione $0325

		if (wo_versione_read >= $0330) then
			for i := 1 to 5 do get_line(str_text, TRUE);	// spazio libero

		if (wo_versione_read > $032C) then begin
			if bo_reading_file then begin
				sx.str_filename := get_line(str_text, TRUE);		// filename
//				get_line(str_text, TRUE)		// file datetime
			end
			else begin
				sx.str_filename := get_line(str_text, TRUE);
				if (sx.str_filename = '') then get_line(str_text, TRUE)
				else begin
					s := get_line(str_text, TRUE);
					{$ifdef GALATEO_EXE} sx.dt_file_attesa := StrToFloat(s); {$endif}
					if NOT text_script_file_read(sx, sx.str_filename, str_caption, str_error_message) then exit
				end
			end
		end;

		if NOT bo_reading_file then begin		// sezione salvata LOCALMENTE sul report, non dipende dal file remoto e non lo influenza
			if (wo_versione_read <= $032E) then begin
				sx.bo_disabled_locale := (sx.str_text = '')
			end
			else begin
				s := get_line(str_text, TRUE);
				sx.bo_disabled_locale := (copy(s, 1, 1) = '1');delete(s, 1, 2);

				if (wo_versione_read >= $0330) then begin
					sx.str_hash_atteso := get_line(str_text, TRUE);
					{$ifdef DEBUG} assert((get_line(str_text, TRUE) = END_OF_SCRIPT) AND (str_text = ''), 'errore di formato nella lettura di uno SCRIPT -- EJHW 9310') {$endif}
				end
			end
		end;

		result := TRUE
	except
	end
end;

function cl_text_scripts.read(var f : Text;wo_versione : word;var str_error_message : string) : boolean;
var
	i, j : smallint;
	s, str_lines, str_caption : string;
begin
	result := FALSE;str_error_message := '';
	readln(f, i);i_numero := i;
	for i := 0 to i_numero-1 do begin
		str_caption := 'SQL script #' + inttostr(i+1) + ' -- ';
		s := '';str_lines := '';
		if (wo_versione < $0330) then
			for j := 1 to 5 + ifi(wo_versione > $032C, 2) + ifi(wo_versione > $032D, 2) + ifi(wo_versione > $032E, 2) do begin
				readln(f, s);str_lines := str_lines + s + ACAPO
			end
		else while (s <> END_OF_SCRIPT) do begin readln(f, s);str_lines := str_lines + s + ACAPO end;

		if NOT text_script_file_read(str_lines, @recs[i], str_caption, FALSE, str_error_message) then exit;
{$ifdef GALATEO_EXE}
		if (wo_versione >= $0330) AND (recs[i].str_hash_atteso <> recs[i].get_hash)
			then add_delimited(str_error_message, 'Il file <' + recs[i].str_filename + '> è stato modificato da ' + ExtractFilename(recs[i].str_saved_by_report) +
				' in data ' + dttime2SQL(recs[i].dt_file_fisica, FALSE, TMFMT_HMS), ACAPO)
{$endif GALATEO_EXE}
	end;
	result := TRUE
end;

{$ifdef GALATEO_EXE}
	function cl_text_scripts.write(var f : Text) : boolean;
	var s, str_full_filename : string;
	begin
		writeln(f, i_numero, ' 0 0 0 0 0 0');		// gli zeri dopo il numero scritti a partire dal 2013-01-31 ver $030D
		for var i : smallint := 0 to i_numero-1 do begin
			var sx : text_script_record_punt := @recs[i];

			{ il contenuto dello SCRIPT viene di norma salvato internamente (sul file principale che contiene il report);
			  se tuttavia viene salvato su FILE ESTERNO (di norma a scopo di condivisione con altri reports), lo script viene in effetti salvato
			  SIA ESTERNAMENTE che INTERNAMENTE;
			  il salvataggio ESTERNO è in realtà PREVALENTE, mentre la copia interna viene considerata accessoria, poichè la copia esterna
			  può essere stata modificata da un altro report, e le modifiche hanno ovviamente la precedenza }

			s := '#ver ' + inttostr(GALATEO_VERSION) + ' 0 0 0 0 0 0' + ACAPO +	// riga aggiunta ver $032E
				globale.str_filename + ACAPO +	// riga aggiunta ver $032E
				inttostr(byte(NOT sx.bo_disabled_remoto)) + ' ' + inttostr(byte(sx.bo_transazione_separata)) + ' ' + inttostr(byte(sx.isolation_level)) + ' ' +
					inttostr(byte(sx.bo_commit)) + ' 0 0 0 0 0' + ACAPO +
				writeln_LPSTR(sx.str_descrizione) + ACAPO +
				writeln_LPSTR(sx.str_text) + ACAPO +
				writeln_LPSTR(sx.str_condizione) + ACAPO +
				writeln_LPSTR(sx.str_note) + ACAPO +		// dalla versione $0325
				ACAPO + ACAPO + ACAPO + ACAPO + ACAPO + 	// dalla versione $0330, spazio libero
				sx.str_filename + ACAPO;						// dalla versione $032D

			if (sx.str_filename <> '') then begin
				if filename_has_explicit_path(sx.str_filename) then str_full_filename := sx.str_filename
				else str_full_filename := make_filename(sx.str_filename, ExtractFilepath(globale.str_filename));

				// poichè il file è COMUNQUE codificato, lo rendo illeggibile per non dare l'idea a qualche buontempone di intervenire direttamente
				if NOT write_textfile(str_full_filename, stringa2hex_encode(s, SCRIPT_ENCODE_KEY, {bo_CIN}TRUE)) then abort;
				s := s + floatToStr(get_file_datetime(str_full_filename))
			end;

			// dalla versione $032F -- informazioni ad uso locale del singolo report
			s := s + ACAPO +
				ifs(sx.bo_disabled_locale, '1', '0') + ' 0 0 0 0 0 0' +	ACAPO +	// dalla versione $032F
				sx.get_hash;	// dalla versione $0330, per gestire le modifiche eseguite sul file e FREE SPACE

			writeln(f, s);
			writeln(f, END_OF_SCRIPT)
		end;
		result := TRUE
	end;
{$endif}

procedure cl_text_scripts.set_numero(i : byte);
begin
	i_numero_phisical := i;
	setLength(recs, i)
end;

{$ifdef CASA}
function get_runtime_script_description(tipo : text_script_type;i_script_ZB : smallint) : string;
// I_SCRIPT è ZERO-based
begin
	var sx : text_script_record_punt := @globale.Text_scripts[tipo].recs[i_script_ZB];
	result := DESCRIZIONE_TEXT_SCRIPT[tipo] + ' #' + (i_script_ZB + 1).ToString + ifs(sx.str_descrizione, ' [' + sx.str_descrizione + ']')
end;
{$endif CASA}

{ text_script_record_type }

{$ifdef GALATEO_EXE}
	function text_script_record_type.get_hash : string;
	begin
		var lo : integer := 0;
		inc(lo, byte(bo_disabled_locale) * 11);
		inc(lo, byte(bo_disabled_remoto) * 12);
		inc(lo, byte(bo_transazione_separata) * 13);
		inc(lo, byte(isolation_level) * 14);
		inc(lo, byte(bo_commit) * 15);

		var s := str_descrizione + '||' + str_condizione + '**' + str_text + '^^' + str_note;
		for var i := 1 to length(s) do lo := (lo + byte(s[i]) * (i mod 13 + 1) * (i mod 17 + 1)) mod 2000000000;
		result := stri_hex(lo, 0)
	end;
{$endif GALATEO_EXE}

procedure text_script_record_type.reset;
begin
	str_descrizione := '';str_condizione := '';str_text := '';
	str_filename := '';str_saved_by_report := '';
	{$ifdef GALATEO_EXE} dt_file_fisica := 0;dt_file_attesa := 0;str_note := ''; {$endif}
	bo_disabled_locale := TRUE;bo_disabled_remoto := FALSE;
	bo_transazione_separata := FALSE;isolation_level := xiDirtyRead;bo_commit := TRUE
end;

initialization
	galateo_initialization_debug('text_scripts')
finalization
	galateo_finalization_debug('text_scripts');
	{$ifdef DEBUG} CCI(i_text_scripts, 'cl_text_scripts', 'global.pas'); {$endif}
end.
