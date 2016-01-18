SUBROUTINE diag
USE master
IMPLICIT NONE
INTEGER, SAVE :: naccum
REAL, DIMENSION(10), SAVE :: bucket
CHARACTER(LEN=*), PARAMETER :: outfile = "/home/btol/Dropbox/HPC/code/day4/diag.dat"
REAL :: val
LOGICAL :: exists
INTEGER :: i, stat
LOGICAL, SAVE :: first_call = .TRUE.

naccum = naccum + 1
val = MINVAL(temp)
bucket(naccum) = val

IF (first_call) then
  OPEN(UNIT=11, IOSTAT=stat, FILE=outfile, STATUS='old')
  IF (stat == 0) CLOSE(11, STATUS='delete')
  first_call = .false.
ENDIF

IF (naccum.EQ.10) THEN 
  INQUIRE(FILE=outfile, EXIST = exists)
  
  IF (EXISTS) THEN
    OPEN(12, FILE=outfile, STATUS="old", POSITION="append", ACTION="write")
    DO i = 1, naccum
      WRITE(12, "(E12.4)") bucket(i)
    END DO
  ELSE
    OPEN(12, FILE=outfile, STATUS="new", ACTION="write")
    DO i = 1, naccum
      WRITE(12, "(E12.4)") bucket(i)
    END DO
  ENDIF 
  naccum = 0
  bucket(:) = 0.0
ENDIF
CLOSE(12)
END SUBROUTINE diag
