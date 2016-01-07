subroutine write_out(f, step)
use master
implicit none
real, dimension(nx, ny) :: f
integer, optional :: step
character(len = 100) :: string
integer :: i, j

if (present(step)) then
write(string, "(A,I6.6,A)") "/home/btol/Dropbox/HPC/code/day3/out/diff.",step,".dat"
else
write(string, "(A)") "/home/btol/Dropbox/HPC/code/day3/out/diff.dat"
endif 

open(10, file=string)
do j = 1, ny
do i = 1, nx
  write(10, "(3E12.4)") real(i-1)*dx, real(j-1)*dy, f(i, j)
enddo
enddo
close(10)
end subroutine write_out

