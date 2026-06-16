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
  galateo_main in 'galateo_main.pas' {GM};

{$R *.res}

begin
	Application.Title := 'Galateo';
	Application.Initialize;
	Application.MainFormOnTaskbar := True;
	Application.CreateForm(TGM, GM);
	Application.Run
end.
