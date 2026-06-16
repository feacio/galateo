e:\d6\galateo\fatti.pas

	al passaggio del mouse su un oggetto fare HINT riepilogativo sulle proprietà dell'oggetto (tipo oggetto, field/formula SQL, ...)
	tasto funzione per andare all'iniozio della sezione successiva (CTRL+DOWN o qualcosa di simile)

	ricerca:
		RUN-TIME: ricerca testo su indice/su report
		EDIT-TIME: dialog di ricerca oggetti per nome: COMBO con TUTTI gli oggetti del report/pagina/sezione e bottone GOTO (che seleziona l'oggetto)

	sezione_edit, bottone per mostrare solo oggetti grafici su USA POSIZIONE, SPESSORE E LARGHEZZA
	apertura file in TEXTPAD (per ricercare testo in modo brutale) e successiva rilettura in Galateo
	opzione per dire di splittare una stringa su MAX n righe (oppure su max XX centimetri)
	mettere un comando per ridurre una sezione alla sua DIMENSIONE MINIMA (rispetto alla sottosezione)
	mostrare sulla barra degli strumenti (come Word) i parametri di formattazione degli oggetti di testo: Arial, dimensione, allineamento, grassetto, corsivo, ....
	il file e:\d6\galateo\errori\inventario-00 viene stampato senza eliminare i campi vuoti; giocando un po' sui campi si risolve il problema; si tratta evidentemente di un bug, da identificare e sistemare
	se un oggetto è a dimensione automatica, il bottone (barra strumenti) allinea a dx non funziona
	export integrale su XLS su un numero con decimali; se formato con il separatore decimale = PUNTO fa casino !!!!!!!!!!!; bisognerebbe utilizzare il separatore decimale corretto a prescindere dalle impostazioni del campo (ma usare invece le impostazioni di sistema)
	eseguire un controllo all'avvio di galateo per verificare che l'operatore abbia sufficienti diritti per eseguire il report (esempio: inventari, archivio articoli, ....)

	possibilità di ridimensionare finestra runtime parametri galateo
	fare finestra per elencare al volo l'elenco dei nomi degli oggetti disponibili, con eventuali filtri per tipo di oggetto/pagina/....
?	DIFFERENTI PROFILI DI esportazione integrale (comprensivi di: set default di pagine da exportare, default-target: clipboard, textfile, ...)
	reimpostare collegamenti con GALATEO when not administrator
	possibilità di caricare le macro ex file esterno (comune a più reports)
	utilizzare un formato di carta predefinito (oltre alla stampante/cassetto)
	perchè certi formati non sono accessibili a certe stampanti???
	possibilità di disabilitare i controls nella finestra runtime (in funzione dei valori inseriti)
	attivare possibilità di nascondere parametro runtime (come è già possibile disabilitarlo)
	in caso di oggetto disabilitato evitare i controlli di merito (can be blank/ cannot/ ...)

	per evitare problemi di caratteri strani nei commenti: in esecuzione evitare la lettura delle righe che iniziano con //
	far leggere ad Explorer il titolo della stampa
	sugli errori runtime mettere nome computer e nome utente, e tutto quanto potrebbe essere utile, versione database, versione programma, data creazione, nome del file del report ..............
	manina che sposta il preview come ACROBAT
	se stampo una sezione di secondo livello su più pagine, l'opzione 'STAMPA/NASCONDI SULLA PRIMA/ULTIMA PAGINA' non funziona
		esempio: CABERG *** E:\D6\HELM\prelievo\stampe\disponibilita\disponibilita-mmag-00.gal, campi giacenza sulla sezione GB_1
	RUNT_PARM: maxlen: se disabilitato non assegnarlo, o alla rovescia
	opzione per segnalare i campi non completamente stampati ma assolutamente obbligatori (esempio: NUMERO DI FATTURA, IMPORTO, ...)
	castelli, fattura immediata 07/0089, la riga delle SCADENZE non viene eliminata anche se blank!!!!!!!!!!!

	un-lockare le transazioni di galateo ASAP
?	mettere le windows come CHILD della finestra che le ha chiamate (si intende: nel programma chiamante)
	se ho una macro sbagliata (non definita) nel SELECT di una sezione, non mi dice dove è l'errore
?	EDIT-TIME	sistemare selezione sezione errata (un solo click non basta, ne servono due (singoli))
GALATEO
	impedire selezione finestra anteprima
	caricare CASSETTI su stampante predefinita
	descrizione BDOC stampe MRS non visibile (2004-10-13, ad esempio su COMM-PROD)
	parametri DOC_CASCO_COLOR: il secondo parametro è fuori sincrono (provare per credere)

GALATEO: jolly-federico, se inserisco un articolo con la seguente descrizione fa casino in stampa
06/10 e 08/10 (2+2 ore, riunione con sig. Prussiani per analisi reports e problemi ore lavorative)
17/10 (3 ore, modifica stampe badge)
20/10 (2 ore, analisi procedura registrazione lavorazioni tecnici)
28/10 (1 ora, incontro con sig. Prussiani, modifica algoritmo gestione badge, prova touch screen)
03/11 (1 ora, verifica e modifica algoritmo badge con Massimo)
04/11 (1 ora, installazione modifiche algoritmo badge)
11/11 (2 ore, installazione nuove commesse di produzione)
14/11 (1 ora, messa a punte stampe commesse)
19/11 (1 ora, installazione procedura di generazione documenti di lavorazione)
25/11 (2 ore, installazione touch screen)
26/11 (2 ore, riconversione vecchi documenti: trasferte, garanzie, ...)
27/11 (1 ore, messa a punto touch screen)
28/11 (1 ora, incontro sig. Prussiani, presentazione report costi macchina)

