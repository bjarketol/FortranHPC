subroutine init(c, n, m)
implicit none
real, dimension(:, :), intent(inout), allocatable :: c
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

