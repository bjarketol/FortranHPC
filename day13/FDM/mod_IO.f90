       module mod_IO
       
       use mod_data
       IMPLICIT NONE
       
       public :: output

       contains
       
       subroutine output

              OPEN(10,FILE='diff.dat')   
	      DO j=1,Ny+2
	        DO i=1,Nx+2
	         WRITE(10,'(3E12.4)') REAL(i-1)*dx,REAL(j-1)*dy,u_loc(i,j)
	        ENDDO
	       WRITE(10,'(A)') ! Will produce a new empty line and tell gnuplot to lift the pen
	      ENDDO
              CLOSE(10)

       end subroutine output
       
       
       end module mod_IO
