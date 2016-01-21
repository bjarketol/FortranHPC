PROGRAM pi
IMPLICIT NONE
REAL*8 :: xmin,xmax,ymin,ymax
REAL*8 :: x,y,r,pival,one
INTEGER :: it, nstop, nin, nout


nstop = 1000000

xmin = 0.0
xmax = 1.0
ymin = 0.0
ymax = 1.0

nin  = 0 
nout = 0

one = 1.0

DO it = 1,nstop
    
    CALL RANDOM_NUMBER(x)
    CALL RANDOM_NUMBER(y)

    r = SQRT(x*x+y*y)
    
    IF (r.LE.one) THEN
        nin = nin + 1
    ELSE
        nout = nout + 1
    ENDIF

ENDDO

pival = 4.0 * float(nin) / float(nstop)

PRINT*, "PI AFTER",nstop,"ITERATIONS IS:",pival


END PROGRAM pi
