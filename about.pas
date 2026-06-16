unit About;

{$ifdef DLL} *** {$endif}

{$I defines}                                                                          
{$undef SOLD_BY_SISTEL}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons,
	gdich, proc;

procedure about_proc(father : TForm);

type
  Tdlg_about = class(TForm)
	 gbox_programma: TGroupBox;
    txt_version: TLabel;
    txt_info_02: TLabel;
    gbox_autore: TGroupBox;
    image_galateo: TImage;
    txt_into_01: TLabel;
	 hand_adv_01: TImage;
	 hand_adv_02: TImage;
    pc_logo: TPageControl;
    sistel: TTabSheet;
    txt_sistel_base: TLabel;
    txt_sistel_via: TLabel;
    txt_sistel_citta: TLabel;
    txt_sistel_tel: TLabel;
    txt_sistel_www: TLabel;
	 fede: TTabSheet;
    txt_federico: TLabel;
    txt_fede_via: TLabel;
    txt_fede_citta: TLabel;
    txt_fede_tel: TLabel;
    txt_fede_www: TLabel;
    panel_logo_sistel: TPanel;
    image_fede_sistel: TImage;
    txt_sistel_federico: TLabel;
    txt_sistel_madeby: TLabel;
    txt_sistel_00: TLabel;
    panel_logo_federico: TPanel;
    image_fede_fede: TImage;
    txt_fede_madeby: TLabel;
	 btn_ok: TBitBtn;
	 hand_adv_03: TImage;
	 panel_user: TPanel;
	 txt_uso_esclusivo: TLabel;
	 txt_nome1: TLabel;
	 txt_nome2: TLabel;
	 txt_user_header: TLabel;
	 txt_placeholder_00: TLabel;
	 procedure btn_okClick(Sender : TObject);
	 procedure image_fede_sistelDblClick(Sender : TObject);
	 procedure FormCreate(Sender : TObject);
	 procedure image_galateoClick(Sender : TObject);
  public
		procedure hidden;
  end;

implementation

uses Fcommons, FMessage, FCtrls,
	galateo_debug, pages;

{$R *.DFM}

procedure about_proc(father : TForm);
begin
	var dlg := Tdlg_about.Create(father);
	dlg.ShowModal;dlg.Free
end;

procedure Tdlg_about.btn_okClick(Sender : TObject); begin close end;
procedure Tdlg_about.hidden; begin MessageBBox(handle, FARFALLA, MBOX_CAPTION) end;
procedure Tdlg_about.image_fede_sistelDblClick(Sender : TObject); begin hidden end;
procedure Tdlg_about.image_galateoClick(Sender : TObject); begin help_proc(self, GALATEO_HOME_PAGE) end;

procedure Tdlg_about.FormCreate(Sender : TObject);
begin
	txt_version.Caption := get_internal_version_signature;
	fede.Tabvisible := FALSE;
	sistel.Tabvisible := FALSE;
	pc_logo.Activepage := {$ifdef SOLD_BY_SISTEL} sistel {$else} fede {$endif};
{$ifdef REPORT_GENERATOR}
	txt_nome1.Font.Assign(txt_uso_esclusivo.Font);
	txt_nome2.Font.Assign(txt_uso_esclusivo.Font);
	txt_uso_esclusivo.Caption := 'Questa versione di Galateo non può';
	txt_nome1.Caption := 'essere utilizzata separatamente da';
	txt_nome2.Caption := PRG_ASSOCIATO;
{$else}
	txt_nome1.Caption := LOGO_NOME_1;
	txt_nome2.Caption := LOGO_NOME_2;
{$ifndef HANDY}
	hand_adv_01.Visible := FALSE;hand_adv_02.Visible := FALSE;hand_adv_03.Visible := FALSE;
{$endif NOT HANDY}
{$endif REPORT_GENERATOR}
	{$ifdef DEBUG} check_components(self) {$endif DEBUG}
end;

initialization
	galateo_initialization_debug('about')
finalization
	galateo_finalization_debug('about')
end.
