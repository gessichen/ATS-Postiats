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
// Author: Hongwei Xi (hwxi AT cs DOT bu DOT edu)
// Start Time: May, 2011
//
(* ****** ****** *)

staload ERR = "pats_error.sats"

(* ****** ****** *)

staload "pats_errmsg.sats"
staload _(*anon*) = "pats_errmsg.dats"
implement prerr_FILENAME<> () = prerr "pats_trans2_dynexp"

(* ****** ****** *)

staload
SYM = "pats_symbol.sats"
overload = with $SYM.eq_symbol_symbol

staload
SYN = "pats_syntax.sats"
typedef d0ynq = $SYN.d0ynq

macdef
prerr_dqid (dq, id) =
  ($SYN.prerr_d0ynq ,(dq); $SYM.prerr_symbol ,(id))
// end of [prerr_dqid]

(* ****** ****** *)

staload "pats_basics.sats"

(* ****** ****** *)

staload "pats_staexp1.sats"
staload "pats_e1xpval.sats"
staload "pats_dynexp1.sats"
staload "pats_staexp2.sats"
staload "pats_dynexp2.sats"
staload "pats_dynexp2_util.sats"

(* ****** ****** *)

staload "pats_trans2.sats"
staload "pats_trans2_env.sats"

(* ****** ****** *)

#include "pats_basics.hats"

(* ****** ****** *)

#define l2l list_of_list_vt
macdef list_sing (x) = list_cons (,(x), list_nil)

(* ****** ****** *)

(*
** HX: dynamic special identifier
*)
datatype dynspecid =
  | SPDIDassgn | SPDIDderef | SPDIDnone
// end of [dynspecid]

fn dynspecid_of_dqid
  (dq: d0ynq, id: symbol): dynspecid =
  case+ dq.d0ynq_node of
  | $SYN.D0YNQnone () => (case+ 0 of
    | _ when id = $SYM.symbol_BANG => SPDIDderef ()
    | _ when id = $SYM.symbol_COLONEQ => SPDIDassgn ()
    | _ => SPDIDnone ()        
    ) // end of [D0YNQnone]
  | _ => SPDIDnone ()
// end of [dynspecid_of_dqid]

(* ****** ****** *)

fn d1exp_tr_dqid (
  d1e0: d1exp, dq: d0ynq, id: symbol
) : d2exp = let
//
  val loc0 = d1e0.d1exp_loc
  val ans = the_d2expenv_find_qua (dq, id)
//
in
//
case+ ans of
| ~Some_vt d2i0 => (case+ d2i0 of
  | D2ITMcon d2cs => let
      val d2cs = d2con_select_arity (d2cs, 0)
      val- list_cons (d2c, _) = d2cs // HX: [d2cs] cannot be nil
    in
      d2exp_con (loc0, d2c, list_nil(*sarg*), ~1(*npf*), list_nil(*darg*))
    end // end of [D2ITEMcon]
  | D2ITMcst d2c => d2exp_cst (loc0, d2c)
  | D2ITMe1xp e1xp => let
      val d1e = d1exp_make_e1xp (loc0, e1xp) in d1exp_tr (d1e)
    end // end of [D2ITMe1xp]
  | D2ITMvar d2v => d2exp_var (loc0, d2v)
  | _ => d2exp_err (loc0)
  ) // end of [Some_vt]
| ~None_vt () => let
    val () = prerr_error2_loc (loc0)
    val () = filprerr_ifdebug (": d1exp_tr_dqid")
    val () = prerr ": the dynamic identifier ["
    val () = prerr_dqid (dq, id)
    val () = prerr "] is unrecognized."
    val () = prerr_newline ()
    val () = the_trans2errlst_add (T2E_d1exp_tr (d1e0))
  in
    d2exp_err (loc0)
  end // end of [None_vt]
end // end of [d1exp_tr_dqid]

(* ****** ****** *)

fn d1exp_tr_assgn (
  d1e0: d1exp, d1es: d1explst
) : d2exp = let
  val loc0 = d1e0.d1exp_loc
in
  case+ d1es of
  | list_cons (
      d1e1, list_cons (d1e2, list_nil ())
    ) =>
      d2exp_assgn (loc0, d1exp_tr d1e1, d1exp_tr d1e2)
    // end of [...]
  | _ => let
      val () = prerr_interror_loc (loc0)
      val () = (prerr ": d1exp_tr_assgn: d1e0 = "; prerr_d1exp d1e0)
      val () = prerr_newline ()
    in
      $ERR.abort {d2exp} ()
    end // end of [_]
end // end of [d1exp_tr_assgn]

fn d1exp_tr_deref (
  d1e0: d1exp, d1es: d1explst
) : d2exp = let
  val loc0 = d1e0.d1exp_loc
in
  case+ d1es of
  | list_cons (
      d1e, list_nil ()
    ) => d2exp_deref (loc0, d1exp_tr d1e)
  | _ => let
      val () = prerr_interror_loc (loc0)
      val () = (prerr ": d1exp_tr_deref: d1e0 = "; prerr_d1exp d1e0)
      val () = prerr_newline ()
    in
      $ERR.abort {d2exp} ()
    end // end of [_]
end // end of [d1exp_tr_deref]

(* ****** ****** *)

extern
fun d1exp_tr_app_dyn (
  d1e0: d1exp
, d1e_fun: d1exp
, locarg: location, npf: int, darg: d1explst
) : d2exp // end of [d1exp_tr_app_dyn]
extern
fun d1exp_tr_app_sta_dyn (
  d1e0: d1exp
, d1e1: d1exp
, d1e_fun: d1exp
, sarg: s1exparglst
, locarg: location, npf: int, darg: d1explst
) : d2exp // end of [d1exp_tr_app_sta_dyn]

(* ****** ****** *)

fun
d1exp_tr_app_dyn_dqid (
  d1e0: d1exp, d1e1: d1exp
, dq: d0ynq, id: symbol
, locarg: location, npf: int, darg: d1explst 
) : d2exp = let
//
val spdid = dynspecid_of_dqid (dq, id) 
//
in
//
case+ spdid of
| SPDIDassgn () => d1exp_tr_assgn (d1e0, darg)
| SPDIDderef () => d1exp_tr_deref (d1e0, darg)
| _ (*SPDIDnone*) => let
    val ans = the_d2expenv_find_qua (dq, id)
  in
    case+ ans of
    | ~Some_vt d2i => (case+ d2i of
      | D2ITMe1xp (e0) => d1exp_tr_app_dyn_e1xp (d1e0, d1e1, e0, locarg, npf, darg)
      | _ => let
          val sarg = list_nil () in
          d1exp_tr_app_sta_dyn_dqid_itm (d1e0, d1e1, d1e1, dq, id, d2i, sarg, locarg, npf, darg)
        end // end of [Some_vt]
      ) // end of [Some_vt]
    | ~None_vt () => let
        val () = prerr_error2_loc (d1e1.d1exp_loc)
        val () = filprerr_ifdebug "d1exp_tr_app_dyn_dqid"
        val () = prerr ": unrecognized dynamic identifier ["
        val () = prerr_dqid (dq, id)
        val () = prerr "]."
        val () = prerr_newline ()
        val () = the_trans2errlst_add (T2E_d1exp_tr (d1e0))
      in
        d2exp_err (d1e0.d1exp_loc)
      end // end of [None_vt]
  end // end of [_]
//
end // end of [d1exp_tr_app_dyn_dqid]

and
d1exp_tr_app_dyn_e1xp (
  d1e0: d1exp, d1e1: d1exp
, e0: e1xp
, locarg: location, npf: int, darg: d1explst 
) : d2exp = let
in
//
case+ e0.e1xp_node of
| E1XPfun _ => let
    val loc0 = d1e0.d1exp_loc
//
    prval pfu = unit_v ()
    val es = list_map_vclo<d1exp> {unit_v} (pfu | darg, !p_clo) where {
      var !p_clo = @lam (pf: !unit_v | d1e: d1exp): e1xp => e1xp_make_d1exp (loc0, d1e)
    } // end of [val]
    prval unit_v () = pfu
//
    val e1 = e1xp_app (loc0, e0, loc0, (l2l)es)
// (*
    val () = (
      print "d1exp_tr_app_dyn_e1xp: e1 = "; print_e1xp e1; print_newline ()
    ) // end of [val]
// *)
    val e2 = e1xp_normalize (e1)
// (*
    val () = (
      print "d1exp_tr_app_dyn_e1xp: e2 = "; print_e1xp e2; print_newline ()
    ) // end of [val]
// *)
    val d1e0_new = d1exp_make_e1xp (loc0, e2)
  in
    d1exp_tr (d1e0_new)
  end // end of [E1XPfun]
| _ => let
    val d1e_fun =
      d1exp_make_e1xp (d1e1.d1exp_loc, e0)
    // end of [val]
  in
    d1exp_tr_app_dyn (d1e0, d1e_fun, locarg, npf, darg)
  end (* end of [_] *)
//
end // end of [d1exp_tr_app_dyn_e1xp]

and
d1exp_tr_app_sta_dyn_dqid (
  d1e0: d1exp
, d1e1: d1exp
, d1e2: d1exp
, dq: d0ynq, id: symbol
, sarg: s1exparglst
, locarg: location, npf: int, darg: d1explst 
) : d2exp = let
  val ans = the_d2expenv_find_qua (dq, id)
in
//
case+ ans of
| ~Some_vt d2i => let
    val sarg = list_nil ()
  in
    d1exp_tr_app_sta_dyn_dqid_itm (d1e0, d1e1, d1e1, dq, id, d2i, sarg, locarg, npf, darg)
  end // end of [Some_vt]
| ~None_vt () => let
    val () = prerr_error2_loc (d1e1.d1exp_loc)
    val () = filprerr_ifdebug "d1exp_tr_app_sta_dyn_dqid"
    val () = prerr ": unrecognized dynamic identifier ["
    val () = prerr_dqid (dq, id)
    val () = prerr "]."
    val () = prerr_newline ()
    val () = the_trans2errlst_add (T2E_d1exp_tr (d1e0))
  in
    d2exp_err (d1e0.d1exp_loc)
  end
end // end of [d1exp_tr_app_sta_dyn_dqid]

and
d1exp_tr_app_sta_dyn_dqid_itm (
  d1e0: d1exp
, d1e1: d1exp
, d1e2: d1exp
, dq: d0ynq, id: symbol
, d2i: d2itm
, sarg: s1exparglst
, locarg: location, npf: int, darg: d1explst 
) : d2exp = let
in
//
case+ d2i of
| D2ITMcon d2cs => let
    val loc0 = d1e0.d1exp_loc
    val d2cs = d2con_select_arity (d2cs, 0)
    val- list_cons (d2c, _) = d2cs
    val sarg = s1exparglst_tr (sarg)
    val darg = d1explst_tr (darg)
  in
    d2exp_con (loc0, d2c, sarg, npf, darg)
  end // end of [D2ITEMcon]
| D2ITMcst d2c => let
    val d2e_fun =
      d2exp_cst (d1e2.d1exp_loc, d2c)
    // end of [val]
    val sarg = s1exparglst_tr (sarg)
    val darg = d1explst_tr (darg)
  in
    d2exp_app_sta_dyn (d1e0.d1exp_loc, d1e1.d1exp_loc, d2e_fun, sarg, locarg, npf, darg)
  end // end of [D2ITMcst]
| D2ITMvar d2v => let
    val d2e_fun = d2exp_var (d1e2.d1exp_loc, d2v)
    val sarg = s1exparglst_tr (sarg)
    val darg = d1explst_tr (darg)
  in
    d2exp_app_sta_dyn (d1e0.d1exp_loc, d1e1.d1exp_loc, d2e_fun, sarg, locarg, npf, darg)
  end // end of [D2ITMvar]
| _ => let
    val () = prerr_error2_loc (d1e2.d1exp_loc)
    val () = filprerr_ifdebug ": d1exp_tr_app_sta_dyn_dqid_itm"
    val () = prerr ": the identifier ["
    val () = prerr_dqid (dq, id)
    val () = prerr "] does not refer to any variable, constant or constructor."
    val () = prerr_newline ()
    val () = the_trans2errlst_add (T2E_d1exp_tr (d1e0))
  in
    d2exp_err (d1e0.d1exp_loc)
  end (* end of [_] *)
//
end // end of [d1exp_tr_app_sta_dyn_dqid_itm]

(* ****** ****** *)

implement
d1exp_tr_app_dyn (
  d1e0, d1e_fun, locarg, npf, darg
) = let
(*
  val () = begin
    print "d1exp_tr_app_dyn: d1e0 = "; print_d1exp d1e0; print_newline ()
  end // end of [val]
*)
in
//
case+ d1e_fun.d1exp_node of
| D1Eide (id) => let
    val dq = $SYN.the_d0ynq_none in
    d1exp_tr_app_dyn_dqid (d1e0, d1e_fun, dq, id, locarg, npf, darg)
  end
| D1Edqid (dq, id) =>
    d1exp_tr_app_dyn_dqid (d1e0, d1e_fun, dq, id, locarg, npf, darg)
  // end of [D1Edqid]
| _ => let
    val d2e_fun = d1exp_tr (d1e_fun)
    val darg = d1explst_tr (darg)
  in
    d2exp_app_dyn (d1e0.d1exp_loc, d2e_fun, locarg, npf, darg)
  end // end of [_]
//
end // end of [d1exp_tr_app_dyn]

implement
d1exp_tr_app_sta_dyn (
  d1e0, d1e1, d1e_fun, sarg, locarg, npf, darg
) = let
(*
  val () = begin
    print "d1exp_tr_app_sta_dyn: d1e0 = "; print_d1exp d1e0; print_newline ()
  end // end of [val]
*)
in
//
case+ d1e_fun.d1exp_node of
| D1Eide (id) => let
    val dq = $SYN.the_d0ynq_none in
    d1exp_tr_app_sta_dyn_dqid (d1e0, d1e1, d1e_fun, dq, id, sarg, locarg, npf, darg)
  end
| D1Edqid (dq, id) =>
    d1exp_tr_app_sta_dyn_dqid (d1e0, d1e1, d1e_fun, dq, id, sarg, locarg, npf, darg)
  // end of [D1Edqid]
| _ => let
    val d2e_fun = d1exp_tr (d1e_fun)
    val sarg = s1exparglst_tr (sarg)
    val darg = d1explst_tr (darg)
  in
    d2exp_app_sta_dyn (d1e0.d1exp_loc, d1e1.d1exp_loc, d2e_fun, sarg, locarg, npf, darg)
  end // end of [_]
//
end // end of [d1exp_tr_app_sta_dyn]

(* ****** ****** *)

fn d2sym_lrbrackets
  (d1e0: d1exp): d2sym = let
  val loc0 = d1e0.d1exp_loc
  val id = $SYM.symbol_LRBRACKETS
  var err: int = 0
  var d2is: d2itmlst = list_nil ()
  val ans = the_d2expenv_find (id)
  val () = (
    case+ ans of
    | ~Some_vt d2i => (
        case+ d2i of
        | D2ITMsymdef xs => d2is := xs | _ => err := err + 1
      ) // end of [Some_vt]
    | ~None_vt () => (err := err + 1)
  ) // end of [val]
  val () = if err > 0 then { // run-time checking
    val () = prerr_interror_loc (loc0)
    val () = (prerr ": d2sym_lrbrackets: d1e0 = "; prerr_d1exp d1e0)
    val () = prerr_newline ()
  } // end of [val]
in
  d2sym_make (loc0, $SYN.d0ynq_none (loc0), id, d2is)
end // end of [d2sym_lrbrackets]

fn d1exp_tr_arrsub (
  d1e0: d1exp
, arr: d1exp, locind: location, ind: d1explstlst
) : d2exp = let
  val loc0 = d1e0.d1exp_loc
  val d2s = d2sym_lrbrackets (d1e0)
  val arr = d1exp_tr (arr)
  val ind = l2l (list_map_fun (ind, d1explst_tr))
in
  d2exp_arrsub (loc0, d2s, arr, locind, ind)
end // end of [d1exp_tr_arrsub]

(* ****** ****** *)
//
// HX: [w1ts] is assumed to be not empty
//
fun d1exp_tr_wths1explst (
  d1e0: d1exp, w1ts: wths1explst
) : d2exp = let
  val loc0 = d1e0.d1exp_loc
in
//
case+ d1e0.d1exp_node of
| D1Eann_type (d1e, s1e) => let
    val d2e = d1exp_tr (d1e)
    val s2e = s1exp_trdn_res_impredicative (s1e, w1ts)
  in
    d2exp_ann_type (loc0, d2e, s2e)
  end // end of [D1Eann_type]
| D1Eann_effc (d1e, efc) => let
    val d2e = d1exp_tr_wths1explst (d1e, w1ts)
    val s2fe = effcst_tr (efc)
  in
    d2exp_ann_seff (loc0, d2e, s2fe)
  end // end of [D1Eann_effc]
| D1Eann_funclo (d1e, fc) => let
    val d2e = d1exp_tr_wths1explst (d1e, w1ts)
  in
    d2exp_ann_funclo (loc0, d2e, fc)
  end // end of[D1Eann_funclo]
| _ => let
    val () = prerr_error2_loc (loc0)
    val () = filprerr_ifdebug ": d1exp_wths1explst_tr"
    val () = prerr ": the dynamic expression is expected to be ascribed a type but it is not."
    val () = prerr_newline ()
    val () = the_trans2errlst_add (T2E_d1exp_tr (d1e0))
  in
    d2exp_err (loc0)
  end // end of [_]
end (* end of [d1exp_wths1explst_tr] *)

fn d1exp_tr_arg_body (
  p1t_arg: p1at, d1e_body: d1exp
) : @(int, p2atlst, d2exp) = let
  var w1ts = WTHS1EXPLSTnil ()
  val p2t_arg = p1at_tr_arg (p1t_arg, w1ts)
  val () = w1ts := wths1explst_reverse (w1ts)
  var npf: int = 0
  val p2ts_arg = (
    case+ p2t_arg.p2at_node of
    | P2Tlist (npf1, p2ts) => (npf := npf1; p2ts)
    | _ => list_sing (p2t_arg)
  ) : p2atlst // end of [val]
  val (pfenv | ()) = the_trans2_env_push ()
  val () = {
    val () = the_s2expenv_add_svarlst ($UT.lstord_listize (p2t_arg.p2at_svs))
    val () = the_d2expenv_add_dvarlst ($UT.lstord_listize (p2t_arg.p2at_dvs))
  } // end of [val]
  val (pfinc | ()) = the_d2varlev_inc ()
  val d2e_body = (
    if wths1explst_is_none w1ts then
      d1exp_tr (d1e_body) // regular translation
    else
      d1exp_tr_wths1explst (d1e_body, w1ts)
    // end of [if]
  ) : d2exp // end of [val]
  val () = the_d2varlev_dec (pfinc | (*none*))
  val () = the_trans2_env_pop (pfenv | (*none*))
//
// val p2ts_arg = lamvararg_proc (p2ts_arg) // HX-2010-08-26: for handling variadic functions
//
in
  @(npf, p2ts_arg, d2e_body)
end // end of [d1exp_tr_arg_body]

(* ****** ****** *)

fn i1nvarg_tr
  (x: i1nvarg): Option_vt (i2nvarg) = let
//
fn auxerr1 (x: i1nvarg): void = {
  val () = prerr_error2_loc (x.i1nvarg_loc)
  val () = filprerr_ifdebug (": i1nvarglst_tr")
  val () = prerr ": the dynamic identifier ["
  val () = $SYM.prerr_symbol (x.i1nvarg_sym)
  val () = prerr "] should refer to a variable but it does not."
  val () = prerr_newline ()
  val () = the_trans2errlst_add (T2E_i1nvarg_tr (x))
} // end of [auxerr1]
fun auxerr2 (x: i1nvarg): void = {
  val () = prerr_error2_loc (x.i1nvarg_loc)
  val () = filprerr_ifdebug (": i1nvarglst_tr")
  val () = prerr ": the dynamic identifier ["
  val () = $SYM.prerr_symbol (x.i1nvarg_sym)
  val () = prerr "] is unrecognized."
  val () = prerr_newline ()
  val () = the_trans2errlst_add (T2E_i1nvarg_tr (x))
} // end of [auxerr2]
//
val ans = the_d2expenv_find x.i1nvarg_sym
//
in
//
case+ ans of
| ~Some_vt d2i => (case+ d2i of
  | D2ITMvar d2v => let
      val typ = (case+ x.i1nvarg_typ of
        | Some s1e => Some (s1exp_trdn_impredicative s1e)
        | None () => None ()
      ) : s2expopt // end of [val]
      val arg = i2nvarg_make (d2v, typ)
    in
      Some_vt (arg)
    end // end of [D2ITEMvar]
  | _ => let
      val () = auxerr1 (x) in None_vt ()
    end // end of [_]
  ) // end of [Some_vt]
| ~None_vt () => let
    val () = auxerr2 (x) in None_vt ()
  end // end of [None_vt]
// end of [case]
end // end of [i1nvarg_tr]

fun
i1nvarglst_tr
  (xs: i1nvarglst): i2nvarglst = let
(*
  val () = print "i1nvarlst_tr: xs = "
  val () = fprint_i1nvarglst (stdout_ref, xs)
  val () = print_newline ()
*)
in
//
case+ xs of
| list_cons (x, xs) => let
    val opt = i1nvarg_tr (x) in case+ opt of
    | ~Some_vt (x) => list_cons (x, i1nvarglst_tr (xs))
    | ~None_vt () => i1nvarglst_tr (xs)
  end (* end of [list_cons] *)
| list_nil () => list_nil ()
//
end // end of [i1nvarglst_tr]

fn i1nvresstate_tr
  (r1es: i1nvresstate): i2nvresstate = let
  val s2q = s1qualst_tr (r1es.i1nvresstate_qua)
  val body = i1nvarglst_tr r1es.i1nvresstate_arg
in
  i2nvresstate_make (s2q.s2qua_svs, s2q.s2qua_sps, body)
end // end of [i1nvresstate_tr]

fn loopi1nv_tr
  (inv: loopi1nv): loopi2nv = let
  val s2q = s1qualst_tr (inv.loopi1nv_qua)
  val met = (case+ inv.loopi1nv_met of
    | Some s1es => Some (s1explst_trdn_int s1es) | None () => None ()
  ) : s2explstopt
  val arg = i1nvarglst_tr (inv.loopi1nv_arg)
  val res = i1nvresstate_tr (inv.loopi1nv_res)
in
  loopi2nv_make (inv.loopi1nv_loc, s2q.s2qua_svs, s2q.s2qua_sps, met, arg, res)
end // end of [loopi1nv_tr]

(* ****** ****** *)

fn m1atch_tr
  (m1at: m1atch): m2atch = let
  val d2e = d1exp_tr (m1at.m1atch_exp)
  val p2topt = (
    case+ m1at.m1atch_pat of
    | Some p1t => let
        val p2t = p1at_tr p1t
        val s2vs = $UT.lstord_listize (p2t.p2at_svs)
        val () = the_s2expenv_add_svarlst s2vs
        val d2vs = $UT.lstord_listize (p2t.p2at_dvs)
        val () = the_d2expenv_add_dvarlst d2vs
      in
        Some (p2t)
      end // end of [Some]
    | None () => None ()
  ) : p2atopt // end of [val]
in
  m2atch_make (m1at.m1atch_loc, d2e, p2topt)
end // end of [m1atch_tr]

(* ****** ****** *)

fn c1lau_tr {n:nat}
  (n: int n, c1l: c1lau): c2lau = let
//
  fn auxerr (
    c1l: c1lau, n: int, n1: int
  ) : void = let
    val () = prerr_error2_loc (c1l.c1lau_loc)
    val () = filprerr_ifdebug (": c1lau_tr")
    val () = prerr ": this clause should contain "
    val () = prerr_string (if n < n1 then "less" else "more")
    val () = prerr " patterns."
    val () = prerr_newline ()
    val () = the_trans2errlst_add (T2E_c1lau_tr (c1l))
  in
    // nothing
  end // end of [auxerr]
//
  val loc = c1l.c1lau_loc
  val p1t = c1l.c1lau_pat
  val p1ts = (case+ p1t.p1at_node of
    | P1Tlist (_(*npf*), p1ts) => p1ts | _ => list_sing (p1t)
  ) : p1atlst // end of [val]
  val p2ts = p1atlst_tr (p1ts)
  val n1 = list_length (p2ts)
(*
  val () = begin
    printf ("c1lau_tr: n = %i and n1 = %i\n", @(n, n1))
  end // end of [val]
*)
//
  val () = if n != n1 then auxerr (c1l, n, n1)
//
  val (pfenv | ()) = the_trans2_env_push ()
  val () = let
    val s2vs = $UT.lstord_listize (p2atlst_svs_union p2ts)
  in
    the_s2expenv_add_svarlst (s2vs)
  end // end of [val]
  val () = let
    val d2vs = $UT.lstord_listize (p2atlst_dvs_union p2ts)
  in
    the_d2expenv_add_dvarlst (d2vs)
  end // end of [val]
  val gua = l2l (list_map_fun (c1l.c1lau_gua, m1atch_tr))
  val body = d1exp_tr (c1l.c1lau_body)
  val () = the_trans2_env_pop (pfenv | (*none*))
//
in
  c2lau_make (loc, p2ts, gua, c1l.c1lau_seq, c1l.c1lau_neg, body)
end // end of [c1lau_tr]

fun c1laulst_tr {n:nat}
  (n: int n, c1ls: c1laulst): c2laulst = (
  case+ c1ls of
  | list_cons (c1l, c1ls) =>
      list_cons (c1lau_tr (n, c1l), c1laulst_tr (n, c1ls))
  | list_nil () => list_nil ()
) // end of [c1laulst_tr]

(* ****** ****** *)

fn sc1lau_trdn (
  sc1l: sc1lau, s2t_pat: s2rt
) : sc2lau = let
  val (pfenv | ()) = the_s2expenv_push_nil ()
  val sp2t = sp1at_trdn (sc1l.sc1lau_pat, s2t_pat)
  val body = d1exp_tr (sc1l.sc1lau_body)
  val () = the_s2expenv_pop_free (pfenv | (*none*))  
in
  sc2lau_make (sc1l.sc1lau_loc, sp2t, body)
end // end of [sc1lau_tr]

fun sc1laulst_trdn (
  xs: sc1laulst, s2t: s2rt
) : sc2laulst = (
  case+ xs of
  | list_cons (x, xs) =>
      list_cons (sc1lau_trdn (x, s2t), sc1laulst_trdn (xs, s2t))
  | list_nil () => list_nil ()
) // end of [sc1laulst_trdn]

(* ****** ****** *)

implement
d1exp_tr (d1e0) = let
// (*
  val () = begin
    print "d1exp_tr: d1e0 = "; print_d1exp d1e0; print_newline ()
  end // end of [val]
// *)
  val loc0 = d1e0.d1exp_loc
in
//
case+ d1e0.d1exp_node of
//
| D1Eide (id) =>
    d1exp_tr_dqid (d1e0, $SYN.the_d0ynq_none, id)
  // end of [D1Eide]
| D1Edqid (dq, id) => d1exp_tr_dqid (d1e0, dq, id)
//
| D1Ebool (b) => d2exp_bool (loc0, b)
| D1Eint (rep) => d2exp_int (loc0, rep)
| D1Echar (c) => d2exp_char (loc0, c)
| D1Estring (s) => d2exp_string (loc0, s)
| D1Efloat (rep) => d2exp_float (loc0, rep)
//
| D1Ei0nt (x) => d2exp_i0nt (loc0, x)
| D1Ec0har (x) => d2exp_c0har (loc0, x)
| D1Ef0loat (x) => d2exp_f0loat (loc0, x)
| D1Es0tring (x) => d2exp_s0tring (loc0, x)
//
| D1Ecstsp cst => d2exp_cstsp (loc0, cst)
//
| D1Etop () => d2exp_top (loc0)
| D1Eempty () => d2exp_empty (loc0)
//
| D1Eextval (s1e, code) => let
    val s2e = s1exp_trdn_viewt0ype (s1e)
  in
    d2exp_extval (loc0, s2e, code)
  end (* end of [D1Eextval] *)
//
| D1Eloopexn (knd) => d2exp_loopexn (loc0, knd)
//
| D1Efoldat (s1as, d1e) => let
    val s2as = s1exparglst_tr (s1as) in
    d2exp_foldat (loc0, s2as, d1exp_tr (d1e))
  end // end of [D1Efoldat]
| D1Efreeat (s1as, d1e) => let
    val s2as = s1exparglst_tr (s1as) in
    d2exp_freeat (loc0, s2as, d1exp_tr (d1e))
  end // end of [D1Efreeat]
//
| D1Elet (d1cs, d1e) => let
    val (pfenv | ()) = the_trans2_env_push ()
    val d2cs = d1eclist_tr (d1cs); val d2e = d1exp_tr (d1e)
    val () = the_trans2_env_pop (pfenv | (*none*))
  in
    d2exp_let (loc0, d2cs, d2e)
  end // end of [D1Elet]
| D1Ewhere (d1e, d1cs) => let
    val (pfenv | ()) = the_trans2_env_push ()
    val d2cs = d1eclist_tr (d1cs); val d2e = d1exp_tr (d1e)
    val () = the_trans2_env_pop (pfenv | (*none*))
  in
    d2exp_where (loc0, d2e, d2cs)
  end // end of [D1Ewhere]
| D1Edecseq (d1cs) => let
    val (pfenv | ()) = the_trans2_env_push ()
    val d2cs = d1eclist_tr (d1cs); val d2e = d2exp_empty (loc0)
    val () = the_trans2_env_pop (pfenv | (*none*))
  in
    d2exp_let (loc0, d2cs, d2e)
  end // end of [D1Edecseq]
//
| D1Eapp_dyn (
    d1e1, locarg, npf, darg
  ) => (
    case+ d1e1.d1exp_node of
    | D1Eapp_sta (d1e_fun, sarg) =>
        d1exp_tr_app_sta_dyn (d1e0, d1e1, d1e_fun, sarg, locarg, npf, darg)
      // end of [P1Tapp_sta]
    | _ => d1exp_tr_app_dyn (d1e0, d1e1, locarg, npf, darg)
  ) // end of [D1Eapp_dyn]
| D1Eapp_sta (d1e1, sarg) => let
    val locarg = d1e1.d1exp_loc in
    d1exp_tr_app_sta_dyn (d1e0, d1e1, d1e1, sarg, locarg, ~1(*npf*), list_nil(*darg*))
  end // end of [D1Eapp_sta]
//
| D1Elist (npf, d1es) => (
  case+ d1es of
  | list_cons _ => let
      val knd = TYTUPKIND_flt // HX: flat tuple
      val d2es = d1explst_tr (d1es)
    in
      d2exp_tup (loc0, knd, npf, d2es)
    end // end of [list_cons]
  | list_nil () => d2exp_empty (loc0)
  ) // end of [D1Elist]
//
| D1Eifhead (
    r1es, _cond, _then, _else
  ) => let
    val r2es = i1nvresstate_tr r1es
    val _cond = d1exp_tr (_cond)
    val _then = d1exp_tr (_then)
    val _else = d1expopt_tr (_else)
  in
    d2exp_ifhead (loc0, r2es, _cond, _then, _else)
  end // end of [D1Eifhead]
| D1Esifhead (
    r1es, _cond, _then, _else
  ) => let
    val r2es = i1nvresstate_tr r1es
    val _cond = s1exp_trdn_bool (_cond)
    val _then = d1exp_tr (_then)
    val _else = d1exp_tr (_else)
  in
    d2exp_sifhead (loc0, r2es, _cond, _then, _else)
  end // end of [D1Eifhead]
//
| D1Ecasehead (
    knd, r1es, d1es, c1ls
  ) => let
    val r2es = i1nvresstate_tr (r1es)
    val d2es = d1explst_tr (d1es)
    val ntup = list_length (d2es)
    val c2ls = c1laulst_tr (ntup, c1ls)
  in
    d2exp_casehead (loc0, knd, r2es, d2es, c2ls)
  end // end of [D1Ecaseof]
| D1Escasehead
    (r1es, s1e, sc1ls) => let
    val r2es = i1nvresstate_tr (r1es)
    val s2e = s1exp_trup (s1e)
    val s2t_pat = s2e.s2exp_srt
    val sc2ls = sc1laulst_trdn (sc1ls, s2t_pat)
(*
    val () =
      sc2laulst_covercheck (loc0, sc2ls, s2t_pat) // FIXME!!!
    // end of [val]
*)
  in
    d2exp_scasehead (loc0, r2es, s2e, sc2ls)
  end // end of [D1Escaseof]
//
| D1Elst (lin, s1eopt, d1es) => let
    val s2eopt = (
      case+ s1eopt of
      | Some s1e => Some (s1exp_trdn_impredicative (s1e))
      | None () => None ()
    ) : s2expopt // end of [val]
    val d2es = d1explst_tr (d1es)
  in
    d2exp_lst (loc0, lin, s2eopt, d2es)
  end // end of [D1Elst]
| D1Etup (tupknd, npf, d1es) =>
    d2exp_tup (loc0, tupknd, npf, d1explst_tr d1es)
  // end of [D1Etup]
| D1Erec (recknd, npf, ld1es) => let
    val ld2es = l2l (list_map_fun (ld1es, labd1exp_tr))
  in
    d2exp_rec (loc0, recknd, npf, ld2es)
  end // end of [D1Erec]
| D1Eseq d1es => let
    val d2es = d1explst_tr (d1es) in d2exp_seq (loc0, d2es)
  end // end of [D1Eseq]
//
| D1Earrsub (arr, locind, ind) =>
    d1exp_tr_arrsub (d1e0, arr, locind, ind)
  // end of [D1Earrsub]
| D1Earrinit
    (s1e_elt, asz, ini) => let
    val s2t_elt = (case+ asz of
      | Some _ => begin case+ ini of
        | list_cons _ => s2rt_t0ype // cannot be linear
        | list_nil () (*uninitialized*) => s2rt_viewt0ype // can be linear
        end // end of [Some]
      | None () => s2rt_viewt0ype // can be linear
    ) : s2rt // end of [val]
    val s2e_elt = s1exp_trdn (s1e_elt, s2t_elt)
    val asz = d1expopt_tr (asz)
    val ini = d1explst_tr (ini)
  in
    d2exp_arrinit (loc0, s2e_elt, asz, ini)
  end // end of [D1Earrinit]
| D1Earrsize
    (elt, ini) => let
    val elt = s1expopt_trup (elt); val ini = d1explst_tr (ini)
  in
    d2exp_arrsize (loc0, elt, ini)
  end // end of [D1Earrsize]
//
| D1Eraise (d1e) => d2exp_raise (loc0, d1exp_tr d1e)
| D1Edelay (knd, d1e) => d2exp_delay (loc0, knd, d1exp_tr d1e)
//
| D1Eptrof (d1e) => d2exp_ptrof (loc0, d1exp_tr d1e)
| D1Eviewat (d1e) => d2exp_viewat (loc0, d1exp_tr d1e)
| D1Esel (knd, d1e, d1l) => let
    val d2e = d1exp_tr d1e; val d2l = d1lab_tr d1l
  in
    if knd = 0 then ( // [.]
      case+ d2e.d2exp_node of
      | D2Esel (d2e_root, d2ls) =>
          d2exp_sel_dot (loc0, d2e_root, l2l (list_extend (d2ls, d2l)))
        // end of [D2Esel]
      | _ => d2exp_sel_dot (loc0, d2e, list_sing (d2l))
    ) else
      d2exp_sel_ptr (loc0, d2e, d2l) // [->]
    // end of [if]
  end (* end of [D1Esel] *)
//
| D1Eexist (s1a, d1e) => let
    val s2a = s1exparg_tr (s1a); val d2e = d1exp_tr (d1e)
  in
    d2exp_exist (loc0, s2a, d2e)
  end // end of [D1Eexist]
//
| D1Elam_dyn (lin, p1t_arg, d1e_body) => let
    val @(npf, p2ts_arg, d2e_body) = d1exp_tr_arg_body (p1t_arg, d1e_body)
  in
    d2exp_lam_dyn (loc0, lin, npf, p2ts_arg, d2e_body)
  end // end of [D1Elam_dyn]
| D1Elaminit_dyn (lin, p1t_arg, d1e_body) => let
    val @(npf, p2ts_arg, d2e_body) = d1exp_tr_arg_body (p1t_arg, d1e_body)
  in
    d2exp_laminit_dyn (loc0, lin, npf, p2ts_arg, d2e_body)
  end // end of [D1Elam_dyn]
| D1Elam_met (locarg, met, body) => let
    val met = s1explst_trup (met); val body = d1exp_tr (body)
  in
    d2exp_lam_met_new (loc0, met, body)
  end (* end of [D1Elam_met] *)
| D1Efix (knd, id, d1e_body) => let
    val d2v =
      d2var_make (id.i0de_loc, id.i0de_sym)
    // end of [val]
    val () = d2var_set_isfix (d2v, true)
    val (pfenv | ()) = the_d2expenv_push_nil ()
    val () = the_d2expenv_add_dvar (d2v)
    val d2e_body = d1exp_tr (d1e_body)
    val () = the_d2expenv_pop_free (pfenv | (*none*))
  in
    d2exp_fix (loc0, knd, d2v, d2e_body)
  end // end of [D1Efix]
//
| D1Elam_sta_syn
    (_(*locarg*), s1qs, d1e) => let
    val (pfenv | ()) = the_s2expenv_push_nil ()
    val s2q = s1qualst_tr (s1qs); val d2e = d1exp_tr (d1e)
    val () = the_s2expenv_pop_free (pfenv | (*none*))
  in
    d2exp_lam_sta (loc0, s2q.s2qua_svs, s2q.s2qua_sps, d2e)
  end // end of [D1Elam_sta_syn]
//
| D1Eann_type (d1e, s1e) => let
    val d2e = d1exp_tr d1e
    val s2e = s1exp_trdn_impredicative (s1e)
  in
    d2exp_ann_type (loc0, d2e, s2e)
  end // end of [D1Eann_type]
| D1Eann_effc (d1e, efc) => let
    val d2e = d1exp_tr (d1e); val s2fe = effcst_tr (efc)
  in
    d2exp_ann_seff (loc0, d2e, s2fe)
  end // end of [D1Eann_effc]
| D1Eann_funclo (d1e, fc) => let
    val d2e = d1exp_tr (d1e) in d2exp_ann_funclo (loc0, d2e, fc)
  end // end of [D1Eann_funclo]
//
| D1Eerr () => d2exp_err (loc0)
//
| D1Eidextapp
    (id, ns, d1es) => let
    val () = prerr_error2_loc (loc0)
    val () = prerr ": the external id ["
    val () = $SYM.prerr_symbol (id)
    val () = prerr "] cannot be handled."
    val () = prerr_newline ()
    val () = the_trans2errlst_add (T2E_d1exp_tr (d1e0))
  in
    d2exp_err (loc0)
  end // end of [_]
//
| D1Esexparg _ => let
    val () = prerr_error2_loc (loc0)
    val () = prerr ": this form of expression is only allowed to occur as an argument."
    val () = prerr_newline ()
    val () = the_trans2errlst_add (T2E_d1exp_tr (d1e0))
  in
    d2exp_err (loc0)
  end // end of [D1Esexparg]
//
// (*
| _ => let
    val () = prerr_interror_loc (loc0)
    val () = prerr ": d1exp_tr: not yet implemented: d1e0 = "
    val () = prerr_d1exp (d1e0)
    val () = prerr "]"
    val () = prerr_newline ()
  in
    $ERR.abort {d2exp} ()
  end // end of [_]
// *)
//
end // end of [d1exp_tr]

(* ****** ****** *)

implement
d1explst_tr (d1es) = l2l (list_map_fun (d1es, d1exp_tr))

implement
d1expopt_tr
  (d1eopt) = (case+ d1eopt of
  | Some (d1e) => Some (d1exp_tr d1e) | None () => None ()
) // end of [d1expopt_tr]

(* ****** ****** *)

implement
labd1exp_tr (ld1e) = let
  val+ $SYN.L0ABELED (l, d1e) = ld1e in labd2exp_make (l, d1exp_tr (d1e))
end // end of [labd0exp_tr]

(* ****** ****** *)

implement
d1lab_tr (d1l0) = let
  val loc0 = d1l0.d1lab_loc
in
  case+ d1l0.d1lab_node of
  | D1LABlab lab => d2lab_lab (loc0, lab)
  | D1LABind ind =>
      d2lab_ind (loc0, l2l (list_map_fun (ind, d1explst_tr)))
    // end of [D1LABind]
end // end of [d1lab_tr]

(* ****** ****** *)

(* end of [pats_trans2_dynexp.dats] *)