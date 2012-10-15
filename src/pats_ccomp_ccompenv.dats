(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-20?? Hongwei Xi, ATS Trustful Software, Inc.
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of  the GNU GENERAL PUBLIC LICENSE (GPL) as published by the
** Free Software Foundation; either version 3, or (at  your  option)  any
** later version.
** 
** ATS is distributed in the hope that it will be useful, but WITHOUT ANY
** WARRANTY; without  even  the  implied  warranty  of MERCHANTABILITY or
** FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License
** for more details.
** 
** You  should  have  received  a  copy of the GNU General Public License
** along  with  ATS;  see the  file COPYING.  If not, please write to the
** Free Software Foundation,  51 Franklin Street, Fifth Floor, Boston, MA
** 02110-1301, USA.
*)

(* ****** ****** *)
//
// Author: Hongwei Xi (gmhwxi AT gmail DOT com)
// Start Time: October, 2012
//
(* ****** ****** *)

staload _(*anon*) = "prelude/DATS/list_vt.dats"

(* ****** ****** *)

staload "pats_dynexp2.sats"

(* ****** ****** *)

staload "pats_histaexp.sats"
staload "pats_hidynexp.sats"

(* ****** ****** *)

staload "pats_ccomp.sats"

(* ****** ****** *)

dataviewtype
d2varmarklst_vt =
  | DVMLSTnil of ()
  | DVMLSTmark of (d2varmarklst_vt)
  | DVMLSTcons of (d2var, d2varmarklst_vt)
// end of [d2varmarklst]

dataviewtype
funimpmarklst_vt =
  | FIMPMLSTnil of ()
  | FIMPMLSTmark of (funimpmarklst_vt)
  | FIMPMLSTcons_cst of (hiimpdec, funimpmarklst_vt)
  | FIMPMLSTcons_var of (hifundec, funimpmarklst_vt)
// end of [funentmarklst_vt]

(* ****** ****** *)
//
extern
fun d2varmarklst_vt_free (xs: d2varmarklst_vt): void
//
implement
d2varmarklst_vt_free (xs) = let
in
  case+ xs of
  | ~DVMLSTnil () => ()
  | ~DVMLSTmark (xs) => d2varmarklst_vt_free (xs)
  | ~DVMLSTcons (_, xs) => d2varmarklst_vt_free (xs)
end // end of [d2varmarklst_vt_free]

(* ****** ****** *)
//
extern
fun funimpmarklst_vt_free (xs: funimpmarklst_vt): void
//
implement
funimpmarklst_vt_free (xs) = let
in
  case+ xs of
  | ~FIMPMLSTnil () => ()
  | ~FIMPMLSTmark (xs) => funimpmarklst_vt_free (xs)
  | ~FIMPMLSTcons_cst (_, xs) => funimpmarklst_vt_free (xs)
  | ~FIMPMLSTcons_var (_, xs) => funimpmarklst_vt_free (xs)
end // end of [funimpmarklst_vt_free]

(* ****** ****** *)
//
extern
fun fprint_dvmlst
  (out: FILEref, xs: !d2varmarklst_vt): void
//
implement
fprint_dvmlst
  (out, xs) = let
//
fun loop (
  out: FILEref, xs: !d2varmarklst_vt, i: int
) : void = let
in
//
case+ xs of
| DVMLSTnil () => fold@ (xs)
| DVMLSTmark (!p_xs) => let
    val () =
      if i > 0 then
        fprint_string (out, ", ")
      // end of [if]
    val () = fprint_string (out, "||")
    val () = loop (out, !p_xs, i+1)
    prval () = fold@ (xs)
  in
    // nothing
  end // end of [DVMLSTmark]
| DVMLSTcons
    (!p_x, !p_xs) => let
    val () =
      if i > 0 then
        fprint_string (out, ", ")
      // end of [if]
    val () = fprint_d2var (out, !p_x)
    val () = loop (out, !p_xs, i+1)
    prval () = fold@ (xs)
  in
    // nothing
  end // end of [DVMLSTcons]
//
end // end of [loop]
//
in
  loop (out, xs, 0)
end // end of [fprint_dvmlst]

(* ****** ****** *)

extern
fun fprint_fimpmlst
  (out: FILEref, xs: !funimpmarklst_vt): void
// end of [fprint_fimpmlst]

implement
fprint_fimpmlst
  (out, xs) = let
//
fun loop (
  out: FILEref, xs: !funimpmarklst_vt, i: int
) : void = let
in
//
case+ xs of
| FIMPMLSTnil () => fold@ (xs)
| FIMPMLSTmark (!p_xs) => let
    val () =
      if i > 0 then
        fprint_string (out, ", ")
      // end of [if]
    val () = fprint_string (out, "||")
    val () = loop (out, !p_xs, i+1)
    prval () = fold@ (xs)
  in
    // nothing
  end // end of [FIMPDVMLSTmark]
//
| FIMPMLSTcons_cst
    (imp, !p_xs) => let
    val () =
      if i > 0 then fprint_string (out, ", ")
    // end of [val]
    val () = fprint_d2cst (out, imp.hiimpdec_cst)
    val () = loop (out, !p_xs, i+1)
    prval () = fold@ (xs)
  in
    // nothing
  end // end of [FIMPDVMLSTcons_cst]
| FIMPMLSTcons_var
    (hfd, !p_xs) => let
    val () =
      if i > 0 then fprint_string (out, ", ")
    // end of [val]
    val () = fprint_d2var (out, hfd.hifundec_var)
    val () = loop (out, !p_xs, i+1)
    prval () = fold@ (xs)
  in
    // nothing
  end // end of [FIMPDVMLSTcons_var]
//
end // end of [loop]
//
in
  loop (out, xs, 0)
end // end of [fprint_fimpmlst]

(* ****** ****** *)

viewtypedef
ccompenv_struct = @{
  ccompenv_dvmlst = d2varmarklst_vt
, ccompenv_varbindmap= d2varmap_vt (primval)
, ccompenv_fimpmlst = funimpmarklst_vt
} // end of [ccompenv_struct]

(* ****** ****** *)

extern
fun ccompenv_struct_uninitize
  (x: &ccompenv_struct >> ccompenv_struct?): void
// end of [ccompenv_struct_uninitize]

implement
ccompenv_struct_uninitize (x) = let
  val () =
    d2varmarklst_vt_free (x.ccompenv_dvmlst)
  // end of [val]
  val () = d2varmap_vt_free (x.ccompenv_varbindmap)
  val () =
    funimpmarklst_vt_free (x.ccompenv_fimpmlst)
  // end of [val]
in
  // end of [ccompenv_struct_uninitize]
end // end of [ccompenv_struct_uninitize]

(* ****** ****** *)

dataviewtype
ccompenv = CCOMPENV of ccompenv_struct

(* ****** ****** *)

assume ccompenv_vtype = ccompenv

(* ****** ****** *)

implement
ccompenv_make
  () = env where {
  val env = CCOMPENV (?)
  val CCOMPENV (!p) = env
//
  val () = p->ccompenv_dvmlst := DVMLSTnil ()
  val () = p->ccompenv_varbindmap := d2varmap_vt_make_nil ()
  val () = p->ccompenv_fimpmlst := FIMPMLSTnil ()
//
  val () = fold@ (env)
} // end of [ccompenv_make]

(* ****** ****** *)

implement
ccompenv_free (env) = let
in
//
case+ env of
| CCOMPENV (!p_env) => let
    val () = ccompenv_struct_uninitize (!p_env)
  in
    free@ (env)
  end // end of [CCOMPENV]
//
end // end of [ccompenv_free]

(* ****** ****** *)

implement
fprint_ccompenv
  (out, env) = let
in
//
case+ env of
| CCOMPENV (!p_env) => let
    val () = fprint_string (out, "ccompenv_dvmlst: ")
    val () = fprint_dvmlst (out, p_env->ccompenv_dvmlst)
    val () = fprint_newline (out)
    val () = fprint_string (out, "ccompenv_fimpmlst: ")
    val () = fprint_fimpmlst (out, p_env->ccompenv_fimpmlst)
    val () = fprint_newline (out)
  in
    fold@ (env)
  end // end of [CCOMPENV]
//
end // end of [fprint_ccompenv]

(* ****** ****** *)

local

assume ccompenv_push_v = unit_v

fun auxpop (
  map: &d2varmap_vt (primval), xs: d2varmarklst_vt
) : d2varmarklst_vt = let
in
//
case+ xs of
| DVMLSTnil () => let
    prval () = fold@ (xs) in xs
  end // end of [DVMLSTnil]
| ~DVMLSTmark (xs) => xs
| ~DVMLSTcons (d2v, xs) => let
    val _(*removed*) = d2varmap_vt_remove (map, d2v)
  in
    auxpop (map, xs)
  end // end of [DVMLSTcons]
//
end // end of [auxpop]

in // in of [local]

implement
ccompenv_pop
  (pfpush | env) = let
//
  prval unit_v () = pfpush
//
  val CCOMPENV (!p) = env
  val dvms = p->ccompenv_dvmlst
  val () = p->ccompenv_dvmlst := auxpop (p->ccompenv_varbindmap, dvms)
//
  prval () = fold@ (env)
//
in
  // nothing
end // end of [ccompenv_pop]

implement
ccompenv_push (env) = let
//
  val CCOMPENV (!p) = env
//
  val () = p->ccompenv_dvmlst := DVMLSTmark (p->ccompenv_dvmlst)
//
  prval () = fold@ (env)
//
in
  (unit_v | ())
end // end of [ccompenv_push]

end // end of [local]

(* ****** ****** *)

implement
ccompenv_add_varbind
  (env, d2v, pmv) = let
//
  val CCOMPENV (!p) = env
  val dvms = p->ccompenv_dvmlst
  val () = p->ccompenv_dvmlst := DVMLSTcons (d2v, dvms)
  val _(*inserted*) = d2varmap_vt_insert (p->ccompenv_varbindmap, d2v, pmv)
//
  prval () = fold@ (env)
//
in
  // nothing
end // end of [ccompenv_add_varbind]

implement
ccompenv_find_varbind
  (env, d2v) = opt where {
//
  val CCOMPENV (!p) = env
  val opt = d2varmap_vt_search (p->ccompenv_varbindmap, d2v)
  prval () = fold@ (env)
} // end of [ccompenv_add_varbind]

(* ****** ****** *)

implement
ccompenv_add_funimp_cst
  (env, imp) = let
//
  val CCOMPENV (!p) = env
  val xs = p->ccompenv_fimpmlst
  val () = p->ccompenv_fimpmlst := FIMPMLSTcons_cst (imp, xs)
//
  prval () = fold@ (env)
//
in
  // nothing
end // end of [ccompenv_add_funimp_cst]

implement
ccompenv_add_funimp_var
  (env, hfd) = let
//
  val CCOMPENV (!p) = env
  val xs = p->ccompenv_fimpmlst
  val () = p->ccompenv_fimpmlst := FIMPMLSTcons_var (hfd, xs)
//
  prval () = fold@ (env)
//
in
  // nothing
end // end of [ccompenv_add_funimp_var]

(* ****** ****** *)

(* end of [pats_ccomp_ccompenv.dats] *)