*> \brief \b CLACGV
*
*  =========== DOCUMENTATION ===========
*
* Online html documentation available at 
*            http://www.netlib.org/lapack/explore-html/ 
*
*  Definition
*  ==========
*
*       SUBROUTINE CLACGV( N, X, INCX )
* 
*       .. Scalar Arguments ..
*       INTEGER            INCX, N
*       ..
*       .. Array Arguments ..
*       COMPLEX            X( * )
*       ..
*  
*  Purpose
*  =======
*
*>\details \b Purpose:
*>\verbatim
*>
*> CLACGV conjugates a complex vector of length N.
*>
*>\endverbatim
*
*  Arguments
*  =========
*
*> \param[in] N
*> \verbatim
*>          N is INTEGER
*>          The length of the vector X.  N >= 0.
*> \endverbatim
*>
*> \param[in,out] X
*> \verbatim
*>          X is COMPLEX array, dimension
*>                         (1+(N-1)*abs(INCX))
*>          On entry, the vector of length N to be conjugated.
*>          On exit, X is overwritten with conjg(X).
*> \endverbatim
*>
*> \param[in] INCX
*> \verbatim
*>          INCX is INTEGER
*>          The spacing between successive elements of X.
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
*> \ingroup complexOTHERauxiliary
*
*  =====================================================================
      SUBROUTINE CLACGV( N, X, INCX )
*
*  -- LAPACK auxiliary routine (version 3.2) --
*  -- LAPACK is a software package provided by Univ. of Tennessee,    --
*  -- Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd..--
*     November 2011
*
*     .. Scalar Arguments ..
      INTEGER            INCX, N
*     ..
*     .. Array Arguments ..
      COMPLEX            X( * )
*     ..
*
* =====================================================================
*
*     .. Local Scalars ..
      INTEGER            I, IOFF
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          CONJG
*     ..
*     .. Executable Statements ..
*
      IF( INCX.EQ.1 ) THEN
         DO 10 I = 1, N
            X( I ) = CONJG( X( I ) )
   10    CONTINUE
      ELSE
         IOFF = 1
         IF( INCX.LT.0 )
     $      IOFF = 1 - ( N-1 )*INCX
         DO 20 I = 1, N
            X( IOFF ) = CONJG( X( IOFF ) )
            IOFF = IOFF + INCX
   20    CONTINUE
      END IF
      RETURN
*
*     End of CLACGV
*
      END
