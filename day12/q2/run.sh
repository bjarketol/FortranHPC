#!/bin/bash

mpirun -np 6 ./comm.exe
mpirun -np 6 ./comm_sr.exe
mpirun -np 6 ./comm_rp.exe
