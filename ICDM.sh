set -x

make


function HLGTEST {

#### SETUP FOR ACES V1:  
CTL_MODULE_PATH="$EDRHOME/ACES/aces-dev/transforms/ctl/utilities:$EDRHOME/ACES/CTLa1"
####

# convert PQ to linear nits
# Set 1000 nits to 12.0 in HLG [0:12]
ctlrender -force -verbose \
    -ctl $EDRHOME/ACES/CTLa1/PQ2Linear.ctl \
         -param1 aIn 1.0 \
         -param1 CLIP $CLIP \
    -ctl $EDRHOME/ACES/CTLa1/scaleMultiplyRGB.ctl \
        -param1 scaleRED   $SCALE\
        -param1 scaleGREEN $SCALE\
        -param1 scaleBLUE  $SCALE\
        -param1 CLIP       1.0 \
    -ctl $EDRHOME/ACES/CTLa1/Linear2HLG_DW3.ctl \
         -param1 LRefDisplay $LREFDISPLAY\
         -param1 colorSpace 2 \
         -param1 DW3 $DW3 \
    $source \
    -format tiff16 "VolumeLimit"$source".tif"
 
    
}



rm -rfv ICDM
mkdir ICDM
cd ICDM

#
../pattern8 -idx 100  -min 0.005 -max 0.5 -maxC  1000.0 -center  -2020 &
../pattern8 -idx 101  -min 0.005 -max 0.5 -maxC  1000.0 -corner  -2020 &
../pattern8 -idx 102  -min 0.005 -max 0.5 -maxC  1000.0   -2020 &
../pattern8 -idx 103  -min 0.005 -max 0.5 -maxC  1000.0  -flip -2020 

../pattern8 -idx 200  -min 0.005 -max 0.5 -maxC  540.0 -center  -2020 &
../pattern8 -idx 201  -min 0.005 -max 0.5 -maxC  540.0 -corner  -2020 &
../pattern8 -idx 202  -min 0.005 -max 0.5 -maxC  540.0   -2020 &
../pattern8 -idx 203  -min 0.005 -max 0.5 -maxC  540.0  -flip -2020 

../pattern8 -idx 300  -min 0.005 -max 0.5 -maxC  4000.0 -center  -2020 &
../pattern8 -idx 301  -min 0.005 -max 0.5 -maxC  4000.0 -corner  -2020 &
../pattern8 -idx 302  -min 0.005 -max 0.5 -maxC  4000.0   -2020 &
../pattern8 -idx 303  -min 0.005 -max 0.5 -maxC  4000.0  -flip -2020 


# Color Volume Patterns

../pattern8 -idx 1000  -min 250.0 -max 500.0 -maxC  1000.0 -r 1.0 -g 0.0 -b 0.005 -center  -2020 &
../pattern8 -idx 1001  -min 250.0 -max 500.0 -maxC  1000.0 -r 0.005 -g 0.0 -b 1.0 -center  -2020 &
../pattern8 -idx 1002  -min 250.0 -max 500.0 -maxC  1000.0 -r 0.0 -g 1.0 -b 0.005 -center  -2020 &
../pattern8 -idx 1003  -min 250.0 -max 500.0 -maxC  1000.0 -r 0.005 -g 1.0 -b 0.0 -center  -2020 &

../pattern8 -idx 2000  -min 150.0 -max 300.0 -maxC  540.0 -r 1.0 -g 0.0 -b 0.005 -center  -2020 &
../pattern8 -idx 2001  -min 150.0 -max 300.0 -maxC  540.0 -r 0.005 -g 0.0 -b 1.0 -center  -2020 &
../pattern8 -idx 2002  -min 150.0 -max 300.0 -maxC  540.0 -r 0.0 -g 1.0 -b 0.005 -center  -2020 &
../pattern8 -idx 2003  -min 150.0 -max 300.0 -maxC  540.0 -r 0.005 -g 1.0 -b 0.0 -center  -2020 &

../pattern8 -idx 3000  -min 250.0 -max 1000.0 -maxC  4000.0 -r 1.0 -g 0.0 -b 0.005 -center  -2020 &
../pattern8 -idx 3001  -min 250.0 -max 1000.0 -maxC  4000.0 -r 0.005 -g 0.0 -b 1.0 -center  -2020 &
../pattern8 -idx 3002  -min 250.0 -max 1000.0 -maxC  4000.0 -r 0.0 -g 1.0 -b 0.005 -center  -2020 &
../pattern8 -idx 3003  -min 250.0 -max 1000.0 -maxC  4000.0 -r 0.005 -g 1.0 -b 0.0 -center  -2020 


# make sure all jobs finished
for job in `jobs -p`
do
echo $job
wait $job 
done



# HLG Conversion Testing
rm -rfv HLG
mkdir HLG




DW3="0"
CLIP="1000.0"
SCALE="0.001"
LREFDISPLAY=$CLIP




source="1001_ANSI5x5_250.000__500.000_CENTER_1000.000_r_0.005_g_0.000_b_1.000_2020.tiff"
HLGTEST
mv -fv "VolumeLimit"$source".tif" HLG/


cd ..




    
     
