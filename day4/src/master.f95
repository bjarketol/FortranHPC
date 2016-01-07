module master
implicit none
real, dimension(:,:), allocatable :: temp, temp_old
integer :: nstop, nx, ny
real :: xmin, xmax, dx
real :: ymin, ymax, dy
real :: dt
real :: d
end module master
