/*
**
** The C code is generated by ATS/Anairiats
** The compilation time is: 2013-8-30: 14h:38m
**
*/

/* include some .h files */
#ifndef _ATS_HEADER_NONE
#include "ats_config.h"
#include "ats_basics.h"
#include "ats_types.h"
#include "ats_exception.h"
#include "ats_memory.h"
#endif /* _ATS_HEADER_NONE */

/* include some .cats files */
#ifndef _ATS_PRELUDE_NONE
#include "prelude/CATS/basics.cats"
#include "prelude/CATS/bool.cats"
#include "prelude/CATS/char.cats"
#include "prelude/CATS/byte.cats"
#include "prelude/CATS/float.cats"
#include "prelude/CATS/integer.cats"
#include "prelude/CATS/integer_ptr.cats"
#include "prelude/CATS/integer_fixed.cats"
#include "prelude/CATS/sizetype.cats"
#include "prelude/CATS/pointer.cats"
#include "prelude/CATS/reference.cats"
#include "prelude/CATS/string.cats"
#include "prelude/CATS/lazy.cats"
#include "prelude/CATS/lazy_vt.cats"
#include "prelude/CATS/printf.cats"
#include "prelude/CATS/list.cats"
#include "prelude/CATS/option.cats"
#include "prelude/CATS/array.cats"
#include "prelude/CATS/matrix.cats"
#endif /* _ATS_PRELUDE_NONE */
/* prologues from statically loaded files */

/* external codes at top */
#line 162 "gcats1_autops.dats"


static inline
ats_void_type
gc_aut_calloc_bsz_memset_bsz
  (ats_ptr_type p, ats_int_type c, ats_int_type bsz) {
  memset (p, c, bsz) ; return ;
}

#line 305 "gcats1_autops.dats"


static inline
ats_void_type gc_aut_realloc_wsz_memcpy_wsz
  (ats_ptr_type p_dest, ats_ptr_type p_src, ats_int_type wsz) {
  memcpy (p_dest, p_src, wsz << NBYTE_PER_WORD_LOG) ;
  return ;
}


/* type definitions */
/* external typedefs */
/* external dynamic constructor declarations */
/* external dynamic constant declarations */
ATSextern_fun(ats_void_type, atspre_assert) (ats_bool_type) ;
ATSextern_fun(ats_void_type, atspre_prerr_newline) () ;
ATSextern_fun(ats_int_type, atspre_add_int_int) (ats_int_type, ats_int_type) ;
ATSextern_fun(ats_int_type, atspre_sub_int_int) (ats_int_type, ats_int_type) ;
ATSextern_fun(ats_int_type, atspre_mul_int_int) (ats_int_type, ats_int_type) ;
ATSextern_fun(ats_bool_type, atspre_lte_int_int) (ats_int_type, ats_int_type) ;
ATSextern_fun(ats_bool_type, atspre_gt_int_int) (ats_int_type, ats_int_type) ;
ATSextern_fun(ats_bool_type, atspre_eq_int_int) (ats_int_type, ats_int_type) ;
ATSextern_fun(ats_int_type, atspre_asl_int_int1) (ats_int_type, ats_int_type) ;
ATSextern_fun(ats_int_type, atspre_asr_int_int1) (ats_int_type, ats_int_type) ;
ATSextern_fun(ats_int_type, atspre_isub) (ats_int_type, ats_int_type) ;
ATSextern_fun(ats_bool_type, atspre_ilte) (ats_int_type, ats_int_type) ;
ATSextern_fun(ats_bool_type, atspre_igte) (ats_int_type, ats_int_type) ;
ATSextern_fun(ats_void_type, atspre_prerr_ptr) (ats_ptr_type) ;
ATSextern_fun(ats_void_type, atspre_prerr_string) (ats_ptr_type) ;
ATSextern_fun(ats_ptr_type, freeitmlst2ptr) (ats_ptr_type) ;
ATSextern_fun(ats_void_type, gc_main_lock_acquire) () ;
ATSextern_fun(ats_void_type, gc_main_lock_release) () ;
ATSextern_fun(ats_void_type, the_globalentrylst_lock_acquire) () ;
ATSextern_fun(ats_void_type, the_globalentrylst_lock_release) () ;
ATSextern_fun(ats_void_type, the_manmemlst_lock_acquire) () ;
ATSextern_fun(ats_void_type, the_manmemlst_lock_release) () ;
ATSextern_fun(ats_void_type, the_threadinfolst_lock_acquire) () ;
ATSextern_fun(ats_void_type, the_threadinfolst_lock_release) () ;
ATSextern_fun(ats_void_type, the_sweeplst_lock_acquire_all) () ;
ATSextern_fun(ats_void_type, the_sweeplst_lock_release_all) () ;
ATSextern_fun(ats_bool_type, freeitmlst_is_nil) (ats_ptr_type) ;
ATSextern_fun(ats_ptr_type, freeitmlst_tail_get) (ats_ptr_type) ;
ATSextern_fun(ats_ptr_type, the_freeitmlst_array_get) (ats_int_type) ;
ATSextern_fun(ats_void_type, the_freeitmlst_array_set) (ats_int_type, ats_ptr_type) ;
ATSextern_fun(ats_void_type, the_freeitmlst_array_insert_at) (ats_ptr_type, ats_int_type) ;
ATSextern_fun(ats_bool_type, chunklst_is_cons) (ats_ptr_type) ;
ATSextern_fun(ats_int_type, chunklst_itemwsz_get) (ats_ptr_type) ;
ATSextern_fun(ats_int_type, chunklst_itemwsz_log_get) (ats_ptr_type) ;
ATSextern_fun(ats_int_type, chunklst_itemtot_get) (ats_ptr_type) ;
ATSextern_fun(ats_ptr_type, chunklst_data_get) (ats_ptr_type) ;
ATSextern_fun(ats_ptr_type, chunklst_create) (ats_int_type, ats_int_type) ;
ATSextern_fun(ats_void_type, chunklst_destroy) (ats_ptr_type) ;
ATSextern_fun(ats_bool_type, the_chunk_count_limit_is_reached_within) (ats_int_type) ;
ATSextern_fun(ats_uintptr1_type, PTR_TOPSEG_GET) (ats_ptr_type) ;
ATSextern_fun(ats_int_type, PTR_BOTSEG_GET) (ats_ptr_type) ;
ATSextern_fun(ats_bool_type, botsegtbllst_is_cons) (ats_ptr_type) ;
ATSextern_fun(ats_ptr_type, botsegtbllst_get) (ats_ptr_type, ats_int_type) ;
ATSextern_fun(ats_ptr_type, ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_2esats__the_topsegtbl_get) (ats_uintptr1_type) ;
ATSextern_fun(ats_void_type, gc_collect) () ;
ATSextern_fun(ats_ptr_type, ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_2esats__gc_freeitmlst_generate) (ats_int_type) ;
ATSextern_fun(ats_ptr_type, gc_aut_malloc_bsz) (ats_int_type) ;
ATSextern_fun(ats_ptr_type, gc_aut_malloc_wsz) (ats_int_type) ;
ATSextern_fun(ats_ptr_type, ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_2esats__gc_aut_realloc_wsz) (ats_ptr_type, ats_int_type) ;
ATSextern_fun(ats_int_type, log2_ceil) (ats_int_type) ;
ATSextern_fun(ats_ptr_type, gc_aut_calloc_bsz) (ats_int_type, ats_int_type) ;
ATSextern_fun(ats_void_type, gc_aut_calloc_bsz_memset_bsz) (ats_ptr_type, ats_int_type, ats_int_type) ;
ATSextern_fun(ats_void_type, gc_aut_realloc_wsz_memcpy_wsz) (ats_ptr_type, ats_ptr_type, ats_int_type) ;

/* external dynamic terminating constant declarations */
#ifdef _ATS_PROOFCHECK
#endif /* _ATS_PROOFCHECK */

/* assuming abstract types */
/* sum constructor declarations */
/* exn constructor declarations */
/* global dynamic (non-functional) constant declarations */
/* internal function declarations */
static
ats_void_type gcats1_autops_gc_aut_free_chunk_3 (ats_ptr_type arg0, ats_ptr_type arg1) ;
static
ats_void_type gcats1_autops_err_botsegtbl_5 (ats_ptr_type arg0) ;
static
ats_void_type gcats1_autops_err_chunk_6 (ats_ptr_type arg0) ;
static
ats_ptr_type gcats1_autops_err_9 (ats_ptr_type arg0) ;
static
ats_ptr_type gcats1_autops_aux_main_10 (ats_ptr_type arg0, ats_ptr_type arg1, ats_int_type arg2) ;

/* partial value template declarations */
/* static temporary variable declarations */
/* external value variable declarations */

/* function implementations */

/*
// /home/hwxi/research/Anairiats/ccomp/runtime/GCATS1/gcats1_autops.dats: 1738(line=53, offs=29) -- 1844(line=57, offs=4)
*/
ATSglobaldec()
ats_ptr_type
gc_aut_malloc_bsz (ats_int_type arg0) {
/* local vardec */
ATSlocal (ats_ptr_type, tmp0) ;
ATSlocal (ats_int_type, tmp1) ;
ATSlocal (ats_int_type, tmp2) ;
ATSlocal (ats_int_type, tmp3) ;

__ats_lab_gc_aut_malloc_bsz:
#line 54 "gcats1_autops.dats"
tmp3 = atspre_isub (8, 1) ;
#line 54 "gcats1_autops.dats"
tmp2 = atspre_add_int_int (arg0, tmp3) ;
#line 54 "gcats1_autops.dats"
tmp1 = atspre_asr_int_int1 (tmp2, 3) ;
#line 56 "gcats1_autops.dats"
tmp0 = gc_aut_malloc_wsz (tmp1) ;
return (tmp0) ;
} /* end of [gc_aut_malloc_bsz] */

/*
// /home/hwxi/research/Anairiats/ccomp/runtime/GCATS1/gcats1_autops.dats: 1954(line=61, offs=29) -- 5420(line=153, offs=4)
*/
ATSglobaldec()
ats_ptr_type
gc_aut_malloc_wsz (ats_int_type arg0) {
/* local vardec */
ATSlocal (ats_ptr_type, tmp4) ;
ATSlocal (ats_int_type, tmp5) ;
ATSlocal (ats_bool_type, tmp6) ;
ATSlocal (ats_int_type, tmp7) ;
ATSlocal (ats_bool_type, tmp8) ;
// ATSlocal_void (tmp9) ;
ATSlocal (ats_bool_type, tmp10) ;
ATSlocal (ats_ptr_type, tmp11) ;
ATSlocal (ats_ptr_type, tmp12) ;
ATSlocal (ats_bool_type, tmp13) ;
ATSlocal (ats_ptr_type, tmp14) ;
ATSlocal (ats_ptr_type, tmp15) ;
// ATSlocal_void (tmp16) ;
// ATSlocal_void (tmp17) ;
ATSlocal (ats_bool_type, tmp18) ;
ATSlocal (ats_int_type, tmp19) ;
// ATSlocal_void (tmp20) ;
// ATSlocal_void (tmp21) ;
ATSlocal (ats_int_type, tmp22) ;
ATSlocal (ats_int_type, tmp23) ;
ATSlocal (ats_int_type, tmp24) ;
ATSlocal (ats_int_type, tmp25) ;
// ATSlocal_void (tmp26) ;
// ATSlocal_void (tmp27) ;
ATSlocal (ats_bool_type, tmp28) ;
// ATSlocal_void (tmp29) ;
// ATSlocal_void (tmp30) ;
// ATSlocal_void (tmp31) ;
// ATSlocal_void (tmp32) ;
// ATSlocal_void (tmp33) ;
// ATSlocal_void (tmp34) ;
// ATSlocal_void (tmp35) ;
// ATSlocal_void (tmp36) ;
// ATSlocal_void (tmp37) ;
// ATSlocal_void (tmp38) ;
// ATSlocal_void (tmp39) ;
// ATSlocal_void (tmp40) ;
// ATSlocal_void (tmp41) ;
ATSlocal (ats_ptr_type, tmp42) ;
// ATSlocal_void (tmp43) ;
ATSlocal (ats_ptr_type, tmp44) ;

__ats_lab_gc_aut_malloc_wsz:
#line 68 "gcats1_autops.dats"
tmp7 = atspre_asl_int_int1 (1, 11) ;
#line 68 "gcats1_autops.dats"
tmp6 = atspre_gt_int_int (arg0, tmp7) ;
#line 68 "gcats1_autops.dats"
if (tmp6) {
#line 68 "gcats1_autops.dats"
tmp5 = -1 ;
} else {
#line 68 "gcats1_autops.dats"
tmp5 = log2_ceil (arg0) ;
} /* end of [if] */
#line 71 "gcats1_autops.dats"
do {
/* branch: __ats_lab_0 */
#line 72 "gcats1_autops.dats"
__ats_lab_0_0:
#line 72 "gcats1_autops.dats"
__ats_lab_0_1:
#line 72 "gcats1_autops.dats"
tmp8 = atspre_igte (tmp5, 0) ;
#line 72 "gcats1_autops.dats"
if (!tmp8) { goto __ats_lab_1_1 ; }
#line 74 "gcats1_autops.dats"
tmp10 = atspre_ilte (tmp5, 11) ;
#line 73 "gcats1_autops.dats"
/* tmp9 = */ atspre_assert (tmp10) ;
#line 75 "gcats1_autops.dats"
tmp11 = the_freeitmlst_array_get (tmp5) ;
#line 77 "gcats1_autops.dats"
tmp13 = freeitmlst_is_nil (tmp11) ;
#line 77 "gcats1_autops.dats"
if (tmp13) {
#line 77 "gcats1_autops.dats"
tmp12 = ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_2esats__gc_freeitmlst_generate (tmp5) ;
} else {
#line 78 "gcats1_autops.dats"
tmp12 = tmp11 ;
} /* end of [if] */
#line 80 "gcats1_autops.dats"
tmp14 = freeitmlst2ptr (tmp12) ;
#line 94 "gcats1_autops.dats"
tmp15 = freeitmlst_tail_get (tmp12) ;
#line 95 "gcats1_autops.dats"
/* tmp16 = */ the_freeitmlst_array_set (tmp5, tmp15) ;
#line 108 "gcats1_autops.dats"
tmp4 = tmp14 ;
break ;

/* branch: __ats_lab_1 */
#line 110 "gcats1_autops.dats"
__ats_lab_1_0:
#line 110 "gcats1_autops.dats"
__ats_lab_1_1:
#line 113 "gcats1_autops.dats"
tmp19 = atspre_asl_int_int1 (1, 30) ;
#line 113 "gcats1_autops.dats"
tmp18 = atspre_gt_int_int (arg0, tmp19) ;
#line 113 "gcats1_autops.dats"
if (tmp18) {
#line 115 "gcats1_autops.dats"
/* tmp20 = */ atspre_prerr_string (ATSstrcst("[gc_aut_malloc_wsz]: argument is too large!")) ;
#line 115 "gcats1_autops.dats"
/* tmp21 = */ atspre_prerr_newline () ;
#line 118 "gcats1_autops.dats"
/* tmp17 = */ ats_exit (1) ;
} else {
/* empty */
} /* end of [if] */
#line 120 "gcats1_autops.dats"
tmp25 = atspre_asl_int_int1 (1, 11) ;
#line 120 "gcats1_autops.dats"
tmp24 = atspre_sub_int_int (tmp25, 1) ;
#line 120 "gcats1_autops.dats"
tmp23 = atspre_add_int_int (arg0, tmp24) ;
#line 120 "gcats1_autops.dats"
tmp22 = atspre_asr_int_int1 (tmp23, 11) ;
#line 121 "gcats1_autops.dats"
/* tmp26 = */ gc_main_lock_acquire () ;
#line 121 "gcats1_autops.dats"
/* tmp27 = ats_selsin_mac(tmp26, atslab_1) */ ;
#line 123 "gcats1_autops.dats"
tmp28 = the_chunk_count_limit_is_reached_within (tmp22) ;
#line 126 "gcats1_autops.dats"
if (tmp28) {
#line 127 "gcats1_autops.dats"
/* tmp30 = */ the_globalentrylst_lock_acquire () ;
#line 127 "gcats1_autops.dats"
/* tmp31 = ats_selsin_mac(tmp30, atslab_1) */ ;
#line 128 "gcats1_autops.dats"
/* tmp32 = */ the_manmemlst_lock_acquire () ;
#line 128 "gcats1_autops.dats"
/* tmp33 = ats_selsin_mac(tmp32, atslab_1) */ ;
#line 129 "gcats1_autops.dats"
/* tmp34 = */ the_threadinfolst_lock_acquire () ;
#line 129 "gcats1_autops.dats"
/* tmp35 = ats_selsin_mac(tmp34, atslab_1) */ ;
#line 130 "gcats1_autops.dats"
/* tmp36 = */ the_sweeplst_lock_acquire_all () ;
#line 130 "gcats1_autops.dats"
/* tmp37 = ats_selsin_mac(tmp36, atslab_1) */ ;
#line 131 "gcats1_autops.dats"
/* tmp38 = */ gc_collect () ;
#line 134 "gcats1_autops.dats"
/* tmp39 = */ the_sweeplst_lock_release_all () ;
#line 135 "gcats1_autops.dats"
/* tmp40 = */ the_threadinfolst_lock_release () ;
#line 136 "gcats1_autops.dats"
/* tmp41 = */ the_manmemlst_lock_release () ;
#line 137 "gcats1_autops.dats"
/* tmp29 = */ the_globalentrylst_lock_release () ;
} else {
/* empty */
} /* end of [if] */
#line 141 "gcats1_autops.dats"
tmp42 = chunklst_create (-1, arg0) ;
#line 142 "gcats1_autops.dats"
/* tmp43 = */ gc_main_lock_release () ;
#line 143 "gcats1_autops.dats"
tmp44 = chunklst_data_get (tmp42) ;
#line 144 "gcats1_autops.dats"
tmp4 = freeitmlst2ptr (tmp44) ;
break ;
} while (0) ;
return (tmp4) ;
} /* end of [gc_aut_malloc_wsz] */

/*
// /home/hwxi/research/Anairiats/ccomp/runtime/GCATS1/gcats1_autops.dats: 5780(line=174, offs=19) -- 6334(line=196, offs=4)
*/
ATSglobaldec()
ats_ptr_type
gc_aut_calloc_bsz (ats_int_type arg0, ats_int_type arg1) {
/* local vardec */
ATSlocal (ats_ptr_type, tmp45) ;
ATSlocal (ats_int_type, tmp46) ;
ATSlocal (ats_ptr_type, tmp47) ;
// ATSlocal_void (tmp48) ;

__ats_lab_gc_aut_calloc_bsz:
#line 183 "gcats1_autops.dats"
tmp46 = atspre_mul_int_int (arg0, arg1) ;
#line 184 "gcats1_autops.dats"
tmp47 = gc_aut_malloc_bsz (tmp46) ;
#line 185 "gcats1_autops.dats"
/* tmp48 = */ gc_aut_calloc_bsz_memset_bsz (tmp47, 0, tmp46) ;
#line 195 "gcats1_autops.dats"
tmp45 = tmp47 ;
return (tmp45) ;
} /* end of [gc_aut_calloc_bsz] */

/*
// /home/hwxi/research/Anairiats/ccomp/runtime/GCATS1/gcats1_autops.dats: 6462(line=202, offs=4) -- 8244(line=256, offs=4)
*/
ATSstaticdec()
ats_void_type
gcats1_autops_gc_aut_free_chunk_3 (ats_ptr_type arg0, ats_ptr_type arg1) {
/* local vardec */
// ATSlocal_void (tmp49) ;
ATSlocal (ats_int_type, tmp50) ;
ATSlocal (ats_bool_type, tmp51) ;
ATSlocal (ats_int_type, tmp52) ;
ATSlocal (ats_bool_type, tmp53) ;
// ATSlocal_void (tmp54) ;
// ATSlocal_void (tmp55) ;
// ATSlocal_void (tmp56) ;

__ats_lab_gcats1_autops_gc_aut_free_chunk_3:
#line 209 "gcats1_autops.dats"
tmp50 = chunklst_itemwsz_log_get (arg0) ;
#line 216 "gcats1_autops.dats"
tmp51 = atspre_igte (tmp50, 0) ;
#line 216 "gcats1_autops.dats"
if (tmp51) {
#line 238 "gcats1_autops.dats"
/* tmp49 = */ the_freeitmlst_array_insert_at (arg1, tmp50) ;
} else {
#line 242 "gcats1_autops.dats"
tmp52 = chunklst_itemtot_get (arg0) ;
#line 244 "gcats1_autops.dats"
tmp53 = atspre_eq_int_int (tmp52, 1) ;
#line 244 "gcats1_autops.dats"
if (tmp53) {
#line 245 "gcats1_autops.dats"
/* tmp54 = */ gc_main_lock_acquire () ;
#line 245 "gcats1_autops.dats"
/* tmp55 = ats_selsin_mac(tmp54, atslab_1) */ ;
#line 246 "gcats1_autops.dats"
/* tmp56 = */ chunklst_destroy (arg0) ;
#line 248 "gcats1_autops.dats"
/* tmp49 = */ gc_main_lock_release () ;
} else {
/* empty */
} /* end of [if] */
} /* end of [if] */
return /* (tmp49) */ ;
} /* end of [gcats1_autops_gc_aut_free_chunk_3] */

/*
// /home/hwxi/research/Anairiats/ccomp/runtime/GCATS1/gcats1_autops.dats: 8409(line=267, offs=6) -- 8605(line=271, offs=6)
*/
ATSstaticdec()
ats_void_type
gcats1_autops_err_botsegtbl_5 (ats_ptr_type arg0) {
/* local vardec */
// ATSlocal_void (tmp58) ;
// ATSlocal_void (tmp59) ;
// ATSlocal_void (tmp60) ;
// ATSlocal_void (tmp61) ;
// ATSlocal_void (tmp62) ;

__ats_lab_gcats1_autops_err_botsegtbl_5:
#line 268 "gcats1_autops.dats"
/* tmp59 = */ atspre_prerr_string (ATSstrcst("GC: Fatal Error: [gc_aut_free] failed")) ;
#line 269 "gcats1_autops.dats"
/* tmp60 = */ atspre_prerr_string (ATSstrcst(": invalid pointer (botsegtbl is nil): ")) ;
#line 269 "gcats1_autops.dats"
/* tmp61 = */ atspre_prerr_ptr (arg0) ;
#line 270 "gcats1_autops.dats"
/* tmp62 = */ atspre_prerr_newline () ;
#line 270 "gcats1_autops.dats"
/* tmp58 = */ ats_exit (1) ;
return /* (tmp58) */ ;
} /* end of [gcats1_autops_err_botsegtbl_5] */

/*
// /home/hwxi/research/Anairiats/ccomp/runtime/GCATS1/gcats1_autops.dats: 8611(line=272, offs=6) -- 8799(line=276, offs=6)
*/
ATSstaticdec()
ats_void_type
gcats1_autops_err_chunk_6 (ats_ptr_type arg0) {
/* local vardec */
// ATSlocal_void (tmp63) ;
// ATSlocal_void (tmp64) ;
// ATSlocal_void (tmp65) ;
// ATSlocal_void (tmp66) ;
// ATSlocal_void (tmp67) ;

__ats_lab_gcats1_autops_err_chunk_6:
#line 273 "gcats1_autops.dats"
/* tmp64 = */ atspre_prerr_string (ATSstrcst("GC: Fatal Error: [gc_aut_free] failed")) ;
#line 274 "gcats1_autops.dats"
/* tmp65 = */ atspre_prerr_string (ATSstrcst(": invalid pointer (chunk is nil): ")) ;
#line 274 "gcats1_autops.dats"
/* tmp66 = */ atspre_prerr_ptr (arg0) ;
#line 275 "gcats1_autops.dats"
/* tmp67 = */ atspre_prerr_newline () ;
#line 275 "gcats1_autops.dats"
/* tmp63 = */ ats_exit (1) ;
return /* (tmp63) */ ;
} /* end of [gcats1_autops_err_chunk_6] */

/*
// /home/hwxi/research/Anairiats/ccomp/runtime/GCATS1/gcats1_autops.dats: 8302(line=261, offs=13) -- 9241(line=290, offs=4)
*/
ATSglobaldec()
ats_void_type
gc_aut_free (ats_ptr_type arg0) {
/* local vardec */
// ATSlocal_void (tmp57) ;
ATSlocal (ats_uintptr1_type, tmp68) ;
ATSlocal (ats_uintptr1_type, tmp69) ;
ATSlocal (ats_ptr_type, tmp70) ;
ATSlocal (ats_bool_type, tmp71) ;
ATSlocal (ats_int_type, tmp72) ;
ATSlocal (ats_ptr_type, tmp73) ;
ATSlocal (ats_bool_type, tmp74) ;

__ats_lab_gc_aut_free:
#line 277 "gcats1_autops.dats"
tmp68 = PTR_TOPSEG_GET (arg0) ;
#line 277 "gcats1_autops.dats"
tmp69 = ats_selsin_mac(tmp68, atslab_1) ;
#line 278 "gcats1_autops.dats"
tmp70 = ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_2esats__the_topsegtbl_get (tmp69) ;
#line 280 "gcats1_autops.dats"
do {
/* branch: __ats_lab_2 */
#line 281 "gcats1_autops.dats"
__ats_lab_2_0:
#line 281 "gcats1_autops.dats"
__ats_lab_2_1:
#line 281 "gcats1_autops.dats"
tmp71 = botsegtbllst_is_cons (tmp70) ;
#line 281 "gcats1_autops.dats"
if (!tmp71) { goto __ats_lab_5_1 ; }
#line 282 "gcats1_autops.dats"
tmp72 = PTR_BOTSEG_GET (arg0) ;
#line 283 "gcats1_autops.dats"
tmp73 = botsegtbllst_get (tmp70, tmp72) ;
#line 285 "gcats1_autops.dats"
do {
/* branch: __ats_lab_3 */
#line 286 "gcats1_autops.dats"
__ats_lab_3_0:
#line 286 "gcats1_autops.dats"
__ats_lab_3_1:
#line 286 "gcats1_autops.dats"
tmp74 = chunklst_is_cons (tmp73) ;
#line 286 "gcats1_autops.dats"
if (!tmp74) { goto __ats_lab_4_1 ; }
#line 286 "gcats1_autops.dats"
/* tmp57 = */ gcats1_autops_gc_aut_free_chunk_3 (tmp73, arg0) ;
break ;

/* branch: __ats_lab_4 */
#line 287 "gcats1_autops.dats"
__ats_lab_4_0:
#line 287 "gcats1_autops.dats"
__ats_lab_4_1:
#line 287 "gcats1_autops.dats"
/* tmp57 = */ gcats1_autops_err_chunk_6 (arg0) ;
break ;
} while (0) ;
break ;

/* branch: __ats_lab_5 */
#line 289 "gcats1_autops.dats"
__ats_lab_5_0:
#line 289 "gcats1_autops.dats"
__ats_lab_5_1:
#line 289 "gcats1_autops.dats"
/* tmp57 = */ gcats1_autops_err_botsegtbl_5 (arg0) ;
break ;
} while (0) ;
return /* (tmp57) */ ;
} /* end of [gc_aut_free] */

/*
// /home/hwxi/research/Anairiats/ccomp/runtime/GCATS1/gcats1_autops.dats: 9354(line=297, offs=20) -- 9471(line=301, offs=4)
*/
ATSglobaldec()
ats_ptr_type
gc_aut_realloc_bsz (ats_ptr_type arg0, ats_int_type arg1) {
/* local vardec */
ATSlocal (ats_ptr_type, tmp75) ;
ATSlocal (ats_int_type, tmp76) ;
ATSlocal (ats_int_type, tmp77) ;
ATSlocal (ats_int_type, tmp78) ;

__ats_lab_gc_aut_realloc_bsz:
#line 298 "gcats1_autops.dats"
tmp78 = atspre_isub (8, 1) ;
#line 298 "gcats1_autops.dats"
tmp77 = atspre_add_int_int (arg1, tmp78) ;
#line 298 "gcats1_autops.dats"
tmp76 = atspre_asr_int_int1 (tmp77, 3) ;
#line 300 "gcats1_autops.dats"
tmp75 = ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_2esats__gc_aut_realloc_wsz (arg0, tmp76) ;
return (tmp75) ;
} /* end of [gc_aut_realloc_bsz] */

/*
// /home/hwxi/research/Anairiats/ccomp/runtime/GCATS1/gcats1_autops.dats: 9961(line=328, offs=6) -- 10126(line=332, offs=6)
*/
ATSstaticdec()
ats_ptr_type
gcats1_autops_err_9 (ats_ptr_type arg0) {
/* local vardec */
ATSlocal (ats_ptr_type, tmp80) ;
// ATSlocal_void (tmp81) ;
// ATSlocal_void (tmp82) ;
// ATSlocal_void (tmp83) ;
// ATSlocal_void (tmp84) ;

__ats_lab_gcats1_autops_err_9:
#line 329 "gcats1_autops.dats"
/* tmp81 = */ atspre_prerr_string (ATSstrcst("GC: Fatal Error: [gc_aut_free] failed")) ;
#line 330 "gcats1_autops.dats"
/* tmp82 = */ atspre_prerr_string (ATSstrcst(": invalid pointer: ")) ;
#line 330 "gcats1_autops.dats"
/* tmp83 = */ atspre_prerr_ptr (arg0) ;
#line 330 "gcats1_autops.dats"
/* tmp84 = */ atspre_prerr_newline () ;
#line 331 "gcats1_autops.dats"
/* tmp80 = */ ats_exit (1) ;
return (tmp80) ;
} /* end of [gcats1_autops_err_9] */

/*
// /home/hwxi/research/Anairiats/ccomp/runtime/GCATS1/gcats1_autops.dats: 10228(line=335, offs=6) -- 11278(line=369, offs=6)
*/
ATSstaticdec()
ats_ptr_type
gcats1_autops_aux_main_10 (ats_ptr_type arg0, ats_ptr_type arg1, ats_int_type arg2) {
/* local vardec */
ATSlocal (ats_ptr_type, tmp88) ;
ATSlocal (ats_int_type, tmp89) ;
ATSlocal (ats_bool_type, tmp90) ;
ATSlocal (ats_ptr_type, tmp91) ;
// ATSlocal_void (tmp92) ;
// ATSlocal_void (tmp93) ;
ATSlocal (ats_bool_type, tmp94) ;
ATSlocal (ats_int_type, tmp95) ;
ATSlocal (ats_ptr_type, tmp96) ;
// ATSlocal_void (tmp97) ;
// ATSlocal_void (tmp98) ;

__ats_lab_gcats1_autops_aux_main_10:
#line 340 "gcats1_autops.dats"
tmp89 = chunklst_itemwsz_get (arg0) ;
#line 342 "gcats1_autops.dats"
do {
/* branch: __ats_lab_6 */
#line 343 "gcats1_autops.dats"
__ats_lab_6_0:
#line 343 "gcats1_autops.dats"
__ats_lab_6_1:
#line 343 "gcats1_autops.dats"
tmp90 = atspre_gt_int_int (arg2, tmp89) ;
#line 343 "gcats1_autops.dats"
if (!tmp90) { goto __ats_lab_7_1 ; }
#line 349 "gcats1_autops.dats"
tmp91 = gc_aut_malloc_wsz (arg2) ;
#line 350 "gcats1_autops.dats"
/* tmp92 = */ gc_aut_realloc_wsz_memcpy_wsz (tmp91, arg1, tmp89) ;
#line 351 "gcats1_autops.dats"
/* tmp93 = */ gcats1_autops_gc_aut_free_chunk_3 (arg0, arg1) ;
#line 353 "gcats1_autops.dats"
tmp88 = tmp91 ;
break ;

/* branch: __ats_lab_7 */
#line 355 "gcats1_autops.dats"
__ats_lab_7_0:
#line 355 "gcats1_autops.dats"
__ats_lab_7_1:
#line 355 "gcats1_autops.dats"
tmp95 = atspre_mul_int_int (2, arg2) ;
#line 355 "gcats1_autops.dats"
tmp94 = atspre_lte_int_int (tmp95, tmp89) ;
#line 355 "gcats1_autops.dats"
if (!tmp94) { goto __ats_lab_8_1 ; }
#line 361 "gcats1_autops.dats"
tmp96 = gc_aut_malloc_wsz (arg2) ;
#line 363 "gcats1_autops.dats"
/* tmp97 = */ gc_aut_realloc_wsz_memcpy_wsz (tmp96, arg1, arg2) ;
#line 364 "gcats1_autops.dats"
/* tmp98 = */ gcats1_autops_gc_aut_free_chunk_3 (arg0, arg1) ;
#line 366 "gcats1_autops.dats"
tmp88 = tmp96 ;
break ;

/* branch: __ats_lab_8 */
#line 368 "gcats1_autops.dats"
__ats_lab_8_0:
#line 368 "gcats1_autops.dats"
__ats_lab_8_1:
#line 368 "gcats1_autops.dats"
tmp88 = arg1 ;
break ;
} while (0) ;
return (tmp88) ;
} /* end of [gcats1_autops_aux_main_10] */

/*
// /home/hwxi/research/Anairiats/ccomp/runtime/GCATS1/gcats1_autops.dats: 9739(line=319, offs=20) -- 11928(line=396, offs=4)
*/
ATSglobaldec()
ats_ptr_type
ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_2esats__gc_aut_realloc_wsz (ats_ptr_type arg0, ats_int_type arg1) {
/* local vardec */
ATSlocal (ats_ptr_type, tmp79) ;
ATSlocal (ats_uintptr1_type, tmp85) ;
ATSlocal (ats_uintptr1_type, tmp86) ;
ATSlocal (ats_ptr_type, tmp87) ;
ATSlocal (ats_bool_type, tmp99) ;
ATSlocal (ats_bool_type, tmp100) ;
ATSlocal (ats_int_type, tmp101) ;
ATSlocal (ats_ptr_type, tmp102) ;
ATSlocal (ats_bool_type, tmp103) ;

__ats_lab_ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_2esats__gc_aut_realloc_wsz:
#line 333 "gcats1_autops.dats"
tmp85 = PTR_TOPSEG_GET (arg0) ;
#line 333 "gcats1_autops.dats"
tmp86 = ats_selsin_mac(tmp85, atslab_1) ;
#line 334 "gcats1_autops.dats"
tmp87 = ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_2esats__the_topsegtbl_get (tmp86) ;
#line 372 "gcats1_autops.dats"
tmp99 = atspre_pgt (arg0, atspre_null_ptr) ;
#line 372 "gcats1_autops.dats"
if (tmp99) {
#line 373 "gcats1_autops.dats"
do {
/* branch: __ats_lab_9 */
#line 374 "gcats1_autops.dats"
__ats_lab_9_0:
#line 374 "gcats1_autops.dats"
__ats_lab_9_1:
#line 374 "gcats1_autops.dats"
tmp100 = botsegtbllst_is_cons (tmp87) ;
#line 374 "gcats1_autops.dats"
if (!tmp100) { goto __ats_lab_12_1 ; }
#line 375 "gcats1_autops.dats"
tmp101 = PTR_BOTSEG_GET (arg0) ;
#line 376 "gcats1_autops.dats"
tmp102 = botsegtbllst_get (tmp87, tmp101) ;
#line 378 "gcats1_autops.dats"
do {
/* branch: __ats_lab_10 */
#line 379 "gcats1_autops.dats"
__ats_lab_10_0:
#line 379 "gcats1_autops.dats"
__ats_lab_10_1:
#line 379 "gcats1_autops.dats"
tmp103 = chunklst_is_cons (tmp102) ;
#line 379 "gcats1_autops.dats"
if (!tmp103) { goto __ats_lab_11_1 ; }
#line 380 "gcats1_autops.dats"
tmp79 = gcats1_autops_aux_main_10 (tmp102, arg0, arg1) ;
break ;

/* branch: __ats_lab_11 */
#line 390 "gcats1_autops.dats"
__ats_lab_11_0:
#line 390 "gcats1_autops.dats"
__ats_lab_11_1:
#line 390 "gcats1_autops.dats"
tmp79 = gcats1_autops_err_9 (arg0) ;
break ;
} while (0) ;
break ;

/* branch: __ats_lab_12 */
#line 392 "gcats1_autops.dats"
__ats_lab_12_0:
#line 392 "gcats1_autops.dats"
__ats_lab_12_1:
#line 392 "gcats1_autops.dats"
tmp79 = gcats1_autops_err_9 (arg0) ;
break ;
} while (0) ;
} else {
#line 394 "gcats1_autops.dats"
tmp79 = gc_aut_malloc_wsz (arg1) ;
} /* end of [if] */
return (tmp79) ;
} /* end of [ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_2esats__gc_aut_realloc_wsz] */

/* static load function */

extern ats_void_type ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_2esats__staload (void) ;

ats_void_type
ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_autops_2edats__staload () {
static int ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_autops_2edats__staload_flag = 0 ;
if (ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_autops_2edats__staload_flag) return ;
ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_autops_2edats__staload_flag = 1 ;

ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_2esats__staload () ;

return ;
} /* staload function */

/* dynamic load function */

// dynload flag declaration
extern ats_int_type ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_autops_2edats__dynload_flag ;

ats_void_type
ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_autops_2edats__dynload () {
ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_autops_2edats__dynload_flag = 1 ;
ATS_2d0_2e2_2e10_2ccomp_2runtime_2GCATS1_2gcats1_autops_2edats__staload () ;

#ifdef _ATS_PROOFCHECK
#endif /* _ATS_PROOFCHECK */

/* marking static variables for GC */

/* marking external values for GC */

/* code for dynamic loading */
return ;
} /* end of [dynload function] */

/* external codes at mid */
/* external codes at bot */

/* ****** ****** */

/* end of [gcats1_autops_dats.c] */
