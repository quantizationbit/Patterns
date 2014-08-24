#!/bin/bash

set -x

cd animation

# CTL Base
CTLBASE=$EDRHOME/ACES/CTL
# DPXEXR Tools (sigma_compare)
DPXEXR=$EDRHOME/Tools/demos/sc
count=60 # 30 # or 750


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

# X265 10 bit run
# x265-$YUVBASE-$crf.bin
BITDEPTH=10
YUVBASE=C-$BITDEPTH"b"
crf=24
BASE=x265-$YUVBASE-$crf
BD=B10
DEC=TAppDecoderStatic

rm -rfv tifXYZ
mkdir tifXYZ
rm -rfv HEVC-$BASE-DIR
$EDRHOME/HEVC/HM/bin/$DEC -d $BITDEPTH -b $BASE.bin -o HEVC-$BASE.yuv
$EDRHOME/Tools/YUV/yuv2tif HEVC-$BASE.yuv $BD HD1920 2020 -f $count
mv tifXYZ HEVC-$BASE-DIR
x265B10=HEVC-$BASE-DIR



# HM 10 bit
BITDEPTH=10
YUVBASE=C-$BITDEPTH"b"
BASE=HM-$YUVBASE
BD=B10
DEC=TAppDecoderStatic

rm -rfv tifXYZ
mkdir tifXYZ
rm -rfv HEVC-$BASE-DIR
$EDRHOME/HEVC/HM/bin/$DEC -d $BITDEPTH -b $BASE.bin -o HEVC-$BASE.yuv
$EDRHOME/Tools/YUV/yuv2tif HEVC-$BASE.yuv $BD HD1920 2020 -f $count
mv tifXYZ HEVC-$BASE-DIR
HM10=HEVC-$BASE-DIR


# HM 12 bit
BITDEPTH=12
YUVBASE=C-$BITDEPTH"b"
BASE=HM-$YUVBASE
BD=" "
DEC=TAppDecoderHighBitDepthStatic

rm -rfv tifXYZ
mkdir tifXYZ
rm -rfv HEVC-$BASE-DIR
$EDRHOME/HEVC/HM/bin/$DEC -d $BITDEPTH -b $BASE.bin -o HEVC-$BASE.yuv
$EDRHOME/Tools/YUV/yuv2tif HEVC-$BASE.yuv $BD HD1920 2020 -f $count
mv tifXYZ HEVC-$BASE-DIR
HM12=HEVC-$BASE-DIR


# HM 14 bit
BITDEPTH=14
YUVBASE=C-$BITDEPTH"b"
BASE=HM-$YUVBASE
BD="B"$BITDEPTH
DEC=TAppDecoderHighBitDepthStatic

rm -rfv tifXYZ
mkdir tifXYZ
rm -rfv HEVC-$BASE-DIR
$EDRHOME/HEVC/HM/bin/$DEC -d $BITDEPTH -b $BASE.bin -o HEVC-$BASE.yuv
$EDRHOME/Tools/YUV/yuv2tif HEVC-$BASE.yuv $BD HD1920 2020 -f $count
mv tifXYZ HEVC-$BASE-DIR
HM14=HEVC-$BASE-DIR



#
# Convert all tiff files from YUV and HEVC into EXR
#
c1=0
CMax=4

DIRS=(  10b-DIR 12b-DIR 14b-DIR  \
        $x265B10  $HM10  $HM12  $HM14)
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







  
