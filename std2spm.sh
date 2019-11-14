#!/bin/bash



#std2spm=/media/sf_Google_Drive/Faces_Hu/CommonFiles/SPM/dog_std2spm.mat
#referenceImage=/media/sf_Google_Drive/Faces_Hu/CommonFiles/SPM/dog_spm.nii.gz

std2spm=/media/sf_Google_Drive/Faces_Hu/CommonFiles/SPM/Hum_std2spm.mat
referenceImage=/media/sf_Google_Drive/Faces_Hu/CommonFiles/SPM/Hum_spm.nii.gz

#maskFolder=/media/sf_Google_Drive/Results/Faces/RSA_groupByT2/Hum
#maskFolder=/media/sf_Google_Drive/Results/Faces/RSAFinalResults/Dog/DirectComparison
maskFolder=/media/sf_Google_Drive/Faces_Hu/figures/spheres/Hum/1
cd ${maskFolder}
#folderList=($(ls ))
#folderList=("LmTg")
#maskList=("reg2_t_Thr0001Corrected" "reg3_t_Thr0001Corrected" "reg4_t_Thr0001Corrected" "reg5_t_Thr0001Corrected")
#for folder in "${folderList[@]}"
#do
#	echo ${folder}

#	cd ${folder}
	maskList=($(ls *.nii.gz))
	for maskName in "${maskList[@]}"
	do
		maskNameOut=spm_${maskName}
		echo transforming mask ${maskName} 
		flirt -in ${maskFolder}/${folder}/${maskName} -ref ${referenceImage} -applyxfm -init ${std2spm} -out ${maskFolder}/${folder}/${maskNameOut}

	done
#	cd ..
#done







