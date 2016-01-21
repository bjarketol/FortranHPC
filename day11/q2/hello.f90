program hello
implicit none
integer ierr,my_rank,size
include 'mpif.h'
call mpi_init(ierr)
call mpi_comm_rank(MPI_COMM_WORLD,my_rank,ierr)
call mpi_comm_size(MPI_COMM_WORLD,size,ierr)

!print rank and size to screen


call mpi_finalize(ierr)


if (my_rank.eq.0) then
    print*, "HELLO,WORLD!, my rank:", my_rank, "size:",size
else
    print*, "my rank:", my_rank, "size:",  size
endif

end
