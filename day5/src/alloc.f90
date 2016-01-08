MODULE allocater
IMPLICIT NONE
REAL, DIMENSION(:,:), ALLOCATABLE :: swork
REAL*8, DIMENSION(:,:), ALLOCATABLE :: dwork
INTERFACE alloc
  MODULE PROCEDURE salloc, dalloc
END INTERFACE alloc
CONTAINS

  SUBROUTINE salloc(f, n, m)
  IMPLICIT NONE
  REAL, DIMENSION(:,:), ALLOCATABLE :: f
  INTEGER, INTENT(IN) :: n, m
  IF (.NOT.ALLOCATED(f)) THEN
    ALLOCATE(f(n,m))
  ELSE
    ALLOCATE(swork(n, m))
    swork(1:SIZE(f(:,1)), 1:SIZE(f(1,:))) = f(:,:)
    f = swork
  ENDIF
  END SUBROUTINE salloc
 
  SUBROUTINE dalloc(f, n, m)
  IMPLICIT NONE
  REAL*8, DIMENSION(:,:), ALLOCATABLE :: f
  INTEGER, INTENT(IN) :: n, m
  IF (.NOT.ALLOCATED(f)) THEN
    ALLOCATE(f(n, m))
  ELSE
    ALLOCATE(swork(n, m))
    dwork(1:SIZE(f(:,1)), 1:SIZE(f(1,:))) = f(:,:)
    f = dwork
  ENDIF
  END SUBROUTINE dalloc

END MODULE allocater
