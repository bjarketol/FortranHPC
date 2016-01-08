SUBROUTINE read_namelist
USE MASTER
IMPLICIT NONE
CHARACTER(len=*), PARAMETER :: nlfile = "name.list"
NAMELIST /namdim/ nx,ny,dt,nstop,d,restart
OPEN(10,FILE=nlfile)
READ(10,namdim)
END SUBROUTINE read_namelist
