open Printf

let get_prog_name argv pos =
  let l = ref [] in
  for i = pos downto 0 do
    l := argv.(i) :: !l
  done;
  String.concat " " !l

let parse
    ?(offset = 0)
    ?(allow_anon = true)
    ?anon_count
    ?usage_msg
    extra_options =

  let argv = Sys.argv in
  assert (offset <= Array.length argv - 1);

  let options = extra_options @ [ (* common options here *) ] in
    let anon = ref [] in
  let anon_fun s = anon := s :: !anon in
  let usage_msg =
    match usage_msg with
      | None ->
          sprintf
            "Usage: %s [options]\nSupported options:\n"
            (get_prog_name argv offset)
      | Some s -> s
  in
  let usage () = Arg.usage options usage_msg in
  try
    Arg.parse_argv
      ~current: (ref offset) argv
      options anon_fun usage_msg;

    let anon = List.rev !anon in
     if not allow_anon && anon <> [] then
      failwith ("Don't know what to do with " ^ List.hd anon)
    else
      let len = List.length anon in
      match anon_count with
      | Some n when n <> len ->
          eprintf "Expecting %i non-optional arguments but %i were given\n"
            n len;
          usage ();
          exit 1
      | _ ->
          anon

  with
  | Arg.Help _usage_msg -> usage (); exit 0
  | Arg.Bad _usage_msg -> usage (); exit 1
  | Failure s -> eprintf "%s\n%!" s; usage (); exit 1
