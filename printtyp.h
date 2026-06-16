// Print Types Declaration
type
//	report_info_type = object
	report_info_type = record
		str_filename, str_description : string;
		lo_key_report : integer;
//		procedure reset;
//		{$ifdef DLL} procedure DLL_safe_copy(source : report_info_type); {$endif}
//		str_last_exported_filename : string;		// 2019-01-02 nome dell'ultimo file realmente exportato
	end;

	print_setup_method_type = function(i_job : smallint) : boolean of object;
	print_setup_procedure_type = function(i_job : smallint) : boolean;

	universal_callback_procedure_type = function(i_job : smallint;report_info : report_info_type) : boolean;

//	str_default_parm_type = string[30];
	GAL_integer_parm = nativeint;	// 32/64 bit in funzione del contesto ** vale anche come placeholder per POINTERS
	GAL_boolean_punt = ^boolean;

	{ usata da CASA.DLL per eseguire la sostituzione delle variabili di ambiente che possono essere inserite in determinati campi
	  (esempio: il nome della cartella/filename di exportazione, che può essere deciso in base ad impostazioni del programma chiamante) }
	callback_replace_variabili_ambiente_procedure_type = function(i_job : smallint;s : string;{future implementations}ptr : pointer) : string;

