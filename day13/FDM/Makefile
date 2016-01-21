# Define program names and objects:
PGM = Pacman      
OBJ = mod_data.o mod_gs.o mod_IO.o mod_comm.o mod_res.o main.o


##################################################################################
LIBPATH =
LIBS = 

FFLAGS = -g -C #-O3 # -xloopinfo -xvpara # -fbounds-check                                                          
#
COMPILE = mpif90
LINK =  mpif90
##################################################################################


# OpenMP variable
#SUNW_MP_THR_IDLE=spin
#OMP_NUM_THREADS=8
#env_var = OMP_NUM_THREADS=$(OMP_NUM_THREADS)


.SUFFIXES: .f90
.f90.o:
	$(COMPILE) -c $(FFLAGS) $<
 
.SUFFIXES: .f
.f.o:
	$(COMPILE) -c $(FFLAGS) $<
	
	 
# Rule for building the program:
$(PGM): $(OBJ)
	$(LINK) -o $(PGM) $(FFLAGS) $(OBJ) $(LIBPATH) $(LIBS)
	chmod go+rx $(PGM)
      
# Dependencies:
main.o:            main.f90 mod_data.o mod_gs.o mod_comm.o mod_res.o
mod_data.o:        mod_data.f90 
mod_gs.o:          mod_gs.f90 mod_data.o
mod_res.o:         mod_res.f90 mod_data.o
mod_comm.o:        mod_comm.f90 mod_data.o
mod_IO.o:          mod_IO.f90 mod_data.o

# Clean-up rule:
clean:
	rm -f $(OBJ) core *.inc *.vo *.mod

# Make profile
collect_$(PGM):$(PGM)
	@clear
	@which f90
	@er_rm -f prof_$(PGM).er
	@mkdir /tmp/$(USER)
	@collect -d /tmp/$(USER) -o prof_$(PGM).er ./$(PGM)
	@er_mv /tmp/$(USER)/prof_$(PGM).er .
	@rm -R /tmp/$(USER)
# IF:  mkdir: Failed to make directory "/tmp/s021851"; File exists
# then: rm -R /tmp/s021851 (og yes!!!)

# See profile	
analyzer_$(PGM):$(PGM)
	@analyzer prof_$(PGM).er

# Collect med multithread
colrun_$(PGM):$(PGM)
	@clear
	@which f90
	@echo 'number of threads' $(OMP_NUM_THREADS)
	@er_rm -f prof_$(PGM).er
	@mkdir /tmp/$(USER)
	@$(env_var) collect -d /tmp/$(USER) -o prof_$(PGM).er ./$(PGM)
	@er_mv /tmp/$(USER)/prof_$(PGM).er .
	@rm -R /tmp/$(USER)

# Kør med multithread
run_$(PGM):$(PGM)	
	$(env_var) ./$(PGM)
	
	
run_ptime:
	@clear
	@which f90
	@echo 'number of threads' $(OMP_NUM_THREADS)
	@$(env_var) ptime nice ./$(PGM) 
