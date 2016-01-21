PROGRAM comm
IMPLICIT NONE
INCLUDE 'mpif.h'
INTEGER :: ierr, iproc, nproc, next, prev, rank
INTEGER :: sum_, sendbuf, recvbuf, handle, fac
INTEGER :: status(MPI_STATUS_SIZE)
REAL*8 :: ts, te
INTEGER, DIMENSION(6) :: bucket

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

CALL MPI_SCAN(rank+1,fac,1,MPI_INTEGER,MPI_PROD,MPI_COMM_WORLD,ierr)
PRINT*,rank,"fac is:", fac

CALL MPI_GATHER(fac,1,MPI_INTEGER,bucket,6,MPI_INTEGER,0, MPI_COMM_WORLD,ierr)

!MPI_ALLGATHER(SENDBUF, SENDCOUNT, SENDTYPE, RECVBUF, RECVCOUNT,
!        RECVTYPE, COMM, IERROR)
!    <type>    SENDBUF (*), RECVBUF (*)
!    INTEGER    SENDCOUNT, SENDTYPE, RECVCOUNT, RECVTYPE, COMM,
!    INTEGER    IERROR

IF (rank.EQ.0) THEN
    PRINT*, bucket
ENDIF


CALL mpi_finalize(ierr)

END PROGRAM comm
