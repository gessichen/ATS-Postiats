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
// Start Time: September, 2012
//
(* ****** ****** *)

staload UT = "pats_utils.sats"
staload _(*anon*) = "pats_utils.dats"

(* ****** ****** *)

staload "pats_basics.sats"

(* ****** ****** *)

staload LAB = "pats_label.sats"

(* ****** ****** *)

staload SYN = "pats_syntax.sats"

(* ****** ****** *)

staload "pats_staexp2.sats"
staload "pats_dynexp2.sats"

(* ****** ****** *)

staload "pats_histaexp.sats"
staload "pats_hidynexp.sats"

(* ****** ****** *)

implement
fprint_hipat
  (out, x) = let
   macdef prstr (s) = fprint_string (out, ,(s))
in
//
case+ x.hipat_node of
//
| HIPany () => {
    val () = prstr "HIPany()"
  }
| HIPvar (d2v) => {
    val () = prstr "HIPvar("
    val () = fprint_d2var (out, d2v)
    val () = prstr ")"
  }
| HIPbool (b) => {
    val () = prstr "HIPbool("
    val () = fprint_bool (out, b)
    val () = prstr ")"
  }
| HIPchar (c) => {
    val () = prstr "HIPchar("
    val () = fprint_char (out, c)
    val () = prstr ")"
  }
| HIPstring (str) => {
    val () = prstr "HIPstring("
    val () = fprint_string (out, str)
    val () = prstr ")"
  }
//
| HIPann (hip, ann) => {
    val () = prstr "HIPann("
    val () = fprint_hipat (out, hip)
    val () = prstr " : "
    val () = fprint_hisexp (out, ann)
    val () = prstr ")"
  }
//
| _ => {
    val () = fprint_string (out, "HIP...(...)")
  } // end of [_]
//
end // end of [fprint_hipat]

(* ****** ****** *)

implement
fprint_hidexp
  (out, x) = let
  macdef prstr (s) = fprint_string (out, ,(s))
in
//
case+
  x.hidexp_node of
//
| HDEbool (b) => {
    val () = prstr "HDEbool("
    val () = fprint_bool (out, b)
    val () = prstr ")"
  }
| HDEchar (c) => {
    val () = prstr "HDEchar("
    val () = fprint_char (out, c)
    val () = prstr ")"
  }
| HDEstring (str) => {
    val () = prstr "HDEstring("
    val () = fprint_string (out, str)
    val () = prstr ")"
  }
//
| HDEi0nt (tok) => {
    val () = prstr "HDEi0nt("
    val () = $SYN.fprint_i0nt (out, tok)
    val () = prstr ")"
  }
| HDEf0loat (tok) => {
    val () = prstr "HDEf0loat("
    val () = $SYN.fprint_f0loat (out, tok)
    val () = prstr ")"
  }
//
| HDEextval (name) => {
    val () = prstr "HDEextval("
    val () = fprint_string (out, name)
    val () = prstr ")"
  }
//
| HDEapp (_, _fun, _arg) => {
    val () = prstr "HDEapp("
    val () = fprint_hidexp (out, _fun)
    val () = prstr "; "
    val () = fprint_hidexplst (out, _arg)
    val () = prstr ")"
  }
//
| HDEtmpcst (d2c, tmparg) => {
    val () = prstr "HDEtmpcst("
    val () = fprint_d2cst (out, d2c)
    val () = prstr "<"
    val () = $UT.fprintlst (out, tmparg, "><", fprint_hisexplst)
    val () = prstr ">"
    val () = prstr ")"
  }
| HDEtmpvar (d2v, tmparg) => {
    val () = prstr "HDEtmpvar("
    val () = fprint_d2var (out, d2v)
    val () = prstr "<"
    val () = $UT.fprintlst (out, tmparg, "><", fprint_hisexplst)
    val () = prstr ">"
    val () = prstr ")"
  }
//
| _ => {
    val () = fprint_string (out, "HDE...(...)")
  } // end of [_]
//
end // end of [fprint_hidexp]

(* ****** ****** *)

implement
fprint_hidexplst
  (out, xs) = $UT.fprintlst (out, xs, "; ", fprint_hidexp)
// end of [fprint_hidexplst]

(* ****** ****** *)

implement
fprint_hidecl
  (out, hid) = let
  macdef prstr (s) = fprint_string (out, ,(s))
in
//
case+ hid.hidecl_node of
//
| HIDvaldecs (knd, hvds) => {
    val () = prstr "HIDvaldecs(\n"
    val () = $UT.fprintlst (out, hvds, "\n", fprint_hivaldec)
    val () = prstr "\n)"
  } // end of [HIDvaldec]
| HIDvaldecs_rec (knd, hvds) => {
    val () = prstr "HIDvaldecs_rec(\n"
    val () = $UT.fprintlst (out, hvds, "\n", fprint_hivaldec)
    val () = prstr "\n)"
  } // end of [HIDvaldec_rec]
//
| _ => {
    val () = prstr "HID...(...)"
  } // end of [_]
//
end // end of [fprint_hivaldec]

(* ****** ****** *)

implement
fprint_hideclist
  (out, hids) = let
in
//
case+ hids of
| list_cons
    (hid, hids) => let
    val () =
      fprint_hidecl (out, hid)
    val () = fprint_newline (out)
  in
    fprint_hideclist (out, hids)
  end // end of [list_cons]
| list_nil () => ()
//
end // end of [fprint_hideclist]

(* ****** ****** *)

implement
fprint_hivaldec
  (out, hvd) = {
  val () = fprint_hipat (out, hvd.hivaldec_pat)
  val () = fprint_string (out, " = ")
  val () = fprint_hidexp (out, hvd.hivaldec_def)
} // end of [fprint_hivaldec]

(* ****** ****** *)

(* end of [pats_hidynexp_print.dats] *)