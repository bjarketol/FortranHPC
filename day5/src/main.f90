PROGRAM main
USE master
USE allocater
IMPLICIT NONE
INTEGER :: it, nwskp
CHARACTER(8) :: date
CHARACTER(10) :: time
REAL :: t1, t2, cr
INTEGER :: c1, c2
INTERFACE
  SUBROUTINE write_out(step)
  INTEGER, OPTIONAL :: step
  END SUBROUTINE
  ELEMENTAL SUBROUTINE copy(c, o)
  REAL, INTENT(INOUT) :: c, o
  END SUBROUTINE
END INTERFACE

! Reads in nx,ny,dt,nstop, and d from name.list(fort.10)
CALL read_namelist

xmin  = 0.0
xmax  = 1.0
ymin  = 0.0
ymax  = 1.0

dx    = (xmax - xmin)/(nx-1)
dy    = (ymax - ymin)/(ny-1)

! Number of time steps to skip before output is written
nwskp = 100            

! Allocate arrays
CALL alloc(temp, nx, ny)
CALL alloc(temp_old, nx, ny)

! Initialize initial conditions
CALL init(temp)
CALL init(temp_old)

! Get and print the  start date+time 
CALL DATE_AND_TIME(DATE=date, TIME=time)
PRINT*, "START DATE-TIME: ", date,"-", time

! Get system clock
CALL SYSTEM_CLOCK(c1, COUNT_RATE=cr)

! Get initial cpu_time
CALL CPU_TIME(t1)

DO it = 1, nstop

  CALL take_step(temp, temp_old)

  IF (MOD(it, nwskp).EQ.0) THEN
    CALL write_out(step=it)
  ENDIF 

  CALL diag
  
  CALL copy(temp_old, temp)  

ENDDO

! Write restart file for test
CALL write_restart(temp)

! Print the end date+time 
CALL DATE_AND_TIME(DATE=date, TIME=time)
PRINT*, "END DATE-TIME: ", date,"-", time

! Get the system clock and calculate and print wall time
CALL SYSTEM_CLOCK(c2)
PRINT*, "WALL TIME USED:", (c2-c1)/REAL(cr), "SECONDS"

! Get current cpu time and print the cpu time spent in the loop
CALL CPU_TIME(t2)
PRINT*, "CPU TIME USED: ",t2-t1, "SECONDS"

END PROGRAM main
