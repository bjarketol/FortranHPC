PROGRAM main
USE master
USE allocater
IMPLICIT NONE
INTEGER :: it
REAL*8, DIMENSION(:,:), POINTER :: temp, temp_old, force

nstop = 2000
nwrt  = 20

nx = 41
ny = 41

xmin = -1.0
xmax = +1.0
ymin = -1.0
ymax = +1.0

dx = (xmax-xmin)/(nx-1)
dy = (ymax-ymin)/(ny-1)

CALL alloc(temp_array, nx, ny)
CALL alloc(temp_old_array, nx, ny)
CALL alloc(force_array, nx, ny)
CALL init_temp()
CALL init_force()

temp => temp_array
temp_old => temp_old_array
force => force_array

DO it = 1,nstop
    CALL step(temp, temp_old, force)
    CALL swap_pointer(temp, temp_old)

    IF (MOD(it,nwrt).eq.0) THEN
        CALL write2txt(temp,it=it)
    ENDIF
ENDDO

!CALL write2txt(temp)

CONTAINS

    SUBROUTINE write2txt(array, it)
    IMPLICIT NONE
    REAL*8, DIMENSION(:,:), POINTER :: array
    INTEGER, OPTIONAL :: it
    CHARACTER(LEN=200) :: outfile
    INTEGER :: i,j

    IF (PRESENT(it)) THEN
        WRITE(outfile, "(A,I6.6,A)") "/home/btol/Dropbox/HPC/code/day7/poisson/out/diff.",it,".dat"
    ELSE
        WRITE(outfile, "(A)") "/home/btol/Dropbox/HPC/code/day7/poisson/out/diff.dat"
    ENDIF

    OPEN(UNIT=20, FILE=outfile)
    DO j = 1, ny
        DO i = 1, nx
            WRITE(20, "(3E12.4)") xmin+REAL(i-1)*dx, ymin+REAL(j-1)*dy, array(i,j)
        ENDDO
    ENDDO
    CLOSE(20)
    END SUBROUTINE write2txt

    SUBROUTINE swap_pointer(p1, p2)
    IMPLICIT NONE
    REAL*8, DIMENSION(:,:), POINTER, INTENT(INOUT) :: p1,p2
    REAL*8, DIMENSION(:,:), POINTER :: p3
    p3 => p1
    p1 => p2
    p2 => p3
    END SUBROUTINE swap_pointer

    SUBROUTINE init_temp()
    temp_array(:,:)  = 0.0    
    temp_array(:,ny) = 20.0 
    temp_array(:,1)  = 0.0
    temp_array(1,:)  = 20.0 
    temp_array(nx,:) = 20.0
    temp_old_array(:,:) = temp_array(:,:)
    END SUBROUTINE init_temp

    SUBROUTINE init_force()
    IMPLICIT NONE
    INTEGER :: i, j
    REAL*8 :: x, y, delsq
    
    delsq = dx*dx

    force_array(:,:) = 0.0

    DO j = 1,ny
        y = ymin+REAL(j-1)*dy
        DO i = 1,nx
            x = xmin+REAL(i-1)*dx
            IF (y.GE.-0.66.AND.y.LE.-0.33) THEN
                IF (x.GE.0.0.AND.x.LE.0.33) THEN
                    force_array(i,j) = 200.0 * delsq
                ENDIF
            ENDIF
        ENDDO
    ENDDO
    END SUBROUTINE init_force
    
    SUBROUTINE step(new, old, f)
    IMPLICIT NONE
    REAL*8, DIMENSION(:, :), POINTER, intent(inout) :: new, old
    REAL*8, DIMENSION(:, :), POINTER :: f
    INTEGER :: i, im, ip
    INTEGER :: j, jm, jp
    
    DO j = 2,ny-1

        jm = MAX(1, j-1)
        jp = MIN(ny, j+1)
    
        DO i = 2,nx-1
            
            im = MAX(1, i-1)
            ip = MIN(nx, i+1)

            new(i,j) = 0.25*(old(i,jm) + &
                             old(i,jp) + &
                             old(im,j) + &
                             old(ip,j) + &
                             f(i,j))
        ENDDO
    ENDDO
    END SUBROUTINE step

END PROGRAM main
