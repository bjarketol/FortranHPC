program main
use master
use allocater
implicit none
integer :: it, nwskp
interface
  subroutine write_out(f, step)
  real, dimension(:, :) :: f
  integer, optional :: step
  end subroutine
end interface

nstop = 200
dt    = 0.000625
nx    = 21
ny    = 21
xmin  = 0.0
xmax  = 1.0
ymin  = 0.0
ymax  = 1.0

dx    = (xmax - xmin)/(nx-1)
dy    = (ymax - ymin)/(ny-1)

! diffusion coefficient
d     = 1.0

! Number of time steps to skip before output is written
nwskp = 100            

!call alloc(temp, nx, ny)

call init(temp, nx, ny)
call init(temp_old, nx, ny)

do it = 1, nstop

  call take_step(temp, temp_old)

  print*, temp(10,10)

  if (mod(it, nwskp).eq.0) then
    call write_out(temp, step=it)
  endif 

  call copy(temp_old, temp)  

enddo
  
end program main

