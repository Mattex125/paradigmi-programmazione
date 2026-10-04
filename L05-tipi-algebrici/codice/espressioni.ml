(* L05 - a tree whose nodes are operations: a PROGRAM as data.

   So far trees contained numbers. Now the tree IS the computation. *)

type expr =
  | Num of int
  | Add of expr * expr
  | Mul of expr * expr
  | Neg of expr

(* (2 + 3) * 4 *)
let e1 = Mul (Add (Num 2, Num 3), Num 4)

(* The usual recipe: one case per constructor. *)
let rec eval = function
  | Num n -> n
  | Add (a, b) -> eval a + eval b
  | Mul (a, b) -> eval a * eval b
  | Neg a -> - (eval a)

(* Different functions on the same type, without touching the type. *)
let rec show = function
  | Num n -> string_of_int n
  | Add (a, b) -> "(" ^ show a ^ " + " ^ show b ^ ")"
  | Mul (a, b) -> "(" ^ show a ^ " * " ^ show b ^ ")"
  | Neg a -> "-" ^ show a

let rec depth = function
  | Num _ -> 1
  | Neg a -> 1 + depth a
  | Add (a, b) | Mul (a, b) -> 1 + max (depth a) (depth b)

let () =
  Printf.printf "%s = %d   (depth %d)\n" (show e1) (eval e1) (depth e1);
  let e2 = Add (Neg (Num 7), Mul (Num 2, Num 5)) in
  Printf.printf "%s = %d   (depth %d)\n" (show e2) (eval e2) (depth e2)

(* Two things to keep in mind from here on.

   1. This type is the abstract syntax of a language, and eval is its
      interpreter. In L11 we do it properly: variables, let, functions.
      The reduction you saw in L03 becomes code that runs.

   2. Add a constructor, say Sub. The compiler will list ALL the functions
      to update, one by one. Try it now: add the constructor and compile
      without touching anything else.
      A type is not documentation: it is a to-do list. *)
