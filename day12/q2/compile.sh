#!/bin/bash

mpif90 comm.f90 -o comm.exe
mpif90 comm_sr.f90 -o comm_sr.exe
mpif90 comm_rp.f90 -o comm_rp.exe
