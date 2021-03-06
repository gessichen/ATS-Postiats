(* ****** ****** *)
//
// HX-2013-04:
// Effective ATS: Copying files (3)
//
(* ****** ****** *)

%{^
#include <unistd.h>
%}

(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
//
(* ****** ****** *)

abst@ype fildes_t0ype = int
stadef fildes: t@ype = fildes_t0ype

(* ****** ****** *)

absvtype buffer_type = ptr
vtypedef buffer = buffer_type

(* ****** ****** *)

extern
fun buffer_create (m: size_t): buffer = "mac#"
extern
fun buffer_destroy (buf: buffer): void = "mac#"
extern
fun buffer_isnot_empty (buf: !buffer): bool = "mac#"

(* ****** ****** *)

%{^

typedef
struct {
  char* data ; size_t size ; size_t nchar ;
} buffer_struct ;
typedef buffer_struct *buffer ;

static
buffer
buffer_create (size_t m)
{
  buffer buf = atspre_malloc_gc(sizeof(buffer_struct)) ;
  buf->data = atspre_malloc_gc(m) ; buf->size = m ; buf->nchar = 0 ;
  return buf ;
}

static
void
buffer_destroy (buffer buf)
{
  atspre_mfree_gc (buf->data) ; atspre_mfree_gc (buf) ; return ;
}

#define buffer_isnot_empty(buf) (((buffer)buf)->nchar?1:0)

%}

(* ****** ****** *)

extern
fun readbuf (src: fildes, buf: !buffer, err: &int): void = "sta#"
extern
fun writebuf (dst: fildes, buf: !buffer, err: &int): void = "sta#"

(* ****** ****** *)

%{^

static
void
readbuf
(
  int src, atstype_ptr buf0, atstype_ptr err
)
{
  buffer buf = (buffer)buf0 ;
  ssize_t nchar ;
  nchar = read(src, buf->data, buf->size) ;
  if (nchar < 0) { *(int*)err += 1 ; return ; }
  buf->nchar = nchar ;
  return ;
}

static
void
writebuf
(
  int dst, atstype_ptr buf0, atstype_ptr err
)
{
  ssize_t nchar ;
  buffer buf = (buffer)buf0 ;
  while (1)
  {
    if (buf->nchar==0) break ;
    nchar = write(dst, buf->data, buf->nchar) ;
    if (nchar < 0) { *(int*)err += 1 ; return ; }
    buf->nchar -= nchar ;
  } // end of [while]
  return ;
}

%}

(* ****** ****** *)

#define BUFSZ (16*1024)

(* ****** ****** *)
//
extern
fun fcopy3 (src: fildes, dst: fildes, err: &int): void
//
(* ****** ****** *)

implement
fcopy3 (src, dst, err) = let
//
fun loop
(
  src: fildes, dst: fildes, buf: !buffer, err0: int, err: &int
) : void = let
  val () = readbuf (src, buf, err)
  val isnot = buffer_isnot_empty (buf)
in
  if isnot then let
    val () = writebuf (dst, buf, err)
  in
    if err = err0 then loop (src, dst, buf, err0, err) else ((*error*))
  end else () // end of [if]
//
end // end of [loop]
//
val buf =
  buffer_create (i2sz(BUFSZ))
val err0 = err
val () = loop (src, dst, buf, err0, err)
val () = buffer_destroy (buf)
//
in
  // nothing
end (* end of [fcopy3] *)

(* ****** ****** *)

val STDIN = $extval (fildes, "0")
val STDOUT = $extval (fildes, "1")

(* ****** ****** *)

implement
main0 () =
{
//
var err: int = 0
val () = fcopy3 (STDIN, STDOUT, err)
val () = assertloc (err = 0)
//
} (* end of [main0] *)

(* ****** ****** *)

(* end of [fcopy3.dats] *)
