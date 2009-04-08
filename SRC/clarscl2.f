      SUBROUTINE CLARSCL2 ( M, N, D, X, LDX )
*
*     -- LAPACK routine (version 3.2)                                 --
*     -- Contributed by James Demmel, Deaglan Halligan, Yozo Hida and --
*     -- Jason Riedy of Univ. of California Berkeley.                 --
*     -- November 2008                                                --
*
*     -- LAPACK is a software package provided by Univ. of Tennessee, --
*     -- Univ. of California Berkeley and NAG Ltd.                    --
*
      IMPLICIT NONE
*     ..
*     .. Scalar Arguments ..
      INTEGER            M, N, LDX
*     ..
*     .. Array Arguments ..
      COMPLEX            X( LDX, * )
      REAL               D( * )
*     ..
*
*  Purpose
*  =======
*
*  CLARSCL2 performs a reciprocal diagonal scaling on an vector:
*    x <-- inv(D) * x
*  where the REAL diagonal matrix D is stored as a vector.
*
*  Eventually to be replaced by BLAS_cge_diag_scale in the new BLAS
*  standard.
*
*  Arguments
*  =========
*
*     M       (input) INTEGER
*     The number of rows of D and X. M >= 0.
*
*     N       (input) INTEGER
*     The number of columns of D and X. N >= 0.
*
*     D       (input) REAL array, length M
*     Diagonal matrix D, stored as a vector of length M.
*
*     X       (input/output) COMPLEX array, dimension (LDX,N)
*     On entry, the vector X to be scaled by D.
*     On exit, the scaled vector.
*
*     LDX     (input) INTEGER
*     The leading dimension of the vector X. LDX >= 0.
*
*  =====================================================================
*
*     .. Local Scalars ..
      INTEGER            I, J
*     ..
*     .. Executable Statements ..
*
      DO J = 1, N
         DO I = 1, M
            X( I, J ) = X( I, J ) / D( I )
         END DO
      END DO

      RETURN
      END

