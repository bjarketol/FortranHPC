module master
implicit none
real, dimension(:, :), allocatable :: temp, temp_old
integer :: nstop, nx, ny
real :: xmin, xmax, dx
real :: ymin, ymax, dy
real :: dt
real :: d
interface
  subroutine init(c, n, m)
  real, dimension(:, :), intent(inout), allocatable :: c
  integer, intent(in) :: n, m
  end subroutine init
end interface
end module master
