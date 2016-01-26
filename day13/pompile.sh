#!/bin/bash

mpif90 -O3 -Mfreeform -c master.f
mpif90 -O3 -Mfreeform -c main.f
mpif90 -O3  master.o main.o -o run.exe
