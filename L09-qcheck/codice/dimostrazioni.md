# L08 — Dimostrazioni complete

Le definizioni e i nomi delle equazioni (`[A1]`, `[L2]`, ecc.) sono in
`definizioni.ml`. Ogni passaggio cita l'equazione che lo giustifica.
Un'equazione si può usare in **entrambe le direzioni**: è lecito perché
le due parti denotano lo stesso valore (trasparenza referenziale, L03).

Formato, lo stesso richiesto all'esame:

1. l'enunciato, con i suoi quantificatori;
2. su quale variabile si fa induzione, e **perché** quella;
3. il caso base;
4. il passo, con l'ipotesi induttiva **scritta per esteso** prima di usarla;
5. ogni riga giustificata fra parentesi quadre.

---

## Teorema 1 — lunghezza di una concatenazione

Per ogni `xs`, `ys`:

    length (xs @ ys) = length xs + length ys

**Induzione su `xs`.** Perché `xs`: `append` ricorre sul primo argomento,
e la dimostrazione segue la funzione.

**Base**, `xs = []`.

      length ([] @ ys)
    = length ys                                   [A1]
    = 0 + length ys                               [aritmetica]
    = length [] + length ys                       [L1, da destra a sinistra]

**Passo**, `xs = x :: r`.
Ipotesi induttiva (II): `length (r @ ys) = length r + length ys`

      length ((x :: r) @ ys)
    = length (x :: (r @ ys))                      [A2]
    = 1 + length (r @ ys)                         [L2]
    = 1 + (length r + length ys)                  [II]
    = (1 + length r) + length ys                  [associatività di +]
    = length (x :: r) + length ys                 [L2, da destra a sinistra]

---

## Teorema 2 — associatività di `@` (il debito di L04)

Per ogni `xs`, `ys`, `zs`:

    `(xs @ ys) @ zs = xs @ (ys @ zs)`

**Induzione su `xs`**, per la stessa ragione.

**Base**, `xs = []`. Le due parti si riducono alla stessa espressione:

      ([] @ ys) @ zs = ys @ zs                    [A1]
      [] @ (ys @ zs) = ys @ zs                    [A1]

**Passo**, `xs = x :: r`.
II: `(r @ ys) @ zs = r @ (ys @ zs)` — cioè l'enunciato sulla **coda**.
`ys` e `zs` restano quelli dell'enunciato: non cambiano lungo la
ricorsione, perché `append` ricorre solo sul primo argomento.

      ((x :: r) @ ys) @ zs
    = (x :: (r @ ys)) @ zs                        [A2] con ys
    = x :: ((r @ ys) @ zs)                        [A2] con zs
    = x :: (r @ (ys @ zs))                        [II]
    = (x :: r) @ (ys @ zs)                        [A2] con (ys @ zs), da destra a sinistra

Le tre applicazioni di `[A2]` meritano una riga, perché è qui che si
inciampa. L'equazione è

    (x :: r) @ ys = x :: (r @ ys)        per ogni x, r, ys

e i nomi delle variabili sono arbitrari: conta la forma. Quindi:

- nella **prima** riga si usa con secondo argomento `ys`;
- nella **seconda** con secondo argomento `zs`, e soprattutto con la `r`
  di `[A2]` istanziata all'**espressione** `r @ ys`, non a una variabile.
  È lecito perché `[A2]` vale per qualunque coda, anche calcolata — ed è
  il punto in cui si crede, a torto, che `[A2]` si applichi solo quando a
  sinistra c'è letteralmente una variabile cons-ed su una variabile;
- nella **quarta** si usa al contrario, con secondo argomento `(ys @ zs)`.

---

## Lemma 3 — `[]` è neutro a destra

Per ogni `xs`:  `xs @ [] = xs`

Che sia neutro a **sinistra** è l'equazione `[A1]`; a destra va dimostrato.

**Base**: `[] @ [] = []`  [A1]

**Passo**, `xs = x :: r`. II: `r @ [] = r`

      (x :: r) @ []
    = x :: (r @ [])                               [A2]
    = x :: r                                      [II]

---

## Teorema 4 — `map` conserva la lunghezza (L06)

Per ogni `f`, `l`:  `length (map f l) = length l`

**Induzione su `l`.**

**Base**: `length (map f []) = length []`  [M1]

**Passo**, `l = x :: r`. II: `length (map f r) = length r`

      length (map f (x :: r))
    = length (f x :: map f r)                     [M2]
    = 1 + length (map f r)                        [L2]
    = 1 + length r                                [II]
    = length (x :: r)                             [L2, da destra a sinistra]

Notate che `f` non compare mai nel ragionamento: la proprietà vale per
**ogni** `f`. È la parametricità di L06, dimostrata invece che letta nel
tipo.

---

## Teorema 5 — fusione di `map` (L06)

Per ogni `f`, `g`, `l`:  `map f (map g l) = map (g %> f) l`

**Induzione su `l`.**

**Base**: entrambe le parti valgono `[]`.

      map f (map g []) = map f [] = []            [M1, M1]
      map (g %> f) []    = []                     [M1]

**Passo**, `l = x :: r`. II: `map f (map g r) = map (g %> f) r`

      map f (map g (x :: r))
    = map f (g x :: map g r)                      [M2]
    = f (g x) :: map f (map g r)                  [M2]
    = f (g x) :: map (g %> f) r                   [II]
    = (g %> f) x :: map (g %> f) r                [C, da destra a sinistra]
    = map (g %> f) (x :: r)                       [M2, da destra a sinistra]

**Attenzione**: vale sui valori. Se `f` o `g` hanno effetti, le due
parti producono gli effetti in ordine diverso (`limiti.ml`).

---

## Teorema 6 — dimensione e visita (il debito di L05)

Per ogni albero `t`:  `size t = length (inorder t)`

**Induzione su `t`.** Il tipo ha un costruttore ricorsivo con **due**
occorrenze ricorsive, quindi il passo ha **due** ipotesi induttive.

**Base**, `t = Leaf`.

      size Leaf = 0                               [D1]
      length (inorder Leaf) = length []           [I1]
                                   = 0            [L1]

**Passo**, `t = Node (l, x, r)`.
II_l: `size l = length (inorder l)`
II_r: `size r = length (inorder r)`

      length (inorder (Node (l, x, r)))
    = length (inorder l @ ([x] @ inorder r))      [I2]
    = length (inorder l @ (x :: ([] @ inorder r)))  [A2]
    = length (inorder l @ (x :: inorder r))       [A1]
    = length (inorder l) + length (x :: inorder r)  [Teorema 1]
    = length (inorder l) + (1 + length (inorder r)) [L2]
    = size l + (1 + size r)                       [II_l, II_r]
    = size l + 1 + size r                         [associatività di +]
    = size (Node (l, x, r))                       [D2, da destra a sinistra]

La riga `[I2]` usa il fatto che `@` associa a destra (vedi `definizioni.ml`).

---

## Teorema 7 — `rev_acc` calcola `naive_rev` (il debito di L07)

Enunciato che ci interessa: per ogni `l`,  `rev_acc [] l = naive_rev l`

### Il tentativo diretto si blocca

**Base**: `rev_acc [] [] = []` [RA1] e `naive_rev [] = []` [R1]. Bene.

**Passo**, `l = x :: r`. II: `rev_acc [] r = naive_rev r`

      rev_acc [] (x :: r)
    = rev_acc [x] r                               [RA2]

e qui ci si ferma. L'ipotesi parla di `rev_acc [] r`; noi abbiamo
`rev_acc [x] r`. L'accumulatore è cambiato, e l'ipotesi non dice nulla su
accumulatori diversi da `[]`.

### Generalizzare

Si dimostra un enunciato **più forte**, che parla di ogni accumulatore:

Per ogni `l`:  **per ogni** `acc`,  `rev_acc acc l = naive_rev l @ acc`

Il «per ogni `acc`» sta **dentro** l'enunciato su cui si fa induzione: è
questo che permette di usare l'ipotesi con un accumulatore diverso.

**Base**, `l = []`, per un `acc` qualsiasi.

      rev_acc acc []           = acc              [RA1]
      naive_rev [] @ acc     = [] @ acc           [R1]
                               = acc              [A1]

**Passo**, `l = x :: r`, per un `acc` qualsiasi.
II: per ogni `acc'`,  `rev_acc acc' r = naive_rev r @ acc'`

Parte sinistra:

      rev_acc acc (x :: r)
    = rev_acc (x :: acc) r                        [RA2]
    = naive_rev r @ (x :: acc)                    [II, con acc' = x :: acc]

Parte destra:

      naive_rev (x :: r) @ acc
    = (naive_rev r @ [x]) @ acc                   [R2]
    = naive_rev r @ ([x] @ acc)                   [Teorema 2]
    = naive_rev r @ (x :: ([] @ acc))             [A2]
    = naive_rev r @ (x :: acc)                    [A1]

Le due parti coincidono.

### Il corollario è il risultato che non eravamo riusciti a dimostrare

      rev_acc [] l
    = naive_rev l @ []                    [Teorema 7 generalizzato, acc = []]
    = naive_rev l                                 [Lemma 3]
