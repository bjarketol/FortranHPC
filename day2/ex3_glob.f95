module glob
implicit none
integer :: nstop, nx, ny
real :: xmin, xmax, dx
real :: ymin, ymax, dy
real :: dt
real :: d
contains
  subroutine init(c, n, m)
  implicit none
  real, dimension(:, :), allocatable :: c
  integer, intent(in) :: n, m
  
  if (.not.allocated(c)) then
      allocate(c(n, m))
  endif
  
  c(:, :) = 0.0
  c(1, :) = 1.0
  c(n, :) = 1.0
  c(:, 1) = 1.0
  c(:, m) = 1.0

  end subroutine init
end module glob
