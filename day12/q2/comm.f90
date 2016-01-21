PROGRAM comm
IMPLICIT NONE
INCLUDE 'mpif.h'
INTEGER :: ierr, iproc, nproc, next, prev, rank
INTEGER :: sum_, sendbuf, sendbuf2, handle
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

sum_ = 0

sendbuf = rank
DO iproc=0,nproc-1

    IF (iproc.GT.0) THEN
        CALL MPI_RECV(sendbuf2,1,MPI_INTEGER,prev,0,MPI_COMM_WORLD,status,ierr)
        CALL MPI_WAIT(handle,status,ierr)
        sendbuf = sendbuf2
    ENDIF

    IF (iproc.LT.nproc-1) THEN
        CALL MPI_ISEND(sendbuf,1,MPI_INTEGER,next,0,MPI_COMM_WORLD,handle,ierr)
    ENDIF

    sum_ = sum_ + sendbuf

ENDDO

PRINT*,rank,"sum is:", sum_

CALL mpi_finalize(ierr)

END PROGRAM comm
