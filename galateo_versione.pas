//* versione per GALATEO -- incluso by GDICH

{$ifdef PROVA}
	legare la disponibilità (e la versione predefinita) delle exportazioni integrali ad una condizione
{$endif}

{ sequenze di tasti non pubblicate:
	ctrl+alt+shift+
		S : diventa System operator
		Y : don't save version of report
}

const
	{ GALRUN non ha la necessità di essere sempre aggiornato rispetto alla versione di CASA.DLL;
	  in certi casi tuttavia (cambio della struttura delle funzioni di interfaccia) è necessario che lo sia;
	  il parametro qui sotto serve proprio per garantire che tale compatibilità sia soddisfatta;
	  deve essere incrementato in occasione delle modifiche sulla struttura delle funzioni esposte dalla DLL }
	DLL_COMPATIBILITY_VERSION = 1;
	GALATEO_VERSIONE_MAJOR = $04;	// prime due cifre esadecimali: MAJOR VERSION

// al cambio di versione prova a valutare l'ipotesi di cambiare i valori di OBJECT_EXPINT_MODE_TYPE (vedi EXPINT_BASE)

	GALATEO_VERSIONE_MINOR = $0B;	// seconde due cifre esadecimali: MINOR VERSION (qui scritto in DECIMALE)
	// la versione effettiva si ottiene accostando MAJOR (esempio $04) e MINOR (esempio $11): esempio $0411
	GALATEO_VERSION = GALATEO_VERSIONE_MAJOR * $100 + GALATEO_VERSIONE_MINOR;	// prime due cifre esadecimali: major versione, ultime 2: minor version
//	GALATEO_VERSION = $0327;	// prime due cifre esadecimali: major versione, ultime 2: minor version
	DLL_FILENAME = 'casa.dll';		// serve per ragioni generiche (sapere dove si trova il file, data-ora, eccetera); non determinante per il funzionamento
		// ***** RICORDATI DI SALVARE L'ESEGUIBILE DELLA VERSIONE PRECEDENTE *************
//		// 4.0C					------------------------------------------------------
		// 4.0B	2025-04-11	------------------------------------------------------
		//							assegnazione stampante default da eseguibile (JOLLY)
		//							aggiunta gestione modalità anticipate di validazione (VCTXT_CHECK_PARMS, VCTXT_AFTER_RUNTIME)
		// 4.0A	**********	------------------------------------------------------
		//							risolti bugs in exportazione integrale
		//							modificata chiamata INIT_GALATEO() per più dettagliata gestione debugging
		//	4.09 2022-10-25	------------------------------------------------------
		//							possibilità di determinare l'arrtondamento di un oggetto TESTO (numero) con una formula
		//							possibilità di determinare il numero di decimali di un oggetto TESTO (numero) con una formula
		//							possibilità di determinare il numero di cifre di un oggetto TESTO (numero) con una formula
		//	4.08 2022-09-11	------------------------------------------------------
		//							sistemato problema delle righe vuote non stampate (e degli spazi ad inizio riga)
		//							aggiunto parametro facoltativo BO_SPAZIO su funzione MIN2HOURS()
		//	4.07 2021-11-10	------------------------------------------------------
		//							salvataggio su file del comando SQL delle sezioni
		//	4.06 2021-05-16	------------------------------------------------------
		//							funzioni di gestione CIN() CIN/ APPEND_CIN/ CHECK_CIN/ DECODE_FROM_CIN
		//	4.05 2021-04-14	------------------------------------------------------
		//							attivata modalità di protezione accesso ai files di configurazione della connessione a database (DBP_GALATEO_FREE_ACCESS)
		//	4.04 2021-03-08	------------------------------------------------------
		//							gestione colonne colorate
		//							formule di ridimensionamento cornici
		//							RECTs con fondo colorato e con angoli arrotondati
		//							sfondo e trasparenza oggetti di testo
		//	4.03 2021-03-08	------------------------------------------------------
		//							aggiunti parametri di connessione database (PROFILO, vedi CONNECTION_CONFIGURATION_TYPE)
		//	4.02 2020-08-02	------------------------------------------------------
		//							immagini utilizzabili come sfondo a design-time (per la costruzione del report)
		//	4.01 2019-12-xx	------------------------------------------------------
		//							gestione PDF modificabili
		// 4.00 2019-09-08	------------------------------------------------------
		//							delphi DX 10.3, versioni a 32 e 64 bits
		// 3.34 2019-07-28	------------------------------------------------------
		//							aggiunta funzione BISESTILE(anno)
		// 3.33 2019-05-19	------------------------------------------------------
		//							aggiunto valore FL_MAX_VERTICAL_SIZE su oggetti che possono essere splittati su più righe
		//	3.32 2019-01-02	------------------------------------------------------
		//							aggiunto parametro PT_STR_LAST_EXPORTED_FILENAME a chiamate DLL GAL_OPEN_AND_PRINT_METHOD() e GAL_OPEN_AND_PRINT_PROC()
		//	3.31 2018-11-11	------------------------------------------------------
		//							modificati (eliminati) parametri configurazione OUTLOOK (e quindi comunicazione con Jolly)
		//	3.30 2018-07-22	------------------------------------------------------
		//							aggiunta HASH per salvataggio SQL scripts e MACRO PARAMETRICHE, per segnalare le modifiche eseguite da altri reports
		//	3.2F 2018-09-21	------------------------------------------------------
		//							introduzione criterio di valutazione oggetti da calcolare (DICH: recalculate_type)
		//							SQL scripts: distinzione tra ABILITAZIONE all'esecuzione LOCALE (sul singolo report) o REMOTA (sul textfile)
		//							messa a punto salvataggio SQL scripts e MACRO PARAMETRICHE su textfiles separati
		//	3.2E 2018-07-15	------------------------------------------------------
		//							salvataggio SQL scripts e MACRO PARAMETRICHE su textfiles separati
		//	3.2D 2018-07-07	------------------------------------------------------
		//							gestione mail OUTLOOK, collaterale ristrutturazione SMTP e MAPI
		//	3.2C 2018-05-21	------------------------------------------------------
		//							gestione attesa al termine di ogni pagina stampata (il break esisteva già, ho aggiunto solo la durata variabile)
		//	3.2B 2017-10-09	------------------------------------------------------
		//							portato numero max objects per logical page da 300 a 400 (colpa di Sebastian GTCalor)
		//	3.2A 2017-02-22	------------------------------------------------------
		//							funzione DLL-exported GAL_get_system_debug_filename()
		//	3.29 2017-02-10	------------------------------------------------------
		//							funzione di pausa al termina della stampa di ogni pagina (IBI)
		//	3.28 2016-10-09	------------------------------------------------------
		//							implementazione limiti inferiori e superiori dimensione pagina stampante
		//							correzione BUG su COMPORTAMENTO_WHEN_NULL
		//	3.27 2016-07-03	------------------------------------------------------
		//		  2016-08-12	aggiunte funzioni CODICEFISCALE(), PARTITAIVA(), CODFIS_PIVA(), IBAN()
		//	3.26 2016-07-03	------------------------------------------------------
		//							eliminato BUG (introdotto probabilmente 2016-05) che sfasava le intestazioni rispetto alle colonne nell'exportazione integrale
		//		  2016-07-02	aggiunta funzioni di gestione COMPORTAMENTO_WHEN_NULL
		//		  2016-06-03	eliminato BUG che impediva la stampa di oggetti di testo semplici (privi di indicazioni di traduzione) quando era attivata la traduzione automatica
		// 3.25 2016-02-02	------------------------------------------------------
		//							cambio parametri di chiamata per le principali CALLBACK PROCEDURES **************************************************
		//		  2016-02-01	URLs personalizzati assegnati dal programma chiamante (STR_LINKS_RUNTIME)
		//		  2016-01-27	risolto BUG che in caso di immagine dinamica assegnata a blank continuava a mostrare la precedente immagine caricata
		//							aggiunta funzione set_callback_replace_variabili_ambiente() per gestione sostituzione variabili di ambiente JOLLY (prima c'era solo la sostituzione delle variabili di sistema)
		// 3.24 2015-12-14	------------------------------------------------------
		//							funzioni TEXT2XML e XML2TEXT
		// 3.23 2015-05-13	------------------------------------------------------
		//							encode UTF8 in exportazione XML
		// 3.22 2015-04-19	------------------------------------------------------
		//							miglioramento della gestione dei profili di exportazione
		//							accorpamento modalità di export INTEGRALE e XML
		//							gestione delle transazioni a livello di singolo SCRIPT-SQL
		//							funzionalità di controllo e validazione runtime
		// 3.21 2015-04-15	------------------------------------------------------ **** la versione 3.21 non è stata diffusa pubblicamente ***
		//							riordinato modalità di stampa, target di stampa e azioni predefinite
		//							introdotto exportazione XML
		// 3.20 2015-02-07	------------------------------------------------------
		//							migliorato e sistemato sistema di debugging
		//							risolti bug sul nomefile e path exportazione (causati da modifica su export multifile di agosto)
		//							sistemazione invio via SMTP (SSL, GMAIL, YAHOO, eccetera)
		//	3.12	2014-08-24 ------------------------------------------------------
		//							possibilità di salvare più files per ogni report (un file per ogni record, o per ogni pagina)
		//							possibilità di selezionare a runtime le sezioni da includere nell'exportazione integrale
		//							2014-06/07/08 sistemati svariati bugs di formattazione in valuta
		// 3.11	2014-02-28 ------------------------------------------------------
		//							flag per attivazione/disattivazione RI-ESECUZIONE scripts SQL
		// 3.10	2013-05-01 ------------------------------------------------------
		//							risolto bug di salvataggio che scombussolava i campi di exportazione integrale qualora si aggiungessero oggetti al report
									{ fino alla versione $030F gli oggetti ricevevandel suo pensieroo l'indice progressivo di caricamento
									  dalla versione $0310 gli oggetti mantengono rigidamente l'indice originale
									  la differenza tra le due modalità è che poichè il salvataggio avviene per sezione (prima la 1, poi la 2, poi la 3)
									  gli oggetti vengono automaticamente rinumerati secondo la sezione di appartenenza (prima gli oggetti della sezione 1,
									  poi quelli della 2, ...)
									  questo comportamento comportava lo sfalsamento delle informazioni di exportazione integrale, che erano legate alla
									  posizione originale di salvataggio }
		// 3.0F	2013-04-22 ------------------------------------------------------
		//							invio mail con forzatura modalità SMTP su client default di sistema (SMTP:federico@feaci.it)
		//							conferma (con password opzionale) per la exportazione integrale su FTP (2013-03-24)
		// 3.0E	2013-02-06 ------------------------------------------------------
		//							FONT condizionale su oggetti di testo (funzione inserita ma non funzionante)
		// 3.0D	2013-02-03 ------------------------------------------------------
		//							campi str_formula_Xshift_mm e str_formula_Yshift_mm per lo shiftamento calcolato degli oggetti
		//							condizioni di stampa pagine
		//							condizioni di esecuzione agli scripts SQL
		// 3.0C	2013-01-13 ------------------------------------------------------
		//							opzione ridimensionamento verticale oggetti RECT e LINES (prima avveniva sempre, ora solo quando necessario)
		// 3.0B	2012-12-31 ------------------------------------------------------
		//							salvataggio export integrale su server FTP
		// 3.0A	2012-11-01 ------------------------------------------------------
		//							gestione numero variabile di scripts SQL
		// 3.09	2012-10-28 ------------------------------------------------------
		//							gestione documenti di riferimento per l'utente e technical reference
		// 3.08	2012-06-28 ------------------------------------------------------
		//							aggiunta gestione diretta SMTP
		// 3.07	2012-06-20 ------------------------------------------------------
		//							fatto nulla, ho cambiato idea
		// 3.06	2011-12-31 ------------------------------------------------------
		//							aggiunta flag BO_LOAD_INDIRIZZO_MAIN_WHEN_UNIQUE su gestione indirizzi mail
		// 3.05	2011-12-24 ------------------------------------------------------
		//							correzione di un piccolo bug di formato del file (backward incompatibility)
		// 3.04	2011-11-15 ------------------------------------------------------
		//							profili multipli di exportazione integrale
		//	3.03	2011-09-11 ------------------------------------------------------
		//							opzioni da attivare in caso di assenza di stampante assegnata (azione_printer_unknown_type)
		//	3.02	2011-07-25 ------------------------------------------------------
		//							trattamento specifico indirizzi mail da caricare per default sulla finestra di trasmissione per mail 
		//							gestione modalità di selezione default printer (modalita_default_printer)
		//	3.01	2011-07-05 ------------------------------------------------------
		//							cambio valore campo ROUND_TYPES (commons.xtypes.ROUND_TYPES)
		// 3.00	2011-05-12 ------------------------------------------------------
		//							oggetti Datamatrix
		//							pesante ristrutturazione oggetti, con ottimizzazione velocità di esecuzione
		//							TLabel >> TFlabel, con gestione scritte inclinate e verticali
		// 2.60	2009-11-20 ------------------------------------------------------
		//							funzioni FORMATTA_VALUTA_xxx()
		// 2.5F	2009-10-24 ------------------------------------------------------
		//							possibilità di considerare i valori di esempio degli oggetti come FORMULE
		//							gestione salvataggio posizione ultima etichetta stampata e funzione POS_ULTIMA_ETICHETTA_STAMPATA()
		// 2.5E	2009-06-11 ------------------------------------------------------
		//							funzione stringofchar()
		// 2.5D	2009-06-09 ------------------------------------------------------
		//							validazione runtime-objects: lunghezza minima
		// 2.5C	2009-03-11 ------------------------------------------------------
		//							exportazione integrale: ottimizzazione (CPU) nella generazione del risultato
		//							exportazione integrale: possibilità di definire separatore (TAB, virgola, semicolon)
		//							exportazione integrale: flag per exportazione automatica (senza richieste all'utente)
		// 2.5B	2009-02-27 ------------------------------------------------------
      //							exportazione integrale: flag per inserimento riga tra headers e dati
      //							exportazione integrale: flag per generazione headers su singola sezione (sezione.bo_expint_headers_colonne)
		// 2.5A	2009-02-24 ------------------------------------------------------
		//							flag per registrazione su debug delle istruzioni eseguite su RUNTIME PARMS
		// 2.59	2009-02-18 ------------------------------------------------------
		//							creazione early-SQL-script (00)
		// 2.58	2009-02-13 ------------------------------------------------------
		//							correzione di bugs sugli scripts SQL e sulle macro locali
		//							implementazione commenti (//) sugli scripts (ovunque vi siano le macro locali)
		//							aggiunto un parametro alla funzione GAL_browse_files()
		// 2.57	2008-10-12 ------------------------------------------------------
		//							funzioni GAL_set_date_SQL() e GAL_set_date_DMY()
		// 2.56	2008-09-09 ------------------------------------------------------
		//							scripts sui parametri runtime
		//							cryptatura dei parametri di connessione a database (durante il salvataggio su file)
		//	2.55	2008-07-31 ------------------------------------------------------
		//							salvataggio delle informazioni di formato della pagina fisica nel caso di TR_LABEL_STANDALONE
		//	2.54	2008-07-16 ------------------------------------------------------
		//							corretto BUG di esecuzione GALRUN che faceva emettere messaggi impropri
		//							miglioramento funzioni di esecuzione diretta della stampa, soprattutto via GALRUN
		//	2.53	2008-07-12 ------------------------------------------------------
		//							function SECTION_GROUP_CHANGED()
		//	2.52	2008-05-10 ------------------------------------------------------
		//							spostamento opzioni di invio per email dalle opzioni PDF alle opzioni generali
		//	2.51	2008-04-25 ------------------------------------------------------
		//							exportazione integrale su file di testo (was: only clipboard)
		//	2.50	2008-04-01 ------------------------------------------------------
		//							allineamento (sx/center/dx e top/center/bottom) delle immagini caricate dinamicamente
		//	2.4F	2008-01-31 ------------------------------------------------------
		//							impostazioni per eseguire la stampa diretta (saltando il dialog di selezione della stampante)
		//	2.4E	2007-11-27 ------------------------------------------------------
		//							runtime-parm per caricamento filenames
		// 2.4D	2007-10-10 ------------------------------------------------------
		//							possibilità di stampare più volte (un numero di volte a piacere) la stessa etichetta
		// 2.4C	2007-10-05 ------------------------------------------------------
		//			2007-10-05 formati di formattazione delle date (prima erano legati al formato implicito TField.AsString)
		// 2.4B	2007-07-26 ------------------------------------------------------
		//			2007-07-26	gestione del TrueType Font Embedding nella generazione dei files PDF
		//			2007-07-26	attributi per forzare Bold, Underlined, Italic e Strikeout (a prescindere dalle abilità integrate nei fonts)
		// 2.4A	2007-06-16 ------------------------------------------------------
		//							cl_sezione.bo_dont_export_continuazione, cl_label.expint_multiline, cl_label.str_expint_acapo
		// 2.49	2007-06-06 ------------------------------------------------------
		//							pos()
		// 2.48	2007-05-16 ------------------------------------------------------
		//							dt2SQL()
		// 2.47	2007-04-20 ------------------------------------------------------
		//							variabile RTQ_apix per runtime parameters
		// 2.46	2007-01-04 ------------------------------------------------------
		//							exportazione dati su file
		// 2.45	2006-10-29 ------------------------------------------------------
		//			2006-10-28	parametri runtime in uscita dal programma
		//			2006-10-28	possibilità di chiedere i parametri runtime in finestre differenti
		//			2006-10-26	interleave2of5Mod10
		// 2.44	2006/??/?? ------------------------------------------------------
		// 2.43	2006/07/30 ------------------------------------------------------
		//			2006/09/26	opzione 'double thickness' per la riga di separazione delle sezioni
		//			2006/09/10	opzione per limitare debug ad una specifica macchina
		//			2006/08		dialog unitaria di richiesta parametri (prima i parametri venivano chiesti uno ad uno)
		// 2.43	2006/07/30 ------------------------------------------------------
		//							proposta automatica di invio via e-mail della stampa
		// 2.42	2006/03/15 ------------------------------------------------------
		//							gestione automatica dei numeri di pagina progressivi
		// 2.41	2006/01/30 ------------------------------------------------------
		//							funzioni di salto pagine virtuale
		//	2.40	2005/11/06 ------------------------------------------------------
		//							funzione char()
		//							funzioni di gestione etichette: numero_etichetta_sezione(), eccetera
		//							modalità TR_LABEL_REPORT: stampa di etichette da SQL
		//			2005/09/27	descrizione breve per pagina logica (prima c'era una sola descrizione)
		//							autoheight
		//							selezione rapida col mouse, per area
		//	2.3F	2005/09/19	aggiunta delle modalità di visualizzazione OSW_SHOW_1REC e OSW_HIDE_1REC (mostra/nasconde sul primo record -- utile se il record si estende su più pagine)
		//							introduzione del minimum required space per la stampa di una sottosezione
		//							correzione di bugs legati alla formattazione delle sottosezioni di terzo livello o superiori
		// 2.3E	2005/09/05 ------------------------------------------------------
		//							fondo colorabile delle pagine per l'anteprima a video
		//							possibilità di scegliere il valore default per stampa/non stampa le pagine logiche
		// 2.3D	2005/08/15 ------------------------------------------------------
		//						  macro parametriche
		//						  gestione delle variabili
		// 2.3C	2005/08/03 ------------------------------------------------------
		//						  esportazione su PDF
		// 2.3B	2005/05/25 ------------------------------------------------------
		//						  passaggio dei parametri di connessione a RUNTIME dal programma a CASA.DLL
		//						  gestione dei parametri database e del login-prompt
		// 2.3A	2005/04/17 ------------------------------------------------------
		//						  macro locali alle istruzioni query SQL
		// 2.39	2005/04/10 ------------------------------------------------------
		//			2005/04/10 funzione list(comando SQL)
		//			2005/04/10 funzione COALESCE()
		//			2005/04/10 gestione DEBUG avanzato
		//			2005/04/10 isolation level
		// 2.38	2005/03/23 ------------------------------------------------------
		//			2005/03/23 funzione SECONDI_2_STRING()
		// 2.37	2005/03/15 ------------------------------------------------------
		//			2005/03/14 giustificazione testi
		// 2.36	2004/09/25 ------------------------------------------------------
		//						  aggiunta della descrizione delle modifiche apportate al report; perfezionamento della gestione del checksum (fino ad ora le ultime 3 cifre della stringa erano lo XOR della stringa)
		//						  descrizione del report, funzione print_link.get_descrizione_galateo()
		// 2.35	2004/08/26 ------------------------------------------------------
		//						  interpretazione dei valori default per i parametri da chiedere RUNTIME, e possibilità di usare gli stessi come istruzioni SQL
		// 2.34	2004/07/06 ------------------------------------------------------
		//						  ridimensionamento automatico della pagina in funzione delle dimensioni reali della stampante utilizzata
		//						  opzione di disabilitazione della registrazione su file log per SQL isolati
		// 2.33	2004/05/05 ------------------------------------------------------
		//						  pagine caricate da file esterno: possibilità di disabilitare il messaggio se la pagina non viene stampata
		//						  pagine caricate da file esterno: possibilità di indicare il file da includere a RUNTIME
		// 2.32	2004/05/05 ------------------------------------------------------
		//						  comando di esportazione distinto da istruzione SQL
		// 2.31	2004/03/28 ------------------------------------------------------
		//			2004-01-27 aggiunto formato per i parametri acquisiti runtime
		// 2.30	2004/01/27 ------------------------------------------------------
		//			2004-01-27 aggiunta funzione REPORT_DATETIME
		// 2.2F	2003/12/16 ------------------------------------------------------
		//						aggiunta funzionalità di indice e ricerca per i singoli records stampati
		// 2.2E	2003/10/28 ------------------------------------------------------
		//					   aggiunta funzioni PAGINA_LOGICA_NUMERO() e PAGINA_LOGICA_NOME()
		// 2.2D	2003/10/12 ------------------------------------------------------
		//					   aggiunta funzione CF_TO_DATANASCITA()
		// 2.2C	2003/09/19 ------------------------------------------------------
		//					   aggiunte funzioni PAGINA_RECORD() e TOT_PAGINE_RECORD()
		// 2.2B	2003/07/28 ------------------------------------------------------
		//			2003/07/28 aggiunta opzione 'multi select' per runtime parameters
		// 2.2A	2003/03/26 ------------------------------------------------------
		//			2003/03/26 gestione degli oggetti 'SQL syntax' elaborati prima della query principale
		// 2.29	2003/02/21 ------------------------------------------------------
		//			2003/02/21 gestione file di LOG per registrazione parametri di stampa
		// 2.28	2003/01/20 ------------------------------------------------------
		//			2003/01/20 modificati parametri di chiamata per funzioni di stampa
		//			2003/01/20 aggiunta funzione REPORT_FILENAME()
		// 2.27	2002/12/14 ------------------------------------------------------
		//			2002/12/14 flag 'stampa la sezione solo se la sottosezione contiene dei records'
		//			2002/12/** gestione efficace (non come prima!) dei flags 'mostra/nascondi a inizio/fine record'
		// 2.26	2002/10/27 ------------------------------------------------------
		//			2002/10/27 aggiunta funzione SOSTITUISCI()
		//			2002/10/27 possibilità di utilizzare le virgolette in formule di testo ( \" )
		// 2.25	2002/10/17 --------------------------------------------------------
		//			2002/10/17 opzione 'colore fondo rettangoli', inserita ma non implementata
		//			2002/10/17 modifica formato file, con incremento numero righe
		// 2.24	2002/10/15 ------------------------------------------------------
		//			2002/10/15 aggiunta domande strutturate a runtime
		//			2002/10/13 aggiunta funzionalità GAL_OPT_OBJ_SET_TIPOVARIABILE
		// 2.23	2002/08/31 ------------------------------------------------------
		//			2002/08/31 aggiunto attributo 'se cambia la size, sposta gli oggetti sottostanti' per le immagini
		//			2002/08/31 sistemato bug di ridimensionamento immagini caricate runtime
		// 2.22	2002/04/26 --------------------------------------------------------
		//			2002/04/26 aggiunte le funzioni FileExists() e FindFullFilename()
		// 2.21	         --------------------------------------------------------
		//			2001/12/24 possibilità di selezionare la stampante da eseguibili (GAL_GOPT_PRINTER_SELECT)
		//			2001/12/24 gestione profili per impostazioni stampante; opzione GAL_GOPT_PROFILE_SELECT
		// 2.20	2001/12/24 --------------------------------------------------------
		//			2001/10/13 aggiunge le funzioni PAGINA_SEZIONE() e TOT_PAGINE_SEZIONE()
		//			01/09/2001 attivata la funzione di stampa condizionale sul singolo oggetto (STAMPA SE ...)
		//			01/09/2001 modificato il sistema di riposizionamento delo objs dopo l'eliminazione di un obj
		//			05/07/2001 possibilità di inserire macro (variabili) nel nome default del file di salvataggio in formato JPG
		// 2.1F	21/06/2001 --------------------------------------------------------
		//			21/06/2001 salvataggio immagini in formato compresso
		// 2.1E	02/05/2001 --------------------------------------------------------
		//			02/05/2001 estensione supporto valute, con differenti tipi di arrotondamento (fissi, max, calcolo)
		// 2.1D	12/03/2001 --------------------------------------------------------
		//			12/03/2001 supporto conversioni di valuta
		//			2001/02/2001 function ABS()
		// 2.1C	2001/01/22 --------------------------------------------------------
		//			2001/01/22 codifica numeri in lettere (1>A, 2>X, 3>K eccetera)
		// 2.1B	2000/11/17 --------------------------------------------------------
		//			2000/11/17 opzione per abilitare/disabilitare l'utilizzo di font sintetizzati (non realmente esistenti) (bo_force_font_exist)
		// 2.1A	2000/10/07 --------------------------------------------------------
		//			2000/10/07 font modificabile via comandi software (bo_switch_fontstyle)
		//			2000/10/07 immagini impostabili a run-time
		//			2000/10/06 parametro JPEG COMPRESSION QUALITY
		//	2.19	2000/08/27 --------------------------------------------------------
		//			2000/08/27 aggiunta funzioni logico-aritmetiche AND(), OR(), XOR()
		//			2000/08/22 spedizione reports via email
		//			2000/08/22 salvataggio immagine report su file JPG
		//			2000/08/22 aggiunti i campi GLOBALE.str_default_image_filename e .str_default_image_filepath
		//			2000/08/22 aggiunte le opzioni GAL_GOPT_SET_EXPORT_PATH e GAL_GOPT_SET_EMAIL_ADDRESS
		//	2.18	2000/08/06 --------------------------------------------------------
		//			2000/08/06 opzione "stampa l'ultima riga di fondo per sezioni e sottosezioni"
		//	2.17	2000/07/26 --------------------------------------------------------
		//			2000/07/26 exportazione dati stampa
		// 2.16	2000/07/10 --------------------------------------------------------
		//			2000/07/10 portato da 7 a 10 il numero max di pagine logiche di un report
		// 2.15	2000/06/10 --------------------------------------------------------
		//			2000/06/10 portato da 4 a 7 il numero max di pagine logiche di un report
		//			2000/05/29 opzione di calcolo valori progressivi (continua a sommare un valore senza mai azzerarlo)
		//			2000/05/12 corretto bug di formattazione testi con spazi e righe vuote (che generavano pagine inutili)
		// 2.14	2000/05/06 rivisitazione delle funzioni di gestione delle etichette
		//			2000/04/14	corretto bug generato dalle differenti versioni di external files (esisteva da ver 2.0D)
		// 2.13	2000/04/05 --------------------------------------------------------
		//			2000/04/05 funzioni MessageBox() e Abort()
		// 2.12	2000/03/31 --------------------------------------------------------
		//			2000/03/31	gestione interlinea per testi che vengono formattati su + righe
		// 2.11	2000/03/14 --------------------------------------------------------
		//			2000/03/14	richiesta di valore parametri a runtime
		// 2.10	2000/03/13 --------------------------------------------------------
		//			2000/03/13	passato da integer a smallint il tipo di PRINT_SETUP()
		// 2.0F	2000/02/24 --------------------------------------------------------
		//			2000/02/24 gestione stampante/cassetti carta specifici per ciascuna pagina logica
		// 2.0E	2000/02/23 --------------------------------------------------------
		//			2000/02/23 gestione dei cassetti della carta
		//			2000/02/23 numero di copie di stampa default
		// 2.0D	2000/02/20 --------------------------------------------------------
		//			2000/02/19 possibilità di stampare pagine logiche con orientamento differente (orizzontale/verticale)
		// 2.0C	2000/02/15 --------------------------------------------------------
		//			2000/02/15 aggiunta la funzione num2str()
		//			2000/02/15 aggiunta la function	GAL_exists_section()
		// 2.0B	2000/01/27 --------------------------------------------------------
		//       2000/01/27 aggiunta la funzione MOD()
		//       2000/01/27 aggiunta la funzione DATA_IN_LETTERE()
		// 2.0A	2000/01/24 --------------------------------------------------------
		//       2000/01/24 aggiunta la funzione GAL_exists_obj()
		// 2.09	2000/01/03 --------------------------------------------------------
		//			2000/01/03 attributo BO_FOOTER: oggetti legati al fondo pagina (design-time)
		//       1999/12/20 passaggio a D4
		// 2.08  1999/12/07 --------------------------------------------------------
		//			1999/12/07 funzione MIN2DAYS()
		//			1999/10/31 possibilità di applicare lo stile 'legami comunitari'
		// 2.07  1999/10/06 --------------------------------------------------------
		//			1999/10/06 parametro lo_print_style:integer alle funzioni: GAL_print(), GAL_open_and_print_method() e GAL_open_and_print_proc()
		//			1999/10/06 funzionalità 'stampa diretta senza anteprima'
		// 2.06	1999/09/27 --------------------------------------------------------
		//       1999/09/27 funzione ZERI()
		//			1999/09/27 l'attributo # di zeri per gli oggetti di testo
		//			1999/09/26 corretto un bug che scambiava il margine sx e quello up per le pagine orizzontali
		// 2.05  1999/08/29 --------------------------------------------------------
		//			bug [comportamento non corretto] espansione di sezioni contenenti
		//				oggetti che non comunicano agli altri la propria variazione di dimensione
		//				la cui posizione non è contenuta nella sezione
		//			disegno automatico cornice e linea di fondo per le sezioni
		// 2.04	1999/08/25 --------------------------------------------------------
		//			1999/08/25 aggiunta della 'condizione di stampa' per singoli oggetti (STR_PRINT_IF); opzione esistente ma non funzionante
		// 2.03	1999/08/09 --------------------------------------------------------
		//			1999/08/09 gestione modalità di visualizzazione per LINEE e CORNICI
		// 2.02	1999/08/08 --------------------------------------------------------
		//			1999/08/08 formati numerici con specificazione di separatore migliaia e decimali
		//	2.01	1999/08/07  *** SALTO ALLA VERSIONE 2, perchè la 1 era quella a 16 bit (Delphi 1.0)
		//			1999/08/07 L2E() e E2L() conversioni da lira ad euro
		// 1.15	1999/07/26 --------------------------------------------------------
		//			script SQL per ogni sezione
		//			funzione GAL_get_version()
		//			funzione STR2SQL() e QUOTEDSTR()
		//			funzione ROUND()
		// 1.14  1999/07/23 --------------------------------------------------------
		//			conserva il colore del font anche per oggetti non abilitati (era un piccolo bug)
		//	1.13  1999/07/06 --------------------------------------------------------
		//			aggiunte le funzioni PUNTATO(), NUMERO() e STRING()
		// 1.12: 1999/03/21 --------------------------------------------------------
		//			oggetto attributi comuni
		// 		posizione fissa degli oggetti nella sezione di appartenenza
		// 1.11: 1999/03/14 --------------------------------------------------------
		//			possibilità di indicare runtime il file grafico associato ad un'immagine
		//			aggiunta proprietà nome alle bitmaps
		// 1.10: 13/03/1999 aggiunto il campo str_remarks ad ogni oggetto; nessuna modifica di formato
		// 1.09: 28/01/1999 aggiunto attributo 'mostra/nascondi oggetti nascosti'
		// 1.08: 18/12/1998 gestione stored procedures (nessuna modifica al formato del file)
		// 1.07: 20/11/1998 aggiunte scripts SQL e spazio per aggiunte future
		// 1.06:	18/10/1998 modifiche nel formato dei reports TEXT ONLY
		// 1.05:	07/08/1998 introduzione pagine logiche esterne condivise da più reports
		// 1.04: 06/08/1998 modificato il metodo di salvataggio bitmaps, con RLE compression
		// 1.03: 17/02/1998 aggiunte 12 stringhe all'intestazione complessiva del file
		// 1.02: 18/11/1997
		// 1.01: 01/03/1997
		// 1.00: VIII-1996
	FIRST_GALATEO_VERSION_WITH_DLL_CHECK = 258;	// versione da cui esiste la funzione GAL_GET_DLL_VERSION() per la verifica della versione DLL

