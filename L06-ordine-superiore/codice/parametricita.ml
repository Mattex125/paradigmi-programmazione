(* L06 - the question from L05, exercise 5: why 'a tree and not int tree?
   The answer is more interesting than the question. *)

let rec length = function
  | [] -> 0
  | _ :: rest -> 1 + length rest

(* length : 'a list -> int

   The type does not only say that it accepts lists of anything.
   It says something much stronger:

     this function CANNOT LOOK at the elements.

   It does not know whether they are numbers, it cannot compare them, it
   cannot add them: it knows nothing about 'a. The only information it has
   access to is the STRUCTURE of the list. *)

(* --------------------------------------------------------------------- *)
(* Let us push it to the limit. How many functions have this type?

     'a -> 'a

   Exactly one: *)

let identity x = x

(* There is no other one. Given a value of a type you know nothing about,
   you cannot inspect it, modify it, compare it, or manufacture another
   one. The only thing you can return is the one that arrived.

   This is a THEOREM, and it comes FOR FREE FROM THE TYPE. Nobody read the
   body of the function.

   Honesty: "exactly one" holds up to functions that do not terminate or
   raise exceptions. This one also has type 'a -> 'b, and computes
   nothing:

     let rec bottom x = bottom x

   The type constrains what CAN be computed, not that anything is. *)

(* --------------------------------------------------------------------- *)
(* A less extreme and more useful case. *)

let rearrange (l : 'a list) : 'a list = List.rev l

(* Any function of type 'a list -> 'a list can only copy, drop, duplicate
   and reorder the elements it received. It CANNOT INVENT ANY. If a 7
   appears in the output list, that 7 was already in the input.

   Compare with int list -> int list, which can do anything. *)

(* --------------------------------------------------------------------- *)
(* The other side of the coin: to compare, you need functions. *)

let rec max_by (worse_than : 'a -> 'a -> bool) = function
  | [] -> None
  | [ x ] -> Some x
  | x :: rest ->
      (match max_by worse_than rest with
       | None -> Some x
       | Some m -> if worse_than m x then Some x else Some m)

(* The type 'a cannot compare itself: so the comparison arrives as an
   ARGUMENT. That is the reason higher-order functions exist, before any
   question of convenience. *)

let () =
  let strings = [ "hello"; "a"; "everyone" ] in
  let shorter_than a b = String.length a < String.length b in
  (match max_by shorter_than strings with
   | None -> print_endline "empty"
   | Some s -> Printf.printf "the longest: %s\n" s);
  match max_by ( < ) [ 3; 9; 2 ] with
  | None -> print_endline "empty"
  | Some n -> Printf.printf "the maximum: %d\n" n

(* Do you recognise max_by? It is `longest` from L05, with everything
   concerning strings taken out. What remains is the shape. *)
