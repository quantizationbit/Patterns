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
