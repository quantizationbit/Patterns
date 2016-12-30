set -x

FFMPEG=$EDRHOME/src/ffmpeg-build-script/workspace/bin/ffmpeg
#FFMPEG=/usr/bin/ffmpeg
X264=$EDRHOME/src/x264/x264

#$X264 --fullhelp
#exit

rm sid.264
$X264 --range tv --colorprim bt2020 --transfer smpte2084 --colormatrix bt2020nc --input-fmt yuv420p10le --input-depth 10 --input-res 3840x2160 --input-range tv --fps 23.976 --profile high10 --crf 0  -o sid.264 ./SID/SID.yuv

$FFMPEG -y -f lavfi -i aevalsrc=0:0:0:0:0:0::d=300  \
 -ar 48000 \
 -vn -ac 6 -acodec aac -cutoff 18000 -ab 768k \
  audio.aac
  

rm -fv sid.mp4
$FFMPEG -y \
  -i sid.264 \
  -i ./SID/audio.aac \
  -c copy "sid.mp4"
  
 wine $EDRHOME/youtube/hdr_metadata/windows/32bits/mkvmerge.exe \
      -o pattern.mkv\
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
      sid.mp4   

exit

