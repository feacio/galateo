NOTE di funzionamento di galateo

formato IF:
	IF( predicato;valore se TRUE;valore se FALSE)

BUGS NOTI:
	Sezione con sottosezione, la sottosezione viene stampata prima della sezione (è sopra); se
	un campo della sezione è di tipo 'STAMPA SOLO ALLA FINE DEL RECORD' può essere stampato sballato
	(più sotto di quanto dovrebbe); il motivo è che inizialmente viene considerato da non stampare e
	la sua posizione non viene perciò ricalcolata in funzione degli altri oggetti, mentre alla fine
	dei conti magari deve essere veramente stampato

HINTS
Aprendo un documento con uno shift schiacciato, viene disabilitata l'opzione di tabulazione verticale
Per attivare il runtime debbuging schiacciare
	SHIFT+CONTROL per informazioni standard
	SHIFT+CONTROL+ALT per informazioni estese

Nelle funzioni, nelle espressioni SQL e in ogni altro punto in cui si voglia far
assumere ad un oggetto il valore di una variabile, specificare la variabile
facendola precedere dal nome della sezione in cui è contenuta.
Esempio:     GB_1.str_codice    oppure DETTAGLIO.str_descr

CASA.DLL
Per chiamare le funzioni di CASA.DLL includere la unit PRINTLNK e chiamare le funzioni necessarie.
E' necessario fornire una funzione di CALLBACK del tipo
che viene richiamata da CASA.DLL durante la stampa per effettuare un setup
specifico e particolareggiato della stampa in corso.
NB: Nella callback function NON USARE TRY ... EXCEPT perchè genera errori. (vero anche in D2?)

Battere INVIO per accedere alle proprietà dell'oggetto selezionato
ALT+INVIO per i legami comunitari

Le SQL_GROUP_FUNCTION vengono sempre riferite alla sezione figlia di quella cui appartengono;
specificare solamente l'espressione SQL; esempio:    SUM(fl_costo*fl_qta)
Dato che si tratta comunque di una richiesta che viene effettuata al database,
nell'espressione si possono utilizzare solamente i campi database, e non le variabili di Galateo.

Gli SQL SCRIPTS sono comandi SQL che vengono impartiti prima dell'esecuzione della stampa.
Per referenziare variabili o parametri in uno script scriverne il nome direttamente, senza $ o altri simboli

STORED PROCEDURES:
	per utilizzare stored procedures:
		* definire la stored proc nella finestra IMPOSTAZIONI
		* utilizzarla come una qualsiasi funzione
		* l'ultimo dei parametri diventa anche il risultato della stored proc
		* l'ultimo parametro è definito come INOUT, tutti gli altri come IN
Se si desidera inserire una virgola in un parametro, il parametro deve essere compreso tra \# e \#

--------------------------------------------------------------------------------

FUNZIONAMENTO DELL'ALGORITMO DI STAMPA
La stampa è divisa in preparazione ed esecuzione.
La PREPARAZIONE avviene ad opera della procedure cl_sezione.impagina() che si occupa
di formattare le diverse pagine e caricare le strutture dati necessarie.
La stampa vera e propria (a video o su printer) viene poi eseguita da cl_print_page.print_page()

Durante la formattazione viene generata una CL_PRINT_PAGE per ogni pagina fisica da stampare.
Ogni CL_PRINT_PAGE contiene una o piu' CL_PRINT_SECTION, che contengono le informazioni sulle sezioni
da stampare per ogni pagina fisica.
Ogni sezione contiene un set di record di dati (ma sulla sezione principale non è necessario,
poichè in questo caso si può dare il caso di stampa incondizionata) che vengono caricati
pre-digeriti sulla struttura recs : cl_print_campo
Quando la query associata ad ogni sottosezione (come anche alle sezioni principali) contengono più d'un record,
si troveranno più CL_PRINT_SECTION consecutivi relativi alla stessa sezione, ciascuno dei quali
caricato con i dati di uno dei records.

GESTIONE SHIFTING DELLA POSIZIONE DEGLI OGGETTI
Se un oggetto cambia la sua altezza, e gli opportuni flag (sull'oggetto e sulla
sezione) sono attivati, gli oggetti sottostanti vengono opportunamente shiftati.
La gestione dello shifting avviene attraverso la classe cl_section_print_objects.
Attraverso il metodo set_deltay_cm() si comunica l'eventuale variazione di altezza
per ogni oggetto (il valore si riferisce all'oggetto stesso, non ha nulla a che
fare con le eventuali variazioni di altezza di altri oggetti).
I metodi get_deltay_...() consentono di reperire, in funzione di differenti
oggetti e posizioni, il valore dello shiftamento.

--------------------------------------------------------------------------------

Oltre alla normale funzione di callback specifica per ogni stampa, è possibile passare
via SET_UNIVERSAL_CALLBACK() una funzione che viene richiamata per ogni stampa eseguita.
E' utilissima per implementare procedure generati di impostazione delle stampe.
Viene richiamata DOPO aver richiamato la callback function specifica per ogni stampa,

--------------------------------------------------------------------------------

CALCOLO E PRECEDENZE DI CALCOLO E DI ASSEGNAZIONE DEI VALORI

L'assegnazione dei valori ed il calcolo delle formule degli oggetti avviene secondo la
seguente sequenza:
	SEZIONE PADRE
	SEZIONE FIGLIA
	SEZIONE NIPOTE
	....

All'interno  della stessa sezione:
	PARAMETRI
	VARIABILI
	GROUP BY
	SCRIPTS PER LA SEZIONE
	ESPRESSIONI SQL
	FORMULE
All'interno della stessa categoria la sequenza è posizionale.
Per verificare (e modificare) la sequenza di calcolo (all'interno della stessa
categoria di oggetti, e la cosa serve praticamente solo per le formule) aprire
l'elenco degli oggetti (F12).

--------------------------------------------------------------------------------

