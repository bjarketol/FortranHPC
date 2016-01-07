module master
real, dimension(:), allocatable :: a, b
real, dimension(:), pointer :: work
contains 
  !Pointer array with alloc/dealloc
  subroutine swap(a, b)
  implicit none
  real, dimension(:), intent(inout) :: a, b
  real, dimension(:), pointer :: work
  integer :: istat
  allocate(work(size(a)), stat=istat)
  work = a; a = b; b = work
  deallocate(work, stat=istat)
  end subroutine swap
end module master

program main
!use master
implicit none
real, dimension(:), allocatable :: a, b
interface 
  subroutine swap_ar(a, b)
  real, dimension(:), intent(inout) :: a, b
  end subroutine swap_ar
  subroutine swap_p(a, b)
  real, dimension(:), intent(inout) :: a, b
  end subroutine swap_p
end interface

allocate(a(90000000))
allocate(b(90000000))

a(:) = 1
b(:) = 2

print*, "a:", a(1)
!call swap_ar(a, b) 
!print*, "a swap automatic:", a(1)
!call swap_p(a, b)
!print*, "a swap pointer:", a(1)
call swap(a, b)
print*, "a swap pointer in heap:", a(1)

end program main


subroutine swap_ar(a, b)
!Automatic array, working in stack
!breaks when outside stack size 
!(if compiled with gfortran -fstack-arrays option)
implicit none
real, dimension(:), intent(inout) :: a, b
real, dimension(size(a)) :: work
work = a; a = b; b = work
end subroutine swap_ar

subroutine swap_p(a, b)
!Pointer array with alloc/dealloc, working in stack
!Can sometimes breaks when outside stack size 
!(if compiled with gfortran -fstack-arrays option)
implicit none
real, dimension(:), intent(inout) :: a, b
real, dimension(:), pointer :: work_s
integer :: istat
allocate(work_s(size(a)), stat=istat)
work_s = a; a = b; b = work_s
deallocate(work_s, stat=istat)
end subroutine swap_p

