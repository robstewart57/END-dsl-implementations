# from https://github.com/craigsapp/midifile
MIDIFILE_HOME~=/path/to/midifile

HALIDE_HOME?=/path/to/Halide

LIBFILE   = midifile
LIBDIR    = lib
DEFINES   =
INCDIR    = include
OBJDIR    = obj
INCPATH   = $(MIDIFILE_HOME)/$(INCDIR)
LIBPATH   = $(MIDIFILE_HOME)/$(LIBDIR)/lib$(LIBFILE).a
OBJPATH   = $(MIDIFILE_HOME)/$(OBJDIR)
COMPILER  = g++ -std=c++11
PREFLAGS  = -O3 -Wall -I$(INCPATH) -L$(LIBPATH) $(OBJPATH)/* -I $(HALIDE_HOME)/include -I $(HALIDE_HOME)/tools -L $(HALIDE_HOME)/bin -lHalide `libpng-config --cflags --ldflags` -lpthread -ldl

all: audio-program

audio-program: $(LIBPATH)
	$(COMPILER) $(PREFLAGS) audio-processing.cpp
