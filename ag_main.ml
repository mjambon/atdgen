open Printf

let general_usage () =
  eprintf "\
Usage: atdgen {atd|help|java|ocaml|version} [options and arguments]
Options and arguments are specific to each mode (java, ocaml, ...).

Try for example 'atdgen ocaml -help' for help on generating OCaml code.
See also 'man atdgen-ocaml'.
"

let atdgen2_warning () =
  eprintf "\
Warning: Missing or invalid subcommand; assuming
  atdgen ocaml %s
for compatibility with atdgen 1.\n%!"
  (String.concat " " (List.tl (Array.to_list Sys.argv)))

let main () =
  if Array.length Sys.argv <= 1 then (
    general_usage ();
    exit 1
  );
  match Sys.argv.(1) with
  | "atd" -> failwith "coming soon!"
  | "help" | "-h" | "-help" | "--help" -> general_usage ()
  | "java" -> failwith "coming soon!"
  | "ocaml" -> Ag_ox_main.main ~offset:1
  | "version" -> print_endline Ag_version.version
  | s ->
      atdgen2_warning ();
      Ag_ox_main.main ~offset:0


let () =
  try main ()
  with
      Atd_ast.Atd_error s
    | Failure s ->
        flush stdout;
	eprintf "%s\n%!" s;
	exit 1
    | e -> raise e
