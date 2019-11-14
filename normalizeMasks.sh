# ! /bin/bash

newSize=2

experiment=facesDog
dataFolder=/media/sf_data

conversionMatrix=/home/brain/Desktop/Normalizing/BOLDstd2Barney2mm.mat
referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Barney2mm.nii.gz
folderOut=/media/sf_data


cd /media/sf_Google_Drive/Faces_Hu/Labels/
fileList=($(ls ))

for fileName in "${fileList[@]}"
do

	echo ${fileName} 
	fileOut=/home/brain/Desktop/LabelsConverted/${fileName}
	flirt -in ${fileName} -ref ${fileName} -out ${fileOut} -applyisoxfm ${newSize}
	fslmaths ${fileOut} -bin ${fileOut}
#		flirt -in ${fileOut} -ref ${referenceFile} -applyxfm -init ${conversionMatrix} -out ${dataFolder}/${experiment}STD/data/${subj}/masks/orig/${fileName}
done


