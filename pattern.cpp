// set up for 12 bits 
// ASSUMES 3840x2160 ONLY


#include <tiffio.h>
#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <string.h>

using namespace std;

// Globals

  unsigned short X;
  unsigned short Y;
  unsigned short Z;
  unsigned short A;

  // file pointer for tif
  TIFF* tif;
  
  // hard code 3840 x 2160
  unsigned short stripsize = 3840*2*4;
  unsigned short pixelStart = 0;
  unsigned short numStrips = 2160;
  short  stripStart;
  char tifName[] = "Pattern.tif"; 

main(int argc, char* argv[])
{ 

  // Array to store line of output for writing process
  // will be allocated to line width with 4 unsigned shorts
  unsigned short *Line;
  
  // Allocate memory to read each image
  int arraySizeX = stripsize/8 - pixelStart/8; // eg 3840
  int arraySizeY = numStrips;
  int arraySizeXH = arraySizeX/2; // eg 1920 cols
  int arraySizeYH = arraySizeY/2; // eg 1080 rows
  printf("Frame Size: %d x %d\n",arraySizeX,arraySizeY);

  Line =  (unsigned short *)malloc((4*arraySizeX*sizeof(unsigned short)));


		
		tif = TIFFOpen(tifName, "w");
		TIFFSetField(tif, TIFFTAG_SAMPLESPERPIXEL, 4);
		TIFFSetField(tif, TIFFTAG_BITSPERSAMPLE, 16);
		TIFFSetField(tif, TIFFTAG_PLANARCONFIG, PLANARCONFIG_CONTIG);
		TIFFSetField(tif, TIFFTAG_IMAGEWIDTH, arraySizeX);
		TIFFSetField(tif, TIFFTAG_IMAGELENGTH, arraySizeY);
		TIFFSetField(tif, TIFFTAG_ROWSPERSTRIP, 1);
		TIFFSetField(tif, TIFFTAG_PHOTOMETRIC, PHOTOMETRIC_RGB);		

		X = 0;
		Y = 0;
		Z = 0;
		// ramp values
		unsigned short Xr = 0;
		unsigned short Yr = 0;
		unsigned short Zr = 0;
		
		// Compute D65 linear XYZ 1-50%
		// X = Y * (x/y) 
		// Z = Y * (1-x-y)/y
		float xD65 = 0.3127;
		float yD65 = 0.3290;
		float pct  = 0.0;

		for (int line = 0;line < arraySizeY;line++)
		{
			// Set 5%
			if(line < arraySizeY/4) pct = 0.05;
		
			// Set 10%
			if(line >= arraySizeY/4 && line < 2*arraySizeY/4) pct = 0.10;
			
			// Set 20%
			if(line >= 2*arraySizeY/4 && line < 3*arraySizeY/4) pct = 0.20;
			
			// Set 50%
			if (line >= 3*arraySizeY/4) pct = 0.5;
			
			
			X = (unsigned short)(0.5 + 4095.0 *(pct * xD65/yD65));
			Y = (unsigned short)(0.5 + 4095 * pct);
			Z = (unsigned short)(0.5 + 4095.0 *(pct * (1.0 - xD65 - yD65)/yD65));
			
			// ramp value (repeat 4 times down image)
			// consider exponential ramp
			//	Yr = pow(0.15*((float)(line % (arraySizeY/4))) / (((float)arraySizeY)/4.0),0.3333)
			pct = pct*((float)(line % (arraySizeY/4))) / (((float)arraySizeY)/4.0);
			Xr = (unsigned short)(0.5 + 4095.0 *(pct * xD65/yD65));
			Yr = (unsigned short)(0.5 + 4095 * pct);
			Zr = (unsigned short)(0.5 + 4095.0 *(pct * (1.0 - xD65 - yD65)/yD65));			
			
			for (unsigned int pixel = 0; pixel < (4*arraySizeX-16);pixel+=16)
			{
				if(pixel < arraySizeX) {
				   Line[pixel]   = 0;     // R = X
					Line[pixel+1] = 0;  //G = Y 
					Line[pixel+2] = 0;   // B = Z
					Line[pixel+3] = 65535;  // A
					if(pixel > arraySizeX/2) { //ramp
				   Line[pixel+4] = Xr << 4;     // R = X
					Line[pixel+5] = Yr << 4;  //G = Y 
					Line[pixel+6] = Zr << 4;   // B = Z
					Line[pixel+7] = 65535;  // A
					}else { // no ramp
				   Line[pixel+4] = X << 4;     // R = X
					Line[pixel+5] = Y << 4;  //G = Y 
					Line[pixel+6] = Z << 4;   // B = Z
					Line[pixel+7] = 65535;  // A
					 }
					
				   Line[pixel+8]   = 0;     // R = X
					Line[pixel+9] = 0;  //G = Y 
					Line[pixel+10] = 0;   // B = Z
					Line[pixel+11] = 65535;  // A	
								
				   Line[pixel+12]   = 0;     // R = X
					Line[pixel+13] = 0;  //G = Y 
					Line[pixel+14] = 0;   // B = Z
					Line[pixel+15] = 65535;  // A	
				} else if(pixel >= arraySizeX && pixel < 2*arraySizeX) {
				   Line[pixel]   = 0;     // R = X
					Line[pixel+1] = 0;  //G = Y 
					Line[pixel+2] = 0;   // B = Z
					Line[pixel+3] = 65535;  // A
	
				   Line[pixel+4] = X << 4;     // R = X
					Line[pixel+5] = Y << 4;  //G = Y 
					Line[pixel+6] = Z << 4;   // B = Z
					Line[pixel+7] = 65535;  // A
					
				   Line[pixel+8] = X << 4;     // R = X
					Line[pixel+9] = Y << 4;  //G = Y 
					Line[pixel+10] =Z << 4;   // B = Z
					Line[pixel+11] = 65535;  // A	
					
					if (pixel > 3*arraySizeX/2) { // ramp
				   Line[pixel+4] = Xr << 4;     // R = X
					Line[pixel+5] = Yr << 4;  //G = Y 
					Line[pixel+6] = Zr << 4;   // B = Z
					Line[pixel+7] = 65535;  // A
					
				   Line[pixel+8] = Xr << 4;     // R = X
					Line[pixel+9] = Yr << 4;  //G = Y 
					Line[pixel+10] =Zr << 4;   // B = Z
					Line[pixel+11] = 65535;  // A					
					}					
								
				   Line[pixel+12]   = 0;     // R = X
					Line[pixel+13] = 0;  //G = Y 
					Line[pixel+14] = 0;   // B = Z
					Line[pixel+15] = 65535;  // A	
				}	else if(pixel >= 2*arraySizeX && pixel < 3*arraySizeX) {
				   Line[pixel]   = 0;     // R = X
					Line[pixel+1] = 0;  //G = Y 
					Line[pixel+2] = 0;   // B = Z
					Line[pixel+3] = 65535;  // A
	
				   Line[pixel+4] = X << 4;     // R = X
					Line[pixel+5] = Y << 4;  //G = Y 
					Line[pixel+6] = Z << 4;   // B = Z
					Line[pixel+7] = 65535;  // A
					
				   Line[pixel+8] = X << 4;     // R = X
					Line[pixel+9] = Y << 4;  //G = Y 
					Line[pixel+10] =Z << 4;   // B = Z
					Line[pixel+11] = 65535;  // A	
					if (pixel > 5*(arraySizeX/2)) { // ramp
				   Line[pixel+4] = Xr << 4;     // R = X
					Line[pixel+5] = Yr << 4;  //G = Y 
					Line[pixel+6] = Zr << 4;   // B = Z
					Line[pixel+7] = 65535;  // A
					
				   Line[pixel+8] = Xr << 4;     // R = X
					Line[pixel+9] = Yr << 4;  //G = Y 
					Line[pixel+10] =Zr << 4;   // B = Z
					Line[pixel+11] = 65535;  // A					   }
					} // end ramp			
				   Line[pixel+12]   = 0;     // R = X
					Line[pixel+13] = 0;  //G = Y 
					Line[pixel+14] = 0;   // B = Z
					Line[pixel+15] = 65535;  // A	
					
				   Line[pixel+16]   = 0;     // R = X
					Line[pixel+17] = 0;  //G = Y 
					Line[pixel+18] = 0;   // B = Z
					Line[pixel+19] = 65535;  // A						

				   Line[pixel+20] = 0;     // R = X
					Line[pixel+21] = 0;  //G = Y 
					Line[pixel+22] = 0;   // B = Z
					Line[pixel+23] = 65535;  // A	

				   Line[pixel+24] = 0;     // R = X
					Line[pixel+25] = 0;  //G = Y 
					Line[pixel+26] = 0;   // B = Z
					Line[pixel+27] = 65535;  // A	

				   Line[pixel+28] = 0;     // R = X
					Line[pixel+29] = 0;  //G = Y 
					Line[pixel+30] = 0;   // B = Z
					Line[pixel+31] = 65535;  // A	
					pixel +=16;
					
					} else { // alternate every 4 lines for last quarter
					if(line % 4 == 0) {
				   Line[pixel]   = X << 4;     // R = X
					Line[pixel+1] = Y << 4;  //G = Y 
					Line[pixel+2] = Z << 4;   // B = Z
					Line[pixel+3] = 65535;  // A
					
					Line[pixel+4] = X << 4;     // R = X
					Line[pixel+5] = Y << 4;  //G = Y 
					Line[pixel+6] = Z << 4;   // B = Z
					Line[pixel+7] = 65535;  // A
					
				   Line[pixel+8] = X << 4;     // R = X
					Line[pixel+9] = Y << 4;  //G = Y 
					Line[pixel+10] =Z << 4;   // B = Z
					Line[pixel+11] = 65535;  // A	
					
				   Line[pixel+12] = X << 4;    // R = X
					Line[pixel+13] = Y << 4;   //G = Y 
					Line[pixel+14] = Z << 4;    // B = Z
					Line[pixel+15] = 65535;  // A		

					if(pixel > 7*(arraySizeX/2)) { //ramp
				   Line[pixel]   = Xr << 4;     // R = X
					Line[pixel+1] = Yr << 4;  //G = Y 
					Line[pixel+2] = Zr << 4;   // B = Z
					Line[pixel+3] = 65535;  // A
				   Line[pixel+4] = Xr << 4;     // R = X
					Line[pixel+5] = Yr << 4;  //G = Y 
					Line[pixel+6] = Zr << 4;   // B = Z
					Line[pixel+7] = 65535;  // A
					
				   Line[pixel+8] = Xr << 4;     // R = X
					Line[pixel+9] = Yr << 4;  //G = Y 
					Line[pixel+10] =Zr << 4;   // B = Z
					Line[pixel+11] = 65535;  // A		
				   Line[pixel+12] = Xr << 4;    // R = X
					Line[pixel+13] = Yr << 4;   //G = Y 
					Line[pixel+14] = Zr << 4;    // B = Z
					Line[pixel+15] = 65535;  // A	
				    } //end ramp				
					} else {
				   Line[pixel]   = 0;     // R = X
					Line[pixel+1] = 0;  //G = Y 
					Line[pixel+2] = 0;   // B = Z
					Line[pixel+3] = 65535;  // A
	
				   Line[pixel+4] = 0;     // R = X
					Line[pixel+5] = 0;  //G = Y 
					Line[pixel+6] = 0;   // B = Z
					Line[pixel+7] = 65535;  // A
					
				   Line[pixel+8]   = 0;     // R = X
					Line[pixel+9] = 0;  //G = Y 
					Line[pixel+10] = 0;   // B = Z
					Line[pixel+11] = 65535;  // A	
								
				   Line[pixel+12]   = 0;     // R = X
					Line[pixel+13] = 0;  //G = Y 
					Line[pixel+14] = 0;   // B = Z
					Line[pixel+15] = 65535;  // A				
				  }		
			   }			
				
			}
			

			TIFFWriteRawStrip(tif, (tstrip_t)line, (tdata_t)Line, 4*arraySizeX*2);

		}		
		
		TIFFClose(tif);
		

}
	


