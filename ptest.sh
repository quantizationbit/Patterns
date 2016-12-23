make
./pattern2
display  Pattern.tif &
ctlrender -verbose -ctl $EDRHOME/ACES/CTL/PQ10k4k-709-8bit.ctl -force Pattern.tif -format tiff8 Pattern444-709-8bit.tiff
gimp  Pattern444-709-8bit.tiff