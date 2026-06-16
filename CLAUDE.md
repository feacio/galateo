# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

GALATEO is a Delphi (VCL, Win32/Win64) report- and label-generation system for printing
database-driven reports with a WYSIWYG print preview. A report is a tree of nested **sections**
(each driven by a SQL `SELECT`) containing **objects** (text, formulas, variables, BMP, lines,
rectangles, barcodes) laid out on one or more **logical pages**. Report files use the `.gal`
extension; an exported logical page uses `.GPL`. The UI and most comments are in Italian.

## The three projects (CASA-GALRUN.groupproj)

The product is split into three binaries that share the same source tree, differentiated by
conditional-compilation symbols:

- **GALATEO.EXE** (`GALATEO.dpr`, defines `GALATEO_EXE`) — the interactive report **designer/editor**.
  Main form is `TGM` in `galateo_main.pas`.
- **CASA.DLL** (`CASA.dpr`, defines `CASA;DLL`) — the **runtime print engine**, linked into a host
  application. It exports the `GAL_*` / `init_galateo` API (see the `EXPORTS` list in `CASA.dpr`)
  used to open a `.gal`, set parameter/object values, and print or preview. The DLL has no designer UI.
- **GALRUN.EXE** (`run/GALRUN.dpr`, defines `GALRUN`) — a thin standalone **runner** that loads
  CASA.DLL via `print_link.pas` and prints a report from the command line / a host.

All three define `GALATEO`. Build the whole group via `CASA-GALRUN.groupproj` (targets `Build`,
`Make`, `Clean`).

### Critical: conditional compilation gates large code differences

`{$ifdef GALATEO_EXE}` ... `{$else}` (the DLL/runtime case) and `{$ifdef CASA}` / `{$ifndef DLL}`
blocks select fundamentally different code paths in the **same** unit. The designer pulls in editor
units (`panel`, `fields`, the `*_edit` forms); the DLL pulls in `print_types`, `print_report`,
`printer_select`. When editing a shared unit, always check which symbol guards the code you touch and
keep all variants compiling — a change that only works under `GALATEO_EXE` will break CASA.DLL/GALRUN
and vice-versa.

## Building

Open `CASA-GALRUN.groupproj` in the Delphi IDE (RAD Studio), or build from the command line with
MSBuild, e.g. `msbuild CASA-GALRUN.groupproj /t:Build /p:Config=Release /p:Platform=Win32`
(use `Config=Debug` for debug; `Platform=Win64` is also configured). Individual projects:
`msbuild GALATEO.dproj` / `CASA.dproj` / `run\GALRUN.dproj`.

- Binaries output to `E:\DX\bin\$(Platform)`; DCUs to `.\$(Platform)\<Project>`.
- There is **no test suite**; verification is manual (open a `.gal` in GALATEO.EXE and print/preview).
  Sample/regression report files live in `ERRORI/` and `storico/`.

### External dependencies (must be on the IDE library path)

This project does **not** vendor its dependencies. It needs:
- Shared in-house **`F*` units** referenced everywhere (`Fcommons`, `FDB`, `FDebug`, `FXstrings`,
  `Fstrings`, `FSQLsoft`, `Federico`, …) plus the shared include `{$I e:\DX\defines}` pulled in by
  the local `defines.pas`. These live outside this repo under `E:\DX`.
- Third-party packages (see `DCC_UsePackage` in `CASA.dproj`): **FireDAC** (DB access), **wPDF**
  (`WPPDFR1/2`, PDF export), **JEDI/JVCL** (`Jv*`), and the **Drag and Drop Component Suite**
  (`DragDrop*`, gated by `EXCLUDE_DRAGDROP`).

## Code map (where the big picture lives)

Read these to understand the model before changing behavior:

- `defines.pas` — master conditional-compilation switches (`PDF`, `CASA_DLL`, `PROFESSIONALE`,
  per-customer flags, `PROVA_FAST`, …). Includes the shared `E:\DX\defines`.
- `gdich.pas` ("Galateo DICHiarazioni") — central shared type/constant declarations; includes
  `galateo_versione.pas` (version numbers + the DLL/EXE compatibility check). Almost every unit uses it.
- `Gun.pas` — the **GALATEO core module** (`module GALATEO`), the heart of the running application
  (was the hidden `GLOBAL` form until 2020). Holds logical-page info, macros, the active job state.
- `pages.pas` — orchestrates logical pages ↔ physical/virtual pages and the sections on them; acts
  as a unit-as-class. Owns `print_status_type` (the print state machine).
- `sezione.pas` — `cl_sezione`: the section hierarchy, each with its SQL query; section nesting and
  the parent/child SQL execution model.
- `objects.pas` (+ `objsx.pas`, `bmps.pas`, `rects.pas`, `labels.pas`, `datamatrix_unit.pas`) — the
  report objects and their print procedures (`print_proc_type`).
- `functions.pas` — the **formula/function engine** (`PAGINA()`, `MAIUSCOLO()`, `EAN13()`, etc.);
  included by `objects.pas`. The user-facing function reference is in `HELP/reference galateo.doc`.
- `print_report.pas` (CASA only) — the runtime print/preview pipeline (FireDAC, PDF, drag&drop export).
- `print_link.pas` — the **import unit a host Delphi app uses to call CASA.DLL**. With `printtyp.h`
  and `printopt.h` (Pascal `{$I}` includes despite the `.h` extension) it defines the shared types
  and the option codes for `GAL_set_option` / `GAL_get_option`.

## Conventions specific to this codebase

- `.h` files (`printtyp.h`, `printopt.h`, `print.h`, `printopt.h`) are **Pascal include files**, not C
  headers — pulled in with `{$I}`.
- Section/object/page indices appear in both 0-based and 1-based forms; suffixes `_ZB` (zero-based)
  and `_1B` (one-based) on identifiers tell you which.
- Reference reports in `$OBJECTNAME` notation; SQL parameters as `$PARM_NAME`; sub-section SQL refers
  to ancestor fields as `SECTIONNAME.FIELD`.
- Follow the Delphi style rules in the user's global `CLAUDE.md` (tabs, naming prefixes, ANSI/
  Windows-1252 encoding — never re-save `.pas`/`.dfm` as UTF-8 or add a BOM).

## Directories to ignore

`Win32/`, `Win64/`, `run/Win32/`, `run/Win64/`, `__history/`, `__recovery/`, `temp/` are build
artifacts / IDE backups. `old/`, `system source/`, `storico/`, and `OLD prjs.rar` are archived/legacy
material, not the active build.
