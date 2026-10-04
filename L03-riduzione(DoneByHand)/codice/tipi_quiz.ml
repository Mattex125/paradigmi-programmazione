Se possibile, stabilire il tipo delle seguenti funzioni

let a x = x
let aa x = x x
let b x y = x
let c f x = f (f x)
let d f g x = f (g x)
let dd x = (x + 1, x ^ "!")
let e x = [ x ]
let g l = List.length l + 1
let gg x y =
  if x then [y] else y
let h f = f 0
let i x y = if x then y else y
let j x = (x, x)
let jj x = [x; x 0]
let k x y = (y, x)
let kk x = [Some x; x]
let l f x = (f x, x)
let ll x = (x, x 0) :: [x 0, x]
let m f g x = (f x, g x)
let mm f x = (f x) + f
let n f (x, y) = (f x, f y)
let nn x =
  match x with
  | Some y -> y + 1
  | None   -> false
let o f x y = f y x
let p pred f x =
  if pred x then f x else x
let q f x = f (Some x)
let r f l = List.map f (List.rev l)
let s f g x = g (f x) x
let t x = fun _ -> x
let u f x = f (fun _ -> x)
let v f = (f 0, f true)
let w f x = f f x


(* ------------------------------------------------------------------
Risposte
a : 'a -> 'a
aa non tipabile
    Per applicare x a un argomento, dovrebbe essere: x : 'a -> 'b ma 
    l’argomento è x stesso, quindi dovrebbe essere contemporaneamente 'a = 'a -> 'b
b : 'a -> 'b -> 'a          il secondo argomento non e' usato: resta libero
c : ('a -> 'a) -> 'a -> 'a  il risultato di f x viene dato nuovamente a f. È questo che obbliga dominio = codominio
d : ('a -> 'b) -> ('c -> 'a) -> 'c -> 'b    la composizione
dd non tipabile
    x + 1    impone x : int
    x ^ "!"  impone x : string
e : 'a -> 'a list
g : 'a list -> int          la lista puo' contenere qualunque cosa
gg nob tipabile
    Il secondo ramo richiede che y abbia lo stesso tipo di [y]: 'a = 'a list 
    e anche questa è un’equazione di tipo infinita.
h : (int -> 'a) -> 'a       applicare f a 0 obbliga f a prendere un intero
i : bool -> 'a -> 'a        x e' usato come condizione, quindi bool
j : 'a -> 'a * 'a
    Le due componenti della coppia sono lo stesso valore e hanno lo stesso tipo.
jj non tipabile
    Per calcolare x 0 deve essere: x : int -> 'a
    Poiché x e x 0 appartengono alla stessa lista, devono avere lo stesso tipo: int -> 'a = 'a
    Di nuovo si otterrebbe un tipo infinito.
k : 'a -> 'b -> 'b * 'a
    I due argomenti possono avere tipi diversi; nella coppia vengono scambiati.
kk non tipabile
    Una lista deve essere omogenea, quindi dovrebbe valere: 'a option = 'a
    Un altro caso di tipo infinito.
l : ('a -> 'b) -> 'a -> 'b * 'a
    f trasforma x, ma x compare anche senza trasformazioni.
ll non tipabile
    le due coppie obbligano x e x 0 a scambiarsi i tipi, producendo ancora un vincolo ricorsivo incompatibile.
m : ('a -> 'b) -> ('a -> 'c) -> 'a -> 'b * 'c
    f e g ricevono lo stesso argomento, ma possono produrre tipi diversi.
mm non tipabile
    Da f x ricaviamo: f : 'a -> int
    Ma l’addizione richiede che anche f sia un intero: f : int
    Quindi f dovrebbe essere contemporaneamente una funzione e un intero.
n : ('a -> 'b) -> 'a * 'a -> 'b * 'b
    f viene applicata a entrambe le componenti: queste devono avere lo stesso tipo.
nn non tipabile
    Il primo ramo produce un int, il secondo un bool, quindi l’intero match non può avere un unico tipo.
o : ('a -> 'b -> 'c) -> 'b -> 'a -> 'c
    Gli argomenti x e y vengono passati a f in ordine inverso.
p : ('a -> bool) -> ('a -> 'a) -> 'a -> 'a
    pred deve produrre un booleano; i due rami dell'if devono avere lo stesso tipo.
q : ('a option -> 'b) -> 'a -> 'b
    f riceve Some x, quindi il suo argomento deve essere un valore option.
r : ('a -> 'b) -> 'a list -> 'b list
    rev non cambia il tipo degli elementi; map può invece trasformarlo.
s : ('a -> 'b) -> ('b -> 'a -> 'c) -> 'a -> 'c
    g riceve sia il risultato di f x sia lo stesso x originale.
t : 'a -> 'b -> 'a
    L'argomento della funzione interna non viene usato.
u : (('a -> 'b) -> 'c) -> 'b -> 'c
    La funzione passata a f ignora il proprio argomento e restituisce sempre x.
v non è tipabile.
    La prima applicazione richiede: f : int -> 'a
    La seconda richiede: f : bool -> 'b
    La stessa f non può avere contemporaneamente entrambi i tipi.
w non è tipabile.
    Per calcolare f f, la funzione f dovrebbe accettare come argomento una funzione dello stesso tipo di f,
    producendo un tipo ricorsivo infinito.
------------------------------------------------------------------ *)
