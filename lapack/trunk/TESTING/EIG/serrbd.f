      SUBROUTINE SERRBD( PATH, NUNIT )
*
*  -- LAPACK test routine (version 3.1) --
*     Univ. of Tennessee, Univ. of California Berkeley and NAG Ltd..
*     November 2006
*
*     .. Scalar Arguments ..
      CHARACTER*3        PATH
      INTEGER            NUNIT
*     ..
*
*  Purpose
*  =======
*
*  SERRBD tests the error exits for SGEBRD, SORGBR, SORMBR, SBDSQR and
*  SBDSDC.
*
*  Arguments
*  =========
*
*  PATH    (input) CHARACTER*3
*          The LAPACK path name for the routines to be tested.
*
*  NUNIT   (input) INTEGER
*          The unit number for output.
*
*  =====================================================================
*
*     .. Parameters ..
      INTEGER            NMAX, LW
      PARAMETER          ( NMAX = 4, LW = NMAX )
*     ..
*     .. Local Scalars ..
      CHARACTER*2        C2
      INTEGER            I, INFO, J, NT
*     ..
*     .. Local Arrays ..
      INTEGER            IQ( NMAX, NMAX ), IW( NMAX )
      REAL               A( NMAX, NMAX ), D( NMAX ), E( NMAX ),
     $                   Q( NMAX, NMAX ), TP( NMAX ), TQ( NMAX ),
     $                   U( NMAX, NMAX ), V( NMAX, NMAX ), W( LW )
*     ..
*     .. External Functions ..
      LOGICAL            LSAMEN
      EXTERNAL           LSAMEN
*     ..
*     .. External Subroutines ..
      EXTERNAL           CHKXER, SBDSDC, SBDSQR, SGEBD2, SGEBRD, SORGBR,
     $                   SORMBR
*     ..
*     .. Scalars in Common ..
      LOGICAL            LERR, OK
      CHARACTER(32)      SRNAMT
      INTEGER            INFOT, NOUT
*     ..
*     .. Common blocks ..
      COMMON             / INFOC / INFOT, NOUT, OK, LERR
      COMMON             / SRNAMC / SRNAMT
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          REAL
*     ..
*     .. Executable Statements ..
*
      NOUT = NUNIT
      WRITE( NOUT, FMT = * )
      C2 = PATH( 2: 3 )
*
*     Set the variables to innocuous values.
*
      DO 20 J = 1, NMAX
         DO 10 I = 1, NMAX
            A( I, J ) = 1. / REAL( I+J )
   10    CONTINUE
   20 CONTINUE
      OK = .TRUE.
      NT = 0
*
*     Test error exits of the SVD routines.
*
      IF( LSAMEN( 2, C2, 'BD' ) ) THEN
*
*        SGEBRD
*
         SRNAMT = 'SGEBRD'
         INFOT = 1
         CALL SGEBRD( -1, 0, A, 1, D, E, TQ, TP, W, 1, INFO )
         CALL CHKXER( 'SGEBRD', INFOT, NOUT, LERR, OK )
         INFOT = 2
         CALL SGEBRD( 0, -1, A, 1, D, E, TQ, TP, W, 1, INFO )
         CALL CHKXER( 'SGEBRD', INFOT, NOUT, LERR, OK )
         INFOT = 4
         CALL SGEBRD( 2, 1, A, 1, D, E, TQ, TP, W, 2, INFO )
         CALL CHKXER( 'SGEBRD', INFOT, NOUT, LERR, OK )
         INFOT = 10
         CALL SGEBRD( 2, 1, A, 2, D, E, TQ, TP, W, 1, INFO )
         CALL CHKXER( 'SGEBRD', INFOT, NOUT, LERR, OK )
         NT = NT + 4
*
*        SGEBD2
*
         SRNAMT = 'SGEBD2'
         INFOT = 1
         CALL SGEBD2( -1, 0, A, 1, D, E, TQ, TP, W, INFO )
         CALL CHKXER( 'SGEBD2', INFOT, NOUT, LERR, OK )
         INFOT = 2
         CALL SGEBD2( 0, -1, A, 1, D, E, TQ, TP, W, INFO )
         CALL CHKXER( 'SGEBD2', INFOT, NOUT, LERR, OK )
         INFOT = 4
         CALL SGEBD2( 2, 1, A, 1, D, E, TQ, TP, W, INFO )
         CALL CHKXER( 'SGEBD2', INFOT, NOUT, LERR, OK )
         NT = NT + 3
*
*        SORGBR
*
         SRNAMT = 'SORGBR'
         INFOT = 1
         CALL SORGBR( '/', 0, 0, 0, A, 1, TQ, W, 1, INFO )
         CALL CHKXER( 'SORGBR', INFOT, NOUT, LERR, OK )
         INFOT = 2
         CALL SORGBR( 'Q', -1, 0, 0, A, 1, TQ, W, 1, INFO )
         CALL CHKXER( 'SORGBR', INFOT, NOUT, LERR, OK )
         INFOT = 3
         CALL SORGBR( 'Q', 0, -1, 0, A, 1, TQ, W, 1, INFO )
         CALL CHKXER( 'SORGBR', INFOT, NOUT, LERR, OK )
         INFOT = 3
         CALL SORGBR( 'Q', 0, 1, 0, A, 1, TQ, W, 1, INFO )
         CALL CHKXER( 'SORGBR', INFOT, NOUT, LERR, OK )
         INFOT = 3
         CALL SORGBR( 'Q', 1, 0, 1, A, 1, TQ, W, 1, INFO )
         CALL CHKXER( 'SORGBR', INFOT, NOUT, LERR, OK )
         INFOT = 3
         CALL SORGBR( 'P', 1, 0, 0, A, 1, TQ, W, 1, INFO )
         CALL CHKXER( 'SORGBR', INFOT, NOUT, LERR, OK )
         INFOT = 3
         CALL SORGBR( 'P', 0, 1, 1, A, 1, TQ, W, 1, INFO )
         CALL CHKXER( 'SORGBR', INFOT, NOUT, LERR, OK )
         INFOT = 4
         CALL SORGBR( 'Q', 0, 0, -1, A, 1, TQ, W, 1, INFO )
         CALL CHKXER( 'SORGBR', INFOT, NOUT, LERR, OK )
         INFOT = 6
         CALL SORGBR( 'Q', 2, 1, 1, A, 1, TQ, W, 1, INFO )
         CALL CHKXER( 'SORGBR', INFOT, NOUT, LERR, OK )
         INFOT = 9
         CALL SORGBR( 'Q', 2, 2, 1, A, 2, TQ, W, 1, INFO )
         CALL CHKXER( 'SORGBR', INFOT, NOUT, LERR, OK )
         NT = NT + 10
*
*        SORMBR
*
         SRNAMT = 'SORMBR'
         INFOT = 1
         CALL SORMBR( '/', 'L', 'T', 0, 0, 0, A, 1, TQ, U, 1, W, 1,
     $                INFO )
         CALL CHKXER( 'SORMBR', INFOT, NOUT, LERR, OK )
         INFOT = 2
         CALL SORMBR( 'Q', '/', 'T', 0, 0, 0, A, 1, TQ, U, 1, W, 1,
     $                INFO )
         CALL CHKXER( 'SORMBR', INFOT, NOUT, LERR, OK )
         INFOT = 3
         CALL SORMBR( 'Q', 'L', '/', 0, 0, 0, A, 1, TQ, U, 1, W, 1,
     $                INFO )
         CALL CHKXER( 'SORMBR', INFOT, NOUT, LERR, OK )
         INFOT = 4
         CALL SORMBR( 'Q', 'L', 'T', -1, 0, 0, A, 1, TQ, U, 1, W, 1,
     $                INFO )
         CALL CHKXER( 'SORMBR', INFOT, NOUT, LERR, OK )
         INFOT = 5
         CALL SORMBR( 'Q', 'L', 'T', 0, -1, 0, A, 1, TQ, U, 1, W, 1,
     $                INFO )
         CALL CHKXER( 'SORMBR', INFOT, NOUT, LERR, OK )
         INFOT = 6
         CALL SORMBR( 'Q', 'L', 'T', 0, 0, -1, A, 1, TQ, U, 1, W, 1,
     $                INFO )
         CALL CHKXER( 'SORMBR', INFOT, NOUT, LERR, OK )
         INFOT = 8
         CALL SORMBR( 'Q', 'L', 'T', 2, 0, 0, A, 1, TQ, U, 2, W, 1,
     $                INFO )
         CALL CHKXER( 'SORMBR', INFOT, NOUT, LERR, OK )
         INFOT = 8
         CALL SORMBR( 'Q', 'R', 'T', 0, 2, 0, A, 1, TQ, U, 1, W, 1,
     $                INFO )
         CALL CHKXER( 'SORMBR', INFOT, NOUT, LERR, OK )
         INFOT = 8
         CALL SORMBR( 'P', 'L', 'T', 2, 0, 2, A, 1, TQ, U, 2, W, 1,
     $                INFO )
         CALL CHKXER( 'SORMBR', INFOT, NOUT, LERR, OK )
         INFOT = 8
         CALL SORMBR( 'P', 'R', 'T', 0, 2, 2, A, 1, TQ, U, 1, W, 1,
     $                INFO )
         CALL CHKXER( 'SORMBR', INFOT, NOUT, LERR, OK )
         INFOT = 11
         CALL SORMBR( 'Q', 'R', 'T', 2, 0, 0, A, 1, TQ, U, 1, W, 1,
     $                INFO )
         CALL CHKXER( 'SORMBR', INFOT, NOUT, LERR, OK )
         INFOT = 13
         CALL SORMBR( 'Q', 'L', 'T', 0, 2, 0, A, 1, TQ, U, 1, W, 1,
     $                INFO )
         CALL CHKXER( 'SORMBR', INFOT, NOUT, LERR, OK )
         INFOT = 13
         CALL SORMBR( 'Q', 'R', 'T', 2, 0, 0, A, 1, TQ, U, 2, W, 1,
     $                INFO )
         CALL CHKXER( 'SORMBR', INFOT, NOUT, LERR, OK )
         NT = NT + 13
*
*        SBDSQR
*
         SRNAMT = 'SBDSQR'
         INFOT = 1
         CALL SBDSQR( '/', 0, 0, 0, 0, D, E, V, 1, U, 1, A, 1, W, INFO )
         CALL CHKXER( 'SBDSQR', INFOT, NOUT, LERR, OK )
         INFOT = 2
         CALL SBDSQR( 'U', -1, 0, 0, 0, D, E, V, 1, U, 1, A, 1, W,
     $                INFO )
         CALL CHKXER( 'SBDSQR', INFOT, NOUT, LERR, OK )
         INFOT = 3
         CALL SBDSQR( 'U', 0, -1, 0, 0, D, E, V, 1, U, 1, A, 1, W,
     $                INFO )
         CALL CHKXER( 'SBDSQR', INFOT, NOUT, LERR, OK )
         INFOT = 4
         CALL SBDSQR( 'U', 0, 0, -1, 0, D, E, V, 1, U, 1, A, 1, W,
     $                INFO )
         CALL CHKXER( 'SBDSQR', INFOT, NOUT, LERR, OK )
         INFOT = 5
         CALL SBDSQR( 'U', 0, 0, 0, -1, D, E, V, 1, U, 1, A, 1, W,
     $                INFO )
         CALL CHKXER( 'SBDSQR', INFOT, NOUT, LERR, OK )
         INFOT = 9
         CALL SBDSQR( 'U', 2, 1, 0, 0, D, E, V, 1, U, 1, A, 1, W, INFO )
         CALL CHKXER( 'SBDSQR', INFOT, NOUT, LERR, OK )
         INFOT = 11
         CALL SBDSQR( 'U', 0, 0, 2, 0, D, E, V, 1, U, 1, A, 1, W, INFO )
         CALL CHKXER( 'SBDSQR', INFOT, NOUT, LERR, OK )
         INFOT = 13
         CALL SBDSQR( 'U', 2, 0, 0, 1, D, E, V, 1, U, 1, A, 1, W, INFO )
         CALL CHKXER( 'SBDSQR', INFOT, NOUT, LERR, OK )
         NT = NT + 8
*
*        SBDSDC
*
         SRNAMT = 'SBDSDC'
         INFOT = 1
         CALL SBDSDC( '/', 'N', 0, D, E, U, 1, V, 1, Q, IQ, W, IW,
     $                INFO )
         CALL CHKXER( 'SBDSDC', INFOT, NOUT, LERR, OK )
         INFOT = 2
         CALL SBDSDC( 'U', '/', 0, D, E, U, 1, V, 1, Q, IQ, W, IW,
     $                INFO )
         CALL CHKXER( 'SBDSDC', INFOT, NOUT, LERR, OK )
         INFOT = 3
         CALL SBDSDC( 'U', 'N', -1, D, E, U, 1, V, 1, Q, IQ, W, IW,
     $                INFO )
         CALL CHKXER( 'SBDSDC', INFOT, NOUT, LERR, OK )
         INFOT = 7
         CALL SBDSDC( 'U', 'I', 2, D, E, U, 1, V, 1, Q, IQ, W, IW,
     $                INFO )
         CALL CHKXER( 'SBDSDC', INFOT, NOUT, LERR, OK )
         INFOT = 9
         CALL SBDSDC( 'U', 'I', 2, D, E, U, 2, V, 1, Q, IQ, W, IW,
     $                INFO )
         CALL CHKXER( 'SBDSDC', INFOT, NOUT, LERR, OK )
         NT = NT + 5
      END IF
*
*     Print a summary line.
*
      IF( OK ) THEN
         WRITE( NOUT, FMT = 9999 )PATH, NT
      ELSE
         WRITE( NOUT, FMT = 9998 )PATH
      END IF
*
 9999 FORMAT( 1X, A3, ' routines passed the tests of the error exits',
     $      ' (', I3, ' tests done)' )
 9998 FORMAT( ' *** ', A3, ' routines failed the tests of the error ',
     $      'exits ***' )
*
      RETURN
*
*     End of SERRBD
*
      END