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
// Start Time: May, 2012
//
(* ****** ****** *)
//
// for handling left-value type restoration after a function call
//
(* ****** ****** *)

staload _(*anon*) = "prelude/DATS/list.dats"
staload _(*anon*) = "prelude/DATS/list_vt.dats"

(* ****** ****** *)

staload "pats_basics.sats"

(* ****** ****** *)

staload "pats_errmsg.sats"
staload _(*anon*) = "pats_errmsg.dats"
implement prerr_FILENAME<> () = prerr "pats_trans3_lvalres"

(* ****** ****** *)

staload "pats_syntax.sats"

(* ****** ****** *)

staload "pats_staexp2.sats"
staload "pats_staexp2_error.sats"
staload "pats_staexp2_util.sats"
staload "pats_stacst2.sats"
staload "pats_dynexp2.sats"
staload "pats_dynexp3.sats"

(* ****** ****** *)

staload SOL = "pats_staexp2_solve.sats"

(* ****** ****** *)

staload "pats_trans3.sats"
staload "pats_trans3_env.sats"

(* ****** ****** *)

local

fun auxerr_pfobj (
  loc0: location, s2l: s2exp
) : void = let
  val () = prerr_error3_loc (loc0)
  val () = prerr ": type-restoration cannot be performed"
  val () = prerr_newline ()
  val () = prerr ": the proof search for view located at ["
  val () = prerr_s2exp (s2l)
  val () = prerr "] failed to turn up a result."
  val () = prerr_newline ()
in
  the_trans3errlst_add (T3E_pfobj_search_none (loc0, s2l))
end // end of [auxerr_pfobj]

fun auxerr_nonatview (
  loc0: location, s2e: s2exp
) : void = let
  val () = prerr_error3_loc (loc0)
  val () = prerr ": type-restoration cannot be performed"  
  val () = prerr ": proof of some atview is needed but one of the following type is given: "
  val () = (prerr "["; prerr_s2exp (s2e); prerr "]")
in
  // nothing
end // end of [auxerr_nonatview]

fun auxmain (
  loc0: location
, pfobj: pfobj
, d3ls: d3lablst
, s2e_new: s2exp
) : s2exp = let
  val+ ~PFOBJ (
    d2v, s2e_ctx, s2e_elt, s2l
  ) = pfobj // end of [val]
  var ctxtopt: s2ctxtopt = None ()
  val s2e_old =
    s2exp_get_dlablst_context (loc0, s2e_elt, d3ls, ctxtopt)
  // end of [val]
in
//
case+ ctxtopt of
| Some (ctxt) => let
    val s2e_elt =
      s2ctxt_hrepl (ctxt, s2e_new)
    // end of [val]
    val s2e = s2exp_hrepl (s2e_ctx, s2e_elt)
    val () = d2var_set_type (d2v, Some (s2e))
  in
    s2e_old
  end // end of [Some]
| None () => let
    val err = $SOL.s2exp_tyleq_solve (loc0, s2e_new, s2e_old)
    val () = if err > 0 then let
      val () = prerr_error3_loc (loc0)
      val () = prerr ": mismatch of bef/aft types of call-by-reference: "
      val () = prerr_newline ()
      val () = prerr_the_staerrlst ()
    in
      the_trans3errlst_add (T3E_s2addr_exch_type_oldnew (loc0, s2e_elt, d3ls, s2e_new))
    end // end of [if] // end of [val]
  in
    s2e_old
  end // end of [None]
//
end // end of [auxmain]

in // in of [local]

implement
s2addr_exch_type (
  loc0, s2l, d3ls, s2e_new
) = let
  val opt = pfobj_search_atview (s2l)
in
//
case+ opt of
| ~Some_vt (pfobj) =>
    auxmain (loc0, pfobj, d3ls, s2e_new)
| ~None_vt () => let
    val () = auxerr_pfobj (loc0, s2l) in s2exp_t0ype_err ()
  end // end of [None_vt]
//
end // end of [s2addr_exch_type]

implement
s2addr_set_type_viewat (
  loc0, s2l, d3ls, s2e_new
) = let
  val s2e_new = s2exp_hnfize (s2e_new)
in
//
case+
  s2e_new.s2exp_node of
| S2Eat (s2e1, s2e2) => let
    val s2e_old = s2addr_exch_type (loc0,s2l, d3ls, s2e1)
  in
  end // end of [S2Eat]
| _ => auxerr_nonatview (loc0, s2e_new)
//
end // end of [s2addr_set_type_viewat]

end // end of [local]

(* ****** ****** *)

local

fun auxerr_linold (
  loc0: location
, d3e: d3exp, d3ls: d3lablst, s2e_old: s2exp
) : void = let
  val () = prerr_error3_loc (loc0)
  val () = prerr ": a linear component of the following type is abandoned: "
  val () = (prerr "["; prerr_s2exp (s2e_old); prerr "].")
  val () = prerr_newline ()
in
  the_trans3errlst_add (T3E_d3lval_exch_type_linold (loc0, d3e, d3ls))
end // end of [auxerr_linold]

fun d2var_refval_check (
  loc0: location, d2v: d2var, refval: int
) : void = 
  if refval > 0 then let
    val () = prerr_error3_loc (loc0)
    val () = prerr ": the dynamic variable ["
    val () = prerr_d2var (d2v)
    val () = prerr "] is required to be mutable in order to support call-by-reference."
    val () = prerr_newline ()
  in
    the_trans3errlst_add (T3E_d3lval_refval (loc0, d2v))
  end // end of [if]
// end of [d2var_refval_check]

in // in of [local]

implement
d3lval_set_type_err (
  refval, d3e0, s2e_new, err
) = let
//
val loc0 = d3e0.d3exp_loc
val () = (
  print "d3lval_set_type_err: s2e_new = "; print_s2exp (s2e_new); print_newline ()
) (* end of [val] *)
//
in
//
case+ d3e0.d3exp_node of
| D3Evar (d2v)
    when d2var_is_mutabl (d2v) => let
    val- Some (s2l) = d2var_get_addr (d2v)
    val d3ls = list_nil // HX: a special case of sel_var
    val _(*old*) = s2addr_exch_type (loc0, s2l, d3ls, s2e_new)
  in
    // nothing
  end // end of [D2Evar/mutabl]
| D3Evar (d2v)
    when d2var_is_linear (d2v) => let
    val () =
      d2var_refval_check (loc0, d2v, refval)
    // end of [val]
    val opt =
      d2var_exch_type (d2v, Some (s2e_new))
    // end of [val]
    val () = d3exp_set_type (d3e0, s2e_new)
  in
    case+ opt of
    | Some (s2e_old) => let
        val islin = s2exp_is_lin (s2e_old)
        val () = if islin then
          auxerr_linold (loc0, d3e0, list_nil(*d3ls*), s2e_old)
        // end of [if] // end of [val]
      in
        // nothing
      end // end of [Some]
    | None () => ()
  end // end of [D2Evar/linear]
//
| D3Esel_var (d2v, d3ls)
    when d2var_is_mutabl (d2v) => let
    val- Some (s2l) = d2var_get_addr (d2v)
    val _(*old*) = s2addr_exch_type (loc0, s2l, d3ls, s2e_new)
  in
    // nothing
  end // end of [D2Evar/mutabl]
| D3Esel_var (d2v, d3ls)
    when d2var_is_linear (d2v) => let
    val () =
      d2var_refval_check (loc0, d2v, refval)
    // end of [val]
    val s2e = d2var_get_type_some (loc0, d2v)
    var ctxtopt: s2expopt = None ()
    val s2e_old =
      s2exp_get_dlablst_context (loc0, s2e, d3ls, ctxtopt)
    val s2e_old = s2exp_hnfize (s2e_old)
    val islin = s2exp_is_lin (s2e_old)
    val () = if islin then auxerr_linold (loc0, d3e0, d3ls, s2e_old)
  in
    case+ ctxtopt of
    | Some (ctxt) => let
        val s2e =
          s2ctxt_hrepl (ctxt, s2e_new)
        // end of [val]
      in
        d2var_set_type (d2v, Some (s2e))
      end // end of [Some]
    | None () => let
        val () = prerr_interror_loc (loc0)
        val () = prerr ": type-restoration for the left-value failed."
        val () = prerr_newline ()
        val () = assertloc (false)
      in
        // this error can occur in theory, but will it do in practice?
      end // end of [None]
  end // end of [D3Evar/linear]
//
| D3Esel_ptr (d3e_ptr, d3ls) => let
    val s2e_ptr = d3exp_get_type (d3e_ptr)
    val s2f_ptr = s2exp2hnf (s2e_ptr)
    val- ~Some_vt (s2l) = un_s2exp_ptr_addr_type (s2f_ptr)
    val _(*old*) = s2addr_exch_type (loc0, s2l, d3ls, s2e_new)
  in
    // nothing
  end // end of [D2Esel_ptr]
//
| D3Eviewat (d3e_ptr, d3ls) => let
    val s2e_ptr = d3exp_get_type (d3e_ptr)
    val s2f_ptr = s2exp2hnf (s2e_ptr)
    val- ~Some_vt (s2l) = un_s2exp_ptr_addr_type (s2f_ptr)
  in
    s2addr_set_type_viewat (loc0, s2l, d3ls, s2e_new)
  end // end of [D2Eviewat]
//
(*
| _ => let
    val () = prerr_error3_loc (loc0)
    val () = prerr ": type-restoration cannot be applied to a non-left-value."
    val () = prerr_newline ()
  in
    the_trans3errlst_add (T3E_d3lval_funarg (d3e0))
  end // end of [_]
*)
| _ => (err := err + 1)
//
end // end of [d3lval_set_type_err]

end // end of [local]

(* ****** ****** *)

local

fn s2exp_fun_is_freeptr
  (s2e: s2exp): bool = (
  case+ s2e.s2exp_node of
  | S2Efun (
      fc, lin, _(*s2fe*), _(*npf*), _(*arg*), _(*res*)
    ) => (
    case+ fc of
    | FUNCLOclo (knd) when knd > 0 => if lin = 0 then true else false
    | _ => false
    ) // end of [S2Efun]
  | _ => false
) // end of [s2exp_fun_is_freeptr]

in // in of [local]

implement
d3lval_arg_set_type
  (refval, d3e0, s2e_new) = let
//
var err: int = 0
var freeknd: int = 0 // free [d3e0] if it is set to 1
val () = d3lval_set_type_err (refval, d3e0, s2e_new, err)
val () = (if err > 0 then begin
  case+ 0 of
  | _ when s2exp_is_nonlin (s2e_new) => () // HX: safely discarded!
  | _ when s2exp_fun_is_freeptr s2e_new => (freeknd := 1) // HX: leak if not freed
  | _  => let
      val loc0 = d3e0.d3exp_loc
      val () = prerr_error3_loc (loc0)
      val () = prerr ": the function argument needs to be a left-value."
      val () = prerr_newline ()
    in
      the_trans3errlst_add (T3E_d3lval_funarg (d3e0))
    end // end of [_]
end) : void // end of [val]
//
in
  freeknd // a linear value must be freed (freeknd = 1) if it cannot be returned
end (* end of [d3lval_arg_set_type] *)

end // end of [local]

(* ****** ****** *)

local

fun aux (
  d3es: d3explst
, s2es_arg: s2explst
, wths2es: wths2explst
) : d3explst = let
in
//
case+ wths2es of
| WTHS2EXPLSTcons_invar
    (_, wths2es) => let
    val- list_cons (d3e, d3es) = d3es
    val- list_cons (s2e_arg, s2es_arg) = s2es_arg
    val loc = d3e.d3exp_loc
    val- S2Erefarg (refval, s2e_res) = s2e_arg.s2exp_node
    val freeknd =
      d3lval_arg_set_type (refval, d3e, s2e_res)
    val d3e = d3exp_refarg (loc, s2e_res, refval, freeknd, d3e)
    val d3es = d3explst_arg_restore (d3es, s2es_arg, wths2es)
  in
    list_cons (d3e, d3es)
  end // end of [WTHS2EXPLSTcons_none]
| WTHS2EXPLSTcons_trans (
    refval, s2e_res, wths2es
  ) => let
    val- list_cons (d3e, d3es) = d3es
    val- list_cons (s2e_arg, s2es_arg) = s2es_arg
    val loc = d3e.d3exp_loc
    val s2f_res = s2exp2hnf (s2e_res)
    val s2e_res = s2hnf_opnexi_and_add (loc, s2f_res)
(*
    val () = (
      print "d3explst_arg_restore: aux: d3e = "; print d3e; print_newline ();
      print "d3explst_arg_restore: aux: d3e.type = "; print d3e.d3exp_type; print_newline ();
      print "d3explst_arg_restore: aux: s2e_res = "; print s2e_res; print_newline ();
    ) // end of [val]
*)
    val freeknd =
      d3lval_arg_set_type (refval, d3e, s2e_res)
    val d3e = d3exp_refarg (loc, s2e_res, refval, freeknd, d3e)
    val d3es = d3explst_arg_restore (d3es, s2es_arg, wths2es)
  in
    list_cons (d3e, d3es)
  end // end of [WTHS2EXPLSTcons_some]
| WTHS2EXPLSTcons_none
    (wths2es) => let
    val- list_cons (d3e, d3es) = d3es
    val- list_cons (s2e_arg, s2es_arg) = s2es_arg
    val d3es = d3explst_arg_restore (d3es, s2es_arg, wths2es)
  in
    list_cons (d3e, d3es)
  end // end of [WTHS2EXPLSTcons_none]
| WTHS2EXPLSTnil () => list_nil ()
//
end // end of [d3explst_arg_restore]

in // in of [local]

implement
d3explst_arg_restore
  (d3es, s2es, wths2es) =
  aux (d3es, s2es, wths2es)
// end of [d3explst_arg_restore]

end // end of [local]

(* ****** ****** *)

(* end of [pats_trans3_lvalres.dats] *)