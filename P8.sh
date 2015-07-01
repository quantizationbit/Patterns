set -x

make
rm -fv *ANSI*tiff *ANSI*jpg
mkdir p8tiff p8jpg


#
# Hue Test Patterns
#
# RGBCMY
./pattern8 -min 0.1 -max 1.0 -maxC  800.0 -corner 
./pattern8 -min 0.1 -max 1.0 -maxC  800.0 -corner -r 1.0 -g 0.0 -b 0.0
./pattern8 -min 0.1 -max 1.0 -maxC  800.0 -corner -r 0.0 -g 1.0 -b 0.0
./pattern8 -min 0.1 -max 1.0 -maxC  800.0 -corner -r 0.0 -g 0.0 -b 1.0
./pattern8 -min 0.1 -max 1.0 -maxC  800.0 -corner -r 0.0 -g 1.0 -b 1.0
./pattern8 -min 0.1 -max 1.0 -maxC  800.0 -corner -r 1.0 -g 0.0 -b 1.0
./pattern8 -min 0.1 -max 1.0 -maxC  800.0 -corner -r 1.0 -g 1.0 -b 0.0

./pattern8 -min 0.1 -max 1.0 -maxC  800.0 -corner -r 1.0 -g 0.0 -b 0.0 -2020
./pattern8 -min 0.1 -max 1.0 -maxC  800.0 -corner -r 0.0 -g 1.0 -b 0.0 -2020
./pattern8 -min 0.1 -max 1.0 -maxC  800.0 -corner -r 0.0 -g 0.0 -b 1.0 -2020
./pattern8 -min 0.1 -max 1.0 -maxC  800.0 -corner -r 0.0 -g 1.0 -b 1.0 -2020
./pattern8 -min 0.1 -max 1.0 -maxC  800.0 -corner -r 1.0 -g 0.0 -b 1.0 -2020
./pattern8 -min 0.1 -max 1.0 -maxC  800.0 -corner -r 1.0 -g 1.0 -b 0.0 -2020


#
# Hue Test Patterns
#
# RGBCMY
./pattern8 -idx 200 -min 0.0 -max 0.0 -maxC  50.0 -center -r 1.0 -g 0.0 -b 0.0
./pattern8 -idx 201 -min 0.0 -max 0.0 -maxC 250.0 -center -r 1.0 -g 0.0 -b 0.0

./pattern8 -idx 202 -min 0.0 -max 0.0 -maxC  50.0 -center -r 0.0 -g 1.0 -b 0.0
./pattern8 -idx 203 -min 0.0 -max 0.0 -maxC 250.0 -center -r 0.0 -g 1.0 -b 0.0

./pattern8 -idx 204 -min 0.0 -max 0.0 -maxC  50.0 -center -r 0.0 -g 0.0 -b 1.0
./pattern8 -idx 205 -min 0.0 -max 0.0 -maxC 250.0 -center -r 0.0 -g 0.0 -b 1.0

./pattern8 -idx 206 -min 0.0 -max 0.0 -maxC  50.0 -center -r 0.0 -g 1.0 -b 1.0
./pattern8 -idx 207 -min 0.0 -max 0.0 -maxC 250.0 -center -r 0.0 -g 1.0 -b 1.0

./pattern8 -idx 208 -min 0.0 -max 0.0 -maxC  50.0 -center -r 1.0 -g 0.0 -b 1.0
./pattern8 -idx 209 -min 0.0 -max 0.0 -maxC 250.0 -center -r 1.0 -g 0.0 -b 1.0

./pattern8 -idx 210 -min 0.0 -max 0.0 -maxC  50.0 -center -r 1.0 -g 1.0 -b 0.0
./pattern8 -idx 211 -min 0.0 -max 0.0 -maxC 250.0 -center -r 1.0 -g 1.0 -b 0.0

#
# Hue Test Patterns
# Rec2020
# RGBCMY
./pattern8 -idx 300 -min 0.0 -max 0.0 -maxC  50.0 -center -r 1.0 -g 0.0 -b 0.0 -2020
./pattern8 -idx 301 -min 0.0 -max 0.0 -maxC 250.0 -center -r 1.0 -g 0.0 -b 0.0 -2020

./pattern8 -idx 302 -min 0.0 -max 0.0 -maxC  50.0 -center -r 0.0 -g 1.0 -b 0.0 -2020
./pattern8 -idx 303 -min 0.0 -max 0.0 -maxC 250.0 -center -r 0.0 -g 1.0 -b 0.0 -2020

./pattern8 -idx 304 -min 0.0 -max 0.0 -maxC  50.0 -center -r 0.0 -g 0.0 -b 1.0 -2020
./pattern8 -idx 305 -min 0.0 -max 0.0 -maxC 250.0 -center -r 0.0 -g 0.0 -b 1.0 -2020

./pattern8 -idx 306 -min 0.0 -max 0.0 -maxC  50.0 -center -r 0.0 -g 1.0 -b 1.0 -2020
./pattern8 -idx 307 -min 0.0 -max 0.0 -maxC 250.0 -center -r 0.0 -g 1.0 -b 1.0 -2020

./pattern8 -idx 308 -min 0.0 -max 0.0 -maxC  50.0 -center -r 1.0 -g 0.0 -b 1.0 -2020
./pattern8 -idx 309 -min 0.0 -max 0.0 -maxC 250.0 -center -r 1.0 -g 0.0 -b 1.0 -2020

./pattern8 -idx 310 -min 0.0 -max 0.0 -maxC  50.0 -center -r 1.0 -g 1.0 -b 0.0 -2020
./pattern8 -idx 311 -min 0.0 -max 0.0 -maxC 250.0 -center -r 1.0 -g 1.0 -b 0.0 -2020




#
# Specific patterns for a testing suite
#
./pattern8  -idx 0 -min 0.1 -max 1.0  -maxC 400.0 -center -flip
./pattern8  -idx 1 -min 0.1 -max 1.0  -maxC 400.0 -corner -flip
./pattern8  -idx 2 -min 0.1 -max 1.0  -maxC 400.0 -corner 
./pattern8  -idx 3 -min 0.0 -max 0.1  -maxC 400.0 -corner
./pattern8  -idx 4 -min 0.0 -max 0.1  


# cyan -r 0.0 -g 1.0 -b 1.0
./pattern8  -idx 5 -min 0.1 -max 1.0  -maxC 400.0 -center -flip -r 0.0 -g 1.0 -b 1.0
./pattern8  -idx 6 -min 0.1 -max 1.0  -maxC 400.0 -corner -flip -r 0.0 -g 1.0 -b 1.0
./pattern8  -idx 7 -min 0.1 -max 1.0  -maxC 400.0 -corner -r 0.0 -g 1.0 -b 1.0
./pattern8  -idx 8 -min 0.0 -max 0.1  -maxC 400.0 -corner -r 0.0 -g 1.0 -b 1.0
./pattern8  -idx 9 -min 0.0 -max 0.1  -r 0.0 -g 1.0 -b 1.0

# yellow -r 1.0 -g 1.0 -b 0.0
./pattern8  -idx 10 -min 0.1 -max 1.0  -maxC 400.0 -center -flip -r 1.0 -g 1.0 -b 0.0
./pattern8  -idx 11 -min 0.1 -max 1.0  -maxC 400.0 -corner -flip -r 1.0 -g 1.0 -b 0.0
./pattern8  -idx 12 -min 0.1 -max 1.0  -maxC 400.0 -corner -r 1.0 -g 1.0 -b 0.0
./pattern8  -idx 13 -min 0.0 -max 0.1  -maxC 400.0 -corner -r 1.0 -g 1.0 -b 0.0
./pattern8  -idx 14 -min 0.0 -max 0.1  -r 1.0 -g 1.0 -b 0.0

# magenta -r 1.0 -g 0.0 -b 1.0
./pattern8  -idx 15 -min 0.1 -max 1.0  -maxC 400.0 -center -flip -r 1.0 -g 0.0 -b 1.0
./pattern8  -idx 16 -min 0.1 -max 1.0  -maxC 400.0 -corner -flip -r 1.0 -g 0.0 -b 1.0
./pattern8  -idx 17 -min 0.1 -max 1.0  -maxC 400.0 -corner -r 1.0 -g 0.0 -b 1.0
./pattern8  -idx 18 -min 0.0 -max 0.1  -maxC 400.0 -corner -r 1.0 -g 0.0 -b 1.0
./pattern8  -idx 19 -min 0.0 -max 0.1  -r 1.0 -g 0.0 -b 1.0

# red -r 1.0 -g 0.0 -b 0.0
./pattern8  -idx 5 -min 0.1 -max 1.0  -maxC 400.0 -center -flip -r 1.0 -g 0.0 -b 0.0
./pattern8  -idx 6 -min 0.1 -max 1.0  -maxC 400.0 -corner -flip -r 1.0 -g 0.0 -b 0.0
./pattern8  -idx 7 -min 0.1 -max 1.0  -maxC 400.0 -corner -r 1.0 -g 0.0 -b 0.0
./pattern8  -idx 8 -min 0.0 -max 0.1  -maxC 400.0 -corner -r 1.0 -g 0.0 -b 0.0
./pattern8  -idx 9 -min 0.0 -max 0.1  -r 1.0 -g 0.0 -b 0.0

# green -r 0.0 -g 1.0 -b 0.0
./pattern8  -idx 10 -min 0.1 -max 1.0  -maxC 400.0 -center -flip -r 0.0 -g 1.0 -b 0.0
./pattern8  -idx 11 -min 0.1 -max 1.0  -maxC 400.0 -corner -flip -r 0.0 -g 1.0 -b 0.0
./pattern8  -idx 12 -min 0.1 -max 1.0  -maxC 400.0 -corner -r 0.0 -g 1.0 -b 0.0
./pattern8  -idx 13 -min 0.0 -max 0.1  -maxC 400.0 -corner -r 0.0 -g 1.0 -b 0.0
./pattern8  -idx 14 -min 0.0 -max 0.1  -r 1.0 -g 1.0 -b 0.0

# blue -r 0.0 -g 0.0 -b 1.0
./pattern8  -idx 15 -min 0.1 -max 1.0  -maxC 400.0 -center -flip -r 0.0 -g 0.0 -b 1.0
./pattern8  -idx 16 -min 0.1 -max 1.0  -maxC 400.0 -corner -flip -r 0.0 -g 0.0 -b 1.0
./pattern8  -idx 17 -min 0.1 -max 1.0  -maxC 400.0 -corner -r 0.0 -g 0.0 -b 1.0
./pattern8  -idx 18 -min 0.0 -max 0.1  -maxC 400.0 -corner -r 0.0 -g 0.0 -b 1.0
./pattern8  -idx 19 -min 0.0 -max 0.1  -r 0.0 -g 0.0 -b 1.0

./pattern8  -idx 100 -min 0.1 -max 1.0  -maxC 500.0 -center -flip
./pattern8  -idx 101 -min 0.1 -max 1.0  -maxC 500.0 -corner -flip
./pattern8  -idx 102 -min 0.1 -max 1.0  -maxC 500.0 -corner 
./pattern8  -idx 103 -min 0.0 -max 0.1  -maxC 500.0 -corner
./pattern8  -idx 104 -min 0.0 -max 0.1  

./pattern8  -idx 105 -min 0.1 -max 1.0  -maxC 800.0 -center -flip
./pattern8  -idx 106 -min 0.1 -max 1.0  -maxC 800.0 -corner -flip
./pattern8  -idx 107 -min 0.1 -max 1.0  -maxC 800.0 -corner 
./pattern8  -idx 108 -min 0.0 -max 0.1  -maxC 800.0 -corner
./pattern8  -idx 109 -min 0.0 -max 0.1 

./pattern8  -idx 110 -min 0.1 -max 1.0  -maxC 1000.0 -center -flip
./pattern8  -idx 111 -min 0.1 -max 1.0  -maxC 1000.0 -corner -flip
./pattern8  -idx 112 -min 0.1 -max 1.0  -maxC 1000.0 -corner 
./pattern8  -idx 113 -min 0.0 -max 0.1  -maxC 1000.0 -corner
./pattern8  -idx 114 -min 0.0 -max 0.1 

./pattern8  -idx 115 -min 0.1 -max 1.0  -maxC 10000.0 -center -flip
./pattern8  -idx 116 -min 0.1 -max 1.0  -maxC 10000.0 -corner -flip
./pattern8  -idx 117 -min 0.1 -max 1.0  -maxC 10000.0 -corner 
./pattern8  -idx 118 -min 0.0 -max 0.1  -maxC 10000.0 -corner
./pattern8  -idx 119 -min 0.0 -max 0.1 



#
# Variety of patterns
#

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

mv -fv *ANSI*tiff p8tiff
mv -fv *ANSI*jpg  p8jpg
