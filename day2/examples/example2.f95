program main
implicit none
integer :: x = 9


print*, fun(x)

contains
    recursive function fun(top) result(s)
    integer :: s, top
    if (top.lt.1) then
        s = 0
        return
    endif
    s = top + fun(top - 1)
    end function
end program main
