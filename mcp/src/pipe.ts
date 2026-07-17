import fs from "node:fs";
import net from "node:net";

/* Devono combaciare con API_PIPE_ROOT / API_PIPE_BASE in galateo_api.pas */
export const PIPE_DIR = "\\\\.\\pipe\\";
export const PIPE_PREFIX = "galateo_api_";

interface GalateoResponse {
	ok: boolean;
	result?: unknown;
	error?: string;
	error_class?: string;
}

export interface Instance {
	pipe: string;
	pid: number;
	filename?: string;
	reportLoaded: boolean;
}

export class GalateoError extends Error {
	readonly errorClass?: string;
	constructor(message: string, errorClass?: string) {
		super(message);
		this.name = "GalateoError";
		this.errorClass = errorClass;
	}
}

/*
 * Una richiesta, una connessione.
 * Il server Delphi apre la pipe con PIPE_UNLIMITED_INSTANCES e il protocollo e' JSON Lines,
 * quindi una connessione usa-e-getta per chiamata tiene questo client senza stato e immune
 * a un socket rimasto appeso dopo un riavvio di GALATEO.
 */
export function galateoCall(
	cmd: string,
	args: Record<string, unknown> | undefined,
	pipeName: string,
	timeoutMs = 20000
): Promise<unknown> {
	return new Promise((resolve, reject) => {
		const socket = net.connect({ path: pipeName });
		let buf = "";
		let settled = false;
		const LF = String.fromCharCode(10);

		const finish = (fn: () => void) => {
			if (settled) return;
			settled = true;
			socket.destroy();
			fn();
		};

		socket.setTimeout(timeoutMs, () =>
			finish(() =>
				reject(
					new GalateoError(
						`nessuna risposta entro ${timeoutMs}ms al comando "${cmd}". ` +
							`GALATEO potrebbe avere una finestra modale aperta in attesa di te.`
					)
				)
			)
		);

		socket.on("error", (e: NodeJS.ErrnoException) =>
			finish(() => reject(new GalateoError(describeSocketError(e, pipeName))))
		);

		socket.on("connect", () => {
			const payload = args === undefined ? { cmd } : { cmd, args };
			socket.write(JSON.stringify(payload) + LF, "utf8");
		});

		socket.on("data", (chunk: Buffer) => {
			buf += chunk.toString("utf8");
			const nl = buf.indexOf(LF);
			if (nl < 0) return;
			const line = buf.slice(0, nl).trim();
			finish(() => {
				let resp: GalateoResponse;
				try {
					resp = JSON.parse(line) as GalateoResponse;
				} catch {
					reject(new GalateoError(`risposta non JSON da GALATEO: ${line.slice(0, 200)}`));
					return;
				}
				if (!resp.ok) {
					reject(new GalateoError(resp.error ?? "errore sconosciuto", resp.error_class));
					return;
				}
				resolve(resp.result);
			});
		});

		socket.on("end", () =>
			finish(() =>
				reject(new GalateoError(`GALATEO ha chiuso la connessione senza rispondere a "${cmd}"`))
			)
		);
	});
}

function describeSocketError(e: NodeJS.ErrnoException, pipeName: string): string {
	if (e.code === "ENOENT") return `nessun GALATEO in ascolto su ${pipeName}`;
	return `${e.code ?? "errore"} sulla pipe ${pipeName}: ${e.message}`;
}

/* Ogni GALATEO espone la propria pipe, col PID nel nome. Enumerare la directory delle pipe
   e' l'unico modo per sapere chi c'e': non esiste un registro. */
export function listPipes(): string[] {
	try {
		return fs.readdirSync(PIPE_DIR).filter((p) => p.toLowerCase().startsWith(PIPE_PREFIX));
	} catch {
		return [];
	}
}

export async function listInstances(): Promise<Instance[]> {
	const out: Instance[] = [];
	for (const name of listPipes()) {
		const pipe = PIPE_DIR + name;
		try {
			const r = (await galateoCall("ping", undefined, pipe, 5000)) as {
				pid: number;
				filename?: string;
				report_loaded?: boolean;
			};
			out.push({ pipe, pid: r.pid, filename: r.filename, reportLoaded: !!r.report_loaded });
		} catch {
			/* istanza che sta chiudendo, o una pipe orfana: la salto invece di far fallire l'elenco */
		}
	}
	return out.sort((a, b) => a.pid - b.pid);
}

export function describeInstances(inst: Instance[]): string {
	return inst.map((i) => `pid ${i.pid} -> ${i.filename ?? "(nessun report aperto)"}`).join("; ");
}

/*
 * Sceglie su quale GALATEO lavorare.
 * Con piu' istanze aperte NON si indovina: Windows assegnerebbe il client a una qualsiasi, e con
 * l'undo inesistente un errore qui vuol dire un report altrui corrotto in silenzio.
 */
export async function resolvePipe(pid?: number): Promise<string> {
	const forced = process.env.GALATEO_PIPE;
	if (forced) return forced;

	const inst = await listInstances();
	if (inst.length === 0)
		throw new GalateoError(
			"nessun GALATEO in ascolto. Avvia GALATEO.EXE: le API sono attive di default."
		);

	if (pid !== undefined) {
		const hit = inst.find((i) => i.pid === pid);
		if (!hit)
			throw new GalateoError(
				`nessuna istanza col pid ${pid}. Aperte adesso: ${describeInstances(inst)}`
			);
		return hit.pipe;
	}

	if (inst.length === 1) return inst[0]!.pipe;

	throw new GalateoError(
		`ci sono ${inst.length} GALATEO aperti, devi dire su quale lavorare passando "instance" col pid. ` +
			`Aperte adesso: ${describeInstances(inst)}`
	);
}
