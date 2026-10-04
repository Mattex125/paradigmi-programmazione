(* L04 — l'avviso di non esaustivita' e' un controesempio.

   ISTRUZIONI
   1. Compilate cosi' com'e':        ocamlc -c esaustivita.ml
      Nessun avviso: i due casi coprono i due costruttori.
   2. Commentate la riga del caso Vuota e ricompilate.
      Leggete l'ultima riga del messaggio: il compilatore non dice
      "hai sbagliato", vi consegna l'esempio che manca.
   3. Rimettetela e togliete invece il caso Cons. Stessa cosa,
      con l'altro controesempio. *)

type 'a lista =
  | Vuota
  | Cons of 'a * 'a lista

let rec lunghezza l =
  match l with
  | Vuota -> 0
  | Cons (_, resto) -> 1 + lunghezza resto

(* ---- il confine dello strumento ----
   Il compilatore non valuta le guardie. Qui i tre casi coprono tutto,
   ma l'avviso arriva lo stesso: decommentate per vederlo. Risponde

     Warning 8 [partial-match]: this pattern-matching is not exhaustive.
       Here is an example of a case that is not matched:
         Cons (_, _)

   e il controesempio e' istruttivo: non sapendo leggere le guardie, il
   compilatore non riesce a restringerlo e vi restituisce l'intero
   costruttore. Lo strumento non sta mentendo, sta dicendo esattamente
   quanto sa. *)

(*
let segno l =
  match l with
  | Cons (x, _) when x > 0 -> "positivo"
  | Cons (x, _) when x <= 0 -> "non positivo"
  | Vuota -> "vuota"
*)

let () = Printf.printf "lunghezza = %d\n" (lunghezza (Cons (1, Cons (2, Vuota))))
