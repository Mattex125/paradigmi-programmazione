(* L06 - why in OCaml one writes  f x y  and not  f(x, y). *)

let add a b = a + b

(* The inferred type is:     int -> int -> int
   which reads as:           int -> (int -> int)
   because the arrow associates to the RIGHT.

   That is: add is not a function of two arguments. It is a function of
   ONE argument, returning a function of one argument. *)

let add_ten = add 10        (* int -> int : an ordinary value *)

let () =
  Printf.printf "add 10 5   = %d\n" (add 10 5);
  Printf.printf "add_ten 5  = %d\n" (add_ten 5)

(* Consequently, application associates to the LEFT:

     add 10 5   is   (add 10) 5

   and that is why parentheses are needed only when you want a different
   grouping:

     permutation l (sort l)     is    permutation(l, sort(l))
     permutation l sort l       would be   permutation(l, sort, l)   *)

(* --------------------------------------------------------------------- *)
(* The version taking a pair exists, and it is a different type. *)

let add_pair (a, b) = a + b          (* int * int -> int *)

(* add_pair takes ONE argument, which is a pair.
   It cannot be partially applied: half a pair does not exist. *)

let () = Printf.printf "add_pair (10, 5) = %d\n" (add_pair (10, 5))

(* Converting between the two shapes is an operation with a name, and it
   is the reason this is called currying (after Haskell Curry). *)

let curry f = fun a b -> f (a, b)
let uncurry f = fun (a, b) -> f a b

let () =
  Printf.printf "curry add_pair 10 5 = %d\n" (curry add_pair 10 5);
  Printf.printf "uncurry add (10, 5) = %d\n" (uncurry add (10, 5))

(* --------------------------------------------------------------------- *)
(* What it is good for: naming special cases without writing a new
   function. *)

let ( -- ) a b = List.init (b - a + 1) (fun i -> a + i)   (* a -- b *)

let evens = List.filter (fun n -> n mod 2 = 0)     (* int list -> int list *)
let sum_all = List.fold_left ( + ) 0               (* int list -> int      *)

let () =
  Printf.printf "sum of the even numbers from 1 to 10 = %d\n"
    (sum_all (evens (1 -- 10)))

(* Note: evens and sum_all are defined WITHOUT naming the list.
   It is not a mannerism: they are partial applications of functions that
   already exist. Types checked with `ocamlc -i currying.ml`. *)
