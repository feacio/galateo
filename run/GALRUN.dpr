program GALRUN;

{$ifndef GALATEO} 			*** GALATEO required ***				{$endif}	// tutte le applicazioni del mondo GALATEO
//{$ifndef GALATEO_EXE}		*** GALATEO_EXE required ***		{$endif}	// GALATEO.EXE
//{$ifndef CASA}					*** CASA required ***					{$endif}	// CASA.DLL
{$ifndef GALRUN}				*** GALRUN required ***					{$endif}	// GALRUN.EXE

{$ifdef DLL}					*** DLL forbidden ***					{$endif}

uses
  SimpleShareMEM,
  Vcl.Forms,
  main_galrun in 'main_galrun.pas' {grun_main},
  galateo_debug in '..\galateo_debug.pas',
  print_link in '..\print_link.pas',
  gdich in '..\gdich.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tgrun_main, grun_main);
  Application.Run;
end.
