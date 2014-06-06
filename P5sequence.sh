set -x

cd sequence
../pattern5 -one 320

ctlrender -force -verbose -ctl $EDRHOME/ACES/CTL/scale.ctl -param1 scale 2.778 -ctl $EDRHOME/ACES/transforms/ctl/rrt/rrt.ctl -param1 aIn 1.0  -ctl $EDRHOME/ACES/CTL/odt_PQ10k.ctl Pattern5.tif -format tiff16 XYZ-1-1.tiff

ctlrender -force -verbose -ctl $EDRHOME/ACES/CTL/scale.ctl -param1 scale 27.78 -ctl $EDRHOME/ACES/transforms/ctl/rrt/rrt.ctl -param1 aIn 1.0  -ctl $EDRHOME/ACES/CTL/odt_PQ10k.ctl Pattern5.tif -format tiff16 XYZ-1-10.tiff

../pattern5 -one 1600

ctlrender -force -verbose -ctl $EDRHOME/ACES/CTL/scale.ctl -param1 scale 2.778 -ctl $EDRHOME/ACES/transforms/ctl/rrt/rrt.ctl -param1 aIn 1.0  -ctl $EDRHOME/ACES/CTL/odt_PQ10k.ctl Pattern5.tif -format tiff16 XYZ-5-1.tiff

ctlrender -force -verbose -ctl $EDRHOME/ACES/CTL/scale.ctl -param1 scale 27.78 -ctl $EDRHOME/ACES/transforms/ctl/rrt/rrt.ctl -param1 aIn 1.0  -ctl $EDRHOME/ACES/CTL/odt_PQ10k.ctl Pattern5.tif -format tiff16 XYZ-5-10.tiff

../pattern5 -one 640

ctlrender -force -verbose -ctl $EDRHOME/ACES/CTL/scale.ctl -param1 scale 2.778 -ctl $EDRHOME/ACES/transforms/ctl/rrt/rrt.ctl -param1 aIn 1.0  -ctl $EDRHOME/ACES/CTL/odt_PQ10k.ctl Pattern5.tif -format tiff16 XYZ-2-1.tiff

ctlrender -force -verbose -ctl $EDRHOME/ACES/CTL/scale.ctl -param1 scale 27.78 -ctl $EDRHOME/ACES/transforms/ctl/rrt/rrt.ctl -param1 aIn 1.0  -ctl $EDRHOME/ACES/CTL/odt_PQ10k.ctl Pattern5.tif -format tiff16 XYZ-2-10.tiff


../pattern5 -one 640

ctlrender -force -verbose -ctl $EDRHOME/ACES/CTL/scale.ctl -param1 scale .2778 -ctl $EDRHOME/ACES/transforms/ctl/rrt/rrt.ctl -param1 aIn 1.0  -ctl $EDRHOME/ACES/CTL/odt_PQ10k.ctl Pattern5.tif -format tiff16 XYZ-2-01.tiff

ctlrender -force -verbose -ctl $EDRHOME/ACES/CTL/scale.ctl -param1 scale .02778 -ctl $EDRHOME/ACES/transforms/ctl/rrt/rrt.ctl -param1 aIn 1.0  -ctl $EDRHOME/ACES/CTL/odt_PQ10k.ctl Pattern5.tif -format tiff16 XYZ-2-001.tiff

./InputConversionXYZ.sh


rm YDzDx.yuv
$EDRHOME/Tools/tiff2ydzdx/tiff2ydzdx XYZ-1-1.tiff Y500 HD1920
$EDRHOME/Tools/tiff2ydzdx/tiff2ydzdx XYZ-1-10.tiff Y500 HD1920
$EDRHOME/Tools/tiff2ydzdx/tiff2ydzdx XYZ-5-1.tiff Y500 HD1920
$EDRHOME/Tools/tiff2ydzdx/tiff2ydzdx XYZ-5-10.tiff Y500 HD1920
$EDRHOME/Tools/tiff2ydzdx/tiff2ydzdx XYZ-2-1.tiff Y500 HD1920
$EDRHOME/Tools/tiff2ydzdx/tiff2ydzdx XYZ-2-10.tiff Y500 HD1920
$EDRHOME/Tools/tiff2ydzdx/tiff2ydzdx XYZ-2-01.tiff Y500 HD1920
$EDRHOME/Tools/tiff2ydzdx/tiff2ydzdx XYZ-2-001.tiff Y500 HD1920

./encodeHDY500.sh 2>&1 | tee logEncode.txt



./OutputConversionXYZ.sh

geeqie 500n_32 &

