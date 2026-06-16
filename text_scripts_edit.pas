// incluso by IMPOSTAZIONI -- contiene le procedure di gestione degli scripts: SQL & MACRO PARAMETRICHE

const
	SCRIPT_SHEET_CAPTION_BASE : array[text_script_type] of string = ('early-', 'std-', 'after-', 'macro-');
	SCRIPT_COLORX : array[text_script_type] of TColor = ($0079BCFF, $00FFFFCE, $00E4CBCB, $00AEFFAE);
	SCRIPT_COLOR_LIGHTX : array[text_script_type] of TColor = ($00DFEFFF, $00FFFFE8, $00F4EAEA, $00E8FFE8);
	SCRIPT_DISABLED_REMOTO_COLOR = clBtnShadow;

// ----------- SQL scripts -------------------------------------------------------------------------------------------------------------------------------------

procedure SQL_tab_type.copy_from(source : SQL_tab_type);
begin
	sheet := source.sheet;panel_header := source.panel_header;
	txt_descrizione := source.txt_descrizione;str_descrizione := source.str_descrizione;
	txt_condizione := source.txt_condizione;str_condizione := source.str_condizione;
	txt_filename := source.txt_filename;str_filename := source.str_filename;
	str_text := source.str_text;
	txt_note := source.txt_note;str_note := source.str_note;
	btn_sx := source.btn_sx;btn_dx := source.btn_dx;
	btn_filename_browse := source.btn_filename_browse;btn_filename_reload := source.btn_filename_reload;

	cbx_disabled_locale := source.cbx_disabled_locale;
	cbx_disabled_remoto := source.cbx_disabled_remoto;
	cbx_transazione_separata := source.cbx_transazione_separata;
	rb_isolation_level := source.rb_isolation_level;
	rb_commit := source.rb_commit
end;

procedure SQL_tab_type.assign_tab_index(tipo : SQL_script_type;i_script_index : byte);
begin
	sheet.Caption := SCRIPT_SHEET_CAPTION_BASE[tipo] + zeri(i_script_index + 1, 2);
	var i_tab_index : smallint := sheet.PageIndex;sheet.Tag := i_tab_index;
	btn_sx.Tag := i_tab_index;btn_dx.Tag := i_tab_index;
	btn_filename_browse.Tag := i_tab_index;btn_filename_reload.Tag := i_tab_index
end;

// ------------------------------

procedure Tdlg_impostazioni.create_and_write_SQLS_table;
var bo_totale : boolean;

	procedure create_tab;
	begin
		var i_index : byte := length(SQL_tabs);
		setLength(SQL_tabs, i_index +  1);
		var x : SQL_tab_punt := @SQL_tabs[i_index];
//		x.script := sx;

		x.sheet := TTabSheet.Create(pc_SQL);x.sheet.PageControl := pc_SQL;

		x.panel_header := TFPanel.create(self);x.panel_header.Parent := x.sheet;
		x.panel_header.Align := alTop;x.panel_header.Height := panel_SQLS_header.Height;
		x.panel_header.Caption := '';

		x.btn_sx := TBitBtn_fede.Create(self);x.btn_sx.Parent := x.panel_header;
		x.btn_sx.TabStop := FALSE;
		set_control_pos_size(x.btn_sx, btn_SQL_move_sheet_sx);
		x.btn_sx.Anchors := btn_SQL_move_sheet_sx.Anchors;
		x.btn_sx.Glyph.Assign(btn_SQL_move_sheet_sx.Glyph);
		x.btn_sx.NumGlyphs := btn_SQL_move_sheet_sx.NumGlyphs;
		x.btn_sx.OnClick := btn_SQL_move_sheet_sxClick;
		x.btn_sx.Hint := btn_SQL_move_sheet_sx.Hint;x.btn_sx.ShowHint := TRUE;

		x.btn_dx := TBitBtn_fede.Create(self);x.btn_dx.Parent := x.panel_header;
		x.btn_dx.TabStop := FALSE;
		set_control_pos_size(x.btn_dx, btn_SQL_move_sheet_dx);
		x.btn_dx.Anchors := btn_SQL_move_sheet_dx.Anchors;
		x.btn_dx.Glyph.Assign(btn_SQL_move_sheet_dx.Glyph);
		x.btn_dx.NumGlyphs := btn_SQL_move_sheet_dx.NumGlyphs;
		x.btn_dx.OnClick := btn_SQL_move_sheet_dxClick;
		x.btn_dx.Hint := btn_SQL_move_sheet_dx.Hint;x.btn_dx.ShowHint := TRUE;
		x.btn_dx.Left := x.panel_header.clientWidth - x.btn_dx.Width;

		x.cbx_disabled_locale := TFCheckBox.Create(self);x.cbx_disabled_locale.Parent := x.panel_header;
		x.cbx_disabled_locale.Caption := cbx_SQLS_disabled_locale_00.Caption;
		set_control_pos_size(x.cbx_disabled_locale, cbx_SQLS_disabled_locale_00);
		x.cbx_disabled_locale.AAA_NeedNotifyModification := FALSE;
		x.cbx_disabled_locale.OnClick := cbx_SQL_script_enabledClick;
		x.cbx_disabled_locale.Hint := cbx_SQLS_disabled_locale_00.Hint;x.cbx_disabled_locale.ShowHint := TRUE;

		x.cbx_disabled_remoto := TFCheckBox.Create(self);x.cbx_disabled_remoto.Parent := x.panel_header;
		x.cbx_disabled_remoto.Caption := cbx_SQLS_disabled_remoto_00.Caption;
		set_control_pos_size(x.cbx_disabled_remoto, cbx_SQLS_disabled_remoto_00);
		x.cbx_disabled_remoto.AAA_NeedNotifyModification := FALSE;
		x.cbx_disabled_remoto.OnClick := cbx_SQL_script_enabledClick;
		x.cbx_disabled_remoto.Hint := cbx_SQLS_disabled_remoto_00.Hint;x.cbx_disabled_remoto.ShowHint := TRUE;

		x.cbx_transazione_separata := TFCheckBox.Create(self);x.cbx_transazione_separata.Parent := x.panel_header;
		x.cbx_transazione_separata.Caption := cbx_SQLS_isolated_transaction_00.Caption;
		set_control_pos_size(x.cbx_transazione_separata, cbx_SQLS_isolated_transaction_00);
		x.cbx_transazione_separata.AAA_NeedNotifyModification := FALSE;
		x.cbx_transazione_separata.OnClick := cbx_SQL_script_enabledClick;
		x.cbx_transazione_separata.Hint := cbx_SQLS_isolated_transaction_00.Hint;x.cbx_transazione_separata.ShowHint := TRUE;

		x.txt_descrizione := TMyLabel.Create(self);x.txt_descrizione.Parent := x.panel_header;
		set_control_pos_size(x.txt_descrizione, txt_SQLS_descrizione_00);
		x.txt_descrizione.Caption := txt_SQLS_descrizione_00.Caption;

		x.str_descrizione := TFEdit.Create(self);x.str_descrizione.Parent := x.panel_header;
		set_control_pos_size(x.str_descrizione, str_SQLS_descrizione_00);
		x.str_descrizione.AAA_NeedNotifyModification := FALSE;
		x.txt_descrizione.FocusControl := x.str_descrizione;
		x.str_descrizione.Anchors := str_SQLS_descrizione_00.Anchors;

		x.txt_condizione := TMyLabel.Create(self);x.txt_condizione.Parent := x.panel_header;
		set_control_pos_size(x.txt_condizione, txt_SQLS_condizione_00);
		x.txt_condizione.Caption := txt_SQLS_condizione_00.Caption;

		x.str_condizione := TFEdit.Create(self);x.str_condizione.Parent := x.panel_header;
		set_control_pos_size(x.str_condizione, str_SQLS_condizione_00);
		x.str_condizione.ShowHint := TRUE;x.str_condizione.Hint := str_SQLS_condizione_00.Hint;
		x.str_condizione.AAA_NeedNotifyModification := FALSE;
		x.txt_condizione.FocusControl := x.str_condizione;
		x.str_condizione.Anchors := str_SQLS_condizione_00.Anchors;

		x.txt_filename := TMyLabel.Create(self);x.txt_filename.Parent := x.panel_header;
		set_control_pos_size(x.txt_filename, txt_SQLS_filename_00);
		x.txt_filename.Caption := txt_SQLS_filename_00.Caption;

		x.str_filename := TFEdit.Create(self);x.str_filename.Parent := x.panel_header;
		set_control_pos_size(x.str_filename, str_SQLS_filename_00);
		x.str_filename.ShowHint := TRUE;x.str_filename.Hint := str_SQLS_filename_00.Hint;
		x.str_filename.AAA_NeedNotifyModification := FALSE;
		x.txt_filename.FocusControl := x.str_filename;
		x.str_filename.Anchors := str_SQLS_filename_00.Anchors;
		x.str_filename.OnExit := cbx_SQL_script_enabledClick;

		x.btn_filename_browse := TBitBtn_fede.create(self);x.btn_filename_browse.Parent := x.panel_header;
		set_control_pos_size(x.btn_filename_browse, btn_SQLS_filename_browse_00);
		x.btn_filename_browse.Caption := btn_SQLS_filename_browse_00.Caption;
		x.btn_filename_browse.ShowHint := TRUE;x.btn_filename_browse.Hint := btn_SQLS_filename_browse_00.Hint;
		x.btn_filename_browse.OnClick := btn_SQLS_filename_browse_00.OnClick;
//		btn_SQLS_filename_browse_00.Glyph.Assign(x.btn_filename_browse.Glyph);

		x.btn_filename_reload := TBitBtn_fede.create(self);x.btn_filename_reload.Parent := x.panel_header;
		set_control_pos_size(x.btn_filename_reload, btn_SQLS_filename_reload_00);
		x.btn_filename_reload.Caption := btn_SQLS_filename_reload_00.Caption;
		x.btn_filename_reload.ShowHint := TRUE;x.btn_filename_reload.Hint := btn_SQLS_filename_reload_00.Hint;
		x.btn_filename_reload.OnClick := btn_SQLS_filename_reload_00.OnClick;
		btn_SQLS_filename_reload_00.Glyph := NIL;
		btn_SQLS_filename_reload_00.Glyph := x.btn_filename_reload.Glyph;

		x.rb_isolation_level := TFRadioGroup.Create(self);x.rb_isolation_level.Parent := x.panel_header;
		x.rb_isolation_level.Caption := rb_SQLS_transaction_isolation_level_00.Caption;
		set_control_pos_size(x.rb_isolation_level, rb_SQLS_transaction_isolation_level_00);
		x.rb_isolation_level.AAA_NeedNotifyModification := FALSE;
		x.rb_isolation_level.Items.Assign(cb_isolation.Items);
		x.rb_isolation_level.ShowHint := TRUE;x.rb_isolation_level.Hint := rb_SQLS_transaction_isolation_level_00.Hint;
//		x.rb_isolation_level.OnClick := cbx_script_enabledClick;
//		x.rb_isolation_level.SendToBack;		// possibile marginale sovrapposizione con EditControls

		x.rb_commit := TFRadioGroup.Create(self);x.rb_commit.Parent := x.panel_header;
		x.rb_commit.Caption := rb_SQLS_transaction_commit_00.Caption;
		set_control_pos_size(x.rb_commit, rb_SQLS_transaction_commit_00);
		x.rb_commit.AAA_NeedNotifyModification := FALSE;
		x.rb_commit.Items.Assign(rb_SQLS_transaction_commit_00.Items);
		x.rb_commit.ShowHint := TRUE;x.rb_commit.Hint := rb_SQLS_transaction_isolation_level_00.Hint;
//		x.rb_commit.OnClick := cbx_script_enabledClick;
//		x.rb_commit.SendToBack;		// possibile marginale sovrapposizione con EditControls

		x.str_text := TFMemo.Create(self);x.str_text.Parent := x.sheet;
		x.str_text.Align := alClient;
//		x.str_SQL.Font.Assign(str_SQLS_00.Font);
		x.str_text.Font.Name := 'Courier New';x.str_text.Font.Size := 10;x.str_text.Font.Style := [fsBold];
		x.str_text.ScrollBars := str_SQLS_00.ScrollBars;
		x.str_text.AAA_NeedNotifyModification := FALSE;

		x.txt_note := TMyLabel.Create(self);x.txt_note.Parent := x.panel_header;
		set_control_pos_size(x.txt_note, txt_SQLS_note_00);
		x.txt_note.Caption := txt_SQLS_note_00.Caption;

		x.str_note := TFMemo.Create(self);x.str_note.Parent := x.panel_header;
		x.str_note.Align := str_SQLS_note_00.Align;
		set_control_pos_size(x.str_note, str_SQLS_note_00);
//		x.str_note.Font.Name := 'Arial';x.str_note.Font.Size := 9;x.str_note.Font.Style := [];
		x.str_note.Font.Assign(str_SQLS_note_00.Font);
		x.str_note.ScrollBars := str_SQLS_note_00.ScrollBars;
		x.str_note.Anchors := str_SQLS_note_00.Anchors;
		x.str_note.AAA_NeedNotifyModification := FALSE
	end;

	procedure apply_tab_values(tipo : SQL_script_type;sx : text_script_record_punt;i_sheet_index, i_script_index : byte);
	begin
		var x : SQL_tab_punt := @SQL_tabs[i_sheet_index];
		x.assign_tab_index(tipo, i_script_index);

//		x.panel_header.Color := SCRIPT_COLORX[tipo];		// questa riga non serve a nulla
		x.str_text.Color := SCRIPT_COLOR_LIGHTX[tipo];
		x.str_note.Color := SCRIPT_COLOR_LIGHTX[tipo];
//		x.cbx_enabled.Tag := i_sheet_index;

		write_SQL_script_tab(i_sheet_index, sx);
//		x.sheet.Highlighted := x.cbx_enabled.Checked;
//		bo_totale := bo_totale OR x.sheet.Highlighted
//		if x.cbx_enabled.Checked then bo_totale := TRUE
		if NOT x.cbx_disabled_locale.Checked AND NOT x.cbx_disabled_remoto.Checked then bo_totale := TRUE
	end;

	procedure create_SQLS_tab(tipo : SQL_script_type);
	begin
		for var i : smallint := 0 to local_scripts[tipo].i_numero - 1 do begin
			inc(i_SQL_tabs_used);
			if (length(SQL_tabs) < i_SQL_tabs_used) then create_tab;
			apply_tab_values(tipo, @local_scripts[tipo].recs[i], i_SQL_tabs_used - 1, i)
		end
	end;

begin
	try
		bo_writing_scripts := TRUE;
		i_SQL_tabs_used := 0;bo_totale := FALSE;
		for var sxt : SQL_script_type := low(sxt) to high(sxt) do create_SQLS_tab(sxt);
		for var i : smallint := i_SQL_tabs_used to high(SQL_tabs) do begin SQL_tabs[i].Sheet.Visible := FALSE;SQL_tabs[i].Sheet.TabVisible := FALSE end;
		page_SQL_scripts.Highlighted := bo_totale;
		pc_SQL.Visible := (i_SQL_tabs_used <> 0)
	finally
		bo_writing_scripts := FALSE
	end
end;

procedure Tdlg_impostazioni.write_SQL_script_tab(i_sheet_index : smallint;sx : text_script_record_punt);
begin
	var x : SQL_tab_punt := @SQL_tabs[i_sheet_index];
	x.str_descrizione.Text := sx.str_descrizione;
	x.str_condizione.Text := sx.str_condizione;
	x.str_text.Text := sx.str_text;
	x.str_note.Text := sx.str_note;

	x.str_filename.Text := sx.str_filename;

	x.cbx_transazione_separata.Checked := sx.bo_transazione_separata;
	x.rb_isolation_level.ItemIndex := byte(sx.isolation_level);
	x.rb_commit.ItemIndex := (1 - byte(sx.bo_commit));

//	x.cbx_enabled.Checked := sx.bo_enabled AND (togli_ACAPO_finali(sx.str_text) <> '')
	x.cbx_disabled_locale.Checked := sx.bo_disabled_locale OR (togli_ACAPO_finali(sx.str_text) = '');
	x.cbx_disabled_remoto.Checked := sx.bo_disabled_remoto
end;

procedure Tdlg_impostazioni.read_SQLS_tabs;
begin
	if bo_writing_scripts then exit;
	var i_tab : smallint := 0;
	for var sxt : SQL_script_type := low(sxt) to high(sxt) do begin
		for var i_script : smallint := 0 to local_scripts[sxt].i_numero - 1 do begin
			var sx : text_script_record_punt := @local_scripts[sxt].recs[i_script];
			sx.str_descrizione := SQL_tabs[i_tab].str_descrizione.Text;
			sx.str_condizione := togliblanks(SQL_tabs[i_tab].str_condizione.Text);
			sx.str_text := SQL_tabs[i_tab].str_text.Text;
			sx.str_note := SQL_tabs[i_tab].str_note.Text;
			sx.str_filename := SQL_tabs[i_tab].str_filename.Text;
			if (sx.str_filename <> '') then sx.str_filename := ChangeFileExt(sx.str_filename, GALATEO_SQL_SCRIPT_FILE_EXT);

			sx.bo_transazione_separata := SQL_tabs[i_tab].cbx_transazione_separata.Checked;
			sx.isolation_level := TFDTxIsolation(SQL_tabs[i_tab].rb_isolation_level.ItemIndex);
			sx.bo_commit := (SQL_tabs[i_tab].rb_commit.ItemIndex = 0);

			sx.bo_disabled_locale := SQL_tabs[i_tab].cbx_disabled_locale.Checked;
			sx.bo_disabled_remoto := SQL_tabs[i_tab].cbx_disabled_remoto.Checked;
//			if sx.bo_enabled AND NOT check_condizione(sxt, i_script) then abort;
			if NOT sx.bo_disabled_locale AND NOT sx.bo_disabled_remoto AND
				NOT check_condizione_booleana(handle, local_scripts[sxt].recs[i_script].str_condizione, DESCRIZIONE_TEXT_SCRIPT[sxt])
					then raise exception.create('AAAAA');
			inc(i_tab)
		end
	end;

	// *DOPO* aver letto i dati aggiorno il numero degli scripts
	local_scripts[TST_SQLS_EARLY].i_numero := i_SQL_scripts_early.get_Asinteger(FALSE);
	local_scripts[TST_SQLS_BEFORE].i_numero := i_SQL_scripts_before.get_Asinteger(FALSE);
	local_scripts[TST_SQLS_AFTER].i_numero := i_SQL_scripts_after.get_Asinteger(FALSE)
end;

procedure Tdlg_impostazioni.enable_SQLS_tabs;
begin
	if NOT bo_started then exit;
	if bo_writing_scripts then exit;
	var i_tab : smallint := 0;
	for var sxt : SQL_script_type := low(sxt) to high(sxt) do begin
		for var i_script : smallint := 0 to local_scripts[sxt].i_numero - 1 do begin
			SQL_tabs[i_tab].btn_sx.Enabled := (i_script > 0);										// non sul primo script di questo tipo
			SQL_tabs[i_tab].btn_dx.Enabled := (i_script < local_scripts[sxt].i_numero - 1);	// non sull'ultimo script di questo tipo
			var bo := NOT SQL_tabs[i_tab].cbx_disabled_locale.Checked;
			SQL_tabs[i_tab].sheet.Highlighted := bo;
			SQL_tabs[i_tab].panel_header.Color := ifi(SQL_tabs[i_tab].cbx_disabled_remoto.Enabled AND SQL_tabs[i_tab].cbx_disabled_remoto.Checked,
				SCRIPT_DISABLED_REMOTO_COLOR, SCRIPT_COLORX[sxt]);
//			SQL_tabs[i_tab].cbx_disabled_locale := ;
			SQL_tabs[i_tab].cbx_disabled_remoto.Enabled := bo AND (SQL_tabs[i_tab].str_filename.Text <> '');
			enable_FC(SQL_tabs[i_tab].txt_descrizione, bo);
			enable_FC(SQL_tabs[i_tab].txt_condizione, bo);
			SQL_tabs[i_tab].cbx_transazione_separata.Enabled := bo;
			SQL_tabs[i_tab].rb_isolation_level.Enabled := bo AND SQL_tabs[i_tab].cbx_transazione_separata.Checked;
			SQL_tabs[i_tab].rb_commit.Enabled := SQL_tabs[i_tab].rb_isolation_level.Enabled;
			SQL_tabs[i_tab].str_text.Enabled := bo;
			SQL_tabs[i_tab].str_note.Enabled := bo;
			inc(i_tab)
		end
	end;
	btn_SQL_scripts_number_apply.Enabled :=
		(local_scripts[TST_SQLS_EARLY].i_numero <> i_SQL_scripts_early.get_Asinteger(FALSE)) OR
		(local_scripts[TST_SQLS_BEFORE].i_numero <> i_SQL_scripts_before.get_Asinteger(FALSE)) OR
		(local_scripts[TST_SQLS_AFTER].i_numero <> i_SQL_scripts_after.get_Asinteger(FALSE))
end;

procedure Tdlg_impostazioni.applica_modifica_numero_scripts_SQL;
begin
	if bo_writing_scripts then exit;
	read_SQLS_tabs;
	create_and_write_SQLS_table;
	enable_SQLS_tabs
end;

procedure Tdlg_impostazioni.move_SQL_script(i_index, i_direzione : smallint);
var temp : SQL_tab_type;
begin
//	if NOT bo_started OR NOT bo_writing_scripts then exit;
	{$ifdef DEBUG} assert(abs(i_direzione) = 1, 'WEEW 3912'); {$endif}
	var i_tab : smallint := 0;
	for var sxt : SQL_script_type := low(sxt) to high(sxt) do begin
		for var i_script : smallint := 0 to local_scripts[sxt].i_numero - 1 do begin
			if (i_tab = i_index) then begin
				// switcho le linguette sul TPageControl
				SQL_tabs[i_index].sheet.PageIndex := SQL_tabs[i_index].sheet.PageIndex + i_direzione;
				// switcho i records su SQL_tabs
				temp.copy_from(SQL_tabs[i_index]);
				SQL_tabs[i_index].copy_from(SQL_tabs[i_index + i_direzione]);
				SQL_tabs[i_index + i_direzione].copy_from(temp);
				SQL_tabs[i_index].assign_tab_index(sxt, i_script);
				SQL_tabs[i_index + i_direzione].assign_tab_index(sxt, i_script + i_direzione);
				enable_SQLS_tabs;
				exit
			end;
			inc(i_tab)
		end
	end
end;

// ----------- MACROS PARAMETRICHE -----------------------------------------------------------------------------------------------------------------------------

function macro_tab_type.get_default_tab_caption(i_index : smallint) : string;
begin
	result := SCRIPT_SHEET_CAPTION_BASE[TST_MACRO_PARAMETRICHE] + zeri(i_index + 1, 2)
end;

procedure macro_tab_type.assign_tab_index(tipo : macro_script_type;i_script_index : byte;str_tab_caption : string);
begin
	sheet.Caption := coalesce(str_tab_caption, get_default_tab_caption(i_script_index));
	var i_tab_index : smallint := sheet.PageIndex;
	sheet.Tag := i_tab_index;str_descrizione.Tag := i_tab_index;
	btn_sx.Tag := i_tab_index;btn_dx.Tag := i_tab_index;
	btn_filename_browse.Tag := i_tab_index;btn_filename_reload.Tag := i_tab_index
end;

procedure macro_tab_type.copy_from(source : macro_tab_type);
begin
	sheet := source.sheet;panel_header := source.panel_header;
	txt_descrizione := source.txt_descrizione;str_descrizione := source.str_descrizione;
	txt_filename := source.txt_filename;str_filename := source.str_filename;
	str_text := source.str_text;
	txt_note := source.txt_note;str_note := source.str_note;
	btn_sx := source.btn_sx;btn_dx := source.btn_dx;
	btn_filename_browse := source.btn_filename_browse;btn_filename_reload := source.btn_filename_reload
end;

// -------------------------------------------------

procedure Tdlg_impostazioni.apply_macros_tab_values(tipo : text_script_type;sx : text_script_record_punt;i_index : byte);
begin
	var x : macro_tab_punt := @macro_tabs[i_index];
	x.assign_tab_index(tipo, i_index, sx.str_descrizione);

	x.panel_header.Color := SCRIPT_COLORX[tipo];
	x.str_text.Color := SCRIPT_COLOR_LIGHTX[tipo];
	x.str_note.Color := SCRIPT_COLOR_LIGHTX[tipo];
//	x.cbx_enabled.Tag := i_sheet_index;

	write_macro_tab(i_index, sx)
end;

procedure Tdlg_impostazioni.write_macro_tab(i_index : smallint;sx : text_script_record_punt);
begin
	var x : macro_tab_punt := @macro_tabs[i_index];
	x.str_descrizione.Text := sx.str_descrizione;
	x.str_condizione.Text := sx.str_condizione;
	x.str_text.Text := sx.str_text;
	x.str_note.Text := sx.str_note;

	x.str_filename.Text := sx.str_filename
end;

procedure Tdlg_impostazioni.create_and_write_macro_table;
var bo_totale : boolean;

	procedure create_tab;
	begin
		var i_index : smallint := length(macro_tabs);
		setLength(macro_tabs, i_index +  1);
		var x : macro_tab_punt := @macro_tabs[i_index];
//		x.script := sx;

		x.sheet := TTabSheet.Create(pc_macro);x.sheet.PageControl := pc_macro;

		x.panel_header := TFPanel.create(self);x.panel_header.Parent := x.sheet;
		x.panel_header.Align := alTop;x.panel_header.Height := panel_macro_header.Height;
		x.panel_header.Caption := '';

		x.btn_sx := TBitBtn_fede.Create(self);x.btn_sx.Parent := x.panel_header;
		x.btn_sx.TabStop := FALSE;
		set_control_pos_size(x.btn_sx, btn_macro_move_sheet_sx);
		x.btn_sx.Anchors := btn_macro_move_sheet_sx.Anchors;
		x.btn_sx.Glyph.Assign(btn_macro_move_sheet_sx.Glyph);
		x.btn_sx.NumGlyphs := btn_macro_move_sheet_sx.NumGlyphs;
		x.btn_sx.OnClick := btn_macro_move_sheet_sxClick;
		x.btn_sx.Hint := btn_macro_move_sheet_sx.Hint;x.btn_sx.ShowHint := TRUE;

		x.btn_dx := TBitBtn_fede.Create(self);x.btn_dx.Parent := x.panel_header;
		x.btn_dx.TabStop := FALSE;
		set_control_pos_size(x.btn_dx, btn_macro_move_sheet_dx);
		x.btn_dx.Anchors := btn_macro_move_sheet_dx.Anchors;
		x.btn_dx.Glyph.Assign(btn_macro_move_sheet_dx.Glyph);
		x.btn_dx.NumGlyphs := btn_macro_move_sheet_dx.NumGlyphs;
		x.btn_dx.OnClick := btn_macro_move_sheet_dxClick;
		x.btn_dx.Hint := btn_macro_move_sheet_dx.Hint;x.btn_dx.ShowHint := TRUE;
		x.btn_dx.Left := x.panel_header.clientWidth - x.btn_dx.Width;

		x.txt_descrizione := TMyLabel.Create(self);x.txt_descrizione.Parent := x.panel_header;
		set_control_pos_size(x.txt_descrizione, txt_macro_descrizione);
		x.txt_descrizione.Caption := txt_macro_descrizione.Caption;

		x.str_descrizione := TFEdit.Create(self);x.str_descrizione.Parent := x.panel_header;
		set_control_pos_size(x.str_descrizione, str_macro_descrizione);
		x.str_descrizione.AAA_NeedNotifyModification := FALSE;
		x.txt_descrizione.FocusControl := x.str_descrizione;
		x.str_descrizione.Anchors := str_macro_descrizione.Anchors;
		x.str_descrizione.OnChange := str_macro_descrizione.OnChange;
		x.str_descrizione.OnExit := str_macro_descrizione.OnExit;
		x.str_descrizione.MaxLength := 32;	// tanto per non esagerare

		x.txt_filename := TMyLabel.Create(self);x.txt_filename.Parent := x.panel_header;
		set_control_pos_size(x.txt_filename, txt_macro_filename);
		x.txt_filename.Caption := txt_macro_filename.Caption;

		x.str_filename := TFEdit.Create(self);x.str_filename.Parent := x.panel_header;
		set_control_pos_size(x.str_filename, str_macro_filename);
		x.str_filename.ShowHint := TRUE;x.str_filename.Hint := str_macro_filename.Hint;
		x.str_filename.AAA_NeedNotifyModification := FALSE;
		x.txt_filename.FocusControl := x.str_filename;
		x.str_filename.Anchors := str_macro_filename.Anchors;

		x.btn_filename_browse := TBitBtn_fede.create(self);x.btn_filename_browse.Parent := x.panel_header;
		set_control_pos_size(x.btn_filename_browse, btn_macro_filename_browse);
		x.btn_filename_browse.Caption := btn_macro_filename_browse.Caption;
		x.btn_filename_browse.ShowHint := TRUE;x.btn_filename_browse.Hint := btn_macro_filename_browse.Hint;
		x.btn_filename_browse.OnClick := btn_macro_filename_browse.OnClick;
		x.btn_filename_browse.Anchors := btn_macro_filename_browse.Anchors;
//		btn_macro_filename_browse.Glyph.Assign(x.btn_filename_browse.Glyph);

		x.btn_filename_reload := TBitBtn_fede.create(self);x.btn_filename_reload.Parent := x.panel_header;
		set_control_pos_size(x.btn_filename_reload, btn_macro_filename_reload);
		x.btn_filename_reload.Caption := btn_macro_filename_reload.Caption;
		x.btn_filename_reload.ShowHint := TRUE;x.btn_filename_reload.Hint := btn_macro_filename_reload.Hint;
		x.btn_filename_reload.OnClick := btn_macro_filename_reload.OnClick;
		x.btn_filename_reload.Anchors := btn_macro_filename_reload.Anchors;
		btn_macro_filename_reload.Glyph := NIL;
		btn_macro_filename_reload.Glyph := x.btn_filename_reload.Glyph;

		x.str_text := TFMemo.Create(self);x.str_text.Parent := x.sheet;
		x.str_text.Align := alClient;
//		x.str_text.Font.Assign(str_textS.Font);
		x.str_text.Font.Name := 'Courier New';x.str_text.Font.Size := 10;x.str_text.Font.Style := [fsBold];
		x.str_text.ScrollBars := memo_macros.ScrollBars;
		x.str_text.AAA_NeedNotifyModification := FALSE;

		x.txt_note := TMyLabel.Create(self);x.txt_note.Parent := x.panel_header;
		set_control_pos_size(x.txt_note, txt_macro_note);
		x.txt_note.Caption := txt_macro_note.Caption;

		x.str_note := TFMemo.Create(self);x.str_note.Parent := x.panel_header;
		x.str_note.Align := str_macro_note.Align;
		set_control_pos_size(x.str_note, str_macro_note);
//		x.str_note.Font.Name := 'Arial';x.str_note.Font.Size := 9;x.str_note.Font.Style := [];
		x.str_note.Font.Assign(str_macro_note.Font);
		x.str_note.ScrollBars := str_macro_note.ScrollBars;
		x.str_note.Anchors := str_macro_note.Anchors;
		x.str_note.AAA_NeedNotifyModification := FALSE
	end;

	procedure create_macros_tab(tipo : text_script_type);
	begin
		for var i : smallint := 0 to local_scripts[tipo].i_numero - 1 do begin
			inc(i_macro_tabs_used);
			if (length(macro_tabs) < i_macro_tabs_used) then create_tab;
//			apply_tab_values(tipo, @local_scripts[tipo].recs[i], i)
			apply_macros_tab_values(tipo, @local_scripts[tipo].recs[i], i)
		end
	end;

begin
	try
		bo_writing_scripts := TRUE;
		i_macro_tabs_used := 0;bo_totale := FALSE;
//		for var sxt : SQL_script_type := low(sxt) to high(sxt) do create_SQLS_tab(sxt);
		create_macros_tab(TST_MACRO_PARAMETRICHE);
		for var i : smallint := i_macro_tabs_used to high(macro_tabs) do begin macro_tabs[i].Sheet.Visible := FALSE;macro_tabs[i].Sheet.TabVisible := FALSE end;
		page_macro_scripts.Highlighted := bo_totale;
		pc_macro.Visible := (i_macro_tabs_used <> 0)
	finally
		bo_writing_scripts := FALSE
	end
end;

procedure Tdlg_impostazioni.read_macro_tabs;
begin
	if bo_writing_scripts then exit;
	var sxt : text_script_type := TST_MACRO_PARAMETRICHE;
	for var i : smallint := 0 to local_scripts[sxt].i_numero - 1 do begin
		var sx : text_script_record_punt := @local_scripts[sxt].recs[i];
		sx.str_descrizione := macro_tabs[i].str_descrizione.Text;
		sx.str_text := macro_tabs[i].str_text.Text;
		sx.str_note := macro_tabs[i].str_note.Text;
		sx.str_filename := macro_tabs[i].str_filename.Text;
		if (sx.str_filename <> '') then sx.str_filename := ChangeFileExt(sx.str_filename, GALATEO_MACRO_SCRIPT_FILE_EXT)
	end;

	// *DOPO* aver letto i dati aggiorno il numero degli scripts
	local_scripts[TST_MACRO_PARAMETRICHE].i_numero := i_macro_scripts.get_Asinteger(FALSE)
end;

procedure Tdlg_impostazioni.enable_macro_tabs;
begin
	if NOT bo_started then exit;
	if bo_writing_scripts then exit;
	btn_applica_macro_scripts.Enabled := (local_scripts[TST_MACRO_PARAMETRICHE].i_numero <> i_macro_scripts.get_Asinteger(FALSE));
	for var i : smallint := 0 to local_scripts[TST_MACRO_PARAMETRICHE].i_numero - 1 do begin
		macro_tabs[i].btn_sx.Enabled := (i > 0);										// non sul primo script di questo tipo
		macro_tabs[i].btn_dx.Enabled := (i < local_scripts[TST_MACRO_PARAMETRICHE].i_numero - 1)	// non sull'ultimo script di questo tipo
	end
end;

procedure Tdlg_impostazioni.move_macro_script(i_index, i_direzione : smallint);
var temp : macro_tab_type;
begin
//	if NOT bo_started OR NOT bo_writing_scripts then exit;
	{$ifdef DEBUG} assert(abs(i_direzione) = 1, 'WEEW 3912'); {$endif}

	// switcho le linguette sul TPageControl
	var i_target : smallint := i_index + i_direzione;
	macro_tabs[i_index].sheet.PageIndex := i_target;
	// switcho i records su SQL_tabs
	temp.copy_from(macro_tabs[i_index]);
	macro_tabs[i_index].copy_from(macro_tabs[i_target]);
	macro_tabs[i_target].copy_from(temp);
	macro_tabs[i_index].assign_tab_index(TST_MACRO_PARAMETRICHE, i_index, macro_tabs[i_index].str_descrizione.Text);
	macro_tabs[i_target].assign_tab_index(TST_MACRO_PARAMETRICHE, i_index + i_direzione, macro_tabs[i_target].str_descrizione.Text);
	enable_macro_tabs
end;

procedure Tdlg_impostazioni.delete_macro_script(i_index : smallint);
begin
	if (i_index < i_macro_tabs_used - 1) then begin
		pc_macro.Pages[i_index].PageIndex := i_macro_tabs_used - 1;		// sposto la linguetta sul fondo
		move(macro_tabs[i_index+1], macro_tabs[i_index], sizeof(macro_tab_type) * (i_macro_tabs_used - i_index - 1))
	end;
	dec(i_macro_tabs_used);i_macro_scripts.set_Asinteger(i_macro_tabs_used);
	pc_macro.Pages[i_macro_tabs_used].TabVisible := FALSE;

	pc_macro.ActivePageIndex := min(i_macro_tabs_used - 1, i_index);
	pc_macro.Pages[pc_macro.ActivePageIndex].Highlighted := TRUE;
	enable_macro_tabs;enable_ctrls
end;

procedure Tdlg_impostazioni.applica_modifica_numero_scripts_macro;
begin
	if bo_writing_scripts then exit;
	read_macro_tabs;
	create_and_write_macro_table;
	enable_macro_tabs
end;

procedure Tdlg_impostazioni.load_file_macro_text_script(i_index : smallint;str_filename : string);
const MBOX_CAPTION = 'File Macro';
var
	x : text_script_record_type;
	str_error : string;
begin
	if NOT text_script_file_read(@x, str_filename, MBOX_CAPTION, str_error) then begin
		MessageBBox(handle, 'Errore durante l''interpretazione del file ' + str_filename + ACAPO2 + str_error, MBOX_CAPTION, MB_ICONSTOP);
		exit
	end;

	write_macro_tab(i_index, @x)
end;

procedure Tdlg_impostazioni.btn_macro_filename_browseClick(Sender : TObject);
const MBOX_CAPTION = 'File Macro';
var btn : TBitBtn_fede absolute sender;
begin
	{$ifdef DEBUG} assert(btn is TBitBtn_fede, 'LJWE 3912'); {$endif}
	var i : smallint := btn.Tag;var pt : macro_tab_punt := @macro_tabs[i];
	if (pt.str_text.Text <> '') AND (MessageBBox(handle,
		'ATTENZIONE: caricando un nuovo file si perderà il contenuto attuale dello script.' + ACAPO2 + 'Vuoi continuare comunque?',
		MBOX_CAPTION, MB_QUESTION_DEFBUTTON2) <> IDYES) then exit;
	var str_filename : string := pt.str_filename.Text;
	if NOT browse_for_files_open(self, 'Carica file macro', str_filename, GALATEO_MACRO_SCRIPT_FILE_EXT, GALATEO_MACRO_SCRIPT_FILE_FILTER,
		{path}ifs(globale.str_filename, ExtractFilePath(globale.str_filename))) then exit;

	load_file_macro_text_script(i, str_filename)
end;

procedure Tdlg_impostazioni.btn_macro_filename_reloadClick(Sender : TObject);
const MBOX_CAPTION = 'File Macro';
var
	i : smallint;
	str_filename : string;
	btn : TBitBtn_fede absolute sender;
	pt : macro_tab_punt;
begin
	{$ifdef DEBUG} assert(btn is TBitBtn_fede, 'LJWE 3913'); {$endif}
	i := btn.Tag;pt := @macro_tabs[i];
	str_filename := pt.str_filename.Text;
	if (str_filename = '') then begin beep;exit end;

	if (pt.str_text.Text <> '') AND (MessageBBox(handle,
		'ATTENZIONE: eventuali modifiche di questo script non ancora salvate saranno perse.' + ACAPO2 + 'Vuoi continuare comunque?',
		MBOX_CAPTION, MB_QUESTION_DEFBUTTON2) <> IDYES) then exit;
	load_file_macro_text_script(i, str_filename)
end;

procedure Tdlg_impostazioni.btn_macro_addClick(Sender : TObject);
begin
	if (MessageBBox(handle, 'Vuoi aggiungere un foglio di macro ?', MBOX_CAPTION, MB_QUESTION) <> IDYES) then exit;
	i_macro_scripts.set_Asinteger(i_macro_tabs_used + 1);
	applica_modifica_numero_scripts_macro;
	pc_macro.ActivePageIndex := i_macro_tabs_used - 1;
	pc_macro.Pages[pc_macro.ActivePageIndex].Highlighted := TRUE
end;

procedure Tdlg_impostazioni.btn_macro_deleteClick(Sender : TObject);
begin
	if (MessageBBox(handle, 'Vuoi eliminare il presente foglio di macro ?', MBOX_CAPTION, MB_QUESTION_DEFBUTTON2) <> IDYES) then exit;
	delete_macro_script(pc_macro.ActivePageIndex)
end;

procedure Tdlg_impostazioni.load_file_SQL_text_script(i_sheet_index : smallint;str_filename : string);
const MBOX_CAPTION = 'File SQL script';
var
	x : text_script_record_type;
	str_error : string;
begin
	if NOT text_script_file_read(@x, str_filename, MBOX_CAPTION, str_error) then begin
		MessageBBox(handle, 'Errore durante l''interpretazione del file ' + str_filename + ACAPO2 + str_error, MBOX_CAPTION, MB_ICONSTOP);
		exit
	end;

	write_SQL_script_tab(i_sheet_index, @x)
end;

procedure Tdlg_impostazioni.btn_SQLS_filename_browse_00Click(Sender : TObject);
const MBOX_CAPTION = 'File SQL script';
var
	i : smallint;
	str_filename : string;
	btn : TBitBtn_fede absolute sender;
	pt : SQL_tab_punt;
begin
	{$ifdef DEBUG} assert(btn is TBitBtn_fede, 'LXWE 3922'); {$endif}
	i := btn.Tag;pt := @SQL_tabs[i];
	if (pt.str_text.Text <> '') AND (MessageBBox(handle,
		'ATTENZIONE: caricando un nuovo file si perderà il contenuto attuale dello script.' + ACAPO2 + 'Vuoi continuare comunque?',
		MBOX_CAPTION, MB_QUESTION_DEFBUTTON2) <> IDYES) then exit;
	str_filename := pt.str_filename.Text;
	if NOT browse_for_files_open(self, 'Carica file script SQL', str_filename, GALATEO_SQL_SCRIPT_FILE_EXT, GALATEO_SQL_SCRIPT_FILE_FILTER,
		{path}ifs(globale.str_filename, ExtractFilePath(globale.str_filename))) then exit;

	load_file_SQL_text_script(i, str_filename)
end;

procedure Tdlg_impostazioni.btn_SQLS_filename_reload_00Click(Sender : TObject);
const MBOX_CAPTION = 'File SQL script';
var
	i : smallint;
	str_filename : string;
	btn : TBitBtn_fede absolute sender;
	pt : SQL_tab_punt;
begin
	{$ifdef DEBUG} assert(btn is TBitBtn_fede, 'LXWE 3923'); {$endif}
	i := btn.Tag;pt := @SQL_tabs[i];
	str_filename := pt.str_filename.Text;
	if (str_filename = '') then begin beep;exit end;

	if (pt.str_text.Text <> '') AND (MessageBBox(handle,
		'ATTENZIONE: eventuali modifiche di questo script non ancora salvate saranno perse.' + ACAPO2 + 'Vuoi continuare comunque?',
		MBOX_CAPTION, MB_QUESTION_DEFBUTTON2) <> IDYES) then exit;
	load_file_SQL_text_script(i, str_filename)
end;
