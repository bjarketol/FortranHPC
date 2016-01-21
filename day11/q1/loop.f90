PROGRAM loop
IMPLICIT NONE
INTEGER :: i, j, k, it, nstop, m
REAL*8 :: ts, te, tavg, c, cinv
REAL*8, DIMENSION(4) :: a
real*8, DIMENSION(:,:,:), ALLOCATABLE :: f
REAL*8, DIMENSION(:), ALLOCATABLE :: b

nstop = 100
m = 100
c = 1.0

ALLOCATE(f(m,m,m))
ALLOCATE(b(m))

!-----------------------------------------------------------------------------
!###### WARM UP LOOP ######!
DO i = 1, 4
    a(i) = 0.0
ENDDO
DO k = 1,4
    DO i = 1,100
        a(k) = a(k) + a(k)
    ENDDO
ENDDO

!------------------------------------------------------------------------------
! QUESTION 1.A)
!------------------------------------------------------------------------------
!###### INITIAL LOOP #######!
CALL CPU_TIME(ts)
DO i = 1, 4
    a(i) = 0.0
ENDDO
DO k = 1,4
    DO i = 1,100000000
        a(k) = a(k) + a(k)
    ENDDO
ENDDO
CALL CPU_TIME(te)
PRINT*, "Q.1a) Time taken for initial loop:", te-ts

!###### UNROLLED LOOP #######!
CALL CPU_TIME(ts)
DO i = 1, 4
    a(i) = 0.0
ENDDO
DO i = 1, 100000000
    a(1) = a(1) + a(1)
    a(2) = a(2) + a(2)
    a(3) = a(3) + a(3)
    a(4) = a(4) + a(4)
ENDDO
CALL CPU_TIME(te)
PRINT*, "Q.1a) Time taken for unrolled loop:", te-ts

!------------------------------------------------------------------------------
! QUESTION 1.B)
!------------------------------------------------------------------------------

! TOP LOOP
tavg = 0.0
DO it = 1,nstop
    CALL CPU_TIME(ts)
    DO i = 1,m
        DO j = 1,m
            DO k = 1,m
                f(i,j,k) = f(i,j,k) * c
            ENDDO
        ENDDO
    ENDDO
    CALL CPU_TIME(te)
    tavg = tavg + (te-ts)
ENDDO
tavg = tavg / float(nstop)
print*, "Q.1b) Average time top i,j,k-order:", tavg

tavg = 0.0
DO it = 1,nstop
    CALL CPU_TIME(ts)
    DO k = 1,m
        DO j = 1,m
            DO i = 1,m
                f(i,j,k) = f(i,j,k) * c
            ENDDO
        ENDDO
    ENDDO
    CALL CPU_TIME(te)
    tavg = tavg + (te-ts)
ENDDO
tavg = tavg / float(nstop)
print*, "Q.1b) Average time top k,j,i-order:", tavg

! BOTTOM LOOP
tavg = 0.0
DO it = 1,nstop
    b(:) = 0.0
    CALL CPU_TIME(ts)
    DO i = 1,m
        IF (MOD(i,10) == 0) THEN
            b(i) = b(i) * 2.0
        ELSE
            b(i) = b(i) * c
        ENDIF
    ENDDO
    CALL CPU_TIME(te)
    tavg = tavg + (te-ts)
ENDDO
tavg = tavg / float(nstop)
print*, "Q.1b) Average time bottom if inside:", tavg

tavg = 0.0
cinv = 1.0/c
DO it = 1,nstop
    b(:) = 0.0
    CALL CPU_TIME(ts)
    DO i = 1,m
        b(i) = b(i)*c
    ENDDO
    DO i = 10,m,10
        b(i) = b(i)*cinv*2.0
    ENDDO
    CALL CPU_TIME(te)
    tavg = tavg + (te-ts)
ENDDO
tavg = tavg / float(nstop)
print*, "Q.1b) Average time bottom if outside:", tavg

END PROGRAM loop
