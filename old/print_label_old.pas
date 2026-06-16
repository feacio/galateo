unit print_label_old;	//* procedure di stampa delle etichette old-style (galateo 1.0 win95)

{$I defines}

interface

uses Windows, StdCtrls, SysUtils,
	Printers_DX;

procedure stampa(printer : TFPrinter;handle : HWND;i_numero_copie : integer;
	var i_last_label_printed : integer;var lo_totale_labels : integer;
	bo_msgs : boolean;var bo_stop : boolean;var bo_ask_incorrect : boolean);

const
	MBOX_MSG_RESET_PRINT_QUESTION = 'Vuoi cancellare le etichette che sono già state stampate virtualmente ma non fisicamente?';
	MBOX_MSG_FF_PRINT_QUESTION =
		{$ifdef PROFESSIONALE}
			'Vuoi emettere il foglio che è rimasto nella stampante?'
		{$else}
			'Vuoi sputare il foglio che è rimasto nella stampante?'
		{$endif};
	MBOX_MSG_CANT_EXIT_PRINT =
		{$ifdef PROFESSIONALE}
			'Per uscire devi emettere il foglio (o annullare la coda di stampa)'
		{$else}
			'Per uscire devi sputare il foglio (o annullare la coda di stampa)'
		{$endif};

implementation

uses Fcommons, FXStrings, FStrings, FMessage, FSystem,
	galateo_debug, Gdich, objects, misure, working, pages;

var lo_print_number : integer;

procedure stampa(printer : TFPrinter;handle : HWND;i_numero_copie : integer;
	var i_last_label_printed : integer;var lo_totale_labels : integer;
	bo_msgs : boolean;var bo_stop : boolean;var bo_ask_incorrect : boolean);
{ il processo chiamante potrà modificare il valore di BO_STOP (inizialmente FALSE)
  per indicare durante la stampa che questa deve essere interrotta;
  if (BO_ASK_INCORRECT) then chiede conferma per eventuali scorrettezze della
  stampa (dimensioni della pagina fisica scorrette, and so on); dopo l'eventuale
  richiesta BO_ASK_INCORRECT viene impostato a FALSE }

	procedure stampa_label(x0,y0 : integer);
	// stampa completa di una singola etichetta
	var
		i,j : i_obj_index_type;
		x1,y1,y_min,i_min : int_pixel_type;
		clpr : TRect;	// clipping rectangle
		printed : set of byte;
		i_delta_y : int_pixel_type;
			{ I_DELTA_Y serve per quando un oggetto di testo viene stampato su più righe, e gli altri
			  slittano conseguentemente verso il fondo }
		i_max_y_pixel : int_pixel_type;	// non serve a nulla qui
	begin
		printed := [];i_delta_y := 0;
		with Printer do with tm do begin
			x1 := x0 + cm2pixel_print_x(get_label_size_X_cm);
			y1 := y0 + cm2pixel_print_y(get_label_size_Y_cm);
			clpr.Left := x0;clpr.Top := y0;clpr.Right := x1;clpr.Bottom := y1;

			// stampo tutti i controls a partire dal più in alto verso quello più in basso
			for i := 1 to i_objs do begin
				y_min := 9999;i_min := 1;
				for j := 1 to i_objs do
					if (NOT (j in printed)) AND (xobjs(j).get_top < y_min) then begin
						y_min := xobjs(j).get_top;
						i_min := j
					end;
				printed := printed + [i_min];
{				objs(i_min].print(controllo.pb_in.canvas,printer.canvas,x0,y0,FALSE,@clpr,i_delta_y) {}
				with xobjs(i_min) do
					if NOT print(
//						pbox.canvas,
						{$ifdef OLD_LABEL}
							{$ifdef DLL} aslabel.Canvas {$else} pbox.canvas {$endif},
						{$else}
//							{$ifdef DLL} aslabel.getCanvas {$else} pbox.canvas {$endif},
							{$ifdef DLL} aslabel.getCanvas {$else} pbox.canvas {$endif},
						{$endif}
						printer.canvas,x0,y0,FALSE,@clpr,i_delta_y,i_max_y_pixel,
						0 { da cambiare nel valore corretto },i_label_size_Y_pix_print,FALSE,0,0)
							then { ???? che fare??? I don't know };
			end;

			if bo_print_bordo then begin
				canvas.moveto(x0,y0);canvas.lineto(x0,y1);
				canvas.lineto(x1,y1);canvas.lineto(x1,y0);canvas.lineto(x0,y0)
			end
		end;
		inc(i_last_label_printed);inc(lo_totale_labels)
	end;

var i,j,k,x0,y0 : integer;
begin
	if bo_ask_incorrect AND NOT verify_page_size(1,handle,printer) then begin bo_stop := TRUE;exit end;
	bo_ask_incorrect := FALSE;
	if bo_msgs then begin
		if (MessageBBox(handle, 'Stampa?', MBOX_CAPTION, MB_QUESTION) <> IDYES) then exit;
		set_wait_cursor(TRUE);
		SetCapture(handle)
	end;

	x0 := 0;i := 1;j := 1;
	while (x0 < i_last_label_printed) do begin
		if (j < tm.i_lab_per_row) then inc(j) else begin j := 1;inc(i) end;
		inc(x0)
	end;

	for k := 1 to i_numero_copie do with Printer do with tm do begin
		if bo_stop then break;
		if (i_last_label_printed = 0) then begin
			inc(lo_print_number);printer.title := 'GALATEO #' + zeri(lo_print_number,2);
			printer.BeginDoc
		end;

		y0 := cm2pixel_print_y(get_page_marg_UP_cm(1) + (get_label_size_Y_cm + r_delta_labs_Y_cm) * (i-1));
		x0 := cm2pixel_print_x(get_page_marg_SX_cm(1) + (get_label_size_X_cm + r_delta_labs_X_cm) * (j-1));
		stampa_label(x0,y0);
		if (j < i_lab_per_row) then inc(j)
		else begin
			j := 1;
			if (i < i_lab_per_page) then inc(i)
			else begin i := 1;i_last_label_printed := 0;Enddoc end
		end;
		ww_printed_another_one
	end;
	if bo_msgs then begin
		ReleaseCapture;set_wait_cursor(FALSE);
		MessageBBox(handle, 'Stampato', MBOX_CAPTION)
	end
end;

initialization
	galateo_initialization_debug('print_label_old')
finalization
	galateo_finalization_debug('print_label_old')
end.
