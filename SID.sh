#!/bin/bash
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
set -x

make

function YUVBuild {

for i in $(seq 1 120);
do
$EDRHOME/Tools/YUV/tif2yuv ANSI*.tiff B10 2020  -o SID.yuv
done
rm -fv ANSI*.tiff
}

function ENCODE {
YUVBASE="SID"

# Encode
crf=12

(x265 --input SID.yuv \
   --input-depth 10 --input-res 3840x2160 --fps 23.976 \
   --profile main10 --level-idc 51 --no-high-tier \
   --crf $crf --aq-mode 3  \
    -p slow  --bframes 12 -I 72 --sar 1 --range limited \
   --colorprim bt2020 --transfer 16 --colormatrix bt2020nc --chromaloc 2 \
   --master-display "G(13250,34500)B(7500,3000)R(34000,16000)WP(15635,16450)L(10000000,50)" \
   --max-cll "999,399" \
   --repeat-headers  \
   -o x265-$YUVBASE-$crf.bin ) 2>&1 | tee logencoder-x265-$YUVBASE-$crf.txt

ffmpeg -y -f lavfi -i aevalsrc=0:0:0:0:0:0::d=300  \
 -ar 48000 \
 -vn -ac 6 -acodec libfdk_aac -cutoff 18000 -ab 768k \
  audio.aac

MP4Box -v -add x265-$YUVBASE-$crf".bin#0:FMT=HEVC:fps=23.98"   -add "audio.aac:lang=en" -hint -rap  -new x265-$YUVBASE-$crf"-24Hz-cloc2.mp4"
}	


#main


rm -rfv SID
mkdir SID
cd SID
rm -fv SID.yuv

../pattern8  -min 0.0 -max 0.0  -2020; YUVBuild
convert ANSI*.tiff -gravity Center  -pointsize 300 -fill 'rgb(25,0,0)' -annotate 0 'ANSI 0,0\n(no corner)' ANSI.tiff
../pattern8  -min 0.000 -max 0.01 -2020; YUVBuild
../pattern8  -min 0.000 -max 0.02 -2020; YUVBuild
../pattern8  -min 0.000 -max 0.05 -2020; YUVBuild
../pattern8  -min 0.000 -max 0.1  -2020; YUVBuild

../pattern8  -min 0.0 -max 0.0  -2020; YUVBuild
convert ANSI*.tiff -gravity Center  -pointsize 300 -fill 'rgb(25,0,0)' -annotate 0 'ANSI 0.005,[0.01, 0.02, 0.05, 0.1]\n(no corner)' ANSI.tiff
../pattern8  -min 0.005 -max 0.01 -2020; YUVBuild
../pattern8  -min 0.005 -max 0.02 -2020; YUVBuild
../pattern8  -min 0.005 -max 0.05 -2020; YUVBuild
../pattern8  -min 0.005 -max 0.1  -2020; YUVBuild

../pattern8  -min 0.0 -max 0.0  -2020; YUVBuild
convert ANSI*.tiff -gravity Center  -pointsize 300 -fill 'rgb(25,0,0)' -annotate 0 'ANSI 0.005,[0.01, 0.02, 0.05, 0.1]\n2.5% Corners @ 1.0 cd/m2' ANSI.tiff
../pattern8  -min 0.005 -max 0.01 -maxC  1.0 -corner -2020; YUVBuild
../pattern8  -min 0.005 -max 0.02 -maxC  1.0 -corner -2020; YUVBuild
../pattern8  -min 0.005 -max 0.05 -maxC  1.0 -corner -2020; YUVBuild
../pattern8  -min 0.005 -max 0.1  -maxC  1.0 -corner -2020; YUVBuild

../pattern8  -min 0.0 -max 0.0  -2020; YUVBuild
convert ANSI*.tiff -gravity Center  -pointsize 300 -fill 'rgb(25,0,0)' -annotate 0 'ANSI 0.005,[0.01, 0.02, 0.05, 0.1]\n2.5% Corners @ 5.0 cd/m2' ANSI.tiff
../pattern8  -min 0.005 -max 0.01 -maxC  5.0 -corner -2020; YUVBuild
../pattern8  -min 0.005 -max 0.02 -maxC  5.0 -corner -2020; YUVBuild
../pattern8  -min 0.005 -max 0.05 -maxC  5.0 -corner -2020; YUVBuild
../pattern8  -min 0.005 -max 0.1  -maxC  5.0 -corner -2020; YUVBuild

../pattern8  -min 0.0 -max 0.0  -2020; YUVBuild
convert ANSI*.tiff -gravity Center  -pointsize 300 -fill 'rgb(25,0,0)' -annotate 0 'ANSI (0.05,0.5), (0.1,0.5), (0.1,1.0)\n2.5% Corners @ 5.0 cd/m2' ANSI.tiff
../pattern8  -min 0.05 -max 0.5 -maxC  5.0 -corner -2020; YUVBuild
../pattern8  -min 0.1  -max 0.5 -maxC  5.0 -corner -2020; YUVBuild
../pattern8  -min 0.1  -max 1.0 -maxC  5.0 -corner -2020; YUVBuild


../pattern8  -min 0.0 -max 0.0  -2020; YUVBuild
convert ANSI*.tiff -gravity Center  -pointsize 300 -fill 'rgb(25,0,0)' -annotate 0 'ANSI (0.05,0.5), (0.1,0.5), (0.1,1.0)\n2.5% Corners @ 25.0 cd/m2' ANSI.tiff
../pattern8  -min 0.05 -max 0.5 -maxC  25.0 -corner -2020; YUVBuild
../pattern8  -min 0.1  -max 0.5 -maxC  25.0 -corner -2020; YUVBuild
../pattern8  -min 0.1  -max 1.0 -maxC  25.0 -corner -2020; YUVBuild

../pattern8  -min 0.0 -max 0.0  -2020; YUVBuild
convert ANSI*.tiff -gravity Center  -pointsize 300 -fill 'rgb(25,0,0)' -annotate 0 'ANSI (0.05,0.5), (0.1,0.5), (0.1,1.0)\n2.5% Corners @ 250.0 cd/m2' ANSI.tiff
../pattern8  -min 0.05 -max 0.5 -maxC  250.0 -corner -2020; YUVBuild
../pattern8  -min 0.1  -max 0.5 -maxC  250.0 -corner -2020; YUVBuild
../pattern8  -min 0.1  -max 1.0 -maxC  250.0 -corner -2020; YUVBuild

../pattern8  -min 0.0 -max 0.0  -2020; YUVBuild
convert ANSI*.tiff -gravity Center  -pointsize 300 -fill 'rgb(25,0,0)' -annotate 0 'ANSI (0.05,0.5), (0.1,0.5), (0.1,1.0)\n2.5% Corners @ 400.0 cd/m2' ANSI.tiff
../pattern8  -min 0.05 -max 0.5 -maxC  400.0 -corner -2020; YUVBuild
../pattern8  -min 0.1  -max 0.5 -maxC  400.0 -corner -2020; YUVBuild
../pattern8  -min 0.1  -max 1.0 -maxC  400.0 -corner -2020; YUVBuild
../pattern8  -min 0.0 -max 0.0  -2020; YUVBuild

ENCODE

cd ..
ls -lt SID

exit



../pattern8 -idx 100  -min 0.005 -max 0.5 -maxC  1000.0 -center  -2020 &
../pattern8 -idx 101  -min 0.005 -max 0.5 -maxC  1000.0 -corner  -2020 &
../pattern8 -idx 102  -min 0.005 -max 0.5 -maxC  1000.0   -2020 &
../pattern8 -idx 103  -min 0.005 -max 0.5 -maxC  1000.0  -flip -2020 

../pattern8 -idx 200  -min 0.005 -max 0.5 -maxC  540.0 -center  -2020 &
../pattern8 -idx 201  -min 0.005 -max 0.5 -maxC  540.0 -corner  -2020 &
../pattern8 -idx 202  -min 0.005 -max 0.5 -maxC  540.0   -2020 &
../pattern8 -idx 203  -min 0.005 -max 0.5 -maxC  540.0  -flip -2020 

../pattern8 -idx 300  -min 0.005 -max 0.5 -maxC  4000.0 -center  -2020 &
../pattern8 -idx 301  -min 0.005 -max 0.5 -maxC  4000.0 -corner  -2020 &
../pattern8 -idx 302  -min 0.005 -max 0.5 -maxC  4000.0   -2020 &
../pattern8 -idx 303  -min 0.005 -max 0.5 -maxC  4000.0  -flip -2020 


# Color Volume Patterns

../pattern8 -idx 1000  -min 250.0 -max 500.0 -maxC  1000.0 -r 1.0 -g 0.0 -b 0.005 -center  -2020 &
../pattern8 -idx 1001  -min 250.0 -max 500.0 -maxC  1000.0 -r 0.005 -g 0.0 -b 1.0 -center  -2020 &
../pattern8 -idx 1002  -min 250.0 -max 500.0 -maxC  1000.0 -r 0.0 -g 1.0 -b 0.005 -center  -2020 &
../pattern8 -idx 1003  -min 250.0 -max 500.0 -maxC  1000.0 -r 0.005 -g 1.0 -b 0.0 -center  -2020 &

../pattern8 -idx 2000  -min 150.0 -max 300.0 -maxC  540.0 -r 1.0 -g 0.0 -b 0.005 -center  -2020 &
../pattern8 -idx 2001  -min 150.0 -max 300.0 -maxC  540.0 -r 0.005 -g 0.0 -b 1.0 -center  -2020 &
../pattern8 -idx 2002  -min 150.0 -max 300.0 -maxC  540.0 -r 0.0 -g 1.0 -b 0.005 -center  -2020 &
../pattern8 -idx 2003  -min 150.0 -max 300.0 -maxC  540.0 -r 0.005 -g 1.0 -b 0.0 -center  -2020 &

../pattern8 -idx 3000  -min 250.0 -max 1000.0 -maxC  4000.0 -r 1.0 -g 0.0 -b 0.005 -center  -2020 &
../pattern8 -idx 3001  -min 250.0 -max 1000.0 -maxC  4000.0 -r 0.005 -g 0.0 -b 1.0 -center  -2020 &
../pattern8 -idx 3002  -min 250.0 -max 1000.0 -maxC  4000.0 -r 0.0 -g 1.0 -b 0.005 -center  -2020 &
../pattern8 -idx 3003  -min 250.0 -max 1000.0 -maxC  4000.0 -r 0.005 -g 1.0 -b 0.0 -center  -2020 


# make sure all jobs finished
for job in `jobs -p`
do
echo $job
wait $job 
done
