*> \brief \b CTZT02
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at 
*            http://www.netlib.org/lapack/explore-html/ 
*
*  Definition:
*  ===========
*
*       REAL             FUNCTION CTZT02( M, N, AF, LDA, TAU, WORK,
*                        LWORK )
* 
*       .. Scalar Arguments ..
*       INTEGER            LDA, LWORK, M, N
*       ..
*       .. Array Arguments ..
*       COMPLEX            AF( LDA, * ), TAU( * ), WORK( LWORK )
*       ..
*  
*
*> \par Purpose:
*  =============
*>
*> \verbatim
*>
*> CTZT02 returns
*>      || I - Q'*Q || / ( M * eps)
*> where the matrix Q is defined by the Householder transformations
*> generated by CTZRQF.
*> \endverbatim
*
*  Arguments:
*  ==========
*
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows of the matrix AF.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of columns of the matrix AF.
*> \endverbatim
*>
*> \param[in] AF
*> \verbatim
*>          AF is COMPLEX array, dimension (LDA,N)
*>          The output of CTZRQF.
*> \endverbatim
*>
*> \param[in] LDA
*> \verbatim
*>          LDA is INTEGER
*>          The leading dimension of the array AF.
*> \endverbatim
*>
*> \param[in] TAU
*> \verbatim
*>          TAU is COMPLEX array, dimension (M)
*>          Details of the Householder transformations as returned by
*>          CTZRQF.
*> \endverbatim
*>
*> \param[out] WORK
*> \verbatim
*>          WORK is COMPLEX array, dimension (LWORK)
*> \endverbatim
*>
*> \param[in] LWORK
*> \verbatim
*>          LWORK is INTEGER
*>          length of WORK array. Must be >= N*N+N
*> \endverbatim
*
*  Authors:
*  ========
*
*> \author Univ. of Tennessee 
*> \author Univ. of California Berkeley 
*> \author Univ. of Colorado Denver 
*> \author NAG Ltd. 
*
*> \date November 2011
*
*> \ingroup complex_lin
*
*  =====================================================================
      REAL             FUNCTION CTZT02( M, N, AF, LDA, TAU, WORK,
     $                 LWORK )
*
*  -- LAPACK test routine (version 3.1) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     November 2011
*
*     .. Scalar Arguments ..
      INTEGER            LDA, LWORK, M, N
*     ..
*     .. Array Arguments ..
      COMPLEX            AF( LDA, * ), TAU( * ), WORK( LWORK )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      REAL               ZERO, ONE
      PARAMETER          ( ZERO = 0.0E0, ONE = 1.0E0 )
*     ..
*     .. Local Scalars ..
      INTEGER            I
*     ..
*     .. Local Arrays ..
      REAL               RWORK( 1 )
*     ..
*     .. External Functions ..
      REAL               CLANGE, SLAMCH
      EXTERNAL           CLANGE, SLAMCH
*     ..
*     .. External Subroutines ..
      EXTERNAL           CLATZM, CLASET, XERBLA
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          CMPLX, CONJG, MAX, REAL
*     ..
*     .. Executable Statements ..
*
      CTZT02 = ZERO
*
      IF( LWORK.LT.N*N+N ) THEN
         CALL XERBLA( 'CTZT02', 7 )
         RETURN
      END IF
*
*     Quick return if possible
*
      IF( M.LE.0 .OR. N.LE.0 )
     $   RETURN
*
*     Q := I
*
      CALL CLASET( 'Full', N, N, CMPLX( ZERO ), CMPLX( ONE ), WORK, N )
*
*     Q := P(1) * ... * P(m) * Q
*
      DO 10 I = M, 1, -1
         CALL CLATZM( 'Left', N-M+1, N, AF( I, M+1 ), LDA, TAU( I ),
     $                WORK( I ), WORK( M+1 ), N, WORK( N*N+1 ) )
   10 CONTINUE
*
*     Q := P(m)' * ... * P(1)' * Q
*
      DO 20 I = 1, M
         CALL CLATZM( 'Left', N-M+1, N, AF( I, M+1 ), LDA,
     $                CONJG( TAU( I ) ), WORK( I ), WORK( M+1 ), N,
     $                WORK( N*N+1 ) )
   20 CONTINUE
*
*     Q := Q - I
*
      DO 30 I = 1, N
         WORK( ( I-1 )*N+I ) = WORK( ( I-1 )*N+I ) - ONE
   30 CONTINUE
*
      CTZT02 = CLANGE( 'One-norm', N, N, WORK, N, RWORK ) /
     $         ( SLAMCH( 'Epsilon' )*REAL( MAX( M, N ) ) )
      RETURN
*
*     End of CTZT02
*
      END
