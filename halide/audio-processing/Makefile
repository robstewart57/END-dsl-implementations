# from https://github.com/craigsapp/midifile
midifile_HOME~=/path/to/midifile
LIBFILE   = midifile
LIBDIR    = lib
DEFINES   =
INCDIR    = include
INCPATH   = $(midifile_HOME)/$(INCDIR)
LIBPATH   = $(midifile_HOME)/$(LIBDIR)/lib$(LIBFILE).a
PREFLAGS  = -O3 -Wall -I$(INCPATH) -L$(LIBPATH)
COMPILER  = g++ -std=c++11

all: audio-program

audio-program: $(LIBPATH)
	$(COMPILER) $(PREFLAGS) audio-processing.cpp
