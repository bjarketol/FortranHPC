elemental subroutine copy(c, o)
use master
implicit none
real, intent(inout) :: c, o
c = o
end subroutine copy
