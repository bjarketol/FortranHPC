#!/bin/bash

mpif90 -Wall -ffree-form -c master.f
mpif90 -Wall -ffree-form -c main.f
mpif90 master.o main.o -o run.exe
