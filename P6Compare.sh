set -x


# CTL Base
CTLBASE=$EDRHOME/ACES/CTL
# DPXEXR Tools (sigma_compare)
DPXEXR=$EDRHOME/Tools/demos/sc
last=59 #29  # or 749


cd animation



#BITDEPTH (in P6range.sh)
# SigmaCompare TIFFs to exr
$DPXEXR/sigma_compare_PQ  XpYpZp%05d.exr XpYpZp%05d-10b.exr 0  $last 1.0  2>&1 | tee CMP16-10b.log
$DPXEXR/sigma_compare_PQ  XpYpZp%05d.exr XpYpZp%05d-12b.exr 0  $last 1.0  2>&1 | tee CMP16-12b.log
$DPXEXR/sigma_compare_PQ  XpYpZp%05d.exr XpYpZp%05d-14b.exr 0  $last 1.0  2>&1 | tee CMP16-14b.log







# YUV
# SigmaCompare YUV to exr
$DPXEXR/sigma_compare_PQ  XpYpZp%05d.exr 10b-DIR/XpYpZp%06d.tif.exr 0  $last 1.0  2>&1 | tee CMP16-YUV-10b.log
$DPXEXR/sigma_compare_PQ  XpYpZp%05d.exr 12b-DIR/XpYpZp%06d.tif.exr 0  $last 1.0  2>&1 | tee CMP16-YUV-12b.log
$DPXEXR/sigma_compare_PQ  XpYpZp%05d.exr 14b-DIR/XpYpZp%06d.tif.exr 0  $last 1.0  2>&1 | tee CMP16-YUV-14b.log



# HEVC
# SigmaCompare HEVC to exr

#x265
BITDEPTH=10
YUVBASE=C-$BITDEPTH"b"
crf=24
BASE=x265-$YUVBASE-$crf
DIR=HEVC-$BASE-DIR
$DPXEXR/sigma_compare_PQ  XpYpZp%05d.exr $DIR/XpYpZp%06d.tif.exr 0  $last 1.0  2>&1 | tee CMP16-HEVC-x265-10b.log

# HM 10 bit
BITDEPTH=10
YUVBASE=C-$BITDEPTH"b"
BASE=HM-$YUVBASE
DIR=HEVC-$BASE-DIR
$DPXEXR/sigma_compare_PQ  XpYpZp%05d.exr $DIR/XpYpZp%06d.tif.exr 0  $last 1.0  2>&1 | tee CMP16-HEVC-HM-10b.log

# HM 12 bit
BITDEPTH=12
YUVBASE=C-$BITDEPTH"b"
BASE=HM-$YUVBASE
DIR=HEVC-$BASE-DIR
$DPXEXR/sigma_compare_PQ  XpYpZp%05d.exr $DIR/XpYpZp%06d.tif.exr 0  $last 1.0  2>&1 | tee CMP16-HEVC-HM-12b.log


# HM 14 bit
BITDEPTH=14
YUVBASE=C-$BITDEPTH"b"
BASE=HM-$YUVBASE
DIR=HEVC-$BASE-DIR
$DPXEXR/sigma_compare_PQ  XpYpZp%05d.exr $DIR/XpYpZp%06d.tif.exr 0  $last 1.0  2>&1 | tee CMP16-HEVC-HM-14b.log



cd ..

exit






