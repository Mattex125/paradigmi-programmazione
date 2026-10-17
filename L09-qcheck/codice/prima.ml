(* L09 - the first test. Anatomy of a property.
 *
 *   ocamlfind ocamlopt -package qcheck -linkpkg prima.ml -o first
 *   ./first
 *
 * Useful options:  ./first -v        also shows the tests that passed
 *                  ./first -s 12345  fixes the seed, to repeat a run *)

let rec map f = function
  | [] -> []
  | x :: r -> f x :: map f r

let rec length = function
  | [] -> 0
  | _ :: r -> 1 + length r

open QCheck2

(* A test has four parts. Look at them one at a time: *)
let invariant =
  Test.make
    ~count:1000                              (* how many inputs to try *)
    ~name:"length (map f l) = length l"      (* the name, shown in the report *)
    ~print:Print.(list int)                  (* how to PRINT a counterexample *)
    Gen.(list nat_small)                     (* the GENERATOR of inputs *)
    (fun l -> length (map succ l) > length l)          (* the PROPERTY *)

(* The generator and the property are the two new things.
   The generator says WHAT to try; the property says WHAT must hold on
   everything that was tried.

   Note that the property names no particular value: it is not a test with
   an input and an expected result, it is the statement of L08 written in
   an executable form. *)

let () = exit (QCheck_base_runner.run_tests_main [ invariant ])

(* TRY REMOVING ~print and making the test fail (for instance by changing
   = into <). The report will say
     <no printer>
   and the counterexample will be useless. QCheck can generate inputs and
   can shrink them, but it does not know how they are written down: that
   part you have to tell it. *)
