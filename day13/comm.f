SUBROUTINE comm() 
USE master
IF (nghbr_top.NE.MPI_PROC_NULL) THEN
    ghst_top(:) = u(2,lpimin:lpimax)
    CALL MPI_SENDRECV_REPLACE(ghst_top, lnx, MPI_DOUBLE_PRECISION, &
                         nghbr_top, 0, nghbr_top, 0, &
                         comm_cart, STATUS, ierr)
    u(1,lpimin:lpimax) = ghst_top(:)
ENDIF
IF (nghbr_bottom.NE.MPI_PROC_NULL) THEN
    ghst_bottom(:) = u(lny-1,lpimin:lpimax)
    CALL MPI_SENDRECV_REPLACE(ghst_bottom, lnx, MPI_DOUBLE_PRECISION, &
                         nghbr_bottom, 0, nghbr_bottom, 0, &
                         comm_cart, STATUS, ierr)
    u(lny,lpimin:lpimax) = ghst_bottom(:)
ENDIF
IF (nghbr_right.NE.MPI_PROC_NULL) THEN
    ghst_right(:) = u(lpjmin:lpjmax,lnx-1)
    CALL MPI_SENDRECV_REPLACE(ghst_right, lny, MPI_DOUBLE_PRECISION, &
                         nghbr_right, 0, nghbr_right, 0, &
                         comm_cart, STATUS, ierr)
    u(lpjmin:lpjmax,lnx) = ghst_right(:)
ENDIF
IF (nghbr_left.NE.MPI_PROC_NULL) THEN
    ghst_left(:) = u(lpjmin:lpjmax,2)
    CALL MPI_SENDRECV_REPLACE(ghst_left, lny, MPI_DOUBLE_PRECISION, &
                         nghbr_left, 0, nghbr_left, 0, &
                         comm_cart, STATUS, ierr)
    u(lpjmin:lpjmax,1) = ghst_left
ENDIF  
CALL MPI_BARRIER(comm_cart, ierr)
END SUBROUTINE comm

