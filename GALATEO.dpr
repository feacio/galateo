program GALATEO;

{$ifNdef GALATEO} 			*** GALATEO required ***				{$endif}	// tutte le applicazioni del mondo GALATEO
{$ifNdef GALATEO_EXE}		*** GALATEO_EXE required ***		{$endif}	// GALATEO.EXE
//{$ifNdef CASA}					*** CASA required ***					{$endif}	// CASA.DLL
//{$ifNdef GALRUN}				*** GALRUN required ***					{$endif}	// GALRUN.EXE

{$ifdef DLL}					*** DLL forbidden ***					{$endif}

uses
  Vcl.Forms,
  Pages,
  Gun in 'Gun.pas',
  galateo_main in 'galateo_main.pas' {GM},
  galateo_api in 'galateo_api.pas',
  wproc in '..\FEDERICO\wproc.pas';

{$R *.res}

begin
	Application.Title := 'Galateo';
	Application.Initialize;
	Application.MainFormOnTaskbar := True;
	Application.CreateForm(TGM, GM);
  if (wx <> NIL) then wx.main_form := Application.MainForm;
	Application.Run
end.
