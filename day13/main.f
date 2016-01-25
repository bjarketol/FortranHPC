PROGRAM main
USE master
IMPLICIT NONE
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ INITIALIZE MPI ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
CALL MPI_INIT(ierr)
CALL MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
CALL MPI_COMM_SIZE(MPI_COMM_WORLD, nproc, ierr)

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ SET VARIABLES  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!

CALL read_namelist()

dx = (xmax-xmin)/(nx-1)
dy = (ymax-ymin)/(ny-1)

f = dx*dy
one_over_hsq = 1.0 / (dx*dy)

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ ALLOCATE AND INITIALIZE GLOBAL ARRAY ~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
ALLOCATE(u_global(ny,nx))

DO i = 1,nx
    DO j = 1, ny
        u_global(j,i) = 0.0
    ENDDO
ENDDO

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ SET MPI TOPO VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
ndims   = 2
dims(1) = ndimj
dims(2) = ndimi
periods(1) = .FALSE.
periods(2) = .FALSE.
reorder    = .FALSE.

CALL MPI_CART_CREATE(MPI_COMM_WORLD, ndims, dims, periods, reorder, &
                     comm_cart, ierr)
CALL MPI_COMM_RANK(comm_cart, rank_cart, ierr)
CALL MPI_CART_COORDS(comm_cart, rank_cart, ndims, coords_cart, ierr)

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ FIND IMEDIATE NEIGHBOURS AND GLOBAL BOUNDARIES ~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!

CALL MPI_CART_SHIFT(comm_cart,0,1,nghbr_top,nghbr_bottom,ierr)
CALL MPI_CART_SHIFT(comm_cart,1,1,nghbr_left,nghbr_right,ierr)

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ FIND LOCAL DIM/VARS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!

lpnx = nx / dims(2)
lpny = ny / dims(1)

lnx = lpnx
lny = lpny

IF (nghbr_left.NE.MPI_PROC_NULL) THEN
    lnx = lnx + 1
ENDIF

IF (nghbr_right.NE.MPI_PROC_NULL) THEN
    lnx = lnx + 1
ENDIF

IF (nghbr_bottom.NE.MPI_PROC_NULL) THEN
    lny = lny + 1
ENDIF

IF (nghbr_top.NE.MPI_PROC_NULL) THEN
    lny = lny + 1
ENDIF

i_cart = coords_cart(2)
j_cart = coords_cart(1)

limin = 1
limax = lnx

ljmin = 1
ljmax = lny

IF (nghbr_left.NE.MPI_PROC_NULL) THEN
    lpimin = 2
ELSE
    lpimin = 1
ENDIF

IF (nghbr_right.NE.MPI_PROC_NULL) THEN
    lpimax = lnx - 1
ELSE
    lpimax = lnx
ENDIF

IF (nghbr_bottom.NE.MPI_PROC_NULL) THEN
    lpjmin = 2
ELSE
    lpjmin = 1
ENDIF

IF (nghbr_top.NE.MPI_PROC_NULL) THEN
    lpjmax = lny - 1
ELSE 
    lpjmax = lny
ENDIF

gimin = 1 + i_cart*lpnx
gimax = gimin - 1 + lpnx

gjmin = 1 + j_cart*lpny
gjmax = gjmin - 1 + lpny

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ ALLOCATE AND INITIALIZE LOCAL ARRAY ~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!

ALLOCATE(u(lny,lnx))
DO i = 1,lnx
    DO j = 1,lny
        u(j,i) = 0.0
    ENDDO
ENDDO

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ ALLOCATE GHOST ARRAYS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!

ALLOCATE(ghst_top(lpny))
ALLOCATE(ghst_bottom(lpny))
ALLOCATE(ghst_left(lpnx))
ALLOCATE(ghst_right(lpnx))

PRINT*, rank, "coord", i_cart, j_cart
PRINT*, rank, "size", SIZE(u,1), size(u,2)
PRINT*, rank, "loc index", limin, limax, ljmin, ljmax
PRINT*, rank, "locp index", lpimin, lpimax, lpjmin, lpjmax
PRINT*, rank, "glob index", gimin, gimax, gjmin, gjmax
PRINT*, rank, "1/hsq, dx,dy", one_over_hsq, dx, dy
PRINT*, rank, "lpnx,lpny", lpnx, lpny
PRINT*, rank, "lnx,lny", lnx, lny
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ ALLOCATE AND INITIALIZE LOCAL ARRAY ~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
resi = resi_limit + 1.0
it = 0
DO WHILE (resi.GT.resi_limit.AND.it.LT.nstop)
    CALL rb_gs()
    CALL comm()
    CALL residual()
    !IF (rank.eq.0.and.mod(it,10).eq.0) THEN
    !    PRINT*, resi
    !ENDIF
    it = it + 1
ENDDO 

!DO i = 2,lnx-1
!    DO j = 2,lny-1
!        u_global(gjmin+(j-2),gimin+(i-2)) = u(j,i)
!    ENDDO
!ENDDO

CALL write2txt()
PRINT*, resi

CALL MPI_FINALIZE(ierr)
END PROGRAM main
