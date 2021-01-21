// set up for 12 bits 
// ASSUMES 3840x2160 ONLY


#include <tiffio.h>
#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#define PI 3.14159265
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
  unsigned short horiz = 4096;
  unsigned short numStrips = 2160;
  unsigned short frame = 5;
  float nits = 300.0; // nits
  char tifName[] = "000000.tiff";



main(int argc, char* argv[])
{ 


		
	     //Process Args:
	     short arg = 1;
	     while(arg < argc) {
	     	
		     if(strcmp(argv[arg],"-frame")==0) {
					arg++;
					if(arg < argc)frame=atoi(argv[arg]);		 
					printf("frame: %d\n",frame);   	
		     }  

		     if(strcmp(argv[arg],"-w")==0) {
					arg++;
					if(arg < argc)horiz=atoi(argv[arg]);		 
					printf("width: %d\n",horiz);   	
		     } 
		     
		     if(strcmp(argv[arg],"-h")==0) {
					arg++;
					if(arg < argc)numStrips=atoi(argv[arg]);		 
					printf("height: %d\n",numStrips);   	
		     } 		     
	     arg++;
	     }
  
  unsigned short stripsize = horiz*2*3;
  unsigned short pixelStart = 0;
  
  float wScale = 1.; //4096./horiz;
  float hScale = 1.; //2160./numStrips;
  float rScale = sqrt(pow(4096./2.,2)+pow(2160./2.,2))/sqrt(pow(horiz/2.,2)+pow(numStrips/2.,2));
  printf("rScale = %f\n", rScale);
  
  for (int F = 0; F <= frame;F++)
  {
 
 
  // Array to store line of output for writing process
  // will be allocated to line width with 4 unsigned shorts
  unsigned short *Line;
  
  // Allocate memory to read each image
  int arraySizeX = stripsize/6 - pixelStart/6; // eg 3840
  int arraySizeY = numStrips;
  int arraySizeXH = arraySizeX/2; // eg 1920 cols
  int arraySizeYH = arraySizeY/2; // eg 1080 rows
  printf("Frame Size: %d x %d :: Frame: %d\n",arraySizeX,arraySizeY, F);

  Line =  (unsigned short *)malloc((3*arraySizeX*sizeof(unsigned short)));

  // set up  frame name
  sprintf(tifName,"%05d.tiff", F); 

		
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
				float r = rScale*sqrt(pow(hScale*(line - arraySizeY/2.),2.) + pow(wScale*((int)(pixel/3.) - arraySizeX/2.),2.));
				float f = r/((((float)F/(float)frame)*(4096.-2160.)+2160.));
				float v = (PQ10000_r(nits/10000.)*(1.-cos(2.*PI*f*r))/2.);
				//float l = (nits/10000.)*(1.-cos(2.*PI*f*r))/2.);
				//float v = PQ10000_r(l);
				
				
				//P3 D65 to XYZ: 
				//{ { 0.486571,	0.228975,	0,	0},
				  //{ 0.265668,	0.691739,	0.0451134,	0},
				  //{ 0.198217,	0.0792869,	1.04394,	0},
				  //{ 0,	0,	0,	1} };				

				Line[pixel]   = (int)(65535.*v*(0.486571+0.265668+0.198217)+0.5); 
				Line[pixel+1] = (int)(65535.*v*(0.228975+0.691739+0.0792869)+0.5);  
				Line[pixel+2] = (int)(65535.*v*(0.0+0.0451134+1.04394)+0.5);
					

			}
			

			TIFFWriteRawStrip(tif, (tstrip_t)line, (tdata_t)Line, 3*arraySizeX*2);

		}		
		
		TIFFClose(tif);
	}

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

