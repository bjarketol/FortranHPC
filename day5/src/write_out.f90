SUBROUTINE write_out(step)
USE master, ONLY : f => temp, nx, ny, dy, dx
IMPLICIT NONE
INTEGER, OPTIONAL :: step
CHARACTER(LEN = 200) :: string
INTEGER :: i, j

IF (PRESENT(step)) THEN
  WRITE(string, "(A,I6.6,A)") "/home/btol/Dropbox/HPC/code/day4/out/diff.",step,".dat"
ELSE
  WRITE(string, "(A)") "/home/btol/Dropbox/HPC/code/day4/out/diff.dat"
ENDIF

OPEN(13, FILE=string)
DO j = 1, ny
  DO i = 1, nx
    WRITE(13, "(3E12.4)") REAL(i-1)*dx, REAL(j-1)*dy, f(i, j)
  ENDDO
ENDDO
CLOSE(13)
END SUBROUTINE write_out
