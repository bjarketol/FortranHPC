MODULE master
IMPLICIT NONE
INCLUDE "mpif.h"

REAL*8, PARAMETER :: one_fourth = 0.2500000000
REAL*8, DIMENSION(:,:), ALLOCATABLE :: u, u_global
REAL*8, DIMENSION(:), ALLOCATABLE :: ghst_top, ghst_bottom
REAL*8, DIMENSION(:), ALLOCATABLE :: ghst_left, ghst_right
REAL*8 :: xmin,xmax,dx
REAL*8 :: ymin,ymax,dy
REAL*8 :: f
REAL*8 :: resi, lresi, resi_limit, iresi
REAL*8 :: one_over_hsq

INTEGER :: nx,ny
INTEGER :: lnx,lny
INTEGER :: lpnx,lpny
INTEGER :: nstop
INTEGER :: i,j, ii,jj
INTEGER :: it

INTEGER :: STATUS(MPI_STATUS_SIZE)
INTEGER :: ierr, rank, nproc
INTEGER :: ndims, dims(2), comm_cart 
INTEGER :: rank_cart, coords_cart(2)
INTEGER :: i_cart, j_cart
INTEGER :: limin, limax, lpimin, lpimax, gimin, gimax
INTEGER :: ljmin, ljmax, lpjmin, lpjmax, gjmin, gjmax
INTEGER :: nghbr_top, nghbr_bottom, nghbr_left, nghbr_right

INTEGER :: ndimi, ndimj

LOGICAL :: periods(2), reorder

END MODULE master
