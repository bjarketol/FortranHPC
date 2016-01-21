PROGRAM main
USE master
IMPLICIT NONE
INTEGER :: STATUS(MPI_STATUS_SIZE)
INTEGER :: ierr, rank, nproc
INTEGER :: ndims, dims(2), comm_cart 
INTEGER :: i, rank_cart, coords_cart(2)
INTEGER :: i_cart, j_cart
INTEGER :: limin, limax, gimin, gimax
INTEGER :: ljmin, ljmax, gjmin, gjmax
LOGICAL :: periods(2), reorder

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ INITIALIZE MPI ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
CALL MPI_INIT(ierr)
CALL MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
CALL MPI_COMM_SIZE(MPI_COMM_WORLD, nproc, ierr)

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ SET VARIABLES  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
nx = 100 
ny = 100 

xmin = 0.0
xmax = 1.0
ymin = 0.0
ymax = 1.0

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ SET MPI TOPO VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
ndims   = 2
dims(1) = 2
dims(2) = 2
periods(1) = .FALSE.
periods(2) = .FALSE.
reorder    = .FALSE.

CALL MPI_CART_CREATE(MPI_COMM_WORLD, ndims, dims, periods, reorder, &
                     comm_cart, ierr)
CALL MPI_COMM_RANK(comm_cart, rank_cart, ierr)
CALL MPI_CART_COORDS(comm_cart, rank_cart, ndims, coords_cart, ierr)

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ FIND LOCAL DIM/VARS~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
lnx = nx / 2 + 1 
lny = ny / 2 + 1

i_cart = coords_cart(1)
j_cart = coords_cart(2)

limin = 0
limax = lnx

ljmin = 0
ljmax = lny

gimin = i_cart * (lnx-1)
gimax = gimin + (lnx-1) 

gjmin = j_cart * (lny-1)
gjmax = gjmin + (lny-1)

PRINT*, rank_cart, limin,limax,gimin,gimax
PRINT*, rank_cart, ljmin,ljmax,gjmin,gjmax

CALL MPI_FINALIZE(ierr)
END PROGRAM main
