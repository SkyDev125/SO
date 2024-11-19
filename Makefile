# Directories
CURDIR := $(shell pwd)
OUTDIR = $(CURDIR)/out
REPORTDIR = $(CURDIR)/report

# Source Files
SRC = $(wildcard $(CURDIR)/*.c)

# Targets
FILENAME = main
TARGET = $(OUTDIR)/$(FILENAME).out
DEBUGTARGET = $(OUTDIR)/$(FILENAME).debug
INPUT_FILE = $(CURDIR)/$(FILENAME).in

# Compiler and flags
CC = gcc
CCLAGS = -Wall -Wextra -Werror
VALFLAGS = --leak-check=full --show-leak-kinds=all --track-origins=yes --log-file=$(REPORTDIR)/valgrind.log
GPROFFLAGS = gmon.out -b -p -q -A > $(REPORTDIR)/gprof.log
LIZFLAGS = -l c -Eduplicate -a 5 -C 10 -L 1000 -a 5 -E NS -t 4 -o $(REPORTDIR)/lizard.html

# Default rule
all: $(TARGET) valgrind gprof lizard

# interactive rule
inter: $(TARGET) inter-valgrind inter-gprof lizard

# Ensure the output directory exists
$(OUTDIR):
	mkdir -p $(OUTDIR)

# Ensure the report directory exists
$(REPORTDIR):
	mkdir -p $(REPORTDIR)

# Compile and run checkers
$(TARGET): $(OUTDIR)
	$(CC) $(CCLAGS) -o $(TARGET) $(SRC)

# Compile and run debug
$(DEBUGTARGET): $(OUTDIR)
	$(CC) $(CCLAGS) -pg -o $(DEBUGTARGET) $(SRC)

# Run valgrind
valgrind: $(TARGET) $(REPORTDIR)
	valgrind $(VALFLAGS) $(TARGET) < $(INPUT_FILE)

# Run valgrind Interactive
inter-valgrind: $(TARGET) $(REPORTDIR)
	valgrind $(VALFLAGS) $(TARGET)

# Run gprof
gprof: $(DEBUGTARGET) $(REPORTDIR)
	$(DEBUGTARGET) < $(INPUT_FILE)
	gprof $(DEBUGTARGET) $(GPROFFLAGS)
	rm gmon.out

# Run gprof Interactive
inter-gprof: $(DEBUGTARGET) $(REPORTDIR)
	$(DEBUGTARGET)
	gprof $(DEBUGTARGET) $(GPROFFLAGS)
	rm gmon.out

# Run lizard
lizard: $(REPORTDIR)
	lizard $(LIZFLAGS) $(SRC)

# Clean rule
clean:
	rm -rf $(OUTDIR)
	rm -rf $(REPORTDIR)