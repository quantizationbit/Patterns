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
  
  // hard code 3840 x 2160
  unsigned short horiz = 3840;
  unsigned short stripsize = horiz*2*3;
  unsigned short pixelStart = 0;
  unsigned short numStrips = 2160;
  int red, green, blue;
  float percent;

  char tifName[] = "000000000000000000000000000000.tiff";

  


main(int argc, char* argv[])
{ 
		
	     //Process Args:
	     short arg = 1;
	     while(arg < argc) {
	     	
		     if(strcmp(argv[arg],"-r")==0) {
					arg++;
					if(arg < argc)red=atoi(argv[arg]);		 
					printf("red: %d\n",red);   	
		     }  

		     if(strcmp(argv[arg],"-g")==0) {
					arg++;
					if(arg < argc)green=atoi(argv[arg]);		 
					printf("green: %d\n",green);   	
		     }  

		     if(strcmp(argv[arg],"-b")==0) {
					arg++;
					if(arg < argc)blue=atoi(argv[arg]);		 
					printf("blue: %d\n",blue);   	
		     }  

		     if(strcmp(argv[arg],"-percent")==0) {
					arg++;
					if(arg < argc)percent=atof(argv[arg]);		 
					printf("percent: %d\n",percent);   	
		     }
		     
	
		     		     
	     arg++;
	     }
  
    // set up  frame name
  sprintf(tifName,"%d_%d_%d_%d.tiff", red,green,blue,(int)(percent+0.5)); 

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
		for (int line = 0;line < arraySizeY;line++)
		{


			
			for (unsigned int pixel = 0; pixel < (3*arraySizeX);pixel+=3)
			{

				Line[pixel]   = 0;   // R = X
				Line[pixel+1] = 0;   //G = Y 
				Line[pixel+2] = 0;   // B = Z
				
				// Paint in percent box
				int halfPctx = (int)(arraySizeX*0.5*percent/100.0 + 0.5);
				int startx = (arraySizeX/2-halfPctx)*3;
				int endx = (arraySizeX/2+halfPctx)*3;

				int halfPcty = (int)(arraySizeY*0.5*percent/100.0 + 0.5);
				int starty = (arraySizeY/2-halfPcty);
				int endy = (arraySizeY/2+halfPcty);	
				
				if(pixel >= startx && pixel <endx) {
				   if(line >=starty && line <endy)    {
					  Line[pixel]   = 64*red;   // R = X
				      Line[pixel+1] = 64*green;   //G = Y 
				      Line[pixel+2] = 64*blue;   // B = Z
				   }	
				}				

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

