Various patterns for simple testing.

**pattern8** (ANSI 5x5 / Corner Box / Center Box)
This tool will generate a 16-bit tiff file with an ANSI and/or Corner/Center Box pattern in many permutations based on input arguments.  For example `pattern8  -min 0.1 -max 1.0 -maxC 500.0 -corner` will generate a background 5x5 ANSI pattern alternating between 0.1 and 1.0 cd/m2 with 500 cd/m2 corner 2.5% area each boxes. Additional options are:

```
-min and -max set the ANSI 5x5 nit levels, setting them the same or zero flattens the background
-corner turns on the corner box with -maxC to set the cd/m2 of the corners
-center turns on a center box with -minC to set the cd/m2 of the center box
-flip will generate the reversed ANSI pattern8
-legal will generate a legal range output (RGB) default is full range
-idx <num> will apply the provided integer number in front of the
generated filename. Helpful if you're making batches of related patterns.
-r <num> -g <num> -b <num> are optional scale factors to use if you want
other than white output. For example to make Cyan colored output use -r 0.0  -g 1.0 -b 1.0.
-2020 will matrix the pixels to Rec 2020 D65 (assuming they are P3D65 to start)
The file name is generated roughly from the parameter values used.
```

**pattern7**
See P7.sh.  Generates center boxes of size and rgb code value determined from arguments.

**pattern6**:

Generates a single frame out of a sequence. This pattern has color gradients that are somewhat smeared around by a small bouncing ball moving through the frame that changes the slope and direction of the gradiants dynamically. Very ad-hoc algorithmn intended to create imagary with severe banding issues in color and grayscale.

Typical usage would be to use "pattern6" to generate a sequence of frames (like 10 seconds or more) then use other tools such as ctlrender to matrix it into a desired colorspace and gamma and then yuv. The entire sequence can then be compressed for testing.

To make a frame: (-frame frame number in sequence, -speed speed multiplier should be 1-5ish, -percent maximum range of gradient relative to 32000 )

pattern6 -frame 18000 -speed 4 -percent 90


pattern5: (needs to be updated...writes a tiff with alpha which is less compatible with other tools)

Generates a static image of blocks of color offsets from RGB and a linear grayscale ramp of very limited extent. The pattern is generated in code value space for a 16 bit tiff centered around codevalue 32000. It is intended to be used as input to a matrixing operation to transform it into something that can be used as floating point linear data.  (e.g. scale the 32000 point in the tiff to 0.5 or any value and treat the RGB values as some colorspace such as P3, 2020, 709, etc.)

usage is:  pattern5 -one # , where # is how many code values in the offsets.


**pattern9** (banded ramp)

Writes a tiff with a ramp split into bands, drawn inside a title safe window. By default the ramp is inset 2.5 percent from each edge of the frame, and the border around it (the surround) is filled at the -maxC nit level. -nosafe sets the inset to zero so the ramp spans the full frame.

Other options include -min and -max (nit range of the ramp), -bands (number of steps), -r -g -b (color scale factors), -legal, -2020, -idx, -UHD, -UHD2, -2K and -4K. See P9.sh for examples.

**pattern10**

Writes numbered frames (-frame) for building a DCP. See pattern10.sh, which feeds the frames to OpenDCP.

**pattern, pattern2, pattern3, pattern4**

Earlier ramp patterns. They repeat a ramp of values down the image (pattern4 also uses standard illuminant white points). Most of the patterns assume a 3840x2160 frame (see the comment at the top of each source file).

**PQ**

Small helper for the PQ transfer function, with -EOTF and -IEOTF options.


## Building

`make` builds pattern through pattern10 and PQ. It needs g++ and libtiff (the makefile links with -ltiff). `make clean` removes the binaries.

## Animation

animation.sh builds the bit depth comparison animation. The animation folder holds its comparison charts (CMP16-*.png).
