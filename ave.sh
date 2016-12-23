set +x 

rm mean.log

for filename in animation/*C.tiff ; do

$EDRHOME/Tools/average/average -i $filename | tee -a mean.log

done
