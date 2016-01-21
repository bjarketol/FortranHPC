#!/bin/bash

echo "Optimization: none"
gfortran loop.f90 -o loop.exe
echo "Optimization: O1"
gfortran -O1 loop.f90 -o loop_O1.exe
echo "Optimization: O2"
gfortran -O2 loop.f90 -o loop_O2.exe
echo "Optimization: O3"
gfortran -O3 loop.f90 -o loop_O3.exe

