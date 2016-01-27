MODULE master
!USE random
IMPLICIT NONE
INCLUDE "mpif.h"

REAL, DIMENSION(:,:), ALLOCATABLE :: ABIG, BBIG, CBIG
REAL, DIMENSION(:,:), ALLOCATABLE :: ASELF, BSELF
REAL, DIMENSION(:,:), ALLOCATABLE :: A, B, C

INTEGER :: i, j, ii, jj
INTEGER :: ir, jr
INTEGER :: stage, q
INTEGER :: ni, nj, n
INTEGER :: lni, lnj
INTEGER :: icoord, jcoord
INTEGER :: gimin, gimax, gjmin, gjmax

INTEGER :: icr, jcr, iccr, jccr, rrank, rcoords(2)

! MPI VARIABLES
INTEGER :: ierr, STATUS(MPI_STATUS_SIZE)
INTEGER :: rank, nproc
INTEGER :: ndims, dims(2)
INTEGER :: rank_cart, comm_cart
INTEGER :: coords_cart(2)
INTEGER :: neigh_top, neigh_bottom, neigh_left, neigh_right
INTEGER :: comm_row, comm_col
INTEGER :: bcast_root

LOGICAL :: periods(2), reorder
LOGICAL :: row_free(2), col_free(2)


CONTAINS

    SUBROUTINE print_ji_result()
    
    !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    !~~~~   FIND OUT WHERE result data is locetated      ~~~~~~~~~~~~!
    !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!

    iccr = ir/(ni/q)
    jccr = jr/(nj/q)

    icr = ir - iccr*lni + 1
    jcr = jr - jccr*lnj + 1

    rcoords(1) = jccr
    rcoords(2) = iccr

    CALL MPI_CART_RANK(comm_cart, rcoords, rrank, ierr)

    IF (rank .EQ. rrank) THEN
        PRINT*, iccr, jccr
        PRINT*, icr, jcr
        PRINT*, C(jcr, icr)
    ENDIF

    END SUBROUTINE print_ji_result
    
    SUBROUTINE generate_sub_matrix_lin()

    DO i = 1,lni
        ii = i + icoord*lni
        DO j = 1,lnj
            ASELF(j,i) = REAL(ii)
            BSELF(j,i) = REAL(ii)
        ENDDO
    ENDDO

    A(:,:) = ASELF(:,:)
    B(:,:) = BSELF(:,:)
    C(:,:) = 0.0

    END SUBROUTINE generate_sub_matrix_lin
  
    SUBROUTINE generate_sub_matrix_cos()

    DO i = 1,lni
        DO j = 1,lnj
            ii = (i-1)+lni*icoord
            jj = (j-1)+lnj*jcoord
            ASELF(j,i) = COS(REAL(ii*n+jj))
            BSELF(j,i) = COS(REAL(ii*n+jj))
        ENDDO
    ENDDO

    A(:,:) = ASELF(:,:)
    B(:,:) = BSELF(:,:)
    C(:,:) = 0.0

    END SUBROUTINE generate_sub_matrix_cos

    !SUBROUTINE generate_sub_matrix_random()
    !CALL init_random_seed()       
    !CALL RANDOM_NUMBER(ABIG)
    !CALL RANDOM_NUMBER(BBIG)
    !
    !! INIT LOCAL A AND B
    !DO i = 1,lni
    !    DO j = 1,lnj
    !        ASELF(j,i) = ABIG(gjmin+(j-1),gimin+(i-1))
    !        BSELF(j,i) = BBIG(gjmin+(j-1),gimin+(i-1))
    !    ENDDO
    !ENDDO

    !! INIT TEMP A,B,C
    !A(:,:) = ASELF(:,:)
    !B(:,:) = BSELF(:,:)
    !C(:,:) = 0.0

    !END SUBROUTINE generate_sub_matrix_random

    SUBROUTINE initialize()

    !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    !~~~~~~~ ALLOCATE THE LARGE ARRAY ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    ALLOCATE(ABIG(nj,ni))
    ALLOCATE(BBIG(nj,ni))
    ALLOCATE(CBIG(nj,ni))

    !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    !~~~~~ INITIALIZE LOCAL SUBARRAYS A,B ~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!

    icoord = coords_cart(2)
    jcoord = coords_cart(1)

    lni = ni / dims(2)
    lnj = nj / dims(1)

    ALLOCATE(ASELF(lnj,lni))
    ALLOCATE(BSELF(lnj,lni))
    ALLOCATE(A(lnj,lni))
    ALLOCATE(B(lnj,lni))
    ALLOCATE(C(lnj,lni))

    gimin = 1 + lni*coords_cart(2)
    gimax = gimin + lni - 1
    gjmin = 1 + lnj*coords_cart(1)
    gjmax = gjmin + lnj - 1

    END SUBROUTINE initialize

    SUBROUTINE generate_communicators()
    
    CALL MPI_CART_CREATE(MPI_COMM_WORLD, ndims, dims, periods, reorder, &
                         comm_cart, ierr)
    CALL MPI_COMM_RANK(comm_cart, rank_cart, ierr)
    CALL MPI_CART_COORDS(comm_cart, rank_cart, ndims, coords_cart, ierr)

    !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    !~~~~~~ FIND IMEDIATE NEIGHBOURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!

    CALL MPI_CART_SHIFT(comm_cart,0,1,neigh_top,neigh_bottom,ierr)

    ! Row communicator
    row_free(1) = .FALSE.
    row_free(2) = .TRUE.
    CALL MPI_CART_SUB(comm_cart, row_free, comm_row, ierr)

    ! Col communicator
    col_free(1) = .TRUE.
    col_free(2) = .FALSE.
    CALL MPI_CART_SUB(comm_cart, col_free, comm_col, ierr)
    CALL MPI_CART_SHIFT(comm_col,0,1,neigh_left,neigh_right,ierr)

    END SUBROUTINE generate_communicators
 
    SUBROUTINE fox()
    
    DO stage=0,q-1

        bcast_root = MOD(jcoord+stage, q)
         
        IF (bcast_root.EQ.icoord) THEN
            CALL MPI_BCAST(ASELF,lni*lnj,MPI_REAL,bcast_root, & 
                           comm_row,ierr)
            CALL multiply_local(ASELF,B,C)
        ELSE
            CALL MPI_BCAST(A,lni*lnj,MPI_REAL,bcast_root,comm_row,ierr)
            CALL multiply_local(A,B,C)
        ENDIF 
        CALL MPI_SENDRECV_REPLACE(B,lni*lnj,MPI_REAL,             &
                                  neigh_right,0,              &
                                  neigh_left,0,               &
                                  comm_col,STATUS,ierr)
    ENDDO

    END SUBROUTINE fox 

    SUBROUTINE multiply_local(AA,BB,CC)
    REAL, DIMENSION(:,:), INTENT(IN) :: AA,BB
    REAL, DIMENSION(:,:), INTENT(OUT) :: CC
    REAL :: CL
    INTEGER :: row, column, N
    CL = 0.0
    N = SIZE(A,1)
    DO row=1,N
        DO column=1,N
            CL = SUM(AA(column,:)*BB(:,row))
            CC(column,row) = CC(column,row) + CL
        ENDDO
    ENDDO
    END SUBROUTINE multiply_local

END MODULE master
