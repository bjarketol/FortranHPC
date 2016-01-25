#!/bin/bash
OPTIMIZATION=
mpif90 $OPTIMIZATION -Wall -ffree-form -c master.f
mpif90 $OPTIMIZATION -Wall -ffree-form -c read_nl.f
mpif90 $OPTIMIZATION -Wall -ffree-form -c write2txt.f
mpif90 $OPTIMIZATION -Wall -ffree-form -c residual.f
mpif90 $OPTIMIZATION -Wall -ffree-form -c comm.f
mpif90 $OPTIMIZATION -Wall -ffree-form -c rb_gs.f
mpif90 $OPTIMIZATION -Wall -ffree-form -c main.f
mpif90 $OPTIMIZATION master.o read_nl.o write2txt.o residual.o comm.o rb_gs.o main.o -o run.exe
