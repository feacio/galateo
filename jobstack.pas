unit Jobstack;

{$I defines}

interface

uses sysutils;

// strutture che servono per sparare su uno stack lo status di un job
const
	MAX_STATUS_STACK = 5;	// numero max di stati di stampa stakkabili
type
	cl_status_stack = class
		private
			i_stack : integer;
			i_stack_pagina_logica_attiva : array[1..MAX_STATUS_STACK] of integer;
		public
			constructor create;
			destructor free;
			procedure push_status;
			procedure pop_status;
	end;
var
	job_stack : cl_status_stack;

implementation

uses Fcommons, FAssert, FDebug, 
	galateo_debug, pages;

{$ifdef DEBUG} var i_status_stack : integer; {$endif}

constructor cl_status_stack.create;
begin
	{$ifdef DEBUG} inc(i_status_stack); {$endif}
//	i_stack := 0
end;

destructor cl_status_stack.free;
begin
	{$ifdef DEBUG}
		assert(i_stack = 0,'status stack non restituito del tutto');
		dec(i_status_stack);
	{$endif}
end;

procedure cl_status_stack.push_status;
begin
	if (i_stack = MAX_STATUS_STACK) then begin
		set_last_job_error('max ' + inttostr(MAX_STATUS_STACK) + ' job status stacks');
		abort
	end;
	inc(i_stack);
	i_stack_pagina_logica_attiva[i_stack] := get_pagina_logica_attiva_1B
end;

procedure cl_status_stack.pop_status;
begin
	{$ifdef DEBUG} assert(i_stack > 0,'status stack negativo'); {$endif}
	set_pagina_logica_attiva_1B(i_stack_pagina_logica_attiva[i_stack],FALSE);
	dec(i_stack)
end;

initialization
	galateo_initialization_debug('jobstack');
	job_stack := cl_status_stack.create
finalization
	galateo_finalization_debug('jobstack');
	job_stack.free;
	{$ifdef DEBUG} CCI(i_status_stack, 'cl_status_stack', 'jobstack.pas') {$endif}
end.
