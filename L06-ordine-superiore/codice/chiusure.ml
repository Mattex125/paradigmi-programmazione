(* L06 - you have already seen a closure in L03, without calling it that. *)

let x = 3
let f () = x + 1
let x = 100

let () = Printf.printf "f () = %d   (not 101)\n" (f ())

(* In L03 the explanation was: let is not an assignment, the second let
   introduces a new binding that hides the first one.
   Today the same thing is said from the other side: f is not just code,
   it is CODE PLUS THE ENVIRONMENT it was written in. It carries that
   environment along. The name of this pair is CLOSURE. *)

(* --------------------------------------------------------------------- *)
(* A function that returns a function. *)

let times k = fun n -> n * k

let double = times 2
let triple = times 3

(* double and triple are the same code, `fun n -> n * k`, with two
   different environments: in one k is 2, in the other 3.
   Neither of them can be modified from here on. *)

let () = Printf.printf "double 5 = %d, triple 5 = %d\n" (double 5) (triple 5)

(* --------------------------------------------------------------------- *)
(* Why this is NOT a C++ function object in disguise.

   A struct with a field k and an operator()(int n) does the same thing,
   but the field can be changed afterwards, and then double stops being
   the double. The same holds for a lambda capturing [&k] instead of [k].
   Here the binding is fixed at creation time and there is no way to reach
   it: this is the referential transparency of L03, seen from inside.

   A practical consequence, and not a small one: `double 5` is 10 ALWAYS,
   so it can be replaced by 10 wherever it occurs. With a mutable object
   that replacement is not legitimate. *)

let compose f g = fun x -> f (g x)

let five_times_minus_one = compose (fun n -> n - 1) (times 5)

let () = Printf.printf "five_times_minus_one 4 = %d\n" (five_times_minus_one 4)
