MODULE master
IMPLICIT NONE
REAL*8, DIMENSION(:,:), ALLOCATABLE, TARGET :: temp_array, temp_old_array, force_array
INTEGER :: nx, ny, nstop, nwrt
REAL*8 :: xmin, xmax, dx
REAL*8 :: ymin, ymax, dy
REAL*8 :: eps
LOGICAL :: jacobi, jacobi_OMP, gauss_seidel, converge, writeout
END MODULE master
