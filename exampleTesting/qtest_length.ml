(* Test the correctness of a length computed with a fold (with accumulator):
   length_fold l = List.length l

   Generalization: length_fold does not look at the elements, so it must
   not change if we map ANY function over the list:
   length_fold (map f l) = List.length l
*)

open QCheck2

(* Function under test: the accumulator acc starts from 0 and
   is incremented by 1 for every element ('_' = element value ignored). *)
let length_fold l = List.fold_left (fun acc _ -> acc + 1) 0 l

(* Generator and printer, with a name:
   Gen.(list int)   = generates random lists of ints
   Print.(list int) = prints such a list (used to show the counterexample) *)
let a_list = Gen.(list int)
let pl = Print.(list int)

(* Simple version: concrete generator.
   Test.make ~count (how many random lists) ~name (the property as a formula)
   ~print (how to show a failing input) generator (fun input -> property) *)
let ts =
  Test.make
    ~count:1000
    ~name:"length_fold agrees with List.length: length_fold l = List.length l"
    ~print:pl
    a_list
    (fun l -> length_fold l = List.length l)

(* Generalized version: the generator makes a pair (f, l) where f is a
   random function int -> int (fun1 with Observable.int for its argument).
   Fun (_, f) is the constructor that gives back the function f.
   Functions cannot be printed, so we print only the list. *)
let function_and_list =
  Gen.(
    pair
      (fun1 Observable.int int)
      (list int)
  )

let tg =
  Test.make
    ~count:1000
    ~name:"length_fold generalized (over all possible fun): length_fold (map f l) = List.length l"
    ~print:(fun (Fun (_, _), l) -> pl l)
    function_and_list
    (fun (Fun (_, f), l) ->
       length_fold (List.map f l) = List.length l)

(* Runs all the tests; exit code 0 if all pass (so 'dune test' is happy) *)
let () = exit (QCheck_base_runner.run_tests_main [ ts; tg ])
