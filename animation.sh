set -x





mkdir animation
cd animation


#rm *tiff
#rm YDzDx.yuv

#frame = 0

#for num in `seq 0 1000`; do

 
 #numStr=`printf "%05d" $num`


#../pattern6 -frame $num -speed 3 -percent 20.0
#$EDRHOME/Tools/YUV/tif2yuv $numStr".tiff" 2020 HD1920 B10
##display -geometry 1280x720 $numStr".tiff" &
##sleep 0.5
##kill -9 %1
#rm -fv $numStr".tiff"



#done


FFMPEG=$EDRHOME/src/ffmpeg-build-script/workspace/bin/ffmpeg
#FFMPEG=/usr/bin/ffmpeg
X264=$EDRHOME/src/x264/x264

#$X264 --fullhelp
#exit

#rm ball.264
#$X264 --range tv --colorprim bt2020 --transfer smpte2084 --colormatrix bt2020nc --input-fmt yuv420p10le --input-depth 10 --input-res 1920x1080 --input-range tv --fps 23.976 --profile high10 --crf 0  -o ball.264 YDzDx.yuv

#$FFMPEG -y -f lavfi -i aevalsrc=0:0:0:0:0:0::d=300  \
 #-ar 48000 \
 #-vn -ac 6 -acodec aac -cutoff 18000 -ab 768k \
  #audio.aac
  

rm -fv ball.mp4
$FFMPEG -y \
  -i ball.264 \
  -i audio.aac \
  -c copy "ball.mp4"
  
 wine $EDRHOME/youtube/hdr_metadata/windows/32bits/mkvmerge.exe \
      -o ball.mkv\
      --colour-matrix 0:9 \
      --colour-range 0:1 \
      --colour-transfer-characteristics 0:16 \
      --colour-primaries 0:9 \
      --max-content-light 0:999 \
      --max-frame-light 0:399 \
      --max-luminance 0:1000 \
      --min-luminance 0:0.005 \
      --chromaticity-coordinates 0:0.68,0.32,0.265,0.690,0.15,0.06 \
      --white-colour-coordinates 0:0.3127,0.3290 \
      ball.mp4   



exit

mpv --loop 5 --osd-level=0 --demuxer=rawvideo --demuxer-rawvideo=w=1920:h=1080:fps=23.976:mp-format=yuv420p10le --colormatrix BT.709 --colormatrix-input-range=limited --colormatrix-output-range=full YDzDx.yuv
