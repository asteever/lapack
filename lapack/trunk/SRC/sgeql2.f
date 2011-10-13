*> \brief \b SGEQL2
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at 
*            http://www.netlib.org/lapack/explore-html/ 
*
*> Download SGEQL2 + dependencies 
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.tgz?format=tgz&filename=/lapack/lapack_routine/sgeql2.f"> 
*> [TGZ]</a> 
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.zip?format=zip&filename=/lapack/lapack_routine/sgeql2.f"> 
*> [ZIP]</a> 
*> <a href="http://www.netlib.org/cgi-bin/netlibfiles.txt?format=txt&filename=/lapack/lapack_routine/sgeql2.f"> 
*> [TXT]</a> 
*
*  Definition
*  ==========
*
*       SUBROUTINE SGEQL2( M, N, A, LDA, TAU, WORK, INFO )
* 
*       .. Scalar Arguments ..
*       INTEGER            INFO, LDA, M, N
*       ..
*       .. Array Arguments ..
*       REAL               A( LDA, * ), TAU( * ), WORK( * )
*       ..
*  
*  Purpose
*  =======
*
*>\details \b Purpose:
*>\verbatim
*>
*> SGEQL2 computes a QL factorization of a real m by n matrix A:
*> A = Q * L.
*>
*>\endverbatim
*
*  Arguments
*  =========
*
*> \param[in] M
*> \verbatim
*>          M is INTEGER
*>          The number of rows of the matrix A.  M >= 0.
*> \endverbatim
*>
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The number of columns of the matrix A.  N >= 0.
*> \endverbatim
*>
*
*  Authors
*  =======
*
*> \author Univ. of Tennessee 
*> \author Univ. of California Berkeley 
*> \author Univ. of Colorado Denver 
*> \author NAG Ltd. 
*
*> \date November 2011
*
*> \ingroup realGEcomputational
*
*
*  Further Details
*  ===============
*>\details \b Further \b Details
*> \verbatim
*          (see Further Details).
*>
*>  LDA     (input) INTEGER
*>          The leading dimension of the array A.  LDA >= max(1,M).
*>
*>  TAU     (output) REAL array, dimension (min(M,N))
*>          The scalar factors of the elementary reflectors (see Further
*>          Details).
*>
*>  WORK    (workspace) REAL array, dimension (N)
*>
*>  INFO    (output) INTEGER
*>          = 0: successful exit
*>          < 0: if INFO = -i, the i-th argument had an illegal value
*>
*>
*>  The matrix Q is represented as a product of elementary reflectors
*>
*>     Q = H(k) . . . H(2) H(1), where k = min(m,n).
*>
*>  Each H(i) has the form
*>
*>     H(i) = I - tau * v * v**T
*>
*>  where tau is a real scalar, and v is a real vector with
*>  v(m-k+i+1:m) = 0 and v(m-k+i) = 1; v(1:m-k+i-1) is stored on exit in
*>  A(1:m-k+i-1,n-k+i), and tau in TAU(i).
*>
*> \endverbatim
*>
*  =====================================================================
      SUBROUTINE SGEQL2( M, N, A, LDA, TAU, WORK, INFO )
*
*  -- LAPACK computational routine (version 3.3.1) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     November 2011
*
*     .. Scalar Arguments ..
      INTEGER            INFO, LDA, M, N
*     ..
*     .. Array Arguments ..
      REAL               A( LDA, * ), TAU( * ), WORK( * )
*     ..
*
*  =====================================================================
*
*     .. Parameters ..
      REAL               ONE
      PARAMETER          ( ONE = 1.0E+0 )
*     ..
*     .. Local Scalars ..
      INTEGER            I, K
      REAL               AII
*     ..
*     .. External Subroutines ..
      EXTERNAL           SLARF, SLARFG, XERBLA
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          MAX, MIN
*     ..
*     .. Executable Statements ..
*
*     Test the input arguments
*
      INFO = 0
      IF( M.LT.0 ) THEN
         INFO = -1
      ELSE IF( N.LT.0 ) THEN
         INFO = -2
      ELSE IF( LDA.LT.MAX( 1, M ) ) THEN
         INFO = -4
      END IF
      IF( INFO.NE.0 ) THEN
         CALL XERBLA( 'SGEQL2', -INFO )
         RETURN
      END IF
*
      K = MIN( M, N )
*
      DO 10 I = K, 1, -1
*
*        Generate elementary reflector H(i) to annihilate
*        A(1:m-k+i-1,n-k+i)
*
         CALL SLARFG( M-K+I, A( M-K+I, N-K+I ), A( 1, N-K+I ), 1,
     $                TAU( I ) )
*
*        Apply H(i) to A(1:m-k+i,1:n-k+i-1) from the left
*
         AII = A( M-K+I, N-K+I )
         A( M-K+I, N-K+I ) = ONE
         CALL SLARF( 'Left', M-K+I, N-K+I-1, A( 1, N-K+I ), 1, TAU( I ),
     $               A, LDA, WORK )
         A( M-K+I, N-K+I ) = AII
   10 CONTINUE
      RETURN
*
*     End of SGEQL2
*
      END
