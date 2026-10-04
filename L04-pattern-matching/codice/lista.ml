(* L04 — la lista costruita da noi.
   Nessuna funzione della libreria standard: solo la ricetta.
   Un caso per costruttore; si ricorre sulla parte piu' piccola. *)

type 'a lista =
  | Vuota
  | Cons of 'a * 'a lista

(* Funzione per importare nella nostra rappresentazione una list scritta "più comodamente", come  [1;2;3]. Utile per poter fare delle prove *)
let rec importa = function
  | [] -> Vuota
  | x :: r -> Cons (x, importa r)

let rec esporta = function
  | Vuota -> []
  | Cons (x, r) -> x :: esporta r

(* ---- le tre funzioni ---- *)

let rec lunghezza l =
  match l with
  | Vuota -> 0
  | Cons (_, resto) -> 1 + lunghezza resto

let rec append l1 l2 =
  match l1 with
  | Vuota -> l2                              (* NON Vuota: la seconda passa intatta *)
  | Cons (x, resto) -> Cons (x, append resto l2)

let rec rev l =
  match l with
  | Vuota -> Vuota
  | Cons (x, resto) -> append (rev resto) (Cons (x, Vuota))

(* ---- prove ---- *)

let () =
  let l = importa [ 1; 2; 3 ] in
  let m = importa [ 4; 5 ] in
  Printf.printf "lunghezza [1;2;3] = %d\n" (lunghezza l);
  Printf.printf "append  -> %s\n"
    (String.concat ";" (List.map string_of_int (esporta (append l m))));
  Printf.printf "rev     -> %s\n"
    (String.concat ";" (List.map string_of_int (esporta (rev l))));
  Printf.printf "lunghezza Vuota = %d\n" (lunghezza Vuota)

(* Osservazione per L07: rev chiama append a ogni passo, e append percorre
   tutto cio' che e' gia' stato girato. Su centomila elementi si sente.
   Qui ci interessa che sia giusta. *)
