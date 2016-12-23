set -x






cd animation

mpv --loop 20 --osd-level=0 --demuxer=rawvideo --demuxer-rawvideo=w=1920:h=1080:fps=23.976:mp-format=yuv420p10le --colormatrix BT.709 --colormatrix-input-range=limited --colormatrix-output-range=full YDzDx.yuv

