unit macros_elenco;

{$ifdef DLL} *** {$endif}

{$I defines}

interface

uses Db, SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Menus, Math, Buttons, ExtCtrls,
	Fcommons, Gdich;

procedure macros_elenco_proc(father : TForm);

type
  Tdlg_elenco_macros = class(TForm)
	 lb: TListBox;
	 menu: TMainMenu;
	 File1: TMenuItem;
	 itm_close: TMenuItem;
	 itm_primo_piano: TMenuItem;
	 N1: TMenuItem;
	 Panel1: TPanel;
	 btn_load: TBitBtn;
	 str_definizione: TMemo;
	 split: TSplitter;
	 itm_copy: TMenuItem;
	 itm_modifica: TMenuItem;
	 btn_copy: TBitBtn;
	 Popup: TPopupMenu;
	 itp_copy: TMenuItem;
	 itp_load: TMenuItem;
	 itm_load: TMenuItem;
	 procedure FormCreate(Sender : TObject);
	 procedure FormClose(Sender : TObject;var Action : TCloseAction);
	 procedure lbDblClick(Sender : TObject);
	 procedure itm_closeClick(Sender : TObject);
	 procedure itm_primo_pianoClick(Sender : TObject);
	 procedure btn_loadClick(Sender : TObject);
	 procedure FormResize(Sender : TObject);
	 procedure lbClick(Sender : TObject);
	 procedure FormDestroy(Sender : TObject);
	 procedure itm_copyClick(Sender : TObject);
	 procedure btn_copyClick(Sender : TObject);
	 procedure itm_loadClick(Sender : TObject);
	 procedure itp_loadClick(Sender : TObject);
	 procedure itp_copyClick(Sender : TObject);
	 procedure FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
  private
		bo_dont_open : boolean;
		procedure exec;
		procedure copy_clipboard;
		function get_definizione(i_macro : smallint) : string;
		procedure enable_ctrls;
  public
		constructor xcreate(father : TForm);
		procedure update_lbox(bo_keep_pos : boolean);
  end;

implementation

{$R *.DFM}

uses FAssert, FErrMsg, FXStrings, FStrings, FMessage, FSystem_base, FSystem, FTrans,
	galateo_debug, galateo_main, Gun, objects, pages, proc, sezione;

const
	MBOX_CAPTION = 'Elenco macro disponibili';

var dlg : Tdlg_elenco_macros;

procedure macros_elenco_proc(father : TForm);
begin
	if (dlg = NIL) then begin
		if (globale.macro_parametriche = NIL) then MessageBBox(get_handle(father), 'Nessuna macro definita', MBOX_CAPTION)
		else dlg := Tdlg_elenco_macros.xcreate(GM)
	end
	else begin dlg.SetFocus;dlg.update_lbox(TRUE) end
end;

constructor Tdlg_elenco_macros.xcreate(father : TForm);
begin
	bo_dont_open := TRUE;
	inherited create(father);
//	parent := father;
	if bo_dont_open then abort;
	visible := TRUE
end;

procedure Tdlg_elenco_macros.FormCreate(Sender : TObject);
begin
	update_lbox(FALSE);
//	left := 50;width := GetSystemMetrics(SM_CXFULLSCREEN) div 4;
//	top := 50;height := GetSystemMetrics(SM_CYFULLSCREEN) - top*2;
	IO_form_size_and_pos(self, FALSE, name);
	itm_primo_piano.Checked := (Formstyle = fsStayOnTop);
	enable_ctrls;
	bo_dont_open := FALSE
end;

procedure Tdlg_elenco_macros.FormDestroy(Sender : TObject);
begin
	dlg := NIL
end;

procedure Tdlg_elenco_macros.FormClose(Sender: TObject;var Action: TCloseAction);
begin
	IO_form_size_and_pos(self, TRUE, name);
	action := caFree
end;

procedure Tdlg_elenco_macros.exec;
begin
end;

procedure Tdlg_elenco_macros.update_lbox(bo_keep_pos : boolean);
var i : smallint;
begin
	lb.Items.clear;
	for i := 0 to length(globale.macro_parametriche)-1 do lb.Items.add(globale.macro_parametriche[i].str_nome)
end;

procedure Tdlg_elenco_macros.lbDblClick(Sender : TObject); begin exec end;
procedure Tdlg_elenco_macros.btn_loadClick(Sender : TObject); begin exec end;
procedure Tdlg_elenco_macros.itm_loadClick(Sender : TObject); begin exec end;
procedure Tdlg_elenco_macros.itp_loadClick(Sender : TObject); begin exec end;
procedure Tdlg_elenco_macros.itp_copyClick(Sender : TObject); begin copy_clipboard end;
procedure Tdlg_elenco_macros.itm_copyClick(Sender : TObject); begin copy_clipboard end;
procedure Tdlg_elenco_macros.btn_copyClick(Sender : TObject); begin copy_clipboard end;
procedure Tdlg_elenco_macros.itm_closeClick(Sender : TObject); begin close end;

procedure Tdlg_elenco_macros.itm_primo_pianoClick(Sender : TObject);
begin
	itm_primo_piano.Checked := NOT itm_primo_piano.Checked;
	if itm_primo_piano.Checked then FormStyle := fsStayOnTop else FormStyle := fsNormal
end;

procedure Tdlg_elenco_macros.FormResize(Sender : TObject);
begin {btn_load.Left := (clientwidth - btn_load.Width) div 2 - 1} end;

function Tdlg_elenco_macros.get_definizione(i_macro : smallint) : string;
var
	i : smallint;
	m : cl_macro_parametrica;
begin
	result := '';
	if (i_macro = -1) OR (i_macro > length(globale.macro_parametriche) - 1) then exit;
	m := globale.macro_parametriche[i_macro];
	if (m.parms = NIL) then result := ' ( )'
	else begin
		for i := 0 to length(m.parms)-1 do add_delimited(result, m.parms[i], ' , ');
		result := ' ( ' + result + ' )'
	end;
	result := m.str_nome + result
end;

procedure Tdlg_elenco_macros.lbClick(Sender : TObject);
var i : smallint;
begin
	enable_ctrls;
	i := lb.ItemIndex;
	if (i = -1) OR (i > length(globale.macro_parametriche) - 1) then exit;
	str_definizione.Text := get_definizione(i) + ' = ' + ACAPO + globale.macro_parametriche[i].str_macro
end;

procedure Tdlg_elenco_macros.copy_clipboard;
var
	i : smallint;
	s : string;
begin
	i := lb.ItemIndex;if (i = -1) then begin MessageBBox(handle, 'Seleziona una macro', MBOX_CAPTION);exit end;
	s := get_definizione(i);
	sostituisci(s, ' ', '');
	if (s = '') then begin MessageBBox(handle, 'Errore durante la copia della definizione', MBOX_CAPTION);exit end;
	str2clipboard('$' + s);beep
end;

procedure Tdlg_elenco_macros.enable_ctrls;
var bo : boolean;
begin
	bo := (lb.ItemIndex <> -1);
	btn_load.Enabled := bo;itp_load.Enabled := bo;itm_load.Enabled := bo;
	btn_copy.Enabled := bo;itp_copy.Enabled := bo;itm_copy.Enabled := bo
end;

procedure Tdlg_elenco_macros.FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
begin
	case key of
		VK_ESCAPE : close
	end
end;

initialization
	galateo_initialization_debug('macros_elenco')
finalization
	galateo_finalization_debug('macros_elenco')
end.
