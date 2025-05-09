
NVCC = nvcc
CFLAGS = -O2 -Xcompiler -Wall -pg -lcublas -arch=sm_60 # Keep profiling

EXE = v4.exe
SRC = v4.cu

all: $(EXE) run  # Only run normally, no profiling by default

# Build the executable
$(EXE): $(SRC)
	$(NVCC) $(CFLAGS) -o $(EXE) $(SRC)

# Run normally
run: $(EXE)
	./$(EXE)

# Profile (run separately if needed)
profile: $(EXE)
	@if [ -f gmon.out ]; then rm gmon.out; fi
	./$(EXE)  # Generate profiling data
	@if [ -f gmon.out ]; then gprof $(EXE) gmon.out > profile.txt; fi
	@cat profile.txt || echo "No profile.txt generated (profiling may not be supported)"

clean:
	rm -f $(EXE) gmon.out profile.txt

