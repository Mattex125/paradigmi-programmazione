(* L06 - three functions from L04/L05, put one under the other. *)

let rec length = function
  | [] -> 0
  | _ :: r -> 1 + length r

let rec sum = function
  | [] -> 0
  | x :: r -> x + sum r

let rec concat_strings = function
  | [] -> ""
  | s :: r -> s ^ concat_strings r

(* Look at them without reading them. They have THE SAME SHAPE:

     | []     -> <a starting value>
     | x :: r -> <combine x with the result on the rest>

   Only two things change: the starting value and the way of combining.
   Let us pull them out, and they become arguments. *)

let rec fold combine initial = function
  | [] -> initial
  | x :: r -> combine x (fold combine initial r)

(* fold : ('a -> 'b -> 'b) -> 'b -> 'a list -> 'b
   in the standard library it is called List.fold_right (with the
   arguments in a different order). *)

let length'         l = fold (fun _ acc -> 1 + acc) 0 l
let sum'            l = fold ( + ) 0 l
let concat_strings' l = fold ( ^ ) "" l

(* --------------------------------------------------------------------- *)
(* map and filter are two special cases of the same shape. *)

let rec map f = function
  | [] -> []
  | x :: r -> f x :: map f r

let rec filter p = function
  | [] -> []
  | x :: r -> if p x then x :: filter p r else filter p r

let map'    f l = fold (fun x acc -> f x :: acc) [] l
let filter' p l = fold (fun x acc -> if p x then x :: acc else acc) [] l

(* It is worth stopping here. fold is not "one more useful function": it
   is THE RECIPE OF L04 turned into a value. Structural recursion on
   lists, written once, with the two holes left open.

   One case per constructor: [] gives `initial`, (::) gives `combine`.
   One argument per constructor. *)

(* --------------------------------------------------------------------- *)
(* Laws: properties holding for EVERY f, g, l. *)

let ( %> ) g f x = f (g x)      (* forward composition *)

let l = [ 1; 2; 3; 4; 5 ]
let f n = n * 3
let g n = n + 1

let () =
  Printf.printf "map f (map g l) = map (g %%> f) l        -> %b\n"
    (map f (map g l) = map (g %> f) l);
  Printf.printf "length (map f l) = length l             -> %b\n"
    (length (map f l) = length l);
  Printf.printf "length (filter p l) <= length l         -> %b\n"
    (length (filter (fun n -> n > 2) l) <= length l);
  Printf.printf "the fold versions agree                 -> %b\n"
    (length' l = length l
     && sum' l = sum l
     && concat_strings' [ "a"; "b" ] = concat_strings [ "a"; "b" ]
     && map' f l = map f l
     && filter' (fun n -> n > 2) l = filter (fun n -> n > 2) l)

(* Here we have CHECKED them on one list. The usual three rungs: in L08 we
   prove them for every list (by induction, and the shape of the proof
   will again be one case per constructor), in L09 QCheck looks for
   counterexamples on randomly generated lists.

   The first law, map f (map g l) = map (g %> f) l, is also a fact about
   performance: two passes become one. But we only learn to count the cost
   in L07. *)
