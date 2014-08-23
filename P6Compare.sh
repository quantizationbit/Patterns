set -x


# CTL Base
CTLBASE=$EDRHOME/ACES/CTL
# DPXEXR Tools (sigma_compare)
DPXEXR=$EDRHOME/Tools/demos/sc
last=29  # or 749


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
$DPXEXR/sigma_compare_PQ  XpYpZp%05d.exr pattern6PQ2020-20-DIR/XpYpZp%06d.tif.exr 0  $last 1.0  2>&1 | tee CMP16-HEVC-x265-10b.log


cd ..

exit

