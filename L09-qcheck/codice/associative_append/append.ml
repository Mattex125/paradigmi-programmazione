(* Test the associative law on append:
   append (append xs ys) zs = append xs (append ys zs))
*)
open QCheck2

let rec append l1 l2 = 
match l1 with 
| [] -> l2 
| x :: r -> x :: append r l2

let a_list = Gen.(list nat_small)   (* Equivale a: Gen.list Gen.nat_small *)
let pl = Print.(list int)

let t =
  Test.make 
  ~count:1000 
  ~name:"Ass@  (xs @ ys) @ zs = xs @ (ys @ zs)"
  ~print:Print.(triple pl pl pl) 
  Gen.(triple a_list a_list a_list)
  (fun (xs, ys, zs) -> append (append xs ys) zs = append xs (append ys zs))

let () = exit (QCheck_base_runner.run_tests_main [ t ])
