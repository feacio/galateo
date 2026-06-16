unit global;	//*

(*

	MODALITA' DI STAMPA
		* IMMAGINE STAMPA
		* EXPORT DATI (integrale e XML)
	TARGET DI STAMPA
		* STAMPANTE
		* file PDF
		* MAIL
		* FILE DATI
		* CLIPBOARD
		* FTP


	le misure degli oggetti sono immagazzinate come segue:
	larghezza della pagina								FISICAMENTE: PAGES.cl_logical_page.r_size_X_cm_ph
																PAGES.get_page_size_X_cm(i_page)	set_page_size_X_cm(i_page)
																i_page_size_X_pix_video(page)	ai_page_size_X_pix_print(page)
																function		get_page_size_X_cm(i_page : i_logical_page_type = 1) : misura_real_type;
																procedure	set_page_size_X_cm(i_page : i_logical_page_type;r_value : misura_real_type);
																function		i_page_size_X_pix_video(i_page : i_logical_page_type) : smallint;
																function		ai_page_size_X_pix_print(i_page : i_logical_page_type) : smallint;

	altezza (netta utilizzabile) della pagina		FISICAMENTE: sections(MAIN_SECTION).r_y_sezione_cm
																function PAGES.cl_logical_page.get_size_Y_cm : misura_real_type;
																procedure PAGES.cl_logical_page.set_size_Y_cm(r : misura_real_type);

																function		PAGES.get_page_size_Y_cm(i_page : i_logical_page_type = 1) : misura_real_type;
																procedure	PAGES.set_page_size_Y_cm(i_page : i_logical_page_type;r_value : misura_real_type);
																function		PAGES.ai_page_size_Y_pix_video(i_page : i_logical_page_type) : smallint;
																function		PAGES.ai_page_size_Y_pix_print(i_page : i_logical_page_type) : smallint;

	if (TR_LABEL_REPORT) {
		dimensioni singola label						FISICAMENTE: PAGES.cl_logical_page.R_LABEL_WIDTH_CM e R_LABEL_HEIGHT_CM

																function		get_label_size_X_cm : misura_real_type;
																procedure	set_label_size_X_cm(r_value : misura_real_type);
																function		i_label_size_X_pix_video : smallint;
																function		i_label_size_X_pix_print : smallint;

																function		get_label_size_Y_cm : misura_real_type;
																procedure	set_label_size_Y_cm(r_value : misura_real_type);
																function		i_label_size_Y_pix_video : smallint;
																function		i_label_size_Y_pix_print : smallint;

	NUMERO DI ETICHETTE:									tm.i_lab_per_row
																tm.i_lab_per_page
	DISTANZA TRA ETICHETTE								tm.r_delta_labs_X_cm
																tm.r_delta_labs_Y_cm
	}
*)

{$I defines}

interface

uses Windows, Messages, Classes, VCL.Forms, DB, SysUtils, Math, Graphics,
	FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
	FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client,
	WPPDFR1, PDF,
	Fcommons, gdich, FDB, FTP_proc,
	{$ifndef DLL} control, {$endif}
	proc, objects, runtime_proc, text_scripts, expint_base, SMTP_proc;

//	Windows, Messages, Classes, VCL.Graphics, VCL.Controls, VCL.Forms, DB, SysUtils, Math, VCL.Grids, VCL.ValEdit,

implementation

{$R *.DFM}

uses FAssert, FDebug, FErrMsg, FSystem_base, FSystem, FSystem_ext, FMessage, FProcs, FFile, FRegistry, Fdata, FSQLsoft, Fbrowse,
	FXStrings, FStrings, input_dialog, myprinter, printers_DX, galateo_debug, sp_galateo, working,
	{$ifdef DLL}
		functions,
	{$else}
		domanda_multipla, Ftime, Database, db_link, pagina_logica_edit, running_etichette, select, macros_elenco, panel,
	{$endif}
	misure, pages, print_report, sezione, printer_select;

{ Tglobale }

initialization
	galateo_initialization_debug('global');
finalization
	galateo_finalization_debug('global');
end.
