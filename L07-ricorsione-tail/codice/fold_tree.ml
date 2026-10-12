type 'a tree =
  | Leaf
  | Node of 'a tree * 'a * 'a tree

(* We get the predefined stack size, expressed in words (presumably 8 bytes), 
   and use it as our default value *)
let default_stack_words = (Gc.get ()).stack_limit

let default_n = 500_000
let default_h = 20

(* Builds a perfectly balanced tree of height h and thus 2**(h+1)-1 nodes *)
let rec balanced height =
  if height = 0 then
    Leaf
  else
    Node (
      balanced (height - 1),
      height,
      balanced (height - 1)
    )

(* Builds a degenerate tree with n nodes *)
let degenerate size =
  let rec aux tree value =
    if value = 0 then
      tree
    else
      aux (Node (tree, value, Leaf)) (value - 1)
  in
  aux Leaf size


(* General fold of a tree with non-tail recursion.
   If called with relatively little stack space, it causes overflow.
   On the other hand, if there is enough space, the function takes a
   time theoretically quadratic as the function of tree height. *)
let rec fold_tree on_leaf on_node = function
  | Leaf ->
      on_leaf
  | Node (left, value, right) ->
      on_node
        (fold_tree on_leaf on_node left)
        value
        (fold_tree on_leaf on_node right)

(* "Natural" use of fold_tree, with information
   traveling from the leaves to the root *)
let bottom_up_fold tree = 
  fold_tree [] (fun x y z -> x @ [y] @ z) tree

(* Calculating tree size via fold_tree *)
let size_via_fold tree = fold_tree 0 (fun l _ r -> l + 1 + r) tree

(* Calculating the depth of tree nodes seems to be possible
   only by traversing the tree top-down (precisely because the depth is 
   the distance from the root). Therefore, using fold_tree doesn't seem possible here.
   Indeed, the following function proceeds top-down and is relatively easy to understand. 
   It returns a list of pairs, where the second element is the depth 
   (while the first is the value at the node).  *)
let depths t =
  let rec go d = function
    | Leaf -> []
    | Node (l, x, r) -> go (d + 1) l @ [ (x, d) ] @ go (d + 1) r
  in
  go 0 t

(* Using fold_tree more "tricky" to calculate depth.
   While depth information necessarily continues to travel from 
   the root to the leaves, the construction of the list with 
   the (node, depth) pairs (i.e., the fold) occurs during the ascent
   phase. This precisely depends on the fact that we are using the 
   fold_tree function *)
let depths_via_fold tree =
  fold_tree
    (fun _depth -> [])
    (fun fold_left value fold_right ->
      fun depth ->
        fold_left (depth + 1)
        @ [(value, depth)]
        @ fold_right (depth + 1))
    tree
    0

(* Folding with tail-position recursion. The input tree T is folded
   using a list L that contains, at any given time, subtrees of T.
   Initially, L consists of T alone. At each recursive step, the root x
   of the subtree (l, x, r) at the head of L is considered, the value x 
   is accumulated (based on the function f), and the subtrees l and r
   are inserted into the list for future steps.  *)
let fold_elements f z t =
  let rec go acc = function
    | [] -> acc
    | Leaf :: rest -> go acc rest
    | Node (l, x, r) :: rest -> go (f acc x) (l :: r :: rest)
  in go z [t]

(* Here the fold is the list of nodes sorted in preorder *)
let tail_fold t =
  List.rev (fold_elements (fun acc x ->  x :: acc) [] t)

(* Main block *)
let () =
  let arg index default =
    if Array.length Sys.argv > index then
      int_of_string Sys.argv.(index)
    else
      default
  in

  let n = arg 1 default_n in
  let h = arg 2 default_h in
  let stack_words = arg 3 default_stack_words in

  Gc.set {
    (Gc.get ()) with
    Gc.stack_limit = stack_words
  };

  let degenerate_tree = degenerate n in
  let balanced_tree = balanced h in

  (try
     print_endline "Top-down fold and degenerate tree";
     let result = depths degenerate_tree in
     Printf.printf
       " non tail -> %d nodes\n%!"
       (List.length result)
   with
   | Stack_overflow ->
       print_endline " non tail -> Stack_overflow");

  (try
     print_endline "Top-down fold and balanced tree";
     let result = depths balanced_tree in
     Printf.printf
       " non tail -> %d nodes\n%!"
       (List.length result)
  with
   | Stack_overflow ->
       print_endline " non tail -> Stack_overflow");

  (try
     print_endline "Bottom-up fold and degenerate tree";
     let result = depths_via_fold degenerate_tree in
     Printf.printf
       " non tail -> %d nodes\n%!"
       (List.length result)
  with
   | Stack_overflow ->
       print_endline " non tail -> Stack_overflow");

  (try
     print_endline "Bottom-up fold and balanced tree";
     let result = depths_via_fold balanced_tree in
     Printf.printf
       " non tail -> %d nodes\n%!"
       (List.length result)
  with
   | Stack_overflow ->
       print_endline " non tail -> Stack_overflow");

  (try
     print_endline "Top-down fold and degenerate tree";
     let result = tail_fold degenerate_tree in
     Printf.printf
       "     tail -> %d nodes\n%!"
       (List.length result)
   with
   | Stack_overflow ->
       print_endline "     tail -> Stack_overflow");

  (try
     print_endline "Top-down fold and balanced tree";
     let result = tail_fold balanced_tree in
     Printf.printf
       "     tail -> %d nodes\n%!"
       (List.length result)
  with
   | Stack_overflow ->
       print_endline "     tail -> Stack_overflow");
  
  
