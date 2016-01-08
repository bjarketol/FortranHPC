SUBROUTINE init(array)
USE master
IMPLICIT NONE
REAL, DIMENSION(nx, ny), INTENT(INOUT) :: array
INTEGER :: i,j
REAL, ALLOCATABLE, DIMENSION(:,:) :: recltest
INTEGER :: reclen

ALLOCATE(recltest(nx,ny))
INQUIRE(iolength=reclen) recltest
DEALLOCATE(recltest)

IF (.NOT.restart) THEN
  array(:, :)  = 0.0
  array(1, :)  = 1.0
  array(nx, :) = 1.0
  array(:, 1)  = 1.0
  array(:, ny) = 1.0
ELSE
  OPEN(UNIT=1, FILE="out.r4", FORM="unformatted", STATUS="old", ACCESS="direct", RECL=reclen)

  DO j = 1, ny
    READ(1,REC=j) (array(i,j), i=1,nx)
  ENDDO

ENDIF
END SUBROUTINE init
