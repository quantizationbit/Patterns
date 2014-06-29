set -x






cd animation
qp=12
yuv=YDzDx.yuv
$EDRHOME/HEVC/HM/bin/TAppEncoderHighBitDepthStatic -c $EDRHOME/HEVC/HM/cfg/encoder_randomaccess_main10.cfg -i $yuv -wdt 1920 -hgt 1080 -f 2134 -fr 24 --InputBitDepth=12 --InternalBitDepth=12 --InputChromaFormat=420 -vui 1 --VideoFullRange=0 --ColourDescriptionPresent=1 --ColourPrimaries=9 --TransferCharateristics=15 --MatrixCoefficients=9 --Profile=main-RExt --Tier=main --Level=4.1  -b str$qp.bin -o rec$qp.yuv -q $qp 2>&1 | tee logencoder_$qp  &

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

