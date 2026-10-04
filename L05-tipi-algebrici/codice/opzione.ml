(* L05 - the debt left open in L03:
     longest : string list -> string
   on the empty list this signature promises a string and there is nothing
   to return. Here is the answer. *)

(* option is not a special construct of the language *)
(* The standard library calls it option, with None and Some. Same thing. *)
type 'a myoption =
  | Nothing
  | Just of 'a

let rec longest = function
  | [] -> Nothing
  | s :: rest ->
      (match longest rest with
       | Nothing -> Just s
       | Just t ->
           if String.length s >= String.length t then Just s else Just t)

(* MIND the >= on the line above.
   That is where the decision about ties lives, the one you discussed in
   L03: with >= the FIRST of two strings of equal length wins, with > the
   LAST one does. A whole specification in one character. *)

(* The caller cannot forget about it: the type forces it to open the
   result, and the compiler checks that both cases are handled. Try
   removing the None line and read the warning. *)
let show l =
  match longest l with	
  | Nothing -> "the list is empty"
  | Just s -> "the longest is: " ^ s

let () =
  List.iter
    (fun l -> print_endline (show l))
    [ [ "hello"; "everyone" ];
      [ "pair"; "pear"; "peas" ];      (* a tie: which one wins? *)
      [] ]
