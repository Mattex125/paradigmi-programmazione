# L08 — Alcune dimostrazioni complete

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

## Teorema 1 — lunghezza di una concatenazione (visto a lezione)

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

## Teorema 2 — associatività di `@`

Per ogni `xs`, `ys`, `zs`:

    (xs @ ys) @ zs = xs @ (ys @ zs)

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

Con il neutro a **sinistra** è l'equazione `[A1]`; a destra va dimostrato.

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
**ogni** `f`. 

