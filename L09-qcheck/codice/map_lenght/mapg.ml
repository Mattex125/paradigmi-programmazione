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

let function_and_list =
  Gen.(
    pair
      (fun1 Observable.int int)
      (list int)
  )

let tg =
  Test.make 
  ~count:1000 
  ~name:"Map generalized (over all possible fun):  length (map f l) = length l"
  ~print:(fun (Fun (_, _), l) -> Print.(list int) l)
  function_and_list
  (fun (Fun (_, f), l) ->
      length (map f l) = length l)

let () = exit (QCheck_base_runner.run_tests_main [ tg ])
