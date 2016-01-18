#!/bin/bash

time OMP_NUM_THREADS=16 OMP_PROC_BIND=true numactl -C 0-7,10-17 ./main.exe


