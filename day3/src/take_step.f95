subroutine take_step(f, g)
use master
implicit none
real, dimension(nx, ny) :: g
real, dimension(nx, ny) :: f
real :: diffx, diffy
integer :: i, im, ip
integer :: j, jm, jp

f = g

do i = 2, ny-1

im = max(1, i - 1)
ip = min(nx, i + 1)

do j = 2, nx-1

  jm = max(1, j - 1)
  jp = min(ny, j + 1)
            
  diffx = (g(ip, j) - 2.0*g(i, j) + g(im, j))/(dx**2.0)
  diffy = (g(i, jp) - 2.0*g(i, j) + g(i, jm))/(dy**2.0)
    
  f(i, j) = g(i, j) + dt * d * (diffx + diffy)    
  
enddo
enddo

end subroutine take_step
