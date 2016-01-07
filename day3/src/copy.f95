subroutine copy(copied, original)
use master
implicit none
real, dimension(nx, ny) :: copied, original

copied(:, :) = original(:, :)

end subroutine copy
