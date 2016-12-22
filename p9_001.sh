set -x

make
rm -fv *STEP*tiff *STEP*jpg
#mkdir p9tiff p9jpg


./pattern9 -min 0.0 -max 4000.0 -maxC 0.0 -legal -r 0.0 -g 0.001 -b 1.0 &
./pattern9 -min 0.0 -max 4000.0 -maxC 0.0 -legal -r 0.001 -g 0.0 -b 1.0 &
./pattern9 -min 0.0 -max 4000.0 -maxC 0.0 -legal -r 1.0 -g 0.001 -b 0.0 &


./pattern9 -min 0.0 -max 1000.0 -maxC 0.0 -legal -r 0.0 -g 0.001 -b 1.0 &
./pattern9 -min 0.0 -max 1000.0 -maxC 0.0 -legal -r 0.001 -g 0.0 -b 1.0 &
./pattern9 -min 0.0 -max 1000.0 -maxC 0.0 -legal -r 1.0 -g 0.001 -b 0.0

