MODULE master
IMPLICIT NONE
INCLUDE "mpif.h"
REAL*8, DIMENSION(:,:), ALLOCATABLE :: u, u_global
REAL*8 :: xmin,xmax,dx
REAL*8 :: ymin,ymax,dy
INTEGER :: nx,ny
INTEGER :: lnx,lny
INTEGER :: nstop
END MODULE master
