subroutine init(array)
use master
implicit none
real, dimension(nx, ny), intent(inout) :: array
array(:, :)  = 0.0
array(1, :)  = 1.0
array(nx, :) = 1.0
array(:, 1)  = 1.0
array(:, ny) = 1.0
end subroutine init

