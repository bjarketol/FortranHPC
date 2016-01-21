PROGRAM ping
IMPLICIT NONE
INCLUDE 'mpif.h'
INTEGER :: ierr, rank, nranks, partner
REAL*8, DIMENSION(:), ALLOCATABLE  :: message
INTEGER :: status(MPI_STATUS_SIZE)
INTEGER :: it, n
REAL*8 :: ts, te

n = 2**29

ALLOCATE(message(n))

CALL mpi_init(ierr)
CALL mpi_comm_rank(MPI_COMM_WORLD, rank, ierr)
CALL mpi_comm_size(MPI_COMM_WORLD, nranks, ierr)


partner = MOD(rank+1, 2)

CALL MPI_BARRIER(MPI_COMM_WORLD, ierr)

IF (rank.EQ.0) THEN
    ts = MPI_WTIME()
ENDIF

IF (rank.EQ.0) THEN
    CALL MPI_SEND(message, n, MPI_DOUBLE_PRECISION, partner, 0, MPI_COMM_WORLD, status, ierr)
    CALL MPI_RECV(message, n, MPI_DOUBLE_PRECISION, partner, 0, MPI_COMM_WORLD, status, ierr)
ELSE
    CALL MPI_RECV(message, n, MPI_DOUBLE_PRECISION, partner, 0, MPI_COMM_WORLD, status, ierr)
    CALL MPI_SEND(message, n, MPI_DOUBLE_PRECISION, partner, 0, MPI_COMM_WORLD, status, ierr)
ENDIF

CALL MPI_BARRIER(MPI_COMM_WORLD, ierr)

IF (rank.EQ.0) THEN
    te = MPI_WTIME()
    PRINT*, "TIME:",te-ts, "bandwidth = ", (8.0 * float(n)) / (te-ts)
ENDIF
CALL mpi_finalize(ierr)

END PROGRAM ping
