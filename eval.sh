set -x





mkdir animation
cd animation


AF=1.0
frame=2132

#
# Compare input and output of YUV as whole sequence
#
# back count off so get the actual last frame num to compare
#$EDRHOME/Tools/demos/sc/sigma_compare_PQ  XpYpZp%05d.exr    YUVPQRT/XpYpZp%05d.exr  0  $frame $AF  2>&1 | tee SC-LOG/log-multi.txt

$EDRHOME/Tools/demos/sc/sigma_compare_PQ  XpYpZp%05d.exr   XpYpZp%05d.exr  500  503 $AF


#mpv --loop 1000 --osd-level=0 --demuxer=rawvideo --demuxer-rawvideo=w=1920:h=1080:fps=23.976:mp-format=yuv420p10le --colormatrix BT.709 --colormatrix-input-range=limited --colormatrix-output-range=full YDzDx.yuv
