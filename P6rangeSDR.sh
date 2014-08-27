set -x

mkdir animationSDR
cd animationSDR

c1=0
CMax=4

num=0
scale=0
frame=0
frameStr=0
rampPercent=25.0


scales=(0.005 0.01 0.025 0.05 0.1 0.2 0.4 0.6 0.8 \
        1.0 2.0 4.0 8.0 16.0 32.0 64.0 100.0 150.0 200.0 400.0 600.0 \
        800.0 1000.0 2000.0 3000.0 4000.0 5000.0 8000.0 9000.0 10000.0 )

for scale in `seq 0 29`; do
for num in `seq 0 1`; do
 
 #numStr=`printf "%05d" $num`
 frameStr=`printf "%05d" $frame`

if [ $c1 -le $CMax ]; then

# Scaling input tiff which is 0.48828125 (as 32000 of 65535) to 1.0 then with scales list above
# will result in output ranges from 0.005 nits to about 10000 that way with the minor range around
# the test pattern will use most code values across entire 0.005-10k nit PQ range.
(../pattern6 -frame $frame -speed 3 -percent $rampPercent; \
  ctlrender -force -ctl $EDRHOME/ACES/CTL/scaleMultiply.ctl -param1 scale 2.048 \
  -ctl $EDRHOME/ACES/CTL/scaleMultiply.ctl -param1 scale ${scales[$scale]} \
  -ctl $EDRHOME/ACES/CTL/P3-2-2020.ctl \
  -ctl $EDRHOME/ACES/CTL/odt_rec709_smpte_MAX.ctl -param1 MAX 1000 \
   $frameStr".tiff" -format tiff16 $frameStr"X.tiff"; \
   rm -fv $frameStr".tiff") &


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


done   # end num frames loop

done   # end scale sequence loop



for job in `jobs -p`
do
echo $job
wait $job 
done
c1=0


# Create 709 YUV
rm -rf 709.yuv
frame=0
for scale in `seq 0 29`; do
for num in `seq 0 1`; do
 
 #numStr=`printf "%05d" $num`
 frameStr=`printf "%05d" $frame`

$EDRHOME/Tools/YUV/tif2yuv $frameStr"X.tiff" B10 709 HD1920 -o 709.yuv
rm -fv $frameStr"X.tiff"

frame=`expr $frame + 1`

done   # end num frames loop
done   # end scale sequence loop



ffmpeg -y -s 1920x1080 -r 2.0  -pix_fmt yuv420p10le -f rawvideo -i 709.yuv  -an -c:v libx264 -preset slow -crf 18 -profile:v high10 -level 4.1 709.mp4

#mpv --loop 1000 --osd-level=0 --demuxer=rawvideo --demuxer-rawvideo=w=1920:h=1080:fps=23.976:mp-format=yuv420p10le --colormatrix BT.709 --colormatrix-input-range=limited --colormatrix-output-range=full YDzDx.yuv
