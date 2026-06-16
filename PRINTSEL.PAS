unit Printsel;

{$I defines}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, xPrinters,
  MYP;

type
  Tdlg_select_printer = class(TForm)
	 lb: TListBox;
	 btn_ok: TButton;
	 btn_cancel: TButton;
	 Label1: TLabel;
	 str_default: TEdit;
	 procedure FormCreate(Sender : TObject);
	 procedure btn_okClick(Sender : TObject);
	 procedure btn_cancelClick(Sender : TObject);
	 procedure lbDblClick(Sender : TObject);
	private
		bo_open_ok : boolean;
		pt_bo_modified : ^boolean;
  public
		constructor create(father : TForm;var bo_modified : boolean);
			{ rende BO_MODIFIED = TRUE se viene modificata la stampante su cui stampare;
			  aggiorna direttamente il valore di CONTROLLO.STR_PRINTER }
  end;

var
  dlg_select_printer: Tdlg_select_printer;

implementation

uses commons,dich,global,pages,proc;

const
	MBOX_CAPTION = 'Selezione stampante';

{$R *.DFM}

constructor Tdlg_select_printer.create(father : TForm;var bo_modified : boolean);
begin
	pt_bo_modified := @bo_modified;
   bo_modified := FALSE;
	inherited create(father);
	if NOT bo_open_ok then abort
end;

procedure Tdlg_select_printer.FormCreate(Sender : TObject);
var i : integer;
begin
	try
		caption := MBOX_CAPTION;
		if (printer.printers.Count = 0) then begin
			strMessageBBox(handle,'Please, abbi la cortesia (per non dire il buon gusto) di installare almeno una stampante '+
				'prima di pensare di scegliere quella che dovrà stampare questa etichetta',MBOX_CAPTION);
			abort
		end;
		lb.Items.add('STAMPANTE PREDEFINITA');
		with printer do begin
			for i := 1 to printers.Count do lb.Items.add(printers[i-1]);
			str_default.Text := printers[printerindex]
		end;
		if (globale.str_printer = '') then lb.ItemIndex := 0
		else lb.ItemIndex := lb.Items.indexof(globale.str_printer);
		bo_open_ok := TRUE
	except
		bo_open_ok := FALSE
	end
end;

procedure Tdlg_select_printer.btn_okClick(Sender : TObject);
var s : string;
begin
	if (lb.ItemIndex <> -1) then begin
		if (lb.ItemIndex = 0) then s := '' else s := maiuscolo(lb.Items[lb.ItemIndex]);
		pt_bo_modified^ := (s <> maiuscolo(globale.str_printer));
		globale.str_printer := s;
		if (pt_bo_modified^) then begin
			globale.bo_modified := TRUE;
         printer.printerindex := lb.ItemIndex -1
		end
	end;
	close
end;

procedure Tdlg_select_printer.btn_cancelClick(Sender : TObject);
begin close end;

procedure Tdlg_select_printer.lbDblClick(Sender : TObject);
begin btn_ok.click end;

initialization
	initialization_debug('printsel')
end.
