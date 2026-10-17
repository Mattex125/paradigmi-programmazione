(* L09 - le leggi dimostrate in L08, trasformate in test eseguibili.
 *
 *   ocamlfind ocamlopt -package qcheck -linkpkg leggi_L08.ml -o laws && ./laws
 *
 * Sono gli stessi enunciati. In L08 li abbiamo dimostrati per ogni lista;
 * qui una macchina li mette alla prova su mille liste generate casualmente.
 * I due metodi non si sostituiscono: si controllano a vicenda. *)

let rec append l1 l2 = match l1 with [] -> l2 | x :: r -> x :: append r l2
let rec length = function [] -> 0 | _ :: r -> 1 + length r
let rec map f = function [] -> [] | x :: r -> f x :: map f r
let ( %> ) g f x = f (g x)
let rec naive_rev = function [] -> [] | x :: r -> append (naive_rev r) [ x ]
let rec rev_acc acc = function [] -> acc | x :: r -> rev_acc (x :: acc) r

open QCheck2

let a_list = Gen.(list nat_small)
let pl = Print.(list int)

let f x = 3 * x + 1
let g x = x + 7

let t1 =
  Test.make ~count:1000 ~name:"T1  length (xs @ ys) = length xs + length ys"
    ~print:Print.(pair pl pl) Gen.(pair a_list a_list)
    (fun (xs, ys) -> length (append xs ys) = length xs + length ys)

let t2 =
  Test.make ~count:1000 ~name:"T2  (xs @ ys) @ zs = xs @ (ys @ zs)"
    ~print:Print.(triple pl pl pl) Gen.(triple a_list a_list a_list)
    (fun (xs, ys, zs) -> append (append xs ys) zs = append xs (append ys zs))

let l3 =
  Test.make ~count:1000 ~name:"L3  xs @ [] = xs" ~print:pl a_list
    (fun xs -> append xs [] = xs)

let t4 =
  Test.make ~count:1000 ~name:"T4  length (map f l) = length l" ~print:pl a_list
    (fun l -> length (map f l) = length l)

let t5 =
  Test.make ~count:1000 ~name:"T5  map f (map g l) = map (g %> f) l" ~print:pl a_list
    (fun l -> map f (map g l) = map (g %> f) l)

let t7 =
  Test.make ~count:1000 ~name:"T7  rev_acc acc l = naive_rev l @ acc"
    ~print:Print.(pair pl pl) Gen.(pair a_list a_list)
    (fun (acc, l) -> rev_acc acc l = append (naive_rev l) acc)

(* E anche l'enunciato che in L08 abbiamo scoperto essere falso. Vi era
   stato chiesto il controesempio più piccolo: ora lo chiediamo a QCheck. *)
let false_one =
  Test.make ~count:1000 ~name:"??  map f (xs @ ys) = map f ys @ map f xs"
    ~print:Print.(pair pl pl) Gen.(pair a_list a_list)
    (fun (xs, ys) -> map f (append xs ys) = append (map f ys) (map f xs))

let () = exit (QCheck_base_runner.run_tests_main [ t1; t2; l3; t4; t5; t7; false_one ])

(* Risultato verificato:
 *
 *   Test ??  map f (xs @ ys) = map f ys @ map f xs failed
 *   (12 shrink steps):
 *
 *   ([0], [1])
 *
 * Due liste di un elemento ciascuna. QCheck non ha TROVATO direttamente
 * questo controesempio: ne ha trovato uno più grande e poi lo ha RIDOTTO,
 * un pezzo alla volta, finché togliere ancora qualcosa avrebbe fatto
 * scomparire il difetto.
 * Questi sono gli «shrink steps», il cui numero cambia a ogni esecuzione.
 *
 * Il controesempio ridotto, invece, non cambia: provando i semi 1, 2,
 * 12345 e 999 (./laws -s 1 e così via), si ottiene sempre ([0], [1]).
 * La riduzione converge allo stesso punto anche partendo da punti diversi. *)
