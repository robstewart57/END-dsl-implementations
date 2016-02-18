SAC2CDIR~=/home/rob/sw/sac/sac2c
COMPILER=$(SAC2CDIR)/bin/sac2c
COMPILER_ARGS=-t mt_pth

# all: prog1 prog2 prog3 prog4 prog5
all: dsl prog1 prog2 prog5

prog1: dsl
	$(COMPILER) $(COMPILER_ARGS) prog1.sac -o prog1

prog2: dsl
	$(COMPILER) $(COMPILER_ARGS) prog2.sac -o prog2

prog3: dsl
	$(COMPILER) $(COMPILER_ARGS) prog3.sac -o prog3

prog4: dsl
	$(COMPILER) $(COMPILER_ARGS) prog4.sac -o prog4

prog5: dsl
	$(COMPILER) $(COMPILER_ARGS) prog5.sac -o prog5

dsl:
	$(COMPILER) $(COMPILER_ARGS) DSL.sac
