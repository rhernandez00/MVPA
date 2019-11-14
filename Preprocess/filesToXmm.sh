#!/bin/bash


newSize=2
echo files will be resized to: ${newSize}
#filesFolder=/media/sf_Google_Drive/Faces_Hu/Eszter
filesFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Dogs/Labels/
#filesFolder=
echo files folder ${filesFolder}


#outputFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Dogs/Labels2mm/subcortical
outputFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Dogs/Labels2mm/
#outputFolder=/media/sf_Google_Drive/Faces_Hu/Eszter2
#mkdir ${outputFolder}
#echo output folder ${outputFolder} created


cd ${filesFolder}
#maskList=("b_fullbrain.nii.gz")
maskList=("b_OccipitoTemporal.nii.gz" "R_OccipitoTemporal.nii.gz" "L_OccipitoTemporal.nii.gz")
#maskList=($(ls *.nii.gz))

for maskName in "${maskList[@]}"
do
	echo ${maskName}
	flirt -in ${maskName} -ref ${maskName} -out ${outputFolder}/${maskName} -applyisoxfm ${newSize}
	fslmaths ${outputFolder}/${maskName} -bin ${outputFolder}/${maskName}
	#fslmaths ${outputFolder}/${maskName} -mul /media/sf_Google_Drive/Faces_Hu/CommonFiles/barneyMask ${outputFolder}/${maskName}
done


