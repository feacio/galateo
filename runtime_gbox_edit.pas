unit runtime_gbox_edit;

{$ifdef DLL} *** {$endif}
{$I defines}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls,
	FBitBtn, Federico, Gdich, proc{, runtime_proc};

function runtime_gbox_edit_proc(father : TForm;gx : cl_runtime_groupbox) : boolean;
// rende TRUE in caso di modifiche

type
	Tdlg_gbox_edit = class(TForm)
    btn_cancel: TFBitBtn;
	 btn_help: TFBitBtn;
	 gbox: TGroupBox;
	 txt_descrizione: TMyLabel;
	 str_descrizione: TFEdit;
    btn_group_text_color: TFBitBtn;
    btn_group_back_color: TFBitBtn;
    btn_objs_back_color: TFBitBtn;
    btn_objs_text_color: TFBitBtn;
    btn_ok: TFBitBtn;
    btn_colori_default: TFBitBtn;
    txt_parameter_window: TMyLabel;
    i_parameter_window: TFEdit;
    cbx_on_exit: TFCheckBox;
    cbx_on_creating: TFCheckBox;
	 procedure FormCreate(Sender : TObject);
	 procedure btn_okClick(Sender : TObject);
	 procedure btn_cancelClick(Sender : TObject);
	 procedure FormDestroy(Sender : TObject);
    procedure btn_group_text_colorClick(Sender : TObject);
    procedure btn_colori_defaultClick(Sender : TObject);
    procedure btn_group_back_colorClick(Sender : TObject);
	 procedure btn_objs_text_colorClick(Sender : TObject);
    procedure btn_objs_back_colorClick(Sender : TObject);
	 procedure FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
	 procedure btn_helpClick(Sender : TObject);
    procedure AAA_notify_modification(Sender : TObject);
		private
			gx : cl_runtime_groupbox;
			gx_external : cl_runtime_groupbox;
			pt_bo_result : ^boolean;
			lo_gruppo_text_color_originale, lo_gruppo_back_color_originale : TColor;
			lo_default_text_color_originale, lo_default_back_color_originale : TColor;
			function get_color(lo_colore, lo_colore_originale : TColor) : TColor;
			function read : boolean;
			procedure write;
			constructor xcreate(father : TForm;gx : cl_runtime_groupbox;var bo_result : boolean);
  end;

implementation

uses galateo_debug, Fcommons, FCtrls,
	pages, help;

{$R *.DFM}

const
	MBOX_CAPTION = 'Gruppo parametri RUNTIME';

function runtime_gbox_edit_proc(father : TForm;gx : cl_runtime_groupbox) : boolean;
begin
	var dlg : Tdlg_gbox_edit := Tdlg_gbox_edit.xCreate(father,gx, result);
	dlg.ShowModal;dlg.Free
end;

constructor Tdlg_gbox_edit.xcreate(father: TForm;gx: cl_runtime_groupbox;var bo_result : boolean);
begin
	self.gx_external := gx;
	self.gx := cl_runtime_groupbox.create;
	self.gx.assign(gx);
	pt_bo_result := @bo_result;bo_result := FALSE;
	inherited create(father)
end;

procedure Tdlg_gbox_edit.FormCreate(Sender : TObject);
begin
	caption := MBOX_CAPTION;
	lo_gruppo_text_color_originale := gbox.Font.Color;
	lo_gruppo_back_color_originale := gbox.Color;
	lo_default_text_color_originale := str_descrizione.Font.Color;
	lo_default_back_color_originale := str_descrizione.Color;
	write;
	{$ifdef DEBUG} check_components(self) {$endif DEBUG}
end;

procedure Tdlg_gbox_edit.FormDestroy(Sender : TObject);
begin
	if (gx <> NIL) then begin gx.free;gx := NIL end
end;

procedure Tdlg_gbox_edit.btn_okClick(Sender : TObject);
begin
	if NOT btn_ok.Focused then btn_ok.SetFocus;
	if (read) then begin pt_bo_result^ := TRUE;close end
end;

procedure Tdlg_gbox_edit.btn_cancelClick(Sender : TObject); begin close end;
procedure Tdlg_gbox_edit.btn_helpClick(Sender : TObject); begin help_proc(self, HELP_RUNTIME_PARMS, HELP_RUNTIME_PARMS_GBOXES_SEGNALIBRO) end;

function Tdlg_gbox_edit.read : boolean;
begin
	gx_external.assign(gx);
	result := TRUE
end;

function Tdlg_gbox_edit.get_color(lo_colore, lo_colore_originale : TColor) : TColor;
begin
	if (lo_colore = RUNTIME_UNASSIGNED_COLOR) then result := lo_colore_originale else result := lo_colore
end;

procedure Tdlg_gbox_edit.write;
begin
	str_descrizione.set_VAR_string(gx.str_descrizione,0);
	i_parameter_window.set_VAR_smallint(gx.i_parameter_window);
	cbx_on_exit.set_VAR_boolean(gx.bo_ask_on_exit);
	cbx_on_creating.set_VAR_boolean(gx.bo_ask_only_when_creating);
	gbox.Font.Color := get_color(gx.lo_gruppo_text_color, lo_gruppo_text_color_originale);
	gbox.Color := get_color(gx.lo_gruppo_back_color, lo_gruppo_back_color_originale);
	str_descrizione.Font.Color := get_color(gx.lo_default_text_color, lo_default_text_color_originale);
	str_descrizione.Color := get_color(gx.lo_default_back_color, lo_default_back_color_originale)
end;

procedure Tdlg_gbox_edit.btn_colori_defaultClick(Sender : TObject);
begin
	gx.lo_gruppo_text_color := RUNTIME_UNASSIGNED_COLOR;gx.lo_gruppo_back_color := RUNTIME_UNASSIGNED_COLOR;
	gx.lo_default_text_color := RUNTIME_UNASSIGNED_COLOR;gx.lo_default_back_color := RUNTIME_UNASSIGNED_COLOR;
	write
end;

procedure Tdlg_gbox_edit.btn_group_text_colorClick(Sender : TObject);
var lo : TColor;
begin
	lo := gbox.Font.Color;
	if select_colore(self,lo) then begin gx.lo_gruppo_text_color := lo;write end
end;

procedure Tdlg_gbox_edit.btn_group_back_colorClick(Sender : TObject);
var lo : TColor;
begin
	lo := gbox.Color;
	if select_colore(self,lo) then begin gx.lo_gruppo_back_color := lo;write end
end;

procedure Tdlg_gbox_edit.btn_objs_text_colorClick(Sender : TObject);
var lo : TColor;
begin
	lo := str_descrizione.Font.Color;
	if select_colore(self,lo) then begin gx.lo_default_text_color := lo;write end
end;

procedure Tdlg_gbox_edit.btn_objs_back_colorClick(Sender : TObject);
var lo : TColor;
begin
	lo := str_descrizione.Color;
	if select_colore(self,lo) then begin gx.lo_default_back_color := lo;write end
end;

procedure Tdlg_gbox_edit.FormKeyDown(Sender : TObject;var Key : Word;Shift : TShiftState);
begin
	case key of
		VK_F9 : begin key := 0;btn_ok.click end
	end
end;

procedure Tdlg_gbox_edit.AAA_notify_modification(Sender : TObject);
begin
//
end;

initialization
	galateo_initialization_debug('runtime_gbox_edit')
finalization
	galateo_finalization_debug('runtime_gbox_edit')
end.
