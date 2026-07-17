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
l'array e rinumera tutti quelli successivi, quindi gli indici non sono stabili tra una chiamata e l'altra.`;

const ISTANZA = `Possono esserci piu' GALATEO aperti insieme, ciascuno con un report diverso. Se ce n'e'
uno solo viene scelto da se'; se ce ne sono di piu' devi passare 'instance' col pid, che trovi con
galateo_instances. Non tirare a indovinare: scrivere sul report sbagliato non e' annullabile.`;

const server = new McpServer({ name: "galateo", version: "0.2.0" });

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
			`il report aperto. Usalo per primo se un altro comando fallisce.\n\n` + ISTANZA,
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
			`\n\n` +
			ISTANZA,
		inputSchema: instanceArg
	},
	async ({ instance }) => run("report.describe", instance)
);

const transport = new StdioServerTransport();
await server.connect(transport);
