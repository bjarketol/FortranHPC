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
!~~~~~~~~~~~~~~~~~~ VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!

! PRINT Result for j,i = jr,ir NB!!!!! 0 INDEX HERE
ir = 98
jr = 99

n = 100

ni = n
nj = n

q = 4

! MPI
ndims      = 2
dims(1)    = q
dims(2)    = q
periods(1) = .TRUE.
periods(2) = .TRUE.
reorder    = .FALSE.

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!

CALL generate_communicators()
CALL initialize()
!CALL generate_sub_matrix_random()
CALL generate_sub_matrix_cos()
!CALL generate_sub_matrix_lin()
CALL fox()
CALL print_ji_result()

CALL MPI_FINALIZE(ierr)
END PROGRAM main
