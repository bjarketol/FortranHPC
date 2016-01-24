PROGRAM main
USE master
USE random
IMPLICIT NONE

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ INITIALIZE MPI ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
CALL MPI_INIT(ierr)
CALL MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
CALL MPI_COMM_SIZE(MPI_COMM_WORLD, nproc, ierr)

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!

ni = 6
nj = 6

! MPI
ndims      = 2
dims(1)    = 2
dims(2)    = 2
periods(1) = .TRUE.
periods(2) = .TRUE.
reorder    = .FALSE.

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ ALLOCATE THE LARGE ARRAY ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!

ALLOCATE(ABIG(ni,nj))
ALLOCATE(BBIG(ni,nj))

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ INITIALIZE LARGE ARRAY WITH RANDOM NUMBERS ~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!

CALL init_random_seed()       
CALL RANDOM_NUMBER(ABIG)
CALL RANDOM_NUMBER(BBIG)

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ INITIALIZE CARTISIAN COMM  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!

CALL MPI_CART_CREATE(MPI_COMM_WORLD, ndims, dims, periods, reorder, &
                     comm_cart, ierr)
CALL MPI_COMM_RANK(comm_cart, rank_cart, ierr)
CALL MPI_CART_COORDS(comm_cart, rank_cart, ndims, coords_cart, ierr)

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ FIND IMEDIATE NEIGHBOURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!

CALL MPI_CART_SHIFT(comm_cart,0,1,neigh_top,neigh_bottom,ierr)
CALL MPI_CART_SHIFT(comm_cart,1,1,neigh_left,neigh_right,ierr)

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~ INITIALIZE LOCAL SUBARRAYS A,B ~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!

lni = ni / dims(1)
lnj = nj / dims(2)

ALLOCATE(ASELF(lni,lnj))
ALLOCATE(BSELF(lni,lnj))
ALLOCATE(A(lni,lnj))
ALLOCATE(B(lni,lnj))
ALLOCATE(C(lni,lnj))

gimin = 1 + lni*coords_cart(1)
gimax = gimin + lni - 1
gjmin = 1 + lnj*coords_cart(2)
gjmax = gjmin + lnj - 1

!
DO j = 1,lnj
    DO i = 1,lni
        ASELF(i,j) = ABIG(gimin+(i-1),gjmin+(j-1))
        BSELF(i,j) = BBIG(gimin+(i-1),gjmin+(j-1))
    ENDDO
ENDDO

CALL matrix_mult(ASELF,BSELF,C)

!PRINT*, ABIG
!PRINT*, BBIG

!PRINT*, "A",A
!PRINT*, "B",B
!PRINT*, "C",C

CALL MPI_FINALIZE(ierr)
END PROGRAM main
