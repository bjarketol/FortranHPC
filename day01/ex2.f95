program main
implicit none
real, allocatable, dimension(:,:) :: temp, temp_old
integer :: nx, ny 
integer :: nstop
real :: dx, dy, dt
real :: xmin, xmax, ymin, ymax
real, parameter :: d = 1.0
integer :: it, i, j

nstop = 200
nx    = 21
ny    = 21
xmin  = 0.0
xmax  = 1.0
ymin  = 0.0
ymax  = 1.0
dx    = (xmax - xmin)/(nx-1)
dy    = (ymax - ymin)/(ny-1)
dt    = 0.000625

allocate(temp(nx, ny))
allocate(temp_old(nx, ny))

! Set border temp to 1.0 and rest to 0.0
temp(:, :)  = 0.0
temp(1, :)  = 1.0
temp(nx, :) = 1.0
temp(:, 1)  = 1.0
temp(:, ny) = 1.0

temp_old(:,:) = temp(:,:)

do it = 1,nstop
    call take_step(temp, temp_old, d, nx, ny, dx, dy, dt)
    print*, temp(10,10)
    temp_old(:,:) = temp(:,:)
enddo

open(10, file="temp.txt")
do j = 1, ny
    do i = 1, nx
        write(10, "(3E12.4)") real(i-1)*dx, real(j-1)*dy, temp(i,j)
    enddo
    write(10,"(A)")
enddo
close(10)

end program main

subroutine take_step(temp, temp_old, d, nx, ny, dx, dy, dt)
implicit none
integer, intent(in) :: nx, ny
real, intent(in), dimension(nx, ny) :: temp_old
real, intent(out), dimension(nx, ny) :: temp
real, intent(in) :: d, dx, dy, dt
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
return
end subroutine
