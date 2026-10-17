(* L09 - the laws proved in L08, turned into executable tests.
 *
 *   ocamlfind ocamlopt -package qcheck -linkpkg leggi_L08.ml -o laws && ./laws
 *
 * The very same sentences. In L08 we proved them for every list; here a
 * machine tries them on a thousand randomly generated lists. The two do
 * not replace each other: they check each other. *)

let rec append l1 l2 = match l1 with [] -> l2 | x :: r -> x :: append r l2
let rec length = function [] -> 0 | _ :: r -> 1 + length r
let rec map f = function [] -> [] | x :: r -> f x :: map f r
let ( %> ) g f x = f (g x)
let rec naive_rev = function [] -> [] | x :: r -> append (naive_rev r) [ x ]
let rec rev_acc acc = function [] -> acc | x :: r -> rev_acc (x :: acc) r

open QCheck2

let a_list = Gen.(list nat_small)
let pl = Print.(list int)

let f x = 3 * x + 1
let g x = x + 7

let t1 =
  Test.make ~count:1000 ~name:"T1  length (xs @ ys) = length xs + length ys"
    ~print:Print.(pair pl pl) Gen.(pair a_list a_list)
    (fun (xs, ys) -> length (append xs ys) = length xs + length ys)

let t2 =
  Test.make ~count:1000 ~name:"T2  (xs @ ys) @ zs = xs @ (ys @ zs)"
    ~print:Print.(triple pl pl pl) Gen.(triple a_list a_list a_list)
    (fun (xs, ys, zs) -> append (append xs ys) zs = append xs (append ys zs))

let l3 =
  Test.make ~count:1000 ~name:"L3  xs @ [] = xs" ~print:pl a_list
    (fun xs -> append xs [] = xs)

let t4 =
  Test.make ~count:1000 ~name:"T4  length (map f l) = length l" ~print:pl a_list
    (fun l -> length (map f l) = length l)

let t5 =
  Test.make ~count:1000 ~name:"T5  map f (map g l) = map (g %> f) l" ~print:pl a_list
    (fun l -> map f (map g l) = map (g %> f) l)

let t7 =
  Test.make ~count:1000 ~name:"T7  rev_acc acc l = naive_rev l @ acc"
    ~print:Print.(pair pl pl) Gen.(pair a_list a_list)
    (fun (acc, l) -> rev_acc acc l = append (naive_rev l) acc)

(* And the one we found false in L08. You were asked for the smallest
   counterexample: now we ask QCheck. *)
let false_one =
  Test.make ~count:1000 ~name:"??  map f (xs @ ys) = map f ys @ map f xs"
    ~print:Print.(pair pl pl) Gen.(pair a_list a_list)
    (fun (xs, ys) -> map f (append xs ys) = append (map f ys) (map f xs))

let () = exit (QCheck_base_runner.run_tests_main [ t1; t2; l3; t4; t5; t7; false_one ])

(* Verified report:
 *
 *   Test ??  map f (xs @ ys) = map f ys @ map f xs failed
 *   (12 shrink steps):
 *
 *   ([0], [1])
 *
 * Two lists of one element each. QCheck did not FIND this counterexample:
 * it found a large one, and then SHRANK it, one piece at a time, until
 * removing anything made the defect disappear.
 * Those are the "shrink steps", and their number changes at every run.
 *
 * The shrunk counterexample does not: tried with the seeds 1, 2, 12345
 * and 999 (./laws -s 1 and so on), it always comes out as ([0], [1]).
 * The shrinking converges to the same point even starting from different
 * places. *)
