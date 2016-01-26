SUBROUTINE residual()
USE master
lresi = 0.0
DO i = 2,lpnx
    DO j = 2,lpny
        iresi =         ABS(                 &
                one_over_hsq * (u(j  ,i+1) + &
                                u(j  ,i-1) + &
                                u(j+1,i  ) + & 
                                u(j-1,i  ) - &
                            4.0*u(j  ,i  ))-1.0)
        lresi = lresi + iresi
    ENDDO
ENDDO

IF (nproc.EQ.1) THEN
    resi = lresi
ELSE
    CALL MPI_BARRIER(comm_cart, ierr) 
    CALL MPI_ALLREDUCE_(lresi, resi, 1, MPI_DOUBLE_PRECISION, &
                        MPI_SUM, comm_cart, ierr)
ENDIF

END SUBROUTINE residual

