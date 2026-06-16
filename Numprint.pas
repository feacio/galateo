unit Numprint;

{$ifdef DLL} *** {$endif}

{$I defines}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
	proc;

function get_print_num(father : TForm) : integer;

type
  Tdlg_print_num = class(TForm)
	 Label1: TLabel;
	 i_num: TEdit;
	 btn_ok: TButton;
	 btn_cancel: TButton;
	 procedure i_numChange(Sender : TObject);
	 procedure btn_cancelClick(Sender : TObject);
	 procedure btn_okClick(Sender : TObject);
  private
		pt_i_labels : ^integer;
		constructor xcreate(father : TForm;var i_labels : integer);
  end;

implementation

uses Fcommons, FXStrings, FStrings, galateo_debug;

{$R *.DFM}

function get_print_num(father : TForm) : integer;
var dlg: Tdlg_print_num;
begin
	dlg := Tdlg_print_num.xcreate(father,result);
	dlg.ShowModal;dlg.Free
end;

constructor Tdlg_print_num.xcreate(father : TForm;var i_labels : integer);
begin
	pt_i_labels := @i_labels;i_labels := 0;
	inherited create(father)
end;

procedure Tdlg_print_num.i_numChange(Sender : TObject);
var
	bo : boolean;
	i,j : integer;
begin
	bo := (i_num.Text <> '');
	if (bo) then begin
		Ival(togliblanks(i_num.Text),i,j);
		bo := (j = 0) AND (i > 0)
	end;
	btn_ok.Enabled := bo
end;

procedure Tdlg_print_num.btn_cancelClick(Sender : TObject);
begin close end;

procedure Tdlg_print_num.btn_okClick(Sender : TObject);
var i,j : integer;
begin Ival(togliblanks(i_num.Text),i,j);pt_i_labels^ := i;close end;

initialization
	galateo_initialization_debug('numprint')
finalization
	galateo_finalization_debug('numprint')
end.
