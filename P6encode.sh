set -x


# animation/C-10b.yuv
# animation/C-12b.yuv
# animation/C-14b.yuv




cd animation

crf=20
x265 --input C-10b.yuv --input-depth 10 --input-res 1920x1080 --fps 23.976 --crf $crf --vbv-maxrate 40000 --vbv-bufsize 140000  -p medium -I 1 --psnr --sar 1 --range limited --colorprim bt2020 --transfer bt2020-10 --colormatrix bt2020nc --chromaloc 1 --no-lft  --repeat-headers  -o pattern6PQ2020-$crf.bin 2>&1 | tee log-$crf.txt


cd ..


exit


x265 --input C-10b.yuv --input-depth 10 --input-res 1920x1080 --fps 23.976 --crf $crf --vbv-maxrate 40000 --vbv-bufsize 140000  -p medium --bframes 12 -I 72 --psnr --sar 1 --range limited --colorprim bt2020 --transfer bt2020-10 --colormatrix bt2020nc --chromaloc 1 --no-lft  --repeat-headers  -o pattern6PQ2020-$crf.bin 2>&1 | tee log-$crf.txt

qp=12
BITDEPTH=14
yuv=animation/C-14b.yuv
$EDRHOME/HEVC/HM/bin/TAppEncoderHighBitDepthStatic -c $EDRHOME/HEVC/HM/cfg/encoder_randomaccess_main10.cfg -i $yuv -wdt 1920 -hgt 1080 -f 750 -fr 24 \
--InputBitDepth=$BITDEPTH --InternalBitDepth=12 --InputChromaFormat=420 -vui 1 --VideoFullRange=0 --ColourDescriptionPresent=1 --ColourPrimaries=9 --TransferCharateristics=15 --MatrixCoefficients=9 --Profile=main-RExt --Tier=main --Level=4.1  -b str$qp.bin -o rec$qp.yuv -q $qp 2>&1 | tee logencoder_$qp  &

($EDRHOME/HEVC/HM/bin/$ENC -c $EDRHOME/HEVC/HM/cfg/encoder_intra_main10.cfg -c SEI.cfg -i $YUVBASE$YUV".yuv" -wdt 1920 -hgt 1080 -f 4 -fr 24 --InputBitDepth=$BITDEPTH --InternalBitDepth=$BITDEPTH --InputChromaFormat=420 -vui 1 --VideoSignalTypePresent=1 --VideoFullRange=0 --ColourDescriptionPresent=1 --ColourPrimaries=9 --TransferCharacteristics=$TC --MatrixCoefficients=$MC --Profile=main-RExt --Tier=main --Level=4.1  \
--SEIMasteringDisplayColourVolume=1 --SEIMasteringDisplayMaxLuminance=$MAXstr"0000" \
--SEIMasteringDisplayMinLuminance=0 \
-b HM-$YUV.bin -o rec-$YUV.yuv -q $qp 2>&1 | tee logencoder-$YUV.log )

exit



crf=23
x265 --input YDzDx.yuv --input-depth 12 --input-res 1920x1080 --fps 23.976 --crf $crf --vbv-maxrate 40000 --vbv-bufsize 140000  -p medium --bframes 12 -I 72 --psnr --sar 1 --range limited --colorprim bt2020 --transfer bt2020-10 --colormatrix bt2020nc --chromaloc 1 --no-lft  --repeat-headers  -o pattern6PQ2020-$crf.bin 2>&1 | tee log-$crf.txt

crf=18
x265 --input YDzDx.yuv --input-depth 12 --input-res 1920x1080 --fps 23.976 --crf $crf --vbv-maxrate 40000 --vbv-bufsize 140000  -p medium --bframes 12 -I 72 --psnr --sar 1 --range limited --colorprim bt2020 --transfer bt2020-10 --colormatrix bt2020nc --chromaloc 1 --no-lft  --repeat-headers -o pattern6PQ2020-$crf.bin 2>&1 | tee log-$crf.txt

crf=30
x265 --input YDzDx.yuv --input-depth 12 --input-res 1920x1080 --fps 23.976 --crf $crf --vbv-maxrate 40000 --vbv-bufsize 140000  -p medium --bframes 12 -I 72 --psnr --sar 1 --range limited --colorprim bt2020 --transfer bt2020-10 --colormatrix bt2020nc --chromaloc 1 --no-lft  --repeat-headers -o pattern6PQ2020-$crf.bin 2>&1 | tee log-$crf.txt

crf=8
x265 --input YDzDx.yuv --input-depth 12 --input-res 1920x1080 --fps 23.976 --crf $crf --vbv-maxrate 40000 --vbv-bufsize 140000  -p medium --bframes 12 -I 72 --psnr --sar 1 --range limited --colorprim bt2020 --transfer bt2020-10 --colormatrix bt2020nc --chromaloc 1 --no-lft  --repeat-headers -o pattern6PQ2020-$crf.bin 2>&1 | tee log-$crf.txt




#mpv --loop 20 --osd-level=0  --colormatrix BT.709 --colormatrix-input-range=limited --colormatrix-output-range=full pattern6.bin

