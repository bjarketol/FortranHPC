SUBROUTINE read_namelist()
USE master
CHARACTER(LEN=*), PARAMETER :: nlfile = "name.list"
NAMELIST /namdim/ nx,ny,nstop,resi_limit,xmin,xmax,ymin,ymax,ndimi,ndimj
OPEN(10,FILE=nlfile)
READ(10,namdim)
END SUBROUTINE read_namelist
