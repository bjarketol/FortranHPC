#!/bin/bash

OMP_PROC_BIND=true numactl -C 0-7,10-17
time ./main.exe


