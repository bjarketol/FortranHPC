PROGRAM main
IMPLICIT NONE
REAL*8 :: pi, calpi, cr
INTEGER :: n, c1, c2

n = 1000000000

CALL SYSTEM_CLOCK(c1, COUNT_RATE=cr)
pi = calpi(n)
CALL SYSTEM_CLOCK(c2)

print*, pi, (real(c2)-real(c1))/cr

END PROGRAM main

REAL*8 FUNCTION calpi(n)
USE OMP_LIB
INTEGER, INTENT(IN) :: n
INTEGER :: i
REAL*8 :: sum_, sum_loc

sum_ = 0.0
sum_loc = 0.0

!CALL OMP_SET_NUM_THREADS(1)
!$OMP PARALLEL SHARED(sum_,n) PRIVATE(i) FIRSTPRIVATE(sum_loc)
!$OMP DO  
DO i = 1,n
  sum_loc = sum_loc + (4.0 / (1.0 + ((real(i)-0.5)/real(n))**2.0)) 
ENDDO
!$OMP END DO
!$OMP CRITICAL (SUM)
sum_ = sum_ + sum_loc
!$OMP END CRITICAL (SUM)
!$OMP END PARALLEL 

calpi = (1.0/real(n))*sum_

RETURN
END FUNCTION calpi

