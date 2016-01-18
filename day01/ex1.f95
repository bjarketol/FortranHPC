program test
implicit none
integer :: i, j, k, n
print*, "Enter j n "
read(*,*) j, n
k = 0
do i = 1, n
    if (i.eq.j) exit
    k = k + 10 
    !i = i + 10 ! Does this compile?
enddo
!k = i
print*, "k = ", k
end program test
