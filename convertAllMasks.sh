#!/bin/bash
subjNum=$1
printf -v subjS "%03d" ${subjNum}
sub=sub${subjS}
echo ${sub}

experiment=Faces_HuMVPA
maskFolder=/media/sf_Google_Drive/Faces_Hu/Labels
anatomicName=A0.nii.gz
dataFolder=/media/sf_Google_Drive

referenceImage=${dataFolder}/${experiment}/data/${sub}/masks/brain_m_BOLD.nii.gz

cd ${maskFolder}
maskList=($(ls *.nii.gz))
for maskName in "${maskList[@]}"
do
	maskNameOut=${maskName}
	echo transforming mask ${maskName}
	flirt -in ${maskFolder}/${maskName} -ref ${referenceImage} -applyxfm -init ${dataFolder}/${experiment}/data/${sub}/masks/std2A0.mat -out ${dataFolder}/${experiment}/data/${sub}/masks/orig/${maskNameOut}

	echo binarizing mask...
	fslmaths ${dataFolder}/${experiment}/data/${sub}/masks/orig/${maskNameOut} -bin ${dataFolder}/${experiment}/data/${sub}/masks/orig/${maskNameOut}
done







