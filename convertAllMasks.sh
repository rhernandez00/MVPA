#!/bin/bash
subjNum=$2
proyect=$1

case "${proyect}" in
	ProsodyFSL)
		echo ProsodyFSL
		std2A0=std2A0.mat
		experiment=ProsodyFSL
		maskFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Dogs/Labels
		dataFolder=/media/sf_data
		;;
	SST)
		echo SST
		std2A0=std2A0.mat
		experiment=SST
		maskFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Dogs/Labels
		dataFolder=/media/sf_data

		;;
	CEVA)
		echo CEVA
		std2A0=std2A0.mat
		experiment=CEVA
		maskFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Dogs/Labels/others
		dataFolder=/media/sf_data

		;;

	*)
		echo Wrong proyect
		exit 1
esac

#for subjNum in $(seq 1 32)
#do

	printf -v subjS "%03d" ${subjNum}
	sub=sub${subjS}
	echo ${sub}
	referenceImage=${dataFolder}/${experiment}/data/${sub}/masks/m_BOLD.nii.gz

#	experiment=Faces_HuMVPA

#	experiment=prosody
	#experiment=HmFaces

#	maskFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Dogs/Regs
#	maskFolder=/media/sf_Google_Drive/Results/DogEmotionsNeg/res
#	maskFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Dogs/Datta
	#maskFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Harvard
#	dataFolder=/media/sf_Google_Drive
#	dataFolder=/media/sf_Google_Drive/usr/share/data


#	referenceImage=${dataFolder}/${experiment}/data/sub002/masks/SPM.nii.gz
#	referenceImage=${dataFolder}/${experiment}/data/${sub}/masks/brain_m_BOLD.nii.gz
#	referenceImage=${dataFolder}/${experiment}/data/${sub}/masks/meanfct.nii.gz
#	referenceImage=${dataFolder}/${experiment}/data/${sub}/masks/A0.nii.gz
	maskFolderName='orig'

	cd ${maskFolder}
	#declare -a maskList=("b_fullbrain.nii.gz")
	maskList=($(ls *.nii.gz))
#	maskList=("b_max1.nii.gz" "b_max2.nii.gz")
	for maskName in "${maskList[@]}"
	do

		maskNameOut=${maskName}
		echo transforming mask ${maskName} 
		flirt -in ${maskFolder}/${maskName} -ref ${referenceImage} -applyxfm -init ${dataFolder}/${experiment}/data/${sub}/masks/${std2A0} -out ${dataFolder}/${experiment}/data/${sub}/masks/${maskFolderName}/${maskNameOut}

		echo binarizing mask...
		fslmaths ${dataFolder}/${experiment}/data/${sub}/masks/${maskFolderName}/${maskNameOut} -bin ${dataFolder}/${experiment}/data/${sub}/masks/${maskFolderName}/${maskNameOut}
	done
#done







