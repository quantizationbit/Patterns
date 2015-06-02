// set up for 12 bits 
// ASSUMES 3840x2160 ONLY


#include <tiffio.h>
#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <string.h>
#include <math.h>
double PQ10000_f( double V);
double PQ10000_r( double L);

// TV applies PQ Gamma producing Luminance: L via PQf on Vtv L=PQf(Vtv)
// for each tv Luminance the V that produced it is given by Vtv=PQr(L)
// that "Vtv" is gamma encoded in ODT to cancel out the TV gamma  Vtv=PQr(Vlinear)
// Vlinear comes from ACES workflow (e.g after RRT +ODT w/o gamma)
// PQf(Vtv) = L
// PQf(PQr(Vlinear)) = L
// PQf(Vtv) = PQf(PQr(Vlinear)) = Vlinear
// L = Vlinear


using namespace std;



  // file pointer for tif
  TIFF* tif;
  
  // hard code 1920x1080
  unsigned short horiz = 3840;
  unsigned short stripsize = horiz*2*3;
  unsigned short pixelStart = 0;
  unsigned short numStrips = 2160;
  unsigned short height5 = numStrips/5;
  unsigned short width5 = horiz/5;
  unsigned short value = 16*256;
  double minNits = 0.0;
  double maxNits = 10000.0;
  unsigned short minValue;
  unsigned short maxValue;
  int red, green, blue;
  bool flip = false;
  
  float percent;

  char tifName[] = "000000000000000000000000000000.tiff";

  


main(int argc, char* argv[])
{ 
		
	     //Process Args:
	     short arg = 1;
	     while(arg < argc) {
	     	
 

		     if(strcmp(argv[arg],"-min")==0) {
					arg++;
					if(arg < argc)minNits=atof(argv[arg]);		 
					printf("min nits: %f\n",minNits);   	
		     }
		     
		     if(strcmp(argv[arg],"-max")==0) {
					arg++;
					if(arg < argc)maxNits=atof(argv[arg]);		 
					printf("max nits: %f\n",maxNits);   	
		     }	
		     
		     if(strcmp(argv[arg],"-flip")==0) {
					flip=true;		 
					printf("Flip: %d\n",flip);  		     
		     }		     
	     arg++;
	     }
	     
	 minValue = (PQ10000_r(minNits/10000.0)*65535.0 + 0.5);  
	 maxValue = (PQ10000_r(maxNits/10000.0)*65535.0 + 0.5);  
	 
	 if(flip)
	 {
		if(value == minValue) {
			value = maxValue;
		} else {
			value = minValue;
		}		 
	 }

  
    // set up  frame name
  if(flip) {
	  sprintf(tifName,"ANSI5x5_%.3f__%.3f_FLIP.tiff", minNits,maxNits);
  } else {
	  sprintf(tifName,"ANSI5x5_%.3f__%.3f.tiff", minNits,maxNits);
  } 

  // Array to store line of output for writing process
  // will be allocated to line width with 4 unsigned shorts
  unsigned short *Line;
  
  // Allocate memory to read each image
  int arraySizeX = stripsize/6 - pixelStart/6; // eg 3840
  int arraySizeY = numStrips;
  int arraySizeXH = arraySizeX/2; // eg 1920 cols
  int arraySizeYH = arraySizeY/2; // eg 1080 rows
  printf("Frame Size: %d x %d\n",arraySizeX,arraySizeY);

  Line =  (unsigned short *)malloc((3*arraySizeX*sizeof(unsigned short)));


		
		tif = TIFFOpen(tifName, "w");
		TIFFSetField(tif, TIFFTAG_SAMPLESPERPIXEL, 3);
		TIFFSetField(tif, TIFFTAG_BITSPERSAMPLE, 16);
		TIFFSetField(tif, TIFFTAG_PLANARCONFIG, PLANARCONFIG_CONTIG);
		TIFFSetField(tif, TIFFTAG_IMAGEWIDTH, arraySizeX);
		TIFFSetField(tif, TIFFTAG_IMAGELENGTH, arraySizeY);
		TIFFSetField(tif, TIFFTAG_ROWSPERSTRIP, 1);
		TIFFSetField(tif, TIFFTAG_PHOTOMETRIC, PHOTOMETRIC_RGB);		

		float px, py, d1,d2;
		for (int line = 0;line < arraySizeY;line+=1)
		{

			if(line % height5 == 0) {
			
				if(value == minValue) {
					value = maxValue;
				} else {
					value = minValue;
				}
			}
		

			
			for (unsigned int pixel = 0; pixel < (3*arraySizeX);pixel+=3*width5)
			{
				

				
				for(unsigned int subPixel=0; subPixel < width5; subPixel+=1)
				{
					Line[3*subPixel+pixel]   = value;   
					Line[3*subPixel+pixel+1] = value;    
					Line[3*subPixel+pixel+2] = value;   				
							
				}
				
				if(value == minValue) {
					value = maxValue;
				} else {
					value = minValue;
				}			

			}

			if(value == minValue) {
				value = maxValue;
			} else {
				value = minValue;
			}						

			TIFFWriteRawStrip(tif, (tstrip_t)line, (tdata_t)Line, 3*arraySizeX*2);

		}		
		
		TIFFClose(tif);
		

}
	

// Functions

// 10000 nits
//  1/gamma-ish, calculate V from Luma
// decode L = (max(,0)/(c2-c3*V**(1/m)))**(1/n)
double PQ10000_f( double V)
{
  double L;
  // Lw, Lb not used since absolute Luma used for PQ
  // formula outputs normalized Luma from 0-1
  L = pow(max(pow(V, 1.0/78.84375) - 0.8359375 ,0.0)/(18.8515625 - 18.6875 * pow(V, 1.0/78.84375)),1.0/0.1593017578);

  return L;
}

// encode (V^gamma ish calculate L from V)
//  encode   V = ((c1+c2*Y**n))/(1+c3*Y**n))**m
double PQ10000_r( double L)
{
  double V;
  // Lw, Lb not used since absolute Luma used for PQ
  // input assumes normalized luma 0-1
  V = pow((0.8359375+ 18.8515625*pow((L),0.1593017578))/(1+18.6875*pow((L),0.1593017578)),78.84375);
  return V;
}

