set +x





W="3840"
H="2160"
DURATION="2"
FPS="23.976"


if [[ `uname` == *CYGWIN* ]]; then
	FFMPEG=$EDRHOME/ffmpeg/bin/ffmpeg
	X265=x265
fi

if [[ `uname` == *Linux* ]]; then
	FFMPEG=$EDRHOME/src/ffmpeg/ffmpeg
	X265=x265
fi

CRF=12
SPEED=fast

function ENCODE_HDR {


$FFMPEG -y -loglevel quiet -loop 1 -framerate $FPS -t $DURATION -i $SOURCE.tiff -an -sn \
  -vf scale=out_color_matrix=bt2020:out_h_chr_pos=0:out_v_chr_pos=0,format=yuv420p10le \
  -f rawvideo -vcodec rawvideo - | $X265 --input - \
   --input-depth 10 --input-res $W"x"$H --fps $FPS \
   --profile main10 --level-idc 51 --no-high-tier --crf $CRF \
   -p $SPEED \
   --hdr-opt --cbqpoffs -6 --crqpoffs -6 \
   --aq-mode 3 --aq-strength 2.0 \
   --bframes 12 --sar 1 \
   --aud --keyint 72 --range limited --no-open-gop --repeat-headers\
   --colorprim bt2020 --transfer 16 --colormatrix bt2020nc --chromaloc 2 \
   --master-display "G(13250,34500)B(7500,3000)R(34000,16000)WP(15635,16450)L(7500000,0)" \
   --max-cll "750,100" \
   -o $SOURCE"_static.bin" 2>&1 | tee $SOURCE"_logencoder_static.txt"

MUX

}

#   -color_primaries bt2020 -colorspace bt2020_ncl -color_trc smpte2084 \
#  -pix_fmt yuv420p10le  \





function MUX {
    
$FFMPEG -y -loglevel quiet -f lavfi -i aevalsrc="0|0:d=$DURATION"  \
 -ar 48000 \
 -vn -ac 2 -acodec aac -cutoff 18000 -ab 96k \
 audio.aac     


# alternate muxing possibility
#MP4Box -v -add "encode/StEM.bin"#0:FMT=HEVC:fps="23.976" -add audio.aac:lang=en -new "encode/StEM.mp4"
#$EDRHOME/src/ffmpeg/ffmpeg-10bit -y -i output/Dunkirk8K_HDR10_Sample_static.mp4 -c:v copy -bsf hevc_mp4toannexb  Dunkirk8K_HDR10_Sample_static.h.265
MP4Box -v -add $SOURCE"_static.bin"#0:FMT=HEVC:fps="23.976" -add audio.aac:lang=en -new $SOURCE"_static.mp4"

}

function PROCESS {

 # file name w/extension e.g. 000111.tiff
 cFile="${filename##*/}"
 # remove extension
 cFile="${cFile%.tif}"
 # note cFile now does NOT have tiff extension!
 echo $filename
 echo $cFile
 
rm -fv input.txt

#10
NITS="10"
PATTERN

NITS="54"
PATTERN

NITS="77"
PATTERN

NITS="97"
PATTERN

NITS="121"
PATTERN

NITS="141"
PATTERN

NITS="176"
PATTERN

NITS="212"
PATTERN

NITS="240"
PATTERN






}

function PATTERN {
rm -fv 1000*tiff
./pattern8 -idx 1000 -min 0.0 -max $NITS -flip
convert 1000*".tiff" -depth 16 -pointsize 50 -fill 'rgb(100,100,0)'\
   -undercolor black -draw "text 60,65 '$NITS'"  \
   $NITS".tiff"
SOURCE=$NITS
ENCODE_HDR
echo "file " $SOURCE"_static.mp4" > input.txt
cat input.txt input.txt input.txt input.txt input.txt > tmp.txt; mv tmp.txt input.txt
$FFMPEG -y -f concat -i input.txt -codec copy $NITS".mp4"

echo "file " $NITS".mp4" >> input2.txt


}


#
# Main
#

#Build 10-240 Patterns
rm -fv input.txt input2.txt

PROCESS

$FFMPEG -y -f concat -i input2.txt -codec copy Source10-240_50p_10.mp4


if [[ `uname` == *CYGWIN* ]]; then
    Hdr10PlusGenerator  -i Source10-240_50p_10.mp4 --masteringpeak 1000 --targetpeak 400 Source10-240_50p.json
    Hdr10PlusInjector   -i Source10-240_50p_10.mp4 --hdrinfo Source10-240_50p.json Source10-240_50p.mp4
fi

if [[ `uname` == *Linux* ]]; then
    Hdr10PlusGenerator.sh -y -i Source10-240_50p_10.mp4 --masteringpeak 1000 --targetpeak 400 Source10-240_50p.json
    Hdr10PlusInjector.sh  -y -i Source10-240_50p_10.mp4 --hdrinfo Source10-240_50p.json Source10-240_50p.mp4
fi



exit

