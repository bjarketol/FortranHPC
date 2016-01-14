sunf90 -c master.f90
sunf90 -c alloc.f90
sunf90 -xinstrument=datarace -fopenmp -c main.f90
sunf90 -xinstrument=datarace master.o alloc.o main.o -o main.exe
