unit standard;

{$ifdef DLL} ******* {$endif}

{$I defines}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons,
	Gdich, proc;

function xselect_standard_configuration(father : TForm) : smallint;

type
  Tdlg_standard_configurations = class(TForm)
	 lb: TListBox;
	 btn_ok: TButton;
	 btn_cancel: TButton;
	 procedure FormCreate(Sender : TObject);
	 procedure lbDblClick(Sender : TObject);
	 procedure btn_cancelClick(Sender : TObject);
	 procedure btn_okClick(Sender : TObject);
  private
		pt_i_configurazione : ^smallint;
  public
		constructor xcreate(father : TForm;var i_configurazione : smallint);
		{ in uscita i_configurazione vale -1 se nessuna selezione, altrimenti il numero della configurazione }
  end;

implementation

uses FMessage, galateo_debug, Fcommons, pages;

{$R *.DFM}

function xselect_standard_configuration(father : TForm) : smallint;
var dlg: Tdlg_standard_configurations;
begin
	dlg := Tdlg_standard_configurations.xCreate(father,result);
	dlg.ShowModal;dlg.Free
end;

constructor Tdlg_standard_configurations.xcreate(father : TForm;var i_configurazione : smallint);
begin
	pt_i_configurazione := @i_configurazione;i_configurazione := -1;
	inherited create(father);
end;

procedure Tdlg_standard_configurations.FormCreate(Sender : TObject);
var i : smallint;
begin for i := 0 to NUM_CONF_STANDARD -1 do lb.Items.add(string(CONFIGURAZIONI_STANDARD[i].str_nome)) end;

procedure Tdlg_standard_configurations.lbDblClick(Sender : TObject);
begin btn_ok.click end;

procedure Tdlg_standard_configurations.btn_cancelClick(Sender : TObject);
begin close end;

procedure Tdlg_standard_configurations.btn_okClick(Sender : TObject);
begin
	if (lb.ItemIndex = -1) then begin
		MessageBBox(handle, 'Seleziona una configurazione', MBOX_CAPTION);
		exit
	end;
	if (MessageBBox(handle,'Confermi la selezione della configurazione' + ACAPO2 +
		'<' + CONFIGURAZIONI_STANDARD[lb.ItemIndex].str_nome + '> ?',
		MBOX_CAPTION, MB_QUESTION) <> IDYES)
			then exit;
	pt_i_configurazione^ := lb.ItemIndex;
	close
end;

initialization
	galateo_initialization_debug('standard')
finalization
	galateo_finalization_debug('standard')
end.
