program simple4
implicit none
integer ierr,my_rank,size,partner
CHARACTER*50 greeting
include 'mpif.h'
integer status(MPI_STATUS_SIZE)

call mpi_init(ierr)
call mpi_comm_rank(MPI_COMM_WORLD,my_rank,ierr)
call mpi_comm_size(MPI_COMM_WORLD,size,ierr)

write(greeting,100) my_rank, size

if(my_rank.eq.0) then
    write(6,*) "HELLO WORLD ", greeting
    do partner=1,size-1
        call mpi_recv(greeting, 50, MPI_CHARACTER, partner, 1, &  
                      MPI_COMM_WORLD, status, ierr)
        write(6,*) greeting
    end do
else
    call mpi_send(greeting, 50, MPI_CHARACTER, 0, 1, & 
                  MPI_COMM_WORLD, ierr)
end if

if(my_rank.eq.0) then
    write(6,*) 'That is all for now!'
end if

call mpi_finalize(ierr)

100  format('processor ', I2, ' of ', I2)

end

