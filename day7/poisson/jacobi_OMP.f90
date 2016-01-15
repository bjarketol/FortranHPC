SUBROUTINE jacobi_OMP_step(new, old, f)
IMPLICIT NONE
REAL*8, DIMENSION(:, :), POINTER, INTENT(INOUT) :: new, old
REAL*8, DIMENSION(:, :), POINTER :: f
INTEGER :: i,j
!$OMP DO PRIVATE(i,j)
DO j = 2,ny-1
    DO i = 2,nx-1
        new(i,j) = 0.25*(old(i  ,j-1) + &
                         old(i  ,j+1) + &
                         old(i-1,j  ) + &
                         old(i+1,j  ) + &
                         f(i,j))
    ENDDO
ENDDO
!$OMP END DO
END SUBROUTINE jacobi_OMP_step

