(* L05 - exercises. They compile as they are: the bodies are to be rewritten. *)

type 'a tree =
  | Leaf
  | Node of 'a tree * 'a * 'a tree

(* 1. mirror: swap the two subtrees, everywhere.
      A question to answer before writing it: which property relates
      mirror to itself applied twice? Write it down, then implement. *)
let rec mirror (t : 'a tree) : 'a tree =
  match t with
  | Leaf -> Leaf
  | Node (l, x, r) -> Node (l, x, r)      (* to be fixed *)

(* 2. member: does the element occur in the tree?
      Careful: we are NOT assuming the tree is ordered. *)
let rec member (_x : 'a) (t : 'a tree) : bool =
  match t with
  | Leaf -> false
  | Node (_, _, _) -> false               (* to be fixed *)

(* 3. leaves: how many Leaf does the tree contain?
      Then check on a few examples: what is the relation between
      leaves t and size t?  The conjecture is proved in L08. *)
let rec leaves (t : 'a tree) : int =
  match t with
  | Leaf -> 0                             (* to be fixed *)
  | Node (l, _, r) -> leaves l + leaves r

(* 4. The missing type.
      Specification: a shape is a circle (with its radius), a rectangle
      (width and height) or a square (its side).
      Define the type so that it is NOT possible to write a rectangle with
      a single number, nor a circle with two.
      Then write area. How many cases must the match have, and who
      decides that? *)

(* 5. A question with no code.
      Why 'a tree and not int tree? What would stop you, with the second
      one, from writing the function size? *)

let () = ignore (mirror, member, leaves)
