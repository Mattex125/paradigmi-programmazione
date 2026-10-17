(* Naive reverse vs reverse: rev acc l = append (naive_rev l) acc
*)

open QCheck2

let rec rev_acc acc = function
| [] -> acc
| x::r -> rev_acc (x::acc) r

let rec naive_rev = function
| [] -> []
| x :: r -> naive_rev r @ [x]

let rec append l1 l2 = 
match l1 with 
| [] -> l2 
| x :: r -> x :: append r l2

let trev =
  Test.make 
  ~count:1000 
  ~name:"Rev: rev_acc acc l = append (naive_rev l) acc"
  ~print:Print.(pair Print.(list int) Print.(list int))
  Gen.(
    pair
      (list int)
      (list int)
  )
  (fun (acc, l) -> rev_acc acc l = append (naive_rev l) acc)

let () = exit (QCheck_base_runner.run_tests_main [ trev ])
