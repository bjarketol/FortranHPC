#!/bin/bash

gfortran -O3 pi.f90 -o pi.exe
mpif90 pipar.f90 -o pipar.exe
