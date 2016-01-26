       PROGRAM main
       
       use mod_data
       use mod_comm
       use mod_gs
       use mod_res
       use mod_IO
       !include 'mpif.h'
       
       IMPLICIT NONE
      ! INTEGER :: status(MPI_STATUS_SIZE)
      
        
       
       call MPI_INIT(ierror)
       call MPI_COMM_SIZE(MPI_COMM_WORLD, nproc, ierror)
       call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierror)
       
       N = 10000
	    
       Nx = N
       Ny = N

       ! Initialize
       Lx = 1.0d0; Ly = 1.0d0 !domain size
       
       reorder = .false.
       ndim=2
       period(1) = .false.
       period(2) = .false.
       dims(1) = 2
       dims(2) = 2
       
       
       !Local dimension without ghost nodes
       Nx_loc = Nx/dims(1)  
       Ny_loc = Ny/dims(2)
       
       !Local dimension with ghost nodes
       Nx_loc_gh = Nx_loc + 2
       Ny_loc_gh = Ny_loc + 2
       
       !Spacing
       dx = Lx/dble(Nx+1)
       dy = Ly/dble(Ny+1)
       
       
       ALLOCATE(u(Nx+2,Ny+2),u_loc(Nx_loc_gh,Ny_loc_gh))
       ALLOCATE(buf_send1(Ny_loc),buf_recv1(Ny_loc))
       ALLOCATE(buf_send2(Nx_loc),buf_recv2(Nx_loc))
       ALLOCATE(buf_send3(Ny_loc),buf_recv3(Ny_loc))
       ALLOCATE(buf_send4(Nx_loc),buf_recv4(Nx_loc))
       ALLOCATE(edof2(Nx_loc))
       
       !u(1:Nx+2,1:Ny+2) = 1.0d0
       u_loc = 1.0d0
       eps = 10.0d0
             
       
       call MPI_CART_CREATE(MPI_COMM_WORLD,ndim,dims,period,reorder,cart_comm,ierror)
       
       
       !----------------- BC-----------------
!              scr1
!            _______
!           /      /    
!    scr2   /      /  dest2
!           /      /
!           /______/
!	     dest1
       
       call MPI_Cart_shift(cart_comm,0,1,src1,dest1,ierror)
       call MPI_Cart_shift(cart_comm,1,1,src2,dest2,ierror)

       !print*,'rank',rank,'dest',dest1,dest2
       !print*,'rank',rank,'src',src1,src2
       
       if (src1.eq.MPI_PROC_NULL) then
           u_loc(1,:) = 0.0d0
       end if
       if (src2.eq.MPI_PROC_NULL) then
           u_loc(:,1) = 0.0d0
       end if
       if (dest1.eq.MPI_PROC_NULL) then
           u_loc(Nx_loc_gh,:) = 0.0d0
       end if
       if (dest2.eq.MPI_PROC_NULL) then
           u_loc(:,Ny_loc_gh) = 0.0d0
       end if
       
       !Checking BC's
       !if (rank.eq.0) then
       !do i=1,12
       !print*, u_loc(i,:)
       !end do
       !end if
       !pause
       
       !----------------- BC END-----------------
       
       
       do istep = 1,1
       
       !   print*,'rank',rank,'dest',dest1,dest2
       !   print*,'rank',rank,'src',src1,src2
	  call comm
	  
	  call rb_gs
	  
	  call res
	  
	  call MPI_ALLREDUCE(r,eps,1,MPI_DOUBLE_PRECISION,MPI_SUM,cart_comm,ierror)
	  
	  
	  if (eps.le.0.01d0) then

	  !call MPI_GATHER(u_loc, SENDCOUNT, MPI_DOUBLE_PRECISION, u, RECVCOUNT,MPI_DOUBLE_PRECISION, 0,cart_comm,IERROR)

	  if (rank.eq.0) then
	  call output
	  print*,'converged in', istep
	  end if
	  
	  call MPI_BARRIER(cart_comm,ierror)
	  
	  exit
	  end if
	  
	    
       
        end do
	
      
      ! print*,'rank',rank,'dest',dest1,dest2
      ! print*,'rank',rank,'src',src1,src2
       
       
       !call MPI_CART_RANK
       
       !call MPI_CART_SHIFT !nabo MPI_SENDRECV
       
       
       
       
       
       call MPI_FINALIZE(ierror)
       
       END PROGRAM main
