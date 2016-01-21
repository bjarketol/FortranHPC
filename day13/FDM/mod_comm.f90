module mod_comm

use mod_data


implicit none


public :: comm

contains

subroutine comm
implicit none
INTEGER :: ii


       !----------------- COMM GHOST-------------
!              scr1
!            _______
!           /      /    
!    scr2   /      /  dest2
!           /      /
!           /______/
!	     dest1
       
       !call MPI_Cart_shift(cart_comm,0,1,src1,dest1,ierror)
       !call MPI_Cart_shift(cart_comm,1,1,src2,dest2,ierror)
       
       
!       do i = 1,2
!            if (i.eq.1) then
!	     send = src1
!	     recv = dest1
!	     elseif (i.eq.2) then
!	     send = src2
!	     recv = dest2
!	     elseif (i.eq.3) then
!	     send = dest1
!	     recv = src1
!	     else
!	     send = dest2
!	     recv = src2
!	    end if
	  
	  
!	  if (send.ne.MPI_PROC_NULL) then
!	     
!	     if (i.eq.1) then
!             buf_send1 = u_loc(2,2:Ny_loc_gh-1)
!	     elseif (i.eq.2) then
!             buf_send1 = u_loc(2:Nx_loc_gh-1,2)
!	     elseif (i.eq.3) then
!             buf_send1 = u_loc(Nx_loc_gh-1,2:Ny_loc_gh-1)
!	     else
!             buf_send1 = u_loc(2:Nx_loc_gh-1,Ny_loc_gh-1)
!	     end if
	    
	   
!	    call MPI_ISSEND(buf_send1,Ny_loc,MPI_DOUBLE_PRECISION,src1,i,cart_comm,REQUEST,IERROR)
!	  end if
	  
	  
!	  if (recv.ne.MPI_PROC_NULL) then
!	  call MPI_RECV(buf_recv1, Ny_loc, MPI_DOUBLE_PRECISION,src1,i,cart_comm, request, IERROR)
          !call MPI_WAIT(request,status, ierror)
	  
!	  if (i.eq.1) then
!             u_loc(1,2:Ny_loc_gh-1) = buf_recv1
!	     elseif (i.eq.2) then
!             u_loc(2:Nx_loc_gh-1,1) = buf_recv1
!	     elseif (i.eq.3) then
!             u_loc(Nx_loc_gh,2:Ny_loc_gh-1) = buf_recv1 
!	     else
!             u_loc(2:Nx_loc_gh-1,Ny_loc_gh) = buf_recv1
!	  end if
  
  
!	  end if
             
!       end do
       
     


       !-------Sending-----------
       print*,'checkin', rank
       
       !call MPI_BARRIER(cart_comm,ierror)
       
!       if (src1.ne.MPI_PROC_NULL) then
!	buf_send1 = u_loc(2,2:Ny_loc_gh-1)
	
!	call MPI_ISSEND(buf_send1,Ny_loc,MPI_DOUBLE_PRECISION,src1,1,cart_comm,REQUEST1,IERROR)

!       end if
      
    !   print*,'HERE WE ARE'
       
       if (src2.ne.MPI_PROC_NULL) then
	buf_send2 = u_loc(2:Nx_loc_gh-1,2)

	!call MPI_ISSEND(buf_send2,Nx_loc,MPI_DOUBLE_PRECISION,src2,2,cart_comm,REQUEST2,IERROR)
	
	call MPI_ISSEND(1.0d0,1,MPI_DOUBLE_PRECISION,src2,2,cart_comm,REQUEST2,IERROR)
	
       end if
       
!       if (dest1.ne.MPI_PROC_NULL) then

!	buf_send3 = u_loc(Nx_loc_gh-1,2:Ny_loc_gh-1)	
!	call MPI_ISSEND(buf_send3,Ny_loc,MPI_DOUBLE_PRECISION,dest1,3,cart_comm,REQUEST3,IERROR)

!       end if
       
 !      if (dest2.ne.MPI_PROC_NULL) then

!	buf_send4 = u_loc(2:Nx_loc_gh-1,Ny_loc_gh-1)	
!	call MPI_ISSEND(buf_send4,Nx_loc,MPI_DOUBLE_PRECISION,dest2,4,cart_comm,REQUEST4,IERROR)

!       end if
       
       
      
       
       !----------Receiving------------
       
       
!       if (src1.ne.MPI_PROC_NULL) then
	
!	call MPI_RECV(buf_recv1, Ny_loc, MPI_DOUBLE_PRECISION,src1,3,cart_comm, REQUEST1, IERROR)
	!call MPI_WAIT(request1,status, ierror)
!	u_loc(1,2:Ny_loc_gh-1) = buf_recv1

!       end if
       
!       if (src2.ne.MPI_PROC_NULL) then

!	call MPI_RECV(buf_recv2, Nx_loc, MPI_DOUBLE_PRECISION,src2,4,cart_comm, REQUEST2, IERROR)
	!call MPI_WAIT(request2,status, ierror)
	u_loc(2:Nx_loc_gh-1,1) = buf_recv2

!       end if
      
!       if (dest1.ne.MPI_PROC_NULL) then
	
!	call MPI_RECV(buf_recv3, Ny_loc, MPI_DOUBLE_PRECISION,dest1,1,cart_comm, REQUEST3, IERROR)
	!call MPI_WAIT(request3,status, ierror)
	u_loc(Nx_loc_gh,2:Ny_loc_gh-1) = buf_recv3  

	   
!        end if
       
       
       if (dest2.ne.MPI_PROC_NULL) then

       ! call MPI_RECV(buf_recv4, Nx_loc, MPI_DOUBLE_PRECISION,dest2,2,cart_comm, REQUEST4, IERROR)
	call MPI_RECV(buf_recv4, 1, MPI_DOUBLE_PRECISION,dest2,2,cart_comm, REQUEST4, IERROR)
	
	!call MPI_WAIT(request4,status, ierror)
	u_loc(2:Nx_loc_gh-1,Ny_loc_gh) = buf_recv4    
        
       end if

print*,'rank',rank,'dest',dest1,dest2
       print*,'rank',rank,'src',src1,src2  

       
       !call MPI_WAITALL(COUNT, ARRAY_OF_REQUESTS, ARRAY_OF_STATUSES, IERROR)
     
       print*,'checkout', rank
       !----------------- COMM GHOST END-----------------


end subroutine


end module mod_comm
