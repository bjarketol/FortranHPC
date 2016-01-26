SUBROUTINE write2txt()
USE master
CHARACTER(LEN = 200) :: string

WRITE(string, "(A,I2.2,A)") "out/output",rank,".dat"

open(13, file=string, status="replace", action="write")

DO i = 1,lpnx
  DO j = 1,lpny
    ii = (lpimin-1)+i
    jj = (lpjmin-1)+j
    WRITE(13, "(5E12.4)") REAL(gimin-1+i-1)*dx, REAL(gjmin-1+j-1)*dy, &
                          u(jj, ii), REAL(i), REAL(j)
  ENDDO
ENDDO
CLOSE(13)

END SUBROUTINE write2txt
