program main
use master
use allocater
implicit none
integer :: it, nwskp
character(8) :: date
character(10) :: time
real :: t1, t2, cr
integer :: c1, c2
interface
  subroutine write_out(step)
  integer, optional :: step
  end subroutine
  elemental subroutine copy(c, o)
  real, intent(inout) :: c, o
  end subroutine
end interface

nx    = 101
ny    = 101
xmin  = 0.0
xmax  = 1.0
ymin  = 0.0
ymax  = 1.0

dx    = (xmax - xmin)/(nx-1)
dy    = (ymax - ymin)/(ny-1)

! Set timestep to fourier limit
dt    = 0.00002  !dt= 0.000625 for 21x21

! Set number of time steps.
nstop = 2000

! diffusion coefficient
d     = 1.0

! Number of time steps to skip before output is written
nwskp = 100            

! Allocate arrays
call alloc(temp, nx, ny)
call alloc(temp_old, nx, ny)

! Initialize initial conditions
call init(temp)
call init(temp_old)

! Get and print the  start date+time 
call date_and_time(date=date, time=time)
print*, "START DATE-TIME: ", date,"-", time

! Get system clock
call system_clock(c1, count_rate=cr)


! Get initial cpu_time
call cpu_time(t1)

do it = 1, nstop

  call take_step(temp, temp_old)

  if (mod(it, nwskp).eq.0) then
    call write_out(step=it)
  endif 

  call diag
  ! Print middle value
  !print*, temp(floor(real(size(temp(:,1))/2)),floor(real(size(temp(1,:))/2)))
  
  call copy(temp_old, temp)  

enddo

! Print the end date+time 
call date_and_time(date=date, time=time)
print*, "END DATE-TIME: ", date,"-", time

! Get the system clock and calculate and print wall time
call system_clock(c2)
print*, "WALL TIME USED:", (c2-c1)/real(cr), "SECONDS"

! Get current cpu time and print the cpu time spent in the loop
call cpu_time(t2)
print*, "CPU TIME USED: ",t2-t1, "SECONDS"

end program main

