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
INTEGER, INTENT(IN) :: n
INTEGER :: i
REAL*8 :: sum_

sum_ = 0.0

DO i = 1,n
  sum_ = sum_ + (4.0 / (1.0 + ((real(i)-0.5)/real(n))**2.0)) 
ENDDO

calpi = (1.0/real(n))*sum_

RETURN
END FUNCTION calpi
