PROGRAM main
USE master
USE allocater
USE OMP_LIB
IMPLICIT NONE
INTEGER :: it
REAL*8, DIMENSION(:,:), POINTER :: temp, temp_old, force
REAL*8 :: k

CALL read_namelist()

dx = (xmax-xmin)/(nx-1)
dy = (ymax-ymin)/(ny-1)

CALL alloc(temp_array, nx, ny)
CALL alloc(temp_old_array, nx, ny)
CALL alloc(force_array, nx, ny)

IF (jacobi_OMP) THEN
    !$OMP PARALLEL
    CALL init_temp_OMP()
    CALL init_force_OMP()
    !$OMP END PARALLEL
ELSE
    CALL init_temp()
    CALL init_force()
ENDIF

temp => temp_array
temp_old => temp_old_array
force => force_array

IF (converge) THEN
    k = 1.0
    it = 1

    ! JACOBI !
    IF (jacobi) THEN
        DO WHILE (k.GT.kmax.AND.it.LE.nstop) 
            CALL jacobi_step(temp, temp_old, force)
            CALL swap_pointer(temp, temp_old)
            CALL frobnorm(k,temp,temp_old)
            IF (writeout.AND.MOD(it,nwrt).EQ.0) THEN
                CALL write2txt(temp,it=it)
            ENDIF
            it = it + 1
        ENDDO
    ENDIF
    
    ! GAUSS-SEIDEL !
    IF (gauss_seidel) THEN
        DO WHILE (k.GT.kmax.AND.it.LE.nstop) 
            CALL copy_old()
            CALL gauss_seidel_step(temp, force)
            !CALL swap_pointer(temp, temp_old)
            CALL frobnorm(k,temp,temp_old)
            IF (writeout.AND.MOD(it,nwrt).EQ.0) THEN
                CALL write2txt(temp,it=it)
            ENDIF
            it = it + 1
        ENDDO
    ENDIF

ELSE
    
    ! JACOBI !
    IF (jacobi) THEN
        DO it=1,nstop 
            CALL jacobi_step(temp, temp_old, force)
            CALL swap_pointer(temp, temp_old)
            IF (writeout.AND.MOD(it,nwrt).EQ.0) THEN
                CALL write2txt(temp,it=it)
            ENDIF
        ENDDO
    ENDIF

    ! JACOBI_OMP !
    IF (jacobi_OMP) THEN
        !$OMP PARALLEL PRIVATE(it) 
        DO it=1, nstop
            CALL jacobi_OMP_step(temp, temp_old, force)
            !$OMP SINGLE
            CALL swap_pointer(temp, temp_old)
            IF (writeout.AND.MOD(it,nwrt).EQ.0) THEN
                CALL write2txt(temp,it=it)
            ENDIF 
            !$OMP END SINGLE
        ENDDO
    !$OMP END PARALLEL
    ENDIF
ENDIF
PRINT*, it, "Iterations done..."
CONTAINS 

    SUBROUTINE read_namelist()
    IMPLICIT NONE
    CHARACTER(LEN=*), PARAMETER :: nlfile = "name.list"
    NAMELIST /namdim/ nx,ny,nstop,nwrt,kmax,xmin,xmax,ymin,ymax,jacobi, &
                      jacobi_OMP, gauss_seidel, converge, writeout
    OPEN(UNIT=10, FILE=nlfile)
    READ(10,namdim)
    END SUBROUTINE read_namelist

    SUBROUTINE frobnorm(c,f,g)
    IMPLICIT NONE
    REAL*8, DIMENSION(:,:), POINTER :: f,g
    REAL*8, DIMENSION(nx,ny) :: lambda
    INTEGER :: i,j
    REAL*8 :: c
    lambda = f - g
    c = 0.0 
    DO j = 1,ny
        DO i = 1,nx
            c = c + lambda(i,j)**2.0   
        ENDDO
    ENDDO
    c = sqrt(c)
    END SUBROUTINE frobnorm

    SUBROUTINE write2txt(array, it)
    IMPLICIT NONE
    REAL*8, DIMENSION(:,:), POINTER :: array
    INTEGER, OPTIONAL :: it
    CHARACTER(LEN=200) :: outfile
    INTEGER :: i,j
    IF (PRESENT(it)) THEN
        
        WRITE(outfile, "(A,I6.6,A)") "/home/btol/Dropbox/HPC/code/day7/poisson/out/diff.",it,".dat"
        !WRITE(outfile, "(A,I6.6,A)") "/home/btol/projects/FortranHPC/day7/poisson/out/diff.",it,".dat"
    ELSE
        WRITE(outfile, "(A,I6.6,A)") "/home/btol/Dropbox/HPC/code/day7/poisson/out/diff.dat"
        !WRITE(outfile, "(A)") "/home/btol/projects/FortranHPC/day7/poisson/out/diff.dat"
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
    
    SUBROUTINE copy_old()
    IMPLICIT NONE
    temp_old_array(:,:) = temp_array(:,:)
    END SUBROUTINE copy_old

    SUBROUTINE init_temp()
    temp_array(:,:)  = 0.0    
    temp_array(:,ny) = 20.0 
    temp_array(:,1)  = 0.0
    temp_array(1,:)  = 20.0 
    temp_array(nx,:) = 20.0
    temp_old_array(:,:) = temp_array(:,:)
    END SUBROUTINE init_temp
    
    SUBROUTINE init_temp_OMP()
    !$OMP WORKSHARE
    temp_array(:,:)  = 0.0    
    temp_array(:,ny) = 20.0 
    temp_array(:,1)  = 0.0
    temp_array(1,:)  = 20.0 
    temp_array(nx,:) = 20.0
    temp_old_array(:,:) = temp_array(:,:)
    !$OMP END WORKSHARE
    END SUBROUTINE init_temp_OMP

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
    
    SUBROUTINE init_force_OMP()
    IMPLICIT NONE
    INTEGER :: i, j
    REAL*8 :: x, y, delsq
    delsq = dx*dx
    !$OMP WORKSHARE
    force_array(:,:) = 0.0
    !$OMP END WORKSHARE
    !$OMP DO PRIVATE(j,i,y,x)
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
    !$OMP END DO
    END SUBROUTINE init_force_OMP
    
    SUBROUTINE jacobi_step(new, old, f)
    IMPLICIT NONE
    REAL*8, DIMENSION(:, :), POINTER, INTENT(INOUT) :: new, old
    REAL*8, DIMENSION(:, :), POINTER :: f
    INTEGER :: i,j
    DO j = 2,ny-1
        DO i = 2,nx-1
            new(i,j) = 0.25*(old(i,  j-1) + &
                             old(i,  j+1) + &
                             old(i-1,j  ) + &
                             old(i+1,j  ) + &
                             f(i,j))
        ENDDO
    ENDDO
    END SUBROUTINE jacobi_step
    
    SUBROUTINE jacobi_OMP_step(new, old, f)
    IMPLICIT NONE
    REAL*8, DIMENSION(:, :), POINTER, INTENT(INOUT) :: new, old
    REAL*8, DIMENSION(:, :), POINTER :: f
    INTEGER :: i,j
    !$OMP DO PRIVATE(i,j)
    DO j = 2,ny-1
        DO i = 2,nx-1
            new(i,j) = 0.25*(old(i  ,j-1) + &
                             old(i  ,j+1) + &
                             old(i-1,j  ) + &
                             old(i+1,j  ) + &
                             f(i,j))
        ENDDO
    ENDDO
    !$OMP END DO
    END SUBROUTINE jacobi_OMP_step

    SUBROUTINE gauss_seidel_step(new, f)
    IMPLICIT NONE
    REAL*8, DIMENSION(:, :), POINTER, INTENT(INOUT) :: new
    REAL*8, DIMENSION(:, :), POINTER :: f
    INTEGER :: i,j
    DO j = 2,ny-1
        DO i = 2,nx-1
            new(i,j) = 0.25*(new(i  ,j-1) + &
                             new(i  ,j+1) + &
                             new(i-1,j  ) + &
                             new(i+1,j  ) + &
                             f(i,j))                        
        ENDDO
    ENDDO
    END SUBROUTINE gauss_seidel_step

END PROGRAM main
