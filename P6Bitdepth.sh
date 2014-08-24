set -x


# CTL Base
CTLBASE=$EDRHOME/ACES/CTL
# DPXEXR Tools (sigma_compare)
DPXEXR=$EDRHOME/Tools/demos/sc


cd animation




c1=0
CMax=4

num=0
scale=0
frame=0
frameStr=0
rampPercent=10.0


scales=(0.005 0.01 0.025 0.05 0.1 0.2 0.4 0.6 0.8 \
        1.0 2.0 4.0 8.0 16.0 32.0 64.0 100.0 150.0 200.0 400.0 600.0 \
        800.0 1000.0 2000.0 3000.0 4000.0 5000.0 8000.0 9000.0 10000.0 )

rm -fv *.yuv

for scale in `seq 0 29`; do
for num in `seq 0 1`; do
 
 #numStr=`printf "%05d" $num`
 frameStr=`printf "%05d" $frame`

# exr: "XpYpZp"$frameStr".exr"
# tiff: $frameStr"C.tiff"

# Truncate TIFF to test values
$EDRHOME/Tools/tiftruncate/tiftruncate -d 10 -i $frameStr"C.tiff" -o $frameStr"C-10b.tiff"	
$EDRHOME/Tools/tiftruncate/tiftruncate -d 12 -i $frameStr"C.tiff" -o $frameStr"C-12b.tiff"	
$EDRHOME/Tools/tiftruncate/tiftruncate -d 14 -i $frameStr"C.tiff" -o $frameStr"C-14b.tiff"	
	
# create EXR
ctlrender -force -ctl $CTLBASE/INVPQnk.ctl \
   -ctl $CTLBASE/nullA.ctl \
  $frameStr"C-10b.tiff" -format exr16 "XpYpZp"$frameStr"-10b.exr" &	
  
ctlrender -force -ctl $CTLBASE/INVPQnk.ctl \
   -ctl $CTLBASE/nullA.ctl \
  $frameStr"C-12b.tiff" -format exr16 "XpYpZp"$frameStr"-12b.exr" &
  
ctlrender -force -ctl $CTLBASE/INVPQnk.ctl \
   -ctl $CTLBASE/nullA.ctl \
  $frameStr"C-14b.tiff" -format exr16 "XpYpZp"$frameStr"-14b.exr"  &  
  
for job in `jobs -p`
do
echo $job
wait $job 
done

  

# Create YUV
$EDRHOME/Tools/YUV/tif2yuv $frameStr"C-10b.tiff" B10 2020 HD1920 -o C-10b.yuv
$EDRHOME/Tools/YUV/tif2yuv $frameStr"C-12b.tiff"     2020 HD1920 -o C-12b.yuv
$EDRHOME/Tools/YUV/tif2yuv $frameStr"C-14b.tiff" B14 2020 HD1920 -o C-14b.yuv


frame=`expr $frame + 1`



done   # end num frames loop

done   # end scale sequence loop


cd ..


exit

