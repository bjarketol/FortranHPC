PROGRAM pi
IMPLICIT NONE
INCLUDE "mpif.h"
REAL*8 :: xmin,xmax,ymin,ymax
REAL*8 :: x,y,r,pival,one
INTEGER :: it, nstop, nin, nout, i
INTEGER :: STATUS(MPI_STATUS_SIZE)
INTEGER :: ierr, rank, nproc
INTEGER :: seedsize, nin_tot, nstop_tot
INTEGER, DIMENSION(:), ALLOCATABLE :: seed

CALL MPI_INIT(ierr)
CALL MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
CALL MPI_COMM_SIZE(MPI_COMM_WORLD, nproc, ierr)

!seedsize = nproc

CALL RANDOM_SEED(SIZE=seedsize)
ALLOCATE(seed(seedsize))
DO i = 1,seedsize
    seed(i) = 1238239 + rank*8365
ENDDO
CALL RANDOM_SEED(PUT=seed)

nstop = 1000000

xmin = 0.0
xmax = 1.0
ymin = 0.0
ymax = 1.0

nin  = 0 
nout = 0

one = 1.0

DO it = 1,nstop
    
    CALL RANDOM_NUMBER(x)
    CALL RANDOM_NUMBER(y)
    
    r = SQRT(x*x+y*y)
    
    IF (r.LE.one) THEN
        nin = nin + 1
    ENDIF

ENDDO

nin_tot = 0
nstop_tot = 0
CALL MPI_REDUCE(nin,nin_tot,1,MPI_INTEGER,MPI_SUM,0,MPI_COMM_WORLD,ierr)
CALL MPI_REDUCE(nstop,nstop_tot,1,MPI_INTEGER,MPI_SUM,0,MPI_COMM_WORLD,ierr)
!3.14159265359
IF (rank.EQ.0) THEN
    pival = 4.0 * float(nin_tot) / float(nstop_tot)
    PRINT*, "PI AFTER",nstop_tot,"ITERATIONS IS:",pival
ENDIF


CALL MPI_FINALIZE(ierr)

END PROGRAM pi
