(* Map fusion: per ogni `f`, `g`, `l`:  `map f (map g l) = map (g %> f) l`
*)
open QCheck2

let rec map f = function
| [] -> []
| x :: r -> f x :: map f r

let (%>) f g x = g (f x)


let functions_and_list =
  Gen.(
    triple
      (fun1 Observable.int int)
      (fun1 Observable.int int)
      (list int)
  )

let t =
  Test.make 
  ~count:1000 
  ~name:"Map fusion: map f (map g l) = map (g %> f) l"
  functions_and_list
  (fun (Fun (_, f), Fun (_, g), l) -> map f (map g l) = map (g %> f) l)

let () = exit (QCheck_base_runner.run_tests_main [ t ])
