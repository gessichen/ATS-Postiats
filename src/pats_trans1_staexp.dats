(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(*                              Hongwei Xi                             *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-20?? Hongwei Xi, Boston University
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
// Start Time: April, 2011
//
(* ****** ****** *)

staload ERR = "pats_error.sats"
staload LOC = "pats_location.sats"
overload + with $LOC.location_combine

staload SYM = "pats_symbol.sats"
macdef AMPERSAND = $SYM.symbol_AMPERSAND
macdef BACKSLASH = $SYM.symbol_BACKSLASH
macdef BANG = $SYM.symbol_BANG
macdef QMARK = $SYM.symbol_QMARK
macdef QMARKBANG = $SYM.symbol_QMARKBANG
macdef GTGT = $SYM.symbol_GTGT
macdef MINUSGT = $SYM.symbol_MINUSGT
overload = with $SYM.eq_symbol_symbol

(* ****** ****** *)

staload "pats_effect.sats"
staload "pats_fixity.sats"
staload "pats_syntax.sats"
staload "pats_staexp1.sats"

(* ****** ****** *)

staload "pats_trans1.sats"
staload "pats_trans1_env.sats"

(* ****** ****** *)

#define l2l list_of_list_vt
macdef list_sing (x) = list_cons (,(x), list_nil ())

(* ****** ****** *)

fn prerr_loc_error1
  (loc: location): void = (
  $LOC.prerr_location loc; prerr ": error(1)"
) // end of [prerr_loc_error1]

fn prerr_interror (): void = prerr "INTERROR(pats_trans1_staexp)"

(* ****** ****** *)
//
// HX: translation of sorts
//
typedef s1expitm = fxitm (s1exp)
typedef s1expitmlst = List s1expitm

(* ****** ****** *)

local

fn appf (
  _fun: s1exp, _arg: s1exp
) :<cloref1> s1expitm = let
  val loc_arg = _arg.s1exp_loc
  val loc = _fun.s1exp_loc + loc_arg
  val xs_arg = (
    case+ _arg.s1exp_node of
    | S1Elist (npf, s1es) => s1es // HX: should npf <= 0 be enforced?
    | _ => list_sing (_arg)
  ) : s1explst // end of [val]
  val s1e_app = s1exp_app (loc, _fun, loc_arg, xs_arg)
in
  FXITMatm (s1e_app)
end // end of [appf]

in // in of [local]

(* ****** ****** *)

fn s1expitm_app
  (loc: location): s1expitm = fxitm_app (loc, appf)
// end of [s1expitm_app]

end // end of [local]

fn s1exp_get_loc (x: s1exp): location = x.s1exp_loc

fn s1exp_make_opr (
  opr: s1exp, f: fxty
) : s1expitm = begin
  fxopr_make {s1exp} (
    s1exp_get_loc
  , lam (loc, x, loc_arg, xs) => s1exp_app (loc, x, loc_arg, xs)
  , opr, f
  ) // end of [oper_make]
end // end of [s1exp_make_opr]

fn s1expitm_backslash
  (loc_opr: location) = begin
  fxopr_make_backslash {s1exp} (
    lam x => x.s1exp_loc
  , lam (loc, x, loc_arg, xs) => s1exp_app (loc, x, loc_arg, xs)
  , loc_opr
  ) // end of [oper_make_backslash]
end // end of [s1expitm_backslash]

(* ****** ****** *)

fn s0qua_tr
  (s0q: s0qua): s1qua =
  case+ s0q.s0qua_node of
  | S0QUAprop s0p => s1qua_prop (s0q.s0qua_loc, s0exp_tr s0p)
  | S0QUAvars (id, ids, s0te) =>
      s1qua_vars (s0q.s0qua_loc, list_cons (id, ids), s0rtext_tr s0te)
    // end of [S0QUAvars]
// end of [s0qua_tr]

implement
s0qualst_tr (xs) = l2l (list_map_fun (xs, s0qua_tr))
implement
s0qualstlst_tr (xss) = l2l (list_map_fun (xss, s0qualst_tr))

(* ****** ****** *)

implement
s0rtext_tr (s0te) = let
  val loc = s0te.s0rtext_loc in
//
case+ s0te.s0rtext_node of
| S0TEsrt s0t => s1rtext_srt (loc, s0rt_tr s0t)
| S0TEsub (id, s0te, s0p, s0ps) => let
    val s1te = s0rtext_tr s0te
    val s1p = s0exp_tr s0p and s1ps = s0explst_tr s0ps
  in
    s1rtext_sub (loc, id.i0de_sym, s1te, list_cons (s1p, s1ps))
  end
//
end // end of [s0rtext_tr]

(* ****** ****** *)

local

fn s0exp_tr_errmsg_opr
  (loc: location): s1exp = let
  val () = prerr_loc_error1 (loc)
  val () = prerr ": the operator needs to be applied."
  val () = prerr_newline ()
in
  $ERR.abort {s1exp} ()
end // end of [s0exp_tr_errmsg_opr]

in // in of [local]

implement
s0exp_tr s0e0 = let
//
#define :: list_cons
//
fun
aux_item (
  s0e0: s0exp
) : s1expitm = let
  val loc0 = s0e0.s0exp_loc in
  case+ s0e0.s0exp_node of
//
  | S0Eint (int) => FXITMatm (s1exp_int (loc0, int))
  | S0Echar (char) => FXITMatm (s1exp_char (loc0, char))
//
  | S0Eextype (name, s0es) => let
      fun f (
        s0e: s0exp
      ) : s1explst = let
        val s1e = s0exp_tr (s0e) in
        case+ s1e.s1exp_node of
        | S1Elist (_(*npf*), s1es) => s1es | _ => list_sing (s1e)
      end // end of [f]
      val s1ess = l2l (list_map_fun (s0es, f))
    in
      FXITMatm (s1exp_extype (loc0, name, s1ess))
    end // end of [S0Eextype]
//
  | S0Eide id when id = AMPERSAND => let
      fn f (
        s1e: s1exp
      ) :<cloref1> s1expitm = let
        val loc = loc0 + s1e.s1exp_loc
      in
        FXITMatm (s1exp_invar (loc, 1(*ref*), s1e))
      end // end of [f]
    in
      FXITMopr (loc0, FXOPRpre (invar_prec_sta, f))
    end // end of [S0Eide when ...]
  | S0Eide id when id = BANG => let
      fn f (
        s1e: s1exp
      ) :<cloref1> s1expitm = let
        val loc = loc0 + s1e.s1exp_loc
      in
        FXITMatm (s1exp_invar (loc, 0(*val*), s1e))
      end // end of [f]
    in
      FXITMopr (loc0, FXOPRpre (invar_prec_sta, f))
    end // end of [S0Eide when ...]
  | S0Eide id when id = QMARKBANG => let
      fn f (
        s1e: s1exp
      ) :<cloref1> s1expitm = let
        val loc = s1e.s1exp_loc + loc0
      in
        FXITMatm (s1exp_top (loc0, 1(*knd*), s1e))
      end // end of [f]
    in
      FXITMopr (loc0, FXOPRpos (qmarkbang_prec_sta, f))
    end // end of [S0Eide when ...]
  | S0Eide id when id = GTGT => let
      fn f (
        s1e1: s1exp, s1e2: s1exp
      ) :<cloref1> s1expitm = let
        val loc = s1e1.s1exp_loc + s1e2.s1exp_loc
      in
        FXITMatm (s1exp_trans (loc, s1e1, s1e2))
      end // end of [f]
    in
      FXITMopr (loc0, FXOPRinf (trans_prec_sta, ASSOCnon, f))
    end // end of [S0Eide when ...]
//
  | S0Eide (id) => let
      val s1e = s1exp_ide (loc0, id) in
      case+ the_fxtyenv_find id of
      | ~Some_vt f => s1exp_make_opr (s1e, f) | ~None_vt () => FXITMatm (s1e)
      // end of [case]
    end // end of [S0Eide]
  | S0Eopid (id) => FXITMatm (s1exp_ide (loc0, id))
  | S0Esqid (sq, id) => FXITMatm (s1exp_sqid (loc0, sq, id))
//
  | S0Eapp _ => let 
      val s1e_app = fixity_resolve (
        loc0, s1exp_get_loc, s1expitm_app (loc0), aux_itemlst s0e0
      ) // end of [val]
    in
      FXITMatm (s1e_app)
    end // end of [S0Eapp]
  | S0Elam (arg, res, body) => let
      val arg = s0marg_tr arg
      val res = s0rtopt_tr res
      val body = s0exp_tr body
      val s1e_lam = s1exp_lam (loc0, arg, res, body)
(*
      val () = begin
        print "s0exp_tr: S0Elam: s1e_lam = "; print s1e_lam; print_newline ()
      end // end of [val]
*)
    in
      FXITMatm (s1e_lam)
    end // end of [S0Elam]
  | S0Eimp tags => let
      val (ofc, lin, prf, efc) = e0fftaglst_tr (tags)
      val fc = (case+ ofc of
        | Some fc => fc | None => FUNCLOfun () // default is [function]
      ) : funclo // end of [val]
(*
      val () = begin
        print "s0exp_tr: S0Eimp: efc = "; print_effcst efc; print_newline ()
      end // end of [val]
*)
      val- ~Some_vt (f) = the_fxtyenv_find (MINUSGT)
      val s1e_imp = s1exp_imp (loc0, fc, lin, prf, Some efc)
    in
      s1exp_make_opr (s1e_imp, f)
    end // end of [S0Eimp]
//
  | S0Elist (s0es) => let
      val s1es = s0explst_tr s0es in FXITMatm (s1exp_list (loc0, s1es))
    end // end of [S0Elist]
  | S0Elist2 (s0es1, s0es2) => let
      val s1es1 = list_map_fun (s0es1, s0exp_tr)
      val s1es2 = list_map_fun (s0es2, s0exp_tr)
    in
      FXITMatm (s1exp_list2 (loc0, s1es1, s1es2))
    end // end of [S0Elist2]
//
  | S0Etytup (knd, npf, s0es) => let
      val s1es = s0explst_tr (s0es)
    in
      FXITMatm (s1exp_tytup (loc0, knd, npf, s1es))
    end // end of [S0Etytup]
  | S0Etyrec (knd, npf, ls0es) => let
      val ls1es = l2l (list_map_fun (ls0es, labs0exp_tr))
    in
      FXITMatm (s1exp_tyrec (loc0, knd, npf, ls1es))
    end // end of [S0Etyrec]
  | S0Etyrec_ext (name, npf, ls0es) => let
      val ls1es = l2l (list_map_fun (ls0es, labs0exp_tr))
    in
      FXITMatm (s1exp_tyrec_ext (loc0, name, npf, ls1es))
    end // end of [S0Etyrec]
//
  | S0Eexi (knd(*funres*), s0qs) => let
      val s1qs = s0qualst_tr s0qs
      fn f (
        body: s1exp
      ) :<cloref1> s1expitm = let
        val loc = loc0 + body.s1exp_loc in
        FXITMatm (s1exp_exi (loc0, knd, s1qs, body))
      end // end of [f]
    in
      FXITMopr (loc0, FXOPRpre (exi_prec_sta, f))
    end // end of [S0Eexi]
  | S0Euni (s0qs) => let
      val s1qs = s0qualst_tr s0qs
      fn f (
        body: s1exp
      ) :<cloref1> s1expitm = let
        val loc = loc0 + body.s1exp_loc in
        FXITMatm (s1exp_uni (loc, s1qs, body))
      end // end of [f]
    in
      FXITMopr (loc0, FXOPRpre (uni_prec_sta, f))
    end // end of [S0Euni]
//
  | S0Eann (s0e, s0t) => let
      val s1e_ann = s1exp_ann (loc0, s0exp_tr (s0e), s0rt_tr (s0t))
    in
      FXITMatm (s1e_ann)
    end // end of [S0Eann]
  | _ => let
      val () = (
        print "s0e0 = "; fprint_s0exp (stdout_ref, s0e0); print_newline ()
      ) // end of [val]
      val () = assertloc (false) in $ERR.abort ()
    end
end // end of [aux_item]
//
and aux_itemlst
  (s0e0: s0exp): s1expitmlst = let
  fun loop (s0e0: s0exp, res: s1expitmlst): s1expitmlst =
    case+ s0e0.s0exp_node of
    | S0Eapp (s0e1, s0e2) => let
        val res = aux_item s0e2 :: res in loop (s0e1, res)
      end // end of [S0Eapp]
    | _ => aux_item s0e0 :: res
  // end of [loop]
in
  loop (s0e0, list_nil ())
end // end of [aux_itemlist]
//
in
//
case+ aux_item (s0e0) of
| FXITMatm (s1e) => s1e
| FXITMopr _ => s0exp_tr_errmsg_opr (s0e0.s0exp_loc)
//
end // end of [s0exp_tr]

end // end of [local]

(* ****** ****** *)

implement
s0explst_tr (xs) = l2l (list_map_fun (xs, s0exp_tr))

implement
s0expopt_tr (opt) = case+ opt of
  | Some x => Some (s0exp_tr (x)) | None () => None ()
// end of [s0expopt_tr]

(* ****** ****** *)

implement
labs0exp_tr (x) = let
  val+ L0ABELED (l, s0e) = x in labs1exp_make (l, s0exp_tr (s0e))
end // end of [labs0exp_tr]

(* ****** ****** *)

implement
q0marg_tr (x) =
  q1marg_make (x.q0marg_loc, s0qualst_tr (x.q0marg_arg))
// end of [q0marg_tr]

implement q0marglst_tr (xs) = l2l (list_map_fun (xs, q0marg_tr))

(* ****** ****** *)

implement a0typ_tr (x) = s0exp_tr (x.a0typ_typ)
implement a0typlst_tr (xs) = l2l (list_map_fun (xs, a0typ_tr))

(* ****** ****** *)

local

extern fun extnam_ismac
  (ext: string, ext_new: &string): bool = "atsopt_extnam_ismac"
extern fun extnam_issta
  (ext: string, ext_new: &string): bool = "atsopt_extnam_issta"
extern fun extnam_isext
  (ext: string, ext_new: &string): bool = "atsopt_extnam_isext"

in // in of [local]

implement
dcstextdef_tr (ext) = let
(*
  val () = print ("dcstextdef_tr: ext = ...")
*)
in
//
case+ 0 of
| _ when
    stropt_is_some (ext) => let
    val ext = stropt_unsome ext
    var ext_new: string = ext
  in
    case+ 0 of
    | _ when extnam_ismac
        (ext, ext_new) => DCSTEXTDEFsome_mac ext_new
    | _ when extnam_issta
        (ext, ext_new) => DCSTEXTDEFsome_sta ext_new
    | _ when extnam_isext
        (ext, ext_new) => DCSTEXTDEFsome_ext ext_new
    | _ => DCSTEXTDEFsome_ext ext_new
  end // end of [_ when ...]
| _ => DCSTEXTDEFnone ()
// end of [case]
end // end of [dcstextdef_tr]

end // end of [local]

(* ****** ****** *)

local
//
// defining [d0cstdec_tr]
//
#define nil list_nil
#define :: list_cons
//
#define CLOPTR 1; #define CLOREF ~1
macdef FUNCLOcloptr = FUNCLOclo (CLOPTR)
macdef FUNCLOcloref = FUNCLOclo (CLOREF)

fun aux1 (
  fc: funclo
, lin: int, prf: int
, efcopt: effcstopt
, fst: int, lst: &int
, xs: d0cstarglst
, s1e_res: s1exp
) : s1exp = begin case+ xs of
  | x :: xs => begin case+ x.d0cstarg_node of
    | D0CSTARGdyn (npf, ys) => let
        val loc_x = x.d0cstarg_loc
        val s1e_arg = s1exp_npf_list (loc_x, npf, a0typlst_tr ys)
        val s1e_res = aux1 (fc, lin, prf, efcopt, fst+1, lst, xs, s1e_res)
        val loc_res = s1e_res.s1exp_loc
        val loc = loc_x + loc_res
        val fc = (if fst > 0 then FUNCLOcloptr else fc): funclo
        val imp = (
          if lst > 0 then begin
            s1exp_imp (loc_res, fc, 0, 0, None ())
          end else begin
            s1exp_imp (loc_res, fc, lin, prf, efcopt)
          end // end of [if]
        ) : s1exp // end of [val]
        val () = lst := lst + 1
      in
        s1exp_app (loc, imp, loc, s1e_arg :: s1e_res :: nil ())
      end // end of [D0CSTARGdyn2]
    | D0CSTARGsta s0qs => let
        val loc_x = x.d0cstarg_loc
        val s1qs = s0qualst_tr s0qs
        val s1e_res = aux1 (fc, lin, prf, efcopt, fst, lst, xs, s1e_res)
        val loc_res = s1e_res.s1exp_loc
        val loc = loc_x + loc_res
        val () = if lst = 0 then let
          val () = prerr_loc_error1 (loc_res)
          val () = prerr ": illegal use of effect annotation"
          val () = prerr_newline ()
        in
          $ERR.abort {void} ()
        end // end of [val]
      in
        s1exp_uni (loc, s1qs, s1e_res)
      end (* end of [D0CSTARGsta] *)
    end (* end of [::] *)
  | nil () => s1e_res // end of [nil]
end // end of [aux1]

fun aux2 .<>. (
    loc0: location
  , isfun: bool
  , isprf: bool
  , xs: d0cstarglst
  , otags: Option e0fftaglst
  , s1e_res: s1exp
  ) : s1exp = let
  var fc: funclo = FUNCLOfun ()
  var lin: int = 0 and prf: int = (if isprf then 1 else 0): int
  var efcopt: effcstopt = None ()
  val () = case+ otags of
    | Some tags => let
        val (ofc1, lin1, prf1, efc1) = e0fftaglst_tr (tags)
        val () = case+ ofc1 of
          | Some fc1 => fc := fc1 | None () => ()
        // end of [val]
      in
        lin := lin1; prf := prf + prf1; efcopt := Some efc1
      end // end of [Some]
    | None () => () // end of [None]
  // end of [val]
  val () = (case+ fc of
    | FUNCLOclo knd => begin
        if knd <> CLOREF then let
          val () = prerr_loc_error1 (loc0)
          val () = if knd = 0 then {
            val () = prerr ": a closure struct is not allowed at the toplevel."
          } // end of [val]
          val () = if knd = 1 then {
            val () = prerr ": a closure pointer is not allowed at the toplevel."
          } // end of [val]
          val () = prerr_newline ()
        in
          $ERR.abort {void} ()
        end // end of [if]
      end // end of [FUNCLOclo]
    | FUNCLOfun () => () // end of [FUNCLOfun]
  ) : void // end of [val]
  var lst: int = 0
in
  aux1 (fc, lin, prf, efcopt, 0, lst, xs, s1e_res)
end // end of [aux2]

fn d0cstdec_tr (
  isfun: bool, isprf: bool, d: d0cstdec
) : d1cstdec = let
  val loc0 = d.d0cstdec_loc
  val s1e_res = s0exp_tr d.d0cstdec_res
  val arg = d.d0cstdec_arg and eff = d.d0cstdec_eff
  val s1e = aux2 (loc0, isfun, isprf, arg, eff, s1e_res)
  val extdef = dcstextdef_tr (d.d0cstdec_extdef)
in
  d1cstdec_make (loc0, d.d0cstdec_fil, d.d0cstdec_sym, s1e, extdef)
end // end of [d0cstdec_tr]

in // in of [local]

implement
d0cstdeclst_tr (
  isfun, isprf, ds
) = case+ ds of
  | list_cons (d, ds) => let
      val d = d0cstdec_tr (isfun, isprf, d)
      val ds = d0cstdeclst_tr (isfun, isprf, ds)
    in
      list_cons (d, ds)
    end // end of [list_cons]
  | list_nil () => list_nil ()
// end of [d0cstdeclst_tr]

end // end of [local]

(* ****** ****** *)

implement
d0atcon_tr (d0c) = let
//
val qua = d0c.d0atcon_qua
val qua = q0marglst_tr (qua)
var npf0: int = 0
val arg = (
  case+ d0c.d0atcon_arg of
  | Some s0e => let
      val s1e = s0exp_tr s0e in
      case+ s1e.s1exp_node of
      | S1Elist (npf, s1es) => (npf0 := npf; s1es)
      | _ => list_cons (s1e, list_nil ())
    end // end of [Some]
  | None () => list_nil ()
) : s1explst
//
val ind = d0c.d0atcon_ind
val ind = (
  case+ ind of
  | Some s0e => let
      val s1es = (
        case+ s0e.s0exp_node of
        | S0Elist s0es => s0explst_tr (s0es)
        | _ => $ERR.abort () where {
            val () = prerr_interror ()
            val () = prerr ": d0atcon_tr: index is required to be a list."
            val () = prerr_newline ()
          } // end of [_]
      ) : s1explst // end of [val]
    in
      Some s1es
    end // end of [Some]
  | None () => None () // end of [None]
) : s1explstopt // end of [val]
//
in
  d1atcon_make (d0c.d0atcon_loc, d0c.d0atcon_sym, qua, npf0, arg, ind)
end // end of [d0atcon_tr]

(* ****** ****** *)

(* end of [pats_trans1_staexp.sats] *)