(* L09 - exercises.
 *
 *   ocamlfind ocamlopt -package qcheck -linkpkg esercizi.ml -o exercises
 *   ./exercises
 *
 * The file compiles and runs as it is: the tests to be written are marked. *)

open QCheck2
let a_list = Gen.(list nat_small)
let pl = Print.(list int)

(* 1. compress: [1;1;2;1] -> [(1,2); (2,1); (1,1)]
      CONSECUTIVE equal elements become a pair (element, how many times).
      It is the function of exercise B2 in the exam paper.

      Write THREE properties before looking at any implementation:
        - one of the "round trip" family;
        - one invariant;
        - one relating compress to a function you already know.
      Then write compress and try them. *)
let compress (_ : int list) : (int * int) list = []   (* to be written *)

(* 2. The trick from famiglie.ml, turned on you.
      Write a WRONG version of compress that passes your three properties.
      If you cannot, your properties were good: say so.
      If you can, add the property that exposes it. *)

(* 3. Generating valid inputs.
      To test a function that expects an ALREADY SORTED list you cannot
      use Gen.list: almost no random list is sorted.
      Write a generator of sorted lists.
      Hint: start from any list and sort it with Gen.map. Then ask
      yourself: what do you lose? Which sorted lists will NEVER be
      generated that way? *)
let gen_sorted : int list Gen.t = Gen.map (List.sort compare) a_list

let example_3 =
  Test.make ~count:1000 ~name:"3. the generator produces sorted lists"
    ~print:pl gen_sorted
    (fun l -> l = List.sort compare l)

(* 4. Exercise 1 of L08, in QCheck.
      leaves t = size t + 1. Reuse the generator from alberi.ml.
      Then try breaking the generator, as suggested at the bottom of that
      file, and see whether the test notices. *)

(* 5. Without code.
      The suite in famiglie.ml, on fake_sort, was green on two properties
      out of three. Write in three lines: what should you have asked
      yourself BEFORE writing the properties, in order to notice?
      The answer is not "try more cases". *)

let () = exit (QCheck_base_runner.run_tests_main [ example_3 ])
