#!/bin/bash

OPTIM=

#mpif90 $OPTIM -Mfreeform -c init_random_seed.f
mpif90 $OPTIM -Mfreeform -c master.f
mpif90 $OPTIM -Mfreeform -c main.f
mpif90 master.o main.o -o run.exe
