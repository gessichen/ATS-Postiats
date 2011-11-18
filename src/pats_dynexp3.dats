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
// Start Time: October, 2011
//
(* ****** ****** *)

staload "pats_staexp2.sats"
staload "pats_dynexp3.sats"

(* ****** ****** *)

implement
p3at_var (
  loc, s2f, knd, d2v
) = '{
  p3at_loc= loc
, p3at_node= P3Tvar (knd, d2v)
, p3at_type= s2f
} // end of [p3at_var]

implement
p3at_ann (
  loc, s2f, p3t, ann
) = '{
  p3at_loc= loc
, p3at_node= P3Tann (p3t, ann)
, p3at_type= s2f
} // end of [p3at_ann]

(* ****** ****** *)

implement
d3exp_var (
  loc, s2f, d2v
) = '{
  d3exp_loc= loc
, d3exp_type= s2f
, d3exp_node= D3Evar (d2v)
} // end of [d3exp_var]

(* ****** ****** *)

implement
d3exp_int
  (loc, s2f, rep, inf) = '{
  d3exp_loc= loc
, d3exp_type= s2f
, d3exp_node= D3Eint (rep, inf)
} // end of [d3exp_int]

implement
d3exp_bool
  (loc, s2f, b) = '{
  d3exp_loc= loc
, d3exp_type= s2f
, d3exp_node= D3Ebool (b)
} // end of [d3exp_bool]

implement
d3exp_char
  (loc, s2f, c) = '{
  d3exp_loc= loc
, d3exp_type= s2f
, d3exp_node= D3Echar (c)
} // end of [d3exp_char]

implement
d3exp_string
  (loc, s2f, str) = '{
  d3exp_loc= loc
, d3exp_type= s2f
, d3exp_node= D3Estring (str)
} // end of [d3exp_string]

implement
d3exp_float
  (loc, s2f, rep) = '{
  d3exp_loc= loc
, d3exp_type= s2f
, d3exp_node= D3Efloat (rep)
} // end of [d3exp_float]

(* ****** ****** *)

implement
d3exp_extval
  (loc, s2f, rep) = '{
  d3exp_loc= loc
, d3exp_type= s2f
, d3exp_node= D3Eextval (rep)
} // end of [d3exp_extval]

(* ****** ****** *)

implement
d3exp_cst (
  loc, s2f, d2c
) = '{
  d3exp_loc= loc
, d3exp_type= s2f
, d3exp_node= D3Ecst (d2c)
} // end of [d3exp_cst]

(* ****** ****** *)

implement
d3exp_lam_dyn (
  loc, s2f_fun, lin, npf, arg, body
) = '{
  d3exp_loc= loc
, d3exp_type= s2f_fun
, d3exp_node= D3Elam_dyn (lin, npf, arg, body)
} // end of [d3exp_lam_dyn]

implement
d3exp_laminit_dyn (
  loc, s2f_fun, lin, npf, arg, body
) = '{
  d3exp_loc= loc
, d3exp_type= s2f_fun
, d3exp_node= D3Elaminit_dyn (lin, npf, arg, body)
} // end of [d3exp_laminit_dyn]

(* ****** ****** *)

implement
f3undec_make
  (loc, d2v, d3e) = '{
  f3undec_loc= loc
, f3undec_var= d2v
, f3undec_def= d3e
} // end of [f3undec_make]

(* ****** ****** *)

implement
d3ecl_none (loc) = '{
  d3ecl_loc= loc, d3ecl_node= D3Cnone ()
} // end of [d3ecl_none]

implement
d3ecl_list (loc, xs) = '{
  d3ecl_loc= loc, d3ecl_node= D3Clist (xs)
} // end of [d3ecl_list]

(* ****** ****** *)

implement
d3ecl_valdecs (loc, knd, d3cs) = '{
  d3ecl_loc= loc, d3ecl_node= D3Cvaldecs (d3cs)
} // end of [d3ecl_valdecs]

(* ****** ****** *)

implement
d3ecl_fundecs (
  loc, funknd, decarg, d3cs
) = '{
  d3ecl_loc= loc
, d3ecl_node= D3Cfundecs (funknd, decarg, d3cs)
} // end of [d3ecl_fundecs]

(* ****** ****** *)

(* end of [pats_dynexp3.dats] *)