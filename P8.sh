set -x

make
rm -fv *ANSI*tiff

# ANSI Full Range
./pattern8  -min 0.0 -max 10000.0

# Corner Box Full Range
./pattern8  -min 0.0 -max 0.0  -maxC 10000.0 -corner


# ANSI dim 0.01 with Corner 500
./pattern8  -min 0.0 -max 0.10  -maxC 500.0 -corner


# ANSI dim  0/0.1
./pattern8  -min 0.0 -max 0.10


# ANSI dim 0.0/1.0 with Corner 500
./pattern8  -min 0.0 -max 1.0 -maxC 500.0 -corner

# ANSI dim 0.1/1.0 with Corner 500
./pattern8  -min 0.1 -max 1.0 -maxC 500.0 -corner

# ANSI dim 0.1/1.0 with Corner 200
./pattern8  -min 0.1 -max 1.0  -maxC 200.0 -corner

#ANSI 500 to 0
./pattern8  -min 0.0  -max 500.0

# dim but on ANSI  0.1/1.0
./pattern8  -min 0.1  -max 1.0


# ANSI very dim 0.0/0.5
./pattern8  -min 0.0 -max 0.5

# ANSI very dim 0.0/0.05
./pattern8  -min 0.0 -max 0.05

# ANSI very dim 0.0/0.05 with Corner 200
./pattern8  -min 0.0 -max 0.05  -maxC 200.0 -corner



for pattern in *ANSI*tiff
do
convert $pattern -resize 960x540 -quality 90 ${pattern%tiff}jpg
#rm -fv $pattern
done


