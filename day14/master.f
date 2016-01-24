MODULE master
IMPLICIT NONE
INCLUDE "mpif.h"

PUBLIC :: matrix_mult

REAL, DIMENSION(:,:), ALLOCATABLE :: ABIG, BBIG
REAL, DIMENSION(:,:), ALLOCATABLE :: ASELF, BSELF
REAL, DIMENSION(:,:), ALLOCATABLE :: A, B, C

INTEGER :: i, j
INTEGER :: ni, nj
INTEGER :: lni, lnj 
INTEGER :: gimin, gimax, gjmin, gjmax

! MPI VARIABLES
INTEGER :: ierr, STATUS(MPI_STATUS_SIZE)
INTEGER :: rank, nproc
INTEGER :: ndims, dims(2)
INTEGER :: rank_cart, comm_cart
INTEGER :: coords_cart(2)

INTEGER :: neigh_top, neigh_bottom, neigh_left, neigh_right

LOGICAL :: periods(2), reorder


CONTAINS
   
  SUBROUTINE fox()
  END SUBROUTINE fox 

  SUBROUTINE matrix_mult(AA,BB,CC)
  REAL, DIMENSION(:,:), INTENT(IN) :: AA,BB
  REAL, DIMENSION(:,:), INTENT(OUT) :: CC
  INTEGER :: row, column, N
  N = SIZE(A,1)
  DO row=1,N
    DO column=1,N
      CC(column,row) = CC(column,row) + SUM(AA(:,row)*BB(column,:))
    ENDDO
  ENDDO
  END SUBROUTINE matrix_mult

END MODULE master
