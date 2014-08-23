#!/usr/bin/gnuplot -persist
#
#    
#    	G N U P L O T
#    	Version 4.6 patchlevel 3    last modified 2013-04-12 
#    	Build System: Linux x86_64
#    
#    	Copyright (C) 1986-1993, 1998, 2004, 2007-2013
#    	Thomas Williams, Colin Kelley and many others
#    
#    	gnuplot home:     http://www.gnuplot.info
#    	faq, bugs, etc:   type "help FAQ"
#    	immediate help:   type "help"  (plot window: hit 'h')

unset logscale
set size ratio (3./4.)
set pointsize 0.7
set logscale x  
set logscale y2 
set xtics mirror font "Calibri, 12"
set ytics nomirror font "Calibri, 12"
set ytics 0,1.0  norangelimit
set y2tics nomirror font "Calibri, 10"
set mxtics 5
set mytics 5
set my2tics 0
set xlabel "Luminance (for Y) [nits]\nXZ [unitless]" font "Calibri, 14"
set xrange [ 0.00100000 : 10000.0 ] noreverse nowriteback
set ylabel "one sigma as % of average at f-stop\n(%)" font "Calibri, 14"
set yrange [ 0.00000 : 8.00000 ] noreverse nowriteback
set format y "%0.1f"
set y2label "Pixel Count\n(from Y data)" font "Calibri, 12"
set y2range [1:1000000]

set grid

name=system("echo $filename") 
set title name font "Calibri, 16"
set style line 1 linewidth 1.5 lt 1 # red
set style line 2 linewidth 1.5 lt 2 # green
set style line 3 linewidth 1.5 lt 3 # blue

set loadpath 
set fontpath 
set psdir
GNUTERM = "x11"

plot \
  "X.data" u 3:($4 >=10  ? (100.*$2/$3) : 1/0) title "X" w lp ls 1, \
  "Y.data" u 3:($4 >=10  ? (100.*$2/$3) : 1/0) title "Y" w lp ls 2, \
  "Z.data" u 3:($4 >=10  ? (100.*$2/$3) : 1/0) title "Z" w lp ls 3, \
  "Y.data" u 3:4 title "Pixels" w lines axes x1y2 lt 0

set term eps size 8in, 6in
set output name.".eps"
replot
#    EOF
