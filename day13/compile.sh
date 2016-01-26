#!/bin/bash

mpif90 -O3 -ffree-form -c master.f
mpif90 -O3 -ffree-form -c main.f
mpif90 -O3  master.o main.o -o run.exe
