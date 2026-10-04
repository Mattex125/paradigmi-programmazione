(* L06 - exercises. Compiles as it is: the bodies are to be rewritten. *)

let rec fold combine initial = function
  | [] -> initial
  | x :: r -> combine x (fold combine initial r)

type 'a tree =
  | Leaf
  | Node of 'a tree * 'a * 'a tree

(* 1. Rewrite with fold, without writing `rec`:
      - the maximum of a list of integers (what type must the result
        have? read L05 again before answering)
      - reverse
      - member *)
let maximum (l : int list) : int option = ignore l; None      (* to do *)
let reverse (l : 'a list) : 'a list = l                       (* to do *)

(* 2. The fold of trees.
      The functions from L05 (size, height, inorder) have the same shape,
      just as length/sum/concat_strings had among themselves.
      Extract the common shape. How many arguments will fold_tree have,
      and who decides that? *)
let fold_tree _on_leaf _on_node (_t : 'a tree) = failwith "to do"

(* 3. Without writing code: which functions have this type?

        ('a -> 'b) -> 'a list -> 'b list

      There is more than one, unlike 'a -> 'a. But there are not many:
      list three of them and say what they have in common.

   4. Without writing code: and this one?

        'a list -> 'a list -> 'a list

      Can a function of this type return [0]? *)

(* 5. An error worth making on purpose.
      Write  let bad_sum = List.fold_left ( + )  and read the type OCaml
      gives you. Then try to apply it to a list.
      What is missing, and how does the error message say it? *)

let () = ignore (maximum, reverse, fold)
