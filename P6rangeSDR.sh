set -x





mkdir animationSDR
cd animationSDR


rm *tiff
rm YDzDx.yuv

c1=0
CMax=4

num=0
scale=0
frame = 0
rampPercent=90.0
# 0.5 * 0.01 = 0.005
# * 2000 = 1000 nits
scales=(0.2 0.4 0.8 1.6 3.2 6.4 12.8 25.6 51.2 102.4 204.8 409.6)

for scale in `seq 0 11`; do
for num in `seq 0 239`; do
 
 numStr=`printf "%05d" $num`

if [ $c1 -le $CMax ]; then

# Scaling input tiff which is 0.48828125 (as 32000 of 65535) to 0.5 then with scales list above
# will result in output ranges from 0.01 nits to about 8000 that way with the minor range around
# the test pattern will use most code values across entire 0.005-10k nit PQ range.
(../pattern6 -frame $num -speed 3 -percent $rampPercent; ctlrender -force -ctl $EDRHOME/ACES/CTL/scaleMultiply.ctl -global_param1 scale 1.024 -ctl $EDRHOME/ACES/CTL/scaleMultiply.ctl -global_param1 scale ${scales[$scale]} -ctl $EDRHOME/ACES/CTL/P3-2-ACES.ctl -ctl $EDRHOME/ACES/CTL/odt_rec2020_smpte_250nits.ctl $numStr".tiff" -format tiff16 $numStr"C.tiff"; rm -fv $numStr".tiff") &


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



for num in `seq 0 239`; do
 
numStr=`printf "%05d" $num`

$EDRHOME/Tools/tiff2ydzdx/tiff2ydzdx $numStr"C.tiff" 2020 HD1920
rm -fv $numStr"C.tiff"

# end appending yuv loop
done



# end scale sequence loop
done


#mpv --loop 1000 --osd-level=0 --demuxer=rawvideo --demuxer-rawvideo=w=1920:h=1080:fps=23.976:mp-format=yuv420p10le --colormatrix BT.709 --colormatrix-input-range=limited --colormatrix-output-range=full YDzDx.yuv