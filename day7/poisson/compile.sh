sunf90 -c master.f90
sunf90 -c alloc.f90
sunf90 -fopenmp -c main.f90
sunf90 -fopenmp master.o alloc.o main.o -o main.exe
