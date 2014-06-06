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
  unsigned short horiz = 1920;
  unsigned short stripsize = horiz*2*3;
  unsigned short pixelStart = 0;
  unsigned short numStrips = 1080;
  float r = 25; // radius
  float x = 5 + r;
  float y = numStrips/2;
  float fps = 23.976;
  float vx = float(horiz/30)/fps;
  float vy = -float(numStrips/10)/fps;
  float speed;
  short  stripStart;
  short D55 = 0;
  unsigned short frame = 0;
  char tifName[] = "000000.tiff";
  short one=320; //one percent
  short gray=32000;
  float percent;
  
  //colors
  unsigned short topL = 0, topM = horiz/2, topR = horiz-1, btm = numStrips-1, mid = numStrips/2-1;

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

		     if(strcmp(argv[arg],"-percent")==0) {
					arg++;
					if(arg < argc)percent=atof(argv[arg]);		 
					printf("percent: %d\n",percent);   	
		     } 
	
		     if(strcmp(argv[arg],"-speed")==0) {
					arg++;
					if(arg < argc)speed=atof(argv[arg]);		 
					printf("speed: %f\n",speed);   
					vx=vx*speed;
					vy=vy*speed;	
		     } 	
		     		     
	     arg++;
	     }
  
    // set up  frame name
  sprintf(tifName,"%05d.tiff", frame); 
  
  for (int F = 0; F <= frame;F++)
  {
  		if( F == 0) continue;
      // Loop position until get to frame time
 					// advance circle to next frame position
 		   x+=vx;
 		   y+=vy;

					// address velocity sign reversal if a bounce detected 
					// if circle position is < r from any side then bounce
					
		  //printf("X= %f  Y= %f\n",x,y);

 		   if(x>= (topR-r))
 		   {
 		   	vx = -vx;
 		   	x = topR-r;
 		   }
 		   
 		   if(x<= (topL+r))
 		   {
				vx = -vx;
				x = topL+r; 		   
 		   }
 		   
 		   if(y>= (btm-r))
 		   {
 		   	vy = -vy;
 		   	y = btm-r;
 		   }
 		   
 		   if(y<= (topL+r))
 		   {
				vy = -vy;
				y = topL+r; 		   
 		   }
					
 
  
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
		for (int line = 0;line < arraySizeY;line++)
		{


			
			for (unsigned int pixel = 0; pixel < (3*arraySizeX);pixel+=3)
			{

				   Line[pixel]   = 0;   // R = X
					Line[pixel+1] = 0;   //G = Y 
					Line[pixel+2] = 0;   // B = Z
					
					// If pixel is near circle then paint it in circle
					// check if distance is < r
					// position x = pixel/3
					// position y = line
					px = x - (float)pixel/3.0;
					py = y - (float)line;
					d1 = sqrt(pow(px,2) + pow(py,2));
					if(d1 < r)
					{
                  Line[pixel+0] = gray - percent*one;					
                  Line[pixel+1] = gray - percent*one;					
                  Line[pixel+2] = gray - percent*one;
                  continue;					                                    
					}

					
					// if pixel not in circle advance color ramp between pixel and other colors
					// distance to each color - circle radius
					
					
					// Top Left corner
					// spot center is x,y
					// current pixel is pixel/3.0, line
					// distance is spot to pixel plus pixel to corner
					px = x - (float)pixel/3.0;
					py = y - (float)line;
					d1 = sqrt(pow(px,2) + pow(py,2)) - r; //spot to pixel distance
					if(d1<0){d1 = 0;}
					d2 = sqrt(pow((float)pixel/3.0,2) + pow((float)line,2)); //pixel to corner distance
					
					if(d2 >= r)
					{
						//ramp is proportional to d and entire ramp completes across d
						//ramp delta is position*ramp/d
                  Line[pixel+0] = gray + percent*(1.0 -((d2-r)/(d1+d2)))*one;
		         }					
		         else
		         {
		         	Line[pixel+0] = gray + percent*one;
		         }
               ///
					// Bottom right corner (B-1)
					d2 = sqrt(pow(horiz -1 - (float)pixel/3.0,2) + pow(numStrips -1 - (float)line,2)); //pixel to corner distance
					if(d2 >= r)
					{
						//ramp is proportional to d and entire ramp completes across d
						//ramp delta is position*ramp/d
                  Line[pixel+2] = gray - percent*(1.0 -((d2-r)/(d1+d2)))*one;
		         }
		         else
		         {
		         	Line[pixel+2] = gray - percent*one;
		         }						   

					// Top right corner (B+1)
					d2 = sqrt(pow(horiz -1 - (float)pixel/3.0,2) + pow(0 - (float)line,2)); //pixel to corner distance
					if(d2 >= r)
					{
						//ramp is proportional to d and entire ramp completes across d
						//ramp delta is position*ramp/d
                  Line[pixel+2] = Line[pixel+2] + percent*(1.0 -((d2-r)/(d1+d2)))*one;
		         }	
		         else
		         {
		         	Line[pixel+2] = Line[pixel+2] + percent*one;
		         }

					// Bottom left corner (R-1)
					d2 = sqrt(pow(0 - (float)pixel/3.0,2) + pow(numStrips -1 - (float)line,2)); //pixel to corner distance
					if(d2 >= r)
					{
						//ramp is proportional to d and entire ramp completes across d
						//ramp delta is position*ramp/d
                  Line[pixel+0] = Line[pixel+0] - percent*(1.0 -((d2-r)/(d1+d2)))*one;
		         }	
		         else
		         {
		         	Line[pixel+0] = Line[pixel+0] - percent*one;
		         }
					// Center top G-1
					d2 = sqrt(pow(-1 + horiz/2 - (float)pixel/3.0,2) + pow(0 - (float)line,2)); //pixel to corner distance
					if(d2 >= r)
					{
						//ramp is proportional to d and entire ramp completes across d
						//ramp delta is position*ramp/d
                  Line[pixel+1] = gray - percent*(1.0 -((d2-r)/(d1+d2)))*one;
		         }
		         else
		         {
		         	Line[pixel+1] = gray - percent*one;
		         }
					// Center bottom G+1
					d2 = sqrt(pow(-1 + horiz/2 - (float)pixel/3.0,2) + pow(numStrips -1 - (float)line,2)); //pixel to corner distance
					if(d2 >= r)
					{
						//ramp is proportional to d and entire ramp completes across d
						//ramp delta is position*ramp/d
                  Line[pixel+1] = Line[pixel+1] + percent*(1.0 -((d2-r)/(d1+d2)))*one;
		         }
		         else
		         {
		         	Line[pixel+1] = Line[pixel+1] + percent*one;
		         }
		         
		         
		         
		         // spots in center left and right of image are too much so skip
		         continue; //skipping
		         
		         
		         // left center R+1, G-1
					d2 = sqrt(pow(-1 + horiz/4 - (float)pixel/3.0,2) + pow(-1 +numStrips/2 - (float)line,2)); //pixel to spot distance
					if(d2 >= r)
					{
						//ramp is proportional to d and entire ramp completes across d
						//ramp delta is position*ramp/d
                  Line[pixel+1] = Line[pixel+1] - percent*(1.0 -pow((d2-r)/(d1+d2),4))*one;
                  Line[pixel+0] = Line[pixel+0] + percent*(1.0 -pow((d2-r)/(d1+d2),4))*one;                  
		         }
		         else
		         {
		         	Line[pixel+1] = Line[pixel+1] - percent*one;
		         	Line[pixel+0] = Line[pixel+0] + percent*one;
		         }		         
		         
	
		         // right center G+1 B-1
					d2 = sqrt(pow(-1 + 3*horiz/4 - (float)pixel/3.0,2) + pow(-1 +numStrips/2 - (float)line,2)); //pixel to spot distance
					if(d2 >= r)
					{
						//ramp is proportional to d and entire ramp completes across d
						//ramp delta is position*ramp/d
                  Line[pixel+1] = Line[pixel+1] + percent*(1.0 -pow((d2-r)/(d1+d2),4))*one;
                  Line[pixel+2] = Line[pixel+2] - percent*(1.0 -pow((d2-r)/(d1+d2),4))*one;                 
		         }
		         else
		         {
		         	Line[pixel+1] = Line[pixel+1] + percent*one;
		         	Line[pixel+2] = Line[pixel+2] - percent*one;
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

