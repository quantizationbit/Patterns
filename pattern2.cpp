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
		double xD65 = 0.3127;
		double yD65 = 0.3290;
		double APL  = 0.0;
		double APLM = 0.0;
		double pctr = 0.0;
		double V = 0.0;
		double L = 0.0;

      V = PQ10000_r(10.0/10000.0); // 10 nits APL back to linear V
      L = 10000.0*PQ10000_f(V); //PQ encoding of V
      printf("V=%g,  L =%g\n", V,L);
      
      V = PQ10000_r(100.0/10000.0); // 10 nits APL back to linear V
      L = 10000.0*PQ10000_f(V); //PQ encoding of V
      printf("V=%g,  L =%g\n", V,L);
      
      V = PQ10000_r(500.0/10000.0); // 10 nits APL back to linear V
      L = 10000.0*PQ10000_f(V); //PQ encoding of V
      printf("V=%g,  L =%g\n", V,L);
      
      V = PQ10000_r(2000.0/10000.0); // 10 nits APL back to linear V
      L = 10000.0*PQ10000_f(V); //PQ encoding of V
      printf("V=%g,  L =%g\n", V,L);                  
      
      V = PQ10000_r(5000.0/10000.0); // 10 nits APL back to linear V
      L = 10000.0*PQ10000_f(V); //PQ encoding of V
      printf("V=%g,  L =%g\n", V,L);
               
      V = PQ10000_r(9999.0/10000.0); // 10 nits APL back to linear V
      L = 10000.0*PQ10000_f(V); //PQ encoding of V
      printf("V=%g,  L =%g\n", V,L);		

		
		for (int line = 0;line < arraySizeY;line++)
		{

			// Set APL 0.1
			if(line < arraySizeY/6) APL = 0.1;
			
			// Set APL 1
			if(line >= arraySizeY/6 && line < 2*arraySizeY/6) APL = 1.0;
						
			// Set APL 10
			if(line >= 2*arraySizeY/6 && line < 3*arraySizeY/6) APL = 10.0;
		
 			// Set APL 100
			if(line >= 3*arraySizeY/6 && line < 4*arraySizeY/6) APL = 100.0;
			
			// Set APL 200
			if(line >= 4*arraySizeY/6 && line < 5*arraySizeY/6) APL = 200.0;
			
			// Set APL 500
			if (line >= 5*arraySizeY/6) APL = 500.0;
			

			X = (unsigned short)(0.5 + 4095.0 * PQ10000_r((APL/10000.0) * xD65/yD65));
			Y = (unsigned short)(0.5 + 4095.0 * PQ10000_r(APL/10000.0));
			Z = (unsigned short)(0.5 + 4095.0 * PQ10000_r((APL/10000.0) * (1.0 - xD65 - yD65)/yD65));
			
			// ramp value (repeat 4 times down image)
			// consider exponential ramp
			//	Yr = pow(0.15*((double)(line % (arraySizeY/4))) / (((double)arraySizeY)/4.0),0.3333)

			double range = 0.01;
			
			for (unsigned int pixel = 0; pixel < (4*arraySizeX);pixel+=32)
			{
				if(pixel < 8*arraySizeX/2) range = 0.999;
				if(pixel < 7*arraySizeX/2) range = 0.90;				
				if(pixel < 6*arraySizeX/2) range = 0.75;
				if(pixel < 5*arraySizeX/2) range = 0.50;	
				if(pixel < 4*arraySizeX/2) range = 0.25;
				if(pixel < 3*arraySizeX/2) range = 0.10;				
				if(pixel < 2*arraySizeX/2) range = 0.05;
				if(pixel < arraySizeX/2) range = 0.01;				
								
				pctr = (double)(pixel % (arraySizeX/2));
				pctr = pctr - (double)(arraySizeX/4.0);
				pctr = pctr / ((double)(arraySizeX/4.0));
				pctr = range*pctr;

				//if(pixel>=0)printf("line=%d, range=%g, pctr=%g, APL=%g pixel=%d, pixelmod=%d, arraySizeX=%d\n",line, range, pctr,APL, pixel,pixel % (arraySizeX/2),arraySizeX);

				APLM = APL + pctr*APL;

			Xr = (unsigned short)(0.5 + 4095.0 * PQ10000_r((APLM/10000.0) * xD65/yD65));
			Yr = (unsigned short)(0.5 + 4095.0 * PQ10000_r(APLM/10000.0));
			Zr = (unsigned short)(0.5 + 4095.0 * PQ10000_r((APLM/10000.0) * (1.0 - xD65 - yD65)/yD65));		

				   Line[pixel]   = X << 4;     // R = X
					Line[pixel+1] = Y << 4;  //G = Y 
					Line[pixel+2] = Z << 4;   // B = Z
					Line[pixel+3] = 65535;  // A

				   Line[pixel+4] = Xr << 4;     // R = X
					Line[pixel+5] = Yr << 4;  //G = Y 
					Line[pixel+6] = Zr << 4;   // B = Z
					Line[pixel+7] = 65535;  // A
					
				   Line[pixel+8] = Xr << 4;     // R = X
					Line[pixel+9] = Yr << 4;  //G = Y 
					Line[pixel+10] =Zr << 4;   // B = Z
					Line[pixel+11] = 65535;  // A					
		
				   Line[pixel+12] = X<<4;     // R = X
					Line[pixel+13] = Y<<4;  //G = Y 
					Line[pixel+14] = Z<<4;   // B = Z
					Line[pixel+15] = 65535;  // A	
		
				   Line[pixel+16] = X << 4;     // R = X
					Line[pixel+17] = Y << 4;  //G = Y 
					Line[pixel+18] = Z << 4;   // B = Z
					Line[pixel+19] = 65535;  // A						

				   Line[pixel+20] = X << 4;     // R = X
					Line[pixel+21] = Y << 4;  //G = Y 
					Line[pixel+22] = Z << 4;   // B = Z
					Line[pixel+23] = 65535;  // A	

				   Line[pixel+24] = X << 4;    // R = X
					Line[pixel+25] = Y << 4;  //G = Y 
					Line[pixel+26] = Z << 4;   // B = Z
					Line[pixel+27] = 65535;  // A	

				   Line[pixel+28] = X << 4;    // R = X
					Line[pixel+29] = Y << 4; //G = Y 
					Line[pixel+30] = Z << 4;   // B = Z
					Line[pixel+31] = 65535;  // A	

			}
			

			TIFFWriteRawStrip(tif, (tstrip_t)line, (tdata_t)Line, 4*arraySizeX*2);

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

