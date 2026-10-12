(* L07 - making the stack blow up, and why it is not as easy as you would
 * expect.
 *
 * HOW TO RUN IT
 *
 *   ocamlc esplode.ml -o blowup_b     (bytecode: the limit below works)
 *   ./blowup_b                        n = 500000, ceiling = 1000000 words
 *   ./blowup_b 100000                 chooses n
 *   ./blowup_b 500000 134217728       chooses n AND the ceiling
 *                                     (134217728 is the default ceiling)
 *
 * The program prints both numbers before starting, because they are easy
 * to confuse:
 *
 *   the first argument  is the LENGTH OF THE LIST
 *   the second argument is the STACK CEILING IN WORDS
 *
 * A word is 8 bytes on a 64-bit machine, so 1 000 000 words = 8 MB, and
 * the default ceiling of 134 217 728 words is about 1 GB.
 *
 * FIRST SURPRISE, and it is the point of the lecture. Compile it with
 * ocamlopt and run it with the DEFAULT limit, that is without the second
 * argument and without any environment variable:
 *
 *   ocamlopt esplode.ml -o blowup && ./blowup 20000000 134217728
 *   non tail -> 199999990000000
 *
 * Twenty million elements, non-tail recursion, no exception. And lowering
 * ulimit -s changes nothing: verified. The reason is that OCaml 5 does not
 * use the system stack for OCaml recursion -- it uses its own, allocated on
 * the heap, which GROWS when needed.
 *
 * But it does not grow for ever. There IS a limit, and the runtime will
 * tell you what it is:
 *
 *   (Gc.get ()).Gc.stack_limit   ->   134217728 words, that is about 1 GB
 *
 * So the sentence you have heard a thousand times -- "non-tail recursion
 * blows the stack" -- is not false: it is just that the default ceiling is
 * a gigabyte, so at realistic sizes you never touch it. What the recursion
 * really does is CONSUME MEMORY in proportion to the length of the list,
 * silently. See memoria.ml: 263 MB for ten million elements, which sits
 * comfortably below the ceiling -- no exception, just memory.
 *
 * SECOND THING. Lower the ceiling and the exception comes back. Two
 * equivalent ways, and both work in bytecode AND in native code:
 *
 *   - from inside the program, with Gc.set, as done below;
 *   - from outside:  OCAMLRUNPARAM=l=1000000 ./blowup_b 500000
 *     (the variable must be on the SAME command line)
 *
 * THE THRESHOLDS ARE DIFFERENT, and the difference is instructive.
 * With a ceiling of 1 000 000 words, verified on OCaml 5.5.0:
 *
 *   bytecode   n = 200 000 goes through, n = 500 000 does not
 *   native     n = 500 000 goes through, n = 700 000 does not
 *
 * Same program, same ceiling, thresholds two to three times apart: a
 * bytecode frame costs more words than a native one. The cost in space is
 * linear in both cases -- it is the constant that changes, and the
 * constant depends on how you compiled. *)

let default_n = 500_000

let default_stack_words = (Gc.get ()).stack_limit

(* let () =
  Printf.printf "OCAMLRUNPARAM = %d words\n%!" default_stack_words *)

let rec sum = function
  | [] -> 0
  | x :: r -> x + sum r

let rec sum_acc acc = function
  | [] -> acc
  | x :: r -> sum_acc (acc + x) r

let () =
  let arg i d = if Array.length Sys.argv > i then int_of_string Sys.argv.(i) else d in
  let n = arg 1 default_n in
  let words = arg 2 default_stack_words in

  (* This is the line that sets the ceiling. It works in bytecode and in
     native code alike. What does NOT work is ulimit -s: OCaml 5 does not
     use the system stack for OCaml recursion. *)
  let c = Gc.get () in
  Printf.printf "stack limit: %d words (was %d)\n%!" words c.Gc.stack_limit;
  Gc.set { c with Gc.stack_limit = words };
  Printf.printf "list length: %d\n%!" n;

  let l = List.init n (fun i -> i) in
  (try Printf.printf "  non tail -> %d\n%!" (sum l)
   with Stack_overflow -> print_endline "  non tail -> Stack_overflow");
  (try Printf.printf "  tail     -> %d\n%!" (sum_acc 0 l)
   with Stack_overflow -> print_endline "  tail     -> Stack_overflow")

(* The accumulator version does not raise the exception with ANY reasonable
 * limit, because it uses no stack. That is the whole point. *)
