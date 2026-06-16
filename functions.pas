unit functions;

{$I defines}

// file contenente la gestione delle funzioni (IF compresi)
// $INCLUSO by OBJECTS.PAS
// vedi FUNCTION.H

{ NOTA
  nella notazione, con FUNCTION o FUNZIONE si intende generalmente una singola
  funzione dalla funzionalità precisa e limitata (ad esempio: PAGE() oppure MAIUSCOLO());
  con FORMULA si intende invece l'insieme dei pezzi (e delle functions) che
  compaiono nel calcolo complessivo del risultato;
  la formula è composta dall'utente, le function sono predefinite in GALATEO

  SINTASSI DELLE FUNZIONI: le funzioni sono in stile C-like, ovvero devono sempre
	  e comunque avere almeno una coppia di parentesi, eventualmente vuote

  ALCUNE FUNZIONI il cui valore dipende da elementi contingenti (ad esempio: la function PAGE)
  vengono pre-elaborate e inserite in forma simbolica all'interno del risultato;
  in fase di stampa avviene una post-elaborazione e l'inserimento del valore reale
}

interface

uses Windows, Classes, SysUtils, Math,
	Fcommons, FXstrings, Gdich, objects;

const
	MAX_PARMS_FUNCTION = 3;						// numero max di parametri per una funzione
	TUTTI_PARAMETRI_NECESSARI = -1;			// parametro simbolico che indica che TUTTI I PARAMETRI SONO NECESSARI
type
	function_type = record
		str_name : string;						// nome della function
		i_parms : 0..MAX_PARMS_FUNCTION;		// numero di parametri
		tipo_valore : risultato_type;
		str_help : string;
		parm_type : array[1..MAX_PARMS_FUNCTION] of risultato_type;
		i_parms_necessari : -1..MAX_PARMS_FUNCTION			// numero di parametri necessari; -1 indica TUTTI, 0=nessuno, 1=1, 2=2, ...
	end;
const
	NUM_FUNCTIONS = 104;	// numero di funzioni riconosciuto dal sistema
	PAGINA_LOGICA_PROGRESSIVA_HELP = 'pagina_logica_progressiva()';	// dichiarato qui x' deve essere referenziato fuori
	FUNC : array[1..NUM_FUNCTIONS] of function_type = (
		// funzioni di sistema
		(str_name:'PAGINA';i_parms:0;tipo_valore:VAL_NUMERO;str_help:'pagina()';parm_type:(VAL_BOH,VAL_BOH,VAL_BOH)),
		(str_name:'TOT_PAGINE';i_parms:0;tipo_valore:VAL_NUMERO;str_help:'tot_pagine()';parm_type:(VAL_BOH,VAL_BOH,VAL_BOH)),
		(str_name:'PAGINA_SEZIONE';i_parms:0;tipo_valore:VAL_NUMERO;str_help:'pagina_sezione()';parm_type:(VAL_BOH,VAL_BOH,VAL_BOH)),
		(str_name:'TOT_PAGINE_SEZIONE';i_parms:0;tipo_valore:VAL_NUMERO;str_help:'tot_pagine_sezione()';parm_type:(VAL_BOH,VAL_BOH,VAL_BOH)),
		(str_name:'PAGINA_RECORD';i_parms:0;tipo_valore:VAL_NUMERO;str_help:'pagina_record()';parm_type:(VAL_BOH,VAL_BOH,VAL_BOH)),
		(str_name:'TOT_PAGINE_RECORD';i_parms:0;tipo_valore:VAL_NUMERO;str_help:'tot_pagine_record()';parm_type:(VAL_BOH,VAL_BOH,VAL_BOH)),

		(str_name:'NUMERO_ETICHETTA_SEZIONE';i_parms:0;tipo_valore:VAL_NUMERO;str_help:'numero_etichetta_sezione()';parm_type:(VAL_BOH,VAL_BOH,VAL_BOH)),	// numero progressivo di etichetta (nella pagina logica)
		(str_name:'NUMERO_ETICHETTA_PAGINA';i_parms:0;tipo_valore:VAL_NUMERO;str_help:'numero_etichetta_pagina()';parm_type:(VAL_BOH,VAL_BOH,VAL_BOH)),		// numero progressivo di etichetta nella pagina fisica
		(str_name:'TOT_ETICHETTE_SEZIONE';i_parms:0;tipo_valore:VAL_NUMERO;str_help:'tot_etichette_sezione()';parm_type:(VAL_BOH,VAL_BOH,VAL_BOH)),			// numero totale di etichette nella pagina logica
		(str_name:'NUMERO_ETICHETTE_PAGINA';i_parms:0;tipo_valore:VAL_NUMERO;str_help:'numero_etichette_pagina()';parm_type:(VAL_BOH,VAL_BOH,VAL_BOH)),		// numero di etichette contenute su una pagina fisica
		(str_name:'SALTA_PAGINE_VIRTUALI';i_parms:1;tipo_valore:VAL_TESTO;str_help:'salta_pagine_virtuali(numero pagine da saltare)';	// salta n pagine virtuali dopo la presente
			 parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'PROSSIMA_PAGINA_FISICA';i_parms:0;tipo_valore:VAL_TESTO;str_help:'prossima_pagina_fisica()';parm_type:(VAL_BOH,VAL_BOH,VAL_BOH)),		// salta alla next pagina fisica
		(str_name:'POS_ULTIMA_ETICHETTA_STAMPATA';i_parms:1;tipo_valore:VAL_NUMERO;str_help:'pos_ultima_etichetta_stampata(stampante)';
			parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:0),

		(str_name:'PAGINA_LOGICA_NUMERO';i_parms:0;tipo_valore:VAL_NUMERO;str_help:'pagina_logica_numero()';parm_type:(VAL_BOH,VAL_BOH,VAL_BOH)),
		(str_name:'PAGINA_LOGICA_DESCRIZIONE';i_parms:0;tipo_valore:VAL_TESTO;str_help:'pagina_logica_descrizione()';parm_type:(VAL_BOH,VAL_BOH,VAL_BOH)),
		(str_name:'PAGINA_LOGICA_DESCRIZIONE_BREVE';i_parms:0;tipo_valore:VAL_TESTO;str_help:'pagina_logica_descrizione_breve()';parm_type:(VAL_BOH,VAL_BOH,VAL_BOH)),
		(str_name:'PAGINA_PROGRESSIVA';i_parms:0;tipo_valore:VAL_NUMERO;str_help:PAGINA_LOGICA_PROGRESSIVA_HELP;parm_type:(VAL_BOH,VAL_BOH,VAL_BOH)),

		(str_name:'ORA';i_parms:0;tipo_valore:VAL_TESTO;str_help:'ora()';parm_type:(VAL_BOH,VAL_BOH,VAL_BOH)),
		(str_name:'DATA';i_parms:1;tipo_valore:VAL_TESTO;str_help:'data([formato=0])';parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:0),

		// funzioni informative
		(str_name:'ISNULL';i_parms:1;tipo_valore:VAL_TESTO;str_help:'ISNULL(object)';parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:1),

		(str_name:'CIN';i_parms:1;tipo_valore:VAL_NUMERO;str_help:'CODICE_CIN(numero) rende la cifra di controllo del numero specificato';parm_type:(VAL_NUMERO, VAL_BOH, VAL_BOH);i_parms_necessari:1),
		(str_name:'APPEND_CIN';i_parms:2;tipo_valore:VAL_TESTO;str_help:'CIN(numero [,delimitatore]) aggiunge il CIN sul fondo del numero, con eventuale delimitatore';parm_type:(VAL_NUMERO, VAL_TESTO, VAL_BOH);i_parms_necessari:1),
		(str_name:'CHECK_CIN';i_parms:2;tipo_valore:VAL_TESTO;str_help:'CHECK_CIN(numero [,delimitatore]) rende T se il CIN è corretto';parm_type:(VAL_TESTO, VAL_TESTO, VAL_BOH);i_parms_necessari:1),
		(str_name:'DECODE_FROM_CIN';i_parms:2;tipo_valore:VAL_NUMERO;str_help:'DECODE_FROM_CIN(numero [,delimitatore]) rende il numero originale dopo controllo del CIN';parm_type:(VAL_TESTO, VAL_TESTO, VAL_BOH);i_parms_necessari:1),

		// funzioni testo
		(str_name:'ACAPO';i_parms:1;tipo_valore:VAL_TESTO;str_help:'ACAPO([lines])';parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:0),
		(str_name:'LEN';i_parms:1;tipo_valore:VAL_NUMERO;str_help:'len(stringa)';parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'COPY';i_parms:3;tipo_valore:VAL_TESTO;str_help:'copy(stringa,i_start,[i_len])';
			parm_type:(VAL_TESTO,VAL_NUMERO, VAL_NUMERO);i_parms_necessari:2),
		(str_name:'SOSTITUISCI';i_parms:3;tipo_valore:VAL_TESTO;str_help:'sostituisci(stringa,vecchio,nuovo) case insensitive';
			parm_type:(VAL_TESTO,VAL_TESTO,VAL_TESTO);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'MAIUSCOLO';i_parms:1;tipo_valore:VAL_TESTO;str_help:'maiuscolo(stringa)';parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'MINUSCOLO';i_parms:1;tipo_valore:VAL_TESTO;str_help:'minuscolo(stringa)';parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'POS';i_parms:2;tipo_valore:VAL_NUMERO;str_help:'pos(sottostringa, stringa)';parm_type:(VAL_TESTO, VAL_TESTO, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'TOGLIBLANKS';i_parms:1;tipo_valore:VAL_TESTO;str_help:'togliblanks(stringa)';parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'QUOTEDSTR';i_parms:1;tipo_valore:VAL_TESTO;str_help:'quotedstr(stringa)';parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'STR2SQL';i_parms:1;tipo_valore:VAL_TESTO;str_help:'str2SQL(stringa)'; parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'DT2SQL';i_parms:3;tipo_valore:VAL_TESTO;str_help:'dt2SQL(data [,inapicia:boolean] [,delta days])' + ACAPO +
			'DELTA DAYS : aggiunge/toglie il numero di giorni specificato';
			parm_type:(VAL_TESTO, VAL_TESTO, VAL_NUMERO);i_parms_necessari:1),
		(str_name:'INAPICIA';i_parms:2;tipo_valore:VAL_TESTO;str_help:'inapicia(stringa,modalita)' + ACAPO2 + 'MODALITA vale:' + ACAPO + APIX_HINTS;
			parm_type:(VAL_TESTO, VAL_NUMERO, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'DISAPICIA';i_parms:1;tipo_valore:VAL_TESTO;str_help:'disapicia(stringa)'; parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'COALESCE';i_parms:3;tipo_valore:VAL_TESTO;str_help:'COALESCE(str1,str2[,str3])';parm_type:(VAL_TESTO, VAL_TESTO, VAL_TESTO);i_parms_necessari:2),
		(str_name:'CHAR';i_parms:1;tipo_valore:VAL_TESTO;str_help:'CHAR(ascii-code)';parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'STRINGOFCHAR';i_parms:2;tipo_valore:VAL_TESTO;str_help:'stringofchar("c",numero)';
			parm_type:(VAL_TESTO, VAL_NUMERO, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),

		// funzioni di traduzione
		(str_name:'PUNTATO';i_parms:1;tipo_valore:VAL_TESTO;str_help:'puntato(numero)';parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'ZERI';i_parms:2;tipo_valore:VAL_TESTO;str_help:'zeri(numero,#cifre)';parm_type:(VAL_NUMERO, VAL_NUMERO, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),

		// FUNZIONI DI CONVERSIONE
		// legge stringa, rende numero
		(str_name:'NUMERO';i_parms:1;tipo_valore:VAL_NUMERO;str_help:'numero(stringa)';parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		 // legge un numero, scrive un testo
		(str_name:'STRING';i_parms:1;tipo_valore:VAL_TESTO;str_help:'string(numero)';parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		// formatta il numero; formato come la funzione STR() del pascal
		(str_name:'FORMATTA_NUMERO';i_parms:3;tipo_valore:VAL_TESTO;str_help:'formatta_numero(stringa,campo,decimali)';
		 parm_type:(VAL_NUMERO, VAL_NUMERO,VAL_NUMERO);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		// lire --> EURO
		(str_name:'L2E';i_parms:1;tipo_valore:VAL_NUMERO;str_help:'L2E(importo)  da £ a euro';parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		// EURO --> lire
		(str_name:'E2L';i_parms:1;tipo_valore:VAL_NUMERO;str_help:'E2L(importo)  da euro a £';parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),

		// VALUTA >> VALUTA
		(str_name:'VALUTA';i_parms:3;tipo_valore:VAL_NUMERO;str_help:'valuta(importo,valuta_from,valuta_to)';
			parm_type:(VAL_NUMERO,VAL_TESTO,VAL_TESTO);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),

		// FORMATTAZIONE IN VALUTA
		(str_name:'FORMATTA_VALUTA';i_parms:2;tipo_valore:VAL_TESTO;str_help:'formatta_valuta(importo[,valuta=EURO])';
			parm_type:(VAL_NUMERO, VAL_TESTO, VAL_BOH);i_parms_necessari:1),
		(str_name:'FORMATTA_VALUTA_MAX';i_parms:2;tipo_valore:VAL_TESTO;str_help:'formatta_valuta_max(importo[,valuta=EURO])';
			parm_type:(VAL_NUMERO, VAL_TESTO, VAL_BOH);i_parms_necessari:1),
		(str_name:'FORMATTA_VALUTA_CALC';i_parms:2;tipo_valore:VAL_TESTO;str_help:'formatta_valuta_calc(importo[,valuta=EURO])';
			parm_type:(VAL_NUMERO, VAL_TESTO, VAL_BOH);i_parms_necessari:1),

		// codifica un numero in lettere (1 --> A, 2 --> B) secondo il formato desiderato
		(str_name:'CODIFICA_NUMERO';i_parms:2;tipo_valore:VAL_TESTO;str_help:'CODIFICA_NUMERO(num,codifica)';
			parm_type:(VAL_TESTO, VAL_TESTO, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),

		// XML FUNCTION ( conversione dei caratteri speciali XML: &lt; (<), &amp; (&), &gt; (>), &quot; ("), and &apos; (')
		(str_name:'TEXT2XML';i_parms:1;tipo_valore:VAL_TESTO;str_help:'TEXT2XML(s)';
			parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'XML2TEXT';i_parms:1;tipo_valore:VAL_TESTO;str_help:'XML2TEXT(s)';
			parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),

		 // funzioni linguistiche
		(str_name:'DATA_IN_LETTERE';i_parms:1;tipo_valore:VAL_TESTO;str_help:'data_in_lettere(data)';
			parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'MESE';i_parms:1;tipo_valore:VAL_TESTO;str_help:'mese(numero)';parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'BISESTILE';i_parms:1;tipo_valore:VAL_TESTO;str_help:'bisestile(anno)';parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'NUM2STR';i_parms:1;tipo_valore:VAL_TESTO;str_help:'num2str(numero) (in lettere)';
			parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'NUM2STRD';i_parms:2;tipo_valore:VAL_TESTO;str_help:'num2strd(numero,decimali)';parm_type:(VAL_NUMERO, VAL_NUMERO, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),

		// codice fiscale >> data di nascita
		(str_name:'CF_TO_DATANASCITA';i_parms:2;tipo_valore:VAL_TESTO;str_help:'CF_to_datanascita(codice_fiscale,0/1 = anno 2/4 cifre)';
			parm_type:(VAL_TESTO, VAL_NUMERO, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'CODICE_FISCALE';i_parms:1;tipo_valore:VAL_TESTO;str_help:'codice_fiscale(codice)';
			parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'PARTITA_IVA';i_parms:1;tipo_valore:VAL_TESTO;str_help:'partita_IVA(codice)';
			parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'IBAN';i_parms:1;tipo_valore:VAL_TESTO;str_help:'IBAN(codice)';
			parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),

		 // funzioni matematiche
		(str_name:'MIN_2_HOURS';i_parms:2;tipo_valore:VAL_TESTO;str_help:'min_2_hours(minuti[,spazio:boolean])';	// BO_SPAZIO: 2022-09-08, ver
			parm_type:(VAL_NUMERO, VAL_TESTO, VAL_BOH);i_parms_necessari:1),
		(str_name:'MIN_2_DAYS';i_parms:2;tipo_valore:VAL_NUMERO;str_help:'min_2_days(minuti,ore_per_giorno)';
			parm_type:(VAL_NUMERO, VAL_NUMERO, VAL_BOH);i_parms_necessari:2),
		(str_name:'SECONDI_2_STRING';i_parms:1;tipo_valore:VAL_TESTO;str_help:'secondi_2_string(secondi)';
			parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),

		(str_name:'MOD';i_parms:2;tipo_valore:VAL_NUMERO;str_help:'mod(numero,divisore)';parm_type:(VAL_NUMERO, VAL_NUMERO, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'ROUND';i_parms:2;tipo_valore:VAL_NUMERO;str_help:'round(numero,decimali)';parm_type:(VAL_NUMERO, VAL_NUMERO, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'AND';i_parms:2;tipo_valore:VAL_NUMERO;str_help:'AND(numero,numero)';parm_type:(VAL_NUMERO, VAL_NUMERO, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'OR';i_parms:2;tipo_valore:VAL_NUMERO;str_help:'OR(numero,numero)';parm_type:(VAL_NUMERO, VAL_NUMERO, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'XOR';i_parms:2;tipo_valore:VAL_NUMERO;str_help:'XOR(numero,numero)';parm_type:(VAL_NUMERO, VAL_NUMERO, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'ABS';i_parms:1;tipo_valore:VAL_NUMERO;str_help:'ABS(numero)';parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),

		// funzioni numeriche
		{ PARI/DISPARI: se non viene passato nessun parametro, indica la condizioni di dis/parità del numero di record
		  NON viene garantita la dis/parità del primo record, ma solo l'alternanza tra record successivi
		  viene gestito attraverso l'attributo ID della struttura print_types.CL_PRINT_SECTION, che viene incrementato per ogni record di ogni sezione }
		(str_name:'DISPARI';i_parms:1;tipo_valore:VAL_TESTO;str_help:'DISPARI(numero) -- se numero non è indicato indica il numero di riga';parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:0),
		(str_name:'PARI';i_parms:1;tipo_valore:VAL_TESTO;str_help:'PARI(numero) -- se numero non è indicato indica il numero di riga';parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:0),

		(str_name:'PRIMO';i_parms:1;tipo_valore:VAL_NUMERO;str_help:'PRIMO(numero) -- rende l''i-esimo numero primo';parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'IS_PRIMO';i_parms:1;tipo_valore:VAL_TESTO;str_help:'IS_PRIMO(numero) -- rende T se il numero è primo';parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'PRIMO_POS';i_parms:1;tipo_valore:VAL_NUMERO;
			str_help:'PRIMO_POS(numero) -- rende la posizione di I_NUMERO nella sequenza di numeri primi, oppure 0 se non è primo';
			parm_type:(VAL_NUMERO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),

		(str_name:'FIBONACCI';i_parms:1;tipo_valore:VAL_NUMERO;str_help:'FIBONACCI(numero) -- rende l''i-esimo numero della sequenza di Fibonacci';
			parm_type:(VAL_NUMERO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'IS_FIBONACCI';i_parms:1;tipo_valore:VAL_TESTO;str_help:'IS_FIBONACCI(numero) -- rende T se il numero appartiene alla sequenza di Fibonacci';
			parm_type:(VAL_NUMERO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'FIBONACCI_POS';i_parms:1;tipo_valore:VAL_NUMERO;
			str_help:'FIBONACCI_POS(numero) -- rende la posizione del numero nella sequenza di Fibonacci, oppure -1 se non appartiene';
			parm_type:(VAL_NUMERO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),

		 // funzioni di relazione con l'utente
		(str_name:'MESSAGEBOX';i_parms:3;tipo_valore:VAL_TESTO;str_help:'messagebox(testo,tipo_icona,parametro obsoleto)';
		 parm_type:(VAL_TESTO, VAL_NUMERO, VAL_NUMERO);i_parms_necessari:2),			// il valore è VAL_TESTO, ma in realtà non è utilizzato; per cui non vale la pena di restituire davvero un integer come la vera MessageBox(); scritto 2009-07-30
		(str_name:'ABORT';i_parms:1;tipo_valore:VAL_TESTO;str_help:'abort(causa errore)';parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),

		// barcodes functions
		(str_name:'EAN13';i_parms:1;tipo_valore:VAL_TESTO;str_help:'EAN13(codice)';parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'EAN128_A';i_parms:1;tipo_valore:VAL_TESTO;str_help:'EAN128_A(codice)';parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'EAN128_B';i_parms:1;tipo_valore:VAL_TESTO;str_help:'EAN128_B(codice)';parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'EAN128_C';i_parms:1;tipo_valore:VAL_TESTO;str_help:'EAN128_C(codice)';parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'EAN128_AUTO';i_parms:1;tipo_valore:VAL_TESTO;str_help:'EAN128_AUTO(codice)';parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'CODE39';i_parms:1;tipo_valore:VAL_TESTO;str_help:'CODE39(codice)';parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'INTERLEAV2OF5_MOD10';i_parms:1;tipo_valore:VAL_TESTO;str_help:'INTERLEAV2OF5_MOD10(codice)';
			parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),

		// file functions
		(str_name:'FILEEXISTS';i_parms:1;tipo_valore:VAL_TESTO;str_help:'FileExists(nomefile)';
			parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'FINDFULLFILENAME';i_parms:2;tipo_valore:VAL_TESTO;str_help:'FindFullFilename(nomefile,path)';
			parm_type:(VAL_TESTO, VAL_TESTO, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'READ_TEXT_FILE';i_parms:2;tipo_valore:VAL_TESTO;str_help:'read_text_file(nomefile[,modalita=0])';
			parm_type:(VAL_TESTO, VAL_NUMERO, VAL_BOH);i_parms_necessari:1),
		(str_name:'REPORT_FILENAME';i_parms:1;tipo_valore:VAL_TESTO;str_help:'report_filename(0=senza path, 1=con path, nn=ultimi nn caratteri, default 0)';
			parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:0),
		(str_name:'REPORT_DATETIME';i_parms:1;tipo_valore:VAL_TESTO;str_help:'report_datetime(0=data, 1=data e ora, default 0)';
			parm_type:(VAL_NUMERO, VAL_BOH,VAL_BOH);i_parms_necessari:0),

		// forza la valutazione di una formula fornita come stringa di testo
		(str_name:'VALUTA_FORMULA';i_parms:1;tipo_valore:VAL_TESTO;str_help:'valuta_formula(funzione)';
			parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
//		(str_name:'NUMBER';i_parms:1;tipo_valore:VAL_NUMERO;str_help:'number(0=sezione, -1=sezione padre, -2 ...)';parm_type:(VAL_NUMERO, VAL_TESTO, VAL_BOH))

		(str_name:'GET_VAR';i_parms:1;tipo_valore:VAL_TESTO;str_help:'get_var(nome_variabile)';
			parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'GET_TEXTVAR';i_parms:1;tipo_valore:VAL_TESTO;str_help:'get_textvar(nome_variabile)';
			parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'GET_NUMVAR';i_parms:1;tipo_valore:VAL_NUMERO;str_help:'get_numvar(nome_variabile)';
			parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'EXISTS_VAR';i_parms:1;tipo_valore:VAL_TESTO;str_help:'exists_var(nome_variabile)';
			parm_type:(VAL_TESTO, VAL_BOH, VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),

		(str_name:'SECTION_GROUP_FIRST';i_parms:0;tipo_valore:VAL_TESTO;str_help:'section_group_first()';
			parm_type:(VAL_BOH,VAL_BOH,VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'SECTION_GROUP_MIDDLE';i_parms:0;tipo_valore:VAL_TESTO;str_help:'section_group_middle()';
			parm_type:(VAL_BOH,VAL_BOH,VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),
		(str_name:'SECTION_GROUP_LAST';i_parms:0;tipo_valore:VAL_TESTO;str_help:'section_group_last()';
			parm_type:(VAL_BOH,VAL_BOH,VAL_BOH);i_parms_necessari:TUTTI_PARAMETRI_NECESSARI),

		// funzioni SQL
		(str_name:'LIST';i_parms:3;tipo_valore:VAL_TESTO;str_help:'list(query SQL,[delimitatore=,],[bo_distinct=FALSE])';
			parm_type:(VAL_TESTO,VAL_TESTO,VAL_TESTO);i_parms_necessari:1),

		// funzioni di debug
		(str_name:'SERIAL_SECTION';i_parms:0;tipo_valore:VAL_NUMERO;str_help:'serial_section()';parm_type:(VAL_BOH,VAL_BOH,VAL_BOH))
	  );

function translate_formula(str_formula : string;var str_result : string;bo_test : boolean;var tipo : risultato_type;ox : objs_type) : boolean;
function interpreta_boolean_expression(str_boolean : string;bo_test : boolean;var bo_result : boolean;var str_msg : string) : boolean;
{$ifdef GALATEO_EXE} function check_condizione_booleana(handle : hwnd;str_condizione, str_descrizione : string;pt_message : string_punt = NIL) : boolean; {$endif}

var
	i_NDXF_POS_ULTIMA_ETICHETTA_STAMPATA_EXTERNAL : smallint;

implementation

uses FAssert, FStrings, proc, valuta, Fdata, Ftime, barcodes, sp_galateo, num2str, FSQLsoft, FMessage, FProcs, FFile, logical_proc,
	galateo_debug, printers_DX, Gun, pages, sezione, misure, {$ifdef CASA} GAPP, print_types, {$endif} labels;

function translate_IF(var str_formula : string;var str_result : string;bo_test : boolean;var tipo : risultato_type) : byte; forward;

var
	dt : cl_data;
	tim : cl_time;
	xndx_last_formula_calculated : byte;
	i_formula_level : smallint;

const
	IF_FUNCTION = 'IF';
	NDXF_PAGE					= 01;
	NDXF_PAGES_TOTALE			= NDXF_PAGE+1;
	NDXF_PAGE_SEZIONE			= NDXF_PAGES_TOTALE+1;
	NDXF_PAGES_TOTALE_SEZIONE= NDXF_PAGE_SEZIONE+1;
	NDXF_PAGE_RECORD			= NDXF_PAGES_TOTALE_SEZIONE+1;
	NDXF_PAGES_TOTALE_RECORD= NDXF_PAGE_RECORD+1;

	NDXF_NUMERO_ETICHETTA_SEZIONE	= NDXF_PAGES_TOTALE_RECORD + 1;		// numero progressivo di etichetta (nella pagina logica)
	NDXF_NUMERO_ETICHETTA_PAGINA = NDXF_NUMERO_ETICHETTA_SEZIONE + 1;	// numero progressivo di etichetta nella pagina fisica
	NDXF_TOT_ETICHETTE_SEZIONE = NDXF_NUMERO_ETICHETTA_PAGINA + 1;		// numero totale di etichette nella pagina logica
	NDXF_NUMERO_ETICHETTE_PAGINA = NDXF_TOT_ETICHETTE_SEZIONE + 1;		// numero di etichette contenute su una pagina fisica
	NDXF_SALTA_PAGINE_VIRTUALI = NDXF_NUMERO_ETICHETTE_PAGINA + 1;
	NDXF_PROSSIMA_PAGINA_FISICA = NDXF_SALTA_PAGINE_VIRTUALI + 1;
	NDXF_POS_ULTIMA_ETICHETTA_STAMPATA = NDXF_PROSSIMA_PAGINA_FISICA + 1;

	NDXF_PAGINA_LOGICA_NUMERO = NDXF_POS_ULTIMA_ETICHETTA_STAMPATA + 1;
	NDXF_PAGINA_LOGICA_DESCR_ESTESA = NDXF_PAGINA_LOGICA_NUMERO + 1;
	NDXF_PAGINA_LOGICA_DESCR_BREVE = NDXF_PAGINA_LOGICA_DESCR_ESTESA + 1;
	NDXF_PAGINA_PROGRESSIVA = NDXF_PAGINA_LOGICA_DESCR_BREVE + 1;

	NDXF_TIME					= NDXF_PAGINA_PROGRESSIVA + 1;
	NDXF_DATE					= NDXF_TIME + 1;
	NDXF_ISNULL					= NDXF_DATE + 1;

	NDXF_CODICE_CIN			= NDXF_ISNULL + 1;
	NDXF_CIN						= NDXF_CODICE_CIN + 1;
	NDXF_CHECK_CIN				= NDXF_CIN + 1;
	NDXF_DECODE_FROM_CIN		= NDXF_CHECK_CIN + 1;

	NDXF_ACAPO					= NDXF_DECODE_FROM_CIN + 1;
	NDXF_LEN						= NDXF_ACAPO + 1;
	NDXF_COPY_STRING			= NDXF_LEN + 1;
	NDXF_SOSTITUISCI			= NDXF_COPY_STRING + 1;
	NDXF_MAIUSCOLO				= NDXF_SOSTITUISCI + 1;
	NDXF_MINUSCOLO				= NDXF_MAIUSCOLO + 1;
	NDXF_POS						= NDXF_MINUSCOLO + 1;
	NDXF_TOGLIBLANKS			= NDXF_POS +1;
	NDXF_QUOTEDSTR				= NDXF_TOGLIBLANKS + 1;
	NDXF_STR2SQL				= NDXF_QUOTEDSTR + 1;
	NDXF_DT2SQL             = NDXF_STR2SQL + 1;
	NDXF_INAPICIA				= NDXF_DT2SQL + 1;
	NDXF_DISAPICIA				= NDXF_INAPICIA + 1;
	NDXF_COALESCE				= NDXF_DISAPICIA + 1;
	NDXF_CHAR					= NDXF_COALESCE + 1;
	NDXF_STRINGOFCHAR			= NDXF_CHAR + 1;
	NDXF_PUNTATO				= NDXF_STRINGOFCHAR + 1;
	NDXF_ZERI					= NDXF_PUNTATO + 1;
	NDXF_NUMERO					= NDXF_ZERI + 1;
	NDXF_STRING					= NDXF_NUMERO + 1;
	NDXF_FORMATTA_NUMERO		= NDXF_STRING + 1;
	NDXF_LIRE_2_EURO			= NDXF_FORMATTA_NUMERO + 1;
	NDXF_EURO_2_LIRE			= NDXF_LIRE_2_EURO + 1;

	NDX_VALUTA					= NDXF_EURO_2_LIRE + 1;
	NDX_FORMATTA_VALUTA		= NDX_VALUTA + 1;
	NDX_FORMATTA_VALUTA_MAX	= NDX_FORMATTA_VALUTA + 1;
	NDX_FORMATTA_VALUTA_CALC= NDX_FORMATTA_VALUTA_MAX + 1;

	NDXF_CODIFICA_NUMERO 	= NDX_FORMATTA_VALUTA_CALC + 1;
	NDXF_TEXT2XML				= NDXF_CODIFICA_NUMERO + 1;
	NDXF_XML2TEXT				= NDXF_TEXT2XML + 1;
	NDXF_DATA_IN_LETTERE 	= NDXF_XML2TEXT + 1;
	NDXF_MESE					= NDXF_DATA_IN_LETTERE + 1;
	NDXF_BISESTILE				= NDXF_MESE + 1;
	NDXF_NUM2STR				= NDXF_BISESTILE + 1;
	NDXF_NUM2STRD				= NDXF_NUM2STR + 1;

	NDXF_CF_TO_DATANASCITA	= NDXF_NUM2STRD + 1;
	NDXF_CODICEFISCALE		= NDXF_CF_TO_DATANASCITA + 1;
	NDXF_PARTITAIVA			= NDXF_CODICEFISCALE + 1;
	NDXF_IBAN					= NDXF_PARTITAIVA + 1;

	NDXF_MIN2HOURS				= NDXF_IBAN + 1;
	NDXF_MIN2DAYS				= NDXF_MIN2HOURS + 1;
	NDXF_SEC2STR				= NDXF_MIN2DAYS + 1;
	NDXF_MOD						= NDXF_SEC2STR + 1;
	NDXF_ROUND					= NDXF_MOD + 1;
	NDXF_AND						= NDXF_ROUND + 1;
	NDXF_OR						= NDXF_AND + 1;
	NDXF_XOR						= NDXF_OR + 1;
	NDXF_ABS						= NDXF_XOR + 1;

	NDXF_DISPARI				= NDXF_ABS + 1;
	NDXF_PARI					= NDXF_DISPARI + 1;

	NDXF_PRIMO					= NDXF_PARI + 1;					// rende l''i-esimo numero primo
	NDXF_IS_PRIMO				= NDXF_PRIMO + 1;					// rende T se il numero è primo
	NDXF_PRIMO_POSIZIONE		= NDXF_IS_PRIMO + 1;				// rende la posizione di I_NUMERO nella sequenza di numeri primi, oppure 0 se non è primo

	NDXF_FIBONACCI				= NDXF_PRIMO_POSIZIONE + 1;	// rende l''i-esimo numero della sequenza di Fibonacci
	NDXF_IS_FIBONACCI			= NDXF_FIBONACCI + 1;			// rende T se il numero appartiene alla sequenza di Fibonacci
	NDXF_FIBONACCI_POSIZIONE= NDXF_IS_FIBONACCI + 1;		// rende la posizione del numero nella sequenza di Fibonacci, oppure 0 se non appartiene

	NDXF_MESSAGEBOX			= NDXF_FIBONACCI_POSIZIONE + 1;
	NDXF_ABORT					= NDXF_MESSAGEBOX + 1;
	NDXF_EAN13					= NDXF_ABORT + 1;
	NDXF_EAN128_A				= NDXF_EAN13 + 1;
	NDXF_EAN128_B				= NDXF_EAN128_A + 1;
	NDXF_EAN128_C				= NDXF_EAN128_B + 1;
	NDXF_EAN128_AUTO			= NDXF_EAN128_C + 1;
	NDXF_CODE39					= NDXF_EAN128_AUTO + 1;
	NDXF_INTERLEAV2OF5_MOD10= NDXF_CODE39 + 1;
	NDXF_FILE_EXISTS			= NDXF_INTERLEAV2OF5_MOD10 + 1;
	NDXF_FIND_FULL_FILENAME	= NDXF_FILE_EXISTS + 1;
	NDXF_READ_TEXT_FILE		= NDXF_FIND_FULL_FILENAME + 1;
	NDXF_REPORT_FILENAME		= NDXF_READ_TEXT_FILE + 1;
	NDXF_REPORT_DATETIME		= NDXF_REPORT_FILENAME + 1;
	NDXF_VALUTA_FORMULA		= NDXF_REPORT_DATETIME + 1;
	NDXF_GET_VAR				= NDXF_VALUTA_FORMULA + 1;
	NDXF_GET_TEXTVAR			= NDXF_GET_VAR + 1;
	NDXF_GET_NUMVAR			= NDXF_GET_TEXTVAR + 1;
	NDXF_EXISTS_VAR			= NDXF_GET_NUMVAR + 1;
	NDX_SECTION_GROUP_FIRST = NDXF_EXISTS_VAR + 1;
	NDX_SECTION_GROUP_MIDDLE = NDX_SECTION_GROUP_FIRST + 1;
	NDX_SECTION_GROUP_LAST = NDX_SECTION_GROUP_MIDDLE + 1;
	NDXF_LIST_SQL				= NDX_SECTION_GROUP_LAST + 1;
	NDXF_SERIAL_SECTION		= NDXF_LIST_SQL + 1;
	// -------------------------------------------------
	NDXF_LAST					= NDXF_SERIAL_SECTION;

	// Read Text Filename ERRor: modalità
	RTF_ERR_ABORT = 0;		// interrompe esecuzione
	RTF_ERR_MESSAGE = 1;		// emette segnalazione e prosegue
	RTF_ERR_ASK_USER = 2;	// domanda all'utente se proseguire
	RTF_ERR_IGNORA = 3;		// non fa nulla

	DATA_DDMMYY = 0;
	DATA_DDMMYYYY = 1;
	DATA_YYYY_MM_DD = 2;
	DATA_YYYYMMDD = 3;
	DATA_YYMMDD = 4;
	DATA_MMDDYY = 5;
	DATA_MMDDYYYY = 6;

function num2str(fl : double;i_decimali_fissi : smallint;var s : string) : boolean;
// traduce il numero FL in una stringa; utilizza I_DECIMALI_FISSI;
// rende TRUE in caso di successo, FALSE altrimenti; se rende FALSE carica una stringa di errore su S
begin
	try
		if (i_decimali_fissi = 0) then numero_2_stringa(system.round(fl), s)	// round() rende un int64
		else begin
			numero_2_stringa(system.trunc(fl), s);	// round() rende un int64
			var xr : real := frac(abs(fl));
			xr := xr * power(10, i_decimali_fissi);
			s := s + '/' + zeri(system.round(xr), i_decimali_fissi)	// stampo in due cifre decimali (i centesimi)
		end;
		result := TRUE
	except
		s := 'errore di conversione';
		result := FALSE
	end
end;

function galateo_read_text_file(str_filename : string;i_modalita : smallint;var s : string) : boolean;
// legge il file STR_FILENAME con la modalità I_MDOALITA; rende TRUE se tutto ok, FALSE se bisogna eseguire un ABORT
begin
	s := '';
	if (str_filename = '') then begin result := TRUE;exit end;

	result := FALSE;

	var it := TstringList.create;
	try
		it.LoadFromFile(str_filename);
		s := it.Text;
		result := TRUE
	except
//		result := FALSE
	end;
	it.free

(*
	{$I-}
	assign(f, str_filename);
//	reset(f);
	open_text_readonly(f);
	i := IOresult;
	if (i <> 0) then begin
		case i_modalita of
			RTF_ERR_ABORT, RTF_ERR_MESSAGE : begin
				MessageBBox(globale.Handle, 'Errore durante la lettura di ' + str_filename, MBOX_CAPTION, MB_ICONSTOP);
				result := (i_modalita = RTF_ERR_MESSAGE)
			end;
			RTF_ERR_ASK_USER : result := (MessageBBox(globale.Handle,
				'Errore durante la lettura di ' + str_filename + ACAPO2 + 'Vuoi proseguire l''elaborazione?',
				MBOX_CAPTION, MB_QUESTION) = IDYES);
			RTF_ERR_IGNORA : result := TRUE;
			else begin
				MessageBBox(globale.Handle, 'Parametro modalità errato', MBOX_CAPTION, MB_ICONSTOP);
				result := FALSE
			end
		end;
		exit		// in ogni caso, interrompo la lettura
	end;

	while NOT eof(f) do begin
		readln(f, str_line);
		s := s + ifs(s <> '', ACAPO) + str_line
	end;
	close(f);if (IOresult = 0) then;
	result := TRUE;
	{$I+} *)
end;

function translate_function(var str_formula : string;var str_result : string;bo_test : boolean;var tipo_valore : risultato_type;ox : objs_type) : integer;
{ verifica se STR_FORMULA inizia con una funzione ed eventualmente traduce tale
  funzione cancellando da STR_FORMULA la sottostringa tradotta;
  in TIPO_VALORE in ingresso viene messo il tipo che l'IF deve restituire; se l'IF
  restituisce un valore diverso la funzione genera un errore; se il valore può
  essere qualunque passare VAL_BOH; in uscita viene caricato il tipo effettivamente
  restituito dall'IF (se in ingresso si era lasciato libero, altrimenti è fissato ancora quello);

  rende IDYES in caso di successo, IDNO in caso di errore nell'elaborazione della formula,
  IDCANCEL se non è stato fatto nulla perchè nulla era da farsi }
label retry;
var
	s, str_temp : string;
	str_parms : array[1..MAX_PARMS_FUNCTION+1] of string;	// +1 per range-checking reasons
	i, j, i_function, i_parms : integer;
	ii : system.smallint;
	vx : array[1..MAX_PARMS_FUNCTION] of variant;
	xr : real;
	dbl : double;
	valuta_from, valuta_to : cl_valuta;
	dtx : TDatetime;
	tipo : risultato_type;
	fs : FASI_STAMPA_TYPE;
	xobj : objs_type;
begin
	{$ifNdef CASA} {$ifdef DEBUG} assert(bo_test, 'translate_function(TEST = FALSE) -- functions.pas'); {$endif} {$endif}
retry:
	result := translate_if(str_formula, str_result, bo_test, tipo_valore);
	if (result <> IDCANCEL) then exit;

	result := IDNO;	// default d'ora innanzi
	// verifico se trattasi di funzione
	i := pos('(', str_formula);
	if (i = 0) then begin result := IDCANCEL;exit end;	// nulla da fare, nessuna funzione da tradurre
	// prendo il nome dell'eventuale funzione
	s := uppercase(copy(str_formula, 1, i-1));

	// macro parametrica?
	if globale.translate_macro_parametrica(str_formula, str_temp, ox, bo_test) then begin
		str_formula := str_result + str_temp;str_result := '';
		togli_blanks_non_necessari(str_formula);
//		result := IDYES;exit
		goto retry
	end;

	// verifico se si tratta di una stored procedure
//	i := exec_stored_proc(sections(1).qry.DatabaseName, str_formula, s, bo_test, TRUE);
	i := exec_stored_proc(sections_ZB(0).qry.DatabaseName, str_formula, s, bo_test, TRUE);
	case i of
		0 : ;	// non è stored proc
		-1 : begin str_result := s;exit end;	// stored procedure con errore; l'errore viene caricato su STR_RESULT
		else begin // stored proc OK
			str_result := str_result + s;
			tipo_valore := internal_tipo_res(get_stored_proc(i).tipo_res);
			result := IDYES;exit
		end
	end;      

	i_function := NUM_FUNCTIONS;
	while (i_function > 0) AND (s <> FUNC[i_function].str_name) do dec(i_function);
	if (i_function = 0) then begin result := IDCANCEL;exit end;		// nulla da fare, nulla è stato fatto

	delete(str_formula, 1, length(s) + 1);
	i_parms := 0;
	while get_parm(str_formula, str_parms[i_parms+1]) do begin
		if (str_formula = '') then begin str_result := 'Parentesi non chiusa nella formula <' + FUNC[i_function].str_name + '>';exit end;	// 2009-04-14
		inc(i_parms)
	end;

{	if (i_parms <> FUNC[i_function].i_parms) then begin
		str_result := 'Funzione <' + FUNC[i_function].str_name + '>: numero di parametri scorretto';
		exit
	end; }
	if ((FUNC[i_function].i_parms_necessari = TUTTI_PARAMETRI_NECESSARI) AND (i_parms <> FUNC[i_function].i_parms)) OR
		(i_parms > FUNC[i_function].i_parms) OR			// troppi parametri
		(i_parms < FUNC[i_function].i_parms_necessari)	// non abbastanza parametri
	then begin
		str_result := 'Funzione <' + FUNC[i_function].str_name + '>: numero di parametri scorretto';
		exit
	end;	

	if (tipo_valore <> VAL_BOH) AND (tipo_valore <> FUNC[i_function].tipo_valore) then begin
		MessageBBox(0,'Funzione <' + FUNC[i_function].str_name + '>: il risultato non è del tipo necessario al contesto',MBOX_CAPTION);
		exit
	end;
	// eseguo la eventuale trasformazione dei parametri
	for i := 1 to i_parms do begin
		tipo := FUNC[i_function].parm_type[i];
		if NOT translate_formula(str_parms[i], str_parms[i], bo_test, tipo, ox) then begin
//		if NOT translate_formula(str_parms[i],str_parms[i],bo_test, FUNC[i_function].parm_type[i], ox) then begin	*** così fino 2011-05-23, ma mi sembra impossibile che potesse funzionare
			MessageBBox(0, str_parms[i], s, MB_ICONSTOP);
			exit
		end;
		vx[i] := str_parms[i]
	end;

	tipo_valore := FUNC[i_function].tipo_valore;
	case i_function of
		NDXF_PAGE : s := get_phisical_printing_page.ToString;
		NDXF_PAGES_TOTALE: s := get_last_phisical_printed_page.ToString;
		NDXF_PAGE_SEZIONE : s := {$ifdef CASA} inttostr(get_phisical_printing_page - get_first_pagina_fisica_of_pagina_logica + 1) {$else} '1' {$endif};
		NDXF_PAGES_TOTALE_SEZIONE : s := {$ifdef CASA} inttostr(get_numero_virtual_pages_of_pagina_logica) {$else} '1' {$endif};

		NDXF_PAGE_RECORD : begin
{$ifdef CASA}
			i := get_virtual_printing_page - get_first_pagina_fisica_of_pagina_logica + 1;
			i := i - get_first_vpage_of_current_main_record(i) + 1;
			s := inttostr(i)
{$else}
			s := '1'
{$endif}
		end;
		NDXF_PAGES_TOTALE_RECORD : begin
{$ifdef CASA}
			i := get_virtual_printing_page - get_first_pagina_fisica_of_pagina_logica + 1;
			s := inttostr(get_last_vpage_of_current_main_record(i) - get_first_vpage_of_current_main_record(i) + 1)
{$else}
			s := '1'
{$endif}
		end;

		NDXF_NUMERO_ETICHETTA_SEZIONE : s := {$ifdef CASA} inttostr(get_virtual_printing_page) {$else} '1' {$endif};	// numero progressivo di etichetta (nella pagina logica)
		NDXF_NUMERO_ETICHETTA_PAGINA : begin	// numero progressivo di etichetta nella pagina fisica
			if tm.i_lab_per_row * tm.i_lab_per_page = 0 then s := '0'
//			else s := inttostr(get_virtual_printing_page mod (tm.i_lab_per_row * tm.i_lab_per_page))
			else s := {$ifdef CASA} inttostr((get_virtual_printing_page-1) mod (tm.i_lab_per_row * tm.i_lab_per_page) + 1) {$else} '0' {$endif}
		end;
		NDXF_TOT_ETICHETTE_SEZIONE : s := {$ifdef CASA} get_last_virtual_printed_page.Tostring {$else} '1' {$endif};	// numero totale di etichette nella pagina logica
		NDXF_NUMERO_ETICHETTE_PAGINA : s := inttostr(tm.i_lab_per_row * tm.i_lab_per_page);		// numero di etichette contenute su una pagina fisica

		NDXF_SALTA_PAGINE_VIRTUALI : begin
			s := '';
			if (globale.tiporeport = TR_LABEL_REPORT) then begin
				if NOT bo_test then i_skip_virtual_pages := vx[1]
			end
{$ifdef GALATEO_EXE}
				else MessageBBox(0,FUNC[i_function].str_name +
					': funzione utilizzabile solo in reports di tipo ' + TIPOREPORT_DESCRIZIONE[globale.tiporeport],MBOX_CAPTION,MB_ICONSTOP)
{$endif}
		end;
		NDXF_PROSSIMA_PAGINA_FISICA : begin
			s := '';
			if (globale.tiporeport = TR_LABEL_REPORT) then begin
				if NOT bo_test then bo_goto_next_phisical_page := TRUE
			end
{$ifdef GALATEO_EXE}
				else MessageBBox(0,FUNC[i_function].str_name +
					': funzione utilizzabile solo in reports di tipo ' + TIPOREPORT_DESCRIZIONE[globale.tiporeport],MBOX_CAPTION,MB_ICONSTOP)
{$endif}
		end;
		NDXF_POS_ULTIMA_ETICHETTA_STAMPATA : begin
			if (globale.tiporeport in LABEL_TYPES) AND label_read_ultima_posizione_stampa(printer.printers[printer.printerindex], globale.str_formato_label, ii) then s := inttostr(ii)
			else s := '0'
		end;
		NDXF_PAGINA_LOGICA_NUMERO : s := inttostr(get_pagina_logica_attiva_1B);
		NDXF_PAGINA_LOGICA_DESCR_ESTESA : s := get_logical_page_1B(get_pagina_logica_attiva_1B).get_descrizione(FALSE);
		NDXF_PAGINA_LOGICA_DESCR_BREVE : s := get_logical_page_1B(get_pagina_logica_attiva_1B).get_descrizione(TRUE);
		NDXF_PAGINA_PROGRESSIVA : begin
			if bo_test then s := '27'	// così, un numero bello
			{$ifdef CASA} else s := inttostr(get_numero_progressivo_pagina_1B(get_pagina_logica_attiva_1B)) {$endif}
		end;
		NDXF_TIME : begin
			tim := cl_time.create;tim.decode_datetime(get_job_datetime);
			s := tim.AsString(0);
			tim.free
		end;
		NDXF_DATE : begin
			i := vx[1];
			case i of
//				DATA_DDMMYY : s := asstring_short(get_job_datetime,'/');
				DATA_DDMMYYYY : s := asstring_data(get_job_datetime,'/');  
				DATA_YYYY_MM_DD : s := dt2SQL(get_job_datetime, {inapicia}FALSE, {SQL_server}FALSE);
				DATA_YYYYMMDD : s := dt2SQL(get_job_datetime, {inapicia}FALSE, {SQL_server}TRUE);
				DATA_YYMMDD : begin s := asstring_short(get_job_datetime,'/');s := copy(s, 7, 2) + copy(s, 3, 4) + copy(s, 1, 2) end;
				DATA_MMDDYY : begin s := asstring_short(get_job_datetime,'/');s := copy(s, 4, 3) + copy(s, 1, 3) + copy(s, 7, 2) end;
				DATA_MMDDYYYY : begin s := asstring_data(get_job_datetime,'/');s := copy(s, 4, 3) + copy(s, 1, 3) + copy(s, 7, 4) end;
				else s := asstring_short(get_job_datetime,'/')
			end
		end;
		NDXF_ISNULL : begin
			s := str_parms[1];
//			if (s = '') then **********;

			xobj := name2obj(s, {all_pages}TRUE);
			if (xobj = NIL) then begin
				str_result := 'Oggetto <' + s + '> non riconosciuto';
				if bo_test then begin result := IDNO;exit end else raise exception.create(str_result)
			end;
			if (xobj.tipo_oggetto <> LABEL_OBJ) then begin
				str_result := 'L''oggetto <' + s + '> deve essere una variabile';
				if bo_test then begin result := IDNO;exit end else raise exception.create(str_result)
			end;
			s := bool2SQL(xobj.aslabel.bo_null)
		end;

		NDXF_CODICE_CIN : s := codice_CIN(str_parms[1].ToInt64).ToString;
		NDXF_CIN : s := CIN(str_parms[1].ToInt64, str_parms[2]);
		NDXF_CHECK_CIN : s := bool2SQL(check_CIN(str_parms[1], str_parms[2]));
		NDXF_DECODE_FROM_CIN : s := decode_from_CIN_string(str_parms[1], str_parms[2]).ToString;

		NDXF_ACAPO : begin
			i := max(1, vx[1]);s := '';
			for j := 1 to i do s := s + ACAPO
		end;
		NDXF_LEN : s := inttostr(length(str_parms[1]));
		NDXF_COPY_STRING : begin
			i := vx[2];
			if (vx[3] = 0) then j := MAXINT else j := vx[3];
			s := copy(str_parms[1],i,j)
		end;
		NDXF_SOSTITUISCI : begin
			s := str_parms[1];
			sostituisci(s,str_parms[2],str_parms[3],{ignore_case :=} TRUE)
		end;
		NDXF_MAIUSCOLO : s := uppercase(str_parms[1]);
		NDXF_MINUSCOLO : s := lowercase(str_parms[1]);
		NDXF_POS : begin
			i := pos(str_parms[1], str_parms[2]);
			s := inttostr(i)
		end;	
		NDXF_TOGLIBLANKS : s := togliblanks(str_parms[1]);
		NDXF_PUNTATO : s := puntato(vx[1]);
		NDXF_ZERI : s := zeri(vx[1], vx[2]);
		NDXF_QUOTEDSTR, NDXF_STR2SQL : begin s := vx[1];s := str2SQL(s) end;
		NDXF_DT2SQL : begin
			s := vx[2];
			var bo_inapicia := (s = '') OR (s = SQL_TRUE);
			s := vx[3];
			var fl_delta_days : double := 0;
			if (s <> '') AND is_numeric(s, TRUE) then fl_delta_days := strToFloat(s);
			s := togliblanks(vx[1]);
			if (s = '') then s := 'NULL'
			else begin
				dtx := str2dt(s) + fl_delta_days;
				if (dtx = 0) then s := ''
				else s := dt2SQL(dtx, bo_inapicia)
			end
		end;
		NDXF_INAPICIA : begin
			s := vx[1];i := vx[2];
			if (i < 0) OR (i > byte(high(APIX_type))) then i := byte(APIX_DEFAULT);
			s := inapicia(s, APIX_type(i))
		end;
		NDXF_DISAPICIA : begin s := vx[1];s := disapicia(s) end;
		NDXF_COALESCE :
			if (vx[1] <> '') then s := vx[1] else
			if (vx[2] <> '') then s := vx[2] else
			if (vx[3] <> '') then s := vx[3] else
			s := '';
		NDXF_CHAR : begin i := vx[1];s := chr(i) end;
		NDXF_STRINGOFCHAR : begin
			s := '';str_temp := vx[1];j := vx[2];
			for i := 1 to j do s := s + str_temp
		end;
		NDXF_NUMERO : begin
			try
				s := strid(vx[1], 0, 0)
			except
				if bo_test then begin
					result := IDNO;
					str_result := 'Il valore <' + str_parms[1] + '> passato alla funzione '+ FUNC[NDXF_NUMERO].str_name + ' non è un numero';
					exit
				end
				else raise
			end
		end;
		NDXF_STRING : s := vx[1];
		{$WARN IMPLICIT_STRING_CAST OFF}
		NDXF_FORMATTA_NUMERO : begin
			drval(vx[1], dbl, @i);i := vx[2];j := vx[3];
			system.str(dbl:i:j, s)
		end;
		{$WARN IMPLICIT_STRING_CAST ON}

		NDXF_CF_TO_DATANASCITA : begin
			try
				s := codicefiscale_to_datascita(vx[1], vx[2] = 0)
			except
				s := ''
			end
		end;
		NDXF_CODICEFISCALE : s := ifs(codice_fiscale(vx[1]), SQL_TRUE, SQL_FALSE);
		NDXF_PARTITAIVA : s := ifs(partita_iva_plausibile(vx[1]), SQL_TRUE, SQL_FALSE);
		NDXF_IBAN : s := ifs(galateo_check_IBAN(vx[1], @str_temp), SQL_TRUE, SQL_FALSE);	// ignoro il messaggio di errore, questa funzione rende solo un BOOLEAN

		NDXF_MIN2HOURS, NDXF_MIN2DAYS : begin // trasforma minuti in ore
			if NOT RRVal(str_parms[1], xr) then begin str_result := 'Qtà temporale errata o out of bounds (' + str_parms[1] + ')'; exit end;
			case i_function of
				NDXF_MIN2HOURS: begin		// formato TESTO
					var bo_spazio := (str_parms[2] <> SQL_FALSE);
					s := minuti2ore(round(xr), bo_spazio)
				end;
				NDXF_MIN2DAYS : begin
					dbl := vx[2];
					if (dbl = 0) then s := '0' else s := strid(xr / 60 / dbl,0,0)	// formato numerico
				end
			end
		end;
		NDXF_LIRE_2_EURO: begin	// arrotondo a due decimali
			DRVal(vx[1],dbl);
			dbl := dbl / LIRE_PER_EURO;
			s := strid(my_round(dbl, DECIMALI_CALCOLO_EURO, RND_NEAREST), 0, 0)
		end;
		NDXF_EURO_2_LIRE: begin	// arrotondo all'unità
			DRVal(vx[1],dbl);
			dbl := dbl * LIRE_PER_EURO;
			s := strid(my_round(dbl, DECIMALI_CALCOLO_LIRE, RND_NEAREST), 0, 0)
		end;
		NDX_VALUTA : begin
			DRVal(vx[1],dbl);
			if NOT load_tbl_valute(globale.get_databasename) then begin
				str_result := 'Impossibile caricare la tabella valute';
				if bo_test then begin result := IDNO;exit end
				else raise exception.create(str_result)
			end;
			valuta_from := get_ptr_valuta(vx[2]);
			valuta_to := get_ptr_valuta(vx[3]);
			if (valuta_from = NIL) OR (valuta_to = NIL) then begin
				str_result := 'Valuta non riconosciuta';
				if bo_test then begin result := IDNO;exit end
				else raise exception.create(str_result)
			end;
			s := valuta_to.spuntato(valuta_from.translate_to(dbl,valuta_to,MAX_ROUNDING))
		end;

		NDX_FORMATTA_VALUTA, NDX_FORMATTA_VALUTA_MAX, NDX_FORMATTA_VALUTA_CALC : begin
			DRVal(vx[1],dbl);
			if NOT load_tbl_valute(globale.get_databasename) then begin
				str_result := 'Impossibile caricare la tabella valute';
				if bo_test then begin result := IDNO;exit end
				else raise exception.create(str_result)
			end;
			s := vx[2];
			if (s = '') then valuta_to := valuta_euro else valuta_to := get_ptr_valuta(s);
			if (valuta_to = NIL) then begin
				str_result := 'Valuta non riconosciuta';
				if bo_test then begin result := IDNO;exit end
				else raise exception.create(str_result)
			end;
			case i_function of
				NDX_FORMATTA_VALUTA : i := FIX_ROUNDING;
				NDX_FORMATTA_VALUTA_MAX : i := MAX_ROUNDING;
				NDX_FORMATTA_VALUTA_CALC : i := EXTENDED_ROUNDING
			end;
			s := valuta_to.puntato(dbl, i)
		end;

		NDXF_CODIFICA_NUMERO : begin
			str_temp := vx[2];
			if (length(str_temp) <> 10) then begin
				str_result := 'La stringa di codifica DEVE essere di 10 caratteri';
				if bo_test then begin result := IDNO;exit end
				else raise exception.create(str_result)
			end;
			s := vx[1];
			for i := 1 to 10 do sostituisci(s, (i mod 10).ToString, str_temp[i])
		end;
		NDXF_TEXT2XML : begin str_temp := vx[1];s := text2XML_special_chars(str_temp, TRUE, XMLUC_LATIN_SUPPLEMENT) end;	// XMLUC_LATIN_SUPPLEMENT è una ipotesi, eventualmente da verificare
		NDXF_XML2TEXT : begin str_temp := vx[1];s := XML2text_special_chars(str_temp) end;
		NDXF_DATA_IN_LETTERE : begin
			s := '';	// a scanso di equivoci
			try
				dt := cl_data.create;
				try
					dt.str2dt(vx[1]);
					s := dt.in_lettere 
				except
				end
			finally
				dt.free
			end
		end;
		NDXF_MESE: begin
			j := vx[1];
			if (j in [1..12]) then s := months_estesi[j] else s := '********'
		end;
		NDXF_BISESTILE : s := bool2SQL(isleapyear(vx[1]));
		NDXF_NUM2STR: begin
			DRVal(vx[1],dbl);
			if NOT num2str(dbl,0,s) then raise exception.create(s)
{			xr := frac(abs(dbl));
			if (xr < 1e-6) OR (1 - xr < 1e-6) then
				numero_2_stringa(system.round(dbl),str)	// round() rende un int64
			else begin
				numero_2_stringa(system.trunc(dbl),str);	// round() rende un int64
				xr := xr * power(10,2);
				s := str + '/' + zeri(system.round(xr),2)	// stampo in due cifre decimali (i centesimi)
			end }
		end;
		NDXF_NUM2STRD: begin
			DRVal(vx[1],dbl);
			j := vx[2];
			if NOT num2str(dbl,j,s) then raise exception.create(s)
		end;
		NDXF_SEC2STR : begin	DRVal(vx[1],dbl);s := formatta_secondi(dbl) end; 	
		NDXF_MOD : begin
			i := vx[1];j := vx[2];
			if (j = 0) then s := '0' else s := (i mod j).ToString
		end;
		NDXF_ROUND: begin	// arrotonda il numero
			DRVal(vx[1],dbl);i := vx[2];
			dbl := my_round(dbl, -i, RND_NEAREST);
			s := strid(dbl, 0, 0)
		end;
		NDXF_AND : begin i := vx[1];j := vx[2];s := (i AND j).ToString end;
		NDXF_OR : begin i := vx[1];j := vx[2];s := (i OR j).ToString end;
		NDXF_XOR : begin i := vx[1];j := vx[2];s := (i XOR j).ToString end;
		NDXF_ABS : begin dbl := vx[1];s := floattostr(abs(dbl)) end;

		NDXF_DISPARI, NDXF_PARI : begin
			if (vx[1] = '') then i := {$ifdef CASA} sections_ZB(i_printing_section_ZB).printing_values.lo_id {$else} 1 {$endif} else i := vx[1];
			s := (odd(i) = (i_function = NDXF_DISPARI)).SQL
		end;

		NDXF_PRIMO : begin i := vx[1];s := numero_primo(i).ToString end;
		NDXF_IS_PRIMO : begin i := vx[1];s := is_numero_primo(i).SQL end;
		NDXF_PRIMO_POSIZIONE : begin i := vx[1];s := numero_primo_posizione(i).ToString end;

		NDXF_FIBONACCI : begin i := vx[1];s := numero_primo(i).ToString end;
		NDXF_IS_FIBONACCI : begin i := vx[1];s := (fibonacci_posizione_sequenza(i) <> -1).SQL end;
		NDXF_FIBONACCI_POSIZIONE : begin i := vx[1];s := fibonacci_posizione_sequenza(i).ToString end;

		NDXF_MESSAGEBOX: begin
			// per evitare di dare più volte lo stesso messaggio
			if NOT bo_test AND (xndx_last_formula_calculated <> NDXF_MESSAGEBOX) AND (xprint_status[get_active_job] = xPS_PREPARING) then begin
				s := str_parms[1];i := vx[2];
				if (i = 0) then i := ifi(vx[3] = 0, MB_ICONINFORMATION, MB_ICONSTOP);
				MessageBBox(0, s, globale.str_filename, i);
				if (vx[3] <> 0) then raise exception.create(s)
			end;
			s := ''	// la funzione non rende comunque niente (è più una procedure che una function)
		end;
		NDXF_ABORT: begin
			if NOT bo_test then raise exception.create(str_parms[1]);
			s := ''	// la funzione non rende comunque niente (è più una procedure che una function)
		end;
		NDXF_EAN13 : s := EAN13(strToInt64(str_parms[1]));
		NDXF_EAN128_A : s := barcode_EAN128_A(str_parms[1]);
		NDXF_EAN128_B : s := barcode_EAN128_B(str_parms[1]);
		NDXF_EAN128_C : s := barcode_EAN128_C(str_parms[1]);
		NDXF_EAN128_AUTO : s := barcode_EAN128_AUTO(str_parms[1]);
		NDXF_CODE39 : s := code39(str_parms[1]);
		NDXF_INTERLEAV2OF5_MOD10 : s := interleave2of5_mod10(str_parms[1]);
		NDXF_FILE_EXISTS : s := bool2SQL(FileExists(str_parms[1]));
		NDXF_FIND_FULL_FILENAME : begin
			s := str_parms[1];
			if NOT find_full_filename(str_parms[2], s, '') then s := ''
		end;
		NDXF_READ_TEXT_FILE : begin
			if NOT bo_test AND NOT galateo_read_text_file(str_parms[1], vx[2], s) then abort
		end;
		NDXF_REPORT_FILENAME : begin
//			s := globale.str_filename;
			s := ChangeFileExt(globale.str_filename, '');
			case vx[1] of
				0 : s := ExtractFilename(s);
				1 : ;	// ok, tutto il nome compreso il PATH
				else s := reduce_filename(s, vx[1])
			end
		end;
		NDXF_REPORT_DATETIME : begin
{			dtx := FileDateToDateTime(FileAge(globale.str_filename));
			if (dtx = 0) then s := ''
			else begin
				if (vx[1] = 1) then s := asstring_datetime(dtx,TRUE)
				else s := asstring_short(dtx,'/')
			end }
			if FileAge(globale.str_filename, dtx) then begin
				if (vx[1] = 1) then s := asstring_datetime(dtx, TRUE) else s := asstring_short(dtx, '/')
			end
			else s := ''
		end;
		NDXF_VALUTA_FORMULA : begin
			tipo := VAL_BOH;
			if NOT translate_formula(str_parms[1], s, bo_test, tipo, ox)
				then MessageBBox(0, 'Formula errata' + ACAPO2 + str_parms[1], globale.str_filename, MB_ICONSTOP)
		end;
		NDXF_GET_VAR, NDXF_GET_TEXTVAR, NDXF_GET_NUMVAR : begin
//			fs := FASE_STAMPA_ASSEGNAZIONE_STORED_VALUES[FORMULA];
			fs := FASE_STAMPA_ASSEGNAZIONE_STORED_VALUES[TV_FORMULA];
//			s := globale.get_stored_value(str_parms[1],NOT bo_test);
			s := globale.get_stored_value(str_parms[1], NOT bo_test AND (globale.fase_stampa <> fs));
			if ((bo_test OR (globale.fase_stampa = fs)) AND
				((tipo_valore = VAL_NUMERO) OR (i_function = NDXF_GET_NUMVAR)) AND (s = ''))
					then s := '1'
		end;
		NDXF_EXISTS_VAR : begin
			if bo_test then s := '1'	// siamo ottimisti
//			else s := ifs(globale.esiste_stored_value(str_parms[1]),'1','0')  		COSI' dal 2005-08 al 2006-01
			else s := bool2SQL(globale.esiste_stored_value(str_parms[1]))			// COSI' dal 2006-01
		end;
		NDX_SECTION_GROUP_FIRST : begin
			if bo_test {$ifdef CASA} OR (i_printing_section_ZB = -1){$endif} then s := 'X'
			{$ifdef CASA} else s := bool2SQL(sections_ZB(i_printing_section_ZB).printing_values.bo_changed_group_field_value) {$endif}
		end;
		NDX_SECTION_GROUP_MIDDLE : begin
			if bo_test {$ifdef CASA} OR (i_printing_section_ZB = -1) {$endif} then s := 'X'
{$ifdef CASA}
			else begin
				// TRUE se non sono sul primo elemento e non sono sull'ultimo elemento
				if sections_ZB(i_printing_section_ZB).printing_values.bo_changed_group_field_value then s := SQL_FALSE	// sono sul primo elemento del gruppo
				else begin
					if (sections_ZB(i_printing_section_ZB).printing_values.next = NIL) then s := SQL_FALSE	// sono certmente sull'ultimo elemento
					else s := bool2SQL(NOT sections_ZB(i_printing_section_ZB).printing_values.next.bo_changed_group_field_value)
				end
			end
{$endif}
		end;
		NDX_SECTION_GROUP_LAST : begin
			if bo_test {$ifdef CASA} OR (i_printing_section_ZB = -1) {$endif} then s := 'X'
{$ifdef CASA}
			else begin
				if (sections_ZB(i_printing_section_ZB).printing_values.next = NIL) then s := SQL_TRUE
				else s := bool2SQL(sections_ZB(i_printing_section_ZB).printing_values.next.bo_changed_group_field_value)
			end
{$endif}
		end;
		NDXF_LIST_SQL : s := get_list_where(globale.get_databasename, str_parms[1], coalesce(str_parms[2], ','), (uppercase(str_parms[3]) = SQL_TRUE));
//		NDXF_SERIAL_SECTION : s := lo_serial_number_impagina.ToString;
		NDXF_SERIAL_SECTION : begin
			if bo_test then s := '1'
			{$ifdef CASA} else s := sections_ZB(i_printing_section_ZB).printing_values.lo_id.ToString {$endif}	// così dal 2008-07-11
		end;	

{		NDXF_RECORD_NUMBER: begin	// record number(0=sezione, -1=sezione padre, -2 ...)
			i := vx[1];
			if (i > 0) OR (i < -get_num_sections) then s := '-1'
			else begin
				if bo_test then s := '77'
				else try
					i := i_printing_section + i;
					sec := sections(i);
					s := inttostr(xx_lo_record_number)
//					s := inttostr(sec.xlo_record_number)
				except
					s := '-1'
				end
			end
//			s := '???????'
		end; }
		{$ifdef DEBUG} else assert(FALSE,'funzione non riconosciuta') {$endif}
	end;
	if NOT bo_test then xndx_last_formula_calculated := i_function;	// per monitorare le formule che non devono essere calcolate + volte (es. messagebox())

	str_result := str_result + s;
	result := IDYES
end;

function get_pos_first_operatore(str_formula : string;sa : array of char) : smallint;
// rende la pos del primo operatore di testo, oppure 0 in caso di errore
begin
	result := high(smallint);
	for var i : smallint := 0 to length(sa)-1 do begin
		var j : smallint := get_char_in_formula(sa[i],str_formula);
		if (j <> 0) AND (j < result) then result := j
	end;
	if (result = high(smallint)) then result := 0
end;

function get_tipo_formula(str_formula : string) : risultato_type;
{ rende il tipo del risultato della formula;
  rende VAL_BOH in caso di mancata comprensione del tipo;
  non effettua nessun controllo sulla correttezza della formula, ma afferma che,
  se la formula è corretta, è del tipo restituito }
label retry;
var
	i, j : integer;
	r : real;
	tipo : risultato_type;
	str_result : string;
begin
	togli_blanks_non_necessari(str_formula);
	str_formula := elimina_parentesi_esterne(str_formula);		// 2007-03-28
	result := VAL_TESTO;
	if (get_char_in_formula(VIRGOLETTA, str_formula) <> 0) then exit;

	// vado a caccia della prima eventuale variabile della formula e verifico di quale tipo è
//	j := get_pos_first_operatore(str_formula,OPERATORI_FORMULA_TESTO_ARRAY);
{	for i := 1 to NUM_OPERATORI_FORMULA_TESTO do begin
		j := get_char_in_formula(OPERATORI_FORMULA_TESTO_ARRAY[i],str_formula);
		if (j <> 0) then break
	end; }
//	if (j = 0) then j := get_pos_first_operatore(str_formula,OPERATORI_FORMULA_NUMERO_ARRAY);
	{	if (j = 0) then for i := 1 to NUM_OPERATORI_FORMULA_NUMERO do begin
		j := get_char_in_formula(OPERATORI_FORMULA_NUMERO_ARRAY[i],str_formula);
		if (j <> 0) then break
	end; }

retry:
	i := get_pos_first_operatore(str_formula, OPERATORI_FORMULA_TESTO_ARRAY);
	j := get_pos_first_operatore(str_formula, OPERATORI_FORMULA_NUMERO_ARRAY);
	if (j = 1) then begin delete(str_formula, 1, 1);goto retry end;	// se c'è un operatore in prima posizione (esempio: segno negativo)
	if (i <> 0) AND (j <> 0) then j := min(i, j) else j := max(i,j);

	if (j <> 0) then begin
		// provo a vedere il tipo del primo pezzo di formula -- 2006-02-14
		tipo := get_tipo_formula(copy(str_formula, 1, j-1));
		if (tipo <> VAL_BOH) then begin result := tipo;exit end
	end;

	if (j = 0) then j := length(str_formula) + 1;	// nessun operatore: verifico se la formula non è una unica variabile
//	xobj := name2obj(copy(str_formula,1,j-1),[xFORMULA,xVARIABILE],TRUE);	** fino a 2011-05-09
//	xobj := name2obj(copy(str_formula,1,j-1), OBJS_FORMULE_VARIABILI, TRUE);
	var xobj : objs_type := name2obj(copy(str_formula,1,j-1), TV_OLD_VARIABILI + [TV_FORMULA], TRUE);
//	if (xobj <> NIL) then begin result := xobj.aslabel.tipo_valore;exit end;
	if (xobj <> NIL) then begin result := xobj.ca.tipo_valore;exit end;

	RRval(copy(str_formula, 1, j-1), r, @i);
	if (i <> 0) then RRval(str_formula, r, @i);	// altrimenti proviamo ad interpretare il tutto nel suo complesso
	if (i = 0) then begin result := VAL_NUMERO;exit end;

	tipo := VAL_BOH;	// lascio aperto il tipo di risultato dell'eventuale IF

	if (translate_function(str_formula, str_result, TRUE, tipo, NIL) = IDYES) then begin result := tipo;exit end;

(*	if translate_formula(str_formula,str_result,{test}TRUE,tipo,NIL) then begin	// aggiunto 2005-08-15, poi tolto per problemi di utilità bassa e ricorsione troppo facile
		result := tipo;exit
	end; *)

	{$ifdef DEBUG} assert(FALSE, 'tipo di formula non capito' + ACAPO2 + str_formula); {$endif}
	result := VAL_BOH
end;

function translate_IF(var str_formula : string;var str_result : string;bo_test : boolean;var tipo : risultato_type) : byte;
{ elabora un IF; rende IDYES in caso di successo, IDNO in caso di errore nella
  formula, IDCANCEL se non è stato fatto nulla perchè nulla era da farsi;
  toglie da STR_FORMULA la parte di formula elaborata;
  appende a LP_RESULT il risultato, ovvero un messaggio di errore;
  in TIPO_VALORE in ingresso viene messo il tipo che l'IF deve restituire; se l'IF
  restituisce un valore diverso la funzione genera un errore; se il valore può
  essere qualunque passare VAL_BOH; in uscita viene caricato il tipo effettivamente
  resituito dall'IF (se in ingresso si era lasciato libero, altrimenti è fissato);
  se la formula non è un IF, rende IDCANCEL e non fa nulla }

label fine;
const
	IF_SINTAX = 'sintassi IF:' + ACAPO2 + 'IF( espressione ; VALORE se vero ; VALORE se falso )';
var
	i, i2, i3 : smallint;
	str_boolean, str_true, str_false : string;
	s, s1, s2, str_original_formula : string;
	bo, bo_value : boolean;
	bo_dont_modify_message : boolean;
		{ TRUE se il messaggio di errore non deve essere ulteriormente modificato; serve
		  per i casi in cui si riceve il messaggio di errore già completo da una chiamata ricorsiva
		  e non lo si vuole modificare }
	tipo1, tipo2, tipo_imposto : risultato_type;	// TIPO_IMPOSTO: tipo che l'IF deve restituire
begin	// translate_if
	tipo_imposto := tipo;
	bo_dont_modify_message := FALSE;
	if (uppercase(copy(str_formula,1,length(IF_FUNCTION) + 1)) <> IF_FUNCTION + '(') then begin
		translate_if := IDCANCEL;goto fine
	end;
	str_original_formula := str_formula;
	translate_IF := IDNO;	// non lasciamoci abbattere dallo sconforto, ma un poco di sano scetticismo non è poi un tragedia!
//	i := get_char_in_formula(')',copy(str_formula,4+1,MAXINT));
	i := get_char_in_formula(')',copy(str_formula,length(IF_FUNCTION)+1+1,MAXINT));
	if (i = 0) then begin str_result := 'IF: parentesi non chiusa';goto fine end;
//	s := copy(str_formula,4,i);
	s := copy(str_formula,length(IF_FUNCTION)+1+1,i-1);
//	delete(str_formula,1,i + length(IF_FUNCTION) + 2);	// cancello l'IF dalla formula
	delete(str_formula,1,i + length(IF_FUNCTION) + 1);	// cancello l'IF dalla formula
	i2 := get_char_in_formula(';',s);i3 := 0;
	if (i2 <> 0) then i3 := get_char_in_formula(';',copy(s,i2+1,MAXINT));
	if (i2 = 0) OR (i3 = 0) then begin
		str_result := 'IF: manca un punto e virgola';goto fine
	end;

	str_boolean := copy(s,1,i2-1);
	str_true := copy(s,i2+1,i3-1);
	str_false := copy(s,i2+i3+1,MAXINT);

(*	// determino se il predicato è TRUE o FALSE
	str := str_boolean;i_op := 1;j := 0;
	while (i_op <= NUM_OPERATORI_COMPARAZIONE) do begin
		j := get_char_in_formula(OPERATORI_COMPARAZIONE[i_op],str);
		if (j <> 0) then break;
		inc(i_op)
	end;
	if (i_op > NUM_OPERATORI_COMPARAZIONE) then begin
		str_result := 'IF: manca l''operatore di confronto nella espressione logica';goto fine
	end;
	s1 := copy(str,1,j-1);
	s2 := copy(str,j+length(OPERATORI_COMPARAZIONE[i_op]),MAXINT);
	tipo1 := VAL_BOH;tipo2 := VAL_BOH;
	if NOT translate_formula(s1,s1,bo_test,tipo1,0) then begin
		str_result := 'IF: errore nel primo termine dell''espressione logica:' + ACAPO2 + s1;
		goto fine
	end;
	if NOT translate_formula(s2,s2,bo_test,tipo2,0) then begin
		str_result := 'IF: errore nel secondo termine dell''espressione logica:' + ACAPO2 + s2;
		goto fine
	end;

	if (VAL_BOH in [tipo1,tipo2]) then begin
		str_result := 'IF: non riesco a capire il tipo dell''espressione logica';
		goto fine
	end;
	if (tipo1 <> tipo2) then begin
		str_result := 'IF: i due argomenti dell''espressione logica sono fra loro incompatibili';
		goto fine
	end;
	try
		bo_value := valuta(s1,s2,OPERATORI_COMPARAZIONE[i_op],tipo1);	// valuto nel modo opportuno il predicato
		bo := TRUE
	except
		str_result := 'IF: errore durante la valutazione dell''espressione logica';
		bo_value := FALSE;bo := FALSE
	end;
	if (NOT bo) then goto fine; *)
	if NOT interpreta_boolean_expression(str_boolean, bo_test, bo_value, str_result) then goto fine;

	// if bo_test then verifico sia il caso TRUE che quello FALSE, altrimenti interpreto solo il risultato che mi interessa
//	tipo1 := VAL_BOH;tipo2 := VAL_BOH;	// istruzione di vitale importanza
	tipo1 := tipo;tipo2 := tipo;	// dal 2005-08-15; perchè comunque, se TIPO è noto, TIPO1 e TIPO2 *devono* essere identici a TIPO
	if bo_test then begin
		if NOT translate_formula(str_false, s1, bo_test, tipo1, NIL) then begin str_result := s1;goto fine end;
		if NOT translate_formula(str_true, s2, bo_test, tipo2, NIL) then begin str_result := s2;goto fine end;
		if (tipo_imposto <> VAL_BOH) AND ((tipo1 <> tipo_imposto) OR (tipo2 <> tipo_imposto)) then begin
			str_result := 'IF: il risultato della formula è incompatibile con il tipo della formula';goto fine
		end;
		if (tipo1 <> tipo2) then begin
			str_result := 'IF: i valori da restituire in funzione del valore del predicato devono essere dello stesso tipo';
			goto fine
		end;
		str_result := str_result + s1;tipo := tipo1
	end
	else begin
		if bo_value then begin bo := translate_formula(str_true, s1, bo_test, tipo1, NIL);tipo := tipo1 end
		else begin bo := translate_formula(str_false, s1, bo_test, tipo2, NIL);tipo := tipo2 end;
		str_result := str_result + s1;
		bo_dont_modify_message := NOT bo;	// se c'è errore, la segnalazione e' già completa
		if NOT bo then goto fine
	end;

	translate_IF := IDYES;	// interpretazione andata a buon fine
fine:
	if (result = IDNO) AND (NOT bo_dont_modify_message OR (str_result = '')) then
		str_result := str_original_formula + ACAPO2 + str_result + ACAPO2 + IF_SINTAX
end;

function translate_formula_TESTO(str_formula : string;var str_result : string;bo_test : boolean;ox : objs_type) : boolean;
label after_read;
var s : string;	//*
begin
	result := FALSE;
	var bo_last_operator := TRUE;

	try
		sostituisci(str_formula, VIRGOLETTA_IN_TEXT, VIRGOLETTA_IN_TEXT_INTERNAL_USE);
		repeat
//			if (str_formula[1] in OPERATORI_FORMULA_TESTO_SET) then begin
			if CharInSet(str_formula[1], OPERATORI_FORMULA_TESTO_SET) then begin
				if bo_last_operator then begin str_result := 'Operatore non previsto' + ACAPO2 + str_formula;exit end;
				bo_last_operator := TRUE;delete(str_formula,1,1);
				goto after_read
			end;
			if NOT bo_last_operator then begin str_result := 'Errore nella formula: operatore mancante prima di' + ACAPO2 + str_formula;exit end;

			var tipo : risultato_type := VAL_BOH;	// lascio aperto il tipo di risultato dell'eventuale IF
			case translate_function(str_formula, str_result, bo_test, tipo, ox) of
				IDCANCEL:;	// nothing to do
				IDYES: begin bo_last_operator := FALSE;goto after_read end;
				IDNO: exit
				{$ifdef DEBUG} else assert(FALSE,'translate_function result out of range') {$endif}
			end;
{			if (str_formula[1] in OPERATORI_FORMULA_TESTO_SET) then begin
				bo_last_operator := TRUE;delete(str_formula,1,1);
				goto after_read
			end;
			if (NOT bo_last_operator) then begin str_result := 'Errore nella formula';exit end; }
			bo_last_operator := FALSE;
			if (str_formula[1] = VIRGOLETTA) then begin
				s := '';delete(str_formula,1,1);
				while (length(str_formula) > 0) AND (str_formula[1] <> VIRGOLETTA) do begin
					str_result := str_result + str_formula[1];delete(str_formula,1,1)
				end;
				if (str_formula = '') then begin
					str_result := 'Nella formula c''è una virgoletta (carattere " ) che non è stata chiusa.';
					exit
				end;
				delete(str_formula, 1, 1);
				goto after_read
			end;

			s := '';
//			while (length(str_formula) > 0) AND NOT (str_formula[1] in OPERATORI_FORMULA_TESTO_SET + [' ']) do begin
			while (length(str_formula) > 0) AND NOT CharInSet(str_formula[1], OPERATORI_FORMULA_TESTO_SET + [' ']) do begin
				s := s + str_formula[1];delete(str_formula,1,1)
			end;

//			xobj := name2obj(str,[VARIABILE,FORMULA],TRUE);		** fino a 2011-05-11
//			xobj := name2obj(str, OBJS_FORMULE_VARIABILI, TRUE);
			var xobj : objs_type := name2obj(s, TV_OLD_VARIABILI + [TV_FORMULA], TRUE);
			if (xobj = NIL) then begin
				str_result := 'Il simbolo <' + s + '> non è una variabile nè una formula.' + ACAPO2 +
					'Una formula di testo può essere composta da VARIABILI, FORMULE, '+  // **** aggiunto FORMULE
					'PAROLE (contenute entro coppie di virgolette) e il segno di concatenazione ''+''.';
				exit
			end;
			var lab : cl_label := xobj.aslabel;
			if bo_test then begin
//				if (lab.str_esempio_value = '') then begin
				if (xobj.ca.str_esempio_value = '') then begin
//					case lab.tipo_valore of
					case xobj.ca.tipo_valore of
						VAL_TESTO : str_result := str_result + s;
						VAL_NUMERO : str_result := str_result + inttostr(random(50000) + 250)
						else {$ifdef DEBUG} assert(FALSE,'TIPO di valore non trattato') {$endif}
					end
				end
//				else str_result := str_result + lab.str_esempio_value
				else str_result := str_result + xobj.ca.str_esempio_value
			end
			else begin
//				if (lab.tipo_valore = VAL_NUMERO) then lab.applica_formato_numerico;
				s := lab.str_print;
				str_result := str_result + s
			end;

after_read:
			str_formula := togliblanks(str_formula)
		until (str_formula = '')
	finally
		sostituisci(str_result, VIRGOLETTA_IN_TEXT_INTERNAL_USE, VIRGOLETTA{_IN_TEXT})	// trasformo nel carattere definitivo
	end;
//	str_result := togliblanks(str_result);
	result := TRUE
end;

function translate_formula_NUMERO(str_formula : string;var str_result : string;bo_test : boolean;ox : objs_type) : boolean;
// assegna a STR_RESULT il risultato della formula; tale risultato viene arrotondato ma non formattato
label after_read;
var
	s : string;	//*
	fl_result : double;	//*
begin
	result := FALSE;
	var bo_last_operator := TRUE;
	str_formula := clear_external_parentesi(str_formula);	// tolgo le eventuali parentesi externe (ininfluenti ma fastidiose)

	repeat
		var tipo : risultato_type := VAL_NUMERO;	// l'eventuale FORMULA deve rendere un numero!
		case translate_function(str_formula, str_result, bo_test, tipo, ox) of
			IDCANCEL:; // nothing to do
			IDYES: begin bo_last_operator := FALSE;goto after_read end;
			IDNO: exit
			{$ifdef DEBUG} else assert(FALSE,'translate_function result out of range') {$endif}
		end;
//		if {(str_formula <> '') AND }(str_formula[1] in OPERATORI_FORMULA_NUMERO_SET + PARENTESI) then begin
		if {(str_formula <> '') AND }CharInSet(str_formula[1], OPERATORI_FORMULA_NUMERO_SET + PARENTESI) then begin
			bo_last_operator := TRUE;
			str_result := str_result + str_formula[1];
			delete(str_formula, 1, 1);
			goto after_read
		end;
		if NOT bo_last_operator then begin str_result := 'Errore nella formula';exit end;
		bo_last_operator := FALSE;
//		if (str_formula[1] in ['0'..'9']) then begin
		if CharInSet(str_formula[1], ['0'..'9']) then begin
			s := '';
//			while (length(str_formula) > 0) AND (str_formula[1] in ['0'..'9','.']) do begin
//			while (str_formula <> '') AND (str_formula[1] in ['0'..'9','.']) do begin
			while (str_formula <> '') AND CharInSet(str_formula[1], ['0'..'9','.']) do begin
//				str_result := str_result + upcase(str_formula[1]);
				str_result := str_result + str_formula[1];
				delete(str_formula, 1, 1)
			end;
			goto after_read
		end;

		s := '';
//		while (length(str_formula) > 0) AND NOT (str_formula[1] in OPERATORI_FORMULA_NUMERO_SET + PARENTESI + [' ']) do begin
		while (length(str_formula) > 0) AND NOT CharInSet(str_formula[1], OPERATORI_FORMULA_NUMERO_SET + PARENTESI + [' ']) do begin
			s := s + str_formula[1];delete(str_formula, 1, 1)
		end;

//		xobj := name2obj(str,[VARIABILE,FORMULA],TRUE);		// FORMULA: aggiunta il 1998-08-02
//		xobj := name2obj(str, OBJS_FORMULE_VARIABILI, TRUE);	// cosi dal 2011-05-09
		var xobj : objs_type := name2obj(s, TV_OLD_VARIABILI + [TV_FORMULA], TRUE);	// cosi dal 2011-05-17
		if (xobj = NIL) then begin
			str_result := 'Il simbolo <' + s + '> non è una variabile nè una formula.' + ACAPO2 +
				'Una formula numerica può essere composta da VARIABILI e FORMULE numeriche, OPERATORI e NUMERI.';
			exit
		end;
(*		if (xobj.get_tipo = FORMULA) then begin	// se si tratta di formula, la faccio valutare
			tipo_formula := VAL_NUMERO;
			if NOT translate_formula(xobj.aslabel.str_formula,str_result,bo_test,tipo_formula,
				obj2index(xobj))
			then begin
				str_result := 'Errore durante la valutazione della formula <'+ str + '>.' + ACAPO2 + str_result;
				exit
			end
		end; *)
//		if (xobj.aslabel.tipo_valore <> VAL_NUMERO) then begin
		if (xobj.ca.tipo_valore <> VAL_NUMERO) then begin
			str_result := 'La variabile <' + s + '> non è di tipo numerico e non può essere utilizzata in una formula numerica.';
			exit
		end;
		if bo_test then begin
//			if (xobj.aslabel.str_esempio_value = '')
			if (xobj.ca.str_esempio_value = '')
				then str_result := str_result + inttostr(random(50000) + 250)
			else begin
//				if NOT RRVal(xobj.aslabel.str_esempio_value,r_temp) then begin
				var r_temp : real;
				if NOT RRVal(xobj.ca.str_esempio_value, r_temp) then begin
					str_result := 'L''oggetto <' + xobj.get_name + '> ha un valore di esempio non numerico';
					exit
				end;
//				str_result := str_result + xobj.aslabel.str_esempio_value
				str_result := str_result + xobj.ca.str_esempio_value
			end
		end
		else begin
//	 		s := xobj.aslabel.str_print;	// fino al 99/08/08
{$ifdef PROVA} *** 2012-09-01 verificare arrotondamenti {$endif}
			s := strid(xobj.aslabel.xdbl_print_value, 0, 0);	// dal 99/08/08
			if s = '' then s := '0';	// blank vale 0 (soprattutto per il caso di record NULL)
			str_result := str_result + s
		end;

after_read:
		str_formula := togliblanks(str_formula)
	until (str_formula = '');
	result := calcola(str_result, fl_result);
	if result then begin
		// OX può legittimamente essere uguale a NIL perchè la formula non è legata ad alcun oggetto specifico
		if (ox <> NIL) then begin
			var lab := ox.aslabel;
			var i_round : smallint := lab.xi_cifre_round;
			// I_ROUND potrebbe essere un valore simbolico (es: FIX_ROUNDING) che deve essere applicato in funzione della valuta, qui difficilmente reperibile
			if NOT symbolic_round(i_round) then fl_result := my_round(fl_result, -i_round, lab.round_method)	// prima arrotondo come desiderato
		end;
		str_result := strid(fl_result{,0,0})
	end
	else str_result := 'Errore nel calcolo della formula.' + ACAPO2 + str_result
end;

{$ifdef DEBUG}
	var sstack : array[1..MAX_FORMULA_RICORSIONI+1] of string;
{$endif}

function translate_formula(str_formula : string;var str_result : string;bo_test : boolean;var tipo : risultato_type;ox : objs_type) : boolean;
{ esegue la trasformazione della formula simbolica STR_FORMULA in una formula costituita da
  soli numeri, in funzione dei valori assunti dai simboli inclusi nella formula;
  la funzione rende TRUE in caso di successo, FALSE altrimenti;
  LP_RESULT contiene il messaggio di errore o il risultato dell'elaborazione;
  LP_FORMULA può essere = LP_RESULT;
  if BO_TEST viene eseguito solo un controllo sulla esistenza e la validità dei simboli }
label retry;
const MBOX_CAPTION = 'Formula';
var str_temp : string;	//*
begin
	if bo_test then str_temp := 'TRUE' else str_temp := 'FALSE';
	str_formula := clear_external_parentesi(str_formula);		// tolgo le eventuali parentesi externe (ininfluenti ma fastidiose)
retry:
	result := FALSE;
	str_result := '';
	sostituisci(str_formula, ACAPO, ' ');
	togli_blanks_non_necessari(str_formula);
	if (str_formula = '') then begin
		str_result := 'Le formule vuote, come le vuote formule, non sono ammesse.' + ACAPO +
			'Ci vuole sostanza, nelle cose; sostanza, ci vuole!';
		exit
	end;

	if globale.translate_macro_parametrica(str_formula, str_temp, ox, bo_test) then begin
		str_formula := str_temp + str_formula;
//		togli_blanks_non_necessari(str_formula);
//		result := IDYES;exit
		goto retry
	end;

	try
		inc(i_formula_level);
		{$ifdef DEBUG} sstack[i_formula_level] := str_formula; {$endif}
		if (i_formula_level > MAX_FORMULA_RICORSIONI) then begin
			MessageBBox(GH, 'E'' stata caricata una formula (anche indirettamente) ricorsiva, '+
				'oppure sono presenti funzioni che presentano un eccessivo livello di Niagara calls (chiamate a cascata)',
				MBOX_CAPTION, MB_ICONSTOP);
			abort
		end;
		if (tipo = VAL_BOH) then begin
//			if (i_obj = 0) then tipo := get_tipo_formula(str_formula) else tipo := objs(i_obj).aslabel.tipo_valore
//			if (ox = NIL) then tipo := get_tipo_formula(str_formula) else tipo := ox.aslabel.tipo_valore
			tipo := get_tipo_formula(str_formula)	// il tipo della formula non dipende dal tipo di oggetto (può essere una formula contenuta in un if() contenuto nella formula ...)
		end;
		case tipo of
			VAL_TESTO : result := translate_formula_testo(str_formula, str_result, bo_test, ox);
			VAL_NUMERO : result := translate_formula_numero(str_formula, str_result, bo_test, ox);
			else begin
				{$ifdef DEBUG} assert(FALSE,'TIPO di valore non trattato in TRANSLATE_FORMULA'); {$endif}
				str_result := '';
				if (ox <> NIL) then str_result := ox.aslabel.Caption + ' - ';
				str_result := str_result + 'errore durante la valutazione della formula'
			end
		end
	finally
		{$ifdef DEBUG} sstack[i_formula_level] := ''; {$endif}
		dec(i_formula_level)
	end
end;

function interpreta_boolean_expression(str_boolean : string;bo_test : boolean;var bo_result : boolean;var str_msg : string) : boolean;
{ valuta l'espressione booleana contenuta in STR_BOOLEAN; rende TRUE se l'espressione è corretta;
  if BO_TEST il risultato è sempre TRUE, else il risultato viene restituito in BO_RESULT;
  eventuali messaggi di errore vengono caricati su STR_MSG }

	function valuta(s1, s2, str_operatore : string;tipo : risultato_type) : boolean;
	{ rende il valore dell'espressione s1 STR_OPERATORE s2;
	  in caso di errore durante la valutazione emette un eventuale messaggio ed
	  esegue un abort;
	  if BO_TEXT then s1 e LP2 sono di tipo testo, altrimenti sono numeri }
	const ZERO = 1e-8;	// approssimazione dello zero
	var i : integer;	//*
	begin
		result := FALSE;
		case tipo of
			VAL_TESTO: begin
//				i := strIcomp(asciiz(s1), asciiz(s2));
				i := CompareStr(s1, s2);
				if (str_operatore = '=') then result := (i = 0) else
				if (str_operatore = '<=') then result := (i <= 0) else
				if (str_operatore = '>=') then result := (i >= 0) else
				if (str_operatore = '<') then result := (i < 0) else
				if (str_operatore = '>') then result := (i > 0) else
				if (str_operatore = '!=') then result := (i <> 0) else
				if (str_operatore = '<>') then result := (i <> 0)
				else begin
					{$ifdef DEBUG} assert(FALSE,'OPERATORE non gestito');{$endif}
					abort
				end
			end;
			VAL_NUMERO: begin
				var r1, r2 : real;
				RRval(s1, r1, @i);
				if (i = 0) then RRval(s2, r2, @i);
				if (i <> 0) then begin
					{$ifdef DEBUG} assert(FALSE,'should not succeed: formula numerica errata dopo tutte le verifiche'); {$endif}
					abort
				end;
				if (str_operatore = '=') then result := (abs(r1-r2) < ZERO) else
				if (str_operatore = '<=') then result := (r1 <= r2) else
				if (str_operatore = '>=') then result := (r1 >= r2) else
				if (str_operatore = '<') then result := (r1 < r2) else
				if (str_operatore = '>') then result := (r1 > r2) else
				if (str_operatore = '!=') OR (str_operatore = '<>') then result := (abs(r1-r2) > ZERO)
				else begin
					{$ifdef DEBUG} assert(FALSE,'OPERATORE non gestito (2)');{$endif}
					abort
				end
			end
			else begin
				{$ifdef DEBUG} assert(FALSE,'OPERATORE non gestito');{$endif}
				abort
			end
		end
	end;

var
	s1, s2 : string;
	bo_1, bo_2 : boolean;
begin
	result := FALSE;bo_result := FALSE;
	{$ifdef DEBUG} assert(str_boolean <> '','DJGH 28783 str_boolean is blank'); {$endif}

	// 2013-02-03 perchè non venivano automaticamente tradotte certune espressioni
	sections_1B(MAIN_SECTION, get_pagina_logica_attiva_1B).interpreta_string(str_boolean, {stampa_vera}TRUE, {check_errors}TRUE);

	str_boolean := clear_external_parentesi(str_boolean);		// tolgo le eventuali parentesi externe (ininfluenti ma fastidiose)

	// cerco un operatore AND a livello esterno (non nidificato in parentesi)
	var i_op : smallint := get_char_in_formula(OP_AND, str_boolean);
	if (i_op <> 0) then begin
		bo_1 := FALSE;bo_2 := FALSE;
		s1 := togliblanks(copy(str_boolean, 1, i_op - 1));
		s2 := togliblanks(copy(str_boolean, i_op + length(OP_AND), MAXINT));
		if NOT interpreta_boolean_expression(s1, bo_test, bo_1, str_msg) then exit;
		// valuto la seconda espressione solo se la prima è vera (o se sto eseguendo un test di correttezza syntattica)
		if (bo_1 OR bo_test) AND NOT interpreta_boolean_expression(s2, bo_test, bo_2, str_msg) then exit;
		bo_result := bo_test OR (bo_1 AND bo_2);
		result := TRUE;exit
	end;

	// cerco un operatore OR a livello esterno (non nidificato in parentesi)
	i_op := get_char_in_formula(OP_OR, str_boolean);
	if (i_op <> 0) then begin
		bo_1 := FALSE;bo_2 := FALSE;
		s1 := togliblanks(copy(str_boolean, 1, i_op - 1));
		s2 := togliblanks(copy(str_boolean, i_op + length(OP_OR), MAXINT));
		if NOT interpreta_boolean_expression(s1, bo_test, bo_1, str_msg) then exit;
		// valuto la seconda espressione solo se la prima è false (altrimenti non serve)
		if (NOT bo_1 OR bo_test) AND NOT interpreta_boolean_expression(s2, bo_test, bo_2, str_msg) then exit;
		bo_result := bo_test OR (bo_1 OR bo_2);
		result := TRUE;exit
	end;

//	if (get_char_in_formula(OPERATORI_COMPARAZIONE[i_op],str_boolean))
	i_op := 1;var j : smallint := 0;
	while (i_op <= NUM_OPERATORI_COMPARAZIONE) do begin
		j := get_char_in_formula(OPERATORI_COMPARAZIONE[i_op], str_boolean);
		if (j <> 0) then break;
		inc(i_op)
	end;
	if (i_op > NUM_OPERATORI_COMPARAZIONE) then begin
		str_msg := 'manca l''operatore di confronto nella espressione logica' + ACAPO2 + str_boolean;
		exit
	end;
	s1 := copy(str_boolean, 1, j-1);
	s2 := copy(str_boolean, j + length(OPERATORI_COMPARAZIONE[i_op]), MAXINT);
	var tipo1 := VAL_BOH;var tipo2 := VAL_BOH;
	if NOT translate_formula(s1, s1, bo_test, tipo1, NIL) then begin
		str_msg := 'errore nel primo termine dell''espressione logica:' + ACAPO2 + s1 + ACAPO2 + str_boolean;
		exit
	end;
	if NOT translate_formula(s2, s2, bo_test, tipo2, NIL) then begin
		str_msg := 'errore nel secondo termine dell''espressione logica:' + ACAPO2 + s2 + ACAPO2 + str_boolean;
		exit
	end;

	if (VAL_BOH in [tipo1, tipo2]) then begin
		str_msg := 'non riesco a capire il tipo dell''espressione logica' + ACAPO2 + str_boolean;
		exit
	end;
	if (tipo1 <> tipo2) then begin
//		str_msg := 'gli argomenti dell''espressione logica non sono compatibili' + ACAPO2 + str_boolean;exit	COSI' FINO AL 2006-04-02
		tipo1 := VAL_TESTO;tipo2 := VAL_TESTO
	end;
	try
		bo_result := valuta(s1, s2, OPERATORI_COMPARAZIONE[i_op], tipo1);	// valuto nel modo opportuno il predicato
		result := TRUE
	except
		str_msg := 'errore durante la valutazione dell''espressione logica'
	end
end;

{$ifdef GALATEO_EXE}
//	function check_condizione_booleana(sxt : SQL_script_type;i_script : smallint) : boolean;
	function check_condizione_booleana(handle : hwnd;str_condizione, str_descrizione : string;pt_message : string_punt = NIL) : boolean;
	{ esegue un controllo sulla condizione di esecuzione dello script specificato; rende TRUE se tutto ok, FALSE se trova errori;
	  emette eventuali messaggi di errore, oppure li carica su PT_MESSAGE se != NIL }
	const MBOX_CAPTION = 'Condizione di esecuzione';
	var
		bo : boolean;	//*
		str_msg : string;	//*
	begin
		result := TRUE;
		if (str_condizione = '') then exit;
		sections_1B(MAIN_SECTION, 1).interpreta_string(str_condizione, {stampa_vera}FALSE, {check_errors}TRUE);
//		if globale.translate_macro_parametrica(str_condizione, str_temp, NIL, {test}TRUE) then str_condizione := str_temp + str_condizione;
		result := interpreta_boolean_expression(str_condizione, TRUE, bo, str_msg);
		if NOT result then begin
			if (pt_message = NIL) then MessageBBox(handle, str_msg, str_descrizione + ' - condizione di esecuzione', MB_ICONSTOP)
			else pt_message^ := str_msg
		end
	end;
{$endif}

{$ifdef DEBUG}
	procedure check_definizioni;
	begin
		assert(NUM_FUNCTIONS = NDXF_LAST,'numero max funzioni errato');
		for var i : smallint := 1 to NUM_FUNCTIONS do begin
			for var j : smallint := 1 to MAX_PARMS_FUNCTION do begin
				if ((j <= FUNC[i].i_parms) AND (FUNC[i].parm_type[j] = VAL_BOH)) OR
					((j > FUNC[i].i_parms) AND (FUNC[i].parm_type[j] <> VAL_BOH))
				then MessageBBox(0,'Funzione ' + FUNC[i].str_name + '(): parametri errati', 'Galateo Functions', MB_ICONSTOP)
			end;
			if (FUNC[i].i_parms < FUNC[i].i_parms_necessari) then
				MessageBBox(0,'Funzione ' + FUNC[i].str_name + '(): numero max di parametri inferiore al numero minimo', 'Galateo Functions', MB_ICONSTOP)
		end
	end;
{$endif}

initialization
	galateo_initialization_debug('functions');
	i_NDXF_POS_ULTIMA_ETICHETTA_STAMPATA_EXTERNAL := NDXF_POS_ULTIMA_ETICHETTA_STAMPATA;
	{$ifdef DEBUG} check_definizioni {$endif}
finalization
	galateo_finalization_debug('functions')
end.
