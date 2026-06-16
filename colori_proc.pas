unit colori_proc;

{$I defines}
{$if NOT (defined(GALATEO_EXE) or defined(CASA))}	*** not good, sir *** {$endif}

interface

uses Windows, SysUtils, Types, Graphics, Classes,
	gdich {$ifdef GALATEO_EXE} ,validate {$endif};

type
	colore_symbolico_type = object
		str_descrizione : string;
		lo_colore : TColor;
		{$ifdef GALATEO_EXE} i_pos : smallint; {$endif}		// serve solo in editing
		function assign(source : colore_symbolico_type) : colore_symbolico_type;
		function blank : boolean;
		function filled : boolean;
	end;
	colore_symbolico_punt = ^colore_symbolico_type;
	colore_symbolico_array = array of colore_symbolico_type;
	colore_symbolico_array_punt = ^colore_symbolico_array;
	table_colori_symbolici = object
		private
			tbl : colore_symbolico_array;
		public
			procedure add(col : colore_symbolico_type);
			procedure clear;
			function read(var f : Text;wo_versione_read : word) : boolean;
			function count : smallint;
			function assign(source : table_colori_symbolici) : table_colori_symbolici;
			function get_index(str_descrizione : string;i_exclude_index : smallint = -1) : smallint;
			function get_colore(i_index : smallint) : colore_symbolico_type;
{$ifdef GALATEO_EXE}
			procedure delete(index : smallint);
			function get_ptr_colore(i_index : smallint) : colore_symbolico_punt;
			function validate(handle : HWND;cx : colore_symbolico_type;i_update_index : smallint = -1) : boolean;
			function write(var f : Text) : boolean;
			function sort : boolean;
			function load_items(it : TStrings) : boolean;
{$endif}
	end;

const
	MAX_COLORI_CONDIZIONALI = 4;
	COLORE_RIGHE_ALTERNE = 15461355;			// grigio chiaro
type
	colonna_colorata_executive_values = record	// contiene i valori esecutivi per ogni sezione realmente stampata (ogni record)
		bo_disabled : boolean;			// TRUE se la colonna NON deve essere stampata
		margine_sx_cm, margine_dx_cm : double;
		lo_colore : TColor;
	end;

	tipo_colore_colonna_colorata = (TCCC_BLANK,
		TCCC_CONDIZIONE,			// colore determinabile in base ad una serie di condizioni
		TCCC_GRADAZIONE);			// colore continuo da un minimo ad un massimo
	tipo_limite_colonna_colorata = ({TLC_BLANK,}
		TLC_FULL_WIDTH,			// dimensione completa pagina stampata
		TLC_SECTION_WIDTH,		// dimensione della sezione, ovvero dell'oggetto utilizzato per TIRARE LE RIGHE della sezione (esclusa la MAIN SECTION)
		TLC_ASSEGNATO, TLC_FORMULE, TLC_OBJECT, TLC_LINES);

	colore_type = object
		lo_colore : TColor;
		str_colore_symbolico : string;		// nome symbolico del colore nella tabella globale dei colori symbolici
		function assign(source : colore_type) : colore_type;
		procedure clear;
		function apply_colore_symbolico : boolean;
		function is_blank : boolean;
		function read(var f : Text;wo_versione : word) : boolean;
{$ifdef GALATEO_EXE}
		function apply_change_name_colore_symbolico(str_from, str_to : string) : boolean;
		function write(var f : text) : boolean;
		function check_not_blank(err_msg : cl_validation;str_descrizione_oggetto : string;bo_vincolante : boolean = FALSE) : boolean;
{$endif}
	end;

	colore_condizionale_type = object
		colore : colore_type;
		str_condizione : string;				// condizione di applicazione del colore
		function assign(source : colore_condizionale_type) : colore_condizionale_type;
		procedure clear;
		function is_blank : boolean;
		function read(var f : Text;wo_versione : word) : boolean;
{$ifdef GALATEO_EXE}
		function write(var f : text) : boolean;
{$endif}
	end;
	colore_condizionale_punt = ^colore_condizionale_type;

	colore_gradazione_type = object
		str_formula_valore : string;		// formula da valutare per ottenere il valore
		i_valore_min, i_valore_max : integer;		// solo valori interi (per il momento)
		colore_min, colore_max, colore_mix_from, colore_mix_to, colore_extra_range : colore_type;
		function assign(source : colore_gradazione_type) : colore_gradazione_type;
		procedure clear;
//		function is_blank : boolean;
		function read(var f : Text;wo_versione : word) : boolean;
{$ifdef GALATEO_EXE}
		function apply_change_name_colore_symbolico(str_from, str_to : string) : boolean;
		function write(var f : text) : boolean;
{$endif}
	end;
	colore_gradazione_punt = ^colore_gradazione_type;

	cl_colonna_colorata = class
		str_descrizione : string;		// descrizione generica della colonna
		bo_disabled : boolean;
		str_condizione_abilitazione : string;
		tipo_limite : tipo_limite_colonna_colorata;
		fl_margine_sx_cm, fl_margine_dx_cm : double;	// posizione assoluta in CM (TIPO_LIMITE = TLC_ASSEGNATO)
		str_formula_margine_sx_CM, str_formula_margine_dx_CM : string;	// TIPO_LIMITE = TLC_FORMULE
		str_limite_object : string;						// oggetto che determina la dimensione (TIPO_LIMITE = TLB_OBJECT)
		str_left_line, str_right_line : string;		// linee che delimitano (TIPO_LIMITE = TLC_LINES)
		colore_base : colore_type;
		tipo_colore : tipo_colore_colonna_colorata;		// modalità di determinazione del colore
		// viene assegnato il primo colore (NOT BLANK) per il quale la condizione sia verificata
		colori_condizionali : array[0..MAX_COLORI_CONDIZIONALI-1] of colore_condizionale_type;
		gradazione : colore_gradazione_type;
		constructor create;
		destructor free;
		procedure clear;
		function codifica_colore(colore : TColor) : TColor;
		function decodifica_colore(colore : TColor) : TColor;
		function read(var f : Text;wo_versione_read : word) : boolean;
		function get_margine_sx_cm : double;
		function get_margine_dx_cm : double;
		function apply_colori_symbolici : boolean;
		function calcola_formula_margine(str_formula : string) : double;
{$ifdef GALATEO_EXE}
		function assign(source : cl_colonna_colorata) : cl_colonna_colorata;
		function write(var f : Text;i_numero_colonna : smallint) : boolean;
		function get_numero_colori_condizionali(bo_ignora_tipo_colore : boolean = FALSE) : smallint;	// rende il numero di colori condizionali NOT BLANK
{$endif}
{$ifdef CASA}
		function draw(ptr_print_section : {cl_print_section}pointer;bo_video : boolean;dx : int_pixel_type;
			exec_values : colonna_colorata_executive_values;vcanvas, pcanvas : TCanvas) : boolean;
		function get_executive_color : TColor;
//		function get_margine_sx_pixel : int_pixel_type;
//		function get_margine_dx_pixel : int_pixel_type;
{$endif}
	end;
	colonna_colorata_array = array of cl_colonna_colorata;

{$ifdef GALATEO_EXE}
const
	DESCRIZIONE_TIPO_LIMITE_COLONNE_COLORATE : array[tipo_limite_colonna_colorata] of string =
		('larghezza pagina', 'larghezza sezione', {TLC_ASSEGNATO}'assegnato', 'formula', 'oggetto', 'coppia di linee verticali');
{$endif}

function apply_colori_symbolici_colonne_colorate(cca : colonna_colorata_array) : boolean;
{$ifdef GALATEO_EXE} function apply_change_name_colore_symbolico(str_from, str_to : string) : boolean; {$endif}

implementation

uses FCommons, FMessage, FProcs, {$ifdef GALATEO_EXE} FxStrings, {$endif}
	GUN, proc, sezione, misure, {$ifdef CASA} print_types, {$endif} functions, objects, pages;

{$ifdef DEBUG} var i_colonna_colorata : integer; {$endif}

// colore_symbolico_type =======================================================================================================================================

function colore_symbolico_type.assign(source : colore_symbolico_type) : colore_symbolico_type;
begin
	str_descrizione := source.str_descrizione;
	lo_colore := source.lo_colore;
	{$ifdef GALATEO_EXE} i_pos := source.i_pos {$endif}
end;

function colore_symbolico_type.blank : boolean;
begin
	result := (str_descrizione = '') AND (lo_colore = 0) { AND i_pos = **}
end;

function colore_symbolico_type.filled : boolean;
begin
	result := (str_descrizione <> '') {AND (lo_colore = 0) AND (i_pos <> **)}
end;

// table_colori_symbolici ======================================================================================================================================

procedure table_colori_symbolici.add(col : colore_symbolico_type);
begin
	var i : smallint := length(tbl);
	setLength(tbl, i+1);tbl[i].assign(col)
end;

function table_colori_symbolici.assign(source : table_colori_symbolici) : table_colori_symbolici;
begin
	setLength(tbl, length(source.tbl));
	for var i : smallint := 0 to high(tbl) do tbl[i].assign(source.tbl[i]);
	result := self
end;

procedure table_colori_symbolici.clear;
begin
	tbl := NIL
end;

function table_colori_symbolici.count : smallint;
begin
	result := length(tbl)
end;

const
	SYMBOLIC_COLOR_SIGLA_FILE = 'syc';		// SYmbolic Colors

{$ifdef GALATEO_EXE}

procedure table_colori_symbolici.delete(index: smallint);
begin
	for var i : smallint := index to high(tbl) - 1 do tbl[i].assign(tbl[i+1]);
	setLength(tbl, high(tbl))
end;

function table_colori_symbolici.write(var f : Text) : boolean;
begin
	writeln(f, SYMBOLIC_COLOR_SIGLA_FILE);		// SYmbolic Colors
	writeln(f, Count, ' 0 0 0 0 0 0');
	for var i : smallint := 0 to Count - 1 do begin
		writeln(f, tbl[i].str_descrizione);
		writeln(f, tbl[i].lo_colore, tbl[i].i_pos:4, ' 0 0 0')
	end;
	result := TRUE
end;

function table_colori_symbolici.validate(handle : HWND;cx : colore_symbolico_type;i_update_index : smallint = -1) : boolean;
{ esegue una validazione del colore symbolico specificato; rende TRUE in caso di successo, FALSE altrimenti; emette eventuali messaggi di errore;
  se I_UPDATE_INDEX = -1 si intende per un NUOVO COLORE SYMBOLICO, altrimenti in modifica del colore I_UPDATE_INDEX }
begin
	result := FALSE;
	if (pos(' ', cx.str_descrizione) <> 0) then begin MessageBBox(handle, 'Il nome symbolico del colore non può contenere spazi', MBOX_CAPTION, MB_ICONSTOP);exit end;
	if NOT cx.filled then begin MessageBBox(handle, 'Assegna un nome (e un colore) prima di aggiungere il colore symbolico', MBOX_CAPTION, MB_ICONSTOP);exit end;

	if (get_index(cx.str_descrizione, i_update_index) <> -1) then begin
		MessageBBox(handle, 'Nome già esistente', MBOX_CAPTION, MB_ICONSTOP);exit
	end;
	result := TRUE
end;

function table_colori_symbolici.get_ptr_colore(i_index : smallint) : colore_symbolico_punt;
begin
	result := @tbl[i_index]
end;

function table_colori_symbolici.load_items(it : TStrings) : boolean;
begin
	it.clear;
	for var i : smallint := 0 to high(tbl) do it.add(tbl[i].str_descrizione);
	result := TRUE
end;

function table_colori_symbolici.sort : boolean;
// ordina la tabella per I_POS e DESCRIZIONE; rende TRUE se vengono eseguite modifiche
begin
	result := FALSE;
	for var i : smallint := 0 to high(tbl) - 1 do
		for var j : smallint := i + 1 to high(tbl) do
			if (tbl[i].i_pos > tbl[j].i_pos) OR ((tbl[i].i_pos = tbl[j].i_pos) AND (uppercase(tbl[i].str_descrizione) > uppercase(tbl[j].str_descrizione))) then begin
				var temp : colore_symbolico_type;
				temp.assign(tbl[i]);tbl[i].assign(tbl[j]);tbl[j].assign(temp);
				result := TRUE
			end
end;

{$endif GALATEO_EXE}

function table_colori_symbolici.read(var f : Text;wo_versione_read : word) : boolean;
var
	i : smallint;	//*
	s : string;
begin
	result := (wo_versione_read < $0404);if result then exit;
	readln(f, s);if (s <> SYMBOLIC_COLOR_SIGLA_FILE) then exit;		// errore
	readln(f, i);setLength(tbl, i);
	for i := 0 to i-1 do begin
		readln(f, tbl[i].str_descrizione);
		readln(f, tbl[i].lo_colore {$ifdef GALATEO_EXE}, tbl[i].i_pos {$endif})
	end;
	result := TRUE
end;

function table_colori_symbolici.get_colore(i_index : smallint): colore_symbolico_type;
begin
	result := tbl[i_index]
end;

function table_colori_symbolici.get_index(str_descrizione : string;i_exclude_index : smallint = -1) : smallint;
begin
	str_descrizione := uppercase(str_descrizione);
	result := high(tbl);
	while (result >= 0) AND ((result = i_exclude_index) OR (uppercase(tbl[result].str_descrizione) <> str_descrizione)) do dec(result)
end;

// cl_colonna_colorata =========================================================================================================================================

procedure colore_type.clear;
begin
	lo_colore := 0;		// discutibile, e cmq di fatto considerato come clWhite
	str_colore_symbolico := ''
end;

function colore_type.assign(source : colore_type) : colore_type;
begin
	lo_colore := source.lo_colore;
	str_colore_symbolico := source.str_colore_symbolico;
	result := self
end;

function colore_type.is_blank : boolean;
begin
	result := (lo_colore = 0) AND (str_colore_symbolico = '')
end;

function colore_type.read(var f : Text;wo_versione : word) : boolean;
var s : string;
begin
	result := FALSE;
	readln(f, s);if (s <> 'cty') then exit;
	readln(f, s);
	lo_colore := StrToInt(trim(copy(s, 1, 12)));
	str_colore_symbolico := copy(s, 13, MAXINT);
	readln(f);result := TRUE
end;

{$ifdef GALATEO_EXE}
function colore_type.write(var f : text) : boolean;
begin
	writeln(f, 'cty');
	writeln(f, lo_colore:12, str_colore_symbolico);
	writeln(f);
	result := TRUE
end;

function colore_type.check_not_blank(err_msg : cl_validation;str_descrizione_oggetto : string;bo_vincolante : boolean = FALSE) : boolean;
// verifica che il colore sia NOT BLANK; rende TRUE se NOT BLANK, FALSE se BLANK; se è BLANK carica un messaggio su ERR_MSG
begin
	result := (lo_colore <> 0);
	if NOT result then validation_add(err_msg, str_descrizione_oggetto + ': il colore associato non è stato assegnato', bo_vincolante)
end;

function colore_type.apply_change_name_colore_symbolico(str_from, str_to : string) : boolean;
begin
	result := (str_colore_symbolico = str_from) AND (str_from <> str_to);
	if result then str_colore_symbolico := str_to
end;

{$endif GALATEO_EXE}

function colore_type.apply_colore_symbolico : boolean;
// applica i colori symbolici, nel caso il colore symbolico sia stato modificato rispetto al colore realmente assegnato; rende TRUE se esegue modifiche
begin
	result := FALSE;
	var i : smallint := globale.table_colori_symbolici.get_index(str_colore_symbolico);
	if (i = -1) then exit;
	var lo_symbolic_color := globale.table_colori_symbolici.get_colore(i).lo_colore;
	if (lo_symbolic_color <> lo_colore) then begin
		result := TRUE;
		lo_colore := lo_symbolic_color
	end
end;

// -------------------------------------------------------------------------------------------------------------------------------------------------------------

procedure colore_gradazione_type.clear;
begin
	str_formula_valore := '';i_valore_min := 0;i_valore_max := 0;
	colore_min.clear;colore_max.clear;colore_mix_from.clear;colore_mix_to.clear;colore_extra_range.clear
end;

function colore_gradazione_type.assign(source : colore_gradazione_type) : colore_gradazione_type;
begin
	str_formula_valore := source.str_formula_valore;
	i_valore_min := source.i_valore_min;i_valore_max := source.i_valore_max;
	colore_min.assign(source.colore_min);colore_max.assign(source.colore_max);
	colore_extra_range.assign(source.colore_extra_range);
	colore_mix_from.assign(source.colore_mix_from);colore_mix_to.assign(source.colore_mix_to)
end;

function colore_gradazione_type.read(var f : Text;wo_versione : word) : boolean;
var s : string;	//*
begin
	result := FALSE;
	readln(f, s);if (s <> 'cgt') then exit;
	readln(f, str_formula_valore);
	readln(f, i_valore_min, i_valore_max);
	result := colore_min.read(f, wo_versione) AND colore_max.read(f, wo_versione) AND
		colore_mix_from.read(f, wo_versione) AND colore_mix_to.read(f, wo_versione) AND
		colore_extra_range.read(f, wo_versione)
end;

{$ifdef GALATEO_EXE}
function colore_gradazione_type.write(var f : text) : boolean;
begin
	writeln(f, 'cgt');
	writeln(f, str_formula_valore);
	writeln(f, i_valore_min, ' ', i_valore_max, ' 0 0 0 0 0');
	result := colore_min.write(f) AND colore_max.write(f) AND colore_mix_from.write(f) AND colore_mix_to.write(f) AND colore_extra_range.write(f)
end;

function colore_gradazione_type.apply_change_name_colore_symbolico(str_from, str_to : string) : boolean;
begin
	result := colore_min.apply_change_name_colore_symbolico(str_from, str_to) OR
		colore_max.apply_change_name_colore_symbolico(str_from, str_to) OR
		colore_mix_from.apply_change_name_colore_symbolico(str_from, str_to) OR
		colore_mix_to.apply_change_name_colore_symbolico(str_from, str_to) OR
		colore_extra_range.apply_change_name_colore_symbolico(str_from, str_to)
end;

{$endif GALATEO_EXE}

// -------------------------------------------------------------------------------------------------------------------------------------------------------------

procedure colore_condizionale_type.clear;
begin
	colore.clear;str_condizione := ''
end;

function colore_condizionale_type.is_blank: boolean;
begin
	result := colore.is_blank AND (str_condizione = '')
end;

function colore_condizionale_type.read(var f : Text;wo_versione : word) : boolean;
var s : string;	//*
begin
	result := FALSE;
	readln(f, s);if (s <> 'cct') then exit;
	if NOT colore.read(f, wo_versione) then exit;
	readln(f, str_condizione);
	readln(f);
	result := TRUE
end;

{$ifdef GALATEO_EXE}
function colore_condizionale_type.write(var f: text): boolean;
begin
	writeln(f, 'cct');
	result := colore.write(f);if NOT result then exit;
	writeln(f, str_condizione);
	writeln(f, '');
	result := TRUE
end;
{$endif}

function colore_condizionale_type.assign(source : colore_condizionale_type) : colore_condizionale_type;
begin
	colore.assign(source.colore);
	str_condizione := source.str_condizione;
	result := self
end;

constructor cl_colonna_colorata.create;
begin
	{$ifdef DEBUG} inc(i_colonna_colorata); {$endif DEBUG}
	clear
end;

destructor cl_colonna_colorata.free;
begin
	{$ifdef DEBUG} dec(i_colonna_colorata) {$endif DEBUG}
end;

function cl_colonna_colorata.calcola_formula_margine(str_formula : string) : double;
var str_result : string;	//*
begin
	result := 0;
	var tipo : risultato_type := VAL_NUMERO;
	if NOT translate_formula(str_formula, str_result, {test}{$ifdef GALATEO_EXE}TRUE{$else}FALSE{$endif}, tipo, NIL) then begin
		MessageBBox(GH, 'Errore nel calcolo runtime della posizione della colonna colorata <' + str_descrizione + '>', 'Colonna colorata', MB_ICONSTOP);
		exit
	end;
	result := strTofloat(check_decimal_format(str_result))		// estraggo il valore in CM
end;

function cl_colonna_colorata.get_margine_sx_cm : double;
begin
	result := 0;
	var obj : objs_type := NIL;
	case tipo_limite of
		TLC_FULL_WIDTH, TLC_SECTION_WIDTH : ;		// assegnato direttamente dalla sezione
		TLC_ASSEGNATO : result := fl_margine_sx_cm;
		TLC_FORMULE : result := calcola_formula_margine(str_formula_margine_sx_CM);
		TLC_OBJECT : obj := name2obj(str_limite_object, {bo_all_pages}FALSE);
		TLC_LINES : obj := name2obj(str_left_line, {bo_all_pages}FALSE)
		{$ifdef DEBUG} else assert(FALSE, 'cl_colonna_colorata.get_margine_sx()') {$endif DEBUG}
	end;
	if (obj <> NIL) then result := video2cm_x(obj.get_left)	// dimensioni in EDITING; le dimensioni runtime non sono ancora state elaborate; usare le FORMULE
end;

function cl_colonna_colorata.get_margine_dx_cm : double;
begin
	result := 0;
	var obj : objs_type := NIL;
	case tipo_limite of
		TLC_FULL_WIDTH, TLC_SECTION_WIDTH : ;		// assegnato direttamente dalla sezione
		TLC_ASSEGNATO : result := fl_margine_dx_cm;
		TLC_FORMULE : result := calcola_formula_margine(str_formula_margine_dx_CM);
		TLC_OBJECT : obj := name2obj(str_limite_object, {bo_all_pages}FALSE);
		TLC_LINES : obj := name2obj(str_right_line, {bo_all_pages}FALSE)
		{$ifdef DEBUG} else assert(FALSE, 'cl_colonna_colorata.get_margine_sx()') {$endif DEBUG}
	end;
	if (obj <> NIL) then result := video2cm_x(obj.get_left + obj.get_width)	// dimensioni in EDITING; le dimensioni runtime non sono ancora state elaborate; usare le FORMULE
end;

function cl_colonna_colorata.apply_colori_symbolici : boolean;
// applica i colori symbolici, nel caso il colore symbolico sia stato modificato rispetto al colore realmente assegnato; rende TRUE se esegue modifiche

	function apply(str_colore_symbolico : string;var lo_colore : TColor) : boolean;
	begin
		result := FALSE;
		var i : smallint := globale.table_colori_symbolici.get_index(str_colore_symbolico);
		if (i = -1) then exit;
		var lo_symbolic_color := globale.table_colori_symbolici.get_colore(i).lo_colore;
		if (lo_symbolic_color <> lo_colore) then begin
			result := TRUE;
			lo_colore := lo_symbolic_color
		end
	end;

begin
//	result := apply(str_colore_symbolico_base, lo_colore_base);
	result := colore_base.apply_colore_symbolico;
	case tipo_colore of
		TCCC_CONDIZIONE : begin
			for var i : smallint := 0 to MAX_COLORI_CONDIZIONALI-1 do
				if colori_condizionali[i].colore.apply_colore_symbolico then result := TRUE
		end;
		TCCC_GRADAZIONE :
	end
end;

procedure cl_colonna_colorata.clear;
begin
	bo_disabled := FALSE;str_condizione_abilitazione := '';
	str_descrizione := '';tipo_colore := TCCC_BLANK;
	colore_base.clear;
	tipo_limite := low(tipo_limite);fl_margine_sx_cm := 0;fl_margine_dx_cm := 0;str_formula_margine_sx_CM := '';str_formula_margine_dx_CM := '';
	str_limite_object := '';str_left_line := '';str_right_line := '';
	for var i : byte := 0 to MAX_COLORI_CONDIZIONALI-1 do colori_condizionali[i].clear;
	gradazione.clear
end;

function cl_colonna_colorata.read(var f: Text; wo_versione_read: word): boolean;
var
	s : string;
	i_numero_colori_condizionali : smallint;
begin
	result := TRUE;
	readln(f, s);if NOT s.StartsWith('cc#') then begin result := FALSE;exit end;	// non controllo il numero colonna, solo che il blocco letto sia di tipo coerente con le attese
	var i_pos : smallint := pos('|', s);if (i_pos = 0) then begin result := FALSE;exit end;
	str_condizione_abilitazione := copy(s, i_pos + 1, MAXINT);
	readln(f, str_descrizione);
	result := result AND colore_base.read(f, wo_versione_read);
	readln(f, byte(tipo_colore), byte(tipo_limite), fl_margine_sx_cm, fl_margine_dx_cm, i_numero_colori_condizionali, byte(bo_disabled));
	readln(f, str_limite_object);readln(f, str_left_line);readln(f, str_right_line);
	readln(f, str_formula_margine_sx_CM);readln(f, str_formula_margine_dx_CM);

	for var i := 0 to i_numero_colori_condizionali - 1 do
		result := result AND colori_condizionali[i].read(f, wo_versione_read);
	readln(f);
	result := result AND gradazione.read(f, wo_versione_read);
	readln(f);
	readln(f, s);result := result AND (s = 'cc-end');
	apply_colori_symbolici
end;

{$ifdef GALATEO_EXE}

function cl_colonna_colorata.write(var f : Text;i_numero_colonna : smallint) : boolean;
begin
	writeln(f, 'cc#', zeri(i_numero_colonna, 2), ' 0 0 0 0 0 0 0 |', str_condizione_abilitazione);
	writeln(f, str_descrizione);
	colore_base.write(f);
	var i_numero_colori := get_numero_colori_condizionali({ignora_tipo_colore}TRUE);
	writeln(f, byte(tipo_colore), byte(tipo_limite):2, ' ', fl_margine_sx_cm:0:4, ' ', fl_margine_dx_cm:0:4, i_numero_colori:3,
		byte(bo_disabled):2, ' 0 0 0 0 0 0');
	writeln(f, str_limite_object);writeln(f, str_left_line);writeln(f, str_right_line);
	writeln(f, str_formula_margine_sx_CM);writeln(f, str_formula_margine_dx_CM);

	for var i := 0 to MAX_COLORI_CONDIZIONALI - 1 do
		if NOT colori_condizionali[i].is_blank then colori_condizionali[i].write(f);
	writeln(f);
	gradazione.write(f);
	writeln(f);writeln(f, 'cc-end');
	result := TRUE
end;

{$endif GALATEO_EXE}

function cl_colonna_colorata.codifica_colore(colore : TColor) : TColor;		// traduce il colore
begin
	if (colore = clWhite) then result := 0 else result := colore
end;

function cl_colonna_colorata.decodifica_colore(colore : TColor) : TColor;		// traduce il colore
begin
	if (colore = 0) then result := clWhite else result := colore
end;

{$ifdef CASA}

function cl_colonna_colorata.draw(ptr_print_section : {cl_print_section}pointer;bo_video : boolean;dx : int_pixel_type;
	exec_values : colonna_colorata_executive_values;vcanvas, pcanvas : TCanvas) : boolean;
{ stampa la colonna colorata tra Y0 e Y1 (pixels, già nel formato adeguato al target video/print);
  PTR_PRINT_SECTION è l'oggetto CL_PRINT_SECTION di cui stiamo stampando le colonne colorate;
  DX è il margine base sinistro }
var
	canvas : TCanvas;
	print_section : cl_print_section absolute ptr_print_section;
begin
	result := TRUE;
	if exec_values.bo_disabled OR (exec_values.lo_colore = clBlack) then exit;		// non è del tutto proprio, ma lo considero più come BLANK che come BLACK

	if bo_video then canvas := vcanvas else canvas := pcanvas;
	var r : TRect := print_section.runtime_rect;
	case tipo_limite of
		TLC_FULL_WIDTH : begin	//
			r.Left := 0;
//			var fl : double := get_PHpage_size_X_cm_1B(print_section.i_logical_page_1B);
			var fl : double := get_PHpage_size_X_cm_ZB(print_section.i_logical_page_ZB);
			if bo_video then r.Right := cm2pixel_video_x(fl) else r.Right := dx + cm2pixel_print_x(fl)
		end;
		TLC_SECTION_WIDTH : ;		// già assegnato
		else begin
			if bo_video then begin
				r.Left := dx + cm2pixel_video_x(exec_values.margine_sx_cm);
				r.Right := dx + cm2pixel_video_x(exec_values.margine_dx_cm)
			end
			else begin
				r.Left := dx + cm2pixel_print_x(exec_values.margine_sx_cm);
				r.Right := dx + cm2pixel_print_x(exec_values.margine_dx_cm)
			end
		end
	end;

	// verifico se lasciare uno spazio per le righe inter-sezionali (che altrimenti viene coperto dalla prossima sezione)
	if (tipo_limite <> TLC_FULL_WIDTH) AND
		(sections_ZB(print_section.i_section_ZB, print_section.i_logical_page_ZB).str_obj_line_bottom_pos_and_width <> '')
			then inc(r.Top);	// dec(r.Bottom);

	// sposto a DX per non mangiare l'oggetto (che viene stampato prima perchè spesso appartenente alla sezione superiore)
	if (tipo_limite <> TLC_FULL_WIDTH) then inc(r.Left);	// ***	dec(r.Right)

	canvas.Brush.Color := exec_values.lo_colore;canvas.Brush.Style := bsSolid;
	canvas.FillRect(r)
end;

function cl_colonna_colorata.get_executive_color : TColor;
var
	bo : boolean;	//*
	str_msg : string;
begin
	var colore_result := colore_base;

	case tipo_colore of
		TCCC_BLANK : ;
		TCCC_CONDIZIONE : begin
			for var i : smallint := 0 to MAX_COLORI_CONDIZIONALI-1 do begin
				var cc : colore_condizionale_type := colori_condizionali[i];
				if (cc.str_condizione = '') then break;
				if NOT interpreta_boolean_expression(cc.str_condizione, {test}FALSE, bo, str_msg) then
					raise exception.create('Colonna colorata <' + str_descrizione + '> errore durante l''interpretazione della condizione -- ' + str_msg);
				if bo then begin
					colore_result := cc.colore;
					break
				end
			end
		end;
		TCCC_GRADAZIONE : begin
			var str_result : string;
			var tipo : risultato_type := VAL_NUMERO;
			if NOT translate_formula(gradazione.str_formula_valore, str_result, {test}FALSE, tipo, NIL) then
				raise exception.create('Colonna colorata <' + str_descrizione + '> errore durante l''interpretazione della condizione -- ' + str_msg);
			var i_value : integer := strToInt(str_result);
			if (i_value = gradazione.i_valore_min) then colore_result := gradazione.colore_min else
			if (i_value = gradazione.i_valore_max) then colore_result := gradazione.colore_max else
			if (i_value > gradazione.i_valore_min) AND ((i_value < gradazione.i_valore_max)) then begin
				{ tolgo gli elementi estremi che coincidono con I_VALORE_MIN e I_VALORE_MAX perchè altrimenti i corrispondenti colori sarebbero persi
				  questa cosa si avverte particolarmente quando i gradini tra MIN e MAX sono pochi ... se ad esempio sono 5 è un disastro }
				var i_low : integer := gradazione.i_valore_min + 1;
				var i_high : integer := gradazione.i_valore_max - 1;
				if (i_low >= i_high) then begin dec(i_low);inc(i_high) end;		// serve a nulla, solo per paura di quello che potrebbe succedere
				var fl_perc : double := (i_value - i_low) / (i_high - i_low) * 100.0;
				colore_result.lo_colore := calcola_colore_intermedio(gradazione.colore_mix_from.lo_colore, gradazione.colore_mix_to.lo_colore, fl_perc);
				colore_result.str_colore_symbolico := ''		// inapplicabile
			end
			else colore_result := gradazione.colore_extra_range
		end
	end;

	result := colore_result.lo_colore;		// in prima battuta, e cmq non fa male
	if (colore_result.str_colore_symbolico <> '') then begin
		var i_ndx := globale.table_colori_symbolici.get_index(colore_result.str_colore_symbolico);
		if (i_ndx <> -1) then result := globale.table_colori_symbolici.get_colore(i_ndx).lo_colore
	end
end;

{$endif CASA}

{$ifdef GALATEO_EXE}

function cl_colonna_colorata.assign(source : cl_colonna_colorata) : cl_colonna_colorata;
begin
	bo_disabled := source.bo_disabled;
	str_condizione_abilitazione := source.str_condizione_abilitazione;
	str_descrizione := source.str_descrizione;
	colore_base.assign(source.colore_base);
	tipo_colore := source.tipo_colore;
	tipo_limite := source.tipo_limite;
	fl_margine_sx_cm := source.fl_margine_sx_cm;fl_margine_dx_cm := source.fl_margine_dx_cm;
	str_formula_margine_sx_CM := source.str_formula_margine_sx_CM;str_formula_margine_dx_CM := source.str_formula_margine_dx_CM;
	str_limite_object := source.str_limite_object;str_left_line := source.str_left_line;str_right_line := source.str_right_line;
	for var i : byte := 0 to MAX_COLORI_CONDIZIONALI-1 do colori_condizionali[i].assign(source.colori_condizionali[i]);
	gradazione.assign(source.gradazione);
	result := self
end;

function cl_colonna_colorata.get_numero_colori_condizionali(bo_ignora_tipo_colore : boolean = FALSE) : smallint;
{ rende il numero di colori condizionali NOT BLANK, non necessariamente contigui (possono esserci dei vuoti, poi eliminati al momento del salvataggio);
  se TIPO_COLORE != TCCC_CONDIZIONE rende ZERO, a meno che BO_IGNORA_TIPO_COLORE non sia TRUE }
begin
	result := 0;
	if (tipo_colore = TCCC_CONDIZIONE) OR bo_ignora_tipo_colore then
//		while (result < MAX_COLORI_CONDIZIONALI) AND (colori_condizionali[result].colore.lo_colore <> 0) do inc(result)
		while (result < MAX_COLORI_CONDIZIONALI) AND NOT colori_condizionali[result].is_blank do inc(result)
end;

{$endif GALATEO_EXE}

function apply_colori_symbolici_colonne_colorate(cca : colonna_colorata_array) : boolean;
begin
	result := FALSE;
	for var i : smallint := 0 to high(cca) do
		if cca[i].apply_colori_symbolici then result := TRUE
end;

{$ifdef GALATEO_EXE}

function apply_change_name_colore_symbolico(str_from, str_to : string) : boolean;
{ applica il cambiamento di NOME SYMBOLICO del colore e lo trasmette a tutti gli oggetti (in particolare alle COLONNE_COLORATE);
  rende TRUE se esegue delle sostituzioni }
begin
	result := FALSE;
	for var i_page_ZB : logical_page_type := 0 to get_ultima_pagina_logica - 1 do begin
		for var i_sez_ZB : section_index_type := 1 to get_num_sections_page_ZB(i_page_ZB) - 1 do begin	// la sezione 0 (main) NON ha colonne colorate
			var sz : cl_sezione := sections_ZB(i_sez_ZB, i_page_ZB);
			for var i : smallint := 0 to high(sz.colonne_colorate) do begin
				var cc : cl_colonna_colorata := sz.colonne_colorate[i];
//				if (cc.str_colore_symbolico_base = str_from) then begin result := TRUE;cc.str_colore_symbolico_base := str_to end;
				if cc.colore_base.apply_change_name_colore_symbolico(str_from, str_to) then result := TRUE;
				for var j : smallint := 0 to cc.get_numero_colori_condizionali - 1 do
					if cc.colori_condizionali[j].colore.apply_change_name_colore_symbolico(str_from, str_to) then result := TRUE;
				if cc.gradazione.apply_change_name_colore_symbolico(str_from, str_to) then result := TRUE
			end
		end
	end
end;

{$endif}
initialization

finalization
	{$ifdef DEBUG} CCI(i_colonna_colorata, 'cl_colonna_colorata', 'colori_proc.pas') {$endif}
end.
