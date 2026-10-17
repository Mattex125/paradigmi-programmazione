(* Test the "length invariance" of a mapping:
   length (map f l) = length l
*)

open QCheck2

let rec length = function
| [] -> 0
| _ :: r -> 1 + length r

let rec map f = function
| [] -> []
| x :: r -> f x :: map f r

let square x = x * x

let a_list = Gen.(list int)
let pl = Print.(list int)

let ts =
  Test.make 
  ~count:1000 
  ~name:"Map preserves length:  length (map f l) = length l"
  ~print:pl
  a_list
  (fun l -> length (map square l) = length l)

let () = exit (QCheck_base_runner.run_tests_main [ ts ])
