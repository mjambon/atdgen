
type json_float = [ `Float of int option (* max decimal places *)
                  | `Int ]

type json_list = [ `Array | `Object ]

type json_variant = { json_cons : string }

type json_field = {
  json_fname  : string;           (* <json name=...> *)
  json_tag_field : string option; (* <json tag_field=...> *)

  json_optional : bool
    (* indicates a JSON optional field: instead of representing the value
       None as a JSON value or wrap a value with some constructor,
       the absence of a value is represented by the absence of a JSON field,
       and a defined value is represented as-is.

       Unwrapped fields have a value of ATD type 'a option and are
       marked as optional with the question mark notation:

       ATD field definition:
         { ?foo : int option }

       unwrapped JSON,     corresponding OCaml:
         { "foo": 123 }    { foo = Some 123 }
         {}                { foo = None }


       In contrast, the ATD field definition for a wrapped JSON field value is:
         { foo : int option } (* no '?' *)

       wrapped JSON,                 corresponding OCaml:
         { "foo": ["Some", 123] }    { foo = Some 123 }
         { "foo": "None" }           { foo = None }
    *)
}
type json_repr =
  [ `Bool
  | `Cell
  | `Def
  | `External
  | `Field of json_field
  | `Float of json_float
  | `Int
  | `List of json_list
  | `Nullable
  | `Option
  | `Record
  | `String
  | `Sum
  | `Tuple
  | `Unit
  | `Variant of json_variant
  | `Wrap ]


val get_json_list : Atd_annot.t -> json_list

val get_json_float : Atd_annot.t -> json_float

val get_json_cons : string -> Atd_annot.t -> string

val get_json_fname : string -> Atd_annot.t -> string

val get_json_tag_field : Atd_annot.t -> string option
