(* L05 - why they are called "algebraic": you can count them.
   A type is a set of values. Let us count them for real. *)

type pair = bool * bool                          (* product:  2 * 2 = 4 *)
type choice = Left of bool | Right of bool       (* sum:      2 + 2 = 4 *)

let all_pairs = [ (true, true); (true, false); (false, true); (false, false) ]
let all_choices = [ Left true; Left false; Right true; Right false ]

(* option adds exactly one value: |'a option| = 1 + |'a| *)
let all_bool_options = [ None; Some true; Some false ]     (* 1 + 2 = 3 *)
let all_unit_options = [ None; Some () ]                   (* 1 + 1 = 2 *)

let () =
  Printf.printf "bool * bool        : %d values\n" (List.length all_pairs);
  Printf.printf "Left | Right       : %d values\n" (List.length all_choices);
  Printf.printf "bool option        : %d values\n" (List.length all_bool_options);
  Printf.printf "unit option        : %d values\n" (List.length all_unit_options)

(* --------------------------------------------------------------------- *)
(* Making illegal states unrepresentable.

   Specification: a contact must have AT LEAST one of email and phone. *)

type contact_record = {
  name : string;
  email : string option;
  phone : string option;
}

(* How many values has this type, for a fixed name?  (1+E) * (1+P).
   Among them there is { email = None; phone = None }, which the
   specification FORBIDS. The type allows an illegal value to be written,
   and every function receiving a contact_record must defend itself. *)

let impossible_contact =
  { name = "Rossi"; email = None; phone = None }   (* compiles fine *)

(* The same specification, as a sum: *)

type contact_info =
  | Email of string
  | Phone of string
  | Both of string * string

(* Values: E + P + E*P. The forbidden case CANNOT BE WRITTEN.
   No run-time check, no exception, nothing to remember: it has
   disappeared from the language.

   The specification moved from the comment into the type, and the type is
   checked by the compiler. *)

type contact = { name2 : string; info : contact_info }

(* Values  N · (E + P + E·P) = N · (1+E)(1+P) *)

let possible_contact = { name2 = "Bianchi"; info = Phone "050 22 12" }

let write c =
  c.name2 ^ ": " ^
  match c.info with
  | Email e -> e
  | Phone p -> p
  | Both (e, p) -> e ^ " / " ^ p

let () =
  ignore impossible_contact;
  print_endline (write possible_contact)
