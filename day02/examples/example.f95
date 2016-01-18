program main
implicit none
real :: x
integer :: info, i 

x = 1.0
info = 2
i = 3

call sub(info)

contains
    subroutine sub(i)
    implicit none
    integer :: i
    print*, "i = ", i
    print*, "x = ", x
    end subroutine sub
end program main




