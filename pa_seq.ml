(* camlp5o *)
(* pa_seq.ml,v *)
(* Copyright (c) INRIA 2007-2017 *)

open Pa_ppx_base
open Pa_passthru
open Ppxutil

let build_seq loc l =
  let rec brec = function
    [] -> <:expr< fun () -> Seq.Nil >>
  | h::t -> <:expr< fun () -> Seq.Cons ($h$, $brec t$) >>
  in brec l

let rewrite_expr arg = function
  <:expr:< [%seq] >> -> build_seq loc []
| <:expr:< [%seq do { $list:el$ } ;] >> -> build_seq loc el
| <:expr:< [%seq $exp:e$ ;] >> -> build_seq loc [e]
| _ -> assert false


let install () = 
let ef = EF.mk () in 
let ef = EF.{ (ef) with
            expr = extfun ef.expr with [
    <:expr:< [%seq] >> | <:expr:< [%seq $_$ ;] >> as z ->
    fun arg fallback ->
      Some (rewrite_expr arg z)
  ] } in
  Pa_passthru.(install { name = "pa_seq"; ef =  ef ; pass = None ; before = [] ; after = [] })
;;

install();;
