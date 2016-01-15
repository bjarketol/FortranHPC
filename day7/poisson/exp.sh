#!/bin/bash

#echo "#thrds wall user sys"; for t in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do echo -n " $t "; OMP_NUM_THREADS=$t time -f "%e %U %S" ./main.exe ; done

echo -n "16 "; OMP_NUM_THREADS=16 OMP_PROC_BIND=true numactl -C 0-7,10-17 time -f "%e %U %S" ./main.exe
echo -n "17 "; MP_NUM_THREADS=17 OMP_PROC_BIND=true numactl -C 0-8,10-17 time -f "%e %U %S" ./main.exe
echo -n "18 "; MP_NUM_THREADS=18 OMP_PROC_BIND=true numactl -C 0-8,10-18 time -f "%e %U %S" ./main.exe
echo -n "19 "; MP_NUM_THREADS=19 OMP_PROC_BIND=true numactl -C 0-9,10-18 time -f "%e %U %S" ./main.exe
echo -n "20 "; MP_NUM_THREADS=20 OMP_PROC_BIND=true numactl -C 0-9,10-19 time -f "%e %U %S" ./main.exe



