      SUBROUTINE STPMQRT( SIDE, TRANS, M, N, K, L, NB, V, LDV, T, LDT,
     $                    A, LDA, B, LDB, WORK, INFO )
      IMPLICIT NONE
*
*  -- LAPACK routine (version 3.?) --
*  -- LAPACK is a software package provided by Univ. of Tennessee, --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd. --
*  -- July 2011 --
*
*     .. Scalar Arguments ..
      CHARACTER SIDE, TRANS
      INTEGER   INFO, K, LDV, LDA, LDB, M, N, L, NB, LDT
*     ..
*     .. Array Arguments ..
      REAL   V( LDV, * ), A( LDA, * ), B( LDB, * ), T( LDT, * ), 
     $          WORK( * )
*     ..
*
*  Purpose
*  =======
*
*  STPMQRT applies a real orthogonal matrix Q obtained from a 
*  "triangular-pentagonal" real block reflector H to a general
*  real matrix C, which consists of two blocks A and B.
*
*  Arguments
*  =========
*
*  SIDE    (input) CHARACTER*1
*          = 'L': apply Q or Q^H from the Left;
*          = 'R': apply Q or Q^H from the Right.
*
*  TRANS   (input) CHARACTER*1
*          = 'N':  No transpose, apply Q;
*          = 'C':  Transpose, apply Q^H.
*
*  M       (input) INTEGER
*          The number of rows of the matrix B. M >= 0.
*
*  N       (input) INTEGER
*          The number of columns of the matrix B. N >= 0.
* 
*  K       (input) INTEGER
*          The number of elementary reflectors whose product defines
*          the matrix Q.
*
*  L       (input) INTEGER
*          The order of the trapezoidal part of V.  
*          K >= L >= 0.  See Further Details.
*
*  NB      (input) INTEGER
*          The block size used for the storage of T.  K >= NB >= 1.
*          This must be the same value of NB used to generate T
*          in CTPQRT.
*
*  V       (input) REAL array, dimension (LDA,K)
*          The i-th column must contain the vector which defines the
*          elementary reflector H(i), for i = 1,2,...,k, as returned by
*          CTPQRT in B.  See Further Details.
*
*  LDA     (input) INTEGER
*          The leading dimension of the array A.
*          If SIDE = 'L', LDA >= max(1,M);
*          if SIDE = 'R', LDA >= max(1,N).
*
*  T       (input) REAL array, dimension (LDT,K)
*          The upper triangular factors of the block reflectors
*          as returned by CTPQRT, stored as a NB-by-K matrix.
*
*  LDT     (input) INTEGER
*          The leading dimension of the array T.  LDT >= NB.
*
*  A       (input/output) REAL array, dimension 
*          (LDA,N) if SIDE = 'L' or 
*          (LDA,K) if SIDE = 'R'
*          On entry, the K-by-N or M-by-K matrix A.
*          On exit, A is overwritten by the corresponding block of 
*          Q*C or Q^H*C or C*Q or C*Q^H.  See Further Details.
*
*  LDA     (input) INTEGER
*          The leading dimension of the array A. 
*          If SIDE = 'L', LDC >= max(1,K);
*          If SIDE = 'R', LDC >= max(1,M). 
*
*  B       (input/output) REAL array, dimension (LDB,N)
*          On entry, the M-by-N matrix B.
*          On exit, B is overwritten by the corresponding block of
*          Q*C or Q^H*C or C*Q or C*Q^H.  See Further Details.
*
*  LDB     (input) INTEGER
*          The leading dimension of the array B. 
*          LDB >= max(1,M).
*
*  WORK    (workspace/output) REAL array.  The dimension of WORK is
*           N*NB if SIDE = 'L', or  M*NB if SIDE = 'R'.
*
*  INFO    (output) INTEGER
*          = 0:  successful exit
*          < 0:  if INFO = -i, the i-th argument had an illegal value
*
*  Further Details
*  ===============
*
*  The columns of the pentagonal matrix V contain the elementary reflectors
*  H(1), H(2), ..., H(K); V is composed of a rectangular block V1 and a 
*  trapezoidal block V2:
*
*        V = [V1]
*            [V2].
*
*  The size of the trapezoidal block V2 is determined by the parameter L, 
*  where 0 <= L <= K; V2 is upper trapezoidal, consisting of the first L
*  rows of a K-by-K upper triangular matrix.  If L=K, V2 is upper triangular;
*  if L=0, there is no trapezoidal block, hence V = V1 is rectangular.
*
*  If SIDE = 'L':  C = [A]  where A is K-by-N,  B is M-by-N and V is M-by-K. 
*                      [B]   
*  
*  If SIDE = 'R':  C = [A B]  where A is M-by-K, B is M-by-N and V is N-by-K.
*
*  The real orthogonal matrix Q is formed from V and T.
*
*  If TRANS='N' and SIDE='L', C is on exit replaced with Q * C.
*
*  If TRANS='C' and SIDE='L', C is on exit replaced with Q^H * C.
*
*  If TRANS='N' and SIDE='R', C is on exit replaced with C * Q.
*
*  If TRANS='C' and SIDE='R', C is on exit replaced with C * Q^H.
*
*  =====================================================================
*
*     ..
*     .. Local Scalars ..
      LOGICAL            LEFT, RIGHT, TRAN, NOTRAN
      INTEGER            I, IB, MB, LB, KF, Q
*     ..
*     .. External Functions ..
      LOGICAL            LSAME
      EXTERNAL           LSAME
*     ..
*     .. External Subroutines ..
      EXTERNAL           XERBLA, SLARFB
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          MAX, MIN
*     ..
*     .. Executable Statements ..
*
*     .. Test the input arguments ..
*
      INFO   = 0
      LEFT   = LSAME( SIDE,  'L' )
      RIGHT  = LSAME( SIDE,  'R' )
      TRAN   = LSAME( TRANS, 'T' )
      NOTRAN = LSAME( TRANS, 'N' )
*      
      IF( LEFT ) THEN
         Q = M
      ELSE IF ( RIGHT ) THEN
         Q = N
      END IF
      IF( .NOT.LEFT .AND. .NOT.RIGHT ) THEN
         INFO = -1
      ELSE IF( .NOT.TRAN .AND. .NOT.NOTRAN ) THEN
         INFO = -2
      ELSE IF( M.LT.0 ) THEN
         INFO = -3
      ELSE IF( N.LT.0 ) THEN
         INFO = -4
      ELSE IF( K.LT.0 ) THEN
         INFO = -5
      ELSE IF( L.LT.0 .OR. L.GT.K ) THEN
         INFO = -6         
      ELSE IF( NB.LT.1 .OR. NB.GT.K ) THEN
         INFO = -7
      ELSE IF( LDV.LT.MAX( 1, Q ) ) THEN
         INFO = -8
      ELSE IF( LDT.LT.NB ) THEN
         INFO = -10
      ELSE IF( LDA.LT.MAX( 1, M ) ) THEN
         INFO = -12
      ELSE IF( LDB.LT.MAX( 1, M ) ) THEN
         INFO = -12
      END IF
*
      IF( INFO.NE.0 ) THEN
         CALL XERBLA( 'STPMQRT', -INFO )
         RETURN
      END IF
*
*     .. Quick return if possible ..
*
      IF( M.EQ.0 .OR. N.EQ.0 .OR. K.EQ.0 ) RETURN
*
      IF( LEFT .AND. TRAN ) THEN
*
         DO I = 1, K, NB
            IB = MIN( NB, K-I+1 )
            MB = MIN( M-L+I+IB-1, M )
            IF( I.GE.L ) THEN
               LB = 0
            ELSE
               LB = MB-M+L-I+1
            END IF
            CALL STPRFB( 'L', 'T', 'F', 'C', MB, N, IB, LB, 
     $                   V( 1, I ), LDV, T( 1, I ), LDT, 
     $                   A( I, 1 ), LDA, B, LDB, WORK, IB )
         END DO
*         
      ELSE IF( RIGHT .AND. NOTRAN ) THEN
*
         DO I = 1, K, NB
            IB = MIN( NB, K-I+1 )
            MB = MIN( N-L+I+IB-1, N )
            IF( I.GE.L ) THEN
               LB = 0
            ELSE
               LB = MB-N+L-I+1
            END IF
            CALL STPRFB( 'R', 'N', 'F', 'C', M, MB, IB, LB, 
     $                   V( 1, I ), LDV, T( 1, I ), LDT, 
     $                   A( 1, I ), LDA, B, LDB, WORK, M )
         END DO
*
      ELSE IF( LEFT .AND. NOTRAN ) THEN
*
         KF = ((K-1)/NB)*NB+1
         DO I = KF, 1, -NB
            IB = MIN( NB, K-I+1 )  
            MB = MIN( M-L+I+IB-1, M )
            IF( I.GE.L ) THEN
               LB = 0
            ELSE
               LB = MB-M+L-I+1
            END IF                   
            CALL STPRFB( 'L', 'N', 'F', 'C', MB, N, IB, LB,
     $                   V( 1, I ), LDV, T( 1, I ), LDT, 
     $                   A( I, 1 ), LDA, B, LDB, WORK, IB )
         END DO
*
      ELSE IF( RIGHT .AND. TRAN ) THEN
*
         KF = ((K-1)/NB)*NB+1
         DO I = KF, 1, -NB
            IB = MIN( NB, K-I+1 )         
            MB = MIN( N-L+I+IB-1, N )
            IF( I.GE.L ) THEN
               LB = 0
            ELSE
               LB = MB-N+L-I+1
            END IF
            CALL STPRFB( 'R', 'T', 'F', 'C', M, MB, IB, LB,
     $                   V( 1, I ), LDV, T( 1, I ), LDT, 
     $                   A( 1, I ), LDA, B, LDB, WORK, M )
         END DO
*
      END IF
*
      RETURN
*
*     End of STPMQRT
*
      END
