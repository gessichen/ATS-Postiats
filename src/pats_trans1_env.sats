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

staload FIX = "pats_fixity.sats"
typedef fxty = $FIX.fxty
staload SYM = "pats_symbol.sats"
typedef symbol = $SYM.symbol

(* ****** ****** *)

staload "pats_syntax.sats"
staload "pats_staexp1.sats"

(* ****** ****** *)

fun the_e1xpenv_add (id: symbol, e: e1xp): void
fun the_e1xpenv_find (id: symbol): Option_vt e1xp

(* ****** ******* *)

fun the_fxtyenv_add (key: symbol, itm: fxty): void
fun the_fxtyenv_find (key: symbol): Option_vt (fxty)

(* ****** ******* *)

fun fprint_the_fxtyenv (out: FILEref): void // mostly for debugging

(* ****** ****** *)

absview
trans1_level_v // for avoiding negative levels
fun trans1_level_get (): int
fun trans1_level_dec (pf: trans1_level_v | (*none*)): void
fun trans1_level_inc (): (trans1_level_v | void)

(* ****** ****** *)

absview trans1_env_push_v

fun trans1_env_pop
  (pf: trans1_env_push_v | (*none*)): void
fun trans1_env_push (): (trans1_env_push_v | void)

(*
** HX: for handling <local ... in ... end>
*)
fun trans1_env_localjoin (
  pf1: trans1_env_push_v, pf2: trans1_env_push_v | (*none*)
) : void // end of [trans1_env_localjoin]

(* ****** ******* *)

absview trans1_env_save_v
fun trans1_env_save ((*none*)): (trans1_env_save_v | void)
fun trans1_env_restore (pf: trans1_env_save_v | (*none*)): void

(* ****** ****** *)

(* end of [pats_trans1_env.sats] *)

