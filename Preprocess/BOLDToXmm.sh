#!/bin/bash


experiment=facesDogSTD
dataFolder=/media/sf_data
newSize=1




referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain.nii.gz

folderOut=/media/sf_data

initialSub=11
finalSub=20




for i in $(seq ${initialSub} ${finalSub})
do
	echo ${i}
	printf -v subN "%03d" ${i} #creates the padded number of run
	subjects+=("sub"${subN})

done




#declare -a subjects=("sub001")
declare -a tasks=("1")
declare -a runs=("001" "002" "003" "004" "005" "006")
#declare -a runs=("001")




for task in "${tasks[@]}"
do
	echo task ${task}
	for subj in "${subjects[@]}"
	do
		for run in "${runs[@]}"
		do

			inputFile=${dataFolder}/${experiment}/data/${subj}/BOLD/task00${task}_run${run}/BOLD.nii.gz
			fileOut=${folderOut}/${experiment}${newSize}mm/data/${subj}/BOLD/task00${task}_run${run}/BOLD.nii.gz
			echo ${inputFile}

			flirt -in ${inputFile} -ref ${inputFile} -out ${fileOut} -applyisoxfm ${newSize}
				
		done
	done
done
