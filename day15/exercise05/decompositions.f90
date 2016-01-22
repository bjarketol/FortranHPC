PROGRAM decompositions

  ! declaration:
  IMPLICIT NONE
  INTEGER,PARAMETER                :: nsub = 16      ! desired number of subdomains
  INTEGER                          :: n              ! number of particles
  INTEGER,DIMENSION(:),ALLOCATABLE :: subdomlabel    ! particle label saying to which subdomain it belongs
  REAL   ,DIMENSION(:),POINTER     :: x,y            ! particle positions
  CHARACTER(LEN = 256)             :: filename

  ! read in the particle positions from file particles.dat:
  filename = 'particles.dat'
  CALL read_particles(filename,n,x,y)
  ALLOCATE(subdomlabel(n))
  subdomlabel = 1 ! for now all particles share the same subdomain


  ! here you enter the subroutine decomposing the (rectangular) domain
  ! enclosing all particles into nsub subdomains, it should output the filled
  ! array subdomlabel:
  ! CALL pencils       (nsub,n,x,y,subdomlabel)
  ! or
  ! CALL cuboid        (nsub,n,x,y,subdomlabel)
  ! or
  ! CALL adapt_quadtree(nsub,n,x,y,subdomlabel)
  



  ! the particle positions and labels are written to a file:
  filename = 'decomp.pdb'
  CALL write_pdbfile(filename,n,x,y,subdomlabel)
  ! or
  filename = 'decomp.txt'
  CALL write_file(filename,n,x,y,subdomlabel)

  ! finalize:
  DEALLOCATE(x)
  DEALLOCATE(y)
  DEALLOCATE(subdomlabel)



CONTAINS



  SUBROUTINE write_pdbfile(filename,n,x,y,subdomlabel)
    ! this subroutine writes a .pdb-file of your particles which allows for
    ! color-coding according to the subdomlabel

    IMPLICIT NONE
    INTEGER             ,INTENT(IN) :: n
    INTEGER,DIMENSION(n),INTENT(IN) :: subdomlabel
    REAL   ,DIMENSION(n),INTENT(IN) :: x,y
    INTEGER                         :: i
    CHARACTER                       :: altloc
    CHARACTER (LEN =  4 )           :: atom_name
    CHARACTER                       :: chains
    CHARACTER (LEN =  2 )           :: charge
    CHARACTER (LEN =  2 )           :: element
    CHARACTER                       :: icode
    INTEGER                         :: resno
    REAL(8)                         :: occ
    CHARACTER (LEN =  3 )           :: resname
    CHARACTER (LEN =  4 )           :: segid
    CHARACTER (LEN = 256)           :: filename
    
    atom_name = 'H   '
    altloc = ' '
    resname = '   '
    chains = ' '
    resno = 0
    icode = ' '
    occ = 1.0D+00
    segid = '    '
    element = '  '
    charge = '  '
    
    OPEN(23,FILE=filename,FORM='FORMATTED',STATUS='REPLACE')
    
    DO i=1,n
      WRITE (23, &
        '(a6,i5,1x,a4,a1,a3,a1,1x,i4,a1,3x,3f8.3,2f6.2,6x,a4,a2,a2)' ) &
        'ATOM  ', i, atom_name, altloc, resname, chains, &
        resno,icode, x(i),y(i),0., occ, REAL(subdomlabel(i)), segid, element, charge
    
    END DO
    WRITE (23, &
      '(a6,i5,1x,4x,a1,a3,1x,a1,i4,a1)' ) &
      'TER   ', n+1, altloc, resname, chains, resno, icode
    CLOSE(23)

  END SUBROUTINE write_pdbfile




  SUBROUTINE write_file(filename,n,x,y,subdomlabel)
    ! this subroutine writes an ASCII-file stating the particle positions and
    ! their subdomlabel

    IMPLICIT NONE
    INTEGER             ,INTENT(IN) :: n
    INTEGER,DIMENSION(n),INTENT(IN) :: subdomlabel
    REAL   ,DIMENSION(n),INTENT(IN) :: x,y
    CHARACTER(LEN = 256),INTENT(IN) :: filename
    INTEGER                         :: i
    
    OPEN(23,FILE=filename,FORM='FORMATTED',STATUS='REPLACE')
    WRITE(23,'(A1,3A16)')'#','x','y','subdomlabel'
    DO i=1,n
       WRITE (23,'(X,2E16.6,I16)')x(i),y(i),subdomlabel(i)
    END DO
    CLOSE(23)

  END SUBROUTINE write_file

  SUBROUTINE read_particles(filename,n,x,y)
    ! this subroutine reads the particle positions given in particles.dat

    IMPLICIT NONE
    INTEGER                  ,INTENT(OUT):: n
    REAL,DIMENSION(:),POINTER            :: x,y
    CHARACTER(LEN = 256)     ,INTENT(IN) :: filename
    INTEGER                              :: i
    
    OPEN(23,FILE=filename,FORM='UNFORMATTED',STATUS='OLD')
    READ(23)n
    ALLOCATE(x(n))
    ALLOCATE(y(n))
    DO i=1,n
       READ(23)x(i),y(i)    
    END DO
    CLOSE(23)

  END SUBROUTINE read_particles

END PROGRAM decompositions
