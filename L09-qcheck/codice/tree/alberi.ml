(* L09 - generating trees: when you have to write the generator yourself.
 *
 *   ocamlfind ocamlopt -package qcheck -linkpkg alberi.ml -o trees && ./trees
 *
 * For lists QCheck already has everything. For a type of your own it does
 * not: the generator is code you write, and it is part of the
 * specification just as much as the property. *)

type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree

let rec size = function
  | Leaf -> 0
  | Node (l, _, r) -> size l + 1 + size r

let rec inorder = function
  | Leaf -> []
  | Node (l, x, r) -> inorder l @ [ x ] @ inorder r

let rec height = function
  | Leaf -> 0
  | Node (l, _, r) -> 1 + max (height l) (height r)

open QCheck2

(* The generator. It reads like this:
     - the size n is halved at every level, otherwise the tree explodes;
     - at every node we choose between Leaf (weight 1) and Node (weight 3),
       so that on average the trees are dense enough to be interesting. *)
let gen_tree =
  Gen.sized_size (Gen.int_bound 6) @@
  Gen.fix (fun self n ->
      match n with
      | 0 -> Gen.pure Leaf
      | n ->
          Gen.oneof_weighted
            [ (1, Gen.pure Leaf);
              (3, Gen.map3 (fun l x r -> Node (l, x, r))
                    (self (n / 2)) Gen.nat_small (self (n / 2))) ])

let rec show = function
  | Leaf -> "L"
  | Node (l, x, r) -> "N(" ^ show l ^ "," ^ string_of_int x ^ "," ^ show r ^ ")"

(* Theorem 6 of L08. *)
let t6 =
  Test.make ~count:2000 ~name:"T6  size t = length (inorder t)"
    ~print:show 
    gen_tree
    (fun t -> size t = List.length (inorder t))

(* A false one, to see the shrinking on a tree-shaped type. *)
let false_one =
  Test.make ~count:2000 ~name:"??  height t = size t" ~print:show gen_tree
    (fun t -> height t = size t)

let () = exit (QCheck_base_runner.run_tests_main [ t6; false_one ])

(* Verified report:
 *
 *   Test ??  height t = size t failed (7 shrink steps):
 *   N(N(L,0,L),0,N(L,0,L))
 *
 * That is, the tree with a root and two children: height 2, size 3.
 * It really is the smallest one on which the two differ -- on a
 * degenerate tree height and size coincide, which is why the property
 * looks true as long as you only try examples by hand.
 *
 * TO TRY, and this is the most important thing in this file.
 * Change  Gen.int_bound 6  into  Gen.int_bound 1  and run it again.
 *
 * Verified: the FALSE property passes. "success (ran 2 tests)", over two
 * thousand generated trees.
 *
 * Not because it became true, but because at that size the generator only
 * produces Leaf and Node(L,x,L), and on those height and size really do
 * coincide. The counterexample exists, and nobody ever proposed it. With
 * Gen.int_bound 2 it shows up again immediately.
 *
 * MORAL: the generator is part of the specification just as much as the
 * property. A green suite with a poor generator says nothing, and you
 * cannot tell from the report: it says "success" all the same.
 *
 * (The weights in oneof_weighted matter much less: tried inverting them
 * from (1,3) to (3,1), the defect shows up anyway, and indeed sooner.) *)
