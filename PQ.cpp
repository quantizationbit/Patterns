/*
 * PQ.cpp
 * 
 * Copyright 2017 Quantization Bit <quantizationbit@gmail.com>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 * 
 * 
 */


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




int main(int argc, char* argv[])
{ 

	     //Process Args:
	     short arg = 1;
         float input =0.0;
	     while(arg < argc) {
 

		     if(strcmp(argv[arg],"-EOTF")==0) {
					arg++;
					if(arg < argc)input=atof(argv[arg]);		 
		     }
		     
		     if(strcmp(argv[arg],"-IEOTF")==0) {
					arg++;
					if(arg < argc)input=-1.0*atof(argv[arg]);		 
		     }	


		
		    arg++;
	     }
         
         if(input < 0. ) {
            printf ("%f",PQ10000_r(-1.0*input/10000.0));
        } else if (input == 0. ) {
            printf ("%f",0.0);
        } else if (input > 0.) {
            printf ("%f",10000.0 * PQ10000_f(input));
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

