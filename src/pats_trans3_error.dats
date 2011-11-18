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

staload _(*anon*) = "prelude/DATS/list_vt.dats"
staload _(*anon*) = "prelude/DATS/reference.dats"

(* ****** ****** *)

staload
ERR = "pats_error.sats"

(* ****** ****** *)

staload "pats_trans3.sats"

(* ****** ****** *)

viewtypedef
trans3errlst_vt = List_vt (trans3err)

(* ****** ****** *)

local

val the_trans3errlst = ref<trans3errlst_vt> (list_vt_nil)

fun the_trans3errlst_get
  (): trans3errlst_vt = let
  val (vbox pf | p) = ref_get_view_ptr (the_trans3errlst)
  val xs = !p
  val () = !p := list_vt_nil ()
in
  xs
end // end of [the_trans3errlst_get]

in // in of [local]

implement
the_trans3errlst_add (x) = () where {
  val (vbox pf | p) = ref_get_view_ptr (the_trans3errlst)
  val () = !p := list_vt_cons (x, !p)
} // end of [the_trans3errlst_add]

implement
the_trans3errlst_finalize () = {
  val xs = the_trans3errlst_get ()
  val n = list_vt_length (xs); val () = list_vt_free (xs)
// (*
  val () = if n > 0 then {
    val () = fprintf (stderr_ref, "TRANS3: there are [%i] errors in total.\n", @(n))
  } // end of [val]
// *)
  val () = if n > 0 then $ERR.abort () else ()
} // end of [the_trans3errlst_finalize]

end // end of [local]

(* ****** ****** *)

(* end of [pats_trans3_error.dats] *)