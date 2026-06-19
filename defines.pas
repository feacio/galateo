{$I e:\DX13\defines}

{$ifNdef DEBUG} {$define DEBUGURGENTE} {$endif}

{*$define GALATEO_SYSTEM_DEBUG}		// attiva la modalità di debugging di sistema (utile per intercettare eventi INITIALIZATION e FINALIZATION e altri eventi di sistema)
{$ifNdef DEBUG} {$ifdef GALATEO_SYSTEM_DEBUG} *** {$endif} {$endif}

{$ifndef DEBUG} { $define PROVA_FAST}	{$endif}		 // velocifica certe units in caso di debug
{$ifdef DEBUG} { $define CHECK_SECTIONS} {$endif}

{ $define OLD_LABEL}		// vecchio modello di labels
{$define PDF}	// attiva la possibilità di exportazione su PDF (ma comunque necessita di permesso da parte del programma che chiama la DLL)

//	{$ifndef GALATEO} *********** devi definire GALATEO, e forse anche DLL (per CASA.DLL) {$endif}

{$define CONSENTI_WRONG_SIZES}	// consente impostazioni di stampa che superino la dimensione fisica della pagina

{ $define JOLLY}
{$define CASA_DLL}	// viene usata la DLL casa da un programma esterno (non JOLLY)
{ $define SISTEL}
{ $define CASTELLI}
{ $define SIGNORI}
{ $define SONZOGNI}
{ $define MRS}
{ $define HANDY}
{ $define SCALVINA}
{ $define CLAUDIA}

{$ifdef JOLLY}
	{$define REPORT_GENERATOR}		// generatore di prospetti per DLL; imposta solo defaults differenti dal caso opposto
	{$define PROFESSIONALE}
	{$define SOLD_BY_SISTEL}
{$endif}

{$ifdef CASA_DLL}
	{$define REPORT_GENERATOR}		// generatore di prospetti per DLL; imposta solo defaults differenti dal caso opposto
	{$define PROFESSIONALE}
	{*$define SOLD_BY_SISTEL}
{$endif}

{$ifdef MRS} {$define PROFESSIONALE}	{$define SOLD_BY_SISTEL} {$endif}
{$ifdef SCALVINA} {$define PROFESSIONALE}	{$define SOLD_BY_SISTEL} {$endif}

{$ifdef SIGNORI} {$define RUBRICA} {$endif}
{$ifdef HANDY} {$define RUBRICA} {$endif}

