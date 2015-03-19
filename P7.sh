set -x










#RED, BLUE, GREEN, YELLOW, CYAN, MAGENTA 
#10% 25% 50% 75% 90% 100% 


#32 64 96 128 160 192 224 256 288 320 352 384 416 448 480 512 543 575 607 639 671 703 735 767 799 831 863 895 927 959 991 1023 

#
# Make Color Patches
#

rm -rfv P3
mkdir P3
cd P3

colors=( 102 256 512 768 922 1023)

for value in "${colors[@]}"; do
 
../pattern7 -r $value -g 0 -b 0 -percent 10
../pattern7 -r 0 -g 0 -b $value -percent 10
../pattern7 -r 0 -g 0 -b $value -percent 10
../pattern7 -r $value -g $value -b 0 -percent 10
../pattern7 -r 0 -g $value -b $value -percent 10
../pattern7 -r $value -g 0 -b $value -percent 10

../pattern7 -r $value -g 0 -b 0 -percent 33
../pattern7 -r 0 -g 0 -b $value -percent 33
../pattern7 -r 0 -g 0 -b $value -percent 33
../pattern7 -r $value -g $value -b 0 -percent 33
../pattern7 -r 0 -g $value -b $value -percent 33
../pattern7 -r $value -g 0 -b $value -percent 33

../pattern7 -r $value -g 0 -b 0 -percent 100
../pattern7 -r 0 -g 0 -b $value -percent 100
../pattern7 -r 0 -g 0 -b $value -percent 100
../pattern7 -r $value -g $value -b 0 -percent 100
../pattern7 -r 0 -g $value -b $value -percent 100
../pattern7 -r $value -g 0 -b $value -percent 100

done  

cd ..


#
# Make D65 patches
#
rm -rfv D65
mkdir D65
cd D65

D65=(32 64 96 128 160 192 224 256 288 320 352 384 416 448 480 512 \
     543 575 607 639 671 703 735 767 799 831 863 895 927 959 991 1023 )

for value in "${D65[@]}"; do
 
../pattern7 -r $value -g $value -b $value -percent 10
../pattern7 -r $value -g $value -b $value -percent 33
../pattern7 -r $value -g $value -b $value -percent 100


done   


cd ..
exit


