set -x

make
rm -fv *ANSI*tiff *ANSI*jpg
rm -rfv atiff ajpg amp4
mkdir atiff ajpg amp4



W="3840"
H="2160"
DURATION="5"
FPS="23.976"
#FFMPEG=$EDRHOME/ffmpeg/bin/ffmpeg
FFMPEG=$EDRHOME/src/ffmpeg/ffmpeg
X265=x265
CRF=12
SPEED=fast

function ENCODE_HDR {




$FFMPEG -y -loglevel quiet -loop 1  -i $SOURCE".tiff" -an -sn \
  -vf scale=out_color_matrix=bt2020:out_h_chr_pos=0:out_v_chr_pos=0,format=yuv420p10le \
  -f rawvideo -vcodec rawvideo -framerate $FPS -t $DURATION - | $X265 --input - \
   --input-depth 10 --input-res $W"x"$H --fps $FPS \
   --profile main10 --level-idc 51 --no-high-tier --crf $CRF \
   -p $SPEED --hdr-opt \
   --cbqpoffs -6 --crqpoffs -6 \
   --aq-mode 3 --aq-strength 2.0 \
   --bframes 12 --sar 1 \
   --aud --keyint 72 --range limited --no-open-gop --repeat-headers\
   --colorprim bt2020 --transfer 16 --colormatrix bt2020nc --chromaloc 2 \
   --master-display "G(13250,34500)B(7500,3000)R(34000,16000)WP(15635,16450)L(10000000,0)" \
   --max-cll "1000,100" \
   -o $SOURCE"_static.bin" 2>&1 | tee $SOURCE"_logencoder_static.txt"

MUX

}





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

function DTM() {
SOURCE=`ls $1*tiff`
SOURCE="${SOURCE%.tiff}"
ENCODE_HDR
echo $SOURCE
/data/HDR10+/script/CLISTMS/Hdr10PlusConvertor.sh -y -i $SOURCE"_static.mp4" --targetpeak 400 --masteringpeak 1000 $SOURCE".mp4"
rm -fv *_static.mp4 *_static.bin *_static*txt
mv $SOURCE".mp4" amp4/
}

#
# Main
#


#10%





./pattern8 -idx 1010 -min 0.005 -max 1.0 -maxC 10.051 -center
DTM 1010
./pattern8 -idx 1050 -min 0.005 -max 1.0 -maxC 50.825 -center
DTM 1050
./pattern8 -idx 1100 -min 0.005 -max 1.0 -maxC 100.230 -center
DTM 1100
./pattern8 -idx 1135 -min 0.005 -max 1.0 -maxC 135.158 -center
DTM 1135
./pattern8 -idx 1181 -min 0.005 -max 1.0 -maxC 181.318 -center
DTM 1181
./pattern8 -idx 1242 -min 0.005 -max 1.0 -maxC 242.201 -center
DTM 1242

./pattern8 -idx 2010 -min 1.5 -max 5.0 -maxC 10.051 -center
DTM 2010
./pattern8 -idx 2050 -min 1.5 -max 5.0 -maxC 50.825 -center
DTM 2050
./pattern8 -idx 2100 -min 1.5 -max 5.0 -maxC 100.230 -center
DTM 2100
./pattern8 -idx 2135 -min 1.5 -max 5.0 -maxC 135.158 -center
DTM 2135
./pattern8 -idx 2181 -min 1.5 -max 5.0 -maxC 181.318 -center
DTM 2181
./pattern8 -idx 2242 -min 1.5 -max 5.0 -maxC 242.201 -center
DTM 2242


for pattern in *ANSI*tiff
do
convert $pattern -resize 960x540 -quality 90 ${pattern%tiff}jpg
#rm -fv $pattern
done

mv -fv *ANSI*tiff atiff
mv -fv *ANSI*jpg  ajpg
