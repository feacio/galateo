unit Murphie;

{$I defines}
{$ifdef DLL} *** {$endif}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,commons,dich,proc;

type
  Tdlg_murphie = class(TForm)
	 Memo1: TMemo;
	 Button1: TButton;
	 Button2: TButton;
	 Edit1: TEdit;
	 procedure Button1Click(Sender : TObject);
	 procedure Button2Click(Sender : TObject);
	 procedure FormCloseQuery(Sender : TObject;var CanClose : Boolean);
	 procedure FormCreate(Sender : TObject);
  private
		bo_can_close : boolean;
  end;

var
  dlg_murphie: Tdlg_murphie;

implementation

{$R *.DFM}

procedure Tdlg_murphie.Button1Click(Sender : TObject);
begin
	MessageBox(handle,'Grazie',PROGRAM_NAME);
	bo_can_close := TRUE;close
end;

procedure Tdlg_murphie.Button2Click(Sender : TObject);
begin
	MessageBox(handle,
		'Giudica altrui secondo il tuo onore, e non secondo il suo merito, perchè altrimenti: chi eviterebbe le frustate?'+
		ACAPO2+'Amleto',PROGRAM_NAME);
	bo_can_close := TRUE;close
end;

procedure Tdlg_murphie.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
	canclose := bo_can_close
end;

procedure Tdlg_murphie.FormCreate(Sender : TObject);
begin bo_can_close := FALSE end;

initialization
//	initialization_debug('murphie')
end.
