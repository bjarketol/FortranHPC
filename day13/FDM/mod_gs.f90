module mod_gs

use mod_data

implicit none

public :: rb_gs

contains

subroutine rb_gs
implicit none
INTEGER :: ii,jj
        
	!Red  
        DO jj=2,Ny_loc_gh-1
           DO ii=2,Nx_loc_gh-1
              if (mod(ii+jj,2) .eq. 1) then
              u_loc(ii,jj) = 0.25d0*(u_loc(ii+1,jj)+u_loc(ii-1,jj)+u_loc(ii,jj+1)+u_loc(ii,jj-1)-dx**2)
	      end if
           ENDDO
        ENDDO
	
	
	!Black  
        DO jj=2,Ny_loc_gh-1
           DO ii=2,Nx_loc_gh-1
 
              if (mod(ii+jj,2) .eq. 0) then
              u_loc(ii,jj) = 0.25d0*(u_loc(ii+1,jj)+u_loc(ii-1,jj)+u_loc(ii,jj+1)+u_loc(ii,jj-1)-dx**2)
	      end if
	      
           ENDDO
        ENDDO

end subroutine



!!! Compute Gauss-Seidel update for even points ...
!!! A point is the average of its adjacent north-south and east-west
!!! points ...

!      Forall(k=2:int_x-2:2, m=2:int_y-2:2) Grid(k,m) = 
!     c   (Grid(k+1,m) + Grid(k-1,m) + Grid(k,m+1) + Grid(k,m-1))/4.0
!      Forall(k=3:int_x-1:2, m=3:int_y-1:2) Grid(k,m) = 
!     c   (Grid(k+1,m) + Grid(k-1,m) + Grid(k,m+1) + Grid(k,m-1))/4.0

!!! Compute Gauss-Seidel update for odd points ...
!!! A point is the average of its adjacent north-south and east-west
!!! points ...

!      Forall(k=3:int_x-1:2, m=2:int_y-2:2) Grid(k,m) = 
!     c   (Grid(k+1,m) + Grid(k-1,m) + Grid(k,m+1) + Grid(k,m-1))/4.0
!      Forall(k=2:int_x-2:2, m=3:int_y-1:2) Grid(k,m) = 
!     c   (Grid(k+1,m) + Grid(k-1,m) + Grid(k,m+1) + Grid(k,m-1))/4.0









end module mod_gs
