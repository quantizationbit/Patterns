Various patterns for simple testing.

patern6:

Generates a single frame from a sequence. This pattern has color gradients that are somewhat smeared around by a small bouncing ball moving through the frame that changes the slope and direction of the gradiants dynamically. Very ad-hoc algorithmn intended to create imagary with severe banding issues in color and grayscale.

Typical usage would be to use "pattern6" to generate a sequence of frames (like 10 seconds or more) then use other tools such as ctlrender to matrix it into a desired colorspace and gamma and then yuv. The entire sequence can then be compressed for testing.

To make a frame: (-frame frame number in sequence, -speed speed multiplier should be 1-5ish, -percent maximum range of gradient relative to 32000 )

pattern6 -frame 18000 -speed 4 -percent 90


pattern5: (needs to be updated...writes a tiff with alpha which is less compatible with other tools)

Generates a static image of blocks of color offsets from RGB and a linear grayscale ramp of very limited extent. The pattern is generated in code value space for a 16 bit tiff centered around codevalue 32000. It is intended to be used as input to a matrixing operation to transform it into something that can be used as floating point linear data.  (e.g. scale the 32000 point in the tiff to 0.5 or any value and treat the RGB values as some colorspace such as P3, 2020, 709, etc.)

usage is:  pattern5 -one # , where # is how many code values in the offsets.