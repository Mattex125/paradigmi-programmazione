(* L07 - the cost in TIME. So far we have talked about space.
 *
 *   ocamlopt costo.ml -o cost && ./cost
 *
 * Native compilation matters here: in bytecode everything is several times
 * slower and the figures below do not match. No library is needed -- the
 * clock is Sys.time, from the standard library, which measures PROCESSOR
 * time.
 *
 * Be patient: the last measurement takes over a minute, and that is
 * exactly the point. *)

(* The rev of L04, written following the structure of the type. *)
let rec naive_rev = function
  | [] -> []
  | x :: r -> naive_rev r @ [ x ]

(* The same, with an accumulator. *)
let rec rev_acc acc = function
  | [] -> acc
  | x :: r -> rev_acc (x :: acc) r

let time name f x =
  let t = Sys.time () in
  let r = f x in
  Printf.printf "  %-14s %8.3f s  (list of %d)\n%!"
    name (Sys.time () -. t) (List.length r)

let () =
  List.iter (fun n ->
    Printf.printf "n = %d\n" n;
    let l = List.init n (fun i -> i) in
    time "naive_rev" naive_rev l;
    time "rev_acc" (rev_acc []) l;
    print_newline ())
    [ 10_000; 20_000; 40_000; 80_000 ]

(* Measured on this machine, OCaml 5.5.0 native:
 *
 *   n = 10000     naive_rev    0.218 s      rev_acc   0.000 s
 *   n = 20000     naive_rev    1.496 s      rev_acc   0.000 s
 *   n = 40000     naive_rev   10.425 s      rev_acc   0.001 s
 *   n = 80000     naive_rev   70.372 s      rev_acc   0.003 s
 *
 * Doubling n multiplies the time of naive_rev by about 7 (6.9, 7.0, 6.8).
 * The operation count is quadratic, so one would expect 4; the rest is
 * paid by the garbage collector, because the program also allocates
 * Theta(n^2) list cells. The gap is therefore WORSE than quadratic, not
 * better.
 *
 * At n = 80000 the two versions differ by a factor of twenty thousand.
 * The absolute figures depend on the machine; the ratios do not.
 *
 * THE CAUSE is in a single line:
 *
 *   naive_rev r @ [x]
 *
 * The @ operator has to copy the whole of its first argument. So at every
 * step the entire already-reversed list is copied: 1 + 2 + ... + n.
 *
 * rev_acc never copies anything: it puts an element in front, which costs
 * a single cell.
 *
 *   x :: acc      <- one cell
 *   acc @ [x]     <- as many cells as acc is long
 *
 * PRACTICAL RULE, valid for the whole course: if an @ appears inside a
 * recursion over lists, stop and count. It can almost always be replaced
 * by a :: and an accumulator.
 *
 * CONNECTION. In L04 we wrote rev this way and I said "today we only care
 * that it is CORRECT, we pay the bill in L07". Here it is.
 * Note, though, that the two versions compute the same thing: in L08 we
 * prove that rev_acc [] l = naive_rev l for every l, which is the serious
 * way of saying that the optimisation did not break anything. *)
