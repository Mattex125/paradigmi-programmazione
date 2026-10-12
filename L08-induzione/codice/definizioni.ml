(* L08 - the definitions we reasoned about today, with a NAME for every
   equation. In the proofs, every step cites one of these names. *)

let rec append l1 l2 =
  match l1 with
  | [] -> l2                              (* [A1]  [] @ ys = ys                  *)
  | x :: r -> x :: append r l2            (* [A2]  (x :: r) @ ys = x :: (r @ ys) *)

let rec length = function
  | [] -> 0                               (* [L1]  length [] = 0                 *)
  | _ :: r -> 1 + length r                (* [L2]  length (x :: r) = 1 + length r *)

let rec map f = function
  | [] -> []                              (* [M1]  map f [] = []                      *)
  | x :: r -> f x :: map f r              (* [M2]  map f (x :: r) = f x :: map f r    *)

let ( %> ) g f x = f (g x)                (* [C]   (g %> f) x = f (g x)          *)

let rec naive_rev = function
  | [] -> []                              (* [R1]  naive_rev [] = []                        *)
  | x :: r -> append (naive_rev r) [ x ]  (* [R2]  naive_rev (x :: r) = naive_rev r @ [x]   *)

let rec rev_acc acc = function
  | [] -> acc                             (* [RA1] rev_acc acc [] = acc                       *)
  | x :: r -> rev_acc (x :: acc) r        (* [RA2] rev_acc acc (x :: r) = rev_acc (x :: acc) r *)

type 'a tree =
  | Leaf
  | Node of 'a tree * 'a * 'a tree

let rec size = function
  | Leaf -> 0                                   (* [D1]  size Leaf = 0 *)
  | Node (l, _, r) -> size l + 1 + size r       (* [D2]  size (Node (l, x, r)) = size l + 1 + size r *)

let rec inorder = function
  | Leaf -> []                                                        (* [I1]  inorder Leaf = [] *)
  | Node (l, x, r) -> append (inorder l) (append [ x ] (inorder r))   (* [I2]  inorder (Node (l, x, r)) = inorder l @ ([x] @ inorder r) *)

(* A note on [I2]. The @ operator associates to the RIGHT, so that line means
   inorder l @ ([x] @ inorder r), which is what is written here. *)
