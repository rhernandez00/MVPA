# ! /bin/bash

initialNum=1
finalNum=90


inputFolder=/media/sf_Google_Drive/Faces_Hu/Labels
inputFile=LABL_brain_Barney.nii
outFolder=/media/sf_Google_Drive/Faces_Hu/Labels

for labelNum in $(seq ${initialNum} ${finalNum})
do
	lowerThr=$((${labelNum} - 1))
	fileName=${labelNum}.nii.gz
	fslmaths ${inputFolder}/${inputFile} -uthr ${labelNum} upTo.nii.gz
	fslmaths ${inputFolder}/${inputFile} -uthr ${lowerThr} lower.nii.gz
	fslmaths upTo.nii.gz -sub lower.nii.gz testImg.nii.gz
	fslmaths testImg.nii.gz -bin ${outFolder}/${fileName}.nii.gz

done
rm upTo.nii.gz
rm lower.nii.gz
rm testImg.nii.gz
