set -x





mkdir animation
cd animation


rm *tiff
rm YDzDx.yuv

frame = 0

for num in `seq 0 48`; do

 
 numStr=`printf "%05d" $num`


../pattern6 -frame $num -speed 3 -percent 25.0
$EDRHOME/Tools/tiff2ydzdx/tiff2ydzdx $numStr".tiff" 2020 HD1920 B10
rm -fv $numStr".tiff"



done

mpv --loop 5 --osd-level=0 --demuxer=rawvideo --demuxer-rawvideo=w=1920:h=1080:fps=23.976:mp-format=yuv420p10le --colormatrix BT.709 --colormatrix-input-range=limited --colormatrix-output-range=full YDzDx.yuv