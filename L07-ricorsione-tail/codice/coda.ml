(* L07 - the question left open at the end of L06:
   fold builds the answer ON THE WAY BACK UP. On a long list, where are
   all the pending operations kept? *)

let rec sum = function
  | [] -> 0
  | x :: r -> x + sum r

(* The reduction model of L03 answers by itself. Follow it:

     sum [1; 2; 3]
   -> 1 + sum [2; 3]
   -> 1 + (2 + sum [3])
   -> 1 + (2 + (3 + sum []))
   -> 1 + (2 + (3 + 0))          <- here the expression is at its widest
   -> 1 + (2 + 3)
   -> 1 + 5
   -> 6

   The expression GROWS for half the way and then closes back up. At its
   widest point it contains n pending additions. Those pending operations
   are not free: they are kept somewhere, and that somewhere is the
   stack. *)

(* --------------------------------------------------------------------- *)

let rec sum_acc acc = function
  | [] -> acc
  | x :: r -> sum_acc (acc + x) r

(*   sum_acc 0 [1; 2; 3]
   -> sum_acc 1 [2; 3]
   -> sum_acc 3 [3]
   -> sum_acc 6 []
   -> 6

   The expression never grows. Each step REPLACES it instead of wrapping
   it. There is no pending operation: the partial sum has already been
   computed and travels in the accumulator. *)

(* The difference has a name. A call is in TAIL POSITION when its result
   IS the result of the function containing it, with nothing left to do
   afterwards.

     x + sum r           the call is NOT in tail position: the + follows it
     sum_acc (acc+x) r   the call IS in tail position: nothing follows it

   When the call is in tail position, the caller has nothing left to
   remember, and its place on the stack can be reused. *)

let () =
  let l = [ 1; 2; 3; 4; 5 ] in
  Printf.printf "sum     = %d\n" (sum l);
  Printf.printf "sum_acc = %d\n" (sum_acc 0 l)

(* Beware of one temptation: the accumulator is NOT a mutable variable in
   disguise. No acc is ever modified: at each call a new one is born,
   bound to a new value. It is exactly the let of L03, repeated. *)
