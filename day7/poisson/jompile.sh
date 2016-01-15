#!/bin/bash
/opt/intel/bin/ifort -c master.f90
/opt/intel/bin/ifort -c alloc.f90
/opt/intel/bin/ifort -fopenmp -c main.f90
/opt/intel/bin/ifort -fopenmp master.o alloc.o main.o -o main.exe
