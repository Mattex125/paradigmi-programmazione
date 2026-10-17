(* L09 - the four families of properties that cover almost every case.
 *
 *   ocamlfind ocamlopt -package qcheck -linkpkg famiglie.ml -o families
 *   ./families
 *
 * When you do not know which property to write, try these four in this
 * order. It is needed for L10, where you will write the properties before
 * querying the model. *)

let rec naive_rev = function [] -> [] | x :: r -> naive_rev r @ [ x ]
let rec rev_acc acc = function [] -> acc | x :: r -> rev_acc (x :: acc) r
let rec insert x = function
  | [] -> [ x ]
  | y :: r -> if x <= y then x :: y :: r else y :: insert x r
let rec sort = function [] -> [] | x :: r -> insert x (sort r)

open QCheck2
let a_list = Gen.(list nat_small)
let pl = Print.(list int)

(* --- 1. ROUND TRIP ----------------------------------------------------
   Two inverse functions: doing and undoing must bring you back to the
   starting point. It is the easiest family to recognise. *)
let round_trip =
  Test.make ~count:1000 ~name:"1. round trip: rev (rev l) = l" ~print:pl a_list
    (fun l -> naive_rev (naive_rev l) = l)

let round_trip_strings =
  Test.make ~count:1000 ~name:"1. round trip: int_of_string (string_of_int n) = n"
    ~print:Print.int Gen.int
    (fun n -> int_of_string (string_of_int n) = n)

(* --- 2. INVARIANT -----------------------------------------------------
   Something the function must NOT change. Often it is the easiest thing
   to state when the exact result is hard to describe. *)
let invariant =
  Test.make ~count:1000 ~name:"2. invariant: sort does not change the length"
    ~print:pl a_list
    (fun l -> List.length (sort l) = List.length l)

(* --- 3. REFERENCE ORACLE ---------------------------------------------
   A second implementation, slower but obviously right, used as a
   yardstick. It is the way to test an optimisation: L07 made rev fast,
   and here we check that it still computes the same thing. *)
let oracle =
  Test.make ~count:1000 ~name:"3. oracle: rev_acc [] l = naive_rev l" ~print:pl a_list
    (fun l -> rev_acc [] l = naive_rev l)

let oracle_library =
  Test.make ~count:1000 ~name:"3. oracle: sort l = List.sort compare l" ~print:pl a_list
    (fun l -> sort l = List.sort compare l)

(* --- 4. METAMORPHIC ---------------------------------------------------
   You do not say what the result is: you say how the result MUST CHANGE
   if you change the input in a known way. Useful precisely when the right
   answer cannot be computed in any other way. *)
let metamorphic =
  Test.make ~count:1000 ~name:"4. metamorphic: sort (rev l) = sort l" ~print:pl a_list
    (fun l -> sort (naive_rev l) = sort l)

(* =====================================================================
   AND NOW THE SERIOUS POINT.

   Property 2, together with the result being sorted, looks like enough to
   characterise a sorting function. It is not. Here is a blatantly wrong
   function: *)

let fake_sort l = List.init (List.length l) (fun _ -> 0)

let rec is_sorted = function
  | [] | [ _ ] -> true
  | x :: (y :: _ as r) -> x <= y && is_sorted r

let fake_1 =
  Test.make ~count:1000 ~name:"the fake one produces a sorted list" ~print:pl a_list
    (fun l -> is_sorted (fake_sort l))

let fake_2 =
  Test.make ~count:1000 ~name:"the fake one preserves the length" ~print:pl a_list
    (fun l -> List.length (fake_sort l) = List.length l)

(* It passes both. What is missing is the property saying that the
   elements are the same ones: *)
let fake_3 =
  Test.make ~count:1000 ~name:"the fake one is a permutation of the input"
    ~print:pl a_list
    (fun l -> List.sort compare (fake_sort l) = List.sort compare l)

let () =
  exit (QCheck_base_runner.run_tests_main
          [ round_trip; round_trip_strings; invariant; oracle;
            oracle_library; metamorphic; fake_1; fake_2; fake_3 ])

(* Verified report: everything passes except the last one, which fails
 * with the shrunk counterexample  [1].
 *
 * A list of ONE element different from zero. It does not get smaller than
 * that.
 *
 * MORAL, and it holds for the whole course: a green suite does not say
 * that the program is right. It says that the properties you wrote were
 * not enough to (possibly) tell it apart from a wrong one. That will be 
 * the subject of L22, and it is the reason why in L10 the specification 
 * is written BEFORE seeing the code. *)
