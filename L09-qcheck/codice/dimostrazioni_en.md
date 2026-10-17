# L08 — Complete proofs

The definitions and equation labels (`[A1]`, `[L2]`, etc.) are in
`definizioni.ml`. Each step cites the equation that justifies it.
An equation can be used in **either direction**: this is legitimate because
both sides denote the same value (referential transparency, L03).

Format, as required in the exam:

1. the statement, including its quantifiers;
2. the variable chosen for induction, and **why** that variable;
3. the base case;
4. the inductive step, with the induction hypothesis **written out in full** before it is used;
5. every line justified in square brackets.

---

## Theorem 1 — length of a concatenation

For all `xs`, `ys`:

    length (xs @ ys) = length xs + length ys

**Induction on `xs`.** Why `xs`? `append` recurses on its first argument,
and the proof follows the function's structure.

**Base case**, `xs = []`.

      length ([] @ ys)
    = length ys                                   [A1]
    = 0 + length ys                               [arithmetic]
    = length [] + length ys                       [L1, right to left]

**Inductive step**, `xs = x :: r`.
Induction hypothesis (IH): `length (r @ ys) = length r + length ys`

      length ((x :: r) @ ys)
    = length (x :: (r @ ys))                      [A2]
    = 1 + length (r @ ys)                         [L2]
    = 1 + (length r + length ys)                  [IH]
    = (1 + length r) + length ys                  [associativity of +]
    = length (x :: r) + length ys                 [L2, right to left]

---

## Theorem 2 — associativity of `@` (the proof left open in L04)

For all `xs`, `ys`, `zs`:

    `(xs @ ys) @ zs = xs @ (ys @ zs)`

**Induction on `xs`**, for the same reason.

**Base case**, `xs = []`. Both sides reduce to the same expression:

      ([] @ ys) @ zs = ys @ zs                    [A1]
      [] @ (ys @ zs) = ys @ zs                    [A1]

**Inductive step**, `xs = x :: r`.
IH: `(r @ ys) @ zs = r @ (ys @ zs)` — that is, the statement for the **tail**.
`ys` and `zs` remain those of the original statement: they do not change
during recursion, since `append` recurses only on its first argument.

      ((x :: r) @ ys) @ zs
    = (x :: (r @ ys)) @ zs                        [A2, with ys]
    = x :: ((r @ ys) @ zs)                        [A2, with zs]
    = x :: (r @ (ys @ zs))                        [IH]
    = (x :: r) @ (ys @ zs)                        [A2, with (ys @ zs), right to left]

The three uses of `[A2]` deserve a closer look, because this is where it
is easy to stumble. The equation is

    (x :: r) @ ys = x :: (r @ ys)        for all x, r, ys

and the variable names are arbitrary: it is the form that matters. Hence:

- in the **first** line, the second argument is `ys`;
- in the **second**, the second argument is `zs`, and, crucially, the `r`
  in `[A2]` is instantiated with the **expression** `r @ ys`, rather than
  a variable. This is valid because `[A2]` holds for any tail, including
  one obtained by computation. It is easy to mistakenly think that `[A2]`
  applies only when the left side literally consists of a variable
  consed onto another variable;
- in the **fourth** line, the equation is used in reverse, with
  `(ys @ zs)` as the second argument.

---

## Lemma 3 — `[]` is a right identity

For all `xs`:  `xs @ [] = xs`

That `[]` is a **left** identity follows from `[A1]`; the right identity
must be proved.

**Base case**: `[] @ [] = []`  [A1]

**Inductive step**, `xs = x :: r`. IH: `r @ [] = r`

      (x :: r) @ []
    = x :: (r @ [])                               [A2]
    = x :: r                                      [IH]

---

## Theorem 4 — `map` preserves length (L06)

For all `f`, `l`:  `length (map f l) = length l`

**Induction on `l`.**

**Base case**: `length (map f []) = length []`  [M1]

**Inductive step**, `l = x :: r`. IH: `length (map f r) = length r`

      length (map f (x :: r))
    = length (f x :: map f r)                     [M2]
    = 1 + length (map f r)                        [L2]
    = 1 + length r                                [IH]
    = length (x :: r)                             [L2, right to left]

Notice that `f` never appears in the reasoning: the property holds for
**every** `f`. This is the parametricity discussed in L06, proved here
rather than inferred from the type.

---

## Theorem 5 — `map` fusion (L06)

For all `f`, `g`, `l`:  `map f (map g l) = map (g %> f) l`

**Induction on `l`.**

**Base case**: both sides evaluate to `[]`.

      map f (map g []) = map f [] = []            [M1, M1]
      map (g %> f) []    = []                     [M1]

**Inductive step**, `l = x :: r`. IH: `map f (map g r) = map (g %> f) r`

      map f (map g (x :: r))
    = map f (g x :: map g r)                      [M2]
    = f (g x) :: map f (map g r)                  [M2]
    = f (g x) :: map (g %> f) r                   [IH]
    = (g %> f) x :: map (g %> f) r                [C, right to left]
    = map (g %> f) (x :: r)                       [M2, right to left]

**Caution**: this holds for values. If `f` or `g` have effects, the two
sides produce those effects in a different order (`limiti.ml`).

---

## Theorem 6 — size and traversal (the proof left open in L05)

For every tree `t`:  `size t = length (inorder t)`

**Induction on `t`.** The type has a recursive constructor with **two**
recursive occurrences, so the inductive step has **two** induction hypotheses.

**Base case**, `t = Leaf`.

      size Leaf = 0                               [D1]
      length (inorder Leaf) = length []           [I1]
                                   = 0            [L1]

**Inductive step**, `t = Node (l, x, r)`.
IH_l: `size l = length (inorder l)`
IH_r: `size r = length (inorder r)`

      length (inorder (Node (l, x, r)))
    = length (inorder l @ ([x] @ inorder r))      [I2]
    = length (inorder l @ (x :: ([] @ inorder r)))  [A2]
    = length (inorder l @ (x :: inorder r))       [A1]
    = length (inorder l) + length (x :: inorder r)  [Theorem 1]
    = length (inorder l) + (1 + length (inorder r)) [L2]
    = size l + (1 + size r)                       [IH_l, IH_r]
    = size l + 1 + size r                         [associativity of +]
    = size (Node (l, x, r))                       [D2, right to left]

The `[I2]` line uses the fact that `@` associates to the right
(see `definizioni.ml`).

---

## Theorem 7 — `rev_acc` computes `naive_rev` (the proof left open in L07)

The statement we want to prove: for all `l`,  `rev_acc [] l = naive_rev l`

### Why a direct proof gets stuck

**Base case**: `rev_acc [] [] = []` [RA1] and `naive_rev [] = []` [R1]. So far, so good.

**Inductive step**, `l = x :: r`. IH: `rev_acc [] r = naive_rev r`

      rev_acc [] (x :: r)
    = rev_acc [x] r                               [RA2]

And here we get stuck. The hypothesis concerns `rev_acc [] r`, whereas
we have `rev_acc [x] r`. The accumulator has changed, and the hypothesis
says nothing about accumulators other than `[]`.

### Generalizing the statement

We prove a **stronger** statement, covering every accumulator:

For all `l`:  **for all** `acc`,  `rev_acc acc l = naive_rev l @ acc`

The “for all `acc`” is **inside** the statement on which we induct:
this allows us to use the hypothesis with a different accumulator.

**Base case**, `l = []`, for an arbitrary `acc`.

      rev_acc acc []           = acc              [RA1]
      naive_rev [] @ acc     = [] @ acc           [R1]
                               = acc              [A1]

**Inductive step**, `l = x :: r`, for an arbitrary `acc`.
IH: for all `acc'`,  `rev_acc acc' r = naive_rev r @ acc'`

Left-hand side:

      rev_acc acc (x :: r)
    = rev_acc (x :: acc) r                        [RA2]
    = naive_rev r @ (x :: acc)                    [IH, with acc' = x :: acc]

Right-hand side:

      naive_rev (x :: r) @ acc
    = (naive_rev r @ [x]) @ acc                   [R2]
    = naive_rev r @ ([x] @ acc)                   [Theorem 2]
    = naive_rev r @ (x :: ([] @ acc))             [A2]
    = naive_rev r @ (x :: acc)                    [A1]

Both sides coincide.

### The corollary gives us the result we could not prove directly

      rev_acc [] l
    = naive_rev l @ []                    [generalized Theorem 7, acc = []]
    = naive_rev l                                 [Lemma 3]
