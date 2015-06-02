set -x

make
rm -fv *ANSI*tiff

./pattern8  -min 0.0 -max 10000.0  
./pattern8  -min 0.0 -max 10000.0  -flip


./pattern8  -min 0.1 -max 10000.0  
./pattern8  -min 0.1 -max 10000.0  -flip

./pattern8  -min 0.1 -max 200.0  
./pattern8  -min 0.1 -max 200.0  -flip

./pattern8  -min 0.01 -max 200.0  
./pattern8  -min 0.01 -max 200.0  -flip

./pattern8  -min 0.05 -max 200.0  
./pattern8  -min 0.05 -max 200.0  -flip

./pattern8  -min 0.005 -max 200.0  
./pattern8  -min 0.005 -max 200.0  -flip

./pattern8  -min 0.0 -max 200.0  
./pattern8  -min 0.0 -max 200.0  -flip

./pattern8  -min 0.5 -max 200.0  
./pattern8  -min 0.5 -max 200.0  -flip

./pattern8  -min 1.0 -max 200.0  
./pattern8  -min 1.0 -max 200.0  -flip

./pattern8  -min 2.0 -max 200.0  
./pattern8  -min 2.0 -max 200.0  -flip

./pattern8  -min 5.0 -max 200.0  
./pattern8  -min 5.0 -max 200.0  -flip

./pattern8  -min 0.0 -max 500.0  
./pattern8  -min 0.0 -max 500.0  -flip

./pattern8  -min 0.1 -max 500.0  
./pattern8  -min 0.1 -max 500.0  -flip

./pattern8  -min 0.5 -max 500.0  
./pattern8  -min 0.5 -max 500.0  -flip

./pattern8  -min 1.0 -max 500.0  
./pattern8  -min 1.0 -max 500.0  -flip

./pattern8  -min 2.0 -max 500.0  
./pattern8  -min 2.0 -max 500.0  -flip

./pattern8  -min 5.0 -max 500.0  
./pattern8  -min 5.0 -max 500.0  -flip



./pattern8  -min 0.0 -max 0.01  
./pattern8  -min 0.0 -max 0.02
./pattern8  -min 0.0 -max 0.03
./pattern8  -min 0.0 -max 0.04
./pattern8  -min 0.0 -max 0.05
./pattern8  -min 0.0 -max 0.1
./pattern8  -min 0.0 -max 0.5


./pattern8  -min 0.05 -max 0.1
./pattern8  -min 0.05 -max 0.2
./pattern8  -min 0.05 -max 0.3
./pattern8  -min 0.05 -max 0.4
./pattern8  -min 0.05 -max 0.5


./pattern8  -min 0.25 -max 2.5
./pattern8  -min 0.25 -max 25.0
./pattern8  -min 0.25 -max 250.0
./pattern8  -min 0.25 -max 500.0
./pattern8  -min 0.25 -max 2500.0

./pattern8  -min 0.0 -max 2.5
./pattern8  -min 0.0 -max 25.0
./pattern8  -min 0.0 -max 250.0
./pattern8  -min 0.0 -max 500.0
./pattern8  -min 0.0 -max 2500.0



