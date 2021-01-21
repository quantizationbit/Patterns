#!/bin/bash


set -x

make
rm -rfv zone tmp
mkdir zone tmp
cd zone

../pattern10 -frame 2

cd ..

rm -rfv j2k DCP
mkdir j2k DCP
cd DCP

opendcp_j2k -i ../zone -b 400 -e kakadu -x -p cinema4k -f -t 8 -m ../tmp -o ../j2k


opendcp_mxf -i ../j2k -o Zone.mxf

	
opendcp_xml --reel Zone.mxf --reel Zone.mxf --reel Zone.mxf --reel Zone.mxf --reel Zone.mxf  --digest Zone4K --kind test -t "4K Zone plate"





exit

OpenDCP version 0.30.0 (c) 2010-2014 Terrence Meiczinger. All rights reserved.

Usage:
       opendcp_j2k -i <file> -o <file> [options ...]

Required:
       -i | --input <file>            - input file or directory
       -o | --output <file>           - output file or directory

Options:
       -r | --rate <rate>                 - frame rate (default 24)
       -p | --profile <profile>           - profile cinema2k | cinema4k (default cinema2k)
       -b | --bw                          - max Mbps bandwitdh (default: 250)
       -3 | --3d                          - adjust frame rate for 3D
       -e | --encoder <openjpeg | kakadu> - jpeg2000 encoder (default openjpeg)
       -x | --no_xyz                      - do not perform rgb->xyz color conversion
       -c | --colorspace <color>          - select source colorpsace: (srgb, rec709, p3, srgb_complex, rec709_complex)
       -f | --calculate                   - Calculate RGB->XYZ values instead of using LUT
       -g | --dpx <linear | film | video> - process dpx image as linear, log film, or log video (default linear)
       -z | --resize                      - resize image to DCI compliant resolution
       -s | --start                       - start frame
       -d | --end                         - end frame
       -t | --threads <threads>           - set number of threads (default 4)
       -m | --tmp_dir                     - sets temporary directory (usually tmpfs one) to save there temporary tiffs for Kakadu
       -n | --no_overwrite                - do not overwrite existing jpeg2000 files
       -l | --log_level <level>           - sets the log level 0:Quiet, 1:Error, 2:Warn (default),  3:Info, 4:Debug
       -h | --help                        - show help
       -v | --version                     - show version
