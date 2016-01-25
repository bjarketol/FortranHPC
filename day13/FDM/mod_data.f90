       module mod_data
       
       include 'mpif.h'
       !use mpi
       
       
       ! Global variables
       INTEGER, PARAMETER :: MKD = KIND(1.0D0)
       INTEGER, PARAMETER :: MKS = KIND(1.0E0)
       INTEGER, PARAMETER :: MK = MKD
       REAL(MK), DIMENSION(:,:), ALLOCATABLE :: u,u_loc
       REAL(MK), DIMENSION(:), ALLOCATABLE :: buf_send1,buf_recv1
       REAL(MK), DIMENSION(:), ALLOCATABLE :: buf_send2,buf_recv2
       REAL(MK), DIMENSION(:), ALLOCATABLE :: buf_send3,buf_recv3
       REAL(MK), DIMENSION(:), ALLOCATABLE :: buf_send4,buf_recv4
       INTEGER, DIMENSION(:), ALLOCATABLE :: edof2
       REAL(MK) :: dx,dy,Lx,Ly,dt,diff,t
       INTEGER :: istep,i,j,Nx,Ny,N,Nx_loc,Ny_loc,Nx_loc_gh,Ny_loc_gh
       INTEGER :: src1,dest1,src2,dest2,send,recv,edof1s,edof1r
       INTEGER :: nthread
       integer :: rank, nproc, ierror, tag,ierr
       LOGICAL :: period(2),reorder
       INTEGER :: ndim, dims(2),cart_comm
       INTEGER, DIMENSION(2) :: coords
       REAL(MK) :: eps,r
       INTEGER :: status(MPI_STATUS_SIZE),ARRAY_OF_STATUSES(MPI_STATUS_SIZE)
       INTEGER :: request,request1,request2,request3,request4,handle
       
       
       end module mod_data
