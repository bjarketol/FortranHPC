#!/bin/bash

OPTIM=

#mpif90 $OPTIM -Wall -fbounds-check -ffree-form -c init_random_seed.f
mpif90 $OPTIM -Wall -fbounds-check -ffree-form -c master.f
mpif90 $OPTIM -Wall -fbounds-check -ffree-form -c main.f
mpif90 master.o init_random_seed.o main.o -o run.exe
