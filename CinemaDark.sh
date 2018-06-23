set -x

rm -rfv FlareTest
mkdir FlareTest
cd FlareTest

../pattern8 -min 0.0005 -max 0.001 -maxC 0.02 -center
../pattern8 -min 0.0005 -max 0.002 -maxC 0.02 -center
../pattern8 -min 0.0005 -max 0.005 -maxC 0.02 -center
../pattern8 -min 0.0005 -max 0.01 -maxC 0.02 -center
../pattern8 -min 0.0005 -max 0.02 -maxC 0.02 -center
../pattern8 -min 0.0005 -max 0.02 -maxC 1.0  -corner
../pattern8 -min 0.001 -max 0.02 -maxC 1.0  -corner
../pattern8 -min 0.002 -max 0.02 -maxC 1.0  -corner
../pattern8 -min 0.005 -max 0.02 -maxC 1.0  -corner
../pattern8 -min 0.01 -max 0.02 -maxC 1.0  -corner
../pattern8 -min 0.01 -max 0.03 -maxC 1.0  -corner

../pattern8 -min 0.0005 -max 0.02 -maxC 10.0  -corner
../pattern8 -min 0.001 -max 0.02 -maxC 10.0  -corner
../pattern8 -min 0.002 -max 0.02 -maxC 10.0  -corner
../pattern8 -min 0.005 -max 0.02 -maxC 10.0  -corner
../pattern8 -min 0.01 -max 0.02 -maxC 10.0  -corner
../pattern8 -min 0.01 -max 0.03 -maxC 10.0  -corner

../pattern8 -min 0.0005 -max 0.02 -maxC 50.0  -corner
../pattern8 -min 0.001 -max 0.02 -maxC 50.0  -corner
../pattern8 -min 0.002 -max 0.02 -maxC 50.0  -corner
../pattern8 -min 0.005 -max 0.02 -maxC 50.0  -corner
../pattern8 -min 0.01 -max 0.02 -maxC 50.0  -corner
../pattern8 -min 0.01 -max 0.03 -maxC 50.0  -corner

../pattern8 -min 0.0005 -max 0.02 -maxC 100.0  -corner
../pattern8 -min 0.001 -max 0.02 -maxC 100.0  -corner
../pattern8 -min 0.002 -max 0.02 -maxC 100.0  -corner
../pattern8 -min 0.005 -max 0.02 -maxC 100.0  -corner
../pattern8 -min 0.01 -max 0.02 -maxC 100.0  -corner
../pattern8 -min 0.01 -max 0.03 -maxC 100.0  -corner


../pattern8 -min 0.0005 -max 0.02 -maxC 250.0  -corner
../pattern8 -min 0.001 -max 0.02 -maxC 250.0  -corner
../pattern8 -min 0.002 -max 0.02 -maxC 250.0  -corner
../pattern8 -min 0.005 -max 0.02 -maxC 250.0  -corner
../pattern8 -min 0.01 -max 0.02 -maxC 250.0  -corner
../pattern8 -min 0.01 -max 0.03 -maxC 250.0  -corner


../pattern8 -min 0.0005 -max 0.02 -maxC 500.0  -corner
../pattern8 -min 0.001 -max 0.02 -maxC 500.0  -corner
../pattern8 -min 0.002 -max 0.02 -maxC 500.0  -corner
../pattern8 -min 0.005 -max 0.02 -maxC 500.0  -corner
../pattern8 -min 0.01 -max 0.02 -maxC 500.0  -corner
../pattern8 -min 0.01 -max 0.03 -maxC 500.0  -corner


../pattern8 -min 0.5 -max 2.0 -maxC 10.0  -corner
../pattern8 -min 0.5 -max 2.0 -maxC 50.0  -corner
../pattern8 -min 0.5 -max 2.0 -maxC 100.0  -corner
../pattern8 -min 0.5 -max 2.0 -maxC 250.0  -corner
../pattern8 -min 0.5 -max 2.0 -maxC 500.0  -corner








ls -lt *.tiff

cd ..

