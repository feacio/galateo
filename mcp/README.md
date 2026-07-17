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

Per ora la superficie e' di sola lettura.

## Nota su read_parms (proc.pas)

`read_parms` scarta i parametri che iniziano per `/A` e tratta **qualunque altra cosa come il nome
del file da aprire**. Un parametro sconosciuto quindi non viene ignorato: fa comparire la modale
"E' possibile specificare un solo nome di file da aprire" e il report **non viene caricato affatto**.
Per questo `/NOAPI` e' gestito esplicitamente li' dentro. Chi aggiunge parametri nuovi a GALATEO deve
ricordarsene.

## Prima di aggiungere comandi di scrittura

Due vincoli noti, non ancora risolti:

1. **In GALATEO non esiste un undo.** Non c'e' stack, non c'e' command pattern. L'unica rete e' il
   `.~GAL` scritto al salvataggio. Prima di far scrivere un LLM va costruito uno snapshot/restore.
2. **`TGlobale.save` e' interattivo**: chiede la firma e la conferma della versione. Serve un
   percorso di salvataggio silenzioso prima di poter esporre `report.save`.
