set -x

make
rm -fv *STEP*tiff *STEP*jpg
#mkdir p9tiff p9jpg



#
# Notes:
# -maxC is nit level of surround
# -min/-max is nit level of ramp
# r/g/b is linear scale factor of nits (in linear, not PQ)
#

# Bright Red (with weak green)
./pattern9 -min 0.0 -max 10000.0 -maxC 1.0 -r 1.0 -g 0.1 -b 0.0
./pattern9 -min 0.0 -max 10000.0 -maxC 1.0 -r 1.0 -g 0.01 -b 0.0
./pattern9 -min 0.0 -max 10000.0 -maxC 1.0 -r 1.0 -g 0.001 -b 0.0

# Bright Blue (with weak green)
./pattern9 -min 0.0 -max 10000.0 -maxC 1.0 -r 0.0 -g 0.1 -b 1.0
./pattern9 -min 0.0 -max 10000.0 -maxC 1.0 -r 0.0 -g 0.01 -b 1.0
./pattern9 -min 0.0 -max 10000.0 -maxC 1.0 -r 0.0 -g 0.001 -b 1.0


# Bright Blue (with weak Red)
./pattern9 -min 0.0 -max 10000.0 -maxC 1.0 -r 0.1 -g 0.0 -b 1.0
./pattern9 -min 0.0 -max 10000.0 -maxC 1.0 -r 0.01 -g 0.0 -b 1.0
./pattern9 -min 0.0 -max 10000.0 -maxC 1.0 -r 0.001 -g 0.0 -b 1.0



# Bright Red (with weak green)
./pattern9 -min 0.0 -max 4000.0 -maxC 1.0 -r 1.0 -g 0.1 -b 0.0
./pattern9 -min 0.0 -max 4000.0 -maxC 1.0 -r 1.0 -g 0.01 -b 0.0
./pattern9 -min 0.0 -max 4000.0 -maxC 1.0 -r 1.0 -g 0.001 -b 0.0

# Bright Blue (with weak green)
./pattern9 -min 0.0 -max 4000.0 -maxC 1.0 -r 0.0 -g 0.1 -b 1.0
./pattern9 -min 0.0 -max 4000.0 -maxC 1.0 -r 0.0 -g 0.01 -b 1.0
./pattern9 -min 0.0 -max 4000.0 -maxC 1.0 -r 0.0 -g 0.001 -b 1.0


# Bright Blue (with weak Red)
./pattern9 -min 0.0 -max 4000.0 -maxC 1.0 -r 0.1 -g 0.0 -b 1.0
./pattern9 -min 0.0 -max 4000.0 -maxC 1.0 -r 0.01 -g 0.0 -b 1.0
./pattern9 -min 0.0 -max 4000.0 -maxC 1.0 -r 0.001 -g 0.0 -b 1.0



# Bright Red (with weak green)
./pattern9 -min 0.0 -max 1000.0 -maxC 1.0 -r 1.0 -g 0.1 -b 0.0
./pattern9 -min 0.0 -max 1000.0 -maxC 1.0 -r 1.0 -g 0.01 -b 0.0
./pattern9 -min 0.0 -max 1000.0 -maxC 1.0 -r 1.0 -g 0.001 -b 0.0

# Bright Blue (with weak green)
./pattern9 -min 0.0 -max 1000.0 -maxC 1.0 -r 0.0 -g 0.1 -b 1.0
./pattern9 -min 0.0 -max 1000.0 -maxC 1.0 -r 0.0 -g 0.01 -b 1.0
./pattern9 -min 0.0 -max 1000.0 -maxC 1.0 -r 0.0 -g 0.001 -b 1.0


# Bright Blue (with weak Red)
./pattern9 -min 0.0 -max 1000.0 -maxC 1.0 -r 0.1 -g 0.0 -b 1.0
./pattern9 -min 0.0 -max 1000.0 -maxC 1.0 -r 0.01 -g 0.0 -b 1.0
./pattern9 -min 0.0 -max 1000.0 -maxC 1.0 -r 0.001 -g 0.0 -b 1.0

