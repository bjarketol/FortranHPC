module allocater
implicit none
real, dimension(:,:), allocatable :: swork
real*8, dimension(:,:), allocatable :: dwork
interface alloc
  module procedure salloc, dalloc
end interface alloc
contains
  
  subroutine salloc(f, n, m)
  implicit none
  real, dimension(:,:), allocatable :: f
  integer, intent(in) :: n, m
  if (.not.allocated(f)) then
    allocate(f(n, m))
  else
    allocate(swork(n, m))
    swork(1:size(f(:,1)), 1:size(f(1,:))) = f(:,:)
    f = swork
  endif 
  end subroutine salloc
 
  subroutine dalloc(f, n, m)
  implicit none
  real*8, dimension(:,:), allocatable :: f
  integer, intent(in) :: n, m
  if (.not.allocated(f)) then
    allocate(f(n, m))
  else
    allocate(swork(n, m))
    dwork(1:size(f(:,1)), 1:size(f(1,:))) = f(:,:)
    f = dwork
  endif 
  end subroutine dalloc

end module allocater
