PROGRAM ping
IMPLICIT NONE
INCLUDE 'mpif.h'
INTEGER :: ierr, rank, nranks, partner
INTEGER :: ping_count, ping_limit
INTEGER :: status(MPI_STATUS_SIZE)
INTEGER :: it
REAL*8 :: ts, te

CALL mpi_init(ierr)
CALL mpi_comm_rank(MPI_COMM_WORLD, rank, ierr)
CALL mpi_comm_size(MPI_COMM_WORLD, nranks, ierr)

ping_limit = 1000
ping_count = 0
partner = MOD(rank+1, 2)

CALL MPI_BARRIER(MPI_COMM_WORLD, ierr)

IF (rank.EQ.0) THEN
    ts = MPI_WTIME()
ENDIF

DO WHILE (ping_count.LT.ping_limit)
    IF (rank.EQ.MOD(ping_count,2)) THEN
        ping_count = ping_count + 1
        CALL MPI_SEND(ping_count, 1, MPI_INTEGER, partner, 0, MPI_COMM_WORLD, status, ierr)
        !PRINT*, "SENDING",ping_count,"FROM RANK",rank,"TO RANK",partner
    ELSE
        CALL MPI_RECV(ping_count, 1, MPI_INTEGER, partner, 0, MPI_COMM_WORLD, status, ierr)
        !PRINT*, "RECV",ping_count,"FROM RANK",partner,"TO RANK",rank
    ENDIF
ENDDO

CALL MPI_BARRIER(MPI_COMM_WORLD, ierr)

IF (rank.EQ.0) THEN
    te = MPI_WTIME()
    PRINT*, "TIME:",te-ts, "bandwidth = ", 4.0 / (te-ts), "b/s"
ENDIF
CALL mpi_finalize(ierr)

END PROGRAM ping
