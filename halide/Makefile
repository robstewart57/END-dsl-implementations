HALIDE_HOME?=/path/to/Halide

all: prog1 prog2 prog3 prog4

prog1: DSL.o prog1.o
	g++ DSL.o prog1.o -o prog1 -g -std=c++11 -I $(HALIDE_HOME)/include -I $(HALIDE_HOME)/tools -L $(HALIDE_HOME)/bin -lHalide `libpng-config --cflags --ldflags` -lpthread -ldl

prog2: DSL.o prog2.o
	g++ DSL.o prog2.o -o prog2 -g -std=c++11 -I $(HALIDE_HOME)/include -I $(HALIDE_HOME)/tools -L $(HALIDE_HOME)/bin -lHalide `libpng-config --cflags --ldflags` -lpthread -ldl

prog3: DSL.o prog3.o
	g++ DSL.o prog3.o -o prog3 -g -std=c++11 -I $(HALIDE_HOME)/include -I $(HALIDE_HOME)/tools -L $(HALIDE_HOME)/bin -lHalide `libpng-config --cflags --ldflags` -lpthread -ldl

prog4: DSL.o prog4.o
	g++ DSL.o prog4.o -o prog4 -g -std=c++11 -I $(HALIDE_HOME)/include -I $(HALIDE_HOME)/tools -L $(HALIDE_HOME)/bin -lHalide `libpng-config --cflags --ldflags` -lpthread -ldl

prog1.o:
	g++ -c prog1.cpp -g -std=c++11 -I $(HALIDE_HOME)/include -I $(HALIDE_HOME)/tools -L $(HALIDE_HOME)/bin -lHalide `libpng-config --cflags --ldflags` -lpthread -ldl

prog2.o:
	g++ -c prog2.cpp -g -std=c++11 -I $(HALIDE_HOME)/include -I $(HALIDE_HOME)/tools -L $(HALIDE_HOME)/bin -lHalide `libpng-config --cflags --ldflags` -lpthread -ldl

prog3.o:
	g++ -c prog3.cpp -g -std=c++11 -I $(HALIDE_HOME)/include -I $(HALIDE_HOME)/tools -L $(HALIDE_HOME)/bin -lHalide `libpng-config --cflags --ldflags` -lpthread -ldl

prog4.o:
	g++ -c prog4.cpp -g -std=c++11 -I $(HALIDE_HOME)/include -I $(HALIDE_HOME)/tools -L $(HALIDE_HOME)/bin -lHalide `libpng-config --cflags --ldflags` -lpthread -ldl

DSL.o:
	g++ -c DSL.cpp -g -std=c++11 -I $(HALIDE_HOME)/include -I $(HALIDE_HOME)/tools -L $(HALIDE_HOME)/bin -lHalide `libpng-config --cflags --ldflags` -lpthread -ldl

clean:
	rm *.o prog1 prog2 prog3
