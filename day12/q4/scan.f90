PROGRAM comm
IMPLICIT NONE
INCLUDE 'mpif.h'
INTEGER :: ierr, iproc, nproc, next, prev, rank
INTEGER :: sum_, sendbuf, recvbuf, handle
INTEGER :: status(MPI_STATUS_SIZE)
REAL*8 :: ts, te

CALL mpi_init(ierr)
CALL mpi_comm_rank(MPI_COMM_WORLD, rank, ierr)
CALL mpi_comm_size(MPI_COMM_WORLD, nproc, ierr)

next = MOD(rank+1, nproc)
prev = MOD(rank-1, nproc)

IF (prev.LT.0) THEN
    prev = prev + nproc
ENDIF

CALL MPI_ALLREDUCE(rank,sum_,1,MPI_INTEGER,MPI_SUM,MPI_COMM_WORLD,ierr)

PRINT*,rank,"sum is:", sum_

CALL mpi_finalize(ierr)

END PROGRAM comm
