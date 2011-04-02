      SUBROUTINE SLATZM( SIDE, M, N, V, INCV, TAU, C1, C2, LDC, WORK )
*
*  -- LAPACK routine (version 3.2) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     November 2006
*
*     .. Scalar Arguments ..
      CHARACTER          SIDE
      INTEGER            INCV, LDC, M, N
      REAL               TAU
*     ..
*     .. Array Arguments ..
      REAL               C1( LDC, * ), C2( LDC, * ), V( * ), WORK( * )
*     ..
*
*  Purpose
*  =======
*
*  This routine is deprecated and has been replaced by routine SORMRZ.
*
*  SLATZM applies a Householder matrix generated by STZRQF to a matrix.
*
*  Let P = I - tau*u*u**T,   u = ( 1 ),
*                                ( v )
*  where v is an (m-1) vector if SIDE = 'L', or a (n-1) vector if
*  SIDE = 'R'.
*
*  If SIDE equals 'L', let
*         C = [ C1 ] 1
*             [ C2 ] m-1
*               n
*  Then C is overwritten by P*C.
*
*  If SIDE equals 'R', let
*         C = [ C1, C2 ] m
*                1  n-1
*  Then C is overwritten by C*P.
*
*  Arguments
*  =========
*
*  SIDE    (input) CHARACTER*1
*          = 'L': form P * C
*          = 'R': form C * P
*
*  M       (input) INTEGER
*          The number of rows of the matrix C.
*
*  N       (input) INTEGER
*          The number of columns of the matrix C.
*
*  V       (input) REAL array, dimension
*                  (1 + (M-1)*abs(INCV)) if SIDE = 'L'
*                  (1 + (N-1)*abs(INCV)) if SIDE = 'R'
*          The vector v in the representation of P. V is not used
*          if TAU = 0.
*
*  INCV    (input) INTEGER
*          The increment between elements of v. INCV <> 0
*
*  TAU     (input) REAL
*          The value tau in the representation of P.
*
*  C1      (input/output) REAL array, dimension
*                         (LDC,N) if SIDE = 'L'
*                         (M,1)   if SIDE = 'R'
*          On entry, the n-vector C1 if SIDE = 'L', or the m-vector C1
*          if SIDE = 'R'.
*
*          On exit, the first row of P*C if SIDE = 'L', or the first
*          column of C*P if SIDE = 'R'.
*
*  C2      (input/output) REAL array, dimension
*                         (LDC, N)   if SIDE = 'L'
*                         (LDC, N-1) if SIDE = 'R'
*          On entry, the (m - 1) x n matrix C2 if SIDE = 'L', or the
*          m x (n - 1) matrix C2 if SIDE = 'R'.
*
*          On exit, rows 2:m of P*C if SIDE = 'L', or columns 2:m of C*P
*          if SIDE = 'R'.
*
*  LDC     (input) INTEGER
*          The leading dimension of the arrays C1 and C2. LDC >= (1,M).
*
*  WORK    (workspace) REAL array, dimension
*                      (N) if SIDE = 'L'
*                      (M) if SIDE = 'R'
*
*  =====================================================================
*
*     .. Parameters ..
      REAL               ONE, ZERO
      PARAMETER          ( ONE = 1.0E+0, ZERO = 0.0E+0 )
*     ..
*     .. External Subroutines ..
      EXTERNAL           SAXPY, SCOPY, SGEMV, SGER
*     ..
*     .. External Functions ..
      LOGICAL            LSAME
      EXTERNAL           LSAME
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          MIN
*     ..
*     .. Executable Statements ..
*
      IF( ( MIN( M, N ).EQ.0 ) .OR. ( TAU.EQ.ZERO ) )
     $   RETURN
*
      IF( LSAME( SIDE, 'L' ) ) THEN
*
*        w :=  (C1 + v**T * C2)**T
*
         CALL SCOPY( N, C1, LDC, WORK, 1 )
         CALL SGEMV( 'Transpose', M-1, N, ONE, C2, LDC, V, INCV, ONE,
     $               WORK, 1 )
*
*        [ C1 ] := [ C1 ] - tau* [ 1 ] * w**T
*        [ C2 ]    [ C2 ]        [ v ]
*
         CALL SAXPY( N, -TAU, WORK, 1, C1, LDC )
         CALL SGER( M-1, N, -TAU, V, INCV, WORK, 1, C2, LDC )
*
      ELSE IF( LSAME( SIDE, 'R' ) ) THEN
*
*        w := C1 + C2 * v
*
         CALL SCOPY( M, C1, 1, WORK, 1 )
         CALL SGEMV( 'No transpose', M, N-1, ONE, C2, LDC, V, INCV, ONE,
     $               WORK, 1 )
*
*        [ C1, C2 ] := [ C1, C2 ] - tau* w * [ 1 , v**T]
*
         CALL SAXPY( M, -TAU, WORK, 1, C1, 1 )
         CALL SGER( M, N-1, -TAU, WORK, 1, V, INCV, C2, LDC )
      END IF
*
      RETURN
*
*     End of SLATZM
*
      END
