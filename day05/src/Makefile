#------------------------------------------------------------------------------
# Simple Makefile for this exercise
# Author: Bjarke Tobias Olsen
# Created: 6. january 2016
#------------------------------------------------------------------------------
SHELL       = /bin/sh
TARGET      = run.exe
BIN         = run.exe

#------------------------------------------------------------------------------
# COMPILER SETTINGS (Linux)
#------------------------------------------------------------------------------
FC          = gfortran
FFLAGS      = -fbacktrace -C -Wall -fcheck=all
LD          = $(FC)
LDFLAGS     = 
LIBS        = 

#------------------------------------------------------------------------------
# BINARY DIRECTORY
#------------------------------------------------------------------------------
namelist	= ../name.list

#------------------------------------------------------------------------------
# BINARY DIRECTORY
#------------------------------------------------------------------------------
bindir      = ../bin

#------------------------------------------------------------------------------
# DEFAULT TARGET
#------------------------------------------------------------------------------
all: $(TARGET)

#------------------------------------------------------------------------------
# OBJECT FILES (OBS: Make sure no file depends on anything below it)
#------------------------------------------------------------------------------
OBJS = master.o \
	   init.o \
       take_step.o \
       write_out.o \
       read_namelist.o \
       write_restart.o \
       diag.o \
       copy.o \
       alloc.o \
       main.o

#------------------------------------------------------------------------------
# DEPENDENCIES
#------------------------------------------------------------------------------
main.o: main.f90 \
	alloc.f90 \
	copy.f90 \
	write_out.f90 \
	read_namelist.f90 \
	write_restart.f90 \
	diag.f90 \
	take_step.f90 \
	init.f90 \
	master.f90
	$(FC) $(FFLAGS) -c main.f90
copy.o: copy.f90 master.f90
	$(FC) $(FFLAGS) -c copy.f90
write_out.o: write_out.f90 master.f90
	$(FC) $(FFLAGS) -c write_out.f90
read_namelist.o: master.f90
	$(FC) $(FFLAGS) -c read_namelist.f90
write_restart.o: master.f90
	$(FC) $(FFLAGS) -c write_restart.f90
diag.o: master.f90
	$(FC) $(FFLAGS) -c diag.f90
take_step.o: take_step.f90 master.f90
	$(FC) $(FFLAGS) -c take_step.f90
init.o: init.f90 master.f90
	$(FC) $(FFLAGS) -c init.f90
master.o: master.f90
	$(FC) $(FFLAGS) -c master.f90
alloc.o: alloc.f90
	$(FC) $(FFLAGS) -c alloc.f90

#------------------------------------------------------------------------------
# LINK
#------------------------------------------------------------------------------
$(TARGET): $(OBJS)
	cp $(namelist) .
	cp $(namelist) $(bindir)
	$(LD) -o $(BIN) $(LDFLAGS) $(OBJS) $(LIBS)

#------------------------------------------------------------------------------
# INSTALL
#------------------------------------------------------------------------------
install: $(BIN)
	(cp -f $(BIN) $(bindir))

#------------------------------------------------------------------------------
# RUN
#------------------------------------------------------------------------------
run: $(BIN)
	$(BIN)

#------------------------------------------------------------------------------
# CLEAN
#------------------------------------------------------------------------------
clean:
	rm *.exe
	rm *.o
	rm *.mod
	rm name.list
	rm ../diag.dat


