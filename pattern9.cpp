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
  double maxCNits= 10000.0;
  unsigned short black;
  unsigned short minValue;
  unsigned short maxValue;
  unsigned short maxCValue;
  int red, green, blue;
  bool flip = false;
  bool legal = false;
  bool corner = false;
  bool center = false;
  bool R2020  = true;
  float area = 0.1; // 10%
  float safe = 0.1; // safe title percent
  unsigned short centerSizeH = (unsigned short)(sqrt(16*horiz*numStrips*area/9) + 0.5);
  unsigned short cornerSizeH = (unsigned short)(sqrt(16*horiz*numStrips*area/36.0) + 0.5);
  unsigned short centerSizeV = (unsigned short)(sqrt(9*horiz*numStrips*area/16) + 0.5);
  unsigned short cornerSizeV = (unsigned short)(sqrt(9*horiz*numStrips*area/64.0) + 0.5);
  unsigned short centerStartTop = numStrips/2 - centerSizeV/2;
  unsigned short centerStartLeft = stripsize/4 - 3*centerSizeH/2;
  
  int idx;
  bool indexF = false;
  
  // color scaling
  float r=1.0;
  float g=1.0;
  float b=1.0;
  
  float percent;

  char tifName[] = "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.tiff";

  


int main(int argc, char* argv[])
{ 
		
	     //Process Args:
	     short arg = 1;
	     while(arg < argc) {
 
		     if(strcmp(argv[arg],"-idx")==0) {
					arg++;
					indexF=true;
					if(arg < argc)idx=atoi(argv[arg]);		 
					printf("index: %d\n",idx);   	
		     } 

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

		     if(strcmp(argv[arg],"-maxC")==0) {
					arg++;
					if(arg < argc)maxCNits=atof(argv[arg]);		 
					printf("max nits: %f\n",maxCNits);   	
		     }	
		     
		     if(strcmp(argv[arg],"-legal")==0) {
					legal=true;		 
					printf("Flip: %d\n",legal);  		     
		     }		  
		     		     
		     if(strcmp(argv[arg],"-r")==0) {
					arg++;
					if(arg < argc)r=atof(argv[arg]);		 
					printf("r scale factor: %f\n",r);   	
		     }
		     
		     if(strcmp(argv[arg],"-g")==0) {
					arg++;
					if(arg < argc)g=atof(argv[arg]);		 
					printf("g scale factor: %f\n",g);   	
		     }
		     
		     if(strcmp(argv[arg],"-b")==0) {
					arg++;
					if(arg < argc)b=atof(argv[arg]);		 
					printf("b scale factor: %f\n",b);   	
		     }		     
		     

		          		     		     	     
	     arg++;
	     }
	     
 
	 
	 if (legal) {
		 float range = 60160.0 - 4096.0;
		 black = (4096.0 + 0.5);  
		 minValue = (PQ10000_r(minNits/10000.0)*range + 4096.0 + 0.5);  
		 maxValue = (PQ10000_r(maxNits/10000.0)*range + 4096.0 + 0.5);
		 maxCValue = (PQ10000_r(maxCNits/10000.0)*range + 4096.0 + 0.5); 		 
	 } else {
		 black = 0;
		 minValue = (PQ10000_r(minNits/10000.0)*65535.0 + 0.5);  
		 maxValue = (PQ10000_r(maxNits/10000.0)*65535.0 + 0.5); 
		 maxCValue = (PQ10000_r(maxCNits/10000.0)*65535.0 + 0.5); 	 
	 }
	 
	 
	 if(flip)
	 {
		if(value == minValue) {
			value = maxValue;
		} else {
			value = minValue;
		}		 
	 }

  
    // set up  frame name
    
if(indexF) {
	
  printf("Index: %d\n",idx);

  if(legal) {
	  if(flip) {
		  sprintf(tifName,"%03d_STEPS_%.3f__%.3f_LEGAL_FLIP_r_%.3f_g_%.3f_b_%.3f.tiff",idx, minNits,maxNits,r,g,b);
	  } else {
		  sprintf(tifName,"%03d_STEPS_%.3f__%.3f_LEGAL_r_%.3f_g_%.3f_b_%.3f.tiff", idx, minNits,maxNits,r,g,b);
	  } 
   } else  {

	  if(flip) {
		  sprintf(tifName,"%03d_STEPS_%.3f__%.3f_FLIP_r_%.3f_g_%.3f_b_%.3f.tiff", idx, minNits,maxNits,r,g,b);
	  } else {
		  sprintf(tifName,"%03d_STEPS_%.3f__%.3f_r_%.3f_g_%.3f_b_%.3f.tiff", idx, minNits,maxNits,r,g,b);
	  }
   }
   
   
  if(corner) {
	  if(legal) {
		  if(flip) {
			  sprintf(tifName,"%03d_STEPS_%.3f__%.3f_LEGAL_FLIP_CORNER_%.3f_r_%.3f_g_%.3f_b_%.3f.tiff", idx, minNits,maxNits,maxCNits,r,g,b);
		  } else {
			  sprintf(tifName,"%03d_STEPS_%.3f__%.3f_LEGAL_CORNER_%.3f_r_%.3f_g_%.3f_b_%.3f.tiff", idx, minNits,maxNits,maxCNits,r,g,b);
		  } 
	   } else  {
	
		  if(flip) {
			  sprintf(tifName,"%03d_STEPS_%.3f__%.3f_FLIP_CORNER_%.3f_r_%.3f_g_%.3f_b_%.3f.tiff", idx, minNits,maxNits,maxCNits,r,g,b);
		  } else {
			  sprintf(tifName,"%03d_STEPS_%.3f__%.3f_CORNER_%.3f_r_%.3f_g_%.3f_b_%.3f.tiff", idx, minNits,maxNits,maxCNits,r,g,b);
		  }
	   }	  
  }
  
  if(center) {
	  if(legal) {
		  if(flip) {
			  sprintf(tifName,"%03d_STEPS_%.3f__%.3f_LEGAL_FLIP_CENTER_%.3f_r_%.3f_g_%.3f_b_%.3f.tiff", idx, minNits,maxNits,maxCNits,r,g,b);
		  } else {
			  sprintf(tifName,"%03d_STEPS_%.3f__%.3f_LEGAL_CENTER_%.3f_r_%.3f_g_%.3f_b_%.3f.tiff", idx, minNits,maxNits,maxCNits,r,g,b);
		  } 
	   } else  {
	
		  if(flip) {
			  sprintf(tifName,"%03d_STEPS_%.3f__%.3f_FLIP_CENTER_%.3f_r_%.3f_g_%.3f_b_%.3f.tiff", idx, minNits,maxNits,maxCNits,r,g,b);
		  } else {
			  sprintf(tifName,"%03d_STEPS_%.3f__%.3f_CENTER_%.3f_r_%.3f_g_%.3f_b_%.3f.tiff", idx, minNits,maxNits,maxCNits,r,g,b);
		  }
	   }	  
  }	
} else     {	    
  
  if(legal) {
	  if(flip) {
		  sprintf(tifName,"STEPS_%.3f__%.3f_LEGAL_FLIP_r_%.3f_g_%.3f_b_%.3f.tiff", minNits,maxNits,r,g,b);
	  } else {
		  sprintf(tifName,"STEPS_%.3f__%.3f_LEGAL_r_%.3f_g_%.3f_b_%.3f.tiff", minNits,maxNits,r,g,b);
	  } 
   } else  {

	  if(flip) {
		  sprintf(tifName,"STEPS_%.3f__%.3f_FLIP_r_%.3f_g_%.3f_b_%.3f.tiff", minNits,maxNits,r,g,b);
	  } else {
		  sprintf(tifName,"STEPS_%.3f__%.3f_r_%.3f_g_%.3f_b_%.3f.tiff", minNits,maxNits,r,g,b);
	  }
   }
   
   
  if(corner) {
	  if(legal) {
		  if(flip) {
			  sprintf(tifName,"STEPS_%.3f__%.3f_LEGAL_FLIP_CORNER_%.3f_r_%.3f_g_%.3f_b_%.3f.tiff", minNits,maxNits,maxCNits,r,g,b);
		  } else {
			  sprintf(tifName,"STEPS_%.3f__%.3f_LEGAL_CORNER_%.3f_r_%.3f_g_%.3f_b_%.3f.tiff", minNits,maxNits,maxCNits,r,g,b);
		  } 
	   } else  {
	
		  if(flip) {
			  sprintf(tifName,"STEPS_%.3f__%.3f_FLIP_CORNER_%.3f_r_%.3f_g_%.3f_b_%.3f.tiff", minNits,maxNits,maxCNits,r,g,b);
		  } else {
			  sprintf(tifName,"STEPS_%.3f__%.3f_CORNER_%.3f_r_%.3f_g_%.3f_b_%.3f.tiff", minNits,maxNits,maxCNits,r,g,b);
		  }
	   }	  
  }
  
  if(center) {
	  if(legal) {
		  if(flip) {
			  sprintf(tifName,"STEPS_%.3f__%.3f_LEGAL_FLIP_CENTER_%.3f_r_%.3f_g_%.3f_b_%.3f.tiff", minNits,maxNits,maxCNits,r,g,b);
		  } else {
			  sprintf(tifName,"STEPS_%.3f__%.3f_LEGAL_CENTER_%.3f_r_%.3f_g_%.3f_b_%.3f.tiff", minNits,maxNits,maxCNits,r,g,b);
		  } 
	   } else  {
	
		  if(flip) {
			  sprintf(tifName,"STEPS_%.3f__%.3f_FLIP_CENTER_%.3f_r_%.3f_g_%.3f_b_%.3f.tiff", minNits,maxNits,maxCNits,r,g,b);
		  } else {
			  sprintf(tifName,"STEPS_%.3f__%.3f_CENTER_%.3f_r_%.3f_g_%.3f_b_%.3f.tiff", minNits,maxNits,maxCNits,r,g,b);
		  }
	   }	  
  }
}  
  
  
  if(R2020) {
	  sprintf(tifName + strlen(tifName)-5, "_2020.tiff");
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

			
			for (unsigned int pixel = 0; pixel < 3*arraySizeX ;pixel+=3)
			{
				if(pixel > safe*3.0*arraySizeX && pixel < 3*arraySizeX - safe*3.0*arraySizeX)
				{
					value = int(16.0*(pixel-safe*3.0*arraySizeX)/(3*arraySizeX - 2.0*safe*3.0*arraySizeX)) * float(maxValue-minValue)/15.0;
					Line[pixel]   = value;   
					Line[pixel+1] = value;    
					Line[pixel+2] = value;   				
			    } else 
			    {
					Line[pixel]   = maxCValue;   
					Line[pixel+1] = maxCValue;    
					Line[pixel+2] = maxCValue;   
			    }

				if(line < arraySizeY*safe || line > arraySizeY - arraySizeY*safe ) {
				
					value = maxCValue;
							Line[pixel]   = value;   
							Line[pixel+1] = value;    
							Line[pixel+2] = value;   
				}
					//
					// P3D65 to 2020 D65 Matrix
					//
					/*
					P3 D65 to 2020 D65: (transpose to use)
					{ { 0.753833,	0.0457438,	-0.00121034,	0},
					  { 0.198597,	0.941778,	0.0176017,	0},
					  { 0.0475696,	0.0124789,	0.983608,	0},
					  { 0,	0,	0,	1} };
					*/
					if(R2020) {
						
						 if (legal) {
							 float range = 60160.0 - 4096.0;
							 
							float red, grn, blu;
							float redLin = PQ10000_f((Line[pixel]-4096.0)/range);
							float grnLin = PQ10000_f((Line[pixel+1]-4096.0)/range);
							float bluLin = PQ10000_f((Line[pixel+2]-4096.0)/range);
							
							redLin = redLin*r;
							grnLin = grnLin*g;
							bluLin = bluLin*b;
										
						    red   = 0.753833*redLin +\
									0.198597*grnLin +\
									0.0475696*bluLin;
	
						    grn =   0.0457438*redLin +\
									0.941778*grnLin +\
									0.0124789*bluLin;
														
						    blu =  -0.00121034*redLin +\
									0.0176017*grnLin +\
									0.983608*bluLin;

							
							if(blu < 0.0)blu = 0;
							
						    Line[pixel]   = (unsigned short)(PQ10000_r(red)*range+0.5) + 4096;   
							Line[pixel+1] = (unsigned short)(PQ10000_r(grn)*range+0.5) + 4096;    
							Line[pixel+2] = (unsigned short)(PQ10000_r(blu)*range+0.5) + 4096;
													 
						 } else {
							float red, grn, blu;
							float redLin = PQ10000_f(Line[pixel]/65535.0);
							float grnLin = PQ10000_f(Line[pixel+1]/65535.0);
							float bluLin = PQ10000_f(Line[pixel+2]/65535.0);
							
							redLin = redLin*r;
							grnLin = grnLin*g;
							bluLin = bluLin*b;
							
						    red   = 0.753833*redLin +\
									0.198597*grnLin +\
									0.0475696*bluLin;
	
						    grn =   0.0457438*redLin +\
									0.941778*grnLin +\
									0.0124789*bluLin;
														
						    blu =  -0.00121034*redLin +\
									0.0176017*grnLin +\
									0.983608*bluLin;
									
						
							if(blu < 0.0)blu = 0;
							
						    Line[pixel]   = (unsigned short)(PQ10000_r(red)*65535.0+0.5);   
							Line[pixel+1] = (unsigned short)(PQ10000_r(grn)*65535.0+0.5);     
							Line[pixel+2] = (unsigned short)(PQ10000_r(blu)*65535.0+0.5);    
						
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
