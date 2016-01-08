SUBROUTINE take_step(f, g)
USE master, ONLY: nx, ny, dx, dy, dt, d
IMPLICIT NONE
REAL, DIMENSION(nx, ny) :: g
REAL, DIMENSION(nx, ny) :: f
REAL :: diffx, diffy
INTEGER :: i, im, ip
INTEGER :: j, jm, jp

f = g

DO i = 2, ny-1

  im = MAX(1, i - 1)
  ip = MIN(nx, i + 1)

  DO j = 2, nx-1

    jm = MAX(1, j - 1)
    jp = MIN(ny, j + 1)
            
    diffx = (g(ip, j) - 2.0*g(i, j) + g(im, j))/(dx**2.0)
    diffy = (g(i, jp) - 2.0*g(i, j) + g(i, jm))/(dy**2.0)
    f(i, j) = g(i, j) + dt * d * (diffx + diffy)    

  ENDDO
ENDDO
END SUBROUTINE take_step
