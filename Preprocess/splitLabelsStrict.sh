# ! /bin/bash

#Extracts all masks, converts them to 2mm, substracts everything but the mask of interest and gives back such mask
initialNum=0
finalNum=90
newSize=2
complete=0

inputFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles
inputFile=LABL_brain_Barney.nii.gz
outFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Dogs/LabelsNums2mmStrict
workFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Dogs/LabelsNums2mmStrict/working

if [ "$complete" == "1" ]; then
	for labelNum in $(seq ${initialNum} ${finalNum})
	do
		lowerThr=$((${labelNum} - 1))
		printf -v labelStr "%02d" ${labelNum} #creates the padded number of mask
		echo ${labelStr}
		fileName=${labelStr}.nii.gz
		fslmaths ${inputFolder}/${inputFile} -uthr ${labelNum} upTo.nii.gz
		fslmaths ${inputFolder}/${inputFile} -uthr ${lowerThr} lower.nii.gz
		fslmaths upTo.nii.gz -sub lower.nii.gz testImg.nii.gz
		fslmaths testImg.nii.gz -bin ${workFolder}/${fileName}.nii.gz
		flirt -in ${workFolder}/${fileName}.nii.gz -ref ${workFolder}/${fileName}.nii.gz -out ${workFolder}/${fileName}.nii.gz -applyisoxfm ${newSize}
		fslmaths ${workFolder}/${fileName}.nii.gz -bin ${workFolder}/${fileName}.nii.gz

	done
	rm upTo.nii.gz
	rm lower.nii.gz
	rm testImg.nii.gz
fi


for labelOfInterest in $(seq ${initialNum} ${finalNum})
do
	echo ${labelOfInterest}
	printf -v labelOfInterestS "%02d" ${labelOfInterest} #creates the padded number of mask

	cp ${workFolder}/00.nii.gz ${workFolder}/toRemove.nii.gz
	for labelNum in $(seq ${initialNum} ${finalNum})
	do
		if [ "$labelNum" != "$labelOfInterest" ]; then
			printf -v labelToRemove "%02d" ${labelNum} #creates the padded number of mask
			fslmaths ${workFolder}/toRemove.nii.gz -add ${workFolder}/${labelToRemove} ${workFolder}/toRemove.nii.gz
		fi
	done
	fslmaths ${workFolder}/toRemove.nii.gz -bin ${workFolder}/toRemove.nii.gz
	fslmaths ${workFolder}/${labelOfInterestS} -sub ${workFolder}/toRemove.nii.gz ${outFolder}/${labelOfInterestS}
	fslmaths ${outFolder}/${labelOfInterestS} -bin ${outFolder}/${labelOfInterestS}
done
