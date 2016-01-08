MODULE master
IMPLICIT NONE
REAL, DIMENSION(:,:), ALLOCATABLE :: temp, temp_old
INTEGER :: nstop, nx, ny
REAL :: xmin, xmax, dx
REAL :: ymin, ymax, dy
REAL :: dt
REAL :: d
LOGICAL :: restart
END MODULE master
