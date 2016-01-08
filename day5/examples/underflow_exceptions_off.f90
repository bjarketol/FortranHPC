! from: http://www.nag.co.uk/nagware/np/doc/faq.asp
Program turn_underflow_flag_off
  Use Ieee_Exceptions
  Implicit None
  type(IEEE_STATUS_TYPE) :: status
  logical :: fail


  if (.not.Ieee_support_halting(Ieee_underflow)) then
     print*,'compiler does not support halting; exiting!'
     stop
  else
     print*,'compiler supports halting!'
  endif

  Call Ieee_Get_Status(status)
  !print*,'status: ',status
  Call Ieee_Set_Halting_mode(Ieee_underflow, .false.)

  Call make_underflow(0.5)

  Call Ieee_Get_Flag(Ieee_Underflow, fail)
  print*,'fail ? ',fail
  Call Ieee_Set_Status(status)
Contains
  Subroutine make_underflow(x)
    Implicit none
    Real, Intent(In) :: x
    Real :: y
    Integer :: n
    y = x
    n = 1
    Do
      y = y**2
      If (y< 1e-4) Exit
      If (y==0) Exit
!     n = n + 1
      Print *, 'Step', n, 'value', y
    End Do
    Print *, 'Zero reached at step', n
  End Subroutine
End Program
