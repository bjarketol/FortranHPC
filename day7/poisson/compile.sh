sunf90 -c master.f90
sunf90 -c alloc.f90
sunf90 -c main.f90
sunf90 master.o alloc.o main.o -o main.exe
