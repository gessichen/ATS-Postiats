
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
// Start Time: February, 2012
//
(* ****** ****** *)

staload UN = "prelude/SATS/unsafe.sats"
staload _(*anon*) = "prelude/DATS/list_vt.dats"

(* ****** ****** *)

staload "pats_basics.sats"

(* ****** ****** *)

staload ERR = "pats_error.sats"

(* ****** ****** *)

staload "pats_errmsg.sats"
staload _(*anon*) = "pats_errmsg.dats"
implement prerr_FILENAME<> () = prerr "pats_constraint3_solve"

(* ****** ****** *)

staload "pats_staexp2.sats"
staload "pats_trans3_env.sats"

(* ****** ****** *)

staload "pats_lintprgm.sats"
staload "pats_constraint3.sats"

(* ****** ****** *)

local
#include "pats_lintprgm_myint_int.dats"
in (*nothing*) end

(* ****** ****** *)

local

staload _(*anon*) =
"pats_lintprgm.dats"
staload _(*anon*) =
"pats_lintprgm_solve.dats"
staload _(*anon*) =
"pats_constraint3_icnstr.dats"

fun{a:t@ype}
indexset_make_s3exp {n:nat} (
  vim: !s2varindmap (n), s3e: s3exp
) : indexset (n+1) = let
  typedef res = indexset (n+1)
  viewtypedef map = s2varindmap (n)
  fun loop (
    s2vs: s2varlst_vt, vim: !map, res: res
  ) : res =
    case+ s2vs of
    | ~list_vt_cons
        (s2v, s2vs) => let
        val ind = s2varindmap_find (vim, s2v)
        val res = (
          if ind > 0 then indexset_add (res, ind) else res
        ) : res // end of [val]
      in
        loop (s2vs, vim, res)
      end // end of [list_vt_cons]
    | ~list_vt_nil () => res
  // end of [loop]
  val s2vs = s3exp_get_fvs (s3e)
  val s2vs = s2varset_vt_listize_free (s2vs)
in
  loop (s2vs, vim, indexset_nil ())
end // end of [indexset_make_s3exp]

fun{a:t@ype}
auxsolve {n:nat} (
  loc0: location
, vim: !s2varindmap (n), n: int n
, s3ps_asmp: s3explst, s3p_conc: s3exp
) : int(*~1/0*) = let
//
// HX: note that the order is reversed:
//
val ics_asmp = let
  viewtypedef res = icnstrlst (a, n+1)
  fun loop (
    loc0: location
  , vim: !s2varindmap (n), n: int n, s3ps: s3explst
  , res: res
  ) : res =
    case+ s3ps of
    | list_cons (s3p, s3ps) => let
        val ic =
          s3exp2icnstr<a> (loc0, vim, n, s3p)
        // end ofl[val]
(*
        val () = (
          print "auxsolve: loop: s3p = ";
          print_s3exp (s3p); print_newline ();
          print "auxsolve: loop: ic = ";
          fprint_icnstr (stdout_ref, ic, n+1);
          print_newline ();
        ) // end of [val]
*)
      in
        loop (loc0, vim, n, s3ps, list_vt_cons (ic, res))
      end // end of [list_cons]
    | list_nil () => res
  // end of [loop]
in
  loop (loc0, vim, n, s3ps_asmp, list_vt_nil)
end // end of [val]
val ic_conc = s3exp2icnstr<a> (loc0, vim, n, s3p_conc)
val ic_conc = icnstr_negate<a> (ic_conc)
//
val iset = indexset_make_s3exp (vim, s3p_conc)
var ics_all
  : icnstrlst (a, n+1) = list_vt_cons (ic_conc, ics_asmp)
val ans = icnstrlst_solve<a> (iset, ics_all, n+1)
val () = icnstrlst_free<a> (ics_all, n+1)
//
in
//
ans // ~1: contradiction reached; 0: undecided yet
//
end // end of [auxsolve]

in // in of [local]

implement
s3explst_solve_s2exp
  (loc0, env, s2p, err) = let
//
val s3p = s3exp_make (env, s2p)
val s3p = (
  case+ s3p of
  | S3Eerr _ => let
      val () = prerr_warning3_loc (loc0)
      val () = prerr ": the constraint ["
      val () = pprerr_s2exp (s2p)
      val () = prerr "] cannot be translated into a form accepted by the constraint solver."
      val () = prerr_newline ()
    in
      s3exp_false // HX: make it the worst scenario
    end // end of [S3Eerr]
  | _ => s3p // end of [_]
) : s3exp // end of [val]
//
var status: int = 0
val () = (
  case+ s3p of
  | S3Ebool (true) => status := ~1
  | _ => ()
) // end of [val]
//
val () = if status >= 0 then {
val s3p_conc =
  s3exp_lintize (env, s3p) // HX: processed for being turned into a vector
//
val (s2vs, s3ps) = s2vbcfenv_extract (env)
val s3ps_asmp =
  $UN.castvwtp1 {s3explst} (s3ps) // HX: cannot be SHARED!
//
// (*
val () = begin
  print "s3explst_solve_s2exp: s2vs = ";
  print_s2varlst ($UN.castvwtp1 {s2varlst} (s2vs)); print_newline ();
  print "s3explst_solve_s2exp: s3ps = ";
  print_s3explst (s3ps_asmp); print_newline ();
  print "s3explst_solve_s2exp: s2p = "; pprint_s2exp (s2p); print_newline ();
  print "s3explst_solve_s2exp: s3p = "; print_s3exp (s3p); print_newline ();
end // end of [val]
// *)
//
val (vim, n) =
  s2varindmap_make (s2vs)
val ans = auxsolve<int> (loc0, vim, n, s3ps_asmp, s3p_conc)
val () = s2varindmap_free (vim)
val () = list_vt_free (s2vs) and () = list_vt_free (s3ps)
val () = status := ans
} (* end of [status >= 0] *)
//
(*
val () = (
  print "s3explst_solve_s2exp: status = "; print status; print_newline ()
) // end of [val]
*)
//
in
  status(*~1/0*)
end // end of [s3explst_solve_s2exp]

end // end of [local]

(* ****** ****** *)
//
// HX-2012-03:
// for errmsg reporting; the function returns 0
// normally; if it returns 1, then the reported
// error should be treated as a warning instead.
//
extern fun
c3nstr_solve_errmsg (c3t: c3nstr, unsolved: uint): int
//
(* ****** ****** *)

extern fun
c3nstr_solve_main (
  env: &s2vbcfenv, c3t: c3nstr, unsolved: &uint, err: &int
) : int(*status*)
// end of [c3nstr_solve_main]

extern fun
c3nstr_solve_prop (
  loc0: location, env: &s2vbcfenv, s2p: s2exp, err: &int
) : int(*status*)
// end of [c3nstr_solve_prop]

extern fun
c3nstr_solve_itmlst (
  loc0: location
, env: &s2vbcfenv, s3is: s3itmlst, unsolved: &uint, err: &int
) : int(*status*)
// end of [c3nstr_solve_itmlst]

extern fun
c3nstr_solve_itmlst_disj (
  loc0: location
, env: &s2vbcfenv
, s3is: s3itmlst, s3iss: s3itmlstlst, unsolved: &uint, err: &int
) : int(*status*)
// end of [c3nstr_solve_itmlst_disj]

(* ****** ****** *)

implement
c3nstr_solve_errmsg
  (c3t, unsolved) = let
//
val loc0 = c3t.c3nstr_loc
val c3tknd = c3t.c3nstr_kind
//
fn prerr_c3nstr_if (
  unsolved: uint, c3t: c3nstr
) : void =
  if (unsolved = 0u) then (prerr ": "; prerr_c3nstr c3t)
// end of [prerr_c3nstr_if]
//
in
//
case+ c3tknd of
| C3NSTRKINDmain () => (
    if unsolved > 0u then (
      0 // errmsg reporting has already be done
    ) else (
      prerr_error3_loc (loc0);
      prerr ": unsolved constraint";
      prerr_c3nstr (c3t);
      prerr_newline ();
      0 // it is treated as an error
    ) (* end of [if] *)
  ) // end of [C3STRKINDnone]
| C3NSTRKINDcase_exhaustiveness
    (casknd, p2tcs) => let
(*
    val () = pattern_match_exhaustiveness_msg (loc0, casknd, p2tcs)
*)
  in
    case+ casknd of
    | CK_case () => 1 (*warning*)
    | CK_case_pos () => 0 (*error*)
    | CK_case_neg () => 0 (*deadcode*)
  end // end of [C3NSTRKINDcase_exhaustiveness]
| C3NSTRKINDtermet_isnat
    () => 0 where {
    val () = prerr_error3_loc (loc0)
    val () = prerr ": unsolved constraint for termination metric being welfounded"
    val () = prerr_c3nstr_if (unsolved, c3t)
    val () = prerr_newline ()
  } // end of [C3NSTRKINDtermet_isnat]
| C3NSTRKINDtermet_isdec
    () => 0 where {
    val () = prerr_error3_loc (loc0)
    val () = prerr ": unsolved constraint for termination metric being decreasing"
    val () = prerr_c3nstr_if (unsolved, c3t)
    val () = prerr_newline ()
  } // end of [C3STRKINDmetric_dec]
//
end // end of [c3nstr_solve_errmsg]

(* ****** ****** *)

implement
c3nstr_solve_main
  (env, c3t, unsolved, err) = let
//
val loc0 = c3t.c3nstr_loc
(*
val () = begin
  print "c3nstr_solve_main: c3t = "; print_c3nstr (c3t); print_newline ();
end // end of [val]
*)
//
var status: int = (
//
// ~1: solved; 0: unsolved
//
  case+ c3t.c3nstr_node of
  | C3NSTRprop s2p =>
      c3nstr_solve_prop (loc0, env, s2p, err)
  | C3NSTRitmlst s3is =>
      c3nstr_solve_itmlst (loc0, env, s3is, unsolved, err)
) : int // end of [val]
//
val () = if status >= 0 then {
  val iswarn =
    c3nstr_solve_errmsg (c3t, unsolved)
  // end of [val]
  val () = if iswarn > 0 then (status := ~1)
} // end of [val]
//
(*
val () = begin
  print "c3nstr_solve_main: status = "; print status; print_newline ()
end // end of [val]
*)
//
val () = if status >= 0 then (unsolved := unsolved + 1u)
//
in
  status (* 0: unsolved; ~1: solved *)
end // end of [c3nstr_solve_main]

(* ****** ****** *)

implement
c3nstr_solve_prop
  (loc0, env, s2p, err) = let
(*
  val () = begin
    print "c3nstr_solve_prop: s2vs = ";
    print_s2varlst (s2vs); print_newline ();
    print "c3nstr_solve_prop: s3ps = ";
    print_s3explst (s3ps); print_newline ();
    print "c3nstr_solve_prop: s2p = ";
    pprint_s2exp (s2p); print_newline ();
  end // end of [val]
*)
in
  s3explst_solve_s2exp (loc0, env, s2p, err)
end // end of [c3nstr_solve_prop]

(* ****** ****** *)

implement
c3nstr_solve_itmlst (
  loc0, env, s3is, unsolved, err
) = let
(*
val () = begin
  print "c3str_solve_itmlst: s3is = ";
  fprint_s3itmlst (stdout_ref, s3is); print_newline ();
end // end of [val]
*)
in
//
case+ s3is of
| list_cons (s3i, s3is) => (
  case+ s3i of
  | S3ITMcnstr c3t => let
      val (pf1 | ()) = s2vbcfenv_push (env)
      val (pf2 | ()) = the_s2varbindmap_push ()
      val ans1 =
        c3nstr_solve_main (env, c3t, unsolved, err)
      // end of [val]
      val () = the_s2varbindmap_pop (pf2 | (*none*))
      val () = s2vbcfenv_pop (pf1 | env)
      val ans2 =
        c3nstr_solve_itmlst (loc0, env, s3is, unsolved, err)
      // end of [val]
    in
      if ans1 >= 0 then 0(*unsolved*) else ans2
    end // end of [S3ITMcnstr]
  | S3ITMhypo (h3p) => let
      val s3p = s3exp_make_h3ypo (env, h3p)
      val () = (
        case+ s3p of
        | S3Eerr _ => let
            val () = begin
              prerr_warning3_loc (loc0);
              prerr ": unused hypothesis: ["; prerr_h3ypo (h3p); prerr "]";
              prerr_newline ()
            end // end of [val]
          in
            // nothing
          end // end of [S3Eerr]
        | _ => let
            val s3p = s3exp_lintize (env, s3p) in s2vbcfenv_add_sbexp (env, s3p)
          end // end of [_]
      ) : void // end of [val]
    in
      c3nstr_solve_itmlst (loc0, env, s3is, unsolved, err)
    end // end of [S3ITMhypo]
  | S3ITMdisj (s3iss_disj) =>
      c3nstr_solve_itmlst_disj (loc0, env, s3is, s3iss_disj, unsolved, err)
  | S3ITMsvar (s2v) => let
      val () = s2vbcfenv_add_svar (env, s2v)
    in
      c3nstr_solve_itmlst (loc0, env, s3is, unsolved, err)
    end // end of [S3ITMsvar]
  | S3ITMsVar (s2V) =>
      c3nstr_solve_itmlst (loc0, env, s3is, unsolved, err)
  ) // end of [list_cons]
| list_nil () => ~1(*solved*)
//
end // end of [c3nstr_solve_itmlst]

(* ****** ****** *)

implement
c3nstr_solve_itmlst_disj (
  loc0, env, s3is0, s3iss(*disj*), unsolved, err
) = let
// (*
val () = (
  print "c3nstr_solve_itmlst_disj: s3iss = ..."; print_newline ()
) // end of [val]
// *)
in
//
case+ s3iss of
| list_cons (s3is, s3iss) => let
    val (pf1 | ()) = s2vbcfenv_push (env)
    val (pf2 | ()) = the_s2varbindmap_push ()
    val s3is1 = list_append (s3is, s3is0)
    val ans = c3nstr_solve_itmlst (loc0, env, s3is1, unsolved, err)
    val () = the_s2varbindmap_pop (pf2 | (*none*))
    val () = s2vbcfenv_pop (pf1 |env)
  in
    c3nstr_solve_itmlst_disj (loc0, env, s3is0, s3iss, unsolved, err)
  end // end of [list_cons]
| list_nil () => ~1(*solved*)
//
end // end of [c3nstr_solve_itmlst_disj]

(* ****** ****** *)

implement
c3nstr_solve (c3t) = let
(*
  val () = begin
    print "c3nstr_solve: c3t = "; print c3t; print_newline ()
  end // end of [val]
*)
  var env: s2vbcfenv = s2vbcfenv_nil ()
//
// HX-2010-09-09: this is needed for solving top-level constraints!!!
  val () = the_s2varbindmap_freetop ()
//
  var unsolved: uint = 0u and err: int = 0
  val _(*status*) = c3nstr_solve_main (env, c3t, unsolved, err)
  val () = s2vbcfenv_free (env)
in
//
case+ 0 of
| _ when unsolved = 0u => let
    val () = (
      prerr "typechecking is finished successfully!"; prerr_newline ()
    ) // end of [val]
  in
    // nothing
  end // end of [unsolved = 0]
| _ => { // unsolved > 0
    val () = prerr "type-checking has failed"
    val () = if unsolved <= 1u then
      prerr ": there is one unsolved constraint"
    val () = if unsolved >= 2u then
      prerr ": there are some unsolved constraints"
    val () = (
      prerr ": please inspect the above reported error message(s) for information."
    ) // end of [val]
    val () = prerr_newline ()
    val () = $ERR.abort {void} ()
  } // end of [_]
//
end // end of [c3nstr_solve]

(* ****** ****** *)

(* end of [pats_constraint3_solve.dats] *)