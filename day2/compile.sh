#!/bin/bash

gfortran -fcheck=all -Wall -c ex3_glob.f95
gfortran -fcheck=all -Wall -c ex3_main.f95

gfortran ex3_main.o ex3_glob.o -o ex3.exe


