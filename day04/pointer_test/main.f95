program main
implicit none
real, dimension(:), pointer :: p
real, dimension(:), allocatable, target :: t
integer :: info, nt
nt = 100000 ! 10000
allocate(t(nt))
call random_number(t)
p => t
print*, "p(3)=", p(3)
deallocate(t,stat=info)
allocate(t(1000))
p => t
print*, "p(3)=", p(3)
call random_number(t)
! nullify(p)
if (associated(p)) then
  print*, "p is associated"
  print*, "p(3)=", p(3)
  print*, "t(3)=", t(3)
endif
end program main
