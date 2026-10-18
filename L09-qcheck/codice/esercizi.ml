(* L09 - esercizi.
 *
 *   ocamlfind ocamlopt -package qcheck -linkpkg esercizi.ml -o exercises
 *   ./exercises
 *
 * Il file si compila e si esegue così com'è: i test da scrivere sono indicati. *)

open QCheck2
let a_list = Gen.(list nat_small)
let pl = Print.(list int)

(* 1. compress: [1;1;2;1] -> [(1,2); (2,1); (1,1)]
      Gli elementi uguali CONSECUTIVI diventano una coppia
      (elemento, numero di occorrenze).
      È la funzione dell'esercizio B2 nel compito d'esame.

      Scrivete TRE proprietà prima di guardare una qualsiasi implementazione:
        - una della famiglia «andata e ritorno»;
        - un'invariante;
        - una che metta in relazione compress con una funzione che conoscete già.
      Poi scrivete compress e provate le proprietà. *)
let compress (_ : int list) : (int * int) list = []   (* da scrivere *)

(* 2. Il trucco di famiglie.ml, questa volta a vostre spese.
      Scrivete una versione SBAGLIATA di compress che superi le vostre
      tre proprietà. Se non ci riuscite, le vostre proprietà erano buone:
      ditelo. Se ci riuscite, aggiungete la proprietà che rivela l'errore. *)

(* 3. Generare input validi.
      Per verificare una funzione che si aspetta una lista GIÀ ORDINATA,
      non potete usare Gen.list: quasi nessuna lista casuale è ordinata.
      Scrivete un generatore di liste ordinate.
      Suggerimento: partite da una lista qualsiasi e ordinatela con Gen.map.
      Poi chiedetevi: cosa perdete? Quali liste ordinate non verranno MAI
      generate in questo modo? *)
let gen_sorted : int list Gen.t = Gen.map (List.sort compare) a_list

let example_3 =
  Test.make ~count:1000 ~name:"3. il generatore produce liste ordinate"
    ~print:pl gen_sorted
    (fun l -> l = List.sort compare l)

(* 4. Senza scrivere codice.
      La suite di famiglie.ml, applicata a fake_sort, dava esito positivo
      per due proprietà su tre. Scrivete in tre righe: cosa avreste dovuto
      chiedervi PRIMA di scrivere le proprietà, per accorgervi del problema?
      La risposta non è «provare più casi». *)

let () =
      if not !Sys.interactive then
            exit (QCheck_base_runner.run_tests_main [ example_3 ])
