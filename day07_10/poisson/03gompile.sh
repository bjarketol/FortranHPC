#!/bin/bash
gfortran -O3 -c master.f90
gfortran -O3 -c alloc.f90
gfortran -O3 -fopenmp -c main.f90
gfortran -O3 -fopenmp master.o alloc.o main.o -o main.exe
