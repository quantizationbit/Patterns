set -x





mkdir animation
cd animation


#rm *tiff
#rm YDzDx.yuv

c1=0
CMax=4

num=0
scale=0
frame=0
frameStr=0
rampPercent=90.0

# 0.5 * 0.01 = 0.005
# * 2000 = 1000 nits
#scales=(0.01 0.02 0.04 0.08 0.16 0.32 0.64 1.28  )
scales=(0.01 0.02 0.04 0.08 0.16 0.32 0.64 1.28 2.56 5.12 10.24 20.48 40.96 81.92 163.84 327.68 645.36 1290.72 2581.44 5162.88 10325.76 20651.52 )

# goto test dir
cd ..
mkdir test
cd test
rm -fv *

# calculate frame 
 num=72
 frame=256
 numStr=`printf "%05d" $num`
 frameStr=`printf "%05d" $frame`
 scale=5
 
# ICES
../pattern6 -frame $num -speed 3 -percent $rampPercent; mv -fv $numStr".tiff" $frameStr".tiff"; ctlrender -force -ctl $EDRHOME/ACES/CTL/scaleMultiply.ctl -param1 scale 1.024 -ctl $EDRHOME/ACES/CTL/scaleMultiply.ctl -param1 scale ${scales[$scale]} -ctl $EDRHOME/ACES/CTL/P3-2-ACES.ctl -ctl $EDRHOME/ACES/CTL/ACES-2-XYZ.ctl -ctl $EDRHOME/ACES/CTL/nullA.ctl $frameStr".tiff" -format exr16 $frameStr"ICES.exr"; rm -fv $frameStr".tiff"; 


# OCES
../pattern6 -frame $num -speed 3 -percent $rampPercent; mv -fv $numStr".tiff" $frameStr".tiff"; ctlrender -force -ctl $EDRHOME/ACES/CTL/scaleMultiply.ctl -param1 scale 1.024 -ctl $EDRHOME/ACES/CTL/scaleMultiply.ctl -param1 scale ${scales[$scale]} -ctl $EDRHOME/ACES/CTL/P3-2-ACES.ctl -ctl $EDRHOME/ACES/transforms/ctl/rrt/rrt.ctl -param1 aIn 1.0 -ctl $EDRHOME/ACES/CTL/ACES-2-XYZ.ctl -ctl $EDRHOME/ACES/CTL/nullA.ctl $frameStr".tiff" -format exr16 $frameStr"OCES.exr"; rm -fv $frameStr".tiff"; 

$EDRHOME/Tools/demos/sc/sigma_compare_PQ $frameStr"ICES.exr" $frameStr"ICES.exr"

$EDRHOME/Tools/demos/sc/sigma_compare_PQ $frameStr"OCES.exr" $frameStr"OCES.exr"



exit



for scale in `seq 0 21`; do
for num in `seq 0 96`; do
 
 numStr=`printf "%05d" $num`
 frameStr=`printf "%05d" $frame`

if [ $c1 -le $CMax ]; then

# Scaling input tiff which is 0.48828125 (as 32000 of 65535) to 0.5 then with scales list above
# will result in output ranges from 0.01 nits to about 8000 that way with the minor range around
# the test pattern will use most code values across entire 0.005-10k nit PQ range.
(../pattern6 -frame $num -speed 3 -percent $rampPercent; mv -fv $numStr".tiff" $frameStr".tiff"; ctlrender -force -ctl $EDRHOME/ACES/CTL/scaleMultiply.ctl -global_param1 scale 1.024 -ctl $EDRHOME/ACES/CTL/scaleMultiply.ctl -global_param1 scale ${scales[$scale]} -ctl $EDRHOME/ACES/CTL/P3-2-ACES.ctl -ctl $EDRHOME/ACES/CTL/odt_PQ10k2020.ctl $frameStr".tiff" -format tiff16 $frameStr"C.tiff"; rm -fv $frameStr".tiff"; ctlrender -force -ctl $EDRHOME/ACES/CTL/INVPQ10k2020-2-XYZ.ctl -ctl $EDRHOME/ACES/CTL/nullA.ctl $frameStr"C.tiff" -format exr16 "XpYpZp"$frameStr".exr") &
#ctlrender -force -verbose -ctl $EDRHOME/ACES/CTL/scaleMultiply.ctl -global_param1 scale 10.0 -ctl $EDRHOME/ACES/CTL/P3-2-ACES.ctl -ctl $EDRHOME/ACES/CTL/odt_rec2020_smpte_250nits.ctl $numStr".tiff" -format tiff16 $numStr"C.tiff"
sleep 1.0

frame=`expr $frame + 1`

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

# end num frames loop
done
# end scale sequence loop
done


for filename in *tiff ; do


$EDRHOME/Tools/tiff2ydzdx/tiff2ydzdx $filename 2020 HD1920

# end appending yuv loop
done







#
# decompile YUV file to PQ TIFF in 2020 RGB
# revert TIFF back to EXR
#
mkdir tifXYZ
rm -fv tifXYZ/*
frameStr=`printf "%05d" $frame`
$EDRHOME/Tools/tiff2ydzdx/ydzdx2tiff YDzDx.yuv HD1920 2020 -f $frame
rm -rfv tifXYZPQ
mv tifXYZ tifXYZPQ
mkdir YUVPQRT
rm -fv YUVPQRT/*
mkdir SC-LOG
rm -fv SC-LOG/*
AF=1.0

#
# Compare input and outpu of YUV
#
for filename in tifXYZPQ/* ; do

 cFile="${filename##*/}"
 # remove extension
 cFile="${cFile%.tif}"

# process input RGB back to linear
# done in original sequence above as current dir and XpYpZp#####.exr

# process just YUV output step back to linear
ctlrender -force -ctl $EDRHOME/ACES/CTL/INVPQ10k2020-2-XYZ.ctl -ctl $EDRHOME/ACES/CTL/nullA.ctl  $filename  -format exr16 YUVPQRT/$cFile".exr" 


#$EDRHOME/Tools/tifcmp/tifcmp SRC/$cFile".tif"  $filename  -o 127 -g 1.0
#mv Compare.tif "SC-LOG/CompareSRCPQ-YUVPQRT"-$cFile".tif"



# compare input to YUV with Output
$EDRHOME/Tools/demos/sc/sigma_compare_linux $cFile".exr"   YUVPQRT/$cFile".exr" 0 0 $AF 2>&1 | tee SC-LOG/"log"$cFile".txt"


done

#
# Compare input and output of YUV as whole sequence
#
# back count off so get the actual last frame num to compare
frame=`expr $frame - 1`
$EDRHOME/Tools/demos/sc/sigma_compare_linux  XpYpZp%05d.exr    YUVPQRT/XpYpZp%05d.exr  0  $frame $AF  2>&1 | tee SC-LOG/log-multi.txt




#mpv --loop 1000 --osd-level=0 --demuxer=rawvideo --demuxer-rawvideo=w=1920:h=1080:fps=23.976:mp-format=yuv420p10le --colormatrix BT.709 --colormatrix-input-range=limited --colormatrix-output-range=full YDzDx.yuv
