unit wproc;

{$I defines}
{$ifNdef GALATEO_EXE} *** {$endif}
{$ifdef DLL} *** {$endif}

{ istruzioni per l'uso:
	prima della creazione 		if NOT wx.can_open(father, WT_XXXXXXXX, i_obj.ToString) then exit;
	dopo la creazione				wx.register_window(father, dlg, WINDOW_CLASS, lab.ca.i_numero_obj.ToString);
	FormClose						Action := caFree
	FormDestroy						wx.close_window(self) }

interface

uses Windows, Forms, SYsUtils;

type
	window_type = (WT_BLANK, WT_IMPOSTAZIONI, WT_SECTION_EDIT, WT_LABEL_EDIT, WT_IMAGE_EDIT, WT_GRAPH_EDIT, WT_DATAMATRIX_EDIT);
const
	MAX_OPEN_WINDOWS : array[window_type] of byte = (		// 0 significa DEFAULT_MAX_WINDOWS_PER_CLASS
		0,		//	WT_BLANK,
		1,		// WT_IMPOSTAZIONI,		*
		0,		// WT_SECTION_EDIT,		*
		0,		// WT_LABEL_EDIT,			*
		0,		// WT_IMAGE_EDIT,			*
		0,		// WT_GRAPH_EDIT,			*
		0);	// WT_DATAMATRIX_EDIT); **
{$ifdef DEBUG}
	WINDOW_TYPE_DESCR : array[window_type] of string = (
		'',					//	WT_BLANK,
		'impostazioni',	// WT_IMPOSTAZIONI,
		'section',			// WT_SECTION_EDIT,
		'label',				// WT_LABEL_EDIT,
		'image',				// WT_IMAGE_EDIT,
		'graph',				// WT_GRAPH_EDIT,
		'datamatrix');		// WT_DATAMATRIX_EDIT);
{$endif DEBUG}

type
	cl_window = class
		father, child : TForm;
		tipo : window_type;
		str_item : string;
		constructor create(father, child : TForm;tipo : window_type;str_item : string);
		{$ifdef DEBUG} destructor free; {$endif DEBUG}
	end;
	cl_windows_container = class
		private
			windows : array of cl_window;
			constructor create;
			destructor free;
			function find_window(father : TForm;tipo : window_type;str_item : string) : smallint; overload;
			function find_window(child : TForm) : smallint; overload;
		public
			function register_window(father, child : TForm;tipo : window_type;str_item : string = '') : boolean;
			function close_window(child : TForm) : boolean;
			function can_open(father : TForm;tipo : window_type;str_item : string = '') : boolean;
			function xcount(tipo : window_type = WT_BLANK) : smallint;
			function can_close_application(str_message : string = '';i_max_wait_ms : integer = 0) : boolean;
			function xcheck_count(father : TForm;str_message : string;i_max_count : smallint = 0) : boolean;
	end;

var wx : cl_windows_container;

implementation

uses {$ifdef DEBUG} FMemory, {$endif DEBUG} FMessage, FTime, FSystem, FXstrings,
	Gdich;

const
	DEFAULT_MAX_WINDOWS_PER_CLASS = 4;		// numero max di windows che si possono aprire per la stessa classe

constructor cl_windows_container.create; begin end;
destructor cl_windows_container.free; begin end;

function cl_windows_container.find_window(father : TForm;tipo : window_type;str_item : string) : smallint;
// rende l'indice della finestra, oppure -1 se non esiste
begin
	for result := 0 to high(windows) do
		if (father = windows[result].father) AND (tipo = windows[result].tipo) AND (str_item = windows[result].str_item) then exit;
	result := -1
end;

function cl_windows_container.find_window(child : TForm) : smallint;
// rende l'indice della finestra, oppure -1 se non esiste
begin
	for result := 0 to high(windows) do
		if (windows[result].child = child) then exit;
	result := -1
end;

function cl_windows_container.can_close_application(str_message : string = '';i_max_wait_ms : integer = 0) : boolean;
{ cerca di chiudere tutte le finestre aperte per terminare l'applicazione; rende TRUE se è possibile, FALSE altrimenti;
  tiene bloccata l'applicazione per un max I_MAX_WAIT_MS millisecondi }
const DEFAULT_MAX_MS = 500;
begin
	if (i_max_wait_ms = 0) then i_max_wait_ms := DEFAULT_MAX_MS;
	for var i := xcount-1 downto 0 do windows[i].child.close;
	var dt_start := start_timer;
	while (xcount > 0) AND (delta_timer_msec(dt_start) < i_max_wait_ms) do my_sleep;
	result := (xcount = 0);
	if NOT result AND (str_message <> '') then MessageBBox(application.MainForm, str_message, GALATEO_MBOX_CAPTION, MB_ICONSTOP)
end;

function cl_windows_container.can_open(father : TForm;tipo : window_type;str_item : string = '') : boolean;
begin
	var i := find_window(father, tipo, str_item);
	result := (i = -1);
	if NOT result then begin windows[i].child.BringToFront;exit end;

	var i_max := MAX_OPEN_WINDOWS[tipo];
	if (i_max = 0) then i_max := DEFAULT_MAX_WINDOWS_PER_CLASS;
	if (xcount(tipo) = i_max) then begin
		MessageBBox(father, 'Non è possibile aprire contemporaneamente più di ' + ifs(i_max = 1, 'UNA finestra', i_max.ToString + ' finestre') + ' di questo tipo',
			GALATEO_MBOX_CAPTION, MB_ICONSTOP);
		result := FALSE
	end
end;

function cl_windows_container.xcheck_count(father: TForm; str_message: string; i_max_count: smallint): boolean;
begin
	result := (xcount <= i_max_count);
	if NOT result AND (str_message <> '') then MessageBBox(father, str_message, GALATEO_MBOX_CAPTION, MB_ICONSTOP)
end;

function cl_windows_container.close_window(child : TForm) : boolean;
begin
	var i := find_window(child);
	result := (i <> -1);
	if result then begin
		windows[i].Free;
		if (i <> high(windows)) then move(windows[i+1], windows[i], sizeof(cl_window) * (high(windows) - i));
		setLength(windows, high(windows))
	end
end;

function cl_windows_container.xcount(tipo : window_type = WT_BLANK) : smallint;
begin
	if (tipo = WT_BLANK) then result := length(windows)
	else begin
		result := 0;
		for var i : smallint := 0 to high(windows) do
			if (windows[i].tipo = tipo) then inc(result)
	end
end;

function cl_windows_container.register_window(father, child : TForm;tipo : window_type;str_item : string) : boolean;
begin
	result := (find_window(child) = -1);
	if result then begin
		setLength(windows, length(windows) + 1);
		windows[high(windows)] := cl_window.Create(father, child, tipo, str_item);
	end
end;

{ cl_window }

constructor cl_window.create(father, child : TForm;tipo : window_type;str_item : string);
begin
	{$ifdef DEBUG} track_pointer_add('cl_window', self, WINDOW_TYPE_DESCR[tipo] + '::' + str_item); {$endif DEBUG}
	self.father := father;self.child := child;
	self.tipo := tipo;self.str_item := str_item
end;

{$ifdef DEBUG}
destructor cl_window.free;
begin
	track_pointer_delete('cl_window', self)
end;
{$endif DEBUG}

initialization
	wx := cl_windows_container.create
finalization
	if (wx <> NIL) then begin wx.free;wx := NIL end
end.
