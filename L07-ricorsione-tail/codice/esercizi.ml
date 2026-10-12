(* L07 - exercises. Compiles as it is: the bodies are to be rewritten. *)

(* 1. THE THRESHOLD, to be measured and not guessed.
      With  ./blowup_b n  (the ceiling is 1 000 000 words, set by the
      program itself) the non-tail sum goes through at n = 200 000 and
      fails at n = 300 000.
      Find by bisection the largest n that goes through.
      Then: how many stack words does one call consume? Does the
      arithmetic work out? *)

(* 2. Make these three tail recursive. For each of them say first, in
      writing, whether the result comes out in the right order or
      reversed. *)

let rec length = function
  | [] -> 0
  | _ :: r -> 1 + length r                     (* to be made tail recursive *)

let rec maximum = function
  | [] -> None
  | [ x ] -> Some x
  | x :: r ->
      (match maximum r with                    (* to be made tail recursive *)
       | None -> Some x
       | Some m -> Some (if x > m then x else m))

let rec map f = function
  | [] -> []
  | x :: r -> f x :: map f r                   (* to be made tail recursive *)


