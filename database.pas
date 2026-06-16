unit Database;	//*

{$ifdef DLL} *** {$endif}

{$I defines}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, StdCtrls, Buttons, DB, ExtCtrls, Math,
	FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
	FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
	Fcommons, Federico, FDB, FBitBtn,
	Gdich, proc, GUN;

//function xdatabase_proc(father : TForm;var bo_alias,bo_login_prompt : boolean;var str_driver, str_table, str_parametri_connessione : string) : boolean;
function xdatabase_proc(father : TForm;pt_config : connection_configuration_punt) : boolean;

type
  Tdlg_database = class(TForm)
	 txt_driver: TLabel;
	 btn_disabilita: TFBitBtn;
	 cb_driver: TComboBox;
	 btn_filename: TFBitBtn;
	 txt_table: TLabel;
	 cb_table: TComboBox;
	 tbl: TTable;
	 rb_alias_driver: TRadioGroup;
	 SQL_image: TImage;
	 txt_connessione: TLabel;
	 str_connessione: TMemo;
	 btn_ok: TFBitBtn;
	 btn_cancel: TFBitBtn;
	 cbx_login_prompt: TFCheckBox;
	 btn_help: TFBitBtn;
	 btn_ASA: TFBitBtn;
	 btn_SQLserver: TFBitBtn;
	 btn_ODBC_admin: TFBitBtn;
	 cbx_ODBC_system: TFCheckBox;
	 cbx_ODBC_user: TFCheckBox;
	 btn_mysql: TFBitBtn;
	 gbox_profilo: TFGroupBox;
	 str_profile: TFEdit;
	 txt_profile_path: TMyLabel;
	 btn_browse_profile_path: TFBitBtn;
	 str_profile_path: TFEdit;
	 cbx_read_from_profile: TFCheckBox;
	 btn_jolly_profile: TFBitBtn;
	 btn_profilo_edit: TFBitBtn;
    btn_check_connection: TFBitBtn;
    btn_browse_profiles: TFBitBtn;
    cbx_verifica_connessione: TFCheckBox;
	 procedure btn_cancelClick(Sender : TObject);
	 procedure btn_okClick(Sender : TObject);
	 procedure FormCreate(Sender : TObject);
	 procedure btn_disabilitaClick(Sender : TObject);
	 procedure btn_filenameClick(Sender : TObject);
	 procedure FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
	 procedure btn_helpClick(Sender : TObject);
	 procedure btn_ASAClick(Sender : TObject);
	 procedure btn_SQLserverClick(Sender : TObject);
	 procedure btn_ODBC_adminClick(Sender : TObject);
	 procedure cbx_ODBC_userClick(Sender : TObject);
	 procedure cbx_ODBC_systemClick(Sender : TObject);
	 procedure btn_mysqlClick(Sender : TObject);
	 procedure generic_enable_ctrls(Sender : TObject);
	 procedure btn_browse_profile_pathClick(Sender : TObject);
	 procedure btn_jolly_profileClick(Sender : TObject);
	 procedure btn_profilo_editClick(Sender : TObject);
	 procedure btn_check_connectionClick(Sender : TObject);
    procedure btn_browse_profilesClick(Sender : TObject);
  private
		pt_bo_ok : boolean_punt;
		pt_config : connection_configuration_punt;
		procedure enable_ctrls;
		procedure execute(bo_close : boolean = TRUE);
		procedure load_ODBC_data_sources;
		procedure profilo_edit;
		procedure browse_profiles;
		constructor xcreate(father : TForm;pt_config : connection_configuration_punt;pt_bo_ok : boolean_punt);
  end;

implementation

uses FErrMsg, FXStrings, FStrings, FSystem, FMessage, FRegistry, FCtrls, FCtrls_RX, FBrowse, database_dialog, FFile, domanda_multipla,
	pages;

{$R *.DFM}

const
	MBOX_CAPTION = 'Connessione a database';
	NUM_LAST_OBJS = 5;
	INI_LAST_FILES_CAPTION = 'ultimi drivers utilizzati';
	INI_LAST_DRIVERS = 'driver #';
	INI_LAST_TABLES = 'table #';

{function xdatabase_proc(father : TForm;var bo_alias,bo_login_prompt : boolean;
	var str_driver,str_table, str_parametri_connessione : string) : boolean;
begin
	var dlg := Tdlg_database.xCreate(father, bo_alias, bo_login_prompt, str_driver, str_table, str_parametri_connessione, @result);
	dlg.ShowModal;dlg.Free
end;}

function xdatabase_proc(father : TForm;pt_config : connection_configuration_punt) : boolean;
begin
	var dlg := Tdlg_database.xCreate(father, pt_config, @result);
	dlg.ShowModal;dlg.Free
end;

constructor Tdlg_database.xcreate(father : TForm;pt_config : connection_configuration_punt;pt_bo_ok : boolean_punt);
begin
	self.pt_config := pt_config;
	self.pt_bo_ok := pt_bo_ok;
	inherited create(father)
end;

procedure Tdlg_database.FormCreate(Sender : TObject);
begin
{	if (globale.bo_report) then begin
		cb_table.Enabled := FALSE;txt_table.Enabled := FALSE;
		btn_filename.Enabled := FALSE;
		pt_str_table^ := ''
	end; }

	cb_table.Text := pt_config.str_table;
	cb_driver.Text := pt_config.str_driver;
	str_connessione.Text := pt_config.str_parametri_connessione;
	cbx_read_from_profile.Checked := pt_config.bo_read_from_profile;
	str_profile.Text := pt_config.str_profile;str_profile_path.Text := pt_config.str_profile_path;
	if {pt_config.bo_alias}TRUE then rb_alias_driver.ItemIndex := 0 else rb_alias_driver.ItemIndex := 1;
	cbx_login_prompt.Checked := pt_config.bo_login_prompt;

	load_ODBC_data_sources;

	var lp : LPSTR := stralloc(256);
{	for i := 1 to NUM_LAST_OBJS do begin
		Windows.GetPrivateProfileString(INI_LAST_FILES_CAPTION, asciiz(INI_LAST_DRIVERS+inttostr(i)),'',lp,256,FILE_INI);
		if (strlen(lp) = 0) then break;
		cb_driver.Items.add(lowercase(strpas(lp)))
	end; }
	for var i : smallint := 1 to NUM_LAST_OBJS do begin
//		Windows.GetPrivateProfileString(INI_LAST_FILES_CAPTION, asciiz(INI_LAST_TABLES + inttostr(i)), '', lp, 256, FILE_INI);
		var ws : WideString := INI_LAST_TABLES + i.ToString;
		Windows.GetPrivateProfileString(INI_LAST_FILES_CAPTION, @ws, '', lp, 256, FILE_INI);
		if (strlen(lp) = 0) then break;
		cb_table.Items.add(lowercase(strpas(lp)))
	end;
	strdispose(lp);
	enable_ctrls;
	{$ifdef DEBUG} check_components(self) {$endif DEBUG}
end;

procedure Tdlg_database.load_ODBC_data_sources;
begin
	var s : string := cb_driver.Text;
	load_ODBC_sources(cb_driver.Items, cbx_ODBC_user.Checked, cbx_ODBC_system.Checked);
	cb_driver.Text := s
end;

procedure Tdlg_database.btn_cancelClick(Sender : TObject); begin close end;
procedure Tdlg_database.btn_check_connectionClick(Sender : TObject); begin execute(FALSE) end;
procedure Tdlg_database.btn_okClick(Sender : TObject); begin execute end;
procedure Tdlg_database.btn_profilo_editClick(Sender : TObject); begin profilo_edit end;
procedure Tdlg_database.cbx_ODBC_userClick(Sender : TObject); begin load_ODBC_data_sources end;
procedure Tdlg_database.generic_enable_ctrls(Sender : TObject); begin enable_ctrls end;
procedure Tdlg_database.cbx_ODBC_systemClick(Sender : TObject); begin load_ODBC_data_sources end;
procedure Tdlg_database.btn_browse_profilesClick(Sender : TObject); begin browse_profiles end;
procedure Tdlg_database.btn_browse_profile_pathClick(Sender : TObject); begin browse_directory(self, 'Directory profilo', str_profile_path) end;
procedure Tdlg_database.btn_ODBC_adminClick(Sender : TObject); begin WinExecAndWait32('odbcad32.exe', FALSE, 0, FALSE) end;
procedure Tdlg_database.btn_helpClick(Sender : TObject); begin help_proc(self, HELP_DATABASE_CONNECTION) end;
procedure Tdlg_database.btn_jolly_profileClick(Sender : TObject); begin str_profile.Text := 'JOLLY';str_connessione.Text := '' end;

procedure Tdlg_database.enable_ctrls;
begin
	var bo_profilo := cbx_read_from_profile.Checked;
	enable_FC(txt_driver, NOT bo_profilo);
	enable_FC(txt_table, NOT bo_profilo);
	cbx_ODBC_user.Enabled := NOT bo_profilo;
	cbx_ODBC_system.Enabled := NOT bo_profilo;
	rb_alias_driver.Enabled := NOT bo_profilo;
	enable_FC(txt_connessione, NOT bo_profilo);
	btn_ASA.Enabled := NOT bo_profilo;
	btn_SQLserver.Enabled := NOT bo_profilo;
	btn_mysql.Enabled := NOT bo_profilo;
	btn_ODBC_admin.Enabled := NOT bo_profilo;

	make_all_children_enabled(gbox_profilo, bo_profilo);
	if NOT bo_profilo then make_all_fathers_enabled(cbx_read_from_profile)
end;

procedure Tdlg_database.execute(bo_close : boolean = TRUE);
label retry;
begin
	var config : cl_connection_configuration := cl_connection_configuration.Create(self);
	try
		cb_driver.Text := lowercase(togliblanks(cb_driver.Text));
//		config.bo_alias := (rb_alias_driver.ItemIndex = 0);
		config.bo_login_prompt := cbx_login_prompt.Checked;
		config.str_driver := cb_driver.Text;
		config.str_table := lowercase(togliblanks(cb_table.Text));
		config.str_parametri_connessione := togli_ACAPO_finali(str_connessione.Text);
		config.bo_read_from_profile := cbx_read_from_profile.Checked;
		config.str_profile := str_profile.Text;
		config.str_profile_path := str_profile_path.Text;

		if config.bo_read_from_profile then begin
			if (config.str_profile = '') then begin
				MessageBBox(handle, 'Profilo non specificato', MBOX_CAPTION, MB_ICONSTOP);
				exit
			end
		end
		else begin
			if (config.str_driver = '') AND (config.str_table = '') then begin
				MessageBBox(handle, 'E'' necessario specificare almeno uno tra:' + ACAPO2 +
					'il tipo di driver' + ACAPO + 'l''alias' + ACAPO + 'la tavola da cui leggere i dati' + ACAPO + 'i parametri di connessione', MBOX_CAPTION);
				exit
			end
		end;

		if config.bo_read_from_profile OR (config.str_driver <> '') then begin
			var dbx : TFDatabase := globale.system_database;
			var bo_login_prompt := config.bo_login_prompt;		// deve essere una variabile staccata
retry:
			try
				dbx.Connected := FALSE;	// solo per sicurezza
				if config.bo_read_from_profile then begin
					var bo_access_not_allowed : boolean;
					if NOT config.read_profile(globale.str_filename, @bo_access_not_allowed) then
						raise exception.create(ifs(bo_access_not_allowed,
							'Galateo non ha diritto di utilizzare il profilo specificato',
							'Profilo <' + config.str_profile + '> non accessibile'));
					dbx.Params.Text := config.database_parms.asstring
				end
				else begin
					if {pt_bo_alias^}TRUE then dbx.Aliasname := config.str_driver else dbx.Drivername := config.str_driver;
					dbx.Params.Text := config.str_parametri_connessione;
				end;
				dbx.LoginPrompt := bo_login_prompt;
				dbx.Connected := TRUE
			except
				error_msg(self, 'Connessione non riuscita', MBOX_CAPTION);
				if bo_login_prompt then abort
			end;
			if NOT bo_login_prompt AND NOT dbx.Connected then begin
				bo_login_prompt := TRUE;
				goto retry
			end
		end;

//		if NOT globale.bo_report then begin
		if (globale.tiporeport = TR_LABEL_STANDALONE) then begin
			try
				tbl.Active := FALSE;	// per sicurezza
				if (config.str_driver = '') then tbl.DatabaseName := '' else tbl.DatabaseName := globale.system_database.Name;
				tbl.TableName := config.str_table;
				tbl.Active := TRUE;tbl.Active := FALSE
			except
				error_msg(self, 'Driver OK, ma tavola non riconosciuta', MBOX_CAPTION);
				abort
			end
		end;

		if bo_close then begin	// procedo a salvare i dati e chiudere la maschera
			pt_bo_ok^ := TRUE;

			Windows.WritePrivateProfileString(INI_LAST_FILES_CAPTION, NIL, '', FILE_INI);

			// scrittura ultime n tables utilizzate
			WritePrivateProfileString(INI_LAST_FILES_CAPTION, INI_LAST_TABLES + (1).Tostring, config.str_table, FILE_INI);
			var i : smallint := cb_table.Items.indexof(config.str_table);
			if (i <> -1) then cb_table.Items.delete(i);
			for i := 0 to min(NUM_LAST_OBJS-2,cb_table.Items.Count-1) do begin
				WritePrivateProfileString(INI_LAST_FILES_CAPTION, INI_LAST_TABLES + (i+2).ToString, cb_table.Items.strings[i], FILE_INI);
				cb_table.Items.add(cb_table.Items.strings[i])
			end;

			// scrittura ultimi n drivers utilizzati
			WritePrivateProfileString(INI_LAST_FILES_CAPTION, INI_LAST_DRIVERS + (1).ToString, cb_driver.Text, FILE_INI);

			i := cb_driver.Items.indexof(cb_driver.Text);
			if (i <> -1) then cb_driver.Items.delete(i);
			for i := 0 to min(NUM_LAST_OBJS-2,cb_driver.Items.Count-1) do begin
				WritePrivateProfileString(INI_LAST_FILES_CAPTION, INI_LAST_DRIVERS + (i+2).ToString, cb_driver.Items.strings[i], FILE_INI);
				cb_driver.Items.add(cb_driver.Items.strings[i])
			end;

			pt_config.assign(config);
			if (config.str_parametri_connessione <> '') AND (globale.str_password_edit = '') then
				MessageBBox(handle, 'Per garantire la sicurezza dei parametri di connessione è consigliabile impostare la password di limitazione dell''apertura del report', MBOX_CAPTION);
			close
		end
		else MessageBBox(handle, 'Connessione eseguita', MBOX_CAPTION)
	finally
		config.free
	end
end;

procedure Tdlg_database.btn_disabilitaClick(Sender : TObject);
begin
	if (MessageBBox(handle, 'Vuoi veramente disabilitare il collegamento al database?', MBOX_CAPTION, MB_QUESTION) <> IDYES) then exit;
	pt_config^.clear;pt_bo_ok^ := TRUE;
	close
end;

procedure Tdlg_database.btn_filenameClick(Sender : TObject);
begin
//	opendlg.filename := cb_table.Text;
	var str_filename : string := cb_table.Text;
//	if NOT opendlg.execute then exit;
	if NOT browse_for_files_open(self, 'Apri sorgente dati', str_filename, '.DBF', 'files dBase (*.dbf)|*.dbf|tutti i files (*.*)|*.*', {default_dir}'') then exit;
//	cb_table.Text := opendlg.filename
	cb_table.Text := str_filename
end;

procedure Tdlg_database.btn_ASAClick(Sender : TObject);
const
	FDAC_USERNAME = 'USER_NAME=';
	FDAC_PASSWORD = 'PASSWORD=';
	FDAC_HOST = 'HOST=';
	FDAC_SERVER = 'SERVER=';
	FDAC_DATABASE = 'DATABASE=';
	FDAC_PORT = 'PORT=';
begin
	cb_driver.Text := 'jolly';cb_table.Text := '';
//	str_connessione.Text := 'UID=' + ACAPO + 'PWD='
	str_connessione.Text := 'DriverID=ASA' + ACAPO +
		FDAC_USERNAME + 'jop' + ACAPO + FDAC_PASSWORD + 'jpw' + ACAPO +
		'//' + FDAC_HOST + ACAPO + FDAC_SERVER + 'jolly' + ACAPO + FDAC_DATABASE + 'jolly' + ACAPO +
		'//' + FDAC_PORT + '0'
end;

procedure Tdlg_database.FormKeyDown(Sender : TObject; var Key : Word;Shift : TShiftState); begin if key_button(key, VK_F9, btn_ok, activecontrol <> str_connessione) then exit end;
procedure Tdlg_database.btn_SQLserverClick(Sender : TObject); begin str_connessione.Text := 'USER NAME=' + ACAPO + 'PASSWORD=' end;
procedure Tdlg_database.btn_mysqlClick(Sender : TObject); begin str_connessione.Text := 'user name=' + ACAPO + 'password=' + ACAPO + 'database=' + ACAPO + 'server=' end;

procedure Tdlg_database.profilo_edit;
begin
	if (str_profile.Text = '') then begin
		MessageBBox(handle, 'Seleziona un profilo da modificare', MBOX_CAPTION, MB_ICONSTOP);
		exit
	end;
	var str_path := str_profile_path.Text;
	if (str_path <> '') AND NOT DirectoryExists(str_path) then begin
		MessageBBox(handle, 'Il path <' + str_path + '> non esiste o non è raggiungibile', MBOX_CAPTION, MB_ICONSTOP);
		exit
	end;
//	database_login_proc(self, {has_supervisor_rights}TRUE, {parms}NIL, str_profile.Text, str_path)
	database_login_proc(self, {has_supervisor_rights}FALSE, {parms}NIL, str_profile.Text, str_path)
end;

procedure Tdlg_database.browse_profiles;
begin
	var it : TStrings := TstringList.create;
	var str_path : string := coalesce(str_profile_path.Text, extractFilePath(Paramstr(0)));
	try
		load_filenames(it, make_filename('*' + FDB_DEFAULT_CONFIGURATION_FILE_SUFFIX, str_path));
		it.Text := uppercase(it.Text);
		sort(it);
		sostituisci(it, FDB_DEFAULT_CONFIGURATION_FILE_SUFFIX, '', {ignore_case}TRUE);
		var i : smallint := domanda_multipla_tstring(self, 'Seleziona profilo connessione', 'Seleziona il profilo di connessione' + ACAPO + 'path: ' + str_path,
			{default}it.IndexOf(uppercase(str_profile.Text)), it);
		if (i <> -1) then str_profile.Text := it[i]
	finally
		it.free
	end
end;

initialization
//	initialization_debug('database')
end.
