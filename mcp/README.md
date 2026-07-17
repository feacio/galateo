# galateo-mcp

Server MCP che espone le API di authoring di GALATEO.EXE a un LLM.

## Come funziona

```
Claude  <--stdio/MCP-->  galateo-mcp (Node)  <--named pipe + JSON Lines-->  GALATEO.EXE
```

Il server Delphi vive in `../galateo_api.pas` e gira dentro GALATEO.EXE su un thread dedicato.
Le richieste vengono marshallate sul main thread con `TThread.Synchronize` perche' gli oggetti del
report SONO controlli VCL: non si toccano da un thread secondario.

Protocollo: una richiesta JSON per riga, una risposta JSON per riga, UTF-8.

- richiesta: `{"cmd":"report.describe","args":{...}}`
- risposta : `{"ok":true,"result":{...}}` oppure `{"ok":false,"error":"...","error_class":"..."}`

Un errore applicativo torna sempre come dato, mai come eccezione o messagebox: GALATEO non deve
fermarsi ad aspettare un umano che non c'e'.

## Le API sono accese di default

GALATEO viene lanciato spesso da JOLLY su un report gia' aperto, e in quel caso la riga di comando
non la scriviamo noi: per questo il server parte da solo, senza bisogno di alcun parametro.

```
GALATEO.EXE report.gal                     API attive (default)
GALATEO.EXE report.gal /NOAPI                 API spente
GALATEO.EXE report.gal /API:nome_mio          nome pipe imposto
```

## Una pipe per istanza

Ogni GALATEO ascolta su `\\.\pipe\galateo_api_<pid>`.

Non e' un dettaglio: con un solo nome di pipe condiviso, `CreateNamedPipe` con
`PIPE_UNLIMITED_INSTANCES` lascia che **piu' processi creino istanze dello stesso nome**, e Windows
assegna il client a una qualsiasi fra quelle libere. Misurato con due GALATEO aperti: le connessioni
si alternavano fra i due a giro. Un LLM avrebbe letto un report e scritto sull'altro, senza che
nessuno se ne accorgesse -- e in GALATEO l'undo non esiste.

Il client enumera `\\.\pipe\` cercando il prefisso `galateo_api_`:

- nessuna istanza -> errore che dice di avviare GALATEO
- una sola       -> scelta automatica
- piu' d'una     -> il comando **rifiuta** e elenca pid + report; tocca passare `instance` col pid

La variabile d'ambiente `GALATEO_PIPE` scavalca tutto e impone un nome di pipe.

## Build

```
npm install
npm run build
```

## Registrazione in Claude Code

```
claude mcp add galateo --scope user -- node E:\DX13\GALATEO\mcp\dist\index.js
```

## Comandi esposti

| tool MCP                  | cmd sulla pipe    | scrive? |
|---------------------------|-------------------|---------|
| `galateo_instances`       | `ping` su ciascuna pipe trovata | no |
| `galateo_ping`            | `ping`            | no      |
| `galateo_report_describe` | `report.describe` | no      |
| `galateo_page_activate`   | `page.activate`   | no (sposta solo il cursore di vista) |
| `galateo_object_move`     | `object.move`     | si'     |

### Perche' `object.move` lavora solo sulla pagina attiva

Non e' una scorciatoia. `on_change_size_and_pos` chiama `check_resize_all`, che applica le azioni
comunitarie usando l'indice dell'oggetto **sulla pagina attiva**: agire su un'altra pagina
trascinerebbe gli oggetti sbagliati, e nessuno se ne accorgerebbe. Da qui `page.activate` come
comando separato.

### Indirizzare per nome: due trappole

I nomi degli oggetti sono univoci **solo dentro la pagina**, non nel report, e le label di testo
statico possono non avere nome affatto. `trova_oggetto` quindi scandisce da se' tutte le pagine
invece di usare l'overload di `name2index` che cerca "prima nella pagina attiva, poi nelle altre":
quello, davanti a due omonimi legali, ne sceglierebbe uno in silenzio. Un nome ambiguo viene rifiutato.

### `object.move` rende l'oggetto com'e' RIMASTO

Non come lo si e' chiesto. `check_size` e `check_pos_in_section` correggono i valori, e le posizioni
vivono in pixel video: i centimetri si quantizzano nel giro di andata e ritorno (chiesto 5.633,
ottenuto 5.636). Il client deve leggere la risposta.

## Nota su read_parms (proc.pas)

`read_parms` scarta i parametri che iniziano per `/A` e tratta **qualunque altra cosa come il nome
del file da aprire**. Un parametro sconosciuto quindi non viene ignorato: fa comparire la modale
"E' possibile specificare un solo nome di file da aprire" e il report **non viene caricato affatto**.
Per questo `/NOAPI` e' gestito esplicitamente li' dentro. Chi aggiunge parametri nuovi a GALATEO deve
ricordarsene.

## La rete di sicurezza: l'API non salva mai

In GALATEO non esiste un undo: niente stack, niente command pattern. Ma una rete c'e' gia', ed e'
`TGM.FormCloseQuery` (`galateo_main.pas`): se `bo_modified` e' TRUE, chiudendo GALATEO compare
"Vuoi salvare le modifiche?", e rispondere NO butta via tutto.

Quindi la regola e': **ogni mutazione alza `GM.bo_modified`, e l'API non scrive mai su disco.** A
salvare o a buttare via decide l'utente, con codice esercitato da anni. Costo: zero righe nuove.

Uno snapshot/restore resterebbe utile -- annullare *una parte* delle modifiche invece di tutte -- ma
si paga caro: `TGlobale.save` ha sette gate interattivi (firma, conferma versione, sola lettura,
fallimento del `.BAK`, ...) e per giunta muta il modello anche quando riesce (`wo_versione_read`,
`bo_saved_debug`, `obj_select(0)`), che e' esattamente cio' che una rete di sicurezza non deve fare.
Non conviene pagarlo prima che la superficie di scrittura abbia preso una forma.

Per la stessa ragione `report.save` non e' esposto.
