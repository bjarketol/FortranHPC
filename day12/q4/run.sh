#!/bin/bash

./pi.exe
mpirun -np 8 ./pipar.exe
