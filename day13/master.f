MODULE master
IMPLICIT NONE
INCLUDE "mpif.h"

PUBLIC :: rb_gs, comm, write2txt

REAL*8, PARAMETER :: one_fourth = 0.2500000000
REAL*8, DIMENSION(:,:), ALLOCATABLE :: u, u_global
REAL*8, DIMENSION(:), ALLOCATABLE :: ghst_top, ghst_bottom
REAL*8, DIMENSION(:), ALLOCATABLE :: ghst_left, ghst_right
REAL*8 :: xmin,xmax,dx
REAL*8 :: ymin,ymax,dy
REAL*8 :: f
REAL*8 :: resi, lresi
REAL*8 :: one_over_hsq

INTEGER :: nx,ny
INTEGER :: lnx,lny
INTEGER :: nstop
INTEGER :: i,j
INTEGER :: it

INTEGER :: STATUS(MPI_STATUS_SIZE)
INTEGER :: ierr, rank, nproc
INTEGER :: ndims, dims(2), comm_cart 
INTEGER :: rank_cart, coords_cart(2)
INTEGER :: i_cart, j_cart
INTEGER :: limin, limax, gimin, gimax
INTEGER :: ljmin, ljmax, gjmin, gjmax
INTEGER :: nghbr_top, nghbr_bottom, nghbr_left, nghbr_right

LOGICAL :: periods(2), reorder

CONTAINS

    SUBROUTINE write2txt()
    CHARACTER(LEN = 200) :: string
    LOGICAL :: exists

    WRITE(string, "(A)") "/home/btol/Dropbox/HPC/code/day13/output.dat"
    
    !inquire(file=string, exist=exists)
    !if (exists) then
    open(13, file=string, status="old", position="append", action="write")
    !else
    !open(13, file=string, status="new", action="write")
    !end if

    DO j = 2, lny-1
      DO i = 2, lnx-1
        WRITE(13, "(3E12.4)") REAL((gimin-1)+i-1)*dx, REAL((gjmin-1)+j-1)*dy, u(i, j)
      ENDDO
    ENDDO
    CLOSE(13)

    END SUBROUTINE write2txt

    SUBROUTINE residual()
    lresi = 0.0
    DO j = 2,lny-1
        DO i = 2,lnx-1
            lresi = lresi + ABS(                 &
                    one_over_hsq * (u(i+1,  j) + &
                                    u(i-1,  j) + &
                                    u(i  ,j+1) + & 
                                    u(i  ,j-1) - &
                                4.0*u(i  ,j  ))-1.0)
        ENDDO
    ENDDO
    
    CALL MPI_BARRIER(comm_cart, ierr) 
    CALL MPI_ALLREDUCE_(lresi, resi, 1, MPI_DOUBLE_PRECISION, &
                        MPI_SUM, comm_cart, ierr)

    END SUBROUTINE residual

    SUBROUTINE comm() 
    IF (nghbr_top.NE.MPI_PROC_NULL) THEN
        ghst_top(:) = u(2,2:lny-1)
        CALL MPI_SENDRECV_REPLACE(ghst_top, lny-2, MPI_DOUBLE_PRECISION, &
                             nghbr_top, 0, nghbr_top, 0, &
                             comm_cart, STATUS, ierr)
        u(1,2:lny-1) = ghst_top
    ENDIF
    IF (nghbr_bottom.NE.MPI_PROC_NULL) THEN
        ghst_bottom(:) = u(lnx-1,2:lny-1)
        CALL MPI_SENDRECV_REPLACE(ghst_bottom, lny-2, MPI_DOUBLE_PRECISION, &
                             nghbr_bottom, 0, nghbr_bottom, 0, &
                             comm_cart, STATUS, ierr)
        u(lnx,2:lny-1) = ghst_bottom
    ENDIF
    IF (nghbr_right.NE.MPI_PROC_NULL) THEN
        ghst_right(:) = u(2:lnx-1,lny-1)
        CALL MPI_SENDRECV_REPLACE(ghst_right, lnx-2, MPI_DOUBLE_PRECISION, &
                             nghbr_right, 0, nghbr_right, 0, &
                             comm_cart, STATUS, ierr)
        u(2:lnx-1,lny) = ghst_right
    ENDIF
    IF (nghbr_left.NE.MPI_PROC_NULL) THEN
        ghst_left(:) = u(2:lnx-1,2)
        CALL MPI_SENDRECV_REPLACE(ghst_left, lnx-2, MPI_DOUBLE_PRECISION, &
                             nghbr_left, 0, nghbr_left, 0, &
                             comm_cart, STATUS, ierr)
        u(2:lnx-1,1) = ghst_left
    ENDIF  
    CALL MPI_BARRIER(comm_cart, ierr)
    END SUBROUTINE comm

    SUBROUTINE rb_gs()
    DO j=2,lny-1,2
        DO i=3,lnx-1,2
            u(i,j) = one_fourth*(u(i+1,j  ) + &
                                 u(i-1,j  ) + &
                                 u(i  ,j+1) + &
                                 u(i  ,j-1) - &
                                 f)
        ENDDO
    ENDDO
    DO j=3,lny-1,2
        DO i=2,lnx-1,2
            u(i,j) = one_fourth*(u(i+1,j  ) + &
                                 u(i-1,j  ) + &
                                 u(i  ,j+1) + &
                                 u(i  ,j-1) - &
                                 f)
        ENDDO
    ENDDO
    DO j=2,lny-1,2
        DO i=2,lnx-1,2
            u(i,j) = one_fourth*(u(i+1,j  ) + &
                                 u(i-1,j  ) + &
                                 u(i  ,j+1) + &
                                 u(i  ,j-1) - &
                                 f)
        ENDDO
    ENDDO
    DO j=3,lny-1,2
        DO i=3,lnx-1,2
            u(i,j) = one_fourth*(u(i+1,j  ) + &
                                 u(i-1,j  ) + &
                                 u(i  ,j+1) + &
                                 u(i  ,j-1) - &
                                 f)
        ENDDO
    ENDDO    
    END SUBROUTINE rb_gs

END MODULE master
