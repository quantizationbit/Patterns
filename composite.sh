set -x

make
convert /data2/8K_from_fotokem_041118_PQ_P3D65/WB_8k_test/8k_178_cc06/8k_178_cc06.00095054.tif \
  -resize 2880x1620 75pct.tiff
  
$EDRHOME/Tools/pattern/pattern8 -min 0.5  -max 0.5
$EDRHOME/Tools/pattern/pattern8 -min 0.1  -max 0.1
$EDRHOME/Tools/pattern/pattern8 -min 0.05 -max 0.05
$EDRHOME/Tools/pattern/pattern8 -min 0.02 -max 0.02

BASE="ANSI5x5_0.500__0.500_r_1.000_g_1.000_b_1.000"
convert $BASE".tiff" -depth 16 -resize 3840x2160 $BASE"_4K.tiff"
convert $BASE"_4K.tiff" 75pct.tiff -depth 16 -gravity center -composite -depth 16 $BASE"_COMPOSITE.tiff"

BASE="ANSI5x5_0.100__0.100_r_1.000_g_1.000_b_1.000"
convert $BASE".tiff" -depth 16 -resize 3840x2160 $BASE"_4K.tiff"
convert $BASE"_4K.tiff" 75pct.tiff -depth 16 -gravity center -composite -depth 16 $BASE"_COMPOSITE.tiff"


BASE="ANSI5x5_0.050__0.050_r_1.000_g_1.000_b_1.000"
convert $BASE".tiff" -depth 16 -resize 3840x2160 $BASE"_4K.tiff"
convert $BASE"_4K.tiff" 75pct.tiff -depth 16 -gravity center -composite -depth 16 $BASE"_COMPOSITE.tiff"


BASE="ANSI5x5_0.020__0.020_r_1.000_g_1.000_b_1.000"
convert $BASE".tiff" -depth 16 -resize 3840x2160 $BASE"_4K.tiff"
convert $BASE"_4K.tiff" 75pct.tiff -depth 16 -gravity center -composite -depth 16 $BASE"_COMPOSITE.tiff"

