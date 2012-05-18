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

staload UN = "prelude/SATS/unsafe.sats"
staload _(*anon*) = "prelude/DATS/list.dats"
staload _(*anon*) = "prelude/DATS/list_vt.dats"

(* ****** ****** *)

staload "pats_errmsg.sats"
staload _(*anon*) = "pats_errmsg.dats"
implement prerr_FILENAME<> () = prerr "pats_trans3_patcon"

(* ****** ****** *)

staload LOC = "pats_location.sats"
typedef location = $LOC.location

(* ****** ****** *)

staload "pats_staexp2.sats"
staload "pats_staexp2_util.sats"
staload "pats_dynexp2.sats"
staload "pats_dynexp3.sats"

(* ****** ****** *)

staload SOL = "pats_staexp2_solve.sats"

(* ****** ****** *)

staload "pats_trans3.sats"
staload "pats_trans3_env.sats"

(* ****** ****** *)

local

fun auxck_free (
  loc0: location
, s2es: s2explst, nerr: int
) : int = let
in
//
case+ s2es of
| list_cons (s2e, s2es) => let
    val () = (
      print "auxck_free: s2e = "; print_s2exp (s2e); print_newline ()  
    ) // end of [val]
    var nerr: int = nerr
    val islin = s2exp_is_lin (s2e)
    val () = if islin then let
      val () = nerr := nerr + 1
      val () = prerr_error3_loc (loc0)
      val () = prerr ": [free@] operation cannot be performed"
      val () = prerr ": a linear component of the following type ["
      val () = prerr_s2exp (s2e)
      val () = prerr "] may be abandoned."
      val () = prerr_newline ()
    in
      // nothing
    end // end of [val]
  in
    auxck_free (loc0, s2es, nerr)
  end // end of [list_cons]
| list_nil () => nerr
//
end // end of [auxck_free]

fun auxfind (
  loc0: location, s2ls: s2explst
) : s2explst = (
  case+ s2ls of
  | list_cons (s2l, s2ls) => let
(*
      val () = (
        print "auxfind: s2l = ";
        print_s2exp (s2l); print_newline ()
      ) // end of [val]
*)
      val opt = pfobj_search_atview (s2l)
      val s2e_elt = (
        case+ opt of
        | ~Some_vt (pfobj) => let
            val ~PFOBJ (
              d2v, s2e_ctx, s2e_elt, _(*s2l*)
            ) = pfobj
            val s2e_out = s2exp_without (s2e_elt)
            val s2e = s2exp_hrepl (s2e_ctx, s2e_out)
            val () = d2var_set_type (d2v, Some (s2e))
          in
            s2e_elt
          end // end of [Some_vt]
        | ~None_vt () => s2exp_err (s2rt_t0ype)
      ) : s2exp // end of [val]
      val s2es_elt = auxfind (loc0, s2ls)
    in
      list_cons (s2e_elt, s2es_elt)
    end // end of [list_cons]
  | list_nil () => list_nil ()
) // end of [auxfind]

fun auxmain (
  loc0: location
, opknd: int // 0/1 free/fold
, s2as: s2exparglst, d2e: d2exp
) : d3exp = let
  val loc = d2e.d2exp_loc
  val d3e = d2exp_trup (d2e)
  val () = d3exp_open_and_add d3e
  val s2e_ptr = d3exp_get_type (d3e)
in
//
case
  s2e_ptr.s2exp_node of
| S2Edatconptr
    (d2c, _(*rt*), arg) => let
    val s2es_elt = auxfind (loc0, arg)
    val s2e_dcon = d2con_get_type (d2c)
    var err: int = 0
    val (s2e_dcon, s2ps) =
      s2exp_uni_instantiate_sexparglst (s2e_dcon, s2as, err)
    // end of [val]
    val () = trans3_env_add_proplst_vt (loc0, s2ps)
    val locarg = $LOC.location_leftmost (loc)
    val (s2e_dcon, s2ps) =
      s2exp_uni_instantiate_all (s2e_dcon, locarg, err)
    // HX: [err] is not used
    val () = trans3_env_add_proplst_vt (loc0, s2ps)
    val- S2Efun (
      fc, lin, s2fe, nof, s2es_arg, s2e_res
    ) = s2e_dcon.s2exp_node // end of [val]
//
    val () = if opknd = 0 then let
      val nerr = auxck_free (loc0, s2es_elt, 0(*nerr*))
    in
      if nerr > 0 then
        the_trans3errlst_add (T3E_d3exp_freeat (loc0, d3e))
      // end of [if]
    end // end of [val]
//
    val () = if opknd > 0 then let
      var err: int = 0
      val () =
        $SOL.s2explst_tyleq_solve_err (loc0, s2es_elt, s2es_arg, err)
      // end of [val]
    in
      if err > 0 then
        the_trans3errlst_add (T3E_d3exp_foldat (loc0, d3e))
      // end of [if]
    end // end of [val]
    val () = if opknd > 0 then let
      var err: int = 0
      val () =
        d3lval_set_type_err (0(*refval*), d3e, s2e_res, err)
      // end of [val]
    in
      if err > 0 then let
        val () = prerr_error3_loc (loc)
        val () = prerr ": [fold@] operation cannot be formed"
        val () = prerr ":  the type of the dynamic expression cannot be changed."
        val () = prerr_newline ()
      in
        the_trans3errlst_add (T3E_d3exp_foldat (loc0, d3e))
      end (* end of [if] *)
    end // end of [val]
  in
    d3e
  end // end of [S2Edatconptr]
| _ => let
    val () = prerr_error3_loc (loc)
    val () = if opknd = 0 then
      prerr ": [free@] operation cannot be performed"
    val () = if opknd > 0 then
      prerr ": [fold@] operation cannot be performed"
    val () = prerr ": unfolded datatype constructor is expected."
    val () = prerr_newline ()
  in
    d3exp_err (loc0)
  end // end of [_]
//
end // end of [auxmain]

in // in of [local]

implement
d2exp_trup_foldat (d2e0) = let
  val loc0 = d2e0.d2exp_loc
  val- D2Efoldat (s2as, d2e) = d2e0.d2exp_node
  val d3e = auxmain (loc0, 1(*opknd*), s2as, d2e)
in
  d3exp_foldat (loc0, d3e)
end // end of [d2exp_trup_foldat]

implement
d2exp_trup_freeat (d2e0) = let
  val loc0 = d2e0.d2exp_loc
  val- D2Efreeat (s2as, d2e) = d2e0.d2exp_node
  val d3e = auxmain (loc0, 0(*opknd*), s2as, d2e)
in
  d3exp_freeat (loc0, d3e)
end // end of [d2exp_trup_freeat]

end // end of [local]

(* ****** ****** *)

(* end of [pats_trans3_fldfrat.dats] *)