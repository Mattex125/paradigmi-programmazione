(* Does map distribute over append? map f (xs @ ys) = map f ys @ map f xs
*)

open QCheck2

let rec map f = function
| [] -> []
| x :: r -> f x :: map f r

let successor x = x + 1

let distr =
  Test.make 
  ~count:1000 
  ~name:"Distributive law: map f (xs @ ys) = map f ys @ map f xs"
  ~print:Print.(pair Print.(list int) Print.(list int))
  Gen.(
    pair	
      (list int)
      (list int)
  )
  (fun (xs, ys) -> map successor (xs @ ys) = map successor ys @ map successor xs)

let () = exit (QCheck_base_runner.run_tests_main [ distr ])
