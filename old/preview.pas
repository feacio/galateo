unit Preview;

{$ifdef DLL} * {$endif}

{$I defines}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls,StdCtrls, Forms, Dialogs, ExtCtrls,
	Printers_DX, Gdich, running_etichette;

type
	Tdlg_preview = class(TForm)
	 panel: TPanel;
	 pb: TPaintBox;
	 btn_close: TButton;
	 procedure FormCreate(Sender : TObject);
	 procedure pbPaint(Sender : TObject);
	 procedure btn_closeClick(Sender : TObject);
	public
		constructor xcreate(father : TForm);
	end;

var dlg_preview: Tdlg_preview;

implementation

uses galateo_debug, misure, objects, pages;

{$R *.DFM}

constructor TDlg_preview.xcreate(father : TForm);
begin inherited create(father) end;

procedure Tdlg_preview.FormCreate(Sender : TObject);
var r : TRect;
begin
	panel.Left := BORDO_DISEGNO_X_PIXEL;
	panel.Top := BORDO_DISEGNO_Y_PIXEL;
	panel.Width := i_label_size_X_pix_video;
	panel.Height := i_label_size_Y_pix_video;
	width := i_label_size_X_pix_video + BORDO_DISEGNO_X_PIXEL * 2;
	height:= i_label_size_Y_pix_video + BORDO_DISEGNO_Y_PIXEL * 2 + GetSystemMetrics(SM_CYCAPTION) + btn_close.Height;

	r := GetClientRect;
	btn_close.Top := panel.Top + panel.Height + (r.Bottom - (panel.Top+panel.Height) - btn_close.Height) div 2;
	btn_close.Left := (r.Right - btn_close.Width) div 2
end;

procedure Tdlg_preview.pbPaint(Sender : TObject);
var i_delta_y, i_max_y_pixel : int_pixel_type;
begin
	i_delta_y := 0;	// inizialmente
	for var i : i_obj_index_type := 1 to i_objs do
		xobjs(i).print(pb.canvas,printer.canvas, 0, 0, TRUE, NIL, i_delta_y, i_max_y_pixel, 0{da cambiare nel valore corretto},
			i_label_size_Y_pix_video, FALSE, 0, 0)
end; 

procedure Tdlg_preview.btn_closeClick(Sender : TObject);
begin close end;

initialization
	galateo_initialization_debug('preview')
finalization
	galateo_finalization_debug('preview')
end.
