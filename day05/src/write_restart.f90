SUBROUTINE write_restart(array)
USE master
IMPLICIT NONE
REAL, DIMENSION(nx, ny), INTENT(INOUT) :: array
INTEGER, PARAMETER :: sizeofreal=4
OPEN(UNIT=1, FILE='out.r4', FORM='unformatted', ACCESS='direct', RECL=nx*ny*sizeofreal)
WRITE(1,REC=1) array
END SUBROUTINE write_restart
