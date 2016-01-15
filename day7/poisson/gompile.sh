#!/bin/bash
gfortran -c master.f90
gfortran -c alloc.f90
gfortran -fopenmp -c main.f90
gfortran -fopenmp master.o alloc.o main.o -o main.exe
