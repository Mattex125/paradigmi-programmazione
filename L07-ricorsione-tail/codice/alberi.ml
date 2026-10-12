(* L07 - exercise 2 of L06 (fold_tree), and the surprise it hides.
 *
 *   ocamlc alberi.ml -o trees && ./trees
 *
 * The program lowers the stack ceiling by itself (see esplode.ml): without
 * that, nothing overflows and the comparison below says nothing. *)

type 'a tree =
  | Leaf
  | Node of 'a tree * 'a * 'a tree

let rec size = function
  | Leaf -> 0
  | Node (l, _, r) -> size l + 1 + size r

(* A balanced tree: every node has two equal children.
   height h  ->  2^h - 1 nodes *)
let rec balanced h =
  if h = 0 then Leaf else Node (balanced (h - 1), h, balanced (h - 1))

(* A degenerate tree: every node has a single child. It is a list in
   disguise. n nodes, height n. *)
let degenerate n =
  let rec aux acc k = if k = 0 then acc else aux (Node (acc, k, Leaf)) (k - 1) in
  aux Leaf n

(* one million words instead of the default 134 217 728 *)
let () = Gc.set { (Gc.get ()) with Gc.stack_limit = 1_000_000 }

let try_it name build =
  match size (build ()) with
  | s -> Printf.printf "%-28s size = %d\n%!" name s
  | exception Stack_overflow -> Printf.printf "%-28s Stack_overflow\n%!" name

let () =
  try_it "balanced, height 21" (fun () -> balanced 21);
  try_it "degenerate, 2 000 000 nodes" (fun () -> degenerate 2_000_000)

(* Measured, bytecode, with the ceiling at 1 000 000 words:
 *
 *   balanced, height 21          size = 2097151
 *   degenerate, 2 000 000 nodes  Stack_overflow
 *
 * Two million nodes in both cases. The first goes through, the second
 * does not.
 *
 * The difference is not the SIZE, it is the HEIGHT. `size` goes all the
 * way down one branch before coming back up, so the pending calls are as
 * many as the height:
 *
 *   balanced   with 2 million nodes  ->  height 21
 *   degenerate with 2 million nodes  ->  height 2 000 000
 *
 * CONSEQUENCE, and this is the thing to take away: for lists the space
 * cost of recursion is linear in the length, ALWAYS. For trees it depends
 * on the SHAPE of the data, and a balanced tree can be walked without any
 * precaution even when it is enormous, because the height grows like the
 * logarithm.
 *
 * That is why on a tree the non-tail version is often acceptable and on a
 * list it almost never is. And indeed `size` cannot be made tail
 * recursive just by adding an accumulator: the recursion is double, and
 * to do it properly you would have to manage by hand a stack of the
 * subtrees still to visit. That is, rewrite by hand what the stack was
 * already doing.
 *
 * Sometimes the cure costs more than the disease: it is a decision, not a
 * rule. *)
