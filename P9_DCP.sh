#!/bin/bash


function Ramp {
rm STEPS_*tiff
./pattern9 -min 0.0 -max 1000.0 -maxC 1.0 $color -bands 40 -4K
mv STEPS_*tiff tmp.tiff
convert tmp.tiff -depth 16 -pointsize 25 -fill 'rgb(150,150,0)'\
   -draw "text 128,2130 '0.'"  \
   -draw "text 225,2130 '25.'"  \
   -draw "text 322,2130 '50.'"  \
   -draw "text 420,2130 '75.'"  \
   -draw "text 518,2130 '100.'" \
   -draw "text 615,2130 '125.'" \
   -draw "text 713,2130 '150.'" \
   -draw "text 810,2130 '175.'" \
   -draw "text 908,2130 '200.'" \
   -draw "text 1006,2130 '225.'" \
   -draw "text 1104,2130 '250.'" \
   -draw "text 1202,2130 '275.'" \
   -draw "text 1305,2130 '300.'" \
   -draw "text 1403,2130 '325.'" \
   -draw "text 1501,2130 '350.'" \
   -draw "text 1599,2130 '375.'" \
   -draw "text 1697,2130 '400.'" \
   -draw "text 1795,2130 '425.'" \
   -draw "text 1893,2130 '450.'" \
   -draw "text 1990,2130 '475.'" \
   -draw "text 2088,2130 '500.'" \
   -draw "text 2186,2130 '525.'" \
   -draw "text 2284,2130 '550.'" \
   -draw "text 2382,2130 '575.'" \
   -draw "text 2474,2130 '600.'" \
   -draw "text 2572,2130 '625.'" \
   -draw "text 2670,2130 '650.'" \
   -draw "text 2767,2130 '675.'" \
   -draw "text 2864,2130 '700.'" \
   -draw "text 2962,2130 '725.'" \
   -draw "text 3060,2130 '750.'" \
   -draw "text 3157,2130 '775.'" \
   -draw "text 3245,2130 '800.'" \
   -draw "text 3343,2130 '825.'" \
   -draw "text 3441,2130 '850.'" \
   -draw "text 3538,2130 '875.'" \
   -draw "text 3636,2130 '900.'" \
   -draw "text 3733,2130 '925.'" \
   -draw "text 3830,2130 '975.'" \
   -draw "text 3927,2130 '1000.'" \
ramp.tiff


# Convert to X'Y'Z' PQ
ctlrender -force -verbose \
    -ctl $EDRHOME/ACES/CTLa1/PQ2Linear.ctl -param1 aIn 1.0 \
    -ctl $EDRHOME/ACES/CTLa1/P3D65-2-XYZ.ctl \
    -ctl $EDRHOME/ACES/CTLa1/Linear2PQ.ctl \
    -ctl $EDRHOME/ACES/CTLs/null.ctl \
ramp.tiff -format tiff16 XYZPQ.tiff
}


#Main
set -x
make
rm -rfv ramp RampP3
mkdir ramp RampP3


color="-r 1.0 -g 1.0 -b 1.0"
Ramp
mv -fv XYZPQ.tiff ramp/0000.tiff
mv -fv ramp.tiff RampP3/0000.tiff

color="-r 1.0 -g 0.0 -b 0.0"
Ramp
mv -fv XYZPQ.tiff ramp/0001.tiff
mv -fv ramp.tiff RampP3/0001.tiff


color="-r 0.0 -g 1.0 -b 0.0"
Ramp
mv -fv XYZPQ.tiff ramp/0002.tiff
mv -fv ramp.tiff RampP3/0002.tiff

color="-r 0.0 -g 0.0 -b 1.0"
Ramp
mv -fv XYZPQ.tiff ramp/0003.tiff
mv -fv ramp.tiff RampP3/0003.tiff

color="-r 0.0 -g 1.0 -b 1.0"
Ramp
mv -fv XYZPQ.tiff ramp/0004.tiff
mv -fv ramp.tiff RampP3/0004.tiff

color="-r 1.0 -g 0.0 -b 1.0"
Ramp
mv -fv XYZPQ.tiff ramp/0005.tiff
mv -fv ramp.tiff RampP3/0005.tiff

color="-r 1.0 -g 1.0 -b 0.0"
Ramp
mv -fv XYZPQ.tiff ramp/0006.tiff
mv -fv ramp.tiff RampP3/0006.tiff




rm -rfv j2k DCP
mkdir j2k DCP
cd DCP

opendcp_j2k -i ../ramp -b 250 -x -p cinema4k -f -t 8 -m ../tmp -o ../j2k


opendcp_mxf -i ../j2k -p 15 -o Ramp.mxf

	
opendcp_xml \
    --reel Ramp.mxf \
    --reel Ramp.mxf \
    --reel Ramp.mxf \
    --reel Ramp.mxf \
    --reel Ramp.mxf \
--digest PQRamp4K --kind test -t "4K PQ Ramp"

cd ..

rm -rfv PQRampDCP RampXYZ
mv DCP PQRampDCP
mv ramp RampXYZ

rm -fv PQRampDCP.zip RampXYZ.zip RampP3.zip

zip -r PQRampDCP.zip PQRampDCP
zip -r RampXYZ.zip RampXYZ
zip -r RampP3.zip RampP3

   

exit

