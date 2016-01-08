program main
implicit none
type point
    real :: x, y
end type point
type, extends(point) :: data_point
    real, allocatable :: data_value(:)
end type data_point
class(point), pointer :: a, b
class(data_point), pointer :: c, d
allocate(a,b,c,d)
allocate(c%data_value(100))

a%x = 2.0; a%y = 2.0
b%x = 4.0; b%y = 4.0

c%x = -2.0; c%y = -2.0; c%data_value = 100
d%x = 4.0; d%y = 4.0

print*, "Distance(a,b) = ", distance(a, b)
print*, "Distance(c,d) = ", distance(c, d)

contains 
real function distance(a,b)
class(point) :: a,b
distance = sqrt((a%x-b%x)**2.0 + (a%y-b%y)**2.0)
end function distance
end program main
