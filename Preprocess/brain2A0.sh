
#!/bin/bash
workingFolder=/media/sf_Google_Drive/DeleteProcessDianaProsodia/DianaSeptember2

cd ${workingFolder}/ToProcess
#fileName=Akira_1
filesToCut=($(ls ))
#filesToCut=("Odin_2.nii" "Odin_3.nii" "Odin_4.nii")

for fileName2 in "${filesToCut[@]}"
do
fileName=${fileName2::-7}

echo ${fileName}


flirt -in ${workingFolder}/A0/brain_${fileName}.nii.gz -ref ${workingFolder}/A0/${fileName}.nii.gz -out ${workingFolder}/A0/brain2${fileName}.nii.gz -omat ${workingFolder}/A0/brain2${fileName}.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -2D -dof 12  -interp trilinear

flirt -in ${workingFolder}/A0/${fileName}_brain_mask.nii.gz -applyxfm -init ${workingFolder}/A0/brain2${fileName}.mat -out ${workingFolder}/A0/${fileName}_brainMask.nii.gz -paddingsize 0.0 -interp trilinear -ref ${workingFolder}/A0/${fileName}.nii.gz

fslmaths ${workingFolder}/toProcess/${fileName} -mul ${workingFolder}/A0/${fileName}_brainMask ${workingFolder}/processed/${fileName}_BET



fslview ${workingFolder}/processed/${fileName}_BET
wait

done
