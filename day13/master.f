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

CONTAINS

    SUBROUTINE read_namelist()
    CHARACTER(LEN=*), PARAMETER :: nlfile = "name.list"
    NAMELIST /namdim/ nx,ny,nstop,xmin,xmax,ymin,ymax,ndimi,ndimj
    OPEN(10,FILE=nlfile)
    READ(10,namdim)
    END SUBROUTINE read_namelist

    SUBROUTINE write2txt()
    CHARACTER(LEN = 200) :: string

    WRITE(string, "(A,I2.2,A)") "out/output",rank,".dat"
    
    open(13, file=string, status="replace", action="write")

    DO i = 1,lpnx
        DO j = 1,lpny
        ii = (lpimin-1)+i
        jj = (lpjmin-1)+j
        WRITE(13, "(3E12.4)") REAL(gimin-1+i-1)*dx, REAL(gjmin-1+j-1)*dy, u(jj, ii)
      ENDDO
    ENDDO
    CLOSE(13)

    END SUBROUTINE write2txt

    SUBROUTINE residual()
    lresi = 0.0
    DO i = 2,lpnx
        DO j = 2,lpny
            lresi = lresi + ABS(                 &
                    one_over_hsq * (u(j  ,i+1) + &
                                    u(j  ,i-1) + &
                                    u(j+1,i  ) + & 
                                    u(j-1,i  ) - &
                                4.0*u(j  ,i  ))-1.0)
        ENDDO
    ENDDO
    
    CALL MPI_BARRIER(comm_cart, ierr) 
    CALL MPI_ALLREDUCE_(lresi, resi, 1, MPI_DOUBLE_PRECISION, &
                        MPI_SUM, comm_cart, ierr)

    END SUBROUTINE residual

    SUBROUTINE comm() 
    IF (nghbr_top.NE.MPI_PROC_NULL) THEN
        ghst_top(:) = u(2,lpimin:lpimax)
        CALL MPI_SENDRECV_REPLACE(ghst_top, lny-2, MPI_DOUBLE_PRECISION, &
                             nghbr_top, 0, nghbr_top, 0, &
                             comm_cart, STATUS, ierr)
        u(1,lpimin:lpimax) = ghst_top(:)
    ENDIF
    IF (nghbr_bottom.NE.MPI_PROC_NULL) THEN
        ghst_bottom(:) = u(lny-1,lpimin:lpimax)
        CALL MPI_SENDRECV_REPLACE(ghst_bottom, lny-2, MPI_DOUBLE_PRECISION, &
                             nghbr_bottom, 0, nghbr_bottom, 0, &
                             comm_cart, STATUS, ierr)
        u(lny,lpimin:lpimax) = ghst_bottom(:)
    ENDIF
    IF (nghbr_right.NE.MPI_PROC_NULL) THEN
        ghst_right(:) = u(lpjmin:lpjmax,lnx-1)
        CALL MPI_SENDRECV_REPLACE(ghst_right, lnx-2, MPI_DOUBLE_PRECISION, &
                             nghbr_right, 0, nghbr_right, 0, &
                             comm_cart, STATUS, ierr)
        u(lpjmin:lpjmax,lnx) = ghst_right(:)
    ENDIF
    IF (nghbr_left.NE.MPI_PROC_NULL) THEN
        ghst_left(:) = u(lpjmin:lpjmax,2)
        CALL MPI_SENDRECV_REPLACE(ghst_left, lnx-2, MPI_DOUBLE_PRECISION, &
                             nghbr_left, 0, nghbr_left, 0, &
                             comm_cart, STATUS, ierr)
        u(lpjmin:lpjmax,1) = ghst_left
    ENDIF  
    CALL MPI_BARRIER(comm_cart, ierr)
    END SUBROUTINE comm

    SUBROUTINE rb_gs()
    DO i=3,lnx-1,2
        DO j=2,lny-1,2
            u(j,i) = one_fourth*(u(j,  i+1) + &
                                 u(j,  i-1) + &
                                 u(j+1,i  ) + &
                                 u(j-1,i  ) - &
                                 f)
        ENDDO
    ENDDO
    DO i=2,lnx-1,2
        DO j=3,lny-1,2
            u(j,i) = one_fourth*(u(j,  i+1) + &
                                 u(j,  i-1) + &
                                 u(j+1,i  ) + &
                                 u(j-1,i  ) - &
                                 f)
        ENDDO
    ENDDO
    DO i=2,lnx-1,2
        DO j=2,lny-1,2
            u(j,i) = one_fourth*(u(j,  i+1) + &
                                 u(j,  i-1) + &
                                 u(j+1,i  ) + &
                                 u(j-1,i  ) - &
                                 f)
        ENDDO
    ENDDO
    DO i=3,lnx-1,2
        DO j=3,lny-1,2
            u(j,i) = one_fourth*(u(j,  i+1) + &
                                 u(j,  i-1) + &
                                 u(j+1,i  ) + &
                                 u(j-1,i  ) - &
                                 f)
        ENDDO
    ENDDO    
    END SUBROUTINE rb_gs

END MODULE master
