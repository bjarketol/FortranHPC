#!/bin/bash

sunf95 -g -fast -fopenmp -xloopinfo pi_manu.f90 -o pi_manu.exe
sunf95 -g -fast -autopar -xloopinfo -xreduction pi_auto.f90 -o pi_auto.exe



