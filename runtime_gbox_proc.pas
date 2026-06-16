unit runtime_gbox_proc;

{$I defines}
{$if NOT (defined(GALATEO_EXE) or defined(CASA))}	*** not good, sir *** {$endif}

interface

uses Windows, SysUtils, Types, Graphics, Classes,
	gdich;

procedure runtime_groupboxes_free(var x : runtime_groupboxes_array);
{$ifdef GALATEO_EXE}
	procedure runtime_groupboxes_load_items(it : TStrings;x : runtime_groupboxes_array);
	procedure runtime_groupboxes_assign(var target, source : runtime_groupboxes_array);
	procedure riassegna_groupboxes(originali, modificate : runtime_groupboxes_array);
{$endif}

implementation

uses FCommons, FMessage,
	GUN, sezione, functions, misure, objects, pages;

procedure runtime_groupboxes_free(var x : runtime_groupboxes_array);
begin
	for var i : smallint := 0 to high(x) do x[i].free;
	x := NIL
end;

{$ifdef GALATEO_EXE}

procedure runtime_groupboxes_load_items(it : TStrings;x : runtime_groupboxes_array);
begin
	it.clear;
	for var i : smallint := 0 to high(x) do it.add(x[i].get_descrizione(i+1))
end;

procedure runtime_groupboxes_assign(var target, source : runtime_groupboxes_array);
begin
	runtime_groupboxes_free(target);
	setLength(target, length(source));
	for var i : smallint := 0 to high(source) do begin
		target[i] := cl_runtime_groupbox.create;
		target[i].assign(source[i])
	end
end;

procedure riassegna_groupboxes(originali, modificate : runtime_groupboxes_array);
// aggiorna il valore della GROUPBOX in funzione delle modifiche di posizione apportate da ORIGINALI a MODIFICATE
begin
	var bo_modified := FALSE;
	for var i_ori : smallint := 0 to high(originali) do begin
		for var i_mod : smallint := 0 to high(modificate) do begin
			if (i_ori <> i_mod) AND (originali[i_ori].lo_id = modificate[i_mod].lo_id) then begin
				for var i_page : logical_page_type := 1 to get_ultima_pagina_logica do begin
					for var i_obj : obj_index_type := 1 to i_objs(i_page) do begin
						var x : objs_type := xobjs(i_obj, i_page);
//						if (x.get_tipo = xVARIABILE) AND (x.aslabel.tipovar = TV_PARAMETRO) AND x.aslabel.bo_ask_runtime AND
						if (x.tipo_variabile = TV_PARAMETRO) AND x.aslabel.bo_ask_runtime AND
							(x.aslabel.i_runtime_groupbox = i_ori)
						then begin
							x.aslabel.i_runtime_groupbox := -i_mod;	// negativo per evitare modifiche a catena indesiderate
							bo_modified := TRUE
						end
					end
				end
			end
		end
	end;

	if bo_modified then begin
		for var i_page : logical_page_type := 1 to get_ultima_pagina_logica do begin
			for var i_obj : obj_index_type := 1 to i_objs(i_page) do begin
				var x : objs_type := xobjs(i_obj, i_page);
//				if (x.get_tipo = xVARIABILE) AND (x.aslabel.tipovar = TV_PARAMETRO) AND x.aslabel.bo_ask_runtime AND
				if (x.tipo_variabile = TV_PARAMETRO) AND x.aslabel.bo_ask_runtime AND
					(x.aslabel.i_runtime_groupbox < 0)
						then x.aslabel.i_runtime_groupbox := -x.aslabel.i_runtime_groupbox
			end
		end
	end
end;

{$endif GALATEO_EXE}

initialization
finalization
//	{$ifdef DEBUG} CCI(i_colonna_colorata, 'cl_colonna_colorata', 'colori_proc.pas') {$endif}
end.
