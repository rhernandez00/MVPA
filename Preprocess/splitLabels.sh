# ! /bin/bash

initialNum=0
finalNum=99


inputFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles
inputFile=LABL_Barney2mmImproved.nii.gz
#inputFile=HarvardOxford-cortl-maxprob-thr0-2mm.nii.gz
#inputFile=Datta_LABL.nii.gz
outFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Dogs/LabelsNums2mm
#outFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Harvard/LabelsNums
#outFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Dogs/DattaNums


for labelNum in $(seq ${initialNum} ${finalNum})
do
	lowerThr=$((${labelNum} - 1))
	echo ${labelNum}
	printf -v labelStr "%02d" ${labelNum} #creates the padded number of run
	fileName=${labelStr}.nii.gz
	fslmaths ${inputFolder}/${inputFile} -uthr ${labelNum} upTo.nii.gz
	fslmaths ${inputFolder}/${inputFile} -uthr ${lowerThr} lower.nii.gz
	fslmaths upTo.nii.gz -sub lower.nii.gz testImg.nii.gz
	fslmaths testImg.nii.gz -bin ${outFolder}/${fileName}.nii.gz

done
rm upTo.nii.gz
rm lower.nii.gz
rm testImg.nii.gz
