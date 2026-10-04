(* L05 - the same recipe as L04, on data that branches.

   In L04: a list is Nil, or an element in front of a list.
   Today:  a tree is a Leaf, or a node with TWO subtrees. *)

type 'a tree =
  | Leaf
  | Node of 'a tree * 'a * 'a tree

(*        4
        /   \
       2     5
      / \
     1   3                                                    *)
let example =
  Node (Node (Node (Leaf, 1, Leaf), 2, Node (Leaf, 3, Leaf)),
        4,
        Node (Leaf, 5, Leaf))

(* The recipe is identical to the one in L04, and the type dictates it:
   one case per constructor, and the recursion goes where the type goes.
   Here the type recurs TWICE, so the code does too. *)

let rec size = function
  | Leaf -> 0
  | Node (l, _, r) -> size l + 1 + size r

let rec height = function
  | Leaf -> 0
  | Node (l, _, r) -> 1 + max (height l) (height r)

let append x xl = 
  match x with
  | [] -> xl
  | y :: yl -> y :: append yl xl

let rec inorder = function
  | Leaf -> []
  | Node (l, x, r) -> inorder l @ [ x ] @ inorder r

(* A property relating two different functions on the same data:

     size t = List.length (inorder t)         for EVERY t

   Today we CHECK it on one example. In L08 we PROVE it for every tree,
   and the proof will have the same shape as these functions: one case per
   constructor. In L09 we will let QCheck look for counterexamples on
   thousands of randomly generated trees.
   Three rungs of the L02 ladder, on the same sentence. *)

let () =
  Printf.printf "size             : %d\n" (size example);
  Printf.printf "height           : %d\n" (height example);
  Printf.printf "inorder          : %s\n"
    (String.concat " " (List.map string_of_int (inorder example)));
  Printf.printf "the property holds on this tree: %b\n"
    (size example = List.length (inorder example))
