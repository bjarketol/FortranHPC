module mod_res

use mod_data

implicit none

public :: res

contains

subroutine res
implicit none
INTEGER :: ii,jj
        
	r = 0.0d0
	
        DO jj=2,Ny_loc_gh-1
           DO ii=2,Nx_loc_gh-1
              
	     r = r + abs((u_loc(ii+1,jj)+u_loc(ii-1,jj)+u_loc(ii,jj+1)+u_loc(ii,jj-1)-4.0d0*u_loc(ii,jj))/dx**2-1.0d0)
	      
           ENDDO
        ENDDO
	
		

end subroutine


end module mod_res
