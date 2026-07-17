#!/usr/bin/env node
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import { GalateoError, galateoCall, listInstances, resolvePipe } from "./pipe.js";

const MODELLO = `Modello di GALATEO:
- un report ha da 1 a 12 PAGINE LOGICHE.
- ogni pagina ha da 1 a 5 SEZIONI annidate ad albero. Ogni sezione ha una SELECT SQL che la pilota;
  la sezione con father=0 e' la principale, una sezione figlia si ripete per ogni riga della sua query.
- ogni pagina ha fino a 400 OGGETTI, ciascuno dentro una sezione. obj_type vale LABEL_OBJ (testo o
  formula), OBJ_BITMAP (immagine), OBJ_RECT, OBJ_LINE, DATAMATRIX_OBJ (barcode).
- var_type dice cosa produce un oggetto: TV_STATIC_TEXT testo fisso, TV_DB_FIELD campo della query,
  TV_PARAMETRO parametro passato dall'esterno, TV_FORMULA formula, TV_SQL_* select dedicata.
- le posizioni (left_cm, top_cm, width_cm, height_cm) sono in CENTIMETRI, relative alla sezione.
- print_if e' una condizione: l'oggetto si stampa solo se e' vera.

IMPORTANTE: identifica sempre un oggetto per 'name', mai per 'index'. Cancellare un oggetto compatta
l'array e rinumera tutti quelli successivi, quindi gli indici non sono stabili tra una chiamata e l'altra.
I nomi sono univoci solo DENTRO una pagina, non nel report: se lo stesso nome esiste su due pagine i
comandi rifiutano invece di scegliere. Le label di testo statico possono non avere nome affatto, e in
quel caso non sono raggiungibili per nome.

La PAGINA ATTIVA e' un cursore globale implicito: i comandi che modificano un oggetto lavorano solo
sulla pagina attiva. Se l'oggetto sta su un'altra pagina, attivala prima con galateo_page_activate.`;

const NIENTE_UNDO = `In GALATEO NON esiste un undo. Le modifiche restano in memoria e l'API non salva mai
su disco: a salvare o a buttare via decide l'utente, rispondendo al "Vuoi salvare le modifiche?" alla
chiusura di GALATEO. Non dire mai all'utente che una modifica e' stata salvata.`;

const ISTANZA = `Possono esserci piu' GALATEO aperti insieme, ciascuno con un report diverso. Se ce n'e'
uno solo viene scelto da se'; se ce ne sono di piu' devi passare 'instance' col pid, che trovi con
galateo_instances. Non tirare a indovinare: scrivere sul report sbagliato non e' annullabile.`;

const server = new McpServer({ name: "galateo", version: "0.3.0" });

const instanceArg = {
	instance: z
		.number()
		.int()
		.optional()
		.describe("PID del GALATEO da pilotare. Serve solo se ne hai piu' di uno aperto.")
};

async function run(cmd: string, pid?: number, args?: Record<string, unknown>) {
	try {
		const pipe = await resolvePipe(pid);
		const result = await galateoCall(cmd, args, pipe);
		return { content: [{ type: "text" as const, text: JSON.stringify(result, null, 2) }] };
	} catch (e) {
		const msg = e instanceof GalateoError ? e.message : String(e);
		return {
			isError: true,
			content: [{ type: "text" as const, text: `GALATEO ha rifiutato "${cmd}": ${msg}` }]
		};
	}
}

server.registerTool(
	"galateo_instances",
	{
		title: "Elenca i GALATEO aperti",
		description:
			`Elenca le istanze di GALATEO.EXE in ascolto, con il pid e il report aperto in ciascuna. ` +
			`Usalo quando un altro comando ti dice che ce n'e' piu' di una, o per sapere su cosa stai lavorando.`,
		inputSchema: {}
	},
	async () => {
		const inst = await listInstances();
		if (inst.length === 0)
			return {
				content: [
					{
						type: "text" as const,
						text: "Nessun GALATEO in ascolto. Avvia GALATEO.EXE: le API sono attive di default."
					}
				]
			};
		return { content: [{ type: "text" as const, text: JSON.stringify(inst, null, 2) }] };
	}
);

server.registerTool(
	"galateo_ping",
	{
		title: "Verifica che GALATEO risponda",
		description:
			`Verifica che un GALATEO sia raggiungibile. Rende la versione del protocollo, il pid, la pipe e ` +
			`il report aperto. Usalo per primo se un altro comando fallisce.

` + ISTANZA,
		inputSchema: instanceArg
	},
	async ({ instance }) => run("ping", instance)
);

server.registerTool(
	"galateo_report_describe",
	{
		title: "Descrivi il report aperto",
		description:
			`Restituisce la struttura completa del report aperto in GALATEO: nome del file, se e' stato
modificato, pagina e sezione attive, e per ogni pagina logica l'elenco delle sezioni (con la loro SQL
e la loro gerarchia) e degli oggetti (con tipo, posizione in cm, formula, espressione SQL).

` +
			MODELLO +
			`

` +
			ISTANZA,
		inputSchema: instanceArg
	},
	async ({ instance }) => run("report.describe", instance)
);

server.registerTool(
	"galateo_page_activate",
	{
		title: "Attiva una pagina logica",
		description:
			`Rende attiva una pagina logica del report. Serve prima di modificare un oggetto che non sta
sulla pagina attualmente attiva: la pagina attiva e' un cursore globale e i comandi di modifica
lavorano solo su di essa.

Non e' una modifica al report ma uno spostamento di vista: non sporca il documento.

` + ISTANZA,
		inputSchema: {
			page: z.number().int().min(1).describe("Numero della pagina logica da attivare (1 = la prima)."),
			...instanceArg
		}
	},
	async ({ page, instance }) => run("page.activate", instance, { page })
);

server.registerTool(
	"galateo_object_move",
	{
		title: "Sposta o ridimensiona un oggetto",
		description:
			`Sposta e/o ridimensiona un oggetto del report, indicandolo per nome. Le misure sono in
CENTIMETRI e relative alla sezione che contiene l'oggetto. Passa solo i campi che vuoi cambiare:
quelli che ometti restano come sono. Serve almeno un campo fra left_cm, top_cm, width_cm, height_cm.

Rende l'oggetto COM'E' RIMASTO, non come l'hai chiesto: GALATEO impone dimensioni minime e vieta a un
oggetto di uscire dalla propria sezione, quindi i valori possono venire corretti. Leggi la risposta
invece di dare per scontato che sia andata come volevi.

Attenzione agli effetti a distanza: se l'oggetto ha delle "azioni comunitarie", spostarlo trascina
anche gli oggetti legati a lui. Rileggi con galateo_report_describe se devi esserne sicuro.

` +
			NIENTE_UNDO +
			`

` +
			ISTANZA,
		inputSchema: {
			name: z.string().min(1).describe("Nome dell'oggetto da spostare. Case-insensitive."),
			left_cm: z.number().optional().describe("Nuova distanza dal bordo sinistro della sezione, in cm."),
			top_cm: z.number().optional().describe("Nuova distanza dal bordo superiore della sezione, in cm."),
			width_cm: z.number().optional().describe("Nuova larghezza, in cm."),
			height_cm: z.number().optional().describe("Nuova altezza, in cm."),
			...instanceArg
		}
	},
	async ({ name, left_cm, top_cm, width_cm, height_cm, instance }) => {
		const args: Record<string, unknown> = { name };
		if (left_cm !== undefined) args.left_cm = left_cm;
		if (top_cm !== undefined) args.top_cm = top_cm;
		if (width_cm !== undefined) args.width_cm = width_cm;
		if (height_cm !== undefined) args.height_cm = height_cm;
		return run("object.move", instance, args);
	}
);

const transport = new StdioServerTransport();
await server.connect(transport);
