SUBROUTINE rb_gs()
USE master
DO i=3,lnx-1,2
    DO j=2,lny-1,2
        u(j,i) = one_fourth*(u(j,  i+1) + &
                             u(j,  i-1) + &
                             u(j+1,i  ) + &
                             u(j-1,i  ) - &
                             f)
    ENDDO
ENDDO
DO i=2,lnx-1,2
    DO j=3,lny-1,2
        u(j,i) = one_fourth*(u(j,  i+1) + &
                             u(j,  i-1) + &
                             u(j+1,i  ) + &
                             u(j-1,i  ) - &
                             f)
    ENDDO
ENDDO
DO i=2,lnx-1,2
    DO j=2,lny-1,2
        u(j,i) = one_fourth*(u(j,  i+1) + &
                             u(j,  i-1) + &
                             u(j+1,i  ) + &
                             u(j-1,i  ) - &
                             f)
    ENDDO
ENDDO
DO i=3,lnx-1,2
    DO j=3,lny-1,2
        u(j,i) = one_fourth*(u(j,  i+1) + &
                             u(j,  i-1) + &
                             u(j+1,i  ) + &
                             u(j-1,i  ) - &
                             f)
    ENDDO
ENDDO    
END SUBROUTINE rb_gs
