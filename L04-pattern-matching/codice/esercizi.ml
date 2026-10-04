(* L04 — esercizi. Usare la ricetta: un caso per costruttore,
   ricorsione sulla parte piu' piccola. Sulle liste di OCaml. *)

(* 1. l'ultimo elemento, se c'e' *)
let rec ultimo (l : 'a list) : 'a option =
  ignore l;
  failwith "da scrivere"

(* 2. i soli elementi pari *)
let rec pari (l : int list) : int list =
  ignore l;
  failwith "da scrivere"

(* 3. il massimo, se la lista non e' vuota *)
let rec massimo (l : int list) : int option =
  ignore l;
  failwith "da scrivere"

(* Domanda per chi finisce presto, da riprendere in L08:
   append (append a b) c  e  append a (append b c)  danno la stessa lista?
   Convincetevene su qualche esempio. In L08 lo dimostrerete per induzione. *)
