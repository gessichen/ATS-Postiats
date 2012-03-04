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
** the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by the
** Free Software Foundation; either version 2.1, or (at your option)  any
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
// Author of the file: Hongwei Xi (hwxi AT cs DOT bu DOT edu)
// Start Time: February, 2012
//
(* ****** ****** *)

implement
add_bool_bool
  (x1, x2) = if x1 then true else x2
// end of [add_bool_bool]

implement
mul_bool_bool
  (x1, x2) = if x1 then x2 else false
// end of [mul_bool_bool]

(* ****** ****** *)

implement
lt_bool_bool (x1, x2) = if x1 then false else x2
implement
lte_bool_bool (x1, x2) = if x1 then x2 else true
implement
gt_bool_bool (x1, x2) = if x2 then false else x1
implement
gte_bool_bool (x1, x2) = if x2 then x1 else true

implement
eq_bool_bool (x1, x2) = if x1 then x2 else ~x2
implement
neq_bool_bool (x1, x2) = if x1 then ~x2 else x1

implement
compare_bool_bool
  (x1, x2) = int_of_bool(x1) - int_of_bool(x2)
// end of [compare_bool_bool]

(* ****** ****** *)

(* end of [bool.dats] *)