unit print_types;		//*

{$I defines}
{$ifdef PROVA_FAST} {$R-,S-} {$undef DEBUG} {$endif}
{$ifNdef CASA} *** {$endif}

interface

uses DB, Sysutils, Windows, VCL.Graphics, Math, VCL.Forms,
	Fcommons, Ftime, gdich, colori_proc;

type
	PS_RW_TYPE = (PS_READ, PS_WRITE);	// Print Section Read/Write

{$ifdef CASA}
	// struttura che contiene un campo (compreso il valore che deve essere stampato)
	cl_print_campo = class
		public
			next : cl_print_campo;
			i_obj : obj_index_type;		// #oggetto
			{$ifdef DEBUG} lo_id_campo, lo_id_campo_copyfrom : integer; {$endif}		// identificatore univoco del campo, serve solo a scopi di debugging
			DataType: TFieldType;
			lp_value : LPSTR;					// contenuto del campo
			bo_continuazione : boolean;	// continuazione di stampa (2007-06-16)
			bo_dont_print : boolean;		// la stampa dell'oggetto, per motivi di ordine superiore, non deve essere eseguita
			bo_null : boolean;
			constructor create(i_obj : obj_index_type;ff : TField;lp_modified_value : LPSTR;bo_senza_dati : boolean);
			constructor create_copy(i_obj : obj_index_type;ff : TField);
			destructor free;
			procedure copy(rec : cl_print_campo);
		private
			r_delta_y_print, r_delta_y_int_print : misura_real_type;
			procedure init(i_obj : obj_index_type;ff : TField;lp_modified_value : LPSTR;bo_senza_dati : boolean);
	end;

	// struttura che contiene le informazioni di stampa (compresi i valori delle variabili) per una sezione
	cl_print_section = class
		next : cl_print_section;
		i_logical_page_1B, i_logical_page_ZB : logical_page_type;
		i_section_1B, i_section_ZB : section_index_type;
		lo_id : integer;									// identificatore univoco record
		str_PK_debug_key : string;						// identifica opzionalmente il valore della PK del record; serve a scopo di debugging
		recs : cl_print_campo;
		str_value_codice_record : string;
		str_runtime_filename : string;				// nomefile qualora sia desunto dai valori della presente sezione; usato solo per records della MAIN SECTION
		bo_changed_group_field_value : boolean;	// TRUE quando il valore referenziato da STR_SECTION_GROUP_FIELD è diverso dal record precedente
		r_y0_cm : misura_real_type;					// Y0 di stampa per la sezione (relativo alla pagina)
		r_height_cm : misura_real_type;				// altezza della sezione
		bo_vuota : boolean;								// TRUE se mancano records da stampare, e si desidera eseguire una stampa a vuoto
		lo_record_number : integer;					// 0-based -- numero di record per la sezione
		lo_LP_record_number : integer;				// 0-based -- numero progressivo di record per la Pagina Logica; serve solo per alimentare i contatori che mostrano all'utente a che punto ci si trova della stampa
		i_ph_page_start : ph_page_type;			// pagina fisica su cui è iniziata la stampa della sezione
		i_ph_page_end : ph_page_type;				// pagina fisica su cui è terminata la stampa della sezione
//		bo_first_page : boolean;						// il record si trova sulla PRIMA pagina fisica utilizza per la stampa del record (2002-12-08)
//		bo_last_page : boolean;							// il record si trova sull'ULTIMA pagina fisica utilizza per la stampa del record (2002-12-08)
		bo_continuazione : boolean;					// TRUE se l'oggetto rappresenta la continuazione della stampa di un oggetto che non ha potuto essere completato sulla pagina precedente (2005-09-19)
//		str_XML : string;									// dati XML per la sezione
		cc_values : array of colonna_colorata_executive_values;	// dati esecutivi necessari per la stampa delle colonne colorate
		runtime_rect : TRect;							// esprime le misure della sezione a runtime, in PIXELS; può contenere valori VIDEO oppure PRINTER
		constructor create(i_logical_page_1B : logical_page_type;i_section_1B : section_index_type;bo_continuazione : boolean = FALSE);
		destructor free;
		procedure copy(source : cl_print_section;bo_copy_id : boolean);
		function get_record(i_obj : obj_index_type) : cl_print_campo;
		procedure insert_complementary_set;
		procedure new_record(i_obj : obj_index_type;ff : TField;lp_modified_value : LPSTR;bo_campo_vuoto : boolean);
		procedure set_section_y0_pos(r_y0_cm : misura_real_type);
		procedure set_section_height(r_height_cm : misura_real_type);
		procedure set_section_fields_values(i_section_1B : section_index_type;write_to_objects : PS_RW_TYPE;
			bo_left_values, bo_only_pos_size, bo_forza_calcolo_formule : boolean);
		procedure registra_colonne_colorate_values;
	end;

	// struttura che contiene i campi relativi ad una pagina di stampa
	cl_print_page = class
		next : cl_print_page;
		i_virtual_page_1B, i_virtual_page_ZB : ph_page_type;	// coincide con la pagina fisica per le stampe di reports, con il numero di etichetta se LABELS
		sections : cl_print_section;
		constructor create(i_virtual_page_1B : ph_page_type);
		destructor free;
		procedure print_page(bo_video : boolean;vcanvas,pcanvas : TCanvas;r_dx0_cm,r_dy0_cm : misura_real_type;
			target : report_target_type;bo_exportazione_integrale : boolean = FALSE);
		function get_print_section_1B(lo_id : integer{$ifdef DEBUG};i_section_1B : section_index_type{$endif}) : cl_print_section;
	end;
{$endif}

{$ifdef CASA}
	DELTAY_REAL_TYPE = misura_real_type;
	DY_cm_type = array of DELTAY_REAL_TYPE;
	DY_cm_punt = ^DY_cm_type;
	DY_cm_array = array of DY_cm_type;
	section_data_type = record
		i_obj : obj_index_type;
		i_top, i_bottom : int_pixel_type;
	end;
	section_data_punt = ^section_data_type;
	cl_section_print_objects = class
		{ questa classe contiene tutti gli oggetti che appartengono ad una sezione;
		  gli indici positivi si riferiscono al vettore OBJS e referenziano gli oggetti;
		  gli indici negativi referenziano le sezioni figlie della sezione in trattamento;
		  l'ordine degli oggetti nel vettore segue la posizione verticale sulla pagina: il primo oggetto è quello più in alto, l'ultimo quello più in basso;
		  questa struttura serve a calcolare la posizione degli oggetti considerando le variazioni di altezza di oggetti e sezioni;
		  non rappresenta l'ordine di stampa (con conseguenti possibili sovrapposizioni degli oggetti successivi sugli oggetti precedenti) è determinata
		  dall'ordine naturale degli oggetti }
		public
			i_objs : obj_index_type;		// numero di oggetti
			ys : array[1..MAX_OBJS] of section_data_type;
			procedure add_object(i_obj : obj_index_type);
			constructor create(i_logical_page_1B : logical_page_type;i_section_1B : section_index_type);
			procedure reset;
			procedure reset_scostamenti(i_page : ph_page_type);
			procedure sort;
			destructor free;
			function get_deltay_cm_totale : DELTAY_REAL_TYPE;
			function get_deltay_cm_for_object(i_obj : obj_index_type) : DELTAY_REAL_TYPE;
			function get_deltay_cm_in_object(i_print_obj, i_obj : obj_index_type) : DELTAY_REAL_TYPE;
			function get_deltay_cm_for_y_pos(y_pixel_pos : int_pixel_type;bo_calculate_on_bottom : boolean = FALSE) : DELTAY_REAL_TYPE;
			procedure set_deltay_cm(i_obj : obj_index_type;r_deltay_cm_value : DELTAY_REAL_TYPE);
		private
			deltay_cm : DY_cm_array;	// 0-based, anche se le pagine sono indicizzate 1-based
			bo_sorted : boolean;
			i_section_ZB, i_section_1B : section_index_type;
			i_logical_page_ZB, i_logical_page_1B : logical_page_type;
			function get_DY_cm(i_page_1B : ph_page_type) : DY_cm_punt;
			procedure free_DY;
	end;

function copy_print_section_record(sv : cl_print_section;pp : cl_print_page;bo_continuazione : boolean) : cl_print_section;
procedure delete_first_print_section_record(var sv_head : cl_print_section);
procedure delete_print_section_record(var sv_head : cl_print_section;lo_id : integer{$ifdef DEBUG};i_section_1B : section_index_type{$endif});
procedure delete_print_sections_from_to(pp : cl_print_page;lo_id_from,lo_id_to : integer);
//procedure move_print_section_record(sv,sv_head : cl_print_section;print_page_destination : cl_print_page);
procedure print_page(pp : cl_print_page;i_virtual_page_1B : ph_page_type;bo_video : boolean;vcanvas,pcanvas : TCanvas;
	r_dx0_cm,r_dy0_cm : misura_real_type;target : report_target_type;bo_exportazione_integrale : boolean = FALSE);

var
	print_pages_1B : array[1..MAX_PAGINE_LOGICHE] of cl_print_page;	// variabile che contiene le pagine logiche durante la stampa

{$endif CASA}

{$ifdef CHECK_SECTIONS} procedure check_sections(s : cl_print_section;str_msg : string); {$endif}

implementation

uses Fassert, Fdebug, FXstrings, Fstrings, FErrMsg, FProcs,
	galateo_debug, proc, expint_base, objsx, misure, pages, sezione, objects, functions, labels {$ifdef CASA}, GAPP{$endif};

var
	lo_id_print_sections : integer;	// progressivo POSITIVO che identifica le sezioni di stampa
	{$ifdef DEBUG} i_print_campo, i_print_section, i_print_page, i_section_print_objects : integer; {$endif}
	{$ifdef DEBUG} lo_id_campo_progressivo : integer; {$endif}		// identificatore univoco del campo, serve solo a scopi di debugging

// -----------------------------------------------------------------------------

{$ifdef CASA}

constructor cl_print_campo.create(i_obj : obj_index_type;ff : TField;lp_modified_value : LPSTR;bo_senza_dati : boolean);
{ se LP_MODIFIED_VALUE <> NIL, contiene modifiche intervenute sul dato contenuto nel campo;
  in tal caso si deve sostituire il contenuto di FF con LP_MODIFIED_VALUE; purtroppo non è facile
  eliminare il parametro FF, che contiene altre importanti informazioni, e bisogna tenere entrambi
  i parametri, anche se effettivamente tendono ad essere l'uno un duplicato dell'altro;
  LP_MODIFIED_VALUE è utile che sia un LPSTR; perchè in questo modo ha anche il valore NIL }
begin
	{$ifdef DEBUG} inc(lo_id_campo_progressivo);lo_id_campo := lo_id_campo_progressivo; {$endif}		// identificatore univoco del campo, serve solo a scopi di debugging
	init(i_obj, ff, lp_modified_value, bo_senza_dati)
end;

constructor cl_print_campo.create_copy(i_obj : obj_index_type;ff : TField);
begin
	{$ifdef DEBUG} inc(lo_id_campo_progressivo);lo_id_campo := lo_id_campo_progressivo; {$endif}		// identificatore univoco del campo, serve solo a scopi di debugging
	init(i_obj, ff, NIL, FALSE)
end;

procedure cl_print_campo.init(i_obj : obj_index_type;ff : TField;lp_modified_value : LPSTR;bo_senza_dati : boolean);
// BO_SENZA_DATI significa che il record viene registrato anche se non esistono dati associati (esempio: sezione priva di query)
var s : string;	//*
begin
	{$ifdef DEBUG} inc(i_print_campo); {$endif}
//	next := NIL;lp_value := NIL;bo_dont_print := FALSE;
	self.i_obj := i_obj;
	if (ff = NIL) then DataType := ftUnknown
	else begin
		datatype := ff.datatype;
		bo_null := ff.IsNull;
		if bo_senza_dati then strcpychk(lp_value, '')
		else begin
			case datatype of
				{ftMemo,} ftBlob: begin		// ftMemo tolto 2019-10-19 (DX) perchè fa casino con i caratteri (e ASSTRING funziona benissimo)
					if (lp_modified_value = NIL) then begin
						if NOT binary_2_string(ff, s) then abort;
						strcpychks(lp_value, s)
					end
					else strcpychk(lp_value, lp_modified_value)
				end;
				ftTime : begin
					if (lp_modified_value = NIL) then begin
						var tm := cl_time.create;
						s := asstring_time(ff.AsDateTime, TMFMT_HM + TMFMT_24H);
						if s = '00:00' then s := '';
						strcpychks(lp_value, s);
						tm.free
					end
//					else strcpy(lp_value,lp_modified_value)
					else strcpychks(lp_value, lp_modified_value)
				end;
				else begin
					if (lp_modified_value = NIL) then strcpychks(lp_value, ff.AsString) else strcpychk(lp_value, lp_modified_value);
					if NOT bo_null AND (strlen(lp_value) = 0) AND (datatype in NUMERIC_FIELDS) then strcpychks(lp_value, '0')
				end
			end
		end
	end
end;

destructor cl_print_campo.free;
begin
	{$ifdef DEBUG} dec(i_print_campo); {$endif}
	strdispose(lp_value)
end;

procedure cl_print_campo.copy(rec : cl_print_campo);
begin
//	next := DA NON COPIARE;
	i_obj := rec.i_obj;
	{$ifdef DEBUG} lo_id_campo_copyfrom := rec.lo_id_campo; {$endif}
	if (rec.lp_value <> NIL) then begin	// altrimenti lo lascio a NIL
		lp_value := stralloc(strbufsize(rec.lp_value));
		strcpy(lp_value, rec.lp_value)
	end;
	datatype := rec.datatype;
	bo_dont_print := rec.bo_dont_print;
	bo_null := rec.bo_null
end;

// -----------------------------------------------------------------------------

constructor cl_print_section.create(i_logical_page_1B : logical_page_type;i_section_1B : section_index_type;bo_continuazione : boolean = FALSE);
begin
	{$ifdef DEBUG} inc(i_print_section); {$endif}
	self.i_logical_page_1B := i_logical_page_1B;self.i_logical_page_ZB := i_logical_page_1B - 1;
	next := NIL;self.i_section_1B := i_section_1B;self.i_section_ZB := i_section_1B - 1;
	recs := NIL;
	inc(lo_id_print_sections);
	lo_id := lo_id_print_sections;	// identificatore univoco
	bo_vuota := TRUE;self.bo_continuazione := bo_continuazione;			// la sezione è vuota fino a diversa evidenza
	i_ph_page_start := 0;i_ph_page_end := 0;
//	bo_first_page := TRUE;bo_last_page := TRUE;		// fino a prova contraria
	if (i_section_ZB <> -1) then setLength(cc_values, length(sections_ZB(i_section_ZB, i_logical_page_ZB).colonne_colorate))
end;

destructor cl_print_section.free;
begin
	{$ifdef DEBUG} dec(i_print_section); {$endif}
	while (recs <> NIL) do begin var rec : cl_print_campo := recs;recs := recs.next;rec.free end
end;

{$ifdef CHECK_SECTIONS}

	procedure check_sections(s : cl_print_section;str_msg : string);
	// esegue controlli basilari sulla coerenza e correttezza delle sezioni
	begin
		if (s = NIL) then exit;
		while (s.next <> NIL) do begin
			var rec : cl_print_section := s.next;var lo : integer := s.lo_id;
//			i_prev := s.i_section;
			while (rec <> NIL) do begin
				// due oggetti consecutivi non possono appartenere a sezioni non contigue
// controllo commentato il 2002-09-01, perchè non sono sicuro della correttezza e necessità
{				assert(abs(rec.i_section - i_prev) <= 1,'ABS(delta section) -- ' + str_msg + ACAPO+
					'ID='+inttostr(rec.xlo_id)+', sez.'+inttostr(rec.i_section)+ACAPO+
					'ID='+'N/A'+', sez.'+inttostr(i_prev)+ACAPO+
					'JKX 399'); }

				assert(rec.lo_id <> lo,str_msg + ACAPO + 'LO_ID: ' + inttostr(lo) + ' doppio KJW 923 ');
//				i_prev := rec.i_section;
				rec := rec.next
			end;
			s := s.next
		end
	end;

{$endif CHECK_SECTIONS}

procedure cl_print_section.copy(source : cl_print_section;bo_copy_id : boolean);
// SELF := source; copia i valori e non i riferimenti
begin
//	next := DA NON COPIARE;
	i_section_1B := source.i_section_1B;i_section_ZB := source.i_section_ZB;
	self.i_logical_page_1B := source.i_logical_page_1B;self.i_logical_page_ZB := source.i_logical_page_ZB;	// aggiunto 2020-03-18 --- chissà perchè non c'era ????????
	lo_record_number := source.lo_record_number;
	lo_LP_record_number := source.lo_LP_record_number;
	var rec : cl_print_campo := source.recs;
	var rec_temp : cl_print_campo := NIL;
	recs := NIL;
	r_y0_cm := source.r_y0_cm;
	i_ph_page_start := source.i_ph_page_start;
	i_ph_page_end := source.i_ph_page_end;
	str_value_codice_record := source.str_value_codice_record;
	str_runtime_filename := source.str_runtime_filename;
	bo_changed_group_field_value := source.bo_changed_group_field_value;
	if bo_copy_id then lo_id := source.lo_id;
	str_PK_debug_key := source.str_PK_debug_key;
	while (rec <> NIL) do begin
		var rec_new := cl_print_campo.create_copy(0, NIL);
		rec_new.copy(rec);
		if (recs = NIL) then begin recs := rec_new;rec_temp := recs end
		else begin rec_temp.next := rec_new;rec_temp := rec_new end;
		rec := rec.next
	end;
	setLength(cc_values, length(source.cc_values));
	for var i_cc := 0 to high(cc_values) do cc_values[i_cc] := source.cc_values[i_cc];
	runtime_rect := source.runtime_rect
end;

function cl_print_section.get_record(i_obj : obj_index_type) : cl_print_campo;
{ rende un referenziatore del record relativo all'oggetto con indice I_OBJ;
  rende NIL se tale record non esiste }
begin
	result := recs;
	while (result <> NIL) AND (result.i_obj <> i_obj) do result := result.next
end;

procedure cl_print_section.new_record(i_obj : obj_index_type;ff : TField;lp_modified_value : LPSTR;bo_campo_vuoto : boolean);
{ se LP_MODIFIED_VALUE <> NIL, contiene modifiche intervenute sul dato contenuto nel campo;
  in tal caso si deve sostituire il contenuto di FF con LP_MODIFIED_VALUE; purtroppo non è facile
  eliminare il parametro FF, che contiene altre importanti informazioni, e bisogna tenere entrambi
  i parametri, anche se effettivamente tendono ad essere un duplicato l'uno dell'altro;
  LP_MODIFIED_VALUE è utile che sia un LPSTR; perchè in questo modo ha anche il valore NIL }
begin
	if NOT bo_campo_vuoto then bo_vuota := FALSE;
	var rec_new : cl_print_campo := cl_print_campo.create(i_obj, ff, lp_modified_value, bo_campo_vuoto);
	if (recs = NIL) then recs := rec_new
	else begin
		var rec : cl_print_campo := recs;while (rec.next <> NIL) do rec := rec.next;
		rec.next := rec_new
	end
end;

procedure cl_print_section.set_section_y0_pos(r_y0_cm : misura_real_type); begin self.r_y0_cm := r_y0_cm end;
procedure cl_print_section.set_section_height(r_height_cm : misura_real_type); begin self.r_height_cm := r_height_cm end;

procedure cl_print_section.registra_colonne_colorate_values;
// recupera e stokka i valori esecutivi da utilizzare per le colonne colorate
begin
	var sz : cl_sezione := sections_ZB(i_section_1B - 1, i_logical_page_1B - 1);
	for var i : smallint := 0 to high(sz.colonne_colorate) do begin
		cc_values[i].bo_disabled := sz.colonne_colorate[i].bo_disabled;
		if NOT cc_values[i].bo_disabled AND (sz.colonne_colorate[i].str_condizione_abilitazione <> '') then begin
			var bo_enabled : boolean;var s : string;
			interpreta_boolean_expression(sz.colonne_colorate[i].str_condizione_abilitazione, {test}FALSE, bo_enabled, s);
			cc_values[i].bo_disabled := NOT bo_enabled
		end;
		if cc_values[i].bo_disabled then continue;		// inutile proseguire nella valutazione dei valori
		cc_values[i].lo_colore := sz.colonne_colorate[i].get_executive_color;
		cc_values[i].margine_sx_cm := sz.colonne_colorate[i].get_margine_sx_cm;
		cc_values[i].margine_dx_cm := sz.colonne_colorate[i].get_margine_dx_cm
	end
end;

procedure cl_print_section.set_section_fields_values(i_section_1B : section_index_type;
	write_to_objects : PS_RW_TYPE;bo_left_values, bo_only_pos_size, bo_forza_calcolo_formule : boolean);
{ if write_to_objects=PS_WRITE then preleva da SELF il contenuto di una sezione e lo scrive sugli oggetti; altrimenti fa il contrario;
  gli "OGGETTI" contengono i valori dei records da stampare;
  durante la preparazione della stampa (PS_WRITE) vengono letti i records uno ad uno e salvati sugli oggetti;
  durante la stampa (PS_READ) i valori da stampare vengono letti dagli oggetti e assegnati alla sezione, che verrà poi stampata;
  if (BO_LEFT_VALUES) then utilizza la parte di valori trascurati dalla procedure di stampa, altrimenti i valori originali;
  if BO_ONLY_POS_AND_SIZE then le operazioni vengono effettuate solamente sugli attributi di dimensione e posizione;
  BO_FORZA_CALCOLO_FORMULE obbliga al ricalcolo delle formule; in alternativa vengono ricalcolate
  solo le formule vuote, lasciando intatto il valore delle formule già calcolate ed eventualmente
  aggiustate dal processo di stampa (esempio: formule che vanno su più pagine e che NON devono
  essere ricalcolate ad ogni pagina) }
//const TIPI_OBJ_AMMESSI = [VARIABILE, FORMULA];	// fino al 2000-05-10 era solo VARIABILE	****** così fino al 2011-05-19
const MBOX_CAPTION_DEBUG = 'set_section_fields_values()';
var lp2_source, lp2_dest : ^LPSTR;
begin
	runtime_debug('000 start', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
{$ifdef DEBUG}
	if bo_forza_calcolo_formule then assert(write_to_objects = PS_WRITE, 'AJSD 9877');
	{$ifdef CHECK_SECTIONS} check_sections(self, 'set_section_fields_values()'); {$endif}
	assert(i_section_1B = self.i_section_1B, 'set_section_fields_values: sezione scorretta');
	if (i_section_1B <> self.i_section_1B) then abort;
{$endif}
	for var i : obj_index_type := 1 to i_objs do begin
		var obj : objs_type := xobjs(i, i_logical_page_1B);
		if (obj.ca.i_section_1B <> i_section_1B) then continue;
		var rec : cl_print_campo := get_record(i);
		{$ifdef DEBUG} assert(rec <> NIL, 'set_section_fields_values: record not found -- LIXM 9981'); {$endif}
		if (rec = NIL) then abort;
		runtime_debug('100 loop-' + zeri(i,4) + '-' + obj.get_name(), MBOX_CAPTION_DEBUG, RD_DEBUG_DETTAGLIO_02);

		if NOT bo_only_pos_size then begin
			var tv : variabile_type := obj.tipo_variabile;
//			if (tipo in TIPI_OBJ_AMMESSI) then lab := obj.aslabel else lab := NIL; }
			var ca : cl_common_attributes := NIL;
			if NOT (tv in [TV_BLANK, TV_STATIC_TEXT]) then ca := obj.ca;
			if (ca <> NIL) AND NOT (tv in TV_COSTANTI + [TV_FORMULA]) then begin
				if (write_to_objects = PS_WRITE) then begin	// preleva da SELF e scrive sugli oggetti (formattazione della stampa: leggo da REC e scrivo su OBJ)
					lp2_source := @rec.lp_value;
					if bo_left_values AND (ca.lp_print_left <> NIL) then lp2_dest := @ca.lp_print_left
					else lp2_dest := @ca.lp_print
				end
				else begin	// PS_READ: preleva dagli oggetti e scrive sulla sezione (esecuzione della stampa: leggo da OBJ e scrivo su REC)
					if bo_left_values AND (ca.lp_print_left <> NIL) then lp2_source := @ca.lp_print_left
					else begin
						lp2_source := @ca.lp_print;
//						if (obj.get_name = sections(i_section).str_field_codice_record) then str_value_codice_record := strpas(lab.lp_print)
					end;
					lp2_dest := @rec.lp_value
				end;
				{$ifdef DEBUG} assert(lp2_source^ <> NIL, 'lp2_source^ = NIL -- KJWI 9291'); {$endif}
				if (lp2_source^ <> NIL) then strcpychk(lp2_dest^, lp2_source^)
			end;

			if (obj.tipo_oggetto = LABEL_OBJ) then begin	// trattamento valid NULL -- bisognerebbe valutare la gestione anche di DATAMATRIX_OBJ
				if (write_to_objects = PS_WRITE) then begin	// formattazione della stampa: leggo da REC e scrivo su OBJ
					obj.bo_dont_print := rec.bo_dont_print;
//					if (ca <> NIL) then obj.aslabel.bo_null := rec.bo_null;
//					if (ca <> NIL) then rec.bo_null := obj.aslabel.bo_null;
					if (ca <> NIL) then begin
						var lab : cl_label := obj.aslabel;
						lab.bo_null := rec.bo_null;
						if NOT (tv in TV_COSTANTI) AND	// escludo i parametri, perchè il valore originale rischia di perdersi
							(ca.tipo_valore = VAL_NUMERO)
						then begin
							if (rec.lp_value = NIL) then lab.reset_print_value
{							else begin
								if lab.bo_null then fl := 0 else fl := rec.lp_value;
								lab.assign_formatted_numeric_print_value(ifr(bo_null, 0, fl))
							end; }
							else if NOT rec.bo_null then begin
								lab.assign_formatted_numeric_print_value(rec.lp_value);
								lab.applica_formato_numerico
							end
						end
					end
				end
				else begin		//  esecuzione della stampa: leggo da OBJ e scrivo su REC
//					rec.bo_dont_print := obj.bo_dont_print	// PS_READ
//					if (ca <> NIL) then rec.bo_null := obj.aslabel.bo_null
//					if (ca <> NIL) then obj.aslabel.bo_null := rec.bo_null
					if (ca <> NIL) then rec.bo_null := obj.aslabel.bo_null
				end
			end
		end;

		if (write_to_objects = PS_WRITE) then obj.set_print_pos_and_size(rec.r_delta_y_print, rec.r_delta_y_int_print)
		else obj.get_print_pos_and_size(rec.r_delta_y_print, rec.r_delta_y_int_print)
	end;
	runtime_debug('200 after loop', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
	if (write_to_objects = PS_WRITE) AND NOT bo_only_pos_size AND NOT calcola_values(GH, TRUE, i_section_1B, NOT bo_forza_calcolo_formule) then abort;
	runtime_debug('210 before colonne colorate', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01);
	if (write_to_objects = PS_READ) then registra_colonne_colorate_values;
	runtime_debug('999 end', MBOX_CAPTION_DEBUG, RD_DEBUG_ACCESSORIO_01)
end;

procedure cl_print_section.insert_complementary_set;
{ aggiunge un nuovo set di valori dopo SELF, prendendo la parte di contenuto degli oggetti
  che le procedure di stampa hanno scartato perchè non sono riuscite a trattare (LP_PRINT_LEFT) }
begin
	var xnext : cl_print_section := next;
	next := cl_print_section.create(i_logical_page_1B, i_section_1B);
	next.next := xnext;
	next.copy(self, FALSE);	// copio tutti i valori della print_section attuale
	next.set_section_fields_values(i_section_1B, PS_READ, {bo_left_values:=}TRUE, FALSE, FALSE)
end;

// -----------------------------------------------------------------------------

constructor cl_print_page.create(i_virtual_page_1B : ph_page_type);
begin
	{$ifdef DEBUG} inc(i_print_page);{register_create(CHKM_GALATEO_PRINT_PAGE,self);} {$endif}
	next := NIL;
	self.i_virtual_page_1B := i_virtual_page_1B; self.i_virtual_page_ZB := i_virtual_page_1B - 1;
	sections := NIL
end;

destructor cl_print_page.free;
begin
	{$ifdef DEBUG} dec(i_print_page);{register_free(CHKM_GALATEO_PRINT_PAGE,self);} {$endif}
	while (sections <> NIL) do begin
		var sec : cl_print_section := sections;sections := sections.next;
		sec.free
	end
end;

{$ifdef DEBUG}
	var bo_inside_print_page : boolean;
{$endif}

procedure cl_print_page.print_page(bo_video : boolean;vcanvas,pcanvas : TCanvas;r_dx0_cm,r_dy0_cm : misura_real_type;
	target : report_target_type;bo_exportazione_integrale : boolean = FALSE);
// target serve principalmente per le EXPORTAZIONI
begin
{$ifdef DEBUG}
	// controllo che i records dati non siano caricati piu' d'una volta
	if bo_inside_print_page then exit;	// no reentrant calls, please
	bo_inside_print_page := TRUE;
	{$ifdef CHECK_SECTIONS} check_sections(sections,'print_page()'); {$endif}
	bo_inside_print_page := FALSE;
{$endif}

	var sz : cl_print_section := sections;
	while (sz <> NIL) do begin
		pages.sections_1B(sz.i_section_1B).print_section(sz, bo_video, vcanvas, pcanvas, r_dx0_cm, r_dy0_cm, i_virtual_page_1B, bo_exportazione_integrale, target);
		sz := sz.next
	end
end;

function cl_print_page.get_print_section_1B(lo_id : integer{$ifdef DEBUG};i_section_1B : section_index_type{$endif}) : cl_print_section;
// rende la section che è identificata da LO_ID
begin
	var sec : cl_print_section := sections;
	while (sec <> NIL) AND (sec.lo_id <> lo_id) do sec := sec.next;
{$ifdef DEBUG}
	if (sec <> NIL) AND (i_section_1B <> sec.i_section_1B) then
		assert(FALSE,'i_section=' + i_section_1B.ToString + '!=' + sec.i_section_1B.ToString + '    -- FDPX 3929 -- id=' + lo_id.ToString);
{$endif}
	result := sec
end;

procedure print_page(pp : cl_print_page;i_virtual_page_1B : ph_page_type;bo_video : boolean;vcanvas, pcanvas : TCanvas;
	r_dx0_cm, r_dy0_cm : misura_real_type;target : report_target_type;bo_exportazione_integrale : boolean = FALSE);
begin
	set_virtual_printing_page(i_virtual_page_1B);
	{$ifdef DEBUG} if (target <> RTA_EXPORT) then assert(NOT bo_exportazione_integrale, 'print_page() -- BO_EXPORTAZIONE_INTEGRALE is TRUE, ma non dovrebbe !!!'); {$endif}
	while (pp <> NIL) AND (pp.i_virtual_page_1B <> i_virtual_page_1B) do pp := pp.next;
	if (pp = NIL) then abort;
	pp.print_page(bo_video, vcanvas, pcanvas, r_dx0_cm, r_dy0_cm, target, bo_exportazione_integrale)
end;

// -----------------------------------------------------------------------------

constructor cl_section_print_objects.create(i_logical_page_1B : logical_page_type;i_section_1B : section_index_type);
begin
	{$ifdef DEBUG} inc(i_section_print_objects); {$endif}
	self.i_logical_page_1B := i_logical_page_1B;self.i_logical_page_ZB := i_logical_page_1B - 1;
	self.i_section_1B := i_section_1B;self.i_section_ZB := i_section_1B - 1
//	for var i : smallint := 1 to MAX_PHISICAL_PAGES_PER_LOGICAL_PAGE do xr_deltay_cm[i] := NIL;
//	reset
end;

destructor cl_section_print_objects.free;
begin
	{$ifdef DEBUG} dec(i_section_print_objects); {$endif}
	free_DY
end;

procedure cl_section_print_objects.free_DY;
begin
	for var i : ph_page_type := 0 to high(deltay_cm) do deltay_cm[i] := NIL;
	deltay_cm := NIL
end;

procedure cl_section_print_objects.add_object(i_obj : obj_index_type);
{ if I_OBJ > 0 then si tratta di un object (e I_OBJ è l'indice dell'oggetto relativo a OBJECTS.OBJS),
  altrimenti di una sottosezione, e -I_OBJ è l'indice della sottosezione }
begin
	{$ifdef DEBUG} assert(NOT bo_sorted, 'cl_section_print_objects.add_object() -- lista già ordinata, impossibile inserire altro'); {$endif}
	var bo_section := (i_obj < 0);
	if NOT bo_section then begin
		var objx : objs_type := pages.xobjs(i_obj, i_logical_page_1B);
		if objx.is_hidden(0)
		// riga successiva: 2007-01-06, a seguito gestione exportazione integrale;
		// se l'oggetto può essere exportato, è necessario caricarlo anche se nascosto altrimenti non è possibile eseguire l'exportazione
			AND (NOT (objx.ca.tipo_oggetto in EXPINT_OBJS) OR (objx.aslabel.ZB_get_running_export_type(-1, i_logical_page_ZB) = OEXP_NOT))
				then exit	// object not to print
	end;

	inc(i_objs);
	var ptys : section_data_punt := @ys[i_objs];
	ptys.i_obj := i_obj;
//	i_obj := abs(i_obj);
	if bo_section then begin
		i_obj := -i_obj;	// indice originariamente negativo
		ptys.i_top := cm2pixel_video_y(sections_1B(i_obj).r_y0_rel_cm);
		if (globale.box_new_valutazione_scostamento = XTRUE) then
			ptys.i_bottom := ptys.i_top	// non meno di così; utile per la gestione degli scostamenti verticali -- 2007-01-14
		{ la riga qui sotto è stata sostituita dalla successiva il 2021-03-21
		  serve conoscere il BOTTOM per gestire cornici che (anomalmente) iniziano sopra la sezione e finiscono nel mezzo della sezione }
//		else ptys.i_bottom := 0	// vecchio metodo fa casino se il bottom delle sezioni è uguale al top -- 2007-01-22
		else ptys.i_bottom := ptys.i_top + cm2pixel_video_y(sections_1B(i_obj).r_y_sezione_cm)
	end
	else with pages.xobjs(i_obj, i_logical_page_1B) do begin
		ptys.i_top := get_top;
		ptys.i_bottom := ptys.i_top + get_height
	end
end;

procedure cl_section_print_objects.reset;
// resetta tutto
begin
	i_objs := 0;bo_sorted := FALSE;
//	fillchar(objs,sizeof(objs),0);
//	fillchar(y_top,sizeof(y_top),0);fillchar(y_bottom,sizeof(y_bottom),0);
	fillchar(ys, sizeof(ys), 0);
	free_DY
end;

procedure cl_section_print_objects.reset_scostamenti(i_page : ph_page_type);
{ resetta solo i valori degli scostamenti;
  da chiamare alla fine del trattamento di una sezione, per resettare i valori degli oggetti che le appartengono;
  introdotta 2007-01-15 }
begin
//	exit;	{$ifdef DEBUG} *** {$endif}
//	DY_cm := get_DY_cm(get_virtual_printing_page);
	var DY_cm : DY_cm_punt := get_DY_cm(i_page);
	for var i : obj_index_type := 0 to i_objs do DY_CM^[i] := 0
end;

procedure cl_section_print_objects.sort;
{ ordina in base alla posizione verticale;
  l'ordinamento avviene lasciando sul fondo alcuni oggetti che non possono
  influenzare gli altri oggetti, ma che possono essere influenzati: tipicamente
  gli oggetti grafici }

{	procedure change(i,j : obj_index_type);
	begin
		var i_temp : obj_index_type := objs[i];objs[i] := objs[j];objs[j] := i_temp;
		i_temp := y_top[i];y_top[i] := y_top[j];y_top[j] := i_temp;
		i_temp := y_bottom[i];y_bottom[i] := y_bottom[j];y_bottom[j] := i_temp
	end; }

const LAST_OBJECTS = [OBJ_RECT, OBJ_LINE];	// objs da lasciare sul fondo nella fase di valutazione preliminare, perchè subiscono gli effetti di quelli che stanno sopra
begin
	for var i : obj_index_type := 1 to i_objs-1 do
		for var j : obj_index_type := i+1 to i_objs do
			if ((ys[i].i_top > ys[j].i_top) AND NOT ((ys[j].i_obj > 0) AND (pages.xobjs(ys[j].i_obj, i_logical_page_1B).ca.tipo_oggetto in LAST_OBJECTS))) OR
				((ys[i].i_obj > 0) AND (pages.xobjs(ys[i].i_obj, i_logical_page_1B).ca.tipo_oggetto in LAST_OBJECTS))
			then begin
//				change(i,j);
//				i_temp := objs[i];objs[i] := objs[j];objs[j] := i_temp;
//				i_temp := ys[i].i_top;ys[i].i_top := y_top[j];y_top[j] := i_temp;
//				i_temp := y_bottom[i];y_bottom[i] := y_bottom[j];y_bottom[j] := i_temp
				var tmp := ys[i];ys[i] := ys[j];ys[j] := tmp
			end;
{	// ordino (più per sfizio che altro) gli oggetti sul fondo
	i := 1;while (i <= i_objs) AND NOT ((i > 0) AND NOT (objects.objs[objs[i]].get_tipo in LAST_OBJECTS)) do inc(i);
	for i := i to i_objs-1 do
		for j := i+1 to i_objs do
			if (ypos[i] > ypos[j]) then change(i,j); {}
	bo_sorted := TRUE
end;

function cl_section_print_objects.get_deltay_cm_totale : DELTAY_REAL_TYPE;
// rende lo shiftamento totale per il fondo della sezione
begin
	result := get_deltay_cm_for_y_pos(cm2pixel_video_y(sections_ZB(i_section_ZB).r_y_gruppo_cm))
end;

(*function cl_section_print_objects.get_deltay_cm_for_y_pos(y_pixel_pos : int_pixel_type;bo_calculate_on_bottom : boolean = FALSE) : DELTAY_REAL_TYPE;
{ restituisce il valore di scostamento verticale di un oggetto in funzione della variazione di altezza
  degli oggetti che si trovano sopra di lui (un oggetto è 'sopra un altro' quando il suo BOTTOM è sopra al TOP dell'oggetto sotto);
  se due o più oggetti hanno sovrapposizione orizzontale (due oggetti hanno sovrapposizione orizzontale quando
  nessuno dei due è sopra l'altro secondo la definizione data sopra) viene utilizzato lo scostamento max;
  funziona anche con scostamenti negativi }
var
	i, j : obj_index_type;
	fl_dy : misura_real_type;
begin
	var DY_cm : DY_cm_punt := get_DY_cm(get_virtual_printing_page);
	{$ifdef DEBUG} assert(DY_cm <> NIL, 'DY_cm = NIL -- UVBC 4742'); {$endif}
	i := 1;result := 0;

	if (globale.box_new_valutazione_scostamento = XTRUE) then begin
//		while (i <= i_objs) AND (ys[i].i_bottom < y_pixel_pos)
		while (i <= i_objs) AND (ys[i].i_bottom <= y_pixel_pos)	// accetto anche oggetti il cui top concide con la riga
//			AND (ys[i].i_top < y_pixel_pos)	// necessario per le subsections, che non hanno valori per Y_BOTTOM
		do begin
			fl_dy := DY_cm^[i];			// scostamento dovuto all'oggetto I
			if (fl_dy = 0) then inc(i)	// scostamento nullo: nessuna conseguenza
			else begin
				// tratto eventuali oggetti J orizzontalmente sovrapposti a I
				j := i + 1;
				while (j <= i_objs) AND
					(ys[j].i_bottom < y_pixel_pos) AND			// l'oggetto è sopra la posizione che sto studiando
					(ys[i].i_bottom > ys[j].i_top)			// l'oggetto I si sovrappone a J
				do begin
					// in caso di scostamenti combinati POSITIVI e NEGATIVI, considero il max() ovvero solo i positivi (più cautelativo)
					if (DY_cm^[j] <> 0) then fl_dy := max(fl_dy, DY_cm^[j]);		// controllo valore ZERO: per gli scostamenti negativi
					inc(j)
				end;
				i := j;
				result := result + fl_dy
			end
		end
	end
	else begin
		while (i <= i_objs) AND (ys[i].i_top < y_pixel_pos) do begin
			fl_dy := DY_cm^[i];
//			while (i < i_objs) AND (ypos[i] = ypos[i + 1]) do begin
			while (i < i_objs) AND (ys[i].i_bottom = ys[i+1].i_bottom) do begin
				inc(i);fl_dy := MAX(fl_dy, DY_cm^[i])
			end;
			result := result + fl_dy;
			inc(i)
		end
	end
end;*)

function cl_section_print_objects.get_deltay_cm_for_y_pos(y_pixel_pos : int_pixel_type;bo_calculate_on_bottom : boolean = FALSE) : DELTAY_REAL_TYPE;
{ restituisce il valore di scostamento verticale di un oggetto in funzione della variazione di altezza degli oggetti che si trovano sopra di lui;
  un oggetto è 'sopra un altro' quando il suo BOTTOM è sopra al TOP dell'altro oggetto);
  due oggetti hanno sovrapposizione orizzontale quando nessuno dei due è sopra l'altro secondo la definizione data sopra;
  se due o più oggetti hanno sovrapposizione orizzontale viene utilizzato lo scostamento max (nel nuovo metodo di calcolo);
  funziona anche con scostamenti negativi;
  2021-03-21 aggiunto BO_CALCULATE_ON_BOTTOM; i calcoli vengono eseguiti sul BOTTOM dell'oggetto anzichè sul TOP;
  serve per la valutazione degli scostamenti avvenuti tra l'inizio e la fine delle cornici, in cui non è corretto considerare il TOP }
var i, j : obj_index_type;
begin
	result := 0;
	var DY_cm : DY_cm_punt := get_DY_cm(get_virtual_printing_page);
	{$ifdef DEBUG} assert(DY_cm <> NIL, 'DY_cm = NIL -- UVBC 4742'); {$endif}
	i := 1;

	if (globale.box_new_valutazione_scostamento = XTRUE) then begin
//		while (i <= i_objs) AND (ys[i].i_bottom < y_pixel_pos)
		while (i <= i_objs) AND (ys[i].i_bottom <= y_pixel_pos)	// accetto anche oggetti il cui top concide con la riga
//			AND (ys[i].i_top < y_pixel_pos)	// necessario per le subsections, che non hanno valori per Y_BOTTOM
		do begin
			var fl_dy1 : misura_real_type := DY_cm^[i];	// scostamento dovuto all'oggetto I
			if (fl_dy1 = 0) then inc(i)		// scostamento nullo: nessuna conseguenza
			else begin
				// tratto eventuali oggetti J orizzontalmente sovrapposti a I
				j := i + 1;
				while (j <= i_objs) AND
					(ys[j].i_bottom < y_pixel_pos) AND			// l'oggetto è sopra la posizione che sto studiando
					(ys[i].i_bottom > ys[j].i_top)			// l'oggetto I si sovrappone a J
				do begin
					// in caso di scostamenti combinati POSITIVI e NEGATIVI, considero il max() ovvero solo i positivi (più cautelativo)
					if (DY_cm^[j] <> 0) then fl_dy1 := max(fl_dy1, DY_cm^[j]);		// controllo valore ZERO: per gli scostamenti negativi
					inc(j)
				end;
				i := j;
				result := result + fl_dy1
			end
		end
	end
	else begin
		while (i <= i_objs) AND (ifi(bo_calculate_on_bottom, ys[i].i_bottom, ys[i].i_top) < y_pixel_pos) do begin
			var fl_dy2 : misura_real_type := DY_cm^[i];
//			while (i < i_objs) AND (ypos[i] = ypos[i + 1]) do begin
			while (i < i_objs) AND (ys[i].i_bottom = ys[i+1].i_bottom) do begin
				inc(i);fl_dy2 := max(fl_dy2, DY_cm^[i])
			end;
			result := result + fl_dy2;
			inc(i)
		end
	end
end;

function cl_section_print_objects.get_deltay_cm_for_object(i_obj : obj_index_type) : DELTAY_REAL_TYPE;
// restituisce il valore di scostamento verticale di un oggetto in funzione della variazione di altezza degli oggetti che si trovano sopra di lui
begin
//	result := get_deltay_cm_for_y_pos(y_top[i_obj])
	result := get_deltay_cm_for_y_pos(ys[i_obj].i_top)
end;

function cl_section_print_objects.get_deltay_cm_in_object(i_print_obj, i_obj : obj_index_type) : DELTAY_REAL_TYPE;
{ funzione che restituisce il valore di scostamento verticale verificatosi all'interno di
  un oggetto, a prescindere dall'eventuale scostamento precedente;
  serve per oggetti grafici che devono ridimensionarsi in funzione delle modifiche
  intercorse tra il loro top ed il loro bottom;
  I_PRINT_OBJ è l'indice interno a CL_SECTION_PRINT_OBJECTS;
  I_OBJ è l'indice esterno (vedi unit OBJECTS) }
begin
//	result := get_deltay_cm_for_y_pos(y_top[i_print_obj] + pages.xobjs(i_obj,i_logical_page).get_height{-1}) - get_deltay_cm_for_y_pos(y_top[i_print_obj])
	var x : objs_type := pages.xobjs(i_obj, i_logical_page_1B);
	if (x.tipo_oggetto in CORNICI_OBJS) AND x.asgraph.bo_dimensione_verticale_fissa then result := 0		// 2013-01-12 (prima c'era solo il caso sottostante)
//	else result := get_deltay_cm_for_y_pos(ys[i_print_obj].i_top + x.get_height{-1}) - get_deltay_cm_for_y_pos(ys[i_print_obj].i_top)
	else begin
(*{$ifNdef DEBUG} *** {$endif DEBUG}
var fl : double := 0;
fl := ys[i_print_obj].i_top;
fl := x.get_height{-1};
var flx := ys[i_print_obj].i_top + x.get_height{-1};
fl := get_deltay_cm_for_y_pos(flx);
fl := get_deltay_cm_for_y_pos(flx, TRUE);
fl := get_deltay_cm_for_y_pos(flx);
fl := get_deltay_cm_for_y_pos(flx, TRUE);
fl := get_deltay_cm_for_y_pos(flx);
fl := get_deltay_cm_for_y_pos(flx, TRUE);
fl := get_deltay_cm_for_y_pos(ys[i_print_obj].i_top); *)
		{$ifdef DEBUG} assert(x.tipo_oggetto in CORNICI_OBJS, 'obj ' + x.get_name + ' (' + i_obj.ToString + ') -- non è una cornice/linea -- cambiare BO_CALCULATE_ON_BOTTOM'); {$endif}
		var bo_calculate_on_bottom := TRUE;
		result := get_deltay_cm_for_y_pos(ys[i_print_obj].i_top + x.get_height{-1}, bo_calculate_on_bottom) - get_deltay_cm_for_y_pos(ys[i_print_obj].i_top, bo_calculate_on_bottom);
		{ se un oggetto (in sezione 1) ha il BOTTOM a metà della sezione 2 che ha pochi records quindi si è ristretta rispetto alle attese,
		  il valore può anche essere negativo ma è assurdo; quindi limito a ZERO come valore inferiore }
//		if (result < 0) then result := 0
	end
end;

procedure cl_section_print_objects.set_deltay_cm(i_obj : obj_index_type;r_deltay_cm_value : DELTAY_REAL_TYPE);
// acquisisce la variazione di altezza dell'oggetto I_OBJ; serve per calcolare la posizione corretta degli oggetti che si trovano sotto di lui
begin
	{$ifdef DEBUG}
//		if (objs[i_obj] > 0) then assert(i_section = pages.xobjs(objs[i_obj],i_logical_page).get_section,'i_section errata -- IXAQ 4432')
//		else assert(i_section = -objs[i_obj]-1,'i_section errata IXQ 433');
		if (ys[i_obj].i_obj > 0) then assert(i_section_1B = pages.xobjs(ys[i_obj].i_obj, i_logical_page_1B).ca.i_section_1B, 'i_section errata -- IXAQ 4432')
		else assert(i_section_1B = -ys[i_obj].i_obj-1, 'i_section errata IXQ 433');
		// l'oggetto è una sezione di livello X, quindi appartiene ad una sezione di livello X-1
		if (r_deltay_cm_value <> 0) then begin
			inc(i_obj);dec(i_obj)		// solo per avere un punto di debug
		end;
	{$endif}
	get_DY_cm(get_virtual_printing_page)^[i_obj] := r_deltay_cm_value
end;

function cl_section_print_objects.get_DY_cm(i_page_1B : ph_page_type) : DY_cm_punt;
{ restituisce il puntatore al vettore di R_DELTAY_CM per la pagina fisica specificata;
  verifica che tale vettore esista; se non esiste lo crea e lo inizializza;
  I_PAGE_1B è (stoltamente) 1-based, a differenza degli indici di R_DELTA_Y_CM }
begin
	if (i_page_1B > length(deltay_cm)) then begin
		setLength(deltay_cm, i_page_1B);
		setLength(deltay_cm[i_page_1B - 1], i_objs + 1)		// alloco per il numero di oggetti della pagina logica attiva (+1 perchè è tutto stoltamente 1-based)
//		for var i : ph_page_type := 1 to MAX_OBJS do deltay_cm[i_page-1, i] := 0
	end;
	result := @(deltay_cm[i_page_1B - 1])
end;

procedure delete_print_sections_from_to(pp : cl_print_page;lo_id_from, lo_id_to : integer);
{ cancella le print section da LO_ID_FROM (compresa) a LO_ID_TO (esclusa);
  passare LO_ID_TO = -1 per cancellare fino alla fine della lista }
const MBOX_DEBUG_CAPTION = 'delete_print_sections_from_to()';
begin
	var sv_temp : cl_print_section := pp.sections;if (sv_temp = NIL) then exit;
	while (sv_temp.next <> NIL) AND (sv_temp.next.lo_id <> lo_id_from) do sv_temp := sv_temp.next;
	if (sv_temp.next <> NIL) AND (sv_temp.next.lo_id <> lo_id_from) then begin		// not found (should not happen)
		{$ifdef DEBUG} assert(FALSE,'delete_print_section_records_from(): obj not found'); {$endif}
		exit
	end;
	while (sv_temp.next <> NIL) AND (sv_temp.next.lo_id <> lo_id_to) do begin
		var svx : cl_print_section := sv_temp.next;sv_temp.next := svx.next;
		runtime_debug('ELIMINATA SEZIONE DATI L/P=' + svx.i_logical_page_1B.ToString + ' SEZ=' + svx.i_section_1B.Tostring +
			' lo_id=' + zeri(svx.lo_id, 6) + ' SQL-PK:' + svx.str_PK_debug_key, MBOX_DEBUG_CAPTION, RD_DEBUG_DETTAGLIO_02);
		svx.free
	end
end;

procedure delete_print_section_record(var sv_head : cl_print_section;lo_id : integer
	{$ifdef DEBUG};i_section_1B : section_index_type{$endif});
// elimina la sezione con l'ID indicato; I_SECTION è per controllo; passare I_SECTION = 0 per saltare il check
const MBOX_DEBUG_CAPTION = 'delete_print_section_record()';
begin
	runtime_debug('START-OF -- lo_id=' + zeri(lo_id, 6), MBOX_DEBUG_CAPTION, RD_DEBUG_DETTAGLIO_02);
	if (sv_head.lo_id = lo_id) then delete_first_print_section_record(sv_head)
	else begin
		var sv_temp : cl_print_section := sv_head;
		while (sv_temp.next <> NIL) AND (sv_temp.next.lo_id <> lo_id) do sv_temp := sv_temp.next;
		var svx : cl_print_section := sv_temp.next;
		if (svx <> NIL) AND (svx.lo_id = lo_id) then begin	// section found, la elimino
			{$ifdef DEBUG} if (i_section_1B <> 0) then assert(i_section_1B = sv_temp.next.i_section_1B, 'EDJK 9328'); {$endif}
			runtime_debug('ELIMINATA SEZIONE DATI L/P=' + svx.i_logical_page_1B.ToString + ' SEZ=' + svx.i_section_1B.ToString +
				' lo_id=' + zeri(svx.lo_id, 6) + ' SQL-PK:' + svx.str_PK_debug_key, MBOX_DEBUG_CAPTION, RD_DEBUG_DETTAGLIO_02);
			sv_temp.next := svx.next;
			svx.free
		end
	end;
	runtime_debug('END-OF -- lo_id=' + zeri(lo_id, 6), MBOX_DEBUG_CAPTION, RD_DEBUG_DETTAGLIO_02)
end;

function copy_print_section_record(sv : cl_print_section;pp : cl_print_page;bo_continuazione : boolean) : cl_print_section;
// copia l'oggetto sezione sulla PRINT_PAGE; rende un puntatore all'oggetto su cui è stata eseguita la copia
var sv_temp : cl_print_section;	//*
begin
	if (pp.sections = NIL) then begin
		pp.sections := cl_print_section.create(sv.i_logical_page_1B, 0, bo_continuazione);
		sv_temp := pp.sections
	end
	else begin
		sv_temp := pp.sections;
		while (sv_temp.next <> NIL) do sv_temp := sv_temp.next;
		sv_temp.next := cl_print_section.create(sv.i_logical_page_1B, 0, bo_continuazione);
		sv_temp := sv_temp.next
	end;
	sv_temp.copy(sv, TRUE);
	result := sv_temp
end;

{procedure move_print_section_record(sv,sv_head : cl_print_section;print_page_destination : cl_print_page);
// sposta l'oggetto sezione SV dalla 'lista' di oggetti sezione SV_HEAD alla PRINT_PAGE_DESTINATION
begin
	copy_print_section_record(sv,print_page_destination);
	var sv_temp : cl_print_section := sv_head;
	while (sv_temp.next <> sv) do sv_temp := sv_temp.next;
	sv_temp.next := sv.next;sv.free
end; }

procedure delete_first_print_section_record(var sv_head : cl_print_section);
// cancella il primo oggetto sezione dalla lista SV_HEAD
const MBOX_DEBUG_CAPTION = 'delete_first_print_section_record()';
begin
	var svx : cl_print_section := sv_head;sv_head := sv_head.next;
	runtime_debug('ELIMINATA SEZIONE DATI L/P=' + svx.i_logical_page_1B.ToString + ' SEZ=' + svx.i_section_1B.ToString +
		' lo_id=' + zeri(svx.lo_id, 6) + ' SQL-PK:' + svx.str_PK_debug_key, MBOX_DEBUG_CAPTION, RD_DEBUG_DETTAGLIO_02);
	svx.free
end;

{$endif CASA}

initialization
	lo_id_print_sections := 1000000;		// per distinguere gli IDs dai numeri di pagina -- dal 2009-10 non è più necessario, ma lascio cmq l'inizializzazione
	{$ifdef DEBUG} lo_id_campo_progressivo := 30000; {$endif}
	galateo_initialization_debug('print_types')
finalization
	galateo_finalization_debug('print_types');
{$ifdef DEBUG}
	CCI(i_print_campo, {str_class_name} 'CL_PRINT_CAMPO', {source_file}'print_types');
	CCI(i_print_section, {str_class_name} 'CL_PRINT_SECTION', {source_file}'print_types');
	CCI(i_print_page, {str_class_name} 'CL_PRINT_PAGE', {source_file}'print_types');
	CCI(i_section_print_objects, {str_class_name} 'CL_SECTION_PRINT_OBJECTS', {source_file}'print_types')
{$endif}
end.
