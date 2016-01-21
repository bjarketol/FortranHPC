#!/bin/bash

echo "Optimization: none"
sunf90 loop.f90 -o loop.exe
echo "Optimization: O1"
sunf90 -O1 loop.f90 -o loop_O1.exe
echo "Optimization: O2"
sunf90 -O2 loop.f90 -o loop_O2.exe
echo "Optimization: O3"
sunf90 -O3 loop.f90 -o loop_O3.exe

