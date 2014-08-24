set -x


cd animation



BITDEPTH=10
YUVBASE=C-$BITDEPTH"b"
YUVFILE=$YUVBASE.yuv
crf=24 # qp actually
x265 --input $YUVFILE --input-depth 10 --input-res 1920x1080 --fps 23.976 --crf $crf --vbv-maxrate 40000 --vbv-bufsize 140000  -p medium -I 1 --psnr --sar 1 --range limited --colorprim bt2020 --transfer bt2020-10 --colormatrix bt2020nc --chromaloc 1 --no-lft  --repeat-headers  -o x265-$YUVBASE-$crf.bin 2>&1 | tee logencoder-x265-$YUVBASE-$crf.txt

TC=16  # 16 = PQ gamma 14 = 2020 10 bits 15 = 2020 12 bits
MC=9   #2020 NCL
qp=12
count=60  

BITDEPTH=10
YUVBASE=C-$BITDEPTH"b"
YUVFILE=$YUVBASE.yuv
tar cvfz $YUVFILE".tgz" $YUVFILE
ENC=$EDRHOME/HEVC/HM/bin/TAppEncoderStatic

$ENC -c $EDRHOME/HEVC/HM/cfg/encoder_intra_main10.cfg \
-i $YUVFILE -wdt 1920 -hgt 1080 -f $count -fr 24 \
--InputBitDepth=$BITDEPTH --InternalBitDepth=$BITDEPTH \
--InputChromaFormat=420 -vui 1 --VideoSignalTypePresent=1 \
--VideoFullRange=0 --ColourDescriptionPresent=1 \
--ColourPrimaries=9 --TransferCharacteristics=$TC \
--MatrixCoefficients=$MC --Profile=main-RExt --Tier=main --Level=4.1  \
--SEIMasteringDisplayColourVolume=1 --SEIMasteringDisplayMaxLuminance=$MAXstr"0000" \
--SEIMasteringDisplayMinLuminance=0 \
-b HM-$YUVBASE.bin -o rec-$YUVBASE.yuv -q $qp 2>&1 | tee logencoder-HM-$YUVBASE.log &



BITDEPTH=12
YUVBASE=C-$BITDEPTH"b"
YUVFILE=$YUVBASE.yuv
tar cvfz $YUVFILE".tgz" $YUVFILE
ENC=$EDRHOME/HEVC/HM/bin/TAppEncoderHighBitDepthStatic

$ENC -c $EDRHOME/HEVC/HM/cfg/encoder_intra_main10.cfg \
-i $YUVFILE -wdt 1920 -hgt 1080 -f $count -fr 24 \
--InputBitDepth=$BITDEPTH --InternalBitDepth=$BITDEPTH \
--InputChromaFormat=420 -vui 1 --VideoSignalTypePresent=1 \
--VideoFullRange=0 --ColourDescriptionPresent=1 \
--ColourPrimaries=9 --TransferCharacteristics=$TC \
--MatrixCoefficients=$MC --Profile=main-RExt --Tier=main --Level=4.1  \
--SEIMasteringDisplayColourVolume=1 --SEIMasteringDisplayMaxLuminance=$MAXstr"0000" \
--SEIMasteringDisplayMinLuminance=0 \
-b HM-$YUVBASE.bin -o rec-$YUVBASE.yuv -q $qp 2>&1 | tee logencoder-HM-$YUVBASE.log &


BITDEPTH=14
YUVBASE=C-$BITDEPTH"b"
YUVFILE=$YUVBASE.yuv
tar cvfz $YUVFILE".tgz" $YUVFILE
ENC=$EDRHOME/HEVC/HM/bin/TAppEncoderHighBitDepthStatic

$ENC -c $EDRHOME/HEVC/HM/cfg/encoder_intra_main10.cfg \
-i $YUVFILE -wdt 1920 -hgt 1080 -f $count -fr 24 \
--InputBitDepth=$BITDEPTH --InternalBitDepth=$BITDEPTH \
--InputChromaFormat=420 -vui 1 --VideoSignalTypePresent=1 \
--VideoFullRange=0 --ColourDescriptionPresent=1 \
--ColourPrimaries=9 --TransferCharacteristics=$TC \
--MatrixCoefficients=$MC --Profile=main-RExt --Tier=main --Level=4.1  \
--SEIMasteringDisplayColourVolume=1 --SEIMasteringDisplayMaxLuminance=$MAXstr"0000" \
--SEIMasteringDisplayMinLuminance=0 \
-b HM-$YUVBASE.bin -o rec-$YUVBASE.yuv -q $qp 2>&1 | tee logencoder-HM-$YUVBASE.log &



for job in `jobs -p`
do
echo $job
wait $job 
done 

cd ..


exit



