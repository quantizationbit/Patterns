#!/bin/bash

set -x

cd animation

# $1 must be nit range to test (e.g 1000, 2000, etc..)
#echo "Range: "$1
sleep 3


c1=0
CMax=6

for filename in CMP*-*log ; do
#for filename in CMP*$1-*log ; do
#for filename in CMP16-StEM-1000-nk10b-10k10b-10k12b.log; do




rm -fv X.data Y.data Z.data

sed -n -e /"PQ Ave"/p -e /"#10k16b-"/p $filename | sed -n -e /sigma_red/p -e /"#10k16b-"/p | sed s/"#10k16b-".*//g | sed -e s/"pixels, PQ Ave".*//g | sed -e s/"sigma_red".// | sed -e s/"] ="// | sed -e s/"self_relative =".*"(".*" ="// | sed s/" for"// | sed s/"pixels".*//  | tee X.data

sed -n -e /"PQ Ave"/p -e /"#10k16b-"/p $filename | sed -n -e /sigma_grn/p -e /"#10k16b-"/p | sed s/"#10k16b-".*//g | sed -e s/"pixels, PQ Ave".*//g | sed -e s/"sigma_grn".// | sed -e s/"] ="// | sed -e s/"self_relative =".*"(".*" ="// | sed s/" for"// | sed s/"pixels".*//  | tee Y.data

sed -n -e /"PQ Ave"/p -e /"#10k16b-"/p $filename | sed -n -e /sigma_blu/p -e /"#10k16b-"/p | sed s/"#10k16b-".*//g | sed -e s/"pixels, PQ Ave".*//g | sed -e s/"sigma_blu".// | sed -e s/"] ="// | sed -e s/"self_relative =".*"(".*" ="// | sed s/" for"// | sed s/"pixels".*//  | tee Z.data

# remove .log
export filename="${filename%.log}"

# use -p if want plots to stay up
gnuplot ../P6plot.gp

if [ $c1 -le $CMax ]; then
  (convert -alpha off -density 300 \
    $filename".eps" -resize 1440x1080  -quality 50 $filename".png"; \
  rm -fv $filename".eps") &


c1=$[$c1 +1]
fi

if [ $c1 = $CMax ]; then
for job in `jobs -p`
do
echo $job
wait $job 
done
c1=0
fi



done


for job in `jobs -p`
do
echo $job
wait $job 
done

cd ..

exit





