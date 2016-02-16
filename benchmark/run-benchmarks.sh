#!/bin/sh

# ensure that all executables are accessible from the directories
# listed in your $PATH environment variable.
n=3

for program in prog1-shallow-vector
do
    calc=0.0
    for i in $(seq 1 $n)
    do
        theTime=$($program "../images/maisie.png" "../images/$program-out.png")
        calc=$(echo "$calc + $theTime"|bc)
        # echo $calc
    done
    calc=$(echo "scale=4;$calc / $n.0"|bc)
    echo "$program mean runtime over $n runs: $calc"
done
