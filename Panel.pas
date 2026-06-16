unit Panel;	//*

{$I defines}
//{$ifdef DLL} *** {$endif}

interface

uses Classes, Messages, Sysutils, Windows, Types, VCL.Controls, VCL.Extctrls, VCL.Forms, VCL.Graphics,
	gdich, Federico;

type
	TGalPanel = class;
	TgalPaintBox = class(TPaintBox)
		public
			panel : TGalPanel;
			constructor xcreate(panel : TGalPanel;box : boolean);
			destructor free;
		private
{$ifndef DLL}
			procedure WMLButtonDblclk(var Message: TWMLButtonDBLCLK); message WM_LBUTTONDBLCLK;
			procedure WMLButtonDown(var Message: TWMLButtonDOWN); message WM_LBUTTONDOWN;
			procedure WMLButtonUp(var Message: TWMLButtonUP); message WM_LBUTTONUP;
			procedure WMMousemove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
			procedure WMRButtonDown(var Message: TWMRButtonDOWN); message WM_RBUTTONDOWN;
			procedure WMPaint(var Message: TWMpaint); message WM_PAINT;
{$endif}
	end;

	TPanel_dragdrop = class
		private
{$ifndef DLL}
			dragging_rect : TRect;
			bo_resizing_left, bo_resizing_top : boolean;
			p_start_dragging : TPoint;
{$endif DLL}
			i_panel_1B : smallint;
		public
{$ifndef DLL}
			bo_resizing_horz, bo_resizing_vert : boolean;
			procedure find_panel(Sender : TObject{;x,y : integer});
			procedure dragging_Mousemove(Sender : TObject;X,Y: Integer);
			procedure draw_rectangle(Sender : TObject;x,y : integer);
			procedure stop_dragging(bo_drop : boolean);
			procedure dragging_mouse_up;
{$endif DLL}
			constructor create;
			destructor free;
	end;

	TBorderpanel = class(Tpanel)	// pannello specifico per Galateo
		public
			panel : TGalPanel;
			bo_top : boolean;
			constructor xcreate(panel : TGalPanel;bo_top : boolean);
			destructor free;
			{$ifndef DLL} procedure xresize(box : boolean); {$endif}
	end;

	Tgalpanel = class(TFpanel)	// pannello specifico per Galateo
		public
			father : TForm;
			pbox : TGalPaintBox;
			i_panel_1B : smallint;
			pan_top, pan_bottom : TBorderPanel;
			constructor xcreate(father : TForm;parent : TWinControl;i_panel_1B : smallint;bo_visible : boolean);
			procedure free;
{$ifdef GALATEO_EXE}
			procedure griglia_virtuale;
			procedure xresize(box : boolean);
			procedure set_active(bo_active : boolean);
			procedure set_father_1B(i_father_1B : smallint);
			procedure set_father_ZB(i_father_ZB : smallint);
		private
//			procedure WMCreate(var Message: TWMCreate); message WM_CREATE; {}
			procedure WMLButtonDblclk(var Message: TWMLButtonDBLCLK); message WM_LBUTTONDBLCLK;
			procedure WMLButtonDown(var Message: TWMLButtonDOWN); message WM_LBUTTONDOWN;
			procedure WMRButtonDown(var Message: TWMRButtonDOWN); message WM_RBUTTONDOWN;
			procedure WMSize(var Message: TWMSize); message WM_SIZE;
{$endif GALATEO_EXE}
	end;

var
	dd : TPanel_dragdrop;

implementation

uses Fcommons, Fdebug, {$ifdef DEBUG} Fassert, {$endif} FSystem,
	{$ifndef DLL} sezione_edit, galateo_main, {$endif}
	proc, galateo_debug, sezione, misure, objsx, objects, labels, bmps, pages;

const
	PANEL_BORDER_HEIGHT_CM = 0.1;		// altezza del bordo del panel separatore
	MAX_SPECIALIZED_PANEL_COLORS = 1+3;	// numero di pannelli con colori specializzati; comprende il #1 (MAIN)
	ACTIVE_PANEL_COLORS : array[1..MAX_SPECIALIZED_PANEL_COLORS] of TColor = (0, clRed, clLime, clYellow);		// 0 = MAIN

{$ifdef DEBUG} var i_panel_dragdrop : integer; {$endif}

// -------- TBorderPanel ---------------------------------

constructor TBorderPanel.xcreate(panel : TGalPanel;bo_top : boolean);
begin
//	register_create(CHKM_GALATEO_GAL_BORDPAN,self);
	inherited create(panel);
	self.Parent := panel;self.panel := panel;
	self.bo_top := bo_top;
	bevelInner := bvNone;bevelOuter := bvNone;
	borderStyle := bsSingle;
	ctl3d := FALSE;color := clBtnFace;
	cursor := crNoDrop{crVSplit {};
	ParentBackground := FALSE;
	left := 0;
	height := cm2pixel_video_y(PANEL_BORDER_HEIGHT_CM);
	{$ifndef DLL}xresize(FALSE){$endif}
end;

destructor TBorderPanel.free;
begin {register_free(CHKM_GALATEO_GAL_BORDPAN,self)} end;

{$ifndef DLL}
procedure TBorderPanel.xresize;
begin
	if bo_top then top := 0 else top := panel.Height - height;
	width := panel.Width
end;
{$endif}

// -------------- TGAL PANEL ---------------------

constructor Tgalpanel.xcreate(father : TForm;parent : TWinControl;i_panel_1B : smallint;bo_visible : boolean);
begin
	inherited create(parent);
	self.father := father;self.parent := parent;
	self.i_panel_1B := i_panel_1B;
	// inizializzazione dei valori
	bevelInner := bvNone;bevelOuter := bvNone;
	Caption := '';Visible := bo_visible;
	ctl3d := FALSE;color := clWindow;
	if (i_panel_1B > MAIN_SECTION) then begin
		pan_top := TBorderPanel.xcreate(self, TRUE);
		pan_bottom := TBorderPanel.xcreate(self, FALSE)
	end;
	pbox := TGalPaintBox.xcreate(self, FALSE)		// creazione PaintBox
end;

procedure Tgalpanel.free;
begin
	pbox.free;
	if (pan_top <> NIL) then pan_top.free;
	if (pan_bottom <> NIL) then pan_bottom.free;
	{$ifndef DLL} set_father_1B(-1) {$endif}		// non mi è chiaro se serva, ma certo non serve IF DLL
end;

{$ifndef DLL}

procedure TGalPanel.set_active(bo_active : boolean);
var i, lo_color : integer;
begin
	if bo_active then begin
		set_section_attiva_ZB(i_panel_1B - 1);
		for i := 1 to get_num_sections do
			if (i <> i_panel_1B) then panels_ZB(i - 1).set_active(FALSE);
		if (i_panel_1B <= MAX_SPECIALIZED_PANEL_COLORS) then lo_color := ACTIVE_PANEL_COLORS[i_panel_1B]
		else lo_color := clActiveCaption
	end
	else lo_color := clBtnFace;
	if (i_panel_1B <> MAIN_SECTION) then begin
		pan_top.Color := lo_color;
		pan_bottom.Color := lo_color
	end
end;

procedure TGalPanel.xresize;
begin
	if (get_num_sections >= i_panel_1B) then begin
		pbox.Width := Width;
		pbox.Height := cm2pixel_video_y(sections_1B(i_panel_1B).r_y_gruppo_cm)
	end;
	if (pan_top <> NIL) then pan_top.xresize(FALSE);
	if (pan_bottom <> NIL) then pan_bottom.xresize(FALSE)
end;

procedure Tgalpanel.set_father_1B(i_father_1B : smallint);
{ assegna al pannello il legittimo parent; I_FATHER è l'indice del pannello che va a fare da parent al pannello presente;
  se I_FATHER = 0 il panel torna di proprietà di CONTROLLO.SBOX (parent del pannello principale) e viene nascosto;
  se I_FATHER = -1 then il panel diventa assolutamente orfano }
begin
	if (parent <> NIL) then parent.removecontrol(self);
	case i_father_1B of
		-1 : Parent := NIL;
		0 : begin
//			panels[self.i_father].removecontrol(self);
			GM.sbox.insertcontrol(self);
			Parent := GM.sbox
		end
		else begin
//			controllo.sbox.removecontrol(self);
			panels_ZB(i_father_1B - 1).insertcontrol(self);
			Parent := panels_ZB(i_father_1B - 1)
		end
	end;
	Visible := (i_father_1B > 0)
end;

procedure Tgalpanel.set_father_ZB(i_father_ZB : smallint);
{ assegna al pannello il legittimo parent; I_FATHER è l'indice del pannello che va a fare da parent al pannello presente;
  se I_FATHER = -1 il panel torna di proprietà di CONTROLLO.SBOX (parent del pannello principale) e viene nascosto;
  se I_FATHER = -2 then il panel diventa assolutamente orfano }
begin
	if (parent <> NIL) then parent.removecontrol(self);
	case i_father_ZB of
		-2 : Parent := NIL;
		-1 : begin
//			panels[self.i_father].removecontrol(self);
			GM.sbox.insertcontrol(self);
			Parent := GM.sbox
		end
		else begin
//			controllo.sbox.removecontrol(self);
			panels_ZB(i_father_ZB).InsertControl(self);
			Parent := panels_ZB(i_father_ZB)
		end
	end;
	Visible := (i_father_ZB > -1)
end;

procedure TGalPanel.WMSize(var Message: TWMSize); begin xresize(FALSE) end;

procedure TGalPanel.WMLButtonDblclk(var Message: TWMLButtonDBLCLK);
begin
	if NOT tratta_mouse_messages(i_panel_1B, message) then edit_section_ZB(i_panel_1B - 1, FALSE)
end;

procedure TGalPanel.WMLButtonDown(var Message: TWMLButtonDown);
begin
	if NOT tratta_mouse_messages(i_panel_1B, message) then set_active(TRUE)
end;

procedure TGalPanel.WMRButtonDown(var Message: TWMRButtonDown);
begin
	if tratta_mouse_messages(i_panel_1B, message) then exit;
	set_active(TRUE);
	GM.itp_nome_sezione.Caption := uppercase(sections_1B(i_panel_1B).str_nome);
	var p := Point(message.xpos, message.ypos);p := ClientToScreen(p);
	GM.popup_section.popup(p.x, p.y)
end;

procedure TGalPanel.griglia_virtuale;
begin
	for var i : smallint := 1 to i_objs do begin
		with xobjs(i) do begin
			if (panel <> self) then continue;	// solo gli oggetti relativi a questo panel
			set_top(get_y_top_virtuale(get_top));
			set_left(get_x_left_virtuale(get_left))
		end
	end
end;

{$endif}

// ---------- TGAL PAINTBOX ---------------------

constructor TgalPaintBox.xcreate(panel : TGalPanel;box : boolean);
begin
{	register_create(CHKM_GALATEO_GAL_PAINTBOX,self); {}
	inherited create(panel);
	self.Parent := panel;self.panel := panel;
	Left := 0;Top := 0
end;

destructor TGalPaintBox.free;
begin {register_free(CHKM_GALATEO_GAL_PAINTBOX,self) }end;

{$ifdef GALATEO_EXE}

	procedure TGalPaintBox.WMLButtonDblclk(var Message: TWMLButtonDBLCLK);
	begin
		if NOT tratta_mouse_messages(panel.i_panel_1B, message) then panel.WMLButtonDblclk(Message)
	end;

	procedure TGalPaintBox.WMLButtonDown(var Message: TWMLButtonDOWN);
	begin
		if NOT tratta_mouse_messages(panel.i_panel_1B, message) then begin
			if NOT multi_selecting_keys_combination then obj_select(0, FALSE, FALSE);
			panel.set_active(TRUE)
		end
	end;

	procedure TGalPaintBox.WMLButtonUp(var Message: TWMLButtonUP);
	begin
		if NOT tratta_mouse_messages(panel.i_panel_1B, message)
			then dd.dragging_mouse_up
	end;

	procedure TGalPaintBox.WMMousemove(var Message: TWMMouseMove);
	begin
		if NOT tratta_mouse_messages(panel.i_panel_1B, message) then
			dd.dragging_Mousemove(self, message.xpos, message.ypos)
	end;

	procedure TGalPaintBox.WMRButtonDown(var Message: TWMRButtonDown);
	begin
		if NOT tratta_mouse_messages(panel.i_panel_1B, message)
			then panel.WMRButtonDown(Message)
	end;

	procedure TGalPaintBox.WMPaint(var Message: TWMpaint);
	var i, k : integer;	//*
	begin
	//	sendtoback;
		var old_pen_style : TPenStyle := canvas.Pen.Style;
		if tm.bo_show_griglia then begin
			canvas.pen.Color := clLime;
			for i := 1 to trunc(get_Vpage_size_X_cm(get_pagina_logica_attiva_1B)) do begin
				k := cm2pixel_video_x(i);
				canvas.moveto(k, 0);canvas.lineto(k, height)
			end;
			for i := 1 to trunc(get_Vpage_size_Y_cm(get_pagina_logica_attiva_1B)) do begin
				k := cm2pixel_video_y(i);
				canvas.moveto(0, k);canvas.lineto(width, k)
			end
		end;
		if globale.bo_griglia_vtabs AND (video2cm_y(globale.i_griglia_vtabs) > 0.5) then begin
			// disegno la griglia tabulatori verticali solo se ogni maglia supera il mezzo cm
			canvas.Pen.Color := clFuchsia;canvas.Pen.Style := psDot;
			for i := 1 to height div globale.i_griglia_vtabs do begin
				k := i * globale.i_griglia_vtabs;
				canvas.Moveto(0, k);canvas.LineTo(width, k)
			end
		end;
		canvas.Pen.Style := old_pen_style
	end;

{$endif}

// ------ TPanel_dragdrop ------------------------------------------------------

constructor TPanel_dragdrop.create;
begin
	{$ifdef DEBUG} inc(i_panel_dragdrop); {$endif}
//	bo_resizing_horz := FALSE;bo_resizing_vert := FALSE;
//	bo_resizing_left := FALSE;bo_resizing_top := FALSE;
	{$ifndef DLL} p_start_dragging := Point(-1, -1); {$endif}
	i_panel_1B := 0
end;

destructor TPanel_dragdrop.free;
begin {$ifdef DEBUG} dec(i_panel_dragdrop) {$endif} end;

{$ifndef DLL}
	procedure TPanel_dragdrop.draw_rectangle(Sender : TObject;x,y : integer);
	{ disegna la shape dell'oggetto che si muove spostato dal mouse;
	  passare (-1,-1) l'ultima volta per far cancellare la shape }
	var
		r : TRect;
		p : TPoint;
	begin
		find_panel(sender);
		with panels_ZB(i_panel_1B - 1) do begin
			pbox.invalidate;pbox.update;
			if (get_selected_obj_index(0) = 0) then stop_dragging(FALSE);
			if (p_start_dragging.x = -1) then begin
				get_selected_obj(0).set_show_hints(FALSE);
				p_start_dragging := Point(x,y);
				p := Point(0,0);p := ClientToScreen(p);
				with get_selected_obj(0) do begin
					if bo_resizing_horz OR bo_resizing_vert then begin
						r.Left := get_left;r.Right := r.Left + get_width;
						r.Top := get_top;r.Bottom := r.Top + get_height;
						if bo_resizing_horz then
							if bo_resizing_left then begin r.Left := 0;dec(r.Right,LARG_SIZE_AREA) end
							else begin inc(r.Left,LARG_SIZE_AREA);r.Right := width end
						else
							if bo_resizing_top then begin r.Top := 0;dec(r.Bottom,LARG_SIZE_AREA) end
							else begin inc(r.Top,LARG_SIZE_AREA);r.Bottom := height end;
						with r do dragging_rect := Rect(p.x+left,p.y+top,p.x+right,p.y+bottom)
					end
					else begin
						dragging_rect := Rect(p.x + x - get_left,p.y + y - get_top,
							p.x + pbox.Width - (get_left + get_width - x)-1,
							p.y + pbox.Height - (get_top + get_height - y)-1)
					end
				end;
				ClipCursor(@dragging_rect)
			end;
			if (x <> -1) then begin
				if bo_resizing_horz OR bo_resizing_vert then with get_selected_obj(0) do begin
					if bo_resizing_horz then
						if bo_resizing_left then begin
							set_width(get_width + get_left - x);
							set_left(x)
						end
						else set_width(x - get_left)
					else
						if bo_resizing_top then begin
							set_height(get_height + get_top - y);
							set_top(y)
						end
						else set_height(y - get_top) {}
				end
				else with dragging_rect, get_selected_obj(0) do begin
					left := get_x_left_virtuale(get_left + x - p_start_dragging.x);
					top := get_y_top_virtuale(get_top + y - p_start_dragging.y);
					right := left + get_width;
					bottom := top + get_height;
					pbox.canvas.Rectangle(left,top,right,bottom)
				end
			end
		end
	end;

	procedure TPanel_dragdrop.dragging_Mousemove(Sender : TObject;X,Y : Integer);
	var
		r : TRect;
		bo_vert : boolean;
	begin
		if GM.btn_lock.Down then exit;	// se lo spostamento è disabilitato, non faccio nulla
		if NOT is_lbutton_down then begin
			bo_resizing_left := FALSE;bo_resizing_top := FALSE;
			if (Sender is cl_bmp) then begin
				r.Left := (sender as TControl).Left;
				r.Right := r.Left + (sender as TControl).Width;
				r.Top := (sender as TControl).Top;
				r.Bottom := r.Top + (sender as TControl).Height;
				bo_resizing_horz := ((r.Left <= x) AND (x <= r.Left + LARG_SIZE_AREA)) OR
					((r.Right-LARG_SIZE_AREA <= x) AND (x <= r.Right));
				bo_vert := ((r.Top <= y) AND (y <= r.Top + LARG_SIZE_AREA)) OR
					((r.Bottom-LARG_SIZE_AREA <= y) AND (y <= r.Bottom));
				if bo_vert then begin
					bo_resizing_top := (r.Top <= y) AND (y <= r.Top + LARG_SIZE_AREA);
					(sender as TControl).cursor := crSizeNS
				end else
				if bo_resizing_horz then begin
					bo_resizing_left := (r.Left <= x) AND (x <= r.Left + LARG_SIZE_AREA);
					(sender as TControl).cursor := crSizeWE
				end
				else (sender as TControl).cursor := DEFAULT_CURSOR_OBJECTS
			end
		end;
		if ((p_start_dragging.x <> -1) AND NOT is_lbutton_down) then begin
			stop_dragging(FALSE);
			exit
		end;
		if ((get_selected_obj_index(0) <> 0) AND is_lbutton_down AND ((p_start_dragging.x <> -1) OR NOT (Sender is TGM)))
			then draw_rectangle(sender,x,y)
	end;

	procedure TPanel_dragdrop.stop_dragging(bo_drop : boolean);
	var i : smallint;
	begin
		if bo_resizing_horz OR bo_resizing_vert then begin
			set_global_modified;
			bo_resizing_horz := FALSE;bo_resizing_vert := FALSE;
			exit
		end
		else begin
			if bo_drop then begin
				set_global_modified;
				get_selected_obj(0).set_left(dragging_rect.Left);
				get_selected_obj(0).set_top(dragging_rect.Top);
				for i := 0 to get_num_sections - 1 do panels_ZB(i).griglia_virtuale
			end
		end;
		if (get_selected_obj_index(0) <> 0) then get_selected_obj(0).set_show_hints(TRUE);
		ClipCursor(NIL);
		for i := 0 to get_num_sections - 1 do panels_ZB(i).pbox.invalidate;
		p_start_dragging.x := -1;
		i_panel_1B := 0
	end;

	procedure TPanel_dragdrop.dragging_mouse_up;
	begin if (p_start_dragging.x <> -1) then stop_dragging(TRUE) end;

	procedure TPanel_dragdrop.find_panel(Sender : TObject{;x,y : integer});
	{ determina il panel su cui si trovano le coordinate X,Y e imposta I_PANEL di conseguenza;
	  rende 0 se non trova il risultato }
	begin
		if (i_panel_1B = 0) then begin
			if (sender is TGalPaintBox) then i_panel_1B := (sender as TGalPaintBox).panel.i_panel_1B;
			if (sender is cl_label) then i_panel_1B := (sender as cl_label).ca.i_section_1B;
			if (sender is cl_bmp) then i_panel_1B := (sender as cl_bmp).ca.i_section_1B;
	//		if (sender is rect_obj) then i_panel_1B := (sender as rect_obj).ca.i_section;
			if (i_panel_1B = 0) then abort
		end
	end;

{$endif}

initialization
	galateo_initialization_debug('panel');
	dd := TPanel_dragdrop.create
finalization
	galateo_finalization_debug('panel');
	if (dd <> NIL) then dd.free;
	{$ifdef DEBUG} CCI(i_panel_dragdrop, 'TPanel_dragdrop', 'panel.pas'); {$endif}
end.
