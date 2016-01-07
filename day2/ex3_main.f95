program main
use glob
implicit none
real, dimension(:, :), allocatable :: temp, temp_old
integer :: it, nwskp

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

contains
  
  subroutine copy(copied, original)
  implicit none
  real, dimension(nx, ny) :: copied, original
  
  copied(:, :) = original(:, :)
  
  end subroutine copy

  subroutine write_out(temp, step)
  implicit none
  real, dimension(nx, ny) :: temp
  integer, optional :: step
  character(len = 30) :: string
  integer :: i, j
  
  if (present(step)) then
    write(string, "(A,I6.6,A)") "out/diff.",step,".dat"
  else
    write(string, "(A)") "out/diff.dat"
  endif 

  open(10, file=string)
  do j = 1, ny
    do i = 1, nx
      write(10, "(3E12.4)") real(i-1)*dx, real(j-1)*dy, temp(i, j)
    enddo
  enddo
  close(10)
  end subroutine write_out

  subroutine take_step(temp, temp_old)
  implicit none
  real, intent(in), dimension(nx, ny) :: temp_old
  real, intent(out), dimension(nx, ny) :: temp
  real :: diffx, diffy
  integer :: i, im, ip
  integer :: j, jm, jp

  temp(:,:) = temp_old

  do i = 2, ny-1

    im = max(1, i - 1)
    ip = min(nx, i + 1)

    do j = 2, nx-1
    
      jm = max(1, j - 1)
      jp = min(ny, j + 1)
                
      diffx = (temp_old(ip, j) - 2.0*temp_old(i, j) + temp_old(im, j))/(dx**2.0)
      diffy = (temp_old(i, jp) - 2.0*temp_old(i, j) + temp_old(i, jm))/(dy**2.0)
        
      temp(i, j) = temp_old(i, j) + dt * d * (diffx + diffy)    
      
    enddo
  enddo

  end subroutine take_step

end program main

