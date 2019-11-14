#!/bin/bash
proyect=$1
initialSub=$2
runBet=false
case "${proyect}" in
	ProsodyFSL)
		echo ProsodyFSL
		conversionMatrix=A02std.mat
		experiment=ProsodyFSL
		dataFolder=/media/sf_data
		referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz
		folderOut=/media/sf_data
		declare -a runs=("001" "002" "003" "004")
		;;
	ProsodyNoFM)
		echo ProsodyNoFM
		conversionMatrix=A02std.mat
		experiment=NoFM
		dataFolder=/media/sf_data/Prosody
		referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz
		folderOut=/media/sf_data/Prosody
		declare -a runs=("001" "002" "003" "004")
		;;
	ComplexD)
		echo ComplexD
		conversionMatrix=A02std.mat
		experiment=ComplexD
		dataFolder=/media/sf_data/Complex
		referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz
		folderOut=/media/sf_data/Complex
		declare -a runs=("001" "002" "003" "004" "005" "006")
		runBet=true
#		declare -a runs=("005" "006")
		;;

	ComplexH)
		echo ComplexH
		conversionMatrix=A02std.mat
		experiment=ComplexH
		dataFolder=/media/sf_data/Complex
		referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/MNI152_T1_2mm_brain.nii.gz
		folderOut=/media/sf_data/Complex
		declare -a runs=("001" "002" "003" "004" "005" "006")
		;;
	FacesH)
		echo FacesH
		conversionMatrix=A02std.mat
		experiment=FacesH
		dataFolder=/media/sf_data/Faces
		referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/MNI152_T1_2mm_brain.nii.gz
		folderOut=/media/sf_data/Faces
		declare -a runs=("001" "002" "003" "004" "005" "006")
		;;
	FacesD)
		echo FacesD
		conversionMatrix=A02std.mat
		experiment=FacesD
		dataFolder=/media/sf_data/Faces
		referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz
		folderOut=/media/sf_data/Faces
		declare -a runs=("001" "002" "003" "004" "005" "006")
		;;
	Objects)
		echo Objects
		conversionMatrix=A02std.mat
		experiment=Objects
		dataFolder=/media/sf_data/Objects
		referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/MNI152_T1_2mm_brain.nii.gz
		folderOut=/media/sf_data/Objects
		declare -a runs=("001" "002" "003" "004" "005" "006" "007" "008" "009" "010" "011" "012")
		;;
	CEVA)
		echo CEVA
		conversionMatrix=A02std.mat
		experiment=CEVA
		dataFolder=/media/sf_data/CEVA
		referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz
		folderOut=/media/sf_data/CEVA
		declare -a runs=("001")
		;;
	Diana)
		echo Diana
		conversionMatrix=A02std.mat
		experiment=Diana
		dataFolder=/media/sf_data
		referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz
		folderOut=/media/sf_data/Diana
		declare -a runs=("001" "002" "003" "004")
		;;
	SST)
		echo SST
		conversionMatrix=A02std.mat
		experiment=SST
		dataFolder=/media/sf_data
		referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz
		folderOut=/media/sf_data/SST
		declare -a runs=("001" "002")
		;;
	*)
		echo Wrong proyect
		exit 1
esac



finalSub=${initialSub}


#experiment=Faces_HuMVPA
#experiment=facesHm
#experiment=facesDog
#dataFolder=/media/sf_Google_Drive
#conversionMatrix=A02std2mm.mat
#referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz
#referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/brain_TPL_brain_Barney.nii.gz
#folderOut=/media/sf_Google_Drive







for i in $(seq ${initialSub} ${finalSub})
do
	echo ${i}
	printf -v subN "%03d" ${i} #creates the padded number of run
	subjects+=("sub"${subN})

done




#declare -a subjects=("sub006")
declare -a tasks=("1")


#declare -a runs=("001")




for task in "${tasks[@]}"
do
	echo task ${task}
	for sub in "${subjects[@]}"
	do
		for run in "${runs[@]}"
		do
			inputFile=${dataFolder}/${experiment}/data/${sub}/BOLD/task00${task}_run${run}/BOLD.nii.gz
			mkdir -p ${folderOut}/${experiment}STD/data/${sub}/BOLD/task00${task}_run${run}/
			fileOut=${folderOut}/${experiment}STD/data/${sub}/BOLD/task00${task}_run${run}/BOLD.nii.gz
			conversionMatrixF=${dataFolder}/${experiment}/data/${sub}/masks/${conversionMatrix}
			tmpFile=${dataFolder}/${experiment}/data/${sub}/masks/tmp.nii.gz
			cp ${inputFile} ${tmpFile}
echo ${inputFile}
echo ${fileOut}
			if [ ${runBet} = true ] ; then
				echo performing BET
				fslmaths ${tmpFile} -mul ${dataFolder}/${experiment}/data/${sub}/masks/brain_mask_m_BOLD.nii.gz ${tmpFile}
			fi
			flirt -in ${tmpFile} -ref ${referenceFile} -applyxfm -init ${conversionMatrixF} -out ${fileOut}
			rm ${tmpFile}
		done
	done
done
