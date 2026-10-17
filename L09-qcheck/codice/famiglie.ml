(* L09 - le quattro famiglie di proprietà che coprono quasi tutti i casi.
 *
 *   ocamlfind ocamlopt -package qcheck -linkpkg famiglie.ml -o families
 *   ./families
 *
 * Quando non sapete quale proprietà scrivere, provate queste quattro in
 * quest'ordine. Serviranno in L10, dove scriverete le proprietà prima di
 * interrogare il modello. *)

let rec naive_rev = function [] -> [] | x :: r -> naive_rev r @ [ x ]
let rec rev_acc acc = function [] -> acc | x :: r -> rev_acc (x :: acc) r
let rec insert x = function
  | [] -> [ x ]
  | y :: r -> if x <= y then x :: y :: r else y :: insert x r
let rec sort = function [] -> [] | x :: r -> insert x (sort r)

open QCheck2
let a_list = Gen.(list nat_small)
let pl = Print.(list int)

(* --- 1. ANDATA E RITORNO ---------------------------------------------
   Due funzioni inverse: eseguire un'operazione e poi annullarla deve
   riportarvi al punto di partenza. È la famiglia più facile da riconoscere. *)
let round_trip =
  Test.make ~count:1000 ~name:"1. andata e ritorno: rev (rev l) = l" ~print:pl a_list
    (fun l -> naive_rev (naive_rev l) = l)

let round_trip_strings =
  Test.make ~count:1000 ~name:"1. andata e ritorno: int_of_string (string_of_int n) = n"
    ~print:Print.int Gen.int
    (fun n -> int_of_string (string_of_int n) = n)

(* --- 2. INVARIANTE ----------------------------------------------------
   Qualcosa che la funzione NON deve cambiare. Spesso è la proprietà più
   facile da enunciare quando il risultato esatto è difficile da descrivere. *)
let invariant =
  Test.make ~count:1000 ~name:"2. invariante: sort non cambia la lunghezza"
    ~print:pl a_list
    (fun l -> List.length (sort l) = List.length l)

(* --- 3. ORACOLO DI RIFERIMENTO ---------------------------------------
   Una seconda implementazione, più lenta ma evidentemente corretta,
   usata come termine di confronto. È un modo per verificare
   un'ottimizzazione: in L07 abbiamo reso veloce rev, e qui controlliamo
   che continui a calcolare lo stesso risultato. *)
let oracle =
  Test.make ~count:1000 ~name:"3. oracolo: rev_acc [] l = naive_rev l" ~print:pl a_list
    (fun l -> rev_acc [] l = naive_rev l)

let oracle_library =
  Test.make ~count:1000 ~name:"3. oracolo: sort l = List.sort compare l" ~print:pl a_list
    (fun l -> sort l = List.sort compare l)

(* --- 4. METAMORFICA ---------------------------------------------------
   Non dite quale sia il risultato: dite come DEVE CAMBIARE il risultato
   se modificate l'input in un modo noto. Utile proprio quando non è
   possibile calcolare la risposta corretta in altro modo. *)
let metamorphic =
  Test.make ~count:1000 ~name:"4. metamorfica: sort (rev l) = sort l" ~print:pl a_list
    (fun l -> sort (naive_rev l) = sort l)

(* =====================================================================
   E ORA IL PUNTO IMPORTANTE.

   La proprietà 2, insieme al fatto che il risultato è ordinato, sembra
   sufficiente a caratterizzare una funzione di ordinamento. Non lo è.
   Ecco una funzione palesemente sbagliata: *)

let fake_sort l = List.init (List.length l) (fun _ -> 0)

let rec is_sorted = function
  | [] | [ _ ] -> true
  | x :: (y :: _ as r) -> x <= y && is_sorted r

let fake_1 =
  Test.make ~count:1000 ~name:"la funzione sbagliata produce una lista ordinata" ~print:pl a_list
    (fun l -> is_sorted (fake_sort l))

let fake_2 =
  Test.make ~count:1000 ~name:"la funzione sbagliata conserva la lunghezza" ~print:pl a_list
    (fun l -> List.length (fake_sort l) = List.length l)

(* Supera entrambi i test. Manca la proprietà che afferma che gli
   elementi sono gli stessi: *)
let fake_3 =
  Test.make ~count:1000 ~name:"la funzione sbagliata è una permutazione dell'input"
    ~print:pl a_list
    (fun l -> List.sort compare (fake_sort l) = List.sort compare l)

let () =
  exit (QCheck_base_runner.run_tests_main
          [ round_trip; round_trip_strings; invariant; oracle;
            oracle_library; metamorphic; fake_1; fake_2; fake_3 ])

(* Risultato verificato: tutti i test passano tranne l'ultimo, che fallisce
 * con il controesempio ridotto [1].
 *
 * Una lista di UN SOLO elemento diverso da zero. Non si può ridurre
 * ulteriormente.
 *
 * MORALE, valida per tutto il corso: una suite tutta verde non significa
 * che il programma sia corretto. Significa che le proprietà che avete
 * scritto non sono bastate a distinguerlo, eventualmente, da uno sbagliato.
 * Questo sarà l'argomento di L22 ed è il motivo per cui in L10 si scrive
 * la specifica PRIMA di vedere il codice. *)
