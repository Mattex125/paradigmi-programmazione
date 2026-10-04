(* L03 — riduzioni da svolgere a mano.
   Negli esercizi adottiamo, per convenzione, una riduzione da sinistra verso destra.
   Scrivete OGNI passo. All'esame si valutano i passi, non il risultato. *)

(* 1 *)
let es1 =
  let f = fun x -> fun y -> x + 2 * y in
  let g = f 3 in
  g (g 1)

(* 2 — attenzione all'ordine: quale argomento si riduce per primo? *)
let es2 =
  let doppio = fun n -> n * 2 in
  let somma = fun a -> fun b -> a + b in
  somma (doppio 3) (doppio (doppio 1))

(* 3 — quante volte viene ridotto (quadrato 2)? *)
let es3 =
  let quadrato = fun n -> n * n in
  let usa = fun v -> v + v in
  usa (quadrato 2)
  
(* 4 — una funzione passata come argomento *)
let es4 =
  let incrementa = fun x -> x + 1 in
  let due_volte = fun f -> fun x -> f (f x) in
  due_volte incrementa 3

(* 5 — quale ramo viene valutato? *)
let es5 =
  let scegli = fun x ->
    if x = 0 then 42 else 10 / x
  in
  scegli (2 - 2)

(* 6 — chiusura e applicazioni parziali *)
let es6 =
  let somma = fun x -> fun y -> x + y in
  let aggiungi3 = somma 3 in
  let applica = fun f -> fun x -> f (f x) in
  applica aggiungi3 1

(* 7 — qui il calcolo viene davvero eseguito due volte *)
let es7 =
  let quadrato = fun n -> n * n in
  let calcola = fun () -> quadrato 2 in
  let usa_due_volte = fun f -> f () + f () in
  usa_due_volte calcola

(* 8 — && non valuta sempre il secondo operando *)
let es8 =
  let positivo = fun x -> x > 0 in
  positivo (-1) && (10 / 0 > 2)

(* 9 — riduzione ricorsiva *)
let es9 =
  let rec somma_fino_a = fun n ->
    if n = 0 then 0
    else n + somma_fino_a (n - 1)
  in
  somma_fino_a 3

let () =
  Printf.printf
    "es1 = %d\nes2 = %d\nes3 = %d\n\
     es4 = %d\nes5 = %d\nes6 = %d\n\
     es7 = %d\nes8 = %b\nes9 = %d\n"
    es1 es2 es3 es4 es5 es6 es7 es8 es9

(* ------------------------------------------------------------------
   RISULTATI (per controllarvi, non per saltare i passi)

   es1 = 13
     g (g 1) -> g (3 + 2*1) -> g (3 + 2) -> g 5
             -> 3 + 2*5 -> 3 + 10 -> 13

   es2 = 10
     entrambi gli argomenti si riducono a valore prima dell'applicazione:
     somma (doppio 3) (doppio (doppio 1)) -> somma 6 (doppio 2)
       -> somma 6 4 -> 6 + 4 -> 10

   es3 = 8
     UNA volta sola: per valore, l'argomento e' ridotto a 4 prima di
     entrare in usa, e dentro il corpo v vale gia' 4.
     Per nome sarebbe stato ridotto due volte, con lo stesso risultato
     e il doppio del lavoro. E' l'anticipo di L07.
     
   es4 = 5

     due_volte incrementa 3
       -> incrementa (incrementa 3)
       -> incrementa (3 + 1)
       -> incrementa 4
       -> 4 + 1
       -> 5

   La funzione incrementa viene applicata due volte. L'applicazione interna
   deve essere ridotta prima di quella esterna.


   es5 = 42

     scegli (2 - 2)
       -> scegli 0
       -> if 0 = 0 then 42 else 10 / 0
       -> if true then 42 else 10 / 0
       -> 42

   Il ramo else non viene valutato. Se lo fosse, produrrebbe
   Division_by_zero.


   es6 = 7

     applica aggiungi3 1
       -> aggiungi3 (aggiungi3 1)
       -> aggiungi3 (3 + 1)
       -> aggiungi3 4
       -> 3 + 4
       -> 7

   aggiungi3 è una chiusura che conserva il legame x = 3.


   es7 = 8

     usa_due_volte calcola
       -> calcola () + calcola ()
       -> quadrato 2 + calcola ()
       -> (2 * 2) + calcola ()
       -> 4 + calcola ()
       -> 4 + quadrato 2
       -> 4 + (2 * 2)
       -> 4 + 4
       -> 8

   A differenza di es3, l'argomento di usa_due_volte è una funzione.
   La funzione è già un valore, ma il suo corpo viene eseguito a ogni
   chiamata. Quindi quadrato 2 viene calcolato due volte.


   es8 = false

     positivo (-1) && (10 / 0 > 2)
       -> (-1 > 0) && (10 / 0 > 2)
       -> false && (10 / 0 > 2)
       -> false

   Il secondo operando di && non viene valutato. Anche qui, se venisse
   valutato, si avrebbe Division_by_zero.


   es9 = 6

     somma_fino_a 3
       -> if 3 = 0 then 0 else 3 + somma_fino_a (3 - 1)
       -> 3 + somma_fino_a 2
       -> 3 + (2 + somma_fino_a 1)
       -> 3 + (2 + (1 + somma_fino_a 0))
       -> 3 + (2 + (1 + 0))
       -> 3 + (2 + 1)
       -> 3 + 3
       -> 6

   A ogni chiamata viene prima valutata la condizione. Soltanto quando
   n è diverso da zero viene valutato il ramo ricorsivo.
   ------------------------------------------------------------------ *)
