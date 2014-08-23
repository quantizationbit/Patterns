#!/bin/bash

set -x

cd animation

# CTL Base
CTLBASE=$EDRHOME/ACES/CTL
# DPXEXR Tools (sigma_compare)
DPXEXR=$EDRHOME/Tools/demos/sc
count=30 # or 750


#
# decompile YUV file to PQ TIFF in 2020 RGB
# revert TIFF back to EXR
#
mkdir tifXYZ
rm -fv tifXYZ/*
rm -rfv 10b-DIR
$EDRHOME/Tools/YUV/yuv2tif C-10b.yuv B10 2020 HD1920 -f $count
mv tifXYZ 10b-DIR

mkdir tifXYZ
rm -fv tifXYZ/*
rm -rfv 12b-DIR
$EDRHOME/Tools/YUV/yuv2tif C-12b.yuv     2020 HD1920 -f $count
mv tifXYZ 12b-DIR

mkdir tifXYZ
rm -fv tifXYZ/*
rm -rfv 14b-DIR
$EDRHOME/Tools/YUV/yuv2tif C-14b.yuv B14 2020 HD1920 -f $count
mv tifXYZ 14b-DIR



#
# Decompile HEVC back to YUV and TIF
#
BASE=pattern6PQ2020-20
BITDEPTH=10
BD=B10
DEC=TAppDecoderStatic

rm -rfv tifXYZ
mkdir tifXYZ
rm -rfv $BASE-DIR
$EDRHOME/HEVC/HM/bin/$DEC -d $BITDEPTH -b $BASE.bin -o HEVC-$BASE.yuv
$EDRHOME/Tools/YUV/yuv2tif HEVC-$BASE.yuv $BD HD1920 2020 -f $count
mv tifXYZ $BASE-DIR


#
# Convert all tiff files from YUV and HEVC into EXR
#
c1=0
CMax=2

DIRS=(pattern6PQ2020-20-DIR 10b-DIR 12b-DIR 14b-DIR)
for DIR in ${DIRS[@]}
do
   
   for frame in $DIR/*tif
   do

	   if [ $c1 -le $CMax ]; then
   
	       ctlrender -force -ctl $CTLBASE/INVPQnk.ctl \
	         -ctl $CTLBASE/nullA.ctl \
	         $frame -format exr16 $frame.exr &
	         
			c1=$[$c1 +1]
		fi
		
		if [ $c1 = $CMax ]; then
			for job in `jobs -p`
			do
			echo $job
			wait $job 
			done
			c1=0
		fi         
   
   done
   
	for job in `jobs -p`
	do
	echo $job
	wait $job 
	done   


done


cd ..

exit







  
